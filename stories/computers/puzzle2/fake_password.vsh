vshcmd: > gcc -Wall -W -Werror -o test_password{,.c}
fake_plt [17:38:03] $ 
vshcmd: > # Original file works as expected
vshcmd: > ./test_password 'password'
Sorry, that's the wrong password
fake_plt [17:38:05] $ 
vshcmd: > ./test_password 'funsies!'
Sorry, that's the wrong password
fake_plt [17:38:05] $ 
vshcmd: > ./test_password 'etmrhdr '
Congratulations!!!
fake_plt [17:38:06] $ 
vshcmd: > # Get the addresses we need.
vshcmd: > readelf -r test_password

Relocation section '.rela.dyn' at offset 0x3a0 contains 2 entries:
  Offset          Info           Type           Sym. Value    Sym. Name + Addend
000000600ff0  000200000006 R_X86_64_GLOB_DAT 0000000000000000 __libc_start_main@GLIBC_2.2.5 + 0
000000600ff8  000400000006 R_X86_64_GLOB_DAT 0000000000000000 __gmon_start__ + 0

Relocation section '.rela.plt' at offset 0x3d0 contains 2 entries:
  Offset          Info           Type           Sym. Value    Sym. Name + Addend
000000601018  000100000007 R_X86_64_JUMP_SLO 0000000000000000 puts@GLIBC_2.2.5 + 0
000000601020  000300000007 R_X86_64_JUMP_SLO 0000000000000000 strcmp@GLIBC_2.2.5 + 0
fake_plt [17:38:08] $ 
vshcmd: > readelf --hex-dump=.got.plt test_password

Hex dump of section '.got.plt':
 NOTE: This section has relocations against it, but these have NOT been applied to this dump.
  0x00601000 200e6000 00000000 00000000 00000000  .`.............
  0x00601010 00000000 00000000 36044000 00000000 ........6.@.....
  0x00601020 46044000 00000000                   F.@.....

fake_plt [17:38:11] $ 
vshcmd: > objdump -h test_password | grep -E -A 1 \(Sections\|.got.plt\)
Sections:
Idx Name          Size      VMA               LMA               File off  Algn
--
 22 .got.plt      00000028  0000000000601000  0000000000601000  00001000  2**3
                  CONTENTS, ALLOC, LOAD, DATA
fake_plt [17:41:40] $ 
vshcmd: > objdump -j .plt -d test_password

test_password:     file format elf64-x86-64


Disassembly of section .plt:

0000000000400420 <.plt>:
  400420:	ff 35 e2 0b 20 00    	pushq  0x200be2(%rip)        # 601008 <_GLOBAL_OFFSET_TABLE_+0x8>
  400426:	ff 25 e4 0b 20 00    	jmpq   *0x200be4(%rip)        # 601010 <_GLOBAL_OFFSET_TABLE_+0x10>
  40042c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000400430 <puts@plt>:
  400430:	ff 25 e2 0b 20 00    	jmpq   *0x200be2(%rip)        # 601018 <puts@GLIBC_2.2.5>
  400436:	68 00 00 00 00       	pushq  $0x0
  40043b:	e9 e0 ff ff ff       	jmpq   400420 <.plt>

0000000000400440 <strcmp@plt>:
  400440:	ff 25 da 0b 20 00    	jmpq   *0x200bda(%rip)        # 601020 <strcmp@GLIBC_2.2.5>
  400446:	68 01 00 00 00       	pushq  $0x1
  40044b:	e9 d0 ff ff ff       	jmpq   400420 <.plt>
fake_plt [17:38:30] $ 
vshcmd: > cp test_password patchedbinary
fake_plt [17:39:02] $ 
vshcmd: > # Reloc is 0x601020 (easier than calculting the jump from strcmp@plt)
vshcmd: > # memory location of .got.plt is 601000
vshcmd: > # offset into file is 1000
vshcmd: > # Take off memory location of .got.plt from reloc, and add back on offset into file.
vshcmd: > offset=$(python -c 'print(0x1020)')
fake_plt [17:43:15] $ 
vshcmd: > # Address of __exit_elf64 is 0x400546 -- write these bytes into the .got position.
vshcmd: > objdump -d test_password | grep exit_elf64 | head -1
0000000000400546 <___exit_elf64>:
fake_plt [17:38:54] $ 
vshcmd: > python -c 'import sys; sys.stdout.buffer.write(b"\x46\x05\x40")'  | dd of=patchedbinary bs=1 seek=$offset conv=notrunc
3+0 records in
3+0 records out
3 bytes copied, 0.07006 s, 0.0 kB/s
fake_plt [17:43:16] $ 
vshcmd: > # Check the patched binary behaves as expected
vshcmd: > ./patchedbinary 'etmrhdr '
Sorry, that's the wrong password
fake_plt [17:43:28] $ 
vshcmd: > ./patchedbinary 'funsies!'
Congratulations!!!
fake_plt [17:43:30] $ 
