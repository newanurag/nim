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

var inorderstr:string
var inordercnt:int
var levelstr:string
proc getInorder*(root: ref BTreeNode): void =
#{
  if (root == nil):
    return
    
  var node: ref ListNode = root.bt_listhead
  if (node == nil):
    printf("node is null\n")

  while true:
    var left  = getBTreeNodeLeft(node)
    var right = getBTreeNodeRight(node)

    getInorder(left)
    inorderstr.add("" & $node.key)
    inorderstr.add(" ")
    inordercnt = inordercnt + 1
    getInorder(right)

    node = node.next
    if (node == nil):
      break
#}

proc inorderBTree*(root: ref BTreeNode): void =
#{
    inorderstr = ""
    inordercnt = 0
    echo ""
    inorderstr.add("Inorder string  :[ ")
    getInorder(root)
    inorderstr.add("] Inorder Count : " & $inordercnt)
    log(inorderstr)
    logf(inorderstr)
    echo ""
#}


proc inorderBTreeStr*(root: ref BTreeNode): string =
#{
    inorderstr = ""
    inordercnt = 0
    inorderstr.add("[ ")
    getInorder(root)
    inorderstr.add("] Inorder Count : " & $inordercnt)
    return inorderstr
#}


proc getInorderBTreeStr*(root: ref BTreeNode): string =
#{
    return inorderBTreeStr(root)
#}

proc getLevelStr*(root: ref BTreeNode, level: int): void =
#{
    if (root == nil):
      return

    var keynode = getBTreeNodeKeyList(root)
   
    if (root.bt_level == level):
      levelstr.add("[ ")

    while(keynode != nil): #{
      var left = getBTreeNodeLeft(keynode)
      var right = getBTreeNoderight(keynode)
      #log("keynode %d\n", keynode.key)
      #log("left    %s\n", getBTreeNodeOnlyStr(left))
      #log("right   %s\n", getBTreeNodeOnlyStr(left))
      #btsleep(300)

      getLevelStr(left, level)

      if (root.bt_level == level):
        levelstr.add($keynode.key)
        levelstr.add(" ")
      
      getLevelStr(right, level)
     
      keynode = keynode.next
      if (keynode == nil and root.bt_level == level):
        levelstr.add("] ")
    #}
#}

proc printLevel*(level: int): void =
#{
    #levelstr = "[ "
    levelstr = ""
    getLevelStr(getRoot(), level)
    #levelstr.add("]")
    log("%s\n", levelstr)
#}
