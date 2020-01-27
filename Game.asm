;GLOBAL MACROS
;-------------------------------------------------------------------------------------------------------------------------	
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
;-------------------------------------------------------------------------------------------------------------------------	

				EXTRN 			TITLEP:FAR
				EXTRN			GAMEOVERP:FAR
				PUBLIC			WIN
				.286
				.MODEL HUGE
				.STACK 64
				.DATA
MYKBUF      	DB 				128 DUP(0)			;Keyboard keystate table
RECKBUF			DB				6 DUP(0)			;RECBUFF
SENDKBUFF		DB				6 DUP(0)
SENDBYTE		DB				0
RECBYTE			DB				0
MYST			DB				0
OTHERST			DB				0
IRQ1OFF			DW				?					;Interrupt Offset
IRQ1SEG			DW				?					;Interrupt Segment
WIN				DB				0					;State of the winner (0: BLUE 1: RED)
LEVEL			DB				1					;CURRENT LVL
LEVELSTF		DB				0					;Level state flag (0:l1 1:l2)
MASTERCLOCK		DW				0					;Mastergamecounter
MASTERSERIAL	DB				0
; RST				DB				0					;Row state	
; CST				DB				0					;Column stat
;String Data
MAINMSG1		DB				'PRESS F1 TO START'
MAINMSG2		DB				'PRESS F2 TO CHAT'
MAINMSG3		DB				'PRESS ESC TO END'
ENTERNAME1		DB				'PLEASE ENTER USERNAME 1'
ENTERNAME2		DB				'PLEASE ENTER USERNAME 2'
ENTERMSG		DB				'PRESS ENTER TO CONTINUE'
GAMEOVERMSG		DB				'GAME OVEER 1'
GAMEOVERMSG1	DB				'GAME OVEER 2'
;Graphics Modules
MINEH			EQU				19
MINEW			EQU				19
;Mine Module
MINEFILE		DB				'MINE.bin',0
MINEFILEH		DW				?
MINEATTR		DB				MINEH*MINEW dup(0)
;Ship Modules
SHIPH			EQU				60
SHIPW			EQU				27
;Ship 1 Module
SHIP1FILE		DB				'SHIP1.bin',0
SHIP1FILEH		DW				?
SHIP1ATTR		DB				SHIPH*SHIPW dup(0)
;Ship 2 Module
SHIP2FILE		DB				'SHIP2.bin',0
SHIP2FILEH		DW				?
SHIP2ATTR		DB				SHIPH*SHIPW dup(0)
;Barrier Modules
BARRH			EQU				64
BARRW			EQU				20
;barrier model 1 module
BARR1FILE		DB				'URBAR.bin',0
BARR1FILEH		DW				?
BARR1ATTR		DB				BARRH*BARRW dup(0)
;barrier model 2 module
BARR1BFILE		DB				'URBARBR.bin',0
BARR1BFILEH		DW				?
BARR1BATTR		DB				BARRH*BARRW dup(0)
;barrier model 1 module
BARR2FILE		DB				'AMBAR.bin',0
BARR2FILEH		DW				?
BARR2ATTR		DB				BARRH*BARRW dup(0)
;barrier model 2 module
BARR2BFILE		DB				'AMBARBR.bin',0
BARR2BFILEH		DW				?
BARR2BATTR		DB				BARRH*BARRW dup(0)

CURRBARRAT		DB				BARRH*BARRW dup(0)
	
NAMEIN1			DB				15,?,15 DUP('$')	
NAMEIN2			DB				15,?,15 DUP('$')
SHIP1ROW		DW				177
SHIP1ROWH		DW				?
SHIP1ROWF		DW				?	
SHIP1COL		DW				46
SHIP1COLF		DW				72
SHIP1COL1		DW				90
SHIP1COLF1		DW				116
SHIP1COLDR		DW				46
SHIP1COLDRF		DW				72
SHIP1COLST		DW				0

SHIP2COL		DW				568
SHIP2COLF		DW				594
SHIP2COL1		DW				523
SHIP2COLF1		DW				549
SHIP2COLDR		DW				568
SHIP2COLDRF		DW				594
SHIP2COLST		DW				0

SHIP2ROW		DW				177
SHIP2ROWH		DW				?
SHIP2ROWF		DW				?	
;definition of barriers (1:state(0:moving 1:hit) 2:coordinate 3:direction(0:up 1:down) 4:speed 5:timeinactive)
BARRIERST		DW				0,0,0,0,0,0									
BARRIERCOL		DW				203,248,293,338,383,428
BARRIERENDC		DW				222,267,312,357,402,447
BARRIERROW		DW				100,200,300,150,250,50
BARRIERENDR		DW				163,263,363,213,313,113	
BARRIERDI		DW				0,1,0,1,0,1
BARRIERSP		DW				1,1,1,1,1,1
BARRIERTI		DW				0,0,0,0,0,0
BARRIERH		DW				3,3,3,3,3,3
;BULLETS IN DATA SEGMENT
BULLCOUNTS1		DB				20
BULLCOUNTS2		DB				20
BULLS1TIMER		DB				5
BULLS2TIMER		DB				5
MAXBULLETS 		EQU				100
BULLETROW		DW				100 DUP(0)
BULLETCOL		DW				100 DUP(0)
BULLETST		DW				100 DUP(0)
BULLETFREE		DW				100 DUP(0)
BULLETDAMAGE	DW				100	DUP(1)
;Mines
MINEFREE		DW				10 DUP(0)
MINECOL			DW				10 DUP(0)
MINEROW			DW				10 DUP(0)
MINESTCOL		DW				10 DUP(0)
MINESTSHR		DW				10 DUP(0)


GUNCOLS1		DW				?
GUNCOLS1F		DW				?

GUNCOLS2		DW				?
GUNCOLS2F		DW				?

;SCORES
SHIP1SCORE		DW				5
SHIP2SCORE		DW				5
SHIP1ROUND		DB				30H
				DB				'-'
SHIP2ROUND		DB				30H
ANCHOR			DB	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
				DB	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
				DB	00,00,00,00,00,00,00,00,00,00,00,15,15,00,00,00,00,00,00,00,00,00,00,00
				DB	00,00,00,00,00,00,00,00,00,00,00,15,15,00,00,00,00,00,00,00,00,00,00,00
				DB	00,00,00,00,00,00,00,00,00,00,00,15,15,00,00,00,00,00,00,00,00,00,00,00
				DB	00,00,00,00,00,00,15,00,00,00,00,15,15,00,00,00,00,15,00,00,00,00,00,00
				DB	00,00,00,00,00,00,15,15,15,15,15,15,15,15,15,15,15,15,00,00,00,00,00,00
				DB	00,00,00,00,00,00,15,00,00,00,00,15,15,00,00,00,00,15,00,00,00,00,00,00
				DB	00,00,00,00,00,00,00,00,00,00,00,15,15,00,00,00,00,00,00,00,00,00,00,00
				DB	00,00,00,00,00,00,00,00,00,00,00,15,15,00,00,00,00,00,00,00,00,00,00,00
				DB	00,00,15,15,15,15,00,00,00,00,00,15,15,00,00,00,00,00,15,15,15,15,00,00
				DB	00,00,15,15,15,00,00,00,00,00,00,15,15,00,00,00,00,00,00,15,15,15,00,00
				DB	00,00,15,15,15,15,00,00,00,00,00,15,15,00,00,00,00,00,15,15,15,15,00,00
				DB	00,00,15,00,15,15,00,00,00,00,00,15,15,00,00,00,00,00,15,15,00,15,00,00
				DB	00,00,00,00,15,15,15,00,00,00,00,15,15,00,00,00,00,15,15,15,00,00,00,00
				DB	00,00,00,00,15,15,15,15,00,00,00,15,15,00,00,00,15,15,15,15,00,00,00,00
				DB	00,00,00,00,00,15,15,15,15,00,00,15,15,00,00,15,15,15,15,15,00,00,00,00
				DB	00,00,00,00,00,00,15,15,15,15,15,15,15,15,15,15,15,15,15,00,00,00,00,00
				DB	00,00,00,00,00,00,00,15,15,15,15,15,15,15,15,15,15,15,00,00,00,00,00,00
				DB	00,00,00,00,00,00,00,00,15,15,15,15,15,15,15,15,15,00,00,00,00,00,00,00
				DB	00,00,00,00,00,00,00,00,00,15,15,15,15,15,15,00,00,00,00,00,00,00,00,00
				DB	00,00,00,00,00,00,00,00,00,00,00,15,15,00,00,00,00,00,00,00,00,00,00,00
				DB	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
				DB	00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
			
ANCHORSTART		DW	?
ANCHOREND		DW	?

;CLOSE
CLOSE			DB	0


;CHATMODULE DATA SEGMENT
INGAMECHATMSG		DB				'---------------------------------IN GAME CHAT---------------------------------'
INCHATFLAG			DB				0
INCHATLOOPFLAG		DB				0
EXCHANGESCREENMSG	DB				'Press Enter to connect'
SUCCESSCONNECTMSG	DB				'Connection Successfull'
CHATINVSENTMSG		DB				'You sent a chat invitation'
CHATINVRECMSG		DB				'You received a chat invitation'

GAMEINVSENTMSG		DB				'You sent a game invitation'
GAMEINVRECMSG		DB				'You received a game invitation'

CONNECTFAILMSG		DB				'Connection failed. Please try again'
ESTABLISHCONNECT	DB				'Establishing connection'
ENTERTOCONNECT		DB				'Press enter to begin connection'			
	
CHATINVSTATES		DB				0
CHATINVSTATER		DB				0
GAMEINVSTATES		DB				0
GAMEINVSTATER		DB				0
INGAMEINVSTATES		DB				0
INGAMEINVSTATER		DB				0		
CURSORSX			DB				2
CURSORSY			DB				?
CURSORRX			DB				2
CURSORRY			DB				?				
RECEIVERNAME		DB				15 DUP('$')
RECNAMECOUNT		DB				0
SENDERNAME			DB				15,?,15 DUP('$')
SENDERNAMECOUNT		DB				0
SENDNAMEST			DB				0
RECNAMEST			DB				0
BOTTOMMSG1			DB				'- To end chatting with ','$'
BOTTOMMSG2			DB				' press ESC'	,'$'
CLENGTH				DW				0
CHARBUFFER			DB				50 DUP(0)
BUFFERREC			DB				51 DUP(0)
CLENGTHR			DW				0
CLEAR				DB				'                                                                              ' ; EMPTY LINE


;INDICATORS
SENDCONFLOOP		DB				'SENDCONFLOOP'
RECEIVECONFLOOP		DB				'RECEIVECONFLOOP'
SENDSIGNAL			DB				'SENDSIGNAL'
RECEIVESIGNAL		DB				'RECEIVESIGNAL'

;-------------------------------------------------------------------------------------------------------------------------		
			.CODE	
MAIN		PROC 					FAR
			CALL					INITSC
			CALL					TITLEP						;Main Title Proc
			CALL					GETKEY						;Get Key to continue
			MOV						AX,@DATA					;Init Data Segment
			MOV						DS,AX
			MOV						ES,AX						;Init Extra Segment
			CALL					READGUIATTRIBUTES			;Copy GUI to DS
			CALL					GETNAME
			CALL					MAINSCREEN
			RET
MAIN		ENDP

;-------------------------------------------------------------------------------------------------------------------------
MAINSCREEN				PROC					NEAR
						CALL					SETVIDEOMODEMAINSCREEN		;Set video to 12H VGA
						CALL					DRAWLINEMAINSCREEN			
						PRINTMESGMAINSCREEN		MAINMSG1,17,14,32
						PRINTMESGMAINSCREEN		MAINMSG2,16,15,32
						PRINTMESGMAINSCREEN		MAINMSG3,17,16,32
						CALL					INITSC
KEYL:					CALL					GETKEYWITHOUTWAIT
						JZ						SKIPGETKEY
						CALL                    GETKEY
						CMP                     BH,1						;compare with esc scan code
						JE						ENDG						;if equal return control to operating system
						CMP						BH,3CH						;Scan code of F2
						JNE						CHECKONF1
						CALL					CHATINVSENT
CHECKONF1:				CMP						BH,3BH						;Scan code of F1
						JNE						CONTINUEKEYL						
						CALL					GAMEINVSENT
SKIPGETKEY:				MOV						DX,3FDH
						IN						AL,DX
						XOR						AH,AH
						AND						AL,1
						JZ						CONTINUEKEYL
						MOV						DX,3F8H
						IN						AL,DX
						CMP						AL,3CH
						JNE						CHECKONF1RECEIVED
						CALL					CHATINVREC
CHECKONF1RECEIVED:		CMP						AL,3BH
						JNE						CONTINUEKEYL
						CALL					GAMEINVREC	
CONTINUEKEYL:			JMP						KEYL						;if not keep listening
ENDG:					MOV						AH,4CH			
						INT						21H
						RET
MAINSCREEN				ENDP
;-------------------------------------------------------------------------------------------------------------------------
;A procedure to draw a line at the bottom of the main screen 3 lines before the boundary
DRAWLINEMAINSCREEN		PROC	NEAR
						MOV		DX,432			;Line coordinate (Height minus 3 lines)
						MOV		CX,0			;Start from x=0
						MOV		AL,0FFH			;pixel color white
						MOV		AH,0CH          ;draw pixel mode
BACK:					INT		10H				;draw pixel
						INC		CX				;inc cx
	    				CMP		CX,639			;to cover whole width
						JNZ		BACK			;loop till width covered			
						RET
DRAWLINEMAINSCREEN		ENDP
;-------------------------------------------------------------------------------------------------------------------------
;A procedure to set the video mode of the main screen
SETVIDEOMODEMAINSCREEN	PROC      NEAR
						MOV		AH,0				;Change video mode 	
			            MOV		AL,12H				;set video mode (12H: 640x480x16)
						INT		10H					;Change video mode and clear screen
						RET
SETVIDEOMODEMAINSCREEN	ENDP
					
;-------------------------------------------------------------------------------------------------------------------------
CLEARLASTLINE			PROC	NEAR	
						MOV		BP,OFFSET CLEAR		
						MOV		AL,0				;Write mode 1
						MOV		AH,13H				;Write string	
						MOV		CX,78				;Number of characters in the string
						MOV		BL,0				;Attribute
						MOV		BH,0				;Page number	
					    MOV 	DH,28
						MOV		DL,0
						INT		10H
						RET
CLEARLASTLINE			ENDP
;-------------------------------------------------------------------------------------------------------------------------
CLEARSENDERLINE			PROC	NEAR	
						MOV		BP,OFFSET CLEAR		
						MOV		AL,0				;Write mode 1
						MOV		AH,13H				;Write string	
						MOV		CX,78				;Number of characters in the string
						MOV		BL,0				;Attribute
						MOV		BH,0				;Page number	
					    MOV 	DH,26
						MOV		DL,0
						INT		10H
						RET
CLEARSENDERLINE			ENDP
;-------------------------------------------------------------------------------------------------------------------------
CLEARRECEIVERLINE		PROC	NEAR	
						MOV		BP,OFFSET CLEAR		
						MOV		AL,0				;Write mode 1
						MOV		AH,13H				;Write string	
						MOV		CX,78				;Number of characters in the string
						MOV		BL,0				;Attribute
						MOV		BH,0				;Page number	
					    MOV 	DH,29
						MOV		DL,0
						INT		10H
						RET
CLEARRECEIVERLINE		ENDP
;-------------------------------------------------------------------------------------------------------------------------
READGUIATTRIBUTES	PROC     	NEAR

					MOV		AH,3Dh					;Open File for reading
					MOV		AL,0					;GUI atrributes into DS
					MOV		DX, OFFSET SHIP1FILE	;File path
					INT		21H
					
					MOV		[SHIP1FILEH],AX			;Copy File Handler 
					MOV		AH,3Fh					;Read Data from file
					MOV		BX,[SHIP1FILEH]			;File Handler
					MOV		CX,SHIPH*SHIPW			;Ship Dimensions
					MOV 	DX,OFFSET SHIP1ATTR		;Read Ship1 into DS
					INT		21H
					
					MOV		AH,3Dh
					MOV		AL,0
					MOV		DX, OFFSET SHIP2FILE
					INT		21H
					
					MOV		[SHIP2FILEH],AX
					MOV		AH,3Fh
					MOV		BX,[SHIP2FILEH]
					MOV		CX,SHIPH*SHIPW
					MOV 	DX,OFFSET SHIP2ATTR
					INT		21H
					
					MOV		AH,3Dh
					MOV		AL,0
					MOV		DX, OFFSET BARR1FILE
					INT		21H
					
					MOV		[BARR1FILEH],AX
					MOV		AH,3Fh
					MOV		BX,[BARR1FILEH]
					MOV		CX,BARRH*BARRW
					MOV 	DX,OFFSET BARR1ATTR
					INT		21H
					
					MOV		AH,3Dh
					MOV		AL,0
					MOV		DX, OFFSET BARR1BFILE
					INT		21H
					
					MOV		[BARR1BFILEH],AX
					MOV		AH,3Fh
					MOV		BX,[BARR1BFILEH]
					MOV		CX,BARRH*BARRW
					MOV 	DX,OFFSET BARR1BATTR
					INT		21H
					
					MOV		AH,3Dh
					MOV		AL,0
					MOV		DX, OFFSET BARR2FILE
					INT		21H
					
					MOV		[BARR2FILEH],AX
					MOV		AH,3Fh
					MOV		BX,[BARR2FILEH]
					MOV		CX,BARRH*BARRW
					MOV 	DX,OFFSET BARR2ATTR
					INT		21H
					
					MOV		AH,3Dh
					MOV		AL,0
					MOV		DX, OFFSET BARR2BFILE
					INT		21H
					
					MOV		[BARR2BFILEH],AX
					MOV		AH,3Fh
					MOV		BX,[BARR2BFILEH]
					MOV		CX,BARRH*BARRW
					MOV 	DX,OFFSET BARR2BATTR
					INT		21H
					
					MOV		AH,3Dh
					MOV		AL,0
					MOV		DX, OFFSET MINEFILE
					INT		21H
					
					MOV		[MINEFILEH],AX
					MOV		AH,3Fh
					MOV		BX,[MINEFILEH]
					MOV		CX,MINEH*MINEW
					MOV 	DX,OFFSET MINEATTR
					INT		21H
					
					RET
