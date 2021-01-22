
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
    # Turn on page size extension for 4Mbyte pages
    movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
    orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
    movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
    # Set page directory
    movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
    movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
    # Turn on paging.
    movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
    orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
    movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

    # Set up the stack pointer.
    movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 d5 10 80       	mov    $0x8010d5c0,%esp

    # Jump to main(), and switch to executing at
    # high addresses. The indirect call is needed because
    # the assembler produces a PC-relative instruction
    # for a direct jump.
    mov $main, %eax
8010002d:	b8 70 39 10 80       	mov    $0x80103970,%eax
    jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
    // Linked list of all buffers, through prev/next.
    // head.next is most recently used.
    struct buf head;
} bcache;

void binit(void) {
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx
    initlock(&bcache.lock, "bcache");

    // Create linked list of buffers
    bcache.head.prev = &bcache.head;
    bcache.head.next = &bcache.head;
    for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
80100044:	bb f4 d5 10 80       	mov    $0x8010d5f4,%ebx
void binit(void) {
80100049:	83 ec 0c             	sub    $0xc,%esp
    initlock(&bcache.lock, "bcache");
8010004c:	68 20 7b 10 80       	push   $0x80107b20
80100051:	68 c0 d5 10 80       	push   $0x8010d5c0
80100056:	e8 a5 4c 00 00       	call   80104d00 <initlock>
    bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 1d 11 80 bc 	movl   $0x80111cbc,0x80111d0c
80100062:	1c 11 80 
    bcache.head.next = &bcache.head;
80100065:	c7 05 10 1d 11 80 bc 	movl   $0x80111cbc,0x80111d10
8010006c:	1c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 1c 11 80       	mov    $0x80111cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
        b->next = bcache.head.next;
        b->prev = &bcache.head;
        initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
        b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
        b->prev = &bcache.head;
8010008b:	c7 43 50 bc 1c 11 80 	movl   $0x80111cbc,0x50(%ebx)
        initsleeplock(&b->lock, "buffer");
80100092:	68 27 7b 10 80       	push   $0x80107b27
80100097:	50                   	push   %eax
80100098:	e8 33 4b 00 00       	call   80104bd0 <initsleeplock>
        bcache.head.next->prev = b;
8010009d:	a1 10 1d 11 80       	mov    0x80111d10,%eax
    for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
        bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
    for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
        bcache.head.next = b;
801000b0:	89 1d 10 1d 11 80    	mov    %ebx,0x80111d10
    for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
801000b6:	3d bc 1c 11 80       	cmp    $0x80111cbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
    }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
    panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.

struct buf*bread(uint dev, uint blockno) {
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
    acquire(&bcache.lock);
801000df:	68 c0 d5 10 80       	push   $0x8010d5c0
801000e4:	e8 57 4d 00 00       	call   80104e40 <acquire>
    for (b = bcache.head.next; b != &bcache.head; b = b->next) {
801000e9:	8b 1d 10 1d 11 80    	mov    0x80111d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
        if (b->dev == dev && b->blockno == blockno) {
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
            b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
80100120:	8b 1d 0c 1d 11 80    	mov    0x80111d0c,%ebx
80100126:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 1c 11 80    	cmp    $0x80111cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
        if (b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
            b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
            b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
            b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
            b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
            release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 d5 10 80       	push   $0x8010d5c0
80100162:	e8 99 4d 00 00       	call   80104f00 <release>
            acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 4a 00 00       	call   80104c10 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
    struct buf *b;

    b = bget(dev, blockno);
    if ((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
        iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 6d 2a 00 00       	call   80102bf0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
    }
    return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
    panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 7b 10 80       	push   $0x80107b2e
80100198:	e8 43 03 00 00       	call   801004e0 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.

void bwrite(struct buf *b) {
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (!holdingsleep(&b->lock)) {
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 fd 4a 00 00       	call   80104cb0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
        panic("bwrite");
    }
    b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
    iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
    iderw(b);
801001c4:	e9 27 2a 00 00       	jmp    80102bf0 <iderw>
        panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 7b 10 80       	push   $0x80107b3f
801001d1:	e8 0a 03 00 00       	call   801004e0 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.

void brelse(struct buf *b) {
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (!holdingsleep(&b->lock)) {
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 bc 4a 00 00       	call   80104cb0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
        panic("brelse");
    }

    releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 6c 4a 00 00       	call   80104c70 <releasesleep>

    acquire(&bcache.lock);
80100204:	c7 04 24 c0 d5 10 80 	movl   $0x8010d5c0,(%esp)
8010020b:	e8 30 4c 00 00       	call   80104e40 <acquire>
    b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
    if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
    if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
    if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
        // no one is waiting for it.
        b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
        b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
        b->next = bcache.head.next;
80100232:	a1 10 1d 11 80       	mov    0x80111d10,%eax
        b->prev = &bcache.head;
80100237:	c7 43 50 bc 1c 11 80 	movl   $0x80111cbc,0x50(%ebx)
        b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
        bcache.head.next->prev = b;
80100241:	a1 10 1d 11 80       	mov    0x80111d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
        bcache.head.next = b;
80100249:	89 1d 10 1d 11 80    	mov    %ebx,0x80111d10
    }

    release(&bcache.lock);
8010024f:	c7 45 08 c0 d5 10 80 	movl   $0x8010d5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    release(&bcache.lock);
8010025c:	e9 9f 4c 00 00       	jmp    80104f00 <release>
        panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 7b 10 80       	push   $0x80107b46
80100269:	e8 72 02 00 00       	call   801004e0 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <writeVideoRegisters>:
}



// Write the specified values to the VGA registers
static void writeVideoRegisters(uchar* regs) {
80100270:	55                   	push   %ebp
                  "d" (port), "0" (addr), "1" (cnt) :
                  "memory", "cc");
}

static inline void outb(ushort port, uchar data) {
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100271:	ba c2 03 00 00       	mov    $0x3c2,%edx
80100276:	89 e5                	mov    %esp,%ebp
80100278:	57                   	push   %edi
80100279:	56                   	push   %esi
8010027a:	53                   	push   %ebx
8010027b:	89 c3                	mov    %eax,%ebx
8010027d:	0f b6 00             	movzbl (%eax),%eax
80100280:	ee                   	out    %al,(%dx)

    /* write MISCELLANEOUS reg */
    outb(VGA_MISC_WRITE, *regs);
    regs++;
    /* write SEQUENCER regs */
    for (i = 0; i < VGA_NUM_SEQ_REGS; i++)
80100281:	31 c9                	xor    %ecx,%ecx
80100283:	bf c4 03 00 00       	mov    $0x3c4,%edi
80100288:	be c5 03 00 00       	mov    $0x3c5,%esi
8010028d:	89 c8                	mov    %ecx,%eax
8010028f:	89 fa                	mov    %edi,%edx
80100291:	ee                   	out    %al,(%dx)
80100292:	0f b6 44 0b 01       	movzbl 0x1(%ebx,%ecx,1),%eax
80100297:	89 f2                	mov    %esi,%edx
80100299:	ee                   	out    %al,(%dx)
8010029a:	83 c1 01             	add    $0x1,%ecx
8010029d:	83 f9 05             	cmp    $0x5,%ecx
801002a0:	75 eb                	jne    8010028d <writeVideoRegisters+0x1d>
801002a2:	be d4 03 00 00       	mov    $0x3d4,%esi
801002a7:	b8 03 00 00 00       	mov    $0x3,%eax
801002ac:	89 f2                	mov    %esi,%edx
801002ae:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801002af:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801002b4:	89 ca                	mov    %ecx,%edx
801002b6:	ec                   	in     (%dx),%al
        outb(VGA_SEQ_DATA, *regs);
        regs++;
    }
    /* Unlock CRTC registers */
    outb(VGA_CRTC_INDEX, 0x03);
    outb(VGA_CRTC_DATA, inb(VGA_CRTC_DATA) | 0x80);
801002b7:	83 c8 80             	or     $0xffffff80,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801002ba:	ee                   	out    %al,(%dx)
801002bb:	b8 11 00 00 00       	mov    $0x11,%eax
801002c0:	89 f2                	mov    %esi,%edx
801002c2:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801002c3:	89 ca                	mov    %ecx,%edx
801002c5:	ec                   	in     (%dx),%al
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801002c6:	83 e0 7f             	and    $0x7f,%eax
801002c9:	ee                   	out    %al,(%dx)
    outb(VGA_CRTC_INDEX, 0x11);
    outb(VGA_CRTC_DATA, inb(VGA_CRTC_DATA) & ~0x80);
    /* Make sure they remain unlocked */
    regs[0x03] |= 0x80;
801002ca:	80 4b 09 80          	orb    $0x80,0x9(%ebx)
    regs[0x11] &= ~0x80;
801002ce:	80 63 17 7f          	andb   $0x7f,0x17(%ebx)
    /* write CRTC regs */
    for (i = 0; i < VGA_NUM_CRTC_REGS; i++)
801002d2:	31 c9                	xor    %ecx,%ecx
801002d4:	bf d4 03 00 00       	mov    $0x3d4,%edi
801002d9:	be d5 03 00 00       	mov    $0x3d5,%esi
801002de:	66 90                	xchg   %ax,%ax
801002e0:	89 c8                	mov    %ecx,%eax
801002e2:	89 fa                	mov    %edi,%edx
801002e4:	ee                   	out    %al,(%dx)
801002e5:	89 f2                	mov    %esi,%edx
801002e7:	0f b6 44 0b 06       	movzbl 0x6(%ebx,%ecx,1),%eax
801002ec:	ee                   	out    %al,(%dx)
801002ed:	83 c1 01             	add    $0x1,%ecx
801002f0:	83 f9 19             	cmp    $0x19,%ecx
801002f3:	75 eb                	jne    801002e0 <writeVideoRegisters+0x70>
        outb(VGA_CRTC_INDEX, i);
        outb(VGA_CRTC_DATA, *regs);
        regs++;
    }
    /* write GRAPHICS CONTROLLER regs */
    for (i = 0; i < VGA_NUM_GC_REGS; i++)
801002f5:	31 c9                	xor    %ecx,%ecx
801002f7:	bf ce 03 00 00       	mov    $0x3ce,%edi
801002fc:	be cf 03 00 00       	mov    $0x3cf,%esi
80100301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100308:	89 c8                	mov    %ecx,%eax
8010030a:	89 fa                	mov    %edi,%edx
8010030c:	ee                   	out    %al,(%dx)
8010030d:	0f b6 44 0b 1f       	movzbl 0x1f(%ebx,%ecx,1),%eax
80100312:	89 f2                	mov    %esi,%edx
80100314:	ee                   	out    %al,(%dx)
80100315:	83 c1 01             	add    $0x1,%ecx
80100318:	83 f9 09             	cmp    $0x9,%ecx
8010031b:	75 eb                	jne    80100308 <writeVideoRegisters+0x98>
        outb(VGA_GC_INDEX, i);
        outb(VGA_GC_DATA, *regs);
        regs++;
    }
    /* write ATTRIBUTE CONTROLLER regs */
    for (i = 0; i < VGA_NUM_AC_REGS; i++)
8010031d:	31 c9                	xor    %ecx,%ecx
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
8010031f:	bf da 03 00 00       	mov    $0x3da,%edi
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100324:	be c0 03 00 00       	mov    $0x3c0,%esi
80100329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100330:	89 fa                	mov    %edi,%edx
80100332:	ec                   	in     (%dx),%al
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100333:	89 c8                	mov    %ecx,%eax
80100335:	89 f2                	mov    %esi,%edx
80100337:	ee                   	out    %al,(%dx)
80100338:	0f b6 44 0b 28       	movzbl 0x28(%ebx,%ecx,1),%eax
8010033d:	ee                   	out    %al,(%dx)
8010033e:	83 c1 01             	add    $0x1,%ecx
80100341:	83 f9 15             	cmp    $0x15,%ecx
80100344:	75 ea                	jne    80100330 <writeVideoRegisters+0xc0>
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100346:	89 fa                	mov    %edi,%edx
80100348:	ec                   	in     (%dx),%al
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100349:	b8 20 00 00 00       	mov    $0x20,%eax
8010034e:	89 f2                	mov    %esi,%edx
80100350:	ee                   	out    %al,(%dx)
        regs++;
    }
    /* lock 16-color palette and unblank display */
    (void)inb(VGA_INSTAT_READ);
    outb(VGA_AC_INDEX, 0x20);
}
80100351:	5b                   	pop    %ebx
80100352:	5e                   	pop    %esi
80100353:	5f                   	pop    %edi
80100354:	5d                   	pop    %ebp
80100355:	c3                   	ret    
80100356:	8d 76 00             	lea    0x0(%esi),%esi
80100359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100360 <consoleread>:
int consoleread(struct inode *ip, char *dst, int n) {
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	57                   	push   %edi
80100364:	56                   	push   %esi
80100365:	53                   	push   %ebx
80100366:	83 ec 28             	sub    $0x28,%esp
80100369:	8b 7d 08             	mov    0x8(%ebp),%edi
8010036c:	8b 75 0c             	mov    0xc(%ebp),%esi
    iunlock(ip);
8010036f:	57                   	push   %edi
80100370:	e8 bb 1e 00 00       	call   80102230 <iunlock>
    acquire(&cons.lock);
80100375:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010037c:	e8 bf 4a 00 00       	call   80104e40 <acquire>
    while (n > 0) {
80100381:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100384:	83 c4 10             	add    $0x10,%esp
80100387:	31 c0                	xor    %eax,%eax
80100389:	85 db                	test   %ebx,%ebx
8010038b:	0f 8e a1 00 00 00    	jle    80100432 <consoleread+0xd2>
        while (input.r == input.w) {
80100391:	8b 15 80 27 11 80    	mov    0x80112780,%edx
80100397:	39 15 84 27 11 80    	cmp    %edx,0x80112784
8010039d:	74 2c                	je     801003cb <consoleread+0x6b>
8010039f:	eb 5f                	jmp    80100400 <consoleread+0xa0>
801003a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            sleep(&input.r, &cons.lock);
801003a8:	83 ec 08             	sub    $0x8,%esp
801003ab:	68 20 c5 10 80       	push   $0x8010c520
801003b0:	68 80 27 11 80       	push   $0x80112780
801003b5:	e8 c6 44 00 00       	call   80104880 <sleep>
        while (input.r == input.w) {
801003ba:	8b 15 80 27 11 80    	mov    0x80112780,%edx
801003c0:	83 c4 10             	add    $0x10,%esp
801003c3:	3b 15 84 27 11 80    	cmp    0x80112784,%edx
801003c9:	75 35                	jne    80100400 <consoleread+0xa0>
            if (myproc()->killed) {
801003cb:	e8 10 3f 00 00       	call   801042e0 <myproc>
801003d0:	8b 40 24             	mov    0x24(%eax),%eax
801003d3:	85 c0                	test   %eax,%eax
801003d5:	74 d1                	je     801003a8 <consoleread+0x48>
                release(&cons.lock);
801003d7:	83 ec 0c             	sub    $0xc,%esp
801003da:	68 20 c5 10 80       	push   $0x8010c520
801003df:	e8 1c 4b 00 00       	call   80104f00 <release>
                ilock(ip);
801003e4:	89 3c 24             	mov    %edi,(%esp)
801003e7:	e8 64 1d 00 00       	call   80102150 <ilock>
                return -1;
801003ec:	83 c4 10             	add    $0x10,%esp
}
801003ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
                return -1;
801003f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801003f7:	5b                   	pop    %ebx
801003f8:	5e                   	pop    %esi
801003f9:	5f                   	pop    %edi
801003fa:	5d                   	pop    %ebp
801003fb:	c3                   	ret    
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        c = input.buf[input.r++ % INPUT_BUF];
80100400:	8d 42 01             	lea    0x1(%edx),%eax
80100403:	a3 80 27 11 80       	mov    %eax,0x80112780
80100408:	89 d0                	mov    %edx,%eax
8010040a:	83 e0 7f             	and    $0x7f,%eax
8010040d:	0f be 80 00 27 11 80 	movsbl -0x7feed900(%eax),%eax
        if (c == C('D')) { // EOF
80100414:	83 f8 04             	cmp    $0x4,%eax
80100417:	74 3f                	je     80100458 <consoleread+0xf8>
        *dst++ = c;
80100419:	83 c6 01             	add    $0x1,%esi
        --n;
8010041c:	83 eb 01             	sub    $0x1,%ebx
        if (c == '\n') {
8010041f:	83 f8 0a             	cmp    $0xa,%eax
        *dst++ = c;
80100422:	88 46 ff             	mov    %al,-0x1(%esi)
        if (c == '\n') {
80100425:	74 43                	je     8010046a <consoleread+0x10a>
    while (n > 0) {
80100427:	85 db                	test   %ebx,%ebx
80100429:	0f 85 62 ff ff ff    	jne    80100391 <consoleread+0x31>
8010042f:	8b 45 10             	mov    0x10(%ebp),%eax
    release(&cons.lock);
80100432:	83 ec 0c             	sub    $0xc,%esp
80100435:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100438:	68 20 c5 10 80       	push   $0x8010c520
8010043d:	e8 be 4a 00 00       	call   80104f00 <release>
    ilock(ip);
80100442:	89 3c 24             	mov    %edi,(%esp)
80100445:	e8 06 1d 00 00       	call   80102150 <ilock>
    return target - n;
8010044a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010044d:	83 c4 10             	add    $0x10,%esp
}
80100450:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100453:	5b                   	pop    %ebx
80100454:	5e                   	pop    %esi
80100455:	5f                   	pop    %edi
80100456:	5d                   	pop    %ebp
80100457:	c3                   	ret    
80100458:	8b 45 10             	mov    0x10(%ebp),%eax
8010045b:	29 d8                	sub    %ebx,%eax
            if (n < target) {
8010045d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100460:	73 d0                	jae    80100432 <consoleread+0xd2>
                input.r--;
80100462:	89 15 80 27 11 80    	mov    %edx,0x80112780
80100468:	eb c8                	jmp    80100432 <consoleread+0xd2>
8010046a:	8b 45 10             	mov    0x10(%ebp),%eax
8010046d:	29 d8                	sub    %ebx,%eax
8010046f:	eb c1                	jmp    80100432 <consoleread+0xd2>
80100471:	eb 0d                	jmp    80100480 <snapshotTextTake.part.0>
80100473:	90                   	nop
80100474:	90                   	nop
80100475:	90                   	nop
80100476:	90                   	nop
80100477:	90                   	nop
80100478:	90                   	nop
80100479:	90                   	nop
8010047a:	90                   	nop
8010047b:	90                   	nop
8010047c:	90                   	nop
8010047d:	90                   	nop
8010047e:	90                   	nop
8010047f:	90                   	nop

80100480 <snapshotTextTake.part.0>:
    outb(CRTPORT, 14);
    outb(CRTPORT + 1, pos >> 8);
    outb(CRTPORT, 15);
    outb(CRTPORT + 1, pos);
}
void snapshotTextTake()                     
80100480:	55                   	push   %ebp
80100481:	ba 00 80 0b 80       	mov    $0x800b8000,%edx
        // Declare some variables
        int i;
        ushort* crtRegister = VGA_0x03_MEMORY;

        //Loop through the register and take all the values
        for (i = 0; i < 2000; i++)
80100486:	31 c0                	xor    %eax,%eax
void snapshotTextTake()                     
80100488:	89 e5                	mov    %esp,%ebp
8010048a:	56                   	push   %esi
8010048b:	53                   	push   %ebx
8010048c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        {
            consoleSnapshot.registerCopy[i] =  crtRegister[i];
80100490:	0f b7 0a             	movzwl (%edx),%ecx
        for (i = 0; i < 2000; i++)
80100493:	83 c0 01             	add    $0x1,%eax
80100496:	83 c2 02             	add    $0x2,%edx
            consoleSnapshot.registerCopy[i] =  crtRegister[i];
80100499:	88 88 23 1f 11 80    	mov    %cl,-0x7feee0dd(%eax)
        for (i = 0; i < 2000; i++)
8010049f:	3d d0 07 00 00       	cmp    $0x7d0,%eax
801004a4:	75 ea                	jne    80100490 <snapshotTextTake.part.0+0x10>
801004a6:	be d4 03 00 00       	mov    $0x3d4,%esi
801004ab:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b0:	89 f2                	mov    %esi,%edx
801004b2:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801004b3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004b8:	89 ca                	mov    %ecx,%edx
801004ba:	ec                   	in     (%dx),%al
        int TempPos;     // Cursor position: col + 80*row.


        //Take cursor position from os
        outb(0x3d4, 14);           
        TempPos = inb(0x3d4 + 1) << 8;  
801004bb:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801004be:	89 f2                	mov    %esi,%edx
801004c0:	c1 e0 08             	shl    $0x8,%eax
801004c3:	89 c3                	mov    %eax,%ebx
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ec                   	in     (%dx),%al
        outb(0x3d4, 15);            
        TempPos |= inb(0x3d4 + 1);      
801004ce:	0f b6 c0             	movzbl %al,%eax
801004d1:	09 d8                	or     %ebx,%eax
801004d3:	a3 20 1f 11 80       	mov    %eax,0x80111f20

        //Store the position in our snapshot
        consoleSnapshot.cursorPos = TempPos; 
    }
}
801004d8:	5b                   	pop    %ebx
801004d9:	5e                   	pop    %esi
801004da:	5d                   	pop    %ebp
801004db:	c3                   	ret    
801004dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801004e0 <panic>:
void panic(char *s) {
801004e0:	55                   	push   %ebp
801004e1:	89 e5                	mov    %esp,%ebp
801004e3:	56                   	push   %esi
801004e4:	53                   	push   %ebx
801004e5:	83 ec 30             	sub    $0x30,%esp
static inline void loadgs(ushort v)  {
    asm volatile ("movw %0, %%gs" : : "r" (v));
}

static inline void cli(void) {
    asm volatile ("cli");
801004e8:	fa                   	cli    
    cons.locking = 0;
801004e9:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
801004f0:	00 00 00 
    getcallerpcs(&s, pcs);
801004f3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801004f6:	8d 75 f8             	lea    -0x8(%ebp),%esi
    cprintf("lapicid %d: panic: ", lapicid());
801004f9:	e8 02 2d 00 00       	call   80103200 <lapicid>
801004fe:	83 ec 08             	sub    $0x8,%esp
80100501:	50                   	push   %eax
80100502:	68 4d 7b 10 80       	push   $0x80107b4d
80100507:	e8 54 03 00 00       	call   80100860 <cprintf>
    cprintf(s);
8010050c:	58                   	pop    %eax
8010050d:	ff 75 08             	pushl  0x8(%ebp)
80100510:	e8 4b 03 00 00       	call   80100860 <cprintf>
    cprintf("\n");
80100515:	c7 04 24 47 85 10 80 	movl   $0x80108547,(%esp)
8010051c:	e8 3f 03 00 00       	call   80100860 <cprintf>
    getcallerpcs(&s, pcs);
80100521:	5a                   	pop    %edx
80100522:	8d 45 08             	lea    0x8(%ebp),%eax
80100525:	59                   	pop    %ecx
80100526:	53                   	push   %ebx
80100527:	50                   	push   %eax
80100528:	e8 f3 47 00 00       	call   80104d20 <getcallerpcs>
8010052d:	83 c4 10             	add    $0x10,%esp
        cprintf(" %p", pcs[i]);
80100530:	83 ec 08             	sub    $0x8,%esp
80100533:	ff 33                	pushl  (%ebx)
80100535:	83 c3 04             	add    $0x4,%ebx
80100538:	68 61 7b 10 80       	push   $0x80107b61
8010053d:	e8 1e 03 00 00       	call   80100860 <cprintf>
    for (i = 0; i < 10; i++) {
80100542:	83 c4 10             	add    $0x10,%esp
80100545:	39 f3                	cmp    %esi,%ebx
80100547:	75 e7                	jne    80100530 <panic+0x50>
    panicked = 1; // freeze other CPU
80100549:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
80100550:	00 00 00 
80100553:	eb fe                	jmp    80100553 <panic+0x73>
80100555:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100560 <consputc>:
    if (panicked) {
80100560:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
80100566:	85 c9                	test   %ecx,%ecx
80100568:	74 06                	je     80100570 <consputc+0x10>
8010056a:	fa                   	cli    
8010056b:	eb fe                	jmp    8010056b <consputc+0xb>
8010056d:	8d 76 00             	lea    0x0(%esi),%esi
void consputc(int c) {
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	53                   	push   %ebx
80100576:	89 c6                	mov    %eax,%esi
80100578:	83 ec 0c             	sub    $0xc,%esp
    if (c == BACKSPACE) {
8010057b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100580:	0f 84 82 00 00 00    	je     80100608 <consputc+0xa8>
        uartputc(c);
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	50                   	push   %eax
8010058a:	e8 81 61 00 00       	call   80106710 <uartputc>
8010058f:	83 c4 10             	add    $0x10,%esp
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100592:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100597:	b8 0e 00 00 00       	mov    $0xe,%eax
8010059c:	89 da                	mov    %ebx,%edx
8010059e:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
8010059f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801005a4:	89 ca                	mov    %ecx,%edx
801005a6:	ec                   	in     (%dx),%al
801005a7:	89 c7                	mov    %eax,%edi
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801005a9:	89 da                	mov    %ebx,%edx
801005ab:	b8 0f 00 00 00       	mov    $0xf,%eax
801005b0:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801005b1:	89 ca                	mov    %ecx,%edx
801005b3:	ec                   	in     (%dx),%al
    if(currentvgamode ==0x03) //If we are in text, go to the usual execution
801005b4:	83 3d c0 a0 10 80 03 	cmpl   $0x3,0x8010a0c0
801005bb:	0f b6 d8             	movzbl %al,%ebx
801005be:	0f 84 e2 00 00 00    	je     801006a6 <consputc+0x146>
        if (c == '\n') { //If character is a new line
801005c4:	83 fe 0a             	cmp    $0xa,%esi
801005c7:	8b 0d 20 1f 11 80    	mov    0x80111f20,%ecx
801005cd:	0f 84 ba 00 00 00    	je     8010068d <consputc+0x12d>
        else if (c == BACKSPACE) { //If character is a backspace
801005d3:	81 fe 00 01 00 00    	cmp    $0x100,%esi
801005d9:	74 57                	je     80100632 <consputc+0xd2>
            consoleSnapshot.registerCopy[consoleSnapshot.cursorPos] = (c & 0xff) | 0x0700;  // black on white
801005db:	89 f0                	mov    %esi,%eax
            consoleSnapshot.cursorPos++;
801005dd:	83 c1 01             	add    $0x1,%ecx
            consoleSnapshot.registerCopy[consoleSnapshot.cursorPos] = (c & 0xff) | 0x0700;  // black on white
801005e0:	88 81 23 1f 11 80    	mov    %al,-0x7feee0dd(%ecx)
            consoleSnapshot.cursorPos++;
801005e6:	89 0d 20 1f 11 80    	mov    %ecx,0x80111f20
        if (consoleSnapshot.cursorPos < 0 || consoleSnapshot.cursorPos > 25 * 80) {
801005ec:	81 f9 d0 07 00 00    	cmp    $0x7d0,%ecx
801005f2:	0f 87 88 00 00 00    	ja     80100680 <consputc+0x120>
        if ((consoleSnapshot.cursorPos / 80) >= 24) { // Scroll up.
801005f8:	81 f9 7f 07 00 00    	cmp    $0x77f,%ecx
801005fe:	7f 41                	jg     80100641 <consputc+0xe1>
}
80100600:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100603:	5b                   	pop    %ebx
80100604:	5e                   	pop    %esi
80100605:	5f                   	pop    %edi
80100606:	5d                   	pop    %ebp
80100607:	c3                   	ret    
        uartputc('\b');
80100608:	83 ec 0c             	sub    $0xc,%esp
8010060b:	6a 08                	push   $0x8
8010060d:	e8 fe 60 00 00       	call   80106710 <uartputc>
        uartputc(' ');
80100612:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100619:	e8 f2 60 00 00       	call   80106710 <uartputc>
        uartputc('\b');
8010061e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100625:	e8 e6 60 00 00       	call   80106710 <uartputc>
8010062a:	83 c4 10             	add    $0x10,%esp
8010062d:	e9 60 ff ff ff       	jmp    80100592 <consputc+0x32>
            if (consoleSnapshot.cursorPos > 0) {
80100632:	85 c9                	test   %ecx,%ecx
80100634:	7e b6                	jle    801005ec <consputc+0x8c>
                --consoleSnapshot.cursorPos;
80100636:	83 e9 01             	sub    $0x1,%ecx
80100639:	89 0d 20 1f 11 80    	mov    %ecx,0x80111f20
8010063f:	eb ab                	jmp    801005ec <consputc+0x8c>
            memmove(consoleSnapshot.registerCopy, consoleSnapshot.registerCopy + 80, sizeof(consoleSnapshot.registerCopy[0]) * 23 * 80);
80100641:	50                   	push   %eax
80100642:	68 30 07 00 00       	push   $0x730
80100647:	68 74 1f 11 80       	push   $0x80111f74
8010064c:	68 24 1f 11 80       	push   $0x80111f24
80100651:	e8 aa 49 00 00       	call   80105000 <memmove>
            consoleSnapshot.cursorPos -= 80;
80100656:	a1 20 1f 11 80       	mov    0x80111f20,%eax
            memset(consoleSnapshot.registerCopy + consoleSnapshot.cursorPos, 0, sizeof(consoleSnapshot.registerCopy[0]) * (24 * 80 - consoleSnapshot.cursorPos));
8010065b:	ba 80 07 00 00       	mov    $0x780,%edx
80100660:	83 c4 0c             	add    $0xc,%esp
            consoleSnapshot.cursorPos -= 80;
80100663:	83 e8 50             	sub    $0x50,%eax
            memset(consoleSnapshot.registerCopy + consoleSnapshot.cursorPos, 0, sizeof(consoleSnapshot.registerCopy[0]) * (24 * 80 - consoleSnapshot.cursorPos));
80100666:	29 c2                	sub    %eax,%edx
            consoleSnapshot.cursorPos -= 80;
80100668:	a3 20 1f 11 80       	mov    %eax,0x80111f20
            memset(consoleSnapshot.registerCopy + consoleSnapshot.cursorPos, 0, sizeof(consoleSnapshot.registerCopy[0]) * (24 * 80 - consoleSnapshot.cursorPos));
8010066d:	05 24 1f 11 80       	add    $0x80111f24,%eax
80100672:	52                   	push   %edx
80100673:	6a 00                	push   $0x0
80100675:	50                   	push   %eax
80100676:	e8 d5 48 00 00       	call   80104f50 <memset>
8010067b:	83 c4 10             	add    $0x10,%esp
}
8010067e:	eb 80                	jmp    80100600 <consputc+0xa0>
            panic("pos under/overflow");
80100680:	83 ec 0c             	sub    $0xc,%esp
80100683:	68 65 7b 10 80       	push   $0x80107b65
80100688:	e8 53 fe ff ff       	call   801004e0 <panic>
            consoleSnapshot.cursorPos += 80 - consoleSnapshot.cursorPos % 80;
8010068d:	89 c8                	mov    %ecx,%eax
8010068f:	bb 50 00 00 00       	mov    $0x50,%ebx
80100694:	99                   	cltd   
80100695:	f7 fb                	idiv   %ebx
80100697:	29 d3                	sub    %edx,%ebx
80100699:	01 d9                	add    %ebx,%ecx
8010069b:	89 0d 20 1f 11 80    	mov    %ecx,0x80111f20
801006a1:	e9 46 ff ff ff       	jmp    801005ec <consputc+0x8c>
    pos = inb(CRTPORT + 1) << 8;
801006a6:	89 f8                	mov    %edi,%eax
801006a8:	0f b6 c0             	movzbl %al,%eax
801006ab:	c1 e0 08             	shl    $0x8,%eax
    pos |= inb(CRTPORT + 1);
801006ae:	09 c3                	or     %eax,%ebx
        if (c == '\n') {
801006b0:	83 fe 0a             	cmp    $0xa,%esi
801006b3:	0f 84 a9 00 00 00    	je     80100762 <consputc+0x202>
        else if (c == BACKSPACE) {
801006b9:	81 fe 00 01 00 00    	cmp    $0x100,%esi
801006bf:	0f 84 91 00 00 00    	je     80100756 <consputc+0x1f6>
            crt[pos++] = (c & 0xff) | 0x0700;  // black on white
801006c5:	89 f0                	mov    %esi,%eax
801006c7:	0f b6 c0             	movzbl %al,%eax
801006ca:	80 cc 07             	or     $0x7,%ah
801006cd:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801006d4:	80 
801006d5:	83 c3 01             	add    $0x1,%ebx
        if (pos < 0 || pos > 25 * 80) {
801006d8:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801006de:	7f a0                	jg     80100680 <consputc+0x120>
        if ((pos / 80) >= 24) { // Scroll up.
801006e0:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801006e6:	7e 38                	jle    80100720 <consputc+0x1c0>
            memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
801006e8:	52                   	push   %edx
801006e9:	68 60 0e 00 00       	push   $0xe60
            pos -= 80;
801006ee:	83 eb 50             	sub    $0x50,%ebx
            memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
801006f1:	68 a0 80 0b 80       	push   $0x800b80a0
801006f6:	68 00 80 0b 80       	push   $0x800b8000
801006fb:	e8 00 49 00 00       	call   80105000 <memmove>
            memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
80100700:	b8 80 07 00 00       	mov    $0x780,%eax
80100705:	83 c4 0c             	add    $0xc,%esp
80100708:	29 d8                	sub    %ebx,%eax
8010070a:	01 c0                	add    %eax,%eax
8010070c:	50                   	push   %eax
8010070d:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100710:	6a 00                	push   $0x0
80100712:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100717:	50                   	push   %eax
80100718:	e8 33 48 00 00       	call   80104f50 <memset>
8010071d:	83 c4 10             	add    $0x10,%esp
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100720:	be d4 03 00 00       	mov    $0x3d4,%esi
80100725:	b8 0e 00 00 00       	mov    $0xe,%eax
8010072a:	89 f2                	mov    %esi,%edx
8010072c:	ee                   	out    %al,(%dx)
8010072d:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
        outb(CRTPORT + 1, pos >> 8);
80100732:	89 d8                	mov    %ebx,%eax
80100734:	c1 f8 08             	sar    $0x8,%eax
80100737:	89 ca                	mov    %ecx,%edx
80100739:	ee                   	out    %al,(%dx)
8010073a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010073f:	89 f2                	mov    %esi,%edx
80100741:	ee                   	out    %al,(%dx)
80100742:	89 d8                	mov    %ebx,%eax
80100744:	89 ca                	mov    %ecx,%edx
80100746:	ee                   	out    %al,(%dx)
        crt[pos] = ' ' | 0x0700;
80100747:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
8010074e:	80 20 07 
80100751:	e9 aa fe ff ff       	jmp    80100600 <consputc+0xa0>
            if (pos > 0) {
80100756:	85 db                	test   %ebx,%ebx
80100758:	74 c6                	je     80100720 <consputc+0x1c0>
                --pos;
8010075a:	83 eb 01             	sub    $0x1,%ebx
8010075d:	e9 76 ff ff ff       	jmp    801006d8 <consputc+0x178>
            pos += 80 - pos % 80;
80100762:	89 d8                	mov    %ebx,%eax
80100764:	b9 50 00 00 00       	mov    $0x50,%ecx
80100769:	99                   	cltd   
8010076a:	f7 f9                	idiv   %ecx
8010076c:	29 d1                	sub    %edx,%ecx
8010076e:	01 cb                	add    %ecx,%ebx
80100770:	e9 63 ff ff ff       	jmp    801006d8 <consputc+0x178>
80100775:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100780 <printint>:
static void printint(int xx, int base, int sign) {
80100780:	55                   	push   %ebp
80100781:	89 e5                	mov    %esp,%ebp
80100783:	57                   	push   %edi
80100784:	56                   	push   %esi
80100785:	53                   	push   %ebx
80100786:	89 d3                	mov    %edx,%ebx
80100788:	83 ec 2c             	sub    $0x2c,%esp
    if (sign && (sign = xx < 0)) {
8010078b:	85 c9                	test   %ecx,%ecx
static void printint(int xx, int base, int sign) {
8010078d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    if (sign && (sign = xx < 0)) {
80100790:	74 04                	je     80100796 <printint+0x16>
80100792:	85 c0                	test   %eax,%eax
80100794:	78 5a                	js     801007f0 <printint+0x70>
        x = xx;
80100796:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    i = 0;
8010079d:	31 c9                	xor    %ecx,%ecx
8010079f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801007a2:	eb 06                	jmp    801007aa <printint+0x2a>
801007a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        buf[i++] = digits[x % base];
801007a8:	89 f9                	mov    %edi,%ecx
801007aa:	31 d2                	xor    %edx,%edx
801007ac:	8d 79 01             	lea    0x1(%ecx),%edi
801007af:	f7 f3                	div    %ebx
801007b1:	0f b6 92 c0 7b 10 80 	movzbl -0x7fef8440(%edx),%edx
    while ((x /= base) != 0);
801007b8:	85 c0                	test   %eax,%eax
        buf[i++] = digits[x % base];
801007ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
    while ((x /= base) != 0);
801007bd:	75 e9                	jne    801007a8 <printint+0x28>
    if (sign) {
801007bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801007c2:	85 c0                	test   %eax,%eax
801007c4:	74 08                	je     801007ce <printint+0x4e>
        buf[i++] = '-';
801007c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801007cb:	8d 79 02             	lea    0x2(%ecx),%edi
801007ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801007d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        consputc(buf[i]);
801007d8:	0f be 03             	movsbl (%ebx),%eax
801007db:	83 eb 01             	sub    $0x1,%ebx
801007de:	e8 7d fd ff ff       	call   80100560 <consputc>
    while (--i >= 0) {
801007e3:	39 f3                	cmp    %esi,%ebx
801007e5:	75 f1                	jne    801007d8 <printint+0x58>
}
801007e7:	83 c4 2c             	add    $0x2c,%esp
801007ea:	5b                   	pop    %ebx
801007eb:	5e                   	pop    %esi
801007ec:	5f                   	pop    %edi
801007ed:	5d                   	pop    %ebp
801007ee:	c3                   	ret    
801007ef:	90                   	nop
        x = -xx;
801007f0:	f7 d8                	neg    %eax
801007f2:	eb a9                	jmp    8010079d <printint+0x1d>
801007f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100800 <consolewrite>:
int consolewrite(struct inode *ip, char *buf, int n) {
80100800:	55                   	push   %ebp
80100801:	89 e5                	mov    %esp,%ebp
80100803:	57                   	push   %edi
80100804:	56                   	push   %esi
80100805:	53                   	push   %ebx
80100806:	83 ec 18             	sub    $0x18,%esp
80100809:	8b 75 10             	mov    0x10(%ebp),%esi
    iunlock(ip);
8010080c:	ff 75 08             	pushl  0x8(%ebp)
8010080f:	e8 1c 1a 00 00       	call   80102230 <iunlock>
    acquire(&cons.lock);
80100814:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010081b:	e8 20 46 00 00       	call   80104e40 <acquire>
    for (i = 0; i < n; i++) {
80100820:	83 c4 10             	add    $0x10,%esp
80100823:	85 f6                	test   %esi,%esi
80100825:	7e 18                	jle    8010083f <consolewrite+0x3f>
80100827:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010082a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010082d:	8d 76 00             	lea    0x0(%esi),%esi
        consputc(buf[i] & 0xff);
80100830:	0f b6 07             	movzbl (%edi),%eax
80100833:	83 c7 01             	add    $0x1,%edi
80100836:	e8 25 fd ff ff       	call   80100560 <consputc>
    for (i = 0; i < n; i++) {
8010083b:	39 fb                	cmp    %edi,%ebx
8010083d:	75 f1                	jne    80100830 <consolewrite+0x30>
    release(&cons.lock);
8010083f:	83 ec 0c             	sub    $0xc,%esp
80100842:	68 20 c5 10 80       	push   $0x8010c520
80100847:	e8 b4 46 00 00       	call   80104f00 <release>
    ilock(ip);
8010084c:	58                   	pop    %eax
8010084d:	ff 75 08             	pushl  0x8(%ebp)
80100850:	e8 fb 18 00 00       	call   80102150 <ilock>
}
80100855:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100858:	89 f0                	mov    %esi,%eax
8010085a:	5b                   	pop    %ebx
8010085b:	5e                   	pop    %esi
8010085c:	5f                   	pop    %edi
8010085d:	5d                   	pop    %ebp
8010085e:	c3                   	ret    
8010085f:	90                   	nop

80100860 <cprintf>:
void cprintf(char *fmt, ...) {
80100860:	55                   	push   %ebp
80100861:	89 e5                	mov    %esp,%ebp
80100863:	57                   	push   %edi
80100864:	56                   	push   %esi
80100865:	53                   	push   %ebx
80100866:	83 ec 1c             	sub    $0x1c,%esp
    locking = cons.locking;
80100869:	a1 54 c5 10 80       	mov    0x8010c554,%eax
    if (locking) {
8010086e:	85 c0                	test   %eax,%eax
    locking = cons.locking;
80100870:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (locking) {
80100873:	0f 85 6f 01 00 00    	jne    801009e8 <cprintf+0x188>
    if (fmt == 0) {
80100879:	8b 45 08             	mov    0x8(%ebp),%eax
8010087c:	85 c0                	test   %eax,%eax
8010087e:	89 c7                	mov    %eax,%edi
80100880:	0f 84 77 01 00 00    	je     801009fd <cprintf+0x19d>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
80100886:	0f b6 00             	movzbl (%eax),%eax
    argp = (uint*)(void*)(&fmt + 1);
80100889:	8d 4d 0c             	lea    0xc(%ebp),%ecx
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
8010088c:	31 db                	xor    %ebx,%ebx
    argp = (uint*)(void*)(&fmt + 1);
8010088e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
80100891:	85 c0                	test   %eax,%eax
80100893:	75 56                	jne    801008eb <cprintf+0x8b>
80100895:	eb 79                	jmp    80100910 <cprintf+0xb0>
80100897:	89 f6                	mov    %esi,%esi
80100899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        c = fmt[++i] & 0xff;
801008a0:	0f b6 16             	movzbl (%esi),%edx
        if (c == 0) {
801008a3:	85 d2                	test   %edx,%edx
801008a5:	74 69                	je     80100910 <cprintf+0xb0>
801008a7:	83 c3 02             	add    $0x2,%ebx
        switch (c) {
801008aa:	83 fa 70             	cmp    $0x70,%edx
801008ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801008b0:	0f 84 84 00 00 00    	je     8010093a <cprintf+0xda>
801008b6:	7f 78                	jg     80100930 <cprintf+0xd0>
801008b8:	83 fa 25             	cmp    $0x25,%edx
801008bb:	0f 84 ff 00 00 00    	je     801009c0 <cprintf+0x160>
801008c1:	83 fa 64             	cmp    $0x64,%edx
801008c4:	0f 85 8e 00 00 00    	jne    80100958 <cprintf+0xf8>
                printint(*argp++, 10, 1);
801008ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801008cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801008d2:	8d 48 04             	lea    0x4(%eax),%ecx
801008d5:	8b 00                	mov    (%eax),%eax
801008d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801008da:	b9 01 00 00 00       	mov    $0x1,%ecx
801008df:	e8 9c fe ff ff       	call   80100780 <printint>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
801008e4:	0f b6 06             	movzbl (%esi),%eax
801008e7:	85 c0                	test   %eax,%eax
801008e9:	74 25                	je     80100910 <cprintf+0xb0>
801008eb:	8d 53 01             	lea    0x1(%ebx),%edx
        if (c != '%') {
801008ee:	83 f8 25             	cmp    $0x25,%eax
801008f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801008f4:	74 aa                	je     801008a0 <cprintf+0x40>
801008f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
            consputc(c);
801008f9:	e8 62 fc ff ff       	call   80100560 <consputc>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
801008fe:	0f b6 06             	movzbl (%esi),%eax
            continue;
80100901:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100904:	89 d3                	mov    %edx,%ebx
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
80100906:	85 c0                	test   %eax,%eax
80100908:	75 e1                	jne    801008eb <cprintf+0x8b>
8010090a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (locking) {
80100910:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100913:	85 c0                	test   %eax,%eax
80100915:	74 10                	je     80100927 <cprintf+0xc7>
        release(&cons.lock);
80100917:	83 ec 0c             	sub    $0xc,%esp
8010091a:	68 20 c5 10 80       	push   $0x8010c520
8010091f:	e8 dc 45 00 00       	call   80104f00 <release>
80100924:	83 c4 10             	add    $0x10,%esp
}
80100927:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010092a:	5b                   	pop    %ebx
8010092b:	5e                   	pop    %esi
8010092c:	5f                   	pop    %edi
8010092d:	5d                   	pop    %ebp
8010092e:	c3                   	ret    
8010092f:	90                   	nop
        switch (c) {
80100930:	83 fa 73             	cmp    $0x73,%edx
80100933:	74 43                	je     80100978 <cprintf+0x118>
80100935:	83 fa 78             	cmp    $0x78,%edx
80100938:	75 1e                	jne    80100958 <cprintf+0xf8>
                printint(*argp++, 16, 0);
8010093a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010093d:	ba 10 00 00 00       	mov    $0x10,%edx
80100942:	8d 48 04             	lea    0x4(%eax),%ecx
80100945:	8b 00                	mov    (%eax),%eax
80100947:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010094a:	31 c9                	xor    %ecx,%ecx
8010094c:	e8 2f fe ff ff       	call   80100780 <printint>
                break;
80100951:	eb 91                	jmp    801008e4 <cprintf+0x84>
80100953:	90                   	nop
80100954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                consputc('%');
80100958:	b8 25 00 00 00       	mov    $0x25,%eax
8010095d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100960:	e8 fb fb ff ff       	call   80100560 <consputc>
                consputc(c);
80100965:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100968:	89 d0                	mov    %edx,%eax
8010096a:	e8 f1 fb ff ff       	call   80100560 <consputc>
                break;
8010096f:	e9 70 ff ff ff       	jmp    801008e4 <cprintf+0x84>
80100974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                if ((s = (char*)*argp++) == 0) {
80100978:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010097b:	8b 10                	mov    (%eax),%edx
8010097d:	8d 48 04             	lea    0x4(%eax),%ecx
80100980:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100983:	85 d2                	test   %edx,%edx
80100985:	74 49                	je     801009d0 <cprintf+0x170>
                for (; *s; s++) {
80100987:	0f be 02             	movsbl (%edx),%eax
                if ((s = (char*)*argp++) == 0) {
8010098a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
                for (; *s; s++) {
8010098d:	84 c0                	test   %al,%al
8010098f:	0f 84 4f ff ff ff    	je     801008e4 <cprintf+0x84>
80100995:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100998:	89 d3                	mov    %edx,%ebx
8010099a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801009a0:	83 c3 01             	add    $0x1,%ebx
                    consputc(*s);
801009a3:	e8 b8 fb ff ff       	call   80100560 <consputc>
                for (; *s; s++) {
801009a8:	0f be 03             	movsbl (%ebx),%eax
801009ab:	84 c0                	test   %al,%al
801009ad:	75 f1                	jne    801009a0 <cprintf+0x140>
                if ((s = (char*)*argp++) == 0) {
801009af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801009b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801009b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801009b8:	e9 27 ff ff ff       	jmp    801008e4 <cprintf+0x84>
801009bd:	8d 76 00             	lea    0x0(%esi),%esi
                consputc('%');
801009c0:	b8 25 00 00 00       	mov    $0x25,%eax
801009c5:	e8 96 fb ff ff       	call   80100560 <consputc>
                break;
801009ca:	e9 15 ff ff ff       	jmp    801008e4 <cprintf+0x84>
801009cf:	90                   	nop
                    s = "(null)";
801009d0:	ba 78 7b 10 80       	mov    $0x80107b78,%edx
                for (; *s; s++) {
801009d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801009d8:	b8 28 00 00 00       	mov    $0x28,%eax
801009dd:	89 d3                	mov    %edx,%ebx
801009df:	eb bf                	jmp    801009a0 <cprintf+0x140>
801009e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        acquire(&cons.lock);
801009e8:	83 ec 0c             	sub    $0xc,%esp
801009eb:	68 20 c5 10 80       	push   $0x8010c520
801009f0:	e8 4b 44 00 00       	call   80104e40 <acquire>
801009f5:	83 c4 10             	add    $0x10,%esp
801009f8:	e9 7c fe ff ff       	jmp    80100879 <cprintf+0x19>
        panic("null fmt");
801009fd:	83 ec 0c             	sub    $0xc,%esp
80100a00:	68 7f 7b 10 80       	push   $0x80107b7f
80100a05:	e8 d6 fa ff ff       	call   801004e0 <panic>
80100a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100a10 <consoleget>:
int consoleget(void) {
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	83 ec 24             	sub    $0x24,%esp
    acquire(&cons.lock);
80100a16:	68 20 c5 10 80       	push   $0x8010c520
80100a1b:	e8 20 44 00 00       	call   80104e40 <acquire>
    while ((c = kbdgetc()) <= 0) {
80100a20:	83 c4 10             	add    $0x10,%esp
80100a23:	eb 05                	jmp    80100a2a <consoleget+0x1a>
80100a25:	8d 76 00             	lea    0x0(%esi),%esi
        if (c == 0) {
80100a28:	74 26                	je     80100a50 <consoleget+0x40>
    while ((c = kbdgetc()) <= 0) {
80100a2a:	e8 d1 25 00 00       	call   80103000 <kbdgetc>
80100a2f:	83 f8 00             	cmp    $0x0,%eax
80100a32:	7e f4                	jle    80100a28 <consoleget+0x18>
    release(&cons.lock);
80100a34:	83 ec 0c             	sub    $0xc,%esp
80100a37:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100a3a:	68 20 c5 10 80       	push   $0x8010c520
80100a3f:	e8 bc 44 00 00       	call   80104f00 <release>
}
80100a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a47:	c9                   	leave  
80100a48:	c3                   	ret    
80100a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            c = kbdgetc();
80100a50:	e8 ab 25 00 00       	call   80103000 <kbdgetc>
80100a55:	eb d3                	jmp    80100a2a <consoleget+0x1a>
80100a57:	89 f6                	mov    %esi,%esi
80100a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100a60 <consoleintr>:
void consoleintr(int (*getc)(void)) {
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	57                   	push   %edi
80100a64:	56                   	push   %esi
80100a65:	53                   	push   %ebx
    int c, doprocdump = 0;
80100a66:	31 f6                	xor    %esi,%esi
void consoleintr(int (*getc)(void)) {
80100a68:	83 ec 18             	sub    $0x18,%esp
80100a6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&cons.lock);
80100a6e:	68 20 c5 10 80       	push   $0x8010c520
80100a73:	e8 c8 43 00 00       	call   80104e40 <acquire>
    while ((c = getc()) >= 0) {
80100a78:	83 c4 10             	add    $0x10,%esp
80100a7b:	90                   	nop
80100a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a80:	ff d3                	call   *%ebx
80100a82:	85 c0                	test   %eax,%eax
80100a84:	89 c7                	mov    %eax,%edi
80100a86:	78 48                	js     80100ad0 <consoleintr+0x70>
        switch (c) {
80100a88:	83 ff 10             	cmp    $0x10,%edi
80100a8b:	0f 84 e7 00 00 00    	je     80100b78 <consoleintr+0x118>
80100a91:	7e 5d                	jle    80100af0 <consoleintr+0x90>
80100a93:	83 ff 15             	cmp    $0x15,%edi
80100a96:	0f 84 ec 00 00 00    	je     80100b88 <consoleintr+0x128>
80100a9c:	83 ff 7f             	cmp    $0x7f,%edi
80100a9f:	75 54                	jne    80100af5 <consoleintr+0x95>
                if (input.e != input.w) {
80100aa1:	a1 88 27 11 80       	mov    0x80112788,%eax
80100aa6:	3b 05 84 27 11 80    	cmp    0x80112784,%eax
80100aac:	74 d2                	je     80100a80 <consoleintr+0x20>
                    input.e--;
80100aae:	83 e8 01             	sub    $0x1,%eax
80100ab1:	a3 88 27 11 80       	mov    %eax,0x80112788
                    consputc(BACKSPACE);
80100ab6:	b8 00 01 00 00       	mov    $0x100,%eax
80100abb:	e8 a0 fa ff ff       	call   80100560 <consputc>
    while ((c = getc()) >= 0) {
80100ac0:	ff d3                	call   *%ebx
80100ac2:	85 c0                	test   %eax,%eax
80100ac4:	89 c7                	mov    %eax,%edi
80100ac6:	79 c0                	jns    80100a88 <consoleintr+0x28>
80100ac8:	90                   	nop
80100ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&cons.lock);
80100ad0:	83 ec 0c             	sub    $0xc,%esp
80100ad3:	68 20 c5 10 80       	push   $0x8010c520
80100ad8:	e8 23 44 00 00       	call   80104f00 <release>
    if (doprocdump) {
80100add:	83 c4 10             	add    $0x10,%esp
80100ae0:	85 f6                	test   %esi,%esi
80100ae2:	0f 85 f8 00 00 00    	jne    80100be0 <consoleintr+0x180>
}
80100ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aeb:	5b                   	pop    %ebx
80100aec:	5e                   	pop    %esi
80100aed:	5f                   	pop    %edi
80100aee:	5d                   	pop    %ebp
80100aef:	c3                   	ret    
        switch (c) {
80100af0:	83 ff 08             	cmp    $0x8,%edi
80100af3:	74 ac                	je     80100aa1 <consoleintr+0x41>
                if (c != 0 && input.e - input.r < INPUT_BUF) {
80100af5:	85 ff                	test   %edi,%edi
80100af7:	74 87                	je     80100a80 <consoleintr+0x20>
80100af9:	a1 88 27 11 80       	mov    0x80112788,%eax
80100afe:	89 c2                	mov    %eax,%edx
80100b00:	2b 15 80 27 11 80    	sub    0x80112780,%edx
80100b06:	83 fa 7f             	cmp    $0x7f,%edx
80100b09:	0f 87 71 ff ff ff    	ja     80100a80 <consoleintr+0x20>
80100b0f:	8d 50 01             	lea    0x1(%eax),%edx
80100b12:	83 e0 7f             	and    $0x7f,%eax
                    c = (c == '\r') ? '\n' : c;
80100b15:	83 ff 0d             	cmp    $0xd,%edi
                    input.buf[input.e++ % INPUT_BUF] = c;
80100b18:	89 15 88 27 11 80    	mov    %edx,0x80112788
                    c = (c == '\r') ? '\n' : c;
80100b1e:	0f 84 cc 00 00 00    	je     80100bf0 <consoleintr+0x190>
                    input.buf[input.e++ % INPUT_BUF] = c;
80100b24:	89 f9                	mov    %edi,%ecx
80100b26:	88 88 00 27 11 80    	mov    %cl,-0x7feed900(%eax)
                    consputc(c);
80100b2c:	89 f8                	mov    %edi,%eax
80100b2e:	e8 2d fa ff ff       	call   80100560 <consputc>
                    if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF) {
80100b33:	83 ff 0a             	cmp    $0xa,%edi
80100b36:	0f 84 c5 00 00 00    	je     80100c01 <consoleintr+0x1a1>
80100b3c:	83 ff 04             	cmp    $0x4,%edi
80100b3f:	0f 84 bc 00 00 00    	je     80100c01 <consoleintr+0x1a1>
80100b45:	a1 80 27 11 80       	mov    0x80112780,%eax
80100b4a:	83 e8 80             	sub    $0xffffff80,%eax
80100b4d:	39 05 88 27 11 80    	cmp    %eax,0x80112788
80100b53:	0f 85 27 ff ff ff    	jne    80100a80 <consoleintr+0x20>
                        wakeup(&input.r);
80100b59:	83 ec 0c             	sub    $0xc,%esp
                        input.w = input.e;
80100b5c:	a3 84 27 11 80       	mov    %eax,0x80112784
                        wakeup(&input.r);
80100b61:	68 80 27 11 80       	push   $0x80112780
80100b66:	e8 c5 3e 00 00       	call   80104a30 <wakeup>
80100b6b:	83 c4 10             	add    $0x10,%esp
80100b6e:	e9 0d ff ff ff       	jmp    80100a80 <consoleintr+0x20>
80100b73:	90                   	nop
80100b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                doprocdump = 1;
80100b78:	be 01 00 00 00       	mov    $0x1,%esi
80100b7d:	e9 fe fe ff ff       	jmp    80100a80 <consoleintr+0x20>
80100b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                while (input.e != input.w &&
80100b88:	a1 88 27 11 80       	mov    0x80112788,%eax
80100b8d:	39 05 84 27 11 80    	cmp    %eax,0x80112784
80100b93:	75 2b                	jne    80100bc0 <consoleintr+0x160>
80100b95:	e9 e6 fe ff ff       	jmp    80100a80 <consoleintr+0x20>
80100b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                    input.e--;
80100ba0:	a3 88 27 11 80       	mov    %eax,0x80112788
                    consputc(BACKSPACE);
80100ba5:	b8 00 01 00 00       	mov    $0x100,%eax
80100baa:	e8 b1 f9 ff ff       	call   80100560 <consputc>
                while (input.e != input.w &&
80100baf:	a1 88 27 11 80       	mov    0x80112788,%eax
80100bb4:	3b 05 84 27 11 80    	cmp    0x80112784,%eax
80100bba:	0f 84 c0 fe ff ff    	je     80100a80 <consoleintr+0x20>
                       input.buf[(input.e - 1) % INPUT_BUF] != '\n') {
80100bc0:	83 e8 01             	sub    $0x1,%eax
80100bc3:	89 c2                	mov    %eax,%edx
80100bc5:	83 e2 7f             	and    $0x7f,%edx
                while (input.e != input.w &&
80100bc8:	80 ba 00 27 11 80 0a 	cmpb   $0xa,-0x7feed900(%edx)
80100bcf:	75 cf                	jne    80100ba0 <consoleintr+0x140>
80100bd1:	e9 aa fe ff ff       	jmp    80100a80 <consoleintr+0x20>
80100bd6:	8d 76 00             	lea    0x0(%esi),%esi
80100bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100be3:	5b                   	pop    %ebx
80100be4:	5e                   	pop    %esi
80100be5:	5f                   	pop    %edi
80100be6:	5d                   	pop    %ebp
        procdump();  // now call procdump() wo. cons.lock held
80100be7:	e9 24 3f 00 00       	jmp    80104b10 <procdump>
80100bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                    input.buf[input.e++ % INPUT_BUF] = c;
80100bf0:	c6 80 00 27 11 80 0a 	movb   $0xa,-0x7feed900(%eax)
                    consputc(c);
80100bf7:	b8 0a 00 00 00       	mov    $0xa,%eax
80100bfc:	e8 5f f9 ff ff       	call   80100560 <consputc>
80100c01:	a1 88 27 11 80       	mov    0x80112788,%eax
80100c06:	e9 4e ff ff ff       	jmp    80100b59 <consoleintr+0xf9>
80100c0b:	90                   	nop
80100c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100c10 <consoleinit>:
void consoleinit(void) {
80100c10:	55                   	push   %ebp
80100c11:	89 e5                	mov    %esp,%ebp
80100c13:	83 ec 10             	sub    $0x10,%esp
    initlock(&cons.lock, "console");
80100c16:	68 88 7b 10 80       	push   $0x80107b88
80100c1b:	68 20 c5 10 80       	push   $0x8010c520
80100c20:	e8 db 40 00 00       	call   80104d00 <initlock>
    ioapicenable(IRQ_KBD, 0);
80100c25:	58                   	pop    %eax
80100c26:	5a                   	pop    %edx
80100c27:	6a 00                	push   $0x0
80100c29:	6a 01                	push   $0x1
    devsw[CONSOLE].write = consolewrite;
80100c2b:	c7 05 4c 31 11 80 00 	movl   $0x80100800,0x8011314c
80100c32:	08 10 80 
    devsw[CONSOLE].read = consoleread;
80100c35:	c7 05 48 31 11 80 60 	movl   $0x80100360,0x80113148
80100c3c:	03 10 80 
    cons.locking = 1;
80100c3f:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
80100c46:	00 00 00 
    ioapicenable(IRQ_KBD, 0);
80100c49:	e8 52 21 00 00       	call   80102da0 <ioapicenable>
}
80100c4e:	83 c4 10             	add    $0x10,%esp
80100c51:	c9                   	leave  
80100c52:	c3                   	ret    
80100c53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100c60 <consolevgaplane>:
void consolevgaplane(uchar plane) {
80100c60:	55                   	push   %ebp
80100c61:	b8 04 00 00 00       	mov    $0x4,%eax
80100c66:	ba ce 03 00 00       	mov    $0x3ce,%edx
80100c6b:	89 e5                	mov    %esp,%ebp
    plane &= 3;
80100c6d:	0f b6 4d 08          	movzbl 0x8(%ebp),%ecx
80100c71:	83 e1 03             	and    $0x3,%ecx
80100c74:	ee                   	out    %al,(%dx)
80100c75:	ba cf 03 00 00       	mov    $0x3cf,%edx
80100c7a:	89 c8                	mov    %ecx,%eax
80100c7c:	ee                   	out    %al,(%dx)
80100c7d:	b8 02 00 00 00       	mov    $0x2,%eax
80100c82:	ba c4 03 00 00       	mov    $0x3c4,%edx
80100c87:	ee                   	out    %al,(%dx)
    planeMask = 1 << plane;
80100c88:	b8 01 00 00 00       	mov    $0x1,%eax
80100c8d:	ba c5 03 00 00       	mov    $0x3c5,%edx
80100c92:	d3 e0                	shl    %cl,%eax
80100c94:	ee                   	out    %al,(%dx)
}
80100c95:	5d                   	pop    %ebp
80100c96:	c3                   	ret    
80100c97:	89 f6                	mov    %esi,%esi
80100c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ca0 <snapshotWrite>:
{
80100ca0:	55                   	push   %ebp
80100ca1:	89 e5                	mov    %esp,%ebp
}
80100ca3:	5d                   	pop    %ebp
80100ca4:	c3                   	ret    
80100ca5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100cb0 <snapshotTextRestore>:
{
80100cb0:	55                   	push   %ebp
80100cb1:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
    for (i = 0; i < 2000; i++) //Loop through the entire register values in our snapshot
80100cb6:	31 c0                	xor    %eax,%eax
{
80100cb8:	89 e5                	mov    %esp,%ebp
80100cba:	56                   	push   %esi
80100cbb:	53                   	push   %ebx
80100cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        crt[i] = (consoleSnapshot.registerCopy[i] & 0xff) | 0x0700;
80100cc0:	0f b6 90 24 1f 11 80 	movzbl -0x7feee0dc(%eax),%edx
    for (i = 0; i < 2000; i++) //Loop through the entire register values in our snapshot
80100cc7:	83 c0 01             	add    $0x1,%eax
80100cca:	83 c1 02             	add    $0x2,%ecx
        crt[i] = (consoleSnapshot.registerCopy[i] & 0xff) | 0x0700;
80100ccd:	80 ce 07             	or     $0x7,%dh
80100cd0:	66 89 51 fe          	mov    %dx,-0x2(%ecx)
    for (i = 0; i < 2000; i++) //Loop through the entire register values in our snapshot
80100cd4:	3d d0 07 00 00       	cmp    $0x7d0,%eax
80100cd9:	75 e5                	jne    80100cc0 <snapshotTextRestore+0x10>
80100cdb:	be d4 03 00 00       	mov    $0x3d4,%esi
    int pos = consoleSnapshot.cursorPos;
80100ce0:	8b 0d 20 1f 11 80    	mov    0x80111f20,%ecx
80100ce6:	b8 0e 00 00 00       	mov    $0xe,%eax
80100ceb:	89 f2                	mov    %esi,%edx
80100ced:	ee                   	out    %al,(%dx)
80100cee:	bb d5 03 00 00       	mov    $0x3d5,%ebx
    outb(CRTPORT + 1, pos >> 8);
80100cf3:	89 c8                	mov    %ecx,%eax
80100cf5:	c1 f8 08             	sar    $0x8,%eax
80100cf8:	89 da                	mov    %ebx,%edx
80100cfa:	ee                   	out    %al,(%dx)
80100cfb:	b8 0f 00 00 00       	mov    $0xf,%eax
80100d00:	89 f2                	mov    %esi,%edx
80100d02:	ee                   	out    %al,(%dx)
80100d03:	89 c8                	mov    %ecx,%eax
80100d05:	89 da                	mov    %ebx,%edx
80100d07:	ee                   	out    %al,(%dx)
}
80100d08:	5b                   	pop    %ebx
80100d09:	5e                   	pop    %esi
80100d0a:	5d                   	pop    %ebp
80100d0b:	c3                   	ret    
80100d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d10 <snapshotTextTake>:
    if(currentvgamode==0x03) //Only take the snapshot if we are in 0x03
80100d10:	83 3d c0 a0 10 80 03 	cmpl   $0x3,0x8010a0c0
{
80100d17:	55                   	push   %ebp
80100d18:	89 e5                	mov    %esp,%ebp
    if(currentvgamode==0x03) //Only take the snapshot if we are in 0x03
80100d1a:	74 04                	je     80100d20 <snapshotTextTake+0x10>
}
80100d1c:	5d                   	pop    %ebp
80100d1d:	c3                   	ret    
80100d1e:	66 90                	xchg   %ax,%ax
80100d20:	5d                   	pop    %ebp
80100d21:	e9 5a f7 ff ff       	jmp    80100480 <snapshotTextTake.part.0>
80100d26:	8d 76 00             	lea    0x0(%esi),%esi
80100d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100d30 <writeFont>:
void writeFont(uchar * fontBuffer, unsigned int fontHeight) {
80100d30:	55                   	push   %ebp
80100d31:	b8 02 00 00 00       	mov    $0x2,%eax
80100d36:	ba c4 03 00 00       	mov    $0x3c4,%edx
80100d3b:	89 e5                	mov    %esp,%ebp
80100d3d:	57                   	push   %edi
80100d3e:	56                   	push   %esi
80100d3f:	53                   	push   %ebx
80100d40:	83 ec 1c             	sub    $0x1c,%esp
80100d43:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100d46:	8b 75 0c             	mov    0xc(%ebp),%esi
80100d49:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100d4a:	ba c5 03 00 00       	mov    $0x3c5,%edx
80100d4f:	ec                   	in     (%dx),%al
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100d50:	ba c4 03 00 00       	mov    $0x3c4,%edx
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100d55:	88 45 e7             	mov    %al,-0x19(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100d58:	b8 04 00 00 00       	mov    $0x4,%eax
80100d5d:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100d5e:	ba c5 03 00 00       	mov    $0x3c5,%edx
80100d63:	ec                   	in     (%dx),%al
    outb(VGA_SEQ_INDEX, 2);
    seq2 = inb(VGA_SEQ_DATA);

    outb(VGA_SEQ_INDEX, 4);
    seq4 = inb(VGA_SEQ_DATA);
    outb(VGA_SEQ_DATA, seq4 | 0x04);
80100d64:	89 c1                	mov    %eax,%ecx
80100d66:	88 45 e6             	mov    %al,-0x1a(%ebp)
80100d69:	83 c9 04             	or     $0x4,%ecx
80100d6c:	89 c8                	mov    %ecx,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100d6e:	ee                   	out    %al,(%dx)
80100d6f:	bf ce 03 00 00       	mov    $0x3ce,%edi
80100d74:	b8 04 00 00 00       	mov    $0x4,%eax
80100d79:	89 fa                	mov    %edi,%edx
80100d7b:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100d7c:	b9 cf 03 00 00       	mov    $0x3cf,%ecx
80100d81:	89 ca                	mov    %ecx,%edx
80100d83:	ec                   	in     (%dx),%al
80100d84:	88 45 e5             	mov    %al,-0x1b(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100d87:	89 fa                	mov    %edi,%edx
80100d89:	b8 05 00 00 00       	mov    $0x5,%eax
80100d8e:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100d8f:	89 ca                	mov    %ecx,%edx
80100d91:	ec                   	in     (%dx),%al
80100d92:	88 45 e4             	mov    %al,-0x1c(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100d95:	83 e0 ef             	and    $0xffffffef,%eax
80100d98:	ee                   	out    %al,(%dx)
80100d99:	b8 06 00 00 00       	mov    $0x6,%eax
80100d9e:	89 fa                	mov    %edi,%edx
80100da0:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100da1:	89 ca                	mov    %ecx,%edx
80100da3:	ec                   	in     (%dx),%al
80100da4:	88 45 e3             	mov    %al,-0x1d(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100da7:	83 e0 fd             	and    $0xfffffffd,%eax
80100daa:	ee                   	out    %al,(%dx)
80100dab:	b8 04 00 00 00       	mov    $0x4,%eax
80100db0:	89 fa                	mov    %edi,%edx
80100db2:	ee                   	out    %al,(%dx)
80100db3:	b8 02 00 00 00       	mov    $0x2,%eax
80100db8:	89 ca                	mov    %ecx,%edx
80100dba:	ee                   	out    %al,(%dx)
80100dbb:	ba c4 03 00 00       	mov    $0x3c4,%edx
80100dc0:	ee                   	out    %al,(%dx)
80100dc1:	b8 04 00 00 00       	mov    $0x4,%eax
80100dc6:	ba c5 03 00 00       	mov    $0x3c5,%edx
80100dcb:	ee                   	out    %al,(%dx)
    gc6 = inb(VGA_GC_DATA);
    outb(VGA_GC_DATA, gc6 & ~0x02);

    consolevgaplane(2);
    // Write font to video memory
    fontBase = (uchar*)P2V(0xB8000);
80100dcc:	bf 00 80 0b 80       	mov    $0x800b8000,%edi
80100dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < 256; i++)
    {
        memmove((ushort*)fontBase, fontBuffer, fontHeight);
80100dd8:	83 ec 04             	sub    $0x4,%esp
80100ddb:	56                   	push   %esi
80100ddc:	53                   	push   %ebx
        fontBase += 32;
        fontBuffer += fontHeight;
80100ddd:	01 f3                	add    %esi,%ebx
        memmove((ushort*)fontBase, fontBuffer, fontHeight);
80100ddf:	57                   	push   %edi
        fontBase += 32;
80100de0:	83 c7 20             	add    $0x20,%edi
        memmove((ushort*)fontBase, fontBuffer, fontHeight);
80100de3:	e8 18 42 00 00       	call   80105000 <memmove>
    for (i = 0; i < 256; i++)
80100de8:	83 c4 10             	add    $0x10,%esp
80100deb:	81 ff 00 a0 0b 80    	cmp    $0x800ba000,%edi
80100df1:	75 e5                	jne    80100dd8 <writeFont+0xa8>
80100df3:	be c4 03 00 00       	mov    $0x3c4,%esi
80100df8:	b8 02 00 00 00       	mov    $0x2,%eax
80100dfd:	89 f2                	mov    %esi,%edx
80100dff:	ee                   	out    %al,(%dx)
80100e00:	bb c5 03 00 00       	mov    $0x3c5,%ebx
80100e05:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80100e09:	89 da                	mov    %ebx,%edx
80100e0b:	ee                   	out    %al,(%dx)
80100e0c:	b9 04 00 00 00       	mov    $0x4,%ecx
80100e11:	89 f2                	mov    %esi,%edx
80100e13:	89 c8                	mov    %ecx,%eax
80100e15:	ee                   	out    %al,(%dx)
80100e16:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
80100e1a:	89 da                	mov    %ebx,%edx
80100e1c:	ee                   	out    %al,(%dx)
80100e1d:	bb ce 03 00 00       	mov    $0x3ce,%ebx
80100e22:	89 c8                	mov    %ecx,%eax
80100e24:	89 da                	mov    %ebx,%edx
80100e26:	ee                   	out    %al,(%dx)
80100e27:	b9 cf 03 00 00       	mov    $0x3cf,%ecx
80100e2c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
80100e30:	89 ca                	mov    %ecx,%edx
80100e32:	ee                   	out    %al,(%dx)
80100e33:	b8 05 00 00 00       	mov    $0x5,%eax
80100e38:	89 da                	mov    %ebx,%edx
80100e3a:	ee                   	out    %al,(%dx)
80100e3b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80100e3f:	89 ca                	mov    %ecx,%edx
80100e41:	ee                   	out    %al,(%dx)
80100e42:	b8 06 00 00 00       	mov    $0x6,%eax
80100e47:	89 da                	mov    %ebx,%edx
80100e49:	ee                   	out    %al,(%dx)
80100e4a:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
80100e4e:	89 ca                	mov    %ecx,%edx
80100e50:	ee                   	out    %al,(%dx)
    outb(VGA_GC_DATA, gc4);
    outb(VGA_GC_INDEX, 5);
    outb(VGA_GC_DATA, gc5);
    outb(VGA_GC_INDEX, 6);
    outb(VGA_GC_DATA, gc6);
}
80100e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e54:	5b                   	pop    %ebx
80100e55:	5e                   	pop    %esi
80100e56:	5f                   	pop    %edi
80100e57:	5d                   	pop    %ebp
80100e58:	c3                   	ret    
80100e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e60 <consolevgamode>:
 * Currently, only these modes are supported:
 *   0x03: 80x25 text mode.
 *   0x12: 640x480x16 graphics mode.
 *   0x13: 320x200x256 graphics mode.
 */
int consolevgamode(int vgamode) {
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	56                   	push   %esi
80100e64:	53                   	push   %ebx
80100e65:	8b 45 08             	mov    0x8(%ebp),%eax
    //acquire(&cons.lock);

    int errorcode = -1;

    switch (vgamode)
80100e68:	83 f8 12             	cmp    $0x12,%eax
80100e6b:	0f 84 cf 00 00 00    	je     80100f40 <consolevgamode+0xe0>
80100e71:	83 f8 13             	cmp    $0x13,%eax
80100e74:	0f 84 96 00 00 00    	je     80100f10 <consolevgamode+0xb0>
80100e7a:	83 f8 03             	cmp    $0x3,%eax
80100e7d:	74 0c                	je     80100e8b <consolevgamode+0x2b>
    }

    //release(&cons.lock);

    return errorcode;
}
80100e7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    int errorcode = -1;
80100e82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100e87:	5b                   	pop    %ebx
80100e88:	5e                   	pop    %esi
80100e89:	5d                   	pop    %ebp
80100e8a:	c3                   	ret    
            writeVideoRegisters(registers_80x25_text);
80100e8b:	b8 80 a0 10 80       	mov    $0x8010a080,%eax
80100e90:	e8 db f3 ff ff       	call   80100270 <writeVideoRegisters>
            writeFont(font_8x16, 16);
80100e95:	83 ec 08             	sub    $0x8,%esp
80100e98:	6a 10                	push   $0x10
80100e9a:	68 00 90 10 80       	push   $0x80109000
80100e9f:	e8 8c fe ff ff       	call   80100d30 <writeFont>
80100ea4:	83 c4 10             	add    $0x10,%esp
80100ea7:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
    for (i = 0; i < 2000; i++) //Loop through the entire register values in our snapshot
80100eac:	31 c0                	xor    %eax,%eax
80100eae:	66 90                	xchg   %ax,%ax
        crt[i] = (consoleSnapshot.registerCopy[i] & 0xff) | 0x0700;
80100eb0:	0f b6 90 24 1f 11 80 	movzbl -0x7feee0dc(%eax),%edx
    for (i = 0; i < 2000; i++) //Loop through the entire register values in our snapshot
80100eb7:	83 c0 01             	add    $0x1,%eax
80100eba:	83 c1 02             	add    $0x2,%ecx
        crt[i] = (consoleSnapshot.registerCopy[i] & 0xff) | 0x0700;
80100ebd:	80 ce 07             	or     $0x7,%dh
80100ec0:	66 89 51 fe          	mov    %dx,-0x2(%ecx)
    for (i = 0; i < 2000; i++) //Loop through the entire register values in our snapshot
80100ec4:	3d d0 07 00 00       	cmp    $0x7d0,%eax
80100ec9:	75 e5                	jne    80100eb0 <consolevgamode+0x50>
80100ecb:	be d4 03 00 00       	mov    $0x3d4,%esi
    int pos = consoleSnapshot.cursorPos;
80100ed0:	8b 0d 20 1f 11 80    	mov    0x80111f20,%ecx
80100ed6:	b8 0e 00 00 00       	mov    $0xe,%eax
80100edb:	89 f2                	mov    %esi,%edx
80100edd:	ee                   	out    %al,(%dx)
80100ede:	bb d5 03 00 00       	mov    $0x3d5,%ebx
    outb(CRTPORT + 1, pos >> 8);
80100ee3:	89 c8                	mov    %ecx,%eax
80100ee5:	c1 f8 08             	sar    $0x8,%eax
80100ee8:	89 da                	mov    %ebx,%edx
80100eea:	ee                   	out    %al,(%dx)
80100eeb:	b8 0f 00 00 00       	mov    $0xf,%eax
80100ef0:	89 f2                	mov    %esi,%edx
80100ef2:	ee                   	out    %al,(%dx)
80100ef3:	89 c8                	mov    %ecx,%eax
80100ef5:	89 da                	mov    %ebx,%edx
80100ef7:	ee                   	out    %al,(%dx)
            currentvgamode = 0x03;
80100ef8:	c7 05 c0 a0 10 80 03 	movl   $0x3,0x8010a0c0
80100eff:	00 00 00 
}
80100f02:	8d 65 f8             	lea    -0x8(%ebp),%esp
            errorcode = 0;
80100f05:	31 c0                	xor    %eax,%eax
}
80100f07:	5b                   	pop    %ebx
80100f08:	5e                   	pop    %esi
80100f09:	5d                   	pop    %ebp
80100f0a:	c3                   	ret    
80100f0b:	90                   	nop
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(currentvgamode==0x03) //Only take the snapshot if we are in 0x03
80100f10:	83 3d c0 a0 10 80 03 	cmpl   $0x3,0x8010a0c0
80100f17:	74 54                	je     80100f6d <consolevgamode+0x10d>
            writeVideoRegisters(registers_320x200x256);
80100f19:	b8 40 a0 10 80       	mov    $0x8010a040,%eax
80100f1e:	e8 4d f3 ff ff       	call   80100270 <writeVideoRegisters>
            currentvgamode = 0x13;
80100f23:	c7 05 c0 a0 10 80 13 	movl   $0x13,0x8010a0c0
80100f2a:	00 00 00 
}
80100f2d:	8d 65 f8             	lea    -0x8(%ebp),%esp
            errorcode = 0;
80100f30:	31 c0                	xor    %eax,%eax
}
80100f32:	5b                   	pop    %ebx
80100f33:	5e                   	pop    %esi
80100f34:	5d                   	pop    %ebp
80100f35:	c3                   	ret    
80100f36:	8d 76 00             	lea    0x0(%esi),%esi
80100f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(currentvgamode==0x03) //Only take the snapshot if we are in 0x03
80100f40:	83 3d c0 a0 10 80 03 	cmpl   $0x3,0x8010a0c0
80100f47:	74 1d                	je     80100f66 <consolevgamode+0x106>
            writeVideoRegisters(registers_640x480x16);
80100f49:	b8 00 a0 10 80       	mov    $0x8010a000,%eax
80100f4e:	e8 1d f3 ff ff       	call   80100270 <writeVideoRegisters>
            currentvgamode = 0x12;
80100f53:	c7 05 c0 a0 10 80 12 	movl   $0x12,0x8010a0c0
80100f5a:	00 00 00 
}
80100f5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
            errorcode = 0;
80100f60:	31 c0                	xor    %eax,%eax
}
80100f62:	5b                   	pop    %ebx
80100f63:	5e                   	pop    %esi
80100f64:	5d                   	pop    %ebp
80100f65:	c3                   	ret    
80100f66:	e8 15 f5 ff ff       	call   80100480 <snapshotTextTake.part.0>
80100f6b:	eb dc                	jmp    80100f49 <consolevgamode+0xe9>
80100f6d:	e8 0e f5 ff ff       	call   80100480 <snapshotTextTake.part.0>
80100f72:	eb a5                	jmp    80100f19 <consolevgamode+0xb9>
80100f74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100f7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100f80 <consolevgabuffer>:
 * http://www.osdever.net/FreeVGA/vga/vgamem.htm will give you more insight into what is going on.
 *
 * Returns a pointer to the virtual address (NOT the physical address) associated with the current
 * video plane.
 */
uchar* consolevgabuffer() {
80100f80:	55                   	push   %ebp
80100f81:	b8 06 00 00 00       	mov    $0x6,%eax
80100f86:	ba ce 03 00 00       	mov    $0x3ce,%edx
80100f8b:	89 e5                	mov    %esp,%ebp
80100f8d:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100f8e:	ba cf 03 00 00       	mov    $0x3cf,%edx
80100f93:	ec                   	in     (%dx),%al
80100f94:	89 c2                	mov    %eax,%edx
80100f96:	b8 00 00 0b 80       	mov    $0x800b0000,%eax
    uchar plane;

    outb(VGA_GC_INDEX, 6);

    plane = inb(VGA_GC_DATA);
    plane >>= 2;
80100f9b:	c0 ea 02             	shr    $0x2,%dl
    plane &= 3;
80100f9e:	83 e2 03             	and    $0x3,%edx

    switch (plane)
80100fa1:	80 fa 02             	cmp    $0x2,%dl
80100fa4:	74 10                	je     80100fb6 <consolevgabuffer+0x36>
    {
    case 0:
    case 1:
        base = (uchar*)P2V(0xA0000);
80100fa6:	80 fa 03             	cmp    $0x3,%dl
80100fa9:	b8 00 80 0b 80       	mov    $0x800b8000,%eax
80100fae:	ba 00 00 0a 80       	mov    $0x800a0000,%edx
80100fb3:	0f 45 c2             	cmovne %edx,%eax
        base = (uchar*)P2V(0xB8000);
        break;
    }

    return base;
}
80100fb6:	5d                   	pop    %ebp
80100fb7:	c3                   	ret    
80100fb8:	90                   	nop
80100fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fc0 <binaryStuff>:


//Function to find the binary value from an x_position - Used for setting pixels
int binaryStuff(int x_pos)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	8b 45 08             	mov    0x8(%ebp),%eax
    switch (x_pos % 8)
80100fc6:	89 c1                	mov    %eax,%ecx
80100fc8:	c1 f9 1f             	sar    $0x1f,%ecx
80100fcb:	c1 e9 1d             	shr    $0x1d,%ecx
80100fce:	8d 14 08             	lea    (%eax,%ecx,1),%edx
80100fd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fd6:	83 e2 07             	and    $0x7,%edx
80100fd9:	29 ca                	sub    %ecx,%edx
80100fdb:	83 fa 07             	cmp    $0x7,%edx
80100fde:	77 07                	ja     80100fe7 <binaryStuff+0x27>
80100fe0:	8b 04 95 a0 7b 10 80 	mov    -0x7fef8460(,%edx,4),%eax
            return 2;
        case 7: 
            return 1;
    }
    return -1;
}
80100fe7:	5d                   	pop    %ebp
80100fe8:	c3                   	ret    
80100fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <setpixel>:

//int pos_x, int pos_y, int VGA_COLOR
int setpixel(int pos_x, int pos_y, int VGA_COLOR)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 2c             	sub    $0x2c,%esp
   
    if (currentvgamode == 0x13)  // Memory location of pixel = A0000 + 320 * y + x
80100ff9:	8b 15 c0 a0 10 80    	mov    0x8010a0c0,%edx
{
80100fff:	8b 45 10             	mov    0x10(%ebp),%eax
    if (currentvgamode == 0x13)  // Memory location of pixel = A0000 + 320 * y + x
80101002:	83 fa 13             	cmp    $0x13,%edx
80101005:	0f 84 25 03 00 00    	je     80101330 <setpixel+0x340>
    {
        memset(VGA_0x13_MEMORY + VGA_0x13_WIDTH * pos_y + pos_x, VGA_COLOR, 1);
    }
    else if (currentvgamode == 0x12)  //640x480 (307200)
8010100b:	83 fa 12             	cmp    $0x12,%edx
8010100e:	74 10                	je     80101020 <setpixel+0x30>
    else // Don't draw anything if we aren't in a drawing mode
    { 
        return 0;
    }
    return 0;
}
80101010:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101013:	31 c0                	xor    %eax,%eax
80101015:	5b                   	pop    %ebx
80101016:	5e                   	pop    %esi
80101017:	5f                   	pop    %edi
80101018:	5d                   	pop    %ebp
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch (x_pos % 8)
80101020:	8b 4d 08             	mov    0x8(%ebp),%ecx
80101023:	8b 55 08             	mov    0x8(%ebp),%edx
80101026:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010102b:	c1 f9 1f             	sar    $0x1f,%ecx
8010102e:	c1 e9 1d             	shr    $0x1d,%ecx
80101031:	01 ca                	add    %ecx,%edx
80101033:	83 e2 07             	and    $0x7,%edx
80101036:	29 ca                	sub    %ecx,%edx
80101038:	83 fa 07             	cmp    $0x7,%edx
8010103b:	0f 86 17 02 00 00    	jbe    80101258 <setpixel+0x268>
        if ((colourAsInt-8) >= 0)
80101041:	83 f8 07             	cmp    $0x7,%eax
        bool BIT3 = false, BIT2 = false, BIT1 = false, BIT0 = false;
80101044:	c6 45 d6 00          	movb   $0x0,-0x2a(%ebp)
        if ((colourAsInt-8) >= 0)
80101048:	7e 07                	jle    80101051 <setpixel+0x61>
            colourAsInt -= 8;
8010104a:	83 e8 08             	sub    $0x8,%eax
            BIT0 = true;//Plane 0; // Set Least significant bit
8010104d:	c6 45 d6 01          	movb   $0x1,-0x2a(%ebp)
        if ((colourAsInt-4) >= 0)
80101051:	83 f8 03             	cmp    $0x3,%eax
        bool BIT3 = false, BIT2 = false, BIT1 = false, BIT0 = false;
80101054:	c6 45 d7 00          	movb   $0x0,-0x29(%ebp)
        if ((colourAsInt-4) >= 0)
80101058:	7e 07                	jle    80101061 <setpixel+0x71>
            colourAsInt -= 4;
8010105a:	83 e8 04             	sub    $0x4,%eax
            BIT1 = true;// Plane 1;
8010105d:	c6 45 d7 01          	movb   $0x1,-0x29(%ebp)
        if ((colourAsInt-2) >= 0)
80101061:	83 f8 01             	cmp    $0x1,%eax
80101064:	0f 8e 0e 02 00 00    	jle    80101278 <setpixel+0x288>
8010106a:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010106d:	8d 14 bf             	lea    (%edi,%edi,4),%edx
80101070:	8d 7d e4             	lea    -0x1c(%ebp),%edi
80101073:	c1 e2 07             	shl    $0x7,%edx
80101076:	03 55 08             	add    0x8(%ebp),%edx
80101079:	8d 4a 07             	lea    0x7(%edx),%ecx
8010107c:	85 d2                	test   %edx,%edx
8010107e:	0f 48 d1             	cmovs  %ecx,%edx
80101081:	c1 fa 03             	sar    $0x3,%edx
        if ((colourAsInt-1) >= 0)
80101084:	83 f8 02             	cmp    $0x2,%eax
80101087:	89 55 d0             	mov    %edx,-0x30(%ebp)
8010108a:	0f 85 d0 02 00 00    	jne    80101360 <setpixel+0x370>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80101090:	be ce 03 00 00       	mov    $0x3ce,%esi
80101095:	b8 04 00 00 00       	mov    $0x4,%eax
8010109a:	89 f2                	mov    %esi,%edx
8010109c:	ee                   	out    %al,(%dx)
8010109d:	b9 cf 03 00 00       	mov    $0x3cf,%ecx
801010a2:	b8 01 00 00 00       	mov    $0x1,%eax
801010a7:	89 ca                	mov    %ecx,%edx
801010a9:	ee                   	out    %al,(%dx)
801010aa:	b8 02 00 00 00       	mov    $0x2,%eax
801010af:	ba c4 03 00 00       	mov    $0x3c4,%edx
801010b4:	ee                   	out    %al,(%dx)
801010b5:	ba c5 03 00 00       	mov    $0x3c5,%edx
801010ba:	ee                   	out    %al,(%dx)
801010bb:	b8 06 00 00 00       	mov    $0x6,%eax
801010c0:	89 f2                	mov    %esi,%edx
801010c2:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801010c3:	89 ca                	mov    %ecx,%edx
801010c5:	ec                   	in     (%dx),%al
    plane >>= 2;
801010c6:	c0 e8 02             	shr    $0x2,%al
        base = (uchar*)P2V(0xB0000);
801010c9:	be 00 00 0b 80       	mov    $0x800b0000,%esi
    plane &= 3;
801010ce:	83 e0 03             	and    $0x3,%eax
    switch (plane)
801010d1:	3c 02                	cmp    $0x2,%al
801010d3:	74 0f                	je     801010e4 <setpixel+0xf4>
        base = (uchar*)P2V(0xA0000);
801010d5:	3c 03                	cmp    $0x3,%al
801010d7:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801010dc:	b8 00 00 0a 80       	mov    $0x800a0000,%eax
801010e1:	0f 45 f0             	cmovne %eax,%esi
            targetByte = memoryPointer + ((640 * pos_y + pos_x) /8);
801010e4:	03 75 d0             	add    -0x30(%ebp),%esi
            memmove(ptrByteFromMemory, targetByte, 8);
801010e7:	83 ec 04             	sub    $0x4,%esp
801010ea:	6a 08                	push   $0x8
801010ec:	56                   	push   %esi
801010ed:	57                   	push   %edi
801010ee:	e8 0d 3f 00 00       	call   80105000 <memmove>
            byteFromMemory += BitAddition;
801010f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
            memset(targetByte, byteFromMemory, 1);
801010f6:	83 c4 0c             	add    $0xc,%esp
801010f9:	6a 01                	push   $0x1
            byteFromMemory += BitAddition;
801010fb:	01 d8                	add    %ebx,%eax
            memset(targetByte, byteFromMemory, 1);
801010fd:	50                   	push   %eax
801010fe:	56                   	push   %esi
            byteFromMemory += BitAddition;
801010ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            memset(targetByte, byteFromMemory, 1);
80101102:	e8 49 3e 00 00       	call   80104f50 <memset>
80101107:	83 c4 10             	add    $0x10,%esp
        if (BIT1)
8010110a:	80 7d d7 00          	cmpb   $0x0,-0x29(%ebp)
8010110e:	0f 84 95 00 00 00    	je     801011a9 <setpixel+0x1b9>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80101114:	bf 04 00 00 00       	mov    $0x4,%edi
80101119:	be ce 03 00 00       	mov    $0x3ce,%esi
8010111e:	89 f8                	mov    %edi,%eax
80101120:	89 f2                	mov    %esi,%edx
80101122:	ee                   	out    %al,(%dx)
80101123:	b9 cf 03 00 00       	mov    $0x3cf,%ecx
80101128:	b8 02 00 00 00       	mov    $0x2,%eax
8010112d:	89 ca                	mov    %ecx,%edx
8010112f:	ee                   	out    %al,(%dx)
80101130:	ba c4 03 00 00       	mov    $0x3c4,%edx
80101135:	ee                   	out    %al,(%dx)
80101136:	ba c5 03 00 00       	mov    $0x3c5,%edx
8010113b:	89 f8                	mov    %edi,%eax
8010113d:	ee                   	out    %al,(%dx)
8010113e:	b8 06 00 00 00       	mov    $0x6,%eax
80101143:	89 f2                	mov    %esi,%edx
80101145:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80101146:	89 ca                	mov    %ecx,%edx
80101148:	ec                   	in     (%dx),%al
    plane >>= 2;
80101149:	c0 e8 02             	shr    $0x2,%al
        base = (uchar*)P2V(0xB0000);
8010114c:	ba 00 00 0b 80       	mov    $0x800b0000,%edx
    plane &= 3;
80101151:	83 e0 03             	and    $0x3,%eax
    switch (plane)
80101154:	3c 02                	cmp    $0x2,%al
80101156:	74 11                	je     80101169 <setpixel+0x179>
        base = (uchar*)P2V(0xA0000);
80101158:	3c 03                	cmp    $0x3,%al
8010115a:	be 00 80 0b 80       	mov    $0x800b8000,%esi
8010115f:	b8 00 00 0a 80       	mov    $0x800a0000,%eax
80101164:	0f 44 c6             	cmove  %esi,%eax
80101167:	89 c2                	mov    %eax,%edx
            targetByte = memoryPointer + ((640 * pos_y + pos_x) /8);
80101169:	8b 45 0c             	mov    0xc(%ebp),%eax
8010116c:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010116f:	c1 e0 07             	shl    $0x7,%eax
80101172:	03 45 08             	add    0x8(%ebp),%eax
80101175:	8d 70 07             	lea    0x7(%eax),%esi
80101178:	85 c0                	test   %eax,%eax
8010117a:	0f 48 c6             	cmovs  %esi,%eax
            memmove(ptrByteFromMemory, targetByte, 8);
8010117d:	83 ec 04             	sub    $0x4,%esp
            targetByte = memoryPointer + ((640 * pos_y + pos_x) /8);
80101180:	c1 f8 03             	sar    $0x3,%eax
            memmove(ptrByteFromMemory, targetByte, 8);
80101183:	6a 08                	push   $0x8
            targetByte = memoryPointer + ((640 * pos_y + pos_x) /8);
80101185:	8d 34 02             	lea    (%edx,%eax,1),%esi
            memmove(ptrByteFromMemory, targetByte, 8);
80101188:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010118b:	56                   	push   %esi
8010118c:	50                   	push   %eax
8010118d:	e8 6e 3e 00 00       	call   80105000 <memmove>
            byteFromMemory += BitAddition;
80101192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
            memset(targetByte, byteFromMemory, 1);
80101195:	83 c4 0c             	add    $0xc,%esp
80101198:	6a 01                	push   $0x1
            byteFromMemory += BitAddition;
8010119a:	01 d8                	add    %ebx,%eax
            memset(targetByte, byteFromMemory, 1);
8010119c:	50                   	push   %eax
8010119d:	56                   	push   %esi
            byteFromMemory += BitAddition;
8010119e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            memset(targetByte, byteFromMemory, 1);
801011a1:	e8 aa 3d 00 00       	call   80104f50 <memset>
801011a6:	83 c4 10             	add    $0x10,%esp
        if (BIT0)
801011a9:	80 7d d6 00          	cmpb   $0x0,-0x2a(%ebp)
801011ad:	0f 84 5d fe ff ff    	je     80101010 <setpixel+0x20>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801011b3:	be ce 03 00 00       	mov    $0x3ce,%esi
801011b8:	b8 04 00 00 00       	mov    $0x4,%eax
801011bd:	89 f2                	mov    %esi,%edx
801011bf:	ee                   	out    %al,(%dx)
801011c0:	b9 cf 03 00 00       	mov    $0x3cf,%ecx
801011c5:	b8 03 00 00 00       	mov    $0x3,%eax
801011ca:	89 ca                	mov    %ecx,%edx
801011cc:	ee                   	out    %al,(%dx)
801011cd:	b8 02 00 00 00       	mov    $0x2,%eax
801011d2:	ba c4 03 00 00       	mov    $0x3c4,%edx
801011d7:	ee                   	out    %al,(%dx)
801011d8:	b8 08 00 00 00       	mov    $0x8,%eax
801011dd:	ba c5 03 00 00       	mov    $0x3c5,%edx
801011e2:	ee                   	out    %al,(%dx)
801011e3:	b8 06 00 00 00       	mov    $0x6,%eax
801011e8:	89 f2                	mov    %esi,%edx
801011ea:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801011eb:	89 ca                	mov    %ecx,%edx
801011ed:	ec                   	in     (%dx),%al
    plane >>= 2;
801011ee:	c0 e8 02             	shr    $0x2,%al
        base = (uchar*)P2V(0xB0000);
801011f1:	ba 00 00 0b 80       	mov    $0x800b0000,%edx
    plane &= 3;
801011f6:	83 e0 03             	and    $0x3,%eax
    switch (plane)
801011f9:	3c 02                	cmp    $0x2,%al
801011fb:	74 0f                	je     8010120c <setpixel+0x21c>
        base = (uchar*)P2V(0xA0000);
801011fd:	3c 03                	cmp    $0x3,%al
801011ff:	ba 00 80 0b 80       	mov    $0x800b8000,%edx
80101204:	b8 00 00 0a 80       	mov    $0x800a0000,%eax
80101209:	0f 45 d0             	cmovne %eax,%edx
            targetByte = memoryPointer  + ((640 * pos_y + pos_x) /8);
8010120c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010120f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80101212:	c1 e0 07             	shl    $0x7,%eax
80101215:	03 45 08             	add    0x8(%ebp),%eax
80101218:	8d 48 07             	lea    0x7(%eax),%ecx
8010121b:	85 c0                	test   %eax,%eax
8010121d:	0f 48 c1             	cmovs  %ecx,%eax
            memmove(ptrByteFromMemory, targetByte, 8);
80101220:	83 ec 04             	sub    $0x4,%esp
            targetByte = memoryPointer  + ((640 * pos_y + pos_x) /8);
80101223:	c1 f8 03             	sar    $0x3,%eax
            memmove(ptrByteFromMemory, targetByte, 8);
80101226:	6a 08                	push   $0x8
            targetByte = memoryPointer  + ((640 * pos_y + pos_x) /8);
80101228:	8d 34 02             	lea    (%edx,%eax,1),%esi
            memmove(ptrByteFromMemory, targetByte, 8);
8010122b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010122e:	56                   	push   %esi
8010122f:	50                   	push   %eax
80101230:	e8 cb 3d 00 00       	call   80105000 <memmove>
            byteFromMemory += BitAddition;
80101235:	03 5d e4             	add    -0x1c(%ebp),%ebx
            memset(targetByte, byteFromMemory, 1);
80101238:	83 c4 0c             	add    $0xc,%esp
8010123b:	6a 01                	push   $0x1
8010123d:	53                   	push   %ebx
8010123e:	56                   	push   %esi
            byteFromMemory += BitAddition;
8010123f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
            memset(targetByte, byteFromMemory, 1);
80101242:	e8 09 3d 00 00       	call   80104f50 <memset>
80101247:	83 c4 10             	add    $0x10,%esp
}
8010124a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010124d:	31 c0                	xor    %eax,%eax
8010124f:	5b                   	pop    %ebx
80101250:	5e                   	pop    %esi
80101251:	5f                   	pop    %edi
80101252:	5d                   	pop    %ebp
80101253:	c3                   	ret    
80101254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if ((colourAsInt-8) >= 0)
80101258:	83 f8 07             	cmp    $0x7,%eax
8010125b:	8b 1c 95 a0 7b 10 80 	mov    -0x7fef8460(,%edx,4),%ebx
        bool BIT3 = false, BIT2 = false, BIT1 = false, BIT0 = false;
80101262:	c6 45 d6 00          	movb   $0x0,-0x2a(%ebp)
        if ((colourAsInt-8) >= 0)
80101266:	0f 8e e5 fd ff ff    	jle    80101051 <setpixel+0x61>
8010126c:	e9 d9 fd ff ff       	jmp    8010104a <setpixel+0x5a>
80101271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if ((colourAsInt-1) >= 0)
80101278:	0f 85 8c fe ff ff    	jne    8010110a <setpixel+0x11a>
8010127e:	8b 45 0c             	mov    0xc(%ebp),%eax
        bool BIT3 = false, BIT2 = false, BIT1 = false, BIT0 = false;
80101281:	c6 45 d5 00          	movb   $0x0,-0x2b(%ebp)
80101285:	8d 04 80             	lea    (%eax,%eax,4),%eax
80101288:	c1 e0 07             	shl    $0x7,%eax
8010128b:	03 45 08             	add    0x8(%ebp),%eax
8010128e:	8d 50 07             	lea    0x7(%eax),%edx
80101291:	85 c0                	test   %eax,%eax
80101293:	0f 48 c2             	cmovs  %edx,%eax
80101296:	c1 f8 03             	sar    $0x3,%eax
80101299:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
8010129c:	bf ce 03 00 00       	mov    $0x3ce,%edi
801012a1:	b8 04 00 00 00       	mov    $0x4,%eax
801012a6:	89 fa                	mov    %edi,%edx
801012a8:	ee                   	out    %al,(%dx)
801012a9:	b9 cf 03 00 00       	mov    $0x3cf,%ecx
801012ae:	31 c0                	xor    %eax,%eax
801012b0:	89 ca                	mov    %ecx,%edx
801012b2:	ee                   	out    %al,(%dx)
801012b3:	b8 02 00 00 00       	mov    $0x2,%eax
801012b8:	ba c4 03 00 00       	mov    $0x3c4,%edx
801012bd:	ee                   	out    %al,(%dx)
801012be:	b8 01 00 00 00       	mov    $0x1,%eax
801012c3:	ba c5 03 00 00       	mov    $0x3c5,%edx
801012c8:	ee                   	out    %al,(%dx)
801012c9:	b8 06 00 00 00       	mov    $0x6,%eax
801012ce:	89 fa                	mov    %edi,%edx
801012d0:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801012d1:	89 ca                	mov    %ecx,%edx
801012d3:	ec                   	in     (%dx),%al
    plane >>= 2;
801012d4:	c0 e8 02             	shr    $0x2,%al
        base = (uchar*)P2V(0xB0000);
801012d7:	ba 00 00 0b 80       	mov    $0x800b0000,%edx
    plane &= 3;
801012dc:	83 e0 03             	and    $0x3,%eax
    switch (plane)
801012df:	3c 02                	cmp    $0x2,%al
801012e1:	74 0f                	je     801012f2 <setpixel+0x302>
        base = (uchar*)P2V(0xA0000);
801012e3:	3c 03                	cmp    $0x3,%al
801012e5:	ba 00 80 0b 80       	mov    $0x800b8000,%edx
801012ea:	b8 00 00 0a 80       	mov    $0x800a0000,%eax
801012ef:	0f 45 d0             	cmovne %eax,%edx
            targetByte = memoryPointer + (640 * pos_y + pos_x) /8;
801012f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
            memmove(ptrByteFromMemory, targetByte, 8);
801012f5:	8d 7d e4             	lea    -0x1c(%ebp),%edi
801012f8:	83 ec 04             	sub    $0x4,%esp
801012fb:	6a 08                	push   $0x8
            targetByte = memoryPointer + (640 * pos_y + pos_x) /8;
801012fd:	8d 34 02             	lea    (%edx,%eax,1),%esi
            memmove(ptrByteFromMemory, targetByte, 8);
80101300:	56                   	push   %esi
80101301:	57                   	push   %edi
80101302:	e8 f9 3c 00 00       	call   80105000 <memmove>
            byteFromMemory += BitAddition;
80101307:	8b 45 e4             	mov    -0x1c(%ebp),%eax
            memset(targetByte, byteFromMemory, 1);
8010130a:	83 c4 0c             	add    $0xc,%esp
8010130d:	6a 01                	push   $0x1
            byteFromMemory += BitAddition;
8010130f:	01 d8                	add    %ebx,%eax
            memset(targetByte, byteFromMemory, 1);
80101311:	50                   	push   %eax
80101312:	56                   	push   %esi
            byteFromMemory += BitAddition;
80101313:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            memset(targetByte, byteFromMemory, 1);
80101316:	e8 35 3c 00 00       	call   80104f50 <memset>
        if (BIT2)
8010131b:	83 c4 10             	add    $0x10,%esp
8010131e:	80 7d d5 00          	cmpb   $0x0,-0x2b(%ebp)
80101322:	0f 84 e2 fd ff ff    	je     8010110a <setpixel+0x11a>
80101328:	e9 63 fd ff ff       	jmp    80101090 <setpixel+0xa0>
8010132d:	8d 76 00             	lea    0x0(%esi),%esi
        memset(VGA_0x13_MEMORY + VGA_0x13_WIDTH * pos_y + pos_x, VGA_COLOR, 1);
80101330:	83 ec 04             	sub    $0x4,%esp
80101333:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101336:	6a 01                	push   $0x1
80101338:	50                   	push   %eax
80101339:	8b 45 0c             	mov    0xc(%ebp),%eax
8010133c:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010133f:	c1 e0 06             	shl    $0x6,%eax
80101342:	8d 84 03 00 00 0a 80 	lea    -0x7ff60000(%ebx,%eax,1),%eax
80101349:	50                   	push   %eax
8010134a:	e8 01 3c 00 00       	call   80104f50 <memset>
8010134f:	83 c4 10             	add    $0x10,%esp
}
80101352:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101355:	31 c0                	xor    %eax,%eax
80101357:	5b                   	pop    %ebx
80101358:	5e                   	pop    %esi
80101359:	5f                   	pop    %edi
8010135a:	5d                   	pop    %ebp
8010135b:	c3                   	ret    
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            BIT2 = true;//Plane 2;
80101360:	c6 45 d5 01          	movb   $0x1,-0x2b(%ebp)
80101364:	e9 33 ff ff ff       	jmp    8010129c <setpixel+0x2ac>
80101369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101370 <zeroFillScreen13h>:

//Set the screen to black if we are in 13h
void zeroFillScreen13h()
{
80101370:	55                   	push   %ebp
80101371:	b8 00 00 0a 80       	mov    $0x800a0000,%eax
80101376:	89 e5                	mov    %esp,%ebp
80101378:	90                   	nop
80101379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ushort* memoryPointer = VGA_0x13_MEMORY;


    for (i = 0; i < 64000; i++) //Loop through the entire register
    {
        memoryPointer[i] = (0);
80101380:	31 d2                	xor    %edx,%edx
80101382:	83 c0 02             	add    $0x2,%eax
80101385:	66 89 50 fe          	mov    %dx,-0x2(%eax)
    for (i = 0; i < 64000; i++) //Loop through the entire register
80101389:	3d 00 f4 0b 80       	cmp    $0x800bf400,%eax
8010138e:	75 f0                	jne    80101380 <zeroFillScreen13h+0x10>
    }
    
}
80101390:	5d                   	pop    %ebp
80101391:	c3                   	ret    
80101392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013a0 <zeroFillScreen12h>:


//Set the screen to black if we are in 12h.
void zeroFillScreen12h()
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	56                   	push   %esi
801013a5:	53                   	push   %ebx
801013a6:	83 ec 1c             	sub    $0x1c,%esp
    unsigned int pos_X, pos_Y;
    unsigned int planeNo;
    uchar* memoryPointer;


    for (planeNo = 0; planeNo < 4; planeNo++)
801013a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801013b0:	b8 04 00 00 00       	mov    $0x4,%eax
801013b5:	ba ce 03 00 00       	mov    $0x3ce,%edx
801013ba:	ee                   	out    %al,(%dx)
801013bb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801013be:	bb cf 03 00 00       	mov    $0x3cf,%ebx
801013c3:	89 da                	mov    %ebx,%edx
801013c5:	89 c8                	mov    %ecx,%eax
801013c7:	ee                   	out    %al,(%dx)
801013c8:	b8 02 00 00 00       	mov    $0x2,%eax
801013cd:	ba c4 03 00 00       	mov    $0x3c4,%edx
801013d2:	ee                   	out    %al,(%dx)
    planeMask = 1 << plane;
801013d3:	b8 01 00 00 00       	mov    $0x1,%eax
801013d8:	ba c5 03 00 00       	mov    $0x3c5,%edx
801013dd:	d3 e0                	shl    %cl,%eax
801013df:	ee                   	out    %al,(%dx)
801013e0:	b8 06 00 00 00       	mov    $0x6,%eax
801013e5:	ba ce 03 00 00       	mov    $0x3ce,%edx
801013ea:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801013eb:	89 da                	mov    %ebx,%edx
801013ed:	ec                   	in     (%dx),%al
    plane >>= 2;
801013ee:	c0 e8 02             	shr    $0x2,%al
        base = (uchar*)P2V(0xB0000);
801013f1:	be 00 00 0b 80       	mov    $0x800b0000,%esi
    plane &= 3;
801013f6:	83 e0 03             	and    $0x3,%eax
    switch (plane)
801013f9:	3c 02                	cmp    $0x2,%al
801013fb:	74 0f                	je     8010140c <zeroFillScreen12h+0x6c>
        base = (uchar*)P2V(0xA0000);
801013fd:	3c 03                	cmp    $0x3,%al
801013ff:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80101404:	b8 00 00 0a 80       	mov    $0x800a0000,%eax
80101409:	0f 45 f0             	cmovne %eax,%esi
8010140c:	8d 86 80 02 00 00    	lea    0x280(%esi),%eax
80101412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101415:	8d 76 00             	lea    0x0(%esi),%esi
80101418:	8d 9e 00 b0 04 00    	lea    0x4b000(%esi),%ebx
        base = (uchar*)P2V(0xB0000);
8010141e:	89 f7                	mov    %esi,%edi

            for (pos_Y = 0; pos_Y < 480; pos_Y++) //480 - Loop through every Y value on each row
            {


                memset(memoryPointer + (640) * pos_Y +pos_X, 0, 1); //pass in 255 (0xFF) to fill the entire byte
80101420:	83 ec 04             	sub    $0x4,%esp
80101423:	6a 01                	push   $0x1
80101425:	6a 00                	push   $0x0
80101427:	57                   	push   %edi
80101428:	81 c7 80 02 00 00    	add    $0x280,%edi
8010142e:	e8 1d 3b 00 00       	call   80104f50 <memset>
            for (pos_Y = 0; pos_Y < 480; pos_Y++) //480 - Loop through every Y value on each row
80101433:	83 c4 10             	add    $0x10,%esp
80101436:	39 fb                	cmp    %edi,%ebx
80101438:	75 e6                	jne    80101420 <zeroFillScreen12h+0x80>
8010143a:	83 c6 01             	add    $0x1,%esi
        for (pos_X = 0; pos_X < 640; pos_X++) // 640 - Loop through every x value
8010143d:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
80101440:	75 d6                	jne    80101418 <zeroFillScreen12h+0x78>
    for (planeNo = 0; planeNo < 4; planeNo++)
80101442:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80101446:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101449:	83 f8 04             	cmp    $0x4,%eax
8010144c:	0f 85 5e ff ff ff    	jne    801013b0 <zeroFillScreen12h+0x10>


            }
        }
    }
}
80101452:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101455:	5b                   	pop    %ebx
80101456:	5e                   	pop    %esi
80101457:	5f                   	pop    %edi
80101458:	5d                   	pop    %ebp
80101459:	c3                   	ret    
8010145a:	66 90                	xchg   %ax,%ax
8010145c:	66 90                	xchg   %ax,%ax
8010145e:	66 90                	xchg   %ax,%ax

80101460 <cleanupexec>:
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

void cleanupexec(pde_t * pgdir, struct inode *ip) {
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	53                   	push   %ebx
80101464:	83 ec 04             	sub    $0x4,%esp
80101467:	8b 45 08             	mov    0x8(%ebp),%eax
8010146a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (pgdir) {
8010146d:	85 c0                	test   %eax,%eax
8010146f:	74 0c                	je     8010147d <cleanupexec+0x1d>
        freevm(pgdir);
80101471:	83 ec 0c             	sub    $0xc,%esp
80101474:	50                   	push   %eax
80101475:	e8 66 63 00 00       	call   801077e0 <freevm>
8010147a:	83 c4 10             	add    $0x10,%esp
    }
    if (ip) {
8010147d:	85 db                	test   %ebx,%ebx
8010147f:	74 1f                	je     801014a0 <cleanupexec+0x40>
        iunlockput(ip);
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	53                   	push   %ebx
80101485:	e8 56 0f 00 00       	call   801023e0 <iunlockput>
        end_op();
8010148a:	83 c4 10             	add    $0x10,%esp
    }    
}
8010148d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101490:	c9                   	leave  
        end_op();
80101491:	e9 4a 22 00 00       	jmp    801036e0 <end_op>
80101496:	8d 76 00             	lea    0x0(%esi),%esi
80101499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
801014a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014a3:	c9                   	leave  
801014a4:	c3                   	ret    
801014a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014b0 <exec>:

int exec(char *path, char **argv) {
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	57                   	push   %edi
801014b4:	56                   	push   %esi
801014b5:	53                   	push   %ebx
801014b6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
    uint argc, sz, sp, ustack[3 + MAXARG + 1];
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pde_t *pgdir, *oldpgdir;
    struct proc *curproc = myproc();
801014bc:	e8 1f 2e 00 00       	call   801042e0 <myproc>
801014c1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

    begin_op();
801014c7:	e8 a4 21 00 00       	call   80103670 <begin_op>

    if ((ip = namei(path)) == 0) {
801014cc:	83 ec 0c             	sub    $0xc,%esp
801014cf:	ff 75 08             	pushl  0x8(%ebp)
801014d2:	e8 d9 14 00 00       	call   801029b0 <namei>
801014d7:	83 c4 10             	add    $0x10,%esp
801014da:	85 c0                	test   %eax,%eax
801014dc:	0f 84 2e 03 00 00    	je     80101810 <exec+0x360>
        end_op();
        cprintf("exec: fail\n");
        return -1;
    }
    ilock(ip);
801014e2:	83 ec 0c             	sub    $0xc,%esp
801014e5:	89 c6                	mov    %eax,%esi
801014e7:	50                   	push   %eax
801014e8:	e8 63 0c 00 00       	call   80102150 <ilock>
    pgdir = 0;

    // Check ELF header
    if (readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf)) {
801014ed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801014f3:	6a 34                	push   $0x34
801014f5:	6a 00                	push   $0x0
801014f7:	50                   	push   %eax
801014f8:	56                   	push   %esi
801014f9:	e8 32 0f 00 00       	call   80102430 <readi>
801014fe:	83 c4 20             	add    $0x20,%esp
80101501:	83 f8 34             	cmp    $0x34,%eax
80101504:	0f 85 c0 02 00 00    	jne    801017ca <exec+0x31a>
        cleanupexec(pgdir, ip);
        return -1;
    }
    if (elf.magic != ELF_MAGIC) {
8010150a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101511:	45 4c 46 
80101514:	0f 85 b0 02 00 00    	jne    801017ca <exec+0x31a>
        cleanupexec(pgdir, ip);
        return -1;        
    }

    if ((pgdir = setupkvm()) == 0) {
8010151a:	e8 41 63 00 00       	call   80107860 <setupkvm>
8010151f:	85 c0                	test   %eax,%eax
80101521:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101527:	0f 84 9d 02 00 00    	je     801017ca <exec+0x31a>
        cleanupexec(pgdir, ip);
        return -1;    
    }

    // Load program into memory.
    sz = 0;
8010152d:	31 ff                	xor    %edi,%edi
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
8010152f:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101536:	00 
80101537:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
8010153d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101543:	0f 84 99 02 00 00    	je     801017e2 <exec+0x332>
80101549:	31 db                	xor    %ebx,%ebx
8010154b:	eb 7d                	jmp    801015ca <exec+0x11a>
8010154d:	8d 76 00             	lea    0x0(%esi),%esi
        if (readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph)) {
            cleanupexec(pgdir, ip);
            return -1;    
        }
        if (ph.type != ELF_PROG_LOAD) {
80101550:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101557:	75 63                	jne    801015bc <exec+0x10c>
            continue;
        }
        if (ph.memsz < ph.filesz) {
80101559:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
8010155f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101565:	0f 82 86 00 00 00    	jb     801015f1 <exec+0x141>
8010156b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101571:	72 7e                	jb     801015f1 <exec+0x141>
        }
        if (ph.vaddr + ph.memsz < ph.vaddr) {
            cleanupexec(pgdir, ip);
            return -1;    
        }
        if ((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0) {
80101573:	83 ec 04             	sub    $0x4,%esp
80101576:	50                   	push   %eax
80101577:	57                   	push   %edi
80101578:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010157e:	e8 fd 60 00 00       	call   80107680 <allocuvm>
80101583:	83 c4 10             	add    $0x10,%esp
80101586:	85 c0                	test   %eax,%eax
80101588:	89 c7                	mov    %eax,%edi
8010158a:	74 65                	je     801015f1 <exec+0x141>
            cleanupexec(pgdir, ip);
            return -1;    
        }
        if (ph.vaddr % PGSIZE != 0) {
8010158c:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80101592:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101597:	75 58                	jne    801015f1 <exec+0x141>
            cleanupexec(pgdir, ip);
            return -1;    
        }
        if (loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0) {
80101599:	83 ec 0c             	sub    $0xc,%esp
8010159c:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
801015a2:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
801015a8:	56                   	push   %esi
801015a9:	50                   	push   %eax
801015aa:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801015b0:	e8 0b 60 00 00       	call   801075c0 <loaduvm>
801015b5:	83 c4 20             	add    $0x20,%esp
801015b8:	85 c0                	test   %eax,%eax
801015ba:	78 35                	js     801015f1 <exec+0x141>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
801015bc:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
801015c3:	83 c3 01             	add    $0x1,%ebx
801015c6:	39 d8                	cmp    %ebx,%eax
801015c8:	7e 46                	jle    80101610 <exec+0x160>
        if (readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph)) {
801015ca:	89 d8                	mov    %ebx,%eax
801015cc:	6a 20                	push   $0x20
801015ce:	c1 e0 05             	shl    $0x5,%eax
801015d1:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
801015d7:	50                   	push   %eax
801015d8:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801015de:	50                   	push   %eax
801015df:	56                   	push   %esi
801015e0:	e8 4b 0e 00 00       	call   80102430 <readi>
801015e5:	83 c4 10             	add    $0x10,%esp
801015e8:	83 f8 20             	cmp    $0x20,%eax
801015eb:	0f 84 5f ff ff ff    	je     80101550 <exec+0xa0>
            cleanupexec(pgdir, ip);
801015f1:	83 ec 08             	sub    $0x8,%esp
801015f4:	56                   	push   %esi
801015f5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801015fb:	e8 60 fe ff ff       	call   80101460 <cleanupexec>
            return -1;    
80101600:	83 c4 10             	add    $0x10,%esp
80101603:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    curproc->tf->eip = elf.entry;  // main
    curproc->tf->esp = sp;
    switchuvm(curproc);
    freevm(oldpgdir);
    return 0;
}
80101608:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010160b:	5b                   	pop    %ebx
8010160c:	5e                   	pop    %esi
8010160d:	5f                   	pop    %edi
8010160e:	5d                   	pop    %ebp
8010160f:	c3                   	ret    
80101610:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80101616:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
8010161c:	8d 9f 00 20 00 00    	lea    0x2000(%edi),%ebx
    iunlockput(ip);
80101622:	83 ec 0c             	sub    $0xc,%esp
80101625:	56                   	push   %esi
80101626:	e8 b5 0d 00 00       	call   801023e0 <iunlockput>
    end_op();
8010162b:	e8 b0 20 00 00       	call   801036e0 <end_op>
    if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0) {
80101630:	83 c4 0c             	add    $0xc,%esp
80101633:	53                   	push   %ebx
80101634:	57                   	push   %edi
80101635:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010163b:	e8 40 60 00 00       	call   80107680 <allocuvm>
80101640:	83 c4 10             	add    $0x10,%esp
80101643:	85 c0                	test   %eax,%eax
80101645:	89 c7                	mov    %eax,%edi
80101647:	0f 84 8c 00 00 00    	je     801016d9 <exec+0x229>
    clearpteu(pgdir, (char*)(sz - 2 * PGSIZE));
8010164d:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80101653:	83 ec 08             	sub    $0x8,%esp
    for (argc = 0; argv[argc]; argc++) {
80101656:	31 f6                	xor    %esi,%esi
80101658:	89 fb                	mov    %edi,%ebx
    clearpteu(pgdir, (char*)(sz - 2 * PGSIZE));
8010165a:	50                   	push   %eax
8010165b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101661:	e8 9a 62 00 00       	call   80107900 <clearpteu>
    for (argc = 0; argv[argc]; argc++) {
80101666:	8b 45 0c             	mov    0xc(%ebp),%eax
80101669:	83 c4 10             	add    $0x10,%esp
8010166c:	8b 08                	mov    (%eax),%ecx
8010166e:	85 c9                	test   %ecx,%ecx
80101670:	0f 84 76 01 00 00    	je     801017ec <exec+0x33c>
80101676:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
8010167c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010167f:	eb 25                	jmp    801016a6 <exec+0x1f6>
80101681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101688:	8d 46 01             	lea    0x1(%esi),%eax
        ustack[3 + argc] = sp;
8010168b:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101691:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
    for (argc = 0; argv[argc]; argc++) {
80101698:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
8010169b:	85 c9                	test   %ecx,%ecx
8010169d:	74 5a                	je     801016f9 <exec+0x249>
        if (argc >= MAXARG) {
8010169f:	83 f8 20             	cmp    $0x20,%eax
801016a2:	74 35                	je     801016d9 <exec+0x229>
801016a4:	89 c6                	mov    %eax,%esi
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801016a6:	83 ec 0c             	sub    $0xc,%esp
801016a9:	51                   	push   %ecx
801016aa:	e8 c1 3a 00 00       	call   80105170 <strlen>
801016af:	f7 d0                	not    %eax
801016b1:	01 c3                	add    %eax,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0) {
801016b3:	58                   	pop    %eax
801016b4:	ff 34 b7             	pushl  (%edi,%esi,4)
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801016b7:	83 e3 fc             	and    $0xfffffffc,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0) {
801016ba:	e8 b1 3a 00 00       	call   80105170 <strlen>
801016bf:	83 c0 01             	add    $0x1,%eax
801016c2:	50                   	push   %eax
801016c3:	ff 34 b7             	pushl  (%edi,%esi,4)
801016c6:	53                   	push   %ebx
801016c7:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801016cd:	e8 ae 63 00 00       	call   80107a80 <copyout>
801016d2:	83 c4 20             	add    $0x20,%esp
801016d5:	85 c0                	test   %eax,%eax
801016d7:	79 af                	jns    80101688 <exec+0x1d8>
        cleanupexec(pgdir, ip);
801016d9:	83 ec 08             	sub    $0x8,%esp
801016dc:	6a 00                	push   $0x0
801016de:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801016e4:	e8 77 fd ff ff       	call   80101460 <cleanupexec>
        return -1;    
801016e9:	83 c4 10             	add    $0x10,%esp
}
801016ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;    
801016ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801016f4:	5b                   	pop    %ebx
801016f5:	5e                   	pop    %esi
801016f6:	5f                   	pop    %edi
801016f7:	5d                   	pop    %ebp
801016f8:	c3                   	ret    
801016f9:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801016ff:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101705:	8d 46 04             	lea    0x4(%esi),%eax
80101708:	8d 34 b5 08 00 00 00 	lea    0x8(,%esi,4),%esi
8010170f:	8d 4e 0c             	lea    0xc(%esi),%ecx
    ustack[3 + argc] = 0;
80101712:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80101719:	00 00 00 00 
    ustack[1] = argc;
8010171d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0) {
80101723:	51                   	push   %ecx
80101724:	52                   	push   %edx
    ustack[0] = 0xffffffff;  // fake return PC
80101725:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010172c:	ff ff ff 
    ustack[1] = argc;
8010172f:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80101735:	89 d8                	mov    %ebx,%eax
    sp -= (3 + argc + 1) * 4;
80101737:	29 cb                	sub    %ecx,%ebx
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0) {
80101739:	53                   	push   %ebx
8010173a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80101740:	29 f0                	sub    %esi,%eax
80101742:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0) {
80101748:	e8 33 63 00 00       	call   80107a80 <copyout>
8010174d:	83 c4 10             	add    $0x10,%esp
80101750:	85 c0                	test   %eax,%eax
80101752:	78 85                	js     801016d9 <exec+0x229>
    for (last = s = path; *s; s++) {
80101754:	8b 45 08             	mov    0x8(%ebp),%eax
80101757:	8b 55 08             	mov    0x8(%ebp),%edx
8010175a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010175d:	0f b6 00             	movzbl (%eax),%eax
80101760:	84 c0                	test   %al,%al
80101762:	74 13                	je     80101777 <exec+0x2c7>
80101764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101768:	83 c1 01             	add    $0x1,%ecx
8010176b:	3c 2f                	cmp    $0x2f,%al
8010176d:	0f b6 01             	movzbl (%ecx),%eax
80101770:	0f 44 d1             	cmove  %ecx,%edx
80101773:	84 c0                	test   %al,%al
80101775:	75 f1                	jne    80101768 <exec+0x2b8>
    safestrcpy(curproc->name, last, sizeof(curproc->name));
80101777:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
8010177d:	83 ec 04             	sub    $0x4,%esp
80101780:	6a 10                	push   $0x10
80101782:	52                   	push   %edx
80101783:	8d 46 6c             	lea    0x6c(%esi),%eax
80101786:	50                   	push   %eax
80101787:	e8 a4 39 00 00       	call   80105130 <safestrcpy>
    curproc->pgdir = pgdir;
8010178c:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    oldpgdir = curproc->pgdir;
80101792:	89 f0                	mov    %esi,%eax
80101794:	8b 76 04             	mov    0x4(%esi),%esi
    curproc->sz = sz;
80101797:	89 38                	mov    %edi,(%eax)
    curproc->pgdir = pgdir;
80101799:	89 48 04             	mov    %ecx,0x4(%eax)
    curproc->tf->eip = elf.entry;  // main
8010179c:	89 c1                	mov    %eax,%ecx
8010179e:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801017a4:	8b 40 18             	mov    0x18(%eax),%eax
801017a7:	89 50 38             	mov    %edx,0x38(%eax)
    curproc->tf->esp = sp;
801017aa:	8b 41 18             	mov    0x18(%ecx),%eax
801017ad:	89 58 44             	mov    %ebx,0x44(%eax)
    switchuvm(curproc);
801017b0:	89 0c 24             	mov    %ecx,(%esp)
801017b3:	e8 78 5c 00 00       	call   80107430 <switchuvm>
    freevm(oldpgdir);
801017b8:	89 34 24             	mov    %esi,(%esp)
801017bb:	e8 20 60 00 00       	call   801077e0 <freevm>
    return 0;
801017c0:	83 c4 10             	add    $0x10,%esp
801017c3:	31 c0                	xor    %eax,%eax
801017c5:	e9 3e fe ff ff       	jmp    80101608 <exec+0x158>
        cleanupexec(pgdir, ip);
801017ca:	83 ec 08             	sub    $0x8,%esp
801017cd:	56                   	push   %esi
801017ce:	6a 00                	push   $0x0
801017d0:	e8 8b fc ff ff       	call   80101460 <cleanupexec>
        return -1;    
801017d5:	83 c4 10             	add    $0x10,%esp
801017d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801017dd:	e9 26 fe ff ff       	jmp    80101608 <exec+0x158>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
801017e2:	bb 00 20 00 00       	mov    $0x2000,%ebx
801017e7:	e9 36 fe ff ff       	jmp    80101622 <exec+0x172>
    for (argc = 0; argv[argc]; argc++) {
801017ec:	b9 10 00 00 00       	mov    $0x10,%ecx
801017f1:	be 04 00 00 00       	mov    $0x4,%esi
801017f6:	b8 03 00 00 00       	mov    $0x3,%eax
801017fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101802:	00 00 00 
80101805:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
8010180b:	e9 02 ff ff ff       	jmp    80101712 <exec+0x262>
        end_op();
80101810:	e8 cb 1e 00 00       	call   801036e0 <end_op>
        cprintf("exec: fail\n");
80101815:	83 ec 0c             	sub    $0xc,%esp
80101818:	68 d1 7b 10 80       	push   $0x80107bd1
8010181d:	e8 3e f0 ff ff       	call   80100860 <cprintf>
        return -1;
80101822:	83 c4 10             	add    $0x10,%esp
80101825:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010182a:	e9 d9 fd ff ff       	jmp    80101608 <exec+0x158>
8010182f:	90                   	nop

80101830 <fileinit>:
struct {
    struct spinlock lock;
    struct file file[NFILE];
} ftable;

void fileinit(void) {
80101830:	55                   	push   %ebp
80101831:	89 e5                	mov    %esp,%ebp
80101833:	83 ec 10             	sub    $0x10,%esp
    initlock(&ftable.lock, "ftable");
80101836:	68 dd 7b 10 80       	push   $0x80107bdd
8010183b:	68 a0 27 11 80       	push   $0x801127a0
80101840:	e8 bb 34 00 00       	call   80104d00 <initlock>
}
80101845:	83 c4 10             	add    $0x10,%esp
80101848:	c9                   	leave  
80101849:	c3                   	ret    
8010184a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101850 <filealloc>:

// Allocate a file structure.
struct file* filealloc(void) {
80101850:	55                   	push   %ebp
80101851:	89 e5                	mov    %esp,%ebp
80101853:	53                   	push   %ebx
    struct file *f;

    acquire(&ftable.lock);
    for (f = ftable.file; f < ftable.file + NFILE; f++) {
80101854:	bb d4 27 11 80       	mov    $0x801127d4,%ebx
struct file* filealloc(void) {
80101859:	83 ec 10             	sub    $0x10,%esp
    acquire(&ftable.lock);
8010185c:	68 a0 27 11 80       	push   $0x801127a0
80101861:	e8 da 35 00 00       	call   80104e40 <acquire>
80101866:	83 c4 10             	add    $0x10,%esp
80101869:	eb 10                	jmp    8010187b <filealloc+0x2b>
8010186b:	90                   	nop
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (f = ftable.file; f < ftable.file + NFILE; f++) {
80101870:	83 c3 18             	add    $0x18,%ebx
80101873:	81 fb 34 31 11 80    	cmp    $0x80113134,%ebx
80101879:	73 25                	jae    801018a0 <filealloc+0x50>
        if (f->ref == 0) {
8010187b:	8b 43 04             	mov    0x4(%ebx),%eax
8010187e:	85 c0                	test   %eax,%eax
80101880:	75 ee                	jne    80101870 <filealloc+0x20>
            f->ref = 1;
            release(&ftable.lock);
80101882:	83 ec 0c             	sub    $0xc,%esp
            f->ref = 1;
80101885:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
            release(&ftable.lock);
8010188c:	68 a0 27 11 80       	push   $0x801127a0
80101891:	e8 6a 36 00 00       	call   80104f00 <release>
            return f;
        }
    }
    release(&ftable.lock);
    return 0;
}
80101896:	89 d8                	mov    %ebx,%eax
            return f;
80101898:	83 c4 10             	add    $0x10,%esp
}
8010189b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010189e:	c9                   	leave  
8010189f:	c3                   	ret    
    release(&ftable.lock);
801018a0:	83 ec 0c             	sub    $0xc,%esp
    return 0;
801018a3:	31 db                	xor    %ebx,%ebx
    release(&ftable.lock);
801018a5:	68 a0 27 11 80       	push   $0x801127a0
801018aa:	e8 51 36 00 00       	call   80104f00 <release>
}
801018af:	89 d8                	mov    %ebx,%eax
    return 0;
801018b1:	83 c4 10             	add    $0x10,%esp
}
801018b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018b7:	c9                   	leave  
801018b8:	c3                   	ret    
801018b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801018c0 <filedup>:

// Increment ref count for file f.
struct file* filedup(struct file *f) {
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	53                   	push   %ebx
801018c4:	83 ec 10             	sub    $0x10,%esp
801018c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ftable.lock);
801018ca:	68 a0 27 11 80       	push   $0x801127a0
801018cf:	e8 6c 35 00 00       	call   80104e40 <acquire>
    if (f->ref < 1) {
801018d4:	8b 43 04             	mov    0x4(%ebx),%eax
801018d7:	83 c4 10             	add    $0x10,%esp
801018da:	85 c0                	test   %eax,%eax
801018dc:	7e 1a                	jle    801018f8 <filedup+0x38>
        panic("filedup");
    }
    f->ref++;
801018de:	83 c0 01             	add    $0x1,%eax
    release(&ftable.lock);
801018e1:	83 ec 0c             	sub    $0xc,%esp
    f->ref++;
801018e4:	89 43 04             	mov    %eax,0x4(%ebx)
    release(&ftable.lock);
801018e7:	68 a0 27 11 80       	push   $0x801127a0
801018ec:	e8 0f 36 00 00       	call   80104f00 <release>
    return f;
}
801018f1:	89 d8                	mov    %ebx,%eax
801018f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018f6:	c9                   	leave  
801018f7:	c3                   	ret    
        panic("filedup");
801018f8:	83 ec 0c             	sub    $0xc,%esp
801018fb:	68 e4 7b 10 80       	push   $0x80107be4
80101900:	e8 db eb ff ff       	call   801004e0 <panic>
80101905:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101910 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f) {
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	57                   	push   %edi
80101914:	56                   	push   %esi
80101915:	53                   	push   %ebx
80101916:	83 ec 28             	sub    $0x28,%esp
80101919:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct file ff;

    acquire(&ftable.lock);
8010191c:	68 a0 27 11 80       	push   $0x801127a0
80101921:	e8 1a 35 00 00       	call   80104e40 <acquire>
    if (f->ref < 1) {
80101926:	8b 43 04             	mov    0x4(%ebx),%eax
80101929:	83 c4 10             	add    $0x10,%esp
8010192c:	85 c0                	test   %eax,%eax
8010192e:	0f 8e 9b 00 00 00    	jle    801019cf <fileclose+0xbf>
        panic("fileclose");
    }
    if (--f->ref > 0) {
80101934:	83 e8 01             	sub    $0x1,%eax
80101937:	85 c0                	test   %eax,%eax
80101939:	89 43 04             	mov    %eax,0x4(%ebx)
8010193c:	74 1a                	je     80101958 <fileclose+0x48>
        release(&ftable.lock);
8010193e:	c7 45 08 a0 27 11 80 	movl   $0x801127a0,0x8(%ebp)
    else if (ff.type == FD_INODE) {
        begin_op();
        iput(ff.ip);
        end_op();
    }
}
80101945:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101948:	5b                   	pop    %ebx
80101949:	5e                   	pop    %esi
8010194a:	5f                   	pop    %edi
8010194b:	5d                   	pop    %ebp
        release(&ftable.lock);
8010194c:	e9 af 35 00 00       	jmp    80104f00 <release>
80101951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ff = *f;
80101958:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
8010195c:	8b 3b                	mov    (%ebx),%edi
    release(&ftable.lock);
8010195e:	83 ec 0c             	sub    $0xc,%esp
    ff = *f;
80101961:	8b 73 0c             	mov    0xc(%ebx),%esi
    f->type = FD_NONE;
80101964:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    ff = *f;
8010196a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010196d:	8b 43 10             	mov    0x10(%ebx),%eax
    release(&ftable.lock);
80101970:	68 a0 27 11 80       	push   $0x801127a0
    ff = *f;
80101975:	89 45 e0             	mov    %eax,-0x20(%ebp)
    release(&ftable.lock);
80101978:	e8 83 35 00 00       	call   80104f00 <release>
    if (ff.type == FD_PIPE) {
8010197d:	83 c4 10             	add    $0x10,%esp
80101980:	83 ff 01             	cmp    $0x1,%edi
80101983:	74 13                	je     80101998 <fileclose+0x88>
    else if (ff.type == FD_INODE) {
80101985:	83 ff 02             	cmp    $0x2,%edi
80101988:	74 26                	je     801019b0 <fileclose+0xa0>
}
8010198a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010198d:	5b                   	pop    %ebx
8010198e:	5e                   	pop    %esi
8010198f:	5f                   	pop    %edi
80101990:	5d                   	pop    %ebp
80101991:	c3                   	ret    
80101992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        pipeclose(ff.pipe, ff.writable);
80101998:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010199c:	83 ec 08             	sub    $0x8,%esp
8010199f:	53                   	push   %ebx
801019a0:	56                   	push   %esi
801019a1:	e8 9a 24 00 00       	call   80103e40 <pipeclose>
801019a6:	83 c4 10             	add    $0x10,%esp
801019a9:	eb df                	jmp    8010198a <fileclose+0x7a>
801019ab:	90                   	nop
801019ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        begin_op();
801019b0:	e8 bb 1c 00 00       	call   80103670 <begin_op>
        iput(ff.ip);
801019b5:	83 ec 0c             	sub    $0xc,%esp
801019b8:	ff 75 e0             	pushl  -0x20(%ebp)
801019bb:	e8 c0 08 00 00       	call   80102280 <iput>
        end_op();
801019c0:	83 c4 10             	add    $0x10,%esp
}
801019c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019c6:	5b                   	pop    %ebx
801019c7:	5e                   	pop    %esi
801019c8:	5f                   	pop    %edi
801019c9:	5d                   	pop    %ebp
        end_op();
801019ca:	e9 11 1d 00 00       	jmp    801036e0 <end_op>
        panic("fileclose");
801019cf:	83 ec 0c             	sub    $0xc,%esp
801019d2:	68 ec 7b 10 80       	push   $0x80107bec
801019d7:	e8 04 eb ff ff       	call   801004e0 <panic>
801019dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019e0 <filestat>:

// Get metadata about file f.
int filestat(struct file *f, struct stat *st) {
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	53                   	push   %ebx
801019e4:	83 ec 04             	sub    $0x4,%esp
801019e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (f->type == FD_INODE) {
801019ea:	83 3b 02             	cmpl   $0x2,(%ebx)
801019ed:	75 31                	jne    80101a20 <filestat+0x40>
        ilock(f->ip);
801019ef:	83 ec 0c             	sub    $0xc,%esp
801019f2:	ff 73 10             	pushl  0x10(%ebx)
801019f5:	e8 56 07 00 00       	call   80102150 <ilock>
        stati(f->ip, st);
801019fa:	58                   	pop    %eax
801019fb:	5a                   	pop    %edx
801019fc:	ff 75 0c             	pushl  0xc(%ebp)
801019ff:	ff 73 10             	pushl  0x10(%ebx)
80101a02:	e8 f9 09 00 00       	call   80102400 <stati>
        iunlock(f->ip);
80101a07:	59                   	pop    %ecx
80101a08:	ff 73 10             	pushl  0x10(%ebx)
80101a0b:	e8 20 08 00 00       	call   80102230 <iunlock>
        return 0;
80101a10:	83 c4 10             	add    $0x10,%esp
80101a13:	31 c0                	xor    %eax,%eax
    }
    return -1;
}
80101a15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a18:	c9                   	leave  
80101a19:	c3                   	ret    
80101a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101a20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a25:	eb ee                	jmp    80101a15 <filestat+0x35>
80101a27:	89 f6                	mov    %esi,%esi
80101a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101a30 <fileread>:

// Read from file f.
int fileread(struct file *f, char *addr, int n) {
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	57                   	push   %edi
80101a34:	56                   	push   %esi
80101a35:	53                   	push   %ebx
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a3f:	8b 7d 10             	mov    0x10(%ebp),%edi
    int r;

    if (f->readable == 0) {
80101a42:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101a46:	74 60                	je     80101aa8 <fileread+0x78>
        return -1;
    }
    if (f->type == FD_PIPE) {
80101a48:	8b 03                	mov    (%ebx),%eax
80101a4a:	83 f8 01             	cmp    $0x1,%eax
80101a4d:	74 41                	je     80101a90 <fileread+0x60>
        return piperead(f->pipe, addr, n);
    }
    if (f->type == FD_INODE) {
80101a4f:	83 f8 02             	cmp    $0x2,%eax
80101a52:	75 5b                	jne    80101aaf <fileread+0x7f>
        ilock(f->ip);
80101a54:	83 ec 0c             	sub    $0xc,%esp
80101a57:	ff 73 10             	pushl  0x10(%ebx)
80101a5a:	e8 f1 06 00 00       	call   80102150 <ilock>
        if ((r = readi(f->ip, addr, f->off, n)) > 0) {
80101a5f:	57                   	push   %edi
80101a60:	ff 73 14             	pushl  0x14(%ebx)
80101a63:	56                   	push   %esi
80101a64:	ff 73 10             	pushl  0x10(%ebx)
80101a67:	e8 c4 09 00 00       	call   80102430 <readi>
80101a6c:	83 c4 20             	add    $0x20,%esp
80101a6f:	85 c0                	test   %eax,%eax
80101a71:	89 c6                	mov    %eax,%esi
80101a73:	7e 03                	jle    80101a78 <fileread+0x48>
            f->off += r;
80101a75:	01 43 14             	add    %eax,0x14(%ebx)
        }
        iunlock(f->ip);
80101a78:	83 ec 0c             	sub    $0xc,%esp
80101a7b:	ff 73 10             	pushl  0x10(%ebx)
80101a7e:	e8 ad 07 00 00       	call   80102230 <iunlock>
        return r;
80101a83:	83 c4 10             	add    $0x10,%esp
    }
    panic("fileread");
}
80101a86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a89:	89 f0                	mov    %esi,%eax
80101a8b:	5b                   	pop    %ebx
80101a8c:	5e                   	pop    %esi
80101a8d:	5f                   	pop    %edi
80101a8e:	5d                   	pop    %ebp
80101a8f:	c3                   	ret    
        return piperead(f->pipe, addr, n);
80101a90:	8b 43 0c             	mov    0xc(%ebx),%eax
80101a93:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101a96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a99:	5b                   	pop    %ebx
80101a9a:	5e                   	pop    %esi
80101a9b:	5f                   	pop    %edi
80101a9c:	5d                   	pop    %ebp
        return piperead(f->pipe, addr, n);
80101a9d:	e9 4e 25 00 00       	jmp    80103ff0 <piperead>
80101aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
80101aa8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101aad:	eb d7                	jmp    80101a86 <fileread+0x56>
    panic("fileread");
80101aaf:	83 ec 0c             	sub    $0xc,%esp
80101ab2:	68 f6 7b 10 80       	push   $0x80107bf6
80101ab7:	e8 24 ea ff ff       	call   801004e0 <panic>
80101abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ac0 <filewrite>:


// Write to file f.
int filewrite(struct file *f, char *addr, int n) {
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	57                   	push   %edi
80101ac4:	56                   	push   %esi
80101ac5:	53                   	push   %ebx
80101ac6:	83 ec 1c             	sub    $0x1c,%esp
80101ac9:	8b 75 08             	mov    0x8(%ebp),%esi
80101acc:	8b 45 0c             	mov    0xc(%ebp),%eax
    int r;

    if (f->writable == 0) {
80101acf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
int filewrite(struct file *f, char *addr, int n) {
80101ad3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ad6:	8b 45 10             	mov    0x10(%ebp),%eax
80101ad9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (f->writable == 0) {
80101adc:	0f 84 aa 00 00 00    	je     80101b8c <filewrite+0xcc>
        return -1;
    }
    if (f->type == FD_PIPE) {
80101ae2:	8b 06                	mov    (%esi),%eax
80101ae4:	83 f8 01             	cmp    $0x1,%eax
80101ae7:	0f 84 c3 00 00 00    	je     80101bb0 <filewrite+0xf0>
        return pipewrite(f->pipe, addr, n);
    }
    if (f->type == FD_INODE) {
80101aed:	83 f8 02             	cmp    $0x2,%eax
80101af0:	0f 85 d9 00 00 00    	jne    80101bcf <filewrite+0x10f>
        // and 2 blocks of slop for non-aligned writes.
        // this really belongs lower down, since writei()
        // might be writing a device like the console.
        int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * 512;
        int i = 0;
        while (i < n) {
80101af6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        int i = 0;
80101af9:	31 ff                	xor    %edi,%edi
        while (i < n) {
80101afb:	85 c0                	test   %eax,%eax
80101afd:	7f 34                	jg     80101b33 <filewrite+0x73>
80101aff:	e9 9c 00 00 00       	jmp    80101ba0 <filewrite+0xe0>
80101b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            }

            begin_op();
            ilock(f->ip);
            if ((r = writei(f->ip, addr + i, f->off, n1)) > 0) {
                f->off += r;
80101b08:	01 46 14             	add    %eax,0x14(%esi)
            }
            iunlock(f->ip);
80101b0b:	83 ec 0c             	sub    $0xc,%esp
80101b0e:	ff 76 10             	pushl  0x10(%esi)
                f->off += r;
80101b11:	89 45 e0             	mov    %eax,-0x20(%ebp)
            iunlock(f->ip);
80101b14:	e8 17 07 00 00       	call   80102230 <iunlock>
            end_op();
80101b19:	e8 c2 1b 00 00       	call   801036e0 <end_op>
80101b1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b21:	83 c4 10             	add    $0x10,%esp

            if (r < 0) {
                break;
            }
            if (r != n1) {
80101b24:	39 c3                	cmp    %eax,%ebx
80101b26:	0f 85 96 00 00 00    	jne    80101bc2 <filewrite+0x102>
                panic("short filewrite");
            }
            i += r;
80101b2c:	01 df                	add    %ebx,%edi
        while (i < n) {
80101b2e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b31:	7e 6d                	jle    80101ba0 <filewrite+0xe0>
            int n1 = n - i;
80101b33:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b36:	b8 00 06 00 00       	mov    $0x600,%eax
80101b3b:	29 fb                	sub    %edi,%ebx
80101b3d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101b43:	0f 4f d8             	cmovg  %eax,%ebx
            begin_op();
80101b46:	e8 25 1b 00 00       	call   80103670 <begin_op>
            ilock(f->ip);
80101b4b:	83 ec 0c             	sub    $0xc,%esp
80101b4e:	ff 76 10             	pushl  0x10(%esi)
80101b51:	e8 fa 05 00 00       	call   80102150 <ilock>
            if ((r = writei(f->ip, addr + i, f->off, n1)) > 0) {
80101b56:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101b59:	53                   	push   %ebx
80101b5a:	ff 76 14             	pushl  0x14(%esi)
80101b5d:	01 f8                	add    %edi,%eax
80101b5f:	50                   	push   %eax
80101b60:	ff 76 10             	pushl  0x10(%esi)
80101b63:	e8 c8 09 00 00       	call   80102530 <writei>
80101b68:	83 c4 20             	add    $0x20,%esp
80101b6b:	85 c0                	test   %eax,%eax
80101b6d:	7f 99                	jg     80101b08 <filewrite+0x48>
            iunlock(f->ip);
80101b6f:	83 ec 0c             	sub    $0xc,%esp
80101b72:	ff 76 10             	pushl  0x10(%esi)
80101b75:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b78:	e8 b3 06 00 00       	call   80102230 <iunlock>
            end_op();
80101b7d:	e8 5e 1b 00 00       	call   801036e0 <end_op>
            if (r < 0) {
80101b82:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b85:	83 c4 10             	add    $0x10,%esp
80101b88:	85 c0                	test   %eax,%eax
80101b8a:	74 98                	je     80101b24 <filewrite+0x64>
        }
        return i == n ? n : -1;
    }
    panic("filewrite");
}
80101b8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80101b8f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101b94:	89 f8                	mov    %edi,%eax
80101b96:	5b                   	pop    %ebx
80101b97:	5e                   	pop    %esi
80101b98:	5f                   	pop    %edi
80101b99:	5d                   	pop    %ebp
80101b9a:	c3                   	ret    
80101b9b:	90                   	nop
80101b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return i == n ? n : -1;
80101ba0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ba3:	75 e7                	jne    80101b8c <filewrite+0xcc>
}
80101ba5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ba8:	89 f8                	mov    %edi,%eax
80101baa:	5b                   	pop    %ebx
80101bab:	5e                   	pop    %esi
80101bac:	5f                   	pop    %edi
80101bad:	5d                   	pop    %ebp
80101bae:	c3                   	ret    
80101baf:	90                   	nop
        return pipewrite(f->pipe, addr, n);
80101bb0:	8b 46 0c             	mov    0xc(%esi),%eax
80101bb3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101bb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bb9:	5b                   	pop    %ebx
80101bba:	5e                   	pop    %esi
80101bbb:	5f                   	pop    %edi
80101bbc:	5d                   	pop    %ebp
        return pipewrite(f->pipe, addr, n);
80101bbd:	e9 1e 23 00 00       	jmp    80103ee0 <pipewrite>
                panic("short filewrite");
80101bc2:	83 ec 0c             	sub    $0xc,%esp
80101bc5:	68 ff 7b 10 80       	push   $0x80107bff
80101bca:	e8 11 e9 ff ff       	call   801004e0 <panic>
    panic("filewrite");
80101bcf:	83 ec 0c             	sub    $0xc,%esp
80101bd2:	68 05 7c 10 80       	push   $0x80107c05
80101bd7:	e8 04 e9 ff ff       	call   801004e0 <panic>
80101bdc:	66 90                	xchg   %ax,%ax
80101bde:	66 90                	xchg   %ax,%ax

80101be0 <bfree>:
    }
    panic("balloc: out of blocks");
}

// Free a disk block.
static void bfree(int dev, uint b) {
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	56                   	push   %esi
80101be4:	53                   	push   %ebx
80101be5:	89 d3                	mov    %edx,%ebx
    struct buf *bp;
    int bi, m;

    bp = bread(dev, BBLOCK(b, sb));
80101be7:	c1 ea 0c             	shr    $0xc,%edx
80101bea:	03 15 b8 31 11 80    	add    0x801131b8,%edx
80101bf0:	83 ec 08             	sub    $0x8,%esp
80101bf3:	52                   	push   %edx
80101bf4:	50                   	push   %eax
80101bf5:	e8 d6 e4 ff ff       	call   801000d0 <bread>
    bi = b % BPB;
    m = 1 << (bi % 8);
80101bfa:	89 d9                	mov    %ebx,%ecx
    if ((bp->data[bi / 8] & m) == 0) {
80101bfc:	c1 fb 03             	sar    $0x3,%ebx
    m = 1 << (bi % 8);
80101bff:	ba 01 00 00 00       	mov    $0x1,%edx
80101c04:	83 e1 07             	and    $0x7,%ecx
    if ((bp->data[bi / 8] & m) == 0) {
80101c07:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101c0d:	83 c4 10             	add    $0x10,%esp
    m = 1 << (bi % 8);
80101c10:	d3 e2                	shl    %cl,%edx
    if ((bp->data[bi / 8] & m) == 0) {
80101c12:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101c17:	85 d1                	test   %edx,%ecx
80101c19:	74 25                	je     80101c40 <bfree+0x60>
        panic("freeing free block");
    }
    bp->data[bi / 8] &= ~m;
80101c1b:	f7 d2                	not    %edx
80101c1d:	89 c6                	mov    %eax,%esi
    log_write(bp);
80101c1f:	83 ec 0c             	sub    $0xc,%esp
    bp->data[bi / 8] &= ~m;
80101c22:	21 ca                	and    %ecx,%edx
80101c24:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
    log_write(bp);
80101c28:	56                   	push   %esi
80101c29:	e8 12 1c 00 00       	call   80103840 <log_write>
    brelse(bp);
80101c2e:	89 34 24             	mov    %esi,(%esp)
80101c31:	e8 aa e5 ff ff       	call   801001e0 <brelse>
}
80101c36:	83 c4 10             	add    $0x10,%esp
80101c39:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c3c:	5b                   	pop    %ebx
80101c3d:	5e                   	pop    %esi
80101c3e:	5d                   	pop    %ebp
80101c3f:	c3                   	ret    
        panic("freeing free block");
80101c40:	83 ec 0c             	sub    $0xc,%esp
80101c43:	68 0f 7c 10 80       	push   $0x80107c0f
80101c48:	e8 93 e8 ff ff       	call   801004e0 <panic>
80101c4d:	8d 76 00             	lea    0x0(%esi),%esi

80101c50 <balloc>:
static uint balloc(uint dev) {
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	83 ec 1c             	sub    $0x1c,%esp
    for (b = 0; b < sb.size; b += BPB) {
80101c59:	8b 0d a0 31 11 80    	mov    0x801131a0,%ecx
static uint balloc(uint dev) {
80101c5f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    for (b = 0; b < sb.size; b += BPB) {
80101c62:	85 c9                	test   %ecx,%ecx
80101c64:	0f 84 87 00 00 00    	je     80101cf1 <balloc+0xa1>
80101c6a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
        bp = bread(dev, BBLOCK(b, sb));
80101c71:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101c74:	83 ec 08             	sub    $0x8,%esp
80101c77:	89 f0                	mov    %esi,%eax
80101c79:	c1 f8 0c             	sar    $0xc,%eax
80101c7c:	03 05 b8 31 11 80    	add    0x801131b8,%eax
80101c82:	50                   	push   %eax
80101c83:	ff 75 d8             	pushl  -0x28(%ebp)
80101c86:	e8 45 e4 ff ff       	call   801000d0 <bread>
80101c8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
80101c8e:	a1 a0 31 11 80       	mov    0x801131a0,%eax
80101c93:	83 c4 10             	add    $0x10,%esp
80101c96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101c99:	31 c0                	xor    %eax,%eax
80101c9b:	eb 2f                	jmp    80101ccc <balloc+0x7c>
80101c9d:	8d 76 00             	lea    0x0(%esi),%esi
            m = 1 << (bi % 8);
80101ca0:	89 c1                	mov    %eax,%ecx
            if ((bp->data[bi / 8] & m) == 0) { // Is block free?
80101ca2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            m = 1 << (bi % 8);
80101ca5:	bb 01 00 00 00       	mov    $0x1,%ebx
80101caa:	83 e1 07             	and    $0x7,%ecx
80101cad:	d3 e3                	shl    %cl,%ebx
            if ((bp->data[bi / 8] & m) == 0) { // Is block free?
80101caf:	89 c1                	mov    %eax,%ecx
80101cb1:	c1 f9 03             	sar    $0x3,%ecx
80101cb4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101cb9:	85 df                	test   %ebx,%edi
80101cbb:	89 fa                	mov    %edi,%edx
80101cbd:	74 41                	je     80101d00 <balloc+0xb0>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
80101cbf:	83 c0 01             	add    $0x1,%eax
80101cc2:	83 c6 01             	add    $0x1,%esi
80101cc5:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101cca:	74 05                	je     80101cd1 <balloc+0x81>
80101ccc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80101ccf:	77 cf                	ja     80101ca0 <balloc+0x50>
        brelse(bp);
80101cd1:	83 ec 0c             	sub    $0xc,%esp
80101cd4:	ff 75 e4             	pushl  -0x1c(%ebp)
80101cd7:	e8 04 e5 ff ff       	call   801001e0 <brelse>
    for (b = 0; b < sb.size; b += BPB) {
80101cdc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101ce3:	83 c4 10             	add    $0x10,%esp
80101ce6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ce9:	39 05 a0 31 11 80    	cmp    %eax,0x801131a0
80101cef:	77 80                	ja     80101c71 <balloc+0x21>
    panic("balloc: out of blocks");
80101cf1:	83 ec 0c             	sub    $0xc,%esp
80101cf4:	68 22 7c 10 80       	push   $0x80107c22
80101cf9:	e8 e2 e7 ff ff       	call   801004e0 <panic>
80101cfe:	66 90                	xchg   %ax,%ax
                bp->data[bi / 8] |= m;  // Mark block in use.
80101d00:	8b 7d e4             	mov    -0x1c(%ebp),%edi
                log_write(bp);
80101d03:	83 ec 0c             	sub    $0xc,%esp
                bp->data[bi / 8] |= m;  // Mark block in use.
80101d06:	09 da                	or     %ebx,%edx
80101d08:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
                log_write(bp);
80101d0c:	57                   	push   %edi
80101d0d:	e8 2e 1b 00 00       	call   80103840 <log_write>
                brelse(bp);
80101d12:	89 3c 24             	mov    %edi,(%esp)
80101d15:	e8 c6 e4 ff ff       	call   801001e0 <brelse>
    bp = bread(dev, bno);
80101d1a:	58                   	pop    %eax
80101d1b:	5a                   	pop    %edx
80101d1c:	56                   	push   %esi
80101d1d:	ff 75 d8             	pushl  -0x28(%ebp)
80101d20:	e8 ab e3 ff ff       	call   801000d0 <bread>
80101d25:	89 c3                	mov    %eax,%ebx
    memset(bp->data, 0, BSIZE);
80101d27:	8d 40 5c             	lea    0x5c(%eax),%eax
80101d2a:	83 c4 0c             	add    $0xc,%esp
80101d2d:	68 00 02 00 00       	push   $0x200
80101d32:	6a 00                	push   $0x0
80101d34:	50                   	push   %eax
80101d35:	e8 16 32 00 00       	call   80104f50 <memset>
    log_write(bp);
80101d3a:	89 1c 24             	mov    %ebx,(%esp)
80101d3d:	e8 fe 1a 00 00       	call   80103840 <log_write>
    brelse(bp);
80101d42:	89 1c 24             	mov    %ebx,(%esp)
80101d45:	e8 96 e4 ff ff       	call   801001e0 <brelse>
}
80101d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d4d:	89 f0                	mov    %esi,%eax
80101d4f:	5b                   	pop    %ebx
80101d50:	5e                   	pop    %esi
80101d51:	5f                   	pop    %edi
80101d52:	5d                   	pop    %ebp
80101d53:	c3                   	ret    
80101d54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101d60 <iget>:
}

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode* iget(uint dev, uint inum) {
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	57                   	push   %edi
80101d64:	56                   	push   %esi
80101d65:	53                   	push   %ebx
80101d66:	89 c7                	mov    %eax,%edi
    struct inode *ip, *empty;

    acquire(&icache.lock);

    // Is the inode already cached?
    empty = 0;
80101d68:	31 f6                	xor    %esi,%esi
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101d6a:	bb f4 31 11 80       	mov    $0x801131f4,%ebx
static struct inode* iget(uint dev, uint inum) {
80101d6f:	83 ec 28             	sub    $0x28,%esp
80101d72:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    acquire(&icache.lock);
80101d75:	68 c0 31 11 80       	push   $0x801131c0
80101d7a:	e8 c1 30 00 00       	call   80104e40 <acquire>
80101d7f:	83 c4 10             	add    $0x10,%esp
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101d82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d85:	eb 17                	jmp    80101d9e <iget+0x3e>
80101d87:	89 f6                	mov    %esi,%esi
80101d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101d90:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101d96:	81 fb 14 4e 11 80    	cmp    $0x80114e14,%ebx
80101d9c:	73 22                	jae    80101dc0 <iget+0x60>
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
80101d9e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101da1:	85 c9                	test   %ecx,%ecx
80101da3:	7e 04                	jle    80101da9 <iget+0x49>
80101da5:	39 3b                	cmp    %edi,(%ebx)
80101da7:	74 4f                	je     80101df8 <iget+0x98>
            ip->ref++;
            release(&icache.lock);
            return ip;
        }
        if (empty == 0 && ip->ref == 0) {  // Remember empty slot.
80101da9:	85 f6                	test   %esi,%esi
80101dab:	75 e3                	jne    80101d90 <iget+0x30>
80101dad:	85 c9                	test   %ecx,%ecx
80101daf:	0f 44 f3             	cmove  %ebx,%esi
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101db2:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101db8:	81 fb 14 4e 11 80    	cmp    $0x80114e14,%ebx
80101dbe:	72 de                	jb     80101d9e <iget+0x3e>
            empty = ip;
        }
    }

    // Recycle an inode cache entry.
    if (empty == 0) {
80101dc0:	85 f6                	test   %esi,%esi
80101dc2:	74 5b                	je     80101e1f <iget+0xbf>
    ip = empty;
    ip->dev = dev;
    ip->inum = inum;
    ip->ref = 1;
    ip->valid = 0;
    release(&icache.lock);
80101dc4:	83 ec 0c             	sub    $0xc,%esp
    ip->dev = dev;
80101dc7:	89 3e                	mov    %edi,(%esi)
    ip->inum = inum;
80101dc9:	89 56 04             	mov    %edx,0x4(%esi)
    ip->ref = 1;
80101dcc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
    ip->valid = 0;
80101dd3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
    release(&icache.lock);
80101dda:	68 c0 31 11 80       	push   $0x801131c0
80101ddf:	e8 1c 31 00 00       	call   80104f00 <release>

    return ip;
80101de4:	83 c4 10             	add    $0x10,%esp
}
80101de7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dea:	89 f0                	mov    %esi,%eax
80101dec:	5b                   	pop    %ebx
80101ded:	5e                   	pop    %esi
80101dee:	5f                   	pop    %edi
80101def:	5d                   	pop    %ebp
80101df0:	c3                   	ret    
80101df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
80101df8:	39 53 04             	cmp    %edx,0x4(%ebx)
80101dfb:	75 ac                	jne    80101da9 <iget+0x49>
            release(&icache.lock);
80101dfd:	83 ec 0c             	sub    $0xc,%esp
            ip->ref++;
80101e00:	83 c1 01             	add    $0x1,%ecx
            return ip;
80101e03:	89 de                	mov    %ebx,%esi
            release(&icache.lock);
80101e05:	68 c0 31 11 80       	push   $0x801131c0
            ip->ref++;
80101e0a:	89 4b 08             	mov    %ecx,0x8(%ebx)
            release(&icache.lock);
80101e0d:	e8 ee 30 00 00       	call   80104f00 <release>
            return ip;
80101e12:	83 c4 10             	add    $0x10,%esp
}
80101e15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e18:	89 f0                	mov    %esi,%eax
80101e1a:	5b                   	pop    %ebx
80101e1b:	5e                   	pop    %esi
80101e1c:	5f                   	pop    %edi
80101e1d:	5d                   	pop    %ebp
80101e1e:	c3                   	ret    
        panic("iget: no inodes");
80101e1f:	83 ec 0c             	sub    $0xc,%esp
80101e22:	68 38 7c 10 80       	push   $0x80107c38
80101e27:	e8 b4 e6 ff ff       	call   801004e0 <panic>
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e30 <bmap>:
// are listed in ip->addrs[].  The next NINDIRECT blocks are
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint bmap(struct inode *ip, uint bn) {
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	89 c6                	mov    %eax,%esi
80101e38:	83 ec 1c             	sub    $0x1c,%esp
    uint addr, *a;
    struct buf *bp;

    if (bn < NDIRECT) {
80101e3b:	83 fa 0b             	cmp    $0xb,%edx
80101e3e:	77 18                	ja     80101e58 <bmap+0x28>
80101e40:	8d 3c 90             	lea    (%eax,%edx,4),%edi
        if ((addr = ip->addrs[bn]) == 0) {
80101e43:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101e46:	85 db                	test   %ebx,%ebx
80101e48:	74 76                	je     80101ec0 <bmap+0x90>
        brelse(bp);
        return addr;
    }

    panic("bmap: out of range");
}
80101e4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e4d:	89 d8                	mov    %ebx,%eax
80101e4f:	5b                   	pop    %ebx
80101e50:	5e                   	pop    %esi
80101e51:	5f                   	pop    %edi
80101e52:	5d                   	pop    %ebp
80101e53:	c3                   	ret    
80101e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bn -= NDIRECT;
80101e58:	8d 5a f4             	lea    -0xc(%edx),%ebx
    if (bn < NINDIRECT) {
80101e5b:	83 fb 7f             	cmp    $0x7f,%ebx
80101e5e:	0f 87 90 00 00 00    	ja     80101ef4 <bmap+0xc4>
        if ((addr = ip->addrs[NDIRECT]) == 0) {
80101e64:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101e6a:	8b 00                	mov    (%eax),%eax
80101e6c:	85 d2                	test   %edx,%edx
80101e6e:	74 70                	je     80101ee0 <bmap+0xb0>
        bp = bread(ip->dev, addr);
80101e70:	83 ec 08             	sub    $0x8,%esp
80101e73:	52                   	push   %edx
80101e74:	50                   	push   %eax
80101e75:	e8 56 e2 ff ff       	call   801000d0 <bread>
        if ((addr = a[bn]) == 0) {
80101e7a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
80101e7e:	83 c4 10             	add    $0x10,%esp
        bp = bread(ip->dev, addr);
80101e81:	89 c7                	mov    %eax,%edi
        if ((addr = a[bn]) == 0) {
80101e83:	8b 1a                	mov    (%edx),%ebx
80101e85:	85 db                	test   %ebx,%ebx
80101e87:	75 1d                	jne    80101ea6 <bmap+0x76>
            a[bn] = addr = balloc(ip->dev);
80101e89:	8b 06                	mov    (%esi),%eax
80101e8b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101e8e:	e8 bd fd ff ff       	call   80101c50 <balloc>
80101e93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            log_write(bp);
80101e96:	83 ec 0c             	sub    $0xc,%esp
            a[bn] = addr = balloc(ip->dev);
80101e99:	89 c3                	mov    %eax,%ebx
80101e9b:	89 02                	mov    %eax,(%edx)
            log_write(bp);
80101e9d:	57                   	push   %edi
80101e9e:	e8 9d 19 00 00       	call   80103840 <log_write>
80101ea3:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101ea6:	83 ec 0c             	sub    $0xc,%esp
80101ea9:	57                   	push   %edi
80101eaa:	e8 31 e3 ff ff       	call   801001e0 <brelse>
80101eaf:	83 c4 10             	add    $0x10,%esp
}
80101eb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb5:	89 d8                	mov    %ebx,%eax
80101eb7:	5b                   	pop    %ebx
80101eb8:	5e                   	pop    %esi
80101eb9:	5f                   	pop    %edi
80101eba:	5d                   	pop    %ebp
80101ebb:	c3                   	ret    
80101ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            ip->addrs[bn] = addr = balloc(ip->dev);
80101ec0:	8b 00                	mov    (%eax),%eax
80101ec2:	e8 89 fd ff ff       	call   80101c50 <balloc>
80101ec7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
80101eca:	8d 65 f4             	lea    -0xc(%ebp),%esp
            ip->addrs[bn] = addr = balloc(ip->dev);
80101ecd:	89 c3                	mov    %eax,%ebx
}
80101ecf:	89 d8                	mov    %ebx,%eax
80101ed1:	5b                   	pop    %ebx
80101ed2:	5e                   	pop    %esi
80101ed3:	5f                   	pop    %edi
80101ed4:	5d                   	pop    %ebp
80101ed5:	c3                   	ret    
80101ed6:	8d 76 00             	lea    0x0(%esi),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101ee0:	e8 6b fd ff ff       	call   80101c50 <balloc>
80101ee5:	89 c2                	mov    %eax,%edx
80101ee7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101eed:	8b 06                	mov    (%esi),%eax
80101eef:	e9 7c ff ff ff       	jmp    80101e70 <bmap+0x40>
    panic("bmap: out of range");
80101ef4:	83 ec 0c             	sub    $0xc,%esp
80101ef7:	68 48 7c 10 80       	push   $0x80107c48
80101efc:	e8 df e5 ff ff       	call   801004e0 <panic>
80101f01:	eb 0d                	jmp    80101f10 <readsb>
80101f03:	90                   	nop
80101f04:	90                   	nop
80101f05:	90                   	nop
80101f06:	90                   	nop
80101f07:	90                   	nop
80101f08:	90                   	nop
80101f09:	90                   	nop
80101f0a:	90                   	nop
80101f0b:	90                   	nop
80101f0c:	90                   	nop
80101f0d:	90                   	nop
80101f0e:	90                   	nop
80101f0f:	90                   	nop

80101f10 <readsb>:
void readsb(int dev, struct superblock *sb) {
80101f10:	55                   	push   %ebp
80101f11:	89 e5                	mov    %esp,%ebp
80101f13:	56                   	push   %esi
80101f14:	53                   	push   %ebx
80101f15:	8b 75 0c             	mov    0xc(%ebp),%esi
    bp = bread(dev, 1);
80101f18:	83 ec 08             	sub    $0x8,%esp
80101f1b:	6a 01                	push   $0x1
80101f1d:	ff 75 08             	pushl  0x8(%ebp)
80101f20:	e8 ab e1 ff ff       	call   801000d0 <bread>
80101f25:	89 c3                	mov    %eax,%ebx
    memmove(sb, bp->data, sizeof(*sb));
80101f27:	8d 40 5c             	lea    0x5c(%eax),%eax
80101f2a:	83 c4 0c             	add    $0xc,%esp
80101f2d:	6a 1c                	push   $0x1c
80101f2f:	50                   	push   %eax
80101f30:	56                   	push   %esi
80101f31:	e8 ca 30 00 00       	call   80105000 <memmove>
    brelse(bp);
80101f36:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f3f:	5b                   	pop    %ebx
80101f40:	5e                   	pop    %esi
80101f41:	5d                   	pop    %ebp
    brelse(bp);
80101f42:	e9 99 e2 ff ff       	jmp    801001e0 <brelse>
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f50 <iinit>:
void iinit(int dev) {
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	53                   	push   %ebx
80101f54:	bb 00 32 11 80       	mov    $0x80113200,%ebx
80101f59:	83 ec 0c             	sub    $0xc,%esp
    initlock(&icache.lock, "icache");
80101f5c:	68 5b 7c 10 80       	push   $0x80107c5b
80101f61:	68 c0 31 11 80       	push   $0x801131c0
80101f66:	e8 95 2d 00 00       	call   80104d00 <initlock>
80101f6b:	83 c4 10             	add    $0x10,%esp
80101f6e:	66 90                	xchg   %ax,%ax
        initsleeplock(&icache.inode[i].lock, "inode");
80101f70:	83 ec 08             	sub    $0x8,%esp
80101f73:	68 62 7c 10 80       	push   $0x80107c62
80101f78:	53                   	push   %ebx
80101f79:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101f7f:	e8 4c 2c 00 00       	call   80104bd0 <initsleeplock>
    for (i = 0; i < NINODE; i++) {
80101f84:	83 c4 10             	add    $0x10,%esp
80101f87:	81 fb 20 4e 11 80    	cmp    $0x80114e20,%ebx
80101f8d:	75 e1                	jne    80101f70 <iinit+0x20>
    readsb(dev, &sb);
80101f8f:	83 ec 08             	sub    $0x8,%esp
80101f92:	68 a0 31 11 80       	push   $0x801131a0
80101f97:	ff 75 08             	pushl  0x8(%ebp)
80101f9a:	e8 71 ff ff ff       	call   80101f10 <readsb>
    cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101f9f:	ff 35 b8 31 11 80    	pushl  0x801131b8
80101fa5:	ff 35 b4 31 11 80    	pushl  0x801131b4
80101fab:	ff 35 b0 31 11 80    	pushl  0x801131b0
80101fb1:	ff 35 ac 31 11 80    	pushl  0x801131ac
80101fb7:	ff 35 a8 31 11 80    	pushl  0x801131a8
80101fbd:	ff 35 a4 31 11 80    	pushl  0x801131a4
80101fc3:	ff 35 a0 31 11 80    	pushl  0x801131a0
80101fc9:	68 c8 7c 10 80       	push   $0x80107cc8
80101fce:	e8 8d e8 ff ff       	call   80100860 <cprintf>
}
80101fd3:	83 c4 30             	add    $0x30,%esp
80101fd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101fd9:	c9                   	leave  
80101fda:	c3                   	ret    
80101fdb:	90                   	nop
80101fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <ialloc>:
struct inode* ialloc(uint dev, short type) {
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 1c             	sub    $0x1c,%esp
    for (inum = 1; inum < sb.ninodes; inum++) {
80101fe9:	83 3d a8 31 11 80 01 	cmpl   $0x1,0x801131a8
struct inode* ialloc(uint dev, short type) {
80101ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ff3:	8b 75 08             	mov    0x8(%ebp),%esi
80101ff6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (inum = 1; inum < sb.ninodes; inum++) {
80101ff9:	0f 86 91 00 00 00    	jbe    80102090 <ialloc+0xb0>
80101fff:	bb 01 00 00 00       	mov    $0x1,%ebx
80102004:	eb 21                	jmp    80102027 <ialloc+0x47>
80102006:	8d 76 00             	lea    0x0(%esi),%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        brelse(bp);
80102010:	83 ec 0c             	sub    $0xc,%esp
    for (inum = 1; inum < sb.ninodes; inum++) {
80102013:	83 c3 01             	add    $0x1,%ebx
        brelse(bp);
80102016:	57                   	push   %edi
80102017:	e8 c4 e1 ff ff       	call   801001e0 <brelse>
    for (inum = 1; inum < sb.ninodes; inum++) {
8010201c:	83 c4 10             	add    $0x10,%esp
8010201f:	39 1d a8 31 11 80    	cmp    %ebx,0x801131a8
80102025:	76 69                	jbe    80102090 <ialloc+0xb0>
        bp = bread(dev, IBLOCK(inum, sb));
80102027:	89 d8                	mov    %ebx,%eax
80102029:	83 ec 08             	sub    $0x8,%esp
8010202c:	c1 e8 03             	shr    $0x3,%eax
8010202f:	03 05 b4 31 11 80    	add    0x801131b4,%eax
80102035:	50                   	push   %eax
80102036:	56                   	push   %esi
80102037:	e8 94 e0 ff ff       	call   801000d0 <bread>
8010203c:	89 c7                	mov    %eax,%edi
        dip = (struct dinode*)bp->data + inum % IPB;
8010203e:	89 d8                	mov    %ebx,%eax
        if (dip->type == 0) { // a free inode
80102040:	83 c4 10             	add    $0x10,%esp
        dip = (struct dinode*)bp->data + inum % IPB;
80102043:	83 e0 07             	and    $0x7,%eax
80102046:	c1 e0 06             	shl    $0x6,%eax
80102049:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
        if (dip->type == 0) { // a free inode
8010204d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80102051:	75 bd                	jne    80102010 <ialloc+0x30>
            memset(dip, 0, sizeof(*dip));
80102053:	83 ec 04             	sub    $0x4,%esp
80102056:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80102059:	6a 40                	push   $0x40
8010205b:	6a 00                	push   $0x0
8010205d:	51                   	push   %ecx
8010205e:	e8 ed 2e 00 00       	call   80104f50 <memset>
            dip->type = type;
80102063:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80102067:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010206a:	66 89 01             	mov    %ax,(%ecx)
            log_write(bp);   // mark it allocated on the disk
8010206d:	89 3c 24             	mov    %edi,(%esp)
80102070:	e8 cb 17 00 00       	call   80103840 <log_write>
            brelse(bp);
80102075:	89 3c 24             	mov    %edi,(%esp)
80102078:	e8 63 e1 ff ff       	call   801001e0 <brelse>
            return iget(dev, inum);
8010207d:	83 c4 10             	add    $0x10,%esp
}
80102080:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return iget(dev, inum);
80102083:	89 da                	mov    %ebx,%edx
80102085:	89 f0                	mov    %esi,%eax
}
80102087:	5b                   	pop    %ebx
80102088:	5e                   	pop    %esi
80102089:	5f                   	pop    %edi
8010208a:	5d                   	pop    %ebp
            return iget(dev, inum);
8010208b:	e9 d0 fc ff ff       	jmp    80101d60 <iget>
    panic("ialloc: no inodes");
80102090:	83 ec 0c             	sub    $0xc,%esp
80102093:	68 68 7c 10 80       	push   $0x80107c68
80102098:	e8 43 e4 ff ff       	call   801004e0 <panic>
8010209d:	8d 76 00             	lea    0x0(%esi),%esi

801020a0 <iupdate>:
void iupdate(struct inode *ip) {
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	56                   	push   %esi
801020a4:	53                   	push   %ebx
801020a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801020a8:	83 ec 08             	sub    $0x8,%esp
801020ab:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801020ae:	83 c3 5c             	add    $0x5c,%ebx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801020b1:	c1 e8 03             	shr    $0x3,%eax
801020b4:	03 05 b4 31 11 80    	add    0x801131b4,%eax
801020ba:	50                   	push   %eax
801020bb:	ff 73 a4             	pushl  -0x5c(%ebx)
801020be:	e8 0d e0 ff ff       	call   801000d0 <bread>
801020c3:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum % IPB;
801020c5:	8b 43 a8             	mov    -0x58(%ebx),%eax
    dip->type = ip->type;
801020c8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801020cc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum % IPB;
801020cf:	83 e0 07             	and    $0x7,%eax
801020d2:	c1 e0 06             	shl    $0x6,%eax
801020d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    dip->type = ip->type;
801020d9:	66 89 10             	mov    %dx,(%eax)
    dip->major = ip->major;
801020dc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801020e0:	83 c0 0c             	add    $0xc,%eax
    dip->major = ip->major;
801020e3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
    dip->minor = ip->minor;
801020e7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801020eb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
    dip->nlink = ip->nlink;
801020ef:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801020f3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
    dip->size = ip->size;
801020f7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801020fa:	89 50 fc             	mov    %edx,-0x4(%eax)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801020fd:	6a 34                	push   $0x34
801020ff:	53                   	push   %ebx
80102100:	50                   	push   %eax
80102101:	e8 fa 2e 00 00       	call   80105000 <memmove>
    log_write(bp);
80102106:	89 34 24             	mov    %esi,(%esp)
80102109:	e8 32 17 00 00       	call   80103840 <log_write>
    brelse(bp);
8010210e:	89 75 08             	mov    %esi,0x8(%ebp)
80102111:	83 c4 10             	add    $0x10,%esp
}
80102114:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102117:	5b                   	pop    %ebx
80102118:	5e                   	pop    %esi
80102119:	5d                   	pop    %ebp
    brelse(bp);
8010211a:	e9 c1 e0 ff ff       	jmp    801001e0 <brelse>
8010211f:	90                   	nop

80102120 <idup>:
struct inode* idup(struct inode *ip) {
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	53                   	push   %ebx
80102124:	83 ec 10             	sub    $0x10,%esp
80102127:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&icache.lock);
8010212a:	68 c0 31 11 80       	push   $0x801131c0
8010212f:	e8 0c 2d 00 00       	call   80104e40 <acquire>
    ip->ref++;
80102134:	83 43 08 01          	addl   $0x1,0x8(%ebx)
    release(&icache.lock);
80102138:	c7 04 24 c0 31 11 80 	movl   $0x801131c0,(%esp)
8010213f:	e8 bc 2d 00 00       	call   80104f00 <release>
}
80102144:	89 d8                	mov    %ebx,%eax
80102146:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102149:	c9                   	leave  
8010214a:	c3                   	ret    
8010214b:	90                   	nop
8010214c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102150 <ilock>:
void ilock(struct inode *ip) {
80102150:	55                   	push   %ebp
80102151:	89 e5                	mov    %esp,%ebp
80102153:	56                   	push   %esi
80102154:	53                   	push   %ebx
80102155:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (ip == 0 || ip->ref < 1) {
80102158:	85 db                	test   %ebx,%ebx
8010215a:	0f 84 b7 00 00 00    	je     80102217 <ilock+0xc7>
80102160:	8b 53 08             	mov    0x8(%ebx),%edx
80102163:	85 d2                	test   %edx,%edx
80102165:	0f 8e ac 00 00 00    	jle    80102217 <ilock+0xc7>
    acquiresleep(&ip->lock);
8010216b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010216e:	83 ec 0c             	sub    $0xc,%esp
80102171:	50                   	push   %eax
80102172:	e8 99 2a 00 00       	call   80104c10 <acquiresleep>
    if (ip->valid == 0) {
80102177:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010217a:	83 c4 10             	add    $0x10,%esp
8010217d:	85 c0                	test   %eax,%eax
8010217f:	74 0f                	je     80102190 <ilock+0x40>
}
80102181:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102184:	5b                   	pop    %ebx
80102185:	5e                   	pop    %esi
80102186:	5d                   	pop    %ebp
80102187:	c3                   	ret    
80102188:	90                   	nop
80102189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80102190:	8b 43 04             	mov    0x4(%ebx),%eax
80102193:	83 ec 08             	sub    $0x8,%esp
80102196:	c1 e8 03             	shr    $0x3,%eax
80102199:	03 05 b4 31 11 80    	add    0x801131b4,%eax
8010219f:	50                   	push   %eax
801021a0:	ff 33                	pushl  (%ebx)
801021a2:	e8 29 df ff ff       	call   801000d0 <bread>
801021a7:	89 c6                	mov    %eax,%esi
        dip = (struct dinode*)bp->data + ip->inum % IPB;
801021a9:	8b 43 04             	mov    0x4(%ebx),%eax
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801021ac:	83 c4 0c             	add    $0xc,%esp
        dip = (struct dinode*)bp->data + ip->inum % IPB;
801021af:	83 e0 07             	and    $0x7,%eax
801021b2:	c1 e0 06             	shl    $0x6,%eax
801021b5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
        ip->type = dip->type;
801021b9:	0f b7 10             	movzwl (%eax),%edx
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801021bc:	83 c0 0c             	add    $0xc,%eax
        ip->type = dip->type;
801021bf:	66 89 53 50          	mov    %dx,0x50(%ebx)
        ip->major = dip->major;
801021c3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801021c7:	66 89 53 52          	mov    %dx,0x52(%ebx)
        ip->minor = dip->minor;
801021cb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801021cf:	66 89 53 54          	mov    %dx,0x54(%ebx)
        ip->nlink = dip->nlink;
801021d3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801021d7:	66 89 53 56          	mov    %dx,0x56(%ebx)
        ip->size = dip->size;
801021db:	8b 50 fc             	mov    -0x4(%eax),%edx
801021de:	89 53 58             	mov    %edx,0x58(%ebx)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801021e1:	6a 34                	push   $0x34
801021e3:	50                   	push   %eax
801021e4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801021e7:	50                   	push   %eax
801021e8:	e8 13 2e 00 00       	call   80105000 <memmove>
        brelse(bp);
801021ed:	89 34 24             	mov    %esi,(%esp)
801021f0:	e8 eb df ff ff       	call   801001e0 <brelse>
        if (ip->type == 0) {
801021f5:	83 c4 10             	add    $0x10,%esp
801021f8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
        ip->valid = 1;
801021fd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
        if (ip->type == 0) {
80102204:	0f 85 77 ff ff ff    	jne    80102181 <ilock+0x31>
            panic("ilock: no type");
8010220a:	83 ec 0c             	sub    $0xc,%esp
8010220d:	68 80 7c 10 80       	push   $0x80107c80
80102212:	e8 c9 e2 ff ff       	call   801004e0 <panic>
        panic("ilock");
80102217:	83 ec 0c             	sub    $0xc,%esp
8010221a:	68 7a 7c 10 80       	push   $0x80107c7a
8010221f:	e8 bc e2 ff ff       	call   801004e0 <panic>
80102224:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010222a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102230 <iunlock>:
void iunlock(struct inode *ip) {
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	56                   	push   %esi
80102234:	53                   	push   %ebx
80102235:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) {
80102238:	85 db                	test   %ebx,%ebx
8010223a:	74 28                	je     80102264 <iunlock+0x34>
8010223c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010223f:	83 ec 0c             	sub    $0xc,%esp
80102242:	56                   	push   %esi
80102243:	e8 68 2a 00 00       	call   80104cb0 <holdingsleep>
80102248:	83 c4 10             	add    $0x10,%esp
8010224b:	85 c0                	test   %eax,%eax
8010224d:	74 15                	je     80102264 <iunlock+0x34>
8010224f:	8b 43 08             	mov    0x8(%ebx),%eax
80102252:	85 c0                	test   %eax,%eax
80102254:	7e 0e                	jle    80102264 <iunlock+0x34>
    releasesleep(&ip->lock);
80102256:	89 75 08             	mov    %esi,0x8(%ebp)
}
80102259:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010225c:	5b                   	pop    %ebx
8010225d:	5e                   	pop    %esi
8010225e:	5d                   	pop    %ebp
    releasesleep(&ip->lock);
8010225f:	e9 0c 2a 00 00       	jmp    80104c70 <releasesleep>
        panic("iunlock");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 8f 7c 10 80       	push   $0x80107c8f
8010226c:	e8 6f e2 ff ff       	call   801004e0 <panic>
80102271:	eb 0d                	jmp    80102280 <iput>
80102273:	90                   	nop
80102274:	90                   	nop
80102275:	90                   	nop
80102276:	90                   	nop
80102277:	90                   	nop
80102278:	90                   	nop
80102279:	90                   	nop
8010227a:	90                   	nop
8010227b:	90                   	nop
8010227c:	90                   	nop
8010227d:	90                   	nop
8010227e:	90                   	nop
8010227f:	90                   	nop

80102280 <iput>:
void iput(struct inode *ip) {
80102280:	55                   	push   %ebp
80102281:	89 e5                	mov    %esp,%ebp
80102283:	57                   	push   %edi
80102284:	56                   	push   %esi
80102285:	53                   	push   %ebx
80102286:	83 ec 28             	sub    $0x28,%esp
80102289:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquiresleep(&ip->lock);
8010228c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010228f:	57                   	push   %edi
80102290:	e8 7b 29 00 00       	call   80104c10 <acquiresleep>
    if (ip->valid && ip->nlink == 0) {
80102295:	8b 53 4c             	mov    0x4c(%ebx),%edx
80102298:	83 c4 10             	add    $0x10,%esp
8010229b:	85 d2                	test   %edx,%edx
8010229d:	74 07                	je     801022a6 <iput+0x26>
8010229f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801022a4:	74 32                	je     801022d8 <iput+0x58>
    releasesleep(&ip->lock);
801022a6:	83 ec 0c             	sub    $0xc,%esp
801022a9:	57                   	push   %edi
801022aa:	e8 c1 29 00 00       	call   80104c70 <releasesleep>
    acquire(&icache.lock);
801022af:	c7 04 24 c0 31 11 80 	movl   $0x801131c0,(%esp)
801022b6:	e8 85 2b 00 00       	call   80104e40 <acquire>
    ip->ref--;
801022bb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
    release(&icache.lock);
801022bf:	83 c4 10             	add    $0x10,%esp
801022c2:	c7 45 08 c0 31 11 80 	movl   $0x801131c0,0x8(%ebp)
}
801022c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022cc:	5b                   	pop    %ebx
801022cd:	5e                   	pop    %esi
801022ce:	5f                   	pop    %edi
801022cf:	5d                   	pop    %ebp
    release(&icache.lock);
801022d0:	e9 2b 2c 00 00       	jmp    80104f00 <release>
801022d5:	8d 76 00             	lea    0x0(%esi),%esi
        acquire(&icache.lock);
801022d8:	83 ec 0c             	sub    $0xc,%esp
801022db:	68 c0 31 11 80       	push   $0x801131c0
801022e0:	e8 5b 2b 00 00       	call   80104e40 <acquire>
        int r = ip->ref;
801022e5:	8b 73 08             	mov    0x8(%ebx),%esi
        release(&icache.lock);
801022e8:	c7 04 24 c0 31 11 80 	movl   $0x801131c0,(%esp)
801022ef:	e8 0c 2c 00 00       	call   80104f00 <release>
        if (r == 1) {
801022f4:	83 c4 10             	add    $0x10,%esp
801022f7:	83 fe 01             	cmp    $0x1,%esi
801022fa:	75 aa                	jne    801022a6 <iput+0x26>
801022fc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80102302:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80102305:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102308:	89 cf                	mov    %ecx,%edi
8010230a:	eb 0b                	jmp    80102317 <iput+0x97>
8010230c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102310:	83 c6 04             	add    $0x4,%esi
static void itrunc(struct inode *ip) {
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++) {
80102313:	39 fe                	cmp    %edi,%esi
80102315:	74 19                	je     80102330 <iput+0xb0>
        if (ip->addrs[i]) {
80102317:	8b 16                	mov    (%esi),%edx
80102319:	85 d2                	test   %edx,%edx
8010231b:	74 f3                	je     80102310 <iput+0x90>
            bfree(ip->dev, ip->addrs[i]);
8010231d:	8b 03                	mov    (%ebx),%eax
8010231f:	e8 bc f8 ff ff       	call   80101be0 <bfree>
            ip->addrs[i] = 0;
80102324:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010232a:	eb e4                	jmp    80102310 <iput+0x90>
8010232c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        }
    }

    if (ip->addrs[NDIRECT]) {
80102330:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80102336:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80102339:	85 c0                	test   %eax,%eax
8010233b:	75 33                	jne    80102370 <iput+0xf0>
        bfree(ip->dev, ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    iupdate(ip);
8010233d:	83 ec 0c             	sub    $0xc,%esp
    ip->size = 0;
80102340:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
    iupdate(ip);
80102347:	53                   	push   %ebx
80102348:	e8 53 fd ff ff       	call   801020a0 <iupdate>
            ip->type = 0;
8010234d:	31 c0                	xor    %eax,%eax
8010234f:	66 89 43 50          	mov    %ax,0x50(%ebx)
            iupdate(ip);
80102353:	89 1c 24             	mov    %ebx,(%esp)
80102356:	e8 45 fd ff ff       	call   801020a0 <iupdate>
            ip->valid = 0;
8010235b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80102362:	83 c4 10             	add    $0x10,%esp
80102365:	e9 3c ff ff ff       	jmp    801022a6 <iput+0x26>
8010236a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        bp = bread(ip->dev, ip->addrs[NDIRECT]);
80102370:	83 ec 08             	sub    $0x8,%esp
80102373:	50                   	push   %eax
80102374:	ff 33                	pushl  (%ebx)
80102376:	e8 55 dd ff ff       	call   801000d0 <bread>
8010237b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80102381:	89 7d e0             	mov    %edi,-0x20(%ebp)
80102384:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        a = (uint*)bp->data;
80102387:	8d 70 5c             	lea    0x5c(%eax),%esi
8010238a:	83 c4 10             	add    $0x10,%esp
8010238d:	89 cf                	mov    %ecx,%edi
8010238f:	eb 0e                	jmp    8010239f <iput+0x11f>
80102391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102398:	83 c6 04             	add    $0x4,%esi
        for (j = 0; j < NINDIRECT; j++) {
8010239b:	39 fe                	cmp    %edi,%esi
8010239d:	74 0f                	je     801023ae <iput+0x12e>
            if (a[j]) {
8010239f:	8b 16                	mov    (%esi),%edx
801023a1:	85 d2                	test   %edx,%edx
801023a3:	74 f3                	je     80102398 <iput+0x118>
                bfree(ip->dev, a[j]);
801023a5:	8b 03                	mov    (%ebx),%eax
801023a7:	e8 34 f8 ff ff       	call   80101be0 <bfree>
801023ac:	eb ea                	jmp    80102398 <iput+0x118>
        brelse(bp);
801023ae:	83 ec 0c             	sub    $0xc,%esp
801023b1:	ff 75 e4             	pushl  -0x1c(%ebp)
801023b4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801023b7:	e8 24 de ff ff       	call   801001e0 <brelse>
        bfree(ip->dev, ip->addrs[NDIRECT]);
801023bc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801023c2:	8b 03                	mov    (%ebx),%eax
801023c4:	e8 17 f8 ff ff       	call   80101be0 <bfree>
        ip->addrs[NDIRECT] = 0;
801023c9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801023d0:	00 00 00 
801023d3:	83 c4 10             	add    $0x10,%esp
801023d6:	e9 62 ff ff ff       	jmp    8010233d <iput+0xbd>
801023db:	90                   	nop
801023dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023e0 <iunlockput>:
void iunlockput(struct inode *ip) {
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	53                   	push   %ebx
801023e4:	83 ec 10             	sub    $0x10,%esp
801023e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    iunlock(ip);
801023ea:	53                   	push   %ebx
801023eb:	e8 40 fe ff ff       	call   80102230 <iunlock>
    iput(ip);
801023f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801023f3:	83 c4 10             	add    $0x10,%esp
}
801023f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023f9:	c9                   	leave  
    iput(ip);
801023fa:	e9 81 fe ff ff       	jmp    80102280 <iput>
801023ff:	90                   	nop

80102400 <stati>:
}

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st) {
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	8b 55 08             	mov    0x8(%ebp),%edx
80102406:	8b 45 0c             	mov    0xc(%ebp),%eax
    st->dev = ip->dev;
80102409:	8b 0a                	mov    (%edx),%ecx
8010240b:	89 48 04             	mov    %ecx,0x4(%eax)
    st->ino = ip->inum;
8010240e:	8b 4a 04             	mov    0x4(%edx),%ecx
80102411:	89 48 08             	mov    %ecx,0x8(%eax)
    st->type = ip->type;
80102414:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80102418:	66 89 08             	mov    %cx,(%eax)
    st->nlink = ip->nlink;
8010241b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010241f:	66 89 48 0c          	mov    %cx,0xc(%eax)
    st->size = ip->size;
80102423:	8b 52 58             	mov    0x58(%edx),%edx
80102426:	89 50 10             	mov    %edx,0x10(%eax)
}
80102429:	5d                   	pop    %ebp
8010242a:	c3                   	ret    
8010242b:	90                   	nop
8010242c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102430 <readi>:


// Read data from inode.
// Caller must hold ip->lock.
int readi(struct inode *ip, char *dst, uint off, uint n) {
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	57                   	push   %edi
80102434:	56                   	push   %esi
80102435:	53                   	push   %ebx
80102436:	83 ec 1c             	sub    $0x1c,%esp
80102439:	8b 45 08             	mov    0x8(%ebp),%eax
8010243c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010243f:	8b 7d 14             	mov    0x14(%ebp),%edi
    uint tot, m;
    struct buf *bp;

    if (ip->type == T_DEV) {
80102442:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
int readi(struct inode *ip, char *dst, uint off, uint n) {
80102447:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010244a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010244d:	8b 75 10             	mov    0x10(%ebp),%esi
80102450:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    if (ip->type == T_DEV) {
80102453:	0f 84 a7 00 00 00    	je     80102500 <readi+0xd0>
            return -1;
        }
        return devsw[ip->major].read(ip, dst, n);
    }

    if (off > ip->size || off + n < off) {
80102459:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010245c:	8b 40 58             	mov    0x58(%eax),%eax
8010245f:	39 c6                	cmp    %eax,%esi
80102461:	0f 87 ba 00 00 00    	ja     80102521 <readi+0xf1>
80102467:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010246a:	89 f9                	mov    %edi,%ecx
8010246c:	01 f1                	add    %esi,%ecx
8010246e:	0f 82 ad 00 00 00    	jb     80102521 <readi+0xf1>
        return -1;
    }
    if (off + n > ip->size) {
        n = ip->size - off;
80102474:	89 c2                	mov    %eax,%edx
80102476:	29 f2                	sub    %esi,%edx
80102478:	39 c8                	cmp    %ecx,%eax
8010247a:	0f 43 d7             	cmovae %edi,%edx
    }

    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
8010247d:	31 ff                	xor    %edi,%edi
8010247f:	85 d2                	test   %edx,%edx
        n = ip->size - off;
80102481:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80102484:	74 6c                	je     801024f2 <readi+0xc2>
80102486:	8d 76 00             	lea    0x0(%esi),%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80102490:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102493:	89 f2                	mov    %esi,%edx
80102495:	c1 ea 09             	shr    $0x9,%edx
80102498:	89 d8                	mov    %ebx,%eax
8010249a:	e8 91 f9 ff ff       	call   80101e30 <bmap>
8010249f:	83 ec 08             	sub    $0x8,%esp
801024a2:	50                   	push   %eax
801024a3:	ff 33                	pushl  (%ebx)
801024a5:	e8 26 dc ff ff       	call   801000d0 <bread>
        m = min(n - tot, BSIZE - off % BSIZE);
801024aa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
801024ad:	89 c2                	mov    %eax,%edx
        m = min(n - tot, BSIZE - off % BSIZE);
801024af:	89 f0                	mov    %esi,%eax
801024b1:	25 ff 01 00 00       	and    $0x1ff,%eax
801024b6:	b9 00 02 00 00       	mov    $0x200,%ecx
801024bb:	83 c4 0c             	add    $0xc,%esp
801024be:	29 c1                	sub    %eax,%ecx
        memmove(dst, bp->data + off % BSIZE, m);
801024c0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801024c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
        m = min(n - tot, BSIZE - off % BSIZE);
801024c7:	29 fb                	sub    %edi,%ebx
801024c9:	39 d9                	cmp    %ebx,%ecx
801024cb:	0f 46 d9             	cmovbe %ecx,%ebx
        memmove(dst, bp->data + off % BSIZE, m);
801024ce:	53                   	push   %ebx
801024cf:	50                   	push   %eax
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
801024d0:	01 df                	add    %ebx,%edi
        memmove(dst, bp->data + off % BSIZE, m);
801024d2:	ff 75 e0             	pushl  -0x20(%ebp)
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
801024d5:	01 de                	add    %ebx,%esi
        memmove(dst, bp->data + off % BSIZE, m);
801024d7:	e8 24 2b 00 00       	call   80105000 <memmove>
        brelse(bp);
801024dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
801024df:	89 14 24             	mov    %edx,(%esp)
801024e2:	e8 f9 dc ff ff       	call   801001e0 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
801024e7:	01 5d e0             	add    %ebx,-0x20(%ebp)
801024ea:	83 c4 10             	add    $0x10,%esp
801024ed:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801024f0:	77 9e                	ja     80102490 <readi+0x60>
    }
    return n;
801024f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801024f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024f8:	5b                   	pop    %ebx
801024f9:	5e                   	pop    %esi
801024fa:	5f                   	pop    %edi
801024fb:	5d                   	pop    %ebp
801024fc:	c3                   	ret    
801024fd:	8d 76 00             	lea    0x0(%esi),%esi
        if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read) {
80102500:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102504:	66 83 f8 09          	cmp    $0x9,%ax
80102508:	77 17                	ja     80102521 <readi+0xf1>
8010250a:	8b 04 c5 40 31 11 80 	mov    -0x7feecec0(,%eax,8),%eax
80102511:	85 c0                	test   %eax,%eax
80102513:	74 0c                	je     80102521 <readi+0xf1>
        return devsw[ip->major].read(ip, dst, n);
80102515:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102518:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010251b:	5b                   	pop    %ebx
8010251c:	5e                   	pop    %esi
8010251d:	5f                   	pop    %edi
8010251e:	5d                   	pop    %ebp
        return devsw[ip->major].read(ip, dst, n);
8010251f:	ff e0                	jmp    *%eax
            return -1;
80102521:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102526:	eb cd                	jmp    801024f5 <readi+0xc5>
80102528:	90                   	nop
80102529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102530 <writei>:

// Write data to inode.
// Caller must hold ip->lock.
int writei(struct inode *ip, char *src, uint off, uint n) {
80102530:	55                   	push   %ebp
80102531:	89 e5                	mov    %esp,%ebp
80102533:	57                   	push   %edi
80102534:	56                   	push   %esi
80102535:	53                   	push   %ebx
80102536:	83 ec 1c             	sub    $0x1c,%esp
80102539:	8b 45 08             	mov    0x8(%ebp),%eax
8010253c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010253f:	8b 7d 14             	mov    0x14(%ebp),%edi
    uint tot, m;
    struct buf *bp;

    if (ip->type == T_DEV) {
80102542:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
int writei(struct inode *ip, char *src, uint off, uint n) {
80102547:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010254a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010254d:	8b 75 10             	mov    0x10(%ebp),%esi
80102550:	89 7d e0             	mov    %edi,-0x20(%ebp)
    if (ip->type == T_DEV) {
80102553:	0f 84 b7 00 00 00    	je     80102610 <writei+0xe0>
            return -1;
        }
        return devsw[ip->major].write(ip, src, n);
    }

    if (off > ip->size || off + n < off) {
80102559:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010255c:	39 70 58             	cmp    %esi,0x58(%eax)
8010255f:	0f 82 eb 00 00 00    	jb     80102650 <writei+0x120>
80102565:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102568:	31 d2                	xor    %edx,%edx
8010256a:	89 f8                	mov    %edi,%eax
8010256c:	01 f0                	add    %esi,%eax
8010256e:	0f 92 c2             	setb   %dl
        return -1;
    }
    if (off + n > MAXFILE * BSIZE) {
80102571:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102576:	0f 87 d4 00 00 00    	ja     80102650 <writei+0x120>
8010257c:	85 d2                	test   %edx,%edx
8010257e:	0f 85 cc 00 00 00    	jne    80102650 <writei+0x120>
        return -1;
    }

    for (tot = 0; tot < n; tot += m, off += m, src += m) {
80102584:	85 ff                	test   %edi,%edi
80102586:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010258d:	74 72                	je     80102601 <writei+0xd1>
8010258f:	90                   	nop
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80102590:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102593:	89 f2                	mov    %esi,%edx
80102595:	c1 ea 09             	shr    $0x9,%edx
80102598:	89 f8                	mov    %edi,%eax
8010259a:	e8 91 f8 ff ff       	call   80101e30 <bmap>
8010259f:	83 ec 08             	sub    $0x8,%esp
801025a2:	50                   	push   %eax
801025a3:	ff 37                	pushl  (%edi)
801025a5:	e8 26 db ff ff       	call   801000d0 <bread>
        m = min(n - tot, BSIZE - off % BSIZE);
801025aa:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801025ad:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
801025b0:	89 c7                	mov    %eax,%edi
        m = min(n - tot, BSIZE - off % BSIZE);
801025b2:	89 f0                	mov    %esi,%eax
801025b4:	b9 00 02 00 00       	mov    $0x200,%ecx
801025b9:	83 c4 0c             	add    $0xc,%esp
801025bc:	25 ff 01 00 00       	and    $0x1ff,%eax
801025c1:	29 c1                	sub    %eax,%ecx
        memmove(bp->data + off % BSIZE, src, m);
801025c3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
        m = min(n - tot, BSIZE - off % BSIZE);
801025c7:	39 d9                	cmp    %ebx,%ecx
801025c9:	0f 46 d9             	cmovbe %ecx,%ebx
        memmove(bp->data + off % BSIZE, src, m);
801025cc:	53                   	push   %ebx
801025cd:	ff 75 dc             	pushl  -0x24(%ebp)
    for (tot = 0; tot < n; tot += m, off += m, src += m) {
801025d0:	01 de                	add    %ebx,%esi
        memmove(bp->data + off % BSIZE, src, m);
801025d2:	50                   	push   %eax
801025d3:	e8 28 2a 00 00       	call   80105000 <memmove>
        log_write(bp);
801025d8:	89 3c 24             	mov    %edi,(%esp)
801025db:	e8 60 12 00 00       	call   80103840 <log_write>
        brelse(bp);
801025e0:	89 3c 24             	mov    %edi,(%esp)
801025e3:	e8 f8 db ff ff       	call   801001e0 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, src += m) {
801025e8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801025eb:	01 5d dc             	add    %ebx,-0x24(%ebp)
801025ee:	83 c4 10             	add    $0x10,%esp
801025f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801025f4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
801025f7:	77 97                	ja     80102590 <writei+0x60>
    }

    if (n > 0 && off > ip->size) {
801025f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801025fc:	3b 70 58             	cmp    0x58(%eax),%esi
801025ff:	77 37                	ja     80102638 <writei+0x108>
        ip->size = off;
        iupdate(ip);
    }
    return n;
80102601:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102604:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102607:	5b                   	pop    %ebx
80102608:	5e                   	pop    %esi
80102609:	5f                   	pop    %edi
8010260a:	5d                   	pop    %ebp
8010260b:	c3                   	ret    
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write) {
80102610:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102614:	66 83 f8 09          	cmp    $0x9,%ax
80102618:	77 36                	ja     80102650 <writei+0x120>
8010261a:	8b 04 c5 44 31 11 80 	mov    -0x7feecebc(,%eax,8),%eax
80102621:	85 c0                	test   %eax,%eax
80102623:	74 2b                	je     80102650 <writei+0x120>
        return devsw[ip->major].write(ip, src, n);
80102625:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102628:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010262b:	5b                   	pop    %ebx
8010262c:	5e                   	pop    %esi
8010262d:	5f                   	pop    %edi
8010262e:	5d                   	pop    %ebp
        return devsw[ip->major].write(ip, src, n);
8010262f:	ff e0                	jmp    *%eax
80102631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        ip->size = off;
80102638:	8b 45 d8             	mov    -0x28(%ebp),%eax
        iupdate(ip);
8010263b:	83 ec 0c             	sub    $0xc,%esp
        ip->size = off;
8010263e:	89 70 58             	mov    %esi,0x58(%eax)
        iupdate(ip);
80102641:	50                   	push   %eax
80102642:	e8 59 fa ff ff       	call   801020a0 <iupdate>
80102647:	83 c4 10             	add    $0x10,%esp
8010264a:	eb b5                	jmp    80102601 <writei+0xd1>
8010264c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            return -1;
80102650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102655:	eb ad                	jmp    80102604 <writei+0xd4>
80102657:	89 f6                	mov    %esi,%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102660 <namecmp>:


// Directories

int namecmp(const char *s, const char *t) {
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	83 ec 0c             	sub    $0xc,%esp
    return strncmp(s, t, DIRSIZ);
80102666:	6a 0e                	push   $0xe
80102668:	ff 75 0c             	pushl  0xc(%ebp)
8010266b:	ff 75 08             	pushl  0x8(%ebp)
8010266e:	e8 fd 29 00 00       	call   80105070 <strncmp>
}
80102673:	c9                   	leave  
80102674:	c3                   	ret    
80102675:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102680 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode* dirlookup(struct inode *dp, char *name, uint *poff) {
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	57                   	push   %edi
80102684:	56                   	push   %esi
80102685:	53                   	push   %ebx
80102686:	83 ec 1c             	sub    $0x1c,%esp
80102689:	8b 5d 08             	mov    0x8(%ebp),%ebx
    uint off, inum;
    struct dirent de;

    if (dp->type != T_DIR) {
8010268c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102691:	0f 85 85 00 00 00    	jne    8010271c <dirlookup+0x9c>
        panic("dirlookup not DIR");
    }

    for (off = 0; off < dp->size; off += sizeof(de)) {
80102697:	8b 53 58             	mov    0x58(%ebx),%edx
8010269a:	31 ff                	xor    %edi,%edi
8010269c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010269f:	85 d2                	test   %edx,%edx
801026a1:	74 3e                	je     801026e1 <dirlookup+0x61>
801026a3:	90                   	nop
801026a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
801026a8:	6a 10                	push   $0x10
801026aa:	57                   	push   %edi
801026ab:	56                   	push   %esi
801026ac:	53                   	push   %ebx
801026ad:	e8 7e fd ff ff       	call   80102430 <readi>
801026b2:	83 c4 10             	add    $0x10,%esp
801026b5:	83 f8 10             	cmp    $0x10,%eax
801026b8:	75 55                	jne    8010270f <dirlookup+0x8f>
            panic("dirlookup read");
        }
        if (de.inum == 0) {
801026ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801026bf:	74 18                	je     801026d9 <dirlookup+0x59>
    return strncmp(s, t, DIRSIZ);
801026c1:	8d 45 da             	lea    -0x26(%ebp),%eax
801026c4:	83 ec 04             	sub    $0x4,%esp
801026c7:	6a 0e                	push   $0xe
801026c9:	50                   	push   %eax
801026ca:	ff 75 0c             	pushl  0xc(%ebp)
801026cd:	e8 9e 29 00 00       	call   80105070 <strncmp>
            continue;
        }
        if (namecmp(name, de.name) == 0) {
801026d2:	83 c4 10             	add    $0x10,%esp
801026d5:	85 c0                	test   %eax,%eax
801026d7:	74 17                	je     801026f0 <dirlookup+0x70>
    for (off = 0; off < dp->size; off += sizeof(de)) {
801026d9:	83 c7 10             	add    $0x10,%edi
801026dc:	3b 7b 58             	cmp    0x58(%ebx),%edi
801026df:	72 c7                	jb     801026a8 <dirlookup+0x28>
            return iget(dp->dev, inum);
        }
    }

    return 0;
}
801026e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801026e4:	31 c0                	xor    %eax,%eax
}
801026e6:	5b                   	pop    %ebx
801026e7:	5e                   	pop    %esi
801026e8:	5f                   	pop    %edi
801026e9:	5d                   	pop    %ebp
801026ea:	c3                   	ret    
801026eb:	90                   	nop
801026ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            if (poff) {
801026f0:	8b 45 10             	mov    0x10(%ebp),%eax
801026f3:	85 c0                	test   %eax,%eax
801026f5:	74 05                	je     801026fc <dirlookup+0x7c>
                *poff = off;
801026f7:	8b 45 10             	mov    0x10(%ebp),%eax
801026fa:	89 38                	mov    %edi,(%eax)
            inum = de.inum;
801026fc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
            return iget(dp->dev, inum);
80102700:	8b 03                	mov    (%ebx),%eax
80102702:	e8 59 f6 ff ff       	call   80101d60 <iget>
}
80102707:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010270a:	5b                   	pop    %ebx
8010270b:	5e                   	pop    %esi
8010270c:	5f                   	pop    %edi
8010270d:	5d                   	pop    %ebp
8010270e:	c3                   	ret    
            panic("dirlookup read");
8010270f:	83 ec 0c             	sub    $0xc,%esp
80102712:	68 a9 7c 10 80       	push   $0x80107ca9
80102717:	e8 c4 dd ff ff       	call   801004e0 <panic>
        panic("dirlookup not DIR");
8010271c:	83 ec 0c             	sub    $0xc,%esp
8010271f:	68 97 7c 10 80       	push   $0x80107c97
80102724:	e8 b7 dd ff ff       	call   801004e0 <panic>
80102729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102730 <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode* namex(char *path, int nameiparent, char *name)                     {
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
80102733:	57                   	push   %edi
80102734:	56                   	push   %esi
80102735:	53                   	push   %ebx
80102736:	89 cf                	mov    %ecx,%edi
80102738:	89 c3                	mov    %eax,%ebx
8010273a:	83 ec 1c             	sub    $0x1c,%esp
    struct inode *ip, *next;

    if (*path == '/') {
8010273d:	80 38 2f             	cmpb   $0x2f,(%eax)
static struct inode* namex(char *path, int nameiparent, char *name)                     {
80102740:	89 55 e0             	mov    %edx,-0x20(%ebp)
    if (*path == '/') {
80102743:	0f 84 67 01 00 00    	je     801028b0 <namex+0x180>
        ip = iget(ROOTDEV, ROOTINO);
    }
    else {
        ip = idup(myproc()->cwd);
80102749:	e8 92 1b 00 00       	call   801042e0 <myproc>
    acquire(&icache.lock);
8010274e:	83 ec 0c             	sub    $0xc,%esp
        ip = idup(myproc()->cwd);
80102751:	8b 70 68             	mov    0x68(%eax),%esi
    acquire(&icache.lock);
80102754:	68 c0 31 11 80       	push   $0x801131c0
80102759:	e8 e2 26 00 00       	call   80104e40 <acquire>
    ip->ref++;
8010275e:	83 46 08 01          	addl   $0x1,0x8(%esi)
    release(&icache.lock);
80102762:	c7 04 24 c0 31 11 80 	movl   $0x801131c0,(%esp)
80102769:	e8 92 27 00 00       	call   80104f00 <release>
8010276e:	83 c4 10             	add    $0x10,%esp
80102771:	eb 08                	jmp    8010277b <namex+0x4b>
80102773:	90                   	nop
80102774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        path++;
80102778:	83 c3 01             	add    $0x1,%ebx
    while (*path == '/') {
8010277b:	0f b6 03             	movzbl (%ebx),%eax
8010277e:	3c 2f                	cmp    $0x2f,%al
80102780:	74 f6                	je     80102778 <namex+0x48>
    if (*path == 0) {
80102782:	84 c0                	test   %al,%al
80102784:	0f 84 ee 00 00 00    	je     80102878 <namex+0x148>
    while (*path != '/' && *path != 0) {
8010278a:	0f b6 03             	movzbl (%ebx),%eax
8010278d:	3c 2f                	cmp    $0x2f,%al
8010278f:	0f 84 b3 00 00 00    	je     80102848 <namex+0x118>
80102795:	84 c0                	test   %al,%al
80102797:	89 da                	mov    %ebx,%edx
80102799:	75 09                	jne    801027a4 <namex+0x74>
8010279b:	e9 a8 00 00 00       	jmp    80102848 <namex+0x118>
801027a0:	84 c0                	test   %al,%al
801027a2:	74 0a                	je     801027ae <namex+0x7e>
        path++;
801027a4:	83 c2 01             	add    $0x1,%edx
    while (*path != '/' && *path != 0) {
801027a7:	0f b6 02             	movzbl (%edx),%eax
801027aa:	3c 2f                	cmp    $0x2f,%al
801027ac:	75 f2                	jne    801027a0 <namex+0x70>
801027ae:	89 d1                	mov    %edx,%ecx
801027b0:	29 d9                	sub    %ebx,%ecx
    if (len >= DIRSIZ) {
801027b2:	83 f9 0d             	cmp    $0xd,%ecx
801027b5:	0f 8e 91 00 00 00    	jle    8010284c <namex+0x11c>
        memmove(name, s, DIRSIZ);
801027bb:	83 ec 04             	sub    $0x4,%esp
801027be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801027c1:	6a 0e                	push   $0xe
801027c3:	53                   	push   %ebx
801027c4:	57                   	push   %edi
801027c5:	e8 36 28 00 00       	call   80105000 <memmove>
        path++;
801027ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        memmove(name, s, DIRSIZ);
801027cd:	83 c4 10             	add    $0x10,%esp
        path++;
801027d0:	89 d3                	mov    %edx,%ebx
    while (*path == '/') {
801027d2:	80 3a 2f             	cmpb   $0x2f,(%edx)
801027d5:	75 11                	jne    801027e8 <namex+0xb8>
801027d7:	89 f6                	mov    %esi,%esi
801027d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        path++;
801027e0:	83 c3 01             	add    $0x1,%ebx
    while (*path == '/') {
801027e3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801027e6:	74 f8                	je     801027e0 <namex+0xb0>
    }

    while ((path = skipelem(path, name)) != 0) {
        ilock(ip);
801027e8:	83 ec 0c             	sub    $0xc,%esp
801027eb:	56                   	push   %esi
801027ec:	e8 5f f9 ff ff       	call   80102150 <ilock>
        if (ip->type != T_DIR) {
801027f1:	83 c4 10             	add    $0x10,%esp
801027f4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801027f9:	0f 85 91 00 00 00    	jne    80102890 <namex+0x160>
            iunlockput(ip);
            return 0;
        }
        if (nameiparent && *path == '\0') {
801027ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102802:	85 d2                	test   %edx,%edx
80102804:	74 09                	je     8010280f <namex+0xdf>
80102806:	80 3b 00             	cmpb   $0x0,(%ebx)
80102809:	0f 84 b7 00 00 00    	je     801028c6 <namex+0x196>
            // Stop one level early.
            iunlock(ip);
            return ip;
        }
        if ((next = dirlookup(ip, name, 0)) == 0) {
8010280f:	83 ec 04             	sub    $0x4,%esp
80102812:	6a 00                	push   $0x0
80102814:	57                   	push   %edi
80102815:	56                   	push   %esi
80102816:	e8 65 fe ff ff       	call   80102680 <dirlookup>
8010281b:	83 c4 10             	add    $0x10,%esp
8010281e:	85 c0                	test   %eax,%eax
80102820:	74 6e                	je     80102890 <namex+0x160>
    iunlock(ip);
80102822:	83 ec 0c             	sub    $0xc,%esp
80102825:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102828:	56                   	push   %esi
80102829:	e8 02 fa ff ff       	call   80102230 <iunlock>
    iput(ip);
8010282e:	89 34 24             	mov    %esi,(%esp)
80102831:	e8 4a fa ff ff       	call   80102280 <iput>
80102836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102839:	83 c4 10             	add    $0x10,%esp
8010283c:	89 c6                	mov    %eax,%esi
8010283e:	e9 38 ff ff ff       	jmp    8010277b <namex+0x4b>
80102843:	90                   	nop
80102844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while (*path != '/' && *path != 0) {
80102848:	89 da                	mov    %ebx,%edx
8010284a:	31 c9                	xor    %ecx,%ecx
        memmove(name, s, len);
8010284c:	83 ec 04             	sub    $0x4,%esp
8010284f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102852:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102855:	51                   	push   %ecx
80102856:	53                   	push   %ebx
80102857:	57                   	push   %edi
80102858:	e8 a3 27 00 00       	call   80105000 <memmove>
        name[len] = 0;
8010285d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102860:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102863:	83 c4 10             	add    $0x10,%esp
80102866:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
8010286a:	89 d3                	mov    %edx,%ebx
8010286c:	e9 61 ff ff ff       	jmp    801027d2 <namex+0xa2>
80102871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            return 0;
        }
        iunlockput(ip);
        ip = next;
    }
    if (nameiparent) {
80102878:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010287b:	85 c0                	test   %eax,%eax
8010287d:	75 5d                	jne    801028dc <namex+0x1ac>
        iput(ip);
        return 0;
    }
    return ip;
}
8010287f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102882:	89 f0                	mov    %esi,%eax
80102884:	5b                   	pop    %ebx
80102885:	5e                   	pop    %esi
80102886:	5f                   	pop    %edi
80102887:	5d                   	pop    %ebp
80102888:	c3                   	ret    
80102889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlock(ip);
80102890:	83 ec 0c             	sub    $0xc,%esp
80102893:	56                   	push   %esi
80102894:	e8 97 f9 ff ff       	call   80102230 <iunlock>
    iput(ip);
80102899:	89 34 24             	mov    %esi,(%esp)
            return 0;
8010289c:	31 f6                	xor    %esi,%esi
    iput(ip);
8010289e:	e8 dd f9 ff ff       	call   80102280 <iput>
            return 0;
801028a3:	83 c4 10             	add    $0x10,%esp
}
801028a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028a9:	89 f0                	mov    %esi,%eax
801028ab:	5b                   	pop    %ebx
801028ac:	5e                   	pop    %esi
801028ad:	5f                   	pop    %edi
801028ae:	5d                   	pop    %ebp
801028af:	c3                   	ret    
        ip = iget(ROOTDEV, ROOTINO);
801028b0:	ba 01 00 00 00       	mov    $0x1,%edx
801028b5:	b8 01 00 00 00       	mov    $0x1,%eax
801028ba:	e8 a1 f4 ff ff       	call   80101d60 <iget>
801028bf:	89 c6                	mov    %eax,%esi
801028c1:	e9 b5 fe ff ff       	jmp    8010277b <namex+0x4b>
            iunlock(ip);
801028c6:	83 ec 0c             	sub    $0xc,%esp
801028c9:	56                   	push   %esi
801028ca:	e8 61 f9 ff ff       	call   80102230 <iunlock>
            return ip;
801028cf:	83 c4 10             	add    $0x10,%esp
}
801028d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801028d5:	89 f0                	mov    %esi,%eax
801028d7:	5b                   	pop    %ebx
801028d8:	5e                   	pop    %esi
801028d9:	5f                   	pop    %edi
801028da:	5d                   	pop    %ebp
801028db:	c3                   	ret    
        iput(ip);
801028dc:	83 ec 0c             	sub    $0xc,%esp
801028df:	56                   	push   %esi
        return 0;
801028e0:	31 f6                	xor    %esi,%esi
        iput(ip);
801028e2:	e8 99 f9 ff ff       	call   80102280 <iput>
        return 0;
801028e7:	83 c4 10             	add    $0x10,%esp
801028ea:	eb 93                	jmp    8010287f <namex+0x14f>
801028ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028f0 <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
801028f0:	55                   	push   %ebp
801028f1:	89 e5                	mov    %esp,%ebp
801028f3:	57                   	push   %edi
801028f4:	56                   	push   %esi
801028f5:	53                   	push   %ebx
801028f6:	83 ec 20             	sub    $0x20,%esp
801028f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if ((ip = dirlookup(dp, name, 0)) != 0) {
801028fc:	6a 00                	push   $0x0
801028fe:	ff 75 0c             	pushl  0xc(%ebp)
80102901:	53                   	push   %ebx
80102902:	e8 79 fd ff ff       	call   80102680 <dirlookup>
80102907:	83 c4 10             	add    $0x10,%esp
8010290a:	85 c0                	test   %eax,%eax
8010290c:	75 67                	jne    80102975 <dirlink+0x85>
    for (off = 0; off < dp->size; off += sizeof(de)) {
8010290e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102911:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102914:	85 ff                	test   %edi,%edi
80102916:	74 29                	je     80102941 <dirlink+0x51>
80102918:	31 ff                	xor    %edi,%edi
8010291a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010291d:	eb 09                	jmp    80102928 <dirlink+0x38>
8010291f:	90                   	nop
80102920:	83 c7 10             	add    $0x10,%edi
80102923:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102926:	73 19                	jae    80102941 <dirlink+0x51>
        if (readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80102928:	6a 10                	push   $0x10
8010292a:	57                   	push   %edi
8010292b:	56                   	push   %esi
8010292c:	53                   	push   %ebx
8010292d:	e8 fe fa ff ff       	call   80102430 <readi>
80102932:	83 c4 10             	add    $0x10,%esp
80102935:	83 f8 10             	cmp    $0x10,%eax
80102938:	75 4e                	jne    80102988 <dirlink+0x98>
        if (de.inum == 0) {
8010293a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010293f:	75 df                	jne    80102920 <dirlink+0x30>
    strncpy(de.name, name, DIRSIZ);
80102941:	8d 45 da             	lea    -0x26(%ebp),%eax
80102944:	83 ec 04             	sub    $0x4,%esp
80102947:	6a 0e                	push   $0xe
80102949:	ff 75 0c             	pushl  0xc(%ebp)
8010294c:	50                   	push   %eax
8010294d:	e8 7e 27 00 00       	call   801050d0 <strncpy>
    de.inum = inum;
80102952:	8b 45 10             	mov    0x10(%ebp),%eax
    if (writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80102955:	6a 10                	push   $0x10
80102957:	57                   	push   %edi
80102958:	56                   	push   %esi
80102959:	53                   	push   %ebx
    de.inum = inum;
8010295a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    if (writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
8010295e:	e8 cd fb ff ff       	call   80102530 <writei>
80102963:	83 c4 20             	add    $0x20,%esp
80102966:	83 f8 10             	cmp    $0x10,%eax
80102969:	75 2a                	jne    80102995 <dirlink+0xa5>
    return 0;
8010296b:	31 c0                	xor    %eax,%eax
}
8010296d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102970:	5b                   	pop    %ebx
80102971:	5e                   	pop    %esi
80102972:	5f                   	pop    %edi
80102973:	5d                   	pop    %ebp
80102974:	c3                   	ret    
        iput(ip);
80102975:	83 ec 0c             	sub    $0xc,%esp
80102978:	50                   	push   %eax
80102979:	e8 02 f9 ff ff       	call   80102280 <iput>
        return -1;
8010297e:	83 c4 10             	add    $0x10,%esp
80102981:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102986:	eb e5                	jmp    8010296d <dirlink+0x7d>
            panic("dirlink read");
80102988:	83 ec 0c             	sub    $0xc,%esp
8010298b:	68 b8 7c 10 80       	push   $0x80107cb8
80102990:	e8 4b db ff ff       	call   801004e0 <panic>
        panic("dirlink");
80102995:	83 ec 0c             	sub    $0xc,%esp
80102998:	68 de 82 10 80       	push   $0x801082de
8010299d:	e8 3e db ff ff       	call   801004e0 <panic>
801029a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029b0 <namei>:

struct inode* namei(char *path) {
801029b0:	55                   	push   %ebp
    char name[DIRSIZ];
    return namex(path, 0, name);
801029b1:	31 d2                	xor    %edx,%edx
struct inode* namei(char *path) {
801029b3:	89 e5                	mov    %esp,%ebp
801029b5:	83 ec 18             	sub    $0x18,%esp
    return namex(path, 0, name);
801029b8:	8b 45 08             	mov    0x8(%ebp),%eax
801029bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801029be:	e8 6d fd ff ff       	call   80102730 <namex>
}
801029c3:	c9                   	leave  
801029c4:	c3                   	ret    
801029c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029d0 <nameiparent>:

struct inode*nameiparent(char *path, char *name) {
801029d0:	55                   	push   %ebp
    return namex(path, 1, name);
801029d1:	ba 01 00 00 00       	mov    $0x1,%edx
struct inode*nameiparent(char *path, char *name) {
801029d6:	89 e5                	mov    %esp,%ebp
    return namex(path, 1, name);
801029d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801029de:	5d                   	pop    %ebp
    return namex(path, 1, name);
801029df:	e9 4c fd ff ff       	jmp    80102730 <namex>
801029e4:	66 90                	xchg   %ax,%ax
801029e6:	66 90                	xchg   %ax,%ax
801029e8:	66 90                	xchg   %ax,%ax
801029ea:	66 90                	xchg   %ax,%ax
801029ec:	66 90                	xchg   %ax,%ax
801029ee:	66 90                	xchg   %ax,%ax

801029f0 <idestart>:
    // Switch back to disk 0.
    outb(0x1f6, 0xe0 | (0 << 4));
}

// Start the request for b.  Caller must hold idelock.
static void idestart(struct buf *b) {
801029f0:	55                   	push   %ebp
801029f1:	89 e5                	mov    %esp,%ebp
801029f3:	57                   	push   %edi
801029f4:	56                   	push   %esi
801029f5:	53                   	push   %ebx
801029f6:	83 ec 0c             	sub    $0xc,%esp
    if (b == 0) {
801029f9:	85 c0                	test   %eax,%eax
801029fb:	0f 84 b4 00 00 00    	je     80102ab5 <idestart+0xc5>
        panic("idestart");
    }
    if (b->blockno >= FSSIZE) {
80102a01:	8b 58 08             	mov    0x8(%eax),%ebx
80102a04:	89 c6                	mov    %eax,%esi
80102a06:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80102a0c:	0f 87 96 00 00 00    	ja     80102aa8 <idestart+0xb8>
80102a12:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102a17:	89 f6                	mov    %esi,%esi
80102a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102a20:	89 ca                	mov    %ecx,%edx
80102a22:	ec                   	in     (%dx),%al
    while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY) {
80102a23:	83 e0 c0             	and    $0xffffffc0,%eax
80102a26:	3c 40                	cmp    $0x40,%al
80102a28:	75 f6                	jne    80102a20 <idestart+0x30>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102a2a:	31 ff                	xor    %edi,%edi
80102a2c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102a31:	89 f8                	mov    %edi,%eax
80102a33:	ee                   	out    %al,(%dx)
80102a34:	b8 01 00 00 00       	mov    $0x1,%eax
80102a39:	ba f2 01 00 00       	mov    $0x1f2,%edx
80102a3e:	ee                   	out    %al,(%dx)
80102a3f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102a44:	89 d8                	mov    %ebx,%eax
80102a46:	ee                   	out    %al,(%dx)

    idewait(0);
    outb(0x3f6, 0);  // generate interrupt
    outb(0x1f2, sector_per_block);  // number of sectors
    outb(0x1f3, sector & 0xff);
    outb(0x1f4, (sector >> 8) & 0xff);
80102a47:	89 d8                	mov    %ebx,%eax
80102a49:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102a4e:	c1 f8 08             	sar    $0x8,%eax
80102a51:	ee                   	out    %al,(%dx)
80102a52:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102a57:	89 f8                	mov    %edi,%eax
80102a59:	ee                   	out    %al,(%dx)
    outb(0x1f5, (sector >> 16) & 0xff);
    outb(0x1f6, 0xe0 | ((b->dev & 1) << 4) | ((sector >> 24) & 0x0f));
80102a5a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80102a5e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102a63:	c1 e0 04             	shl    $0x4,%eax
80102a66:	83 e0 10             	and    $0x10,%eax
80102a69:	83 c8 e0             	or     $0xffffffe0,%eax
80102a6c:	ee                   	out    %al,(%dx)
    if (b->flags & B_DIRTY) {
80102a6d:	f6 06 04             	testb  $0x4,(%esi)
80102a70:	75 16                	jne    80102a88 <idestart+0x98>
80102a72:	b8 20 00 00 00       	mov    $0x20,%eax
80102a77:	89 ca                	mov    %ecx,%edx
80102a79:	ee                   	out    %al,(%dx)
        outsl(0x1f0, b->data, BSIZE / 4);
    }
    else {
        outb(0x1f7, read_cmd);
    }
}
80102a7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a7d:	5b                   	pop    %ebx
80102a7e:	5e                   	pop    %esi
80102a7f:	5f                   	pop    %edi
80102a80:	5d                   	pop    %ebp
80102a81:	c3                   	ret    
80102a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a88:	b8 30 00 00 00       	mov    $0x30,%eax
80102a8d:	89 ca                	mov    %ecx,%edx
80102a8f:	ee                   	out    %al,(%dx)
    asm volatile ("cld; rep outsl" :
80102a90:	b9 80 00 00 00       	mov    $0x80,%ecx
        outsl(0x1f0, b->data, BSIZE / 4);
80102a95:	83 c6 5c             	add    $0x5c,%esi
80102a98:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102a9d:	fc                   	cld    
80102a9e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102aa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102aa3:	5b                   	pop    %ebx
80102aa4:	5e                   	pop    %esi
80102aa5:	5f                   	pop    %edi
80102aa6:	5d                   	pop    %ebp
80102aa7:	c3                   	ret    
        panic("incorrect blockno");
80102aa8:	83 ec 0c             	sub    $0xc,%esp
80102aab:	68 24 7d 10 80       	push   $0x80107d24
80102ab0:	e8 2b da ff ff       	call   801004e0 <panic>
        panic("idestart");
80102ab5:	83 ec 0c             	sub    $0xc,%esp
80102ab8:	68 1b 7d 10 80       	push   $0x80107d1b
80102abd:	e8 1e da ff ff       	call   801004e0 <panic>
80102ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ad0 <ideinit>:
void ideinit(void) {
80102ad0:	55                   	push   %ebp
80102ad1:	89 e5                	mov    %esp,%ebp
80102ad3:	83 ec 10             	sub    $0x10,%esp
    initlock(&idelock, "ide");
80102ad6:	68 36 7d 10 80       	push   $0x80107d36
80102adb:	68 80 c5 10 80       	push   $0x8010c580
80102ae0:	e8 1b 22 00 00       	call   80104d00 <initlock>
    ioapicenable(IRQ_IDE, ncpu - 1);
80102ae5:	58                   	pop    %eax
80102ae6:	a1 e0 54 11 80       	mov    0x801154e0,%eax
80102aeb:	5a                   	pop    %edx
80102aec:	83 e8 01             	sub    $0x1,%eax
80102aef:	50                   	push   %eax
80102af0:	6a 0e                	push   $0xe
80102af2:	e8 a9 02 00 00       	call   80102da0 <ioapicenable>
80102af7:	83 c4 10             	add    $0x10,%esp
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102afa:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102aff:	90                   	nop
80102b00:	ec                   	in     (%dx),%al
    while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY) {
80102b01:	83 e0 c0             	and    $0xffffffc0,%eax
80102b04:	3c 40                	cmp    $0x40,%al
80102b06:	75 f8                	jne    80102b00 <ideinit+0x30>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102b08:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102b0d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102b12:	ee                   	out    %al,(%dx)
80102b13:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102b18:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102b1d:	eb 06                	jmp    80102b25 <ideinit+0x55>
80102b1f:	90                   	nop
    for (i = 0; i < 1000; i++) {
80102b20:	83 e9 01             	sub    $0x1,%ecx
80102b23:	74 0f                	je     80102b34 <ideinit+0x64>
80102b25:	ec                   	in     (%dx),%al
        if (inb(0x1f7) != 0) {
80102b26:	84 c0                	test   %al,%al
80102b28:	74 f6                	je     80102b20 <ideinit+0x50>
            havedisk1 = 1;
80102b2a:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
80102b31:	00 00 00 
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102b34:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102b39:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102b3e:	ee                   	out    %al,(%dx)
}
80102b3f:	c9                   	leave  
80102b40:	c3                   	ret    
80102b41:	eb 0d                	jmp    80102b50 <ideintr>
80102b43:	90                   	nop
80102b44:	90                   	nop
80102b45:	90                   	nop
80102b46:	90                   	nop
80102b47:	90                   	nop
80102b48:	90                   	nop
80102b49:	90                   	nop
80102b4a:	90                   	nop
80102b4b:	90                   	nop
80102b4c:	90                   	nop
80102b4d:	90                   	nop
80102b4e:	90                   	nop
80102b4f:	90                   	nop

80102b50 <ideintr>:

// Interrupt handler.
void ideintr(void) {
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
80102b53:	57                   	push   %edi
80102b54:	56                   	push   %esi
80102b55:	53                   	push   %ebx
80102b56:	83 ec 18             	sub    $0x18,%esp
    struct buf *b;

    // First queued buffer is the active request.
    acquire(&idelock);
80102b59:	68 80 c5 10 80       	push   $0x8010c580
80102b5e:	e8 dd 22 00 00       	call   80104e40 <acquire>

    if ((b = idequeue) == 0) {
80102b63:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
80102b69:	83 c4 10             	add    $0x10,%esp
80102b6c:	85 db                	test   %ebx,%ebx
80102b6e:	74 67                	je     80102bd7 <ideintr+0x87>
        release(&idelock);
        return;
    }
    idequeue = b->qnext;
80102b70:	8b 43 58             	mov    0x58(%ebx),%eax
80102b73:	a3 64 c5 10 80       	mov    %eax,0x8010c564

    // Read data if needed.
    if (!(b->flags & B_DIRTY) && idewait(1) >= 0) {
80102b78:	8b 3b                	mov    (%ebx),%edi
80102b7a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102b80:	75 31                	jne    80102bb3 <ideintr+0x63>
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102b82:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102b87:	89 f6                	mov    %esi,%esi
80102b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102b90:	ec                   	in     (%dx),%al
    while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY) {
80102b91:	89 c6                	mov    %eax,%esi
80102b93:	83 e6 c0             	and    $0xffffffc0,%esi
80102b96:	89 f1                	mov    %esi,%ecx
80102b98:	80 f9 40             	cmp    $0x40,%cl
80102b9b:	75 f3                	jne    80102b90 <ideintr+0x40>
    if (checkerr && (r & (IDE_DF | IDE_ERR)) != 0) {
80102b9d:	a8 21                	test   $0x21,%al
80102b9f:	75 12                	jne    80102bb3 <ideintr+0x63>
        insl(0x1f0, b->data, BSIZE / 4);
80102ba1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
    asm volatile ("cld; rep insl" :
80102ba4:	b9 80 00 00 00       	mov    $0x80,%ecx
80102ba9:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102bae:	fc                   	cld    
80102baf:	f3 6d                	rep insl (%dx),%es:(%edi)
80102bb1:	8b 3b                	mov    (%ebx),%edi
    }

    // Wake process waiting for this buf.
    b->flags |= B_VALID;
    b->flags &= ~B_DIRTY;
80102bb3:	83 e7 fb             	and    $0xfffffffb,%edi
    wakeup(b);
80102bb6:	83 ec 0c             	sub    $0xc,%esp
    b->flags &= ~B_DIRTY;
80102bb9:	89 f9                	mov    %edi,%ecx
80102bbb:	83 c9 02             	or     $0x2,%ecx
80102bbe:	89 0b                	mov    %ecx,(%ebx)
    wakeup(b);
80102bc0:	53                   	push   %ebx
80102bc1:	e8 6a 1e 00 00       	call   80104a30 <wakeup>

    // Start disk on next buf in queue.
    if (idequeue != 0) {
80102bc6:	a1 64 c5 10 80       	mov    0x8010c564,%eax
80102bcb:	83 c4 10             	add    $0x10,%esp
80102bce:	85 c0                	test   %eax,%eax
80102bd0:	74 05                	je     80102bd7 <ideintr+0x87>
        idestart(idequeue);
80102bd2:	e8 19 fe ff ff       	call   801029f0 <idestart>
        release(&idelock);
80102bd7:	83 ec 0c             	sub    $0xc,%esp
80102bda:	68 80 c5 10 80       	push   $0x8010c580
80102bdf:	e8 1c 23 00 00       	call   80104f00 <release>
    }

    release(&idelock);
}
80102be4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102be7:	5b                   	pop    %ebx
80102be8:	5e                   	pop    %esi
80102be9:	5f                   	pop    %edi
80102bea:	5d                   	pop    %ebp
80102beb:	c3                   	ret    
80102bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102bf0 <iderw>:


// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void iderw(struct buf *b) {
80102bf0:	55                   	push   %ebp
80102bf1:	89 e5                	mov    %esp,%ebp
80102bf3:	53                   	push   %ebx
80102bf4:	83 ec 10             	sub    $0x10,%esp
80102bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct buf **pp;

    if (!holdingsleep(&b->lock)) {
80102bfa:	8d 43 0c             	lea    0xc(%ebx),%eax
80102bfd:	50                   	push   %eax
80102bfe:	e8 ad 20 00 00       	call   80104cb0 <holdingsleep>
80102c03:	83 c4 10             	add    $0x10,%esp
80102c06:	85 c0                	test   %eax,%eax
80102c08:	0f 84 c6 00 00 00    	je     80102cd4 <iderw+0xe4>
        panic("iderw: buf not locked");
    }
    if ((b->flags & (B_VALID | B_DIRTY)) == B_VALID) {
80102c0e:	8b 03                	mov    (%ebx),%eax
80102c10:	83 e0 06             	and    $0x6,%eax
80102c13:	83 f8 02             	cmp    $0x2,%eax
80102c16:	0f 84 ab 00 00 00    	je     80102cc7 <iderw+0xd7>
        panic("iderw: nothing to do");
    }
    if (b->dev != 0 && !havedisk1) {
80102c1c:	8b 53 04             	mov    0x4(%ebx),%edx
80102c1f:	85 d2                	test   %edx,%edx
80102c21:	74 0d                	je     80102c30 <iderw+0x40>
80102c23:	a1 60 c5 10 80       	mov    0x8010c560,%eax
80102c28:	85 c0                	test   %eax,%eax
80102c2a:	0f 84 b1 00 00 00    	je     80102ce1 <iderw+0xf1>
        panic("iderw: ide disk 1 not present");
    }

    acquire(&idelock);  //DOC:acquire-lock
80102c30:	83 ec 0c             	sub    $0xc,%esp
80102c33:	68 80 c5 10 80       	push   $0x8010c580
80102c38:	e8 03 22 00 00       	call   80104e40 <acquire>

    // Append b to idequeue.
    b->qnext = 0;
    for (pp = &idequeue; *pp; pp = &(*pp)->qnext) { //DOC:insert-queue
80102c3d:	8b 15 64 c5 10 80    	mov    0x8010c564,%edx
80102c43:	83 c4 10             	add    $0x10,%esp
    b->qnext = 0;
80102c46:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
    for (pp = &idequeue; *pp; pp = &(*pp)->qnext) { //DOC:insert-queue
80102c4d:	85 d2                	test   %edx,%edx
80102c4f:	75 09                	jne    80102c5a <iderw+0x6a>
80102c51:	eb 6d                	jmp    80102cc0 <iderw+0xd0>
80102c53:	90                   	nop
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	89 c2                	mov    %eax,%edx
80102c5a:	8b 42 58             	mov    0x58(%edx),%eax
80102c5d:	85 c0                	test   %eax,%eax
80102c5f:	75 f7                	jne    80102c58 <iderw+0x68>
80102c61:	83 c2 58             	add    $0x58,%edx
        ;
    }
    *pp = b;
80102c64:	89 1a                	mov    %ebx,(%edx)

    // Start disk if necessary.
    if (idequeue == b) {
80102c66:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
80102c6c:	74 42                	je     80102cb0 <iderw+0xc0>
        idestart(b);
    }

    // Wait for request to finish.
    while ((b->flags & (B_VALID | B_DIRTY)) != B_VALID) {
80102c6e:	8b 03                	mov    (%ebx),%eax
80102c70:	83 e0 06             	and    $0x6,%eax
80102c73:	83 f8 02             	cmp    $0x2,%eax
80102c76:	74 23                	je     80102c9b <iderw+0xab>
80102c78:	90                   	nop
80102c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        sleep(b, &idelock);
80102c80:	83 ec 08             	sub    $0x8,%esp
80102c83:	68 80 c5 10 80       	push   $0x8010c580
80102c88:	53                   	push   %ebx
80102c89:	e8 f2 1b 00 00       	call   80104880 <sleep>
    while ((b->flags & (B_VALID | B_DIRTY)) != B_VALID) {
80102c8e:	8b 03                	mov    (%ebx),%eax
80102c90:	83 c4 10             	add    $0x10,%esp
80102c93:	83 e0 06             	and    $0x6,%eax
80102c96:	83 f8 02             	cmp    $0x2,%eax
80102c99:	75 e5                	jne    80102c80 <iderw+0x90>
    }

    release(&idelock);
80102c9b:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102ca2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ca5:	c9                   	leave  
    release(&idelock);
80102ca6:	e9 55 22 00 00       	jmp    80104f00 <release>
80102cab:	90                   	nop
80102cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        idestart(b);
80102cb0:	89 d8                	mov    %ebx,%eax
80102cb2:	e8 39 fd ff ff       	call   801029f0 <idestart>
80102cb7:	eb b5                	jmp    80102c6e <iderw+0x7e>
80102cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (pp = &idequeue; *pp; pp = &(*pp)->qnext) { //DOC:insert-queue
80102cc0:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
80102cc5:	eb 9d                	jmp    80102c64 <iderw+0x74>
        panic("iderw: nothing to do");
80102cc7:	83 ec 0c             	sub    $0xc,%esp
80102cca:	68 50 7d 10 80       	push   $0x80107d50
80102ccf:	e8 0c d8 ff ff       	call   801004e0 <panic>
        panic("iderw: buf not locked");
80102cd4:	83 ec 0c             	sub    $0xc,%esp
80102cd7:	68 3a 7d 10 80       	push   $0x80107d3a
80102cdc:	e8 ff d7 ff ff       	call   801004e0 <panic>
        panic("iderw: ide disk 1 not present");
80102ce1:	83 ec 0c             	sub    $0xc,%esp
80102ce4:	68 65 7d 10 80       	push   $0x80107d65
80102ce9:	e8 f2 d7 ff ff       	call   801004e0 <panic>
80102cee:	66 90                	xchg   %ax,%ax

80102cf0 <ioapicinit>:
static void ioapicwrite(int reg, uint data) {
    ioapic->reg = reg;
    ioapic->data = data;
}

void ioapicinit(void) {
80102cf0:	55                   	push   %ebp
    int i, id, maxintr;

    ioapic = (volatile struct ioapic*)IOAPIC;
80102cf1:	c7 05 14 4e 11 80 00 	movl   $0xfec00000,0x80114e14
80102cf8:	00 c0 fe 
void ioapicinit(void) {
80102cfb:	89 e5                	mov    %esp,%ebp
80102cfd:	56                   	push   %esi
80102cfe:	53                   	push   %ebx
    ioapic->reg = reg;
80102cff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102d06:	00 00 00 
    return ioapic->data;
80102d09:	a1 14 4e 11 80       	mov    0x80114e14,%eax
80102d0e:	8b 58 10             	mov    0x10(%eax),%ebx
    ioapic->reg = reg;
80102d11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    return ioapic->data;
80102d17:	8b 0d 14 4e 11 80    	mov    0x80114e14,%ecx
    maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
    id = ioapicread(REG_ID) >> 24;
    if (id != ioapicid) {
80102d1d:	0f b6 15 40 4f 11 80 	movzbl 0x80114f40,%edx
    maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102d24:	c1 eb 10             	shr    $0x10,%ebx
    return ioapic->data;
80102d27:	8b 41 10             	mov    0x10(%ecx),%eax
    maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102d2a:	0f b6 db             	movzbl %bl,%ebx
    id = ioapicread(REG_ID) >> 24;
80102d2d:	c1 e8 18             	shr    $0x18,%eax
    if (id != ioapicid) {
80102d30:	39 c2                	cmp    %eax,%edx
80102d32:	74 16                	je     80102d4a <ioapicinit+0x5a>
        cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102d34:	83 ec 0c             	sub    $0xc,%esp
80102d37:	68 84 7d 10 80       	push   $0x80107d84
80102d3c:	e8 1f db ff ff       	call   80100860 <cprintf>
80102d41:	8b 0d 14 4e 11 80    	mov    0x80114e14,%ecx
80102d47:	83 c4 10             	add    $0x10,%esp
80102d4a:	83 c3 21             	add    $0x21,%ebx
void ioapicinit(void) {
80102d4d:	ba 10 00 00 00       	mov    $0x10,%edx
80102d52:	b8 20 00 00 00       	mov    $0x20,%eax
80102d57:	89 f6                	mov    %esi,%esi
80102d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ioapic->reg = reg;
80102d60:	89 11                	mov    %edx,(%ecx)
    ioapic->data = data;
80102d62:	8b 0d 14 4e 11 80    	mov    0x80114e14,%ecx
    }

    // Mark all interrupts edge-triggered, active high, disabled,
    // and not routed to any CPUs.
    for (i = 0; i <= maxintr; i++) {
        ioapicwrite(REG_TABLE + 2 * i, INT_DISABLED | (T_IRQ0 + i));
80102d68:	89 c6                	mov    %eax,%esi
80102d6a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102d70:	83 c0 01             	add    $0x1,%eax
    ioapic->data = data;
80102d73:	89 71 10             	mov    %esi,0x10(%ecx)
80102d76:	8d 72 01             	lea    0x1(%edx),%esi
80102d79:	83 c2 02             	add    $0x2,%edx
    for (i = 0; i <= maxintr; i++) {
80102d7c:	39 d8                	cmp    %ebx,%eax
    ioapic->reg = reg;
80102d7e:	89 31                	mov    %esi,(%ecx)
    ioapic->data = data;
80102d80:	8b 0d 14 4e 11 80    	mov    0x80114e14,%ecx
80102d86:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
    for (i = 0; i <= maxintr; i++) {
80102d8d:	75 d1                	jne    80102d60 <ioapicinit+0x70>
        ioapicwrite(REG_TABLE + 2 * i + 1, 0);
    }
}
80102d8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d92:	5b                   	pop    %ebx
80102d93:	5e                   	pop    %esi
80102d94:	5d                   	pop    %ebp
80102d95:	c3                   	ret    
80102d96:	8d 76 00             	lea    0x0(%esi),%esi
80102d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102da0 <ioapicenable>:

void ioapicenable(int irq, int cpunum) {
80102da0:	55                   	push   %ebp
    ioapic->reg = reg;
80102da1:	8b 0d 14 4e 11 80    	mov    0x80114e14,%ecx
void ioapicenable(int irq, int cpunum) {
80102da7:	89 e5                	mov    %esp,%ebp
80102da9:	8b 45 08             	mov    0x8(%ebp),%eax
    // Mark interrupt edge-triggered, active high,
    // enabled, and routed to the given cpunum,
    // which happens to be that cpu's APIC ID.
    ioapicwrite(REG_TABLE + 2 * irq, T_IRQ0 + irq);
80102dac:	8d 50 20             	lea    0x20(%eax),%edx
80102daf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
    ioapic->reg = reg;
80102db3:	89 01                	mov    %eax,(%ecx)
    ioapic->data = data;
80102db5:	8b 0d 14 4e 11 80    	mov    0x80114e14,%ecx
    ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
80102dbb:	83 c0 01             	add    $0x1,%eax
    ioapic->data = data;
80102dbe:	89 51 10             	mov    %edx,0x10(%ecx)
    ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
80102dc1:	8b 55 0c             	mov    0xc(%ebp),%edx
    ioapic->reg = reg;
80102dc4:	89 01                	mov    %eax,(%ecx)
    ioapic->data = data;
80102dc6:	a1 14 4e 11 80       	mov    0x80114e14,%eax
    ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
80102dcb:	c1 e2 18             	shl    $0x18,%edx
    ioapic->data = data;
80102dce:	89 50 10             	mov    %edx,0x10(%eax)
}
80102dd1:	5d                   	pop    %ebp
80102dd2:	c3                   	ret    
80102dd3:	66 90                	xchg   %ax,%ax
80102dd5:	66 90                	xchg   %ax,%ax
80102dd7:	66 90                	xchg   %ax,%ax
80102dd9:	66 90                	xchg   %ax,%ax
80102ddb:	66 90                	xchg   %ax,%ax
80102ddd:	66 90                	xchg   %ax,%ax
80102ddf:	90                   	nop

80102de0 <kfree>:

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(char *v) {
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	53                   	push   %ebx
80102de4:	83 ec 04             	sub    $0x4,%esp
80102de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct run *r;

    if ((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP) {
80102dea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102df0:	75 70                	jne    80102e62 <kfree+0x82>
80102df2:	81 fb 88 7c 11 80    	cmp    $0x80117c88,%ebx
80102df8:	72 68                	jb     80102e62 <kfree+0x82>
80102dfa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102e00:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102e05:	77 5b                	ja     80102e62 <kfree+0x82>
        panic("kfree");
    }

    // Fill with junk to catch dangling refs.
    memset(v, 1, PGSIZE);
80102e07:	83 ec 04             	sub    $0x4,%esp
80102e0a:	68 00 10 00 00       	push   $0x1000
80102e0f:	6a 01                	push   $0x1
80102e11:	53                   	push   %ebx
80102e12:	e8 39 21 00 00       	call   80104f50 <memset>

    if (kmem.use_lock) {
80102e17:	8b 15 54 4e 11 80    	mov    0x80114e54,%edx
80102e1d:	83 c4 10             	add    $0x10,%esp
80102e20:	85 d2                	test   %edx,%edx
80102e22:	75 2c                	jne    80102e50 <kfree+0x70>
        acquire(&kmem.lock);
    }
    r = (struct run*)v;
    r->next = kmem.freelist;
80102e24:	a1 58 4e 11 80       	mov    0x80114e58,%eax
80102e29:	89 03                	mov    %eax,(%ebx)
    kmem.freelist = r;
    if (kmem.use_lock) {
80102e2b:	a1 54 4e 11 80       	mov    0x80114e54,%eax
    kmem.freelist = r;
80102e30:	89 1d 58 4e 11 80    	mov    %ebx,0x80114e58
    if (kmem.use_lock) {
80102e36:	85 c0                	test   %eax,%eax
80102e38:	75 06                	jne    80102e40 <kfree+0x60>
        release(&kmem.lock);
    }
}
80102e3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e3d:	c9                   	leave  
80102e3e:	c3                   	ret    
80102e3f:	90                   	nop
        release(&kmem.lock);
80102e40:	c7 45 08 20 4e 11 80 	movl   $0x80114e20,0x8(%ebp)
}
80102e47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e4a:	c9                   	leave  
        release(&kmem.lock);
80102e4b:	e9 b0 20 00 00       	jmp    80104f00 <release>
        acquire(&kmem.lock);
80102e50:	83 ec 0c             	sub    $0xc,%esp
80102e53:	68 20 4e 11 80       	push   $0x80114e20
80102e58:	e8 e3 1f 00 00       	call   80104e40 <acquire>
80102e5d:	83 c4 10             	add    $0x10,%esp
80102e60:	eb c2                	jmp    80102e24 <kfree+0x44>
        panic("kfree");
80102e62:	83 ec 0c             	sub    $0xc,%esp
80102e65:	68 b6 7d 10 80       	push   $0x80107db6
80102e6a:	e8 71 d6 ff ff       	call   801004e0 <panic>
80102e6f:	90                   	nop

80102e70 <freerange>:
void freerange(void *vstart, void *vend) {
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	56                   	push   %esi
80102e74:	53                   	push   %ebx
    p = (char*)PGROUNDUP((uint)vstart);
80102e75:	8b 45 08             	mov    0x8(%ebp),%eax
void freerange(void *vstart, void *vend) {
80102e78:	8b 75 0c             	mov    0xc(%ebp),%esi
    p = (char*)PGROUNDUP((uint)vstart);
80102e7b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102e81:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102e87:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102e8d:	39 de                	cmp    %ebx,%esi
80102e8f:	72 23                	jb     80102eb4 <freerange+0x44>
80102e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree(p);
80102e98:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102e9e:	83 ec 0c             	sub    $0xc,%esp
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102ea1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
80102ea7:	50                   	push   %eax
80102ea8:	e8 33 ff ff ff       	call   80102de0 <kfree>
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102ead:	83 c4 10             	add    $0x10,%esp
80102eb0:	39 f3                	cmp    %esi,%ebx
80102eb2:	76 e4                	jbe    80102e98 <freerange+0x28>
}
80102eb4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102eb7:	5b                   	pop    %ebx
80102eb8:	5e                   	pop    %esi
80102eb9:	5d                   	pop    %ebp
80102eba:	c3                   	ret    
80102ebb:	90                   	nop
80102ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ec0 <kinit1>:
void kinit1(void *vstart, void *vend) {
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	56                   	push   %esi
80102ec4:	53                   	push   %ebx
80102ec5:	8b 75 0c             	mov    0xc(%ebp),%esi
    initlock(&kmem.lock, "kmem");
80102ec8:	83 ec 08             	sub    $0x8,%esp
80102ecb:	68 bc 7d 10 80       	push   $0x80107dbc
80102ed0:	68 20 4e 11 80       	push   $0x80114e20
80102ed5:	e8 26 1e 00 00       	call   80104d00 <initlock>
    p = (char*)PGROUNDUP((uint)vstart);
80102eda:	8b 45 08             	mov    0x8(%ebp),%eax
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102edd:	83 c4 10             	add    $0x10,%esp
    kmem.use_lock = 0;
80102ee0:	c7 05 54 4e 11 80 00 	movl   $0x0,0x80114e54
80102ee7:	00 00 00 
    p = (char*)PGROUNDUP((uint)vstart);
80102eea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ef0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102ef6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102efc:	39 de                	cmp    %ebx,%esi
80102efe:	72 1c                	jb     80102f1c <kinit1+0x5c>
        kfree(p);
80102f00:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102f06:	83 ec 0c             	sub    $0xc,%esp
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102f09:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
80102f0f:	50                   	push   %eax
80102f10:	e8 cb fe ff ff       	call   80102de0 <kfree>
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102f15:	83 c4 10             	add    $0x10,%esp
80102f18:	39 de                	cmp    %ebx,%esi
80102f1a:	73 e4                	jae    80102f00 <kinit1+0x40>
}
80102f1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102f1f:	5b                   	pop    %ebx
80102f20:	5e                   	pop    %esi
80102f21:	5d                   	pop    %ebp
80102f22:	c3                   	ret    
80102f23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f30 <kinit2>:
void kinit2(void *vstart, void *vend) {
80102f30:	55                   	push   %ebp
80102f31:	89 e5                	mov    %esp,%ebp
80102f33:	56                   	push   %esi
80102f34:	53                   	push   %ebx
    p = (char*)PGROUNDUP((uint)vstart);
80102f35:	8b 45 08             	mov    0x8(%ebp),%eax
void kinit2(void *vstart, void *vend) {
80102f38:	8b 75 0c             	mov    0xc(%ebp),%esi
    p = (char*)PGROUNDUP((uint)vstart);
80102f3b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102f41:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102f47:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102f4d:	39 de                	cmp    %ebx,%esi
80102f4f:	72 23                	jb     80102f74 <kinit2+0x44>
80102f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree(p);
80102f58:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102f5e:	83 ec 0c             	sub    $0xc,%esp
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102f61:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
80102f67:	50                   	push   %eax
80102f68:	e8 73 fe ff ff       	call   80102de0 <kfree>
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102f6d:	83 c4 10             	add    $0x10,%esp
80102f70:	39 de                	cmp    %ebx,%esi
80102f72:	73 e4                	jae    80102f58 <kinit2+0x28>
    kmem.use_lock = 1;
80102f74:	c7 05 54 4e 11 80 01 	movl   $0x1,0x80114e54
80102f7b:	00 00 00 
}
80102f7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102f81:	5b                   	pop    %ebx
80102f82:	5e                   	pop    %esi
80102f83:	5d                   	pop    %ebp
80102f84:	c3                   	ret    
80102f85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f90 <kalloc>:
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char* kalloc(void)  {
    struct run *r;

    if (kmem.use_lock) {
80102f90:	a1 54 4e 11 80       	mov    0x80114e54,%eax
80102f95:	85 c0                	test   %eax,%eax
80102f97:	75 1f                	jne    80102fb8 <kalloc+0x28>
        acquire(&kmem.lock);
    }
    r = kmem.freelist;
80102f99:	a1 58 4e 11 80       	mov    0x80114e58,%eax
    if (r) {
80102f9e:	85 c0                	test   %eax,%eax
80102fa0:	74 0e                	je     80102fb0 <kalloc+0x20>
        kmem.freelist = r->next;
80102fa2:	8b 10                	mov    (%eax),%edx
80102fa4:	89 15 58 4e 11 80    	mov    %edx,0x80114e58
80102faa:	c3                   	ret    
80102fab:	90                   	nop
80102fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if (kmem.use_lock) {
        release(&kmem.lock);
    }
    return (char*)r;
}
80102fb0:	f3 c3                	repz ret 
80102fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
char* kalloc(void)  {
80102fb8:	55                   	push   %ebp
80102fb9:	89 e5                	mov    %esp,%ebp
80102fbb:	83 ec 24             	sub    $0x24,%esp
        acquire(&kmem.lock);
80102fbe:	68 20 4e 11 80       	push   $0x80114e20
80102fc3:	e8 78 1e 00 00       	call   80104e40 <acquire>
    r = kmem.freelist;
80102fc8:	a1 58 4e 11 80       	mov    0x80114e58,%eax
    if (r) {
80102fcd:	83 c4 10             	add    $0x10,%esp
80102fd0:	8b 15 54 4e 11 80    	mov    0x80114e54,%edx
80102fd6:	85 c0                	test   %eax,%eax
80102fd8:	74 08                	je     80102fe2 <kalloc+0x52>
        kmem.freelist = r->next;
80102fda:	8b 08                	mov    (%eax),%ecx
80102fdc:	89 0d 58 4e 11 80    	mov    %ecx,0x80114e58
    if (kmem.use_lock) {
80102fe2:	85 d2                	test   %edx,%edx
80102fe4:	74 16                	je     80102ffc <kalloc+0x6c>
        release(&kmem.lock);
80102fe6:	83 ec 0c             	sub    $0xc,%esp
80102fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102fec:	68 20 4e 11 80       	push   $0x80114e20
80102ff1:	e8 0a 1f 00 00       	call   80104f00 <release>
    return (char*)r;
80102ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
        release(&kmem.lock);
80102ff9:	83 c4 10             	add    $0x10,%esp
}
80102ffc:	c9                   	leave  
80102ffd:	c3                   	ret    
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <kbdgetc>:
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80103000:	ba 64 00 00 00       	mov    $0x64,%edx
80103005:	ec                   	in     (%dx),%al
        normalmap, shiftmap, ctlmap, ctlmap
    };
    uint st, data, c;

    st = inb(KBSTATP);
    if ((st & KBS_DIB) == 0) {
80103006:	a8 01                	test   $0x1,%al
80103008:	0f 84 c2 00 00 00    	je     801030d0 <kbdgetc+0xd0>
8010300e:	ba 60 00 00 00       	mov    $0x60,%edx
80103013:	ec                   	in     (%dx),%al
        return -1;
    }
    data = inb(KBDATAP);
80103014:	0f b6 d0             	movzbl %al,%edx
80103017:	8b 0d b4 c5 10 80    	mov    0x8010c5b4,%ecx

    if (data == 0xE0) {
8010301d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80103023:	0f 84 7f 00 00 00    	je     801030a8 <kbdgetc+0xa8>
int kbdgetc(void) {
80103029:	55                   	push   %ebp
8010302a:	89 e5                	mov    %esp,%ebp
8010302c:	53                   	push   %ebx
8010302d:	89 cb                	mov    %ecx,%ebx
8010302f:	83 e3 40             	and    $0x40,%ebx
        shift |= E0ESC;
        return 0;
    }
    else if (data & 0x80) {
80103032:	84 c0                	test   %al,%al
80103034:	78 4a                	js     80103080 <kbdgetc+0x80>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
        shift &= ~(shiftcode[data] | E0ESC);
        return 0;
    }
    else if (shift & E0ESC) {
80103036:	85 db                	test   %ebx,%ebx
80103038:	74 09                	je     80103043 <kbdgetc+0x43>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
8010303a:	83 c8 80             	or     $0xffffff80,%eax
        shift &= ~E0ESC;
8010303d:	83 e1 bf             	and    $0xffffffbf,%ecx
        data |= 0x80;
80103040:	0f b6 d0             	movzbl %al,%edx
    }

    shift |= shiftcode[data];
80103043:	0f b6 82 00 7f 10 80 	movzbl -0x7fef8100(%edx),%eax
8010304a:	09 c1                	or     %eax,%ecx
    shift ^= togglecode[data];
8010304c:	0f b6 82 00 7e 10 80 	movzbl -0x7fef8200(%edx),%eax
80103053:	31 c1                	xor    %eax,%ecx
    c = charcode[shift & (CTL | SHIFT)][data];
80103055:	89 c8                	mov    %ecx,%eax
    shift ^= togglecode[data];
80103057:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
    c = charcode[shift & (CTL | SHIFT)][data];
8010305d:	83 e0 03             	and    $0x3,%eax
    if (shift & CAPSLOCK) {
80103060:	83 e1 08             	and    $0x8,%ecx
    c = charcode[shift & (CTL | SHIFT)][data];
80103063:	8b 04 85 e0 7d 10 80 	mov    -0x7fef8220(,%eax,4),%eax
8010306a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
    if (shift & CAPSLOCK) {
8010306e:	74 31                	je     801030a1 <kbdgetc+0xa1>
        if ('a' <= c && c <= 'z') {
80103070:	8d 50 9f             	lea    -0x61(%eax),%edx
80103073:	83 fa 19             	cmp    $0x19,%edx
80103076:	77 40                	ja     801030b8 <kbdgetc+0xb8>
            c += 'A' - 'a';
80103078:	83 e8 20             	sub    $0x20,%eax
        else if ('A' <= c && c <= 'Z') {
            c += 'a' - 'A';
        }
    }
    return c;
}
8010307b:	5b                   	pop    %ebx
8010307c:	5d                   	pop    %ebp
8010307d:	c3                   	ret    
8010307e:	66 90                	xchg   %ax,%ax
        data = (shift & E0ESC ? data : data & 0x7F);
80103080:	83 e0 7f             	and    $0x7f,%eax
80103083:	85 db                	test   %ebx,%ebx
80103085:	0f 44 d0             	cmove  %eax,%edx
        shift &= ~(shiftcode[data] | E0ESC);
80103088:	0f b6 82 00 7f 10 80 	movzbl -0x7fef8100(%edx),%eax
8010308f:	83 c8 40             	or     $0x40,%eax
80103092:	0f b6 c0             	movzbl %al,%eax
80103095:	f7 d0                	not    %eax
80103097:	21 c1                	and    %eax,%ecx
        return 0;
80103099:	31 c0                	xor    %eax,%eax
        shift &= ~(shiftcode[data] | E0ESC);
8010309b:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
801030a1:	5b                   	pop    %ebx
801030a2:	5d                   	pop    %ebp
801030a3:	c3                   	ret    
801030a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        shift |= E0ESC;
801030a8:	83 c9 40             	or     $0x40,%ecx
        return 0;
801030ab:	31 c0                	xor    %eax,%eax
        shift |= E0ESC;
801030ad:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
        return 0;
801030b3:	c3                   	ret    
801030b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        else if ('A' <= c && c <= 'Z') {
801030b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
            c += 'a' - 'A';
801030bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801030be:	5b                   	pop    %ebx
            c += 'a' - 'A';
801030bf:	83 f9 1a             	cmp    $0x1a,%ecx
801030c2:	0f 42 c2             	cmovb  %edx,%eax
}
801030c5:	5d                   	pop    %ebp
801030c6:	c3                   	ret    
801030c7:	89 f6                	mov    %esi,%esi
801030c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return -1;
801030d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801030d5:	c3                   	ret    
801030d6:	8d 76 00             	lea    0x0(%esi),%esi
801030d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030e0 <kbdintr>:

void kbdintr(void) {
801030e0:	55                   	push   %ebp
801030e1:	89 e5                	mov    %esp,%ebp
801030e3:	83 ec 14             	sub    $0x14,%esp
    consoleintr(kbdgetc);
801030e6:	68 00 30 10 80       	push   $0x80103000
801030eb:	e8 70 d9 ff ff       	call   80100a60 <consoleintr>
}
801030f0:	83 c4 10             	add    $0x10,%esp
801030f3:	c9                   	leave  
801030f4:	c3                   	ret    
801030f5:	66 90                	xchg   %ax,%ax
801030f7:	66 90                	xchg   %ax,%ax
801030f9:	66 90                	xchg   %ax,%ax
801030fb:	66 90                	xchg   %ax,%ax
801030fd:	66 90                	xchg   %ax,%ax
801030ff:	90                   	nop

80103100 <lapicinit>:
    lapic[index] = value;
    lapic[ID];  // wait for write to finish, by reading
}

void lapicinit(void) {
    if (!lapic) {
80103100:	a1 5c 4e 11 80       	mov    0x80114e5c,%eax
void lapicinit(void) {
80103105:	55                   	push   %ebp
80103106:	89 e5                	mov    %esp,%ebp
    if (!lapic) {
80103108:	85 c0                	test   %eax,%eax
8010310a:	0f 84 c8 00 00 00    	je     801031d8 <lapicinit+0xd8>
    lapic[index] = value;
80103110:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103117:	01 00 00 
    lapic[ID];  // wait for write to finish, by reading
8010311a:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
8010311d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103124:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80103127:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
8010312a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103131:	00 02 00 
    lapic[ID];  // wait for write to finish, by reading
80103134:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80103137:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010313e:	96 98 00 
    lapic[ID];  // wait for write to finish, by reading
80103141:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80103144:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010314b:	00 01 00 
    lapic[ID];  // wait for write to finish, by reading
8010314e:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80103151:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103158:	00 01 00 
    lapic[ID];  // wait for write to finish, by reading
8010315b:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(LINT0, MASKED);
    lapicw(LINT1, MASKED);

    // Disable performance counter overflow interrupts
    // on machines that provide that interrupt entry.
    if (((lapic[VER] >> 16) & 0xFF) >= 4) {
8010315e:	8b 50 30             	mov    0x30(%eax),%edx
80103161:	c1 ea 10             	shr    $0x10,%edx
80103164:	80 fa 03             	cmp    $0x3,%dl
80103167:	77 77                	ja     801031e0 <lapicinit+0xe0>
    lapic[index] = value;
80103169:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103170:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80103173:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80103176:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010317d:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80103180:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80103183:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010318a:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
8010318d:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80103190:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103197:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
8010319a:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
8010319d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801031a4:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
801031a7:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
801031aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801031b1:	85 08 00 
    lapic[ID];  // wait for write to finish, by reading
801031b4:	8b 50 20             	mov    0x20(%eax),%edx
801031b7:	89 f6                	mov    %esi,%esi
801031b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapicw(EOI, 0);

    // Send an Init Level De-Assert to synchronise arbitration ID's.
    lapicw(ICRHI, 0);
    lapicw(ICRLO, BCAST | INIT | LEVEL);
    while (lapic[ICRLO] & DELIVS) {
801031c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801031c6:	80 e6 10             	and    $0x10,%dh
801031c9:	75 f5                	jne    801031c0 <lapicinit+0xc0>
    lapic[index] = value;
801031cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801031d2:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
801031d5:	8b 40 20             	mov    0x20(%eax),%eax
        ;
    }

    // Enable interrupts on the APIC (but not on the processor).
    lapicw(TPR, 0);
}
801031d8:	5d                   	pop    %ebp
801031d9:	c3                   	ret    
801031da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapic[index] = value;
801031e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801031e7:	00 01 00 
    lapic[ID];  // wait for write to finish, by reading
801031ea:	8b 50 20             	mov    0x20(%eax),%edx
801031ed:	e9 77 ff ff ff       	jmp    80103169 <lapicinit+0x69>
801031f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103200 <lapicid>:

int lapicid(void) {
    if (!lapic) {
80103200:	8b 15 5c 4e 11 80    	mov    0x80114e5c,%edx
int lapicid(void) {
80103206:	55                   	push   %ebp
80103207:	31 c0                	xor    %eax,%eax
80103209:	89 e5                	mov    %esp,%ebp
    if (!lapic) {
8010320b:	85 d2                	test   %edx,%edx
8010320d:	74 06                	je     80103215 <lapicid+0x15>
        return 0;
    }
    return lapic[ID] >> 24;
8010320f:	8b 42 20             	mov    0x20(%edx),%eax
80103212:	c1 e8 18             	shr    $0x18,%eax
}
80103215:	5d                   	pop    %ebp
80103216:	c3                   	ret    
80103217:	89 f6                	mov    %esi,%esi
80103219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103220 <lapiceoi>:

// Acknowledge interrupt.
void lapiceoi(void) {
    if (lapic) {
80103220:	a1 5c 4e 11 80       	mov    0x80114e5c,%eax
void lapiceoi(void) {
80103225:	55                   	push   %ebp
80103226:	89 e5                	mov    %esp,%ebp
    if (lapic) {
80103228:	85 c0                	test   %eax,%eax
8010322a:	74 0d                	je     80103239 <lapiceoi+0x19>
    lapic[index] = value;
8010322c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103233:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80103236:	8b 40 20             	mov    0x20(%eax),%eax
        lapicw(EOI, 0);
    }
}
80103239:	5d                   	pop    %ebp
8010323a:	c3                   	ret    
8010323b:	90                   	nop
8010323c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103240 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void microdelay(int us) {
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
}
80103243:	5d                   	pop    %ebp
80103244:	c3                   	ret    
80103245:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103250 <lapicstartap>:
#define CMOS_PORT    0x70
#define CMOS_RETURN  0x71

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void lapicstartap(uchar apicid, uint addr)      {
80103250:	55                   	push   %ebp
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80103251:	b8 0f 00 00 00       	mov    $0xf,%eax
80103256:	ba 70 00 00 00       	mov    $0x70,%edx
8010325b:	89 e5                	mov    %esp,%ebp
8010325d:	53                   	push   %ebx
8010325e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103261:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103264:	ee                   	out    %al,(%dx)
80103265:	b8 0a 00 00 00       	mov    $0xa,%eax
8010326a:	ba 71 00 00 00       	mov    $0x71,%edx
8010326f:	ee                   	out    %al,(%dx)
    // and the warm reset vector (DWORD based at 40:67) to point at
    // the AP startup code prior to the [universal startup algorithm]."
    outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
    outb(CMOS_PORT + 1, 0x0A);
    wrv = (ushort*)P2V((0x40 << 4 | 0x67));  // Warm reset vector
    wrv[0] = 0;
80103270:	31 c0                	xor    %eax,%eax
    wrv[1] = addr >> 4;

    // "Universal startup algorithm."
    // Send INIT (level-triggered) interrupt to reset other CPU.
    lapicw(ICRHI, apicid << 24);
80103272:	c1 e3 18             	shl    $0x18,%ebx
    wrv[0] = 0;
80103275:	66 a3 67 04 00 80    	mov    %ax,0x80000467
    wrv[1] = addr >> 4;
8010327b:	89 c8                	mov    %ecx,%eax
    // when it is in the halted state due to an INIT.  So the second
    // should be ignored, but it is part of the official Intel algorithm.
    // Bochs complains about the second one.  Too bad for Bochs.
    for (i = 0; i < 2; i++) {
        lapicw(ICRHI, apicid << 24);
        lapicw(ICRLO, STARTUP | (addr >> 12));
8010327d:	c1 e9 0c             	shr    $0xc,%ecx
    wrv[1] = addr >> 4;
80103280:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRHI, apicid << 24);
80103283:	89 da                	mov    %ebx,%edx
        lapicw(ICRLO, STARTUP | (addr >> 12));
80103285:	80 cd 06             	or     $0x6,%ch
    wrv[1] = addr >> 4;
80103288:	66 a3 69 04 00 80    	mov    %ax,0x80000469
    lapic[index] = value;
8010328e:	a1 5c 4e 11 80       	mov    0x80114e5c,%eax
80103293:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
    lapic[ID];  // wait for write to finish, by reading
80103299:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
8010329c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801032a3:	c5 00 00 
    lapic[ID];  // wait for write to finish, by reading
801032a6:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
801032a9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801032b0:	85 00 00 
    lapic[ID];  // wait for write to finish, by reading
801032b3:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
801032b6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
    lapic[ID];  // wait for write to finish, by reading
801032bc:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
801032bf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    lapic[ID];  // wait for write to finish, by reading
801032c5:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
801032c8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
    lapic[ID];  // wait for write to finish, by reading
801032ce:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
801032d1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    lapic[ID];  // wait for write to finish, by reading
801032d7:	8b 40 20             	mov    0x20(%eax),%eax
        microdelay(200);
    }
}
801032da:	5b                   	pop    %ebx
801032db:	5d                   	pop    %ebp
801032dc:	c3                   	ret    
801032dd:	8d 76 00             	lea    0x0(%esi),%esi

801032e0 <cmostime>:
    r->month  = cmos_read(MONTH);
    r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r) {
801032e0:	55                   	push   %ebp
801032e1:	b8 0b 00 00 00       	mov    $0xb,%eax
801032e6:	ba 70 00 00 00       	mov    $0x70,%edx
801032eb:	89 e5                	mov    %esp,%ebp
801032ed:	57                   	push   %edi
801032ee:	56                   	push   %esi
801032ef:	53                   	push   %ebx
801032f0:	83 ec 4c             	sub    $0x4c,%esp
801032f3:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801032f4:	ba 71 00 00 00       	mov    $0x71,%edx
801032f9:	ec                   	in     (%dx),%al
801032fa:	83 e0 04             	and    $0x4,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801032fd:	bb 70 00 00 00       	mov    $0x70,%ebx
80103302:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103305:	8d 76 00             	lea    0x0(%esi),%esi
80103308:	31 c0                	xor    %eax,%eax
8010330a:	89 da                	mov    %ebx,%edx
8010330c:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
8010330d:	b9 71 00 00 00       	mov    $0x71,%ecx
80103312:	89 ca                	mov    %ecx,%edx
80103314:	ec                   	in     (%dx),%al
80103315:	88 45 b7             	mov    %al,-0x49(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80103318:	89 da                	mov    %ebx,%edx
8010331a:	b8 02 00 00 00       	mov    $0x2,%eax
8010331f:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80103320:	89 ca                	mov    %ecx,%edx
80103322:	ec                   	in     (%dx),%al
80103323:	88 45 b6             	mov    %al,-0x4a(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80103326:	89 da                	mov    %ebx,%edx
80103328:	b8 04 00 00 00       	mov    $0x4,%eax
8010332d:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
8010332e:	89 ca                	mov    %ecx,%edx
80103330:	ec                   	in     (%dx),%al
80103331:	88 45 b5             	mov    %al,-0x4b(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80103334:	89 da                	mov    %ebx,%edx
80103336:	b8 07 00 00 00       	mov    $0x7,%eax
8010333b:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
8010333c:	89 ca                	mov    %ecx,%edx
8010333e:	ec                   	in     (%dx),%al
8010333f:	88 45 b4             	mov    %al,-0x4c(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80103342:	89 da                	mov    %ebx,%edx
80103344:	b8 08 00 00 00       	mov    $0x8,%eax
80103349:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
8010334a:	89 ca                	mov    %ecx,%edx
8010334c:	ec                   	in     (%dx),%al
8010334d:	89 c7                	mov    %eax,%edi
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
8010334f:	89 da                	mov    %ebx,%edx
80103351:	b8 09 00 00 00       	mov    $0x9,%eax
80103356:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80103357:	89 ca                	mov    %ecx,%edx
80103359:	ec                   	in     (%dx),%al
8010335a:	89 c6                	mov    %eax,%esi
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
8010335c:	89 da                	mov    %ebx,%edx
8010335e:	b8 0a 00 00 00       	mov    $0xa,%eax
80103363:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80103364:	89 ca                	mov    %ecx,%edx
80103366:	ec                   	in     (%dx),%al
    bcd = (sb & (1 << 2)) == 0;

    // make sure CMOS doesn't modify time while we read it
    for (;;) {
        fill_rtcdate(&t1);
        if (cmos_read(CMOS_STATA) & CMOS_UIP) {
80103367:	84 c0                	test   %al,%al
80103369:	78 9d                	js     80103308 <cmostime+0x28>
    return inb(CMOS_RETURN);
8010336b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010336f:	89 fa                	mov    %edi,%edx
80103371:	0f b6 fa             	movzbl %dl,%edi
80103374:	89 f2                	mov    %esi,%edx
80103376:	0f b6 f2             	movzbl %dl,%esi
80103379:	89 7d c8             	mov    %edi,-0x38(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
8010337c:	89 da                	mov    %ebx,%edx
8010337e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103381:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103384:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103388:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010338b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010338f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103392:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103396:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103399:	31 c0                	xor    %eax,%eax
8010339b:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
8010339c:	89 ca                	mov    %ecx,%edx
8010339e:	ec                   	in     (%dx),%al
8010339f:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801033a2:	89 da                	mov    %ebx,%edx
801033a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801033a7:	b8 02 00 00 00       	mov    $0x2,%eax
801033ac:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801033ad:	89 ca                	mov    %ecx,%edx
801033af:	ec                   	in     (%dx),%al
801033b0:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801033b3:	89 da                	mov    %ebx,%edx
801033b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801033b8:	b8 04 00 00 00       	mov    $0x4,%eax
801033bd:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801033be:	89 ca                	mov    %ecx,%edx
801033c0:	ec                   	in     (%dx),%al
801033c1:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801033c4:	89 da                	mov    %ebx,%edx
801033c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801033c9:	b8 07 00 00 00       	mov    $0x7,%eax
801033ce:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801033cf:	89 ca                	mov    %ecx,%edx
801033d1:	ec                   	in     (%dx),%al
801033d2:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801033d5:	89 da                	mov    %ebx,%edx
801033d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801033da:	b8 08 00 00 00       	mov    $0x8,%eax
801033df:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801033e0:	89 ca                	mov    %ecx,%edx
801033e2:	ec                   	in     (%dx),%al
801033e3:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801033e6:	89 da                	mov    %ebx,%edx
801033e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801033eb:	b8 09 00 00 00       	mov    $0x9,%eax
801033f0:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801033f1:	89 ca                	mov    %ecx,%edx
801033f3:	ec                   	in     (%dx),%al
801033f4:	0f b6 c0             	movzbl %al,%eax
            continue;
        }
        fill_rtcdate(&t2);
        if (memcmp(&t1, &t2, sizeof(t1)) == 0) {
801033f7:	83 ec 04             	sub    $0x4,%esp
    return inb(CMOS_RETURN);
801033fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (memcmp(&t1, &t2, sizeof(t1)) == 0) {
801033fd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103400:	6a 18                	push   $0x18
80103402:	50                   	push   %eax
80103403:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103406:	50                   	push   %eax
80103407:	e8 94 1b 00 00       	call   80104fa0 <memcmp>
8010340c:	83 c4 10             	add    $0x10,%esp
8010340f:	85 c0                	test   %eax,%eax
80103411:	0f 85 f1 fe ff ff    	jne    80103308 <cmostime+0x28>
            break;
        }
    }

    // convert
    if (bcd) {
80103417:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010341b:	75 78                	jne    80103495 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
        CONV(second);
8010341d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103420:	89 c2                	mov    %eax,%edx
80103422:	83 e0 0f             	and    $0xf,%eax
80103425:	c1 ea 04             	shr    $0x4,%edx
80103428:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010342b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010342e:	89 45 b8             	mov    %eax,-0x48(%ebp)
        CONV(minute);
80103431:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103434:	89 c2                	mov    %eax,%edx
80103436:	83 e0 0f             	and    $0xf,%eax
80103439:	c1 ea 04             	shr    $0x4,%edx
8010343c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010343f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103442:	89 45 bc             	mov    %eax,-0x44(%ebp)
        CONV(hour  );
80103445:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103448:	89 c2                	mov    %eax,%edx
8010344a:	83 e0 0f             	and    $0xf,%eax
8010344d:	c1 ea 04             	shr    $0x4,%edx
80103450:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103453:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103456:	89 45 c0             	mov    %eax,-0x40(%ebp)
        CONV(day   );
80103459:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010345c:	89 c2                	mov    %eax,%edx
8010345e:	83 e0 0f             	and    $0xf,%eax
80103461:	c1 ea 04             	shr    $0x4,%edx
80103464:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103467:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010346a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        CONV(month );
8010346d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103470:	89 c2                	mov    %eax,%edx
80103472:	83 e0 0f             	and    $0xf,%eax
80103475:	c1 ea 04             	shr    $0x4,%edx
80103478:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010347b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010347e:	89 45 c8             	mov    %eax,-0x38(%ebp)
        CONV(year  );
80103481:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103484:	89 c2                	mov    %eax,%edx
80103486:	83 e0 0f             	and    $0xf,%eax
80103489:	c1 ea 04             	shr    $0x4,%edx
8010348c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010348f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103492:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
    }

    *r = t1;
80103495:	8b 75 08             	mov    0x8(%ebp),%esi
80103498:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010349b:	89 06                	mov    %eax,(%esi)
8010349d:	8b 45 bc             	mov    -0x44(%ebp),%eax
801034a0:	89 46 04             	mov    %eax,0x4(%esi)
801034a3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801034a6:	89 46 08             	mov    %eax,0x8(%esi)
801034a9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801034ac:	89 46 0c             	mov    %eax,0xc(%esi)
801034af:	8b 45 c8             	mov    -0x38(%ebp),%eax
801034b2:	89 46 10             	mov    %eax,0x10(%esi)
801034b5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801034b8:	89 46 14             	mov    %eax,0x14(%esi)
    r->year += 2000;
801034bb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801034c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034c5:	5b                   	pop    %ebx
801034c6:	5e                   	pop    %esi
801034c7:	5f                   	pop    %edi
801034c8:	5d                   	pop    %ebp
801034c9:	c3                   	ret    
801034ca:	66 90                	xchg   %ax,%ax
801034cc:	66 90                	xchg   %ax,%ax
801034ce:	66 90                	xchg   %ax,%ax

801034d0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801034d0:	8b 0d a8 4e 11 80    	mov    0x80114ea8,%ecx
801034d6:	85 c9                	test   %ecx,%ecx
801034d8:	0f 8e 8a 00 00 00    	jle    80103568 <install_trans+0x98>
{
801034de:	55                   	push   %ebp
801034df:	89 e5                	mov    %esp,%ebp
801034e1:	57                   	push   %edi
801034e2:	56                   	push   %esi
801034e3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
801034e4:	31 db                	xor    %ebx,%ebx
{
801034e6:	83 ec 0c             	sub    $0xc,%esp
801034e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801034f0:	a1 94 4e 11 80       	mov    0x80114e94,%eax
801034f5:	83 ec 08             	sub    $0x8,%esp
801034f8:	01 d8                	add    %ebx,%eax
801034fa:	83 c0 01             	add    $0x1,%eax
801034fd:	50                   	push   %eax
801034fe:	ff 35 a4 4e 11 80    	pushl  0x80114ea4
80103504:	e8 c7 cb ff ff       	call   801000d0 <bread>
80103509:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010350b:	58                   	pop    %eax
8010350c:	5a                   	pop    %edx
8010350d:	ff 34 9d ac 4e 11 80 	pushl  -0x7feeb154(,%ebx,4)
80103514:	ff 35 a4 4e 11 80    	pushl  0x80114ea4
  for (tail = 0; tail < log.lh.n; tail++) {
8010351a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010351d:	e8 ae cb ff ff       	call   801000d0 <bread>
80103522:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103524:	8d 47 5c             	lea    0x5c(%edi),%eax
80103527:	83 c4 0c             	add    $0xc,%esp
8010352a:	68 00 02 00 00       	push   $0x200
8010352f:	50                   	push   %eax
80103530:	8d 46 5c             	lea    0x5c(%esi),%eax
80103533:	50                   	push   %eax
80103534:	e8 c7 1a 00 00       	call   80105000 <memmove>
    bwrite(dbuf);  // write dst to disk
80103539:	89 34 24             	mov    %esi,(%esp)
8010353c:	e8 5f cc ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80103541:	89 3c 24             	mov    %edi,(%esp)
80103544:	e8 97 cc ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80103549:	89 34 24             	mov    %esi,(%esp)
8010354c:	e8 8f cc ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103551:	83 c4 10             	add    $0x10,%esp
80103554:	39 1d a8 4e 11 80    	cmp    %ebx,0x80114ea8
8010355a:	7f 94                	jg     801034f0 <install_trans+0x20>
  }
}
8010355c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010355f:	5b                   	pop    %ebx
80103560:	5e                   	pop    %esi
80103561:	5f                   	pop    %edi
80103562:	5d                   	pop    %ebp
80103563:	c3                   	ret    
80103564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103568:	f3 c3                	repz ret 
8010356a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103570 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	56                   	push   %esi
80103574:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80103575:	83 ec 08             	sub    $0x8,%esp
80103578:	ff 35 94 4e 11 80    	pushl  0x80114e94
8010357e:	ff 35 a4 4e 11 80    	pushl  0x80114ea4
80103584:	e8 47 cb ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103589:	8b 1d a8 4e 11 80    	mov    0x80114ea8,%ebx
  for (i = 0; i < log.lh.n; i++) {
8010358f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103592:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80103594:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80103596:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103599:	7e 16                	jle    801035b1 <write_head+0x41>
8010359b:	c1 e3 02             	shl    $0x2,%ebx
8010359e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
801035a0:	8b 8a ac 4e 11 80    	mov    -0x7feeb154(%edx),%ecx
801035a6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
801035aa:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
801035ad:	39 da                	cmp    %ebx,%edx
801035af:	75 ef                	jne    801035a0 <write_head+0x30>
  }
  bwrite(buf);
801035b1:	83 ec 0c             	sub    $0xc,%esp
801035b4:	56                   	push   %esi
801035b5:	e8 e6 cb ff ff       	call   801001a0 <bwrite>
  brelse(buf);
801035ba:	89 34 24             	mov    %esi,(%esp)
801035bd:	e8 1e cc ff ff       	call   801001e0 <brelse>
}
801035c2:	83 c4 10             	add    $0x10,%esp
801035c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035c8:	5b                   	pop    %ebx
801035c9:	5e                   	pop    %esi
801035ca:	5d                   	pop    %ebp
801035cb:	c3                   	ret    
801035cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801035d0 <initlog>:
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	53                   	push   %ebx
801035d4:	83 ec 2c             	sub    $0x2c,%esp
801035d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801035da:	68 00 80 10 80       	push   $0x80108000
801035df:	68 60 4e 11 80       	push   $0x80114e60
801035e4:	e8 17 17 00 00       	call   80104d00 <initlock>
  readsb(dev, &sb);
801035e9:	58                   	pop    %eax
801035ea:	8d 45 dc             	lea    -0x24(%ebp),%eax
801035ed:	5a                   	pop    %edx
801035ee:	50                   	push   %eax
801035ef:	53                   	push   %ebx
801035f0:	e8 1b e9 ff ff       	call   80101f10 <readsb>
  log.size = sb.nlog;
801035f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801035f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801035fb:	59                   	pop    %ecx
  log.dev = dev;
801035fc:	89 1d a4 4e 11 80    	mov    %ebx,0x80114ea4
  log.size = sb.nlog;
80103602:	89 15 98 4e 11 80    	mov    %edx,0x80114e98
  log.start = sb.logstart;
80103608:	a3 94 4e 11 80       	mov    %eax,0x80114e94
  struct buf *buf = bread(log.dev, log.start);
8010360d:	5a                   	pop    %edx
8010360e:	50                   	push   %eax
8010360f:	53                   	push   %ebx
80103610:	e8 bb ca ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103615:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103618:	83 c4 10             	add    $0x10,%esp
8010361b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010361d:	89 1d a8 4e 11 80    	mov    %ebx,0x80114ea8
  for (i = 0; i < log.lh.n; i++) {
80103623:	7e 1c                	jle    80103641 <initlog+0x71>
80103625:	c1 e3 02             	shl    $0x2,%ebx
80103628:	31 d2                	xor    %edx,%edx
8010362a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103630:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103634:	83 c2 04             	add    $0x4,%edx
80103637:	89 8a a8 4e 11 80    	mov    %ecx,-0x7feeb158(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010363d:	39 d3                	cmp    %edx,%ebx
8010363f:	75 ef                	jne    80103630 <initlog+0x60>
  brelse(buf);
80103641:	83 ec 0c             	sub    $0xc,%esp
80103644:	50                   	push   %eax
80103645:	e8 96 cb ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010364a:	e8 81 fe ff ff       	call   801034d0 <install_trans>
  log.lh.n = 0;
8010364f:	c7 05 a8 4e 11 80 00 	movl   $0x0,0x80114ea8
80103656:	00 00 00 
  write_head(); // clear the log
80103659:	e8 12 ff ff ff       	call   80103570 <write_head>
}
8010365e:	83 c4 10             	add    $0x10,%esp
80103661:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103664:	c9                   	leave  
80103665:	c3                   	ret    
80103666:	8d 76 00             	lea    0x0(%esi),%esi
80103669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103670 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103676:	68 60 4e 11 80       	push   $0x80114e60
8010367b:	e8 c0 17 00 00       	call   80104e40 <acquire>
80103680:	83 c4 10             	add    $0x10,%esp
80103683:	eb 18                	jmp    8010369d <begin_op+0x2d>
80103685:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103688:	83 ec 08             	sub    $0x8,%esp
8010368b:	68 60 4e 11 80       	push   $0x80114e60
80103690:	68 60 4e 11 80       	push   $0x80114e60
80103695:	e8 e6 11 00 00       	call   80104880 <sleep>
8010369a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010369d:	a1 a0 4e 11 80       	mov    0x80114ea0,%eax
801036a2:	85 c0                	test   %eax,%eax
801036a4:	75 e2                	jne    80103688 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801036a6:	a1 9c 4e 11 80       	mov    0x80114e9c,%eax
801036ab:	8b 15 a8 4e 11 80    	mov    0x80114ea8,%edx
801036b1:	83 c0 01             	add    $0x1,%eax
801036b4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801036b7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801036ba:	83 fa 1e             	cmp    $0x1e,%edx
801036bd:	7f c9                	jg     80103688 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801036bf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801036c2:	a3 9c 4e 11 80       	mov    %eax,0x80114e9c
      release(&log.lock);
801036c7:	68 60 4e 11 80       	push   $0x80114e60
801036cc:	e8 2f 18 00 00       	call   80104f00 <release>
      break;
    }
  }
}
801036d1:	83 c4 10             	add    $0x10,%esp
801036d4:	c9                   	leave  
801036d5:	c3                   	ret    
801036d6:	8d 76 00             	lea    0x0(%esi),%esi
801036d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036e0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	57                   	push   %edi
801036e4:	56                   	push   %esi
801036e5:	53                   	push   %ebx
801036e6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801036e9:	68 60 4e 11 80       	push   $0x80114e60
801036ee:	e8 4d 17 00 00       	call   80104e40 <acquire>
  log.outstanding -= 1;
801036f3:	a1 9c 4e 11 80       	mov    0x80114e9c,%eax
  if(log.committing)
801036f8:	8b 35 a0 4e 11 80    	mov    0x80114ea0,%esi
801036fe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103701:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103704:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103706:	89 1d 9c 4e 11 80    	mov    %ebx,0x80114e9c
  if(log.committing)
8010370c:	0f 85 1a 01 00 00    	jne    8010382c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103712:	85 db                	test   %ebx,%ebx
80103714:	0f 85 ee 00 00 00    	jne    80103808 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010371a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010371d:	c7 05 a0 4e 11 80 01 	movl   $0x1,0x80114ea0
80103724:	00 00 00 
  release(&log.lock);
80103727:	68 60 4e 11 80       	push   $0x80114e60
8010372c:	e8 cf 17 00 00       	call   80104f00 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103731:	8b 0d a8 4e 11 80    	mov    0x80114ea8,%ecx
80103737:	83 c4 10             	add    $0x10,%esp
8010373a:	85 c9                	test   %ecx,%ecx
8010373c:	0f 8e 85 00 00 00    	jle    801037c7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103742:	a1 94 4e 11 80       	mov    0x80114e94,%eax
80103747:	83 ec 08             	sub    $0x8,%esp
8010374a:	01 d8                	add    %ebx,%eax
8010374c:	83 c0 01             	add    $0x1,%eax
8010374f:	50                   	push   %eax
80103750:	ff 35 a4 4e 11 80    	pushl  0x80114ea4
80103756:	e8 75 c9 ff ff       	call   801000d0 <bread>
8010375b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010375d:	58                   	pop    %eax
8010375e:	5a                   	pop    %edx
8010375f:	ff 34 9d ac 4e 11 80 	pushl  -0x7feeb154(,%ebx,4)
80103766:	ff 35 a4 4e 11 80    	pushl  0x80114ea4
  for (tail = 0; tail < log.lh.n; tail++) {
8010376c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010376f:	e8 5c c9 ff ff       	call   801000d0 <bread>
80103774:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103776:	8d 40 5c             	lea    0x5c(%eax),%eax
80103779:	83 c4 0c             	add    $0xc,%esp
8010377c:	68 00 02 00 00       	push   $0x200
80103781:	50                   	push   %eax
80103782:	8d 46 5c             	lea    0x5c(%esi),%eax
80103785:	50                   	push   %eax
80103786:	e8 75 18 00 00       	call   80105000 <memmove>
    bwrite(to);  // write the log
8010378b:	89 34 24             	mov    %esi,(%esp)
8010378e:	e8 0d ca ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103793:	89 3c 24             	mov    %edi,(%esp)
80103796:	e8 45 ca ff ff       	call   801001e0 <brelse>
    brelse(to);
8010379b:	89 34 24             	mov    %esi,(%esp)
8010379e:	e8 3d ca ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801037a3:	83 c4 10             	add    $0x10,%esp
801037a6:	3b 1d a8 4e 11 80    	cmp    0x80114ea8,%ebx
801037ac:	7c 94                	jl     80103742 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801037ae:	e8 bd fd ff ff       	call   80103570 <write_head>
    install_trans(); // Now install writes to home locations
801037b3:	e8 18 fd ff ff       	call   801034d0 <install_trans>
    log.lh.n = 0;
801037b8:	c7 05 a8 4e 11 80 00 	movl   $0x0,0x80114ea8
801037bf:	00 00 00 
    write_head();    // Erase the transaction from the log
801037c2:	e8 a9 fd ff ff       	call   80103570 <write_head>
    acquire(&log.lock);
801037c7:	83 ec 0c             	sub    $0xc,%esp
801037ca:	68 60 4e 11 80       	push   $0x80114e60
801037cf:	e8 6c 16 00 00       	call   80104e40 <acquire>
    wakeup(&log);
801037d4:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
    log.committing = 0;
801037db:	c7 05 a0 4e 11 80 00 	movl   $0x0,0x80114ea0
801037e2:	00 00 00 
    wakeup(&log);
801037e5:	e8 46 12 00 00       	call   80104a30 <wakeup>
    release(&log.lock);
801037ea:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
801037f1:	e8 0a 17 00 00       	call   80104f00 <release>
801037f6:	83 c4 10             	add    $0x10,%esp
}
801037f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037fc:	5b                   	pop    %ebx
801037fd:	5e                   	pop    %esi
801037fe:	5f                   	pop    %edi
801037ff:	5d                   	pop    %ebp
80103800:	c3                   	ret    
80103801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103808:	83 ec 0c             	sub    $0xc,%esp
8010380b:	68 60 4e 11 80       	push   $0x80114e60
80103810:	e8 1b 12 00 00       	call   80104a30 <wakeup>
  release(&log.lock);
80103815:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
8010381c:	e8 df 16 00 00       	call   80104f00 <release>
80103821:	83 c4 10             	add    $0x10,%esp
}
80103824:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103827:	5b                   	pop    %ebx
80103828:	5e                   	pop    %esi
80103829:	5f                   	pop    %edi
8010382a:	5d                   	pop    %ebp
8010382b:	c3                   	ret    
    panic("log.committing");
8010382c:	83 ec 0c             	sub    $0xc,%esp
8010382f:	68 04 80 10 80       	push   $0x80108004
80103834:	e8 a7 cc ff ff       	call   801004e0 <panic>
80103839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103840 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	53                   	push   %ebx
80103844:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103847:	8b 15 a8 4e 11 80    	mov    0x80114ea8,%edx
{
8010384d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103850:	83 fa 1d             	cmp    $0x1d,%edx
80103853:	0f 8f 9d 00 00 00    	jg     801038f6 <log_write+0xb6>
80103859:	a1 98 4e 11 80       	mov    0x80114e98,%eax
8010385e:	83 e8 01             	sub    $0x1,%eax
80103861:	39 c2                	cmp    %eax,%edx
80103863:	0f 8d 8d 00 00 00    	jge    801038f6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103869:	a1 9c 4e 11 80       	mov    0x80114e9c,%eax
8010386e:	85 c0                	test   %eax,%eax
80103870:	0f 8e 8d 00 00 00    	jle    80103903 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103876:	83 ec 0c             	sub    $0xc,%esp
80103879:	68 60 4e 11 80       	push   $0x80114e60
8010387e:	e8 bd 15 00 00       	call   80104e40 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103883:	8b 0d a8 4e 11 80    	mov    0x80114ea8,%ecx
80103889:	83 c4 10             	add    $0x10,%esp
8010388c:	83 f9 00             	cmp    $0x0,%ecx
8010388f:	7e 57                	jle    801038e8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103891:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103894:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103896:	3b 15 ac 4e 11 80    	cmp    0x80114eac,%edx
8010389c:	75 0b                	jne    801038a9 <log_write+0x69>
8010389e:	eb 38                	jmp    801038d8 <log_write+0x98>
801038a0:	39 14 85 ac 4e 11 80 	cmp    %edx,-0x7feeb154(,%eax,4)
801038a7:	74 2f                	je     801038d8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
801038a9:	83 c0 01             	add    $0x1,%eax
801038ac:	39 c1                	cmp    %eax,%ecx
801038ae:	75 f0                	jne    801038a0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801038b0:	89 14 85 ac 4e 11 80 	mov    %edx,-0x7feeb154(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
801038b7:	83 c0 01             	add    $0x1,%eax
801038ba:	a3 a8 4e 11 80       	mov    %eax,0x80114ea8
  b->flags |= B_DIRTY; // prevent eviction
801038bf:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801038c2:	c7 45 08 60 4e 11 80 	movl   $0x80114e60,0x8(%ebp)
}
801038c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038cc:	c9                   	leave  
  release(&log.lock);
801038cd:	e9 2e 16 00 00       	jmp    80104f00 <release>
801038d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801038d8:	89 14 85 ac 4e 11 80 	mov    %edx,-0x7feeb154(,%eax,4)
801038df:	eb de                	jmp    801038bf <log_write+0x7f>
801038e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038e8:	8b 43 08             	mov    0x8(%ebx),%eax
801038eb:	a3 ac 4e 11 80       	mov    %eax,0x80114eac
  if (i == log.lh.n)
801038f0:	75 cd                	jne    801038bf <log_write+0x7f>
801038f2:	31 c0                	xor    %eax,%eax
801038f4:	eb c1                	jmp    801038b7 <log_write+0x77>
    panic("too big a transaction");
801038f6:	83 ec 0c             	sub    $0xc,%esp
801038f9:	68 13 80 10 80       	push   $0x80108013
801038fe:	e8 dd cb ff ff       	call   801004e0 <panic>
    panic("log_write outside of trans");
80103903:	83 ec 0c             	sub    $0xc,%esp
80103906:	68 29 80 10 80       	push   $0x80108029
8010390b:	e8 d0 cb ff ff       	call   801004e0 <panic>

80103910 <mpmain>:
    lapicinit();
    mpmain();
}

// Common CPU setup code.
static void mpmain(void) {
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	53                   	push   %ebx
80103914:	83 ec 04             	sub    $0x4,%esp
    cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103917:	e8 a4 09 00 00       	call   801042c0 <cpuid>
8010391c:	89 c3                	mov    %eax,%ebx
8010391e:	e8 9d 09 00 00       	call   801042c0 <cpuid>
80103923:	83 ec 04             	sub    $0x4,%esp
80103926:	53                   	push   %ebx
80103927:	50                   	push   %eax
80103928:	68 44 80 10 80       	push   $0x80108044
8010392d:	e8 2e cf ff ff       	call   80100860 <cprintf>
    idtinit();       // load idt register
80103932:	e8 e9 29 00 00       	call   80106320 <idtinit>
    xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103937:	e8 04 09 00 00       	call   80104240 <mycpu>
8010393c:	89 c2                	mov    %eax,%edx

static inline uint xchg(volatile uint *addr, uint newval) {
    uint result;

    // The + in "+m" denotes a read-modify-write operand.
    asm volatile ("lock; xchgl %0, %1" :
8010393e:	b8 01 00 00 00       	mov    $0x1,%eax
80103943:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
    scheduler();     // start running processes
8010394a:	e8 51 0c 00 00       	call   801045a0 <scheduler>
8010394f:	90                   	nop

80103950 <mpenter>:
static void mpenter(void)  {
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	83 ec 08             	sub    $0x8,%esp
    switchkvm();
80103956:	e8 b5 3a 00 00       	call   80107410 <switchkvm>
    seginit();
8010395b:	e8 20 3a 00 00       	call   80107380 <seginit>
    lapicinit();
80103960:	e8 9b f7 ff ff       	call   80103100 <lapicinit>
    mpmain();
80103965:	e8 a6 ff ff ff       	call   80103910 <mpmain>
8010396a:	66 90                	xchg   %ax,%ax
8010396c:	66 90                	xchg   %ax,%ax
8010396e:	66 90                	xchg   %ax,%ax

80103970 <main>:
int main(void) {
80103970:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103974:	83 e4 f0             	and    $0xfffffff0,%esp
80103977:	ff 71 fc             	pushl  -0x4(%ecx)
8010397a:	55                   	push   %ebp
8010397b:	89 e5                	mov    %esp,%ebp
8010397d:	53                   	push   %ebx
8010397e:	51                   	push   %ecx
    kinit1(end, P2V(4 * 1024 * 1024)); // phys page allocator
8010397f:	83 ec 08             	sub    $0x8,%esp
80103982:	68 00 00 40 80       	push   $0x80400000
80103987:	68 88 7c 11 80       	push   $0x80117c88
8010398c:	e8 2f f5 ff ff       	call   80102ec0 <kinit1>
    kvmalloc();      // kernel page table
80103991:	e8 4a 3f 00 00       	call   801078e0 <kvmalloc>
    mpinit();        // detect other processors
80103996:	e8 75 01 00 00       	call   80103b10 <mpinit>
    lapicinit();     // interrupt controller
8010399b:	e8 60 f7 ff ff       	call   80103100 <lapicinit>
    seginit();       // segment descriptors
801039a0:	e8 db 39 00 00       	call   80107380 <seginit>
    picinit();       // disable pic
801039a5:	e8 46 03 00 00       	call   80103cf0 <picinit>
    ioapicinit();    // another interrupt controller
801039aa:	e8 41 f3 ff ff       	call   80102cf0 <ioapicinit>
    consoleinit();   // console hardware
801039af:	e8 5c d2 ff ff       	call   80100c10 <consoleinit>
    uartinit();      // serial port
801039b4:	e8 97 2c 00 00       	call   80106650 <uartinit>
    pinit();         // process table
801039b9:	e8 62 08 00 00       	call   80104220 <pinit>
    tvinit();        // trap vectors
801039be:	e8 dd 28 00 00       	call   801062a0 <tvinit>
    binit();         // buffer cache
801039c3:	e8 78 c6 ff ff       	call   80100040 <binit>
    fileinit();      // file table
801039c8:	e8 63 de ff ff       	call   80101830 <fileinit>
    ideinit();       // disk
801039cd:	e8 fe f0 ff ff       	call   80102ad0 <ideinit>

    // Write entry code to unused memory at 0x7000.
    // The linker has placed the image of entryother.S in
    // _binary_entryother_start.
    code = P2V(0x7000);
    memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801039d2:	83 c4 0c             	add    $0xc,%esp
801039d5:	68 7a 00 00 00       	push   $0x7a
801039da:	68 8c c4 10 80       	push   $0x8010c48c
801039df:	68 00 70 00 80       	push   $0x80007000
801039e4:	e8 17 16 00 00       	call   80105000 <memmove>

    for (c = cpus; c < cpus + ncpu; c++) {
801039e9:	69 05 e0 54 11 80 b0 	imul   $0xb0,0x801154e0,%eax
801039f0:	00 00 00 
801039f3:	83 c4 10             	add    $0x10,%esp
801039f6:	05 60 4f 11 80       	add    $0x80114f60,%eax
801039fb:	3d 60 4f 11 80       	cmp    $0x80114f60,%eax
80103a00:	76 71                	jbe    80103a73 <main+0x103>
80103a02:	bb 60 4f 11 80       	mov    $0x80114f60,%ebx
80103a07:	89 f6                	mov    %esi,%esi
80103a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if (c == mycpu()) { // We've started already.
80103a10:	e8 2b 08 00 00       	call   80104240 <mycpu>
80103a15:	39 d8                	cmp    %ebx,%eax
80103a17:	74 41                	je     80103a5a <main+0xea>
        }

        // Tell entryother.S what stack to use, where to enter, and what
        // pgdir to use. We cannot use kpgdir yet, because the AP processor
        // is running in low  memory, so we use entrypgdir for the APs too.
        stack = kalloc();
80103a19:	e8 72 f5 ff ff       	call   80102f90 <kalloc>
        *(void**)(code - 4) = stack + KSTACKSIZE;
80103a1e:	05 00 10 00 00       	add    $0x1000,%eax
        *(void(**)(void))(code - 8) = mpenter;
80103a23:	c7 05 f8 6f 00 80 50 	movl   $0x80103950,0x80006ff8
80103a2a:	39 10 80 
        *(int**)(code - 12) = (void *) V2P(entrypgdir);
80103a2d:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80103a34:	b0 10 00 
        *(void**)(code - 4) = stack + KSTACKSIZE;
80103a37:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

        lapicstartap(c->apicid, V2P(code));
80103a3c:	0f b6 03             	movzbl (%ebx),%eax
80103a3f:	83 ec 08             	sub    $0x8,%esp
80103a42:	68 00 70 00 00       	push   $0x7000
80103a47:	50                   	push   %eax
80103a48:	e8 03 f8 ff ff       	call   80103250 <lapicstartap>
80103a4d:	83 c4 10             	add    $0x10,%esp

        // wait for cpu to finish mpmain()
        while (c->started == 0) {
80103a50:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103a56:	85 c0                	test   %eax,%eax
80103a58:	74 f6                	je     80103a50 <main+0xe0>
    for (c = cpus; c < cpus + ncpu; c++) {
80103a5a:	69 05 e0 54 11 80 b0 	imul   $0xb0,0x801154e0,%eax
80103a61:	00 00 00 
80103a64:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103a6a:	05 60 4f 11 80       	add    $0x80114f60,%eax
80103a6f:	39 c3                	cmp    %eax,%ebx
80103a71:	72 9d                	jb     80103a10 <main+0xa0>
    kinit2(P2V(4 * 1024 * 1024), P2V(PHYSTOP)); // must come after startothers()
80103a73:	83 ec 08             	sub    $0x8,%esp
80103a76:	68 00 00 00 8e       	push   $0x8e000000
80103a7b:	68 00 00 40 80       	push   $0x80400000
80103a80:	e8 ab f4 ff ff       	call   80102f30 <kinit2>
    userinit();      // first user process
80103a85:	e8 86 08 00 00       	call   80104310 <userinit>
    mpmain();        // finish this processor's setup
80103a8a:	e8 81 fe ff ff       	call   80103910 <mpmain>
80103a8f:	90                   	nop

80103a90 <mpsearch1>:
    }
    return sum;
}

// Look for an MP structure in the len bytes at addr.
static struct mp*mpsearch1(uint a, int len) {
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	57                   	push   %edi
80103a94:	56                   	push   %esi
    uchar *e, *p, *addr;

    addr = P2V(a);
80103a95:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
static struct mp*mpsearch1(uint a, int len) {
80103a9b:	53                   	push   %ebx
    e = addr + len;
80103a9c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
static struct mp*mpsearch1(uint a, int len) {
80103a9f:	83 ec 0c             	sub    $0xc,%esp
    for (p = addr; p < e; p += sizeof(struct mp)) {
80103aa2:	39 de                	cmp    %ebx,%esi
80103aa4:	72 10                	jb     80103ab6 <mpsearch1+0x26>
80103aa6:	eb 50                	jmp    80103af8 <mpsearch1+0x68>
80103aa8:	90                   	nop
80103aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ab0:	39 fb                	cmp    %edi,%ebx
80103ab2:	89 fe                	mov    %edi,%esi
80103ab4:	76 42                	jbe    80103af8 <mpsearch1+0x68>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0) {
80103ab6:	83 ec 04             	sub    $0x4,%esp
80103ab9:	8d 7e 10             	lea    0x10(%esi),%edi
80103abc:	6a 04                	push   $0x4
80103abe:	68 58 80 10 80       	push   $0x80108058
80103ac3:	56                   	push   %esi
80103ac4:	e8 d7 14 00 00       	call   80104fa0 <memcmp>
80103ac9:	83 c4 10             	add    $0x10,%esp
80103acc:	85 c0                	test   %eax,%eax
80103ace:	75 e0                	jne    80103ab0 <mpsearch1+0x20>
80103ad0:	89 f1                	mov    %esi,%ecx
80103ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        sum += addr[i];
80103ad8:	0f b6 11             	movzbl (%ecx),%edx
80103adb:	83 c1 01             	add    $0x1,%ecx
80103ade:	01 d0                	add    %edx,%eax
    for (i = 0; i < len; i++) {
80103ae0:	39 f9                	cmp    %edi,%ecx
80103ae2:	75 f4                	jne    80103ad8 <mpsearch1+0x48>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0) {
80103ae4:	84 c0                	test   %al,%al
80103ae6:	75 c8                	jne    80103ab0 <mpsearch1+0x20>
            return (struct mp*)p;
        }
    }
    return 0;
}
80103ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103aeb:	89 f0                	mov    %esi,%eax
80103aed:	5b                   	pop    %ebx
80103aee:	5e                   	pop    %esi
80103aef:	5f                   	pop    %edi
80103af0:	5d                   	pop    %ebp
80103af1:	c3                   	ret    
80103af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103af8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80103afb:	31 f6                	xor    %esi,%esi
}
80103afd:	89 f0                	mov    %esi,%eax
80103aff:	5b                   	pop    %ebx
80103b00:	5e                   	pop    %esi
80103b01:	5f                   	pop    %edi
80103b02:	5d                   	pop    %ebp
80103b03:	c3                   	ret    
80103b04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103b10 <mpinit>:
    }
    *pmp = mp;
    return conf;
}

void mpinit(void) {
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	57                   	push   %edi
80103b14:	56                   	push   %esi
80103b15:	53                   	push   %ebx
80103b16:	83 ec 1c             	sub    $0x1c,%esp
    if ((p = ((bda[0x0F] << 8) | bda[0x0E]) << 4)) {
80103b19:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103b20:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103b27:	c1 e0 08             	shl    $0x8,%eax
80103b2a:	09 d0                	or     %edx,%eax
80103b2c:	c1 e0 04             	shl    $0x4,%eax
80103b2f:	85 c0                	test   %eax,%eax
80103b31:	75 1b                	jne    80103b4e <mpinit+0x3e>
        p = ((bda[0x14] << 8) | bda[0x13]) * 1024;
80103b33:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103b3a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103b41:	c1 e0 08             	shl    $0x8,%eax
80103b44:	09 d0                	or     %edx,%eax
80103b46:	c1 e0 0a             	shl    $0xa,%eax
        if ((mp = mpsearch1(p - 1024, 1024))) {
80103b49:	2d 00 04 00 00       	sub    $0x400,%eax
        if ((mp = mpsearch1(p, 1024))) {
80103b4e:	ba 00 04 00 00       	mov    $0x400,%edx
80103b53:	e8 38 ff ff ff       	call   80103a90 <mpsearch1>
80103b58:	85 c0                	test   %eax,%eax
80103b5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b5d:	0f 84 3d 01 00 00    	je     80103ca0 <mpinit+0x190>
    if ((mp = mpsearch()) == 0 || mp->physaddr == 0) {
80103b63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103b66:	8b 58 04             	mov    0x4(%eax),%ebx
80103b69:	85 db                	test   %ebx,%ebx
80103b6b:	0f 84 4f 01 00 00    	je     80103cc0 <mpinit+0x1b0>
    conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103b71:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
    if (memcmp(conf, "PCMP", 4) != 0) {
80103b77:	83 ec 04             	sub    $0x4,%esp
80103b7a:	6a 04                	push   $0x4
80103b7c:	68 75 80 10 80       	push   $0x80108075
80103b81:	56                   	push   %esi
80103b82:	e8 19 14 00 00       	call   80104fa0 <memcmp>
80103b87:	83 c4 10             	add    $0x10,%esp
80103b8a:	85 c0                	test   %eax,%eax
80103b8c:	0f 85 2e 01 00 00    	jne    80103cc0 <mpinit+0x1b0>
    if (conf->version != 1 && conf->version != 4) {
80103b92:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103b99:	3c 01                	cmp    $0x1,%al
80103b9b:	0f 95 c2             	setne  %dl
80103b9e:	3c 04                	cmp    $0x4,%al
80103ba0:	0f 95 c0             	setne  %al
80103ba3:	20 c2                	and    %al,%dl
80103ba5:	0f 85 15 01 00 00    	jne    80103cc0 <mpinit+0x1b0>
    if (sum((uchar*)conf, conf->length) != 0) {
80103bab:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
    for (i = 0; i < len; i++) {
80103bb2:	66 85 ff             	test   %di,%di
80103bb5:	74 1a                	je     80103bd1 <mpinit+0xc1>
80103bb7:	89 f0                	mov    %esi,%eax
80103bb9:	01 f7                	add    %esi,%edi
    sum = 0;
80103bbb:	31 d2                	xor    %edx,%edx
80103bbd:	8d 76 00             	lea    0x0(%esi),%esi
        sum += addr[i];
80103bc0:	0f b6 08             	movzbl (%eax),%ecx
80103bc3:	83 c0 01             	add    $0x1,%eax
80103bc6:	01 ca                	add    %ecx,%edx
    for (i = 0; i < len; i++) {
80103bc8:	39 c7                	cmp    %eax,%edi
80103bca:	75 f4                	jne    80103bc0 <mpinit+0xb0>
80103bcc:	84 d2                	test   %dl,%dl
80103bce:	0f 95 c2             	setne  %dl
    struct mp *mp;
    struct mpconf *conf;
    struct mpproc *proc;
    struct mpioapic *ioapic;

    if ((conf = mpconfig(&mp)) == 0) {
80103bd1:	85 f6                	test   %esi,%esi
80103bd3:	0f 84 e7 00 00 00    	je     80103cc0 <mpinit+0x1b0>
80103bd9:	84 d2                	test   %dl,%dl
80103bdb:	0f 85 df 00 00 00    	jne    80103cc0 <mpinit+0x1b0>
        panic("Expect to run on an SMP");
    }
    ismp = 1;
    lapic = (uint*)conf->lapicaddr;
80103be1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103be7:	a3 5c 4e 11 80       	mov    %eax,0x80114e5c
    for (p = (uchar*)(conf + 1), e = (uchar*)conf + conf->length; p < e;) {
80103bec:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103bf3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
    ismp = 1;
80103bf9:	bb 01 00 00 00       	mov    $0x1,%ebx
    for (p = (uchar*)(conf + 1), e = (uchar*)conf + conf->length; p < e;) {
80103bfe:	01 d6                	add    %edx,%esi
80103c00:	39 c6                	cmp    %eax,%esi
80103c02:	76 23                	jbe    80103c27 <mpinit+0x117>
        switch (*p) {
80103c04:	0f b6 10             	movzbl (%eax),%edx
80103c07:	80 fa 04             	cmp    $0x4,%dl
80103c0a:	0f 87 ca 00 00 00    	ja     80103cda <mpinit+0x1ca>
80103c10:	ff 24 95 9c 80 10 80 	jmp    *-0x7fef7f64(,%edx,4)
80103c17:	89 f6                	mov    %esi,%esi
80103c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                p += sizeof(struct mpioapic);
                continue;
            case MPBUS:
            case MPIOINTR:
            case MPLINTR:
                p += 8;
80103c20:	83 c0 08             	add    $0x8,%eax
    for (p = (uchar*)(conf + 1), e = (uchar*)conf + conf->length; p < e;) {
80103c23:	39 c6                	cmp    %eax,%esi
80103c25:	77 dd                	ja     80103c04 <mpinit+0xf4>
            default:
                ismp = 0;
                break;
        }
    }
    if (!ismp) {
80103c27:	85 db                	test   %ebx,%ebx
80103c29:	0f 84 9e 00 00 00    	je     80103ccd <mpinit+0x1bd>
        panic("Didn't find a suitable machine");
    }

    if (mp->imcrp) {
80103c2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c32:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103c36:	74 15                	je     80103c4d <mpinit+0x13d>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80103c38:	b8 70 00 00 00       	mov    $0x70,%eax
80103c3d:	ba 22 00 00 00       	mov    $0x22,%edx
80103c42:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80103c43:	ba 23 00 00 00       	mov    $0x23,%edx
80103c48:	ec                   	in     (%dx),%al
        // Bochs doesn't support IMCR, so this doesn't run on Bochs.
        // But it would on real hardware.
        outb(0x22, 0x70);   // Select IMCR
        outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103c49:	83 c8 01             	or     $0x1,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80103c4c:	ee                   	out    %al,(%dx)
    }
}
80103c4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c50:	5b                   	pop    %ebx
80103c51:	5e                   	pop    %esi
80103c52:	5f                   	pop    %edi
80103c53:	5d                   	pop    %ebp
80103c54:	c3                   	ret    
80103c55:	8d 76 00             	lea    0x0(%esi),%esi
                if (ncpu < NCPU) {
80103c58:	8b 0d e0 54 11 80    	mov    0x801154e0,%ecx
80103c5e:	83 f9 07             	cmp    $0x7,%ecx
80103c61:	7f 19                	jg     80103c7c <mpinit+0x16c>
                    cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103c63:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103c67:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
                    ncpu++;
80103c6d:	83 c1 01             	add    $0x1,%ecx
80103c70:	89 0d e0 54 11 80    	mov    %ecx,0x801154e0
                    cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103c76:	88 97 60 4f 11 80    	mov    %dl,-0x7feeb0a0(%edi)
                p += sizeof(struct mpproc);
80103c7c:	83 c0 14             	add    $0x14,%eax
                continue;
80103c7f:	e9 7c ff ff ff       	jmp    80103c00 <mpinit+0xf0>
80103c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                ioapicid = ioapic->apicno;
80103c88:	0f b6 50 01          	movzbl 0x1(%eax),%edx
                p += sizeof(struct mpioapic);
80103c8c:	83 c0 08             	add    $0x8,%eax
                ioapicid = ioapic->apicno;
80103c8f:	88 15 40 4f 11 80    	mov    %dl,0x80114f40
                continue;
80103c95:	e9 66 ff ff ff       	jmp    80103c00 <mpinit+0xf0>
80103c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return mpsearch1(0xF0000, 0x10000);
80103ca0:	ba 00 00 01 00       	mov    $0x10000,%edx
80103ca5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103caa:	e8 e1 fd ff ff       	call   80103a90 <mpsearch1>
    if ((mp = mpsearch()) == 0 || mp->physaddr == 0) {
80103caf:	85 c0                	test   %eax,%eax
    return mpsearch1(0xF0000, 0x10000);
80103cb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if ((mp = mpsearch()) == 0 || mp->physaddr == 0) {
80103cb4:	0f 85 a9 fe ff ff    	jne    80103b63 <mpinit+0x53>
80103cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        panic("Expect to run on an SMP");
80103cc0:	83 ec 0c             	sub    $0xc,%esp
80103cc3:	68 5d 80 10 80       	push   $0x8010805d
80103cc8:	e8 13 c8 ff ff       	call   801004e0 <panic>
        panic("Didn't find a suitable machine");
80103ccd:	83 ec 0c             	sub    $0xc,%esp
80103cd0:	68 7c 80 10 80       	push   $0x8010807c
80103cd5:	e8 06 c8 ff ff       	call   801004e0 <panic>
                ismp = 0;
80103cda:	31 db                	xor    %ebx,%ebx
80103cdc:	e9 26 ff ff ff       	jmp    80103c07 <mpinit+0xf7>
80103ce1:	66 90                	xchg   %ax,%ax
80103ce3:	66 90                	xchg   %ax,%ax
80103ce5:	66 90                	xchg   %ax,%ax
80103ce7:	66 90                	xchg   %ax,%ax
80103ce9:	66 90                	xchg   %ax,%ax
80103ceb:	66 90                	xchg   %ax,%ax
80103ced:	66 90                	xchg   %ax,%ax
80103cef:	90                   	nop

80103cf0 <picinit>:
// I/O Addresses of the two programmable interrupt controllers
#define IO_PIC1         0x20    // Master (IRQs 0-7)
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void picinit(void) {
80103cf0:	55                   	push   %ebp
80103cf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cf6:	ba 21 00 00 00       	mov    $0x21,%edx
80103cfb:	89 e5                	mov    %esp,%ebp
80103cfd:	ee                   	out    %al,(%dx)
80103cfe:	ba a1 00 00 00       	mov    $0xa1,%edx
80103d03:	ee                   	out    %al,(%dx)
    // mask all interrupts
    outb(IO_PIC1 + 1, 0xFF);
    outb(IO_PIC2 + 1, 0xFF);
}
80103d04:	5d                   	pop    %ebp
80103d05:	c3                   	ret    
80103d06:	66 90                	xchg   %ax,%ax
80103d08:	66 90                	xchg   %ax,%ax
80103d0a:	66 90                	xchg   %ax,%ax
80103d0c:	66 90                	xchg   %ax,%ax
80103d0e:	66 90                	xchg   %ax,%ax

80103d10 <cleanuppipealloc>:
    uint nwrite;    // number of bytes written
    int readopen;   // read fd is still open
    int writeopen;  // write fd is still open
};

void cleanuppipealloc(struct pipe *p, struct file **f0, struct file **f1) {
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	56                   	push   %esi
80103d14:	53                   	push   %ebx
80103d15:	8b 45 08             	mov    0x8(%ebp),%eax
80103d18:	8b 75 0c             	mov    0xc(%ebp),%esi
80103d1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
     if (p) {
80103d1e:	85 c0                	test   %eax,%eax
80103d20:	74 0c                	je     80103d2e <cleanuppipealloc+0x1e>
        kfree((char*)p);
80103d22:	83 ec 0c             	sub    $0xc,%esp
80103d25:	50                   	push   %eax
80103d26:	e8 b5 f0 ff ff       	call   80102de0 <kfree>
80103d2b:	83 c4 10             	add    $0x10,%esp
    }
    if (*f0) {
80103d2e:	8b 06                	mov    (%esi),%eax
80103d30:	85 c0                	test   %eax,%eax
80103d32:	74 0c                	je     80103d40 <cleanuppipealloc+0x30>
        fileclose(*f0);
80103d34:	83 ec 0c             	sub    $0xc,%esp
80103d37:	50                   	push   %eax
80103d38:	e8 d3 db ff ff       	call   80101910 <fileclose>
80103d3d:	83 c4 10             	add    $0x10,%esp
    }
    if (*f1) {
80103d40:	8b 03                	mov    (%ebx),%eax
80103d42:	85 c0                	test   %eax,%eax
80103d44:	74 12                	je     80103d58 <cleanuppipealloc+0x48>
        fileclose(*f1);
80103d46:	89 45 08             	mov    %eax,0x8(%ebp)
    }   
}
80103d49:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d4c:	5b                   	pop    %ebx
80103d4d:	5e                   	pop    %esi
80103d4e:	5d                   	pop    %ebp
        fileclose(*f1);
80103d4f:	e9 bc db ff ff       	jmp    80101910 <fileclose>
80103d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80103d58:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d5b:	5b                   	pop    %ebx
80103d5c:	5e                   	pop    %esi
80103d5d:	5d                   	pop    %ebp
80103d5e:	c3                   	ret    
80103d5f:	90                   	nop

80103d60 <pipealloc>:

int pipealloc(struct file **f0, struct file **f1) {
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	57                   	push   %edi
80103d64:	56                   	push   %esi
80103d65:	53                   	push   %ebx
80103d66:	83 ec 0c             	sub    $0xc,%esp
80103d69:	8b 75 08             	mov    0x8(%ebp),%esi
80103d6c:	8b 7d 0c             	mov    0xc(%ebp),%edi
    struct pipe *p;

    p = 0;
    *f0 = *f1 = 0;
80103d6f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103d75:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) {
80103d7b:	e8 d0 da ff ff       	call   80101850 <filealloc>
80103d80:	85 c0                	test   %eax,%eax
80103d82:	89 06                	mov    %eax,(%esi)
80103d84:	0f 84 96 00 00 00    	je     80103e20 <pipealloc+0xc0>
80103d8a:	e8 c1 da ff ff       	call   80101850 <filealloc>
80103d8f:	85 c0                	test   %eax,%eax
80103d91:	89 07                	mov    %eax,(%edi)
80103d93:	0f 84 87 00 00 00    	je     80103e20 <pipealloc+0xc0>
        cleanuppipealloc(p, f0, f1);
        return -1;
    }
    if ((p = (struct pipe*)kalloc()) == 0) {
80103d99:	e8 f2 f1 ff ff       	call   80102f90 <kalloc>
80103d9e:	85 c0                	test   %eax,%eax
80103da0:	89 c3                	mov    %eax,%ebx
80103da2:	74 7c                	je     80103e20 <pipealloc+0xc0>
    }
    p->readopen = 1;
    p->writeopen = 1;
    p->nwrite = 0;
    p->nread = 0;
    initlock(&p->lock, "pipe");
80103da4:	83 ec 08             	sub    $0x8,%esp
    p->readopen = 1;
80103da7:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103dae:	00 00 00 
    p->writeopen = 1;
80103db1:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103db8:	00 00 00 
    p->nwrite = 0;
80103dbb:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103dc2:	00 00 00 
    p->nread = 0;
80103dc5:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103dcc:	00 00 00 
    initlock(&p->lock, "pipe");
80103dcf:	68 b0 80 10 80       	push   $0x801080b0
80103dd4:	50                   	push   %eax
80103dd5:	e8 26 0f 00 00       	call   80104d00 <initlock>
    (*f0)->type = FD_PIPE;
80103dda:	8b 06                	mov    (%esi),%eax
    (*f0)->pipe = p;
    (*f1)->type = FD_PIPE;
    (*f1)->readable = 0;
    (*f1)->writable = 1;
    (*f1)->pipe = p;
    return 0;
80103ddc:	83 c4 10             	add    $0x10,%esp
    (*f0)->type = FD_PIPE;
80103ddf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    (*f0)->readable = 1;
80103de5:	8b 06                	mov    (%esi),%eax
80103de7:	c6 40 08 01          	movb   $0x1,0x8(%eax)
    (*f0)->writable = 0;
80103deb:	8b 06                	mov    (%esi),%eax
80103ded:	c6 40 09 00          	movb   $0x0,0x9(%eax)
    (*f0)->pipe = p;
80103df1:	8b 06                	mov    (%esi),%eax
80103df3:	89 58 0c             	mov    %ebx,0xc(%eax)
    (*f1)->type = FD_PIPE;
80103df6:	8b 07                	mov    (%edi),%eax
80103df8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    (*f1)->readable = 0;
80103dfe:	8b 07                	mov    (%edi),%eax
80103e00:	c6 40 08 00          	movb   $0x0,0x8(%eax)
    (*f1)->writable = 1;
80103e04:	8b 07                	mov    (%edi),%eax
80103e06:	c6 40 09 01          	movb   $0x1,0x9(%eax)
    (*f1)->pipe = p;
80103e0a:	8b 07                	mov    (%edi),%eax
80103e0c:	89 58 0c             	mov    %ebx,0xc(%eax)
    return 0;
80103e0f:	31 c0                	xor    %eax,%eax
}
80103e11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e14:	5b                   	pop    %ebx
80103e15:	5e                   	pop    %esi
80103e16:	5f                   	pop    %edi
80103e17:	5d                   	pop    %ebp
80103e18:	c3                   	ret    
80103e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cleanuppipealloc(p, f0, f1);
80103e20:	83 ec 04             	sub    $0x4,%esp
80103e23:	57                   	push   %edi
80103e24:	56                   	push   %esi
80103e25:	6a 00                	push   $0x0
80103e27:	e8 e4 fe ff ff       	call   80103d10 <cleanuppipealloc>
        return -1;
80103e2c:	83 c4 10             	add    $0x10,%esp
80103e2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e34:	eb db                	jmp    80103e11 <pipealloc+0xb1>
80103e36:	8d 76 00             	lea    0x0(%esi),%esi
80103e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e40 <pipeclose>:

void pipeclose(struct pipe *p, int writable) {
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	56                   	push   %esi
80103e44:	53                   	push   %ebx
80103e45:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103e48:	8b 75 0c             	mov    0xc(%ebp),%esi
    acquire(&p->lock);
80103e4b:	83 ec 0c             	sub    $0xc,%esp
80103e4e:	53                   	push   %ebx
80103e4f:	e8 ec 0f 00 00       	call   80104e40 <acquire>
    if (writable) {
80103e54:	83 c4 10             	add    $0x10,%esp
80103e57:	85 f6                	test   %esi,%esi
80103e59:	74 45                	je     80103ea0 <pipeclose+0x60>
        p->writeopen = 0;
        wakeup(&p->nread);
80103e5b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103e61:	83 ec 0c             	sub    $0xc,%esp
        p->writeopen = 0;
80103e64:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103e6b:	00 00 00 
        wakeup(&p->nread);
80103e6e:	50                   	push   %eax
80103e6f:	e8 bc 0b 00 00       	call   80104a30 <wakeup>
80103e74:	83 c4 10             	add    $0x10,%esp
    }
    else {
        p->readopen = 0;
        wakeup(&p->nwrite);
    }
    if (p->readopen == 0 && p->writeopen == 0) {
80103e77:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103e7d:	85 d2                	test   %edx,%edx
80103e7f:	75 0a                	jne    80103e8b <pipeclose+0x4b>
80103e81:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103e87:	85 c0                	test   %eax,%eax
80103e89:	74 35                	je     80103ec0 <pipeclose+0x80>
        release(&p->lock);
        kfree((char*)p);
    }
    else {
        release(&p->lock);
80103e8b:	89 5d 08             	mov    %ebx,0x8(%ebp)
    }
}
80103e8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e91:	5b                   	pop    %ebx
80103e92:	5e                   	pop    %esi
80103e93:	5d                   	pop    %ebp
        release(&p->lock);
80103e94:	e9 67 10 00 00       	jmp    80104f00 <release>
80103e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        wakeup(&p->nwrite);
80103ea0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103ea6:	83 ec 0c             	sub    $0xc,%esp
        p->readopen = 0;
80103ea9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103eb0:	00 00 00 
        wakeup(&p->nwrite);
80103eb3:	50                   	push   %eax
80103eb4:	e8 77 0b 00 00       	call   80104a30 <wakeup>
80103eb9:	83 c4 10             	add    $0x10,%esp
80103ebc:	eb b9                	jmp    80103e77 <pipeclose+0x37>
80103ebe:	66 90                	xchg   %ax,%ax
        release(&p->lock);
80103ec0:	83 ec 0c             	sub    $0xc,%esp
80103ec3:	53                   	push   %ebx
80103ec4:	e8 37 10 00 00       	call   80104f00 <release>
        kfree((char*)p);
80103ec9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103ecc:	83 c4 10             	add    $0x10,%esp
}
80103ecf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ed2:	5b                   	pop    %ebx
80103ed3:	5e                   	pop    %esi
80103ed4:	5d                   	pop    %ebp
        kfree((char*)p);
80103ed5:	e9 06 ef ff ff       	jmp    80102de0 <kfree>
80103eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ee0 <pipewrite>:

int pipewrite(struct pipe *p, char *addr, int n) {
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	57                   	push   %edi
80103ee4:	56                   	push   %esi
80103ee5:	53                   	push   %ebx
80103ee6:	83 ec 28             	sub    $0x28,%esp
80103ee9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int i;

    acquire(&p->lock);
80103eec:	53                   	push   %ebx
80103eed:	e8 4e 0f 00 00       	call   80104e40 <acquire>
    for (i = 0; i < n; i++) {
80103ef2:	8b 45 10             	mov    0x10(%ebp),%eax
80103ef5:	83 c4 10             	add    $0x10,%esp
80103ef8:	85 c0                	test   %eax,%eax
80103efa:	0f 8e c9 00 00 00    	jle    80103fc9 <pipewrite+0xe9>
80103f00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103f03:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
        while (p->nwrite == p->nread + PIPESIZE) { //DOC: pipewrite-full
            if (p->readopen == 0 || myproc()->killed) {
                release(&p->lock);
                return -1;
            }
            wakeup(&p->nread);
80103f09:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103f0f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103f12:	03 4d 10             	add    0x10(%ebp),%ecx
80103f15:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        while (p->nwrite == p->nread + PIPESIZE) { //DOC: pipewrite-full
80103f18:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103f1e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103f24:	39 d0                	cmp    %edx,%eax
80103f26:	75 71                	jne    80103f99 <pipewrite+0xb9>
            if (p->readopen == 0 || myproc()->killed) {
80103f28:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103f2e:	85 c0                	test   %eax,%eax
80103f30:	74 4e                	je     80103f80 <pipewrite+0xa0>
            sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103f32:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103f38:	eb 3a                	jmp    80103f74 <pipewrite+0x94>
80103f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            wakeup(&p->nread);
80103f40:	83 ec 0c             	sub    $0xc,%esp
80103f43:	57                   	push   %edi
80103f44:	e8 e7 0a 00 00       	call   80104a30 <wakeup>
            sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103f49:	5a                   	pop    %edx
80103f4a:	59                   	pop    %ecx
80103f4b:	53                   	push   %ebx
80103f4c:	56                   	push   %esi
80103f4d:	e8 2e 09 00 00       	call   80104880 <sleep>
        while (p->nwrite == p->nread + PIPESIZE) { //DOC: pipewrite-full
80103f52:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103f58:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103f5e:	83 c4 10             	add    $0x10,%esp
80103f61:	05 00 02 00 00       	add    $0x200,%eax
80103f66:	39 c2                	cmp    %eax,%edx
80103f68:	75 36                	jne    80103fa0 <pipewrite+0xc0>
            if (p->readopen == 0 || myproc()->killed) {
80103f6a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103f70:	85 c0                	test   %eax,%eax
80103f72:	74 0c                	je     80103f80 <pipewrite+0xa0>
80103f74:	e8 67 03 00 00       	call   801042e0 <myproc>
80103f79:	8b 40 24             	mov    0x24(%eax),%eax
80103f7c:	85 c0                	test   %eax,%eax
80103f7e:	74 c0                	je     80103f40 <pipewrite+0x60>
                release(&p->lock);
80103f80:	83 ec 0c             	sub    $0xc,%esp
80103f83:	53                   	push   %ebx
80103f84:	e8 77 0f 00 00       	call   80104f00 <release>
                return -1;
80103f89:	83 c4 10             	add    $0x10,%esp
80103f8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        p->data[p->nwrite++ % PIPESIZE] = addr[i];
    }
    wakeup(&p->nread);  //DOC: pipewrite-wakeup1
    release(&p->lock);
    return n;
}
80103f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f94:	5b                   	pop    %ebx
80103f95:	5e                   	pop    %esi
80103f96:	5f                   	pop    %edi
80103f97:	5d                   	pop    %ebp
80103f98:	c3                   	ret    
        while (p->nwrite == p->nread + PIPESIZE) { //DOC: pipewrite-full
80103f99:	89 c2                	mov    %eax,%edx
80103f9b:	90                   	nop
80103f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103fa0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103fa3:	8d 42 01             	lea    0x1(%edx),%eax
80103fa6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103fac:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103fb2:	83 c6 01             	add    $0x1,%esi
80103fb5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
    for (i = 0; i < n; i++) {
80103fb9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103fbc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
        p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103fbf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
    for (i = 0; i < n; i++) {
80103fc3:	0f 85 4f ff ff ff    	jne    80103f18 <pipewrite+0x38>
    wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103fc9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103fcf:	83 ec 0c             	sub    $0xc,%esp
80103fd2:	50                   	push   %eax
80103fd3:	e8 58 0a 00 00       	call   80104a30 <wakeup>
    release(&p->lock);
80103fd8:	89 1c 24             	mov    %ebx,(%esp)
80103fdb:	e8 20 0f 00 00       	call   80104f00 <release>
    return n;
80103fe0:	83 c4 10             	add    $0x10,%esp
80103fe3:	8b 45 10             	mov    0x10(%ebp),%eax
80103fe6:	eb a9                	jmp    80103f91 <pipewrite+0xb1>
80103fe8:	90                   	nop
80103fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ff0 <piperead>:

int piperead(struct pipe *p, char *addr, int n)     {
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	57                   	push   %edi
80103ff4:	56                   	push   %esi
80103ff5:	53                   	push   %ebx
80103ff6:	83 ec 18             	sub    $0x18,%esp
80103ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80103ffc:	8b 7d 0c             	mov    0xc(%ebp),%edi
    int i;

    acquire(&p->lock);
80103fff:	56                   	push   %esi
80104000:	e8 3b 0e 00 00       	call   80104e40 <acquire>
    while (p->nread == p->nwrite && p->writeopen) { //DOC: pipe-empty
80104005:	83 c4 10             	add    $0x10,%esp
80104008:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010400e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80104014:	75 6a                	jne    80104080 <piperead+0x90>
80104016:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010401c:	85 db                	test   %ebx,%ebx
8010401e:	0f 84 c4 00 00 00    	je     801040e8 <piperead+0xf8>
        if (myproc()->killed) {
            release(&p->lock);
            return -1;
        }
        sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104024:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010402a:	eb 2d                	jmp    80104059 <piperead+0x69>
8010402c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104030:	83 ec 08             	sub    $0x8,%esp
80104033:	56                   	push   %esi
80104034:	53                   	push   %ebx
80104035:	e8 46 08 00 00       	call   80104880 <sleep>
    while (p->nread == p->nwrite && p->writeopen) { //DOC: pipe-empty
8010403a:	83 c4 10             	add    $0x10,%esp
8010403d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80104043:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80104049:	75 35                	jne    80104080 <piperead+0x90>
8010404b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80104051:	85 d2                	test   %edx,%edx
80104053:	0f 84 8f 00 00 00    	je     801040e8 <piperead+0xf8>
        if (myproc()->killed) {
80104059:	e8 82 02 00 00       	call   801042e0 <myproc>
8010405e:	8b 48 24             	mov    0x24(%eax),%ecx
80104061:	85 c9                	test   %ecx,%ecx
80104063:	74 cb                	je     80104030 <piperead+0x40>
            release(&p->lock);
80104065:	83 ec 0c             	sub    $0xc,%esp
            return -1;
80104068:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
            release(&p->lock);
8010406d:	56                   	push   %esi
8010406e:	e8 8d 0e 00 00       	call   80104f00 <release>
            return -1;
80104073:	83 c4 10             	add    $0x10,%esp
        addr[i] = p->data[p->nread++ % PIPESIZE];
    }
    wakeup(&p->nwrite);  //DOC: piperead-wakeup
    release(&p->lock);
    return i;
}
80104076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104079:	89 d8                	mov    %ebx,%eax
8010407b:	5b                   	pop    %ebx
8010407c:	5e                   	pop    %esi
8010407d:	5f                   	pop    %edi
8010407e:	5d                   	pop    %ebp
8010407f:	c3                   	ret    
    for (i = 0; i < n; i++) {  //DOC: piperead-copy
80104080:	8b 45 10             	mov    0x10(%ebp),%eax
80104083:	85 c0                	test   %eax,%eax
80104085:	7e 61                	jle    801040e8 <piperead+0xf8>
        if (p->nread == p->nwrite) {
80104087:	31 db                	xor    %ebx,%ebx
80104089:	eb 13                	jmp    8010409e <piperead+0xae>
8010408b:	90                   	nop
8010408c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104090:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80104096:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010409c:	74 1f                	je     801040bd <piperead+0xcd>
        addr[i] = p->data[p->nread++ % PIPESIZE];
8010409e:	8d 41 01             	lea    0x1(%ecx),%eax
801040a1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801040a7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801040ad:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801040b2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    for (i = 0; i < n; i++) {  //DOC: piperead-copy
801040b5:	83 c3 01             	add    $0x1,%ebx
801040b8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801040bb:	75 d3                	jne    80104090 <piperead+0xa0>
    wakeup(&p->nwrite);  //DOC: piperead-wakeup
801040bd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801040c3:	83 ec 0c             	sub    $0xc,%esp
801040c6:	50                   	push   %eax
801040c7:	e8 64 09 00 00       	call   80104a30 <wakeup>
    release(&p->lock);
801040cc:	89 34 24             	mov    %esi,(%esp)
801040cf:	e8 2c 0e 00 00       	call   80104f00 <release>
    return i;
801040d4:	83 c4 10             	add    $0x10,%esp
}
801040d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040da:	89 d8                	mov    %ebx,%eax
801040dc:	5b                   	pop    %ebx
801040dd:	5e                   	pop    %esi
801040de:	5f                   	pop    %edi
801040df:	5d                   	pop    %ebp
801040e0:	c3                   	ret    
801040e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040e8:	31 db                	xor    %ebx,%ebx
801040ea:	eb d1                	jmp    801040bd <piperead+0xcd>
801040ec:	66 90                	xchg   %ax,%ax
801040ee:	66 90                	xchg   %ax,%ax

801040f0 <allocproc>:

// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc* allocproc(void) {
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	53                   	push   %ebx
801040f4:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;
    char *sp;
    int found = 0;

    acquire(&ptable.lock);
801040f7:	68 00 55 11 80       	push   $0x80115500
801040fc:	e8 3f 0d 00 00       	call   80104e40 <acquire>

    p = ptable.proc;
    while (p < &ptable.proc[NPROC] && !found) {
        if (p->state == UNUSED) {
80104101:	8b 15 40 55 11 80    	mov    0x80115540,%edx
80104107:	83 c4 10             	add    $0x10,%esp
8010410a:	85 d2                	test   %edx,%edx
8010410c:	74 3a                	je     80104148 <allocproc+0x58>
            found = 1;
        }
        else {
            p++;
8010410e:	bb b0 55 11 80       	mov    $0x801155b0,%ebx
80104113:	90                   	nop
80104114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->state == UNUSED) {
80104118:	8b 43 0c             	mov    0xc(%ebx),%eax
8010411b:	85 c0                	test   %eax,%eax
8010411d:	74 31                	je     80104150 <allocproc+0x60>
            p++;
8010411f:	83 c3 7c             	add    $0x7c,%ebx
    while (p < &ptable.proc[NPROC] && !found) {
80104122:	81 fb 34 74 11 80    	cmp    $0x80117434,%ebx
80104128:	72 ee                	jb     80104118 <allocproc+0x28>
        }
       
    }
    if (!found) {    
        release(&ptable.lock);
8010412a:	83 ec 0c             	sub    $0xc,%esp
        return 0;
8010412d:	31 db                	xor    %ebx,%ebx
        release(&ptable.lock);
8010412f:	68 00 55 11 80       	push   $0x80115500
80104134:	e8 c7 0d 00 00       	call   80104f00 <release>
        return 0;
80104139:	83 c4 10             	add    $0x10,%esp
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint)forkret;

    return p;
}
8010413c:	89 d8                	mov    %ebx,%eax
8010413e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104141:	c9                   	leave  
80104142:	c3                   	ret    
80104143:	90                   	nop
80104144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p = ptable.proc;
80104148:	bb 34 55 11 80       	mov    $0x80115534,%ebx
8010414d:	8d 76 00             	lea    0x0(%esi),%esi
    p->pid = nextpid++;
80104150:	a1 04 c0 10 80       	mov    0x8010c004,%eax
    release(&ptable.lock);
80104155:	83 ec 0c             	sub    $0xc,%esp
    p->state = EMBRYO;
80104158:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;
8010415f:	8d 50 01             	lea    0x1(%eax),%edx
80104162:	89 43 10             	mov    %eax,0x10(%ebx)
    release(&ptable.lock);
80104165:	68 00 55 11 80       	push   $0x80115500
    p->pid = nextpid++;
8010416a:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
    release(&ptable.lock);
80104170:	e8 8b 0d 00 00       	call   80104f00 <release>
    if ((p->kstack = kalloc()) == 0) {
80104175:	e8 16 ee ff ff       	call   80102f90 <kalloc>
8010417a:	83 c4 10             	add    $0x10,%esp
8010417d:	85 c0                	test   %eax,%eax
8010417f:	89 43 08             	mov    %eax,0x8(%ebx)
80104182:	74 3c                	je     801041c0 <allocproc+0xd0>
    sp -= sizeof *p->tf;
80104184:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    memset(p->context, 0, sizeof *p->context);
8010418a:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *p->context;
8010418d:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *p->tf;
80104192:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint*)sp = (uint)trapret;
80104195:	c7 40 14 87 62 10 80 	movl   $0x80106287,0x14(%eax)
    p->context = (struct context*)sp;
8010419c:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
8010419f:	6a 14                	push   $0x14
801041a1:	6a 00                	push   $0x0
801041a3:	50                   	push   %eax
801041a4:	e8 a7 0d 00 00       	call   80104f50 <memset>
    p->context->eip = (uint)forkret;
801041a9:	8b 43 1c             	mov    0x1c(%ebx),%eax
    return p;
801041ac:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint)forkret;
801041af:	c7 40 10 d0 41 10 80 	movl   $0x801041d0,0x10(%eax)
}
801041b6:	89 d8                	mov    %ebx,%eax
801041b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041bb:	c9                   	leave  
801041bc:	c3                   	ret    
801041bd:	8d 76 00             	lea    0x0(%esi),%esi
        p->state = UNUSED;
801041c0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
801041c7:	31 db                	xor    %ebx,%ebx
801041c9:	e9 6e ff ff ff       	jmp    8010413c <allocproc+0x4c>
801041ce:	66 90                	xchg   %ax,%ax

801041d0 <forkret>:
    release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void) {
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
801041d6:	68 00 55 11 80       	push   $0x80115500
801041db:	e8 20 0d 00 00       	call   80104f00 <release>

    if (first) {
801041e0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
801041e5:	83 c4 10             	add    $0x10,%esp
801041e8:	85 c0                	test   %eax,%eax
801041ea:	75 04                	jne    801041f0 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
801041ec:	c9                   	leave  
801041ed:	c3                   	ret    
801041ee:	66 90                	xchg   %ax,%ax
        iinit(ROOTDEV);
801041f0:	83 ec 0c             	sub    $0xc,%esp
        first = 0;
801041f3:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
801041fa:	00 00 00 
        iinit(ROOTDEV);
801041fd:	6a 01                	push   $0x1
801041ff:	e8 4c dd ff ff       	call   80101f50 <iinit>
        initlog(ROOTDEV);
80104204:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010420b:	e8 c0 f3 ff ff       	call   801035d0 <initlog>
80104210:	83 c4 10             	add    $0x10,%esp
}
80104213:	c9                   	leave  
80104214:	c3                   	ret    
80104215:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104220 <pinit>:
void pinit(void) {
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
80104226:	68 b5 80 10 80       	push   $0x801080b5
8010422b:	68 00 55 11 80       	push   $0x80115500
80104230:	e8 cb 0a 00 00       	call   80104d00 <initlock>
}
80104235:	83 c4 10             	add    $0x10,%esp
80104238:	c9                   	leave  
80104239:	c3                   	ret    
8010423a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104240 <mycpu>:
struct cpu*mycpu(void)  {
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	56                   	push   %esi
80104244:	53                   	push   %ebx
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
80104245:	9c                   	pushf  
80104246:	58                   	pop    %eax
    if (readeflags() & FL_IF) {
80104247:	f6 c4 02             	test   $0x2,%ah
8010424a:	75 5e                	jne    801042aa <mycpu+0x6a>
    apicid = lapicid();
8010424c:	e8 af ef ff ff       	call   80103200 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80104251:	8b 35 e0 54 11 80    	mov    0x801154e0,%esi
80104257:	85 f6                	test   %esi,%esi
80104259:	7e 42                	jle    8010429d <mycpu+0x5d>
        if (cpus[i].apicid == apicid) {
8010425b:	0f b6 15 60 4f 11 80 	movzbl 0x80114f60,%edx
80104262:	39 d0                	cmp    %edx,%eax
80104264:	74 30                	je     80104296 <mycpu+0x56>
80104266:	b9 10 50 11 80       	mov    $0x80115010,%ecx
    for (i = 0; i < ncpu; ++i) {
8010426b:	31 d2                	xor    %edx,%edx
8010426d:	8d 76 00             	lea    0x0(%esi),%esi
80104270:	83 c2 01             	add    $0x1,%edx
80104273:	39 f2                	cmp    %esi,%edx
80104275:	74 26                	je     8010429d <mycpu+0x5d>
        if (cpus[i].apicid == apicid) {
80104277:	0f b6 19             	movzbl (%ecx),%ebx
8010427a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80104280:	39 c3                	cmp    %eax,%ebx
80104282:	75 ec                	jne    80104270 <mycpu+0x30>
80104284:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010428a:	05 60 4f 11 80       	add    $0x80114f60,%eax
}
8010428f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104292:	5b                   	pop    %ebx
80104293:	5e                   	pop    %esi
80104294:	5d                   	pop    %ebp
80104295:	c3                   	ret    
        if (cpus[i].apicid == apicid) {
80104296:	b8 60 4f 11 80       	mov    $0x80114f60,%eax
            return &cpus[i];
8010429b:	eb f2                	jmp    8010428f <mycpu+0x4f>
    panic("unknown apicid\n");
8010429d:	83 ec 0c             	sub    $0xc,%esp
801042a0:	68 bc 80 10 80       	push   $0x801080bc
801042a5:	e8 36 c2 ff ff       	call   801004e0 <panic>
        panic("mycpu called with interrupts enabled\n");
801042aa:	83 ec 0c             	sub    $0xc,%esp
801042ad:	68 98 81 10 80       	push   $0x80108198
801042b2:	e8 29 c2 ff ff       	call   801004e0 <panic>
801042b7:	89 f6                	mov    %esi,%esi
801042b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042c0 <cpuid>:
int cpuid() {
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
801042c6:	e8 75 ff ff ff       	call   80104240 <mycpu>
801042cb:	2d 60 4f 11 80       	sub    $0x80114f60,%eax
}
801042d0:	c9                   	leave  
    return mycpu() - cpus;
801042d1:	c1 f8 04             	sar    $0x4,%eax
801042d4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801042da:	c3                   	ret    
801042db:	90                   	nop
801042dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042e0 <myproc>:
struct proc*myproc(void)  {
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 04             	sub    $0x4,%esp
    pushcli();
801042e7:	e8 84 0a 00 00       	call   80104d70 <pushcli>
    c = mycpu();
801042ec:	e8 4f ff ff ff       	call   80104240 <mycpu>
    p = c->proc;
801042f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801042f7:	e8 b4 0a 00 00       	call   80104db0 <popcli>
}
801042fc:	83 c4 04             	add    $0x4,%esp
801042ff:	89 d8                	mov    %ebx,%eax
80104301:	5b                   	pop    %ebx
80104302:	5d                   	pop    %ebp
80104303:	c3                   	ret    
80104304:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010430a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104310 <userinit>:
void userinit(void) {
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	53                   	push   %ebx
80104314:	83 ec 04             	sub    $0x4,%esp
    p = allocproc();
80104317:	e8 d4 fd ff ff       	call   801040f0 <allocproc>
8010431c:	89 c3                	mov    %eax,%ebx
    initproc = p;
8010431e:	a3 b8 c5 10 80       	mov    %eax,0x8010c5b8
    if ((p->pgdir = setupkvm()) == 0) {
80104323:	e8 38 35 00 00       	call   80107860 <setupkvm>
80104328:	85 c0                	test   %eax,%eax
8010432a:	89 43 04             	mov    %eax,0x4(%ebx)
8010432d:	0f 84 bd 00 00 00    	je     801043f0 <userinit+0xe0>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104333:	83 ec 04             	sub    $0x4,%esp
80104336:	68 2c 00 00 00       	push   $0x2c
8010433b:	68 60 c4 10 80       	push   $0x8010c460
80104340:	50                   	push   %eax
80104341:	e8 fa 31 00 00       	call   80107540 <inituvm>
    memset(p->tf, 0, sizeof(*p->tf));
80104346:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80104349:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
8010434f:	6a 4c                	push   $0x4c
80104351:	6a 00                	push   $0x0
80104353:	ff 73 18             	pushl  0x18(%ebx)
80104356:	e8 f5 0b 00 00       	call   80104f50 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010435b:	8b 43 18             	mov    0x18(%ebx),%eax
8010435e:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104363:	b9 23 00 00 00       	mov    $0x23,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
80104368:	83 c4 0c             	add    $0xc,%esp
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010436b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010436f:	8b 43 18             	mov    0x18(%ebx),%eax
80104372:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
80104376:	8b 43 18             	mov    0x18(%ebx),%eax
80104379:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010437d:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80104381:	8b 43 18             	mov    0x18(%ebx),%eax
80104384:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104388:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
8010438c:	8b 43 18             	mov    0x18(%ebx),%eax
8010438f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80104396:	8b 43 18             	mov    0x18(%ebx),%eax
80104399:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
801043a0:	8b 43 18             	mov    0x18(%ebx),%eax
801043a3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
801043aa:	8d 43 6c             	lea    0x6c(%ebx),%eax
801043ad:	6a 10                	push   $0x10
801043af:	68 e5 80 10 80       	push   $0x801080e5
801043b4:	50                   	push   %eax
801043b5:	e8 76 0d 00 00       	call   80105130 <safestrcpy>
    p->cwd = namei("/");
801043ba:	c7 04 24 ee 80 10 80 	movl   $0x801080ee,(%esp)
801043c1:	e8 ea e5 ff ff       	call   801029b0 <namei>
801043c6:	89 43 68             	mov    %eax,0x68(%ebx)
    acquire(&ptable.lock);
801043c9:	c7 04 24 00 55 11 80 	movl   $0x80115500,(%esp)
801043d0:	e8 6b 0a 00 00       	call   80104e40 <acquire>
    p->state = RUNNABLE;
801043d5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    release(&ptable.lock);
801043dc:	c7 04 24 00 55 11 80 	movl   $0x80115500,(%esp)
801043e3:	e8 18 0b 00 00       	call   80104f00 <release>
}
801043e8:	83 c4 10             	add    $0x10,%esp
801043eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043ee:	c9                   	leave  
801043ef:	c3                   	ret    
        panic("userinit: out of memory?");
801043f0:	83 ec 0c             	sub    $0xc,%esp
801043f3:	68 cc 80 10 80       	push   $0x801080cc
801043f8:	e8 e3 c0 ff ff       	call   801004e0 <panic>
801043fd:	8d 76 00             	lea    0x0(%esi),%esi

80104400 <growproc>:
int growproc(int n) {
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	56                   	push   %esi
80104404:	53                   	push   %ebx
80104405:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80104408:	e8 63 09 00 00       	call   80104d70 <pushcli>
    c = mycpu();
8010440d:	e8 2e fe ff ff       	call   80104240 <mycpu>
    p = c->proc;
80104412:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104418:	e8 93 09 00 00       	call   80104db0 <popcli>
    if (n > 0) {
8010441d:	83 fe 00             	cmp    $0x0,%esi
    sz = curproc->sz;
80104420:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80104422:	7f 1c                	jg     80104440 <growproc+0x40>
    else if (n < 0) {
80104424:	75 3a                	jne    80104460 <growproc+0x60>
    switchuvm(curproc);
80104426:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80104429:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
8010442b:	53                   	push   %ebx
8010442c:	e8 ff 2f 00 00       	call   80107430 <switchuvm>
    return 0;
80104431:	83 c4 10             	add    $0x10,%esp
80104434:	31 c0                	xor    %eax,%eax
}
80104436:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104439:	5b                   	pop    %ebx
8010443a:	5e                   	pop    %esi
8010443b:	5d                   	pop    %ebp
8010443c:	c3                   	ret    
8010443d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0) {
80104440:	83 ec 04             	sub    $0x4,%esp
80104443:	01 c6                	add    %eax,%esi
80104445:	56                   	push   %esi
80104446:	50                   	push   %eax
80104447:	ff 73 04             	pushl  0x4(%ebx)
8010444a:	e8 31 32 00 00       	call   80107680 <allocuvm>
8010444f:	83 c4 10             	add    $0x10,%esp
80104452:	85 c0                	test   %eax,%eax
80104454:	75 d0                	jne    80104426 <growproc+0x26>
            return -1;
80104456:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010445b:	eb d9                	jmp    80104436 <growproc+0x36>
8010445d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0) {
80104460:	83 ec 04             	sub    $0x4,%esp
80104463:	01 c6                	add    %eax,%esi
80104465:	56                   	push   %esi
80104466:	50                   	push   %eax
80104467:	ff 73 04             	pushl  0x4(%ebx)
8010446a:	e8 41 33 00 00       	call   801077b0 <deallocuvm>
8010446f:	83 c4 10             	add    $0x10,%esp
80104472:	85 c0                	test   %eax,%eax
80104474:	75 b0                	jne    80104426 <growproc+0x26>
80104476:	eb de                	jmp    80104456 <growproc+0x56>
80104478:	90                   	nop
80104479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104480 <fork>:
int fork(void) {
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	57                   	push   %edi
80104484:	56                   	push   %esi
80104485:	53                   	push   %ebx
80104486:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80104489:	e8 e2 08 00 00       	call   80104d70 <pushcli>
    c = mycpu();
8010448e:	e8 ad fd ff ff       	call   80104240 <mycpu>
    p = c->proc;
80104493:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104499:	e8 12 09 00 00       	call   80104db0 <popcli>
    if ((np = allocproc()) == 0) {
8010449e:	e8 4d fc ff ff       	call   801040f0 <allocproc>
801044a3:	85 c0                	test   %eax,%eax
801044a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801044a8:	0f 84 b7 00 00 00    	je     80104565 <fork+0xe5>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
801044ae:	83 ec 08             	sub    $0x8,%esp
801044b1:	ff 33                	pushl  (%ebx)
801044b3:	ff 73 04             	pushl  0x4(%ebx)
801044b6:	89 c7                	mov    %eax,%edi
801044b8:	e8 73 34 00 00       	call   80107930 <copyuvm>
801044bd:	83 c4 10             	add    $0x10,%esp
801044c0:	85 c0                	test   %eax,%eax
801044c2:	89 47 04             	mov    %eax,0x4(%edi)
801044c5:	0f 84 a1 00 00 00    	je     8010456c <fork+0xec>
    np->sz = curproc->sz;
801044cb:	8b 03                	mov    (%ebx),%eax
801044cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801044d0:	89 01                	mov    %eax,(%ecx)
    np->parent = curproc;
801044d2:	89 59 14             	mov    %ebx,0x14(%ecx)
801044d5:	89 c8                	mov    %ecx,%eax
    *np->tf = *curproc->tf;
801044d7:	8b 79 18             	mov    0x18(%ecx),%edi
801044da:	8b 73 18             	mov    0x18(%ebx),%esi
801044dd:	b9 13 00 00 00       	mov    $0x13,%ecx
801044e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++) {
801044e4:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
801044e6:	8b 40 18             	mov    0x18(%eax),%eax
801044e9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
        if (curproc->ofile[i]) {
801044f0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801044f4:	85 c0                	test   %eax,%eax
801044f6:	74 13                	je     8010450b <fork+0x8b>
            np->ofile[i] = filedup(curproc->ofile[i]);
801044f8:	83 ec 0c             	sub    $0xc,%esp
801044fb:	50                   	push   %eax
801044fc:	e8 bf d3 ff ff       	call   801018c0 <filedup>
80104501:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104504:	83 c4 10             	add    $0x10,%esp
80104507:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
    for (i = 0; i < NOFILE; i++) {
8010450b:	83 c6 01             	add    $0x1,%esi
8010450e:	83 fe 10             	cmp    $0x10,%esi
80104511:	75 dd                	jne    801044f0 <fork+0x70>
    np->cwd = idup(curproc->cwd);
80104513:	83 ec 0c             	sub    $0xc,%esp
80104516:	ff 73 68             	pushl  0x68(%ebx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104519:	83 c3 6c             	add    $0x6c,%ebx
    np->cwd = idup(curproc->cwd);
8010451c:	e8 ff db ff ff       	call   80102120 <idup>
80104521:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104524:	83 c4 0c             	add    $0xc,%esp
    np->cwd = idup(curproc->cwd);
80104527:	89 47 68             	mov    %eax,0x68(%edi)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010452a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010452d:	6a 10                	push   $0x10
8010452f:	53                   	push   %ebx
80104530:	50                   	push   %eax
80104531:	e8 fa 0b 00 00       	call   80105130 <safestrcpy>
    pid = np->pid;
80104536:	8b 5f 10             	mov    0x10(%edi),%ebx
    acquire(&ptable.lock);
80104539:	c7 04 24 00 55 11 80 	movl   $0x80115500,(%esp)
80104540:	e8 fb 08 00 00       	call   80104e40 <acquire>
    np->state = RUNNABLE;
80104545:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
    release(&ptable.lock);
8010454c:	c7 04 24 00 55 11 80 	movl   $0x80115500,(%esp)
80104553:	e8 a8 09 00 00       	call   80104f00 <release>
    return pid;
80104558:	83 c4 10             	add    $0x10,%esp
}
8010455b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010455e:	89 d8                	mov    %ebx,%eax
80104560:	5b                   	pop    %ebx
80104561:	5e                   	pop    %esi
80104562:	5f                   	pop    %edi
80104563:	5d                   	pop    %ebp
80104564:	c3                   	ret    
        return -1;
80104565:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010456a:	eb ef                	jmp    8010455b <fork+0xdb>
        kfree(np->kstack);
8010456c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010456f:	83 ec 0c             	sub    $0xc,%esp
80104572:	ff 73 08             	pushl  0x8(%ebx)
80104575:	e8 66 e8 ff ff       	call   80102de0 <kfree>
        np->kstack = 0;
8010457a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->state = UNUSED;
80104581:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return -1;
80104588:	83 c4 10             	add    $0x10,%esp
8010458b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104590:	eb c9                	jmp    8010455b <fork+0xdb>
80104592:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045a0 <scheduler>:
void scheduler(void) {
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	57                   	push   %edi
801045a4:	56                   	push   %esi
801045a5:	53                   	push   %ebx
801045a6:	83 ec 0c             	sub    $0xc,%esp
    struct cpu *c = mycpu();
801045a9:	e8 92 fc ff ff       	call   80104240 <mycpu>
801045ae:	8d 78 04             	lea    0x4(%eax),%edi
801045b1:	89 c6                	mov    %eax,%esi
    c->proc = 0;
801045b3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801045ba:	00 00 00 
801045bd:	8d 76 00             	lea    0x0(%esi),%esi
    asm volatile ("sti");
801045c0:	fb                   	sti    
        acquire(&ptable.lock);
801045c1:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801045c4:	bb 34 55 11 80       	mov    $0x80115534,%ebx
        acquire(&ptable.lock);
801045c9:	68 00 55 11 80       	push   $0x80115500
801045ce:	e8 6d 08 00 00       	call   80104e40 <acquire>
801045d3:	83 c4 10             	add    $0x10,%esp
801045d6:	8d 76 00             	lea    0x0(%esi),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            if (p->state != RUNNABLE) {
801045e0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801045e4:	75 33                	jne    80104619 <scheduler+0x79>
            switchuvm(p);
801045e6:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
801045e9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
801045ef:	53                   	push   %ebx
801045f0:	e8 3b 2e 00 00       	call   80107430 <switchuvm>
            swtch(&(c->scheduler), p->context);
801045f5:	58                   	pop    %eax
801045f6:	5a                   	pop    %edx
801045f7:	ff 73 1c             	pushl  0x1c(%ebx)
801045fa:	57                   	push   %edi
            p->state = RUNNING;
801045fb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
            swtch(&(c->scheduler), p->context);
80104602:	e8 84 0b 00 00       	call   8010518b <swtch>
            switchkvm();
80104607:	e8 04 2e 00 00       	call   80107410 <switchkvm>
            c->proc = 0;
8010460c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104613:	00 00 00 
80104616:	83 c4 10             	add    $0x10,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104619:	83 c3 7c             	add    $0x7c,%ebx
8010461c:	81 fb 34 74 11 80    	cmp    $0x80117434,%ebx
80104622:	72 bc                	jb     801045e0 <scheduler+0x40>
        release(&ptable.lock);
80104624:	83 ec 0c             	sub    $0xc,%esp
80104627:	68 00 55 11 80       	push   $0x80115500
8010462c:	e8 cf 08 00 00       	call   80104f00 <release>
        sti();
80104631:	83 c4 10             	add    $0x10,%esp
80104634:	eb 8a                	jmp    801045c0 <scheduler+0x20>
80104636:	8d 76 00             	lea    0x0(%esi),%esi
80104639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104640 <sched>:
void sched(void) {
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
    pushcli();
80104645:	e8 26 07 00 00       	call   80104d70 <pushcli>
    c = mycpu();
8010464a:	e8 f1 fb ff ff       	call   80104240 <mycpu>
    p = c->proc;
8010464f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104655:	e8 56 07 00 00       	call   80104db0 <popcli>
    if (!holding(&ptable.lock)) {
8010465a:	83 ec 0c             	sub    $0xc,%esp
8010465d:	68 00 55 11 80       	push   $0x80115500
80104662:	e8 a9 07 00 00       	call   80104e10 <holding>
80104667:	83 c4 10             	add    $0x10,%esp
8010466a:	85 c0                	test   %eax,%eax
8010466c:	74 4f                	je     801046bd <sched+0x7d>
    if (mycpu()->ncli != 1) {
8010466e:	e8 cd fb ff ff       	call   80104240 <mycpu>
80104673:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010467a:	75 68                	jne    801046e4 <sched+0xa4>
    if (p->state == RUNNING) {
8010467c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104680:	74 55                	je     801046d7 <sched+0x97>
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
80104682:	9c                   	pushf  
80104683:	58                   	pop    %eax
    if (readeflags() & FL_IF) {
80104684:	f6 c4 02             	test   $0x2,%ah
80104687:	75 41                	jne    801046ca <sched+0x8a>
    intena = mycpu()->intena;
80104689:	e8 b2 fb ff ff       	call   80104240 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
8010468e:	83 c3 1c             	add    $0x1c,%ebx
    intena = mycpu()->intena;
80104691:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
80104697:	e8 a4 fb ff ff       	call   80104240 <mycpu>
8010469c:	83 ec 08             	sub    $0x8,%esp
8010469f:	ff 70 04             	pushl  0x4(%eax)
801046a2:	53                   	push   %ebx
801046a3:	e8 e3 0a 00 00       	call   8010518b <swtch>
    mycpu()->intena = intena;
801046a8:	e8 93 fb ff ff       	call   80104240 <mycpu>
}
801046ad:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
801046b0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801046b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046b9:	5b                   	pop    %ebx
801046ba:	5e                   	pop    %esi
801046bb:	5d                   	pop    %ebp
801046bc:	c3                   	ret    
        panic("sched ptable.lock");
801046bd:	83 ec 0c             	sub    $0xc,%esp
801046c0:	68 f0 80 10 80       	push   $0x801080f0
801046c5:	e8 16 be ff ff       	call   801004e0 <panic>
        panic("sched interruptible");
801046ca:	83 ec 0c             	sub    $0xc,%esp
801046cd:	68 1c 81 10 80       	push   $0x8010811c
801046d2:	e8 09 be ff ff       	call   801004e0 <panic>
        panic("sched running");
801046d7:	83 ec 0c             	sub    $0xc,%esp
801046da:	68 0e 81 10 80       	push   $0x8010810e
801046df:	e8 fc bd ff ff       	call   801004e0 <panic>
        panic("sched locks");
801046e4:	83 ec 0c             	sub    $0xc,%esp
801046e7:	68 02 81 10 80       	push   $0x80108102
801046ec:	e8 ef bd ff ff       	call   801004e0 <panic>
801046f1:	eb 0d                	jmp    80104700 <exit>
801046f3:	90                   	nop
801046f4:	90                   	nop
801046f5:	90                   	nop
801046f6:	90                   	nop
801046f7:	90                   	nop
801046f8:	90                   	nop
801046f9:	90                   	nop
801046fa:	90                   	nop
801046fb:	90                   	nop
801046fc:	90                   	nop
801046fd:	90                   	nop
801046fe:	90                   	nop
801046ff:	90                   	nop

80104700 <exit>:
void exit(void)  {
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	57                   	push   %edi
80104704:	56                   	push   %esi
80104705:	53                   	push   %ebx
80104706:	83 ec 0c             	sub    $0xc,%esp
    pushcli();
80104709:	e8 62 06 00 00       	call   80104d70 <pushcli>
    c = mycpu();
8010470e:	e8 2d fb ff ff       	call   80104240 <mycpu>
    p = c->proc;
80104713:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104719:	e8 92 06 00 00       	call   80104db0 <popcli>
    if (curproc == initproc) {
8010471e:	39 35 b8 c5 10 80    	cmp    %esi,0x8010c5b8
80104724:	8d 5e 28             	lea    0x28(%esi),%ebx
80104727:	8d 7e 68             	lea    0x68(%esi),%edi
8010472a:	0f 84 e7 00 00 00    	je     80104817 <exit+0x117>
        if (curproc->ofile[fd]) {
80104730:	8b 03                	mov    (%ebx),%eax
80104732:	85 c0                	test   %eax,%eax
80104734:	74 12                	je     80104748 <exit+0x48>
            fileclose(curproc->ofile[fd]);
80104736:	83 ec 0c             	sub    $0xc,%esp
80104739:	50                   	push   %eax
8010473a:	e8 d1 d1 ff ff       	call   80101910 <fileclose>
            curproc->ofile[fd] = 0;
8010473f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104745:	83 c4 10             	add    $0x10,%esp
80104748:	83 c3 04             	add    $0x4,%ebx
    for (fd = 0; fd < NOFILE; fd++) {
8010474b:	39 fb                	cmp    %edi,%ebx
8010474d:	75 e1                	jne    80104730 <exit+0x30>
    begin_op();
8010474f:	e8 1c ef ff ff       	call   80103670 <begin_op>
    iput(curproc->cwd);
80104754:	83 ec 0c             	sub    $0xc,%esp
80104757:	ff 76 68             	pushl  0x68(%esi)
8010475a:	e8 21 db ff ff       	call   80102280 <iput>
    end_op();
8010475f:	e8 7c ef ff ff       	call   801036e0 <end_op>
    curproc->cwd = 0;
80104764:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
    acquire(&ptable.lock);
8010476b:	c7 04 24 00 55 11 80 	movl   $0x80115500,(%esp)
80104772:	e8 c9 06 00 00       	call   80104e40 <acquire>
    wakeup1(curproc->parent);
80104777:	8b 56 14             	mov    0x14(%esi),%edx
8010477a:	83 c4 10             	add    $0x10,%esp
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010477d:	b8 34 55 11 80       	mov    $0x80115534,%eax
80104782:	eb 0e                	jmp    80104792 <exit+0x92>
80104784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104788:	83 c0 7c             	add    $0x7c,%eax
8010478b:	3d 34 74 11 80       	cmp    $0x80117434,%eax
80104790:	73 1c                	jae    801047ae <exit+0xae>
        if (p->state == SLEEPING && p->chan == chan) {
80104792:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104796:	75 f0                	jne    80104788 <exit+0x88>
80104798:	3b 50 20             	cmp    0x20(%eax),%edx
8010479b:	75 eb                	jne    80104788 <exit+0x88>
            p->state = RUNNABLE;
8010479d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801047a4:	83 c0 7c             	add    $0x7c,%eax
801047a7:	3d 34 74 11 80       	cmp    $0x80117434,%eax
801047ac:	72 e4                	jb     80104792 <exit+0x92>
            p->parent = initproc;
801047ae:	8b 0d b8 c5 10 80    	mov    0x8010c5b8,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801047b4:	ba 34 55 11 80       	mov    $0x80115534,%edx
801047b9:	eb 10                	jmp    801047cb <exit+0xcb>
801047bb:	90                   	nop
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047c0:	83 c2 7c             	add    $0x7c,%edx
801047c3:	81 fa 34 74 11 80    	cmp    $0x80117434,%edx
801047c9:	73 33                	jae    801047fe <exit+0xfe>
        if (p->parent == curproc) {
801047cb:	39 72 14             	cmp    %esi,0x14(%edx)
801047ce:	75 f0                	jne    801047c0 <exit+0xc0>
            if (p->state == ZOMBIE) {
801047d0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
            p->parent = initproc;
801047d4:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE) {
801047d7:	75 e7                	jne    801047c0 <exit+0xc0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801047d9:	b8 34 55 11 80       	mov    $0x80115534,%eax
801047de:	eb 0a                	jmp    801047ea <exit+0xea>
801047e0:	83 c0 7c             	add    $0x7c,%eax
801047e3:	3d 34 74 11 80       	cmp    $0x80117434,%eax
801047e8:	73 d6                	jae    801047c0 <exit+0xc0>
        if (p->state == SLEEPING && p->chan == chan) {
801047ea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801047ee:	75 f0                	jne    801047e0 <exit+0xe0>
801047f0:	3b 48 20             	cmp    0x20(%eax),%ecx
801047f3:	75 eb                	jne    801047e0 <exit+0xe0>
            p->state = RUNNABLE;
801047f5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801047fc:	eb e2                	jmp    801047e0 <exit+0xe0>
    curproc->state = ZOMBIE;
801047fe:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
    sched();
80104805:	e8 36 fe ff ff       	call   80104640 <sched>
    panic("zombie exit");
8010480a:	83 ec 0c             	sub    $0xc,%esp
8010480d:	68 3d 81 10 80       	push   $0x8010813d
80104812:	e8 c9 bc ff ff       	call   801004e0 <panic>
        panic("init exiting");
80104817:	83 ec 0c             	sub    $0xc,%esp
8010481a:	68 30 81 10 80       	push   $0x80108130
8010481f:	e8 bc bc ff ff       	call   801004e0 <panic>
80104824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010482a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104830 <yield>:
void yield(void)      {
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	53                   	push   %ebx
80104834:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80104837:	68 00 55 11 80       	push   $0x80115500
8010483c:	e8 ff 05 00 00       	call   80104e40 <acquire>
    pushcli();
80104841:	e8 2a 05 00 00       	call   80104d70 <pushcli>
    c = mycpu();
80104846:	e8 f5 f9 ff ff       	call   80104240 <mycpu>
    p = c->proc;
8010484b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104851:	e8 5a 05 00 00       	call   80104db0 <popcli>
    myproc()->state = RUNNABLE;
80104856:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    sched();
8010485d:	e8 de fd ff ff       	call   80104640 <sched>
    release(&ptable.lock);
80104862:	c7 04 24 00 55 11 80 	movl   $0x80115500,(%esp)
80104869:	e8 92 06 00 00       	call   80104f00 <release>
}
8010486e:	83 c4 10             	add    $0x10,%esp
80104871:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104874:	c9                   	leave  
80104875:	c3                   	ret    
80104876:	8d 76 00             	lea    0x0(%esi),%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104880 <sleep>:
void sleep(void *chan, struct spinlock *lk)  {
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	57                   	push   %edi
80104884:	56                   	push   %esi
80104885:	53                   	push   %ebx
80104886:	83 ec 0c             	sub    $0xc,%esp
80104889:	8b 7d 08             	mov    0x8(%ebp),%edi
8010488c:	8b 75 0c             	mov    0xc(%ebp),%esi
    pushcli();
8010488f:	e8 dc 04 00 00       	call   80104d70 <pushcli>
    c = mycpu();
80104894:	e8 a7 f9 ff ff       	call   80104240 <mycpu>
    p = c->proc;
80104899:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
8010489f:	e8 0c 05 00 00       	call   80104db0 <popcli>
    if (p == 0) {
801048a4:	85 db                	test   %ebx,%ebx
801048a6:	0f 84 87 00 00 00    	je     80104933 <sleep+0xb3>
    if (lk == 0) {
801048ac:	85 f6                	test   %esi,%esi
801048ae:	74 76                	je     80104926 <sleep+0xa6>
    if (lk != &ptable.lock) { //DOC: sleeplock0
801048b0:	81 fe 00 55 11 80    	cmp    $0x80115500,%esi
801048b6:	74 50                	je     80104908 <sleep+0x88>
        acquire(&ptable.lock);  //DOC: sleeplock1
801048b8:	83 ec 0c             	sub    $0xc,%esp
801048bb:	68 00 55 11 80       	push   $0x80115500
801048c0:	e8 7b 05 00 00       	call   80104e40 <acquire>
        release(lk);
801048c5:	89 34 24             	mov    %esi,(%esp)
801048c8:	e8 33 06 00 00       	call   80104f00 <release>
    p->chan = chan;
801048cd:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
801048d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
801048d7:	e8 64 fd ff ff       	call   80104640 <sched>
    p->chan = 0;
801048dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        release(&ptable.lock);
801048e3:	c7 04 24 00 55 11 80 	movl   $0x80115500,(%esp)
801048ea:	e8 11 06 00 00       	call   80104f00 <release>
        acquire(lk);
801048ef:	89 75 08             	mov    %esi,0x8(%ebp)
801048f2:	83 c4 10             	add    $0x10,%esp
}
801048f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048f8:	5b                   	pop    %ebx
801048f9:	5e                   	pop    %esi
801048fa:	5f                   	pop    %edi
801048fb:	5d                   	pop    %ebp
        acquire(lk);
801048fc:	e9 3f 05 00 00       	jmp    80104e40 <acquire>
80104901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->chan = chan;
80104908:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
8010490b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104912:	e8 29 fd ff ff       	call   80104640 <sched>
    p->chan = 0;
80104917:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010491e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104921:	5b                   	pop    %ebx
80104922:	5e                   	pop    %esi
80104923:	5f                   	pop    %edi
80104924:	5d                   	pop    %ebp
80104925:	c3                   	ret    
        panic("sleep without lk");
80104926:	83 ec 0c             	sub    $0xc,%esp
80104929:	68 4f 81 10 80       	push   $0x8010814f
8010492e:	e8 ad bb ff ff       	call   801004e0 <panic>
        panic("sleep");
80104933:	83 ec 0c             	sub    $0xc,%esp
80104936:	68 49 81 10 80       	push   $0x80108149
8010493b:	e8 a0 bb ff ff       	call   801004e0 <panic>

80104940 <wait>:
int wait(void) {
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
    pushcli();
80104945:	e8 26 04 00 00       	call   80104d70 <pushcli>
    c = mycpu();
8010494a:	e8 f1 f8 ff ff       	call   80104240 <mycpu>
    p = c->proc;
8010494f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104955:	e8 56 04 00 00       	call   80104db0 <popcli>
    acquire(&ptable.lock);
8010495a:	83 ec 0c             	sub    $0xc,%esp
8010495d:	68 00 55 11 80       	push   $0x80115500
80104962:	e8 d9 04 00 00       	call   80104e40 <acquire>
80104967:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
8010496a:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010496c:	bb 34 55 11 80       	mov    $0x80115534,%ebx
80104971:	eb 10                	jmp    80104983 <wait+0x43>
80104973:	90                   	nop
80104974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104978:	83 c3 7c             	add    $0x7c,%ebx
8010497b:	81 fb 34 74 11 80    	cmp    $0x80117434,%ebx
80104981:	73 1b                	jae    8010499e <wait+0x5e>
            if (p->parent != curproc) {
80104983:	39 73 14             	cmp    %esi,0x14(%ebx)
80104986:	75 f0                	jne    80104978 <wait+0x38>
            if (p->state == ZOMBIE) {
80104988:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010498c:	74 32                	je     801049c0 <wait+0x80>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010498e:	83 c3 7c             	add    $0x7c,%ebx
            havekids = 1;
80104991:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104996:	81 fb 34 74 11 80    	cmp    $0x80117434,%ebx
8010499c:	72 e5                	jb     80104983 <wait+0x43>
        if (!havekids || curproc->killed) {
8010499e:	85 c0                	test   %eax,%eax
801049a0:	74 74                	je     80104a16 <wait+0xd6>
801049a2:	8b 46 24             	mov    0x24(%esi),%eax
801049a5:	85 c0                	test   %eax,%eax
801049a7:	75 6d                	jne    80104a16 <wait+0xd6>
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801049a9:	83 ec 08             	sub    $0x8,%esp
801049ac:	68 00 55 11 80       	push   $0x80115500
801049b1:	56                   	push   %esi
801049b2:	e8 c9 fe ff ff       	call   80104880 <sleep>
        havekids = 0;
801049b7:	83 c4 10             	add    $0x10,%esp
801049ba:	eb ae                	jmp    8010496a <wait+0x2a>
801049bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                kfree(p->kstack);
801049c0:	83 ec 0c             	sub    $0xc,%esp
801049c3:	ff 73 08             	pushl  0x8(%ebx)
                pid = p->pid;
801049c6:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
801049c9:	e8 12 e4 ff ff       	call   80102de0 <kfree>
                freevm(p->pgdir);
801049ce:	5a                   	pop    %edx
801049cf:	ff 73 04             	pushl  0x4(%ebx)
                p->kstack = 0;
801049d2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
801049d9:	e8 02 2e 00 00       	call   801077e0 <freevm>
                release(&ptable.lock);
801049de:	c7 04 24 00 55 11 80 	movl   $0x80115500,(%esp)
                p->pid = 0;
801049e5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
801049ec:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
801049f3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
801049f7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
801049fe:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
80104a05:	e8 f6 04 00 00       	call   80104f00 <release>
                return pid;
80104a0a:	83 c4 10             	add    $0x10,%esp
}
80104a0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a10:	89 f0                	mov    %esi,%eax
80104a12:	5b                   	pop    %ebx
80104a13:	5e                   	pop    %esi
80104a14:	5d                   	pop    %ebp
80104a15:	c3                   	ret    
            release(&ptable.lock);
80104a16:	83 ec 0c             	sub    $0xc,%esp
            return -1;
80104a19:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
80104a1e:	68 00 55 11 80       	push   $0x80115500
80104a23:	e8 d8 04 00 00       	call   80104f00 <release>
            return -1;
80104a28:	83 c4 10             	add    $0x10,%esp
80104a2b:	eb e0                	jmp    80104a0d <wait+0xcd>
80104a2d:	8d 76 00             	lea    0x0(%esi),%esi

80104a30 <wakeup>:
        }
    }
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan) {
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	53                   	push   %ebx
80104a34:	83 ec 10             	sub    $0x10,%esp
80104a37:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
80104a3a:	68 00 55 11 80       	push   $0x80115500
80104a3f:	e8 fc 03 00 00       	call   80104e40 <acquire>
80104a44:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104a47:	b8 34 55 11 80       	mov    $0x80115534,%eax
80104a4c:	eb 0c                	jmp    80104a5a <wakeup+0x2a>
80104a4e:	66 90                	xchg   %ax,%ax
80104a50:	83 c0 7c             	add    $0x7c,%eax
80104a53:	3d 34 74 11 80       	cmp    $0x80117434,%eax
80104a58:	73 1c                	jae    80104a76 <wakeup+0x46>
        if (p->state == SLEEPING && p->chan == chan) {
80104a5a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104a5e:	75 f0                	jne    80104a50 <wakeup+0x20>
80104a60:	3b 58 20             	cmp    0x20(%eax),%ebx
80104a63:	75 eb                	jne    80104a50 <wakeup+0x20>
            p->state = RUNNABLE;
80104a65:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104a6c:	83 c0 7c             	add    $0x7c,%eax
80104a6f:	3d 34 74 11 80       	cmp    $0x80117434,%eax
80104a74:	72 e4                	jb     80104a5a <wakeup+0x2a>
    wakeup1(chan);
    release(&ptable.lock);
80104a76:	c7 45 08 00 55 11 80 	movl   $0x80115500,0x8(%ebp)
}
80104a7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a80:	c9                   	leave  
    release(&ptable.lock);
80104a81:	e9 7a 04 00 00       	jmp    80104f00 <release>
80104a86:	8d 76 00             	lea    0x0(%esi),%esi
80104a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a90 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid) {
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 10             	sub    $0x10,%esp
80104a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
80104a9a:	68 00 55 11 80       	push   $0x80115500
80104a9f:	e8 9c 03 00 00       	call   80104e40 <acquire>
80104aa4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104aa7:	b8 34 55 11 80       	mov    $0x80115534,%eax
80104aac:	eb 0c                	jmp    80104aba <kill+0x2a>
80104aae:	66 90                	xchg   %ax,%ax
80104ab0:	83 c0 7c             	add    $0x7c,%eax
80104ab3:	3d 34 74 11 80       	cmp    $0x80117434,%eax
80104ab8:	73 36                	jae    80104af0 <kill+0x60>
        if (p->pid == pid) {
80104aba:	39 58 10             	cmp    %ebx,0x10(%eax)
80104abd:	75 f1                	jne    80104ab0 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING) {
80104abf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
            p->killed = 1;
80104ac3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            if (p->state == SLEEPING) {
80104aca:	75 07                	jne    80104ad3 <kill+0x43>
                p->state = RUNNABLE;
80104acc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            }
            release(&ptable.lock);
80104ad3:	83 ec 0c             	sub    $0xc,%esp
80104ad6:	68 00 55 11 80       	push   $0x80115500
80104adb:	e8 20 04 00 00       	call   80104f00 <release>
            return 0;
80104ae0:	83 c4 10             	add    $0x10,%esp
80104ae3:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
80104ae5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ae8:	c9                   	leave  
80104ae9:	c3                   	ret    
80104aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ptable.lock);
80104af0:	83 ec 0c             	sub    $0xc,%esp
80104af3:	68 00 55 11 80       	push   $0x80115500
80104af8:	e8 03 04 00 00       	call   80104f00 <release>
    return -1;
80104afd:	83 c4 10             	add    $0x10,%esp
80104b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b08:	c9                   	leave  
80104b09:	c3                   	ret    
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b10 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	57                   	push   %edi
80104b14:	56                   	push   %esi
80104b15:	53                   	push   %ebx
80104b16:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104b19:	bb 34 55 11 80       	mov    $0x80115534,%ebx
void procdump(void) {
80104b1e:	83 ec 3c             	sub    $0x3c,%esp
80104b21:	eb 24                	jmp    80104b47 <procdump+0x37>
80104b23:	90                   	nop
80104b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            getcallerpcs((uint*)p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++) {
                cprintf(" %p", pc[i]);
            }
        }
        cprintf("\n");
80104b28:	83 ec 0c             	sub    $0xc,%esp
80104b2b:	68 47 85 10 80       	push   $0x80108547
80104b30:	e8 2b bd ff ff       	call   80100860 <cprintf>
80104b35:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104b38:	83 c3 7c             	add    $0x7c,%ebx
80104b3b:	81 fb 34 74 11 80    	cmp    $0x80117434,%ebx
80104b41:	0f 83 81 00 00 00    	jae    80104bc8 <procdump+0xb8>
        if (p->state == UNUSED) {
80104b47:	8b 43 0c             	mov    0xc(%ebx),%eax
80104b4a:	85 c0                	test   %eax,%eax
80104b4c:	74 ea                	je     80104b38 <procdump+0x28>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state]) {
80104b4e:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
80104b51:	ba 60 81 10 80       	mov    $0x80108160,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state]) {
80104b56:	77 11                	ja     80104b69 <procdump+0x59>
80104b58:	8b 14 85 c0 81 10 80 	mov    -0x7fef7e40(,%eax,4),%edx
            state = "???";
80104b5f:	b8 60 81 10 80       	mov    $0x80108160,%eax
80104b64:	85 d2                	test   %edx,%edx
80104b66:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
80104b69:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104b6c:	50                   	push   %eax
80104b6d:	52                   	push   %edx
80104b6e:	ff 73 10             	pushl  0x10(%ebx)
80104b71:	68 64 81 10 80       	push   $0x80108164
80104b76:	e8 e5 bc ff ff       	call   80100860 <cprintf>
        if (p->state == SLEEPING) {
80104b7b:	83 c4 10             	add    $0x10,%esp
80104b7e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104b82:	75 a4                	jne    80104b28 <procdump+0x18>
            getcallerpcs((uint*)p->context->ebp + 2, pc);
80104b84:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b87:	83 ec 08             	sub    $0x8,%esp
80104b8a:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104b8d:	50                   	push   %eax
80104b8e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104b91:	8b 40 0c             	mov    0xc(%eax),%eax
80104b94:	83 c0 08             	add    $0x8,%eax
80104b97:	50                   	push   %eax
80104b98:	e8 83 01 00 00       	call   80104d20 <getcallerpcs>
80104b9d:	83 c4 10             	add    $0x10,%esp
            for (i = 0; i < 10 && pc[i] != 0; i++) {
80104ba0:	8b 17                	mov    (%edi),%edx
80104ba2:	85 d2                	test   %edx,%edx
80104ba4:	74 82                	je     80104b28 <procdump+0x18>
                cprintf(" %p", pc[i]);
80104ba6:	83 ec 08             	sub    $0x8,%esp
80104ba9:	83 c7 04             	add    $0x4,%edi
80104bac:	52                   	push   %edx
80104bad:	68 61 7b 10 80       	push   $0x80107b61
80104bb2:	e8 a9 bc ff ff       	call   80100860 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++) {
80104bb7:	83 c4 10             	add    $0x10,%esp
80104bba:	39 fe                	cmp    %edi,%esi
80104bbc:	75 e2                	jne    80104ba0 <procdump+0x90>
80104bbe:	e9 65 ff ff ff       	jmp    80104b28 <procdump+0x18>
80104bc3:	90                   	nop
80104bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
}
80104bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bcb:	5b                   	pop    %ebx
80104bcc:	5e                   	pop    %esi
80104bcd:	5f                   	pop    %edi
80104bce:	5d                   	pop    %ebp
80104bcf:	c3                   	ret    

80104bd0 <initsleeplock>:
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "sleeplock.h"

void initsleeplock(struct sleeplock *lk, char *name) {
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	53                   	push   %ebx
80104bd4:	83 ec 0c             	sub    $0xc,%esp
80104bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    initlock(&lk->lk, "sleep lock");
80104bda:	68 d8 81 10 80       	push   $0x801081d8
80104bdf:	8d 43 04             	lea    0x4(%ebx),%eax
80104be2:	50                   	push   %eax
80104be3:	e8 18 01 00 00       	call   80104d00 <initlock>
    lk->name = name;
80104be8:	8b 45 0c             	mov    0xc(%ebp),%eax
    lk->locked = 0;
80104beb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    lk->pid = 0;
}
80104bf1:	83 c4 10             	add    $0x10,%esp
    lk->pid = 0;
80104bf4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
    lk->name = name;
80104bfb:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104bfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c01:	c9                   	leave  
80104c02:	c3                   	ret    
80104c03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c10 <acquiresleep>:

void acquiresleep(struct sleeplock *lk) {
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	56                   	push   %esi
80104c14:	53                   	push   %ebx
80104c15:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&lk->lk);
80104c18:	83 ec 0c             	sub    $0xc,%esp
80104c1b:	8d 73 04             	lea    0x4(%ebx),%esi
80104c1e:	56                   	push   %esi
80104c1f:	e8 1c 02 00 00       	call   80104e40 <acquire>
    while (lk->locked) {
80104c24:	8b 13                	mov    (%ebx),%edx
80104c26:	83 c4 10             	add    $0x10,%esp
80104c29:	85 d2                	test   %edx,%edx
80104c2b:	74 16                	je     80104c43 <acquiresleep+0x33>
80104c2d:	8d 76 00             	lea    0x0(%esi),%esi
        sleep(lk, &lk->lk);
80104c30:	83 ec 08             	sub    $0x8,%esp
80104c33:	56                   	push   %esi
80104c34:	53                   	push   %ebx
80104c35:	e8 46 fc ff ff       	call   80104880 <sleep>
    while (lk->locked) {
80104c3a:	8b 03                	mov    (%ebx),%eax
80104c3c:	83 c4 10             	add    $0x10,%esp
80104c3f:	85 c0                	test   %eax,%eax
80104c41:	75 ed                	jne    80104c30 <acquiresleep+0x20>
    }
    lk->locked = 1;
80104c43:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
    lk->pid = myproc()->pid;
80104c49:	e8 92 f6 ff ff       	call   801042e0 <myproc>
80104c4e:	8b 40 10             	mov    0x10(%eax),%eax
80104c51:	89 43 3c             	mov    %eax,0x3c(%ebx)
    release(&lk->lk);
80104c54:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104c57:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c5a:	5b                   	pop    %ebx
80104c5b:	5e                   	pop    %esi
80104c5c:	5d                   	pop    %ebp
    release(&lk->lk);
80104c5d:	e9 9e 02 00 00       	jmp    80104f00 <release>
80104c62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <releasesleep>:

void releasesleep(struct sleeplock *lk) {
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	53                   	push   %ebx
80104c75:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&lk->lk);
80104c78:	83 ec 0c             	sub    $0xc,%esp
80104c7b:	8d 73 04             	lea    0x4(%ebx),%esi
80104c7e:	56                   	push   %esi
80104c7f:	e8 bc 01 00 00       	call   80104e40 <acquire>
    lk->locked = 0;
80104c84:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    lk->pid = 0;
80104c8a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
    wakeup(lk);
80104c91:	89 1c 24             	mov    %ebx,(%esp)
80104c94:	e8 97 fd ff ff       	call   80104a30 <wakeup>
    release(&lk->lk);
80104c99:	89 75 08             	mov    %esi,0x8(%ebp)
80104c9c:	83 c4 10             	add    $0x10,%esp
}
80104c9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ca2:	5b                   	pop    %ebx
80104ca3:	5e                   	pop    %esi
80104ca4:	5d                   	pop    %ebp
    release(&lk->lk);
80104ca5:	e9 56 02 00 00       	jmp    80104f00 <release>
80104caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104cb0 <holdingsleep>:

int holdingsleep(struct sleeplock *lk) {
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	57                   	push   %edi
80104cb4:	56                   	push   %esi
80104cb5:	53                   	push   %ebx
80104cb6:	31 ff                	xor    %edi,%edi
80104cb8:	83 ec 18             	sub    $0x18,%esp
80104cbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int r;

    acquire(&lk->lk);
80104cbe:	8d 73 04             	lea    0x4(%ebx),%esi
80104cc1:	56                   	push   %esi
80104cc2:	e8 79 01 00 00       	call   80104e40 <acquire>
    r = lk->locked && (lk->pid == myproc()->pid);
80104cc7:	8b 03                	mov    (%ebx),%eax
80104cc9:	83 c4 10             	add    $0x10,%esp
80104ccc:	85 c0                	test   %eax,%eax
80104cce:	74 13                	je     80104ce3 <holdingsleep+0x33>
80104cd0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104cd3:	e8 08 f6 ff ff       	call   801042e0 <myproc>
80104cd8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104cdb:	0f 94 c0             	sete   %al
80104cde:	0f b6 c0             	movzbl %al,%eax
80104ce1:	89 c7                	mov    %eax,%edi
    release(&lk->lk);
80104ce3:	83 ec 0c             	sub    $0xc,%esp
80104ce6:	56                   	push   %esi
80104ce7:	e8 14 02 00 00       	call   80104f00 <release>
    return r;
}
80104cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cef:	89 f8                	mov    %edi,%eax
80104cf1:	5b                   	pop    %ebx
80104cf2:	5e                   	pop    %esi
80104cf3:	5f                   	pop    %edi
80104cf4:	5d                   	pop    %ebp
80104cf5:	c3                   	ret    
80104cf6:	66 90                	xchg   %ax,%ax
80104cf8:	66 90                	xchg   %ax,%ax
80104cfa:	66 90                	xchg   %ax,%ax
80104cfc:	66 90                	xchg   %ax,%ax
80104cfe:	66 90                	xchg   %ax,%ax

80104d00 <initlock>:
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

void initlock(struct spinlock *lk, char *name) {
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	8b 45 08             	mov    0x8(%ebp),%eax
    lk->name = name;
80104d06:	8b 55 0c             	mov    0xc(%ebp),%edx
    lk->locked = 0;
80104d09:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    lk->name = name;
80104d0f:	89 50 04             	mov    %edx,0x4(%eax)
    lk->cpu = 0;
80104d12:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104d19:	5d                   	pop    %ebp
80104d1a:	c3                   	ret    
80104d1b:	90                   	nop
80104d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d20 <getcallerpcs>:

    popcli();
}

// Record the current call stack in pcs[] by following the %ebp chain.
void getcallerpcs(void *v, uint pcs[]) {
80104d20:	55                   	push   %ebp
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
    for (i = 0; i < 10; i++) {
80104d21:	31 d2                	xor    %edx,%edx
void getcallerpcs(void *v, uint pcs[]) {
80104d23:	89 e5                	mov    %esp,%ebp
80104d25:	53                   	push   %ebx
    ebp = (uint*)v - 2;
80104d26:	8b 45 08             	mov    0x8(%ebp),%eax
void getcallerpcs(void *v, uint pcs[]) {
80104d29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    ebp = (uint*)v - 2;
80104d2c:	83 e8 08             	sub    $0x8,%eax
80104d2f:	90                   	nop
        if (ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff) {
80104d30:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104d36:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104d3c:	77 1a                	ja     80104d58 <getcallerpcs+0x38>
            break;
        }
        pcs[i] = ebp[1];     // saved %eip
80104d3e:	8b 58 04             	mov    0x4(%eax),%ebx
80104d41:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    for (i = 0; i < 10; i++) {
80104d44:	83 c2 01             	add    $0x1,%edx
        ebp = (uint*)ebp[0]; // saved %ebp
80104d47:	8b 00                	mov    (%eax),%eax
    for (i = 0; i < 10; i++) {
80104d49:	83 fa 0a             	cmp    $0xa,%edx
80104d4c:	75 e2                	jne    80104d30 <getcallerpcs+0x10>
    }
    for (; i < 10; i++) {
        pcs[i] = 0;
    }
}
80104d4e:	5b                   	pop    %ebx
80104d4f:	5d                   	pop    %ebp
80104d50:	c3                   	ret    
80104d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d58:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104d5b:	83 c1 28             	add    $0x28,%ecx
80104d5e:	66 90                	xchg   %ax,%ax
        pcs[i] = 0;
80104d60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104d66:	83 c0 04             	add    $0x4,%eax
    for (; i < 10; i++) {
80104d69:	39 c1                	cmp    %eax,%ecx
80104d6b:	75 f3                	jne    80104d60 <getcallerpcs+0x40>
}
80104d6d:	5b                   	pop    %ebx
80104d6e:	5d                   	pop    %ebp
80104d6f:	c3                   	ret    

80104d70 <pushcli>:

// Pushcli/popcli are like cli/sti except that they are matched:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void pushcli(void)      {
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	53                   	push   %ebx
80104d74:	83 ec 04             	sub    $0x4,%esp
80104d77:	9c                   	pushf  
80104d78:	5b                   	pop    %ebx
    asm volatile ("cli");
80104d79:	fa                   	cli    
    int eflags;

    eflags = readeflags();
    cli();
    if (mycpu()->ncli == 0) {
80104d7a:	e8 c1 f4 ff ff       	call   80104240 <mycpu>
80104d7f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d85:	85 c0                	test   %eax,%eax
80104d87:	75 11                	jne    80104d9a <pushcli+0x2a>
        mycpu()->intena = eflags & FL_IF;
80104d89:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104d8f:	e8 ac f4 ff ff       	call   80104240 <mycpu>
80104d94:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
    }
    mycpu()->ncli += 1;
80104d9a:	e8 a1 f4 ff ff       	call   80104240 <mycpu>
80104d9f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104da6:	83 c4 04             	add    $0x4,%esp
80104da9:	5b                   	pop    %ebx
80104daa:	5d                   	pop    %ebp
80104dab:	c3                   	ret    
80104dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104db0 <popcli>:

void popcli(void)      {
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	83 ec 08             	sub    $0x8,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
80104db6:	9c                   	pushf  
80104db7:	58                   	pop    %eax
    if (readeflags() & FL_IF) {
80104db8:	f6 c4 02             	test   $0x2,%ah
80104dbb:	75 35                	jne    80104df2 <popcli+0x42>
        panic("popcli - interruptible");
    }
    if (--mycpu()->ncli < 0) {
80104dbd:	e8 7e f4 ff ff       	call   80104240 <mycpu>
80104dc2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104dc9:	78 34                	js     80104dff <popcli+0x4f>
        panic("popcli");
    }
    if (mycpu()->ncli == 0 && mycpu()->intena) {
80104dcb:	e8 70 f4 ff ff       	call   80104240 <mycpu>
80104dd0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104dd6:	85 d2                	test   %edx,%edx
80104dd8:	74 06                	je     80104de0 <popcli+0x30>
        sti();
    }
}
80104dda:	c9                   	leave  
80104ddb:	c3                   	ret    
80104ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (mycpu()->ncli == 0 && mycpu()->intena) {
80104de0:	e8 5b f4 ff ff       	call   80104240 <mycpu>
80104de5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104deb:	85 c0                	test   %eax,%eax
80104ded:	74 eb                	je     80104dda <popcli+0x2a>
    asm volatile ("sti");
80104def:	fb                   	sti    
}
80104df0:	c9                   	leave  
80104df1:	c3                   	ret    
        panic("popcli - interruptible");
80104df2:	83 ec 0c             	sub    $0xc,%esp
80104df5:	68 e3 81 10 80       	push   $0x801081e3
80104dfa:	e8 e1 b6 ff ff       	call   801004e0 <panic>
        panic("popcli");
80104dff:	83 ec 0c             	sub    $0xc,%esp
80104e02:	68 fa 81 10 80       	push   $0x801081fa
80104e07:	e8 d4 b6 ff ff       	call   801004e0 <panic>
80104e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e10 <holding>:
int holding(struct spinlock *lock) {
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	56                   	push   %esi
80104e14:	53                   	push   %ebx
80104e15:	8b 75 08             	mov    0x8(%ebp),%esi
80104e18:	31 db                	xor    %ebx,%ebx
    pushcli();
80104e1a:	e8 51 ff ff ff       	call   80104d70 <pushcli>
    r = lock->locked && lock->cpu == mycpu();
80104e1f:	8b 06                	mov    (%esi),%eax
80104e21:	85 c0                	test   %eax,%eax
80104e23:	74 10                	je     80104e35 <holding+0x25>
80104e25:	8b 5e 08             	mov    0x8(%esi),%ebx
80104e28:	e8 13 f4 ff ff       	call   80104240 <mycpu>
80104e2d:	39 c3                	cmp    %eax,%ebx
80104e2f:	0f 94 c3             	sete   %bl
80104e32:	0f b6 db             	movzbl %bl,%ebx
    popcli();
80104e35:	e8 76 ff ff ff       	call   80104db0 <popcli>
}
80104e3a:	89 d8                	mov    %ebx,%eax
80104e3c:	5b                   	pop    %ebx
80104e3d:	5e                   	pop    %esi
80104e3e:	5d                   	pop    %ebp
80104e3f:	c3                   	ret    

80104e40 <acquire>:
void acquire(struct spinlock *lk) {
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
    pushcli(); // disable interrupts to avoid deadlock.
80104e45:	e8 26 ff ff ff       	call   80104d70 <pushcli>
    if (holding(lk)) {
80104e4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e4d:	83 ec 0c             	sub    $0xc,%esp
80104e50:	53                   	push   %ebx
80104e51:	e8 ba ff ff ff       	call   80104e10 <holding>
80104e56:	83 c4 10             	add    $0x10,%esp
80104e59:	85 c0                	test   %eax,%eax
80104e5b:	0f 85 83 00 00 00    	jne    80104ee4 <acquire+0xa4>
80104e61:	89 c6                	mov    %eax,%esi
    asm volatile ("lock; xchgl %0, %1" :
80104e63:	ba 01 00 00 00       	mov    $0x1,%edx
80104e68:	eb 09                	jmp    80104e73 <acquire+0x33>
80104e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e70:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e73:	89 d0                	mov    %edx,%eax
80104e75:	f0 87 03             	lock xchg %eax,(%ebx)
    while (xchg(&lk->locked, 1) != 0) {
80104e78:	85 c0                	test   %eax,%eax
80104e7a:	75 f4                	jne    80104e70 <acquire+0x30>
    __sync_synchronize();
80104e7c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    lk->cpu = mycpu();
80104e81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e84:	e8 b7 f3 ff ff       	call   80104240 <mycpu>
    getcallerpcs(&lk, lk->pcs);
80104e89:	8d 53 0c             	lea    0xc(%ebx),%edx
    lk->cpu = mycpu();
80104e8c:	89 43 08             	mov    %eax,0x8(%ebx)
    ebp = (uint*)v - 2;
80104e8f:	89 e8                	mov    %ebp,%eax
80104e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff) {
80104e98:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104e9e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104ea4:	77 1a                	ja     80104ec0 <acquire+0x80>
        pcs[i] = ebp[1];     // saved %eip
80104ea6:	8b 48 04             	mov    0x4(%eax),%ecx
80104ea9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
    for (i = 0; i < 10; i++) {
80104eac:	83 c6 01             	add    $0x1,%esi
        ebp = (uint*)ebp[0]; // saved %ebp
80104eaf:	8b 00                	mov    (%eax),%eax
    for (i = 0; i < 10; i++) {
80104eb1:	83 fe 0a             	cmp    $0xa,%esi
80104eb4:	75 e2                	jne    80104e98 <acquire+0x58>
}
80104eb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eb9:	5b                   	pop    %ebx
80104eba:	5e                   	pop    %esi
80104ebb:	5d                   	pop    %ebp
80104ebc:	c3                   	ret    
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi
80104ec0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104ec3:	83 c2 28             	add    $0x28,%edx
80104ec6:	8d 76 00             	lea    0x0(%esi),%esi
80104ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        pcs[i] = 0;
80104ed0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ed6:	83 c0 04             	add    $0x4,%eax
    for (; i < 10; i++) {
80104ed9:	39 d0                	cmp    %edx,%eax
80104edb:	75 f3                	jne    80104ed0 <acquire+0x90>
}
80104edd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ee0:	5b                   	pop    %ebx
80104ee1:	5e                   	pop    %esi
80104ee2:	5d                   	pop    %ebp
80104ee3:	c3                   	ret    
        panic("acquire");
80104ee4:	83 ec 0c             	sub    $0xc,%esp
80104ee7:	68 01 82 10 80       	push   $0x80108201
80104eec:	e8 ef b5 ff ff       	call   801004e0 <panic>
80104ef1:	eb 0d                	jmp    80104f00 <release>
80104ef3:	90                   	nop
80104ef4:	90                   	nop
80104ef5:	90                   	nop
80104ef6:	90                   	nop
80104ef7:	90                   	nop
80104ef8:	90                   	nop
80104ef9:	90                   	nop
80104efa:	90                   	nop
80104efb:	90                   	nop
80104efc:	90                   	nop
80104efd:	90                   	nop
80104efe:	90                   	nop
80104eff:	90                   	nop

80104f00 <release>:
void release(struct spinlock *lk) {
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	53                   	push   %ebx
80104f04:	83 ec 10             	sub    $0x10,%esp
80104f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (!holding(lk)) {
80104f0a:	53                   	push   %ebx
80104f0b:	e8 00 ff ff ff       	call   80104e10 <holding>
80104f10:	83 c4 10             	add    $0x10,%esp
80104f13:	85 c0                	test   %eax,%eax
80104f15:	74 22                	je     80104f39 <release+0x39>
    lk->pcs[0] = 0;
80104f17:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    lk->cpu = 0;
80104f1e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    __sync_synchronize();
80104f25:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    asm volatile ("movl $0, %0" : "+m" (lk->locked) :);
80104f2a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104f30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f33:	c9                   	leave  
    popcli();
80104f34:	e9 77 fe ff ff       	jmp    80104db0 <popcli>
        panic("release");
80104f39:	83 ec 0c             	sub    $0xc,%esp
80104f3c:	68 09 82 10 80       	push   $0x80108209
80104f41:	e8 9a b5 ff ff       	call   801004e0 <panic>
80104f46:	66 90                	xchg   %ax,%ax
80104f48:	66 90                	xchg   %ax,%ax
80104f4a:	66 90                	xchg   %ax,%ax
80104f4c:	66 90                	xchg   %ax,%ax
80104f4e:	66 90                	xchg   %ax,%ax

80104f50 <memset>:
#include "types.h"
#include "x86.h"

void* memset(void *dst, int c, uint n) {
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	57                   	push   %edi
80104f54:	53                   	push   %ebx
80104f55:	8b 55 08             	mov    0x8(%ebp),%edx
80104f58:	8b 4d 10             	mov    0x10(%ebp),%ecx
    if ((int)dst % 4 == 0 && n % 4 == 0) {
80104f5b:	f6 c2 03             	test   $0x3,%dl
80104f5e:	75 05                	jne    80104f65 <memset+0x15>
80104f60:	f6 c1 03             	test   $0x3,%cl
80104f63:	74 13                	je     80104f78 <memset+0x28>
    asm volatile ("cld; rep stosb" :
80104f65:	89 d7                	mov    %edx,%edi
80104f67:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f6a:	fc                   	cld    
80104f6b:	f3 aa                	rep stos %al,%es:(%edi)
    }
    else {
        stosb(dst, c, n);
    }
    return dst;
}
80104f6d:	5b                   	pop    %ebx
80104f6e:	89 d0                	mov    %edx,%eax
80104f70:	5f                   	pop    %edi
80104f71:	5d                   	pop    %ebp
80104f72:	c3                   	ret    
80104f73:	90                   	nop
80104f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        c &= 0xFF;
80104f78:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
        stosl(dst, (c << 24) | (c << 16) | (c << 8) | c, n / 4);
80104f7c:	c1 e9 02             	shr    $0x2,%ecx
80104f7f:	89 f8                	mov    %edi,%eax
80104f81:	89 fb                	mov    %edi,%ebx
80104f83:	c1 e0 18             	shl    $0x18,%eax
80104f86:	c1 e3 10             	shl    $0x10,%ebx
80104f89:	09 d8                	or     %ebx,%eax
80104f8b:	09 f8                	or     %edi,%eax
80104f8d:	c1 e7 08             	shl    $0x8,%edi
80104f90:	09 f8                	or     %edi,%eax
    asm volatile ("cld; rep stosl" :
80104f92:	89 d7                	mov    %edx,%edi
80104f94:	fc                   	cld    
80104f95:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104f97:	5b                   	pop    %ebx
80104f98:	89 d0                	mov    %edx,%eax
80104f9a:	5f                   	pop    %edi
80104f9b:	5d                   	pop    %ebp
80104f9c:	c3                   	ret    
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi

80104fa0 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n) {
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	57                   	push   %edi
80104fa4:	56                   	push   %esi
80104fa5:	53                   	push   %ebx
80104fa6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104fa9:	8b 75 08             	mov    0x8(%ebp),%esi
80104fac:	8b 7d 0c             	mov    0xc(%ebp),%edi
    const uchar *s1, *s2;

    s1 = v1;
    s2 = v2;
    while (n-- > 0) {
80104faf:	85 db                	test   %ebx,%ebx
80104fb1:	74 29                	je     80104fdc <memcmp+0x3c>
        if (*s1 != *s2) {
80104fb3:	0f b6 16             	movzbl (%esi),%edx
80104fb6:	0f b6 0f             	movzbl (%edi),%ecx
80104fb9:	38 d1                	cmp    %dl,%cl
80104fbb:	75 2b                	jne    80104fe8 <memcmp+0x48>
80104fbd:	b8 01 00 00 00       	mov    $0x1,%eax
80104fc2:	eb 14                	jmp    80104fd8 <memcmp+0x38>
80104fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fc8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104fcc:	83 c0 01             	add    $0x1,%eax
80104fcf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104fd4:	38 ca                	cmp    %cl,%dl
80104fd6:	75 10                	jne    80104fe8 <memcmp+0x48>
    while (n-- > 0) {
80104fd8:	39 d8                	cmp    %ebx,%eax
80104fda:	75 ec                	jne    80104fc8 <memcmp+0x28>
        }
        s1++, s2++;
    }

    return 0;
}
80104fdc:	5b                   	pop    %ebx
    return 0;
80104fdd:	31 c0                	xor    %eax,%eax
}
80104fdf:	5e                   	pop    %esi
80104fe0:	5f                   	pop    %edi
80104fe1:	5d                   	pop    %ebp
80104fe2:	c3                   	ret    
80104fe3:	90                   	nop
80104fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            return *s1 - *s2;
80104fe8:	0f b6 c2             	movzbl %dl,%eax
}
80104feb:	5b                   	pop    %ebx
            return *s1 - *s2;
80104fec:	29 c8                	sub    %ecx,%eax
}
80104fee:	5e                   	pop    %esi
80104fef:	5f                   	pop    %edi
80104ff0:	5d                   	pop    %ebp
80104ff1:	c3                   	ret    
80104ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105000 <memmove>:

void* memmove(void *dst, const void *src, uint n) {
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	56                   	push   %esi
80105004:	53                   	push   %ebx
80105005:	8b 45 08             	mov    0x8(%ebp),%eax
80105008:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010500b:	8b 75 10             	mov    0x10(%ebp),%esi
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
8010500e:	39 c3                	cmp    %eax,%ebx
80105010:	73 26                	jae    80105038 <memmove+0x38>
80105012:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105015:	39 c8                	cmp    %ecx,%eax
80105017:	73 1f                	jae    80105038 <memmove+0x38>
        s += n;
        d += n;
        while (n-- > 0) {
80105019:	85 f6                	test   %esi,%esi
8010501b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010501e:	74 0f                	je     8010502f <memmove+0x2f>
            *--d = *--s;
80105020:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105024:	88 0c 10             	mov    %cl,(%eax,%edx,1)
        while (n-- > 0) {
80105027:	83 ea 01             	sub    $0x1,%edx
8010502a:	83 fa ff             	cmp    $0xffffffff,%edx
8010502d:	75 f1                	jne    80105020 <memmove+0x20>
            *d++ = *s++;
        }
    }

    return dst;
}
8010502f:	5b                   	pop    %ebx
80105030:	5e                   	pop    %esi
80105031:	5d                   	pop    %ebp
80105032:	c3                   	ret    
80105033:	90                   	nop
80105034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        while (n-- > 0) {
80105038:	31 d2                	xor    %edx,%edx
8010503a:	85 f6                	test   %esi,%esi
8010503c:	74 f1                	je     8010502f <memmove+0x2f>
8010503e:	66 90                	xchg   %ax,%ax
            *d++ = *s++;
80105040:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105044:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105047:	83 c2 01             	add    $0x1,%edx
        while (n-- > 0) {
8010504a:	39 d6                	cmp    %edx,%esi
8010504c:	75 f2                	jne    80105040 <memmove+0x40>
}
8010504e:	5b                   	pop    %ebx
8010504f:	5e                   	pop    %esi
80105050:	5d                   	pop    %ebp
80105051:	c3                   	ret    
80105052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105060 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void* memcpy(void *dst, const void *src, uint n) {
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
    return memmove(dst, src, n);
}
80105063:	5d                   	pop    %ebp
    return memmove(dst, src, n);
80105064:	eb 9a                	jmp    80105000 <memmove>
80105066:	8d 76 00             	lea    0x0(%esi),%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105070 <strncmp>:

int strncmp(const char *p, const char *q, uint n) {
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	57                   	push   %edi
80105074:	56                   	push   %esi
80105075:	8b 7d 10             	mov    0x10(%ebp),%edi
80105078:	53                   	push   %ebx
80105079:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010507c:	8b 75 0c             	mov    0xc(%ebp),%esi
    while (n > 0 && *p && *p == *q) {
8010507f:	85 ff                	test   %edi,%edi
80105081:	74 2f                	je     801050b2 <strncmp+0x42>
80105083:	0f b6 01             	movzbl (%ecx),%eax
80105086:	0f b6 1e             	movzbl (%esi),%ebx
80105089:	84 c0                	test   %al,%al
8010508b:	74 37                	je     801050c4 <strncmp+0x54>
8010508d:	38 c3                	cmp    %al,%bl
8010508f:	75 33                	jne    801050c4 <strncmp+0x54>
80105091:	01 f7                	add    %esi,%edi
80105093:	eb 13                	jmp    801050a8 <strncmp+0x38>
80105095:	8d 76 00             	lea    0x0(%esi),%esi
80105098:	0f b6 01             	movzbl (%ecx),%eax
8010509b:	84 c0                	test   %al,%al
8010509d:	74 21                	je     801050c0 <strncmp+0x50>
8010509f:	0f b6 1a             	movzbl (%edx),%ebx
801050a2:	89 d6                	mov    %edx,%esi
801050a4:	38 d8                	cmp    %bl,%al
801050a6:	75 1c                	jne    801050c4 <strncmp+0x54>
        n--, p++, q++;
801050a8:	8d 56 01             	lea    0x1(%esi),%edx
801050ab:	83 c1 01             	add    $0x1,%ecx
    while (n > 0 && *p && *p == *q) {
801050ae:	39 fa                	cmp    %edi,%edx
801050b0:	75 e6                	jne    80105098 <strncmp+0x28>
    }
    if (n == 0) {
        return 0;
    }
    return (uchar) * p - (uchar) * q;
}
801050b2:	5b                   	pop    %ebx
        return 0;
801050b3:	31 c0                	xor    %eax,%eax
}
801050b5:	5e                   	pop    %esi
801050b6:	5f                   	pop    %edi
801050b7:	5d                   	pop    %ebp
801050b8:	c3                   	ret    
801050b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050c0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
    return (uchar) * p - (uchar) * q;
801050c4:	29 d8                	sub    %ebx,%eax
}
801050c6:	5b                   	pop    %ebx
801050c7:	5e                   	pop    %esi
801050c8:	5f                   	pop    %edi
801050c9:	5d                   	pop    %ebp
801050ca:	c3                   	ret    
801050cb:	90                   	nop
801050cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050d0 <strncpy>:

char* strncpy(char *s, const char *t, int n) {
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	56                   	push   %esi
801050d4:	53                   	push   %ebx
801050d5:	8b 45 08             	mov    0x8(%ebp),%eax
801050d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801050db:	8b 4d 10             	mov    0x10(%ebp),%ecx
    char *os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0) {
801050de:	89 c2                	mov    %eax,%edx
801050e0:	eb 19                	jmp    801050fb <strncpy+0x2b>
801050e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050e8:	83 c3 01             	add    $0x1,%ebx
801050eb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801050ef:	83 c2 01             	add    $0x1,%edx
801050f2:	84 c9                	test   %cl,%cl
801050f4:	88 4a ff             	mov    %cl,-0x1(%edx)
801050f7:	74 09                	je     80105102 <strncpy+0x32>
801050f9:	89 f1                	mov    %esi,%ecx
801050fb:	85 c9                	test   %ecx,%ecx
801050fd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105100:	7f e6                	jg     801050e8 <strncpy+0x18>
        ;
    }
    while (n-- > 0) {
80105102:	31 c9                	xor    %ecx,%ecx
80105104:	85 f6                	test   %esi,%esi
80105106:	7e 17                	jle    8010511f <strncpy+0x4f>
80105108:	90                   	nop
80105109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        *s++ = 0;
80105110:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105114:	89 f3                	mov    %esi,%ebx
80105116:	83 c1 01             	add    $0x1,%ecx
80105119:	29 cb                	sub    %ecx,%ebx
    while (n-- > 0) {
8010511b:	85 db                	test   %ebx,%ebx
8010511d:	7f f1                	jg     80105110 <strncpy+0x40>
    }
    return os;
}
8010511f:	5b                   	pop    %ebx
80105120:	5e                   	pop    %esi
80105121:	5d                   	pop    %ebp
80105122:	c3                   	ret    
80105123:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105130 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char* safestrcpy(char *s, const char *t, int n) {
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	56                   	push   %esi
80105134:	53                   	push   %ebx
80105135:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105138:	8b 45 08             	mov    0x8(%ebp),%eax
8010513b:	8b 55 0c             	mov    0xc(%ebp),%edx
    char *os;

    os = s;
    if (n <= 0) {
8010513e:	85 c9                	test   %ecx,%ecx
80105140:	7e 26                	jle    80105168 <safestrcpy+0x38>
80105142:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105146:	89 c1                	mov    %eax,%ecx
80105148:	eb 17                	jmp    80105161 <safestrcpy+0x31>
8010514a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return os;
    }
    while (--n > 0 && (*s++ = *t++) != 0) {
80105150:	83 c2 01             	add    $0x1,%edx
80105153:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105157:	83 c1 01             	add    $0x1,%ecx
8010515a:	84 db                	test   %bl,%bl
8010515c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010515f:	74 04                	je     80105165 <safestrcpy+0x35>
80105161:	39 f2                	cmp    %esi,%edx
80105163:	75 eb                	jne    80105150 <safestrcpy+0x20>
        ;
    }
    *s = 0;
80105165:	c6 01 00             	movb   $0x0,(%ecx)
    return os;
}
80105168:	5b                   	pop    %ebx
80105169:	5e                   	pop    %esi
8010516a:	5d                   	pop    %ebp
8010516b:	c3                   	ret    
8010516c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105170 <strlen>:

int strlen(const char *s) {
80105170:	55                   	push   %ebp
    int n;

    for (n = 0; s[n]; n++) {
80105171:	31 c0                	xor    %eax,%eax
int strlen(const char *s) {
80105173:	89 e5                	mov    %esp,%ebp
80105175:	8b 55 08             	mov    0x8(%ebp),%edx
    for (n = 0; s[n]; n++) {
80105178:	80 3a 00             	cmpb   $0x0,(%edx)
8010517b:	74 0c                	je     80105189 <strlen+0x19>
8010517d:	8d 76 00             	lea    0x0(%esi),%esi
80105180:	83 c0 01             	add    $0x1,%eax
80105183:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105187:	75 f7                	jne    80105180 <strlen+0x10>
        ;
    }
    return n;
}
80105189:	5d                   	pop    %ebp
8010518a:	c3                   	ret    

8010518b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
    movl 4(%esp), %eax
8010518b:	8b 44 24 04          	mov    0x4(%esp),%eax
    movl 8(%esp), %edx
8010518f:	8b 54 24 08          	mov    0x8(%esp),%edx

    # Save old callee-saved registers
    pushl %ebp
80105193:	55                   	push   %ebp
    pushl %ebx
80105194:	53                   	push   %ebx
    pushl %esi
80105195:	56                   	push   %esi
    pushl %edi
80105196:	57                   	push   %edi

    # Switch stacks
    movl %esp, (%eax)
80105197:	89 20                	mov    %esp,(%eax)
    movl %edx, %esp
80105199:	89 d4                	mov    %edx,%esp

    # Load new callee-saved registers
    popl %edi
8010519b:	5f                   	pop    %edi
    popl %esi
8010519c:	5e                   	pop    %esi
    popl %ebx
8010519d:	5b                   	pop    %ebx
    popl %ebp
8010519e:	5d                   	pop    %ebp
    ret
8010519f:	c3                   	ret    

801051a0 <fetchint>:
// Arguments on the stack, from the user call to the C
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int fetchint(uint addr, int *ip)  {
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	53                   	push   %ebx
801051a4:	83 ec 04             	sub    $0x4,%esp
801051a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *curproc = myproc();
801051aa:	e8 31 f1 ff ff       	call   801042e0 <myproc>

    if (addr >= curproc->sz || addr + 4 > curproc->sz) {
801051af:	8b 00                	mov    (%eax),%eax
801051b1:	39 d8                	cmp    %ebx,%eax
801051b3:	76 1b                	jbe    801051d0 <fetchint+0x30>
801051b5:	8d 53 04             	lea    0x4(%ebx),%edx
801051b8:	39 d0                	cmp    %edx,%eax
801051ba:	72 14                	jb     801051d0 <fetchint+0x30>
        return -1;
    }
    *ip = *(int*)(addr);
801051bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801051bf:	8b 13                	mov    (%ebx),%edx
801051c1:	89 10                	mov    %edx,(%eax)
    return 0;
801051c3:	31 c0                	xor    %eax,%eax
}
801051c5:	83 c4 04             	add    $0x4,%esp
801051c8:	5b                   	pop    %ebx
801051c9:	5d                   	pop    %ebp
801051ca:	c3                   	ret    
801051cb:	90                   	nop
801051cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801051d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051d5:	eb ee                	jmp    801051c5 <fetchint+0x25>
801051d7:	89 f6                	mov    %esi,%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051e0 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int fetchstr(uint addr, char **pp) {
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	53                   	push   %ebx
801051e4:	83 ec 04             	sub    $0x4,%esp
801051e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    char *s, *ep;
    struct proc *curproc = myproc();
801051ea:	e8 f1 f0 ff ff       	call   801042e0 <myproc>

    if (addr >= curproc->sz) {
801051ef:	39 18                	cmp    %ebx,(%eax)
801051f1:	76 29                	jbe    8010521c <fetchstr+0x3c>
        return -1;
    }
    *pp = (char*)addr;
801051f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801051f6:	89 da                	mov    %ebx,%edx
801051f8:	89 19                	mov    %ebx,(%ecx)
    ep = (char*)curproc->sz;
801051fa:	8b 00                	mov    (%eax),%eax
    for (s = *pp; s < ep; s++) {
801051fc:	39 c3                	cmp    %eax,%ebx
801051fe:	73 1c                	jae    8010521c <fetchstr+0x3c>
        if (*s == 0) {
80105200:	80 3b 00             	cmpb   $0x0,(%ebx)
80105203:	75 10                	jne    80105215 <fetchstr+0x35>
80105205:	eb 39                	jmp    80105240 <fetchstr+0x60>
80105207:	89 f6                	mov    %esi,%esi
80105209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105210:	80 3a 00             	cmpb   $0x0,(%edx)
80105213:	74 1b                	je     80105230 <fetchstr+0x50>
    for (s = *pp; s < ep; s++) {
80105215:	83 c2 01             	add    $0x1,%edx
80105218:	39 d0                	cmp    %edx,%eax
8010521a:	77 f4                	ja     80105210 <fetchstr+0x30>
        return -1;
8010521c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            return s - *pp;
        }
    }
    return -1;
}
80105221:	83 c4 04             	add    $0x4,%esp
80105224:	5b                   	pop    %ebx
80105225:	5d                   	pop    %ebp
80105226:	c3                   	ret    
80105227:	89 f6                	mov    %esi,%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105230:	83 c4 04             	add    $0x4,%esp
80105233:	89 d0                	mov    %edx,%eax
80105235:	29 d8                	sub    %ebx,%eax
80105237:	5b                   	pop    %ebx
80105238:	5d                   	pop    %ebp
80105239:	c3                   	ret    
8010523a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (*s == 0) {
80105240:	31 c0                	xor    %eax,%eax
            return s - *pp;
80105242:	eb dd                	jmp    80105221 <fetchstr+0x41>
80105244:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010524a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105250 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip) {
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	56                   	push   %esi
80105254:	53                   	push   %ebx
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80105255:	e8 86 f0 ff ff       	call   801042e0 <myproc>
8010525a:	8b 40 18             	mov    0x18(%eax),%eax
8010525d:	8b 55 08             	mov    0x8(%ebp),%edx
80105260:	8b 40 44             	mov    0x44(%eax),%eax
80105263:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    struct proc *curproc = myproc();
80105266:	e8 75 f0 ff ff       	call   801042e0 <myproc>
    if (addr >= curproc->sz || addr + 4 > curproc->sz) {
8010526b:	8b 00                	mov    (%eax),%eax
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
8010526d:	8d 73 04             	lea    0x4(%ebx),%esi
    if (addr >= curproc->sz || addr + 4 > curproc->sz) {
80105270:	39 c6                	cmp    %eax,%esi
80105272:	73 1c                	jae    80105290 <argint+0x40>
80105274:	8d 53 08             	lea    0x8(%ebx),%edx
80105277:	39 d0                	cmp    %edx,%eax
80105279:	72 15                	jb     80105290 <argint+0x40>
    *ip = *(int*)(addr);
8010527b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010527e:	8b 53 04             	mov    0x4(%ebx),%edx
80105281:	89 10                	mov    %edx,(%eax)
    return 0;
80105283:	31 c0                	xor    %eax,%eax
}
80105285:	5b                   	pop    %ebx
80105286:	5e                   	pop    %esi
80105287:	5d                   	pop    %ebp
80105288:	c3                   	ret    
80105289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80105295:	eb ee                	jmp    80105285 <argint+0x35>
80105297:	89 f6                	mov    %esi,%esi
80105299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052a0 <argptr>:

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int argptr(int n, char **pp, int size) {
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	56                   	push   %esi
801052a4:	53                   	push   %ebx
801052a5:	83 ec 10             	sub    $0x10,%esp
801052a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
    int i;
    struct proc *curproc = myproc();
801052ab:	e8 30 f0 ff ff       	call   801042e0 <myproc>
801052b0:	89 c6                	mov    %eax,%esi

    if (argint(n, &i) < 0) {
801052b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052b5:	83 ec 08             	sub    $0x8,%esp
801052b8:	50                   	push   %eax
801052b9:	ff 75 08             	pushl  0x8(%ebp)
801052bc:	e8 8f ff ff ff       	call   80105250 <argint>
        return -1;
    }
    if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz) {
801052c1:	83 c4 10             	add    $0x10,%esp
801052c4:	85 c0                	test   %eax,%eax
801052c6:	78 28                	js     801052f0 <argptr+0x50>
801052c8:	85 db                	test   %ebx,%ebx
801052ca:	78 24                	js     801052f0 <argptr+0x50>
801052cc:	8b 16                	mov    (%esi),%edx
801052ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052d1:	39 c2                	cmp    %eax,%edx
801052d3:	76 1b                	jbe    801052f0 <argptr+0x50>
801052d5:	01 c3                	add    %eax,%ebx
801052d7:	39 da                	cmp    %ebx,%edx
801052d9:	72 15                	jb     801052f0 <argptr+0x50>
        return -1;
    }
    *pp = (char*)i;
801052db:	8b 55 0c             	mov    0xc(%ebp),%edx
801052de:	89 02                	mov    %eax,(%edx)
    return 0;
801052e0:	31 c0                	xor    %eax,%eax
}
801052e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052e5:	5b                   	pop    %ebx
801052e6:	5e                   	pop    %esi
801052e7:	5d                   	pop    %ebp
801052e8:	c3                   	ret    
801052e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801052f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052f5:	eb eb                	jmp    801052e2 <argptr+0x42>
801052f7:	89 f6                	mov    %esi,%esi
801052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105300 <argstr>:

// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int argstr(int n, char **pp) {
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	83 ec 20             	sub    $0x20,%esp
    int addr;
    if (argint(n, &addr) < 0) {
80105306:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105309:	50                   	push   %eax
8010530a:	ff 75 08             	pushl  0x8(%ebp)
8010530d:	e8 3e ff ff ff       	call   80105250 <argint>
80105312:	83 c4 10             	add    $0x10,%esp
80105315:	85 c0                	test   %eax,%eax
80105317:	78 17                	js     80105330 <argstr+0x30>
        return -1;
    }
    return fetchstr(addr, pp);
80105319:	83 ec 08             	sub    $0x8,%esp
8010531c:	ff 75 0c             	pushl  0xc(%ebp)
8010531f:	ff 75 f4             	pushl  -0xc(%ebp)
80105322:	e8 b9 fe ff ff       	call   801051e0 <fetchstr>
80105327:	83 c4 10             	add    $0x10,%esp
}
8010532a:	c9                   	leave  
8010532b:	c3                   	ret    
8010532c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105335:	c9                   	leave  
80105336:	c3                   	ret    
80105337:	89 f6                	mov    %esi,%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105340 <syscall>:
    [SYS_clearscreen12h] sys_clearscreen12h,
    [SYS_videomodevga13] sys_videomodevga13,
    // TODO: Add your system call function to the OS syscall table.
};

void syscall(void) {
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	53                   	push   %ebx
80105344:	83 ec 04             	sub    $0x4,%esp
    int num;
    struct proc *curproc = myproc();
80105347:	e8 94 ef ff ff       	call   801042e0 <myproc>
8010534c:	89 c3                	mov    %eax,%ebx

    num = curproc->tf->eax;
8010534e:	8b 40 18             	mov    0x18(%eax),%eax
80105351:	8b 40 1c             	mov    0x1c(%eax),%eax
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105354:	8d 50 ff             	lea    -0x1(%eax),%edx
80105357:	83 fa 1c             	cmp    $0x1c,%edx
8010535a:	77 1c                	ja     80105378 <syscall+0x38>
8010535c:	8b 14 85 40 82 10 80 	mov    -0x7fef7dc0(,%eax,4),%edx
80105363:	85 d2                	test   %edx,%edx
80105365:	74 11                	je     80105378 <syscall+0x38>
        curproc->tf->eax = syscalls[num]();
80105367:	ff d2                	call   *%edx
80105369:	8b 53 18             	mov    0x18(%ebx),%edx
8010536c:	89 42 1c             	mov    %eax,0x1c(%edx)
    else {
        cprintf("%d %s: unknown sys call %d\n",
                curproc->pid, curproc->name, num);
        curproc->tf->eax = -1;
    }
}
8010536f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105372:	c9                   	leave  
80105373:	c3                   	ret    
80105374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf("%d %s: unknown sys call %d\n",
80105378:	50                   	push   %eax
                curproc->pid, curproc->name, num);
80105379:	8d 43 6c             	lea    0x6c(%ebx),%eax
        cprintf("%d %s: unknown sys call %d\n",
8010537c:	50                   	push   %eax
8010537d:	ff 73 10             	pushl  0x10(%ebx)
80105380:	68 11 82 10 80       	push   $0x80108211
80105385:	e8 d6 b4 ff ff       	call   80100860 <cprintf>
        curproc->tf->eax = -1;
8010538a:	8b 43 18             	mov    0x18(%ebx),%eax
8010538d:	83 c4 10             	add    $0x10,%esp
80105390:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010539a:	c9                   	leave  
8010539b:	c3                   	ret    
8010539c:	66 90                	xchg   %ax,%ax
8010539e:	66 90                	xchg   %ax,%ax

801053a0 <create>:
    end_op();

    return 0;
}

static struct inode* create(char *path, short type, short major, short minor)  {
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	57                   	push   %edi
801053a4:	56                   	push   %esi
801053a5:	53                   	push   %ebx
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0) {
801053a6:	8d 75 da             	lea    -0x26(%ebp),%esi
static struct inode* create(char *path, short type, short major, short minor)  {
801053a9:	83 ec 34             	sub    $0x34,%esp
801053ac:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801053af:	8b 4d 08             	mov    0x8(%ebp),%ecx
    if ((dp = nameiparent(path, name)) == 0) {
801053b2:	56                   	push   %esi
801053b3:	50                   	push   %eax
static struct inode* create(char *path, short type, short major, short minor)  {
801053b4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801053b7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
    if ((dp = nameiparent(path, name)) == 0) {
801053ba:	e8 11 d6 ff ff       	call   801029d0 <nameiparent>
801053bf:	83 c4 10             	add    $0x10,%esp
801053c2:	85 c0                	test   %eax,%eax
801053c4:	0f 84 46 01 00 00    	je     80105510 <create+0x170>
        return 0;
    }
    ilock(dp);
801053ca:	83 ec 0c             	sub    $0xc,%esp
801053cd:	89 c3                	mov    %eax,%ebx
801053cf:	50                   	push   %eax
801053d0:	e8 7b cd ff ff       	call   80102150 <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0) {
801053d5:	83 c4 0c             	add    $0xc,%esp
801053d8:	6a 00                	push   $0x0
801053da:	56                   	push   %esi
801053db:	53                   	push   %ebx
801053dc:	e8 9f d2 ff ff       	call   80102680 <dirlookup>
801053e1:	83 c4 10             	add    $0x10,%esp
801053e4:	85 c0                	test   %eax,%eax
801053e6:	89 c7                	mov    %eax,%edi
801053e8:	74 36                	je     80105420 <create+0x80>
        iunlockput(dp);
801053ea:	83 ec 0c             	sub    $0xc,%esp
801053ed:	53                   	push   %ebx
801053ee:	e8 ed cf ff ff       	call   801023e0 <iunlockput>
        ilock(ip);
801053f3:	89 3c 24             	mov    %edi,(%esp)
801053f6:	e8 55 cd ff ff       	call   80102150 <ilock>
        if (type == T_FILE && ip->type == T_FILE) {
801053fb:	83 c4 10             	add    $0x10,%esp
801053fe:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105403:	0f 85 97 00 00 00    	jne    801054a0 <create+0x100>
80105409:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010540e:	0f 85 8c 00 00 00    	jne    801054a0 <create+0x100>
    }

    iunlockput(dp);

    return ip;
}
80105414:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105417:	89 f8                	mov    %edi,%eax
80105419:	5b                   	pop    %ebx
8010541a:	5e                   	pop    %esi
8010541b:	5f                   	pop    %edi
8010541c:	5d                   	pop    %ebp
8010541d:	c3                   	ret    
8010541e:	66 90                	xchg   %ax,%ax
    if ((ip = ialloc(dp->dev, type)) == 0) {
80105420:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105424:	83 ec 08             	sub    $0x8,%esp
80105427:	50                   	push   %eax
80105428:	ff 33                	pushl  (%ebx)
8010542a:	e8 b1 cb ff ff       	call   80101fe0 <ialloc>
8010542f:	83 c4 10             	add    $0x10,%esp
80105432:	85 c0                	test   %eax,%eax
80105434:	89 c7                	mov    %eax,%edi
80105436:	0f 84 e8 00 00 00    	je     80105524 <create+0x184>
    ilock(ip);
8010543c:	83 ec 0c             	sub    $0xc,%esp
8010543f:	50                   	push   %eax
80105440:	e8 0b cd ff ff       	call   80102150 <ilock>
    ip->major = major;
80105445:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105449:	66 89 47 52          	mov    %ax,0x52(%edi)
    ip->minor = minor;
8010544d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105451:	66 89 47 54          	mov    %ax,0x54(%edi)
    ip->nlink = 1;
80105455:	b8 01 00 00 00       	mov    $0x1,%eax
8010545a:	66 89 47 56          	mov    %ax,0x56(%edi)
    iupdate(ip);
8010545e:	89 3c 24             	mov    %edi,(%esp)
80105461:	e8 3a cc ff ff       	call   801020a0 <iupdate>
    if (type == T_DIR) { // Create . and .. entries.
80105466:	83 c4 10             	add    $0x10,%esp
80105469:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010546e:	74 50                	je     801054c0 <create+0x120>
    if (dirlink(dp, name, ip->inum) < 0) {
80105470:	83 ec 04             	sub    $0x4,%esp
80105473:	ff 77 04             	pushl  0x4(%edi)
80105476:	56                   	push   %esi
80105477:	53                   	push   %ebx
80105478:	e8 73 d4 ff ff       	call   801028f0 <dirlink>
8010547d:	83 c4 10             	add    $0x10,%esp
80105480:	85 c0                	test   %eax,%eax
80105482:	0f 88 8f 00 00 00    	js     80105517 <create+0x177>
    iunlockput(dp);
80105488:	83 ec 0c             	sub    $0xc,%esp
8010548b:	53                   	push   %ebx
8010548c:	e8 4f cf ff ff       	call   801023e0 <iunlockput>
    return ip;
80105491:	83 c4 10             	add    $0x10,%esp
}
80105494:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105497:	89 f8                	mov    %edi,%eax
80105499:	5b                   	pop    %ebx
8010549a:	5e                   	pop    %esi
8010549b:	5f                   	pop    %edi
8010549c:	5d                   	pop    %ebp
8010549d:	c3                   	ret    
8010549e:	66 90                	xchg   %ax,%ax
        iunlockput(ip);
801054a0:	83 ec 0c             	sub    $0xc,%esp
801054a3:	57                   	push   %edi
        return 0;
801054a4:	31 ff                	xor    %edi,%edi
        iunlockput(ip);
801054a6:	e8 35 cf ff ff       	call   801023e0 <iunlockput>
        return 0;
801054ab:	83 c4 10             	add    $0x10,%esp
}
801054ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054b1:	89 f8                	mov    %edi,%eax
801054b3:	5b                   	pop    %ebx
801054b4:	5e                   	pop    %esi
801054b5:	5f                   	pop    %edi
801054b6:	5d                   	pop    %ebp
801054b7:	c3                   	ret    
801054b8:	90                   	nop
801054b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        dp->nlink++;  // for ".."
801054c0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
        iupdate(dp);
801054c5:	83 ec 0c             	sub    $0xc,%esp
801054c8:	53                   	push   %ebx
801054c9:	e8 d2 cb ff ff       	call   801020a0 <iupdate>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0) {
801054ce:	83 c4 0c             	add    $0xc,%esp
801054d1:	ff 77 04             	pushl  0x4(%edi)
801054d4:	68 d4 82 10 80       	push   $0x801082d4
801054d9:	57                   	push   %edi
801054da:	e8 11 d4 ff ff       	call   801028f0 <dirlink>
801054df:	83 c4 10             	add    $0x10,%esp
801054e2:	85 c0                	test   %eax,%eax
801054e4:	78 1c                	js     80105502 <create+0x162>
801054e6:	83 ec 04             	sub    $0x4,%esp
801054e9:	ff 73 04             	pushl  0x4(%ebx)
801054ec:	68 d3 82 10 80       	push   $0x801082d3
801054f1:	57                   	push   %edi
801054f2:	e8 f9 d3 ff ff       	call   801028f0 <dirlink>
801054f7:	83 c4 10             	add    $0x10,%esp
801054fa:	85 c0                	test   %eax,%eax
801054fc:	0f 89 6e ff ff ff    	jns    80105470 <create+0xd0>
            panic("create dots");
80105502:	83 ec 0c             	sub    $0xc,%esp
80105505:	68 c7 82 10 80       	push   $0x801082c7
8010550a:	e8 d1 af ff ff       	call   801004e0 <panic>
8010550f:	90                   	nop
        return 0;
80105510:	31 ff                	xor    %edi,%edi
80105512:	e9 fd fe ff ff       	jmp    80105414 <create+0x74>
        panic("create: dirlink");
80105517:	83 ec 0c             	sub    $0xc,%esp
8010551a:	68 d6 82 10 80       	push   $0x801082d6
8010551f:	e8 bc af ff ff       	call   801004e0 <panic>
        panic("create: ialloc");
80105524:	83 ec 0c             	sub    $0xc,%esp
80105527:	68 b8 82 10 80       	push   $0x801082b8
8010552c:	e8 af af ff ff       	call   801004e0 <panic>
80105531:	eb 0d                	jmp    80105540 <argfd.constprop.0>
80105533:	90                   	nop
80105534:	90                   	nop
80105535:	90                   	nop
80105536:	90                   	nop
80105537:	90                   	nop
80105538:	90                   	nop
80105539:	90                   	nop
8010553a:	90                   	nop
8010553b:	90                   	nop
8010553c:	90                   	nop
8010553d:	90                   	nop
8010553e:	90                   	nop
8010553f:	90                   	nop

80105540 <argfd.constprop.0>:
static int argfd(int n, int *pfd, struct file **pf) {
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	56                   	push   %esi
80105544:	53                   	push   %ebx
80105545:	89 c3                	mov    %eax,%ebx
    if (argint(n, &fd) < 0) {
80105547:	8d 45 f4             	lea    -0xc(%ebp),%eax
static int argfd(int n, int *pfd, struct file **pf) {
8010554a:	89 d6                	mov    %edx,%esi
8010554c:	83 ec 18             	sub    $0x18,%esp
    if (argint(n, &fd) < 0) {
8010554f:	50                   	push   %eax
80105550:	6a 00                	push   $0x0
80105552:	e8 f9 fc ff ff       	call   80105250 <argint>
80105557:	83 c4 10             	add    $0x10,%esp
8010555a:	85 c0                	test   %eax,%eax
8010555c:	78 2a                	js     80105588 <argfd.constprop.0+0x48>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) {
8010555e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105562:	77 24                	ja     80105588 <argfd.constprop.0+0x48>
80105564:	e8 77 ed ff ff       	call   801042e0 <myproc>
80105569:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010556c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105570:	85 c0                	test   %eax,%eax
80105572:	74 14                	je     80105588 <argfd.constprop.0+0x48>
    if (pfd) {
80105574:	85 db                	test   %ebx,%ebx
80105576:	74 02                	je     8010557a <argfd.constprop.0+0x3a>
        *pfd = fd;
80105578:	89 13                	mov    %edx,(%ebx)
        *pf = f;
8010557a:	89 06                	mov    %eax,(%esi)
    return 0;
8010557c:	31 c0                	xor    %eax,%eax
}
8010557e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105581:	5b                   	pop    %ebx
80105582:	5e                   	pop    %esi
80105583:	5d                   	pop    %ebp
80105584:	c3                   	ret    
80105585:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
80105588:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010558d:	eb ef                	jmp    8010557e <argfd.constprop.0+0x3e>
8010558f:	90                   	nop

80105590 <sys_dup>:
int sys_dup(void) {
80105590:	55                   	push   %ebp
    if (argfd(0, 0, &f) < 0) {
80105591:	31 c0                	xor    %eax,%eax
int sys_dup(void) {
80105593:	89 e5                	mov    %esp,%ebp
80105595:	56                   	push   %esi
80105596:	53                   	push   %ebx
    if (argfd(0, 0, &f) < 0) {
80105597:	8d 55 f4             	lea    -0xc(%ebp),%edx
int sys_dup(void) {
8010559a:	83 ec 10             	sub    $0x10,%esp
    if (argfd(0, 0, &f) < 0) {
8010559d:	e8 9e ff ff ff       	call   80105540 <argfd.constprop.0>
801055a2:	85 c0                	test   %eax,%eax
801055a4:	78 42                	js     801055e8 <sys_dup+0x58>
    if ((fd = fdalloc(f)) < 0) {
801055a6:	8b 75 f4             	mov    -0xc(%ebp),%esi
    for (fd = 0; fd < NOFILE; fd++) {
801055a9:	31 db                	xor    %ebx,%ebx
    struct proc *curproc = myproc();
801055ab:	e8 30 ed ff ff       	call   801042e0 <myproc>
801055b0:	eb 0e                	jmp    801055c0 <sys_dup+0x30>
801055b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (fd = 0; fd < NOFILE; fd++) {
801055b8:	83 c3 01             	add    $0x1,%ebx
801055bb:	83 fb 10             	cmp    $0x10,%ebx
801055be:	74 28                	je     801055e8 <sys_dup+0x58>
        if (curproc->ofile[fd] == 0) {
801055c0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055c4:	85 d2                	test   %edx,%edx
801055c6:	75 f0                	jne    801055b8 <sys_dup+0x28>
            curproc->ofile[fd] = f;
801055c8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    filedup(f);
801055cc:	83 ec 0c             	sub    $0xc,%esp
801055cf:	ff 75 f4             	pushl  -0xc(%ebp)
801055d2:	e8 e9 c2 ff ff       	call   801018c0 <filedup>
    return fd;
801055d7:	83 c4 10             	add    $0x10,%esp
}
801055da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055dd:	89 d8                	mov    %ebx,%eax
801055df:	5b                   	pop    %ebx
801055e0:	5e                   	pop    %esi
801055e1:	5d                   	pop    %ebp
801055e2:	c3                   	ret    
801055e3:	90                   	nop
801055e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return -1;
801055eb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801055f0:	89 d8                	mov    %ebx,%eax
801055f2:	5b                   	pop    %ebx
801055f3:	5e                   	pop    %esi
801055f4:	5d                   	pop    %ebp
801055f5:	c3                   	ret    
801055f6:	8d 76 00             	lea    0x0(%esi),%esi
801055f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105600 <sys_read>:
int sys_read(void) {
80105600:	55                   	push   %ebp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) {
80105601:	31 c0                	xor    %eax,%eax
int sys_read(void) {
80105603:	89 e5                	mov    %esp,%ebp
80105605:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) {
80105608:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010560b:	e8 30 ff ff ff       	call   80105540 <argfd.constprop.0>
80105610:	85 c0                	test   %eax,%eax
80105612:	78 4c                	js     80105660 <sys_read+0x60>
80105614:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105617:	83 ec 08             	sub    $0x8,%esp
8010561a:	50                   	push   %eax
8010561b:	6a 02                	push   $0x2
8010561d:	e8 2e fc ff ff       	call   80105250 <argint>
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	85 c0                	test   %eax,%eax
80105627:	78 37                	js     80105660 <sys_read+0x60>
80105629:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010562c:	83 ec 04             	sub    $0x4,%esp
8010562f:	ff 75 f0             	pushl  -0x10(%ebp)
80105632:	50                   	push   %eax
80105633:	6a 01                	push   $0x1
80105635:	e8 66 fc ff ff       	call   801052a0 <argptr>
8010563a:	83 c4 10             	add    $0x10,%esp
8010563d:	85 c0                	test   %eax,%eax
8010563f:	78 1f                	js     80105660 <sys_read+0x60>
    return fileread(f, p, n);
80105641:	83 ec 04             	sub    $0x4,%esp
80105644:	ff 75 f0             	pushl  -0x10(%ebp)
80105647:	ff 75 f4             	pushl  -0xc(%ebp)
8010564a:	ff 75 ec             	pushl  -0x14(%ebp)
8010564d:	e8 de c3 ff ff       	call   80101a30 <fileread>
80105652:	83 c4 10             	add    $0x10,%esp
}
80105655:	c9                   	leave  
80105656:	c3                   	ret    
80105657:	89 f6                	mov    %esi,%esi
80105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return -1;
80105660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105665:	c9                   	leave  
80105666:	c3                   	ret    
80105667:	89 f6                	mov    %esi,%esi
80105669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105670 <sys_write>:
int sys_write(void) {
80105670:	55                   	push   %ebp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) {
80105671:	31 c0                	xor    %eax,%eax
int sys_write(void) {
80105673:	89 e5                	mov    %esp,%ebp
80105675:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) {
80105678:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010567b:	e8 c0 fe ff ff       	call   80105540 <argfd.constprop.0>
80105680:	85 c0                	test   %eax,%eax
80105682:	78 4c                	js     801056d0 <sys_write+0x60>
80105684:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105687:	83 ec 08             	sub    $0x8,%esp
8010568a:	50                   	push   %eax
8010568b:	6a 02                	push   $0x2
8010568d:	e8 be fb ff ff       	call   80105250 <argint>
80105692:	83 c4 10             	add    $0x10,%esp
80105695:	85 c0                	test   %eax,%eax
80105697:	78 37                	js     801056d0 <sys_write+0x60>
80105699:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010569c:	83 ec 04             	sub    $0x4,%esp
8010569f:	ff 75 f0             	pushl  -0x10(%ebp)
801056a2:	50                   	push   %eax
801056a3:	6a 01                	push   $0x1
801056a5:	e8 f6 fb ff ff       	call   801052a0 <argptr>
801056aa:	83 c4 10             	add    $0x10,%esp
801056ad:	85 c0                	test   %eax,%eax
801056af:	78 1f                	js     801056d0 <sys_write+0x60>
    return filewrite(f, p, n);
801056b1:	83 ec 04             	sub    $0x4,%esp
801056b4:	ff 75 f0             	pushl  -0x10(%ebp)
801056b7:	ff 75 f4             	pushl  -0xc(%ebp)
801056ba:	ff 75 ec             	pushl  -0x14(%ebp)
801056bd:	e8 fe c3 ff ff       	call   80101ac0 <filewrite>
801056c2:	83 c4 10             	add    $0x10,%esp
}
801056c5:	c9                   	leave  
801056c6:	c3                   	ret    
801056c7:	89 f6                	mov    %esi,%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return -1;
801056d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056d5:	c9                   	leave  
801056d6:	c3                   	ret    
801056d7:	89 f6                	mov    %esi,%esi
801056d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056e0 <sys_close>:
int sys_close(void) {
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, &fd, &f) < 0) {
801056e6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801056e9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056ec:	e8 4f fe ff ff       	call   80105540 <argfd.constprop.0>
801056f1:	85 c0                	test   %eax,%eax
801056f3:	78 2b                	js     80105720 <sys_close+0x40>
    myproc()->ofile[fd] = 0;
801056f5:	e8 e6 eb ff ff       	call   801042e0 <myproc>
801056fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
    fileclose(f);
801056fd:	83 ec 0c             	sub    $0xc,%esp
    myproc()->ofile[fd] = 0;
80105700:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105707:	00 
    fileclose(f);
80105708:	ff 75 f4             	pushl  -0xc(%ebp)
8010570b:	e8 00 c2 ff ff       	call   80101910 <fileclose>
    return 0;
80105710:	83 c4 10             	add    $0x10,%esp
80105713:	31 c0                	xor    %eax,%eax
}
80105715:	c9                   	leave  
80105716:	c3                   	ret    
80105717:	89 f6                	mov    %esi,%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return -1;
80105720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105725:	c9                   	leave  
80105726:	c3                   	ret    
80105727:	89 f6                	mov    %esi,%esi
80105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105730 <sys_fstat>:
int sys_fstat(void) {
80105730:	55                   	push   %ebp
    if (argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0) {
80105731:	31 c0                	xor    %eax,%eax
int sys_fstat(void) {
80105733:	89 e5                	mov    %esp,%ebp
80105735:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0) {
80105738:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010573b:	e8 00 fe ff ff       	call   80105540 <argfd.constprop.0>
80105740:	85 c0                	test   %eax,%eax
80105742:	78 2c                	js     80105770 <sys_fstat+0x40>
80105744:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105747:	83 ec 04             	sub    $0x4,%esp
8010574a:	6a 14                	push   $0x14
8010574c:	50                   	push   %eax
8010574d:	6a 01                	push   $0x1
8010574f:	e8 4c fb ff ff       	call   801052a0 <argptr>
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	85 c0                	test   %eax,%eax
80105759:	78 15                	js     80105770 <sys_fstat+0x40>
    return filestat(f, st);
8010575b:	83 ec 08             	sub    $0x8,%esp
8010575e:	ff 75 f4             	pushl  -0xc(%ebp)
80105761:	ff 75 f0             	pushl  -0x10(%ebp)
80105764:	e8 77 c2 ff ff       	call   801019e0 <filestat>
80105769:	83 c4 10             	add    $0x10,%esp
}
8010576c:	c9                   	leave  
8010576d:	c3                   	ret    
8010576e:	66 90                	xchg   %ax,%ax
        return -1;
80105770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105775:	c9                   	leave  
80105776:	c3                   	ret    
80105777:	89 f6                	mov    %esi,%esi
80105779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105780 <cleanupsyslink>:
void cleanupsyslink(struct inode * ip) {
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	53                   	push   %ebx
80105784:	83 ec 10             	sub    $0x10,%esp
80105787:	8b 5d 08             	mov    0x8(%ebp),%ebx
    ilock(ip);
8010578a:	53                   	push   %ebx
8010578b:	e8 c0 c9 ff ff       	call   80102150 <ilock>
    ip->nlink--;
80105790:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
    iupdate(ip);
80105795:	89 1c 24             	mov    %ebx,(%esp)
80105798:	e8 03 c9 ff ff       	call   801020a0 <iupdate>
    iunlockput(ip);
8010579d:	89 1c 24             	mov    %ebx,(%esp)
801057a0:	e8 3b cc ff ff       	call   801023e0 <iunlockput>
    end_op();
801057a5:	83 c4 10             	add    $0x10,%esp
}
801057a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057ab:	c9                   	leave  
    end_op();
801057ac:	e9 2f df ff ff       	jmp    801036e0 <end_op>
801057b1:	eb 0d                	jmp    801057c0 <sys_link>
801057b3:	90                   	nop
801057b4:	90                   	nop
801057b5:	90                   	nop
801057b6:	90                   	nop
801057b7:	90                   	nop
801057b8:	90                   	nop
801057b9:	90                   	nop
801057ba:	90                   	nop
801057bb:	90                   	nop
801057bc:	90                   	nop
801057bd:	90                   	nop
801057be:	90                   	nop
801057bf:	90                   	nop

801057c0 <sys_link>:
int sys_link(void) {
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	57                   	push   %edi
801057c4:	56                   	push   %esi
801057c5:	53                   	push   %ebx
    if (argstr(0, &old) < 0 || argstr(1, &new) < 0) {
801057c6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
int sys_link(void) {
801057c9:	83 ec 34             	sub    $0x34,%esp
    if (argstr(0, &old) < 0 || argstr(1, &new) < 0) {
801057cc:	50                   	push   %eax
801057cd:	6a 00                	push   $0x0
801057cf:	e8 2c fb ff ff       	call   80105300 <argstr>
801057d4:	83 c4 10             	add    $0x10,%esp
801057d7:	85 c0                	test   %eax,%eax
801057d9:	0f 88 f1 00 00 00    	js     801058d0 <sys_link+0x110>
801057df:	8d 45 d0             	lea    -0x30(%ebp),%eax
801057e2:	83 ec 08             	sub    $0x8,%esp
801057e5:	50                   	push   %eax
801057e6:	6a 01                	push   $0x1
801057e8:	e8 13 fb ff ff       	call   80105300 <argstr>
801057ed:	83 c4 10             	add    $0x10,%esp
801057f0:	85 c0                	test   %eax,%eax
801057f2:	0f 88 d8 00 00 00    	js     801058d0 <sys_link+0x110>
    begin_op();
801057f8:	e8 73 de ff ff       	call   80103670 <begin_op>
    if ((ip = namei(old)) == 0) {
801057fd:	83 ec 0c             	sub    $0xc,%esp
80105800:	ff 75 d4             	pushl  -0x2c(%ebp)
80105803:	e8 a8 d1 ff ff       	call   801029b0 <namei>
80105808:	83 c4 10             	add    $0x10,%esp
8010580b:	85 c0                	test   %eax,%eax
8010580d:	89 c3                	mov    %eax,%ebx
8010580f:	0f 84 da 00 00 00    	je     801058ef <sys_link+0x12f>
    ilock(ip);
80105815:	83 ec 0c             	sub    $0xc,%esp
80105818:	50                   	push   %eax
80105819:	e8 32 c9 ff ff       	call   80102150 <ilock>
    if (ip->type == T_DIR) {
8010581e:	83 c4 10             	add    $0x10,%esp
80105821:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105826:	0f 84 ab 00 00 00    	je     801058d7 <sys_link+0x117>
    ip->nlink++;
8010582c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(ip);
80105831:	83 ec 0c             	sub    $0xc,%esp
    if ((dp = nameiparent(new, name)) == 0) {
80105834:	8d 7d da             	lea    -0x26(%ebp),%edi
    iupdate(ip);
80105837:	53                   	push   %ebx
80105838:	e8 63 c8 ff ff       	call   801020a0 <iupdate>
    iunlock(ip);
8010583d:	89 1c 24             	mov    %ebx,(%esp)
80105840:	e8 eb c9 ff ff       	call   80102230 <iunlock>
    if ((dp = nameiparent(new, name)) == 0) {
80105845:	58                   	pop    %eax
80105846:	5a                   	pop    %edx
80105847:	57                   	push   %edi
80105848:	ff 75 d0             	pushl  -0x30(%ebp)
8010584b:	e8 80 d1 ff ff       	call   801029d0 <nameiparent>
80105850:	83 c4 10             	add    $0x10,%esp
80105853:	85 c0                	test   %eax,%eax
80105855:	89 c6                	mov    %eax,%esi
80105857:	74 6a                	je     801058c3 <sys_link+0x103>
    ilock(dp);
80105859:	83 ec 0c             	sub    $0xc,%esp
8010585c:	50                   	push   %eax
8010585d:	e8 ee c8 ff ff       	call   80102150 <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
80105862:	83 c4 10             	add    $0x10,%esp
80105865:	8b 03                	mov    (%ebx),%eax
80105867:	39 06                	cmp    %eax,(%esi)
80105869:	75 3d                	jne    801058a8 <sys_link+0xe8>
8010586b:	83 ec 04             	sub    $0x4,%esp
8010586e:	ff 73 04             	pushl  0x4(%ebx)
80105871:	57                   	push   %edi
80105872:	56                   	push   %esi
80105873:	e8 78 d0 ff ff       	call   801028f0 <dirlink>
80105878:	83 c4 10             	add    $0x10,%esp
8010587b:	85 c0                	test   %eax,%eax
8010587d:	78 29                	js     801058a8 <sys_link+0xe8>
    iunlockput(dp);
8010587f:	83 ec 0c             	sub    $0xc,%esp
80105882:	56                   	push   %esi
80105883:	e8 58 cb ff ff       	call   801023e0 <iunlockput>
    iput(ip);
80105888:	89 1c 24             	mov    %ebx,(%esp)
8010588b:	e8 f0 c9 ff ff       	call   80102280 <iput>
    end_op();
80105890:	e8 4b de ff ff       	call   801036e0 <end_op>
    return 0;
80105895:	83 c4 10             	add    $0x10,%esp
80105898:	31 c0                	xor    %eax,%eax
}
8010589a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010589d:	5b                   	pop    %ebx
8010589e:	5e                   	pop    %esi
8010589f:	5f                   	pop    %edi
801058a0:	5d                   	pop    %ebp
801058a1:	c3                   	ret    
801058a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        iunlockput(dp);
801058a8:	83 ec 0c             	sub    $0xc,%esp
801058ab:	56                   	push   %esi
801058ac:	e8 2f cb ff ff       	call   801023e0 <iunlockput>
        cleanupsyslink(ip);
801058b1:	89 1c 24             	mov    %ebx,(%esp)
801058b4:	e8 c7 fe ff ff       	call   80105780 <cleanupsyslink>
        return -1;
801058b9:	83 c4 10             	add    $0x10,%esp
801058bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058c1:	eb d7                	jmp    8010589a <sys_link+0xda>
        cleanupsyslink(ip);
801058c3:	83 ec 0c             	sub    $0xc,%esp
801058c6:	53                   	push   %ebx
801058c7:	e8 b4 fe ff ff       	call   80105780 <cleanupsyslink>
        return -1;
801058cc:	83 c4 10             	add    $0x10,%esp
801058cf:	90                   	nop
801058d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d5:	eb c3                	jmp    8010589a <sys_link+0xda>
        iunlockput(ip);
801058d7:	83 ec 0c             	sub    $0xc,%esp
801058da:	53                   	push   %ebx
801058db:	e8 00 cb ff ff       	call   801023e0 <iunlockput>
        end_op();
801058e0:	e8 fb dd ff ff       	call   801036e0 <end_op>
        return -1;
801058e5:	83 c4 10             	add    $0x10,%esp
801058e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ed:	eb ab                	jmp    8010589a <sys_link+0xda>
        end_op();
801058ef:	e8 ec dd ff ff       	call   801036e0 <end_op>
        return -1;
801058f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058f9:	eb 9f                	jmp    8010589a <sys_link+0xda>
801058fb:	90                   	nop
801058fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105900 <sys_unlink>:
int sys_unlink(void) {
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	57                   	push   %edi
80105904:	56                   	push   %esi
80105905:	53                   	push   %ebx
    if (argstr(0, &path) < 0) {
80105906:	8d 45 c0             	lea    -0x40(%ebp),%eax
int sys_unlink(void) {
80105909:	83 ec 44             	sub    $0x44,%esp
    if (argstr(0, &path) < 0) {
8010590c:	50                   	push   %eax
8010590d:	6a 00                	push   $0x0
8010590f:	e8 ec f9 ff ff       	call   80105300 <argstr>
80105914:	83 c4 10             	add    $0x10,%esp
80105917:	85 c0                	test   %eax,%eax
80105919:	0f 88 52 01 00 00    	js     80105a71 <sys_unlink+0x171>
    if ((dp = nameiparent(path, name)) == 0) {
8010591f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
    begin_op();
80105922:	e8 49 dd ff ff       	call   80103670 <begin_op>
    if ((dp = nameiparent(path, name)) == 0) {
80105927:	83 ec 08             	sub    $0x8,%esp
8010592a:	53                   	push   %ebx
8010592b:	ff 75 c0             	pushl  -0x40(%ebp)
8010592e:	e8 9d d0 ff ff       	call   801029d0 <nameiparent>
80105933:	83 c4 10             	add    $0x10,%esp
80105936:	85 c0                	test   %eax,%eax
80105938:	89 c6                	mov    %eax,%esi
8010593a:	0f 84 7b 01 00 00    	je     80105abb <sys_unlink+0x1bb>
    ilock(dp);
80105940:	83 ec 0c             	sub    $0xc,%esp
80105943:	50                   	push   %eax
80105944:	e8 07 c8 ff ff       	call   80102150 <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) {
80105949:	58                   	pop    %eax
8010594a:	5a                   	pop    %edx
8010594b:	68 d4 82 10 80       	push   $0x801082d4
80105950:	53                   	push   %ebx
80105951:	e8 0a cd ff ff       	call   80102660 <namecmp>
80105956:	83 c4 10             	add    $0x10,%esp
80105959:	85 c0                	test   %eax,%eax
8010595b:	0f 84 3f 01 00 00    	je     80105aa0 <sys_unlink+0x1a0>
80105961:	83 ec 08             	sub    $0x8,%esp
80105964:	68 d3 82 10 80       	push   $0x801082d3
80105969:	53                   	push   %ebx
8010596a:	e8 f1 cc ff ff       	call   80102660 <namecmp>
8010596f:	83 c4 10             	add    $0x10,%esp
80105972:	85 c0                	test   %eax,%eax
80105974:	0f 84 26 01 00 00    	je     80105aa0 <sys_unlink+0x1a0>
    if ((ip = dirlookup(dp, name, &off)) == 0) {
8010597a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010597d:	83 ec 04             	sub    $0x4,%esp
80105980:	50                   	push   %eax
80105981:	53                   	push   %ebx
80105982:	56                   	push   %esi
80105983:	e8 f8 cc ff ff       	call   80102680 <dirlookup>
80105988:	83 c4 10             	add    $0x10,%esp
8010598b:	85 c0                	test   %eax,%eax
8010598d:	89 c3                	mov    %eax,%ebx
8010598f:	0f 84 0b 01 00 00    	je     80105aa0 <sys_unlink+0x1a0>
    ilock(ip);
80105995:	83 ec 0c             	sub    $0xc,%esp
80105998:	50                   	push   %eax
80105999:	e8 b2 c7 ff ff       	call   80102150 <ilock>
    if (ip->nlink < 1) {
8010599e:	83 c4 10             	add    $0x10,%esp
801059a1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801059a6:	0f 8e 2b 01 00 00    	jle    80105ad7 <sys_unlink+0x1d7>
    if (ip->type == T_DIR && !isdirempty(ip)) {
801059ac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059b1:	74 6d                	je     80105a20 <sys_unlink+0x120>
    memset(&de, 0, sizeof(de));
801059b3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801059b6:	83 ec 04             	sub    $0x4,%esp
801059b9:	6a 10                	push   $0x10
801059bb:	6a 00                	push   $0x0
801059bd:	50                   	push   %eax
801059be:	e8 8d f5 ff ff       	call   80104f50 <memset>
    if (writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
801059c3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801059c6:	6a 10                	push   $0x10
801059c8:	ff 75 c4             	pushl  -0x3c(%ebp)
801059cb:	50                   	push   %eax
801059cc:	56                   	push   %esi
801059cd:	e8 5e cb ff ff       	call   80102530 <writei>
801059d2:	83 c4 20             	add    $0x20,%esp
801059d5:	83 f8 10             	cmp    $0x10,%eax
801059d8:	0f 85 06 01 00 00    	jne    80105ae4 <sys_unlink+0x1e4>
    if (ip->type == T_DIR) {
801059de:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059e3:	0f 84 97 00 00 00    	je     80105a80 <sys_unlink+0x180>
    iunlockput(dp);
801059e9:	83 ec 0c             	sub    $0xc,%esp
801059ec:	56                   	push   %esi
801059ed:	e8 ee c9 ff ff       	call   801023e0 <iunlockput>
    ip->nlink--;
801059f2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
    iupdate(ip);
801059f7:	89 1c 24             	mov    %ebx,(%esp)
801059fa:	e8 a1 c6 ff ff       	call   801020a0 <iupdate>
    iunlockput(ip);
801059ff:	89 1c 24             	mov    %ebx,(%esp)
80105a02:	e8 d9 c9 ff ff       	call   801023e0 <iunlockput>
    end_op();
80105a07:	e8 d4 dc ff ff       	call   801036e0 <end_op>
    return 0;
80105a0c:	83 c4 10             	add    $0x10,%esp
80105a0f:	31 c0                	xor    %eax,%eax
}
80105a11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a14:	5b                   	pop    %ebx
80105a15:	5e                   	pop    %esi
80105a16:	5f                   	pop    %edi
80105a17:	5d                   	pop    %ebp
80105a18:	c3                   	ret    
80105a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
80105a20:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105a24:	76 8d                	jbe    801059b3 <sys_unlink+0xb3>
80105a26:	bf 20 00 00 00       	mov    $0x20,%edi
80105a2b:	eb 0f                	jmp    80105a3c <sys_unlink+0x13c>
80105a2d:	8d 76 00             	lea    0x0(%esi),%esi
80105a30:	83 c7 10             	add    $0x10,%edi
80105a33:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105a36:	0f 83 77 ff ff ff    	jae    801059b3 <sys_unlink+0xb3>
        if (readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80105a3c:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105a3f:	6a 10                	push   $0x10
80105a41:	57                   	push   %edi
80105a42:	50                   	push   %eax
80105a43:	53                   	push   %ebx
80105a44:	e8 e7 c9 ff ff       	call   80102430 <readi>
80105a49:	83 c4 10             	add    $0x10,%esp
80105a4c:	83 f8 10             	cmp    $0x10,%eax
80105a4f:	75 79                	jne    80105aca <sys_unlink+0x1ca>
        if (de.inum != 0) {
80105a51:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105a56:	74 d8                	je     80105a30 <sys_unlink+0x130>
        iunlockput(ip);
80105a58:	83 ec 0c             	sub    $0xc,%esp
80105a5b:	53                   	push   %ebx
80105a5c:	e8 7f c9 ff ff       	call   801023e0 <iunlockput>
        iunlockput(dp);
80105a61:	89 34 24             	mov    %esi,(%esp)
80105a64:	e8 77 c9 ff ff       	call   801023e0 <iunlockput>
        end_op();
80105a69:	e8 72 dc ff ff       	call   801036e0 <end_op>
        return -1;       
80105a6e:	83 c4 10             	add    $0x10,%esp
}
80105a71:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;       
80105a74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a79:	5b                   	pop    %ebx
80105a7a:	5e                   	pop    %esi
80105a7b:	5f                   	pop    %edi
80105a7c:	5d                   	pop    %ebp
80105a7d:	c3                   	ret    
80105a7e:	66 90                	xchg   %ax,%ax
        dp->nlink--;
80105a80:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
        iupdate(dp);
80105a85:	83 ec 0c             	sub    $0xc,%esp
80105a88:	56                   	push   %esi
80105a89:	e8 12 c6 ff ff       	call   801020a0 <iupdate>
80105a8e:	83 c4 10             	add    $0x10,%esp
80105a91:	e9 53 ff ff ff       	jmp    801059e9 <sys_unlink+0xe9>
80105a96:	8d 76 00             	lea    0x0(%esi),%esi
80105a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        iunlockput(dp);
80105aa0:	83 ec 0c             	sub    $0xc,%esp
80105aa3:	56                   	push   %esi
80105aa4:	e8 37 c9 ff ff       	call   801023e0 <iunlockput>
        end_op();
80105aa9:	e8 32 dc ff ff       	call   801036e0 <end_op>
        return -1;       
80105aae:	83 c4 10             	add    $0x10,%esp
80105ab1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ab6:	e9 56 ff ff ff       	jmp    80105a11 <sys_unlink+0x111>
        end_op();
80105abb:	e8 20 dc ff ff       	call   801036e0 <end_op>
        return -1;
80105ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ac5:	e9 47 ff ff ff       	jmp    80105a11 <sys_unlink+0x111>
            panic("isdirempty: readi");
80105aca:	83 ec 0c             	sub    $0xc,%esp
80105acd:	68 f8 82 10 80       	push   $0x801082f8
80105ad2:	e8 09 aa ff ff       	call   801004e0 <panic>
        panic("unlink: nlink < 1");
80105ad7:	83 ec 0c             	sub    $0xc,%esp
80105ada:	68 e6 82 10 80       	push   $0x801082e6
80105adf:	e8 fc a9 ff ff       	call   801004e0 <panic>
        panic("unlink: writei");
80105ae4:	83 ec 0c             	sub    $0xc,%esp
80105ae7:	68 0a 83 10 80       	push   $0x8010830a
80105aec:	e8 ef a9 ff ff       	call   801004e0 <panic>
80105af1:	eb 0d                	jmp    80105b00 <sys_open>
80105af3:	90                   	nop
80105af4:	90                   	nop
80105af5:	90                   	nop
80105af6:	90                   	nop
80105af7:	90                   	nop
80105af8:	90                   	nop
80105af9:	90                   	nop
80105afa:	90                   	nop
80105afb:	90                   	nop
80105afc:	90                   	nop
80105afd:	90                   	nop
80105afe:	90                   	nop
80105aff:	90                   	nop

80105b00 <sys_open>:

int sys_open(void) {
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	57                   	push   %edi
80105b04:	56                   	push   %esi
80105b05:	53                   	push   %ebx
    char *path;
    int fd, omode;
    struct file *f;
    struct inode *ip;

    if (argstr(0, &path) < 0 || argint(1, &omode) < 0) {
80105b06:	8d 45 e0             	lea    -0x20(%ebp),%eax
int sys_open(void) {
80105b09:	83 ec 24             	sub    $0x24,%esp
    if (argstr(0, &path) < 0 || argint(1, &omode) < 0) {
80105b0c:	50                   	push   %eax
80105b0d:	6a 00                	push   $0x0
80105b0f:	e8 ec f7 ff ff       	call   80105300 <argstr>
80105b14:	83 c4 10             	add    $0x10,%esp
80105b17:	85 c0                	test   %eax,%eax
80105b19:	0f 88 1d 01 00 00    	js     80105c3c <sys_open+0x13c>
80105b1f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b22:	83 ec 08             	sub    $0x8,%esp
80105b25:	50                   	push   %eax
80105b26:	6a 01                	push   $0x1
80105b28:	e8 23 f7 ff ff       	call   80105250 <argint>
80105b2d:	83 c4 10             	add    $0x10,%esp
80105b30:	85 c0                	test   %eax,%eax
80105b32:	0f 88 04 01 00 00    	js     80105c3c <sys_open+0x13c>
        return -1;
    }

    begin_op();
80105b38:	e8 33 db ff ff       	call   80103670 <begin_op>

    if (omode & O_CREATE) {
80105b3d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105b41:	0f 85 a9 00 00 00    	jne    80105bf0 <sys_open+0xf0>
            end_op();
            return -1;
        }
    }
    else {
        if ((ip = namei(path)) == 0) {
80105b47:	83 ec 0c             	sub    $0xc,%esp
80105b4a:	ff 75 e0             	pushl  -0x20(%ebp)
80105b4d:	e8 5e ce ff ff       	call   801029b0 <namei>
80105b52:	83 c4 10             	add    $0x10,%esp
80105b55:	85 c0                	test   %eax,%eax
80105b57:	89 c6                	mov    %eax,%esi
80105b59:	0f 84 b2 00 00 00    	je     80105c11 <sys_open+0x111>
            end_op();
            return -1;
        }
        ilock(ip);
80105b5f:	83 ec 0c             	sub    $0xc,%esp
80105b62:	50                   	push   %eax
80105b63:	e8 e8 c5 ff ff       	call   80102150 <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY) {
80105b68:	83 c4 10             	add    $0x10,%esp
80105b6b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105b70:	0f 84 aa 00 00 00    	je     80105c20 <sys_open+0x120>
            end_op();
            return -1;
        }
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
80105b76:	e8 d5 bc ff ff       	call   80101850 <filealloc>
80105b7b:	85 c0                	test   %eax,%eax
80105b7d:	89 c7                	mov    %eax,%edi
80105b7f:	0f 84 a6 00 00 00    	je     80105c2b <sys_open+0x12b>
    struct proc *curproc = myproc();
80105b85:	e8 56 e7 ff ff       	call   801042e0 <myproc>
    for (fd = 0; fd < NOFILE; fd++) {
80105b8a:	31 db                	xor    %ebx,%ebx
80105b8c:	eb 0e                	jmp    80105b9c <sys_open+0x9c>
80105b8e:	66 90                	xchg   %ax,%ax
80105b90:	83 c3 01             	add    $0x1,%ebx
80105b93:	83 fb 10             	cmp    $0x10,%ebx
80105b96:	0f 84 ac 00 00 00    	je     80105c48 <sys_open+0x148>
        if (curproc->ofile[fd] == 0) {
80105b9c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105ba0:	85 d2                	test   %edx,%edx
80105ba2:	75 ec                	jne    80105b90 <sys_open+0x90>
        }
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
80105ba4:	83 ec 0c             	sub    $0xc,%esp
            curproc->ofile[fd] = f;
80105ba7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
    iunlock(ip);
80105bab:	56                   	push   %esi
80105bac:	e8 7f c6 ff ff       	call   80102230 <iunlock>
    end_op();
80105bb1:	e8 2a db ff ff       	call   801036e0 <end_op>

    f->type = FD_INODE;
80105bb6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
    f->ip = ip;
    f->off = 0;
    f->readable = !(omode & O_WRONLY);
80105bbc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bbf:	83 c4 10             	add    $0x10,%esp
    f->ip = ip;
80105bc2:	89 77 10             	mov    %esi,0x10(%edi)
    f->off = 0;
80105bc5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
    f->readable = !(omode & O_WRONLY);
80105bcc:	89 d0                	mov    %edx,%eax
80105bce:	f7 d0                	not    %eax
80105bd0:	83 e0 01             	and    $0x1,%eax
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bd3:	83 e2 03             	and    $0x3,%edx
    f->readable = !(omode & O_WRONLY);
80105bd6:	88 47 08             	mov    %al,0x8(%edi)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bd9:	0f 95 47 09          	setne  0x9(%edi)
    return fd;
}
80105bdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105be0:	89 d8                	mov    %ebx,%eax
80105be2:	5b                   	pop    %ebx
80105be3:	5e                   	pop    %esi
80105be4:	5f                   	pop    %edi
80105be5:	5d                   	pop    %ebp
80105be6:	c3                   	ret    
80105be7:	89 f6                	mov    %esi,%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        ip = create(path, T_FILE, 0, 0);
80105bf0:	83 ec 0c             	sub    $0xc,%esp
80105bf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105bf6:	31 c9                	xor    %ecx,%ecx
80105bf8:	6a 00                	push   $0x0
80105bfa:	ba 02 00 00 00       	mov    $0x2,%edx
80105bff:	e8 9c f7 ff ff       	call   801053a0 <create>
        if (ip == 0) {
80105c04:	83 c4 10             	add    $0x10,%esp
80105c07:	85 c0                	test   %eax,%eax
        ip = create(path, T_FILE, 0, 0);
80105c09:	89 c6                	mov    %eax,%esi
        if (ip == 0) {
80105c0b:	0f 85 65 ff ff ff    	jne    80105b76 <sys_open+0x76>
            end_op();
80105c11:	e8 ca da ff ff       	call   801036e0 <end_op>
            return -1;
80105c16:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c1b:	eb c0                	jmp    80105bdd <sys_open+0xdd>
80105c1d:	8d 76 00             	lea    0x0(%esi),%esi
        if (ip->type == T_DIR && omode != O_RDONLY) {
80105c20:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105c23:	85 c9                	test   %ecx,%ecx
80105c25:	0f 84 4b ff ff ff    	je     80105b76 <sys_open+0x76>
        iunlockput(ip);
80105c2b:	83 ec 0c             	sub    $0xc,%esp
80105c2e:	56                   	push   %esi
80105c2f:	e8 ac c7 ff ff       	call   801023e0 <iunlockput>
        end_op();
80105c34:	e8 a7 da ff ff       	call   801036e0 <end_op>
        return -1;
80105c39:	83 c4 10             	add    $0x10,%esp
80105c3c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c41:	eb 9a                	jmp    80105bdd <sys_open+0xdd>
80105c43:	90                   	nop
80105c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            fileclose(f);
80105c48:	83 ec 0c             	sub    $0xc,%esp
80105c4b:	57                   	push   %edi
80105c4c:	e8 bf bc ff ff       	call   80101910 <fileclose>
80105c51:	83 c4 10             	add    $0x10,%esp
80105c54:	eb d5                	jmp    80105c2b <sys_open+0x12b>
80105c56:	8d 76 00             	lea    0x0(%esi),%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c60 <sys_mkdir>:

int sys_mkdir(void) {
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	83 ec 18             	sub    $0x18,%esp
    char *path;
    struct inode *ip;

    begin_op();
80105c66:	e8 05 da ff ff       	call   80103670 <begin_op>
    if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
80105c6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c6e:	83 ec 08             	sub    $0x8,%esp
80105c71:	50                   	push   %eax
80105c72:	6a 00                	push   $0x0
80105c74:	e8 87 f6 ff ff       	call   80105300 <argstr>
80105c79:	83 c4 10             	add    $0x10,%esp
80105c7c:	85 c0                	test   %eax,%eax
80105c7e:	78 30                	js     80105cb0 <sys_mkdir+0x50>
80105c80:	83 ec 0c             	sub    $0xc,%esp
80105c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c86:	31 c9                	xor    %ecx,%ecx
80105c88:	6a 00                	push   $0x0
80105c8a:	ba 01 00 00 00       	mov    $0x1,%edx
80105c8f:	e8 0c f7 ff ff       	call   801053a0 <create>
80105c94:	83 c4 10             	add    $0x10,%esp
80105c97:	85 c0                	test   %eax,%eax
80105c99:	74 15                	je     80105cb0 <sys_mkdir+0x50>
        end_op();
        return -1;
    }
    iunlockput(ip);
80105c9b:	83 ec 0c             	sub    $0xc,%esp
80105c9e:	50                   	push   %eax
80105c9f:	e8 3c c7 ff ff       	call   801023e0 <iunlockput>
    end_op();
80105ca4:	e8 37 da ff ff       	call   801036e0 <end_op>
    return 0;
80105ca9:	83 c4 10             	add    $0x10,%esp
80105cac:	31 c0                	xor    %eax,%eax
}
80105cae:	c9                   	leave  
80105caf:	c3                   	ret    
        end_op();
80105cb0:	e8 2b da ff ff       	call   801036e0 <end_op>
        return -1;
80105cb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cba:	c9                   	leave  
80105cbb:	c3                   	ret    
80105cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cc0 <sys_mknod>:

int sys_mknod(void) {
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	83 ec 18             	sub    $0x18,%esp
    struct inode *ip;
    char *path;
    int major, minor;

    begin_op();
80105cc6:	e8 a5 d9 ff ff       	call   80103670 <begin_op>
    if ((argstr(0, &path)) < 0 ||
80105ccb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105cce:	83 ec 08             	sub    $0x8,%esp
80105cd1:	50                   	push   %eax
80105cd2:	6a 00                	push   $0x0
80105cd4:	e8 27 f6 ff ff       	call   80105300 <argstr>
80105cd9:	83 c4 10             	add    $0x10,%esp
80105cdc:	85 c0                	test   %eax,%eax
80105cde:	78 60                	js     80105d40 <sys_mknod+0x80>
        argint(1, &major) < 0 ||
80105ce0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ce3:	83 ec 08             	sub    $0x8,%esp
80105ce6:	50                   	push   %eax
80105ce7:	6a 01                	push   $0x1
80105ce9:	e8 62 f5 ff ff       	call   80105250 <argint>
    if ((argstr(0, &path)) < 0 ||
80105cee:	83 c4 10             	add    $0x10,%esp
80105cf1:	85 c0                	test   %eax,%eax
80105cf3:	78 4b                	js     80105d40 <sys_mknod+0x80>
        argint(2, &minor) < 0 ||
80105cf5:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cf8:	83 ec 08             	sub    $0x8,%esp
80105cfb:	50                   	push   %eax
80105cfc:	6a 02                	push   $0x2
80105cfe:	e8 4d f5 ff ff       	call   80105250 <argint>
        argint(1, &major) < 0 ||
80105d03:	83 c4 10             	add    $0x10,%esp
80105d06:	85 c0                	test   %eax,%eax
80105d08:	78 36                	js     80105d40 <sys_mknod+0x80>
        (ip = create(path, T_DEV, major, minor)) == 0) {
80105d0a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
        argint(2, &minor) < 0 ||
80105d0e:	83 ec 0c             	sub    $0xc,%esp
        (ip = create(path, T_DEV, major, minor)) == 0) {
80105d11:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
        argint(2, &minor) < 0 ||
80105d15:	ba 03 00 00 00       	mov    $0x3,%edx
80105d1a:	50                   	push   %eax
80105d1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105d1e:	e8 7d f6 ff ff       	call   801053a0 <create>
80105d23:	83 c4 10             	add    $0x10,%esp
80105d26:	85 c0                	test   %eax,%eax
80105d28:	74 16                	je     80105d40 <sys_mknod+0x80>
        end_op();
        return -1;
    }
    iunlockput(ip);
80105d2a:	83 ec 0c             	sub    $0xc,%esp
80105d2d:	50                   	push   %eax
80105d2e:	e8 ad c6 ff ff       	call   801023e0 <iunlockput>
    end_op();
80105d33:	e8 a8 d9 ff ff       	call   801036e0 <end_op>
    return 0;
80105d38:	83 c4 10             	add    $0x10,%esp
80105d3b:	31 c0                	xor    %eax,%eax
}
80105d3d:	c9                   	leave  
80105d3e:	c3                   	ret    
80105d3f:	90                   	nop
        end_op();
80105d40:	e8 9b d9 ff ff       	call   801036e0 <end_op>
        return -1;
80105d45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d4a:	c9                   	leave  
80105d4b:	c3                   	ret    
80105d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d50 <sys_chdir>:

int sys_chdir(void) {
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	56                   	push   %esi
80105d54:	53                   	push   %ebx
80105d55:	83 ec 10             	sub    $0x10,%esp
    char *path;
    struct inode *ip;
    struct proc *curproc = myproc();
80105d58:	e8 83 e5 ff ff       	call   801042e0 <myproc>
80105d5d:	89 c6                	mov    %eax,%esi

    begin_op();
80105d5f:	e8 0c d9 ff ff       	call   80103670 <begin_op>
    if (argstr(0, &path) < 0 || (ip = namei(path)) == 0) {
80105d64:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d67:	83 ec 08             	sub    $0x8,%esp
80105d6a:	50                   	push   %eax
80105d6b:	6a 00                	push   $0x0
80105d6d:	e8 8e f5 ff ff       	call   80105300 <argstr>
80105d72:	83 c4 10             	add    $0x10,%esp
80105d75:	85 c0                	test   %eax,%eax
80105d77:	78 77                	js     80105df0 <sys_chdir+0xa0>
80105d79:	83 ec 0c             	sub    $0xc,%esp
80105d7c:	ff 75 f4             	pushl  -0xc(%ebp)
80105d7f:	e8 2c cc ff ff       	call   801029b0 <namei>
80105d84:	83 c4 10             	add    $0x10,%esp
80105d87:	85 c0                	test   %eax,%eax
80105d89:	89 c3                	mov    %eax,%ebx
80105d8b:	74 63                	je     80105df0 <sys_chdir+0xa0>
        end_op();
        return -1;
    }
    ilock(ip);
80105d8d:	83 ec 0c             	sub    $0xc,%esp
80105d90:	50                   	push   %eax
80105d91:	e8 ba c3 ff ff       	call   80102150 <ilock>
    if (ip->type != T_DIR) {
80105d96:	83 c4 10             	add    $0x10,%esp
80105d99:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d9e:	75 30                	jne    80105dd0 <sys_chdir+0x80>
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
80105da0:	83 ec 0c             	sub    $0xc,%esp
80105da3:	53                   	push   %ebx
80105da4:	e8 87 c4 ff ff       	call   80102230 <iunlock>
    iput(curproc->cwd);
80105da9:	58                   	pop    %eax
80105daa:	ff 76 68             	pushl  0x68(%esi)
80105dad:	e8 ce c4 ff ff       	call   80102280 <iput>
    end_op();
80105db2:	e8 29 d9 ff ff       	call   801036e0 <end_op>
    curproc->cwd = ip;
80105db7:	89 5e 68             	mov    %ebx,0x68(%esi)
    return 0;
80105dba:	83 c4 10             	add    $0x10,%esp
80105dbd:	31 c0                	xor    %eax,%eax
}
80105dbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105dc2:	5b                   	pop    %ebx
80105dc3:	5e                   	pop    %esi
80105dc4:	5d                   	pop    %ebp
80105dc5:	c3                   	ret    
80105dc6:	8d 76 00             	lea    0x0(%esi),%esi
80105dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        iunlockput(ip);
80105dd0:	83 ec 0c             	sub    $0xc,%esp
80105dd3:	53                   	push   %ebx
80105dd4:	e8 07 c6 ff ff       	call   801023e0 <iunlockput>
        end_op();
80105dd9:	e8 02 d9 ff ff       	call   801036e0 <end_op>
        return -1;
80105dde:	83 c4 10             	add    $0x10,%esp
80105de1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105de6:	eb d7                	jmp    80105dbf <sys_chdir+0x6f>
80105de8:	90                   	nop
80105de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        end_op();
80105df0:	e8 eb d8 ff ff       	call   801036e0 <end_op>
        return -1;
80105df5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dfa:	eb c3                	jmp    80105dbf <sys_chdir+0x6f>
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e00 <sys_exec>:

int sys_exec(void) {
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	57                   	push   %edi
80105e04:	56                   	push   %esi
80105e05:	53                   	push   %ebx
    char *path, *argv[MAXARG];
    int i;
    uint uargv, uarg;

    if (argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
80105e06:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
int sys_exec(void) {
80105e0c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
    if (argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
80105e12:	50                   	push   %eax
80105e13:	6a 00                	push   $0x0
80105e15:	e8 e6 f4 ff ff       	call   80105300 <argstr>
80105e1a:	83 c4 10             	add    $0x10,%esp
80105e1d:	85 c0                	test   %eax,%eax
80105e1f:	0f 88 87 00 00 00    	js     80105eac <sys_exec+0xac>
80105e25:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105e2b:	83 ec 08             	sub    $0x8,%esp
80105e2e:	50                   	push   %eax
80105e2f:	6a 01                	push   $0x1
80105e31:	e8 1a f4 ff ff       	call   80105250 <argint>
80105e36:	83 c4 10             	add    $0x10,%esp
80105e39:	85 c0                	test   %eax,%eax
80105e3b:	78 6f                	js     80105eac <sys_exec+0xac>
        return -1;
    }
    memset(argv, 0, sizeof(argv));
80105e3d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105e43:	83 ec 04             	sub    $0x4,%esp
    for (i = 0;; i++) {
80105e46:	31 db                	xor    %ebx,%ebx
    memset(argv, 0, sizeof(argv));
80105e48:	68 80 00 00 00       	push   $0x80
80105e4d:	6a 00                	push   $0x0
80105e4f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105e55:	50                   	push   %eax
80105e56:	e8 f5 f0 ff ff       	call   80104f50 <memset>
80105e5b:	83 c4 10             	add    $0x10,%esp
80105e5e:	eb 2c                	jmp    80105e8c <sys_exec+0x8c>
            return -1;
        }
        if (fetchint(uargv + 4 * i, (int*)&uarg) < 0) {
            return -1;
        }
        if (uarg == 0) {
80105e60:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105e66:	85 c0                	test   %eax,%eax
80105e68:	74 56                	je     80105ec0 <sys_exec+0xc0>
            argv[i] = 0;
            break;
        }
        if (fetchstr(uarg, &argv[i]) < 0) {
80105e6a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105e70:	83 ec 08             	sub    $0x8,%esp
80105e73:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105e76:	52                   	push   %edx
80105e77:	50                   	push   %eax
80105e78:	e8 63 f3 ff ff       	call   801051e0 <fetchstr>
80105e7d:	83 c4 10             	add    $0x10,%esp
80105e80:	85 c0                	test   %eax,%eax
80105e82:	78 28                	js     80105eac <sys_exec+0xac>
    for (i = 0;; i++) {
80105e84:	83 c3 01             	add    $0x1,%ebx
        if (i >= NELEM(argv)) {
80105e87:	83 fb 20             	cmp    $0x20,%ebx
80105e8a:	74 20                	je     80105eac <sys_exec+0xac>
        if (fetchint(uargv + 4 * i, (int*)&uarg) < 0) {
80105e8c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105e92:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105e99:	83 ec 08             	sub    $0x8,%esp
80105e9c:	57                   	push   %edi
80105e9d:	01 f0                	add    %esi,%eax
80105e9f:	50                   	push   %eax
80105ea0:	e8 fb f2 ff ff       	call   801051a0 <fetchint>
80105ea5:	83 c4 10             	add    $0x10,%esp
80105ea8:	85 c0                	test   %eax,%eax
80105eaa:	79 b4                	jns    80105e60 <sys_exec+0x60>
            return -1;
        }
    }
    return exec(path, argv);
}
80105eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80105eaf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105eb4:	5b                   	pop    %ebx
80105eb5:	5e                   	pop    %esi
80105eb6:	5f                   	pop    %edi
80105eb7:	5d                   	pop    %ebp
80105eb8:	c3                   	ret    
80105eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return exec(path, argv);
80105ec0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ec6:	83 ec 08             	sub    $0x8,%esp
            argv[i] = 0;
80105ec9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ed0:	00 00 00 00 
    return exec(path, argv);
80105ed4:	50                   	push   %eax
80105ed5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105edb:	e8 d0 b5 ff ff       	call   801014b0 <exec>
80105ee0:	83 c4 10             	add    $0x10,%esp
}
80105ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ee6:	5b                   	pop    %ebx
80105ee7:	5e                   	pop    %esi
80105ee8:	5f                   	pop    %edi
80105ee9:	5d                   	pop    %ebp
80105eea:	c3                   	ret    
80105eeb:	90                   	nop
80105eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ef0 <sys_pipe>:

int sys_pipe(void) {
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	57                   	push   %edi
80105ef4:	56                   	push   %esi
80105ef5:	53                   	push   %ebx
    int *fd;
    struct file *rf, *wf;
    int fd0, fd1;

    if (argptr(0, (void*)&fd, 2 * sizeof(fd[0])) < 0) {
80105ef6:	8d 45 dc             	lea    -0x24(%ebp),%eax
int sys_pipe(void) {
80105ef9:	83 ec 20             	sub    $0x20,%esp
    if (argptr(0, (void*)&fd, 2 * sizeof(fd[0])) < 0) {
80105efc:	6a 08                	push   $0x8
80105efe:	50                   	push   %eax
80105eff:	6a 00                	push   $0x0
80105f01:	e8 9a f3 ff ff       	call   801052a0 <argptr>
80105f06:	83 c4 10             	add    $0x10,%esp
80105f09:	85 c0                	test   %eax,%eax
80105f0b:	0f 88 ae 00 00 00    	js     80105fbf <sys_pipe+0xcf>
        return -1;
    }
    if (pipealloc(&rf, &wf) < 0) {
80105f11:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f14:	83 ec 08             	sub    $0x8,%esp
80105f17:	50                   	push   %eax
80105f18:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f1b:	50                   	push   %eax
80105f1c:	e8 3f de ff ff       	call   80103d60 <pipealloc>
80105f21:	83 c4 10             	add    $0x10,%esp
80105f24:	85 c0                	test   %eax,%eax
80105f26:	0f 88 93 00 00 00    	js     80105fbf <sys_pipe+0xcf>
        return -1;
    }
    fd0 = -1;
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
80105f2c:	8b 7d e0             	mov    -0x20(%ebp),%edi
    for (fd = 0; fd < NOFILE; fd++) {
80105f2f:	31 db                	xor    %ebx,%ebx
    struct proc *curproc = myproc();
80105f31:	e8 aa e3 ff ff       	call   801042e0 <myproc>
80105f36:	eb 10                	jmp    80105f48 <sys_pipe+0x58>
80105f38:	90                   	nop
80105f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (fd = 0; fd < NOFILE; fd++) {
80105f40:	83 c3 01             	add    $0x1,%ebx
80105f43:	83 fb 10             	cmp    $0x10,%ebx
80105f46:	74 60                	je     80105fa8 <sys_pipe+0xb8>
        if (curproc->ofile[fd] == 0) {
80105f48:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105f4c:	85 f6                	test   %esi,%esi
80105f4e:	75 f0                	jne    80105f40 <sys_pipe+0x50>
            curproc->ofile[fd] = f;
80105f50:	8d 73 08             	lea    0x8(%ebx),%esi
80105f53:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
80105f57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    struct proc *curproc = myproc();
80105f5a:	e8 81 e3 ff ff       	call   801042e0 <myproc>
    for (fd = 0; fd < NOFILE; fd++) {
80105f5f:	31 d2                	xor    %edx,%edx
80105f61:	eb 0d                	jmp    80105f70 <sys_pipe+0x80>
80105f63:	90                   	nop
80105f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f68:	83 c2 01             	add    $0x1,%edx
80105f6b:	83 fa 10             	cmp    $0x10,%edx
80105f6e:	74 28                	je     80105f98 <sys_pipe+0xa8>
        if (curproc->ofile[fd] == 0) {
80105f70:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105f74:	85 c9                	test   %ecx,%ecx
80105f76:	75 f0                	jne    80105f68 <sys_pipe+0x78>
            curproc->ofile[fd] = f;
80105f78:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
        }
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    fd[0] = fd0;
80105f7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f7f:	89 18                	mov    %ebx,(%eax)
    fd[1] = fd1;
80105f81:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f84:	89 50 04             	mov    %edx,0x4(%eax)
    return 0;
80105f87:	31 c0                	xor    %eax,%eax
}
80105f89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f8c:	5b                   	pop    %ebx
80105f8d:	5e                   	pop    %esi
80105f8e:	5f                   	pop    %edi
80105f8f:	5d                   	pop    %ebp
80105f90:	c3                   	ret    
80105f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            myproc()->ofile[fd0] = 0;
80105f98:	e8 43 e3 ff ff       	call   801042e0 <myproc>
80105f9d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105fa4:	00 
80105fa5:	8d 76 00             	lea    0x0(%esi),%esi
        fileclose(rf);
80105fa8:	83 ec 0c             	sub    $0xc,%esp
80105fab:	ff 75 e0             	pushl  -0x20(%ebp)
80105fae:	e8 5d b9 ff ff       	call   80101910 <fileclose>
        fileclose(wf);
80105fb3:	58                   	pop    %eax
80105fb4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105fb7:	e8 54 b9 ff ff       	call   80101910 <fileclose>
        return -1;
80105fbc:	83 c4 10             	add    $0x10,%esp
80105fbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc4:	eb c3                	jmp    80105f89 <sys_pipe+0x99>
80105fc6:	66 90                	xchg   %ax,%ax
80105fc8:	66 90                	xchg   %ax,%ax
80105fca:	66 90                	xchg   %ax,%ax
80105fcc:	66 90                	xchg   %ax,%ax
80105fce:	66 90                	xchg   %ax,%ax

80105fd0 <sys_fork>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void) {
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
    return fork();
}
80105fd3:	5d                   	pop    %ebp
    return fork();
80105fd4:	e9 a7 e4 ff ff       	jmp    80104480 <fork>
80105fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fe0 <sys_exit>:

int sys_exit(void) {
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	83 ec 08             	sub    $0x8,%esp
    exit();
80105fe6:	e8 15 e7 ff ff       	call   80104700 <exit>
    return 0;  // not reached
}
80105feb:	31 c0                	xor    %eax,%eax
80105fed:	c9                   	leave  
80105fee:	c3                   	ret    
80105fef:	90                   	nop

80105ff0 <sys_wait>:

int sys_wait(void) {
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
    return wait();
}
80105ff3:	5d                   	pop    %ebp
    return wait();
80105ff4:	e9 47 e9 ff ff       	jmp    80104940 <wait>
80105ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106000 <sys_kill>:

int sys_kill(void) {
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	83 ec 20             	sub    $0x20,%esp
    int pid;

    if (argint(0, &pid) < 0) {
80106006:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106009:	50                   	push   %eax
8010600a:	6a 00                	push   $0x0
8010600c:	e8 3f f2 ff ff       	call   80105250 <argint>
80106011:	83 c4 10             	add    $0x10,%esp
80106014:	85 c0                	test   %eax,%eax
80106016:	78 18                	js     80106030 <sys_kill+0x30>
        return -1;
    }
    return kill(pid);
80106018:	83 ec 0c             	sub    $0xc,%esp
8010601b:	ff 75 f4             	pushl  -0xc(%ebp)
8010601e:	e8 6d ea ff ff       	call   80104a90 <kill>
80106023:	83 c4 10             	add    $0x10,%esp
}
80106026:	c9                   	leave  
80106027:	c3                   	ret    
80106028:	90                   	nop
80106029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80106030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106035:	c9                   	leave  
80106036:	c3                   	ret    
80106037:	89 f6                	mov    %esi,%esi
80106039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106040 <sys_getpid>:

int sys_getpid(void) {
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
80106043:	83 ec 08             	sub    $0x8,%esp
    return myproc()->pid;
80106046:	e8 95 e2 ff ff       	call   801042e0 <myproc>
8010604b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010604e:	c9                   	leave  
8010604f:	c3                   	ret    

80106050 <sys_sbrk>:

int sys_sbrk(void) {
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	53                   	push   %ebx
    int addr;
    int n;

    if (argint(0, &n) < 0) {
80106054:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sbrk(void) {
80106057:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0) {
8010605a:	50                   	push   %eax
8010605b:	6a 00                	push   $0x0
8010605d:	e8 ee f1 ff ff       	call   80105250 <argint>
80106062:	83 c4 10             	add    $0x10,%esp
80106065:	85 c0                	test   %eax,%eax
80106067:	78 27                	js     80106090 <sys_sbrk+0x40>
        return -1;
    }
    addr = myproc()->sz;
80106069:	e8 72 e2 ff ff       	call   801042e0 <myproc>
    if (growproc(n) < 0) {
8010606e:	83 ec 0c             	sub    $0xc,%esp
    addr = myproc()->sz;
80106071:	8b 18                	mov    (%eax),%ebx
    if (growproc(n) < 0) {
80106073:	ff 75 f4             	pushl  -0xc(%ebp)
80106076:	e8 85 e3 ff ff       	call   80104400 <growproc>
8010607b:	83 c4 10             	add    $0x10,%esp
8010607e:	85 c0                	test   %eax,%eax
80106080:	78 0e                	js     80106090 <sys_sbrk+0x40>
        return -1;
    }
    return addr;
}
80106082:	89 d8                	mov    %ebx,%eax
80106084:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106087:	c9                   	leave  
80106088:	c3                   	ret    
80106089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80106090:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106095:	eb eb                	jmp    80106082 <sys_sbrk+0x32>
80106097:	89 f6                	mov    %esi,%esi
80106099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801060a0 <sys_sleep>:

int sys_sleep(void) {
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	53                   	push   %ebx
    int n;
    uint ticks0;

    if (argint(0, &n) < 0) {
801060a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sleep(void) {
801060a7:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0) {
801060aa:	50                   	push   %eax
801060ab:	6a 00                	push   $0x0
801060ad:	e8 9e f1 ff ff       	call   80105250 <argint>
801060b2:	83 c4 10             	add    $0x10,%esp
801060b5:	85 c0                	test   %eax,%eax
801060b7:	0f 88 8a 00 00 00    	js     80106147 <sys_sleep+0xa7>
        return -1;
    }
    acquire(&tickslock);
801060bd:	83 ec 0c             	sub    $0xc,%esp
801060c0:	68 40 74 11 80       	push   $0x80117440
801060c5:	e8 76 ed ff ff       	call   80104e40 <acquire>
    ticks0 = ticks;
    while (ticks - ticks0 < n) {
801060ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060cd:	83 c4 10             	add    $0x10,%esp
    ticks0 = ticks;
801060d0:	8b 1d 80 7c 11 80    	mov    0x80117c80,%ebx
    while (ticks - ticks0 < n) {
801060d6:	85 d2                	test   %edx,%edx
801060d8:	75 27                	jne    80106101 <sys_sleep+0x61>
801060da:	eb 54                	jmp    80106130 <sys_sleep+0x90>
801060dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (myproc()->killed) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
801060e0:	83 ec 08             	sub    $0x8,%esp
801060e3:	68 40 74 11 80       	push   $0x80117440
801060e8:	68 80 7c 11 80       	push   $0x80117c80
801060ed:	e8 8e e7 ff ff       	call   80104880 <sleep>
    while (ticks - ticks0 < n) {
801060f2:	a1 80 7c 11 80       	mov    0x80117c80,%eax
801060f7:	83 c4 10             	add    $0x10,%esp
801060fa:	29 d8                	sub    %ebx,%eax
801060fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801060ff:	73 2f                	jae    80106130 <sys_sleep+0x90>
        if (myproc()->killed) {
80106101:	e8 da e1 ff ff       	call   801042e0 <myproc>
80106106:	8b 40 24             	mov    0x24(%eax),%eax
80106109:	85 c0                	test   %eax,%eax
8010610b:	74 d3                	je     801060e0 <sys_sleep+0x40>
            release(&tickslock);
8010610d:	83 ec 0c             	sub    $0xc,%esp
80106110:	68 40 74 11 80       	push   $0x80117440
80106115:	e8 e6 ed ff ff       	call   80104f00 <release>
            return -1;
8010611a:	83 c4 10             	add    $0x10,%esp
8010611d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    release(&tickslock);
    return 0;
}
80106122:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106125:	c9                   	leave  
80106126:	c3                   	ret    
80106127:	89 f6                	mov    %esi,%esi
80106129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&tickslock);
80106130:	83 ec 0c             	sub    $0xc,%esp
80106133:	68 40 74 11 80       	push   $0x80117440
80106138:	e8 c3 ed ff ff       	call   80104f00 <release>
    return 0;
8010613d:	83 c4 10             	add    $0x10,%esp
80106140:	31 c0                	xor    %eax,%eax
}
80106142:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106145:	c9                   	leave  
80106146:	c3                   	ret    
        return -1;
80106147:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010614c:	eb f4                	jmp    80106142 <sys_sleep+0xa2>
8010614e:	66 90                	xchg   %ax,%ax

80106150 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void) {
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	53                   	push   %ebx
80106154:	83 ec 10             	sub    $0x10,%esp
    uint xticks;

    acquire(&tickslock);
80106157:	68 40 74 11 80       	push   $0x80117440
8010615c:	e8 df ec ff ff       	call   80104e40 <acquire>
    xticks = ticks;
80106161:	8b 1d 80 7c 11 80    	mov    0x80117c80,%ebx
    release(&tickslock);
80106167:	c7 04 24 40 74 11 80 	movl   $0x80117440,(%esp)
8010616e:	e8 8d ed ff ff       	call   80104f00 <release>
    return xticks;
}
80106173:	89 d8                	mov    %ebx,%eax
80106175:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106178:	c9                   	leave  
80106179:	c3                   	ret    
8010617a:	66 90                	xchg   %ax,%ax
8010617c:	66 90                	xchg   %ax,%ax
8010617e:	66 90                	xchg   %ax,%ax

80106180 <sys_getch>:
#include "types.h"
#include "defs.h"

int sys_getch(void) {
80106180:	55                   	push   %ebp
80106181:	89 e5                	mov    %esp,%ebp
    return consoleget();
}
80106183:	5d                   	pop    %ebp
    return consoleget();
80106184:	e9 87 a8 ff ff       	jmp    80100a10 <consoleget>
80106189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106190 <sys_greeting>:

int sys_greeting(void)
{
80106190:	55                   	push   %ebp
80106191:	89 e5                	mov    %esp,%ebp
80106193:	83 ec 14             	sub    $0x14,%esp
    cprintf("Hello, user\n");
80106196:	68 19 83 10 80       	push   $0x80108319
8010619b:	e8 c0 a6 ff ff       	call   80100860 <cprintf>
 
    return 0;
}
801061a0:	31 c0                	xor    %eax,%eax
801061a2:	c9                   	leave  
801061a3:	c3                   	ret    
801061a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801061aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801061b0 <sys_videomodevga13>:

int sys_videomodevga13(void)
{
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
801061b3:	83 ec 14             	sub    $0x14,%esp
    consolevgamode(0x13);
801061b6:	6a 13                	push   $0x13
801061b8:	e8 a3 ac ff ff       	call   80100e60 <consolevgamode>
    cprintf("VGA Mode Set to 0x13\n");
801061bd:	c7 04 24 26 83 10 80 	movl   $0x80108326,(%esp)
801061c4:	e8 97 a6 ff ff       	call   80100860 <cprintf>
    return 0;
}
801061c9:	31 c0                	xor    %eax,%eax
801061cb:	c9                   	leave  
801061cc:	c3                   	ret    
801061cd:	8d 76 00             	lea    0x0(%esi),%esi

801061d0 <sys_videomodevga12>:
int sys_videomodevga12(void)
{
801061d0:	55                   	push   %ebp
801061d1:	89 e5                	mov    %esp,%ebp
801061d3:	83 ec 14             	sub    $0x14,%esp
    consolevgamode(0x12);
801061d6:	6a 12                	push   $0x12
801061d8:	e8 83 ac ff ff       	call   80100e60 <consolevgamode>
    cprintf("VGA Mode set to 0x12\n");
801061dd:	c7 04 24 3c 83 10 80 	movl   $0x8010833c,(%esp)
801061e4:	e8 77 a6 ff ff       	call   80100860 <cprintf>
    return 0;
}
801061e9:	31 c0                	xor    %eax,%eax
801061eb:	c9                   	leave  
801061ec:	c3                   	ret    
801061ed:	8d 76 00             	lea    0x0(%esi),%esi

801061f0 <sys_videomodetext>:
int sys_videomodetext(void)
{
801061f0:	55                   	push   %ebp
801061f1:	89 e5                	mov    %esp,%ebp
801061f3:	83 ec 14             	sub    $0x14,%esp
    cprintf("VGA Mode Set to 0x03\n");
801061f6:	68 52 83 10 80       	push   $0x80108352
801061fb:	e8 60 a6 ff ff       	call   80100860 <cprintf>
    consolevgamode(0x03);
80106200:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
80106207:	e8 54 ac ff ff       	call   80100e60 <consolevgamode>
    return 0;
}
8010620c:	31 c0                	xor    %eax,%eax
8010620e:	c9                   	leave  
8010620f:	c3                   	ret    

80106210 <sys_setspecificpixel>:

//int x, int y, unsigned char VGA_colour
int sys_setspecificpixel(void)
{
80106210:	55                   	push   %ebp
80106211:	89 e5                	mov    %esp,%ebp
80106213:	83 ec 20             	sub    $0x20,%esp
    int x;
    int y;
    int VGA_colour;
    argint(2, &VGA_colour);
80106216:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106219:	50                   	push   %eax
8010621a:	6a 02                	push   $0x2
8010621c:	e8 2f f0 ff ff       	call   80105250 <argint>
    argint(1, &y);
80106221:	58                   	pop    %eax
80106222:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106225:	5a                   	pop    %edx
80106226:	50                   	push   %eax
80106227:	6a 01                	push   $0x1
80106229:	e8 22 f0 ff ff       	call   80105250 <argint>
    argint(0, &x);
8010622e:	59                   	pop    %ecx
8010622f:	58                   	pop    %eax
80106230:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106233:	50                   	push   %eax
80106234:	6a 00                	push   $0x0
80106236:	e8 15 f0 ff ff       	call   80105250 <argint>

    setpixel(x,y,VGA_colour);
8010623b:	83 c4 0c             	add    $0xc,%esp
8010623e:	ff 75 f4             	pushl  -0xc(%ebp)
80106241:	ff 75 f0             	pushl  -0x10(%ebp)
80106244:	ff 75 ec             	pushl  -0x14(%ebp)
80106247:	e8 a4 ad ff ff       	call   80100ff0 <setpixel>
    return 0;
}
8010624c:	31 c0                	xor    %eax,%eax
8010624e:	c9                   	leave  
8010624f:	c3                   	ret    

80106250 <sys_clearscreen13h>:

int sys_clearscreen13h(void)
{
80106250:	55                   	push   %ebp
80106251:	89 e5                	mov    %esp,%ebp
80106253:	83 ec 08             	sub    $0x8,%esp
    zeroFillScreen13h();
80106256:	e8 15 b1 ff ff       	call   80101370 <zeroFillScreen13h>
    return 0;
}
8010625b:	31 c0                	xor    %eax,%eax
8010625d:	c9                   	leave  
8010625e:	c3                   	ret    
8010625f:	90                   	nop

80106260 <sys_clearscreen12h>:
int sys_clearscreen12h(void)
{
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	83 ec 08             	sub    $0x8,%esp
    zeroFillScreen12h();
80106266:	e8 35 b1 ff ff       	call   801013a0 <zeroFillScreen12h>
    return 0;
}
8010626b:	31 c0                	xor    %eax,%eax
8010626d:	c9                   	leave  
8010626e:	c3                   	ret    

8010626f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
    pushl %ds
8010626f:	1e                   	push   %ds
    pushl %es
80106270:	06                   	push   %es
    pushl %fs
80106271:	0f a0                	push   %fs
    pushl %gs
80106273:	0f a8                	push   %gs
    pushal
80106275:	60                   	pusha  
  
    # Set up data segments.
    movw $(SEG_KDATA<<3), %ax
80106276:	66 b8 10 00          	mov    $0x10,%ax
    movw %ax, %ds
8010627a:	8e d8                	mov    %eax,%ds
    movw %ax, %es
8010627c:	8e c0                	mov    %eax,%es

    # Call trap(tf), where tf=%esp
    pushl %esp
8010627e:	54                   	push   %esp
    call trap
8010627f:	e8 cc 00 00 00       	call   80106350 <trap>
    addl $4, %esp
80106284:	83 c4 04             	add    $0x4,%esp

80106287 <trapret>:

    # Return falls through to trapret...
.globl trapret
trapret:
    popal
80106287:	61                   	popa   
    popl %gs
80106288:	0f a9                	pop    %gs
    popl %fs
8010628a:	0f a1                	pop    %fs
    popl %es
8010628c:	07                   	pop    %es
    popl %ds
8010628d:	1f                   	pop    %ds
    addl $0x8, %esp  # trapno and errcode
8010628e:	83 c4 08             	add    $0x8,%esp
    iret
80106291:	cf                   	iret   
80106292:	66 90                	xchg   %ax,%ax
80106294:	66 90                	xchg   %ax,%ax
80106296:	66 90                	xchg   %ax,%ax
80106298:	66 90                	xchg   %ax,%ax
8010629a:	66 90                	xchg   %ax,%ax
8010629c:	66 90                	xchg   %ax,%ax
8010629e:	66 90                	xchg   %ax,%ax

801062a0 <tvinit>:
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void) {
801062a0:	55                   	push   %ebp
    int i;

    for (i = 0; i < 256; i++) {
801062a1:	31 c0                	xor    %eax,%eax
void tvinit(void) {
801062a3:	89 e5                	mov    %esp,%ebp
801062a5:	83 ec 08             	sub    $0x8,%esp
801062a8:	90                   	nop
801062a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
801062b0:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
801062b7:	c7 04 c5 82 74 11 80 	movl   $0x8e000008,-0x7fee8b7e(,%eax,8)
801062be:	08 00 00 8e 
801062c2:	66 89 14 c5 80 74 11 	mov    %dx,-0x7fee8b80(,%eax,8)
801062c9:	80 
801062ca:	c1 ea 10             	shr    $0x10,%edx
801062cd:	66 89 14 c5 86 74 11 	mov    %dx,-0x7fee8b7a(,%eax,8)
801062d4:	80 
    for (i = 0; i < 256; i++) {
801062d5:	83 c0 01             	add    $0x1,%eax
801062d8:	3d 00 01 00 00       	cmp    $0x100,%eax
801062dd:	75 d1                	jne    801062b0 <tvinit+0x10>
    }
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801062df:	a1 08 c1 10 80       	mov    0x8010c108,%eax

    initlock(&tickslock, "time");
801062e4:	83 ec 08             	sub    $0x8,%esp
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801062e7:	c7 05 82 76 11 80 08 	movl   $0xef000008,0x80117682
801062ee:	00 00 ef 
    initlock(&tickslock, "time");
801062f1:	68 68 83 10 80       	push   $0x80108368
801062f6:	68 40 74 11 80       	push   $0x80117440
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
801062fb:	66 a3 80 76 11 80    	mov    %ax,0x80117680
80106301:	c1 e8 10             	shr    $0x10,%eax
80106304:	66 a3 86 76 11 80    	mov    %ax,0x80117686
    initlock(&tickslock, "time");
8010630a:	e8 f1 e9 ff ff       	call   80104d00 <initlock>
}
8010630f:	83 c4 10             	add    $0x10,%esp
80106312:	c9                   	leave  
80106313:	c3                   	ret    
80106314:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010631a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106320 <idtinit>:

void idtinit(void) {
80106320:	55                   	push   %ebp
    pd[0] = size - 1;
80106321:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106326:	89 e5                	mov    %esp,%ebp
80106328:	83 ec 10             	sub    $0x10,%esp
8010632b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    pd[1] = (uint)p;
8010632f:	b8 80 74 11 80       	mov    $0x80117480,%eax
80106334:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    pd[2] = (uint)p >> 16;
80106338:	c1 e8 10             	shr    $0x10,%eax
8010633b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    asm volatile ("lidt (%0)" : : "r" (pd));
8010633f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106342:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
80106345:	c9                   	leave  
80106346:	c3                   	ret    
80106347:	89 f6                	mov    %esi,%esi
80106349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106350 <trap>:

void trap(struct trapframe *tf) {
80106350:	55                   	push   %ebp
80106351:	89 e5                	mov    %esp,%ebp
80106353:	57                   	push   %edi
80106354:	56                   	push   %esi
80106355:	53                   	push   %ebx
80106356:	83 ec 1c             	sub    $0x1c,%esp
80106359:	8b 7d 08             	mov    0x8(%ebp),%edi
    if (tf->trapno == T_SYSCALL) {
8010635c:	8b 47 30             	mov    0x30(%edi),%eax
8010635f:	83 f8 40             	cmp    $0x40,%eax
80106362:	0f 84 f0 00 00 00    	je     80106458 <trap+0x108>
            exit();
        }
        return;
    }

    switch (tf->trapno) {
80106368:	83 e8 20             	sub    $0x20,%eax
8010636b:	83 f8 1f             	cmp    $0x1f,%eax
8010636e:	77 10                	ja     80106380 <trap+0x30>
80106370:	ff 24 85 10 84 10 80 	jmp    *-0x7fef7bf0(,%eax,4)
80106377:	89 f6                	mov    %esi,%esi
80106379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            lapiceoi();
            break;

    
        default:
            if (myproc() == 0 || (tf->cs & 3) == 0) {
80106380:	e8 5b df ff ff       	call   801042e0 <myproc>
80106385:	85 c0                	test   %eax,%eax
80106387:	8b 5f 38             	mov    0x38(%edi),%ebx
8010638a:	0f 84 14 02 00 00    	je     801065a4 <trap+0x254>
80106390:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106394:	0f 84 0a 02 00 00    	je     801065a4 <trap+0x254>
    return result;
}

static inline uint rcr2(void) {
    uint val;
    asm volatile ("movl %%cr2,%0" : "=r" (val));
8010639a:	0f 20 d1             	mov    %cr2,%ecx
8010639d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
801063a0:	e8 1b df ff ff       	call   801042c0 <cpuid>
801063a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
801063a8:	8b 47 34             	mov    0x34(%edi),%eax
801063ab:	8b 77 30             	mov    0x30(%edi),%esi
801063ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                    "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
801063b1:	e8 2a df ff ff       	call   801042e0 <myproc>
801063b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801063b9:	e8 22 df ff ff       	call   801042e0 <myproc>
            cprintf("pid %d %s: trap %d err %d on cpu %d "
801063be:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801063c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801063c4:	51                   	push   %ecx
801063c5:	53                   	push   %ebx
801063c6:	52                   	push   %edx
                    myproc()->pid, myproc()->name, tf->trapno,
801063c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
801063ca:	ff 75 e4             	pushl  -0x1c(%ebp)
801063cd:	56                   	push   %esi
                    myproc()->pid, myproc()->name, tf->trapno,
801063ce:	83 c2 6c             	add    $0x6c,%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
801063d1:	52                   	push   %edx
801063d2:	ff 70 10             	pushl  0x10(%eax)
801063d5:	68 cc 83 10 80       	push   $0x801083cc
801063da:	e8 81 a4 ff ff       	call   80100860 <cprintf>
                    tf->err, cpuid(), tf->eip, rcr2());
            myproc()->killed = 1;
801063df:	83 c4 20             	add    $0x20,%esp
801063e2:	e8 f9 de ff ff       	call   801042e0 <myproc>
801063e7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
801063ee:	e8 ed de ff ff       	call   801042e0 <myproc>
801063f3:	85 c0                	test   %eax,%eax
801063f5:	74 1d                	je     80106414 <trap+0xc4>
801063f7:	e8 e4 de ff ff       	call   801042e0 <myproc>
801063fc:	8b 50 24             	mov    0x24(%eax),%edx
801063ff:	85 d2                	test   %edx,%edx
80106401:	74 11                	je     80106414 <trap+0xc4>
80106403:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106407:	83 e0 03             	and    $0x3,%eax
8010640a:	66 83 f8 03          	cmp    $0x3,%ax
8010640e:	0f 84 4c 01 00 00    	je     80106560 <trap+0x210>
        exit();
    }

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
80106414:	e8 c7 de ff ff       	call   801042e0 <myproc>
80106419:	85 c0                	test   %eax,%eax
8010641b:	74 0b                	je     80106428 <trap+0xd8>
8010641d:	e8 be de ff ff       	call   801042e0 <myproc>
80106422:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106426:	74 68                	je     80106490 <trap+0x140>
        tf->trapno == T_IRQ0 + IRQ_TIMER) {
        yield();
    }

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
80106428:	e8 b3 de ff ff       	call   801042e0 <myproc>
8010642d:	85 c0                	test   %eax,%eax
8010642f:	74 19                	je     8010644a <trap+0xfa>
80106431:	e8 aa de ff ff       	call   801042e0 <myproc>
80106436:	8b 40 24             	mov    0x24(%eax),%eax
80106439:	85 c0                	test   %eax,%eax
8010643b:	74 0d                	je     8010644a <trap+0xfa>
8010643d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106441:	83 e0 03             	and    $0x3,%eax
80106444:	66 83 f8 03          	cmp    $0x3,%ax
80106448:	74 37                	je     80106481 <trap+0x131>
        exit();
    }
}
8010644a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010644d:	5b                   	pop    %ebx
8010644e:	5e                   	pop    %esi
8010644f:	5f                   	pop    %edi
80106450:	5d                   	pop    %ebp
80106451:	c3                   	ret    
80106452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (myproc()->killed) {
80106458:	e8 83 de ff ff       	call   801042e0 <myproc>
8010645d:	8b 58 24             	mov    0x24(%eax),%ebx
80106460:	85 db                	test   %ebx,%ebx
80106462:	0f 85 e8 00 00 00    	jne    80106550 <trap+0x200>
        myproc()->tf = tf;
80106468:	e8 73 de ff ff       	call   801042e0 <myproc>
8010646d:	89 78 18             	mov    %edi,0x18(%eax)
        syscall();
80106470:	e8 cb ee ff ff       	call   80105340 <syscall>
        if (myproc()->killed) {
80106475:	e8 66 de ff ff       	call   801042e0 <myproc>
8010647a:	8b 48 24             	mov    0x24(%eax),%ecx
8010647d:	85 c9                	test   %ecx,%ecx
8010647f:	74 c9                	je     8010644a <trap+0xfa>
}
80106481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106484:	5b                   	pop    %ebx
80106485:	5e                   	pop    %esi
80106486:	5f                   	pop    %edi
80106487:	5d                   	pop    %ebp
            exit();
80106488:	e9 73 e2 ff ff       	jmp    80104700 <exit>
8010648d:	8d 76 00             	lea    0x0(%esi),%esi
    if (myproc() && myproc()->state == RUNNING &&
80106490:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106494:	75 92                	jne    80106428 <trap+0xd8>
        yield();
80106496:	e8 95 e3 ff ff       	call   80104830 <yield>
8010649b:	eb 8b                	jmp    80106428 <trap+0xd8>
8010649d:	8d 76 00             	lea    0x0(%esi),%esi
            if (cpuid() == 0) {
801064a0:	e8 1b de ff ff       	call   801042c0 <cpuid>
801064a5:	85 c0                	test   %eax,%eax
801064a7:	0f 84 c3 00 00 00    	je     80106570 <trap+0x220>
            lapiceoi();
801064ad:	e8 6e cd ff ff       	call   80103220 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
801064b2:	e8 29 de ff ff       	call   801042e0 <myproc>
801064b7:	85 c0                	test   %eax,%eax
801064b9:	0f 85 38 ff ff ff    	jne    801063f7 <trap+0xa7>
801064bf:	e9 50 ff ff ff       	jmp    80106414 <trap+0xc4>
801064c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            kbdintr();
801064c8:	e8 13 cc ff ff       	call   801030e0 <kbdintr>
            lapiceoi();
801064cd:	e8 4e cd ff ff       	call   80103220 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
801064d2:	e8 09 de ff ff       	call   801042e0 <myproc>
801064d7:	85 c0                	test   %eax,%eax
801064d9:	0f 85 18 ff ff ff    	jne    801063f7 <trap+0xa7>
801064df:	e9 30 ff ff ff       	jmp    80106414 <trap+0xc4>
801064e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            uartintr();
801064e8:	e8 53 02 00 00       	call   80106740 <uartintr>
            lapiceoi();
801064ed:	e8 2e cd ff ff       	call   80103220 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
801064f2:	e8 e9 dd ff ff       	call   801042e0 <myproc>
801064f7:	85 c0                	test   %eax,%eax
801064f9:	0f 85 f8 fe ff ff    	jne    801063f7 <trap+0xa7>
801064ff:	e9 10 ff ff ff       	jmp    80106414 <trap+0xc4>
80106504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106508:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010650c:	8b 77 38             	mov    0x38(%edi),%esi
8010650f:	e8 ac dd ff ff       	call   801042c0 <cpuid>
80106514:	56                   	push   %esi
80106515:	53                   	push   %ebx
80106516:	50                   	push   %eax
80106517:	68 74 83 10 80       	push   $0x80108374
8010651c:	e8 3f a3 ff ff       	call   80100860 <cprintf>
            lapiceoi();
80106521:	e8 fa cc ff ff       	call   80103220 <lapiceoi>
            break;
80106526:	83 c4 10             	add    $0x10,%esp
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
80106529:	e8 b2 dd ff ff       	call   801042e0 <myproc>
8010652e:	85 c0                	test   %eax,%eax
80106530:	0f 85 c1 fe ff ff    	jne    801063f7 <trap+0xa7>
80106536:	e9 d9 fe ff ff       	jmp    80106414 <trap+0xc4>
8010653b:	90                   	nop
8010653c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            ideintr();
80106540:	e8 0b c6 ff ff       	call   80102b50 <ideintr>
80106545:	e9 63 ff ff ff       	jmp    801064ad <trap+0x15d>
8010654a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            exit();
80106550:	e8 ab e1 ff ff       	call   80104700 <exit>
80106555:	e9 0e ff ff ff       	jmp    80106468 <trap+0x118>
8010655a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        exit();
80106560:	e8 9b e1 ff ff       	call   80104700 <exit>
80106565:	e9 aa fe ff ff       	jmp    80106414 <trap+0xc4>
8010656a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                acquire(&tickslock);
80106570:	83 ec 0c             	sub    $0xc,%esp
80106573:	68 40 74 11 80       	push   $0x80117440
80106578:	e8 c3 e8 ff ff       	call   80104e40 <acquire>
                wakeup(&ticks);
8010657d:	c7 04 24 80 7c 11 80 	movl   $0x80117c80,(%esp)
                ticks++;
80106584:	83 05 80 7c 11 80 01 	addl   $0x1,0x80117c80
                wakeup(&ticks);
8010658b:	e8 a0 e4 ff ff       	call   80104a30 <wakeup>
                release(&tickslock);
80106590:	c7 04 24 40 74 11 80 	movl   $0x80117440,(%esp)
80106597:	e8 64 e9 ff ff       	call   80104f00 <release>
8010659c:	83 c4 10             	add    $0x10,%esp
8010659f:	e9 09 ff ff ff       	jmp    801064ad <trap+0x15d>
801065a4:	0f 20 d6             	mov    %cr2,%esi
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801065a7:	e8 14 dd ff ff       	call   801042c0 <cpuid>
801065ac:	83 ec 0c             	sub    $0xc,%esp
801065af:	56                   	push   %esi
801065b0:	53                   	push   %ebx
801065b1:	50                   	push   %eax
801065b2:	ff 77 30             	pushl  0x30(%edi)
801065b5:	68 98 83 10 80       	push   $0x80108398
801065ba:	e8 a1 a2 ff ff       	call   80100860 <cprintf>
                panic("trap");
801065bf:	83 c4 14             	add    $0x14,%esp
801065c2:	68 6d 83 10 80       	push   $0x8010836d
801065c7:	e8 14 9f ff ff       	call   801004e0 <panic>
801065cc:	66 90                	xchg   %ax,%ax
801065ce:	66 90                	xchg   %ax,%ax

801065d0 <uartgetc>:
    }
    outb(COM1 + 0, c);
}

static int uartgetc(void)            {
    if (!uart) {
801065d0:	a1 bc c5 10 80       	mov    0x8010c5bc,%eax
static int uartgetc(void)            {
801065d5:	55                   	push   %ebp
801065d6:	89 e5                	mov    %esp,%ebp
    if (!uart) {
801065d8:	85 c0                	test   %eax,%eax
801065da:	74 1c                	je     801065f8 <uartgetc+0x28>
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801065dc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801065e1:	ec                   	in     (%dx),%al
        return -1;
    }
    if (!(inb(COM1 + 5) & 0x01)) {
801065e2:	a8 01                	test   $0x1,%al
801065e4:	74 12                	je     801065f8 <uartgetc+0x28>
801065e6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065eb:	ec                   	in     (%dx),%al
        return -1;
    }
    return inb(COM1 + 0);
801065ec:	0f b6 c0             	movzbl %al,%eax
}
801065ef:	5d                   	pop    %ebp
801065f0:	c3                   	ret    
801065f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801065f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065fd:	5d                   	pop    %ebp
801065fe:	c3                   	ret    
801065ff:	90                   	nop

80106600 <uartputc.part.0>:
void uartputc(int c) {
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	57                   	push   %edi
80106604:	56                   	push   %esi
80106605:	53                   	push   %ebx
80106606:	89 c7                	mov    %eax,%edi
80106608:	bb 80 00 00 00       	mov    $0x80,%ebx
8010660d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106612:	83 ec 0c             	sub    $0xc,%esp
80106615:	eb 1b                	jmp    80106632 <uartputc.part.0+0x32>
80106617:	89 f6                	mov    %esi,%esi
80106619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        microdelay(10);
80106620:	83 ec 0c             	sub    $0xc,%esp
80106623:	6a 0a                	push   $0xa
80106625:	e8 16 cc ff ff       	call   80103240 <microdelay>
    for (i = 0; i < 128 && !(inb(COM1 + 5) & 0x20); i++) {
8010662a:	83 c4 10             	add    $0x10,%esp
8010662d:	83 eb 01             	sub    $0x1,%ebx
80106630:	74 07                	je     80106639 <uartputc.part.0+0x39>
80106632:	89 f2                	mov    %esi,%edx
80106634:	ec                   	in     (%dx),%al
80106635:	a8 20                	test   $0x20,%al
80106637:	74 e7                	je     80106620 <uartputc.part.0+0x20>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80106639:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010663e:	89 f8                	mov    %edi,%eax
80106640:	ee                   	out    %al,(%dx)
}
80106641:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106644:	5b                   	pop    %ebx
80106645:	5e                   	pop    %esi
80106646:	5f                   	pop    %edi
80106647:	5d                   	pop    %ebp
80106648:	c3                   	ret    
80106649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106650 <uartinit>:
void uartinit(void) {
80106650:	55                   	push   %ebp
80106651:	31 c9                	xor    %ecx,%ecx
80106653:	89 c8                	mov    %ecx,%eax
80106655:	89 e5                	mov    %esp,%ebp
80106657:	57                   	push   %edi
80106658:	56                   	push   %esi
80106659:	53                   	push   %ebx
8010665a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010665f:	89 da                	mov    %ebx,%edx
80106661:	83 ec 0c             	sub    $0xc,%esp
80106664:	ee                   	out    %al,(%dx)
80106665:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010666a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010666f:	89 fa                	mov    %edi,%edx
80106671:	ee                   	out    %al,(%dx)
80106672:	b8 0c 00 00 00       	mov    $0xc,%eax
80106677:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010667c:	ee                   	out    %al,(%dx)
8010667d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106682:	89 c8                	mov    %ecx,%eax
80106684:	89 f2                	mov    %esi,%edx
80106686:	ee                   	out    %al,(%dx)
80106687:	b8 03 00 00 00       	mov    $0x3,%eax
8010668c:	89 fa                	mov    %edi,%edx
8010668e:	ee                   	out    %al,(%dx)
8010668f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106694:	89 c8                	mov    %ecx,%eax
80106696:	ee                   	out    %al,(%dx)
80106697:	b8 01 00 00 00       	mov    $0x1,%eax
8010669c:	89 f2                	mov    %esi,%edx
8010669e:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
8010669f:	ba fd 03 00 00       	mov    $0x3fd,%edx
801066a4:	ec                   	in     (%dx),%al
    if (inb(COM1 + 5) == 0xFF) {
801066a5:	3c ff                	cmp    $0xff,%al
801066a7:	74 5a                	je     80106703 <uartinit+0xb3>
    uart = 1;
801066a9:	c7 05 bc c5 10 80 01 	movl   $0x1,0x8010c5bc
801066b0:	00 00 00 
801066b3:	89 da                	mov    %ebx,%edx
801066b5:	ec                   	in     (%dx),%al
801066b6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066bb:	ec                   	in     (%dx),%al
    ioapicenable(IRQ_COM1, 0);
801066bc:	83 ec 08             	sub    $0x8,%esp
    for (p = "xv6...\n"; *p; p++) {
801066bf:	bb 90 84 10 80       	mov    $0x80108490,%ebx
    ioapicenable(IRQ_COM1, 0);
801066c4:	6a 00                	push   $0x0
801066c6:	6a 04                	push   $0x4
801066c8:	e8 d3 c6 ff ff       	call   80102da0 <ioapicenable>
801066cd:	83 c4 10             	add    $0x10,%esp
    for (p = "xv6...\n"; *p; p++) {
801066d0:	b8 78 00 00 00       	mov    $0x78,%eax
801066d5:	eb 13                	jmp    801066ea <uartinit+0x9a>
801066d7:	89 f6                	mov    %esi,%esi
801066d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801066e0:	83 c3 01             	add    $0x1,%ebx
801066e3:	0f be 03             	movsbl (%ebx),%eax
801066e6:	84 c0                	test   %al,%al
801066e8:	74 19                	je     80106703 <uartinit+0xb3>
    if (!uart) {
801066ea:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
801066f0:	85 d2                	test   %edx,%edx
801066f2:	74 ec                	je     801066e0 <uartinit+0x90>
    for (p = "xv6...\n"; *p; p++) {
801066f4:	83 c3 01             	add    $0x1,%ebx
801066f7:	e8 04 ff ff ff       	call   80106600 <uartputc.part.0>
801066fc:	0f be 03             	movsbl (%ebx),%eax
801066ff:	84 c0                	test   %al,%al
80106701:	75 e7                	jne    801066ea <uartinit+0x9a>
}
80106703:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106706:	5b                   	pop    %ebx
80106707:	5e                   	pop    %esi
80106708:	5f                   	pop    %edi
80106709:	5d                   	pop    %ebp
8010670a:	c3                   	ret    
8010670b:	90                   	nop
8010670c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106710 <uartputc>:
    if (!uart) {
80106710:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
void uartputc(int c) {
80106716:	55                   	push   %ebp
80106717:	89 e5                	mov    %esp,%ebp
    if (!uart) {
80106719:	85 d2                	test   %edx,%edx
void uartputc(int c) {
8010671b:	8b 45 08             	mov    0x8(%ebp),%eax
    if (!uart) {
8010671e:	74 10                	je     80106730 <uartputc+0x20>
}
80106720:	5d                   	pop    %ebp
80106721:	e9 da fe ff ff       	jmp    80106600 <uartputc.part.0>
80106726:	8d 76 00             	lea    0x0(%esi),%esi
80106729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106730:	5d                   	pop    %ebp
80106731:	c3                   	ret    
80106732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106740 <uartintr>:

void uartintr(void) {
80106740:	55                   	push   %ebp
80106741:	89 e5                	mov    %esp,%ebp
80106743:	83 ec 14             	sub    $0x14,%esp
    consoleintr(uartgetc);
80106746:	68 d0 65 10 80       	push   $0x801065d0
8010674b:	e8 10 a3 ff ff       	call   80100a60 <consoleintr>
}
80106750:	83 c4 10             	add    $0x10,%esp
80106753:	c9                   	leave  
80106754:	c3                   	ret    

80106755 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106755:	6a 00                	push   $0x0
  pushl $0
80106757:	6a 00                	push   $0x0
  jmp alltraps
80106759:	e9 11 fb ff ff       	jmp    8010626f <alltraps>

8010675e <vector1>:
.globl vector1
vector1:
  pushl $0
8010675e:	6a 00                	push   $0x0
  pushl $1
80106760:	6a 01                	push   $0x1
  jmp alltraps
80106762:	e9 08 fb ff ff       	jmp    8010626f <alltraps>

80106767 <vector2>:
.globl vector2
vector2:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $2
80106769:	6a 02                	push   $0x2
  jmp alltraps
8010676b:	e9 ff fa ff ff       	jmp    8010626f <alltraps>

80106770 <vector3>:
.globl vector3
vector3:
  pushl $0
80106770:	6a 00                	push   $0x0
  pushl $3
80106772:	6a 03                	push   $0x3
  jmp alltraps
80106774:	e9 f6 fa ff ff       	jmp    8010626f <alltraps>

80106779 <vector4>:
.globl vector4
vector4:
  pushl $0
80106779:	6a 00                	push   $0x0
  pushl $4
8010677b:	6a 04                	push   $0x4
  jmp alltraps
8010677d:	e9 ed fa ff ff       	jmp    8010626f <alltraps>

80106782 <vector5>:
.globl vector5
vector5:
  pushl $0
80106782:	6a 00                	push   $0x0
  pushl $5
80106784:	6a 05                	push   $0x5
  jmp alltraps
80106786:	e9 e4 fa ff ff       	jmp    8010626f <alltraps>

8010678b <vector6>:
.globl vector6
vector6:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $6
8010678d:	6a 06                	push   $0x6
  jmp alltraps
8010678f:	e9 db fa ff ff       	jmp    8010626f <alltraps>

80106794 <vector7>:
.globl vector7
vector7:
  pushl $0
80106794:	6a 00                	push   $0x0
  pushl $7
80106796:	6a 07                	push   $0x7
  jmp alltraps
80106798:	e9 d2 fa ff ff       	jmp    8010626f <alltraps>

8010679d <vector8>:
.globl vector8
vector8:
  pushl $8
8010679d:	6a 08                	push   $0x8
  jmp alltraps
8010679f:	e9 cb fa ff ff       	jmp    8010626f <alltraps>

801067a4 <vector9>:
.globl vector9
vector9:
  pushl $0
801067a4:	6a 00                	push   $0x0
  pushl $9
801067a6:	6a 09                	push   $0x9
  jmp alltraps
801067a8:	e9 c2 fa ff ff       	jmp    8010626f <alltraps>

801067ad <vector10>:
.globl vector10
vector10:
  pushl $10
801067ad:	6a 0a                	push   $0xa
  jmp alltraps
801067af:	e9 bb fa ff ff       	jmp    8010626f <alltraps>

801067b4 <vector11>:
.globl vector11
vector11:
  pushl $11
801067b4:	6a 0b                	push   $0xb
  jmp alltraps
801067b6:	e9 b4 fa ff ff       	jmp    8010626f <alltraps>

801067bb <vector12>:
.globl vector12
vector12:
  pushl $12
801067bb:	6a 0c                	push   $0xc
  jmp alltraps
801067bd:	e9 ad fa ff ff       	jmp    8010626f <alltraps>

801067c2 <vector13>:
.globl vector13
vector13:
  pushl $13
801067c2:	6a 0d                	push   $0xd
  jmp alltraps
801067c4:	e9 a6 fa ff ff       	jmp    8010626f <alltraps>

801067c9 <vector14>:
.globl vector14
vector14:
  pushl $14
801067c9:	6a 0e                	push   $0xe
  jmp alltraps
801067cb:	e9 9f fa ff ff       	jmp    8010626f <alltraps>

801067d0 <vector15>:
.globl vector15
vector15:
  pushl $0
801067d0:	6a 00                	push   $0x0
  pushl $15
801067d2:	6a 0f                	push   $0xf
  jmp alltraps
801067d4:	e9 96 fa ff ff       	jmp    8010626f <alltraps>

801067d9 <vector16>:
.globl vector16
vector16:
  pushl $0
801067d9:	6a 00                	push   $0x0
  pushl $16
801067db:	6a 10                	push   $0x10
  jmp alltraps
801067dd:	e9 8d fa ff ff       	jmp    8010626f <alltraps>

801067e2 <vector17>:
.globl vector17
vector17:
  pushl $17
801067e2:	6a 11                	push   $0x11
  jmp alltraps
801067e4:	e9 86 fa ff ff       	jmp    8010626f <alltraps>

801067e9 <vector18>:
.globl vector18
vector18:
  pushl $0
801067e9:	6a 00                	push   $0x0
  pushl $18
801067eb:	6a 12                	push   $0x12
  jmp alltraps
801067ed:	e9 7d fa ff ff       	jmp    8010626f <alltraps>

801067f2 <vector19>:
.globl vector19
vector19:
  pushl $0
801067f2:	6a 00                	push   $0x0
  pushl $19
801067f4:	6a 13                	push   $0x13
  jmp alltraps
801067f6:	e9 74 fa ff ff       	jmp    8010626f <alltraps>

801067fb <vector20>:
.globl vector20
vector20:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $20
801067fd:	6a 14                	push   $0x14
  jmp alltraps
801067ff:	e9 6b fa ff ff       	jmp    8010626f <alltraps>

80106804 <vector21>:
.globl vector21
vector21:
  pushl $0
80106804:	6a 00                	push   $0x0
  pushl $21
80106806:	6a 15                	push   $0x15
  jmp alltraps
80106808:	e9 62 fa ff ff       	jmp    8010626f <alltraps>

8010680d <vector22>:
.globl vector22
vector22:
  pushl $0
8010680d:	6a 00                	push   $0x0
  pushl $22
8010680f:	6a 16                	push   $0x16
  jmp alltraps
80106811:	e9 59 fa ff ff       	jmp    8010626f <alltraps>

80106816 <vector23>:
.globl vector23
vector23:
  pushl $0
80106816:	6a 00                	push   $0x0
  pushl $23
80106818:	6a 17                	push   $0x17
  jmp alltraps
8010681a:	e9 50 fa ff ff       	jmp    8010626f <alltraps>

8010681f <vector24>:
.globl vector24
vector24:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $24
80106821:	6a 18                	push   $0x18
  jmp alltraps
80106823:	e9 47 fa ff ff       	jmp    8010626f <alltraps>

80106828 <vector25>:
.globl vector25
vector25:
  pushl $0
80106828:	6a 00                	push   $0x0
  pushl $25
8010682a:	6a 19                	push   $0x19
  jmp alltraps
8010682c:	e9 3e fa ff ff       	jmp    8010626f <alltraps>

80106831 <vector26>:
.globl vector26
vector26:
  pushl $0
80106831:	6a 00                	push   $0x0
  pushl $26
80106833:	6a 1a                	push   $0x1a
  jmp alltraps
80106835:	e9 35 fa ff ff       	jmp    8010626f <alltraps>

8010683a <vector27>:
.globl vector27
vector27:
  pushl $0
8010683a:	6a 00                	push   $0x0
  pushl $27
8010683c:	6a 1b                	push   $0x1b
  jmp alltraps
8010683e:	e9 2c fa ff ff       	jmp    8010626f <alltraps>

80106843 <vector28>:
.globl vector28
vector28:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $28
80106845:	6a 1c                	push   $0x1c
  jmp alltraps
80106847:	e9 23 fa ff ff       	jmp    8010626f <alltraps>

8010684c <vector29>:
.globl vector29
vector29:
  pushl $0
8010684c:	6a 00                	push   $0x0
  pushl $29
8010684e:	6a 1d                	push   $0x1d
  jmp alltraps
80106850:	e9 1a fa ff ff       	jmp    8010626f <alltraps>

80106855 <vector30>:
.globl vector30
vector30:
  pushl $0
80106855:	6a 00                	push   $0x0
  pushl $30
80106857:	6a 1e                	push   $0x1e
  jmp alltraps
80106859:	e9 11 fa ff ff       	jmp    8010626f <alltraps>

8010685e <vector31>:
.globl vector31
vector31:
  pushl $0
8010685e:	6a 00                	push   $0x0
  pushl $31
80106860:	6a 1f                	push   $0x1f
  jmp alltraps
80106862:	e9 08 fa ff ff       	jmp    8010626f <alltraps>

80106867 <vector32>:
.globl vector32
vector32:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $32
80106869:	6a 20                	push   $0x20
  jmp alltraps
8010686b:	e9 ff f9 ff ff       	jmp    8010626f <alltraps>

80106870 <vector33>:
.globl vector33
vector33:
  pushl $0
80106870:	6a 00                	push   $0x0
  pushl $33
80106872:	6a 21                	push   $0x21
  jmp alltraps
80106874:	e9 f6 f9 ff ff       	jmp    8010626f <alltraps>

80106879 <vector34>:
.globl vector34
vector34:
  pushl $0
80106879:	6a 00                	push   $0x0
  pushl $34
8010687b:	6a 22                	push   $0x22
  jmp alltraps
8010687d:	e9 ed f9 ff ff       	jmp    8010626f <alltraps>

80106882 <vector35>:
.globl vector35
vector35:
  pushl $0
80106882:	6a 00                	push   $0x0
  pushl $35
80106884:	6a 23                	push   $0x23
  jmp alltraps
80106886:	e9 e4 f9 ff ff       	jmp    8010626f <alltraps>

8010688b <vector36>:
.globl vector36
vector36:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $36
8010688d:	6a 24                	push   $0x24
  jmp alltraps
8010688f:	e9 db f9 ff ff       	jmp    8010626f <alltraps>

80106894 <vector37>:
.globl vector37
vector37:
  pushl $0
80106894:	6a 00                	push   $0x0
  pushl $37
80106896:	6a 25                	push   $0x25
  jmp alltraps
80106898:	e9 d2 f9 ff ff       	jmp    8010626f <alltraps>

8010689d <vector38>:
.globl vector38
vector38:
  pushl $0
8010689d:	6a 00                	push   $0x0
  pushl $38
8010689f:	6a 26                	push   $0x26
  jmp alltraps
801068a1:	e9 c9 f9 ff ff       	jmp    8010626f <alltraps>

801068a6 <vector39>:
.globl vector39
vector39:
  pushl $0
801068a6:	6a 00                	push   $0x0
  pushl $39
801068a8:	6a 27                	push   $0x27
  jmp alltraps
801068aa:	e9 c0 f9 ff ff       	jmp    8010626f <alltraps>

801068af <vector40>:
.globl vector40
vector40:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $40
801068b1:	6a 28                	push   $0x28
  jmp alltraps
801068b3:	e9 b7 f9 ff ff       	jmp    8010626f <alltraps>

801068b8 <vector41>:
.globl vector41
vector41:
  pushl $0
801068b8:	6a 00                	push   $0x0
  pushl $41
801068ba:	6a 29                	push   $0x29
  jmp alltraps
801068bc:	e9 ae f9 ff ff       	jmp    8010626f <alltraps>

801068c1 <vector42>:
.globl vector42
vector42:
  pushl $0
801068c1:	6a 00                	push   $0x0
  pushl $42
801068c3:	6a 2a                	push   $0x2a
  jmp alltraps
801068c5:	e9 a5 f9 ff ff       	jmp    8010626f <alltraps>

801068ca <vector43>:
.globl vector43
vector43:
  pushl $0
801068ca:	6a 00                	push   $0x0
  pushl $43
801068cc:	6a 2b                	push   $0x2b
  jmp alltraps
801068ce:	e9 9c f9 ff ff       	jmp    8010626f <alltraps>

801068d3 <vector44>:
.globl vector44
vector44:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $44
801068d5:	6a 2c                	push   $0x2c
  jmp alltraps
801068d7:	e9 93 f9 ff ff       	jmp    8010626f <alltraps>

801068dc <vector45>:
.globl vector45
vector45:
  pushl $0
801068dc:	6a 00                	push   $0x0
  pushl $45
801068de:	6a 2d                	push   $0x2d
  jmp alltraps
801068e0:	e9 8a f9 ff ff       	jmp    8010626f <alltraps>

801068e5 <vector46>:
.globl vector46
vector46:
  pushl $0
801068e5:	6a 00                	push   $0x0
  pushl $46
801068e7:	6a 2e                	push   $0x2e
  jmp alltraps
801068e9:	e9 81 f9 ff ff       	jmp    8010626f <alltraps>

801068ee <vector47>:
.globl vector47
vector47:
  pushl $0
801068ee:	6a 00                	push   $0x0
  pushl $47
801068f0:	6a 2f                	push   $0x2f
  jmp alltraps
801068f2:	e9 78 f9 ff ff       	jmp    8010626f <alltraps>

801068f7 <vector48>:
.globl vector48
vector48:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $48
801068f9:	6a 30                	push   $0x30
  jmp alltraps
801068fb:	e9 6f f9 ff ff       	jmp    8010626f <alltraps>

80106900 <vector49>:
.globl vector49
vector49:
  pushl $0
80106900:	6a 00                	push   $0x0
  pushl $49
80106902:	6a 31                	push   $0x31
  jmp alltraps
80106904:	e9 66 f9 ff ff       	jmp    8010626f <alltraps>

80106909 <vector50>:
.globl vector50
vector50:
  pushl $0
80106909:	6a 00                	push   $0x0
  pushl $50
8010690b:	6a 32                	push   $0x32
  jmp alltraps
8010690d:	e9 5d f9 ff ff       	jmp    8010626f <alltraps>

80106912 <vector51>:
.globl vector51
vector51:
  pushl $0
80106912:	6a 00                	push   $0x0
  pushl $51
80106914:	6a 33                	push   $0x33
  jmp alltraps
80106916:	e9 54 f9 ff ff       	jmp    8010626f <alltraps>

8010691b <vector52>:
.globl vector52
vector52:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $52
8010691d:	6a 34                	push   $0x34
  jmp alltraps
8010691f:	e9 4b f9 ff ff       	jmp    8010626f <alltraps>

80106924 <vector53>:
.globl vector53
vector53:
  pushl $0
80106924:	6a 00                	push   $0x0
  pushl $53
80106926:	6a 35                	push   $0x35
  jmp alltraps
80106928:	e9 42 f9 ff ff       	jmp    8010626f <alltraps>

8010692d <vector54>:
.globl vector54
vector54:
  pushl $0
8010692d:	6a 00                	push   $0x0
  pushl $54
8010692f:	6a 36                	push   $0x36
  jmp alltraps
80106931:	e9 39 f9 ff ff       	jmp    8010626f <alltraps>

80106936 <vector55>:
.globl vector55
vector55:
  pushl $0
80106936:	6a 00                	push   $0x0
  pushl $55
80106938:	6a 37                	push   $0x37
  jmp alltraps
8010693a:	e9 30 f9 ff ff       	jmp    8010626f <alltraps>

8010693f <vector56>:
.globl vector56
vector56:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $56
80106941:	6a 38                	push   $0x38
  jmp alltraps
80106943:	e9 27 f9 ff ff       	jmp    8010626f <alltraps>

80106948 <vector57>:
.globl vector57
vector57:
  pushl $0
80106948:	6a 00                	push   $0x0
  pushl $57
8010694a:	6a 39                	push   $0x39
  jmp alltraps
8010694c:	e9 1e f9 ff ff       	jmp    8010626f <alltraps>

80106951 <vector58>:
.globl vector58
vector58:
  pushl $0
80106951:	6a 00                	push   $0x0
  pushl $58
80106953:	6a 3a                	push   $0x3a
  jmp alltraps
80106955:	e9 15 f9 ff ff       	jmp    8010626f <alltraps>

8010695a <vector59>:
.globl vector59
vector59:
  pushl $0
8010695a:	6a 00                	push   $0x0
  pushl $59
8010695c:	6a 3b                	push   $0x3b
  jmp alltraps
8010695e:	e9 0c f9 ff ff       	jmp    8010626f <alltraps>

80106963 <vector60>:
.globl vector60
vector60:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $60
80106965:	6a 3c                	push   $0x3c
  jmp alltraps
80106967:	e9 03 f9 ff ff       	jmp    8010626f <alltraps>

8010696c <vector61>:
.globl vector61
vector61:
  pushl $0
8010696c:	6a 00                	push   $0x0
  pushl $61
8010696e:	6a 3d                	push   $0x3d
  jmp alltraps
80106970:	e9 fa f8 ff ff       	jmp    8010626f <alltraps>

80106975 <vector62>:
.globl vector62
vector62:
  pushl $0
80106975:	6a 00                	push   $0x0
  pushl $62
80106977:	6a 3e                	push   $0x3e
  jmp alltraps
80106979:	e9 f1 f8 ff ff       	jmp    8010626f <alltraps>

8010697e <vector63>:
.globl vector63
vector63:
  pushl $0
8010697e:	6a 00                	push   $0x0
  pushl $63
80106980:	6a 3f                	push   $0x3f
  jmp alltraps
80106982:	e9 e8 f8 ff ff       	jmp    8010626f <alltraps>

80106987 <vector64>:
.globl vector64
vector64:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $64
80106989:	6a 40                	push   $0x40
  jmp alltraps
8010698b:	e9 df f8 ff ff       	jmp    8010626f <alltraps>

80106990 <vector65>:
.globl vector65
vector65:
  pushl $0
80106990:	6a 00                	push   $0x0
  pushl $65
80106992:	6a 41                	push   $0x41
  jmp alltraps
80106994:	e9 d6 f8 ff ff       	jmp    8010626f <alltraps>

80106999 <vector66>:
.globl vector66
vector66:
  pushl $0
80106999:	6a 00                	push   $0x0
  pushl $66
8010699b:	6a 42                	push   $0x42
  jmp alltraps
8010699d:	e9 cd f8 ff ff       	jmp    8010626f <alltraps>

801069a2 <vector67>:
.globl vector67
vector67:
  pushl $0
801069a2:	6a 00                	push   $0x0
  pushl $67
801069a4:	6a 43                	push   $0x43
  jmp alltraps
801069a6:	e9 c4 f8 ff ff       	jmp    8010626f <alltraps>

801069ab <vector68>:
.globl vector68
vector68:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $68
801069ad:	6a 44                	push   $0x44
  jmp alltraps
801069af:	e9 bb f8 ff ff       	jmp    8010626f <alltraps>

801069b4 <vector69>:
.globl vector69
vector69:
  pushl $0
801069b4:	6a 00                	push   $0x0
  pushl $69
801069b6:	6a 45                	push   $0x45
  jmp alltraps
801069b8:	e9 b2 f8 ff ff       	jmp    8010626f <alltraps>

801069bd <vector70>:
.globl vector70
vector70:
  pushl $0
801069bd:	6a 00                	push   $0x0
  pushl $70
801069bf:	6a 46                	push   $0x46
  jmp alltraps
801069c1:	e9 a9 f8 ff ff       	jmp    8010626f <alltraps>

801069c6 <vector71>:
.globl vector71
vector71:
  pushl $0
801069c6:	6a 00                	push   $0x0
  pushl $71
801069c8:	6a 47                	push   $0x47
  jmp alltraps
801069ca:	e9 a0 f8 ff ff       	jmp    8010626f <alltraps>

801069cf <vector72>:
.globl vector72
vector72:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $72
801069d1:	6a 48                	push   $0x48
  jmp alltraps
801069d3:	e9 97 f8 ff ff       	jmp    8010626f <alltraps>

801069d8 <vector73>:
.globl vector73
vector73:
  pushl $0
801069d8:	6a 00                	push   $0x0
  pushl $73
801069da:	6a 49                	push   $0x49
  jmp alltraps
801069dc:	e9 8e f8 ff ff       	jmp    8010626f <alltraps>

801069e1 <vector74>:
.globl vector74
vector74:
  pushl $0
801069e1:	6a 00                	push   $0x0
  pushl $74
801069e3:	6a 4a                	push   $0x4a
  jmp alltraps
801069e5:	e9 85 f8 ff ff       	jmp    8010626f <alltraps>

801069ea <vector75>:
.globl vector75
vector75:
  pushl $0
801069ea:	6a 00                	push   $0x0
  pushl $75
801069ec:	6a 4b                	push   $0x4b
  jmp alltraps
801069ee:	e9 7c f8 ff ff       	jmp    8010626f <alltraps>

801069f3 <vector76>:
.globl vector76
vector76:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $76
801069f5:	6a 4c                	push   $0x4c
  jmp alltraps
801069f7:	e9 73 f8 ff ff       	jmp    8010626f <alltraps>

801069fc <vector77>:
.globl vector77
vector77:
  pushl $0
801069fc:	6a 00                	push   $0x0
  pushl $77
801069fe:	6a 4d                	push   $0x4d
  jmp alltraps
80106a00:	e9 6a f8 ff ff       	jmp    8010626f <alltraps>

80106a05 <vector78>:
.globl vector78
vector78:
  pushl $0
80106a05:	6a 00                	push   $0x0
  pushl $78
80106a07:	6a 4e                	push   $0x4e
  jmp alltraps
80106a09:	e9 61 f8 ff ff       	jmp    8010626f <alltraps>

80106a0e <vector79>:
.globl vector79
vector79:
  pushl $0
80106a0e:	6a 00                	push   $0x0
  pushl $79
80106a10:	6a 4f                	push   $0x4f
  jmp alltraps
80106a12:	e9 58 f8 ff ff       	jmp    8010626f <alltraps>

80106a17 <vector80>:
.globl vector80
vector80:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $80
80106a19:	6a 50                	push   $0x50
  jmp alltraps
80106a1b:	e9 4f f8 ff ff       	jmp    8010626f <alltraps>

80106a20 <vector81>:
.globl vector81
vector81:
  pushl $0
80106a20:	6a 00                	push   $0x0
  pushl $81
80106a22:	6a 51                	push   $0x51
  jmp alltraps
80106a24:	e9 46 f8 ff ff       	jmp    8010626f <alltraps>

80106a29 <vector82>:
.globl vector82
vector82:
  pushl $0
80106a29:	6a 00                	push   $0x0
  pushl $82
80106a2b:	6a 52                	push   $0x52
  jmp alltraps
80106a2d:	e9 3d f8 ff ff       	jmp    8010626f <alltraps>

80106a32 <vector83>:
.globl vector83
vector83:
  pushl $0
80106a32:	6a 00                	push   $0x0
  pushl $83
80106a34:	6a 53                	push   $0x53
  jmp alltraps
80106a36:	e9 34 f8 ff ff       	jmp    8010626f <alltraps>

80106a3b <vector84>:
.globl vector84
vector84:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $84
80106a3d:	6a 54                	push   $0x54
  jmp alltraps
80106a3f:	e9 2b f8 ff ff       	jmp    8010626f <alltraps>

80106a44 <vector85>:
.globl vector85
vector85:
  pushl $0
80106a44:	6a 00                	push   $0x0
  pushl $85
80106a46:	6a 55                	push   $0x55
  jmp alltraps
80106a48:	e9 22 f8 ff ff       	jmp    8010626f <alltraps>

80106a4d <vector86>:
.globl vector86
vector86:
  pushl $0
80106a4d:	6a 00                	push   $0x0
  pushl $86
80106a4f:	6a 56                	push   $0x56
  jmp alltraps
80106a51:	e9 19 f8 ff ff       	jmp    8010626f <alltraps>

80106a56 <vector87>:
.globl vector87
vector87:
  pushl $0
80106a56:	6a 00                	push   $0x0
  pushl $87
80106a58:	6a 57                	push   $0x57
  jmp alltraps
80106a5a:	e9 10 f8 ff ff       	jmp    8010626f <alltraps>

80106a5f <vector88>:
.globl vector88
vector88:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $88
80106a61:	6a 58                	push   $0x58
  jmp alltraps
80106a63:	e9 07 f8 ff ff       	jmp    8010626f <alltraps>

80106a68 <vector89>:
.globl vector89
vector89:
  pushl $0
80106a68:	6a 00                	push   $0x0
  pushl $89
80106a6a:	6a 59                	push   $0x59
  jmp alltraps
80106a6c:	e9 fe f7 ff ff       	jmp    8010626f <alltraps>

80106a71 <vector90>:
.globl vector90
vector90:
  pushl $0
80106a71:	6a 00                	push   $0x0
  pushl $90
80106a73:	6a 5a                	push   $0x5a
  jmp alltraps
80106a75:	e9 f5 f7 ff ff       	jmp    8010626f <alltraps>

80106a7a <vector91>:
.globl vector91
vector91:
  pushl $0
80106a7a:	6a 00                	push   $0x0
  pushl $91
80106a7c:	6a 5b                	push   $0x5b
  jmp alltraps
80106a7e:	e9 ec f7 ff ff       	jmp    8010626f <alltraps>

80106a83 <vector92>:
.globl vector92
vector92:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $92
80106a85:	6a 5c                	push   $0x5c
  jmp alltraps
80106a87:	e9 e3 f7 ff ff       	jmp    8010626f <alltraps>

80106a8c <vector93>:
.globl vector93
vector93:
  pushl $0
80106a8c:	6a 00                	push   $0x0
  pushl $93
80106a8e:	6a 5d                	push   $0x5d
  jmp alltraps
80106a90:	e9 da f7 ff ff       	jmp    8010626f <alltraps>

80106a95 <vector94>:
.globl vector94
vector94:
  pushl $0
80106a95:	6a 00                	push   $0x0
  pushl $94
80106a97:	6a 5e                	push   $0x5e
  jmp alltraps
80106a99:	e9 d1 f7 ff ff       	jmp    8010626f <alltraps>

80106a9e <vector95>:
.globl vector95
vector95:
  pushl $0
80106a9e:	6a 00                	push   $0x0
  pushl $95
80106aa0:	6a 5f                	push   $0x5f
  jmp alltraps
80106aa2:	e9 c8 f7 ff ff       	jmp    8010626f <alltraps>

80106aa7 <vector96>:
.globl vector96
vector96:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $96
80106aa9:	6a 60                	push   $0x60
  jmp alltraps
80106aab:	e9 bf f7 ff ff       	jmp    8010626f <alltraps>

80106ab0 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ab0:	6a 00                	push   $0x0
  pushl $97
80106ab2:	6a 61                	push   $0x61
  jmp alltraps
80106ab4:	e9 b6 f7 ff ff       	jmp    8010626f <alltraps>

80106ab9 <vector98>:
.globl vector98
vector98:
  pushl $0
80106ab9:	6a 00                	push   $0x0
  pushl $98
80106abb:	6a 62                	push   $0x62
  jmp alltraps
80106abd:	e9 ad f7 ff ff       	jmp    8010626f <alltraps>

80106ac2 <vector99>:
.globl vector99
vector99:
  pushl $0
80106ac2:	6a 00                	push   $0x0
  pushl $99
80106ac4:	6a 63                	push   $0x63
  jmp alltraps
80106ac6:	e9 a4 f7 ff ff       	jmp    8010626f <alltraps>

80106acb <vector100>:
.globl vector100
vector100:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $100
80106acd:	6a 64                	push   $0x64
  jmp alltraps
80106acf:	e9 9b f7 ff ff       	jmp    8010626f <alltraps>

80106ad4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106ad4:	6a 00                	push   $0x0
  pushl $101
80106ad6:	6a 65                	push   $0x65
  jmp alltraps
80106ad8:	e9 92 f7 ff ff       	jmp    8010626f <alltraps>

80106add <vector102>:
.globl vector102
vector102:
  pushl $0
80106add:	6a 00                	push   $0x0
  pushl $102
80106adf:	6a 66                	push   $0x66
  jmp alltraps
80106ae1:	e9 89 f7 ff ff       	jmp    8010626f <alltraps>

80106ae6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106ae6:	6a 00                	push   $0x0
  pushl $103
80106ae8:	6a 67                	push   $0x67
  jmp alltraps
80106aea:	e9 80 f7 ff ff       	jmp    8010626f <alltraps>

80106aef <vector104>:
.globl vector104
vector104:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $104
80106af1:	6a 68                	push   $0x68
  jmp alltraps
80106af3:	e9 77 f7 ff ff       	jmp    8010626f <alltraps>

80106af8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106af8:	6a 00                	push   $0x0
  pushl $105
80106afa:	6a 69                	push   $0x69
  jmp alltraps
80106afc:	e9 6e f7 ff ff       	jmp    8010626f <alltraps>

80106b01 <vector106>:
.globl vector106
vector106:
  pushl $0
80106b01:	6a 00                	push   $0x0
  pushl $106
80106b03:	6a 6a                	push   $0x6a
  jmp alltraps
80106b05:	e9 65 f7 ff ff       	jmp    8010626f <alltraps>

80106b0a <vector107>:
.globl vector107
vector107:
  pushl $0
80106b0a:	6a 00                	push   $0x0
  pushl $107
80106b0c:	6a 6b                	push   $0x6b
  jmp alltraps
80106b0e:	e9 5c f7 ff ff       	jmp    8010626f <alltraps>

80106b13 <vector108>:
.globl vector108
vector108:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $108
80106b15:	6a 6c                	push   $0x6c
  jmp alltraps
80106b17:	e9 53 f7 ff ff       	jmp    8010626f <alltraps>

80106b1c <vector109>:
.globl vector109
vector109:
  pushl $0
80106b1c:	6a 00                	push   $0x0
  pushl $109
80106b1e:	6a 6d                	push   $0x6d
  jmp alltraps
80106b20:	e9 4a f7 ff ff       	jmp    8010626f <alltraps>

80106b25 <vector110>:
.globl vector110
vector110:
  pushl $0
80106b25:	6a 00                	push   $0x0
  pushl $110
80106b27:	6a 6e                	push   $0x6e
  jmp alltraps
80106b29:	e9 41 f7 ff ff       	jmp    8010626f <alltraps>

80106b2e <vector111>:
.globl vector111
vector111:
  pushl $0
80106b2e:	6a 00                	push   $0x0
  pushl $111
80106b30:	6a 6f                	push   $0x6f
  jmp alltraps
80106b32:	e9 38 f7 ff ff       	jmp    8010626f <alltraps>

80106b37 <vector112>:
.globl vector112
vector112:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $112
80106b39:	6a 70                	push   $0x70
  jmp alltraps
80106b3b:	e9 2f f7 ff ff       	jmp    8010626f <alltraps>

80106b40 <vector113>:
.globl vector113
vector113:
  pushl $0
80106b40:	6a 00                	push   $0x0
  pushl $113
80106b42:	6a 71                	push   $0x71
  jmp alltraps
80106b44:	e9 26 f7 ff ff       	jmp    8010626f <alltraps>

80106b49 <vector114>:
.globl vector114
vector114:
  pushl $0
80106b49:	6a 00                	push   $0x0
  pushl $114
80106b4b:	6a 72                	push   $0x72
  jmp alltraps
80106b4d:	e9 1d f7 ff ff       	jmp    8010626f <alltraps>

80106b52 <vector115>:
.globl vector115
vector115:
  pushl $0
80106b52:	6a 00                	push   $0x0
  pushl $115
80106b54:	6a 73                	push   $0x73
  jmp alltraps
80106b56:	e9 14 f7 ff ff       	jmp    8010626f <alltraps>

80106b5b <vector116>:
.globl vector116
vector116:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $116
80106b5d:	6a 74                	push   $0x74
  jmp alltraps
80106b5f:	e9 0b f7 ff ff       	jmp    8010626f <alltraps>

80106b64 <vector117>:
.globl vector117
vector117:
  pushl $0
80106b64:	6a 00                	push   $0x0
  pushl $117
80106b66:	6a 75                	push   $0x75
  jmp alltraps
80106b68:	e9 02 f7 ff ff       	jmp    8010626f <alltraps>

80106b6d <vector118>:
.globl vector118
vector118:
  pushl $0
80106b6d:	6a 00                	push   $0x0
  pushl $118
80106b6f:	6a 76                	push   $0x76
  jmp alltraps
80106b71:	e9 f9 f6 ff ff       	jmp    8010626f <alltraps>

80106b76 <vector119>:
.globl vector119
vector119:
  pushl $0
80106b76:	6a 00                	push   $0x0
  pushl $119
80106b78:	6a 77                	push   $0x77
  jmp alltraps
80106b7a:	e9 f0 f6 ff ff       	jmp    8010626f <alltraps>

80106b7f <vector120>:
.globl vector120
vector120:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $120
80106b81:	6a 78                	push   $0x78
  jmp alltraps
80106b83:	e9 e7 f6 ff ff       	jmp    8010626f <alltraps>

80106b88 <vector121>:
.globl vector121
vector121:
  pushl $0
80106b88:	6a 00                	push   $0x0
  pushl $121
80106b8a:	6a 79                	push   $0x79
  jmp alltraps
80106b8c:	e9 de f6 ff ff       	jmp    8010626f <alltraps>

80106b91 <vector122>:
.globl vector122
vector122:
  pushl $0
80106b91:	6a 00                	push   $0x0
  pushl $122
80106b93:	6a 7a                	push   $0x7a
  jmp alltraps
80106b95:	e9 d5 f6 ff ff       	jmp    8010626f <alltraps>

80106b9a <vector123>:
.globl vector123
vector123:
  pushl $0
80106b9a:	6a 00                	push   $0x0
  pushl $123
80106b9c:	6a 7b                	push   $0x7b
  jmp alltraps
80106b9e:	e9 cc f6 ff ff       	jmp    8010626f <alltraps>

80106ba3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $124
80106ba5:	6a 7c                	push   $0x7c
  jmp alltraps
80106ba7:	e9 c3 f6 ff ff       	jmp    8010626f <alltraps>

80106bac <vector125>:
.globl vector125
vector125:
  pushl $0
80106bac:	6a 00                	push   $0x0
  pushl $125
80106bae:	6a 7d                	push   $0x7d
  jmp alltraps
80106bb0:	e9 ba f6 ff ff       	jmp    8010626f <alltraps>

80106bb5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106bb5:	6a 00                	push   $0x0
  pushl $126
80106bb7:	6a 7e                	push   $0x7e
  jmp alltraps
80106bb9:	e9 b1 f6 ff ff       	jmp    8010626f <alltraps>

80106bbe <vector127>:
.globl vector127
vector127:
  pushl $0
80106bbe:	6a 00                	push   $0x0
  pushl $127
80106bc0:	6a 7f                	push   $0x7f
  jmp alltraps
80106bc2:	e9 a8 f6 ff ff       	jmp    8010626f <alltraps>

80106bc7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $128
80106bc9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106bce:	e9 9c f6 ff ff       	jmp    8010626f <alltraps>

80106bd3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $129
80106bd5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106bda:	e9 90 f6 ff ff       	jmp    8010626f <alltraps>

80106bdf <vector130>:
.globl vector130
vector130:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $130
80106be1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106be6:	e9 84 f6 ff ff       	jmp    8010626f <alltraps>

80106beb <vector131>:
.globl vector131
vector131:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $131
80106bed:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106bf2:	e9 78 f6 ff ff       	jmp    8010626f <alltraps>

80106bf7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $132
80106bf9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106bfe:	e9 6c f6 ff ff       	jmp    8010626f <alltraps>

80106c03 <vector133>:
.globl vector133
vector133:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $133
80106c05:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106c0a:	e9 60 f6 ff ff       	jmp    8010626f <alltraps>

80106c0f <vector134>:
.globl vector134
vector134:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $134
80106c11:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106c16:	e9 54 f6 ff ff       	jmp    8010626f <alltraps>

80106c1b <vector135>:
.globl vector135
vector135:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $135
80106c1d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106c22:	e9 48 f6 ff ff       	jmp    8010626f <alltraps>

80106c27 <vector136>:
.globl vector136
vector136:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $136
80106c29:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106c2e:	e9 3c f6 ff ff       	jmp    8010626f <alltraps>

80106c33 <vector137>:
.globl vector137
vector137:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $137
80106c35:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106c3a:	e9 30 f6 ff ff       	jmp    8010626f <alltraps>

80106c3f <vector138>:
.globl vector138
vector138:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $138
80106c41:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106c46:	e9 24 f6 ff ff       	jmp    8010626f <alltraps>

80106c4b <vector139>:
.globl vector139
vector139:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $139
80106c4d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106c52:	e9 18 f6 ff ff       	jmp    8010626f <alltraps>

80106c57 <vector140>:
.globl vector140
vector140:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $140
80106c59:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106c5e:	e9 0c f6 ff ff       	jmp    8010626f <alltraps>

80106c63 <vector141>:
.globl vector141
vector141:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $141
80106c65:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106c6a:	e9 00 f6 ff ff       	jmp    8010626f <alltraps>

80106c6f <vector142>:
.globl vector142
vector142:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $142
80106c71:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106c76:	e9 f4 f5 ff ff       	jmp    8010626f <alltraps>

80106c7b <vector143>:
.globl vector143
vector143:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $143
80106c7d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106c82:	e9 e8 f5 ff ff       	jmp    8010626f <alltraps>

80106c87 <vector144>:
.globl vector144
vector144:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $144
80106c89:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106c8e:	e9 dc f5 ff ff       	jmp    8010626f <alltraps>

80106c93 <vector145>:
.globl vector145
vector145:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $145
80106c95:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106c9a:	e9 d0 f5 ff ff       	jmp    8010626f <alltraps>

80106c9f <vector146>:
.globl vector146
vector146:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $146
80106ca1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106ca6:	e9 c4 f5 ff ff       	jmp    8010626f <alltraps>

80106cab <vector147>:
.globl vector147
vector147:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $147
80106cad:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106cb2:	e9 b8 f5 ff ff       	jmp    8010626f <alltraps>

80106cb7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $148
80106cb9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106cbe:	e9 ac f5 ff ff       	jmp    8010626f <alltraps>

80106cc3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $149
80106cc5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106cca:	e9 a0 f5 ff ff       	jmp    8010626f <alltraps>

80106ccf <vector150>:
.globl vector150
vector150:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $150
80106cd1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106cd6:	e9 94 f5 ff ff       	jmp    8010626f <alltraps>

80106cdb <vector151>:
.globl vector151
vector151:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $151
80106cdd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106ce2:	e9 88 f5 ff ff       	jmp    8010626f <alltraps>

80106ce7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $152
80106ce9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106cee:	e9 7c f5 ff ff       	jmp    8010626f <alltraps>

80106cf3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $153
80106cf5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106cfa:	e9 70 f5 ff ff       	jmp    8010626f <alltraps>

80106cff <vector154>:
.globl vector154
vector154:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $154
80106d01:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106d06:	e9 64 f5 ff ff       	jmp    8010626f <alltraps>

80106d0b <vector155>:
.globl vector155
vector155:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $155
80106d0d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106d12:	e9 58 f5 ff ff       	jmp    8010626f <alltraps>

80106d17 <vector156>:
.globl vector156
vector156:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $156
80106d19:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106d1e:	e9 4c f5 ff ff       	jmp    8010626f <alltraps>

80106d23 <vector157>:
.globl vector157
vector157:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $157
80106d25:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106d2a:	e9 40 f5 ff ff       	jmp    8010626f <alltraps>

80106d2f <vector158>:
.globl vector158
vector158:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $158
80106d31:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106d36:	e9 34 f5 ff ff       	jmp    8010626f <alltraps>

80106d3b <vector159>:
.globl vector159
vector159:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $159
80106d3d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106d42:	e9 28 f5 ff ff       	jmp    8010626f <alltraps>

80106d47 <vector160>:
.globl vector160
vector160:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $160
80106d49:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106d4e:	e9 1c f5 ff ff       	jmp    8010626f <alltraps>

80106d53 <vector161>:
.globl vector161
vector161:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $161
80106d55:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106d5a:	e9 10 f5 ff ff       	jmp    8010626f <alltraps>

80106d5f <vector162>:
.globl vector162
vector162:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $162
80106d61:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106d66:	e9 04 f5 ff ff       	jmp    8010626f <alltraps>

80106d6b <vector163>:
.globl vector163
vector163:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $163
80106d6d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106d72:	e9 f8 f4 ff ff       	jmp    8010626f <alltraps>

80106d77 <vector164>:
.globl vector164
vector164:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $164
80106d79:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106d7e:	e9 ec f4 ff ff       	jmp    8010626f <alltraps>

80106d83 <vector165>:
.globl vector165
vector165:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $165
80106d85:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106d8a:	e9 e0 f4 ff ff       	jmp    8010626f <alltraps>

80106d8f <vector166>:
.globl vector166
vector166:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $166
80106d91:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106d96:	e9 d4 f4 ff ff       	jmp    8010626f <alltraps>

80106d9b <vector167>:
.globl vector167
vector167:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $167
80106d9d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106da2:	e9 c8 f4 ff ff       	jmp    8010626f <alltraps>

80106da7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $168
80106da9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106dae:	e9 bc f4 ff ff       	jmp    8010626f <alltraps>

80106db3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $169
80106db5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106dba:	e9 b0 f4 ff ff       	jmp    8010626f <alltraps>

80106dbf <vector170>:
.globl vector170
vector170:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $170
80106dc1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106dc6:	e9 a4 f4 ff ff       	jmp    8010626f <alltraps>

80106dcb <vector171>:
.globl vector171
vector171:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $171
80106dcd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106dd2:	e9 98 f4 ff ff       	jmp    8010626f <alltraps>

80106dd7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $172
80106dd9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106dde:	e9 8c f4 ff ff       	jmp    8010626f <alltraps>

80106de3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $173
80106de5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106dea:	e9 80 f4 ff ff       	jmp    8010626f <alltraps>

80106def <vector174>:
.globl vector174
vector174:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $174
80106df1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106df6:	e9 74 f4 ff ff       	jmp    8010626f <alltraps>

80106dfb <vector175>:
.globl vector175
vector175:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $175
80106dfd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106e02:	e9 68 f4 ff ff       	jmp    8010626f <alltraps>

80106e07 <vector176>:
.globl vector176
vector176:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $176
80106e09:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106e0e:	e9 5c f4 ff ff       	jmp    8010626f <alltraps>

80106e13 <vector177>:
.globl vector177
vector177:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $177
80106e15:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106e1a:	e9 50 f4 ff ff       	jmp    8010626f <alltraps>

80106e1f <vector178>:
.globl vector178
vector178:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $178
80106e21:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106e26:	e9 44 f4 ff ff       	jmp    8010626f <alltraps>

80106e2b <vector179>:
.globl vector179
vector179:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $179
80106e2d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106e32:	e9 38 f4 ff ff       	jmp    8010626f <alltraps>

80106e37 <vector180>:
.globl vector180
vector180:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $180
80106e39:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106e3e:	e9 2c f4 ff ff       	jmp    8010626f <alltraps>

80106e43 <vector181>:
.globl vector181
vector181:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $181
80106e45:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106e4a:	e9 20 f4 ff ff       	jmp    8010626f <alltraps>

80106e4f <vector182>:
.globl vector182
vector182:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $182
80106e51:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106e56:	e9 14 f4 ff ff       	jmp    8010626f <alltraps>

80106e5b <vector183>:
.globl vector183
vector183:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $183
80106e5d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106e62:	e9 08 f4 ff ff       	jmp    8010626f <alltraps>

80106e67 <vector184>:
.globl vector184
vector184:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $184
80106e69:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106e6e:	e9 fc f3 ff ff       	jmp    8010626f <alltraps>

80106e73 <vector185>:
.globl vector185
vector185:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $185
80106e75:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106e7a:	e9 f0 f3 ff ff       	jmp    8010626f <alltraps>

80106e7f <vector186>:
.globl vector186
vector186:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $186
80106e81:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106e86:	e9 e4 f3 ff ff       	jmp    8010626f <alltraps>

80106e8b <vector187>:
.globl vector187
vector187:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $187
80106e8d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106e92:	e9 d8 f3 ff ff       	jmp    8010626f <alltraps>

80106e97 <vector188>:
.globl vector188
vector188:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $188
80106e99:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106e9e:	e9 cc f3 ff ff       	jmp    8010626f <alltraps>

80106ea3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $189
80106ea5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106eaa:	e9 c0 f3 ff ff       	jmp    8010626f <alltraps>

80106eaf <vector190>:
.globl vector190
vector190:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $190
80106eb1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106eb6:	e9 b4 f3 ff ff       	jmp    8010626f <alltraps>

80106ebb <vector191>:
.globl vector191
vector191:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $191
80106ebd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106ec2:	e9 a8 f3 ff ff       	jmp    8010626f <alltraps>

80106ec7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $192
80106ec9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106ece:	e9 9c f3 ff ff       	jmp    8010626f <alltraps>

80106ed3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $193
80106ed5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106eda:	e9 90 f3 ff ff       	jmp    8010626f <alltraps>

80106edf <vector194>:
.globl vector194
vector194:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $194
80106ee1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106ee6:	e9 84 f3 ff ff       	jmp    8010626f <alltraps>

80106eeb <vector195>:
.globl vector195
vector195:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $195
80106eed:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106ef2:	e9 78 f3 ff ff       	jmp    8010626f <alltraps>

80106ef7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $196
80106ef9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106efe:	e9 6c f3 ff ff       	jmp    8010626f <alltraps>

80106f03 <vector197>:
.globl vector197
vector197:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $197
80106f05:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106f0a:	e9 60 f3 ff ff       	jmp    8010626f <alltraps>

80106f0f <vector198>:
.globl vector198
vector198:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $198
80106f11:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106f16:	e9 54 f3 ff ff       	jmp    8010626f <alltraps>

80106f1b <vector199>:
.globl vector199
vector199:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $199
80106f1d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106f22:	e9 48 f3 ff ff       	jmp    8010626f <alltraps>

80106f27 <vector200>:
.globl vector200
vector200:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $200
80106f29:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106f2e:	e9 3c f3 ff ff       	jmp    8010626f <alltraps>

80106f33 <vector201>:
.globl vector201
vector201:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $201
80106f35:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106f3a:	e9 30 f3 ff ff       	jmp    8010626f <alltraps>

80106f3f <vector202>:
.globl vector202
vector202:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $202
80106f41:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106f46:	e9 24 f3 ff ff       	jmp    8010626f <alltraps>

80106f4b <vector203>:
.globl vector203
vector203:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $203
80106f4d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106f52:	e9 18 f3 ff ff       	jmp    8010626f <alltraps>

80106f57 <vector204>:
.globl vector204
vector204:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $204
80106f59:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106f5e:	e9 0c f3 ff ff       	jmp    8010626f <alltraps>

80106f63 <vector205>:
.globl vector205
vector205:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $205
80106f65:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106f6a:	e9 00 f3 ff ff       	jmp    8010626f <alltraps>

80106f6f <vector206>:
.globl vector206
vector206:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $206
80106f71:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106f76:	e9 f4 f2 ff ff       	jmp    8010626f <alltraps>

80106f7b <vector207>:
.globl vector207
vector207:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $207
80106f7d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106f82:	e9 e8 f2 ff ff       	jmp    8010626f <alltraps>

80106f87 <vector208>:
.globl vector208
vector208:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $208
80106f89:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106f8e:	e9 dc f2 ff ff       	jmp    8010626f <alltraps>

80106f93 <vector209>:
.globl vector209
vector209:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $209
80106f95:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106f9a:	e9 d0 f2 ff ff       	jmp    8010626f <alltraps>

80106f9f <vector210>:
.globl vector210
vector210:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $210
80106fa1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106fa6:	e9 c4 f2 ff ff       	jmp    8010626f <alltraps>

80106fab <vector211>:
.globl vector211
vector211:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $211
80106fad:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106fb2:	e9 b8 f2 ff ff       	jmp    8010626f <alltraps>

80106fb7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $212
80106fb9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106fbe:	e9 ac f2 ff ff       	jmp    8010626f <alltraps>

80106fc3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $213
80106fc5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106fca:	e9 a0 f2 ff ff       	jmp    8010626f <alltraps>

80106fcf <vector214>:
.globl vector214
vector214:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $214
80106fd1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106fd6:	e9 94 f2 ff ff       	jmp    8010626f <alltraps>

80106fdb <vector215>:
.globl vector215
vector215:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $215
80106fdd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106fe2:	e9 88 f2 ff ff       	jmp    8010626f <alltraps>

80106fe7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $216
80106fe9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106fee:	e9 7c f2 ff ff       	jmp    8010626f <alltraps>

80106ff3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $217
80106ff5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106ffa:	e9 70 f2 ff ff       	jmp    8010626f <alltraps>

80106fff <vector218>:
.globl vector218
vector218:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $218
80107001:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107006:	e9 64 f2 ff ff       	jmp    8010626f <alltraps>

8010700b <vector219>:
.globl vector219
vector219:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $219
8010700d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107012:	e9 58 f2 ff ff       	jmp    8010626f <alltraps>

80107017 <vector220>:
.globl vector220
vector220:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $220
80107019:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010701e:	e9 4c f2 ff ff       	jmp    8010626f <alltraps>

80107023 <vector221>:
.globl vector221
vector221:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $221
80107025:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010702a:	e9 40 f2 ff ff       	jmp    8010626f <alltraps>

8010702f <vector222>:
.globl vector222
vector222:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $222
80107031:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107036:	e9 34 f2 ff ff       	jmp    8010626f <alltraps>

8010703b <vector223>:
.globl vector223
vector223:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $223
8010703d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107042:	e9 28 f2 ff ff       	jmp    8010626f <alltraps>

80107047 <vector224>:
.globl vector224
vector224:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $224
80107049:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010704e:	e9 1c f2 ff ff       	jmp    8010626f <alltraps>

80107053 <vector225>:
.globl vector225
vector225:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $225
80107055:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010705a:	e9 10 f2 ff ff       	jmp    8010626f <alltraps>

8010705f <vector226>:
.globl vector226
vector226:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $226
80107061:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107066:	e9 04 f2 ff ff       	jmp    8010626f <alltraps>

8010706b <vector227>:
.globl vector227
vector227:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $227
8010706d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107072:	e9 f8 f1 ff ff       	jmp    8010626f <alltraps>

80107077 <vector228>:
.globl vector228
vector228:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $228
80107079:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010707e:	e9 ec f1 ff ff       	jmp    8010626f <alltraps>

80107083 <vector229>:
.globl vector229
vector229:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $229
80107085:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010708a:	e9 e0 f1 ff ff       	jmp    8010626f <alltraps>

8010708f <vector230>:
.globl vector230
vector230:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $230
80107091:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107096:	e9 d4 f1 ff ff       	jmp    8010626f <alltraps>

8010709b <vector231>:
.globl vector231
vector231:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $231
8010709d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801070a2:	e9 c8 f1 ff ff       	jmp    8010626f <alltraps>

801070a7 <vector232>:
.globl vector232
vector232:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $232
801070a9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801070ae:	e9 bc f1 ff ff       	jmp    8010626f <alltraps>

801070b3 <vector233>:
.globl vector233
vector233:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $233
801070b5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801070ba:	e9 b0 f1 ff ff       	jmp    8010626f <alltraps>

801070bf <vector234>:
.globl vector234
vector234:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $234
801070c1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801070c6:	e9 a4 f1 ff ff       	jmp    8010626f <alltraps>

801070cb <vector235>:
.globl vector235
vector235:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $235
801070cd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801070d2:	e9 98 f1 ff ff       	jmp    8010626f <alltraps>

801070d7 <vector236>:
.globl vector236
vector236:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $236
801070d9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801070de:	e9 8c f1 ff ff       	jmp    8010626f <alltraps>

801070e3 <vector237>:
.globl vector237
vector237:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $237
801070e5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801070ea:	e9 80 f1 ff ff       	jmp    8010626f <alltraps>

801070ef <vector238>:
.globl vector238
vector238:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $238
801070f1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801070f6:	e9 74 f1 ff ff       	jmp    8010626f <alltraps>

801070fb <vector239>:
.globl vector239
vector239:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $239
801070fd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107102:	e9 68 f1 ff ff       	jmp    8010626f <alltraps>

80107107 <vector240>:
.globl vector240
vector240:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $240
80107109:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010710e:	e9 5c f1 ff ff       	jmp    8010626f <alltraps>

80107113 <vector241>:
.globl vector241
vector241:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $241
80107115:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010711a:	e9 50 f1 ff ff       	jmp    8010626f <alltraps>

8010711f <vector242>:
.globl vector242
vector242:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $242
80107121:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107126:	e9 44 f1 ff ff       	jmp    8010626f <alltraps>

8010712b <vector243>:
.globl vector243
vector243:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $243
8010712d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107132:	e9 38 f1 ff ff       	jmp    8010626f <alltraps>

80107137 <vector244>:
.globl vector244
vector244:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $244
80107139:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010713e:	e9 2c f1 ff ff       	jmp    8010626f <alltraps>

80107143 <vector245>:
.globl vector245
vector245:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $245
80107145:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010714a:	e9 20 f1 ff ff       	jmp    8010626f <alltraps>

8010714f <vector246>:
.globl vector246
vector246:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $246
80107151:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107156:	e9 14 f1 ff ff       	jmp    8010626f <alltraps>

8010715b <vector247>:
.globl vector247
vector247:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $247
8010715d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107162:	e9 08 f1 ff ff       	jmp    8010626f <alltraps>

80107167 <vector248>:
.globl vector248
vector248:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $248
80107169:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010716e:	e9 fc f0 ff ff       	jmp    8010626f <alltraps>

80107173 <vector249>:
.globl vector249
vector249:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $249
80107175:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010717a:	e9 f0 f0 ff ff       	jmp    8010626f <alltraps>

8010717f <vector250>:
.globl vector250
vector250:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $250
80107181:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107186:	e9 e4 f0 ff ff       	jmp    8010626f <alltraps>

8010718b <vector251>:
.globl vector251
vector251:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $251
8010718d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107192:	e9 d8 f0 ff ff       	jmp    8010626f <alltraps>

80107197 <vector252>:
.globl vector252
vector252:
  pushl $0
80107197:	6a 00                	push   $0x0
  pushl $252
80107199:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010719e:	e9 cc f0 ff ff       	jmp    8010626f <alltraps>

801071a3 <vector253>:
.globl vector253
vector253:
  pushl $0
801071a3:	6a 00                	push   $0x0
  pushl $253
801071a5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801071aa:	e9 c0 f0 ff ff       	jmp    8010626f <alltraps>

801071af <vector254>:
.globl vector254
vector254:
  pushl $0
801071af:	6a 00                	push   $0x0
  pushl $254
801071b1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801071b6:	e9 b4 f0 ff ff       	jmp    8010626f <alltraps>

801071bb <vector255>:
.globl vector255
vector255:
  pushl $0
801071bb:	6a 00                	push   $0x0
  pushl $255
801071bd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801071c2:	e9 a8 f0 ff ff       	jmp    8010626f <alltraps>
801071c7:	66 90                	xchg   %ax,%ax
801071c9:	66 90                	xchg   %ax,%ax
801071cb:	66 90                	xchg   %ax,%ax
801071cd:	66 90                	xchg   %ax,%ax
801071cf:	90                   	nop

801071d0 <walkpgdir>:
}

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t * walkpgdir(pde_t *pgdir, const void *va, int alloc) {
801071d0:	55                   	push   %ebp
801071d1:	89 e5                	mov    %esp,%ebp
801071d3:	57                   	push   %edi
801071d4:	56                   	push   %esi
801071d5:	53                   	push   %ebx
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
801071d6:	89 d3                	mov    %edx,%ebx
static pte_t * walkpgdir(pde_t *pgdir, const void *va, int alloc) {
801071d8:	89 d7                	mov    %edx,%edi
    pde = &pgdir[PDX(va)];
801071da:	c1 eb 16             	shr    $0x16,%ebx
801071dd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
static pte_t * walkpgdir(pde_t *pgdir, const void *va, int alloc) {
801071e0:	83 ec 0c             	sub    $0xc,%esp
    if (*pde & PTE_P) {
801071e3:	8b 06                	mov    (%esi),%eax
801071e5:	a8 01                	test   $0x1,%al
801071e7:	74 27                	je     80107210 <walkpgdir+0x40>
        pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071ee:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
        // The permissions here are overly generous, but they can
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
801071f4:	c1 ef 0a             	shr    $0xa,%edi
}
801071f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return &pgtab[PTX(va)];
801071fa:	89 fa                	mov    %edi,%edx
801071fc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107202:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107205:	5b                   	pop    %ebx
80107206:	5e                   	pop    %esi
80107207:	5f                   	pop    %edi
80107208:	5d                   	pop    %ebp
80107209:	c3                   	ret    
8010720a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (!alloc || (pgtab = (pte_t*)kalloc()) == 0) {
80107210:	85 c9                	test   %ecx,%ecx
80107212:	74 2c                	je     80107240 <walkpgdir+0x70>
80107214:	e8 77 bd ff ff       	call   80102f90 <kalloc>
80107219:	85 c0                	test   %eax,%eax
8010721b:	89 c3                	mov    %eax,%ebx
8010721d:	74 21                	je     80107240 <walkpgdir+0x70>
        memset(pgtab, 0, PGSIZE);
8010721f:	83 ec 04             	sub    $0x4,%esp
80107222:	68 00 10 00 00       	push   $0x1000
80107227:	6a 00                	push   $0x0
80107229:	50                   	push   %eax
8010722a:	e8 21 dd ff ff       	call   80104f50 <memset>
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010722f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107235:	83 c4 10             	add    $0x10,%esp
80107238:	83 c8 07             	or     $0x7,%eax
8010723b:	89 06                	mov    %eax,(%esi)
8010723d:	eb b5                	jmp    801071f4 <walkpgdir+0x24>
8010723f:	90                   	nop
}
80107240:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return 0;
80107243:	31 c0                	xor    %eax,%eax
}
80107245:	5b                   	pop    %ebx
80107246:	5e                   	pop    %esi
80107247:	5f                   	pop    %edi
80107248:	5d                   	pop    %ebp
80107249:	c3                   	ret    
8010724a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107250 <mappages>:

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	57                   	push   %edi
80107254:	56                   	push   %esi
80107255:	53                   	push   %ebx
    char *a, *last;
    pte_t *pte;

    a = (char*)PGROUNDDOWN((uint)va);
80107256:	89 d3                	mov    %edx,%ebx
80107258:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
static int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
8010725e:	83 ec 1c             	sub    $0x1c,%esp
80107261:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107264:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107268:	8b 7d 08             	mov    0x8(%ebp),%edi
8010726b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107270:	89 45 e0             	mov    %eax,-0x20(%ebp)
            return -1;
        }
        if (*pte & PTE_P) {
            panic("remap");
        }
        *pte = pa | perm | PTE_P;
80107273:	8b 45 0c             	mov    0xc(%ebp),%eax
80107276:	29 df                	sub    %ebx,%edi
80107278:	83 c8 01             	or     $0x1,%eax
8010727b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010727e:	eb 15                	jmp    80107295 <mappages+0x45>
        if (*pte & PTE_P) {
80107280:	f6 00 01             	testb  $0x1,(%eax)
80107283:	75 45                	jne    801072ca <mappages+0x7a>
        *pte = pa | perm | PTE_P;
80107285:	0b 75 dc             	or     -0x24(%ebp),%esi
        if (a == last) {
80107288:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
        *pte = pa | perm | PTE_P;
8010728b:	89 30                	mov    %esi,(%eax)
        if (a == last) {
8010728d:	74 31                	je     801072c0 <mappages+0x70>
            break;
        }
        a += PGSIZE;
8010728f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        if ((pte = walkpgdir(pgdir, a, 1)) == 0) {
80107295:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107298:	b9 01 00 00 00       	mov    $0x1,%ecx
8010729d:	89 da                	mov    %ebx,%edx
8010729f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801072a2:	e8 29 ff ff ff       	call   801071d0 <walkpgdir>
801072a7:	85 c0                	test   %eax,%eax
801072a9:	75 d5                	jne    80107280 <mappages+0x30>
        pa += PGSIZE;
    }
    return 0;
}
801072ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
801072ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072b3:	5b                   	pop    %ebx
801072b4:	5e                   	pop    %esi
801072b5:	5f                   	pop    %edi
801072b6:	5d                   	pop    %ebp
801072b7:	c3                   	ret    
801072b8:	90                   	nop
801072b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801072c3:	31 c0                	xor    %eax,%eax
}
801072c5:	5b                   	pop    %ebx
801072c6:	5e                   	pop    %esi
801072c7:	5f                   	pop    %edi
801072c8:	5d                   	pop    %ebp
801072c9:	c3                   	ret    
            panic("remap");
801072ca:	83 ec 0c             	sub    $0xc,%esp
801072cd:	68 98 84 10 80       	push   $0x80108498
801072d2:	e8 09 92 ff ff       	call   801004e0 <panic>
801072d7:	89 f6                	mov    %esi,%esi
801072d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072e0 <deallocuvm.part.0>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	57                   	push   %edi
801072e4:	56                   	push   %esi
801072e5:	53                   	push   %ebx

    if (newsz >= oldsz) {
        return oldsz;
    }

    a = PGROUNDUP(newsz);
801072e6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
801072ec:	89 c7                	mov    %eax,%edi
    a = PGROUNDUP(newsz);
801072ee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
801072f4:	83 ec 1c             	sub    $0x1c,%esp
801072f7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    for (; a  < oldsz; a += PGSIZE) {
801072fa:	39 d3                	cmp    %edx,%ebx
801072fc:	73 66                	jae    80107364 <deallocuvm.part.0+0x84>
801072fe:	89 d6                	mov    %edx,%esi
80107300:	eb 3d                	jmp    8010733f <deallocuvm.part.0+0x5f>
80107302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        pte = walkpgdir(pgdir, (char*)a, 0);
        if (!pte) {
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
        }
        else if ((*pte & PTE_P) != 0) {
80107308:	8b 10                	mov    (%eax),%edx
8010730a:	f6 c2 01             	test   $0x1,%dl
8010730d:	74 26                	je     80107335 <deallocuvm.part.0+0x55>
            pa = PTE_ADDR(*pte);
            if (pa == 0) {
8010730f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107315:	74 58                	je     8010736f <deallocuvm.part.0+0x8f>
                panic("kfree");
            }
            char *v = P2V(pa);
            kfree(v);
80107317:	83 ec 0c             	sub    $0xc,%esp
            char *v = P2V(pa);
8010731a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107320:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            kfree(v);
80107323:	52                   	push   %edx
80107324:	e8 b7 ba ff ff       	call   80102de0 <kfree>
            *pte = 0;
80107329:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010732c:	83 c4 10             	add    $0x10,%esp
8010732f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (; a  < oldsz; a += PGSIZE) {
80107335:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010733b:	39 f3                	cmp    %esi,%ebx
8010733d:	73 25                	jae    80107364 <deallocuvm.part.0+0x84>
        pte = walkpgdir(pgdir, (char*)a, 0);
8010733f:	31 c9                	xor    %ecx,%ecx
80107341:	89 da                	mov    %ebx,%edx
80107343:	89 f8                	mov    %edi,%eax
80107345:	e8 86 fe ff ff       	call   801071d0 <walkpgdir>
        if (!pte) {
8010734a:	85 c0                	test   %eax,%eax
8010734c:	75 ba                	jne    80107308 <deallocuvm.part.0+0x28>
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010734e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107354:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
    for (; a  < oldsz; a += PGSIZE) {
8010735a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107360:	39 f3                	cmp    %esi,%ebx
80107362:	72 db                	jb     8010733f <deallocuvm.part.0+0x5f>
        }
    }
    return newsz;
}
80107364:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107367:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010736a:	5b                   	pop    %ebx
8010736b:	5e                   	pop    %esi
8010736c:	5f                   	pop    %edi
8010736d:	5d                   	pop    %ebp
8010736e:	c3                   	ret    
                panic("kfree");
8010736f:	83 ec 0c             	sub    $0xc,%esp
80107372:	68 b6 7d 10 80       	push   $0x80107db6
80107377:	e8 64 91 ff ff       	call   801004e0 <panic>
8010737c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107380 <seginit>:
void seginit(void) {
80107380:	55                   	push   %ebp
80107381:	89 e5                	mov    %esp,%ebp
80107383:	83 ec 18             	sub    $0x18,%esp
    c = &cpus[cpuid()];
80107386:	e8 35 cf ff ff       	call   801042c0 <cpuid>
8010738b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
    pd[0] = size - 1;
80107391:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107396:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
    c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
8010739a:	c7 80 d8 4f 11 80 ff 	movl   $0xffff,-0x7feeb028(%eax)
801073a1:	ff 00 00 
801073a4:	c7 80 dc 4f 11 80 00 	movl   $0xcf9a00,-0x7feeb024(%eax)
801073ab:	9a cf 00 
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801073ae:	c7 80 e0 4f 11 80 ff 	movl   $0xffff,-0x7feeb020(%eax)
801073b5:	ff 00 00 
801073b8:	c7 80 e4 4f 11 80 00 	movl   $0xcf9200,-0x7feeb01c(%eax)
801073bf:	92 cf 00 
    c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
801073c2:	c7 80 e8 4f 11 80 ff 	movl   $0xffff,-0x7feeb018(%eax)
801073c9:	ff 00 00 
801073cc:	c7 80 ec 4f 11 80 00 	movl   $0xcffa00,-0x7feeb014(%eax)
801073d3:	fa cf 00 
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801073d6:	c7 80 f0 4f 11 80 ff 	movl   $0xffff,-0x7feeb010(%eax)
801073dd:	ff 00 00 
801073e0:	c7 80 f4 4f 11 80 00 	movl   $0xcff200,-0x7feeb00c(%eax)
801073e7:	f2 cf 00 
    lgdt(c->gdt, sizeof(c->gdt));
801073ea:	05 d0 4f 11 80       	add    $0x80114fd0,%eax
    pd[1] = (uint)p;
801073ef:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
    pd[2] = (uint)p >> 16;
801073f3:	c1 e8 10             	shr    $0x10,%eax
801073f6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    asm volatile ("lgdt (%0)" : : "r" (pd));
801073fa:	8d 45 f2             	lea    -0xe(%ebp),%eax
801073fd:	0f 01 10             	lgdtl  (%eax)
}
80107400:	c9                   	leave  
80107401:	c3                   	ret    
80107402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107410 <switchkvm>:
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80107410:	a1 84 7c 11 80       	mov    0x80117c84,%eax
void switchkvm(void)      {
80107415:	55                   	push   %ebp
80107416:	89 e5                	mov    %esp,%ebp
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80107418:	05 00 00 00 80       	add    $0x80000000,%eax
    return val;
}

static inline void lcr3(uint val) {
    asm volatile ("movl %0,%%cr3" : : "r" (val));
8010741d:	0f 22 d8             	mov    %eax,%cr3
}
80107420:	5d                   	pop    %ebp
80107421:	c3                   	ret    
80107422:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107430 <switchuvm>:
void switchuvm(struct proc *p) {
80107430:	55                   	push   %ebp
80107431:	89 e5                	mov    %esp,%ebp
80107433:	57                   	push   %edi
80107434:	56                   	push   %esi
80107435:	53                   	push   %ebx
80107436:	83 ec 1c             	sub    $0x1c,%esp
80107439:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (p == 0) {
8010743c:	85 db                	test   %ebx,%ebx
8010743e:	0f 84 cb 00 00 00    	je     8010750f <switchuvm+0xdf>
    if (p->kstack == 0) {
80107444:	8b 43 08             	mov    0x8(%ebx),%eax
80107447:	85 c0                	test   %eax,%eax
80107449:	0f 84 da 00 00 00    	je     80107529 <switchuvm+0xf9>
    if (p->pgdir == 0) {
8010744f:	8b 43 04             	mov    0x4(%ebx),%eax
80107452:	85 c0                	test   %eax,%eax
80107454:	0f 84 c2 00 00 00    	je     8010751c <switchuvm+0xec>
    pushcli();
8010745a:	e8 11 d9 ff ff       	call   80104d70 <pushcli>
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010745f:	e8 dc cd ff ff       	call   80104240 <mycpu>
80107464:	89 c6                	mov    %eax,%esi
80107466:	e8 d5 cd ff ff       	call   80104240 <mycpu>
8010746b:	89 c7                	mov    %eax,%edi
8010746d:	e8 ce cd ff ff       	call   80104240 <mycpu>
80107472:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107475:	83 c7 08             	add    $0x8,%edi
80107478:	e8 c3 cd ff ff       	call   80104240 <mycpu>
8010747d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107480:	83 c0 08             	add    $0x8,%eax
80107483:	ba 67 00 00 00       	mov    $0x67,%edx
80107488:	c1 e8 18             	shr    $0x18,%eax
8010748b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107492:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107499:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
    mycpu()->ts.iomb = (ushort) 0xFFFF;
8010749f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801074a4:	83 c1 08             	add    $0x8,%ecx
801074a7:	c1 e9 10             	shr    $0x10,%ecx
801074aa:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801074b0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801074b5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
801074bc:	be 10 00 00 00       	mov    $0x10,%esi
    mycpu()->gdt[SEG_TSS].s = 0;
801074c1:	e8 7a cd ff ff       	call   80104240 <mycpu>
801074c6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
801074cd:	e8 6e cd ff ff       	call   80104240 <mycpu>
801074d2:	66 89 70 10          	mov    %si,0x10(%eax)
    mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801074d6:	8b 73 08             	mov    0x8(%ebx),%esi
801074d9:	e8 62 cd ff ff       	call   80104240 <mycpu>
801074de:	81 c6 00 10 00 00    	add    $0x1000,%esi
801074e4:	89 70 0c             	mov    %esi,0xc(%eax)
    mycpu()->ts.iomb = (ushort) 0xFFFF;
801074e7:	e8 54 cd ff ff       	call   80104240 <mycpu>
801074ec:	66 89 78 6e          	mov    %di,0x6e(%eax)
    asm volatile ("ltr %0" : : "r" (sel));
801074f0:	b8 28 00 00 00       	mov    $0x28,%eax
801074f5:	0f 00 d8             	ltr    %ax
    lcr3(V2P(p->pgdir));  // switch to process's address space
801074f8:	8b 43 04             	mov    0x4(%ebx),%eax
801074fb:	05 00 00 00 80       	add    $0x80000000,%eax
    asm volatile ("movl %0,%%cr3" : : "r" (val));
80107500:	0f 22 d8             	mov    %eax,%cr3
}
80107503:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107506:	5b                   	pop    %ebx
80107507:	5e                   	pop    %esi
80107508:	5f                   	pop    %edi
80107509:	5d                   	pop    %ebp
    popcli();
8010750a:	e9 a1 d8 ff ff       	jmp    80104db0 <popcli>
        panic("switchuvm: no process");
8010750f:	83 ec 0c             	sub    $0xc,%esp
80107512:	68 9e 84 10 80       	push   $0x8010849e
80107517:	e8 c4 8f ff ff       	call   801004e0 <panic>
        panic("switchuvm: no pgdir");
8010751c:	83 ec 0c             	sub    $0xc,%esp
8010751f:	68 c9 84 10 80       	push   $0x801084c9
80107524:	e8 b7 8f ff ff       	call   801004e0 <panic>
        panic("switchuvm: no kstack");
80107529:	83 ec 0c             	sub    $0xc,%esp
8010752c:	68 b4 84 10 80       	push   $0x801084b4
80107531:	e8 aa 8f ff ff       	call   801004e0 <panic>
80107536:	8d 76 00             	lea    0x0(%esi),%esi
80107539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107540 <inituvm>:
void inituvm(pde_t *pgdir, char *init, uint sz) {
80107540:	55                   	push   %ebp
80107541:	89 e5                	mov    %esp,%ebp
80107543:	57                   	push   %edi
80107544:	56                   	push   %esi
80107545:	53                   	push   %ebx
80107546:	83 ec 1c             	sub    $0x1c,%esp
80107549:	8b 75 10             	mov    0x10(%ebp),%esi
8010754c:	8b 45 08             	mov    0x8(%ebp),%eax
8010754f:	8b 7d 0c             	mov    0xc(%ebp),%edi
    if (sz >= PGSIZE) {
80107552:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
void inituvm(pde_t *pgdir, char *init, uint sz) {
80107558:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (sz >= PGSIZE) {
8010755b:	77 49                	ja     801075a6 <inituvm+0x66>
    mem = kalloc();
8010755d:	e8 2e ba ff ff       	call   80102f90 <kalloc>
    memset(mem, 0, PGSIZE);
80107562:	83 ec 04             	sub    $0x4,%esp
    mem = kalloc();
80107565:	89 c3                	mov    %eax,%ebx
    memset(mem, 0, PGSIZE);
80107567:	68 00 10 00 00       	push   $0x1000
8010756c:	6a 00                	push   $0x0
8010756e:	50                   	push   %eax
8010756f:	e8 dc d9 ff ff       	call   80104f50 <memset>
    mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80107574:	58                   	pop    %eax
80107575:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010757b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107580:	5a                   	pop    %edx
80107581:	6a 06                	push   $0x6
80107583:	50                   	push   %eax
80107584:	31 d2                	xor    %edx,%edx
80107586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107589:	e8 c2 fc ff ff       	call   80107250 <mappages>
    memmove(mem, init, sz);
8010758e:	89 75 10             	mov    %esi,0x10(%ebp)
80107591:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107594:	83 c4 10             	add    $0x10,%esp
80107597:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010759a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010759d:	5b                   	pop    %ebx
8010759e:	5e                   	pop    %esi
8010759f:	5f                   	pop    %edi
801075a0:	5d                   	pop    %ebp
    memmove(mem, init, sz);
801075a1:	e9 5a da ff ff       	jmp    80105000 <memmove>
        panic("inituvm: more than a page");
801075a6:	83 ec 0c             	sub    $0xc,%esp
801075a9:	68 dd 84 10 80       	push   $0x801084dd
801075ae:	e8 2d 8f ff ff       	call   801004e0 <panic>
801075b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801075b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075c0 <loaduvm>:
int loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz) {
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	57                   	push   %edi
801075c4:	56                   	push   %esi
801075c5:	53                   	push   %ebx
801075c6:	83 ec 0c             	sub    $0xc,%esp
    if ((uint) addr % PGSIZE != 0) {
801075c9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801075d0:	0f 85 91 00 00 00    	jne    80107667 <loaduvm+0xa7>
    for (i = 0; i < sz; i += PGSIZE) {
801075d6:	8b 75 18             	mov    0x18(%ebp),%esi
801075d9:	31 db                	xor    %ebx,%ebx
801075db:	85 f6                	test   %esi,%esi
801075dd:	75 1a                	jne    801075f9 <loaduvm+0x39>
801075df:	eb 6f                	jmp    80107650 <loaduvm+0x90>
801075e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801075ee:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801075f4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801075f7:	76 57                	jbe    80107650 <loaduvm+0x90>
        if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0) {
801075f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801075fc:	8b 45 08             	mov    0x8(%ebp),%eax
801075ff:	31 c9                	xor    %ecx,%ecx
80107601:	01 da                	add    %ebx,%edx
80107603:	e8 c8 fb ff ff       	call   801071d0 <walkpgdir>
80107608:	85 c0                	test   %eax,%eax
8010760a:	74 4e                	je     8010765a <loaduvm+0x9a>
        pa = PTE_ADDR(*pte);
8010760c:	8b 00                	mov    (%eax),%eax
        if (readi(ip, P2V(pa), offset + i, n) != n) {
8010760e:	8b 4d 14             	mov    0x14(%ebp),%ecx
        if (sz - i < PGSIZE) {
80107611:	bf 00 10 00 00       	mov    $0x1000,%edi
        pa = PTE_ADDR(*pte);
80107616:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        if (sz - i < PGSIZE) {
8010761b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107621:	0f 46 fe             	cmovbe %esi,%edi
        if (readi(ip, P2V(pa), offset + i, n) != n) {
80107624:	01 d9                	add    %ebx,%ecx
80107626:	05 00 00 00 80       	add    $0x80000000,%eax
8010762b:	57                   	push   %edi
8010762c:	51                   	push   %ecx
8010762d:	50                   	push   %eax
8010762e:	ff 75 10             	pushl  0x10(%ebp)
80107631:	e8 fa ad ff ff       	call   80102430 <readi>
80107636:	83 c4 10             	add    $0x10,%esp
80107639:	39 f8                	cmp    %edi,%eax
8010763b:	74 ab                	je     801075e8 <loaduvm+0x28>
}
8010763d:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80107640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107645:	5b                   	pop    %ebx
80107646:	5e                   	pop    %esi
80107647:	5f                   	pop    %edi
80107648:	5d                   	pop    %ebp
80107649:	c3                   	ret    
8010764a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107650:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107653:	31 c0                	xor    %eax,%eax
}
80107655:	5b                   	pop    %ebx
80107656:	5e                   	pop    %esi
80107657:	5f                   	pop    %edi
80107658:	5d                   	pop    %ebp
80107659:	c3                   	ret    
            panic("loaduvm: address should exist");
8010765a:	83 ec 0c             	sub    $0xc,%esp
8010765d:	68 f7 84 10 80       	push   $0x801084f7
80107662:	e8 79 8e ff ff       	call   801004e0 <panic>
        panic("loaduvm: addr must be page aligned");
80107667:	83 ec 0c             	sub    $0xc,%esp
8010766a:	68 98 85 10 80       	push   $0x80108598
8010766f:	e8 6c 8e ff ff       	call   801004e0 <panic>
80107674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010767a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107680 <allocuvm>:
int allocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80107680:	55                   	push   %ebp
80107681:	89 e5                	mov    %esp,%ebp
80107683:	57                   	push   %edi
80107684:	56                   	push   %esi
80107685:	53                   	push   %ebx
80107686:	83 ec 1c             	sub    $0x1c,%esp
    if (newsz >= KERNBASE) {
80107689:	8b 7d 10             	mov    0x10(%ebp),%edi
8010768c:	85 ff                	test   %edi,%edi
8010768e:	0f 88 8e 00 00 00    	js     80107722 <allocuvm+0xa2>
    if (newsz < oldsz) {
80107694:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107697:	0f 82 93 00 00 00    	jb     80107730 <allocuvm+0xb0>
    a = PGROUNDUP(oldsz);
8010769d:	8b 45 0c             	mov    0xc(%ebp),%eax
801076a0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801076a6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; a < newsz; a += PGSIZE) {
801076ac:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801076af:	0f 86 7e 00 00 00    	jbe    80107733 <allocuvm+0xb3>
801076b5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801076b8:	8b 7d 08             	mov    0x8(%ebp),%edi
801076bb:	eb 42                	jmp    801076ff <allocuvm+0x7f>
801076bd:	8d 76 00             	lea    0x0(%esi),%esi
        memset(mem, 0, PGSIZE);
801076c0:	83 ec 04             	sub    $0x4,%esp
801076c3:	68 00 10 00 00       	push   $0x1000
801076c8:	6a 00                	push   $0x0
801076ca:	50                   	push   %eax
801076cb:	e8 80 d8 ff ff       	call   80104f50 <memset>
        if (mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
801076d0:	58                   	pop    %eax
801076d1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801076d7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076dc:	5a                   	pop    %edx
801076dd:	6a 06                	push   $0x6
801076df:	50                   	push   %eax
801076e0:	89 da                	mov    %ebx,%edx
801076e2:	89 f8                	mov    %edi,%eax
801076e4:	e8 67 fb ff ff       	call   80107250 <mappages>
801076e9:	83 c4 10             	add    $0x10,%esp
801076ec:	85 c0                	test   %eax,%eax
801076ee:	78 50                	js     80107740 <allocuvm+0xc0>
    for (; a < newsz; a += PGSIZE) {
801076f0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801076f6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801076f9:	0f 86 81 00 00 00    	jbe    80107780 <allocuvm+0x100>
        mem = kalloc();
801076ff:	e8 8c b8 ff ff       	call   80102f90 <kalloc>
        if (mem == 0) {
80107704:	85 c0                	test   %eax,%eax
        mem = kalloc();
80107706:	89 c6                	mov    %eax,%esi
        if (mem == 0) {
80107708:	75 b6                	jne    801076c0 <allocuvm+0x40>
            cprintf("allocuvm out of memory\n");
8010770a:	83 ec 0c             	sub    $0xc,%esp
8010770d:	68 15 85 10 80       	push   $0x80108515
80107712:	e8 49 91 ff ff       	call   80100860 <cprintf>
    if (newsz >= oldsz) {
80107717:	83 c4 10             	add    $0x10,%esp
8010771a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010771d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107720:	77 6e                	ja     80107790 <allocuvm+0x110>
}
80107722:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
80107725:	31 ff                	xor    %edi,%edi
}
80107727:	89 f8                	mov    %edi,%eax
80107729:	5b                   	pop    %ebx
8010772a:	5e                   	pop    %esi
8010772b:	5f                   	pop    %edi
8010772c:	5d                   	pop    %ebp
8010772d:	c3                   	ret    
8010772e:	66 90                	xchg   %ax,%ax
        return oldsz;
80107730:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107733:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107736:	89 f8                	mov    %edi,%eax
80107738:	5b                   	pop    %ebx
80107739:	5e                   	pop    %esi
8010773a:	5f                   	pop    %edi
8010773b:	5d                   	pop    %ebp
8010773c:	c3                   	ret    
8010773d:	8d 76 00             	lea    0x0(%esi),%esi
            cprintf("allocuvm out of memory (2)\n");
80107740:	83 ec 0c             	sub    $0xc,%esp
80107743:	68 2d 85 10 80       	push   $0x8010852d
80107748:	e8 13 91 ff ff       	call   80100860 <cprintf>
    if (newsz >= oldsz) {
8010774d:	83 c4 10             	add    $0x10,%esp
80107750:	8b 45 0c             	mov    0xc(%ebp),%eax
80107753:	39 45 10             	cmp    %eax,0x10(%ebp)
80107756:	76 0d                	jbe    80107765 <allocuvm+0xe5>
80107758:	89 c1                	mov    %eax,%ecx
8010775a:	8b 55 10             	mov    0x10(%ebp),%edx
8010775d:	8b 45 08             	mov    0x8(%ebp),%eax
80107760:	e8 7b fb ff ff       	call   801072e0 <deallocuvm.part.0>
            kfree(mem);
80107765:	83 ec 0c             	sub    $0xc,%esp
            return 0;
80107768:	31 ff                	xor    %edi,%edi
            kfree(mem);
8010776a:	56                   	push   %esi
8010776b:	e8 70 b6 ff ff       	call   80102de0 <kfree>
            return 0;
80107770:	83 c4 10             	add    $0x10,%esp
}
80107773:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107776:	89 f8                	mov    %edi,%eax
80107778:	5b                   	pop    %ebx
80107779:	5e                   	pop    %esi
8010777a:	5f                   	pop    %edi
8010777b:	5d                   	pop    %ebp
8010777c:	c3                   	ret    
8010777d:	8d 76 00             	lea    0x0(%esi),%esi
80107780:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107783:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107786:	5b                   	pop    %ebx
80107787:	89 f8                	mov    %edi,%eax
80107789:	5e                   	pop    %esi
8010778a:	5f                   	pop    %edi
8010778b:	5d                   	pop    %ebp
8010778c:	c3                   	ret    
8010778d:	8d 76 00             	lea    0x0(%esi),%esi
80107790:	89 c1                	mov    %eax,%ecx
80107792:	8b 55 10             	mov    0x10(%ebp),%edx
80107795:	8b 45 08             	mov    0x8(%ebp),%eax
            return 0;
80107798:	31 ff                	xor    %edi,%edi
8010779a:	e8 41 fb ff ff       	call   801072e0 <deallocuvm.part.0>
8010779f:	eb 92                	jmp    80107733 <allocuvm+0xb3>
801077a1:	eb 0d                	jmp    801077b0 <deallocuvm>
801077a3:	90                   	nop
801077a4:	90                   	nop
801077a5:	90                   	nop
801077a6:	90                   	nop
801077a7:	90                   	nop
801077a8:	90                   	nop
801077a9:	90                   	nop
801077aa:	90                   	nop
801077ab:	90                   	nop
801077ac:	90                   	nop
801077ad:	90                   	nop
801077ae:	90                   	nop
801077af:	90                   	nop

801077b0 <deallocuvm>:
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	8b 55 0c             	mov    0xc(%ebp),%edx
801077b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801077b9:	8b 45 08             	mov    0x8(%ebp),%eax
    if (newsz >= oldsz) {
801077bc:	39 d1                	cmp    %edx,%ecx
801077be:	73 10                	jae    801077d0 <deallocuvm+0x20>
}
801077c0:	5d                   	pop    %ebp
801077c1:	e9 1a fb ff ff       	jmp    801072e0 <deallocuvm.part.0>
801077c6:	8d 76 00             	lea    0x0(%esi),%esi
801077c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801077d0:	89 d0                	mov    %edx,%eax
801077d2:	5d                   	pop    %ebp
801077d3:	c3                   	ret    
801077d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801077da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801077e0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void freevm(pde_t *pgdir) {
801077e0:	55                   	push   %ebp
801077e1:	89 e5                	mov    %esp,%ebp
801077e3:	57                   	push   %edi
801077e4:	56                   	push   %esi
801077e5:	53                   	push   %ebx
801077e6:	83 ec 0c             	sub    $0xc,%esp
801077e9:	8b 75 08             	mov    0x8(%ebp),%esi
    uint i;

    if (pgdir == 0) {
801077ec:	85 f6                	test   %esi,%esi
801077ee:	74 59                	je     80107849 <freevm+0x69>
801077f0:	31 c9                	xor    %ecx,%ecx
801077f2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801077f7:	89 f0                	mov    %esi,%eax
801077f9:	e8 e2 fa ff ff       	call   801072e0 <deallocuvm.part.0>
801077fe:	89 f3                	mov    %esi,%ebx
80107800:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107806:	eb 0f                	jmp    80107817 <freevm+0x37>
80107808:	90                   	nop
80107809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107810:	83 c3 04             	add    $0x4,%ebx
        panic("freevm: no pgdir");
    }
    deallocuvm(pgdir, KERNBASE, 0);
    for (i = 0; i < NPDENTRIES; i++) {
80107813:	39 fb                	cmp    %edi,%ebx
80107815:	74 23                	je     8010783a <freevm+0x5a>
        if (pgdir[i] & PTE_P) {
80107817:	8b 03                	mov    (%ebx),%eax
80107819:	a8 01                	test   $0x1,%al
8010781b:	74 f3                	je     80107810 <freevm+0x30>
            char * v = P2V(PTE_ADDR(pgdir[i]));
8010781d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
            kfree(v);
80107822:	83 ec 0c             	sub    $0xc,%esp
80107825:	83 c3 04             	add    $0x4,%ebx
            char * v = P2V(PTE_ADDR(pgdir[i]));
80107828:	05 00 00 00 80       	add    $0x80000000,%eax
            kfree(v);
8010782d:	50                   	push   %eax
8010782e:	e8 ad b5 ff ff       	call   80102de0 <kfree>
80107833:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NPDENTRIES; i++) {
80107836:	39 fb                	cmp    %edi,%ebx
80107838:	75 dd                	jne    80107817 <freevm+0x37>
        }
    }
    kfree((char*)pgdir);
8010783a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010783d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107840:	5b                   	pop    %ebx
80107841:	5e                   	pop    %esi
80107842:	5f                   	pop    %edi
80107843:	5d                   	pop    %ebp
    kfree((char*)pgdir);
80107844:	e9 97 b5 ff ff       	jmp    80102de0 <kfree>
        panic("freevm: no pgdir");
80107849:	83 ec 0c             	sub    $0xc,%esp
8010784c:	68 49 85 10 80       	push   $0x80108549
80107851:	e8 8a 8c ff ff       	call   801004e0 <panic>
80107856:	8d 76 00             	lea    0x0(%esi),%esi
80107859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107860 <setupkvm>:
pde_t*setupkvm(void) {
80107860:	55                   	push   %ebp
80107861:	89 e5                	mov    %esp,%ebp
80107863:	56                   	push   %esi
80107864:	53                   	push   %ebx
    if ((pgdir = (pde_t*)kalloc()) == 0) {
80107865:	e8 26 b7 ff ff       	call   80102f90 <kalloc>
8010786a:	85 c0                	test   %eax,%eax
8010786c:	89 c6                	mov    %eax,%esi
8010786e:	74 42                	je     801078b2 <setupkvm+0x52>
    memset(pgdir, 0, PGSIZE);
80107870:	83 ec 04             	sub    $0x4,%esp
    for (k = kmap; k < &kmap[NELEM(kmap)]; k++) {
80107873:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
    memset(pgdir, 0, PGSIZE);
80107878:	68 00 10 00 00       	push   $0x1000
8010787d:	6a 00                	push   $0x0
8010787f:	50                   	push   %eax
80107880:	e8 cb d6 ff ff       	call   80104f50 <memset>
80107885:	83 c4 10             	add    $0x10,%esp
                     (uint)k->phys_start, k->perm) < 0) {
80107888:	8b 43 04             	mov    0x4(%ebx),%eax
        if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010788b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010788e:	83 ec 08             	sub    $0x8,%esp
80107891:	8b 13                	mov    (%ebx),%edx
80107893:	ff 73 0c             	pushl  0xc(%ebx)
80107896:	50                   	push   %eax
80107897:	29 c1                	sub    %eax,%ecx
80107899:	89 f0                	mov    %esi,%eax
8010789b:	e8 b0 f9 ff ff       	call   80107250 <mappages>
801078a0:	83 c4 10             	add    $0x10,%esp
801078a3:	85 c0                	test   %eax,%eax
801078a5:	78 19                	js     801078c0 <setupkvm+0x60>
    for (k = kmap; k < &kmap[NELEM(kmap)]; k++) {
801078a7:	83 c3 10             	add    $0x10,%ebx
801078aa:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
801078b0:	75 d6                	jne    80107888 <setupkvm+0x28>
}
801078b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801078b5:	89 f0                	mov    %esi,%eax
801078b7:	5b                   	pop    %ebx
801078b8:	5e                   	pop    %esi
801078b9:	5d                   	pop    %ebp
801078ba:	c3                   	ret    
801078bb:	90                   	nop
801078bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            freevm(pgdir);
801078c0:	83 ec 0c             	sub    $0xc,%esp
801078c3:	56                   	push   %esi
            return 0;
801078c4:	31 f6                	xor    %esi,%esi
            freevm(pgdir);
801078c6:	e8 15 ff ff ff       	call   801077e0 <freevm>
            return 0;
801078cb:	83 c4 10             	add    $0x10,%esp
}
801078ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801078d1:	89 f0                	mov    %esi,%eax
801078d3:	5b                   	pop    %ebx
801078d4:	5e                   	pop    %esi
801078d5:	5d                   	pop    %ebp
801078d6:	c3                   	ret    
801078d7:	89 f6                	mov    %esi,%esi
801078d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801078e0 <kvmalloc>:
void kvmalloc(void)  {
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	83 ec 08             	sub    $0x8,%esp
    kpgdir = setupkvm();
801078e6:	e8 75 ff ff ff       	call   80107860 <setupkvm>
801078eb:	a3 84 7c 11 80       	mov    %eax,0x80117c84
    lcr3(V2P(kpgdir));   // switch to the kernel page table
801078f0:	05 00 00 00 80       	add    $0x80000000,%eax
801078f5:	0f 22 d8             	mov    %eax,%cr3
}
801078f8:	c9                   	leave  
801078f9:	c3                   	ret    
801078fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107900 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void clearpteu(pde_t *pgdir, char *uva) {
80107900:	55                   	push   %ebp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
80107901:	31 c9                	xor    %ecx,%ecx
void clearpteu(pde_t *pgdir, char *uva) {
80107903:	89 e5                	mov    %esp,%ebp
80107905:	83 ec 08             	sub    $0x8,%esp
    pte = walkpgdir(pgdir, uva, 0);
80107908:	8b 55 0c             	mov    0xc(%ebp),%edx
8010790b:	8b 45 08             	mov    0x8(%ebp),%eax
8010790e:	e8 bd f8 ff ff       	call   801071d0 <walkpgdir>
    if (pte == 0) {
80107913:	85 c0                	test   %eax,%eax
80107915:	74 05                	je     8010791c <clearpteu+0x1c>
        panic("clearpteu");
    }
    *pte &= ~PTE_U;
80107917:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010791a:	c9                   	leave  
8010791b:	c3                   	ret    
        panic("clearpteu");
8010791c:	83 ec 0c             	sub    $0xc,%esp
8010791f:	68 5a 85 10 80       	push   $0x8010855a
80107924:	e8 b7 8b ff ff       	call   801004e0 <panic>
80107929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107930 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t* copyuvm(pde_t *pgdir, uint sz) {
80107930:	55                   	push   %ebp
80107931:	89 e5                	mov    %esp,%ebp
80107933:	57                   	push   %edi
80107934:	56                   	push   %esi
80107935:	53                   	push   %ebx
80107936:	83 ec 1c             	sub    $0x1c,%esp
    pde_t *d;
    pte_t *pte;
    uint pa, i, flags;
    char *mem;

    if ((d = setupkvm()) == 0) {
80107939:	e8 22 ff ff ff       	call   80107860 <setupkvm>
8010793e:	85 c0                	test   %eax,%eax
80107940:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107943:	0f 84 9f 00 00 00    	je     801079e8 <copyuvm+0xb8>
        return 0;
    }
    for (i = 0; i < sz; i += PGSIZE) {
80107949:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010794c:	85 db                	test   %ebx,%ebx
8010794e:	0f 84 94 00 00 00    	je     801079e8 <copyuvm+0xb8>
80107954:	31 ff                	xor    %edi,%edi
80107956:	eb 4a                	jmp    801079a2 <copyuvm+0x72>
80107958:	90                   	nop
80107959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        flags = PTE_FLAGS(*pte);
        if ((mem = kalloc()) == 0) {
            freevm(d);
            return 0;
        }
        memmove(mem, (char*)P2V(pa), PGSIZE);
80107960:	83 ec 04             	sub    $0x4,%esp
80107963:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107969:	68 00 10 00 00       	push   $0x1000
8010796e:	53                   	push   %ebx
8010796f:	50                   	push   %eax
80107970:	e8 8b d6 ff ff       	call   80105000 <memmove>
        if (mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107975:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010797b:	5a                   	pop    %edx
8010797c:	59                   	pop    %ecx
8010797d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107980:	50                   	push   %eax
80107981:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107986:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107989:	89 fa                	mov    %edi,%edx
8010798b:	e8 c0 f8 ff ff       	call   80107250 <mappages>
80107990:	83 c4 10             	add    $0x10,%esp
80107993:	85 c0                	test   %eax,%eax
80107995:	78 61                	js     801079f8 <copyuvm+0xc8>
    for (i = 0; i < sz; i += PGSIZE) {
80107997:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010799d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801079a0:	76 46                	jbe    801079e8 <copyuvm+0xb8>
        if ((pte = walkpgdir(pgdir, (void *) i, 0)) == 0) {
801079a2:	8b 45 08             	mov    0x8(%ebp),%eax
801079a5:	31 c9                	xor    %ecx,%ecx
801079a7:	89 fa                	mov    %edi,%edx
801079a9:	e8 22 f8 ff ff       	call   801071d0 <walkpgdir>
801079ae:	85 c0                	test   %eax,%eax
801079b0:	74 7a                	je     80107a2c <copyuvm+0xfc>
        if (!(*pte & PTE_P)) {
801079b2:	8b 00                	mov    (%eax),%eax
801079b4:	a8 01                	test   $0x1,%al
801079b6:	74 67                	je     80107a1f <copyuvm+0xef>
        pa = PTE_ADDR(*pte);
801079b8:	89 c3                	mov    %eax,%ebx
        flags = PTE_FLAGS(*pte);
801079ba:	25 ff 0f 00 00       	and    $0xfff,%eax
        pa = PTE_ADDR(*pte);
801079bf:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
        flags = PTE_FLAGS(*pte);
801079c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if ((mem = kalloc()) == 0) {
801079c8:	e8 c3 b5 ff ff       	call   80102f90 <kalloc>
801079cd:	85 c0                	test   %eax,%eax
801079cf:	89 c6                	mov    %eax,%esi
801079d1:	75 8d                	jne    80107960 <copyuvm+0x30>
            freevm(d);
801079d3:	83 ec 0c             	sub    $0xc,%esp
801079d6:	ff 75 e0             	pushl  -0x20(%ebp)
801079d9:	e8 02 fe ff ff       	call   801077e0 <freevm>
            return 0;
801079de:	83 c4 10             	add    $0x10,%esp
801079e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            freevm(d);
            return 0;
        }
    }
    return d;
}
801079e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079ee:	5b                   	pop    %ebx
801079ef:	5e                   	pop    %esi
801079f0:	5f                   	pop    %edi
801079f1:	5d                   	pop    %ebp
801079f2:	c3                   	ret    
801079f3:	90                   	nop
801079f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            kfree(mem);
801079f8:	83 ec 0c             	sub    $0xc,%esp
801079fb:	56                   	push   %esi
801079fc:	e8 df b3 ff ff       	call   80102de0 <kfree>
            freevm(d);
80107a01:	58                   	pop    %eax
80107a02:	ff 75 e0             	pushl  -0x20(%ebp)
80107a05:	e8 d6 fd ff ff       	call   801077e0 <freevm>
            return 0;
80107a0a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107a11:	83 c4 10             	add    $0x10,%esp
}
80107a14:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a17:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a1a:	5b                   	pop    %ebx
80107a1b:	5e                   	pop    %esi
80107a1c:	5f                   	pop    %edi
80107a1d:	5d                   	pop    %ebp
80107a1e:	c3                   	ret    
            panic("copyuvm: page not present");
80107a1f:	83 ec 0c             	sub    $0xc,%esp
80107a22:	68 7e 85 10 80       	push   $0x8010857e
80107a27:	e8 b4 8a ff ff       	call   801004e0 <panic>
            panic("copyuvm: pte should exist");
80107a2c:	83 ec 0c             	sub    $0xc,%esp
80107a2f:	68 64 85 10 80       	push   $0x80108564
80107a34:	e8 a7 8a ff ff       	call   801004e0 <panic>
80107a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a40 <uva2ka>:


// Map user virtual address to kernel address.
char*uva2ka(pde_t *pgdir, char *uva)      {
80107a40:	55                   	push   %ebp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
80107a41:	31 c9                	xor    %ecx,%ecx
char*uva2ka(pde_t *pgdir, char *uva)      {
80107a43:	89 e5                	mov    %esp,%ebp
80107a45:	83 ec 08             	sub    $0x8,%esp
    pte = walkpgdir(pgdir, uva, 0);
80107a48:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a4b:	8b 45 08             	mov    0x8(%ebp),%eax
80107a4e:	e8 7d f7 ff ff       	call   801071d0 <walkpgdir>
    if ((*pte & PTE_P) == 0) {
80107a53:	8b 00                	mov    (%eax),%eax
    }
    if ((*pte & PTE_U) == 0) {
        return 0;
    }
    return (char*)P2V(PTE_ADDR(*pte));
}
80107a55:	c9                   	leave  
    if ((*pte & PTE_U) == 0) {
80107a56:	89 c2                	mov    %eax,%edx
    return (char*)P2V(PTE_ADDR(*pte));
80107a58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if ((*pte & PTE_U) == 0) {
80107a5d:	83 e2 05             	and    $0x5,%edx
    return (char*)P2V(PTE_ADDR(*pte));
80107a60:	05 00 00 00 80       	add    $0x80000000,%eax
80107a65:	83 fa 05             	cmp    $0x5,%edx
80107a68:	ba 00 00 00 00       	mov    $0x0,%edx
80107a6d:	0f 45 c2             	cmovne %edx,%eax
}
80107a70:	c3                   	ret    
80107a71:	eb 0d                	jmp    80107a80 <copyout>
80107a73:	90                   	nop
80107a74:	90                   	nop
80107a75:	90                   	nop
80107a76:	90                   	nop
80107a77:	90                   	nop
80107a78:	90                   	nop
80107a79:	90                   	nop
80107a7a:	90                   	nop
80107a7b:	90                   	nop
80107a7c:	90                   	nop
80107a7d:	90                   	nop
80107a7e:	90                   	nop
80107a7f:	90                   	nop

80107a80 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int copyout(pde_t *pgdir, uint va, void *p, uint len)     {
80107a80:	55                   	push   %ebp
80107a81:	89 e5                	mov    %esp,%ebp
80107a83:	57                   	push   %edi
80107a84:	56                   	push   %esi
80107a85:	53                   	push   %ebx
80107a86:	83 ec 1c             	sub    $0x1c,%esp
80107a89:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107a8c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a8f:	8b 7d 10             	mov    0x10(%ebp),%edi
    char *buf, *pa0;
    uint n, va0;

    buf = (char*)p;
    while (len > 0) {
80107a92:	85 db                	test   %ebx,%ebx
80107a94:	75 40                	jne    80107ad6 <copyout+0x56>
80107a96:	eb 70                	jmp    80107b08 <copyout+0x88>
80107a98:	90                   	nop
80107a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        va0 = (uint)PGROUNDDOWN(va);
        pa0 = uva2ka(pgdir, (char*)va0);
        if (pa0 == 0) {
            return -1;
        }
        n = PGSIZE - (va - va0);
80107aa0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107aa3:	89 f1                	mov    %esi,%ecx
80107aa5:	29 d1                	sub    %edx,%ecx
80107aa7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107aad:	39 d9                	cmp    %ebx,%ecx
80107aaf:	0f 47 cb             	cmova  %ebx,%ecx
        if (n > len) {
            n = len;
        }
        memmove(pa0 + (va - va0), buf, n);
80107ab2:	29 f2                	sub    %esi,%edx
80107ab4:	83 ec 04             	sub    $0x4,%esp
80107ab7:	01 d0                	add    %edx,%eax
80107ab9:	51                   	push   %ecx
80107aba:	57                   	push   %edi
80107abb:	50                   	push   %eax
80107abc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107abf:	e8 3c d5 ff ff       	call   80105000 <memmove>
        len -= n;
        buf += n;
80107ac4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    while (len > 0) {
80107ac7:	83 c4 10             	add    $0x10,%esp
        va = va0 + PGSIZE;
80107aca:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
        buf += n;
80107ad0:	01 cf                	add    %ecx,%edi
    while (len > 0) {
80107ad2:	29 cb                	sub    %ecx,%ebx
80107ad4:	74 32                	je     80107b08 <copyout+0x88>
        va0 = (uint)PGROUNDDOWN(va);
80107ad6:	89 d6                	mov    %edx,%esi
        pa0 = uva2ka(pgdir, (char*)va0);
80107ad8:	83 ec 08             	sub    $0x8,%esp
        va0 = (uint)PGROUNDDOWN(va);
80107adb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107ade:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
        pa0 = uva2ka(pgdir, (char*)va0);
80107ae4:	56                   	push   %esi
80107ae5:	ff 75 08             	pushl  0x8(%ebp)
80107ae8:	e8 53 ff ff ff       	call   80107a40 <uva2ka>
        if (pa0 == 0) {
80107aed:	83 c4 10             	add    $0x10,%esp
80107af0:	85 c0                	test   %eax,%eax
80107af2:	75 ac                	jne    80107aa0 <copyout+0x20>
    }
    return 0;
}
80107af4:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80107af7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107afc:	5b                   	pop    %ebx
80107afd:	5e                   	pop    %esi
80107afe:	5f                   	pop    %edi
80107aff:	5d                   	pop    %ebp
80107b00:	c3                   	ret    
80107b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b08:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107b0b:	31 c0                	xor    %eax,%eax
}
80107b0d:	5b                   	pop    %ebx
80107b0e:	5e                   	pop    %esi
80107b0f:	5f                   	pop    %edi
80107b10:	5d                   	pop    %ebp
80107b11:	c3                   	ret    
