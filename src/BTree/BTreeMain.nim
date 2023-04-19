#################################################
# BTreeMain.nim
#################################################

import os
import std/[asyncnet,asyncdispatch]
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
import BTreeCli
import BTreeDelete
import BTreeServer

#################################################
# Function   : main()
# Description: Process life begins from here 
#             
#################################################

proc main(): void =
#{
   var btorder = 5
   argv = os.commandLineParams()
   argc = len(argv)
   discard initBTree(btorder)
   discard processDebug("")

   var inp:seq[int]
   for key in countup(1, 32, 2):
     inputstr.add($key & " ")
     datalist.add(key)
     inp.add(key)
     discard insertBTree(key)
   #discard createBTree(inp)
     discard processDraw("")
     printListNode(getKeyListNode(key),0,0, true)

   for key in countup(2, 33, 2):
     let a = 5
     inputstr.add($key & " ")
     datalist.add(key)
     inp.add(key)
     discard insertBTree(key)
     discard processDraw("")
     printListNode(getKeyListNode(key),0,0, true)


   if (argc > 0 and argv[0] == "cli"):
     var s = cliInput()
     return

   if (argc > 0 and argv[0] == "rcli"):
     asyncCheck startBTreeServer(rcliInput)
     runForever()
     return
   #Below one is a working datalist
   #datalist = @[50, 10, 64, 9, 70, 100, 120, 68, 130, 69, 15, 25, 30, 35, 40]
   datalist = @[1, 2, 3, 4, 5 ,6 ,7, 8, 9, 10, 11, 12, 13]

   printInput(datalist)
   echo ""
   for key in datalist: #{
     discard insertBTree(key)
   #}

   printBTreeArrayF()
   printBTreeListF()
   printInputF(datalist)
   inorderBTree(btroot)
   log("Total BTreeNodes: %d\n", getbsize())
   log("Total ListNodes : %d\n", len(btlist))
#}

#openLogger(BT_LOG_FILE)
main()
#closeLogger()
