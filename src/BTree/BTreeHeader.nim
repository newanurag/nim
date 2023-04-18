import std/math
#import std/os
import strutils
import std/streams
import std/times
import CommonLogger

########################################################
# Data Structures
########################################################

# Linked List Node with leftBTreeNode and rightBTreeNode 
# pointer keyword is equivalent to void* in C or C++

type #{ A Linked List Node data structure
  ListNode* = object
    key              *: int
    value            *: pointer
    next             *: ref ListNode
    prev             *: ref ListNode
    leftBTreeNode    *: pointer
    rightBTreeNode   *: pointer
    currentBTreeNode *: pointer
    parentListNode   *: ref ListNode
#}

type #{ A BTree Node data structure
  BTreeNode* = object
    bt_listhead      *: ref ListNode #Start node of keylist
    bt_listtail      *: ref ListNode #tail node of keylist
    bt_numkeys       *: int #No. of keys present in the current Btree node
    bt_id            *: string 
    bt_numchild      *: int #No. of children this BTreeNode has
    bt_level         *: int

    # type of tree node
    # 1 = root 
    # 2 = Non-Leaf and Non-Root
    # 3 = leaf
    bt_type          *: int 
#}
type 
  KeyValue  * = object
       key  *: int
       value*: pointer

type # An object used to return the search result
  SearchResult* = object
    btreenode *: ref BTreeNode
    listnode  *: ref ListNode

########################################################
# Global variables
########################################################

const BT_SUCCESS * = 0
const BT_FAILURE * = -1
const BT_ERROR     = -1
const BT_FALSE   * = false
const BT_TRUE    * = true

const BT_ROOT    * = 1
const BT_NODE    * = 2
const BT_LEAF    * = 3

var BT_DEFAULT_ORDER* = 3
var BT_DEFAULT_LOG_FILE* = "btree.log"

var BT_ORDER   * = BT_DEFAULT_ORDER
var v = BT_ORDER/2
var bBT_MINKEYS = ceil(v)  - 1
var bBT_MINCHLD = ceil(v)
var BT_DEGREE  * = BT_ORDER
var BT_MAXCHLD * = BT_DEGREE            #Max no. of children. It should be BT_DEGREE
var BT_MINCHLD * = bBT_MINCHLD.int      #Min no. of childrens for a non-root and non-leaf node.
var BT_MAXKEYS * = BT_DEGREE - 1        #Max no. of keys a btree node can handle
var BT_MINKEYS * = bBT_MINKEYS.int      #Min no. of keys a btree node can handle
                                        #It should be ceil[m/2]-1 where m is the degree/order

var BT_PREFIX    * = "BTN"
var BT_SUFFIX    * = 1
var BT_LOG_FILE  * = BT_DEFAULT_LOG_FILE
var BT_MAXLEVEL  * = 0

var BT_DEFAULT_DEBUG_LEVEL     * = 0
var BT_DEBUG_LEVEL_E * = 0 #Error
var BT_DEBUG_LEVEL_W * = 1 #Warning
var BT_DEBUG_LEVEL_I * = 2 #Info
var BT_DEBUG_LEVEL_D * = 3 #Debug

# The root of the BTree
var btroot *:ref BTreeNode = nil

#Array of BTreeNode data structure currently present in BTree
var btarray*:seq[ref BTreeNode]

#Array of  ListNode (Linked List data structure)  currently present in BTree
var btlist *:seq[ref ListNode]

var btdebug *:int = BT_DEFAULT_DEBUG_LEVEL

########################################################
#Function Declaration Prototype
########################################################

#BTree Creation
#proc createBTree*(root: var ref BTreeNode, parent: var ref BTreeNode, key: int):ref BTreeNode
#proc createBTree*(keys: seq[int]):ref BTreeNode

#Searching
#proc findLeafBTreeNode*(root: ref BTreeNode, key: int): ref BTreeNode
#proc searchBTree*(root: ref BTreeNode, key: int): ref SearchResult

#Traversal
#proc inorderBTree*(root: ref BTreeNode): void
