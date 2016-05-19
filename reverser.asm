section .data
arrayB	db 10h, 20h, 30h, 40h, 50h
len equ $-arrayB

section .text
global _start

_start:
mov esi, arrayB
mov al, len
test al, 1
jz even           ;even test for cx loop
inc al
even:
mov bl, 2
div bl            ;total elements=n/2
mov bl, len
dec bl            ;bl now holds total elements
mov ecx, eax

L1:               ;swap 
mov al, [esi] 
add esi, ebx
xchg al, [esi]
sub esi, ebx
mov [esi], al
dec ebx           ;2 elements have been exchanged
dec ebx           ;therefore, bl - 2
inc esi
loop L1


mov eax, 1
mov ebx, 0
int 80h

