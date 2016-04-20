"""commands to support Driessen's branching model
An implementation of Vincent Driessen's branching model for Mercurial
"""
#
# Authoring history of this fork:
#  o Jan 03 2011 - Mar 18 2011  Original version by yinwm <yinweiming@gmail.com>
#  o Jun 29 2011 -              Rewritten by Yujie Wu <yujie.wu2@gmail.com>



import os
import sys
import copy
import ConfigParser
import mercurial

from mercurial import util, extensions, error
from mercurial.node import short
from mercurial.i18n import _



###############################################################################################################################
# Let's use 128 char width.
# It is silly to stick to the 80-char rule.
#
#
# Terminologies  <== Read before you got confused
#   - branch type
#     We distinguish the following types of branches: master, develop, feature, release, hotfix, support.
#     We should assume any branch is of one of these types.
#
#   - stream
#     The entire set of branches of the same type. Stream is not branch, it is a set. Stream is not a type, it is a set.
#     Stream is a set of branches.
#
#   - substream
#     A subset of branches in a stream.
#
#   - trunk
#     Trunk is a special branch. A stream can optionally have a trunk, but only one trunk at most. For example, master and
#     develop streams each has a trunk, whereas feature, release, hotfix, and support streams don't.
#     If a stream has a trunk, all branches in the stream normally should diverge from the trunk and later merge to the trunk
#     when the branches are closed.
#     Trunk is a relative concept. A trunk of a stream may be a regular branch of another stream. (The former stream will be
#     a substream of the latter.)
#
#   - source
#     Source is an attribute of stream. The source of a stream refers to the parent stream where branches in the current stream
#     are created from. Most commonly, source of a stream is the stream itself. But this is not always the case, for example,
#     the sources of release and feature streams are the develop stream.
#
#   - destin
#     Destin is another attribute of stream. The destin of a stream refers to the stream(s) where branches in the current
#     stream will merge to. Most commonly, destin of a stream is the stream itself. But this is not always the case, for
#     example, the destin of release is the develop and the master streams.
#
#   - branch name
#     Use this term carefully since it is potentially ambiguious.
#     Try using this term to refer to fullname (see below).
#
#   - fullname
#     Branch name as recognized by the SCM, e.g., feature/enhance_log.
#     Prefer this term to 'branch name'.
#
#   - basename
#     Branch name recognized by flow, but not necessarily by SCM, e.g., enhanced_log (with prefix 'feature/' dropped).
#
#   - name
#     Use this term carefully since it is potentially ambiguious.
#     This term should be a synonym of basename (see above). Try using it only as place holders, such as
#     <hotfix-prefix>/<name>.
#
#   - flow action
#     Refer to action on a specified stream, e.g., hg flow feature start, where 'start' is an action.
#
#   - flow command
#     Refer to other actions than those on a stream, e.g., hg flow unshelve, where 'unshelve' is a command.
#
#   - hg command
#     Refer to command not from flow extension.
#
#   - workflow
#     Refer to the process of executing a sequence of hg commands.
#
#   - history
#     Refer to a sequence of hg commands that has been executed.
#
# Notatioins
#   - <stream>
#     Examples: <feature>, <hotfix>. These denote the corresponding streams. When you refer to a stream, e.g., feature stream,
#     use '<feature>' (or more verbosely 'feature stream'), instead of '<feature> stream', because '<feature>' already means
#     stream.
#
#   - <stream> branch
#     Example: a <feature> branch. This phrase refers a branch in <feature>. Do not use 'a feature branch' to mean a branch in
#     <feature> because the word 'feature' there should take its usual meaning as in English, which doesn't necessarily mean
#     the feature stream.
#
#   - `text`
#     Example, `hg flow feature start <name>`. The text wrapped by the ` (apostrophe) symbols should be a piece of code or
#     shell command, which could contain placeholders to be replaced by actual values.
#
#   - 'text' or "text"
#     Refer to an exact string.
###############################################################################################################################



VERSION                   = "0.9.4"
CONFIG_BASENAME           = ".flow"
OLD_CONFIG_BASENAME       = ".hgflow"
CONFIG_SECTION_BRANCHNAME = "branchname"
STRIP_CHARS               = '\'"'


colortable = {"flow.error"      : "red bold",
              "flow.warn"       : "magenta bold",
              "flow.note"       : "cyan",
              "flow.help.topic" : "yellow",
              "flow.help.code"  : "green bold",
              }



def _print( ui, *arg, **kwarg ) :
    """
    Customized print function

    This function prints messages with the prefix: C{flow: }. Multiple messages can be printed in one call.
    See I{Example I} below.

    @type  ui:      C{mercurial.ui}
    @param ui:      Mercurial user interface object
    @type  warning: C{bool}
    @param warning: If set to true, messages will be written to C{stderr} using the C{ui.warn} function.
    @type  note:    C{bool}
    @param note:    If set to true, messages will be written to C{stdout} using the C{ui.note} function. The messages will be
                    visible only when user turns on C{--verbose}.
                    By default, both L{warning} and L{note} are set to false, and messages will be written to C{stdout}.
    @type  prefix:  C{None} or C{str}
    @param prefix:  Add a customized prefix before every message. See I{Example II}.
    @type  newline: C{bool}
    @param newline: If set to false, each message will be written without newline suffix. Default value is true.

    I{Example I}:
    
    >>> _print( ui, "message1", "message2" )
    flow: message1
    flow: message2

    I{Example II}:
    
    >>> _print( ui, "message1", "message2", prefix = "warning: " )
    flow: warning: message1
    flow: warning: message2

    I{Example III}:
    
    >>> _print( ui, "message1", "message2", inline = False )
    flow: message1message2
    """
    printer = ui.warn if (kwarg.get( "warning" )) else (ui.note if (kwarg.get( "note" )) else ui.write)
    indent  = kwarg.get( "indent", "" )
    prefix  = kwarg.get( "prefix", "" )
    newline = kwarg.get( "newline" )
    newline = "\n" if (newline or newline is None) else ""
    for e in arg :
        printer( _(ui.config( "flow", "prefix", "flow: " ).strip( STRIP_CHARS ) + prefix + indent) )
        printer( _(e + newline), label = kwarg.get( "label", "" ) )



def _warn( ui, *arg, **kwarg ) :
    """
    Print messages to C{stderr}. Each message will be prefixed with C{flow: warning: }.

    This function is a thin wrapper of L{_print}. See document of the later for usage detail.
    
    Customized prefix will be appended after C{flow: warning: }.

    I{Example}:

    >>> _warn( ui, "message1", "message2", prefix = "prefix_" )
    flow: warning: prefix_message1
    flow: warning: prefix_message2
    """
    kwarg["warn"  ] = True
    kwarg["label" ] = kwarg.get( "label", "flow.warn" )
    kwarg["prefix"] = "warning: " + kwarg.get( "prefix", "" )
    _print( ui, *arg, **kwarg )



def _error( ui, *arg, **kwarg ) :
    """
    Print messages to C{stderr}. Each message will be prefixed with C{flow: error: }.

    This function is a thin wrapper of L{_print}. See document of the later for usage detail.
    
    Customized prefix will be appended after C{flow: error: }.

    I{Example}:

    >>> _error( ui, "message1", "message2", prefix = "prefix_" )
    flow: error: prefix_message1
    flow: error: prefix_message2
    """
    kwarg["warn"  ] = True
    kwarg["label" ] = kwarg.get( "label", "flow.error" )
    kwarg["prefix"] = "error: " + kwarg.get( "prefix", "" )
    _print( ui, *arg, **kwarg )



def _note( ui, *arg, **kwarg ) :
    """
    Print messages to C{stout}. Each message will be prefixed with C{flow: note: }. The messages will be displayed only when
    user turns on C{--verbose}. If you want to print message without C{--verbose}, include an argument C{via_quiet = True} in
    the call to this function.

    This function is a thin wrapper of L{_print}. See document of the later for usage detail.
    
    Customized prefix will be appended after C{flow: note: }.

    I{Example}:

    >>> _note( ui, "message1", "message2", prefix = "prefix_" )
    flow: note: prefix_message1
    flow: note: prefix_message2
    """
    if (kwarg.get( "via_quiet")) :
        kwarg["note"] = not kwarg["via_quiet"]
        del kwarg["via_quiet"]
    else :
        kwarg["note"] = True
    kwarg["label" ] = kwarg.get( "label", "flow.note" )
    kwarg["prefix"] = "note: " + kwarg.get( "prefix", "" )
    _print( ui, *arg, **kwarg )



class AbortFlow( Exception ) :
    """
    Throw an instance of this exception whenever we have to abort the flow command.
    """
    def __init__( self, *arg ) :
        """
        Accept one or more error messages in C{str} as the arguments.
        """
        Exception.__init__( self, "Aborted hg flow command." )
        self._msg = arg


    def error_message( self ) :
        """
        Returns a list of error messages in C{str}.
        """
        return self._msg
    


class AbnormalStream( Exception ) :
    """
    Throw an instance of this exception if the stream does not belong to any one of C{<master>}, C{<develop>}, C{<feature>},
    C{<release>}, C{<hotfix>}, and C{<support>}.
    """
    def __init__( self, message = "", stream = None ) :
        """
        Accept one error message. You can also pass the C{Stream} object, which can be retrieved later via the C{stream}
        method.
        """
        Exception.__init__( self, message )
        self._stream = stream



    def stream( self ) :
        """
        Return the C{Stream} object.
        """
        return self._stream

        

