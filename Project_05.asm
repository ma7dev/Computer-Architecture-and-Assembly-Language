TITLE Sorting Random Integers(Project_05.asm)

; Author: Mazen Alotaibi
; Course / Project ID : 271 - 001 / 05         Due Date : 11 / 13 / 2016
; Description: Generates random integers specified by user value. Then sorts random integers in descending order and displays median value. Error checking included. My rounding function rounds up 1 whole integer.

INCLUDE Irvine32.inc

MIN = 10
MAX = 200
LO = 100
HI = 999
MAXSIZE = 200

.data
intro_1		BYTE	"Sorting random integers                Programmed by Mazen Alotaibi", 0
intro_2     BYTE	"This program generates random integers in the range[100..999],", 0
intro_3		BYTE	"displays the original list, sorts the list and calculates ", 0
intro_4		BYTE	"the median value. Finally, it displays the sorted list in descending order", 0
prompt_1	BYTE	"How many numbers should be generated [10..200]: ", 0
goodbye_1	BYTE	"Results certified by Mazen Alotaibi. Goodbye ", 0
error_1	    BYTE	"Invalid input", 0
message		BYTE	"The unsorted list: ", 0
message_2	BYTE	"The sorted list:", 0
spaces		BYTE	" ", 0
goodBye		BYTE    "Thank you for playing sorting list, goodbye!", 0
medMessage  BYTE    "The rounded median is ", 0
request		DWORD	?					; no of random integers to be displayed, user inputted.
pointer		DWORD	?					; points to a value in array
median		DWORD	?
num			DWORD	?
countTen	DWORD    10
randomArray	DWORD	 MAXSIZE DUP(? )

.code
main PROC
	call	Randomize
	call	intro
	call	Crlf
	push	OFFSET request						; pass request by reference
	call	getData
	push	OFFSET randomArray					; pass randomArray by reference
	push    request								; pass request by value
	push	HI
	push	LO
	call	fillArray
	push	OFFSET message
	call	listMessage
	push	request								; pass by value
	push	OFFSET randomArray
	push    countTen
	call	displayArray
	push	OFFSET randomArray
	push	request								; pass request by value
	push	pointer								; pass by value
	call	sortList
	call	Crlf
	call	Crlf
	push	OFFSET message_2
	call	listSortedMessage
	push	request
	push	OFFSET randomArray
	push    countTen
	call	displayArray
	push	request
	push	OFFSET randomArray
	push	num
	push	median
	push	OFFSET medMessage
	call	computeMedian
	call	Crlf
	mov     edx, OFFSET goodbye
	call	WriteString
	call	Crlf
	exit									; to operating system
main ENDP

; --------------------------------------------------
; Procedure to introduce the program.
; receives: none
; returns: none
; preconditions: none
; registers changed : edx
; --------------------------------------------------
intro PROC
; Display introduction
	mov		edx, OFFSET intro_1
	call	WriteString
	call	Crlf
	call	Crlf
	mov		edx, OFFSET intro_2
	call	WriteString
	call	Crlf
	mov		edx, OFFSET intro_3
	call	WriteString
	call	Crlf
	mov		edx, OFFSET intro_4
	call	WriteString
	call	Crlf
	call	Crlf
	ret
intro ENDP

; --------------------------------------------------
; Procedure to get number of random integers to be displayed from user
; receives: request by reference
; returns: good input userNum
; preconditions:none
; registers changed : eax, edx, ebx
; --------------------------------------------------
getData PROC
	push	ebp; set up stack frame
	mov		ebp, esp
	mov		ebx, [ebp + 8]
; get the integer from user
top :
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	cmp	    eax, MAX
	jg		false_1
	cmp		eax, MIN
	jl		false_1
	mov		[ebx], eax
	pop		ebp
	call	Crlf
	ret		4
false_1:
	mov		edx, OFFSET error_1
	call	WriteString
	call	Crlf
	jmp		top
getData ENDP

; --------------------------------------------------
; Procedure to fill array with random integers based on user inputted value "request"
; receives:request, address of array
; returns: filled array with random integers
; preconditions: good input value(request)
; registers changed : ebx, eax, edi
; --------------------------------------------------
fillArray PROC
	push	ebp										; setup stack frame
	mov		ebp, esp
	mov		ecx, [ebp + 16]							; move request / count into ecx
	mov		edi, [ebp + 20]							; move @list into edi
; Setting up RandomRange
	mov		eax, [ebp + 12]
	sub		eax, [ebp + 8]
	inc		eax
