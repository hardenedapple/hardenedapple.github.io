vshcmd: > gdb ./testprog
Reading symbols from ./testprog...(no debugging symbols found)...done.
(gdb) 
vshcmd: > start
Temporary breakpoint 1 at 0x4007f4
Starting program: /home/matthew/share/hardenedapple.github.io/stories/computers/elf_override/testprog 

Temporary breakpoint 1, 0x00000000004007f4 in main ()
(gdb) 
vshcmd: > x/100xb 0x400398
00	6c	69	62	64	6c	2e	73
6f	2e	32	00	5f	5f	67	6d
6f	6e	5f	73	74	61	72	74
5f	5f	00	64	6c	6f	70	65
6e	00	64	6c	73	79	6d	00
6c	69	62	63	2e	73	6f	2e
36	00	70	75	74	73	00	5f
5f	61	73	73	65	72	74	5f
66	61	69	6c	00	70	72	69
6e	74	66	00	73	74	72	63
6d	70	00	5f	5f	6c	69	62
63	5f	73	74	61	72	74	5f
6d	61	69	6e
(gdb) 
vshcmd: > !xxd -r -p
 libdl.so.2 __gmon_start__ dlopen dlsym libc.so.6 puts __assert_fail printf strcmp __libc_start_main
vshcmd: > info target
Symbols from "/home/matthew/share/hardenedapple.github.io/stories/computers/elf_override/testprog".
Native process:
	Using the running image of child process 1085.
	While running this, GDB does not access memory from...
