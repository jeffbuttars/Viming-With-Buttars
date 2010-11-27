"""
NiceMenu.py	
(c) Copyright 2010 Jeff Buttars. All Rights Reserved.
"""

# System Imports
import threading
import vim
import subprocess
from Queue import Queue, Empty

# Regional Imports

compl_res = None

class LogThread( threading.Thread ):
	""""""

	def run( self ):
		"""docstring for run"""
		self.alive = True
		fd = open( '/tmp/vim.log', 'w' )
		while self.alive:
			# try forever until we get some data
			logEntry = NiceMenu_logQ.get(True)
			fd.write( "%s\n" % logEntry )
			fd.flush()

		nmlog( "LogThread stopping", 'debug')
		fd.close()
	#run()
		
#LogThread

class CmdThread( threading.Thread ):

	def run( self ):
		nmlog( "CmdThread.run()", 'debug'  )
		self.alive = True
		self.curPos = None
		while self.alive:
			try:
				# try forever until we get some data
				item = NiceMenu_cmdQ.get(True)
				nmlog( "CmdThread.run() item:%s" % item, 'debug'  )
				try:
					self.processCMD( item['cmd'], item['args'] )
				except Exception as e:
					nmlog( "CmdThread.run() caught exception:%s" % e, 'debug'  )
			except Exception:
				pass


		nmlog( "CmdThread.run() stopping", 'debug'  )
	#run()

	def getCurWord( self, line, pos ):
		"""docstring for getCurWord"""
		nmlog( "NiceMenu.CmdThread.getCurWord (line:%s,pos:%s)" % (line, pos), 'debug' )
		line = vim.current.line
		wlist = line[0:int(pos[2],10)].split()

		if not wlist:
			cw = ""
		else:
			cw = wlist[-1]

		nmlog( "NiceMenu.CmdThread.getCurWord %s" % cw, 'debug' )
		return cw
	#getCurWord()

	def getWordMin( self ):
		"""docstring for getWordMin"""
		#try:
			#wm = vim.eval( "b:NiceMenuMin" )
		#except:
			#wm = vim.eval( "g:NiceMenuMin" )
		#return wm 
		return int(vim.eval( "g:NiceMenuMin" ), 10 )
	#getWordMin()

	def getOmniWord( self, spoint ):
		"""docstring for getOmniWord"""
		if not self.curPos:
			return ""
			
		line = self.curPos['line']
		pos = self.curPos['pos']

		nmlog( "NiceMenu.CmdThread.getOmniWord line:'%s', pos:%s, spoint:%s" % (line,pos,spoint), 'debug' )
		ol = line[int(spoint,10):int(pos[2],10)-1]

		nmlog( "NiceMenu.CmdThread.getOmniWord '%s'" % ol, 'debug' )
		return ol
	#getOmniWord()

	def procKeyPress( self, args ):
		"""docstring for procKeyPress"""
		line = args['line']
		npos = args['pos']

		# to see what npos looks like, see help: getpos()
		nmlog( "NiceMenu.CmdThread.processCMD, cmd:NMCMD_KEY_PRESS, pos%s" % npos, 'debug' )

		if self.curPos:
			curPos = self.curPos['pos']
			if curPos and npos[1] == curPos[1] and npos[2] == curPos[2] and npos[3] == curPos[3]:
				nmlog( "NiceMenu.CmdThread.processCMD bad pos, npos:%s, curPos:%s" % ( npos, curPos ), 'debug' )
				return False
		
		cword = self.getCurWord( line, npos )
		if len(cword) < self.getWordMin():
			nmlog( "NiceMenu.CmdThread.processCMD word to short, %s" % ( self.getWordMin() ), 'debug' )
			return False 

		# If it's just a number, don't deal with it.
		# TODO: make optional
		if cword.isdigit():
			nmlog( "NiceMenu.CmdThread.processCMD %s is a digit, no complete" % ( cword ), 'debug' )
			return False 

		#TODO: make optional
		#If we're inside a string, not at the end, don't try to complete
		space_idx = int(npos[2],10)
		if len(line) >= space_idx and not line[space_idx-1].isspace():
			nmlog( "NiceMenu.CmdThread.processCMD %s:%s is in a string, no complete" % ( cword,npos ), 'debug' )
			return False

		# remember what we want to complete
		self.curPos = args 

		# Stop any existing key timers before we start a new one.
		cancel()

		global NiceMenu_ptimer
		#delay = vim.eval("NiceMenuGetDelay()")
		delay = None
		if not delay:
			delay = '.8'
		nmlog( "NiceMenu.CmdThread.procKeyPress starting key timer, %s" % ( delay ), 'debug' )
		NiceMenu_ptimer = threading.Timer( float(delay), keyTimer )
		NiceMenu_ptimer.start()

		return True
	#procKeyPress()


	def processCMD( self, cmd, args=None ):
		"""docstring for processCMD"""
		nmlog( "NiceMenu.CmdThread.processCMD, cmd:%s, args:%s" % ( cmd, args ), 'debug' )

		if cmd == NMCMD_KEY_PRESS:
			return self.procKeyPress( args )
		elif cmd == NMCMD_KEY_TOUT:
			nmlog( "NiceMenu.CmdThread.processCMD, cmd:NMCMD_KEY_TOUT", 'debug' )

			omnifunc = self.remoteExp( "&omnifunc" )

			# test if we have a completion at this cursor position
			# returns -1 if no completion can be made.
			res = self.remoteExp( "%s(1,'')" % omnifunc )

			nmlog( "NiceMenu.CmdThread.processCMD, cmd:NMCMD_KEY_TOUT, checking omnifunc. remote_exp:%s(1,''), res:%s" % ( omnifunc, res ), 'debug' )
			if res == -1:
				nmlog( "NiceMenu.CmdThread.processCMD, cmd:NMCMD_KEY_TOUT, no omnicompletion available" )
				return

			vim.command('let b:completionPos = %s' % (res) )
			#clist = self.remoteExp("%s(0,'%s')" % (omnifunc, self.getOmniWord( res )))
			#nmlog( "NiceMenu.CmdThread.processCMD, cmd:NMCMD_KEY_TOUT, omnicompletion results: %s" % (clist) )
			#compl = vim.command( "let b:NiceMenuCompRes = %s(%s,'%s')" % (
					#item['func'], item['arg1'], item['arg2']) )
			#return

			# Drop our completion function onto the Q
			nmlog( "NiceMenu.CmdThread.processCMD, cmd:NMCMD_KEY_TOUT, omnicompletion available, queueing command." )
			NiceMenu_ActionQ.put_nowait( {'curPos':self.curPos, 'type':'omnifunc', 
				'func':omnifunc, 'arg1':0, 'arg2':self.getOmniWord( res ) } )

			# Calling back to the main vim process via NiceMenuAction()
			# It will pull the fist item off the action queu and run it for us.
			#NiceMenu_ActionQ.put( {'curPos':self.curPos, 'type':'omni', 'data':res } )

			#res = self.remoteExp( "NiceMenuAction()" )
			NiceMenuAction()
			#servername = vim.eval( "v:servername" )
			#vim.command( 'call remote_expr("%s", "NiceMenuAction()")' % ( servername ) )
			#nmlog( "NiceMenu.CmdThread.processCMD, cmd:NMCMD_KEY_TOUT, dumping omnicompletion results: %s" % (compl_res) )

		elif cmd == NMCMD_LEFT_INSERT:
			nmlog( "NiceMenu.CmdThread.processCMD, cmd:NMCMD_LEFT_INSERT", 'debug' )
			self.curPos = None
			cancel()

	def remoteExp( self, exp ):
		"""docstring for remoteExp"""
		nmlog( "NiceMenu.CmdThread.remoteExp %s" % exp, 'debug' )
		servername = vim.eval( "v:servername" )
		if not servername:
			nmlog( "NiceMenu.CmdThread.remoteExp no servername, unable to process remote expr ", 'error' )
		res = vim.eval( "remote_expr(\"%s\", \"%s\")" % ( servername, exp ) )
		#nmlog( "NiceMenu.CmdThread.remoteExp %s,  %s returned:%s" % (servername,exp,res), 'debug' )
		return res
	#remoteExp()


