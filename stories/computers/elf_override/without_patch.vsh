vshcmd: > gcc -Wall -W -o testprog without_patch.c
playing_with_elf [11:33:01] $ 
vshcmd: > # Check the patched binary behaves as expected
vshcmd: > ./testprog 'etmrhdr '
Congratulations!!!
playing_with_elf [11:33:02] $ 
vshcmd: > ./testprog 'funsies!'
So close ... !!
playing_with_elf [11:33:03] $ 
vshcmd: > ./testprog 'hello'
Sorry, that's the wrong password
playing_with_elf [11:33:03] $ 
