vshcmd: > # I'm having difficulty finding a valid modification to my original
vshcmd: > # PLTE that will have the same CRC.
vshcmd: > #
vshcmd: > # I found the stack overflow questions below.
vshcmd: > # https://stackoverflow.com/questions/48247647/how-do-i-modify-a-file-while-maintaining-its-crc-32-checksum
vshcmd: > # https://stackoverflow.com/questions/1515914/crc32-collision
vshcmd: > #
vshcmd: > # One of them suggested the command line program `spoof`.
vshcmd: > # This is me trying to use that program.
vshcmd: > git clone https://github.com/madler/spoof
Cloning into 'spoof'...
remote: Enumerating objects: 59, done.        
Unpacking objects:   1% (1/59)
Unpacking objects:  52% (31/59)
own-stego [11:51:11] $ 
vshcmd: > cd spoof
spoof [11:55:25] $ 
vshcmd: > ls
codewords.txt  fline.c  fline.h  getcodes  README.md  ruse.cc  spoof.c
spoof [11:55:29] $ 
vshcmd: > gcc -std=c99 -o spoof spoof.c fline.c
spoof [12:04:40] $ 
vshcmd: > # Using the program requires the following arguments:
vshcmd: > #     degree polynomial reflect
vshcmd: > #     crc length
vshcmd: > #     offset_1 position_1
vshcmd: > #     offset_2 position_2
vshcmd: > #     ...
vshcmd: > #     offset_n position_n
vshcmd: > # `degree` is the number of bits in the CRC in decimal.
vshcmd: > # Taken from the extracting-letters.vsh file.
vshcmd: > #     32
