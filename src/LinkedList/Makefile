NIM_OUTDIR  = objects_compiled
NIM_BINDIR  = /home/averma/nim/bin/
NIM_SRCDIR  = /home/averma/nim/src/
BTREE_SRCDIR = $(NIM_SRCDIR)LinkedList/
 
NIM_FLAGS = --threads:on --checks:on --outdir:$(NIM_BINDIR)
NIM_DEBUG_FLAGS = --debuginfo:on --stackTrace:on  --lineTrace:on --debugger:native --hints:off --warning:UnusedImport:off --warning:CStringConv:off --warning:UnreachableCode:off -d:nimCallDepthLimit=10000

bt:
	(cd ../; make bt)

b:
	./backup.sh

$(NIM_BINDIR)/LinkedList:$(BTREE_SRCDIR)LinkedList.nim
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(BTREE_SRCDIR)LinkedList.nim

ll:$(NIM_BINDIR)/LinkedList
	

clean:

loc:
	wc *.nim |grep total

all: ll
