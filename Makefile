NIM_OUTDIR  = objects_compiled
NIM_BINDIR  = bin
NIM_SRCDIR  = src/
RB_SRCDIR = $(NIM_SRCDIR)RingBuffer/
BTREE_SRCDIR = $(NIM_SRCDIR)BTree/
BST_SRCDIR = $(NIM_SRCDIR)BST/
LINKEDLIST_SRCDIR = $(NIM_SRCDIR)LinkedList/

NIM_FLAGS = --threads:on --checks:on --outdir:$(NIM_BINDIR)
NIM_DEBUG_FLAGS = --debuginfo:on --stackTrace:on  --lineTrace:on --debugger:native --hints:on


rb:
	make -f $(RB_SRCDIR)/Makefile

ll:
	make -f $(LINKEDLIST_SRCDIR)/Makefile

bst:
	make -f $(BST_SRCDIR)/Makefile

btree:
	make -f $(BTREE_SRCDIR)/Makefile
	

all:rb ll bst btree


clean:
	make -f $(RB_SRCDIR)/Makefile clean
	make -f $(LINKEDLIST_SRCDIR)/Makefile clean
	make -f $(BST_SRCDIR)/Makefile clean
	make -f $(BTREE_SRCDIR)/Makefile clean