#processCMD()

# CmdThread

def keyTimer():
	"""docstring for keyTimer"""
	nmlog( "NiceMenu.keyTimer() expired", 'debug' )
	sendCmd( NMCMD_KEY_TOUT )
#keyTimer()

def cancel():
	"""docstring for Cancel"""
	nmlog( "NiceMenu.Cancel", 'debug' )
	global NiceMenu_ptimer
	if NiceMenu_ptimer:
		NiceMenu_ptimer.cancel()
#cancel()

def sendCmd( cmd, args=None ):
	"""docstring for NiceMenu.SendCmd"""
	nmlog( "NiceMenu.SendCmd, %s, %s" % ( cmd, args ), 'debug' )
	NiceMenu_cmdQ.put_nowait( { 'cmd':cmd, 'args':args  } )
#sendCmd()

def nmlog( msg, level='info' ):
	"""docstring for nmlog"""
	NiceMenu_logQ.put_nowait( msg )
#nmlog()

def showMenu():

	# Don't show the menu if we're not in insert mode.
	if 'i' != vim.eval('mode()'):
		nmlog( 'NiceMenu.ShowMenu bad context, not in insert mode. mode=%s' %  vim.eval('mode()'), 'debug' )
		return

	try:
		#subprocess.call( ["gvim", "--servername", "%s"%sname, "--remote-send", '<C-R>=NiceMenuAsyncCpl()<CR>'] )
		#nmq_key_trigger.put_nowait( "key trigger: " )
		pass

	except Exception as e:
		nmlog( "NiceMenu.ShowMenu exception:%s" % e, 'error' )