READGUIATTRIBUTES	ENDP
;-------------------------------------------------------------------------------------------------------------------------
GETNAME		PROC     		NEAR
			CALL			SETVIDEOMODEMAINSCREEN
			PRINTMESGMAINSCREEN	ENTERNAME1,21,12,28
			PRINTMESGMAINSCREEN	ENTERMSG,24,14,28
			MOV				AH,2
			MOV				DL,31
			MOV				DH,13
			MOV				BH,0
			INT				10H
			MOV				AH,0AH
			MOV				DX,OFFSET SENDERNAME
			INT				21H
			CALL			EXCHANGENAMES
			RET
GETNAME		ENDP
;-------------------------------------------------------------------------------------------------------------------------
EXCHANGENAMES		PROC		NEAR
					CALL		SETVIDEOMODEMAINSCREEN
					CALL		DRAWLINEMAINSCREEN
					PRINTMESGMAINSCREEN	EXCHANGESCREENMSG,22,12,28

					
INFLOOPXCHG:		MOV			AH,1					
					INT			16H							;Check if a key is pressed					
					JZ			NOKEYPRESSEDXCHG			;If no key is pressed check if a name can be received
					MOV			AH,0
					INT			16H							;Get the scan code of the key
					CMP			AH,1CH						;Compare key pressed with Enter
					JNE			NOKEYPRESSEDXCHG			;If the key pressed is not Enter, do not send name and check if a name is sent
					CALL		SENDNAME					;procedure that sends the name and checks for a confirmation
					
				
NOKEYPRESSEDXCHG:	MOV			DX,3FDH
					IN			AL,DX
					XOR			AH,AH
					AND			AL,1
					JZ			CONTINUEKEYLXCHG			;If nothing is received continue listening to keys
					MOV			DX,3F8H
					IN			AL,DX
					CALL		RECEIVENAME					;procedure to receive the name in RECEIVERNAME and send a confirmation
CONTINUEKEYLXCHG:	JMP			INFLOOPXCHG

					RET
EXCHANGENAMES		ENDP
;-------------------------------------------------------------------------------------------------------------------------
SENDNAME			PROC		NEAR

					MOV 		DX,3FDH							;send signal
WAITTILLEMPTYSIGNAL:IN			AL,DX
					AND			AL,00100000B
					JZ			WAITTILLEMPTYSIGNAL
					MOV			DX,3F8H
					MOV			AL,1
					OUT			DX,AL
					CALL		CLEARLASTLINE
					PRINTMESGMAINSCREEN	ESTABLISHCONNECT,23,28,2
					
CONFIRMLOOP:		MOV			DX,3FDH						;check for a confirmation			
					IN			AL,DX
					XOR			AH,AH
					AND			AL,1	
					JZ			CONFIRMLOOP					;if nothing is received print that the connection has failed
					MOV			DX,3F8H
					IN			AL,DX
					CMP			AL,1						
					JNE			NOCONFIRMATIONS				;if the received confirmation != 1 print that the connection has failed		
					
					MOV			SI,0	
SENDNEXTCHARNAME:	MOV 		DX,3FDH
WAITTILLEMPTYSNAME:	IN			AL,DX
					AND			AL,00100000B
					JZ			WAITTILLEMPTYSNAME
					MOV			DX,3F8H
					MOV			AL,BYTE PTR SENDERNAME[SI+2]
					OUT			DX,AL
					INC			SI
					MOV			BX,SI	
					CMP			BL,BYTE PTR SENDERNAME[1]
					JBE			SENDNEXTCHARNAME
					MOV			BX,SI
					MOV			SENDERNAMECOUNT,BL
					MOV			DX,3F8H
					MOV			AL,'$'
					OUT			DX,AL						;send name and terminating  character

					
					MOV			SENDNAMEST,1				;if a confirmation is received set the sender status					
										
					CMP			RECNAMEST,1
					JNE			NONAMERECEIVED
					CALL		MAINSCREEN					
					
NOCONFIRMATIONS:	CALL		CLEARLASTLINE
					PRINTMESGMAINSCREEN	CONNECTFAILMSG,35,28,2	
NONAMERECEIVED:		RET
SENDNAME			ENDP
;-------------------------------------------------------------------------------------------------------------------------
RECEIVENAME			PROC		NEAR	
					
					
					
SENDCONFIRMATION:	MOV 		DX,3FDH							;send confirmation
WAITTILLEMPTYRNAME:	IN			AL,DX
					AND			AL,00100000B
					JZ			WAITTILLEMPTYRNAME
					MOV			DX,3F8H
					MOV			AL,1
					OUT			DX,AL
					CALL		CLEARLASTLINE
					PRINTMESGMAINSCREEN	ENTERTOCONNECT,32,28,2					
					
					MOV			SI,0
					
RECEIVENEXTCHAR:	MOV			DX,3FDH
CHECKNEXTCHARAGAIN:	IN			AL,DX
					XOR			AH,AH
					AND			AL,1
					JZ			CHECKNEXTCHARAGAIN
					
					MOV			DX,3F8H
					IN			AL,DX
					
					MOV			BL,RECNAMECOUNT
					MOV			BH,0
					MOV			SI,BX
					MOV			RECEIVERNAME[SI],AL					
					INC			RECNAMECOUNT
					CMP			RECEIVERNAME[SI],'$'
					JNE			RECEIVENEXTCHAR					;receive whole name			
					
					
					MOV			RECNAMEST,1					
					
					
					CALL		CLEARLASTLINE
					PRINTMESGMAINSCREEN	ENTERTOCONNECT,31,28,2
					CMP			SENDNAMEST,1
					JNE			NONAMESENT
					CALL		MAINSCREEN
					
NONAMESENT:			RET					
RECEIVENAME			ENDP	

;-------------------------------------------------------------------------------------------------------------------------
;function to get key pressed	
GETKEY      PROC      		NEAR
			MOV 			AH,10H		
			INT 			16H
			MOV 			BH,AH		
			RET
GETKEY		ENDP
;-------------------------------------------------------------------------------------------------------------------------
;function to get key pressed without wait
GETKEYWITHOUTWAIT		PROC      NEAR
						MOV		AH,1
						INT		16H
						RET
GETKEYWITHOUTWAIT		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CHATINVSENT				PROC	NEAR
						MOV 	DX,3FDH
WAITTILLEMPTYINVSENT:	IN		AL,DX
						AND		AL,00100000B
						JZ		WAITTILLEMPTYINVSENT
						MOV		DX,3F8H
						MOV		AL,3CH
						OUT		DX,AL						
						PRINTMESGMAINSCREEN	CHATINVSENTMSG,26,28,2
						MOV		CHATINVSTATES,1
						CMP		CHATINVSTATER,1						
						JE		BEGINCHATS
						JMP		NOCHATRECEIVED
BEGINCHATS:				CALL	CHATMODULE	
NOCHATRECEIVED:			RET
CHATINVSENT				ENDP
;-------------------------------------------------------------------------------------------------------------------------
CHATINVREC				PROC	NEAR
						CMP		CHATINVSTATES,1
						JE		BEGINCHATR
						MOV		CHATINVSTATER,1
						PRINTMESGMAINSCREEN	CHATINVRECMSG,30,28,2
						JMP		NOCHATSENT						
BEGINCHATR:				CALL	CHATMODULE	
NOCHATSENT:				RET
CHATINVREC				ENDP
;-------------------------------------------------------------------------------------------------------------------------
GAMEINVSENT				PROC	NEAR
						MOV 	DX,3FDH
WAITTILLEMPTYINVSENTG:	IN		AL,DX
						AND		AL,00100000B
						JZ		WAITTILLEMPTYINVSENTG
						MOV		DX,3F8H
						MOV		AL,3BH
						OUT		DX,AL						
						PRINTMESGMAINSCREEN	GAMEINVSENTMSG,26,28,2
						MOV		GAMEINVSTATES,1
						CMP		GAMEINVSTATER,1						
						JE		BEGINGAMES
						JMP		NOCHATRECEIVED
						
BEGINGAMES:				MOV		MASTERSERIAL,0
						CALL	PLAYGAME	
NOGAMERECEIVED:			RET
GAMEINVSENT				ENDP
;-------------------------------------------------------------------------------------------------------------------------
GAMEINVREC				PROC	NEAR
						CMP		GAMEINVSTATES,1
						JE		BEGINGAMER
						MOV		GAMEINVSTATER,1
						PRINTMESGMAINSCREEN	GAMEINVRECMSG,30,28,2
						JMP		NOGAMESENT						
BEGINGAMER:				MOV		MASTERSERIAL,1
						CALL	PLAYGAME	
NOGAMESENT:				RET
GAMEINVREC				ENDP
;-------------------------------------------------------------------------------------------------------------------------
INGAMECHATINVSENT		PROC	NEAR
						CMP		SENDKBUFF[5],1
						JNE		NOINCHATRECEIVED
						PRINTMESGMAINSCREEN	CHATINVSENTMSG,26,28,2
						MOV		INGAMEINVSTATES,1
						CMP		INGAMEINVSTATER,1						
						JE		BEGININCHATS
						JMP		NOINCHATRECEIVED
BEGININCHATS:			CALL	INCHATMODULE	
						; MOV		SENDKBUFF[5],0
						; MOV		RECKBUF[5],0
						; MOV		INGAMEINVSTATES,0
						; MOV		INGAMEINVSTATER,0
NOINCHATRECEIVED:		RET
INGAMECHATINVSENT		ENDP
;-------------------------------------------------------------------------------------------------------------------------
INGAMECHATINVREC		PROC	NEAR
						CMP		RECKBUF[5],1
						JNE		NOINCHATSENT		
						MOV		INGAMEINVSTATER,1					
						CMP		INGAMEINVSTATES,1
						JE		BEGININCHATR						
						PRINTMESGMAINSCREEN	CHATINVRECMSG,30,28,2
						JMP		NOINCHATSENT						
BEGININCHATR:			CALL	INCHATMODULE
						; MOV		RECKBUF[5],0
						; MOV		SENDKBUFF[5],0	
						; MOV		INGAMEINVSTATES,0
						; MOV		INGAMEINVSTATER,0
						
NOINCHATSENT:			RET
INGAMECHATINVREC		ENDP
;-------------------------------------------------------------------------------------------------------------------------
UPDATEKEYBOARDISR		PROC	NEAR
						XOR		AX, AX				
						MOV     ES, AX

						CLI                         						; UPDATE ISR ADDRESS W/ INTS DISABLED
						MOV 		AX, WORD PTR ES:[9*4]     			; STORE CURRENT ISR ADDRESS
						MOV			WORD PTR IRQ1OFF, AX
						MOV 		AX, WORD PTR ES:[9*4+2]     				; STORE CURRENT ISR ADDRESS
						MOV			WORD PTR IRQ1SEG, AX
						MOV   	  	WORD PTR ES:[9*4], OFFSET IRQ1ISR		;MOVE MY IRQ1 ISR HANDLER TO INT 9H
						MOV     	WORD PTR ES:[9*4+2], CS					;MOVE SEGMENT FOR FULL ADDRESS
						STI													;ENABLE INTS
			
						MOV		AX,DS					
						MOV		ES,AX
						RET
UPDATEKEYBOARDISR		ENDP
;-------------------------------------------------------------------------------------------------------------------------
RESTOREKEYBOARDISR		PROC	NEAR
						XOR		AX, AX
						MOV     ES, AX
						
						CLI                         ; UPDATE ISR ADDRESS W/ INTS DISABLED
						MOV			AX, WORD PTR IRQ1SEG
						MOV    		WORD PTR ES:[9*4+2], AX   ; RESTORE ISR ADDRESS
						MOV			AX, WORD PTR IRQ1OFF
						MOV     	WORD PTR ES:[9*4], AX  ;FROM STACK
						STI							;ENABLE INTS
						
						MOV		AX,DS
						MOV		ES,AX
						RET
RESTOREKEYBOARDISR		ENDP
;-------------------------------------------------------------------------------------------------------------------------
;Main play game function
PLAYGAME			PROC      NEAR
					MOV			GAMEINVSTATER,0
					MOV			GAMEINVSTATES,0
					;CALL		GETNAME
					CALL		DRAWGAME			;draw initial state
					CALL 		DRAWBARRIERS
					CALL		DRAWSCORESSHIP1
					CALL		DRAWSCORESSHIP2
					CALL		UPDATEKEYBOARDISR
					PRINTMESGMAINSCREEN		SHIP1ROUND,3,0,37
LOOPPLAY:			
					;CALL		DRAWBULLETCOUNTS2
					CALL		SAVEACTION
					CALL		CONVERTBUFFTOB
					
					CMP			MASTERSERIAL,1
					JE			MASTER
					CALL		PREPAREXCHGS					
					JMP			BEGINEXCG
MASTER:				CALL		PREPAREXCHGM				
					
					
					
BEGINEXCG:			CALL		CONVERTBTOBUFF
					CALL		INGAMECHATINVREC
					CALL		INGAMECHATINVSENT
					CMP			MASTERSERIAL,1
					JE			MASTERACTION	
					CALL		GETACTIONS
					JMP			CONTINUEPLAYGAME
MASTERACTION:		CALL		GETACTIONM

CONTINUEPLAYGAME:	CALL		UPDATEBARRIERS
					CALL		DRAWBARRIERS
					CALL		UPDATEBULLETS
					CALL		UPDATEBULLCOUNTER
					CALL		CHECKCOLLISIONS
					CALL		DRAWBULLETS
					CALL		UPDATESCORESSHIP1
					CALL		UPDATESCORESSHIP2
					
					
					CMP			LEVELSTF,0
					JE			NOLEVEL2
					
					
					
					CALL		CREATEMINES
					CALL		CREATEMINES2
					CALL		UPDATEMINES	
					CALL		CHECKMINESCOLL	;TEMP TO BE CALLED IN  PGAME2

					
					
					;CMP			CLOSE,1
NOLEVEL2:			INC			MASTERCLOCK
					JMP			LOOPPLAY
					MOV			AH,4CH
					INT			21H
					
					
					
					; MOV			CX,2
					; MOV			DX,2710H
					; MOV			AH,86H
					; INT			15H
				
					JMP			LOOPPLAY			
EXITPLAYGAME:		RET
PLAYGAME			ENDP
;-------------------------------------------------------------------------------------------------------------------------
;1:up 2:dwn 3:lft 4:rght 5:fire

;-------------------------------------------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------------------------------------------
DRAWGAME			PROC      NEAR
					CALL		DRAWBACKGROUND			
					CALL		DRAWSHIPS					
					RET
DRAWGAME			ENDP
;-------------------------------------------------------------------------------------------------------------------------
DRAWBACKGROUND		PROC      NEAR
					MOV			AH,0
					MOV			AL,12H				;mode 12H (640x480x16)
					INT			10H					;change video mode			
					MOV			BX,0				;page number
					MOV			DX,30				;initial coordinates of play area
BACKGROUNDOUTLOOP:	MOV			CX,0				;column coordinate
					MOV			AL,0Bh				;color
					MOV			AH,0CH				;draw pixel mode
BACKGROUNDINLOOP:	INT			10H					
					INC			CX
					CALL		TEXTUREBG
					MOV			AH,0CH
					CMP			CX,639				;end of columns	
					JBE			BACKGROUNDINLOOP
					INC			DX
					CMP			DX,384				;end of play area
					JBE			BACKGROUNDOUTLOOP
					RET
DRAWBACKGROUND		ENDP
;-------------------------------------------------------------------------------------------------------------------------
TEXTUREBG			PROC      NEAR
					MOV			AX,0C0BH
					PUSH 		DX
					PUSH		CX
					PUSH		BX
					PUSH		AX
					MOV 		AX,DX
					MOV			DX,20
					DIV			DL
					CMP			AH,2
					JAE			ENDTEXTURE
					MOV			DL,2
					DIV  		DL
					CMP			AH,1
					JE			ODDTEXTURE
					JNE			EVENTEXTURE
ODDTEXTURE:			MOV			AX,CX
					MOV			DX,40
					DIV			Dl
					CMP			AH,30
					JBE			ENDTEXTURE
					JMP			CHANGETEXTURE
EVENTEXTURE:		MOV			AX,CX
					MOV			DX,40
					DIV			Dl
					CMP			AH,10
					JAE			ENDTEXTURE
CHANGETEXTURE:		POP			AX
					MOV 		AX,0C03H
					PUSH		AX
ENDTEXTURE:			POP			AX
					POP			BX
					POP			CX
					POP			DX
					RET
TEXTUREBG			ENDP
;-------------------------------------------------------------------------------------------------------------------------
DRAWSHIPS			PROC      NEAR					
					CALL		DRAWSHIP1
					CALL		DRAWSHIP2
					RET
DRAWSHIPS			ENDP
;-------------------------------------------------------------------------------------------------------------------------
CLEARSHIP1UP		PROC      NEAR
					MOV			DX,SHIP1ROW			;load current position of ship
					MOV			SHIP1ROWH,DX				
					ADD			SHIP1ROWH,29		;calculate half coordinate of ship
					MOV			SHIP1ROWF,DX
					MOV 		DX,SHIP1ROWH
					ADD			DX,24
					ADD			SHIP1ROWF,59		;calculate full coordinate of ship		
