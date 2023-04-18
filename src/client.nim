import std/[asyncnet, asyncdispatch]

#[
proc connect(socket: AsyncSocket; address: string; port: Port): owned(Future[void]) {.....}

]#
proc Client() {.async.} =
#{
  var ipaddr = "127.0.0.1"
  var port = Port(9999);
  var client = newAsyncSocket()

  discard client.connect(ipaddr, port)

  discard client.send("testing")

#}
