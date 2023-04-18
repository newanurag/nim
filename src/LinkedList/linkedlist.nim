######################################################################
# Linked List Data Structures
######################################################################
type
  ListNode = object
    val: string
    next: ref ListNode #Traced reference to next ListNode object
    prev: ref ListNode #Traced reference to prev ListNode object

type
  List = object
    head: ref ListNode #Traced reference to first Node in the Linked List
    tail: ref ListNode #Traced reference to  last Node in the Linked List
    createList: proc(arg_arr: var seq[string]):void
    insert:     proc(arg_val: var string):void
    delete:     proc(arg_val: var string):void
    print:      proc():void # Print the Linked List in iterative manner
    printR:     proc(node: var ref ListNode):void # Print the Linked List in recursive manner
    find:       proc(key: var string):bool

var list:List

######################################################################
# Linked List APIs
######################################################################

##########################################
# Insert single data node in a linked list
##########################################
proc insert(arg_val: var string):void =
  var node: ref ListNode
  new(node)
  node.val = arg_val
  node.next = nil
  node.prev = nil

  if (list.head == nil):
    list.head = node
    list.tail = node
  else:
    list.tail.next = node
    list.tail = list.tail.next

  echo list.head.val

##########################################
# Insert Array of nodes in linked list
##########################################
proc createList(arg_arr: var seq[string]): void =
  var arrlen:int = len(arg_arr)

  for data in arg_arr:
    var str = data
    list.insert(str)


proc findList(key: var string): bool =
  var node:ref ListNode = list.head
  while node != nil:
    echo "key=",key," node=",node.val
    if (key == node.val):
      return true
    node = node.next

  return false

##########################################
# Print LinkedList
##########################################
proc printList():void =
  var node:ref ListNode = list.head
  while true:
    if (node == nil):
      break
    echo node.val
    node = node.next

proc printListR(node: var ref ListNode):void =
  if node == nil:
    return
  else:
     echo node.val
     printListR(node.next)



##########################################
# Initialize the linked list object
##########################################
proc ListInit(): void =
  #var obj = List(head: nil, tail: nil, insert: insertNode)
  list = List()
  list.head       = nil
  list.tail       = nil
  list.insert     = insert
  list.createList = createList
  list.print      = printList
  list.printR     = printListR
  list.find       = findList

proc createList():void =
  var datalist:seq[string] = @["abc", "def", "ghi"]
  list.createList(datalist)

proc print():void =
  echo "Printing List in Iterative Manner"
  list.print()

proc printR():void =
  echo "Printing List in Recursive Manner"
  list.printR(list.head)

proc find(str: string):void =
  var arg_str = str
  var ret = list.find(arg_str)
  if (ret == true):
    echo "Element ",arg_str," is found"
  else:
    echo "Element NOT found"

##########################################
# Core Main function for Execution
##########################################
proc main(): void =
  echo "Main Function"
  ListInit()
  createList()
  print()
  find("def")
  printR()

main()
