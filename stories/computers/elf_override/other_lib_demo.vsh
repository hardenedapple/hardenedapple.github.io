vshcmd: > gcc -c -W -Wall -Werror -fPIC check_password.c
vshcmd: > gcc -shared -o libcheckpass.so check_password.o
vshcmd: > gcc -g -L$(pwd) -Wl,-rpath=$(pwd) -Wall -o testprog other_libraries.c -lcheckpass
elf_override [20:32:03] $ elf_override [20:32:03] $ other_libraries.c: In function ‘print_object_info’:
other_libraries.c:214:17: warning: assignment discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
         c->phdr = info->dlpi_phdr;
                 ^
elf_override [20:32:03] $ 
vshcmd: > ./testprog 'etmrhdr '
Congratulations!!!
elf_override [20:32:05] $ 
vshcmd: > ./testprog 'hello'
Sorry, that's the wrong password
elf_override [20:32:06] $ 
vshcmd: > ./testprog 'funsies!'
So close ... !!
elf_override [20:32:07] $ 
