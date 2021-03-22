	[BITS 16]
	[ORG 0x7c00]
	CYLS EQU 10	
	
	JMP	entry

entry:
	MOV	AX, 0
	MOV	SS, AX
	MOV	SP, 0x7c00
	MOV	DS, AX
	MOV	ES, AX



read_silinder_from_USB:
	MOV	AX, 0x0820
	MOV	ES, AX
	MOV	CH, 0
	MOV	DH, 0
	MOV	CL, 2

read_loop:
	MOV	AH, 0x02
	MOV	AL, 1
	MOV	BX, 0
	MOV	DL, 0x80
	INT	0x13
	JC	error_process
	JMP	read_next_silinder

read_next_silinder:
	MOV	AX, ES
	ADD	AX, 0x0020
	MOV	ES, AX
	ADD	CL, 1
	CMP	CL, 16
	JBE	read_loop
	
	MOV	CL, 1
	ADD	DH, 1
	CMP	DH, 2
	JB	read_loop


	MOV	DH, 0
	ADD	CH, 1
	CMP	CH, CYLS
	JB	read_loop
	JMP	error_process
	;JMP	0x8200

putloop:
	MOV	AL, [SI]
	ADD	SI, 1
	CMP	AL, 0
	JE	0x8200
	MOV	AH, 0x0e
	MOV	BX, 15
	INT	0x10
	JMP	putloop
fin:
	HLT
	JMP	fin

error_process:
	MOV	SI,error_msg
	JMP	putloop


error_msg:
	DB	0x0a, 0x0a
	DB	"ERROR"
	DB	0x0a
	DB	0

	RESB	510-($-$$)
	DB	0x55, 0xaa

