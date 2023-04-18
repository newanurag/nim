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

var inputdata: seq[int]
var splitcnt = 0
var debug = 0

proc getBTreeNodeLeftSibling(plistnode: ref ListNode): ref BTreeNode =
#{
    var leftBTN: ref BTreeNode = nil

    if (plistnode.prev == nil):
      leftBTN = getBTreeNodeLeft(plistnode)
    else:
      leftBTN = getBTreeNodeRight(plistnode.prev)

    log("Left Sibling %s with keys %d\n", getBTreeNodeStr(leftBTN), getBTreeNodeNumKeys(leftBTN))
    return leftBTN
#}

proc getBTreeNodeRightSibling(plistnode: ref ListNode): ref BTreeNode =
#{
    var rightBTN: ref BTreeNode = nil
    if (plistnode.next == nil):
      log("No right sibling found\n")
      return
    else:         
      rightBTN = getBTreeNodeRight(plistnode.next)

    log("Right Sibiling %s with keys %d\n", getBTreeNodeStr(rightBTN),
       getBTreeNodeNumKeys(rightBTN))
#}

proc borrowFromLeftSibling(delnode: var ref ListNode, leftsib: var ref BTreeNode): void =
#{
    delnode.key = delnode.parentListNode.key
    var prev = leftsib.bt_listtail.prev
    var newpkey = leftsib.bt_listtail.key
    delnode.parentListNode.key = newpkey #New parent key
    prev.next = nil
    leftsib.bt_listtail = prev
    leftsib.bt_numkeys = leftsib.bt_numkeys - 1
    log("LeftSibling: Borrowed Key %d, NewParent Key %d\n", delnode.key, newpkey)
#}

proc borrowFromRightSibling(delnode: var ref ListNode, rightsib: var ref BTreeNode): void =
#{
    delnode.key = delnode.parentListNode.key
    var next = rightsib.bt_listhead.next 
    var newpkey = rightsib.bt_listhead.key
    delnode.parentListNode.key = newpkey
    next.prev = nil
    rightsib.bt_listhead = next
    rightsib.bt_numkeys = rightsib.bt_numkeys - 1
    log("RightSibling: Borrowed Key %d, NewParent Key %d\n", delnode.key, newpkey)
#}

proc deleteListNodeLeafCase3(btnode: var ref BTreeNode, 
                            delnode: var ref ListNode,
                            leftsib : var ref BTreeNode,
                            rightsib: var ref BTreeNode): void =
#{
    var parentListNode       = delnode.parentListNode
    var prevListNode         = parentListNode.prev
    var nextListNode         = parentListNode.next

    #Scenario 1:
    #Scenario 2:
    #Scenario 3:
#}

proc deleteListNodeLeafCase2(btnode: var ref BTreeNode, delnode: var ref ListNode): void =
#{

    log("Will have to borrow the keys first from left or right siblings\n")

    # CASE-1: Borrow from Left Sibling
    var leftsib = getBTreeNodeLeftSibling(delnode.parentListNode)

    if ((leftsib != nil) and (getBTreeNodeNumKeys(leftsib) > BT_MINKEYS)):
      borrowFromLeftSibling(delnode, leftsib)
      return

    # CASE-2: Borrow from Right Sibling
    var rightsib = getBTreeNodeRightSibling(delnode.parentListNode)

    if ( (rightsib != nil) and (getBTreeNodeNumKeys(rightsib) > BT_MINKEYS)):
      borrowFromRightSibling(delnode, rightsib)
      return

    # CASE-3: Merge left and right siblings
    # we have come here because both left and right siblings have exactly
    # BT_MINKEYS,
#}

proc deleteListNodeLeafCase1(btnode: var ref BTreeNode, delnode: var ref ListNode): void =
#{
   # If delnode is the first node to be deleted
   if (delnode.prev == nil):
     delnode.next.prev  = nil
     btnode.bt_listhead = delnode.next
     btnode.bt_numkeys  = btnode.bt_numkeys  - 1
     return
   
   # If delnode is the last node to be deleted
   if (delnode.next == nil):
     btnode.bt_listtail = delnode.prev
     btnode.bt_listtail.next = nil
     btnode.bt_numkeys  = btnode.bt_numkeys  - 1
     return

   # If delnode is the intermediate node to be deleted
   delnode.prev.next = delnode.next
   delnode.next.prev = delnode.prev
   btnode.bt_numkeys = btnode.bt_numkeys  - 1
   return
#}

proc deleteListNodeLeaf*(btnode: var ref BTreeNode, delnode: var ref ListNode): void =
#{
   log("delnode keys %d=%d\n", getBTreeNodeNumKeys(btnode), BT_MINKEYS)

   if (getBTreeNodeNumKeys(btnode) > BT_MINKEYS):
     deleteListNodeLeafCase1(btnode, delnode)
   else:
     deleteListNodeLeafCase2(btnode, delnode)
#}
