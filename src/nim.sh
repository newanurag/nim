NIM_PWD=/home/averma/lab/nim/src/BTree
BT_FILES="BTreeHeader.nim BTreeUtils.nim BTreePrints.nim BTreeCreate.nim "
BT_FILES="$BT_FILES BTreeDeleteLeaf.nim BTreeMain.nim BTreeCli.nim BTreeSearch.nim BTreeTraversal.nim"
#BT_FILES="$BT_FILES BTreeDelete.nim BTreeMain.nim BTreeCli.nim BTreeSearch.nim BTreeTraversal.nim"

for f in $BT_FILES
do
    bn=`basename -s.nim $f`
    title=`echo $bn | awk -F "BTree" '{print $2}'`
    echo "TAB Title=$title for Opened file $f"
	gnome-terminal --tab --title="$title" --working-directory=${NIM_PWD} -- vim $f
done
#gnome-terminal --tab --title="make" --working-directory=${NIM_PWD} --wait -- vim Makefile

