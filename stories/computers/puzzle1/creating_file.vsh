vshcmd: > # Create an executable ELF file
vshcmd: > as elfhdr.s -o aself.o
vshcmd: > ld -Ttext 0x08048000 --oformat=binary -o elffile.out aself.o
vshcmd: > chmod +x ./elffile.out
vshcmd: > echo && ./elffile.out
puzzle1 [17:57:40] $ puzzle1 [17:57:41] $ puzzle1 [17:57:41] $ 
Magic words can be obtuse.
But reveal an alternate use.
Read, google, deduce.
puzzle1 [17:57:41] $ 
vshcmd: > file elffile.out
elffile.out: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), statically linked, stripped
puzzle1 [17:58:27] $ 
vshcmd: > # Create a valid mbr .
vshcmd: > as mbr_message.s -o asmbr.o
vshcmd: > ld -Ttext 0x7c00 --oformat=binary -o asmbr.out asmbr.o
vshcmd: > qemu-system-x86_64 -enable-kvm -drive file=asmbr.out,index=0,if=floppy,format=raw -boot order=a
puzzle1 [17:58:31] $ puzzle1 [17:58:31] $ puzzle1 [17:58:35] $ 
vshcmd: > python
vshcmd: > import itertools
vshcmd: > with open('elffile.out', 'rb') as infile:
vshcmd: >   elfbytes = infile.read()
vshcmd: > with open('asmbr.out', 'rb') as infile:
vshcmd: >   mbrbytes = infile.read()
vshcmd: > with open('final.bin', 'wb') as outfile:
vshcmd: >   for pos, (left, right) in enumerate(itertools.zip_longest(mbrbytes, elfbytes, fillvalue=0)):
vshcmd: >       if left != 0 and right != 0 and left != right:
vshcmd: >           print("\nFailure at byte position", hex(pos))
vshcmd: >           print("mbr value: ", hex(left))
vshcmd: >           print("ELF value: ", hex(right))
vshcmd: >   outfile.write(bytes([ left | right for left, right in itertools.zip_longest(mbrbytes, elfbytes, fillvalue=0)]))
vshcmd: > exit()
Python 3.6.2 (default, Jul 20 2017, 03:52:27) 
[GCC 7.1.1 20170630] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> >>> ... ... >>> ... ... >>> ... ... ... ... ... ... ... 1024
>>> puzzle1 [17:58:39] $ 
vshcmd: > # Check that output file works as an mbr
vshcmd: > qemu-system-x86_64 -enable-kvm -drive file=final.bin,index=0,if=floppy,format=raw -boot order=a
puzzle1 [18:07:36] $ 
vshcmd: > # N.B. this requires a bochsrc.txt -- just use the most plain one you find via google.
vshcmd: > cat > bochsrc.txt
vshcmd: > megs: 32
vshcmd: > #romimage: file=/usr/share/bochs/BIOS-bochs-latest, address=0xf0000
vshcmd: > #vgaromimage: /usr/share/bochs/VGABIOS-elpin-2.40
vshcmd: > floppya: 1_44=final.bin, status=inserted
vshcmd: > # CHS=7769/16/63
vshcmd: > log: bochsout.txt
vshcmd: > mouse: enabled=0
vshcmd: > bochs
puzzle1 [18:08:52] $ ========================================================================
                       Bochs x86 Emulator 2.6.9
               Built from SVN snapshot on April 9, 2017
                  Compiled on Apr 21 2017 at 23:41:40
========================================================================
00000000000i[      ] BXSHARE not set. using compile time default '/usr/share/bochs'
00000000000i[      ] reading configuration from bochsrc.txt
------------------------------
Bochs Configuration: Main Menu
------------------------------

This is the Bochs Configuration Interface, where you can describe the
machine that you want to simulate.  Bochs has already searched for a
configuration file (typically called bochsrc.txt) and loaded it if it
could be found.  When you are satisfied with the configuration, go
ahead and start the simulation.

You can also start bochs with the -q option to skip these menus.

1. Restore factory default configuration
2. Read options from...
3. Edit options
4. Save options to...
5. Restore the Bochs state from...
6. Begin simulation
7. Quit now

Please choose one: [6] 
vshcmd: > 6
00000000000i[      ] installing x module as the Bochs GUI
00000000000i[      ] using log file bochsout.txt
Next at t=0
(0) [0x0000fffffff0] f000:fff0 (unk. ctxt): jmpf 0xf000:e05b          ; ea5be000f0
<bochs:1> 
vshcmd: > cont
========================================================================
Bochs is exiting with the following message:
[XGUI  ] POWER button turned off.
========================================================================
(0).[264396000] [0x000000007d12] 0000:7d12 (unk. ctxt): jmp .-2 (0x00007d12)      ; ebfe
puzzle1 [18:09:09] $ 
vshcmd: > rm bochsrc.txt
puzzle1 [18:09:13] $ 
vshcmd: > # Check that it works as a binary
vshcmd: > chmod u+x final.bin && ./final.bin
Magic words can be obtuse.
But reveal an alternate use.
Read, google, deduce.
puzzle1 [18:09:19] $ 
vshcmd: > # Show that the file isn't too suspicious
vshcmd: > file final.bin
final.bin: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), statically linked, stripped
puzzle1 [18:09:24] $ 
vshcmd: > readelf -a final.bin
ELF Header:
  Magic:   7f 45 4c 46 01 01 01 00 e9 e4 00 00 00 00 00 00 
  Class:                             ELF32
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       233
  Type:                              EXEC (Executable file)
  Machine:                           Intel 80386
  Version:                           0x1
  Entry point address:               0x8048163
  Start of program headers:          59 (bytes into file)
  Start of section headers:          91 (bytes into file)
  Flags:                             0x0
  Size of this header:               52 (bytes)
  Size of program headers:           32 (bytes)
  Number of program headers:         1
  Size of section headers:           40 (bytes)
  Number of section headers:         3
  Section header string table index: 2

Section Headers:
  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            00000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        08048163 000163 00029d 00   A  0   0 16
  [ 2] .shstrtab         STRTAB          00000000 0000d3 00001b 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  p (processor specific)

There are no section groups in this file.

Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x000000 0x08048000 0x0800a5e9 0x00400 0x00400 R E 0x1000

 Section to Segment mapping:
  Segment Sections...
   00     .text 

There is no dynamic section in this file.

There are no relocations in this file.

The decoding of unwind sections for machine type Intel 80386 is not currently supported.

No version information found in this file.
puzzle1 [18:09:32] $ 
vshcmd: > objdump -x final.bin

final.bin:     file format elf32-i386
final.bin
architecture: i386, flags 0x00000102:
EXEC_P, D_PAGED
start address 0x08048163

Program Header:
    LOAD off    0x00000000 vaddr 0x08048000 paddr 0x0800a5e9 align 2**12
         filesz 0x00000400 memsz 0x00000400 flags r-x

Sections:
Idx Name          Size      VMA       LMA       File off  Algn
  0 .text         0000029d  08048163  0800a74c  00000163  2**4
                  CONTENTS, ALLOC, LOAD, READONLY, DATA
SYMBOL TABLE:
no symbols


puzzle1 [18:09:42] $ 