whileLoop :
	call	RandomRange
	add		eax, [ebp + 8]
	mov     [edi], eax
	add		edi, 4
	loop	whileLoop
	pop		ebp
	ret		16
fillArray ENDP

; --------------------------------------------------
; Proceduere to display sorted and unsorted array based on user request
; receives: request, array, countTen
; returns: list with all values 10 per line
; preconditions: filled array, request
; registers changed; ecx, esi, edi,
; --------------------------------------------------
displayArray PROC
	push	ebp
	mov		ebp, esp									; setup stack frame
	mov		ecx, [ebp + 16]								; move request / count
	mov		esi, [ebp + 12]								; move  addrress of array into esi
	mov		edi, 0
again:
	mov eax, [esi]
	call	WriteDec
	inc		edi
	mov		al, spaces
	call	WriteChar
	add		esi, 4
	cmp		edi, [ebp + 8]							; this is countTen holds value 10
	je		nextLine
	loop	again
endAgain :
	pop		ebp
	ret		12
nextLine :
	call   Crlf
	mov    edi, 0
	cmp    edi, ecx
	je     quit
	loop   again
quit :
	pop		ebp
	ret		12
displayArray ENDP

; --------------------------------------------------
; Proceduere to sort list into descending order
; receives: request, array, pointer
; returns; sorted list in descending order
; preconditions: good user request, defined array
; registers changed; ecx, edi, eax
; --------------------------------------------------
sortList PROC
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp + 16]								; move address of array into esi
	mov		ecx, [ebp + 12]								; moving count / request into
	mov		[ebp + 8], edi								; move content of edi into pointer
	dec		ecx
start :
	push	ecx											; save the value of count / request
	mov		edi, [ebp + 8]								; point to the first value in list
sort :
	mov		eax, [edi]
	cmp		[edi + 4], eax								; check current and next value in array to see which is higher
	jl		next
	xchg	eax, [edi + 4]
	mov		[edi], eax
next :
	add		edi, 4
	loop	sort
	pop		ecx
	loop	start
finish :
	pop		ebp
	ret		12
SortList ENDP

; --------------------------------------------------
; Procedure to display unsorted message
; receives: offset string message
; returns: none
; preconditions: unsorted list
; registers changed : edx
; --------------------------------------------------
listMessage PROC
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp + 8]								; move addr of message into edx
	call	WriteString
	call	Crlf
	pop		ebp
	ret		4
listMessage ENDP

; --------------------------------------------------
; Procedure to display unsorted message
; receives: address of string
; returns: none
; preconditions: sorted
; registers changed : edx
; --------------------------------------------------
listSortedMessage PROC
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp + 8]							; move addr of message into edx
	call	WriteString
	call	Crlf
	pop		ebp
	ret		4
listSortedMessage ENDP

; --------------------------------------------------
; Procedure for display rounded median
; receives: request, list, num, median
; returns: rounded median
; preconditions: sorted / unsorted list
; registers changed : edx, ecx, esi, edx
; --------------------------------------------------
computeMedian PROC
	call	Crlf
	push	ebp
	mov		ebp, esp
	mov		eax, [ebp + 24]					; move request / count into eax
	mov		esi, [ebp + 20]					; move @list into esi
; check parity of count
	mov		ebx, 2
	cdq
	div		ebx
	cmp		edx, 0
	je		L4
	mov		ecx, 0
	mov		[ebp + 16], eax						; assigning quotient to num
L1 :
	mov		eax, [esi]
	cmp		[ebp + 16], ecx
	je		showMedian
continue :
	add		esi, 4
	inc		ecx
	jmp		L1
showMedian :
	call	Crlf
	mov		edx, [ebp + 8]
	call	WriteString
	mov		[ebp + 12], eax
	call	WriteDec
	call	Crlf
	pop		ebp
	ret		20
L4:
	mov		ecx, 0
	mov		[ebp + 16], eax						; assigning quotient to num
L2 :
	mov		eax, [esi]
	cmp		[ebp + 16], ecx
	je		showEvenMedian
forward :
	add		esi, 4
	inc		ecx
	jmp		L2
showEvenMedian :
	call	Crlf
	mov		edx, [ebp + 8]
	call	WriteString
	mov     eax, [esi - 4]
	mov     ebx, [esi]
	add	    eax, ebx
	mov		ebx, 2
	cdq
	div     ebx
	cmp     edx, 1						; if remainder is 1 round up to next whole integer
	je      addOne
	call	WriteDec
	call	Crlf
	pop		ebp
	ret		20
addOne:
	add		eax, 1
	call	WriteDec
	call	Crlf
	pop		ebp
	ret		20
computeMedian ENDP
END main
