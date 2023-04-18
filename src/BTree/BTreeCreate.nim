#################################################
# IMPLEMENTATION OF BTREE IN NIM LANGUAGE
#################################################
#import std/math
#import std/os
import strutils
import std/math
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

# Procs Forward Declaration
proc createBTree*(keys: seq[int]):ref BTreeNode

proc initBTree*(order: int = BT_DEFAULT_ORDER,
                  logfile: string = BT_DEFAULT_LOG_FILE,
                  ): ref BTreeNode

proc insertBTree*(key: int): int
proc insertBTree*(root: var ref BTreeNode, key: int, value: pointer = nil): int
proc insertKey(root: var ref BTreeNode, key: int, value: pointer = nil): int
proc insertKeyNode(arg_root   : var ref BTreeNode,
                   arg_middle : var ref ListNode,
                   arg_left   : var ref BTreeNode,
                   arg_right  : var ref BTreeNode ): void

proc splitBTreeNode(currBTreeNode: var ref BTreeNode): int

proc insertKey(root: var ref BTreeNode, key: int, value: pointer = nil): int =
#{
   if (root == nil): #{
     return BT_FAILURE
   #}

   var newnode  = newListNode(key)
   if (newnode == nil):
     return BT_FAILURE

   setValue(newnode, value)
   var head    = root.bt_listhead
   if (head == nil):
     root.bt_listhead = newnode
     root.bt_listtail = root.bt_listhead
     root.bt_numkeys  = root.bt_numkeys + 1 
     setListNodeParent(newnode, nil)
     log("DEBUG: CASE-0: Key [%d] is inserted at Level [%d] in empty BTreeNode\n",
     key, getBTreeNodeLevel(root))
     return BT_SUCCESS

   # Insert the key in extreme left
   # CASE-1: Extreme Left Insertion
   if (key < head.key): #{
     newnode.next = head
     head.prev = newnode
     root.bt_listhead = newnode
     setCurrentBTreeNode(root)
     setListNodeParent(newnode, getListNodeParent(head))
     if (getDebugLevel() == BT_DEBUG_LEVEL_D):
       log("DEBUG: CASE-1: Input Key[%d] is inserted at Level [%d] in BTreeNode %s\n",
       key, getBTreeNodeLevel(root), getBTreeNodeStr(root))
     return BT_SUCCESS
   #}

   # Insert the key in extreme right
   # CASE-2: Extreme Right Insertion
   var tail    = root.bt_listtail
   if (key > tail.key): #{
     tail.next = newnode
     newnode.prev = tail
     root.bt_listtail = newnode
     setCurrentBTreeNode(root)
     setListNodeParent(newnode, getListNodeParent(tail))
     if (getDebugLevel() == BT_DEBUG_LEVEL_D):
       log("DEBUG: CASE-2: Input Key[%d] is inserted at Level [%d] in BTreeNode %s\n",
       key, getBTreeNodeLevel(root), getBTreeNodeStr(root))
     log("DEBUG:AF type = %d\n", root.bt_type)
     return BT_SUCCESS
   #} End of if loop

   var prev: ref ListNode = nil
   head = root.bt_listhead

   while (head != nil): #{
     if (key < head.key): #{
       prev.next = newnode
       newnode.prev = prev
       newnode.next = head
       head.prev = newnode
       setCurrentBTreeNode(root)
       setListNodeParent(newnode, getListNodeParent(head))
       if (getDebugLevel() == BT_DEBUG_LEVEL_D):
         log("DEBUG: CASE-3: Input Key[%d] is inserted at Level [%d] in BTreeNode %s\n",
         key, getBTreeNodeLevel(root), getBTreeNodeStr(root))
       return BT_SUCCESS
     #} End of if loop
     prev = head
     head = head.next
   #} End of while loop
#}

