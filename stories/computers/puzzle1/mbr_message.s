# Contains those bytes I use from the ELF file, and the code for the mbr.
# Everything after a `vimcmd;` prompt
# Is a command to be run by vim. It's just a keybinding I have that I find
# useful sometimes.
.code16
    .globl _start
# Like in elfhdr.s, marking a section out just so I can tell the linker where
# in memory this is getting loaded.
.text
section_start:
    # ELF header that I have to have
    .byte      0x7F, 'E', 'L', 'F', 1, 1, 1, 0         #   e_ident

    # In case ZF != 0  or  SF != OF
    # Doesn't matter that much, as the ELF header between here and the jg
    # target is pretty harmless, but nice to have.
    jmp _start

    # In case ZF == 0  and SF == OF.
    # This is the case on startup of a qemu instance, but is not the case on
    # startup of a bochs emulation, so account for both.
    # The ELF magic number causes a jmp to 0x47
.fill 0x47 - (. - section_start), 1, 0
    jmp _start

# Find offset of the message
# vimcmd; +1! grep -o -b -a '"' elffile.out | python -c 'import re; print(".set quotation_mark,", hex(int(re.sub(r"(\d+):.*", r"\1", input()))))'
.set quotation_mark, 0xec
    .fill quotation_mark - (. - section_start), 1, 0
quot_char:
    .byte '"'

# Padding to move into the space I've reserved.
    .byte 0
    .byte 0

_start:
    movw $0x7c0     , %ax
    movw %ax        , %ds
    movb 0x3     , %al
    movb $0x0e , %ah
    int $0x10
    movb u_letter - section_start, %al
    movb $0x0e , %ah
    int $0x10
    movb n_letter - section_start, %al
    movb $0x0e     , %ah
    int $0x10
    movb at_char - section_start, %al
    subb $('@' - '!'), %al
    movb $0x0e , %ah
    int $0x10
jmp .


# vimcmd; +1! grep -o -b -a 'My words' elffile.out | python -c 'import re; print(".set message_offset,", hex(int(re.sub(r"(\d+):.*", r"\1", input()))))'
.set message_offset, 0x115
.fill message_offset + 0x13 - (. - section_start), 1, 0
u_letter:
    .byte 'u'
.fill message_offset + 0x46 - (. - section_start), 1, 0
n_letter:
    .byte 'n'
# Find offset of an at sign
# vimcmd; +1! grep -o -b -a '@' elffile.out | python -c 'import re; print(".set at_sign,", hex(int(re.sub(r"(\d+):.*", r"\1", input()))))'
.set at_sign, 0x186
    .fill at_sign - (. - section_start), 1, 0
at_char:
    .byte '@'


.fill 510 - (. - section_start), 1, 0
    .byte 0x55
    .byte 0xAA