SHIP1CLEAROUT:		MOV			CX,SHIP1COLDR				;initial column coordinate of ship			
					MOV			AH,0CH				;draw pixel mode
SHIP1CLEARIN:		MOV			AL,00BH				;pixel color	
					INT			10H					;draw pixel	
					INC			CX					
					CMP			CX,SHIP1COLDRF				;end of ship column coordinate
					JBE			SHIP1CLEARIN		;loop till end of ship width
					INC			DX					
					CMP			DX,SHIP1ROWF		;loop till end of ship length
					JBE			SHIP1CLEAROUT
					
					
					MOV			CX,SHIP1COLDRF
					ADD			CX,1
					MOV			GUNCOLS1,CX
					
					ADD			CX,7
					MOV			GUNCOLS1F,CX
					
					MOV 		DX,SHIP1ROWH
					SUB			DX,1
					MOV			DI,0
SHIP1GUNOUTCLOOPU:	MOV			CX,GUNCOLS1
					MOV			AL,0Bh
SHIP1GUNINCLOOPU:	INT			10H
					INC			CX
					CMP			CX,GUNCOLS1F
					JBE			SHIP1GUNINCLOOPU
					INC			DX
					INC			DI
					CMP			DI,3
					JBE			SHIP1GUNOUTCLOOPU
					
					RET
CLEARSHIP1UP		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CLEARSHIP1DOWN		PROC      	NEAR
					MOV			DX,SHIP1ROW			;load current position of ship
					MOV			SHIP1ROWH,DX				
					ADD			SHIP1ROWH,29		;calculate half coordinate of ship
					MOV			SHIP1ROWF,DX
					ADD			SHIP1ROWF,5			;calculate full coordinate of ship		
SHIP1CLEAROUTD:		MOV			CX,SHIP1COLDR				;initial column coordinate of ship			
					MOV			AH,0CH				;draw pixel mode
SHIP1CLEARIND:		MOV			AL,0BH				;pixel color	
					INT			10H					;draw pixel	
					INC			CX					
					CMP			CX,SHIP1COLDRF				;end of ship column coordinate
					JBE			SHIP1CLEARIND		;loop till end of ship width
					INC			DX					
					CMP			DX,SHIP1ROWF		;loop till end of ship length
					JBE			SHIP1CLEAROUTD
					
					
					MOV			CX,SHIP1COLDRF
					ADD			CX,1
					MOV			GUNCOLS1,CX
					
					ADD			CX,7
					MOV			GUNCOLS1F,CX
					
					
					MOV 		DX,SHIP1ROWH
					SUB			DX,1
					MOV			DI,0
SHIP1GUNOUTCLOOPD:	MOV			CX,GUNCOLS1
					MOV			AL,0Bh
SHIP1GUNINCLOOPD:	INT			10H
					INC			CX
					CMP			CX,GUNCOLS1F
					JBE			SHIP1GUNINCLOOPD
					INC			DX
					INC			DI
					CMP			DI,3
					JBE			SHIP1GUNOUTCLOOPD
					
					RET
CLEARSHIP1DOWN		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CLEARSHIP1HOME		PROC
					MOV 		CX,SHIP1COL
					MOV 		DX,SHIP1ROW
CLEARS1HOMEOUTLOOP:	MOV 		CX,SHIP1COL
					MOV			AH,0CH
					MOV 		BH,0
					MOV 		AL,0BH
CLEARS1HOMEINLOOP:	INT 		10H
					INC			CX
					CMP			CX,SHIP1COLF
					JBE			CLEARS1HOMEINLOOP
					INC			DX
					CMP			DX,SHIP1ROWF
					JBE			CLEARS1HOMEOUTLOOP
					
					MOV			CX,SHIP1COLF
					ADD			CX,1
					MOV			GUNCOLS1,CX
					
					ADD			CX,7
					MOV			GUNCOLS1F,CX
					
					
					MOV 		DX,SHIP1ROWH
					SUB			DX,1
					MOV			DI,0
SHIP1GUNOUTCLOOPH:	MOV			CX,GUNCOLS1
					MOV			AL,0Bh
SHIP1GUNINCLOOPH:	INT			10H
					INC			CX
					CMP			CX,GUNCOLS1F
					JBE			SHIP1GUNINCLOOPH
					INC			DX
					INC			DI
					CMP			DI,3
					JBE			SHIP1GUNOUTCLOOPH
					
					RET
CLEARSHIP1HOME		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CLEARSHIP1AWAY		PROC
					MOV 		CX,SHIP1COL
					MOV 		DX,SHIP1ROW
CLEARS1AWAYOUTLOOP:	MOV 		CX,SHIP1COL1
					MOV			AH,0CH
					MOV 		BH,0
					MOV 		AL,0BH
CLEARS1AWAYINLOOP:	INT 		10H
					INC			CX
					CMP			CX,SHIP1COLF1
					JBE			CLEARS1AWAYINLOOP
					INC			DX
					CMP			DX,SHIP1ROWF
					JBE			CLEARS1AWAYOUTLOOP
					
					MOV			CX,SHIP1COLF1
					ADD			CX,1
					MOV			GUNCOLS1,CX
					
					ADD			CX,7
					MOV			GUNCOLS1F,CX
					
					
					MOV 		DX,SHIP1ROWH
					SUB			DX,1
					MOV			DI,0
SHIP1GUNOUTCLOOPA:	MOV			CX,GUNCOLS1
					MOV			AL,0Bh
SHIP1GUNINCLOOPA:	INT			10H
					INC			CX
					CMP			CX,GUNCOLS1F
					JBE			SHIP1GUNINCLOOPA
					INC			DX
					INC			DI
					CMP			DI,3
					JBE			SHIP1GUNOUTCLOOPA

					RET
CLEARSHIP1AWAY		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CLEARSHIP2UP		PROC      	NEAR
					MOV			DX,SHIP2ROW			;load current position of ship
					MOV			SHIP2ROWH,DX				
					ADD			SHIP2ROWH,29		;calculate half coordinate of ship
					MOV			SHIP2ROWF,DX
					MOV 		DX,SHIP2ROWH
					ADD			DX,24
					ADD			SHIP2ROWF,59		;calculate full coordinate of ship		
SHIP2CLEAROUT:		MOV			CX,SHIP2COLDR				;initial column coordinate of ship			
					MOV			AH,0CH				;draw pixel mode
SHIP2CLEARIN:		MOV			AL,0BH				;pixel color	
					INT			10H					;draw pixel	
					INC			CX					
					CMP			CX,SHIP2COLDRF			;end of ship column coordinate
					JBE			SHIP2CLEARIN		;loop till end of ship width
					INC			DX					
					CMP			DX,SHIP2ROWF		;loop till end of ship length
					JBE			SHIP2CLEAROUT
					
					MOV			CX,SHIP2COLDR
					SUB			CX,7
					MOV			GUNCOLS2,CX
					
					ADD			CX,6
					MOV			GUNCOLS2F,CX
					
					MOV 		DX,SHIP2ROWH
					SUB			DX,1
					MOV			DI,0
SHIP2GUNOUTCLOOPU:	MOV			CX,GUNCOLS2
					MOV			AL,0Bh
SHIP2GUNINCLOOPU:	INT			10H
					INC			CX
					CMP			CX,GUNCOLS2F
					JBE			SHIP2GUNINCLOOPU
					INC			DX
					INC			DI
					CMP			DI,3
					JBE			SHIP2GUNOUTCLOOPU	
					
					RET
CLEARSHIP2UP		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CLEARSHIP2DOWN		PROC      NEAR
					MOV			DX,SHIP2ROW			;load current position of ship
					MOV			SHIP2ROWH,DX				
					ADD			SHIP2ROWH,29		;calculate half coordinate of ship
					MOV			SHIP2ROWF,DX
					ADD			SHIP2ROWF,5			;calculate full coordinate of ship		
SHIP2CLEAROUTD:		MOV			CX,SHIP2COLDR				;initial column coordinate of ship			
					MOV			AH,0CH				;draw pixel mode
SHIP2CLEARIND:		MOV			AL,0BH				;pixel color	
					INT			10H					;draw pixel	
					INC			CX					
					CMP			CX,SHIP2COLDRF			;end of ship column coordinate
					JBE			SHIP2CLEARIND		;loop till end of ship width
					INC			DX					
					CMP			DX,SHIP2ROWF		;loop till end of ship length
					JBE			SHIP2CLEAROUTD
					
					MOV			CX,SHIP2COLDR
					SUB			CX,7
					MOV			GUNCOLS2,CX
					
					ADD			CX,6
					MOV			GUNCOLS2F,CX
					
					
					MOV 		DX,SHIP2ROWH
					SUB			DX,1
					MOV			DI,0
SHIP2GUNOUTCLOOPD:	MOV			CX,GUNCOLS2
					MOV			AL,0Bh
SHIP2GUNINCLOOPD:	INT			10H
					INC			CX
					CMP			CX,GUNCOLS2F
					JBE			SHIP2GUNINCLOOPD
					INC			DX
					INC			DI
					CMP			DI,3
					JBE			SHIP2GUNOUTCLOOPD
					RET
CLEARSHIP2DOWN		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CLEARSHIP2HOME		PROC
					MOV 		CX,SHIP2COL
					MOV 		DX,SHIP2ROW
CLEARS2HOMEOUTLOOP:	MOV 		CX,SHIP2COL
					MOV			AH,0CH
					MOV 		BH,0
					MOV 		AL,0BH
CLEARS2HOMEINLOOP:	INT 		10H
					INC			CX
					CMP			CX,SHIP2COLF
					JBE			CLEARS2HOMEINLOOP
					INC			DX
					CMP			DX,SHIP2ROWF
					JBE			CLEARS2HOMEOUTLOOP
					
					MOV			CX,SHIP2COL
					SUB			CX,7
					MOV			GUNCOLS2,CX
					
					ADD			CX,6
					MOV			GUNCOLS2F,CX
					
					MOV 		DX,SHIP2ROWH
					SUB			DX,1
					MOV			DI,0
SHIP2GUNOUTCLOOPH:	MOV			CX,GUNCOLS2
					MOV			AL,0Bh
SHIP2GUNINCLOOPH:	INT			10H
					INC			CX
					CMP			CX,GUNCOLS2F
					JBE			SHIP2GUNINCLOOPH
					INC			DX
					INC			DI
					CMP			DI,3
					JBE			SHIP2GUNOUTCLOOPH	
					RET
CLEARSHIP2HOME		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CLEARSHIP2AWAY		PROC
					MOV 		CX,SHIP2COL
					MOV 		DX,SHIP2ROW
CLEARS2AWAYOUTLOOP:	MOV 		CX,SHIP2COL1
					MOV			AH,0CH
					MOV 		BH,0
					MOV 		AL,0BH
CLEARS2AWAYINLOOP:	INT 		10H
					INC			CX
					CMP			CX,SHIP2COLF1
					JBE			CLEARS2AWAYINLOOP
					INC			DX
					CMP			DX,SHIP2ROWF
					JBE			CLEARS2AWAYOUTLOOP
					
					MOV			CX,SHIP2COL1
					SUB			CX,7
					MOV			GUNCOLS2,CX
					
					ADD			CX,6
					MOV			GUNCOLS2F,CX
					
					MOV 		DX,SHIP2ROWH
					SUB			DX,1
					MOV			DI,0
SHIP2GUNOUTCLOOPA:	MOV			CX,GUNCOLS2
					MOV			AL,0Bh
SHIP2GUNINCLOOPA:	INT			10H
					INC			CX
					CMP			CX,GUNCOLS2F
					JBE			SHIP2GUNINCLOOPA
					INC			DX
					INC			DI
					CMP			DI,3
					JBE			SHIP2GUNOUTCLOOPA	
					RET
CLEARSHIP2AWAY		ENDP
;-------------------------------------------------------------------------------------------------------------------------
DRAWSHIP1			PROC      NEAR
					MOV			SI,OFFSET SHIP1ATTR		;load attribute array	
					MOV			DX,SHIP1ROW			;load current position of ship1
					MOV			SHIP1ROWH,DX			
					ADD			SHIP1ROWH,29		;calculate ship half coordinate	
					MOV			SHIP1ROWF,DX
					ADD			SHIP1ROWF,59		;calculate ship full coordinate
SHIP1OUTLOOP1:		MOV			CX,SHIP1COLDR				;initial column coordinate of ship	
					MOV			AH,0CH				;draw pixel mode
SHIP1INLOOP1:		MOV			AL,[SI]				;determine pixel color from attribute array
					INT			10H					;draw pixel
					INC			CX					;go to the next column	
					INC			SI					;go to the next attribute		
					CMP			CX,SHIP1COLDRF				;end of ship width
					JBE			SHIP1INLOOP1		
					INC			DX					;go to the next row	
					CMP			DX,SHIP1ROWF		;end of the first half of the ship
					JBE			SHIP1OUTLOOP1				
					
					MOV			CX,SHIP1COLDRF
					ADD			CX,1
					MOV			GUNCOLS1,CX
					
					ADD			CX,7
					MOV			GUNCOLS1F,CX
					
					
					MOV 		DX,SHIP1ROWH
					SUB			DX,1
					MOV			DI,0
SHIP1GUNOUTLOOP:	MOV			CX,GUNCOLS1
					MOV			AL,0h
SHIP1GUNINLOOP:		INT			10H
					INC			CX
					CMP			CX,GUNCOLS1F
					JBE			SHIP1GUNINLOOP
					INC			DX
					INC			DI
					CMP			DI,3
					JBE			SHIP1GUNOUTLOOP
					
					RET
DRAWSHIP1			ENDP
;-------------------------------------------------------------------------------------------------------------------------
;look at DRAWSHIP1 for comments
DRAWSHIP2			PROC      NEAR
					MOV			SI,OFFSET SHIP2ATTR
					MOV			DX,SHIP2ROW
					MOV			SHIP2ROWH,DX
					ADD			SHIP2ROWH,29
					MOV			SHIP2ROWF,DX
					ADD			SHIP2ROWF,59
SHIP2OUTLOOP1:		MOV			CX,SHIP2COLDR					
					MOV			AH,0CH
SHIP2INLOOP1:		MOV			AL,[SI]
					INT			10H
					INC			CX
					INC			SI
					CMP			CX,SHIP2COLDRF
					JBE			SHIP2INLOOP1
					INC			DX
					CMP			DX,SHIP2ROWF
					JBE			SHIP2OUTLOOP1

					MOV			CX,SHIP2COLDR
					SUB			CX,7
					MOV			GUNCOLS2,CX
					
					
					ADD			CX,6
					MOV			GUNCOLS2F,CX


					MOV 		DX,SHIP2ROWH
					SUB			DX,1
					MOV			DI,0
SHIP2GUNOUTLOOP:	MOV			CX,GUNCOLS2
					MOV			AL,0h
SHIP2GUNINLOOP:		INT			10H
					INC			CX
					CMP			CX,GUNCOLS2F
					JBE			SHIP2GUNINLOOP
					INC			DX
					INC			DI
					CMP			DI,3
					JBE			SHIP2GUNOUTLOOP	



					
					
					RET
DRAWSHIP2			ENDP
;-------------------------------------------------------------------------------------------------------------------------
;moves the ship up if the appropriate key is pressed 	
MOVESHIP1UP			PROC      NEAR
					; CMP			AH,11H			;compare with scan code of 'w'		
					; JNE			EXITSHIP1UP		;exit if 'w' is not pressed
					CMP			SHIP1ROW,32		;compare with upper boundary
					JBE			EXITSHIP1UP		;exit if out of play area
					CALL		CLEARSHIP1UP	;erases the previous drawing
					SUB			SHIP1ROW,5		;move ship1 up
					CALL		DRAWSHIP1		;draws ship1 in the new position
EXITSHIP1UP:		RET
MOVESHIP1UP			ENDP
;-------------------------------------------------------------------------------------------------------------------------
;look at MOVESHIP1UP for comments
MOVESHIP2UP			PROC      NEAR
					; CMP			AH,48H			;compare with scan code of page up button
					; JNE			EXITSHIP2UP
					CMP			SHIP2ROW,32
					JBE			EXITSHIP2UP
					CALL		CLEARSHIP2UP
					SUB			SHIP2ROW,5
					CALL		DRAWSHIP2
EXITSHIP2UP:		RET
MOVESHIP2UP			ENDP
;-------------------------------------------------------------------------------------------------------------------------
;move the ship down if the appropriate key is pressed 
MOVESHIP1DOWN		PROC      NEAR
					; CMP			AH,1FH			;compare with scan code of 's'
					; JNE			EXITSHIP1DOWN	;exit if 's' is not pressed
					CMP			SHIP1ROW,322	;compare with lower boundary	
					JAE			EXITSHIP1DOWN	;exit if out of play area
					CALL		CLEARSHIP1DOWN	;erases the previous drawing
					ADD			SHIP1ROW,5		;move ship1 down
					CALL		DRAWSHIP1		;draws ship1 in the new position
EXITSHIP1DOWN:		RET
MOVESHIP1DOWN		ENDP
;-------------------------------------------------------------------------------------------------------------------------
;look at MOVESHIP1DOWN for comments
MOVESHIP2DOWN		PROC      NEAR
					; CMP			AH,50H			;compare with scan code of page down button
					; JNE			EXITSHIP2DOWN
					CMP			SHIP2ROW,322
					JAE			EXITSHIP2DOWN
					CALL		CLEARSHIP2DOWN
					ADD			SHIP2ROW,5
					CALL		DRAWSHIP2
EXITSHIP2DOWN:		RET
MOVESHIP2DOWN		ENDP
;-------------------------------------------------------------------------------------------------------------------------
MOVESHIP1HOME		PROC		NEAR
					CMP			SHIP1COLST,0
					JE			EXITMOVESHIP1H
					MOV			SHIP1COLST,0
					MOV			AX,SHIP1COL
					MOV			SHIP1COLDR,AX
					MOV			AX,SHIP1COLF
					MOV			SHIP1COLDRF,AX
					CALL		CLEARSHIP1AWAY
					CALL		DRAWSHIP1
