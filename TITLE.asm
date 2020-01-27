PRINTMESGMAINSCREEN		MACRO			MESSAGE,LEN,ROW,COLUMN
			MOV				BP,OFFSET MESSAGE	;Message to be printed in extra segment	
			MOV				AL,0				;Write mode 1
			MOV				AH,13H				;Write string	
			MOV				CX,LEN				;Number of characters in the string
			MOV				BL,0FH				;Attribute
			MOV				BH,0				;Page number	
			MOV 			DH,ROW
			MOV				DL,COLUMN
			INT				10H
			ENDM		
			
			PUBLIC TITLEP
			.286
			.Model Small
            .Stack 64 
			
DTSEG		SEGMENT			PARA 	'DATA'
TITLEFILE	DB				'TITLE.bin',0
TITLEFILEH	DW				?
TITLEATTR	DB				64000 dup(0)
DTSEG		ENDS
		
			.code
TITLEP		PROC	FAR
TOP:		ASSUME 	DS:DTSEG
			MOV 	AX,DTSEG
			MOV		DS,AX
			
			MOV		AH,00
			MOV		AL,13H
			INT 	10H
			
			MOV		AH,3Dh
			MOV		AL,0
			MOV		DX, OFFSET TITLEFILE
			INT		21H
			
			MOV		DS:[TITLEFILEH],AX
			MOV		AH,3Fh
			MOV		BX,DS:[TITLEFILEH]
			MOV		CX,64000
			MOV 	DX,OFFSET TITLEATTR
			INT		21H
			
			MOV		AX, 0A000h
			MOV		ES,	AX
			MOV		DI, 0
			MOV		CX, 64000
LOOP1:		MOV		AL,DS:TITLEATTR[DI]
			MOV		ES:[DI], AL
			INC		DI
			LOOP	LOOP1
			
			RET
TITLEP		ENDP
END 		