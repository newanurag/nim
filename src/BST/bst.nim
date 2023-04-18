##################################
# TreeNode Object
##################################
type
  TreeNode = object
    data:   int
    left:  ref TreeNode
    right: ref TreeNode


##################################
# Tree Object with root and its 
# functions
##################################
type
  Tree = object
    root: ref TreeNode
    createTree:proc(root: ref TreeNode, datalist: seq[int]):ref TreeNode
    insert:proc(root:ref TreeNode, data: int):void
    inorder:proc(root:ref TreeNode):void
    preorder:proc(root:ref TreeNode):void

var TreeObj = Tree(root: nil)
var found:bool = false

proc insert(root:ref TreeNode, data: int):ref TreeNode =
#{
  if (root == nil):
    #[
    #var node:ref TreeNode
    #new(node)
    #var node = (ref TreeNode)()
    node.data  = data
    node.left  = nil
    node.right = nil
    return node
    ]#

    return (ref TreeNode)(data: data, left: nil, right: nil)
    #return var node = (ref TreeNode)(data: data, left: nil, right: nil)
    #return node

  if (data < root.data):
    root.left = insert(root.left, data)
  else:
    root.right = insert(root.right, data)

  return root
#}

proc inorder(root:ref TreeNode):void =
#{
  if (root == nil):
    return;
  inorder(root.left)
  stdout.write(root.data);
  stdout.write(" ");
  inorder(root.right)
#}

proc inorder():void =
#{
  echo "Printing Inorder Traversal"
  inorder(TreeObj.root);
  echo ""
#}

proc preorder(root: ref TreeNode):void =
#{
  if (root == nil):
    return
  
  stdout.write(root.data)
  stdout.write(" ")
  preorder(root.left)
  preorder(root.right)
#}

proc preorder():void =
#{
  echo "Printing Preorder Traversal"
  preorder(TreeObj.root)
  echo ""
#}

proc search(root:ref TreeNode, data: int):void =
#{
   if (root == nil):
     return

   if (root.data == data):
     found = true
   elif (data < root.data):
     search(root.left, data)
   else:
     search(root.right, data)
#}

proc searchTreeNode(root: ref TreeNode, data: int):ref TreeNode =
#{
   if (root == nil):
     return nil

   if (data == root.data):
     return root
   elif (data < root.data):
     return searchTreeNode(root.left, data)
   else:
     return searchTreeNode(root.right, data)

#}

proc findInorderSuccessor(root: ref TreeNode): ref TreeNode =
#{
  var node = root
  while (node.left != nil):
    node = node.left

  stdout.write("Inorder Successor is :")
  stdout.write(node.data)
  echo ""
  return node

#}

proc delete(root: ref TreeNode, data: int):ref TreeNode =
#{
   if (root == nil):
     return nil

   if (data < root.data):
     root.left = delete(root.left, data)
   elif (data > root.data):
     root.right = delete(root.right, data)
   else:
     if (root.left == nil and root.right == nil):
       return nil

     if (root.left == nil):
       return root.right

     if (root.right == nil):
       return root.left

     var node = findInorderSuccessor(root.right)
     root.data = node.data
     root.right = delete(TreeObj.root.right, node.data) 
     return root
#}

proc delete(data: int):void =
#{
   echo "Node To Be Deleted [",data,"]"
   var node = delete(TreeObj.root, data)
#}

 
proc createTree():void =
#{
  var datalist:seq[int]
  datalist = @[50,10,56,32,67,12,34]

  stdout.write("Input Data [ ")
  var root:ref TreeNode
  for data in datalist:
    stdout.write(data)
    stdout.write(" ")
    root = insert(root, data)

  stdout.write("]")
  echo ""
  TreeObj.root = root
#}

proc traversal():void =
#{
  inorder()
  preorder()
#}

proc search():void =
#{
   var key = 12
   search(TreeObj.root, key)
   if (found == true):
     echo "Data [",key,"] Found"
   else:
     echo "Data [",key,"] NOT Found"

   var node = searchTreeNode(TreeObj.root, key)
   if (node == nil):
     echo "Node for Data [",key,"] NOT Found"
   else:
     echo "Node for Data [",key,"] Found"

#}

proc main():void =
  echo "Main Function: Binary Tree Implementation"
  createTree()
  traversal()
  search()
  delete(10)
  inorder()
main()
