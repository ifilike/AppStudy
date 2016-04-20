# -*- coding: utf-8 -*-
#
# sourcetree_hg_checklink: customise checklink() to create an ignorable 
#                          file event pattern
# 
# The problem with the standard util.checklink() is that it creates files 
# called hg-checklink-BLAH in source folders, and because Mac's FSEvents
# system only reports what directory a change was encountered in, we can't
# ignore them unless they're in a directory we can identify. So this can 
# cause unnecessary refreshes which themselves might create more temp files.
#
# Our solution is to force these into the .hg folder where they can be ignored
# by our existing FSEvent system which only looks out for specific changes

# Copyright (c) 2014 Atlassian
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

import mercurial.util
import os

old_checklink = mercurial.util.checklink

############################################################
def sourcetree_checklink(path):
    # Just add a .hg prefix, this is used for the base path anyway
    return old_checklink(os.path.join(path, ".hg"))
    

mercurial.util.checklink = sourcetree_checklink



