######################################################################
# Ring Buffer APIs
######################################################################
const RING_BUFFER_SIZE = 5

# Create a RingBuffer Class/struct with its data and member functions
type 
  RingBufferArray = object
    writeidx: int
    readidx:  int
    size:     int
    buffer:   array[RING_BUFFER_SIZE, string]
    write:    proc(self: var RingBufferArray, arg_string: string): int
    read:     proc(self: var RingBufferArray): string

# Write/Append into the ring buffer
proc write(self: var RingBufferArray, arg_string: string): int =
    if (self.writeidx > (RING_BUFFER_SIZE - 1)):
      echo "Ring Buffer is full"

    self.buffer[self.writeidx] = arg_string
    echo "Data [",arg_string,"] written into ring buffer"

    return 1

# Read data from ring buffer
proc read(self: var RingBufferArray): string =
    var data = self.buffer[self.readidx]

type RingBufferSeq = object
    writeidx: int
    readidx:  int
    size:     int
    buffer:   seq

proc RBWriteFix(rbobj: var RingBufferArray, arg_string: string): int =
  if (rbobj.writeidx > (RING_BUFFER_SIZE - 1)):
    echo "[Error] Ring Buffer is Full"
    return 0

  rbobj.buffer[rbobj.writeidx] = arg_string
  rbobj.writeidx = rbobj.writeidx + 1
  echo "Write function for enqueuing data into Ring Buffer"
  return 1

proc RBWrite(rbobj: var RingBufferArray, arg_string: string): int =
  if (rbobj.writeidx > (RING_BUFFER_SIZE - 1)):
    rbobj.writeidx = 0;
    if (rbobj.writeidx == rbobj.readidx):
      rbobj.readidx = rbobj.readidx + 1

  rbobj.buffer[rbobj.writeidx] = arg_string
  rbobj.writeidx = rbobj.writeidx + 1
  echo "Write function for enqueuing data into Ring Buffer"
  return 1
  

proc RBRead(rbobj: var RingBufferArray): string =
  echo "Read function for reading and removing data from Ring Buffer" 
  if (rbobj.readidx > (RING_BUFFER_SIZE - 1)):
    rbobj.readidx = 0;
  var data = rbobj.buffer[rbobj.readidx]
  rbobj.readidx = rbobj.readidx + 1
  return data

proc RBSize(rbobj: RingBufferArray): int =
  return rbobj.size

proc RBStatus(rbobj: RingBufferArray) =
  echo "RingBuffer:WriteIdx: ", rbobj.writeidx
  echo "RingBuffer:ReadIdx : ", rbobj.readidx
  echo "RingBuffer:Size    : ", rbobj.size

proc RBInit(): RingBufferArray =
  var obj = RingBufferArray(writeidx: 0, readidx: 0, size: RING_BUFFER_SIZE)
  obj.enqueue = write
  obj.dequeue = read
  return obj

proc main2() =
  echo "Main function, First Program in nim"
  var obj = RBInit();
  var ret:int 
  ret = RBWrite(obj, "Diamond")
  ret = RBWrite(obj, "Gold")
  ret = RBWrite(obj, "Silver")
  ret = RBWrite(obj, "Copper")
  ret = RBWrite(obj, "Bronze")
  ret = RBWrite(obj, "Steel")
  var data = RBRead(obj )
  echo "Current Read Data from RingBuffer is [",data,"]"
  RBStatus(obj);

proc main(): void =
  echo "Main Function"
  var obj = RBInit();
  var ret: int = 0
  ret = obj.enqueue(obj, "Diamond")
  ret = obj.enqueue(obj, "Gold")
  ret = obj.enqueue(obj, "Silver")
  ret = obj.enqueue(obj, "Copper")
  ret = obj.enqueue(obj, "Bronze")
  ret = obj.enqueue(obj, "Steel")

  var data = obj.dequeue(obj)
main()
