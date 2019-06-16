TITLE Integer Accumulator(Project_03.asm)

; Author: Mazen Alotaibi
; Course / Project ID : 271 - 001 / 03      Due Date : 10 / 23 / 2016
; Description: This program is Integer Accumulator which can calculate negative numbers and take the rounded number.
; **EC: I have lined each input that the user entered.

INCLUDE Irvine32.inc

LOW_LIMIT = -100	;lower limit 
UP_LIMIT = 0

.data

userName    BYTE    33 DUP(0)	; string to be entered by user
intro_1     BYTE    "Welcome to Integer Accumulator programmed by Mazen Alotaibi", 0
prompt_1    BYTE    "What's your name?  ", 0
intro_2     BYTE    "Hello, ", 0
intro_3     BYTE    "Please enter numbers in [-100,-1].", 0
intro_4     BYTE    "Enter a non-negative number when you are finished to see results.", 0
prompt_2    BYTE    "Enter number: ", 0;
goodbye_1   BYTE    "Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ", 0
thing_1		BYTE	"( ", 0
thing_2		BYTE	" )", 0
userNum     DWORD    0
countNum    DWORD    0
sum         DWORD    0
quotient    DWORD    0
special_1   BYTE    "You did not enter any negative numbers ", 0
message_1   BYTE    "You entered ", 0
message_2   BYTE    " valid numbers", 0
message_3   BYTE    "Number out of range", 0
message_4   BYTE    "The sum of your valid numbers is ", 0
message_5   BYTE    "The rounded average is ", 0
ex_credit   BYTE    "**EC:  I have lined each input that the user entered.", 0

.code
main PROC

; Into
	mov     edx, OFFSET intro_1
	call    WriteString
	call    Crlf
	mov     edx, OFFSET ex_credit
	call    WriteString
	call    Crlf
	call    Crlf
	mov     edx, OFFSET prompt_1
	call    WriteString
	mov     edx, OFFSET userName
	mov     ecx, 32
	call    ReadString
	mov     edx, OFFSET intro_2
	call    WriteString
	mov     edx, OFFSET userName
	call    WriteString
	call    Crlf
	call    Crlf
	mov     edx, OFFSET intro_3
	call    WriteString
	call    Crlf
	mov     edx, OFFSET intro_4
	call    WriteString

; Get userNum
	call    Crlf
	mov     edx, OFFSET prompt_2
	call    WriteString
	call    ReadInt
	mov     userNum, eax
	cmp     eax, UP_LIMIT
	jge     L1
	cmp     eax, LOW_LIMIT
	jl      L2
	inc     countNum
	jmp     L3

L1 :
	mov edx, OFFSET special_1
	call    WriteString
	call    Crlf
	jmp     Q2

L2 :
	mov  edx, OFFSET message_3
	call    WriteString
	call    Crlf
	jmp     L4

L3 :
	mov     eax, userNum
	mov     ebx, sum
	add     eax, ebx
	mov     sum, eax

; Accumulate sum
L4 :
	mov     eax, userNum
	cmp     eax, UP_LIMIT
	jge     Q1
	mov		edx, OFFSET thing_1
	call    WriteString
	mov     eax, countNum
	call    WriteDec
	mov		edx, OFFSET thing_2
	call    WriteString
	call    Crlf
	mov     edx, OFFSET prompt_2
	call    WriteString
	call    ReadInt
	mov     userNum, eax
	inc     countNum
	cmp     userNum, LOW_LIMIT
	jl      F1
	mov     ebx, UP_LIMIT
	cmp     userNum, ebx
	jge     F1
	mov     eax, userNum
	mov     ebx, sum
	add     eax, ebx
	mov     sum, eax
	jmp     L4

F1 :
	mov    ebx, UP_LIMIT
	cmp    userNum, ebx
	jl     F2
	dec    countNum
	mov    edx, OFFSET message_1
	call   WriteString
	mov    eax, countNum
	call   WriteDec
	mov    edx, OFFSET message_2
	call   WriteString
	jmp    L4

F2 :
	dec    countNum
	mov    edx, OFFSET message_3
	call   WriteString
	call   Crlf
	jmp    L4

; Display Result
Q1 :
	mov     eax, sum
	cmp     eax, UP_LIMIT
	jg      Q2
	mov     edx, OFFSET message_4
	call    Crlf
	call    WriteString
	call    WriteInt
	call    Crlf

; Rounded Average
	mov     edx, OFFSET message_5
	call    WriteString
	mov     eax, 0
	mov     eax, sum
	cdq
	mov     ebx, countNum
	idiv    ebx
	mov     quotient, eax
	call    WriteInt
	call    CrLf

; Farewell
Q2 :
	mov     edx, OFFSET goodbye_1
	call    WriteString
	mov     edx, OFFSET userName
	call    WriteString
	call    CrLf

exit
main ENDP
END main