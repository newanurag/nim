######################################################################
# Ring Buffer Module Implementation
######################################################################

const RING_BUFFER_SIZE:int = 4
const RB_SUCCESS = 0
const RB_FAILURE = -1

type #{ A Ring Buffer Object
  RingBuffer* = object
    buffer:   array[RING_BUFFER_SIZE, ref string]
    size:     int
    readidx:  int
    writeidx: int
    #ops vector
    RingBufferInit: proc(): ref RingBuffer
    isEmpty:        proc(obj: ref RingBuffer): bool
    isFull:         proc(obj: ref RingBuffer): bool
    setData*:        proc(obj: ref RingBuffer, data: string): int
    getData:        proc(obj: ref RingBuffer): ref string
    getSize:        proc(obj: ref RingBuffer): int
    getStatus:      proc(obj: ref RingBuffer): void
#}

proc isEmpty*(obj: ref RingBuffer): bool
proc isFull*(obj: ref RingBuffer): bool
proc setData*(obj: ref RingBuffer, data: string):int
proc getData*(obj: ref RingBuffer): ref string
proc getSize*(obj: ref RingBuffer): int
proc getStatus*(obj: ref RingBuffer): void



#######################################################
# getSize()
#######################################################
proc getSize*(obj: ref RingBuffer): int =
#{
   return obj.size
#}

#######################################################
# isFull()
#######################################################
proc isFull*(obj: ref RingBuffer):bool =
#{
   var tmp = (obj.writeidx + 1) mod RING_BUFFER_SIZE
   
   echo "writeidx: ",obj.writeidx
   echo "readidx: ",obj.readidx
   if (tmp == obj.readidx and obj.readidx != -1):
     echo "True: RB is FULL"
     return true
   else:
     #echo "False: RB is Empty"
     return false
#}

#######################################################
# isEmpty()
#######################################################
proc isEmpty*(obj: ref RingBuffer):bool =
#{
   if (obj.writeidx == obj.readidx):
     return true

   var tmp = (obj.readidx + 1) mod RING_BUFFER_SIZE
   if (tmp > obj.writeidx):
     return true

   return false

#}

#######################################################
# setData()
#######################################################
proc setData(obj: ref RingBuffer, data: ref string):int =
#{
   obj.writeidx = (obj.writeidx + 1) mod RING_BUFFER_SIZE
   if (obj.buffer[obj.writeidx] == nil):
     obj.buffer[obj.writeidx] = data
   else:
     echo "RB is FULL"
     return RB_FAILURE
   return RB_SUCCESS
#}

#######################################################
# getStatus()
#######################################################
proc getStatus*(obj: ref RingBuffer):void =
#{
  echo "RingBuffer:size    :", obj.size
  echo "RingBuffer:readidx :", obj.readidx
  echo "RingBuffer:writeidx:", obj.writeidx
  echo "RingBuffer Entries:"
  for idx, element in obj.buffer:
    stdout.write("[",idx,"] ")
    if (element == nil):
      stdout.write("NULL")
    else:
      var str:string = element[]
      stdout.write(str)
    stdout.write("\n")
#}

proc getStatus2*(obj: ref RingBuffer):void =
#{
  echo "RingBuffer:size    :", obj.size
  echo "RingBuffer:readidx :", obj.readidx
  echo "RingBuffer:writeidx:", obj.writeidx
  echo "RingBuffer Entries:"
  for idx, element in obj.buffer:
    stdout.write("[",idx,"] ")
    stdout.write(element.repr)
    stdout.write("\n")
  stdout.write("Line Status of Ring Buffer [ ")
  for element in obj.buffer:
    stdout.write(element.repr)
    stdout.write(" ")
  stdout.write("]\n")
#}


#######################################################
# getData()
#######################################################
proc getData*(obj: ref RingBuffer): ref string =
#{

   obj.readidx = (obj.readidx + 1) mod RING_BUFFER_SIZE
   var data = obj.buffer[obj.readidx]
   if (data == nil):
     echo "RB is already empty"
   else:
     obj.buffer[obj.readidx] = nil
   return data
#}

#######################################################
# RingBufferInit()
#######################################################
proc RingBufferInit*():ref RingBuffer =
#{
  var RBObj  = new(RingBuffer)
  RBObj.size = RING_BUFFER_SIZE
  RBObj.readidx = -1
  RBObj.writeidx = -1
  #RBObj.buffer = ["This", "is", "for", "testing", "purpose", "abc", "def", "ghi", "jkl", "mno"]
  RBObj.isEmpty   = isEmpty
  RBObj.isFull    = isFull
  RBObj.setData   = setData
  RBObj.getData   = getData
  RBObj.getSize   = getSize
  RBObj.getStatus = getStatus
  return RBObj
#}
