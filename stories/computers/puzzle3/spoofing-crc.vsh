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
Unpacking objects:   1% (1/59)Unpacking objects:   3% (2/59)Unpacking objects:   5% (3/59)Unpacking objects:   6% (4/59)Unpacking objects:   8% (5/59)Unpacking objects:  10% (6/59)Unpacking objects:  11% (7/59)Unpacking objects:  13% (8/59)Unpacking objects:  15% (9/59)Unpacking objects:  16% (10/59)Unpacking objects:  18% (11/59)Unpacking objects:  20% (12/59)Unpacking objects:  22% (13/59)Unpacking objects:  23% (14/59)Unpacking objects:  25% (15/59)Unpacking objects:  27% (16/59)Unpacking objects:  28% (17/59)Unpacking objects:  30% (18/59)Unpacking objects:  32% (19/59)Unpacking objects:  33% (20/59)Unpacking objects:  35% (21/59)Unpacking objects:  37% (22/59)Unpacking objects:  38% (23/59)Unpacking objects:  40% (24/59)Unpacking objects:  42% (25/59)Unpacking objects:  44% (26/59)Unpacking objects:  45% (27/59)Unpacking objects:  47% (28/59)Unpacking objects:  49% (29/59)Unpacking objects:  50% (30/59)remote: Total 59 (delta 0), reused 0 (delta 0), pack-reused 59        
Unpacking objects:  52% (31/59)Unpacking objects:  54% (32/59)Unpacking objects:  55% (33/59)Unpacking objects:  57% (34/59)Unpacking objects:  59% (35/59)Unpacking objects:  61% (36/59)Unpacking objects:  62% (37/59)Unpacking objects:  64% (38/59)Unpacking objects:  66% (39/59)Unpacking objects:  67% (40/59)Unpacking objects:  69% (41/59)Unpacking objects:  71% (42/59)Unpacking objects:  72% (43/59)Unpacking objects:  74% (44/59)Unpacking objects:  76% (45/59)Unpacking objects:  77% (46/59)Unpacking objects:  79% (47/59)Unpacking objects:  81% (48/59)Unpacking objects:  83% (49/59)Unpacking objects:  84% (50/59)Unpacking objects:  86% (51/59)Unpacking objects:  88% (52/59)Unpacking objects:  89% (53/59)Unpacking objects:  91% (54/59)Unpacking objects:  93% (55/59)Unpacking objects:  94% (56/59)Unpacking objects:  96% (57/59)Unpacking objects:  98% (58/59)Unpacking objects: 100% (59/59)Unpacking objects: 100% (59/59), 113.10 KiB | 639.00 KiB/s, done.
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