proc insertKeyNode(argRoot   : var ref BTreeNode, # This is the main BTreeNode where the
                                                  # middle node is going to be inserted
                   argMiddle : var ref ListNode,  # This is the newnode which is going
                                                  # to be inserted
                   argLeft   : var ref BTreeNode, # This is the left subtree of newnode
                   argRight  : var ref BTreeNode  # This is the right subtree of newnode
                   ): void =
#{
    var middleNode      = argMiddle
    var currkeynode     = getBTreeNodeKeyList(argRoot)
    var lastkeynode     = getBTreeNodeKeyListTail(argRoot)
    var argleftkeynode  = getBTreeNodeKeyList(argLeft)
    var argrightkeynode = getBTreeNodeKeyList(argRight)
    var prevkeynode: ref ListNode = nil

    if (getDebugLevel() == BT_DEBUG_LEVEL_D):
      var argrootlevel    = getBTreeNodeLevel(argRoot)
      var argleftlevel    = getBTreeNodeLevel(argLeft)
      var argrightlevel   = getBTreeNodeLevel(argLeft)
      log("currkeynode               = %d\n", currkeynode.key)
      log("lastkeynode               = %d\n", lastkeynode.key)
      log("argleftkeynode            = %d\n", argleftkeynode.key)
      log("argrightkeynode           = %d\n", argrightkeynode.key)
      log("middleNode                = %d\n", middleNode.key)
      log("middleNode.parentListNode = %d\n", middleNode.parentListNode.key)
      log("argrootlevel  and type    = %d %d\n", argrootlevel, argRoot.bt_type)
      log("argleftlevel  and type    = %d %d\n", argleftlevel, argLeft.bt_type)
      log("argrightlevel and type    = %d %d\n", argrightlevel, argRight.bt_type)

    # Case 1: When the to-be-inserted node i.e. argMiddle  lies in the
    # extreme left of the arg_root BTreeNode

    # CASE-1: Extreme Left Insertion
    if (middleNode.key < currkeynode.key): #{ 

      var oldleftchild = getBTreeNodeLeft(argRoot)
   
      #Five Operations are required
      #OP1: Set the parent of newly added Middle as parent of existing argRoot
      setListNodeParent(middleNode, getListNodeParent(currkeynode))

      #OP2: Disconnect the leftside subtree/BTreeeNode
      if (oldleftchild != nil):
        var NULLL: ref BTreeNode = nil
        setBTreeNodeLeft(argRoot, NULLL)

      #OP3: Middle is now inserted into parent Btree node and at the starting position
      middleNode.next          = currkeynode
      currkeynode.prev         = middleNode
      setBTreeNodeKeyList(argRoot, middleNode)

      #OP4: Save the right subtree of new Node.
      #Assign it to the Right subtree(argRight) of middleNode as its left child
      var oldright  = getBTreeNodeRight(middleNode)
      if (oldright != nil):
        setBTreeNodeLeft(argRight, oldright)

      #OP5: Set Middle as parent of argleft and argright BTreeNodes
      #It will also set the parent as Middle node to all left and
      #right subtree nodes
      setBTreeNodeLeft(middleNode,  argLeft)
      setBTreeNodeRight(middleNode, argRight)

    
      setCurrentBTreeNode(argRoot)
      setCurrentBTreeNode(argLeft)
      setCurrentBTreeNode(argRight)
      log("DEBUG: CASE-1: Extreme Left Insertion: Level[%d][%s]=%s\n",
      getBTreeNodeLevel(argRoot), getAddressHex(argRoot), getBTreeNodeStr(argRoot))
      return
    #}

    # CASE-2: Extreme Right Insertion
    if (middleNode.key > lastkeynode.key): #{

      #Five Operations are required
      #OP1: Set the parent of newly added Middle as parent of existing argRoot
      setListNodeParent(middleNode, getListNodeParent(lastkeynode))

      var tail = getBTreeNodeKeyListTail(argRoot)
      #OP2: Set the new i.e middle node as last/tail node in the existing keylist
      tail.next = middleNode
      middleNode.prev = tail
      argRoot.bt_listtail = middleNode

      #OP3: Save the right subtree of new Node.
      #Assign it to the Right subtree of middleNode as its left child
      var oldright = getBTreeNodeRight(middleNode)
      if (oldright != nil):
        setBTreeNodeLeft(argRight, oldright)

      #OP4: Set the middleNode right child as argRight
      setBTreeNodeRight(middleNode, argRight) 

      #OP5: Now set previous of middle node with right child subtree as argLeft
      setBtreeNodeRight(middleNode.prev, argLeft)


      setCurrentBTreeNode(argRoot)
      setCurrentBTreeNode(argLeft)
      setCurrentBTreeNode(argRight)

      log("DEBUG: CASE-2: Extreme Right Insertion: Level[%d][%s]=%s\n",
      getBTreeNodeLevel(argRoot), getAddressHex(argRoot), getBTreeNodeStr(argRoot))
      return
    #}

    # CASE-3: Intermediate Node Insertion
    while(currkeynode != nil): #{

      if (middleNode.key < currkeynode.key): #{

        #Five operations required
        #OP1: Set the parent of newly added Middle as parent of existing argRoot
        setListNodeParent(middleNode, getListNodeParent(currkeynode))

        #OP2: Insert the new i.e. middle node into the existing keylist
        prevkeynode.next = middleNode
        middleNode.next  = currkeynode
        currkeynode.prev = middleNode
        middleNode.prev  = prevkeynode
        
        #OP3: Save the right subtree of new Node.
        #Assign it to the Right BTreeNode as its left child
        var oldright = getBTreeNodeRight(middleNode)
        if (oldright != nil):
          setBTreeNodeLeft(argRight, oldright)

        #OP4: Now set the middle Node right child as argRight
        setBTreeNodeRight(middleNode, argRight)

        #OP5: Now set the previous node of middle with the right child as argLeft subtree 
        setBTreeNodeRight(prevkeynode, argLeft)


        setCurrentBTreeNode(argRoot)
        setCurrentBTreeNode(argLeft)
        setCurrentBTreeNode(argRight)

        log("DEBUG: CASE-3: Intermediate  Insertion: Level[%d][%s]=%s\n",
        getBTreeNodeLevel(argRoot), getAddressHex(argRoot), getBTreeNodeStr(argRoot))
        return

      #}
      prevkeynode = currkeynode
      currkeynode = currkeynode.next
    #}
