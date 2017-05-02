vshcmd: > gcc -c -W -Wall -Werror -fPIC check_password.c
vshcmd: > gcc -shared -o libcheckpass.so check_password.o
vshcmd: > gcc -g -L$(pwd) -Wl,-rpath=$(pwd) -Wall -o testprog other_libraries.c -lcheckpass
elf_override [16:25:01] $ elf_override [16:25:01] $ other_libraries.c: In function ‘get_object_phdr’:
other_libraries.c:208:17: warning: assignment discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
         c->phdr = info->dlpi_phdr;
                 ^
elf_override [16:25:01] $ 
vshcmd: > ./testprog 'etmrhdr '
Congratulations!!!
elf_override [16:25:03] $ 
vshcmd: > ./testprog 'hello'
Sorry, that's the wrong password
elf_override [16:25:03] $ 
vshcmd: > ./testprog 'funsies!'
So close ... !!
elf_override [16:25:04] $ 
