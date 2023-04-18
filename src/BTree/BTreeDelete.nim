#################################################
# IMPLEMENTATION OF BTREE IN NIM LANGUAGE
#################################################
#import std/math
#import std/os

import CommonImports
import CommonLogger
import CommonUtils
import BTreeHeader
import BTreeUtils
import BTreePrints
import BTreeSearch
import BTreeTraversal
import BTreeDeleteLeaf

# Procs Forward Declaration
proc deleteBTree*(key: int): int
#proc deleteBTreeSuccessor*(key: int): int
#proc deleteBTreePredecessor*(key: int): int

proc deleteBTree*(key: int): int =
#{
    var target = searchBTree(key)
    if (target == nil): #{
      log("Key[%] not found\n")
      return

    var btnode   = target.btreenode
    var listnode = target.listnode
    if (getBTreeNodeType(btnode) == BT_LEAF):
      log("Before Deletion %s\n", getBTreeNodeStr(btnode))
      deleteListNodeLeaf(btnode, listnode)
      log("After  Deletion %s\n", getBTreeNodeStr(btnode))
      return

    if (getBTreeNodeType(btnode) == BT_NODE):
      log("Deletion is allowed for Leaf Nodes only.\n")
      log("Deletion for Intermediate and Root Nodes is in progress\n")
      log("Before Deletion %s\n", getBTreeNodeStr(btnode))
      log("After  Deletion %s\n", getBTreeNodeStr(btnode))
      return 

    if (getBTreeNodeType(btnode) == BT_ROOT):
      log("Deletion is allowed for Leaf Nodes only.\n")
      log("Deletion for Intermediate and Root Nodes is in progress\n")
      log("Before Deletion %s\n", getBTreeNodeStr(btnode))
      log("After  Deletion %s\n", getBTreeNodeStr(btnode))
      return
#}
