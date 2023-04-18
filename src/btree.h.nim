import std/math
import std/os

let BT_DEGREE  = 3                    #Degree of a BTree
let BT_MAXKEYS = BT_DEGREE - 1         #Max no. of keys a btree node can handle
let BT_MAXCHLD = BT_DEGREE            #Max no. of children. It should be BT_DEGREE
let BT_MINCHLD = ceil(BT_DEGREE / 2)  #Min no. of childrens for a non-root and non-leaf node.
                                      #It should be ceil[m/2] where m is the degree/order
const BT_ROOT   = 1
const BT_NODE   = 2
const BT_LEAF   = 3

type #{ A Linked List Node data structure
  ListNode*= object
    key    *: int
    next   *: ref ListNode
    prev   *: ref ListNode
    lesser *: pointer
    greater*: pointer
#}

type #{ A BTree Node data structure
  BTreeNode*= object
    bt_type:     int 

    # type of tree node
    # 1 = root 
    # 2 = Non-Leaf and Non-Root
    # 3 = leaf

    bt_knum:    int #No. of keys present in the current Btree node
    bt_kstart:  int #first key present in keylist
    bt_kend:    int #last key present in keylist
    bt_listhead: ref ListNode #List of key nodes this node contains
    bt_listtail: ref ListNode #tail node of the listhead
    bt_cnum:    int #No. of children present in this node
    
#}

proc newListNode*(key: int): ref ListNode =
#{
   var obj     = new ListNode
   obj.key     = key
   obj.next    = nil
   obj.prev    = nil
   obj.lesser  = nil
   obj.greater = nil
   return obj
#}

proc newBTreeNode*(key: int): ref BTreeNode =
#{
   var lnode         = newListNode(key)
   var bnode         = new BTreeNode
   bnode.bt_kstart   = key
   bnode.bt_kend     = key
   bnode.bt_listhead = lnode
   bnode.bt_listtail = lnode
   return bnode
#}

proc printList*(head: ref ListNode): void =
#{
   var node = head
   while (node != nil):
     stdout.write(node.key," ")
     node = node.next
#}

proc printBTreeNode*(root: ref BTreeNode): void =
#{
   stdout.write("BTreeNode.kstart = " & $(root.bt_kstart) & "\n")
   stdout.write("BTreeNode.kend   = " & $(root.bt_kend) & "\n")
   stdout.write("BTreeNode.head   = " & $(root.bt_listhead.key) & "\n")
   stdout.write("BTreeNode.tail   = " & $(root.bt_listtail.key) & "\n")
   stdout.write("BTreeNode.cnum   = " & $(root.bt_cnum) & "\n")
   stdout.write("BTreeNode.knum   = " & $(root.bt_knum) & "\n")

#}

proc printInput*(datalist: seq[int]): void=
#{
   for idx, i in datalist: #{
     if (idx == low(datalist)):
       stdout.write("Input string:[ ")

     stdout.write(i)
     stdout.write(" ")

     if (idx == high(datalist)):
       stdout.write("]\n")
   #}
#}
