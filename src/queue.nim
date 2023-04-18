type
  queue = object
    size: int
    buffer: array[10, int]


var q = (ref queue)()
var s = 11
var arr = [1,2,3]
var r = new queue
r. size = 15
echo "Queue Implementation:", q.size
echo q.repr
echo r.repr
echo s.sizeof
echo s.repr
