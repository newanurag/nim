NIM_OUTDIR  = objects_compiled
NIM_BINDIR  = /home/averma/nim/bin
NIM_SRCDIR  = /home/averma/nim/src
RB_SRCDIR =   $(NIM_SRCDIR)/RingBuffer
 
NIM_FLAGS = --threads:on --checks:on --outdir:$(NIM_BINDIR)
NIM_DEBUG_FLAGS = --debuginfo:on --stackTrace:on  --lineTrace:on --debugger:native --hints:off --warning:UnusedImport:off --warning:CStringConv:off --warning:UnreachableCode:off

$(NIM_BINDIR)/RingBufferCore:$(RB_SRCDIR)/RingBufferHeader.nim $(RB_SRCDIR)/RingBufferCore.nim
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(RB_SRCDIR)/RingBufferCore.nim

$(NIM_BINDIR)/RingBuffer:$(RB_SRCDIR)/RingBufferHeader.nim $(NIM_BINDIR)/RingBufferCore $(RB_SRCDIR)/RingBufferMain.nim
	nim  $(NIM_FLAGS) $(NIM_DEBUG_FLAGS) c -r $(RB_SRCDIR)/RingBufferMain.nim

rb:$(NIM_BINDIR)/RingBuffer
#rb:$(NIM_BINDIR)/RingBufferCore
	

clean:
	rm -rf $(NIM_BINDIR)/RingBuffer*

loc:
	wc *.nim |grep total

all: rb

ls:
	ls -l $(NIM_BINDIR)/RingBuffer*

ca:clean all

