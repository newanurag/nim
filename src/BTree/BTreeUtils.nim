import std/math
import std/os
import strutils
import CommonImports
import CommonLogger
import CommonUtils
import BTreeHeader

#Function Prototype Declaration
proc getid*(): string
proc btsleep*(x: int): void
proc btsleeps*(x: int): void
proc newListNode*(key: int): ref ListNode
proc newBTreeNode*(): ref BTreeNode
proc newBTreeNode*(key: int): ref BTreeNode
proc newBTreeNode*(node: ref ListNode): ref BTreeNode
proc getMiddleNode*(head: ref ListNode): ref ListNode
proc getMiddle*(head: ref ListNode): ref ListNode
proc getMiddleNode*(root: ref BTreeNode): ref ListNode
proc setValue*(node: var ref ListNode, value: pointer): void
proc getbsize*(): int
proc getAddress*(root: ref BTreeNode): int64
proc getAddressHex*(root: ref BTreeNode): cstring
proc getAddress*(head: ref ListNode): int64
proc getAddressHex*(head: ref ListNode): cstring
proc setRoot*(btnode: var ref BTreeNode): void
proc getRoot*(): ref BTreeNode
proc getIDStr*(root: ref BTreeNode): string
proc getIDStr*(): string
proc getBTreeNodeKeyList*(btnode: ref BTreeNode): ref ListNode
proc setBTreeNodeKeyList*(btnode: var ref BTreeNode, newlist: ref ListNode): void
proc getBTreeNodeKeyListHead*(btnode: ref BTreeNode): ref ListNode
proc getBTreeNodeKeyListTail*(btnode: ref BTreeNode): ref ListNode
proc getBTreeNodeLeft*(node: ref ListNode): ref BTreeNode
proc getBTreeNodeLeft*(root: ref BTreeNode): ref BTreeNode
proc getBTreeNodeRight*(node: ref ListNode): ref BTreeNode
proc getBTreeNodeRight*(root: ref BTreeNode): ref BTreeNode
proc setBTreeNodeLeft*(node: var ref ListNode, leftBTN: var ref BTreeNode): void
proc setBTreeNodeLeft*(currBTN: var ref BTreeNode, leftBTN: var ref BTreeNode): void
proc setBTreeNodeRight*(node: var ref ListNode, rightBTN: var ref BTreeNode): void
proc setBTreeNodeRight*(currBTN: var ref BTreeNode, rightBTN: var ref BTreeNode): void
proc getBTreeNodeNumKeys*(btnode: ref BTreeNode): int
proc isBTreeNodeFull*(btnode: ref BTreeNode): bool
proc setBTreeNodeType*(btnode: var ref BTreeNode, nodetype: int): void
proc setBTreeNodeLevel*(btnode: var ref BTreeNode, level: int): void
proc getBTreeNodeLevel*(btnode: ref BTreeNode): int
proc getCurrentBTreeNode*(listnode: ref ListNode): ref BTreeNode
proc setCurrentBTreeNode*(list: var ref ListNode, parentBTN: ref BTreeNode): void
proc setCurrentBTreeNode*(btnode: var ref BTreeNode): void
proc getListNodeParent*(node: ref ListNode): ref ListNode
proc setListNodeParent*(listnode: var ref ListNode, pListNode: ref ListNode, all: bool = false): void
proc setListNodeParent*(btnode: var ref BTreeNode, pListNode: ref ListNode, all: bool = false): void
proc getKey*(btnode: ref BTreeNode): int
proc getKey*(listnode: ref ListNode): int
proc getDebugLevel*(): int
proc setDebugLevel*(dbglvl: int): void

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

proc btsleep*(x: int): void =
#{
   sleep(x)
#}
proc btsleeps*(x: int): void =
#{
   sleep(x * 1000)
#}