#} End of function insertKeyNode

proc splitBTreeNode(currBTreeNode: var ref BTreeNode): int =
#{
   splitcnt = splitcnt + 1
   log("DEBUG: splitBTreeNode: splitcnt = %d\n", splitcnt)


   var #{
     ret              = BT_SUCCESS
     leftList         : ref ListNode
     leftTail         : ref ListNode
     rightList        : ref ListNode
     middleNode       : ref ListNode #This is named as Node because it will always have one node 
     parentMiddleNode : ref ListNode #Parent of middleNode
     parentBTreeNode  : ref BTreeNode # This the BTreeNode where pMiddleNode resides
     currlevel        = getBTreeNodeLevel(currBTreeNode)
   #}
 
   middleNode  = getMiddle(getBTreeNodeKeyList(currBTreeNode))
   leftList    = getBTreeNodeKeyList(currBTreeNode)
   rightList   = middleNode.next
   lefttail    = middleNode.prev

   parentMiddleNode  = getListNodeParent(middleNode)
   if (parentMiddleNode != nil):
     parentBTreeNode = getCurrentBTreeNode(parentMiddleNode)
   else:
     parentBTreeNode = nil
  
   if (getDebugLevel() == BT_DEBUG_LEVEL_D): #{
     log("DEBUG: MiddleNode Extracted [%d]\n", middleNode.key )
     log("DEBUG: current[%d][%s] = %s, Type %d\n", 
     getBTreeNodeLevel(currBTreeNode), getAddressHex(currBTreeNode), 
     getBTreeNodeStr(currBTreeNode), currBTreeNode.bt_type)

     log("DEBUG: parent of middle keynode %d is [%d][%s] = %s \n", middleNode.key, 
     getBTreeNodeLevel(parentBTreeNode), getAddressHex(parentBTreeNode),
     getBTreeNodeStr(parentBTreeNode))
   #}

   #Disconnect all the ties of middleNode fromt its previous and next nodes
   middleNode.prev.next = nil
   middleNode.prev = nil
   middleNode.next.prev = nil
   middleNode.next = nil

   #Now form the BTreeNodes from the corresponding middleNode, leftList and rightList
   #No need to form the BTreeNode from leftList because it is basically the current BTreeNode
   var newLeftBTreeNode = currBTreeNode
   newLeftBTreeNode.bt_listtail = leftTail


   var newRightBTreeNode = newBTreeNode(rightList)
   if (newRightBTreeNode == nil): #{
     return BT_FAILURE
   #}
   else:
     setBTreeNodeLevel(newRightBTreeNode, getBTreeNodeLevel(currBTreeNode))
     setBTreeNodeType(newRightBTreeNode, getBTreeNodeType(currBTreeNode))

   if (parentBTreeNode == nil):#{
     var newRootBTreeNode = newBTreeNode(middleNode)
     if (newRootBTreeNode == nil): #{
       return BT_FAILURE
     #}

     var oldright = getBTreeNodeRight(middleNode)
     if (oldright != nil):
       setBTreeNodeLeft(newRightBTreeNode, oldright)

     setBTreeNodeLeft(middleNode,  newLeftBTreeNode)
     setBTreeNodeRight(middleNode, newRightBTreeNode)

     newRootBTreeNode.bt_numkeys = 1

     setBTreeNodeLevel(newRightBTreeNode, currlevel)
     setBTreeNodeLevel(newRootBTreeNode, currlevel + 1)
    
     setBTreeNodeType(newRootBTreeNode, BT_ROOT)
     if (currlevel == 0):
       setBTreeNodeType(newLeftBTreeNode,  BT_LEAF)
       setBTreeNodeType(newRightBTreeNode, BT_LEAF)
     else:
       setBTreeNodeType(newLeftBTreeNode,  BT_NODE)
       setBTreeNodeType(newRightBTreeNode, BT_NODE)

     setCurrentBTreeNode(newRootBTreeNode)
     setCurrentBTreeNode(newLeftBTreeNode)
     setCurrentBTreeNode(newRightBTreeNode)

     log("DEBUG: Key[%d] is now promoted to ROOT at level [%d]\n",

     getKey(newRootBtreeNode), getBTreeNodeLevel(newRootBTreeNode))

     log("Left  BTreeNode %s at level %d with type %d\n",
        getBTreeNodeStr(newLeftBTreeNode),
        newLeftBTreeNode.bt_level, newLeftBTreeNode.bt_type)
     log("Right BTreeNode %s at level %d with type %d\n",
        getBTreeNodeStr(newRightBTreeNode),
        newRightBTreeNode.bt_level, newRightBTreeNode.bt_type)
     
     setRoot(newRootBTreeNode)
     return BT_SUCCESS
   #}
   log("DEBUG: BEFORE: KeyNode[%d] is being promoted to parent %s of type %d\n", 
       getKey(middleNode), getBTreeNodeStr(parentBTreeNode), parentBTreeNode.bt_type )

   insertKeyNode(parentBTreeNode, middleNode, newLeftBTreeNode, newRightBTreeNode) 
   log("DEBUG: AFTER : KeyNode[%d] is being promoted to parent %s of type %d\n", 
       getKey(middleNode), getBTreeNodeStr(parentBTreeNode), parentBTreeNode.bt_type )

   if (parentBTreeNode.bt_numkeys > BT_MAXKEYS):
     ret = splitBTreeNode(parentBTreeNode) 
