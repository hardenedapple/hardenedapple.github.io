vshcmd: > gcc -Wall -W -Werror -o testprog direct_patch.c
playing_with_elf [10:23:44] $ 
vshcmd: > # Original file works as expected
vshcmd: > ./testprog 'password'
Sorry, that's the wrong password
playing_with_elf [10:23:58] $ 
vshcmd: > ./testprog 'funsies!'
Sorry, that's the wrong password
playing_with_elf [10:23:58] $ 
vshcmd: > ./testprog 'etmrhdr '
Congratulations!!!
playing_with_elf [10:24:00] $ 
vshcmd: > # Get the addresses we need.
vshcmd: > readelf -r testprog

Relocation section '.rela.dyn' at offset 0x3a0 contains 2 entries:
  Offset          Info           Type           Sym. Value    Sym. Name + Addend
000000600ff0  000200000006 R_X86_64_GLOB_DAT 0000000000000000 __libc_start_main@GLIBC_2.2.5 + 0
000000600ff8  000400000006 R_X86_64_GLOB_DAT 0000000000000000 __gmon_start__ + 0

Relocation section '.rela.plt' at offset 0x3d0 contains 2 entries:
  Offset          Info           Type           Sym. Value    Sym. Name + Addend
000000601018  000100000007 R_X86_64_JUMP_SLO 0000000000000000 puts@GLIBC_2.2.5 + 0
000000601020  000300000007 R_X86_64_JUMP_SLO 0000000000000000 strcmp@GLIBC_2.2.5 + 0
playing_with_elf [10:24:01] $ 
vshcmd: > readelf -s testprog | grep altstrcmp
    58: 0000000000400546   157 FUNC    GLOBAL DEFAULT   13 altstrcmp
playing_with_elf [10:24:12] $ 
vshcmd: > # Reloc is 0x601020 (easier than calculting the jump from strcmp@plt)
vshcmd: > # memory location of .got.plt is 601000
vshcmd: > # offset into file is 1000
vshcmd: > # Take off memory location of .got.plt from reloc, and add back on offset into file.
vshcmd: > offset=$(python -c 'print(0x601020 - (0x601000 - 0x1000))')
playing_with_elf [10:24:40] $ 
vshcmd: > python -c 'import sys; sys.stdout.buffer.write(b"\x46\x05\x40")'  | dd of=testprog bs=1 seek=$offset conv=notrunc
3+0 records in
3+0 records out
3 bytes copied, 0.068378 s, 0.0 kB/s
playing_with_elf [10:25:23] $ 
vshcmd: > # Check the patched binary behaves as expected
vshcmd: > ./testprog 'etmrhdr '
Sorry, that's the wrong password
playing_with_elf [10:25:25] $ 
vshcmd: > ./testprog 'funsies!'
Congratulations!!!
playing_with_elf [10:25:32] $ 
