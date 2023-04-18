import std/math
import std/os

const BT_DEGREE = 3
const BT_ROOT   = 1
const BT_NODE   = 2
const BT_LEAF   = 3

type #{ A Linked List Node data structure
  ListNode = object
    key: int
    next: ref ListNode
    prev: ref ListNode
#}

type #{ A Binary Tree Node data structure
  TreeNode = object
    key:   int
    left:  ref TreeNode
    right: ref TreeNode
#}

type #{
  KeyNode = object
    data:        int
    numKeys:     int
    numChildren: int
    next:        ref KeyNode
    prev:        ref KeyNode
    lesser:      pointer
    greater:     pointer
     
#}
 

type #{ A BTree Node data structure
  BTreeNode = object
    bt_type:     int 

    # type of tree node
    # 1 = root 
    # 2 = Non-Leaf and Non-Root
    # 3 = leaf

    bt_degree:    int #Degree of a BTree
    bt_maxkeys:   int #Max no. of keys a btree node can handle
    bt_minkeys:   int #Min no. of keys
    bt_maxchild:  int #Max no. of children. It should be m where m is the defree/order of Btree
    bt_minchild:  int #Min no. of childrens for a non-root and non-leaf node.
                      # It should be ceil[m/2] where m is the degree/order
    bt_numkeys:   int #No. of keys present in the current Btree node
    bt_key:       int #The value of the first key present in the list of keys
    bt_lastData:  int #The value of the last key present in the list of keys
    bt_firstKey:  ref ListNode #Pointer to first node in KeyList
    bt_lastKey:   ref ListNode #Pointer to last node in KeyList
    bt_keyList:   ref ListNode #Linked list of all the keys handled by this btree node
    bt_child:     array[BT_DEGREE, ref BTreeNode] #Pointer to the list of childrens
    
#}

proc newListNode(key: int): ref ListNode =
#{
   var obj  = new ListNode
   obj.key  = key
   obj.next = nil
   obj.prev = nil
   return obj
#}

proc newListNode(): ref ListNode =
#{
   var obj  = new ListNode
   obj.key  = -1
   obj.next = nil
   obj.prev = nil
   return obj
#}

proc newBTreeNode(key: int): ref BTreeNode =
#{
   var obj         = new BTreeNode
   obj.bt_degree   = BT_DEGREE
   obj.bt_maxchild = obj.bt_degree
   obj.bt_minchild = (int) ceil(obj.bt_maxchild/2)
   obj.bt_maxkeys  = obj.bt_maxchild - 1
   obj.bt_minkeys  = obj.bt_minchild - 1

   obj.bt_key      = key
   return obj
#}


proc ceilfloor(): void =
#{

   var origf = 3/2
   var c = ceil(origf)
   var f = floor(origf)
   var t = trunc(origf)
   var r = round(origf)
   echo "Original Value ",origf
   echo "Ceiling  Value ",c
   echo "Floor    Value ",f
   echo "Trunc    Value ",t
   echo "Round    Value ",r

#}

var Root:ref BTreeNode
var datalist = @[50,10,34,12,6,55,25]

proc createRoot():ref BTreeNode =
#{
   Root             = newBTreeNode(datalist[0])
   Root.bt_type     = BT_ROOT

   var left         = newBTreeNode(datalist[1])
   var right        = newBTreeNode(datalist[2])
   left.bt_type     = BT_LEAF
   right.bt_type    = BT_LEAF
   Root.bt_child[0] = left
   Root.bt_child[1] = right
#}

proc create(): void =
#{
   ceilfloor()

#}

proc main(): void =
#{
   create()
#}

main()
