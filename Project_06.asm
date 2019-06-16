TITLE: Designing Low Level Procedures and Implementing a Macro    (Project_06.asm)

; *********************************************************************
; Author: Mazen Alotaibi
; Course / Project ID : 271 - 001 / 06      Due Date : 12 / 04 / 2016
; Description: This program will ask for 10 unsigned decimal numbers, which they all should fit inside 32 bit register,
;			   to sum them up and get their average.
; *********************************************************************

INCLUDE Irvine32.inc

sizeArray = 10

disStr		MACRO	string
	push	edx				
	mov		edx, OFFSET string
	call	WriteString
	pop		edx				
ENDM

getStr		MACRO   var, string
	push	ecx
	push	edx
	disStr	string
	mov		edx, OFFSET var
	mov		ecx, (SIZEOF var)-1
	call	ReadString
	pop		edx
	pop		ecx
ENDM

.data
	intro_1			BYTE	"Written by:  Mazen Alotaibi (Designing low-level procedures)",0
	intro_2			BYTE	"Please provide 10 unsigned decimal integers.",0
	intro_3			BYTE	"Each number needs to be small enough to fit inside 32 bit register. ",0
	intro_4			BYTE	"After you have finished inputting the raw numbers I will display a list",0
	intro_5			BYTE	"of the integers, their sum, and their average value.",0
	prompt_1		BYTE	"Please enter an unsigned number: ",0
	error_1			BYTE	"ERROR: You did not enter an unsigned integer or your number was too big. Try again: ",0
	display_1		BYTE	"You entered the following numbers: ",0
	display_2		BYTE	"The sum of these numbers is: ",0
	display_3		BYTE	"The average is: ",0
	farewell		BYTE    "Thanks for playing! Mazen Alotaibi", 0
	comma			BYTE    ", ", 0
	counter			DWORD   0
	arrayCounter	DWORD	0
	userStrLength	DWORD	?
	sum				DWORD   ? 
	average			DWORD   ?
	userArray		DWORD   sizeArray DUP(? )
	userString		BYTE	33 DUP(? )
	tempString		BYTE	32 DUP(?)

.code
main PROC
	call	intro
	call	Crlf
getNum:
	push	counter
	push	OFFSET userArray
	push	userStrLength
	call	readVal
	inc		counter
	inc		arrayCounter
	mov		edx, sizeArray
	cmp		arrayCounter, edx
	je		done
	jmp		getNum
done:
	push	sizeArray
	push	OFFSET userArray
	call	displayArray
	push	sizeArray
	push	OFFSET userArray
	push	OFFSET sum
	call	computeSum
	call	Crlf
	disStr	display_2
	push	sum
	push	OFFSET tempString
	call	writeVal
	push	sizeArray
	push	sum
	push	OFFSET average
	call	computeAverage
	disStr	display_3
	push	average
	push	OFFSET tempString
	call	writeVal
	call	Crlf
	disStr	farewell
	call	Crlf
	exit					; to operating system
main ENDP

;*********************************************************************
;Procedure to introduce the program.
;receives: none
;returns: none
;preconditions: none
;registers changed: edx
;*********************************************************************
intro PROC					; Display introduction
	disStr	intro_1
	call	Crlf
	call	Crlf
	disStr	intro_2
	call	Crlf
	disStr	intro_3
	call	Crlf
	disStr	intro_4
	call	Crlf
	disStr	intro_5
	call	Crlf
	ret
intro ENDP

;*********************************************************************
;Procedure to getValue from user, perform validation and store value in a array
;receives: none
;returns: valid integer value 
;preconditions: none
;registers changed: edx, esi, ecx
;*********************************************************************
readVal PROC
	push	ebp
	mov		ebp, esp
	getStr	userString,prompt_1
verify:
	mov		[ebp+8], eax						; move the length of the userStr into variable userStrLength
	mov		ecx, eax							; move the length of userStr into ecx to serve as a counter 
	mov		esi, OFFSET userString  
nextDigit:
	lodsb
	cmp		al , 48
	jl		error
	cmp		al, 57
	jg		error
	loop	nextDigit
	jmp		verifySize
tryInputAgain:
	getStr  userString, error_1
	jmp		verify
error:
	jmp		tryInputAgain
verifySize:
	mov		edx, OFFSET userString
	mov		ecx, [ebp+8]
	call	ParseDecimal32						; convert to int and set carry flag
	jc		tryInputAgain						; if CF = 1 this means size is too big so tryInputAgain

	;fill the array with the appropriate validated value
	mov		ebx, [ebp+16]						; move counter into ebx
	mov		edi, [ebp+12]						; addr of userArray into edi
	imul	ebx, 4
	mov		[edi+ebx], eax
	pop		ebp
	ret		12
readVal ENDP

;*********************************************************************
;Procedure to display validated numbers from array 
;receives: address of array, arraySize, 
;returns: none
;preconditions: validated array
;registers changed: edx
;*********************************************************************
displayArray PROC
	push	ebp
	mov		ebp, esp						; setup stack frame
	mov		ecx, [ebp+12]					; move arraySize 
	mov		esi, [ebp+8]					; move  addrress of array into esi
	mov		ebx, 0
	call	Crlf
	disStr	display_1
	call	Crlf
again:
	mov		eax,[esi] 
	call	WriteDec
	mov		al, comma
	call	WriteChar
	add		esi, 4
	loop	again
	pop		ebp 
	ret		8
displayArray ENDP

;*********************************************************************
;Procedure to add numbers in array and calculate average
;receives: address of array, arraySize, 
;returns: none
;preconditions: validated array
;registers changed: edx
;*********************************************************************
computeSum PROC
	push	ebp
	mov		ebp, esp						; setup stack frame
	mov		ecx, [ebp+16]					; move arraySize 
	mov		esi, [ebp+12]					; move  addrress of array into esi
	mov		edi, [ebp+8]					; move address of sum to edi
accumulate:
	mov		eax,[esi] 
	add		ebx, eax
	add		esi, 4
	loop	accumulate
	mov		[edi], ebx						; assign the total to memory content of address of sum
	pop		ebp
	ret		12
computeSum ENDP

;*********************************************************************
;Procedure to convert integer to string 
;receives: integer, address of temp string
;returns: none
;preconditions: valid integer
;registers changed: edx
;*********************************************************************
writeVal PROC
	push	ebp
	mov		ebp, esp
	mov		eax, [ebp+12]					; move sum to convert to string to eax
	mov		esi, [ebp+8]					; move address of temp String to esi
	mov		ebx, 10
	push	0
Conversion:
	mov		edx, 0
	div		ebx
	add		edx, 48
	push	edx								; this is the newly converted remainder into ascii
	cmp		eax, 0							; Check to see if null is reached
	jne		Conversion
removeNum:									; Remove numbers from stack
	pop		[esi]
	mov		eax, [esi]
	inc		esi
	cmp		eax,0							; compare to see if all number has been removed
	jne		removeNum
	mov		edx, [ebp+8]					; Display the converted integer to string using macro
	disStr	OFFSET tempString
	call	CrLf
	pop		ebp
	ret		8
writeVal ENDP

;*********************************************************************
;Procedure to calculateAverage
;receives: sum, arraySize , address of average
;returns: average
;preconditions: validated array, sum
;registers changed: eax, edi
;*********************************************************************
computeAverage PROC
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+8]					; address of average into edi
	mov		eax, [ebp+12]					; move sum into eax
	mov		ebx, [ebp+16]					; move sizeArray into ebx
	cdq
	div		ebx
	mov		[edi],eax						; move quotient into average
	pop		ebp
	ret		12
computeAverage ENDP

END main