class Commands( object ) :
    """
    Wrapper class of C{mercurial.commands} with ability of recording command history.

    I{Example:}

    >>> commands = Commands()
    >>> commands.commit( ui, repo, ... )
    >>> commands.update( ui, repo, ... )
    >>> commands.print_history()
    flow: note: Hg command history:
    flow: note:   hg commit --message "flow: Closed release 0.7." --close_branch
    flow: note:   hg update default
    """
    def __init__( self ) :
        self.ui           = None
        self._cmd         = None
        self._cmd_history = []
        self._via_quiet   = False
        self._dryrun      = False
        
    
    
    def __getattr__( self, name ) :
        """
        Typical invocation of mercurial commands is in the form: commands.name( ... ).
        We only need to save the command name here, leaving execution of the command to the L{__call__} function.
        """
        if (name[0] != "_") :
            self._cmd = name
            return self

        

    def __call__( self, ui, repo, *arg, **kwarg ) :
        """
        Invoke the mercurial command and save it as a string into the history.
        @raise AbortFlow: Throw exception if the return code of hg command (except C{commit} and C{rebase}) is nonzero.
        """
        self.ui = ui
        cmd_str = "hg " + (self._cmd[:-1] if (self._cmd[-1] == "_") else self._cmd)
        arg     = self._branch2str(   arg )
        kwarg   = self._branch2str( kwarg )

        for key, value in kwarg.items() :
            if (value is None) :
                continue
            
            new_key = ""
            for e in key :
                new_key += "-" if (e == "_") else e
            key = new_key
            
            if (isinstance( value, str ) and -1 < value.find( " " )) :
                new_value = ""
                for c in value :
                    if   (c == "\\") : new_value += "\\\\"
                    elif (c == '"' ) : new_value += "\""
                    else             : new_value += c
                value = '"%s"' % new_value
                
            if (isinstance( value, bool )) :
                cmd_str = "%s --%s" % (cmd_str, key,)
            elif (isinstance( value, list )) :
                for e in value :
                    cmd_str = "%s --%s %s" % (cmd_str, key, str( e ),)
            else :
                cmd_str = "%s --%s %s" % (cmd_str, key, str( value ),)
        for e in arg :
            cmd_str = "%s %s " % (cmd_str, str( e ),)

        self._cmd_history.append( cmd_str )
        
        if (self._dryrun) :
            return
        
        try :
            ret   = None
            cmd   = self._cmd
            where = mercurial.commands
            if (self._cmd[0] == "q") :
                where = extensions.find( "mq" )
                cmd   = self._cmd[1:]
            elif (self._cmd == "rebase") :
                where = extensions.find( "rebase" )
            ret = getattr( where, cmd )( ui, repo, *arg, **kwarg )
            if (ret and self._cmd not in ["commit", "rebase",]) :
                raise AbortFlow( "Nonzero return code from hg command" )
        except Exception, e :
            raise AbortFlow( "Hg command failed: %s" % cmd_str, "abort: %s\n" % str( e ) )

        

    def _branch2str( self, value ) :
        """
        If C{value} is a C{Branch} object, return its fullname (C{str}); if it is not, return the object itself. Do this
        recursively if C{value} is a C{tuple}, or C{list}, or C{dict} object.
        """
        if (isinstance( value, Branch )) :
            return value.fullname()
        if (isinstance( value, (list, tuple,) )) :
            new_value = []
            for e in value :
                new_value.append( self._branch2str( e ) )
            return new_value
        if (isinstance( value, dict )) :
            new_value = {}
            for k, v in value.items() :
                new_value[k] = self._branch2str( v )
            return new_value
        return value
    
            

    def use_quiet_channel( self, via_quiet = True ) :
        """
        Print the history to the I{quiet} channel, where text will be displayed even when user does not specify the
        C{--verbose} option.
        """
        self._via_quiet = via_quiet



    def use_verbose_channel( self, via_verbose = True ) :
        """
        Print the history to the I{verbose} channel, where text will be display only when user specify the C{--verbose} option.
        """
        self._via_quiet = not via_verbose



    def dryrun( self, switch = None ) :
        """
        Switch the dry-run mode.

        @type  switch: C{boolean} or C{None}
        @param switch: Switch on dry-run mode if C{switch = True}, off if C{switch = False}. If C{switch} is C{None}, just
                       return the current state of dry-run mode.
        """
        if (switch is None) :
            return self._dryrun
        self._dryrun = switch
        

            
    def print_history( self ) :
        """
        Print the command history using the L{_note} function.
        """
        if (self.ui) :
            _note( self.ui, "Hg command history:", via_quiet = self._via_quiet )
            for e in self._cmd_history :
                _note( self.ui, e, prefix = "  ", via_quiet = self._via_quiet )



class Stream( object ) :
    @staticmethod
    def gen( ui, repo, name, check = False ) :
        """
        Given the name of a stream, return a C{Stream} object.
        If the name is that of one of the standard streams: master, develop, feature, release, hotfix, and support, return the
        same object as in C{STREAM}. If not, create and return a new C{stream} object. If the new object is not in the standard
        streams, an C{AbnormalStream} exception will be thrown. One can catch the exception and call its C{stream} method to
        get the object.
        
        @type  name : C{str}
        @param name : Name of the stream
        @type  check: C{boolean}
        @param check: If true and the stream is not a standard one, the function will check if the trunk of the stream exists
                      or not and (if exists) open or not.
                      
        @raise AbortFlow     : When C{check} is true and the trunk of the stream doesn't exist or is closed
        @raise AbnormalStream: When the stream is not in any of the standard streams
        """
        for e in STREAM.values() :
            if (name == e.name()) :
                return e
        
        rootstream_name = name.split( '/', 1 )[0]
        is_normalstream = True
        if (rootstream_name in STREAM) :
            trunk  = name.replace( rootstream_name + '/', STREAM[rootstream_name].prefix(), 1 )
            stream = Stream( ui, repo, name, trunk = trunk )
        else :
            stream = Stream( ui, repo, name, trunk = name )
            is_normalstream = False
        if (check) :
            try :
                trunk = stream.trunk()
            except error.RepoLookupError :
                raise AbortFlow( "Stream not found: %s" % stream )
            if (trunk.is_closed()) :
                raise AbortFlow( "%s has been closed." % stream )
        if (not is_normalstream) :
            raise AbnormalStream( stream = Stream( ui, repo, name ) )
        return stream

        

    def __init__( self, ui, repo, name, **kwarg ) :
        """
        Create a new C{Stream} object.

        @type  name  : C{str}
        @param name  : Name of the new stream
        @type  trunk : C{str} or C{None}
        @param trunk : Fullname of the trunk of the stream, or C{None}
        @type  prefix: C{str}
        @param prefix: Name prefix of branches in this stream. If not specified, it will default to C{trunk + '/'} (if C{trunk}
                       is not C{None}), or C{name + '/'} if (C{trunk} is C{None}).
        @type  source: C{Stream}
        @param source: Stream where branches in this stream will be created from
        @type  destin: C{list} of C{Stream} objects
        @param destin: Streams where branches in this stream will merge to when being finished
        """
        self.ui   = ui
        self.repo = repo
        
        self._name   = name
        self._trunk  = kwarg.get( "trunk"  )
        self._prefix = kwarg.get( "prefix" )
        self._source = kwarg.get( "source", self )
        self._destin = kwarg.get( "destin", [self._source,] )
    
        if (self._prefix is None) :
            if (self._trunk) :
                self._prefix = self._trunk + '/'
            else :
                self._prefix = self._name + '/'
        
        
        
    def __str__( self ) :
        """
        Return a string: '<stream-name>'.
        """
        return "<%s>" % self._name



    def __cmp__( self, rhs ) :
        """
        Compare streams by comparing their names as strings.
        """
        lhs = self._name
        rhs = rhs ._name
        return -1 if (lhs < rhs) else (1 if (lhs > rhs) else 0)



    def __contains__( self, stranch ) :
        """
        Return true if the C{stanch} is in this stream.
        
        @type  stranch: C{Stream} or C{Branch}
        @param srranch: Stream or branch which you want to test if it is in this stream
        """
        if (isinstance( stranch, Branch )) :
            if (stranch._fullname == self._trunk) :
                return True
            return stranch._fullname.startswith( self.prefix() )
        elif (isinstance( stranch, Stream )) :
            return stranch.prefix().startswith( self.prefix() )
        return str( stranch ).startswith( self.prefix() )

    
    
    def name( self ) :
        """
        Return the name of this stream.
        """
        return self._name



    def trunk( self, trace = False ) :
        """
        Return the trunk of this stream. If it has no trunk, return C{None} or the trunk of the source stream depending on the
        C{trace} parameter.

        @type  trace: C{boolean}
        @param trace: If true and this stream has no trunk, return the trunk of the source stream, and do this recursively
                      until a trunk is found. If false, this function will return C{None}.
                      
        @return: A C{Branch} object or C{None}
        """
        trunk = Branch( self.ui, self.repo, self._trunk ) if (self._trunk) else None
        if (not trunk and trace) :
            return self.source().trunk( True )
        return trunk
    


    def prefix( self ) :
        """
        Return the branch name prefix of this stream.

        @return: C{str}
        """
        return self._prefix



    def source( self ) :
        """
        Return the source stream.

        @return: C{Stream}
        """
        return self._source



    def destin( self ) :
        """
        Return a list of streams where branches in this stream will merge to when finished.

        @return: C{Stream}
        """
        return self._destin

    

    def get_fullname( self, branch_basename ) :
        """
        Return the fullname of a branch.

        @type  branch_basename: C{str}
        @param branch_basename: Basename of a branch in this stream

        @return: C{str}
        """
        return self._prefix + branch_basename



    def get_branch( self, branch_basename ) :
        """
        Create and return a new C{Branch} object with the given basename.

        @type  branch_basename: C{str}
        @param branch_basename: Basename of a branch in this stream
        
        @return: C{Branch}
        """
        return Branch( self.ui, self.repo, self.get_fullname( branch_basename ) )

    

    def branches( self, openclosed = "open" ) :
        """
        Return a list of branches in this stream. The list does not include the trunk.
        The returned list is sorted per branch name.

        @type  openclosed: C{str}, must be one of "open", "closed", and "all".
        @param openclosed: If the value is C{"open"}, return all open branches in this stream; if C{"closed"}, return all
                           closed branches in this stream; if C{"all"}, returns all open and closed branches in this stream.
        """
        if (openclosed not in ["open", "closed", "all",]) :
            raise ValueError( "Invalid value for `openclosed` parameter: %s" % openclosed )
        
        all_branches = []
        for branch_fullname, head in self.repo.branchmap().items() :
            all_branches.append( Branch( self.ui, self.repo, head[0] ) )

        branches = []
        for e in all_branches :
            try :
                stream = e.stream()
            except AbnormalStream, a :
                stream = a.stream()
            if (stream in self) :
                if (openclosed == "open") :
                    if (e.is_open()) :
                        branches.append( e )
                elif (openclosed == "closed") :
                    if (e.is_closed()) :
                        branches.append( e )
                else :
                    branches.append( e )
        branches.sort()
        return branches
        
    

class Branch( object ) :
    def __init__( self, ui, repo, rev = None ) :
        """
        Create a C{Branch} object with the given C{rev}.
        """
        self.ui   = ui
        self.repo = repo
        self.ctx  = self.repo[rev]
        
        self._fullname = str( self.ctx.branch() )

        

    def __str__( self ) :
        """
        Return the fullname of this branch.
        """
        return self._fullname



    def __cmp__( self, rhs ) :
        """
        Compare two C{Branch} object by comparing their fullnames.
        """
        if (rhs is None) :
            return 1
        lhs = self._fullname
        rhs = rhs ._fullname
        return -1 if (lhs < rhs) else (1 if (lhs > rhs) else 0)

    
    
    def fullname( self ) :
        """
        Return the fullname of this branch.
        """
        return self._fullname

    

    def basename( self, stream = None, should_quote = False ) :
        """
        Return the basename relative to the C{stream}. If C{stream} is C{None}, return the shortest possible basename (will
        not contain any '/'s).

        @type  stream: C{Stream} or C{None}
        @param stream: Stream to which the basename is relative
        """
        if (stream) :
            if (self._fullname == stream._trunk) :
                return "trunk"
            ret = self._fullname[len( stream.prefix() ):]
        else :
            ret = self._fullname.rsplit( '/', 1 )[-1]
        if (should_quote) :
            ret = "'%s'" % ret
        return ret
    


    def is_closed( self ) :
        """
        Return true if this branch is closed; or false if it is open.
        """
        extra = self.ctx.extra()
        try :
            return extra["close"]
        except KeyError :
            return False



    def is_open( self ) :
        """
        Return true if this branch is open; or false if it is closed.
        """
        return not self.is_closed()



    def is_develop_trunk( self ) :
        """
        Return true if this branch is the trunk of C{<develop>}.
        """
        return STREAM["develop"]._trunk == self._fullname



    def is_master_trunk( self ) :
        """
        Return true if this branch is the trunk of C{<master>}.
        """
        return STREAM["master"]._trunk == self._fullname



    def is_trunk( self, stream ) :
        """
        Return true if this branch is the trunk of the C{stream}.
        """
        return stream._trunk == self._fullname
    
    
        
    def stream( self ) :
        """
        Return the stream that this branch belongs to.
        """
        name = self._fullname
        for stream in STREAM.values() :
            if (name == stream._trunk) :
                return stream
            if (name.startswith( stream.prefix() )) :
                name = name.replace( stream.prefix(), stream.name() + '/' )
                break
        return Stream.gen( self.ui, self.repo, name.rsplit( '/', 1 )[0] )



