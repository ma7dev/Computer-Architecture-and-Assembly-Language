TITLE Composite Numbers(Project_04.asm)

; Author: Mazen Alotaibi
; Course / Project ID : 271 - 001 / 04      Due Date : 10 / 30 / 2016
; Description: This program displays composite numbers.
; **EC: Displaying composite numbers in aligned columns.

INCLUDE Irvine32.inc

UPPER					= 400					; upper limit when testing
LOWER					= 1						; lower limit when testing
NUM_PER_LINE			= 4						; numbers per line is 5
COL_OFFSET				= 6						; spacing between numbers

.data
numDisplay		DWORD	?						; displaying numbers
validate		DWORD	?						; is it valid or not
comNum			DWORD	?						; current position for the current composite number
factor			DWORD	?						; when testing with factor
num				DWORD	3						; is it a compotive or not

row				BYTE	8						; y position
col				BYTE	-1						; col number
colSet			BYTE	0						; col number times offsets for accurate spacing

intro_1			BYTE	"Composite Numbers", 0
intro_2			BYTE	"Programmer by Mazen Alotaibi", 0
extraCredit		BYTE	"**EC: Displaying composite numbers in aligned columns.", 0
rules			BYTE	"Enter the number of composite numbers you would like to see. I will accept orders for up to 400 composites.", 0
prompt_1		BYTE	"Enter the number of composites to display [1 .. 400]: ", 0
error_1			BYTE	"Out of range. Try again.", 0
hrShow			BYTE	"------------------------------", 0
farewell1		BYTE	"Results certified by Mazen Alotaibi.", 0
farewell_2		BYTE	"Goodbye.", 0

.code
main PROC
	call	intro											; display intodcution
	call	getUserData										; get users input
	call	showComposites									; display composite numbers
	call	farewell										; display farewell
	exit													; exit to operating system
main ENDP

; --------------------------------------------------
; Description: Display title, name, extraCredit and rules
; Inputs: none
; Outputs: none
; --------------------------------------------------
intro PROC
	mov		edx, OFFSET		intro_1						; display programs title
	call	WriteString
	call	CrLf
	mov		edx, OFFSET		intro_2						; display programmers name
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET		extraCredit					; display extraCredit
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET		rules						; display rules
	call	WriteString
	call	CrLf
	ret
intro ENDP

; --------------------------------------------------
; Description: Get numCom to be displayed from user
; Inputs: none
; Outputs: numDisplay
; --------------------------------------------------
getUserData PROC
enterNum :
	inc		row											; inc row to display
	inc		row											; to make room for invalid inputs
	mov		eax, 1										; sets validate to true
	mov		validate, eax
	mov		edx, OFFSET		prompt_1					; enter number prompt
	call	WriteString
	call	readInt
	mov		numDisplay, eax
	call	inputValid									; validates user input
	cmp		validate, 0									; if input invalid validate will set to 0
	JE		enterNum
	ret
getUserData ENDP

; --------------------------------------------------
; Description: Display composite numbers
; Inputs: comNum
; Outputs: none
; --------------------------------------------------

showComposites PROC
	mov		ecx, numDisplay								; set loop
	call	CrLf
	mov		edx, OFFSET hrShow
	call	WriteString
	call	CrLf
display :
	call	isCom										; check if composite or not
	call	setCol										; check if new line or new col
	mov		eax, comNum
	mov		dh, row
	mov		dl, colSet
	call	Gotoxy										; right position on screen, xy
	call	WriteDec
	call	CrLf
	loop	display
	call	CrLf
	ret
showComposites ENDP

; --------------------------------------------------
; Description: Check if in range or not
; Inputs: numDisplay
; Outputs: validate
; --------------------------------------------------
inputValid PROC
	cmp		numDisplay, UPPER						; compares to upper limit
	JA		notRange
	cmp		numDisplay, LOWER						; compares to lower limit
	JB		notRange
	JMP		inRange
notRange :											; error message when it is out of range
	mov		edx, OFFSET		error_1
	call	WriteString
	call	CrLf
	mov		eax, 0
	mov		validate, eax							; continue when it is in range
inRange :
	ret
inputValid ENDP

; --------------------------------------------------
; Description: Check if composite or not
; Inputs: numDisplay
; Outputs: validate
; --------------------------------------------------
isCom PROC
newNum :
	inc		num									; inc num to test it
	mov		eax, num
	shr		eax, 1								; divide num into half
	mov		factor, eax
testNum :										; divide num to check if composite or not
	mov		edx, 0
	mov		eax, num
	mov		ebx, factor
	div		ebx
	cmp		edx, 0								; if there is not reminder then it is a composite
	JE		found
nextFactor :									; testing next factor
	dec		factor
	cmp		factor, 1							; if factor is 1, then not a composite
	JE		newNum
	JMP		testnum
found :											; if compotive has been found, then move it
	mov		eax, num
	mov		comNum, eax
	ret
isCom ENDP

; --------------------------------------------------
; Description: Check if the number is composite
; Inputs: row, NUMBER_PER_LINE, col, colSet, and COL_OFFSET
; Outputs: col, colSet and row variables
; --------------------------------------------------
setCol PROC
	cmp		col, NUM_PER_LINE					; check if is a new line or a new col
	JNE		newCol
	inc		row									; start new line
	mov		al, 0
	mov		col, al
	mov		colSet, al
	jmp		done
newCol :										; start new col
	inc		col
	mov		al, col
	mov		bl, COL_OFFSET
	mul		bl
	mov		colSet, al
done :
	ret
setCol ENDP

; --------------------------------------------------
; Description : Displays Farewell Message
; Inputs: None
; Outputs: None
; --------------------------------------------------
farewell PROC
	mov		edx, OFFSET hrShow
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET		farewell1		; displays first farwell message with programmers name
	call	WriteString
	call	CrLf
	mov		edx, OFFSET		farewell_2		; displays goodbye
	call	WriteString
	call	CrLf
	ret
farewell ENDP

END main