NIM_OUTDIR  = objects_compiled
NIM_BINDIR  = /home/averma/nim/bin/
NIM_SRCDIR  = /home/averma/nim/src/
BTREE_SRCDIR = $(NIM_SRCDIR)BTree/
 
NIM_FLAGS = --threads:on --checks:on --outdir:$(NIM_BINDIR)
NIM_DEBUG_FLAGS = --debuginfo:on --stackTrace:on  --lineTrace:on --debugger:native --hints:off --warning:UnusedImport:off --warning:CStringConv:off --warning:UnreachableCode:off -d:nimCallDepthLimit=10000


all: $(NIM_BINDIR)/BTreeMain
$(NIM_BINDIR)/CommonImports:$(BTREE_SRCDIR)CommonImports.nim
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)CommonImports.nim

$(NIM_BINDIR)/CommonLogger:$(BTREE_SRCDIR)CommonLogger.nim $(NIM_BINDIR)/CommonImports
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)CommonLogger.nim

$(NIM_BINDIR)/CommonUtils:$(BTREE_SRCDIR)CommonUtils.nim $(NIM_BINDIR)/CommonLogger
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)CommonUtils.nim

$(NIM_BINDIR)/BTreeHead:$(BTREE_SRCDIR)BTreeHeader.nim $(NIM_BINDIR)/CommonLogger $(NIM_BINDIR)/CommonUtils
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)BTreeHeader.nim

$(NIM_BINDIR)/BTreeUtils:$(BTREE_SRCDIR)BTreeUtils.nim $(NIM_BINDIR)/BTreeHead
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)BTreeUtils.nim

$(NIM_BINDIR)/BTreePrints:$(BTREE_SRCDIR)BTreeHeader.nim
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)BTreePrints.nim

$(NIM_BINDIR)/BTreeTraversal:$(BTREE_SRCDIR)BTreeTraversal.nim $(NIM_BINDIR)/BTreeHead
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)BTreeTraversal.nim

$(NIM_BINDIR)/BTreeSearch:$(BTREE_SRCDIR)BTreeSearch.nim $(NIM_BINDIR)/BTreeHead
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)BTreeSearch.nim

$(NIM_BINDIR)/BTreeCreate:$(BTREE_SRCDIR)BTreeCreate.nim $(NIM_BINDIR)/BTreeHead
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)BTreeCreate.nim

$(NIM_BINDIR)/BTreeDeleteLeaf:$(BTREE_SRCDIR)BTreeDeleteLeaf.nim $(NIM_BINDIR)/BTreeHead
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)BTreeDeleteLeaf.nim

$(NIM_BINDIR)/BTreeDelete:$(BTREE_SRCDIR)BTreeDelete.nim $(NIM_BINDIR)/BTreeHead $(NIM_BINDIR)/BTreeDeleteLeaf
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)BTreeDelete.nim

$(NIM_BINDIR)/BTreeCli:$(BTREE_SRCDIR)BTreeCli.nim $(NIM_BINDIR)/BTreeHead
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)BTreeCreate.nim

$(NIM_BINDIR)/BTreeMain:$(BTREE_SRCDIR)BTreeMain.nim $(NIM_BINDIR)/BTreeDelete $(NIM_BINDIR)/BTreeCli $(NIM_BINDIR)/BTreeCreate $(NIM_BINDIR)/BTreeSearch $(NIM_BINDIR)/BTreeTraversal $(NIM_BINDIR)/BTreeUtils $(NIM_BINDIR)/BTreeHead
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c $(BTREE_SRCDIR)BTreeMain.nim


r:
	$(NIM_BINDIR)/BTreeMain

cli:$(NIM_BINDIR)/BTreeMain
	$(NIM_BINDIR)/BTreeMain cli

rc:cli

gcli:
	gdb $(NIM_BINDIR)/BTreeMain cli
g:
	gdb $(NIM_BINDIR)/BTreeMain

loc:
	wc *.nim |grep total

loc2:
	wc BTreeHeader.nim BTreeCreate.nim BTreeDelete.nim BTreeSearch.nim BTreeTraversal.nim
ls:
	ls -l $(NIM_BINDIR)/BTree*

clean:
	rm -rf $(NIM_BINDIR)/BTree*

ca: clean all
b:
	./backup.sh
