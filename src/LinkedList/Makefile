NIM_OUTDIR  = objects_compiled
NIM_BINDIR  = /home/averma/nim/bin
NIM_SRCDIR  = /home/averma/nim/src
LINKEDLIST_SRCDIR = $(NIM_SRCDIR)/LinkedList/
 
NIM_FLAGS = --threads:on --checks:on --outdir:$(NIM_BINDIR)
NIM_DEBUG_FLAGS = --debuginfo:on --stackTrace:on  --lineTrace:on --debugger:native --hints:off --warning:UnusedImport:off --warning:CStringConv:off --warning:UnreachableCode:off

$(NIM_BINDIR)/LinkedList:$(LINKEDLIST_SRCDIR)LinkedList.nim
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(LINKEDLIST_SRCDIR)LinkedList.nim

ll:$(NIM_BINDIR)/LinkedList
	

clean:
	rm -rf $(NIM_BINDIR)/LinkedList*

loc:
	wc *.nim |grep total

all: ll
ls:
	ls -l $(NIM_BINDIR)/LinkedList*

ca: clean all
