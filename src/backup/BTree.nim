#################################################
# IMPLEMENTATION OF BTREE IN NIM LANGUAGE
#################################################
#import std/math
#import std/os

#################################################
# BTree and its associated data structures and
# variables are defined in this header module
#################################################
import BTreeHeader

var btroot:ref BTreeNode = nil

#################################################
# Function   : inorder()
# Description: Traverse the BTree in inorder mode
#################################################
proc getInorder(root: ref BTreeNode): void =
#{
  if (root == nil):
    return
    
  var keylist: ref ListNode = root.bt_listhead
  if (keylist == nil):
    echo "keylist is null"
  while true:
    var left  = cast[ref BTreeNode](keylist.lesser)
    var right = cast[ref BTreeNode](keylist.greater)

    getInorder(left)
    stdout.write(keylist.key," ")
    getInorder(right)

    keylist = keylist.next
    if (keylist == nil):
      break
#}

proc inorder(root: ref BTreeNode): void =
#{
    stdout.write("Inorder string:[ ")
    getInorder(root)
    stdout.write("]\n")
#}

#################################################
# Function   : insertList()
# Description: To insert the key in the list
#              in sorted order
#################################################
proc insertList(head: var ref ListNode, tail: var ref ListNode, key: int): ref ListNode =
#{
   var found:bool = false
   if (head == nil):
     var obj = newListNode(key)
     head = obj
     tail = obj
     return head
   
   if (key < head.key):
     var obj = newListNode(key)
     obj.next = head
     return obj

   if (key > tail.key): #{
     var obj = newListNode(key)
     tail.next = obj
     tail = tail.next
     return head
   #}

   var prev = head
   var node = head.next
   while(node.next != nil): #{
     if (key < node.key): #{
       var obj = newListNode(key)
       obj.next = head
       prev.next = obj
       found = true
       break
     #}
   #}

     prev = node
     node = node.next

   if (found == false):
     var obj = newListNode(key)
     node.next = obj

   return head
#}

#################################################
# Function   : createBTree()
# Description: To insert the key in the list
#              in sorted order
#################################################
proc createBTree(root: var ref BTreeNode, parent: var ref BTreeNode, key: int):ref BTreeNode =
#{
   if (root == nil): #{
     root = newBTreeNode(key)
     root.bt_knum = 1
     if (parent == nil):
       root.bt_type = BT_ROOT
     else:
       root.bt_parent  = parent
       parent.bt_cnum  = parent.bt_cnum + 1
       if (parent.bt_cnum > BT_MAXCHLD):
         echo "Time to split the parent node [",parent.bt_kstart,"] for child key[",key,"]"
       #stdout.write(str)
     
       if (parent != btroot): #{
         parent.bt_type = BT_NODE
       #}
     #}

     return root
   #}

   if root.bt_knum < BT_MAXKEYS: #{
     echo "Inserted ListNode [" & $key & "]"
     # Insert the node here
     root.bt_listhead = insertList(root.bt_listhead, root.bt_listtail, key)
     root.bt_kstart = root.bt_listhead.key
     root.bt_kend   = root.bt_listtail.key
     root.bt_knum = root.bt_knum + 1
   #}
   else: #{
     if (key < root.bt_kstart): #{
       echo "\nTime to create BTreeNode[",key,"] in left side of ", root.bt_listhead.key
       var left: ref BTreeNode = cast[ref BTreeNode](root.bt_listhead.lesser)
       if (left == nil): #{
         left = createBTree(left, root, key)
         left.bt_parentKey          = root.bt_listhead.key
         left.bt_parentKeyNode      = root.bt_listhead
         root.bt_listhead.lesser = cast[pointer](left)
         var str = "Created BTreeNode [" & $left.bt_kstart & "]=>"
         str.add("Parent:[" & $left.bt_parentKey & "] ")
         str.add("CNUM = [" & $root.bt_cnum & "]\n")
         stdout.write(str)
       else:
         left = createBTree(left, root, key)
       #}
     #}
     elif (key > root.bt_kend): #{
       echo "\nTime to create BTreeNode[",key,"] in right side of ",root.bt_listtail.key
       var right: ref BTreeNode = cast[ref BTreeNode](root.bt_listtail.greater)
       if (right == nil): #{
         right = createBTree(right, root, key)
         right.bt_parentKey          = root.bt_listtail.key
         right.bt_parentKeyNode      = root.bt_listtail
         root.bt_listtail.greater = cast[pointer](right)
         var str = "Created BTreeNode [" & $right.bt_kstart & "]=>"
         str.add("Parent:[" & $right.bt_parentKey & "] ")
         str.add("CNUM = [" & $root.bt_cnum & "]\n")
         stdout.write(str)
       else:
         right = createBTree(right, root, key)
       #}
     #}
     elif (key > root.bt_kstart and key < root.bt_kend): #{
       #echo "key ", key," lies in between [",root.bt_kstart,"] and [",root.bt_kend ,"]"
       var head = root.bt_listhead
       
       while((head != nil) and (head.next != nil)): #{
         if (key > head.key and key < head.next.key): #{
           echo "\nBTreeNode[",key,"] needs to be created in between [",head.key,"] and [",head.next.key,"]"
           var right: ref BTreeNode = cast[ref BTreeNode](head.greater)
           if (right == nil):
             right = createBTree(right, root, key)
             right.bt_parentKey     = head.key
             right.bt_parentKeyNode = head
             head.greater = cast[pointer](right)
             var str = "Created BTreeNode [" & $right.bt_kstart & "]=>"
             str.add("Parent:[" & $right.bt_parentKey & "] ")
             str.add("CNUM = [" & $root.bt_cnum & "]\n")
             stdout.write(str)
           else:
             right = createBTree(right, root, key)

           break

         head = head.next
         #}
       #}
     #}  
   #} //End of top if block where BT_DEGREE is checked
   return root
#}


#################################################
# Function   : main()
# Description: Process life begins from here 
#             
#################################################
proc main(): void =
#{
   var datalist = @[50, 10, 64, 9, 70, 55, 12, 100, 42]

   printInput(datalist)
   for i in datalist: #{
     var parent: ref BTreeNode = nil
     btroot = createBTree(btroot, parent, i)
   #}

   inorder(btroot)
   printInput(datalist)
#}

main()
