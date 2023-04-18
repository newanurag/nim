######################################################################
# Ring Buffer Module Implementation
######################################################################

import os
import std/terminal
import std/[asyncnet, asyncdispatch]
import RingBufferHeader

#######################################################
# cls() : echo based on debug flag
#######################################################
proc cls*():void =
#{
  eraseScreen(stdout)
#}

#######################################################
# log() : echo based on debug flag
#######################################################
proc log*(data: string):void =
#{
   logstr.add(data)
   if (RingBufferObject.rb_debug == true):
     echo data
#}

proc logxy*(data: string, x: int, y: int):void =
#{
   var col = x
   var row = y
   setCursorPos(col,row)
   stdout.write(data)
#}

#######################################################
# logr() : log raw value independent of debug flag
#######################################################
proc logr*(data: string):string {.discardable.} =
#{
   logrstr.add(data)
   #[
   if (data == "\n"):
     logrstrarray.add(logrstr)
     logrstr = ""
   else:
     logrstr.add(data)

   ]#
   if (RingBufferObject.rb_debug == true):
     stdout.write(data)
#}

#######################################################
# setDebug()
#######################################################
proc setDebug(obj: ref RingBuffer, flag: bool): void =
#{
   obj.rb_debug = flag
#}

#######################################################
# reset()
#######################################################
proc reset(obj: ref RingBuffer): void =
#{
   for i in 1..obj.getSize(obj):
     let rbdata = obj.getBufferData(obj)

   obj.rb_readidx  = -1
   obj.rb_writeidx = -1
#}

#######################################################
# isEmpty()
#######################################################
proc isEmpty(obj: ref RingBuffer): bool =
#{
   if (obj.rb_count == 0):
     return true
   else:
     return false
#}

#######################################################
# isFull()
#######################################################
proc isFull(obj: ref RingBuffer): bool =
#{
   if (obj.rb_count == obj.rb_size):
     return true
   else:
     return false
#}

#######################################################
# getSize()
#######################################################
proc getSize(obj: ref RingBuffer): int =
#{
   return obj.rb_size
#}

#######################################################
# getCount()
#######################################################
proc getCount(obj: ref RingBuffer): int =
#{
   return obj.rb_count
#}

#######################################################
# setBufferData()
#######################################################
proc setBufferData(obj: ref RingBuffer, data: ref string):int =
#{
   var idx = (obj.rb_writeidx + 1) mod obj.rb_size

   if (obj.rb_type == RB_STATIC):
     if (obj.rb_sbuffer[idx] == nil):
       obj.rb_sbuffer[idx] = data
       obj.rb_writeidx = idx
       obj.rb_count = obj.rb_count + 1
     else:
       log "RB:Static is FULL"
       return RB_FAILURE

   if (obj.rb_type == RB_DYNAMIC):
     if (obj.rb_dbuffer[idx] == nil):
       obj.rb_dbuffer[idx] = data
       obj.rb_writeidx = idx
       obj.rb_count = obj.rb_count + 1
     else:
       log "RB:Dynamic is FULL"
       return RB_FAILURE

   log("Data [" & data[] & "] added to RingBuffer")
   return RB_SUCCESS
#}

#######################################################
# getBufferData()
#######################################################
proc getBufferData(obj: ref RingBuffer): ref string =
#{
   if (obj.rb_type == RB_STATIC):
     var idx = (obj.rb_readidx + 1) mod obj.rb_size
     var data = obj.rb_sbuffer[idx]
     if (data == nil):
       log("RB:Static is already empty")
     else:
       obj.rb_sbuffer[idx] = nil
       obj.rb_readidx = idx
       obj.rb_count = obj.rb_count - 1

     log("Data [" & data[] & "] pickedup from RingBuffer")
     return data

   if (obj.rb_type == RB_DYNAMIC):
     var idx = (obj.rb_readidx + 1) mod obj.rb_size
     var data = obj.rb_dbuffer[idx]
     if (data == nil):
       log("RB:Dynamic is already empty")
     else:
       obj.rb_dbuffer[idx] = nil
       obj.rb_readidx = idx
       obj.rb_count = obj.rb_count - 1
       log("Data [" & data[] & "] pickedup from RingBuffer")
     return data

   return nil