# showMenu()

def NiceMenuAction():
	"""docstring for NiceMenuAction"""

	item = None
	try:
		item = NiceMenu_ActionQ.get_nowait()
	except Exception:
		#print( "NiceMenuAction: nothing on the action q" )
		item = None
		nmlog( "NiceMenuAction: nothing on the action q", 'debug' )

	# Check for spelling suggestions

	win = vim.current.window
	cpos = win.cursor
	npos = (cpos[0], cpos[1]-1)
	win.cursor = npos
	cword = vim.eval( "expand('<cword>')" )
	win.cursor = cpos

	#vim.command('set spell')
	#spell_list = vim.command( "let b:nm_spelllist = spellsuggest('%s')" % (cword) )
	#spell_list = vim.eval( "spellsuggest('%s')" % (cword) )
	#vim.command('set nospell')
	#vim.command('let b:completionPos = %s' % (cpos[1]+1))
	#nmlog( "NiceMenuAction: cword:%s, spell list:%s" % (cword, spell_list), 'debug' )


	servername = vim.eval( "v:servername" )

	if item and item['type'] == 'omnifunc':
		nmlog( "NiceMenuAction: trying: let b:completionList=%s(%s,'%s')" % (  item['func'], item['arg1'], item['arg2'] ), 'debug' )
		vim.command( "let b:completionList=%s(%s,'%s')" % ( item['func'], item['arg1'], item['arg2']) )
		#vim.command('let b:completionPos = %s' % (item['arg1']))
		#vim.command( "call sort(b:completionList)"  )


		if vim.eval('b:completionList'):

			#vim.command( "let b:completionList+=b:nm_spelllist"  )

			vim.command( "set completefunc=NiceMenuCompletefunc" )
			nmlog( "NiceMenuAction: displaying completion..." )
			#vim.command( "call remote_send( \"%s\", '<C-X><C-U>' )" % ( servername ) )
			#vim.command( "call remote_expr( \"%s\", feedkeys(\"\<C-X>\<C-U>\") )" % ( servername ) )
			#vim.command( 'call feedkeys( "\<C-X>\<C-U>" )' )
			# Use a subprocess server call because for reasons
			# I don't know about calling feedkeys or remote_send/expr 
			# has a huge and un acceptable delay.
			subprocess.call( ["gvim", "--servername", "%s"%servername, "--remote-send", '<C-X><C-U>'] )
			nmlog( "NiceMenuAction: sent keys", 'debug' )
		else:
			nmlog( "NiceMenuAction: falling back easy completion", 'debug' )
			subprocess.call( ["gvim", "--servername", "%s"%servername, "--remote-send", '<C-X><C-N>'] )
	else:
		nmlog( "NiceMenuAction: falling back easy completion", 'debug' )
		subprocess.call( ["gvim", "--servername", "%s"%servername, "--remote-send", '<C-X><C-N>'] )
#NiceMenuAction()

def NiceMenuShutdown():
	"""docstring for NiceMenuShutdown"""
	nmlog("NiceMenuShutdown", 'debug')
	logThread.alive = False
	cmdThread.alive = False
	
	if NiceMenu_ptimer:
		NiceMenu_ptimer.cancel()
	# pump the queues so the threads will shutdown.
	NiceMenu_cmdQ.put_nowait( "shutdown" )
	NiceMenu_logQ.put_nowait( "shutdown" )
#NiceMenuShutdown()

# Initialize the global environment
NMCMD_KEY_PRESS = 1
NMCMD_KEY_TOUT = 2
NMCMD_LEFT_INSERT = 4

curPos = None

NiceMenu_cmdQ = Queue()
NiceMenu_ActionQ = Queue()
NiceMenu_logQ = Queue()
NiceMenu_ptimer = None

cmdThread = CmdThread()
cmdThread.start()

logThread = LogThread()
logThread.start()