#} End of function splitBTreeNode

proc insertBTree*(root: var ref BTreeNode, key: int, value: pointer = nil): int =
#{
   var ret:int = BT_SUCCESS
   inputdata.add(key)
   var targetLeafBTreeNode = findLeafBTreeNode(root, key)
   if (targetLeafBTreeNode == nil): #{
     return insertKey(root, key, value)
   #}
   else: #{

     ret = insertKey(targetLeafBTreeNode, key)
     if (ret != 0):
       log("ERROR: Unable to insert key[%d]\n", key)
       return ret

     if (targetLeafBTreeNode.bt_numkeys > BT_MAXKEYS): #{
       ret = splitBTreeNode(targetLeafBTreeNode)
     #}
   #}
   return ret
#}

proc insertBTree*(key: int): int =
#{
   var root = getRoot()
   return insertBTree(root, key)
#}

proc insertBTree*(key: int, value: pointer): int =
#{
   var root = getRoot()
   return insertBTree(root, key, value)
#}

proc insertBTree*(keyval: ref KeyValue): int =
#{
   return insertBTree(keyval.key, keyval.value)
#}

proc createBTree*(keys: seq[int]):ref BTreeNode =
#{
   var root: ref BTreeNode

   if (getRoot() == nil): #{
     root = newBTreeNode()
     if (root != nil):
       setRoot(root)
     else:
       return nil
   #}
      
   for key in keys: #{
     root = getRoot()
     var ret = insertBTree(root, key)
     if (ret != BT_SUCCESS):
       log("ERROR: Insertion failure for key [%d]\n", key)
       return nil
     root = getRoot()
   #}

   return root
