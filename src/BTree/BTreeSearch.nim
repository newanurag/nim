#################################################
# IMPLEMENTATION OF BTREE IN NIM LANGUAGE
#################################################
#import std/math
#import std/os

#################################################
# BTree and its associated data structures and
# variables are defined in this header module
#################################################
import CommonImports
import CommonLogger
import CommonUtils
import BTreeHeader
import BTreeUtils
import BTreePrints
proc searchBTree*(key: int): ref SearchResult
proc getSuccessor*(key: int): ref SearchResult
proc getPredecessor*(key: int): ref SearchResult

proc findLeafBTreeNode*(root: ref BTreeNode, key: int): ref BTreeNode =
#{
   if (root == nil or root.bt_listhead == nil or root.bt_listtail == nil):
     return nil
   var minkey = root.bt_listhead.key
   var maxkey = root.bt_listtail.key
   if (getDebugLevel() == BT_DEBUG_LEVEL_D):
     log("Search Range [%d - %d]\n", minkey, maxkey)

   if (key > minkey and key < maxkey): #{
     var node = root.bt_listhead.next
     var prev = root.bt_listhead
     while(node != nil): #{
       if (getDebugLevel() == BT_DEBUG_LEVEL_D):
         log("Deep Search Range: [%d - %d]\n", prev.key, node.key)
       if (key > prev.key and key < node.key):
         var right = getBTreeNodeRight(prev)
         if (right != nil): #{
           var bnode = findLeafBTreeNode(right, key)
           if (bnode != nil): #{
             return bnode
           #}
         #}
       #}
       prev = node
       node = node.next
     #} End of while loop
     return root
   #} End of top level if condition

   if (key < minkey): #{
     var left = getBTreeNodeLeft(root)
     if (left == nil):
       return root
     else:
       return findLeafBTreeNode(left, key)
   #}

   if (key > maxkey): #{
     var right = getBTreeNodeRight(root)
     if (right == nil):
       return root
     else:
       return findLeafBTreeNode(right, key)
   #}
#}

proc searchBTree*(root: ref BTreeNode, key: int): ref SearchResult =
#{
   if (root == nil):
     return nil

   var head = root.bt_listhead
   var srobj: ref SearchResult = nil

   while(head != nil): #{

     if (key == head.key):
       #log("key [%d] Found\n",key);
       srobj       = new SearchResult
       srobj.btreenode = root
       srobj.listnode  = head
       return srobj
    
     if (key < head.key):
       srobj = searchBTree(getBTreeNodeLeft(head), key)

     if (key > head.key):
       srobj = searchBTree(getBTreeNodeRight(head), key)

     if (srobj == nil):
       head = head.next
     else:
       return srobj
   #}
#}

proc searchBTree*(key: int): ref SearchResult =
#{
   log("Searching Key[%d]\n", key)
   if (getRoot() == nil):
     return nil

   return searchBTree(getRoot(), key)
#}

proc getSuccessor*(key: int): ref SearchResult =
#{
   log("Getting Successor of Key[%d]\n", key)

   var sr = searchBTree(key)
   var listnode = sr.listnode
   if (listnode.next != nil):
     log("Successor Key[%d] found in same BtreeNode %s\n", 
        listnode.next.key, getBTreeNodeStr(sr.btreenode))
   else:
     var rightbtn = getBTreeNodeRight(listnode)
     log("Successor Key[%d] found in right subtree\n", getBTreeNodeKeyList(rightbtn).key)
#}

proc searchBTreeSuccessor*(key: int): ref SearchResult =
#{
    var sr = searchBTree(key)
    var listnode = sr.listnode

#}

proc getPredecessor*(key: int): ref SearchResult =
#{
   log("Getting Predecessor of Key[%d]\n", key)

   var sr = searchBTree(key)
   var listnode = sr.listnode
   if (listnode.prev != nil):
     log("Predecessor Key[%d] found in same BtreeNode %s\n", 
        listnode.prev.key, getBTreeNodeStr(sr.btreenode))
   else:
     var leftbtn = getBTreeNodeLeft(listnode)
     log("Predecessor Key[%d] found in left subtree\n", getBTreeNodeKeyListTail(leftbtn).key)
#}

proc findLeafBTreeNode*(key: int): ref BTreeNode =
#{
   return findLeafBTreeNode(getRoot(), key)
#}
