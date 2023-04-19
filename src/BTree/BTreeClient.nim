import std/[asyncnet, asyncdispatch]
import CommonImports
import CommonLogger
import CommonUtils
import BTreeHeader
import BTreeUtils
import BTreePrints
import BTreeCli


#[
proc connect(socket: AsyncSocket; address: string; port: Port): owned(Future[void]) {.....}

]#
proc Client() {.async.} =
#{
  var ipaddr = BT_SERVER_IP_ADDRESS
  var port = Port(BT_SERVER_PORT);
  var client = newAsyncSocket()

  discard client.connect(ipaddr, port)

  discard client.send("testing")

#}