EXITMOVESHIP1H:		RET
MOVESHIP1HOME		ENDP
;-------------------------------------------------------------------------------------------------------------------------
MOVESHIP2HOME		PROC		NEAR
					CMP			SHIP2COLST,0
					JE			EXITMOVESHIP2H
					MOV			SHIP2COLST,0
					MOV			AX,SHIP2COL
					MOV			SHIP2COLDR,AX
					MOV			AX,SHIP2COLF
					MOV			SHIP2COLDRF,AX
					CALL		CLEARSHIP2AWAY
					CALL		DRAWSHIP2
EXITMOVESHIP2H:		RET
MOVESHIP2HOME		ENDP
;-------------------------------------------------------------------------------------------------------------------------
MOVESHIP1AWAY		PROC		NEAR
					CMP			SHIP1COLST,1
					JE			EXITMOVESHIP1A
					MOV			SHIP1COLST,1
					MOV			AX,SHIP1COL1
					MOV			SHIP1COLDR,AX
					MOV			AX,SHIP1COLF1
					MOV			SHIP1COLDRF,AX
					CALL		CLEARSHIP1HOME
					CALL		DRAWSHIP1

EXITMOVESHIP1A:		RET
MOVESHIP1AWAY		ENDP
;-------------------------------------------------------------------------------------------------------------------------
MOVESHIP2AWAY		PROC		NEAR
					CMP			SHIP2COLST,1
					JE			EXITMOVESHIP2A
					MOV			SHIP2COLST,1
					MOV			AX,SHIP2COL1
					MOV			SHIP2COLDR,AX
					MOV			AX,SHIP2COLF1
					MOV			SHIP2COLDRF,AX
					CALL		CLEARSHIP2HOME
					CALL		DRAWSHIP2

EXITMOVESHIP2A:		RET
MOVESHIP2AWAY		ENDP
;-------------------------------------------------------------------------------------------------------------------------
;checks if a key is pressed and activates the corresponding action
CHECKSHIPACTION		PROC      NEAR
					CALL		GETKEYWITHOUTWAIT				
					JZ			EXITCHECK				;if no key press exit the PROC      NEARedure
					MOV 		AH,0					
					INT			16H						;capture the scan code of key in AH
					CALL		MOVESHIP1UP					
					CALL		MOVESHIP1DOWN
					CALL		MOVESHIP2UP
					CALL		MOVESHIP2DOWN
EXITCHECK:			RET
CHECKSHIPACTION		ENDP
;-------------------------------------------------------------------------------------------------------------------------
DRAWBARRIERS		PROC      NEAR
					MOV			SI,0					;SI points to the data of the first barrier
STARTDRAWBAR:		MOV			DI,0
					CMP			SI,2
					JE			BAR2DRAW
					CMP			SI,8
					JE			BAR2DRAW
BAR1DRAW:			CMP			BARRIERST[SI],0
					JE			BARRIERMOVCOLOR
					PUSH		SI
					PUSH   		DI
					MOV			CX,BARRH*BARRW
					MOV 		SI,OFFSET	BARR1BATTR
					MOV			DI,OFFSET CURRBARRAT
					REP			MOVSB
					POP			DI
					POP			SI
					JMP			BARRIERLOOP
BARRIERMOVCOLOR:	PUSH		SI
					PUSH   		DI
					MOV			CX,BARRH*BARRW
					MOV 		SI,OFFSET	BARR1ATTR
					MOV			DI,OFFSET CURRBARRAT
					REP			MOVSB
					POP			DI
					POP			SI
					JMP			BARRIERLOOP
BAR2DRAW:			CMP			BARRIERST[SI],0
					JE			BARRIERMOVCOLOR2
					PUSH		SI
					PUSH   		DI
					MOV			CX,BARRH*BARRW
					MOV 		SI,OFFSET	BARR2BATTR
					MOV			DI,OFFSET CURRBARRAT
					REP			MOVSB
					POP			DI
					POP			SI
					JMP			BARRIERLOOP
BARRIERMOVCOLOR2:	PUSH		SI
					PUSH   		DI
					MOV			CX,BARRH*BARRW
					MOV 		SI,OFFSET	BARR2ATTR
					MOV			DI,OFFSET CURRBARRAT
					REP			MOVSB
					POP			DI
					POP			SI
					JMP			BARRIERLOOP
BARRIERLOOP:		MOV			DX,BARRIERROW[SI]		;move in DX the row of the barrier
BARRIEROUT:			MOV			CX,BARRIERCOL[SI]		;move in CX the column of the barrier	
					MOV			AH,0CH					;draw pixel mode
					MOV			BH,00H
BARRIERIN:			MOV			AL,CURRBARRAT[DI]
					INT			10H						;draw the pixel	
					INC			CX						;go to the next column
					INC			DI
					CMP			CX,BARRIERENDC[SI]		;compare the column with the width of the barrier
					JBE			BARRIERIN				;loop to draw the next pixel	
					INC			DX						;go to the next row
					CMP			DX,BARRIERENDR[SI]		;compare the row with the length of the barrier	
					JBE			BARRIEROUT				;loop to draw the next line	
					
					CMP			BARRIERDI[SI],0
					JE			CLEARBARUP
					MOV			AX,BARRIERROW[SI]
					DEC			AX
					MOV			DX,AX
					MOV			CX,BARRIERCOL[SI]
					MOV			AL,0BH
					MOV			AH,0CH
BARCLEARLINEDOWN:	INT			10H
					INC			CX
					CMP			CX,BARRIERENDC[SI]
					JBE			BARCLEARLINEDOWN
					JMP			DRAWNEXTBAR
CLEARBARUP:			MOV			AX,BARRIERENDR[SI]
					INC			AX
					MOV			DX,AX
					MOV			CX,BARRIERCOL[SI]
					MOV			AL,0BH
					MOV			AH,0CH
BARCLEARLINEUP:		INT			10H
					INC			CX
					CMP			CX,BARRIERENDC[SI]
					JBE			BARCLEARLINEUP					
					
					
DRAWNEXTBAR:		ADD			SI,2					;go the data of the next barrier
					CMP			SI,10					;compare with the last barrier 
					JA			ENDDRAWBARR
					JMP	FAR		ptr STARTDRAWBAR			;loop to draw the next barrier	
					
ENDDRAWBARR:		RET
DRAWBARRIERS		ENDP
;-------------------------------------------------------------------------------------------------------------------------
UPDATEBARRIERS		PROC      NEAR
					CALL  		CHECKBARRIERSTATE
					CALL		MOVEBARRIERS
					CALL		RESETBARRIERSTATE
					RET
UPDATEBARRIERS		ENDP
;-------------------------------------------------------------------------------------------------------------------------
RESETBARRIERSTATE	PROC      NEAR
					MOV			SI,0
RESETSTATELOOP:		MOV			AX,BARRIERST[SI]
					CMP			AX,0
					JE			RESETCHECKNEXT
					DEC			BARRIERTI[SI]
					MOV			BX,BARRIERTI[SI]
					CMP			BX,0
					JA			RESETCHECKNEXT
					MOV			BARRIERST[SI],0


RESETCHECKNEXT:		ADD			SI,2
					CMP			SI,10
					JBE			RESETSTATELOOP
					RET	
RESETBARRIERSTATE	ENDP
;-------------------------------------------------------------------------------------------------------------------------
CHECKBARRIERSTATE	PROC      NEAR
					MOV			SI,0
CHECKBARSTLOOP:		CMP			BARRIERROW[SI],30
					JBE			TOGGLEBARST
					CMP			BARRIERENDR[SI],384
					JAE			TOGGLEBARST
					JMP			CHECKNEXTBAR
TOGGLEBARST:		XOR			BARRIERDI[SI],1	
CHECKNEXTBAR:		ADD 		SI,2
					CMP			SI,10
					JBE			CHECKBARSTLOOP
					RET
CHECKBARRIERSTATE	ENDP
;-------------------------------------------------------------------------------------------------------------------------
MOVEBARRIERS		PROC      NEAR
					MOV			SI,0
MOVBARSLOOP:		CALL		MOVEBARRIERUP
					CALL		MOVEBARRIERDOWN
					ADD			SI,2
					CMP			SI,10
					JBE			MOVBARSLOOP
					RET
MOVEBARRIERS		ENDP
;-------------------------------------------------------------------------------------------------------------------------
MOVEBARRIERUP		PROC      NEAR
					MOV			AX,WORD PTR BARRIERDI[SI]
					CMP			AX,0
					JNE			EXITMOVBARUP
					MOV			AX,WORD PTR BARRIERSP[SI]
					SUB			BARRIERROW[SI],AX
					SUB			BARRIERENDR[SI],AX	
EXITMOVBARUP:		RET
MOVEBARRIERUP		ENDP	
;-------------------------------------------------------------------------------------------------------------------------
MOVEBARRIERDOWN		PROC      NEAR
					MOV			AX,WORD PTR BARRIERDI[SI]
					CMP			AX,1
					JNE			EXITMOVBARDOWN
					MOV			AX,WORD PTR BARRIERSP[SI]
					ADD			BARRIERROW[SI],AX
					ADD			BARRIERENDR[SI],AX	
EXITMOVBARDOWN:		RET
MOVEBARRIERDOWN		ENDP	
;-------------------------------------------------------------------------------------------------------------------------
; CHECKBULLETFIRE		PROC      NEAR
					; CALL		GETKEYWITHOUTWAIT		
					; JZ			EXITCHECKBULLET			;if no key press exit the PROC      NEARedure
					; MOV 		AH,0					
					; INT			16H						;capture the scan code of key in AH
					; CMP			AH,21H					;check with ascii in al
					; JNE			NEXTCHECKBUL			;if not equal check second key
					; CALL		CREATEBULLETSHIP1		;call to fire for ship1
					; JMP			EXITCHECKBULLET			;ret
; NEXTCHECKBUL:		CMP			AH,26H					;compare with fire of second ship
					; JNE			EXITCHECKBULLET			;not equal exit
					; CALL		CREATEBULLETSHIP2		;call fire for ship2
; EXITCHECKBULLET:	RET
; CHECKBULLETFIRE		ENDP
;-------------------------------------------------------------------------------------------------------------------------
UPDATEBULLCOUNTER	PROC	 NEAR
					CMP			BULLCOUNTS1,20
					JE			CHECKS2BULLC
					DEC			BULLS1TIMER
					CMP			BULLS1TIMER,0
					JA			CHECKS2BULLC
					INC			BULLCOUNTS1
					MOV			BULLS1TIMER,10
CHECKS2BULLC:		CMP			BULLCOUNTS2,20
					JE			EXITUPDATEBULLC
					DEC			BULLS2TIMER
					CMP			BULLS2TIMER,0
					JA			EXITUPDATEBULLC
					INC			BULLCOUNTS2
					MOV			BULLS2TIMER,10
					
					
EXITUPDATEBULLC:	RET
UPDATEBULLCOUNTER	ENDP
;-------------------------------------------------------------------------------------------------------------------------
CREATEBULLETSHIP1	PROC      NEAR
					CMP			BULLCOUNTS1,0
					JBE			EXITCREATEBULL1
					MOV			SI,0
BULLARRAYLOOP1:		CMP			BULLETFREE[SI],0
					JNE			SKIPBULLADD1
					MOV			WORD PTR BULLETFREE[SI],1
					MOV			WORD PTR BULLETST[SI],0
					MOV			AX,SHIP1ROW
					ADD			AX,29
					MOV			WORD PTR BULLETROW[SI],AX
					MOV			AX,SHIP1COLDRF
					ADD			AX,9
					MOV			WORD PTR BULLETCOL[SI],AX
					DEC			BULLCOUNTS1
					JMP			EXITCREATEBULL1		


SKIPBULLADD1:		ADD			SI,2
					CMP			SI,MAXBULLETS
					JBE			BULLARRAYLOOP1
EXITCREATEBULL1:	RET
CREATEBULLETSHIP1	ENDP
;-------------------------------------------------------------------------------------------------------------------------
;look in CREATEBULLETSHIP1 for comments
CREATEBULLETSHIP2	PROC      NEAR
					CMP			BULLCOUNTS2,0
					JBE			EXITCREATEBULL2
					MOV			SI,0
BULLARRAYLOOP2:		CMP			BULLETFREE[SI],0
					JNE			SKIPBULLADD2
					MOV			WORD PTR BULLETFREE[SI],1
					MOV			WORD PTR BULLETST[SI],1
					MOV			AX,SHIP2ROW
					ADD			AX,29
					MOV			WORD PTR BULLETROW[SI],AX
					MOV			AX,SHIP2COLDR
					SUB			AX,9
					MOV			WORD PTR BULLETCOL[SI],AX
					DEC			BULLCOUNTS2
					JMP			EXITCREATEBULL2		


SKIPBULLADD2:		ADD			SI,2
					CMP			SI,MAXBULLETS
					JBE			BULLARRAYLOOP2
EXITCREATEBULL2:	RET
CREATEBULLETSHIP2	ENDP
;-------------------------------------------------------------------------------------------------------------------------
DRAWBULLETS			PROC      NEAR
					MOV			SI,0
DRAWBULLETSLOOP:	CMP			BULLETFREE[SI],1
					JNE			SKIPDRAWBULLETS
					CALL		DRAWBULLET										
SKIPDRAWBULLETS:    ADD			SI,2
					CMP			SI,100
					JBE			DRAWBULLETSLOOP					
					RET
DRAWBULLETS			ENDP
;-------------------------------------------------------------------------------------------------------------------------
DRAWBULLET			PROC      NEAR
					MOV			AX,WORD PTR BULLETCOL[SI]
					ADD			AX,4
					MOV			DI,WORD PTR BULLETROW[SI]
					ADD			DI,4
					MOV			DX,WORD PTR BULLETROW[SI]
DRAWBULLETOUT:		MOV			CX,WORD PTR BULLETCOL[SI]
DRAWBULLETIN:		PUSH		AX
					MOV			AL,4
					MOV			BH,00H
					MOV			AH,0CH
					INT			10H
					INC			CX
					POP			AX
					CMP			CX,AX
					JBE			DRAWBULLETIN
					INC			DX
					CMP			DX,DI
					JBE			DRAWBULLETOUT
					RET
DRAWBULLET			ENDP
;-------------------------------------------------------------------------------------------------------------------------
CLEARBULLETR		PROC      NEAR
					MOV			AX,WORD PTR BULLETCOL[SI]
					SUB			AX,6
					MOV			DI,WORD PTR BULLETROW[SI]
					ADD			DI,4
					MOV			DX,WORD PTR BULLETROW[SI]
CLEARBULLETOUTR:	MOV			CX,WORD PTR BULLETCOL[SI]
					SUB			CX,10
CLEARBULLETINR:		PUSH		AX
					MOV			AL,0BH
					MOV			AH,0CH
					INT			10H
					INC			CX
					POP			AX
					CMP			CX,AX
					JBE			CLEARBULLETINR
					INC			DX
					CMP			DX,DI
					JBE			CLEARBULLETOUTR
					RET
CLEARBULLETR		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CLEARBULLETL		PROC      NEAR
					MOV			AX,WORD PTR BULLETCOL[SI]
					ADD			AX,14
					MOV			DI,WORD PTR BULLETROW[SI]
					ADD			DI,4
					MOV			DX,WORD PTR BULLETROW[SI]
CLEARBULLETOUTL:	MOV			CX,WORD PTR BULLETCOL[SI]
					ADD			CX,10
CLEARBULLETINL:		PUSH		AX
					MOV			AL,0BH
					MOV			AH,0CH
					INT			10H
					INC			CX
					POP			AX
					CMP			CX,AX
					JBE			CLEARBULLETINL
					INC			DX
					CMP			DX,DI
					JBE			CLEARBULLETOUTL
					RET
CLEARBULLETL		ENDP
;-------------------------------------------------------------------------------------------------------------------------
UPDATEBULLETS		PROC      NEAR
					MOV			SI,0
UPDATEBULLETSLOOP:	CMP			WORD PTR BULLETFREE[SI],1
					JNE			SKIPUPDATEBULL
					CMP			WORD PTR BULLETST[SI],0
					JNE			UPDATEBULLLEFT	
					ADD			WORD PTR BULLETCOL[SI],10
					CALL		CLEARBULLETR
					JMP			SKIPUPDATEBULL					
UPDATEBULLLEFT:		SUB			WORD PTR BULLETCOL[SI],10	
					CALL		CLEARBULLETL				
SKIPUPDATEBULL:		ADD			SI,2
					CMP			SI,100
					JBE			UPDATEBULLETSLOOP

					RET
UPDATEBULLETS		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CREATEMINES			PROC	NEAR
					MOV		AX,WORD PTR MASTERCLOCK
					MOV		AH,00
					MOV		DL,50
					DIV 	DL
					CMP		AH,0
					JNE		ENDCREATEMINES
					MOV		DL,2
					MOV		AH,00
					DIV		DL
					CMP		AH,0
					JE		EVENMINESLOT
					JNE		ODDMINESLOT
EVENMINESLOT:		MOV		AX,BARRIERROW[0]
					MOV		AH,00
					MOV		DL,2
					DIV		DL
					CMP		AH,1
					JE		LMINESLOTE
					JNE		RMINESLOTE
LMINESLOTE:			CALL	CREATEMINES1L
					JMP		ENDCREATEMINES
RMINESLOTE:			CALL	CREATEMINES1R
					JMP		ENDCREATEMINES
ODDMINESLOT:		MOV		AX,BARRIERROW[10]
					MOV		AH,00
					MOV		DL,2
					DIV		DL
					CMP		AH,1
					JE		LMINESLOTO
					JNE		RMINESLOTO
