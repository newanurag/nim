######################################################################
# Ring Buffer Implementation
######################################################################

import ringbuffer_module
import std/[asyncnet, asyncdispatch]

proc setData(obj: ref RingBuffer, data: string): void =
#{
   var str:ref string 
   str = new (string)
   str[].add(data)
   discard obj.setBufferData(obj, str)
#}

proc getData(obj:ref RingBuffer): void =
#{
    var str = obj.getBufferData(obj)
    if (str != nil):
      # echo (str[])
      let b = 3
    else:
      echo "Data is NULL"
#}

proc getDataBack(obj:ref RingBuffer): void =
#{
    var str = obj.getBufferDataBack(obj)
    if (str != nil):
      echo (str[])
    else:
      echo "Data is NULL"
#}

proc getStatus(obj:ref RingBuffer): void =
#{
   obj.getStatus(obj)
#}

proc print(obj:ref RingBuffer): void =
#{
   waitFor obj.print(obj)
#}

#######################################################
# Core Main Function(), Implementation
#######################################################
proc main():void =
#{
   var obj = RingBufferInit(6)
   var size = obj.getSize(obj)
   setData(obj, "This")
   setData(obj, "is")
   setData(obj, "for")
   setData(obj, "abc")
   setData(obj, "def")
   print(obj)
   getData(obj)
   print(obj)
   setData(obj, "ghi")
   print(obj)
   getData(obj)
   print(obj)
#}

main()
