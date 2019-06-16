TITLE Program Template(Project_2.asm)

; Author: Mazen Alotaibi
; Course / Project ID : CS271 - 001 / 02              Date : 10 / 09 / 2016
; Description:This program is a fibonacci number displayer, which displays all the fibonacci numbers of the number that the user enters
; **EC: DESCRIPTION: The program displays the numbers in aligned columns.

INCLUDE Irvine32.inc
MAX = 32
LIMIT_MAX = 46
LIMIT_MIN = 1
COUNTER_S = 5
.data

userNum		DWORD ? ; integer
userName	BYTE    33 DUP(0); string
counter_z	DWORD ? ; integer

intro_1     BYTE    "Fibonacci Numbers ", 0
intro_2     BYTE    "Programmed by Mazen Alotaibi", 0

prompt_1    BYTE    "What is your name? ", 0
reply_1		BYTE	"Hello, ", 0

intro_3		BYTE    "Enter the number of Fibonacci terms to be displayed.", 0
intro_4		BYTE    "Give the number as an integer in the range [1 .. 46].", 0
prompt_2	BYTE	"How many Fibonacci terms do you want? " , 0
error       BYTE    "Out of range. Enter a number in [1 .. 46]", 0

space		BYTE	" ", 0

prev		DWORD	1;
next		DWORD	1;
sum			DWORD	0;
counter		DWORD	0;

done		BYTE    "Results certified by Mazen Alotaibi.", 0
goodbye		BYTE	"Goodbye, ", 0

extraCredit BYTE    "**EC: Display the numbers in aligned columns.", 0
D1			BYTE	"+--------------------------------------------------+", 0
D2			BYTE	"| ", 0
D3			BYTE	" | ", 0

.code

main PROC
; introduction
	mov     edx, OFFSET intro_1
	call    WriteString
	call    Crlf
	mov     edx, OFFSET intro_2
	call    WriteString
	call    Crlf
	mov     edx, OFFSET extraCredit
	call    WriteString
	call    CrLf

; getUserData
	call    CrLf
	mov     edx, OFFSET prompt_1
	call    WriteString
	mov     edx, OFFSET userName
	mov     ecx, MAX
	call    ReadString
	call    CrLf
	mov     edx, OFFSET reply_1
	call    WriteString
	mov     edx, OFFSET userName
	call    WriteString
	call    CrLf

; userInstructions
	mov     edx, OFFSET intro_3
	call    WriteString
	call    Crlf
	mov     edx, OFFSET intro_4
	call    WriteString
	call    CrLf

L1 :
	mov     edx, OFFSET prompt_2
	call    WriteString
	call    ReadInt
	call    CrLf
	mov     userNum, eax

; Comparison instruction
	mov     eax, userNum
	cmp     eax, LIMIT_MIN
	jl      L2
	cmp     eax, LIMIT_MAX
	jg		L2
	jmp     L3

L2 :
; If outside the range
	mov     edx, OFFSET error
	call    WriteString
	call    Crlf
	jmp		L1

L3 :
	; Counted loop
	; DisplayFibs
	mov     ecx, userNum
	mov     eax, prev
	mov     counter_z, 0
	mov     edx, OFFSET D1
	call    WriteString
	call    Crlf
	mov     edx, OFFSET D2
	call    WriteString
L4 :
	cmp     counter_z, COUNTER_S
	jne     L5
	mov     counter_z, 0
	call    Crlf
	mov     edx, OFFSET D1
	call    WriteString
	call    Crlf
	mov     edx, OFFSET D2
	call    WriteString
L5 :
	call    WriteDec
	mov     AL, space
	call    WriteChar
	mov     ebx, next
	add     ebx, prev
	mov     sum, ebx
	mov     ebx, next
	mov     prev, ebx
	mov     eax, sum
	mov     next, eax
	mov     eax, prev
	inc     counter_z
	mov     edx, OFFSET D3
	call    WriteString
	loop   L4

; farewell
	call    Crlf
	mov     edx, OFFSET D1
	call    WriteString
	call    CrLf
	mov     edx, OFFSET done
	call    WriteString
	call    CrLf
	mov     edx, OFFSET goodbye
	call    WriteString
	mov     edx, OFFSET userName
	call    WriteString
	call    CrLf
	exit
	main ENDP

END main