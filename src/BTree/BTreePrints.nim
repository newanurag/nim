import std/math
#import std/os
import strutils
import std/terminal
import std/[os, strutils]
import CommonImports
import CommonLogger
import BTreeHeader
import BTreeUtils

proc getBTreeNodeStr*(arg_node: ref BTreeNode): string

proc getid*(): string =
#{
   var idstr: string = BT_PREFIX
   var ids = BT_SUFFIX
   idstr.add("[")
   idstr.add(intToStr(ids))
   idstr.add("]")
   BT_SUFFIX = BT_SUFFIX + 1
   return idstr
#}

proc printInput*(datalist: seq[int]): void=
#{
   var str:string
   for idx, i in datalist: #{
     if (idx == low(datalist)):
       str.add("Input   string  :[ ")
     str.add("" & $i)
     str.add(" ")

     if (idx == high(datalist)):
       str.add("]")
   #}
   str.add(" Input   Count : " & $len(datalist))
   log(str)
   logf(str)
#}

proc getInputStr*(datalist: seq[int]): string =
#{
   var str:string
   for idx, i in datalist: #{
     if (idx == low(datalist)):
       str.add("[ ")
     str.add("" & $i)
     str.add(" ")

     if (idx == high(datalist)):
       str.add("]")
   #}
   str.add(" Input count   : " & $len(datalist))
   return str
#}

proc printInputF*(datalist: seq[int]): void=
#{
   var str:string
   for idx, i in datalist: #{
     if (idx == low(datalist)):
       str.add("Input   string  :[ ")
     str.add("" & $i)
     str.add(" ")

     if (idx == high(datalist)):
       str.add("]")
   #}
   logf(str)
#}


proc drawBTreeNode*(curpos: int = 42, listnode: ref ListNode): void =
#{
   if (listnode == nil):
     log("Key not found in BTree\n")
     return
   var ocean = "\e[38;5;38;23m"
   var yellow = "\e[33m"
   echo ocean
   var node = listnode
   var currBTN = cast[ref BTreeNode] (node.currentBTreeNode)
   var leftBTreeNode  = getBTreeNodeLeft(node)
   var rightBTreeNode = getBTreeNodeRight(node)
   var strn = "[ " & $node.key & " ]"
   strn.removeSuffix(' ')
   var strc:string = getBTreeNodeStr(currBTN)
   strc.removeSuffix(' ')

   var strl = getBTreeNodeStr(leftBTreeNode)
   strl.removeSuffix(' ')

   var strr = getBTreeNodeStr(rightBTreeNode)
   strr.removeSuffix(' ')
   #let lenc = len(strc)
   let lenc = len(strn)
   let lenl = len(strl)
   let lenr = len(strr)

   #log("    ListNode.Pictorial Representation       \n")
   var cp = curpos
   cursorForward cp
   #log("%s\n",strc)
   log("%s\n\n",strn)
   cursorForward cp - lenl
   log("%s\n",strl)
   cursorUp 1
   cursorForward cp + lenc 
   log("%s",strr)
   var def = "\e[0m"
   echo def

#}

proc drawBTreeNode*(curpos: int = 42, key: int): void =
#{
    drawBTreeNode(curpos, getKeyListNode(key))
#}

