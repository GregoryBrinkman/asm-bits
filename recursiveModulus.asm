section .data
	val dd 'a'
	divisor dd 3h
	
section .text
global _start

_start:
	mov ax, [divisor]
	push ax
	mov ax, [val]
	push ax
	call modulus      ;return value in ax
	mov ax, 1
	xor bx, bx
	int 80h

modulus:
	push ebp
	mov ebp, esp
	mov ax, [ebp+8]   ;ax has val
	mov bx, [ebp+10]
	cmp ax, bx        ;ebp+10 is divisor
	jl out
	sub ax, bx        ;val - divisor until val < divisor
	push bx
	push ax
	call modulus      ;calls until val mod divisor is reached
out:pop ebp	
	ret 4
