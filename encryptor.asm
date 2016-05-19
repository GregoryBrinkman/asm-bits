section .data
	string dd "This is a null-terminated string to be encrypted", 0
	encryptor dd "ABXmv#7"
	
section .text
global _start

_start:
	mov eax, string
	push eax          ;push address of string 
	mov eax, encryptor
	push eax          ;push address of encryption
	call crypt
	mov eax, 1
	xor ebx, ebx
	int 80h

crypt:
	push ebp
	mov ebp, esp

	mov eax, [ebp+8]  ;encryptor
	mov ebx, [ebp+12] ;string
L1:                 ;loop until NULL is reached
	mov esi, eax
	mov cl, [esi]
	cmp cl, '7'       ;encryption string is at its end
	jne next
	mov eax, [ebp+8]  ;restart encryption string
	dec eax
next:
	mov esi, ebx
	mov dl, [esi]
	cmp dl, 0         ;break out if null
	je out
	xor cl, dl        ;xor byte to encrypt it
	mov [esi], cl     ;place encrypted byte back in string

	inc eax
	inc ebx           ;increment all strings
	inc ecx           ;ensure loop will occur
	loop L1
out:
  pop ebp	
	ret 8