commands = Commands()
STREAM   = {}           # key = stream name, value = `Stream` object. Will be set by `Flow.__init__`.



class Flow( object ) :
    def __init__( self, ui, repo, init = False ) :
        """
        Construct a C{Flow} instance that will execute the workflow.
        Construction will fail if the C{flow} extension has not been initialized for the repository.
        A warning message will be issued if the repository has uncommitted changes.
        @type  init: C{boolean}
        @param init: If true, a C{Flow} object will be constructed for initialization of hgflow. Such constructed object does
                     not supply all functionalities and is only meant to execute the `hg flow init` command.
        """
        self.ui   = ui
        self.repo = repo

        self.autoshelve       = False
        self.warn_uncommitted = True
        self.msg_prefix       = "flow: "
        self.orig_workspace   = Branch( ui, repo )
        self.curr_workspace   = self.orig_workspace     # May be changed whenever `hg update` command is executed.
        self.orig_dir         = os.getcwd()
        
        if (init) : return
        
        config_fname = os.path.join( self.repo.root, CONFIG_BASENAME )
        if (os.path.isfile( config_fname )) :
            config = ConfigParser.ConfigParser()
            config.read( config_fname )
            try :
                master  = config.get( CONFIG_SECTION_BRANCHNAME, "master"  )
                develop = config.get( CONFIG_SECTION_BRANCHNAME, "develop" )
                feature = config.get( CONFIG_SECTION_BRANCHNAME, "feature" )
                release = config.get( CONFIG_SECTION_BRANCHNAME, "release" )
                hotfix  = config.get( CONFIG_SECTION_BRANCHNAME, "hotfix"  )
                support = config.get( CONFIG_SECTION_BRANCHNAME, "support" )
            except :
                self._error( "Flow has not been initialized for this repository." )
                sys.exit( 1 )
        else :
            old_config_fname = os.path.join( self.repo.root, OLD_CONFIG_BASENAME )
            if (os.path.isfile( old_config_fname )) :
                config = ConfigParser.ConfigParser()
                config.read( old_config_fname )
                try :
                    master  = config.get( CONFIG_SECTION_BRANCHNAME, "master"  )
                    develop = config.get( CONFIG_SECTION_BRANCHNAME, "develop" )
                    feature = config.get( CONFIG_SECTION_BRANCHNAME, "feature" )
                    release = config.get( CONFIG_SECTION_BRANCHNAME, "release" )
                    hotfix  = config.get( CONFIG_SECTION_BRANCHNAME, "hotfix"  )
                    support = config.get( CONFIG_SECTION_BRANCHNAME, "support" )
                except :
                    self._error( "Flow has not been initialized for this repository." )
                    sys.exit( 1 )
                self._warn( "Configuration file format of flow has changed since v0.9." )
                self._warn( "Please use `hg flow upgrade` to upgrade the configuration file." )
            else :
                self._error( "Flow has not been initialized for this repository." )
                sys.exit( 1 )

        global STREAM
        STREAM["master" ] = Stream( ui, repo, "master",  trunk  = master  )
        STREAM["develop"] = Stream( ui, repo, "develop", trunk  = develop )
        STREAM["feature"] = Stream( ui, repo, "feature", prefix = feature, source = STREAM["develop"] )
        STREAM["release"] = Stream( ui, repo, "release", prefix = release, source = STREAM["develop"] )
        STREAM["hotfix" ] = Stream( ui, repo, "hotfix",  prefix = hotfix,  source = STREAM["master" ] )
        STREAM["support"] = Stream( ui, repo, "support", prefix = support, source = STREAM["master" ], destin = [] )

        STREAM["develop"]._destin.append( STREAM["release"] )
        STREAM["release"]._destin.append( STREAM["master" ] )
        STREAM["hotfix" ]._destin.append( STREAM["develop"] )

        if (ui.has_section( "hgflow" )) :
            self._warn( "The [hgflow] section in hg configuration file is deprecated." )
            self._warn( "Please replace the section name from [hgflow] to [flow]." )
            self.autoshelve       = ui.configbool( "hgflow", "autoshelve",       False )
            self.warn_uncommitted = ui.configbool( "hgflow", "warn_uncommitted", True  )
        if (ui.has_section( "flow" )) :
            self.autoshelve       = ui.configbool( "flow", "autoshelve",       False    )
            self.warn_uncommitted = ui.configbool( "flow", "warn_uncommitted", True     )
            self.msg_prefix       = ui.config    ( "flow", "prefix",           "flow: " ).strip( STRIP_CHARS )
        if (self._has_uncommitted_changes() and self.warn_uncommitted) :
            self._warn( "Your workspace has uncommitted changes." )

        # We'd better temporarily change the current directory to the root of the repository at the beginning.
        # This is to avoid the problem that the CWD might be gone after switching to a different branch. (Issue#14)
        # We will change it back to the original directory when the hgflow command exits.
        os.chdir( self.repo.root )
        # __init__
    
    
    
    def __getattr__( self, name ) :
        """
        Execute mercurial command of name C{name[1:]}.

        @type  name: C{str}
        @param name: Should be a mercurial command name prefixed with one underscore. For example, to call C{commit} command,
                     use C{self._commit}.
        """
        if (name[0] == "_") :
            cmd = getattr( commands, name[1:] )
            def func( *arg, **kwarg ) :
                cmd( self.ui, self.repo, *arg, **kwarg )
            return func
        raise AttributeError( "%s instance has no attribute '%s'" % (self.__class__, name,) )



    def _update( self, rev, *arg, **kwarg ) :
        """
        Intercept the call to `hg update` command. We need to keep track of the branch of the workspace.

        @type  rev: C{str} or C{mercurial.changectx}
        @param rev: Revision to which the workspace will update
        """
        try :
            old_workspace_ctx   = self.curr_workspace.ctx
            self.curr_workspace = rev if (isinstance( rev, Branch )) else Branch( self.ui, self.repo, rev )
        except error.RepoLookupError, e :
            if (commands.dryrun()) :
                commands.update( self.ui, self.repo, rev, *arg, **kwarg )
            else :
                raise e
        if (old_workspace_ctx != self.curr_workspace.ctx) :
            commands.update( self.ui, self.repo, rev, *arg, **kwarg )
        
        

    def _print( self, *arg, **kwarg ) :
        """
        Thin wrapper of the global C{_print} function
        """
        _print( self.ui, *arg, **kwarg )

        

    def _warn( self, *arg, **kwarg ) :
        """
        Thin wrapper of the global C{_warn} function
        """
        _warn( self.ui, *arg, **kwarg )

        

    def _error( self, *arg, **kwarg ) :
        """
        Thin wrapper of the global C{_error} function
        """
        _error( self.ui, *arg, **kwarg )



    def _note( self, *arg, **kwarg ) :
        """
        Thin wrapper of the global C{_note} function
        """
        _note( self.ui, *arg, **kwarg )



    def _check_rebase( self ) :
        """
        Check if 'rebase' extension is activated. If not, raise an 'AbortFlow' exception.

        @raise AbortFlow: When 'rebase' extension is not found
        """
        try :
            extensions.find( "rebase" )
        except KeyError :
            raise AbortFlow( "Cannot rebase without 'rebase' extension." )

        

    def _check_mq( self ) :
        """
        Check if 'mq' extension is activated. If not, raise an 'AbortFlow' exception.
        
        @raise AbortFlow: When 'rebase' extension is not found
        """
        try :
            extensions.find( "mq" )
        except KeyError :
            raise AbortFlow( "Cannot shelve/unshelve changes without 'mq' extension." )
            

                

    def _is_shelved( self, branch ) :
        """
        Return true if the given branch has been shelved.

        @type  branch: C{Branch}
        @param branch: Branch to test if it has shelved changes
        """
        shelve_name = "flow/" + branch.fullname() + ".pch"
        patch_fname = self.repo.join( "patches/" + shelve_name )
        shelve_name2 = "hgflow/" + branch.fullname()
        patch_fname2 = self.repo.join( "patches/" + shelve_name2 )
        return os.path.isfile( patch_fname ) or os.path.isfile( patch_fname2 )
 
            
        
    def _shelve( self, *arg, **kwarg ) :
        """
        Shelve workspace if C{self.autoshelve} is C{True}.

        This function utilizes the C{mq} extension to achieve shelving. Bascially, it calls the following C{mq} commands:
            C{hg qnew <patchname> --currentuser --currentdate -m "Shelved changes"}
            C{hg qpop}
        where <patchname> follows the pattern: flow/<branch_fullname>.pch
        The two commands will give us a patch file that later will be used to unshelve the change.
        """
        if (self.autoshelve) :
            if (self._has_uncommitted_changes()) :
                shelve_name = "flow/" + self.curr_workspace.fullname() + ".pch"
                self._check_mq()
                self._qnew( shelve_name, currentuser = True, currentdate = True, message = "Shelved changes" )
                self._qpop()



    def _unshelve( self, *arg, **kwarg ) :
        """
        Unshelve the previously shelved changes to the workspace if C{self.autoshelve} is C{True}.

        This function needs the C{mq} extension to achieve unshelving. Bascially, it calls the following commands:
            C{hg import <patch_filename> --no-commit}
            C{hg qdelete <patchname>}
        where <patchname> follows the pattern: flow/<branch_fullname>.pch, which was previously created by flow's shelving.
        """
        if (self.autoshelve) :
            shelve_name = "flow/" + self.curr_workspace.fullname() + ".pch"
            patch_fname = self.repo.join( "patches/" + shelve_name )
            if (os.path.isfile( patch_fname )) :
                self._check_mq()
                self._import_( patch_fname, no_commit = True, base = None, strip = 1 )
                self._qdelete( shelve_name )
            else :
                # Tries the old and deprecated directory.
                shelve_name = "hgflow/" + self.curr_workspace.fullname()
                patch_fname = self.repo.join( "patches/" + shelve_name )
                if (os.path.isfile( patch_fname )) :
                    self._check_mq()
                    self._import_( patch_fname, no_commit = True, base = None, strip = 1 )
                    self._qdelete( shelve_name )
                
    
        
    def _has_uncommitted_changes( self ) :
        """
        Return true if any tracked file is modified, or added, or removed, or deleted.
        """
        return any( self.repo.status() )

    

    def _branches( self, openclosed = "open" ) :
        """
        Return a list of branches.
        
        @type  openclosed: C{str}, "open", "closed", and "all"
        @param openclosed: If C{"open"}, return all open branches; if C{"closed"}, return all closed branches; if C{"all"},
                           return all branches.
        """
        if (openclosed not in ["open", "closed", "all",]) :
            raise ValueError( "Invalid value for openclosed parameter: %s" % openclosed )
        all_branches = []
        for branch_fullname, head in self.repo.branchmap().items() :
            all_branches.append( Branch( self.ui, self.repo, head[0] ) )
        branches = []
        for e in all_branches:
            if (openclosed == "open") :
                if (e.is_open()) :
                    branches.append( e )
            elif (openclosed == "closed") :
                if (e.is_closed()) :
                    branches.append( e )
            else :
                branches.append( e )
        return branches



    def _find_branch( self, fullname ) :
        """
        Return true if a branch C{fullname} is open.

        @type  fullname: C{str}
        @param fullname: Fullname of branch that you want to know whether it is open
        """
        try :
            Branch( self.ui, self.repo, fullname )
            return True
        except error.RepoLookupError :
            return False

    
    
    def latest_master_tags( self ) :
        """
        Return the latest tag of C{<master>} branch.
        """
        trunk_fullname = STREAM["master"].trunk().fullname()
        master_context = self.repo[trunk_fullname]
        while (master_context) :
            tags = master_context.tags()
            try :
                tags.remove( "tip" )
            except ValueError :
                pass
            if (tags) :
                return tags
            parents        = master_context.parents()
            master_context = None
            for e in parents :
                if (trunk_fullname == e.branch()) :
                    master_context = e
                    break
        return []

    

    def _create_branch( self, fullname, message, from_branch = None, **kwarg ) :
        """
        Create a new branch and commit the change.

        @type     fullname: C{str}
        @param    fullname: Fullname of the new branch
        @type      message: C{str}
        @param     message: Commit message
        @type  from_branch: C{Branch}
        @param from_branch: Parent branch of the new branch
        """
        if (from_branch and self.curr_workspace != from_branch) :
            self._update( from_branch )
        self._branch( fullname )
        self._commit( message = message, **kwarg )
        if (commands.dryrun()) :
            # Makes a fake new branch.
            self.curr_workspace = Branch( self.ui, self.repo )
            self.curr_workspace._fullname = fullname
        else :
            self.curr_workspace = Branch( self.ui, self.repo, fullname )
        
        

    def _action_start( self, stream, *arg, **kwarg ) :
        """
        Conduct the I{start} action for the given stream. A new branch in the stream will be created.

        @type  stream: C{Stream}
        @param stream: Stream where you want to start a new branch
        """
        try :
            basename = arg[1]
        except IndexError :
            raise AbortFlow( "You must specify a name for the new branch to start." )
            
        kwarg    = _getopt( self.ui, "start", kwarg )
        rev      = kwarg.pop( "rev",     None )
        msg      = kwarg.pop( "message", ""   )
        fullname = stream.get_fullname( basename )
        if (self._find_branch( fullname )) :
            self._warn( "An open branch named '%s' already exists in %s." % (basename, stream,) )
        else :
            if (rev is None) :
                from_branch = stream.source().trunk()
                self._shelve()
                self._update( from_branch )
            else :
                from_branch = Branch( self.ui, self.repo, rev )
                if (from_branch._fullname != stream.source()._trunk) :
                    raise AbortFlow( "Revision %s is not in the source stream of %s." % (rev, stream,) )
                self._shelve()
                self._update( rev = rev )
            if (msg) :
                msg = "%s\n" % msg
            self._create_branch( fullname, "%s%sCreated branch '%s'." % (msg, self.msg_prefix, fullname,) )

            

    def _action_push( self, stream, *arg, **kwarg ) :
        """
        Conduct the I{push} action for the given stream. The workspace branch will be pushed to the remote repository.

        @type  stream: C{Stream}
        @param stream: Stream where you want to push the workspace branch
        """
        if (self.curr_workspace in stream) :
            self._push( new_branch = True, branch = [self.curr_workspace.fullname(),] )
        else :
            raise AbortFlow( "Your workspace is '%s' branch, which is not in %s." % (self.curr_workspace, stream,),
                             "To push a %s branch, you must first update to it." % stream )
        
        

    def _action_pull( self, stream, *arg, **kwarg ) :
        """
        Conduct the I{pull} action for the given stream. The workspace branch will be updated with changes pulled from the
        remote repository.

        @type  stream: C{Stream}
        @param stream: Stream where you want to pull for the workspace branch
        """
        try :
            branch = stream.get_fullname( arg[1] )
        except IndexError :
            branch = self.curr_workspace
            if (branch not in stream) :
                raise AbortFlow( "Your workspace is '%s' branch, which is not in %s." % (branch, stream,),
                                 "To pull a %s branch, you must first update to it." % stream )
                
        self._pull( update = True, branch = [branch,] )
        


    def _action_list( self, stream, *arg, **kwarg ) :
        """
        Print all open branches in the given stream.

        @type  stream: C{Stream}
        @param stream: Stream of which you want to display open branches
        """
        # Lists all open branches in this stream.
        kwarg         = _getopt( self.ui, "list", kwarg )
        open_branches = stream.branches()
        trunk         = stream.trunk()
        if (trunk) :
            tags = ""
            if (stream == STREAM["master"]) :
                tags = self.latest_master_tags()
                tags = (", latest tags: %s" % ", ".join( tags )) if (tags) else ""
            self._print( "%s trunk: %s%s" % (stream, trunk, tags,) )
        if (open_branches) :
            self._print( "Open %s branches:" % stream )
            open_branches.sort()
            for e in open_branches :
                marker  = "#" if (self._is_shelved( e )  ) else ""
                marker += "*" if (e == self.orig_workspace) else ""
                self._print( str( e ) + marker, prefix = "  " )
        else :
            self._print( "No open %s branches" % stream )
        if (kwarg.get( "closed" )) :
            closed_branches = stream.branches( "closed" )
            if (closed_branches) :
                self._print( "Closed %s branches:" % stream )
                closed_branches.sort( lambda x, y : y.ctx.rev() - x.ctx.rev() )
                for e in closed_branches :
                    self.ui.write( "%-31s"   % e.basename( stream ),                  label = "branches.closed" )
                    self.ui.write( " %5s:%s" % (e.ctx.rev(), short( e.ctx.node() ),), label = "log.changeset"   )
                    self.ui.write( "  %s\n"  % util.datestr( e.ctx.date(), format = "%Y-%m-%d %a %H:%M %1" ),
                                   label = "log.date" )
                    bn = str( e )
                    p1 = e.ctx
                    while (p1.branch() == bn) :
                        e  = p1
                        p1 = e.p1()
                    description = e.description()
                    msg_prefix  = ("flow: ", "hgflow: ", "hg flow,", self.msg_prefix or "#@$(&*^$",)
                    if (not (description.startswith( msg_prefix ))) :
                        lines = [e.strip() for e in description.split( "\n" )]
                        self.ui.note( "  description: %s\n" % lines[0] )
                        for line in lines[1:] :
                            if (not (line.startswith( msg_prefix ))) :
                                self.ui.note( "               %s\n" % lines[0] )
                        self.ui.note( "\n" )
            else :
                self._print( "No closed %s branches" % stream )



    def _action_log( self, stream, *arg, **kwarg ) :
        """
        Show revision history of the specified branch.

        @type  stream: C{Stream},
        @param stream: Stream where the specified branch is
        """
        # User may specify a file with a relative path name. Since CWD has changed to the repository's root dir when the
        # `Flow' object was constructed, we need to restore the original dir to get the correct path name of the file.
        os.chdir( self.orig_dir )
        kwarg     = _getopt( self.ui, "log", kwarg )
        filenames = kwarg.pop( "file", [] )
        onstream  = kwarg.pop( "onstream", False )
        if (onstream) :
            filenames.extend( arg[1:] )
            branches = stream.branches()
            if (stream._trunk) :
                branches.append( stream._trunk )
        else :
            # Case 1: hg flow <stream> log <basename>
            #         - Shows the log of the "<stream>/<basename>" branch.
            # Case 2: hg flow <stream> log
            #         - Case 2a: <stream> does not have a trunk
            #                    - Shows the log of the current workspace, which should be a branch in <stream>.
            #         - Case 2b: <stream> has a trunk
            #                    - Case 2b1: Current workspace is a branch in <stream>.
            #                                - Shows the log of the current workspace.
            #                    - Case 2b2: Current workspace is not a branch in <stream>.
            #                                - Shows the log of <stream>'s trunk.
            # Case 3: hg flow <stream> log <filename>
            #         - This case can be overriden by Case 1. Namely, if the <filename> happens to be the same as the
            #           <basename>, the latter will take precedence.
            #         - Case 3a: The current workspace is in <stream>
            #                    - Show the log of <filename> in the current workspace branch.
            #         - Case 3b: The current workspace is not in <stream>, and <stream> has a trunk.
            #                    - Show the log of <filename> in <stream>'s trunk.
            #         - Case 3c: The current workspace is not in <stream>, and <stream> has no trunk.
            #                    - Error
            try :
                branch = stream.get_branch( arg[1] )
                # Case 1
            except error.RepoLookupError :
                filenames.append( arg[1] )
                if (self.curr_workspace in stream) :
                    # Case 3a
                    branch = self.curr_workspace
                else :
                    branch = stream.trunk()
                    if (not branch) :
                        # Case 3c
                        raise AbortFlow( "Cannot determine branch in %s. Please be more specific." % stream )
                    else :
                        # Case 3b
                        # Just be clear that we have covered Case 2b2.
                        pass
            except IndexError :
                branch = stream.trunk()
                if (not branch) :
                    # Case 2a
                    branch = self.curr_workspace
                    if (branch not in stream) :
                        raise AbortFlow( "Your workspace is '%s' branch, which is not in %s." % (branch, stream,),
                                         "To show log of a %s branch, you must also specify its name." % stream )
                elif (self.curr_workspace in stream) :
                    # Case 2b1
                    branch = self.curr_workspace
                else :
                    # Case 2b2
                    # Just be clear that we have covered Case 2b2.
                    pass
            # At this point, `branch` must be existent.
            branches = [branch,]

        # OK. We have to explicitly specify the date, rev, and user arguments to prevent mercurial python APIs from crashing.
        opts = {"date" : None, "rev" : None, "user" : None, "branch" : branches,}
        opts.update( kwarg )
        self._log( *filenames, **opts )

        

    def _action_abort( self, stream, *arg, **kwarg ) :
        """
        Abort the workspace branch.

        @type  stream: C{Stream}
        @param stream: Stream where the branch which you want to abort is
        """
        kwarg          = _getopt( self.ui, "abort", kwarg )
        msg            = kwarg.pop( "message",  ""    )
        onstream       = kwarg.pop( "onstream", False )
        curr_workspace = self.curr_workspace
        if (msg) :
            msg = "%s\n" % msg
        if (curr_workspace.is_develop_trunk()) :
            raise AbortFlow( "You cannot abort the <develop> trunk." )
        if (onstream) :
            branches = stream.branches()
            if (stream == STREAM["develop"]) :
                branches.remove( stream.trunk() )
            elif (stream._trunk) :
                branches.append( stream.trunk() )
            for branch in branches :
                self._update( branch )
                self._commit( close_branch = True, message = "%s%sAborted %s %s." %
                              (msg, self.msg_prefix, stream, branch.basename( stream, should_quote = True ),) )
            if (self.curr_workspace != self.orig_workspace) :
                self._update( self.orig_workspace )
        else :
            if (curr_workspace.is_trunk( stream )) :
                curr_stream = curr_workspace.stream()
                raise AbortFlow( "You cannot abort a trunk.",
                                 "To abort '%s' as a branch, use `hg flow %s abort`." % (curr_workspace, curr_stream.name(),)
                                 )
            if (curr_workspace not in stream) :
                raise AbortFlow( "Your workspace is '%s' branch, which is not in %s." % (curr_workspace, stream,),
                                 "To abort a %s branch, you must first update to it." % stream )
            self._commit( close_branch = True, message = "%s%sAborted %s '%s'." %
                          (msg, self.msg_prefix, stream, curr_workspace.basename( stream ),) )
            self._update( stream.trunk( trace = True ) )
        self._unshelve()

    

    def _action_promote( self, stream, *arg, **kwarg ) :
        """
        Promote the workspace branch to its destination stream(s). If there are uncommitted changes in the current branch,
        they will be automatically shelved before rebasing and unshelved afterwards.

        @type  stream: C{Stream}
        @param stream: Stream where the branch which you want to rebase is
        @type     rev: C{str}
        @param    rev: If provided, promote this revision instead of the head. The specified revision must be in the workspace
                       branch.
        """
        kwarg          = _getopt( self.ui, "promote", kwarg )
        rev            = kwarg.pop( "rev",     None )
        message        = kwarg.pop( "message", None )
        message        = (message + "\n") if (message) else ""
        orig_workspace = self.curr_workspace
        has_shelved    = False
        
        if (orig_workspace not in stream) :
            raise AbortFlow( "Your workspace is '%s' branch, which is not in %s." % (orig_workspace, stream,),
                             "To promote a %s branch, you must first update to it." % stream )
        
        if (rev) :
            # Ensures `rev` is in workspace branch.
            promoted_branch = Branch( self.ui, self.repo, rev )
            promoted_rev    = rev
            promoted_node   = promoted_branch.ctx.node()
            if (promoted_branch != orig_workspace) :
                raise AbortFlow( "Revision %s is not in workspace branch." % rev )
        else :
            promoted_branch = orig_workspace
            promoted_rev    = orig_workspace
            promoted_ctx    = promoted_branch.ctx
            promoted_node   = promoted_ctx.node()
            # `promoted_node' is `None' if the `promote_ctx' is an instance of `workingctx'.
            while (promoted_node is None) :
                promoted_ctx  = promoted_ctx._parents[0]
                promoted_node = promoted_ctx.node()
            
        if (arg[1:]) :
            if (not has_shelved) :
                self._shelve()
                has_shelved = True
            for dest in arg[1:] :
                self._update( dest          )
                self._merge ( promoted_rev  )
                self._commit( message = message + ("%sPromoted %s '%s' (%s) to '%s'." %
                              (self.msg_prefix, stream, promoted_branch.basename( stream ),
                               short( promoted_node ), dest,)), **kwarg )
        else :
            for s in stream.destin() :
                if (s == stream) :
                    continue
                trunk = s.trunk()
                if (trunk) :
                    if (not has_shelved) :
                        self._shelve()
                        has_shelved = True
                    self._update( trunk        )
                    self._merge ( promoted_rev )
                    self._commit( message = message + ("%sPromoted %s '%s' (%s) to '%s'." %
                                  (self.msg_prefix, stream, promoted_branch.basename( stream ),
                                   short( promoted_node ), trunk,)), **kwarg )
                else :
                    self._error( "Cannot determine promote destination." )
                    return
        if (orig_workspace != self.curr_workspace) :
            self._update( orig_workspace )
        self._unshelve()

    

    def _action_rebase( self, stream, *arg, **kwarg ) :
        """
        Rebase the workspace branch to its parent branch. If there are uncommitted changes in the current branch, they will be
        automatically shelved before rebasing and unshelved afterwards.

        @type  stream: C{Stream}
        @param stream: Stream where the branch which you want to rebase is
        @type  dest:   C{str}
        @param dest:   If provided, use its value as the destination of rebasing. The value must be a changeset of the parent
                       branch, otherwise it will trigger an error. If not provided, use the tip of the parent branch as the
                       destination of rebasing.
        """
        kwarg    = _getopt( self.ui, "rebase", kwarg )
        dest     = kwarg.get( "dest" )
        onstream = kwarg.pop( "onstream", False )
        if (onstream) :
            if (not dest) :
                dest = stream.source().trunk( trace = True )
            branches = stream.branches()
            if (stream == STREAM["develop"]) :
                branches.remove( stream.trunk() )
            elif (stream._trunk) :
                branches.append( stream.trunk() )
            self._check_rebase()
            self._shelve()
            for branch in branches :
                if (dest != branch) :
                    self._rebase( base = branch, dest = dest, keepbranches = True )
            self._unshelve()
        else :
            curr_workspace = self.curr_workspace
            if (not dest) :
                dest = stream.trunk( trace = True )
            if (curr_workspace not in stream) :
                raise AbortFlow( "Your workspace is '%s' branch, which is not in %s." % (curr_workspace, stream,),
                                 "To rebase a %s branch, you must first update to it." % stream )
            if (curr_workspace.is_develop_trunk()) :
                raise AbortFlow( "You cannot rebase the <develop> trunk." )
            if (dest == curr_workspace) :
                self._warn( "No effects from rebasing a branch to itself" )
            else :
                self._check_rebase()
                self._shelve()
                self._rebase( base = curr_workspace, dest = dest, keepbranches = True )
                self._unshelve()
    
    
    
    def _update_workspace( self, stream, branch, verbose = True ) :
        """
        Update the workspace to the given branch. Shelving and unshelving will be conducted automatically.

        @type  stream: C{Stream}
        @param stream: Stream where the branch which you are updating the workspace to is
        @type  branch: C{Branch} or C{None}
        @param branch: Branch to update the workspace to. No effects if it is C{None}.
        """
        if (not branch) :
            return
        
        if (branch == self.curr_workspace) :
            if (verbose) :
                self._print( "You are already in %s %s." % (stream, branch.basename( stream, should_quote = True ),) )
        else :
            self._print( "Update workspace to %s %s." % (stream, branch.basename( stream, should_quote = True ),) )
            self._shelve()
            self._update( branch )
            self._unshelve()


    
    def _action_other( self, stream, *arg, **kwarg ) :
        """
        If the action is the name of a branch in the given stream, we will update workspace to that branch; otherwise, the
        action is considered as an error.
        
        @type  stream: C{Stream}
        @param stream: Stream where the branch that we will switch to is
        """
        try :
            name   = arg[0]
            branch = stream.get_branch( name )
            if (branch.is_closed()) :
                self._warn( "%s '%s' has been closed." % (stream, name,) )
            self._update_workspace( stream, branch )
        except error.RepoLookupError :
            self._error( "Invalid action or unknown branch in %s: '%s'"         % (stream, name,) )
            self._print( "If you want to create a new branch called '%s' in %s" % (name, stream,) )
            self._print( "try command:", "  hg flow %s start %s" % (stream.name(), name,) )
            raise AbortFlow()

            

    def _commit_change( self, opt ) :
        """
        Commit the changes in the workspace.
        Note that this method can potentially mutate C{opt}. Specifically, it will delete the C{commit} and C{message} keys if
        they are present in C{opt}.
        
        @type  opt: C{dict}
        @param opt: Option dictionary. Recognizable keys are C{commit} and C{message}. The value of C{commit} should be a
                    boolean, indicating whether or not to perform committing. The value of C{message} should be a string, which
                    will be used as the commit message. It is OK for both of the options to be missing. But it would trigger
                    an error if C{message} is given without C{commit} set to true. There is no special treatment on other
                    keys, and they will be passed to the C{hg commit} command as is.
        """
        if (opt.get( "commit" )) :
            del opt["commit"]
            self._commit( **opt )
            try :
                del opt["message"]
            except KeyError :
                pass
        elif (opt.get( "message" )) :
            raise AbortFlow( "Cannot use the specified commit message.", "Did you forget to specify the -c option?" )
        
        
            
    def _action_finish( self, stream, *arg, **kwarg ) :
        """
        Finish a branch in the given stream. The current workspace must be in the branch to be finished, otherwise an error
        will be triggered. The default behavior of finish action is the following:
          1. close the branch.
          2. merge the branch to the C{destin} streams.

        @type  stream: C{Stream}
        @param stream: Stream where the branch that we will finish is
        """
        try :
            tag_name = arg[1]
        except IndexError :
            tag_name = None

        kwarg          = _getopt( self.ui, "finish", kwarg )
        onstream       = kwarg.pop( "onstream", False )
        curr_workspace = self.curr_workspace
        curr_stream    = curr_workspace.stream()
        name           = curr_workspace.basename( stream, should_quote = True )
        tag_name       = tag_name if (tag_name) else ("v" + name[1:-1])
        develop_stream = STREAM["develop"]
        
        if (onstream) :
            if (stream in [develop_stream, STREAM["support"], STREAM["hotfix"], STREAM["release"],]) :
                raise AbortFlow( "You cannot finish %s." % stream )
            branches = stream.branches()
            if (stream._trunk) :
                branches.append( stream.trunk() )
            for branch in branches :
                self._update( branch )
                self._action_finish( stream, *arg, **kwarg )
            return
                
        if (curr_workspace.is_develop_trunk()) :
            raise AbortFlow( "You cannot finish the <develop> trunk." )
        elif (curr_workspace not in stream) :
            raise AbortFlow( "Your workspace is '%s' branch, which is not in %s." % (curr_workspace, stream,),
                             "To finish a %s branch, you must first update to it." % stream )

        # Commits changes (if any) in the current branch.
        self._commit_change( kwarg )

        # Merges the workspace to its `destin` streams.
        destin_with_trunk    = []
        destin_without_trunk = []
        final_branch         = None
        for s in stream.destin() :
            trunk = s.trunk()
            if (trunk == curr_workspace) :
                pass
            elif (trunk) :
                destin_with_trunk.append( s )
            else :
                destin_without_trunk.append( s )
        for s in destin_without_trunk :
            trunk = s.trunk()
            so = Stream( self.ui, self.repo,
                         stream.name() + "/" + curr_workspace.basename( stream ), trunk = curr_workspace.fullname() )
            so = "%s:%s" % (so.name(), s.name(),)
            self.action( so, "start", name[1:-1] )
            final_branch = s.get_fullname( name[1:-1] )
        if (destin_with_trunk or destin_without_trunk) :
            # If either list is not empty.
            self._update( curr_workspace )
            self._commit( close_branch = True, message = "%sClosed %s %s." % (self.msg_prefix, stream, name,), **kwarg )
        else :
            # If both lists are empty.
            if (stream == STREAM["support"]) :
                self._update( curr_workspace )
                self._commit( close_branch = True, message = "%sClosed %s %s." % (self.msg_prefix, stream, name,), **kwarg )
                final_branch = STREAM["master"].trunk()
            else :
                raise AbortFlow( "No branch in %s to finish." % stream )
        for s in destin_with_trunk :
            trunk = s.trunk()
            self._update( trunk          )
            self._merge ( curr_workspace )
            self._commit( message = "%sMerged %s %s to %s ('%s')." % (self.msg_prefix, stream, name, s, trunk,), **kwarg )
            if (s == STREAM["master"]) :
                self._tag( tag_name )
            elif (s in develop_stream and s is not develop_stream) :
                tr_stream = trunk.stream()
                for ss in tr_stream.destin() :
                    if (ss == develop_stream) :
                        dvtrunk = develop_stream.trunk()
                        tr_name = trunk.basename( ss )
                        self._update( dvtrunk )
                        self._merge ( trunk   )
                        self._commit( message = "%sMerged <develop/%s:%s> %s to %s ('%s')." %
                                      (self.msg_prefix, tr_name, stream.name(), name, ss, dvtrunk,), **kwarg )
        if (final_branch) :
            self._update( final_branch )
    
            

    def _execute_action( self, stream, *arg, **kwarg ) :
        """
        Execute an action on the given stream. If no action is specified, the action will default to I{list}
        (see L{_action_list}). The default behavior of an action is defined by the C{_action_*} methods. Custom action behavior
        can be given through the C{action_func} parameter.

        @type  stream:      C{Stream}
        @param stream:      Stream where we will execute the action
        @type  action_func: C{dict}
        @param action_func: Custom action methods. Key (C{str}) is action name, and value is a function that define the
                            behavior of the custom action.
        """
        try :
            action = arg[0]
        except IndexError :
            action = "list"

        action_func = {
            "start"   : self._action_start,
            "finish"  : self._action_finish,
            "push"    : self._action_push,
            "publish" : self._action_push,
            "pull"    : self._action_pull,
            "list"    : self._action_list,
            "log"     : self._action_log,
            "abort"   : self._action_abort,
            "promote" : self._action_promote,
            "rebase"  : self._action_rebase,
            "other"   : self._action_other,
        }

        custom_action_func = kwarg.pop( "action_func", {} )
        action_func.update( custom_action_func )

        return action_func.get( action, self._action_other )( stream, *arg, **kwarg )
    
    
       
    def action( self, stream, *arg, **kwarg ) :
        """
        Execute action on the stream.
        """
        if (isinstance( stream, str )) :
            source = None
            tokens = stream.split( ':' )
            n      = len( tokens )
            if (n == 2) :
                source, stream = tokens[0], tokens[1]
            if (n > 3 or not stream) :
                raise AbortFlow( "Invalid stream syntax: '%s'" % stream )
            try :
                stream = Stream.gen( self.ui, self.repo, stream, check = True )
            except AbnormalStream, e :
                stream = e.stream()
            if (source) :
                try :
                    source = Stream.gen( self.ui, self.repo, source, check = True )
                except AbnormalStream, e :
                    source = e.stream()
                stream = copy.copy( stream )
                stream._source = source
                for i, e in enumerate( stream.destin() ) :
                    if (source in e ) :
                        stream._destin[i] = source
                        break
                else :
                    stream._destin = [source]

        if (len( arg ) > 0) :
            action = arg[0]
            if (stream == STREAM["master"]) :
                if (action in ["start", "finish", "abort", "rebase",]) :
                    raise AbortFlow( "Invalid action for <master>" )
        else :
            self._update_workspace( stream, stream.trunk(), verbose = False )
        self._execute_action( stream, *arg, **kwarg )
        
    

    def print_version( self, *arg, **kwarg ) :
        """
        Print flow's version and then quit.
        """
        self._print( "version %s" % VERSION )



    def unshelve( self, *arg, **kwarg ) :
        """
        Unshelve the previously shelved changes.
        """
        self.autoshelve = True
        self._unshelve( *arg, **kwarg )

        

    def print_open_branches( self, *arg, **kwarg ) :
        """
        Print open branches in each stream.

        The currently active branch will be marked with a * symbol. Branches where there are shelved changes will be marked
        with a # symbol.
        """
        self._print( "Currently open branches:" )
        curr_workspace = self.curr_workspace
        stream_names   = ["master", "develop", "feature", "release", "hotfix", "support",]
        all_branches   = self._branches()
        for sn in stream_names :
            stream = STREAM[sn]
            trunk  = stream.trunk()
            open_branches_in_stream = []
            remaining_branches      = []
            for e in all_branches :
                if (e in stream) :
                    open_branches_in_stream.append( e )
                else :
                    remaining_branches.append( e )
            all_branches = remaining_branches
            if (trunk is None and not open_branches_in_stream) :
                continue
            self._print( "%-9s: " % stream, newline = False )
            if (trunk) :
                marker  = "#" if (self._is_shelved( trunk )) else ""
                marker += "*" if (trunk == curr_workspace  ) else ""
                self.ui.write( "%s%s " % (trunk, marker,) )
                open_branches_in_stream.remove( trunk )
            if (open_branches_in_stream) :
                for e in open_branches_in_stream :
                    marker  = "#" if (self._is_shelved( e )) else ""
                    marker += "*" if (e == curr_workspace  ) else ""
                    self.ui.write( "%s%s " % (e, marker,) )
            self.ui.write( "\n" )

    
     
    def init( self, *arg, **kwarg ) :
        """
        Initialize flow.
        """
        config_fname   = os.path.join( self.repo.root, CONFIG_BASENAME )
        master_stream  = "default"
        hotfix_stream  = "hotfix/"
        develop_stream = "develop"
        feature_stream = "feature/"
        release_stream = "release/"
        support_stream = "support/"
        has_goodconfig = False
        
        # Fetches existing condition
        if (os.path.isfile( config_fname )) :
            self._print( "Flow was already initialized for workspace:" )
            config = ConfigParser.ConfigParser()
            config.read( config_fname )
            SECTION = CONFIG_SECTION_BRANCHNAME
            try :
                master_stream  = config.get( SECTION, "master"  )
                develop_stream = config.get( SECTION, "develop" )
                feature_stream = config.get( SECTION, "feature" )
                release_stream = config.get( SECTION, "release" )
                hotfix_stream  = config.get( SECTION, "hotfix"  )
                support_stream = config.get( SECTION, "support" )
                has_goodconfig = True
            except ConfigParser.NoSectionError :
                self._error( "Section [%s] not found in configuration file: %s" % (SECTION, config_fname,) )
                self._error( "Your configuration file is probably in old format or corrupt." )
            except ConfigParser.NoOptionError, e :
                self._error( "%s" % e )
                self._error( "Your configuration file is probably corrupt." )
                
        if (has_goodconfig) :
            self._print( "Repository-specific configuration:" )
            self._print( "<master>  trunk: '%s'"         %  master_stream, prefix = "  " )
            self._print( "<develop> trunk: '%s'"         % develop_stream, prefix = "  " )
            self._print( "<feature> branch prefix: '%s'" % feature_stream, prefix = "  " )
            self._print( "<release> branch prefix: '%s'" % release_stream, prefix = "  " )
            self._print( "<hotfix>  branch prefix: '%s'" %  hotfix_stream, prefix = "  " )
            self._print( "<support> branch prefix: '%s'" % support_stream, prefix = "  " )

        autoshelve = None
        if (self.ui.has_section( "hgflow" ) or self.ui.has_section( "flow" )) :
            self._print( "Global configuration:" )
            autoshelve = self.ui.configbool( "hgflow", "autoshelve" )
            if (self.ui.has_section( "flow" )) :
                autoshelve = self.ui.configbool( "flow", "autoshelve" )
            if (not (autoshelve is None)) :
                self._print( "autoshelve: %s" % ("on" if (autoshelve) else "off"), prefix = "  " )

        # Shall we continue if there already exists a configuration file?
        kwarg = _getopt( self.ui, "init", kwarg )
        if (has_goodconfig and not kwarg.get( "force" )) :
            return

        print
        try :
            mq = extensions.find( "mq" )
        except KeyError :
            self._warn( "The 'mq' extension is deactivated. You cannot use some features of flow." )
            print

        workspace = self.curr_workspace
        branches  = self._branches()
        if (len( branches ) > 1) :
            self._warn( "You have the following open branches. Will initialize flow for all of them." )
            for branch in branches :
                if (branch == workspace) :
                    self._warn( "  " + branch.fullname() + " (active)" )
                else :
                    self._warn( "  %s" % branch.fullname() )
            print
            
        # 'status' method returns a 7-member tuple:
        # 0 modified, 1 added, 2 removed, 3 deleted, 4 unknown(?), 5 ignored, and 6 clean
        orig_repo_status = self.repo.status()[:4]
        for e in orig_repo_status :
            try :
                e.remove( ".flow" )
            except ValueError :
                pass

        if (any( orig_repo_status )) :
            if (len( branches ) > 1 and not mq) :
                raise AbortFlow( "Your workspace has uncommitted changes. Cannot initialize flow for all",
                                 "  open branches. You can either commit the changes or install the 'mq'",
                                 "  extension, and then try again." )

        def get_input( stream_name, default ) :
            while (True) :
                answer = self.ui.prompt( _("Branch name for %s stream: [%s]" % (stream_name, default,)), default = default )
                if (answer.find( ':' ) > -1) :
                    self._error( "Illegal symbol ':' in branch name" )
                else :
                    return answer
        master_stream  = get_input( "master",   master_stream )
        develop_stream = get_input( "develop", develop_stream )
        feature_stream = get_input( "feature", feature_stream )
        release_stream = get_input( "release", release_stream )
        hotfix_stream  = get_input( "hotfix",   hotfix_stream )
        support_stream = get_input( "support", support_stream )

        if (autoshelve is None) :
            self._print( """
When you switch to another branch, flow can automatically shelve uncommitted
changes in workpace right before switching. Later when you switch back, flow can
automatically unshelve the changes to the workspace. This functionality is
called autoshelve. You need the 'mq' extension to use it.""" )
            answer = self.ui.prompt( "Do you want to turn it on? [Yes] ", default = "y" )
            answer = True if (answer.lower() in ["yes", "y", "",]) else False
            if (answer) :
                self._print( """
Here is what you need to do:
  To turn it on for only this repository, edit your <repository-root>/.hg/hgrc
  file by adding the following lines:
      [flow]
      autoshelve = true
  You can turn it on for all of your repositories by doing the same edition to
  your $HOME/.hgrc file. To turn it off, just edit the corresponding file and
  replace 'true' with 'false'.
""" )
                self.ui.prompt( _("Press Enter to continue initialization...") )

        # Creates configuration.
        config = ConfigParser.RawConfigParser()
        config.add_section( CONFIG_SECTION_BRANCHNAME )
        config.set( CONFIG_SECTION_BRANCHNAME, "master",   master_stream )
        config.set( CONFIG_SECTION_BRANCHNAME, "develop", develop_stream )
        config.set( CONFIG_SECTION_BRANCHNAME, "feature", feature_stream )
        config.set( CONFIG_SECTION_BRANCHNAME, "release", release_stream )
        config.set( CONFIG_SECTION_BRANCHNAME, "hotfix",   hotfix_stream )
        config.set( CONFIG_SECTION_BRANCHNAME, "support", support_stream )

        def write_config() :
            # Writes the configuration in the current branch.
            with open( config_fname, "w" ) as fh :
                config.write( fh )
            repo_status = self.repo.status( unknown = True )
            if (".flow" in repo_status[0]) :
                self._commit( config_fname, message = "flow initialization: Modified configuration file." )
            elif (".flow" in repo_status[4]) :
                self._add   ( config_fname )
                self._commit( config_fname, message = "flow initialization: Added configuration file." )

        write_config()
        
        # Writes the configuration in all the other branches.
        self.autoshelve = True
        self._shelve()
        
        if (len( branches ) > 1) :
            for branch in branches :
                if (branch == workspace) : continue
                self._update( branch )
                write_config()
            self._update( workspace )
    
        # Creates 'master' and 'develop' streams if they don't yet exist.
        if (not self._find_branch( master_stream )) :
            self._create_branch( master_stream, "flow initialization: Created <master> trunk: %s" % master_stream )
        if (not self._find_branch( develop_stream )) :
            self._create_branch( develop_stream, "flow initialization: Created <develop> trunk: %s" % develop_stream )
        self._update( workspace )
        self._unshelve()

    

    def upgrade( self, *arg, **kwarg ) :
        """
        Upgrade older version to the latest version.
        """
        self._print( "Upgrade flow's configuration file from v0.7 (or v0.8) to v0.9." )
        config_fname     = os.path.join( self.repo.root,     CONFIG_BASENAME )
        old_config_fname = os.path.join( self.repo.root, OLD_CONFIG_BASENAME )
        workspace = self.curr_workspace
        for branch in self._branches() :
            self._update( branch )
            self._rename( old_config_fname, config_fname, force = True )
            self._commit( message = "flow upgrade: Renamed flow's configuration file from '.hgflow' to '.flow'." )
        self._update( workspace )

        

