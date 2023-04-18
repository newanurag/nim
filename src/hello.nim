######################################################################
# Ring Buffer APIs
######################################################################
proc RingBufferWrite(arg_string: string) =
  echo "Write function for enqueuing data into Ring Buffer"

proc RingBufferRead(arg_sting: string): string =
  echo "Read function for reading and removing data from Ring Buffer"

proc RingBufferSize(): int =
  return 10

proc printName(arg_name: var string): string =
  echo "Inside function, name is ",arg_name
  arg_name.add(" is Good")
  return arg_name


proc main() =
  echo "Main function, First Program in nim"
  RingBufferWrite("Diamond")
main()
var str = "Nim Language"
var name = printName(str)
echo "After Func call, return value is [", name,"]"
