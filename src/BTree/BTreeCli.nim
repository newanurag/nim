#################################################
# BTreeMain.nim
#################################################

import os
import std/math
import strutils
import CommonImports
import CommonLogger
import CommonUtils
import BTreeHeader
import BTreeUtils
import BTreeTraversal
import BTreeSearch
import BTreeCreate
import BTreePrints
import BTreeDelete

var argv*:seq[string]
var argc*:int

var datalist*: seq[int]
var inputstr*:string

var header* = "Input [ "
var footer* = "]"
var prompt* = "[BTree]@NIM > "

proc processInorder(cmd: string): int

proc processDraw*(cmd: string): int =
#{
  log("Max Levels Observed %d\n\n", BT_MAXLEVEL)
  var cmd_draw = cmd.split(" ")
  for idx, cmnd in cmd_draw:
    if (idx > 0):
      var key = getint(cmnd)
      drawBTreeNode(21, key)
      log("\n\n")
      #discard processInorder(cmd)
      return BT_SUCCESS

  var i = BT_MAXLEVEL
  while (true):
    log("LEVEL[%d]=> ", i)
    printLevel(i)
    log("\n")

    i = i - 1
    if (i < 0):
      break

  #discard processInorder(cmd)
  return BT_SUCCESS
#}

proc processCreate(cmd: string): int =
#{
    destroyBTree()
    discard initBTree(BT_ORDER)
    var cmd_find = cmd.split(" ")
    for idx, cmnd in cmd_find:
      if (idx > 0):
        var key = getint(cmnd)
        datalist.add(key)
        discard insertBTree(key)
    return BT_SUCCESS
#}

proc processFind(cmd: string): int =
#{
    var cmd_find = cmd.split(" ")
    for idx, cmnd in cmd_find:
      if (idx > 0):
        var key = getint(cmnd)
        datalist.add(key)
        var obj = findLeafBTreeNode(key)
        log("Find Target BTreeNode %s\n", getBTreeNodeStr(obj))
    return BT_SUCCESS
#}

proc processInsert(cmd: string): int =
#{
    var cmd_insert = cmd.split(" ")
    for idx, cmnd in cmd_insert:
      if (idx > 0):
        var key = getint(cmnd)
        datalist.add(key)
        discard insertBTree(key)
    return BT_SUCCESS
#}

proc processPrint(cmd: string): int =
#{
    var cmd_print = cmd.split(" ")
    for idx, cmnd in cmd_print:
      if (idx > 0):
        var key = getint(cmnd)
        printListNode(getKeyListNode(key),0,0, true)
        
    return BT_SUCCESS
#}

proc processDelete(cmd: string): int =
#{
    var cmd_delete = cmd.split(" ")
    for idx, cmnd in cmd_delete:
      if (idx > 0):
        var key = getint(cmnd)
        log("Deleting Key[%d]\n", key)
        datalist.add(key)
        discard deleteBTree(key)
    return BT_SUCCESS
#}

proc processSearch(cmd: string): int =
#{
    var cmd_search = cmd.split(" ")
    for idx, cmnd in cmd_search:
      if (idx > 0):
        var key = getint(cmnd)
        datalist.add(key)
        var sr =  searchBTree(key)
        if (sr == nil):
          log("Sorry: Key[%d] does not exist in BTree\n", key)
        else:
          var btn = sr.btreenode
          var ln  = sr.listnode
          var leftbtn   = getBTreeNodeLeft(ln)
          var rightbtn  = getBTreeNodeRight(ln)
          if (ln.parentListNode != nil):
            log("Key[%d] found at Level[%d] in BTreeNode %s\n", 
            key, getBTreeNodeLevel(btn), getBTreeNodeStr(btn))
            var parentbtn = cast[ref BTreeNode] (ln.parentListNode.currentBTreeNode)
            log("Current Key       %d\n", key)
            log("Current BTreeNode %s\n", getBTreeNodeStr(btn))
            log("Parent  Key       %d\n", ln.parentListNode.key)
            log("Parent  BTreeNode %s\n", getBTreeNodeStr(parentbtn))
            log("Left    BTreeNode %s\n", getBTreeNodeStr(leftbtn))
            log("Right   BTreeNode %s\n", getBTreeNodeStr(rightbtn))
          else:
            log("Key[%d] found at Level[%d] in BTreeNode %s. Its Parent is NULL\n", 
            key, getBTreeNodeLevel(btn), getBTreeNodeStr(btn))
            log("Current Key       %d\n", key)
            log("Current BTreeNode %s\n", getBTreeNodeStr(btn))
            log("Parent  Key       [ NULL ]\n")
            log("Parent  BTreeNode [ NULL ]\n")
            log("Left    BTreeNode %s\n", getBTreeNodeStr(leftbtn))
            log("Right   BTreeNode %s\n", getBTreeNodeStr(rightbtn))
          
          #discard getSuccessor(key)
          #discard getPredecessor(key)
    return BT_SUCCESS
#}

proc processInorder(cmd: string): int =
#{
   if (btroot == nil):
     log("BTree is not formed yet. Enter any number to form a BTree\n")
     return
   log("Input   string  :[ " )
   log(inputstr)
   log(footer)
   log(" Input   Count : %d", len(datalist))
   echo ""
   inorderBTree(btroot)
   return BT_SUCCESS
#}

proc processShellCmd(cmd: string): int =
#{
   discard run(cmd)
   return BT_SUCCESS
#}