proc printListNode*(node: ref ListNode, idx: int, tot: int, sn: bool = false): void =
#{

   if (node == nil):
     log("Current ListNode is NULL\n")
     return
   
   var key = node.key
   var keyaddr = getAddress(node)
   var currBTN = cast[ref BTreeNode] (node.currentBTreeNode)
   if (currBTN == nil):
     log("Current BTreeNode is NULL\n")
     return

   var currBTNType: string
   if (currBTN.bt_type == BT_LEAF):
     currBTNType.add("[ LEAF ]")
   elif (currBTN.bt_type == BT_NODE):
     currBTNType.add("[ NODE ]")
   else:
     currBTNType.add("[ ROOT ]")
   var level = getBTreeNodeLevel(currBTN)
   var parentListNode = node.parentListNode
   var parentBTN: ref BTreeNode
   var parentBTNType: string
   if (parentListNode != nil):
     parentBTN = cast[ref BTreeNode] (parentListNode.currentBTreeNode)
     if (parentBTN.bt_type == 0):
       parentBTNType.add("[ LEAF ]")
     else:
       parentBTNType.add("[ ROOT ]")
   else:
     parentBTN = nil
   if (sn == true):
     log("[<--------- ListNode  Begin ------>\n", idx, tot)
   else:
     log("[<--------- ListNode  Begin[%d/%d] ---------->\n", idx, tot)
   log("    ListNode.key                          = %-10d [Address = %s]\n",
            key, getAddressHex(node) )
   log("    ListNode.Level and Type               = LEVEL[%d] TYPE[%d] = >%s\n", level, currBTN.bt_type, currBTNType)
   log("    ListNode.currentBTreeNode             = %-10s [Address = %s]\n", 
            getBTreeNodeStr(currBTN), getAddressHex(currBTN))
   if (node.parentListNode != nil):
     log("    ListNode.ParentListNodeKey            = %-10d [Address = %s]\n", 
              getListNodeParent(node).key, getAddressHex(getListNodeParent(node)))
   else:
     log("    ListNode.ParentListNodeKey            = NULL\n")

   if (parentBTN != nil):
     log("    ListNode.ParentBTreeNode              = %-10s [Address = %s]\n",
              getBTreeNodeStr(parentBTN), getAddressHex(parentBTN))
   else:
     log("    ListNode.ParentBTreeNode              = NULL\n")

   if (node.next == nil):
     log("    ListNode.nextKey in Current BTreeNode = NULL\n")
   else:
     log("    ListNode.nextKey in Current BTreeNode = %-10d [Address = %s]\n",
         node.next.key, getAddressHex(node.next))

   if (node.prev == nil):
     log("    ListNode.prevKey in Current BTreeNode = NULL\n")
   else:
     log("    ListNode.prevKey in Current BTreeNode = %-10d [Address = %s]\n",
         node.prev.key, getAddressHex(node.prev))

   var leftBTreeNode  = getBTreeNodeLeft(node)
   var rightBTreeNode = getBTreeNodeRight(node)
   if (leftBTreeNode == nil):
     log("    ListNode.leftBTreeNode                = NULL\n")
   else:
     log("    ListNode.leftBTreeNode                = %-10s [Address = %s]\n",
              getBTreeNodeStr(leftBTreeNode), getAddressHex(leftBTreeNode))

   if (rightBTreeNode == nil):
     log("    ListNode.rightBTreeNode               = NULL\n")
   else:
     log("    ListNode.rightBTreeNode               = %-10s [Address = %s]\n",
              getBTreeNodeStr(rightBTreeNode), getAddressHex(rightBTreeNode))

   log("\n")

   drawBTreeNode(42, node)

   log("\n")
   if (sn == true):
     log("[<--------- ListNode    End ------>\n\n", idx, tot)
   else:
    log("[<--------- ListNode    End[%d/%d] ---------->\n\n", idx, tot)
#}

