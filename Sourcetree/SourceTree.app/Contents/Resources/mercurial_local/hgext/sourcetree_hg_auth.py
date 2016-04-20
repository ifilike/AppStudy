# -*- coding: utf-8 -*-
#
# sourcetree_hg_auth: integrate with SourceTree authentication system
#
# Copyright (c) 2013 Atlassian
#
# Elements based on:
# mercurial_keyring: save passwords in password database
#
# Copyright (c) 2009 Marcin Kasperski <Marcin.Kasperski@mekk.waw.pl>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

from mercurial import util
from mercurial.i18n import _
try:
    from mercurial.url import passwordmgr
except:
    from mercurial.httprepo import passwordmgr
from mercurial import mail
from urllib2 import AbstractBasicAuthHandler, AbstractDigestAuthHandler
from urlparse import urlparse
import urllib2
import os
from subprocess import Popen, PIPE

############################################################

def monkeypatch_method(cls,fname=None):
    def decorator(func):
        local_fname = fname
        if local_fname is None:
            local_fname = func.__name__
        setattr(func, "orig", getattr(cls, local_fname, None))
        setattr(cls, local_fname, func)
        return func
    return decorator

############################################################

def _debug(ui, msg):
    ui.debug("[SourceTreeAuth] " + msg + "\n")

def _debug_reply(ui, msg, url, user, pwd):
    _debug(ui, "%s. Url: %s, user: %s, passwd: %s" % (
                                                      msg, url, user, pwd and '*' * len(pwd) or 'not set'))


############################################################

class HTTPPasswordHandler(object):
    """
        Actual implementation of password handling.
        
        Object of this class is bound as passwordmgr attribute.
        """
    def __init__(self):
        self.pwd_cache = {}
        self.last_reply = None
    
    def find_auth(self, pwmgr, realm, authuri, req):
        """
            SSH_ASKPASS redirection
            """
        ui = pwmgr.ui
        
        _debug(ui, "Using SourceTree authentication integration")
        
        # Example params:
        # realm: Bitbucket.org HTTP
        # authuri: https://bitbucket.org/sinbad/sourcetree?cmd=capabilities
        # Note lack of username in authuri even though it was there
        # Would have to get user from somewhere else in subrepo
        
        # Strip arguments to get actual remote repository url.
        base_url = self.canonical_url(authuri)
        
        _debug(ui, 'base_url: ' + base_url)
        
        # Extracting possible username (or password)
        # stored directly in repository url
        user, pwd = urllib2.HTTPPasswordMgrWithDefaultRealm.find_user_password(pwmgr, realm, authuri)
        if user and pwd:
            _debug_reply(ui, _("Auth data found in repository URL"),base_url, user, pwd)
            return user, pwd
    
        if user:
            _debug(ui, 'User found in URL: ' + user)

        sshaskpass = os.environ.get('SSH_ASKPASS')
        display = os.environ.get('DISPLAY')

        if sshaskpass is None or display is None:
            return find_user_password.orig(pwmgr, realm, authuri)


        # Let's try to get the hostname from the url
        # This will work with subrepo calls that way
        parsed_url = urlparse(authuri)
        hostname = parsed_url.hostname

        if hostname:
            _debug(ui, 'Host name found in URL: ' + hostname)

        # All the smarts are in AskPass, all we have to do is call it

        if user is None:
            # Is user in the environment?
            user = os.environ.get('AUTH_USERNAME')

        if user is None:
            # OK, we have to get user from AskPass
            # This will prompt for pwd at same time & save so only one user prompt
            if hostname:
                prompt = 'Username for \'' + hostname + ':'
            else:
                prompt = 'Username:'

            # must define AUTH_HOSTNAME in AskPass env
            procenv = os.environ.copy()
            if hostname:
                procenv['AUTH_HOSTNAME'] = hostname

            proc = Popen([sshaskpass, prompt], env=procenv, stdout=PIPE, stderr=PIPE)
            output,erroutput = proc.communicate()

            if proc.returncode != 0:
                ui.status('Error calling askpass for username: ' + erroroutput)
                return find_user_password.orig(pwmgr, realm, authuri)

            # trim off any \r\n
            user = output.rstrip('\r\n')

            _debug(ui, 'Got username from askpass: ' + user)

        # Now get password
        prompt = 'Password:'
        
        # must define AUTH_HOSTNAME and AUTH_USERNAME in AskPass env
        procenv = os.environ.copy()
        procenv['AUTH_USERNAME'] = user
        if hostname:
            procenv['AUTH_HOSTNAME'] = hostname

        proc = Popen([sshaskpass, prompt], env=procenv, stdout=PIPE, stderr=PIPE)
        output,erroutput = proc.communicate()

        if proc.returncode != 0:
            ui.status('Error calling askpass for password: ' + erroroutput)
            return find_user_password.orig(pwmgr, realm, authuri)

        # trim off any \r\n
        password = output.rstrip('\r\n')

        _debug(ui, 'Got password from askpass: ' + ('*' * len(password)))

        return user,password
    
    
    def canonical_url(self, authuri):
        """
            Strips query params from url. Used to convert urls like
            https://repo.machine.com/repos/apps/module?pairs=0000000000000000000000000000000000000000-0000000000000000000000000000000000000000&cmd=between
            to
            https://repo.machine.com/repos/apps/module
            """
        parsed_url = urlparse(authuri)
        return "%s://%s%s" % (parsed_url.scheme, parsed_url.netloc,
                              parsed_url.path)

############################################################

@monkeypatch_method(passwordmgr)
def find_user_password(self, realm, authuri):
    """
        keyring-based implementation of username/password query
        for HTTP(S) connections
        
        Passwords are saved in gnome keyring, OSX/Chain or other platform
        specific storage and keyed by the repository url
        """
    # Extend object attributes
    if not hasattr(self, '_pwd_handler'):
        self._pwd_handler = HTTPPasswordHandler()
    
    if hasattr(self, '_http_req'):
        req = self._http_req
    else:
        req = None

    return self._pwd_handler.find_auth(self, realm, authuri, req)

@monkeypatch_method(AbstractBasicAuthHandler, "http_error_auth_reqed")
def basic_http_error_auth_reqed(self, authreq, host, req, headers):
    self.passwd._http_req = req
    try:
        return basic_http_error_auth_reqed.orig(self, authreq, host, req, headers)
    finally:
        self.passwd._http_req = None

@monkeypatch_method(AbstractDigestAuthHandler, "http_error_auth_reqed")
def digest_http_error_auth_reqed(self, authreq, host, req, headers):
    self.passwd._http_req = req
    try:
        return digest_http_error_auth_reqed.orig(self, authreq, host, req, headers)
    finally:
        self.passwd._http_req = None