def flow_init_cmd( ui, repo, *args, **kwarg ) :
    """
    Initialize flow.
    This command has been deprecated.
    """
    _warn( ui, "`hg flow-init` has been deprecated. In the future use `hg flow init` instead." )
    Flow( ui, repo, init = True ).init( *args, **kwarg )
   
    

def flow_cmd( ui, repo, cmd = None, *arg, **kwarg ) :
    """Flow is a Mercurial extension implementing a generalized branching model,
where Driessen's model is only a special case.

actions:

- start    Open a new branch in the stream.
- finish   Close workspace branch and merge it to destination stream(s).
- push     Push workspace branch to the remote repository.
- publish  Same as `push`
- pull     Pull from the remote repository and update workspace branch.
- list     List all open branches in the stream.
- log      Show revision history of branch.
- promote  Merge workspace to other branches. (not closing any branches.)
- rebase   Rebase workspace branch to its parent branch.
- abort    Abort branch. Close branch without merging.

If no action is specified by user, the action will default to `list`. If a
branch name (instead of action) is given after the stream name, Flow will
switch the current workspace to the branch.

commands:

- init     Initialize flow.
- unshelve Unshelve the previously shelved changes for workspace branch.
- upgrade  Upgrade the configuration file to v0.9 or later.
- help     Show help for a specific topic. Example: `hg flow help @help`
- version  Show flow's version number.
"""
    # Supresses bookmarks, otherwise if the name of a bookmark happens to be the same as a named branch, hg will use the
    # bookmark's revision.
    repo._bookmarks = {}
    
    flow = Flow( ui, repo, cmd in ["init", "upgrade",] )
    func = {
        "init"     : flow.init,
        "upgrade"  : flow.upgrade,
        "unshelve" : flow.unshelve,
        "help"     : Help( ui, repo ).print_help,
        "version"  : flow.print_version,
        None       : flow.print_open_branches,
    }

    commands.use_quiet_channel( kwarg.get( "history" ) )
    commands.dryrun           ( kwarg.get( "dry_run" ) )

    if (kwarg.get( "dry_run" )) :
        _print( ui, "This is a dry run." )
        commands.use_quiet_channel( True )
        
    try :
        # If `cmd' is a command (instead of an action), checks the options for it.
        if (cmd in func) :
            _getopt( ui, cmd, kwarg )
        
        func = func.get( cmd, lambda *arg, **kwarg : flow.action( cmd, *arg, **kwarg ) )
        func( *arg, **kwarg )
    except AbortFlow, e :
        errmsg = e.error_message()
        if (errmsg and "Unrecognized option" == errmsg[0][:19]) :
            _error( ui, errmsg[0] )
            _note ( ui, errmsg[1] )
        else :
            _error( ui, *errmsg )
        if (ui.tracebackflag) :
            ei = sys.exc_info()
            sys.excepthook( ei[0], ei[1], ei[2] )

    commands.print_history()

    try :
        os.chdir( flow.orig_dir )
    except :
        _print( ui, "The original dir is gone in file system (probably due to updating branch)." )
        _print( ui, "You are now in the root dir of the repository." )