LMINESLOTO:			CALL	CREATEMINES2L
					JMP		ENDCREATEMINES
RMINESLOTO:			CALL	CREATEMINES2R
					JMP		ENDCREATEMINES
ENDCREATEMINES:		RET
CREATEMINES			ENDP
;-------------------------------------------------------------------------------------------------------------------------
CREATEMINES2		PROC	NEAR
					MOV		AX,WORD PTR MASTERCLOCK
					MOV		AH,00
					MOV		DL,50
					DIV 	DL
					CMP		AH,1
					JNE		ENDCREATEMINES
					MOV		DL,2
					MOV		AH,00
					DIV		DL
					CMP		AH,1
					JE		EVENMINESLOT2
					JNE		ODDMINESLOT2
EVENMINESLOT2:		MOV		AX,BARRIERROW[10]
					MOV		AH,00
					MOV		DL,2
					DIV		DL
					CMP		AH,1
					JE		LMINESLOTE2
					JNE		RMINESLOTE2
LMINESLOTE2:		CALL	CREATEMINES1L
					JMP		ENDCREATEMINES
RMINESLOTE2:		CALL	CREATEMINES1R
					JMP		ENDCREATEMINES
ODDMINESLOT2:		MOV		AX,BARRIERROW[0]
					MOV		AH,00
					MOV		DL,2
					DIV		DL
					CMP		AH,0
					JE		LMINESLOTO2
					JNE		RMINESLOTO2
LMINESLOTO2:		CALL	CREATEMINES2L
					JMP		ENDCREATEMINES
RMINESLOTO2:		CALL	CREATEMINES2R
					JMP		ENDCREATEMINES2
ENDCREATEMINES2:		RET
CREATEMINES2		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CREATEMINES1L		PROC	NEAR
					MOV			SI,0
CREATEMINELOOP1L:	CMP			MINEFREE[SI],0
					JNE			SKIPMINEADD1L
					MOV			WORD PTR MINEFREE[SI],1
					MOV			WORD PTR MINECOL[SI],50
					MOV			WORD PTR MINEROW[SI],30
					MOV			WORD PTR MINESTCOL[SI],0
					MOV			WORD PTR MINESTSHR[SI],0
					JMP			EXITCREATEMINE1L

SKIPMINEADD1L:		ADD			SI,2
					CMP			SI,10
					JBE			CREATEMINELOOP1L
EXITCREATEMINE1L:	RET
CREATEMINES1L		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CREATEMINES2L		PROC	NEAR
					MOV			SI,0
CREATEMINELOOP2L:	CMP			MINEFREE[SI],0
					JNE			SKIPMINEADD2L
					MOV			WORD PTR MINEFREE[SI],1
					MOV			WORD PTR MINECOL[SI],572
					MOV			WORD PTR MINEROW[SI],30
					MOV			WORD PTR MINESTCOL[SI],0
					MOV			WORD PTR MINESTSHR[SI],1
					JMP			EXITCREATEMINE2L

SKIPMINEADD2L:		ADD			SI,2
					CMP			SI,10
					JBE			CREATEMINELOOP2L
EXITCREATEMINE2L:	RET
CREATEMINES2L		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CREATEMINES1R		PROC	NEAR
					MOV			SI,0
CREATEMINELOOP1R:	CMP			MINEFREE[SI],0
					JNE			SKIPMINEADD1R
					MOV			WORD PTR MINEFREE[SI],1
					MOV			WORD PTR MINECOL[SI],95
					MOV			WORD PTR MINEROW[SI],30
					MOV			WORD PTR MINESTCOL[SI],1
					MOV			WORD PTR MINESTSHR[SI],0
					JMP			EXITCREATEMINE1R

SKIPMINEADD1R:		ADD			SI,2
					CMP			SI,10
					JBE			CREATEMINELOOP1R
EXITCREATEMINE1R:	RET
CREATEMINES1R		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CREATEMINES2R		PROC	NEAR
					MOV			SI,0
CREATEMINELOOP2R:	CMP			MINEFREE[SI],0
					JNE			SKIPMINEADD2R
					MOV			WORD PTR MINEFREE[SI],1
					MOV			WORD PTR MINECOL[SI],527
					MOV			WORD PTR MINEROW[SI],30
					MOV			WORD PTR MINESTCOL[SI],1
					MOV			WORD PTR MINESTSHR[SI],1
					JMP			EXITCREATEMINE2R

SKIPMINEADD2R:		ADD			SI,2
					CMP			SI,10
					JBE			CREATEMINELOOP2R
EXITCREATEMINE2R:	RET
CREATEMINES2R		ENDP
;-------------------------------------------------------------------------------------------------------------------------
DRAWMINES			PROC      NEAR
					MOV			SI,0
DRAWMINESLOOP:		CMP			MINEFREE[SI],1
					JNE			SKIPDRAWMINES
					CALL		DRAWMINE										
SKIPDRAWMINES:   	
					ADD			SI,2
					CMP			SI,10
					JBE			DRAWMINESLOOP					
					RET
DRAWMINES			ENDP
;-------------------------------------------------------------------------------------------------------------------------
DRAWMINE			PROC      NEAR
					MOV			DI,0
					MOV			AX,WORD PTR MINECOL[SI]
					ADD			AX,18
					MOV			BP,WORD PTR MINEROW[SI]
					ADD			BP,18
					MOV			DX,WORD PTR MINEROW[SI]
DRAWMINEOUT:		MOV			CX,WORD PTR MINECOL[SI]
DRAWMINEIN:			PUSH		AX
					MOV			AL,MINEATTR[DI]
					MOV			BH,00H
					MOV			AH,0CH
					INT			10H
					INC			CX
					INC			DI
					POP			AX
					CMP			CX,AX
					JBE			DRAWMINEIN
					INC			DX
					CMP			DX,BP
					JBE			DRAWMINEOUT
					RET
DRAWMINE			ENDP
;-------------------------------------------------------------------------------------------------------------------------
CLEARMINE			PROC      NEAR
					MOV			AX,WORD PTR MINECOL[SI]
					ADD			AX,18
					MOV			DI,WORD PTR MINEROW[SI]
					ADD			DI,18
					MOV			DX,WORD PTR MINEROW[SI]
CLEARMINEOUT:		MOV			CX,WORD PTR MINECOL[SI]
CLEARMINEIN:		PUSH		AX
					MOV			AL,0BH
					MOV			BH,00H
					MOV			AH,0CH
					INT			10H
					INC			CX
					POP			AX
					CMP			CX,AX
					JBE			CLEARMINEIN
					INC			DX
					CMP			DX,DI
					JBE			CLEARMINEOUT
					RET
CLEARMINE			ENDP
;-------------------------------------------------------------------------------------------------------------------------
UPDATEMINES		PROC      NEAR
					MOV			SI,0
UPDATEMINESLOOP:	CMP			WORD PTR MINEFREE[SI],1
					JNE			SKIPUPDATEMINE
					CALL		CLEARMINE
					ADD			MINEROW[SI],3
					CALL		DRAWMINE
					CMP			MINEROW[SI],365
					JB			SKIPUPDATEMINE
					CALL		CLEARMINE
					MOV			MINEFREE[SI],0
SKIPUPDATEMINE:		ADD			SI,2
					CMP			SI,10
					JBE			UPDATEMINESLOOP

					RET
UPDATEMINES		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CHECKCOLLISIONS		PROC      NEAR
					CALL		CHECKEDGECOLL
					CALL		CHECKBARCOLL
					CALL		CHECKSHIPSCOLL
					RET
CHECKCOLLISIONS		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CHECKMINESCOLL		PROC	 NEAR
					MOV			SI,0
MINECHECKCOLLLOOP:	CMP			MINEFREE[SI],0
					JE			SKIPCHECKMINE
					CMP			MINESTSHR[SI],0
					JNE			SHIP2MINECOLL
					CALL		CHECKSHIP1MINECOLL
					JMP			SKIPCHECKMINE
SHIP2MINECOLL:		CALL		CHECKSHIP2MINECOLL
SKIPCHECKMINE:		ADD			SI,2
					CMP			SI,10
					JBE			MINECHECKCOLLLOOP
					RET
CHECKMINESCOLL		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CHECKSHIP1MINECOLL		PROC	  NEAR
					MOV			AX,MINESTCOL[SI]
					CMP			SHIP1COLST,AX
					JNE			EXITSHIP1MCOLCHECK
					MOV			AX,MINEROW[SI]
					ADD			AX,18
					CMP			SHIP1ROW,AX
					JA			EXITSHIP1MCOLCHECK
					MOV			AX,MINEROW[SI]
					CMP			SHIP1ROWF,AX
					JB			EXITSHIP1MCOLCHECK
					DEC			SHIP1SCORE
					MOV			MINEFREE[SI],0
					CALL		CLEARMINE

EXITSHIP1MCOLCHECK:	RET
CHECKSHIP1MINECOLL		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CHECKSHIP2MINECOLL		PROC	  NEAR
					MOV			AX,MINESTCOL[SI]
					CMP			SHIP2COLST,AX
					JNE			EXITSHIP2MCOLCHECK
					MOV			AX,MINEROW[SI]
					ADD			AX,18
					CMP			SHIP2ROW,AX
					JA			EXITSHIP2MCOLCHECK
					MOV			AX,MINEROW[SI]
					CMP			SHIP2ROWF,AX
					JB			EXITSHIP2MCOLCHECK
					DEC			SHIP2SCORE
					MOV			MINEFREE[SI],0
					CALL		CLEARMINE

EXITSHIP2MCOLCHECK:	RET
CHECKSHIP2MINECOLL		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CHECKEDGECOLL		PROC      NEAR
					MOV			SI,0
CHECKEDGECOLLLOOP:	CMP			BULLETFREE[SI],1
					JNE			SKIPCHECKEDGE	
					CMP			BULLETCOL[SI],30
					JBE			FREEBULLETEDGE
					CMP			BULLETCOL[SI],600
					JAE			FREEBULLETEDGE
					JMP			SKIPCHECKEDGE	
FREEBULLETEDGE:		MOV			BULLETFREE[SI],0
SKIPCHECKEDGE:		ADD			SI,2
					CMP			SI,100
					JBE			CHECKEDGECOLLLOOP
					RET
CHECKEDGECOLL		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CHECKBARCOLL		PROC      NEAR
					MOV			SI,0
CHECKBARCOLLLOOP:	CMP			BULLETFREE[SI],1
					JNE			SKIPCHECKBAR
					CMP			BULLETST[SI],1
					JNE			CHECKBULLCOLLR
					CALL		CHECKBARCOLLLEFT
					JMP			SKIPCHECKBAR
CHECKBULLCOLLR:		CALL		CHECKBARCOLLRIGHT			
SKIPCHECKBAR:		ADD			SI,2
					CMP			SI,100
					JBE			CHECKBARCOLLLOOP
					RET
CHECKBARCOLL		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CHECKBARCOLLLEFT	PROC      NEAR
					CMP			BARRIERST[10],1
					JE			BAR5CHECKL
					CMP			WORD PTR BULLETCOL[SI],448
					JBE			BAR6RANGECHECKL
					JMP			BAR5CHECKL
BAR6RANGECHECKL:	CMP			WORD PTR BULLETCOL[SI],428
					JB			BAR5CHECKL
					CALL		COLLISIONBAR6L
					
BAR5CHECKL:			CMP			BARRIERST[8],1
					JE			BAR4CHECKL
					CMP			WORD PTR BULLETCOL[SI],403
					JBE			BAR5RANGECHECKL
					JMP			BAR4CHECKL
BAR5RANGECHECKL:	CMP			WORD PTR BULLETCOL[SI],383
					JB  		BAR4CHECKL
					CALL		COLLISIONBAR5L
					
										
BAR4CHECKL:			CMP			BARRIERST[6],1
					JE			BAR3CHECKL
					CMP			WORD PTR BULLETCOL[SI],358
					JBE			BAR4RANGECHECKL
					JMP			BAR3CHECKL
BAR4RANGECHECKL:	CMP			WORD PTR BULLETCOL[SI],338
					JB			BAR3CHECKL
					CALL		COLLISIONBAR4L
					
										
BAR3CHECKL:			CMP			BARRIERST[4],1
					JE			BAR2CHECKL
					CMP			WORD PTR BULLETCOL[SI],313
					JBE			BAR3RANGECHECKL
					JMP			BAR2CHECKL
BAR3RANGECHECKL:	CMP			WORD PTR BULLETCOL[SI],293
					JB 			BAR2CHECKL
					CALL		COLLISIONBAR3L
					
										
BAR2CHECKL:			CMP			BARRIERST[2],1
					JE			BAR1CHECKL
					CMP			WORD PTR BULLETCOL[SI],268
					JBE			BAR2RANGECHECKL
					JMP			BAR1CHECKL
BAR2RANGECHECKL:	CMP			WORD PTR BULLETCOL[SI],248
					JB			BAR1CHECKL
					CALL		COLLISIONBAR2L
					
										
BAR1CHECKL:			CMP			BARRIERST[0],1
					JE			EXITBARCOLLLEFT
					CMP			WORD PTR BULLETCOL[SI],223
					JBE			BAR1RANGECHECKL
					JMP			EXITBARCOLLLEFT
BAR1RANGECHECKL:	CMP			WORD PTR BULLETCOL[SI],203
					JB			EXITBARCOLLLEFT
					CALL		COLLISIONBAR1L
					
EXITBARCOLLLEFT:	RET
CHECKBARCOLLLEFT	ENDP
;-------------------------------------------------------------------------------------------------------------------------					
COLLISIONBAR6L		PROC      NEAR		
					MOV			AX, WORD PTR BARRIERROW[10]
					SUB			AX,4	
					CMP			WORD PTR BULLETROW[SI],AX
					JAE			BAR6COLLRANGECHCKL
					JMP			EXITBAR6COLL
BAR6COLLRANGECHCKL:	MOV			AX, word ptr BARRIERENDR[10]
					CMP			WORD PTR BULLETROW[SI],AX
					JA  		EXITBAR6COLL
					MOV			BULLETFREE[SI],0
					MOV			AX,BULLETDAMAGE[SI]
					MOV			DX,BARRIERH[10]
					SUB			DX,AX
					CMP			DX,0
					JLE			CHANGEBARST6L
					MOV			BARRIERH[10],DX
					JMP			EXITBAR6COLL
CHANGEBARST6L:		MOV			BARRIERST[10],1
					MOV			BARRIERH[10],3
					MOV			BARRIERTI[10],100
EXITBAR6COLL:		RET
COLLISIONBAR6L		ENDP
;-------------------------------------------------------------------------------------------------------------------------
COLLISIONBAR5L		PROC      NEAR		
					MOV			AX,BARRIERROW[8]
					SUB			AX,4	
					CMP			WORD PTR BULLETROW[SI],AX
					JAE			BAR5COLLRANGECHCKL
					JMP			EXITBAR5COLL
BAR5COLLRANGECHCKL:	MOV			AX,BARRIERENDR[8]
					CMP			WORD PTR BULLETROW[SI],AX
					JA 			EXITBAR5COLL
					MOV			BULLETFREE[SI],0
					MOV			AX,BULLETDAMAGE[SI]
					MOV			DX,BARRIERH[8]
					SUB			DX,AX
					CMP			DX,0
					JLE			CHANGEBARST5L
					MOV			BARRIERH[8],DX
					JMP			EXITBAR5COLL
CHANGEBARST5L:		MOV			BARRIERST[8],1
					MOV			BARRIERH[8],3
					MOV			BARRIERTI[8],100
EXITBAR5COLL:		RET
COLLISIONBAR5L		ENDP
;-------------------------------------------------------------------------------------------------------------------------
COLLISIONBAR4L		PROC      NEAR		
					MOV			AX,BARRIERROW[6]
					SUB			AX,4	
					CMP			WORD PTR BULLETROW[SI],AX
					JAE			BAR4COLLRANGECHCKL
					JMP			EXITBAR4COLL
BAR4COLLRANGECHCKL:	MOV			AX,BARRIERENDR[6]
					CMP			WORD PTR BULLETROW[SI],AX
					JA 			EXITBAR4COLL
					MOV			BULLETFREE[SI],0
					MOV			AX,BULLETDAMAGE[SI]
					MOV			DX,BARRIERH[6]
					SUB			DX,AX
					CMP			DX,0
					JLE			CHANGEBARST4L
					MOV			BARRIERH[6],DX
					JMP			EXITBAR4COLL
CHANGEBARST4L:		MOV			BARRIERST[6],1	
					MOV			BARRIERH[6],3
					MOV			BARRIERTI[6],100
EXITBAR4COLL:		RET
COLLISIONBAR4L		ENDP
;-------------------------------------------------------------------------------------------------------------------------
COLLISIONBAR3L		PROC      NEAR		
					MOV			AX,BARRIERROW[4]
					SUB			AX,4	
					CMP			WORD PTR BULLETROW[SI],AX
					JAE			BAR3COLLRANGECHCKL
					JMP			EXITBAR3COLL
BAR3COLLRANGECHCKL:	MOV			AX,BARRIERENDR[4]
					CMP			WORD PTR BULLETROW[SI],AX
					JA 			EXITBAR3COLL
					MOV			BULLETFREE[SI],0
					MOV			AX,BULLETDAMAGE[SI]
					MOV			DX,BARRIERH[4]
					SUB			DX,AX
					CMP			DX,0
					JLE			CHANGEBARST3L
					MOV			BARRIERH[4],DX
					JMP			EXITBAR3COLL
CHANGEBARST3L:		MOV			BARRIERST[4],1
					MOV			BARRIERH[4],3
					MOV			BARRIERTI[4],100
