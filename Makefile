NIM_OUTDIR  = objects_compiled
NIM_BINDIR  = bin
NIM_SRCDIR  = src/
BTREE_SRCDIR = $(NIM_SRCDIR)BTree/

NIM_FLAGS = --threads:on --checks:on --outdir:$(NIM_BINDIR)
NIM_DEBUG_FLAGS = --debuginfo:on --stackTrace:on  --lineTrace:on --debugger:native --hints:on

rbm:
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(NIM_SRCDIR)ringbuffer_module.nim
rb:rbm
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(NIM_SRCDIR)ringbuffer.nim
r:rb

l:
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(NIM_SRCDIR)linkedlist.nim
bst:
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(NIM_SRCDIR)bst.nim
b:bst

q:
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(NIM_SRCDIR)queue.nim
s:
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(NIM_SRCDIR)server.nim
c:
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(NIM_SRCDIR)client.nim

bt:
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)BTreeHeader.nim
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)BTreeTraversal.nim
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)BTreeSearch.nim
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)BTreeCreate.nim
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)BTreeMain.nim
cs:c s

rs: rbm s

#all:bst

clean:

lsbin:
	ls -l bin
ls:
	ls -l src

server:rs

all: bt

g:
	gdb -eval-command "source {path-to-nim}\tools\nim-gdb.py" test

vim:
	vim $(NIM_SRCDIR)BTree.nim
vi:vim
v:vi
