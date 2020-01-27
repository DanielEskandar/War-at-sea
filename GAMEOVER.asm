PRINTMESGMAINSCREEN			MACRO			MESSAGE,LEN,ROW,COLUMN
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
			
			PUBLIC 	GAMEOVERP
			EXTRN	WIN:BYTE
			.286
			.Model Small
            .Stack 64 
			
DTSEG1		SEGMENT			PARA 	'DATA'
VICBLUFILE	DB				'VICBLU.bin',0
VICREDFILE	DB				'VICRED.bin',0
VICFILEH	DW				?
VICATTR		DB				56960 dup(0)
WINST		DB				0
DTSEG1		ENDS
		
			.code
GAMEOVERP		PROC	FAR
					MOV		DL,WIN
					PUSH	DX
					
					ASSUME 	DS:DTSEG1
					MOV 	AX,DTSEG1
					MOV		DS,AX
					
					POP		DX
					MOV		WINST,DL
					CMP		WINST,1
					JE		SHIP1WON
					JNE		SHIP2WON
					
SHIP1WON:			MOV		AH,3Dh
					MOV		AL,0
					MOV		DX, OFFSET VICBLUFILE
					INT		21H
					
					JMP		SKIPSHIP2WON
					
SHIP2WON:			MOV		AH,3Dh
					MOV		AL,0
					MOV		DX, OFFSET VICREDFILE
					INT		21H
					
SKIPSHIP2WON:		MOV		DS:[VICFILEH],AX
					MOV		AH,3Fh
					MOV		BX,DS:[VICFILEH]
					MOV		CX,56960
					MOV 	DX,OFFSET VICATTR
					INT		21H
			
					MOV			SI,0
					MOV			DI,0
					MOV			DX,125
GAMEOVER3OUTLOOP:	MOV 		CX,160
					MOV			AH,0CH
					MOV 		BH,0
GAMEOVER3INLOOP:	MOV 		AL,VICATTR[SI]
					INT 		10H
					INC			CX
					INC			SI
					CMP			CX,479
					JBE			GAMEOVER3INLOOP
					INC			DX
					CMP			DX,302
					JBE			GAMEOVER3OUTLOOP
			
					RET
GAMEOVERP			ENDP
END 		