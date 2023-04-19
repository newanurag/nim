#############################
#NIM TCP/IP Server
#############################
import os
import std/[asyncnet,asyncdispatch]
import CommonImports
import CommonLogger
import CommonUtils
import BTreeHeader
import BTreeUtils
import BTreePrints
import BTreeCli

type 
  HostInfo  = object
    hostip  : string
    hostport: Port
    
proc processClient(client: AsyncSocket, rcli: proc(cmd: string): string) {.async.} =
#{
  var peerinfo  = cast[HostInfo](client.getPeerAddr())
  var localinfo = cast[HostInfo](client.getLocalAddr())
  var clientPrompt = prompt
  while true:
    await client.send(clientPrompt)
    var clientdata = await client.recvLine()

    if (clientdata == "\r\n"):
      continue

    var str = rcli(clientdata)
    await client.send(str & "\n")

#}



####################################################################
# Main Server Function
####################################################################
proc startBTreeServer*(rcli: proc(cmd: string): string) {.async.} =
#{

  var ret = 0

  var serversocket = newAsyncSocket()
  serversocket.setSockOpt(OptReuseAddr, true)

  serversocket.bindAddr(Port(BT_SERVER_PORT), BT_SERVER_IP_ADDRESS)
  serversocket.listen()

  log("BTreeServer started\n")

  while true:
    let client = await serversocket.accept()
    if (client != nil):
      asyncCheck processClient(client, rcli)

#}

#proc main():void =
#{
  #asyncCheck Server()
#}

#main()
#asyncCheck Server()
#runForever()