proc printListNodeF*(node: ref ListNode, idx: int, tot: int): void =
#{
   var key = node.key
   var keyaddr = getAddress(node)
   var curaddr = cast[ref BTreeNode] (node.currentBTreeNode)
   var level = getBTreeNodeLevel(curaddr)
   var parentListNode = node.parentListNode
   var parentBTreeNode: ref BTreeNode
   if (parentListNode != nil):
     parentBTreeNode = cast[ref BTreeNode] (parentListNode.currentBTreeNode)
   else:
     parentBTreeNode = nil
   logf("[<--------- ListNode  Begin[%d/%d] ---------->", idx, tot)
   logf(" ListNode                      = %s", getAddressHex(node) )
   logf(" ListNode.key                  = %d", key)
   logf(" ListNode.level                = %d", level)
   logf(" ListNode.currentBTreeNode     = %s", getAddressHex(curaddr))
   logf(" ListNode.currentBTreeNode     = %s", getBTreeNodeStr(curaddr))
   logf(" ListNode.ParentListNode       = %s", getAddressHex(getListNodeParent(node)))

   if (node.parentListNode != nil):
     logf(" ListNode.ParentListNodeKey    = %d", getListNodeParent(node).key)
   else:
     logf(" ListNode.ParentListNodeKey    = NULL")

   logf(" ListNode.ParentBTreeNode      = %s", getAddressHex(parentBTreeNode))
   if (parentBTreeNode != nil):
     logf(" ListNode.ParentBTreeNode      = %s", getBTreeNodeStr(parentBTreeNode))
   else:
     logf(" ListNode.ParentBTreeNode      = NULL")

   if (node.next == nil):
     logf(" ListNode.next                 = %s", getAddressHex(node.next))
   else:
     logf(" ListNode.next                 = %s next.key = %d",
         getAddressHex(node.next), node.next.key)

   if (node.prev == nil):
     logf(" ListNode.prev                 = %s", getAddressHex(node.prev))
   else:
     logf(" ListNode.prev                 = %s prev.key = %d",
         getAddressHex(node.prev), node.prev.key)


   var leftBTreeNode  = getBTreeNodeLeft(node)
   var rightBTreeNode = getBTreeNodeRight(node)
   var str:string
   if (leftBTreeNode != nil):
     str.add(" ListNode.leftBTreeNode        = [ ")
     var node = leftBTreeNode.bt_listhead
     while (node != nil):
       str.add("" & $node.key)
       str.add(" ")
       node = node.next
     str.add("]")
     logf(str)

   str = ""
   if (rightBTreeNode != nil):
     str.add(" ListNode.rightBTreeNode       = [ ")
     var node = rightBTreeNode.bt_listhead
     while (node != nil):
       str.add("" & $node.key)
       str.add(" ")
       node = node.next
     str.add("]")
     logf(str)

   logf("[<--------- ListNode    End[%d/%d] ---------->", idx, tot)
#}

proc printBTreeNode*(root: ref BTreeNode): void =
#{
   if (root == nil):
     return
   var middle = getMiddleNode(root)

   var parentListNode = getListNodeParent(getBTreeNodeKeyList(root))
   var parentBTreeNode: ref BTreeNode = nil

   if (parentListNode != nil):
     parentBTreeNode = getCurrentBTreeNode(parentListNode)
   else:
     parentBTreeNode = nil

   echo "[<--------- BTreeNode Begin ---------->"
   log(" BTreeNode                     = %s\n", getAddressHex(root) )
   log(" BTreeNode.ID                  = %s\n",  root.bt_id)
   if (root.bt_type == BT_ROOT): #{
     log(" BTreeNode.type                = ROOT\n")
   elif (root.bt_type == BT_NODE):
     log(" BTreeNode.type                = INTERNAL_NODE\n")
   else:
     log(" BTreeNode.type                = LEAF\n")
   #}
   log(" BTreeNode.level               = %d\n", root.bt_level)
   
   log(" BTreeNode.degree              = %d\n", BT_DEGREE)
   log(" BTreeNode.order               = %d\n", BT_DEGREE)
   var minchld:float
   minchld = cast[int](BT_DEGREE) / 2
   log(" BTreeNode.head                = %d\n", root.bt_listhead.key)
   log(" BTreeNode.head                = %s\n", getAddressHex(root.bt_listhead))
   log(" BTreeNode.tail                = %d\n", root.bt_listtail.key)
   log(" BTreeNode.tail                = %s\n", getAddressHex(root.bt_listtail))
   log(" BTreeNode.cnum(No. of childs) = %d\n", root.bt_numchild)
   log(" BTreeNode.maxchild            = %d\n", BT_MAXCHLD)
   stdout.write(" BTreeNode.minchild            = " & $minchld & "\n")
   log(" BTreeNode.knum(No. of keys)   = %d\n", root.bt_numkeys)
   log(" BTreeNode.maxkeys             = %d\n", BT_MAXKEYS)
   log(" BTreeNode.middleKey           = %d\n", middle.key)
   log(" BTreeNode.middleNode          = %s\n", getAddressHex(middle))
   log(" BTreeNode.parent              = %s\n", getAddressHex(parentBTreeNode))

   if (parentBTreeNode != nil):
     log(" BTreeNode.parent              = %s, KEY = %d\n",
     parentBTreeNode.bt_id, parentBTreeNode.bt_listhead.key)

   log(" BTreeNode.keyList             = [ ")
   var node = root.bt_listhead
   while (node != nil):
     log("%d ",node.key)
     node = node.next
   stdout.write("]\n")
   echo "]<--------- BTreeNode   End ---------->"
#}

