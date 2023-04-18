#############################
#NIM TCP/IP Server
#############################
import os
import std/[asyncnet,asyncdispatch]
import ringbuffer_module

type 
  HostInfo  = object
    hostip  : string
    hostport: Port
    
const LOCAL_IP_ADDRESS = "127.0.0.1"
const LOCAL_PORT = 9999
var row = 0
var col = 0
proc print(obj: ref RingBuffer):void =
#{
   waitFor obj.printxy(obj, col, row)
#}

proc header(obj: ref RingBuffer): void =
#{
  cls()
  row = 0
  col = 0
  #col = 30
  logxy("NIM : Greetings!!!", col, row)
  row = row + 1
  logxy("Ring Buffer Server [" & $LOCAL_IP_ADDRESS & "] started on Port [" & $LOCAL_PORT & "]\n", col, row)
  row = row + 2
  logxy("Live Visualization of Ring Buffer", col, row)
  row = row + 2
  print(obj)
#}

proc writeData(obj: ref RingBuffer, data: string): int  =
#{
    var str:ref string
    str = new (string)
    str[].add(data)
    return obj.setBufferData(obj, str)
#}

proc processClient(client: AsyncSocket, obj: ref RingBuffer) {.async.} =
#{
  var peerinfo  = cast[HostInfo](client.getPeerAddr())
  var localinfo = cast[HostInfo](client.getLocalAddr())
  var clientPrompt = "[RingBufferServer]> "
  while true:
    await client.send(clientPrompt)
    var clientdata = await client.recvLine()

    if (clientdata == "\r\n"):
      continue

    if (clientdata == "cmds" or clientdata == "cmd" or clientdata == "help"):
      var cmds = "[ [ read | get ] | [ exit | quit ] | reset | [ stats | stat | show ] ]"
      await client.send(cmds & "\n")

    elif (clientdata == "read" or clientdata == "get"):
      var rbdata = obj.getBufferData(obj)
      if (rbdata != nil):
        rbdata[] = "RingBuffer[" & $obj.rb_readidx & "] = " & rbdata[]  
        await client.send(rbdata[] & "\n")
        header(obj)
        await client.send(logrstr & "\n\n")
      else:
        await client.send("Ring Buffer is Empty. Use show command to get more details \n")

    elif (clientdata == "stats" or clientdata == "stats"):
      var outdata:string
      outdata.add("RB Size        : " & $obj.getSize(obj) & "\n")
      outdata.add("RB Active Count: " & $obj.getCount(obj) & "\n")
      outdata.add("RB ReadIndex   : " & $obj.rb_readidx & "\n")
      outdata.add("RB WriteIndex  : " & $obj.rb_writeidx & "\n")
      await client.send(outdata & "\n")

    elif (clientdata == "show"):
      header(obj)
      var outdata:string
      outdata.add("RB Size        : " & $obj.getSize(obj) & "\n")
      outdata.add("RB Active Count: " & $obj.getCount(obj) & "\n")
      outdata.add("RB ReadIndex   : " & $obj.rb_readidx & "\n")
      outdata.add("RB WriteIndex  : " & $obj.rb_writeidx & "\n")
      await client.send(outdata & "\n")
      await client.send(logrstr & "\n\n")

    elif (clientdata == "clear" or clientdata == "reset"):
      obj.reset(obj)

    elif (clientdata == "quit" or clientdata == "exit" or clientdata == "q" or clientdata == "e" ):
      header(obj)
      client.close()
      break

    else:
      #Actual Data from client is written here into the RingBuffer
      let ret = writeData(obj, clientdata)
      if (ret == -1):
        await client.send("Unable to write data [" & $clientdata & "]\n")
        await client.send("Ring Buffer is Full. Use show command to get more details \n")
      else:
        header(obj)
        await client.send(logrstr & "\n\n")
    header(obj)
#}



####################################################################
# Main Server Function
####################################################################
proc Server() {.async.} =
#{

  var ret = 0
  var RingBufferObj = RingBufferInit(6)

  var serversocket = newAsyncSocket()
  serversocket.setSockOpt(OptReuseAddr, true)

  serversocket.bindAddr(Port(LOCAL_PORT), LOCAL_IP_ADDRESS)
  serversocket.listen()

  header(RingBufferObj)
  while true:
    let client = await serversocket.accept()
    if (client != nil):
      #var peer  = cast[HostInfo](client.getPeerAddr())
      #logr("< Client Connected with Host:"& $peer.hostip & " Port:" & $peer.hostport.repr & " >")
      asyncCheck processClient(client, RingBufferObj)

#}

proc main():void =
#{
  asyncCheck Server()
#}

#main()
asyncCheck Server()
runForever()
