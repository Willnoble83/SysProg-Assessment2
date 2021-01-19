
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
8010002d:	b8 60 35 10 80       	mov    $0x80103560,%eax
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
8010004c:	68 e0 76 10 80       	push   $0x801076e0
80100051:	68 c0 d5 10 80       	push   $0x8010d5c0
80100056:	e8 95 48 00 00       	call   801048f0 <initlock>
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
80100092:	68 e7 76 10 80       	push   $0x801076e7
80100097:	50                   	push   %eax
80100098:	e8 23 47 00 00       	call   801047c0 <initsleeplock>
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
801000e4:	e8 47 49 00 00       	call   80104a30 <acquire>
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
80100162:	e8 89 49 00 00       	call   80104af0 <release>
            acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 46 00 00       	call   80104800 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
    struct buf *b;

    b = bget(dev, blockno);
    if ((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
        iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 5d 26 00 00       	call   801027e0 <iderw>
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
80100193:	68 ee 76 10 80       	push   $0x801076ee
80100198:	e8 e3 02 00 00       	call   80100480 <panic>
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
801001ae:	e8 ed 46 00 00       	call   801048a0 <holdingsleep>
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
801001c4:	e9 17 26 00 00       	jmp    801027e0 <iderw>
        panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 ff 76 10 80       	push   $0x801076ff
801001d1:	e8 aa 02 00 00       	call   80100480 <panic>
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
801001ef:	e8 ac 46 00 00       	call   801048a0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
        panic("brelse");
    }

    releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 46 00 00       	call   80104860 <releasesleep>

    acquire(&bcache.lock);
80100204:	c7 04 24 c0 d5 10 80 	movl   $0x8010d5c0,(%esp)
8010020b:	e8 20 48 00 00       	call   80104a30 <acquire>
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
8010025c:	e9 8f 48 00 00       	jmp    80104af0 <release>
        panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 77 10 80       	push   $0x80107706
80100269:	e8 12 02 00 00       	call   80100480 <panic>
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
80100370:	e8 ab 1a 00 00       	call   80101e20 <iunlock>
    acquire(&cons.lock);
80100375:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010037c:	e8 af 46 00 00       	call   80104a30 <acquire>
    while (n > 0) {
80100381:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100384:	83 c4 10             	add    $0x10,%esp
80100387:	31 c0                	xor    %eax,%eax
80100389:	85 db                	test   %ebx,%ebx
8010038b:	0f 8e a1 00 00 00    	jle    80100432 <consoleread+0xd2>
        while (input.r == input.w) {
80100391:	8b 15 a0 1f 11 80    	mov    0x80111fa0,%edx
80100397:	39 15 a4 1f 11 80    	cmp    %edx,0x80111fa4
8010039d:	74 2c                	je     801003cb <consoleread+0x6b>
8010039f:	eb 5f                	jmp    80100400 <consoleread+0xa0>
801003a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            sleep(&input.r, &cons.lock);
801003a8:	83 ec 08             	sub    $0x8,%esp
801003ab:	68 20 c5 10 80       	push   $0x8010c520
801003b0:	68 a0 1f 11 80       	push   $0x80111fa0
801003b5:	e8 b6 40 00 00       	call   80104470 <sleep>
        while (input.r == input.w) {
801003ba:	8b 15 a0 1f 11 80    	mov    0x80111fa0,%edx
801003c0:	83 c4 10             	add    $0x10,%esp
801003c3:	3b 15 a4 1f 11 80    	cmp    0x80111fa4,%edx
801003c9:	75 35                	jne    80100400 <consoleread+0xa0>
            if (myproc()->killed) {
801003cb:	e8 00 3b 00 00       	call   80103ed0 <myproc>
801003d0:	8b 40 24             	mov    0x24(%eax),%eax
801003d3:	85 c0                	test   %eax,%eax
801003d5:	74 d1                	je     801003a8 <consoleread+0x48>
                release(&cons.lock);
801003d7:	83 ec 0c             	sub    $0xc,%esp
801003da:	68 20 c5 10 80       	push   $0x8010c520
801003df:	e8 0c 47 00 00       	call   80104af0 <release>
                ilock(ip);
801003e4:	89 3c 24             	mov    %edi,(%esp)
801003e7:	e8 54 19 00 00       	call   80101d40 <ilock>
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
80100403:	a3 a0 1f 11 80       	mov    %eax,0x80111fa0
80100408:	89 d0                	mov    %edx,%eax
8010040a:	83 e0 7f             	and    $0x7f,%eax
8010040d:	0f be 80 20 1f 11 80 	movsbl -0x7feee0e0(%eax),%eax
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
8010043d:	e8 ae 46 00 00       	call   80104af0 <release>
    ilock(ip);
80100442:	89 3c 24             	mov    %edi,(%esp)
80100445:	e8 f6 18 00 00       	call   80101d40 <ilock>
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
80100462:	89 15 a0 1f 11 80    	mov    %edx,0x80111fa0
80100468:	eb c8                	jmp    80100432 <consoleread+0xd2>
8010046a:	8b 45 10             	mov    0x10(%ebp),%eax
8010046d:	29 d8                	sub    %ebx,%eax
8010046f:	eb c1                	jmp    80100432 <consoleread+0xd2>
80100471:	eb 0d                	jmp    80100480 <panic>
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

80100480 <panic>:
void panic(char *s) {
80100480:	55                   	push   %ebp
80100481:	89 e5                	mov    %esp,%ebp
80100483:	56                   	push   %esi
80100484:	53                   	push   %ebx
80100485:	83 ec 30             	sub    $0x30,%esp
static inline void loadgs(ushort v)  {
    asm volatile ("movw %0, %%gs" : : "r" (v));
}

static inline void cli(void) {
    asm volatile ("cli");
80100488:	fa                   	cli    
    cons.locking = 0;
80100489:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
80100490:	00 00 00 
    getcallerpcs(&s, pcs);
80100493:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100496:	8d 75 f8             	lea    -0x8(%ebp),%esi
    cprintf("lapicid %d: panic: ", lapicid());
80100499:	e8 52 29 00 00       	call   80102df0 <lapicid>
8010049e:	83 ec 08             	sub    $0x8,%esp
801004a1:	50                   	push   %eax
801004a2:	68 0d 77 10 80       	push   $0x8010770d
801004a7:	e8 54 03 00 00       	call   80100800 <cprintf>
    cprintf(s);
801004ac:	58                   	pop    %eax
801004ad:	ff 75 08             	pushl  0x8(%ebp)
801004b0:	e8 4b 03 00 00       	call   80100800 <cprintf>
    cprintf("\n");
801004b5:	c7 04 24 a3 80 10 80 	movl   $0x801080a3,(%esp)
801004bc:	e8 3f 03 00 00       	call   80100800 <cprintf>
    getcallerpcs(&s, pcs);
801004c1:	5a                   	pop    %edx
801004c2:	8d 45 08             	lea    0x8(%ebp),%eax
801004c5:	59                   	pop    %ecx
801004c6:	53                   	push   %ebx
801004c7:	50                   	push   %eax
801004c8:	e8 43 44 00 00       	call   80104910 <getcallerpcs>
801004cd:	83 c4 10             	add    $0x10,%esp
        cprintf(" %p", pcs[i]);
801004d0:	83 ec 08             	sub    $0x8,%esp
801004d3:	ff 33                	pushl  (%ebx)
801004d5:	83 c3 04             	add    $0x4,%ebx
801004d8:	68 21 77 10 80       	push   $0x80107721
801004dd:	e8 1e 03 00 00       	call   80100800 <cprintf>
    for (i = 0; i < 10; i++) {
801004e2:	83 c4 10             	add    $0x10,%esp
801004e5:	39 f3                	cmp    %esi,%ebx
801004e7:	75 e7                	jne    801004d0 <panic+0x50>
    panicked = 1; // freeze other CPU
801004e9:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
801004f0:	00 00 00 
801004f3:	eb fe                	jmp    801004f3 <panic+0x73>
801004f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801004f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100500 <consputc>:
    if (panicked) {
80100500:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
80100506:	85 c9                	test   %ecx,%ecx
80100508:	74 06                	je     80100510 <consputc+0x10>
8010050a:	fa                   	cli    
8010050b:	eb fe                	jmp    8010050b <consputc+0xb>
8010050d:	8d 76 00             	lea    0x0(%esi),%esi
void consputc(int c) {
80100510:	55                   	push   %ebp
80100511:	89 e5                	mov    %esp,%ebp
80100513:	57                   	push   %edi
80100514:	56                   	push   %esi
80100515:	53                   	push   %ebx
80100516:	89 c6                	mov    %eax,%esi
80100518:	83 ec 0c             	sub    $0xc,%esp
    if (c == BACKSPACE) {
8010051b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100520:	0f 84 82 00 00 00    	je     801005a8 <consputc+0xa8>
        uartputc(c);
80100526:	83 ec 0c             	sub    $0xc,%esp
80100529:	50                   	push   %eax
8010052a:	e8 91 5d 00 00       	call   801062c0 <uartputc>
8010052f:	83 c4 10             	add    $0x10,%esp
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100532:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100537:	b8 0e 00 00 00       	mov    $0xe,%eax
8010053c:	89 da                	mov    %ebx,%edx
8010053e:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
8010053f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100544:	89 ca                	mov    %ecx,%edx
80100546:	ec                   	in     (%dx),%al
80100547:	89 c7                	mov    %eax,%edi
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100549:	89 da                	mov    %ebx,%edx
8010054b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100550:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100551:	89 ca                	mov    %ecx,%edx
80100553:	ec                   	in     (%dx),%al
    if(currentvgamode ==0x03) //If we are in text, work as usual
80100554:	83 3d c0 a0 10 80 03 	cmpl   $0x3,0x8010a0c0
8010055b:	0f b6 d8             	movzbl %al,%ebx
8010055e:	0f 84 e2 00 00 00    	je     80100646 <consputc+0x146>
        if (c == '\n') {
80100564:	83 fe 0a             	cmp    $0xa,%esi
80100567:	8b 0d c0 1f 11 80    	mov    0x80111fc0,%ecx
8010056d:	0f 84 ba 00 00 00    	je     8010062d <consputc+0x12d>
        else if (c == BACKSPACE) {
80100573:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100579:	74 57                	je     801005d2 <consputc+0xd2>
            snapshotInstance.registerValues[snapshotInstance.cursorPos] = (c & 0xff) | 0x0700;  // black on white
8010057b:	89 f0                	mov    %esi,%eax
            snapshotInstance.cursorPos++;
8010057d:	83 c1 01             	add    $0x1,%ecx
            snapshotInstance.registerValues[snapshotInstance.cursorPos] = (c & 0xff) | 0x0700;  // black on white
80100580:	88 81 c3 1f 11 80    	mov    %al,-0x7feee03d(%ecx)
            snapshotInstance.cursorPos++;
80100586:	89 0d c0 1f 11 80    	mov    %ecx,0x80111fc0
        if (snapshotInstance.cursorPos < 0 || snapshotInstance.cursorPos > 25 * 80) {
8010058c:	81 f9 d0 07 00 00    	cmp    $0x7d0,%ecx
80100592:	0f 87 88 00 00 00    	ja     80100620 <consputc+0x120>
        if ((snapshotInstance.cursorPos / 80) >= 24) { // Scroll up.
80100598:	81 f9 7f 07 00 00    	cmp    $0x77f,%ecx
8010059e:	7f 41                	jg     801005e1 <consputc+0xe1>
}
801005a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005a3:	5b                   	pop    %ebx
801005a4:	5e                   	pop    %esi
801005a5:	5f                   	pop    %edi
801005a6:	5d                   	pop    %ebp
801005a7:	c3                   	ret    
        uartputc('\b');
801005a8:	83 ec 0c             	sub    $0xc,%esp
801005ab:	6a 08                	push   $0x8
801005ad:	e8 0e 5d 00 00       	call   801062c0 <uartputc>
        uartputc(' ');
801005b2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801005b9:	e8 02 5d 00 00       	call   801062c0 <uartputc>
        uartputc('\b');
801005be:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801005c5:	e8 f6 5c 00 00       	call   801062c0 <uartputc>
801005ca:	83 c4 10             	add    $0x10,%esp
801005cd:	e9 60 ff ff ff       	jmp    80100532 <consputc+0x32>
            if (snapshotInstance.cursorPos > 0) {
801005d2:	85 c9                	test   %ecx,%ecx
801005d4:	7e b6                	jle    8010058c <consputc+0x8c>
                --snapshotInstance.cursorPos;
801005d6:	83 e9 01             	sub    $0x1,%ecx
801005d9:	89 0d c0 1f 11 80    	mov    %ecx,0x80111fc0
801005df:	eb ab                	jmp    8010058c <consputc+0x8c>
            memmove(snapshotInstance.registerValues, snapshotInstance.registerValues + 80, sizeof(snapshotInstance.registerValues[0]) * 23 * 80);
801005e1:	50                   	push   %eax
801005e2:	68 30 07 00 00       	push   $0x730
801005e7:	68 14 20 11 80       	push   $0x80112014
801005ec:	68 c4 1f 11 80       	push   $0x80111fc4
801005f1:	e8 fa 45 00 00       	call   80104bf0 <memmove>
            snapshotInstance.cursorPos -= 80;
801005f6:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
            memset(snapshotInstance.registerValues + snapshotInstance.cursorPos, 0, sizeof(snapshotInstance.registerValues[0]) * (24 * 80 - snapshotInstance.cursorPos));
801005fb:	ba 80 07 00 00       	mov    $0x780,%edx
80100600:	83 c4 0c             	add    $0xc,%esp
            snapshotInstance.cursorPos -= 80;
80100603:	83 e8 50             	sub    $0x50,%eax
            memset(snapshotInstance.registerValues + snapshotInstance.cursorPos, 0, sizeof(snapshotInstance.registerValues[0]) * (24 * 80 - snapshotInstance.cursorPos));
80100606:	29 c2                	sub    %eax,%edx
            snapshotInstance.cursorPos -= 80;
80100608:	a3 c0 1f 11 80       	mov    %eax,0x80111fc0
            memset(snapshotInstance.registerValues + snapshotInstance.cursorPos, 0, sizeof(snapshotInstance.registerValues[0]) * (24 * 80 - snapshotInstance.cursorPos));
8010060d:	05 c4 1f 11 80       	add    $0x80111fc4,%eax
80100612:	52                   	push   %edx
80100613:	6a 00                	push   $0x0
80100615:	50                   	push   %eax
80100616:	e8 25 45 00 00       	call   80104b40 <memset>
8010061b:	83 c4 10             	add    $0x10,%esp
}
8010061e:	eb 80                	jmp    801005a0 <consputc+0xa0>
            panic("pos under/overflow");
80100620:	83 ec 0c             	sub    $0xc,%esp
80100623:	68 25 77 10 80       	push   $0x80107725
80100628:	e8 53 fe ff ff       	call   80100480 <panic>
            snapshotInstance.cursorPos += 80 - snapshotInstance.cursorPos % 80;
8010062d:	89 c8                	mov    %ecx,%eax
8010062f:	bb 50 00 00 00       	mov    $0x50,%ebx
80100634:	99                   	cltd   
80100635:	f7 fb                	idiv   %ebx
80100637:	29 d3                	sub    %edx,%ebx
80100639:	01 d9                	add    %ebx,%ecx
8010063b:	89 0d c0 1f 11 80    	mov    %ecx,0x80111fc0
80100641:	e9 46 ff ff ff       	jmp    8010058c <consputc+0x8c>
    pos = inb(CRTPORT + 1) << 8;
80100646:	89 f8                	mov    %edi,%eax
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	c1 e0 08             	shl    $0x8,%eax
    pos |= inb(CRTPORT + 1);
8010064e:	09 c3                	or     %eax,%ebx
        if (c == '\n') {
80100650:	83 fe 0a             	cmp    $0xa,%esi
80100653:	0f 84 a9 00 00 00    	je     80100702 <consputc+0x202>
        else if (c == BACKSPACE) {
80100659:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010065f:	0f 84 91 00 00 00    	je     801006f6 <consputc+0x1f6>
            crt[pos++] = (c & 0xff) | 0x0700;  // black on white
80100665:	89 f0                	mov    %esi,%eax
80100667:	0f b6 c0             	movzbl %al,%eax
8010066a:	80 cc 07             	or     $0x7,%ah
8010066d:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100674:	80 
80100675:	83 c3 01             	add    $0x1,%ebx
        if (pos < 0 || pos > 25 * 80) {
80100678:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010067e:	7f a0                	jg     80100620 <consputc+0x120>
        if ((pos / 80) >= 24) { // Scroll up.
80100680:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100686:	7e 38                	jle    801006c0 <consputc+0x1c0>
            memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
80100688:	52                   	push   %edx
80100689:	68 60 0e 00 00       	push   $0xe60
            pos -= 80;
8010068e:	83 eb 50             	sub    $0x50,%ebx
            memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
80100691:	68 a0 80 0b 80       	push   $0x800b80a0
80100696:	68 00 80 0b 80       	push   $0x800b8000
8010069b:	e8 50 45 00 00       	call   80104bf0 <memmove>
            memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
801006a0:	b8 80 07 00 00       	mov    $0x780,%eax
801006a5:	83 c4 0c             	add    $0xc,%esp
801006a8:	29 d8                	sub    %ebx,%eax
801006aa:	01 c0                	add    %eax,%eax
801006ac:	50                   	push   %eax
801006ad:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
801006b0:	6a 00                	push   $0x0
801006b2:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
801006b7:	50                   	push   %eax
801006b8:	e8 83 44 00 00       	call   80104b40 <memset>
801006bd:	83 c4 10             	add    $0x10,%esp
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801006c0:	be d4 03 00 00       	mov    $0x3d4,%esi
801006c5:	b8 0e 00 00 00       	mov    $0xe,%eax
801006ca:	89 f2                	mov    %esi,%edx
801006cc:	ee                   	out    %al,(%dx)
801006cd:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
        outb(CRTPORT + 1, pos >> 8);
801006d2:	89 d8                	mov    %ebx,%eax
801006d4:	c1 f8 08             	sar    $0x8,%eax
801006d7:	89 ca                	mov    %ecx,%edx
801006d9:	ee                   	out    %al,(%dx)
801006da:	b8 0f 00 00 00       	mov    $0xf,%eax
801006df:	89 f2                	mov    %esi,%edx
801006e1:	ee                   	out    %al,(%dx)
801006e2:	89 d8                	mov    %ebx,%eax
801006e4:	89 ca                	mov    %ecx,%edx
801006e6:	ee                   	out    %al,(%dx)
        crt[pos] = ' ' | 0x0700;
801006e7:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
801006ee:	80 20 07 
801006f1:	e9 aa fe ff ff       	jmp    801005a0 <consputc+0xa0>
            if (pos > 0) {
801006f6:	85 db                	test   %ebx,%ebx
801006f8:	74 c6                	je     801006c0 <consputc+0x1c0>
                --pos;
801006fa:	83 eb 01             	sub    $0x1,%ebx
801006fd:	e9 76 ff ff ff       	jmp    80100678 <consputc+0x178>
            pos += 80 - pos % 80;
80100702:	89 d8                	mov    %ebx,%eax
80100704:	b9 50 00 00 00       	mov    $0x50,%ecx
80100709:	99                   	cltd   
8010070a:	f7 f9                	idiv   %ecx
8010070c:	29 d1                	sub    %edx,%ecx
8010070e:	01 cb                	add    %ecx,%ebx
80100710:	e9 63 ff ff ff       	jmp    80100678 <consputc+0x178>
80100715:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100720 <printint>:
static void printint(int xx, int base, int sign) {
80100720:	55                   	push   %ebp
80100721:	89 e5                	mov    %esp,%ebp
80100723:	57                   	push   %edi
80100724:	56                   	push   %esi
80100725:	53                   	push   %ebx
80100726:	89 d3                	mov    %edx,%ebx
80100728:	83 ec 2c             	sub    $0x2c,%esp
    if (sign && (sign = xx < 0)) {
8010072b:	85 c9                	test   %ecx,%ecx
static void printint(int xx, int base, int sign) {
8010072d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    if (sign && (sign = xx < 0)) {
80100730:	74 04                	je     80100736 <printint+0x16>
80100732:	85 c0                	test   %eax,%eax
80100734:	78 5a                	js     80100790 <printint+0x70>
        x = xx;
80100736:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    i = 0;
8010073d:	31 c9                	xor    %ecx,%ecx
8010073f:	8d 75 d7             	lea    -0x29(%ebp),%esi
80100742:	eb 06                	jmp    8010074a <printint+0x2a>
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        buf[i++] = digits[x % base];
80100748:	89 f9                	mov    %edi,%ecx
8010074a:	31 d2                	xor    %edx,%edx
8010074c:	8d 79 01             	lea    0x1(%ecx),%edi
8010074f:	f7 f3                	div    %ebx
80100751:	0f b6 92 50 77 10 80 	movzbl -0x7fef88b0(%edx),%edx
    while ((x /= base) != 0);
80100758:	85 c0                	test   %eax,%eax
        buf[i++] = digits[x % base];
8010075a:	88 14 3e             	mov    %dl,(%esi,%edi,1)
    while ((x /= base) != 0);
8010075d:	75 e9                	jne    80100748 <printint+0x28>
    if (sign) {
8010075f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100762:	85 c0                	test   %eax,%eax
80100764:	74 08                	je     8010076e <printint+0x4e>
        buf[i++] = '-';
80100766:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
8010076b:	8d 79 02             	lea    0x2(%ecx),%edi
8010076e:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
80100772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        consputc(buf[i]);
80100778:	0f be 03             	movsbl (%ebx),%eax
8010077b:	83 eb 01             	sub    $0x1,%ebx
8010077e:	e8 7d fd ff ff       	call   80100500 <consputc>
    while (--i >= 0) {
80100783:	39 f3                	cmp    %esi,%ebx
80100785:	75 f1                	jne    80100778 <printint+0x58>
}
80100787:	83 c4 2c             	add    $0x2c,%esp
8010078a:	5b                   	pop    %ebx
8010078b:	5e                   	pop    %esi
8010078c:	5f                   	pop    %edi
8010078d:	5d                   	pop    %ebp
8010078e:	c3                   	ret    
8010078f:	90                   	nop
        x = -xx;
80100790:	f7 d8                	neg    %eax
80100792:	eb a9                	jmp    8010073d <printint+0x1d>
80100794:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010079a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801007a0 <consolewrite>:
int consolewrite(struct inode *ip, char *buf, int n) {
801007a0:	55                   	push   %ebp
801007a1:	89 e5                	mov    %esp,%ebp
801007a3:	57                   	push   %edi
801007a4:	56                   	push   %esi
801007a5:	53                   	push   %ebx
801007a6:	83 ec 18             	sub    $0x18,%esp
801007a9:	8b 75 10             	mov    0x10(%ebp),%esi
    iunlock(ip);
801007ac:	ff 75 08             	pushl  0x8(%ebp)
801007af:	e8 6c 16 00 00       	call   80101e20 <iunlock>
    acquire(&cons.lock);
801007b4:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
801007bb:	e8 70 42 00 00       	call   80104a30 <acquire>
    for (i = 0; i < n; i++) {
801007c0:	83 c4 10             	add    $0x10,%esp
801007c3:	85 f6                	test   %esi,%esi
801007c5:	7e 18                	jle    801007df <consolewrite+0x3f>
801007c7:	8b 7d 0c             	mov    0xc(%ebp),%edi
801007ca:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
801007cd:	8d 76 00             	lea    0x0(%esi),%esi
        consputc(buf[i] & 0xff);
801007d0:	0f b6 07             	movzbl (%edi),%eax
801007d3:	83 c7 01             	add    $0x1,%edi
801007d6:	e8 25 fd ff ff       	call   80100500 <consputc>
    for (i = 0; i < n; i++) {
801007db:	39 fb                	cmp    %edi,%ebx
801007dd:	75 f1                	jne    801007d0 <consolewrite+0x30>
    release(&cons.lock);
801007df:	83 ec 0c             	sub    $0xc,%esp
801007e2:	68 20 c5 10 80       	push   $0x8010c520
801007e7:	e8 04 43 00 00       	call   80104af0 <release>
    ilock(ip);
801007ec:	58                   	pop    %eax
801007ed:	ff 75 08             	pushl  0x8(%ebp)
801007f0:	e8 4b 15 00 00       	call   80101d40 <ilock>
}
801007f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801007f8:	89 f0                	mov    %esi,%eax
801007fa:	5b                   	pop    %ebx
801007fb:	5e                   	pop    %esi
801007fc:	5f                   	pop    %edi
801007fd:	5d                   	pop    %ebp
801007fe:	c3                   	ret    
801007ff:	90                   	nop

80100800 <cprintf>:
void cprintf(char *fmt, ...) {
80100800:	55                   	push   %ebp
80100801:	89 e5                	mov    %esp,%ebp
80100803:	57                   	push   %edi
80100804:	56                   	push   %esi
80100805:	53                   	push   %ebx
80100806:	83 ec 1c             	sub    $0x1c,%esp
    locking = cons.locking;
80100809:	a1 54 c5 10 80       	mov    0x8010c554,%eax
    if (locking) {
8010080e:	85 c0                	test   %eax,%eax
    locking = cons.locking;
80100810:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (locking) {
80100813:	0f 85 6f 01 00 00    	jne    80100988 <cprintf+0x188>
    if (fmt == 0) {
80100819:	8b 45 08             	mov    0x8(%ebp),%eax
8010081c:	85 c0                	test   %eax,%eax
8010081e:	89 c7                	mov    %eax,%edi
80100820:	0f 84 77 01 00 00    	je     8010099d <cprintf+0x19d>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
80100826:	0f b6 00             	movzbl (%eax),%eax
    argp = (uint*)(void*)(&fmt + 1);
80100829:	8d 4d 0c             	lea    0xc(%ebp),%ecx
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
8010082c:	31 db                	xor    %ebx,%ebx
    argp = (uint*)(void*)(&fmt + 1);
8010082e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
80100831:	85 c0                	test   %eax,%eax
80100833:	75 56                	jne    8010088b <cprintf+0x8b>
80100835:	eb 79                	jmp    801008b0 <cprintf+0xb0>
80100837:	89 f6                	mov    %esi,%esi
80100839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        c = fmt[++i] & 0xff;
80100840:	0f b6 16             	movzbl (%esi),%edx
        if (c == 0) {
80100843:	85 d2                	test   %edx,%edx
80100845:	74 69                	je     801008b0 <cprintf+0xb0>
80100847:	83 c3 02             	add    $0x2,%ebx
        switch (c) {
8010084a:	83 fa 70             	cmp    $0x70,%edx
8010084d:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
80100850:	0f 84 84 00 00 00    	je     801008da <cprintf+0xda>
80100856:	7f 78                	jg     801008d0 <cprintf+0xd0>
80100858:	83 fa 25             	cmp    $0x25,%edx
8010085b:	0f 84 ff 00 00 00    	je     80100960 <cprintf+0x160>
80100861:	83 fa 64             	cmp    $0x64,%edx
80100864:	0f 85 8e 00 00 00    	jne    801008f8 <cprintf+0xf8>
                printint(*argp++, 10, 1);
8010086a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010086d:	ba 0a 00 00 00       	mov    $0xa,%edx
80100872:	8d 48 04             	lea    0x4(%eax),%ecx
80100875:	8b 00                	mov    (%eax),%eax
80100877:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010087a:	b9 01 00 00 00       	mov    $0x1,%ecx
8010087f:	e8 9c fe ff ff       	call   80100720 <printint>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
80100884:	0f b6 06             	movzbl (%esi),%eax
80100887:	85 c0                	test   %eax,%eax
80100889:	74 25                	je     801008b0 <cprintf+0xb0>
8010088b:	8d 53 01             	lea    0x1(%ebx),%edx
        if (c != '%') {
8010088e:	83 f8 25             	cmp    $0x25,%eax
80100891:	8d 34 17             	lea    (%edi,%edx,1),%esi
80100894:	74 aa                	je     80100840 <cprintf+0x40>
80100896:	89 55 e0             	mov    %edx,-0x20(%ebp)
            consputc(c);
80100899:	e8 62 fc ff ff       	call   80100500 <consputc>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
8010089e:	0f b6 06             	movzbl (%esi),%eax
            continue;
801008a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801008a4:	89 d3                	mov    %edx,%ebx
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
801008a6:	85 c0                	test   %eax,%eax
801008a8:	75 e1                	jne    8010088b <cprintf+0x8b>
801008aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (locking) {
801008b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
801008b3:	85 c0                	test   %eax,%eax
801008b5:	74 10                	je     801008c7 <cprintf+0xc7>
        release(&cons.lock);
801008b7:	83 ec 0c             	sub    $0xc,%esp
801008ba:	68 20 c5 10 80       	push   $0x8010c520
801008bf:	e8 2c 42 00 00       	call   80104af0 <release>
801008c4:	83 c4 10             	add    $0x10,%esp
}
801008c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008ca:	5b                   	pop    %ebx
801008cb:	5e                   	pop    %esi
801008cc:	5f                   	pop    %edi
801008cd:	5d                   	pop    %ebp
801008ce:	c3                   	ret    
801008cf:	90                   	nop
        switch (c) {
801008d0:	83 fa 73             	cmp    $0x73,%edx
801008d3:	74 43                	je     80100918 <cprintf+0x118>
801008d5:	83 fa 78             	cmp    $0x78,%edx
801008d8:	75 1e                	jne    801008f8 <cprintf+0xf8>
                printint(*argp++, 16, 0);
801008da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801008dd:	ba 10 00 00 00       	mov    $0x10,%edx
801008e2:	8d 48 04             	lea    0x4(%eax),%ecx
801008e5:	8b 00                	mov    (%eax),%eax
801008e7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801008ea:	31 c9                	xor    %ecx,%ecx
801008ec:	e8 2f fe ff ff       	call   80100720 <printint>
                break;
801008f1:	eb 91                	jmp    80100884 <cprintf+0x84>
801008f3:	90                   	nop
801008f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                consputc('%');
801008f8:	b8 25 00 00 00       	mov    $0x25,%eax
801008fd:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100900:	e8 fb fb ff ff       	call   80100500 <consputc>
                consputc(c);
80100905:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100908:	89 d0                	mov    %edx,%eax
8010090a:	e8 f1 fb ff ff       	call   80100500 <consputc>
                break;
8010090f:	e9 70 ff ff ff       	jmp    80100884 <cprintf+0x84>
80100914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                if ((s = (char*)*argp++) == 0) {
80100918:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010091b:	8b 10                	mov    (%eax),%edx
8010091d:	8d 48 04             	lea    0x4(%eax),%ecx
80100920:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100923:	85 d2                	test   %edx,%edx
80100925:	74 49                	je     80100970 <cprintf+0x170>
                for (; *s; s++) {
80100927:	0f be 02             	movsbl (%edx),%eax
                if ((s = (char*)*argp++) == 0) {
8010092a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
                for (; *s; s++) {
8010092d:	84 c0                	test   %al,%al
8010092f:	0f 84 4f ff ff ff    	je     80100884 <cprintf+0x84>
80100935:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100938:	89 d3                	mov    %edx,%ebx
8010093a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100940:	83 c3 01             	add    $0x1,%ebx
                    consputc(*s);
80100943:	e8 b8 fb ff ff       	call   80100500 <consputc>
                for (; *s; s++) {
80100948:	0f be 03             	movsbl (%ebx),%eax
8010094b:	84 c0                	test   %al,%al
8010094d:	75 f1                	jne    80100940 <cprintf+0x140>
                if ((s = (char*)*argp++) == 0) {
8010094f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100952:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80100955:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100958:	e9 27 ff ff ff       	jmp    80100884 <cprintf+0x84>
8010095d:	8d 76 00             	lea    0x0(%esi),%esi
                consputc('%');
80100960:	b8 25 00 00 00       	mov    $0x25,%eax
80100965:	e8 96 fb ff ff       	call   80100500 <consputc>
                break;
8010096a:	e9 15 ff ff ff       	jmp    80100884 <cprintf+0x84>
8010096f:	90                   	nop
                    s = "(null)";
80100970:	ba 38 77 10 80       	mov    $0x80107738,%edx
                for (; *s; s++) {
80100975:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100978:	b8 28 00 00 00       	mov    $0x28,%eax
8010097d:	89 d3                	mov    %edx,%ebx
8010097f:	eb bf                	jmp    80100940 <cprintf+0x140>
80100981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        acquire(&cons.lock);
80100988:	83 ec 0c             	sub    $0xc,%esp
8010098b:	68 20 c5 10 80       	push   $0x8010c520
80100990:	e8 9b 40 00 00       	call   80104a30 <acquire>
80100995:	83 c4 10             	add    $0x10,%esp
80100998:	e9 7c fe ff ff       	jmp    80100819 <cprintf+0x19>
        panic("null fmt");
8010099d:	83 ec 0c             	sub    $0xc,%esp
801009a0:	68 3f 77 10 80       	push   $0x8010773f
801009a5:	e8 d6 fa ff ff       	call   80100480 <panic>
801009aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801009b0 <consoleget>:
int consoleget(void) {
801009b0:	55                   	push   %ebp
801009b1:	89 e5                	mov    %esp,%ebp
801009b3:	83 ec 24             	sub    $0x24,%esp
    acquire(&cons.lock);
801009b6:	68 20 c5 10 80       	push   $0x8010c520
801009bb:	e8 70 40 00 00       	call   80104a30 <acquire>
    while ((c = kbdgetc()) <= 0) {
801009c0:	83 c4 10             	add    $0x10,%esp
801009c3:	eb 05                	jmp    801009ca <consoleget+0x1a>
801009c5:	8d 76 00             	lea    0x0(%esi),%esi
        if (c == 0) {
801009c8:	74 26                	je     801009f0 <consoleget+0x40>
    while ((c = kbdgetc()) <= 0) {
801009ca:	e8 21 22 00 00       	call   80102bf0 <kbdgetc>
801009cf:	83 f8 00             	cmp    $0x0,%eax
801009d2:	7e f4                	jle    801009c8 <consoleget+0x18>
    release(&cons.lock);
801009d4:	83 ec 0c             	sub    $0xc,%esp
801009d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801009da:	68 20 c5 10 80       	push   $0x8010c520
801009df:	e8 0c 41 00 00       	call   80104af0 <release>
}
801009e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801009e7:	c9                   	leave  
801009e8:	c3                   	ret    
801009e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            c = kbdgetc();
801009f0:	e8 fb 21 00 00       	call   80102bf0 <kbdgetc>
801009f5:	eb d3                	jmp    801009ca <consoleget+0x1a>
801009f7:	89 f6                	mov    %esi,%esi
801009f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100a00 <consoleintr>:
void consoleintr(int (*getc)(void)) {
80100a00:	55                   	push   %ebp
80100a01:	89 e5                	mov    %esp,%ebp
80100a03:	57                   	push   %edi
80100a04:	56                   	push   %esi
80100a05:	53                   	push   %ebx
    int c, doprocdump = 0;
80100a06:	31 f6                	xor    %esi,%esi
void consoleintr(int (*getc)(void)) {
80100a08:	83 ec 18             	sub    $0x18,%esp
80100a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&cons.lock);
80100a0e:	68 20 c5 10 80       	push   $0x8010c520
80100a13:	e8 18 40 00 00       	call   80104a30 <acquire>
    while ((c = getc()) >= 0) {
80100a18:	83 c4 10             	add    $0x10,%esp
80100a1b:	90                   	nop
80100a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a20:	ff d3                	call   *%ebx
80100a22:	85 c0                	test   %eax,%eax
80100a24:	89 c7                	mov    %eax,%edi
80100a26:	78 48                	js     80100a70 <consoleintr+0x70>
        switch (c) {
80100a28:	83 ff 10             	cmp    $0x10,%edi
80100a2b:	0f 84 e7 00 00 00    	je     80100b18 <consoleintr+0x118>
80100a31:	7e 5d                	jle    80100a90 <consoleintr+0x90>
80100a33:	83 ff 15             	cmp    $0x15,%edi
80100a36:	0f 84 ec 00 00 00    	je     80100b28 <consoleintr+0x128>
80100a3c:	83 ff 7f             	cmp    $0x7f,%edi
80100a3f:	75 54                	jne    80100a95 <consoleintr+0x95>
                if (input.e != input.w) {
80100a41:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
80100a46:	3b 05 a4 1f 11 80    	cmp    0x80111fa4,%eax
80100a4c:	74 d2                	je     80100a20 <consoleintr+0x20>
                    input.e--;
80100a4e:	83 e8 01             	sub    $0x1,%eax
80100a51:	a3 a8 1f 11 80       	mov    %eax,0x80111fa8
                    consputc(BACKSPACE);
80100a56:	b8 00 01 00 00       	mov    $0x100,%eax
80100a5b:	e8 a0 fa ff ff       	call   80100500 <consputc>
    while ((c = getc()) >= 0) {
80100a60:	ff d3                	call   *%ebx
80100a62:	85 c0                	test   %eax,%eax
80100a64:	89 c7                	mov    %eax,%edi
80100a66:	79 c0                	jns    80100a28 <consoleintr+0x28>
80100a68:	90                   	nop
80100a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&cons.lock);
80100a70:	83 ec 0c             	sub    $0xc,%esp
80100a73:	68 20 c5 10 80       	push   $0x8010c520
80100a78:	e8 73 40 00 00       	call   80104af0 <release>
    if (doprocdump) {
80100a7d:	83 c4 10             	add    $0x10,%esp
80100a80:	85 f6                	test   %esi,%esi
80100a82:	0f 85 f8 00 00 00    	jne    80100b80 <consoleintr+0x180>
}
80100a88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a8b:	5b                   	pop    %ebx
80100a8c:	5e                   	pop    %esi
80100a8d:	5f                   	pop    %edi
80100a8e:	5d                   	pop    %ebp
80100a8f:	c3                   	ret    
        switch (c) {
80100a90:	83 ff 08             	cmp    $0x8,%edi
80100a93:	74 ac                	je     80100a41 <consoleintr+0x41>
                if (c != 0 && input.e - input.r < INPUT_BUF) {
80100a95:	85 ff                	test   %edi,%edi
80100a97:	74 87                	je     80100a20 <consoleintr+0x20>
80100a99:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
80100a9e:	89 c2                	mov    %eax,%edx
80100aa0:	2b 15 a0 1f 11 80    	sub    0x80111fa0,%edx
80100aa6:	83 fa 7f             	cmp    $0x7f,%edx
80100aa9:	0f 87 71 ff ff ff    	ja     80100a20 <consoleintr+0x20>
80100aaf:	8d 50 01             	lea    0x1(%eax),%edx
80100ab2:	83 e0 7f             	and    $0x7f,%eax
                    c = (c == '\r') ? '\n' : c;
80100ab5:	83 ff 0d             	cmp    $0xd,%edi
                    input.buf[input.e++ % INPUT_BUF] = c;
80100ab8:	89 15 a8 1f 11 80    	mov    %edx,0x80111fa8
                    c = (c == '\r') ? '\n' : c;
80100abe:	0f 84 cc 00 00 00    	je     80100b90 <consoleintr+0x190>
                    input.buf[input.e++ % INPUT_BUF] = c;
80100ac4:	89 f9                	mov    %edi,%ecx
80100ac6:	88 88 20 1f 11 80    	mov    %cl,-0x7feee0e0(%eax)
                    consputc(c);
80100acc:	89 f8                	mov    %edi,%eax
80100ace:	e8 2d fa ff ff       	call   80100500 <consputc>
                    if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF) {
80100ad3:	83 ff 0a             	cmp    $0xa,%edi
80100ad6:	0f 84 c5 00 00 00    	je     80100ba1 <consoleintr+0x1a1>
80100adc:	83 ff 04             	cmp    $0x4,%edi
80100adf:	0f 84 bc 00 00 00    	je     80100ba1 <consoleintr+0x1a1>
80100ae5:	a1 a0 1f 11 80       	mov    0x80111fa0,%eax
80100aea:	83 e8 80             	sub    $0xffffff80,%eax
80100aed:	39 05 a8 1f 11 80    	cmp    %eax,0x80111fa8
80100af3:	0f 85 27 ff ff ff    	jne    80100a20 <consoleintr+0x20>
                        wakeup(&input.r);
80100af9:	83 ec 0c             	sub    $0xc,%esp
                        input.w = input.e;
80100afc:	a3 a4 1f 11 80       	mov    %eax,0x80111fa4
                        wakeup(&input.r);
80100b01:	68 a0 1f 11 80       	push   $0x80111fa0
80100b06:	e8 15 3b 00 00       	call   80104620 <wakeup>
80100b0b:	83 c4 10             	add    $0x10,%esp
80100b0e:	e9 0d ff ff ff       	jmp    80100a20 <consoleintr+0x20>
80100b13:	90                   	nop
80100b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                doprocdump = 1;
80100b18:	be 01 00 00 00       	mov    $0x1,%esi
80100b1d:	e9 fe fe ff ff       	jmp    80100a20 <consoleintr+0x20>
80100b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                while (input.e != input.w &&
80100b28:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
80100b2d:	39 05 a4 1f 11 80    	cmp    %eax,0x80111fa4
80100b33:	75 2b                	jne    80100b60 <consoleintr+0x160>
80100b35:	e9 e6 fe ff ff       	jmp    80100a20 <consoleintr+0x20>
80100b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                    input.e--;
80100b40:	a3 a8 1f 11 80       	mov    %eax,0x80111fa8
                    consputc(BACKSPACE);
80100b45:	b8 00 01 00 00       	mov    $0x100,%eax
80100b4a:	e8 b1 f9 ff ff       	call   80100500 <consputc>
                while (input.e != input.w &&
80100b4f:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
80100b54:	3b 05 a4 1f 11 80    	cmp    0x80111fa4,%eax
80100b5a:	0f 84 c0 fe ff ff    	je     80100a20 <consoleintr+0x20>
                       input.buf[(input.e - 1) % INPUT_BUF] != '\n') {
80100b60:	83 e8 01             	sub    $0x1,%eax
80100b63:	89 c2                	mov    %eax,%edx
80100b65:	83 e2 7f             	and    $0x7f,%edx
                while (input.e != input.w &&
80100b68:	80 ba 20 1f 11 80 0a 	cmpb   $0xa,-0x7feee0e0(%edx)
80100b6f:	75 cf                	jne    80100b40 <consoleintr+0x140>
80100b71:	e9 aa fe ff ff       	jmp    80100a20 <consoleintr+0x20>
80100b76:	8d 76 00             	lea    0x0(%esi),%esi
80100b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100b80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b83:	5b                   	pop    %ebx
80100b84:	5e                   	pop    %esi
80100b85:	5f                   	pop    %edi
80100b86:	5d                   	pop    %ebp
        procdump();  // now call procdump() wo. cons.lock held
80100b87:	e9 74 3b 00 00       	jmp    80104700 <procdump>
80100b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                    input.buf[input.e++ % INPUT_BUF] = c;
80100b90:	c6 80 20 1f 11 80 0a 	movb   $0xa,-0x7feee0e0(%eax)
                    consputc(c);
80100b97:	b8 0a 00 00 00       	mov    $0xa,%eax
80100b9c:	e8 5f f9 ff ff       	call   80100500 <consputc>
80100ba1:	a1 a8 1f 11 80       	mov    0x80111fa8,%eax
80100ba6:	e9 4e ff ff ff       	jmp    80100af9 <consoleintr+0xf9>
80100bab:	90                   	nop
80100bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100bb0 <consoleinit>:
void consoleinit(void) {
80100bb0:	55                   	push   %ebp
80100bb1:	89 e5                	mov    %esp,%ebp
80100bb3:	83 ec 10             	sub    $0x10,%esp
    initlock(&cons.lock, "console");
80100bb6:	68 48 77 10 80       	push   $0x80107748
80100bbb:	68 20 c5 10 80       	push   $0x8010c520
80100bc0:	e8 2b 3d 00 00       	call   801048f0 <initlock>
    ioapicenable(IRQ_KBD, 0);
80100bc5:	58                   	pop    %eax
80100bc6:	5a                   	pop    %edx
80100bc7:	6a 00                	push   $0x0
80100bc9:	6a 01                	push   $0x1
    devsw[CONSOLE].write = consolewrite;
80100bcb:	c7 05 4c 31 11 80 a0 	movl   $0x801007a0,0x8011314c
80100bd2:	07 10 80 
    devsw[CONSOLE].read = consoleread;
80100bd5:	c7 05 48 31 11 80 60 	movl   $0x80100360,0x80113148
80100bdc:	03 10 80 
    cons.locking = 1;
80100bdf:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
80100be6:	00 00 00 
    ioapicenable(IRQ_KBD, 0);
80100be9:	e8 a2 1d 00 00       	call   80102990 <ioapicenable>
}
80100bee:	83 c4 10             	add    $0x10,%esp
80100bf1:	c9                   	leave  
80100bf2:	c3                   	ret    
80100bf3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100c00 <consolevgaplane>:
void consolevgaplane(uchar plane) {
80100c00:	55                   	push   %ebp
80100c01:	b8 04 00 00 00       	mov    $0x4,%eax
80100c06:	ba ce 03 00 00       	mov    $0x3ce,%edx
80100c0b:	89 e5                	mov    %esp,%ebp
    plane &= 3;
80100c0d:	0f b6 4d 08          	movzbl 0x8(%ebp),%ecx
80100c11:	83 e1 03             	and    $0x3,%ecx
80100c14:	ee                   	out    %al,(%dx)
80100c15:	ba cf 03 00 00       	mov    $0x3cf,%edx
80100c1a:	89 c8                	mov    %ecx,%eax
80100c1c:	ee                   	out    %al,(%dx)
80100c1d:	b8 02 00 00 00       	mov    $0x2,%eax
80100c22:	ba c4 03 00 00       	mov    $0x3c4,%edx
80100c27:	ee                   	out    %al,(%dx)
    planeMask = 1 << plane;
80100c28:	b8 01 00 00 00       	mov    $0x1,%eax
80100c2d:	ba c5 03 00 00       	mov    $0x3c5,%edx
80100c32:	d3 e0                	shl    %cl,%eax
80100c34:	ee                   	out    %al,(%dx)
}
80100c35:	5d                   	pop    %ebp
80100c36:	c3                   	ret    
80100c37:	89 f6                	mov    %esi,%esi
80100c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100c40 <snapshotWrite>:
{
80100c40:	55                   	push   %ebp
80100c41:	89 e5                	mov    %esp,%ebp
}
80100c43:	5d                   	pop    %ebp
80100c44:	c3                   	ret    
80100c45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100c50 <snapshotTextRestore>:
void snapshotTextRestore()                  // For restoring the console when entering back into text mode.
{
80100c50:	55                   	push   %ebp
80100c51:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx

    // Declare some variables
    int i;
    ushort* crt = VGA_0x03_MEMORY;

    for (i = 0; i < 2000; i++) //Loop through the entire register values in our snapshot
80100c56:	31 c0                	xor    %eax,%eax
{
80100c58:	89 e5                	mov    %esp,%ebp
80100c5a:	56                   	push   %esi
80100c5b:	53                   	push   %ebx
80100c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    {
        crt[i] = (snapshotInstance.registerValues[i] & 0xff) | 0x0700;
80100c60:	0f b6 90 c4 1f 11 80 	movzbl -0x7feee03c(%eax),%edx
    for (i = 0; i < 2000; i++) //Loop through the entire register values in our snapshot
80100c67:	83 c0 01             	add    $0x1,%eax
80100c6a:	83 c1 02             	add    $0x2,%ecx
        crt[i] = (snapshotInstance.registerValues[i] & 0xff) | 0x0700;
80100c6d:	80 ce 07             	or     $0x7,%dh
80100c70:	66 89 51 fe          	mov    %dx,-0x2(%ecx)
    for (i = 0; i < 2000; i++) //Loop through the entire register values in our snapshot
80100c74:	3d d0 07 00 00       	cmp    $0x7d0,%eax
80100c79:	75 e5                	jne    80100c60 <snapshotTextRestore+0x10>
80100c7b:	be d4 03 00 00       	mov    $0x3d4,%esi
    }


    int pos = snapshotInstance.cursorPos;
80100c80:	8b 0d c0 1f 11 80    	mov    0x80111fc0,%ecx
80100c86:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c8b:	89 f2                	mov    %esi,%edx
80100c8d:	ee                   	out    %al,(%dx)
80100c8e:	bb d5 03 00 00       	mov    $0x3d5,%ebx
    outb(CRTPORT, 14);
    outb(CRTPORT + 1, pos >> 8);
80100c93:	89 c8                	mov    %ecx,%eax
80100c95:	c1 f8 08             	sar    $0x8,%eax
80100c98:	89 da                	mov    %ebx,%edx
80100c9a:	ee                   	out    %al,(%dx)
80100c9b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100ca0:	89 f2                	mov    %esi,%edx
80100ca2:	ee                   	out    %al,(%dx)
80100ca3:	89 c8                	mov    %ecx,%eax
80100ca5:	89 da                	mov    %ebx,%edx
80100ca7:	ee                   	out    %al,(%dx)
    outb(CRTPORT, 15);
    outb(CRTPORT + 1, pos);
}
80100ca8:	5b                   	pop    %ebx
80100ca9:	5e                   	pop    %esi
80100caa:	5d                   	pop    %ebp
80100cab:	c3                   	ret    
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100cb0 <snapshotTextTake>:
void snapshotTextTake()                     
{
80100cb0:	55                   	push   %ebp
80100cb1:	ba 00 80 0b 80       	mov    $0x800b8000,%edx
    // Declare some variables
    int i;
    ushort* crt = VGA_0x03_MEMORY;

    //Loop through the entire 
    for (i = 0; i < 2000; i++)
80100cb6:	31 c0                	xor    %eax,%eax
{
80100cb8:	89 e5                	mov    %esp,%ebp
80100cba:	56                   	push   %esi
80100cbb:	53                   	push   %ebx
80100cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    {
        snapshotInstance.registerValues[i] =  crt[i];
80100cc0:	0f b7 0a             	movzwl (%edx),%ecx
    for (i = 0; i < 2000; i++)
80100cc3:	83 c0 01             	add    $0x1,%eax
80100cc6:	83 c2 02             	add    $0x2,%edx
        snapshotInstance.registerValues[i] =  crt[i];
80100cc9:	88 88 c3 1f 11 80    	mov    %cl,-0x7feee03d(%eax)
    for (i = 0; i < 2000; i++)
80100ccf:	3d d0 07 00 00       	cmp    $0x7d0,%eax
80100cd4:	75 ea                	jne    80100cc0 <snapshotTextTake+0x10>
80100cd6:	be d4 03 00 00       	mov    $0x3d4,%esi
80100cdb:	b8 0e 00 00 00       	mov    $0xe,%eax
80100ce0:	89 f2                	mov    %esi,%edx
80100ce2:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100ce3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100ce8:	89 ca                	mov    %ecx,%edx
80100cea:	ec                   	in     (%dx),%al
    }
    //Take the cursor position
    int pos;     // Cursor position: col + 80*row.

    outb(0x3d4, 14);           
    pos = inb(0x3d4 + 1) << 8;  
80100ceb:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100cee:	89 f2                	mov    %esi,%edx
80100cf0:	c1 e0 08             	shl    $0x8,%eax
80100cf3:	89 c3                	mov    %eax,%ebx
80100cf5:	b8 0f 00 00 00       	mov    $0xf,%eax
80100cfa:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100cfb:	89 ca                	mov    %ecx,%edx
80100cfd:	ec                   	in     (%dx),%al
    outb(0x3d4, 15);            
    pos |= inb(0x3d4 + 1);      
80100cfe:	0f b6 c0             	movzbl %al,%eax
80100d01:	09 d8                	or     %ebx,%eax
80100d03:	a3 c0 1f 11 80       	mov    %eax,0x80111fc0

    //Store the position in our snapshot
    snapshotInstance.cursorPos = pos; 
    
}
80100d08:	5b                   	pop    %ebx
80100d09:	5e                   	pop    %esi
80100d0a:	5d                   	pop    %ebp
80100d0b:	c3                   	ret    
80100d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d10 <writeFont>:
void writeFont(uchar * fontBuffer, unsigned int fontHeight) {
80100d10:	55                   	push   %ebp
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100d11:	b8 02 00 00 00       	mov    $0x2,%eax
80100d16:	ba c4 03 00 00       	mov    $0x3c4,%edx
80100d1b:	89 e5                	mov    %esp,%ebp
80100d1d:	57                   	push   %edi
80100d1e:	56                   	push   %esi
80100d1f:	53                   	push   %ebx
80100d20:	83 ec 1c             	sub    $0x1c,%esp
80100d23:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100d26:	8b 75 0c             	mov    0xc(%ebp),%esi
80100d29:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100d2a:	ba c5 03 00 00       	mov    $0x3c5,%edx
80100d2f:	ec                   	in     (%dx),%al
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100d30:	ba c4 03 00 00       	mov    $0x3c4,%edx
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100d35:	88 45 e7             	mov    %al,-0x19(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100d38:	b8 04 00 00 00       	mov    $0x4,%eax
80100d3d:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100d3e:	ba c5 03 00 00       	mov    $0x3c5,%edx
80100d43:	ec                   	in     (%dx),%al
    outb(VGA_SEQ_INDEX, 2);
    seq2 = inb(VGA_SEQ_DATA);

    outb(VGA_SEQ_INDEX, 4);
    seq4 = inb(VGA_SEQ_DATA);
    outb(VGA_SEQ_DATA, seq4 | 0x04);
80100d44:	89 c1                	mov    %eax,%ecx
80100d46:	88 45 e6             	mov    %al,-0x1a(%ebp)
80100d49:	83 c9 04             	or     $0x4,%ecx
80100d4c:	89 c8                	mov    %ecx,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100d4e:	ee                   	out    %al,(%dx)
80100d4f:	bf ce 03 00 00       	mov    $0x3ce,%edi
80100d54:	b8 04 00 00 00       	mov    $0x4,%eax
80100d59:	89 fa                	mov    %edi,%edx
80100d5b:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100d5c:	b9 cf 03 00 00       	mov    $0x3cf,%ecx
80100d61:	89 ca                	mov    %ecx,%edx
80100d63:	ec                   	in     (%dx),%al
80100d64:	88 45 e5             	mov    %al,-0x1b(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100d67:	89 fa                	mov    %edi,%edx
80100d69:	b8 05 00 00 00       	mov    $0x5,%eax
80100d6e:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100d6f:	89 ca                	mov    %ecx,%edx
80100d71:	ec                   	in     (%dx),%al
80100d72:	88 45 e4             	mov    %al,-0x1c(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100d75:	83 e0 ef             	and    $0xffffffef,%eax
80100d78:	ee                   	out    %al,(%dx)
80100d79:	b8 06 00 00 00       	mov    $0x6,%eax
80100d7e:	89 fa                	mov    %edi,%edx
80100d80:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100d81:	89 ca                	mov    %ecx,%edx
80100d83:	ec                   	in     (%dx),%al
80100d84:	88 45 e3             	mov    %al,-0x1d(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100d87:	83 e0 fd             	and    $0xfffffffd,%eax
80100d8a:	ee                   	out    %al,(%dx)
80100d8b:	b8 04 00 00 00       	mov    $0x4,%eax
80100d90:	89 fa                	mov    %edi,%edx
80100d92:	ee                   	out    %al,(%dx)
80100d93:	b8 02 00 00 00       	mov    $0x2,%eax
80100d98:	89 ca                	mov    %ecx,%edx
80100d9a:	ee                   	out    %al,(%dx)
80100d9b:	ba c4 03 00 00       	mov    $0x3c4,%edx
80100da0:	ee                   	out    %al,(%dx)
80100da1:	b8 04 00 00 00       	mov    $0x4,%eax
80100da6:	ba c5 03 00 00       	mov    $0x3c5,%edx
80100dab:	ee                   	out    %al,(%dx)
    gc6 = inb(VGA_GC_DATA);
    outb(VGA_GC_DATA, gc6 & ~0x02);

    consolevgaplane(2);
    // Write font to video memory
    fontBase = (uchar*)P2V(0xB8000);
80100dac:	bf 00 80 0b 80       	mov    $0x800b8000,%edi
80100db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < 256; i++)
    {
        memmove((ushort*)fontBase, fontBuffer, fontHeight);
80100db8:	83 ec 04             	sub    $0x4,%esp
80100dbb:	56                   	push   %esi
80100dbc:	53                   	push   %ebx
        fontBase += 32;
        fontBuffer += fontHeight;
80100dbd:	01 f3                	add    %esi,%ebx
        memmove((ushort*)fontBase, fontBuffer, fontHeight);
80100dbf:	57                   	push   %edi
        fontBase += 32;
80100dc0:	83 c7 20             	add    $0x20,%edi
        memmove((ushort*)fontBase, fontBuffer, fontHeight);
80100dc3:	e8 28 3e 00 00       	call   80104bf0 <memmove>
    for (i = 0; i < 256; i++)
80100dc8:	83 c4 10             	add    $0x10,%esp
80100dcb:	81 ff 00 a0 0b 80    	cmp    $0x800ba000,%edi
80100dd1:	75 e5                	jne    80100db8 <writeFont+0xa8>
80100dd3:	be c4 03 00 00       	mov    $0x3c4,%esi
80100dd8:	b8 02 00 00 00       	mov    $0x2,%eax
80100ddd:	89 f2                	mov    %esi,%edx
80100ddf:	ee                   	out    %al,(%dx)
80100de0:	bb c5 03 00 00       	mov    $0x3c5,%ebx
80100de5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80100de9:	89 da                	mov    %ebx,%edx
80100deb:	ee                   	out    %al,(%dx)
80100dec:	b9 04 00 00 00       	mov    $0x4,%ecx
80100df1:	89 f2                	mov    %esi,%edx
80100df3:	89 c8                	mov    %ecx,%eax
80100df5:	ee                   	out    %al,(%dx)
80100df6:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
80100dfa:	89 da                	mov    %ebx,%edx
80100dfc:	ee                   	out    %al,(%dx)
80100dfd:	bb ce 03 00 00       	mov    $0x3ce,%ebx
80100e02:	89 c8                	mov    %ecx,%eax
80100e04:	89 da                	mov    %ebx,%edx
80100e06:	ee                   	out    %al,(%dx)
80100e07:	b9 cf 03 00 00       	mov    $0x3cf,%ecx
80100e0c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
80100e10:	89 ca                	mov    %ecx,%edx
80100e12:	ee                   	out    %al,(%dx)
80100e13:	b8 05 00 00 00       	mov    $0x5,%eax
80100e18:	89 da                	mov    %ebx,%edx
80100e1a:	ee                   	out    %al,(%dx)
80100e1b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80100e1f:	89 ca                	mov    %ecx,%edx
80100e21:	ee                   	out    %al,(%dx)
80100e22:	b8 06 00 00 00       	mov    $0x6,%eax
80100e27:	89 da                	mov    %ebx,%edx
80100e29:	ee                   	out    %al,(%dx)
80100e2a:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
80100e2e:	89 ca                	mov    %ecx,%edx
80100e30:	ee                   	out    %al,(%dx)
    outb(VGA_GC_DATA, gc4);
    outb(VGA_GC_INDEX, 5);
    outb(VGA_GC_DATA, gc5);
    outb(VGA_GC_INDEX, 6);
    outb(VGA_GC_DATA, gc6);
}
80100e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e34:	5b                   	pop    %ebx
80100e35:	5e                   	pop    %esi
80100e36:	5f                   	pop    %edi
80100e37:	5d                   	pop    %ebp
80100e38:	c3                   	ret    
80100e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e40 <consolevgamode>:
 * Currently, only these modes are supported:
 *   0x03: 80x25 text mode.
 *   0x12: 640x480x16 graphics mode.
 *   0x13: 320x200x256 graphics mode.
 */
int consolevgamode(int vgamode) {
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	56                   	push   %esi
80100e44:	53                   	push   %ebx
80100e45:	8b 45 08             	mov    0x8(%ebp),%eax
    //acquire(&cons.lock);

    int errorcode = -1;

    switch (vgamode)
80100e48:	83 f8 12             	cmp    $0x12,%eax
80100e4b:	0f 84 17 01 00 00    	je     80100f68 <consolevgamode+0x128>
80100e51:	83 f8 13             	cmp    $0x13,%eax
80100e54:	0f 84 96 00 00 00    	je     80100ef0 <consolevgamode+0xb0>
80100e5a:	83 f8 03             	cmp    $0x3,%eax
80100e5d:	74 0c                	je     80100e6b <consolevgamode+0x2b>
    }

    //release(&cons.lock);

    return errorcode;
}
80100e5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    int errorcode = -1;
80100e62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5d                   	pop    %ebp
80100e6a:	c3                   	ret    
            writeVideoRegisters(registers_80x25_text);
80100e6b:	b8 80 a0 10 80       	mov    $0x8010a080,%eax
80100e70:	e8 fb f3 ff ff       	call   80100270 <writeVideoRegisters>
            writeFont(font_8x16, 16);
80100e75:	83 ec 08             	sub    $0x8,%esp
80100e78:	6a 10                	push   $0x10
80100e7a:	68 00 90 10 80       	push   $0x80109000
80100e7f:	e8 8c fe ff ff       	call   80100d10 <writeFont>
80100e84:	83 c4 10             	add    $0x10,%esp
80100e87:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
    for (i = 0; i < 2000; i++) //Loop through the entire register values in our snapshot
80100e8c:	31 c0                	xor    %eax,%eax
80100e8e:	66 90                	xchg   %ax,%ax
        crt[i] = (snapshotInstance.registerValues[i] & 0xff) | 0x0700;
80100e90:	0f b6 90 c4 1f 11 80 	movzbl -0x7feee03c(%eax),%edx
    for (i = 0; i < 2000; i++) //Loop through the entire register values in our snapshot
80100e97:	83 c0 01             	add    $0x1,%eax
80100e9a:	83 c1 02             	add    $0x2,%ecx
        crt[i] = (snapshotInstance.registerValues[i] & 0xff) | 0x0700;
80100e9d:	80 ce 07             	or     $0x7,%dh
80100ea0:	66 89 51 fe          	mov    %dx,-0x2(%ecx)
    for (i = 0; i < 2000; i++) //Loop through the entire register values in our snapshot
80100ea4:	3d d0 07 00 00       	cmp    $0x7d0,%eax
80100ea9:	75 e5                	jne    80100e90 <consolevgamode+0x50>
80100eab:	be d4 03 00 00       	mov    $0x3d4,%esi
    int pos = snapshotInstance.cursorPos;
80100eb0:	8b 0d c0 1f 11 80    	mov    0x80111fc0,%ecx
80100eb6:	b8 0e 00 00 00       	mov    $0xe,%eax
80100ebb:	89 f2                	mov    %esi,%edx
80100ebd:	ee                   	out    %al,(%dx)
80100ebe:	bb d5 03 00 00       	mov    $0x3d5,%ebx
    outb(CRTPORT + 1, pos >> 8);
80100ec3:	89 c8                	mov    %ecx,%eax
80100ec5:	c1 f8 08             	sar    $0x8,%eax
80100ec8:	89 da                	mov    %ebx,%edx
80100eca:	ee                   	out    %al,(%dx)
80100ecb:	b8 0f 00 00 00       	mov    $0xf,%eax
80100ed0:	89 f2                	mov    %esi,%edx
80100ed2:	ee                   	out    %al,(%dx)
80100ed3:	89 c8                	mov    %ecx,%eax
80100ed5:	89 da                	mov    %ebx,%edx
80100ed7:	ee                   	out    %al,(%dx)
            currentvgamode = 0x03;
80100ed8:	c7 05 c0 a0 10 80 03 	movl   $0x3,0x8010a0c0
80100edf:	00 00 00 
}
80100ee2:	8d 65 f8             	lea    -0x8(%ebp),%esp
            errorcode = 0;
80100ee5:	31 c0                	xor    %eax,%eax
}
80100ee7:	5b                   	pop    %ebx
80100ee8:	5e                   	pop    %esi
80100ee9:	5d                   	pop    %ebp
80100eea:	c3                   	ret    
80100eeb:	90                   	nop
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch (vgamode)
80100ef0:	ba 00 80 0b 80       	mov    $0x800b8000,%edx
    for (i = 0; i < 2000; i++)
80100ef5:	31 c0                	xor    %eax,%eax
80100ef7:	89 f6                	mov    %esi,%esi
80100ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        snapshotInstance.registerValues[i] =  crt[i];
80100f00:	0f b7 0a             	movzwl (%edx),%ecx
    for (i = 0; i < 2000; i++)
80100f03:	83 c0 01             	add    $0x1,%eax
80100f06:	83 c2 02             	add    $0x2,%edx
        snapshotInstance.registerValues[i] =  crt[i];
80100f09:	88 88 c3 1f 11 80    	mov    %cl,-0x7feee03d(%eax)
    for (i = 0; i < 2000; i++)
80100f0f:	3d d0 07 00 00       	cmp    $0x7d0,%eax
80100f14:	75 ea                	jne    80100f00 <consolevgamode+0xc0>
80100f16:	be d4 03 00 00       	mov    $0x3d4,%esi
80100f1b:	b8 0e 00 00 00       	mov    $0xe,%eax
80100f20:	89 f2                	mov    %esi,%edx
80100f22:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100f23:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100f28:	89 ca                	mov    %ecx,%edx
80100f2a:	ec                   	in     (%dx),%al
    pos = inb(0x3d4 + 1) << 8;  
80100f2b:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100f2e:	89 f2                	mov    %esi,%edx
80100f30:	c1 e0 08             	shl    $0x8,%eax
80100f33:	89 c3                	mov    %eax,%ebx
80100f35:	b8 0f 00 00 00       	mov    $0xf,%eax
80100f3a:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100f3b:	89 ca                	mov    %ecx,%edx
80100f3d:	ec                   	in     (%dx),%al
    pos |= inb(0x3d4 + 1);      
80100f3e:	0f b6 c0             	movzbl %al,%eax
80100f41:	09 d8                	or     %ebx,%eax
80100f43:	a3 c0 1f 11 80       	mov    %eax,0x80111fc0
            writeVideoRegisters(registers_320x200x256);
80100f48:	b8 40 a0 10 80       	mov    $0x8010a040,%eax
80100f4d:	e8 1e f3 ff ff       	call   80100270 <writeVideoRegisters>
            currentvgamode = 0x13;
80100f52:	c7 05 c0 a0 10 80 13 	movl   $0x13,0x8010a0c0
80100f59:	00 00 00 
}
80100f5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
            errorcode = 0;
80100f5f:	31 c0                	xor    %eax,%eax
}
80100f61:	5b                   	pop    %ebx
80100f62:	5e                   	pop    %esi
80100f63:	5d                   	pop    %ebp
80100f64:	c3                   	ret    
80100f65:	8d 76 00             	lea    0x0(%esi),%esi
    switch (vgamode)
80100f68:	ba 00 80 0b 80       	mov    $0x800b8000,%edx
    for (i = 0; i < 2000; i++)
80100f6d:	31 c0                	xor    %eax,%eax
80100f6f:	90                   	nop
        snapshotInstance.registerValues[i] =  crt[i];
80100f70:	0f b7 0a             	movzwl (%edx),%ecx
    for (i = 0; i < 2000; i++)
80100f73:	83 c0 01             	add    $0x1,%eax
80100f76:	83 c2 02             	add    $0x2,%edx
        snapshotInstance.registerValues[i] =  crt[i];
80100f79:	88 88 c3 1f 11 80    	mov    %cl,-0x7feee03d(%eax)
    for (i = 0; i < 2000; i++)
80100f7f:	3d d0 07 00 00       	cmp    $0x7d0,%eax
80100f84:	75 ea                	jne    80100f70 <consolevgamode+0x130>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100f86:	be d4 03 00 00       	mov    $0x3d4,%esi
80100f8b:	b8 0e 00 00 00       	mov    $0xe,%eax
80100f90:	89 f2                	mov    %esi,%edx
80100f92:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100f93:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100f98:	89 ca                	mov    %ecx,%edx
80100f9a:	ec                   	in     (%dx),%al
    pos = inb(0x3d4 + 1) << 8;  
80100f9b:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100f9e:	89 f2                	mov    %esi,%edx
80100fa0:	c1 e0 08             	shl    $0x8,%eax
80100fa3:	89 c3                	mov    %eax,%ebx
80100fa5:	b8 0f 00 00 00       	mov    $0xf,%eax
80100faa:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100fab:	89 ca                	mov    %ecx,%edx
80100fad:	ec                   	in     (%dx),%al
    pos |= inb(0x3d4 + 1);      
80100fae:	0f b6 c0             	movzbl %al,%eax
80100fb1:	09 d8                	or     %ebx,%eax
80100fb3:	a3 c0 1f 11 80       	mov    %eax,0x80111fc0
            writeVideoRegisters(registers_640x480x16);
80100fb8:	b8 00 a0 10 80       	mov    $0x8010a000,%eax
80100fbd:	e8 ae f2 ff ff       	call   80100270 <writeVideoRegisters>
            currentvgamode = 0x12;
80100fc2:	c7 05 c0 a0 10 80 12 	movl   $0x12,0x8010a0c0
80100fc9:	00 00 00 
}
80100fcc:	8d 65 f8             	lea    -0x8(%ebp),%esp
            errorcode = 0;
80100fcf:	31 c0                	xor    %eax,%eax
}
80100fd1:	5b                   	pop    %ebx
80100fd2:	5e                   	pop    %esi
80100fd3:	5d                   	pop    %ebp
80100fd4:	c3                   	ret    
80100fd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fe0 <consolevgabuffer>:
 * http://www.osdever.net/FreeVGA/vga/vgamem.htm will give you more insight into what is going on.
 *
 * Returns a pointer to the virtual address (NOT the physical address) associated with the current
 * video plane.
 */
uchar* consolevgabuffer() {
80100fe0:	55                   	push   %ebp
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100fe1:	b8 06 00 00 00       	mov    $0x6,%eax
80100fe6:	ba ce 03 00 00       	mov    $0x3ce,%edx
80100feb:	89 e5                	mov    %esp,%ebp
80100fed:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100fee:	ba cf 03 00 00       	mov    $0x3cf,%edx
80100ff3:	ec                   	in     (%dx),%al
80100ff4:	89 c2                	mov    %eax,%edx
80100ff6:	b8 00 00 0b 80       	mov    $0x800b0000,%eax
    uchar plane;

    outb(VGA_GC_INDEX, 6);

    plane = inb(VGA_GC_DATA);
    plane >>= 2;
80100ffb:	c0 ea 02             	shr    $0x2,%dl
    plane &= 3;
80100ffe:	83 e2 03             	and    $0x3,%edx

    switch (plane)
80101001:	80 fa 02             	cmp    $0x2,%dl
80101004:	74 10                	je     80101016 <consolevgabuffer+0x36>
    {
    case 0:
    case 1:
        base = (uchar*)P2V(0xA0000);
80101006:	80 fa 03             	cmp    $0x3,%dl
80101009:	b8 00 80 0b 80       	mov    $0x800b8000,%eax
8010100e:	ba 00 00 0a 80       	mov    $0x800a0000,%edx
80101013:	0f 45 c2             	cmovne %edx,%eax
        base = (uchar*)P2V(0xB8000);
        break;
    }

    return base;
}
80101016:	5d                   	pop    %ebp
80101017:	c3                   	ret    
80101018:	90                   	nop
80101019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101020 <setpixel>:
//int pos_x, int pos_y, int VGA_COLOR
int setpixel(int pos_x, int pos_y, int VGA_COLOR)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	83 ec 0c             	sub    $0xc,%esp
80101026:	8b 45 0c             	mov    0xc(%ebp),%eax
    //cprintf("%d,%d,%d\n",pos_x,pos_y,VGA_COLOR);
    // Memory location of pixel = A0000 + 320 * y + x
    memset(VGA_0x13_MEMORY + VGA_0x13_WIDTH * pos_y + pos_x, VGA_COLOR, 1);
80101029:	6a 01                	push   $0x1
8010102b:	ff 75 10             	pushl  0x10(%ebp)
8010102e:	8d 04 80             	lea    (%eax,%eax,4),%eax
80101031:	c1 e0 06             	shl    $0x6,%eax
80101034:	03 45 08             	add    0x8(%ebp),%eax
80101037:	2d 00 00 f6 7f       	sub    $0x7ff60000,%eax
8010103c:	50                   	push   %eax
8010103d:	e8 fe 3a 00 00       	call   80104b40 <memset>
    //cprintf("Finished setting pixel!");
    return 0;
80101042:	31 c0                	xor    %eax,%eax
80101044:	c9                   	leave  
80101045:	c3                   	ret    
80101046:	66 90                	xchg   %ax,%ax
80101048:	66 90                	xchg   %ax,%ax
8010104a:	66 90                	xchg   %ax,%ax
8010104c:	66 90                	xchg   %ax,%ax
8010104e:	66 90                	xchg   %ax,%ax

80101050 <cleanupexec>:
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

void cleanupexec(pde_t * pgdir, struct inode *ip) {
80101050:	55                   	push   %ebp
80101051:	89 e5                	mov    %esp,%ebp
80101053:	53                   	push   %ebx
80101054:	83 ec 04             	sub    $0x4,%esp
80101057:	8b 45 08             	mov    0x8(%ebp),%eax
8010105a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (pgdir) {
8010105d:	85 c0                	test   %eax,%eax
8010105f:	74 0c                	je     8010106d <cleanupexec+0x1d>
        freevm(pgdir);
80101061:	83 ec 0c             	sub    $0xc,%esp
80101064:	50                   	push   %eax
80101065:	e8 26 63 00 00       	call   80107390 <freevm>
8010106a:	83 c4 10             	add    $0x10,%esp
    }
    if (ip) {
8010106d:	85 db                	test   %ebx,%ebx
8010106f:	74 1f                	je     80101090 <cleanupexec+0x40>
        iunlockput(ip);
80101071:	83 ec 0c             	sub    $0xc,%esp
80101074:	53                   	push   %ebx
80101075:	e8 56 0f 00 00       	call   80101fd0 <iunlockput>
        end_op();
8010107a:	83 c4 10             	add    $0x10,%esp
    }    
}
8010107d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101080:	c9                   	leave  
        end_op();
80101081:	e9 4a 22 00 00       	jmp    801032d0 <end_op>
80101086:	8d 76 00             	lea    0x0(%esi),%esi
80101089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80101090:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101093:	c9                   	leave  
80101094:	c3                   	ret    
80101095:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801010a0 <exec>:

int exec(char *path, char **argv) {
801010a0:	55                   	push   %ebp
801010a1:	89 e5                	mov    %esp,%ebp
801010a3:	57                   	push   %edi
801010a4:	56                   	push   %esi
801010a5:	53                   	push   %ebx
801010a6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
    uint argc, sz, sp, ustack[3 + MAXARG + 1];
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pde_t *pgdir, *oldpgdir;
    struct proc *curproc = myproc();
801010ac:	e8 1f 2e 00 00       	call   80103ed0 <myproc>
801010b1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

    begin_op();
801010b7:	e8 a4 21 00 00       	call   80103260 <begin_op>

    if ((ip = namei(path)) == 0) {
801010bc:	83 ec 0c             	sub    $0xc,%esp
801010bf:	ff 75 08             	pushl  0x8(%ebp)
801010c2:	e8 d9 14 00 00       	call   801025a0 <namei>
801010c7:	83 c4 10             	add    $0x10,%esp
801010ca:	85 c0                	test   %eax,%eax
801010cc:	0f 84 2e 03 00 00    	je     80101400 <exec+0x360>
        end_op();
        cprintf("exec: fail\n");
        return -1;
    }
    ilock(ip);
801010d2:	83 ec 0c             	sub    $0xc,%esp
801010d5:	89 c6                	mov    %eax,%esi
801010d7:	50                   	push   %eax
801010d8:	e8 63 0c 00 00       	call   80101d40 <ilock>
    pgdir = 0;

    // Check ELF header
    if (readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf)) {
801010dd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801010e3:	6a 34                	push   $0x34
801010e5:	6a 00                	push   $0x0
801010e7:	50                   	push   %eax
801010e8:	56                   	push   %esi
801010e9:	e8 32 0f 00 00       	call   80102020 <readi>
801010ee:	83 c4 20             	add    $0x20,%esp
801010f1:	83 f8 34             	cmp    $0x34,%eax
801010f4:	0f 85 c0 02 00 00    	jne    801013ba <exec+0x31a>
        cleanupexec(pgdir, ip);
        return -1;
    }
    if (elf.magic != ELF_MAGIC) {
801010fa:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101101:	45 4c 46 
80101104:	0f 85 b0 02 00 00    	jne    801013ba <exec+0x31a>
        cleanupexec(pgdir, ip);
        return -1;        
    }

    if ((pgdir = setupkvm()) == 0) {
8010110a:	e8 01 63 00 00       	call   80107410 <setupkvm>
8010110f:	85 c0                	test   %eax,%eax
80101111:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101117:	0f 84 9d 02 00 00    	je     801013ba <exec+0x31a>
        cleanupexec(pgdir, ip);
        return -1;    
    }

    // Load program into memory.
    sz = 0;
8010111d:	31 ff                	xor    %edi,%edi
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
8010111f:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101126:	00 
80101127:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
8010112d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101133:	0f 84 99 02 00 00    	je     801013d2 <exec+0x332>
80101139:	31 db                	xor    %ebx,%ebx
8010113b:	eb 7d                	jmp    801011ba <exec+0x11a>
8010113d:	8d 76 00             	lea    0x0(%esi),%esi
        if (readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph)) {
            cleanupexec(pgdir, ip);
            return -1;    
        }
        if (ph.type != ELF_PROG_LOAD) {
80101140:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101147:	75 63                	jne    801011ac <exec+0x10c>
            continue;
        }
        if (ph.memsz < ph.filesz) {
80101149:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
8010114f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101155:	0f 82 86 00 00 00    	jb     801011e1 <exec+0x141>
8010115b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101161:	72 7e                	jb     801011e1 <exec+0x141>
        }
        if (ph.vaddr + ph.memsz < ph.vaddr) {
            cleanupexec(pgdir, ip);
            return -1;    
        }
        if ((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0) {
80101163:	83 ec 04             	sub    $0x4,%esp
80101166:	50                   	push   %eax
80101167:	57                   	push   %edi
80101168:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010116e:	e8 bd 60 00 00       	call   80107230 <allocuvm>
80101173:	83 c4 10             	add    $0x10,%esp
80101176:	85 c0                	test   %eax,%eax
80101178:	89 c7                	mov    %eax,%edi
8010117a:	74 65                	je     801011e1 <exec+0x141>
            cleanupexec(pgdir, ip);
            return -1;    
        }
        if (ph.vaddr % PGSIZE != 0) {
8010117c:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80101182:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101187:	75 58                	jne    801011e1 <exec+0x141>
            cleanupexec(pgdir, ip);
            return -1;    
        }
        if (loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0) {
80101189:	83 ec 0c             	sub    $0xc,%esp
8010118c:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80101192:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80101198:	56                   	push   %esi
80101199:	50                   	push   %eax
8010119a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801011a0:	e8 cb 5f 00 00       	call   80107170 <loaduvm>
801011a5:	83 c4 20             	add    $0x20,%esp
801011a8:	85 c0                	test   %eax,%eax
801011aa:	78 35                	js     801011e1 <exec+0x141>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
801011ac:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
801011b3:	83 c3 01             	add    $0x1,%ebx
801011b6:	39 d8                	cmp    %ebx,%eax
801011b8:	7e 46                	jle    80101200 <exec+0x160>
        if (readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph)) {
801011ba:	89 d8                	mov    %ebx,%eax
801011bc:	6a 20                	push   $0x20
801011be:	c1 e0 05             	shl    $0x5,%eax
801011c1:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
801011c7:	50                   	push   %eax
801011c8:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801011ce:	50                   	push   %eax
801011cf:	56                   	push   %esi
801011d0:	e8 4b 0e 00 00       	call   80102020 <readi>
801011d5:	83 c4 10             	add    $0x10,%esp
801011d8:	83 f8 20             	cmp    $0x20,%eax
801011db:	0f 84 5f ff ff ff    	je     80101140 <exec+0xa0>
            cleanupexec(pgdir, ip);
801011e1:	83 ec 08             	sub    $0x8,%esp
801011e4:	56                   	push   %esi
801011e5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801011eb:	e8 60 fe ff ff       	call   80101050 <cleanupexec>
            return -1;    
801011f0:	83 c4 10             	add    $0x10,%esp
801011f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    curproc->tf->eip = elf.entry;  // main
    curproc->tf->esp = sp;
    switchuvm(curproc);
    freevm(oldpgdir);
    return 0;
}
801011f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011fb:	5b                   	pop    %ebx
801011fc:	5e                   	pop    %esi
801011fd:	5f                   	pop    %edi
801011fe:	5d                   	pop    %ebp
801011ff:	c3                   	ret    
80101200:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80101206:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
8010120c:	8d 9f 00 20 00 00    	lea    0x2000(%edi),%ebx
    iunlockput(ip);
80101212:	83 ec 0c             	sub    $0xc,%esp
80101215:	56                   	push   %esi
80101216:	e8 b5 0d 00 00       	call   80101fd0 <iunlockput>
    end_op();
8010121b:	e8 b0 20 00 00       	call   801032d0 <end_op>
    if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0) {
80101220:	83 c4 0c             	add    $0xc,%esp
80101223:	53                   	push   %ebx
80101224:	57                   	push   %edi
80101225:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010122b:	e8 00 60 00 00       	call   80107230 <allocuvm>
80101230:	83 c4 10             	add    $0x10,%esp
80101233:	85 c0                	test   %eax,%eax
80101235:	89 c7                	mov    %eax,%edi
80101237:	0f 84 8c 00 00 00    	je     801012c9 <exec+0x229>
    clearpteu(pgdir, (char*)(sz - 2 * PGSIZE));
8010123d:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80101243:	83 ec 08             	sub    $0x8,%esp
    for (argc = 0; argv[argc]; argc++) {
80101246:	31 f6                	xor    %esi,%esi
80101248:	89 fb                	mov    %edi,%ebx
    clearpteu(pgdir, (char*)(sz - 2 * PGSIZE));
8010124a:	50                   	push   %eax
8010124b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101251:	e8 5a 62 00 00       	call   801074b0 <clearpteu>
    for (argc = 0; argv[argc]; argc++) {
80101256:	8b 45 0c             	mov    0xc(%ebp),%eax
80101259:	83 c4 10             	add    $0x10,%esp
8010125c:	8b 08                	mov    (%eax),%ecx
8010125e:	85 c9                	test   %ecx,%ecx
80101260:	0f 84 76 01 00 00    	je     801013dc <exec+0x33c>
80101266:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
8010126c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010126f:	eb 25                	jmp    80101296 <exec+0x1f6>
80101271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101278:	8d 46 01             	lea    0x1(%esi),%eax
        ustack[3 + argc] = sp;
8010127b:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101281:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
    for (argc = 0; argv[argc]; argc++) {
80101288:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
8010128b:	85 c9                	test   %ecx,%ecx
8010128d:	74 5a                	je     801012e9 <exec+0x249>
        if (argc >= MAXARG) {
8010128f:	83 f8 20             	cmp    $0x20,%eax
80101292:	74 35                	je     801012c9 <exec+0x229>
80101294:	89 c6                	mov    %eax,%esi
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101296:	83 ec 0c             	sub    $0xc,%esp
80101299:	51                   	push   %ecx
8010129a:	e8 c1 3a 00 00       	call   80104d60 <strlen>
8010129f:	f7 d0                	not    %eax
801012a1:	01 c3                	add    %eax,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0) {
801012a3:	58                   	pop    %eax
801012a4:	ff 34 b7             	pushl  (%edi,%esi,4)
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801012a7:	83 e3 fc             	and    $0xfffffffc,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0) {
801012aa:	e8 b1 3a 00 00       	call   80104d60 <strlen>
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	50                   	push   %eax
801012b3:	ff 34 b7             	pushl  (%edi,%esi,4)
801012b6:	53                   	push   %ebx
801012b7:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801012bd:	e8 6e 63 00 00       	call   80107630 <copyout>
801012c2:	83 c4 20             	add    $0x20,%esp
801012c5:	85 c0                	test   %eax,%eax
801012c7:	79 af                	jns    80101278 <exec+0x1d8>
        cleanupexec(pgdir, ip);
801012c9:	83 ec 08             	sub    $0x8,%esp
801012cc:	6a 00                	push   $0x0
801012ce:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801012d4:	e8 77 fd ff ff       	call   80101050 <cleanupexec>
        return -1;    
801012d9:	83 c4 10             	add    $0x10,%esp
}
801012dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;    
801012df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801012e4:	5b                   	pop    %ebx
801012e5:	5e                   	pop    %esi
801012e6:	5f                   	pop    %edi
801012e7:	5d                   	pop    %ebp
801012e8:	c3                   	ret    
801012e9:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801012ef:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801012f5:	8d 46 04             	lea    0x4(%esi),%eax
801012f8:	8d 34 b5 08 00 00 00 	lea    0x8(,%esi,4),%esi
801012ff:	8d 4e 0c             	lea    0xc(%esi),%ecx
    ustack[3 + argc] = 0;
80101302:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80101309:	00 00 00 00 
    ustack[1] = argc;
8010130d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0) {
80101313:	51                   	push   %ecx
80101314:	52                   	push   %edx
    ustack[0] = 0xffffffff;  // fake return PC
80101315:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010131c:	ff ff ff 
    ustack[1] = argc;
8010131f:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80101325:	89 d8                	mov    %ebx,%eax
    sp -= (3 + argc + 1) * 4;
80101327:	29 cb                	sub    %ecx,%ebx
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0) {
80101329:	53                   	push   %ebx
8010132a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80101330:	29 f0                	sub    %esi,%eax
80101332:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0) {
80101338:	e8 f3 62 00 00       	call   80107630 <copyout>
8010133d:	83 c4 10             	add    $0x10,%esp
80101340:	85 c0                	test   %eax,%eax
80101342:	78 85                	js     801012c9 <exec+0x229>
    for (last = s = path; *s; s++) {
80101344:	8b 45 08             	mov    0x8(%ebp),%eax
80101347:	8b 55 08             	mov    0x8(%ebp),%edx
8010134a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010134d:	0f b6 00             	movzbl (%eax),%eax
80101350:	84 c0                	test   %al,%al
80101352:	74 13                	je     80101367 <exec+0x2c7>
80101354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101358:	83 c1 01             	add    $0x1,%ecx
8010135b:	3c 2f                	cmp    $0x2f,%al
8010135d:	0f b6 01             	movzbl (%ecx),%eax
80101360:	0f 44 d1             	cmove  %ecx,%edx
80101363:	84 c0                	test   %al,%al
80101365:	75 f1                	jne    80101358 <exec+0x2b8>
    safestrcpy(curproc->name, last, sizeof(curproc->name));
80101367:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
8010136d:	83 ec 04             	sub    $0x4,%esp
80101370:	6a 10                	push   $0x10
80101372:	52                   	push   %edx
80101373:	8d 46 6c             	lea    0x6c(%esi),%eax
80101376:	50                   	push   %eax
80101377:	e8 a4 39 00 00       	call   80104d20 <safestrcpy>
    curproc->pgdir = pgdir;
8010137c:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    oldpgdir = curproc->pgdir;
80101382:	89 f0                	mov    %esi,%eax
80101384:	8b 76 04             	mov    0x4(%esi),%esi
    curproc->sz = sz;
80101387:	89 38                	mov    %edi,(%eax)
    curproc->pgdir = pgdir;
80101389:	89 48 04             	mov    %ecx,0x4(%eax)
    curproc->tf->eip = elf.entry;  // main
8010138c:	89 c1                	mov    %eax,%ecx
8010138e:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80101394:	8b 40 18             	mov    0x18(%eax),%eax
80101397:	89 50 38             	mov    %edx,0x38(%eax)
    curproc->tf->esp = sp;
8010139a:	8b 41 18             	mov    0x18(%ecx),%eax
8010139d:	89 58 44             	mov    %ebx,0x44(%eax)
    switchuvm(curproc);
801013a0:	89 0c 24             	mov    %ecx,(%esp)
801013a3:	e8 38 5c 00 00       	call   80106fe0 <switchuvm>
    freevm(oldpgdir);
801013a8:	89 34 24             	mov    %esi,(%esp)
801013ab:	e8 e0 5f 00 00       	call   80107390 <freevm>
    return 0;
801013b0:	83 c4 10             	add    $0x10,%esp
801013b3:	31 c0                	xor    %eax,%eax
801013b5:	e9 3e fe ff ff       	jmp    801011f8 <exec+0x158>
        cleanupexec(pgdir, ip);
801013ba:	83 ec 08             	sub    $0x8,%esp
801013bd:	56                   	push   %esi
801013be:	6a 00                	push   $0x0
801013c0:	e8 8b fc ff ff       	call   80101050 <cleanupexec>
        return -1;    
801013c5:	83 c4 10             	add    $0x10,%esp
801013c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013cd:	e9 26 fe ff ff       	jmp    801011f8 <exec+0x158>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
801013d2:	bb 00 20 00 00       	mov    $0x2000,%ebx
801013d7:	e9 36 fe ff ff       	jmp    80101212 <exec+0x172>
    for (argc = 0; argv[argc]; argc++) {
801013dc:	b9 10 00 00 00       	mov    $0x10,%ecx
801013e1:	be 04 00 00 00       	mov    $0x4,%esi
801013e6:	b8 03 00 00 00       	mov    $0x3,%eax
801013eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
801013f2:	00 00 00 
801013f5:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
801013fb:	e9 02 ff ff ff       	jmp    80101302 <exec+0x262>
        end_op();
80101400:	e8 cb 1e 00 00       	call   801032d0 <end_op>
        cprintf("exec: fail\n");
80101405:	83 ec 0c             	sub    $0xc,%esp
80101408:	68 61 77 10 80       	push   $0x80107761
8010140d:	e8 ee f3 ff ff       	call   80100800 <cprintf>
        return -1;
80101412:	83 c4 10             	add    $0x10,%esp
80101415:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010141a:	e9 d9 fd ff ff       	jmp    801011f8 <exec+0x158>
8010141f:	90                   	nop

80101420 <fileinit>:
struct {
    struct spinlock lock;
    struct file file[NFILE];
} ftable;

void fileinit(void) {
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	83 ec 10             	sub    $0x10,%esp
    initlock(&ftable.lock, "ftable");
80101426:	68 6d 77 10 80       	push   $0x8010776d
8010142b:	68 a0 27 11 80       	push   $0x801127a0
80101430:	e8 bb 34 00 00       	call   801048f0 <initlock>
}
80101435:	83 c4 10             	add    $0x10,%esp
80101438:	c9                   	leave  
80101439:	c3                   	ret    
8010143a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101440 <filealloc>:

// Allocate a file structure.
struct file* filealloc(void) {
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	53                   	push   %ebx
    struct file *f;

    acquire(&ftable.lock);
    for (f = ftable.file; f < ftable.file + NFILE; f++) {
80101444:	bb d4 27 11 80       	mov    $0x801127d4,%ebx
struct file* filealloc(void) {
80101449:	83 ec 10             	sub    $0x10,%esp
    acquire(&ftable.lock);
8010144c:	68 a0 27 11 80       	push   $0x801127a0
80101451:	e8 da 35 00 00       	call   80104a30 <acquire>
80101456:	83 c4 10             	add    $0x10,%esp
80101459:	eb 10                	jmp    8010146b <filealloc+0x2b>
8010145b:	90                   	nop
8010145c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (f = ftable.file; f < ftable.file + NFILE; f++) {
80101460:	83 c3 18             	add    $0x18,%ebx
80101463:	81 fb 34 31 11 80    	cmp    $0x80113134,%ebx
80101469:	73 25                	jae    80101490 <filealloc+0x50>
        if (f->ref == 0) {
8010146b:	8b 43 04             	mov    0x4(%ebx),%eax
8010146e:	85 c0                	test   %eax,%eax
80101470:	75 ee                	jne    80101460 <filealloc+0x20>
            f->ref = 1;
            release(&ftable.lock);
80101472:	83 ec 0c             	sub    $0xc,%esp
            f->ref = 1;
80101475:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
            release(&ftable.lock);
8010147c:	68 a0 27 11 80       	push   $0x801127a0
80101481:	e8 6a 36 00 00       	call   80104af0 <release>
            return f;
        }
    }
    release(&ftable.lock);
    return 0;
}
80101486:	89 d8                	mov    %ebx,%eax
            return f;
80101488:	83 c4 10             	add    $0x10,%esp
}
8010148b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010148e:	c9                   	leave  
8010148f:	c3                   	ret    
    release(&ftable.lock);
80101490:	83 ec 0c             	sub    $0xc,%esp
    return 0;
80101493:	31 db                	xor    %ebx,%ebx
    release(&ftable.lock);
80101495:	68 a0 27 11 80       	push   $0x801127a0
8010149a:	e8 51 36 00 00       	call   80104af0 <release>
}
8010149f:	89 d8                	mov    %ebx,%eax
    return 0;
801014a1:	83 c4 10             	add    $0x10,%esp
}
801014a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014a7:	c9                   	leave  
801014a8:	c3                   	ret    
801014a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014b0 <filedup>:

// Increment ref count for file f.
struct file* filedup(struct file *f) {
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	53                   	push   %ebx
801014b4:	83 ec 10             	sub    $0x10,%esp
801014b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ftable.lock);
801014ba:	68 a0 27 11 80       	push   $0x801127a0
801014bf:	e8 6c 35 00 00       	call   80104a30 <acquire>
    if (f->ref < 1) {
801014c4:	8b 43 04             	mov    0x4(%ebx),%eax
801014c7:	83 c4 10             	add    $0x10,%esp
801014ca:	85 c0                	test   %eax,%eax
801014cc:	7e 1a                	jle    801014e8 <filedup+0x38>
        panic("filedup");
    }
    f->ref++;
801014ce:	83 c0 01             	add    $0x1,%eax
    release(&ftable.lock);
801014d1:	83 ec 0c             	sub    $0xc,%esp
    f->ref++;
801014d4:	89 43 04             	mov    %eax,0x4(%ebx)
    release(&ftable.lock);
801014d7:	68 a0 27 11 80       	push   $0x801127a0
801014dc:	e8 0f 36 00 00       	call   80104af0 <release>
    return f;
}
801014e1:	89 d8                	mov    %ebx,%eax
801014e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014e6:	c9                   	leave  
801014e7:	c3                   	ret    
        panic("filedup");
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	68 74 77 10 80       	push   $0x80107774
801014f0:	e8 8b ef ff ff       	call   80100480 <panic>
801014f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101500 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f) {
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	57                   	push   %edi
80101504:	56                   	push   %esi
80101505:	53                   	push   %ebx
80101506:	83 ec 28             	sub    $0x28,%esp
80101509:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct file ff;

    acquire(&ftable.lock);
8010150c:	68 a0 27 11 80       	push   $0x801127a0
80101511:	e8 1a 35 00 00       	call   80104a30 <acquire>
    if (f->ref < 1) {
80101516:	8b 43 04             	mov    0x4(%ebx),%eax
80101519:	83 c4 10             	add    $0x10,%esp
8010151c:	85 c0                	test   %eax,%eax
8010151e:	0f 8e 9b 00 00 00    	jle    801015bf <fileclose+0xbf>
        panic("fileclose");
    }
    if (--f->ref > 0) {
80101524:	83 e8 01             	sub    $0x1,%eax
80101527:	85 c0                	test   %eax,%eax
80101529:	89 43 04             	mov    %eax,0x4(%ebx)
8010152c:	74 1a                	je     80101548 <fileclose+0x48>
        release(&ftable.lock);
8010152e:	c7 45 08 a0 27 11 80 	movl   $0x801127a0,0x8(%ebp)
    else if (ff.type == FD_INODE) {
        begin_op();
        iput(ff.ip);
        end_op();
    }
}
80101535:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101538:	5b                   	pop    %ebx
80101539:	5e                   	pop    %esi
8010153a:	5f                   	pop    %edi
8010153b:	5d                   	pop    %ebp
        release(&ftable.lock);
8010153c:	e9 af 35 00 00       	jmp    80104af0 <release>
80101541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ff = *f;
80101548:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
8010154c:	8b 3b                	mov    (%ebx),%edi
    release(&ftable.lock);
8010154e:	83 ec 0c             	sub    $0xc,%esp
    ff = *f;
80101551:	8b 73 0c             	mov    0xc(%ebx),%esi
    f->type = FD_NONE;
80101554:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    ff = *f;
8010155a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010155d:	8b 43 10             	mov    0x10(%ebx),%eax
    release(&ftable.lock);
80101560:	68 a0 27 11 80       	push   $0x801127a0
    ff = *f;
80101565:	89 45 e0             	mov    %eax,-0x20(%ebp)
    release(&ftable.lock);
80101568:	e8 83 35 00 00       	call   80104af0 <release>
    if (ff.type == FD_PIPE) {
8010156d:	83 c4 10             	add    $0x10,%esp
80101570:	83 ff 01             	cmp    $0x1,%edi
80101573:	74 13                	je     80101588 <fileclose+0x88>
    else if (ff.type == FD_INODE) {
80101575:	83 ff 02             	cmp    $0x2,%edi
80101578:	74 26                	je     801015a0 <fileclose+0xa0>
}
8010157a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010157d:	5b                   	pop    %ebx
8010157e:	5e                   	pop    %esi
8010157f:	5f                   	pop    %edi
80101580:	5d                   	pop    %ebp
80101581:	c3                   	ret    
80101582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        pipeclose(ff.pipe, ff.writable);
80101588:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010158c:	83 ec 08             	sub    $0x8,%esp
8010158f:	53                   	push   %ebx
80101590:	56                   	push   %esi
80101591:	e8 9a 24 00 00       	call   80103a30 <pipeclose>
80101596:	83 c4 10             	add    $0x10,%esp
80101599:	eb df                	jmp    8010157a <fileclose+0x7a>
8010159b:	90                   	nop
8010159c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        begin_op();
801015a0:	e8 bb 1c 00 00       	call   80103260 <begin_op>
        iput(ff.ip);
801015a5:	83 ec 0c             	sub    $0xc,%esp
801015a8:	ff 75 e0             	pushl  -0x20(%ebp)
801015ab:	e8 c0 08 00 00       	call   80101e70 <iput>
        end_op();
801015b0:	83 c4 10             	add    $0x10,%esp
}
801015b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015b6:	5b                   	pop    %ebx
801015b7:	5e                   	pop    %esi
801015b8:	5f                   	pop    %edi
801015b9:	5d                   	pop    %ebp
        end_op();
801015ba:	e9 11 1d 00 00       	jmp    801032d0 <end_op>
        panic("fileclose");
801015bf:	83 ec 0c             	sub    $0xc,%esp
801015c2:	68 7c 77 10 80       	push   $0x8010777c
801015c7:	e8 b4 ee ff ff       	call   80100480 <panic>
801015cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015d0 <filestat>:

// Get metadata about file f.
int filestat(struct file *f, struct stat *st) {
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	53                   	push   %ebx
801015d4:	83 ec 04             	sub    $0x4,%esp
801015d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (f->type == FD_INODE) {
801015da:	83 3b 02             	cmpl   $0x2,(%ebx)
801015dd:	75 31                	jne    80101610 <filestat+0x40>
        ilock(f->ip);
801015df:	83 ec 0c             	sub    $0xc,%esp
801015e2:	ff 73 10             	pushl  0x10(%ebx)
801015e5:	e8 56 07 00 00       	call   80101d40 <ilock>
        stati(f->ip, st);
801015ea:	58                   	pop    %eax
801015eb:	5a                   	pop    %edx
801015ec:	ff 75 0c             	pushl  0xc(%ebp)
801015ef:	ff 73 10             	pushl  0x10(%ebx)
801015f2:	e8 f9 09 00 00       	call   80101ff0 <stati>
        iunlock(f->ip);
801015f7:	59                   	pop    %ecx
801015f8:	ff 73 10             	pushl  0x10(%ebx)
801015fb:	e8 20 08 00 00       	call   80101e20 <iunlock>
        return 0;
80101600:	83 c4 10             	add    $0x10,%esp
80101603:	31 c0                	xor    %eax,%eax
    }
    return -1;
}
80101605:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101608:	c9                   	leave  
80101609:	c3                   	ret    
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101615:	eb ee                	jmp    80101605 <filestat+0x35>
80101617:	89 f6                	mov    %esi,%esi
80101619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101620 <fileread>:

// Read from file f.
int fileread(struct file *f, char *addr, int n) {
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	57                   	push   %edi
80101624:	56                   	push   %esi
80101625:	53                   	push   %ebx
80101626:	83 ec 0c             	sub    $0xc,%esp
80101629:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010162c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010162f:	8b 7d 10             	mov    0x10(%ebp),%edi
    int r;

    if (f->readable == 0) {
80101632:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101636:	74 60                	je     80101698 <fileread+0x78>
        return -1;
    }
    if (f->type == FD_PIPE) {
80101638:	8b 03                	mov    (%ebx),%eax
8010163a:	83 f8 01             	cmp    $0x1,%eax
8010163d:	74 41                	je     80101680 <fileread+0x60>
        return piperead(f->pipe, addr, n);
    }
    if (f->type == FD_INODE) {
8010163f:	83 f8 02             	cmp    $0x2,%eax
80101642:	75 5b                	jne    8010169f <fileread+0x7f>
        ilock(f->ip);
80101644:	83 ec 0c             	sub    $0xc,%esp
80101647:	ff 73 10             	pushl  0x10(%ebx)
8010164a:	e8 f1 06 00 00       	call   80101d40 <ilock>
        if ((r = readi(f->ip, addr, f->off, n)) > 0) {
8010164f:	57                   	push   %edi
80101650:	ff 73 14             	pushl  0x14(%ebx)
80101653:	56                   	push   %esi
80101654:	ff 73 10             	pushl  0x10(%ebx)
80101657:	e8 c4 09 00 00       	call   80102020 <readi>
8010165c:	83 c4 20             	add    $0x20,%esp
8010165f:	85 c0                	test   %eax,%eax
80101661:	89 c6                	mov    %eax,%esi
80101663:	7e 03                	jle    80101668 <fileread+0x48>
            f->off += r;
80101665:	01 43 14             	add    %eax,0x14(%ebx)
        }
        iunlock(f->ip);
80101668:	83 ec 0c             	sub    $0xc,%esp
8010166b:	ff 73 10             	pushl  0x10(%ebx)
8010166e:	e8 ad 07 00 00       	call   80101e20 <iunlock>
        return r;
80101673:	83 c4 10             	add    $0x10,%esp
    }
    panic("fileread");
}
80101676:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101679:	89 f0                	mov    %esi,%eax
8010167b:	5b                   	pop    %ebx
8010167c:	5e                   	pop    %esi
8010167d:	5f                   	pop    %edi
8010167e:	5d                   	pop    %ebp
8010167f:	c3                   	ret    
        return piperead(f->pipe, addr, n);
80101680:	8b 43 0c             	mov    0xc(%ebx),%eax
80101683:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101686:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101689:	5b                   	pop    %ebx
8010168a:	5e                   	pop    %esi
8010168b:	5f                   	pop    %edi
8010168c:	5d                   	pop    %ebp
        return piperead(f->pipe, addr, n);
8010168d:	e9 4e 25 00 00       	jmp    80103be0 <piperead>
80101692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
80101698:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010169d:	eb d7                	jmp    80101676 <fileread+0x56>
    panic("fileread");
8010169f:	83 ec 0c             	sub    $0xc,%esp
801016a2:	68 86 77 10 80       	push   $0x80107786
801016a7:	e8 d4 ed ff ff       	call   80100480 <panic>
801016ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016b0 <filewrite>:


// Write to file f.
int filewrite(struct file *f, char *addr, int n) {
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	57                   	push   %edi
801016b4:	56                   	push   %esi
801016b5:	53                   	push   %ebx
801016b6:	83 ec 1c             	sub    $0x1c,%esp
801016b9:	8b 75 08             	mov    0x8(%ebp),%esi
801016bc:	8b 45 0c             	mov    0xc(%ebp),%eax
    int r;

    if (f->writable == 0) {
801016bf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
int filewrite(struct file *f, char *addr, int n) {
801016c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801016c6:	8b 45 10             	mov    0x10(%ebp),%eax
801016c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (f->writable == 0) {
801016cc:	0f 84 aa 00 00 00    	je     8010177c <filewrite+0xcc>
        return -1;
    }
    if (f->type == FD_PIPE) {
801016d2:	8b 06                	mov    (%esi),%eax
801016d4:	83 f8 01             	cmp    $0x1,%eax
801016d7:	0f 84 c3 00 00 00    	je     801017a0 <filewrite+0xf0>
        return pipewrite(f->pipe, addr, n);
    }
    if (f->type == FD_INODE) {
801016dd:	83 f8 02             	cmp    $0x2,%eax
801016e0:	0f 85 d9 00 00 00    	jne    801017bf <filewrite+0x10f>
        // and 2 blocks of slop for non-aligned writes.
        // this really belongs lower down, since writei()
        // might be writing a device like the console.
        int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * 512;
        int i = 0;
        while (i < n) {
801016e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        int i = 0;
801016e9:	31 ff                	xor    %edi,%edi
        while (i < n) {
801016eb:	85 c0                	test   %eax,%eax
801016ed:	7f 34                	jg     80101723 <filewrite+0x73>
801016ef:	e9 9c 00 00 00       	jmp    80101790 <filewrite+0xe0>
801016f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            }

            begin_op();
            ilock(f->ip);
            if ((r = writei(f->ip, addr + i, f->off, n1)) > 0) {
                f->off += r;
801016f8:	01 46 14             	add    %eax,0x14(%esi)
            }
            iunlock(f->ip);
801016fb:	83 ec 0c             	sub    $0xc,%esp
801016fe:	ff 76 10             	pushl  0x10(%esi)
                f->off += r;
80101701:	89 45 e0             	mov    %eax,-0x20(%ebp)
            iunlock(f->ip);
80101704:	e8 17 07 00 00       	call   80101e20 <iunlock>
            end_op();
80101709:	e8 c2 1b 00 00       	call   801032d0 <end_op>
8010170e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101711:	83 c4 10             	add    $0x10,%esp

            if (r < 0) {
                break;
            }
            if (r != n1) {
80101714:	39 c3                	cmp    %eax,%ebx
80101716:	0f 85 96 00 00 00    	jne    801017b2 <filewrite+0x102>
                panic("short filewrite");
            }
            i += r;
8010171c:	01 df                	add    %ebx,%edi
        while (i < n) {
8010171e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101721:	7e 6d                	jle    80101790 <filewrite+0xe0>
            int n1 = n - i;
80101723:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101726:	b8 00 06 00 00       	mov    $0x600,%eax
8010172b:	29 fb                	sub    %edi,%ebx
8010172d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101733:	0f 4f d8             	cmovg  %eax,%ebx
            begin_op();
80101736:	e8 25 1b 00 00       	call   80103260 <begin_op>
            ilock(f->ip);
8010173b:	83 ec 0c             	sub    $0xc,%esp
8010173e:	ff 76 10             	pushl  0x10(%esi)
80101741:	e8 fa 05 00 00       	call   80101d40 <ilock>
            if ((r = writei(f->ip, addr + i, f->off, n1)) > 0) {
80101746:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101749:	53                   	push   %ebx
8010174a:	ff 76 14             	pushl  0x14(%esi)
8010174d:	01 f8                	add    %edi,%eax
8010174f:	50                   	push   %eax
80101750:	ff 76 10             	pushl  0x10(%esi)
80101753:	e8 c8 09 00 00       	call   80102120 <writei>
80101758:	83 c4 20             	add    $0x20,%esp
8010175b:	85 c0                	test   %eax,%eax
8010175d:	7f 99                	jg     801016f8 <filewrite+0x48>
            iunlock(f->ip);
8010175f:	83 ec 0c             	sub    $0xc,%esp
80101762:	ff 76 10             	pushl  0x10(%esi)
80101765:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101768:	e8 b3 06 00 00       	call   80101e20 <iunlock>
            end_op();
8010176d:	e8 5e 1b 00 00       	call   801032d0 <end_op>
            if (r < 0) {
80101772:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101775:	83 c4 10             	add    $0x10,%esp
80101778:	85 c0                	test   %eax,%eax
8010177a:	74 98                	je     80101714 <filewrite+0x64>
        }
        return i == n ? n : -1;
    }
    panic("filewrite");
}
8010177c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010177f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101784:	89 f8                	mov    %edi,%eax
80101786:	5b                   	pop    %ebx
80101787:	5e                   	pop    %esi
80101788:	5f                   	pop    %edi
80101789:	5d                   	pop    %ebp
8010178a:	c3                   	ret    
8010178b:	90                   	nop
8010178c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return i == n ? n : -1;
80101790:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101793:	75 e7                	jne    8010177c <filewrite+0xcc>
}
80101795:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101798:	89 f8                	mov    %edi,%eax
8010179a:	5b                   	pop    %ebx
8010179b:	5e                   	pop    %esi
8010179c:	5f                   	pop    %edi
8010179d:	5d                   	pop    %ebp
8010179e:	c3                   	ret    
8010179f:	90                   	nop
        return pipewrite(f->pipe, addr, n);
801017a0:	8b 46 0c             	mov    0xc(%esi),%eax
801017a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801017a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017a9:	5b                   	pop    %ebx
801017aa:	5e                   	pop    %esi
801017ab:	5f                   	pop    %edi
801017ac:	5d                   	pop    %ebp
        return pipewrite(f->pipe, addr, n);
801017ad:	e9 1e 23 00 00       	jmp    80103ad0 <pipewrite>
                panic("short filewrite");
801017b2:	83 ec 0c             	sub    $0xc,%esp
801017b5:	68 8f 77 10 80       	push   $0x8010778f
801017ba:	e8 c1 ec ff ff       	call   80100480 <panic>
    panic("filewrite");
801017bf:	83 ec 0c             	sub    $0xc,%esp
801017c2:	68 95 77 10 80       	push   $0x80107795
801017c7:	e8 b4 ec ff ff       	call   80100480 <panic>
801017cc:	66 90                	xchg   %ax,%ax
801017ce:	66 90                	xchg   %ax,%ax

801017d0 <bfree>:
    }
    panic("balloc: out of blocks");
}

// Free a disk block.
static void bfree(int dev, uint b) {
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	56                   	push   %esi
801017d4:	53                   	push   %ebx
801017d5:	89 d3                	mov    %edx,%ebx
    struct buf *bp;
    int bi, m;

    bp = bread(dev, BBLOCK(b, sb));
801017d7:	c1 ea 0c             	shr    $0xc,%edx
801017da:	03 15 b8 31 11 80    	add    0x801131b8,%edx
801017e0:	83 ec 08             	sub    $0x8,%esp
801017e3:	52                   	push   %edx
801017e4:	50                   	push   %eax
801017e5:	e8 e6 e8 ff ff       	call   801000d0 <bread>
    bi = b % BPB;
    m = 1 << (bi % 8);
801017ea:	89 d9                	mov    %ebx,%ecx
    if ((bp->data[bi / 8] & m) == 0) {
801017ec:	c1 fb 03             	sar    $0x3,%ebx
    m = 1 << (bi % 8);
801017ef:	ba 01 00 00 00       	mov    $0x1,%edx
801017f4:	83 e1 07             	and    $0x7,%ecx
    if ((bp->data[bi / 8] & m) == 0) {
801017f7:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801017fd:	83 c4 10             	add    $0x10,%esp
    m = 1 << (bi % 8);
80101800:	d3 e2                	shl    %cl,%edx
    if ((bp->data[bi / 8] & m) == 0) {
80101802:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101807:	85 d1                	test   %edx,%ecx
80101809:	74 25                	je     80101830 <bfree+0x60>
        panic("freeing free block");
    }
    bp->data[bi / 8] &= ~m;
8010180b:	f7 d2                	not    %edx
8010180d:	89 c6                	mov    %eax,%esi
    log_write(bp);
8010180f:	83 ec 0c             	sub    $0xc,%esp
    bp->data[bi / 8] &= ~m;
80101812:	21 ca                	and    %ecx,%edx
80101814:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
    log_write(bp);
80101818:	56                   	push   %esi
80101819:	e8 12 1c 00 00       	call   80103430 <log_write>
    brelse(bp);
8010181e:	89 34 24             	mov    %esi,(%esp)
80101821:	e8 ba e9 ff ff       	call   801001e0 <brelse>
}
80101826:	83 c4 10             	add    $0x10,%esp
80101829:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010182c:	5b                   	pop    %ebx
8010182d:	5e                   	pop    %esi
8010182e:	5d                   	pop    %ebp
8010182f:	c3                   	ret    
        panic("freeing free block");
80101830:	83 ec 0c             	sub    $0xc,%esp
80101833:	68 9f 77 10 80       	push   $0x8010779f
80101838:	e8 43 ec ff ff       	call   80100480 <panic>
8010183d:	8d 76 00             	lea    0x0(%esi),%esi

80101840 <balloc>:
static uint balloc(uint dev) {
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	57                   	push   %edi
80101844:	56                   	push   %esi
80101845:	53                   	push   %ebx
80101846:	83 ec 1c             	sub    $0x1c,%esp
    for (b = 0; b < sb.size; b += BPB) {
80101849:	8b 0d a0 31 11 80    	mov    0x801131a0,%ecx
static uint balloc(uint dev) {
8010184f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    for (b = 0; b < sb.size; b += BPB) {
80101852:	85 c9                	test   %ecx,%ecx
80101854:	0f 84 87 00 00 00    	je     801018e1 <balloc+0xa1>
8010185a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
        bp = bread(dev, BBLOCK(b, sb));
80101861:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101864:	83 ec 08             	sub    $0x8,%esp
80101867:	89 f0                	mov    %esi,%eax
80101869:	c1 f8 0c             	sar    $0xc,%eax
8010186c:	03 05 b8 31 11 80    	add    0x801131b8,%eax
80101872:	50                   	push   %eax
80101873:	ff 75 d8             	pushl  -0x28(%ebp)
80101876:	e8 55 e8 ff ff       	call   801000d0 <bread>
8010187b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
8010187e:	a1 a0 31 11 80       	mov    0x801131a0,%eax
80101883:	83 c4 10             	add    $0x10,%esp
80101886:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101889:	31 c0                	xor    %eax,%eax
8010188b:	eb 2f                	jmp    801018bc <balloc+0x7c>
8010188d:	8d 76 00             	lea    0x0(%esi),%esi
            m = 1 << (bi % 8);
80101890:	89 c1                	mov    %eax,%ecx
            if ((bp->data[bi / 8] & m) == 0) { // Is block free?
80101892:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            m = 1 << (bi % 8);
80101895:	bb 01 00 00 00       	mov    $0x1,%ebx
8010189a:	83 e1 07             	and    $0x7,%ecx
8010189d:	d3 e3                	shl    %cl,%ebx
            if ((bp->data[bi / 8] & m) == 0) { // Is block free?
8010189f:	89 c1                	mov    %eax,%ecx
801018a1:	c1 f9 03             	sar    $0x3,%ecx
801018a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801018a9:	85 df                	test   %ebx,%edi
801018ab:	89 fa                	mov    %edi,%edx
801018ad:	74 41                	je     801018f0 <balloc+0xb0>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
801018af:	83 c0 01             	add    $0x1,%eax
801018b2:	83 c6 01             	add    $0x1,%esi
801018b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801018ba:	74 05                	je     801018c1 <balloc+0x81>
801018bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801018bf:	77 cf                	ja     80101890 <balloc+0x50>
        brelse(bp);
801018c1:	83 ec 0c             	sub    $0xc,%esp
801018c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801018c7:	e8 14 e9 ff ff       	call   801001e0 <brelse>
    for (b = 0; b < sb.size; b += BPB) {
801018cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801018d9:	39 05 a0 31 11 80    	cmp    %eax,0x801131a0
801018df:	77 80                	ja     80101861 <balloc+0x21>
    panic("balloc: out of blocks");
801018e1:	83 ec 0c             	sub    $0xc,%esp
801018e4:	68 b2 77 10 80       	push   $0x801077b2
801018e9:	e8 92 eb ff ff       	call   80100480 <panic>
801018ee:	66 90                	xchg   %ax,%ax
                bp->data[bi / 8] |= m;  // Mark block in use.
801018f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
                log_write(bp);
801018f3:	83 ec 0c             	sub    $0xc,%esp
                bp->data[bi / 8] |= m;  // Mark block in use.
801018f6:	09 da                	or     %ebx,%edx
801018f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
                log_write(bp);
801018fc:	57                   	push   %edi
801018fd:	e8 2e 1b 00 00       	call   80103430 <log_write>
                brelse(bp);
80101902:	89 3c 24             	mov    %edi,(%esp)
80101905:	e8 d6 e8 ff ff       	call   801001e0 <brelse>
    bp = bread(dev, bno);
8010190a:	58                   	pop    %eax
8010190b:	5a                   	pop    %edx
8010190c:	56                   	push   %esi
8010190d:	ff 75 d8             	pushl  -0x28(%ebp)
80101910:	e8 bb e7 ff ff       	call   801000d0 <bread>
80101915:	89 c3                	mov    %eax,%ebx
    memset(bp->data, 0, BSIZE);
80101917:	8d 40 5c             	lea    0x5c(%eax),%eax
8010191a:	83 c4 0c             	add    $0xc,%esp
8010191d:	68 00 02 00 00       	push   $0x200
80101922:	6a 00                	push   $0x0
80101924:	50                   	push   %eax
80101925:	e8 16 32 00 00       	call   80104b40 <memset>
    log_write(bp);
8010192a:	89 1c 24             	mov    %ebx,(%esp)
8010192d:	e8 fe 1a 00 00       	call   80103430 <log_write>
    brelse(bp);
80101932:	89 1c 24             	mov    %ebx,(%esp)
80101935:	e8 a6 e8 ff ff       	call   801001e0 <brelse>
}
8010193a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010193d:	89 f0                	mov    %esi,%eax
8010193f:	5b                   	pop    %ebx
80101940:	5e                   	pop    %esi
80101941:	5f                   	pop    %edi
80101942:	5d                   	pop    %ebp
80101943:	c3                   	ret    
80101944:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010194a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101950 <iget>:
}

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode* iget(uint dev, uint inum) {
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	53                   	push   %ebx
80101956:	89 c7                	mov    %eax,%edi
    struct inode *ip, *empty;

    acquire(&icache.lock);

    // Is the inode already cached?
    empty = 0;
80101958:	31 f6                	xor    %esi,%esi
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
8010195a:	bb f4 31 11 80       	mov    $0x801131f4,%ebx
static struct inode* iget(uint dev, uint inum) {
8010195f:	83 ec 28             	sub    $0x28,%esp
80101962:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    acquire(&icache.lock);
80101965:	68 c0 31 11 80       	push   $0x801131c0
8010196a:	e8 c1 30 00 00       	call   80104a30 <acquire>
8010196f:	83 c4 10             	add    $0x10,%esp
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101972:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101975:	eb 17                	jmp    8010198e <iget+0x3e>
80101977:	89 f6                	mov    %esi,%esi
80101979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101980:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101986:	81 fb 14 4e 11 80    	cmp    $0x80114e14,%ebx
8010198c:	73 22                	jae    801019b0 <iget+0x60>
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
8010198e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101991:	85 c9                	test   %ecx,%ecx
80101993:	7e 04                	jle    80101999 <iget+0x49>
80101995:	39 3b                	cmp    %edi,(%ebx)
80101997:	74 4f                	je     801019e8 <iget+0x98>
            ip->ref++;
            release(&icache.lock);
            return ip;
        }
        if (empty == 0 && ip->ref == 0) {  // Remember empty slot.
80101999:	85 f6                	test   %esi,%esi
8010199b:	75 e3                	jne    80101980 <iget+0x30>
8010199d:	85 c9                	test   %ecx,%ecx
8010199f:	0f 44 f3             	cmove  %ebx,%esi
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
801019a2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801019a8:	81 fb 14 4e 11 80    	cmp    $0x80114e14,%ebx
801019ae:	72 de                	jb     8010198e <iget+0x3e>
            empty = ip;
        }
    }

    // Recycle an inode cache entry.
    if (empty == 0) {
801019b0:	85 f6                	test   %esi,%esi
801019b2:	74 5b                	je     80101a0f <iget+0xbf>
    ip = empty;
    ip->dev = dev;
    ip->inum = inum;
    ip->ref = 1;
    ip->valid = 0;
    release(&icache.lock);
801019b4:	83 ec 0c             	sub    $0xc,%esp
    ip->dev = dev;
801019b7:	89 3e                	mov    %edi,(%esi)
    ip->inum = inum;
801019b9:	89 56 04             	mov    %edx,0x4(%esi)
    ip->ref = 1;
801019bc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
    ip->valid = 0;
801019c3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
    release(&icache.lock);
801019ca:	68 c0 31 11 80       	push   $0x801131c0
801019cf:	e8 1c 31 00 00       	call   80104af0 <release>

    return ip;
801019d4:	83 c4 10             	add    $0x10,%esp
}
801019d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019da:	89 f0                	mov    %esi,%eax
801019dc:	5b                   	pop    %ebx
801019dd:	5e                   	pop    %esi
801019de:	5f                   	pop    %edi
801019df:	5d                   	pop    %ebp
801019e0:	c3                   	ret    
801019e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
801019e8:	39 53 04             	cmp    %edx,0x4(%ebx)
801019eb:	75 ac                	jne    80101999 <iget+0x49>
            release(&icache.lock);
801019ed:	83 ec 0c             	sub    $0xc,%esp
            ip->ref++;
801019f0:	83 c1 01             	add    $0x1,%ecx
            return ip;
801019f3:	89 de                	mov    %ebx,%esi
            release(&icache.lock);
801019f5:	68 c0 31 11 80       	push   $0x801131c0
            ip->ref++;
801019fa:	89 4b 08             	mov    %ecx,0x8(%ebx)
            release(&icache.lock);
801019fd:	e8 ee 30 00 00       	call   80104af0 <release>
            return ip;
80101a02:	83 c4 10             	add    $0x10,%esp
}
80101a05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a08:	89 f0                	mov    %esi,%eax
80101a0a:	5b                   	pop    %ebx
80101a0b:	5e                   	pop    %esi
80101a0c:	5f                   	pop    %edi
80101a0d:	5d                   	pop    %ebp
80101a0e:	c3                   	ret    
        panic("iget: no inodes");
80101a0f:	83 ec 0c             	sub    $0xc,%esp
80101a12:	68 c8 77 10 80       	push   $0x801077c8
80101a17:	e8 64 ea ff ff       	call   80100480 <panic>
80101a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a20 <bmap>:
// are listed in ip->addrs[].  The next NINDIRECT blocks are
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint bmap(struct inode *ip, uint bn) {
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	57                   	push   %edi
80101a24:	56                   	push   %esi
80101a25:	53                   	push   %ebx
80101a26:	89 c6                	mov    %eax,%esi
80101a28:	83 ec 1c             	sub    $0x1c,%esp
    uint addr, *a;
    struct buf *bp;

    if (bn < NDIRECT) {
80101a2b:	83 fa 0b             	cmp    $0xb,%edx
80101a2e:	77 18                	ja     80101a48 <bmap+0x28>
80101a30:	8d 3c 90             	lea    (%eax,%edx,4),%edi
        if ((addr = ip->addrs[bn]) == 0) {
80101a33:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101a36:	85 db                	test   %ebx,%ebx
80101a38:	74 76                	je     80101ab0 <bmap+0x90>
        brelse(bp);
        return addr;
    }

    panic("bmap: out of range");
}
80101a3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a3d:	89 d8                	mov    %ebx,%eax
80101a3f:	5b                   	pop    %ebx
80101a40:	5e                   	pop    %esi
80101a41:	5f                   	pop    %edi
80101a42:	5d                   	pop    %ebp
80101a43:	c3                   	ret    
80101a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bn -= NDIRECT;
80101a48:	8d 5a f4             	lea    -0xc(%edx),%ebx
    if (bn < NINDIRECT) {
80101a4b:	83 fb 7f             	cmp    $0x7f,%ebx
80101a4e:	0f 87 90 00 00 00    	ja     80101ae4 <bmap+0xc4>
        if ((addr = ip->addrs[NDIRECT]) == 0) {
80101a54:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101a5a:	8b 00                	mov    (%eax),%eax
80101a5c:	85 d2                	test   %edx,%edx
80101a5e:	74 70                	je     80101ad0 <bmap+0xb0>
        bp = bread(ip->dev, addr);
80101a60:	83 ec 08             	sub    $0x8,%esp
80101a63:	52                   	push   %edx
80101a64:	50                   	push   %eax
80101a65:	e8 66 e6 ff ff       	call   801000d0 <bread>
        if ((addr = a[bn]) == 0) {
80101a6a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
80101a6e:	83 c4 10             	add    $0x10,%esp
        bp = bread(ip->dev, addr);
80101a71:	89 c7                	mov    %eax,%edi
        if ((addr = a[bn]) == 0) {
80101a73:	8b 1a                	mov    (%edx),%ebx
80101a75:	85 db                	test   %ebx,%ebx
80101a77:	75 1d                	jne    80101a96 <bmap+0x76>
            a[bn] = addr = balloc(ip->dev);
80101a79:	8b 06                	mov    (%esi),%eax
80101a7b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101a7e:	e8 bd fd ff ff       	call   80101840 <balloc>
80101a83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            log_write(bp);
80101a86:	83 ec 0c             	sub    $0xc,%esp
            a[bn] = addr = balloc(ip->dev);
80101a89:	89 c3                	mov    %eax,%ebx
80101a8b:	89 02                	mov    %eax,(%edx)
            log_write(bp);
80101a8d:	57                   	push   %edi
80101a8e:	e8 9d 19 00 00       	call   80103430 <log_write>
80101a93:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101a96:	83 ec 0c             	sub    $0xc,%esp
80101a99:	57                   	push   %edi
80101a9a:	e8 41 e7 ff ff       	call   801001e0 <brelse>
80101a9f:	83 c4 10             	add    $0x10,%esp
}
80101aa2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aa5:	89 d8                	mov    %ebx,%eax
80101aa7:	5b                   	pop    %ebx
80101aa8:	5e                   	pop    %esi
80101aa9:	5f                   	pop    %edi
80101aaa:	5d                   	pop    %ebp
80101aab:	c3                   	ret    
80101aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            ip->addrs[bn] = addr = balloc(ip->dev);
80101ab0:	8b 00                	mov    (%eax),%eax
80101ab2:	e8 89 fd ff ff       	call   80101840 <balloc>
80101ab7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
80101aba:	8d 65 f4             	lea    -0xc(%ebp),%esp
            ip->addrs[bn] = addr = balloc(ip->dev);
80101abd:	89 c3                	mov    %eax,%ebx
}
80101abf:	89 d8                	mov    %ebx,%eax
80101ac1:	5b                   	pop    %ebx
80101ac2:	5e                   	pop    %esi
80101ac3:	5f                   	pop    %edi
80101ac4:	5d                   	pop    %ebp
80101ac5:	c3                   	ret    
80101ac6:	8d 76 00             	lea    0x0(%esi),%esi
80101ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101ad0:	e8 6b fd ff ff       	call   80101840 <balloc>
80101ad5:	89 c2                	mov    %eax,%edx
80101ad7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101add:	8b 06                	mov    (%esi),%eax
80101adf:	e9 7c ff ff ff       	jmp    80101a60 <bmap+0x40>
    panic("bmap: out of range");
80101ae4:	83 ec 0c             	sub    $0xc,%esp
80101ae7:	68 d8 77 10 80       	push   $0x801077d8
80101aec:	e8 8f e9 ff ff       	call   80100480 <panic>
80101af1:	eb 0d                	jmp    80101b00 <readsb>
80101af3:	90                   	nop
80101af4:	90                   	nop
80101af5:	90                   	nop
80101af6:	90                   	nop
80101af7:	90                   	nop
80101af8:	90                   	nop
80101af9:	90                   	nop
80101afa:	90                   	nop
80101afb:	90                   	nop
80101afc:	90                   	nop
80101afd:	90                   	nop
80101afe:	90                   	nop
80101aff:	90                   	nop

80101b00 <readsb>:
void readsb(int dev, struct superblock *sb) {
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	56                   	push   %esi
80101b04:	53                   	push   %ebx
80101b05:	8b 75 0c             	mov    0xc(%ebp),%esi
    bp = bread(dev, 1);
80101b08:	83 ec 08             	sub    $0x8,%esp
80101b0b:	6a 01                	push   $0x1
80101b0d:	ff 75 08             	pushl  0x8(%ebp)
80101b10:	e8 bb e5 ff ff       	call   801000d0 <bread>
80101b15:	89 c3                	mov    %eax,%ebx
    memmove(sb, bp->data, sizeof(*sb));
80101b17:	8d 40 5c             	lea    0x5c(%eax),%eax
80101b1a:	83 c4 0c             	add    $0xc,%esp
80101b1d:	6a 1c                	push   $0x1c
80101b1f:	50                   	push   %eax
80101b20:	56                   	push   %esi
80101b21:	e8 ca 30 00 00       	call   80104bf0 <memmove>
    brelse(bp);
80101b26:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b29:	83 c4 10             	add    $0x10,%esp
}
80101b2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b2f:	5b                   	pop    %ebx
80101b30:	5e                   	pop    %esi
80101b31:	5d                   	pop    %ebp
    brelse(bp);
80101b32:	e9 a9 e6 ff ff       	jmp    801001e0 <brelse>
80101b37:	89 f6                	mov    %esi,%esi
80101b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b40 <iinit>:
void iinit(int dev) {
80101b40:	55                   	push   %ebp
80101b41:	89 e5                	mov    %esp,%ebp
80101b43:	53                   	push   %ebx
80101b44:	bb 00 32 11 80       	mov    $0x80113200,%ebx
80101b49:	83 ec 0c             	sub    $0xc,%esp
    initlock(&icache.lock, "icache");
80101b4c:	68 eb 77 10 80       	push   $0x801077eb
80101b51:	68 c0 31 11 80       	push   $0x801131c0
80101b56:	e8 95 2d 00 00       	call   801048f0 <initlock>
80101b5b:	83 c4 10             	add    $0x10,%esp
80101b5e:	66 90                	xchg   %ax,%ax
        initsleeplock(&icache.inode[i].lock, "inode");
80101b60:	83 ec 08             	sub    $0x8,%esp
80101b63:	68 f2 77 10 80       	push   $0x801077f2
80101b68:	53                   	push   %ebx
80101b69:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101b6f:	e8 4c 2c 00 00       	call   801047c0 <initsleeplock>
    for (i = 0; i < NINODE; i++) {
80101b74:	83 c4 10             	add    $0x10,%esp
80101b77:	81 fb 20 4e 11 80    	cmp    $0x80114e20,%ebx
80101b7d:	75 e1                	jne    80101b60 <iinit+0x20>
    readsb(dev, &sb);
80101b7f:	83 ec 08             	sub    $0x8,%esp
80101b82:	68 a0 31 11 80       	push   $0x801131a0
80101b87:	ff 75 08             	pushl  0x8(%ebp)
80101b8a:	e8 71 ff ff ff       	call   80101b00 <readsb>
    cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101b8f:	ff 35 b8 31 11 80    	pushl  0x801131b8
80101b95:	ff 35 b4 31 11 80    	pushl  0x801131b4
80101b9b:	ff 35 b0 31 11 80    	pushl  0x801131b0
80101ba1:	ff 35 ac 31 11 80    	pushl  0x801131ac
80101ba7:	ff 35 a8 31 11 80    	pushl  0x801131a8
80101bad:	ff 35 a4 31 11 80    	pushl  0x801131a4
80101bb3:	ff 35 a0 31 11 80    	pushl  0x801131a0
80101bb9:	68 58 78 10 80       	push   $0x80107858
80101bbe:	e8 3d ec ff ff       	call   80100800 <cprintf>
}
80101bc3:	83 c4 30             	add    $0x30,%esp
80101bc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101bc9:	c9                   	leave  
80101bca:	c3                   	ret    
80101bcb:	90                   	nop
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101bd0 <ialloc>:
struct inode* ialloc(uint dev, short type) {
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	57                   	push   %edi
80101bd4:	56                   	push   %esi
80101bd5:	53                   	push   %ebx
80101bd6:	83 ec 1c             	sub    $0x1c,%esp
    for (inum = 1; inum < sb.ninodes; inum++) {
80101bd9:	83 3d a8 31 11 80 01 	cmpl   $0x1,0x801131a8
struct inode* ialloc(uint dev, short type) {
80101be0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101be3:	8b 75 08             	mov    0x8(%ebp),%esi
80101be6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (inum = 1; inum < sb.ninodes; inum++) {
80101be9:	0f 86 91 00 00 00    	jbe    80101c80 <ialloc+0xb0>
80101bef:	bb 01 00 00 00       	mov    $0x1,%ebx
80101bf4:	eb 21                	jmp    80101c17 <ialloc+0x47>
80101bf6:	8d 76 00             	lea    0x0(%esi),%esi
80101bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        brelse(bp);
80101c00:	83 ec 0c             	sub    $0xc,%esp
    for (inum = 1; inum < sb.ninodes; inum++) {
80101c03:	83 c3 01             	add    $0x1,%ebx
        brelse(bp);
80101c06:	57                   	push   %edi
80101c07:	e8 d4 e5 ff ff       	call   801001e0 <brelse>
    for (inum = 1; inum < sb.ninodes; inum++) {
80101c0c:	83 c4 10             	add    $0x10,%esp
80101c0f:	39 1d a8 31 11 80    	cmp    %ebx,0x801131a8
80101c15:	76 69                	jbe    80101c80 <ialloc+0xb0>
        bp = bread(dev, IBLOCK(inum, sb));
80101c17:	89 d8                	mov    %ebx,%eax
80101c19:	83 ec 08             	sub    $0x8,%esp
80101c1c:	c1 e8 03             	shr    $0x3,%eax
80101c1f:	03 05 b4 31 11 80    	add    0x801131b4,%eax
80101c25:	50                   	push   %eax
80101c26:	56                   	push   %esi
80101c27:	e8 a4 e4 ff ff       	call   801000d0 <bread>
80101c2c:	89 c7                	mov    %eax,%edi
        dip = (struct dinode*)bp->data + inum % IPB;
80101c2e:	89 d8                	mov    %ebx,%eax
        if (dip->type == 0) { // a free inode
80101c30:	83 c4 10             	add    $0x10,%esp
        dip = (struct dinode*)bp->data + inum % IPB;
80101c33:	83 e0 07             	and    $0x7,%eax
80101c36:	c1 e0 06             	shl    $0x6,%eax
80101c39:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
        if (dip->type == 0) { // a free inode
80101c3d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101c41:	75 bd                	jne    80101c00 <ialloc+0x30>
            memset(dip, 0, sizeof(*dip));
80101c43:	83 ec 04             	sub    $0x4,%esp
80101c46:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101c49:	6a 40                	push   $0x40
80101c4b:	6a 00                	push   $0x0
80101c4d:	51                   	push   %ecx
80101c4e:	e8 ed 2e 00 00       	call   80104b40 <memset>
            dip->type = type;
80101c53:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101c57:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101c5a:	66 89 01             	mov    %ax,(%ecx)
            log_write(bp);   // mark it allocated on the disk
80101c5d:	89 3c 24             	mov    %edi,(%esp)
80101c60:	e8 cb 17 00 00       	call   80103430 <log_write>
            brelse(bp);
80101c65:	89 3c 24             	mov    %edi,(%esp)
80101c68:	e8 73 e5 ff ff       	call   801001e0 <brelse>
            return iget(dev, inum);
80101c6d:	83 c4 10             	add    $0x10,%esp
}
80101c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return iget(dev, inum);
80101c73:	89 da                	mov    %ebx,%edx
80101c75:	89 f0                	mov    %esi,%eax
}
80101c77:	5b                   	pop    %ebx
80101c78:	5e                   	pop    %esi
80101c79:	5f                   	pop    %edi
80101c7a:	5d                   	pop    %ebp
            return iget(dev, inum);
80101c7b:	e9 d0 fc ff ff       	jmp    80101950 <iget>
    panic("ialloc: no inodes");
80101c80:	83 ec 0c             	sub    $0xc,%esp
80101c83:	68 f8 77 10 80       	push   $0x801077f8
80101c88:	e8 f3 e7 ff ff       	call   80100480 <panic>
80101c8d:	8d 76 00             	lea    0x0(%esi),%esi

80101c90 <iupdate>:
void iupdate(struct inode *ip) {
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	56                   	push   %esi
80101c94:	53                   	push   %ebx
80101c95:	8b 5d 08             	mov    0x8(%ebp),%ebx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c98:	83 ec 08             	sub    $0x8,%esp
80101c9b:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c9e:	83 c3 5c             	add    $0x5c,%ebx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101ca1:	c1 e8 03             	shr    $0x3,%eax
80101ca4:	03 05 b4 31 11 80    	add    0x801131b4,%eax
80101caa:	50                   	push   %eax
80101cab:	ff 73 a4             	pushl  -0x5c(%ebx)
80101cae:	e8 1d e4 ff ff       	call   801000d0 <bread>
80101cb3:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum % IPB;
80101cb5:	8b 43 a8             	mov    -0x58(%ebx),%eax
    dip->type = ip->type;
80101cb8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101cbc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum % IPB;
80101cbf:	83 e0 07             	and    $0x7,%eax
80101cc2:	c1 e0 06             	shl    $0x6,%eax
80101cc5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    dip->type = ip->type;
80101cc9:	66 89 10             	mov    %dx,(%eax)
    dip->major = ip->major;
80101ccc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101cd0:	83 c0 0c             	add    $0xc,%eax
    dip->major = ip->major;
80101cd3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
    dip->minor = ip->minor;
80101cd7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101cdb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
    dip->nlink = ip->nlink;
80101cdf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101ce3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
    dip->size = ip->size;
80101ce7:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101cea:	89 50 fc             	mov    %edx,-0x4(%eax)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101ced:	6a 34                	push   $0x34
80101cef:	53                   	push   %ebx
80101cf0:	50                   	push   %eax
80101cf1:	e8 fa 2e 00 00       	call   80104bf0 <memmove>
    log_write(bp);
80101cf6:	89 34 24             	mov    %esi,(%esp)
80101cf9:	e8 32 17 00 00       	call   80103430 <log_write>
    brelse(bp);
80101cfe:	89 75 08             	mov    %esi,0x8(%ebp)
80101d01:	83 c4 10             	add    $0x10,%esp
}
80101d04:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d07:	5b                   	pop    %ebx
80101d08:	5e                   	pop    %esi
80101d09:	5d                   	pop    %ebp
    brelse(bp);
80101d0a:	e9 d1 e4 ff ff       	jmp    801001e0 <brelse>
80101d0f:	90                   	nop

80101d10 <idup>:
struct inode* idup(struct inode *ip) {
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	53                   	push   %ebx
80101d14:	83 ec 10             	sub    $0x10,%esp
80101d17:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&icache.lock);
80101d1a:	68 c0 31 11 80       	push   $0x801131c0
80101d1f:	e8 0c 2d 00 00       	call   80104a30 <acquire>
    ip->ref++;
80101d24:	83 43 08 01          	addl   $0x1,0x8(%ebx)
    release(&icache.lock);
80101d28:	c7 04 24 c0 31 11 80 	movl   $0x801131c0,(%esp)
80101d2f:	e8 bc 2d 00 00       	call   80104af0 <release>
}
80101d34:	89 d8                	mov    %ebx,%eax
80101d36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d39:	c9                   	leave  
80101d3a:	c3                   	ret    
80101d3b:	90                   	nop
80101d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d40 <ilock>:
void ilock(struct inode *ip) {
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	56                   	push   %esi
80101d44:	53                   	push   %ebx
80101d45:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (ip == 0 || ip->ref < 1) {
80101d48:	85 db                	test   %ebx,%ebx
80101d4a:	0f 84 b7 00 00 00    	je     80101e07 <ilock+0xc7>
80101d50:	8b 53 08             	mov    0x8(%ebx),%edx
80101d53:	85 d2                	test   %edx,%edx
80101d55:	0f 8e ac 00 00 00    	jle    80101e07 <ilock+0xc7>
    acquiresleep(&ip->lock);
80101d5b:	8d 43 0c             	lea    0xc(%ebx),%eax
80101d5e:	83 ec 0c             	sub    $0xc,%esp
80101d61:	50                   	push   %eax
80101d62:	e8 99 2a 00 00       	call   80104800 <acquiresleep>
    if (ip->valid == 0) {
80101d67:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101d6a:	83 c4 10             	add    $0x10,%esp
80101d6d:	85 c0                	test   %eax,%eax
80101d6f:	74 0f                	je     80101d80 <ilock+0x40>
}
80101d71:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d74:	5b                   	pop    %ebx
80101d75:	5e                   	pop    %esi
80101d76:	5d                   	pop    %ebp
80101d77:	c3                   	ret    
80101d78:	90                   	nop
80101d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d80:	8b 43 04             	mov    0x4(%ebx),%eax
80101d83:	83 ec 08             	sub    $0x8,%esp
80101d86:	c1 e8 03             	shr    $0x3,%eax
80101d89:	03 05 b4 31 11 80    	add    0x801131b4,%eax
80101d8f:	50                   	push   %eax
80101d90:	ff 33                	pushl  (%ebx)
80101d92:	e8 39 e3 ff ff       	call   801000d0 <bread>
80101d97:	89 c6                	mov    %eax,%esi
        dip = (struct dinode*)bp->data + ip->inum % IPB;
80101d99:	8b 43 04             	mov    0x4(%ebx),%eax
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101d9c:	83 c4 0c             	add    $0xc,%esp
        dip = (struct dinode*)bp->data + ip->inum % IPB;
80101d9f:	83 e0 07             	and    $0x7,%eax
80101da2:	c1 e0 06             	shl    $0x6,%eax
80101da5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
        ip->type = dip->type;
80101da9:	0f b7 10             	movzwl (%eax),%edx
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101dac:	83 c0 0c             	add    $0xc,%eax
        ip->type = dip->type;
80101daf:	66 89 53 50          	mov    %dx,0x50(%ebx)
        ip->major = dip->major;
80101db3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101db7:	66 89 53 52          	mov    %dx,0x52(%ebx)
        ip->minor = dip->minor;
80101dbb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101dbf:	66 89 53 54          	mov    %dx,0x54(%ebx)
        ip->nlink = dip->nlink;
80101dc3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101dc7:	66 89 53 56          	mov    %dx,0x56(%ebx)
        ip->size = dip->size;
80101dcb:	8b 50 fc             	mov    -0x4(%eax),%edx
80101dce:	89 53 58             	mov    %edx,0x58(%ebx)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101dd1:	6a 34                	push   $0x34
80101dd3:	50                   	push   %eax
80101dd4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101dd7:	50                   	push   %eax
80101dd8:	e8 13 2e 00 00       	call   80104bf0 <memmove>
        brelse(bp);
80101ddd:	89 34 24             	mov    %esi,(%esp)
80101de0:	e8 fb e3 ff ff       	call   801001e0 <brelse>
        if (ip->type == 0) {
80101de5:	83 c4 10             	add    $0x10,%esp
80101de8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
        ip->valid = 1;
80101ded:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
        if (ip->type == 0) {
80101df4:	0f 85 77 ff ff ff    	jne    80101d71 <ilock+0x31>
            panic("ilock: no type");
80101dfa:	83 ec 0c             	sub    $0xc,%esp
80101dfd:	68 10 78 10 80       	push   $0x80107810
80101e02:	e8 79 e6 ff ff       	call   80100480 <panic>
        panic("ilock");
80101e07:	83 ec 0c             	sub    $0xc,%esp
80101e0a:	68 0a 78 10 80       	push   $0x8010780a
80101e0f:	e8 6c e6 ff ff       	call   80100480 <panic>
80101e14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101e1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101e20 <iunlock>:
void iunlock(struct inode *ip) {
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	56                   	push   %esi
80101e24:	53                   	push   %ebx
80101e25:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) {
80101e28:	85 db                	test   %ebx,%ebx
80101e2a:	74 28                	je     80101e54 <iunlock+0x34>
80101e2c:	8d 73 0c             	lea    0xc(%ebx),%esi
80101e2f:	83 ec 0c             	sub    $0xc,%esp
80101e32:	56                   	push   %esi
80101e33:	e8 68 2a 00 00       	call   801048a0 <holdingsleep>
80101e38:	83 c4 10             	add    $0x10,%esp
80101e3b:	85 c0                	test   %eax,%eax
80101e3d:	74 15                	je     80101e54 <iunlock+0x34>
80101e3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101e42:	85 c0                	test   %eax,%eax
80101e44:	7e 0e                	jle    80101e54 <iunlock+0x34>
    releasesleep(&ip->lock);
80101e46:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101e49:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e4c:	5b                   	pop    %ebx
80101e4d:	5e                   	pop    %esi
80101e4e:	5d                   	pop    %ebp
    releasesleep(&ip->lock);
80101e4f:	e9 0c 2a 00 00       	jmp    80104860 <releasesleep>
        panic("iunlock");
80101e54:	83 ec 0c             	sub    $0xc,%esp
80101e57:	68 1f 78 10 80       	push   $0x8010781f
80101e5c:	e8 1f e6 ff ff       	call   80100480 <panic>
80101e61:	eb 0d                	jmp    80101e70 <iput>
80101e63:	90                   	nop
80101e64:	90                   	nop
80101e65:	90                   	nop
80101e66:	90                   	nop
80101e67:	90                   	nop
80101e68:	90                   	nop
80101e69:	90                   	nop
80101e6a:	90                   	nop
80101e6b:	90                   	nop
80101e6c:	90                   	nop
80101e6d:	90                   	nop
80101e6e:	90                   	nop
80101e6f:	90                   	nop

80101e70 <iput>:
void iput(struct inode *ip) {
80101e70:	55                   	push   %ebp
80101e71:	89 e5                	mov    %esp,%ebp
80101e73:	57                   	push   %edi
80101e74:	56                   	push   %esi
80101e75:	53                   	push   %ebx
80101e76:	83 ec 28             	sub    $0x28,%esp
80101e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquiresleep(&ip->lock);
80101e7c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101e7f:	57                   	push   %edi
80101e80:	e8 7b 29 00 00       	call   80104800 <acquiresleep>
    if (ip->valid && ip->nlink == 0) {
80101e85:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101e88:	83 c4 10             	add    $0x10,%esp
80101e8b:	85 d2                	test   %edx,%edx
80101e8d:	74 07                	je     80101e96 <iput+0x26>
80101e8f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101e94:	74 32                	je     80101ec8 <iput+0x58>
    releasesleep(&ip->lock);
80101e96:	83 ec 0c             	sub    $0xc,%esp
80101e99:	57                   	push   %edi
80101e9a:	e8 c1 29 00 00       	call   80104860 <releasesleep>
    acquire(&icache.lock);
80101e9f:	c7 04 24 c0 31 11 80 	movl   $0x801131c0,(%esp)
80101ea6:	e8 85 2b 00 00       	call   80104a30 <acquire>
    ip->ref--;
80101eab:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
    release(&icache.lock);
80101eaf:	83 c4 10             	add    $0x10,%esp
80101eb2:	c7 45 08 c0 31 11 80 	movl   $0x801131c0,0x8(%ebp)
}
80101eb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ebc:	5b                   	pop    %ebx
80101ebd:	5e                   	pop    %esi
80101ebe:	5f                   	pop    %edi
80101ebf:	5d                   	pop    %ebp
    release(&icache.lock);
80101ec0:	e9 2b 2c 00 00       	jmp    80104af0 <release>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
        acquire(&icache.lock);
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	68 c0 31 11 80       	push   $0x801131c0
80101ed0:	e8 5b 2b 00 00       	call   80104a30 <acquire>
        int r = ip->ref;
80101ed5:	8b 73 08             	mov    0x8(%ebx),%esi
        release(&icache.lock);
80101ed8:	c7 04 24 c0 31 11 80 	movl   $0x801131c0,(%esp)
80101edf:	e8 0c 2c 00 00       	call   80104af0 <release>
        if (r == 1) {
80101ee4:	83 c4 10             	add    $0x10,%esp
80101ee7:	83 fe 01             	cmp    $0x1,%esi
80101eea:	75 aa                	jne    80101e96 <iput+0x26>
80101eec:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101ef2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101ef5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101ef8:	89 cf                	mov    %ecx,%edi
80101efa:	eb 0b                	jmp    80101f07 <iput+0x97>
80101efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f00:	83 c6 04             	add    $0x4,%esi
static void itrunc(struct inode *ip) {
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++) {
80101f03:	39 fe                	cmp    %edi,%esi
80101f05:	74 19                	je     80101f20 <iput+0xb0>
        if (ip->addrs[i]) {
80101f07:	8b 16                	mov    (%esi),%edx
80101f09:	85 d2                	test   %edx,%edx
80101f0b:	74 f3                	je     80101f00 <iput+0x90>
            bfree(ip->dev, ip->addrs[i]);
80101f0d:	8b 03                	mov    (%ebx),%eax
80101f0f:	e8 bc f8 ff ff       	call   801017d0 <bfree>
            ip->addrs[i] = 0;
80101f14:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101f1a:	eb e4                	jmp    80101f00 <iput+0x90>
80101f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        }
    }

    if (ip->addrs[NDIRECT]) {
80101f20:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101f26:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101f29:	85 c0                	test   %eax,%eax
80101f2b:	75 33                	jne    80101f60 <iput+0xf0>
        bfree(ip->dev, ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    iupdate(ip);
80101f2d:	83 ec 0c             	sub    $0xc,%esp
    ip->size = 0;
80101f30:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
    iupdate(ip);
80101f37:	53                   	push   %ebx
80101f38:	e8 53 fd ff ff       	call   80101c90 <iupdate>
            ip->type = 0;
80101f3d:	31 c0                	xor    %eax,%eax
80101f3f:	66 89 43 50          	mov    %ax,0x50(%ebx)
            iupdate(ip);
80101f43:	89 1c 24             	mov    %ebx,(%esp)
80101f46:	e8 45 fd ff ff       	call   80101c90 <iupdate>
            ip->valid = 0;
80101f4b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101f52:	83 c4 10             	add    $0x10,%esp
80101f55:	e9 3c ff ff ff       	jmp    80101e96 <iput+0x26>
80101f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101f60:	83 ec 08             	sub    $0x8,%esp
80101f63:	50                   	push   %eax
80101f64:	ff 33                	pushl  (%ebx)
80101f66:	e8 65 e1 ff ff       	call   801000d0 <bread>
80101f6b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101f71:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101f74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        a = (uint*)bp->data;
80101f77:	8d 70 5c             	lea    0x5c(%eax),%esi
80101f7a:	83 c4 10             	add    $0x10,%esp
80101f7d:	89 cf                	mov    %ecx,%edi
80101f7f:	eb 0e                	jmp    80101f8f <iput+0x11f>
80101f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f88:	83 c6 04             	add    $0x4,%esi
        for (j = 0; j < NINDIRECT; j++) {
80101f8b:	39 fe                	cmp    %edi,%esi
80101f8d:	74 0f                	je     80101f9e <iput+0x12e>
            if (a[j]) {
80101f8f:	8b 16                	mov    (%esi),%edx
80101f91:	85 d2                	test   %edx,%edx
80101f93:	74 f3                	je     80101f88 <iput+0x118>
                bfree(ip->dev, a[j]);
80101f95:	8b 03                	mov    (%ebx),%eax
80101f97:	e8 34 f8 ff ff       	call   801017d0 <bfree>
80101f9c:	eb ea                	jmp    80101f88 <iput+0x118>
        brelse(bp);
80101f9e:	83 ec 0c             	sub    $0xc,%esp
80101fa1:	ff 75 e4             	pushl  -0x1c(%ebp)
80101fa4:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101fa7:	e8 34 e2 ff ff       	call   801001e0 <brelse>
        bfree(ip->dev, ip->addrs[NDIRECT]);
80101fac:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101fb2:	8b 03                	mov    (%ebx),%eax
80101fb4:	e8 17 f8 ff ff       	call   801017d0 <bfree>
        ip->addrs[NDIRECT] = 0;
80101fb9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101fc0:	00 00 00 
80101fc3:	83 c4 10             	add    $0x10,%esp
80101fc6:	e9 62 ff ff ff       	jmp    80101f2d <iput+0xbd>
80101fcb:	90                   	nop
80101fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fd0 <iunlockput>:
void iunlockput(struct inode *ip) {
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	53                   	push   %ebx
80101fd4:	83 ec 10             	sub    $0x10,%esp
80101fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    iunlock(ip);
80101fda:	53                   	push   %ebx
80101fdb:	e8 40 fe ff ff       	call   80101e20 <iunlock>
    iput(ip);
80101fe0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101fe3:	83 c4 10             	add    $0x10,%esp
}
80101fe6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101fe9:	c9                   	leave  
    iput(ip);
80101fea:	e9 81 fe ff ff       	jmp    80101e70 <iput>
80101fef:	90                   	nop

80101ff0 <stati>:
}

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st) {
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
    st->dev = ip->dev;
80101ff9:	8b 0a                	mov    (%edx),%ecx
80101ffb:	89 48 04             	mov    %ecx,0x4(%eax)
    st->ino = ip->inum;
80101ffe:	8b 4a 04             	mov    0x4(%edx),%ecx
80102001:	89 48 08             	mov    %ecx,0x8(%eax)
    st->type = ip->type;
80102004:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80102008:	66 89 08             	mov    %cx,(%eax)
    st->nlink = ip->nlink;
8010200b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010200f:	66 89 48 0c          	mov    %cx,0xc(%eax)
    st->size = ip->size;
80102013:	8b 52 58             	mov    0x58(%edx),%edx
80102016:	89 50 10             	mov    %edx,0x10(%eax)
}
80102019:	5d                   	pop    %ebp
8010201a:	c3                   	ret    
8010201b:	90                   	nop
8010201c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102020 <readi>:


// Read data from inode.
// Caller must hold ip->lock.
int readi(struct inode *ip, char *dst, uint off, uint n) {
80102020:	55                   	push   %ebp
80102021:	89 e5                	mov    %esp,%ebp
80102023:	57                   	push   %edi
80102024:	56                   	push   %esi
80102025:	53                   	push   %ebx
80102026:	83 ec 1c             	sub    $0x1c,%esp
80102029:	8b 45 08             	mov    0x8(%ebp),%eax
8010202c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010202f:	8b 7d 14             	mov    0x14(%ebp),%edi
    uint tot, m;
    struct buf *bp;

    if (ip->type == T_DEV) {
80102032:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
int readi(struct inode *ip, char *dst, uint off, uint n) {
80102037:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010203a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010203d:	8b 75 10             	mov    0x10(%ebp),%esi
80102040:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    if (ip->type == T_DEV) {
80102043:	0f 84 a7 00 00 00    	je     801020f0 <readi+0xd0>
            return -1;
        }
        return devsw[ip->major].read(ip, dst, n);
    }

    if (off > ip->size || off + n < off) {
80102049:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010204c:	8b 40 58             	mov    0x58(%eax),%eax
8010204f:	39 c6                	cmp    %eax,%esi
80102051:	0f 87 ba 00 00 00    	ja     80102111 <readi+0xf1>
80102057:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010205a:	89 f9                	mov    %edi,%ecx
8010205c:	01 f1                	add    %esi,%ecx
8010205e:	0f 82 ad 00 00 00    	jb     80102111 <readi+0xf1>
        return -1;
    }
    if (off + n > ip->size) {
        n = ip->size - off;
80102064:	89 c2                	mov    %eax,%edx
80102066:	29 f2                	sub    %esi,%edx
80102068:	39 c8                	cmp    %ecx,%eax
8010206a:	0f 43 d7             	cmovae %edi,%edx
    }

    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
8010206d:	31 ff                	xor    %edi,%edi
8010206f:	85 d2                	test   %edx,%edx
        n = ip->size - off;
80102071:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80102074:	74 6c                	je     801020e2 <readi+0xc2>
80102076:	8d 76 00             	lea    0x0(%esi),%esi
80102079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80102080:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102083:	89 f2                	mov    %esi,%edx
80102085:	c1 ea 09             	shr    $0x9,%edx
80102088:	89 d8                	mov    %ebx,%eax
8010208a:	e8 91 f9 ff ff       	call   80101a20 <bmap>
8010208f:	83 ec 08             	sub    $0x8,%esp
80102092:	50                   	push   %eax
80102093:	ff 33                	pushl  (%ebx)
80102095:	e8 36 e0 ff ff       	call   801000d0 <bread>
        m = min(n - tot, BSIZE - off % BSIZE);
8010209a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
8010209d:	89 c2                	mov    %eax,%edx
        m = min(n - tot, BSIZE - off % BSIZE);
8010209f:	89 f0                	mov    %esi,%eax
801020a1:	25 ff 01 00 00       	and    $0x1ff,%eax
801020a6:	b9 00 02 00 00       	mov    $0x200,%ecx
801020ab:	83 c4 0c             	add    $0xc,%esp
801020ae:	29 c1                	sub    %eax,%ecx
        memmove(dst, bp->data + off % BSIZE, m);
801020b0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
801020b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
        m = min(n - tot, BSIZE - off % BSIZE);
801020b7:	29 fb                	sub    %edi,%ebx
801020b9:	39 d9                	cmp    %ebx,%ecx
801020bb:	0f 46 d9             	cmovbe %ecx,%ebx
        memmove(dst, bp->data + off % BSIZE, m);
801020be:	53                   	push   %ebx
801020bf:	50                   	push   %eax
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
801020c0:	01 df                	add    %ebx,%edi
        memmove(dst, bp->data + off % BSIZE, m);
801020c2:	ff 75 e0             	pushl  -0x20(%ebp)
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
801020c5:	01 de                	add    %ebx,%esi
        memmove(dst, bp->data + off % BSIZE, m);
801020c7:	e8 24 2b 00 00       	call   80104bf0 <memmove>
        brelse(bp);
801020cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
801020cf:	89 14 24             	mov    %edx,(%esp)
801020d2:	e8 09 e1 ff ff       	call   801001e0 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
801020d7:	01 5d e0             	add    %ebx,-0x20(%ebp)
801020da:	83 c4 10             	add    $0x10,%esp
801020dd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801020e0:	77 9e                	ja     80102080 <readi+0x60>
    }
    return n;
801020e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801020e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020e8:	5b                   	pop    %ebx
801020e9:	5e                   	pop    %esi
801020ea:	5f                   	pop    %edi
801020eb:	5d                   	pop    %ebp
801020ec:	c3                   	ret    
801020ed:	8d 76 00             	lea    0x0(%esi),%esi
        if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read) {
801020f0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801020f4:	66 83 f8 09          	cmp    $0x9,%ax
801020f8:	77 17                	ja     80102111 <readi+0xf1>
801020fa:	8b 04 c5 40 31 11 80 	mov    -0x7feecec0(,%eax,8),%eax
80102101:	85 c0                	test   %eax,%eax
80102103:	74 0c                	je     80102111 <readi+0xf1>
        return devsw[ip->major].read(ip, dst, n);
80102105:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102108:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010210b:	5b                   	pop    %ebx
8010210c:	5e                   	pop    %esi
8010210d:	5f                   	pop    %edi
8010210e:	5d                   	pop    %ebp
        return devsw[ip->major].read(ip, dst, n);
8010210f:	ff e0                	jmp    *%eax
            return -1;
80102111:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102116:	eb cd                	jmp    801020e5 <readi+0xc5>
80102118:	90                   	nop
80102119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102120 <writei>:

// Write data to inode.
// Caller must hold ip->lock.
int writei(struct inode *ip, char *src, uint off, uint n) {
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	57                   	push   %edi
80102124:	56                   	push   %esi
80102125:	53                   	push   %ebx
80102126:	83 ec 1c             	sub    $0x1c,%esp
80102129:	8b 45 08             	mov    0x8(%ebp),%eax
8010212c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010212f:	8b 7d 14             	mov    0x14(%ebp),%edi
    uint tot, m;
    struct buf *bp;

    if (ip->type == T_DEV) {
80102132:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
int writei(struct inode *ip, char *src, uint off, uint n) {
80102137:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010213a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010213d:	8b 75 10             	mov    0x10(%ebp),%esi
80102140:	89 7d e0             	mov    %edi,-0x20(%ebp)
    if (ip->type == T_DEV) {
80102143:	0f 84 b7 00 00 00    	je     80102200 <writei+0xe0>
            return -1;
        }
        return devsw[ip->major].write(ip, src, n);
    }

    if (off > ip->size || off + n < off) {
80102149:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010214c:	39 70 58             	cmp    %esi,0x58(%eax)
8010214f:	0f 82 eb 00 00 00    	jb     80102240 <writei+0x120>
80102155:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102158:	31 d2                	xor    %edx,%edx
8010215a:	89 f8                	mov    %edi,%eax
8010215c:	01 f0                	add    %esi,%eax
8010215e:	0f 92 c2             	setb   %dl
        return -1;
    }
    if (off + n > MAXFILE * BSIZE) {
80102161:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102166:	0f 87 d4 00 00 00    	ja     80102240 <writei+0x120>
8010216c:	85 d2                	test   %edx,%edx
8010216e:	0f 85 cc 00 00 00    	jne    80102240 <writei+0x120>
        return -1;
    }

    for (tot = 0; tot < n; tot += m, off += m, src += m) {
80102174:	85 ff                	test   %edi,%edi
80102176:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010217d:	74 72                	je     801021f1 <writei+0xd1>
8010217f:	90                   	nop
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80102180:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102183:	89 f2                	mov    %esi,%edx
80102185:	c1 ea 09             	shr    $0x9,%edx
80102188:	89 f8                	mov    %edi,%eax
8010218a:	e8 91 f8 ff ff       	call   80101a20 <bmap>
8010218f:	83 ec 08             	sub    $0x8,%esp
80102192:	50                   	push   %eax
80102193:	ff 37                	pushl  (%edi)
80102195:	e8 36 df ff ff       	call   801000d0 <bread>
        m = min(n - tot, BSIZE - off % BSIZE);
8010219a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010219d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
801021a0:	89 c7                	mov    %eax,%edi
        m = min(n - tot, BSIZE - off % BSIZE);
801021a2:	89 f0                	mov    %esi,%eax
801021a4:	b9 00 02 00 00       	mov    $0x200,%ecx
801021a9:	83 c4 0c             	add    $0xc,%esp
801021ac:	25 ff 01 00 00       	and    $0x1ff,%eax
801021b1:	29 c1                	sub    %eax,%ecx
        memmove(bp->data + off % BSIZE, src, m);
801021b3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
        m = min(n - tot, BSIZE - off % BSIZE);
801021b7:	39 d9                	cmp    %ebx,%ecx
801021b9:	0f 46 d9             	cmovbe %ecx,%ebx
        memmove(bp->data + off % BSIZE, src, m);
801021bc:	53                   	push   %ebx
801021bd:	ff 75 dc             	pushl  -0x24(%ebp)
    for (tot = 0; tot < n; tot += m, off += m, src += m) {
801021c0:	01 de                	add    %ebx,%esi
        memmove(bp->data + off % BSIZE, src, m);
801021c2:	50                   	push   %eax
801021c3:	e8 28 2a 00 00       	call   80104bf0 <memmove>
        log_write(bp);
801021c8:	89 3c 24             	mov    %edi,(%esp)
801021cb:	e8 60 12 00 00       	call   80103430 <log_write>
        brelse(bp);
801021d0:	89 3c 24             	mov    %edi,(%esp)
801021d3:	e8 08 e0 ff ff       	call   801001e0 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, src += m) {
801021d8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801021db:	01 5d dc             	add    %ebx,-0x24(%ebp)
801021de:	83 c4 10             	add    $0x10,%esp
801021e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801021e4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
801021e7:	77 97                	ja     80102180 <writei+0x60>
    }

    if (n > 0 && off > ip->size) {
801021e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801021ec:	3b 70 58             	cmp    0x58(%eax),%esi
801021ef:	77 37                	ja     80102228 <writei+0x108>
        ip->size = off;
        iupdate(ip);
    }
    return n;
801021f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
801021f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021f7:	5b                   	pop    %ebx
801021f8:	5e                   	pop    %esi
801021f9:	5f                   	pop    %edi
801021fa:	5d                   	pop    %ebp
801021fb:	c3                   	ret    
801021fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write) {
80102200:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102204:	66 83 f8 09          	cmp    $0x9,%ax
80102208:	77 36                	ja     80102240 <writei+0x120>
8010220a:	8b 04 c5 44 31 11 80 	mov    -0x7feecebc(,%eax,8),%eax
80102211:	85 c0                	test   %eax,%eax
80102213:	74 2b                	je     80102240 <writei+0x120>
        return devsw[ip->major].write(ip, src, n);
80102215:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102218:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010221b:	5b                   	pop    %ebx
8010221c:	5e                   	pop    %esi
8010221d:	5f                   	pop    %edi
8010221e:	5d                   	pop    %ebp
        return devsw[ip->major].write(ip, src, n);
8010221f:	ff e0                	jmp    *%eax
80102221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        ip->size = off;
80102228:	8b 45 d8             	mov    -0x28(%ebp),%eax
        iupdate(ip);
8010222b:	83 ec 0c             	sub    $0xc,%esp
        ip->size = off;
8010222e:	89 70 58             	mov    %esi,0x58(%eax)
        iupdate(ip);
80102231:	50                   	push   %eax
80102232:	e8 59 fa ff ff       	call   80101c90 <iupdate>
80102237:	83 c4 10             	add    $0x10,%esp
8010223a:	eb b5                	jmp    801021f1 <writei+0xd1>
8010223c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            return -1;
80102240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102245:	eb ad                	jmp    801021f4 <writei+0xd4>
80102247:	89 f6                	mov    %esi,%esi
80102249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102250 <namecmp>:


// Directories

int namecmp(const char *s, const char *t) {
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	83 ec 0c             	sub    $0xc,%esp
    return strncmp(s, t, DIRSIZ);
80102256:	6a 0e                	push   $0xe
80102258:	ff 75 0c             	pushl  0xc(%ebp)
8010225b:	ff 75 08             	pushl  0x8(%ebp)
8010225e:	e8 fd 29 00 00       	call   80104c60 <strncmp>
}
80102263:	c9                   	leave  
80102264:	c3                   	ret    
80102265:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102270 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode* dirlookup(struct inode *dp, char *name, uint *poff) {
80102270:	55                   	push   %ebp
80102271:	89 e5                	mov    %esp,%ebp
80102273:	57                   	push   %edi
80102274:	56                   	push   %esi
80102275:	53                   	push   %ebx
80102276:	83 ec 1c             	sub    $0x1c,%esp
80102279:	8b 5d 08             	mov    0x8(%ebp),%ebx
    uint off, inum;
    struct dirent de;

    if (dp->type != T_DIR) {
8010227c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102281:	0f 85 85 00 00 00    	jne    8010230c <dirlookup+0x9c>
        panic("dirlookup not DIR");
    }

    for (off = 0; off < dp->size; off += sizeof(de)) {
80102287:	8b 53 58             	mov    0x58(%ebx),%edx
8010228a:	31 ff                	xor    %edi,%edi
8010228c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010228f:	85 d2                	test   %edx,%edx
80102291:	74 3e                	je     801022d1 <dirlookup+0x61>
80102293:	90                   	nop
80102294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80102298:	6a 10                	push   $0x10
8010229a:	57                   	push   %edi
8010229b:	56                   	push   %esi
8010229c:	53                   	push   %ebx
8010229d:	e8 7e fd ff ff       	call   80102020 <readi>
801022a2:	83 c4 10             	add    $0x10,%esp
801022a5:	83 f8 10             	cmp    $0x10,%eax
801022a8:	75 55                	jne    801022ff <dirlookup+0x8f>
            panic("dirlookup read");
        }
        if (de.inum == 0) {
801022aa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801022af:	74 18                	je     801022c9 <dirlookup+0x59>
    return strncmp(s, t, DIRSIZ);
801022b1:	8d 45 da             	lea    -0x26(%ebp),%eax
801022b4:	83 ec 04             	sub    $0x4,%esp
801022b7:	6a 0e                	push   $0xe
801022b9:	50                   	push   %eax
801022ba:	ff 75 0c             	pushl  0xc(%ebp)
801022bd:	e8 9e 29 00 00       	call   80104c60 <strncmp>
            continue;
        }
        if (namecmp(name, de.name) == 0) {
801022c2:	83 c4 10             	add    $0x10,%esp
801022c5:	85 c0                	test   %eax,%eax
801022c7:	74 17                	je     801022e0 <dirlookup+0x70>
    for (off = 0; off < dp->size; off += sizeof(de)) {
801022c9:	83 c7 10             	add    $0x10,%edi
801022cc:	3b 7b 58             	cmp    0x58(%ebx),%edi
801022cf:	72 c7                	jb     80102298 <dirlookup+0x28>
            return iget(dp->dev, inum);
        }
    }

    return 0;
}
801022d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801022d4:	31 c0                	xor    %eax,%eax
}
801022d6:	5b                   	pop    %ebx
801022d7:	5e                   	pop    %esi
801022d8:	5f                   	pop    %edi
801022d9:	5d                   	pop    %ebp
801022da:	c3                   	ret    
801022db:	90                   	nop
801022dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            if (poff) {
801022e0:	8b 45 10             	mov    0x10(%ebp),%eax
801022e3:	85 c0                	test   %eax,%eax
801022e5:	74 05                	je     801022ec <dirlookup+0x7c>
                *poff = off;
801022e7:	8b 45 10             	mov    0x10(%ebp),%eax
801022ea:	89 38                	mov    %edi,(%eax)
            inum = de.inum;
801022ec:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
            return iget(dp->dev, inum);
801022f0:	8b 03                	mov    (%ebx),%eax
801022f2:	e8 59 f6 ff ff       	call   80101950 <iget>
}
801022f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022fa:	5b                   	pop    %ebx
801022fb:	5e                   	pop    %esi
801022fc:	5f                   	pop    %edi
801022fd:	5d                   	pop    %ebp
801022fe:	c3                   	ret    
            panic("dirlookup read");
801022ff:	83 ec 0c             	sub    $0xc,%esp
80102302:	68 39 78 10 80       	push   $0x80107839
80102307:	e8 74 e1 ff ff       	call   80100480 <panic>
        panic("dirlookup not DIR");
8010230c:	83 ec 0c             	sub    $0xc,%esp
8010230f:	68 27 78 10 80       	push   $0x80107827
80102314:	e8 67 e1 ff ff       	call   80100480 <panic>
80102319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102320 <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode* namex(char *path, int nameiparent, char *name)                     {
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	57                   	push   %edi
80102324:	56                   	push   %esi
80102325:	53                   	push   %ebx
80102326:	89 cf                	mov    %ecx,%edi
80102328:	89 c3                	mov    %eax,%ebx
8010232a:	83 ec 1c             	sub    $0x1c,%esp
    struct inode *ip, *next;

    if (*path == '/') {
8010232d:	80 38 2f             	cmpb   $0x2f,(%eax)
static struct inode* namex(char *path, int nameiparent, char *name)                     {
80102330:	89 55 e0             	mov    %edx,-0x20(%ebp)
    if (*path == '/') {
80102333:	0f 84 67 01 00 00    	je     801024a0 <namex+0x180>
        ip = iget(ROOTDEV, ROOTINO);
    }
    else {
        ip = idup(myproc()->cwd);
80102339:	e8 92 1b 00 00       	call   80103ed0 <myproc>
    acquire(&icache.lock);
8010233e:	83 ec 0c             	sub    $0xc,%esp
        ip = idup(myproc()->cwd);
80102341:	8b 70 68             	mov    0x68(%eax),%esi
    acquire(&icache.lock);
80102344:	68 c0 31 11 80       	push   $0x801131c0
80102349:	e8 e2 26 00 00       	call   80104a30 <acquire>
    ip->ref++;
8010234e:	83 46 08 01          	addl   $0x1,0x8(%esi)
    release(&icache.lock);
80102352:	c7 04 24 c0 31 11 80 	movl   $0x801131c0,(%esp)
80102359:	e8 92 27 00 00       	call   80104af0 <release>
8010235e:	83 c4 10             	add    $0x10,%esp
80102361:	eb 08                	jmp    8010236b <namex+0x4b>
80102363:	90                   	nop
80102364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        path++;
80102368:	83 c3 01             	add    $0x1,%ebx
    while (*path == '/') {
8010236b:	0f b6 03             	movzbl (%ebx),%eax
8010236e:	3c 2f                	cmp    $0x2f,%al
80102370:	74 f6                	je     80102368 <namex+0x48>
    if (*path == 0) {
80102372:	84 c0                	test   %al,%al
80102374:	0f 84 ee 00 00 00    	je     80102468 <namex+0x148>
    while (*path != '/' && *path != 0) {
8010237a:	0f b6 03             	movzbl (%ebx),%eax
8010237d:	3c 2f                	cmp    $0x2f,%al
8010237f:	0f 84 b3 00 00 00    	je     80102438 <namex+0x118>
80102385:	84 c0                	test   %al,%al
80102387:	89 da                	mov    %ebx,%edx
80102389:	75 09                	jne    80102394 <namex+0x74>
8010238b:	e9 a8 00 00 00       	jmp    80102438 <namex+0x118>
80102390:	84 c0                	test   %al,%al
80102392:	74 0a                	je     8010239e <namex+0x7e>
        path++;
80102394:	83 c2 01             	add    $0x1,%edx
    while (*path != '/' && *path != 0) {
80102397:	0f b6 02             	movzbl (%edx),%eax
8010239a:	3c 2f                	cmp    $0x2f,%al
8010239c:	75 f2                	jne    80102390 <namex+0x70>
8010239e:	89 d1                	mov    %edx,%ecx
801023a0:	29 d9                	sub    %ebx,%ecx
    if (len >= DIRSIZ) {
801023a2:	83 f9 0d             	cmp    $0xd,%ecx
801023a5:	0f 8e 91 00 00 00    	jle    8010243c <namex+0x11c>
        memmove(name, s, DIRSIZ);
801023ab:	83 ec 04             	sub    $0x4,%esp
801023ae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801023b1:	6a 0e                	push   $0xe
801023b3:	53                   	push   %ebx
801023b4:	57                   	push   %edi
801023b5:	e8 36 28 00 00       	call   80104bf0 <memmove>
        path++;
801023ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        memmove(name, s, DIRSIZ);
801023bd:	83 c4 10             	add    $0x10,%esp
        path++;
801023c0:	89 d3                	mov    %edx,%ebx
    while (*path == '/') {
801023c2:	80 3a 2f             	cmpb   $0x2f,(%edx)
801023c5:	75 11                	jne    801023d8 <namex+0xb8>
801023c7:	89 f6                	mov    %esi,%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        path++;
801023d0:	83 c3 01             	add    $0x1,%ebx
    while (*path == '/') {
801023d3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801023d6:	74 f8                	je     801023d0 <namex+0xb0>
    }

    while ((path = skipelem(path, name)) != 0) {
        ilock(ip);
801023d8:	83 ec 0c             	sub    $0xc,%esp
801023db:	56                   	push   %esi
801023dc:	e8 5f f9 ff ff       	call   80101d40 <ilock>
        if (ip->type != T_DIR) {
801023e1:	83 c4 10             	add    $0x10,%esp
801023e4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801023e9:	0f 85 91 00 00 00    	jne    80102480 <namex+0x160>
            iunlockput(ip);
            return 0;
        }
        if (nameiparent && *path == '\0') {
801023ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
801023f2:	85 d2                	test   %edx,%edx
801023f4:	74 09                	je     801023ff <namex+0xdf>
801023f6:	80 3b 00             	cmpb   $0x0,(%ebx)
801023f9:	0f 84 b7 00 00 00    	je     801024b6 <namex+0x196>
            // Stop one level early.
            iunlock(ip);
            return ip;
        }
        if ((next = dirlookup(ip, name, 0)) == 0) {
801023ff:	83 ec 04             	sub    $0x4,%esp
80102402:	6a 00                	push   $0x0
80102404:	57                   	push   %edi
80102405:	56                   	push   %esi
80102406:	e8 65 fe ff ff       	call   80102270 <dirlookup>
8010240b:	83 c4 10             	add    $0x10,%esp
8010240e:	85 c0                	test   %eax,%eax
80102410:	74 6e                	je     80102480 <namex+0x160>
    iunlock(ip);
80102412:	83 ec 0c             	sub    $0xc,%esp
80102415:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102418:	56                   	push   %esi
80102419:	e8 02 fa ff ff       	call   80101e20 <iunlock>
    iput(ip);
8010241e:	89 34 24             	mov    %esi,(%esp)
80102421:	e8 4a fa ff ff       	call   80101e70 <iput>
80102426:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102429:	83 c4 10             	add    $0x10,%esp
8010242c:	89 c6                	mov    %eax,%esi
8010242e:	e9 38 ff ff ff       	jmp    8010236b <namex+0x4b>
80102433:	90                   	nop
80102434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while (*path != '/' && *path != 0) {
80102438:	89 da                	mov    %ebx,%edx
8010243a:	31 c9                	xor    %ecx,%ecx
        memmove(name, s, len);
8010243c:	83 ec 04             	sub    $0x4,%esp
8010243f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102442:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102445:	51                   	push   %ecx
80102446:	53                   	push   %ebx
80102447:	57                   	push   %edi
80102448:	e8 a3 27 00 00       	call   80104bf0 <memmove>
        name[len] = 0;
8010244d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102450:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102453:	83 c4 10             	add    $0x10,%esp
80102456:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
8010245a:	89 d3                	mov    %edx,%ebx
8010245c:	e9 61 ff ff ff       	jmp    801023c2 <namex+0xa2>
80102461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            return 0;
        }
        iunlockput(ip);
        ip = next;
    }
    if (nameiparent) {
80102468:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010246b:	85 c0                	test   %eax,%eax
8010246d:	75 5d                	jne    801024cc <namex+0x1ac>
        iput(ip);
        return 0;
    }
    return ip;
}
8010246f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102472:	89 f0                	mov    %esi,%eax
80102474:	5b                   	pop    %ebx
80102475:	5e                   	pop    %esi
80102476:	5f                   	pop    %edi
80102477:	5d                   	pop    %ebp
80102478:	c3                   	ret    
80102479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlock(ip);
80102480:	83 ec 0c             	sub    $0xc,%esp
80102483:	56                   	push   %esi
80102484:	e8 97 f9 ff ff       	call   80101e20 <iunlock>
    iput(ip);
80102489:	89 34 24             	mov    %esi,(%esp)
            return 0;
8010248c:	31 f6                	xor    %esi,%esi
    iput(ip);
8010248e:	e8 dd f9 ff ff       	call   80101e70 <iput>
            return 0;
80102493:	83 c4 10             	add    $0x10,%esp
}
80102496:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102499:	89 f0                	mov    %esi,%eax
8010249b:	5b                   	pop    %ebx
8010249c:	5e                   	pop    %esi
8010249d:	5f                   	pop    %edi
8010249e:	5d                   	pop    %ebp
8010249f:	c3                   	ret    
        ip = iget(ROOTDEV, ROOTINO);
801024a0:	ba 01 00 00 00       	mov    $0x1,%edx
801024a5:	b8 01 00 00 00       	mov    $0x1,%eax
801024aa:	e8 a1 f4 ff ff       	call   80101950 <iget>
801024af:	89 c6                	mov    %eax,%esi
801024b1:	e9 b5 fe ff ff       	jmp    8010236b <namex+0x4b>
            iunlock(ip);
801024b6:	83 ec 0c             	sub    $0xc,%esp
801024b9:	56                   	push   %esi
801024ba:	e8 61 f9 ff ff       	call   80101e20 <iunlock>
            return ip;
801024bf:	83 c4 10             	add    $0x10,%esp
}
801024c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024c5:	89 f0                	mov    %esi,%eax
801024c7:	5b                   	pop    %ebx
801024c8:	5e                   	pop    %esi
801024c9:	5f                   	pop    %edi
801024ca:	5d                   	pop    %ebp
801024cb:	c3                   	ret    
        iput(ip);
801024cc:	83 ec 0c             	sub    $0xc,%esp
801024cf:	56                   	push   %esi
        return 0;
801024d0:	31 f6                	xor    %esi,%esi
        iput(ip);
801024d2:	e8 99 f9 ff ff       	call   80101e70 <iput>
        return 0;
801024d7:	83 c4 10             	add    $0x10,%esp
801024da:	eb 93                	jmp    8010246f <namex+0x14f>
801024dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024e0 <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	57                   	push   %edi
801024e4:	56                   	push   %esi
801024e5:	53                   	push   %ebx
801024e6:	83 ec 20             	sub    $0x20,%esp
801024e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if ((ip = dirlookup(dp, name, 0)) != 0) {
801024ec:	6a 00                	push   $0x0
801024ee:	ff 75 0c             	pushl  0xc(%ebp)
801024f1:	53                   	push   %ebx
801024f2:	e8 79 fd ff ff       	call   80102270 <dirlookup>
801024f7:	83 c4 10             	add    $0x10,%esp
801024fa:	85 c0                	test   %eax,%eax
801024fc:	75 67                	jne    80102565 <dirlink+0x85>
    for (off = 0; off < dp->size; off += sizeof(de)) {
801024fe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102501:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102504:	85 ff                	test   %edi,%edi
80102506:	74 29                	je     80102531 <dirlink+0x51>
80102508:	31 ff                	xor    %edi,%edi
8010250a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010250d:	eb 09                	jmp    80102518 <dirlink+0x38>
8010250f:	90                   	nop
80102510:	83 c7 10             	add    $0x10,%edi
80102513:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102516:	73 19                	jae    80102531 <dirlink+0x51>
        if (readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80102518:	6a 10                	push   $0x10
8010251a:	57                   	push   %edi
8010251b:	56                   	push   %esi
8010251c:	53                   	push   %ebx
8010251d:	e8 fe fa ff ff       	call   80102020 <readi>
80102522:	83 c4 10             	add    $0x10,%esp
80102525:	83 f8 10             	cmp    $0x10,%eax
80102528:	75 4e                	jne    80102578 <dirlink+0x98>
        if (de.inum == 0) {
8010252a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010252f:	75 df                	jne    80102510 <dirlink+0x30>
    strncpy(de.name, name, DIRSIZ);
80102531:	8d 45 da             	lea    -0x26(%ebp),%eax
80102534:	83 ec 04             	sub    $0x4,%esp
80102537:	6a 0e                	push   $0xe
80102539:	ff 75 0c             	pushl  0xc(%ebp)
8010253c:	50                   	push   %eax
8010253d:	e8 7e 27 00 00       	call   80104cc0 <strncpy>
    de.inum = inum;
80102542:	8b 45 10             	mov    0x10(%ebp),%eax
    if (writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80102545:	6a 10                	push   $0x10
80102547:	57                   	push   %edi
80102548:	56                   	push   %esi
80102549:	53                   	push   %ebx
    de.inum = inum;
8010254a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    if (writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
8010254e:	e8 cd fb ff ff       	call   80102120 <writei>
80102553:	83 c4 20             	add    $0x20,%esp
80102556:	83 f8 10             	cmp    $0x10,%eax
80102559:	75 2a                	jne    80102585 <dirlink+0xa5>
    return 0;
8010255b:	31 c0                	xor    %eax,%eax
}
8010255d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102560:	5b                   	pop    %ebx
80102561:	5e                   	pop    %esi
80102562:	5f                   	pop    %edi
80102563:	5d                   	pop    %ebp
80102564:	c3                   	ret    
        iput(ip);
80102565:	83 ec 0c             	sub    $0xc,%esp
80102568:	50                   	push   %eax
80102569:	e8 02 f9 ff ff       	call   80101e70 <iput>
        return -1;
8010256e:	83 c4 10             	add    $0x10,%esp
80102571:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102576:	eb e5                	jmp    8010255d <dirlink+0x7d>
            panic("dirlink read");
80102578:	83 ec 0c             	sub    $0xc,%esp
8010257b:	68 48 78 10 80       	push   $0x80107848
80102580:	e8 fb de ff ff       	call   80100480 <panic>
        panic("dirlink");
80102585:	83 ec 0c             	sub    $0xc,%esp
80102588:	68 52 7e 10 80       	push   $0x80107e52
8010258d:	e8 ee de ff ff       	call   80100480 <panic>
80102592:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025a0 <namei>:

struct inode* namei(char *path) {
801025a0:	55                   	push   %ebp
    char name[DIRSIZ];
    return namex(path, 0, name);
801025a1:	31 d2                	xor    %edx,%edx
struct inode* namei(char *path) {
801025a3:	89 e5                	mov    %esp,%ebp
801025a5:	83 ec 18             	sub    $0x18,%esp
    return namex(path, 0, name);
801025a8:	8b 45 08             	mov    0x8(%ebp),%eax
801025ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801025ae:	e8 6d fd ff ff       	call   80102320 <namex>
}
801025b3:	c9                   	leave  
801025b4:	c3                   	ret    
801025b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025c0 <nameiparent>:

struct inode*nameiparent(char *path, char *name) {
801025c0:	55                   	push   %ebp
    return namex(path, 1, name);
801025c1:	ba 01 00 00 00       	mov    $0x1,%edx
struct inode*nameiparent(char *path, char *name) {
801025c6:	89 e5                	mov    %esp,%ebp
    return namex(path, 1, name);
801025c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801025ce:	5d                   	pop    %ebp
    return namex(path, 1, name);
801025cf:	e9 4c fd ff ff       	jmp    80102320 <namex>
801025d4:	66 90                	xchg   %ax,%ax
801025d6:	66 90                	xchg   %ax,%ax
801025d8:	66 90                	xchg   %ax,%ax
801025da:	66 90                	xchg   %ax,%ax
801025dc:	66 90                	xchg   %ax,%ax
801025de:	66 90                	xchg   %ax,%ax

801025e0 <idestart>:
    // Switch back to disk 0.
    outb(0x1f6, 0xe0 | (0 << 4));
}

// Start the request for b.  Caller must hold idelock.
static void idestart(struct buf *b) {
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	57                   	push   %edi
801025e4:	56                   	push   %esi
801025e5:	53                   	push   %ebx
801025e6:	83 ec 0c             	sub    $0xc,%esp
    if (b == 0) {
801025e9:	85 c0                	test   %eax,%eax
801025eb:	0f 84 b4 00 00 00    	je     801026a5 <idestart+0xc5>
        panic("idestart");
    }
    if (b->blockno >= FSSIZE) {
801025f1:	8b 58 08             	mov    0x8(%eax),%ebx
801025f4:	89 c6                	mov    %eax,%esi
801025f6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801025fc:	0f 87 96 00 00 00    	ja     80102698 <idestart+0xb8>
80102602:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102607:	89 f6                	mov    %esi,%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102610:	89 ca                	mov    %ecx,%edx
80102612:	ec                   	in     (%dx),%al
    while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY) {
80102613:	83 e0 c0             	and    $0xffffffc0,%eax
80102616:	3c 40                	cmp    $0x40,%al
80102618:	75 f6                	jne    80102610 <idestart+0x30>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
8010261a:	31 ff                	xor    %edi,%edi
8010261c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102621:	89 f8                	mov    %edi,%eax
80102623:	ee                   	out    %al,(%dx)
80102624:	b8 01 00 00 00       	mov    $0x1,%eax
80102629:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010262e:	ee                   	out    %al,(%dx)
8010262f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102634:	89 d8                	mov    %ebx,%eax
80102636:	ee                   	out    %al,(%dx)

    idewait(0);
    outb(0x3f6, 0);  // generate interrupt
    outb(0x1f2, sector_per_block);  // number of sectors
    outb(0x1f3, sector & 0xff);
    outb(0x1f4, (sector >> 8) & 0xff);
80102637:	89 d8                	mov    %ebx,%eax
80102639:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010263e:	c1 f8 08             	sar    $0x8,%eax
80102641:	ee                   	out    %al,(%dx)
80102642:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102647:	89 f8                	mov    %edi,%eax
80102649:	ee                   	out    %al,(%dx)
    outb(0x1f5, (sector >> 16) & 0xff);
    outb(0x1f6, 0xe0 | ((b->dev & 1) << 4) | ((sector >> 24) & 0x0f));
8010264a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010264e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102653:	c1 e0 04             	shl    $0x4,%eax
80102656:	83 e0 10             	and    $0x10,%eax
80102659:	83 c8 e0             	or     $0xffffffe0,%eax
8010265c:	ee                   	out    %al,(%dx)
    if (b->flags & B_DIRTY) {
8010265d:	f6 06 04             	testb  $0x4,(%esi)
80102660:	75 16                	jne    80102678 <idestart+0x98>
80102662:	b8 20 00 00 00       	mov    $0x20,%eax
80102667:	89 ca                	mov    %ecx,%edx
80102669:	ee                   	out    %al,(%dx)
        outsl(0x1f0, b->data, BSIZE / 4);
    }
    else {
        outb(0x1f7, read_cmd);
    }
}
8010266a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010266d:	5b                   	pop    %ebx
8010266e:	5e                   	pop    %esi
8010266f:	5f                   	pop    %edi
80102670:	5d                   	pop    %ebp
80102671:	c3                   	ret    
80102672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102678:	b8 30 00 00 00       	mov    $0x30,%eax
8010267d:	89 ca                	mov    %ecx,%edx
8010267f:	ee                   	out    %al,(%dx)
    asm volatile ("cld; rep outsl" :
80102680:	b9 80 00 00 00       	mov    $0x80,%ecx
        outsl(0x1f0, b->data, BSIZE / 4);
80102685:	83 c6 5c             	add    $0x5c,%esi
80102688:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010268d:	fc                   	cld    
8010268e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102690:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102693:	5b                   	pop    %ebx
80102694:	5e                   	pop    %esi
80102695:	5f                   	pop    %edi
80102696:	5d                   	pop    %ebp
80102697:	c3                   	ret    
        panic("incorrect blockno");
80102698:	83 ec 0c             	sub    $0xc,%esp
8010269b:	68 b4 78 10 80       	push   $0x801078b4
801026a0:	e8 db dd ff ff       	call   80100480 <panic>
        panic("idestart");
801026a5:	83 ec 0c             	sub    $0xc,%esp
801026a8:	68 ab 78 10 80       	push   $0x801078ab
801026ad:	e8 ce dd ff ff       	call   80100480 <panic>
801026b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026c0 <ideinit>:
void ideinit(void) {
801026c0:	55                   	push   %ebp
801026c1:	89 e5                	mov    %esp,%ebp
801026c3:	83 ec 10             	sub    $0x10,%esp
    initlock(&idelock, "ide");
801026c6:	68 c6 78 10 80       	push   $0x801078c6
801026cb:	68 80 c5 10 80       	push   $0x8010c580
801026d0:	e8 1b 22 00 00       	call   801048f0 <initlock>
    ioapicenable(IRQ_IDE, ncpu - 1);
801026d5:	58                   	pop    %eax
801026d6:	a1 e0 54 11 80       	mov    0x801154e0,%eax
801026db:	5a                   	pop    %edx
801026dc:	83 e8 01             	sub    $0x1,%eax
801026df:	50                   	push   %eax
801026e0:	6a 0e                	push   $0xe
801026e2:	e8 a9 02 00 00       	call   80102990 <ioapicenable>
801026e7:	83 c4 10             	add    $0x10,%esp
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801026ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026ef:	90                   	nop
801026f0:	ec                   	in     (%dx),%al
    while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY) {
801026f1:	83 e0 c0             	and    $0xffffffc0,%eax
801026f4:	3c 40                	cmp    $0x40,%al
801026f6:	75 f8                	jne    801026f0 <ideinit+0x30>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801026f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801026fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102702:	ee                   	out    %al,(%dx)
80102703:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102708:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010270d:	eb 06                	jmp    80102715 <ideinit+0x55>
8010270f:	90                   	nop
    for (i = 0; i < 1000; i++) {
80102710:	83 e9 01             	sub    $0x1,%ecx
80102713:	74 0f                	je     80102724 <ideinit+0x64>
80102715:	ec                   	in     (%dx),%al
        if (inb(0x1f7) != 0) {
80102716:	84 c0                	test   %al,%al
80102718:	74 f6                	je     80102710 <ideinit+0x50>
            havedisk1 = 1;
8010271a:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
80102721:	00 00 00 
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102724:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102729:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010272e:	ee                   	out    %al,(%dx)
}
8010272f:	c9                   	leave  
80102730:	c3                   	ret    
80102731:	eb 0d                	jmp    80102740 <ideintr>
80102733:	90                   	nop
80102734:	90                   	nop
80102735:	90                   	nop
80102736:	90                   	nop
80102737:	90                   	nop
80102738:	90                   	nop
80102739:	90                   	nop
8010273a:	90                   	nop
8010273b:	90                   	nop
8010273c:	90                   	nop
8010273d:	90                   	nop
8010273e:	90                   	nop
8010273f:	90                   	nop

80102740 <ideintr>:

// Interrupt handler.
void ideintr(void) {
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	57                   	push   %edi
80102744:	56                   	push   %esi
80102745:	53                   	push   %ebx
80102746:	83 ec 18             	sub    $0x18,%esp
    struct buf *b;

    // First queued buffer is the active request.
    acquire(&idelock);
80102749:	68 80 c5 10 80       	push   $0x8010c580
8010274e:	e8 dd 22 00 00       	call   80104a30 <acquire>

    if ((b = idequeue) == 0) {
80102753:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
80102759:	83 c4 10             	add    $0x10,%esp
8010275c:	85 db                	test   %ebx,%ebx
8010275e:	74 67                	je     801027c7 <ideintr+0x87>
        release(&idelock);
        return;
    }
    idequeue = b->qnext;
80102760:	8b 43 58             	mov    0x58(%ebx),%eax
80102763:	a3 64 c5 10 80       	mov    %eax,0x8010c564

    // Read data if needed.
    if (!(b->flags & B_DIRTY) && idewait(1) >= 0) {
80102768:	8b 3b                	mov    (%ebx),%edi
8010276a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102770:	75 31                	jne    801027a3 <ideintr+0x63>
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102772:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102777:	89 f6                	mov    %esi,%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102780:	ec                   	in     (%dx),%al
    while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY) {
80102781:	89 c6                	mov    %eax,%esi
80102783:	83 e6 c0             	and    $0xffffffc0,%esi
80102786:	89 f1                	mov    %esi,%ecx
80102788:	80 f9 40             	cmp    $0x40,%cl
8010278b:	75 f3                	jne    80102780 <ideintr+0x40>
    if (checkerr && (r & (IDE_DF | IDE_ERR)) != 0) {
8010278d:	a8 21                	test   $0x21,%al
8010278f:	75 12                	jne    801027a3 <ideintr+0x63>
        insl(0x1f0, b->data, BSIZE / 4);
80102791:	8d 7b 5c             	lea    0x5c(%ebx),%edi
    asm volatile ("cld; rep insl" :
80102794:	b9 80 00 00 00       	mov    $0x80,%ecx
80102799:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010279e:	fc                   	cld    
8010279f:	f3 6d                	rep insl (%dx),%es:(%edi)
801027a1:	8b 3b                	mov    (%ebx),%edi
    }

    // Wake process waiting for this buf.
    b->flags |= B_VALID;
    b->flags &= ~B_DIRTY;
801027a3:	83 e7 fb             	and    $0xfffffffb,%edi
    wakeup(b);
801027a6:	83 ec 0c             	sub    $0xc,%esp
    b->flags &= ~B_DIRTY;
801027a9:	89 f9                	mov    %edi,%ecx
801027ab:	83 c9 02             	or     $0x2,%ecx
801027ae:	89 0b                	mov    %ecx,(%ebx)
    wakeup(b);
801027b0:	53                   	push   %ebx
801027b1:	e8 6a 1e 00 00       	call   80104620 <wakeup>

    // Start disk on next buf in queue.
    if (idequeue != 0) {
801027b6:	a1 64 c5 10 80       	mov    0x8010c564,%eax
801027bb:	83 c4 10             	add    $0x10,%esp
801027be:	85 c0                	test   %eax,%eax
801027c0:	74 05                	je     801027c7 <ideintr+0x87>
        idestart(idequeue);
801027c2:	e8 19 fe ff ff       	call   801025e0 <idestart>
        release(&idelock);
801027c7:	83 ec 0c             	sub    $0xc,%esp
801027ca:	68 80 c5 10 80       	push   $0x8010c580
801027cf:	e8 1c 23 00 00       	call   80104af0 <release>
    }

    release(&idelock);
}
801027d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027d7:	5b                   	pop    %ebx
801027d8:	5e                   	pop    %esi
801027d9:	5f                   	pop    %edi
801027da:	5d                   	pop    %ebp
801027db:	c3                   	ret    
801027dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027e0 <iderw>:


// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void iderw(struct buf *b) {
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	53                   	push   %ebx
801027e4:	83 ec 10             	sub    $0x10,%esp
801027e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct buf **pp;

    if (!holdingsleep(&b->lock)) {
801027ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801027ed:	50                   	push   %eax
801027ee:	e8 ad 20 00 00       	call   801048a0 <holdingsleep>
801027f3:	83 c4 10             	add    $0x10,%esp
801027f6:	85 c0                	test   %eax,%eax
801027f8:	0f 84 c6 00 00 00    	je     801028c4 <iderw+0xe4>
        panic("iderw: buf not locked");
    }
    if ((b->flags & (B_VALID | B_DIRTY)) == B_VALID) {
801027fe:	8b 03                	mov    (%ebx),%eax
80102800:	83 e0 06             	and    $0x6,%eax
80102803:	83 f8 02             	cmp    $0x2,%eax
80102806:	0f 84 ab 00 00 00    	je     801028b7 <iderw+0xd7>
        panic("iderw: nothing to do");
    }
    if (b->dev != 0 && !havedisk1) {
8010280c:	8b 53 04             	mov    0x4(%ebx),%edx
8010280f:	85 d2                	test   %edx,%edx
80102811:	74 0d                	je     80102820 <iderw+0x40>
80102813:	a1 60 c5 10 80       	mov    0x8010c560,%eax
80102818:	85 c0                	test   %eax,%eax
8010281a:	0f 84 b1 00 00 00    	je     801028d1 <iderw+0xf1>
        panic("iderw: ide disk 1 not present");
    }

    acquire(&idelock);  //DOC:acquire-lock
80102820:	83 ec 0c             	sub    $0xc,%esp
80102823:	68 80 c5 10 80       	push   $0x8010c580
80102828:	e8 03 22 00 00       	call   80104a30 <acquire>

    // Append b to idequeue.
    b->qnext = 0;
    for (pp = &idequeue; *pp; pp = &(*pp)->qnext) { //DOC:insert-queue
8010282d:	8b 15 64 c5 10 80    	mov    0x8010c564,%edx
80102833:	83 c4 10             	add    $0x10,%esp
    b->qnext = 0;
80102836:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
    for (pp = &idequeue; *pp; pp = &(*pp)->qnext) { //DOC:insert-queue
8010283d:	85 d2                	test   %edx,%edx
8010283f:	75 09                	jne    8010284a <iderw+0x6a>
80102841:	eb 6d                	jmp    801028b0 <iderw+0xd0>
80102843:	90                   	nop
80102844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102848:	89 c2                	mov    %eax,%edx
8010284a:	8b 42 58             	mov    0x58(%edx),%eax
8010284d:	85 c0                	test   %eax,%eax
8010284f:	75 f7                	jne    80102848 <iderw+0x68>
80102851:	83 c2 58             	add    $0x58,%edx
        ;
    }
    *pp = b;
80102854:	89 1a                	mov    %ebx,(%edx)

    // Start disk if necessary.
    if (idequeue == b) {
80102856:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
8010285c:	74 42                	je     801028a0 <iderw+0xc0>
        idestart(b);
    }

    // Wait for request to finish.
    while ((b->flags & (B_VALID | B_DIRTY)) != B_VALID) {
8010285e:	8b 03                	mov    (%ebx),%eax
80102860:	83 e0 06             	and    $0x6,%eax
80102863:	83 f8 02             	cmp    $0x2,%eax
80102866:	74 23                	je     8010288b <iderw+0xab>
80102868:	90                   	nop
80102869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        sleep(b, &idelock);
80102870:	83 ec 08             	sub    $0x8,%esp
80102873:	68 80 c5 10 80       	push   $0x8010c580
80102878:	53                   	push   %ebx
80102879:	e8 f2 1b 00 00       	call   80104470 <sleep>
    while ((b->flags & (B_VALID | B_DIRTY)) != B_VALID) {
8010287e:	8b 03                	mov    (%ebx),%eax
80102880:	83 c4 10             	add    $0x10,%esp
80102883:	83 e0 06             	and    $0x6,%eax
80102886:	83 f8 02             	cmp    $0x2,%eax
80102889:	75 e5                	jne    80102870 <iderw+0x90>
    }

    release(&idelock);
8010288b:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102895:	c9                   	leave  
    release(&idelock);
80102896:	e9 55 22 00 00       	jmp    80104af0 <release>
8010289b:	90                   	nop
8010289c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        idestart(b);
801028a0:	89 d8                	mov    %ebx,%eax
801028a2:	e8 39 fd ff ff       	call   801025e0 <idestart>
801028a7:	eb b5                	jmp    8010285e <iderw+0x7e>
801028a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (pp = &idequeue; *pp; pp = &(*pp)->qnext) { //DOC:insert-queue
801028b0:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
801028b5:	eb 9d                	jmp    80102854 <iderw+0x74>
        panic("iderw: nothing to do");
801028b7:	83 ec 0c             	sub    $0xc,%esp
801028ba:	68 e0 78 10 80       	push   $0x801078e0
801028bf:	e8 bc db ff ff       	call   80100480 <panic>
        panic("iderw: buf not locked");
801028c4:	83 ec 0c             	sub    $0xc,%esp
801028c7:	68 ca 78 10 80       	push   $0x801078ca
801028cc:	e8 af db ff ff       	call   80100480 <panic>
        panic("iderw: ide disk 1 not present");
801028d1:	83 ec 0c             	sub    $0xc,%esp
801028d4:	68 f5 78 10 80       	push   $0x801078f5
801028d9:	e8 a2 db ff ff       	call   80100480 <panic>
801028de:	66 90                	xchg   %ax,%ax

801028e0 <ioapicinit>:
static void ioapicwrite(int reg, uint data) {
    ioapic->reg = reg;
    ioapic->data = data;
}

void ioapicinit(void) {
801028e0:	55                   	push   %ebp
    int i, id, maxintr;

    ioapic = (volatile struct ioapic*)IOAPIC;
801028e1:	c7 05 14 4e 11 80 00 	movl   $0xfec00000,0x80114e14
801028e8:	00 c0 fe 
void ioapicinit(void) {
801028eb:	89 e5                	mov    %esp,%ebp
801028ed:	56                   	push   %esi
801028ee:	53                   	push   %ebx
    ioapic->reg = reg;
801028ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801028f6:	00 00 00 
    return ioapic->data;
801028f9:	a1 14 4e 11 80       	mov    0x80114e14,%eax
801028fe:	8b 58 10             	mov    0x10(%eax),%ebx
    ioapic->reg = reg;
80102901:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    return ioapic->data;
80102907:	8b 0d 14 4e 11 80    	mov    0x80114e14,%ecx
    maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
    id = ioapicread(REG_ID) >> 24;
    if (id != ioapicid) {
8010290d:	0f b6 15 40 4f 11 80 	movzbl 0x80114f40,%edx
    maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102914:	c1 eb 10             	shr    $0x10,%ebx
    return ioapic->data;
80102917:	8b 41 10             	mov    0x10(%ecx),%eax
    maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010291a:	0f b6 db             	movzbl %bl,%ebx
    id = ioapicread(REG_ID) >> 24;
8010291d:	c1 e8 18             	shr    $0x18,%eax
    if (id != ioapicid) {
80102920:	39 c2                	cmp    %eax,%edx
80102922:	74 16                	je     8010293a <ioapicinit+0x5a>
        cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102924:	83 ec 0c             	sub    $0xc,%esp
80102927:	68 14 79 10 80       	push   $0x80107914
8010292c:	e8 cf de ff ff       	call   80100800 <cprintf>
80102931:	8b 0d 14 4e 11 80    	mov    0x80114e14,%ecx
80102937:	83 c4 10             	add    $0x10,%esp
8010293a:	83 c3 21             	add    $0x21,%ebx
void ioapicinit(void) {
8010293d:	ba 10 00 00 00       	mov    $0x10,%edx
80102942:	b8 20 00 00 00       	mov    $0x20,%eax
80102947:	89 f6                	mov    %esi,%esi
80102949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ioapic->reg = reg;
80102950:	89 11                	mov    %edx,(%ecx)
    ioapic->data = data;
80102952:	8b 0d 14 4e 11 80    	mov    0x80114e14,%ecx
    }

    // Mark all interrupts edge-triggered, active high, disabled,
    // and not routed to any CPUs.
    for (i = 0; i <= maxintr; i++) {
        ioapicwrite(REG_TABLE + 2 * i, INT_DISABLED | (T_IRQ0 + i));
80102958:	89 c6                	mov    %eax,%esi
8010295a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102960:	83 c0 01             	add    $0x1,%eax
    ioapic->data = data;
80102963:	89 71 10             	mov    %esi,0x10(%ecx)
80102966:	8d 72 01             	lea    0x1(%edx),%esi
80102969:	83 c2 02             	add    $0x2,%edx
    for (i = 0; i <= maxintr; i++) {
8010296c:	39 d8                	cmp    %ebx,%eax
    ioapic->reg = reg;
8010296e:	89 31                	mov    %esi,(%ecx)
    ioapic->data = data;
80102970:	8b 0d 14 4e 11 80    	mov    0x80114e14,%ecx
80102976:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
    for (i = 0; i <= maxintr; i++) {
8010297d:	75 d1                	jne    80102950 <ioapicinit+0x70>
        ioapicwrite(REG_TABLE + 2 * i + 1, 0);
    }
}
8010297f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102982:	5b                   	pop    %ebx
80102983:	5e                   	pop    %esi
80102984:	5d                   	pop    %ebp
80102985:	c3                   	ret    
80102986:	8d 76 00             	lea    0x0(%esi),%esi
80102989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102990 <ioapicenable>:

void ioapicenable(int irq, int cpunum) {
80102990:	55                   	push   %ebp
    ioapic->reg = reg;
80102991:	8b 0d 14 4e 11 80    	mov    0x80114e14,%ecx
void ioapicenable(int irq, int cpunum) {
80102997:	89 e5                	mov    %esp,%ebp
80102999:	8b 45 08             	mov    0x8(%ebp),%eax
    // Mark interrupt edge-triggered, active high,
    // enabled, and routed to the given cpunum,
    // which happens to be that cpu's APIC ID.
    ioapicwrite(REG_TABLE + 2 * irq, T_IRQ0 + irq);
8010299c:	8d 50 20             	lea    0x20(%eax),%edx
8010299f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
    ioapic->reg = reg;
801029a3:	89 01                	mov    %eax,(%ecx)
    ioapic->data = data;
801029a5:	8b 0d 14 4e 11 80    	mov    0x80114e14,%ecx
    ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
801029ab:	83 c0 01             	add    $0x1,%eax
    ioapic->data = data;
801029ae:	89 51 10             	mov    %edx,0x10(%ecx)
    ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
801029b1:	8b 55 0c             	mov    0xc(%ebp),%edx
    ioapic->reg = reg;
801029b4:	89 01                	mov    %eax,(%ecx)
    ioapic->data = data;
801029b6:	a1 14 4e 11 80       	mov    0x80114e14,%eax
    ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
801029bb:	c1 e2 18             	shl    $0x18,%edx
    ioapic->data = data;
801029be:	89 50 10             	mov    %edx,0x10(%eax)
}
801029c1:	5d                   	pop    %ebp
801029c2:	c3                   	ret    
801029c3:	66 90                	xchg   %ax,%ax
801029c5:	66 90                	xchg   %ax,%ax
801029c7:	66 90                	xchg   %ax,%ax
801029c9:	66 90                	xchg   %ax,%ax
801029cb:	66 90                	xchg   %ax,%ax
801029cd:	66 90                	xchg   %ax,%ax
801029cf:	90                   	nop

801029d0 <kfree>:

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(char *v) {
801029d0:	55                   	push   %ebp
801029d1:	89 e5                	mov    %esp,%ebp
801029d3:	53                   	push   %ebx
801029d4:	83 ec 04             	sub    $0x4,%esp
801029d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct run *r;

    if ((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP) {
801029da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801029e0:	75 70                	jne    80102a52 <kfree+0x82>
801029e2:	81 fb 88 7c 11 80    	cmp    $0x80117c88,%ebx
801029e8:	72 68                	jb     80102a52 <kfree+0x82>
801029ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801029f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801029f5:	77 5b                	ja     80102a52 <kfree+0x82>
        panic("kfree");
    }

    // Fill with junk to catch dangling refs.
    memset(v, 1, PGSIZE);
801029f7:	83 ec 04             	sub    $0x4,%esp
801029fa:	68 00 10 00 00       	push   $0x1000
801029ff:	6a 01                	push   $0x1
80102a01:	53                   	push   %ebx
80102a02:	e8 39 21 00 00       	call   80104b40 <memset>

    if (kmem.use_lock) {
80102a07:	8b 15 54 4e 11 80    	mov    0x80114e54,%edx
80102a0d:	83 c4 10             	add    $0x10,%esp
80102a10:	85 d2                	test   %edx,%edx
80102a12:	75 2c                	jne    80102a40 <kfree+0x70>
        acquire(&kmem.lock);
    }
    r = (struct run*)v;
    r->next = kmem.freelist;
80102a14:	a1 58 4e 11 80       	mov    0x80114e58,%eax
80102a19:	89 03                	mov    %eax,(%ebx)
    kmem.freelist = r;
    if (kmem.use_lock) {
80102a1b:	a1 54 4e 11 80       	mov    0x80114e54,%eax
    kmem.freelist = r;
80102a20:	89 1d 58 4e 11 80    	mov    %ebx,0x80114e58
    if (kmem.use_lock) {
80102a26:	85 c0                	test   %eax,%eax
80102a28:	75 06                	jne    80102a30 <kfree+0x60>
        release(&kmem.lock);
    }
}
80102a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a2d:	c9                   	leave  
80102a2e:	c3                   	ret    
80102a2f:	90                   	nop
        release(&kmem.lock);
80102a30:	c7 45 08 20 4e 11 80 	movl   $0x80114e20,0x8(%ebp)
}
80102a37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a3a:	c9                   	leave  
        release(&kmem.lock);
80102a3b:	e9 b0 20 00 00       	jmp    80104af0 <release>
        acquire(&kmem.lock);
80102a40:	83 ec 0c             	sub    $0xc,%esp
80102a43:	68 20 4e 11 80       	push   $0x80114e20
80102a48:	e8 e3 1f 00 00       	call   80104a30 <acquire>
80102a4d:	83 c4 10             	add    $0x10,%esp
80102a50:	eb c2                	jmp    80102a14 <kfree+0x44>
        panic("kfree");
80102a52:	83 ec 0c             	sub    $0xc,%esp
80102a55:	68 46 79 10 80       	push   $0x80107946
80102a5a:	e8 21 da ff ff       	call   80100480 <panic>
80102a5f:	90                   	nop

80102a60 <freerange>:
void freerange(void *vstart, void *vend) {
80102a60:	55                   	push   %ebp
80102a61:	89 e5                	mov    %esp,%ebp
80102a63:	56                   	push   %esi
80102a64:	53                   	push   %ebx
    p = (char*)PGROUNDUP((uint)vstart);
80102a65:	8b 45 08             	mov    0x8(%ebp),%eax
void freerange(void *vstart, void *vend) {
80102a68:	8b 75 0c             	mov    0xc(%ebp),%esi
    p = (char*)PGROUNDUP((uint)vstart);
80102a6b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a71:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102a77:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a7d:	39 de                	cmp    %ebx,%esi
80102a7f:	72 23                	jb     80102aa4 <freerange+0x44>
80102a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree(p);
80102a88:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102a8e:	83 ec 0c             	sub    $0xc,%esp
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102a91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
80102a97:	50                   	push   %eax
80102a98:	e8 33 ff ff ff       	call   801029d0 <kfree>
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102a9d:	83 c4 10             	add    $0x10,%esp
80102aa0:	39 f3                	cmp    %esi,%ebx
80102aa2:	76 e4                	jbe    80102a88 <freerange+0x28>
}
80102aa4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102aa7:	5b                   	pop    %ebx
80102aa8:	5e                   	pop    %esi
80102aa9:	5d                   	pop    %ebp
80102aaa:	c3                   	ret    
80102aab:	90                   	nop
80102aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ab0 <kinit1>:
void kinit1(void *vstart, void *vend) {
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	56                   	push   %esi
80102ab4:	53                   	push   %ebx
80102ab5:	8b 75 0c             	mov    0xc(%ebp),%esi
    initlock(&kmem.lock, "kmem");
80102ab8:	83 ec 08             	sub    $0x8,%esp
80102abb:	68 4c 79 10 80       	push   $0x8010794c
80102ac0:	68 20 4e 11 80       	push   $0x80114e20
80102ac5:	e8 26 1e 00 00       	call   801048f0 <initlock>
    p = (char*)PGROUNDUP((uint)vstart);
80102aca:	8b 45 08             	mov    0x8(%ebp),%eax
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102acd:	83 c4 10             	add    $0x10,%esp
    kmem.use_lock = 0;
80102ad0:	c7 05 54 4e 11 80 00 	movl   $0x0,0x80114e54
80102ad7:	00 00 00 
    p = (char*)PGROUNDUP((uint)vstart);
80102ada:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ae0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102ae6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102aec:	39 de                	cmp    %ebx,%esi
80102aee:	72 1c                	jb     80102b0c <kinit1+0x5c>
        kfree(p);
80102af0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102af6:	83 ec 0c             	sub    $0xc,%esp
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102af9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
80102aff:	50                   	push   %eax
80102b00:	e8 cb fe ff ff       	call   801029d0 <kfree>
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102b05:	83 c4 10             	add    $0x10,%esp
80102b08:	39 de                	cmp    %ebx,%esi
80102b0a:	73 e4                	jae    80102af0 <kinit1+0x40>
}
80102b0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b0f:	5b                   	pop    %ebx
80102b10:	5e                   	pop    %esi
80102b11:	5d                   	pop    %ebp
80102b12:	c3                   	ret    
80102b13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b20 <kinit2>:
void kinit2(void *vstart, void *vend) {
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	56                   	push   %esi
80102b24:	53                   	push   %ebx
    p = (char*)PGROUNDUP((uint)vstart);
80102b25:	8b 45 08             	mov    0x8(%ebp),%eax
void kinit2(void *vstart, void *vend) {
80102b28:	8b 75 0c             	mov    0xc(%ebp),%esi
    p = (char*)PGROUNDUP((uint)vstart);
80102b2b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b31:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102b37:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b3d:	39 de                	cmp    %ebx,%esi
80102b3f:	72 23                	jb     80102b64 <kinit2+0x44>
80102b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree(p);
80102b48:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102b4e:	83 ec 0c             	sub    $0xc,%esp
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102b51:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
80102b57:	50                   	push   %eax
80102b58:	e8 73 fe ff ff       	call   801029d0 <kfree>
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102b5d:	83 c4 10             	add    $0x10,%esp
80102b60:	39 de                	cmp    %ebx,%esi
80102b62:	73 e4                	jae    80102b48 <kinit2+0x28>
    kmem.use_lock = 1;
80102b64:	c7 05 54 4e 11 80 01 	movl   $0x1,0x80114e54
80102b6b:	00 00 00 
}
80102b6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b71:	5b                   	pop    %ebx
80102b72:	5e                   	pop    %esi
80102b73:	5d                   	pop    %ebp
80102b74:	c3                   	ret    
80102b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b80 <kalloc>:
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char* kalloc(void)  {
    struct run *r;

    if (kmem.use_lock) {
80102b80:	a1 54 4e 11 80       	mov    0x80114e54,%eax
80102b85:	85 c0                	test   %eax,%eax
80102b87:	75 1f                	jne    80102ba8 <kalloc+0x28>
        acquire(&kmem.lock);
    }
    r = kmem.freelist;
80102b89:	a1 58 4e 11 80       	mov    0x80114e58,%eax
    if (r) {
80102b8e:	85 c0                	test   %eax,%eax
80102b90:	74 0e                	je     80102ba0 <kalloc+0x20>
        kmem.freelist = r->next;
80102b92:	8b 10                	mov    (%eax),%edx
80102b94:	89 15 58 4e 11 80    	mov    %edx,0x80114e58
80102b9a:	c3                   	ret    
80102b9b:	90                   	nop
80102b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if (kmem.use_lock) {
        release(&kmem.lock);
    }
    return (char*)r;
}
80102ba0:	f3 c3                	repz ret 
80102ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
char* kalloc(void)  {
80102ba8:	55                   	push   %ebp
80102ba9:	89 e5                	mov    %esp,%ebp
80102bab:	83 ec 24             	sub    $0x24,%esp
        acquire(&kmem.lock);
80102bae:	68 20 4e 11 80       	push   $0x80114e20
80102bb3:	e8 78 1e 00 00       	call   80104a30 <acquire>
    r = kmem.freelist;
80102bb8:	a1 58 4e 11 80       	mov    0x80114e58,%eax
    if (r) {
80102bbd:	83 c4 10             	add    $0x10,%esp
80102bc0:	8b 15 54 4e 11 80    	mov    0x80114e54,%edx
80102bc6:	85 c0                	test   %eax,%eax
80102bc8:	74 08                	je     80102bd2 <kalloc+0x52>
        kmem.freelist = r->next;
80102bca:	8b 08                	mov    (%eax),%ecx
80102bcc:	89 0d 58 4e 11 80    	mov    %ecx,0x80114e58
    if (kmem.use_lock) {
80102bd2:	85 d2                	test   %edx,%edx
80102bd4:	74 16                	je     80102bec <kalloc+0x6c>
        release(&kmem.lock);
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102bdc:	68 20 4e 11 80       	push   $0x80114e20
80102be1:	e8 0a 1f 00 00       	call   80104af0 <release>
    return (char*)r;
80102be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
        release(&kmem.lock);
80102be9:	83 c4 10             	add    $0x10,%esp
}
80102bec:	c9                   	leave  
80102bed:	c3                   	ret    
80102bee:	66 90                	xchg   %ax,%ax

80102bf0 <kbdgetc>:
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102bf0:	ba 64 00 00 00       	mov    $0x64,%edx
80102bf5:	ec                   	in     (%dx),%al
        normalmap, shiftmap, ctlmap, ctlmap
    };
    uint st, data, c;

    st = inb(KBSTATP);
    if ((st & KBS_DIB) == 0) {
80102bf6:	a8 01                	test   $0x1,%al
80102bf8:	0f 84 c2 00 00 00    	je     80102cc0 <kbdgetc+0xd0>
80102bfe:	ba 60 00 00 00       	mov    $0x60,%edx
80102c03:	ec                   	in     (%dx),%al
        return -1;
    }
    data = inb(KBDATAP);
80102c04:	0f b6 d0             	movzbl %al,%edx
80102c07:	8b 0d b4 c5 10 80    	mov    0x8010c5b4,%ecx

    if (data == 0xE0) {
80102c0d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102c13:	0f 84 7f 00 00 00    	je     80102c98 <kbdgetc+0xa8>
int kbdgetc(void) {
80102c19:	55                   	push   %ebp
80102c1a:	89 e5                	mov    %esp,%ebp
80102c1c:	53                   	push   %ebx
80102c1d:	89 cb                	mov    %ecx,%ebx
80102c1f:	83 e3 40             	and    $0x40,%ebx
        shift |= E0ESC;
        return 0;
    }
    else if (data & 0x80) {
80102c22:	84 c0                	test   %al,%al
80102c24:	78 4a                	js     80102c70 <kbdgetc+0x80>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
        shift &= ~(shiftcode[data] | E0ESC);
        return 0;
    }
    else if (shift & E0ESC) {
80102c26:	85 db                	test   %ebx,%ebx
80102c28:	74 09                	je     80102c33 <kbdgetc+0x43>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
80102c2a:	83 c8 80             	or     $0xffffff80,%eax
        shift &= ~E0ESC;
80102c2d:	83 e1 bf             	and    $0xffffffbf,%ecx
        data |= 0x80;
80102c30:	0f b6 d0             	movzbl %al,%edx
    }

    shift |= shiftcode[data];
80102c33:	0f b6 82 80 7a 10 80 	movzbl -0x7fef8580(%edx),%eax
80102c3a:	09 c1                	or     %eax,%ecx
    shift ^= togglecode[data];
80102c3c:	0f b6 82 80 79 10 80 	movzbl -0x7fef8680(%edx),%eax
80102c43:	31 c1                	xor    %eax,%ecx
    c = charcode[shift & (CTL | SHIFT)][data];
80102c45:	89 c8                	mov    %ecx,%eax
    shift ^= togglecode[data];
80102c47:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
    c = charcode[shift & (CTL | SHIFT)][data];
80102c4d:	83 e0 03             	and    $0x3,%eax
    if (shift & CAPSLOCK) {
80102c50:	83 e1 08             	and    $0x8,%ecx
    c = charcode[shift & (CTL | SHIFT)][data];
80102c53:	8b 04 85 60 79 10 80 	mov    -0x7fef86a0(,%eax,4),%eax
80102c5a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
    if (shift & CAPSLOCK) {
80102c5e:	74 31                	je     80102c91 <kbdgetc+0xa1>
        if ('a' <= c && c <= 'z') {
80102c60:	8d 50 9f             	lea    -0x61(%eax),%edx
80102c63:	83 fa 19             	cmp    $0x19,%edx
80102c66:	77 40                	ja     80102ca8 <kbdgetc+0xb8>
            c += 'A' - 'a';
80102c68:	83 e8 20             	sub    $0x20,%eax
        else if ('A' <= c && c <= 'Z') {
            c += 'a' - 'A';
        }
    }
    return c;
}
80102c6b:	5b                   	pop    %ebx
80102c6c:	5d                   	pop    %ebp
80102c6d:	c3                   	ret    
80102c6e:	66 90                	xchg   %ax,%ax
        data = (shift & E0ESC ? data : data & 0x7F);
80102c70:	83 e0 7f             	and    $0x7f,%eax
80102c73:	85 db                	test   %ebx,%ebx
80102c75:	0f 44 d0             	cmove  %eax,%edx
        shift &= ~(shiftcode[data] | E0ESC);
80102c78:	0f b6 82 80 7a 10 80 	movzbl -0x7fef8580(%edx),%eax
80102c7f:	83 c8 40             	or     $0x40,%eax
80102c82:	0f b6 c0             	movzbl %al,%eax
80102c85:	f7 d0                	not    %eax
80102c87:	21 c1                	and    %eax,%ecx
        return 0;
80102c89:	31 c0                	xor    %eax,%eax
        shift &= ~(shiftcode[data] | E0ESC);
80102c8b:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
80102c91:	5b                   	pop    %ebx
80102c92:	5d                   	pop    %ebp
80102c93:	c3                   	ret    
80102c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        shift |= E0ESC;
80102c98:	83 c9 40             	or     $0x40,%ecx
        return 0;
80102c9b:	31 c0                	xor    %eax,%eax
        shift |= E0ESC;
80102c9d:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
        return 0;
80102ca3:	c3                   	ret    
80102ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        else if ('A' <= c && c <= 'Z') {
80102ca8:	8d 48 bf             	lea    -0x41(%eax),%ecx
            c += 'a' - 'A';
80102cab:	8d 50 20             	lea    0x20(%eax),%edx
}
80102cae:	5b                   	pop    %ebx
            c += 'a' - 'A';
80102caf:	83 f9 1a             	cmp    $0x1a,%ecx
80102cb2:	0f 42 c2             	cmovb  %edx,%eax
}
80102cb5:	5d                   	pop    %ebp
80102cb6:	c3                   	ret    
80102cb7:	89 f6                	mov    %esi,%esi
80102cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return -1;
80102cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102cc5:	c3                   	ret    
80102cc6:	8d 76 00             	lea    0x0(%esi),%esi
80102cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cd0 <kbdintr>:

void kbdintr(void) {
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	83 ec 14             	sub    $0x14,%esp
    consoleintr(kbdgetc);
80102cd6:	68 f0 2b 10 80       	push   $0x80102bf0
80102cdb:	e8 20 dd ff ff       	call   80100a00 <consoleintr>
}
80102ce0:	83 c4 10             	add    $0x10,%esp
80102ce3:	c9                   	leave  
80102ce4:	c3                   	ret    
80102ce5:	66 90                	xchg   %ax,%ax
80102ce7:	66 90                	xchg   %ax,%ax
80102ce9:	66 90                	xchg   %ax,%ax
80102ceb:	66 90                	xchg   %ax,%ax
80102ced:	66 90                	xchg   %ax,%ax
80102cef:	90                   	nop

80102cf0 <lapicinit>:
    lapic[index] = value;
    lapic[ID];  // wait for write to finish, by reading
}

void lapicinit(void) {
    if (!lapic) {
80102cf0:	a1 5c 4e 11 80       	mov    0x80114e5c,%eax
void lapicinit(void) {
80102cf5:	55                   	push   %ebp
80102cf6:	89 e5                	mov    %esp,%ebp
    if (!lapic) {
80102cf8:	85 c0                	test   %eax,%eax
80102cfa:	0f 84 c8 00 00 00    	je     80102dc8 <lapicinit+0xd8>
    lapic[index] = value;
80102d00:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102d07:	01 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102d0a:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d0d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102d14:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102d17:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d1a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102d21:	00 02 00 
    lapic[ID];  // wait for write to finish, by reading
80102d24:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d27:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102d2e:	96 98 00 
    lapic[ID];  // wait for write to finish, by reading
80102d31:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d34:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102d3b:	00 01 00 
    lapic[ID];  // wait for write to finish, by reading
80102d3e:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d41:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102d48:	00 01 00 
    lapic[ID];  // wait for write to finish, by reading
80102d4b:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(LINT0, MASKED);
    lapicw(LINT1, MASKED);

    // Disable performance counter overflow interrupts
    // on machines that provide that interrupt entry.
    if (((lapic[VER] >> 16) & 0xFF) >= 4) {
80102d4e:	8b 50 30             	mov    0x30(%eax),%edx
80102d51:	c1 ea 10             	shr    $0x10,%edx
80102d54:	80 fa 03             	cmp    $0x3,%dl
80102d57:	77 77                	ja     80102dd0 <lapicinit+0xe0>
    lapic[index] = value;
80102d59:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102d60:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102d63:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d66:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d6d:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102d70:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d73:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d7a:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102d7d:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d80:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d87:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102d8a:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d8d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102d94:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102d97:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102d9a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102da1:	85 08 00 
    lapic[ID];  // wait for write to finish, by reading
80102da4:	8b 50 20             	mov    0x20(%eax),%edx
80102da7:	89 f6                	mov    %esi,%esi
80102da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapicw(EOI, 0);

    // Send an Init Level De-Assert to synchronise arbitration ID's.
    lapicw(ICRHI, 0);
    lapicw(ICRLO, BCAST | INIT | LEVEL);
    while (lapic[ICRLO] & DELIVS) {
80102db0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102db6:	80 e6 10             	and    $0x10,%dh
80102db9:	75 f5                	jne    80102db0 <lapicinit+0xc0>
    lapic[index] = value;
80102dbb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102dc2:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102dc5:	8b 40 20             	mov    0x20(%eax),%eax
        ;
    }

    // Enable interrupts on the APIC (but not on the processor).
    lapicw(TPR, 0);
}
80102dc8:	5d                   	pop    %ebp
80102dc9:	c3                   	ret    
80102dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapic[index] = value;
80102dd0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102dd7:	00 01 00 
    lapic[ID];  // wait for write to finish, by reading
80102dda:	8b 50 20             	mov    0x20(%eax),%edx
80102ddd:	e9 77 ff ff ff       	jmp    80102d59 <lapicinit+0x69>
80102de2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102df0 <lapicid>:

int lapicid(void) {
    if (!lapic) {
80102df0:	8b 15 5c 4e 11 80    	mov    0x80114e5c,%edx
int lapicid(void) {
80102df6:	55                   	push   %ebp
80102df7:	31 c0                	xor    %eax,%eax
80102df9:	89 e5                	mov    %esp,%ebp
    if (!lapic) {
80102dfb:	85 d2                	test   %edx,%edx
80102dfd:	74 06                	je     80102e05 <lapicid+0x15>
        return 0;
    }
    return lapic[ID] >> 24;
80102dff:	8b 42 20             	mov    0x20(%edx),%eax
80102e02:	c1 e8 18             	shr    $0x18,%eax
}
80102e05:	5d                   	pop    %ebp
80102e06:	c3                   	ret    
80102e07:	89 f6                	mov    %esi,%esi
80102e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e10 <lapiceoi>:

// Acknowledge interrupt.
void lapiceoi(void) {
    if (lapic) {
80102e10:	a1 5c 4e 11 80       	mov    0x80114e5c,%eax
void lapiceoi(void) {
80102e15:	55                   	push   %ebp
80102e16:	89 e5                	mov    %esp,%ebp
    if (lapic) {
80102e18:	85 c0                	test   %eax,%eax
80102e1a:	74 0d                	je     80102e29 <lapiceoi+0x19>
    lapic[index] = value;
80102e1c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102e23:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102e26:	8b 40 20             	mov    0x20(%eax),%eax
        lapicw(EOI, 0);
    }
}
80102e29:	5d                   	pop    %ebp
80102e2a:	c3                   	ret    
80102e2b:	90                   	nop
80102e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102e30 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void microdelay(int us) {
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
}
80102e33:	5d                   	pop    %ebp
80102e34:	c3                   	ret    
80102e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e40 <lapicstartap>:
#define CMOS_PORT    0x70
#define CMOS_RETURN  0x71

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void lapicstartap(uchar apicid, uint addr)      {
80102e40:	55                   	push   %ebp
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102e41:	b8 0f 00 00 00       	mov    $0xf,%eax
80102e46:	ba 70 00 00 00       	mov    $0x70,%edx
80102e4b:	89 e5                	mov    %esp,%ebp
80102e4d:	53                   	push   %ebx
80102e4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102e51:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e54:	ee                   	out    %al,(%dx)
80102e55:	b8 0a 00 00 00       	mov    $0xa,%eax
80102e5a:	ba 71 00 00 00       	mov    $0x71,%edx
80102e5f:	ee                   	out    %al,(%dx)
    // and the warm reset vector (DWORD based at 40:67) to point at
    // the AP startup code prior to the [universal startup algorithm]."
    outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
    outb(CMOS_PORT + 1, 0x0A);
    wrv = (ushort*)P2V((0x40 << 4 | 0x67));  // Warm reset vector
    wrv[0] = 0;
80102e60:	31 c0                	xor    %eax,%eax
    wrv[1] = addr >> 4;

    // "Universal startup algorithm."
    // Send INIT (level-triggered) interrupt to reset other CPU.
    lapicw(ICRHI, apicid << 24);
80102e62:	c1 e3 18             	shl    $0x18,%ebx
    wrv[0] = 0;
80102e65:	66 a3 67 04 00 80    	mov    %ax,0x80000467
    wrv[1] = addr >> 4;
80102e6b:	89 c8                	mov    %ecx,%eax
    // when it is in the halted state due to an INIT.  So the second
    // should be ignored, but it is part of the official Intel algorithm.
    // Bochs complains about the second one.  Too bad for Bochs.
    for (i = 0; i < 2; i++) {
        lapicw(ICRHI, apicid << 24);
        lapicw(ICRLO, STARTUP | (addr >> 12));
80102e6d:	c1 e9 0c             	shr    $0xc,%ecx
    wrv[1] = addr >> 4;
80102e70:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRHI, apicid << 24);
80102e73:	89 da                	mov    %ebx,%edx
        lapicw(ICRLO, STARTUP | (addr >> 12));
80102e75:	80 cd 06             	or     $0x6,%ch
    wrv[1] = addr >> 4;
80102e78:	66 a3 69 04 00 80    	mov    %ax,0x80000469
    lapic[index] = value;
80102e7e:	a1 5c 4e 11 80       	mov    0x80114e5c,%eax
80102e83:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
    lapic[ID];  // wait for write to finish, by reading
80102e89:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
80102e8c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102e93:	c5 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102e96:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
80102e99:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ea0:	85 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102ea3:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
80102ea6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
    lapic[ID];  // wait for write to finish, by reading
80102eac:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
80102eaf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    lapic[ID];  // wait for write to finish, by reading
80102eb5:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
80102eb8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
    lapic[ID];  // wait for write to finish, by reading
80102ebe:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102ec1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    lapic[ID];  // wait for write to finish, by reading
80102ec7:	8b 40 20             	mov    0x20(%eax),%eax
        microdelay(200);
    }
}
80102eca:	5b                   	pop    %ebx
80102ecb:	5d                   	pop    %ebp
80102ecc:	c3                   	ret    
80102ecd:	8d 76 00             	lea    0x0(%esi),%esi

80102ed0 <cmostime>:
    r->month  = cmos_read(MONTH);
    r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r) {
80102ed0:	55                   	push   %ebp
80102ed1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ed6:	ba 70 00 00 00       	mov    $0x70,%edx
80102edb:	89 e5                	mov    %esp,%ebp
80102edd:	57                   	push   %edi
80102ede:	56                   	push   %esi
80102edf:	53                   	push   %ebx
80102ee0:	83 ec 4c             	sub    $0x4c,%esp
80102ee3:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102ee4:	ba 71 00 00 00       	mov    $0x71,%edx
80102ee9:	ec                   	in     (%dx),%al
80102eea:	83 e0 04             	and    $0x4,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102eed:	bb 70 00 00 00       	mov    $0x70,%ebx
80102ef2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ef5:	8d 76 00             	lea    0x0(%esi),%esi
80102ef8:	31 c0                	xor    %eax,%eax
80102efa:	89 da                	mov    %ebx,%edx
80102efc:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102efd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102f02:	89 ca                	mov    %ecx,%edx
80102f04:	ec                   	in     (%dx),%al
80102f05:	88 45 b7             	mov    %al,-0x49(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102f08:	89 da                	mov    %ebx,%edx
80102f0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102f0f:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102f10:	89 ca                	mov    %ecx,%edx
80102f12:	ec                   	in     (%dx),%al
80102f13:	88 45 b6             	mov    %al,-0x4a(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102f16:	89 da                	mov    %ebx,%edx
80102f18:	b8 04 00 00 00       	mov    $0x4,%eax
80102f1d:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102f1e:	89 ca                	mov    %ecx,%edx
80102f20:	ec                   	in     (%dx),%al
80102f21:	88 45 b5             	mov    %al,-0x4b(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102f24:	89 da                	mov    %ebx,%edx
80102f26:	b8 07 00 00 00       	mov    $0x7,%eax
80102f2b:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102f2c:	89 ca                	mov    %ecx,%edx
80102f2e:	ec                   	in     (%dx),%al
80102f2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102f32:	89 da                	mov    %ebx,%edx
80102f34:	b8 08 00 00 00       	mov    $0x8,%eax
80102f39:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102f3a:	89 ca                	mov    %ecx,%edx
80102f3c:	ec                   	in     (%dx),%al
80102f3d:	89 c7                	mov    %eax,%edi
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102f3f:	89 da                	mov    %ebx,%edx
80102f41:	b8 09 00 00 00       	mov    $0x9,%eax
80102f46:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102f47:	89 ca                	mov    %ecx,%edx
80102f49:	ec                   	in     (%dx),%al
80102f4a:	89 c6                	mov    %eax,%esi
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102f4c:	89 da                	mov    %ebx,%edx
80102f4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102f53:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102f54:	89 ca                	mov    %ecx,%edx
80102f56:	ec                   	in     (%dx),%al
    bcd = (sb & (1 << 2)) == 0;

    // make sure CMOS doesn't modify time while we read it
    for (;;) {
        fill_rtcdate(&t1);
        if (cmos_read(CMOS_STATA) & CMOS_UIP) {
80102f57:	84 c0                	test   %al,%al
80102f59:	78 9d                	js     80102ef8 <cmostime+0x28>
    return inb(CMOS_RETURN);
80102f5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102f5f:	89 fa                	mov    %edi,%edx
80102f61:	0f b6 fa             	movzbl %dl,%edi
80102f64:	89 f2                	mov    %esi,%edx
80102f66:	0f b6 f2             	movzbl %dl,%esi
80102f69:	89 7d c8             	mov    %edi,-0x38(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102f6c:	89 da                	mov    %ebx,%edx
80102f6e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102f71:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102f74:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102f78:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102f7b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102f7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102f82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102f86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102f89:	31 c0                	xor    %eax,%eax
80102f8b:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102f8c:	89 ca                	mov    %ecx,%edx
80102f8e:	ec                   	in     (%dx),%al
80102f8f:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102f92:	89 da                	mov    %ebx,%edx
80102f94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102f97:	b8 02 00 00 00       	mov    $0x2,%eax
80102f9c:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102f9d:	89 ca                	mov    %ecx,%edx
80102f9f:	ec                   	in     (%dx),%al
80102fa0:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102fa3:	89 da                	mov    %ebx,%edx
80102fa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102fa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102fad:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102fae:	89 ca                	mov    %ecx,%edx
80102fb0:	ec                   	in     (%dx),%al
80102fb1:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102fb4:	89 da                	mov    %ebx,%edx
80102fb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102fb9:	b8 07 00 00 00       	mov    $0x7,%eax
80102fbe:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102fbf:	89 ca                	mov    %ecx,%edx
80102fc1:	ec                   	in     (%dx),%al
80102fc2:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102fc5:	89 da                	mov    %ebx,%edx
80102fc7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102fca:	b8 08 00 00 00       	mov    $0x8,%eax
80102fcf:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102fd0:	89 ca                	mov    %ecx,%edx
80102fd2:	ec                   	in     (%dx),%al
80102fd3:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102fd6:	89 da                	mov    %ebx,%edx
80102fd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102fdb:	b8 09 00 00 00       	mov    $0x9,%eax
80102fe0:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102fe1:	89 ca                	mov    %ecx,%edx
80102fe3:	ec                   	in     (%dx),%al
80102fe4:	0f b6 c0             	movzbl %al,%eax
            continue;
        }
        fill_rtcdate(&t2);
        if (memcmp(&t1, &t2, sizeof(t1)) == 0) {
80102fe7:	83 ec 04             	sub    $0x4,%esp
    return inb(CMOS_RETURN);
80102fea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (memcmp(&t1, &t2, sizeof(t1)) == 0) {
80102fed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ff0:	6a 18                	push   $0x18
80102ff2:	50                   	push   %eax
80102ff3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ff6:	50                   	push   %eax
80102ff7:	e8 94 1b 00 00       	call   80104b90 <memcmp>
80102ffc:	83 c4 10             	add    $0x10,%esp
80102fff:	85 c0                	test   %eax,%eax
80103001:	0f 85 f1 fe ff ff    	jne    80102ef8 <cmostime+0x28>
            break;
        }
    }

    // convert
    if (bcd) {
80103007:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010300b:	75 78                	jne    80103085 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
        CONV(second);
8010300d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103010:	89 c2                	mov    %eax,%edx
80103012:	83 e0 0f             	and    $0xf,%eax
80103015:	c1 ea 04             	shr    $0x4,%edx
80103018:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010301b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010301e:	89 45 b8             	mov    %eax,-0x48(%ebp)
        CONV(minute);
80103021:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103024:	89 c2                	mov    %eax,%edx
80103026:	83 e0 0f             	and    $0xf,%eax
80103029:	c1 ea 04             	shr    $0x4,%edx
8010302c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010302f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103032:	89 45 bc             	mov    %eax,-0x44(%ebp)
        CONV(hour  );
80103035:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103038:	89 c2                	mov    %eax,%edx
8010303a:	83 e0 0f             	and    $0xf,%eax
8010303d:	c1 ea 04             	shr    $0x4,%edx
80103040:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103043:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103046:	89 45 c0             	mov    %eax,-0x40(%ebp)
        CONV(day   );
80103049:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010304c:	89 c2                	mov    %eax,%edx
8010304e:	83 e0 0f             	and    $0xf,%eax
80103051:	c1 ea 04             	shr    $0x4,%edx
80103054:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103057:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010305a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        CONV(month );
8010305d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103060:	89 c2                	mov    %eax,%edx
80103062:	83 e0 0f             	and    $0xf,%eax
80103065:	c1 ea 04             	shr    $0x4,%edx
80103068:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010306b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010306e:	89 45 c8             	mov    %eax,-0x38(%ebp)
        CONV(year  );
80103071:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103074:	89 c2                	mov    %eax,%edx
80103076:	83 e0 0f             	and    $0xf,%eax
80103079:	c1 ea 04             	shr    $0x4,%edx
8010307c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010307f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103082:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
    }

    *r = t1;
80103085:	8b 75 08             	mov    0x8(%ebp),%esi
80103088:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010308b:	89 06                	mov    %eax,(%esi)
8010308d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103090:	89 46 04             	mov    %eax,0x4(%esi)
80103093:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103096:	89 46 08             	mov    %eax,0x8(%esi)
80103099:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010309c:	89 46 0c             	mov    %eax,0xc(%esi)
8010309f:	8b 45 c8             	mov    -0x38(%ebp),%eax
801030a2:	89 46 10             	mov    %eax,0x10(%esi)
801030a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801030a8:	89 46 14             	mov    %eax,0x14(%esi)
    r->year += 2000;
801030ab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801030b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030b5:	5b                   	pop    %ebx
801030b6:	5e                   	pop    %esi
801030b7:	5f                   	pop    %edi
801030b8:	5d                   	pop    %ebp
801030b9:	c3                   	ret    
801030ba:	66 90                	xchg   %ax,%ax
801030bc:	66 90                	xchg   %ax,%ax
801030be:	66 90                	xchg   %ax,%ax

801030c0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030c0:	8b 0d a8 4e 11 80    	mov    0x80114ea8,%ecx
801030c6:	85 c9                	test   %ecx,%ecx
801030c8:	0f 8e 8a 00 00 00    	jle    80103158 <install_trans+0x98>
{
801030ce:	55                   	push   %ebp
801030cf:	89 e5                	mov    %esp,%ebp
801030d1:	57                   	push   %edi
801030d2:	56                   	push   %esi
801030d3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
801030d4:	31 db                	xor    %ebx,%ebx
{
801030d6:	83 ec 0c             	sub    $0xc,%esp
801030d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801030e0:	a1 94 4e 11 80       	mov    0x80114e94,%eax
801030e5:	83 ec 08             	sub    $0x8,%esp
801030e8:	01 d8                	add    %ebx,%eax
801030ea:	83 c0 01             	add    $0x1,%eax
801030ed:	50                   	push   %eax
801030ee:	ff 35 a4 4e 11 80    	pushl  0x80114ea4
801030f4:	e8 d7 cf ff ff       	call   801000d0 <bread>
801030f9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030fb:	58                   	pop    %eax
801030fc:	5a                   	pop    %edx
801030fd:	ff 34 9d ac 4e 11 80 	pushl  -0x7feeb154(,%ebx,4)
80103104:	ff 35 a4 4e 11 80    	pushl  0x80114ea4
  for (tail = 0; tail < log.lh.n; tail++) {
8010310a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010310d:	e8 be cf ff ff       	call   801000d0 <bread>
80103112:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103114:	8d 47 5c             	lea    0x5c(%edi),%eax
80103117:	83 c4 0c             	add    $0xc,%esp
8010311a:	68 00 02 00 00       	push   $0x200
8010311f:	50                   	push   %eax
80103120:	8d 46 5c             	lea    0x5c(%esi),%eax
80103123:	50                   	push   %eax
80103124:	e8 c7 1a 00 00       	call   80104bf0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103129:	89 34 24             	mov    %esi,(%esp)
8010312c:	e8 6f d0 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80103131:	89 3c 24             	mov    %edi,(%esp)
80103134:	e8 a7 d0 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80103139:	89 34 24             	mov    %esi,(%esp)
8010313c:	e8 9f d0 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103141:	83 c4 10             	add    $0x10,%esp
80103144:	39 1d a8 4e 11 80    	cmp    %ebx,0x80114ea8
8010314a:	7f 94                	jg     801030e0 <install_trans+0x20>
  }
}
8010314c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010314f:	5b                   	pop    %ebx
80103150:	5e                   	pop    %esi
80103151:	5f                   	pop    %edi
80103152:	5d                   	pop    %ebp
80103153:	c3                   	ret    
80103154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103158:	f3 c3                	repz ret 
8010315a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103160 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	56                   	push   %esi
80103164:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80103165:	83 ec 08             	sub    $0x8,%esp
80103168:	ff 35 94 4e 11 80    	pushl  0x80114e94
8010316e:	ff 35 a4 4e 11 80    	pushl  0x80114ea4
80103174:	e8 57 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103179:	8b 1d a8 4e 11 80    	mov    0x80114ea8,%ebx
  for (i = 0; i < log.lh.n; i++) {
8010317f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103182:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80103184:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80103186:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103189:	7e 16                	jle    801031a1 <write_head+0x41>
8010318b:	c1 e3 02             	shl    $0x2,%ebx
8010318e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80103190:	8b 8a ac 4e 11 80    	mov    -0x7feeb154(%edx),%ecx
80103196:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
8010319a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010319d:	39 da                	cmp    %ebx,%edx
8010319f:	75 ef                	jne    80103190 <write_head+0x30>
  }
  bwrite(buf);
801031a1:	83 ec 0c             	sub    $0xc,%esp
801031a4:	56                   	push   %esi
801031a5:	e8 f6 cf ff ff       	call   801001a0 <bwrite>
  brelse(buf);
801031aa:	89 34 24             	mov    %esi,(%esp)
801031ad:	e8 2e d0 ff ff       	call   801001e0 <brelse>
}
801031b2:	83 c4 10             	add    $0x10,%esp
801031b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801031b8:	5b                   	pop    %ebx
801031b9:	5e                   	pop    %esi
801031ba:	5d                   	pop    %ebp
801031bb:	c3                   	ret    
801031bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801031c0 <initlog>:
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	53                   	push   %ebx
801031c4:	83 ec 2c             	sub    $0x2c,%esp
801031c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801031ca:	68 80 7b 10 80       	push   $0x80107b80
801031cf:	68 60 4e 11 80       	push   $0x80114e60
801031d4:	e8 17 17 00 00       	call   801048f0 <initlock>
  readsb(dev, &sb);
801031d9:	58                   	pop    %eax
801031da:	8d 45 dc             	lea    -0x24(%ebp),%eax
801031dd:	5a                   	pop    %edx
801031de:	50                   	push   %eax
801031df:	53                   	push   %ebx
801031e0:	e8 1b e9 ff ff       	call   80101b00 <readsb>
  log.size = sb.nlog;
801031e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801031e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801031eb:	59                   	pop    %ecx
  log.dev = dev;
801031ec:	89 1d a4 4e 11 80    	mov    %ebx,0x80114ea4
  log.size = sb.nlog;
801031f2:	89 15 98 4e 11 80    	mov    %edx,0x80114e98
  log.start = sb.logstart;
801031f8:	a3 94 4e 11 80       	mov    %eax,0x80114e94
  struct buf *buf = bread(log.dev, log.start);
801031fd:	5a                   	pop    %edx
801031fe:	50                   	push   %eax
801031ff:	53                   	push   %ebx
80103200:	e8 cb ce ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103205:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103208:	83 c4 10             	add    $0x10,%esp
8010320b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010320d:	89 1d a8 4e 11 80    	mov    %ebx,0x80114ea8
  for (i = 0; i < log.lh.n; i++) {
80103213:	7e 1c                	jle    80103231 <initlog+0x71>
80103215:	c1 e3 02             	shl    $0x2,%ebx
80103218:	31 d2                	xor    %edx,%edx
8010321a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103220:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103224:	83 c2 04             	add    $0x4,%edx
80103227:	89 8a a8 4e 11 80    	mov    %ecx,-0x7feeb158(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010322d:	39 d3                	cmp    %edx,%ebx
8010322f:	75 ef                	jne    80103220 <initlog+0x60>
  brelse(buf);
80103231:	83 ec 0c             	sub    $0xc,%esp
80103234:	50                   	push   %eax
80103235:	e8 a6 cf ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010323a:	e8 81 fe ff ff       	call   801030c0 <install_trans>
  log.lh.n = 0;
8010323f:	c7 05 a8 4e 11 80 00 	movl   $0x0,0x80114ea8
80103246:	00 00 00 
  write_head(); // clear the log
80103249:	e8 12 ff ff ff       	call   80103160 <write_head>
}
8010324e:	83 c4 10             	add    $0x10,%esp
80103251:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103254:	c9                   	leave  
80103255:	c3                   	ret    
80103256:	8d 76 00             	lea    0x0(%esi),%esi
80103259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103260 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103266:	68 60 4e 11 80       	push   $0x80114e60
8010326b:	e8 c0 17 00 00       	call   80104a30 <acquire>
80103270:	83 c4 10             	add    $0x10,%esp
80103273:	eb 18                	jmp    8010328d <begin_op+0x2d>
80103275:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103278:	83 ec 08             	sub    $0x8,%esp
8010327b:	68 60 4e 11 80       	push   $0x80114e60
80103280:	68 60 4e 11 80       	push   $0x80114e60
80103285:	e8 e6 11 00 00       	call   80104470 <sleep>
8010328a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010328d:	a1 a0 4e 11 80       	mov    0x80114ea0,%eax
80103292:	85 c0                	test   %eax,%eax
80103294:	75 e2                	jne    80103278 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103296:	a1 9c 4e 11 80       	mov    0x80114e9c,%eax
8010329b:	8b 15 a8 4e 11 80    	mov    0x80114ea8,%edx
801032a1:	83 c0 01             	add    $0x1,%eax
801032a4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801032a7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801032aa:	83 fa 1e             	cmp    $0x1e,%edx
801032ad:	7f c9                	jg     80103278 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801032af:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801032b2:	a3 9c 4e 11 80       	mov    %eax,0x80114e9c
      release(&log.lock);
801032b7:	68 60 4e 11 80       	push   $0x80114e60
801032bc:	e8 2f 18 00 00       	call   80104af0 <release>
      break;
    }
  }
}
801032c1:	83 c4 10             	add    $0x10,%esp
801032c4:	c9                   	leave  
801032c5:	c3                   	ret    
801032c6:	8d 76 00             	lea    0x0(%esi),%esi
801032c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801032d0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801032d0:	55                   	push   %ebp
801032d1:	89 e5                	mov    %esp,%ebp
801032d3:	57                   	push   %edi
801032d4:	56                   	push   %esi
801032d5:	53                   	push   %ebx
801032d6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801032d9:	68 60 4e 11 80       	push   $0x80114e60
801032de:	e8 4d 17 00 00       	call   80104a30 <acquire>
  log.outstanding -= 1;
801032e3:	a1 9c 4e 11 80       	mov    0x80114e9c,%eax
  if(log.committing)
801032e8:	8b 35 a0 4e 11 80    	mov    0x80114ea0,%esi
801032ee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801032f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
801032f4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
801032f6:	89 1d 9c 4e 11 80    	mov    %ebx,0x80114e9c
  if(log.committing)
801032fc:	0f 85 1a 01 00 00    	jne    8010341c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103302:	85 db                	test   %ebx,%ebx
80103304:	0f 85 ee 00 00 00    	jne    801033f8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010330a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010330d:	c7 05 a0 4e 11 80 01 	movl   $0x1,0x80114ea0
80103314:	00 00 00 
  release(&log.lock);
80103317:	68 60 4e 11 80       	push   $0x80114e60
8010331c:	e8 cf 17 00 00       	call   80104af0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103321:	8b 0d a8 4e 11 80    	mov    0x80114ea8,%ecx
80103327:	83 c4 10             	add    $0x10,%esp
8010332a:	85 c9                	test   %ecx,%ecx
8010332c:	0f 8e 85 00 00 00    	jle    801033b7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103332:	a1 94 4e 11 80       	mov    0x80114e94,%eax
80103337:	83 ec 08             	sub    $0x8,%esp
8010333a:	01 d8                	add    %ebx,%eax
8010333c:	83 c0 01             	add    $0x1,%eax
8010333f:	50                   	push   %eax
80103340:	ff 35 a4 4e 11 80    	pushl  0x80114ea4
80103346:	e8 85 cd ff ff       	call   801000d0 <bread>
8010334b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010334d:	58                   	pop    %eax
8010334e:	5a                   	pop    %edx
8010334f:	ff 34 9d ac 4e 11 80 	pushl  -0x7feeb154(,%ebx,4)
80103356:	ff 35 a4 4e 11 80    	pushl  0x80114ea4
  for (tail = 0; tail < log.lh.n; tail++) {
8010335c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010335f:	e8 6c cd ff ff       	call   801000d0 <bread>
80103364:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103366:	8d 40 5c             	lea    0x5c(%eax),%eax
80103369:	83 c4 0c             	add    $0xc,%esp
8010336c:	68 00 02 00 00       	push   $0x200
80103371:	50                   	push   %eax
80103372:	8d 46 5c             	lea    0x5c(%esi),%eax
80103375:	50                   	push   %eax
80103376:	e8 75 18 00 00       	call   80104bf0 <memmove>
    bwrite(to);  // write the log
8010337b:	89 34 24             	mov    %esi,(%esp)
8010337e:	e8 1d ce ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103383:	89 3c 24             	mov    %edi,(%esp)
80103386:	e8 55 ce ff ff       	call   801001e0 <brelse>
    brelse(to);
8010338b:	89 34 24             	mov    %esi,(%esp)
8010338e:	e8 4d ce ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103393:	83 c4 10             	add    $0x10,%esp
80103396:	3b 1d a8 4e 11 80    	cmp    0x80114ea8,%ebx
8010339c:	7c 94                	jl     80103332 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010339e:	e8 bd fd ff ff       	call   80103160 <write_head>
    install_trans(); // Now install writes to home locations
801033a3:	e8 18 fd ff ff       	call   801030c0 <install_trans>
    log.lh.n = 0;
801033a8:	c7 05 a8 4e 11 80 00 	movl   $0x0,0x80114ea8
801033af:	00 00 00 
    write_head();    // Erase the transaction from the log
801033b2:	e8 a9 fd ff ff       	call   80103160 <write_head>
    acquire(&log.lock);
801033b7:	83 ec 0c             	sub    $0xc,%esp
801033ba:	68 60 4e 11 80       	push   $0x80114e60
801033bf:	e8 6c 16 00 00       	call   80104a30 <acquire>
    wakeup(&log);
801033c4:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
    log.committing = 0;
801033cb:	c7 05 a0 4e 11 80 00 	movl   $0x0,0x80114ea0
801033d2:	00 00 00 
    wakeup(&log);
801033d5:	e8 46 12 00 00       	call   80104620 <wakeup>
    release(&log.lock);
801033da:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
801033e1:	e8 0a 17 00 00       	call   80104af0 <release>
801033e6:	83 c4 10             	add    $0x10,%esp
}
801033e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033ec:	5b                   	pop    %ebx
801033ed:	5e                   	pop    %esi
801033ee:	5f                   	pop    %edi
801033ef:	5d                   	pop    %ebp
801033f0:	c3                   	ret    
801033f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
801033f8:	83 ec 0c             	sub    $0xc,%esp
801033fb:	68 60 4e 11 80       	push   $0x80114e60
80103400:	e8 1b 12 00 00       	call   80104620 <wakeup>
  release(&log.lock);
80103405:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
8010340c:	e8 df 16 00 00       	call   80104af0 <release>
80103411:	83 c4 10             	add    $0x10,%esp
}
80103414:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103417:	5b                   	pop    %ebx
80103418:	5e                   	pop    %esi
80103419:	5f                   	pop    %edi
8010341a:	5d                   	pop    %ebp
8010341b:	c3                   	ret    
    panic("log.committing");
8010341c:	83 ec 0c             	sub    $0xc,%esp
8010341f:	68 84 7b 10 80       	push   $0x80107b84
80103424:	e8 57 d0 ff ff       	call   80100480 <panic>
80103429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103430 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	53                   	push   %ebx
80103434:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103437:	8b 15 a8 4e 11 80    	mov    0x80114ea8,%edx
{
8010343d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103440:	83 fa 1d             	cmp    $0x1d,%edx
80103443:	0f 8f 9d 00 00 00    	jg     801034e6 <log_write+0xb6>
80103449:	a1 98 4e 11 80       	mov    0x80114e98,%eax
8010344e:	83 e8 01             	sub    $0x1,%eax
80103451:	39 c2                	cmp    %eax,%edx
80103453:	0f 8d 8d 00 00 00    	jge    801034e6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103459:	a1 9c 4e 11 80       	mov    0x80114e9c,%eax
8010345e:	85 c0                	test   %eax,%eax
80103460:	0f 8e 8d 00 00 00    	jle    801034f3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103466:	83 ec 0c             	sub    $0xc,%esp
80103469:	68 60 4e 11 80       	push   $0x80114e60
8010346e:	e8 bd 15 00 00       	call   80104a30 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103473:	8b 0d a8 4e 11 80    	mov    0x80114ea8,%ecx
80103479:	83 c4 10             	add    $0x10,%esp
8010347c:	83 f9 00             	cmp    $0x0,%ecx
8010347f:	7e 57                	jle    801034d8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103481:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103484:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103486:	3b 15 ac 4e 11 80    	cmp    0x80114eac,%edx
8010348c:	75 0b                	jne    80103499 <log_write+0x69>
8010348e:	eb 38                	jmp    801034c8 <log_write+0x98>
80103490:	39 14 85 ac 4e 11 80 	cmp    %edx,-0x7feeb154(,%eax,4)
80103497:	74 2f                	je     801034c8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103499:	83 c0 01             	add    $0x1,%eax
8010349c:	39 c1                	cmp    %eax,%ecx
8010349e:	75 f0                	jne    80103490 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801034a0:	89 14 85 ac 4e 11 80 	mov    %edx,-0x7feeb154(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
801034a7:	83 c0 01             	add    $0x1,%eax
801034aa:	a3 a8 4e 11 80       	mov    %eax,0x80114ea8
  b->flags |= B_DIRTY; // prevent eviction
801034af:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801034b2:	c7 45 08 60 4e 11 80 	movl   $0x80114e60,0x8(%ebp)
}
801034b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801034bc:	c9                   	leave  
  release(&log.lock);
801034bd:	e9 2e 16 00 00       	jmp    80104af0 <release>
801034c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801034c8:	89 14 85 ac 4e 11 80 	mov    %edx,-0x7feeb154(,%eax,4)
801034cf:	eb de                	jmp    801034af <log_write+0x7f>
801034d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034d8:	8b 43 08             	mov    0x8(%ebx),%eax
801034db:	a3 ac 4e 11 80       	mov    %eax,0x80114eac
  if (i == log.lh.n)
801034e0:	75 cd                	jne    801034af <log_write+0x7f>
801034e2:	31 c0                	xor    %eax,%eax
801034e4:	eb c1                	jmp    801034a7 <log_write+0x77>
    panic("too big a transaction");
801034e6:	83 ec 0c             	sub    $0xc,%esp
801034e9:	68 93 7b 10 80       	push   $0x80107b93
801034ee:	e8 8d cf ff ff       	call   80100480 <panic>
    panic("log_write outside of trans");
801034f3:	83 ec 0c             	sub    $0xc,%esp
801034f6:	68 a9 7b 10 80       	push   $0x80107ba9
801034fb:	e8 80 cf ff ff       	call   80100480 <panic>

80103500 <mpmain>:
    lapicinit();
    mpmain();
}

// Common CPU setup code.
static void mpmain(void) {
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	53                   	push   %ebx
80103504:	83 ec 04             	sub    $0x4,%esp
    cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103507:	e8 a4 09 00 00       	call   80103eb0 <cpuid>
8010350c:	89 c3                	mov    %eax,%ebx
8010350e:	e8 9d 09 00 00       	call   80103eb0 <cpuid>
80103513:	83 ec 04             	sub    $0x4,%esp
80103516:	53                   	push   %ebx
80103517:	50                   	push   %eax
80103518:	68 c4 7b 10 80       	push   $0x80107bc4
8010351d:	e8 de d2 ff ff       	call   80100800 <cprintf>
    idtinit();       // load idt register
80103522:	e8 a9 29 00 00       	call   80105ed0 <idtinit>
    xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103527:	e8 04 09 00 00       	call   80103e30 <mycpu>
8010352c:	89 c2                	mov    %eax,%edx

static inline uint xchg(volatile uint *addr, uint newval) {
    uint result;

    // The + in "+m" denotes a read-modify-write operand.
    asm volatile ("lock; xchgl %0, %1" :
8010352e:	b8 01 00 00 00       	mov    $0x1,%eax
80103533:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
    scheduler();     // start running processes
8010353a:	e8 51 0c 00 00       	call   80104190 <scheduler>
8010353f:	90                   	nop

80103540 <mpenter>:
static void mpenter(void)  {
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	83 ec 08             	sub    $0x8,%esp
    switchkvm();
80103546:	e8 75 3a 00 00       	call   80106fc0 <switchkvm>
    seginit();
8010354b:	e8 e0 39 00 00       	call   80106f30 <seginit>
    lapicinit();
80103550:	e8 9b f7 ff ff       	call   80102cf0 <lapicinit>
    mpmain();
80103555:	e8 a6 ff ff ff       	call   80103500 <mpmain>
8010355a:	66 90                	xchg   %ax,%ax
8010355c:	66 90                	xchg   %ax,%ax
8010355e:	66 90                	xchg   %ax,%ax

80103560 <main>:
int main(void) {
80103560:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103564:	83 e4 f0             	and    $0xfffffff0,%esp
80103567:	ff 71 fc             	pushl  -0x4(%ecx)
8010356a:	55                   	push   %ebp
8010356b:	89 e5                	mov    %esp,%ebp
8010356d:	53                   	push   %ebx
8010356e:	51                   	push   %ecx
    kinit1(end, P2V(4 * 1024 * 1024)); // phys page allocator
8010356f:	83 ec 08             	sub    $0x8,%esp
80103572:	68 00 00 40 80       	push   $0x80400000
80103577:	68 88 7c 11 80       	push   $0x80117c88
8010357c:	e8 2f f5 ff ff       	call   80102ab0 <kinit1>
    kvmalloc();      // kernel page table
80103581:	e8 0a 3f 00 00       	call   80107490 <kvmalloc>
    mpinit();        // detect other processors
80103586:	e8 75 01 00 00       	call   80103700 <mpinit>
    lapicinit();     // interrupt controller
8010358b:	e8 60 f7 ff ff       	call   80102cf0 <lapicinit>
    seginit();       // segment descriptors
80103590:	e8 9b 39 00 00       	call   80106f30 <seginit>
    picinit();       // disable pic
80103595:	e8 46 03 00 00       	call   801038e0 <picinit>
    ioapicinit();    // another interrupt controller
8010359a:	e8 41 f3 ff ff       	call   801028e0 <ioapicinit>
    consoleinit();   // console hardware
8010359f:	e8 0c d6 ff ff       	call   80100bb0 <consoleinit>
    uartinit();      // serial port
801035a4:	e8 57 2c 00 00       	call   80106200 <uartinit>
    pinit();         // process table
801035a9:	e8 62 08 00 00       	call   80103e10 <pinit>
    tvinit();        // trap vectors
801035ae:	e8 9d 28 00 00       	call   80105e50 <tvinit>
    binit();         // buffer cache
801035b3:	e8 88 ca ff ff       	call   80100040 <binit>
    fileinit();      // file table
801035b8:	e8 63 de ff ff       	call   80101420 <fileinit>
    ideinit();       // disk
801035bd:	e8 fe f0 ff ff       	call   801026c0 <ideinit>

    // Write entry code to unused memory at 0x7000.
    // The linker has placed the image of entryother.S in
    // _binary_entryother_start.
    code = P2V(0x7000);
    memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801035c2:	83 c4 0c             	add    $0xc,%esp
801035c5:	68 7a 00 00 00       	push   $0x7a
801035ca:	68 8c c4 10 80       	push   $0x8010c48c
801035cf:	68 00 70 00 80       	push   $0x80007000
801035d4:	e8 17 16 00 00       	call   80104bf0 <memmove>

    for (c = cpus; c < cpus + ncpu; c++) {
801035d9:	69 05 e0 54 11 80 b0 	imul   $0xb0,0x801154e0,%eax
801035e0:	00 00 00 
801035e3:	83 c4 10             	add    $0x10,%esp
801035e6:	05 60 4f 11 80       	add    $0x80114f60,%eax
801035eb:	3d 60 4f 11 80       	cmp    $0x80114f60,%eax
801035f0:	76 71                	jbe    80103663 <main+0x103>
801035f2:	bb 60 4f 11 80       	mov    $0x80114f60,%ebx
801035f7:	89 f6                	mov    %esi,%esi
801035f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if (c == mycpu()) { // We've started already.
80103600:	e8 2b 08 00 00       	call   80103e30 <mycpu>
80103605:	39 d8                	cmp    %ebx,%eax
80103607:	74 41                	je     8010364a <main+0xea>
        }

        // Tell entryother.S what stack to use, where to enter, and what
        // pgdir to use. We cannot use kpgdir yet, because the AP processor
        // is running in low  memory, so we use entrypgdir for the APs too.
        stack = kalloc();
80103609:	e8 72 f5 ff ff       	call   80102b80 <kalloc>
        *(void**)(code - 4) = stack + KSTACKSIZE;
8010360e:	05 00 10 00 00       	add    $0x1000,%eax
        *(void(**)(void))(code - 8) = mpenter;
80103613:	c7 05 f8 6f 00 80 40 	movl   $0x80103540,0x80006ff8
8010361a:	35 10 80 
        *(int**)(code - 12) = (void *) V2P(entrypgdir);
8010361d:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80103624:	b0 10 00 
        *(void**)(code - 4) = stack + KSTACKSIZE;
80103627:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

        lapicstartap(c->apicid, V2P(code));
8010362c:	0f b6 03             	movzbl (%ebx),%eax
8010362f:	83 ec 08             	sub    $0x8,%esp
80103632:	68 00 70 00 00       	push   $0x7000
80103637:	50                   	push   %eax
80103638:	e8 03 f8 ff ff       	call   80102e40 <lapicstartap>
8010363d:	83 c4 10             	add    $0x10,%esp

        // wait for cpu to finish mpmain()
        while (c->started == 0) {
80103640:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103646:	85 c0                	test   %eax,%eax
80103648:	74 f6                	je     80103640 <main+0xe0>
    for (c = cpus; c < cpus + ncpu; c++) {
8010364a:	69 05 e0 54 11 80 b0 	imul   $0xb0,0x801154e0,%eax
80103651:	00 00 00 
80103654:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010365a:	05 60 4f 11 80       	add    $0x80114f60,%eax
8010365f:	39 c3                	cmp    %eax,%ebx
80103661:	72 9d                	jb     80103600 <main+0xa0>
    kinit2(P2V(4 * 1024 * 1024), P2V(PHYSTOP)); // must come after startothers()
80103663:	83 ec 08             	sub    $0x8,%esp
80103666:	68 00 00 00 8e       	push   $0x8e000000
8010366b:	68 00 00 40 80       	push   $0x80400000
80103670:	e8 ab f4 ff ff       	call   80102b20 <kinit2>
    userinit();      // first user process
80103675:	e8 86 08 00 00       	call   80103f00 <userinit>
    mpmain();        // finish this processor's setup
8010367a:	e8 81 fe ff ff       	call   80103500 <mpmain>
8010367f:	90                   	nop

80103680 <mpsearch1>:
    }
    return sum;
}

// Look for an MP structure in the len bytes at addr.
static struct mp*mpsearch1(uint a, int len) {
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	57                   	push   %edi
80103684:	56                   	push   %esi
    uchar *e, *p, *addr;

    addr = P2V(a);
80103685:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
static struct mp*mpsearch1(uint a, int len) {
8010368b:	53                   	push   %ebx
    e = addr + len;
8010368c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
static struct mp*mpsearch1(uint a, int len) {
8010368f:	83 ec 0c             	sub    $0xc,%esp
    for (p = addr; p < e; p += sizeof(struct mp)) {
80103692:	39 de                	cmp    %ebx,%esi
80103694:	72 10                	jb     801036a6 <mpsearch1+0x26>
80103696:	eb 50                	jmp    801036e8 <mpsearch1+0x68>
80103698:	90                   	nop
80103699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036a0:	39 fb                	cmp    %edi,%ebx
801036a2:	89 fe                	mov    %edi,%esi
801036a4:	76 42                	jbe    801036e8 <mpsearch1+0x68>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0) {
801036a6:	83 ec 04             	sub    $0x4,%esp
801036a9:	8d 7e 10             	lea    0x10(%esi),%edi
801036ac:	6a 04                	push   $0x4
801036ae:	68 d8 7b 10 80       	push   $0x80107bd8
801036b3:	56                   	push   %esi
801036b4:	e8 d7 14 00 00       	call   80104b90 <memcmp>
801036b9:	83 c4 10             	add    $0x10,%esp
801036bc:	85 c0                	test   %eax,%eax
801036be:	75 e0                	jne    801036a0 <mpsearch1+0x20>
801036c0:	89 f1                	mov    %esi,%ecx
801036c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        sum += addr[i];
801036c8:	0f b6 11             	movzbl (%ecx),%edx
801036cb:	83 c1 01             	add    $0x1,%ecx
801036ce:	01 d0                	add    %edx,%eax
    for (i = 0; i < len; i++) {
801036d0:	39 f9                	cmp    %edi,%ecx
801036d2:	75 f4                	jne    801036c8 <mpsearch1+0x48>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0) {
801036d4:	84 c0                	test   %al,%al
801036d6:	75 c8                	jne    801036a0 <mpsearch1+0x20>
            return (struct mp*)p;
        }
    }
    return 0;
}
801036d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036db:	89 f0                	mov    %esi,%eax
801036dd:	5b                   	pop    %ebx
801036de:	5e                   	pop    %esi
801036df:	5f                   	pop    %edi
801036e0:	5d                   	pop    %ebp
801036e1:	c3                   	ret    
801036e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801036eb:	31 f6                	xor    %esi,%esi
}
801036ed:	89 f0                	mov    %esi,%eax
801036ef:	5b                   	pop    %ebx
801036f0:	5e                   	pop    %esi
801036f1:	5f                   	pop    %edi
801036f2:	5d                   	pop    %ebp
801036f3:	c3                   	ret    
801036f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103700 <mpinit>:
    }
    *pmp = mp;
    return conf;
}

void mpinit(void) {
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	57                   	push   %edi
80103704:	56                   	push   %esi
80103705:	53                   	push   %ebx
80103706:	83 ec 1c             	sub    $0x1c,%esp
    if ((p = ((bda[0x0F] << 8) | bda[0x0E]) << 4)) {
80103709:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103710:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103717:	c1 e0 08             	shl    $0x8,%eax
8010371a:	09 d0                	or     %edx,%eax
8010371c:	c1 e0 04             	shl    $0x4,%eax
8010371f:	85 c0                	test   %eax,%eax
80103721:	75 1b                	jne    8010373e <mpinit+0x3e>
        p = ((bda[0x14] << 8) | bda[0x13]) * 1024;
80103723:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010372a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103731:	c1 e0 08             	shl    $0x8,%eax
80103734:	09 d0                	or     %edx,%eax
80103736:	c1 e0 0a             	shl    $0xa,%eax
        if ((mp = mpsearch1(p - 1024, 1024))) {
80103739:	2d 00 04 00 00       	sub    $0x400,%eax
        if ((mp = mpsearch1(p, 1024))) {
8010373e:	ba 00 04 00 00       	mov    $0x400,%edx
80103743:	e8 38 ff ff ff       	call   80103680 <mpsearch1>
80103748:	85 c0                	test   %eax,%eax
8010374a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010374d:	0f 84 3d 01 00 00    	je     80103890 <mpinit+0x190>
    if ((mp = mpsearch()) == 0 || mp->physaddr == 0) {
80103753:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103756:	8b 58 04             	mov    0x4(%eax),%ebx
80103759:	85 db                	test   %ebx,%ebx
8010375b:	0f 84 4f 01 00 00    	je     801038b0 <mpinit+0x1b0>
    conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103761:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
    if (memcmp(conf, "PCMP", 4) != 0) {
80103767:	83 ec 04             	sub    $0x4,%esp
8010376a:	6a 04                	push   $0x4
8010376c:	68 f5 7b 10 80       	push   $0x80107bf5
80103771:	56                   	push   %esi
80103772:	e8 19 14 00 00       	call   80104b90 <memcmp>
80103777:	83 c4 10             	add    $0x10,%esp
8010377a:	85 c0                	test   %eax,%eax
8010377c:	0f 85 2e 01 00 00    	jne    801038b0 <mpinit+0x1b0>
    if (conf->version != 1 && conf->version != 4) {
80103782:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103789:	3c 01                	cmp    $0x1,%al
8010378b:	0f 95 c2             	setne  %dl
8010378e:	3c 04                	cmp    $0x4,%al
80103790:	0f 95 c0             	setne  %al
80103793:	20 c2                	and    %al,%dl
80103795:	0f 85 15 01 00 00    	jne    801038b0 <mpinit+0x1b0>
    if (sum((uchar*)conf, conf->length) != 0) {
8010379b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
    for (i = 0; i < len; i++) {
801037a2:	66 85 ff             	test   %di,%di
801037a5:	74 1a                	je     801037c1 <mpinit+0xc1>
801037a7:	89 f0                	mov    %esi,%eax
801037a9:	01 f7                	add    %esi,%edi
    sum = 0;
801037ab:	31 d2                	xor    %edx,%edx
801037ad:	8d 76 00             	lea    0x0(%esi),%esi
        sum += addr[i];
801037b0:	0f b6 08             	movzbl (%eax),%ecx
801037b3:	83 c0 01             	add    $0x1,%eax
801037b6:	01 ca                	add    %ecx,%edx
    for (i = 0; i < len; i++) {
801037b8:	39 c7                	cmp    %eax,%edi
801037ba:	75 f4                	jne    801037b0 <mpinit+0xb0>
801037bc:	84 d2                	test   %dl,%dl
801037be:	0f 95 c2             	setne  %dl
    struct mp *mp;
    struct mpconf *conf;
    struct mpproc *proc;
    struct mpioapic *ioapic;

    if ((conf = mpconfig(&mp)) == 0) {
801037c1:	85 f6                	test   %esi,%esi
801037c3:	0f 84 e7 00 00 00    	je     801038b0 <mpinit+0x1b0>
801037c9:	84 d2                	test   %dl,%dl
801037cb:	0f 85 df 00 00 00    	jne    801038b0 <mpinit+0x1b0>
        panic("Expect to run on an SMP");
    }
    ismp = 1;
    lapic = (uint*)conf->lapicaddr;
801037d1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801037d7:	a3 5c 4e 11 80       	mov    %eax,0x80114e5c
    for (p = (uchar*)(conf + 1), e = (uchar*)conf + conf->length; p < e;) {
801037dc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801037e3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
    ismp = 1;
801037e9:	bb 01 00 00 00       	mov    $0x1,%ebx
    for (p = (uchar*)(conf + 1), e = (uchar*)conf + conf->length; p < e;) {
801037ee:	01 d6                	add    %edx,%esi
801037f0:	39 c6                	cmp    %eax,%esi
801037f2:	76 23                	jbe    80103817 <mpinit+0x117>
        switch (*p) {
801037f4:	0f b6 10             	movzbl (%eax),%edx
801037f7:	80 fa 04             	cmp    $0x4,%dl
801037fa:	0f 87 ca 00 00 00    	ja     801038ca <mpinit+0x1ca>
80103800:	ff 24 95 1c 7c 10 80 	jmp    *-0x7fef83e4(,%edx,4)
80103807:	89 f6                	mov    %esi,%esi
80103809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                p += sizeof(struct mpioapic);
                continue;
            case MPBUS:
            case MPIOINTR:
            case MPLINTR:
                p += 8;
80103810:	83 c0 08             	add    $0x8,%eax
    for (p = (uchar*)(conf + 1), e = (uchar*)conf + conf->length; p < e;) {
80103813:	39 c6                	cmp    %eax,%esi
80103815:	77 dd                	ja     801037f4 <mpinit+0xf4>
            default:
                ismp = 0;
                break;
        }
    }
    if (!ismp) {
80103817:	85 db                	test   %ebx,%ebx
80103819:	0f 84 9e 00 00 00    	je     801038bd <mpinit+0x1bd>
        panic("Didn't find a suitable machine");
    }

    if (mp->imcrp) {
8010381f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103822:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103826:	74 15                	je     8010383d <mpinit+0x13d>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80103828:	b8 70 00 00 00       	mov    $0x70,%eax
8010382d:	ba 22 00 00 00       	mov    $0x22,%edx
80103832:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80103833:	ba 23 00 00 00       	mov    $0x23,%edx
80103838:	ec                   	in     (%dx),%al
        // Bochs doesn't support IMCR, so this doesn't run on Bochs.
        // But it would on real hardware.
        outb(0x22, 0x70);   // Select IMCR
        outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103839:	83 c8 01             	or     $0x1,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
8010383c:	ee                   	out    %al,(%dx)
    }
}
8010383d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103840:	5b                   	pop    %ebx
80103841:	5e                   	pop    %esi
80103842:	5f                   	pop    %edi
80103843:	5d                   	pop    %ebp
80103844:	c3                   	ret    
80103845:	8d 76 00             	lea    0x0(%esi),%esi
                if (ncpu < NCPU) {
80103848:	8b 0d e0 54 11 80    	mov    0x801154e0,%ecx
8010384e:	83 f9 07             	cmp    $0x7,%ecx
80103851:	7f 19                	jg     8010386c <mpinit+0x16c>
                    cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103853:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103857:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
                    ncpu++;
8010385d:	83 c1 01             	add    $0x1,%ecx
80103860:	89 0d e0 54 11 80    	mov    %ecx,0x801154e0
                    cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103866:	88 97 60 4f 11 80    	mov    %dl,-0x7feeb0a0(%edi)
                p += sizeof(struct mpproc);
8010386c:	83 c0 14             	add    $0x14,%eax
                continue;
8010386f:	e9 7c ff ff ff       	jmp    801037f0 <mpinit+0xf0>
80103874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                ioapicid = ioapic->apicno;
80103878:	0f b6 50 01          	movzbl 0x1(%eax),%edx
                p += sizeof(struct mpioapic);
8010387c:	83 c0 08             	add    $0x8,%eax
                ioapicid = ioapic->apicno;
8010387f:	88 15 40 4f 11 80    	mov    %dl,0x80114f40
                continue;
80103885:	e9 66 ff ff ff       	jmp    801037f0 <mpinit+0xf0>
8010388a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return mpsearch1(0xF0000, 0x10000);
80103890:	ba 00 00 01 00       	mov    $0x10000,%edx
80103895:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010389a:	e8 e1 fd ff ff       	call   80103680 <mpsearch1>
    if ((mp = mpsearch()) == 0 || mp->physaddr == 0) {
8010389f:	85 c0                	test   %eax,%eax
    return mpsearch1(0xF0000, 0x10000);
801038a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if ((mp = mpsearch()) == 0 || mp->physaddr == 0) {
801038a4:	0f 85 a9 fe ff ff    	jne    80103753 <mpinit+0x53>
801038aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        panic("Expect to run on an SMP");
801038b0:	83 ec 0c             	sub    $0xc,%esp
801038b3:	68 dd 7b 10 80       	push   $0x80107bdd
801038b8:	e8 c3 cb ff ff       	call   80100480 <panic>
        panic("Didn't find a suitable machine");
801038bd:	83 ec 0c             	sub    $0xc,%esp
801038c0:	68 fc 7b 10 80       	push   $0x80107bfc
801038c5:	e8 b6 cb ff ff       	call   80100480 <panic>
                ismp = 0;
801038ca:	31 db                	xor    %ebx,%ebx
801038cc:	e9 26 ff ff ff       	jmp    801037f7 <mpinit+0xf7>
801038d1:	66 90                	xchg   %ax,%ax
801038d3:	66 90                	xchg   %ax,%ax
801038d5:	66 90                	xchg   %ax,%ax
801038d7:	66 90                	xchg   %ax,%ax
801038d9:	66 90                	xchg   %ax,%ax
801038db:	66 90                	xchg   %ax,%ax
801038dd:	66 90                	xchg   %ax,%ax
801038df:	90                   	nop

801038e0 <picinit>:
// I/O Addresses of the two programmable interrupt controllers
#define IO_PIC1         0x20    // Master (IRQs 0-7)
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void picinit(void) {
801038e0:	55                   	push   %ebp
801038e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038e6:	ba 21 00 00 00       	mov    $0x21,%edx
801038eb:	89 e5                	mov    %esp,%ebp
801038ed:	ee                   	out    %al,(%dx)
801038ee:	ba a1 00 00 00       	mov    $0xa1,%edx
801038f3:	ee                   	out    %al,(%dx)
    // mask all interrupts
    outb(IO_PIC1 + 1, 0xFF);
    outb(IO_PIC2 + 1, 0xFF);
}
801038f4:	5d                   	pop    %ebp
801038f5:	c3                   	ret    
801038f6:	66 90                	xchg   %ax,%ax
801038f8:	66 90                	xchg   %ax,%ax
801038fa:	66 90                	xchg   %ax,%ax
801038fc:	66 90                	xchg   %ax,%ax
801038fe:	66 90                	xchg   %ax,%ax

80103900 <cleanuppipealloc>:
    uint nwrite;    // number of bytes written
    int readopen;   // read fd is still open
    int writeopen;  // write fd is still open
};

void cleanuppipealloc(struct pipe *p, struct file **f0, struct file **f1) {
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	56                   	push   %esi
80103904:	53                   	push   %ebx
80103905:	8b 45 08             	mov    0x8(%ebp),%eax
80103908:	8b 75 0c             	mov    0xc(%ebp),%esi
8010390b:	8b 5d 10             	mov    0x10(%ebp),%ebx
     if (p) {
8010390e:	85 c0                	test   %eax,%eax
80103910:	74 0c                	je     8010391e <cleanuppipealloc+0x1e>
        kfree((char*)p);
80103912:	83 ec 0c             	sub    $0xc,%esp
80103915:	50                   	push   %eax
80103916:	e8 b5 f0 ff ff       	call   801029d0 <kfree>
8010391b:	83 c4 10             	add    $0x10,%esp
    }
    if (*f0) {
8010391e:	8b 06                	mov    (%esi),%eax
80103920:	85 c0                	test   %eax,%eax
80103922:	74 0c                	je     80103930 <cleanuppipealloc+0x30>
        fileclose(*f0);
80103924:	83 ec 0c             	sub    $0xc,%esp
80103927:	50                   	push   %eax
80103928:	e8 d3 db ff ff       	call   80101500 <fileclose>
8010392d:	83 c4 10             	add    $0x10,%esp
    }
    if (*f1) {
80103930:	8b 03                	mov    (%ebx),%eax
80103932:	85 c0                	test   %eax,%eax
80103934:	74 12                	je     80103948 <cleanuppipealloc+0x48>
        fileclose(*f1);
80103936:	89 45 08             	mov    %eax,0x8(%ebp)
    }   
}
80103939:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010393c:	5b                   	pop    %ebx
8010393d:	5e                   	pop    %esi
8010393e:	5d                   	pop    %ebp
        fileclose(*f1);
8010393f:	e9 bc db ff ff       	jmp    80101500 <fileclose>
80103944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80103948:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010394b:	5b                   	pop    %ebx
8010394c:	5e                   	pop    %esi
8010394d:	5d                   	pop    %ebp
8010394e:	c3                   	ret    
8010394f:	90                   	nop

80103950 <pipealloc>:

int pipealloc(struct file **f0, struct file **f1) {
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	57                   	push   %edi
80103954:	56                   	push   %esi
80103955:	53                   	push   %ebx
80103956:	83 ec 0c             	sub    $0xc,%esp
80103959:	8b 75 08             	mov    0x8(%ebp),%esi
8010395c:	8b 7d 0c             	mov    0xc(%ebp),%edi
    struct pipe *p;

    p = 0;
    *f0 = *f1 = 0;
8010395f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103965:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) {
8010396b:	e8 d0 da ff ff       	call   80101440 <filealloc>
80103970:	85 c0                	test   %eax,%eax
80103972:	89 06                	mov    %eax,(%esi)
80103974:	0f 84 96 00 00 00    	je     80103a10 <pipealloc+0xc0>
8010397a:	e8 c1 da ff ff       	call   80101440 <filealloc>
8010397f:	85 c0                	test   %eax,%eax
80103981:	89 07                	mov    %eax,(%edi)
80103983:	0f 84 87 00 00 00    	je     80103a10 <pipealloc+0xc0>
        cleanuppipealloc(p, f0, f1);
        return -1;
    }
    if ((p = (struct pipe*)kalloc()) == 0) {
80103989:	e8 f2 f1 ff ff       	call   80102b80 <kalloc>
8010398e:	85 c0                	test   %eax,%eax
80103990:	89 c3                	mov    %eax,%ebx
80103992:	74 7c                	je     80103a10 <pipealloc+0xc0>
    }
    p->readopen = 1;
    p->writeopen = 1;
    p->nwrite = 0;
    p->nread = 0;
    initlock(&p->lock, "pipe");
80103994:	83 ec 08             	sub    $0x8,%esp
    p->readopen = 1;
80103997:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010399e:	00 00 00 
    p->writeopen = 1;
801039a1:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801039a8:	00 00 00 
    p->nwrite = 0;
801039ab:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801039b2:	00 00 00 
    p->nread = 0;
801039b5:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801039bc:	00 00 00 
    initlock(&p->lock, "pipe");
801039bf:	68 30 7c 10 80       	push   $0x80107c30
801039c4:	50                   	push   %eax
801039c5:	e8 26 0f 00 00       	call   801048f0 <initlock>
    (*f0)->type = FD_PIPE;
801039ca:	8b 06                	mov    (%esi),%eax
    (*f0)->pipe = p;
    (*f1)->type = FD_PIPE;
    (*f1)->readable = 0;
    (*f1)->writable = 1;
    (*f1)->pipe = p;
    return 0;
801039cc:	83 c4 10             	add    $0x10,%esp
    (*f0)->type = FD_PIPE;
801039cf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    (*f0)->readable = 1;
801039d5:	8b 06                	mov    (%esi),%eax
801039d7:	c6 40 08 01          	movb   $0x1,0x8(%eax)
    (*f0)->writable = 0;
801039db:	8b 06                	mov    (%esi),%eax
801039dd:	c6 40 09 00          	movb   $0x0,0x9(%eax)
    (*f0)->pipe = p;
801039e1:	8b 06                	mov    (%esi),%eax
801039e3:	89 58 0c             	mov    %ebx,0xc(%eax)
    (*f1)->type = FD_PIPE;
801039e6:	8b 07                	mov    (%edi),%eax
801039e8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    (*f1)->readable = 0;
801039ee:	8b 07                	mov    (%edi),%eax
801039f0:	c6 40 08 00          	movb   $0x0,0x8(%eax)
    (*f1)->writable = 1;
801039f4:	8b 07                	mov    (%edi),%eax
801039f6:	c6 40 09 01          	movb   $0x1,0x9(%eax)
    (*f1)->pipe = p;
801039fa:	8b 07                	mov    (%edi),%eax
801039fc:	89 58 0c             	mov    %ebx,0xc(%eax)
    return 0;
801039ff:	31 c0                	xor    %eax,%eax
}
80103a01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a04:	5b                   	pop    %ebx
80103a05:	5e                   	pop    %esi
80103a06:	5f                   	pop    %edi
80103a07:	5d                   	pop    %ebp
80103a08:	c3                   	ret    
80103a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cleanuppipealloc(p, f0, f1);
80103a10:	83 ec 04             	sub    $0x4,%esp
80103a13:	57                   	push   %edi
80103a14:	56                   	push   %esi
80103a15:	6a 00                	push   $0x0
80103a17:	e8 e4 fe ff ff       	call   80103900 <cleanuppipealloc>
        return -1;
80103a1c:	83 c4 10             	add    $0x10,%esp
80103a1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a24:	eb db                	jmp    80103a01 <pipealloc+0xb1>
80103a26:	8d 76 00             	lea    0x0(%esi),%esi
80103a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a30 <pipeclose>:

void pipeclose(struct pipe *p, int writable) {
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	56                   	push   %esi
80103a34:	53                   	push   %ebx
80103a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a38:	8b 75 0c             	mov    0xc(%ebp),%esi
    acquire(&p->lock);
80103a3b:	83 ec 0c             	sub    $0xc,%esp
80103a3e:	53                   	push   %ebx
80103a3f:	e8 ec 0f 00 00       	call   80104a30 <acquire>
    if (writable) {
80103a44:	83 c4 10             	add    $0x10,%esp
80103a47:	85 f6                	test   %esi,%esi
80103a49:	74 45                	je     80103a90 <pipeclose+0x60>
        p->writeopen = 0;
        wakeup(&p->nread);
80103a4b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103a51:	83 ec 0c             	sub    $0xc,%esp
        p->writeopen = 0;
80103a54:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103a5b:	00 00 00 
        wakeup(&p->nread);
80103a5e:	50                   	push   %eax
80103a5f:	e8 bc 0b 00 00       	call   80104620 <wakeup>
80103a64:	83 c4 10             	add    $0x10,%esp
    }
    else {
        p->readopen = 0;
        wakeup(&p->nwrite);
    }
    if (p->readopen == 0 && p->writeopen == 0) {
80103a67:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103a6d:	85 d2                	test   %edx,%edx
80103a6f:	75 0a                	jne    80103a7b <pipeclose+0x4b>
80103a71:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103a77:	85 c0                	test   %eax,%eax
80103a79:	74 35                	je     80103ab0 <pipeclose+0x80>
        release(&p->lock);
        kfree((char*)p);
    }
    else {
        release(&p->lock);
80103a7b:	89 5d 08             	mov    %ebx,0x8(%ebp)
    }
}
80103a7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a81:	5b                   	pop    %ebx
80103a82:	5e                   	pop    %esi
80103a83:	5d                   	pop    %ebp
        release(&p->lock);
80103a84:	e9 67 10 00 00       	jmp    80104af0 <release>
80103a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        wakeup(&p->nwrite);
80103a90:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103a96:	83 ec 0c             	sub    $0xc,%esp
        p->readopen = 0;
80103a99:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103aa0:	00 00 00 
        wakeup(&p->nwrite);
80103aa3:	50                   	push   %eax
80103aa4:	e8 77 0b 00 00       	call   80104620 <wakeup>
80103aa9:	83 c4 10             	add    $0x10,%esp
80103aac:	eb b9                	jmp    80103a67 <pipeclose+0x37>
80103aae:	66 90                	xchg   %ax,%ax
        release(&p->lock);
80103ab0:	83 ec 0c             	sub    $0xc,%esp
80103ab3:	53                   	push   %ebx
80103ab4:	e8 37 10 00 00       	call   80104af0 <release>
        kfree((char*)p);
80103ab9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103abc:	83 c4 10             	add    $0x10,%esp
}
80103abf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ac2:	5b                   	pop    %ebx
80103ac3:	5e                   	pop    %esi
80103ac4:	5d                   	pop    %ebp
        kfree((char*)p);
80103ac5:	e9 06 ef ff ff       	jmp    801029d0 <kfree>
80103aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ad0 <pipewrite>:

int pipewrite(struct pipe *p, char *addr, int n) {
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	57                   	push   %edi
80103ad4:	56                   	push   %esi
80103ad5:	53                   	push   %ebx
80103ad6:	83 ec 28             	sub    $0x28,%esp
80103ad9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int i;

    acquire(&p->lock);
80103adc:	53                   	push   %ebx
80103add:	e8 4e 0f 00 00       	call   80104a30 <acquire>
    for (i = 0; i < n; i++) {
80103ae2:	8b 45 10             	mov    0x10(%ebp),%eax
80103ae5:	83 c4 10             	add    $0x10,%esp
80103ae8:	85 c0                	test   %eax,%eax
80103aea:	0f 8e c9 00 00 00    	jle    80103bb9 <pipewrite+0xe9>
80103af0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103af3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
        while (p->nwrite == p->nread + PIPESIZE) { //DOC: pipewrite-full
            if (p->readopen == 0 || myproc()->killed) {
                release(&p->lock);
                return -1;
            }
            wakeup(&p->nread);
80103af9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103aff:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103b02:	03 4d 10             	add    0x10(%ebp),%ecx
80103b05:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        while (p->nwrite == p->nread + PIPESIZE) { //DOC: pipewrite-full
80103b08:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103b0e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103b14:	39 d0                	cmp    %edx,%eax
80103b16:	75 71                	jne    80103b89 <pipewrite+0xb9>
            if (p->readopen == 0 || myproc()->killed) {
80103b18:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103b1e:	85 c0                	test   %eax,%eax
80103b20:	74 4e                	je     80103b70 <pipewrite+0xa0>
            sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103b22:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103b28:	eb 3a                	jmp    80103b64 <pipewrite+0x94>
80103b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            wakeup(&p->nread);
80103b30:	83 ec 0c             	sub    $0xc,%esp
80103b33:	57                   	push   %edi
80103b34:	e8 e7 0a 00 00       	call   80104620 <wakeup>
            sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103b39:	5a                   	pop    %edx
80103b3a:	59                   	pop    %ecx
80103b3b:	53                   	push   %ebx
80103b3c:	56                   	push   %esi
80103b3d:	e8 2e 09 00 00       	call   80104470 <sleep>
        while (p->nwrite == p->nread + PIPESIZE) { //DOC: pipewrite-full
80103b42:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103b48:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103b4e:	83 c4 10             	add    $0x10,%esp
80103b51:	05 00 02 00 00       	add    $0x200,%eax
80103b56:	39 c2                	cmp    %eax,%edx
80103b58:	75 36                	jne    80103b90 <pipewrite+0xc0>
            if (p->readopen == 0 || myproc()->killed) {
80103b5a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103b60:	85 c0                	test   %eax,%eax
80103b62:	74 0c                	je     80103b70 <pipewrite+0xa0>
80103b64:	e8 67 03 00 00       	call   80103ed0 <myproc>
80103b69:	8b 40 24             	mov    0x24(%eax),%eax
80103b6c:	85 c0                	test   %eax,%eax
80103b6e:	74 c0                	je     80103b30 <pipewrite+0x60>
                release(&p->lock);
80103b70:	83 ec 0c             	sub    $0xc,%esp
80103b73:	53                   	push   %ebx
80103b74:	e8 77 0f 00 00       	call   80104af0 <release>
                return -1;
80103b79:	83 c4 10             	add    $0x10,%esp
80103b7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        p->data[p->nwrite++ % PIPESIZE] = addr[i];
    }
    wakeup(&p->nread);  //DOC: pipewrite-wakeup1
    release(&p->lock);
    return n;
}
80103b81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b84:	5b                   	pop    %ebx
80103b85:	5e                   	pop    %esi
80103b86:	5f                   	pop    %edi
80103b87:	5d                   	pop    %ebp
80103b88:	c3                   	ret    
        while (p->nwrite == p->nread + PIPESIZE) { //DOC: pipewrite-full
80103b89:	89 c2                	mov    %eax,%edx
80103b8b:	90                   	nop
80103b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b90:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103b93:	8d 42 01             	lea    0x1(%edx),%eax
80103b96:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103b9c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103ba2:	83 c6 01             	add    $0x1,%esi
80103ba5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
    for (i = 0; i < n; i++) {
80103ba9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103bac:	89 75 e4             	mov    %esi,-0x1c(%ebp)
        p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103baf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
    for (i = 0; i < n; i++) {
80103bb3:	0f 85 4f ff ff ff    	jne    80103b08 <pipewrite+0x38>
    wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103bb9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103bbf:	83 ec 0c             	sub    $0xc,%esp
80103bc2:	50                   	push   %eax
80103bc3:	e8 58 0a 00 00       	call   80104620 <wakeup>
    release(&p->lock);
80103bc8:	89 1c 24             	mov    %ebx,(%esp)
80103bcb:	e8 20 0f 00 00       	call   80104af0 <release>
    return n;
80103bd0:	83 c4 10             	add    $0x10,%esp
80103bd3:	8b 45 10             	mov    0x10(%ebp),%eax
80103bd6:	eb a9                	jmp    80103b81 <pipewrite+0xb1>
80103bd8:	90                   	nop
80103bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103be0 <piperead>:

int piperead(struct pipe *p, char *addr, int n)     {
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	57                   	push   %edi
80103be4:	56                   	push   %esi
80103be5:	53                   	push   %ebx
80103be6:	83 ec 18             	sub    $0x18,%esp
80103be9:	8b 75 08             	mov    0x8(%ebp),%esi
80103bec:	8b 7d 0c             	mov    0xc(%ebp),%edi
    int i;

    acquire(&p->lock);
80103bef:	56                   	push   %esi
80103bf0:	e8 3b 0e 00 00       	call   80104a30 <acquire>
    while (p->nread == p->nwrite && p->writeopen) { //DOC: pipe-empty
80103bf5:	83 c4 10             	add    $0x10,%esp
80103bf8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103bfe:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103c04:	75 6a                	jne    80103c70 <piperead+0x90>
80103c06:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103c0c:	85 db                	test   %ebx,%ebx
80103c0e:	0f 84 c4 00 00 00    	je     80103cd8 <piperead+0xf8>
        if (myproc()->killed) {
            release(&p->lock);
            return -1;
        }
        sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103c14:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103c1a:	eb 2d                	jmp    80103c49 <piperead+0x69>
80103c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c20:	83 ec 08             	sub    $0x8,%esp
80103c23:	56                   	push   %esi
80103c24:	53                   	push   %ebx
80103c25:	e8 46 08 00 00       	call   80104470 <sleep>
    while (p->nread == p->nwrite && p->writeopen) { //DOC: pipe-empty
80103c2a:	83 c4 10             	add    $0x10,%esp
80103c2d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103c33:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103c39:	75 35                	jne    80103c70 <piperead+0x90>
80103c3b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103c41:	85 d2                	test   %edx,%edx
80103c43:	0f 84 8f 00 00 00    	je     80103cd8 <piperead+0xf8>
        if (myproc()->killed) {
80103c49:	e8 82 02 00 00       	call   80103ed0 <myproc>
80103c4e:	8b 48 24             	mov    0x24(%eax),%ecx
80103c51:	85 c9                	test   %ecx,%ecx
80103c53:	74 cb                	je     80103c20 <piperead+0x40>
            release(&p->lock);
80103c55:	83 ec 0c             	sub    $0xc,%esp
            return -1;
80103c58:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
            release(&p->lock);
80103c5d:	56                   	push   %esi
80103c5e:	e8 8d 0e 00 00       	call   80104af0 <release>
            return -1;
80103c63:	83 c4 10             	add    $0x10,%esp
        addr[i] = p->data[p->nread++ % PIPESIZE];
    }
    wakeup(&p->nwrite);  //DOC: piperead-wakeup
    release(&p->lock);
    return i;
}
80103c66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c69:	89 d8                	mov    %ebx,%eax
80103c6b:	5b                   	pop    %ebx
80103c6c:	5e                   	pop    %esi
80103c6d:	5f                   	pop    %edi
80103c6e:	5d                   	pop    %ebp
80103c6f:	c3                   	ret    
    for (i = 0; i < n; i++) {  //DOC: piperead-copy
80103c70:	8b 45 10             	mov    0x10(%ebp),%eax
80103c73:	85 c0                	test   %eax,%eax
80103c75:	7e 61                	jle    80103cd8 <piperead+0xf8>
        if (p->nread == p->nwrite) {
80103c77:	31 db                	xor    %ebx,%ebx
80103c79:	eb 13                	jmp    80103c8e <piperead+0xae>
80103c7b:	90                   	nop
80103c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c80:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103c86:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103c8c:	74 1f                	je     80103cad <piperead+0xcd>
        addr[i] = p->data[p->nread++ % PIPESIZE];
80103c8e:	8d 41 01             	lea    0x1(%ecx),%eax
80103c91:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103c97:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103c9d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103ca2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    for (i = 0; i < n; i++) {  //DOC: piperead-copy
80103ca5:	83 c3 01             	add    $0x1,%ebx
80103ca8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103cab:	75 d3                	jne    80103c80 <piperead+0xa0>
    wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103cad:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103cb3:	83 ec 0c             	sub    $0xc,%esp
80103cb6:	50                   	push   %eax
80103cb7:	e8 64 09 00 00       	call   80104620 <wakeup>
    release(&p->lock);
80103cbc:	89 34 24             	mov    %esi,(%esp)
80103cbf:	e8 2c 0e 00 00       	call   80104af0 <release>
    return i;
80103cc4:	83 c4 10             	add    $0x10,%esp
}
80103cc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cca:	89 d8                	mov    %ebx,%eax
80103ccc:	5b                   	pop    %ebx
80103ccd:	5e                   	pop    %esi
80103cce:	5f                   	pop    %edi
80103ccf:	5d                   	pop    %ebp
80103cd0:	c3                   	ret    
80103cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cd8:	31 db                	xor    %ebx,%ebx
80103cda:	eb d1                	jmp    80103cad <piperead+0xcd>
80103cdc:	66 90                	xchg   %ax,%ax
80103cde:	66 90                	xchg   %ax,%ax

80103ce0 <allocproc>:

// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc* allocproc(void) {
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	53                   	push   %ebx
80103ce4:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;
    char *sp;
    int found = 0;

    acquire(&ptable.lock);
80103ce7:	68 00 55 11 80       	push   $0x80115500
80103cec:	e8 3f 0d 00 00       	call   80104a30 <acquire>

    p = ptable.proc;
    while (p < &ptable.proc[NPROC] && !found) {
        if (p->state == UNUSED) {
80103cf1:	8b 15 40 55 11 80    	mov    0x80115540,%edx
80103cf7:	83 c4 10             	add    $0x10,%esp
80103cfa:	85 d2                	test   %edx,%edx
80103cfc:	74 3a                	je     80103d38 <allocproc+0x58>
            found = 1;
        }
        else {
            p++;
80103cfe:	bb b0 55 11 80       	mov    $0x801155b0,%ebx
80103d03:	90                   	nop
80103d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->state == UNUSED) {
80103d08:	8b 43 0c             	mov    0xc(%ebx),%eax
80103d0b:	85 c0                	test   %eax,%eax
80103d0d:	74 31                	je     80103d40 <allocproc+0x60>
            p++;
80103d0f:	83 c3 7c             	add    $0x7c,%ebx
    while (p < &ptable.proc[NPROC] && !found) {
80103d12:	81 fb 34 74 11 80    	cmp    $0x80117434,%ebx
80103d18:	72 ee                	jb     80103d08 <allocproc+0x28>
        }
       
    }
    if (!found) {    
        release(&ptable.lock);
80103d1a:	83 ec 0c             	sub    $0xc,%esp
        return 0;
80103d1d:	31 db                	xor    %ebx,%ebx
        release(&ptable.lock);
80103d1f:	68 00 55 11 80       	push   $0x80115500
80103d24:	e8 c7 0d 00 00       	call   80104af0 <release>
        return 0;
80103d29:	83 c4 10             	add    $0x10,%esp
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint)forkret;

    return p;
}
80103d2c:	89 d8                	mov    %ebx,%eax
80103d2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d31:	c9                   	leave  
80103d32:	c3                   	ret    
80103d33:	90                   	nop
80103d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p = ptable.proc;
80103d38:	bb 34 55 11 80       	mov    $0x80115534,%ebx
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi
    p->pid = nextpid++;
80103d40:	a1 04 c0 10 80       	mov    0x8010c004,%eax
    release(&ptable.lock);
80103d45:	83 ec 0c             	sub    $0xc,%esp
    p->state = EMBRYO;
80103d48:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;
80103d4f:	8d 50 01             	lea    0x1(%eax),%edx
80103d52:	89 43 10             	mov    %eax,0x10(%ebx)
    release(&ptable.lock);
80103d55:	68 00 55 11 80       	push   $0x80115500
    p->pid = nextpid++;
80103d5a:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
    release(&ptable.lock);
80103d60:	e8 8b 0d 00 00       	call   80104af0 <release>
    if ((p->kstack = kalloc()) == 0) {
80103d65:	e8 16 ee ff ff       	call   80102b80 <kalloc>
80103d6a:	83 c4 10             	add    $0x10,%esp
80103d6d:	85 c0                	test   %eax,%eax
80103d6f:	89 43 08             	mov    %eax,0x8(%ebx)
80103d72:	74 3c                	je     80103db0 <allocproc+0xd0>
    sp -= sizeof *p->tf;
80103d74:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    memset(p->context, 0, sizeof *p->context);
80103d7a:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *p->context;
80103d7d:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *p->tf;
80103d82:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint*)sp = (uint)trapret;
80103d85:	c7 40 14 38 5e 10 80 	movl   $0x80105e38,0x14(%eax)
    p->context = (struct context*)sp;
80103d8c:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103d8f:	6a 14                	push   $0x14
80103d91:	6a 00                	push   $0x0
80103d93:	50                   	push   %eax
80103d94:	e8 a7 0d 00 00       	call   80104b40 <memset>
    p->context->eip = (uint)forkret;
80103d99:	8b 43 1c             	mov    0x1c(%ebx),%eax
    return p;
80103d9c:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint)forkret;
80103d9f:	c7 40 10 c0 3d 10 80 	movl   $0x80103dc0,0x10(%eax)
}
80103da6:	89 d8                	mov    %ebx,%eax
80103da8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dab:	c9                   	leave  
80103dac:	c3                   	ret    
80103dad:	8d 76 00             	lea    0x0(%esi),%esi
        p->state = UNUSED;
80103db0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
80103db7:	31 db                	xor    %ebx,%ebx
80103db9:	e9 6e ff ff ff       	jmp    80103d2c <allocproc+0x4c>
80103dbe:	66 90                	xchg   %ax,%ax

80103dc0 <forkret>:
    release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void) {
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103dc6:	68 00 55 11 80       	push   $0x80115500
80103dcb:	e8 20 0d 00 00       	call   80104af0 <release>

    if (first) {
80103dd0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103dd5:	83 c4 10             	add    $0x10,%esp
80103dd8:	85 c0                	test   %eax,%eax
80103dda:	75 04                	jne    80103de0 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103ddc:	c9                   	leave  
80103ddd:	c3                   	ret    
80103dde:	66 90                	xchg   %ax,%ax
        iinit(ROOTDEV);
80103de0:	83 ec 0c             	sub    $0xc,%esp
        first = 0;
80103de3:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103dea:	00 00 00 
        iinit(ROOTDEV);
80103ded:	6a 01                	push   $0x1
80103def:	e8 4c dd ff ff       	call   80101b40 <iinit>
        initlog(ROOTDEV);
80103df4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103dfb:	e8 c0 f3 ff ff       	call   801031c0 <initlog>
80103e00:	83 c4 10             	add    $0x10,%esp
}
80103e03:	c9                   	leave  
80103e04:	c3                   	ret    
80103e05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e10 <pinit>:
void pinit(void) {
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
80103e16:	68 35 7c 10 80       	push   $0x80107c35
80103e1b:	68 00 55 11 80       	push   $0x80115500
80103e20:	e8 cb 0a 00 00       	call   801048f0 <initlock>
}
80103e25:	83 c4 10             	add    $0x10,%esp
80103e28:	c9                   	leave  
80103e29:	c3                   	ret    
80103e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e30 <mycpu>:
struct cpu*mycpu(void)  {
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	56                   	push   %esi
80103e34:	53                   	push   %ebx
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
80103e35:	9c                   	pushf  
80103e36:	58                   	pop    %eax
    if (readeflags() & FL_IF) {
80103e37:	f6 c4 02             	test   $0x2,%ah
80103e3a:	75 5e                	jne    80103e9a <mycpu+0x6a>
    apicid = lapicid();
80103e3c:	e8 af ef ff ff       	call   80102df0 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80103e41:	8b 35 e0 54 11 80    	mov    0x801154e0,%esi
80103e47:	85 f6                	test   %esi,%esi
80103e49:	7e 42                	jle    80103e8d <mycpu+0x5d>
        if (cpus[i].apicid == apicid) {
80103e4b:	0f b6 15 60 4f 11 80 	movzbl 0x80114f60,%edx
80103e52:	39 d0                	cmp    %edx,%eax
80103e54:	74 30                	je     80103e86 <mycpu+0x56>
80103e56:	b9 10 50 11 80       	mov    $0x80115010,%ecx
    for (i = 0; i < ncpu; ++i) {
80103e5b:	31 d2                	xor    %edx,%edx
80103e5d:	8d 76 00             	lea    0x0(%esi),%esi
80103e60:	83 c2 01             	add    $0x1,%edx
80103e63:	39 f2                	cmp    %esi,%edx
80103e65:	74 26                	je     80103e8d <mycpu+0x5d>
        if (cpus[i].apicid == apicid) {
80103e67:	0f b6 19             	movzbl (%ecx),%ebx
80103e6a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103e70:	39 c3                	cmp    %eax,%ebx
80103e72:	75 ec                	jne    80103e60 <mycpu+0x30>
80103e74:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103e7a:	05 60 4f 11 80       	add    $0x80114f60,%eax
}
80103e7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e82:	5b                   	pop    %ebx
80103e83:	5e                   	pop    %esi
80103e84:	5d                   	pop    %ebp
80103e85:	c3                   	ret    
        if (cpus[i].apicid == apicid) {
80103e86:	b8 60 4f 11 80       	mov    $0x80114f60,%eax
            return &cpus[i];
80103e8b:	eb f2                	jmp    80103e7f <mycpu+0x4f>
    panic("unknown apicid\n");
80103e8d:	83 ec 0c             	sub    $0xc,%esp
80103e90:	68 3c 7c 10 80       	push   $0x80107c3c
80103e95:	e8 e6 c5 ff ff       	call   80100480 <panic>
        panic("mycpu called with interrupts enabled\n");
80103e9a:	83 ec 0c             	sub    $0xc,%esp
80103e9d:	68 18 7d 10 80       	push   $0x80107d18
80103ea2:	e8 d9 c5 ff ff       	call   80100480 <panic>
80103ea7:	89 f6                	mov    %esi,%esi
80103ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103eb0 <cpuid>:
int cpuid() {
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
80103eb6:	e8 75 ff ff ff       	call   80103e30 <mycpu>
80103ebb:	2d 60 4f 11 80       	sub    $0x80114f60,%eax
}
80103ec0:	c9                   	leave  
    return mycpu() - cpus;
80103ec1:	c1 f8 04             	sar    $0x4,%eax
80103ec4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103eca:	c3                   	ret    
80103ecb:	90                   	nop
80103ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ed0 <myproc>:
struct proc*myproc(void)  {
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	53                   	push   %ebx
80103ed4:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103ed7:	e8 84 0a 00 00       	call   80104960 <pushcli>
    c = mycpu();
80103edc:	e8 4f ff ff ff       	call   80103e30 <mycpu>
    p = c->proc;
80103ee1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103ee7:	e8 b4 0a 00 00       	call   801049a0 <popcli>
}
80103eec:	83 c4 04             	add    $0x4,%esp
80103eef:	89 d8                	mov    %ebx,%eax
80103ef1:	5b                   	pop    %ebx
80103ef2:	5d                   	pop    %ebp
80103ef3:	c3                   	ret    
80103ef4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103efa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103f00 <userinit>:
void userinit(void) {
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	53                   	push   %ebx
80103f04:	83 ec 04             	sub    $0x4,%esp
    p = allocproc();
80103f07:	e8 d4 fd ff ff       	call   80103ce0 <allocproc>
80103f0c:	89 c3                	mov    %eax,%ebx
    initproc = p;
80103f0e:	a3 b8 c5 10 80       	mov    %eax,0x8010c5b8
    if ((p->pgdir = setupkvm()) == 0) {
80103f13:	e8 f8 34 00 00       	call   80107410 <setupkvm>
80103f18:	85 c0                	test   %eax,%eax
80103f1a:	89 43 04             	mov    %eax,0x4(%ebx)
80103f1d:	0f 84 bd 00 00 00    	je     80103fe0 <userinit+0xe0>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103f23:	83 ec 04             	sub    $0x4,%esp
80103f26:	68 2c 00 00 00       	push   $0x2c
80103f2b:	68 60 c4 10 80       	push   $0x8010c460
80103f30:	50                   	push   %eax
80103f31:	e8 ba 31 00 00       	call   801070f0 <inituvm>
    memset(p->tf, 0, sizeof(*p->tf));
80103f36:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103f39:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80103f3f:	6a 4c                	push   $0x4c
80103f41:	6a 00                	push   $0x0
80103f43:	ff 73 18             	pushl  0x18(%ebx)
80103f46:	e8 f5 0b 00 00       	call   80104b40 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f4b:	8b 43 18             	mov    0x18(%ebx),%eax
80103f4e:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f53:	b9 23 00 00 00       	mov    $0x23,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103f58:	83 c4 0c             	add    $0xc,%esp
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f5b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f5f:	8b 43 18             	mov    0x18(%ebx),%eax
80103f62:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
80103f66:	8b 43 18             	mov    0x18(%ebx),%eax
80103f69:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f6d:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80103f71:	8b 43 18             	mov    0x18(%ebx),%eax
80103f74:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f78:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80103f7c:	8b 43 18             	mov    0x18(%ebx),%eax
80103f7f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80103f86:	8b 43 18             	mov    0x18(%ebx),%eax
80103f89:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80103f90:	8b 43 18             	mov    0x18(%ebx),%eax
80103f93:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103f9a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103f9d:	6a 10                	push   $0x10
80103f9f:	68 65 7c 10 80       	push   $0x80107c65
80103fa4:	50                   	push   %eax
80103fa5:	e8 76 0d 00 00       	call   80104d20 <safestrcpy>
    p->cwd = namei("/");
80103faa:	c7 04 24 6e 7c 10 80 	movl   $0x80107c6e,(%esp)
80103fb1:	e8 ea e5 ff ff       	call   801025a0 <namei>
80103fb6:	89 43 68             	mov    %eax,0x68(%ebx)
    acquire(&ptable.lock);
80103fb9:	c7 04 24 00 55 11 80 	movl   $0x80115500,(%esp)
80103fc0:	e8 6b 0a 00 00       	call   80104a30 <acquire>
    p->state = RUNNABLE;
80103fc5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    release(&ptable.lock);
80103fcc:	c7 04 24 00 55 11 80 	movl   $0x80115500,(%esp)
80103fd3:	e8 18 0b 00 00       	call   80104af0 <release>
}
80103fd8:	83 c4 10             	add    $0x10,%esp
80103fdb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fde:	c9                   	leave  
80103fdf:	c3                   	ret    
        panic("userinit: out of memory?");
80103fe0:	83 ec 0c             	sub    $0xc,%esp
80103fe3:	68 4c 7c 10 80       	push   $0x80107c4c
80103fe8:	e8 93 c4 ff ff       	call   80100480 <panic>
80103fed:	8d 76 00             	lea    0x0(%esi),%esi

80103ff0 <growproc>:
int growproc(int n) {
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	56                   	push   %esi
80103ff4:	53                   	push   %ebx
80103ff5:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80103ff8:	e8 63 09 00 00       	call   80104960 <pushcli>
    c = mycpu();
80103ffd:	e8 2e fe ff ff       	call   80103e30 <mycpu>
    p = c->proc;
80104002:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104008:	e8 93 09 00 00       	call   801049a0 <popcli>
    if (n > 0) {
8010400d:	83 fe 00             	cmp    $0x0,%esi
    sz = curproc->sz;
80104010:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80104012:	7f 1c                	jg     80104030 <growproc+0x40>
    else if (n < 0) {
80104014:	75 3a                	jne    80104050 <growproc+0x60>
    switchuvm(curproc);
80104016:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80104019:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
8010401b:	53                   	push   %ebx
8010401c:	e8 bf 2f 00 00       	call   80106fe0 <switchuvm>
    return 0;
80104021:	83 c4 10             	add    $0x10,%esp
80104024:	31 c0                	xor    %eax,%eax
}
80104026:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104029:	5b                   	pop    %ebx
8010402a:	5e                   	pop    %esi
8010402b:	5d                   	pop    %ebp
8010402c:	c3                   	ret    
8010402d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0) {
80104030:	83 ec 04             	sub    $0x4,%esp
80104033:	01 c6                	add    %eax,%esi
80104035:	56                   	push   %esi
80104036:	50                   	push   %eax
80104037:	ff 73 04             	pushl  0x4(%ebx)
8010403a:	e8 f1 31 00 00       	call   80107230 <allocuvm>
8010403f:	83 c4 10             	add    $0x10,%esp
80104042:	85 c0                	test   %eax,%eax
80104044:	75 d0                	jne    80104016 <growproc+0x26>
            return -1;
80104046:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010404b:	eb d9                	jmp    80104026 <growproc+0x36>
8010404d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0) {
80104050:	83 ec 04             	sub    $0x4,%esp
80104053:	01 c6                	add    %eax,%esi
80104055:	56                   	push   %esi
80104056:	50                   	push   %eax
80104057:	ff 73 04             	pushl  0x4(%ebx)
8010405a:	e8 01 33 00 00       	call   80107360 <deallocuvm>
8010405f:	83 c4 10             	add    $0x10,%esp
80104062:	85 c0                	test   %eax,%eax
80104064:	75 b0                	jne    80104016 <growproc+0x26>
80104066:	eb de                	jmp    80104046 <growproc+0x56>
80104068:	90                   	nop
80104069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104070 <fork>:
int fork(void) {
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	57                   	push   %edi
80104074:	56                   	push   %esi
80104075:	53                   	push   %ebx
80104076:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80104079:	e8 e2 08 00 00       	call   80104960 <pushcli>
    c = mycpu();
8010407e:	e8 ad fd ff ff       	call   80103e30 <mycpu>
    p = c->proc;
80104083:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104089:	e8 12 09 00 00       	call   801049a0 <popcli>
    if ((np = allocproc()) == 0) {
8010408e:	e8 4d fc ff ff       	call   80103ce0 <allocproc>
80104093:	85 c0                	test   %eax,%eax
80104095:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104098:	0f 84 b7 00 00 00    	je     80104155 <fork+0xe5>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
8010409e:	83 ec 08             	sub    $0x8,%esp
801040a1:	ff 33                	pushl  (%ebx)
801040a3:	ff 73 04             	pushl  0x4(%ebx)
801040a6:	89 c7                	mov    %eax,%edi
801040a8:	e8 33 34 00 00       	call   801074e0 <copyuvm>
801040ad:	83 c4 10             	add    $0x10,%esp
801040b0:	85 c0                	test   %eax,%eax
801040b2:	89 47 04             	mov    %eax,0x4(%edi)
801040b5:	0f 84 a1 00 00 00    	je     8010415c <fork+0xec>
    np->sz = curproc->sz;
801040bb:	8b 03                	mov    (%ebx),%eax
801040bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801040c0:	89 01                	mov    %eax,(%ecx)
    np->parent = curproc;
801040c2:	89 59 14             	mov    %ebx,0x14(%ecx)
801040c5:	89 c8                	mov    %ecx,%eax
    *np->tf = *curproc->tf;
801040c7:	8b 79 18             	mov    0x18(%ecx),%edi
801040ca:	8b 73 18             	mov    0x18(%ebx),%esi
801040cd:	b9 13 00 00 00       	mov    $0x13,%ecx
801040d2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++) {
801040d4:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
801040d6:	8b 40 18             	mov    0x18(%eax),%eax
801040d9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
        if (curproc->ofile[i]) {
801040e0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801040e4:	85 c0                	test   %eax,%eax
801040e6:	74 13                	je     801040fb <fork+0x8b>
            np->ofile[i] = filedup(curproc->ofile[i]);
801040e8:	83 ec 0c             	sub    $0xc,%esp
801040eb:	50                   	push   %eax
801040ec:	e8 bf d3 ff ff       	call   801014b0 <filedup>
801040f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801040f4:	83 c4 10             	add    $0x10,%esp
801040f7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
    for (i = 0; i < NOFILE; i++) {
801040fb:	83 c6 01             	add    $0x1,%esi
801040fe:	83 fe 10             	cmp    $0x10,%esi
80104101:	75 dd                	jne    801040e0 <fork+0x70>
    np->cwd = idup(curproc->cwd);
80104103:	83 ec 0c             	sub    $0xc,%esp
80104106:	ff 73 68             	pushl  0x68(%ebx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104109:	83 c3 6c             	add    $0x6c,%ebx
    np->cwd = idup(curproc->cwd);
8010410c:	e8 ff db ff ff       	call   80101d10 <idup>
80104111:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104114:	83 c4 0c             	add    $0xc,%esp
    np->cwd = idup(curproc->cwd);
80104117:	89 47 68             	mov    %eax,0x68(%edi)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010411a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010411d:	6a 10                	push   $0x10
8010411f:	53                   	push   %ebx
80104120:	50                   	push   %eax
80104121:	e8 fa 0b 00 00       	call   80104d20 <safestrcpy>
    pid = np->pid;
80104126:	8b 5f 10             	mov    0x10(%edi),%ebx
    acquire(&ptable.lock);
80104129:	c7 04 24 00 55 11 80 	movl   $0x80115500,(%esp)
80104130:	e8 fb 08 00 00       	call   80104a30 <acquire>
    np->state = RUNNABLE;
80104135:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
    release(&ptable.lock);
8010413c:	c7 04 24 00 55 11 80 	movl   $0x80115500,(%esp)
80104143:	e8 a8 09 00 00       	call   80104af0 <release>
    return pid;
80104148:	83 c4 10             	add    $0x10,%esp
}
8010414b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010414e:	89 d8                	mov    %ebx,%eax
80104150:	5b                   	pop    %ebx
80104151:	5e                   	pop    %esi
80104152:	5f                   	pop    %edi
80104153:	5d                   	pop    %ebp
80104154:	c3                   	ret    
        return -1;
80104155:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010415a:	eb ef                	jmp    8010414b <fork+0xdb>
        kfree(np->kstack);
8010415c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010415f:	83 ec 0c             	sub    $0xc,%esp
80104162:	ff 73 08             	pushl  0x8(%ebx)
80104165:	e8 66 e8 ff ff       	call   801029d0 <kfree>
        np->kstack = 0;
8010416a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->state = UNUSED;
80104171:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return -1;
80104178:	83 c4 10             	add    $0x10,%esp
8010417b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104180:	eb c9                	jmp    8010414b <fork+0xdb>
80104182:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104190 <scheduler>:
void scheduler(void) {
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	57                   	push   %edi
80104194:	56                   	push   %esi
80104195:	53                   	push   %ebx
80104196:	83 ec 0c             	sub    $0xc,%esp
    struct cpu *c = mycpu();
80104199:	e8 92 fc ff ff       	call   80103e30 <mycpu>
8010419e:	8d 78 04             	lea    0x4(%eax),%edi
801041a1:	89 c6                	mov    %eax,%esi
    c->proc = 0;
801041a3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801041aa:	00 00 00 
801041ad:	8d 76 00             	lea    0x0(%esi),%esi
    asm volatile ("sti");
801041b0:	fb                   	sti    
        acquire(&ptable.lock);
801041b1:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801041b4:	bb 34 55 11 80       	mov    $0x80115534,%ebx
        acquire(&ptable.lock);
801041b9:	68 00 55 11 80       	push   $0x80115500
801041be:	e8 6d 08 00 00       	call   80104a30 <acquire>
801041c3:	83 c4 10             	add    $0x10,%esp
801041c6:	8d 76 00             	lea    0x0(%esi),%esi
801041c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            if (p->state != RUNNABLE) {
801041d0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801041d4:	75 33                	jne    80104209 <scheduler+0x79>
            switchuvm(p);
801041d6:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
801041d9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
801041df:	53                   	push   %ebx
801041e0:	e8 fb 2d 00 00       	call   80106fe0 <switchuvm>
            swtch(&(c->scheduler), p->context);
801041e5:	58                   	pop    %eax
801041e6:	5a                   	pop    %edx
801041e7:	ff 73 1c             	pushl  0x1c(%ebx)
801041ea:	57                   	push   %edi
            p->state = RUNNING;
801041eb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
            swtch(&(c->scheduler), p->context);
801041f2:	e8 84 0b 00 00       	call   80104d7b <swtch>
            switchkvm();
801041f7:	e8 c4 2d 00 00       	call   80106fc0 <switchkvm>
            c->proc = 0;
801041fc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104203:	00 00 00 
80104206:	83 c4 10             	add    $0x10,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104209:	83 c3 7c             	add    $0x7c,%ebx
8010420c:	81 fb 34 74 11 80    	cmp    $0x80117434,%ebx
80104212:	72 bc                	jb     801041d0 <scheduler+0x40>
        release(&ptable.lock);
80104214:	83 ec 0c             	sub    $0xc,%esp
80104217:	68 00 55 11 80       	push   $0x80115500
8010421c:	e8 cf 08 00 00       	call   80104af0 <release>
        sti();
80104221:	83 c4 10             	add    $0x10,%esp
80104224:	eb 8a                	jmp    801041b0 <scheduler+0x20>
80104226:	8d 76 00             	lea    0x0(%esi),%esi
80104229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104230 <sched>:
void sched(void) {
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	56                   	push   %esi
80104234:	53                   	push   %ebx
    pushcli();
80104235:	e8 26 07 00 00       	call   80104960 <pushcli>
    c = mycpu();
8010423a:	e8 f1 fb ff ff       	call   80103e30 <mycpu>
    p = c->proc;
8010423f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104245:	e8 56 07 00 00       	call   801049a0 <popcli>
    if (!holding(&ptable.lock)) {
8010424a:	83 ec 0c             	sub    $0xc,%esp
8010424d:	68 00 55 11 80       	push   $0x80115500
80104252:	e8 a9 07 00 00       	call   80104a00 <holding>
80104257:	83 c4 10             	add    $0x10,%esp
8010425a:	85 c0                	test   %eax,%eax
8010425c:	74 4f                	je     801042ad <sched+0x7d>
    if (mycpu()->ncli != 1) {
8010425e:	e8 cd fb ff ff       	call   80103e30 <mycpu>
80104263:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010426a:	75 68                	jne    801042d4 <sched+0xa4>
    if (p->state == RUNNING) {
8010426c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104270:	74 55                	je     801042c7 <sched+0x97>
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
80104272:	9c                   	pushf  
80104273:	58                   	pop    %eax
    if (readeflags() & FL_IF) {
80104274:	f6 c4 02             	test   $0x2,%ah
80104277:	75 41                	jne    801042ba <sched+0x8a>
    intena = mycpu()->intena;
80104279:	e8 b2 fb ff ff       	call   80103e30 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
8010427e:	83 c3 1c             	add    $0x1c,%ebx
    intena = mycpu()->intena;
80104281:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
80104287:	e8 a4 fb ff ff       	call   80103e30 <mycpu>
8010428c:	83 ec 08             	sub    $0x8,%esp
8010428f:	ff 70 04             	pushl  0x4(%eax)
80104292:	53                   	push   %ebx
80104293:	e8 e3 0a 00 00       	call   80104d7b <swtch>
    mycpu()->intena = intena;
80104298:	e8 93 fb ff ff       	call   80103e30 <mycpu>
}
8010429d:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
801042a0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801042a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042a9:	5b                   	pop    %ebx
801042aa:	5e                   	pop    %esi
801042ab:	5d                   	pop    %ebp
801042ac:	c3                   	ret    
        panic("sched ptable.lock");
801042ad:	83 ec 0c             	sub    $0xc,%esp
801042b0:	68 70 7c 10 80       	push   $0x80107c70
801042b5:	e8 c6 c1 ff ff       	call   80100480 <panic>
        panic("sched interruptible");
801042ba:	83 ec 0c             	sub    $0xc,%esp
801042bd:	68 9c 7c 10 80       	push   $0x80107c9c
801042c2:	e8 b9 c1 ff ff       	call   80100480 <panic>
        panic("sched running");
801042c7:	83 ec 0c             	sub    $0xc,%esp
801042ca:	68 8e 7c 10 80       	push   $0x80107c8e
801042cf:	e8 ac c1 ff ff       	call   80100480 <panic>
        panic("sched locks");
801042d4:	83 ec 0c             	sub    $0xc,%esp
801042d7:	68 82 7c 10 80       	push   $0x80107c82
801042dc:	e8 9f c1 ff ff       	call   80100480 <panic>
801042e1:	eb 0d                	jmp    801042f0 <exit>
801042e3:	90                   	nop
801042e4:	90                   	nop
801042e5:	90                   	nop
801042e6:	90                   	nop
801042e7:	90                   	nop
801042e8:	90                   	nop
801042e9:	90                   	nop
801042ea:	90                   	nop
801042eb:	90                   	nop
801042ec:	90                   	nop
801042ed:	90                   	nop
801042ee:	90                   	nop
801042ef:	90                   	nop

801042f0 <exit>:
void exit(void)  {
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	57                   	push   %edi
801042f4:	56                   	push   %esi
801042f5:	53                   	push   %ebx
801042f6:	83 ec 0c             	sub    $0xc,%esp
    pushcli();
801042f9:	e8 62 06 00 00       	call   80104960 <pushcli>
    c = mycpu();
801042fe:	e8 2d fb ff ff       	call   80103e30 <mycpu>
    p = c->proc;
80104303:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104309:	e8 92 06 00 00       	call   801049a0 <popcli>
    if (curproc == initproc) {
8010430e:	39 35 b8 c5 10 80    	cmp    %esi,0x8010c5b8
80104314:	8d 5e 28             	lea    0x28(%esi),%ebx
80104317:	8d 7e 68             	lea    0x68(%esi),%edi
8010431a:	0f 84 e7 00 00 00    	je     80104407 <exit+0x117>
        if (curproc->ofile[fd]) {
80104320:	8b 03                	mov    (%ebx),%eax
80104322:	85 c0                	test   %eax,%eax
80104324:	74 12                	je     80104338 <exit+0x48>
            fileclose(curproc->ofile[fd]);
80104326:	83 ec 0c             	sub    $0xc,%esp
80104329:	50                   	push   %eax
8010432a:	e8 d1 d1 ff ff       	call   80101500 <fileclose>
            curproc->ofile[fd] = 0;
8010432f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104335:	83 c4 10             	add    $0x10,%esp
80104338:	83 c3 04             	add    $0x4,%ebx
    for (fd = 0; fd < NOFILE; fd++) {
8010433b:	39 fb                	cmp    %edi,%ebx
8010433d:	75 e1                	jne    80104320 <exit+0x30>
    begin_op();
8010433f:	e8 1c ef ff ff       	call   80103260 <begin_op>
    iput(curproc->cwd);
80104344:	83 ec 0c             	sub    $0xc,%esp
80104347:	ff 76 68             	pushl  0x68(%esi)
8010434a:	e8 21 db ff ff       	call   80101e70 <iput>
    end_op();
8010434f:	e8 7c ef ff ff       	call   801032d0 <end_op>
    curproc->cwd = 0;
80104354:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
    acquire(&ptable.lock);
8010435b:	c7 04 24 00 55 11 80 	movl   $0x80115500,(%esp)
80104362:	e8 c9 06 00 00       	call   80104a30 <acquire>
    wakeup1(curproc->parent);
80104367:	8b 56 14             	mov    0x14(%esi),%edx
8010436a:	83 c4 10             	add    $0x10,%esp
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010436d:	b8 34 55 11 80       	mov    $0x80115534,%eax
80104372:	eb 0e                	jmp    80104382 <exit+0x92>
80104374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104378:	83 c0 7c             	add    $0x7c,%eax
8010437b:	3d 34 74 11 80       	cmp    $0x80117434,%eax
80104380:	73 1c                	jae    8010439e <exit+0xae>
        if (p->state == SLEEPING && p->chan == chan) {
80104382:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104386:	75 f0                	jne    80104378 <exit+0x88>
80104388:	3b 50 20             	cmp    0x20(%eax),%edx
8010438b:	75 eb                	jne    80104378 <exit+0x88>
            p->state = RUNNABLE;
8010438d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104394:	83 c0 7c             	add    $0x7c,%eax
80104397:	3d 34 74 11 80       	cmp    $0x80117434,%eax
8010439c:	72 e4                	jb     80104382 <exit+0x92>
            p->parent = initproc;
8010439e:	8b 0d b8 c5 10 80    	mov    0x8010c5b8,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043a4:	ba 34 55 11 80       	mov    $0x80115534,%edx
801043a9:	eb 10                	jmp    801043bb <exit+0xcb>
801043ab:	90                   	nop
801043ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043b0:	83 c2 7c             	add    $0x7c,%edx
801043b3:	81 fa 34 74 11 80    	cmp    $0x80117434,%edx
801043b9:	73 33                	jae    801043ee <exit+0xfe>
        if (p->parent == curproc) {
801043bb:	39 72 14             	cmp    %esi,0x14(%edx)
801043be:	75 f0                	jne    801043b0 <exit+0xc0>
            if (p->state == ZOMBIE) {
801043c0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
            p->parent = initproc;
801043c4:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE) {
801043c7:	75 e7                	jne    801043b0 <exit+0xc0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043c9:	b8 34 55 11 80       	mov    $0x80115534,%eax
801043ce:	eb 0a                	jmp    801043da <exit+0xea>
801043d0:	83 c0 7c             	add    $0x7c,%eax
801043d3:	3d 34 74 11 80       	cmp    $0x80117434,%eax
801043d8:	73 d6                	jae    801043b0 <exit+0xc0>
        if (p->state == SLEEPING && p->chan == chan) {
801043da:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043de:	75 f0                	jne    801043d0 <exit+0xe0>
801043e0:	3b 48 20             	cmp    0x20(%eax),%ecx
801043e3:	75 eb                	jne    801043d0 <exit+0xe0>
            p->state = RUNNABLE;
801043e5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801043ec:	eb e2                	jmp    801043d0 <exit+0xe0>
    curproc->state = ZOMBIE;
801043ee:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
    sched();
801043f5:	e8 36 fe ff ff       	call   80104230 <sched>
    panic("zombie exit");
801043fa:	83 ec 0c             	sub    $0xc,%esp
801043fd:	68 bd 7c 10 80       	push   $0x80107cbd
80104402:	e8 79 c0 ff ff       	call   80100480 <panic>
        panic("init exiting");
80104407:	83 ec 0c             	sub    $0xc,%esp
8010440a:	68 b0 7c 10 80       	push   $0x80107cb0
8010440f:	e8 6c c0 ff ff       	call   80100480 <panic>
80104414:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010441a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104420 <yield>:
void yield(void)      {
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	53                   	push   %ebx
80104424:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80104427:	68 00 55 11 80       	push   $0x80115500
8010442c:	e8 ff 05 00 00       	call   80104a30 <acquire>
    pushcli();
80104431:	e8 2a 05 00 00       	call   80104960 <pushcli>
    c = mycpu();
80104436:	e8 f5 f9 ff ff       	call   80103e30 <mycpu>
    p = c->proc;
8010443b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80104441:	e8 5a 05 00 00       	call   801049a0 <popcli>
    myproc()->state = RUNNABLE;
80104446:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    sched();
8010444d:	e8 de fd ff ff       	call   80104230 <sched>
    release(&ptable.lock);
80104452:	c7 04 24 00 55 11 80 	movl   $0x80115500,(%esp)
80104459:	e8 92 06 00 00       	call   80104af0 <release>
}
8010445e:	83 c4 10             	add    $0x10,%esp
80104461:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104464:	c9                   	leave  
80104465:	c3                   	ret    
80104466:	8d 76 00             	lea    0x0(%esi),%esi
80104469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104470 <sleep>:
void sleep(void *chan, struct spinlock *lk)  {
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	57                   	push   %edi
80104474:	56                   	push   %esi
80104475:	53                   	push   %ebx
80104476:	83 ec 0c             	sub    $0xc,%esp
80104479:	8b 7d 08             	mov    0x8(%ebp),%edi
8010447c:	8b 75 0c             	mov    0xc(%ebp),%esi
    pushcli();
8010447f:	e8 dc 04 00 00       	call   80104960 <pushcli>
    c = mycpu();
80104484:	e8 a7 f9 ff ff       	call   80103e30 <mycpu>
    p = c->proc;
80104489:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
8010448f:	e8 0c 05 00 00       	call   801049a0 <popcli>
    if (p == 0) {
80104494:	85 db                	test   %ebx,%ebx
80104496:	0f 84 87 00 00 00    	je     80104523 <sleep+0xb3>
    if (lk == 0) {
8010449c:	85 f6                	test   %esi,%esi
8010449e:	74 76                	je     80104516 <sleep+0xa6>
    if (lk != &ptable.lock) { //DOC: sleeplock0
801044a0:	81 fe 00 55 11 80    	cmp    $0x80115500,%esi
801044a6:	74 50                	je     801044f8 <sleep+0x88>
        acquire(&ptable.lock);  //DOC: sleeplock1
801044a8:	83 ec 0c             	sub    $0xc,%esp
801044ab:	68 00 55 11 80       	push   $0x80115500
801044b0:	e8 7b 05 00 00       	call   80104a30 <acquire>
        release(lk);
801044b5:	89 34 24             	mov    %esi,(%esp)
801044b8:	e8 33 06 00 00       	call   80104af0 <release>
    p->chan = chan;
801044bd:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
801044c0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
801044c7:	e8 64 fd ff ff       	call   80104230 <sched>
    p->chan = 0;
801044cc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        release(&ptable.lock);
801044d3:	c7 04 24 00 55 11 80 	movl   $0x80115500,(%esp)
801044da:	e8 11 06 00 00       	call   80104af0 <release>
        acquire(lk);
801044df:	89 75 08             	mov    %esi,0x8(%ebp)
801044e2:	83 c4 10             	add    $0x10,%esp
}
801044e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044e8:	5b                   	pop    %ebx
801044e9:	5e                   	pop    %esi
801044ea:	5f                   	pop    %edi
801044eb:	5d                   	pop    %ebp
        acquire(lk);
801044ec:	e9 3f 05 00 00       	jmp    80104a30 <acquire>
801044f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->chan = chan;
801044f8:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
801044fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104502:	e8 29 fd ff ff       	call   80104230 <sched>
    p->chan = 0;
80104507:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010450e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104511:	5b                   	pop    %ebx
80104512:	5e                   	pop    %esi
80104513:	5f                   	pop    %edi
80104514:	5d                   	pop    %ebp
80104515:	c3                   	ret    
        panic("sleep without lk");
80104516:	83 ec 0c             	sub    $0xc,%esp
80104519:	68 cf 7c 10 80       	push   $0x80107ccf
8010451e:	e8 5d bf ff ff       	call   80100480 <panic>
        panic("sleep");
80104523:	83 ec 0c             	sub    $0xc,%esp
80104526:	68 c9 7c 10 80       	push   $0x80107cc9
8010452b:	e8 50 bf ff ff       	call   80100480 <panic>

80104530 <wait>:
int wait(void) {
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
    pushcli();
80104535:	e8 26 04 00 00       	call   80104960 <pushcli>
    c = mycpu();
8010453a:	e8 f1 f8 ff ff       	call   80103e30 <mycpu>
    p = c->proc;
8010453f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104545:	e8 56 04 00 00       	call   801049a0 <popcli>
    acquire(&ptable.lock);
8010454a:	83 ec 0c             	sub    $0xc,%esp
8010454d:	68 00 55 11 80       	push   $0x80115500
80104552:	e8 d9 04 00 00       	call   80104a30 <acquire>
80104557:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
8010455a:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010455c:	bb 34 55 11 80       	mov    $0x80115534,%ebx
80104561:	eb 10                	jmp    80104573 <wait+0x43>
80104563:	90                   	nop
80104564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104568:	83 c3 7c             	add    $0x7c,%ebx
8010456b:	81 fb 34 74 11 80    	cmp    $0x80117434,%ebx
80104571:	73 1b                	jae    8010458e <wait+0x5e>
            if (p->parent != curproc) {
80104573:	39 73 14             	cmp    %esi,0x14(%ebx)
80104576:	75 f0                	jne    80104568 <wait+0x38>
            if (p->state == ZOMBIE) {
80104578:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010457c:	74 32                	je     801045b0 <wait+0x80>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010457e:	83 c3 7c             	add    $0x7c,%ebx
            havekids = 1;
80104581:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104586:	81 fb 34 74 11 80    	cmp    $0x80117434,%ebx
8010458c:	72 e5                	jb     80104573 <wait+0x43>
        if (!havekids || curproc->killed) {
8010458e:	85 c0                	test   %eax,%eax
80104590:	74 74                	je     80104606 <wait+0xd6>
80104592:	8b 46 24             	mov    0x24(%esi),%eax
80104595:	85 c0                	test   %eax,%eax
80104597:	75 6d                	jne    80104606 <wait+0xd6>
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104599:	83 ec 08             	sub    $0x8,%esp
8010459c:	68 00 55 11 80       	push   $0x80115500
801045a1:	56                   	push   %esi
801045a2:	e8 c9 fe ff ff       	call   80104470 <sleep>
        havekids = 0;
801045a7:	83 c4 10             	add    $0x10,%esp
801045aa:	eb ae                	jmp    8010455a <wait+0x2a>
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                kfree(p->kstack);
801045b0:	83 ec 0c             	sub    $0xc,%esp
801045b3:	ff 73 08             	pushl  0x8(%ebx)
                pid = p->pid;
801045b6:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
801045b9:	e8 12 e4 ff ff       	call   801029d0 <kfree>
                freevm(p->pgdir);
801045be:	5a                   	pop    %edx
801045bf:	ff 73 04             	pushl  0x4(%ebx)
                p->kstack = 0;
801045c2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
801045c9:	e8 c2 2d 00 00       	call   80107390 <freevm>
                release(&ptable.lock);
801045ce:	c7 04 24 00 55 11 80 	movl   $0x80115500,(%esp)
                p->pid = 0;
801045d5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
801045dc:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
801045e3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
801045e7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
801045ee:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
801045f5:	e8 f6 04 00 00       	call   80104af0 <release>
                return pid;
801045fa:	83 c4 10             	add    $0x10,%esp
}
801045fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104600:	89 f0                	mov    %esi,%eax
80104602:	5b                   	pop    %ebx
80104603:	5e                   	pop    %esi
80104604:	5d                   	pop    %ebp
80104605:	c3                   	ret    
            release(&ptable.lock);
80104606:	83 ec 0c             	sub    $0xc,%esp
            return -1;
80104609:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
8010460e:	68 00 55 11 80       	push   $0x80115500
80104613:	e8 d8 04 00 00       	call   80104af0 <release>
            return -1;
80104618:	83 c4 10             	add    $0x10,%esp
8010461b:	eb e0                	jmp    801045fd <wait+0xcd>
8010461d:	8d 76 00             	lea    0x0(%esi),%esi

80104620 <wakeup>:
        }
    }
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan) {
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	53                   	push   %ebx
80104624:	83 ec 10             	sub    $0x10,%esp
80104627:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
8010462a:	68 00 55 11 80       	push   $0x80115500
8010462f:	e8 fc 03 00 00       	call   80104a30 <acquire>
80104634:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104637:	b8 34 55 11 80       	mov    $0x80115534,%eax
8010463c:	eb 0c                	jmp    8010464a <wakeup+0x2a>
8010463e:	66 90                	xchg   %ax,%ax
80104640:	83 c0 7c             	add    $0x7c,%eax
80104643:	3d 34 74 11 80       	cmp    $0x80117434,%eax
80104648:	73 1c                	jae    80104666 <wakeup+0x46>
        if (p->state == SLEEPING && p->chan == chan) {
8010464a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010464e:	75 f0                	jne    80104640 <wakeup+0x20>
80104650:	3b 58 20             	cmp    0x20(%eax),%ebx
80104653:	75 eb                	jne    80104640 <wakeup+0x20>
            p->state = RUNNABLE;
80104655:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010465c:	83 c0 7c             	add    $0x7c,%eax
8010465f:	3d 34 74 11 80       	cmp    $0x80117434,%eax
80104664:	72 e4                	jb     8010464a <wakeup+0x2a>
    wakeup1(chan);
    release(&ptable.lock);
80104666:	c7 45 08 00 55 11 80 	movl   $0x80115500,0x8(%ebp)
}
8010466d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104670:	c9                   	leave  
    release(&ptable.lock);
80104671:	e9 7a 04 00 00       	jmp    80104af0 <release>
80104676:	8d 76 00             	lea    0x0(%esi),%esi
80104679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104680 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid) {
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	53                   	push   %ebx
80104684:	83 ec 10             	sub    $0x10,%esp
80104687:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
8010468a:	68 00 55 11 80       	push   $0x80115500
8010468f:	e8 9c 03 00 00       	call   80104a30 <acquire>
80104694:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104697:	b8 34 55 11 80       	mov    $0x80115534,%eax
8010469c:	eb 0c                	jmp    801046aa <kill+0x2a>
8010469e:	66 90                	xchg   %ax,%ax
801046a0:	83 c0 7c             	add    $0x7c,%eax
801046a3:	3d 34 74 11 80       	cmp    $0x80117434,%eax
801046a8:	73 36                	jae    801046e0 <kill+0x60>
        if (p->pid == pid) {
801046aa:	39 58 10             	cmp    %ebx,0x10(%eax)
801046ad:	75 f1                	jne    801046a0 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING) {
801046af:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
            p->killed = 1;
801046b3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            if (p->state == SLEEPING) {
801046ba:	75 07                	jne    801046c3 <kill+0x43>
                p->state = RUNNABLE;
801046bc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            }
            release(&ptable.lock);
801046c3:	83 ec 0c             	sub    $0xc,%esp
801046c6:	68 00 55 11 80       	push   $0x80115500
801046cb:	e8 20 04 00 00       	call   80104af0 <release>
            return 0;
801046d0:	83 c4 10             	add    $0x10,%esp
801046d3:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
801046d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046d8:	c9                   	leave  
801046d9:	c3                   	ret    
801046da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ptable.lock);
801046e0:	83 ec 0c             	sub    $0xc,%esp
801046e3:	68 00 55 11 80       	push   $0x80115500
801046e8:	e8 03 04 00 00       	call   80104af0 <release>
    return -1;
801046ed:	83 c4 10             	add    $0x10,%esp
801046f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046f8:	c9                   	leave  
801046f9:	c3                   	ret    
801046fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104700 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	57                   	push   %edi
80104704:	56                   	push   %esi
80104705:	53                   	push   %ebx
80104706:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104709:	bb 34 55 11 80       	mov    $0x80115534,%ebx
void procdump(void) {
8010470e:	83 ec 3c             	sub    $0x3c,%esp
80104711:	eb 24                	jmp    80104737 <procdump+0x37>
80104713:	90                   	nop
80104714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            getcallerpcs((uint*)p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++) {
                cprintf(" %p", pc[i]);
            }
        }
        cprintf("\n");
80104718:	83 ec 0c             	sub    $0xc,%esp
8010471b:	68 a3 80 10 80       	push   $0x801080a3
80104720:	e8 db c0 ff ff       	call   80100800 <cprintf>
80104725:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104728:	83 c3 7c             	add    $0x7c,%ebx
8010472b:	81 fb 34 74 11 80    	cmp    $0x80117434,%ebx
80104731:	0f 83 81 00 00 00    	jae    801047b8 <procdump+0xb8>
        if (p->state == UNUSED) {
80104737:	8b 43 0c             	mov    0xc(%ebx),%eax
8010473a:	85 c0                	test   %eax,%eax
8010473c:	74 ea                	je     80104728 <procdump+0x28>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state]) {
8010473e:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
80104741:	ba e0 7c 10 80       	mov    $0x80107ce0,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state]) {
80104746:	77 11                	ja     80104759 <procdump+0x59>
80104748:	8b 14 85 40 7d 10 80 	mov    -0x7fef82c0(,%eax,4),%edx
            state = "???";
8010474f:	b8 e0 7c 10 80       	mov    $0x80107ce0,%eax
80104754:	85 d2                	test   %edx,%edx
80104756:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
80104759:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010475c:	50                   	push   %eax
8010475d:	52                   	push   %edx
8010475e:	ff 73 10             	pushl  0x10(%ebx)
80104761:	68 e4 7c 10 80       	push   $0x80107ce4
80104766:	e8 95 c0 ff ff       	call   80100800 <cprintf>
        if (p->state == SLEEPING) {
8010476b:	83 c4 10             	add    $0x10,%esp
8010476e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104772:	75 a4                	jne    80104718 <procdump+0x18>
            getcallerpcs((uint*)p->context->ebp + 2, pc);
80104774:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104777:	83 ec 08             	sub    $0x8,%esp
8010477a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010477d:	50                   	push   %eax
8010477e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104781:	8b 40 0c             	mov    0xc(%eax),%eax
80104784:	83 c0 08             	add    $0x8,%eax
80104787:	50                   	push   %eax
80104788:	e8 83 01 00 00       	call   80104910 <getcallerpcs>
8010478d:	83 c4 10             	add    $0x10,%esp
            for (i = 0; i < 10 && pc[i] != 0; i++) {
80104790:	8b 17                	mov    (%edi),%edx
80104792:	85 d2                	test   %edx,%edx
80104794:	74 82                	je     80104718 <procdump+0x18>
                cprintf(" %p", pc[i]);
80104796:	83 ec 08             	sub    $0x8,%esp
80104799:	83 c7 04             	add    $0x4,%edi
8010479c:	52                   	push   %edx
8010479d:	68 21 77 10 80       	push   $0x80107721
801047a2:	e8 59 c0 ff ff       	call   80100800 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++) {
801047a7:	83 c4 10             	add    $0x10,%esp
801047aa:	39 fe                	cmp    %edi,%esi
801047ac:	75 e2                	jne    80104790 <procdump+0x90>
801047ae:	e9 65 ff ff ff       	jmp    80104718 <procdump+0x18>
801047b3:	90                   	nop
801047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
}
801047b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047bb:	5b                   	pop    %ebx
801047bc:	5e                   	pop    %esi
801047bd:	5f                   	pop    %edi
801047be:	5d                   	pop    %ebp
801047bf:	c3                   	ret    

801047c0 <initsleeplock>:
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "sleeplock.h"

void initsleeplock(struct sleeplock *lk, char *name) {
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	53                   	push   %ebx
801047c4:	83 ec 0c             	sub    $0xc,%esp
801047c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    initlock(&lk->lk, "sleep lock");
801047ca:	68 58 7d 10 80       	push   $0x80107d58
801047cf:	8d 43 04             	lea    0x4(%ebx),%eax
801047d2:	50                   	push   %eax
801047d3:	e8 18 01 00 00       	call   801048f0 <initlock>
    lk->name = name;
801047d8:	8b 45 0c             	mov    0xc(%ebp),%eax
    lk->locked = 0;
801047db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    lk->pid = 0;
}
801047e1:	83 c4 10             	add    $0x10,%esp
    lk->pid = 0;
801047e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
    lk->name = name;
801047eb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801047ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047f1:	c9                   	leave  
801047f2:	c3                   	ret    
801047f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104800 <acquiresleep>:

void acquiresleep(struct sleeplock *lk) {
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
80104805:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&lk->lk);
80104808:	83 ec 0c             	sub    $0xc,%esp
8010480b:	8d 73 04             	lea    0x4(%ebx),%esi
8010480e:	56                   	push   %esi
8010480f:	e8 1c 02 00 00       	call   80104a30 <acquire>
    while (lk->locked) {
80104814:	8b 13                	mov    (%ebx),%edx
80104816:	83 c4 10             	add    $0x10,%esp
80104819:	85 d2                	test   %edx,%edx
8010481b:	74 16                	je     80104833 <acquiresleep+0x33>
8010481d:	8d 76 00             	lea    0x0(%esi),%esi
        sleep(lk, &lk->lk);
80104820:	83 ec 08             	sub    $0x8,%esp
80104823:	56                   	push   %esi
80104824:	53                   	push   %ebx
80104825:	e8 46 fc ff ff       	call   80104470 <sleep>
    while (lk->locked) {
8010482a:	8b 03                	mov    (%ebx),%eax
8010482c:	83 c4 10             	add    $0x10,%esp
8010482f:	85 c0                	test   %eax,%eax
80104831:	75 ed                	jne    80104820 <acquiresleep+0x20>
    }
    lk->locked = 1;
80104833:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
    lk->pid = myproc()->pid;
80104839:	e8 92 f6 ff ff       	call   80103ed0 <myproc>
8010483e:	8b 40 10             	mov    0x10(%eax),%eax
80104841:	89 43 3c             	mov    %eax,0x3c(%ebx)
    release(&lk->lk);
80104844:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104847:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010484a:	5b                   	pop    %ebx
8010484b:	5e                   	pop    %esi
8010484c:	5d                   	pop    %ebp
    release(&lk->lk);
8010484d:	e9 9e 02 00 00       	jmp    80104af0 <release>
80104852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104860 <releasesleep>:

void releasesleep(struct sleeplock *lk) {
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	53                   	push   %ebx
80104865:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&lk->lk);
80104868:	83 ec 0c             	sub    $0xc,%esp
8010486b:	8d 73 04             	lea    0x4(%ebx),%esi
8010486e:	56                   	push   %esi
8010486f:	e8 bc 01 00 00       	call   80104a30 <acquire>
    lk->locked = 0;
80104874:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    lk->pid = 0;
8010487a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
    wakeup(lk);
80104881:	89 1c 24             	mov    %ebx,(%esp)
80104884:	e8 97 fd ff ff       	call   80104620 <wakeup>
    release(&lk->lk);
80104889:	89 75 08             	mov    %esi,0x8(%ebp)
8010488c:	83 c4 10             	add    $0x10,%esp
}
8010488f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104892:	5b                   	pop    %ebx
80104893:	5e                   	pop    %esi
80104894:	5d                   	pop    %ebp
    release(&lk->lk);
80104895:	e9 56 02 00 00       	jmp    80104af0 <release>
8010489a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048a0 <holdingsleep>:

int holdingsleep(struct sleeplock *lk) {
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	57                   	push   %edi
801048a4:	56                   	push   %esi
801048a5:	53                   	push   %ebx
801048a6:	31 ff                	xor    %edi,%edi
801048a8:	83 ec 18             	sub    $0x18,%esp
801048ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int r;

    acquire(&lk->lk);
801048ae:	8d 73 04             	lea    0x4(%ebx),%esi
801048b1:	56                   	push   %esi
801048b2:	e8 79 01 00 00       	call   80104a30 <acquire>
    r = lk->locked && (lk->pid == myproc()->pid);
801048b7:	8b 03                	mov    (%ebx),%eax
801048b9:	83 c4 10             	add    $0x10,%esp
801048bc:	85 c0                	test   %eax,%eax
801048be:	74 13                	je     801048d3 <holdingsleep+0x33>
801048c0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801048c3:	e8 08 f6 ff ff       	call   80103ed0 <myproc>
801048c8:	39 58 10             	cmp    %ebx,0x10(%eax)
801048cb:	0f 94 c0             	sete   %al
801048ce:	0f b6 c0             	movzbl %al,%eax
801048d1:	89 c7                	mov    %eax,%edi
    release(&lk->lk);
801048d3:	83 ec 0c             	sub    $0xc,%esp
801048d6:	56                   	push   %esi
801048d7:	e8 14 02 00 00       	call   80104af0 <release>
    return r;
}
801048dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048df:	89 f8                	mov    %edi,%eax
801048e1:	5b                   	pop    %ebx
801048e2:	5e                   	pop    %esi
801048e3:	5f                   	pop    %edi
801048e4:	5d                   	pop    %ebp
801048e5:	c3                   	ret    
801048e6:	66 90                	xchg   %ax,%ax
801048e8:	66 90                	xchg   %ax,%ax
801048ea:	66 90                	xchg   %ax,%ax
801048ec:	66 90                	xchg   %ax,%ax
801048ee:	66 90                	xchg   %ax,%ax

801048f0 <initlock>:
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

void initlock(struct spinlock *lk, char *name) {
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	8b 45 08             	mov    0x8(%ebp),%eax
    lk->name = name;
801048f6:	8b 55 0c             	mov    0xc(%ebp),%edx
    lk->locked = 0;
801048f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    lk->name = name;
801048ff:	89 50 04             	mov    %edx,0x4(%eax)
    lk->cpu = 0;
80104902:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104909:	5d                   	pop    %ebp
8010490a:	c3                   	ret    
8010490b:	90                   	nop
8010490c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104910 <getcallerpcs>:

    popcli();
}

// Record the current call stack in pcs[] by following the %ebp chain.
void getcallerpcs(void *v, uint pcs[]) {
80104910:	55                   	push   %ebp
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
    for (i = 0; i < 10; i++) {
80104911:	31 d2                	xor    %edx,%edx
void getcallerpcs(void *v, uint pcs[]) {
80104913:	89 e5                	mov    %esp,%ebp
80104915:	53                   	push   %ebx
    ebp = (uint*)v - 2;
80104916:	8b 45 08             	mov    0x8(%ebp),%eax
void getcallerpcs(void *v, uint pcs[]) {
80104919:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    ebp = (uint*)v - 2;
8010491c:	83 e8 08             	sub    $0x8,%eax
8010491f:	90                   	nop
        if (ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff) {
80104920:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104926:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010492c:	77 1a                	ja     80104948 <getcallerpcs+0x38>
            break;
        }
        pcs[i] = ebp[1];     // saved %eip
8010492e:	8b 58 04             	mov    0x4(%eax),%ebx
80104931:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    for (i = 0; i < 10; i++) {
80104934:	83 c2 01             	add    $0x1,%edx
        ebp = (uint*)ebp[0]; // saved %ebp
80104937:	8b 00                	mov    (%eax),%eax
    for (i = 0; i < 10; i++) {
80104939:	83 fa 0a             	cmp    $0xa,%edx
8010493c:	75 e2                	jne    80104920 <getcallerpcs+0x10>
    }
    for (; i < 10; i++) {
        pcs[i] = 0;
    }
}
8010493e:	5b                   	pop    %ebx
8010493f:	5d                   	pop    %ebp
80104940:	c3                   	ret    
80104941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104948:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010494b:	83 c1 28             	add    $0x28,%ecx
8010494e:	66 90                	xchg   %ax,%ax
        pcs[i] = 0;
80104950:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104956:	83 c0 04             	add    $0x4,%eax
    for (; i < 10; i++) {
80104959:	39 c1                	cmp    %eax,%ecx
8010495b:	75 f3                	jne    80104950 <getcallerpcs+0x40>
}
8010495d:	5b                   	pop    %ebx
8010495e:	5d                   	pop    %ebp
8010495f:	c3                   	ret    

80104960 <pushcli>:

// Pushcli/popcli are like cli/sti except that they are matched:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void pushcli(void)      {
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	53                   	push   %ebx
80104964:	83 ec 04             	sub    $0x4,%esp
80104967:	9c                   	pushf  
80104968:	5b                   	pop    %ebx
    asm volatile ("cli");
80104969:	fa                   	cli    
    int eflags;

    eflags = readeflags();
    cli();
    if (mycpu()->ncli == 0) {
8010496a:	e8 c1 f4 ff ff       	call   80103e30 <mycpu>
8010496f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104975:	85 c0                	test   %eax,%eax
80104977:	75 11                	jne    8010498a <pushcli+0x2a>
        mycpu()->intena = eflags & FL_IF;
80104979:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010497f:	e8 ac f4 ff ff       	call   80103e30 <mycpu>
80104984:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
    }
    mycpu()->ncli += 1;
8010498a:	e8 a1 f4 ff ff       	call   80103e30 <mycpu>
8010498f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104996:	83 c4 04             	add    $0x4,%esp
80104999:	5b                   	pop    %ebx
8010499a:	5d                   	pop    %ebp
8010499b:	c3                   	ret    
8010499c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049a0 <popcli>:

void popcli(void)      {
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	83 ec 08             	sub    $0x8,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
801049a6:	9c                   	pushf  
801049a7:	58                   	pop    %eax
    if (readeflags() & FL_IF) {
801049a8:	f6 c4 02             	test   $0x2,%ah
801049ab:	75 35                	jne    801049e2 <popcli+0x42>
        panic("popcli - interruptible");
    }
    if (--mycpu()->ncli < 0) {
801049ad:	e8 7e f4 ff ff       	call   80103e30 <mycpu>
801049b2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801049b9:	78 34                	js     801049ef <popcli+0x4f>
        panic("popcli");
    }
    if (mycpu()->ncli == 0 && mycpu()->intena) {
801049bb:	e8 70 f4 ff ff       	call   80103e30 <mycpu>
801049c0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801049c6:	85 d2                	test   %edx,%edx
801049c8:	74 06                	je     801049d0 <popcli+0x30>
        sti();
    }
}
801049ca:	c9                   	leave  
801049cb:	c3                   	ret    
801049cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (mycpu()->ncli == 0 && mycpu()->intena) {
801049d0:	e8 5b f4 ff ff       	call   80103e30 <mycpu>
801049d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049db:	85 c0                	test   %eax,%eax
801049dd:	74 eb                	je     801049ca <popcli+0x2a>
    asm volatile ("sti");
801049df:	fb                   	sti    
}
801049e0:	c9                   	leave  
801049e1:	c3                   	ret    
        panic("popcli - interruptible");
801049e2:	83 ec 0c             	sub    $0xc,%esp
801049e5:	68 63 7d 10 80       	push   $0x80107d63
801049ea:	e8 91 ba ff ff       	call   80100480 <panic>
        panic("popcli");
801049ef:	83 ec 0c             	sub    $0xc,%esp
801049f2:	68 7a 7d 10 80       	push   $0x80107d7a
801049f7:	e8 84 ba ff ff       	call   80100480 <panic>
801049fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a00 <holding>:
int holding(struct spinlock *lock) {
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	56                   	push   %esi
80104a04:	53                   	push   %ebx
80104a05:	8b 75 08             	mov    0x8(%ebp),%esi
80104a08:	31 db                	xor    %ebx,%ebx
    pushcli();
80104a0a:	e8 51 ff ff ff       	call   80104960 <pushcli>
    r = lock->locked && lock->cpu == mycpu();
80104a0f:	8b 06                	mov    (%esi),%eax
80104a11:	85 c0                	test   %eax,%eax
80104a13:	74 10                	je     80104a25 <holding+0x25>
80104a15:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a18:	e8 13 f4 ff ff       	call   80103e30 <mycpu>
80104a1d:	39 c3                	cmp    %eax,%ebx
80104a1f:	0f 94 c3             	sete   %bl
80104a22:	0f b6 db             	movzbl %bl,%ebx
    popcli();
80104a25:	e8 76 ff ff ff       	call   801049a0 <popcli>
}
80104a2a:	89 d8                	mov    %ebx,%eax
80104a2c:	5b                   	pop    %ebx
80104a2d:	5e                   	pop    %esi
80104a2e:	5d                   	pop    %ebp
80104a2f:	c3                   	ret    

80104a30 <acquire>:
void acquire(struct spinlock *lk) {
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	53                   	push   %ebx
    pushcli(); // disable interrupts to avoid deadlock.
80104a35:	e8 26 ff ff ff       	call   80104960 <pushcli>
    if (holding(lk)) {
80104a3a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a3d:	83 ec 0c             	sub    $0xc,%esp
80104a40:	53                   	push   %ebx
80104a41:	e8 ba ff ff ff       	call   80104a00 <holding>
80104a46:	83 c4 10             	add    $0x10,%esp
80104a49:	85 c0                	test   %eax,%eax
80104a4b:	0f 85 83 00 00 00    	jne    80104ad4 <acquire+0xa4>
80104a51:	89 c6                	mov    %eax,%esi
    asm volatile ("lock; xchgl %0, %1" :
80104a53:	ba 01 00 00 00       	mov    $0x1,%edx
80104a58:	eb 09                	jmp    80104a63 <acquire+0x33>
80104a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a60:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a63:	89 d0                	mov    %edx,%eax
80104a65:	f0 87 03             	lock xchg %eax,(%ebx)
    while (xchg(&lk->locked, 1) != 0) {
80104a68:	85 c0                	test   %eax,%eax
80104a6a:	75 f4                	jne    80104a60 <acquire+0x30>
    __sync_synchronize();
80104a6c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    lk->cpu = mycpu();
80104a71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a74:	e8 b7 f3 ff ff       	call   80103e30 <mycpu>
    getcallerpcs(&lk, lk->pcs);
80104a79:	8d 53 0c             	lea    0xc(%ebx),%edx
    lk->cpu = mycpu();
80104a7c:	89 43 08             	mov    %eax,0x8(%ebx)
    ebp = (uint*)v - 2;
80104a7f:	89 e8                	mov    %ebp,%eax
80104a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff) {
80104a88:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104a8e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104a94:	77 1a                	ja     80104ab0 <acquire+0x80>
        pcs[i] = ebp[1];     // saved %eip
80104a96:	8b 48 04             	mov    0x4(%eax),%ecx
80104a99:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
    for (i = 0; i < 10; i++) {
80104a9c:	83 c6 01             	add    $0x1,%esi
        ebp = (uint*)ebp[0]; // saved %ebp
80104a9f:	8b 00                	mov    (%eax),%eax
    for (i = 0; i < 10; i++) {
80104aa1:	83 fe 0a             	cmp    $0xa,%esi
80104aa4:	75 e2                	jne    80104a88 <acquire+0x58>
}
80104aa6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104aa9:	5b                   	pop    %ebx
80104aaa:	5e                   	pop    %esi
80104aab:	5d                   	pop    %ebp
80104aac:	c3                   	ret    
80104aad:	8d 76 00             	lea    0x0(%esi),%esi
80104ab0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104ab3:	83 c2 28             	add    $0x28,%edx
80104ab6:	8d 76 00             	lea    0x0(%esi),%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        pcs[i] = 0;
80104ac0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ac6:	83 c0 04             	add    $0x4,%eax
    for (; i < 10; i++) {
80104ac9:	39 d0                	cmp    %edx,%eax
80104acb:	75 f3                	jne    80104ac0 <acquire+0x90>
}
80104acd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ad0:	5b                   	pop    %ebx
80104ad1:	5e                   	pop    %esi
80104ad2:	5d                   	pop    %ebp
80104ad3:	c3                   	ret    
        panic("acquire");
80104ad4:	83 ec 0c             	sub    $0xc,%esp
80104ad7:	68 81 7d 10 80       	push   $0x80107d81
80104adc:	e8 9f b9 ff ff       	call   80100480 <panic>
80104ae1:	eb 0d                	jmp    80104af0 <release>
80104ae3:	90                   	nop
80104ae4:	90                   	nop
80104ae5:	90                   	nop
80104ae6:	90                   	nop
80104ae7:	90                   	nop
80104ae8:	90                   	nop
80104ae9:	90                   	nop
80104aea:	90                   	nop
80104aeb:	90                   	nop
80104aec:	90                   	nop
80104aed:	90                   	nop
80104aee:	90                   	nop
80104aef:	90                   	nop

80104af0 <release>:
void release(struct spinlock *lk) {
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	53                   	push   %ebx
80104af4:	83 ec 10             	sub    $0x10,%esp
80104af7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (!holding(lk)) {
80104afa:	53                   	push   %ebx
80104afb:	e8 00 ff ff ff       	call   80104a00 <holding>
80104b00:	83 c4 10             	add    $0x10,%esp
80104b03:	85 c0                	test   %eax,%eax
80104b05:	74 22                	je     80104b29 <release+0x39>
    lk->pcs[0] = 0;
80104b07:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    lk->cpu = 0;
80104b0e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    __sync_synchronize();
80104b15:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    asm volatile ("movl $0, %0" : "+m" (lk->locked) :);
80104b1a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104b20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b23:	c9                   	leave  
    popcli();
80104b24:	e9 77 fe ff ff       	jmp    801049a0 <popcli>
        panic("release");
80104b29:	83 ec 0c             	sub    $0xc,%esp
80104b2c:	68 89 7d 10 80       	push   $0x80107d89
80104b31:	e8 4a b9 ff ff       	call   80100480 <panic>
80104b36:	66 90                	xchg   %ax,%ax
80104b38:	66 90                	xchg   %ax,%ax
80104b3a:	66 90                	xchg   %ax,%ax
80104b3c:	66 90                	xchg   %ax,%ax
80104b3e:	66 90                	xchg   %ax,%ax

80104b40 <memset>:
#include "types.h"
#include "x86.h"

void* memset(void *dst, int c, uint n) {
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	57                   	push   %edi
80104b44:	53                   	push   %ebx
80104b45:	8b 55 08             	mov    0x8(%ebp),%edx
80104b48:	8b 4d 10             	mov    0x10(%ebp),%ecx
    if ((int)dst % 4 == 0 && n % 4 == 0) {
80104b4b:	f6 c2 03             	test   $0x3,%dl
80104b4e:	75 05                	jne    80104b55 <memset+0x15>
80104b50:	f6 c1 03             	test   $0x3,%cl
80104b53:	74 13                	je     80104b68 <memset+0x28>
    asm volatile ("cld; rep stosb" :
80104b55:	89 d7                	mov    %edx,%edi
80104b57:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b5a:	fc                   	cld    
80104b5b:	f3 aa                	rep stos %al,%es:(%edi)
    }
    else {
        stosb(dst, c, n);
    }
    return dst;
}
80104b5d:	5b                   	pop    %ebx
80104b5e:	89 d0                	mov    %edx,%eax
80104b60:	5f                   	pop    %edi
80104b61:	5d                   	pop    %ebp
80104b62:	c3                   	ret    
80104b63:	90                   	nop
80104b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        c &= 0xFF;
80104b68:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
        stosl(dst, (c << 24) | (c << 16) | (c << 8) | c, n / 4);
80104b6c:	c1 e9 02             	shr    $0x2,%ecx
80104b6f:	89 f8                	mov    %edi,%eax
80104b71:	89 fb                	mov    %edi,%ebx
80104b73:	c1 e0 18             	shl    $0x18,%eax
80104b76:	c1 e3 10             	shl    $0x10,%ebx
80104b79:	09 d8                	or     %ebx,%eax
80104b7b:	09 f8                	or     %edi,%eax
80104b7d:	c1 e7 08             	shl    $0x8,%edi
80104b80:	09 f8                	or     %edi,%eax
    asm volatile ("cld; rep stosl" :
80104b82:	89 d7                	mov    %edx,%edi
80104b84:	fc                   	cld    
80104b85:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104b87:	5b                   	pop    %ebx
80104b88:	89 d0                	mov    %edx,%eax
80104b8a:	5f                   	pop    %edi
80104b8b:	5d                   	pop    %ebp
80104b8c:	c3                   	ret    
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi

80104b90 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n) {
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	57                   	push   %edi
80104b94:	56                   	push   %esi
80104b95:	53                   	push   %ebx
80104b96:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104b99:	8b 75 08             	mov    0x8(%ebp),%esi
80104b9c:	8b 7d 0c             	mov    0xc(%ebp),%edi
    const uchar *s1, *s2;

    s1 = v1;
    s2 = v2;
    while (n-- > 0) {
80104b9f:	85 db                	test   %ebx,%ebx
80104ba1:	74 29                	je     80104bcc <memcmp+0x3c>
        if (*s1 != *s2) {
80104ba3:	0f b6 16             	movzbl (%esi),%edx
80104ba6:	0f b6 0f             	movzbl (%edi),%ecx
80104ba9:	38 d1                	cmp    %dl,%cl
80104bab:	75 2b                	jne    80104bd8 <memcmp+0x48>
80104bad:	b8 01 00 00 00       	mov    $0x1,%eax
80104bb2:	eb 14                	jmp    80104bc8 <memcmp+0x38>
80104bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bb8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104bbc:	83 c0 01             	add    $0x1,%eax
80104bbf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104bc4:	38 ca                	cmp    %cl,%dl
80104bc6:	75 10                	jne    80104bd8 <memcmp+0x48>
    while (n-- > 0) {
80104bc8:	39 d8                	cmp    %ebx,%eax
80104bca:	75 ec                	jne    80104bb8 <memcmp+0x28>
        }
        s1++, s2++;
    }

    return 0;
}
80104bcc:	5b                   	pop    %ebx
    return 0;
80104bcd:	31 c0                	xor    %eax,%eax
}
80104bcf:	5e                   	pop    %esi
80104bd0:	5f                   	pop    %edi
80104bd1:	5d                   	pop    %ebp
80104bd2:	c3                   	ret    
80104bd3:	90                   	nop
80104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            return *s1 - *s2;
80104bd8:	0f b6 c2             	movzbl %dl,%eax
}
80104bdb:	5b                   	pop    %ebx
            return *s1 - *s2;
80104bdc:	29 c8                	sub    %ecx,%eax
}
80104bde:	5e                   	pop    %esi
80104bdf:	5f                   	pop    %edi
80104be0:	5d                   	pop    %ebp
80104be1:	c3                   	ret    
80104be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bf0 <memmove>:

void* memmove(void *dst, const void *src, uint n) {
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	53                   	push   %ebx
80104bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80104bf8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104bfb:	8b 75 10             	mov    0x10(%ebp),%esi
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
80104bfe:	39 c3                	cmp    %eax,%ebx
80104c00:	73 26                	jae    80104c28 <memmove+0x38>
80104c02:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104c05:	39 c8                	cmp    %ecx,%eax
80104c07:	73 1f                	jae    80104c28 <memmove+0x38>
        s += n;
        d += n;
        while (n-- > 0) {
80104c09:	85 f6                	test   %esi,%esi
80104c0b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104c0e:	74 0f                	je     80104c1f <memmove+0x2f>
            *--d = *--s;
80104c10:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104c14:	88 0c 10             	mov    %cl,(%eax,%edx,1)
        while (n-- > 0) {
80104c17:	83 ea 01             	sub    $0x1,%edx
80104c1a:	83 fa ff             	cmp    $0xffffffff,%edx
80104c1d:	75 f1                	jne    80104c10 <memmove+0x20>
            *d++ = *s++;
        }
    }

    return dst;
}
80104c1f:	5b                   	pop    %ebx
80104c20:	5e                   	pop    %esi
80104c21:	5d                   	pop    %ebp
80104c22:	c3                   	ret    
80104c23:	90                   	nop
80104c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        while (n-- > 0) {
80104c28:	31 d2                	xor    %edx,%edx
80104c2a:	85 f6                	test   %esi,%esi
80104c2c:	74 f1                	je     80104c1f <memmove+0x2f>
80104c2e:	66 90                	xchg   %ax,%ax
            *d++ = *s++;
80104c30:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104c34:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104c37:	83 c2 01             	add    $0x1,%edx
        while (n-- > 0) {
80104c3a:	39 d6                	cmp    %edx,%esi
80104c3c:	75 f2                	jne    80104c30 <memmove+0x40>
}
80104c3e:	5b                   	pop    %ebx
80104c3f:	5e                   	pop    %esi
80104c40:	5d                   	pop    %ebp
80104c41:	c3                   	ret    
80104c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c50 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void* memcpy(void *dst, const void *src, uint n) {
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
    return memmove(dst, src, n);
}
80104c53:	5d                   	pop    %ebp
    return memmove(dst, src, n);
80104c54:	eb 9a                	jmp    80104bf0 <memmove>
80104c56:	8d 76 00             	lea    0x0(%esi),%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <strncmp>:

int strncmp(const char *p, const char *q, uint n) {
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	57                   	push   %edi
80104c64:	56                   	push   %esi
80104c65:	8b 7d 10             	mov    0x10(%ebp),%edi
80104c68:	53                   	push   %ebx
80104c69:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c6c:	8b 75 0c             	mov    0xc(%ebp),%esi
    while (n > 0 && *p && *p == *q) {
80104c6f:	85 ff                	test   %edi,%edi
80104c71:	74 2f                	je     80104ca2 <strncmp+0x42>
80104c73:	0f b6 01             	movzbl (%ecx),%eax
80104c76:	0f b6 1e             	movzbl (%esi),%ebx
80104c79:	84 c0                	test   %al,%al
80104c7b:	74 37                	je     80104cb4 <strncmp+0x54>
80104c7d:	38 c3                	cmp    %al,%bl
80104c7f:	75 33                	jne    80104cb4 <strncmp+0x54>
80104c81:	01 f7                	add    %esi,%edi
80104c83:	eb 13                	jmp    80104c98 <strncmp+0x38>
80104c85:	8d 76 00             	lea    0x0(%esi),%esi
80104c88:	0f b6 01             	movzbl (%ecx),%eax
80104c8b:	84 c0                	test   %al,%al
80104c8d:	74 21                	je     80104cb0 <strncmp+0x50>
80104c8f:	0f b6 1a             	movzbl (%edx),%ebx
80104c92:	89 d6                	mov    %edx,%esi
80104c94:	38 d8                	cmp    %bl,%al
80104c96:	75 1c                	jne    80104cb4 <strncmp+0x54>
        n--, p++, q++;
80104c98:	8d 56 01             	lea    0x1(%esi),%edx
80104c9b:	83 c1 01             	add    $0x1,%ecx
    while (n > 0 && *p && *p == *q) {
80104c9e:	39 fa                	cmp    %edi,%edx
80104ca0:	75 e6                	jne    80104c88 <strncmp+0x28>
    }
    if (n == 0) {
        return 0;
    }
    return (uchar) * p - (uchar) * q;
}
80104ca2:	5b                   	pop    %ebx
        return 0;
80104ca3:	31 c0                	xor    %eax,%eax
}
80104ca5:	5e                   	pop    %esi
80104ca6:	5f                   	pop    %edi
80104ca7:	5d                   	pop    %ebp
80104ca8:	c3                   	ret    
80104ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cb0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
    return (uchar) * p - (uchar) * q;
80104cb4:	29 d8                	sub    %ebx,%eax
}
80104cb6:	5b                   	pop    %ebx
80104cb7:	5e                   	pop    %esi
80104cb8:	5f                   	pop    %edi
80104cb9:	5d                   	pop    %ebp
80104cba:	c3                   	ret    
80104cbb:	90                   	nop
80104cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cc0 <strncpy>:

char* strncpy(char *s, const char *t, int n) {
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	56                   	push   %esi
80104cc4:	53                   	push   %ebx
80104cc5:	8b 45 08             	mov    0x8(%ebp),%eax
80104cc8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104ccb:	8b 4d 10             	mov    0x10(%ebp),%ecx
    char *os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0) {
80104cce:	89 c2                	mov    %eax,%edx
80104cd0:	eb 19                	jmp    80104ceb <strncpy+0x2b>
80104cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cd8:	83 c3 01             	add    $0x1,%ebx
80104cdb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104cdf:	83 c2 01             	add    $0x1,%edx
80104ce2:	84 c9                	test   %cl,%cl
80104ce4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ce7:	74 09                	je     80104cf2 <strncpy+0x32>
80104ce9:	89 f1                	mov    %esi,%ecx
80104ceb:	85 c9                	test   %ecx,%ecx
80104ced:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104cf0:	7f e6                	jg     80104cd8 <strncpy+0x18>
        ;
    }
    while (n-- > 0) {
80104cf2:	31 c9                	xor    %ecx,%ecx
80104cf4:	85 f6                	test   %esi,%esi
80104cf6:	7e 17                	jle    80104d0f <strncpy+0x4f>
80104cf8:	90                   	nop
80104cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        *s++ = 0;
80104d00:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104d04:	89 f3                	mov    %esi,%ebx
80104d06:	83 c1 01             	add    $0x1,%ecx
80104d09:	29 cb                	sub    %ecx,%ebx
    while (n-- > 0) {
80104d0b:	85 db                	test   %ebx,%ebx
80104d0d:	7f f1                	jg     80104d00 <strncpy+0x40>
    }
    return os;
}
80104d0f:	5b                   	pop    %ebx
80104d10:	5e                   	pop    %esi
80104d11:	5d                   	pop    %ebp
80104d12:	c3                   	ret    
80104d13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char* safestrcpy(char *s, const char *t, int n) {
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	56                   	push   %esi
80104d24:	53                   	push   %ebx
80104d25:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d28:	8b 45 08             	mov    0x8(%ebp),%eax
80104d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
    char *os;

    os = s;
    if (n <= 0) {
80104d2e:	85 c9                	test   %ecx,%ecx
80104d30:	7e 26                	jle    80104d58 <safestrcpy+0x38>
80104d32:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104d36:	89 c1                	mov    %eax,%ecx
80104d38:	eb 17                	jmp    80104d51 <safestrcpy+0x31>
80104d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return os;
    }
    while (--n > 0 && (*s++ = *t++) != 0) {
80104d40:	83 c2 01             	add    $0x1,%edx
80104d43:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104d47:	83 c1 01             	add    $0x1,%ecx
80104d4a:	84 db                	test   %bl,%bl
80104d4c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104d4f:	74 04                	je     80104d55 <safestrcpy+0x35>
80104d51:	39 f2                	cmp    %esi,%edx
80104d53:	75 eb                	jne    80104d40 <safestrcpy+0x20>
        ;
    }
    *s = 0;
80104d55:	c6 01 00             	movb   $0x0,(%ecx)
    return os;
}
80104d58:	5b                   	pop    %ebx
80104d59:	5e                   	pop    %esi
80104d5a:	5d                   	pop    %ebp
80104d5b:	c3                   	ret    
80104d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d60 <strlen>:

int strlen(const char *s) {
80104d60:	55                   	push   %ebp
    int n;

    for (n = 0; s[n]; n++) {
80104d61:	31 c0                	xor    %eax,%eax
int strlen(const char *s) {
80104d63:	89 e5                	mov    %esp,%ebp
80104d65:	8b 55 08             	mov    0x8(%ebp),%edx
    for (n = 0; s[n]; n++) {
80104d68:	80 3a 00             	cmpb   $0x0,(%edx)
80104d6b:	74 0c                	je     80104d79 <strlen+0x19>
80104d6d:	8d 76 00             	lea    0x0(%esi),%esi
80104d70:	83 c0 01             	add    $0x1,%eax
80104d73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d77:	75 f7                	jne    80104d70 <strlen+0x10>
        ;
    }
    return n;
}
80104d79:	5d                   	pop    %ebp
80104d7a:	c3                   	ret    

80104d7b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
    movl 4(%esp), %eax
80104d7b:	8b 44 24 04          	mov    0x4(%esp),%eax
    movl 8(%esp), %edx
80104d7f:	8b 54 24 08          	mov    0x8(%esp),%edx

    # Save old callee-saved registers
    pushl %ebp
80104d83:	55                   	push   %ebp
    pushl %ebx
80104d84:	53                   	push   %ebx
    pushl %esi
80104d85:	56                   	push   %esi
    pushl %edi
80104d86:	57                   	push   %edi

    # Switch stacks
    movl %esp, (%eax)
80104d87:	89 20                	mov    %esp,(%eax)
    movl %edx, %esp
80104d89:	89 d4                	mov    %edx,%esp

    # Load new callee-saved registers
    popl %edi
80104d8b:	5f                   	pop    %edi
    popl %esi
80104d8c:	5e                   	pop    %esi
    popl %ebx
80104d8d:	5b                   	pop    %ebx
    popl %ebp
80104d8e:	5d                   	pop    %ebp
    ret
80104d8f:	c3                   	ret    

80104d90 <fetchint>:
// Arguments on the stack, from the user call to the C
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int fetchint(uint addr, int *ip)  {
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	53                   	push   %ebx
80104d94:	83 ec 04             	sub    $0x4,%esp
80104d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *curproc = myproc();
80104d9a:	e8 31 f1 ff ff       	call   80103ed0 <myproc>

    if (addr >= curproc->sz || addr + 4 > curproc->sz) {
80104d9f:	8b 00                	mov    (%eax),%eax
80104da1:	39 d8                	cmp    %ebx,%eax
80104da3:	76 1b                	jbe    80104dc0 <fetchint+0x30>
80104da5:	8d 53 04             	lea    0x4(%ebx),%edx
80104da8:	39 d0                	cmp    %edx,%eax
80104daa:	72 14                	jb     80104dc0 <fetchint+0x30>
        return -1;
    }
    *ip = *(int*)(addr);
80104dac:	8b 45 0c             	mov    0xc(%ebp),%eax
80104daf:	8b 13                	mov    (%ebx),%edx
80104db1:	89 10                	mov    %edx,(%eax)
    return 0;
80104db3:	31 c0                	xor    %eax,%eax
}
80104db5:	83 c4 04             	add    $0x4,%esp
80104db8:	5b                   	pop    %ebx
80104db9:	5d                   	pop    %ebp
80104dba:	c3                   	ret    
80104dbb:	90                   	nop
80104dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80104dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc5:	eb ee                	jmp    80104db5 <fetchint+0x25>
80104dc7:	89 f6                	mov    %esi,%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int fetchstr(uint addr, char **pp) {
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	53                   	push   %ebx
80104dd4:	83 ec 04             	sub    $0x4,%esp
80104dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    char *s, *ep;
    struct proc *curproc = myproc();
80104dda:	e8 f1 f0 ff ff       	call   80103ed0 <myproc>

    if (addr >= curproc->sz) {
80104ddf:	39 18                	cmp    %ebx,(%eax)
80104de1:	76 29                	jbe    80104e0c <fetchstr+0x3c>
        return -1;
    }
    *pp = (char*)addr;
80104de3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104de6:	89 da                	mov    %ebx,%edx
80104de8:	89 19                	mov    %ebx,(%ecx)
    ep = (char*)curproc->sz;
80104dea:	8b 00                	mov    (%eax),%eax
    for (s = *pp; s < ep; s++) {
80104dec:	39 c3                	cmp    %eax,%ebx
80104dee:	73 1c                	jae    80104e0c <fetchstr+0x3c>
        if (*s == 0) {
80104df0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104df3:	75 10                	jne    80104e05 <fetchstr+0x35>
80104df5:	eb 39                	jmp    80104e30 <fetchstr+0x60>
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e00:	80 3a 00             	cmpb   $0x0,(%edx)
80104e03:	74 1b                	je     80104e20 <fetchstr+0x50>
    for (s = *pp; s < ep; s++) {
80104e05:	83 c2 01             	add    $0x1,%edx
80104e08:	39 d0                	cmp    %edx,%eax
80104e0a:	77 f4                	ja     80104e00 <fetchstr+0x30>
        return -1;
80104e0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            return s - *pp;
        }
    }
    return -1;
}
80104e11:	83 c4 04             	add    $0x4,%esp
80104e14:	5b                   	pop    %ebx
80104e15:	5d                   	pop    %ebp
80104e16:	c3                   	ret    
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e20:	83 c4 04             	add    $0x4,%esp
80104e23:	89 d0                	mov    %edx,%eax
80104e25:	29 d8                	sub    %ebx,%eax
80104e27:	5b                   	pop    %ebx
80104e28:	5d                   	pop    %ebp
80104e29:	c3                   	ret    
80104e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (*s == 0) {
80104e30:	31 c0                	xor    %eax,%eax
            return s - *pp;
80104e32:	eb dd                	jmp    80104e11 <fetchstr+0x41>
80104e34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e40 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip) {
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104e45:	e8 86 f0 ff ff       	call   80103ed0 <myproc>
80104e4a:	8b 40 18             	mov    0x18(%eax),%eax
80104e4d:	8b 55 08             	mov    0x8(%ebp),%edx
80104e50:	8b 40 44             	mov    0x44(%eax),%eax
80104e53:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    struct proc *curproc = myproc();
80104e56:	e8 75 f0 ff ff       	call   80103ed0 <myproc>
    if (addr >= curproc->sz || addr + 4 > curproc->sz) {
80104e5b:	8b 00                	mov    (%eax),%eax
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104e5d:	8d 73 04             	lea    0x4(%ebx),%esi
    if (addr >= curproc->sz || addr + 4 > curproc->sz) {
80104e60:	39 c6                	cmp    %eax,%esi
80104e62:	73 1c                	jae    80104e80 <argint+0x40>
80104e64:	8d 53 08             	lea    0x8(%ebx),%edx
80104e67:	39 d0                	cmp    %edx,%eax
80104e69:	72 15                	jb     80104e80 <argint+0x40>
    *ip = *(int*)(addr);
80104e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e6e:	8b 53 04             	mov    0x4(%ebx),%edx
80104e71:	89 10                	mov    %edx,(%eax)
    return 0;
80104e73:	31 c0                	xor    %eax,%eax
}
80104e75:	5b                   	pop    %ebx
80104e76:	5e                   	pop    %esi
80104e77:	5d                   	pop    %ebp
80104e78:	c3                   	ret    
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80104e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104e85:	eb ee                	jmp    80104e75 <argint+0x35>
80104e87:	89 f6                	mov    %esi,%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e90 <argptr>:

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int argptr(int n, char **pp, int size) {
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
80104e95:	83 ec 10             	sub    $0x10,%esp
80104e98:	8b 5d 10             	mov    0x10(%ebp),%ebx
    int i;
    struct proc *curproc = myproc();
80104e9b:	e8 30 f0 ff ff       	call   80103ed0 <myproc>
80104ea0:	89 c6                	mov    %eax,%esi

    if (argint(n, &i) < 0) {
80104ea2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ea5:	83 ec 08             	sub    $0x8,%esp
80104ea8:	50                   	push   %eax
80104ea9:	ff 75 08             	pushl  0x8(%ebp)
80104eac:	e8 8f ff ff ff       	call   80104e40 <argint>
        return -1;
    }
    if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz) {
80104eb1:	83 c4 10             	add    $0x10,%esp
80104eb4:	85 c0                	test   %eax,%eax
80104eb6:	78 28                	js     80104ee0 <argptr+0x50>
80104eb8:	85 db                	test   %ebx,%ebx
80104eba:	78 24                	js     80104ee0 <argptr+0x50>
80104ebc:	8b 16                	mov    (%esi),%edx
80104ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec1:	39 c2                	cmp    %eax,%edx
80104ec3:	76 1b                	jbe    80104ee0 <argptr+0x50>
80104ec5:	01 c3                	add    %eax,%ebx
80104ec7:	39 da                	cmp    %ebx,%edx
80104ec9:	72 15                	jb     80104ee0 <argptr+0x50>
        return -1;
    }
    *pp = (char*)i;
80104ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ece:	89 02                	mov    %eax,(%edx)
    return 0;
80104ed0:	31 c0                	xor    %eax,%eax
}
80104ed2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ed5:	5b                   	pop    %ebx
80104ed6:	5e                   	pop    %esi
80104ed7:	5d                   	pop    %ebp
80104ed8:	c3                   	ret    
80104ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80104ee0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee5:	eb eb                	jmp    80104ed2 <argptr+0x42>
80104ee7:	89 f6                	mov    %esi,%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ef0 <argstr>:

// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int argstr(int n, char **pp) {
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	83 ec 20             	sub    $0x20,%esp
    int addr;
    if (argint(n, &addr) < 0) {
80104ef6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ef9:	50                   	push   %eax
80104efa:	ff 75 08             	pushl  0x8(%ebp)
80104efd:	e8 3e ff ff ff       	call   80104e40 <argint>
80104f02:	83 c4 10             	add    $0x10,%esp
80104f05:	85 c0                	test   %eax,%eax
80104f07:	78 17                	js     80104f20 <argstr+0x30>
        return -1;
    }
    return fetchstr(addr, pp);
80104f09:	83 ec 08             	sub    $0x8,%esp
80104f0c:	ff 75 0c             	pushl  0xc(%ebp)
80104f0f:	ff 75 f4             	pushl  -0xc(%ebp)
80104f12:	e8 b9 fe ff ff       	call   80104dd0 <fetchstr>
80104f17:	83 c4 10             	add    $0x10,%esp
}
80104f1a:	c9                   	leave  
80104f1b:	c3                   	ret    
80104f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80104f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f25:	c9                   	leave  
80104f26:	c3                   	ret    
80104f27:	89 f6                	mov    %esi,%esi
80104f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f30 <syscall>:
    [SYS_videomodetext] sys_videomodetext,
    [SYS_setspecificpixel] sys_setspecificpixel,
    // TODO: Add your system call function to the OS syscall table.
};

void syscall(void) {
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	53                   	push   %ebx
80104f34:	83 ec 04             	sub    $0x4,%esp
    int num;
    struct proc *curproc = myproc();
80104f37:	e8 94 ef ff ff       	call   80103ed0 <myproc>
80104f3c:	89 c3                	mov    %eax,%ebx

    num = curproc->tf->eax;
80104f3e:	8b 40 18             	mov    0x18(%eax),%eax
80104f41:	8b 40 1c             	mov    0x1c(%eax),%eax
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f44:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f47:	83 fa 19             	cmp    $0x19,%edx
80104f4a:	77 1c                	ja     80104f68 <syscall+0x38>
80104f4c:	8b 14 85 c0 7d 10 80 	mov    -0x7fef8240(,%eax,4),%edx
80104f53:	85 d2                	test   %edx,%edx
80104f55:	74 11                	je     80104f68 <syscall+0x38>
        curproc->tf->eax = syscalls[num]();
80104f57:	ff d2                	call   *%edx
80104f59:	8b 53 18             	mov    0x18(%ebx),%edx
80104f5c:	89 42 1c             	mov    %eax,0x1c(%edx)
    else {
        cprintf("%d %s: unknown sys call %d\n",
                curproc->pid, curproc->name, num);
        curproc->tf->eax = -1;
    }
}
80104f5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f62:	c9                   	leave  
80104f63:	c3                   	ret    
80104f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf("%d %s: unknown sys call %d\n",
80104f68:	50                   	push   %eax
                curproc->pid, curproc->name, num);
80104f69:	8d 43 6c             	lea    0x6c(%ebx),%eax
        cprintf("%d %s: unknown sys call %d\n",
80104f6c:	50                   	push   %eax
80104f6d:	ff 73 10             	pushl  0x10(%ebx)
80104f70:	68 91 7d 10 80       	push   $0x80107d91
80104f75:	e8 86 b8 ff ff       	call   80100800 <cprintf>
        curproc->tf->eax = -1;
80104f7a:	8b 43 18             	mov    0x18(%ebx),%eax
80104f7d:	83 c4 10             	add    $0x10,%esp
80104f80:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104f87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f8a:	c9                   	leave  
80104f8b:	c3                   	ret    
80104f8c:	66 90                	xchg   %ax,%ax
80104f8e:	66 90                	xchg   %ax,%ax

80104f90 <create>:
    end_op();

    return 0;
}

static struct inode* create(char *path, short type, short major, short minor)  {
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	57                   	push   %edi
80104f94:	56                   	push   %esi
80104f95:	53                   	push   %ebx
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0) {
80104f96:	8d 75 da             	lea    -0x26(%ebp),%esi
static struct inode* create(char *path, short type, short major, short minor)  {
80104f99:	83 ec 34             	sub    $0x34,%esp
80104f9c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104f9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
    if ((dp = nameiparent(path, name)) == 0) {
80104fa2:	56                   	push   %esi
80104fa3:	50                   	push   %eax
static struct inode* create(char *path, short type, short major, short minor)  {
80104fa4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104fa7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
    if ((dp = nameiparent(path, name)) == 0) {
80104faa:	e8 11 d6 ff ff       	call   801025c0 <nameiparent>
80104faf:	83 c4 10             	add    $0x10,%esp
80104fb2:	85 c0                	test   %eax,%eax
80104fb4:	0f 84 46 01 00 00    	je     80105100 <create+0x170>
        return 0;
    }
    ilock(dp);
80104fba:	83 ec 0c             	sub    $0xc,%esp
80104fbd:	89 c3                	mov    %eax,%ebx
80104fbf:	50                   	push   %eax
80104fc0:	e8 7b cd ff ff       	call   80101d40 <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0) {
80104fc5:	83 c4 0c             	add    $0xc,%esp
80104fc8:	6a 00                	push   $0x0
80104fca:	56                   	push   %esi
80104fcb:	53                   	push   %ebx
80104fcc:	e8 9f d2 ff ff       	call   80102270 <dirlookup>
80104fd1:	83 c4 10             	add    $0x10,%esp
80104fd4:	85 c0                	test   %eax,%eax
80104fd6:	89 c7                	mov    %eax,%edi
80104fd8:	74 36                	je     80105010 <create+0x80>
        iunlockput(dp);
80104fda:	83 ec 0c             	sub    $0xc,%esp
80104fdd:	53                   	push   %ebx
80104fde:	e8 ed cf ff ff       	call   80101fd0 <iunlockput>
        ilock(ip);
80104fe3:	89 3c 24             	mov    %edi,(%esp)
80104fe6:	e8 55 cd ff ff       	call   80101d40 <ilock>
        if (type == T_FILE && ip->type == T_FILE) {
80104feb:	83 c4 10             	add    $0x10,%esp
80104fee:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104ff3:	0f 85 97 00 00 00    	jne    80105090 <create+0x100>
80104ff9:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104ffe:	0f 85 8c 00 00 00    	jne    80105090 <create+0x100>
    }

    iunlockput(dp);

    return ip;
}
80105004:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105007:	89 f8                	mov    %edi,%eax
80105009:	5b                   	pop    %ebx
8010500a:	5e                   	pop    %esi
8010500b:	5f                   	pop    %edi
8010500c:	5d                   	pop    %ebp
8010500d:	c3                   	ret    
8010500e:	66 90                	xchg   %ax,%ax
    if ((ip = ialloc(dp->dev, type)) == 0) {
80105010:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105014:	83 ec 08             	sub    $0x8,%esp
80105017:	50                   	push   %eax
80105018:	ff 33                	pushl  (%ebx)
8010501a:	e8 b1 cb ff ff       	call   80101bd0 <ialloc>
8010501f:	83 c4 10             	add    $0x10,%esp
80105022:	85 c0                	test   %eax,%eax
80105024:	89 c7                	mov    %eax,%edi
80105026:	0f 84 e8 00 00 00    	je     80105114 <create+0x184>
    ilock(ip);
8010502c:	83 ec 0c             	sub    $0xc,%esp
8010502f:	50                   	push   %eax
80105030:	e8 0b cd ff ff       	call   80101d40 <ilock>
    ip->major = major;
80105035:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105039:	66 89 47 52          	mov    %ax,0x52(%edi)
    ip->minor = minor;
8010503d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105041:	66 89 47 54          	mov    %ax,0x54(%edi)
    ip->nlink = 1;
80105045:	b8 01 00 00 00       	mov    $0x1,%eax
8010504a:	66 89 47 56          	mov    %ax,0x56(%edi)
    iupdate(ip);
8010504e:	89 3c 24             	mov    %edi,(%esp)
80105051:	e8 3a cc ff ff       	call   80101c90 <iupdate>
    if (type == T_DIR) { // Create . and .. entries.
80105056:	83 c4 10             	add    $0x10,%esp
80105059:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010505e:	74 50                	je     801050b0 <create+0x120>
    if (dirlink(dp, name, ip->inum) < 0) {
80105060:	83 ec 04             	sub    $0x4,%esp
80105063:	ff 77 04             	pushl  0x4(%edi)
80105066:	56                   	push   %esi
80105067:	53                   	push   %ebx
80105068:	e8 73 d4 ff ff       	call   801024e0 <dirlink>
8010506d:	83 c4 10             	add    $0x10,%esp
80105070:	85 c0                	test   %eax,%eax
80105072:	0f 88 8f 00 00 00    	js     80105107 <create+0x177>
    iunlockput(dp);
80105078:	83 ec 0c             	sub    $0xc,%esp
8010507b:	53                   	push   %ebx
8010507c:	e8 4f cf ff ff       	call   80101fd0 <iunlockput>
    return ip;
80105081:	83 c4 10             	add    $0x10,%esp
}
80105084:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105087:	89 f8                	mov    %edi,%eax
80105089:	5b                   	pop    %ebx
8010508a:	5e                   	pop    %esi
8010508b:	5f                   	pop    %edi
8010508c:	5d                   	pop    %ebp
8010508d:	c3                   	ret    
8010508e:	66 90                	xchg   %ax,%ax
        iunlockput(ip);
80105090:	83 ec 0c             	sub    $0xc,%esp
80105093:	57                   	push   %edi
        return 0;
80105094:	31 ff                	xor    %edi,%edi
        iunlockput(ip);
80105096:	e8 35 cf ff ff       	call   80101fd0 <iunlockput>
        return 0;
8010509b:	83 c4 10             	add    $0x10,%esp
}
8010509e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050a1:	89 f8                	mov    %edi,%eax
801050a3:	5b                   	pop    %ebx
801050a4:	5e                   	pop    %esi
801050a5:	5f                   	pop    %edi
801050a6:	5d                   	pop    %ebp
801050a7:	c3                   	ret    
801050a8:	90                   	nop
801050a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        dp->nlink++;  // for ".."
801050b0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
        iupdate(dp);
801050b5:	83 ec 0c             	sub    $0xc,%esp
801050b8:	53                   	push   %ebx
801050b9:	e8 d2 cb ff ff       	call   80101c90 <iupdate>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0) {
801050be:	83 c4 0c             	add    $0xc,%esp
801050c1:	ff 77 04             	pushl  0x4(%edi)
801050c4:	68 48 7e 10 80       	push   $0x80107e48
801050c9:	57                   	push   %edi
801050ca:	e8 11 d4 ff ff       	call   801024e0 <dirlink>
801050cf:	83 c4 10             	add    $0x10,%esp
801050d2:	85 c0                	test   %eax,%eax
801050d4:	78 1c                	js     801050f2 <create+0x162>
801050d6:	83 ec 04             	sub    $0x4,%esp
801050d9:	ff 73 04             	pushl  0x4(%ebx)
801050dc:	68 47 7e 10 80       	push   $0x80107e47
801050e1:	57                   	push   %edi
801050e2:	e8 f9 d3 ff ff       	call   801024e0 <dirlink>
801050e7:	83 c4 10             	add    $0x10,%esp
801050ea:	85 c0                	test   %eax,%eax
801050ec:	0f 89 6e ff ff ff    	jns    80105060 <create+0xd0>
            panic("create dots");
801050f2:	83 ec 0c             	sub    $0xc,%esp
801050f5:	68 3b 7e 10 80       	push   $0x80107e3b
801050fa:	e8 81 b3 ff ff       	call   80100480 <panic>
801050ff:	90                   	nop
        return 0;
80105100:	31 ff                	xor    %edi,%edi
80105102:	e9 fd fe ff ff       	jmp    80105004 <create+0x74>
        panic("create: dirlink");
80105107:	83 ec 0c             	sub    $0xc,%esp
8010510a:	68 4a 7e 10 80       	push   $0x80107e4a
8010510f:	e8 6c b3 ff ff       	call   80100480 <panic>
        panic("create: ialloc");
80105114:	83 ec 0c             	sub    $0xc,%esp
80105117:	68 2c 7e 10 80       	push   $0x80107e2c
8010511c:	e8 5f b3 ff ff       	call   80100480 <panic>
80105121:	eb 0d                	jmp    80105130 <argfd.constprop.0>
80105123:	90                   	nop
80105124:	90                   	nop
80105125:	90                   	nop
80105126:	90                   	nop
80105127:	90                   	nop
80105128:	90                   	nop
80105129:	90                   	nop
8010512a:	90                   	nop
8010512b:	90                   	nop
8010512c:	90                   	nop
8010512d:	90                   	nop
8010512e:	90                   	nop
8010512f:	90                   	nop

80105130 <argfd.constprop.0>:
static int argfd(int n, int *pfd, struct file **pf) {
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	56                   	push   %esi
80105134:	53                   	push   %ebx
80105135:	89 c3                	mov    %eax,%ebx
    if (argint(n, &fd) < 0) {
80105137:	8d 45 f4             	lea    -0xc(%ebp),%eax
static int argfd(int n, int *pfd, struct file **pf) {
8010513a:	89 d6                	mov    %edx,%esi
8010513c:	83 ec 18             	sub    $0x18,%esp
    if (argint(n, &fd) < 0) {
8010513f:	50                   	push   %eax
80105140:	6a 00                	push   $0x0
80105142:	e8 f9 fc ff ff       	call   80104e40 <argint>
80105147:	83 c4 10             	add    $0x10,%esp
8010514a:	85 c0                	test   %eax,%eax
8010514c:	78 2a                	js     80105178 <argfd.constprop.0+0x48>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) {
8010514e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105152:	77 24                	ja     80105178 <argfd.constprop.0+0x48>
80105154:	e8 77 ed ff ff       	call   80103ed0 <myproc>
80105159:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010515c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105160:	85 c0                	test   %eax,%eax
80105162:	74 14                	je     80105178 <argfd.constprop.0+0x48>
    if (pfd) {
80105164:	85 db                	test   %ebx,%ebx
80105166:	74 02                	je     8010516a <argfd.constprop.0+0x3a>
        *pfd = fd;
80105168:	89 13                	mov    %edx,(%ebx)
        *pf = f;
8010516a:	89 06                	mov    %eax,(%esi)
    return 0;
8010516c:	31 c0                	xor    %eax,%eax
}
8010516e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105171:	5b                   	pop    %ebx
80105172:	5e                   	pop    %esi
80105173:	5d                   	pop    %ebp
80105174:	c3                   	ret    
80105175:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
80105178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010517d:	eb ef                	jmp    8010516e <argfd.constprop.0+0x3e>
8010517f:	90                   	nop

80105180 <sys_dup>:
int sys_dup(void) {
80105180:	55                   	push   %ebp
    if (argfd(0, 0, &f) < 0) {
80105181:	31 c0                	xor    %eax,%eax
int sys_dup(void) {
80105183:	89 e5                	mov    %esp,%ebp
80105185:	56                   	push   %esi
80105186:	53                   	push   %ebx
    if (argfd(0, 0, &f) < 0) {
80105187:	8d 55 f4             	lea    -0xc(%ebp),%edx
int sys_dup(void) {
8010518a:	83 ec 10             	sub    $0x10,%esp
    if (argfd(0, 0, &f) < 0) {
8010518d:	e8 9e ff ff ff       	call   80105130 <argfd.constprop.0>
80105192:	85 c0                	test   %eax,%eax
80105194:	78 42                	js     801051d8 <sys_dup+0x58>
    if ((fd = fdalloc(f)) < 0) {
80105196:	8b 75 f4             	mov    -0xc(%ebp),%esi
    for (fd = 0; fd < NOFILE; fd++) {
80105199:	31 db                	xor    %ebx,%ebx
    struct proc *curproc = myproc();
8010519b:	e8 30 ed ff ff       	call   80103ed0 <myproc>
801051a0:	eb 0e                	jmp    801051b0 <sys_dup+0x30>
801051a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (fd = 0; fd < NOFILE; fd++) {
801051a8:	83 c3 01             	add    $0x1,%ebx
801051ab:	83 fb 10             	cmp    $0x10,%ebx
801051ae:	74 28                	je     801051d8 <sys_dup+0x58>
        if (curproc->ofile[fd] == 0) {
801051b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051b4:	85 d2                	test   %edx,%edx
801051b6:	75 f0                	jne    801051a8 <sys_dup+0x28>
            curproc->ofile[fd] = f;
801051b8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    filedup(f);
801051bc:	83 ec 0c             	sub    $0xc,%esp
801051bf:	ff 75 f4             	pushl  -0xc(%ebp)
801051c2:	e8 e9 c2 ff ff       	call   801014b0 <filedup>
    return fd;
801051c7:	83 c4 10             	add    $0x10,%esp
}
801051ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051cd:	89 d8                	mov    %ebx,%eax
801051cf:	5b                   	pop    %ebx
801051d0:	5e                   	pop    %esi
801051d1:	5d                   	pop    %ebp
801051d2:	c3                   	ret    
801051d3:	90                   	nop
801051d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return -1;
801051db:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801051e0:	89 d8                	mov    %ebx,%eax
801051e2:	5b                   	pop    %ebx
801051e3:	5e                   	pop    %esi
801051e4:	5d                   	pop    %ebp
801051e5:	c3                   	ret    
801051e6:	8d 76 00             	lea    0x0(%esi),%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051f0 <sys_read>:
int sys_read(void) {
801051f0:	55                   	push   %ebp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) {
801051f1:	31 c0                	xor    %eax,%eax
int sys_read(void) {
801051f3:	89 e5                	mov    %esp,%ebp
801051f5:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) {
801051f8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051fb:	e8 30 ff ff ff       	call   80105130 <argfd.constprop.0>
80105200:	85 c0                	test   %eax,%eax
80105202:	78 4c                	js     80105250 <sys_read+0x60>
80105204:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105207:	83 ec 08             	sub    $0x8,%esp
8010520a:	50                   	push   %eax
8010520b:	6a 02                	push   $0x2
8010520d:	e8 2e fc ff ff       	call   80104e40 <argint>
80105212:	83 c4 10             	add    $0x10,%esp
80105215:	85 c0                	test   %eax,%eax
80105217:	78 37                	js     80105250 <sys_read+0x60>
80105219:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010521c:	83 ec 04             	sub    $0x4,%esp
8010521f:	ff 75 f0             	pushl  -0x10(%ebp)
80105222:	50                   	push   %eax
80105223:	6a 01                	push   $0x1
80105225:	e8 66 fc ff ff       	call   80104e90 <argptr>
8010522a:	83 c4 10             	add    $0x10,%esp
8010522d:	85 c0                	test   %eax,%eax
8010522f:	78 1f                	js     80105250 <sys_read+0x60>
    return fileread(f, p, n);
80105231:	83 ec 04             	sub    $0x4,%esp
80105234:	ff 75 f0             	pushl  -0x10(%ebp)
80105237:	ff 75 f4             	pushl  -0xc(%ebp)
8010523a:	ff 75 ec             	pushl  -0x14(%ebp)
8010523d:	e8 de c3 ff ff       	call   80101620 <fileread>
80105242:	83 c4 10             	add    $0x10,%esp
}
80105245:	c9                   	leave  
80105246:	c3                   	ret    
80105247:	89 f6                	mov    %esi,%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return -1;
80105250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105255:	c9                   	leave  
80105256:	c3                   	ret    
80105257:	89 f6                	mov    %esi,%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105260 <sys_write>:
int sys_write(void) {
80105260:	55                   	push   %ebp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) {
80105261:	31 c0                	xor    %eax,%eax
int sys_write(void) {
80105263:	89 e5                	mov    %esp,%ebp
80105265:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) {
80105268:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010526b:	e8 c0 fe ff ff       	call   80105130 <argfd.constprop.0>
80105270:	85 c0                	test   %eax,%eax
80105272:	78 4c                	js     801052c0 <sys_write+0x60>
80105274:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105277:	83 ec 08             	sub    $0x8,%esp
8010527a:	50                   	push   %eax
8010527b:	6a 02                	push   $0x2
8010527d:	e8 be fb ff ff       	call   80104e40 <argint>
80105282:	83 c4 10             	add    $0x10,%esp
80105285:	85 c0                	test   %eax,%eax
80105287:	78 37                	js     801052c0 <sys_write+0x60>
80105289:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010528c:	83 ec 04             	sub    $0x4,%esp
8010528f:	ff 75 f0             	pushl  -0x10(%ebp)
80105292:	50                   	push   %eax
80105293:	6a 01                	push   $0x1
80105295:	e8 f6 fb ff ff       	call   80104e90 <argptr>
8010529a:	83 c4 10             	add    $0x10,%esp
8010529d:	85 c0                	test   %eax,%eax
8010529f:	78 1f                	js     801052c0 <sys_write+0x60>
    return filewrite(f, p, n);
801052a1:	83 ec 04             	sub    $0x4,%esp
801052a4:	ff 75 f0             	pushl  -0x10(%ebp)
801052a7:	ff 75 f4             	pushl  -0xc(%ebp)
801052aa:	ff 75 ec             	pushl  -0x14(%ebp)
801052ad:	e8 fe c3 ff ff       	call   801016b0 <filewrite>
801052b2:	83 c4 10             	add    $0x10,%esp
}
801052b5:	c9                   	leave  
801052b6:	c3                   	ret    
801052b7:	89 f6                	mov    %esi,%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return -1;
801052c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052c5:	c9                   	leave  
801052c6:	c3                   	ret    
801052c7:	89 f6                	mov    %esi,%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052d0 <sys_close>:
int sys_close(void) {
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, &fd, &f) < 0) {
801052d6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801052d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052dc:	e8 4f fe ff ff       	call   80105130 <argfd.constprop.0>
801052e1:	85 c0                	test   %eax,%eax
801052e3:	78 2b                	js     80105310 <sys_close+0x40>
    myproc()->ofile[fd] = 0;
801052e5:	e8 e6 eb ff ff       	call   80103ed0 <myproc>
801052ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
    fileclose(f);
801052ed:	83 ec 0c             	sub    $0xc,%esp
    myproc()->ofile[fd] = 0;
801052f0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801052f7:	00 
    fileclose(f);
801052f8:	ff 75 f4             	pushl  -0xc(%ebp)
801052fb:	e8 00 c2 ff ff       	call   80101500 <fileclose>
    return 0;
80105300:	83 c4 10             	add    $0x10,%esp
80105303:	31 c0                	xor    %eax,%eax
}
80105305:	c9                   	leave  
80105306:	c3                   	ret    
80105307:	89 f6                	mov    %esi,%esi
80105309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return -1;
80105310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105315:	c9                   	leave  
80105316:	c3                   	ret    
80105317:	89 f6                	mov    %esi,%esi
80105319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105320 <sys_fstat>:
int sys_fstat(void) {
80105320:	55                   	push   %ebp
    if (argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0) {
80105321:	31 c0                	xor    %eax,%eax
int sys_fstat(void) {
80105323:	89 e5                	mov    %esp,%ebp
80105325:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0) {
80105328:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010532b:	e8 00 fe ff ff       	call   80105130 <argfd.constprop.0>
80105330:	85 c0                	test   %eax,%eax
80105332:	78 2c                	js     80105360 <sys_fstat+0x40>
80105334:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105337:	83 ec 04             	sub    $0x4,%esp
8010533a:	6a 14                	push   $0x14
8010533c:	50                   	push   %eax
8010533d:	6a 01                	push   $0x1
8010533f:	e8 4c fb ff ff       	call   80104e90 <argptr>
80105344:	83 c4 10             	add    $0x10,%esp
80105347:	85 c0                	test   %eax,%eax
80105349:	78 15                	js     80105360 <sys_fstat+0x40>
    return filestat(f, st);
8010534b:	83 ec 08             	sub    $0x8,%esp
8010534e:	ff 75 f4             	pushl  -0xc(%ebp)
80105351:	ff 75 f0             	pushl  -0x10(%ebp)
80105354:	e8 77 c2 ff ff       	call   801015d0 <filestat>
80105359:	83 c4 10             	add    $0x10,%esp
}
8010535c:	c9                   	leave  
8010535d:	c3                   	ret    
8010535e:	66 90                	xchg   %ax,%ax
        return -1;
80105360:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105365:	c9                   	leave  
80105366:	c3                   	ret    
80105367:	89 f6                	mov    %esi,%esi
80105369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105370 <cleanupsyslink>:
void cleanupsyslink(struct inode * ip) {
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	53                   	push   %ebx
80105374:	83 ec 10             	sub    $0x10,%esp
80105377:	8b 5d 08             	mov    0x8(%ebp),%ebx
    ilock(ip);
8010537a:	53                   	push   %ebx
8010537b:	e8 c0 c9 ff ff       	call   80101d40 <ilock>
    ip->nlink--;
80105380:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
    iupdate(ip);
80105385:	89 1c 24             	mov    %ebx,(%esp)
80105388:	e8 03 c9 ff ff       	call   80101c90 <iupdate>
    iunlockput(ip);
8010538d:	89 1c 24             	mov    %ebx,(%esp)
80105390:	e8 3b cc ff ff       	call   80101fd0 <iunlockput>
    end_op();
80105395:	83 c4 10             	add    $0x10,%esp
}
80105398:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010539b:	c9                   	leave  
    end_op();
8010539c:	e9 2f df ff ff       	jmp    801032d0 <end_op>
801053a1:	eb 0d                	jmp    801053b0 <sys_link>
801053a3:	90                   	nop
801053a4:	90                   	nop
801053a5:	90                   	nop
801053a6:	90                   	nop
801053a7:	90                   	nop
801053a8:	90                   	nop
801053a9:	90                   	nop
801053aa:	90                   	nop
801053ab:	90                   	nop
801053ac:	90                   	nop
801053ad:	90                   	nop
801053ae:	90                   	nop
801053af:	90                   	nop

801053b0 <sys_link>:
int sys_link(void) {
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	57                   	push   %edi
801053b4:	56                   	push   %esi
801053b5:	53                   	push   %ebx
    if (argstr(0, &old) < 0 || argstr(1, &new) < 0) {
801053b6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
int sys_link(void) {
801053b9:	83 ec 34             	sub    $0x34,%esp
    if (argstr(0, &old) < 0 || argstr(1, &new) < 0) {
801053bc:	50                   	push   %eax
801053bd:	6a 00                	push   $0x0
801053bf:	e8 2c fb ff ff       	call   80104ef0 <argstr>
801053c4:	83 c4 10             	add    $0x10,%esp
801053c7:	85 c0                	test   %eax,%eax
801053c9:	0f 88 f1 00 00 00    	js     801054c0 <sys_link+0x110>
801053cf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801053d2:	83 ec 08             	sub    $0x8,%esp
801053d5:	50                   	push   %eax
801053d6:	6a 01                	push   $0x1
801053d8:	e8 13 fb ff ff       	call   80104ef0 <argstr>
801053dd:	83 c4 10             	add    $0x10,%esp
801053e0:	85 c0                	test   %eax,%eax
801053e2:	0f 88 d8 00 00 00    	js     801054c0 <sys_link+0x110>
    begin_op();
801053e8:	e8 73 de ff ff       	call   80103260 <begin_op>
    if ((ip = namei(old)) == 0) {
801053ed:	83 ec 0c             	sub    $0xc,%esp
801053f0:	ff 75 d4             	pushl  -0x2c(%ebp)
801053f3:	e8 a8 d1 ff ff       	call   801025a0 <namei>
801053f8:	83 c4 10             	add    $0x10,%esp
801053fb:	85 c0                	test   %eax,%eax
801053fd:	89 c3                	mov    %eax,%ebx
801053ff:	0f 84 da 00 00 00    	je     801054df <sys_link+0x12f>
    ilock(ip);
80105405:	83 ec 0c             	sub    $0xc,%esp
80105408:	50                   	push   %eax
80105409:	e8 32 c9 ff ff       	call   80101d40 <ilock>
    if (ip->type == T_DIR) {
8010540e:	83 c4 10             	add    $0x10,%esp
80105411:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105416:	0f 84 ab 00 00 00    	je     801054c7 <sys_link+0x117>
    ip->nlink++;
8010541c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(ip);
80105421:	83 ec 0c             	sub    $0xc,%esp
    if ((dp = nameiparent(new, name)) == 0) {
80105424:	8d 7d da             	lea    -0x26(%ebp),%edi
    iupdate(ip);
80105427:	53                   	push   %ebx
80105428:	e8 63 c8 ff ff       	call   80101c90 <iupdate>
    iunlock(ip);
8010542d:	89 1c 24             	mov    %ebx,(%esp)
80105430:	e8 eb c9 ff ff       	call   80101e20 <iunlock>
    if ((dp = nameiparent(new, name)) == 0) {
80105435:	58                   	pop    %eax
80105436:	5a                   	pop    %edx
80105437:	57                   	push   %edi
80105438:	ff 75 d0             	pushl  -0x30(%ebp)
8010543b:	e8 80 d1 ff ff       	call   801025c0 <nameiparent>
80105440:	83 c4 10             	add    $0x10,%esp
80105443:	85 c0                	test   %eax,%eax
80105445:	89 c6                	mov    %eax,%esi
80105447:	74 6a                	je     801054b3 <sys_link+0x103>
    ilock(dp);
80105449:	83 ec 0c             	sub    $0xc,%esp
8010544c:	50                   	push   %eax
8010544d:	e8 ee c8 ff ff       	call   80101d40 <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
80105452:	83 c4 10             	add    $0x10,%esp
80105455:	8b 03                	mov    (%ebx),%eax
80105457:	39 06                	cmp    %eax,(%esi)
80105459:	75 3d                	jne    80105498 <sys_link+0xe8>
8010545b:	83 ec 04             	sub    $0x4,%esp
8010545e:	ff 73 04             	pushl  0x4(%ebx)
80105461:	57                   	push   %edi
80105462:	56                   	push   %esi
80105463:	e8 78 d0 ff ff       	call   801024e0 <dirlink>
80105468:	83 c4 10             	add    $0x10,%esp
8010546b:	85 c0                	test   %eax,%eax
8010546d:	78 29                	js     80105498 <sys_link+0xe8>
    iunlockput(dp);
8010546f:	83 ec 0c             	sub    $0xc,%esp
80105472:	56                   	push   %esi
80105473:	e8 58 cb ff ff       	call   80101fd0 <iunlockput>
    iput(ip);
80105478:	89 1c 24             	mov    %ebx,(%esp)
8010547b:	e8 f0 c9 ff ff       	call   80101e70 <iput>
    end_op();
80105480:	e8 4b de ff ff       	call   801032d0 <end_op>
    return 0;
80105485:	83 c4 10             	add    $0x10,%esp
80105488:	31 c0                	xor    %eax,%eax
}
8010548a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010548d:	5b                   	pop    %ebx
8010548e:	5e                   	pop    %esi
8010548f:	5f                   	pop    %edi
80105490:	5d                   	pop    %ebp
80105491:	c3                   	ret    
80105492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        iunlockput(dp);
80105498:	83 ec 0c             	sub    $0xc,%esp
8010549b:	56                   	push   %esi
8010549c:	e8 2f cb ff ff       	call   80101fd0 <iunlockput>
        cleanupsyslink(ip);
801054a1:	89 1c 24             	mov    %ebx,(%esp)
801054a4:	e8 c7 fe ff ff       	call   80105370 <cleanupsyslink>
        return -1;
801054a9:	83 c4 10             	add    $0x10,%esp
801054ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054b1:	eb d7                	jmp    8010548a <sys_link+0xda>
        cleanupsyslink(ip);
801054b3:	83 ec 0c             	sub    $0xc,%esp
801054b6:	53                   	push   %ebx
801054b7:	e8 b4 fe ff ff       	call   80105370 <cleanupsyslink>
        return -1;
801054bc:	83 c4 10             	add    $0x10,%esp
801054bf:	90                   	nop
801054c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054c5:	eb c3                	jmp    8010548a <sys_link+0xda>
        iunlockput(ip);
801054c7:	83 ec 0c             	sub    $0xc,%esp
801054ca:	53                   	push   %ebx
801054cb:	e8 00 cb ff ff       	call   80101fd0 <iunlockput>
        end_op();
801054d0:	e8 fb dd ff ff       	call   801032d0 <end_op>
        return -1;
801054d5:	83 c4 10             	add    $0x10,%esp
801054d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054dd:	eb ab                	jmp    8010548a <sys_link+0xda>
        end_op();
801054df:	e8 ec dd ff ff       	call   801032d0 <end_op>
        return -1;
801054e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054e9:	eb 9f                	jmp    8010548a <sys_link+0xda>
801054eb:	90                   	nop
801054ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054f0 <sys_unlink>:
int sys_unlink(void) {
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	57                   	push   %edi
801054f4:	56                   	push   %esi
801054f5:	53                   	push   %ebx
    if (argstr(0, &path) < 0) {
801054f6:	8d 45 c0             	lea    -0x40(%ebp),%eax
int sys_unlink(void) {
801054f9:	83 ec 44             	sub    $0x44,%esp
    if (argstr(0, &path) < 0) {
801054fc:	50                   	push   %eax
801054fd:	6a 00                	push   $0x0
801054ff:	e8 ec f9 ff ff       	call   80104ef0 <argstr>
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	85 c0                	test   %eax,%eax
80105509:	0f 88 52 01 00 00    	js     80105661 <sys_unlink+0x171>
    if ((dp = nameiparent(path, name)) == 0) {
8010550f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
    begin_op();
80105512:	e8 49 dd ff ff       	call   80103260 <begin_op>
    if ((dp = nameiparent(path, name)) == 0) {
80105517:	83 ec 08             	sub    $0x8,%esp
8010551a:	53                   	push   %ebx
8010551b:	ff 75 c0             	pushl  -0x40(%ebp)
8010551e:	e8 9d d0 ff ff       	call   801025c0 <nameiparent>
80105523:	83 c4 10             	add    $0x10,%esp
80105526:	85 c0                	test   %eax,%eax
80105528:	89 c6                	mov    %eax,%esi
8010552a:	0f 84 7b 01 00 00    	je     801056ab <sys_unlink+0x1bb>
    ilock(dp);
80105530:	83 ec 0c             	sub    $0xc,%esp
80105533:	50                   	push   %eax
80105534:	e8 07 c8 ff ff       	call   80101d40 <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) {
80105539:	58                   	pop    %eax
8010553a:	5a                   	pop    %edx
8010553b:	68 48 7e 10 80       	push   $0x80107e48
80105540:	53                   	push   %ebx
80105541:	e8 0a cd ff ff       	call   80102250 <namecmp>
80105546:	83 c4 10             	add    $0x10,%esp
80105549:	85 c0                	test   %eax,%eax
8010554b:	0f 84 3f 01 00 00    	je     80105690 <sys_unlink+0x1a0>
80105551:	83 ec 08             	sub    $0x8,%esp
80105554:	68 47 7e 10 80       	push   $0x80107e47
80105559:	53                   	push   %ebx
8010555a:	e8 f1 cc ff ff       	call   80102250 <namecmp>
8010555f:	83 c4 10             	add    $0x10,%esp
80105562:	85 c0                	test   %eax,%eax
80105564:	0f 84 26 01 00 00    	je     80105690 <sys_unlink+0x1a0>
    if ((ip = dirlookup(dp, name, &off)) == 0) {
8010556a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010556d:	83 ec 04             	sub    $0x4,%esp
80105570:	50                   	push   %eax
80105571:	53                   	push   %ebx
80105572:	56                   	push   %esi
80105573:	e8 f8 cc ff ff       	call   80102270 <dirlookup>
80105578:	83 c4 10             	add    $0x10,%esp
8010557b:	85 c0                	test   %eax,%eax
8010557d:	89 c3                	mov    %eax,%ebx
8010557f:	0f 84 0b 01 00 00    	je     80105690 <sys_unlink+0x1a0>
    ilock(ip);
80105585:	83 ec 0c             	sub    $0xc,%esp
80105588:	50                   	push   %eax
80105589:	e8 b2 c7 ff ff       	call   80101d40 <ilock>
    if (ip->nlink < 1) {
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105596:	0f 8e 2b 01 00 00    	jle    801056c7 <sys_unlink+0x1d7>
    if (ip->type == T_DIR && !isdirempty(ip)) {
8010559c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055a1:	74 6d                	je     80105610 <sys_unlink+0x120>
    memset(&de, 0, sizeof(de));
801055a3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801055a6:	83 ec 04             	sub    $0x4,%esp
801055a9:	6a 10                	push   $0x10
801055ab:	6a 00                	push   $0x0
801055ad:	50                   	push   %eax
801055ae:	e8 8d f5 ff ff       	call   80104b40 <memset>
    if (writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
801055b3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801055b6:	6a 10                	push   $0x10
801055b8:	ff 75 c4             	pushl  -0x3c(%ebp)
801055bb:	50                   	push   %eax
801055bc:	56                   	push   %esi
801055bd:	e8 5e cb ff ff       	call   80102120 <writei>
801055c2:	83 c4 20             	add    $0x20,%esp
801055c5:	83 f8 10             	cmp    $0x10,%eax
801055c8:	0f 85 06 01 00 00    	jne    801056d4 <sys_unlink+0x1e4>
    if (ip->type == T_DIR) {
801055ce:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055d3:	0f 84 97 00 00 00    	je     80105670 <sys_unlink+0x180>
    iunlockput(dp);
801055d9:	83 ec 0c             	sub    $0xc,%esp
801055dc:	56                   	push   %esi
801055dd:	e8 ee c9 ff ff       	call   80101fd0 <iunlockput>
    ip->nlink--;
801055e2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
    iupdate(ip);
801055e7:	89 1c 24             	mov    %ebx,(%esp)
801055ea:	e8 a1 c6 ff ff       	call   80101c90 <iupdate>
    iunlockput(ip);
801055ef:	89 1c 24             	mov    %ebx,(%esp)
801055f2:	e8 d9 c9 ff ff       	call   80101fd0 <iunlockput>
    end_op();
801055f7:	e8 d4 dc ff ff       	call   801032d0 <end_op>
    return 0;
801055fc:	83 c4 10             	add    $0x10,%esp
801055ff:	31 c0                	xor    %eax,%eax
}
80105601:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105604:	5b                   	pop    %ebx
80105605:	5e                   	pop    %esi
80105606:	5f                   	pop    %edi
80105607:	5d                   	pop    %ebp
80105608:	c3                   	ret    
80105609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
80105610:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105614:	76 8d                	jbe    801055a3 <sys_unlink+0xb3>
80105616:	bf 20 00 00 00       	mov    $0x20,%edi
8010561b:	eb 0f                	jmp    8010562c <sys_unlink+0x13c>
8010561d:	8d 76 00             	lea    0x0(%esi),%esi
80105620:	83 c7 10             	add    $0x10,%edi
80105623:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105626:	0f 83 77 ff ff ff    	jae    801055a3 <sys_unlink+0xb3>
        if (readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
8010562c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010562f:	6a 10                	push   $0x10
80105631:	57                   	push   %edi
80105632:	50                   	push   %eax
80105633:	53                   	push   %ebx
80105634:	e8 e7 c9 ff ff       	call   80102020 <readi>
80105639:	83 c4 10             	add    $0x10,%esp
8010563c:	83 f8 10             	cmp    $0x10,%eax
8010563f:	75 79                	jne    801056ba <sys_unlink+0x1ca>
        if (de.inum != 0) {
80105641:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105646:	74 d8                	je     80105620 <sys_unlink+0x130>
        iunlockput(ip);
80105648:	83 ec 0c             	sub    $0xc,%esp
8010564b:	53                   	push   %ebx
8010564c:	e8 7f c9 ff ff       	call   80101fd0 <iunlockput>
        iunlockput(dp);
80105651:	89 34 24             	mov    %esi,(%esp)
80105654:	e8 77 c9 ff ff       	call   80101fd0 <iunlockput>
        end_op();
80105659:	e8 72 dc ff ff       	call   801032d0 <end_op>
        return -1;       
8010565e:	83 c4 10             	add    $0x10,%esp
}
80105661:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;       
80105664:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105669:	5b                   	pop    %ebx
8010566a:	5e                   	pop    %esi
8010566b:	5f                   	pop    %edi
8010566c:	5d                   	pop    %ebp
8010566d:	c3                   	ret    
8010566e:	66 90                	xchg   %ax,%ax
        dp->nlink--;
80105670:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
        iupdate(dp);
80105675:	83 ec 0c             	sub    $0xc,%esp
80105678:	56                   	push   %esi
80105679:	e8 12 c6 ff ff       	call   80101c90 <iupdate>
8010567e:	83 c4 10             	add    $0x10,%esp
80105681:	e9 53 ff ff ff       	jmp    801055d9 <sys_unlink+0xe9>
80105686:	8d 76 00             	lea    0x0(%esi),%esi
80105689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        iunlockput(dp);
80105690:	83 ec 0c             	sub    $0xc,%esp
80105693:	56                   	push   %esi
80105694:	e8 37 c9 ff ff       	call   80101fd0 <iunlockput>
        end_op();
80105699:	e8 32 dc ff ff       	call   801032d0 <end_op>
        return -1;       
8010569e:	83 c4 10             	add    $0x10,%esp
801056a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a6:	e9 56 ff ff ff       	jmp    80105601 <sys_unlink+0x111>
        end_op();
801056ab:	e8 20 dc ff ff       	call   801032d0 <end_op>
        return -1;
801056b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056b5:	e9 47 ff ff ff       	jmp    80105601 <sys_unlink+0x111>
            panic("isdirempty: readi");
801056ba:	83 ec 0c             	sub    $0xc,%esp
801056bd:	68 6c 7e 10 80       	push   $0x80107e6c
801056c2:	e8 b9 ad ff ff       	call   80100480 <panic>
        panic("unlink: nlink < 1");
801056c7:	83 ec 0c             	sub    $0xc,%esp
801056ca:	68 5a 7e 10 80       	push   $0x80107e5a
801056cf:	e8 ac ad ff ff       	call   80100480 <panic>
        panic("unlink: writei");
801056d4:	83 ec 0c             	sub    $0xc,%esp
801056d7:	68 7e 7e 10 80       	push   $0x80107e7e
801056dc:	e8 9f ad ff ff       	call   80100480 <panic>
801056e1:	eb 0d                	jmp    801056f0 <sys_open>
801056e3:	90                   	nop
801056e4:	90                   	nop
801056e5:	90                   	nop
801056e6:	90                   	nop
801056e7:	90                   	nop
801056e8:	90                   	nop
801056e9:	90                   	nop
801056ea:	90                   	nop
801056eb:	90                   	nop
801056ec:	90                   	nop
801056ed:	90                   	nop
801056ee:	90                   	nop
801056ef:	90                   	nop

801056f0 <sys_open>:

int sys_open(void) {
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	57                   	push   %edi
801056f4:	56                   	push   %esi
801056f5:	53                   	push   %ebx
    char *path;
    int fd, omode;
    struct file *f;
    struct inode *ip;

    if (argstr(0, &path) < 0 || argint(1, &omode) < 0) {
801056f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
int sys_open(void) {
801056f9:	83 ec 24             	sub    $0x24,%esp
    if (argstr(0, &path) < 0 || argint(1, &omode) < 0) {
801056fc:	50                   	push   %eax
801056fd:	6a 00                	push   $0x0
801056ff:	e8 ec f7 ff ff       	call   80104ef0 <argstr>
80105704:	83 c4 10             	add    $0x10,%esp
80105707:	85 c0                	test   %eax,%eax
80105709:	0f 88 1d 01 00 00    	js     8010582c <sys_open+0x13c>
8010570f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105712:	83 ec 08             	sub    $0x8,%esp
80105715:	50                   	push   %eax
80105716:	6a 01                	push   $0x1
80105718:	e8 23 f7 ff ff       	call   80104e40 <argint>
8010571d:	83 c4 10             	add    $0x10,%esp
80105720:	85 c0                	test   %eax,%eax
80105722:	0f 88 04 01 00 00    	js     8010582c <sys_open+0x13c>
        return -1;
    }

    begin_op();
80105728:	e8 33 db ff ff       	call   80103260 <begin_op>

    if (omode & O_CREATE) {
8010572d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105731:	0f 85 a9 00 00 00    	jne    801057e0 <sys_open+0xf0>
            end_op();
            return -1;
        }
    }
    else {
        if ((ip = namei(path)) == 0) {
80105737:	83 ec 0c             	sub    $0xc,%esp
8010573a:	ff 75 e0             	pushl  -0x20(%ebp)
8010573d:	e8 5e ce ff ff       	call   801025a0 <namei>
80105742:	83 c4 10             	add    $0x10,%esp
80105745:	85 c0                	test   %eax,%eax
80105747:	89 c6                	mov    %eax,%esi
80105749:	0f 84 b2 00 00 00    	je     80105801 <sys_open+0x111>
            end_op();
            return -1;
        }
        ilock(ip);
8010574f:	83 ec 0c             	sub    $0xc,%esp
80105752:	50                   	push   %eax
80105753:	e8 e8 c5 ff ff       	call   80101d40 <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY) {
80105758:	83 c4 10             	add    $0x10,%esp
8010575b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105760:	0f 84 aa 00 00 00    	je     80105810 <sys_open+0x120>
            end_op();
            return -1;
        }
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
80105766:	e8 d5 bc ff ff       	call   80101440 <filealloc>
8010576b:	85 c0                	test   %eax,%eax
8010576d:	89 c7                	mov    %eax,%edi
8010576f:	0f 84 a6 00 00 00    	je     8010581b <sys_open+0x12b>
    struct proc *curproc = myproc();
80105775:	e8 56 e7 ff ff       	call   80103ed0 <myproc>
    for (fd = 0; fd < NOFILE; fd++) {
8010577a:	31 db                	xor    %ebx,%ebx
8010577c:	eb 0e                	jmp    8010578c <sys_open+0x9c>
8010577e:	66 90                	xchg   %ax,%ax
80105780:	83 c3 01             	add    $0x1,%ebx
80105783:	83 fb 10             	cmp    $0x10,%ebx
80105786:	0f 84 ac 00 00 00    	je     80105838 <sys_open+0x148>
        if (curproc->ofile[fd] == 0) {
8010578c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105790:	85 d2                	test   %edx,%edx
80105792:	75 ec                	jne    80105780 <sys_open+0x90>
        }
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
80105794:	83 ec 0c             	sub    $0xc,%esp
            curproc->ofile[fd] = f;
80105797:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
    iunlock(ip);
8010579b:	56                   	push   %esi
8010579c:	e8 7f c6 ff ff       	call   80101e20 <iunlock>
    end_op();
801057a1:	e8 2a db ff ff       	call   801032d0 <end_op>

    f->type = FD_INODE;
801057a6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
    f->ip = ip;
    f->off = 0;
    f->readable = !(omode & O_WRONLY);
801057ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057af:	83 c4 10             	add    $0x10,%esp
    f->ip = ip;
801057b2:	89 77 10             	mov    %esi,0x10(%edi)
    f->off = 0;
801057b5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
    f->readable = !(omode & O_WRONLY);
801057bc:	89 d0                	mov    %edx,%eax
801057be:	f7 d0                	not    %eax
801057c0:	83 e0 01             	and    $0x1,%eax
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057c3:	83 e2 03             	and    $0x3,%edx
    f->readable = !(omode & O_WRONLY);
801057c6:	88 47 08             	mov    %al,0x8(%edi)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057c9:	0f 95 47 09          	setne  0x9(%edi)
    return fd;
}
801057cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057d0:	89 d8                	mov    %ebx,%eax
801057d2:	5b                   	pop    %ebx
801057d3:	5e                   	pop    %esi
801057d4:	5f                   	pop    %edi
801057d5:	5d                   	pop    %ebp
801057d6:	c3                   	ret    
801057d7:	89 f6                	mov    %esi,%esi
801057d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        ip = create(path, T_FILE, 0, 0);
801057e0:	83 ec 0c             	sub    $0xc,%esp
801057e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057e6:	31 c9                	xor    %ecx,%ecx
801057e8:	6a 00                	push   $0x0
801057ea:	ba 02 00 00 00       	mov    $0x2,%edx
801057ef:	e8 9c f7 ff ff       	call   80104f90 <create>
        if (ip == 0) {
801057f4:	83 c4 10             	add    $0x10,%esp
801057f7:	85 c0                	test   %eax,%eax
        ip = create(path, T_FILE, 0, 0);
801057f9:	89 c6                	mov    %eax,%esi
        if (ip == 0) {
801057fb:	0f 85 65 ff ff ff    	jne    80105766 <sys_open+0x76>
            end_op();
80105801:	e8 ca da ff ff       	call   801032d0 <end_op>
            return -1;
80105806:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010580b:	eb c0                	jmp    801057cd <sys_open+0xdd>
8010580d:	8d 76 00             	lea    0x0(%esi),%esi
        if (ip->type == T_DIR && omode != O_RDONLY) {
80105810:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105813:	85 c9                	test   %ecx,%ecx
80105815:	0f 84 4b ff ff ff    	je     80105766 <sys_open+0x76>
        iunlockput(ip);
8010581b:	83 ec 0c             	sub    $0xc,%esp
8010581e:	56                   	push   %esi
8010581f:	e8 ac c7 ff ff       	call   80101fd0 <iunlockput>
        end_op();
80105824:	e8 a7 da ff ff       	call   801032d0 <end_op>
        return -1;
80105829:	83 c4 10             	add    $0x10,%esp
8010582c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105831:	eb 9a                	jmp    801057cd <sys_open+0xdd>
80105833:	90                   	nop
80105834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            fileclose(f);
80105838:	83 ec 0c             	sub    $0xc,%esp
8010583b:	57                   	push   %edi
8010583c:	e8 bf bc ff ff       	call   80101500 <fileclose>
80105841:	83 c4 10             	add    $0x10,%esp
80105844:	eb d5                	jmp    8010581b <sys_open+0x12b>
80105846:	8d 76 00             	lea    0x0(%esi),%esi
80105849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105850 <sys_mkdir>:

int sys_mkdir(void) {
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	83 ec 18             	sub    $0x18,%esp
    char *path;
    struct inode *ip;

    begin_op();
80105856:	e8 05 da ff ff       	call   80103260 <begin_op>
    if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
8010585b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010585e:	83 ec 08             	sub    $0x8,%esp
80105861:	50                   	push   %eax
80105862:	6a 00                	push   $0x0
80105864:	e8 87 f6 ff ff       	call   80104ef0 <argstr>
80105869:	83 c4 10             	add    $0x10,%esp
8010586c:	85 c0                	test   %eax,%eax
8010586e:	78 30                	js     801058a0 <sys_mkdir+0x50>
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105876:	31 c9                	xor    %ecx,%ecx
80105878:	6a 00                	push   $0x0
8010587a:	ba 01 00 00 00       	mov    $0x1,%edx
8010587f:	e8 0c f7 ff ff       	call   80104f90 <create>
80105884:	83 c4 10             	add    $0x10,%esp
80105887:	85 c0                	test   %eax,%eax
80105889:	74 15                	je     801058a0 <sys_mkdir+0x50>
        end_op();
        return -1;
    }
    iunlockput(ip);
8010588b:	83 ec 0c             	sub    $0xc,%esp
8010588e:	50                   	push   %eax
8010588f:	e8 3c c7 ff ff       	call   80101fd0 <iunlockput>
    end_op();
80105894:	e8 37 da ff ff       	call   801032d0 <end_op>
    return 0;
80105899:	83 c4 10             	add    $0x10,%esp
8010589c:	31 c0                	xor    %eax,%eax
}
8010589e:	c9                   	leave  
8010589f:	c3                   	ret    
        end_op();
801058a0:	e8 2b da ff ff       	call   801032d0 <end_op>
        return -1;
801058a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058aa:	c9                   	leave  
801058ab:	c3                   	ret    
801058ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058b0 <sys_mknod>:

int sys_mknod(void) {
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	83 ec 18             	sub    $0x18,%esp
    struct inode *ip;
    char *path;
    int major, minor;

    begin_op();
801058b6:	e8 a5 d9 ff ff       	call   80103260 <begin_op>
    if ((argstr(0, &path)) < 0 ||
801058bb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058be:	83 ec 08             	sub    $0x8,%esp
801058c1:	50                   	push   %eax
801058c2:	6a 00                	push   $0x0
801058c4:	e8 27 f6 ff ff       	call   80104ef0 <argstr>
801058c9:	83 c4 10             	add    $0x10,%esp
801058cc:	85 c0                	test   %eax,%eax
801058ce:	78 60                	js     80105930 <sys_mknod+0x80>
        argint(1, &major) < 0 ||
801058d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058d3:	83 ec 08             	sub    $0x8,%esp
801058d6:	50                   	push   %eax
801058d7:	6a 01                	push   $0x1
801058d9:	e8 62 f5 ff ff       	call   80104e40 <argint>
    if ((argstr(0, &path)) < 0 ||
801058de:	83 c4 10             	add    $0x10,%esp
801058e1:	85 c0                	test   %eax,%eax
801058e3:	78 4b                	js     80105930 <sys_mknod+0x80>
        argint(2, &minor) < 0 ||
801058e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058e8:	83 ec 08             	sub    $0x8,%esp
801058eb:	50                   	push   %eax
801058ec:	6a 02                	push   $0x2
801058ee:	e8 4d f5 ff ff       	call   80104e40 <argint>
        argint(1, &major) < 0 ||
801058f3:	83 c4 10             	add    $0x10,%esp
801058f6:	85 c0                	test   %eax,%eax
801058f8:	78 36                	js     80105930 <sys_mknod+0x80>
        (ip = create(path, T_DEV, major, minor)) == 0) {
801058fa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
        argint(2, &minor) < 0 ||
801058fe:	83 ec 0c             	sub    $0xc,%esp
        (ip = create(path, T_DEV, major, minor)) == 0) {
80105901:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
        argint(2, &minor) < 0 ||
80105905:	ba 03 00 00 00       	mov    $0x3,%edx
8010590a:	50                   	push   %eax
8010590b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010590e:	e8 7d f6 ff ff       	call   80104f90 <create>
80105913:	83 c4 10             	add    $0x10,%esp
80105916:	85 c0                	test   %eax,%eax
80105918:	74 16                	je     80105930 <sys_mknod+0x80>
        end_op();
        return -1;
    }
    iunlockput(ip);
8010591a:	83 ec 0c             	sub    $0xc,%esp
8010591d:	50                   	push   %eax
8010591e:	e8 ad c6 ff ff       	call   80101fd0 <iunlockput>
    end_op();
80105923:	e8 a8 d9 ff ff       	call   801032d0 <end_op>
    return 0;
80105928:	83 c4 10             	add    $0x10,%esp
8010592b:	31 c0                	xor    %eax,%eax
}
8010592d:	c9                   	leave  
8010592e:	c3                   	ret    
8010592f:	90                   	nop
        end_op();
80105930:	e8 9b d9 ff ff       	call   801032d0 <end_op>
        return -1;
80105935:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010593a:	c9                   	leave  
8010593b:	c3                   	ret    
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <sys_chdir>:

int sys_chdir(void) {
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	56                   	push   %esi
80105944:	53                   	push   %ebx
80105945:	83 ec 10             	sub    $0x10,%esp
    char *path;
    struct inode *ip;
    struct proc *curproc = myproc();
80105948:	e8 83 e5 ff ff       	call   80103ed0 <myproc>
8010594d:	89 c6                	mov    %eax,%esi

    begin_op();
8010594f:	e8 0c d9 ff ff       	call   80103260 <begin_op>
    if (argstr(0, &path) < 0 || (ip = namei(path)) == 0) {
80105954:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105957:	83 ec 08             	sub    $0x8,%esp
8010595a:	50                   	push   %eax
8010595b:	6a 00                	push   $0x0
8010595d:	e8 8e f5 ff ff       	call   80104ef0 <argstr>
80105962:	83 c4 10             	add    $0x10,%esp
80105965:	85 c0                	test   %eax,%eax
80105967:	78 77                	js     801059e0 <sys_chdir+0xa0>
80105969:	83 ec 0c             	sub    $0xc,%esp
8010596c:	ff 75 f4             	pushl  -0xc(%ebp)
8010596f:	e8 2c cc ff ff       	call   801025a0 <namei>
80105974:	83 c4 10             	add    $0x10,%esp
80105977:	85 c0                	test   %eax,%eax
80105979:	89 c3                	mov    %eax,%ebx
8010597b:	74 63                	je     801059e0 <sys_chdir+0xa0>
        end_op();
        return -1;
    }
    ilock(ip);
8010597d:	83 ec 0c             	sub    $0xc,%esp
80105980:	50                   	push   %eax
80105981:	e8 ba c3 ff ff       	call   80101d40 <ilock>
    if (ip->type != T_DIR) {
80105986:	83 c4 10             	add    $0x10,%esp
80105989:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010598e:	75 30                	jne    801059c0 <sys_chdir+0x80>
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
80105990:	83 ec 0c             	sub    $0xc,%esp
80105993:	53                   	push   %ebx
80105994:	e8 87 c4 ff ff       	call   80101e20 <iunlock>
    iput(curproc->cwd);
80105999:	58                   	pop    %eax
8010599a:	ff 76 68             	pushl  0x68(%esi)
8010599d:	e8 ce c4 ff ff       	call   80101e70 <iput>
    end_op();
801059a2:	e8 29 d9 ff ff       	call   801032d0 <end_op>
    curproc->cwd = ip;
801059a7:	89 5e 68             	mov    %ebx,0x68(%esi)
    return 0;
801059aa:	83 c4 10             	add    $0x10,%esp
801059ad:	31 c0                	xor    %eax,%eax
}
801059af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059b2:	5b                   	pop    %ebx
801059b3:	5e                   	pop    %esi
801059b4:	5d                   	pop    %ebp
801059b5:	c3                   	ret    
801059b6:	8d 76 00             	lea    0x0(%esi),%esi
801059b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        iunlockput(ip);
801059c0:	83 ec 0c             	sub    $0xc,%esp
801059c3:	53                   	push   %ebx
801059c4:	e8 07 c6 ff ff       	call   80101fd0 <iunlockput>
        end_op();
801059c9:	e8 02 d9 ff ff       	call   801032d0 <end_op>
        return -1;
801059ce:	83 c4 10             	add    $0x10,%esp
801059d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059d6:	eb d7                	jmp    801059af <sys_chdir+0x6f>
801059d8:	90                   	nop
801059d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        end_op();
801059e0:	e8 eb d8 ff ff       	call   801032d0 <end_op>
        return -1;
801059e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ea:	eb c3                	jmp    801059af <sys_chdir+0x6f>
801059ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059f0 <sys_exec>:

int sys_exec(void) {
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	57                   	push   %edi
801059f4:	56                   	push   %esi
801059f5:	53                   	push   %ebx
    char *path, *argv[MAXARG];
    int i;
    uint uargv, uarg;

    if (argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
801059f6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
int sys_exec(void) {
801059fc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
    if (argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
80105a02:	50                   	push   %eax
80105a03:	6a 00                	push   $0x0
80105a05:	e8 e6 f4 ff ff       	call   80104ef0 <argstr>
80105a0a:	83 c4 10             	add    $0x10,%esp
80105a0d:	85 c0                	test   %eax,%eax
80105a0f:	0f 88 87 00 00 00    	js     80105a9c <sys_exec+0xac>
80105a15:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a1b:	83 ec 08             	sub    $0x8,%esp
80105a1e:	50                   	push   %eax
80105a1f:	6a 01                	push   $0x1
80105a21:	e8 1a f4 ff ff       	call   80104e40 <argint>
80105a26:	83 c4 10             	add    $0x10,%esp
80105a29:	85 c0                	test   %eax,%eax
80105a2b:	78 6f                	js     80105a9c <sys_exec+0xac>
        return -1;
    }
    memset(argv, 0, sizeof(argv));
80105a2d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a33:	83 ec 04             	sub    $0x4,%esp
    for (i = 0;; i++) {
80105a36:	31 db                	xor    %ebx,%ebx
    memset(argv, 0, sizeof(argv));
80105a38:	68 80 00 00 00       	push   $0x80
80105a3d:	6a 00                	push   $0x0
80105a3f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105a45:	50                   	push   %eax
80105a46:	e8 f5 f0 ff ff       	call   80104b40 <memset>
80105a4b:	83 c4 10             	add    $0x10,%esp
80105a4e:	eb 2c                	jmp    80105a7c <sys_exec+0x8c>
            return -1;
        }
        if (fetchint(uargv + 4 * i, (int*)&uarg) < 0) {
            return -1;
        }
        if (uarg == 0) {
80105a50:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a56:	85 c0                	test   %eax,%eax
80105a58:	74 56                	je     80105ab0 <sys_exec+0xc0>
            argv[i] = 0;
            break;
        }
        if (fetchstr(uarg, &argv[i]) < 0) {
80105a5a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105a60:	83 ec 08             	sub    $0x8,%esp
80105a63:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105a66:	52                   	push   %edx
80105a67:	50                   	push   %eax
80105a68:	e8 63 f3 ff ff       	call   80104dd0 <fetchstr>
80105a6d:	83 c4 10             	add    $0x10,%esp
80105a70:	85 c0                	test   %eax,%eax
80105a72:	78 28                	js     80105a9c <sys_exec+0xac>
    for (i = 0;; i++) {
80105a74:	83 c3 01             	add    $0x1,%ebx
        if (i >= NELEM(argv)) {
80105a77:	83 fb 20             	cmp    $0x20,%ebx
80105a7a:	74 20                	je     80105a9c <sys_exec+0xac>
        if (fetchint(uargv + 4 * i, (int*)&uarg) < 0) {
80105a7c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a82:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105a89:	83 ec 08             	sub    $0x8,%esp
80105a8c:	57                   	push   %edi
80105a8d:	01 f0                	add    %esi,%eax
80105a8f:	50                   	push   %eax
80105a90:	e8 fb f2 ff ff       	call   80104d90 <fetchint>
80105a95:	83 c4 10             	add    $0x10,%esp
80105a98:	85 c0                	test   %eax,%eax
80105a9a:	79 b4                	jns    80105a50 <sys_exec+0x60>
            return -1;
        }
    }
    return exec(path, argv);
}
80105a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80105a9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aa4:	5b                   	pop    %ebx
80105aa5:	5e                   	pop    %esi
80105aa6:	5f                   	pop    %edi
80105aa7:	5d                   	pop    %ebp
80105aa8:	c3                   	ret    
80105aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return exec(path, argv);
80105ab0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ab6:	83 ec 08             	sub    $0x8,%esp
            argv[i] = 0;
80105ab9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ac0:	00 00 00 00 
    return exec(path, argv);
80105ac4:	50                   	push   %eax
80105ac5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105acb:	e8 d0 b5 ff ff       	call   801010a0 <exec>
80105ad0:	83 c4 10             	add    $0x10,%esp
}
80105ad3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ad6:	5b                   	pop    %ebx
80105ad7:	5e                   	pop    %esi
80105ad8:	5f                   	pop    %edi
80105ad9:	5d                   	pop    %ebp
80105ada:	c3                   	ret    
80105adb:	90                   	nop
80105adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ae0 <sys_pipe>:

int sys_pipe(void) {
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	57                   	push   %edi
80105ae4:	56                   	push   %esi
80105ae5:	53                   	push   %ebx
    int *fd;
    struct file *rf, *wf;
    int fd0, fd1;

    if (argptr(0, (void*)&fd, 2 * sizeof(fd[0])) < 0) {
80105ae6:	8d 45 dc             	lea    -0x24(%ebp),%eax
int sys_pipe(void) {
80105ae9:	83 ec 20             	sub    $0x20,%esp
    if (argptr(0, (void*)&fd, 2 * sizeof(fd[0])) < 0) {
80105aec:	6a 08                	push   $0x8
80105aee:	50                   	push   %eax
80105aef:	6a 00                	push   $0x0
80105af1:	e8 9a f3 ff ff       	call   80104e90 <argptr>
80105af6:	83 c4 10             	add    $0x10,%esp
80105af9:	85 c0                	test   %eax,%eax
80105afb:	0f 88 ae 00 00 00    	js     80105baf <sys_pipe+0xcf>
        return -1;
    }
    if (pipealloc(&rf, &wf) < 0) {
80105b01:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b04:	83 ec 08             	sub    $0x8,%esp
80105b07:	50                   	push   %eax
80105b08:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b0b:	50                   	push   %eax
80105b0c:	e8 3f de ff ff       	call   80103950 <pipealloc>
80105b11:	83 c4 10             	add    $0x10,%esp
80105b14:	85 c0                	test   %eax,%eax
80105b16:	0f 88 93 00 00 00    	js     80105baf <sys_pipe+0xcf>
        return -1;
    }
    fd0 = -1;
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
80105b1c:	8b 7d e0             	mov    -0x20(%ebp),%edi
    for (fd = 0; fd < NOFILE; fd++) {
80105b1f:	31 db                	xor    %ebx,%ebx
    struct proc *curproc = myproc();
80105b21:	e8 aa e3 ff ff       	call   80103ed0 <myproc>
80105b26:	eb 10                	jmp    80105b38 <sys_pipe+0x58>
80105b28:	90                   	nop
80105b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (fd = 0; fd < NOFILE; fd++) {
80105b30:	83 c3 01             	add    $0x1,%ebx
80105b33:	83 fb 10             	cmp    $0x10,%ebx
80105b36:	74 60                	je     80105b98 <sys_pipe+0xb8>
        if (curproc->ofile[fd] == 0) {
80105b38:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b3c:	85 f6                	test   %esi,%esi
80105b3e:	75 f0                	jne    80105b30 <sys_pipe+0x50>
            curproc->ofile[fd] = f;
80105b40:	8d 73 08             	lea    0x8(%ebx),%esi
80105b43:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
80105b47:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    struct proc *curproc = myproc();
80105b4a:	e8 81 e3 ff ff       	call   80103ed0 <myproc>
    for (fd = 0; fd < NOFILE; fd++) {
80105b4f:	31 d2                	xor    %edx,%edx
80105b51:	eb 0d                	jmp    80105b60 <sys_pipe+0x80>
80105b53:	90                   	nop
80105b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b58:	83 c2 01             	add    $0x1,%edx
80105b5b:	83 fa 10             	cmp    $0x10,%edx
80105b5e:	74 28                	je     80105b88 <sys_pipe+0xa8>
        if (curproc->ofile[fd] == 0) {
80105b60:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105b64:	85 c9                	test   %ecx,%ecx
80105b66:	75 f0                	jne    80105b58 <sys_pipe+0x78>
            curproc->ofile[fd] = f;
80105b68:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
        }
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    fd[0] = fd0;
80105b6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b6f:	89 18                	mov    %ebx,(%eax)
    fd[1] = fd1;
80105b71:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b74:	89 50 04             	mov    %edx,0x4(%eax)
    return 0;
80105b77:	31 c0                	xor    %eax,%eax
}
80105b79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b7c:	5b                   	pop    %ebx
80105b7d:	5e                   	pop    %esi
80105b7e:	5f                   	pop    %edi
80105b7f:	5d                   	pop    %ebp
80105b80:	c3                   	ret    
80105b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            myproc()->ofile[fd0] = 0;
80105b88:	e8 43 e3 ff ff       	call   80103ed0 <myproc>
80105b8d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105b94:	00 
80105b95:	8d 76 00             	lea    0x0(%esi),%esi
        fileclose(rf);
80105b98:	83 ec 0c             	sub    $0xc,%esp
80105b9b:	ff 75 e0             	pushl  -0x20(%ebp)
80105b9e:	e8 5d b9 ff ff       	call   80101500 <fileclose>
        fileclose(wf);
80105ba3:	58                   	pop    %eax
80105ba4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ba7:	e8 54 b9 ff ff       	call   80101500 <fileclose>
        return -1;
80105bac:	83 c4 10             	add    $0x10,%esp
80105baf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bb4:	eb c3                	jmp    80105b79 <sys_pipe+0x99>
80105bb6:	66 90                	xchg   %ax,%ax
80105bb8:	66 90                	xchg   %ax,%ax
80105bba:	66 90                	xchg   %ax,%ax
80105bbc:	66 90                	xchg   %ax,%ax
80105bbe:	66 90                	xchg   %ax,%ax

80105bc0 <sys_fork>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void) {
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
    return fork();
}
80105bc3:	5d                   	pop    %ebp
    return fork();
80105bc4:	e9 a7 e4 ff ff       	jmp    80104070 <fork>
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bd0 <sys_exit>:

int sys_exit(void) {
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	83 ec 08             	sub    $0x8,%esp
    exit();
80105bd6:	e8 15 e7 ff ff       	call   801042f0 <exit>
    return 0;  // not reached
}
80105bdb:	31 c0                	xor    %eax,%eax
80105bdd:	c9                   	leave  
80105bde:	c3                   	ret    
80105bdf:	90                   	nop

80105be0 <sys_wait>:

int sys_wait(void) {
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
    return wait();
}
80105be3:	5d                   	pop    %ebp
    return wait();
80105be4:	e9 47 e9 ff ff       	jmp    80104530 <wait>
80105be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bf0 <sys_kill>:

int sys_kill(void) {
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	83 ec 20             	sub    $0x20,%esp
    int pid;

    if (argint(0, &pid) < 0) {
80105bf6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bf9:	50                   	push   %eax
80105bfa:	6a 00                	push   $0x0
80105bfc:	e8 3f f2 ff ff       	call   80104e40 <argint>
80105c01:	83 c4 10             	add    $0x10,%esp
80105c04:	85 c0                	test   %eax,%eax
80105c06:	78 18                	js     80105c20 <sys_kill+0x30>
        return -1;
    }
    return kill(pid);
80105c08:	83 ec 0c             	sub    $0xc,%esp
80105c0b:	ff 75 f4             	pushl  -0xc(%ebp)
80105c0e:	e8 6d ea ff ff       	call   80104680 <kill>
80105c13:	83 c4 10             	add    $0x10,%esp
}
80105c16:	c9                   	leave  
80105c17:	c3                   	ret    
80105c18:	90                   	nop
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c25:	c9                   	leave  
80105c26:	c3                   	ret    
80105c27:	89 f6                	mov    %esi,%esi
80105c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c30 <sys_getpid>:

int sys_getpid(void) {
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	83 ec 08             	sub    $0x8,%esp
    return myproc()->pid;
80105c36:	e8 95 e2 ff ff       	call   80103ed0 <myproc>
80105c3b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c3e:	c9                   	leave  
80105c3f:	c3                   	ret    

80105c40 <sys_sbrk>:

int sys_sbrk(void) {
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	53                   	push   %ebx
    int addr;
    int n;

    if (argint(0, &n) < 0) {
80105c44:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sbrk(void) {
80105c47:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0) {
80105c4a:	50                   	push   %eax
80105c4b:	6a 00                	push   $0x0
80105c4d:	e8 ee f1 ff ff       	call   80104e40 <argint>
80105c52:	83 c4 10             	add    $0x10,%esp
80105c55:	85 c0                	test   %eax,%eax
80105c57:	78 27                	js     80105c80 <sys_sbrk+0x40>
        return -1;
    }
    addr = myproc()->sz;
80105c59:	e8 72 e2 ff ff       	call   80103ed0 <myproc>
    if (growproc(n) < 0) {
80105c5e:	83 ec 0c             	sub    $0xc,%esp
    addr = myproc()->sz;
80105c61:	8b 18                	mov    (%eax),%ebx
    if (growproc(n) < 0) {
80105c63:	ff 75 f4             	pushl  -0xc(%ebp)
80105c66:	e8 85 e3 ff ff       	call   80103ff0 <growproc>
80105c6b:	83 c4 10             	add    $0x10,%esp
80105c6e:	85 c0                	test   %eax,%eax
80105c70:	78 0e                	js     80105c80 <sys_sbrk+0x40>
        return -1;
    }
    return addr;
}
80105c72:	89 d8                	mov    %ebx,%eax
80105c74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c77:	c9                   	leave  
80105c78:	c3                   	ret    
80105c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105c80:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c85:	eb eb                	jmp    80105c72 <sys_sbrk+0x32>
80105c87:	89 f6                	mov    %esi,%esi
80105c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c90 <sys_sleep>:

int sys_sleep(void) {
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	53                   	push   %ebx
    int n;
    uint ticks0;

    if (argint(0, &n) < 0) {
80105c94:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sleep(void) {
80105c97:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0) {
80105c9a:	50                   	push   %eax
80105c9b:	6a 00                	push   $0x0
80105c9d:	e8 9e f1 ff ff       	call   80104e40 <argint>
80105ca2:	83 c4 10             	add    $0x10,%esp
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	0f 88 8a 00 00 00    	js     80105d37 <sys_sleep+0xa7>
        return -1;
    }
    acquire(&tickslock);
80105cad:	83 ec 0c             	sub    $0xc,%esp
80105cb0:	68 40 74 11 80       	push   $0x80117440
80105cb5:	e8 76 ed ff ff       	call   80104a30 <acquire>
    ticks0 = ticks;
    while (ticks - ticks0 < n) {
80105cba:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cbd:	83 c4 10             	add    $0x10,%esp
    ticks0 = ticks;
80105cc0:	8b 1d 80 7c 11 80    	mov    0x80117c80,%ebx
    while (ticks - ticks0 < n) {
80105cc6:	85 d2                	test   %edx,%edx
80105cc8:	75 27                	jne    80105cf1 <sys_sleep+0x61>
80105cca:	eb 54                	jmp    80105d20 <sys_sleep+0x90>
80105ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (myproc()->killed) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
80105cd0:	83 ec 08             	sub    $0x8,%esp
80105cd3:	68 40 74 11 80       	push   $0x80117440
80105cd8:	68 80 7c 11 80       	push   $0x80117c80
80105cdd:	e8 8e e7 ff ff       	call   80104470 <sleep>
    while (ticks - ticks0 < n) {
80105ce2:	a1 80 7c 11 80       	mov    0x80117c80,%eax
80105ce7:	83 c4 10             	add    $0x10,%esp
80105cea:	29 d8                	sub    %ebx,%eax
80105cec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105cef:	73 2f                	jae    80105d20 <sys_sleep+0x90>
        if (myproc()->killed) {
80105cf1:	e8 da e1 ff ff       	call   80103ed0 <myproc>
80105cf6:	8b 40 24             	mov    0x24(%eax),%eax
80105cf9:	85 c0                	test   %eax,%eax
80105cfb:	74 d3                	je     80105cd0 <sys_sleep+0x40>
            release(&tickslock);
80105cfd:	83 ec 0c             	sub    $0xc,%esp
80105d00:	68 40 74 11 80       	push   $0x80117440
80105d05:	e8 e6 ed ff ff       	call   80104af0 <release>
            return -1;
80105d0a:	83 c4 10             	add    $0x10,%esp
80105d0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    release(&tickslock);
    return 0;
}
80105d12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d15:	c9                   	leave  
80105d16:	c3                   	ret    
80105d17:	89 f6                	mov    %esi,%esi
80105d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&tickslock);
80105d20:	83 ec 0c             	sub    $0xc,%esp
80105d23:	68 40 74 11 80       	push   $0x80117440
80105d28:	e8 c3 ed ff ff       	call   80104af0 <release>
    return 0;
80105d2d:	83 c4 10             	add    $0x10,%esp
80105d30:	31 c0                	xor    %eax,%eax
}
80105d32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d35:	c9                   	leave  
80105d36:	c3                   	ret    
        return -1;
80105d37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d3c:	eb f4                	jmp    80105d32 <sys_sleep+0xa2>
80105d3e:	66 90                	xchg   %ax,%ax

80105d40 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void) {
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	53                   	push   %ebx
80105d44:	83 ec 10             	sub    $0x10,%esp
    uint xticks;

    acquire(&tickslock);
80105d47:	68 40 74 11 80       	push   $0x80117440
80105d4c:	e8 df ec ff ff       	call   80104a30 <acquire>
    xticks = ticks;
80105d51:	8b 1d 80 7c 11 80    	mov    0x80117c80,%ebx
    release(&tickslock);
80105d57:	c7 04 24 40 74 11 80 	movl   $0x80117440,(%esp)
80105d5e:	e8 8d ed ff ff       	call   80104af0 <release>
    return xticks;
}
80105d63:	89 d8                	mov    %ebx,%eax
80105d65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d68:	c9                   	leave  
80105d69:	c3                   	ret    
80105d6a:	66 90                	xchg   %ax,%ax
80105d6c:	66 90                	xchg   %ax,%ax
80105d6e:	66 90                	xchg   %ax,%ax

80105d70 <sys_getch>:
#include "types.h"
#include "defs.h"

int sys_getch(void) {
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
    return consoleget();
}
80105d73:	5d                   	pop    %ebp
    return consoleget();
80105d74:	e9 37 ac ff ff       	jmp    801009b0 <consoleget>
80105d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d80 <sys_greeting>:

int sys_greeting(void)
{
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	83 ec 14             	sub    $0x14,%esp
    cprintf("Hello, user\n");
80105d86:	68 8d 7e 10 80       	push   $0x80107e8d
80105d8b:	e8 70 aa ff ff       	call   80100800 <cprintf>

    return 0;
}
80105d90:	31 c0                	xor    %eax,%eax
80105d92:	c9                   	leave  
80105d93:	c3                   	ret    
80105d94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105da0 <sys_videomodevga>:

int sys_videomodevga(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	83 ec 14             	sub    $0x14,%esp
    consolevgamode(0x13);
80105da6:	6a 13                	push   $0x13
80105da8:	e8 93 b0 ff ff       	call   80100e40 <consolevgamode>
    cprintf("VGA Mode Set to 0x13\n");
80105dad:	c7 04 24 9a 7e 10 80 	movl   $0x80107e9a,(%esp)
80105db4:	e8 47 aa ff ff       	call   80100800 <cprintf>
    return 0;
}
80105db9:	31 c0                	xor    %eax,%eax
80105dbb:	c9                   	leave  
80105dbc:	c3                   	ret    
80105dbd:	8d 76 00             	lea    0x0(%esi),%esi

80105dc0 <sys_videomodetext>:
int sys_videomodetext(void)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	83 ec 14             	sub    $0x14,%esp
    cprintf("VGA Mode Set to 0x03\n");
80105dc6:	68 b0 7e 10 80       	push   $0x80107eb0
80105dcb:	e8 30 aa ff ff       	call   80100800 <cprintf>
    consolevgamode(0x03);
80105dd0:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
80105dd7:	e8 64 b0 ff ff       	call   80100e40 <consolevgamode>
    return 0;
}
80105ddc:	31 c0                	xor    %eax,%eax
80105dde:	c9                   	leave  
80105ddf:	c3                   	ret    

80105de0 <sys_setspecificpixel>:

//int x, int y, unsigned char VGA_colour
int sys_setspecificpixel(void)
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	83 ec 20             	sub    $0x20,%esp
    int x;
    int y;
    int VGA_colour;
    argint(2, &VGA_colour);
80105de6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105de9:	50                   	push   %eax
80105dea:	6a 02                	push   $0x2
80105dec:	e8 4f f0 ff ff       	call   80104e40 <argint>
    argint(1, &y);
80105df1:	58                   	pop    %eax
80105df2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105df5:	5a                   	pop    %edx
80105df6:	50                   	push   %eax
80105df7:	6a 01                	push   $0x1
80105df9:	e8 42 f0 ff ff       	call   80104e40 <argint>
    argint(0, &x);
80105dfe:	59                   	pop    %ecx
80105dff:	58                   	pop    %eax
80105e00:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e03:	50                   	push   %eax
80105e04:	6a 00                	push   $0x0
80105e06:	e8 35 f0 ff ff       	call   80104e40 <argint>

    setpixel(x,y,VGA_colour);
80105e0b:	83 c4 0c             	add    $0xc,%esp
80105e0e:	ff 75 f4             	pushl  -0xc(%ebp)
80105e11:	ff 75 f0             	pushl  -0x10(%ebp)
80105e14:	ff 75 ec             	pushl  -0x14(%ebp)
80105e17:	e8 04 b2 ff ff       	call   80101020 <setpixel>
    return 0;
}
80105e1c:	31 c0                	xor    %eax,%eax
80105e1e:	c9                   	leave  
80105e1f:	c3                   	ret    

80105e20 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
    pushl %ds
80105e20:	1e                   	push   %ds
    pushl %es
80105e21:	06                   	push   %es
    pushl %fs
80105e22:	0f a0                	push   %fs
    pushl %gs
80105e24:	0f a8                	push   %gs
    pushal
80105e26:	60                   	pusha  
  
    # Set up data segments.
    movw $(SEG_KDATA<<3), %ax
80105e27:	66 b8 10 00          	mov    $0x10,%ax
    movw %ax, %ds
80105e2b:	8e d8                	mov    %eax,%ds
    movw %ax, %es
80105e2d:	8e c0                	mov    %eax,%es

    # Call trap(tf), where tf=%esp
    pushl %esp
80105e2f:	54                   	push   %esp
    call trap
80105e30:	e8 cb 00 00 00       	call   80105f00 <trap>
    addl $4, %esp
80105e35:	83 c4 04             	add    $0x4,%esp

80105e38 <trapret>:

    # Return falls through to trapret...
.globl trapret
trapret:
    popal
80105e38:	61                   	popa   
    popl %gs
80105e39:	0f a9                	pop    %gs
    popl %fs
80105e3b:	0f a1                	pop    %fs
    popl %es
80105e3d:	07                   	pop    %es
    popl %ds
80105e3e:	1f                   	pop    %ds
    addl $0x8, %esp  # trapno and errcode
80105e3f:	83 c4 08             	add    $0x8,%esp
    iret
80105e42:	cf                   	iret   
80105e43:	66 90                	xchg   %ax,%ax
80105e45:	66 90                	xchg   %ax,%ax
80105e47:	66 90                	xchg   %ax,%ax
80105e49:	66 90                	xchg   %ax,%ax
80105e4b:	66 90                	xchg   %ax,%ax
80105e4d:	66 90                	xchg   %ax,%ax
80105e4f:	90                   	nop

80105e50 <tvinit>:
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void) {
80105e50:	55                   	push   %ebp
    int i;

    for (i = 0; i < 256; i++) {
80105e51:	31 c0                	xor    %eax,%eax
void tvinit(void) {
80105e53:	89 e5                	mov    %esp,%ebp
80105e55:	83 ec 08             	sub    $0x8,%esp
80105e58:	90                   	nop
80105e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105e60:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80105e67:	c7 04 c5 82 74 11 80 	movl   $0x8e000008,-0x7fee8b7e(,%eax,8)
80105e6e:	08 00 00 8e 
80105e72:	66 89 14 c5 80 74 11 	mov    %dx,-0x7fee8b80(,%eax,8)
80105e79:	80 
80105e7a:	c1 ea 10             	shr    $0x10,%edx
80105e7d:	66 89 14 c5 86 74 11 	mov    %dx,-0x7fee8b7a(,%eax,8)
80105e84:	80 
    for (i = 0; i < 256; i++) {
80105e85:	83 c0 01             	add    $0x1,%eax
80105e88:	3d 00 01 00 00       	cmp    $0x100,%eax
80105e8d:	75 d1                	jne    80105e60 <tvinit+0x10>
    }
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105e8f:	a1 08 c1 10 80       	mov    0x8010c108,%eax

    initlock(&tickslock, "time");
80105e94:	83 ec 08             	sub    $0x8,%esp
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105e97:	c7 05 82 76 11 80 08 	movl   $0xef000008,0x80117682
80105e9e:	00 00 ef 
    initlock(&tickslock, "time");
80105ea1:	68 c6 7e 10 80       	push   $0x80107ec6
80105ea6:	68 40 74 11 80       	push   $0x80117440
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105eab:	66 a3 80 76 11 80    	mov    %ax,0x80117680
80105eb1:	c1 e8 10             	shr    $0x10,%eax
80105eb4:	66 a3 86 76 11 80    	mov    %ax,0x80117686
    initlock(&tickslock, "time");
80105eba:	e8 31 ea ff ff       	call   801048f0 <initlock>
}
80105ebf:	83 c4 10             	add    $0x10,%esp
80105ec2:	c9                   	leave  
80105ec3:	c3                   	ret    
80105ec4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105eca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105ed0 <idtinit>:

void idtinit(void) {
80105ed0:	55                   	push   %ebp
    pd[0] = size - 1;
80105ed1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ed6:	89 e5                	mov    %esp,%ebp
80105ed8:	83 ec 10             	sub    $0x10,%esp
80105edb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    pd[1] = (uint)p;
80105edf:	b8 80 74 11 80       	mov    $0x80117480,%eax
80105ee4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    pd[2] = (uint)p >> 16;
80105ee8:	c1 e8 10             	shr    $0x10,%eax
80105eeb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    asm volatile ("lidt (%0)" : : "r" (pd));
80105eef:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ef2:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
80105ef5:	c9                   	leave  
80105ef6:	c3                   	ret    
80105ef7:	89 f6                	mov    %esi,%esi
80105ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f00 <trap>:

void trap(struct trapframe *tf) {
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	57                   	push   %edi
80105f04:	56                   	push   %esi
80105f05:	53                   	push   %ebx
80105f06:	83 ec 1c             	sub    $0x1c,%esp
80105f09:	8b 7d 08             	mov    0x8(%ebp),%edi
    if (tf->trapno == T_SYSCALL) {
80105f0c:	8b 47 30             	mov    0x30(%edi),%eax
80105f0f:	83 f8 40             	cmp    $0x40,%eax
80105f12:	0f 84 f0 00 00 00    	je     80106008 <trap+0x108>
            exit();
        }
        return;
    }

    switch (tf->trapno) {
80105f18:	83 e8 20             	sub    $0x20,%eax
80105f1b:	83 f8 1f             	cmp    $0x1f,%eax
80105f1e:	77 10                	ja     80105f30 <trap+0x30>
80105f20:	ff 24 85 6c 7f 10 80 	jmp    *-0x7fef8094(,%eax,4)
80105f27:	89 f6                	mov    %esi,%esi
80105f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            lapiceoi();
            break;

    
        default:
            if (myproc() == 0 || (tf->cs & 3) == 0) {
80105f30:	e8 9b df ff ff       	call   80103ed0 <myproc>
80105f35:	85 c0                	test   %eax,%eax
80105f37:	8b 5f 38             	mov    0x38(%edi),%ebx
80105f3a:	0f 84 14 02 00 00    	je     80106154 <trap+0x254>
80105f40:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105f44:	0f 84 0a 02 00 00    	je     80106154 <trap+0x254>
    return result;
}

static inline uint rcr2(void) {
    uint val;
    asm volatile ("movl %%cr2,%0" : "=r" (val));
80105f4a:	0f 20 d1             	mov    %cr2,%ecx
80105f4d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f50:	e8 5b df ff ff       	call   80103eb0 <cpuid>
80105f55:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105f58:	8b 47 34             	mov    0x34(%edi),%eax
80105f5b:	8b 77 30             	mov    0x30(%edi),%esi
80105f5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                    "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
80105f61:	e8 6a df ff ff       	call   80103ed0 <myproc>
80105f66:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f69:	e8 62 df ff ff       	call   80103ed0 <myproc>
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f6e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105f71:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105f74:	51                   	push   %ecx
80105f75:	53                   	push   %ebx
80105f76:	52                   	push   %edx
                    myproc()->pid, myproc()->name, tf->trapno,
80105f77:	8b 55 e0             	mov    -0x20(%ebp),%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f7a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f7d:	56                   	push   %esi
                    myproc()->pid, myproc()->name, tf->trapno,
80105f7e:	83 c2 6c             	add    $0x6c,%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f81:	52                   	push   %edx
80105f82:	ff 70 10             	pushl  0x10(%eax)
80105f85:	68 28 7f 10 80       	push   $0x80107f28
80105f8a:	e8 71 a8 ff ff       	call   80100800 <cprintf>
                    tf->err, cpuid(), tf->eip, rcr2());
            myproc()->killed = 1;
80105f8f:	83 c4 20             	add    $0x20,%esp
80105f92:	e8 39 df ff ff       	call   80103ed0 <myproc>
80105f97:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
80105f9e:	e8 2d df ff ff       	call   80103ed0 <myproc>
80105fa3:	85 c0                	test   %eax,%eax
80105fa5:	74 1d                	je     80105fc4 <trap+0xc4>
80105fa7:	e8 24 df ff ff       	call   80103ed0 <myproc>
80105fac:	8b 50 24             	mov    0x24(%eax),%edx
80105faf:	85 d2                	test   %edx,%edx
80105fb1:	74 11                	je     80105fc4 <trap+0xc4>
80105fb3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105fb7:	83 e0 03             	and    $0x3,%eax
80105fba:	66 83 f8 03          	cmp    $0x3,%ax
80105fbe:	0f 84 4c 01 00 00    	je     80106110 <trap+0x210>
        exit();
    }

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
80105fc4:	e8 07 df ff ff       	call   80103ed0 <myproc>
80105fc9:	85 c0                	test   %eax,%eax
80105fcb:	74 0b                	je     80105fd8 <trap+0xd8>
80105fcd:	e8 fe de ff ff       	call   80103ed0 <myproc>
80105fd2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105fd6:	74 68                	je     80106040 <trap+0x140>
        tf->trapno == T_IRQ0 + IRQ_TIMER) {
        yield();
    }

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
80105fd8:	e8 f3 de ff ff       	call   80103ed0 <myproc>
80105fdd:	85 c0                	test   %eax,%eax
80105fdf:	74 19                	je     80105ffa <trap+0xfa>
80105fe1:	e8 ea de ff ff       	call   80103ed0 <myproc>
80105fe6:	8b 40 24             	mov    0x24(%eax),%eax
80105fe9:	85 c0                	test   %eax,%eax
80105feb:	74 0d                	je     80105ffa <trap+0xfa>
80105fed:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ff1:	83 e0 03             	and    $0x3,%eax
80105ff4:	66 83 f8 03          	cmp    $0x3,%ax
80105ff8:	74 37                	je     80106031 <trap+0x131>
        exit();
    }
}
80105ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ffd:	5b                   	pop    %ebx
80105ffe:	5e                   	pop    %esi
80105fff:	5f                   	pop    %edi
80106000:	5d                   	pop    %ebp
80106001:	c3                   	ret    
80106002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (myproc()->killed) {
80106008:	e8 c3 de ff ff       	call   80103ed0 <myproc>
8010600d:	8b 58 24             	mov    0x24(%eax),%ebx
80106010:	85 db                	test   %ebx,%ebx
80106012:	0f 85 e8 00 00 00    	jne    80106100 <trap+0x200>
        myproc()->tf = tf;
80106018:	e8 b3 de ff ff       	call   80103ed0 <myproc>
8010601d:	89 78 18             	mov    %edi,0x18(%eax)
        syscall();
80106020:	e8 0b ef ff ff       	call   80104f30 <syscall>
        if (myproc()->killed) {
80106025:	e8 a6 de ff ff       	call   80103ed0 <myproc>
8010602a:	8b 48 24             	mov    0x24(%eax),%ecx
8010602d:	85 c9                	test   %ecx,%ecx
8010602f:	74 c9                	je     80105ffa <trap+0xfa>
}
80106031:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106034:	5b                   	pop    %ebx
80106035:	5e                   	pop    %esi
80106036:	5f                   	pop    %edi
80106037:	5d                   	pop    %ebp
            exit();
80106038:	e9 b3 e2 ff ff       	jmp    801042f0 <exit>
8010603d:	8d 76 00             	lea    0x0(%esi),%esi
    if (myproc() && myproc()->state == RUNNING &&
80106040:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106044:	75 92                	jne    80105fd8 <trap+0xd8>
        yield();
80106046:	e8 d5 e3 ff ff       	call   80104420 <yield>
8010604b:	eb 8b                	jmp    80105fd8 <trap+0xd8>
8010604d:	8d 76 00             	lea    0x0(%esi),%esi
            if (cpuid() == 0) {
80106050:	e8 5b de ff ff       	call   80103eb0 <cpuid>
80106055:	85 c0                	test   %eax,%eax
80106057:	0f 84 c3 00 00 00    	je     80106120 <trap+0x220>
            lapiceoi();
8010605d:	e8 ae cd ff ff       	call   80102e10 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
80106062:	e8 69 de ff ff       	call   80103ed0 <myproc>
80106067:	85 c0                	test   %eax,%eax
80106069:	0f 85 38 ff ff ff    	jne    80105fa7 <trap+0xa7>
8010606f:	e9 50 ff ff ff       	jmp    80105fc4 <trap+0xc4>
80106074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            kbdintr();
80106078:	e8 53 cc ff ff       	call   80102cd0 <kbdintr>
            lapiceoi();
8010607d:	e8 8e cd ff ff       	call   80102e10 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
80106082:	e8 49 de ff ff       	call   80103ed0 <myproc>
80106087:	85 c0                	test   %eax,%eax
80106089:	0f 85 18 ff ff ff    	jne    80105fa7 <trap+0xa7>
8010608f:	e9 30 ff ff ff       	jmp    80105fc4 <trap+0xc4>
80106094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            uartintr();
80106098:	e8 53 02 00 00       	call   801062f0 <uartintr>
            lapiceoi();
8010609d:	e8 6e cd ff ff       	call   80102e10 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
801060a2:	e8 29 de ff ff       	call   80103ed0 <myproc>
801060a7:	85 c0                	test   %eax,%eax
801060a9:	0f 85 f8 fe ff ff    	jne    80105fa7 <trap+0xa7>
801060af:	e9 10 ff ff ff       	jmp    80105fc4 <trap+0xc4>
801060b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
801060b8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801060bc:	8b 77 38             	mov    0x38(%edi),%esi
801060bf:	e8 ec dd ff ff       	call   80103eb0 <cpuid>
801060c4:	56                   	push   %esi
801060c5:	53                   	push   %ebx
801060c6:	50                   	push   %eax
801060c7:	68 d0 7e 10 80       	push   $0x80107ed0
801060cc:	e8 2f a7 ff ff       	call   80100800 <cprintf>
            lapiceoi();
801060d1:	e8 3a cd ff ff       	call   80102e10 <lapiceoi>
            break;
801060d6:	83 c4 10             	add    $0x10,%esp
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
801060d9:	e8 f2 dd ff ff       	call   80103ed0 <myproc>
801060de:	85 c0                	test   %eax,%eax
801060e0:	0f 85 c1 fe ff ff    	jne    80105fa7 <trap+0xa7>
801060e6:	e9 d9 fe ff ff       	jmp    80105fc4 <trap+0xc4>
801060eb:	90                   	nop
801060ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            ideintr();
801060f0:	e8 4b c6 ff ff       	call   80102740 <ideintr>
801060f5:	e9 63 ff ff ff       	jmp    8010605d <trap+0x15d>
801060fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            exit();
80106100:	e8 eb e1 ff ff       	call   801042f0 <exit>
80106105:	e9 0e ff ff ff       	jmp    80106018 <trap+0x118>
8010610a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        exit();
80106110:	e8 db e1 ff ff       	call   801042f0 <exit>
80106115:	e9 aa fe ff ff       	jmp    80105fc4 <trap+0xc4>
8010611a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                acquire(&tickslock);
80106120:	83 ec 0c             	sub    $0xc,%esp
80106123:	68 40 74 11 80       	push   $0x80117440
80106128:	e8 03 e9 ff ff       	call   80104a30 <acquire>
                wakeup(&ticks);
8010612d:	c7 04 24 80 7c 11 80 	movl   $0x80117c80,(%esp)
                ticks++;
80106134:	83 05 80 7c 11 80 01 	addl   $0x1,0x80117c80
                wakeup(&ticks);
8010613b:	e8 e0 e4 ff ff       	call   80104620 <wakeup>
                release(&tickslock);
80106140:	c7 04 24 40 74 11 80 	movl   $0x80117440,(%esp)
80106147:	e8 a4 e9 ff ff       	call   80104af0 <release>
8010614c:	83 c4 10             	add    $0x10,%esp
8010614f:	e9 09 ff ff ff       	jmp    8010605d <trap+0x15d>
80106154:	0f 20 d6             	mov    %cr2,%esi
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106157:	e8 54 dd ff ff       	call   80103eb0 <cpuid>
8010615c:	83 ec 0c             	sub    $0xc,%esp
8010615f:	56                   	push   %esi
80106160:	53                   	push   %ebx
80106161:	50                   	push   %eax
80106162:	ff 77 30             	pushl  0x30(%edi)
80106165:	68 f4 7e 10 80       	push   $0x80107ef4
8010616a:	e8 91 a6 ff ff       	call   80100800 <cprintf>
                panic("trap");
8010616f:	83 c4 14             	add    $0x14,%esp
80106172:	68 cb 7e 10 80       	push   $0x80107ecb
80106177:	e8 04 a3 ff ff       	call   80100480 <panic>
8010617c:	66 90                	xchg   %ax,%ax
8010617e:	66 90                	xchg   %ax,%ax

80106180 <uartgetc>:
    }
    outb(COM1 + 0, c);
}

static int uartgetc(void)            {
    if (!uart) {
80106180:	a1 bc c5 10 80       	mov    0x8010c5bc,%eax
static int uartgetc(void)            {
80106185:	55                   	push   %ebp
80106186:	89 e5                	mov    %esp,%ebp
    if (!uart) {
80106188:	85 c0                	test   %eax,%eax
8010618a:	74 1c                	je     801061a8 <uartgetc+0x28>
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
8010618c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106191:	ec                   	in     (%dx),%al
        return -1;
    }
    if (!(inb(COM1 + 5) & 0x01)) {
80106192:	a8 01                	test   $0x1,%al
80106194:	74 12                	je     801061a8 <uartgetc+0x28>
80106196:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010619b:	ec                   	in     (%dx),%al
        return -1;
    }
    return inb(COM1 + 0);
8010619c:	0f b6 c0             	movzbl %al,%eax
}
8010619f:	5d                   	pop    %ebp
801061a0:	c3                   	ret    
801061a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801061a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061ad:	5d                   	pop    %ebp
801061ae:	c3                   	ret    
801061af:	90                   	nop

801061b0 <uartputc.part.0>:
void uartputc(int c) {
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
801061b3:	57                   	push   %edi
801061b4:	56                   	push   %esi
801061b5:	53                   	push   %ebx
801061b6:	89 c7                	mov    %eax,%edi
801061b8:	bb 80 00 00 00       	mov    $0x80,%ebx
801061bd:	be fd 03 00 00       	mov    $0x3fd,%esi
801061c2:	83 ec 0c             	sub    $0xc,%esp
801061c5:	eb 1b                	jmp    801061e2 <uartputc.part.0+0x32>
801061c7:	89 f6                	mov    %esi,%esi
801061c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        microdelay(10);
801061d0:	83 ec 0c             	sub    $0xc,%esp
801061d3:	6a 0a                	push   $0xa
801061d5:	e8 56 cc ff ff       	call   80102e30 <microdelay>
    for (i = 0; i < 128 && !(inb(COM1 + 5) & 0x20); i++) {
801061da:	83 c4 10             	add    $0x10,%esp
801061dd:	83 eb 01             	sub    $0x1,%ebx
801061e0:	74 07                	je     801061e9 <uartputc.part.0+0x39>
801061e2:	89 f2                	mov    %esi,%edx
801061e4:	ec                   	in     (%dx),%al
801061e5:	a8 20                	test   $0x20,%al
801061e7:	74 e7                	je     801061d0 <uartputc.part.0+0x20>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
801061e9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061ee:	89 f8                	mov    %edi,%eax
801061f0:	ee                   	out    %al,(%dx)
}
801061f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061f4:	5b                   	pop    %ebx
801061f5:	5e                   	pop    %esi
801061f6:	5f                   	pop    %edi
801061f7:	5d                   	pop    %ebp
801061f8:	c3                   	ret    
801061f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106200 <uartinit>:
void uartinit(void) {
80106200:	55                   	push   %ebp
80106201:	31 c9                	xor    %ecx,%ecx
80106203:	89 c8                	mov    %ecx,%eax
80106205:	89 e5                	mov    %esp,%ebp
80106207:	57                   	push   %edi
80106208:	56                   	push   %esi
80106209:	53                   	push   %ebx
8010620a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010620f:	89 da                	mov    %ebx,%edx
80106211:	83 ec 0c             	sub    $0xc,%esp
80106214:	ee                   	out    %al,(%dx)
80106215:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010621a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010621f:	89 fa                	mov    %edi,%edx
80106221:	ee                   	out    %al,(%dx)
80106222:	b8 0c 00 00 00       	mov    $0xc,%eax
80106227:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010622c:	ee                   	out    %al,(%dx)
8010622d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106232:	89 c8                	mov    %ecx,%eax
80106234:	89 f2                	mov    %esi,%edx
80106236:	ee                   	out    %al,(%dx)
80106237:	b8 03 00 00 00       	mov    $0x3,%eax
8010623c:	89 fa                	mov    %edi,%edx
8010623e:	ee                   	out    %al,(%dx)
8010623f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106244:	89 c8                	mov    %ecx,%eax
80106246:	ee                   	out    %al,(%dx)
80106247:	b8 01 00 00 00       	mov    $0x1,%eax
8010624c:	89 f2                	mov    %esi,%edx
8010624e:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
8010624f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106254:	ec                   	in     (%dx),%al
    if (inb(COM1 + 5) == 0xFF) {
80106255:	3c ff                	cmp    $0xff,%al
80106257:	74 5a                	je     801062b3 <uartinit+0xb3>
    uart = 1;
80106259:	c7 05 bc c5 10 80 01 	movl   $0x1,0x8010c5bc
80106260:	00 00 00 
80106263:	89 da                	mov    %ebx,%edx
80106265:	ec                   	in     (%dx),%al
80106266:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010626b:	ec                   	in     (%dx),%al
    ioapicenable(IRQ_COM1, 0);
8010626c:	83 ec 08             	sub    $0x8,%esp
    for (p = "xv6...\n"; *p; p++) {
8010626f:	bb ec 7f 10 80       	mov    $0x80107fec,%ebx
    ioapicenable(IRQ_COM1, 0);
80106274:	6a 00                	push   $0x0
80106276:	6a 04                	push   $0x4
80106278:	e8 13 c7 ff ff       	call   80102990 <ioapicenable>
8010627d:	83 c4 10             	add    $0x10,%esp
    for (p = "xv6...\n"; *p; p++) {
80106280:	b8 78 00 00 00       	mov    $0x78,%eax
80106285:	eb 13                	jmp    8010629a <uartinit+0x9a>
80106287:	89 f6                	mov    %esi,%esi
80106289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106290:	83 c3 01             	add    $0x1,%ebx
80106293:	0f be 03             	movsbl (%ebx),%eax
80106296:	84 c0                	test   %al,%al
80106298:	74 19                	je     801062b3 <uartinit+0xb3>
    if (!uart) {
8010629a:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
801062a0:	85 d2                	test   %edx,%edx
801062a2:	74 ec                	je     80106290 <uartinit+0x90>
    for (p = "xv6...\n"; *p; p++) {
801062a4:	83 c3 01             	add    $0x1,%ebx
801062a7:	e8 04 ff ff ff       	call   801061b0 <uartputc.part.0>
801062ac:	0f be 03             	movsbl (%ebx),%eax
801062af:	84 c0                	test   %al,%al
801062b1:	75 e7                	jne    8010629a <uartinit+0x9a>
}
801062b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062b6:	5b                   	pop    %ebx
801062b7:	5e                   	pop    %esi
801062b8:	5f                   	pop    %edi
801062b9:	5d                   	pop    %ebp
801062ba:	c3                   	ret    
801062bb:	90                   	nop
801062bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062c0 <uartputc>:
    if (!uart) {
801062c0:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
void uartputc(int c) {
801062c6:	55                   	push   %ebp
801062c7:	89 e5                	mov    %esp,%ebp
    if (!uart) {
801062c9:	85 d2                	test   %edx,%edx
void uartputc(int c) {
801062cb:	8b 45 08             	mov    0x8(%ebp),%eax
    if (!uart) {
801062ce:	74 10                	je     801062e0 <uartputc+0x20>
}
801062d0:	5d                   	pop    %ebp
801062d1:	e9 da fe ff ff       	jmp    801061b0 <uartputc.part.0>
801062d6:	8d 76 00             	lea    0x0(%esi),%esi
801062d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801062e0:	5d                   	pop    %ebp
801062e1:	c3                   	ret    
801062e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062f0 <uartintr>:

void uartintr(void) {
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	83 ec 14             	sub    $0x14,%esp
    consoleintr(uartgetc);
801062f6:	68 80 61 10 80       	push   $0x80106180
801062fb:	e8 00 a7 ff ff       	call   80100a00 <consoleintr>
}
80106300:	83 c4 10             	add    $0x10,%esp
80106303:	c9                   	leave  
80106304:	c3                   	ret    

80106305 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106305:	6a 00                	push   $0x0
  pushl $0
80106307:	6a 00                	push   $0x0
  jmp alltraps
80106309:	e9 12 fb ff ff       	jmp    80105e20 <alltraps>

8010630e <vector1>:
.globl vector1
vector1:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $1
80106310:	6a 01                	push   $0x1
  jmp alltraps
80106312:	e9 09 fb ff ff       	jmp    80105e20 <alltraps>

80106317 <vector2>:
.globl vector2
vector2:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $2
80106319:	6a 02                	push   $0x2
  jmp alltraps
8010631b:	e9 00 fb ff ff       	jmp    80105e20 <alltraps>

80106320 <vector3>:
.globl vector3
vector3:
  pushl $0
80106320:	6a 00                	push   $0x0
  pushl $3
80106322:	6a 03                	push   $0x3
  jmp alltraps
80106324:	e9 f7 fa ff ff       	jmp    80105e20 <alltraps>

80106329 <vector4>:
.globl vector4
vector4:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $4
8010632b:	6a 04                	push   $0x4
  jmp alltraps
8010632d:	e9 ee fa ff ff       	jmp    80105e20 <alltraps>

80106332 <vector5>:
.globl vector5
vector5:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $5
80106334:	6a 05                	push   $0x5
  jmp alltraps
80106336:	e9 e5 fa ff ff       	jmp    80105e20 <alltraps>

8010633b <vector6>:
.globl vector6
vector6:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $6
8010633d:	6a 06                	push   $0x6
  jmp alltraps
8010633f:	e9 dc fa ff ff       	jmp    80105e20 <alltraps>

80106344 <vector7>:
.globl vector7
vector7:
  pushl $0
80106344:	6a 00                	push   $0x0
  pushl $7
80106346:	6a 07                	push   $0x7
  jmp alltraps
80106348:	e9 d3 fa ff ff       	jmp    80105e20 <alltraps>

8010634d <vector8>:
.globl vector8
vector8:
  pushl $8
8010634d:	6a 08                	push   $0x8
  jmp alltraps
8010634f:	e9 cc fa ff ff       	jmp    80105e20 <alltraps>

80106354 <vector9>:
.globl vector9
vector9:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $9
80106356:	6a 09                	push   $0x9
  jmp alltraps
80106358:	e9 c3 fa ff ff       	jmp    80105e20 <alltraps>

8010635d <vector10>:
.globl vector10
vector10:
  pushl $10
8010635d:	6a 0a                	push   $0xa
  jmp alltraps
8010635f:	e9 bc fa ff ff       	jmp    80105e20 <alltraps>

80106364 <vector11>:
.globl vector11
vector11:
  pushl $11
80106364:	6a 0b                	push   $0xb
  jmp alltraps
80106366:	e9 b5 fa ff ff       	jmp    80105e20 <alltraps>

8010636b <vector12>:
.globl vector12
vector12:
  pushl $12
8010636b:	6a 0c                	push   $0xc
  jmp alltraps
8010636d:	e9 ae fa ff ff       	jmp    80105e20 <alltraps>

80106372 <vector13>:
.globl vector13
vector13:
  pushl $13
80106372:	6a 0d                	push   $0xd
  jmp alltraps
80106374:	e9 a7 fa ff ff       	jmp    80105e20 <alltraps>

80106379 <vector14>:
.globl vector14
vector14:
  pushl $14
80106379:	6a 0e                	push   $0xe
  jmp alltraps
8010637b:	e9 a0 fa ff ff       	jmp    80105e20 <alltraps>

80106380 <vector15>:
.globl vector15
vector15:
  pushl $0
80106380:	6a 00                	push   $0x0
  pushl $15
80106382:	6a 0f                	push   $0xf
  jmp alltraps
80106384:	e9 97 fa ff ff       	jmp    80105e20 <alltraps>

80106389 <vector16>:
.globl vector16
vector16:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $16
8010638b:	6a 10                	push   $0x10
  jmp alltraps
8010638d:	e9 8e fa ff ff       	jmp    80105e20 <alltraps>

80106392 <vector17>:
.globl vector17
vector17:
  pushl $17
80106392:	6a 11                	push   $0x11
  jmp alltraps
80106394:	e9 87 fa ff ff       	jmp    80105e20 <alltraps>

80106399 <vector18>:
.globl vector18
vector18:
  pushl $0
80106399:	6a 00                	push   $0x0
  pushl $18
8010639b:	6a 12                	push   $0x12
  jmp alltraps
8010639d:	e9 7e fa ff ff       	jmp    80105e20 <alltraps>

801063a2 <vector19>:
.globl vector19
vector19:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $19
801063a4:	6a 13                	push   $0x13
  jmp alltraps
801063a6:	e9 75 fa ff ff       	jmp    80105e20 <alltraps>

801063ab <vector20>:
.globl vector20
vector20:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $20
801063ad:	6a 14                	push   $0x14
  jmp alltraps
801063af:	e9 6c fa ff ff       	jmp    80105e20 <alltraps>

801063b4 <vector21>:
.globl vector21
vector21:
  pushl $0
801063b4:	6a 00                	push   $0x0
  pushl $21
801063b6:	6a 15                	push   $0x15
  jmp alltraps
801063b8:	e9 63 fa ff ff       	jmp    80105e20 <alltraps>

801063bd <vector22>:
.globl vector22
vector22:
  pushl $0
801063bd:	6a 00                	push   $0x0
  pushl $22
801063bf:	6a 16                	push   $0x16
  jmp alltraps
801063c1:	e9 5a fa ff ff       	jmp    80105e20 <alltraps>

801063c6 <vector23>:
.globl vector23
vector23:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $23
801063c8:	6a 17                	push   $0x17
  jmp alltraps
801063ca:	e9 51 fa ff ff       	jmp    80105e20 <alltraps>

801063cf <vector24>:
.globl vector24
vector24:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $24
801063d1:	6a 18                	push   $0x18
  jmp alltraps
801063d3:	e9 48 fa ff ff       	jmp    80105e20 <alltraps>

801063d8 <vector25>:
.globl vector25
vector25:
  pushl $0
801063d8:	6a 00                	push   $0x0
  pushl $25
801063da:	6a 19                	push   $0x19
  jmp alltraps
801063dc:	e9 3f fa ff ff       	jmp    80105e20 <alltraps>

801063e1 <vector26>:
.globl vector26
vector26:
  pushl $0
801063e1:	6a 00                	push   $0x0
  pushl $26
801063e3:	6a 1a                	push   $0x1a
  jmp alltraps
801063e5:	e9 36 fa ff ff       	jmp    80105e20 <alltraps>

801063ea <vector27>:
.globl vector27
vector27:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $27
801063ec:	6a 1b                	push   $0x1b
  jmp alltraps
801063ee:	e9 2d fa ff ff       	jmp    80105e20 <alltraps>

801063f3 <vector28>:
.globl vector28
vector28:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $28
801063f5:	6a 1c                	push   $0x1c
  jmp alltraps
801063f7:	e9 24 fa ff ff       	jmp    80105e20 <alltraps>

801063fc <vector29>:
.globl vector29
vector29:
  pushl $0
801063fc:	6a 00                	push   $0x0
  pushl $29
801063fe:	6a 1d                	push   $0x1d
  jmp alltraps
80106400:	e9 1b fa ff ff       	jmp    80105e20 <alltraps>

80106405 <vector30>:
.globl vector30
vector30:
  pushl $0
80106405:	6a 00                	push   $0x0
  pushl $30
80106407:	6a 1e                	push   $0x1e
  jmp alltraps
80106409:	e9 12 fa ff ff       	jmp    80105e20 <alltraps>

8010640e <vector31>:
.globl vector31
vector31:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $31
80106410:	6a 1f                	push   $0x1f
  jmp alltraps
80106412:	e9 09 fa ff ff       	jmp    80105e20 <alltraps>

80106417 <vector32>:
.globl vector32
vector32:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $32
80106419:	6a 20                	push   $0x20
  jmp alltraps
8010641b:	e9 00 fa ff ff       	jmp    80105e20 <alltraps>

80106420 <vector33>:
.globl vector33
vector33:
  pushl $0
80106420:	6a 00                	push   $0x0
  pushl $33
80106422:	6a 21                	push   $0x21
  jmp alltraps
80106424:	e9 f7 f9 ff ff       	jmp    80105e20 <alltraps>

80106429 <vector34>:
.globl vector34
vector34:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $34
8010642b:	6a 22                	push   $0x22
  jmp alltraps
8010642d:	e9 ee f9 ff ff       	jmp    80105e20 <alltraps>

80106432 <vector35>:
.globl vector35
vector35:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $35
80106434:	6a 23                	push   $0x23
  jmp alltraps
80106436:	e9 e5 f9 ff ff       	jmp    80105e20 <alltraps>

8010643b <vector36>:
.globl vector36
vector36:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $36
8010643d:	6a 24                	push   $0x24
  jmp alltraps
8010643f:	e9 dc f9 ff ff       	jmp    80105e20 <alltraps>

80106444 <vector37>:
.globl vector37
vector37:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $37
80106446:	6a 25                	push   $0x25
  jmp alltraps
80106448:	e9 d3 f9 ff ff       	jmp    80105e20 <alltraps>

8010644d <vector38>:
.globl vector38
vector38:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $38
8010644f:	6a 26                	push   $0x26
  jmp alltraps
80106451:	e9 ca f9 ff ff       	jmp    80105e20 <alltraps>

80106456 <vector39>:
.globl vector39
vector39:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $39
80106458:	6a 27                	push   $0x27
  jmp alltraps
8010645a:	e9 c1 f9 ff ff       	jmp    80105e20 <alltraps>

8010645f <vector40>:
.globl vector40
vector40:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $40
80106461:	6a 28                	push   $0x28
  jmp alltraps
80106463:	e9 b8 f9 ff ff       	jmp    80105e20 <alltraps>

80106468 <vector41>:
.globl vector41
vector41:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $41
8010646a:	6a 29                	push   $0x29
  jmp alltraps
8010646c:	e9 af f9 ff ff       	jmp    80105e20 <alltraps>

80106471 <vector42>:
.globl vector42
vector42:
  pushl $0
80106471:	6a 00                	push   $0x0
  pushl $42
80106473:	6a 2a                	push   $0x2a
  jmp alltraps
80106475:	e9 a6 f9 ff ff       	jmp    80105e20 <alltraps>

8010647a <vector43>:
.globl vector43
vector43:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $43
8010647c:	6a 2b                	push   $0x2b
  jmp alltraps
8010647e:	e9 9d f9 ff ff       	jmp    80105e20 <alltraps>

80106483 <vector44>:
.globl vector44
vector44:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $44
80106485:	6a 2c                	push   $0x2c
  jmp alltraps
80106487:	e9 94 f9 ff ff       	jmp    80105e20 <alltraps>

8010648c <vector45>:
.globl vector45
vector45:
  pushl $0
8010648c:	6a 00                	push   $0x0
  pushl $45
8010648e:	6a 2d                	push   $0x2d
  jmp alltraps
80106490:	e9 8b f9 ff ff       	jmp    80105e20 <alltraps>

80106495 <vector46>:
.globl vector46
vector46:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $46
80106497:	6a 2e                	push   $0x2e
  jmp alltraps
80106499:	e9 82 f9 ff ff       	jmp    80105e20 <alltraps>

8010649e <vector47>:
.globl vector47
vector47:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $47
801064a0:	6a 2f                	push   $0x2f
  jmp alltraps
801064a2:	e9 79 f9 ff ff       	jmp    80105e20 <alltraps>

801064a7 <vector48>:
.globl vector48
vector48:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $48
801064a9:	6a 30                	push   $0x30
  jmp alltraps
801064ab:	e9 70 f9 ff ff       	jmp    80105e20 <alltraps>

801064b0 <vector49>:
.globl vector49
vector49:
  pushl $0
801064b0:	6a 00                	push   $0x0
  pushl $49
801064b2:	6a 31                	push   $0x31
  jmp alltraps
801064b4:	e9 67 f9 ff ff       	jmp    80105e20 <alltraps>

801064b9 <vector50>:
.globl vector50
vector50:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $50
801064bb:	6a 32                	push   $0x32
  jmp alltraps
801064bd:	e9 5e f9 ff ff       	jmp    80105e20 <alltraps>

801064c2 <vector51>:
.globl vector51
vector51:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $51
801064c4:	6a 33                	push   $0x33
  jmp alltraps
801064c6:	e9 55 f9 ff ff       	jmp    80105e20 <alltraps>

801064cb <vector52>:
.globl vector52
vector52:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $52
801064cd:	6a 34                	push   $0x34
  jmp alltraps
801064cf:	e9 4c f9 ff ff       	jmp    80105e20 <alltraps>

801064d4 <vector53>:
.globl vector53
vector53:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $53
801064d6:	6a 35                	push   $0x35
  jmp alltraps
801064d8:	e9 43 f9 ff ff       	jmp    80105e20 <alltraps>

801064dd <vector54>:
.globl vector54
vector54:
  pushl $0
801064dd:	6a 00                	push   $0x0
  pushl $54
801064df:	6a 36                	push   $0x36
  jmp alltraps
801064e1:	e9 3a f9 ff ff       	jmp    80105e20 <alltraps>

801064e6 <vector55>:
.globl vector55
vector55:
  pushl $0
801064e6:	6a 00                	push   $0x0
  pushl $55
801064e8:	6a 37                	push   $0x37
  jmp alltraps
801064ea:	e9 31 f9 ff ff       	jmp    80105e20 <alltraps>

801064ef <vector56>:
.globl vector56
vector56:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $56
801064f1:	6a 38                	push   $0x38
  jmp alltraps
801064f3:	e9 28 f9 ff ff       	jmp    80105e20 <alltraps>

801064f8 <vector57>:
.globl vector57
vector57:
  pushl $0
801064f8:	6a 00                	push   $0x0
  pushl $57
801064fa:	6a 39                	push   $0x39
  jmp alltraps
801064fc:	e9 1f f9 ff ff       	jmp    80105e20 <alltraps>

80106501 <vector58>:
.globl vector58
vector58:
  pushl $0
80106501:	6a 00                	push   $0x0
  pushl $58
80106503:	6a 3a                	push   $0x3a
  jmp alltraps
80106505:	e9 16 f9 ff ff       	jmp    80105e20 <alltraps>

8010650a <vector59>:
.globl vector59
vector59:
  pushl $0
8010650a:	6a 00                	push   $0x0
  pushl $59
8010650c:	6a 3b                	push   $0x3b
  jmp alltraps
8010650e:	e9 0d f9 ff ff       	jmp    80105e20 <alltraps>

80106513 <vector60>:
.globl vector60
vector60:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $60
80106515:	6a 3c                	push   $0x3c
  jmp alltraps
80106517:	e9 04 f9 ff ff       	jmp    80105e20 <alltraps>

8010651c <vector61>:
.globl vector61
vector61:
  pushl $0
8010651c:	6a 00                	push   $0x0
  pushl $61
8010651e:	6a 3d                	push   $0x3d
  jmp alltraps
80106520:	e9 fb f8 ff ff       	jmp    80105e20 <alltraps>

80106525 <vector62>:
.globl vector62
vector62:
  pushl $0
80106525:	6a 00                	push   $0x0
  pushl $62
80106527:	6a 3e                	push   $0x3e
  jmp alltraps
80106529:	e9 f2 f8 ff ff       	jmp    80105e20 <alltraps>

8010652e <vector63>:
.globl vector63
vector63:
  pushl $0
8010652e:	6a 00                	push   $0x0
  pushl $63
80106530:	6a 3f                	push   $0x3f
  jmp alltraps
80106532:	e9 e9 f8 ff ff       	jmp    80105e20 <alltraps>

80106537 <vector64>:
.globl vector64
vector64:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $64
80106539:	6a 40                	push   $0x40
  jmp alltraps
8010653b:	e9 e0 f8 ff ff       	jmp    80105e20 <alltraps>

80106540 <vector65>:
.globl vector65
vector65:
  pushl $0
80106540:	6a 00                	push   $0x0
  pushl $65
80106542:	6a 41                	push   $0x41
  jmp alltraps
80106544:	e9 d7 f8 ff ff       	jmp    80105e20 <alltraps>

80106549 <vector66>:
.globl vector66
vector66:
  pushl $0
80106549:	6a 00                	push   $0x0
  pushl $66
8010654b:	6a 42                	push   $0x42
  jmp alltraps
8010654d:	e9 ce f8 ff ff       	jmp    80105e20 <alltraps>

80106552 <vector67>:
.globl vector67
vector67:
  pushl $0
80106552:	6a 00                	push   $0x0
  pushl $67
80106554:	6a 43                	push   $0x43
  jmp alltraps
80106556:	e9 c5 f8 ff ff       	jmp    80105e20 <alltraps>

8010655b <vector68>:
.globl vector68
vector68:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $68
8010655d:	6a 44                	push   $0x44
  jmp alltraps
8010655f:	e9 bc f8 ff ff       	jmp    80105e20 <alltraps>

80106564 <vector69>:
.globl vector69
vector69:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $69
80106566:	6a 45                	push   $0x45
  jmp alltraps
80106568:	e9 b3 f8 ff ff       	jmp    80105e20 <alltraps>

8010656d <vector70>:
.globl vector70
vector70:
  pushl $0
8010656d:	6a 00                	push   $0x0
  pushl $70
8010656f:	6a 46                	push   $0x46
  jmp alltraps
80106571:	e9 aa f8 ff ff       	jmp    80105e20 <alltraps>

80106576 <vector71>:
.globl vector71
vector71:
  pushl $0
80106576:	6a 00                	push   $0x0
  pushl $71
80106578:	6a 47                	push   $0x47
  jmp alltraps
8010657a:	e9 a1 f8 ff ff       	jmp    80105e20 <alltraps>

8010657f <vector72>:
.globl vector72
vector72:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $72
80106581:	6a 48                	push   $0x48
  jmp alltraps
80106583:	e9 98 f8 ff ff       	jmp    80105e20 <alltraps>

80106588 <vector73>:
.globl vector73
vector73:
  pushl $0
80106588:	6a 00                	push   $0x0
  pushl $73
8010658a:	6a 49                	push   $0x49
  jmp alltraps
8010658c:	e9 8f f8 ff ff       	jmp    80105e20 <alltraps>

80106591 <vector74>:
.globl vector74
vector74:
  pushl $0
80106591:	6a 00                	push   $0x0
  pushl $74
80106593:	6a 4a                	push   $0x4a
  jmp alltraps
80106595:	e9 86 f8 ff ff       	jmp    80105e20 <alltraps>

8010659a <vector75>:
.globl vector75
vector75:
  pushl $0
8010659a:	6a 00                	push   $0x0
  pushl $75
8010659c:	6a 4b                	push   $0x4b
  jmp alltraps
8010659e:	e9 7d f8 ff ff       	jmp    80105e20 <alltraps>

801065a3 <vector76>:
.globl vector76
vector76:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $76
801065a5:	6a 4c                	push   $0x4c
  jmp alltraps
801065a7:	e9 74 f8 ff ff       	jmp    80105e20 <alltraps>

801065ac <vector77>:
.globl vector77
vector77:
  pushl $0
801065ac:	6a 00                	push   $0x0
  pushl $77
801065ae:	6a 4d                	push   $0x4d
  jmp alltraps
801065b0:	e9 6b f8 ff ff       	jmp    80105e20 <alltraps>

801065b5 <vector78>:
.globl vector78
vector78:
  pushl $0
801065b5:	6a 00                	push   $0x0
  pushl $78
801065b7:	6a 4e                	push   $0x4e
  jmp alltraps
801065b9:	e9 62 f8 ff ff       	jmp    80105e20 <alltraps>

801065be <vector79>:
.globl vector79
vector79:
  pushl $0
801065be:	6a 00                	push   $0x0
  pushl $79
801065c0:	6a 4f                	push   $0x4f
  jmp alltraps
801065c2:	e9 59 f8 ff ff       	jmp    80105e20 <alltraps>

801065c7 <vector80>:
.globl vector80
vector80:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $80
801065c9:	6a 50                	push   $0x50
  jmp alltraps
801065cb:	e9 50 f8 ff ff       	jmp    80105e20 <alltraps>

801065d0 <vector81>:
.globl vector81
vector81:
  pushl $0
801065d0:	6a 00                	push   $0x0
  pushl $81
801065d2:	6a 51                	push   $0x51
  jmp alltraps
801065d4:	e9 47 f8 ff ff       	jmp    80105e20 <alltraps>

801065d9 <vector82>:
.globl vector82
vector82:
  pushl $0
801065d9:	6a 00                	push   $0x0
  pushl $82
801065db:	6a 52                	push   $0x52
  jmp alltraps
801065dd:	e9 3e f8 ff ff       	jmp    80105e20 <alltraps>

801065e2 <vector83>:
.globl vector83
vector83:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $83
801065e4:	6a 53                	push   $0x53
  jmp alltraps
801065e6:	e9 35 f8 ff ff       	jmp    80105e20 <alltraps>

801065eb <vector84>:
.globl vector84
vector84:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $84
801065ed:	6a 54                	push   $0x54
  jmp alltraps
801065ef:	e9 2c f8 ff ff       	jmp    80105e20 <alltraps>

801065f4 <vector85>:
.globl vector85
vector85:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $85
801065f6:	6a 55                	push   $0x55
  jmp alltraps
801065f8:	e9 23 f8 ff ff       	jmp    80105e20 <alltraps>

801065fd <vector86>:
.globl vector86
vector86:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $86
801065ff:	6a 56                	push   $0x56
  jmp alltraps
80106601:	e9 1a f8 ff ff       	jmp    80105e20 <alltraps>

80106606 <vector87>:
.globl vector87
vector87:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $87
80106608:	6a 57                	push   $0x57
  jmp alltraps
8010660a:	e9 11 f8 ff ff       	jmp    80105e20 <alltraps>

8010660f <vector88>:
.globl vector88
vector88:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $88
80106611:	6a 58                	push   $0x58
  jmp alltraps
80106613:	e9 08 f8 ff ff       	jmp    80105e20 <alltraps>

80106618 <vector89>:
.globl vector89
vector89:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $89
8010661a:	6a 59                	push   $0x59
  jmp alltraps
8010661c:	e9 ff f7 ff ff       	jmp    80105e20 <alltraps>

80106621 <vector90>:
.globl vector90
vector90:
  pushl $0
80106621:	6a 00                	push   $0x0
  pushl $90
80106623:	6a 5a                	push   $0x5a
  jmp alltraps
80106625:	e9 f6 f7 ff ff       	jmp    80105e20 <alltraps>

8010662a <vector91>:
.globl vector91
vector91:
  pushl $0
8010662a:	6a 00                	push   $0x0
  pushl $91
8010662c:	6a 5b                	push   $0x5b
  jmp alltraps
8010662e:	e9 ed f7 ff ff       	jmp    80105e20 <alltraps>

80106633 <vector92>:
.globl vector92
vector92:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $92
80106635:	6a 5c                	push   $0x5c
  jmp alltraps
80106637:	e9 e4 f7 ff ff       	jmp    80105e20 <alltraps>

8010663c <vector93>:
.globl vector93
vector93:
  pushl $0
8010663c:	6a 00                	push   $0x0
  pushl $93
8010663e:	6a 5d                	push   $0x5d
  jmp alltraps
80106640:	e9 db f7 ff ff       	jmp    80105e20 <alltraps>

80106645 <vector94>:
.globl vector94
vector94:
  pushl $0
80106645:	6a 00                	push   $0x0
  pushl $94
80106647:	6a 5e                	push   $0x5e
  jmp alltraps
80106649:	e9 d2 f7 ff ff       	jmp    80105e20 <alltraps>

8010664e <vector95>:
.globl vector95
vector95:
  pushl $0
8010664e:	6a 00                	push   $0x0
  pushl $95
80106650:	6a 5f                	push   $0x5f
  jmp alltraps
80106652:	e9 c9 f7 ff ff       	jmp    80105e20 <alltraps>

80106657 <vector96>:
.globl vector96
vector96:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $96
80106659:	6a 60                	push   $0x60
  jmp alltraps
8010665b:	e9 c0 f7 ff ff       	jmp    80105e20 <alltraps>

80106660 <vector97>:
.globl vector97
vector97:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $97
80106662:	6a 61                	push   $0x61
  jmp alltraps
80106664:	e9 b7 f7 ff ff       	jmp    80105e20 <alltraps>

80106669 <vector98>:
.globl vector98
vector98:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $98
8010666b:	6a 62                	push   $0x62
  jmp alltraps
8010666d:	e9 ae f7 ff ff       	jmp    80105e20 <alltraps>

80106672 <vector99>:
.globl vector99
vector99:
  pushl $0
80106672:	6a 00                	push   $0x0
  pushl $99
80106674:	6a 63                	push   $0x63
  jmp alltraps
80106676:	e9 a5 f7 ff ff       	jmp    80105e20 <alltraps>

8010667b <vector100>:
.globl vector100
vector100:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $100
8010667d:	6a 64                	push   $0x64
  jmp alltraps
8010667f:	e9 9c f7 ff ff       	jmp    80105e20 <alltraps>

80106684 <vector101>:
.globl vector101
vector101:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $101
80106686:	6a 65                	push   $0x65
  jmp alltraps
80106688:	e9 93 f7 ff ff       	jmp    80105e20 <alltraps>

8010668d <vector102>:
.globl vector102
vector102:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $102
8010668f:	6a 66                	push   $0x66
  jmp alltraps
80106691:	e9 8a f7 ff ff       	jmp    80105e20 <alltraps>

80106696 <vector103>:
.globl vector103
vector103:
  pushl $0
80106696:	6a 00                	push   $0x0
  pushl $103
80106698:	6a 67                	push   $0x67
  jmp alltraps
8010669a:	e9 81 f7 ff ff       	jmp    80105e20 <alltraps>

8010669f <vector104>:
.globl vector104
vector104:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $104
801066a1:	6a 68                	push   $0x68
  jmp alltraps
801066a3:	e9 78 f7 ff ff       	jmp    80105e20 <alltraps>

801066a8 <vector105>:
.globl vector105
vector105:
  pushl $0
801066a8:	6a 00                	push   $0x0
  pushl $105
801066aa:	6a 69                	push   $0x69
  jmp alltraps
801066ac:	e9 6f f7 ff ff       	jmp    80105e20 <alltraps>

801066b1 <vector106>:
.globl vector106
vector106:
  pushl $0
801066b1:	6a 00                	push   $0x0
  pushl $106
801066b3:	6a 6a                	push   $0x6a
  jmp alltraps
801066b5:	e9 66 f7 ff ff       	jmp    80105e20 <alltraps>

801066ba <vector107>:
.globl vector107
vector107:
  pushl $0
801066ba:	6a 00                	push   $0x0
  pushl $107
801066bc:	6a 6b                	push   $0x6b
  jmp alltraps
801066be:	e9 5d f7 ff ff       	jmp    80105e20 <alltraps>

801066c3 <vector108>:
.globl vector108
vector108:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $108
801066c5:	6a 6c                	push   $0x6c
  jmp alltraps
801066c7:	e9 54 f7 ff ff       	jmp    80105e20 <alltraps>

801066cc <vector109>:
.globl vector109
vector109:
  pushl $0
801066cc:	6a 00                	push   $0x0
  pushl $109
801066ce:	6a 6d                	push   $0x6d
  jmp alltraps
801066d0:	e9 4b f7 ff ff       	jmp    80105e20 <alltraps>

801066d5 <vector110>:
.globl vector110
vector110:
  pushl $0
801066d5:	6a 00                	push   $0x0
  pushl $110
801066d7:	6a 6e                	push   $0x6e
  jmp alltraps
801066d9:	e9 42 f7 ff ff       	jmp    80105e20 <alltraps>

801066de <vector111>:
.globl vector111
vector111:
  pushl $0
801066de:	6a 00                	push   $0x0
  pushl $111
801066e0:	6a 6f                	push   $0x6f
  jmp alltraps
801066e2:	e9 39 f7 ff ff       	jmp    80105e20 <alltraps>

801066e7 <vector112>:
.globl vector112
vector112:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $112
801066e9:	6a 70                	push   $0x70
  jmp alltraps
801066eb:	e9 30 f7 ff ff       	jmp    80105e20 <alltraps>

801066f0 <vector113>:
.globl vector113
vector113:
  pushl $0
801066f0:	6a 00                	push   $0x0
  pushl $113
801066f2:	6a 71                	push   $0x71
  jmp alltraps
801066f4:	e9 27 f7 ff ff       	jmp    80105e20 <alltraps>

801066f9 <vector114>:
.globl vector114
vector114:
  pushl $0
801066f9:	6a 00                	push   $0x0
  pushl $114
801066fb:	6a 72                	push   $0x72
  jmp alltraps
801066fd:	e9 1e f7 ff ff       	jmp    80105e20 <alltraps>

80106702 <vector115>:
.globl vector115
vector115:
  pushl $0
80106702:	6a 00                	push   $0x0
  pushl $115
80106704:	6a 73                	push   $0x73
  jmp alltraps
80106706:	e9 15 f7 ff ff       	jmp    80105e20 <alltraps>

8010670b <vector116>:
.globl vector116
vector116:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $116
8010670d:	6a 74                	push   $0x74
  jmp alltraps
8010670f:	e9 0c f7 ff ff       	jmp    80105e20 <alltraps>

80106714 <vector117>:
.globl vector117
vector117:
  pushl $0
80106714:	6a 00                	push   $0x0
  pushl $117
80106716:	6a 75                	push   $0x75
  jmp alltraps
80106718:	e9 03 f7 ff ff       	jmp    80105e20 <alltraps>

8010671d <vector118>:
.globl vector118
vector118:
  pushl $0
8010671d:	6a 00                	push   $0x0
  pushl $118
8010671f:	6a 76                	push   $0x76
  jmp alltraps
80106721:	e9 fa f6 ff ff       	jmp    80105e20 <alltraps>

80106726 <vector119>:
.globl vector119
vector119:
  pushl $0
80106726:	6a 00                	push   $0x0
  pushl $119
80106728:	6a 77                	push   $0x77
  jmp alltraps
8010672a:	e9 f1 f6 ff ff       	jmp    80105e20 <alltraps>

8010672f <vector120>:
.globl vector120
vector120:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $120
80106731:	6a 78                	push   $0x78
  jmp alltraps
80106733:	e9 e8 f6 ff ff       	jmp    80105e20 <alltraps>

80106738 <vector121>:
.globl vector121
vector121:
  pushl $0
80106738:	6a 00                	push   $0x0
  pushl $121
8010673a:	6a 79                	push   $0x79
  jmp alltraps
8010673c:	e9 df f6 ff ff       	jmp    80105e20 <alltraps>

80106741 <vector122>:
.globl vector122
vector122:
  pushl $0
80106741:	6a 00                	push   $0x0
  pushl $122
80106743:	6a 7a                	push   $0x7a
  jmp alltraps
80106745:	e9 d6 f6 ff ff       	jmp    80105e20 <alltraps>

8010674a <vector123>:
.globl vector123
vector123:
  pushl $0
8010674a:	6a 00                	push   $0x0
  pushl $123
8010674c:	6a 7b                	push   $0x7b
  jmp alltraps
8010674e:	e9 cd f6 ff ff       	jmp    80105e20 <alltraps>

80106753 <vector124>:
.globl vector124
vector124:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $124
80106755:	6a 7c                	push   $0x7c
  jmp alltraps
80106757:	e9 c4 f6 ff ff       	jmp    80105e20 <alltraps>

8010675c <vector125>:
.globl vector125
vector125:
  pushl $0
8010675c:	6a 00                	push   $0x0
  pushl $125
8010675e:	6a 7d                	push   $0x7d
  jmp alltraps
80106760:	e9 bb f6 ff ff       	jmp    80105e20 <alltraps>

80106765 <vector126>:
.globl vector126
vector126:
  pushl $0
80106765:	6a 00                	push   $0x0
  pushl $126
80106767:	6a 7e                	push   $0x7e
  jmp alltraps
80106769:	e9 b2 f6 ff ff       	jmp    80105e20 <alltraps>

8010676e <vector127>:
.globl vector127
vector127:
  pushl $0
8010676e:	6a 00                	push   $0x0
  pushl $127
80106770:	6a 7f                	push   $0x7f
  jmp alltraps
80106772:	e9 a9 f6 ff ff       	jmp    80105e20 <alltraps>

80106777 <vector128>:
.globl vector128
vector128:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $128
80106779:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010677e:	e9 9d f6 ff ff       	jmp    80105e20 <alltraps>

80106783 <vector129>:
.globl vector129
vector129:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $129
80106785:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010678a:	e9 91 f6 ff ff       	jmp    80105e20 <alltraps>

8010678f <vector130>:
.globl vector130
vector130:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $130
80106791:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106796:	e9 85 f6 ff ff       	jmp    80105e20 <alltraps>

8010679b <vector131>:
.globl vector131
vector131:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $131
8010679d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801067a2:	e9 79 f6 ff ff       	jmp    80105e20 <alltraps>

801067a7 <vector132>:
.globl vector132
vector132:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $132
801067a9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801067ae:	e9 6d f6 ff ff       	jmp    80105e20 <alltraps>

801067b3 <vector133>:
.globl vector133
vector133:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $133
801067b5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801067ba:	e9 61 f6 ff ff       	jmp    80105e20 <alltraps>

801067bf <vector134>:
.globl vector134
vector134:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $134
801067c1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801067c6:	e9 55 f6 ff ff       	jmp    80105e20 <alltraps>

801067cb <vector135>:
.globl vector135
vector135:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $135
801067cd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801067d2:	e9 49 f6 ff ff       	jmp    80105e20 <alltraps>

801067d7 <vector136>:
.globl vector136
vector136:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $136
801067d9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801067de:	e9 3d f6 ff ff       	jmp    80105e20 <alltraps>

801067e3 <vector137>:
.globl vector137
vector137:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $137
801067e5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801067ea:	e9 31 f6 ff ff       	jmp    80105e20 <alltraps>

801067ef <vector138>:
.globl vector138
vector138:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $138
801067f1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801067f6:	e9 25 f6 ff ff       	jmp    80105e20 <alltraps>

801067fb <vector139>:
.globl vector139
vector139:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $139
801067fd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106802:	e9 19 f6 ff ff       	jmp    80105e20 <alltraps>

80106807 <vector140>:
.globl vector140
vector140:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $140
80106809:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010680e:	e9 0d f6 ff ff       	jmp    80105e20 <alltraps>

80106813 <vector141>:
.globl vector141
vector141:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $141
80106815:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010681a:	e9 01 f6 ff ff       	jmp    80105e20 <alltraps>

8010681f <vector142>:
.globl vector142
vector142:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $142
80106821:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106826:	e9 f5 f5 ff ff       	jmp    80105e20 <alltraps>

8010682b <vector143>:
.globl vector143
vector143:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $143
8010682d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106832:	e9 e9 f5 ff ff       	jmp    80105e20 <alltraps>

80106837 <vector144>:
.globl vector144
vector144:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $144
80106839:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010683e:	e9 dd f5 ff ff       	jmp    80105e20 <alltraps>

80106843 <vector145>:
.globl vector145
vector145:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $145
80106845:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010684a:	e9 d1 f5 ff ff       	jmp    80105e20 <alltraps>

8010684f <vector146>:
.globl vector146
vector146:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $146
80106851:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106856:	e9 c5 f5 ff ff       	jmp    80105e20 <alltraps>

8010685b <vector147>:
.globl vector147
vector147:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $147
8010685d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106862:	e9 b9 f5 ff ff       	jmp    80105e20 <alltraps>

80106867 <vector148>:
.globl vector148
vector148:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $148
80106869:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010686e:	e9 ad f5 ff ff       	jmp    80105e20 <alltraps>

80106873 <vector149>:
.globl vector149
vector149:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $149
80106875:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010687a:	e9 a1 f5 ff ff       	jmp    80105e20 <alltraps>

8010687f <vector150>:
.globl vector150
vector150:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $150
80106881:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106886:	e9 95 f5 ff ff       	jmp    80105e20 <alltraps>

8010688b <vector151>:
.globl vector151
vector151:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $151
8010688d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106892:	e9 89 f5 ff ff       	jmp    80105e20 <alltraps>

80106897 <vector152>:
.globl vector152
vector152:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $152
80106899:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010689e:	e9 7d f5 ff ff       	jmp    80105e20 <alltraps>

801068a3 <vector153>:
.globl vector153
vector153:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $153
801068a5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801068aa:	e9 71 f5 ff ff       	jmp    80105e20 <alltraps>

801068af <vector154>:
.globl vector154
vector154:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $154
801068b1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801068b6:	e9 65 f5 ff ff       	jmp    80105e20 <alltraps>

801068bb <vector155>:
.globl vector155
vector155:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $155
801068bd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801068c2:	e9 59 f5 ff ff       	jmp    80105e20 <alltraps>

801068c7 <vector156>:
.globl vector156
vector156:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $156
801068c9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801068ce:	e9 4d f5 ff ff       	jmp    80105e20 <alltraps>

801068d3 <vector157>:
.globl vector157
vector157:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $157
801068d5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801068da:	e9 41 f5 ff ff       	jmp    80105e20 <alltraps>

801068df <vector158>:
.globl vector158
vector158:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $158
801068e1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801068e6:	e9 35 f5 ff ff       	jmp    80105e20 <alltraps>

801068eb <vector159>:
.globl vector159
vector159:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $159
801068ed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801068f2:	e9 29 f5 ff ff       	jmp    80105e20 <alltraps>

801068f7 <vector160>:
.globl vector160
vector160:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $160
801068f9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801068fe:	e9 1d f5 ff ff       	jmp    80105e20 <alltraps>

80106903 <vector161>:
.globl vector161
vector161:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $161
80106905:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010690a:	e9 11 f5 ff ff       	jmp    80105e20 <alltraps>

8010690f <vector162>:
.globl vector162
vector162:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $162
80106911:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106916:	e9 05 f5 ff ff       	jmp    80105e20 <alltraps>

8010691b <vector163>:
.globl vector163
vector163:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $163
8010691d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106922:	e9 f9 f4 ff ff       	jmp    80105e20 <alltraps>

80106927 <vector164>:
.globl vector164
vector164:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $164
80106929:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010692e:	e9 ed f4 ff ff       	jmp    80105e20 <alltraps>

80106933 <vector165>:
.globl vector165
vector165:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $165
80106935:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010693a:	e9 e1 f4 ff ff       	jmp    80105e20 <alltraps>

8010693f <vector166>:
.globl vector166
vector166:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $166
80106941:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106946:	e9 d5 f4 ff ff       	jmp    80105e20 <alltraps>

8010694b <vector167>:
.globl vector167
vector167:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $167
8010694d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106952:	e9 c9 f4 ff ff       	jmp    80105e20 <alltraps>

80106957 <vector168>:
.globl vector168
vector168:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $168
80106959:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010695e:	e9 bd f4 ff ff       	jmp    80105e20 <alltraps>

80106963 <vector169>:
.globl vector169
vector169:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $169
80106965:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010696a:	e9 b1 f4 ff ff       	jmp    80105e20 <alltraps>

8010696f <vector170>:
.globl vector170
vector170:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $170
80106971:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106976:	e9 a5 f4 ff ff       	jmp    80105e20 <alltraps>

8010697b <vector171>:
.globl vector171
vector171:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $171
8010697d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106982:	e9 99 f4 ff ff       	jmp    80105e20 <alltraps>

80106987 <vector172>:
.globl vector172
vector172:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $172
80106989:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010698e:	e9 8d f4 ff ff       	jmp    80105e20 <alltraps>

80106993 <vector173>:
.globl vector173
vector173:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $173
80106995:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010699a:	e9 81 f4 ff ff       	jmp    80105e20 <alltraps>

8010699f <vector174>:
.globl vector174
vector174:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $174
801069a1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801069a6:	e9 75 f4 ff ff       	jmp    80105e20 <alltraps>

801069ab <vector175>:
.globl vector175
vector175:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $175
801069ad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801069b2:	e9 69 f4 ff ff       	jmp    80105e20 <alltraps>

801069b7 <vector176>:
.globl vector176
vector176:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $176
801069b9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801069be:	e9 5d f4 ff ff       	jmp    80105e20 <alltraps>

801069c3 <vector177>:
.globl vector177
vector177:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $177
801069c5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801069ca:	e9 51 f4 ff ff       	jmp    80105e20 <alltraps>

801069cf <vector178>:
.globl vector178
vector178:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $178
801069d1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801069d6:	e9 45 f4 ff ff       	jmp    80105e20 <alltraps>

801069db <vector179>:
.globl vector179
vector179:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $179
801069dd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801069e2:	e9 39 f4 ff ff       	jmp    80105e20 <alltraps>

801069e7 <vector180>:
.globl vector180
vector180:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $180
801069e9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801069ee:	e9 2d f4 ff ff       	jmp    80105e20 <alltraps>

801069f3 <vector181>:
.globl vector181
vector181:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $181
801069f5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801069fa:	e9 21 f4 ff ff       	jmp    80105e20 <alltraps>

801069ff <vector182>:
.globl vector182
vector182:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $182
80106a01:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106a06:	e9 15 f4 ff ff       	jmp    80105e20 <alltraps>

80106a0b <vector183>:
.globl vector183
vector183:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $183
80106a0d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106a12:	e9 09 f4 ff ff       	jmp    80105e20 <alltraps>

80106a17 <vector184>:
.globl vector184
vector184:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $184
80106a19:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106a1e:	e9 fd f3 ff ff       	jmp    80105e20 <alltraps>

80106a23 <vector185>:
.globl vector185
vector185:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $185
80106a25:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106a2a:	e9 f1 f3 ff ff       	jmp    80105e20 <alltraps>

80106a2f <vector186>:
.globl vector186
vector186:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $186
80106a31:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106a36:	e9 e5 f3 ff ff       	jmp    80105e20 <alltraps>

80106a3b <vector187>:
.globl vector187
vector187:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $187
80106a3d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106a42:	e9 d9 f3 ff ff       	jmp    80105e20 <alltraps>

80106a47 <vector188>:
.globl vector188
vector188:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $188
80106a49:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106a4e:	e9 cd f3 ff ff       	jmp    80105e20 <alltraps>

80106a53 <vector189>:
.globl vector189
vector189:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $189
80106a55:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106a5a:	e9 c1 f3 ff ff       	jmp    80105e20 <alltraps>

80106a5f <vector190>:
.globl vector190
vector190:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $190
80106a61:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106a66:	e9 b5 f3 ff ff       	jmp    80105e20 <alltraps>

80106a6b <vector191>:
.globl vector191
vector191:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $191
80106a6d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106a72:	e9 a9 f3 ff ff       	jmp    80105e20 <alltraps>

80106a77 <vector192>:
.globl vector192
vector192:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $192
80106a79:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106a7e:	e9 9d f3 ff ff       	jmp    80105e20 <alltraps>

80106a83 <vector193>:
.globl vector193
vector193:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $193
80106a85:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106a8a:	e9 91 f3 ff ff       	jmp    80105e20 <alltraps>

80106a8f <vector194>:
.globl vector194
vector194:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $194
80106a91:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106a96:	e9 85 f3 ff ff       	jmp    80105e20 <alltraps>

80106a9b <vector195>:
.globl vector195
vector195:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $195
80106a9d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106aa2:	e9 79 f3 ff ff       	jmp    80105e20 <alltraps>

80106aa7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $196
80106aa9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106aae:	e9 6d f3 ff ff       	jmp    80105e20 <alltraps>

80106ab3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $197
80106ab5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106aba:	e9 61 f3 ff ff       	jmp    80105e20 <alltraps>

80106abf <vector198>:
.globl vector198
vector198:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $198
80106ac1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106ac6:	e9 55 f3 ff ff       	jmp    80105e20 <alltraps>

80106acb <vector199>:
.globl vector199
vector199:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $199
80106acd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106ad2:	e9 49 f3 ff ff       	jmp    80105e20 <alltraps>

80106ad7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $200
80106ad9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106ade:	e9 3d f3 ff ff       	jmp    80105e20 <alltraps>

80106ae3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $201
80106ae5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106aea:	e9 31 f3 ff ff       	jmp    80105e20 <alltraps>

80106aef <vector202>:
.globl vector202
vector202:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $202
80106af1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106af6:	e9 25 f3 ff ff       	jmp    80105e20 <alltraps>

80106afb <vector203>:
.globl vector203
vector203:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $203
80106afd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106b02:	e9 19 f3 ff ff       	jmp    80105e20 <alltraps>

80106b07 <vector204>:
.globl vector204
vector204:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $204
80106b09:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106b0e:	e9 0d f3 ff ff       	jmp    80105e20 <alltraps>

80106b13 <vector205>:
.globl vector205
vector205:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $205
80106b15:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106b1a:	e9 01 f3 ff ff       	jmp    80105e20 <alltraps>

80106b1f <vector206>:
.globl vector206
vector206:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $206
80106b21:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106b26:	e9 f5 f2 ff ff       	jmp    80105e20 <alltraps>

80106b2b <vector207>:
.globl vector207
vector207:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $207
80106b2d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106b32:	e9 e9 f2 ff ff       	jmp    80105e20 <alltraps>

80106b37 <vector208>:
.globl vector208
vector208:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $208
80106b39:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106b3e:	e9 dd f2 ff ff       	jmp    80105e20 <alltraps>

80106b43 <vector209>:
.globl vector209
vector209:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $209
80106b45:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106b4a:	e9 d1 f2 ff ff       	jmp    80105e20 <alltraps>

80106b4f <vector210>:
.globl vector210
vector210:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $210
80106b51:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106b56:	e9 c5 f2 ff ff       	jmp    80105e20 <alltraps>

80106b5b <vector211>:
.globl vector211
vector211:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $211
80106b5d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106b62:	e9 b9 f2 ff ff       	jmp    80105e20 <alltraps>

80106b67 <vector212>:
.globl vector212
vector212:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $212
80106b69:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106b6e:	e9 ad f2 ff ff       	jmp    80105e20 <alltraps>

80106b73 <vector213>:
.globl vector213
vector213:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $213
80106b75:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106b7a:	e9 a1 f2 ff ff       	jmp    80105e20 <alltraps>

80106b7f <vector214>:
.globl vector214
vector214:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $214
80106b81:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106b86:	e9 95 f2 ff ff       	jmp    80105e20 <alltraps>

80106b8b <vector215>:
.globl vector215
vector215:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $215
80106b8d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106b92:	e9 89 f2 ff ff       	jmp    80105e20 <alltraps>

80106b97 <vector216>:
.globl vector216
vector216:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $216
80106b99:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106b9e:	e9 7d f2 ff ff       	jmp    80105e20 <alltraps>

80106ba3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $217
80106ba5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106baa:	e9 71 f2 ff ff       	jmp    80105e20 <alltraps>

80106baf <vector218>:
.globl vector218
vector218:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $218
80106bb1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106bb6:	e9 65 f2 ff ff       	jmp    80105e20 <alltraps>

80106bbb <vector219>:
.globl vector219
vector219:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $219
80106bbd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106bc2:	e9 59 f2 ff ff       	jmp    80105e20 <alltraps>

80106bc7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $220
80106bc9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106bce:	e9 4d f2 ff ff       	jmp    80105e20 <alltraps>

80106bd3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $221
80106bd5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106bda:	e9 41 f2 ff ff       	jmp    80105e20 <alltraps>

80106bdf <vector222>:
.globl vector222
vector222:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $222
80106be1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106be6:	e9 35 f2 ff ff       	jmp    80105e20 <alltraps>

80106beb <vector223>:
.globl vector223
vector223:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $223
80106bed:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106bf2:	e9 29 f2 ff ff       	jmp    80105e20 <alltraps>

80106bf7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $224
80106bf9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106bfe:	e9 1d f2 ff ff       	jmp    80105e20 <alltraps>

80106c03 <vector225>:
.globl vector225
vector225:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $225
80106c05:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106c0a:	e9 11 f2 ff ff       	jmp    80105e20 <alltraps>

80106c0f <vector226>:
.globl vector226
vector226:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $226
80106c11:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106c16:	e9 05 f2 ff ff       	jmp    80105e20 <alltraps>

80106c1b <vector227>:
.globl vector227
vector227:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $227
80106c1d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106c22:	e9 f9 f1 ff ff       	jmp    80105e20 <alltraps>

80106c27 <vector228>:
.globl vector228
vector228:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $228
80106c29:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106c2e:	e9 ed f1 ff ff       	jmp    80105e20 <alltraps>

80106c33 <vector229>:
.globl vector229
vector229:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $229
80106c35:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106c3a:	e9 e1 f1 ff ff       	jmp    80105e20 <alltraps>

80106c3f <vector230>:
.globl vector230
vector230:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $230
80106c41:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106c46:	e9 d5 f1 ff ff       	jmp    80105e20 <alltraps>

80106c4b <vector231>:
.globl vector231
vector231:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $231
80106c4d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106c52:	e9 c9 f1 ff ff       	jmp    80105e20 <alltraps>

80106c57 <vector232>:
.globl vector232
vector232:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $232
80106c59:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106c5e:	e9 bd f1 ff ff       	jmp    80105e20 <alltraps>

80106c63 <vector233>:
.globl vector233
vector233:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $233
80106c65:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106c6a:	e9 b1 f1 ff ff       	jmp    80105e20 <alltraps>

80106c6f <vector234>:
.globl vector234
vector234:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $234
80106c71:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106c76:	e9 a5 f1 ff ff       	jmp    80105e20 <alltraps>

80106c7b <vector235>:
.globl vector235
vector235:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $235
80106c7d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106c82:	e9 99 f1 ff ff       	jmp    80105e20 <alltraps>

80106c87 <vector236>:
.globl vector236
vector236:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $236
80106c89:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106c8e:	e9 8d f1 ff ff       	jmp    80105e20 <alltraps>

80106c93 <vector237>:
.globl vector237
vector237:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $237
80106c95:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106c9a:	e9 81 f1 ff ff       	jmp    80105e20 <alltraps>

80106c9f <vector238>:
.globl vector238
vector238:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $238
80106ca1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106ca6:	e9 75 f1 ff ff       	jmp    80105e20 <alltraps>

80106cab <vector239>:
.globl vector239
vector239:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $239
80106cad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106cb2:	e9 69 f1 ff ff       	jmp    80105e20 <alltraps>

80106cb7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $240
80106cb9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106cbe:	e9 5d f1 ff ff       	jmp    80105e20 <alltraps>

80106cc3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $241
80106cc5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106cca:	e9 51 f1 ff ff       	jmp    80105e20 <alltraps>

80106ccf <vector242>:
.globl vector242
vector242:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $242
80106cd1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106cd6:	e9 45 f1 ff ff       	jmp    80105e20 <alltraps>

80106cdb <vector243>:
.globl vector243
vector243:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $243
80106cdd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ce2:	e9 39 f1 ff ff       	jmp    80105e20 <alltraps>

80106ce7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $244
80106ce9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106cee:	e9 2d f1 ff ff       	jmp    80105e20 <alltraps>

80106cf3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $245
80106cf5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106cfa:	e9 21 f1 ff ff       	jmp    80105e20 <alltraps>

80106cff <vector246>:
.globl vector246
vector246:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $246
80106d01:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106d06:	e9 15 f1 ff ff       	jmp    80105e20 <alltraps>

80106d0b <vector247>:
.globl vector247
vector247:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $247
80106d0d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106d12:	e9 09 f1 ff ff       	jmp    80105e20 <alltraps>

80106d17 <vector248>:
.globl vector248
vector248:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $248
80106d19:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106d1e:	e9 fd f0 ff ff       	jmp    80105e20 <alltraps>

80106d23 <vector249>:
.globl vector249
vector249:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $249
80106d25:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106d2a:	e9 f1 f0 ff ff       	jmp    80105e20 <alltraps>

80106d2f <vector250>:
.globl vector250
vector250:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $250
80106d31:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106d36:	e9 e5 f0 ff ff       	jmp    80105e20 <alltraps>

80106d3b <vector251>:
.globl vector251
vector251:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $251
80106d3d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106d42:	e9 d9 f0 ff ff       	jmp    80105e20 <alltraps>

80106d47 <vector252>:
.globl vector252
vector252:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $252
80106d49:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106d4e:	e9 cd f0 ff ff       	jmp    80105e20 <alltraps>

80106d53 <vector253>:
.globl vector253
vector253:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $253
80106d55:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106d5a:	e9 c1 f0 ff ff       	jmp    80105e20 <alltraps>

80106d5f <vector254>:
.globl vector254
vector254:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $254
80106d61:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106d66:	e9 b5 f0 ff ff       	jmp    80105e20 <alltraps>

80106d6b <vector255>:
.globl vector255
vector255:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $255
80106d6d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106d72:	e9 a9 f0 ff ff       	jmp    80105e20 <alltraps>
80106d77:	66 90                	xchg   %ax,%ax
80106d79:	66 90                	xchg   %ax,%ax
80106d7b:	66 90                	xchg   %ax,%ax
80106d7d:	66 90                	xchg   %ax,%ax
80106d7f:	90                   	nop

80106d80 <walkpgdir>:
}

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t * walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106d80:	55                   	push   %ebp
80106d81:	89 e5                	mov    %esp,%ebp
80106d83:	57                   	push   %edi
80106d84:	56                   	push   %esi
80106d85:	53                   	push   %ebx
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
80106d86:	89 d3                	mov    %edx,%ebx
static pte_t * walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106d88:	89 d7                	mov    %edx,%edi
    pde = &pgdir[PDX(va)];
80106d8a:	c1 eb 16             	shr    $0x16,%ebx
80106d8d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
static pte_t * walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106d90:	83 ec 0c             	sub    $0xc,%esp
    if (*pde & PTE_P) {
80106d93:	8b 06                	mov    (%esi),%eax
80106d95:	a8 01                	test   $0x1,%al
80106d97:	74 27                	je     80106dc0 <walkpgdir+0x40>
        pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d99:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d9e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
        // The permissions here are overly generous, but they can
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
80106da4:	c1 ef 0a             	shr    $0xa,%edi
}
80106da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return &pgtab[PTX(va)];
80106daa:	89 fa                	mov    %edi,%edx
80106dac:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106db2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106db5:	5b                   	pop    %ebx
80106db6:	5e                   	pop    %esi
80106db7:	5f                   	pop    %edi
80106db8:	5d                   	pop    %ebp
80106db9:	c3                   	ret    
80106dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (!alloc || (pgtab = (pte_t*)kalloc()) == 0) {
80106dc0:	85 c9                	test   %ecx,%ecx
80106dc2:	74 2c                	je     80106df0 <walkpgdir+0x70>
80106dc4:	e8 b7 bd ff ff       	call   80102b80 <kalloc>
80106dc9:	85 c0                	test   %eax,%eax
80106dcb:	89 c3                	mov    %eax,%ebx
80106dcd:	74 21                	je     80106df0 <walkpgdir+0x70>
        memset(pgtab, 0, PGSIZE);
80106dcf:	83 ec 04             	sub    $0x4,%esp
80106dd2:	68 00 10 00 00       	push   $0x1000
80106dd7:	6a 00                	push   $0x0
80106dd9:	50                   	push   %eax
80106dda:	e8 61 dd ff ff       	call   80104b40 <memset>
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106ddf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106de5:	83 c4 10             	add    $0x10,%esp
80106de8:	83 c8 07             	or     $0x7,%eax
80106deb:	89 06                	mov    %eax,(%esi)
80106ded:	eb b5                	jmp    80106da4 <walkpgdir+0x24>
80106def:	90                   	nop
}
80106df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return 0;
80106df3:	31 c0                	xor    %eax,%eax
}
80106df5:	5b                   	pop    %ebx
80106df6:	5e                   	pop    %esi
80106df7:	5f                   	pop    %edi
80106df8:	5d                   	pop    %ebp
80106df9:	c3                   	ret    
80106dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e00 <mappages>:

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	57                   	push   %edi
80106e04:	56                   	push   %esi
80106e05:	53                   	push   %ebx
    char *a, *last;
    pte_t *pte;

    a = (char*)PGROUNDDOWN((uint)va);
80106e06:	89 d3                	mov    %edx,%ebx
80106e08:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
static int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
80106e0e:	83 ec 1c             	sub    $0x1c,%esp
80106e11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e14:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106e18:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e20:	89 45 e0             	mov    %eax,-0x20(%ebp)
            return -1;
        }
        if (*pte & PTE_P) {
            panic("remap");
        }
        *pte = pa | perm | PTE_P;
80106e23:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e26:	29 df                	sub    %ebx,%edi
80106e28:	83 c8 01             	or     $0x1,%eax
80106e2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106e2e:	eb 15                	jmp    80106e45 <mappages+0x45>
        if (*pte & PTE_P) {
80106e30:	f6 00 01             	testb  $0x1,(%eax)
80106e33:	75 45                	jne    80106e7a <mappages+0x7a>
        *pte = pa | perm | PTE_P;
80106e35:	0b 75 dc             	or     -0x24(%ebp),%esi
        if (a == last) {
80106e38:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
        *pte = pa | perm | PTE_P;
80106e3b:	89 30                	mov    %esi,(%eax)
        if (a == last) {
80106e3d:	74 31                	je     80106e70 <mappages+0x70>
            break;
        }
        a += PGSIZE;
80106e3f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        if ((pte = walkpgdir(pgdir, a, 1)) == 0) {
80106e45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e48:	b9 01 00 00 00       	mov    $0x1,%ecx
80106e4d:	89 da                	mov    %ebx,%edx
80106e4f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106e52:	e8 29 ff ff ff       	call   80106d80 <walkpgdir>
80106e57:	85 c0                	test   %eax,%eax
80106e59:	75 d5                	jne    80106e30 <mappages+0x30>
        pa += PGSIZE;
    }
    return 0;
}
80106e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80106e5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e63:	5b                   	pop    %ebx
80106e64:	5e                   	pop    %esi
80106e65:	5f                   	pop    %edi
80106e66:	5d                   	pop    %ebp
80106e67:	c3                   	ret    
80106e68:	90                   	nop
80106e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106e73:	31 c0                	xor    %eax,%eax
}
80106e75:	5b                   	pop    %ebx
80106e76:	5e                   	pop    %esi
80106e77:	5f                   	pop    %edi
80106e78:	5d                   	pop    %ebp
80106e79:	c3                   	ret    
            panic("remap");
80106e7a:	83 ec 0c             	sub    $0xc,%esp
80106e7d:	68 f4 7f 10 80       	push   $0x80107ff4
80106e82:	e8 f9 95 ff ff       	call   80100480 <panic>
80106e87:	89 f6                	mov    %esi,%esi
80106e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e90 <deallocuvm.part.0>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx

    if (newsz >= oldsz) {
        return oldsz;
    }

    a = PGROUNDUP(newsz);
80106e96:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80106e9c:	89 c7                	mov    %eax,%edi
    a = PGROUNDUP(newsz);
80106e9e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80106ea4:	83 ec 1c             	sub    $0x1c,%esp
80106ea7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    for (; a  < oldsz; a += PGSIZE) {
80106eaa:	39 d3                	cmp    %edx,%ebx
80106eac:	73 66                	jae    80106f14 <deallocuvm.part.0+0x84>
80106eae:	89 d6                	mov    %edx,%esi
80106eb0:	eb 3d                	jmp    80106eef <deallocuvm.part.0+0x5f>
80106eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        pte = walkpgdir(pgdir, (char*)a, 0);
        if (!pte) {
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
        }
        else if ((*pte & PTE_P) != 0) {
80106eb8:	8b 10                	mov    (%eax),%edx
80106eba:	f6 c2 01             	test   $0x1,%dl
80106ebd:	74 26                	je     80106ee5 <deallocuvm.part.0+0x55>
            pa = PTE_ADDR(*pte);
            if (pa == 0) {
80106ebf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106ec5:	74 58                	je     80106f1f <deallocuvm.part.0+0x8f>
                panic("kfree");
            }
            char *v = P2V(pa);
            kfree(v);
80106ec7:	83 ec 0c             	sub    $0xc,%esp
            char *v = P2V(pa);
80106eca:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106ed0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            kfree(v);
80106ed3:	52                   	push   %edx
80106ed4:	e8 f7 ba ff ff       	call   801029d0 <kfree>
            *pte = 0;
80106ed9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106edc:	83 c4 10             	add    $0x10,%esp
80106edf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (; a  < oldsz; a += PGSIZE) {
80106ee5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106eeb:	39 f3                	cmp    %esi,%ebx
80106eed:	73 25                	jae    80106f14 <deallocuvm.part.0+0x84>
        pte = walkpgdir(pgdir, (char*)a, 0);
80106eef:	31 c9                	xor    %ecx,%ecx
80106ef1:	89 da                	mov    %ebx,%edx
80106ef3:	89 f8                	mov    %edi,%eax
80106ef5:	e8 86 fe ff ff       	call   80106d80 <walkpgdir>
        if (!pte) {
80106efa:	85 c0                	test   %eax,%eax
80106efc:	75 ba                	jne    80106eb8 <deallocuvm.part.0+0x28>
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106efe:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106f04:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
    for (; a  < oldsz; a += PGSIZE) {
80106f0a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f10:	39 f3                	cmp    %esi,%ebx
80106f12:	72 db                	jb     80106eef <deallocuvm.part.0+0x5f>
        }
    }
    return newsz;
}
80106f14:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f17:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f1a:	5b                   	pop    %ebx
80106f1b:	5e                   	pop    %esi
80106f1c:	5f                   	pop    %edi
80106f1d:	5d                   	pop    %ebp
80106f1e:	c3                   	ret    
                panic("kfree");
80106f1f:	83 ec 0c             	sub    $0xc,%esp
80106f22:	68 46 79 10 80       	push   $0x80107946
80106f27:	e8 54 95 ff ff       	call   80100480 <panic>
80106f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f30 <seginit>:
void seginit(void) {
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	83 ec 18             	sub    $0x18,%esp
    c = &cpus[cpuid()];
80106f36:	e8 75 cf ff ff       	call   80103eb0 <cpuid>
80106f3b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
    pd[0] = size - 1;
80106f41:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106f46:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
    c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
80106f4a:	c7 80 d8 4f 11 80 ff 	movl   $0xffff,-0x7feeb028(%eax)
80106f51:	ff 00 00 
80106f54:	c7 80 dc 4f 11 80 00 	movl   $0xcf9a00,-0x7feeb024(%eax)
80106f5b:	9a cf 00 
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f5e:	c7 80 e0 4f 11 80 ff 	movl   $0xffff,-0x7feeb020(%eax)
80106f65:	ff 00 00 
80106f68:	c7 80 e4 4f 11 80 00 	movl   $0xcf9200,-0x7feeb01c(%eax)
80106f6f:	92 cf 00 
    c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
80106f72:	c7 80 e8 4f 11 80 ff 	movl   $0xffff,-0x7feeb018(%eax)
80106f79:	ff 00 00 
80106f7c:	c7 80 ec 4f 11 80 00 	movl   $0xcffa00,-0x7feeb014(%eax)
80106f83:	fa cf 00 
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f86:	c7 80 f0 4f 11 80 ff 	movl   $0xffff,-0x7feeb010(%eax)
80106f8d:	ff 00 00 
80106f90:	c7 80 f4 4f 11 80 00 	movl   $0xcff200,-0x7feeb00c(%eax)
80106f97:	f2 cf 00 
    lgdt(c->gdt, sizeof(c->gdt));
80106f9a:	05 d0 4f 11 80       	add    $0x80114fd0,%eax
    pd[1] = (uint)p;
80106f9f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
    pd[2] = (uint)p >> 16;
80106fa3:	c1 e8 10             	shr    $0x10,%eax
80106fa6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    asm volatile ("lgdt (%0)" : : "r" (pd));
80106faa:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106fad:	0f 01 10             	lgdtl  (%eax)
}
80106fb0:	c9                   	leave  
80106fb1:	c3                   	ret    
80106fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fc0 <switchkvm>:
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80106fc0:	a1 84 7c 11 80       	mov    0x80117c84,%eax
void switchkvm(void)      {
80106fc5:	55                   	push   %ebp
80106fc6:	89 e5                	mov    %esp,%ebp
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80106fc8:	05 00 00 00 80       	add    $0x80000000,%eax
    return val;
}

static inline void lcr3(uint val) {
    asm volatile ("movl %0,%%cr3" : : "r" (val));
80106fcd:	0f 22 d8             	mov    %eax,%cr3
}
80106fd0:	5d                   	pop    %ebp
80106fd1:	c3                   	ret    
80106fd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fe0 <switchuvm>:
void switchuvm(struct proc *p) {
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	57                   	push   %edi
80106fe4:	56                   	push   %esi
80106fe5:	53                   	push   %ebx
80106fe6:	83 ec 1c             	sub    $0x1c,%esp
80106fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (p == 0) {
80106fec:	85 db                	test   %ebx,%ebx
80106fee:	0f 84 cb 00 00 00    	je     801070bf <switchuvm+0xdf>
    if (p->kstack == 0) {
80106ff4:	8b 43 08             	mov    0x8(%ebx),%eax
80106ff7:	85 c0                	test   %eax,%eax
80106ff9:	0f 84 da 00 00 00    	je     801070d9 <switchuvm+0xf9>
    if (p->pgdir == 0) {
80106fff:	8b 43 04             	mov    0x4(%ebx),%eax
80107002:	85 c0                	test   %eax,%eax
80107004:	0f 84 c2 00 00 00    	je     801070cc <switchuvm+0xec>
    pushcli();
8010700a:	e8 51 d9 ff ff       	call   80104960 <pushcli>
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010700f:	e8 1c ce ff ff       	call   80103e30 <mycpu>
80107014:	89 c6                	mov    %eax,%esi
80107016:	e8 15 ce ff ff       	call   80103e30 <mycpu>
8010701b:	89 c7                	mov    %eax,%edi
8010701d:	e8 0e ce ff ff       	call   80103e30 <mycpu>
80107022:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107025:	83 c7 08             	add    $0x8,%edi
80107028:	e8 03 ce ff ff       	call   80103e30 <mycpu>
8010702d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107030:	83 c0 08             	add    $0x8,%eax
80107033:	ba 67 00 00 00       	mov    $0x67,%edx
80107038:	c1 e8 18             	shr    $0x18,%eax
8010703b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107042:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107049:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
    mycpu()->ts.iomb = (ushort) 0xFFFF;
8010704f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107054:	83 c1 08             	add    $0x8,%ecx
80107057:	c1 e9 10             	shr    $0x10,%ecx
8010705a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107060:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107065:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
8010706c:	be 10 00 00 00       	mov    $0x10,%esi
    mycpu()->gdt[SEG_TSS].s = 0;
80107071:	e8 ba cd ff ff       	call   80103e30 <mycpu>
80107076:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
8010707d:	e8 ae cd ff ff       	call   80103e30 <mycpu>
80107082:	66 89 70 10          	mov    %si,0x10(%eax)
    mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107086:	8b 73 08             	mov    0x8(%ebx),%esi
80107089:	e8 a2 cd ff ff       	call   80103e30 <mycpu>
8010708e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107094:	89 70 0c             	mov    %esi,0xc(%eax)
    mycpu()->ts.iomb = (ushort) 0xFFFF;
80107097:	e8 94 cd ff ff       	call   80103e30 <mycpu>
8010709c:	66 89 78 6e          	mov    %di,0x6e(%eax)
    asm volatile ("ltr %0" : : "r" (sel));
801070a0:	b8 28 00 00 00       	mov    $0x28,%eax
801070a5:	0f 00 d8             	ltr    %ax
    lcr3(V2P(p->pgdir));  // switch to process's address space
801070a8:	8b 43 04             	mov    0x4(%ebx),%eax
801070ab:	05 00 00 00 80       	add    $0x80000000,%eax
    asm volatile ("movl %0,%%cr3" : : "r" (val));
801070b0:	0f 22 d8             	mov    %eax,%cr3
}
801070b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070b6:	5b                   	pop    %ebx
801070b7:	5e                   	pop    %esi
801070b8:	5f                   	pop    %edi
801070b9:	5d                   	pop    %ebp
    popcli();
801070ba:	e9 e1 d8 ff ff       	jmp    801049a0 <popcli>
        panic("switchuvm: no process");
801070bf:	83 ec 0c             	sub    $0xc,%esp
801070c2:	68 fa 7f 10 80       	push   $0x80107ffa
801070c7:	e8 b4 93 ff ff       	call   80100480 <panic>
        panic("switchuvm: no pgdir");
801070cc:	83 ec 0c             	sub    $0xc,%esp
801070cf:	68 25 80 10 80       	push   $0x80108025
801070d4:	e8 a7 93 ff ff       	call   80100480 <panic>
        panic("switchuvm: no kstack");
801070d9:	83 ec 0c             	sub    $0xc,%esp
801070dc:	68 10 80 10 80       	push   $0x80108010
801070e1:	e8 9a 93 ff ff       	call   80100480 <panic>
801070e6:	8d 76 00             	lea    0x0(%esi),%esi
801070e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070f0 <inituvm>:
void inituvm(pde_t *pgdir, char *init, uint sz) {
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	57                   	push   %edi
801070f4:	56                   	push   %esi
801070f5:	53                   	push   %ebx
801070f6:	83 ec 1c             	sub    $0x1c,%esp
801070f9:	8b 75 10             	mov    0x10(%ebp),%esi
801070fc:	8b 45 08             	mov    0x8(%ebp),%eax
801070ff:	8b 7d 0c             	mov    0xc(%ebp),%edi
    if (sz >= PGSIZE) {
80107102:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
void inituvm(pde_t *pgdir, char *init, uint sz) {
80107108:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (sz >= PGSIZE) {
8010710b:	77 49                	ja     80107156 <inituvm+0x66>
    mem = kalloc();
8010710d:	e8 6e ba ff ff       	call   80102b80 <kalloc>
    memset(mem, 0, PGSIZE);
80107112:	83 ec 04             	sub    $0x4,%esp
    mem = kalloc();
80107115:	89 c3                	mov    %eax,%ebx
    memset(mem, 0, PGSIZE);
80107117:	68 00 10 00 00       	push   $0x1000
8010711c:	6a 00                	push   $0x0
8010711e:	50                   	push   %eax
8010711f:	e8 1c da ff ff       	call   80104b40 <memset>
    mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80107124:	58                   	pop    %eax
80107125:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010712b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107130:	5a                   	pop    %edx
80107131:	6a 06                	push   $0x6
80107133:	50                   	push   %eax
80107134:	31 d2                	xor    %edx,%edx
80107136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107139:	e8 c2 fc ff ff       	call   80106e00 <mappages>
    memmove(mem, init, sz);
8010713e:	89 75 10             	mov    %esi,0x10(%ebp)
80107141:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107144:	83 c4 10             	add    $0x10,%esp
80107147:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010714a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010714d:	5b                   	pop    %ebx
8010714e:	5e                   	pop    %esi
8010714f:	5f                   	pop    %edi
80107150:	5d                   	pop    %ebp
    memmove(mem, init, sz);
80107151:	e9 9a da ff ff       	jmp    80104bf0 <memmove>
        panic("inituvm: more than a page");
80107156:	83 ec 0c             	sub    $0xc,%esp
80107159:	68 39 80 10 80       	push   $0x80108039
8010715e:	e8 1d 93 ff ff       	call   80100480 <panic>
80107163:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107170 <loaduvm>:
int loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz) {
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	57                   	push   %edi
80107174:	56                   	push   %esi
80107175:	53                   	push   %ebx
80107176:	83 ec 0c             	sub    $0xc,%esp
    if ((uint) addr % PGSIZE != 0) {
80107179:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107180:	0f 85 91 00 00 00    	jne    80107217 <loaduvm+0xa7>
    for (i = 0; i < sz; i += PGSIZE) {
80107186:	8b 75 18             	mov    0x18(%ebp),%esi
80107189:	31 db                	xor    %ebx,%ebx
8010718b:	85 f6                	test   %esi,%esi
8010718d:	75 1a                	jne    801071a9 <loaduvm+0x39>
8010718f:	eb 6f                	jmp    80107200 <loaduvm+0x90>
80107191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107198:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010719e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801071a4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801071a7:	76 57                	jbe    80107200 <loaduvm+0x90>
        if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0) {
801071a9:	8b 55 0c             	mov    0xc(%ebp),%edx
801071ac:	8b 45 08             	mov    0x8(%ebp),%eax
801071af:	31 c9                	xor    %ecx,%ecx
801071b1:	01 da                	add    %ebx,%edx
801071b3:	e8 c8 fb ff ff       	call   80106d80 <walkpgdir>
801071b8:	85 c0                	test   %eax,%eax
801071ba:	74 4e                	je     8010720a <loaduvm+0x9a>
        pa = PTE_ADDR(*pte);
801071bc:	8b 00                	mov    (%eax),%eax
        if (readi(ip, P2V(pa), offset + i, n) != n) {
801071be:	8b 4d 14             	mov    0x14(%ebp),%ecx
        if (sz - i < PGSIZE) {
801071c1:	bf 00 10 00 00       	mov    $0x1000,%edi
        pa = PTE_ADDR(*pte);
801071c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        if (sz - i < PGSIZE) {
801071cb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801071d1:	0f 46 fe             	cmovbe %esi,%edi
        if (readi(ip, P2V(pa), offset + i, n) != n) {
801071d4:	01 d9                	add    %ebx,%ecx
801071d6:	05 00 00 00 80       	add    $0x80000000,%eax
801071db:	57                   	push   %edi
801071dc:	51                   	push   %ecx
801071dd:	50                   	push   %eax
801071de:	ff 75 10             	pushl  0x10(%ebp)
801071e1:	e8 3a ae ff ff       	call   80102020 <readi>
801071e6:	83 c4 10             	add    $0x10,%esp
801071e9:	39 f8                	cmp    %edi,%eax
801071eb:	74 ab                	je     80107198 <loaduvm+0x28>
}
801071ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
801071f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071f5:	5b                   	pop    %ebx
801071f6:	5e                   	pop    %esi
801071f7:	5f                   	pop    %edi
801071f8:	5d                   	pop    %ebp
801071f9:	c3                   	ret    
801071fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107200:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107203:	31 c0                	xor    %eax,%eax
}
80107205:	5b                   	pop    %ebx
80107206:	5e                   	pop    %esi
80107207:	5f                   	pop    %edi
80107208:	5d                   	pop    %ebp
80107209:	c3                   	ret    
            panic("loaduvm: address should exist");
8010720a:	83 ec 0c             	sub    $0xc,%esp
8010720d:	68 53 80 10 80       	push   $0x80108053
80107212:	e8 69 92 ff ff       	call   80100480 <panic>
        panic("loaduvm: addr must be page aligned");
80107217:	83 ec 0c             	sub    $0xc,%esp
8010721a:	68 f4 80 10 80       	push   $0x801080f4
8010721f:	e8 5c 92 ff ff       	call   80100480 <panic>
80107224:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010722a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107230 <allocuvm>:
int allocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	57                   	push   %edi
80107234:	56                   	push   %esi
80107235:	53                   	push   %ebx
80107236:	83 ec 1c             	sub    $0x1c,%esp
    if (newsz >= KERNBASE) {
80107239:	8b 7d 10             	mov    0x10(%ebp),%edi
8010723c:	85 ff                	test   %edi,%edi
8010723e:	0f 88 8e 00 00 00    	js     801072d2 <allocuvm+0xa2>
    if (newsz < oldsz) {
80107244:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107247:	0f 82 93 00 00 00    	jb     801072e0 <allocuvm+0xb0>
    a = PGROUNDUP(oldsz);
8010724d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107250:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107256:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; a < newsz; a += PGSIZE) {
8010725c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010725f:	0f 86 7e 00 00 00    	jbe    801072e3 <allocuvm+0xb3>
80107265:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107268:	8b 7d 08             	mov    0x8(%ebp),%edi
8010726b:	eb 42                	jmp    801072af <allocuvm+0x7f>
8010726d:	8d 76 00             	lea    0x0(%esi),%esi
        memset(mem, 0, PGSIZE);
80107270:	83 ec 04             	sub    $0x4,%esp
80107273:	68 00 10 00 00       	push   $0x1000
80107278:	6a 00                	push   $0x0
8010727a:	50                   	push   %eax
8010727b:	e8 c0 d8 ff ff       	call   80104b40 <memset>
        if (mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
80107280:	58                   	pop    %eax
80107281:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107287:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010728c:	5a                   	pop    %edx
8010728d:	6a 06                	push   $0x6
8010728f:	50                   	push   %eax
80107290:	89 da                	mov    %ebx,%edx
80107292:	89 f8                	mov    %edi,%eax
80107294:	e8 67 fb ff ff       	call   80106e00 <mappages>
80107299:	83 c4 10             	add    $0x10,%esp
8010729c:	85 c0                	test   %eax,%eax
8010729e:	78 50                	js     801072f0 <allocuvm+0xc0>
    for (; a < newsz; a += PGSIZE) {
801072a0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072a6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801072a9:	0f 86 81 00 00 00    	jbe    80107330 <allocuvm+0x100>
        mem = kalloc();
801072af:	e8 cc b8 ff ff       	call   80102b80 <kalloc>
        if (mem == 0) {
801072b4:	85 c0                	test   %eax,%eax
        mem = kalloc();
801072b6:	89 c6                	mov    %eax,%esi
        if (mem == 0) {
801072b8:	75 b6                	jne    80107270 <allocuvm+0x40>
            cprintf("allocuvm out of memory\n");
801072ba:	83 ec 0c             	sub    $0xc,%esp
801072bd:	68 71 80 10 80       	push   $0x80108071
801072c2:	e8 39 95 ff ff       	call   80100800 <cprintf>
    if (newsz >= oldsz) {
801072c7:	83 c4 10             	add    $0x10,%esp
801072ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801072cd:	39 45 10             	cmp    %eax,0x10(%ebp)
801072d0:	77 6e                	ja     80107340 <allocuvm+0x110>
}
801072d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
801072d5:	31 ff                	xor    %edi,%edi
}
801072d7:	89 f8                	mov    %edi,%eax
801072d9:	5b                   	pop    %ebx
801072da:	5e                   	pop    %esi
801072db:	5f                   	pop    %edi
801072dc:	5d                   	pop    %ebp
801072dd:	c3                   	ret    
801072de:	66 90                	xchg   %ax,%ax
        return oldsz;
801072e0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801072e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072e6:	89 f8                	mov    %edi,%eax
801072e8:	5b                   	pop    %ebx
801072e9:	5e                   	pop    %esi
801072ea:	5f                   	pop    %edi
801072eb:	5d                   	pop    %ebp
801072ec:	c3                   	ret    
801072ed:	8d 76 00             	lea    0x0(%esi),%esi
            cprintf("allocuvm out of memory (2)\n");
801072f0:	83 ec 0c             	sub    $0xc,%esp
801072f3:	68 89 80 10 80       	push   $0x80108089
801072f8:	e8 03 95 ff ff       	call   80100800 <cprintf>
    if (newsz >= oldsz) {
801072fd:	83 c4 10             	add    $0x10,%esp
80107300:	8b 45 0c             	mov    0xc(%ebp),%eax
80107303:	39 45 10             	cmp    %eax,0x10(%ebp)
80107306:	76 0d                	jbe    80107315 <allocuvm+0xe5>
80107308:	89 c1                	mov    %eax,%ecx
8010730a:	8b 55 10             	mov    0x10(%ebp),%edx
8010730d:	8b 45 08             	mov    0x8(%ebp),%eax
80107310:	e8 7b fb ff ff       	call   80106e90 <deallocuvm.part.0>
            kfree(mem);
80107315:	83 ec 0c             	sub    $0xc,%esp
            return 0;
80107318:	31 ff                	xor    %edi,%edi
            kfree(mem);
8010731a:	56                   	push   %esi
8010731b:	e8 b0 b6 ff ff       	call   801029d0 <kfree>
            return 0;
80107320:	83 c4 10             	add    $0x10,%esp
}
80107323:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107326:	89 f8                	mov    %edi,%eax
80107328:	5b                   	pop    %ebx
80107329:	5e                   	pop    %esi
8010732a:	5f                   	pop    %edi
8010732b:	5d                   	pop    %ebp
8010732c:	c3                   	ret    
8010732d:	8d 76 00             	lea    0x0(%esi),%esi
80107330:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107333:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107336:	5b                   	pop    %ebx
80107337:	89 f8                	mov    %edi,%eax
80107339:	5e                   	pop    %esi
8010733a:	5f                   	pop    %edi
8010733b:	5d                   	pop    %ebp
8010733c:	c3                   	ret    
8010733d:	8d 76 00             	lea    0x0(%esi),%esi
80107340:	89 c1                	mov    %eax,%ecx
80107342:	8b 55 10             	mov    0x10(%ebp),%edx
80107345:	8b 45 08             	mov    0x8(%ebp),%eax
            return 0;
80107348:	31 ff                	xor    %edi,%edi
8010734a:	e8 41 fb ff ff       	call   80106e90 <deallocuvm.part.0>
8010734f:	eb 92                	jmp    801072e3 <allocuvm+0xb3>
80107351:	eb 0d                	jmp    80107360 <deallocuvm>
80107353:	90                   	nop
80107354:	90                   	nop
80107355:	90                   	nop
80107356:	90                   	nop
80107357:	90                   	nop
80107358:	90                   	nop
80107359:	90                   	nop
8010735a:	90                   	nop
8010735b:	90                   	nop
8010735c:	90                   	nop
8010735d:	90                   	nop
8010735e:	90                   	nop
8010735f:	90                   	nop

80107360 <deallocuvm>:
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	8b 55 0c             	mov    0xc(%ebp),%edx
80107366:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107369:	8b 45 08             	mov    0x8(%ebp),%eax
    if (newsz >= oldsz) {
8010736c:	39 d1                	cmp    %edx,%ecx
8010736e:	73 10                	jae    80107380 <deallocuvm+0x20>
}
80107370:	5d                   	pop    %ebp
80107371:	e9 1a fb ff ff       	jmp    80106e90 <deallocuvm.part.0>
80107376:	8d 76 00             	lea    0x0(%esi),%esi
80107379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107380:	89 d0                	mov    %edx,%eax
80107382:	5d                   	pop    %ebp
80107383:	c3                   	ret    
80107384:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010738a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107390 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void freevm(pde_t *pgdir) {
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	57                   	push   %edi
80107394:	56                   	push   %esi
80107395:	53                   	push   %ebx
80107396:	83 ec 0c             	sub    $0xc,%esp
80107399:	8b 75 08             	mov    0x8(%ebp),%esi
    uint i;

    if (pgdir == 0) {
8010739c:	85 f6                	test   %esi,%esi
8010739e:	74 59                	je     801073f9 <freevm+0x69>
801073a0:	31 c9                	xor    %ecx,%ecx
801073a2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801073a7:	89 f0                	mov    %esi,%eax
801073a9:	e8 e2 fa ff ff       	call   80106e90 <deallocuvm.part.0>
801073ae:	89 f3                	mov    %esi,%ebx
801073b0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801073b6:	eb 0f                	jmp    801073c7 <freevm+0x37>
801073b8:	90                   	nop
801073b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073c0:	83 c3 04             	add    $0x4,%ebx
        panic("freevm: no pgdir");
    }
    deallocuvm(pgdir, KERNBASE, 0);
    for (i = 0; i < NPDENTRIES; i++) {
801073c3:	39 fb                	cmp    %edi,%ebx
801073c5:	74 23                	je     801073ea <freevm+0x5a>
        if (pgdir[i] & PTE_P) {
801073c7:	8b 03                	mov    (%ebx),%eax
801073c9:	a8 01                	test   $0x1,%al
801073cb:	74 f3                	je     801073c0 <freevm+0x30>
            char * v = P2V(PTE_ADDR(pgdir[i]));
801073cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
            kfree(v);
801073d2:	83 ec 0c             	sub    $0xc,%esp
801073d5:	83 c3 04             	add    $0x4,%ebx
            char * v = P2V(PTE_ADDR(pgdir[i]));
801073d8:	05 00 00 00 80       	add    $0x80000000,%eax
            kfree(v);
801073dd:	50                   	push   %eax
801073de:	e8 ed b5 ff ff       	call   801029d0 <kfree>
801073e3:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NPDENTRIES; i++) {
801073e6:	39 fb                	cmp    %edi,%ebx
801073e8:	75 dd                	jne    801073c7 <freevm+0x37>
        }
    }
    kfree((char*)pgdir);
801073ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801073ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073f0:	5b                   	pop    %ebx
801073f1:	5e                   	pop    %esi
801073f2:	5f                   	pop    %edi
801073f3:	5d                   	pop    %ebp
    kfree((char*)pgdir);
801073f4:	e9 d7 b5 ff ff       	jmp    801029d0 <kfree>
        panic("freevm: no pgdir");
801073f9:	83 ec 0c             	sub    $0xc,%esp
801073fc:	68 a5 80 10 80       	push   $0x801080a5
80107401:	e8 7a 90 ff ff       	call   80100480 <panic>
80107406:	8d 76 00             	lea    0x0(%esi),%esi
80107409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107410 <setupkvm>:
pde_t*setupkvm(void) {
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	56                   	push   %esi
80107414:	53                   	push   %ebx
    if ((pgdir = (pde_t*)kalloc()) == 0) {
80107415:	e8 66 b7 ff ff       	call   80102b80 <kalloc>
8010741a:	85 c0                	test   %eax,%eax
8010741c:	89 c6                	mov    %eax,%esi
8010741e:	74 42                	je     80107462 <setupkvm+0x52>
    memset(pgdir, 0, PGSIZE);
80107420:	83 ec 04             	sub    $0x4,%esp
    for (k = kmap; k < &kmap[NELEM(kmap)]; k++) {
80107423:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
    memset(pgdir, 0, PGSIZE);
80107428:	68 00 10 00 00       	push   $0x1000
8010742d:	6a 00                	push   $0x0
8010742f:	50                   	push   %eax
80107430:	e8 0b d7 ff ff       	call   80104b40 <memset>
80107435:	83 c4 10             	add    $0x10,%esp
                     (uint)k->phys_start, k->perm) < 0) {
80107438:	8b 43 04             	mov    0x4(%ebx),%eax
        if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010743b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010743e:	83 ec 08             	sub    $0x8,%esp
80107441:	8b 13                	mov    (%ebx),%edx
80107443:	ff 73 0c             	pushl  0xc(%ebx)
80107446:	50                   	push   %eax
80107447:	29 c1                	sub    %eax,%ecx
80107449:	89 f0                	mov    %esi,%eax
8010744b:	e8 b0 f9 ff ff       	call   80106e00 <mappages>
80107450:	83 c4 10             	add    $0x10,%esp
80107453:	85 c0                	test   %eax,%eax
80107455:	78 19                	js     80107470 <setupkvm+0x60>
    for (k = kmap; k < &kmap[NELEM(kmap)]; k++) {
80107457:	83 c3 10             	add    $0x10,%ebx
8010745a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107460:	75 d6                	jne    80107438 <setupkvm+0x28>
}
80107462:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107465:	89 f0                	mov    %esi,%eax
80107467:	5b                   	pop    %ebx
80107468:	5e                   	pop    %esi
80107469:	5d                   	pop    %ebp
8010746a:	c3                   	ret    
8010746b:	90                   	nop
8010746c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            freevm(pgdir);
80107470:	83 ec 0c             	sub    $0xc,%esp
80107473:	56                   	push   %esi
            return 0;
80107474:	31 f6                	xor    %esi,%esi
            freevm(pgdir);
80107476:	e8 15 ff ff ff       	call   80107390 <freevm>
            return 0;
8010747b:	83 c4 10             	add    $0x10,%esp
}
8010747e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107481:	89 f0                	mov    %esi,%eax
80107483:	5b                   	pop    %ebx
80107484:	5e                   	pop    %esi
80107485:	5d                   	pop    %ebp
80107486:	c3                   	ret    
80107487:	89 f6                	mov    %esi,%esi
80107489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107490 <kvmalloc>:
void kvmalloc(void)  {
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	83 ec 08             	sub    $0x8,%esp
    kpgdir = setupkvm();
80107496:	e8 75 ff ff ff       	call   80107410 <setupkvm>
8010749b:	a3 84 7c 11 80       	mov    %eax,0x80117c84
    lcr3(V2P(kpgdir));   // switch to the kernel page table
801074a0:	05 00 00 00 80       	add    $0x80000000,%eax
801074a5:	0f 22 d8             	mov    %eax,%cr3
}
801074a8:	c9                   	leave  
801074a9:	c3                   	ret    
801074aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074b0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void clearpteu(pde_t *pgdir, char *uva) {
801074b0:	55                   	push   %ebp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
801074b1:	31 c9                	xor    %ecx,%ecx
void clearpteu(pde_t *pgdir, char *uva) {
801074b3:	89 e5                	mov    %esp,%ebp
801074b5:	83 ec 08             	sub    $0x8,%esp
    pte = walkpgdir(pgdir, uva, 0);
801074b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801074bb:	8b 45 08             	mov    0x8(%ebp),%eax
801074be:	e8 bd f8 ff ff       	call   80106d80 <walkpgdir>
    if (pte == 0) {
801074c3:	85 c0                	test   %eax,%eax
801074c5:	74 05                	je     801074cc <clearpteu+0x1c>
        panic("clearpteu");
    }
    *pte &= ~PTE_U;
801074c7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801074ca:	c9                   	leave  
801074cb:	c3                   	ret    
        panic("clearpteu");
801074cc:	83 ec 0c             	sub    $0xc,%esp
801074cf:	68 b6 80 10 80       	push   $0x801080b6
801074d4:	e8 a7 8f ff ff       	call   80100480 <panic>
801074d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t* copyuvm(pde_t *pgdir, uint sz) {
801074e0:	55                   	push   %ebp
801074e1:	89 e5                	mov    %esp,%ebp
801074e3:	57                   	push   %edi
801074e4:	56                   	push   %esi
801074e5:	53                   	push   %ebx
801074e6:	83 ec 1c             	sub    $0x1c,%esp
    pde_t *d;
    pte_t *pte;
    uint pa, i, flags;
    char *mem;

    if ((d = setupkvm()) == 0) {
801074e9:	e8 22 ff ff ff       	call   80107410 <setupkvm>
801074ee:	85 c0                	test   %eax,%eax
801074f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801074f3:	0f 84 9f 00 00 00    	je     80107598 <copyuvm+0xb8>
        return 0;
    }
    for (i = 0; i < sz; i += PGSIZE) {
801074f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801074fc:	85 db                	test   %ebx,%ebx
801074fe:	0f 84 94 00 00 00    	je     80107598 <copyuvm+0xb8>
80107504:	31 ff                	xor    %edi,%edi
80107506:	eb 4a                	jmp    80107552 <copyuvm+0x72>
80107508:	90                   	nop
80107509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        flags = PTE_FLAGS(*pte);
        if ((mem = kalloc()) == 0) {
            freevm(d);
            return 0;
        }
        memmove(mem, (char*)P2V(pa), PGSIZE);
80107510:	83 ec 04             	sub    $0x4,%esp
80107513:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107519:	68 00 10 00 00       	push   $0x1000
8010751e:	53                   	push   %ebx
8010751f:	50                   	push   %eax
80107520:	e8 cb d6 ff ff       	call   80104bf0 <memmove>
        if (mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107525:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010752b:	5a                   	pop    %edx
8010752c:	59                   	pop    %ecx
8010752d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107530:	50                   	push   %eax
80107531:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107536:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107539:	89 fa                	mov    %edi,%edx
8010753b:	e8 c0 f8 ff ff       	call   80106e00 <mappages>
80107540:	83 c4 10             	add    $0x10,%esp
80107543:	85 c0                	test   %eax,%eax
80107545:	78 61                	js     801075a8 <copyuvm+0xc8>
    for (i = 0; i < sz; i += PGSIZE) {
80107547:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010754d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107550:	76 46                	jbe    80107598 <copyuvm+0xb8>
        if ((pte = walkpgdir(pgdir, (void *) i, 0)) == 0) {
80107552:	8b 45 08             	mov    0x8(%ebp),%eax
80107555:	31 c9                	xor    %ecx,%ecx
80107557:	89 fa                	mov    %edi,%edx
80107559:	e8 22 f8 ff ff       	call   80106d80 <walkpgdir>
8010755e:	85 c0                	test   %eax,%eax
80107560:	74 7a                	je     801075dc <copyuvm+0xfc>
        if (!(*pte & PTE_P)) {
80107562:	8b 00                	mov    (%eax),%eax
80107564:	a8 01                	test   $0x1,%al
80107566:	74 67                	je     801075cf <copyuvm+0xef>
        pa = PTE_ADDR(*pte);
80107568:	89 c3                	mov    %eax,%ebx
        flags = PTE_FLAGS(*pte);
8010756a:	25 ff 0f 00 00       	and    $0xfff,%eax
        pa = PTE_ADDR(*pte);
8010756f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
        flags = PTE_FLAGS(*pte);
80107575:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if ((mem = kalloc()) == 0) {
80107578:	e8 03 b6 ff ff       	call   80102b80 <kalloc>
8010757d:	85 c0                	test   %eax,%eax
8010757f:	89 c6                	mov    %eax,%esi
80107581:	75 8d                	jne    80107510 <copyuvm+0x30>
            freevm(d);
80107583:	83 ec 0c             	sub    $0xc,%esp
80107586:	ff 75 e0             	pushl  -0x20(%ebp)
80107589:	e8 02 fe ff ff       	call   80107390 <freevm>
            return 0;
8010758e:	83 c4 10             	add    $0x10,%esp
80107591:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            freevm(d);
            return 0;
        }
    }
    return d;
}
80107598:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010759b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010759e:	5b                   	pop    %ebx
8010759f:	5e                   	pop    %esi
801075a0:	5f                   	pop    %edi
801075a1:	5d                   	pop    %ebp
801075a2:	c3                   	ret    
801075a3:	90                   	nop
801075a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            kfree(mem);
801075a8:	83 ec 0c             	sub    $0xc,%esp
801075ab:	56                   	push   %esi
801075ac:	e8 1f b4 ff ff       	call   801029d0 <kfree>
            freevm(d);
801075b1:	58                   	pop    %eax
801075b2:	ff 75 e0             	pushl  -0x20(%ebp)
801075b5:	e8 d6 fd ff ff       	call   80107390 <freevm>
            return 0;
801075ba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801075c1:	83 c4 10             	add    $0x10,%esp
}
801075c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075ca:	5b                   	pop    %ebx
801075cb:	5e                   	pop    %esi
801075cc:	5f                   	pop    %edi
801075cd:	5d                   	pop    %ebp
801075ce:	c3                   	ret    
            panic("copyuvm: page not present");
801075cf:	83 ec 0c             	sub    $0xc,%esp
801075d2:	68 da 80 10 80       	push   $0x801080da
801075d7:	e8 a4 8e ff ff       	call   80100480 <panic>
            panic("copyuvm: pte should exist");
801075dc:	83 ec 0c             	sub    $0xc,%esp
801075df:	68 c0 80 10 80       	push   $0x801080c0
801075e4:	e8 97 8e ff ff       	call   80100480 <panic>
801075e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075f0 <uva2ka>:


// Map user virtual address to kernel address.
char*uva2ka(pde_t *pgdir, char *uva)      {
801075f0:	55                   	push   %ebp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
801075f1:	31 c9                	xor    %ecx,%ecx
char*uva2ka(pde_t *pgdir, char *uva)      {
801075f3:	89 e5                	mov    %esp,%ebp
801075f5:	83 ec 08             	sub    $0x8,%esp
    pte = walkpgdir(pgdir, uva, 0);
801075f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801075fb:	8b 45 08             	mov    0x8(%ebp),%eax
801075fe:	e8 7d f7 ff ff       	call   80106d80 <walkpgdir>
    if ((*pte & PTE_P) == 0) {
80107603:	8b 00                	mov    (%eax),%eax
    }
    if ((*pte & PTE_U) == 0) {
        return 0;
    }
    return (char*)P2V(PTE_ADDR(*pte));
}
80107605:	c9                   	leave  
    if ((*pte & PTE_U) == 0) {
80107606:	89 c2                	mov    %eax,%edx
    return (char*)P2V(PTE_ADDR(*pte));
80107608:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if ((*pte & PTE_U) == 0) {
8010760d:	83 e2 05             	and    $0x5,%edx
    return (char*)P2V(PTE_ADDR(*pte));
80107610:	05 00 00 00 80       	add    $0x80000000,%eax
80107615:	83 fa 05             	cmp    $0x5,%edx
80107618:	ba 00 00 00 00       	mov    $0x0,%edx
8010761d:	0f 45 c2             	cmovne %edx,%eax
}
80107620:	c3                   	ret    
80107621:	eb 0d                	jmp    80107630 <copyout>
80107623:	90                   	nop
80107624:	90                   	nop
80107625:	90                   	nop
80107626:	90                   	nop
80107627:	90                   	nop
80107628:	90                   	nop
80107629:	90                   	nop
8010762a:	90                   	nop
8010762b:	90                   	nop
8010762c:	90                   	nop
8010762d:	90                   	nop
8010762e:	90                   	nop
8010762f:	90                   	nop

80107630 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int copyout(pde_t *pgdir, uint va, void *p, uint len)     {
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	57                   	push   %edi
80107634:	56                   	push   %esi
80107635:	53                   	push   %ebx
80107636:	83 ec 1c             	sub    $0x1c,%esp
80107639:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010763c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010763f:	8b 7d 10             	mov    0x10(%ebp),%edi
    char *buf, *pa0;
    uint n, va0;

    buf = (char*)p;
    while (len > 0) {
80107642:	85 db                	test   %ebx,%ebx
80107644:	75 40                	jne    80107686 <copyout+0x56>
80107646:	eb 70                	jmp    801076b8 <copyout+0x88>
80107648:	90                   	nop
80107649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        va0 = (uint)PGROUNDDOWN(va);
        pa0 = uva2ka(pgdir, (char*)va0);
        if (pa0 == 0) {
            return -1;
        }
        n = PGSIZE - (va - va0);
80107650:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107653:	89 f1                	mov    %esi,%ecx
80107655:	29 d1                	sub    %edx,%ecx
80107657:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010765d:	39 d9                	cmp    %ebx,%ecx
8010765f:	0f 47 cb             	cmova  %ebx,%ecx
        if (n > len) {
            n = len;
        }
        memmove(pa0 + (va - va0), buf, n);
80107662:	29 f2                	sub    %esi,%edx
80107664:	83 ec 04             	sub    $0x4,%esp
80107667:	01 d0                	add    %edx,%eax
80107669:	51                   	push   %ecx
8010766a:	57                   	push   %edi
8010766b:	50                   	push   %eax
8010766c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010766f:	e8 7c d5 ff ff       	call   80104bf0 <memmove>
        len -= n;
        buf += n;
80107674:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    while (len > 0) {
80107677:	83 c4 10             	add    $0x10,%esp
        va = va0 + PGSIZE;
8010767a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
        buf += n;
80107680:	01 cf                	add    %ecx,%edi
    while (len > 0) {
80107682:	29 cb                	sub    %ecx,%ebx
80107684:	74 32                	je     801076b8 <copyout+0x88>
        va0 = (uint)PGROUNDDOWN(va);
80107686:	89 d6                	mov    %edx,%esi
        pa0 = uva2ka(pgdir, (char*)va0);
80107688:	83 ec 08             	sub    $0x8,%esp
        va0 = (uint)PGROUNDDOWN(va);
8010768b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010768e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
        pa0 = uva2ka(pgdir, (char*)va0);
80107694:	56                   	push   %esi
80107695:	ff 75 08             	pushl  0x8(%ebp)
80107698:	e8 53 ff ff ff       	call   801075f0 <uva2ka>
        if (pa0 == 0) {
8010769d:	83 c4 10             	add    $0x10,%esp
801076a0:	85 c0                	test   %eax,%eax
801076a2:	75 ac                	jne    80107650 <copyout+0x20>
    }
    return 0;
}
801076a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
801076a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801076ac:	5b                   	pop    %ebx
801076ad:	5e                   	pop    %esi
801076ae:	5f                   	pop    %edi
801076af:	5d                   	pop    %ebp
801076b0:	c3                   	ret    
801076b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801076bb:	31 c0                	xor    %eax,%eax
}
801076bd:	5b                   	pop    %ebx
801076be:	5e                   	pop    %esi
801076bf:	5f                   	pop    %edi
801076c0:	5d                   	pop    %ebp
801076c1:	c3                   	ret    
