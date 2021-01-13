
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

    # Jump to main(), and switch to executing at
    # high addresses. The indirect call is needed because
    # the assembler produces a PC-relative instruction
    # for a direct jump.
    mov $main, %eax
8010002d:	b8 c0 32 10 80       	mov    $0x801032c0,%eax
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
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
void binit(void) {
80100049:	83 ec 0c             	sub    $0xc,%esp
    initlock(&bcache.lock, "bcache");
8010004c:	68 00 74 10 80       	push   $0x80107400
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 f5 45 00 00       	call   80104650 <initlock>
    bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
    bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
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
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
        initsleeplock(&b->lock, "buffer");
80100092:	68 07 74 10 80       	push   $0x80107407
80100097:	50                   	push   %eax
80100098:	e8 83 44 00 00       	call   80104520 <initsleeplock>
        bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
        bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
    for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
        bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
    for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
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
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 a7 46 00 00       	call   80104790 <acquire>
    for (b = bcache.head.next; b != &bcache.head; b = b->next) {
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 e9 46 00 00       	call   80104850 <release>
            acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 43 00 00       	call   80104560 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
    struct buf *b;

    b = bget(dev, blockno);
    if ((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
        iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 bd 23 00 00       	call   80102540 <iderw>
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
80100193:	68 0e 74 10 80       	push   $0x8010740e
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
801001ae:	e8 4d 44 00 00       	call   80104600 <holdingsleep>
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
801001c4:	e9 77 23 00 00       	jmp    80102540 <iderw>
        panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 74 10 80       	push   $0x8010741f
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
801001ef:	e8 0c 44 00 00       	call   80104600 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
        panic("brelse");
    }

    releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 bc 43 00 00       	call   801045c0 <releasesleep>

    acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 80 45 00 00       	call   80104790 <acquire>
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
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
        b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
        b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
        bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
        bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
    }

    release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    release(&bcache.lock);
8010025c:	e9 ef 45 00 00       	jmp    80104850 <release>
        panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 74 10 80       	push   $0x80107426
80100269:	e8 12 02 00 00       	call   80100480 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <writeVideoRegisters>:
    outb(VGA_SEQ_INDEX, 2);
    outb(VGA_SEQ_DATA, planeMask);
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
80100370:	e8 0b 18 00 00       	call   80101b80 <iunlock>
    acquire(&cons.lock);
80100375:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010037c:	e8 0f 44 00 00       	call   80104790 <acquire>
    while (n > 0) {
80100381:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100384:	83 c4 10             	add    $0x10,%esp
80100387:	31 c0                	xor    %eax,%eax
80100389:	85 db                	test   %ebx,%ebx
8010038b:	0f 8e a1 00 00 00    	jle    80100432 <consoleread+0xd2>
        while (input.r == input.w) {
80100391:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
80100397:	39 15 a4 0f 11 80    	cmp    %edx,0x80110fa4
8010039d:	74 2c                	je     801003cb <consoleread+0x6b>
8010039f:	eb 5f                	jmp    80100400 <consoleread+0xa0>
801003a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            sleep(&input.r, &cons.lock);
801003a8:	83 ec 08             	sub    $0x8,%esp
801003ab:	68 20 b5 10 80       	push   $0x8010b520
801003b0:	68 a0 0f 11 80       	push   $0x80110fa0
801003b5:	e8 16 3e 00 00       	call   801041d0 <sleep>
        while (input.r == input.w) {
801003ba:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801003c0:	83 c4 10             	add    $0x10,%esp
801003c3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801003c9:	75 35                	jne    80100400 <consoleread+0xa0>
            if (myproc()->killed) {
801003cb:	e8 60 38 00 00       	call   80103c30 <myproc>
801003d0:	8b 40 24             	mov    0x24(%eax),%eax
801003d3:	85 c0                	test   %eax,%eax
801003d5:	74 d1                	je     801003a8 <consoleread+0x48>
                release(&cons.lock);
801003d7:	83 ec 0c             	sub    $0xc,%esp
801003da:	68 20 b5 10 80       	push   $0x8010b520
801003df:	e8 6c 44 00 00       	call   80104850 <release>
                ilock(ip);
801003e4:	89 3c 24             	mov    %edi,(%esp)
801003e7:	e8 b4 16 00 00       	call   80101aa0 <ilock>
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
80100403:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100408:	89 d0                	mov    %edx,%eax
8010040a:	83 e0 7f             	and    $0x7f,%eax
8010040d:	0f be 80 20 0f 11 80 	movsbl -0x7feef0e0(%eax),%eax
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
80100438:	68 20 b5 10 80       	push   $0x8010b520
8010043d:	e8 0e 44 00 00       	call   80104850 <release>
    ilock(ip);
80100442:	89 3c 24             	mov    %edi,(%esp)
80100445:	e8 56 16 00 00       	call   80101aa0 <ilock>
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
80100462:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
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
80100489:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
80100490:	00 00 00 
    getcallerpcs(&s, pcs);
80100493:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100496:	8d 75 f8             	lea    -0x8(%ebp),%esi
    cprintf("lapicid %d: panic: ", lapicid());
80100499:	e8 b2 26 00 00       	call   80102b50 <lapicid>
8010049e:	83 ec 08             	sub    $0x8,%esp
801004a1:	50                   	push   %eax
801004a2:	68 2d 74 10 80       	push   $0x8010742d
801004a7:	e8 a4 02 00 00       	call   80100750 <cprintf>
    cprintf(s);
801004ac:	58                   	pop    %eax
801004ad:	ff 75 08             	pushl  0x8(%ebp)
801004b0:	e8 9b 02 00 00       	call   80100750 <cprintf>
    cprintf("\n");
801004b5:	c7 04 24 9b 7d 10 80 	movl   $0x80107d9b,(%esp)
801004bc:	e8 8f 02 00 00       	call   80100750 <cprintf>
    getcallerpcs(&s, pcs);
801004c1:	5a                   	pop    %edx
801004c2:	8d 45 08             	lea    0x8(%ebp),%eax
801004c5:	59                   	pop    %ecx
801004c6:	53                   	push   %ebx
801004c7:	50                   	push   %eax
801004c8:	e8 a3 41 00 00       	call   80104670 <getcallerpcs>
801004cd:	83 c4 10             	add    $0x10,%esp
        cprintf(" %p", pcs[i]);
801004d0:	83 ec 08             	sub    $0x8,%esp
801004d3:	ff 33                	pushl  (%ebx)
801004d5:	83 c3 04             	add    $0x4,%ebx
801004d8:	68 41 74 10 80       	push   $0x80107441
801004dd:	e8 6e 02 00 00       	call   80100750 <cprintf>
    for (i = 0; i < 10; i++) {
801004e2:	83 c4 10             	add    $0x10,%esp
801004e5:	39 f3                	cmp    %esi,%ebx
801004e7:	75 e7                	jne    801004d0 <panic+0x50>
    panicked = 1; // freeze other CPU
801004e9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801004f0:	00 00 00 
801004f3:	eb fe                	jmp    801004f3 <panic+0x73>
801004f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801004f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100500 <consputc>:
    if (panicked) {
80100500:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
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
80100520:	0f 84 b1 00 00 00    	je     801005d7 <consputc+0xd7>
        uartputc(c);
80100526:	83 ec 0c             	sub    $0xc,%esp
80100529:	50                   	push   %eax
8010052a:	e8 c1 5a 00 00       	call   80105ff0 <uartputc>
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
    pos = inb(CRTPORT + 1) << 8;
80100547:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
8010054a:	89 da                	mov    %ebx,%edx
8010054c:	c1 e0 08             	shl    $0x8,%eax
8010054f:	89 c7                	mov    %eax,%edi
80100551:	b8 0f 00 00 00       	mov    $0xf,%eax
80100556:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100557:	89 ca                	mov    %ecx,%edx
80100559:	ec                   	in     (%dx),%al
8010055a:	0f b6 d8             	movzbl %al,%ebx
    pos |= inb(CRTPORT + 1);
8010055d:	09 fb                	or     %edi,%ebx
    if (c == '\n') {
8010055f:	83 fe 0a             	cmp    $0xa,%esi
80100562:	0f 84 f3 00 00 00    	je     8010065b <consputc+0x15b>
    else if (c == BACKSPACE) {
80100568:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010056e:	0f 84 d7 00 00 00    	je     8010064b <consputc+0x14b>
        crt[pos++] = (c & 0xff) | 0x0700;  // black on white
80100574:	89 f0                	mov    %esi,%eax
80100576:	0f b6 c0             	movzbl %al,%eax
80100579:	80 cc 07             	or     $0x7,%ah
8010057c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100583:	80 
80100584:	83 c3 01             	add    $0x1,%ebx
    if (pos < 0 || pos > 25 * 80) {
80100587:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010058d:	0f 8f ab 00 00 00    	jg     8010063e <consputc+0x13e>
    if ((pos / 80) >= 24) { // Scroll up.
80100593:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100599:	7f 66                	jg     80100601 <consputc+0x101>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
8010059b:	be d4 03 00 00       	mov    $0x3d4,%esi
801005a0:	b8 0e 00 00 00       	mov    $0xe,%eax
801005a5:	89 f2                	mov    %esi,%edx
801005a7:	ee                   	out    %al,(%dx)
801005a8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
    outb(CRTPORT + 1, pos >> 8);
801005ad:	89 d8                	mov    %ebx,%eax
801005af:	c1 f8 08             	sar    $0x8,%eax
801005b2:	89 ca                	mov    %ecx,%edx
801005b4:	ee                   	out    %al,(%dx)
801005b5:	b8 0f 00 00 00       	mov    $0xf,%eax
801005ba:	89 f2                	mov    %esi,%edx
801005bc:	ee                   	out    %al,(%dx)
801005bd:	89 d8                	mov    %ebx,%eax
801005bf:	89 ca                	mov    %ecx,%edx
801005c1:	ee                   	out    %al,(%dx)
    crt[pos] = ' ' | 0x0700;
801005c2:	b8 20 07 00 00       	mov    $0x720,%eax
801005c7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801005ce:	80 
}
801005cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005d2:	5b                   	pop    %ebx
801005d3:	5e                   	pop    %esi
801005d4:	5f                   	pop    %edi
801005d5:	5d                   	pop    %ebp
801005d6:	c3                   	ret    
        uartputc('\b');
801005d7:	83 ec 0c             	sub    $0xc,%esp
801005da:	6a 08                	push   $0x8
801005dc:	e8 0f 5a 00 00       	call   80105ff0 <uartputc>
        uartputc(' ');
801005e1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801005e8:	e8 03 5a 00 00       	call   80105ff0 <uartputc>
        uartputc('\b');
801005ed:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801005f4:	e8 f7 59 00 00       	call   80105ff0 <uartputc>
801005f9:	83 c4 10             	add    $0x10,%esp
801005fc:	e9 31 ff ff ff       	jmp    80100532 <consputc+0x32>
        memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
80100601:	52                   	push   %edx
80100602:	68 60 0e 00 00       	push   $0xe60
        pos -= 80;
80100607:	83 eb 50             	sub    $0x50,%ebx
        memmove(crt, crt + 80, sizeof(crt[0]) * 23 * 80);
8010060a:	68 a0 80 0b 80       	push   $0x800b80a0
8010060f:	68 00 80 0b 80       	push   $0x800b8000
80100614:	e8 37 43 00 00       	call   80104950 <memmove>
        memset(crt + pos, 0, sizeof(crt[0]) * (24 * 80 - pos));
80100619:	b8 80 07 00 00       	mov    $0x780,%eax
8010061e:	83 c4 0c             	add    $0xc,%esp
80100621:	29 d8                	sub    %ebx,%eax
80100623:	01 c0                	add    %eax,%eax
80100625:	50                   	push   %eax
80100626:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100629:	6a 00                	push   $0x0
8010062b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100630:	50                   	push   %eax
80100631:	e8 6a 42 00 00       	call   801048a0 <memset>
80100636:	83 c4 10             	add    $0x10,%esp
80100639:	e9 5d ff ff ff       	jmp    8010059b <consputc+0x9b>
        panic("pos under/overflow");
8010063e:	83 ec 0c             	sub    $0xc,%esp
80100641:	68 45 74 10 80       	push   $0x80107445
80100646:	e8 35 fe ff ff       	call   80100480 <panic>
        if (pos > 0) {
8010064b:	85 db                	test   %ebx,%ebx
8010064d:	0f 84 48 ff ff ff    	je     8010059b <consputc+0x9b>
            --pos;
80100653:	83 eb 01             	sub    $0x1,%ebx
80100656:	e9 2c ff ff ff       	jmp    80100587 <consputc+0x87>
        pos += 80 - pos % 80;
8010065b:	89 d8                	mov    %ebx,%eax
8010065d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100662:	99                   	cltd   
80100663:	f7 f9                	idiv   %ecx
80100665:	29 d1                	sub    %edx,%ecx
80100667:	01 cb                	add    %ecx,%ebx
80100669:	e9 19 ff ff ff       	jmp    80100587 <consputc+0x87>
8010066e:	66 90                	xchg   %ax,%ax

80100670 <printint>:
static void printint(int xx, int base, int sign) {
80100670:	55                   	push   %ebp
80100671:	89 e5                	mov    %esp,%ebp
80100673:	57                   	push   %edi
80100674:	56                   	push   %esi
80100675:	53                   	push   %ebx
80100676:	89 d3                	mov    %edx,%ebx
80100678:	83 ec 2c             	sub    $0x2c,%esp
    if (sign && (sign = xx < 0)) {
8010067b:	85 c9                	test   %ecx,%ecx
static void printint(int xx, int base, int sign) {
8010067d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    if (sign && (sign = xx < 0)) {
80100680:	74 04                	je     80100686 <printint+0x16>
80100682:	85 c0                	test   %eax,%eax
80100684:	78 5a                	js     801006e0 <printint+0x70>
        x = xx;
80100686:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    i = 0;
8010068d:	31 c9                	xor    %ecx,%ecx
8010068f:	8d 75 d7             	lea    -0x29(%ebp),%esi
80100692:	eb 06                	jmp    8010069a <printint+0x2a>
80100694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        buf[i++] = digits[x % base];
80100698:	89 f9                	mov    %edi,%ecx
8010069a:	31 d2                	xor    %edx,%edx
8010069c:	8d 79 01             	lea    0x1(%ecx),%edi
8010069f:	f7 f3                	div    %ebx
801006a1:	0f b6 92 70 74 10 80 	movzbl -0x7fef8b90(%edx),%edx
    while ((x /= base) != 0);
801006a8:	85 c0                	test   %eax,%eax
        buf[i++] = digits[x % base];
801006aa:	88 14 3e             	mov    %dl,(%esi,%edi,1)
    while ((x /= base) != 0);
801006ad:	75 e9                	jne    80100698 <printint+0x28>
    if (sign) {
801006af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801006b2:	85 c0                	test   %eax,%eax
801006b4:	74 08                	je     801006be <printint+0x4e>
        buf[i++] = '-';
801006b6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801006bb:	8d 79 02             	lea    0x2(%ecx),%edi
801006be:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801006c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        consputc(buf[i]);
801006c8:	0f be 03             	movsbl (%ebx),%eax
801006cb:	83 eb 01             	sub    $0x1,%ebx
801006ce:	e8 2d fe ff ff       	call   80100500 <consputc>
    while (--i >= 0) {
801006d3:	39 f3                	cmp    %esi,%ebx
801006d5:	75 f1                	jne    801006c8 <printint+0x58>
}
801006d7:	83 c4 2c             	add    $0x2c,%esp
801006da:	5b                   	pop    %ebx
801006db:	5e                   	pop    %esi
801006dc:	5f                   	pop    %edi
801006dd:	5d                   	pop    %ebp
801006de:	c3                   	ret    
801006df:	90                   	nop
        x = -xx;
801006e0:	f7 d8                	neg    %eax
801006e2:	eb a9                	jmp    8010068d <printint+0x1d>
801006e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801006ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801006f0 <consolewrite>:
int consolewrite(struct inode *ip, char *buf, int n) {
801006f0:	55                   	push   %ebp
801006f1:	89 e5                	mov    %esp,%ebp
801006f3:	57                   	push   %edi
801006f4:	56                   	push   %esi
801006f5:	53                   	push   %ebx
801006f6:	83 ec 18             	sub    $0x18,%esp
801006f9:	8b 75 10             	mov    0x10(%ebp),%esi
    iunlock(ip);
801006fc:	ff 75 08             	pushl  0x8(%ebp)
801006ff:	e8 7c 14 00 00       	call   80101b80 <iunlock>
    acquire(&cons.lock);
80100704:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010070b:	e8 80 40 00 00       	call   80104790 <acquire>
    for (i = 0; i < n; i++) {
80100710:	83 c4 10             	add    $0x10,%esp
80100713:	85 f6                	test   %esi,%esi
80100715:	7e 18                	jle    8010072f <consolewrite+0x3f>
80100717:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010071a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
        consputc(buf[i] & 0xff);
80100720:	0f b6 07             	movzbl (%edi),%eax
80100723:	83 c7 01             	add    $0x1,%edi
80100726:	e8 d5 fd ff ff       	call   80100500 <consputc>
    for (i = 0; i < n; i++) {
8010072b:	39 fb                	cmp    %edi,%ebx
8010072d:	75 f1                	jne    80100720 <consolewrite+0x30>
    release(&cons.lock);
8010072f:	83 ec 0c             	sub    $0xc,%esp
80100732:	68 20 b5 10 80       	push   $0x8010b520
80100737:	e8 14 41 00 00       	call   80104850 <release>
    ilock(ip);
8010073c:	58                   	pop    %eax
8010073d:	ff 75 08             	pushl  0x8(%ebp)
80100740:	e8 5b 13 00 00       	call   80101aa0 <ilock>
}
80100745:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100748:	89 f0                	mov    %esi,%eax
8010074a:	5b                   	pop    %ebx
8010074b:	5e                   	pop    %esi
8010074c:	5f                   	pop    %edi
8010074d:	5d                   	pop    %ebp
8010074e:	c3                   	ret    
8010074f:	90                   	nop

80100750 <cprintf>:
void cprintf(char *fmt, ...) {
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	57                   	push   %edi
80100754:	56                   	push   %esi
80100755:	53                   	push   %ebx
80100756:	83 ec 1c             	sub    $0x1c,%esp
    locking = cons.locking;
80100759:	a1 54 b5 10 80       	mov    0x8010b554,%eax
    if (locking) {
8010075e:	85 c0                	test   %eax,%eax
    locking = cons.locking;
80100760:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (locking) {
80100763:	0f 85 6f 01 00 00    	jne    801008d8 <cprintf+0x188>
    if (fmt == 0) {
80100769:	8b 45 08             	mov    0x8(%ebp),%eax
8010076c:	85 c0                	test   %eax,%eax
8010076e:	89 c7                	mov    %eax,%edi
80100770:	0f 84 77 01 00 00    	je     801008ed <cprintf+0x19d>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
80100776:	0f b6 00             	movzbl (%eax),%eax
    argp = (uint*)(void*)(&fmt + 1);
80100779:	8d 4d 0c             	lea    0xc(%ebp),%ecx
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
8010077c:	31 db                	xor    %ebx,%ebx
    argp = (uint*)(void*)(&fmt + 1);
8010077e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
80100781:	85 c0                	test   %eax,%eax
80100783:	75 56                	jne    801007db <cprintf+0x8b>
80100785:	eb 79                	jmp    80100800 <cprintf+0xb0>
80100787:	89 f6                	mov    %esi,%esi
80100789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        c = fmt[++i] & 0xff;
80100790:	0f b6 16             	movzbl (%esi),%edx
        if (c == 0) {
80100793:	85 d2                	test   %edx,%edx
80100795:	74 69                	je     80100800 <cprintf+0xb0>
80100797:	83 c3 02             	add    $0x2,%ebx
        switch (c) {
8010079a:	83 fa 70             	cmp    $0x70,%edx
8010079d:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801007a0:	0f 84 84 00 00 00    	je     8010082a <cprintf+0xda>
801007a6:	7f 78                	jg     80100820 <cprintf+0xd0>
801007a8:	83 fa 25             	cmp    $0x25,%edx
801007ab:	0f 84 ff 00 00 00    	je     801008b0 <cprintf+0x160>
801007b1:	83 fa 64             	cmp    $0x64,%edx
801007b4:	0f 85 8e 00 00 00    	jne    80100848 <cprintf+0xf8>
                printint(*argp++, 10, 1);
801007ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801007bd:	ba 0a 00 00 00       	mov    $0xa,%edx
801007c2:	8d 48 04             	lea    0x4(%eax),%ecx
801007c5:	8b 00                	mov    (%eax),%eax
801007c7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801007ca:	b9 01 00 00 00       	mov    $0x1,%ecx
801007cf:	e8 9c fe ff ff       	call   80100670 <printint>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
801007d4:	0f b6 06             	movzbl (%esi),%eax
801007d7:	85 c0                	test   %eax,%eax
801007d9:	74 25                	je     80100800 <cprintf+0xb0>
801007db:	8d 53 01             	lea    0x1(%ebx),%edx
        if (c != '%') {
801007de:	83 f8 25             	cmp    $0x25,%eax
801007e1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801007e4:	74 aa                	je     80100790 <cprintf+0x40>
801007e6:	89 55 e0             	mov    %edx,-0x20(%ebp)
            consputc(c);
801007e9:	e8 12 fd ff ff       	call   80100500 <consputc>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
801007ee:	0f b6 06             	movzbl (%esi),%eax
            continue;
801007f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801007f4:	89 d3                	mov    %edx,%ebx
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
801007f6:	85 c0                	test   %eax,%eax
801007f8:	75 e1                	jne    801007db <cprintf+0x8b>
801007fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (locking) {
80100800:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100803:	85 c0                	test   %eax,%eax
80100805:	74 10                	je     80100817 <cprintf+0xc7>
        release(&cons.lock);
80100807:	83 ec 0c             	sub    $0xc,%esp
8010080a:	68 20 b5 10 80       	push   $0x8010b520
8010080f:	e8 3c 40 00 00       	call   80104850 <release>
80100814:	83 c4 10             	add    $0x10,%esp
}
80100817:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010081a:	5b                   	pop    %ebx
8010081b:	5e                   	pop    %esi
8010081c:	5f                   	pop    %edi
8010081d:	5d                   	pop    %ebp
8010081e:	c3                   	ret    
8010081f:	90                   	nop
        switch (c) {
80100820:	83 fa 73             	cmp    $0x73,%edx
80100823:	74 43                	je     80100868 <cprintf+0x118>
80100825:	83 fa 78             	cmp    $0x78,%edx
80100828:	75 1e                	jne    80100848 <cprintf+0xf8>
                printint(*argp++, 16, 0);
8010082a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010082d:	ba 10 00 00 00       	mov    $0x10,%edx
80100832:	8d 48 04             	lea    0x4(%eax),%ecx
80100835:	8b 00                	mov    (%eax),%eax
80100837:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010083a:	31 c9                	xor    %ecx,%ecx
8010083c:	e8 2f fe ff ff       	call   80100670 <printint>
                break;
80100841:	eb 91                	jmp    801007d4 <cprintf+0x84>
80100843:	90                   	nop
80100844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                consputc('%');
80100848:	b8 25 00 00 00       	mov    $0x25,%eax
8010084d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100850:	e8 ab fc ff ff       	call   80100500 <consputc>
                consputc(c);
80100855:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100858:	89 d0                	mov    %edx,%eax
8010085a:	e8 a1 fc ff ff       	call   80100500 <consputc>
                break;
8010085f:	e9 70 ff ff ff       	jmp    801007d4 <cprintf+0x84>
80100864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                if ((s = (char*)*argp++) == 0) {
80100868:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010086b:	8b 10                	mov    (%eax),%edx
8010086d:	8d 48 04             	lea    0x4(%eax),%ecx
80100870:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100873:	85 d2                	test   %edx,%edx
80100875:	74 49                	je     801008c0 <cprintf+0x170>
                for (; *s; s++) {
80100877:	0f be 02             	movsbl (%edx),%eax
                if ((s = (char*)*argp++) == 0) {
8010087a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
                for (; *s; s++) {
8010087d:	84 c0                	test   %al,%al
8010087f:	0f 84 4f ff ff ff    	je     801007d4 <cprintf+0x84>
80100885:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100888:	89 d3                	mov    %edx,%ebx
8010088a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100890:	83 c3 01             	add    $0x1,%ebx
                    consputc(*s);
80100893:	e8 68 fc ff ff       	call   80100500 <consputc>
                for (; *s; s++) {
80100898:	0f be 03             	movsbl (%ebx),%eax
8010089b:	84 c0                	test   %al,%al
8010089d:	75 f1                	jne    80100890 <cprintf+0x140>
                if ((s = (char*)*argp++) == 0) {
8010089f:	8b 45 e0             	mov    -0x20(%ebp),%eax
801008a2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801008a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801008a8:	e9 27 ff ff ff       	jmp    801007d4 <cprintf+0x84>
801008ad:	8d 76 00             	lea    0x0(%esi),%esi
                consputc('%');
801008b0:	b8 25 00 00 00       	mov    $0x25,%eax
801008b5:	e8 46 fc ff ff       	call   80100500 <consputc>
                break;
801008ba:	e9 15 ff ff ff       	jmp    801007d4 <cprintf+0x84>
801008bf:	90                   	nop
                    s = "(null)";
801008c0:	ba 58 74 10 80       	mov    $0x80107458,%edx
                for (; *s; s++) {
801008c5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801008c8:	b8 28 00 00 00       	mov    $0x28,%eax
801008cd:	89 d3                	mov    %edx,%ebx
801008cf:	eb bf                	jmp    80100890 <cprintf+0x140>
801008d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        acquire(&cons.lock);
801008d8:	83 ec 0c             	sub    $0xc,%esp
801008db:	68 20 b5 10 80       	push   $0x8010b520
801008e0:	e8 ab 3e 00 00       	call   80104790 <acquire>
801008e5:	83 c4 10             	add    $0x10,%esp
801008e8:	e9 7c fe ff ff       	jmp    80100769 <cprintf+0x19>
        panic("null fmt");
801008ed:	83 ec 0c             	sub    $0xc,%esp
801008f0:	68 5f 74 10 80       	push   $0x8010745f
801008f5:	e8 86 fb ff ff       	call   80100480 <panic>
801008fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100900 <consoleget>:
int consoleget(void) {
80100900:	55                   	push   %ebp
80100901:	89 e5                	mov    %esp,%ebp
80100903:	83 ec 24             	sub    $0x24,%esp
    acquire(&cons.lock);
80100906:	68 20 b5 10 80       	push   $0x8010b520
8010090b:	e8 80 3e 00 00       	call   80104790 <acquire>
    while ((c = kbdgetc()) <= 0) {
80100910:	83 c4 10             	add    $0x10,%esp
80100913:	eb 05                	jmp    8010091a <consoleget+0x1a>
80100915:	8d 76 00             	lea    0x0(%esi),%esi
        if (c == 0) {
80100918:	74 26                	je     80100940 <consoleget+0x40>
    while ((c = kbdgetc()) <= 0) {
8010091a:	e8 31 20 00 00       	call   80102950 <kbdgetc>
8010091f:	83 f8 00             	cmp    $0x0,%eax
80100922:	7e f4                	jle    80100918 <consoleget+0x18>
    release(&cons.lock);
80100924:	83 ec 0c             	sub    $0xc,%esp
80100927:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010092a:	68 20 b5 10 80       	push   $0x8010b520
8010092f:	e8 1c 3f 00 00       	call   80104850 <release>
}
80100934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100937:	c9                   	leave  
80100938:	c3                   	ret    
80100939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            c = kbdgetc();
80100940:	e8 0b 20 00 00       	call   80102950 <kbdgetc>
80100945:	eb d3                	jmp    8010091a <consoleget+0x1a>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleintr>:
void consoleintr(int (*getc)(void)) {
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	57                   	push   %edi
80100954:	56                   	push   %esi
80100955:	53                   	push   %ebx
    int c, doprocdump = 0;
80100956:	31 f6                	xor    %esi,%esi
void consoleintr(int (*getc)(void)) {
80100958:	83 ec 18             	sub    $0x18,%esp
8010095b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&cons.lock);
8010095e:	68 20 b5 10 80       	push   $0x8010b520
80100963:	e8 28 3e 00 00       	call   80104790 <acquire>
    while ((c = getc()) >= 0) {
80100968:	83 c4 10             	add    $0x10,%esp
8010096b:	90                   	nop
8010096c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100970:	ff d3                	call   *%ebx
80100972:	85 c0                	test   %eax,%eax
80100974:	89 c7                	mov    %eax,%edi
80100976:	78 48                	js     801009c0 <consoleintr+0x70>
        switch (c) {
80100978:	83 ff 10             	cmp    $0x10,%edi
8010097b:	0f 84 e7 00 00 00    	je     80100a68 <consoleintr+0x118>
80100981:	7e 5d                	jle    801009e0 <consoleintr+0x90>
80100983:	83 ff 15             	cmp    $0x15,%edi
80100986:	0f 84 ec 00 00 00    	je     80100a78 <consoleintr+0x128>
8010098c:	83 ff 7f             	cmp    $0x7f,%edi
8010098f:	75 54                	jne    801009e5 <consoleintr+0x95>
                if (input.e != input.w) {
80100991:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100996:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010099c:	74 d2                	je     80100970 <consoleintr+0x20>
                    input.e--;
8010099e:	83 e8 01             	sub    $0x1,%eax
801009a1:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
                    consputc(BACKSPACE);
801009a6:	b8 00 01 00 00       	mov    $0x100,%eax
801009ab:	e8 50 fb ff ff       	call   80100500 <consputc>
    while ((c = getc()) >= 0) {
801009b0:	ff d3                	call   *%ebx
801009b2:	85 c0                	test   %eax,%eax
801009b4:	89 c7                	mov    %eax,%edi
801009b6:	79 c0                	jns    80100978 <consoleintr+0x28>
801009b8:	90                   	nop
801009b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&cons.lock);
801009c0:	83 ec 0c             	sub    $0xc,%esp
801009c3:	68 20 b5 10 80       	push   $0x8010b520
801009c8:	e8 83 3e 00 00       	call   80104850 <release>
    if (doprocdump) {
801009cd:	83 c4 10             	add    $0x10,%esp
801009d0:	85 f6                	test   %esi,%esi
801009d2:	0f 85 f8 00 00 00    	jne    80100ad0 <consoleintr+0x180>
}
801009d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009db:	5b                   	pop    %ebx
801009dc:	5e                   	pop    %esi
801009dd:	5f                   	pop    %edi
801009de:	5d                   	pop    %ebp
801009df:	c3                   	ret    
        switch (c) {
801009e0:	83 ff 08             	cmp    $0x8,%edi
801009e3:	74 ac                	je     80100991 <consoleintr+0x41>
                if (c != 0 && input.e - input.r < INPUT_BUF) {
801009e5:	85 ff                	test   %edi,%edi
801009e7:	74 87                	je     80100970 <consoleintr+0x20>
801009e9:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801009ee:	89 c2                	mov    %eax,%edx
801009f0:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801009f6:	83 fa 7f             	cmp    $0x7f,%edx
801009f9:	0f 87 71 ff ff ff    	ja     80100970 <consoleintr+0x20>
801009ff:	8d 50 01             	lea    0x1(%eax),%edx
80100a02:	83 e0 7f             	and    $0x7f,%eax
                    c = (c == '\r') ? '\n' : c;
80100a05:	83 ff 0d             	cmp    $0xd,%edi
                    input.buf[input.e++ % INPUT_BUF] = c;
80100a08:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
                    c = (c == '\r') ? '\n' : c;
80100a0e:	0f 84 cc 00 00 00    	je     80100ae0 <consoleintr+0x190>
                    input.buf[input.e++ % INPUT_BUF] = c;
80100a14:	89 f9                	mov    %edi,%ecx
80100a16:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
                    consputc(c);
80100a1c:	89 f8                	mov    %edi,%eax
80100a1e:	e8 dd fa ff ff       	call   80100500 <consputc>
                    if (c == '\n' || c == C('D') || input.e == input.r + INPUT_BUF) {
80100a23:	83 ff 0a             	cmp    $0xa,%edi
80100a26:	0f 84 c5 00 00 00    	je     80100af1 <consoleintr+0x1a1>
80100a2c:	83 ff 04             	cmp    $0x4,%edi
80100a2f:	0f 84 bc 00 00 00    	je     80100af1 <consoleintr+0x1a1>
80100a35:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
80100a3a:	83 e8 80             	sub    $0xffffff80,%eax
80100a3d:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100a43:	0f 85 27 ff ff ff    	jne    80100970 <consoleintr+0x20>
                        wakeup(&input.r);
80100a49:	83 ec 0c             	sub    $0xc,%esp
                        input.w = input.e;
80100a4c:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
                        wakeup(&input.r);
80100a51:	68 a0 0f 11 80       	push   $0x80110fa0
80100a56:	e8 25 39 00 00       	call   80104380 <wakeup>
80100a5b:	83 c4 10             	add    $0x10,%esp
80100a5e:	e9 0d ff ff ff       	jmp    80100970 <consoleintr+0x20>
80100a63:	90                   	nop
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                doprocdump = 1;
80100a68:	be 01 00 00 00       	mov    $0x1,%esi
80100a6d:	e9 fe fe ff ff       	jmp    80100970 <consoleintr+0x20>
80100a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                while (input.e != input.w &&
80100a78:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100a7d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100a83:	75 2b                	jne    80100ab0 <consoleintr+0x160>
80100a85:	e9 e6 fe ff ff       	jmp    80100970 <consoleintr+0x20>
80100a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                    input.e--;
80100a90:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
                    consputc(BACKSPACE);
80100a95:	b8 00 01 00 00       	mov    $0x100,%eax
80100a9a:	e8 61 fa ff ff       	call   80100500 <consputc>
                while (input.e != input.w &&
80100a9f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100aa4:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100aaa:	0f 84 c0 fe ff ff    	je     80100970 <consoleintr+0x20>
                       input.buf[(input.e - 1) % INPUT_BUF] != '\n') {
80100ab0:	83 e8 01             	sub    $0x1,%eax
80100ab3:	89 c2                	mov    %eax,%edx
80100ab5:	83 e2 7f             	and    $0x7f,%edx
                while (input.e != input.w &&
80100ab8:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100abf:	75 cf                	jne    80100a90 <consoleintr+0x140>
80100ac1:	e9 aa fe ff ff       	jmp    80100970 <consoleintr+0x20>
80100ac6:	8d 76 00             	lea    0x0(%esi),%esi
80100ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100ad0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ad3:	5b                   	pop    %ebx
80100ad4:	5e                   	pop    %esi
80100ad5:	5f                   	pop    %edi
80100ad6:	5d                   	pop    %ebp
        procdump();  // now call procdump() wo. cons.lock held
80100ad7:	e9 84 39 00 00       	jmp    80104460 <procdump>
80100adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                    input.buf[input.e++ % INPUT_BUF] = c;
80100ae0:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
                    consputc(c);
80100ae7:	b8 0a 00 00 00       	mov    $0xa,%eax
80100aec:	e8 0f fa ff ff       	call   80100500 <consputc>
80100af1:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100af6:	e9 4e ff ff ff       	jmp    80100a49 <consoleintr+0xf9>
80100afb:	90                   	nop
80100afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100b00 <consoleinit>:
void consoleinit(void) {
80100b00:	55                   	push   %ebp
80100b01:	89 e5                	mov    %esp,%ebp
80100b03:	83 ec 10             	sub    $0x10,%esp
    initlock(&cons.lock, "console");
80100b06:	68 68 74 10 80       	push   $0x80107468
80100b0b:	68 20 b5 10 80       	push   $0x8010b520
80100b10:	e8 3b 3b 00 00       	call   80104650 <initlock>
    ioapicenable(IRQ_KBD, 0);
80100b15:	58                   	pop    %eax
80100b16:	5a                   	pop    %edx
80100b17:	6a 00                	push   $0x0
80100b19:	6a 01                	push   $0x1
    devsw[CONSOLE].write = consolewrite;
80100b1b:	c7 05 6c 19 11 80 f0 	movl   $0x801006f0,0x8011196c
80100b22:	06 10 80 
    devsw[CONSOLE].read = consoleread;
80100b25:	c7 05 68 19 11 80 60 	movl   $0x80100360,0x80111968
80100b2c:	03 10 80 
    cons.locking = 1;
80100b2f:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100b36:	00 00 00 
    ioapicenable(IRQ_KBD, 0);
80100b39:	e8 b2 1b 00 00       	call   801026f0 <ioapicenable>
}
80100b3e:	83 c4 10             	add    $0x10,%esp
80100b41:	c9                   	leave  
80100b42:	c3                   	ret    
80100b43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100b50 <consolevgaplane>:
void consolevgaplane(uchar plane) {
80100b50:	55                   	push   %ebp
80100b51:	b8 04 00 00 00       	mov    $0x4,%eax
80100b56:	ba ce 03 00 00       	mov    $0x3ce,%edx
80100b5b:	89 e5                	mov    %esp,%ebp
    plane &= 3;
80100b5d:	0f b6 4d 08          	movzbl 0x8(%ebp),%ecx
80100b61:	83 e1 03             	and    $0x3,%ecx
80100b64:	ee                   	out    %al,(%dx)
80100b65:	ba cf 03 00 00       	mov    $0x3cf,%edx
80100b6a:	89 c8                	mov    %ecx,%eax
80100b6c:	ee                   	out    %al,(%dx)
80100b6d:	b8 02 00 00 00       	mov    $0x2,%eax
80100b72:	ba c4 03 00 00       	mov    $0x3c4,%edx
80100b77:	ee                   	out    %al,(%dx)
    planeMask = 1 << plane;
80100b78:	b8 01 00 00 00       	mov    $0x1,%eax
80100b7d:	ba c5 03 00 00       	mov    $0x3c5,%edx
80100b82:	d3 e0                	shl    %cl,%eax
80100b84:	ee                   	out    %al,(%dx)
}
80100b85:	5d                   	pop    %ebp
80100b86:	c3                   	ret    
80100b87:	89 f6                	mov    %esi,%esi
80100b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100b90 <writeFont>:

void writeFont(uchar * fontBuffer, unsigned int fontHeight) {
80100b90:	55                   	push   %ebp
80100b91:	b8 02 00 00 00       	mov    $0x2,%eax
80100b96:	ba c4 03 00 00       	mov    $0x3c4,%edx
80100b9b:	89 e5                	mov    %esp,%ebp
80100b9d:	57                   	push   %edi
80100b9e:	56                   	push   %esi
80100b9f:	53                   	push   %ebx
80100ba0:	83 ec 1c             	sub    $0x1c,%esp
80100ba3:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100ba6:	8b 75 0c             	mov    0xc(%ebp),%esi
80100ba9:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100baa:	ba c5 03 00 00       	mov    $0x3c5,%edx
80100baf:	ec                   	in     (%dx),%al
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100bb0:	ba c4 03 00 00       	mov    $0x3c4,%edx
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100bb5:	88 45 e7             	mov    %al,-0x19(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100bb8:	b8 04 00 00 00       	mov    $0x4,%eax
80100bbd:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100bbe:	ba c5 03 00 00       	mov    $0x3c5,%edx
80100bc3:	ec                   	in     (%dx),%al
    outb(VGA_SEQ_INDEX, 2);
    seq2 = inb(VGA_SEQ_DATA);

    outb(VGA_SEQ_INDEX, 4);
    seq4 = inb(VGA_SEQ_DATA);
    outb(VGA_SEQ_DATA, seq4 | 0x04);
80100bc4:	89 c1                	mov    %eax,%ecx
80100bc6:	88 45 e6             	mov    %al,-0x1a(%ebp)
80100bc9:	83 c9 04             	or     $0x4,%ecx
80100bcc:	89 c8                	mov    %ecx,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100bce:	ee                   	out    %al,(%dx)
80100bcf:	bf ce 03 00 00       	mov    $0x3ce,%edi
80100bd4:	b8 04 00 00 00       	mov    $0x4,%eax
80100bd9:	89 fa                	mov    %edi,%edx
80100bdb:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100bdc:	b9 cf 03 00 00       	mov    $0x3cf,%ecx
80100be1:	89 ca                	mov    %ecx,%edx
80100be3:	ec                   	in     (%dx),%al
80100be4:	88 45 e5             	mov    %al,-0x1b(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100be7:	89 fa                	mov    %edi,%edx
80100be9:	b8 05 00 00 00       	mov    $0x5,%eax
80100bee:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100bef:	89 ca                	mov    %ecx,%edx
80100bf1:	ec                   	in     (%dx),%al
80100bf2:	88 45 e4             	mov    %al,-0x1c(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100bf5:	83 e0 ef             	and    $0xffffffef,%eax
80100bf8:	ee                   	out    %al,(%dx)
80100bf9:	b8 06 00 00 00       	mov    $0x6,%eax
80100bfe:	89 fa                	mov    %edi,%edx
80100c00:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100c01:	89 ca                	mov    %ecx,%edx
80100c03:	ec                   	in     (%dx),%al
80100c04:	88 45 e3             	mov    %al,-0x1d(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80100c07:	83 e0 fd             	and    $0xfffffffd,%eax
80100c0a:	ee                   	out    %al,(%dx)
80100c0b:	b8 04 00 00 00       	mov    $0x4,%eax
80100c10:	89 fa                	mov    %edi,%edx
80100c12:	ee                   	out    %al,(%dx)
80100c13:	b8 02 00 00 00       	mov    $0x2,%eax
80100c18:	89 ca                	mov    %ecx,%edx
80100c1a:	ee                   	out    %al,(%dx)
80100c1b:	ba c4 03 00 00       	mov    $0x3c4,%edx
80100c20:	ee                   	out    %al,(%dx)
80100c21:	b8 04 00 00 00       	mov    $0x4,%eax
80100c26:	ba c5 03 00 00       	mov    $0x3c5,%edx
80100c2b:	ee                   	out    %al,(%dx)
    gc6 = inb(VGA_GC_DATA);
    outb(VGA_GC_DATA, gc6 & ~0x02);

    consolevgaplane(2);
    // Write font to video memory
    fontBase = (uchar*)P2V(0xB8000);
80100c2c:	bf 00 80 0b 80       	mov    $0x800b8000,%edi
80100c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (i = 0; i < 256; i++)
    {
        memmove((ushort*)fontBase, fontBuffer, fontHeight);
80100c38:	83 ec 04             	sub    $0x4,%esp
80100c3b:	56                   	push   %esi
80100c3c:	53                   	push   %ebx
        fontBase += 32;
        fontBuffer += fontHeight;
80100c3d:	01 f3                	add    %esi,%ebx
        memmove((ushort*)fontBase, fontBuffer, fontHeight);
80100c3f:	57                   	push   %edi
        fontBase += 32;
80100c40:	83 c7 20             	add    $0x20,%edi
        memmove((ushort*)fontBase, fontBuffer, fontHeight);
80100c43:	e8 08 3d 00 00       	call   80104950 <memmove>
    for (i = 0; i < 256; i++)
80100c48:	83 c4 10             	add    $0x10,%esp
80100c4b:	81 ff 00 a0 0b 80    	cmp    $0x800ba000,%edi
80100c51:	75 e5                	jne    80100c38 <writeFont+0xa8>
80100c53:	be c4 03 00 00       	mov    $0x3c4,%esi
80100c58:	b8 02 00 00 00       	mov    $0x2,%eax
80100c5d:	89 f2                	mov    %esi,%edx
80100c5f:	ee                   	out    %al,(%dx)
80100c60:	bb c5 03 00 00       	mov    $0x3c5,%ebx
80100c65:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80100c69:	89 da                	mov    %ebx,%edx
80100c6b:	ee                   	out    %al,(%dx)
80100c6c:	b9 04 00 00 00       	mov    $0x4,%ecx
80100c71:	89 f2                	mov    %esi,%edx
80100c73:	89 c8                	mov    %ecx,%eax
80100c75:	ee                   	out    %al,(%dx)
80100c76:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
80100c7a:	89 da                	mov    %ebx,%edx
80100c7c:	ee                   	out    %al,(%dx)
80100c7d:	bb ce 03 00 00       	mov    $0x3ce,%ebx
80100c82:	89 c8                	mov    %ecx,%eax
80100c84:	89 da                	mov    %ebx,%edx
80100c86:	ee                   	out    %al,(%dx)
80100c87:	b9 cf 03 00 00       	mov    $0x3cf,%ecx
80100c8c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
80100c90:	89 ca                	mov    %ecx,%edx
80100c92:	ee                   	out    %al,(%dx)
80100c93:	b8 05 00 00 00       	mov    $0x5,%eax
80100c98:	89 da                	mov    %ebx,%edx
80100c9a:	ee                   	out    %al,(%dx)
80100c9b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80100c9f:	89 ca                	mov    %ecx,%edx
80100ca1:	ee                   	out    %al,(%dx)
80100ca2:	b8 06 00 00 00       	mov    $0x6,%eax
80100ca7:	89 da                	mov    %ebx,%edx
80100ca9:	ee                   	out    %al,(%dx)
80100caa:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
80100cae:	89 ca                	mov    %ecx,%edx
80100cb0:	ee                   	out    %al,(%dx)
    outb(VGA_GC_DATA, gc4);
    outb(VGA_GC_INDEX, 5);
    outb(VGA_GC_DATA, gc5);
    outb(VGA_GC_INDEX, 6);
    outb(VGA_GC_DATA, gc6); 
}
80100cb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100cb4:	5b                   	pop    %ebx
80100cb5:	5e                   	pop    %esi
80100cb6:	5f                   	pop    %edi
80100cb7:	5d                   	pop    %ebp
80100cb8:	c3                   	ret    
80100cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100cc0 <consolevgamode>:
 * Currently, only these modes are supported:
 *   0x03: 80x25 text mode.
 *   0x12: 640x480x16 graphics mode.
 *   0x13: 320x200x256 graphics mode.
 */
int consolevgamode(int vgamode) {
80100cc0:	55                   	push   %ebp
80100cc1:	89 e5                	mov    %esp,%ebp
80100cc3:	53                   	push   %ebx
80100cc4:	83 ec 10             	sub    $0x10,%esp
80100cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&cons.lock);
80100cca:	68 20 b5 10 80       	push   $0x8010b520
80100ccf:	e8 bc 3a 00 00       	call   80104790 <acquire>

    int errorcode = -1;

    switch (vgamode)
80100cd4:	83 c4 10             	add    $0x10,%esp
80100cd7:	83 fb 12             	cmp    $0x12,%ebx
80100cda:	74 74                	je     80100d50 <consolevgamode+0x90>
80100cdc:	83 fb 13             	cmp    $0x13,%ebx
80100cdf:	74 4f                	je     80100d30 <consolevgamode+0x70>
80100ce1:	83 fb 03             	cmp    $0x3,%ebx
80100ce4:	74 1a                	je     80100d00 <consolevgamode+0x40>
    int errorcode = -1;
80100ce6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
            currentvgamode = 0x13;
            errorcode = 0;
        } break;
    }

    release(&cons.lock);
80100ceb:	83 ec 0c             	sub    $0xc,%esp
80100cee:	68 20 b5 10 80       	push   $0x8010b520
80100cf3:	e8 58 3b 00 00       	call   80104850 <release>

    return errorcode;
}
80100cf8:	89 d8                	mov    %ebx,%eax
80100cfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cfd:	c9                   	leave  
80100cfe:	c3                   	ret    
80100cff:	90                   	nop
            writeVideoRegisters(registers_80x25_text);
80100d00:	b8 80 90 10 80       	mov    $0x80109080,%eax
            errorcode = 0;
80100d05:	31 db                	xor    %ebx,%ebx
            writeVideoRegisters(registers_80x25_text);
80100d07:	e8 64 f5 ff ff       	call   80100270 <writeVideoRegisters>
            writeFont(font_8x16, 16);
80100d0c:	83 ec 08             	sub    $0x8,%esp
80100d0f:	6a 10                	push   $0x10
80100d11:	68 00 80 10 80       	push   $0x80108000
80100d16:	e8 75 fe ff ff       	call   80100b90 <writeFont>
            currentvgamode = 0x03;
80100d1b:	c7 05 c0 90 10 80 03 	movl   $0x3,0x801090c0
80100d22:	00 00 00 
        } break;
80100d25:	83 c4 10             	add    $0x10,%esp
80100d28:	eb c1                	jmp    80100ceb <consolevgamode+0x2b>
80100d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            writeVideoRegisters(registers_320x200x256);
80100d30:	b8 40 90 10 80       	mov    $0x80109040,%eax
            errorcode = 0;
80100d35:	31 db                	xor    %ebx,%ebx
            writeVideoRegisters(registers_320x200x256);
80100d37:	e8 34 f5 ff ff       	call   80100270 <writeVideoRegisters>
            currentvgamode = 0x13;
80100d3c:	c7 05 c0 90 10 80 13 	movl   $0x13,0x801090c0
80100d43:	00 00 00 
        } break;
80100d46:	eb a3                	jmp    80100ceb <consolevgamode+0x2b>
80100d48:	90                   	nop
80100d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            writeVideoRegisters(registers_640x480x16);
80100d50:	b8 00 90 10 80       	mov    $0x80109000,%eax
            errorcode = 0;
80100d55:	31 db                	xor    %ebx,%ebx
            writeVideoRegisters(registers_640x480x16);
80100d57:	e8 14 f5 ff ff       	call   80100270 <writeVideoRegisters>
            currentvgamode = 0x12;
80100d5c:	c7 05 c0 90 10 80 12 	movl   $0x12,0x801090c0
80100d63:	00 00 00 
        } break;
80100d66:	eb 83                	jmp    80100ceb <consolevgamode+0x2b>
80100d68:	90                   	nop
80100d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100d70 <consolevgabuffer>:
 * http://www.osdever.net/FreeVGA/vga/vgamem.htm will give you more insight into what is going on.
 *
 * Returns a pointer to the virtual address (NOT the physical address) associated with the current
 * video plane.
 */
uchar* consolevgabuffer() {
80100d70:	55                   	push   %ebp
80100d71:	b8 06 00 00 00       	mov    $0x6,%eax
80100d76:	ba ce 03 00 00       	mov    $0x3ce,%edx
80100d7b:	89 e5                	mov    %esp,%ebp
80100d7d:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80100d7e:	ba cf 03 00 00       	mov    $0x3cf,%edx
80100d83:	ec                   	in     (%dx),%al
80100d84:	89 c2                	mov    %eax,%edx
80100d86:	b8 00 00 0b 80       	mov    $0x800b0000,%eax
    uchar plane;

    outb(VGA_GC_INDEX, 6);

    plane = inb(VGA_GC_DATA);
    plane >>= 2;
80100d8b:	c0 ea 02             	shr    $0x2,%dl
    plane &= 3;
80100d8e:	83 e2 03             	and    $0x3,%edx

    switch (plane)
80100d91:	80 fa 02             	cmp    $0x2,%dl
80100d94:	74 10                	je     80100da6 <consolevgabuffer+0x36>
    {
    case 0:
    case 1:
        base = (uchar*)P2V(0xA0000);
80100d96:	80 fa 03             	cmp    $0x3,%dl
80100d99:	b8 00 80 0b 80       	mov    $0x800b8000,%eax
80100d9e:	ba 00 00 0a 80       	mov    $0x800a0000,%edx
80100da3:	0f 45 c2             	cmovne %edx,%eax
        base = (uchar*)P2V(0xB8000);
        break;
    }

    return base;
}
80100da6:	5d                   	pop    %ebp
80100da7:	c3                   	ret    
80100da8:	66 90                	xchg   %ax,%ax
80100daa:	66 90                	xchg   %ax,%ax
80100dac:	66 90                	xchg   %ax,%ax
80100dae:	66 90                	xchg   %ax,%ax

80100db0 <cleanupexec>:
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

void cleanupexec(pde_t * pgdir, struct inode *ip) {
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	53                   	push   %ebx
80100db4:	83 ec 04             	sub    $0x4,%esp
80100db7:	8b 45 08             	mov    0x8(%ebp),%eax
80100dba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (pgdir) {
80100dbd:	85 c0                	test   %eax,%eax
80100dbf:	74 0c                	je     80100dcd <cleanupexec+0x1d>
        freevm(pgdir);
80100dc1:	83 ec 0c             	sub    $0xc,%esp
80100dc4:	50                   	push   %eax
80100dc5:	e8 f6 62 00 00       	call   801070c0 <freevm>
80100dca:	83 c4 10             	add    $0x10,%esp
    }
    if (ip) {
80100dcd:	85 db                	test   %ebx,%ebx
80100dcf:	74 1f                	je     80100df0 <cleanupexec+0x40>
        iunlockput(ip);
80100dd1:	83 ec 0c             	sub    $0xc,%esp
80100dd4:	53                   	push   %ebx
80100dd5:	e8 56 0f 00 00       	call   80101d30 <iunlockput>
        end_op();
80100dda:	83 c4 10             	add    $0x10,%esp
    }    
}
80100ddd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de0:	c9                   	leave  
        end_op();
80100de1:	e9 4a 22 00 00       	jmp    80103030 <end_op>
80100de6:	8d 76 00             	lea    0x0(%esi),%esi
80100de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100df0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100df3:	c9                   	leave  
80100df4:	c3                   	ret    
80100df5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e00 <exec>:

int exec(char *path, char **argv) {
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	57                   	push   %edi
80100e04:	56                   	push   %esi
80100e05:	53                   	push   %ebx
80100e06:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
    uint argc, sz, sp, ustack[3 + MAXARG + 1];
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pde_t *pgdir, *oldpgdir;
    struct proc *curproc = myproc();
80100e0c:	e8 1f 2e 00 00       	call   80103c30 <myproc>
80100e11:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

    begin_op();
80100e17:	e8 a4 21 00 00       	call   80102fc0 <begin_op>

    if ((ip = namei(path)) == 0) {
80100e1c:	83 ec 0c             	sub    $0xc,%esp
80100e1f:	ff 75 08             	pushl  0x8(%ebp)
80100e22:	e8 d9 14 00 00       	call   80102300 <namei>
80100e27:	83 c4 10             	add    $0x10,%esp
80100e2a:	85 c0                	test   %eax,%eax
80100e2c:	0f 84 2e 03 00 00    	je     80101160 <exec+0x360>
        end_op();
        cprintf("exec: fail\n");
        return -1;
    }
    ilock(ip);
80100e32:	83 ec 0c             	sub    $0xc,%esp
80100e35:	89 c6                	mov    %eax,%esi
80100e37:	50                   	push   %eax
80100e38:	e8 63 0c 00 00       	call   80101aa0 <ilock>
    pgdir = 0;

    // Check ELF header
    if (readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf)) {
80100e3d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100e43:	6a 34                	push   $0x34
80100e45:	6a 00                	push   $0x0
80100e47:	50                   	push   %eax
80100e48:	56                   	push   %esi
80100e49:	e8 32 0f 00 00       	call   80101d80 <readi>
80100e4e:	83 c4 20             	add    $0x20,%esp
80100e51:	83 f8 34             	cmp    $0x34,%eax
80100e54:	0f 85 c0 02 00 00    	jne    8010111a <exec+0x31a>
        cleanupexec(pgdir, ip);
        return -1;
    }
    if (elf.magic != ELF_MAGIC) {
80100e5a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100e61:	45 4c 46 
80100e64:	0f 85 b0 02 00 00    	jne    8010111a <exec+0x31a>
        cleanupexec(pgdir, ip);
        return -1;        
    }

    if ((pgdir = setupkvm()) == 0) {
80100e6a:	e8 d1 62 00 00       	call   80107140 <setupkvm>
80100e6f:	85 c0                	test   %eax,%eax
80100e71:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100e77:	0f 84 9d 02 00 00    	je     8010111a <exec+0x31a>
        cleanupexec(pgdir, ip);
        return -1;    
    }

    // Load program into memory.
    sz = 0;
80100e7d:	31 ff                	xor    %edi,%edi
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100e7f:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100e86:	00 
80100e87:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100e8d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100e93:	0f 84 99 02 00 00    	je     80101132 <exec+0x332>
80100e99:	31 db                	xor    %ebx,%ebx
80100e9b:	eb 7d                	jmp    80100f1a <exec+0x11a>
80100e9d:	8d 76 00             	lea    0x0(%esi),%esi
        if (readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph)) {
            cleanupexec(pgdir, ip);
            return -1;    
        }
        if (ph.type != ELF_PROG_LOAD) {
80100ea0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ea7:	75 63                	jne    80100f0c <exec+0x10c>
            continue;
        }
        if (ph.memsz < ph.filesz) {
80100ea9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100eaf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100eb5:	0f 82 86 00 00 00    	jb     80100f41 <exec+0x141>
80100ebb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ec1:	72 7e                	jb     80100f41 <exec+0x141>
        }
        if (ph.vaddr + ph.memsz < ph.vaddr) {
            cleanupexec(pgdir, ip);
            return -1;    
        }
        if ((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0) {
80100ec3:	83 ec 04             	sub    $0x4,%esp
80100ec6:	50                   	push   %eax
80100ec7:	57                   	push   %edi
80100ec8:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ece:	e8 8d 60 00 00       	call   80106f60 <allocuvm>
80100ed3:	83 c4 10             	add    $0x10,%esp
80100ed6:	85 c0                	test   %eax,%eax
80100ed8:	89 c7                	mov    %eax,%edi
80100eda:	74 65                	je     80100f41 <exec+0x141>
            cleanupexec(pgdir, ip);
            return -1;    
        }
        if (ph.vaddr % PGSIZE != 0) {
80100edc:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ee2:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ee7:	75 58                	jne    80100f41 <exec+0x141>
            cleanupexec(pgdir, ip);
            return -1;    
        }
        if (loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0) {
80100ee9:	83 ec 0c             	sub    $0xc,%esp
80100eec:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100ef2:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ef8:	56                   	push   %esi
80100ef9:	50                   	push   %eax
80100efa:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f00:	e8 9b 5f 00 00       	call   80106ea0 <loaduvm>
80100f05:	83 c4 20             	add    $0x20,%esp
80100f08:	85 c0                	test   %eax,%eax
80100f0a:	78 35                	js     80100f41 <exec+0x141>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80100f0c:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100f13:	83 c3 01             	add    $0x1,%ebx
80100f16:	39 d8                	cmp    %ebx,%eax
80100f18:	7e 46                	jle    80100f60 <exec+0x160>
        if (readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph)) {
80100f1a:	89 d8                	mov    %ebx,%eax
80100f1c:	6a 20                	push   $0x20
80100f1e:	c1 e0 05             	shl    $0x5,%eax
80100f21:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100f27:	50                   	push   %eax
80100f28:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100f2e:	50                   	push   %eax
80100f2f:	56                   	push   %esi
80100f30:	e8 4b 0e 00 00       	call   80101d80 <readi>
80100f35:	83 c4 10             	add    $0x10,%esp
80100f38:	83 f8 20             	cmp    $0x20,%eax
80100f3b:	0f 84 5f ff ff ff    	je     80100ea0 <exec+0xa0>
            cleanupexec(pgdir, ip);
80100f41:	83 ec 08             	sub    $0x8,%esp
80100f44:	56                   	push   %esi
80100f45:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f4b:	e8 60 fe ff ff       	call   80100db0 <cleanupexec>
            return -1;    
80100f50:	83 c4 10             	add    $0x10,%esp
80100f53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    curproc->tf->eip = elf.entry;  // main
    curproc->tf->esp = sp;
    switchuvm(curproc);
    freevm(oldpgdir);
    return 0;
}
80100f58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5b:	5b                   	pop    %ebx
80100f5c:	5e                   	pop    %esi
80100f5d:	5f                   	pop    %edi
80100f5e:	5d                   	pop    %ebp
80100f5f:	c3                   	ret    
80100f60:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100f66:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100f6c:	8d 9f 00 20 00 00    	lea    0x2000(%edi),%ebx
    iunlockput(ip);
80100f72:	83 ec 0c             	sub    $0xc,%esp
80100f75:	56                   	push   %esi
80100f76:	e8 b5 0d 00 00       	call   80101d30 <iunlockput>
    end_op();
80100f7b:	e8 b0 20 00 00       	call   80103030 <end_op>
    if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0) {
80100f80:	83 c4 0c             	add    $0xc,%esp
80100f83:	53                   	push   %ebx
80100f84:	57                   	push   %edi
80100f85:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f8b:	e8 d0 5f 00 00       	call   80106f60 <allocuvm>
80100f90:	83 c4 10             	add    $0x10,%esp
80100f93:	85 c0                	test   %eax,%eax
80100f95:	89 c7                	mov    %eax,%edi
80100f97:	0f 84 8c 00 00 00    	je     80101029 <exec+0x229>
    clearpteu(pgdir, (char*)(sz - 2 * PGSIZE));
80100f9d:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100fa3:	83 ec 08             	sub    $0x8,%esp
    for (argc = 0; argv[argc]; argc++) {
80100fa6:	31 f6                	xor    %esi,%esi
80100fa8:	89 fb                	mov    %edi,%ebx
    clearpteu(pgdir, (char*)(sz - 2 * PGSIZE));
80100faa:	50                   	push   %eax
80100fab:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100fb1:	e8 2a 62 00 00       	call   801071e0 <clearpteu>
    for (argc = 0; argv[argc]; argc++) {
80100fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fb9:	83 c4 10             	add    $0x10,%esp
80100fbc:	8b 08                	mov    (%eax),%ecx
80100fbe:	85 c9                	test   %ecx,%ecx
80100fc0:	0f 84 76 01 00 00    	je     8010113c <exec+0x33c>
80100fc6:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100fcc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100fcf:	eb 25                	jmp    80100ff6 <exec+0x1f6>
80100fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fd8:	8d 46 01             	lea    0x1(%esi),%eax
        ustack[3 + argc] = sp;
80100fdb:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100fe1:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
    for (argc = 0; argv[argc]; argc++) {
80100fe8:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80100feb:	85 c9                	test   %ecx,%ecx
80100fed:	74 5a                	je     80101049 <exec+0x249>
        if (argc >= MAXARG) {
80100fef:	83 f8 20             	cmp    $0x20,%eax
80100ff2:	74 35                	je     80101029 <exec+0x229>
80100ff4:	89 c6                	mov    %eax,%esi
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ff6:	83 ec 0c             	sub    $0xc,%esp
80100ff9:	51                   	push   %ecx
80100ffa:	e8 c1 3a 00 00       	call   80104ac0 <strlen>
80100fff:	f7 d0                	not    %eax
80101001:	01 c3                	add    %eax,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0) {
80101003:	58                   	pop    %eax
80101004:	ff 34 b7             	pushl  (%edi,%esi,4)
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101007:	83 e3 fc             	and    $0xfffffffc,%ebx
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0) {
8010100a:	e8 b1 3a 00 00       	call   80104ac0 <strlen>
8010100f:	83 c0 01             	add    $0x1,%eax
80101012:	50                   	push   %eax
80101013:	ff 34 b7             	pushl  (%edi,%esi,4)
80101016:	53                   	push   %ebx
80101017:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010101d:	e8 3e 63 00 00       	call   80107360 <copyout>
80101022:	83 c4 20             	add    $0x20,%esp
80101025:	85 c0                	test   %eax,%eax
80101027:	79 af                	jns    80100fd8 <exec+0x1d8>
        cleanupexec(pgdir, ip);
80101029:	83 ec 08             	sub    $0x8,%esp
8010102c:	6a 00                	push   $0x0
8010102e:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101034:	e8 77 fd ff ff       	call   80100db0 <cleanupexec>
        return -1;    
80101039:	83 c4 10             	add    $0x10,%esp
}
8010103c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;    
8010103f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101044:	5b                   	pop    %ebx
80101045:	5e                   	pop    %esi
80101046:	5f                   	pop    %edi
80101047:	5d                   	pop    %ebp
80101048:	c3                   	ret    
80101049:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
8010104f:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101055:	8d 46 04             	lea    0x4(%esi),%eax
80101058:	8d 34 b5 08 00 00 00 	lea    0x8(,%esi,4),%esi
8010105f:	8d 4e 0c             	lea    0xc(%esi),%ecx
    ustack[3 + argc] = 0;
80101062:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80101069:	00 00 00 00 
    ustack[1] = argc;
8010106d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0) {
80101073:	51                   	push   %ecx
80101074:	52                   	push   %edx
    ustack[0] = 0xffffffff;  // fake return PC
80101075:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010107c:	ff ff ff 
    ustack[1] = argc;
8010107f:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80101085:	89 d8                	mov    %ebx,%eax
    sp -= (3 + argc + 1) * 4;
80101087:	29 cb                	sub    %ecx,%ebx
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0) {
80101089:	53                   	push   %ebx
8010108a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
    ustack[2] = sp - (argc + 1) * 4;  // argv pointer
80101090:	29 f0                	sub    %esi,%eax
80101092:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0) {
80101098:	e8 c3 62 00 00       	call   80107360 <copyout>
8010109d:	83 c4 10             	add    $0x10,%esp
801010a0:	85 c0                	test   %eax,%eax
801010a2:	78 85                	js     80101029 <exec+0x229>
    for (last = s = path; *s; s++) {
801010a4:	8b 45 08             	mov    0x8(%ebp),%eax
801010a7:	8b 55 08             	mov    0x8(%ebp),%edx
801010aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
801010ad:	0f b6 00             	movzbl (%eax),%eax
801010b0:	84 c0                	test   %al,%al
801010b2:	74 13                	je     801010c7 <exec+0x2c7>
801010b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010b8:	83 c1 01             	add    $0x1,%ecx
801010bb:	3c 2f                	cmp    $0x2f,%al
801010bd:	0f b6 01             	movzbl (%ecx),%eax
801010c0:	0f 44 d1             	cmove  %ecx,%edx
801010c3:	84 c0                	test   %al,%al
801010c5:	75 f1                	jne    801010b8 <exec+0x2b8>
    safestrcpy(curproc->name, last, sizeof(curproc->name));
801010c7:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
801010cd:	83 ec 04             	sub    $0x4,%esp
801010d0:	6a 10                	push   $0x10
801010d2:	52                   	push   %edx
801010d3:	8d 46 6c             	lea    0x6c(%esi),%eax
801010d6:	50                   	push   %eax
801010d7:	e8 a4 39 00 00       	call   80104a80 <safestrcpy>
    curproc->pgdir = pgdir;
801010dc:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    oldpgdir = curproc->pgdir;
801010e2:	89 f0                	mov    %esi,%eax
801010e4:	8b 76 04             	mov    0x4(%esi),%esi
    curproc->sz = sz;
801010e7:	89 38                	mov    %edi,(%eax)
    curproc->pgdir = pgdir;
801010e9:	89 48 04             	mov    %ecx,0x4(%eax)
    curproc->tf->eip = elf.entry;  // main
801010ec:	89 c1                	mov    %eax,%ecx
801010ee:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801010f4:	8b 40 18             	mov    0x18(%eax),%eax
801010f7:	89 50 38             	mov    %edx,0x38(%eax)
    curproc->tf->esp = sp;
801010fa:	8b 41 18             	mov    0x18(%ecx),%eax
801010fd:	89 58 44             	mov    %ebx,0x44(%eax)
    switchuvm(curproc);
80101100:	89 0c 24             	mov    %ecx,(%esp)
80101103:	e8 08 5c 00 00       	call   80106d10 <switchuvm>
    freevm(oldpgdir);
80101108:	89 34 24             	mov    %esi,(%esp)
8010110b:	e8 b0 5f 00 00       	call   801070c0 <freevm>
    return 0;
80101110:	83 c4 10             	add    $0x10,%esp
80101113:	31 c0                	xor    %eax,%eax
80101115:	e9 3e fe ff ff       	jmp    80100f58 <exec+0x158>
        cleanupexec(pgdir, ip);
8010111a:	83 ec 08             	sub    $0x8,%esp
8010111d:	56                   	push   %esi
8010111e:	6a 00                	push   $0x0
80101120:	e8 8b fc ff ff       	call   80100db0 <cleanupexec>
        return -1;    
80101125:	83 c4 10             	add    $0x10,%esp
80101128:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010112d:	e9 26 fe ff ff       	jmp    80100f58 <exec+0x158>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
80101132:	bb 00 20 00 00       	mov    $0x2000,%ebx
80101137:	e9 36 fe ff ff       	jmp    80100f72 <exec+0x172>
    for (argc = 0; argv[argc]; argc++) {
8010113c:	b9 10 00 00 00       	mov    $0x10,%ecx
80101141:	be 04 00 00 00       	mov    $0x4,%esi
80101146:	b8 03 00 00 00       	mov    $0x3,%eax
8010114b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101152:	00 00 00 
80101155:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
8010115b:	e9 02 ff ff ff       	jmp    80101062 <exec+0x262>
        end_op();
80101160:	e8 cb 1e 00 00       	call   80103030 <end_op>
        cprintf("exec: fail\n");
80101165:	83 ec 0c             	sub    $0xc,%esp
80101168:	68 81 74 10 80       	push   $0x80107481
8010116d:	e8 de f5 ff ff       	call   80100750 <cprintf>
        return -1;
80101172:	83 c4 10             	add    $0x10,%esp
80101175:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010117a:	e9 d9 fd ff ff       	jmp    80100f58 <exec+0x158>
8010117f:	90                   	nop

80101180 <fileinit>:
struct {
    struct spinlock lock;
    struct file file[NFILE];
} ftable;

void fileinit(void) {
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	83 ec 10             	sub    $0x10,%esp
    initlock(&ftable.lock, "ftable");
80101186:	68 8d 74 10 80       	push   $0x8010748d
8010118b:	68 c0 0f 11 80       	push   $0x80110fc0
80101190:	e8 bb 34 00 00       	call   80104650 <initlock>
}
80101195:	83 c4 10             	add    $0x10,%esp
80101198:	c9                   	leave  
80101199:	c3                   	ret    
8010119a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801011a0 <filealloc>:

// Allocate a file structure.
struct file* filealloc(void) {
801011a0:	55                   	push   %ebp
801011a1:	89 e5                	mov    %esp,%ebp
801011a3:	53                   	push   %ebx
    struct file *f;

    acquire(&ftable.lock);
    for (f = ftable.file; f < ftable.file + NFILE; f++) {
801011a4:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
struct file* filealloc(void) {
801011a9:	83 ec 10             	sub    $0x10,%esp
    acquire(&ftable.lock);
801011ac:	68 c0 0f 11 80       	push   $0x80110fc0
801011b1:	e8 da 35 00 00       	call   80104790 <acquire>
801011b6:	83 c4 10             	add    $0x10,%esp
801011b9:	eb 10                	jmp    801011cb <filealloc+0x2b>
801011bb:	90                   	nop
801011bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (f = ftable.file; f < ftable.file + NFILE; f++) {
801011c0:	83 c3 18             	add    $0x18,%ebx
801011c3:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
801011c9:	73 25                	jae    801011f0 <filealloc+0x50>
        if (f->ref == 0) {
801011cb:	8b 43 04             	mov    0x4(%ebx),%eax
801011ce:	85 c0                	test   %eax,%eax
801011d0:	75 ee                	jne    801011c0 <filealloc+0x20>
            f->ref = 1;
            release(&ftable.lock);
801011d2:	83 ec 0c             	sub    $0xc,%esp
            f->ref = 1;
801011d5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
            release(&ftable.lock);
801011dc:	68 c0 0f 11 80       	push   $0x80110fc0
801011e1:	e8 6a 36 00 00       	call   80104850 <release>
            return f;
        }
    }
    release(&ftable.lock);
    return 0;
}
801011e6:	89 d8                	mov    %ebx,%eax
            return f;
801011e8:	83 c4 10             	add    $0x10,%esp
}
801011eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011ee:	c9                   	leave  
801011ef:	c3                   	ret    
    release(&ftable.lock);
801011f0:	83 ec 0c             	sub    $0xc,%esp
    return 0;
801011f3:	31 db                	xor    %ebx,%ebx
    release(&ftable.lock);
801011f5:	68 c0 0f 11 80       	push   $0x80110fc0
801011fa:	e8 51 36 00 00       	call   80104850 <release>
}
801011ff:	89 d8                	mov    %ebx,%eax
    return 0;
80101201:	83 c4 10             	add    $0x10,%esp
}
80101204:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101207:	c9                   	leave  
80101208:	c3                   	ret    
80101209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101210 <filedup>:

// Increment ref count for file f.
struct file* filedup(struct file *f) {
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	53                   	push   %ebx
80101214:	83 ec 10             	sub    $0x10,%esp
80101217:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ftable.lock);
8010121a:	68 c0 0f 11 80       	push   $0x80110fc0
8010121f:	e8 6c 35 00 00       	call   80104790 <acquire>
    if (f->ref < 1) {
80101224:	8b 43 04             	mov    0x4(%ebx),%eax
80101227:	83 c4 10             	add    $0x10,%esp
8010122a:	85 c0                	test   %eax,%eax
8010122c:	7e 1a                	jle    80101248 <filedup+0x38>
        panic("filedup");
    }
    f->ref++;
8010122e:	83 c0 01             	add    $0x1,%eax
    release(&ftable.lock);
80101231:	83 ec 0c             	sub    $0xc,%esp
    f->ref++;
80101234:	89 43 04             	mov    %eax,0x4(%ebx)
    release(&ftable.lock);
80101237:	68 c0 0f 11 80       	push   $0x80110fc0
8010123c:	e8 0f 36 00 00       	call   80104850 <release>
    return f;
}
80101241:	89 d8                	mov    %ebx,%eax
80101243:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101246:	c9                   	leave  
80101247:	c3                   	ret    
        panic("filedup");
80101248:	83 ec 0c             	sub    $0xc,%esp
8010124b:	68 94 74 10 80       	push   $0x80107494
80101250:	e8 2b f2 ff ff       	call   80100480 <panic>
80101255:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101260 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f) {
80101260:	55                   	push   %ebp
80101261:	89 e5                	mov    %esp,%ebp
80101263:	57                   	push   %edi
80101264:	56                   	push   %esi
80101265:	53                   	push   %ebx
80101266:	83 ec 28             	sub    $0x28,%esp
80101269:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct file ff;

    acquire(&ftable.lock);
8010126c:	68 c0 0f 11 80       	push   $0x80110fc0
80101271:	e8 1a 35 00 00       	call   80104790 <acquire>
    if (f->ref < 1) {
80101276:	8b 43 04             	mov    0x4(%ebx),%eax
80101279:	83 c4 10             	add    $0x10,%esp
8010127c:	85 c0                	test   %eax,%eax
8010127e:	0f 8e 9b 00 00 00    	jle    8010131f <fileclose+0xbf>
        panic("fileclose");
    }
    if (--f->ref > 0) {
80101284:	83 e8 01             	sub    $0x1,%eax
80101287:	85 c0                	test   %eax,%eax
80101289:	89 43 04             	mov    %eax,0x4(%ebx)
8010128c:	74 1a                	je     801012a8 <fileclose+0x48>
        release(&ftable.lock);
8010128e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
    else if (ff.type == FD_INODE) {
        begin_op();
        iput(ff.ip);
        end_op();
    }
}
80101295:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101298:	5b                   	pop    %ebx
80101299:	5e                   	pop    %esi
8010129a:	5f                   	pop    %edi
8010129b:	5d                   	pop    %ebp
        release(&ftable.lock);
8010129c:	e9 af 35 00 00       	jmp    80104850 <release>
801012a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ff = *f;
801012a8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
801012ac:	8b 3b                	mov    (%ebx),%edi
    release(&ftable.lock);
801012ae:	83 ec 0c             	sub    $0xc,%esp
    ff = *f;
801012b1:	8b 73 0c             	mov    0xc(%ebx),%esi
    f->type = FD_NONE;
801012b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    ff = *f;
801012ba:	88 45 e7             	mov    %al,-0x19(%ebp)
801012bd:	8b 43 10             	mov    0x10(%ebx),%eax
    release(&ftable.lock);
801012c0:	68 c0 0f 11 80       	push   $0x80110fc0
    ff = *f;
801012c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    release(&ftable.lock);
801012c8:	e8 83 35 00 00       	call   80104850 <release>
    if (ff.type == FD_PIPE) {
801012cd:	83 c4 10             	add    $0x10,%esp
801012d0:	83 ff 01             	cmp    $0x1,%edi
801012d3:	74 13                	je     801012e8 <fileclose+0x88>
    else if (ff.type == FD_INODE) {
801012d5:	83 ff 02             	cmp    $0x2,%edi
801012d8:	74 26                	je     80101300 <fileclose+0xa0>
}
801012da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012dd:	5b                   	pop    %ebx
801012de:	5e                   	pop    %esi
801012df:	5f                   	pop    %edi
801012e0:	5d                   	pop    %ebp
801012e1:	c3                   	ret    
801012e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        pipeclose(ff.pipe, ff.writable);
801012e8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801012ec:	83 ec 08             	sub    $0x8,%esp
801012ef:	53                   	push   %ebx
801012f0:	56                   	push   %esi
801012f1:	e8 9a 24 00 00       	call   80103790 <pipeclose>
801012f6:	83 c4 10             	add    $0x10,%esp
801012f9:	eb df                	jmp    801012da <fileclose+0x7a>
801012fb:	90                   	nop
801012fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        begin_op();
80101300:	e8 bb 1c 00 00       	call   80102fc0 <begin_op>
        iput(ff.ip);
80101305:	83 ec 0c             	sub    $0xc,%esp
80101308:	ff 75 e0             	pushl  -0x20(%ebp)
8010130b:	e8 c0 08 00 00       	call   80101bd0 <iput>
        end_op();
80101310:	83 c4 10             	add    $0x10,%esp
}
80101313:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101316:	5b                   	pop    %ebx
80101317:	5e                   	pop    %esi
80101318:	5f                   	pop    %edi
80101319:	5d                   	pop    %ebp
        end_op();
8010131a:	e9 11 1d 00 00       	jmp    80103030 <end_op>
        panic("fileclose");
8010131f:	83 ec 0c             	sub    $0xc,%esp
80101322:	68 9c 74 10 80       	push   $0x8010749c
80101327:	e8 54 f1 ff ff       	call   80100480 <panic>
8010132c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101330 <filestat>:

// Get metadata about file f.
int filestat(struct file *f, struct stat *st) {
80101330:	55                   	push   %ebp
80101331:	89 e5                	mov    %esp,%ebp
80101333:	53                   	push   %ebx
80101334:	83 ec 04             	sub    $0x4,%esp
80101337:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (f->type == FD_INODE) {
8010133a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010133d:	75 31                	jne    80101370 <filestat+0x40>
        ilock(f->ip);
8010133f:	83 ec 0c             	sub    $0xc,%esp
80101342:	ff 73 10             	pushl  0x10(%ebx)
80101345:	e8 56 07 00 00       	call   80101aa0 <ilock>
        stati(f->ip, st);
8010134a:	58                   	pop    %eax
8010134b:	5a                   	pop    %edx
8010134c:	ff 75 0c             	pushl  0xc(%ebp)
8010134f:	ff 73 10             	pushl  0x10(%ebx)
80101352:	e8 f9 09 00 00       	call   80101d50 <stati>
        iunlock(f->ip);
80101357:	59                   	pop    %ecx
80101358:	ff 73 10             	pushl  0x10(%ebx)
8010135b:	e8 20 08 00 00       	call   80101b80 <iunlock>
        return 0;
80101360:	83 c4 10             	add    $0x10,%esp
80101363:	31 c0                	xor    %eax,%eax
    }
    return -1;
}
80101365:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101368:	c9                   	leave  
80101369:	c3                   	ret    
8010136a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101375:	eb ee                	jmp    80101365 <filestat+0x35>
80101377:	89 f6                	mov    %esi,%esi
80101379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101380 <fileread>:

// Read from file f.
int fileread(struct file *f, char *addr, int n) {
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	57                   	push   %edi
80101384:	56                   	push   %esi
80101385:	53                   	push   %ebx
80101386:	83 ec 0c             	sub    $0xc,%esp
80101389:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010138c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010138f:	8b 7d 10             	mov    0x10(%ebp),%edi
    int r;

    if (f->readable == 0) {
80101392:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101396:	74 60                	je     801013f8 <fileread+0x78>
        return -1;
    }
    if (f->type == FD_PIPE) {
80101398:	8b 03                	mov    (%ebx),%eax
8010139a:	83 f8 01             	cmp    $0x1,%eax
8010139d:	74 41                	je     801013e0 <fileread+0x60>
        return piperead(f->pipe, addr, n);
    }
    if (f->type == FD_INODE) {
8010139f:	83 f8 02             	cmp    $0x2,%eax
801013a2:	75 5b                	jne    801013ff <fileread+0x7f>
        ilock(f->ip);
801013a4:	83 ec 0c             	sub    $0xc,%esp
801013a7:	ff 73 10             	pushl  0x10(%ebx)
801013aa:	e8 f1 06 00 00       	call   80101aa0 <ilock>
        if ((r = readi(f->ip, addr, f->off, n)) > 0) {
801013af:	57                   	push   %edi
801013b0:	ff 73 14             	pushl  0x14(%ebx)
801013b3:	56                   	push   %esi
801013b4:	ff 73 10             	pushl  0x10(%ebx)
801013b7:	e8 c4 09 00 00       	call   80101d80 <readi>
801013bc:	83 c4 20             	add    $0x20,%esp
801013bf:	85 c0                	test   %eax,%eax
801013c1:	89 c6                	mov    %eax,%esi
801013c3:	7e 03                	jle    801013c8 <fileread+0x48>
            f->off += r;
801013c5:	01 43 14             	add    %eax,0x14(%ebx)
        }
        iunlock(f->ip);
801013c8:	83 ec 0c             	sub    $0xc,%esp
801013cb:	ff 73 10             	pushl  0x10(%ebx)
801013ce:	e8 ad 07 00 00       	call   80101b80 <iunlock>
        return r;
801013d3:	83 c4 10             	add    $0x10,%esp
    }
    panic("fileread");
}
801013d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d9:	89 f0                	mov    %esi,%eax
801013db:	5b                   	pop    %ebx
801013dc:	5e                   	pop    %esi
801013dd:	5f                   	pop    %edi
801013de:	5d                   	pop    %ebp
801013df:	c3                   	ret    
        return piperead(f->pipe, addr, n);
801013e0:	8b 43 0c             	mov    0xc(%ebx),%eax
801013e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801013e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e9:	5b                   	pop    %ebx
801013ea:	5e                   	pop    %esi
801013eb:	5f                   	pop    %edi
801013ec:	5d                   	pop    %ebp
        return piperead(f->pipe, addr, n);
801013ed:	e9 4e 25 00 00       	jmp    80103940 <piperead>
801013f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
801013f8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801013fd:	eb d7                	jmp    801013d6 <fileread+0x56>
    panic("fileread");
801013ff:	83 ec 0c             	sub    $0xc,%esp
80101402:	68 a6 74 10 80       	push   $0x801074a6
80101407:	e8 74 f0 ff ff       	call   80100480 <panic>
8010140c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101410 <filewrite>:


// Write to file f.
int filewrite(struct file *f, char *addr, int n) {
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	57                   	push   %edi
80101414:	56                   	push   %esi
80101415:	53                   	push   %ebx
80101416:	83 ec 1c             	sub    $0x1c,%esp
80101419:	8b 75 08             	mov    0x8(%ebp),%esi
8010141c:	8b 45 0c             	mov    0xc(%ebp),%eax
    int r;

    if (f->writable == 0) {
8010141f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
int filewrite(struct file *f, char *addr, int n) {
80101423:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101426:	8b 45 10             	mov    0x10(%ebp),%eax
80101429:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (f->writable == 0) {
8010142c:	0f 84 aa 00 00 00    	je     801014dc <filewrite+0xcc>
        return -1;
    }
    if (f->type == FD_PIPE) {
80101432:	8b 06                	mov    (%esi),%eax
80101434:	83 f8 01             	cmp    $0x1,%eax
80101437:	0f 84 c3 00 00 00    	je     80101500 <filewrite+0xf0>
        return pipewrite(f->pipe, addr, n);
    }
    if (f->type == FD_INODE) {
8010143d:	83 f8 02             	cmp    $0x2,%eax
80101440:	0f 85 d9 00 00 00    	jne    8010151f <filewrite+0x10f>
        // and 2 blocks of slop for non-aligned writes.
        // this really belongs lower down, since writei()
        // might be writing a device like the console.
        int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * 512;
        int i = 0;
        while (i < n) {
80101446:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        int i = 0;
80101449:	31 ff                	xor    %edi,%edi
        while (i < n) {
8010144b:	85 c0                	test   %eax,%eax
8010144d:	7f 34                	jg     80101483 <filewrite+0x73>
8010144f:	e9 9c 00 00 00       	jmp    801014f0 <filewrite+0xe0>
80101454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            }

            begin_op();
            ilock(f->ip);
            if ((r = writei(f->ip, addr + i, f->off, n1)) > 0) {
                f->off += r;
80101458:	01 46 14             	add    %eax,0x14(%esi)
            }
            iunlock(f->ip);
8010145b:	83 ec 0c             	sub    $0xc,%esp
8010145e:	ff 76 10             	pushl  0x10(%esi)
                f->off += r;
80101461:	89 45 e0             	mov    %eax,-0x20(%ebp)
            iunlock(f->ip);
80101464:	e8 17 07 00 00       	call   80101b80 <iunlock>
            end_op();
80101469:	e8 c2 1b 00 00       	call   80103030 <end_op>
8010146e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101471:	83 c4 10             	add    $0x10,%esp

            if (r < 0) {
                break;
            }
            if (r != n1) {
80101474:	39 c3                	cmp    %eax,%ebx
80101476:	0f 85 96 00 00 00    	jne    80101512 <filewrite+0x102>
                panic("short filewrite");
            }
            i += r;
8010147c:	01 df                	add    %ebx,%edi
        while (i < n) {
8010147e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101481:	7e 6d                	jle    801014f0 <filewrite+0xe0>
            int n1 = n - i;
80101483:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101486:	b8 00 06 00 00       	mov    $0x600,%eax
8010148b:	29 fb                	sub    %edi,%ebx
8010148d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101493:	0f 4f d8             	cmovg  %eax,%ebx
            begin_op();
80101496:	e8 25 1b 00 00       	call   80102fc0 <begin_op>
            ilock(f->ip);
8010149b:	83 ec 0c             	sub    $0xc,%esp
8010149e:	ff 76 10             	pushl  0x10(%esi)
801014a1:	e8 fa 05 00 00       	call   80101aa0 <ilock>
            if ((r = writei(f->ip, addr + i, f->off, n1)) > 0) {
801014a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801014a9:	53                   	push   %ebx
801014aa:	ff 76 14             	pushl  0x14(%esi)
801014ad:	01 f8                	add    %edi,%eax
801014af:	50                   	push   %eax
801014b0:	ff 76 10             	pushl  0x10(%esi)
801014b3:	e8 c8 09 00 00       	call   80101e80 <writei>
801014b8:	83 c4 20             	add    $0x20,%esp
801014bb:	85 c0                	test   %eax,%eax
801014bd:	7f 99                	jg     80101458 <filewrite+0x48>
            iunlock(f->ip);
801014bf:	83 ec 0c             	sub    $0xc,%esp
801014c2:	ff 76 10             	pushl  0x10(%esi)
801014c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801014c8:	e8 b3 06 00 00       	call   80101b80 <iunlock>
            end_op();
801014cd:	e8 5e 1b 00 00       	call   80103030 <end_op>
            if (r < 0) {
801014d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801014d5:	83 c4 10             	add    $0x10,%esp
801014d8:	85 c0                	test   %eax,%eax
801014da:	74 98                	je     80101474 <filewrite+0x64>
        }
        return i == n ? n : -1;
    }
    panic("filewrite");
}
801014dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
801014df:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801014e4:	89 f8                	mov    %edi,%eax
801014e6:	5b                   	pop    %ebx
801014e7:	5e                   	pop    %esi
801014e8:	5f                   	pop    %edi
801014e9:	5d                   	pop    %ebp
801014ea:	c3                   	ret    
801014eb:	90                   	nop
801014ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return i == n ? n : -1;
801014f0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801014f3:	75 e7                	jne    801014dc <filewrite+0xcc>
}
801014f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f8:	89 f8                	mov    %edi,%eax
801014fa:	5b                   	pop    %ebx
801014fb:	5e                   	pop    %esi
801014fc:	5f                   	pop    %edi
801014fd:	5d                   	pop    %ebp
801014fe:	c3                   	ret    
801014ff:	90                   	nop
        return pipewrite(f->pipe, addr, n);
80101500:	8b 46 0c             	mov    0xc(%esi),%eax
80101503:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101506:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101509:	5b                   	pop    %ebx
8010150a:	5e                   	pop    %esi
8010150b:	5f                   	pop    %edi
8010150c:	5d                   	pop    %ebp
        return pipewrite(f->pipe, addr, n);
8010150d:	e9 1e 23 00 00       	jmp    80103830 <pipewrite>
                panic("short filewrite");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 af 74 10 80       	push   $0x801074af
8010151a:	e8 61 ef ff ff       	call   80100480 <panic>
    panic("filewrite");
8010151f:	83 ec 0c             	sub    $0xc,%esp
80101522:	68 b5 74 10 80       	push   $0x801074b5
80101527:	e8 54 ef ff ff       	call   80100480 <panic>
8010152c:	66 90                	xchg   %ax,%ax
8010152e:	66 90                	xchg   %ax,%ax

80101530 <bfree>:
    }
    panic("balloc: out of blocks");
}

// Free a disk block.
static void bfree(int dev, uint b) {
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	56                   	push   %esi
80101534:	53                   	push   %ebx
80101535:	89 d3                	mov    %edx,%ebx
    struct buf *bp;
    int bi, m;

    bp = bread(dev, BBLOCK(b, sb));
80101537:	c1 ea 0c             	shr    $0xc,%edx
8010153a:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101540:	83 ec 08             	sub    $0x8,%esp
80101543:	52                   	push   %edx
80101544:	50                   	push   %eax
80101545:	e8 86 eb ff ff       	call   801000d0 <bread>
    bi = b % BPB;
    m = 1 << (bi % 8);
8010154a:	89 d9                	mov    %ebx,%ecx
    if ((bp->data[bi / 8] & m) == 0) {
8010154c:	c1 fb 03             	sar    $0x3,%ebx
    m = 1 << (bi % 8);
8010154f:	ba 01 00 00 00       	mov    $0x1,%edx
80101554:	83 e1 07             	and    $0x7,%ecx
    if ((bp->data[bi / 8] & m) == 0) {
80101557:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010155d:	83 c4 10             	add    $0x10,%esp
    m = 1 << (bi % 8);
80101560:	d3 e2                	shl    %cl,%edx
    if ((bp->data[bi / 8] & m) == 0) {
80101562:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101567:	85 d1                	test   %edx,%ecx
80101569:	74 25                	je     80101590 <bfree+0x60>
        panic("freeing free block");
    }
    bp->data[bi / 8] &= ~m;
8010156b:	f7 d2                	not    %edx
8010156d:	89 c6                	mov    %eax,%esi
    log_write(bp);
8010156f:	83 ec 0c             	sub    $0xc,%esp
    bp->data[bi / 8] &= ~m;
80101572:	21 ca                	and    %ecx,%edx
80101574:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
    log_write(bp);
80101578:	56                   	push   %esi
80101579:	e8 12 1c 00 00       	call   80103190 <log_write>
    brelse(bp);
8010157e:	89 34 24             	mov    %esi,(%esp)
80101581:	e8 5a ec ff ff       	call   801001e0 <brelse>
}
80101586:	83 c4 10             	add    $0x10,%esp
80101589:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010158c:	5b                   	pop    %ebx
8010158d:	5e                   	pop    %esi
8010158e:	5d                   	pop    %ebp
8010158f:	c3                   	ret    
        panic("freeing free block");
80101590:	83 ec 0c             	sub    $0xc,%esp
80101593:	68 bf 74 10 80       	push   $0x801074bf
80101598:	e8 e3 ee ff ff       	call   80100480 <panic>
8010159d:	8d 76 00             	lea    0x0(%esi),%esi

801015a0 <balloc>:
static uint balloc(uint dev) {
801015a0:	55                   	push   %ebp
801015a1:	89 e5                	mov    %esp,%ebp
801015a3:	57                   	push   %edi
801015a4:	56                   	push   %esi
801015a5:	53                   	push   %ebx
801015a6:	83 ec 1c             	sub    $0x1c,%esp
    for (b = 0; b < sb.size; b += BPB) {
801015a9:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
static uint balloc(uint dev) {
801015af:	89 45 d8             	mov    %eax,-0x28(%ebp)
    for (b = 0; b < sb.size; b += BPB) {
801015b2:	85 c9                	test   %ecx,%ecx
801015b4:	0f 84 87 00 00 00    	je     80101641 <balloc+0xa1>
801015ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
        bp = bread(dev, BBLOCK(b, sb));
801015c1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801015c4:	83 ec 08             	sub    $0x8,%esp
801015c7:	89 f0                	mov    %esi,%eax
801015c9:	c1 f8 0c             	sar    $0xc,%eax
801015cc:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801015d2:	50                   	push   %eax
801015d3:	ff 75 d8             	pushl  -0x28(%ebp)
801015d6:	e8 f5 ea ff ff       	call   801000d0 <bread>
801015db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
801015de:	a1 c0 19 11 80       	mov    0x801119c0,%eax
801015e3:	83 c4 10             	add    $0x10,%esp
801015e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801015e9:	31 c0                	xor    %eax,%eax
801015eb:	eb 2f                	jmp    8010161c <balloc+0x7c>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi
            m = 1 << (bi % 8);
801015f0:	89 c1                	mov    %eax,%ecx
            if ((bp->data[bi / 8] & m) == 0) { // Is block free?
801015f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            m = 1 << (bi % 8);
801015f5:	bb 01 00 00 00       	mov    $0x1,%ebx
801015fa:	83 e1 07             	and    $0x7,%ecx
801015fd:	d3 e3                	shl    %cl,%ebx
            if ((bp->data[bi / 8] & m) == 0) { // Is block free?
801015ff:	89 c1                	mov    %eax,%ecx
80101601:	c1 f9 03             	sar    $0x3,%ecx
80101604:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101609:	85 df                	test   %ebx,%edi
8010160b:	89 fa                	mov    %edi,%edx
8010160d:	74 41                	je     80101650 <balloc+0xb0>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
8010160f:	83 c0 01             	add    $0x1,%eax
80101612:	83 c6 01             	add    $0x1,%esi
80101615:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010161a:	74 05                	je     80101621 <balloc+0x81>
8010161c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010161f:	77 cf                	ja     801015f0 <balloc+0x50>
        brelse(bp);
80101621:	83 ec 0c             	sub    $0xc,%esp
80101624:	ff 75 e4             	pushl  -0x1c(%ebp)
80101627:	e8 b4 eb ff ff       	call   801001e0 <brelse>
    for (b = 0; b < sb.size; b += BPB) {
8010162c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101633:	83 c4 10             	add    $0x10,%esp
80101636:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101639:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010163f:	77 80                	ja     801015c1 <balloc+0x21>
    panic("balloc: out of blocks");
80101641:	83 ec 0c             	sub    $0xc,%esp
80101644:	68 d2 74 10 80       	push   $0x801074d2
80101649:	e8 32 ee ff ff       	call   80100480 <panic>
8010164e:	66 90                	xchg   %ax,%ax
                bp->data[bi / 8] |= m;  // Mark block in use.
80101650:	8b 7d e4             	mov    -0x1c(%ebp),%edi
                log_write(bp);
80101653:	83 ec 0c             	sub    $0xc,%esp
                bp->data[bi / 8] |= m;  // Mark block in use.
80101656:	09 da                	or     %ebx,%edx
80101658:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
                log_write(bp);
8010165c:	57                   	push   %edi
8010165d:	e8 2e 1b 00 00       	call   80103190 <log_write>
                brelse(bp);
80101662:	89 3c 24             	mov    %edi,(%esp)
80101665:	e8 76 eb ff ff       	call   801001e0 <brelse>
    bp = bread(dev, bno);
8010166a:	58                   	pop    %eax
8010166b:	5a                   	pop    %edx
8010166c:	56                   	push   %esi
8010166d:	ff 75 d8             	pushl  -0x28(%ebp)
80101670:	e8 5b ea ff ff       	call   801000d0 <bread>
80101675:	89 c3                	mov    %eax,%ebx
    memset(bp->data, 0, BSIZE);
80101677:	8d 40 5c             	lea    0x5c(%eax),%eax
8010167a:	83 c4 0c             	add    $0xc,%esp
8010167d:	68 00 02 00 00       	push   $0x200
80101682:	6a 00                	push   $0x0
80101684:	50                   	push   %eax
80101685:	e8 16 32 00 00       	call   801048a0 <memset>
    log_write(bp);
8010168a:	89 1c 24             	mov    %ebx,(%esp)
8010168d:	e8 fe 1a 00 00       	call   80103190 <log_write>
    brelse(bp);
80101692:	89 1c 24             	mov    %ebx,(%esp)
80101695:	e8 46 eb ff ff       	call   801001e0 <brelse>
}
8010169a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010169d:	89 f0                	mov    %esi,%eax
8010169f:	5b                   	pop    %ebx
801016a0:	5e                   	pop    %esi
801016a1:	5f                   	pop    %edi
801016a2:	5d                   	pop    %ebp
801016a3:	c3                   	ret    
801016a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801016aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801016b0 <iget>:
}

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode* iget(uint dev, uint inum) {
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	57                   	push   %edi
801016b4:	56                   	push   %esi
801016b5:	53                   	push   %ebx
801016b6:	89 c7                	mov    %eax,%edi
    struct inode *ip, *empty;

    acquire(&icache.lock);

    // Is the inode already cached?
    empty = 0;
801016b8:	31 f6                	xor    %esi,%esi
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
801016ba:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
static struct inode* iget(uint dev, uint inum) {
801016bf:	83 ec 28             	sub    $0x28,%esp
801016c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    acquire(&icache.lock);
801016c5:	68 e0 19 11 80       	push   $0x801119e0
801016ca:	e8 c1 30 00 00       	call   80104790 <acquire>
801016cf:	83 c4 10             	add    $0x10,%esp
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
801016d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801016d5:	eb 17                	jmp    801016ee <iget+0x3e>
801016d7:	89 f6                	mov    %esi,%esi
801016d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801016e0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801016e6:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801016ec:	73 22                	jae    80101710 <iget+0x60>
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
801016ee:	8b 4b 08             	mov    0x8(%ebx),%ecx
801016f1:	85 c9                	test   %ecx,%ecx
801016f3:	7e 04                	jle    801016f9 <iget+0x49>
801016f5:	39 3b                	cmp    %edi,(%ebx)
801016f7:	74 4f                	je     80101748 <iget+0x98>
            ip->ref++;
            release(&icache.lock);
            return ip;
        }
        if (empty == 0 && ip->ref == 0) {  // Remember empty slot.
801016f9:	85 f6                	test   %esi,%esi
801016fb:	75 e3                	jne    801016e0 <iget+0x30>
801016fd:	85 c9                	test   %ecx,%ecx
801016ff:	0f 44 f3             	cmove  %ebx,%esi
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
80101702:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101708:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010170e:	72 de                	jb     801016ee <iget+0x3e>
            empty = ip;
        }
    }

    // Recycle an inode cache entry.
    if (empty == 0) {
80101710:	85 f6                	test   %esi,%esi
80101712:	74 5b                	je     8010176f <iget+0xbf>
    ip = empty;
    ip->dev = dev;
    ip->inum = inum;
    ip->ref = 1;
    ip->valid = 0;
    release(&icache.lock);
80101714:	83 ec 0c             	sub    $0xc,%esp
    ip->dev = dev;
80101717:	89 3e                	mov    %edi,(%esi)
    ip->inum = inum;
80101719:	89 56 04             	mov    %edx,0x4(%esi)
    ip->ref = 1;
8010171c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
    ip->valid = 0;
80101723:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
    release(&icache.lock);
8010172a:	68 e0 19 11 80       	push   $0x801119e0
8010172f:	e8 1c 31 00 00       	call   80104850 <release>

    return ip;
80101734:	83 c4 10             	add    $0x10,%esp
}
80101737:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010173a:	89 f0                	mov    %esi,%eax
8010173c:	5b                   	pop    %ebx
8010173d:	5e                   	pop    %esi
8010173e:	5f                   	pop    %edi
8010173f:	5d                   	pop    %ebp
80101740:	c3                   	ret    
80101741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
80101748:	39 53 04             	cmp    %edx,0x4(%ebx)
8010174b:	75 ac                	jne    801016f9 <iget+0x49>
            release(&icache.lock);
8010174d:	83 ec 0c             	sub    $0xc,%esp
            ip->ref++;
80101750:	83 c1 01             	add    $0x1,%ecx
            return ip;
80101753:	89 de                	mov    %ebx,%esi
            release(&icache.lock);
80101755:	68 e0 19 11 80       	push   $0x801119e0
            ip->ref++;
8010175a:	89 4b 08             	mov    %ecx,0x8(%ebx)
            release(&icache.lock);
8010175d:	e8 ee 30 00 00       	call   80104850 <release>
            return ip;
80101762:	83 c4 10             	add    $0x10,%esp
}
80101765:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101768:	89 f0                	mov    %esi,%eax
8010176a:	5b                   	pop    %ebx
8010176b:	5e                   	pop    %esi
8010176c:	5f                   	pop    %edi
8010176d:	5d                   	pop    %ebp
8010176e:	c3                   	ret    
        panic("iget: no inodes");
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	68 e8 74 10 80       	push   $0x801074e8
80101777:	e8 04 ed ff ff       	call   80100480 <panic>
8010177c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101780 <bmap>:
// are listed in ip->addrs[].  The next NINDIRECT blocks are
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint bmap(struct inode *ip, uint bn) {
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	57                   	push   %edi
80101784:	56                   	push   %esi
80101785:	53                   	push   %ebx
80101786:	89 c6                	mov    %eax,%esi
80101788:	83 ec 1c             	sub    $0x1c,%esp
    uint addr, *a;
    struct buf *bp;

    if (bn < NDIRECT) {
8010178b:	83 fa 0b             	cmp    $0xb,%edx
8010178e:	77 18                	ja     801017a8 <bmap+0x28>
80101790:	8d 3c 90             	lea    (%eax,%edx,4),%edi
        if ((addr = ip->addrs[bn]) == 0) {
80101793:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101796:	85 db                	test   %ebx,%ebx
80101798:	74 76                	je     80101810 <bmap+0x90>
        brelse(bp);
        return addr;
    }

    panic("bmap: out of range");
}
8010179a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010179d:	89 d8                	mov    %ebx,%eax
8010179f:	5b                   	pop    %ebx
801017a0:	5e                   	pop    %esi
801017a1:	5f                   	pop    %edi
801017a2:	5d                   	pop    %ebp
801017a3:	c3                   	ret    
801017a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bn -= NDIRECT;
801017a8:	8d 5a f4             	lea    -0xc(%edx),%ebx
    if (bn < NINDIRECT) {
801017ab:	83 fb 7f             	cmp    $0x7f,%ebx
801017ae:	0f 87 90 00 00 00    	ja     80101844 <bmap+0xc4>
        if ((addr = ip->addrs[NDIRECT]) == 0) {
801017b4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801017ba:	8b 00                	mov    (%eax),%eax
801017bc:	85 d2                	test   %edx,%edx
801017be:	74 70                	je     80101830 <bmap+0xb0>
        bp = bread(ip->dev, addr);
801017c0:	83 ec 08             	sub    $0x8,%esp
801017c3:	52                   	push   %edx
801017c4:	50                   	push   %eax
801017c5:	e8 06 e9 ff ff       	call   801000d0 <bread>
        if ((addr = a[bn]) == 0) {
801017ca:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801017ce:	83 c4 10             	add    $0x10,%esp
        bp = bread(ip->dev, addr);
801017d1:	89 c7                	mov    %eax,%edi
        if ((addr = a[bn]) == 0) {
801017d3:	8b 1a                	mov    (%edx),%ebx
801017d5:	85 db                	test   %ebx,%ebx
801017d7:	75 1d                	jne    801017f6 <bmap+0x76>
            a[bn] = addr = balloc(ip->dev);
801017d9:	8b 06                	mov    (%esi),%eax
801017db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801017de:	e8 bd fd ff ff       	call   801015a0 <balloc>
801017e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            log_write(bp);
801017e6:	83 ec 0c             	sub    $0xc,%esp
            a[bn] = addr = balloc(ip->dev);
801017e9:	89 c3                	mov    %eax,%ebx
801017eb:	89 02                	mov    %eax,(%edx)
            log_write(bp);
801017ed:	57                   	push   %edi
801017ee:	e8 9d 19 00 00       	call   80103190 <log_write>
801017f3:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801017f6:	83 ec 0c             	sub    $0xc,%esp
801017f9:	57                   	push   %edi
801017fa:	e8 e1 e9 ff ff       	call   801001e0 <brelse>
801017ff:	83 c4 10             	add    $0x10,%esp
}
80101802:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101805:	89 d8                	mov    %ebx,%eax
80101807:	5b                   	pop    %ebx
80101808:	5e                   	pop    %esi
80101809:	5f                   	pop    %edi
8010180a:	5d                   	pop    %ebp
8010180b:	c3                   	ret    
8010180c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            ip->addrs[bn] = addr = balloc(ip->dev);
80101810:	8b 00                	mov    (%eax),%eax
80101812:	e8 89 fd ff ff       	call   801015a0 <balloc>
80101817:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010181a:	8d 65 f4             	lea    -0xc(%ebp),%esp
            ip->addrs[bn] = addr = balloc(ip->dev);
8010181d:	89 c3                	mov    %eax,%ebx
}
8010181f:	89 d8                	mov    %ebx,%eax
80101821:	5b                   	pop    %ebx
80101822:	5e                   	pop    %esi
80101823:	5f                   	pop    %edi
80101824:	5d                   	pop    %ebp
80101825:	c3                   	ret    
80101826:	8d 76 00             	lea    0x0(%esi),%esi
80101829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101830:	e8 6b fd ff ff       	call   801015a0 <balloc>
80101835:	89 c2                	mov    %eax,%edx
80101837:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010183d:	8b 06                	mov    (%esi),%eax
8010183f:	e9 7c ff ff ff       	jmp    801017c0 <bmap+0x40>
    panic("bmap: out of range");
80101844:	83 ec 0c             	sub    $0xc,%esp
80101847:	68 f8 74 10 80       	push   $0x801074f8
8010184c:	e8 2f ec ff ff       	call   80100480 <panic>
80101851:	eb 0d                	jmp    80101860 <readsb>
80101853:	90                   	nop
80101854:	90                   	nop
80101855:	90                   	nop
80101856:	90                   	nop
80101857:	90                   	nop
80101858:	90                   	nop
80101859:	90                   	nop
8010185a:	90                   	nop
8010185b:	90                   	nop
8010185c:	90                   	nop
8010185d:	90                   	nop
8010185e:	90                   	nop
8010185f:	90                   	nop

80101860 <readsb>:
void readsb(int dev, struct superblock *sb) {
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 75 0c             	mov    0xc(%ebp),%esi
    bp = bread(dev, 1);
80101868:	83 ec 08             	sub    $0x8,%esp
8010186b:	6a 01                	push   $0x1
8010186d:	ff 75 08             	pushl  0x8(%ebp)
80101870:	e8 5b e8 ff ff       	call   801000d0 <bread>
80101875:	89 c3                	mov    %eax,%ebx
    memmove(sb, bp->data, sizeof(*sb));
80101877:	8d 40 5c             	lea    0x5c(%eax),%eax
8010187a:	83 c4 0c             	add    $0xc,%esp
8010187d:	6a 1c                	push   $0x1c
8010187f:	50                   	push   %eax
80101880:	56                   	push   %esi
80101881:	e8 ca 30 00 00       	call   80104950 <memmove>
    brelse(bp);
80101886:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101889:	83 c4 10             	add    $0x10,%esp
}
8010188c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188f:	5b                   	pop    %ebx
80101890:	5e                   	pop    %esi
80101891:	5d                   	pop    %ebp
    brelse(bp);
80101892:	e9 49 e9 ff ff       	jmp    801001e0 <brelse>
80101897:	89 f6                	mov    %esi,%esi
80101899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801018a0 <iinit>:
void iinit(int dev) {
801018a0:	55                   	push   %ebp
801018a1:	89 e5                	mov    %esp,%ebp
801018a3:	53                   	push   %ebx
801018a4:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
801018a9:	83 ec 0c             	sub    $0xc,%esp
    initlock(&icache.lock, "icache");
801018ac:	68 0b 75 10 80       	push   $0x8010750b
801018b1:	68 e0 19 11 80       	push   $0x801119e0
801018b6:	e8 95 2d 00 00       	call   80104650 <initlock>
801018bb:	83 c4 10             	add    $0x10,%esp
801018be:	66 90                	xchg   %ax,%ax
        initsleeplock(&icache.inode[i].lock, "inode");
801018c0:	83 ec 08             	sub    $0x8,%esp
801018c3:	68 12 75 10 80       	push   $0x80107512
801018c8:	53                   	push   %ebx
801018c9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018cf:	e8 4c 2c 00 00       	call   80104520 <initsleeplock>
    for (i = 0; i < NINODE; i++) {
801018d4:	83 c4 10             	add    $0x10,%esp
801018d7:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801018dd:	75 e1                	jne    801018c0 <iinit+0x20>
    readsb(dev, &sb);
801018df:	83 ec 08             	sub    $0x8,%esp
801018e2:	68 c0 19 11 80       	push   $0x801119c0
801018e7:	ff 75 08             	pushl  0x8(%ebp)
801018ea:	e8 71 ff ff ff       	call   80101860 <readsb>
    cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801018ef:	ff 35 d8 19 11 80    	pushl  0x801119d8
801018f5:	ff 35 d4 19 11 80    	pushl  0x801119d4
801018fb:	ff 35 d0 19 11 80    	pushl  0x801119d0
80101901:	ff 35 cc 19 11 80    	pushl  0x801119cc
80101907:	ff 35 c8 19 11 80    	pushl  0x801119c8
8010190d:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101913:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101919:	68 78 75 10 80       	push   $0x80107578
8010191e:	e8 2d ee ff ff       	call   80100750 <cprintf>
}
80101923:	83 c4 30             	add    $0x30,%esp
80101926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101929:	c9                   	leave  
8010192a:	c3                   	ret    
8010192b:	90                   	nop
8010192c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101930 <ialloc>:
struct inode* ialloc(uint dev, short type) {
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	57                   	push   %edi
80101934:	56                   	push   %esi
80101935:	53                   	push   %ebx
80101936:	83 ec 1c             	sub    $0x1c,%esp
    for (inum = 1; inum < sb.ninodes; inum++) {
80101939:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
struct inode* ialloc(uint dev, short type) {
80101940:	8b 45 0c             	mov    0xc(%ebp),%eax
80101943:	8b 75 08             	mov    0x8(%ebp),%esi
80101946:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (inum = 1; inum < sb.ninodes; inum++) {
80101949:	0f 86 91 00 00 00    	jbe    801019e0 <ialloc+0xb0>
8010194f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101954:	eb 21                	jmp    80101977 <ialloc+0x47>
80101956:	8d 76 00             	lea    0x0(%esi),%esi
80101959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        brelse(bp);
80101960:	83 ec 0c             	sub    $0xc,%esp
    for (inum = 1; inum < sb.ninodes; inum++) {
80101963:	83 c3 01             	add    $0x1,%ebx
        brelse(bp);
80101966:	57                   	push   %edi
80101967:	e8 74 e8 ff ff       	call   801001e0 <brelse>
    for (inum = 1; inum < sb.ninodes; inum++) {
8010196c:	83 c4 10             	add    $0x10,%esp
8010196f:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
80101975:	76 69                	jbe    801019e0 <ialloc+0xb0>
        bp = bread(dev, IBLOCK(inum, sb));
80101977:	89 d8                	mov    %ebx,%eax
80101979:	83 ec 08             	sub    $0x8,%esp
8010197c:	c1 e8 03             	shr    $0x3,%eax
8010197f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101985:	50                   	push   %eax
80101986:	56                   	push   %esi
80101987:	e8 44 e7 ff ff       	call   801000d0 <bread>
8010198c:	89 c7                	mov    %eax,%edi
        dip = (struct dinode*)bp->data + inum % IPB;
8010198e:	89 d8                	mov    %ebx,%eax
        if (dip->type == 0) { // a free inode
80101990:	83 c4 10             	add    $0x10,%esp
        dip = (struct dinode*)bp->data + inum % IPB;
80101993:	83 e0 07             	and    $0x7,%eax
80101996:	c1 e0 06             	shl    $0x6,%eax
80101999:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
        if (dip->type == 0) { // a free inode
8010199d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801019a1:	75 bd                	jne    80101960 <ialloc+0x30>
            memset(dip, 0, sizeof(*dip));
801019a3:	83 ec 04             	sub    $0x4,%esp
801019a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801019a9:	6a 40                	push   $0x40
801019ab:	6a 00                	push   $0x0
801019ad:	51                   	push   %ecx
801019ae:	e8 ed 2e 00 00       	call   801048a0 <memset>
            dip->type = type;
801019b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801019b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801019ba:	66 89 01             	mov    %ax,(%ecx)
            log_write(bp);   // mark it allocated on the disk
801019bd:	89 3c 24             	mov    %edi,(%esp)
801019c0:	e8 cb 17 00 00       	call   80103190 <log_write>
            brelse(bp);
801019c5:	89 3c 24             	mov    %edi,(%esp)
801019c8:	e8 13 e8 ff ff       	call   801001e0 <brelse>
            return iget(dev, inum);
801019cd:	83 c4 10             	add    $0x10,%esp
}
801019d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return iget(dev, inum);
801019d3:	89 da                	mov    %ebx,%edx
801019d5:	89 f0                	mov    %esi,%eax
}
801019d7:	5b                   	pop    %ebx
801019d8:	5e                   	pop    %esi
801019d9:	5f                   	pop    %edi
801019da:	5d                   	pop    %ebp
            return iget(dev, inum);
801019db:	e9 d0 fc ff ff       	jmp    801016b0 <iget>
    panic("ialloc: no inodes");
801019e0:	83 ec 0c             	sub    $0xc,%esp
801019e3:	68 18 75 10 80       	push   $0x80107518
801019e8:	e8 93 ea ff ff       	call   80100480 <panic>
801019ed:	8d 76 00             	lea    0x0(%esi),%esi

801019f0 <iupdate>:
void iupdate(struct inode *ip) {
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	56                   	push   %esi
801019f4:	53                   	push   %ebx
801019f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019f8:	83 ec 08             	sub    $0x8,%esp
801019fb:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019fe:	83 c3 5c             	add    $0x5c,%ebx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a01:	c1 e8 03             	shr    $0x3,%eax
80101a04:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101a0a:	50                   	push   %eax
80101a0b:	ff 73 a4             	pushl  -0x5c(%ebx)
80101a0e:	e8 bd e6 ff ff       	call   801000d0 <bread>
80101a13:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum % IPB;
80101a15:	8b 43 a8             	mov    -0x58(%ebx),%eax
    dip->type = ip->type;
80101a18:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a1c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum % IPB;
80101a1f:	83 e0 07             	and    $0x7,%eax
80101a22:	c1 e0 06             	shl    $0x6,%eax
80101a25:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    dip->type = ip->type;
80101a29:	66 89 10             	mov    %dx,(%eax)
    dip->major = ip->major;
80101a2c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a30:	83 c0 0c             	add    $0xc,%eax
    dip->major = ip->major;
80101a33:	66 89 50 f6          	mov    %dx,-0xa(%eax)
    dip->minor = ip->minor;
80101a37:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101a3b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
    dip->nlink = ip->nlink;
80101a3f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101a43:	66 89 50 fa          	mov    %dx,-0x6(%eax)
    dip->size = ip->size;
80101a47:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101a4a:	89 50 fc             	mov    %edx,-0x4(%eax)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101a4d:	6a 34                	push   $0x34
80101a4f:	53                   	push   %ebx
80101a50:	50                   	push   %eax
80101a51:	e8 fa 2e 00 00       	call   80104950 <memmove>
    log_write(bp);
80101a56:	89 34 24             	mov    %esi,(%esp)
80101a59:	e8 32 17 00 00       	call   80103190 <log_write>
    brelse(bp);
80101a5e:	89 75 08             	mov    %esi,0x8(%ebp)
80101a61:	83 c4 10             	add    $0x10,%esp
}
80101a64:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a67:	5b                   	pop    %ebx
80101a68:	5e                   	pop    %esi
80101a69:	5d                   	pop    %ebp
    brelse(bp);
80101a6a:	e9 71 e7 ff ff       	jmp    801001e0 <brelse>
80101a6f:	90                   	nop

80101a70 <idup>:
struct inode* idup(struct inode *ip) {
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	53                   	push   %ebx
80101a74:	83 ec 10             	sub    $0x10,%esp
80101a77:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&icache.lock);
80101a7a:	68 e0 19 11 80       	push   $0x801119e0
80101a7f:	e8 0c 2d 00 00       	call   80104790 <acquire>
    ip->ref++;
80101a84:	83 43 08 01          	addl   $0x1,0x8(%ebx)
    release(&icache.lock);
80101a88:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101a8f:	e8 bc 2d 00 00       	call   80104850 <release>
}
80101a94:	89 d8                	mov    %ebx,%eax
80101a96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a99:	c9                   	leave  
80101a9a:	c3                   	ret    
80101a9b:	90                   	nop
80101a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101aa0 <ilock>:
void ilock(struct inode *ip) {
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	56                   	push   %esi
80101aa4:	53                   	push   %ebx
80101aa5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (ip == 0 || ip->ref < 1) {
80101aa8:	85 db                	test   %ebx,%ebx
80101aaa:	0f 84 b7 00 00 00    	je     80101b67 <ilock+0xc7>
80101ab0:	8b 53 08             	mov    0x8(%ebx),%edx
80101ab3:	85 d2                	test   %edx,%edx
80101ab5:	0f 8e ac 00 00 00    	jle    80101b67 <ilock+0xc7>
    acquiresleep(&ip->lock);
80101abb:	8d 43 0c             	lea    0xc(%ebx),%eax
80101abe:	83 ec 0c             	sub    $0xc,%esp
80101ac1:	50                   	push   %eax
80101ac2:	e8 99 2a 00 00       	call   80104560 <acquiresleep>
    if (ip->valid == 0) {
80101ac7:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101aca:	83 c4 10             	add    $0x10,%esp
80101acd:	85 c0                	test   %eax,%eax
80101acf:	74 0f                	je     80101ae0 <ilock+0x40>
}
80101ad1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ad4:	5b                   	pop    %ebx
80101ad5:	5e                   	pop    %esi
80101ad6:	5d                   	pop    %ebp
80101ad7:	c3                   	ret    
80101ad8:	90                   	nop
80101ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101ae0:	8b 43 04             	mov    0x4(%ebx),%eax
80101ae3:	83 ec 08             	sub    $0x8,%esp
80101ae6:	c1 e8 03             	shr    $0x3,%eax
80101ae9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101aef:	50                   	push   %eax
80101af0:	ff 33                	pushl  (%ebx)
80101af2:	e8 d9 e5 ff ff       	call   801000d0 <bread>
80101af7:	89 c6                	mov    %eax,%esi
        dip = (struct dinode*)bp->data + ip->inum % IPB;
80101af9:	8b 43 04             	mov    0x4(%ebx),%eax
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101afc:	83 c4 0c             	add    $0xc,%esp
        dip = (struct dinode*)bp->data + ip->inum % IPB;
80101aff:	83 e0 07             	and    $0x7,%eax
80101b02:	c1 e0 06             	shl    $0x6,%eax
80101b05:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
        ip->type = dip->type;
80101b09:	0f b7 10             	movzwl (%eax),%edx
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b0c:	83 c0 0c             	add    $0xc,%eax
        ip->type = dip->type;
80101b0f:	66 89 53 50          	mov    %dx,0x50(%ebx)
        ip->major = dip->major;
80101b13:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101b17:	66 89 53 52          	mov    %dx,0x52(%ebx)
        ip->minor = dip->minor;
80101b1b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101b1f:	66 89 53 54          	mov    %dx,0x54(%ebx)
        ip->nlink = dip->nlink;
80101b23:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101b27:	66 89 53 56          	mov    %dx,0x56(%ebx)
        ip->size = dip->size;
80101b2b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101b2e:	89 53 58             	mov    %edx,0x58(%ebx)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b31:	6a 34                	push   $0x34
80101b33:	50                   	push   %eax
80101b34:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101b37:	50                   	push   %eax
80101b38:	e8 13 2e 00 00       	call   80104950 <memmove>
        brelse(bp);
80101b3d:	89 34 24             	mov    %esi,(%esp)
80101b40:	e8 9b e6 ff ff       	call   801001e0 <brelse>
        if (ip->type == 0) {
80101b45:	83 c4 10             	add    $0x10,%esp
80101b48:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
        ip->valid = 1;
80101b4d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
        if (ip->type == 0) {
80101b54:	0f 85 77 ff ff ff    	jne    80101ad1 <ilock+0x31>
            panic("ilock: no type");
80101b5a:	83 ec 0c             	sub    $0xc,%esp
80101b5d:	68 30 75 10 80       	push   $0x80107530
80101b62:	e8 19 e9 ff ff       	call   80100480 <panic>
        panic("ilock");
80101b67:	83 ec 0c             	sub    $0xc,%esp
80101b6a:	68 2a 75 10 80       	push   $0x8010752a
80101b6f:	e8 0c e9 ff ff       	call   80100480 <panic>
80101b74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101b7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101b80 <iunlock>:
void iunlock(struct inode *ip) {
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	56                   	push   %esi
80101b84:	53                   	push   %ebx
80101b85:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1) {
80101b88:	85 db                	test   %ebx,%ebx
80101b8a:	74 28                	je     80101bb4 <iunlock+0x34>
80101b8c:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b8f:	83 ec 0c             	sub    $0xc,%esp
80101b92:	56                   	push   %esi
80101b93:	e8 68 2a 00 00       	call   80104600 <holdingsleep>
80101b98:	83 c4 10             	add    $0x10,%esp
80101b9b:	85 c0                	test   %eax,%eax
80101b9d:	74 15                	je     80101bb4 <iunlock+0x34>
80101b9f:	8b 43 08             	mov    0x8(%ebx),%eax
80101ba2:	85 c0                	test   %eax,%eax
80101ba4:	7e 0e                	jle    80101bb4 <iunlock+0x34>
    releasesleep(&ip->lock);
80101ba6:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101ba9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101bac:	5b                   	pop    %ebx
80101bad:	5e                   	pop    %esi
80101bae:	5d                   	pop    %ebp
    releasesleep(&ip->lock);
80101baf:	e9 0c 2a 00 00       	jmp    801045c0 <releasesleep>
        panic("iunlock");
80101bb4:	83 ec 0c             	sub    $0xc,%esp
80101bb7:	68 3f 75 10 80       	push   $0x8010753f
80101bbc:	e8 bf e8 ff ff       	call   80100480 <panic>
80101bc1:	eb 0d                	jmp    80101bd0 <iput>
80101bc3:	90                   	nop
80101bc4:	90                   	nop
80101bc5:	90                   	nop
80101bc6:	90                   	nop
80101bc7:	90                   	nop
80101bc8:	90                   	nop
80101bc9:	90                   	nop
80101bca:	90                   	nop
80101bcb:	90                   	nop
80101bcc:	90                   	nop
80101bcd:	90                   	nop
80101bce:	90                   	nop
80101bcf:	90                   	nop

80101bd0 <iput>:
void iput(struct inode *ip) {
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	57                   	push   %edi
80101bd4:	56                   	push   %esi
80101bd5:	53                   	push   %ebx
80101bd6:	83 ec 28             	sub    $0x28,%esp
80101bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquiresleep(&ip->lock);
80101bdc:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101bdf:	57                   	push   %edi
80101be0:	e8 7b 29 00 00       	call   80104560 <acquiresleep>
    if (ip->valid && ip->nlink == 0) {
80101be5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101be8:	83 c4 10             	add    $0x10,%esp
80101beb:	85 d2                	test   %edx,%edx
80101bed:	74 07                	je     80101bf6 <iput+0x26>
80101bef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101bf4:	74 32                	je     80101c28 <iput+0x58>
    releasesleep(&ip->lock);
80101bf6:	83 ec 0c             	sub    $0xc,%esp
80101bf9:	57                   	push   %edi
80101bfa:	e8 c1 29 00 00       	call   801045c0 <releasesleep>
    acquire(&icache.lock);
80101bff:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101c06:	e8 85 2b 00 00       	call   80104790 <acquire>
    ip->ref--;
80101c0b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
    release(&icache.lock);
80101c0f:	83 c4 10             	add    $0x10,%esp
80101c12:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101c19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c1c:	5b                   	pop    %ebx
80101c1d:	5e                   	pop    %esi
80101c1e:	5f                   	pop    %edi
80101c1f:	5d                   	pop    %ebp
    release(&icache.lock);
80101c20:	e9 2b 2c 00 00       	jmp    80104850 <release>
80101c25:	8d 76 00             	lea    0x0(%esi),%esi
        acquire(&icache.lock);
80101c28:	83 ec 0c             	sub    $0xc,%esp
80101c2b:	68 e0 19 11 80       	push   $0x801119e0
80101c30:	e8 5b 2b 00 00       	call   80104790 <acquire>
        int r = ip->ref;
80101c35:	8b 73 08             	mov    0x8(%ebx),%esi
        release(&icache.lock);
80101c38:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101c3f:	e8 0c 2c 00 00       	call   80104850 <release>
        if (r == 1) {
80101c44:	83 c4 10             	add    $0x10,%esp
80101c47:	83 fe 01             	cmp    $0x1,%esi
80101c4a:	75 aa                	jne    80101bf6 <iput+0x26>
80101c4c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101c52:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101c55:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101c58:	89 cf                	mov    %ecx,%edi
80101c5a:	eb 0b                	jmp    80101c67 <iput+0x97>
80101c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c60:	83 c6 04             	add    $0x4,%esi
static void itrunc(struct inode *ip) {
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++) {
80101c63:	39 fe                	cmp    %edi,%esi
80101c65:	74 19                	je     80101c80 <iput+0xb0>
        if (ip->addrs[i]) {
80101c67:	8b 16                	mov    (%esi),%edx
80101c69:	85 d2                	test   %edx,%edx
80101c6b:	74 f3                	je     80101c60 <iput+0x90>
            bfree(ip->dev, ip->addrs[i]);
80101c6d:	8b 03                	mov    (%ebx),%eax
80101c6f:	e8 bc f8 ff ff       	call   80101530 <bfree>
            ip->addrs[i] = 0;
80101c74:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101c7a:	eb e4                	jmp    80101c60 <iput+0x90>
80101c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        }
    }

    if (ip->addrs[NDIRECT]) {
80101c80:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101c86:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c89:	85 c0                	test   %eax,%eax
80101c8b:	75 33                	jne    80101cc0 <iput+0xf0>
        bfree(ip->dev, ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    iupdate(ip);
80101c8d:	83 ec 0c             	sub    $0xc,%esp
    ip->size = 0;
80101c90:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
    iupdate(ip);
80101c97:	53                   	push   %ebx
80101c98:	e8 53 fd ff ff       	call   801019f0 <iupdate>
            ip->type = 0;
80101c9d:	31 c0                	xor    %eax,%eax
80101c9f:	66 89 43 50          	mov    %ax,0x50(%ebx)
            iupdate(ip);
80101ca3:	89 1c 24             	mov    %ebx,(%esp)
80101ca6:	e8 45 fd ff ff       	call   801019f0 <iupdate>
            ip->valid = 0;
80101cab:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101cb2:	83 c4 10             	add    $0x10,%esp
80101cb5:	e9 3c ff ff ff       	jmp    80101bf6 <iput+0x26>
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cc0:	83 ec 08             	sub    $0x8,%esp
80101cc3:	50                   	push   %eax
80101cc4:	ff 33                	pushl  (%ebx)
80101cc6:	e8 05 e4 ff ff       	call   801000d0 <bread>
80101ccb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101cd1:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101cd4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        a = (uint*)bp->data;
80101cd7:	8d 70 5c             	lea    0x5c(%eax),%esi
80101cda:	83 c4 10             	add    $0x10,%esp
80101cdd:	89 cf                	mov    %ecx,%edi
80101cdf:	eb 0e                	jmp    80101cef <iput+0x11f>
80101ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ce8:	83 c6 04             	add    $0x4,%esi
        for (j = 0; j < NINDIRECT; j++) {
80101ceb:	39 fe                	cmp    %edi,%esi
80101ced:	74 0f                	je     80101cfe <iput+0x12e>
            if (a[j]) {
80101cef:	8b 16                	mov    (%esi),%edx
80101cf1:	85 d2                	test   %edx,%edx
80101cf3:	74 f3                	je     80101ce8 <iput+0x118>
                bfree(ip->dev, a[j]);
80101cf5:	8b 03                	mov    (%ebx),%eax
80101cf7:	e8 34 f8 ff ff       	call   80101530 <bfree>
80101cfc:	eb ea                	jmp    80101ce8 <iput+0x118>
        brelse(bp);
80101cfe:	83 ec 0c             	sub    $0xc,%esp
80101d01:	ff 75 e4             	pushl  -0x1c(%ebp)
80101d04:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d07:	e8 d4 e4 ff ff       	call   801001e0 <brelse>
        bfree(ip->dev, ip->addrs[NDIRECT]);
80101d0c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101d12:	8b 03                	mov    (%ebx),%eax
80101d14:	e8 17 f8 ff ff       	call   80101530 <bfree>
        ip->addrs[NDIRECT] = 0;
80101d19:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101d20:	00 00 00 
80101d23:	83 c4 10             	add    $0x10,%esp
80101d26:	e9 62 ff ff ff       	jmp    80101c8d <iput+0xbd>
80101d2b:	90                   	nop
80101d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d30 <iunlockput>:
void iunlockput(struct inode *ip) {
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	53                   	push   %ebx
80101d34:	83 ec 10             	sub    $0x10,%esp
80101d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
    iunlock(ip);
80101d3a:	53                   	push   %ebx
80101d3b:	e8 40 fe ff ff       	call   80101b80 <iunlock>
    iput(ip);
80101d40:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101d43:	83 c4 10             	add    $0x10,%esp
}
80101d46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101d49:	c9                   	leave  
    iput(ip);
80101d4a:	e9 81 fe ff ff       	jmp    80101bd0 <iput>
80101d4f:	90                   	nop

80101d50 <stati>:
}

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st) {
80101d50:	55                   	push   %ebp
80101d51:	89 e5                	mov    %esp,%ebp
80101d53:	8b 55 08             	mov    0x8(%ebp),%edx
80101d56:	8b 45 0c             	mov    0xc(%ebp),%eax
    st->dev = ip->dev;
80101d59:	8b 0a                	mov    (%edx),%ecx
80101d5b:	89 48 04             	mov    %ecx,0x4(%eax)
    st->ino = ip->inum;
80101d5e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101d61:	89 48 08             	mov    %ecx,0x8(%eax)
    st->type = ip->type;
80101d64:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101d68:	66 89 08             	mov    %cx,(%eax)
    st->nlink = ip->nlink;
80101d6b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101d6f:	66 89 48 0c          	mov    %cx,0xc(%eax)
    st->size = ip->size;
80101d73:	8b 52 58             	mov    0x58(%edx),%edx
80101d76:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d79:	5d                   	pop    %ebp
80101d7a:	c3                   	ret    
80101d7b:	90                   	nop
80101d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d80 <readi>:


// Read data from inode.
// Caller must hold ip->lock.
int readi(struct inode *ip, char *dst, uint off, uint n) {
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
80101d83:	57                   	push   %edi
80101d84:	56                   	push   %esi
80101d85:	53                   	push   %ebx
80101d86:	83 ec 1c             	sub    $0x1c,%esp
80101d89:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101d8f:	8b 7d 14             	mov    0x14(%ebp),%edi
    uint tot, m;
    struct buf *bp;

    if (ip->type == T_DEV) {
80101d92:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
int readi(struct inode *ip, char *dst, uint off, uint n) {
80101d97:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101d9a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d9d:	8b 75 10             	mov    0x10(%ebp),%esi
80101da0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    if (ip->type == T_DEV) {
80101da3:	0f 84 a7 00 00 00    	je     80101e50 <readi+0xd0>
            return -1;
        }
        return devsw[ip->major].read(ip, dst, n);
    }

    if (off > ip->size || off + n < off) {
80101da9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101dac:	8b 40 58             	mov    0x58(%eax),%eax
80101daf:	39 c6                	cmp    %eax,%esi
80101db1:	0f 87 ba 00 00 00    	ja     80101e71 <readi+0xf1>
80101db7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101dba:	89 f9                	mov    %edi,%ecx
80101dbc:	01 f1                	add    %esi,%ecx
80101dbe:	0f 82 ad 00 00 00    	jb     80101e71 <readi+0xf1>
        return -1;
    }
    if (off + n > ip->size) {
        n = ip->size - off;
80101dc4:	89 c2                	mov    %eax,%edx
80101dc6:	29 f2                	sub    %esi,%edx
80101dc8:	39 c8                	cmp    %ecx,%eax
80101dca:	0f 43 d7             	cmovae %edi,%edx
    }

    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101dcd:	31 ff                	xor    %edi,%edi
80101dcf:	85 d2                	test   %edx,%edx
        n = ip->size - off;
80101dd1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101dd4:	74 6c                	je     80101e42 <readi+0xc2>
80101dd6:	8d 76 00             	lea    0x0(%esi),%esi
80101dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101de0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101de3:	89 f2                	mov    %esi,%edx
80101de5:	c1 ea 09             	shr    $0x9,%edx
80101de8:	89 d8                	mov    %ebx,%eax
80101dea:	e8 91 f9 ff ff       	call   80101780 <bmap>
80101def:	83 ec 08             	sub    $0x8,%esp
80101df2:	50                   	push   %eax
80101df3:	ff 33                	pushl  (%ebx)
80101df5:	e8 d6 e2 ff ff       	call   801000d0 <bread>
        m = min(n - tot, BSIZE - off % BSIZE);
80101dfa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101dfd:	89 c2                	mov    %eax,%edx
        m = min(n - tot, BSIZE - off % BSIZE);
80101dff:	89 f0                	mov    %esi,%eax
80101e01:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e06:	b9 00 02 00 00       	mov    $0x200,%ecx
80101e0b:	83 c4 0c             	add    $0xc,%esp
80101e0e:	29 c1                	sub    %eax,%ecx
        memmove(dst, bp->data + off % BSIZE, m);
80101e10:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101e14:	89 55 dc             	mov    %edx,-0x24(%ebp)
        m = min(n - tot, BSIZE - off % BSIZE);
80101e17:	29 fb                	sub    %edi,%ebx
80101e19:	39 d9                	cmp    %ebx,%ecx
80101e1b:	0f 46 d9             	cmovbe %ecx,%ebx
        memmove(dst, bp->data + off % BSIZE, m);
80101e1e:	53                   	push   %ebx
80101e1f:	50                   	push   %eax
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101e20:	01 df                	add    %ebx,%edi
        memmove(dst, bp->data + off % BSIZE, m);
80101e22:	ff 75 e0             	pushl  -0x20(%ebp)
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101e25:	01 de                	add    %ebx,%esi
        memmove(dst, bp->data + off % BSIZE, m);
80101e27:	e8 24 2b 00 00       	call   80104950 <memmove>
        brelse(bp);
80101e2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e2f:	89 14 24             	mov    %edx,(%esp)
80101e32:	e8 a9 e3 ff ff       	call   801001e0 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101e37:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101e3a:	83 c4 10             	add    $0x10,%esp
80101e3d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101e40:	77 9e                	ja     80101de0 <readi+0x60>
    }
    return n;
80101e42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e48:	5b                   	pop    %ebx
80101e49:	5e                   	pop    %esi
80101e4a:	5f                   	pop    %edi
80101e4b:	5d                   	pop    %ebp
80101e4c:	c3                   	ret    
80101e4d:	8d 76 00             	lea    0x0(%esi),%esi
        if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read) {
80101e50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e54:	66 83 f8 09          	cmp    $0x9,%ax
80101e58:	77 17                	ja     80101e71 <readi+0xf1>
80101e5a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101e61:	85 c0                	test   %eax,%eax
80101e63:	74 0c                	je     80101e71 <readi+0xf1>
        return devsw[ip->major].read(ip, dst, n);
80101e65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e6b:	5b                   	pop    %ebx
80101e6c:	5e                   	pop    %esi
80101e6d:	5f                   	pop    %edi
80101e6e:	5d                   	pop    %ebp
        return devsw[ip->major].read(ip, dst, n);
80101e6f:	ff e0                	jmp    *%eax
            return -1;
80101e71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e76:	eb cd                	jmp    80101e45 <readi+0xc5>
80101e78:	90                   	nop
80101e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e80 <writei>:

// Write data to inode.
// Caller must hold ip->lock.
int writei(struct inode *ip, char *src, uint off, uint n) {
80101e80:	55                   	push   %ebp
80101e81:	89 e5                	mov    %esp,%ebp
80101e83:	57                   	push   %edi
80101e84:	56                   	push   %esi
80101e85:	53                   	push   %ebx
80101e86:	83 ec 1c             	sub    $0x1c,%esp
80101e89:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101e8f:	8b 7d 14             	mov    0x14(%ebp),%edi
    uint tot, m;
    struct buf *bp;

    if (ip->type == T_DEV) {
80101e92:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
int writei(struct inode *ip, char *src, uint off, uint n) {
80101e97:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101e9a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101e9d:	8b 75 10             	mov    0x10(%ebp),%esi
80101ea0:	89 7d e0             	mov    %edi,-0x20(%ebp)
    if (ip->type == T_DEV) {
80101ea3:	0f 84 b7 00 00 00    	je     80101f60 <writei+0xe0>
            return -1;
        }
        return devsw[ip->major].write(ip, src, n);
    }

    if (off > ip->size || off + n < off) {
80101ea9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101eac:	39 70 58             	cmp    %esi,0x58(%eax)
80101eaf:	0f 82 eb 00 00 00    	jb     80101fa0 <writei+0x120>
80101eb5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101eb8:	31 d2                	xor    %edx,%edx
80101eba:	89 f8                	mov    %edi,%eax
80101ebc:	01 f0                	add    %esi,%eax
80101ebe:	0f 92 c2             	setb   %dl
        return -1;
    }
    if (off + n > MAXFILE * BSIZE) {
80101ec1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ec6:	0f 87 d4 00 00 00    	ja     80101fa0 <writei+0x120>
80101ecc:	85 d2                	test   %edx,%edx
80101ece:	0f 85 cc 00 00 00    	jne    80101fa0 <writei+0x120>
        return -1;
    }

    for (tot = 0; tot < n; tot += m, off += m, src += m) {
80101ed4:	85 ff                	test   %edi,%edi
80101ed6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101edd:	74 72                	je     80101f51 <writei+0xd1>
80101edf:	90                   	nop
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101ee0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ee3:	89 f2                	mov    %esi,%edx
80101ee5:	c1 ea 09             	shr    $0x9,%edx
80101ee8:	89 f8                	mov    %edi,%eax
80101eea:	e8 91 f8 ff ff       	call   80101780 <bmap>
80101eef:	83 ec 08             	sub    $0x8,%esp
80101ef2:	50                   	push   %eax
80101ef3:	ff 37                	pushl  (%edi)
80101ef5:	e8 d6 e1 ff ff       	call   801000d0 <bread>
        m = min(n - tot, BSIZE - off % BSIZE);
80101efa:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101efd:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101f00:	89 c7                	mov    %eax,%edi
        m = min(n - tot, BSIZE - off % BSIZE);
80101f02:	89 f0                	mov    %esi,%eax
80101f04:	b9 00 02 00 00       	mov    $0x200,%ecx
80101f09:	83 c4 0c             	add    $0xc,%esp
80101f0c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f11:	29 c1                	sub    %eax,%ecx
        memmove(bp->data + off % BSIZE, src, m);
80101f13:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
        m = min(n - tot, BSIZE - off % BSIZE);
80101f17:	39 d9                	cmp    %ebx,%ecx
80101f19:	0f 46 d9             	cmovbe %ecx,%ebx
        memmove(bp->data + off % BSIZE, src, m);
80101f1c:	53                   	push   %ebx
80101f1d:	ff 75 dc             	pushl  -0x24(%ebp)
    for (tot = 0; tot < n; tot += m, off += m, src += m) {
80101f20:	01 de                	add    %ebx,%esi
        memmove(bp->data + off % BSIZE, src, m);
80101f22:	50                   	push   %eax
80101f23:	e8 28 2a 00 00       	call   80104950 <memmove>
        log_write(bp);
80101f28:	89 3c 24             	mov    %edi,(%esp)
80101f2b:	e8 60 12 00 00       	call   80103190 <log_write>
        brelse(bp);
80101f30:	89 3c 24             	mov    %edi,(%esp)
80101f33:	e8 a8 e2 ff ff       	call   801001e0 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, src += m) {
80101f38:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101f3b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101f3e:	83 c4 10             	add    $0x10,%esp
80101f41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f44:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101f47:	77 97                	ja     80101ee0 <writei+0x60>
    }

    if (n > 0 && off > ip->size) {
80101f49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f4c:	3b 70 58             	cmp    0x58(%eax),%esi
80101f4f:	77 37                	ja     80101f88 <writei+0x108>
        ip->size = off;
        iupdate(ip);
    }
    return n;
80101f51:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101f54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f57:	5b                   	pop    %ebx
80101f58:	5e                   	pop    %esi
80101f59:	5f                   	pop    %edi
80101f5a:	5d                   	pop    %ebp
80101f5b:	c3                   	ret    
80101f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write) {
80101f60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101f64:	66 83 f8 09          	cmp    $0x9,%ax
80101f68:	77 36                	ja     80101fa0 <writei+0x120>
80101f6a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101f71:	85 c0                	test   %eax,%eax
80101f73:	74 2b                	je     80101fa0 <writei+0x120>
        return devsw[ip->major].write(ip, src, n);
80101f75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f7b:	5b                   	pop    %ebx
80101f7c:	5e                   	pop    %esi
80101f7d:	5f                   	pop    %edi
80101f7e:	5d                   	pop    %ebp
        return devsw[ip->major].write(ip, src, n);
80101f7f:	ff e0                	jmp    *%eax
80101f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        ip->size = off;
80101f88:	8b 45 d8             	mov    -0x28(%ebp),%eax
        iupdate(ip);
80101f8b:	83 ec 0c             	sub    $0xc,%esp
        ip->size = off;
80101f8e:	89 70 58             	mov    %esi,0x58(%eax)
        iupdate(ip);
80101f91:	50                   	push   %eax
80101f92:	e8 59 fa ff ff       	call   801019f0 <iupdate>
80101f97:	83 c4 10             	add    $0x10,%esp
80101f9a:	eb b5                	jmp    80101f51 <writei+0xd1>
80101f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            return -1;
80101fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fa5:	eb ad                	jmp    80101f54 <writei+0xd4>
80101fa7:	89 f6                	mov    %esi,%esi
80101fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fb0 <namecmp>:


// Directories

int namecmp(const char *s, const char *t) {
80101fb0:	55                   	push   %ebp
80101fb1:	89 e5                	mov    %esp,%ebp
80101fb3:	83 ec 0c             	sub    $0xc,%esp
    return strncmp(s, t, DIRSIZ);
80101fb6:	6a 0e                	push   $0xe
80101fb8:	ff 75 0c             	pushl  0xc(%ebp)
80101fbb:	ff 75 08             	pushl  0x8(%ebp)
80101fbe:	e8 fd 29 00 00       	call   801049c0 <strncmp>
}
80101fc3:	c9                   	leave  
80101fc4:	c3                   	ret    
80101fc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode* dirlookup(struct inode *dp, char *name, uint *poff) {
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	57                   	push   %edi
80101fd4:	56                   	push   %esi
80101fd5:	53                   	push   %ebx
80101fd6:	83 ec 1c             	sub    $0x1c,%esp
80101fd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    uint off, inum;
    struct dirent de;

    if (dp->type != T_DIR) {
80101fdc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101fe1:	0f 85 85 00 00 00    	jne    8010206c <dirlookup+0x9c>
        panic("dirlookup not DIR");
    }

    for (off = 0; off < dp->size; off += sizeof(de)) {
80101fe7:	8b 53 58             	mov    0x58(%ebx),%edx
80101fea:	31 ff                	xor    %edi,%edi
80101fec:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fef:	85 d2                	test   %edx,%edx
80101ff1:	74 3e                	je     80102031 <dirlookup+0x61>
80101ff3:	90                   	nop
80101ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80101ff8:	6a 10                	push   $0x10
80101ffa:	57                   	push   %edi
80101ffb:	56                   	push   %esi
80101ffc:	53                   	push   %ebx
80101ffd:	e8 7e fd ff ff       	call   80101d80 <readi>
80102002:	83 c4 10             	add    $0x10,%esp
80102005:	83 f8 10             	cmp    $0x10,%eax
80102008:	75 55                	jne    8010205f <dirlookup+0x8f>
            panic("dirlookup read");
        }
        if (de.inum == 0) {
8010200a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010200f:	74 18                	je     80102029 <dirlookup+0x59>
    return strncmp(s, t, DIRSIZ);
80102011:	8d 45 da             	lea    -0x26(%ebp),%eax
80102014:	83 ec 04             	sub    $0x4,%esp
80102017:	6a 0e                	push   $0xe
80102019:	50                   	push   %eax
8010201a:	ff 75 0c             	pushl  0xc(%ebp)
8010201d:	e8 9e 29 00 00       	call   801049c0 <strncmp>
            continue;
        }
        if (namecmp(name, de.name) == 0) {
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	85 c0                	test   %eax,%eax
80102027:	74 17                	je     80102040 <dirlookup+0x70>
    for (off = 0; off < dp->size; off += sizeof(de)) {
80102029:	83 c7 10             	add    $0x10,%edi
8010202c:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010202f:	72 c7                	jb     80101ff8 <dirlookup+0x28>
            return iget(dp->dev, inum);
        }
    }

    return 0;
}
80102031:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80102034:	31 c0                	xor    %eax,%eax
}
80102036:	5b                   	pop    %ebx
80102037:	5e                   	pop    %esi
80102038:	5f                   	pop    %edi
80102039:	5d                   	pop    %ebp
8010203a:	c3                   	ret    
8010203b:	90                   	nop
8010203c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            if (poff) {
80102040:	8b 45 10             	mov    0x10(%ebp),%eax
80102043:	85 c0                	test   %eax,%eax
80102045:	74 05                	je     8010204c <dirlookup+0x7c>
                *poff = off;
80102047:	8b 45 10             	mov    0x10(%ebp),%eax
8010204a:	89 38                	mov    %edi,(%eax)
            inum = de.inum;
8010204c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
            return iget(dp->dev, inum);
80102050:	8b 03                	mov    (%ebx),%eax
80102052:	e8 59 f6 ff ff       	call   801016b0 <iget>
}
80102057:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010205a:	5b                   	pop    %ebx
8010205b:	5e                   	pop    %esi
8010205c:	5f                   	pop    %edi
8010205d:	5d                   	pop    %ebp
8010205e:	c3                   	ret    
            panic("dirlookup read");
8010205f:	83 ec 0c             	sub    $0xc,%esp
80102062:	68 59 75 10 80       	push   $0x80107559
80102067:	e8 14 e4 ff ff       	call   80100480 <panic>
        panic("dirlookup not DIR");
8010206c:	83 ec 0c             	sub    $0xc,%esp
8010206f:	68 47 75 10 80       	push   $0x80107547
80102074:	e8 07 e4 ff ff       	call   80100480 <panic>
80102079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102080 <namex>:

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode* namex(char *path, int nameiparent, char *name)                     {
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	89 cf                	mov    %ecx,%edi
80102088:	89 c3                	mov    %eax,%ebx
8010208a:	83 ec 1c             	sub    $0x1c,%esp
    struct inode *ip, *next;

    if (*path == '/') {
8010208d:	80 38 2f             	cmpb   $0x2f,(%eax)
static struct inode* namex(char *path, int nameiparent, char *name)                     {
80102090:	89 55 e0             	mov    %edx,-0x20(%ebp)
    if (*path == '/') {
80102093:	0f 84 67 01 00 00    	je     80102200 <namex+0x180>
        ip = iget(ROOTDEV, ROOTINO);
    }
    else {
        ip = idup(myproc()->cwd);
80102099:	e8 92 1b 00 00       	call   80103c30 <myproc>
    acquire(&icache.lock);
8010209e:	83 ec 0c             	sub    $0xc,%esp
        ip = idup(myproc()->cwd);
801020a1:	8b 70 68             	mov    0x68(%eax),%esi
    acquire(&icache.lock);
801020a4:	68 e0 19 11 80       	push   $0x801119e0
801020a9:	e8 e2 26 00 00       	call   80104790 <acquire>
    ip->ref++;
801020ae:	83 46 08 01          	addl   $0x1,0x8(%esi)
    release(&icache.lock);
801020b2:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801020b9:	e8 92 27 00 00       	call   80104850 <release>
801020be:	83 c4 10             	add    $0x10,%esp
801020c1:	eb 08                	jmp    801020cb <namex+0x4b>
801020c3:	90                   	nop
801020c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        path++;
801020c8:	83 c3 01             	add    $0x1,%ebx
    while (*path == '/') {
801020cb:	0f b6 03             	movzbl (%ebx),%eax
801020ce:	3c 2f                	cmp    $0x2f,%al
801020d0:	74 f6                	je     801020c8 <namex+0x48>
    if (*path == 0) {
801020d2:	84 c0                	test   %al,%al
801020d4:	0f 84 ee 00 00 00    	je     801021c8 <namex+0x148>
    while (*path != '/' && *path != 0) {
801020da:	0f b6 03             	movzbl (%ebx),%eax
801020dd:	3c 2f                	cmp    $0x2f,%al
801020df:	0f 84 b3 00 00 00    	je     80102198 <namex+0x118>
801020e5:	84 c0                	test   %al,%al
801020e7:	89 da                	mov    %ebx,%edx
801020e9:	75 09                	jne    801020f4 <namex+0x74>
801020eb:	e9 a8 00 00 00       	jmp    80102198 <namex+0x118>
801020f0:	84 c0                	test   %al,%al
801020f2:	74 0a                	je     801020fe <namex+0x7e>
        path++;
801020f4:	83 c2 01             	add    $0x1,%edx
    while (*path != '/' && *path != 0) {
801020f7:	0f b6 02             	movzbl (%edx),%eax
801020fa:	3c 2f                	cmp    $0x2f,%al
801020fc:	75 f2                	jne    801020f0 <namex+0x70>
801020fe:	89 d1                	mov    %edx,%ecx
80102100:	29 d9                	sub    %ebx,%ecx
    if (len >= DIRSIZ) {
80102102:	83 f9 0d             	cmp    $0xd,%ecx
80102105:	0f 8e 91 00 00 00    	jle    8010219c <namex+0x11c>
        memmove(name, s, DIRSIZ);
8010210b:	83 ec 04             	sub    $0x4,%esp
8010210e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102111:	6a 0e                	push   $0xe
80102113:	53                   	push   %ebx
80102114:	57                   	push   %edi
80102115:	e8 36 28 00 00       	call   80104950 <memmove>
        path++;
8010211a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        memmove(name, s, DIRSIZ);
8010211d:	83 c4 10             	add    $0x10,%esp
        path++;
80102120:	89 d3                	mov    %edx,%ebx
    while (*path == '/') {
80102122:	80 3a 2f             	cmpb   $0x2f,(%edx)
80102125:	75 11                	jne    80102138 <namex+0xb8>
80102127:	89 f6                	mov    %esi,%esi
80102129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        path++;
80102130:	83 c3 01             	add    $0x1,%ebx
    while (*path == '/') {
80102133:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102136:	74 f8                	je     80102130 <namex+0xb0>
    }

    while ((path = skipelem(path, name)) != 0) {
        ilock(ip);
80102138:	83 ec 0c             	sub    $0xc,%esp
8010213b:	56                   	push   %esi
8010213c:	e8 5f f9 ff ff       	call   80101aa0 <ilock>
        if (ip->type != T_DIR) {
80102141:	83 c4 10             	add    $0x10,%esp
80102144:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102149:	0f 85 91 00 00 00    	jne    801021e0 <namex+0x160>
            iunlockput(ip);
            return 0;
        }
        if (nameiparent && *path == '\0') {
8010214f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102152:	85 d2                	test   %edx,%edx
80102154:	74 09                	je     8010215f <namex+0xdf>
80102156:	80 3b 00             	cmpb   $0x0,(%ebx)
80102159:	0f 84 b7 00 00 00    	je     80102216 <namex+0x196>
            // Stop one level early.
            iunlock(ip);
            return ip;
        }
        if ((next = dirlookup(ip, name, 0)) == 0) {
8010215f:	83 ec 04             	sub    $0x4,%esp
80102162:	6a 00                	push   $0x0
80102164:	57                   	push   %edi
80102165:	56                   	push   %esi
80102166:	e8 65 fe ff ff       	call   80101fd0 <dirlookup>
8010216b:	83 c4 10             	add    $0x10,%esp
8010216e:	85 c0                	test   %eax,%eax
80102170:	74 6e                	je     801021e0 <namex+0x160>
    iunlock(ip);
80102172:	83 ec 0c             	sub    $0xc,%esp
80102175:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102178:	56                   	push   %esi
80102179:	e8 02 fa ff ff       	call   80101b80 <iunlock>
    iput(ip);
8010217e:	89 34 24             	mov    %esi,(%esp)
80102181:	e8 4a fa ff ff       	call   80101bd0 <iput>
80102186:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102189:	83 c4 10             	add    $0x10,%esp
8010218c:	89 c6                	mov    %eax,%esi
8010218e:	e9 38 ff ff ff       	jmp    801020cb <namex+0x4b>
80102193:	90                   	nop
80102194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while (*path != '/' && *path != 0) {
80102198:	89 da                	mov    %ebx,%edx
8010219a:	31 c9                	xor    %ecx,%ecx
        memmove(name, s, len);
8010219c:	83 ec 04             	sub    $0x4,%esp
8010219f:	89 55 dc             	mov    %edx,-0x24(%ebp)
801021a2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801021a5:	51                   	push   %ecx
801021a6:	53                   	push   %ebx
801021a7:	57                   	push   %edi
801021a8:	e8 a3 27 00 00       	call   80104950 <memmove>
        name[len] = 0;
801021ad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801021b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
801021b3:	83 c4 10             	add    $0x10,%esp
801021b6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
801021ba:	89 d3                	mov    %edx,%ebx
801021bc:	e9 61 ff ff ff       	jmp    80102122 <namex+0xa2>
801021c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            return 0;
        }
        iunlockput(ip);
        ip = next;
    }
    if (nameiparent) {
801021c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801021cb:	85 c0                	test   %eax,%eax
801021cd:	75 5d                	jne    8010222c <namex+0x1ac>
        iput(ip);
        return 0;
    }
    return ip;
}
801021cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021d2:	89 f0                	mov    %esi,%eax
801021d4:	5b                   	pop    %ebx
801021d5:	5e                   	pop    %esi
801021d6:	5f                   	pop    %edi
801021d7:	5d                   	pop    %ebp
801021d8:	c3                   	ret    
801021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlock(ip);
801021e0:	83 ec 0c             	sub    $0xc,%esp
801021e3:	56                   	push   %esi
801021e4:	e8 97 f9 ff ff       	call   80101b80 <iunlock>
    iput(ip);
801021e9:	89 34 24             	mov    %esi,(%esp)
            return 0;
801021ec:	31 f6                	xor    %esi,%esi
    iput(ip);
801021ee:	e8 dd f9 ff ff       	call   80101bd0 <iput>
            return 0;
801021f3:	83 c4 10             	add    $0x10,%esp
}
801021f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021f9:	89 f0                	mov    %esi,%eax
801021fb:	5b                   	pop    %ebx
801021fc:	5e                   	pop    %esi
801021fd:	5f                   	pop    %edi
801021fe:	5d                   	pop    %ebp
801021ff:	c3                   	ret    
        ip = iget(ROOTDEV, ROOTINO);
80102200:	ba 01 00 00 00       	mov    $0x1,%edx
80102205:	b8 01 00 00 00       	mov    $0x1,%eax
8010220a:	e8 a1 f4 ff ff       	call   801016b0 <iget>
8010220f:	89 c6                	mov    %eax,%esi
80102211:	e9 b5 fe ff ff       	jmp    801020cb <namex+0x4b>
            iunlock(ip);
80102216:	83 ec 0c             	sub    $0xc,%esp
80102219:	56                   	push   %esi
8010221a:	e8 61 f9 ff ff       	call   80101b80 <iunlock>
            return ip;
8010221f:	83 c4 10             	add    $0x10,%esp
}
80102222:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102225:	89 f0                	mov    %esi,%eax
80102227:	5b                   	pop    %ebx
80102228:	5e                   	pop    %esi
80102229:	5f                   	pop    %edi
8010222a:	5d                   	pop    %ebp
8010222b:	c3                   	ret    
        iput(ip);
8010222c:	83 ec 0c             	sub    $0xc,%esp
8010222f:	56                   	push   %esi
        return 0;
80102230:	31 f6                	xor    %esi,%esi
        iput(ip);
80102232:	e8 99 f9 ff ff       	call   80101bd0 <iput>
        return 0;
80102237:	83 c4 10             	add    $0x10,%esp
8010223a:	eb 93                	jmp    801021cf <namex+0x14f>
8010223c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102240 <dirlink>:
int dirlink(struct inode *dp, char *name, uint inum) {
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 20             	sub    $0x20,%esp
80102249:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if ((ip = dirlookup(dp, name, 0)) != 0) {
8010224c:	6a 00                	push   $0x0
8010224e:	ff 75 0c             	pushl  0xc(%ebp)
80102251:	53                   	push   %ebx
80102252:	e8 79 fd ff ff       	call   80101fd0 <dirlookup>
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	85 c0                	test   %eax,%eax
8010225c:	75 67                	jne    801022c5 <dirlink+0x85>
    for (off = 0; off < dp->size; off += sizeof(de)) {
8010225e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102261:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102264:	85 ff                	test   %edi,%edi
80102266:	74 29                	je     80102291 <dirlink+0x51>
80102268:	31 ff                	xor    %edi,%edi
8010226a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010226d:	eb 09                	jmp    80102278 <dirlink+0x38>
8010226f:	90                   	nop
80102270:	83 c7 10             	add    $0x10,%edi
80102273:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102276:	73 19                	jae    80102291 <dirlink+0x51>
        if (readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80102278:	6a 10                	push   $0x10
8010227a:	57                   	push   %edi
8010227b:	56                   	push   %esi
8010227c:	53                   	push   %ebx
8010227d:	e8 fe fa ff ff       	call   80101d80 <readi>
80102282:	83 c4 10             	add    $0x10,%esp
80102285:	83 f8 10             	cmp    $0x10,%eax
80102288:	75 4e                	jne    801022d8 <dirlink+0x98>
        if (de.inum == 0) {
8010228a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010228f:	75 df                	jne    80102270 <dirlink+0x30>
    strncpy(de.name, name, DIRSIZ);
80102291:	8d 45 da             	lea    -0x26(%ebp),%eax
80102294:	83 ec 04             	sub    $0x4,%esp
80102297:	6a 0e                	push   $0xe
80102299:	ff 75 0c             	pushl  0xc(%ebp)
8010229c:	50                   	push   %eax
8010229d:	e8 7e 27 00 00       	call   80104a20 <strncpy>
    de.inum = inum;
801022a2:	8b 45 10             	mov    0x10(%ebp),%eax
    if (writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
801022a5:	6a 10                	push   $0x10
801022a7:	57                   	push   %edi
801022a8:	56                   	push   %esi
801022a9:	53                   	push   %ebx
    de.inum = inum;
801022aa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    if (writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
801022ae:	e8 cd fb ff ff       	call   80101e80 <writei>
801022b3:	83 c4 20             	add    $0x20,%esp
801022b6:	83 f8 10             	cmp    $0x10,%eax
801022b9:	75 2a                	jne    801022e5 <dirlink+0xa5>
    return 0;
801022bb:	31 c0                	xor    %eax,%eax
}
801022bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022c0:	5b                   	pop    %ebx
801022c1:	5e                   	pop    %esi
801022c2:	5f                   	pop    %edi
801022c3:	5d                   	pop    %ebp
801022c4:	c3                   	ret    
        iput(ip);
801022c5:	83 ec 0c             	sub    $0xc,%esp
801022c8:	50                   	push   %eax
801022c9:	e8 02 f9 ff ff       	call   80101bd0 <iput>
        return -1;
801022ce:	83 c4 10             	add    $0x10,%esp
801022d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022d6:	eb e5                	jmp    801022bd <dirlink+0x7d>
            panic("dirlink read");
801022d8:	83 ec 0c             	sub    $0xc,%esp
801022db:	68 68 75 10 80       	push   $0x80107568
801022e0:	e8 9b e1 ff ff       	call   80100480 <panic>
        panic("dirlink");
801022e5:	83 ec 0c             	sub    $0xc,%esp
801022e8:	68 76 7b 10 80       	push   $0x80107b76
801022ed:	e8 8e e1 ff ff       	call   80100480 <panic>
801022f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102300 <namei>:

struct inode* namei(char *path) {
80102300:	55                   	push   %ebp
    char name[DIRSIZ];
    return namex(path, 0, name);
80102301:	31 d2                	xor    %edx,%edx
struct inode* namei(char *path) {
80102303:	89 e5                	mov    %esp,%ebp
80102305:	83 ec 18             	sub    $0x18,%esp
    return namex(path, 0, name);
80102308:	8b 45 08             	mov    0x8(%ebp),%eax
8010230b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010230e:	e8 6d fd ff ff       	call   80102080 <namex>
}
80102313:	c9                   	leave  
80102314:	c3                   	ret    
80102315:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102320 <nameiparent>:

struct inode*nameiparent(char *path, char *name) {
80102320:	55                   	push   %ebp
    return namex(path, 1, name);
80102321:	ba 01 00 00 00       	mov    $0x1,%edx
struct inode*nameiparent(char *path, char *name) {
80102326:	89 e5                	mov    %esp,%ebp
    return namex(path, 1, name);
80102328:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010232b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010232e:	5d                   	pop    %ebp
    return namex(path, 1, name);
8010232f:	e9 4c fd ff ff       	jmp    80102080 <namex>
80102334:	66 90                	xchg   %ax,%ax
80102336:	66 90                	xchg   %ax,%ax
80102338:	66 90                	xchg   %ax,%ax
8010233a:	66 90                	xchg   %ax,%ax
8010233c:	66 90                	xchg   %ax,%ax
8010233e:	66 90                	xchg   %ax,%ax

80102340 <idestart>:
    // Switch back to disk 0.
    outb(0x1f6, 0xe0 | (0 << 4));
}

// Start the request for b.  Caller must hold idelock.
static void idestart(struct buf *b) {
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	57                   	push   %edi
80102344:	56                   	push   %esi
80102345:	53                   	push   %ebx
80102346:	83 ec 0c             	sub    $0xc,%esp
    if (b == 0) {
80102349:	85 c0                	test   %eax,%eax
8010234b:	0f 84 b4 00 00 00    	je     80102405 <idestart+0xc5>
        panic("idestart");
    }
    if (b->blockno >= FSSIZE) {
80102351:	8b 58 08             	mov    0x8(%eax),%ebx
80102354:	89 c6                	mov    %eax,%esi
80102356:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010235c:	0f 87 96 00 00 00    	ja     801023f8 <idestart+0xb8>
80102362:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102367:	89 f6                	mov    %esi,%esi
80102369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102370:	89 ca                	mov    %ecx,%edx
80102372:	ec                   	in     (%dx),%al
    while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY) {
80102373:	83 e0 c0             	and    $0xffffffc0,%eax
80102376:	3c 40                	cmp    $0x40,%al
80102378:	75 f6                	jne    80102370 <idestart+0x30>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
8010237a:	31 ff                	xor    %edi,%edi
8010237c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102381:	89 f8                	mov    %edi,%eax
80102383:	ee                   	out    %al,(%dx)
80102384:	b8 01 00 00 00       	mov    $0x1,%eax
80102389:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010238e:	ee                   	out    %al,(%dx)
8010238f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102394:	89 d8                	mov    %ebx,%eax
80102396:	ee                   	out    %al,(%dx)

    idewait(0);
    outb(0x3f6, 0);  // generate interrupt
    outb(0x1f2, sector_per_block);  // number of sectors
    outb(0x1f3, sector & 0xff);
    outb(0x1f4, (sector >> 8) & 0xff);
80102397:	89 d8                	mov    %ebx,%eax
80102399:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010239e:	c1 f8 08             	sar    $0x8,%eax
801023a1:	ee                   	out    %al,(%dx)
801023a2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801023a7:	89 f8                	mov    %edi,%eax
801023a9:	ee                   	out    %al,(%dx)
    outb(0x1f5, (sector >> 16) & 0xff);
    outb(0x1f6, 0xe0 | ((b->dev & 1) << 4) | ((sector >> 24) & 0x0f));
801023aa:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801023ae:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023b3:	c1 e0 04             	shl    $0x4,%eax
801023b6:	83 e0 10             	and    $0x10,%eax
801023b9:	83 c8 e0             	or     $0xffffffe0,%eax
801023bc:	ee                   	out    %al,(%dx)
    if (b->flags & B_DIRTY) {
801023bd:	f6 06 04             	testb  $0x4,(%esi)
801023c0:	75 16                	jne    801023d8 <idestart+0x98>
801023c2:	b8 20 00 00 00       	mov    $0x20,%eax
801023c7:	89 ca                	mov    %ecx,%edx
801023c9:	ee                   	out    %al,(%dx)
        outsl(0x1f0, b->data, BSIZE / 4);
    }
    else {
        outb(0x1f7, read_cmd);
    }
}
801023ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023cd:	5b                   	pop    %ebx
801023ce:	5e                   	pop    %esi
801023cf:	5f                   	pop    %edi
801023d0:	5d                   	pop    %ebp
801023d1:	c3                   	ret    
801023d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801023d8:	b8 30 00 00 00       	mov    $0x30,%eax
801023dd:	89 ca                	mov    %ecx,%edx
801023df:	ee                   	out    %al,(%dx)
    asm volatile ("cld; rep outsl" :
801023e0:	b9 80 00 00 00       	mov    $0x80,%ecx
        outsl(0x1f0, b->data, BSIZE / 4);
801023e5:	83 c6 5c             	add    $0x5c,%esi
801023e8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801023ed:	fc                   	cld    
801023ee:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801023f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023f3:	5b                   	pop    %ebx
801023f4:	5e                   	pop    %esi
801023f5:	5f                   	pop    %edi
801023f6:	5d                   	pop    %ebp
801023f7:	c3                   	ret    
        panic("incorrect blockno");
801023f8:	83 ec 0c             	sub    $0xc,%esp
801023fb:	68 d4 75 10 80       	push   $0x801075d4
80102400:	e8 7b e0 ff ff       	call   80100480 <panic>
        panic("idestart");
80102405:	83 ec 0c             	sub    $0xc,%esp
80102408:	68 cb 75 10 80       	push   $0x801075cb
8010240d:	e8 6e e0 ff ff       	call   80100480 <panic>
80102412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102420 <ideinit>:
void ideinit(void) {
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	83 ec 10             	sub    $0x10,%esp
    initlock(&idelock, "ide");
80102426:	68 e6 75 10 80       	push   $0x801075e6
8010242b:	68 80 b5 10 80       	push   $0x8010b580
80102430:	e8 1b 22 00 00       	call   80104650 <initlock>
    ioapicenable(IRQ_IDE, ncpu - 1);
80102435:	58                   	pop    %eax
80102436:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010243b:	5a                   	pop    %edx
8010243c:	83 e8 01             	sub    $0x1,%eax
8010243f:	50                   	push   %eax
80102440:	6a 0e                	push   $0xe
80102442:	e8 a9 02 00 00       	call   801026f0 <ioapicenable>
80102447:	83 c4 10             	add    $0x10,%esp
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
8010244a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010244f:	90                   	nop
80102450:	ec                   	in     (%dx),%al
    while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY) {
80102451:	83 e0 c0             	and    $0xffffffc0,%eax
80102454:	3c 40                	cmp    $0x40,%al
80102456:	75 f8                	jne    80102450 <ideinit+0x30>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102458:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010245d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102462:	ee                   	out    %al,(%dx)
80102463:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102468:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010246d:	eb 06                	jmp    80102475 <ideinit+0x55>
8010246f:	90                   	nop
    for (i = 0; i < 1000; i++) {
80102470:	83 e9 01             	sub    $0x1,%ecx
80102473:	74 0f                	je     80102484 <ideinit+0x64>
80102475:	ec                   	in     (%dx),%al
        if (inb(0x1f7) != 0) {
80102476:	84 c0                	test   %al,%al
80102478:	74 f6                	je     80102470 <ideinit+0x50>
            havedisk1 = 1;
8010247a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102481:	00 00 00 
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102484:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102489:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010248e:	ee                   	out    %al,(%dx)
}
8010248f:	c9                   	leave  
80102490:	c3                   	ret    
80102491:	eb 0d                	jmp    801024a0 <ideintr>
80102493:	90                   	nop
80102494:	90                   	nop
80102495:	90                   	nop
80102496:	90                   	nop
80102497:	90                   	nop
80102498:	90                   	nop
80102499:	90                   	nop
8010249a:	90                   	nop
8010249b:	90                   	nop
8010249c:	90                   	nop
8010249d:	90                   	nop
8010249e:	90                   	nop
8010249f:	90                   	nop

801024a0 <ideintr>:

// Interrupt handler.
void ideintr(void) {
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	57                   	push   %edi
801024a4:	56                   	push   %esi
801024a5:	53                   	push   %ebx
801024a6:	83 ec 18             	sub    $0x18,%esp
    struct buf *b;

    // First queued buffer is the active request.
    acquire(&idelock);
801024a9:	68 80 b5 10 80       	push   $0x8010b580
801024ae:	e8 dd 22 00 00       	call   80104790 <acquire>

    if ((b = idequeue) == 0) {
801024b3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801024b9:	83 c4 10             	add    $0x10,%esp
801024bc:	85 db                	test   %ebx,%ebx
801024be:	74 67                	je     80102527 <ideintr+0x87>
        release(&idelock);
        return;
    }
    idequeue = b->qnext;
801024c0:	8b 43 58             	mov    0x58(%ebx),%eax
801024c3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

    // Read data if needed.
    if (!(b->flags & B_DIRTY) && idewait(1) >= 0) {
801024c8:	8b 3b                	mov    (%ebx),%edi
801024ca:	f7 c7 04 00 00 00    	test   $0x4,%edi
801024d0:	75 31                	jne    80102503 <ideintr+0x63>
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
801024d2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024d7:	89 f6                	mov    %esi,%esi
801024d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801024e0:	ec                   	in     (%dx),%al
    while (((r = inb(0x1f7)) & (IDE_BSY | IDE_DRDY)) != IDE_DRDY) {
801024e1:	89 c6                	mov    %eax,%esi
801024e3:	83 e6 c0             	and    $0xffffffc0,%esi
801024e6:	89 f1                	mov    %esi,%ecx
801024e8:	80 f9 40             	cmp    $0x40,%cl
801024eb:	75 f3                	jne    801024e0 <ideintr+0x40>
    if (checkerr && (r & (IDE_DF | IDE_ERR)) != 0) {
801024ed:	a8 21                	test   $0x21,%al
801024ef:	75 12                	jne    80102503 <ideintr+0x63>
        insl(0x1f0, b->data, BSIZE / 4);
801024f1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
    asm volatile ("cld; rep insl" :
801024f4:	b9 80 00 00 00       	mov    $0x80,%ecx
801024f9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801024fe:	fc                   	cld    
801024ff:	f3 6d                	rep insl (%dx),%es:(%edi)
80102501:	8b 3b                	mov    (%ebx),%edi
    }

    // Wake process waiting for this buf.
    b->flags |= B_VALID;
    b->flags &= ~B_DIRTY;
80102503:	83 e7 fb             	and    $0xfffffffb,%edi
    wakeup(b);
80102506:	83 ec 0c             	sub    $0xc,%esp
    b->flags &= ~B_DIRTY;
80102509:	89 f9                	mov    %edi,%ecx
8010250b:	83 c9 02             	or     $0x2,%ecx
8010250e:	89 0b                	mov    %ecx,(%ebx)
    wakeup(b);
80102510:	53                   	push   %ebx
80102511:	e8 6a 1e 00 00       	call   80104380 <wakeup>

    // Start disk on next buf in queue.
    if (idequeue != 0) {
80102516:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010251b:	83 c4 10             	add    $0x10,%esp
8010251e:	85 c0                	test   %eax,%eax
80102520:	74 05                	je     80102527 <ideintr+0x87>
        idestart(idequeue);
80102522:	e8 19 fe ff ff       	call   80102340 <idestart>
        release(&idelock);
80102527:	83 ec 0c             	sub    $0xc,%esp
8010252a:	68 80 b5 10 80       	push   $0x8010b580
8010252f:	e8 1c 23 00 00       	call   80104850 <release>
    }

    release(&idelock);
}
80102534:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102537:	5b                   	pop    %ebx
80102538:	5e                   	pop    %esi
80102539:	5f                   	pop    %edi
8010253a:	5d                   	pop    %ebp
8010253b:	c3                   	ret    
8010253c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102540 <iderw>:


// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void iderw(struct buf *b) {
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	53                   	push   %ebx
80102544:	83 ec 10             	sub    $0x10,%esp
80102547:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct buf **pp;

    if (!holdingsleep(&b->lock)) {
8010254a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010254d:	50                   	push   %eax
8010254e:	e8 ad 20 00 00       	call   80104600 <holdingsleep>
80102553:	83 c4 10             	add    $0x10,%esp
80102556:	85 c0                	test   %eax,%eax
80102558:	0f 84 c6 00 00 00    	je     80102624 <iderw+0xe4>
        panic("iderw: buf not locked");
    }
    if ((b->flags & (B_VALID | B_DIRTY)) == B_VALID) {
8010255e:	8b 03                	mov    (%ebx),%eax
80102560:	83 e0 06             	and    $0x6,%eax
80102563:	83 f8 02             	cmp    $0x2,%eax
80102566:	0f 84 ab 00 00 00    	je     80102617 <iderw+0xd7>
        panic("iderw: nothing to do");
    }
    if (b->dev != 0 && !havedisk1) {
8010256c:	8b 53 04             	mov    0x4(%ebx),%edx
8010256f:	85 d2                	test   %edx,%edx
80102571:	74 0d                	je     80102580 <iderw+0x40>
80102573:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102578:	85 c0                	test   %eax,%eax
8010257a:	0f 84 b1 00 00 00    	je     80102631 <iderw+0xf1>
        panic("iderw: ide disk 1 not present");
    }

    acquire(&idelock);  //DOC:acquire-lock
80102580:	83 ec 0c             	sub    $0xc,%esp
80102583:	68 80 b5 10 80       	push   $0x8010b580
80102588:	e8 03 22 00 00       	call   80104790 <acquire>

    // Append b to idequeue.
    b->qnext = 0;
    for (pp = &idequeue; *pp; pp = &(*pp)->qnext) { //DOC:insert-queue
8010258d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102593:	83 c4 10             	add    $0x10,%esp
    b->qnext = 0;
80102596:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
    for (pp = &idequeue; *pp; pp = &(*pp)->qnext) { //DOC:insert-queue
8010259d:	85 d2                	test   %edx,%edx
8010259f:	75 09                	jne    801025aa <iderw+0x6a>
801025a1:	eb 6d                	jmp    80102610 <iderw+0xd0>
801025a3:	90                   	nop
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025a8:	89 c2                	mov    %eax,%edx
801025aa:	8b 42 58             	mov    0x58(%edx),%eax
801025ad:	85 c0                	test   %eax,%eax
801025af:	75 f7                	jne    801025a8 <iderw+0x68>
801025b1:	83 c2 58             	add    $0x58,%edx
        ;
    }
    *pp = b;
801025b4:	89 1a                	mov    %ebx,(%edx)

    // Start disk if necessary.
    if (idequeue == b) {
801025b6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801025bc:	74 42                	je     80102600 <iderw+0xc0>
        idestart(b);
    }

    // Wait for request to finish.
    while ((b->flags & (B_VALID | B_DIRTY)) != B_VALID) {
801025be:	8b 03                	mov    (%ebx),%eax
801025c0:	83 e0 06             	and    $0x6,%eax
801025c3:	83 f8 02             	cmp    $0x2,%eax
801025c6:	74 23                	je     801025eb <iderw+0xab>
801025c8:	90                   	nop
801025c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        sleep(b, &idelock);
801025d0:	83 ec 08             	sub    $0x8,%esp
801025d3:	68 80 b5 10 80       	push   $0x8010b580
801025d8:	53                   	push   %ebx
801025d9:	e8 f2 1b 00 00       	call   801041d0 <sleep>
    while ((b->flags & (B_VALID | B_DIRTY)) != B_VALID) {
801025de:	8b 03                	mov    (%ebx),%eax
801025e0:	83 c4 10             	add    $0x10,%esp
801025e3:	83 e0 06             	and    $0x6,%eax
801025e6:	83 f8 02             	cmp    $0x2,%eax
801025e9:	75 e5                	jne    801025d0 <iderw+0x90>
    }

    release(&idelock);
801025eb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801025f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025f5:	c9                   	leave  
    release(&idelock);
801025f6:	e9 55 22 00 00       	jmp    80104850 <release>
801025fb:	90                   	nop
801025fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        idestart(b);
80102600:	89 d8                	mov    %ebx,%eax
80102602:	e8 39 fd ff ff       	call   80102340 <idestart>
80102607:	eb b5                	jmp    801025be <iderw+0x7e>
80102609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (pp = &idequeue; *pp; pp = &(*pp)->qnext) { //DOC:insert-queue
80102610:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102615:	eb 9d                	jmp    801025b4 <iderw+0x74>
        panic("iderw: nothing to do");
80102617:	83 ec 0c             	sub    $0xc,%esp
8010261a:	68 00 76 10 80       	push   $0x80107600
8010261f:	e8 5c de ff ff       	call   80100480 <panic>
        panic("iderw: buf not locked");
80102624:	83 ec 0c             	sub    $0xc,%esp
80102627:	68 ea 75 10 80       	push   $0x801075ea
8010262c:	e8 4f de ff ff       	call   80100480 <panic>
        panic("iderw: ide disk 1 not present");
80102631:	83 ec 0c             	sub    $0xc,%esp
80102634:	68 15 76 10 80       	push   $0x80107615
80102639:	e8 42 de ff ff       	call   80100480 <panic>
8010263e:	66 90                	xchg   %ax,%ax

80102640 <ioapicinit>:
static void ioapicwrite(int reg, uint data) {
    ioapic->reg = reg;
    ioapic->data = data;
}

void ioapicinit(void) {
80102640:	55                   	push   %ebp
    int i, id, maxintr;

    ioapic = (volatile struct ioapic*)IOAPIC;
80102641:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102648:	00 c0 fe 
void ioapicinit(void) {
8010264b:	89 e5                	mov    %esp,%ebp
8010264d:	56                   	push   %esi
8010264e:	53                   	push   %ebx
    ioapic->reg = reg;
8010264f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102656:	00 00 00 
    return ioapic->data;
80102659:	a1 34 36 11 80       	mov    0x80113634,%eax
8010265e:	8b 58 10             	mov    0x10(%eax),%ebx
    ioapic->reg = reg;
80102661:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    return ioapic->data;
80102667:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
    maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
    id = ioapicread(REG_ID) >> 24;
    if (id != ioapicid) {
8010266d:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
    maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102674:	c1 eb 10             	shr    $0x10,%ebx
    return ioapic->data;
80102677:	8b 41 10             	mov    0x10(%ecx),%eax
    maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010267a:	0f b6 db             	movzbl %bl,%ebx
    id = ioapicread(REG_ID) >> 24;
8010267d:	c1 e8 18             	shr    $0x18,%eax
    if (id != ioapicid) {
80102680:	39 c2                	cmp    %eax,%edx
80102682:	74 16                	je     8010269a <ioapicinit+0x5a>
        cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102684:	83 ec 0c             	sub    $0xc,%esp
80102687:	68 34 76 10 80       	push   $0x80107634
8010268c:	e8 bf e0 ff ff       	call   80100750 <cprintf>
80102691:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102697:	83 c4 10             	add    $0x10,%esp
8010269a:	83 c3 21             	add    $0x21,%ebx
void ioapicinit(void) {
8010269d:	ba 10 00 00 00       	mov    $0x10,%edx
801026a2:	b8 20 00 00 00       	mov    $0x20,%eax
801026a7:	89 f6                	mov    %esi,%esi
801026a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ioapic->reg = reg;
801026b0:	89 11                	mov    %edx,(%ecx)
    ioapic->data = data;
801026b2:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
    }

    // Mark all interrupts edge-triggered, active high, disabled,
    // and not routed to any CPUs.
    for (i = 0; i <= maxintr; i++) {
        ioapicwrite(REG_TABLE + 2 * i, INT_DISABLED | (T_IRQ0 + i));
801026b8:	89 c6                	mov    %eax,%esi
801026ba:	81 ce 00 00 01 00    	or     $0x10000,%esi
801026c0:	83 c0 01             	add    $0x1,%eax
    ioapic->data = data;
801026c3:	89 71 10             	mov    %esi,0x10(%ecx)
801026c6:	8d 72 01             	lea    0x1(%edx),%esi
801026c9:	83 c2 02             	add    $0x2,%edx
    for (i = 0; i <= maxintr; i++) {
801026cc:	39 d8                	cmp    %ebx,%eax
    ioapic->reg = reg;
801026ce:	89 31                	mov    %esi,(%ecx)
    ioapic->data = data;
801026d0:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801026d6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
    for (i = 0; i <= maxintr; i++) {
801026dd:	75 d1                	jne    801026b0 <ioapicinit+0x70>
        ioapicwrite(REG_TABLE + 2 * i + 1, 0);
    }
}
801026df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026e2:	5b                   	pop    %ebx
801026e3:	5e                   	pop    %esi
801026e4:	5d                   	pop    %ebp
801026e5:	c3                   	ret    
801026e6:	8d 76 00             	lea    0x0(%esi),%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026f0 <ioapicenable>:

void ioapicenable(int irq, int cpunum) {
801026f0:	55                   	push   %ebp
    ioapic->reg = reg;
801026f1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
void ioapicenable(int irq, int cpunum) {
801026f7:	89 e5                	mov    %esp,%ebp
801026f9:	8b 45 08             	mov    0x8(%ebp),%eax
    // Mark interrupt edge-triggered, active high,
    // enabled, and routed to the given cpunum,
    // which happens to be that cpu's APIC ID.
    ioapicwrite(REG_TABLE + 2 * irq, T_IRQ0 + irq);
801026fc:	8d 50 20             	lea    0x20(%eax),%edx
801026ff:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
    ioapic->reg = reg;
80102703:	89 01                	mov    %eax,(%ecx)
    ioapic->data = data;
80102705:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
    ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
8010270b:	83 c0 01             	add    $0x1,%eax
    ioapic->data = data;
8010270e:	89 51 10             	mov    %edx,0x10(%ecx)
    ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
80102711:	8b 55 0c             	mov    0xc(%ebp),%edx
    ioapic->reg = reg;
80102714:	89 01                	mov    %eax,(%ecx)
    ioapic->data = data;
80102716:	a1 34 36 11 80       	mov    0x80113634,%eax
    ioapicwrite(REG_TABLE + 2 * irq + 1, cpunum << 24);
8010271b:	c1 e2 18             	shl    $0x18,%edx
    ioapic->data = data;
8010271e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102721:	5d                   	pop    %ebp
80102722:	c3                   	ret    
80102723:	66 90                	xchg   %ax,%ax
80102725:	66 90                	xchg   %ax,%ax
80102727:	66 90                	xchg   %ax,%ax
80102729:	66 90                	xchg   %ax,%ax
8010272b:	66 90                	xchg   %ax,%ax
8010272d:	66 90                	xchg   %ax,%ax
8010272f:	90                   	nop

80102730 <kfree>:

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(char *v) {
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
80102733:	53                   	push   %ebx
80102734:	83 ec 04             	sub    $0x4,%esp
80102737:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct run *r;

    if ((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP) {
8010273a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102740:	75 70                	jne    801027b2 <kfree+0x82>
80102742:	81 fb a8 64 11 80    	cmp    $0x801164a8,%ebx
80102748:	72 68                	jb     801027b2 <kfree+0x82>
8010274a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102750:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102755:	77 5b                	ja     801027b2 <kfree+0x82>
        panic("kfree");
    }

    // Fill with junk to catch dangling refs.
    memset(v, 1, PGSIZE);
80102757:	83 ec 04             	sub    $0x4,%esp
8010275a:	68 00 10 00 00       	push   $0x1000
8010275f:	6a 01                	push   $0x1
80102761:	53                   	push   %ebx
80102762:	e8 39 21 00 00       	call   801048a0 <memset>

    if (kmem.use_lock) {
80102767:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010276d:	83 c4 10             	add    $0x10,%esp
80102770:	85 d2                	test   %edx,%edx
80102772:	75 2c                	jne    801027a0 <kfree+0x70>
        acquire(&kmem.lock);
    }
    r = (struct run*)v;
    r->next = kmem.freelist;
80102774:	a1 78 36 11 80       	mov    0x80113678,%eax
80102779:	89 03                	mov    %eax,(%ebx)
    kmem.freelist = r;
    if (kmem.use_lock) {
8010277b:	a1 74 36 11 80       	mov    0x80113674,%eax
    kmem.freelist = r;
80102780:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
    if (kmem.use_lock) {
80102786:	85 c0                	test   %eax,%eax
80102788:	75 06                	jne    80102790 <kfree+0x60>
        release(&kmem.lock);
    }
}
8010278a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010278d:	c9                   	leave  
8010278e:	c3                   	ret    
8010278f:	90                   	nop
        release(&kmem.lock);
80102790:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102797:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010279a:	c9                   	leave  
        release(&kmem.lock);
8010279b:	e9 b0 20 00 00       	jmp    80104850 <release>
        acquire(&kmem.lock);
801027a0:	83 ec 0c             	sub    $0xc,%esp
801027a3:	68 40 36 11 80       	push   $0x80113640
801027a8:	e8 e3 1f 00 00       	call   80104790 <acquire>
801027ad:	83 c4 10             	add    $0x10,%esp
801027b0:	eb c2                	jmp    80102774 <kfree+0x44>
        panic("kfree");
801027b2:	83 ec 0c             	sub    $0xc,%esp
801027b5:	68 66 76 10 80       	push   $0x80107666
801027ba:	e8 c1 dc ff ff       	call   80100480 <panic>
801027bf:	90                   	nop

801027c0 <freerange>:
void freerange(void *vstart, void *vend) {
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	56                   	push   %esi
801027c4:	53                   	push   %ebx
    p = (char*)PGROUNDUP((uint)vstart);
801027c5:	8b 45 08             	mov    0x8(%ebp),%eax
void freerange(void *vstart, void *vend) {
801027c8:	8b 75 0c             	mov    0xc(%ebp),%esi
    p = (char*)PGROUNDUP((uint)vstart);
801027cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
801027d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027dd:	39 de                	cmp    %ebx,%esi
801027df:	72 23                	jb     80102804 <freerange+0x44>
801027e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree(p);
801027e8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027ee:	83 ec 0c             	sub    $0xc,%esp
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
801027f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
801027f7:	50                   	push   %eax
801027f8:	e8 33 ff ff ff       	call   80102730 <kfree>
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
801027fd:	83 c4 10             	add    $0x10,%esp
80102800:	39 f3                	cmp    %esi,%ebx
80102802:	76 e4                	jbe    801027e8 <freerange+0x28>
}
80102804:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102807:	5b                   	pop    %ebx
80102808:	5e                   	pop    %esi
80102809:	5d                   	pop    %ebp
8010280a:	c3                   	ret    
8010280b:	90                   	nop
8010280c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102810 <kinit1>:
void kinit1(void *vstart, void *vend) {
80102810:	55                   	push   %ebp
80102811:	89 e5                	mov    %esp,%ebp
80102813:	56                   	push   %esi
80102814:	53                   	push   %ebx
80102815:	8b 75 0c             	mov    0xc(%ebp),%esi
    initlock(&kmem.lock, "kmem");
80102818:	83 ec 08             	sub    $0x8,%esp
8010281b:	68 6c 76 10 80       	push   $0x8010766c
80102820:	68 40 36 11 80       	push   $0x80113640
80102825:	e8 26 1e 00 00       	call   80104650 <initlock>
    p = (char*)PGROUNDUP((uint)vstart);
8010282a:	8b 45 08             	mov    0x8(%ebp),%eax
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
8010282d:	83 c4 10             	add    $0x10,%esp
    kmem.use_lock = 0;
80102830:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102837:	00 00 00 
    p = (char*)PGROUNDUP((uint)vstart);
8010283a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102840:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102846:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010284c:	39 de                	cmp    %ebx,%esi
8010284e:	72 1c                	jb     8010286c <kinit1+0x5c>
        kfree(p);
80102850:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102856:	83 ec 0c             	sub    $0xc,%esp
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102859:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
8010285f:	50                   	push   %eax
80102860:	e8 cb fe ff ff       	call   80102730 <kfree>
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102865:	83 c4 10             	add    $0x10,%esp
80102868:	39 de                	cmp    %ebx,%esi
8010286a:	73 e4                	jae    80102850 <kinit1+0x40>
}
8010286c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010286f:	5b                   	pop    %ebx
80102870:	5e                   	pop    %esi
80102871:	5d                   	pop    %ebp
80102872:	c3                   	ret    
80102873:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102880 <kinit2>:
void kinit2(void *vstart, void *vend) {
80102880:	55                   	push   %ebp
80102881:	89 e5                	mov    %esp,%ebp
80102883:	56                   	push   %esi
80102884:	53                   	push   %ebx
    p = (char*)PGROUNDUP((uint)vstart);
80102885:	8b 45 08             	mov    0x8(%ebp),%eax
void kinit2(void *vstart, void *vend) {
80102888:	8b 75 0c             	mov    0xc(%ebp),%esi
    p = (char*)PGROUNDUP((uint)vstart);
8010288b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102891:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
80102897:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010289d:	39 de                	cmp    %ebx,%esi
8010289f:	72 23                	jb     801028c4 <kinit2+0x44>
801028a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree(p);
801028a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801028ae:	83 ec 0c             	sub    $0xc,%esp
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
801028b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        kfree(p);
801028b7:	50                   	push   %eax
801028b8:	e8 73 fe ff ff       	call   80102730 <kfree>
    for (; p + PGSIZE <= (char*)vend; p += PGSIZE) {
801028bd:	83 c4 10             	add    $0x10,%esp
801028c0:	39 de                	cmp    %ebx,%esi
801028c2:	73 e4                	jae    801028a8 <kinit2+0x28>
    kmem.use_lock = 1;
801028c4:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
801028cb:	00 00 00 
}
801028ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028d1:	5b                   	pop    %ebx
801028d2:	5e                   	pop    %esi
801028d3:	5d                   	pop    %ebp
801028d4:	c3                   	ret    
801028d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028e0 <kalloc>:
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char* kalloc(void)  {
    struct run *r;

    if (kmem.use_lock) {
801028e0:	a1 74 36 11 80       	mov    0x80113674,%eax
801028e5:	85 c0                	test   %eax,%eax
801028e7:	75 1f                	jne    80102908 <kalloc+0x28>
        acquire(&kmem.lock);
    }
    r = kmem.freelist;
801028e9:	a1 78 36 11 80       	mov    0x80113678,%eax
    if (r) {
801028ee:	85 c0                	test   %eax,%eax
801028f0:	74 0e                	je     80102900 <kalloc+0x20>
        kmem.freelist = r->next;
801028f2:	8b 10                	mov    (%eax),%edx
801028f4:	89 15 78 36 11 80    	mov    %edx,0x80113678
801028fa:	c3                   	ret    
801028fb:	90                   	nop
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
    if (kmem.use_lock) {
        release(&kmem.lock);
    }
    return (char*)r;
}
80102900:	f3 c3                	repz ret 
80102902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
char* kalloc(void)  {
80102908:	55                   	push   %ebp
80102909:	89 e5                	mov    %esp,%ebp
8010290b:	83 ec 24             	sub    $0x24,%esp
        acquire(&kmem.lock);
8010290e:	68 40 36 11 80       	push   $0x80113640
80102913:	e8 78 1e 00 00       	call   80104790 <acquire>
    r = kmem.freelist;
80102918:	a1 78 36 11 80       	mov    0x80113678,%eax
    if (r) {
8010291d:	83 c4 10             	add    $0x10,%esp
80102920:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102926:	85 c0                	test   %eax,%eax
80102928:	74 08                	je     80102932 <kalloc+0x52>
        kmem.freelist = r->next;
8010292a:	8b 08                	mov    (%eax),%ecx
8010292c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
    if (kmem.use_lock) {
80102932:	85 d2                	test   %edx,%edx
80102934:	74 16                	je     8010294c <kalloc+0x6c>
        release(&kmem.lock);
80102936:	83 ec 0c             	sub    $0xc,%esp
80102939:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010293c:	68 40 36 11 80       	push   $0x80113640
80102941:	e8 0a 1f 00 00       	call   80104850 <release>
    return (char*)r;
80102946:	8b 45 f4             	mov    -0xc(%ebp),%eax
        release(&kmem.lock);
80102949:	83 c4 10             	add    $0x10,%esp
}
8010294c:	c9                   	leave  
8010294d:	c3                   	ret    
8010294e:	66 90                	xchg   %ax,%ax

80102950 <kbdgetc>:
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102950:	ba 64 00 00 00       	mov    $0x64,%edx
80102955:	ec                   	in     (%dx),%al
        normalmap, shiftmap, ctlmap, ctlmap
    };
    uint st, data, c;

    st = inb(KBSTATP);
    if ((st & KBS_DIB) == 0) {
80102956:	a8 01                	test   $0x1,%al
80102958:	0f 84 c2 00 00 00    	je     80102a20 <kbdgetc+0xd0>
8010295e:	ba 60 00 00 00       	mov    $0x60,%edx
80102963:	ec                   	in     (%dx),%al
        return -1;
    }
    data = inb(KBDATAP);
80102964:	0f b6 d0             	movzbl %al,%edx
80102967:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

    if (data == 0xE0) {
8010296d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102973:	0f 84 7f 00 00 00    	je     801029f8 <kbdgetc+0xa8>
int kbdgetc(void) {
80102979:	55                   	push   %ebp
8010297a:	89 e5                	mov    %esp,%ebp
8010297c:	53                   	push   %ebx
8010297d:	89 cb                	mov    %ecx,%ebx
8010297f:	83 e3 40             	and    $0x40,%ebx
        shift |= E0ESC;
        return 0;
    }
    else if (data & 0x80) {
80102982:	84 c0                	test   %al,%al
80102984:	78 4a                	js     801029d0 <kbdgetc+0x80>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
        shift &= ~(shiftcode[data] | E0ESC);
        return 0;
    }
    else if (shift & E0ESC) {
80102986:	85 db                	test   %ebx,%ebx
80102988:	74 09                	je     80102993 <kbdgetc+0x43>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
8010298a:	83 c8 80             	or     $0xffffff80,%eax
        shift &= ~E0ESC;
8010298d:	83 e1 bf             	and    $0xffffffbf,%ecx
        data |= 0x80;
80102990:	0f b6 d0             	movzbl %al,%edx
    }

    shift |= shiftcode[data];
80102993:	0f b6 82 a0 77 10 80 	movzbl -0x7fef8860(%edx),%eax
8010299a:	09 c1                	or     %eax,%ecx
    shift ^= togglecode[data];
8010299c:	0f b6 82 a0 76 10 80 	movzbl -0x7fef8960(%edx),%eax
801029a3:	31 c1                	xor    %eax,%ecx
    c = charcode[shift & (CTL | SHIFT)][data];
801029a5:	89 c8                	mov    %ecx,%eax
    shift ^= togglecode[data];
801029a7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    c = charcode[shift & (CTL | SHIFT)][data];
801029ad:	83 e0 03             	and    $0x3,%eax
    if (shift & CAPSLOCK) {
801029b0:	83 e1 08             	and    $0x8,%ecx
    c = charcode[shift & (CTL | SHIFT)][data];
801029b3:	8b 04 85 80 76 10 80 	mov    -0x7fef8980(,%eax,4),%eax
801029ba:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
    if (shift & CAPSLOCK) {
801029be:	74 31                	je     801029f1 <kbdgetc+0xa1>
        if ('a' <= c && c <= 'z') {
801029c0:	8d 50 9f             	lea    -0x61(%eax),%edx
801029c3:	83 fa 19             	cmp    $0x19,%edx
801029c6:	77 40                	ja     80102a08 <kbdgetc+0xb8>
            c += 'A' - 'a';
801029c8:	83 e8 20             	sub    $0x20,%eax
        else if ('A' <= c && c <= 'Z') {
            c += 'a' - 'A';
        }
    }
    return c;
}
801029cb:	5b                   	pop    %ebx
801029cc:	5d                   	pop    %ebp
801029cd:	c3                   	ret    
801029ce:	66 90                	xchg   %ax,%ax
        data = (shift & E0ESC ? data : data & 0x7F);
801029d0:	83 e0 7f             	and    $0x7f,%eax
801029d3:	85 db                	test   %ebx,%ebx
801029d5:	0f 44 d0             	cmove  %eax,%edx
        shift &= ~(shiftcode[data] | E0ESC);
801029d8:	0f b6 82 a0 77 10 80 	movzbl -0x7fef8860(%edx),%eax
801029df:	83 c8 40             	or     $0x40,%eax
801029e2:	0f b6 c0             	movzbl %al,%eax
801029e5:	f7 d0                	not    %eax
801029e7:	21 c1                	and    %eax,%ecx
        return 0;
801029e9:	31 c0                	xor    %eax,%eax
        shift &= ~(shiftcode[data] | E0ESC);
801029eb:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801029f1:	5b                   	pop    %ebx
801029f2:	5d                   	pop    %ebp
801029f3:	c3                   	ret    
801029f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        shift |= E0ESC;
801029f8:	83 c9 40             	or     $0x40,%ecx
        return 0;
801029fb:	31 c0                	xor    %eax,%eax
        shift |= E0ESC;
801029fd:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
        return 0;
80102a03:	c3                   	ret    
80102a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        else if ('A' <= c && c <= 'Z') {
80102a08:	8d 48 bf             	lea    -0x41(%eax),%ecx
            c += 'a' - 'A';
80102a0b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102a0e:	5b                   	pop    %ebx
            c += 'a' - 'A';
80102a0f:	83 f9 1a             	cmp    $0x1a,%ecx
80102a12:	0f 42 c2             	cmovb  %edx,%eax
}
80102a15:	5d                   	pop    %ebp
80102a16:	c3                   	ret    
80102a17:	89 f6                	mov    %esi,%esi
80102a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return -1;
80102a20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102a25:	c3                   	ret    
80102a26:	8d 76 00             	lea    0x0(%esi),%esi
80102a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a30 <kbdintr>:

void kbdintr(void) {
80102a30:	55                   	push   %ebp
80102a31:	89 e5                	mov    %esp,%ebp
80102a33:	83 ec 14             	sub    $0x14,%esp
    consoleintr(kbdgetc);
80102a36:	68 50 29 10 80       	push   $0x80102950
80102a3b:	e8 10 df ff ff       	call   80100950 <consoleintr>
}
80102a40:	83 c4 10             	add    $0x10,%esp
80102a43:	c9                   	leave  
80102a44:	c3                   	ret    
80102a45:	66 90                	xchg   %ax,%ax
80102a47:	66 90                	xchg   %ax,%ax
80102a49:	66 90                	xchg   %ax,%ax
80102a4b:	66 90                	xchg   %ax,%ax
80102a4d:	66 90                	xchg   %ax,%ax
80102a4f:	90                   	nop

80102a50 <lapicinit>:
    lapic[index] = value;
    lapic[ID];  // wait for write to finish, by reading
}

void lapicinit(void) {
    if (!lapic) {
80102a50:	a1 7c 36 11 80       	mov    0x8011367c,%eax
void lapicinit(void) {
80102a55:	55                   	push   %ebp
80102a56:	89 e5                	mov    %esp,%ebp
    if (!lapic) {
80102a58:	85 c0                	test   %eax,%eax
80102a5a:	0f 84 c8 00 00 00    	je     80102b28 <lapicinit+0xd8>
    lapic[index] = value;
80102a60:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102a67:	01 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102a6a:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102a6d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102a74:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102a77:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102a7a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a81:	00 02 00 
    lapic[ID];  // wait for write to finish, by reading
80102a84:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102a87:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a8e:	96 98 00 
    lapic[ID];  // wait for write to finish, by reading
80102a91:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102a94:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a9b:	00 01 00 
    lapic[ID];  // wait for write to finish, by reading
80102a9e:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102aa1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102aa8:	00 01 00 
    lapic[ID];  // wait for write to finish, by reading
80102aab:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(LINT0, MASKED);
    lapicw(LINT1, MASKED);

    // Disable performance counter overflow interrupts
    // on machines that provide that interrupt entry.
    if (((lapic[VER] >> 16) & 0xFF) >= 4) {
80102aae:	8b 50 30             	mov    0x30(%eax),%edx
80102ab1:	c1 ea 10             	shr    $0x10,%edx
80102ab4:	80 fa 03             	cmp    $0x3,%dl
80102ab7:	77 77                	ja     80102b30 <lapicinit+0xe0>
    lapic[index] = value;
80102ab9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102ac0:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102ac3:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102ac6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102acd:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102ad0:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102ad3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102ada:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102add:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102ae0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ae7:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102aea:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102aed:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102af4:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102af7:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102afa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102b01:	85 08 00 
    lapic[ID];  // wait for write to finish, by reading
80102b04:	8b 50 20             	mov    0x20(%eax),%edx
80102b07:	89 f6                	mov    %esi,%esi
80102b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapicw(EOI, 0);

    // Send an Init Level De-Assert to synchronise arbitration ID's.
    lapicw(ICRHI, 0);
    lapicw(ICRLO, BCAST | INIT | LEVEL);
    while (lapic[ICRLO] & DELIVS) {
80102b10:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102b16:	80 e6 10             	and    $0x10,%dh
80102b19:	75 f5                	jne    80102b10 <lapicinit+0xc0>
    lapic[index] = value;
80102b1b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102b22:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102b25:	8b 40 20             	mov    0x20(%eax),%eax
        ;
    }

    // Enable interrupts on the APIC (but not on the processor).
    lapicw(TPR, 0);
}
80102b28:	5d                   	pop    %ebp
80102b29:	c3                   	ret    
80102b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapic[index] = value;
80102b30:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102b37:	00 01 00 
    lapic[ID];  // wait for write to finish, by reading
80102b3a:	8b 50 20             	mov    0x20(%eax),%edx
80102b3d:	e9 77 ff ff ff       	jmp    80102ab9 <lapicinit+0x69>
80102b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b50 <lapicid>:

int lapicid(void) {
    if (!lapic) {
80102b50:	8b 15 7c 36 11 80    	mov    0x8011367c,%edx
int lapicid(void) {
80102b56:	55                   	push   %ebp
80102b57:	31 c0                	xor    %eax,%eax
80102b59:	89 e5                	mov    %esp,%ebp
    if (!lapic) {
80102b5b:	85 d2                	test   %edx,%edx
80102b5d:	74 06                	je     80102b65 <lapicid+0x15>
        return 0;
    }
    return lapic[ID] >> 24;
80102b5f:	8b 42 20             	mov    0x20(%edx),%eax
80102b62:	c1 e8 18             	shr    $0x18,%eax
}
80102b65:	5d                   	pop    %ebp
80102b66:	c3                   	ret    
80102b67:	89 f6                	mov    %esi,%esi
80102b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b70 <lapiceoi>:

// Acknowledge interrupt.
void lapiceoi(void) {
    if (lapic) {
80102b70:	a1 7c 36 11 80       	mov    0x8011367c,%eax
void lapiceoi(void) {
80102b75:	55                   	push   %ebp
80102b76:	89 e5                	mov    %esp,%ebp
    if (lapic) {
80102b78:	85 c0                	test   %eax,%eax
80102b7a:	74 0d                	je     80102b89 <lapiceoi+0x19>
    lapic[index] = value;
80102b7c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b83:	00 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102b86:	8b 40 20             	mov    0x20(%eax),%eax
        lapicw(EOI, 0);
    }
}
80102b89:	5d                   	pop    %ebp
80102b8a:	c3                   	ret    
80102b8b:	90                   	nop
80102b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b90 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void microdelay(int us) {
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
}
80102b93:	5d                   	pop    %ebp
80102b94:	c3                   	ret    
80102b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <lapicstartap>:
#define CMOS_PORT    0x70
#define CMOS_RETURN  0x71

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void lapicstartap(uchar apicid, uint addr)      {
80102ba0:	55                   	push   %ebp
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102ba1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102ba6:	ba 70 00 00 00       	mov    $0x70,%edx
80102bab:	89 e5                	mov    %esp,%ebp
80102bad:	53                   	push   %ebx
80102bae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102bb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102bb4:	ee                   	out    %al,(%dx)
80102bb5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bba:	ba 71 00 00 00       	mov    $0x71,%edx
80102bbf:	ee                   	out    %al,(%dx)
    // and the warm reset vector (DWORD based at 40:67) to point at
    // the AP startup code prior to the [universal startup algorithm]."
    outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
    outb(CMOS_PORT + 1, 0x0A);
    wrv = (ushort*)P2V((0x40 << 4 | 0x67));  // Warm reset vector
    wrv[0] = 0;
80102bc0:	31 c0                	xor    %eax,%eax
    wrv[1] = addr >> 4;

    // "Universal startup algorithm."
    // Send INIT (level-triggered) interrupt to reset other CPU.
    lapicw(ICRHI, apicid << 24);
80102bc2:	c1 e3 18             	shl    $0x18,%ebx
    wrv[0] = 0;
80102bc5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
    wrv[1] = addr >> 4;
80102bcb:	89 c8                	mov    %ecx,%eax
    // when it is in the halted state due to an INIT.  So the second
    // should be ignored, but it is part of the official Intel algorithm.
    // Bochs complains about the second one.  Too bad for Bochs.
    for (i = 0; i < 2; i++) {
        lapicw(ICRHI, apicid << 24);
        lapicw(ICRLO, STARTUP | (addr >> 12));
80102bcd:	c1 e9 0c             	shr    $0xc,%ecx
    wrv[1] = addr >> 4;
80102bd0:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRHI, apicid << 24);
80102bd3:	89 da                	mov    %ebx,%edx
        lapicw(ICRLO, STARTUP | (addr >> 12));
80102bd5:	80 cd 06             	or     $0x6,%ch
    wrv[1] = addr >> 4;
80102bd8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
    lapic[index] = value;
80102bde:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102be3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
    lapic[ID];  // wait for write to finish, by reading
80102be9:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
80102bec:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102bf3:	c5 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102bf6:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
80102bf9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102c00:	85 00 00 
    lapic[ID];  // wait for write to finish, by reading
80102c03:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
80102c06:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
    lapic[ID];  // wait for write to finish, by reading
80102c0c:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
80102c0f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    lapic[ID];  // wait for write to finish, by reading
80102c15:	8b 58 20             	mov    0x20(%eax),%ebx
    lapic[index] = value;
80102c18:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
    lapic[ID];  // wait for write to finish, by reading
80102c1e:	8b 50 20             	mov    0x20(%eax),%edx
    lapic[index] = value;
80102c21:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    lapic[ID];  // wait for write to finish, by reading
80102c27:	8b 40 20             	mov    0x20(%eax),%eax
        microdelay(200);
    }
}
80102c2a:	5b                   	pop    %ebx
80102c2b:	5d                   	pop    %ebp
80102c2c:	c3                   	ret    
80102c2d:	8d 76 00             	lea    0x0(%esi),%esi

80102c30 <cmostime>:
    r->month  = cmos_read(MONTH);
    r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r) {
80102c30:	55                   	push   %ebp
80102c31:	b8 0b 00 00 00       	mov    $0xb,%eax
80102c36:	ba 70 00 00 00       	mov    $0x70,%edx
80102c3b:	89 e5                	mov    %esp,%ebp
80102c3d:	57                   	push   %edi
80102c3e:	56                   	push   %esi
80102c3f:	53                   	push   %ebx
80102c40:	83 ec 4c             	sub    $0x4c,%esp
80102c43:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102c44:	ba 71 00 00 00       	mov    $0x71,%edx
80102c49:	ec                   	in     (%dx),%al
80102c4a:	83 e0 04             	and    $0x4,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102c4d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102c52:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102c55:	8d 76 00             	lea    0x0(%esi),%esi
80102c58:	31 c0                	xor    %eax,%eax
80102c5a:	89 da                	mov    %ebx,%edx
80102c5c:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102c5d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c62:	89 ca                	mov    %ecx,%edx
80102c64:	ec                   	in     (%dx),%al
80102c65:	88 45 b7             	mov    %al,-0x49(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102c68:	89 da                	mov    %ebx,%edx
80102c6a:	b8 02 00 00 00       	mov    $0x2,%eax
80102c6f:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102c70:	89 ca                	mov    %ecx,%edx
80102c72:	ec                   	in     (%dx),%al
80102c73:	88 45 b6             	mov    %al,-0x4a(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102c76:	89 da                	mov    %ebx,%edx
80102c78:	b8 04 00 00 00       	mov    $0x4,%eax
80102c7d:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102c7e:	89 ca                	mov    %ecx,%edx
80102c80:	ec                   	in     (%dx),%al
80102c81:	88 45 b5             	mov    %al,-0x4b(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102c84:	89 da                	mov    %ebx,%edx
80102c86:	b8 07 00 00 00       	mov    $0x7,%eax
80102c8b:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102c8c:	89 ca                	mov    %ecx,%edx
80102c8e:	ec                   	in     (%dx),%al
80102c8f:	88 45 b4             	mov    %al,-0x4c(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102c92:	89 da                	mov    %ebx,%edx
80102c94:	b8 08 00 00 00       	mov    $0x8,%eax
80102c99:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102c9a:	89 ca                	mov    %ecx,%edx
80102c9c:	ec                   	in     (%dx),%al
80102c9d:	89 c7                	mov    %eax,%edi
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102c9f:	89 da                	mov    %ebx,%edx
80102ca1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ca6:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102ca7:	89 ca                	mov    %ecx,%edx
80102ca9:	ec                   	in     (%dx),%al
80102caa:	89 c6                	mov    %eax,%esi
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102cac:	89 da                	mov    %ebx,%edx
80102cae:	b8 0a 00 00 00       	mov    $0xa,%eax
80102cb3:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102cb4:	89 ca                	mov    %ecx,%edx
80102cb6:	ec                   	in     (%dx),%al
    bcd = (sb & (1 << 2)) == 0;

    // make sure CMOS doesn't modify time while we read it
    for (;;) {
        fill_rtcdate(&t1);
        if (cmos_read(CMOS_STATA) & CMOS_UIP) {
80102cb7:	84 c0                	test   %al,%al
80102cb9:	78 9d                	js     80102c58 <cmostime+0x28>
    return inb(CMOS_RETURN);
80102cbb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102cbf:	89 fa                	mov    %edi,%edx
80102cc1:	0f b6 fa             	movzbl %dl,%edi
80102cc4:	89 f2                	mov    %esi,%edx
80102cc6:	0f b6 f2             	movzbl %dl,%esi
80102cc9:	89 7d c8             	mov    %edi,-0x38(%ebp)
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102ccc:	89 da                	mov    %ebx,%edx
80102cce:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102cd1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102cd4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102cd8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102cdb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102cdf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ce2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ce6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ce9:	31 c0                	xor    %eax,%eax
80102ceb:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102cec:	89 ca                	mov    %ecx,%edx
80102cee:	ec                   	in     (%dx),%al
80102cef:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102cf2:	89 da                	mov    %ebx,%edx
80102cf4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102cf7:	b8 02 00 00 00       	mov    $0x2,%eax
80102cfc:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102cfd:	89 ca                	mov    %ecx,%edx
80102cff:	ec                   	in     (%dx),%al
80102d00:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102d03:	89 da                	mov    %ebx,%edx
80102d05:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102d08:	b8 04 00 00 00       	mov    $0x4,%eax
80102d0d:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102d0e:	89 ca                	mov    %ecx,%edx
80102d10:	ec                   	in     (%dx),%al
80102d11:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102d14:	89 da                	mov    %ebx,%edx
80102d16:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102d19:	b8 07 00 00 00       	mov    $0x7,%eax
80102d1e:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102d1f:	89 ca                	mov    %ecx,%edx
80102d21:	ec                   	in     (%dx),%al
80102d22:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102d25:	89 da                	mov    %ebx,%edx
80102d27:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102d2a:	b8 08 00 00 00       	mov    $0x8,%eax
80102d2f:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102d30:	89 ca                	mov    %ecx,%edx
80102d32:	ec                   	in     (%dx),%al
80102d33:	0f b6 c0             	movzbl %al,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80102d36:	89 da                	mov    %ebx,%edx
80102d38:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d3b:	b8 09 00 00 00       	mov    $0x9,%eax
80102d40:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80102d41:	89 ca                	mov    %ecx,%edx
80102d43:	ec                   	in     (%dx),%al
80102d44:	0f b6 c0             	movzbl %al,%eax
            continue;
        }
        fill_rtcdate(&t2);
        if (memcmp(&t1, &t2, sizeof(t1)) == 0) {
80102d47:	83 ec 04             	sub    $0x4,%esp
    return inb(CMOS_RETURN);
80102d4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (memcmp(&t1, &t2, sizeof(t1)) == 0) {
80102d4d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102d50:	6a 18                	push   $0x18
80102d52:	50                   	push   %eax
80102d53:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d56:	50                   	push   %eax
80102d57:	e8 94 1b 00 00       	call   801048f0 <memcmp>
80102d5c:	83 c4 10             	add    $0x10,%esp
80102d5f:	85 c0                	test   %eax,%eax
80102d61:	0f 85 f1 fe ff ff    	jne    80102c58 <cmostime+0x28>
            break;
        }
    }

    // convert
    if (bcd) {
80102d67:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102d6b:	75 78                	jne    80102de5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
        CONV(second);
80102d6d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d70:	89 c2                	mov    %eax,%edx
80102d72:	83 e0 0f             	and    $0xf,%eax
80102d75:	c1 ea 04             	shr    $0x4,%edx
80102d78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d7e:	89 45 b8             	mov    %eax,-0x48(%ebp)
        CONV(minute);
80102d81:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d84:	89 c2                	mov    %eax,%edx
80102d86:	83 e0 0f             	and    $0xf,%eax
80102d89:	c1 ea 04             	shr    $0x4,%edx
80102d8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d92:	89 45 bc             	mov    %eax,-0x44(%ebp)
        CONV(hour  );
80102d95:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d98:	89 c2                	mov    %eax,%edx
80102d9a:	83 e0 0f             	and    $0xf,%eax
80102d9d:	c1 ea 04             	shr    $0x4,%edx
80102da0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102da3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102da6:	89 45 c0             	mov    %eax,-0x40(%ebp)
        CONV(day   );
80102da9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102dac:	89 c2                	mov    %eax,%edx
80102dae:	83 e0 0f             	and    $0xf,%eax
80102db1:	c1 ea 04             	shr    $0x4,%edx
80102db4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102db7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        CONV(month );
80102dbd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102dc0:	89 c2                	mov    %eax,%edx
80102dc2:	83 e0 0f             	and    $0xf,%eax
80102dc5:	c1 ea 04             	shr    $0x4,%edx
80102dc8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dcb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dce:	89 45 c8             	mov    %eax,-0x38(%ebp)
        CONV(year  );
80102dd1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102dd4:	89 c2                	mov    %eax,%edx
80102dd6:	83 e0 0f             	and    $0xf,%eax
80102dd9:	c1 ea 04             	shr    $0x4,%edx
80102ddc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ddf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102de2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
    }

    *r = t1;
80102de5:	8b 75 08             	mov    0x8(%ebp),%esi
80102de8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102deb:	89 06                	mov    %eax,(%esi)
80102ded:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102df0:	89 46 04             	mov    %eax,0x4(%esi)
80102df3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102df6:	89 46 08             	mov    %eax,0x8(%esi)
80102df9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102dfc:	89 46 0c             	mov    %eax,0xc(%esi)
80102dff:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e02:	89 46 10             	mov    %eax,0x10(%esi)
80102e05:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e08:	89 46 14             	mov    %eax,0x14(%esi)
    r->year += 2000;
80102e0b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e15:	5b                   	pop    %ebx
80102e16:	5e                   	pop    %esi
80102e17:	5f                   	pop    %edi
80102e18:	5d                   	pop    %ebp
80102e19:	c3                   	ret    
80102e1a:	66 90                	xchg   %ax,%ax
80102e1c:	66 90                	xchg   %ax,%ax
80102e1e:	66 90                	xchg   %ax,%ax

80102e20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e20:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102e26:	85 c9                	test   %ecx,%ecx
80102e28:	0f 8e 8a 00 00 00    	jle    80102eb8 <install_trans+0x98>
{
80102e2e:	55                   	push   %ebp
80102e2f:	89 e5                	mov    %esp,%ebp
80102e31:	57                   	push   %edi
80102e32:	56                   	push   %esi
80102e33:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102e34:	31 db                	xor    %ebx,%ebx
{
80102e36:	83 ec 0c             	sub    $0xc,%esp
80102e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e40:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102e45:	83 ec 08             	sub    $0x8,%esp
80102e48:	01 d8                	add    %ebx,%eax
80102e4a:	83 c0 01             	add    $0x1,%eax
80102e4d:	50                   	push   %eax
80102e4e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e54:	e8 77 d2 ff ff       	call   801000d0 <bread>
80102e59:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e5b:	58                   	pop    %eax
80102e5c:	5a                   	pop    %edx
80102e5d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102e64:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e6d:	e8 5e d2 ff ff       	call   801000d0 <bread>
80102e72:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e74:	8d 47 5c             	lea    0x5c(%edi),%eax
80102e77:	83 c4 0c             	add    $0xc,%esp
80102e7a:	68 00 02 00 00       	push   $0x200
80102e7f:	50                   	push   %eax
80102e80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e83:	50                   	push   %eax
80102e84:	e8 c7 1a 00 00       	call   80104950 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e89:	89 34 24             	mov    %esi,(%esp)
80102e8c:	e8 0f d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102e91:	89 3c 24             	mov    %edi,(%esp)
80102e94:	e8 47 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 3f d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ea1:	83 c4 10             	add    $0x10,%esp
80102ea4:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102eaa:	7f 94                	jg     80102e40 <install_trans+0x20>
  }
}
80102eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eaf:	5b                   	pop    %ebx
80102eb0:	5e                   	pop    %esi
80102eb1:	5f                   	pop    %edi
80102eb2:	5d                   	pop    %ebp
80102eb3:	c3                   	ret    
80102eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102eb8:	f3 c3                	repz ret 
80102eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ec0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	56                   	push   %esi
80102ec4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ec5:	83 ec 08             	sub    $0x8,%esp
80102ec8:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102ece:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102ed4:	e8 f7 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ed9:	8b 1d c8 36 11 80    	mov    0x801136c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102edf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ee2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ee4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ee6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ee9:	7e 16                	jle    80102f01 <write_head+0x41>
80102eeb:	c1 e3 02             	shl    $0x2,%ebx
80102eee:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ef0:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102ef6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102efa:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102efd:	39 da                	cmp    %ebx,%edx
80102eff:	75 ef                	jne    80102ef0 <write_head+0x30>
  }
  bwrite(buf);
80102f01:	83 ec 0c             	sub    $0xc,%esp
80102f04:	56                   	push   %esi
80102f05:	e8 96 d2 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102f0a:	89 34 24             	mov    %esi,(%esp)
80102f0d:	e8 ce d2 ff ff       	call   801001e0 <brelse>
}
80102f12:	83 c4 10             	add    $0x10,%esp
80102f15:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102f18:	5b                   	pop    %ebx
80102f19:	5e                   	pop    %esi
80102f1a:	5d                   	pop    %ebp
80102f1b:	c3                   	ret    
80102f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102f20 <initlog>:
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	53                   	push   %ebx
80102f24:	83 ec 2c             	sub    $0x2c,%esp
80102f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102f2a:	68 a0 78 10 80       	push   $0x801078a0
80102f2f:	68 80 36 11 80       	push   $0x80113680
80102f34:	e8 17 17 00 00       	call   80104650 <initlock>
  readsb(dev, &sb);
80102f39:	58                   	pop    %eax
80102f3a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102f3d:	5a                   	pop    %edx
80102f3e:	50                   	push   %eax
80102f3f:	53                   	push   %ebx
80102f40:	e8 1b e9 ff ff       	call   80101860 <readsb>
  log.size = sb.nlog;
80102f45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102f48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102f4b:	59                   	pop    %ecx
  log.dev = dev;
80102f4c:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102f52:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  log.start = sb.logstart;
80102f58:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  struct buf *buf = bread(log.dev, log.start);
80102f5d:	5a                   	pop    %edx
80102f5e:	50                   	push   %eax
80102f5f:	53                   	push   %ebx
80102f60:	e8 6b d1 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102f65:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102f68:	83 c4 10             	add    $0x10,%esp
80102f6b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102f6d:	89 1d c8 36 11 80    	mov    %ebx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102f73:	7e 1c                	jle    80102f91 <initlog+0x71>
80102f75:	c1 e3 02             	shl    $0x2,%ebx
80102f78:	31 d2                	xor    %edx,%edx
80102f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102f80:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102f84:	83 c2 04             	add    $0x4,%edx
80102f87:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102f8d:	39 d3                	cmp    %edx,%ebx
80102f8f:	75 ef                	jne    80102f80 <initlog+0x60>
  brelse(buf);
80102f91:	83 ec 0c             	sub    $0xc,%esp
80102f94:	50                   	push   %eax
80102f95:	e8 46 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f9a:	e8 81 fe ff ff       	call   80102e20 <install_trans>
  log.lh.n = 0;
80102f9f:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102fa6:	00 00 00 
  write_head(); // clear the log
80102fa9:	e8 12 ff ff ff       	call   80102ec0 <write_head>
}
80102fae:	83 c4 10             	add    $0x10,%esp
80102fb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fb4:	c9                   	leave  
80102fb5:	c3                   	ret    
80102fb6:	8d 76 00             	lea    0x0(%esi),%esi
80102fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fc0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102fc6:	68 80 36 11 80       	push   $0x80113680
80102fcb:	e8 c0 17 00 00       	call   80104790 <acquire>
80102fd0:	83 c4 10             	add    $0x10,%esp
80102fd3:	eb 18                	jmp    80102fed <begin_op+0x2d>
80102fd5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102fd8:	83 ec 08             	sub    $0x8,%esp
80102fdb:	68 80 36 11 80       	push   $0x80113680
80102fe0:	68 80 36 11 80       	push   $0x80113680
80102fe5:	e8 e6 11 00 00       	call   801041d0 <sleep>
80102fea:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102fed:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102ff2:	85 c0                	test   %eax,%eax
80102ff4:	75 e2                	jne    80102fd8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ff6:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102ffb:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80103001:	83 c0 01             	add    $0x1,%eax
80103004:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103007:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010300a:	83 fa 1e             	cmp    $0x1e,%edx
8010300d:	7f c9                	jg     80102fd8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010300f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103012:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80103017:	68 80 36 11 80       	push   $0x80113680
8010301c:	e8 2f 18 00 00       	call   80104850 <release>
      break;
    }
  }
}
80103021:	83 c4 10             	add    $0x10,%esp
80103024:	c9                   	leave  
80103025:	c3                   	ret    
80103026:	8d 76 00             	lea    0x0(%esi),%esi
80103029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103030 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	57                   	push   %edi
80103034:	56                   	push   %esi
80103035:	53                   	push   %ebx
80103036:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103039:	68 80 36 11 80       	push   $0x80113680
8010303e:	e8 4d 17 00 00       	call   80104790 <acquire>
  log.outstanding -= 1;
80103043:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80103048:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
8010304e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103051:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103054:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103056:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
8010305c:	0f 85 1a 01 00 00    	jne    8010317c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103062:	85 db                	test   %ebx,%ebx
80103064:	0f 85 ee 00 00 00    	jne    80103158 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010306a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010306d:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80103074:	00 00 00 
  release(&log.lock);
80103077:	68 80 36 11 80       	push   $0x80113680
8010307c:	e8 cf 17 00 00       	call   80104850 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103081:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80103087:	83 c4 10             	add    $0x10,%esp
8010308a:	85 c9                	test   %ecx,%ecx
8010308c:	0f 8e 85 00 00 00    	jle    80103117 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103092:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80103097:	83 ec 08             	sub    $0x8,%esp
8010309a:	01 d8                	add    %ebx,%eax
8010309c:	83 c0 01             	add    $0x1,%eax
8010309f:	50                   	push   %eax
801030a0:	ff 35 c4 36 11 80    	pushl  0x801136c4
801030a6:	e8 25 d0 ff ff       	call   801000d0 <bread>
801030ab:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030ad:	58                   	pop    %eax
801030ae:	5a                   	pop    %edx
801030af:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
801030b6:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
801030bc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030bf:	e8 0c d0 ff ff       	call   801000d0 <bread>
801030c4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801030c6:	8d 40 5c             	lea    0x5c(%eax),%eax
801030c9:	83 c4 0c             	add    $0xc,%esp
801030cc:	68 00 02 00 00       	push   $0x200
801030d1:	50                   	push   %eax
801030d2:	8d 46 5c             	lea    0x5c(%esi),%eax
801030d5:	50                   	push   %eax
801030d6:	e8 75 18 00 00       	call   80104950 <memmove>
    bwrite(to);  // write the log
801030db:	89 34 24             	mov    %esi,(%esp)
801030de:	e8 bd d0 ff ff       	call   801001a0 <bwrite>
    brelse(from);
801030e3:	89 3c 24             	mov    %edi,(%esp)
801030e6:	e8 f5 d0 ff ff       	call   801001e0 <brelse>
    brelse(to);
801030eb:	89 34 24             	mov    %esi,(%esp)
801030ee:	e8 ed d0 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030f3:	83 c4 10             	add    $0x10,%esp
801030f6:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
801030fc:	7c 94                	jl     80103092 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030fe:	e8 bd fd ff ff       	call   80102ec0 <write_head>
    install_trans(); // Now install writes to home locations
80103103:	e8 18 fd ff ff       	call   80102e20 <install_trans>
    log.lh.n = 0;
80103108:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
8010310f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103112:	e8 a9 fd ff ff       	call   80102ec0 <write_head>
    acquire(&log.lock);
80103117:	83 ec 0c             	sub    $0xc,%esp
8010311a:	68 80 36 11 80       	push   $0x80113680
8010311f:	e8 6c 16 00 00       	call   80104790 <acquire>
    wakeup(&log);
80103124:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
8010312b:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80103132:	00 00 00 
    wakeup(&log);
80103135:	e8 46 12 00 00       	call   80104380 <wakeup>
    release(&log.lock);
8010313a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103141:	e8 0a 17 00 00       	call   80104850 <release>
80103146:	83 c4 10             	add    $0x10,%esp
}
80103149:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010314c:	5b                   	pop    %ebx
8010314d:	5e                   	pop    %esi
8010314e:	5f                   	pop    %edi
8010314f:	5d                   	pop    %ebp
80103150:	c3                   	ret    
80103151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103158:	83 ec 0c             	sub    $0xc,%esp
8010315b:	68 80 36 11 80       	push   $0x80113680
80103160:	e8 1b 12 00 00       	call   80104380 <wakeup>
  release(&log.lock);
80103165:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
8010316c:	e8 df 16 00 00       	call   80104850 <release>
80103171:	83 c4 10             	add    $0x10,%esp
}
80103174:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103177:	5b                   	pop    %ebx
80103178:	5e                   	pop    %esi
80103179:	5f                   	pop    %edi
8010317a:	5d                   	pop    %ebp
8010317b:	c3                   	ret    
    panic("log.committing");
8010317c:	83 ec 0c             	sub    $0xc,%esp
8010317f:	68 a4 78 10 80       	push   $0x801078a4
80103184:	e8 f7 d2 ff ff       	call   80100480 <panic>
80103189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103190 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	53                   	push   %ebx
80103194:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103197:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
8010319d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801031a0:	83 fa 1d             	cmp    $0x1d,%edx
801031a3:	0f 8f 9d 00 00 00    	jg     80103246 <log_write+0xb6>
801031a9:	a1 b8 36 11 80       	mov    0x801136b8,%eax
801031ae:	83 e8 01             	sub    $0x1,%eax
801031b1:	39 c2                	cmp    %eax,%edx
801031b3:	0f 8d 8d 00 00 00    	jge    80103246 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
801031b9:	a1 bc 36 11 80       	mov    0x801136bc,%eax
801031be:	85 c0                	test   %eax,%eax
801031c0:	0f 8e 8d 00 00 00    	jle    80103253 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801031c6:	83 ec 0c             	sub    $0xc,%esp
801031c9:	68 80 36 11 80       	push   $0x80113680
801031ce:	e8 bd 15 00 00       	call   80104790 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801031d3:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
801031d9:	83 c4 10             	add    $0x10,%esp
801031dc:	83 f9 00             	cmp    $0x0,%ecx
801031df:	7e 57                	jle    80103238 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031e1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
801031e4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031e6:	3b 15 cc 36 11 80    	cmp    0x801136cc,%edx
801031ec:	75 0b                	jne    801031f9 <log_write+0x69>
801031ee:	eb 38                	jmp    80103228 <log_write+0x98>
801031f0:	39 14 85 cc 36 11 80 	cmp    %edx,-0x7feec934(,%eax,4)
801031f7:	74 2f                	je     80103228 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
801031f9:	83 c0 01             	add    $0x1,%eax
801031fc:	39 c1                	cmp    %eax,%ecx
801031fe:	75 f0                	jne    801031f0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103200:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103207:	83 c0 01             	add    $0x1,%eax
8010320a:	a3 c8 36 11 80       	mov    %eax,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
8010320f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103212:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80103219:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010321c:	c9                   	leave  
  release(&log.lock);
8010321d:	e9 2e 16 00 00       	jmp    80104850 <release>
80103222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103228:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
8010322f:	eb de                	jmp    8010320f <log_write+0x7f>
80103231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103238:	8b 43 08             	mov    0x8(%ebx),%eax
8010323b:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80103240:	75 cd                	jne    8010320f <log_write+0x7f>
80103242:	31 c0                	xor    %eax,%eax
80103244:	eb c1                	jmp    80103207 <log_write+0x77>
    panic("too big a transaction");
80103246:	83 ec 0c             	sub    $0xc,%esp
80103249:	68 b3 78 10 80       	push   $0x801078b3
8010324e:	e8 2d d2 ff ff       	call   80100480 <panic>
    panic("log_write outside of trans");
80103253:	83 ec 0c             	sub    $0xc,%esp
80103256:	68 c9 78 10 80       	push   $0x801078c9
8010325b:	e8 20 d2 ff ff       	call   80100480 <panic>

80103260 <mpmain>:
    lapicinit();
    mpmain();
}

// Common CPU setup code.
static void mpmain(void) {
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	53                   	push   %ebx
80103264:	83 ec 04             	sub    $0x4,%esp
    cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103267:	e8 a4 09 00 00       	call   80103c10 <cpuid>
8010326c:	89 c3                	mov    %eax,%ebx
8010326e:	e8 9d 09 00 00       	call   80103c10 <cpuid>
80103273:	83 ec 04             	sub    $0x4,%esp
80103276:	53                   	push   %ebx
80103277:	50                   	push   %eax
80103278:	68 e4 78 10 80       	push   $0x801078e4
8010327d:	e8 ce d4 ff ff       	call   80100750 <cprintf>
    idtinit();       // load idt register
80103282:	e8 79 29 00 00       	call   80105c00 <idtinit>
    xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103287:	e8 04 09 00 00       	call   80103b90 <mycpu>
8010328c:	89 c2                	mov    %eax,%edx

static inline uint xchg(volatile uint *addr, uint newval) {
    uint result;

    // The + in "+m" denotes a read-modify-write operand.
    asm volatile ("lock; xchgl %0, %1" :
8010328e:	b8 01 00 00 00       	mov    $0x1,%eax
80103293:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
    scheduler();     // start running processes
8010329a:	e8 51 0c 00 00       	call   80103ef0 <scheduler>
8010329f:	90                   	nop

801032a0 <mpenter>:
static void mpenter(void)  {
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	83 ec 08             	sub    $0x8,%esp
    switchkvm();
801032a6:	e8 45 3a 00 00       	call   80106cf0 <switchkvm>
    seginit();
801032ab:	e8 b0 39 00 00       	call   80106c60 <seginit>
    lapicinit();
801032b0:	e8 9b f7 ff ff       	call   80102a50 <lapicinit>
    mpmain();
801032b5:	e8 a6 ff ff ff       	call   80103260 <mpmain>
801032ba:	66 90                	xchg   %ax,%ax
801032bc:	66 90                	xchg   %ax,%ax
801032be:	66 90                	xchg   %ax,%ax

801032c0 <main>:
int main(void) {
801032c0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801032c4:	83 e4 f0             	and    $0xfffffff0,%esp
801032c7:	ff 71 fc             	pushl  -0x4(%ecx)
801032ca:	55                   	push   %ebp
801032cb:	89 e5                	mov    %esp,%ebp
801032cd:	53                   	push   %ebx
801032ce:	51                   	push   %ecx
    kinit1(end, P2V(4 * 1024 * 1024)); // phys page allocator
801032cf:	83 ec 08             	sub    $0x8,%esp
801032d2:	68 00 00 40 80       	push   $0x80400000
801032d7:	68 a8 64 11 80       	push   $0x801164a8
801032dc:	e8 2f f5 ff ff       	call   80102810 <kinit1>
    kvmalloc();      // kernel page table
801032e1:	e8 da 3e 00 00       	call   801071c0 <kvmalloc>
    mpinit();        // detect other processors
801032e6:	e8 75 01 00 00       	call   80103460 <mpinit>
    lapicinit();     // interrupt controller
801032eb:	e8 60 f7 ff ff       	call   80102a50 <lapicinit>
    seginit();       // segment descriptors
801032f0:	e8 6b 39 00 00       	call   80106c60 <seginit>
    picinit();       // disable pic
801032f5:	e8 46 03 00 00       	call   80103640 <picinit>
    ioapicinit();    // another interrupt controller
801032fa:	e8 41 f3 ff ff       	call   80102640 <ioapicinit>
    consoleinit();   // console hardware
801032ff:	e8 fc d7 ff ff       	call   80100b00 <consoleinit>
    uartinit();      // serial port
80103304:	e8 27 2c 00 00       	call   80105f30 <uartinit>
    pinit();         // process table
80103309:	e8 62 08 00 00       	call   80103b70 <pinit>
    tvinit();        // trap vectors
8010330e:	e8 6d 28 00 00       	call   80105b80 <tvinit>
    binit();         // buffer cache
80103313:	e8 28 cd ff ff       	call   80100040 <binit>
    fileinit();      // file table
80103318:	e8 63 de ff ff       	call   80101180 <fileinit>
    ideinit();       // disk
8010331d:	e8 fe f0 ff ff       	call   80102420 <ideinit>

    // Write entry code to unused memory at 0x7000.
    // The linker has placed the image of entryother.S in
    // _binary_entryother_start.
    code = P2V(0x7000);
    memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103322:	83 c4 0c             	add    $0xc,%esp
80103325:	68 7a 00 00 00       	push   $0x7a
8010332a:	68 8c b4 10 80       	push   $0x8010b48c
8010332f:	68 00 70 00 80       	push   $0x80007000
80103334:	e8 17 16 00 00       	call   80104950 <memmove>

    for (c = cpus; c < cpus + ncpu; c++) {
80103339:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103340:	00 00 00 
80103343:	83 c4 10             	add    $0x10,%esp
80103346:	05 80 37 11 80       	add    $0x80113780,%eax
8010334b:	3d 80 37 11 80       	cmp    $0x80113780,%eax
80103350:	76 71                	jbe    801033c3 <main+0x103>
80103352:	bb 80 37 11 80       	mov    $0x80113780,%ebx
80103357:	89 f6                	mov    %esi,%esi
80103359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if (c == mycpu()) { // We've started already.
80103360:	e8 2b 08 00 00       	call   80103b90 <mycpu>
80103365:	39 d8                	cmp    %ebx,%eax
80103367:	74 41                	je     801033aa <main+0xea>
        }

        // Tell entryother.S what stack to use, where to enter, and what
        // pgdir to use. We cannot use kpgdir yet, because the AP processor
        // is running in low  memory, so we use entrypgdir for the APs too.
        stack = kalloc();
80103369:	e8 72 f5 ff ff       	call   801028e0 <kalloc>
        *(void**)(code - 4) = stack + KSTACKSIZE;
8010336e:	05 00 10 00 00       	add    $0x1000,%eax
        *(void(**)(void))(code - 8) = mpenter;
80103373:	c7 05 f8 6f 00 80 a0 	movl   $0x801032a0,0x80006ff8
8010337a:	32 10 80 
        *(int**)(code - 12) = (void *) V2P(entrypgdir);
8010337d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103384:	a0 10 00 
        *(void**)(code - 4) = stack + KSTACKSIZE;
80103387:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

        lapicstartap(c->apicid, V2P(code));
8010338c:	0f b6 03             	movzbl (%ebx),%eax
8010338f:	83 ec 08             	sub    $0x8,%esp
80103392:	68 00 70 00 00       	push   $0x7000
80103397:	50                   	push   %eax
80103398:	e8 03 f8 ff ff       	call   80102ba0 <lapicstartap>
8010339d:	83 c4 10             	add    $0x10,%esp

        // wait for cpu to finish mpmain()
        while (c->started == 0) {
801033a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801033a6:	85 c0                	test   %eax,%eax
801033a8:	74 f6                	je     801033a0 <main+0xe0>
    for (c = cpus; c < cpus + ncpu; c++) {
801033aa:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801033b1:	00 00 00 
801033b4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801033ba:	05 80 37 11 80       	add    $0x80113780,%eax
801033bf:	39 c3                	cmp    %eax,%ebx
801033c1:	72 9d                	jb     80103360 <main+0xa0>
    kinit2(P2V(4 * 1024 * 1024), P2V(PHYSTOP)); // must come after startothers()
801033c3:	83 ec 08             	sub    $0x8,%esp
801033c6:	68 00 00 00 8e       	push   $0x8e000000
801033cb:	68 00 00 40 80       	push   $0x80400000
801033d0:	e8 ab f4 ff ff       	call   80102880 <kinit2>
    userinit();      // first user process
801033d5:	e8 86 08 00 00       	call   80103c60 <userinit>
    mpmain();        // finish this processor's setup
801033da:	e8 81 fe ff ff       	call   80103260 <mpmain>
801033df:	90                   	nop

801033e0 <mpsearch1>:
    }
    return sum;
}

// Look for an MP structure in the len bytes at addr.
static struct mp*mpsearch1(uint a, int len) {
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
    uchar *e, *p, *addr;

    addr = P2V(a);
801033e5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
static struct mp*mpsearch1(uint a, int len) {
801033eb:	53                   	push   %ebx
    e = addr + len;
801033ec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
static struct mp*mpsearch1(uint a, int len) {
801033ef:	83 ec 0c             	sub    $0xc,%esp
    for (p = addr; p < e; p += sizeof(struct mp)) {
801033f2:	39 de                	cmp    %ebx,%esi
801033f4:	72 10                	jb     80103406 <mpsearch1+0x26>
801033f6:	eb 50                	jmp    80103448 <mpsearch1+0x68>
801033f8:	90                   	nop
801033f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103400:	39 fb                	cmp    %edi,%ebx
80103402:	89 fe                	mov    %edi,%esi
80103404:	76 42                	jbe    80103448 <mpsearch1+0x68>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0) {
80103406:	83 ec 04             	sub    $0x4,%esp
80103409:	8d 7e 10             	lea    0x10(%esi),%edi
8010340c:	6a 04                	push   $0x4
8010340e:	68 f8 78 10 80       	push   $0x801078f8
80103413:	56                   	push   %esi
80103414:	e8 d7 14 00 00       	call   801048f0 <memcmp>
80103419:	83 c4 10             	add    $0x10,%esp
8010341c:	85 c0                	test   %eax,%eax
8010341e:	75 e0                	jne    80103400 <mpsearch1+0x20>
80103420:	89 f1                	mov    %esi,%ecx
80103422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        sum += addr[i];
80103428:	0f b6 11             	movzbl (%ecx),%edx
8010342b:	83 c1 01             	add    $0x1,%ecx
8010342e:	01 d0                	add    %edx,%eax
    for (i = 0; i < len; i++) {
80103430:	39 f9                	cmp    %edi,%ecx
80103432:	75 f4                	jne    80103428 <mpsearch1+0x48>
        if (memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0) {
80103434:	84 c0                	test   %al,%al
80103436:	75 c8                	jne    80103400 <mpsearch1+0x20>
            return (struct mp*)p;
        }
    }
    return 0;
}
80103438:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010343b:	89 f0                	mov    %esi,%eax
8010343d:	5b                   	pop    %ebx
8010343e:	5e                   	pop    %esi
8010343f:	5f                   	pop    %edi
80103440:	5d                   	pop    %ebp
80103441:	c3                   	ret    
80103442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103448:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
8010344b:	31 f6                	xor    %esi,%esi
}
8010344d:	89 f0                	mov    %esi,%eax
8010344f:	5b                   	pop    %ebx
80103450:	5e                   	pop    %esi
80103451:	5f                   	pop    %edi
80103452:	5d                   	pop    %ebp
80103453:	c3                   	ret    
80103454:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010345a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103460 <mpinit>:
    }
    *pmp = mp;
    return conf;
}

void mpinit(void) {
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	57                   	push   %edi
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 1c             	sub    $0x1c,%esp
    if ((p = ((bda[0x0F] << 8) | bda[0x0E]) << 4)) {
80103469:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103470:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103477:	c1 e0 08             	shl    $0x8,%eax
8010347a:	09 d0                	or     %edx,%eax
8010347c:	c1 e0 04             	shl    $0x4,%eax
8010347f:	85 c0                	test   %eax,%eax
80103481:	75 1b                	jne    8010349e <mpinit+0x3e>
        p = ((bda[0x14] << 8) | bda[0x13]) * 1024;
80103483:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010348a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103491:	c1 e0 08             	shl    $0x8,%eax
80103494:	09 d0                	or     %edx,%eax
80103496:	c1 e0 0a             	shl    $0xa,%eax
        if ((mp = mpsearch1(p - 1024, 1024))) {
80103499:	2d 00 04 00 00       	sub    $0x400,%eax
        if ((mp = mpsearch1(p, 1024))) {
8010349e:	ba 00 04 00 00       	mov    $0x400,%edx
801034a3:	e8 38 ff ff ff       	call   801033e0 <mpsearch1>
801034a8:	85 c0                	test   %eax,%eax
801034aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034ad:	0f 84 3d 01 00 00    	je     801035f0 <mpinit+0x190>
    if ((mp = mpsearch()) == 0 || mp->physaddr == 0) {
801034b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034b6:	8b 58 04             	mov    0x4(%eax),%ebx
801034b9:	85 db                	test   %ebx,%ebx
801034bb:	0f 84 4f 01 00 00    	je     80103610 <mpinit+0x1b0>
    conf = (struct mpconf*) P2V((uint) mp->physaddr);
801034c1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
    if (memcmp(conf, "PCMP", 4) != 0) {
801034c7:	83 ec 04             	sub    $0x4,%esp
801034ca:	6a 04                	push   $0x4
801034cc:	68 15 79 10 80       	push   $0x80107915
801034d1:	56                   	push   %esi
801034d2:	e8 19 14 00 00       	call   801048f0 <memcmp>
801034d7:	83 c4 10             	add    $0x10,%esp
801034da:	85 c0                	test   %eax,%eax
801034dc:	0f 85 2e 01 00 00    	jne    80103610 <mpinit+0x1b0>
    if (conf->version != 1 && conf->version != 4) {
801034e2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801034e9:	3c 01                	cmp    $0x1,%al
801034eb:	0f 95 c2             	setne  %dl
801034ee:	3c 04                	cmp    $0x4,%al
801034f0:	0f 95 c0             	setne  %al
801034f3:	20 c2                	and    %al,%dl
801034f5:	0f 85 15 01 00 00    	jne    80103610 <mpinit+0x1b0>
    if (sum((uchar*)conf, conf->length) != 0) {
801034fb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
    for (i = 0; i < len; i++) {
80103502:	66 85 ff             	test   %di,%di
80103505:	74 1a                	je     80103521 <mpinit+0xc1>
80103507:	89 f0                	mov    %esi,%eax
80103509:	01 f7                	add    %esi,%edi
    sum = 0;
8010350b:	31 d2                	xor    %edx,%edx
8010350d:	8d 76 00             	lea    0x0(%esi),%esi
        sum += addr[i];
80103510:	0f b6 08             	movzbl (%eax),%ecx
80103513:	83 c0 01             	add    $0x1,%eax
80103516:	01 ca                	add    %ecx,%edx
    for (i = 0; i < len; i++) {
80103518:	39 c7                	cmp    %eax,%edi
8010351a:	75 f4                	jne    80103510 <mpinit+0xb0>
8010351c:	84 d2                	test   %dl,%dl
8010351e:	0f 95 c2             	setne  %dl
    struct mp *mp;
    struct mpconf *conf;
    struct mpproc *proc;
    struct mpioapic *ioapic;

    if ((conf = mpconfig(&mp)) == 0) {
80103521:	85 f6                	test   %esi,%esi
80103523:	0f 84 e7 00 00 00    	je     80103610 <mpinit+0x1b0>
80103529:	84 d2                	test   %dl,%dl
8010352b:	0f 85 df 00 00 00    	jne    80103610 <mpinit+0x1b0>
        panic("Expect to run on an SMP");
    }
    ismp = 1;
    lapic = (uint*)conf->lapicaddr;
80103531:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103537:	a3 7c 36 11 80       	mov    %eax,0x8011367c
    for (p = (uchar*)(conf + 1), e = (uchar*)conf + conf->length; p < e;) {
8010353c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103543:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
    ismp = 1;
80103549:	bb 01 00 00 00       	mov    $0x1,%ebx
    for (p = (uchar*)(conf + 1), e = (uchar*)conf + conf->length; p < e;) {
8010354e:	01 d6                	add    %edx,%esi
80103550:	39 c6                	cmp    %eax,%esi
80103552:	76 23                	jbe    80103577 <mpinit+0x117>
        switch (*p) {
80103554:	0f b6 10             	movzbl (%eax),%edx
80103557:	80 fa 04             	cmp    $0x4,%dl
8010355a:	0f 87 ca 00 00 00    	ja     8010362a <mpinit+0x1ca>
80103560:	ff 24 95 3c 79 10 80 	jmp    *-0x7fef86c4(,%edx,4)
80103567:	89 f6                	mov    %esi,%esi
80103569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
                p += sizeof(struct mpioapic);
                continue;
            case MPBUS:
            case MPIOINTR:
            case MPLINTR:
                p += 8;
80103570:	83 c0 08             	add    $0x8,%eax
    for (p = (uchar*)(conf + 1), e = (uchar*)conf + conf->length; p < e;) {
80103573:	39 c6                	cmp    %eax,%esi
80103575:	77 dd                	ja     80103554 <mpinit+0xf4>
            default:
                ismp = 0;
                break;
        }
    }
    if (!ismp) {
80103577:	85 db                	test   %ebx,%ebx
80103579:	0f 84 9e 00 00 00    	je     8010361d <mpinit+0x1bd>
        panic("Didn't find a suitable machine");
    }

    if (mp->imcrp) {
8010357f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103582:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103586:	74 15                	je     8010359d <mpinit+0x13d>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80103588:	b8 70 00 00 00       	mov    $0x70,%eax
8010358d:	ba 22 00 00 00       	mov    $0x22,%edx
80103592:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80103593:	ba 23 00 00 00       	mov    $0x23,%edx
80103598:	ec                   	in     (%dx),%al
        // Bochs doesn't support IMCR, so this doesn't run on Bochs.
        // But it would on real hardware.
        outb(0x22, 0x70);   // Select IMCR
        outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103599:	83 c8 01             	or     $0x1,%eax
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
8010359c:	ee                   	out    %al,(%dx)
    }
}
8010359d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035a0:	5b                   	pop    %ebx
801035a1:	5e                   	pop    %esi
801035a2:	5f                   	pop    %edi
801035a3:	5d                   	pop    %ebp
801035a4:	c3                   	ret    
801035a5:	8d 76 00             	lea    0x0(%esi),%esi
                if (ncpu < NCPU) {
801035a8:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
801035ae:	83 f9 07             	cmp    $0x7,%ecx
801035b1:	7f 19                	jg     801035cc <mpinit+0x16c>
                    cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035b3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801035b7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
                    ncpu++;
801035bd:	83 c1 01             	add    $0x1,%ecx
801035c0:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
                    cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035c6:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
                p += sizeof(struct mpproc);
801035cc:	83 c0 14             	add    $0x14,%eax
                continue;
801035cf:	e9 7c ff ff ff       	jmp    80103550 <mpinit+0xf0>
801035d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                ioapicid = ioapic->apicno;
801035d8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
                p += sizeof(struct mpioapic);
801035dc:	83 c0 08             	add    $0x8,%eax
                ioapicid = ioapic->apicno;
801035df:	88 15 60 37 11 80    	mov    %dl,0x80113760
                continue;
801035e5:	e9 66 ff ff ff       	jmp    80103550 <mpinit+0xf0>
801035ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return mpsearch1(0xF0000, 0x10000);
801035f0:	ba 00 00 01 00       	mov    $0x10000,%edx
801035f5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801035fa:	e8 e1 fd ff ff       	call   801033e0 <mpsearch1>
    if ((mp = mpsearch()) == 0 || mp->physaddr == 0) {
801035ff:	85 c0                	test   %eax,%eax
    return mpsearch1(0xF0000, 0x10000);
80103601:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if ((mp = mpsearch()) == 0 || mp->physaddr == 0) {
80103604:	0f 85 a9 fe ff ff    	jne    801034b3 <mpinit+0x53>
8010360a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        panic("Expect to run on an SMP");
80103610:	83 ec 0c             	sub    $0xc,%esp
80103613:	68 fd 78 10 80       	push   $0x801078fd
80103618:	e8 63 ce ff ff       	call   80100480 <panic>
        panic("Didn't find a suitable machine");
8010361d:	83 ec 0c             	sub    $0xc,%esp
80103620:	68 1c 79 10 80       	push   $0x8010791c
80103625:	e8 56 ce ff ff       	call   80100480 <panic>
                ismp = 0;
8010362a:	31 db                	xor    %ebx,%ebx
8010362c:	e9 26 ff ff ff       	jmp    80103557 <mpinit+0xf7>
80103631:	66 90                	xchg   %ax,%ax
80103633:	66 90                	xchg   %ax,%ax
80103635:	66 90                	xchg   %ax,%ax
80103637:	66 90                	xchg   %ax,%ax
80103639:	66 90                	xchg   %ax,%ax
8010363b:	66 90                	xchg   %ax,%ax
8010363d:	66 90                	xchg   %ax,%ax
8010363f:	90                   	nop

80103640 <picinit>:
// I/O Addresses of the two programmable interrupt controllers
#define IO_PIC1         0x20    // Master (IRQs 0-7)
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void picinit(void) {
80103640:	55                   	push   %ebp
80103641:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103646:	ba 21 00 00 00       	mov    $0x21,%edx
8010364b:	89 e5                	mov    %esp,%ebp
8010364d:	ee                   	out    %al,(%dx)
8010364e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103653:	ee                   	out    %al,(%dx)
    // mask all interrupts
    outb(IO_PIC1 + 1, 0xFF);
    outb(IO_PIC2 + 1, 0xFF);
}
80103654:	5d                   	pop    %ebp
80103655:	c3                   	ret    
80103656:	66 90                	xchg   %ax,%ax
80103658:	66 90                	xchg   %ax,%ax
8010365a:	66 90                	xchg   %ax,%ax
8010365c:	66 90                	xchg   %ax,%ax
8010365e:	66 90                	xchg   %ax,%ax

80103660 <cleanuppipealloc>:
    uint nwrite;    // number of bytes written
    int readopen;   // read fd is still open
    int writeopen;  // write fd is still open
};

void cleanuppipealloc(struct pipe *p, struct file **f0, struct file **f1) {
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	56                   	push   %esi
80103664:	53                   	push   %ebx
80103665:	8b 45 08             	mov    0x8(%ebp),%eax
80103668:	8b 75 0c             	mov    0xc(%ebp),%esi
8010366b:	8b 5d 10             	mov    0x10(%ebp),%ebx
     if (p) {
8010366e:	85 c0                	test   %eax,%eax
80103670:	74 0c                	je     8010367e <cleanuppipealloc+0x1e>
        kfree((char*)p);
80103672:	83 ec 0c             	sub    $0xc,%esp
80103675:	50                   	push   %eax
80103676:	e8 b5 f0 ff ff       	call   80102730 <kfree>
8010367b:	83 c4 10             	add    $0x10,%esp
    }
    if (*f0) {
8010367e:	8b 06                	mov    (%esi),%eax
80103680:	85 c0                	test   %eax,%eax
80103682:	74 0c                	je     80103690 <cleanuppipealloc+0x30>
        fileclose(*f0);
80103684:	83 ec 0c             	sub    $0xc,%esp
80103687:	50                   	push   %eax
80103688:	e8 d3 db ff ff       	call   80101260 <fileclose>
8010368d:	83 c4 10             	add    $0x10,%esp
    }
    if (*f1) {
80103690:	8b 03                	mov    (%ebx),%eax
80103692:	85 c0                	test   %eax,%eax
80103694:	74 12                	je     801036a8 <cleanuppipealloc+0x48>
        fileclose(*f1);
80103696:	89 45 08             	mov    %eax,0x8(%ebp)
    }   
}
80103699:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010369c:	5b                   	pop    %ebx
8010369d:	5e                   	pop    %esi
8010369e:	5d                   	pop    %ebp
        fileclose(*f1);
8010369f:	e9 bc db ff ff       	jmp    80101260 <fileclose>
801036a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
801036a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036ab:	5b                   	pop    %ebx
801036ac:	5e                   	pop    %esi
801036ad:	5d                   	pop    %ebp
801036ae:	c3                   	ret    
801036af:	90                   	nop

801036b0 <pipealloc>:

int pipealloc(struct file **f0, struct file **f1) {
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	57                   	push   %edi
801036b4:	56                   	push   %esi
801036b5:	53                   	push   %ebx
801036b6:	83 ec 0c             	sub    $0xc,%esp
801036b9:	8b 75 08             	mov    0x8(%ebp),%esi
801036bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
    struct pipe *p;

    p = 0;
    *f0 = *f1 = 0;
801036bf:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801036c5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0) {
801036cb:	e8 d0 da ff ff       	call   801011a0 <filealloc>
801036d0:	85 c0                	test   %eax,%eax
801036d2:	89 06                	mov    %eax,(%esi)
801036d4:	0f 84 96 00 00 00    	je     80103770 <pipealloc+0xc0>
801036da:	e8 c1 da ff ff       	call   801011a0 <filealloc>
801036df:	85 c0                	test   %eax,%eax
801036e1:	89 07                	mov    %eax,(%edi)
801036e3:	0f 84 87 00 00 00    	je     80103770 <pipealloc+0xc0>
        cleanuppipealloc(p, f0, f1);
        return -1;
    }
    if ((p = (struct pipe*)kalloc()) == 0) {
801036e9:	e8 f2 f1 ff ff       	call   801028e0 <kalloc>
801036ee:	85 c0                	test   %eax,%eax
801036f0:	89 c3                	mov    %eax,%ebx
801036f2:	74 7c                	je     80103770 <pipealloc+0xc0>
    }
    p->readopen = 1;
    p->writeopen = 1;
    p->nwrite = 0;
    p->nread = 0;
    initlock(&p->lock, "pipe");
801036f4:	83 ec 08             	sub    $0x8,%esp
    p->readopen = 1;
801036f7:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801036fe:	00 00 00 
    p->writeopen = 1;
80103701:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103708:	00 00 00 
    p->nwrite = 0;
8010370b:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103712:	00 00 00 
    p->nread = 0;
80103715:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
8010371c:	00 00 00 
    initlock(&p->lock, "pipe");
8010371f:	68 50 79 10 80       	push   $0x80107950
80103724:	50                   	push   %eax
80103725:	e8 26 0f 00 00       	call   80104650 <initlock>
    (*f0)->type = FD_PIPE;
8010372a:	8b 06                	mov    (%esi),%eax
    (*f0)->pipe = p;
    (*f1)->type = FD_PIPE;
    (*f1)->readable = 0;
    (*f1)->writable = 1;
    (*f1)->pipe = p;
    return 0;
8010372c:	83 c4 10             	add    $0x10,%esp
    (*f0)->type = FD_PIPE;
8010372f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    (*f0)->readable = 1;
80103735:	8b 06                	mov    (%esi),%eax
80103737:	c6 40 08 01          	movb   $0x1,0x8(%eax)
    (*f0)->writable = 0;
8010373b:	8b 06                	mov    (%esi),%eax
8010373d:	c6 40 09 00          	movb   $0x0,0x9(%eax)
    (*f0)->pipe = p;
80103741:	8b 06                	mov    (%esi),%eax
80103743:	89 58 0c             	mov    %ebx,0xc(%eax)
    (*f1)->type = FD_PIPE;
80103746:	8b 07                	mov    (%edi),%eax
80103748:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    (*f1)->readable = 0;
8010374e:	8b 07                	mov    (%edi),%eax
80103750:	c6 40 08 00          	movb   $0x0,0x8(%eax)
    (*f1)->writable = 1;
80103754:	8b 07                	mov    (%edi),%eax
80103756:	c6 40 09 01          	movb   $0x1,0x9(%eax)
    (*f1)->pipe = p;
8010375a:	8b 07                	mov    (%edi),%eax
8010375c:	89 58 0c             	mov    %ebx,0xc(%eax)
    return 0;
8010375f:	31 c0                	xor    %eax,%eax
}
80103761:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103764:	5b                   	pop    %ebx
80103765:	5e                   	pop    %esi
80103766:	5f                   	pop    %edi
80103767:	5d                   	pop    %ebp
80103768:	c3                   	ret    
80103769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        cleanuppipealloc(p, f0, f1);
80103770:	83 ec 04             	sub    $0x4,%esp
80103773:	57                   	push   %edi
80103774:	56                   	push   %esi
80103775:	6a 00                	push   $0x0
80103777:	e8 e4 fe ff ff       	call   80103660 <cleanuppipealloc>
        return -1;
8010377c:	83 c4 10             	add    $0x10,%esp
8010377f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103784:	eb db                	jmp    80103761 <pipealloc+0xb1>
80103786:	8d 76 00             	lea    0x0(%esi),%esi
80103789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103790 <pipeclose>:

void pipeclose(struct pipe *p, int writable) {
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	56                   	push   %esi
80103794:	53                   	push   %ebx
80103795:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103798:	8b 75 0c             	mov    0xc(%ebp),%esi
    acquire(&p->lock);
8010379b:	83 ec 0c             	sub    $0xc,%esp
8010379e:	53                   	push   %ebx
8010379f:	e8 ec 0f 00 00       	call   80104790 <acquire>
    if (writable) {
801037a4:	83 c4 10             	add    $0x10,%esp
801037a7:	85 f6                	test   %esi,%esi
801037a9:	74 45                	je     801037f0 <pipeclose+0x60>
        p->writeopen = 0;
        wakeup(&p->nread);
801037ab:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037b1:	83 ec 0c             	sub    $0xc,%esp
        p->writeopen = 0;
801037b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801037bb:	00 00 00 
        wakeup(&p->nread);
801037be:	50                   	push   %eax
801037bf:	e8 bc 0b 00 00       	call   80104380 <wakeup>
801037c4:	83 c4 10             	add    $0x10,%esp
    }
    else {
        p->readopen = 0;
        wakeup(&p->nwrite);
    }
    if (p->readopen == 0 && p->writeopen == 0) {
801037c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801037cd:	85 d2                	test   %edx,%edx
801037cf:	75 0a                	jne    801037db <pipeclose+0x4b>
801037d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801037d7:	85 c0                	test   %eax,%eax
801037d9:	74 35                	je     80103810 <pipeclose+0x80>
        release(&p->lock);
        kfree((char*)p);
    }
    else {
        release(&p->lock);
801037db:	89 5d 08             	mov    %ebx,0x8(%ebp)
    }
}
801037de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037e1:	5b                   	pop    %ebx
801037e2:	5e                   	pop    %esi
801037e3:	5d                   	pop    %ebp
        release(&p->lock);
801037e4:	e9 67 10 00 00       	jmp    80104850 <release>
801037e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        wakeup(&p->nwrite);
801037f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801037f6:	83 ec 0c             	sub    $0xc,%esp
        p->readopen = 0;
801037f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103800:	00 00 00 
        wakeup(&p->nwrite);
80103803:	50                   	push   %eax
80103804:	e8 77 0b 00 00       	call   80104380 <wakeup>
80103809:	83 c4 10             	add    $0x10,%esp
8010380c:	eb b9                	jmp    801037c7 <pipeclose+0x37>
8010380e:	66 90                	xchg   %ax,%ax
        release(&p->lock);
80103810:	83 ec 0c             	sub    $0xc,%esp
80103813:	53                   	push   %ebx
80103814:	e8 37 10 00 00       	call   80104850 <release>
        kfree((char*)p);
80103819:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010381c:	83 c4 10             	add    $0x10,%esp
}
8010381f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103822:	5b                   	pop    %ebx
80103823:	5e                   	pop    %esi
80103824:	5d                   	pop    %ebp
        kfree((char*)p);
80103825:	e9 06 ef ff ff       	jmp    80102730 <kfree>
8010382a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103830 <pipewrite>:

int pipewrite(struct pipe *p, char *addr, int n) {
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	57                   	push   %edi
80103834:	56                   	push   %esi
80103835:	53                   	push   %ebx
80103836:	83 ec 28             	sub    $0x28,%esp
80103839:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int i;

    acquire(&p->lock);
8010383c:	53                   	push   %ebx
8010383d:	e8 4e 0f 00 00       	call   80104790 <acquire>
    for (i = 0; i < n; i++) {
80103842:	8b 45 10             	mov    0x10(%ebp),%eax
80103845:	83 c4 10             	add    $0x10,%esp
80103848:	85 c0                	test   %eax,%eax
8010384a:	0f 8e c9 00 00 00    	jle    80103919 <pipewrite+0xe9>
80103850:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103853:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
        while (p->nwrite == p->nread + PIPESIZE) { //DOC: pipewrite-full
            if (p->readopen == 0 || myproc()->killed) {
                release(&p->lock);
                return -1;
            }
            wakeup(&p->nread);
80103859:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010385f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103862:	03 4d 10             	add    0x10(%ebp),%ecx
80103865:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        while (p->nwrite == p->nread + PIPESIZE) { //DOC: pipewrite-full
80103868:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010386e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103874:	39 d0                	cmp    %edx,%eax
80103876:	75 71                	jne    801038e9 <pipewrite+0xb9>
            if (p->readopen == 0 || myproc()->killed) {
80103878:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010387e:	85 c0                	test   %eax,%eax
80103880:	74 4e                	je     801038d0 <pipewrite+0xa0>
            sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103882:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103888:	eb 3a                	jmp    801038c4 <pipewrite+0x94>
8010388a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            wakeup(&p->nread);
80103890:	83 ec 0c             	sub    $0xc,%esp
80103893:	57                   	push   %edi
80103894:	e8 e7 0a 00 00       	call   80104380 <wakeup>
            sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103899:	5a                   	pop    %edx
8010389a:	59                   	pop    %ecx
8010389b:	53                   	push   %ebx
8010389c:	56                   	push   %esi
8010389d:	e8 2e 09 00 00       	call   801041d0 <sleep>
        while (p->nwrite == p->nread + PIPESIZE) { //DOC: pipewrite-full
801038a2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038a8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801038ae:	83 c4 10             	add    $0x10,%esp
801038b1:	05 00 02 00 00       	add    $0x200,%eax
801038b6:	39 c2                	cmp    %eax,%edx
801038b8:	75 36                	jne    801038f0 <pipewrite+0xc0>
            if (p->readopen == 0 || myproc()->killed) {
801038ba:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801038c0:	85 c0                	test   %eax,%eax
801038c2:	74 0c                	je     801038d0 <pipewrite+0xa0>
801038c4:	e8 67 03 00 00       	call   80103c30 <myproc>
801038c9:	8b 40 24             	mov    0x24(%eax),%eax
801038cc:	85 c0                	test   %eax,%eax
801038ce:	74 c0                	je     80103890 <pipewrite+0x60>
                release(&p->lock);
801038d0:	83 ec 0c             	sub    $0xc,%esp
801038d3:	53                   	push   %ebx
801038d4:	e8 77 0f 00 00       	call   80104850 <release>
                return -1;
801038d9:	83 c4 10             	add    $0x10,%esp
801038dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        p->data[p->nwrite++ % PIPESIZE] = addr[i];
    }
    wakeup(&p->nread);  //DOC: pipewrite-wakeup1
    release(&p->lock);
    return n;
}
801038e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038e4:	5b                   	pop    %ebx
801038e5:	5e                   	pop    %esi
801038e6:	5f                   	pop    %edi
801038e7:	5d                   	pop    %ebp
801038e8:	c3                   	ret    
        while (p->nwrite == p->nread + PIPESIZE) { //DOC: pipewrite-full
801038e9:	89 c2                	mov    %eax,%edx
801038eb:	90                   	nop
801038ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->data[p->nwrite++ % PIPESIZE] = addr[i];
801038f0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801038f3:	8d 42 01             	lea    0x1(%edx),%eax
801038f6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801038fc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103902:	83 c6 01             	add    $0x1,%esi
80103905:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
    for (i = 0; i < n; i++) {
80103909:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010390c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
        p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010390f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
    for (i = 0; i < n; i++) {
80103913:	0f 85 4f ff ff ff    	jne    80103868 <pipewrite+0x38>
    wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103919:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010391f:	83 ec 0c             	sub    $0xc,%esp
80103922:	50                   	push   %eax
80103923:	e8 58 0a 00 00       	call   80104380 <wakeup>
    release(&p->lock);
80103928:	89 1c 24             	mov    %ebx,(%esp)
8010392b:	e8 20 0f 00 00       	call   80104850 <release>
    return n;
80103930:	83 c4 10             	add    $0x10,%esp
80103933:	8b 45 10             	mov    0x10(%ebp),%eax
80103936:	eb a9                	jmp    801038e1 <pipewrite+0xb1>
80103938:	90                   	nop
80103939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103940 <piperead>:

int piperead(struct pipe *p, char *addr, int n)     {
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	57                   	push   %edi
80103944:	56                   	push   %esi
80103945:	53                   	push   %ebx
80103946:	83 ec 18             	sub    $0x18,%esp
80103949:	8b 75 08             	mov    0x8(%ebp),%esi
8010394c:	8b 7d 0c             	mov    0xc(%ebp),%edi
    int i;

    acquire(&p->lock);
8010394f:	56                   	push   %esi
80103950:	e8 3b 0e 00 00       	call   80104790 <acquire>
    while (p->nread == p->nwrite && p->writeopen) { //DOC: pipe-empty
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010395e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103964:	75 6a                	jne    801039d0 <piperead+0x90>
80103966:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010396c:	85 db                	test   %ebx,%ebx
8010396e:	0f 84 c4 00 00 00    	je     80103a38 <piperead+0xf8>
        if (myproc()->killed) {
            release(&p->lock);
            return -1;
        }
        sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103974:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010397a:	eb 2d                	jmp    801039a9 <piperead+0x69>
8010397c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103980:	83 ec 08             	sub    $0x8,%esp
80103983:	56                   	push   %esi
80103984:	53                   	push   %ebx
80103985:	e8 46 08 00 00       	call   801041d0 <sleep>
    while (p->nread == p->nwrite && p->writeopen) { //DOC: pipe-empty
8010398a:	83 c4 10             	add    $0x10,%esp
8010398d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103993:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103999:	75 35                	jne    801039d0 <piperead+0x90>
8010399b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801039a1:	85 d2                	test   %edx,%edx
801039a3:	0f 84 8f 00 00 00    	je     80103a38 <piperead+0xf8>
        if (myproc()->killed) {
801039a9:	e8 82 02 00 00       	call   80103c30 <myproc>
801039ae:	8b 48 24             	mov    0x24(%eax),%ecx
801039b1:	85 c9                	test   %ecx,%ecx
801039b3:	74 cb                	je     80103980 <piperead+0x40>
            release(&p->lock);
801039b5:	83 ec 0c             	sub    $0xc,%esp
            return -1;
801039b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
            release(&p->lock);
801039bd:	56                   	push   %esi
801039be:	e8 8d 0e 00 00       	call   80104850 <release>
            return -1;
801039c3:	83 c4 10             	add    $0x10,%esp
        addr[i] = p->data[p->nread++ % PIPESIZE];
    }
    wakeup(&p->nwrite);  //DOC: piperead-wakeup
    release(&p->lock);
    return i;
}
801039c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039c9:	89 d8                	mov    %ebx,%eax
801039cb:	5b                   	pop    %ebx
801039cc:	5e                   	pop    %esi
801039cd:	5f                   	pop    %edi
801039ce:	5d                   	pop    %ebp
801039cf:	c3                   	ret    
    for (i = 0; i < n; i++) {  //DOC: piperead-copy
801039d0:	8b 45 10             	mov    0x10(%ebp),%eax
801039d3:	85 c0                	test   %eax,%eax
801039d5:	7e 61                	jle    80103a38 <piperead+0xf8>
        if (p->nread == p->nwrite) {
801039d7:	31 db                	xor    %ebx,%ebx
801039d9:	eb 13                	jmp    801039ee <piperead+0xae>
801039db:	90                   	nop
801039dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039e0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801039e6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801039ec:	74 1f                	je     80103a0d <piperead+0xcd>
        addr[i] = p->data[p->nread++ % PIPESIZE];
801039ee:	8d 41 01             	lea    0x1(%ecx),%eax
801039f1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801039f7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801039fd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103a02:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    for (i = 0; i < n; i++) {  //DOC: piperead-copy
80103a05:	83 c3 01             	add    $0x1,%ebx
80103a08:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103a0b:	75 d3                	jne    801039e0 <piperead+0xa0>
    wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103a0d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103a13:	83 ec 0c             	sub    $0xc,%esp
80103a16:	50                   	push   %eax
80103a17:	e8 64 09 00 00       	call   80104380 <wakeup>
    release(&p->lock);
80103a1c:	89 34 24             	mov    %esi,(%esp)
80103a1f:	e8 2c 0e 00 00       	call   80104850 <release>
    return i;
80103a24:	83 c4 10             	add    $0x10,%esp
}
80103a27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a2a:	89 d8                	mov    %ebx,%eax
80103a2c:	5b                   	pop    %ebx
80103a2d:	5e                   	pop    %esi
80103a2e:	5f                   	pop    %edi
80103a2f:	5d                   	pop    %ebp
80103a30:	c3                   	ret    
80103a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a38:	31 db                	xor    %ebx,%ebx
80103a3a:	eb d1                	jmp    80103a0d <piperead+0xcd>
80103a3c:	66 90                	xchg   %ax,%ax
80103a3e:	66 90                	xchg   %ax,%ax

80103a40 <allocproc>:

// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc* allocproc(void) {
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	53                   	push   %ebx
80103a44:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;
    char *sp;
    int found = 0;

    acquire(&ptable.lock);
80103a47:	68 20 3d 11 80       	push   $0x80113d20
80103a4c:	e8 3f 0d 00 00       	call   80104790 <acquire>

    p = ptable.proc;
    while (p < &ptable.proc[NPROC] && !found) {
        if (p->state == UNUSED) {
80103a51:	8b 15 60 3d 11 80    	mov    0x80113d60,%edx
80103a57:	83 c4 10             	add    $0x10,%esp
80103a5a:	85 d2                	test   %edx,%edx
80103a5c:	74 3a                	je     80103a98 <allocproc+0x58>
            found = 1;
        }
        else {
            p++;
80103a5e:	bb d0 3d 11 80       	mov    $0x80113dd0,%ebx
80103a63:	90                   	nop
80103a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->state == UNUSED) {
80103a68:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a6b:	85 c0                	test   %eax,%eax
80103a6d:	74 31                	je     80103aa0 <allocproc+0x60>
            p++;
80103a6f:	83 c3 7c             	add    $0x7c,%ebx
    while (p < &ptable.proc[NPROC] && !found) {
80103a72:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80103a78:	72 ee                	jb     80103a68 <allocproc+0x28>
        }
       
    }
    if (!found) {    
        release(&ptable.lock);
80103a7a:	83 ec 0c             	sub    $0xc,%esp
        return 0;
80103a7d:	31 db                	xor    %ebx,%ebx
        release(&ptable.lock);
80103a7f:	68 20 3d 11 80       	push   $0x80113d20
80103a84:	e8 c7 0d 00 00       	call   80104850 <release>
        return 0;
80103a89:	83 c4 10             	add    $0x10,%esp
    p->context = (struct context*)sp;
    memset(p->context, 0, sizeof *p->context);
    p->context->eip = (uint)forkret;

    return p;
}
80103a8c:	89 d8                	mov    %ebx,%eax
80103a8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a91:	c9                   	leave  
80103a92:	c3                   	ret    
80103a93:	90                   	nop
80103a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p = ptable.proc;
80103a98:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi
    p->pid = nextpid++;
80103aa0:	a1 04 b0 10 80       	mov    0x8010b004,%eax
    release(&ptable.lock);
80103aa5:	83 ec 0c             	sub    $0xc,%esp
    p->state = EMBRYO;
80103aa8:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;
80103aaf:	8d 50 01             	lea    0x1(%eax),%edx
80103ab2:	89 43 10             	mov    %eax,0x10(%ebx)
    release(&ptable.lock);
80103ab5:	68 20 3d 11 80       	push   $0x80113d20
    p->pid = nextpid++;
80103aba:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
    release(&ptable.lock);
80103ac0:	e8 8b 0d 00 00       	call   80104850 <release>
    if ((p->kstack = kalloc()) == 0) {
80103ac5:	e8 16 ee ff ff       	call   801028e0 <kalloc>
80103aca:	83 c4 10             	add    $0x10,%esp
80103acd:	85 c0                	test   %eax,%eax
80103acf:	89 43 08             	mov    %eax,0x8(%ebx)
80103ad2:	74 3c                	je     80103b10 <allocproc+0xd0>
    sp -= sizeof *p->tf;
80103ad4:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    memset(p->context, 0, sizeof *p->context);
80103ada:	83 ec 04             	sub    $0x4,%esp
    sp -= sizeof *p->context;
80103add:	05 9c 0f 00 00       	add    $0xf9c,%eax
    sp -= sizeof *p->tf;
80103ae2:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint*)sp = (uint)trapret;
80103ae5:	c7 40 14 6f 5b 10 80 	movl   $0x80105b6f,0x14(%eax)
    p->context = (struct context*)sp;
80103aec:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103aef:	6a 14                	push   $0x14
80103af1:	6a 00                	push   $0x0
80103af3:	50                   	push   %eax
80103af4:	e8 a7 0d 00 00       	call   801048a0 <memset>
    p->context->eip = (uint)forkret;
80103af9:	8b 43 1c             	mov    0x1c(%ebx),%eax
    return p;
80103afc:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint)forkret;
80103aff:	c7 40 10 20 3b 10 80 	movl   $0x80103b20,0x10(%eax)
}
80103b06:	89 d8                	mov    %ebx,%eax
80103b08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b0b:	c9                   	leave  
80103b0c:	c3                   	ret    
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
        p->state = UNUSED;
80103b10:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
80103b17:	31 db                	xor    %ebx,%ebx
80103b19:	e9 6e ff ff ff       	jmp    80103a8c <allocproc+0x4c>
80103b1e:	66 90                	xchg   %ax,%ax

80103b20 <forkret>:
    release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void) {
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	83 ec 14             	sub    $0x14,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80103b26:	68 20 3d 11 80       	push   $0x80113d20
80103b2b:	e8 20 0d 00 00       	call   80104850 <release>

    if (first) {
80103b30:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103b35:	83 c4 10             	add    $0x10,%esp
80103b38:	85 c0                	test   %eax,%eax
80103b3a:	75 04                	jne    80103b40 <forkret+0x20>
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}
80103b3c:	c9                   	leave  
80103b3d:	c3                   	ret    
80103b3e:	66 90                	xchg   %ax,%ax
        iinit(ROOTDEV);
80103b40:	83 ec 0c             	sub    $0xc,%esp
        first = 0;
80103b43:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103b4a:	00 00 00 
        iinit(ROOTDEV);
80103b4d:	6a 01                	push   $0x1
80103b4f:	e8 4c dd ff ff       	call   801018a0 <iinit>
        initlog(ROOTDEV);
80103b54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103b5b:	e8 c0 f3 ff ff       	call   80102f20 <initlog>
80103b60:	83 c4 10             	add    $0x10,%esp
}
80103b63:	c9                   	leave  
80103b64:	c3                   	ret    
80103b65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b70 <pinit>:
void pinit(void) {
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
80103b76:	68 55 79 10 80       	push   $0x80107955
80103b7b:	68 20 3d 11 80       	push   $0x80113d20
80103b80:	e8 cb 0a 00 00       	call   80104650 <initlock>
}
80103b85:	83 c4 10             	add    $0x10,%esp
80103b88:	c9                   	leave  
80103b89:	c3                   	ret    
80103b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b90 <mycpu>:
struct cpu*mycpu(void)  {
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	56                   	push   %esi
80103b94:	53                   	push   %ebx
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
80103b95:	9c                   	pushf  
80103b96:	58                   	pop    %eax
    if (readeflags() & FL_IF) {
80103b97:	f6 c4 02             	test   $0x2,%ah
80103b9a:	75 5e                	jne    80103bfa <mycpu+0x6a>
    apicid = lapicid();
80103b9c:	e8 af ef ff ff       	call   80102b50 <lapicid>
    for (i = 0; i < ncpu; ++i) {
80103ba1:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103ba7:	85 f6                	test   %esi,%esi
80103ba9:	7e 42                	jle    80103bed <mycpu+0x5d>
        if (cpus[i].apicid == apicid) {
80103bab:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103bb2:	39 d0                	cmp    %edx,%eax
80103bb4:	74 30                	je     80103be6 <mycpu+0x56>
80103bb6:	b9 30 38 11 80       	mov    $0x80113830,%ecx
    for (i = 0; i < ncpu; ++i) {
80103bbb:	31 d2                	xor    %edx,%edx
80103bbd:	8d 76 00             	lea    0x0(%esi),%esi
80103bc0:	83 c2 01             	add    $0x1,%edx
80103bc3:	39 f2                	cmp    %esi,%edx
80103bc5:	74 26                	je     80103bed <mycpu+0x5d>
        if (cpus[i].apicid == apicid) {
80103bc7:	0f b6 19             	movzbl (%ecx),%ebx
80103bca:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103bd0:	39 c3                	cmp    %eax,%ebx
80103bd2:	75 ec                	jne    80103bc0 <mycpu+0x30>
80103bd4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103bda:	05 80 37 11 80       	add    $0x80113780,%eax
}
80103bdf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103be2:	5b                   	pop    %ebx
80103be3:	5e                   	pop    %esi
80103be4:	5d                   	pop    %ebp
80103be5:	c3                   	ret    
        if (cpus[i].apicid == apicid) {
80103be6:	b8 80 37 11 80       	mov    $0x80113780,%eax
            return &cpus[i];
80103beb:	eb f2                	jmp    80103bdf <mycpu+0x4f>
    panic("unknown apicid\n");
80103bed:	83 ec 0c             	sub    $0xc,%esp
80103bf0:	68 5c 79 10 80       	push   $0x8010795c
80103bf5:	e8 86 c8 ff ff       	call   80100480 <panic>
        panic("mycpu called with interrupts enabled\n");
80103bfa:	83 ec 0c             	sub    $0xc,%esp
80103bfd:	68 38 7a 10 80       	push   $0x80107a38
80103c02:	e8 79 c8 ff ff       	call   80100480 <panic>
80103c07:	89 f6                	mov    %esi,%esi
80103c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c10 <cpuid>:
int cpuid() {
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
80103c16:	e8 75 ff ff ff       	call   80103b90 <mycpu>
80103c1b:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103c20:	c9                   	leave  
    return mycpu() - cpus;
80103c21:	c1 f8 04             	sar    $0x4,%eax
80103c24:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c2a:	c3                   	ret    
80103c2b:	90                   	nop
80103c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c30 <myproc>:
struct proc*myproc(void)  {
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	53                   	push   %ebx
80103c34:	83 ec 04             	sub    $0x4,%esp
    pushcli();
80103c37:	e8 84 0a 00 00       	call   801046c0 <pushcli>
    c = mycpu();
80103c3c:	e8 4f ff ff ff       	call   80103b90 <mycpu>
    p = c->proc;
80103c41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103c47:	e8 b4 0a 00 00       	call   80104700 <popcli>
}
80103c4c:	83 c4 04             	add    $0x4,%esp
80103c4f:	89 d8                	mov    %ebx,%eax
80103c51:	5b                   	pop    %ebx
80103c52:	5d                   	pop    %ebp
80103c53:	c3                   	ret    
80103c54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c60 <userinit>:
void userinit(void) {
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	53                   	push   %ebx
80103c64:	83 ec 04             	sub    $0x4,%esp
    p = allocproc();
80103c67:	e8 d4 fd ff ff       	call   80103a40 <allocproc>
80103c6c:	89 c3                	mov    %eax,%ebx
    initproc = p;
80103c6e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
    if ((p->pgdir = setupkvm()) == 0) {
80103c73:	e8 c8 34 00 00       	call   80107140 <setupkvm>
80103c78:	85 c0                	test   %eax,%eax
80103c7a:	89 43 04             	mov    %eax,0x4(%ebx)
80103c7d:	0f 84 bd 00 00 00    	je     80103d40 <userinit+0xe0>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c83:	83 ec 04             	sub    $0x4,%esp
80103c86:	68 2c 00 00 00       	push   $0x2c
80103c8b:	68 60 b4 10 80       	push   $0x8010b460
80103c90:	50                   	push   %eax
80103c91:	e8 8a 31 00 00       	call   80106e20 <inituvm>
    memset(p->tf, 0, sizeof(*p->tf));
80103c96:	83 c4 0c             	add    $0xc,%esp
    p->sz = PGSIZE;
80103c99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
80103c9f:	6a 4c                	push   $0x4c
80103ca1:	6a 00                	push   $0x0
80103ca3:	ff 73 18             	pushl  0x18(%ebx)
80103ca6:	e8 f5 0b 00 00       	call   801048a0 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cab:	8b 43 18             	mov    0x18(%ebx),%eax
80103cae:	ba 1b 00 00 00       	mov    $0x1b,%edx
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cb3:	b9 23 00 00 00       	mov    $0x23,%ecx
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103cb8:	83 c4 0c             	add    $0xc,%esp
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cbb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cbf:	8b 43 18             	mov    0x18(%ebx),%eax
80103cc2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
    p->tf->es = p->tf->ds;
80103cc6:	8b 43 18             	mov    0x18(%ebx),%eax
80103cc9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ccd:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80103cd1:	8b 43 18             	mov    0x18(%ebx),%eax
80103cd4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103cd8:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80103cdc:	8b 43 18             	mov    0x18(%ebx),%eax
80103cdf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80103ce6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ce9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80103cf0:	8b 43 18             	mov    0x18(%ebx),%eax
80103cf3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
80103cfa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103cfd:	6a 10                	push   $0x10
80103cff:	68 85 79 10 80       	push   $0x80107985
80103d04:	50                   	push   %eax
80103d05:	e8 76 0d 00 00       	call   80104a80 <safestrcpy>
    p->cwd = namei("/");
80103d0a:	c7 04 24 8e 79 10 80 	movl   $0x8010798e,(%esp)
80103d11:	e8 ea e5 ff ff       	call   80102300 <namei>
80103d16:	89 43 68             	mov    %eax,0x68(%ebx)
    acquire(&ptable.lock);
80103d19:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d20:	e8 6b 0a 00 00       	call   80104790 <acquire>
    p->state = RUNNABLE;
80103d25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    release(&ptable.lock);
80103d2c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d33:	e8 18 0b 00 00       	call   80104850 <release>
}
80103d38:	83 c4 10             	add    $0x10,%esp
80103d3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d3e:	c9                   	leave  
80103d3f:	c3                   	ret    
        panic("userinit: out of memory?");
80103d40:	83 ec 0c             	sub    $0xc,%esp
80103d43:	68 6c 79 10 80       	push   $0x8010796c
80103d48:	e8 33 c7 ff ff       	call   80100480 <panic>
80103d4d:	8d 76 00             	lea    0x0(%esi),%esi

80103d50 <growproc>:
int growproc(int n) {
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	56                   	push   %esi
80103d54:	53                   	push   %ebx
80103d55:	8b 75 08             	mov    0x8(%ebp),%esi
    pushcli();
80103d58:	e8 63 09 00 00       	call   801046c0 <pushcli>
    c = mycpu();
80103d5d:	e8 2e fe ff ff       	call   80103b90 <mycpu>
    p = c->proc;
80103d62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103d68:	e8 93 09 00 00       	call   80104700 <popcli>
    if (n > 0) {
80103d6d:	83 fe 00             	cmp    $0x0,%esi
    sz = curproc->sz;
80103d70:	8b 03                	mov    (%ebx),%eax
    if (n > 0) {
80103d72:	7f 1c                	jg     80103d90 <growproc+0x40>
    else if (n < 0) {
80103d74:	75 3a                	jne    80103db0 <growproc+0x60>
    switchuvm(curproc);
80103d76:	83 ec 0c             	sub    $0xc,%esp
    curproc->sz = sz;
80103d79:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103d7b:	53                   	push   %ebx
80103d7c:	e8 8f 2f 00 00       	call   80106d10 <switchuvm>
    return 0;
80103d81:	83 c4 10             	add    $0x10,%esp
80103d84:	31 c0                	xor    %eax,%eax
}
80103d86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d89:	5b                   	pop    %ebx
80103d8a:	5e                   	pop    %esi
80103d8b:	5d                   	pop    %ebp
80103d8c:	c3                   	ret    
80103d8d:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0) {
80103d90:	83 ec 04             	sub    $0x4,%esp
80103d93:	01 c6                	add    %eax,%esi
80103d95:	56                   	push   %esi
80103d96:	50                   	push   %eax
80103d97:	ff 73 04             	pushl  0x4(%ebx)
80103d9a:	e8 c1 31 00 00       	call   80106f60 <allocuvm>
80103d9f:	83 c4 10             	add    $0x10,%esp
80103da2:	85 c0                	test   %eax,%eax
80103da4:	75 d0                	jne    80103d76 <growproc+0x26>
            return -1;
80103da6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dab:	eb d9                	jmp    80103d86 <growproc+0x36>
80103dad:	8d 76 00             	lea    0x0(%esi),%esi
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0) {
80103db0:	83 ec 04             	sub    $0x4,%esp
80103db3:	01 c6                	add    %eax,%esi
80103db5:	56                   	push   %esi
80103db6:	50                   	push   %eax
80103db7:	ff 73 04             	pushl  0x4(%ebx)
80103dba:	e8 d1 32 00 00       	call   80107090 <deallocuvm>
80103dbf:	83 c4 10             	add    $0x10,%esp
80103dc2:	85 c0                	test   %eax,%eax
80103dc4:	75 b0                	jne    80103d76 <growproc+0x26>
80103dc6:	eb de                	jmp    80103da6 <growproc+0x56>
80103dc8:	90                   	nop
80103dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103dd0 <fork>:
int fork(void) {
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	57                   	push   %edi
80103dd4:	56                   	push   %esi
80103dd5:	53                   	push   %ebx
80103dd6:	83 ec 1c             	sub    $0x1c,%esp
    pushcli();
80103dd9:	e8 e2 08 00 00       	call   801046c0 <pushcli>
    c = mycpu();
80103dde:	e8 ad fd ff ff       	call   80103b90 <mycpu>
    p = c->proc;
80103de3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103de9:	e8 12 09 00 00       	call   80104700 <popcli>
    if ((np = allocproc()) == 0) {
80103dee:	e8 4d fc ff ff       	call   80103a40 <allocproc>
80103df3:	85 c0                	test   %eax,%eax
80103df5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103df8:	0f 84 b7 00 00 00    	je     80103eb5 <fork+0xe5>
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
80103dfe:	83 ec 08             	sub    $0x8,%esp
80103e01:	ff 33                	pushl  (%ebx)
80103e03:	ff 73 04             	pushl  0x4(%ebx)
80103e06:	89 c7                	mov    %eax,%edi
80103e08:	e8 03 34 00 00       	call   80107210 <copyuvm>
80103e0d:	83 c4 10             	add    $0x10,%esp
80103e10:	85 c0                	test   %eax,%eax
80103e12:	89 47 04             	mov    %eax,0x4(%edi)
80103e15:	0f 84 a1 00 00 00    	je     80103ebc <fork+0xec>
    np->sz = curproc->sz;
80103e1b:	8b 03                	mov    (%ebx),%eax
80103e1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103e20:	89 01                	mov    %eax,(%ecx)
    np->parent = curproc;
80103e22:	89 59 14             	mov    %ebx,0x14(%ecx)
80103e25:	89 c8                	mov    %ecx,%eax
    *np->tf = *curproc->tf;
80103e27:	8b 79 18             	mov    0x18(%ecx),%edi
80103e2a:	8b 73 18             	mov    0x18(%ebx),%esi
80103e2d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103e32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    for (i = 0; i < NOFILE; i++) {
80103e34:	31 f6                	xor    %esi,%esi
    np->tf->eax = 0;
80103e36:	8b 40 18             	mov    0x18(%eax),%eax
80103e39:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
        if (curproc->ofile[i]) {
80103e40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e44:	85 c0                	test   %eax,%eax
80103e46:	74 13                	je     80103e5b <fork+0x8b>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103e48:	83 ec 0c             	sub    $0xc,%esp
80103e4b:	50                   	push   %eax
80103e4c:	e8 bf d3 ff ff       	call   80101210 <filedup>
80103e51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e54:	83 c4 10             	add    $0x10,%esp
80103e57:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
    for (i = 0; i < NOFILE; i++) {
80103e5b:	83 c6 01             	add    $0x1,%esi
80103e5e:	83 fe 10             	cmp    $0x10,%esi
80103e61:	75 dd                	jne    80103e40 <fork+0x70>
    np->cwd = idup(curproc->cwd);
80103e63:	83 ec 0c             	sub    $0xc,%esp
80103e66:	ff 73 68             	pushl  0x68(%ebx)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e69:	83 c3 6c             	add    $0x6c,%ebx
    np->cwd = idup(curproc->cwd);
80103e6c:	e8 ff db ff ff       	call   80101a70 <idup>
80103e71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e74:	83 c4 0c             	add    $0xc,%esp
    np->cwd = idup(curproc->cwd);
80103e77:	89 47 68             	mov    %eax,0x68(%edi)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e7a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e7d:	6a 10                	push   $0x10
80103e7f:	53                   	push   %ebx
80103e80:	50                   	push   %eax
80103e81:	e8 fa 0b 00 00       	call   80104a80 <safestrcpy>
    pid = np->pid;
80103e86:	8b 5f 10             	mov    0x10(%edi),%ebx
    acquire(&ptable.lock);
80103e89:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e90:	e8 fb 08 00 00       	call   80104790 <acquire>
    np->state = RUNNABLE;
80103e95:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
    release(&ptable.lock);
80103e9c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ea3:	e8 a8 09 00 00       	call   80104850 <release>
    return pid;
80103ea8:	83 c4 10             	add    $0x10,%esp
}
80103eab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103eae:	89 d8                	mov    %ebx,%eax
80103eb0:	5b                   	pop    %ebx
80103eb1:	5e                   	pop    %esi
80103eb2:	5f                   	pop    %edi
80103eb3:	5d                   	pop    %ebp
80103eb4:	c3                   	ret    
        return -1;
80103eb5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103eba:	eb ef                	jmp    80103eab <fork+0xdb>
        kfree(np->kstack);
80103ebc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103ebf:	83 ec 0c             	sub    $0xc,%esp
80103ec2:	ff 73 08             	pushl  0x8(%ebx)
80103ec5:	e8 66 e8 ff ff       	call   80102730 <kfree>
        np->kstack = 0;
80103eca:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->state = UNUSED;
80103ed1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return -1;
80103ed8:	83 c4 10             	add    $0x10,%esp
80103edb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ee0:	eb c9                	jmp    80103eab <fork+0xdb>
80103ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ef0 <scheduler>:
void scheduler(void) {
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	57                   	push   %edi
80103ef4:	56                   	push   %esi
80103ef5:	53                   	push   %ebx
80103ef6:	83 ec 0c             	sub    $0xc,%esp
    struct cpu *c = mycpu();
80103ef9:	e8 92 fc ff ff       	call   80103b90 <mycpu>
80103efe:	8d 78 04             	lea    0x4(%eax),%edi
80103f01:	89 c6                	mov    %eax,%esi
    c->proc = 0;
80103f03:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f0a:	00 00 00 
80103f0d:	8d 76 00             	lea    0x0(%esi),%esi
    asm volatile ("sti");
80103f10:	fb                   	sti    
        acquire(&ptable.lock);
80103f11:	83 ec 0c             	sub    $0xc,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103f14:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
        acquire(&ptable.lock);
80103f19:	68 20 3d 11 80       	push   $0x80113d20
80103f1e:	e8 6d 08 00 00       	call   80104790 <acquire>
80103f23:	83 c4 10             	add    $0x10,%esp
80103f26:	8d 76 00             	lea    0x0(%esi),%esi
80103f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            if (p->state != RUNNABLE) {
80103f30:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f34:	75 33                	jne    80103f69 <scheduler+0x79>
            switchuvm(p);
80103f36:	83 ec 0c             	sub    $0xc,%esp
            c->proc = p;
80103f39:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
80103f3f:	53                   	push   %ebx
80103f40:	e8 cb 2d 00 00       	call   80106d10 <switchuvm>
            swtch(&(c->scheduler), p->context);
80103f45:	58                   	pop    %eax
80103f46:	5a                   	pop    %edx
80103f47:	ff 73 1c             	pushl  0x1c(%ebx)
80103f4a:	57                   	push   %edi
            p->state = RUNNING;
80103f4b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
            swtch(&(c->scheduler), p->context);
80103f52:	e8 84 0b 00 00       	call   80104adb <swtch>
            switchkvm();
80103f57:	e8 94 2d 00 00       	call   80106cf0 <switchkvm>
            c->proc = 0;
80103f5c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f63:	00 00 00 
80103f66:	83 c4 10             	add    $0x10,%esp
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103f69:	83 c3 7c             	add    $0x7c,%ebx
80103f6c:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80103f72:	72 bc                	jb     80103f30 <scheduler+0x40>
        release(&ptable.lock);
80103f74:	83 ec 0c             	sub    $0xc,%esp
80103f77:	68 20 3d 11 80       	push   $0x80113d20
80103f7c:	e8 cf 08 00 00       	call   80104850 <release>
        sti();
80103f81:	83 c4 10             	add    $0x10,%esp
80103f84:	eb 8a                	jmp    80103f10 <scheduler+0x20>
80103f86:	8d 76 00             	lea    0x0(%esi),%esi
80103f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f90 <sched>:
void sched(void) {
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	56                   	push   %esi
80103f94:	53                   	push   %ebx
    pushcli();
80103f95:	e8 26 07 00 00       	call   801046c0 <pushcli>
    c = mycpu();
80103f9a:	e8 f1 fb ff ff       	call   80103b90 <mycpu>
    p = c->proc;
80103f9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
80103fa5:	e8 56 07 00 00       	call   80104700 <popcli>
    if (!holding(&ptable.lock)) {
80103faa:	83 ec 0c             	sub    $0xc,%esp
80103fad:	68 20 3d 11 80       	push   $0x80113d20
80103fb2:	e8 a9 07 00 00       	call   80104760 <holding>
80103fb7:	83 c4 10             	add    $0x10,%esp
80103fba:	85 c0                	test   %eax,%eax
80103fbc:	74 4f                	je     8010400d <sched+0x7d>
    if (mycpu()->ncli != 1) {
80103fbe:	e8 cd fb ff ff       	call   80103b90 <mycpu>
80103fc3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103fca:	75 68                	jne    80104034 <sched+0xa4>
    if (p->state == RUNNING) {
80103fcc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103fd0:	74 55                	je     80104027 <sched+0x97>
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
80103fd2:	9c                   	pushf  
80103fd3:	58                   	pop    %eax
    if (readeflags() & FL_IF) {
80103fd4:	f6 c4 02             	test   $0x2,%ah
80103fd7:	75 41                	jne    8010401a <sched+0x8a>
    intena = mycpu()->intena;
80103fd9:	e8 b2 fb ff ff       	call   80103b90 <mycpu>
    swtch(&p->context, mycpu()->scheduler);
80103fde:	83 c3 1c             	add    $0x1c,%ebx
    intena = mycpu()->intena;
80103fe1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
80103fe7:	e8 a4 fb ff ff       	call   80103b90 <mycpu>
80103fec:	83 ec 08             	sub    $0x8,%esp
80103fef:	ff 70 04             	pushl  0x4(%eax)
80103ff2:	53                   	push   %ebx
80103ff3:	e8 e3 0a 00 00       	call   80104adb <swtch>
    mycpu()->intena = intena;
80103ff8:	e8 93 fb ff ff       	call   80103b90 <mycpu>
}
80103ffd:	83 c4 10             	add    $0x10,%esp
    mycpu()->intena = intena;
80104000:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104006:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104009:	5b                   	pop    %ebx
8010400a:	5e                   	pop    %esi
8010400b:	5d                   	pop    %ebp
8010400c:	c3                   	ret    
        panic("sched ptable.lock");
8010400d:	83 ec 0c             	sub    $0xc,%esp
80104010:	68 90 79 10 80       	push   $0x80107990
80104015:	e8 66 c4 ff ff       	call   80100480 <panic>
        panic("sched interruptible");
8010401a:	83 ec 0c             	sub    $0xc,%esp
8010401d:	68 bc 79 10 80       	push   $0x801079bc
80104022:	e8 59 c4 ff ff       	call   80100480 <panic>
        panic("sched running");
80104027:	83 ec 0c             	sub    $0xc,%esp
8010402a:	68 ae 79 10 80       	push   $0x801079ae
8010402f:	e8 4c c4 ff ff       	call   80100480 <panic>
        panic("sched locks");
80104034:	83 ec 0c             	sub    $0xc,%esp
80104037:	68 a2 79 10 80       	push   $0x801079a2
8010403c:	e8 3f c4 ff ff       	call   80100480 <panic>
80104041:	eb 0d                	jmp    80104050 <exit>
80104043:	90                   	nop
80104044:	90                   	nop
80104045:	90                   	nop
80104046:	90                   	nop
80104047:	90                   	nop
80104048:	90                   	nop
80104049:	90                   	nop
8010404a:	90                   	nop
8010404b:	90                   	nop
8010404c:	90                   	nop
8010404d:	90                   	nop
8010404e:	90                   	nop
8010404f:	90                   	nop

80104050 <exit>:
void exit(void)  {
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	57                   	push   %edi
80104054:	56                   	push   %esi
80104055:	53                   	push   %ebx
80104056:	83 ec 0c             	sub    $0xc,%esp
    pushcli();
80104059:	e8 62 06 00 00       	call   801046c0 <pushcli>
    c = mycpu();
8010405e:	e8 2d fb ff ff       	call   80103b90 <mycpu>
    p = c->proc;
80104063:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
80104069:	e8 92 06 00 00       	call   80104700 <popcli>
    if (curproc == initproc) {
8010406e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80104074:	8d 5e 28             	lea    0x28(%esi),%ebx
80104077:	8d 7e 68             	lea    0x68(%esi),%edi
8010407a:	0f 84 e7 00 00 00    	je     80104167 <exit+0x117>
        if (curproc->ofile[fd]) {
80104080:	8b 03                	mov    (%ebx),%eax
80104082:	85 c0                	test   %eax,%eax
80104084:	74 12                	je     80104098 <exit+0x48>
            fileclose(curproc->ofile[fd]);
80104086:	83 ec 0c             	sub    $0xc,%esp
80104089:	50                   	push   %eax
8010408a:	e8 d1 d1 ff ff       	call   80101260 <fileclose>
            curproc->ofile[fd] = 0;
8010408f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104095:	83 c4 10             	add    $0x10,%esp
80104098:	83 c3 04             	add    $0x4,%ebx
    for (fd = 0; fd < NOFILE; fd++) {
8010409b:	39 fb                	cmp    %edi,%ebx
8010409d:	75 e1                	jne    80104080 <exit+0x30>
    begin_op();
8010409f:	e8 1c ef ff ff       	call   80102fc0 <begin_op>
    iput(curproc->cwd);
801040a4:	83 ec 0c             	sub    $0xc,%esp
801040a7:	ff 76 68             	pushl  0x68(%esi)
801040aa:	e8 21 db ff ff       	call   80101bd0 <iput>
    end_op();
801040af:	e8 7c ef ff ff       	call   80103030 <end_op>
    curproc->cwd = 0;
801040b4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
    acquire(&ptable.lock);
801040bb:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801040c2:	e8 c9 06 00 00       	call   80104790 <acquire>
    wakeup1(curproc->parent);
801040c7:	8b 56 14             	mov    0x14(%esi),%edx
801040ca:	83 c4 10             	add    $0x10,%esp
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void wakeup1(void *chan) {
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801040cd:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801040d2:	eb 0e                	jmp    801040e2 <exit+0x92>
801040d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040d8:	83 c0 7c             	add    $0x7c,%eax
801040db:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
801040e0:	73 1c                	jae    801040fe <exit+0xae>
        if (p->state == SLEEPING && p->chan == chan) {
801040e2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040e6:	75 f0                	jne    801040d8 <exit+0x88>
801040e8:	3b 50 20             	cmp    0x20(%eax),%edx
801040eb:	75 eb                	jne    801040d8 <exit+0x88>
            p->state = RUNNABLE;
801040ed:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801040f4:	83 c0 7c             	add    $0x7c,%eax
801040f7:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
801040fc:	72 e4                	jb     801040e2 <exit+0x92>
            p->parent = initproc;
801040fe:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104104:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80104109:	eb 10                	jmp    8010411b <exit+0xcb>
8010410b:	90                   	nop
8010410c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104110:	83 c2 7c             	add    $0x7c,%edx
80104113:	81 fa 54 5c 11 80    	cmp    $0x80115c54,%edx
80104119:	73 33                	jae    8010414e <exit+0xfe>
        if (p->parent == curproc) {
8010411b:	39 72 14             	cmp    %esi,0x14(%edx)
8010411e:	75 f0                	jne    80104110 <exit+0xc0>
            if (p->state == ZOMBIE) {
80104120:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
            p->parent = initproc;
80104124:	89 4a 14             	mov    %ecx,0x14(%edx)
            if (p->state == ZOMBIE) {
80104127:	75 e7                	jne    80104110 <exit+0xc0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104129:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010412e:	eb 0a                	jmp    8010413a <exit+0xea>
80104130:	83 c0 7c             	add    $0x7c,%eax
80104133:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80104138:	73 d6                	jae    80104110 <exit+0xc0>
        if (p->state == SLEEPING && p->chan == chan) {
8010413a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010413e:	75 f0                	jne    80104130 <exit+0xe0>
80104140:	3b 48 20             	cmp    0x20(%eax),%ecx
80104143:	75 eb                	jne    80104130 <exit+0xe0>
            p->state = RUNNABLE;
80104145:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010414c:	eb e2                	jmp    80104130 <exit+0xe0>
    curproc->state = ZOMBIE;
8010414e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
    sched();
80104155:	e8 36 fe ff ff       	call   80103f90 <sched>
    panic("zombie exit");
8010415a:	83 ec 0c             	sub    $0xc,%esp
8010415d:	68 dd 79 10 80       	push   $0x801079dd
80104162:	e8 19 c3 ff ff       	call   80100480 <panic>
        panic("init exiting");
80104167:	83 ec 0c             	sub    $0xc,%esp
8010416a:	68 d0 79 10 80       	push   $0x801079d0
8010416f:	e8 0c c3 ff ff       	call   80100480 <panic>
80104174:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010417a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104180 <yield>:
void yield(void)      {
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	53                   	push   %ebx
80104184:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80104187:	68 20 3d 11 80       	push   $0x80113d20
8010418c:	e8 ff 05 00 00       	call   80104790 <acquire>
    pushcli();
80104191:	e8 2a 05 00 00       	call   801046c0 <pushcli>
    c = mycpu();
80104196:	e8 f5 f9 ff ff       	call   80103b90 <mycpu>
    p = c->proc;
8010419b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801041a1:	e8 5a 05 00 00       	call   80104700 <popcli>
    myproc()->state = RUNNABLE;
801041a6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    sched();
801041ad:	e8 de fd ff ff       	call   80103f90 <sched>
    release(&ptable.lock);
801041b2:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801041b9:	e8 92 06 00 00       	call   80104850 <release>
}
801041be:	83 c4 10             	add    $0x10,%esp
801041c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041c4:	c9                   	leave  
801041c5:	c3                   	ret    
801041c6:	8d 76 00             	lea    0x0(%esi),%esi
801041c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041d0 <sleep>:
void sleep(void *chan, struct spinlock *lk)  {
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	57                   	push   %edi
801041d4:	56                   	push   %esi
801041d5:	53                   	push   %ebx
801041d6:	83 ec 0c             	sub    $0xc,%esp
801041d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801041dc:	8b 75 0c             	mov    0xc(%ebp),%esi
    pushcli();
801041df:	e8 dc 04 00 00       	call   801046c0 <pushcli>
    c = mycpu();
801041e4:	e8 a7 f9 ff ff       	call   80103b90 <mycpu>
    p = c->proc;
801041e9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
801041ef:	e8 0c 05 00 00       	call   80104700 <popcli>
    if (p == 0) {
801041f4:	85 db                	test   %ebx,%ebx
801041f6:	0f 84 87 00 00 00    	je     80104283 <sleep+0xb3>
    if (lk == 0) {
801041fc:	85 f6                	test   %esi,%esi
801041fe:	74 76                	je     80104276 <sleep+0xa6>
    if (lk != &ptable.lock) { //DOC: sleeplock0
80104200:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80104206:	74 50                	je     80104258 <sleep+0x88>
        acquire(&ptable.lock);  //DOC: sleeplock1
80104208:	83 ec 0c             	sub    $0xc,%esp
8010420b:	68 20 3d 11 80       	push   $0x80113d20
80104210:	e8 7b 05 00 00       	call   80104790 <acquire>
        release(lk);
80104215:	89 34 24             	mov    %esi,(%esp)
80104218:	e8 33 06 00 00       	call   80104850 <release>
    p->chan = chan;
8010421d:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
80104220:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104227:	e8 64 fd ff ff       	call   80103f90 <sched>
    p->chan = 0;
8010422c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
        release(&ptable.lock);
80104233:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010423a:	e8 11 06 00 00       	call   80104850 <release>
        acquire(lk);
8010423f:	89 75 08             	mov    %esi,0x8(%ebp)
80104242:	83 c4 10             	add    $0x10,%esp
}
80104245:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104248:	5b                   	pop    %ebx
80104249:	5e                   	pop    %esi
8010424a:	5f                   	pop    %edi
8010424b:	5d                   	pop    %ebp
        acquire(lk);
8010424c:	e9 3f 05 00 00       	jmp    80104790 <acquire>
80104251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->chan = chan;
80104258:	89 7b 20             	mov    %edi,0x20(%ebx)
    p->state = SLEEPING;
8010425b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80104262:	e8 29 fd ff ff       	call   80103f90 <sched>
    p->chan = 0;
80104267:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010426e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104271:	5b                   	pop    %ebx
80104272:	5e                   	pop    %esi
80104273:	5f                   	pop    %edi
80104274:	5d                   	pop    %ebp
80104275:	c3                   	ret    
        panic("sleep without lk");
80104276:	83 ec 0c             	sub    $0xc,%esp
80104279:	68 ef 79 10 80       	push   $0x801079ef
8010427e:	e8 fd c1 ff ff       	call   80100480 <panic>
        panic("sleep");
80104283:	83 ec 0c             	sub    $0xc,%esp
80104286:	68 e9 79 10 80       	push   $0x801079e9
8010428b:	e8 f0 c1 ff ff       	call   80100480 <panic>

80104290 <wait>:
int wait(void) {
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	56                   	push   %esi
80104294:	53                   	push   %ebx
    pushcli();
80104295:	e8 26 04 00 00       	call   801046c0 <pushcli>
    c = mycpu();
8010429a:	e8 f1 f8 ff ff       	call   80103b90 <mycpu>
    p = c->proc;
8010429f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
    popcli();
801042a5:	e8 56 04 00 00       	call   80104700 <popcli>
    acquire(&ptable.lock);
801042aa:	83 ec 0c             	sub    $0xc,%esp
801042ad:	68 20 3d 11 80       	push   $0x80113d20
801042b2:	e8 d9 04 00 00       	call   80104790 <acquire>
801042b7:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
801042ba:	31 c0                	xor    %eax,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042bc:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
801042c1:	eb 10                	jmp    801042d3 <wait+0x43>
801042c3:	90                   	nop
801042c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042c8:	83 c3 7c             	add    $0x7c,%ebx
801042cb:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
801042d1:	73 1b                	jae    801042ee <wait+0x5e>
            if (p->parent != curproc) {
801042d3:	39 73 14             	cmp    %esi,0x14(%ebx)
801042d6:	75 f0                	jne    801042c8 <wait+0x38>
            if (p->state == ZOMBIE) {
801042d8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801042dc:	74 32                	je     80104310 <wait+0x80>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042de:	83 c3 7c             	add    $0x7c,%ebx
            havekids = 1;
801042e1:	b8 01 00 00 00       	mov    $0x1,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801042e6:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
801042ec:	72 e5                	jb     801042d3 <wait+0x43>
        if (!havekids || curproc->killed) {
801042ee:	85 c0                	test   %eax,%eax
801042f0:	74 74                	je     80104366 <wait+0xd6>
801042f2:	8b 46 24             	mov    0x24(%esi),%eax
801042f5:	85 c0                	test   %eax,%eax
801042f7:	75 6d                	jne    80104366 <wait+0xd6>
        sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801042f9:	83 ec 08             	sub    $0x8,%esp
801042fc:	68 20 3d 11 80       	push   $0x80113d20
80104301:	56                   	push   %esi
80104302:	e8 c9 fe ff ff       	call   801041d0 <sleep>
        havekids = 0;
80104307:	83 c4 10             	add    $0x10,%esp
8010430a:	eb ae                	jmp    801042ba <wait+0x2a>
8010430c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                kfree(p->kstack);
80104310:	83 ec 0c             	sub    $0xc,%esp
80104313:	ff 73 08             	pushl  0x8(%ebx)
                pid = p->pid;
80104316:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
80104319:	e8 12 e4 ff ff       	call   80102730 <kfree>
                freevm(p->pgdir);
8010431e:	5a                   	pop    %edx
8010431f:	ff 73 04             	pushl  0x4(%ebx)
                p->kstack = 0;
80104322:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
80104329:	e8 92 2d 00 00       	call   801070c0 <freevm>
                release(&ptable.lock);
8010432e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
                p->pid = 0;
80104335:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
8010433c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
80104343:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
80104347:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
8010434e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
80104355:	e8 f6 04 00 00       	call   80104850 <release>
                return pid;
8010435a:	83 c4 10             	add    $0x10,%esp
}
8010435d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104360:	89 f0                	mov    %esi,%eax
80104362:	5b                   	pop    %ebx
80104363:	5e                   	pop    %esi
80104364:	5d                   	pop    %ebp
80104365:	c3                   	ret    
            release(&ptable.lock);
80104366:	83 ec 0c             	sub    $0xc,%esp
            return -1;
80104369:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
8010436e:	68 20 3d 11 80       	push   $0x80113d20
80104373:	e8 d8 04 00 00       	call   80104850 <release>
            return -1;
80104378:	83 c4 10             	add    $0x10,%esp
8010437b:	eb e0                	jmp    8010435d <wait+0xcd>
8010437d:	8d 76 00             	lea    0x0(%esi),%esi

80104380 <wakeup>:
        }
    }
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan) {
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	53                   	push   %ebx
80104384:	83 ec 10             	sub    $0x10,%esp
80104387:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&ptable.lock);
8010438a:	68 20 3d 11 80       	push   $0x80113d20
8010438f:	e8 fc 03 00 00       	call   80104790 <acquire>
80104394:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104397:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010439c:	eb 0c                	jmp    801043aa <wakeup+0x2a>
8010439e:	66 90                	xchg   %ax,%ax
801043a0:	83 c0 7c             	add    $0x7c,%eax
801043a3:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
801043a8:	73 1c                	jae    801043c6 <wakeup+0x46>
        if (p->state == SLEEPING && p->chan == chan) {
801043aa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043ae:	75 f0                	jne    801043a0 <wakeup+0x20>
801043b0:	3b 58 20             	cmp    0x20(%eax),%ebx
801043b3:	75 eb                	jne    801043a0 <wakeup+0x20>
            p->state = RUNNABLE;
801043b5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043bc:	83 c0 7c             	add    $0x7c,%eax
801043bf:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
801043c4:	72 e4                	jb     801043aa <wakeup+0x2a>
    wakeup1(chan);
    release(&ptable.lock);
801043c6:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
801043cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043d0:	c9                   	leave  
    release(&ptable.lock);
801043d1:	e9 7a 04 00 00       	jmp    80104850 <release>
801043d6:	8d 76 00             	lea    0x0(%esi),%esi
801043d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043e0 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid) {
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	53                   	push   %ebx
801043e4:	83 ec 10             	sub    $0x10,%esp
801043e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
801043ea:	68 20 3d 11 80       	push   $0x80113d20
801043ef:	e8 9c 03 00 00       	call   80104790 <acquire>
801043f4:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043f7:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801043fc:	eb 0c                	jmp    8010440a <kill+0x2a>
801043fe:	66 90                	xchg   %ax,%ax
80104400:	83 c0 7c             	add    $0x7c,%eax
80104403:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80104408:	73 36                	jae    80104440 <kill+0x60>
        if (p->pid == pid) {
8010440a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010440d:	75 f1                	jne    80104400 <kill+0x20>
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING) {
8010440f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
            p->killed = 1;
80104413:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            if (p->state == SLEEPING) {
8010441a:	75 07                	jne    80104423 <kill+0x43>
                p->state = RUNNABLE;
8010441c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            }
            release(&ptable.lock);
80104423:	83 ec 0c             	sub    $0xc,%esp
80104426:	68 20 3d 11 80       	push   $0x80113d20
8010442b:	e8 20 04 00 00       	call   80104850 <release>
            return 0;
80104430:	83 c4 10             	add    $0x10,%esp
80104433:	31 c0                	xor    %eax,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
80104435:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104438:	c9                   	leave  
80104439:	c3                   	ret    
8010443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ptable.lock);
80104440:	83 ec 0c             	sub    $0xc,%esp
80104443:	68 20 3d 11 80       	push   $0x80113d20
80104448:	e8 03 04 00 00       	call   80104850 <release>
    return -1;
8010444d:	83 c4 10             	add    $0x10,%esp
80104450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104455:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104458:	c9                   	leave  
80104459:	c3                   	ret    
8010445a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104460 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	57                   	push   %edi
80104464:	56                   	push   %esi
80104465:	53                   	push   %ebx
80104466:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104469:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
void procdump(void) {
8010446e:	83 ec 3c             	sub    $0x3c,%esp
80104471:	eb 24                	jmp    80104497 <procdump+0x37>
80104473:	90                   	nop
80104474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            getcallerpcs((uint*)p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++) {
                cprintf(" %p", pc[i]);
            }
        }
        cprintf("\n");
80104478:	83 ec 0c             	sub    $0xc,%esp
8010447b:	68 9b 7d 10 80       	push   $0x80107d9b
80104480:	e8 cb c2 ff ff       	call   80100750 <cprintf>
80104485:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104488:	83 c3 7c             	add    $0x7c,%ebx
8010448b:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80104491:	0f 83 81 00 00 00    	jae    80104518 <procdump+0xb8>
        if (p->state == UNUSED) {
80104497:	8b 43 0c             	mov    0xc(%ebx),%eax
8010449a:	85 c0                	test   %eax,%eax
8010449c:	74 ea                	je     80104488 <procdump+0x28>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state]) {
8010449e:	83 f8 05             	cmp    $0x5,%eax
            state = "???";
801044a1:	ba 00 7a 10 80       	mov    $0x80107a00,%edx
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state]) {
801044a6:	77 11                	ja     801044b9 <procdump+0x59>
801044a8:	8b 14 85 60 7a 10 80 	mov    -0x7fef85a0(,%eax,4),%edx
            state = "???";
801044af:	b8 00 7a 10 80       	mov    $0x80107a00,%eax
801044b4:	85 d2                	test   %edx,%edx
801044b6:	0f 44 d0             	cmove  %eax,%edx
        cprintf("%d %s %s", p->pid, state, p->name);
801044b9:	8d 43 6c             	lea    0x6c(%ebx),%eax
801044bc:	50                   	push   %eax
801044bd:	52                   	push   %edx
801044be:	ff 73 10             	pushl  0x10(%ebx)
801044c1:	68 04 7a 10 80       	push   $0x80107a04
801044c6:	e8 85 c2 ff ff       	call   80100750 <cprintf>
        if (p->state == SLEEPING) {
801044cb:	83 c4 10             	add    $0x10,%esp
801044ce:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801044d2:	75 a4                	jne    80104478 <procdump+0x18>
            getcallerpcs((uint*)p->context->ebp + 2, pc);
801044d4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044d7:	83 ec 08             	sub    $0x8,%esp
801044da:	8d 7d c0             	lea    -0x40(%ebp),%edi
801044dd:	50                   	push   %eax
801044de:	8b 43 1c             	mov    0x1c(%ebx),%eax
801044e1:	8b 40 0c             	mov    0xc(%eax),%eax
801044e4:	83 c0 08             	add    $0x8,%eax
801044e7:	50                   	push   %eax
801044e8:	e8 83 01 00 00       	call   80104670 <getcallerpcs>
801044ed:	83 c4 10             	add    $0x10,%esp
            for (i = 0; i < 10 && pc[i] != 0; i++) {
801044f0:	8b 17                	mov    (%edi),%edx
801044f2:	85 d2                	test   %edx,%edx
801044f4:	74 82                	je     80104478 <procdump+0x18>
                cprintf(" %p", pc[i]);
801044f6:	83 ec 08             	sub    $0x8,%esp
801044f9:	83 c7 04             	add    $0x4,%edi
801044fc:	52                   	push   %edx
801044fd:	68 41 74 10 80       	push   $0x80107441
80104502:	e8 49 c2 ff ff       	call   80100750 <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++) {
80104507:	83 c4 10             	add    $0x10,%esp
8010450a:	39 fe                	cmp    %edi,%esi
8010450c:	75 e2                	jne    801044f0 <procdump+0x90>
8010450e:	e9 65 ff ff ff       	jmp    80104478 <procdump+0x18>
80104513:	90                   	nop
80104514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
}
80104518:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010451b:	5b                   	pop    %ebx
8010451c:	5e                   	pop    %esi
8010451d:	5f                   	pop    %edi
8010451e:	5d                   	pop    %ebp
8010451f:	c3                   	ret    

80104520 <initsleeplock>:
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "sleeplock.h"

void initsleeplock(struct sleeplock *lk, char *name) {
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	53                   	push   %ebx
80104524:	83 ec 0c             	sub    $0xc,%esp
80104527:	8b 5d 08             	mov    0x8(%ebp),%ebx
    initlock(&lk->lk, "sleep lock");
8010452a:	68 78 7a 10 80       	push   $0x80107a78
8010452f:	8d 43 04             	lea    0x4(%ebx),%eax
80104532:	50                   	push   %eax
80104533:	e8 18 01 00 00       	call   80104650 <initlock>
    lk->name = name;
80104538:	8b 45 0c             	mov    0xc(%ebp),%eax
    lk->locked = 0;
8010453b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    lk->pid = 0;
}
80104541:	83 c4 10             	add    $0x10,%esp
    lk->pid = 0;
80104544:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
    lk->name = name;
8010454b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010454e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104551:	c9                   	leave  
80104552:	c3                   	ret    
80104553:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104560 <acquiresleep>:

void acquiresleep(struct sleeplock *lk) {
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	56                   	push   %esi
80104564:	53                   	push   %ebx
80104565:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&lk->lk);
80104568:	83 ec 0c             	sub    $0xc,%esp
8010456b:	8d 73 04             	lea    0x4(%ebx),%esi
8010456e:	56                   	push   %esi
8010456f:	e8 1c 02 00 00       	call   80104790 <acquire>
    while (lk->locked) {
80104574:	8b 13                	mov    (%ebx),%edx
80104576:	83 c4 10             	add    $0x10,%esp
80104579:	85 d2                	test   %edx,%edx
8010457b:	74 16                	je     80104593 <acquiresleep+0x33>
8010457d:	8d 76 00             	lea    0x0(%esi),%esi
        sleep(lk, &lk->lk);
80104580:	83 ec 08             	sub    $0x8,%esp
80104583:	56                   	push   %esi
80104584:	53                   	push   %ebx
80104585:	e8 46 fc ff ff       	call   801041d0 <sleep>
    while (lk->locked) {
8010458a:	8b 03                	mov    (%ebx),%eax
8010458c:	83 c4 10             	add    $0x10,%esp
8010458f:	85 c0                	test   %eax,%eax
80104591:	75 ed                	jne    80104580 <acquiresleep+0x20>
    }
    lk->locked = 1;
80104593:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
    lk->pid = myproc()->pid;
80104599:	e8 92 f6 ff ff       	call   80103c30 <myproc>
8010459e:	8b 40 10             	mov    0x10(%eax),%eax
801045a1:	89 43 3c             	mov    %eax,0x3c(%ebx)
    release(&lk->lk);
801045a4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801045a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045aa:	5b                   	pop    %ebx
801045ab:	5e                   	pop    %esi
801045ac:	5d                   	pop    %ebp
    release(&lk->lk);
801045ad:	e9 9e 02 00 00       	jmp    80104850 <release>
801045b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045c0 <releasesleep>:

void releasesleep(struct sleeplock *lk) {
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	56                   	push   %esi
801045c4:	53                   	push   %ebx
801045c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&lk->lk);
801045c8:	83 ec 0c             	sub    $0xc,%esp
801045cb:	8d 73 04             	lea    0x4(%ebx),%esi
801045ce:	56                   	push   %esi
801045cf:	e8 bc 01 00 00       	call   80104790 <acquire>
    lk->locked = 0;
801045d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    lk->pid = 0;
801045da:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
    wakeup(lk);
801045e1:	89 1c 24             	mov    %ebx,(%esp)
801045e4:	e8 97 fd ff ff       	call   80104380 <wakeup>
    release(&lk->lk);
801045e9:	89 75 08             	mov    %esi,0x8(%ebp)
801045ec:	83 c4 10             	add    $0x10,%esp
}
801045ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045f2:	5b                   	pop    %ebx
801045f3:	5e                   	pop    %esi
801045f4:	5d                   	pop    %ebp
    release(&lk->lk);
801045f5:	e9 56 02 00 00       	jmp    80104850 <release>
801045fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104600 <holdingsleep>:

int holdingsleep(struct sleeplock *lk) {
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	57                   	push   %edi
80104604:	56                   	push   %esi
80104605:	53                   	push   %ebx
80104606:	31 ff                	xor    %edi,%edi
80104608:	83 ec 18             	sub    $0x18,%esp
8010460b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int r;

    acquire(&lk->lk);
8010460e:	8d 73 04             	lea    0x4(%ebx),%esi
80104611:	56                   	push   %esi
80104612:	e8 79 01 00 00       	call   80104790 <acquire>
    r = lk->locked && (lk->pid == myproc()->pid);
80104617:	8b 03                	mov    (%ebx),%eax
80104619:	83 c4 10             	add    $0x10,%esp
8010461c:	85 c0                	test   %eax,%eax
8010461e:	74 13                	je     80104633 <holdingsleep+0x33>
80104620:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104623:	e8 08 f6 ff ff       	call   80103c30 <myproc>
80104628:	39 58 10             	cmp    %ebx,0x10(%eax)
8010462b:	0f 94 c0             	sete   %al
8010462e:	0f b6 c0             	movzbl %al,%eax
80104631:	89 c7                	mov    %eax,%edi
    release(&lk->lk);
80104633:	83 ec 0c             	sub    $0xc,%esp
80104636:	56                   	push   %esi
80104637:	e8 14 02 00 00       	call   80104850 <release>
    return r;
}
8010463c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010463f:	89 f8                	mov    %edi,%eax
80104641:	5b                   	pop    %ebx
80104642:	5e                   	pop    %esi
80104643:	5f                   	pop    %edi
80104644:	5d                   	pop    %ebp
80104645:	c3                   	ret    
80104646:	66 90                	xchg   %ax,%ax
80104648:	66 90                	xchg   %ax,%ax
8010464a:	66 90                	xchg   %ax,%ax
8010464c:	66 90                	xchg   %ax,%ax
8010464e:	66 90                	xchg   %ax,%ax

80104650 <initlock>:
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

void initlock(struct spinlock *lk, char *name) {
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	8b 45 08             	mov    0x8(%ebp),%eax
    lk->name = name;
80104656:	8b 55 0c             	mov    0xc(%ebp),%edx
    lk->locked = 0;
80104659:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    lk->name = name;
8010465f:	89 50 04             	mov    %edx,0x4(%eax)
    lk->cpu = 0;
80104662:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104669:	5d                   	pop    %ebp
8010466a:	c3                   	ret    
8010466b:	90                   	nop
8010466c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104670 <getcallerpcs>:

    popcli();
}

// Record the current call stack in pcs[] by following the %ebp chain.
void getcallerpcs(void *v, uint pcs[]) {
80104670:	55                   	push   %ebp
    uint *ebp;
    int i;

    ebp = (uint*)v - 2;
    for (i = 0; i < 10; i++) {
80104671:	31 d2                	xor    %edx,%edx
void getcallerpcs(void *v, uint pcs[]) {
80104673:	89 e5                	mov    %esp,%ebp
80104675:	53                   	push   %ebx
    ebp = (uint*)v - 2;
80104676:	8b 45 08             	mov    0x8(%ebp),%eax
void getcallerpcs(void *v, uint pcs[]) {
80104679:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    ebp = (uint*)v - 2;
8010467c:	83 e8 08             	sub    $0x8,%eax
8010467f:	90                   	nop
        if (ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff) {
80104680:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104686:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010468c:	77 1a                	ja     801046a8 <getcallerpcs+0x38>
            break;
        }
        pcs[i] = ebp[1];     // saved %eip
8010468e:	8b 58 04             	mov    0x4(%eax),%ebx
80104691:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
    for (i = 0; i < 10; i++) {
80104694:	83 c2 01             	add    $0x1,%edx
        ebp = (uint*)ebp[0]; // saved %ebp
80104697:	8b 00                	mov    (%eax),%eax
    for (i = 0; i < 10; i++) {
80104699:	83 fa 0a             	cmp    $0xa,%edx
8010469c:	75 e2                	jne    80104680 <getcallerpcs+0x10>
    }
    for (; i < 10; i++) {
        pcs[i] = 0;
    }
}
8010469e:	5b                   	pop    %ebx
8010469f:	5d                   	pop    %ebp
801046a0:	c3                   	ret    
801046a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046a8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801046ab:	83 c1 28             	add    $0x28,%ecx
801046ae:	66 90                	xchg   %ax,%ax
        pcs[i] = 0;
801046b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801046b6:	83 c0 04             	add    $0x4,%eax
    for (; i < 10; i++) {
801046b9:	39 c1                	cmp    %eax,%ecx
801046bb:	75 f3                	jne    801046b0 <getcallerpcs+0x40>
}
801046bd:	5b                   	pop    %ebx
801046be:	5d                   	pop    %ebp
801046bf:	c3                   	ret    

801046c0 <pushcli>:

// Pushcli/popcli are like cli/sti except that they are matched:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void pushcli(void)      {
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	53                   	push   %ebx
801046c4:	83 ec 04             	sub    $0x4,%esp
801046c7:	9c                   	pushf  
801046c8:	5b                   	pop    %ebx
    asm volatile ("cli");
801046c9:	fa                   	cli    
    int eflags;

    eflags = readeflags();
    cli();
    if (mycpu()->ncli == 0) {
801046ca:	e8 c1 f4 ff ff       	call   80103b90 <mycpu>
801046cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801046d5:	85 c0                	test   %eax,%eax
801046d7:	75 11                	jne    801046ea <pushcli+0x2a>
        mycpu()->intena = eflags & FL_IF;
801046d9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801046df:	e8 ac f4 ff ff       	call   80103b90 <mycpu>
801046e4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
    }
    mycpu()->ncli += 1;
801046ea:	e8 a1 f4 ff ff       	call   80103b90 <mycpu>
801046ef:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801046f6:	83 c4 04             	add    $0x4,%esp
801046f9:	5b                   	pop    %ebx
801046fa:	5d                   	pop    %ebp
801046fb:	c3                   	ret    
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104700 <popcli>:

void popcli(void)      {
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	83 ec 08             	sub    $0x8,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
80104706:	9c                   	pushf  
80104707:	58                   	pop    %eax
    if (readeflags() & FL_IF) {
80104708:	f6 c4 02             	test   $0x2,%ah
8010470b:	75 35                	jne    80104742 <popcli+0x42>
        panic("popcli - interruptible");
    }
    if (--mycpu()->ncli < 0) {
8010470d:	e8 7e f4 ff ff       	call   80103b90 <mycpu>
80104712:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104719:	78 34                	js     8010474f <popcli+0x4f>
        panic("popcli");
    }
    if (mycpu()->ncli == 0 && mycpu()->intena) {
8010471b:	e8 70 f4 ff ff       	call   80103b90 <mycpu>
80104720:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104726:	85 d2                	test   %edx,%edx
80104728:	74 06                	je     80104730 <popcli+0x30>
        sti();
    }
}
8010472a:	c9                   	leave  
8010472b:	c3                   	ret    
8010472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (mycpu()->ncli == 0 && mycpu()->intena) {
80104730:	e8 5b f4 ff ff       	call   80103b90 <mycpu>
80104735:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010473b:	85 c0                	test   %eax,%eax
8010473d:	74 eb                	je     8010472a <popcli+0x2a>
    asm volatile ("sti");
8010473f:	fb                   	sti    
}
80104740:	c9                   	leave  
80104741:	c3                   	ret    
        panic("popcli - interruptible");
80104742:	83 ec 0c             	sub    $0xc,%esp
80104745:	68 83 7a 10 80       	push   $0x80107a83
8010474a:	e8 31 bd ff ff       	call   80100480 <panic>
        panic("popcli");
8010474f:	83 ec 0c             	sub    $0xc,%esp
80104752:	68 9a 7a 10 80       	push   $0x80107a9a
80104757:	e8 24 bd ff ff       	call   80100480 <panic>
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104760 <holding>:
int holding(struct spinlock *lock) {
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	56                   	push   %esi
80104764:	53                   	push   %ebx
80104765:	8b 75 08             	mov    0x8(%ebp),%esi
80104768:	31 db                	xor    %ebx,%ebx
    pushcli();
8010476a:	e8 51 ff ff ff       	call   801046c0 <pushcli>
    r = lock->locked && lock->cpu == mycpu();
8010476f:	8b 06                	mov    (%esi),%eax
80104771:	85 c0                	test   %eax,%eax
80104773:	74 10                	je     80104785 <holding+0x25>
80104775:	8b 5e 08             	mov    0x8(%esi),%ebx
80104778:	e8 13 f4 ff ff       	call   80103b90 <mycpu>
8010477d:	39 c3                	cmp    %eax,%ebx
8010477f:	0f 94 c3             	sete   %bl
80104782:	0f b6 db             	movzbl %bl,%ebx
    popcli();
80104785:	e8 76 ff ff ff       	call   80104700 <popcli>
}
8010478a:	89 d8                	mov    %ebx,%eax
8010478c:	5b                   	pop    %ebx
8010478d:	5e                   	pop    %esi
8010478e:	5d                   	pop    %ebp
8010478f:	c3                   	ret    

80104790 <acquire>:
void acquire(struct spinlock *lk) {
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
    pushcli(); // disable interrupts to avoid deadlock.
80104795:	e8 26 ff ff ff       	call   801046c0 <pushcli>
    if (holding(lk)) {
8010479a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010479d:	83 ec 0c             	sub    $0xc,%esp
801047a0:	53                   	push   %ebx
801047a1:	e8 ba ff ff ff       	call   80104760 <holding>
801047a6:	83 c4 10             	add    $0x10,%esp
801047a9:	85 c0                	test   %eax,%eax
801047ab:	0f 85 83 00 00 00    	jne    80104834 <acquire+0xa4>
801047b1:	89 c6                	mov    %eax,%esi
    asm volatile ("lock; xchgl %0, %1" :
801047b3:	ba 01 00 00 00       	mov    $0x1,%edx
801047b8:	eb 09                	jmp    801047c3 <acquire+0x33>
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047c3:	89 d0                	mov    %edx,%eax
801047c5:	f0 87 03             	lock xchg %eax,(%ebx)
    while (xchg(&lk->locked, 1) != 0) {
801047c8:	85 c0                	test   %eax,%eax
801047ca:	75 f4                	jne    801047c0 <acquire+0x30>
    __sync_synchronize();
801047cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    lk->cpu = mycpu();
801047d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047d4:	e8 b7 f3 ff ff       	call   80103b90 <mycpu>
    getcallerpcs(&lk, lk->pcs);
801047d9:	8d 53 0c             	lea    0xc(%ebx),%edx
    lk->cpu = mycpu();
801047dc:	89 43 08             	mov    %eax,0x8(%ebx)
    ebp = (uint*)v - 2;
801047df:	89 e8                	mov    %ebp,%eax
801047e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff) {
801047e8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801047ee:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801047f4:	77 1a                	ja     80104810 <acquire+0x80>
        pcs[i] = ebp[1];     // saved %eip
801047f6:	8b 48 04             	mov    0x4(%eax),%ecx
801047f9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
    for (i = 0; i < 10; i++) {
801047fc:	83 c6 01             	add    $0x1,%esi
        ebp = (uint*)ebp[0]; // saved %ebp
801047ff:	8b 00                	mov    (%eax),%eax
    for (i = 0; i < 10; i++) {
80104801:	83 fe 0a             	cmp    $0xa,%esi
80104804:	75 e2                	jne    801047e8 <acquire+0x58>
}
80104806:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104809:	5b                   	pop    %ebx
8010480a:	5e                   	pop    %esi
8010480b:	5d                   	pop    %ebp
8010480c:	c3                   	ret    
8010480d:	8d 76 00             	lea    0x0(%esi),%esi
80104810:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104813:	83 c2 28             	add    $0x28,%edx
80104816:	8d 76 00             	lea    0x0(%esi),%esi
80104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        pcs[i] = 0;
80104820:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104826:	83 c0 04             	add    $0x4,%eax
    for (; i < 10; i++) {
80104829:	39 d0                	cmp    %edx,%eax
8010482b:	75 f3                	jne    80104820 <acquire+0x90>
}
8010482d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104830:	5b                   	pop    %ebx
80104831:	5e                   	pop    %esi
80104832:	5d                   	pop    %ebp
80104833:	c3                   	ret    
        panic("acquire");
80104834:	83 ec 0c             	sub    $0xc,%esp
80104837:	68 a1 7a 10 80       	push   $0x80107aa1
8010483c:	e8 3f bc ff ff       	call   80100480 <panic>
80104841:	eb 0d                	jmp    80104850 <release>
80104843:	90                   	nop
80104844:	90                   	nop
80104845:	90                   	nop
80104846:	90                   	nop
80104847:	90                   	nop
80104848:	90                   	nop
80104849:	90                   	nop
8010484a:	90                   	nop
8010484b:	90                   	nop
8010484c:	90                   	nop
8010484d:	90                   	nop
8010484e:	90                   	nop
8010484f:	90                   	nop

80104850 <release>:
void release(struct spinlock *lk) {
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	53                   	push   %ebx
80104854:	83 ec 10             	sub    $0x10,%esp
80104857:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (!holding(lk)) {
8010485a:	53                   	push   %ebx
8010485b:	e8 00 ff ff ff       	call   80104760 <holding>
80104860:	83 c4 10             	add    $0x10,%esp
80104863:	85 c0                	test   %eax,%eax
80104865:	74 22                	je     80104889 <release+0x39>
    lk->pcs[0] = 0;
80104867:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    lk->cpu = 0;
8010486e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    __sync_synchronize();
80104875:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
    asm volatile ("movl $0, %0" : "+m" (lk->locked) :);
8010487a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104880:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104883:	c9                   	leave  
    popcli();
80104884:	e9 77 fe ff ff       	jmp    80104700 <popcli>
        panic("release");
80104889:	83 ec 0c             	sub    $0xc,%esp
8010488c:	68 a9 7a 10 80       	push   $0x80107aa9
80104891:	e8 ea bb ff ff       	call   80100480 <panic>
80104896:	66 90                	xchg   %ax,%ax
80104898:	66 90                	xchg   %ax,%ax
8010489a:	66 90                	xchg   %ax,%ax
8010489c:	66 90                	xchg   %ax,%ax
8010489e:	66 90                	xchg   %ax,%ax

801048a0 <memset>:
#include "types.h"
#include "x86.h"

void* memset(void *dst, int c, uint n) {
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	57                   	push   %edi
801048a4:	53                   	push   %ebx
801048a5:	8b 55 08             	mov    0x8(%ebp),%edx
801048a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
    if ((int)dst % 4 == 0 && n % 4 == 0) {
801048ab:	f6 c2 03             	test   $0x3,%dl
801048ae:	75 05                	jne    801048b5 <memset+0x15>
801048b0:	f6 c1 03             	test   $0x3,%cl
801048b3:	74 13                	je     801048c8 <memset+0x28>
    asm volatile ("cld; rep stosb" :
801048b5:	89 d7                	mov    %edx,%edi
801048b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801048ba:	fc                   	cld    
801048bb:	f3 aa                	rep stos %al,%es:(%edi)
    }
    else {
        stosb(dst, c, n);
    }
    return dst;
}
801048bd:	5b                   	pop    %ebx
801048be:	89 d0                	mov    %edx,%eax
801048c0:	5f                   	pop    %edi
801048c1:	5d                   	pop    %ebp
801048c2:	c3                   	ret    
801048c3:	90                   	nop
801048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        c &= 0xFF;
801048c8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
        stosl(dst, (c << 24) | (c << 16) | (c << 8) | c, n / 4);
801048cc:	c1 e9 02             	shr    $0x2,%ecx
801048cf:	89 f8                	mov    %edi,%eax
801048d1:	89 fb                	mov    %edi,%ebx
801048d3:	c1 e0 18             	shl    $0x18,%eax
801048d6:	c1 e3 10             	shl    $0x10,%ebx
801048d9:	09 d8                	or     %ebx,%eax
801048db:	09 f8                	or     %edi,%eax
801048dd:	c1 e7 08             	shl    $0x8,%edi
801048e0:	09 f8                	or     %edi,%eax
    asm volatile ("cld; rep stosl" :
801048e2:	89 d7                	mov    %edx,%edi
801048e4:	fc                   	cld    
801048e5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801048e7:	5b                   	pop    %ebx
801048e8:	89 d0                	mov    %edx,%eax
801048ea:	5f                   	pop    %edi
801048eb:	5d                   	pop    %ebp
801048ec:	c3                   	ret    
801048ed:	8d 76 00             	lea    0x0(%esi),%esi

801048f0 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n) {
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	57                   	push   %edi
801048f4:	56                   	push   %esi
801048f5:	53                   	push   %ebx
801048f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801048f9:	8b 75 08             	mov    0x8(%ebp),%esi
801048fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
    const uchar *s1, *s2;

    s1 = v1;
    s2 = v2;
    while (n-- > 0) {
801048ff:	85 db                	test   %ebx,%ebx
80104901:	74 29                	je     8010492c <memcmp+0x3c>
        if (*s1 != *s2) {
80104903:	0f b6 16             	movzbl (%esi),%edx
80104906:	0f b6 0f             	movzbl (%edi),%ecx
80104909:	38 d1                	cmp    %dl,%cl
8010490b:	75 2b                	jne    80104938 <memcmp+0x48>
8010490d:	b8 01 00 00 00       	mov    $0x1,%eax
80104912:	eb 14                	jmp    80104928 <memcmp+0x38>
80104914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104918:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010491c:	83 c0 01             	add    $0x1,%eax
8010491f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104924:	38 ca                	cmp    %cl,%dl
80104926:	75 10                	jne    80104938 <memcmp+0x48>
    while (n-- > 0) {
80104928:	39 d8                	cmp    %ebx,%eax
8010492a:	75 ec                	jne    80104918 <memcmp+0x28>
        }
        s1++, s2++;
    }

    return 0;
}
8010492c:	5b                   	pop    %ebx
    return 0;
8010492d:	31 c0                	xor    %eax,%eax
}
8010492f:	5e                   	pop    %esi
80104930:	5f                   	pop    %edi
80104931:	5d                   	pop    %ebp
80104932:	c3                   	ret    
80104933:	90                   	nop
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            return *s1 - *s2;
80104938:	0f b6 c2             	movzbl %dl,%eax
}
8010493b:	5b                   	pop    %ebx
            return *s1 - *s2;
8010493c:	29 c8                	sub    %ecx,%eax
}
8010493e:	5e                   	pop    %esi
8010493f:	5f                   	pop    %edi
80104940:	5d                   	pop    %ebp
80104941:	c3                   	ret    
80104942:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104950 <memmove>:

void* memmove(void *dst, const void *src, uint n) {
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	56                   	push   %esi
80104954:	53                   	push   %ebx
80104955:	8b 45 08             	mov    0x8(%ebp),%eax
80104958:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010495b:	8b 75 10             	mov    0x10(%ebp),%esi
    const char *s;
    char *d;

    s = src;
    d = dst;
    if (s < d && s + n > d) {
8010495e:	39 c3                	cmp    %eax,%ebx
80104960:	73 26                	jae    80104988 <memmove+0x38>
80104962:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104965:	39 c8                	cmp    %ecx,%eax
80104967:	73 1f                	jae    80104988 <memmove+0x38>
        s += n;
        d += n;
        while (n-- > 0) {
80104969:	85 f6                	test   %esi,%esi
8010496b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010496e:	74 0f                	je     8010497f <memmove+0x2f>
            *--d = *--s;
80104970:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104974:	88 0c 10             	mov    %cl,(%eax,%edx,1)
        while (n-- > 0) {
80104977:	83 ea 01             	sub    $0x1,%edx
8010497a:	83 fa ff             	cmp    $0xffffffff,%edx
8010497d:	75 f1                	jne    80104970 <memmove+0x20>
            *d++ = *s++;
        }
    }

    return dst;
}
8010497f:	5b                   	pop    %ebx
80104980:	5e                   	pop    %esi
80104981:	5d                   	pop    %ebp
80104982:	c3                   	ret    
80104983:	90                   	nop
80104984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        while (n-- > 0) {
80104988:	31 d2                	xor    %edx,%edx
8010498a:	85 f6                	test   %esi,%esi
8010498c:	74 f1                	je     8010497f <memmove+0x2f>
8010498e:	66 90                	xchg   %ax,%ax
            *d++ = *s++;
80104990:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104994:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104997:	83 c2 01             	add    $0x1,%edx
        while (n-- > 0) {
8010499a:	39 d6                	cmp    %edx,%esi
8010499c:	75 f2                	jne    80104990 <memmove+0x40>
}
8010499e:	5b                   	pop    %ebx
8010499f:	5e                   	pop    %esi
801049a0:	5d                   	pop    %ebp
801049a1:	c3                   	ret    
801049a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void* memcpy(void *dst, const void *src, uint n) {
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
    return memmove(dst, src, n);
}
801049b3:	5d                   	pop    %ebp
    return memmove(dst, src, n);
801049b4:	eb 9a                	jmp    80104950 <memmove>
801049b6:	8d 76 00             	lea    0x0(%esi),%esi
801049b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049c0 <strncmp>:

int strncmp(const char *p, const char *q, uint n) {
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	57                   	push   %edi
801049c4:	56                   	push   %esi
801049c5:	8b 7d 10             	mov    0x10(%ebp),%edi
801049c8:	53                   	push   %ebx
801049c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801049cc:	8b 75 0c             	mov    0xc(%ebp),%esi
    while (n > 0 && *p && *p == *q) {
801049cf:	85 ff                	test   %edi,%edi
801049d1:	74 2f                	je     80104a02 <strncmp+0x42>
801049d3:	0f b6 01             	movzbl (%ecx),%eax
801049d6:	0f b6 1e             	movzbl (%esi),%ebx
801049d9:	84 c0                	test   %al,%al
801049db:	74 37                	je     80104a14 <strncmp+0x54>
801049dd:	38 c3                	cmp    %al,%bl
801049df:	75 33                	jne    80104a14 <strncmp+0x54>
801049e1:	01 f7                	add    %esi,%edi
801049e3:	eb 13                	jmp    801049f8 <strncmp+0x38>
801049e5:	8d 76 00             	lea    0x0(%esi),%esi
801049e8:	0f b6 01             	movzbl (%ecx),%eax
801049eb:	84 c0                	test   %al,%al
801049ed:	74 21                	je     80104a10 <strncmp+0x50>
801049ef:	0f b6 1a             	movzbl (%edx),%ebx
801049f2:	89 d6                	mov    %edx,%esi
801049f4:	38 d8                	cmp    %bl,%al
801049f6:	75 1c                	jne    80104a14 <strncmp+0x54>
        n--, p++, q++;
801049f8:	8d 56 01             	lea    0x1(%esi),%edx
801049fb:	83 c1 01             	add    $0x1,%ecx
    while (n > 0 && *p && *p == *q) {
801049fe:	39 fa                	cmp    %edi,%edx
80104a00:	75 e6                	jne    801049e8 <strncmp+0x28>
    }
    if (n == 0) {
        return 0;
    }
    return (uchar) * p - (uchar) * q;
}
80104a02:	5b                   	pop    %ebx
        return 0;
80104a03:	31 c0                	xor    %eax,%eax
}
80104a05:	5e                   	pop    %esi
80104a06:	5f                   	pop    %edi
80104a07:	5d                   	pop    %ebp
80104a08:	c3                   	ret    
80104a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a10:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
    return (uchar) * p - (uchar) * q;
80104a14:	29 d8                	sub    %ebx,%eax
}
80104a16:	5b                   	pop    %ebx
80104a17:	5e                   	pop    %esi
80104a18:	5f                   	pop    %edi
80104a19:	5d                   	pop    %ebp
80104a1a:	c3                   	ret    
80104a1b:	90                   	nop
80104a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a20 <strncpy>:

char* strncpy(char *s, const char *t, int n) {
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
80104a25:	8b 45 08             	mov    0x8(%ebp),%eax
80104a28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104a2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
    char *os;

    os = s;
    while (n-- > 0 && (*s++ = *t++) != 0) {
80104a2e:	89 c2                	mov    %eax,%edx
80104a30:	eb 19                	jmp    80104a4b <strncpy+0x2b>
80104a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a38:	83 c3 01             	add    $0x1,%ebx
80104a3b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104a3f:	83 c2 01             	add    $0x1,%edx
80104a42:	84 c9                	test   %cl,%cl
80104a44:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a47:	74 09                	je     80104a52 <strncpy+0x32>
80104a49:	89 f1                	mov    %esi,%ecx
80104a4b:	85 c9                	test   %ecx,%ecx
80104a4d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104a50:	7f e6                	jg     80104a38 <strncpy+0x18>
        ;
    }
    while (n-- > 0) {
80104a52:	31 c9                	xor    %ecx,%ecx
80104a54:	85 f6                	test   %esi,%esi
80104a56:	7e 17                	jle    80104a6f <strncpy+0x4f>
80104a58:	90                   	nop
80104a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        *s++ = 0;
80104a60:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104a64:	89 f3                	mov    %esi,%ebx
80104a66:	83 c1 01             	add    $0x1,%ecx
80104a69:	29 cb                	sub    %ecx,%ebx
    while (n-- > 0) {
80104a6b:	85 db                	test   %ebx,%ebx
80104a6d:	7f f1                	jg     80104a60 <strncpy+0x40>
    }
    return os;
}
80104a6f:	5b                   	pop    %ebx
80104a70:	5e                   	pop    %esi
80104a71:	5d                   	pop    %ebp
80104a72:	c3                   	ret    
80104a73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a80 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char* safestrcpy(char *s, const char *t, int n) {
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	56                   	push   %esi
80104a84:	53                   	push   %ebx
80104a85:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a88:	8b 45 08             	mov    0x8(%ebp),%eax
80104a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
    char *os;

    os = s;
    if (n <= 0) {
80104a8e:	85 c9                	test   %ecx,%ecx
80104a90:	7e 26                	jle    80104ab8 <safestrcpy+0x38>
80104a92:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104a96:	89 c1                	mov    %eax,%ecx
80104a98:	eb 17                	jmp    80104ab1 <safestrcpy+0x31>
80104a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return os;
    }
    while (--n > 0 && (*s++ = *t++) != 0) {
80104aa0:	83 c2 01             	add    $0x1,%edx
80104aa3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104aa7:	83 c1 01             	add    $0x1,%ecx
80104aaa:	84 db                	test   %bl,%bl
80104aac:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104aaf:	74 04                	je     80104ab5 <safestrcpy+0x35>
80104ab1:	39 f2                	cmp    %esi,%edx
80104ab3:	75 eb                	jne    80104aa0 <safestrcpy+0x20>
        ;
    }
    *s = 0;
80104ab5:	c6 01 00             	movb   $0x0,(%ecx)
    return os;
}
80104ab8:	5b                   	pop    %ebx
80104ab9:	5e                   	pop    %esi
80104aba:	5d                   	pop    %ebp
80104abb:	c3                   	ret    
80104abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ac0 <strlen>:

int strlen(const char *s) {
80104ac0:	55                   	push   %ebp
    int n;

    for (n = 0; s[n]; n++) {
80104ac1:	31 c0                	xor    %eax,%eax
int strlen(const char *s) {
80104ac3:	89 e5                	mov    %esp,%ebp
80104ac5:	8b 55 08             	mov    0x8(%ebp),%edx
    for (n = 0; s[n]; n++) {
80104ac8:	80 3a 00             	cmpb   $0x0,(%edx)
80104acb:	74 0c                	je     80104ad9 <strlen+0x19>
80104acd:	8d 76 00             	lea    0x0(%esi),%esi
80104ad0:	83 c0 01             	add    $0x1,%eax
80104ad3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ad7:	75 f7                	jne    80104ad0 <strlen+0x10>
        ;
    }
    return n;
}
80104ad9:	5d                   	pop    %ebp
80104ada:	c3                   	ret    

80104adb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
    movl 4(%esp), %eax
80104adb:	8b 44 24 04          	mov    0x4(%esp),%eax
    movl 8(%esp), %edx
80104adf:	8b 54 24 08          	mov    0x8(%esp),%edx

    # Save old callee-saved registers
    pushl %ebp
80104ae3:	55                   	push   %ebp
    pushl %ebx
80104ae4:	53                   	push   %ebx
    pushl %esi
80104ae5:	56                   	push   %esi
    pushl %edi
80104ae6:	57                   	push   %edi

    # Switch stacks
    movl %esp, (%eax)
80104ae7:	89 20                	mov    %esp,(%eax)
    movl %edx, %esp
80104ae9:	89 d4                	mov    %edx,%esp

    # Load new callee-saved registers
    popl %edi
80104aeb:	5f                   	pop    %edi
    popl %esi
80104aec:	5e                   	pop    %esi
    popl %ebx
80104aed:	5b                   	pop    %ebx
    popl %ebp
80104aee:	5d                   	pop    %ebp
    ret
80104aef:	c3                   	ret    

80104af0 <fetchint>:
// Arguments on the stack, from the user call to the C
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int fetchint(uint addr, int *ip)  {
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	53                   	push   %ebx
80104af4:	83 ec 04             	sub    $0x4,%esp
80104af7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *curproc = myproc();
80104afa:	e8 31 f1 ff ff       	call   80103c30 <myproc>

    if (addr >= curproc->sz || addr + 4 > curproc->sz) {
80104aff:	8b 00                	mov    (%eax),%eax
80104b01:	39 d8                	cmp    %ebx,%eax
80104b03:	76 1b                	jbe    80104b20 <fetchint+0x30>
80104b05:	8d 53 04             	lea    0x4(%ebx),%edx
80104b08:	39 d0                	cmp    %edx,%eax
80104b0a:	72 14                	jb     80104b20 <fetchint+0x30>
        return -1;
    }
    *ip = *(int*)(addr);
80104b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b0f:	8b 13                	mov    (%ebx),%edx
80104b11:	89 10                	mov    %edx,(%eax)
    return 0;
80104b13:	31 c0                	xor    %eax,%eax
}
80104b15:	83 c4 04             	add    $0x4,%esp
80104b18:	5b                   	pop    %ebx
80104b19:	5d                   	pop    %ebp
80104b1a:	c3                   	ret    
80104b1b:	90                   	nop
80104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80104b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b25:	eb ee                	jmp    80104b15 <fetchint+0x25>
80104b27:	89 f6                	mov    %esi,%esi
80104b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b30 <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int fetchstr(uint addr, char **pp) {
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	53                   	push   %ebx
80104b34:	83 ec 04             	sub    $0x4,%esp
80104b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
    char *s, *ep;
    struct proc *curproc = myproc();
80104b3a:	e8 f1 f0 ff ff       	call   80103c30 <myproc>

    if (addr >= curproc->sz) {
80104b3f:	39 18                	cmp    %ebx,(%eax)
80104b41:	76 29                	jbe    80104b6c <fetchstr+0x3c>
        return -1;
    }
    *pp = (char*)addr;
80104b43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104b46:	89 da                	mov    %ebx,%edx
80104b48:	89 19                	mov    %ebx,(%ecx)
    ep = (char*)curproc->sz;
80104b4a:	8b 00                	mov    (%eax),%eax
    for (s = *pp; s < ep; s++) {
80104b4c:	39 c3                	cmp    %eax,%ebx
80104b4e:	73 1c                	jae    80104b6c <fetchstr+0x3c>
        if (*s == 0) {
80104b50:	80 3b 00             	cmpb   $0x0,(%ebx)
80104b53:	75 10                	jne    80104b65 <fetchstr+0x35>
80104b55:	eb 39                	jmp    80104b90 <fetchstr+0x60>
80104b57:	89 f6                	mov    %esi,%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104b60:	80 3a 00             	cmpb   $0x0,(%edx)
80104b63:	74 1b                	je     80104b80 <fetchstr+0x50>
    for (s = *pp; s < ep; s++) {
80104b65:	83 c2 01             	add    $0x1,%edx
80104b68:	39 d0                	cmp    %edx,%eax
80104b6a:	77 f4                	ja     80104b60 <fetchstr+0x30>
        return -1;
80104b6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
            return s - *pp;
        }
    }
    return -1;
}
80104b71:	83 c4 04             	add    $0x4,%esp
80104b74:	5b                   	pop    %ebx
80104b75:	5d                   	pop    %ebp
80104b76:	c3                   	ret    
80104b77:	89 f6                	mov    %esi,%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104b80:	83 c4 04             	add    $0x4,%esp
80104b83:	89 d0                	mov    %edx,%eax
80104b85:	29 d8                	sub    %ebx,%eax
80104b87:	5b                   	pop    %ebx
80104b88:	5d                   	pop    %ebp
80104b89:	c3                   	ret    
80104b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (*s == 0) {
80104b90:	31 c0                	xor    %eax,%eax
            return s - *pp;
80104b92:	eb dd                	jmp    80104b71 <fetchstr+0x41>
80104b94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104ba0 <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip) {
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	56                   	push   %esi
80104ba4:	53                   	push   %ebx
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104ba5:	e8 86 f0 ff ff       	call   80103c30 <myproc>
80104baa:	8b 40 18             	mov    0x18(%eax),%eax
80104bad:	8b 55 08             	mov    0x8(%ebp),%edx
80104bb0:	8b 40 44             	mov    0x44(%eax),%eax
80104bb3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    struct proc *curproc = myproc();
80104bb6:	e8 75 f0 ff ff       	call   80103c30 <myproc>
    if (addr >= curproc->sz || addr + 4 > curproc->sz) {
80104bbb:	8b 00                	mov    (%eax),%eax
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104bbd:	8d 73 04             	lea    0x4(%ebx),%esi
    if (addr >= curproc->sz || addr + 4 > curproc->sz) {
80104bc0:	39 c6                	cmp    %eax,%esi
80104bc2:	73 1c                	jae    80104be0 <argint+0x40>
80104bc4:	8d 53 08             	lea    0x8(%ebx),%edx
80104bc7:	39 d0                	cmp    %edx,%eax
80104bc9:	72 15                	jb     80104be0 <argint+0x40>
    *ip = *(int*)(addr);
80104bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bce:	8b 53 04             	mov    0x4(%ebx),%edx
80104bd1:	89 10                	mov    %edx,(%eax)
    return 0;
80104bd3:	31 c0                	xor    %eax,%eax
}
80104bd5:	5b                   	pop    %ebx
80104bd6:	5e                   	pop    %esi
80104bd7:	5d                   	pop    %ebp
80104bd8:	c3                   	ret    
80104bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80104be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80104be5:	eb ee                	jmp    80104bd5 <argint+0x35>
80104be7:	89 f6                	mov    %esi,%esi
80104be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bf0 <argptr>:

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int argptr(int n, char **pp, int size) {
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	53                   	push   %ebx
80104bf5:	83 ec 10             	sub    $0x10,%esp
80104bf8:	8b 5d 10             	mov    0x10(%ebp),%ebx
    int i;
    struct proc *curproc = myproc();
80104bfb:	e8 30 f0 ff ff       	call   80103c30 <myproc>
80104c00:	89 c6                	mov    %eax,%esi

    if (argint(n, &i) < 0) {
80104c02:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c05:	83 ec 08             	sub    $0x8,%esp
80104c08:	50                   	push   %eax
80104c09:	ff 75 08             	pushl  0x8(%ebp)
80104c0c:	e8 8f ff ff ff       	call   80104ba0 <argint>
        return -1;
    }
    if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz) {
80104c11:	83 c4 10             	add    $0x10,%esp
80104c14:	85 c0                	test   %eax,%eax
80104c16:	78 28                	js     80104c40 <argptr+0x50>
80104c18:	85 db                	test   %ebx,%ebx
80104c1a:	78 24                	js     80104c40 <argptr+0x50>
80104c1c:	8b 16                	mov    (%esi),%edx
80104c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c21:	39 c2                	cmp    %eax,%edx
80104c23:	76 1b                	jbe    80104c40 <argptr+0x50>
80104c25:	01 c3                	add    %eax,%ebx
80104c27:	39 da                	cmp    %ebx,%edx
80104c29:	72 15                	jb     80104c40 <argptr+0x50>
        return -1;
    }
    *pp = (char*)i;
80104c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c2e:	89 02                	mov    %eax,(%edx)
    return 0;
80104c30:	31 c0                	xor    %eax,%eax
}
80104c32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c35:	5b                   	pop    %ebx
80104c36:	5e                   	pop    %esi
80104c37:	5d                   	pop    %ebp
80104c38:	c3                   	ret    
80104c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80104c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c45:	eb eb                	jmp    80104c32 <argptr+0x42>
80104c47:	89 f6                	mov    %esi,%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c50 <argstr>:

// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int argstr(int n, char **pp) {
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	83 ec 20             	sub    $0x20,%esp
    int addr;
    if (argint(n, &addr) < 0) {
80104c56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c59:	50                   	push   %eax
80104c5a:	ff 75 08             	pushl  0x8(%ebp)
80104c5d:	e8 3e ff ff ff       	call   80104ba0 <argint>
80104c62:	83 c4 10             	add    $0x10,%esp
80104c65:	85 c0                	test   %eax,%eax
80104c67:	78 17                	js     80104c80 <argstr+0x30>
        return -1;
    }
    return fetchstr(addr, pp);
80104c69:	83 ec 08             	sub    $0x8,%esp
80104c6c:	ff 75 0c             	pushl  0xc(%ebp)
80104c6f:	ff 75 f4             	pushl  -0xc(%ebp)
80104c72:	e8 b9 fe ff ff       	call   80104b30 <fetchstr>
80104c77:	83 c4 10             	add    $0x10,%esp
}
80104c7a:	c9                   	leave  
80104c7b:	c3                   	ret    
80104c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80104c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c85:	c9                   	leave  
80104c86:	c3                   	ret    
80104c87:	89 f6                	mov    %esi,%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c90 <syscall>:
    [SYS_setspecificpixel] sys_setspecificpixel,
    [SYS_setpixel] sys_setpixel,
    // TODO: Add your system call function to the OS syscall table.
};

void syscall(void) {
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	53                   	push   %ebx
80104c94:	83 ec 04             	sub    $0x4,%esp
    int num;
    struct proc *curproc = myproc();
80104c97:	e8 94 ef ff ff       	call   80103c30 <myproc>
80104c9c:	89 c3                	mov    %eax,%ebx

    num = curproc->tf->eax;
80104c9e:	8b 40 18             	mov    0x18(%eax),%eax
80104ca1:	8b 40 1c             	mov    0x1c(%eax),%eax
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ca4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ca7:	83 fa 1a             	cmp    $0x1a,%edx
80104caa:	77 1c                	ja     80104cc8 <syscall+0x38>
80104cac:	8b 14 85 e0 7a 10 80 	mov    -0x7fef8520(,%eax,4),%edx
80104cb3:	85 d2                	test   %edx,%edx
80104cb5:	74 11                	je     80104cc8 <syscall+0x38>
        curproc->tf->eax = syscalls[num]();
80104cb7:	ff d2                	call   *%edx
80104cb9:	8b 53 18             	mov    0x18(%ebx),%edx
80104cbc:	89 42 1c             	mov    %eax,0x1c(%edx)
    else {
        cprintf("%d %s: unknown sys call %d\n",
                curproc->pid, curproc->name, num);
        curproc->tf->eax = -1;
    }
}
80104cbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cc2:	c9                   	leave  
80104cc3:	c3                   	ret    
80104cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf("%d %s: unknown sys call %d\n",
80104cc8:	50                   	push   %eax
                curproc->pid, curproc->name, num);
80104cc9:	8d 43 6c             	lea    0x6c(%ebx),%eax
        cprintf("%d %s: unknown sys call %d\n",
80104ccc:	50                   	push   %eax
80104ccd:	ff 73 10             	pushl  0x10(%ebx)
80104cd0:	68 b1 7a 10 80       	push   $0x80107ab1
80104cd5:	e8 76 ba ff ff       	call   80100750 <cprintf>
        curproc->tf->eax = -1;
80104cda:	8b 43 18             	mov    0x18(%ebx),%eax
80104cdd:	83 c4 10             	add    $0x10,%esp
80104ce0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104ce7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cea:	c9                   	leave  
80104ceb:	c3                   	ret    
80104cec:	66 90                	xchg   %ax,%ax
80104cee:	66 90                	xchg   %ax,%ax

80104cf0 <create>:
    end_op();

    return 0;
}

static struct inode* create(char *path, short type, short major, short minor)  {
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	57                   	push   %edi
80104cf4:	56                   	push   %esi
80104cf5:	53                   	push   %ebx
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0) {
80104cf6:	8d 75 da             	lea    -0x26(%ebp),%esi
static struct inode* create(char *path, short type, short major, short minor)  {
80104cf9:	83 ec 34             	sub    $0x34,%esp
80104cfc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104cff:	8b 4d 08             	mov    0x8(%ebp),%ecx
    if ((dp = nameiparent(path, name)) == 0) {
80104d02:	56                   	push   %esi
80104d03:	50                   	push   %eax
static struct inode* create(char *path, short type, short major, short minor)  {
80104d04:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104d07:	89 4d cc             	mov    %ecx,-0x34(%ebp)
    if ((dp = nameiparent(path, name)) == 0) {
80104d0a:	e8 11 d6 ff ff       	call   80102320 <nameiparent>
80104d0f:	83 c4 10             	add    $0x10,%esp
80104d12:	85 c0                	test   %eax,%eax
80104d14:	0f 84 46 01 00 00    	je     80104e60 <create+0x170>
        return 0;
    }
    ilock(dp);
80104d1a:	83 ec 0c             	sub    $0xc,%esp
80104d1d:	89 c3                	mov    %eax,%ebx
80104d1f:	50                   	push   %eax
80104d20:	e8 7b cd ff ff       	call   80101aa0 <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0) {
80104d25:	83 c4 0c             	add    $0xc,%esp
80104d28:	6a 00                	push   $0x0
80104d2a:	56                   	push   %esi
80104d2b:	53                   	push   %ebx
80104d2c:	e8 9f d2 ff ff       	call   80101fd0 <dirlookup>
80104d31:	83 c4 10             	add    $0x10,%esp
80104d34:	85 c0                	test   %eax,%eax
80104d36:	89 c7                	mov    %eax,%edi
80104d38:	74 36                	je     80104d70 <create+0x80>
        iunlockput(dp);
80104d3a:	83 ec 0c             	sub    $0xc,%esp
80104d3d:	53                   	push   %ebx
80104d3e:	e8 ed cf ff ff       	call   80101d30 <iunlockput>
        ilock(ip);
80104d43:	89 3c 24             	mov    %edi,(%esp)
80104d46:	e8 55 cd ff ff       	call   80101aa0 <ilock>
        if (type == T_FILE && ip->type == T_FILE) {
80104d4b:	83 c4 10             	add    $0x10,%esp
80104d4e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d53:	0f 85 97 00 00 00    	jne    80104df0 <create+0x100>
80104d59:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104d5e:	0f 85 8c 00 00 00    	jne    80104df0 <create+0x100>
    }

    iunlockput(dp);

    return ip;
}
80104d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d67:	89 f8                	mov    %edi,%eax
80104d69:	5b                   	pop    %ebx
80104d6a:	5e                   	pop    %esi
80104d6b:	5f                   	pop    %edi
80104d6c:	5d                   	pop    %ebp
80104d6d:	c3                   	ret    
80104d6e:	66 90                	xchg   %ax,%ax
    if ((ip = ialloc(dp->dev, type)) == 0) {
80104d70:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d74:	83 ec 08             	sub    $0x8,%esp
80104d77:	50                   	push   %eax
80104d78:	ff 33                	pushl  (%ebx)
80104d7a:	e8 b1 cb ff ff       	call   80101930 <ialloc>
80104d7f:	83 c4 10             	add    $0x10,%esp
80104d82:	85 c0                	test   %eax,%eax
80104d84:	89 c7                	mov    %eax,%edi
80104d86:	0f 84 e8 00 00 00    	je     80104e74 <create+0x184>
    ilock(ip);
80104d8c:	83 ec 0c             	sub    $0xc,%esp
80104d8f:	50                   	push   %eax
80104d90:	e8 0b cd ff ff       	call   80101aa0 <ilock>
    ip->major = major;
80104d95:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d99:	66 89 47 52          	mov    %ax,0x52(%edi)
    ip->minor = minor;
80104d9d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104da1:	66 89 47 54          	mov    %ax,0x54(%edi)
    ip->nlink = 1;
80104da5:	b8 01 00 00 00       	mov    $0x1,%eax
80104daa:	66 89 47 56          	mov    %ax,0x56(%edi)
    iupdate(ip);
80104dae:	89 3c 24             	mov    %edi,(%esp)
80104db1:	e8 3a cc ff ff       	call   801019f0 <iupdate>
    if (type == T_DIR) { // Create . and .. entries.
80104db6:	83 c4 10             	add    $0x10,%esp
80104db9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104dbe:	74 50                	je     80104e10 <create+0x120>
    if (dirlink(dp, name, ip->inum) < 0) {
80104dc0:	83 ec 04             	sub    $0x4,%esp
80104dc3:	ff 77 04             	pushl  0x4(%edi)
80104dc6:	56                   	push   %esi
80104dc7:	53                   	push   %ebx
80104dc8:	e8 73 d4 ff ff       	call   80102240 <dirlink>
80104dcd:	83 c4 10             	add    $0x10,%esp
80104dd0:	85 c0                	test   %eax,%eax
80104dd2:	0f 88 8f 00 00 00    	js     80104e67 <create+0x177>
    iunlockput(dp);
80104dd8:	83 ec 0c             	sub    $0xc,%esp
80104ddb:	53                   	push   %ebx
80104ddc:	e8 4f cf ff ff       	call   80101d30 <iunlockput>
    return ip;
80104de1:	83 c4 10             	add    $0x10,%esp
}
80104de4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104de7:	89 f8                	mov    %edi,%eax
80104de9:	5b                   	pop    %ebx
80104dea:	5e                   	pop    %esi
80104deb:	5f                   	pop    %edi
80104dec:	5d                   	pop    %ebp
80104ded:	c3                   	ret    
80104dee:	66 90                	xchg   %ax,%ax
        iunlockput(ip);
80104df0:	83 ec 0c             	sub    $0xc,%esp
80104df3:	57                   	push   %edi
        return 0;
80104df4:	31 ff                	xor    %edi,%edi
        iunlockput(ip);
80104df6:	e8 35 cf ff ff       	call   80101d30 <iunlockput>
        return 0;
80104dfb:	83 c4 10             	add    $0x10,%esp
}
80104dfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e01:	89 f8                	mov    %edi,%eax
80104e03:	5b                   	pop    %ebx
80104e04:	5e                   	pop    %esi
80104e05:	5f                   	pop    %edi
80104e06:	5d                   	pop    %ebp
80104e07:	c3                   	ret    
80104e08:	90                   	nop
80104e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        dp->nlink++;  // for ".."
80104e10:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
        iupdate(dp);
80104e15:	83 ec 0c             	sub    $0xc,%esp
80104e18:	53                   	push   %ebx
80104e19:	e8 d2 cb ff ff       	call   801019f0 <iupdate>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0) {
80104e1e:	83 c4 0c             	add    $0xc,%esp
80104e21:	ff 77 04             	pushl  0x4(%edi)
80104e24:	68 6c 7b 10 80       	push   $0x80107b6c
80104e29:	57                   	push   %edi
80104e2a:	e8 11 d4 ff ff       	call   80102240 <dirlink>
80104e2f:	83 c4 10             	add    $0x10,%esp
80104e32:	85 c0                	test   %eax,%eax
80104e34:	78 1c                	js     80104e52 <create+0x162>
80104e36:	83 ec 04             	sub    $0x4,%esp
80104e39:	ff 73 04             	pushl  0x4(%ebx)
80104e3c:	68 6b 7b 10 80       	push   $0x80107b6b
80104e41:	57                   	push   %edi
80104e42:	e8 f9 d3 ff ff       	call   80102240 <dirlink>
80104e47:	83 c4 10             	add    $0x10,%esp
80104e4a:	85 c0                	test   %eax,%eax
80104e4c:	0f 89 6e ff ff ff    	jns    80104dc0 <create+0xd0>
            panic("create dots");
80104e52:	83 ec 0c             	sub    $0xc,%esp
80104e55:	68 5f 7b 10 80       	push   $0x80107b5f
80104e5a:	e8 21 b6 ff ff       	call   80100480 <panic>
80104e5f:	90                   	nop
        return 0;
80104e60:	31 ff                	xor    %edi,%edi
80104e62:	e9 fd fe ff ff       	jmp    80104d64 <create+0x74>
        panic("create: dirlink");
80104e67:	83 ec 0c             	sub    $0xc,%esp
80104e6a:	68 6e 7b 10 80       	push   $0x80107b6e
80104e6f:	e8 0c b6 ff ff       	call   80100480 <panic>
        panic("create: ialloc");
80104e74:	83 ec 0c             	sub    $0xc,%esp
80104e77:	68 50 7b 10 80       	push   $0x80107b50
80104e7c:	e8 ff b5 ff ff       	call   80100480 <panic>
80104e81:	eb 0d                	jmp    80104e90 <argfd.constprop.0>
80104e83:	90                   	nop
80104e84:	90                   	nop
80104e85:	90                   	nop
80104e86:	90                   	nop
80104e87:	90                   	nop
80104e88:	90                   	nop
80104e89:	90                   	nop
80104e8a:	90                   	nop
80104e8b:	90                   	nop
80104e8c:	90                   	nop
80104e8d:	90                   	nop
80104e8e:	90                   	nop
80104e8f:	90                   	nop

80104e90 <argfd.constprop.0>:
static int argfd(int n, int *pfd, struct file **pf) {
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
80104e95:	89 c3                	mov    %eax,%ebx
    if (argint(n, &fd) < 0) {
80104e97:	8d 45 f4             	lea    -0xc(%ebp),%eax
static int argfd(int n, int *pfd, struct file **pf) {
80104e9a:	89 d6                	mov    %edx,%esi
80104e9c:	83 ec 18             	sub    $0x18,%esp
    if (argint(n, &fd) < 0) {
80104e9f:	50                   	push   %eax
80104ea0:	6a 00                	push   $0x0
80104ea2:	e8 f9 fc ff ff       	call   80104ba0 <argint>
80104ea7:	83 c4 10             	add    $0x10,%esp
80104eaa:	85 c0                	test   %eax,%eax
80104eac:	78 2a                	js     80104ed8 <argfd.constprop.0+0x48>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0) {
80104eae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104eb2:	77 24                	ja     80104ed8 <argfd.constprop.0+0x48>
80104eb4:	e8 77 ed ff ff       	call   80103c30 <myproc>
80104eb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ebc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104ec0:	85 c0                	test   %eax,%eax
80104ec2:	74 14                	je     80104ed8 <argfd.constprop.0+0x48>
    if (pfd) {
80104ec4:	85 db                	test   %ebx,%ebx
80104ec6:	74 02                	je     80104eca <argfd.constprop.0+0x3a>
        *pfd = fd;
80104ec8:	89 13                	mov    %edx,(%ebx)
        *pf = f;
80104eca:	89 06                	mov    %eax,(%esi)
    return 0;
80104ecc:	31 c0                	xor    %eax,%eax
}
80104ece:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ed1:	5b                   	pop    %ebx
80104ed2:	5e                   	pop    %esi
80104ed3:	5d                   	pop    %ebp
80104ed4:	c3                   	ret    
80104ed5:	8d 76 00             	lea    0x0(%esi),%esi
        return -1;
80104ed8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104edd:	eb ef                	jmp    80104ece <argfd.constprop.0+0x3e>
80104edf:	90                   	nop

80104ee0 <sys_dup>:
int sys_dup(void) {
80104ee0:	55                   	push   %ebp
    if (argfd(0, 0, &f) < 0) {
80104ee1:	31 c0                	xor    %eax,%eax
int sys_dup(void) {
80104ee3:	89 e5                	mov    %esp,%ebp
80104ee5:	56                   	push   %esi
80104ee6:	53                   	push   %ebx
    if (argfd(0, 0, &f) < 0) {
80104ee7:	8d 55 f4             	lea    -0xc(%ebp),%edx
int sys_dup(void) {
80104eea:	83 ec 10             	sub    $0x10,%esp
    if (argfd(0, 0, &f) < 0) {
80104eed:	e8 9e ff ff ff       	call   80104e90 <argfd.constprop.0>
80104ef2:	85 c0                	test   %eax,%eax
80104ef4:	78 42                	js     80104f38 <sys_dup+0x58>
    if ((fd = fdalloc(f)) < 0) {
80104ef6:	8b 75 f4             	mov    -0xc(%ebp),%esi
    for (fd = 0; fd < NOFILE; fd++) {
80104ef9:	31 db                	xor    %ebx,%ebx
    struct proc *curproc = myproc();
80104efb:	e8 30 ed ff ff       	call   80103c30 <myproc>
80104f00:	eb 0e                	jmp    80104f10 <sys_dup+0x30>
80104f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (fd = 0; fd < NOFILE; fd++) {
80104f08:	83 c3 01             	add    $0x1,%ebx
80104f0b:	83 fb 10             	cmp    $0x10,%ebx
80104f0e:	74 28                	je     80104f38 <sys_dup+0x58>
        if (curproc->ofile[fd] == 0) {
80104f10:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f14:	85 d2                	test   %edx,%edx
80104f16:	75 f0                	jne    80104f08 <sys_dup+0x28>
            curproc->ofile[fd] = f;
80104f18:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    filedup(f);
80104f1c:	83 ec 0c             	sub    $0xc,%esp
80104f1f:	ff 75 f4             	pushl  -0xc(%ebp)
80104f22:	e8 e9 c2 ff ff       	call   80101210 <filedup>
    return fd;
80104f27:	83 c4 10             	add    $0x10,%esp
}
80104f2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f2d:	89 d8                	mov    %ebx,%eax
80104f2f:	5b                   	pop    %ebx
80104f30:	5e                   	pop    %esi
80104f31:	5d                   	pop    %ebp
80104f32:	c3                   	ret    
80104f33:	90                   	nop
80104f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f38:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return -1;
80104f3b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f40:	89 d8                	mov    %ebx,%eax
80104f42:	5b                   	pop    %ebx
80104f43:	5e                   	pop    %esi
80104f44:	5d                   	pop    %ebp
80104f45:	c3                   	ret    
80104f46:	8d 76 00             	lea    0x0(%esi),%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f50 <sys_read>:
int sys_read(void) {
80104f50:	55                   	push   %ebp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) {
80104f51:	31 c0                	xor    %eax,%eax
int sys_read(void) {
80104f53:	89 e5                	mov    %esp,%ebp
80104f55:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) {
80104f58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104f5b:	e8 30 ff ff ff       	call   80104e90 <argfd.constprop.0>
80104f60:	85 c0                	test   %eax,%eax
80104f62:	78 4c                	js     80104fb0 <sys_read+0x60>
80104f64:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f67:	83 ec 08             	sub    $0x8,%esp
80104f6a:	50                   	push   %eax
80104f6b:	6a 02                	push   $0x2
80104f6d:	e8 2e fc ff ff       	call   80104ba0 <argint>
80104f72:	83 c4 10             	add    $0x10,%esp
80104f75:	85 c0                	test   %eax,%eax
80104f77:	78 37                	js     80104fb0 <sys_read+0x60>
80104f79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f7c:	83 ec 04             	sub    $0x4,%esp
80104f7f:	ff 75 f0             	pushl  -0x10(%ebp)
80104f82:	50                   	push   %eax
80104f83:	6a 01                	push   $0x1
80104f85:	e8 66 fc ff ff       	call   80104bf0 <argptr>
80104f8a:	83 c4 10             	add    $0x10,%esp
80104f8d:	85 c0                	test   %eax,%eax
80104f8f:	78 1f                	js     80104fb0 <sys_read+0x60>
    return fileread(f, p, n);
80104f91:	83 ec 04             	sub    $0x4,%esp
80104f94:	ff 75 f0             	pushl  -0x10(%ebp)
80104f97:	ff 75 f4             	pushl  -0xc(%ebp)
80104f9a:	ff 75 ec             	pushl  -0x14(%ebp)
80104f9d:	e8 de c3 ff ff       	call   80101380 <fileread>
80104fa2:	83 c4 10             	add    $0x10,%esp
}
80104fa5:	c9                   	leave  
80104fa6:	c3                   	ret    
80104fa7:	89 f6                	mov    %esi,%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return -1;
80104fb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fb5:	c9                   	leave  
80104fb6:	c3                   	ret    
80104fb7:	89 f6                	mov    %esi,%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fc0 <sys_write>:
int sys_write(void) {
80104fc0:	55                   	push   %ebp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) {
80104fc1:	31 c0                	xor    %eax,%eax
int sys_write(void) {
80104fc3:	89 e5                	mov    %esp,%ebp
80104fc5:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0) {
80104fc8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104fcb:	e8 c0 fe ff ff       	call   80104e90 <argfd.constprop.0>
80104fd0:	85 c0                	test   %eax,%eax
80104fd2:	78 4c                	js     80105020 <sys_write+0x60>
80104fd4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fd7:	83 ec 08             	sub    $0x8,%esp
80104fda:	50                   	push   %eax
80104fdb:	6a 02                	push   $0x2
80104fdd:	e8 be fb ff ff       	call   80104ba0 <argint>
80104fe2:	83 c4 10             	add    $0x10,%esp
80104fe5:	85 c0                	test   %eax,%eax
80104fe7:	78 37                	js     80105020 <sys_write+0x60>
80104fe9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fec:	83 ec 04             	sub    $0x4,%esp
80104fef:	ff 75 f0             	pushl  -0x10(%ebp)
80104ff2:	50                   	push   %eax
80104ff3:	6a 01                	push   $0x1
80104ff5:	e8 f6 fb ff ff       	call   80104bf0 <argptr>
80104ffa:	83 c4 10             	add    $0x10,%esp
80104ffd:	85 c0                	test   %eax,%eax
80104fff:	78 1f                	js     80105020 <sys_write+0x60>
    return filewrite(f, p, n);
80105001:	83 ec 04             	sub    $0x4,%esp
80105004:	ff 75 f0             	pushl  -0x10(%ebp)
80105007:	ff 75 f4             	pushl  -0xc(%ebp)
8010500a:	ff 75 ec             	pushl  -0x14(%ebp)
8010500d:	e8 fe c3 ff ff       	call   80101410 <filewrite>
80105012:	83 c4 10             	add    $0x10,%esp
}
80105015:	c9                   	leave  
80105016:	c3                   	ret    
80105017:	89 f6                	mov    %esi,%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return -1;
80105020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105025:	c9                   	leave  
80105026:	c3                   	ret    
80105027:	89 f6                	mov    %esi,%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105030 <sys_close>:
int sys_close(void) {
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, &fd, &f) < 0) {
80105036:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105039:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010503c:	e8 4f fe ff ff       	call   80104e90 <argfd.constprop.0>
80105041:	85 c0                	test   %eax,%eax
80105043:	78 2b                	js     80105070 <sys_close+0x40>
    myproc()->ofile[fd] = 0;
80105045:	e8 e6 eb ff ff       	call   80103c30 <myproc>
8010504a:	8b 55 f0             	mov    -0x10(%ebp),%edx
    fileclose(f);
8010504d:	83 ec 0c             	sub    $0xc,%esp
    myproc()->ofile[fd] = 0;
80105050:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105057:	00 
    fileclose(f);
80105058:	ff 75 f4             	pushl  -0xc(%ebp)
8010505b:	e8 00 c2 ff ff       	call   80101260 <fileclose>
    return 0;
80105060:	83 c4 10             	add    $0x10,%esp
80105063:	31 c0                	xor    %eax,%eax
}
80105065:	c9                   	leave  
80105066:	c3                   	ret    
80105067:	89 f6                	mov    %esi,%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return -1;
80105070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105075:	c9                   	leave  
80105076:	c3                   	ret    
80105077:	89 f6                	mov    %esi,%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105080 <sys_fstat>:
int sys_fstat(void) {
80105080:	55                   	push   %ebp
    if (argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0) {
80105081:	31 c0                	xor    %eax,%eax
int sys_fstat(void) {
80105083:	89 e5                	mov    %esp,%ebp
80105085:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0) {
80105088:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010508b:	e8 00 fe ff ff       	call   80104e90 <argfd.constprop.0>
80105090:	85 c0                	test   %eax,%eax
80105092:	78 2c                	js     801050c0 <sys_fstat+0x40>
80105094:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105097:	83 ec 04             	sub    $0x4,%esp
8010509a:	6a 14                	push   $0x14
8010509c:	50                   	push   %eax
8010509d:	6a 01                	push   $0x1
8010509f:	e8 4c fb ff ff       	call   80104bf0 <argptr>
801050a4:	83 c4 10             	add    $0x10,%esp
801050a7:	85 c0                	test   %eax,%eax
801050a9:	78 15                	js     801050c0 <sys_fstat+0x40>
    return filestat(f, st);
801050ab:	83 ec 08             	sub    $0x8,%esp
801050ae:	ff 75 f4             	pushl  -0xc(%ebp)
801050b1:	ff 75 f0             	pushl  -0x10(%ebp)
801050b4:	e8 77 c2 ff ff       	call   80101330 <filestat>
801050b9:	83 c4 10             	add    $0x10,%esp
}
801050bc:	c9                   	leave  
801050bd:	c3                   	ret    
801050be:	66 90                	xchg   %ax,%ax
        return -1;
801050c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050c5:	c9                   	leave  
801050c6:	c3                   	ret    
801050c7:	89 f6                	mov    %esi,%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050d0 <cleanupsyslink>:
void cleanupsyslink(struct inode * ip) {
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	53                   	push   %ebx
801050d4:	83 ec 10             	sub    $0x10,%esp
801050d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    ilock(ip);
801050da:	53                   	push   %ebx
801050db:	e8 c0 c9 ff ff       	call   80101aa0 <ilock>
    ip->nlink--;
801050e0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
    iupdate(ip);
801050e5:	89 1c 24             	mov    %ebx,(%esp)
801050e8:	e8 03 c9 ff ff       	call   801019f0 <iupdate>
    iunlockput(ip);
801050ed:	89 1c 24             	mov    %ebx,(%esp)
801050f0:	e8 3b cc ff ff       	call   80101d30 <iunlockput>
    end_op();
801050f5:	83 c4 10             	add    $0x10,%esp
}
801050f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050fb:	c9                   	leave  
    end_op();
801050fc:	e9 2f df ff ff       	jmp    80103030 <end_op>
80105101:	eb 0d                	jmp    80105110 <sys_link>
80105103:	90                   	nop
80105104:	90                   	nop
80105105:	90                   	nop
80105106:	90                   	nop
80105107:	90                   	nop
80105108:	90                   	nop
80105109:	90                   	nop
8010510a:	90                   	nop
8010510b:	90                   	nop
8010510c:	90                   	nop
8010510d:	90                   	nop
8010510e:	90                   	nop
8010510f:	90                   	nop

80105110 <sys_link>:
int sys_link(void) {
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	57                   	push   %edi
80105114:	56                   	push   %esi
80105115:	53                   	push   %ebx
    if (argstr(0, &old) < 0 || argstr(1, &new) < 0) {
80105116:	8d 45 d4             	lea    -0x2c(%ebp),%eax
int sys_link(void) {
80105119:	83 ec 34             	sub    $0x34,%esp
    if (argstr(0, &old) < 0 || argstr(1, &new) < 0) {
8010511c:	50                   	push   %eax
8010511d:	6a 00                	push   $0x0
8010511f:	e8 2c fb ff ff       	call   80104c50 <argstr>
80105124:	83 c4 10             	add    $0x10,%esp
80105127:	85 c0                	test   %eax,%eax
80105129:	0f 88 f1 00 00 00    	js     80105220 <sys_link+0x110>
8010512f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105132:	83 ec 08             	sub    $0x8,%esp
80105135:	50                   	push   %eax
80105136:	6a 01                	push   $0x1
80105138:	e8 13 fb ff ff       	call   80104c50 <argstr>
8010513d:	83 c4 10             	add    $0x10,%esp
80105140:	85 c0                	test   %eax,%eax
80105142:	0f 88 d8 00 00 00    	js     80105220 <sys_link+0x110>
    begin_op();
80105148:	e8 73 de ff ff       	call   80102fc0 <begin_op>
    if ((ip = namei(old)) == 0) {
8010514d:	83 ec 0c             	sub    $0xc,%esp
80105150:	ff 75 d4             	pushl  -0x2c(%ebp)
80105153:	e8 a8 d1 ff ff       	call   80102300 <namei>
80105158:	83 c4 10             	add    $0x10,%esp
8010515b:	85 c0                	test   %eax,%eax
8010515d:	89 c3                	mov    %eax,%ebx
8010515f:	0f 84 da 00 00 00    	je     8010523f <sys_link+0x12f>
    ilock(ip);
80105165:	83 ec 0c             	sub    $0xc,%esp
80105168:	50                   	push   %eax
80105169:	e8 32 c9 ff ff       	call   80101aa0 <ilock>
    if (ip->type == T_DIR) {
8010516e:	83 c4 10             	add    $0x10,%esp
80105171:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105176:	0f 84 ab 00 00 00    	je     80105227 <sys_link+0x117>
    ip->nlink++;
8010517c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(ip);
80105181:	83 ec 0c             	sub    $0xc,%esp
    if ((dp = nameiparent(new, name)) == 0) {
80105184:	8d 7d da             	lea    -0x26(%ebp),%edi
    iupdate(ip);
80105187:	53                   	push   %ebx
80105188:	e8 63 c8 ff ff       	call   801019f0 <iupdate>
    iunlock(ip);
8010518d:	89 1c 24             	mov    %ebx,(%esp)
80105190:	e8 eb c9 ff ff       	call   80101b80 <iunlock>
    if ((dp = nameiparent(new, name)) == 0) {
80105195:	58                   	pop    %eax
80105196:	5a                   	pop    %edx
80105197:	57                   	push   %edi
80105198:	ff 75 d0             	pushl  -0x30(%ebp)
8010519b:	e8 80 d1 ff ff       	call   80102320 <nameiparent>
801051a0:	83 c4 10             	add    $0x10,%esp
801051a3:	85 c0                	test   %eax,%eax
801051a5:	89 c6                	mov    %eax,%esi
801051a7:	74 6a                	je     80105213 <sys_link+0x103>
    ilock(dp);
801051a9:	83 ec 0c             	sub    $0xc,%esp
801051ac:	50                   	push   %eax
801051ad:	e8 ee c8 ff ff       	call   80101aa0 <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
801051b2:	83 c4 10             	add    $0x10,%esp
801051b5:	8b 03                	mov    (%ebx),%eax
801051b7:	39 06                	cmp    %eax,(%esi)
801051b9:	75 3d                	jne    801051f8 <sys_link+0xe8>
801051bb:	83 ec 04             	sub    $0x4,%esp
801051be:	ff 73 04             	pushl  0x4(%ebx)
801051c1:	57                   	push   %edi
801051c2:	56                   	push   %esi
801051c3:	e8 78 d0 ff ff       	call   80102240 <dirlink>
801051c8:	83 c4 10             	add    $0x10,%esp
801051cb:	85 c0                	test   %eax,%eax
801051cd:	78 29                	js     801051f8 <sys_link+0xe8>
    iunlockput(dp);
801051cf:	83 ec 0c             	sub    $0xc,%esp
801051d2:	56                   	push   %esi
801051d3:	e8 58 cb ff ff       	call   80101d30 <iunlockput>
    iput(ip);
801051d8:	89 1c 24             	mov    %ebx,(%esp)
801051db:	e8 f0 c9 ff ff       	call   80101bd0 <iput>
    end_op();
801051e0:	e8 4b de ff ff       	call   80103030 <end_op>
    return 0;
801051e5:	83 c4 10             	add    $0x10,%esp
801051e8:	31 c0                	xor    %eax,%eax
}
801051ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051ed:	5b                   	pop    %ebx
801051ee:	5e                   	pop    %esi
801051ef:	5f                   	pop    %edi
801051f0:	5d                   	pop    %ebp
801051f1:	c3                   	ret    
801051f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        iunlockput(dp);
801051f8:	83 ec 0c             	sub    $0xc,%esp
801051fb:	56                   	push   %esi
801051fc:	e8 2f cb ff ff       	call   80101d30 <iunlockput>
        cleanupsyslink(ip);
80105201:	89 1c 24             	mov    %ebx,(%esp)
80105204:	e8 c7 fe ff ff       	call   801050d0 <cleanupsyslink>
        return -1;
80105209:	83 c4 10             	add    $0x10,%esp
8010520c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105211:	eb d7                	jmp    801051ea <sys_link+0xda>
        cleanupsyslink(ip);
80105213:	83 ec 0c             	sub    $0xc,%esp
80105216:	53                   	push   %ebx
80105217:	e8 b4 fe ff ff       	call   801050d0 <cleanupsyslink>
        return -1;
8010521c:	83 c4 10             	add    $0x10,%esp
8010521f:	90                   	nop
80105220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105225:	eb c3                	jmp    801051ea <sys_link+0xda>
        iunlockput(ip);
80105227:	83 ec 0c             	sub    $0xc,%esp
8010522a:	53                   	push   %ebx
8010522b:	e8 00 cb ff ff       	call   80101d30 <iunlockput>
        end_op();
80105230:	e8 fb dd ff ff       	call   80103030 <end_op>
        return -1;
80105235:	83 c4 10             	add    $0x10,%esp
80105238:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010523d:	eb ab                	jmp    801051ea <sys_link+0xda>
        end_op();
8010523f:	e8 ec dd ff ff       	call   80103030 <end_op>
        return -1;
80105244:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105249:	eb 9f                	jmp    801051ea <sys_link+0xda>
8010524b:	90                   	nop
8010524c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105250 <sys_unlink>:
int sys_unlink(void) {
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	57                   	push   %edi
80105254:	56                   	push   %esi
80105255:	53                   	push   %ebx
    if (argstr(0, &path) < 0) {
80105256:	8d 45 c0             	lea    -0x40(%ebp),%eax
int sys_unlink(void) {
80105259:	83 ec 44             	sub    $0x44,%esp
    if (argstr(0, &path) < 0) {
8010525c:	50                   	push   %eax
8010525d:	6a 00                	push   $0x0
8010525f:	e8 ec f9 ff ff       	call   80104c50 <argstr>
80105264:	83 c4 10             	add    $0x10,%esp
80105267:	85 c0                	test   %eax,%eax
80105269:	0f 88 52 01 00 00    	js     801053c1 <sys_unlink+0x171>
    if ((dp = nameiparent(path, name)) == 0) {
8010526f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
    begin_op();
80105272:	e8 49 dd ff ff       	call   80102fc0 <begin_op>
    if ((dp = nameiparent(path, name)) == 0) {
80105277:	83 ec 08             	sub    $0x8,%esp
8010527a:	53                   	push   %ebx
8010527b:	ff 75 c0             	pushl  -0x40(%ebp)
8010527e:	e8 9d d0 ff ff       	call   80102320 <nameiparent>
80105283:	83 c4 10             	add    $0x10,%esp
80105286:	85 c0                	test   %eax,%eax
80105288:	89 c6                	mov    %eax,%esi
8010528a:	0f 84 7b 01 00 00    	je     8010540b <sys_unlink+0x1bb>
    ilock(dp);
80105290:	83 ec 0c             	sub    $0xc,%esp
80105293:	50                   	push   %eax
80105294:	e8 07 c8 ff ff       	call   80101aa0 <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0) {
80105299:	58                   	pop    %eax
8010529a:	5a                   	pop    %edx
8010529b:	68 6c 7b 10 80       	push   $0x80107b6c
801052a0:	53                   	push   %ebx
801052a1:	e8 0a cd ff ff       	call   80101fb0 <namecmp>
801052a6:	83 c4 10             	add    $0x10,%esp
801052a9:	85 c0                	test   %eax,%eax
801052ab:	0f 84 3f 01 00 00    	je     801053f0 <sys_unlink+0x1a0>
801052b1:	83 ec 08             	sub    $0x8,%esp
801052b4:	68 6b 7b 10 80       	push   $0x80107b6b
801052b9:	53                   	push   %ebx
801052ba:	e8 f1 cc ff ff       	call   80101fb0 <namecmp>
801052bf:	83 c4 10             	add    $0x10,%esp
801052c2:	85 c0                	test   %eax,%eax
801052c4:	0f 84 26 01 00 00    	je     801053f0 <sys_unlink+0x1a0>
    if ((ip = dirlookup(dp, name, &off)) == 0) {
801052ca:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801052cd:	83 ec 04             	sub    $0x4,%esp
801052d0:	50                   	push   %eax
801052d1:	53                   	push   %ebx
801052d2:	56                   	push   %esi
801052d3:	e8 f8 cc ff ff       	call   80101fd0 <dirlookup>
801052d8:	83 c4 10             	add    $0x10,%esp
801052db:	85 c0                	test   %eax,%eax
801052dd:	89 c3                	mov    %eax,%ebx
801052df:	0f 84 0b 01 00 00    	je     801053f0 <sys_unlink+0x1a0>
    ilock(ip);
801052e5:	83 ec 0c             	sub    $0xc,%esp
801052e8:	50                   	push   %eax
801052e9:	e8 b2 c7 ff ff       	call   80101aa0 <ilock>
    if (ip->nlink < 1) {
801052ee:	83 c4 10             	add    $0x10,%esp
801052f1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801052f6:	0f 8e 2b 01 00 00    	jle    80105427 <sys_unlink+0x1d7>
    if (ip->type == T_DIR && !isdirempty(ip)) {
801052fc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105301:	74 6d                	je     80105370 <sys_unlink+0x120>
    memset(&de, 0, sizeof(de));
80105303:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105306:	83 ec 04             	sub    $0x4,%esp
80105309:	6a 10                	push   $0x10
8010530b:	6a 00                	push   $0x0
8010530d:	50                   	push   %eax
8010530e:	e8 8d f5 ff ff       	call   801048a0 <memset>
    if (writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
80105313:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105316:	6a 10                	push   $0x10
80105318:	ff 75 c4             	pushl  -0x3c(%ebp)
8010531b:	50                   	push   %eax
8010531c:	56                   	push   %esi
8010531d:	e8 5e cb ff ff       	call   80101e80 <writei>
80105322:	83 c4 20             	add    $0x20,%esp
80105325:	83 f8 10             	cmp    $0x10,%eax
80105328:	0f 85 06 01 00 00    	jne    80105434 <sys_unlink+0x1e4>
    if (ip->type == T_DIR) {
8010532e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105333:	0f 84 97 00 00 00    	je     801053d0 <sys_unlink+0x180>
    iunlockput(dp);
80105339:	83 ec 0c             	sub    $0xc,%esp
8010533c:	56                   	push   %esi
8010533d:	e8 ee c9 ff ff       	call   80101d30 <iunlockput>
    ip->nlink--;
80105342:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
    iupdate(ip);
80105347:	89 1c 24             	mov    %ebx,(%esp)
8010534a:	e8 a1 c6 ff ff       	call   801019f0 <iupdate>
    iunlockput(ip);
8010534f:	89 1c 24             	mov    %ebx,(%esp)
80105352:	e8 d9 c9 ff ff       	call   80101d30 <iunlockput>
    end_op();
80105357:	e8 d4 dc ff ff       	call   80103030 <end_op>
    return 0;
8010535c:	83 c4 10             	add    $0x10,%esp
8010535f:	31 c0                	xor    %eax,%eax
}
80105361:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105364:	5b                   	pop    %ebx
80105365:	5e                   	pop    %esi
80105366:	5f                   	pop    %edi
80105367:	5d                   	pop    %ebp
80105368:	c3                   	ret    
80105369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
80105370:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105374:	76 8d                	jbe    80105303 <sys_unlink+0xb3>
80105376:	bf 20 00 00 00       	mov    $0x20,%edi
8010537b:	eb 0f                	jmp    8010538c <sys_unlink+0x13c>
8010537d:	8d 76 00             	lea    0x0(%esi),%esi
80105380:	83 c7 10             	add    $0x10,%edi
80105383:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105386:	0f 83 77 ff ff ff    	jae    80105303 <sys_unlink+0xb3>
        if (readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de)) {
8010538c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010538f:	6a 10                	push   $0x10
80105391:	57                   	push   %edi
80105392:	50                   	push   %eax
80105393:	53                   	push   %ebx
80105394:	e8 e7 c9 ff ff       	call   80101d80 <readi>
80105399:	83 c4 10             	add    $0x10,%esp
8010539c:	83 f8 10             	cmp    $0x10,%eax
8010539f:	75 79                	jne    8010541a <sys_unlink+0x1ca>
        if (de.inum != 0) {
801053a1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801053a6:	74 d8                	je     80105380 <sys_unlink+0x130>
        iunlockput(ip);
801053a8:	83 ec 0c             	sub    $0xc,%esp
801053ab:	53                   	push   %ebx
801053ac:	e8 7f c9 ff ff       	call   80101d30 <iunlockput>
        iunlockput(dp);
801053b1:	89 34 24             	mov    %esi,(%esp)
801053b4:	e8 77 c9 ff ff       	call   80101d30 <iunlockput>
        end_op();
801053b9:	e8 72 dc ff ff       	call   80103030 <end_op>
        return -1;       
801053be:	83 c4 10             	add    $0x10,%esp
}
801053c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;       
801053c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053c9:	5b                   	pop    %ebx
801053ca:	5e                   	pop    %esi
801053cb:	5f                   	pop    %edi
801053cc:	5d                   	pop    %ebp
801053cd:	c3                   	ret    
801053ce:	66 90                	xchg   %ax,%ax
        dp->nlink--;
801053d0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
        iupdate(dp);
801053d5:	83 ec 0c             	sub    $0xc,%esp
801053d8:	56                   	push   %esi
801053d9:	e8 12 c6 ff ff       	call   801019f0 <iupdate>
801053de:	83 c4 10             	add    $0x10,%esp
801053e1:	e9 53 ff ff ff       	jmp    80105339 <sys_unlink+0xe9>
801053e6:	8d 76 00             	lea    0x0(%esi),%esi
801053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        iunlockput(dp);
801053f0:	83 ec 0c             	sub    $0xc,%esp
801053f3:	56                   	push   %esi
801053f4:	e8 37 c9 ff ff       	call   80101d30 <iunlockput>
        end_op();
801053f9:	e8 32 dc ff ff       	call   80103030 <end_op>
        return -1;       
801053fe:	83 c4 10             	add    $0x10,%esp
80105401:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105406:	e9 56 ff ff ff       	jmp    80105361 <sys_unlink+0x111>
        end_op();
8010540b:	e8 20 dc ff ff       	call   80103030 <end_op>
        return -1;
80105410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105415:	e9 47 ff ff ff       	jmp    80105361 <sys_unlink+0x111>
            panic("isdirempty: readi");
8010541a:	83 ec 0c             	sub    $0xc,%esp
8010541d:	68 90 7b 10 80       	push   $0x80107b90
80105422:	e8 59 b0 ff ff       	call   80100480 <panic>
        panic("unlink: nlink < 1");
80105427:	83 ec 0c             	sub    $0xc,%esp
8010542a:	68 7e 7b 10 80       	push   $0x80107b7e
8010542f:	e8 4c b0 ff ff       	call   80100480 <panic>
        panic("unlink: writei");
80105434:	83 ec 0c             	sub    $0xc,%esp
80105437:	68 a2 7b 10 80       	push   $0x80107ba2
8010543c:	e8 3f b0 ff ff       	call   80100480 <panic>
80105441:	eb 0d                	jmp    80105450 <sys_open>
80105443:	90                   	nop
80105444:	90                   	nop
80105445:	90                   	nop
80105446:	90                   	nop
80105447:	90                   	nop
80105448:	90                   	nop
80105449:	90                   	nop
8010544a:	90                   	nop
8010544b:	90                   	nop
8010544c:	90                   	nop
8010544d:	90                   	nop
8010544e:	90                   	nop
8010544f:	90                   	nop

80105450 <sys_open>:

int sys_open(void) {
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	57                   	push   %edi
80105454:	56                   	push   %esi
80105455:	53                   	push   %ebx
    char *path;
    int fd, omode;
    struct file *f;
    struct inode *ip;

    if (argstr(0, &path) < 0 || argint(1, &omode) < 0) {
80105456:	8d 45 e0             	lea    -0x20(%ebp),%eax
int sys_open(void) {
80105459:	83 ec 24             	sub    $0x24,%esp
    if (argstr(0, &path) < 0 || argint(1, &omode) < 0) {
8010545c:	50                   	push   %eax
8010545d:	6a 00                	push   $0x0
8010545f:	e8 ec f7 ff ff       	call   80104c50 <argstr>
80105464:	83 c4 10             	add    $0x10,%esp
80105467:	85 c0                	test   %eax,%eax
80105469:	0f 88 1d 01 00 00    	js     8010558c <sys_open+0x13c>
8010546f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105472:	83 ec 08             	sub    $0x8,%esp
80105475:	50                   	push   %eax
80105476:	6a 01                	push   $0x1
80105478:	e8 23 f7 ff ff       	call   80104ba0 <argint>
8010547d:	83 c4 10             	add    $0x10,%esp
80105480:	85 c0                	test   %eax,%eax
80105482:	0f 88 04 01 00 00    	js     8010558c <sys_open+0x13c>
        return -1;
    }

    begin_op();
80105488:	e8 33 db ff ff       	call   80102fc0 <begin_op>

    if (omode & O_CREATE) {
8010548d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105491:	0f 85 a9 00 00 00    	jne    80105540 <sys_open+0xf0>
            end_op();
            return -1;
        }
    }
    else {
        if ((ip = namei(path)) == 0) {
80105497:	83 ec 0c             	sub    $0xc,%esp
8010549a:	ff 75 e0             	pushl  -0x20(%ebp)
8010549d:	e8 5e ce ff ff       	call   80102300 <namei>
801054a2:	83 c4 10             	add    $0x10,%esp
801054a5:	85 c0                	test   %eax,%eax
801054a7:	89 c6                	mov    %eax,%esi
801054a9:	0f 84 b2 00 00 00    	je     80105561 <sys_open+0x111>
            end_op();
            return -1;
        }
        ilock(ip);
801054af:	83 ec 0c             	sub    $0xc,%esp
801054b2:	50                   	push   %eax
801054b3:	e8 e8 c5 ff ff       	call   80101aa0 <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY) {
801054b8:	83 c4 10             	add    $0x10,%esp
801054bb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801054c0:	0f 84 aa 00 00 00    	je     80105570 <sys_open+0x120>
            end_op();
            return -1;
        }
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
801054c6:	e8 d5 bc ff ff       	call   801011a0 <filealloc>
801054cb:	85 c0                	test   %eax,%eax
801054cd:	89 c7                	mov    %eax,%edi
801054cf:	0f 84 a6 00 00 00    	je     8010557b <sys_open+0x12b>
    struct proc *curproc = myproc();
801054d5:	e8 56 e7 ff ff       	call   80103c30 <myproc>
    for (fd = 0; fd < NOFILE; fd++) {
801054da:	31 db                	xor    %ebx,%ebx
801054dc:	eb 0e                	jmp    801054ec <sys_open+0x9c>
801054de:	66 90                	xchg   %ax,%ax
801054e0:	83 c3 01             	add    $0x1,%ebx
801054e3:	83 fb 10             	cmp    $0x10,%ebx
801054e6:	0f 84 ac 00 00 00    	je     80105598 <sys_open+0x148>
        if (curproc->ofile[fd] == 0) {
801054ec:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801054f0:	85 d2                	test   %edx,%edx
801054f2:	75 ec                	jne    801054e0 <sys_open+0x90>
        }
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
801054f4:	83 ec 0c             	sub    $0xc,%esp
            curproc->ofile[fd] = f;
801054f7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
    iunlock(ip);
801054fb:	56                   	push   %esi
801054fc:	e8 7f c6 ff ff       	call   80101b80 <iunlock>
    end_op();
80105501:	e8 2a db ff ff       	call   80103030 <end_op>

    f->type = FD_INODE;
80105506:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
    f->ip = ip;
    f->off = 0;
    f->readable = !(omode & O_WRONLY);
8010550c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010550f:	83 c4 10             	add    $0x10,%esp
    f->ip = ip;
80105512:	89 77 10             	mov    %esi,0x10(%edi)
    f->off = 0;
80105515:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
    f->readable = !(omode & O_WRONLY);
8010551c:	89 d0                	mov    %edx,%eax
8010551e:	f7 d0                	not    %eax
80105520:	83 e0 01             	and    $0x1,%eax
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105523:	83 e2 03             	and    $0x3,%edx
    f->readable = !(omode & O_WRONLY);
80105526:	88 47 08             	mov    %al,0x8(%edi)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105529:	0f 95 47 09          	setne  0x9(%edi)
    return fd;
}
8010552d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105530:	89 d8                	mov    %ebx,%eax
80105532:	5b                   	pop    %ebx
80105533:	5e                   	pop    %esi
80105534:	5f                   	pop    %edi
80105535:	5d                   	pop    %ebp
80105536:	c3                   	ret    
80105537:	89 f6                	mov    %esi,%esi
80105539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        ip = create(path, T_FILE, 0, 0);
80105540:	83 ec 0c             	sub    $0xc,%esp
80105543:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105546:	31 c9                	xor    %ecx,%ecx
80105548:	6a 00                	push   $0x0
8010554a:	ba 02 00 00 00       	mov    $0x2,%edx
8010554f:	e8 9c f7 ff ff       	call   80104cf0 <create>
        if (ip == 0) {
80105554:	83 c4 10             	add    $0x10,%esp
80105557:	85 c0                	test   %eax,%eax
        ip = create(path, T_FILE, 0, 0);
80105559:	89 c6                	mov    %eax,%esi
        if (ip == 0) {
8010555b:	0f 85 65 ff ff ff    	jne    801054c6 <sys_open+0x76>
            end_op();
80105561:	e8 ca da ff ff       	call   80103030 <end_op>
            return -1;
80105566:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010556b:	eb c0                	jmp    8010552d <sys_open+0xdd>
8010556d:	8d 76 00             	lea    0x0(%esi),%esi
        if (ip->type == T_DIR && omode != O_RDONLY) {
80105570:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105573:	85 c9                	test   %ecx,%ecx
80105575:	0f 84 4b ff ff ff    	je     801054c6 <sys_open+0x76>
        iunlockput(ip);
8010557b:	83 ec 0c             	sub    $0xc,%esp
8010557e:	56                   	push   %esi
8010557f:	e8 ac c7 ff ff       	call   80101d30 <iunlockput>
        end_op();
80105584:	e8 a7 da ff ff       	call   80103030 <end_op>
        return -1;
80105589:	83 c4 10             	add    $0x10,%esp
8010558c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105591:	eb 9a                	jmp    8010552d <sys_open+0xdd>
80105593:	90                   	nop
80105594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            fileclose(f);
80105598:	83 ec 0c             	sub    $0xc,%esp
8010559b:	57                   	push   %edi
8010559c:	e8 bf bc ff ff       	call   80101260 <fileclose>
801055a1:	83 c4 10             	add    $0x10,%esp
801055a4:	eb d5                	jmp    8010557b <sys_open+0x12b>
801055a6:	8d 76 00             	lea    0x0(%esi),%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055b0 <sys_mkdir>:

int sys_mkdir(void) {
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	83 ec 18             	sub    $0x18,%esp
    char *path;
    struct inode *ip;

    begin_op();
801055b6:	e8 05 da ff ff       	call   80102fc0 <begin_op>
    if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
801055bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055be:	83 ec 08             	sub    $0x8,%esp
801055c1:	50                   	push   %eax
801055c2:	6a 00                	push   $0x0
801055c4:	e8 87 f6 ff ff       	call   80104c50 <argstr>
801055c9:	83 c4 10             	add    $0x10,%esp
801055cc:	85 c0                	test   %eax,%eax
801055ce:	78 30                	js     80105600 <sys_mkdir+0x50>
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d6:	31 c9                	xor    %ecx,%ecx
801055d8:	6a 00                	push   $0x0
801055da:	ba 01 00 00 00       	mov    $0x1,%edx
801055df:	e8 0c f7 ff ff       	call   80104cf0 <create>
801055e4:	83 c4 10             	add    $0x10,%esp
801055e7:	85 c0                	test   %eax,%eax
801055e9:	74 15                	je     80105600 <sys_mkdir+0x50>
        end_op();
        return -1;
    }
    iunlockput(ip);
801055eb:	83 ec 0c             	sub    $0xc,%esp
801055ee:	50                   	push   %eax
801055ef:	e8 3c c7 ff ff       	call   80101d30 <iunlockput>
    end_op();
801055f4:	e8 37 da ff ff       	call   80103030 <end_op>
    return 0;
801055f9:	83 c4 10             	add    $0x10,%esp
801055fc:	31 c0                	xor    %eax,%eax
}
801055fe:	c9                   	leave  
801055ff:	c3                   	ret    
        end_op();
80105600:	e8 2b da ff ff       	call   80103030 <end_op>
        return -1;
80105605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010560a:	c9                   	leave  
8010560b:	c3                   	ret    
8010560c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105610 <sys_mknod>:

int sys_mknod(void) {
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 18             	sub    $0x18,%esp
    struct inode *ip;
    char *path;
    int major, minor;

    begin_op();
80105616:	e8 a5 d9 ff ff       	call   80102fc0 <begin_op>
    if ((argstr(0, &path)) < 0 ||
8010561b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010561e:	83 ec 08             	sub    $0x8,%esp
80105621:	50                   	push   %eax
80105622:	6a 00                	push   $0x0
80105624:	e8 27 f6 ff ff       	call   80104c50 <argstr>
80105629:	83 c4 10             	add    $0x10,%esp
8010562c:	85 c0                	test   %eax,%eax
8010562e:	78 60                	js     80105690 <sys_mknod+0x80>
        argint(1, &major) < 0 ||
80105630:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105633:	83 ec 08             	sub    $0x8,%esp
80105636:	50                   	push   %eax
80105637:	6a 01                	push   $0x1
80105639:	e8 62 f5 ff ff       	call   80104ba0 <argint>
    if ((argstr(0, &path)) < 0 ||
8010563e:	83 c4 10             	add    $0x10,%esp
80105641:	85 c0                	test   %eax,%eax
80105643:	78 4b                	js     80105690 <sys_mknod+0x80>
        argint(2, &minor) < 0 ||
80105645:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105648:	83 ec 08             	sub    $0x8,%esp
8010564b:	50                   	push   %eax
8010564c:	6a 02                	push   $0x2
8010564e:	e8 4d f5 ff ff       	call   80104ba0 <argint>
        argint(1, &major) < 0 ||
80105653:	83 c4 10             	add    $0x10,%esp
80105656:	85 c0                	test   %eax,%eax
80105658:	78 36                	js     80105690 <sys_mknod+0x80>
        (ip = create(path, T_DEV, major, minor)) == 0) {
8010565a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
        argint(2, &minor) < 0 ||
8010565e:	83 ec 0c             	sub    $0xc,%esp
        (ip = create(path, T_DEV, major, minor)) == 0) {
80105661:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
        argint(2, &minor) < 0 ||
80105665:	ba 03 00 00 00       	mov    $0x3,%edx
8010566a:	50                   	push   %eax
8010566b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010566e:	e8 7d f6 ff ff       	call   80104cf0 <create>
80105673:	83 c4 10             	add    $0x10,%esp
80105676:	85 c0                	test   %eax,%eax
80105678:	74 16                	je     80105690 <sys_mknod+0x80>
        end_op();
        return -1;
    }
    iunlockput(ip);
8010567a:	83 ec 0c             	sub    $0xc,%esp
8010567d:	50                   	push   %eax
8010567e:	e8 ad c6 ff ff       	call   80101d30 <iunlockput>
    end_op();
80105683:	e8 a8 d9 ff ff       	call   80103030 <end_op>
    return 0;
80105688:	83 c4 10             	add    $0x10,%esp
8010568b:	31 c0                	xor    %eax,%eax
}
8010568d:	c9                   	leave  
8010568e:	c3                   	ret    
8010568f:	90                   	nop
        end_op();
80105690:	e8 9b d9 ff ff       	call   80103030 <end_op>
        return -1;
80105695:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010569a:	c9                   	leave  
8010569b:	c3                   	ret    
8010569c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056a0 <sys_chdir>:

int sys_chdir(void) {
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	56                   	push   %esi
801056a4:	53                   	push   %ebx
801056a5:	83 ec 10             	sub    $0x10,%esp
    char *path;
    struct inode *ip;
    struct proc *curproc = myproc();
801056a8:	e8 83 e5 ff ff       	call   80103c30 <myproc>
801056ad:	89 c6                	mov    %eax,%esi

    begin_op();
801056af:	e8 0c d9 ff ff       	call   80102fc0 <begin_op>
    if (argstr(0, &path) < 0 || (ip = namei(path)) == 0) {
801056b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056b7:	83 ec 08             	sub    $0x8,%esp
801056ba:	50                   	push   %eax
801056bb:	6a 00                	push   $0x0
801056bd:	e8 8e f5 ff ff       	call   80104c50 <argstr>
801056c2:	83 c4 10             	add    $0x10,%esp
801056c5:	85 c0                	test   %eax,%eax
801056c7:	78 77                	js     80105740 <sys_chdir+0xa0>
801056c9:	83 ec 0c             	sub    $0xc,%esp
801056cc:	ff 75 f4             	pushl  -0xc(%ebp)
801056cf:	e8 2c cc ff ff       	call   80102300 <namei>
801056d4:	83 c4 10             	add    $0x10,%esp
801056d7:	85 c0                	test   %eax,%eax
801056d9:	89 c3                	mov    %eax,%ebx
801056db:	74 63                	je     80105740 <sys_chdir+0xa0>
        end_op();
        return -1;
    }
    ilock(ip);
801056dd:	83 ec 0c             	sub    $0xc,%esp
801056e0:	50                   	push   %eax
801056e1:	e8 ba c3 ff ff       	call   80101aa0 <ilock>
    if (ip->type != T_DIR) {
801056e6:	83 c4 10             	add    $0x10,%esp
801056e9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056ee:	75 30                	jne    80105720 <sys_chdir+0x80>
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	53                   	push   %ebx
801056f4:	e8 87 c4 ff ff       	call   80101b80 <iunlock>
    iput(curproc->cwd);
801056f9:	58                   	pop    %eax
801056fa:	ff 76 68             	pushl  0x68(%esi)
801056fd:	e8 ce c4 ff ff       	call   80101bd0 <iput>
    end_op();
80105702:	e8 29 d9 ff ff       	call   80103030 <end_op>
    curproc->cwd = ip;
80105707:	89 5e 68             	mov    %ebx,0x68(%esi)
    return 0;
8010570a:	83 c4 10             	add    $0x10,%esp
8010570d:	31 c0                	xor    %eax,%eax
}
8010570f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105712:	5b                   	pop    %ebx
80105713:	5e                   	pop    %esi
80105714:	5d                   	pop    %ebp
80105715:	c3                   	ret    
80105716:	8d 76 00             	lea    0x0(%esi),%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        iunlockput(ip);
80105720:	83 ec 0c             	sub    $0xc,%esp
80105723:	53                   	push   %ebx
80105724:	e8 07 c6 ff ff       	call   80101d30 <iunlockput>
        end_op();
80105729:	e8 02 d9 ff ff       	call   80103030 <end_op>
        return -1;
8010572e:	83 c4 10             	add    $0x10,%esp
80105731:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105736:	eb d7                	jmp    8010570f <sys_chdir+0x6f>
80105738:	90                   	nop
80105739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        end_op();
80105740:	e8 eb d8 ff ff       	call   80103030 <end_op>
        return -1;
80105745:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010574a:	eb c3                	jmp    8010570f <sys_chdir+0x6f>
8010574c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105750 <sys_exec>:

int sys_exec(void) {
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	57                   	push   %edi
80105754:	56                   	push   %esi
80105755:	53                   	push   %ebx
    char *path, *argv[MAXARG];
    int i;
    uint uargv, uarg;

    if (argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
80105756:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
int sys_exec(void) {
8010575c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
    if (argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0) {
80105762:	50                   	push   %eax
80105763:	6a 00                	push   $0x0
80105765:	e8 e6 f4 ff ff       	call   80104c50 <argstr>
8010576a:	83 c4 10             	add    $0x10,%esp
8010576d:	85 c0                	test   %eax,%eax
8010576f:	0f 88 87 00 00 00    	js     801057fc <sys_exec+0xac>
80105775:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010577b:	83 ec 08             	sub    $0x8,%esp
8010577e:	50                   	push   %eax
8010577f:	6a 01                	push   $0x1
80105781:	e8 1a f4 ff ff       	call   80104ba0 <argint>
80105786:	83 c4 10             	add    $0x10,%esp
80105789:	85 c0                	test   %eax,%eax
8010578b:	78 6f                	js     801057fc <sys_exec+0xac>
        return -1;
    }
    memset(argv, 0, sizeof(argv));
8010578d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105793:	83 ec 04             	sub    $0x4,%esp
    for (i = 0;; i++) {
80105796:	31 db                	xor    %ebx,%ebx
    memset(argv, 0, sizeof(argv));
80105798:	68 80 00 00 00       	push   $0x80
8010579d:	6a 00                	push   $0x0
8010579f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801057a5:	50                   	push   %eax
801057a6:	e8 f5 f0 ff ff       	call   801048a0 <memset>
801057ab:	83 c4 10             	add    $0x10,%esp
801057ae:	eb 2c                	jmp    801057dc <sys_exec+0x8c>
            return -1;
        }
        if (fetchint(uargv + 4 * i, (int*)&uarg) < 0) {
            return -1;
        }
        if (uarg == 0) {
801057b0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801057b6:	85 c0                	test   %eax,%eax
801057b8:	74 56                	je     80105810 <sys_exec+0xc0>
            argv[i] = 0;
            break;
        }
        if (fetchstr(uarg, &argv[i]) < 0) {
801057ba:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801057c0:	83 ec 08             	sub    $0x8,%esp
801057c3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801057c6:	52                   	push   %edx
801057c7:	50                   	push   %eax
801057c8:	e8 63 f3 ff ff       	call   80104b30 <fetchstr>
801057cd:	83 c4 10             	add    $0x10,%esp
801057d0:	85 c0                	test   %eax,%eax
801057d2:	78 28                	js     801057fc <sys_exec+0xac>
    for (i = 0;; i++) {
801057d4:	83 c3 01             	add    $0x1,%ebx
        if (i >= NELEM(argv)) {
801057d7:	83 fb 20             	cmp    $0x20,%ebx
801057da:	74 20                	je     801057fc <sys_exec+0xac>
        if (fetchint(uargv + 4 * i, (int*)&uarg) < 0) {
801057dc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801057e2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801057e9:	83 ec 08             	sub    $0x8,%esp
801057ec:	57                   	push   %edi
801057ed:	01 f0                	add    %esi,%eax
801057ef:	50                   	push   %eax
801057f0:	e8 fb f2 ff ff       	call   80104af0 <fetchint>
801057f5:	83 c4 10             	add    $0x10,%esp
801057f8:	85 c0                	test   %eax,%eax
801057fa:	79 b4                	jns    801057b0 <sys_exec+0x60>
            return -1;
        }
    }
    return exec(path, argv);
}
801057fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
801057ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105804:	5b                   	pop    %ebx
80105805:	5e                   	pop    %esi
80105806:	5f                   	pop    %edi
80105807:	5d                   	pop    %ebp
80105808:	c3                   	ret    
80105809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return exec(path, argv);
80105810:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105816:	83 ec 08             	sub    $0x8,%esp
            argv[i] = 0;
80105819:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105820:	00 00 00 00 
    return exec(path, argv);
80105824:	50                   	push   %eax
80105825:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010582b:	e8 d0 b5 ff ff       	call   80100e00 <exec>
80105830:	83 c4 10             	add    $0x10,%esp
}
80105833:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105836:	5b                   	pop    %ebx
80105837:	5e                   	pop    %esi
80105838:	5f                   	pop    %edi
80105839:	5d                   	pop    %ebp
8010583a:	c3                   	ret    
8010583b:	90                   	nop
8010583c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105840 <sys_pipe>:

int sys_pipe(void) {
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	57                   	push   %edi
80105844:	56                   	push   %esi
80105845:	53                   	push   %ebx
    int *fd;
    struct file *rf, *wf;
    int fd0, fd1;

    if (argptr(0, (void*)&fd, 2 * sizeof(fd[0])) < 0) {
80105846:	8d 45 dc             	lea    -0x24(%ebp),%eax
int sys_pipe(void) {
80105849:	83 ec 20             	sub    $0x20,%esp
    if (argptr(0, (void*)&fd, 2 * sizeof(fd[0])) < 0) {
8010584c:	6a 08                	push   $0x8
8010584e:	50                   	push   %eax
8010584f:	6a 00                	push   $0x0
80105851:	e8 9a f3 ff ff       	call   80104bf0 <argptr>
80105856:	83 c4 10             	add    $0x10,%esp
80105859:	85 c0                	test   %eax,%eax
8010585b:	0f 88 ae 00 00 00    	js     8010590f <sys_pipe+0xcf>
        return -1;
    }
    if (pipealloc(&rf, &wf) < 0) {
80105861:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105864:	83 ec 08             	sub    $0x8,%esp
80105867:	50                   	push   %eax
80105868:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010586b:	50                   	push   %eax
8010586c:	e8 3f de ff ff       	call   801036b0 <pipealloc>
80105871:	83 c4 10             	add    $0x10,%esp
80105874:	85 c0                	test   %eax,%eax
80105876:	0f 88 93 00 00 00    	js     8010590f <sys_pipe+0xcf>
        return -1;
    }
    fd0 = -1;
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
8010587c:	8b 7d e0             	mov    -0x20(%ebp),%edi
    for (fd = 0; fd < NOFILE; fd++) {
8010587f:	31 db                	xor    %ebx,%ebx
    struct proc *curproc = myproc();
80105881:	e8 aa e3 ff ff       	call   80103c30 <myproc>
80105886:	eb 10                	jmp    80105898 <sys_pipe+0x58>
80105888:	90                   	nop
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for (fd = 0; fd < NOFILE; fd++) {
80105890:	83 c3 01             	add    $0x1,%ebx
80105893:	83 fb 10             	cmp    $0x10,%ebx
80105896:	74 60                	je     801058f8 <sys_pipe+0xb8>
        if (curproc->ofile[fd] == 0) {
80105898:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010589c:	85 f6                	test   %esi,%esi
8010589e:	75 f0                	jne    80105890 <sys_pipe+0x50>
            curproc->ofile[fd] = f;
801058a0:	8d 73 08             	lea    0x8(%ebx),%esi
801058a3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
801058a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    struct proc *curproc = myproc();
801058aa:	e8 81 e3 ff ff       	call   80103c30 <myproc>
    for (fd = 0; fd < NOFILE; fd++) {
801058af:	31 d2                	xor    %edx,%edx
801058b1:	eb 0d                	jmp    801058c0 <sys_pipe+0x80>
801058b3:	90                   	nop
801058b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058b8:	83 c2 01             	add    $0x1,%edx
801058bb:	83 fa 10             	cmp    $0x10,%edx
801058be:	74 28                	je     801058e8 <sys_pipe+0xa8>
        if (curproc->ofile[fd] == 0) {
801058c0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801058c4:	85 c9                	test   %ecx,%ecx
801058c6:	75 f0                	jne    801058b8 <sys_pipe+0x78>
            curproc->ofile[fd] = f;
801058c8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
        }
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    fd[0] = fd0;
801058cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058cf:	89 18                	mov    %ebx,(%eax)
    fd[1] = fd1;
801058d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058d4:	89 50 04             	mov    %edx,0x4(%eax)
    return 0;
801058d7:	31 c0                	xor    %eax,%eax
}
801058d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058dc:	5b                   	pop    %ebx
801058dd:	5e                   	pop    %esi
801058de:	5f                   	pop    %edi
801058df:	5d                   	pop    %ebp
801058e0:	c3                   	ret    
801058e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            myproc()->ofile[fd0] = 0;
801058e8:	e8 43 e3 ff ff       	call   80103c30 <myproc>
801058ed:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801058f4:	00 
801058f5:	8d 76 00             	lea    0x0(%esi),%esi
        fileclose(rf);
801058f8:	83 ec 0c             	sub    $0xc,%esp
801058fb:	ff 75 e0             	pushl  -0x20(%ebp)
801058fe:	e8 5d b9 ff ff       	call   80101260 <fileclose>
        fileclose(wf);
80105903:	58                   	pop    %eax
80105904:	ff 75 e4             	pushl  -0x1c(%ebp)
80105907:	e8 54 b9 ff ff       	call   80101260 <fileclose>
        return -1;
8010590c:	83 c4 10             	add    $0x10,%esp
8010590f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105914:	eb c3                	jmp    801058d9 <sys_pipe+0x99>
80105916:	66 90                	xchg   %ax,%ax
80105918:	66 90                	xchg   %ax,%ax
8010591a:	66 90                	xchg   %ax,%ax
8010591c:	66 90                	xchg   %ax,%ax
8010591e:	66 90                	xchg   %ax,%ax

80105920 <sys_fork>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void) {
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
    return fork();
}
80105923:	5d                   	pop    %ebp
    return fork();
80105924:	e9 a7 e4 ff ff       	jmp    80103dd0 <fork>
80105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105930 <sys_exit>:

int sys_exit(void) {
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	83 ec 08             	sub    $0x8,%esp
    exit();
80105936:	e8 15 e7 ff ff       	call   80104050 <exit>
    return 0;  // not reached
}
8010593b:	31 c0                	xor    %eax,%eax
8010593d:	c9                   	leave  
8010593e:	c3                   	ret    
8010593f:	90                   	nop

80105940 <sys_wait>:

int sys_wait(void) {
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
    return wait();
}
80105943:	5d                   	pop    %ebp
    return wait();
80105944:	e9 47 e9 ff ff       	jmp    80104290 <wait>
80105949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105950 <sys_kill>:

int sys_kill(void) {
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	83 ec 20             	sub    $0x20,%esp
    int pid;

    if (argint(0, &pid) < 0) {
80105956:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105959:	50                   	push   %eax
8010595a:	6a 00                	push   $0x0
8010595c:	e8 3f f2 ff ff       	call   80104ba0 <argint>
80105961:	83 c4 10             	add    $0x10,%esp
80105964:	85 c0                	test   %eax,%eax
80105966:	78 18                	js     80105980 <sys_kill+0x30>
        return -1;
    }
    return kill(pid);
80105968:	83 ec 0c             	sub    $0xc,%esp
8010596b:	ff 75 f4             	pushl  -0xc(%ebp)
8010596e:	e8 6d ea ff ff       	call   801043e0 <kill>
80105973:	83 c4 10             	add    $0x10,%esp
}
80105976:	c9                   	leave  
80105977:	c3                   	ret    
80105978:	90                   	nop
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105985:	c9                   	leave  
80105986:	c3                   	ret    
80105987:	89 f6                	mov    %esi,%esi
80105989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105990 <sys_getpid>:

int sys_getpid(void) {
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	83 ec 08             	sub    $0x8,%esp
    return myproc()->pid;
80105996:	e8 95 e2 ff ff       	call   80103c30 <myproc>
8010599b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010599e:	c9                   	leave  
8010599f:	c3                   	ret    

801059a0 <sys_sbrk>:

int sys_sbrk(void) {
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	53                   	push   %ebx
    int addr;
    int n;

    if (argint(0, &n) < 0) {
801059a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sbrk(void) {
801059a7:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0) {
801059aa:	50                   	push   %eax
801059ab:	6a 00                	push   $0x0
801059ad:	e8 ee f1 ff ff       	call   80104ba0 <argint>
801059b2:	83 c4 10             	add    $0x10,%esp
801059b5:	85 c0                	test   %eax,%eax
801059b7:	78 27                	js     801059e0 <sys_sbrk+0x40>
        return -1;
    }
    addr = myproc()->sz;
801059b9:	e8 72 e2 ff ff       	call   80103c30 <myproc>
    if (growproc(n) < 0) {
801059be:	83 ec 0c             	sub    $0xc,%esp
    addr = myproc()->sz;
801059c1:	8b 18                	mov    (%eax),%ebx
    if (growproc(n) < 0) {
801059c3:	ff 75 f4             	pushl  -0xc(%ebp)
801059c6:	e8 85 e3 ff ff       	call   80103d50 <growproc>
801059cb:	83 c4 10             	add    $0x10,%esp
801059ce:	85 c0                	test   %eax,%eax
801059d0:	78 0e                	js     801059e0 <sys_sbrk+0x40>
        return -1;
    }
    return addr;
}
801059d2:	89 d8                	mov    %ebx,%eax
801059d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059d7:	c9                   	leave  
801059d8:	c3                   	ret    
801059d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
801059e0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059e5:	eb eb                	jmp    801059d2 <sys_sbrk+0x32>
801059e7:	89 f6                	mov    %esi,%esi
801059e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059f0 <sys_sleep>:

int sys_sleep(void) {
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	53                   	push   %ebx
    int n;
    uint ticks0;

    if (argint(0, &n) < 0) {
801059f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
int sys_sleep(void) {
801059f7:	83 ec 1c             	sub    $0x1c,%esp
    if (argint(0, &n) < 0) {
801059fa:	50                   	push   %eax
801059fb:	6a 00                	push   $0x0
801059fd:	e8 9e f1 ff ff       	call   80104ba0 <argint>
80105a02:	83 c4 10             	add    $0x10,%esp
80105a05:	85 c0                	test   %eax,%eax
80105a07:	0f 88 8a 00 00 00    	js     80105a97 <sys_sleep+0xa7>
        return -1;
    }
    acquire(&tickslock);
80105a0d:	83 ec 0c             	sub    $0xc,%esp
80105a10:	68 60 5c 11 80       	push   $0x80115c60
80105a15:	e8 76 ed ff ff       	call   80104790 <acquire>
    ticks0 = ticks;
    while (ticks - ticks0 < n) {
80105a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a1d:	83 c4 10             	add    $0x10,%esp
    ticks0 = ticks;
80105a20:	8b 1d a0 64 11 80    	mov    0x801164a0,%ebx
    while (ticks - ticks0 < n) {
80105a26:	85 d2                	test   %edx,%edx
80105a28:	75 27                	jne    80105a51 <sys_sleep+0x61>
80105a2a:	eb 54                	jmp    80105a80 <sys_sleep+0x90>
80105a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (myproc()->killed) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
80105a30:	83 ec 08             	sub    $0x8,%esp
80105a33:	68 60 5c 11 80       	push   $0x80115c60
80105a38:	68 a0 64 11 80       	push   $0x801164a0
80105a3d:	e8 8e e7 ff ff       	call   801041d0 <sleep>
    while (ticks - ticks0 < n) {
80105a42:	a1 a0 64 11 80       	mov    0x801164a0,%eax
80105a47:	83 c4 10             	add    $0x10,%esp
80105a4a:	29 d8                	sub    %ebx,%eax
80105a4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a4f:	73 2f                	jae    80105a80 <sys_sleep+0x90>
        if (myproc()->killed) {
80105a51:	e8 da e1 ff ff       	call   80103c30 <myproc>
80105a56:	8b 40 24             	mov    0x24(%eax),%eax
80105a59:	85 c0                	test   %eax,%eax
80105a5b:	74 d3                	je     80105a30 <sys_sleep+0x40>
            release(&tickslock);
80105a5d:	83 ec 0c             	sub    $0xc,%esp
80105a60:	68 60 5c 11 80       	push   $0x80115c60
80105a65:	e8 e6 ed ff ff       	call   80104850 <release>
            return -1;
80105a6a:	83 c4 10             	add    $0x10,%esp
80105a6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    release(&tickslock);
    return 0;
}
80105a72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a75:	c9                   	leave  
80105a76:	c3                   	ret    
80105a77:	89 f6                	mov    %esi,%esi
80105a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&tickslock);
80105a80:	83 ec 0c             	sub    $0xc,%esp
80105a83:	68 60 5c 11 80       	push   $0x80115c60
80105a88:	e8 c3 ed ff ff       	call   80104850 <release>
    return 0;
80105a8d:	83 c4 10             	add    $0x10,%esp
80105a90:	31 c0                	xor    %eax,%eax
}
80105a92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a95:	c9                   	leave  
80105a96:	c3                   	ret    
        return -1;
80105a97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a9c:	eb f4                	jmp    80105a92 <sys_sleep+0xa2>
80105a9e:	66 90                	xchg   %ax,%ax

80105aa0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void) {
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	53                   	push   %ebx
80105aa4:	83 ec 10             	sub    $0x10,%esp
    uint xticks;

    acquire(&tickslock);
80105aa7:	68 60 5c 11 80       	push   $0x80115c60
80105aac:	e8 df ec ff ff       	call   80104790 <acquire>
    xticks = ticks;
80105ab1:	8b 1d a0 64 11 80    	mov    0x801164a0,%ebx
    release(&tickslock);
80105ab7:	c7 04 24 60 5c 11 80 	movl   $0x80115c60,(%esp)
80105abe:	e8 8d ed ff ff       	call   80104850 <release>
    return xticks;
}
80105ac3:	89 d8                	mov    %ebx,%eax
80105ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ac8:	c9                   	leave  
80105ac9:	c3                   	ret    
80105aca:	66 90                	xchg   %ax,%ax
80105acc:	66 90                	xchg   %ax,%ax
80105ace:	66 90                	xchg   %ax,%ax

80105ad0 <sys_getch>:
#include "types.h"
#include "defs.h"

int sys_getch(void) {
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
    return consoleget();
}
80105ad3:	5d                   	pop    %ebp
    return consoleget();
80105ad4:	e9 27 ae ff ff       	jmp    80100900 <consoleget>
80105ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ae0 <sys_greeting>:

int sys_greeting(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	83 ec 14             	sub    $0x14,%esp
    cprintf("Hello, user\n");
80105ae6:	68 b1 7b 10 80       	push   $0x80107bb1
80105aeb:	e8 60 ac ff ff       	call   80100750 <cprintf>

    return 0;
}
80105af0:	31 c0                	xor    %eax,%eax
80105af2:	c9                   	leave  
80105af3:	c3                   	ret    
80105af4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105afa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105b00 <sys_videomodevga>:

int sys_videomodevga(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	83 ec 14             	sub    $0x14,%esp
    consolevgamode(0x13);
80105b06:	6a 13                	push   $0x13
80105b08:	e8 b3 b1 ff ff       	call   80100cc0 <consolevgamode>
    return 0;
}
80105b0d:	31 c0                	xor    %eax,%eax
80105b0f:	c9                   	leave  
80105b10:	c3                   	ret    
80105b11:	eb 0d                	jmp    80105b20 <sys_videomodetext>
80105b13:	90                   	nop
80105b14:	90                   	nop
80105b15:	90                   	nop
80105b16:	90                   	nop
80105b17:	90                   	nop
80105b18:	90                   	nop
80105b19:	90                   	nop
80105b1a:	90                   	nop
80105b1b:	90                   	nop
80105b1c:	90                   	nop
80105b1d:	90                   	nop
80105b1e:	90                   	nop
80105b1f:	90                   	nop

80105b20 <sys_videomodetext>:
int sys_videomodetext(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	83 ec 14             	sub    $0x14,%esp
    consolevgamode(0x03);
80105b26:	6a 03                	push   $0x3
80105b28:	e8 93 b1 ff ff       	call   80100cc0 <consolevgamode>
    return 0;
}
80105b2d:	31 c0                	xor    %eax,%eax
80105b2f:	c9                   	leave  
80105b30:	c3                   	ret    
80105b31:	eb 0d                	jmp    80105b40 <sys_setpixel>
80105b33:	90                   	nop
80105b34:	90                   	nop
80105b35:	90                   	nop
80105b36:	90                   	nop
80105b37:	90                   	nop
80105b38:	90                   	nop
80105b39:	90                   	nop
80105b3a:	90                   	nop
80105b3b:	90                   	nop
80105b3c:	90                   	nop
80105b3d:	90                   	nop
80105b3e:	90                   	nop
80105b3f:	90                   	nop

80105b40 <sys_setpixel>:
int sys_setpixel(int pos_x, int pos_y, int VGA_COLOR)
{
80105b40:	55                   	push   %ebp
    
    //unsigned char* location = (unsigned char*)0xA0000 + 320 * pos_y + pos_x;
    //*location = VGA_COLOR;
    return 0;
}
80105b41:	31 c0                	xor    %eax,%eax
{
80105b43:	89 e5                	mov    %esp,%ebp
}
80105b45:	5d                   	pop    %ebp
80105b46:	c3                   	ret    
80105b47:	89 f6                	mov    %esi,%esi
80105b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b50 <sys_setspecificpixel>:
80105b50:	55                   	push   %ebp
80105b51:	31 c0                	xor    %eax,%eax
80105b53:	89 e5                	mov    %esp,%ebp
80105b55:	5d                   	pop    %ebp
80105b56:	c3                   	ret    

80105b57 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
    pushl %ds
80105b57:	1e                   	push   %ds
    pushl %es
80105b58:	06                   	push   %es
    pushl %fs
80105b59:	0f a0                	push   %fs
    pushl %gs
80105b5b:	0f a8                	push   %gs
    pushal
80105b5d:	60                   	pusha  
  
    # Set up data segments.
    movw $(SEG_KDATA<<3), %ax
80105b5e:	66 b8 10 00          	mov    $0x10,%ax
    movw %ax, %ds
80105b62:	8e d8                	mov    %eax,%ds
    movw %ax, %es
80105b64:	8e c0                	mov    %eax,%es

    # Call trap(tf), where tf=%esp
    pushl %esp
80105b66:	54                   	push   %esp
    call trap
80105b67:	e8 c4 00 00 00       	call   80105c30 <trap>
    addl $4, %esp
80105b6c:	83 c4 04             	add    $0x4,%esp

80105b6f <trapret>:

    # Return falls through to trapret...
.globl trapret
trapret:
    popal
80105b6f:	61                   	popa   
    popl %gs
80105b70:	0f a9                	pop    %gs
    popl %fs
80105b72:	0f a1                	pop    %fs
    popl %es
80105b74:	07                   	pop    %es
    popl %ds
80105b75:	1f                   	pop    %ds
    addl $0x8, %esp  # trapno and errcode
80105b76:	83 c4 08             	add    $0x8,%esp
    iret
80105b79:	cf                   	iret   
80105b7a:	66 90                	xchg   %ax,%ax
80105b7c:	66 90                	xchg   %ax,%ax
80105b7e:	66 90                	xchg   %ax,%ax

80105b80 <tvinit>:
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void tvinit(void) {
80105b80:	55                   	push   %ebp
    int i;

    for (i = 0; i < 256; i++) {
80105b81:	31 c0                	xor    %eax,%eax
void tvinit(void) {
80105b83:	89 e5                	mov    %esp,%ebp
80105b85:	83 ec 08             	sub    $0x8,%esp
80105b88:	90                   	nop
80105b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
80105b90:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105b97:	c7 04 c5 a2 5c 11 80 	movl   $0x8e000008,-0x7feea35e(,%eax,8)
80105b9e:	08 00 00 8e 
80105ba2:	66 89 14 c5 a0 5c 11 	mov    %dx,-0x7feea360(,%eax,8)
80105ba9:	80 
80105baa:	c1 ea 10             	shr    $0x10,%edx
80105bad:	66 89 14 c5 a6 5c 11 	mov    %dx,-0x7feea35a(,%eax,8)
80105bb4:	80 
    for (i = 0; i < 256; i++) {
80105bb5:	83 c0 01             	add    $0x1,%eax
80105bb8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bbd:	75 d1                	jne    80105b90 <tvinit+0x10>
    }
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105bbf:	a1 08 b1 10 80       	mov    0x8010b108,%eax

    initlock(&tickslock, "time");
80105bc4:	83 ec 08             	sub    $0x8,%esp
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105bc7:	c7 05 a2 5e 11 80 08 	movl   $0xef000008,0x80115ea2
80105bce:	00 00 ef 
    initlock(&tickslock, "time");
80105bd1:	68 be 7b 10 80       	push   $0x80107bbe
80105bd6:	68 60 5c 11 80       	push   $0x80115c60
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);
80105bdb:	66 a3 a0 5e 11 80    	mov    %ax,0x80115ea0
80105be1:	c1 e8 10             	shr    $0x10,%eax
80105be4:	66 a3 a6 5e 11 80    	mov    %ax,0x80115ea6
    initlock(&tickslock, "time");
80105bea:	e8 61 ea ff ff       	call   80104650 <initlock>
}
80105bef:	83 c4 10             	add    $0x10,%esp
80105bf2:	c9                   	leave  
80105bf3:	c3                   	ret    
80105bf4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105bfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105c00 <idtinit>:

void idtinit(void) {
80105c00:	55                   	push   %ebp
    pd[0] = size - 1;
80105c01:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c06:	89 e5                	mov    %esp,%ebp
80105c08:	83 ec 10             	sub    $0x10,%esp
80105c0b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    pd[1] = (uint)p;
80105c0f:	b8 a0 5c 11 80       	mov    $0x80115ca0,%eax
80105c14:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    pd[2] = (uint)p >> 16;
80105c18:	c1 e8 10             	shr    $0x10,%eax
80105c1b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
    asm volatile ("lidt (%0)" : : "r" (pd));
80105c1f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c22:	0f 01 18             	lidtl  (%eax)
    lidt(idt, sizeof(idt));
}
80105c25:	c9                   	leave  
80105c26:	c3                   	ret    
80105c27:	89 f6                	mov    %esi,%esi
80105c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c30 <trap>:

void trap(struct trapframe *tf) {
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	57                   	push   %edi
80105c34:	56                   	push   %esi
80105c35:	53                   	push   %ebx
80105c36:	83 ec 1c             	sub    $0x1c,%esp
80105c39:	8b 7d 08             	mov    0x8(%ebp),%edi
    if (tf->trapno == T_SYSCALL) {
80105c3c:	8b 47 30             	mov    0x30(%edi),%eax
80105c3f:	83 f8 40             	cmp    $0x40,%eax
80105c42:	0f 84 f0 00 00 00    	je     80105d38 <trap+0x108>
            exit();
        }
        return;
    }

    switch (tf->trapno) {
80105c48:	83 e8 20             	sub    $0x20,%eax
80105c4b:	83 f8 1f             	cmp    $0x1f,%eax
80105c4e:	77 10                	ja     80105c60 <trap+0x30>
80105c50:	ff 24 85 64 7c 10 80 	jmp    *-0x7fef839c(,%eax,4)
80105c57:	89 f6                	mov    %esi,%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            lapiceoi();
            break;

    
        default:
            if (myproc() == 0 || (tf->cs & 3) == 0) {
80105c60:	e8 cb df ff ff       	call   80103c30 <myproc>
80105c65:	85 c0                	test   %eax,%eax
80105c67:	8b 5f 38             	mov    0x38(%edi),%ebx
80105c6a:	0f 84 14 02 00 00    	je     80105e84 <trap+0x254>
80105c70:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105c74:	0f 84 0a 02 00 00    	je     80105e84 <trap+0x254>
    return result;
}

static inline uint rcr2(void) {
    uint val;
    asm volatile ("movl %%cr2,%0" : "=r" (val));
80105c7a:	0f 20 d1             	mov    %cr2,%ecx
80105c7d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c80:	e8 8b df ff ff       	call   80103c10 <cpuid>
80105c85:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c88:	8b 47 34             	mov    0x34(%edi),%eax
80105c8b:	8b 77 30             	mov    0x30(%edi),%esi
80105c8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                    "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
80105c91:	e8 9a df ff ff       	call   80103c30 <myproc>
80105c96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c99:	e8 92 df ff ff       	call   80103c30 <myproc>
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c9e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ca1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ca4:	51                   	push   %ecx
80105ca5:	53                   	push   %ebx
80105ca6:	52                   	push   %edx
                    myproc()->pid, myproc()->name, tf->trapno,
80105ca7:	8b 55 e0             	mov    -0x20(%ebp),%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105caa:	ff 75 e4             	pushl  -0x1c(%ebp)
80105cad:	56                   	push   %esi
                    myproc()->pid, myproc()->name, tf->trapno,
80105cae:	83 c2 6c             	add    $0x6c,%edx
            cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cb1:	52                   	push   %edx
80105cb2:	ff 70 10             	pushl  0x10(%eax)
80105cb5:	68 20 7c 10 80       	push   $0x80107c20
80105cba:	e8 91 aa ff ff       	call   80100750 <cprintf>
                    tf->err, cpuid(), tf->eip, rcr2());
            myproc()->killed = 1;
80105cbf:	83 c4 20             	add    $0x20,%esp
80105cc2:	e8 69 df ff ff       	call   80103c30 <myproc>
80105cc7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
80105cce:	e8 5d df ff ff       	call   80103c30 <myproc>
80105cd3:	85 c0                	test   %eax,%eax
80105cd5:	74 1d                	je     80105cf4 <trap+0xc4>
80105cd7:	e8 54 df ff ff       	call   80103c30 <myproc>
80105cdc:	8b 50 24             	mov    0x24(%eax),%edx
80105cdf:	85 d2                	test   %edx,%edx
80105ce1:	74 11                	je     80105cf4 <trap+0xc4>
80105ce3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ce7:	83 e0 03             	and    $0x3,%eax
80105cea:	66 83 f8 03          	cmp    $0x3,%ax
80105cee:	0f 84 4c 01 00 00    	je     80105e40 <trap+0x210>
        exit();
    }

    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
80105cf4:	e8 37 df ff ff       	call   80103c30 <myproc>
80105cf9:	85 c0                	test   %eax,%eax
80105cfb:	74 0b                	je     80105d08 <trap+0xd8>
80105cfd:	e8 2e df ff ff       	call   80103c30 <myproc>
80105d02:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d06:	74 68                	je     80105d70 <trap+0x140>
        tf->trapno == T_IRQ0 + IRQ_TIMER) {
        yield();
    }

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
80105d08:	e8 23 df ff ff       	call   80103c30 <myproc>
80105d0d:	85 c0                	test   %eax,%eax
80105d0f:	74 19                	je     80105d2a <trap+0xfa>
80105d11:	e8 1a df ff ff       	call   80103c30 <myproc>
80105d16:	8b 40 24             	mov    0x24(%eax),%eax
80105d19:	85 c0                	test   %eax,%eax
80105d1b:	74 0d                	je     80105d2a <trap+0xfa>
80105d1d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d21:	83 e0 03             	and    $0x3,%eax
80105d24:	66 83 f8 03          	cmp    $0x3,%ax
80105d28:	74 37                	je     80105d61 <trap+0x131>
        exit();
    }
}
80105d2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d2d:	5b                   	pop    %ebx
80105d2e:	5e                   	pop    %esi
80105d2f:	5f                   	pop    %edi
80105d30:	5d                   	pop    %ebp
80105d31:	c3                   	ret    
80105d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (myproc()->killed) {
80105d38:	e8 f3 de ff ff       	call   80103c30 <myproc>
80105d3d:	8b 58 24             	mov    0x24(%eax),%ebx
80105d40:	85 db                	test   %ebx,%ebx
80105d42:	0f 85 e8 00 00 00    	jne    80105e30 <trap+0x200>
        myproc()->tf = tf;
80105d48:	e8 e3 de ff ff       	call   80103c30 <myproc>
80105d4d:	89 78 18             	mov    %edi,0x18(%eax)
        syscall();
80105d50:	e8 3b ef ff ff       	call   80104c90 <syscall>
        if (myproc()->killed) {
80105d55:	e8 d6 de ff ff       	call   80103c30 <myproc>
80105d5a:	8b 48 24             	mov    0x24(%eax),%ecx
80105d5d:	85 c9                	test   %ecx,%ecx
80105d5f:	74 c9                	je     80105d2a <trap+0xfa>
}
80105d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d64:	5b                   	pop    %ebx
80105d65:	5e                   	pop    %esi
80105d66:	5f                   	pop    %edi
80105d67:	5d                   	pop    %ebp
            exit();
80105d68:	e9 e3 e2 ff ff       	jmp    80104050 <exit>
80105d6d:	8d 76 00             	lea    0x0(%esi),%esi
    if (myproc() && myproc()->state == RUNNING &&
80105d70:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105d74:	75 92                	jne    80105d08 <trap+0xd8>
        yield();
80105d76:	e8 05 e4 ff ff       	call   80104180 <yield>
80105d7b:	eb 8b                	jmp    80105d08 <trap+0xd8>
80105d7d:	8d 76 00             	lea    0x0(%esi),%esi
            if (cpuid() == 0) {
80105d80:	e8 8b de ff ff       	call   80103c10 <cpuid>
80105d85:	85 c0                	test   %eax,%eax
80105d87:	0f 84 c3 00 00 00    	je     80105e50 <trap+0x220>
            lapiceoi();
80105d8d:	e8 de cd ff ff       	call   80102b70 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
80105d92:	e8 99 de ff ff       	call   80103c30 <myproc>
80105d97:	85 c0                	test   %eax,%eax
80105d99:	0f 85 38 ff ff ff    	jne    80105cd7 <trap+0xa7>
80105d9f:	e9 50 ff ff ff       	jmp    80105cf4 <trap+0xc4>
80105da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            kbdintr();
80105da8:	e8 83 cc ff ff       	call   80102a30 <kbdintr>
            lapiceoi();
80105dad:	e8 be cd ff ff       	call   80102b70 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
80105db2:	e8 79 de ff ff       	call   80103c30 <myproc>
80105db7:	85 c0                	test   %eax,%eax
80105db9:	0f 85 18 ff ff ff    	jne    80105cd7 <trap+0xa7>
80105dbf:	e9 30 ff ff ff       	jmp    80105cf4 <trap+0xc4>
80105dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            uartintr();
80105dc8:	e8 53 02 00 00       	call   80106020 <uartintr>
            lapiceoi();
80105dcd:	e8 9e cd ff ff       	call   80102b70 <lapiceoi>
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
80105dd2:	e8 59 de ff ff       	call   80103c30 <myproc>
80105dd7:	85 c0                	test   %eax,%eax
80105dd9:	0f 85 f8 fe ff ff    	jne    80105cd7 <trap+0xa7>
80105ddf:	e9 10 ff ff ff       	jmp    80105cf4 <trap+0xc4>
80105de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105de8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105dec:	8b 77 38             	mov    0x38(%edi),%esi
80105def:	e8 1c de ff ff       	call   80103c10 <cpuid>
80105df4:	56                   	push   %esi
80105df5:	53                   	push   %ebx
80105df6:	50                   	push   %eax
80105df7:	68 c8 7b 10 80       	push   $0x80107bc8
80105dfc:	e8 4f a9 ff ff       	call   80100750 <cprintf>
            lapiceoi();
80105e01:	e8 6a cd ff ff       	call   80102b70 <lapiceoi>
            break;
80105e06:	83 c4 10             	add    $0x10,%esp
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER) {
80105e09:	e8 22 de ff ff       	call   80103c30 <myproc>
80105e0e:	85 c0                	test   %eax,%eax
80105e10:	0f 85 c1 fe ff ff    	jne    80105cd7 <trap+0xa7>
80105e16:	e9 d9 fe ff ff       	jmp    80105cf4 <trap+0xc4>
80105e1b:	90                   	nop
80105e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            ideintr();
80105e20:	e8 7b c6 ff ff       	call   801024a0 <ideintr>
80105e25:	e9 63 ff ff ff       	jmp    80105d8d <trap+0x15d>
80105e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            exit();
80105e30:	e8 1b e2 ff ff       	call   80104050 <exit>
80105e35:	e9 0e ff ff ff       	jmp    80105d48 <trap+0x118>
80105e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        exit();
80105e40:	e8 0b e2 ff ff       	call   80104050 <exit>
80105e45:	e9 aa fe ff ff       	jmp    80105cf4 <trap+0xc4>
80105e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                acquire(&tickslock);
80105e50:	83 ec 0c             	sub    $0xc,%esp
80105e53:	68 60 5c 11 80       	push   $0x80115c60
80105e58:	e8 33 e9 ff ff       	call   80104790 <acquire>
                wakeup(&ticks);
80105e5d:	c7 04 24 a0 64 11 80 	movl   $0x801164a0,(%esp)
                ticks++;
80105e64:	83 05 a0 64 11 80 01 	addl   $0x1,0x801164a0
                wakeup(&ticks);
80105e6b:	e8 10 e5 ff ff       	call   80104380 <wakeup>
                release(&tickslock);
80105e70:	c7 04 24 60 5c 11 80 	movl   $0x80115c60,(%esp)
80105e77:	e8 d4 e9 ff ff       	call   80104850 <release>
80105e7c:	83 c4 10             	add    $0x10,%esp
80105e7f:	e9 09 ff ff ff       	jmp    80105d8d <trap+0x15d>
80105e84:	0f 20 d6             	mov    %cr2,%esi
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e87:	e8 84 dd ff ff       	call   80103c10 <cpuid>
80105e8c:	83 ec 0c             	sub    $0xc,%esp
80105e8f:	56                   	push   %esi
80105e90:	53                   	push   %ebx
80105e91:	50                   	push   %eax
80105e92:	ff 77 30             	pushl  0x30(%edi)
80105e95:	68 ec 7b 10 80       	push   $0x80107bec
80105e9a:	e8 b1 a8 ff ff       	call   80100750 <cprintf>
                panic("trap");
80105e9f:	83 c4 14             	add    $0x14,%esp
80105ea2:	68 c3 7b 10 80       	push   $0x80107bc3
80105ea7:	e8 d4 a5 ff ff       	call   80100480 <panic>
80105eac:	66 90                	xchg   %ax,%ax
80105eae:	66 90                	xchg   %ax,%ax

80105eb0 <uartgetc>:
    }
    outb(COM1 + 0, c);
}

static int uartgetc(void)            {
    if (!uart) {
80105eb0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
static int uartgetc(void)            {
80105eb5:	55                   	push   %ebp
80105eb6:	89 e5                	mov    %esp,%ebp
    if (!uart) {
80105eb8:	85 c0                	test   %eax,%eax
80105eba:	74 1c                	je     80105ed8 <uartgetc+0x28>
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80105ebc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ec1:	ec                   	in     (%dx),%al
        return -1;
    }
    if (!(inb(COM1 + 5) & 0x01)) {
80105ec2:	a8 01                	test   $0x1,%al
80105ec4:	74 12                	je     80105ed8 <uartgetc+0x28>
80105ec6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ecb:	ec                   	in     (%dx),%al
        return -1;
    }
    return inb(COM1 + 0);
80105ecc:	0f b6 c0             	movzbl %al,%eax
}
80105ecf:	5d                   	pop    %ebp
80105ed0:	c3                   	ret    
80105ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        return -1;
80105ed8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105edd:	5d                   	pop    %ebp
80105ede:	c3                   	ret    
80105edf:	90                   	nop

80105ee0 <uartputc.part.0>:
void uartputc(int c) {
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	57                   	push   %edi
80105ee4:	56                   	push   %esi
80105ee5:	53                   	push   %ebx
80105ee6:	89 c7                	mov    %eax,%edi
80105ee8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105eed:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ef2:	83 ec 0c             	sub    $0xc,%esp
80105ef5:	eb 1b                	jmp    80105f12 <uartputc.part.0+0x32>
80105ef7:	89 f6                	mov    %esi,%esi
80105ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        microdelay(10);
80105f00:	83 ec 0c             	sub    $0xc,%esp
80105f03:	6a 0a                	push   $0xa
80105f05:	e8 86 cc ff ff       	call   80102b90 <microdelay>
    for (i = 0; i < 128 && !(inb(COM1 + 5) & 0x20); i++) {
80105f0a:	83 c4 10             	add    $0x10,%esp
80105f0d:	83 eb 01             	sub    $0x1,%ebx
80105f10:	74 07                	je     80105f19 <uartputc.part.0+0x39>
80105f12:	89 f2                	mov    %esi,%edx
80105f14:	ec                   	in     (%dx),%al
80105f15:	a8 20                	test   $0x20,%al
80105f17:	74 e7                	je     80105f00 <uartputc.part.0+0x20>
    asm volatile ("out %0,%1" : : "a" (data), "d" (port));
80105f19:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f1e:	89 f8                	mov    %edi,%eax
80105f20:	ee                   	out    %al,(%dx)
}
80105f21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f24:	5b                   	pop    %ebx
80105f25:	5e                   	pop    %esi
80105f26:	5f                   	pop    %edi
80105f27:	5d                   	pop    %ebp
80105f28:	c3                   	ret    
80105f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f30 <uartinit>:
void uartinit(void) {
80105f30:	55                   	push   %ebp
80105f31:	31 c9                	xor    %ecx,%ecx
80105f33:	89 c8                	mov    %ecx,%eax
80105f35:	89 e5                	mov    %esp,%ebp
80105f37:	57                   	push   %edi
80105f38:	56                   	push   %esi
80105f39:	53                   	push   %ebx
80105f3a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105f3f:	89 da                	mov    %ebx,%edx
80105f41:	83 ec 0c             	sub    $0xc,%esp
80105f44:	ee                   	out    %al,(%dx)
80105f45:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105f4a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f4f:	89 fa                	mov    %edi,%edx
80105f51:	ee                   	out    %al,(%dx)
80105f52:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f57:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f5c:	ee                   	out    %al,(%dx)
80105f5d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105f62:	89 c8                	mov    %ecx,%eax
80105f64:	89 f2                	mov    %esi,%edx
80105f66:	ee                   	out    %al,(%dx)
80105f67:	b8 03 00 00 00       	mov    $0x3,%eax
80105f6c:	89 fa                	mov    %edi,%edx
80105f6e:	ee                   	out    %al,(%dx)
80105f6f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f74:	89 c8                	mov    %ecx,%eax
80105f76:	ee                   	out    %al,(%dx)
80105f77:	b8 01 00 00 00       	mov    $0x1,%eax
80105f7c:	89 f2                	mov    %esi,%edx
80105f7e:	ee                   	out    %al,(%dx)
    asm volatile ("in %1,%0" : "=a" (data) : "d" (port));
80105f7f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f84:	ec                   	in     (%dx),%al
    if (inb(COM1 + 5) == 0xFF) {
80105f85:	3c ff                	cmp    $0xff,%al
80105f87:	74 5a                	je     80105fe3 <uartinit+0xb3>
    uart = 1;
80105f89:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80105f90:	00 00 00 
80105f93:	89 da                	mov    %ebx,%edx
80105f95:	ec                   	in     (%dx),%al
80105f96:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f9b:	ec                   	in     (%dx),%al
    ioapicenable(IRQ_COM1, 0);
80105f9c:	83 ec 08             	sub    $0x8,%esp
    for (p = "xv6...\n"; *p; p++) {
80105f9f:	bb e4 7c 10 80       	mov    $0x80107ce4,%ebx
    ioapicenable(IRQ_COM1, 0);
80105fa4:	6a 00                	push   $0x0
80105fa6:	6a 04                	push   $0x4
80105fa8:	e8 43 c7 ff ff       	call   801026f0 <ioapicenable>
80105fad:	83 c4 10             	add    $0x10,%esp
    for (p = "xv6...\n"; *p; p++) {
80105fb0:	b8 78 00 00 00       	mov    $0x78,%eax
80105fb5:	eb 13                	jmp    80105fca <uartinit+0x9a>
80105fb7:	89 f6                	mov    %esi,%esi
80105fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105fc0:	83 c3 01             	add    $0x1,%ebx
80105fc3:	0f be 03             	movsbl (%ebx),%eax
80105fc6:	84 c0                	test   %al,%al
80105fc8:	74 19                	je     80105fe3 <uartinit+0xb3>
    if (!uart) {
80105fca:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80105fd0:	85 d2                	test   %edx,%edx
80105fd2:	74 ec                	je     80105fc0 <uartinit+0x90>
    for (p = "xv6...\n"; *p; p++) {
80105fd4:	83 c3 01             	add    $0x1,%ebx
80105fd7:	e8 04 ff ff ff       	call   80105ee0 <uartputc.part.0>
80105fdc:	0f be 03             	movsbl (%ebx),%eax
80105fdf:	84 c0                	test   %al,%al
80105fe1:	75 e7                	jne    80105fca <uartinit+0x9a>
}
80105fe3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fe6:	5b                   	pop    %ebx
80105fe7:	5e                   	pop    %esi
80105fe8:	5f                   	pop    %edi
80105fe9:	5d                   	pop    %ebp
80105fea:	c3                   	ret    
80105feb:	90                   	nop
80105fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ff0 <uartputc>:
    if (!uart) {
80105ff0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
void uartputc(int c) {
80105ff6:	55                   	push   %ebp
80105ff7:	89 e5                	mov    %esp,%ebp
    if (!uart) {
80105ff9:	85 d2                	test   %edx,%edx
void uartputc(int c) {
80105ffb:	8b 45 08             	mov    0x8(%ebp),%eax
    if (!uart) {
80105ffe:	74 10                	je     80106010 <uartputc+0x20>
}
80106000:	5d                   	pop    %ebp
80106001:	e9 da fe ff ff       	jmp    80105ee0 <uartputc.part.0>
80106006:	8d 76 00             	lea    0x0(%esi),%esi
80106009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106010:	5d                   	pop    %ebp
80106011:	c3                   	ret    
80106012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106020 <uartintr>:

void uartintr(void) {
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	83 ec 14             	sub    $0x14,%esp
    consoleintr(uartgetc);
80106026:	68 b0 5e 10 80       	push   $0x80105eb0
8010602b:	e8 20 a9 ff ff       	call   80100950 <consoleintr>
}
80106030:	83 c4 10             	add    $0x10,%esp
80106033:	c9                   	leave  
80106034:	c3                   	ret    

80106035 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106035:	6a 00                	push   $0x0
  pushl $0
80106037:	6a 00                	push   $0x0
  jmp alltraps
80106039:	e9 19 fb ff ff       	jmp    80105b57 <alltraps>

8010603e <vector1>:
.globl vector1
vector1:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $1
80106040:	6a 01                	push   $0x1
  jmp alltraps
80106042:	e9 10 fb ff ff       	jmp    80105b57 <alltraps>

80106047 <vector2>:
.globl vector2
vector2:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $2
80106049:	6a 02                	push   $0x2
  jmp alltraps
8010604b:	e9 07 fb ff ff       	jmp    80105b57 <alltraps>

80106050 <vector3>:
.globl vector3
vector3:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $3
80106052:	6a 03                	push   $0x3
  jmp alltraps
80106054:	e9 fe fa ff ff       	jmp    80105b57 <alltraps>

80106059 <vector4>:
.globl vector4
vector4:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $4
8010605b:	6a 04                	push   $0x4
  jmp alltraps
8010605d:	e9 f5 fa ff ff       	jmp    80105b57 <alltraps>

80106062 <vector5>:
.globl vector5
vector5:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $5
80106064:	6a 05                	push   $0x5
  jmp alltraps
80106066:	e9 ec fa ff ff       	jmp    80105b57 <alltraps>

8010606b <vector6>:
.globl vector6
vector6:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $6
8010606d:	6a 06                	push   $0x6
  jmp alltraps
8010606f:	e9 e3 fa ff ff       	jmp    80105b57 <alltraps>

80106074 <vector7>:
.globl vector7
vector7:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $7
80106076:	6a 07                	push   $0x7
  jmp alltraps
80106078:	e9 da fa ff ff       	jmp    80105b57 <alltraps>

8010607d <vector8>:
.globl vector8
vector8:
  pushl $8
8010607d:	6a 08                	push   $0x8
  jmp alltraps
8010607f:	e9 d3 fa ff ff       	jmp    80105b57 <alltraps>

80106084 <vector9>:
.globl vector9
vector9:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $9
80106086:	6a 09                	push   $0x9
  jmp alltraps
80106088:	e9 ca fa ff ff       	jmp    80105b57 <alltraps>

8010608d <vector10>:
.globl vector10
vector10:
  pushl $10
8010608d:	6a 0a                	push   $0xa
  jmp alltraps
8010608f:	e9 c3 fa ff ff       	jmp    80105b57 <alltraps>

80106094 <vector11>:
.globl vector11
vector11:
  pushl $11
80106094:	6a 0b                	push   $0xb
  jmp alltraps
80106096:	e9 bc fa ff ff       	jmp    80105b57 <alltraps>

8010609b <vector12>:
.globl vector12
vector12:
  pushl $12
8010609b:	6a 0c                	push   $0xc
  jmp alltraps
8010609d:	e9 b5 fa ff ff       	jmp    80105b57 <alltraps>

801060a2 <vector13>:
.globl vector13
vector13:
  pushl $13
801060a2:	6a 0d                	push   $0xd
  jmp alltraps
801060a4:	e9 ae fa ff ff       	jmp    80105b57 <alltraps>

801060a9 <vector14>:
.globl vector14
vector14:
  pushl $14
801060a9:	6a 0e                	push   $0xe
  jmp alltraps
801060ab:	e9 a7 fa ff ff       	jmp    80105b57 <alltraps>

801060b0 <vector15>:
.globl vector15
vector15:
  pushl $0
801060b0:	6a 00                	push   $0x0
  pushl $15
801060b2:	6a 0f                	push   $0xf
  jmp alltraps
801060b4:	e9 9e fa ff ff       	jmp    80105b57 <alltraps>

801060b9 <vector16>:
.globl vector16
vector16:
  pushl $0
801060b9:	6a 00                	push   $0x0
  pushl $16
801060bb:	6a 10                	push   $0x10
  jmp alltraps
801060bd:	e9 95 fa ff ff       	jmp    80105b57 <alltraps>

801060c2 <vector17>:
.globl vector17
vector17:
  pushl $17
801060c2:	6a 11                	push   $0x11
  jmp alltraps
801060c4:	e9 8e fa ff ff       	jmp    80105b57 <alltraps>

801060c9 <vector18>:
.globl vector18
vector18:
  pushl $0
801060c9:	6a 00                	push   $0x0
  pushl $18
801060cb:	6a 12                	push   $0x12
  jmp alltraps
801060cd:	e9 85 fa ff ff       	jmp    80105b57 <alltraps>

801060d2 <vector19>:
.globl vector19
vector19:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $19
801060d4:	6a 13                	push   $0x13
  jmp alltraps
801060d6:	e9 7c fa ff ff       	jmp    80105b57 <alltraps>

801060db <vector20>:
.globl vector20
vector20:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $20
801060dd:	6a 14                	push   $0x14
  jmp alltraps
801060df:	e9 73 fa ff ff       	jmp    80105b57 <alltraps>

801060e4 <vector21>:
.globl vector21
vector21:
  pushl $0
801060e4:	6a 00                	push   $0x0
  pushl $21
801060e6:	6a 15                	push   $0x15
  jmp alltraps
801060e8:	e9 6a fa ff ff       	jmp    80105b57 <alltraps>

801060ed <vector22>:
.globl vector22
vector22:
  pushl $0
801060ed:	6a 00                	push   $0x0
  pushl $22
801060ef:	6a 16                	push   $0x16
  jmp alltraps
801060f1:	e9 61 fa ff ff       	jmp    80105b57 <alltraps>

801060f6 <vector23>:
.globl vector23
vector23:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $23
801060f8:	6a 17                	push   $0x17
  jmp alltraps
801060fa:	e9 58 fa ff ff       	jmp    80105b57 <alltraps>

801060ff <vector24>:
.globl vector24
vector24:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $24
80106101:	6a 18                	push   $0x18
  jmp alltraps
80106103:	e9 4f fa ff ff       	jmp    80105b57 <alltraps>

80106108 <vector25>:
.globl vector25
vector25:
  pushl $0
80106108:	6a 00                	push   $0x0
  pushl $25
8010610a:	6a 19                	push   $0x19
  jmp alltraps
8010610c:	e9 46 fa ff ff       	jmp    80105b57 <alltraps>

80106111 <vector26>:
.globl vector26
vector26:
  pushl $0
80106111:	6a 00                	push   $0x0
  pushl $26
80106113:	6a 1a                	push   $0x1a
  jmp alltraps
80106115:	e9 3d fa ff ff       	jmp    80105b57 <alltraps>

8010611a <vector27>:
.globl vector27
vector27:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $27
8010611c:	6a 1b                	push   $0x1b
  jmp alltraps
8010611e:	e9 34 fa ff ff       	jmp    80105b57 <alltraps>

80106123 <vector28>:
.globl vector28
vector28:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $28
80106125:	6a 1c                	push   $0x1c
  jmp alltraps
80106127:	e9 2b fa ff ff       	jmp    80105b57 <alltraps>

8010612c <vector29>:
.globl vector29
vector29:
  pushl $0
8010612c:	6a 00                	push   $0x0
  pushl $29
8010612e:	6a 1d                	push   $0x1d
  jmp alltraps
80106130:	e9 22 fa ff ff       	jmp    80105b57 <alltraps>

80106135 <vector30>:
.globl vector30
vector30:
  pushl $0
80106135:	6a 00                	push   $0x0
  pushl $30
80106137:	6a 1e                	push   $0x1e
  jmp alltraps
80106139:	e9 19 fa ff ff       	jmp    80105b57 <alltraps>

8010613e <vector31>:
.globl vector31
vector31:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $31
80106140:	6a 1f                	push   $0x1f
  jmp alltraps
80106142:	e9 10 fa ff ff       	jmp    80105b57 <alltraps>

80106147 <vector32>:
.globl vector32
vector32:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $32
80106149:	6a 20                	push   $0x20
  jmp alltraps
8010614b:	e9 07 fa ff ff       	jmp    80105b57 <alltraps>

80106150 <vector33>:
.globl vector33
vector33:
  pushl $0
80106150:	6a 00                	push   $0x0
  pushl $33
80106152:	6a 21                	push   $0x21
  jmp alltraps
80106154:	e9 fe f9 ff ff       	jmp    80105b57 <alltraps>

80106159 <vector34>:
.globl vector34
vector34:
  pushl $0
80106159:	6a 00                	push   $0x0
  pushl $34
8010615b:	6a 22                	push   $0x22
  jmp alltraps
8010615d:	e9 f5 f9 ff ff       	jmp    80105b57 <alltraps>

80106162 <vector35>:
.globl vector35
vector35:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $35
80106164:	6a 23                	push   $0x23
  jmp alltraps
80106166:	e9 ec f9 ff ff       	jmp    80105b57 <alltraps>

8010616b <vector36>:
.globl vector36
vector36:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $36
8010616d:	6a 24                	push   $0x24
  jmp alltraps
8010616f:	e9 e3 f9 ff ff       	jmp    80105b57 <alltraps>

80106174 <vector37>:
.globl vector37
vector37:
  pushl $0
80106174:	6a 00                	push   $0x0
  pushl $37
80106176:	6a 25                	push   $0x25
  jmp alltraps
80106178:	e9 da f9 ff ff       	jmp    80105b57 <alltraps>

8010617d <vector38>:
.globl vector38
vector38:
  pushl $0
8010617d:	6a 00                	push   $0x0
  pushl $38
8010617f:	6a 26                	push   $0x26
  jmp alltraps
80106181:	e9 d1 f9 ff ff       	jmp    80105b57 <alltraps>

80106186 <vector39>:
.globl vector39
vector39:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $39
80106188:	6a 27                	push   $0x27
  jmp alltraps
8010618a:	e9 c8 f9 ff ff       	jmp    80105b57 <alltraps>

8010618f <vector40>:
.globl vector40
vector40:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $40
80106191:	6a 28                	push   $0x28
  jmp alltraps
80106193:	e9 bf f9 ff ff       	jmp    80105b57 <alltraps>

80106198 <vector41>:
.globl vector41
vector41:
  pushl $0
80106198:	6a 00                	push   $0x0
  pushl $41
8010619a:	6a 29                	push   $0x29
  jmp alltraps
8010619c:	e9 b6 f9 ff ff       	jmp    80105b57 <alltraps>

801061a1 <vector42>:
.globl vector42
vector42:
  pushl $0
801061a1:	6a 00                	push   $0x0
  pushl $42
801061a3:	6a 2a                	push   $0x2a
  jmp alltraps
801061a5:	e9 ad f9 ff ff       	jmp    80105b57 <alltraps>

801061aa <vector43>:
.globl vector43
vector43:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $43
801061ac:	6a 2b                	push   $0x2b
  jmp alltraps
801061ae:	e9 a4 f9 ff ff       	jmp    80105b57 <alltraps>

801061b3 <vector44>:
.globl vector44
vector44:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $44
801061b5:	6a 2c                	push   $0x2c
  jmp alltraps
801061b7:	e9 9b f9 ff ff       	jmp    80105b57 <alltraps>

801061bc <vector45>:
.globl vector45
vector45:
  pushl $0
801061bc:	6a 00                	push   $0x0
  pushl $45
801061be:	6a 2d                	push   $0x2d
  jmp alltraps
801061c0:	e9 92 f9 ff ff       	jmp    80105b57 <alltraps>

801061c5 <vector46>:
.globl vector46
vector46:
  pushl $0
801061c5:	6a 00                	push   $0x0
  pushl $46
801061c7:	6a 2e                	push   $0x2e
  jmp alltraps
801061c9:	e9 89 f9 ff ff       	jmp    80105b57 <alltraps>

801061ce <vector47>:
.globl vector47
vector47:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $47
801061d0:	6a 2f                	push   $0x2f
  jmp alltraps
801061d2:	e9 80 f9 ff ff       	jmp    80105b57 <alltraps>

801061d7 <vector48>:
.globl vector48
vector48:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $48
801061d9:	6a 30                	push   $0x30
  jmp alltraps
801061db:	e9 77 f9 ff ff       	jmp    80105b57 <alltraps>

801061e0 <vector49>:
.globl vector49
vector49:
  pushl $0
801061e0:	6a 00                	push   $0x0
  pushl $49
801061e2:	6a 31                	push   $0x31
  jmp alltraps
801061e4:	e9 6e f9 ff ff       	jmp    80105b57 <alltraps>

801061e9 <vector50>:
.globl vector50
vector50:
  pushl $0
801061e9:	6a 00                	push   $0x0
  pushl $50
801061eb:	6a 32                	push   $0x32
  jmp alltraps
801061ed:	e9 65 f9 ff ff       	jmp    80105b57 <alltraps>

801061f2 <vector51>:
.globl vector51
vector51:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $51
801061f4:	6a 33                	push   $0x33
  jmp alltraps
801061f6:	e9 5c f9 ff ff       	jmp    80105b57 <alltraps>

801061fb <vector52>:
.globl vector52
vector52:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $52
801061fd:	6a 34                	push   $0x34
  jmp alltraps
801061ff:	e9 53 f9 ff ff       	jmp    80105b57 <alltraps>

80106204 <vector53>:
.globl vector53
vector53:
  pushl $0
80106204:	6a 00                	push   $0x0
  pushl $53
80106206:	6a 35                	push   $0x35
  jmp alltraps
80106208:	e9 4a f9 ff ff       	jmp    80105b57 <alltraps>

8010620d <vector54>:
.globl vector54
vector54:
  pushl $0
8010620d:	6a 00                	push   $0x0
  pushl $54
8010620f:	6a 36                	push   $0x36
  jmp alltraps
80106211:	e9 41 f9 ff ff       	jmp    80105b57 <alltraps>

80106216 <vector55>:
.globl vector55
vector55:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $55
80106218:	6a 37                	push   $0x37
  jmp alltraps
8010621a:	e9 38 f9 ff ff       	jmp    80105b57 <alltraps>

8010621f <vector56>:
.globl vector56
vector56:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $56
80106221:	6a 38                	push   $0x38
  jmp alltraps
80106223:	e9 2f f9 ff ff       	jmp    80105b57 <alltraps>

80106228 <vector57>:
.globl vector57
vector57:
  pushl $0
80106228:	6a 00                	push   $0x0
  pushl $57
8010622a:	6a 39                	push   $0x39
  jmp alltraps
8010622c:	e9 26 f9 ff ff       	jmp    80105b57 <alltraps>

80106231 <vector58>:
.globl vector58
vector58:
  pushl $0
80106231:	6a 00                	push   $0x0
  pushl $58
80106233:	6a 3a                	push   $0x3a
  jmp alltraps
80106235:	e9 1d f9 ff ff       	jmp    80105b57 <alltraps>

8010623a <vector59>:
.globl vector59
vector59:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $59
8010623c:	6a 3b                	push   $0x3b
  jmp alltraps
8010623e:	e9 14 f9 ff ff       	jmp    80105b57 <alltraps>

80106243 <vector60>:
.globl vector60
vector60:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $60
80106245:	6a 3c                	push   $0x3c
  jmp alltraps
80106247:	e9 0b f9 ff ff       	jmp    80105b57 <alltraps>

8010624c <vector61>:
.globl vector61
vector61:
  pushl $0
8010624c:	6a 00                	push   $0x0
  pushl $61
8010624e:	6a 3d                	push   $0x3d
  jmp alltraps
80106250:	e9 02 f9 ff ff       	jmp    80105b57 <alltraps>

80106255 <vector62>:
.globl vector62
vector62:
  pushl $0
80106255:	6a 00                	push   $0x0
  pushl $62
80106257:	6a 3e                	push   $0x3e
  jmp alltraps
80106259:	e9 f9 f8 ff ff       	jmp    80105b57 <alltraps>

8010625e <vector63>:
.globl vector63
vector63:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $63
80106260:	6a 3f                	push   $0x3f
  jmp alltraps
80106262:	e9 f0 f8 ff ff       	jmp    80105b57 <alltraps>

80106267 <vector64>:
.globl vector64
vector64:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $64
80106269:	6a 40                	push   $0x40
  jmp alltraps
8010626b:	e9 e7 f8 ff ff       	jmp    80105b57 <alltraps>

80106270 <vector65>:
.globl vector65
vector65:
  pushl $0
80106270:	6a 00                	push   $0x0
  pushl $65
80106272:	6a 41                	push   $0x41
  jmp alltraps
80106274:	e9 de f8 ff ff       	jmp    80105b57 <alltraps>

80106279 <vector66>:
.globl vector66
vector66:
  pushl $0
80106279:	6a 00                	push   $0x0
  pushl $66
8010627b:	6a 42                	push   $0x42
  jmp alltraps
8010627d:	e9 d5 f8 ff ff       	jmp    80105b57 <alltraps>

80106282 <vector67>:
.globl vector67
vector67:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $67
80106284:	6a 43                	push   $0x43
  jmp alltraps
80106286:	e9 cc f8 ff ff       	jmp    80105b57 <alltraps>

8010628b <vector68>:
.globl vector68
vector68:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $68
8010628d:	6a 44                	push   $0x44
  jmp alltraps
8010628f:	e9 c3 f8 ff ff       	jmp    80105b57 <alltraps>

80106294 <vector69>:
.globl vector69
vector69:
  pushl $0
80106294:	6a 00                	push   $0x0
  pushl $69
80106296:	6a 45                	push   $0x45
  jmp alltraps
80106298:	e9 ba f8 ff ff       	jmp    80105b57 <alltraps>

8010629d <vector70>:
.globl vector70
vector70:
  pushl $0
8010629d:	6a 00                	push   $0x0
  pushl $70
8010629f:	6a 46                	push   $0x46
  jmp alltraps
801062a1:	e9 b1 f8 ff ff       	jmp    80105b57 <alltraps>

801062a6 <vector71>:
.globl vector71
vector71:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $71
801062a8:	6a 47                	push   $0x47
  jmp alltraps
801062aa:	e9 a8 f8 ff ff       	jmp    80105b57 <alltraps>

801062af <vector72>:
.globl vector72
vector72:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $72
801062b1:	6a 48                	push   $0x48
  jmp alltraps
801062b3:	e9 9f f8 ff ff       	jmp    80105b57 <alltraps>

801062b8 <vector73>:
.globl vector73
vector73:
  pushl $0
801062b8:	6a 00                	push   $0x0
  pushl $73
801062ba:	6a 49                	push   $0x49
  jmp alltraps
801062bc:	e9 96 f8 ff ff       	jmp    80105b57 <alltraps>

801062c1 <vector74>:
.globl vector74
vector74:
  pushl $0
801062c1:	6a 00                	push   $0x0
  pushl $74
801062c3:	6a 4a                	push   $0x4a
  jmp alltraps
801062c5:	e9 8d f8 ff ff       	jmp    80105b57 <alltraps>

801062ca <vector75>:
.globl vector75
vector75:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $75
801062cc:	6a 4b                	push   $0x4b
  jmp alltraps
801062ce:	e9 84 f8 ff ff       	jmp    80105b57 <alltraps>

801062d3 <vector76>:
.globl vector76
vector76:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $76
801062d5:	6a 4c                	push   $0x4c
  jmp alltraps
801062d7:	e9 7b f8 ff ff       	jmp    80105b57 <alltraps>

801062dc <vector77>:
.globl vector77
vector77:
  pushl $0
801062dc:	6a 00                	push   $0x0
  pushl $77
801062de:	6a 4d                	push   $0x4d
  jmp alltraps
801062e0:	e9 72 f8 ff ff       	jmp    80105b57 <alltraps>

801062e5 <vector78>:
.globl vector78
vector78:
  pushl $0
801062e5:	6a 00                	push   $0x0
  pushl $78
801062e7:	6a 4e                	push   $0x4e
  jmp alltraps
801062e9:	e9 69 f8 ff ff       	jmp    80105b57 <alltraps>

801062ee <vector79>:
.globl vector79
vector79:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $79
801062f0:	6a 4f                	push   $0x4f
  jmp alltraps
801062f2:	e9 60 f8 ff ff       	jmp    80105b57 <alltraps>

801062f7 <vector80>:
.globl vector80
vector80:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $80
801062f9:	6a 50                	push   $0x50
  jmp alltraps
801062fb:	e9 57 f8 ff ff       	jmp    80105b57 <alltraps>

80106300 <vector81>:
.globl vector81
vector81:
  pushl $0
80106300:	6a 00                	push   $0x0
  pushl $81
80106302:	6a 51                	push   $0x51
  jmp alltraps
80106304:	e9 4e f8 ff ff       	jmp    80105b57 <alltraps>

80106309 <vector82>:
.globl vector82
vector82:
  pushl $0
80106309:	6a 00                	push   $0x0
  pushl $82
8010630b:	6a 52                	push   $0x52
  jmp alltraps
8010630d:	e9 45 f8 ff ff       	jmp    80105b57 <alltraps>

80106312 <vector83>:
.globl vector83
vector83:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $83
80106314:	6a 53                	push   $0x53
  jmp alltraps
80106316:	e9 3c f8 ff ff       	jmp    80105b57 <alltraps>

8010631b <vector84>:
.globl vector84
vector84:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $84
8010631d:	6a 54                	push   $0x54
  jmp alltraps
8010631f:	e9 33 f8 ff ff       	jmp    80105b57 <alltraps>

80106324 <vector85>:
.globl vector85
vector85:
  pushl $0
80106324:	6a 00                	push   $0x0
  pushl $85
80106326:	6a 55                	push   $0x55
  jmp alltraps
80106328:	e9 2a f8 ff ff       	jmp    80105b57 <alltraps>

8010632d <vector86>:
.globl vector86
vector86:
  pushl $0
8010632d:	6a 00                	push   $0x0
  pushl $86
8010632f:	6a 56                	push   $0x56
  jmp alltraps
80106331:	e9 21 f8 ff ff       	jmp    80105b57 <alltraps>

80106336 <vector87>:
.globl vector87
vector87:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $87
80106338:	6a 57                	push   $0x57
  jmp alltraps
8010633a:	e9 18 f8 ff ff       	jmp    80105b57 <alltraps>

8010633f <vector88>:
.globl vector88
vector88:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $88
80106341:	6a 58                	push   $0x58
  jmp alltraps
80106343:	e9 0f f8 ff ff       	jmp    80105b57 <alltraps>

80106348 <vector89>:
.globl vector89
vector89:
  pushl $0
80106348:	6a 00                	push   $0x0
  pushl $89
8010634a:	6a 59                	push   $0x59
  jmp alltraps
8010634c:	e9 06 f8 ff ff       	jmp    80105b57 <alltraps>

80106351 <vector90>:
.globl vector90
vector90:
  pushl $0
80106351:	6a 00                	push   $0x0
  pushl $90
80106353:	6a 5a                	push   $0x5a
  jmp alltraps
80106355:	e9 fd f7 ff ff       	jmp    80105b57 <alltraps>

8010635a <vector91>:
.globl vector91
vector91:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $91
8010635c:	6a 5b                	push   $0x5b
  jmp alltraps
8010635e:	e9 f4 f7 ff ff       	jmp    80105b57 <alltraps>

80106363 <vector92>:
.globl vector92
vector92:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $92
80106365:	6a 5c                	push   $0x5c
  jmp alltraps
80106367:	e9 eb f7 ff ff       	jmp    80105b57 <alltraps>

8010636c <vector93>:
.globl vector93
vector93:
  pushl $0
8010636c:	6a 00                	push   $0x0
  pushl $93
8010636e:	6a 5d                	push   $0x5d
  jmp alltraps
80106370:	e9 e2 f7 ff ff       	jmp    80105b57 <alltraps>

80106375 <vector94>:
.globl vector94
vector94:
  pushl $0
80106375:	6a 00                	push   $0x0
  pushl $94
80106377:	6a 5e                	push   $0x5e
  jmp alltraps
80106379:	e9 d9 f7 ff ff       	jmp    80105b57 <alltraps>

8010637e <vector95>:
.globl vector95
vector95:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $95
80106380:	6a 5f                	push   $0x5f
  jmp alltraps
80106382:	e9 d0 f7 ff ff       	jmp    80105b57 <alltraps>

80106387 <vector96>:
.globl vector96
vector96:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $96
80106389:	6a 60                	push   $0x60
  jmp alltraps
8010638b:	e9 c7 f7 ff ff       	jmp    80105b57 <alltraps>

80106390 <vector97>:
.globl vector97
vector97:
  pushl $0
80106390:	6a 00                	push   $0x0
  pushl $97
80106392:	6a 61                	push   $0x61
  jmp alltraps
80106394:	e9 be f7 ff ff       	jmp    80105b57 <alltraps>

80106399 <vector98>:
.globl vector98
vector98:
  pushl $0
80106399:	6a 00                	push   $0x0
  pushl $98
8010639b:	6a 62                	push   $0x62
  jmp alltraps
8010639d:	e9 b5 f7 ff ff       	jmp    80105b57 <alltraps>

801063a2 <vector99>:
.globl vector99
vector99:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $99
801063a4:	6a 63                	push   $0x63
  jmp alltraps
801063a6:	e9 ac f7 ff ff       	jmp    80105b57 <alltraps>

801063ab <vector100>:
.globl vector100
vector100:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $100
801063ad:	6a 64                	push   $0x64
  jmp alltraps
801063af:	e9 a3 f7 ff ff       	jmp    80105b57 <alltraps>

801063b4 <vector101>:
.globl vector101
vector101:
  pushl $0
801063b4:	6a 00                	push   $0x0
  pushl $101
801063b6:	6a 65                	push   $0x65
  jmp alltraps
801063b8:	e9 9a f7 ff ff       	jmp    80105b57 <alltraps>

801063bd <vector102>:
.globl vector102
vector102:
  pushl $0
801063bd:	6a 00                	push   $0x0
  pushl $102
801063bf:	6a 66                	push   $0x66
  jmp alltraps
801063c1:	e9 91 f7 ff ff       	jmp    80105b57 <alltraps>

801063c6 <vector103>:
.globl vector103
vector103:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $103
801063c8:	6a 67                	push   $0x67
  jmp alltraps
801063ca:	e9 88 f7 ff ff       	jmp    80105b57 <alltraps>

801063cf <vector104>:
.globl vector104
vector104:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $104
801063d1:	6a 68                	push   $0x68
  jmp alltraps
801063d3:	e9 7f f7 ff ff       	jmp    80105b57 <alltraps>

801063d8 <vector105>:
.globl vector105
vector105:
  pushl $0
801063d8:	6a 00                	push   $0x0
  pushl $105
801063da:	6a 69                	push   $0x69
  jmp alltraps
801063dc:	e9 76 f7 ff ff       	jmp    80105b57 <alltraps>

801063e1 <vector106>:
.globl vector106
vector106:
  pushl $0
801063e1:	6a 00                	push   $0x0
  pushl $106
801063e3:	6a 6a                	push   $0x6a
  jmp alltraps
801063e5:	e9 6d f7 ff ff       	jmp    80105b57 <alltraps>

801063ea <vector107>:
.globl vector107
vector107:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $107
801063ec:	6a 6b                	push   $0x6b
  jmp alltraps
801063ee:	e9 64 f7 ff ff       	jmp    80105b57 <alltraps>

801063f3 <vector108>:
.globl vector108
vector108:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $108
801063f5:	6a 6c                	push   $0x6c
  jmp alltraps
801063f7:	e9 5b f7 ff ff       	jmp    80105b57 <alltraps>

801063fc <vector109>:
.globl vector109
vector109:
  pushl $0
801063fc:	6a 00                	push   $0x0
  pushl $109
801063fe:	6a 6d                	push   $0x6d
  jmp alltraps
80106400:	e9 52 f7 ff ff       	jmp    80105b57 <alltraps>

80106405 <vector110>:
.globl vector110
vector110:
  pushl $0
80106405:	6a 00                	push   $0x0
  pushl $110
80106407:	6a 6e                	push   $0x6e
  jmp alltraps
80106409:	e9 49 f7 ff ff       	jmp    80105b57 <alltraps>

8010640e <vector111>:
.globl vector111
vector111:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $111
80106410:	6a 6f                	push   $0x6f
  jmp alltraps
80106412:	e9 40 f7 ff ff       	jmp    80105b57 <alltraps>

80106417 <vector112>:
.globl vector112
vector112:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $112
80106419:	6a 70                	push   $0x70
  jmp alltraps
8010641b:	e9 37 f7 ff ff       	jmp    80105b57 <alltraps>

80106420 <vector113>:
.globl vector113
vector113:
  pushl $0
80106420:	6a 00                	push   $0x0
  pushl $113
80106422:	6a 71                	push   $0x71
  jmp alltraps
80106424:	e9 2e f7 ff ff       	jmp    80105b57 <alltraps>

80106429 <vector114>:
.globl vector114
vector114:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $114
8010642b:	6a 72                	push   $0x72
  jmp alltraps
8010642d:	e9 25 f7 ff ff       	jmp    80105b57 <alltraps>

80106432 <vector115>:
.globl vector115
vector115:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $115
80106434:	6a 73                	push   $0x73
  jmp alltraps
80106436:	e9 1c f7 ff ff       	jmp    80105b57 <alltraps>

8010643b <vector116>:
.globl vector116
vector116:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $116
8010643d:	6a 74                	push   $0x74
  jmp alltraps
8010643f:	e9 13 f7 ff ff       	jmp    80105b57 <alltraps>

80106444 <vector117>:
.globl vector117
vector117:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $117
80106446:	6a 75                	push   $0x75
  jmp alltraps
80106448:	e9 0a f7 ff ff       	jmp    80105b57 <alltraps>

8010644d <vector118>:
.globl vector118
vector118:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $118
8010644f:	6a 76                	push   $0x76
  jmp alltraps
80106451:	e9 01 f7 ff ff       	jmp    80105b57 <alltraps>

80106456 <vector119>:
.globl vector119
vector119:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $119
80106458:	6a 77                	push   $0x77
  jmp alltraps
8010645a:	e9 f8 f6 ff ff       	jmp    80105b57 <alltraps>

8010645f <vector120>:
.globl vector120
vector120:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $120
80106461:	6a 78                	push   $0x78
  jmp alltraps
80106463:	e9 ef f6 ff ff       	jmp    80105b57 <alltraps>

80106468 <vector121>:
.globl vector121
vector121:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $121
8010646a:	6a 79                	push   $0x79
  jmp alltraps
8010646c:	e9 e6 f6 ff ff       	jmp    80105b57 <alltraps>

80106471 <vector122>:
.globl vector122
vector122:
  pushl $0
80106471:	6a 00                	push   $0x0
  pushl $122
80106473:	6a 7a                	push   $0x7a
  jmp alltraps
80106475:	e9 dd f6 ff ff       	jmp    80105b57 <alltraps>

8010647a <vector123>:
.globl vector123
vector123:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $123
8010647c:	6a 7b                	push   $0x7b
  jmp alltraps
8010647e:	e9 d4 f6 ff ff       	jmp    80105b57 <alltraps>

80106483 <vector124>:
.globl vector124
vector124:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $124
80106485:	6a 7c                	push   $0x7c
  jmp alltraps
80106487:	e9 cb f6 ff ff       	jmp    80105b57 <alltraps>

8010648c <vector125>:
.globl vector125
vector125:
  pushl $0
8010648c:	6a 00                	push   $0x0
  pushl $125
8010648e:	6a 7d                	push   $0x7d
  jmp alltraps
80106490:	e9 c2 f6 ff ff       	jmp    80105b57 <alltraps>

80106495 <vector126>:
.globl vector126
vector126:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $126
80106497:	6a 7e                	push   $0x7e
  jmp alltraps
80106499:	e9 b9 f6 ff ff       	jmp    80105b57 <alltraps>

8010649e <vector127>:
.globl vector127
vector127:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $127
801064a0:	6a 7f                	push   $0x7f
  jmp alltraps
801064a2:	e9 b0 f6 ff ff       	jmp    80105b57 <alltraps>

801064a7 <vector128>:
.globl vector128
vector128:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $128
801064a9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064ae:	e9 a4 f6 ff ff       	jmp    80105b57 <alltraps>

801064b3 <vector129>:
.globl vector129
vector129:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $129
801064b5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064ba:	e9 98 f6 ff ff       	jmp    80105b57 <alltraps>

801064bf <vector130>:
.globl vector130
vector130:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $130
801064c1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801064c6:	e9 8c f6 ff ff       	jmp    80105b57 <alltraps>

801064cb <vector131>:
.globl vector131
vector131:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $131
801064cd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801064d2:	e9 80 f6 ff ff       	jmp    80105b57 <alltraps>

801064d7 <vector132>:
.globl vector132
vector132:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $132
801064d9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801064de:	e9 74 f6 ff ff       	jmp    80105b57 <alltraps>

801064e3 <vector133>:
.globl vector133
vector133:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $133
801064e5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801064ea:	e9 68 f6 ff ff       	jmp    80105b57 <alltraps>

801064ef <vector134>:
.globl vector134
vector134:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $134
801064f1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801064f6:	e9 5c f6 ff ff       	jmp    80105b57 <alltraps>

801064fb <vector135>:
.globl vector135
vector135:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $135
801064fd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106502:	e9 50 f6 ff ff       	jmp    80105b57 <alltraps>

80106507 <vector136>:
.globl vector136
vector136:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $136
80106509:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010650e:	e9 44 f6 ff ff       	jmp    80105b57 <alltraps>

80106513 <vector137>:
.globl vector137
vector137:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $137
80106515:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010651a:	e9 38 f6 ff ff       	jmp    80105b57 <alltraps>

8010651f <vector138>:
.globl vector138
vector138:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $138
80106521:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106526:	e9 2c f6 ff ff       	jmp    80105b57 <alltraps>

8010652b <vector139>:
.globl vector139
vector139:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $139
8010652d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106532:	e9 20 f6 ff ff       	jmp    80105b57 <alltraps>

80106537 <vector140>:
.globl vector140
vector140:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $140
80106539:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010653e:	e9 14 f6 ff ff       	jmp    80105b57 <alltraps>

80106543 <vector141>:
.globl vector141
vector141:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $141
80106545:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010654a:	e9 08 f6 ff ff       	jmp    80105b57 <alltraps>

8010654f <vector142>:
.globl vector142
vector142:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $142
80106551:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106556:	e9 fc f5 ff ff       	jmp    80105b57 <alltraps>

8010655b <vector143>:
.globl vector143
vector143:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $143
8010655d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106562:	e9 f0 f5 ff ff       	jmp    80105b57 <alltraps>

80106567 <vector144>:
.globl vector144
vector144:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $144
80106569:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010656e:	e9 e4 f5 ff ff       	jmp    80105b57 <alltraps>

80106573 <vector145>:
.globl vector145
vector145:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $145
80106575:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010657a:	e9 d8 f5 ff ff       	jmp    80105b57 <alltraps>

8010657f <vector146>:
.globl vector146
vector146:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $146
80106581:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106586:	e9 cc f5 ff ff       	jmp    80105b57 <alltraps>

8010658b <vector147>:
.globl vector147
vector147:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $147
8010658d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106592:	e9 c0 f5 ff ff       	jmp    80105b57 <alltraps>

80106597 <vector148>:
.globl vector148
vector148:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $148
80106599:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010659e:	e9 b4 f5 ff ff       	jmp    80105b57 <alltraps>

801065a3 <vector149>:
.globl vector149
vector149:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $149
801065a5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065aa:	e9 a8 f5 ff ff       	jmp    80105b57 <alltraps>

801065af <vector150>:
.globl vector150
vector150:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $150
801065b1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065b6:	e9 9c f5 ff ff       	jmp    80105b57 <alltraps>

801065bb <vector151>:
.globl vector151
vector151:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $151
801065bd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801065c2:	e9 90 f5 ff ff       	jmp    80105b57 <alltraps>

801065c7 <vector152>:
.globl vector152
vector152:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $152
801065c9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801065ce:	e9 84 f5 ff ff       	jmp    80105b57 <alltraps>

801065d3 <vector153>:
.globl vector153
vector153:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $153
801065d5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801065da:	e9 78 f5 ff ff       	jmp    80105b57 <alltraps>

801065df <vector154>:
.globl vector154
vector154:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $154
801065e1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801065e6:	e9 6c f5 ff ff       	jmp    80105b57 <alltraps>

801065eb <vector155>:
.globl vector155
vector155:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $155
801065ed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801065f2:	e9 60 f5 ff ff       	jmp    80105b57 <alltraps>

801065f7 <vector156>:
.globl vector156
vector156:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $156
801065f9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801065fe:	e9 54 f5 ff ff       	jmp    80105b57 <alltraps>

80106603 <vector157>:
.globl vector157
vector157:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $157
80106605:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010660a:	e9 48 f5 ff ff       	jmp    80105b57 <alltraps>

8010660f <vector158>:
.globl vector158
vector158:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $158
80106611:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106616:	e9 3c f5 ff ff       	jmp    80105b57 <alltraps>

8010661b <vector159>:
.globl vector159
vector159:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $159
8010661d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106622:	e9 30 f5 ff ff       	jmp    80105b57 <alltraps>

80106627 <vector160>:
.globl vector160
vector160:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $160
80106629:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010662e:	e9 24 f5 ff ff       	jmp    80105b57 <alltraps>

80106633 <vector161>:
.globl vector161
vector161:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $161
80106635:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010663a:	e9 18 f5 ff ff       	jmp    80105b57 <alltraps>

8010663f <vector162>:
.globl vector162
vector162:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $162
80106641:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106646:	e9 0c f5 ff ff       	jmp    80105b57 <alltraps>

8010664b <vector163>:
.globl vector163
vector163:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $163
8010664d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106652:	e9 00 f5 ff ff       	jmp    80105b57 <alltraps>

80106657 <vector164>:
.globl vector164
vector164:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $164
80106659:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010665e:	e9 f4 f4 ff ff       	jmp    80105b57 <alltraps>

80106663 <vector165>:
.globl vector165
vector165:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $165
80106665:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010666a:	e9 e8 f4 ff ff       	jmp    80105b57 <alltraps>

8010666f <vector166>:
.globl vector166
vector166:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $166
80106671:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106676:	e9 dc f4 ff ff       	jmp    80105b57 <alltraps>

8010667b <vector167>:
.globl vector167
vector167:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $167
8010667d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106682:	e9 d0 f4 ff ff       	jmp    80105b57 <alltraps>

80106687 <vector168>:
.globl vector168
vector168:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $168
80106689:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010668e:	e9 c4 f4 ff ff       	jmp    80105b57 <alltraps>

80106693 <vector169>:
.globl vector169
vector169:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $169
80106695:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010669a:	e9 b8 f4 ff ff       	jmp    80105b57 <alltraps>

8010669f <vector170>:
.globl vector170
vector170:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $170
801066a1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066a6:	e9 ac f4 ff ff       	jmp    80105b57 <alltraps>

801066ab <vector171>:
.globl vector171
vector171:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $171
801066ad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066b2:	e9 a0 f4 ff ff       	jmp    80105b57 <alltraps>

801066b7 <vector172>:
.globl vector172
vector172:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $172
801066b9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066be:	e9 94 f4 ff ff       	jmp    80105b57 <alltraps>

801066c3 <vector173>:
.globl vector173
vector173:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $173
801066c5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801066ca:	e9 88 f4 ff ff       	jmp    80105b57 <alltraps>

801066cf <vector174>:
.globl vector174
vector174:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $174
801066d1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801066d6:	e9 7c f4 ff ff       	jmp    80105b57 <alltraps>

801066db <vector175>:
.globl vector175
vector175:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $175
801066dd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801066e2:	e9 70 f4 ff ff       	jmp    80105b57 <alltraps>

801066e7 <vector176>:
.globl vector176
vector176:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $176
801066e9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801066ee:	e9 64 f4 ff ff       	jmp    80105b57 <alltraps>

801066f3 <vector177>:
.globl vector177
vector177:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $177
801066f5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801066fa:	e9 58 f4 ff ff       	jmp    80105b57 <alltraps>

801066ff <vector178>:
.globl vector178
vector178:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $178
80106701:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106706:	e9 4c f4 ff ff       	jmp    80105b57 <alltraps>

8010670b <vector179>:
.globl vector179
vector179:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $179
8010670d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106712:	e9 40 f4 ff ff       	jmp    80105b57 <alltraps>

80106717 <vector180>:
.globl vector180
vector180:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $180
80106719:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010671e:	e9 34 f4 ff ff       	jmp    80105b57 <alltraps>

80106723 <vector181>:
.globl vector181
vector181:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $181
80106725:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010672a:	e9 28 f4 ff ff       	jmp    80105b57 <alltraps>

8010672f <vector182>:
.globl vector182
vector182:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $182
80106731:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106736:	e9 1c f4 ff ff       	jmp    80105b57 <alltraps>

8010673b <vector183>:
.globl vector183
vector183:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $183
8010673d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106742:	e9 10 f4 ff ff       	jmp    80105b57 <alltraps>

80106747 <vector184>:
.globl vector184
vector184:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $184
80106749:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010674e:	e9 04 f4 ff ff       	jmp    80105b57 <alltraps>

80106753 <vector185>:
.globl vector185
vector185:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $185
80106755:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010675a:	e9 f8 f3 ff ff       	jmp    80105b57 <alltraps>

8010675f <vector186>:
.globl vector186
vector186:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $186
80106761:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106766:	e9 ec f3 ff ff       	jmp    80105b57 <alltraps>

8010676b <vector187>:
.globl vector187
vector187:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $187
8010676d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106772:	e9 e0 f3 ff ff       	jmp    80105b57 <alltraps>

80106777 <vector188>:
.globl vector188
vector188:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $188
80106779:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010677e:	e9 d4 f3 ff ff       	jmp    80105b57 <alltraps>

80106783 <vector189>:
.globl vector189
vector189:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $189
80106785:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010678a:	e9 c8 f3 ff ff       	jmp    80105b57 <alltraps>

8010678f <vector190>:
.globl vector190
vector190:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $190
80106791:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106796:	e9 bc f3 ff ff       	jmp    80105b57 <alltraps>

8010679b <vector191>:
.globl vector191
vector191:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $191
8010679d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067a2:	e9 b0 f3 ff ff       	jmp    80105b57 <alltraps>

801067a7 <vector192>:
.globl vector192
vector192:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $192
801067a9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067ae:	e9 a4 f3 ff ff       	jmp    80105b57 <alltraps>

801067b3 <vector193>:
.globl vector193
vector193:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $193
801067b5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067ba:	e9 98 f3 ff ff       	jmp    80105b57 <alltraps>

801067bf <vector194>:
.globl vector194
vector194:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $194
801067c1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801067c6:	e9 8c f3 ff ff       	jmp    80105b57 <alltraps>

801067cb <vector195>:
.globl vector195
vector195:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $195
801067cd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801067d2:	e9 80 f3 ff ff       	jmp    80105b57 <alltraps>

801067d7 <vector196>:
.globl vector196
vector196:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $196
801067d9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801067de:	e9 74 f3 ff ff       	jmp    80105b57 <alltraps>

801067e3 <vector197>:
.globl vector197
vector197:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $197
801067e5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801067ea:	e9 68 f3 ff ff       	jmp    80105b57 <alltraps>

801067ef <vector198>:
.globl vector198
vector198:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $198
801067f1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801067f6:	e9 5c f3 ff ff       	jmp    80105b57 <alltraps>

801067fb <vector199>:
.globl vector199
vector199:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $199
801067fd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106802:	e9 50 f3 ff ff       	jmp    80105b57 <alltraps>

80106807 <vector200>:
.globl vector200
vector200:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $200
80106809:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010680e:	e9 44 f3 ff ff       	jmp    80105b57 <alltraps>

80106813 <vector201>:
.globl vector201
vector201:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $201
80106815:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010681a:	e9 38 f3 ff ff       	jmp    80105b57 <alltraps>

8010681f <vector202>:
.globl vector202
vector202:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $202
80106821:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106826:	e9 2c f3 ff ff       	jmp    80105b57 <alltraps>

8010682b <vector203>:
.globl vector203
vector203:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $203
8010682d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106832:	e9 20 f3 ff ff       	jmp    80105b57 <alltraps>

80106837 <vector204>:
.globl vector204
vector204:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $204
80106839:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010683e:	e9 14 f3 ff ff       	jmp    80105b57 <alltraps>

80106843 <vector205>:
.globl vector205
vector205:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $205
80106845:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010684a:	e9 08 f3 ff ff       	jmp    80105b57 <alltraps>

8010684f <vector206>:
.globl vector206
vector206:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $206
80106851:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106856:	e9 fc f2 ff ff       	jmp    80105b57 <alltraps>

8010685b <vector207>:
.globl vector207
vector207:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $207
8010685d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106862:	e9 f0 f2 ff ff       	jmp    80105b57 <alltraps>

80106867 <vector208>:
.globl vector208
vector208:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $208
80106869:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010686e:	e9 e4 f2 ff ff       	jmp    80105b57 <alltraps>

80106873 <vector209>:
.globl vector209
vector209:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $209
80106875:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010687a:	e9 d8 f2 ff ff       	jmp    80105b57 <alltraps>

8010687f <vector210>:
.globl vector210
vector210:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $210
80106881:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106886:	e9 cc f2 ff ff       	jmp    80105b57 <alltraps>

8010688b <vector211>:
.globl vector211
vector211:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $211
8010688d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106892:	e9 c0 f2 ff ff       	jmp    80105b57 <alltraps>

80106897 <vector212>:
.globl vector212
vector212:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $212
80106899:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010689e:	e9 b4 f2 ff ff       	jmp    80105b57 <alltraps>

801068a3 <vector213>:
.globl vector213
vector213:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $213
801068a5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068aa:	e9 a8 f2 ff ff       	jmp    80105b57 <alltraps>

801068af <vector214>:
.globl vector214
vector214:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $214
801068b1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068b6:	e9 9c f2 ff ff       	jmp    80105b57 <alltraps>

801068bb <vector215>:
.globl vector215
vector215:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $215
801068bd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801068c2:	e9 90 f2 ff ff       	jmp    80105b57 <alltraps>

801068c7 <vector216>:
.globl vector216
vector216:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $216
801068c9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801068ce:	e9 84 f2 ff ff       	jmp    80105b57 <alltraps>

801068d3 <vector217>:
.globl vector217
vector217:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $217
801068d5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801068da:	e9 78 f2 ff ff       	jmp    80105b57 <alltraps>

801068df <vector218>:
.globl vector218
vector218:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $218
801068e1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801068e6:	e9 6c f2 ff ff       	jmp    80105b57 <alltraps>

801068eb <vector219>:
.globl vector219
vector219:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $219
801068ed:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801068f2:	e9 60 f2 ff ff       	jmp    80105b57 <alltraps>

801068f7 <vector220>:
.globl vector220
vector220:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $220
801068f9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801068fe:	e9 54 f2 ff ff       	jmp    80105b57 <alltraps>

80106903 <vector221>:
.globl vector221
vector221:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $221
80106905:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010690a:	e9 48 f2 ff ff       	jmp    80105b57 <alltraps>

8010690f <vector222>:
.globl vector222
vector222:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $222
80106911:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106916:	e9 3c f2 ff ff       	jmp    80105b57 <alltraps>

8010691b <vector223>:
.globl vector223
vector223:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $223
8010691d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106922:	e9 30 f2 ff ff       	jmp    80105b57 <alltraps>

80106927 <vector224>:
.globl vector224
vector224:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $224
80106929:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010692e:	e9 24 f2 ff ff       	jmp    80105b57 <alltraps>

80106933 <vector225>:
.globl vector225
vector225:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $225
80106935:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010693a:	e9 18 f2 ff ff       	jmp    80105b57 <alltraps>

8010693f <vector226>:
.globl vector226
vector226:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $226
80106941:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106946:	e9 0c f2 ff ff       	jmp    80105b57 <alltraps>

8010694b <vector227>:
.globl vector227
vector227:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $227
8010694d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106952:	e9 00 f2 ff ff       	jmp    80105b57 <alltraps>

80106957 <vector228>:
.globl vector228
vector228:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $228
80106959:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010695e:	e9 f4 f1 ff ff       	jmp    80105b57 <alltraps>

80106963 <vector229>:
.globl vector229
vector229:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $229
80106965:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010696a:	e9 e8 f1 ff ff       	jmp    80105b57 <alltraps>

8010696f <vector230>:
.globl vector230
vector230:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $230
80106971:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106976:	e9 dc f1 ff ff       	jmp    80105b57 <alltraps>

8010697b <vector231>:
.globl vector231
vector231:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $231
8010697d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106982:	e9 d0 f1 ff ff       	jmp    80105b57 <alltraps>

80106987 <vector232>:
.globl vector232
vector232:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $232
80106989:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010698e:	e9 c4 f1 ff ff       	jmp    80105b57 <alltraps>

80106993 <vector233>:
.globl vector233
vector233:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $233
80106995:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010699a:	e9 b8 f1 ff ff       	jmp    80105b57 <alltraps>

8010699f <vector234>:
.globl vector234
vector234:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $234
801069a1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069a6:	e9 ac f1 ff ff       	jmp    80105b57 <alltraps>

801069ab <vector235>:
.globl vector235
vector235:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $235
801069ad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069b2:	e9 a0 f1 ff ff       	jmp    80105b57 <alltraps>

801069b7 <vector236>:
.globl vector236
vector236:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $236
801069b9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069be:	e9 94 f1 ff ff       	jmp    80105b57 <alltraps>

801069c3 <vector237>:
.globl vector237
vector237:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $237
801069c5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801069ca:	e9 88 f1 ff ff       	jmp    80105b57 <alltraps>

801069cf <vector238>:
.globl vector238
vector238:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $238
801069d1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801069d6:	e9 7c f1 ff ff       	jmp    80105b57 <alltraps>

801069db <vector239>:
.globl vector239
vector239:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $239
801069dd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801069e2:	e9 70 f1 ff ff       	jmp    80105b57 <alltraps>

801069e7 <vector240>:
.globl vector240
vector240:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $240
801069e9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801069ee:	e9 64 f1 ff ff       	jmp    80105b57 <alltraps>

801069f3 <vector241>:
.globl vector241
vector241:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $241
801069f5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801069fa:	e9 58 f1 ff ff       	jmp    80105b57 <alltraps>

801069ff <vector242>:
.globl vector242
vector242:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $242
80106a01:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a06:	e9 4c f1 ff ff       	jmp    80105b57 <alltraps>

80106a0b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $243
80106a0d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a12:	e9 40 f1 ff ff       	jmp    80105b57 <alltraps>

80106a17 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $244
80106a19:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a1e:	e9 34 f1 ff ff       	jmp    80105b57 <alltraps>

80106a23 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $245
80106a25:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a2a:	e9 28 f1 ff ff       	jmp    80105b57 <alltraps>

80106a2f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $246
80106a31:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a36:	e9 1c f1 ff ff       	jmp    80105b57 <alltraps>

80106a3b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $247
80106a3d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a42:	e9 10 f1 ff ff       	jmp    80105b57 <alltraps>

80106a47 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $248
80106a49:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a4e:	e9 04 f1 ff ff       	jmp    80105b57 <alltraps>

80106a53 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $249
80106a55:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a5a:	e9 f8 f0 ff ff       	jmp    80105b57 <alltraps>

80106a5f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $250
80106a61:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a66:	e9 ec f0 ff ff       	jmp    80105b57 <alltraps>

80106a6b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $251
80106a6d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a72:	e9 e0 f0 ff ff       	jmp    80105b57 <alltraps>

80106a77 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $252
80106a79:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a7e:	e9 d4 f0 ff ff       	jmp    80105b57 <alltraps>

80106a83 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $253
80106a85:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a8a:	e9 c8 f0 ff ff       	jmp    80105b57 <alltraps>

80106a8f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $254
80106a91:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a96:	e9 bc f0 ff ff       	jmp    80105b57 <alltraps>

80106a9b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $255
80106a9d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106aa2:	e9 b0 f0 ff ff       	jmp    80105b57 <alltraps>
80106aa7:	66 90                	xchg   %ax,%ax
80106aa9:	66 90                	xchg   %ax,%ax
80106aab:	66 90                	xchg   %ax,%ax
80106aad:	66 90                	xchg   %ax,%ax
80106aaf:	90                   	nop

80106ab0 <walkpgdir>:
}

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t * walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
80106ab3:	57                   	push   %edi
80106ab4:	56                   	push   %esi
80106ab5:	53                   	push   %ebx
    pde_t *pde;
    pte_t *pgtab;

    pde = &pgdir[PDX(va)];
80106ab6:	89 d3                	mov    %edx,%ebx
static pte_t * walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106ab8:	89 d7                	mov    %edx,%edi
    pde = &pgdir[PDX(va)];
80106aba:	c1 eb 16             	shr    $0x16,%ebx
80106abd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
static pte_t * walkpgdir(pde_t *pgdir, const void *va, int alloc) {
80106ac0:	83 ec 0c             	sub    $0xc,%esp
    if (*pde & PTE_P) {
80106ac3:	8b 06                	mov    (%esi),%eax
80106ac5:	a8 01                	test   $0x1,%al
80106ac7:	74 27                	je     80106af0 <walkpgdir+0x40>
        pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ac9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ace:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
        // The permissions here are overly generous, but they can
        // be further restricted by the permissions in the page table
        // entries, if necessary.
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
    }
    return &pgtab[PTX(va)];
80106ad4:	c1 ef 0a             	shr    $0xa,%edi
}
80106ad7:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return &pgtab[PTX(va)];
80106ada:	89 fa                	mov    %edi,%edx
80106adc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ae2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106ae5:	5b                   	pop    %ebx
80106ae6:	5e                   	pop    %esi
80106ae7:	5f                   	pop    %edi
80106ae8:	5d                   	pop    %ebp
80106ae9:	c3                   	ret    
80106aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if (!alloc || (pgtab = (pte_t*)kalloc()) == 0) {
80106af0:	85 c9                	test   %ecx,%ecx
80106af2:	74 2c                	je     80106b20 <walkpgdir+0x70>
80106af4:	e8 e7 bd ff ff       	call   801028e0 <kalloc>
80106af9:	85 c0                	test   %eax,%eax
80106afb:	89 c3                	mov    %eax,%ebx
80106afd:	74 21                	je     80106b20 <walkpgdir+0x70>
        memset(pgtab, 0, PGSIZE);
80106aff:	83 ec 04             	sub    $0x4,%esp
80106b02:	68 00 10 00 00       	push   $0x1000
80106b07:	6a 00                	push   $0x0
80106b09:	50                   	push   %eax
80106b0a:	e8 91 dd ff ff       	call   801048a0 <memset>
        *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b0f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b15:	83 c4 10             	add    $0x10,%esp
80106b18:	83 c8 07             	or     $0x7,%eax
80106b1b:	89 06                	mov    %eax,(%esi)
80106b1d:	eb b5                	jmp    80106ad4 <walkpgdir+0x24>
80106b1f:	90                   	nop
}
80106b20:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return 0;
80106b23:	31 c0                	xor    %eax,%eax
}
80106b25:	5b                   	pop    %ebx
80106b26:	5e                   	pop    %esi
80106b27:	5f                   	pop    %edi
80106b28:	5d                   	pop    %ebp
80106b29:	c3                   	ret    
80106b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b30 <mappages>:

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	57                   	push   %edi
80106b34:	56                   	push   %esi
80106b35:	53                   	push   %ebx
    char *a, *last;
    pte_t *pte;

    a = (char*)PGROUNDDOWN((uint)va);
80106b36:	89 d3                	mov    %edx,%ebx
80106b38:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
static int mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm) {
80106b3e:	83 ec 1c             	sub    $0x1c,%esp
80106b41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b44:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b48:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b50:	89 45 e0             	mov    %eax,-0x20(%ebp)
            return -1;
        }
        if (*pte & PTE_P) {
            panic("remap");
        }
        *pte = pa | perm | PTE_P;
80106b53:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b56:	29 df                	sub    %ebx,%edi
80106b58:	83 c8 01             	or     $0x1,%eax
80106b5b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b5e:	eb 15                	jmp    80106b75 <mappages+0x45>
        if (*pte & PTE_P) {
80106b60:	f6 00 01             	testb  $0x1,(%eax)
80106b63:	75 45                	jne    80106baa <mappages+0x7a>
        *pte = pa | perm | PTE_P;
80106b65:	0b 75 dc             	or     -0x24(%ebp),%esi
        if (a == last) {
80106b68:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
        *pte = pa | perm | PTE_P;
80106b6b:	89 30                	mov    %esi,(%eax)
        if (a == last) {
80106b6d:	74 31                	je     80106ba0 <mappages+0x70>
            break;
        }
        a += PGSIZE;
80106b6f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        if ((pte = walkpgdir(pgdir, a, 1)) == 0) {
80106b75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b78:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b7d:	89 da                	mov    %ebx,%edx
80106b7f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106b82:	e8 29 ff ff ff       	call   80106ab0 <walkpgdir>
80106b87:	85 c0                	test   %eax,%eax
80106b89:	75 d5                	jne    80106b60 <mappages+0x30>
        pa += PGSIZE;
    }
    return 0;
}
80106b8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80106b8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b93:	5b                   	pop    %ebx
80106b94:	5e                   	pop    %esi
80106b95:	5f                   	pop    %edi
80106b96:	5d                   	pop    %ebp
80106b97:	c3                   	ret    
80106b98:	90                   	nop
80106b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ba0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106ba3:	31 c0                	xor    %eax,%eax
}
80106ba5:	5b                   	pop    %ebx
80106ba6:	5e                   	pop    %esi
80106ba7:	5f                   	pop    %edi
80106ba8:	5d                   	pop    %ebp
80106ba9:	c3                   	ret    
            panic("remap");
80106baa:	83 ec 0c             	sub    $0xc,%esp
80106bad:	68 ec 7c 10 80       	push   $0x80107cec
80106bb2:	e8 c9 98 ff ff       	call   80100480 <panic>
80106bb7:	89 f6                	mov    %esi,%esi
80106bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bc0 <deallocuvm.part.0>:

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	57                   	push   %edi
80106bc4:	56                   	push   %esi
80106bc5:	53                   	push   %ebx

    if (newsz >= oldsz) {
        return oldsz;
    }

    a = PGROUNDUP(newsz);
80106bc6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80106bcc:	89 c7                	mov    %eax,%edi
    a = PGROUNDUP(newsz);
80106bce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80106bd4:	83 ec 1c             	sub    $0x1c,%esp
80106bd7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    for (; a  < oldsz; a += PGSIZE) {
80106bda:	39 d3                	cmp    %edx,%ebx
80106bdc:	73 66                	jae    80106c44 <deallocuvm.part.0+0x84>
80106bde:	89 d6                	mov    %edx,%esi
80106be0:	eb 3d                	jmp    80106c1f <deallocuvm.part.0+0x5f>
80106be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        pte = walkpgdir(pgdir, (char*)a, 0);
        if (!pte) {
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
        }
        else if ((*pte & PTE_P) != 0) {
80106be8:	8b 10                	mov    (%eax),%edx
80106bea:	f6 c2 01             	test   $0x1,%dl
80106bed:	74 26                	je     80106c15 <deallocuvm.part.0+0x55>
            pa = PTE_ADDR(*pte);
            if (pa == 0) {
80106bef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106bf5:	74 58                	je     80106c4f <deallocuvm.part.0+0x8f>
                panic("kfree");
            }
            char *v = P2V(pa);
            kfree(v);
80106bf7:	83 ec 0c             	sub    $0xc,%esp
            char *v = P2V(pa);
80106bfa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106c00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            kfree(v);
80106c03:	52                   	push   %edx
80106c04:	e8 27 bb ff ff       	call   80102730 <kfree>
            *pte = 0;
80106c09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c0c:	83 c4 10             	add    $0x10,%esp
80106c0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for (; a  < oldsz; a += PGSIZE) {
80106c15:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c1b:	39 f3                	cmp    %esi,%ebx
80106c1d:	73 25                	jae    80106c44 <deallocuvm.part.0+0x84>
        pte = walkpgdir(pgdir, (char*)a, 0);
80106c1f:	31 c9                	xor    %ecx,%ecx
80106c21:	89 da                	mov    %ebx,%edx
80106c23:	89 f8                	mov    %edi,%eax
80106c25:	e8 86 fe ff ff       	call   80106ab0 <walkpgdir>
        if (!pte) {
80106c2a:	85 c0                	test   %eax,%eax
80106c2c:	75 ba                	jne    80106be8 <deallocuvm.part.0+0x28>
            a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c2e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106c34:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
    for (; a  < oldsz; a += PGSIZE) {
80106c3a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c40:	39 f3                	cmp    %esi,%ebx
80106c42:	72 db                	jb     80106c1f <deallocuvm.part.0+0x5f>
        }
    }
    return newsz;
}
80106c44:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c4a:	5b                   	pop    %ebx
80106c4b:	5e                   	pop    %esi
80106c4c:	5f                   	pop    %edi
80106c4d:	5d                   	pop    %ebp
80106c4e:	c3                   	ret    
                panic("kfree");
80106c4f:	83 ec 0c             	sub    $0xc,%esp
80106c52:	68 66 76 10 80       	push   $0x80107666
80106c57:	e8 24 98 ff ff       	call   80100480 <panic>
80106c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c60 <seginit>:
void seginit(void) {
80106c60:	55                   	push   %ebp
80106c61:	89 e5                	mov    %esp,%ebp
80106c63:	83 ec 18             	sub    $0x18,%esp
    c = &cpus[cpuid()];
80106c66:	e8 a5 cf ff ff       	call   80103c10 <cpuid>
80106c6b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
    pd[0] = size - 1;
80106c71:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c76:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
    c->gdt[SEG_KCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, 0);
80106c7a:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80106c81:	ff 00 00 
80106c84:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
80106c8b:	9a cf 00 
    c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c8e:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80106c95:	ff 00 00 
80106c98:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80106c9f:	92 cf 00 
    c->gdt[SEG_UCODE] = SEG(STA_X | STA_R, 0, 0xffffffff, DPL_USER);
80106ca2:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80106ca9:	ff 00 00 
80106cac:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80106cb3:	fa cf 00 
    c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106cb6:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80106cbd:	ff 00 00 
80106cc0:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80106cc7:	f2 cf 00 
    lgdt(c->gdt, sizeof(c->gdt));
80106cca:	05 f0 37 11 80       	add    $0x801137f0,%eax
    pd[1] = (uint)p;
80106ccf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
    pd[2] = (uint)p >> 16;
80106cd3:	c1 e8 10             	shr    $0x10,%eax
80106cd6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    asm volatile ("lgdt (%0)" : : "r" (pd));
80106cda:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106cdd:	0f 01 10             	lgdtl  (%eax)
}
80106ce0:	c9                   	leave  
80106ce1:	c3                   	ret    
80106ce2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cf0 <switchkvm>:
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80106cf0:	a1 a4 64 11 80       	mov    0x801164a4,%eax
void switchkvm(void)      {
80106cf5:	55                   	push   %ebp
80106cf6:	89 e5                	mov    %esp,%ebp
    lcr3(V2P(kpgdir));   // switch to the kernel page table
80106cf8:	05 00 00 00 80       	add    $0x80000000,%eax
    return val;
}

static inline void lcr3(uint val) {
    asm volatile ("movl %0,%%cr3" : : "r" (val));
80106cfd:	0f 22 d8             	mov    %eax,%cr3
}
80106d00:	5d                   	pop    %ebp
80106d01:	c3                   	ret    
80106d02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d10 <switchuvm>:
void switchuvm(struct proc *p) {
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
80106d16:	83 ec 1c             	sub    $0x1c,%esp
80106d19:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (p == 0) {
80106d1c:	85 db                	test   %ebx,%ebx
80106d1e:	0f 84 cb 00 00 00    	je     80106def <switchuvm+0xdf>
    if (p->kstack == 0) {
80106d24:	8b 43 08             	mov    0x8(%ebx),%eax
80106d27:	85 c0                	test   %eax,%eax
80106d29:	0f 84 da 00 00 00    	je     80106e09 <switchuvm+0xf9>
    if (p->pgdir == 0) {
80106d2f:	8b 43 04             	mov    0x4(%ebx),%eax
80106d32:	85 c0                	test   %eax,%eax
80106d34:	0f 84 c2 00 00 00    	je     80106dfc <switchuvm+0xec>
    pushcli();
80106d3a:	e8 81 d9 ff ff       	call   801046c0 <pushcli>
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d3f:	e8 4c ce ff ff       	call   80103b90 <mycpu>
80106d44:	89 c6                	mov    %eax,%esi
80106d46:	e8 45 ce ff ff       	call   80103b90 <mycpu>
80106d4b:	89 c7                	mov    %eax,%edi
80106d4d:	e8 3e ce ff ff       	call   80103b90 <mycpu>
80106d52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d55:	83 c7 08             	add    $0x8,%edi
80106d58:	e8 33 ce ff ff       	call   80103b90 <mycpu>
80106d5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d60:	83 c0 08             	add    $0x8,%eax
80106d63:	ba 67 00 00 00       	mov    $0x67,%edx
80106d68:	c1 e8 18             	shr    $0x18,%eax
80106d6b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106d72:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106d79:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
    mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d7f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d84:	83 c1 08             	add    $0x8,%ecx
80106d87:	c1 e9 10             	shr    $0x10,%ecx
80106d8a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106d90:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d95:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d9c:	be 10 00 00 00       	mov    $0x10,%esi
    mycpu()->gdt[SEG_TSS].s = 0;
80106da1:	e8 ea cd ff ff       	call   80103b90 <mycpu>
80106da6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
    mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dad:	e8 de cd ff ff       	call   80103b90 <mycpu>
80106db2:	66 89 70 10          	mov    %si,0x10(%eax)
    mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106db6:	8b 73 08             	mov    0x8(%ebx),%esi
80106db9:	e8 d2 cd ff ff       	call   80103b90 <mycpu>
80106dbe:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106dc4:	89 70 0c             	mov    %esi,0xc(%eax)
    mycpu()->ts.iomb = (ushort) 0xFFFF;
80106dc7:	e8 c4 cd ff ff       	call   80103b90 <mycpu>
80106dcc:	66 89 78 6e          	mov    %di,0x6e(%eax)
    asm volatile ("ltr %0" : : "r" (sel));
80106dd0:	b8 28 00 00 00       	mov    $0x28,%eax
80106dd5:	0f 00 d8             	ltr    %ax
    lcr3(V2P(p->pgdir));  // switch to process's address space
80106dd8:	8b 43 04             	mov    0x4(%ebx),%eax
80106ddb:	05 00 00 00 80       	add    $0x80000000,%eax
    asm volatile ("movl %0,%%cr3" : : "r" (val));
80106de0:	0f 22 d8             	mov    %eax,%cr3
}
80106de3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106de6:	5b                   	pop    %ebx
80106de7:	5e                   	pop    %esi
80106de8:	5f                   	pop    %edi
80106de9:	5d                   	pop    %ebp
    popcli();
80106dea:	e9 11 d9 ff ff       	jmp    80104700 <popcli>
        panic("switchuvm: no process");
80106def:	83 ec 0c             	sub    $0xc,%esp
80106df2:	68 f2 7c 10 80       	push   $0x80107cf2
80106df7:	e8 84 96 ff ff       	call   80100480 <panic>
        panic("switchuvm: no pgdir");
80106dfc:	83 ec 0c             	sub    $0xc,%esp
80106dff:	68 1d 7d 10 80       	push   $0x80107d1d
80106e04:	e8 77 96 ff ff       	call   80100480 <panic>
        panic("switchuvm: no kstack");
80106e09:	83 ec 0c             	sub    $0xc,%esp
80106e0c:	68 08 7d 10 80       	push   $0x80107d08
80106e11:	e8 6a 96 ff ff       	call   80100480 <panic>
80106e16:	8d 76 00             	lea    0x0(%esi),%esi
80106e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e20 <inituvm>:
void inituvm(pde_t *pgdir, char *init, uint sz) {
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	57                   	push   %edi
80106e24:	56                   	push   %esi
80106e25:	53                   	push   %ebx
80106e26:	83 ec 1c             	sub    $0x1c,%esp
80106e29:	8b 75 10             	mov    0x10(%ebp),%esi
80106e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2f:	8b 7d 0c             	mov    0xc(%ebp),%edi
    if (sz >= PGSIZE) {
80106e32:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
void inituvm(pde_t *pgdir, char *init, uint sz) {
80106e38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (sz >= PGSIZE) {
80106e3b:	77 49                	ja     80106e86 <inituvm+0x66>
    mem = kalloc();
80106e3d:	e8 9e ba ff ff       	call   801028e0 <kalloc>
    memset(mem, 0, PGSIZE);
80106e42:	83 ec 04             	sub    $0x4,%esp
    mem = kalloc();
80106e45:	89 c3                	mov    %eax,%ebx
    memset(mem, 0, PGSIZE);
80106e47:	68 00 10 00 00       	push   $0x1000
80106e4c:	6a 00                	push   $0x0
80106e4e:	50                   	push   %eax
80106e4f:	e8 4c da ff ff       	call   801048a0 <memset>
    mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W | PTE_U);
80106e54:	58                   	pop    %eax
80106e55:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e5b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e60:	5a                   	pop    %edx
80106e61:	6a 06                	push   $0x6
80106e63:	50                   	push   %eax
80106e64:	31 d2                	xor    %edx,%edx
80106e66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e69:	e8 c2 fc ff ff       	call   80106b30 <mappages>
    memmove(mem, init, sz);
80106e6e:	89 75 10             	mov    %esi,0x10(%ebp)
80106e71:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106e74:	83 c4 10             	add    $0x10,%esp
80106e77:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e7d:	5b                   	pop    %ebx
80106e7e:	5e                   	pop    %esi
80106e7f:	5f                   	pop    %edi
80106e80:	5d                   	pop    %ebp
    memmove(mem, init, sz);
80106e81:	e9 ca da ff ff       	jmp    80104950 <memmove>
        panic("inituvm: more than a page");
80106e86:	83 ec 0c             	sub    $0xc,%esp
80106e89:	68 31 7d 10 80       	push   $0x80107d31
80106e8e:	e8 ed 95 ff ff       	call   80100480 <panic>
80106e93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ea0 <loaduvm>:
int loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz) {
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
80106ea6:	83 ec 0c             	sub    $0xc,%esp
    if ((uint) addr % PGSIZE != 0) {
80106ea9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106eb0:	0f 85 91 00 00 00    	jne    80106f47 <loaduvm+0xa7>
    for (i = 0; i < sz; i += PGSIZE) {
80106eb6:	8b 75 18             	mov    0x18(%ebp),%esi
80106eb9:	31 db                	xor    %ebx,%ebx
80106ebb:	85 f6                	test   %esi,%esi
80106ebd:	75 1a                	jne    80106ed9 <loaduvm+0x39>
80106ebf:	eb 6f                	jmp    80106f30 <loaduvm+0x90>
80106ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ec8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ece:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106ed4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106ed7:	76 57                	jbe    80106f30 <loaduvm+0x90>
        if ((pte = walkpgdir(pgdir, addr + i, 0)) == 0) {
80106ed9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106edc:	8b 45 08             	mov    0x8(%ebp),%eax
80106edf:	31 c9                	xor    %ecx,%ecx
80106ee1:	01 da                	add    %ebx,%edx
80106ee3:	e8 c8 fb ff ff       	call   80106ab0 <walkpgdir>
80106ee8:	85 c0                	test   %eax,%eax
80106eea:	74 4e                	je     80106f3a <loaduvm+0x9a>
        pa = PTE_ADDR(*pte);
80106eec:	8b 00                	mov    (%eax),%eax
        if (readi(ip, P2V(pa), offset + i, n) != n) {
80106eee:	8b 4d 14             	mov    0x14(%ebp),%ecx
        if (sz - i < PGSIZE) {
80106ef1:	bf 00 10 00 00       	mov    $0x1000,%edi
        pa = PTE_ADDR(*pte);
80106ef6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
        if (sz - i < PGSIZE) {
80106efb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106f01:	0f 46 fe             	cmovbe %esi,%edi
        if (readi(ip, P2V(pa), offset + i, n) != n) {
80106f04:	01 d9                	add    %ebx,%ecx
80106f06:	05 00 00 00 80       	add    $0x80000000,%eax
80106f0b:	57                   	push   %edi
80106f0c:	51                   	push   %ecx
80106f0d:	50                   	push   %eax
80106f0e:	ff 75 10             	pushl  0x10(%ebp)
80106f11:	e8 6a ae ff ff       	call   80101d80 <readi>
80106f16:	83 c4 10             	add    $0x10,%esp
80106f19:	39 f8                	cmp    %edi,%eax
80106f1b:	74 ab                	je     80106ec8 <loaduvm+0x28>
}
80106f1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
80106f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f25:	5b                   	pop    %ebx
80106f26:	5e                   	pop    %esi
80106f27:	5f                   	pop    %edi
80106f28:	5d                   	pop    %ebp
80106f29:	c3                   	ret    
80106f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106f33:	31 c0                	xor    %eax,%eax
}
80106f35:	5b                   	pop    %ebx
80106f36:	5e                   	pop    %esi
80106f37:	5f                   	pop    %edi
80106f38:	5d                   	pop    %ebp
80106f39:	c3                   	ret    
            panic("loaduvm: address should exist");
80106f3a:	83 ec 0c             	sub    $0xc,%esp
80106f3d:	68 4b 7d 10 80       	push   $0x80107d4b
80106f42:	e8 39 95 ff ff       	call   80100480 <panic>
        panic("loaduvm: addr must be page aligned");
80106f47:	83 ec 0c             	sub    $0xc,%esp
80106f4a:	68 ec 7d 10 80       	push   $0x80107dec
80106f4f:	e8 2c 95 ff ff       	call   80100480 <panic>
80106f54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f60 <allocuvm>:
int allocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 1c             	sub    $0x1c,%esp
    if (newsz >= KERNBASE) {
80106f69:	8b 7d 10             	mov    0x10(%ebp),%edi
80106f6c:	85 ff                	test   %edi,%edi
80106f6e:	0f 88 8e 00 00 00    	js     80107002 <allocuvm+0xa2>
    if (newsz < oldsz) {
80106f74:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f77:	0f 82 93 00 00 00    	jb     80107010 <allocuvm+0xb0>
    a = PGROUNDUP(oldsz);
80106f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f80:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106f86:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    for (; a < newsz; a += PGSIZE) {
80106f8c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106f8f:	0f 86 7e 00 00 00    	jbe    80107013 <allocuvm+0xb3>
80106f95:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106f98:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f9b:	eb 42                	jmp    80106fdf <allocuvm+0x7f>
80106f9d:	8d 76 00             	lea    0x0(%esi),%esi
        memset(mem, 0, PGSIZE);
80106fa0:	83 ec 04             	sub    $0x4,%esp
80106fa3:	68 00 10 00 00       	push   $0x1000
80106fa8:	6a 00                	push   $0x0
80106faa:	50                   	push   %eax
80106fab:	e8 f0 d8 ff ff       	call   801048a0 <memset>
        if (mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
80106fb0:	58                   	pop    %eax
80106fb1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106fb7:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fbc:	5a                   	pop    %edx
80106fbd:	6a 06                	push   $0x6
80106fbf:	50                   	push   %eax
80106fc0:	89 da                	mov    %ebx,%edx
80106fc2:	89 f8                	mov    %edi,%eax
80106fc4:	e8 67 fb ff ff       	call   80106b30 <mappages>
80106fc9:	83 c4 10             	add    $0x10,%esp
80106fcc:	85 c0                	test   %eax,%eax
80106fce:	78 50                	js     80107020 <allocuvm+0xc0>
    for (; a < newsz; a += PGSIZE) {
80106fd0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fd6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106fd9:	0f 86 81 00 00 00    	jbe    80107060 <allocuvm+0x100>
        mem = kalloc();
80106fdf:	e8 fc b8 ff ff       	call   801028e0 <kalloc>
        if (mem == 0) {
80106fe4:	85 c0                	test   %eax,%eax
        mem = kalloc();
80106fe6:	89 c6                	mov    %eax,%esi
        if (mem == 0) {
80106fe8:	75 b6                	jne    80106fa0 <allocuvm+0x40>
            cprintf("allocuvm out of memory\n");
80106fea:	83 ec 0c             	sub    $0xc,%esp
80106fed:	68 69 7d 10 80       	push   $0x80107d69
80106ff2:	e8 59 97 ff ff       	call   80100750 <cprintf>
    if (newsz >= oldsz) {
80106ff7:	83 c4 10             	add    $0x10,%esp
80106ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ffd:	39 45 10             	cmp    %eax,0x10(%ebp)
80107000:	77 6e                	ja     80107070 <allocuvm+0x110>
}
80107002:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
80107005:	31 ff                	xor    %edi,%edi
}
80107007:	89 f8                	mov    %edi,%eax
80107009:	5b                   	pop    %ebx
8010700a:	5e                   	pop    %esi
8010700b:	5f                   	pop    %edi
8010700c:	5d                   	pop    %ebp
8010700d:	c3                   	ret    
8010700e:	66 90                	xchg   %ax,%ax
        return oldsz;
80107010:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107013:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107016:	89 f8                	mov    %edi,%eax
80107018:	5b                   	pop    %ebx
80107019:	5e                   	pop    %esi
8010701a:	5f                   	pop    %edi
8010701b:	5d                   	pop    %ebp
8010701c:	c3                   	ret    
8010701d:	8d 76 00             	lea    0x0(%esi),%esi
            cprintf("allocuvm out of memory (2)\n");
80107020:	83 ec 0c             	sub    $0xc,%esp
80107023:	68 81 7d 10 80       	push   $0x80107d81
80107028:	e8 23 97 ff ff       	call   80100750 <cprintf>
    if (newsz >= oldsz) {
8010702d:	83 c4 10             	add    $0x10,%esp
80107030:	8b 45 0c             	mov    0xc(%ebp),%eax
80107033:	39 45 10             	cmp    %eax,0x10(%ebp)
80107036:	76 0d                	jbe    80107045 <allocuvm+0xe5>
80107038:	89 c1                	mov    %eax,%ecx
8010703a:	8b 55 10             	mov    0x10(%ebp),%edx
8010703d:	8b 45 08             	mov    0x8(%ebp),%eax
80107040:	e8 7b fb ff ff       	call   80106bc0 <deallocuvm.part.0>
            kfree(mem);
80107045:	83 ec 0c             	sub    $0xc,%esp
            return 0;
80107048:	31 ff                	xor    %edi,%edi
            kfree(mem);
8010704a:	56                   	push   %esi
8010704b:	e8 e0 b6 ff ff       	call   80102730 <kfree>
            return 0;
80107050:	83 c4 10             	add    $0x10,%esp
}
80107053:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107056:	89 f8                	mov    %edi,%eax
80107058:	5b                   	pop    %ebx
80107059:	5e                   	pop    %esi
8010705a:	5f                   	pop    %edi
8010705b:	5d                   	pop    %ebp
8010705c:	c3                   	ret    
8010705d:	8d 76 00             	lea    0x0(%esi),%esi
80107060:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107063:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107066:	5b                   	pop    %ebx
80107067:	89 f8                	mov    %edi,%eax
80107069:	5e                   	pop    %esi
8010706a:	5f                   	pop    %edi
8010706b:	5d                   	pop    %ebp
8010706c:	c3                   	ret    
8010706d:	8d 76 00             	lea    0x0(%esi),%esi
80107070:	89 c1                	mov    %eax,%ecx
80107072:	8b 55 10             	mov    0x10(%ebp),%edx
80107075:	8b 45 08             	mov    0x8(%ebp),%eax
            return 0;
80107078:	31 ff                	xor    %edi,%edi
8010707a:	e8 41 fb ff ff       	call   80106bc0 <deallocuvm.part.0>
8010707f:	eb 92                	jmp    80107013 <allocuvm+0xb3>
80107081:	eb 0d                	jmp    80107090 <deallocuvm>
80107083:	90                   	nop
80107084:	90                   	nop
80107085:	90                   	nop
80107086:	90                   	nop
80107087:	90                   	nop
80107088:	90                   	nop
80107089:	90                   	nop
8010708a:	90                   	nop
8010708b:	90                   	nop
8010708c:	90                   	nop
8010708d:	90                   	nop
8010708e:	90                   	nop
8010708f:	90                   	nop

80107090 <deallocuvm>:
int deallocuvm(pde_t *pgdir, uint oldsz, uint newsz) {
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	8b 55 0c             	mov    0xc(%ebp),%edx
80107096:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107099:	8b 45 08             	mov    0x8(%ebp),%eax
    if (newsz >= oldsz) {
8010709c:	39 d1                	cmp    %edx,%ecx
8010709e:	73 10                	jae    801070b0 <deallocuvm+0x20>
}
801070a0:	5d                   	pop    %ebp
801070a1:	e9 1a fb ff ff       	jmp    80106bc0 <deallocuvm.part.0>
801070a6:	8d 76 00             	lea    0x0(%esi),%esi
801070a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801070b0:	89 d0                	mov    %edx,%eax
801070b2:	5d                   	pop    %ebp
801070b3:	c3                   	ret    
801070b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801070c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void freevm(pde_t *pgdir) {
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 0c             	sub    $0xc,%esp
801070c9:	8b 75 08             	mov    0x8(%ebp),%esi
    uint i;

    if (pgdir == 0) {
801070cc:	85 f6                	test   %esi,%esi
801070ce:	74 59                	je     80107129 <freevm+0x69>
801070d0:	31 c9                	xor    %ecx,%ecx
801070d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801070d7:	89 f0                	mov    %esi,%eax
801070d9:	e8 e2 fa ff ff       	call   80106bc0 <deallocuvm.part.0>
801070de:	89 f3                	mov    %esi,%ebx
801070e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801070e6:	eb 0f                	jmp    801070f7 <freevm+0x37>
801070e8:	90                   	nop
801070e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070f0:	83 c3 04             	add    $0x4,%ebx
        panic("freevm: no pgdir");
    }
    deallocuvm(pgdir, KERNBASE, 0);
    for (i = 0; i < NPDENTRIES; i++) {
801070f3:	39 fb                	cmp    %edi,%ebx
801070f5:	74 23                	je     8010711a <freevm+0x5a>
        if (pgdir[i] & PTE_P) {
801070f7:	8b 03                	mov    (%ebx),%eax
801070f9:	a8 01                	test   $0x1,%al
801070fb:	74 f3                	je     801070f0 <freevm+0x30>
            char * v = P2V(PTE_ADDR(pgdir[i]));
801070fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
            kfree(v);
80107102:	83 ec 0c             	sub    $0xc,%esp
80107105:	83 c3 04             	add    $0x4,%ebx
            char * v = P2V(PTE_ADDR(pgdir[i]));
80107108:	05 00 00 00 80       	add    $0x80000000,%eax
            kfree(v);
8010710d:	50                   	push   %eax
8010710e:	e8 1d b6 ff ff       	call   80102730 <kfree>
80107113:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NPDENTRIES; i++) {
80107116:	39 fb                	cmp    %edi,%ebx
80107118:	75 dd                	jne    801070f7 <freevm+0x37>
        }
    }
    kfree((char*)pgdir);
8010711a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010711d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107120:	5b                   	pop    %ebx
80107121:	5e                   	pop    %esi
80107122:	5f                   	pop    %edi
80107123:	5d                   	pop    %ebp
    kfree((char*)pgdir);
80107124:	e9 07 b6 ff ff       	jmp    80102730 <kfree>
        panic("freevm: no pgdir");
80107129:	83 ec 0c             	sub    $0xc,%esp
8010712c:	68 9d 7d 10 80       	push   $0x80107d9d
80107131:	e8 4a 93 ff ff       	call   80100480 <panic>
80107136:	8d 76 00             	lea    0x0(%esi),%esi
80107139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107140 <setupkvm>:
pde_t*setupkvm(void) {
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	56                   	push   %esi
80107144:	53                   	push   %ebx
    if ((pgdir = (pde_t*)kalloc()) == 0) {
80107145:	e8 96 b7 ff ff       	call   801028e0 <kalloc>
8010714a:	85 c0                	test   %eax,%eax
8010714c:	89 c6                	mov    %eax,%esi
8010714e:	74 42                	je     80107192 <setupkvm+0x52>
    memset(pgdir, 0, PGSIZE);
80107150:	83 ec 04             	sub    $0x4,%esp
    for (k = kmap; k < &kmap[NELEM(kmap)]; k++) {
80107153:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
    memset(pgdir, 0, PGSIZE);
80107158:	68 00 10 00 00       	push   $0x1000
8010715d:	6a 00                	push   $0x0
8010715f:	50                   	push   %eax
80107160:	e8 3b d7 ff ff       	call   801048a0 <memset>
80107165:	83 c4 10             	add    $0x10,%esp
                     (uint)k->phys_start, k->perm) < 0) {
80107168:	8b 43 04             	mov    0x4(%ebx),%eax
        if (mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010716b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010716e:	83 ec 08             	sub    $0x8,%esp
80107171:	8b 13                	mov    (%ebx),%edx
80107173:	ff 73 0c             	pushl  0xc(%ebx)
80107176:	50                   	push   %eax
80107177:	29 c1                	sub    %eax,%ecx
80107179:	89 f0                	mov    %esi,%eax
8010717b:	e8 b0 f9 ff ff       	call   80106b30 <mappages>
80107180:	83 c4 10             	add    $0x10,%esp
80107183:	85 c0                	test   %eax,%eax
80107185:	78 19                	js     801071a0 <setupkvm+0x60>
    for (k = kmap; k < &kmap[NELEM(kmap)]; k++) {
80107187:	83 c3 10             	add    $0x10,%ebx
8010718a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107190:	75 d6                	jne    80107168 <setupkvm+0x28>
}
80107192:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107195:	89 f0                	mov    %esi,%eax
80107197:	5b                   	pop    %ebx
80107198:	5e                   	pop    %esi
80107199:	5d                   	pop    %ebp
8010719a:	c3                   	ret    
8010719b:	90                   	nop
8010719c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            freevm(pgdir);
801071a0:	83 ec 0c             	sub    $0xc,%esp
801071a3:	56                   	push   %esi
            return 0;
801071a4:	31 f6                	xor    %esi,%esi
            freevm(pgdir);
801071a6:	e8 15 ff ff ff       	call   801070c0 <freevm>
            return 0;
801071ab:	83 c4 10             	add    $0x10,%esp
}
801071ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071b1:	89 f0                	mov    %esi,%eax
801071b3:	5b                   	pop    %ebx
801071b4:	5e                   	pop    %esi
801071b5:	5d                   	pop    %ebp
801071b6:	c3                   	ret    
801071b7:	89 f6                	mov    %esi,%esi
801071b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071c0 <kvmalloc>:
void kvmalloc(void)  {
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	83 ec 08             	sub    $0x8,%esp
    kpgdir = setupkvm();
801071c6:	e8 75 ff ff ff       	call   80107140 <setupkvm>
801071cb:	a3 a4 64 11 80       	mov    %eax,0x801164a4
    lcr3(V2P(kpgdir));   // switch to the kernel page table
801071d0:	05 00 00 00 80       	add    $0x80000000,%eax
801071d5:	0f 22 d8             	mov    %eax,%cr3
}
801071d8:	c9                   	leave  
801071d9:	c3                   	ret    
801071da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void clearpteu(pde_t *pgdir, char *uva) {
801071e0:	55                   	push   %ebp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
801071e1:	31 c9                	xor    %ecx,%ecx
void clearpteu(pde_t *pgdir, char *uva) {
801071e3:	89 e5                	mov    %esp,%ebp
801071e5:	83 ec 08             	sub    $0x8,%esp
    pte = walkpgdir(pgdir, uva, 0);
801071e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801071eb:	8b 45 08             	mov    0x8(%ebp),%eax
801071ee:	e8 bd f8 ff ff       	call   80106ab0 <walkpgdir>
    if (pte == 0) {
801071f3:	85 c0                	test   %eax,%eax
801071f5:	74 05                	je     801071fc <clearpteu+0x1c>
        panic("clearpteu");
    }
    *pte &= ~PTE_U;
801071f7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801071fa:	c9                   	leave  
801071fb:	c3                   	ret    
        panic("clearpteu");
801071fc:	83 ec 0c             	sub    $0xc,%esp
801071ff:	68 ae 7d 10 80       	push   $0x80107dae
80107204:	e8 77 92 ff ff       	call   80100480 <panic>
80107209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107210 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t* copyuvm(pde_t *pgdir, uint sz) {
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	57                   	push   %edi
80107214:	56                   	push   %esi
80107215:	53                   	push   %ebx
80107216:	83 ec 1c             	sub    $0x1c,%esp
    pde_t *d;
    pte_t *pte;
    uint pa, i, flags;
    char *mem;

    if ((d = setupkvm()) == 0) {
80107219:	e8 22 ff ff ff       	call   80107140 <setupkvm>
8010721e:	85 c0                	test   %eax,%eax
80107220:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107223:	0f 84 9f 00 00 00    	je     801072c8 <copyuvm+0xb8>
        return 0;
    }
    for (i = 0; i < sz; i += PGSIZE) {
80107229:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010722c:	85 db                	test   %ebx,%ebx
8010722e:	0f 84 94 00 00 00    	je     801072c8 <copyuvm+0xb8>
80107234:	31 ff                	xor    %edi,%edi
80107236:	eb 4a                	jmp    80107282 <copyuvm+0x72>
80107238:	90                   	nop
80107239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        flags = PTE_FLAGS(*pte);
        if ((mem = kalloc()) == 0) {
            freevm(d);
            return 0;
        }
        memmove(mem, (char*)P2V(pa), PGSIZE);
80107240:	83 ec 04             	sub    $0x4,%esp
80107243:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107249:	68 00 10 00 00       	push   $0x1000
8010724e:	53                   	push   %ebx
8010724f:	50                   	push   %eax
80107250:	e8 fb d6 ff ff       	call   80104950 <memmove>
        if (mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107255:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010725b:	5a                   	pop    %edx
8010725c:	59                   	pop    %ecx
8010725d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107260:	50                   	push   %eax
80107261:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107266:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107269:	89 fa                	mov    %edi,%edx
8010726b:	e8 c0 f8 ff ff       	call   80106b30 <mappages>
80107270:	83 c4 10             	add    $0x10,%esp
80107273:	85 c0                	test   %eax,%eax
80107275:	78 61                	js     801072d8 <copyuvm+0xc8>
    for (i = 0; i < sz; i += PGSIZE) {
80107277:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010727d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107280:	76 46                	jbe    801072c8 <copyuvm+0xb8>
        if ((pte = walkpgdir(pgdir, (void *) i, 0)) == 0) {
80107282:	8b 45 08             	mov    0x8(%ebp),%eax
80107285:	31 c9                	xor    %ecx,%ecx
80107287:	89 fa                	mov    %edi,%edx
80107289:	e8 22 f8 ff ff       	call   80106ab0 <walkpgdir>
8010728e:	85 c0                	test   %eax,%eax
80107290:	74 7a                	je     8010730c <copyuvm+0xfc>
        if (!(*pte & PTE_P)) {
80107292:	8b 00                	mov    (%eax),%eax
80107294:	a8 01                	test   $0x1,%al
80107296:	74 67                	je     801072ff <copyuvm+0xef>
        pa = PTE_ADDR(*pte);
80107298:	89 c3                	mov    %eax,%ebx
        flags = PTE_FLAGS(*pte);
8010729a:	25 ff 0f 00 00       	and    $0xfff,%eax
        pa = PTE_ADDR(*pte);
8010729f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
        flags = PTE_FLAGS(*pte);
801072a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if ((mem = kalloc()) == 0) {
801072a8:	e8 33 b6 ff ff       	call   801028e0 <kalloc>
801072ad:	85 c0                	test   %eax,%eax
801072af:	89 c6                	mov    %eax,%esi
801072b1:	75 8d                	jne    80107240 <copyuvm+0x30>
            freevm(d);
801072b3:	83 ec 0c             	sub    $0xc,%esp
801072b6:	ff 75 e0             	pushl  -0x20(%ebp)
801072b9:	e8 02 fe ff ff       	call   801070c0 <freevm>
            return 0;
801072be:	83 c4 10             	add    $0x10,%esp
801072c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            freevm(d);
            return 0;
        }
    }
    return d;
}
801072c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072ce:	5b                   	pop    %ebx
801072cf:	5e                   	pop    %esi
801072d0:	5f                   	pop    %edi
801072d1:	5d                   	pop    %ebp
801072d2:	c3                   	ret    
801072d3:	90                   	nop
801072d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            kfree(mem);
801072d8:	83 ec 0c             	sub    $0xc,%esp
801072db:	56                   	push   %esi
801072dc:	e8 4f b4 ff ff       	call   80102730 <kfree>
            freevm(d);
801072e1:	58                   	pop    %eax
801072e2:	ff 75 e0             	pushl  -0x20(%ebp)
801072e5:	e8 d6 fd ff ff       	call   801070c0 <freevm>
            return 0;
801072ea:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801072f1:	83 c4 10             	add    $0x10,%esp
}
801072f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072fa:	5b                   	pop    %ebx
801072fb:	5e                   	pop    %esi
801072fc:	5f                   	pop    %edi
801072fd:	5d                   	pop    %ebp
801072fe:	c3                   	ret    
            panic("copyuvm: page not present");
801072ff:	83 ec 0c             	sub    $0xc,%esp
80107302:	68 d2 7d 10 80       	push   $0x80107dd2
80107307:	e8 74 91 ff ff       	call   80100480 <panic>
            panic("copyuvm: pte should exist");
8010730c:	83 ec 0c             	sub    $0xc,%esp
8010730f:	68 b8 7d 10 80       	push   $0x80107db8
80107314:	e8 67 91 ff ff       	call   80100480 <panic>
80107319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107320 <uva2ka>:


// Map user virtual address to kernel address.
char*uva2ka(pde_t *pgdir, char *uva)      {
80107320:	55                   	push   %ebp
    pte_t *pte;

    pte = walkpgdir(pgdir, uva, 0);
80107321:	31 c9                	xor    %ecx,%ecx
char*uva2ka(pde_t *pgdir, char *uva)      {
80107323:	89 e5                	mov    %esp,%ebp
80107325:	83 ec 08             	sub    $0x8,%esp
    pte = walkpgdir(pgdir, uva, 0);
80107328:	8b 55 0c             	mov    0xc(%ebp),%edx
8010732b:	8b 45 08             	mov    0x8(%ebp),%eax
8010732e:	e8 7d f7 ff ff       	call   80106ab0 <walkpgdir>
    if ((*pte & PTE_P) == 0) {
80107333:	8b 00                	mov    (%eax),%eax
    }
    if ((*pte & PTE_U) == 0) {
        return 0;
    }
    return (char*)P2V(PTE_ADDR(*pte));
}
80107335:	c9                   	leave  
    if ((*pte & PTE_U) == 0) {
80107336:	89 c2                	mov    %eax,%edx
    return (char*)P2V(PTE_ADDR(*pte));
80107338:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if ((*pte & PTE_U) == 0) {
8010733d:	83 e2 05             	and    $0x5,%edx
    return (char*)P2V(PTE_ADDR(*pte));
80107340:	05 00 00 00 80       	add    $0x80000000,%eax
80107345:	83 fa 05             	cmp    $0x5,%edx
80107348:	ba 00 00 00 00       	mov    $0x0,%edx
8010734d:	0f 45 c2             	cmovne %edx,%eax
}
80107350:	c3                   	ret    
80107351:	eb 0d                	jmp    80107360 <copyout>
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

80107360 <copyout>:

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int copyout(pde_t *pgdir, uint va, void *p, uint len)     {
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	57                   	push   %edi
80107364:	56                   	push   %esi
80107365:	53                   	push   %ebx
80107366:	83 ec 1c             	sub    $0x1c,%esp
80107369:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010736c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010736f:	8b 7d 10             	mov    0x10(%ebp),%edi
    char *buf, *pa0;
    uint n, va0;

    buf = (char*)p;
    while (len > 0) {
80107372:	85 db                	test   %ebx,%ebx
80107374:	75 40                	jne    801073b6 <copyout+0x56>
80107376:	eb 70                	jmp    801073e8 <copyout+0x88>
80107378:	90                   	nop
80107379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        va0 = (uint)PGROUNDDOWN(va);
        pa0 = uva2ka(pgdir, (char*)va0);
        if (pa0 == 0) {
            return -1;
        }
        n = PGSIZE - (va - va0);
80107380:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107383:	89 f1                	mov    %esi,%ecx
80107385:	29 d1                	sub    %edx,%ecx
80107387:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010738d:	39 d9                	cmp    %ebx,%ecx
8010738f:	0f 47 cb             	cmova  %ebx,%ecx
        if (n > len) {
            n = len;
        }
        memmove(pa0 + (va - va0), buf, n);
80107392:	29 f2                	sub    %esi,%edx
80107394:	83 ec 04             	sub    $0x4,%esp
80107397:	01 d0                	add    %edx,%eax
80107399:	51                   	push   %ecx
8010739a:	57                   	push   %edi
8010739b:	50                   	push   %eax
8010739c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010739f:	e8 ac d5 ff ff       	call   80104950 <memmove>
        len -= n;
        buf += n;
801073a4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    while (len > 0) {
801073a7:	83 c4 10             	add    $0x10,%esp
        va = va0 + PGSIZE;
801073aa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
        buf += n;
801073b0:	01 cf                	add    %ecx,%edi
    while (len > 0) {
801073b2:	29 cb                	sub    %ecx,%ebx
801073b4:	74 32                	je     801073e8 <copyout+0x88>
        va0 = (uint)PGROUNDDOWN(va);
801073b6:	89 d6                	mov    %edx,%esi
        pa0 = uva2ka(pgdir, (char*)va0);
801073b8:	83 ec 08             	sub    $0x8,%esp
        va0 = (uint)PGROUNDDOWN(va);
801073bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801073be:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
        pa0 = uva2ka(pgdir, (char*)va0);
801073c4:	56                   	push   %esi
801073c5:	ff 75 08             	pushl  0x8(%ebp)
801073c8:	e8 53 ff ff ff       	call   80107320 <uva2ka>
        if (pa0 == 0) {
801073cd:	83 c4 10             	add    $0x10,%esp
801073d0:	85 c0                	test   %eax,%eax
801073d2:	75 ac                	jne    80107380 <copyout+0x20>
    }
    return 0;
}
801073d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return -1;
801073d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073dc:	5b                   	pop    %ebx
801073dd:	5e                   	pop    %esi
801073de:	5f                   	pop    %edi
801073df:	5d                   	pop    %ebp
801073e0:	c3                   	ret    
801073e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801073eb:	31 c0                	xor    %eax,%eax
}
801073ed:	5b                   	pop    %ebx
801073ee:	5e                   	pop    %esi
801073ef:	5f                   	pop    %edi
801073f0:	5d                   	pop    %ebp
801073f1:	c3                   	ret    
