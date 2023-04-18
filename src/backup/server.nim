#############################
#NIM TCP/IP Server
#############################
import std/[asyncnet,asyncdispatch]
import ringbuffer_module

type 
  HostInfo  = object
    hostip  : string
    hostport: Port
    

proc processClient(client: AsyncSocket, obj: ref RingBuffer) {.async.} =
#{
  var peerinfo  = cast[HostInfo](client.getPeerAddr())
  var localinfo = cast[HostInfo](client.getLocalAddr())
  while true:
    var data = await client.recvLine()
    #stdout.write("[Host:",host," Port:",port.repr,"]> ")
    stdout.write("[MessageFromClient][Host:",peerinfo.hostip," Port:",peerinfo.hostport.repr,"]> ")
    echo data
    var outdata:string = "[MessageFromServer][Host:" & localinfo.hostip & " Port:" & localinfo.hostport.repr & "]> "
    outdata.add(data)
    outdata.add("\n")
    await client.send(outdata)
#}

####################################################################
# Main Server Function
####################################################################
proc Server() {.async.} =
#{

  var ipaddr = "127.0.0.1"
  var port = 9999
  var ret = 0
  var obj = RingBufferInit(6)

  var serversocket = newAsyncSocket()
  #serversocket.setSockOpt(OptReuseAddr, true)

  serversocket.bindAddr(Port(port), ipaddr)
  serversocket.listen()

  
  echo "Greetings!!!\nNIM Server[",ipaddr,"] started on Port [",port,"].\nWaiting for client"
  while true:
    let client = await serversocket.accept()
    asyncCheck processClient(client, obj)

#}

proc main():void =
#{
  asyncCheck Server()
#}

#main()
asyncCheck Server()
runForever()