#}

#######################################################
# getBufferDataBack()
#######################################################
proc getBufferDataBack(obj: ref RingBuffer): ref string =
#{
   if (obj.rb_type == RB_STATIC):
     var data = obj.rb_sbuffer[obj.rb_writeidx]
     if (data != nil):
       obj.rb_sbuffer[obj.rb_writeidx] = nil
       if (obj.rb_writeidx == 0):
         obj.rb_writeidx = obj.rb_size
       else:
         obj.rb_writeidx = obj.rb_writeidx - 1
       return data
     else:
       return nil

   if (obj.rb_type == RB_DYNAMIC):
     var data = obj.rb_dbuffer[obj.rb_writeidx]
     if (data != nil):
       obj.rb_dbuffer[obj.rb_writeidx] = nil
       if (obj.rb_writeidx == 0):
         obj.rb_writeidx = obj.rb_size
       else:
         obj.rb_writeidx = obj.rb_writeidx - 1
       return data
     else:
       return nil
#}

#######################################################
# getStatus()
#######################################################
proc getStatus(obj: ref RingBuffer):void =
#{
  if (obj.rb_type == RB_STATIC):
    log("RingBuffer:Type    :" & $(obj.rb_type) & " STATIC i.e. Array Based")

  if (obj.rb_type == RB_DYNAMIC):
    log("RingBuffer:Type    :" & $(obj.rb_type) & " DYNAMIC i.e. Array Based")

  log("RingBuffer:rb_size    :" & $obj.rb_size)
  log("RingBuffer:Entries :" & $obj.rb_count)
  log("RingBuffer:rb_readidx :" & $obj.rb_readidx)
  log("RingBuffer:rb_writeidx:" & $obj.rb_writeidx)
  log("RingBuffer Entries:")

  if (obj.rb_type == RB_STATIC):
    for idx, element in obj.rb_sbuffer:
      logr("[" & $idx & "] ")
      if (element == nil):
        logr("NULL")
      else:
        var str:string = element[]
        logr(str)
      logr("\n")

  if (obj.rb_type == RB_DYNAMIC):
    for idx, element in obj.rb_dbuffer:
      logr("[" & $idx & "] ")
      if (element == nil):
        logr("NULL")
      else:
        var str:string = element[]
        logr(str)
      logr("\n")

#}

proc printStatic(obj: ref RingBuffer):void =
#{

  if (obj.rb_type == RB_STATIC):
    logr("[ ")
    for idx, element in obj.rb_sbuffer:
      if (element == nil):
        logr("====")
      else:
        var str:string = element[]
        for i in 1 .. len(str):
          logr("=")

      if idx == high(obj.rb_sbuffer):
        logr(" ]")
      else:
        logr("=|=")

    logr("\n")

    logr("[ ")
    for idx, element in obj.rb_sbuffer:
      if (element == nil):
        logr("    ")
      else:
        var str:string = element[]
        logr(str)

      if idx == high(obj.rb_sbuffer):
        logr(" ]")
      else:
        logr(" | ")

    logr("\n")
    logr("[ ")
    for idx, element in obj.rb_sbuffer:
      if (element == nil):
        logr("====")
      else:
        var str:string = element[]
        for i in 1 .. len(str):
          logr("=")

      if idx == high(obj.rb_sbuffer):
        logr(" ]")
      else:
        logr("=|=")
#}

