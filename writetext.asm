section .bss
  file: resb 4

section .data
  promptMsg db "Start entering your text now", 0xa, "Ctrl+D to write and exit", 0xa
  len equ $-promptMsg
  errorMsg db "Error. Usage: writetext FILENAME", 0xa
  errorLen equ $-errorMsg
  buf: db 100

section .text
global _start

_start:

  pop ebx                   ;   pop argc
  cmp ebx, 2                ;   check if argc is 2
  jne _nofile               ;   exit if not

  pop ebx                   ;   pop argv[0] (name of program)

  pop ebx                   ;   pop name of the file to be written to
  cmp ebx, 0                ;   check if ebx is not zero
  jbe _exit                 ;   exit

  mov [file], ebx           ;   store file name
                            ;   check if file exists
  mov eax, 5                ;   sys_open file with fine name in ebx
  mov ebx, [file]           ;   name of the file to be opened
  mov ecx, 2001o            ;   0_RDWR + 0_APPEND
  int 80h

  push eax                  ;   store returned file pointer
  cmp eax, 0
  jg _prompt_user	          ;   if file exists, do not create it
  pop eax                   ;   grab file pointer


_create_and_open:

  mov eax, 8                ;   sys_create
  mov ecx, 511              ;   access rights
  int 80h

  cmp eax, 0                ;   check if file was created
  jbe _exit                 ;   error creating file

  mov eax, 5                ;   sys_open file with fine name in ebx
  mov ebx, [file]           ;   name of the file to be opened
  mov ecx, 2001o            ;   0_RDWR + 0_APPEND
  int 80h

  cmp eax, 0                ;   check if fd in eax > 0
  jbe _exit                 ;   cannot open file

  push eax                  ;	  store file pointer


_prompt_user:

  mov ecx, promptMsg
  mov edx, len
  mov ebx, 1                ;   stdout
  mov eax, 4                ;   write
  int 80h

  pop ebx                   ;   pop the file pointer into ebx


L1:

  push ebx                  ;    store file pointer

  mov eax, 3                ;    read...
  mov ebx, 0                ;    from stdin...
  mov ecx, buf              ;    into buffer...
  mov edx, 100              ;    of length 100
  int 80h

  mov edx, eax              ;    move returned length of stdin to edx
  cmp edx, 0
  je _close                 ;    check for 0 (EOF/Ctrl-D)

  pop ebx                   ;    grab file pointer from stack

  mov eax, 4                ;    write...
  mov ecx, buf              ;    contents of buffer into file
  int 80h

  mov ecx, 2                ;    infinite loop

  loop L1

_nofile:
  mov ecx, errorMsg
  mov edx, errorLen
  mov ebx, 2                ;   stderr
  mov eax, 4                ;   write
  int 80h

_close:
  pop ebx                   ;	  grab file pointer from stack
  mov eax, 6                ;   close file in ebx
  int 80h

_exit:
  mov eax, 1                ;   exit
  int 80h