EXITBAR3COLL:		RET
COLLISIONBAR3L		ENDP
;-------------------------------------------------------------------------------------------------------------------------
COLLISIONBAR2L		PROC      NEAR		
					MOV			AX,BARRIERROW[2]
					SUB			AX,4	
					CMP			WORD PTR BULLETROW[SI],AX
					JAE			BAR2COLLRANGECHCKL
					JMP			EXITBAR2COLL
BAR2COLLRANGECHCKL:	MOV			AX,BARRIERENDR[2]
					CMP			WORD PTR BULLETROW[SI],AX
					JA 			EXITBAR2COLL
					MOV			BULLETFREE[SI],0
					MOV			AX,BULLETDAMAGE[SI]
					MOV			DX,BARRIERH[2]
					SUB			DX,AX
					CMP			DX,0
					JLE			CHANGEBARST2L
					MOV			BARRIERH[2],DX
					JMP			EXITBAR2COLL
CHANGEBARST2L:		MOV			BARRIERST[2],1
					MOV			BARRIERH[2],3	
					MOV			BARRIERTI[2],100
EXITBAR2COLL:		RET
COLLISIONBAR2L		ENDP

;-------------------------------------------------------------------------------------------------------------------------
COLLISIONBAR1L		PROC      NEAR		
					MOV			AX,BARRIERROW[0]
					SUB			AX,4	
					CMP			WORD PTR BULLETROW[SI],AX
					JAE			BAR1COLLRANGECHCKL
					JMP			EXITBAR1COLL
BAR1COLLRANGECHCKL:	MOV			AX,BARRIERENDR[0]
					CMP			WORD PTR BULLETROW[SI],AX
					JA 			EXITBAR1COLL
					MOV			BULLETFREE[SI],0
					MOV			AX,BULLETDAMAGE[SI]
					MOV			DX,BARRIERH[0]
					SUB			DX,AX
					CMP			DX,0
					JLE			CHANGEBARST1L
					MOV			BARRIERH[0],DX
					JMP			EXITBAR1COLL
CHANGEBARST1L:		MOV			BARRIERST[0],1
					MOV			BARRIERH[0],3
					MOV			BARRIERTI[0],100
EXITBAR1COLL:		RET
COLLISIONBAR1L		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CHECKBARCOLLRIGHT	PROC      NEAR
					CMP			BARRIERST[0],1
					JE			BAR2CHECKR
					CMP			WORD PTR BULLETCOL[SI],203
					JAE			BAR1RANGECHECKR
					JMP			BAR2CHECKR
BAR1RANGECHECKR:	CMP			WORD PTR BULLETCOL[SI],223
					JA			BAR2CHECKR
					CALL		COLLISIONBAR1R
					
BAR2CHECKR:			CMP			BARRIERST[2],1
					JE			BAR3CHECKR
					CMP			WORD PTR BULLETCOL[SI],248
					JAE			BAR2RANGECHECKR
					JMP			BAR3CHECKR
BAR2RANGECHECKR:	CMP			WORD PTR BULLETCOL[SI],268
					JA  		BAR3CHECKR
					CALL		COLLISIONBAR2R
					
										
BAR3CHECKR:			CMP			BARRIERST[4],1
					JE			BAR4CHECKR
					CMP			WORD PTR BULLETCOL[SI],293
					JAE			BAR3RANGECHECKR
					JMP			BAR4CHECKR
BAR3RANGECHECKR:	CMP			WORD PTR BULLETCOL[SI],313
					JA			BAR4CHECKR
					CALL		COLLISIONBAR3R
					
										
BAR4CHECKR:			CMP			BARRIERST[6],1
					JE			BAR5CHECKR
					CMP			WORD PTR BULLETCOL[SI],338
					JAE			BAR4RANGECHECKR
					JMP			BAR5CHECKR
BAR4RANGECHECKR:	CMP			WORD PTR BULLETCOL[SI],358
					JA			BAR5CHECKR
					CALL		COLLISIONBAR4R
					
										
BAR5CHECKR:			CMP			BARRIERST[8],1
					JE			BAR6CHECKR
					CMP			WORD PTR BULLETCOL[SI],383
					JAE			BAR5RANGECHECKR
					JMP			BAR6CHECKR
BAR5RANGECHECKR:	CMP			WORD PTR BULLETCOL[SI],403
					JA			BAR6CHECKR
					CALL		COLLISIONBAR5R
					
										
BAR6CHECKR:			CMP			BARRIERST[10],1
					JE			EXITBARCOLLRIGHT
					CMP			WORD PTR BULLETCOL[SI],428
					JAE			BAR6RANGECHECKR
					JMP			EXITBARCOLLRIGHT
BAR6RANGECHECKR:	CMP			WORD PTR BULLETCOL[SI],448
					JA			EXITBARCOLLRIGHT
					CALL		COLLISIONBAR6R
					
EXITBARCOLLRIGHT:	RET
CHECKBARCOLLRIGHT	ENDP
;-------------------------------------------------------------------------------------------------------------------------					
COLLISIONBAR6R		PROC      NEAR		
					MOV			AX, WORD PTR BARRIERROW[10]
					SUB			AX,4	
					CMP			WORD PTR BULLETROW[SI],AX
					JAE			BAR6COLLRANGECHCKR
					JMP			EXITBAR6COLR
BAR6COLLRANGECHCKR:	MOV			AX, word ptr BARRIERENDR[10]
					CMP			WORD PTR BULLETROW[SI],AX
					JA  		EXITBAR6COLR
					MOV			BULLETFREE[SI],0
					MOV			AX,BULLETDAMAGE[SI]
					MOV			DX,BARRIERH[10]
					SUB			DX,AX
					CMP			DX,0
					JLE			CHANGEBARST6R
					MOV			BARRIERH[10],DX
					JMP			EXITBAR6COLR
CHANGEBARST6R:		MOV			BARRIERST[10],1
					MOV			BARRIERH[10],3	
					MOV			BARRIERTI[10],100
EXITBAR6COLR:		RET
COLLISIONBAR6R		ENDP
;-------------------------------------------------------------------------------------------------------------------------
COLLISIONBAR5R		PROC      NEAR		
					MOV			AX,BARRIERROW[8]
					SUB			AX,4	
					CMP			WORD PTR BULLETROW[SI],AX
					JAE			BAR5COLLRANGECHCKR
					JMP			EXITBAR5COLR
BAR5COLLRANGECHCKR:	MOV			AX,BARRIERENDR[8]
					CMP			WORD PTR BULLETROW[SI],AX
					JA 			EXITBAR5COLR
					MOV			BULLETFREE[SI],0
					MOV			AX,BULLETDAMAGE[SI]
					MOV			DX,BARRIERH[8]
					SUB			DX,AX
					CMP			DX,0
					JLE			CHANGEBARST5R
					MOV			BARRIERH[8],DX
					JMP			EXITBAR5COLR
CHANGEBARST5R:		MOV			BARRIERST[8],1
					MOV			BARRIERH[8],3	
					MOV			BARRIERTI[8],100
EXITBAR5COLR:		RET
COLLISIONBAR5R		ENDP
;-------------------------------------------------------------------------------------------------------------------------
COLLISIONBAR4R		PROC      NEAR		
					MOV			AX,BARRIERROW[6]
					SUB			AX,4	
					CMP			WORD PTR BULLETROW[SI],AX
					JAE			BAR4COLLRANGECHCKR
					JMP			EXITBAR4COLR
BAR4COLLRANGECHCKR:	MOV			AX,BARRIERENDR[6]
					CMP			WORD PTR BULLETROW[SI],AX
					JA 			EXITBAR4COLR
					MOV			BULLETFREE[SI],0
					MOV			AX,BULLETDAMAGE[SI]
					MOV			DX,BARRIERH[6]
					SUB			DX,AX
					CMP			DX,0
					JLE			CHANGEBARST4R
					MOV			BARRIERH[6],DX
					JMP			EXITBAR4COLR
CHANGEBARST4R:		MOV			BARRIERST[6],1
					MOV			BARRIERH[6],3	
					MOV			BARRIERTI[6],100
					
EXITBAR4COLR:		RET
COLLISIONBAR4R		ENDP
;-------------------------------------------------------------------------------------------------------------------------
COLLISIONBAR3R		PROC      NEAR		
					MOV			AX,BARRIERROW[4]
					SUB			AX,4	
					CMP			WORD PTR BULLETROW[SI],AX
					JAE			BAR3COLLRANGECHCKR
					JMP			EXITBAR3COLR
BAR3COLLRANGECHCKR:	MOV			AX,BARRIERENDR[4]
					CMP			WORD PTR BULLETROW[SI],AX
					JA 			EXITBAR3COLR
					MOV			BULLETFREE[SI],0
					MOV			AX,BULLETDAMAGE[SI]
					MOV			DX,BARRIERH[4]
					SUB			DX,AX
					CMP			DX,0
					JLE			CHANGEBARST3R
					MOV			BARRIERH[4],DX
					JMP			EXITBAR3COLR
CHANGEBARST3R:		MOV			BARRIERST[4],1
					MOV			BARRIERH[4],3	
					MOV			BARRIERTI[4],100
EXITBAR3COLR:		RET
COLLISIONBAR3R		ENDP
;-------------------------------------------------------------------------------------------------------------------------
COLLISIONBAR2R		PROC      NEAR		
					MOV			AX,BARRIERROW[2]
					SUB			AX,4	
					CMP			WORD PTR BULLETROW[SI],AX
					JAE			BAR2COLLRANGECHCKR
					JMP			EXITBAR2COLR
BAR2COLLRANGECHCKR:	MOV			AX,BARRIERENDR[2]
					CMP			WORD PTR BULLETROW[SI],AX
					JA 			EXITBAR2COLR
					MOV			BULLETFREE[SI],0
					MOV			AX,BULLETDAMAGE[SI]
					MOV			DX,BARRIERH[2]
					SUB			DX,AX
					CMP			DX,0
					JLE			CHANGEBARST2R
					MOV			BARRIERH[2],DX
					JMP			EXITBAR2COLR
CHANGEBARST2R:		MOV			BARRIERST[2],1
					MOV			BARRIERH[2],3	
					MOV			BARRIERTI[2],100
EXITBAR2COLR:		RET
COLLISIONBAR2R		ENDP

;-------------------------------------------------------------------------------------------------------------------------
COLLISIONBAR1R		PROC      NEAR		
					MOV			AX,BARRIERROW[0]
					SUB			AX,4	
					CMP			WORD PTR BULLETROW[SI],AX
					JAE			BAR1COLLRANGECHCKR
					JMP			EXITBAR1COLR
BAR1COLLRANGECHCKR:	MOV			AX,BARRIERENDR[0]
					CMP			WORD PTR BULLETROW[SI],AX
					JA 			EXITBAR1COLR
					MOV			BULLETFREE[SI],0
					MOV			AX,BULLETDAMAGE[SI]
					MOV			DX,BARRIERH[0]
					SUB			DX,AX
					CMP			DX,0
					JLE			CHANGEBARST1R
					MOV			BARRIERH[0],DX
					JMP			EXITBAR1COLR
CHANGEBARST1R:		MOV			BARRIERST[0],1
					MOV			BARRIERH[0],3	
					MOV			BARRIERTI[0],100
EXITBAR1COLR:		RET
COLLISIONBAR1R		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CHECKSHIPSCOLL		PROC      NEAR
					MOV			SI,0
CHECKSHIPCOLLLOOP:	CMP			WORD PTR  BULLETFREE[SI],1
					JNE			SKIPCHECKSHIPCOLL
					CMP			WORD PTR  BULLETST[SI],0
					JNE			SHIP1COLLCHECK			
					CALL		CHECKSHIP2COLL
					JMP			SKIPCHECKSHIPCOLL
			
			
SHIP1COLLCHECK:		CALL		CHECKSHIP1COLL

SKIPCHECKSHIPCOLL:	ADD			SI,2
					CMP			SI,100
					JBE			CHECKSHIPCOLLLOOP	
					RET
CHECKSHIPSCOLL		ENDP

;-------------------------------------------------------------------------------------------------------------------------
CHECKSHIP2COLL		PROC      NEAR
					MOV			AX,SHIP2COLDR
					CMP			WORD PTR  BULLETCOL[SI],AX
					JB			EXITCHECKSHIP2COLL
					MOV			DX,SHIP2ROW
					CMP			WORD PTR  BULLETROW[SI],DX
					JB			EXITCHECKSHIP2COLL
					MOV			DX,SHIP2ROWF
					CMP			WORD PTR  BULLETROW[SI],DX
					JA			EXITCHECKSHIP2COLL
					MOV			WORD PTR  BULLETFREE[SI],0
					DEC			SHIP2SCORE
EXITCHECKSHIP2COLL:	RET
CHECKSHIP2COLL		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CHECKSHIP1COLL		PROC      NEAR
					MOV			AX,SHIP1COLDRF
					CMP			WORD PTR  BULLETCOL[SI],AX
					JA			EXITCHECKSHIP1COLL
					MOV			DI,SHIP1ROW
					CMP			WORD PTR  BULLETROW[SI],DI
					JB			EXITCHECKSHIP1COLL
					MOV			DI,SHIP1ROWF
					CMP			WORD PTR  BULLETROW[SI],DI
					JA			EXITCHECKSHIP1COLL
					MOV			WORD PTR  BULLETFREE[SI],0
					DEC			SHIP1SCORE
EXITCHECKSHIP1COLL:	RET
CHECKSHIP1COLL		ENDP
;-------------------------------------------------------------------------------------------------------------------------
GETACTIONM			PROC      NEAR
					
					
					CMP			[MYKBUF + 48H],1
					JNE			NEXTCMP1
					CALL		MOVESHIP1UP
					;JMP			EXITGETKEYINMAIN
NEXTCMP1:			CMP			[MYKBUF + 50H],1
					JNE			NEXTCMP2
					CALL		MOVESHIP1DOWN

NEXTCMP2:			CMP			[MYKBUF + 39H],1
					JNE			NEXTCMPR1
					CALL		CREATEBULLETSHIP1
					
NEXTCMPR1:			CMP			[RECKBUF],1
					JNE			NEXTCMPR2
					CALL		MOVESHIP2UP
					
NEXTCMPR2:			CMP			[RECKBUF+1],1
					JNE			NEXTCMPR3
					CALL		MOVESHIP2DOWN
					
NEXTCMPR3:			CMP			[RECKBUF+2],1
					JNE			CHECKLVL2
					CALL		CREATEBULLETSHIP2
					
CHECKLVL2:			CMP			LEVELSTF,0
					JE			NEXTCMP10
					
					
					CMP			[MYKBUF + 4DH],1
					JNE			NEXTCMP7
					CALL		MOVESHIP1AWAY

NEXTCMP7:			CMP			[MYKBUF + 4BH],1
					JNE			NEXTCMPR5
					CALL		MOVESHIP1HOME
					

					
NEXTCMPR5:			CMP			[RECKBUF+3],1
					JNE			NEXTCMPR4
					CALL		MOVESHIP2AWAY
					
NEXTCMPR4:			CMP			[RECKBUF+4],1
					JNE			NEXTCMP10
					CALL		MOVESHIP2HOME
										

SKIPLEVEL2ACT:
NEXTCMP10:			CMP			[MYKBUF + 3EH],1
					JNE			EXITGETKEYINMAIN
					MOV			CLOSE,1

					
EXITGETKEYINMAIN:	
					
					CALL		CLEARKEYBOARDBUFFER
					RET
GETACTIONM			ENDP
;-------------------------------------------------------------------------------------------------------------------------
GETACTIONS			PROC      NEAR
					
					
					CMP			[MYKBUF + 48H],1
					JNE			NEXTCMP1S
					CALL		MOVESHIP2UP
					;JMP			EXITGETKEYINMAIN
NEXTCMP1S:			CMP			[MYKBUF + 50H],1
					JNE			NEXTCMP2S
					CALL		MOVESHIP2DOWN

NEXTCMP2S:			CMP			[MYKBUF + 39H],1
					JNE			NEXTCMPR1S
					CALL		CREATEBULLETSHIP2
					
NEXTCMPR1S:			CMP			[RECKBUF],1
					JNE			NEXTCMPR2S
					CALL		MOVESHIP1UP
					
NEXTCMPR2S:			CMP			[RECKBUF+1],1
					JNE			NEXTCMPR3S
					CALL		MOVESHIP1DOWN
					
NEXTCMPR3S:			CMP			[RECKBUF+2],1
					JNE			CHECKLVL2S
					CALL		CREATEBULLETSHIP1
					
CHECKLVL2S:			CMP			LEVELSTF,0
					JE			NEXTCMP10S
					
					
					CMP			[MYKBUF + 4DH],1
					JNE			NEXTCMP7S
					CALL		MOVESHIP2HOME

NEXTCMP7S:			CMP			[MYKBUF + 4BH],1
					JNE			NEXTCMPR5S
					CALL		MOVESHIP2AWAY
					

					
NEXTCMPR5S:			CMP			[RECKBUF+3],1
					JNE			NEXTCMPR4S
					CALL		MOVESHIP1HOME
					
NEXTCMPR4S:			CMP			[RECKBUF+4],1
					JNE			NEXTCMP10S
					CALL		MOVESHIP1AWAY
										

SKIPLEVEL2ACTS:
NEXTCMP10S:			CMP			[MYKBUF + 3EH],1
					JNE			EXITGETKEYINMAINS
					MOV			CLOSE,1

					
EXITGETKEYINMAINS:	
					
					CALL		CLEARKEYBOARDBUFFER
					RET
