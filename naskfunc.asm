	[BITS 32]
	
	GLOBAL io_hlt
	GLOBAL write_mem8

[SECTION .text]
io_hlt:
	HLT
	RET

write_mem8:
	MOV	ECX, [EBP+4]
	MOV	AL, [ESP+8]
	MOV	[ECX], AL
	RET	
