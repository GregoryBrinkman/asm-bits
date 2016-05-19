section .data
	val1 dd 00020001h
	val2 dd 00040003h

section .text
global _start

_start:
	mov esi, val1
	mov ax, [esi]   ;ax holds last 2 bytes of val
	mov bx, [esi+2] ;bx holds first 2 bytes of val
	mov esi, val2
	mov cx, [esi]   ;cx holds last 2 bytes of val2
	mov dx, [esi+2] ;dx holds first 2 bytes of val2
	add ax, cx
	adc bx, dx
                  ;little endian: ax, bx
                  ;bx holds MSB and bigger value
	mov ax, 1
	mov bx, 0
	int 80h