proc newListNode*(key: int): ref ListNode =
#{
   var obj              = new ListNode
   if (obj == nil):
     log("Error: Unable to allocate memory for ListNode\n")
     return nil
   obj.key              = key
   obj.next             = nil
   obj.prev             = nil
   obj.leftBTreeNode    = nil
   obj.rightBTreeNode   = nil
   obj.currentBTreeNode = nil
   obj.parentListNode   = nil
   btlist.add(obj)
   #log("ListNode [%d] Created for key [%d]\n",len(btlist), key);
   logf("ListNode [%d] Created for key [%d]\n",len(btlist), key);
   return obj
#}

proc newBTreeNode*(): ref BTreeNode =
#{
   var bnode         = new BTreeNode
   if (bnode == nil):
     log("Error: Unable to allocate memory for BTreeNode\n")
     return nil
   bnode.bt_id       = getid()
   bnode.bt_listhead = nil
   bnode.bt_listtail = nil
   bnode.bt_type     = BT_LEAF
   bnode.bt_numkeys  = 0
   bnode.bt_numchild = 0
   bnode.bt_level    = 0
   log("BTreeNode %s Created\n", bnode.bt_id);
   logf("BTreeNode %s Created\n", bnode.bt_id);
   btarray.add(bnode)
   return bnode
#}

proc newBTreeNode*(key: int): ref BTreeNode =
#{
   var lnode              = newListNode(key)
   var bnode              = new BTreeNode
   if (bnode == nil):
     log("Error: Unable to allocate memory for BTreeNode\n")
     return nil

   lnode.currentBTreeNode = cast[pointer](bnode)

   bnode.bt_id            = getid()
   bnode.bt_listhead      = lnode
   bnode.bt_listtail      = lnode
   bnode.bt_type          = BT_LEAF
   bnode.bt_numkeys       = 1
   bnode.bt_numchild      = 0
   bnode.bt_level         = 0
   #log("BTreeNode %s Created for key [%d]\n", (bnode.bt_id), lnode.key);
   logf("BTreeNode %s Created for key [%d]\n", (bnode.bt_id), lnode.key);
   btarray.add(bnode)
   return bnode
#}

proc newBTreeNode*(node: ref ListNode): ref BTreeNode =
#{
   var lnode           = node
   var bnode           = new BTreeNode
   if (bnode == nil):
     log("Error: Unable to allocate memory for BTreeNode\n")
     return nil
   bnode.bt_id         = getid()
   bnode.bt_listhead   = lnode
   bnode.bt_type       = BT_LEAF
   bnode.bt_numkeys    = 0
   bnode.bt_numchild   = 0
   bnode.bt_level      = 0

   #log("BTreeNode %s Created for key [%d]\n", (bnode.bt_id), lnode.key);
   logf("BTreeNode %s Created for key [%d]\n", (bnode.bt_id), lnode.key);
   
   while(lnode != nil):
     lnode.currentBTreeNode = cast[pointer] (bnode)
     bnode.bt_numkeys       = bnode.bt_numkeys + 1
     bnode.bt_listtail      = lnode
     lnode = lnode.next
   
   btarray.add(bnode)
   return bnode
#}

proc getMiddleNode*(head: ref ListNode): ref ListNode =
#{
   if (head == nil): 
     return nil
   var slow = head
   var fast = head

   while (fast != nil and fast.next != nil): #{
     #printf("SLOW = %d\n", slow.key)
     slow = slow.next
     fast = fast.next.next
   #}

  
   return slow
#}

proc getMiddle*(head: ref ListNode): ref ListNode =
#{
   return getMiddleNode(head)
#}

proc getMiddleNode*(root: ref BTreeNode): ref ListNode =
#{
   if (root == nil):
     return nil

   var slow = root.bt_listhead
   var fast = root.bt_listhead

   while (fast != nil and fast.next != nil): #{
     #printListNode(slow, "SLOW")
     #printListNode(fast, "FAST")
     slow = slow.next
     fast = fast.next.next
   #}  
   return slow
#}

proc setValue*(node: var ref ListNode, value: pointer): void =
#{
   node.value = cast[pointer](value)
#}

proc getbsize*(): int =
#{
  return len(btarray)
#}