GETACTIONS			ENDP
;-------------------------------------------------------------------------------------------------------------------------
SAVEACTION			PROC		NEAR
;1 UP , 2 DOWN , 3 FIRE, 4 	LEFT, 5 RIGHT, 6 F3
					MOV			AL,MYKBUF[48H]
					MOV			SENDKBUFF,AL
					MOV			AL,MYKBUF[50H]
					MOV			SENDKBUFF[1],AL
					MOV			AL,MYKBUF[39H]
					MOV			SENDKBUFF[2],AL
					MOV			AL,MYKBUF[4BH]
					MOV			SENDKBUFF[3],AL
					MOV			AL,MYKBUF[4DH]
					MOV			SENDKBUFF[4],AL
					MOV			AL,MYKBUF[3DH]
					MOV			SENDKBUFF[5],AL	
					
EXITSAVEACTION:		RET
SAVEACTION			ENDP
;-------------------------------------------------------------------------------------------------------------------------
PREPAREXCHGM			PROC		NEAR
						MOV 		DX,3FDH							;send confirmation
WAITTILLEMPTYXCHGM:		IN			AL,DX
						AND			AL,00100000B
						JZ			WAITTILLEMPTYXCHGM
						MOV			DX,3F8H
						MOV			AL,1
						OUT			DX,AL
						
						MOV			DX,3FDH
WAITCONFIRMXCHGM:		IN			AL,DX
						XOR			AH,AH
						AND			AL,1
						JZ			WAITCONFIRMXCHGM						
						MOV			DX,3F8H
						IN			AL,DX
						CMP			AL,1
						
						CALL		EXCHANGEBUFFM
						
						RET
PREPAREXCHGM			ENDP
;-------------------------------------------------------------------------------------------------------------------------
PREPAREXCHGS			PROC		NEAR						
						
						MOV			DX,3FDH
WAITCONFIRMXCHGS:		IN			AL,DX
						XOR			AH,AH
						AND			AL,1
						JZ			WAITCONFIRMXCHGS						
						MOV			DX,3F8H
						IN			AL,DX
						CMP			AL,1
						
						MOV 		DX,3FDH							;send confirmation
WAITTILLEMPTYXCHGS:		IN			AL,DX
						AND			AL,00100000B
						JZ			WAITTILLEMPTYXCHGS
						MOV			DX,3F8H
						MOV			AL,1
						OUT			DX,AL
						
						CALL		EXCHANGEBUFFS
						
						RET
PREPAREXCHGS			ENDP
;-------------------------------------------------------------------------------------------------------------------------
EXCHANGEBUFFM		PROC		NEAR
					MOV 		DX,3FDH							;send key byte
WAITTILLEMPTYBUFFM:	IN			AL,DX
					AND			AL,00100000B
					JZ			WAITTILLEMPTYBUFFM
					MOV			DX,3F8H
					MOV			AL,SENDBYTE
					OUT			DX,AL
					
					MOV			DX,3FDH
WAITBUFFM:			IN			AL,DX
					XOR			AH,AH
					AND			AL,1
					JZ			WAITBUFFM						
					MOV			DX,3F8H
					IN			AL,DX
					
					MOV			RECBYTE,AL
			
					RET
EXCHANGEBUFFM		ENDP
;-------------------------------------------------------------------------------------------------------------------------
EXCHANGEBUFFS		PROC		NEAR

					MOV			DX,3FDH
WAITBUFFS:			IN			AL,DX
					XOR			AH,AH
					AND			AL,1
					JZ			WAITBUFFS						
					MOV			DX,3F8H
					IN			AL,DX
					MOV			RECBYTE,AL

					MOV 		DX,3FDH							;send key byte
WAITTILLEMPTYBUFFS:	IN			AL,DX
					AND			AL,00100000B
					JZ			WAITTILLEMPTYBUFFS
					MOV			DX,3F8H
					MOV			AL,SENDBYTE
					OUT			DX,AL
					
					
			
					RET
EXCHANGEBUFFS		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CONVERTBUFFTOB		PROC		NEAR
					XOR			AX,AX
					XOR			DX,DX
					MOV			DL,BYTE PTR SENDKBUFF[0]
					SHL			DL,1
					MOV			AL,BYTE PTR SENDKBUFF[1]
					OR			DL,AL
					SHL			DL,1
					MOV			AL,BYTE PTR SENDKBUFF[2]
					OR			DL,AL
					SHL			DL,1
					MOV			AL,BYTE PTR SENDKBUFF[3]
					OR			DL,AL
					SHL			DL,1
					MOV			AL,BYTE PTR SENDKBUFF[4]
					OR			DL,AL
					SHL			DL,1
					MOV			AL,BYTE PTR SENDKBUFF[5]
					OR			DL,AL
					MOV			SENDBYTE,DL

					RET
CONVERTBUFFTOB		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CONVERTBTOBUFF		PROC		NEAR
					MOV			DL,RECBYTE
					MOV			SI,5					
		
LOOPCONV:			SHR			DL,1
					JC			AONE
					MOV			RECKBUF[SI],0
					JMP			DECSI
AONE:				MOV			RECKBUF[SI],1
DECSI:				DEC			SI
					CMP			SI,0
					JGE			LOOPCONV
					
					RET
CONVERTBTOBUFF		ENDP
;-------------------------------------------------------------------------------------------------------------------------
DRAW1CAPTAINSCORE	PROC      NEAR
					MOV		SI,0
					MOV		DX,3
ANCHOROUTLOOP:		MOV		CX,7
					MOV		AH,0CH
ANCHORINLOOP:		MOV		AL,ANCHOR[SI]
					CMP 	AL,00
					JE		SKIPCAPTAIN
					MOV		AL,14
SKIPCAPTAIN:		INT		10H
					INC		CX
					INC		SI
					CMP		CX,30
					JBE		ANCHORINLOOP
					INC		DX
					CMP		DX,26
					JBE		ANCHOROUTLOOP
					RET
DRAW1CAPTAINSCORE	ENDP
;-------------------------------------------------------------------------------------------------------------------------
DRAW2CAPTAINSCORE	PROC      NEAR
					MOV		SI,0
					MOV		DX,3
ANCHOROUTLOOP3:		MOV		CX,609
					MOV		AH,0CH
ANCHORINLOOP3:		MOV		AL,ANCHOR[SI]
					CMP 	AL,00
					JE		SKIPCAPTAIN2
					MOV		AL,14
SKIPCAPTAIN2:		INT		10H
					INC		CX
					INC		SI
					CMP		CX,632
					JBE		ANCHORINLOOP3
					INC		DX
					CMP		DX,26
					JBE		ANCHOROUTLOOP3
					RET
DRAW2CAPTAINSCORE	ENDP
;-------------------------------------------------------------------------------------------------------------------------
DRAWANCHORS			PROC      NEAR

					MOV		SI,OFFSET ANCHOR
					MOV		DX,3
ANCHOROUTLOOP1:		MOV		CX,ANCHORSTART
					MOV		AH,0CH
ACHORINLOOP1:		MOV		AL,[SI]
					INT		10H
					INC		CX
					INC		SI
					CMP		CX,ANCHOREND
					JBE		ACHORINLOOP1
					INC		DX
					CMP		DX,26
					JBE		ANCHOROUTLOOP1
					
					RET
DRAWANCHORS			ENDP
;-------------------------------------------------------------------------------------------------------------------------
DRAWSCORESSHIP2		PROC      NEAR
					
					
					CALL	DRAW2CAPTAINSCORE
					
					MOV		ANCHORSTART,585
					MOV		ANCHOREND,608
					CALL	DRAWANCHORS
					
					
					MOV		ANCHORSTART,561
					MOV		ANCHOREND,584
					CALL	DRAWANCHORS
					
					
					MOV		ANCHORSTART,537
					MOV		ANCHOREND,560
					CALL	DRAWANCHORS
					
					
					

					RET
DRAWSCORESSHIP2		ENDP
;-------------------------------------------------------------------------------------------------------------------------
DRAWSCORESSHIP1		PROC      NEAR
					
					CALL	DRAW1CAPTAINSCORE
					MOV		ANCHORSTART,30
					MOV		ANCHOREND,53
					CALL	DRAWANCHORS
					
					
					MOV		ANCHORSTART,53
					MOV		ANCHOREND,76
					CALL	DRAWANCHORS
					
					
					MOV		ANCHORSTART,76
					MOV		ANCHOREND,99
					CALL	DRAWANCHORS
				
EXITDRAWSCORE1:		RET
DRAWSCORESSHIP1		ENDP
;-------------------------------------------------------------------------------------------------------------------------
CLEARANCHOR			PROC      NEAR
					MOV		DX,3
CLEAROUTLOOP1:		MOV		CX,ANCHORSTART
					MOV		AH,0CH
CLEARINLOOP1:		MOV		AL,00
					INT		10H
					INC		CX
					INC		SI
					CMP		CX,ANCHOREND
					JBE		CLEARINLOOP1
					INC		DX
					CMP		DX,26
					JBE		CLEAROUTLOOP1
					RET
					
CLEARANCHOR			ENDP
;-------------------------------------------------------------------------------------------------------------------------		
UPDATESCORESSHIP1	PROC      NEAR
					MOV		DI,SHIP1SCORE
					CMP		DI,5
					JAE		EXITUPDATESCORES1
					CMP		DI,4
					JAE		NEXTUPDATE
					MOV		ANCHORSTART,76
					MOV		ANCHOREND,99
					CALL	CLEARANCHOR
NEXTUPDATE:			CMP		DI,3
					JAE		NEXTUPDATE1
					MOV		ANCHORSTART,53
					MOV		ANCHOREND,76
					CALL	CLEARANCHOR
NEXTUPDATE1:		CMP		DI,2
					JAE		NEXTUPDATE2
					MOV		ANCHORSTART,30
					MOV		ANCHOREND,53
					CALL	CLEARANCHOR
NEXTUPDATE2:		CMP		DI,0
					JA		EXITUPDATESCORES1
					MOV		ANCHORSTART,7
					MOV		ANCHOREND,30
					CALL	CLEARANCHOR
					CALL	GAMEOVERSHIP1
EXITUPDATESCORES1:	RET
UPDATESCORESSHIP1	ENDP

;-------------------------------------------------------------------------------------------------------------------------
UPDATESCORESSHIP2	PROC      NEAR
					MOV		DI,SHIP2SCORE
					CMP		DI,5
					JAE		EXITUPDATESCORES2
					CMP		DI,4
					JAE		NEXTUPDATE11
					MOV		ANCHORSTART,537
					MOV		ANCHOREND,560
					CALL	CLEARANCHOR
NEXTUPDATE11:		CMP		DI,3
					JAE		NEXTUPDATE22
					MOV		ANCHORSTART,561
					MOV		ANCHOREND,584
					CALL	CLEARANCHOR
NEXTUPDATE22:		CMP		DI,2
					JAE		NEXTUPDATE33
					MOV		ANCHORSTART,585
					MOV		ANCHOREND,608
					CALL	CLEARANCHOR
NEXTUPDATE33:		CMP		DI,0
					JA		EXITUPDATESCORES1
					MOV		ANCHORSTART,609
					MOV		ANCHOREND,632
					CALL	CLEARANCHOR
					CALL	GAMEOVERSHIP2
EXITUPDATESCORES2:	RET
UPDATESCORESSHIP2	ENDP
;-------------------------------------------------------------------------------------------------------------------------
DRAWBULLETCOUNTS1	PROC		NEAR
					MOV 		CX,20
					MOV 		DX,385
DRAWBULLCOUNT1OUT:	MOV 		CX,20
					MOV			AH,0CH
					MOV 		BH,0
					MOV 		AL,04H
DRAWBULLCOUNT1IN:	INT 		10H
					INC			CX
					CMP			CX,99
					JBE			DRAWBULLCOUNT1IN
					INC			DX
					CMP			DX,394
					JBE			DRAWBULLCOUNT1OUT
					RET
DRAWBULLETCOUNTS1	ENDP	
;-------------------------------------------------------------------------------------------------------------------------
DRAWBULLETCOUNTS2	PROC		NEAR
					MOV 		CX,541
					MOV 		DX,385
DRAWBULLCOUNT2OUT1:	MOV 		CX,20
					MOV			AH,0CH
					MOV 		BH,0
					MOV 		AL,00H
DRAWBULLCOUNT2IN1:	INT 		10H
					INC			CX
					CMP			CX,620
					JBE			DRAWBULLCOUNT2IN1
					INC			DX
					CMP			DX,387
					JBE			DRAWBULLCOUNT2OUT1
					
					MOV			AL,BULLCOUNTS2
					MOV			DL,4
					MUL			DL	
					SUB			AX,1
					ADD			AX,541
					MOV			SI,AX
					
					MOV 		CX,541
					MOV 		DX,385
DRAWBULLCOUNT2OUT2:	MOV 		CX,541
					MOV			AH,0CH
					MOV 		BH,0
					MOV 		AL,04H
DRAWBULLCOUNT2IN2:	INT 		10H
					INC			CX
					CMP			CX,SI
					JBE			DRAWBULLCOUNT2IN2
					INC			DX
					CMP			DX,387
					JBE			DRAWBULLCOUNT2OUT2
					RET
DRAWBULLETCOUNTS2	ENDP	
;-------------------------------------------------------------------------------------------------------------------------
GAMEOVERSHIP1		PROC      NEAR
					MOV 		CX,46
					MOV 		DX,SHIP1ROW
GAMEOVER1OUTLOOP:	MOV 		CX,46
					MOV			AH,0CH
					MOV 		BH,0
					MOV 		AL,0BH
GAMEOVER1INLOOP:	INT 		10H
					INC			CX
					CMP			CX,72
					JBE			GAMEOVER1INLOOP
					INC			DX
					PUSH		CX
					PUSH		DX
					PUSH		AX
					MOV			CX,0
					MOV			DX,0A200H
					MOV			AH,86H
					INT			15H
					POP			AX
					POP			DX
					POP			CX
					CMP			DX,SHIP1ROWF
					JBE			GAMEOVER1OUTLOOP
					MOV			WIN,0
					INC			SHIP2ROUND
					CALL		GAMEOVER
					RET
GAMEOVERSHIP1		ENDP
;-------------------------------------------------------------------------------------------------------------------------
GAMEOVERSHIP2		PROC      NEAR
					MOV 		DX,SHIP2ROW
GAMEOVER2OUTLOOP:	MOV 		CX,568
					MOV			AH,0CH
					MOV 		BH,0
					MOV 		AL,0BH
GAMEOVER2INLOOP:	INT 		10H
					INC			CX
					CMP			CX,594
					JBE			GAMEOVER2INLOOP
					INC			DX
					PUSH		CX
					PUSH		DX
					PUSH		AX
					MOV			CX,0
					MOV			DX,0A200H
					MOV			AH,86H
					INT			15H
					POP			AX
					POP			DX
					POP			CX
					CMP			DX,SHIP2ROWF
					JBE			GAMEOVER2OUTLOOP
					MOV			WIN,1
					INC			SHIP1ROUND
					CALL		GAMEOVER
					RET
GAMEOVERSHIP2		ENDP
;-------------------------------------------------------------------------------------------------------------------------
GAMEOVER			PROC		NEAR
					CMP			WIN,0
					JNE			SHIP2WON
					CALL		GAMEOVERP
					JMP			SKIPSHIP2WONL
SHIP2WON:			CALL		GAMEOVERP

SKIPSHIP2WONL:		MOV			AX,@DATA
					MOV			DS,AX
					MOV			ES,AX
					
LOOPGAMEOVERKEY:	CMP			[MYKBUF+1CH],1
					JNE			LOOPGAMEOVERKEY
					CALL		RELOADDATASEG
					CMP			LEVEL,3
					JB			LEVEL1LOOP
					CMP			LEVEL,3
					JE			LEVEL2LOOP
					MOV			LEVELSTF,0
					MOV			LEVEL,1
					CALL		MAINSCREEN
LEVEL1LOOP:			INC			LEVEL
					CALL		PLAYGAME
LEVEL2LOOP:			INC			LEVEL
					MOV			LEVELSTF,1
					CALL		PLAYGAME
					RET
GAMEOVER			ENDP
;-------------------------------------------------------------------------------------------------------------------------
RELOADDATASEG		PROC		NEAR
					MOV			[MYKBUF+1CH],0
					MOV			SHIP1ROW,177
					MOV			SHIP2ROW,177
					MOV			SHIP1SCORE,5
					MOV			SHIP2SCORE,5
					MOV			SI,0
BULLCLEARLOOP:		MOV			WORD PTR BULLETFREE[SI],0
					ADD			SI,2
					CMP			SI,100
					JB			BULLCLEARLOOP
					MOV			SI,0
BARRIERCLEARLOOP:	MOV			WORD PTR BARRIERST[SI],0
					MOV			WORD PTR BARRIERTI[SI],0
					ADD			SI,2
					CMP			SI,10
					JBE			BARRIERCLEARLOOP
					MOV			BULLCOUNTS1,20
					MOV			BULLCOUNTS2,20
					MOV			BULLS1TIMER,5
					MOV			BULLS2TIMER,5
					CALL		RESTOREKEYBOARDISR
					MOV			CLOSE,0
					MOV			WIN,0
					MOV			CHATINVSTATER,0
					MOV			CHATINVSTATES,0
					MOV			GAMEINVSTATER,0
					MOV			GAMEINVSTATES,0
				
					
					
					
					RET
RELOADDATASEG		ENDP
;-------------------------------------------------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------------------------------------------
CLEARKEYBOARDBUFFER		PROC      NEAR	
						PUSH	AX
						PUSH	ES
						MOV		AX, 0000H
						MOV		ES, AX
						MOV		ES:[041AH], 041EH
						MOV		ES:[041CH], 041EH				; CLEARS KEYBOARD BUFFER
						POP		ES
						POP		AX
						RET
	
CLEARKEYBOARDBUFFER		ENDP
;-------------------------------------------------------------------------------------------------------------------------

