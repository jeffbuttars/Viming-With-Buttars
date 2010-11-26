"""
NiceMenu.py	
(c) Copyright 2010 Jeff Buttars. All Rights Reserved.
"""

# System Imports
import threading
import vim
#import subprocess
from Queue import Queue

# Regional Imports


class logThread( threading.Thread ):
	""""""

	def run( self ):
		"""docstring for run"""
		fd = open( '/tmp/vim.log', 'w' )
		while True:
			# try forever until we get some data
			logEntry = NiceMenu_logQ.get(True)
			fd.write( "%s\n" % logEntry )
			fd.flush()
	#run()
		
#logThread

class cmdThread( threading.Thread ):

	def run( self ):
		nmlog( "cmdThread.run()", 'debug'  )
		self.curPos = None
		while True:
			# try forever until we get some data
			item = NiceMenu_cmdQ.get(True)
			try:
				self.processCMD( item['cmd'], item['args'] )
			except Exception as e:
				nmlog( "cmdThread.run() caught exception:%s" % e, 'debug'  )

	#run()

	def getCurWord( self, line, pos ):
		"""docstring for getCurWord"""
		nmlog( "NiceMenu.cmdThread.getCurWord (line:%s,pos:%s)" % (line, pos), 'debug' )
		line = vim.current.line
		wlist = line[0:int(pos[2],10)].split()

		if not wlist:
			cw = ""
		else:
			cw = wlist[-1]

		nmlog( "NiceMenu.cmdThread.getCurWord %s" % cw, 'debug' )
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

		nmlog( "NiceMenu.cmdThread.getOmniWord line:%s, pos:%s, spoint:%s" % (line,pos,spoint), 'debug' )
		ol = line[int(spoint,10):int(pos[2],10)-1]

		nmlog( "NiceMenu.cmdThread.getOmniWord %s" % ol, 'debug' )
		return ol
	#getOmniWord()


	def procKeyPress( self, args ):
		"""docstring for procKeyPress"""
		line = args['line']
		npos = args['pos']

		# to see what npos looks like, see help: getpos()
		nmlog( "NiceMenu.cmdThread.processCMD, cmd:NMCMD_KEY_PRESS, pos%s" % npos, 'debug' )

		if self.curPos:
			curPos = self.curPos['pos']
			if curPos and npos[1] == curPos[1] and npos[2] == curPos[2] and npos[3] == curPos[3]:
				nmlog( "NiceMenu.cmdThread.processCMD bad pos, npos:%s, curPos:%s" % ( npos, curPos ), 'debug' )
				return False
		
		cword = self.getCurWord( line, npos )
		if len(cword) < self.getWordMin():
			nmlog( "NiceMenu.cmdThread.processCMD word to short, %s" % ( self.getWordMin() ), 'debug' )
			return False 

		# If it's just a number, don't deal with it.
		# TODO: make optional
		if cword.isdigit():
			nmlog( "NiceMenu.cmdThread.processCMD %s is a digit, no complete" % ( cword ), 'debug' )
			return False 

		#TODO: make optional
		#If we're inside a string, not at the end, don't try to complete
		space_idx = int(npos[2],10)
		if len(line) >= space_idx and not line[space_idx-1].isspace():
			nmlog( "NiceMenu.cmdThread.processCMD %s:%s is in a string, no complete" % ( cword,npos ), 'debug' )
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
		nmlog( "NiceMenu.cmdThread.processCMD starting key timer, %s" % ( delay ), 'debug' )
		NiceMenu_ptimer = threading.Timer( float(delay), keyTimer )
		NiceMenu_ptimer.start()

		return True
	#procKeyPress()


	def processCMD( self, cmd, args=None ):
		"""docstring for processCMD"""
		nmlog( "NiceMenu.cmdThread.processCMD, cmd:%s, args:%s" % ( cmd, args ), 'debug' )

		if cmd == NMCMD_KEY_PRESS:
			return self.procKeyPress( args )
		elif cmd == NMCMD_KEY_TOUT:
			nmlog( "NiceMenu.cmdThread.processCMD, cmd:NMCMD_KEY_TOUT", 'debug' )

			omnifunc = self.remoteExp( "&omnifunc" )

			res = self.remoteExp( "%s(1,'')" % omnifunc )
			nmlog( "NiceMenu.cmdThread.processCMD, cmd:NMCMD_KEY_TOUT, remote_exp:%s" % ( res ), 'debug' )

			#res = self.remoteExp( "%s(0,'%s')" % ( omnifunc, self.getOmniWord( res ) ) )
			NiceMenu_ActionQ.put_nowait( {'curPos':self.curPos, 'type':'omnifunc', 
				'func':omnifunc, 'arg1':0, 'arg2':self.getOmniWord( res ) } )

			#NiceMenu_ActionQ.put( {'curPos':self.curPos, 'type':'omni', 'data':res } )
			res = self.remoteExp( "NiceMenuAction()"  )

		elif cmd == NMCMD_LEFT_INSERT:
			nmlog( "NiceMenu.cmdThread.processCMD, cmd:NMCMD_LEFT_INSERT", 'debug' )
			self.curPos = None
			cancel()

	def remoteExp( self, exp ):
		"""docstring for remoteExp"""
		nmlog( "NiceMenu.cmdThread.remoteExp %s" % exp, 'debug' )
		servername = vim.eval( "v:servername" )
		if not servername:
			nmlog( "NiceMenu.cmdThread.remoteExp no servername, unable to process remote expr ", 'error' )
		res = vim.eval( "remote_expr(\"%s\", \"%s\")" % ( servername, exp ) )
		#nmlog( "NiceMenu.cmdThread.remoteExp %s,  %s returned:%s" % (servername,exp,res), 'debug' )
		return res
	#remoteExp()

#processCMD()

# cmdThread

def keyTimer():
	"""docstring for keyTimer"""
	nmlog( "NiceMenu.keyTimer()", 'debug' )
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

# Initialize the global environment


NMCMD_KEY_PRESS = 1
NMCMD_KEY_TOUT = 2
NMCMD_LEFT_INSERT = 4

curPos = None

NiceMenu_cmdQ = Queue()
NiceMenu_ActionQ = Queue()
NiceMenu_logQ = Queue()
NiceMenu_ptimer = None

(logThread()).start()
(cmdThread()).start()