proc getAddress*(root: ref BTreeNode): int64 =
#{
   #var v  = cast[int64](unsafeAddr(root[]))
   var v2 = cast[int64](cast[pointer](root))
   #stdout.write(" BTreeNode         = 0x" & v2.toHex & "\n")
   #echo " BTreeNode         = 0x",v.toHex
   #echo root.repr
   
   return v2
#}

proc getAddressHex*(root: ref BTreeNode): cstring =
#{
   #var v  = cast[int64](unsafeAddr(root[]))
   #var v2 = cast[int64](cast[pointer](root))
   var v2 = getAddress(root)
   #stdout.write(" BTreeNode         = 0x" & v2.toHex & "\n")
   #echo " BTreeNode         = 0x",v.toHex
   #echo root.repr
   var  str =  "0x"
   str.add(v2.toHex)
   var outstr:cstring = str.cstring
   return outstr
   #return "0x" & v2.toHex
#}

proc getAddressHex*(root: pointer): cstring =
#{
   var v = cast[int64](root)
   var  str =  "0x"
   str.add(v.toHex)
   var outstr:cstring = str.cstring
   return outstr
#}

proc getAddress*(head: ref ListNode): int64 =
#{
   #var v  = cast[int64](unsafeAddr(head[]))
   var v2 = cast[int64](cast[pointer](head))
   return v2
#}

proc getAddressHex*(head: ref ListNode): cstring =
#{
   #var v  = cast[int64](unsafeAddr(head[]))
   var v2 = cast[int64](cast[pointer](head))
   #var outstr = cast[cstring]( "0x" & v2.toHex)
   var  str =  "0x"
   str.add(v2.toHex)
   var outstr:cstring = str.cstring
   return outstr
   #return "0x" & v2.toHex
#}

proc setRoot*(btnode: var ref BTreeNode): void =
#{
    btroot = btnode
    #btroot.bt_type = BT_ROOT
#}

proc getRoot*(): ref BTreeNode =
#{
    return btroot
#}

proc getIDStr*(root: ref BTreeNode): string =
#{
    return root.bt_id
#}

proc getIDStr*(): string =
#{
    return getIDStr(getRoot())
#}


proc getBTreeNodeKeyList*(btnode: ref BTreeNode): ref ListNode =
#{
    return btnode.bt_listhead
#}

proc setBTreeNodeKeyList*(btnode: var ref BTreeNode, newlist: ref ListNode): void =
#{
    btnode.bt_listhead = newlist
#}

proc getBTreeNodeKeyListHead*(btnode: ref BTreeNode): ref ListNode =
#{
    return getBTreeNodeKeyList(btnode)
#}

proc getBTreeNodeKeyListTail*(btnode: ref BTreeNode): ref ListNode =
#{
    return btnode.bt_listtail
#}

proc getBTreeNodeLeft*(node: ref ListNode): ref BTreeNode =
#{
   return cast[ref BTreeNode](node.leftBTreeNode)
#}

proc getBTreeNodeLeft*(root: ref BTreeNode): ref BTreeNode =
#{
   return getBTreeNodeLeft(root.bt_listhead)
#}

proc getBTreeNodeRight*(node: ref ListNode): ref BTreeNode =
#{
   #var right = cast[ref BTreeNode](node.rightBTreeNode)
   #return right
   return cast[ref BTreeNode](node.rightBTreeNode)
#}

proc getBTreeNodeRight*(root: ref BTreeNode): ref BTreeNode =
#{
   return getBTreeNodeRight(root.bt_listtail)
#}

proc setBTreeNodeLeft*(node: var ref ListNode, leftBTN: var ref BTreeNode): void =
#{
   node.leftBTreeNode = cast[pointer](leftBTN)
   if (leftBTN != nil):
     setListNodeParent(leftBTN, node, true)
#}

proc setBTreeNodeLeft*(currBTN: var ref BTreeNode, leftBTN: var ref BTreeNode): void =
#{
   setBTreeNodeLeft(currBTN.bt_listhead, leftBTN)
#}

proc setBTreeNodeRight*(node: var ref ListNode, rightBTN: var ref BTreeNode): void =
#{
   node.rightBTreeNode = cast[pointer](rightBTN)
   if (rightBTN != nil):
     setListNodeParent(rightBTN, node, true)
