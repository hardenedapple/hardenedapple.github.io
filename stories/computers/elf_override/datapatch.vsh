vshcmd: > gcc -Wall -W -Werror -o testprog datapatch.c
playing_with_elf [10:30:13] $ 
vshcmd: > # Original file segfaults because of the value stored in strcmpgot
vshcmd: > ./testprog hello
Segmentation fault (core dumped)
playing_with_elf [10:30:53] $ 
vshcmd: > # Get the addresses we need.
vshcmd: > readelf -s testprog | grep strcmpgot
    48: 0000000000601038     8 OBJECT  GLOBAL DEFAULT   24 strcmpgot
playing_with_elf [10:31:15] $ 
vshcmd: > readelf --sections testprog | grep -A 2 '.data'
  [15] .rodata           PROGBITS         0000000000400740  00000740
       0000000000000071  0000000000000000   A       0     0     8
  [16] .eh_frame_hdr     PROGBITS         00000000004007b4  000007b4
--
  [24] .data             PROGBITS         0000000000601028  00001028
       0000000000000018  0000000000000000  WA       0     0     8
  [25] .bss              NOBITS           0000000000601040  00001040
playing_with_elf [10:31:38] $ 
vshcmd: > # Position of strcmpgot is at 601038 in memory, it's in the .data
vshcmd: > # section that starts at offset 1028 and becomes at memory 601028 so
vshcmd: > # it gets shifted by 60000
vshcmd: > offset=$(python -c 'print(0x1038)')
playing_with_elf [10:32:59] $ 
vshcmd: > # Position of strcmp entry in the .got.plt table is 0x601020
vshcmd: > readelf -r testprog

Relocation section '.rela.dyn' at offset 0x3a0 contains 2 entries:
  Offset          Info           Type           Sym. Value    Sym. Name + Addend
000000600ff0  000200000006 R_X86_64_GLOB_DAT 0000000000000000 __libc_start_main@GLIBC_2.2.5 + 0
000000600ff8  000400000006 R_X86_64_GLOB_DAT 0000000000000000 __gmon_start__ + 0

Relocation section '.rela.plt' at offset 0x3d0 contains 2 entries:
  Offset          Info           Type           Sym. Value    Sym. Name + Addend
000000601018  000100000007 R_X86_64_JUMP_SLO 0000000000000000 puts@GLIBC_2.2.5 + 0
000000601020  000300000007 R_X86_64_JUMP_SLO 0000000000000000 strcmp@GLIBC_2.2.5 + 0
playing_with_elf [10:33:25] $ 
vshcmd: > # Write address of strcmp entry in .got.plt table into the strcmpgot
vshcmd: > # global in my file.
vshcmd: > python -c 'import sys; sys.stdout.buffer.write(b"\x20\x10\x60")'  | dd of=testprog bs=1 seek=$offset conv=notrunc
3+0 records in
3+0 records out
3 bytes copied, 0.0694957 s, 0.0 kB/s
playing_with_elf [10:34:17] $ 
vshcmd: > # Check the patched binary behaves as expected
vshcmd: > ./testprog 'etmrhdr '
Congratulations!!!
playing_with_elf [10:34:19] $ 
vshcmd: > ./testprog 'funsies!'
So close ... !!
playing_with_elf [10:34:20] $ 
vshcmd: > ./testprog 'hello'
Sorry, that's the wrong password
playing_with_elf [10:34:22] $ 