class Help( object ) :
    """
    Online help system
    We define all help topics within this class.
    We support text effects on help message. See C{colortable} for predefined effects as C{flow.help.*}. To make it easy to use
    text effects, we invented a primitive markdown syntax. For now, we support only the C{flow.help.code}, which will be
    applied to text wrapped with '{{{' and '}}}'.
    """

    SHORT_USAGE = """
flow: a Mercurial workflow extension

Usage: {{{hg flow {<stream> [<action> [<arg>...]] | <command>} [<option>...]}}}

""" + flow_cmd.__doc__

    TOPIC = {
"@deprecated" : """
The following items have been deprecated in this release and will be removed in
the future:
  * flow-init   Command `hg flow-init` is replaced by `hg flow init`.
  * [hgflow]    The '[hgflow]' section name in hg's configuration file is
                renamed to '[flow]'.
  * .hgflow     Configuration file is renamed from '.hgflow' to '.flow'. You can
                use {{{hg flow upgrade}}} command to rename the file in all open
                branches.
""",

"@examples" : """
{{{> hg flow}}}
flow: Currently open branches:
flow: <master> : default
flow: <develop>: develop develop/0.9#
flow: <feature>: feature/help*
# Show open branches in all streams. The '*' marker indicate the workspace is
# the 'help' branch in <feature>. The '#' markers indicates there are shelved
# changes in the branch.

{{{> hg flow feature finish --history}}}
# Finish the current <feature> branch, and print the history of primitive hg
# commands used by the workflow.

{{{> hg flow develop/0.9:feature start new_v0.9_feature}}}
# Start a new feature branch from the 'develop/0.9' branch.

{{{> hg flow develop/0.9:feature finish --verbose}}}
flow: note: Hg command history:
flow: note:   hg commit --message "flow: Closed <feature> 'help'." --close-branch
flow: note:   hg update develop/0.9
flow: note:   hg merge feature/help
flow: note:   hg commit --message "flow: Merged <feature> 'help' to <develop/0.9> ('develop/0.9')."
flow: note:   hg update develop
flow: note:   hg merge develop/0.9
flow: note:   hg commit --message "flow: Merged <develop/0.9:feature> 'help' to <develop> ('develop')."
# Finish the workspace <feature> branch, merging it to 'develop/0.9', which is
# in turn merged to <develop>'s trunk.
""",

"@master" : """
Master stream contains 1 and only 1 branch that has only and all production
revisions (i.e., official releases). New revisions in <master> are created when
a <release> or <hotfix> branch merges into <master>.
The following actions can be applied to <master>: push, publish, pull, list,
and log.
""",

"@develop" : """
Develop stream contains all changes made for future releases. <release> and
<feature> branches are started from <develop> and will be merged to <develop>
when finished. Since version 0.9, user can create branches in <develop>. A
<develop> branch can be used as the source branch to start <release> and
<feature> branches.
""",

"@feature" : """
Feature stream contains branches where new features for future releases are
developed. Branches in <feature> are created from either <develop> or an
existing <feature> branch.
All actions can be applied to <feature> branches. When a <feature> branch is
finished, it will normally be merged into <develop>.
""",

"@release" : """
Release stream contains branches of release candidates. Code in <release> branch
will usually be tested and bug-fixed. Once a <release> branch is graduated from
the testing and bug-fixing process, it will be merged to both <master> and
<develop>.
""",

"@hotfix" : """
Hotfix stream contains branches for fixing bugs in <master>. <hotfix> branches
are started from <master> and once they are finished will be merged to both
<master> and <develop>.
""",

"@support" : """
Support stream contains branches for supporting a previous release. <support>
branches are started from <master> and will never be merged to anywhere. When
finished, they will be simply closed.
""",

"@start" : """
Start a new branch in stream. <feature> and <release> branches are started from
<develop>. <hotfix> and <support> branches are started from <master>.

syntax:
{{{hg flow <stream> start <name> [<option>...]}}}

options:
 -r --rev REV       Revision to start a new branch from.
 -m --message TEXT  Record TEXT as commit message when open new branch.
 -d --date DATE     Record the specified DATE as commit date.
 
The new branch is named after <stream-prefix>/<name>.
""",

"@finish" : """
Finishing a branch in stream means to close the branch and merge the branch to
destination stream(s). <feature> branches will be merged to <develop>, and
<release> and <hotfix> branches will be merged to both <develop> and <master>.
<support> branches will not be merged to anywhere, and they will only be closed.
Note that merging to a non-trunk <develop> branch will cause the <develop>
branch to be merged into the <develop> trunk.

syntax:
{{{hg flow <stream> finish [<option>...]}}}

The workspace branch will be finished. The branch must be in the specified
<stream>.

options:
 -c --commit        Commit changes before close the branch.
 -m --message TEXT  Record TEXT as commit message.
 -d --date DATE     Record the specified DATE as commit date.
""",

"@push" : """
Push the workspace branch to the remote repository.

syntax:
{{{hg flow <stream> push}}}

alternative syntax:
{{{hg flow <stream> publish}}}
The two syntaxes are completely equivalent.

The workspace branch must be in <stream>.
""",

"@publish" : """
Push the workspace branch to the remote repository.

syntax:
{{{hg flow <stream> publish}}}

alternative syntax:
{{{hg flow <stream> push}}}
The two syntaxes are completely equivalent.

The workspace branch must be in <stream>.
""",

"@pull" : """
Pull a branch named after <stream-prefix>/<name> from the remote repository and
update the workspace. If <name> is not specified, it defaults to the workspace
branch.

syntax:
{{{hg flow <stream> pull [<name>]}}}

The pulled branch must be in <stream>.
""",

"@list" : """
List all open branches in <stream>.

syntax:
{{{hg flow <stream> list}}}

alternative syntax:
{{{hg flow <stream>}}}
If <stream> has trunk (e.g., <develop> and <master>), this syntax will update
the workspace to the trunk besides listing all open branches in <stream>. If
<stream> does not have trunk (e.g., <feature>, <release>, <hotfix>, and
<support>), this syntax is completely equivalent to the other one.

option:
-c --closed    Show open and closed branches in <stream>.
""",

"@log" : """
Show revision history of the specified branch, which must be in <stream>.
syntax:
{{{hg flow <stream> log [<basename>]}}}
where <basename> is of the branch name, e.g., if a branch's name is
'feature/colored_help', its basename relative to <feature> (assuming the
branch name prefix is 'feature/') is 'colored_help'.
If <basename> is missing, it will default to the workspace branch.

Show revision history of a single file in the workspace branch.
syntax:
{{{hg flow <stream> log <filename>}}}
If <filename> happens to be the same as the basename of a branch in <stream>,
it will be recognized as the basename.

alternative syntax:
{{{hg flow <stream> log -F <filename>}}}
Use this syntax to avoid the potential ambiguity with the prior syntax. Also,
you can specify multiple file names to show revision history of these files.

Show revision history of specified files in a designated branch.
syntax:
{{{hg flow <stream> log <basename> -F <filename>}}}

options:
 -F --file FILE [+]  File to show history of.
 -d --date DATE      Show revisions matching date spec.
 -k --keyword TEXT   Do case-insensitive search for a given text.
 -p --patch          Show patch.
 -g --git            Use git extended diff format to show patch.
 -l --limit VALUE    Limit number of changesets displayed.
 
[+] marked option can be specified multiple times.
""",
        
"@abort" : """
Abort the workspace branch, which is to simply close the branch.

syntax:
{{{hg flow <stream> abort [-m <TEXT>]}}}

option:
 -m --message TEXT  Record TEXT as commit message when close branch.
""",

"@promote" : """
Merge the workspace branch to destination branches. The destination branches,
if omitted, will default to the trunk of the destination stream. The destination
streams of basic streams are listed as follows:

   stream          destination
------------+-----------------------
 <feature>    <develop>
 <develop>    n/a
 <release>    <develop> & <master>
 <hotfix>     <develop> & <master>
 <master>     n/a
 <support>    n/a
 natural      stream-trunk
 
syntax:
{{{hg flow <stream> promote [<branch-full-name>...] [<option>...]}}}

The workspace branch must be in <stream>. If the `-r` option is omitted, its
value will default to the head of the workspace branch.

option:
-r --rev REV       Revision to promote to other branches.
-m --message TEXT  Record TEXT as commit message when promote branch.
-d --date DATE     Record the specified DATE as commit date.
""",
        
"@rebase" : """
Rebase the workspace branch to the specified revision.

syntax:
{{{hg flow <stream> rebase [-d <rev>]}}}

The workspace branch must be in <stream>. If the destination revision is not
specified, it will default to the source branch of the workspace branch.
""",
        
"@version" : """
Show version of the flow extension.

syntax:
{{{hg flow version}}}
""",

"@init" : """
Initialize the flow extension for the repository. The configuration file: .flow
will be written in the root dir of the repository. The file will be tracked by
hg. If you have multiple open branches, the .flow file should be present and
synchronized in all of them -- init command will do this for you automatically.

syntax:
{{{hg flow init [<option>...]}}}

options:
-f --force  Force reinitializing flow.
""",

"@upgrade" : """
Upgrade the configuration file from v0.7 or v0.8 to v0.9 or later.

syntax:
{{{hg flow upgrade}}}
""",

"@unshelve" : """
Unshelve previously shelved changes by hgflow. Sometimes, unshelving is not
automatically executed because workflow is terminated prematurelly. In such
situations, you can always use the unshelve command to manually restore the
shelved changes.

syntax:
{{{hg flow unshelve}}}
""",

"@terms" : """
Concepts:
- stream
  The entire set of branches of the same type. Stream is not branch, it is a
  set of branches. In general, a stream can contain any number (including zero)
  of branches. The master stream is, however, special in that it contains 1 and
  only 1 branch. The develop stream contains at least one branch.

- basic streams
  Refers to the master, develop, feature, release, hotfix, and support streams
  as predefined in Driessen's model.

- natural streams
  Refers to a set of branches that diverged from and will merge into the same
  branch. The set of branches plus the branch that they diverged from form a
  natural stream. The branch that all the other branches in the same natural
  stream diverged from and will merge into is the trunk of the natural stream.

- trunk
  Trunk is a special branch. A stream can optionally have a trunk, but only one
  trunk at most. For example, master and develop streams each has a trunk,
  whereas feature, release, hotfix, and support streams don't. And all natural
  streams each has a trunk. If a stream has a trunk, all branches in the stream
  normally should diverge from the trunk and later merge to the trunk when they
  are finished.
  Trunk is a relative concept. A trunk of a stream may be a regular branch of
  another stream. (The former stream will be called a substream of the latter.)

- source
  Source is an attribute of stream. The source of a stream refers to the stream
  where branches in the current stream are created from. A stream's source can
  be the stream itself. But this is not always the case, for example,
  the sources of release and feature streams are the develop stream.

- destin
  Destin is another attribute of stream. The destin of a stream refers to the
  stream(s) where branches in the current stream will merge to. A stream's
  destin can be the stream itself. But this is not always the case,
  for example, the destin of release is the develop and the master streams.

- fullname
  Branch name as recognized by the SCM, e.g., feature/enhance_log.

- basename
  Branch name recognized by flow, but not necessarily by SCM, e.g.,
  enhanced_log (with prefix 'feature/' dropped).

- flow action
  Refer to action on a specified stream, e.g., hg flow feature start, where
  'start' is an action.

- flow command
  Commands don't act on a stream, e.g., hg flow unshelve, where 'unshelve'
  is a command.

- hg command
  Refer to commands not from flow extension.

- workflow
  Refer to the process of executing a sequence of hg commands.

- history
  Refer to a sequence of executed hg commands.

Notatioins
- <stream>
  Examples: <feature>, <hotfix>. These denote the corresponding streams. When
  you refer to a stream, e.g., feature stream, use '<feature>' (or more
  verbosely 'feature stream'), instead of '<feature> stream', because
  '<feature>' already means stream.

- <stream> branch
  Example: a <feature> branch. This phrase refers a branch in <feature>. Do not
  use 'a feature branch' to mean a branch in <feature> because the word
  'feature' there should take its usual meaning as in English, which doesn't
  necessarily mean the feature stream.
""",

"@help" : """
Show online help and then quit. An argument can be optionally given after the
'help' command to specify a particular help topic. Detailed online help is
available for the following topics:
  @all        - Show detailed help for all supported topics.
  @<stream>   - Show help about a particular stream, e.g., {{{@feature}}}, {{{@master}}}.
  @<action>   - Show help about an action, e.g., {{{@finish,}}} {{{@log}}}.
  @<command>  - Show help about a command, e.g., {{{@help}}}, {{{@unshelve}}}.
  @terms      - Show explanations of terminologies used in hgflow.
  @examples   - Show a few command examples.
  @deprecated - Show a list of deprecated features.""",
}

    def __init__( self, ui, repo ) :
        self.ui   = ui
        self.repo = repo



    def _print( self, s ) :
        """
        Print text with predefined effects.
        @type  s: C{str}
        @param s: String to be printed
        """
        import re
        code_pattern = re.compile( "{{{.*?}}}" )
        last_span    = (0, 0,)
        for match in code_pattern.finditer( s ) :
            span = match.span()
            self.ui.write( s[last_span[1]:span[0]] )
            self.ui.write( s[span[0] + 3:span[1] - 3], label = "flow.help.code" )
            last_span = span
        self.ui.write( s[last_span[1]:] )
        
        
        
    def print_help( self, topic = None, *arg, **opts ) :
        """
        Print help information.

        @type  topic : C{str} or C{None}
        @param topic : Help topic
        """
        if (topic is None) :
            self._print( self.SHORT_USAGE )
        elif (topic == "@all") :
            doc = self.TOPIC.items()
            doc.sort()
            for t, help in doc :
                self.ui.write( "%s" % t, label = "flow.help.topic" )
                self._print( "%s\n" % help )
        else :
            try :
                help_content = self.TOPIC[topic]
                self.ui.write( "%s" % topic, label = "flow.help.topic" )
                self._print( "%s\n" % help_content )
            except KeyError :
                _error( self.ui, "Unknown topic: %s" % topic )
                if (("@" + topic) in self.TOPIC or topic == "all") :
                    _error( self.ui, "Did you mean '@%s'?" % topic )
                _print( self.ui, """Supported topics are the following:
  @all        - Show detailed help for all supported topics.
  @<stream>   - Show help about a particular stream, e.g., @feature, @master.
  @<action>   - Show help about an action, e.g., @finish, @log.
  @<command>  - Show help about a command, e.g., @help, @unshelve.
  @<option>   - Show help about an option, e.g., @-F, @--history.
  @examples   - Show a few command examples.
  @deprecated - Show a list of deprecated features.
""" )
    