proc printBTreeNodeF*(root: ref BTreeNode, idx: int, tot: int): void =
#{
   if (root == nil):
     return
   var middle = getMiddleNode(root)
   var parentListNode = getListNodeParent(getBTreeNodeKeyList(root))
   var parentBTreeNode: ref BTreeNode = nil

   if (parentListNode != nil):
     parentBTreeNode = getCurrentBTreeNode(parentListNode)
   else:
     parentBTreeNode = nil


   logf("[<--------- BTreeNode Begin[%d/%d] ---------->", idx, tot)
   logf(" BTreeNode                     = %s", getAddressHex(root) )
   logf(" BTreeNode.ID                  = %s",  root.bt_id)
   if (root.bt_type == BT_ROOT): #{
     logf(" BTreeNode.type                = ROOT")
   elif (root.bt_type == BT_NODE):
     logf(" BTreeNode.type                = INTERNAL_NODE")
   else:
     logf(" BTreeNode.type                = LEAF")
   #}
   
   logf(" BTreeNode.level               = %d", root.bt_level)
   logf(" BTreeNode.degree              = %d", BT_DEGREE)
   logf(" BTreeNode.order               = %d", BT_DEGREE)
   var minchld:float
   minchld = cast[int](BT_DEGREE) / 2
   logf(" BTreeNode.head                = %d", root.bt_listhead.key)
   logf(" BTreeNode.head                = %s", getAddressHex(root.bt_listhead))
   logf(" BTreeNode.tail                = %d", root.bt_listtail.key)
   logf(" BTreeNode.tail                = %s", getAddressHex(root.bt_listtail))
   logf(" BTreeNode.cnum(No. of childs) = %d", root.bt_numchild)
   logf(" BTreeNode.maxchild            = %d", BT_MAXCHLD)
   #stdout.write(" BTreeNode.minchild          = " & $minchld & "\n")
   #logf(" BTreeNode.minchild            = %f", minchld)
   logf(" BTreeNode.knum(No. of keys)   = %d", root.bt_numkeys)
   logf(" BTreeNode.maxkeys             = %d", BT_MAXKEYS)
   logf(" BTreeNode.middleKey           = %d", middle.key)
   logf(" BTreeNode.middleNode          = %s", getAddressHex(middle))
   logf(" BTreeNode.parent              = %s", getAddressHex(parentBTreeNode))
   var str:string
   if (parentBTreeNode != nil):
     str.add(" BTreeNode.parentBTreeNode     = [ ")
     var node = parentBTreeNode.bt_listhead
     while (node != nil):
       str.add("" & $node.key)
       str.add(" ")
       node = node.next
     str.add("]")
     logf(str)

   str = ""
   str.add(" BTreeNode.keyList             = [ ")
   var node = root.bt_listhead
   while (node != nil):
     str.add("" & $node.key)
     str.add(" ")
     node = node.next
   str.add("]")
   logf(str)
   logf("]<--------- BTreeNode   End[%d/%d] ---------->", idx, tot)
#}

proc printBTreeArray*(): void =
#{
   for node in btarray:
     printBTreeNode(node)
   log("Total BTreeNodes  : %d\n", len(btarray))
   logf("Total BTreeNodes  : %d\n", len(btarray))
#}

proc printBTreeArrayF*(): void =
#{
   for idx, node in btarray:
     printBTreeNodeF(node, idx+1, len(btarray))
   logf("Total BTreeNodes     : %d\n", len(btarray))
#}

proc printBTreeListF*(): void =
#{
   for idx, node in btlist:
     printListNodeF(node, idx+1, len(btlist))
   logf("Total ListNodes : %d\n", len(btlist))
#}
proc printBTreeList*(): void =
#{
   for idx, node in btlist:
     printListNode(node, idx+1, len(btlist))
   log("Total ListNodes  : %d\n", len(btlist))
   log("Total BTreeNodes : %d\n\n", len(btarray))
#}

proc getBTreeNodeStr*(arg_node: ref BTreeNode): string =
#{
   if (arg_node == nil):
     return "[ NULL ]"
   var str = ""
   str.add("[ ")
   var node = arg_node.bt_listhead
   while (node != nil):
     str.add("" & $node.key)
     str.add(" ")
     node = node.next
   str.add("] ")
   return str
#}
