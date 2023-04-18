import std/math
#import std/os
import strutils
import std/streams
import std/times
import CommonImports

#Function Declarations
proc logflush*(): void
proc logf*(str: string): void
proc logf*(arg1: int): void
proc logf*(str: string, arg1: int): void
proc logf*(str: string, arg1: cstring, arg2: int): void
proc logf*(str: string, arg1: int, arg2: int): void
proc logf*(str: string, arg1: int, arg2: int64): void
proc logf*(str: string, arg1: int, arg2: int, arg3: int): void
proc logf*(str: string, arg1: int, arg2: int, arg3: int, arg4: int): void
proc logf*(str: string, arg1: string): void
proc logf*(str: string, arg1: cstring): void
proc logf*(str: string, arg1: string, arg2: int): void
proc logf*(str: string, arg1: float): void
proc openLogger*(fname: string): void
proc openLogger*(): void
proc closeLogger*(): void




var LOG_FILE* = "logger.log"

#var logstream* = newFileStream(LOG_FILE, fmWrite)
var logstream:FileStream



proc logflush*(): void =
#{
   flush(logstream)
   logstream.flush()
   flushFile(stdout)
#}
proc logf*(str: string): void =
#{
   let dt = getDateStr()
   let tm = getClockStr()
   var logstr:string
   logstr.add("[")
   logstr.add(tm)
   logstr.add(":")
   logstr.add(dt)
   logstr.add("] ")
   logstr.add(str)
   #logstr.add("\n")
   if (logstream == nil):
     return
   logstream.writeLine(logstr)
   flush(logstream)
   logstream.flush()
   flushFile(stdout)
#}

proc logf*(arg1: int): void =
#{
   #var strout: string = newString(len(str) + sizeof(arg1))
   #discard snprintf(strout.cstring, 128, str.cstring, arg1.cint)
   var strout: string = newString(128)
   var slen = sprintf(strout.cstring,"%d",arg1.cint)
   strout.setLen(slen)
   logf(strout)
#}

proc logf*(str: string, arg1: int): void =
#{
   #var strout: string = newString(len(str) + sizeof(arg1))
   #discard snprintf(strout.cstring, 128, str.cstring, arg1.cint)
   var strout: string = newString(128)
   var slen = sprintf(strout.cstring, str.cstring, arg1.cint)
   strout.setLen(slen)
   logf(strout)
#}

proc logf*(str: string, arg1: cstring, arg2: int): void =
#{
   #var strout: string = newString(len(str) + sizeof(arg1))
   #discard snprintf(strout.cstring, 128, str.cstring, arg1.cint)
   var strout: string = newString(128)
   var slen = sprintf(strout.cstring, str.cstring, arg1, arg2.cint)
   strout.setLen(slen)
   logf(strout)
#}


proc logf*(str: string, arg1: int, arg2: int): void =
#{
   var strout: string = newString(128)
   #discard snprintf(strout.cstring, 128, str.cstring, arg1.cint, arg2.cint)
   var slen = sprintf(strout.cstring, str.cstring, arg1.cint, arg2.cint)
   strout.setLen(slen)
   logf(strout)
#}

proc logf*(str: string, arg1: int, arg2: int64): void =
#{
   var strout: string = newString(128)
   #discard snprintf(strout.cstring, 128, str.cstring, arg1.cint, arg2.cint)
   var slen = sprintf(strout.cstring, str.cstring, arg1.cint, arg2.cint)
   strout.setLen(slen)
   logf(strout)
#}

proc logf*(str: string, arg1: int, arg2: int, arg3: int): void =
#{
   var strout: string = newString(128)
   #discard snprintf(strout.cstring, 128, str.cstring, arg1.cint, arg2.cint, arg3.cint)
   var slen = sprintf(strout.cstring, str.cstring, arg1.cint, arg2.cint, arg3.cint)
   strout.setLen(slen)
   logf(strout)
#}

proc logf*(str: string, arg1: int, arg2: int, arg3: int, arg4: int): void =
#{
   var strout: string = newString(128)
   #discard snprintf(strout.cstring, 128, str.cstring, arg1.cint, arg2.cint, arg3.cint, arg4.cint)
   var slen = sprintf(strout.cstring, str.cstring, arg1.cint, arg2.cint, arg3.cint, arg4.cint)
   strout.setLen (slen)
   logf(strout)
#}

proc logf*(str: string, arg1: string): void =
#{
   var strout: string = newString(128)
   #discard snprintf(strout.cstring, 128, str.cstring, arg1.cstring)
   var slen = sprintf(strout.cstring, str.cstring, arg1.cstring)
   strout.setLen (slen)
   logf(strout)
#}

proc logf*(str: string, arg1: cstring): void =
#{
   var strout: string = newString(128)
   #discard snprintf(strout.cstring, 128, str.cstring, arg1)
   var slen = sprintf(strout.cstring, str.cstring, arg1.cstring)
   strout.setLen (slen)
   logf(strout)
#}

proc logf*(str: string, arg1: string, arg2: int): void =
#{
   var strout: string = newString(128)
   #discard snprintf(strout.cstring, 128, str.cstring, arg1)
   var slen = sprintf(strout.cstring, str.cstring, arg1.cstring, arg2.cint)
   strout.setLen (slen)
   logf(strout)
#}


proc logf*(str: string, arg1: float): void =
#{
   var strout: string = newString(128)
   #discard snprintf(strout.cstring, 128, str.cstring, arg1.cfloat)
   var slen = sprintf(strout.cstring, str.cstring, arg1.cfloat)
   strout.setLen (slen)
   logf(strout)
#}

proc openLogger*(fname: string): void =
#{
   if (logstream != nil):
     close(logstream)
   logstream = newFileStream(fname, fmWrite)
   logf("LOGGER STARTED for log file [%s]", LOG_FILE)
#}


proc openLogger*(): void =
#{
   logstream = newFileStream(LOG_FILE, fmWrite)
   logf("LOGGER STARTED for log file [%s]", LOG_FILE)
#}

proc closeLogger*(): void =
#{
   if (logstream == nil):
     return
   logf("LOGGER STOPPED for log file [%s]", LOG_FILE)
   close(logstream)
#}