OPT_FILTER = {
"init"    : ("force",),
"start"   : ("rev", "message", "date",),
"finish"  : ("commit", "message", "date", "onstream",),
"list"    : ("closed",),
"log"     : ("file", "date", "keyword", "patch", "git", "limit", "graph", "onstream",),
"abort"   : ("onstream", "message",),
"promote" : ("rev", "message", "date", "onstream",),
"rebase"  : ("dest", "onstream",),
}

OPT_CONFLICT = {
"dest"   : ("-d", '',   ),     # (short-form-of-option, default-value,)
"date"   : ("-d", '',   ),
"closed" : ("-c", False,),
"commit" : ("-c", False,),
}

def _getopt( ui, key, opt ) :
    """
    Return user-specified options.

    We cannot separate options for different subcommands because of the design of the C{cmdtable}. So ambiguity exists for some
    options. For example, the C{-d} option, it means C{dest} for C{rebase} and C{date} for C{finish}. For either of the two
    actions, the value of the C{-d} option could be saved in C{dest} or C{date}. In general, we don't know which one.

    We have to do a bit of parsing to resolve potential ambiguity. This function is here for that purpose. C{opt} is the raw
    option C{dict} from C{hg}. We will reparse it a bit for a particular command or action given by C{key}. The function
    returns a C{dict} that contains the option's name and its value.
    N.B.:
    (1) If the value of an option evaluates to false, the option will be absent in the returned C{dict} object.
    (2) This function will mutate and return C{opt}.

    @type   ui: C{mercurial.ui}
    @param  ui: Mercurial user interface object
    @type  key: C{str}
    @param key: Command or action for which you are getting the options
    @type  opt: C{dict}
    @param opt: Raw options
    
    @raise AbortFlow: AbortFlow exception will be raised if there is option error.
    """
    ret       = {}
    rec_short = []    # A list of recoginized short options
    for e in OPT_FILTER.get( key, [] ) :
        if (opt.get( e )) :
            ret[e] = opt[e]
        elif (e in OPT_CONFLICT) :
            short_opt, default_value = OPT_CONFLICT[e]
            argv = sys.argv
            if (short_opt in argv) :
                rec_short.append( short_opt )
                if (isinstance( default_value, str )) :
                    index  = argv.index( short_opt )
                    try :
                        ret[e] = argv[index + 1]
                    except IndexError :
                        raise AbortFlow( "Value not found for %s option." % short_opt )
                else :
                    ret[e] = not default_value

    bad_opt = [e for e in     opt if (e not in (["history", "dry_run",] + ret.keys()) and opt[e])  ]
    bad_opt = [e for e in bad_opt if (e in sys.argv) or (OPT_CONFLICT.get( e, [0,] )[0] not in rec_short)]
    
    if (bad_opt) :
        bad_opt = [e.replace( "_", "-" ) for e in bad_opt]
        if (key is None) :
            raise AbortFlow( "Unrecognized option%s for `hg flow`: %s." %
                             ("" if (len( bad_opt ) == 1) else "s", "--" + (", --".join( bad_opt )),),
                             "`hg flow` should take no options." )
        else :
            raise AbortFlow( "Unrecognized option%s for `%s`: %s." %
                             ("" if (len( bad_opt ) == 1) else "s", key, "--" + (", --".join( bad_opt )),),
                             "Execute `hg flow help @%s` to see available options for `%s`." % (key, key,) )
            
    return ret