proc processExit(cmd: string): int =
#{ 
   if (getRoot() != nil and getBTreeNodeNumKeys(getRoot()) > 0 ):
     printBTreeArrayF()
     printBTreeListF()
     printInputF(datalist)
     inorderBTree(btroot)
     logf("Total BTreeNodes: %d\n", getbsize())
     logf("Total ListNodes : %d\n", len(btlist))
   closeLogger()
   echo ""
   discard processShellCmd("make cli")
   quit(0)
   return BT_SUCCESS
#}

proc processDebug*(cmd: string): int =
#{
   setDebugLevel(BT_DEBUG_LEVEL_D)
   log("Debug messages enabled\n")
   return BT_SUCCESS
#}

proc processDDebug(cmd: string): int =
#{
   setDebugLevel(BT_DEBUG_LEVEL_E)
   log("Debug messages disabled\n")
   return BT_SUCCESS
#}

proc processInput(cmd: string): int =
#{
   log("Input   string  :[ " )
   log(inputstr)
   log(footer)
   log(" Input   Count : %d", len(datalist))
   echo ""
   return BT_SUCCESS
#}

proc processRoot(cmd: string): int =
#{
   if (btroot != nil):
     var str = getBTreeNodeStr(btroot)
     log("ROOT KeyList %s\n", str)
   else:
     log("BTree is not formed yet. Enter any number to form a BTree\n")
   return BT_SUCCESS
#}

proc processStats(cmd: string): int =
#{
   if (btroot == nil):
     log("BTree is not formed yet. Enter any number to form a BTree\n")
     return
   printBTreeList()
   return BT_SUCCESS
#}

proc processInfo(cmd: string): int =
#{
   var v = BT_ORDER/2
   var bBT_MAXKEYS = BT_ORDER - 1
   var bBT_MINKEYS = ceil(v)  - 1
   var bBT_MAXCHLD = BT_ORDER 
   var bBT_MINCHLD = ceil(v)
   if (btroot == nil):
     log("BTree is not formed yet\n")
   log("BT_ORDER       = %d\n", BT_ORDER)
   log("BT_MAXKEYS     = %d\n", bBT_MAXKEYS)
   log("BT_MINKEYS     = %0.0f\n", bBT_MINKEYS)
   log("BT_MAXCHILD    = %d\n", bBT_MAXCHLD)
   log("BT_MINCHILD    = %0.0f\n", BT_MINCHLD)
   log("BT_MAXLEVEL    = %d\n", BT_MAXLEVEL)
   log("BT_LOG_FILE    = %s\n", BT_LOG_FILE)
   log("BT_DEBUG_LEVEL = %d\n", btdebug)

   return BT_SUCCESS
#}
proc processOrder(cmd: string): int =
#{
    var val: int
    var cmd_search = cmd.split(" ")
    for idx, cmnd in cmd_search:
      if (idx > 0):
        val = getint(cmnd)
   
    if (val < 3 or val > 512):
      log("Valid BTree order are from 3 to 512\n")
    else:
      BT_ORDER = val
      log("Order of BTree changed to %d. New Attributes of BTree are:\n", BT_ORDER)
      discard processInfo(cmd)
      destroyBTree()
      inputstr = ""
      discard initBTree(val)
#}

proc processCommand(cmd: string): int =
#{
   if (cmd == "exit" or cmd == "quit" or cmd == "q" or cmd == "e" ):
     return processExit(cmd)

   if (cmd == "date" or cmd == "ls" or cmd == "pwd"):
     return processShellCmd(cmd)

   if (cmd == "setd"):
     return processDebug(cmd)


   if (cmd == "info"):
     return processInfo(cmd)

   if (cmd == "reset"):
     return processDDebug(cmd)

   if (cmd == "inorder" or cmd == "in"):
     return processInorder(cmd)

   if (cmd == "inp" or cmd == "input"):
     return processInput(cmd)

   if (cmd == "root" or cmd == "r"):
     return processRoot(cmd)

   if (cmd == "s" or cmd == "stats"):
     return processStats(cmd)

   if ((cmd.startsWith("create") == true) or (cmd.startsWith("c") == true) ):
     return processCreate(cmd)

   if ((cmd.startsWith("find") == true) or (cmd.startsWith("f") == true) ):
     return processFind(cmd)

   if ((cmd.startsWith("delete") == true) or (cmd.startsWith("del") == true) ):
     return processDelete(cmd)

   if ((cmd.startsWith("draw") == true) or (cmd.startsWith("d") == true) ):
     return processDraw(cmd)

   if ((cmd.startsWith("print") == true) or (cmd.startsWith("p") == true) ):
     return processPrint(cmd)

   if ((cmd.startsWith("insert") == true) or (cmd.startsWith("i") == true) ):
     return processInsert(cmd)

   if ((cmd.startsWith("search") == true) or (cmd.startsWith("s") == true) ):
     return processSearch(cmd)


   if (cmd.startsWith("setm") == true ):
     return processOrder(cmd)

   var cmdlist = cmd.split(" ")
   for cmnd in cmdlist:
     var key = getint(cmnd)
     if (key == 0):
       return -1
     #echo cmnd
     datalist.add(key)
     inputstr.add($key & " ")
     log(header)
     log(inputstr)
     log(footer)
     echo ""

     discard insertBTree(key)
#}

proc rcliInput*(cmd: string): string =
#{
    discard processCommand(cmd)
#}

proc cliInput*(): string =
#{
   cls()
   log("Welcome to BTree Implementation in NIM Language\n")
   var cmd:string
   while (true):
     log(prompt)
     cmd = readLine(stdin);
     if (cmd != ""):
       discard processCommand(cmd)

   return inputstr
#}