IRQ1ISR		PROC  		NEAR
			PUSHA

			; READ KEYBOARD SCAN CODE FROM PORT 60H
			IN      AL, 60H

			; UPDATE KEYBOARD STATE
			XOR     BH, BH
			MOV     BL, AL
			AND     BL, 7FH             ; BX = SCAN CODE
			SHR     AL, 7               ; AL = 0 IF PRESSED, 1 IF RELEASED
			XOR     AL, 1               ; AL = 1 IF PRESSED, 0 IF RELEASED
			MOV     BYTE PTR [MYKBUF+BX], AL
				
	
			
			; SEND EOI TO KEYBOARD TO RESET KB STATUS
			IN      AL, 61H
			MOV     AH, AL
			OR      AL, 80H
			OUT     61H, AL
			MOV     AL, AH
			OUT     61H, AL

			; SEND EOI TO MASTER PIC TO TERMINATE INT
			MOV     AL, 20H
			OUT     20H, AL

			POPA
			IRET
IRQ1ISR		ENDP
;-------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------
CHATMODULE				PROC        	NEAR	
						MOV				CHATINVSTATER,0
						MOV				CHATINVSTATES,0
						CALL			SETCHATVIDEOMODE
						CALL			DRAWCHATSCREEN
						CALL			INITSC
						CALL			CHAT
						RET
CHATMODULE				ENDP
;-------------------------------------------------------------------------------------------------------------------------
INITSC					PROC        NEAR
						PUSHA
						MOV			AL,80H			;SET DLAB = 1
						MOV			DX,3FBH			;set dx to LCR
						OUT			DX,AL			;SEND OUT
						MOV			AX,12			;set baud rate to 9600
						MOV			DX,3F8H
						OUT 		DX,AL
						MOV			DX,3F9H
						MOV			AL,AH
						OUT 		DX,AL
						MOV			DX,3FBH
						MOV			AL,00011011B
						OUT			DX,AL
						POPA
						RET
INITSC					ENDP		
;-------------------------------------------------------------------------------------------------------------------------
SETCHATVIDEOMODE		PROC        NEAR
						MOV			AH,0
						MOV			AL,3
						INT			10H
						RET
SETCHATVIDEOMODE		ENDP
;-------------------------------------------------------------------------------------------------------------------------
DRAWCHATSCREEN			PROC       	NEAR
						
						MOV			AH,2
						MOV			DL,0
						MOV			DH,0
						MOV			BH,0
						INT			10H

						MOV			AH,9
						MOV			DX,OFFSET SENDERNAME + 2
						INT			21H	
						
						MOV			AH,2
						MOV			DL,SENDERNAME[1]
						MOV			DH,0
						MOV			BH,0
						INT			10H
						
						MOV			AH,2
						MOV			DH,0	
						MOV			DL,':'
						INT			21H						
						
						MOV			AH,2
						MOV			DL,0
						MOV			DH,11
						MOV			BH,0
						INT			10H
						
						MOV			AH,2
						MOV			DL,'-'
						MOV			CX,80
MIDDLELINE:				INT			21H
						LOOP		MIDDLELINE
						
						MOV			AH,9
						MOV			DX,OFFSET RECEIVERNAME
						INT			21H
						MOV			AH,2
						MOV			DL,':'
						INT			21H
						
						
						MOV			AH,2
						MOV			DL,0
						MOV			DH,23
						MOV			BH,0
						INT			10H
						
						MOV			AH,2
						MOV			DL,'-'
						MOV			CX,80
BOTTOMLINE:				INT			21H
						LOOP		BOTTOMLINE
						
						MOV			AH,9
						MOV			DX,OFFSET BOTTOMMSG1
						INT			21H
						MOV			DX,OFFSET RECEIVERNAME
						INT			21H
						MOV			DX,OFFSET BOTTOMMSG2
						INT			21H
						
						MOV			AH,2
						MOV			DL,0
						MOV			DH,1
						MOV			BH,0
						INT			10H
						
						MOV			CURSORSY,1
						
						MOV			CURSORRY,13
						
						RET
DRAWCHATSCREEN			ENDP
;--------------------------------------------------------------------------------------------------------------------------------------
CHAT					PROC        NEAR


INFINITELOOP:			MOV			AH,1
						INT			16H
						JZ			NOKEYPRESSED
						CALL		PUTKEYINBUFFER
NOKEYPRESSED:			MOV			DX,3FDH
						IN			AL,DX
						XOR			AH,AH
						AND			AL,1
						JZ			INFINITELOOP
						
						MOV			DX,3F8H
						IN			AL,DX
						
						CMP			AL,27
						JNE			SKIPENDCHAT
						CALL		EXITCHAT
						
SKIPENDCHAT:			MOV			SI,CLENGTHR
						MOV			BUFFERREC[SI],AL
						INC			CLENGTHR
						CMP			BUFFERREC[SI],'$'
						JNE			NOKEYPRESSED
						CALL		PRINTRMSG
						JMP			INFINITELOOP
						RET

CHAT					ENDP
;---------------------------------------------------------------------------------------------------------------------------------------
PUTKEYINBUFFER			PROC        NEAR	
						MOV			AH,0
						INT			16H
						CMP			AH,1CH
						JE			SEND
						
						CMP			AH,1
						JE			ESCPRESSED
									
						
						CMP			AH,14
						JE			BACKSPACE
						
						CMP			CLENGTH,50
						JAE			ENDPUTKEYINBUFF
						
						CMP			CLENGTH,0
						JA			ADDCHARBUFF
						
						
						PUSHA
						
						CMP			INCHATFLAG,1
						JNE			SKIPINCHATFLAG
						CALL		CLEARSENDERLINE
						
SKIPINCHATFLAG:			MOV			AH,2
						MOV			DL,0
						MOV			DH,CURSORSY
						MOV			BH,0
						INT			10H
						
						MOV			AH,2
						MOV			DL,'*'
						INT			21H
						
						MOV			AH,2
						MOV			DL,' '
						INT			21H
						
						POPA
						
ADDCHARBUFF:			MOV			BX,CLENGTH
						MOV			BYTE PTR CHARBUFFER[BX],AL
						MOV 		AH,2
						MOV			DL, BYTE PTR CHARBUFFER[BX]
						MOV			BX,0
						INT 		21H
						INC			CURSORSX
						INC			CLENGTH	
						JMP			ENDPUTKEYINBUFF
						
						
SEND:					CMP			CLENGTH,0
						JE			ENDPUTKEYINBUFF
						CALL		SENDBUFFER
						JMP 		ENDPUTKEYINBUFF
						
ESCPRESSED:				CALL		ESCAPECHAT
						MOV			INCHATLOOPFLAG,1
						JMP			ENDPUTKEYINBUFF	
						
BACKSPACE:				CALL		BACKSPACECASE

ENDPUTKEYINBUFF:		RET
PUTKEYINBUFFER			ENDP
;---------------------------------------------------------------------------------------------------------------------------------------
SENDBUFFER			PROC       	NEAR
					MOV			SI,0
SENDNEXTCHAR:		MOV 		DX,3FDH
WAITTILLEMPTY:		IN			AL,DX
					AND			AL,00100000B
					JZ			WAITTILLEMPTY
					MOV			DX,3F8H
					MOV			AL, BYTE PTR CHARBUFFER[SI]
					OUT			DX, AL
					INC			SI
					CMP			SI,CLENGTH
					JBE			SENDNEXTCHAR
					MOV			CLENGTH,0
					MOV			DX,3F8H
					MOV			AL,'$'
					OUT			DX,AL
					
					CMP			INCHATFLAG,1
					JE			NOSCROLLS
					INC			CURSORSY					
					MOV			CURSORSX,2
					CMP			CURSORSY,11
					JNE			NOSCROLLS
					CALL		SCROLLSEND
					
NOSCROLLS:			MOV			AH,2
					MOV			DL,CURSORSX
					MOV			DH,CURSORSY
					MOV			BH,0
					INT			10H
					
					RET
SENDBUFFER			ENDP
;---------------------------------------------------------------------------------------------------------------------------------------
BACKSPACECASE		PROC        NEAR
					
					CMP			CLENGTH,0
					JE			NOBACKSPACE
					
					MOV			AH,2
					MOV			DL,8
					INT			21H
					
					MOV			DL,20H
					INT			21H
					
					MOV			DL,8
					INT			21H
					DEC			CLENGTH
					
				
					
					
NOBACKSPACE:		RET
BACKSPACECASE		ENDP


;---------------------------------------------------------------------------------------------------------------------------------------
PRINTRMSG			PROC        NEAR
					CMP			INCHATFLAG,1
					JNE			SKIPCLEAR
					CALL		CLEARRECEIVERLINE
					
					
SKIPCLEAR:			MOV			AH,2
					MOV			DL,0
					MOV			DH,CURSORRY
					MOV			BH,0
					INT			10H
					
					MOV			AH,2
					MOV			DL,'-'
					INT			21H
					
					MOV			AH,2
					MOV			DL,CURSORRX
					MOV			DH,CURSORRY
					MOV			BH,0
					INT			10H
					
					MOV			AH,9
					MOV			DX,OFFSET BUFFERREC
					INT			21H
					MOV			CLENGTHR,0
					
					CMP			INCHATFLAG,1
					JE			NOSCROLLR
					INC			CURSORRY
					CMP			CURSORRY,23
					JNE			NOSCROLLR
					CALL		SCROLLRECEIVE
	
NOSCROLLR:			MOV			AH,2
					MOV			DL,CURSORSX
					MOV			DH,CURSORSY
					MOV			BH,0
					INT			10H
					
					RET
PRINTRMSG			ENDP
;---------------------------------------------------------------------------------------------------------------------------------------
SCROLLSEND			PROC        NEAR
					MOV			AH,6
					MOV			AL,1
					MOV			BH,7
					MOV			CH,1
					MOV			CL,0
					MOV			DH,10
					MOV			DL,79
					INT			10H
					DEC			CURSORSY
					
					MOV			AH,5H
					MOV			AL,0
					INT			10H
					
					MOV			AH,2
					MOV			DL,CURSORSX
					MOV			DH,CURSORSY
					MOV			BH,0
					INT			10H


					RET
SCROLLSEND			ENDP
;---------------------------------------------------------------------------------------------------------------------------------------
SCROLLRECEIVE		PROC        NEAR
					MOV			AH,6
					MOV			AL,1
					MOV			BH,7
					MOV			CH,13
					MOV			CL,0
					MOV			DH,22
					MOV			DL,79
					INT			10H
					DEC			CURSORRY
					
					MOV			AH,5H
					MOV			AL,0
					INT			10H
					
					MOV			AH,2
					MOV			DL,CURSORRX
					MOV			DH,CURSORRY
					MOV			BH,0
					INT			10H


					RET
SCROLLRECEIVE		ENDP
;---------------------------------------------------------------------------------------------------------------------------------------
ESCAPECHAT			PROC        NEAR
WAITTILLEMPTYESC:	IN			AL,DX
					AND			AL,00100000B
					JZ			WAITTILLEMPTYESC
					MOV			DX,3F8H
					MOV			AL, 27
					OUT			DX, AL
					CMP			INCHATFLAG,1
					JNE			GOTOMAINSCREEN					
					JMP			EXITESCAPECHAT
GOTOMAINSCREEN:		CALL		MAINSCREEN
EXITESCAPECHAT:		RET
ESCAPECHAT			ENDP
;---------------------------------------------------------------------------------------------------------------------------------------
EXITCHAT			PROC		NEAR
					CALL		MAINSCREEN
					RET
EXITCHAT			ENDP
;----------------------------------------------------------------------------------------------------------------------------------------
INCHATMODULE		PROC		NEAR
					MOV			MYKBUF[3DH],0
					CALL		RESTOREKEYBOARDISR
					MOV			SENDKBUFF[5],0
					MOV			RECKBUF[5],0
					MOV			INGAMEINVSTATES,0
					MOV			INGAMEINVSTATER,0
					CALL		CLEARLASTLINE
					CALL		DRAWINCHAT
					MOV			INCHATFLAG,1
					CALL		INCHAT
					MOV			INCHATFLAG,0					
					CALL		UPDATEKEYBOARDISR
					PRINTMESGMAINSCREEN CLEAR,78,24,0
					PRINTMESGMAINSCREEN CLEAR,78,25,0
					PRINTMESGMAINSCREEN CLEAR,78,26,0
					PRINTMESGMAINSCREEN CLEAR,78,27,0
					PRINTMESGMAINSCREEN CLEAR,78,28,0
					PRINTMESGMAINSCREEN CLEAR,78,29,0
					
					RET
INCHATMODULE		ENDP
;----------------------------------------------------------------------------------------------------------------------------------------
DRAWINCHAT			PROC		NEAR

					PRINTMESGMAINSCREEN INGAMECHATMSG,78,24,0
	
					MOV			AH,2
					MOV			DL,0
					MOV			DH,25
					MOV			BH,0
					INT			10H

					MOV			AH,9
					MOV			DX,OFFSET SENDERNAME + 2
					INT			21H	
					
					MOV			AH,2
					MOV			DL,SENDERNAME[1]
					MOV			DH,25
					MOV			BH,0
					INT			10H
					
					MOV			AH,2
					MOV			DH,0	
					MOV			DL,':'
					INT			21H						
					
					MOV			AH,2
					MOV			DL,0
					MOV			DH,27
					MOV			BH,0
					INT			10H
					
					MOV			AH,2
					MOV			DL,'-'
					MOV			CX,78
MIDDLELINEIN:		INT			21H
					LOOP		MIDDLELINEIN
					
					MOV			AH,2
					MOV			DL,' '
					INT			21H
					
					MOV			AH,2
					MOV			DL,' '
					INT			21H
					
					MOV			AH,9
					MOV			DX,OFFSET RECEIVERNAME
					INT			21H
					MOV			AH,2
					MOV			DL,':'
					INT			21H
					
					MOV			CURSORSY,26
						
					MOV			CURSORRY,29

					RET
DRAWINCHAT			ENDP
;----------------------------------------------------------------------------------------------------------------------------------------
INCHAT					PROC		NEAR
INFINITELOOPIN:			MOV			AH,1
						INT			16H
						JZ			NOKEYPRESSEDIN
						CALL		PUTKEYINBUFFER
						CMP			INCHATLOOPFLAG,1
						JE			EXITINCHAT
NOKEYPRESSEDIN:			MOV			DX,3FDH
						IN			AL,DX
						XOR			AH,AH
						AND			AL,1
						JZ			INFINITELOOPIN
						
						MOV			DX,3F8H
						IN			AL,DX
						
						CMP			AL,27
						JE			EXITINCHAT
						
SKIPENDCHATIN:			MOV			SI,CLENGTHR
						MOV			BUFFERREC[SI],AL
						INC			CLENGTHR
						CMP			BUFFERREC[SI],'$'
						JNE			NOKEYPRESSEDIN
						CALL		PRINTRMSG
						JMP			INFINITELOOPIN
						
EXITINCHAT:				MOV			INCHATLOOPFLAG,0
						RET
INCHAT					ENDP
;---------------------------------------------------------------------------------------------------------------------------------------
PRINTRMSGIN			PROC        NEAR
					MOV			AH,2
					MOV			DL,0
					MOV			DH,CURSORRY
					MOV			BH,0
					INT			10H
					
					MOV			AH,2
					MOV			DL,'-'
					INT			21H
					
					MOV			AH,2
					MOV			DL,CURSORRX
					MOV			DH,CURSORRY
					MOV			BH,0
					INT			10H
					
					MOV			AH,9
					MOV			DX,OFFSET BUFFERREC
					INT			21H
					MOV			CLENGTHR,0
					
					
					
	
					MOV			AH,2
					MOV			DL,CURSORSX
					MOV			DH,CURSORSY
					MOV			BH,0
					INT			10H
					
					RET
PRINTRMSGIN			ENDP
;---------------------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------
;Push all procedure
PUSHALL		PROC      NEAR
			PUSH			AX
			PUSH			BX
			PUSH			CX
			PUSH			DX
			RET
PUSHALL		ENDP

;Pop all Procedure
POPALL		PROC      NEAR
			POP				DX
			POP				CX
			POP				BX
			POP				AX
			RET
POPALL		ENDP

			END 			MAIN

;LEGACY CODE FOR REFERENCE
;-------------------------------------------------------------------------------------------------------------------------
;A procedure that changes the state of the row according to the boundaries			
; CHANGESTR	PROC     		NEAR
			; CMP				DH,29
			; JE				TOGGLER
			; CMP				DH,0
			; JE				TOGGLER
			; RET
; TOGGLER:	XOR				RST,1
			; RET			
; CHANGESTR	ENDP
	
; ;A procedure that changes the state of the column according to the boundaries			
; CHANGESTC	PROC      NEAR
			; CMP				DL,70
			; JE				TOGGLEC
			; CMP				DL,0
			; JE				TOGGLEC
			; RET
; TOGGLEC:	XOR				CST,1
			; RET
; CHANGESTC	ENDP

; ;A procedure that changes the coordinates of the message according to the boundaries
; CHANGESTATE	PROC      NEAR
			; CALL			CHANGESTR			;Change the state of the row if the message hits upper or lower bounday
			; CALL			CHANGESTC			;Change the state of the column if the message hits left or right boundary	
			; CALL			CHANGER				;If row state = 0 increment the row else decrement the row
			; CALL			CHANGEC				;If column state = 0 increment the column else decrement the column	
			; RET
; CHANGESTATE	ENDP

; ;A procedure that increments or decrements the row according to the state of the row
; CHANGER		PROC      NEAR
			; CMP				RST,0	
			; JE				INCR
			; DEC				DH
			; RET			
; INCR:		INC 			DH			
			; RET
; CHANGER		ENDP	

; ;A procedure that increments or decrements the column according to the state of the column
; CHANGEC		PROC      NEAR
			; CMP				CST,0
			; JE				INCC
			; DEC				DL
			; RET			
; INCC:		INC 			DL			
			; RET
; CHANGEC		ENDP				
			
			