#}

proc initBTree*(order: int = BT_DEFAULT_ORDER,
                  logfile: string = BT_DEFAULT_LOG_FILE,
                  ): ref BTreeNode =
#{
    BT_ORDER   = order
    BT_DEGREE  = BT_ORDER
    var v = BT_ORDER/2
    var bBT_MAXKEYS = BT_ORDER - 1
    var bBT_MINKEYS = ceil(v)  - 1
    var bBT_MAXCHLD = BT_ORDER
    var bBT_MINCHLD = ceil(v)

    BT_MAXKEYS = bBT_MAXKEYS
    BT_MINKEYS = bBT_MINKEYS.int
    BT_MAXCHLD = bBT_MAXCHLD
    BT_MINCHLD = bBT_MINCHLD.int

    log("BT_ORDER       = %d\n", BT_ORDER)
    log("BT_MAXKEYS     = %d\n", BT_MAXKEYS)
    log("BT_MINKEYS     = %d\n", BT_MINKEYS)
    log("BT_MAXCHILD    = %d\n", BT_MAXCHLD)
    log("BT_MINCHILD    = %d\n", BT_MINCHLD)
    log("BT_MAXLEVEL    = %d\n", BT_MAXLEVEL)
    log("BT_LOG_FILE    = %s\n", BT_LOG_FILE)
    log("BT_DEBUG_LEVEL = %d\n", btdebug)



    BT_LOG_FILE = logfile

    #openLogger(BT_LOG_FILE)
    var root: ref BTreeNode
    if (getRoot() == nil): #{
      root = newBTreeNode()
      if (root != nil):
        setRoot(root)
      else:
        return nil
    #}
    return root
#}

proc destroyBTree*(): void =
#{
   btroot = nil
   #btarray.delete(low(btarray)..high(btarray))
   var m = len(btarray)
   m = m - 1
   #delete(btarray,0,n)
   delete(btarray,m)
   var n = len(btlist)
   n = n - 1
   delete(btlist, n)
   #btlist.delete(low(btlist)..high(btlist))
   BT_MAXLEVEL = 0
#}
