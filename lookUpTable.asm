section .data
table: db 'A'
    db 1
entrysize equ $-table
    db 'a'
    db 3
    db 'X'
    db 7
    db 'x'
    db 4
    db 'Z'
    db 10
entryNum equ ($-table)/entrysize
    db 100

section .text
global _start

_start:
	mov al, 'X'           ;table compare
	mov ebx, table        ;ebx has table address
	mov ecx, entryNum     ;ecx has entryNum address
L1: cmp al, [ebx]
	jne L2                ;if key and compare are equal, 
	mov al, [ebx+1]       ;store and return value in al 
	jmp L3
L2: add ebx, entrysize  ;else check next key value
	loop L1
	mov al, [ebx]
L3:
	mov ax, 1
	xor bx, bx
	int 80h