cmdtable = {
"flow" :
    (flow_cmd,
     [("",  "history",   False, _("Print history of hg commands used in this workflow."),                          ),
      ("",  "dry-run",   None,  _("Do not perform actions, just print history."),                                  ),
      ("f", "force",     False, _("Force reinitializing flow. [init]"),                                            ),
      ("r", "rev",       '',    _("Revision to start a new branch from. [start]"),                       _('REV'), ),
      ("c", "commit",    False, _("Commit changes before closing the branch. [finish]"),                           ),
      ("d", "date",      '',    _("Record the specified date as commit date. [start, finish, promote]"), _('DATE'),),
      ("m", "message",   '',    _("Record TEXT as commit message. [start, finish, promote, abort]"),     _('TEXT'),),
      ("c", "closed",    False, _("Show normal and closed branches in stream. [list]"),                            ),
      ("F", "file",      [],    _("File to show history of. [log]"),                                     _('FILE'),),
      ("d", "date",      '',    _("Show revisions matching date spec. [log]"),                           _('DATE'),),
      ("k", "keyword",   '',    _("Do case-insensitive search for a given text. [log]"),                 _('TEXT'),),
      ("p", "patch",     False, _("Show patch. [log]"),                                                            ),
      ("g", "git",       False, _("Use git extended diff format to show patch. [log]"),                            ),
      ("l", "limit",     '',    _("Limit number of changesets displayed. [log]"),                                  ),
      ("r", "rev",       '',    _("Revision to promote to other branches. [promote]"),                   _('REV'), ),
      ("d", "dest",      '',    _("Destination changeset of rebasing. [rebase]"),                        _('REV' ),),
      ("s", "onstream",  False, _("Act on stream. [finish, rebase, log, abort]"),                                  ),
     ],
     "hg flow {<stream> [<action> [<arg>]] | <command>} [<option>...]",
     ),

"flow-init" :
    (flow_init_cmd,
     [("f", "force",   False, _("Force reinitializing flow."),),
      ("",  "history", False, _("Print history of hg commands used by this flow command."),),
      ],
     ("hg flow-init"),
     ),
}
