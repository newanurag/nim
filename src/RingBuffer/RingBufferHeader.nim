######################################################################
# Ring Buffer Module Implementation
######################################################################

import os
import std/terminal
import std/[asyncnet, asyncdispatch]

const RING_BUFFER_SIZE* = 3
var RB_SUCCESS* = 0
var RB_FAILURE* = -1
var RB_STATIC* = 1
var RB_DYNAMIC* = 2

type #{ A Ring Buffer Object. Exported to other modules
  RingBuffer* = object

    # Object Members
    rb_sbuffer*:  array[RING_BUFFER_SIZE, ref string]
    rb_dbuffer*:  seq[ref string]
    rb_size*:     int
    rb_readidx*: int
    rb_writeidx*:int
    rb_count*:    int
    rb_type*:     int 
    rb_debug*:   bool
    #rb_type = 1: Fixed  Size i.e. Static  and Array     based
    #rb_type = 2: Random Size i.e. Dynamic and Sequence  based

    #Mandatory Member Functions
    isEmpty*:            proc(obj: ref RingBuffer): bool
    isFull*:             proc(obj: ref RingBuffer): bool
    setBufferData*:      proc(obj: ref RingBuffer, data: ref string): int
    getBufferData*:      proc(obj: ref RingBuffer): ref string

    #Optional  Member Functions
    getBufferDataBack*:  proc(obj: ref RingBuffer): ref string
    getStatus*:          proc(obj: ref RingBuffer): void
    print*:              proc(obj: ref RingBuffer) {.async.}
    printxy*:            proc(obj: ref RingBuffer, x: int, y: int) {.async.}
    show*:               proc(obj: ref RingBuffer): void
    getSize*:            proc(obj: ref RingBuffer): int
    getCount*:           proc(obj: ref RingBuffer): int
    setDebug*:           proc(obj: ref RingBuffer, flag: bool): void
    reset*:              proc(obj: ref RingBuffer): void
#}

# Function Declaration
#[
proc setBufferData(obj: ref RingBuffer, data: ref string):int
proc getBufferData(obj: ref RingBuffer): ref string
proc getBufferDataBack(obj: ref RingBuffer): ref string
proc getSize(obj: ref RingBuffer): int
proc getStatus(obj: ref RingBuffer): void
proc print(obj: ref RingBuffer) {.async.}
proc printxy(obj: ref RingBuffer, x: int, y:int ) {.async.}
proc isEmpty(obj: ref RingBuffer): bool
proc isFull(obj: ref RingBuffer): bool
proc setDebug(obj: ref RingBuffer, flag: bool): void
proc getCount(obj: ref RingBuffer): int
proc reset(obj: ref RingBuffer): void
]#

var RingBufferObject*:ref RingBuffer
var logrstr*:string
var logstr*:string
var logrstrarray*:seq[string]

