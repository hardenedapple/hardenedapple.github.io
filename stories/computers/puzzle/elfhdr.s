# TODO Stop `file` saying "with debug_info"
.code32
    .globl _start
# This is for the linker to have a named section that I can tell it to keep at
# the start of the file. The fact it's named .text here doesn't matter in the
# slightest, I could have used .data and the linker flag -Tdata, or I could
# have used .section mysection, "2" and --section-start=mysection=0x7c00 .
.text
ehdr:                                                 # Elf32_Ehdr
              .byte      0x7F, 'E', 'L', 'F', 1, 1, 1, 0         #   e_ident
              # Can overwrite some bytes here -- as was done in
              # http://www.muppetlabs.com/~breadbox/software/tiny/teensy.html
              # (which is awesome by the way ... you should check it out).
              # We do this so that if the `jg` instruction that is the two
              # bytes of the ELF header isn't triggered, we can jmp to the mbr
              # code without going over the rest of this header.
              # It doesn't appear to matter -- there aren't any bytes that
              # would be interpreted as troublesome instructions between here
              # and the p_paddr member, but it's nice to be sure.
      .fill 8, 1, 0
              .word      2                               #   e_type
              .word      3                               #   e_machine
              .long      1                               #   e_version
              .long      _start                          #   e_entry
              .long      phdr - ehdr                     #   e_phoff
              .long      shdr - ehdr                     #   e_shoff
              .long      0                               #   e_flags
              .word      ehdrsize                        #   e_ehsize
              .word      phdrsize                        #   e_phentsize
              .word      1                               #   e_phnum
              .word      shdrsize                        #   e_shentsize
              # One for the reserved entry
              # one for a .text section
              # and one for the string table.
              # Possibly in the future, contain the mbr code in a .special
              # segment as an extra hint that can be seen with objdump/readelf?
              # Decide once difficulty level has been determined.
              .word      3                               #   e_shnum
              .word      2                               #   e_shstrndx

.set ehdrsize, . - ehdr

.fill 7, 1, 0
phdr:                                                 # Elf32_Phdr
              .long      1                               #   p_type
              .long      0                               #   p_offset
              .long      0x08048000                      #   p_vaddr
              # Physical addressing is not relevant on Linux, according to
              # http://www.sco.com/developers/gabi/latest/ch5.pheader.html
              # On System V this member has unspecified contents for executable
              # files.
              # man elf(5) say that on BSD it must be 0 ... but it seems to
              # work fine on my Linux machine.
              # I've padded the file above here, and will overwrite this value
              # with a jmp instruction so the possible execution of the jg
              # instruction that is the first two bytes of the ELF magic number
              # moves us to an instruction we've controlled and that gets us
              # back to the embedded mbr code
              # N.B. As far as I've observed, the jg instruction is executed
              # when I boot this file with qemu-system-x86_64, but not when I
              # boot it with bochs. I didn't find anything saying what state
              # the condition flags should be in, so I guess that's
              # unspecified.
              .long      0x08000000                      #   p_paddr
              # NOTE: We could put the jmp instruction we need in the p_filesz
              # and p_memsz members of this struct. For this to work we
              # need p_memsz and p_filesz to be the same (or a SHT_NOBITS
              # section). Otherwise we get a Segmentation fault startup of the
              # program.
              .long      filesize                        #   p_filesz
              .long      filesize                        #   p_memsz
              .long      5                               #   p_flags
              .long      0x1000                          #   p_align

.set phdrsize,     . - phdr


# Reserved first section header entry.
# See man elf(5), second paragraph under section "Section header (Shdr)"
shdr:
.fill 10, 4, 0
.set shdrsize,     . - shdr


# .text section header
textshdr:
            .long  1   # sh_name
            .long  1   # sh_type SHT_PROGBITS
            .long  2   # sh_flags SHF_ALLOC
            .long  _start # sh_addr, start of the .text section
            .long  _start - ehdr # sh_offset (position in file)
            .long  progend - _start    # sh_size
            .long  0   # sh_link
            .long  0   # sh_info
            .long  16  # sh_addralign
            .long  0   # sh_entsize


# String section header
stringshdr:
            .long  shstrtabname   # sh_name
            .long  3   # sh_type -- SHT_STRTAB
            .long  0   # sh_flags
            .long  0   # sh_addr (position in loaded memory)
            .long  stringsection - ehdr # sh_offset (position in file)
            .long  stringsection_size # sh_size
            .long  0   # sh_link
            .long  0   # sh_info
            .long  1   # sh_addralign
            .long  0   # sh_entsize

# String section bits
stringsection:
            # Name for "first" (reserved) section number
            .byte 0
            .asciz ".text"
.set shstrtabname, . - stringsection
            .asciz ".shstrtab"
            # Currently unused segment name ... other than that I grep the
            # file for it to find where my space for the mbr is.
            .asciz ".special\""
.set stringsection_size, . - stringsection

# Space for the mbr
# Would be cool to have the mbr as part of the .data section of the main
# executable.
# Would be even better to overlay the instructions with something else -- like
# the instructions for the ELF file.
# Not sure if it would make it too difficult a challenge ... doubt people even
# look into these instructions anyway.
# Plus, may be difficult to do for me to bother ;-)
.fill 0x27, 1, 0

message:
    .ascii "My words may be obtuse.\n"
    .ascii "But they reveal a truth.\n"
    .ascii "Read them carefully and give me a ...\n"
.set message_len, . - message

_start:
    # Print message
    movl $message_len, %edx
    movl $message, %ecx
    movl $1,  %ebx
    movl $4,  %eax
    int $0x80
    # exit
    mov $1, %bl
    xor %eax, %eax
    inc %eax
    int $0x80

# Maybe should have more code, so that the bootable flag is hidden?
# Would be cool to find an instruction that contains the bootable flag (maybe
# even just a mov with a literal) so it's completely hidden.
# Probably would make the challenge too hard.
.org 1024, 0
.set progend, .
.set filesize, . - ehdr