#}

proc setBTreeNodeRight*(currBTN: var ref BTreeNode, rightBTN: var ref BTreeNode): void =
#{
   setBTreeNodeRight(currBTN.bt_listtail, rightBTN)
#}

proc getBTreeNodeNumKeys*(btnode: ref BTreeNode): int =
#{
    if (btnode == nil):
      log("ERROR: BTreeNode is NULL. Returning -1 for numkeys\n")
      var st = getStackTraceEntries()
      echo st
      return -1
    return btnode.bt_numkeys
#}

proc isBTreeNodeFull*(btnode: ref BTreeNode): bool =
#{
    if (btnode == nil):
      log("ERROR: BTreeNode is NULL. Returning FALSE\n")
      return BT_FALSE
    
    var numkeys = getBTreeNodeNumKeys(btnode)
    if (numkeys == BT_MAXKEYS):
      return BT_TRUE
    else:
      return BT_FALSE
#}

proc getKeyListNode*(key: int): ref ListNode =
#{
    for idx, listnode in btlist:
      if (listnode.key == key):
        return listnode
    
    return nil
#}

proc setBTreeNodeType*(btnode: var ref BTreeNode, nodetype: int): void =
#{
    btnode.bt_type = nodetype
#}
proc getBTreeNodeType*(btnode: ref BTreeNode): int =
#{
    return btnode.bt_type
#}

proc setBTreeNodeLevel*(btnode: var ref BTreeNode, level: int): void =
#{
    btnode.bt_level = level
    if (level > BT_MAXLEVEL):
      BT_MAXLEVEL = level
#}

proc getBTreeNodeLevel*(btnode: ref BTreeNode): int =
#{
    if (btnode == nil):
      return low(int)
    return btnode.bt_level
#}

proc getCurrentBTreeNode*(listnode: ref ListNode): ref BTreeNode =
#{
    return cast[ref BTreeNode] (listnode.currentBTreeNode)
#}

proc setCurrentBTreeNode*(list: var ref ListNode, parentBTN: ref BTreeNode): void =
#{
    var listnode = list
    while(listnode != nil):
      listnode.currentBTreeNode = cast[pointer] (parentBTN)
      listnode = listnode.next
#}

proc setCurrentBTreeNode*(btnode: var ref BTreeNode): void =
#{
    var listnode = getBTreeNodeKeyList(btnode)
    var numkeys  = 0
    var numchild = 0
    while(listnode != nil):
      listnode.currentBTreeNode = cast[pointer] (btnode)
      numkeys  = numkeys + 1

      if (listnode.leftBTreeNode != nil):
        numchild = numchild + 1

      if (listnode.rightBTreeNode != nil):
        numchild = numchild + 1

      listnode = listnode.next

    btnode.bt_numkeys  = numkeys
    btnode.bt_numchild = numchild
#}

proc getListNodeParent*(node: ref ListNode): ref ListNode =
#{
   if (node == nil):
     log("node is NULL. It should not have happened\n")
     return nil
   return node.parentListNode
#}

proc setListNodeParent*(listnode: var ref ListNode, pListNode: ref ListNode, all: bool = false): void =
#{
    if (all == false):
      listnode.parentListNode = pListNode
    else:
      var node = listnode
      while(node != nil): 
        node.parentListNode = pListNode
        node = node.next
#}

proc setListNodeParent*(btnode: var ref BTreeNode, pListNode: ref ListNode, all: bool = false): void =
#{
     var keylist = getBTreeNodeKeyList(btnode)
     setListNodeParent(keylist, pListNode, all)
#}

proc getKey*(listnode: ref ListNode): int =
#{
    return listnode.key
#}

proc getKey*(btnode: ref BTreeNode): int =
#{
    return getKey(btnode.bt_listhead)
#}

proc getDebugLevel*(): int =
#{
    return btdebug
#}
proc setDebugLevel*(dbglvl: int): void =
#{
    btdebug = dbglvl
#}
