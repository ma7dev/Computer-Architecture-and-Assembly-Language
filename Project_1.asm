TITLE Program Template     (Project_1.asm)

; Author: Mazen Alotaibi
; Course / Project ID:   CS271-001/01              Date: 10/02/2016
; Description: This program is a calculator that can add, subtract, multiply and divide two numbers.
; **EC: DESCRIPTION: The program won't accept any number that the user input for the second number if the second number is larger than the first number.
; **EC: DESCRIPTION: The program will ask the user to repeat if yes (1) then the program will continue running, if not then exit the program.

INCLUDE Irvine32.inc


.data

userNum1    DWORD   ?  ;integer to be entered by user
userNum2    DWORD   ?  ;integer to be entered by user
userASKED	DWORD	?	;integer to run again
product     DWORD   ?
sum         DWORD   ?
difference  DWORD   ?
quotient    DWORD   ?
remainder   DWORD   ?
intro_1     BYTE    "Elementary Arithmetic by Mazen Alotaibi ",0
intro_2     BYTE    "Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder.", 0
prompt_1    BYTE    "First number:  ", 0
prompt_2    BYTE    "Second number:  ",0
addition    BYTE    " + ",0
subtract    BYTE    " - ",0
multiply    BYTE    " X ",0
divide      BYTE    " / ",0
equal       BYTE    " = ",0
remain      BYTE    " remainder ",0
error       BYTE    "The second number must be less than the first!",0
again		BYTE    "Press (1) to continue, else press any other key. ", 0
goodbye		BYTE	"Impressed? Bye!", 0
extraCredit BYTE    "**EC: Program verifies second number to be less than the first.",0
extraCredit2 BYTE    "**EC: Program verifies to do the loop.",0

.code

main PROC
;Introduce User
    mov     edx, OFFSET intro_1
    call    WriteString
    call    Crlf
    mov     edx, OFFSET extraCredit
    call    WriteString
    call    CrLf
	mov     edx, OFFSET extraCredit2
    call    WriteString
    call    CrLf
    call    CrLf
    mov     edx, OFFSET intro_2
    call    WriteString
    call    CrLf

startLoop:

;Get User Inputs
    call    CrLf
    mov     edx,OFFSET prompt_1
    call    WriteString
    call    ReadInt
    mov     userNum1, eax
    mov     edx, OFFSET prompt_2
    call    WriteString
    call    ReadInt
    mov     userNum2, eax
    call    Crlf
    
;Comparison instruction
    mov     eax, userNum1
    cmp     eax, userNum2
    JL      L1
    jmp     L2

L1:

;If 2nd Num is larger than the 1st Num
    mov     edx, OFFSET error
    call    WriteString
    call    Crlf
    mov     edx, OFFSET goodBye
    call    WriteString 
	call    Crlf
    exit    

L2:

;Calculation

;Addition
    mov     eax, userNum1
    ADD     eax, userNum2
    mov     sum, eax
    
;Subtraction
    mov    eax, userNum1
    SUB    eax, userNum2
    mov    difference, eax

;Multiplication
    mov     eax, userNum1
    mov     ebx, userNum2
    mul     ebx
    mov     product, eax

;Division
    mov     eax, userNum2
    cdq
    mov     eax, userNum1
    mov     ebx, userNum2
    div     ebx
    mov     quotient, eax
    mov     remainder, edx
    
;Results

;Addition Result
    mov     eax,userNum1
    call    WriteDec
    mov     edx, OFFSET addition
    call    WriteString
    mov     eax, userNum2
    call    WriteDec
    mov     edx, OFFSET equal
    call    WriteString
    mov     eax,sum
    call    WriteDec
    call    Crlf
    
;Subtraction Result
    mov     eax, userNum1
    call    WriteDec
    mov     edx, OFFSET subtract
    call    WriteString
    mov     eax,userNum2
    call    WriteDec
    mov     edx, OFFSET equal
    call    WriteString
    mov     eax, difference
    call    WriteDec
    call    Crlf

;Multiplication Result
    mov     eax, userNum1
    call    WriteDec
    mov     edx, OFFSET multiply
    call    WriteString
    mov     eax, userNum2
    call    WriteDec
    mov     edx, OFFSET equal
    call    WriteString
    mov     eax, product
    call    WriteDec
    call    Crlf

;Division Result
    mov     eax, userNum1
    call    WriteDec
    mov     edx, OFFSET divide
    call    WriteString
    mov     eax, userNum2
    call    WriteDec
    mov     edx, OFFSET equal
    call    WriteString
    mov     eax, quotient
    call    WriteDec
    mov     edx, OFFSET remain
    call    WriteString
    mov     eax, remainder
    call    WriteDec
    
;Ask to Play Again
    call    Crlf
    mov     edx, OFFSET again
    call    WriteString
	call    ReadInt
    mov     userNum1, eax
	cmp		userNum1, 1
	je		startLoop

;Say Goodbye
	call    Crlf
    mov     edx, OFFSET goodbye
    call    WriteString
	call    Crlf
    exit

main ENDP
END main