section .data
	arrayB	db 10h, 20h, 30h, 40h
	len equ $-arrayB

section .text
global _start

_start:
	mov esi, 0
	mov al, len
	mov bl, 2
	div bl
	mov ecx, eax

L1:
	mov al, [arrayB+esi]
	inc esi
	xchg al, [arrayB+esi]
	dec esi
	mov [arrayB+esi], al
	add esi, 2
	loop L1
	
	mov eax, 1
	mov ebx, 0
	int 80h