proc printDynamic(obj: ref RingBuffer):void =
#{
  var printstr:string

  if (obj.rb_type == RB_DYNAMIC):
    logr("[ ")
    for idx, element in obj.rb_dbuffer:
      if (element == nil):
        logr("====")
      else:
        var str:string = element[]
        for i in 1 .. len(str):
          logr("=")

      if idx == high(obj.rb_dbuffer):
        logr(" ]")
      else:
        logr("=|=")

    logr("\n")

    logr("[ ")
    for idx, element in obj.rb_dbuffer:
      if (element == nil):
        logr("    ")
      else:
        var str:string = element[]
        logr(str)

      if idx == high(obj.rb_dbuffer):
        logr(" ]")
      else:
        logr(" | ")

    logr("\n")
    logr("[ ")
    for idx, element in obj.rb_dbuffer:
      if (element == nil):
        logr("====")
      else:
        var str:string = element[]
        for i in 1 .. len(str):
          logr("=")

      if idx == high(obj.rb_dbuffer):
        logr(" ]")
      else:
        logr("=|=")
#}

proc print(obj: ref RingBuffer) {.async.} =
#{
  var col = 0
  var row = 1
  cls()
  setCursorPos(col,row)
  printStatic(obj)
  printDynamic(obj)
  #await sleepAsync(1000)
#[
  while true:
    setCursorPos(col,row+2)
    printStatic(obj)
    printDynamic(obj)
    await sleepAsync(1000)
]#

  logr("\n")
#}

proc printxy(obj: ref RingBuffer, x:int, y:int) {.async.} =
#{
  var col = x
  var row = y
  setCursorPos(col,row)
  logrstr = ""
  printStatic(obj)
  printDynamic(obj)
  stdout.write(logrstr)
  flushFile(stdout)
  #[
  for element in logrstrarray:
    setCursorPos(col,row)
    stdout.write(element)
    flushFile(stdout)
    row = row + 1
  setCursorPos(col,row)
  stdout.write(logrstr)
  #await sleepAsync(400)
  #logr("\n")
  flushFile(stdout)
  ]#
#}

proc show(obj: ref RingBuffer): void =
#{
   let a = obj.print(obj)
   waitFor a
#}

#######################################################
# RingBufferInit() : Exported to other modules
#######################################################
proc RingBufferInit*():ref RingBuffer =
#{
  var RBObj  = new(RingBuffer)
  RBObj.rb_size = RING_BUFFER_SIZE
  RBObj.rb_count          = 0
  RBObj.rb_type           = RB_STATIC
  RBObj.rb_readidx        = -1
  RBObj.rb_writeidx       = -1
  RBObj.setBufferData     = setBufferData
  RBObj.getBufferData     = getBufferData
  RBObj.getBufferDataBack = getBufferDataBack
  RBObj.getSize           = getSize
  RBObj.getCount          = getCount
  RBObj.getStatus         = getStatus
  RBObj.isEmpty           = isEmpty
  RBObj.isFull            = isFull
  RBObj.print             = print
  RBObj.printxy           = printxy
  RBObj.show              = show
  RBObj.setDebug          = setDebug
  RBObj.reset             = reset

  RingBufferObject        = RBObj
  return RBObj
#}

proc RingBufferInit*(rb_size: int):ref RingBuffer =
#{
  var RBObj  = new(RingBuffer)
  RBObj.rb_size = rb_size
  RBObj.rb_type           = RB_DYNAMIC
  RBObj.rb_readidx        = -1
  RBObj.rb_writeidx       = -1
  RBObj.setBufferData     = setBufferData
  RBObj.getBufferData     = getBufferData
  RBObj.getBufferDataBack = getBufferDataBack
  RBObj.getSize           = getSize
  RBObj.getCount          = getCount
  RBObj.getStatus         = getStatus
  RBObj.isEmpty           = isEmpty
  RBObj.isFull            = isFull
  RBObj.print             = print
  RBObj.printxy           = printxy
  RBObj.show              = show
  RBObj.setDebug          = setDebug
  RBObj.reset             = reset

  RBOBJ.rb_dbuffer        = newSeq[ref string](RBObj.rb_size)

  RingBufferObject        = RBObj
  return RBObj
#}