Local exec file:
	`/home/matthew/share/hardenedapple.github.io/stories/computers/elf_override/testprog', file type elf64-x86-64.
	Entry point: 0x4005b0
	0x0000000000400238 - 0x0000000000400254 is .interp
	0x0000000000400254 - 0x0000000000400274 is .note.ABI-tag
	0x0000000000400274 - 0x0000000000400298 is .note.gnu.build-id
	0x0000000000400298 - 0x00000000004002bc is .gnu.hash
	0x00000000004002c0 - 0x0000000000400398 is .dynsym
	0x0000000000400398 - 0x0000000000400409 is .dynstr
	0x000000000040040a - 0x000000000040041c is .gnu.version
	0x0000000000400420 - 0x0000000000400460 is .gnu.version_r
	0x0000000000400460 - 0x0000000000400490 is .rela.dyn
	0x0000000000400490 - 0x0000000000400520 is .rela.plt
	0x0000000000400520 - 0x0000000000400537 is .init
	0x0000000000400540 - 0x00000000004005b0 is .plt
	0x00000000004005b0 - 0x0000000000400962 is .text
	0x0000000000400964 - 0x000000000040096d is .fini
	0x0000000000400970 - 0x0000000000400a28 is .rodata
	0x0000000000400a28 - 0x0000000000400a74 is .eh_frame_hdr
	0x0000000000400a78 - 0x0000000000400bcc is .eh_frame
	0x0000000000600df8 - 0x0000000000600e00 is .init_array
	0x0000000000600e00 - 0x0000000000600e08 is .fini_array
	0x0000000000600e08 - 0x0000000000600e10 is .jcr
	0x0000000000600e10 - 0x0000000000600ff0 is .dynamic
	0x0000000000600ff0 - 0x0000000000601000 is .got
	0x0000000000601000 - 0x0000000000601048 is .got.plt
	0x0000000000601048 - 0x0000000000601058 is .data
	0x0000000000601058 - 0x0000000000601060 is .bss
	0x00007ffff7dda1c8 - 0x00007ffff7dda1ec is .note.gnu.build-id in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7dda1f0 - 0x00007ffff7dda338 is .hash in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7dda338 - 0x00007ffff7dda49c is .gnu.hash in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7dda4a0 - 0x00007ffff7dda740 is .dynsym in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7dda740 - 0x00007ffff7dda8ea is .dynstr in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7dda8ea - 0x00007ffff7dda922 is .gnu.version in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7dda928 - 0x00007ffff7dda9cc is .gnu.version_d in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7dda9d0 - 0x00007ffff7ddab38 is .rela.dyn in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7ddab40 - 0x00007ffff7ddab50 is .plt in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7ddab50 - 0x00007ffff7ddab80 is .plt.got in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7ddab80 - 0x00007ffff7df5f20 is .text in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7df5f20 - 0x00007ffff7df9ea0 is .rodata in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7df9ea0 - 0x00007ffff7dfa4fc is .eh_frame_hdr in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7dfa500 - 0x00007ffff7dfca38 is .eh_frame in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7ffcba0 - 0x00007ffff7ffce3c is .data.rel.ro in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7ffce40 - 0x00007ffff7ffcfa0 is .dynamic in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7ffcfa0 - 0x00007ffff7ffcff0 is .got in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7ffd000 - 0x00007ffff7ffdf78 is .data in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7ffdf80 - 0x00007ffff7ffe0f0 is .bss in /lib64/ld-linux-x86-64.so.2
	0x00007ffff7ffa120 - 0x00007ffff7ffa15c is .hash in system-supplied DSO at 0x7ffff7ffa000
	0x00007ffff7ffa160 - 0x00007ffff7ffa1a8 is .gnu.hash in system-supplied DSO at 0x7ffff7ffa000
	0x00007ffff7ffa1a8 - 0x00007ffff7ffa298 is .dynsym in system-supplied DSO at 0x7ffff7ffa000
	0x00007ffff7ffa298 - 0x00007ffff7ffa2f6 is .dynstr in system-supplied DSO at 0x7ffff7ffa000
	0x00007ffff7ffa2f6 - 0x00007ffff7ffa30a is .gnu.version in system-supplied DSO at 0x7ffff7ffa000
	0x00007ffff7ffa310 - 0x00007ffff7ffa348 is .gnu.version_d in system-supplied DSO at 0x7ffff7ffa000
	0x00007ffff7ffa348 - 0x00007ffff7ffa458 is .dynamic in system-supplied DSO at 0x7ffff7ffa000
	0x00007ffff7ffa458 - 0x00007ffff7ffa798 is .rodata in system-supplied DSO at 0x7ffff7ffa000
	0x00007ffff7ffa798 - 0x00007ffff7ffa7d4 is .note in system-supplied DSO at 0x7ffff7ffa000
	0x00007ffff7ffa7d4 - 0x00007ffff7ffa810 is .eh_frame_hdr in system-supplied DSO at 0x7ffff7ffa000
	0x00007ffff7ffa810 - 0x00007ffff7ffa928 is .eh_frame in system-supplied DSO at 0x7ffff7ffa000
	0x00007ffff7ffa930 - 0x00007ffff7ffadba is .text in system-supplied DSO at 0x7ffff7ffa000
	0x00007ffff7ffadba - 0x00007ffff7ffadfb is .altinstructions in system-supplied DSO at 0x7ffff7ffa000
	0x00007ffff7ffadfb - 0x00007ffff7ffae0b is .altinstr_replacement in system-supplied DSO at 0x7ffff7ffa000
	0x00007ffff7bd61c8 - 0x00007ffff7bd61ec is .note.gnu.build-id in /usr/lib/libdl.so.2
	0x00007ffff7bd61ec - 0x00007ffff7bd620c is .note.ABI-tag in /usr/lib/libdl.so.2
	0x00007ffff7bd6210 - 0x00007ffff7bd62d4 is .gnu.hash in /usr/lib/libdl.so.2
	0x00007ffff7bd62d8 - 0x00007ffff7bd66e0 is .dynsym in /usr/lib/libdl.so.2
	0x00007ffff7bd66e0 - 0x00007ffff7bd691d is .dynstr in /usr/lib/libdl.so.2
	0x00007ffff7bd691e - 0x00007ffff7bd6974 is .gnu.version in /usr/lib/libdl.so.2
	0x00007ffff7bd6978 - 0x00007ffff7bd6a1c is .gnu.version_d in /usr/lib/libdl.so.2
	0x00007ffff7bd6a20 - 0x00007ffff7bd6a80 is .gnu.version_r in /usr/lib/libdl.so.2
	0x00007ffff7bd6a80 - 0x00007ffff7bd6d68 is .rela.dyn in /usr/lib/libdl.so.2
	0x00007ffff7bd6d68 - 0x00007ffff7bd6d7f is .init in /usr/lib/libdl.so.2
	0x00007ffff7bd6d80 - 0x00007ffff7bd6d90 is .plt in /usr/lib/libdl.so.2
	0x00007ffff7bd6d90 - 0x00007ffff7bd6e20 is .plt.got in /usr/lib/libdl.so.2
	0x00007ffff7bd6e20 - 0x00007ffff7bd7ade is .text in /usr/lib/libdl.so.2
	0x00007ffff7bd7ae0 - 0x00007ffff7bd7ae9 is .fini in /usr/lib/libdl.so.2
	0x00007ffff7bd7aec - 0x00007ffff7bd7b8f is .rodata in /usr/lib/libdl.so.2
	0x00007ffff7bd7b90 - 0x00007ffff7bd7c54 is .eh_frame_hdr in /usr/lib/libdl.so.2
	0x00007ffff7bd7c58 - 0x00007ffff7bd7fdc is .eh_frame in /usr/lib/libdl.so.2
	0x00007ffff7bd7fe0 - 0x00007ffff7bd8198 is .hash in /usr/lib/libdl.so.2
	0x00007ffff7dd8d08 - 0x00007ffff7dd8d18 is .init_array in /usr/lib/libdl.so.2
	0x00007ffff7dd8d18 - 0x00007ffff7dd8d28 is .fini_array in /usr/lib/libdl.so.2
	0x00007ffff7dd8d28 - 0x00007ffff7dd8d30 is .jcr in /usr/lib/libdl.so.2
	0x00007ffff7dd8d30 - 0x00007ffff7dd8f30 is .dynamic in /usr/lib/libdl.so.2
	0x00007ffff7dd8f30 - 0x00007ffff7dd9000 is .got in /usr/lib/libdl.so.2
	0x00007ffff7dd9000 - 0x00007ffff7dd9018 is .got.plt in /usr/lib/libdl.so.2
	0x00007ffff7dd9018 - 0x00007ffff7dd9020 is .data in /usr/lib/libdl.so.2
	0x00007ffff7dd9020 - 0x00007ffff7dd9090 is .bss in /usr/lib/libdl.so.2
	0x00007ffff7832270 - 0x00007ffff7832294 is .note.gnu.build-id in /usr/lib/libc.so.6
	0x00007ffff7832294 - 0x00007ffff78322b4 is .note.ABI-tag in /usr/lib/libc.so.6
	0x00007ffff78322b8 - 0x00007ffff7835dc4 is .gnu.hash in /usr/lib/libc.so.6
	0x00007ffff7835dc8 - 0x00007ffff78431a8 is .dynsym in /usr/lib/libc.so.6
	0x00007ffff78431a8 - 0x00007ffff7848c43 is .dynstr in /usr/lib/libc.so.6
	0x00007ffff7848c44 - 0x00007ffff7849dec is .gnu.version in /usr/lib/libc.so.6
	0x00007ffff7849df0 - 0x00007ffff784a1ac is .gnu.version_d in /usr/lib/libc.so.6
	0x00007ffff784a1b0 - 0x00007ffff784a1e0 is .gnu.version_r in /usr/lib/libc.so.6
	0x00007ffff784a1e0 - 0x00007ffff78519b0 is .rela.dyn in /usr/lib/libc.so.6
	0x00007ffff78519b0 - 0x00007ffff7851a70 is .rela.plt in /usr/lib/libc.so.6
	0x00007ffff7851a70 - 0x00007ffff7851b00 is .plt in /usr/lib/libc.so.6
	0x00007ffff7851b00 - 0x00007ffff7851b38 is .plt.got in /usr/lib/libc.so.6
	0x00007ffff7851b40 - 0x00007ffff7981a43 is .text in /usr/lib/libc.so.6
	0x00007ffff7981a50 - 0x00007ffff7982858 is __libc_freeres_fn in /usr/lib/libc.so.6
	0x00007ffff7982860 - 0x00007ffff7982a72 is __libc_thread_freeres_fn in /usr/lib/libc.so.6
	0x00007ffff7982a80 - 0x00007ffff79a34c0 is .rodata in /usr/lib/libc.so.6
	0x00007ffff79a34c0 - 0x00007ffff79a34de is .interp in /usr/lib/libc.so.6
	0x00007ffff79a34e0 - 0x00007ffff79a8efc is .eh_frame_hdr in /usr/lib/libc.so.6
	0x00007ffff79a8f00 - 0x00007ffff79c8e14 is .eh_frame in /usr/lib/libc.so.6
	0x00007ffff79c8e14 - 0x00007ffff79c9205 is .gcc_except_table in /usr/lib/libc.so.6
	0x00007ffff79c9208 - 0x00007ffff79cc544 is .hash in /usr/lib/libc.so.6
	0x00007ffff7bcc788 - 0x00007ffff7bcc798 is .tdata in /usr/lib/libc.so.6
	0x00007ffff7bcc798 - 0x00007ffff7bcc800 is .tbss in /usr/lib/libc.so.6
	0x00007ffff7bcc798 - 0x00007ffff7bcc7a0 is .init_array in /usr/lib/libc.so.6
	0x00007ffff7bcc7a0 - 0x00007ffff7bcc898 is __libc_subfreeres in /usr/lib/libc.so.6
	0x00007ffff7bcc898 - 0x00007ffff7bcc8a0 is __libc_atexit in /usr/lib/libc.so.6
	0x00007ffff7bcc8a0 - 0x00007ffff7bcc8c0 is __libc_thread_subfreeres in /usr/lib/libc.so.6
	0x00007ffff7bcc8c0 - 0x00007ffff7bcd628 is __libc_IO_vtables in /usr/lib/libc.so.6
	0x00007ffff7bcd640 - 0x00007ffff7bcfb60 is .data.rel.ro in /usr/lib/libc.so.6
	0x00007ffff7bcfb60 - 0x00007ffff7bcfd50 is .dynamic in /usr/lib/libc.so.6
	0x00007ffff7bcfd50 - 0x00007ffff7bcffe8 is .got in /usr/lib/libc.so.6
	0x00007ffff7bd0000 - 0x00007ffff7bd0058 is .got.plt in /usr/lib/libc.so.6
	0x00007ffff7bd0060 - 0x00007ffff7bd16e0 is .data in /usr/lib/libc.so.6
	0x00007ffff7bd16e0 - 0x00007ffff7bd5930 is .bss in /usr/lib/libc.so.6
(gdb) 
vshcmd: > x/9xg 0x400400
0x400400:	0x0000000000601018	0x0000000100000007
0x400410:	0x0000000000000000	0x0000000000601020
0x400420:	0x0000000200000007	0x0000000000000000
0x400430:	0x0000000000601028	0x0000000500000007
0x400440:	0x0000000000000000
(gdb) 
