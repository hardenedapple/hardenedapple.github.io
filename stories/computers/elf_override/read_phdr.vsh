vshcmd: > gcc -Wall -W -o testprog read_phdr.c -g
read_phdr.c: In function ‘get_object_phdr’:
read_phdr.c:185:17: warning: assignment discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
         c->phdr = info->dlpi_phdr;
                 ^
read_phdr.c:181:55: warning: unused parameter ‘size’ [-Wunused-parameter]
 int get_object_phdr(struct dl_phdr_info *info, size_t size, void *data)
                                                       ^~~~
elf_override [16:23:06] $ 
vshcmd: > ./testprog 'password'
Sorry, that's the wrong password
elf_override [16:23:09] $ 
vshcmd: > ./testprog 'funsies!'
So close ... !!
elf_override [16:23:10] $ 
vshcmd: > ./testprog 'etmrhdr '
Congratulations!!!
elf_override [16:23:10] $ 
