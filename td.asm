; Ricky Cheng
; Tower Defense
; April 5, 2007

			jmp runProgram					; jumps past all the variables so nothing is being called
; variables
score		dw 0							; current score
level		dw 1							; what level is it currently on
gold		dw 50							; the amount of gold you have, gold is used to buy towers
lives		dw 20							; amount of lives you have before the game is over
curTowers	db 0							; current towers owned
gameMode	db 0							; choose the game mode, 0 = normal mode, 1 = endless, 4 = fast pace no upgrade mode

; enemy arrays
enemyXCoord	db 20 DUP (?)					; x coord
enemyYCoord	db 20 DUP (?)					; y coord
enemyDirect	db 20 DUP (1)					; 1 = Right, 2 = Left, 3 = Up, 4 = Down
enemyHealth	dw 40 DUP (?)					; this is the remaining life of each enemy
enemyAscii	db 1,2,3,4,5,6,7,8,11,12,13,14,15,16,17,18,19

; tower arrays
towerXCoord	db 100 DUP (?)
towerYCoord db 100 DUP (?)
towerType	db 100 DUP (?)					; air or ground
towerLevel	db 100 DUP (?)					; level will determine ascii character

; constants
noUpgrade	equ 2							; Fast pace, no stopping, no upgrading, endless mode
towersAlw	equ 100							; total towers allowed
enemies		equ 20							; enemies per level
eneAsciiTot	equ 19							; total number in the enemy Ascii Array
enemyMaxHea	equ	60000						; max life the enemy can have
stageWidth	equ 80							; stage width
stageHeight equ 25							; stage height
stageDiv	equ 65							; this variable represents the line which divides the two screens
scoreRow	equ 1							; row score is on
levelRow	equ 2							; row levle is on
goldRow		equ 3							; row gold is on
livesRow	equ 4							; row lives is on
vertBorder	equ 179							; ascii char for vertical line |
horzPath	equ 205							; ascii char for =
vertPath	equ 186							; ascii char for | |
trPath		equ 187							; top right 
tlPath		equ 201							; top left
brPath		equ 188							; bottom right
blPath		equ 200							; bottom left
field		equ 176							; field ascii 
arrow		equ 0							; arrow tower
air			equ 1							; air tower
canon		equ 2							; canon tower
roadAscii 	equ 255							; road Ascii

; style sheet
dosColor	equ 07h							; default DOS COLOR
textColor	equ 09h							; ASCII Text Color	
pathColor	equ 0Fh							; path color	
fieldColor	equ 02h							; field color	
towerColor	equ 03h							; tower color
roadColor	equ 0							; road color	/ enemy path
hitEneColor	equ 0ch							; color of the enemy when hit

; text
txtScore	db 'Score: ', 0					; Score txt
txtLevel	db 'Level: ', 0					; Level txt
txtLives	db 'Lives: ', 0					; Lives txt
txtGold		db 'Gold: ' , 0					; Gold txt
txtNxtLvl	db '(X)Next Wave ', 0			; Next level txt
txtTowers	db 'Towers: ', 0				; Towers txt	 
txtQuit		db '(X)End Game  ', 0			; End game txt
borderLine	db '------------ ', 0			; Border line
arrowLine 	db '(',235,') Arrow    ', 0		; Arrow txt
canonLine 	db '(',233,') Canon    ', 0		; Canon txt
airLine 	db '(',234,') Air      ', 0		; Air txt
clearLine 	db '( ) Clear    ', 0			; Clear selection txt
txtCost		db 'Cost: ', 0					; Tower cost
txtDmg		db 'Damage: ', 0				; Tower damage
txtPurchase	db '(X)Purchase ', 0			; Purchase tower
txtUpgrade	db '(X)Upgrade ', 0				; Upgrade tower
txtSelect	db 'Selected: ', 0
txtS1b		db '****  ***** ***** ***** *   *  **** *****', 0
txtS2b		db '*   * *     *     *     **  * *     *    ', 0
txtS3b		db '*   * ***** ***** ***** * * *  ***  *****', 0
txtS4b		db '*   * *     *     *     *  **     * *    ', 0
txtS5b		db '****  ***** *     ***** *   *  ***  *****', 0 
txtS1		db '  ***** ***** *     * ***** ****   ', 0
txtS2		db '    *   *   * *  *  * *     *   *  ', 0
txtS3		db '    *   *   * *  *  * ***** ****   ', 0
txtS4		db '    *   *   *  * * *  *     *  *   ', 0
txtS5		db '    *   *****   * *   ***** *   *  ', 0
txtStart	db 'Click on one of the circles to start the game.', 0
txtGameM1	db 'O Normal Mode', 0
txtGameM2	db 'O Endless Mode', 0
txtGameM3	db 'O Exit', 0
txtGameM4	db 'O Help', 0
txtReplay	db '(X) Play Again?', 0
txtQuitGm	db '(X) Quit Game!', 0
txtG1		db '*****   ***   *     *  ***** ', 0
txtG2		db '*      *   *  **   **  *     ', 0
txtG3		db '*  **  *****  * * * *  ***** ', 0
txtG4		db '*   *  *   *  *  *  *  *     ', 0
txtG5		db '*****  *   *  *  *  *  ***** ', 0
txtG1b		db '*****  *   *  *****	 ****	 ', 0
txtG2b		db '*   *  *   *  *  	 *   *   ', 0
txtG3b		db '*   *  *   *  *****  ****	 ', 0
txtG4b		db '*   *   * *   *  	 *  *    ', 0
txtG5b		db '*****    *    *****  *   *	 ', 0
txtHelp1	db 'The objective of this game is simple. Click on ', 0
txtHelp2	db 'a tower on the right menu and then click on a green ', 0
txtHelp3	db 'spot (field) on the left side of the screen. There are ', 0
txtHelp4	db 'two modes to play this game in. Normal mode, is the ', 0
txtHelp5	db 'default mode in which you can upgrade towers after each ', 0
txtHelp6	db 'wave but you can not purchase towers while the game is ', 0
txtHelp7	db 'in play. Endless mode, is an additional mode in which ', 0
txtHelp8	db 'you can not upgrade towers and there is no pause in ', 0
txtHelp9	db 'between each level. In normal mode, the game ends when ', 0
txtHelp10	db 'you reach level twenty or if you lose all twenty lives. ', 0 
txtHelp11	db 'In endless mode, the game ends when you lose all your ', 0
txtHelp12	db 'lives. Each tower has a specific range in which it can ', 0
txtHelp13	db 'hit the opponents enemies. An arrow tower. Has a range ', 0
txtHelp14	db 'of 5, the canon has a range of 3 and the air tower has ', 0
txtHelp15	db 'a range of 4. ', 0
txtHelp16	db 'Press any key to exit. ', 0
						
; temp registers
tempReg1	dw ?
tempReg2	dw ?
tempRegA	db ?
tempRegX	db ?							; temp register to hold dl
tempRegY	db ?							; temp register to hold dh
towerSelect	db ?							; holds the current tower type selected
towerIndex	dw ?							; this is the tower index

; start execution of program
runProgram:	call f_cls						; clears screen
			call f_splash					; calls splash screen
			call f_playGame					; method to run the game
			cmp ax, 1						; play game returns ax, 1 = play game, 0 = quit game
			je runProgram					; if = 1 then jump back to top and play again
			call f_cls						; if it is not then clear the screen and exit
			int 20h
;
; Function mouse movement for splash screen
f_splashMo	proc
splhLp:		call f_setOffSrn				; set the cursor off the screen
			mov ax, 3						; move ax, 3
			int 33h							; wait for mouse input
			or bx, bx						; if there is a mouse input
			jz splhLp						; if not jump back to top
			call f_prtMouXY					; gets xy location
			cmp cx, 32						; compare to 32, x column
			jne splhLp						; if it is not equal then jump back to top
			cmp dx, 16						; checks if y = 16
			jne splNxt2						; if it is not jump to 2nd check
			mov gameMode, 0					; it is the normal game move
			jmp splhExt						; exit after setting the game mode
splNxt2:	cmp dx, 18						; set y = 18
			jne splNxt3						; jump to next check
			mov gameMode, 2					; game mode = endless
			jmp splhExt						; jump to exit
splNxt3:	cmp dx, 22						; checks if it is the game over button
			jne splNxt4						; if it is not jump back to top
			call f_cls						; else clear screen
			int 20h							; return to dos
			jmp splhExt						; jump to exit
splNxt4:	cmp dx, 20
			jne splhLp
			call f_help
			call f_cls
			call f_splash
splhExt:	ret
f_splashMo	endp
;
; Function display help
f_help		proc
			push ax
			push bx
			push cx
			push dx
			call f_cls
			mov bl, 0fh						; text color
			mov si, offset txtHelp1			; moves the text into the correct position and prints it out
			mov dl, 5						; x loc
			mov dh, 5						; y loc
			call f_drawTxt3					; print
			mov si, offset txtHelp2			; moves the text into the correct position and prints it out
			mov dl, 5						; x loc
			inc dh							; y loc
			call f_drawTxt3					; print
			mov si, offset txtHelp3			; moves the text into the correct position and prints it out
			mov dl, 5						; x loc
			inc dh							; y loc
			call f_drawTxt3					; print
			mov si, offset txtHelp4			; moves the text into the correct position and prints it out
			mov dl, 5						; x loc
			inc dh							; y loc
			call f_drawTxt3					; print
			mov si, offset txtHelp5			; moves the text into the correct position and prints it out
			mov dl, 5						; x loc
			inc dh							; y loc
			call f_drawTxt3					; print
			mov si, offset txtHelp6			; moves the text into the correct position and prints it out
			mov dl, 5						; x loc
			inc dh							; y loc
			call f_drawTxt3					; print
			mov si, offset txtHelp7			; moves the text into the correct position and prints it out
			mov dl, 5						; x loc
			inc dh							; y loc
			call f_drawTxt3					; print
			mov si, offset txtHelp8			; moves the text into the correct position and prints it out
			mov dl, 5						; x loc
			inc dh							; y loc
			call f_drawTxt3					; print
			mov si, offset txtHelp9			; moves the text into the correct position and prints it out
			mov dl, 5						; x loc
			inc dh							; y loc
			call f_drawTxt3					; print
			mov si, offset txtHelp10		; moves the text into the correct position and prints it out
			mov dl, 5						; x loc
			inc dh							; y loc
			call f_drawTxt3					; print
			mov si, offset txtHelp11		; moves the text into the correct position and prints it out
			mov dl, 5						; x loc
			inc dh							; y loc
			call f_drawTxt3					; print
			mov si, offset txtHelp12		; moves the text into the correct position and prints it out
			mov dl, 5						; x loc
			inc dh							; y loc
			call f_drawTxt3					; print
			mov si, offset txtHelp13		; moves the text into the correct position and prints it out
			mov dl, 5						; x loc
			inc dh							; y loc
			call f_drawTxt3					; print			
			mov si, offset txtHelp14		; moves the text into the correct position and prints it out
			mov dl, 5						; x loc
			inc dh							; y loc
			call f_drawTxt3					; print			
			mov si, offset txtHelp15		; moves the text into the correct position and prints it out
			mov dl, 5						; x loc
			inc dh							; y loc
			call f_drawTxt3					; print
			mov dl, 5
			add dh, 2
			mov si, offset txtHelp16
			call f_drawTxt3
			int 16h
			pop dx
			pop cx
			pop bx
			pop ax
			ret
f_help		endp
;
; Function draws the splash screen
f_splash	proc
			mov bl, 0fh						; text color
			mov si, offset txtS1			; moves the text into the correct position and prints it out
			mov dl, 0						; x loc
			mov dh, 3						; y loc
			call f_drawTxt3					; print
			inc dh							; inc
			mov dl, 0
			mov si, offset txtS2
			call f_drawTxt3
			inc dh
			mov dl, 0
			mov si, offset txtS3
			call f_drawTxt3			
			inc dh
			mov dl, 0
			mov si, offset txtS4
			call f_drawTxt3
			inc dh
			mov dl, 0
			mov si, offset txtS5
			call f_drawTxt3
			; second part of the tower drawing
			mov si, offset txtS1b
			mov dl, 36
			mov dh, 3
			call f_drawTxt3
			inc dh
			mov dl, 36
			mov si, offset txtS2b
			call f_drawTxt3
			inc dh
			mov dl, 36
			mov si, offset txtS3b
			call f_drawTxt3			
			inc dh
			mov dl, 36
			mov si, offset txtS4b
			call f_drawTxt3
			inc dh
			mov dl, 36
			mov si, offset txtS5b
			call f_drawTxt3
			; third part line
			mov dl, 2
			add dh, 2
			mov cx, 75
			mov al, '='
			call f_paint
			; paints the choices
			mov dl, 18
			mov dh, 12
			mov cx, 1
			mov si, offset txtStart
			call f_drawTxt3
			mov dl, 32
			mov dh, 16
			mov si, offset txtGameM1
			call f_drawTxt3
			add dh, 2
			mov dl, 32
			mov si, offset txtGameM2
			call f_drawTxt3
			mov dl, 32
			add dh, 2
			mov si, offset txtGameM4		; help
			call f_drawTxt3
			mov dl, 32
			add dh, 2
			mov si, offset txtGameM3		; exit
			call f_drawTxt3
			call f_splashMo					; calls the splash movement function
			ret
f_splash	endp
;
; Function game over screen
; @return ax - 1 means play again, 0 means quit game
f_gameOver	proc
			mov dl, 10						; moves x
			mov dh, 3						; moves y
			mov cx, 1						; one print out only
			mov bl, 07h						; text color, dos color
			mov si, offset txtG1			; si position of the text
			call f_drawTxt3					; write it to screen
			inc dh
			mov dl, 10
			mov si, offset txtG2
			call f_drawTxt3
			inc dh
			mov dl, 10
			mov si, offset txtG3
			call f_drawTxt3
			inc dh
			mov dl, 10
			mov si, offset txtG4
			call f_drawTxt3
			inc dh
			mov dl, 10
			mov si, offset txtG5
			call f_drawTxt3
			; 2nd part of word, --> Over
			mov dh, 3
			mov dl, 40
			mov si, offset txtG1b
			call f_drawTxt3
			inc dh
			mov dl, 40
			mov si, offset txtG2b
			call f_drawTxt3
			inc dh
			mov dl, 40
			mov si, offset txtG3b
			call f_drawTxt3
			inc dh
			mov dl, 40
			mov si, offset txtG4b
			call f_drawTxt3
			inc dh
			mov dl, 40
			mov si, offset txtG5b
			call f_drawTxt3
			; end of printing word gameover
			mov dh, 10
			mov dl, 34
			mov si, offset txtScore
			call f_drawTxt3
			mov ax, score
			call f_printAX
			; end score print
			inc dh
			mov dl, 34
			mov si, offset txtLevel
			call f_drawTxt3
			mov ax, level
			call f_printAX
			; end level print
			inc dh
			mov dl, 34
			mov si, offset txtGold
			call f_drawTxt3
			mov ax, gold
			call f_printAX
			; end gold print
			inc dh
			mov dl, 34
			mov si, offset txtTowers
			call f_drawTxt3
			mov ax, 0
			mov al, curTowers
			call f_printAX
			; end tower print
			add dh, 4
			mov dl, 32
			mov si, offset txtReplay
			call f_drawTxt3
			; end replay button
			add dh, 2
			mov dl, 32
			mov si, offset txtQuitGm
			call f_drawTxt3
			; end quit button
gmovalp:	call f_setOffSrn				; moves cursor off the screen
			mov ax, 3						; gets ready to call mouse interrupt to get keys
			int 33h							; calls mouse interrupt
			or bx, bx						; checks if mouse has been pressed
			jz gmovalp						; if not go to top
			call f_prtMouXY					; print out mouse
			cmp cx, 33						; compare location
			jne gmovalp						; not equal jump to top
			cmp dx, 17						; compare to see if play again
			jne gMovChk2					; not equal jump to next loop
			mov ax, 1						; 1 = play game agian
			jmp gmovaext					; jump to exit
gMovChk2:	cmp dx, 19						; exit game
			jne gmovalp						; jump to top
			mov ax, 0						; quit game
			jmp gmovaext					; jump to exit
gmovaext:	ret
f_gameOver	endp
;
; Function starts the game
f_playGame	proc
			call f_cls
			call f_defaultSt				; default stats
			call f_initGui					; initializes GUI
			call f_runSimul					; runs the first wave
			call f_cls
			call f_gameOver
			ret
f_playGame	endp
;
; Function default status
f_defaultSt	proc
			mov ax, 0
			mov bx, 0
			mov cx, 0
			mov dx, 0
			mov si, 0
			mov gameMode, 0
			mov score, 0
			mov level, 1
			mov	gold, 50
			mov lives, 20
			mov curTowers, 0
			ret
f_defaultSt	endp

; Function to initalize gui and draw things to the screen
f_initGui	proc
			call f_setGphM					; sets Graphics Mode
			call f_drawBdr					; draws horizontal line to divide screen
			call f_drawRMenu				; draws the right menu
			call f_drwMoMenu				; draws the menu you click on a tower
			call f_drawPath					; draw the enemies path
			call f_drawField				; draws green field
			call f_intEneLoc				; inits the enemy location
			call f_setEneHea				; sets the enemies health
			call f_initMouse				; inits mouse
			ret
f_initGui	endp
;
; Function run wave simulation
f_runSimul	proc
			call f_buildTwr					; this allows you to build towers and upgrade
lpp:		cmp lives, 0					; if 0 lives then game is over
			je gameOver						; go to gameover
			cmp gameMode, 0					; if game mode is set to normal, there is only 20 levels
			jne elModStart					; not normal mode skip this check
			cmp level, 20					; check if it is level 20
			ja gameOver						; if it is then you win
elModStart:	call f_chkNxtLvl				; check the next level
			cmp al, 1						; 1 = yes next lvl
			jne lppElse						; if(al == 1) {
			call f_colorRoad				; colors the road
			call f_drawRMenu				; defaults right menu
			call f_setOffSrn				; set mouse off screen
			call f_buildTwr					; jump to build tower mode
lppElse:	call f_drawRMenu				; } else run rest of program {
			mov al, ' '						; blank ascii, clear enemy
			call f_dspEnemy					; displays the enemies
			call f_moveEnemy				; moves them across the road
			call f_colorRoad				; colors the road
			call f_getEneAsc				; enemy ascii character 
			call f_dspEnemy					; displays the enemy
			call f_attackEne				; attacks the enemy
			call f_setOffSrn				; sets screen off screen
			cmp gameMode, noUpgrade			; compare to check if it it is endlessmode
			jne skipNxtSp					; if it is not then skip next step
			call f_buildTwr					; this is for no upgrade mode
skipNxtSp:	call DELAY
			jmp lpp
gameOver:	ret
f_runSimul	endp
;
; Function buy towers
f_buyTwr	proc
			push ax
			push cx
			push dx
			push bx
			cmp curTowers, towersAlw		; checks to see if there are 100 towers
			ja buyTwrExtH					; if there is you can not build anymore
			cmp towerSelect, 0				; checks to see if tower select = 0 , meaning no towers have been selected
			je buyTwrExtH					; if it is then move on to next step
			cmp towerSelect, 4				; else if 4 is selected it means a tower has been selected
			je buyTwrExtH					; then jump to the next step
			mov dh, dl						; move the x coord
			mov dl, cl						; move the y coord
			call f_readChar					; read the character in its location (dl,dh)
			cmp al, field					; checks if it is a field
			jne buyTwrExtH					; if not equal to a field exit
			cmp towerSelect, 235			; check if is an arrow tower
			jne buyTwrCan					; if not jump to next purchase
			cmp gold, 10					; check if money is sufficient
			jb buyTwrExtH					; not equal exit
			sub gold, 10					; if it is sub 10 gold
			jmp purchTwr					; purchase tower
buyTwrCan:	cmp towerSelect, 233			; checks if tower is canon
			jne buyTwrAir					; not equal go to air tower
			cmp gold, 20					; check if playerh as 20 gold
			jb buyTwrExtH					; if user doesnt exit
			sub gold, 20					; subtract twenty gold
			jmp purchTwr					; jump to purchase tower
buyTwrAir:	cmp gold, 15					; checks if user has 15 gold
			jb buyTwrExtH					; below then exit
			sub gold, 15					; else subtract 15 gold
			jmp purchTwr					; jump to purchase tower
buyTwrExtH:	jmp buyTwrExt					; jump to exit
purchTwr:	mov al, towerSelect				; move al to the tower ascii
			mov bl, towerColor				; move in the tower color
			mov cx, 1						; move in 1 because only one tower printed
			call f_paint					; paint it to screeen
			mov bx, 0						; clear bx  = 0
			mov bl, curTowers				; bl = cur towers
			inc curTowers					; increment curtowers
			mov towerXCoord[bx], dl			; set x coord
			mov towerYCoord[bx], dh			; set y coord
			mov towerLevel[bx], 1			; set level
			cmp towerSelect, 235			; type comparisons
			jne buyTwrCmp2					; compare its type
			mov towerType[bx], arrow		; tower = arrow
			mov towerSelect, 0				; no towers selected
			jmp buyTwrExt					; exit
buyTwrCmp2:	cmp towerSelect, 234			; tower = air
			jne buyTwrCmp3					; jump to next comparison if not
			mov towerType[bx], air			; tower is air
			mov towerSelect, 0				; tower selected = none
			jmp buyTwrExt					; exit
buyTwrCmp3:	mov towerType[bx], canon		; tower = canon
			mov towerSelect, 0				; tower selected = 0
buyTwrExt:	pop bx
			pop dx
			pop cx
			pop ax
			ret
f_buyTwr	endp
;
; Function build towers, the player aspect of the game
; Warning (Do not over write cx, dx registers)  as they control the mouse
f_buildTwr	proc
			push ax							; saves register
bTwrLp:		mov ax, 3						; required for mouse input
			int 33h							; mouse interrupt
			cmp gameMode, noUpgrade			; checks the mode of the game
			je noUpGrMo						; endless = no upgrade skip next steps
			or bx, bx						; checks if anything was clicked
			jz bTwrLp						; if not jump to beginning of loop
noUpGrMo:	or bx, bx						; checks if anything was clicked
			jz bTwrQtJmpH					; if not jump to beginning of loop
			call f_clrPTwrM					; calls clear tower mouse menu
			call f_prtMouXY					; uncommenting this breaks the program
			call f_buyTwr					; calls purchase tower if tower was selected
			call f_drawRMenu				; calls draw right menu
			call f_dspSelect				; display selected 
			call f_setOffSrn				; moves cursor off screen
			cmp cx, 68						; (X) location
			jne btNxtChk					; not equal final check
			cmp dx, 22						;(X) Next Wave
			je bTwrQtJmpH					; equal jump
			cmp dx, 23						;(X) Exit Game
			jne btNxtChk2 					;if(true)
			mov lives, 0					; 0 lives exit game
			jmp bTwrQtJmpH					; } else
btNxtChk2:	cmp dx, 8						; arrow choosen
			jne btNxtChk3					; next check
			mov towerSelect, 235			; tower selected arrow
			call f_twrPMenu					; draw menu
			jmp bTwrLp						; go to top
btNxtChk3:	cmp dx, 9						; canon is choosen
			jne btNxtChk4					; not equwal next check
			mov towerSelect, 233			; tower selected canon
			call f_twrPMenu					; draw mouse menu
			jmp bTwrLp						; jump to top
bTwrLpJmpH:	jmp bTwrLp						; jumper to the top loop
bTwrQtJmpH: jmp quitGame					; jumper to quit game
btNxtChk4:	cmp dx, 10						; air
			jne btNxtChk5					; not equal nxt loop
			mov towerSelect, 234			; tower selected air
			call f_twrPMenu					; draw mouse menu
			jmp bTwrLp						; jump to top
btNxtChk5:	cmp dx, 11						; clear
			jne btNxtChk6					; jump nextl oop
			mov towerSelect, 0				; tower selected = 0
			call f_clrPTwrM					; clear tower
			jmp bTwrLp						; jump loop
btNxtChk6:	cmp dx, 18						; x = 18
			jne btNxtChk					; not equal jump
			cmp towerSelect, 4				; checks if towerselected = 4
			jne btNxtChk					; not equal jump
			call f_upgradeT					; else call upgrade tower
			call f_clrPTwrM					; clear the mouse screen
			jmp bTwrLp						; jump to top
btNxtChk:	call f_clrPTwrM					; clear mouse screen
			call f_grabTwrDa				; grab tower data
			cmp al, 1						; if it is a 1 means that a tower was selected
			jne bTwrLpJmpH					; if not equal go back to top of loop
			mov towerIndex, cx				; saves the tower index
			call f_towerMenu				; call tower menu
			mov towerSelect, 4				; move tower select, 4
			jmp bTwrLp						; additional jumper
quitGame:	call f_clrPTwrM					; clears the side screen
			mov ah, 0						; move ah = 0
			pop ax
			ret
f_buildTwr	endp
;
; Function draws menus
f_drwMoMenu	proc
			push bx
			push dx
			push si
			mov bx, 0Fh	 					; color value
			mov si, offset txtNxtLvl		; offset of the text
			mov dh, 22						; y location
			call f_drawTxt2					; draw text
			mov si, offset txtQuit
			mov dh, 23
			call f_drawTxt2
			mov si, offset borderLine
			mov dh, 6
			call f_drawTxt2
			mov si, offset arrowLine
			mov dh, 8
			call f_drawTxt2			
			mov si, offset canonLine
			mov dh, 9
			call f_drawTxt2			
			mov si, offset airLine
			mov dh, 10
			call f_drawTxt2
			mov si, offset clearLine
			mov dh, 11
			call f_drawTxt2
			mov si, offset borderLine
			mov dh, 13
			call f_drawTxt2
			pop si
			pop dx
			pop bx
			ret
f_drwMoMenu	endp
;
; Function grabs the tower and gets its stats
; @return al - 1 = true match found, 0 = false nothing found
; @return cx - index of match found
; @return ah - tower level
f_grabTwrDa	proc
			push bx
			mov bx, 0
gTwrDataLp:	cmp bl, curTowers
			ja noDaFound
			cmp cl, towerXCoord[bx]
			jne twrDataInc
			cmp dl, towerYCoord[bx]
			jne twrDataInc
			mov cx, bx
			mov al, 1
			mov ah, towerLevel[bx]
			jmp gTwrDataEx
twrDataInc:	inc bx
			jmp gTwrDataLp
noDaFound:	mov al, 0						; false nothing found, exit
gTwrDataEx:	pop bx
			ret
f_grabTwrDa	endp
;
; Function tower upgrade cost selection
; @param cx - index of tower
; @return bx - cost
f_upToCost	proc
			push cx
			push ax
			mov bx, cx						; index for the tower
			mov ah, towerType[bx]
			mov al, towerLevel[bx]
			cmp ah, arrow					; compares if tower is an arrow
			jne upToCostCn
			cmp al, 1
			jne upToCAr2
			mov bx, 13
			jmp upToCostE
upToCAr2:	cmp al, 2
			jne upToCAr3
			mov bx, 22
			jmp upToCostE
upToCAr3:	cmp al, 3
			jne upToCAr4
			mov bx, 37
			jmp upToCostE
upToCAr4:	cmp al, 4
			jne upToCAr5
			mov bx, 75
			jmp upToCostE
upToCAr5:	cmp al, 5
			jne upToCAr6
			mov bx, 135
			jmp upToCostE
upToCAr6:	mov ah, 0
			mov bx, 50
			mul bx
			mov bx, ax
			sub bx, level
			jmp upToCostE
upToCostCn:	cmp ah, canon					; compares if tower is a canon
			jne upToCostAi
			cmp al, 1
			jne upToCCn2
			mov bx, 18
			jmp upToCostE
upToCCn2:	cmp al, 2
			jne upToCCn3
			mov bx, 40
			jmp upToCostE
upToCCn3: 	cmp al, 3
			jne upToCCn4
			mov bx, 78
			jmp upToCostE
upToCCn4:	cmp al, 4
			jne upToCCn5
			mov bx, 143
			jmp upToCostE
upToCCn5:	cmp al, 5
			jne upToCCn6
			mov bx, 279
			jmp upToCostE
upToCCn6:	mov ah, 0
			mov bx, 60
			mul bx
			mov bx, ax
			sub bx, level
			jmp upToCostE
upToCostAi: cmp al, 1						; last tower has to be air
			jne upToCAi2
			mov bx, 10
			jmp upToCostE
upToCAi2:	cmp al, 2
			jne upToCAi3
			mov bx, 25
			jmp upToCostE
upToCAi3:	cmp al, 3
			jne upToCAi4
			mov bx, 75
			jmp upToCostE
upToCAi4:	cmp al, 4
			jne upToCAi5
			mov bx, 155
			jmp upToCostE
upToCAi5:	cmp al, 5
			jne upToCAi6
			mov bx, 300
			jmp upToCostE
upToCAi6:	mov ah, 0
			mov bx, 80
			mul bx
			mov bx, ax
			sub bx, level
			jmp upToCostE
upToCostE:	pop ax
			pop cx
			ret
f_upToCost	endp
;
; Function upgrades the tower
; @param towerIndex - index of the tower
f_upgradeT	proc
			push bx
			push cx
			mov cx, towerIndex	
			call f_upToCost					; bx = cost
			cmp bx, gold
			ja exitUpG
			sub gold, bx
			mov bx, towerIndex
			inc towerLevel[bx]
			mov towerIndex, 0
			mov towerSelect, 0
			call f_dspTower
exitUpG:	pop cx
			pop bx
			ret
f_upgradeT	endp
;
; Function tower menu, when you click on a menu stats will display
; @param cx - index of tower selected
; @param ah - level of the tower
f_towerMenu	proc
			push si
			push bx
			push dx
			push ax
			mov dh, 15
			mov bx, 0
			mov bl, ah						; tower level is stored here
			mov si, offset txtLevel
			call f_drawText
			mov dh, 17
			call f_upToCost
			mov si, offset txtCost
			call f_drawText
			mov bx, cx
			call f_getTwrDmg				; returns tower dmg in ax
			mov dh, 16
			mov bx, ax						; the new dmg the tower will have	
			mov si, offset txtDmg
			call f_drawText
			mov dh, 18						; upgrade row
			mov bl, 0Fh
			mov si, offset txtUpgrade
			call f_drawTxt2
			pop ax
			pop dx
			pop bx
			pop si
			call f_setOffSrn
			ret
f_towerMenu	endp
;
; Function draw tower purchase menu
; al = cost of towers, ah = dmg of towers
f_twrPMenu	proc
			push si
			push bx
			push dx
			push ax
			cmp towerSelect, 235			; arrow
			jne twrPMenN
			mov al, 10						; cost
			mov ah, 7
			jmp twrPMenuPr
twrPMenN:	cmp towerSelect, 233			; canon tower!!!
			jne twrPMenN2
			mov al, 20
			mov ah, 10
			jmp twrPMenuPr
twrPMenN2:	mov al, 15						; air tower!!!
			mov ah, 15						; air last case
			jmp twrPMenuPr
twrPMenuPr:	mov dh, 17						; row, y location
			mov bx, 0						; cost
			mov bl, al						; cost
			mov si, offset txtCost
			call f_drawText
			mov dh, 18
			mov bx, 0						; dmg
			mov bl, ah
			mov si, offset txtDmg
			call f_drawText
			pop ax
			pop dx
			pop bx
			pop si
			call f_setOffSrn
			ret
f_twrPMenu	endp
; 
; Function prints out the x and y value of the mouse
; @param cx - X position
; @param dx - Y position
f_prtMouXY	proc
			push ax
			push dx							; saves the dx
			mov dl, 66						s; testing delete after
			mov dh, 16
			call f_setCurPos
			shr cx, 1
			shr cx, 1
			shr cx, 1
			mov ax, cx
;			call f_printAx
			mov dh, 17
			call f_setCurPos
			pop dx
			shr dx, 1
			shr dx, 1
			shr dx, 1
			mov ax, dx
;			call f_printAx
			pop ax
			ret
f_prtMouXY	endp
;
; Function gets the ascii character for the tower
; @param al - level for tower
; @param ah - type of tower
; @return al - ascii for tower
f_towerAsci	proc
			cmp ah, arrow
			jne tAsChk2
			cmp al, 1
			jne tAsChkAw2					; change this to check lvl 2
			mov al, 235						; arrow tower ascii
			jmp tAsChkExt
tAsChkAw2:	cmp al, 2
			jne tskChkAw3
			mov al, 236
			jmp tAsChkExt
tskChkAw3:	cmp al, 3
			jne tskChkAw4
			mov al, 237
			jmp tAsChkExt
tskChkAw4:	cmp al, 4
			jne tskChkAw5
			mov al, 240
			jmp tAsChkExt
tskChkAw5:	cmp al, 5
			jne tskChkAw6
			mov al, 226
			jmp tAsChkExt
tskChkAw6:	mov al, 247
			jmp tAsChkExt
tAsChk2:	cmp ah, air
			jne tAsChk3
			cmp al, 1
			jne tAsChkAi2					; change this to check lvl2
			mov al, 234						; air tower ascii
			jmp tAsChkExt
tAsChkAi2:	cmp al, 2
			jne tAsChkAi3
			mov al, 225
			jmp tAsChkExt
tAsChkAi3:	cmp al, 3
			jne tAsChkAi4
			mov al, 227
			jmp tAsChkExt
tAsChkAi4:	cmp al, 4
			jne tAsChkAi5
			mov al, 244
			jmp tAsChkExt
tAsChkAi5:	cmp al, 5
			jne tAsChkAi6
			mov al, 245
			jmp tAsChkExt
tAsChkAi6:	mov al, 246
			jmp tAsChkExt
tAsChk3:	cmp al, 1						; has to be canon tower because last case
			jne tAsChkCn2					; change this to check lvl 2
			mov al, 233						; canon tower ascii
			jmp tAsChkExt
tAsChkCn2:	cmp al, 2
			jne tAsChkCn3
			mov al, 157
			jmp tAsChkExt
tAsChkCn3:	cmp al, 3
			jne tAsChkCn4
			mov al, 251
			jmp tAsChkExt
tAsChkCn4:	cmp al, 4
			jne tAsChkCn5
			mov al, 248
			jmp tAsChkExt
tAsChkCn5:	cmp al, 5
			jne tAsChkCn6
			mov al, 229
			jmp tAsChkExt
tAsChkCn6:	mov al, 162
			jmp tAsChkExt
tAsChkExt:	ret
f_towerAsci	endp
;
; Function loops through the array and draws the towers, there can only be 100 towers
f_dspTower	proc
			push bx
			mov bx, 0						; counter
dspTowerLp:	cmp bl, curTowers				; comparison 
			je dspTowerEx
			mov cx, 1
			mov dl, towerXCoord[bx]
			mov dh, towerYCoord[bx]
			mov al, towerLevel[bx]
			mov ah, towerType[bx]
			call f_towerAsci
			push bx							; saves the counter
			mov bl, towerColor				; tower color
			call f_paint				
			pop bx							; restores the counter
			inc bx							; increment counter
			jmp dspTowerLp
dspTowerEx:	pop bx
			ret
f_dspTower	endp
;
; Function adds gold 
f_addGold	proc
			cmp level, 5
			ja nxtBrack2
			inc gold
			jmp goldEnd
nxtBrack2:	cmp level, 10
			ja nxtBrack3
			add gold, 2
			jmp goldEnd
nxtBrack3:	cmp level, 15
			ja nxtBrack4
			add gold, 3
			jmp goldEnd
nxtBrack4:	cmp level, 20
			ja nxtBrack5
			add gold, 5
			jmp goldEnd
nxtBrack5:	cmp level, 25
			ja nxtBrack6
			add gold, 6
			jmp goldEnd
nxtBrack6:	cmp level, 30
			ja nxtBrack7
			add gold, 8
			jmp goldEnd
nxtBrack7:	cmp level, 40
			ja nxtBrack8
			add gold, 10
			jmp goldEnd
nxtBrack8:	cmp level, 50
			ja nxtBrack9
			add gold, 15
			jmp goldEnd
nxtBrack9:	cmp level, 100
			ja finalBrack
			add gold, 20
			jmp goldEnd
finalBrack:	add gold, 50
goldEnd:	ret
f_addGold 	endp
;
; Function deal damage to enemy
; @param bx - index of tower
; @param si - index of enemy
f_dealDmg	proc
			push si
			call f_dmgSound
			call f_getTwrDmg				; dmg stored in AX
			add si, si						; double si to get the word index
			cmp enemyHealth[si], ax
			ja dealDmgSu
			mov word ptr enemyHealth[si], 0
			jmp dealDmgEx
dealDmgSu:	sub enemyHealth[si], ax			; subtract health
dealDmgEx:	cmp word ptr enemyHealth[si], 0
			jne skipScoInc
			inc score
			call f_addGold
skipScoInc:	pop si
			ret
f_dealDmg	endp
;
; Function sound for the towers
; @param bx - index of tower
f_dmgSound	proc
			push ax
			push dx
			mov ax, 0						; clears ax
			mov al, towerType[bx]			; gets the tower type
			cmp ax, arrow					; checks if it is arrow
			jne dmgSndCan					; not jump to canon
			mov ax, 1500					; move sound frequency
			jmp sndExt						; jump exit
dmgSndCan:	cmp ax, canon					; checks if sound is canon
			jne dmgSndAir					; not equal jump to air
			mov ax, 1000					; move frequency
			jmp sndExt						; jump to exit
dmgSndAir:	mov ax, 750						; move sound frequency
			jmp sndExt						; jump exit
sndExt:		mov dx, 1						; move dx = 1
			call note						; play note
			pop dx
			pop ax
			ret
f_dmgSound	endp
;
; Function gets damage that the tower deals, figures out dmg
; from al, tower level and ah, tower type
; @param bx - index of tower
; @return ax - dmg returned in ax
f_getTwrDmg	proc
			mov al, towerLevel[bx]
			mov ah, towerType[bx]
			cmp ah, arrow					; arrow {
			jne	twrDmgAir				
			cmp al, 1						; level 1
			jne trArw2
			mov ax, 7						; 7dmg
			jmp twrDmgExt
trArw2:		cmp al, 2						; level 2
			jne trArw3
			mov ax, 13						; 15 dmg
			jmp twrDmgExt
trArw3:		cmp al, 3						; level 3
			jne trArw4
			mov ax, 30						; 35 dmg
			jmp twrDmgExt
trArw4:		cmp al, 4						; level 4
			jne trArw5
			mov ax, 55						; 75 dmg
			jmp twrDmgExt	
trArw5:		cmp al, 5						; level 5
			jne trArw6	
			mov ax, 75						; 175 dmg
			jmp twrDmgExt
trArw6:		push bx							; towers greater then lvl 5
			mov bl, al						; formula level *30 +25 = dmg
			mov bh, 0
			mov ax, 20					
			mul ax
			add ax, 25
			pop bx 
			jmp twrDmgExt
twrDmgAir:	cmp ah, air						; } air {
			jne twrDmgCan				
			cmp al, 1						; level 1
			jne trAir2
			mov ax, 15						; 15 dmg
			jmp twrDmgExt
trAir2:		cmp al, 2
			jne trAir3
			mov ax, 22
			jmp twrDmgExt
trAir3:		cmp al, 3
			jne trAir4
			mov ax, 40
			jmp twrDmgExt
trAir4:		cmp al, 4
			jne trAir5
			mov ax, 64
			jmp twrDmgExt
trAir5:		cmp al, 5
			jne trAir6
			mov ax, 80
			jmp twrDmgExt
trAir6:		push bx
			mov bl, al						; formula level *20 +50 = dmg
			mov bh, 0
			mov ax, 20					
			mul ax
			add ax, 50			
			pop bx
			jmp twrDmgExt
twrDmgCan:	cmp al, 1						; } canon { level 1
			jne twrCan2
			mov ax, 10						; 7 dmg
			jmp twrDmgExt
twrCan2:	cmp al, 2
			jne twrCan3
			mov ax, 20
			jmp twrDmgExt
twrCan3:	cmp al, 3
			jne twrCan4
			mov ax, 29
			jmp twrDmgExt
twrCan4:	cmp al, 4
			jne twrCan5
			mov ax, 44
			jmp twrDmgExt
twrCan5:	cmp al, 5
			jne twrCan6
			mov ax, 88
			jmp twrDmgExt
twrCan6:	push bx
			mov bl, al						; formula level *50 +50 = dmg
			mov bh, 0
			mov ax, 50					
			mul ax
			add ax, 50			
			pop bx
			jmp twrDmgExt
twrDmgExt:	ret
f_getTwrDmg	endp
;
; Function to get range of the tower
; @param al - tower type
; @return ah - range
f_getRange	proc
			cmp al, arrow
			jne gRanCmp2					; if not equal then jump to canon
			mov ah, 5
			jmp getRangeEx
gRanCmp2:	cmp al, canon
			jne gRanCmp3					; if not equal then jump to air
			mov ah, 3
			jmp getRangeEx
gRanCmp3:	mov ah, 4						; last one has to be air
getRangeEx:	ret
f_getRange	endp
;
; Function to check if tower can attack enemy
; @param bx - tower index
; @return al - 1 or 0, 1 meaning yes can attack
f_canAtkEn	proc
			push bx
			cmp towerType[bx], arrow
			jne canAtkUn
			mov al, 1
			jmp cnAtkEnXt
canAtkUn:	mov ax, level					; gets ready for division
			push bx
			mov bx, 7						; puts 7 into bx gets ready to divide
			div bl
			pop bx							; restores bx
			cmp ah, 0						; mod is level 7, 7th level is air
			jne cnAtkEnLa		
			mov ah, 1						; enemy is air
			jmp cnAtkEnChk
cnAtkEnLa:	mov ah, 0						; enemy is ground	
cnAtkEnChk:	mov bl, towerType[bx]
			cmp bl, canon					; if it is a canon tower then it is ground
			jne cnAtkEnCk2					; if not it is either a 0 or 1 already
			mov bl, 0						; if (bl == 2) bl = 0 meaning ground
cnAtkEnCk2:	cmp ah, bl						; check if air or ground
			je cnAtkYes						; if it is equal it means they can atk
			mov al, 0						; else means no they can not attack
			jmp cnAtkEnXt					; jump to exit
cnAtkYes:	mov al, 1						; 1 = true, can attack
			jmp cnAtkEnXt					; jump to exit
cnAtkEnXt:	pop bx
			ret
f_canAtkEn	endp
; 
; Function to check for overflow in range, takes in x coords
; and checks if it goes beyond the boundaries of 1 - 80
; @param al - x range low
; @param ah - x range high
; @return (al,ah) - readjusts for overflow, new hi, lo x range
f_chkOvrFlX	proc
			cmp al, 0F0h					; checks if it is under 1 (x low range)
			jb chkOvXExt					; if it isnt then exit loop
			mov al, 1
			cmp ah, stageWidth				; cmp ah, 80
			jb chkOvXExt
			mov ah, stageWidth
chkOvXExt:	ret
f_chkOvrFlX	endp
;
; Function to check for overflow in range, takes in y coords
; and checks if it goes beyond boundaries of 0-24
; @param al - y range low
; @param ah - y range high
; @return (al,ah) - readjusts for overflow, new hi, low x range
f_chkOvrFlY	proc
			cmp al, 0F0h
			jb chkOvYExt
			mov al, 0
			cmp ah, stageHeight
			jb chkOvYExt
			mov ah, stageHeight
chkOvYExt:	ret
f_chkOvrFlY	endp
;
; Function to check if there is an enemy in the tower range
; Loops through the tower array and then loops through the enemy array
; Worse big o(n^2) = 2000 checks, 100*20 enemies
; @param bx - index of tower
; @param si - index of enemy
f_findEnemy	proc
			push cx
			push bx
			call f_canAtkEn					; calls a function to check if tower can attack enemy
			cmp al, 1						; 1 means return was true
			jne findEneExt					; else get out of this function
			mov al, towerType[bx]			; al = tower type, param for f_getRange
			call f_getRange					; gets range into ah
			dec ah							; subtract by 1 so that center is included in range
			mov tempRegA, ah				; stores in temp registry
			mov al, towerXCoord[bx]			; al = x coord for tower
			mov ah, al						; sets both ah = al = X coord for tower
			sub al, tempRegA				; gets the min X range
			add ah, tempRegA				; ges the max X range
			call f_chkOvrFlX
			cmp al, enemyXCoord[si]		
			ja findEneExt
			cmp enemyXCoord[si], ah
			ja findEneExt
			mov al, towerYCoord[bx]			; al = y coord for tower
			mov ah, al
			sub al, tempRegA
			add ah, tempRegA
			call f_chkOvrFlY
			cmp al, enemyYCoord[si]			; if enemyY is in range of Y tower min
			ja findEneExt
			cmp enemyYCoord[si], ah
			ja findEneExt
			mov dl, enemyXCoord[si]			; it is in range, x coord
			mov dh, enemyYCoord[si]			; y coords
			mov cx, 1						; 1 enemy
			push bx
			call f_getEneAsc				; gets enemy ascii character
			mov bl, hitEneColor				; damaged enemy color
			call f_paint
			pop bx
			call f_dealDmg
			mov dl, 1						; hit = true, there was an attack
findEneExt:	pop bx
			pop cx
			ret
f_findEnemy	endp
;
; Function attack enemy, this is the main method to attack
; loops through the tower array and loops through the enemy array for the 
; first instance of an enemy, if it finds it, attack it and check the next tower
f_attackEne	proc
			push ax
			push cx
			push bx
			push si
			mov bx, 0						; bx counter to loop through towers array
atkEneLpFi:	cmp bl, curTowers				
			je atkEneExt					; if over then exit	
			mov si, enemies
			dec si			
atkEneLpIn:	cmp si, -1						; -1 = 0ffffh
			je atkEnePExt					; if over then exit
			call f_chkEneLiv				; checks if enemy is alive or dead
			cmp ah, 0						; if enemy is dead
			je atkEneDead					; jump to atkEneDead
			mov dl, 0
			call f_findEnemy				; atk enemy function
			cmp dl, 1						; if(hit == true)
			je atkEnePExt					; break loop and inc tower
atkEneDead:	dec si
			jmp atkEneLpIn					; jump back to loop
atkEnePExt:	inc bl
			jmp atkEneLpFi					; jump back to outter loop
atkEneExt:	pop si
			pop bx
			pop cx
			pop ax
			ret
f_attackEne	endp
;
; Function check for next level
; @return al - 1 = yes nxt lvl, 0 = no not next level
f_chkNxtLvl	proc
			push si
			mov si, 0
			mov al, 0
ckNxtLvlLp:	cmp si, enemies
			je nxtLvlTru
			call f_chkEneLiv
			cmp ah, 1						; check to see if enemy is dead
			je ckNxLvExt					; if not dead then exit
			inc si
			jmp ckNxtLvlLp
nxtLvlTru:	mov ax, level
			add score, ax
			inc level
			call f_intEneLoc
			call f_setEneHea
			call f_resetDir
			mov al, 1						; return 
ckNxLvExt:	pop si
			ret
f_chkNxtLvl	endp
;
; Function sets the enemies health depending on the level
; Levels 1 - 3: level*10
; Level 4 - 6: level *15
; Level 7: level *20
f_setEneHea	proc
			push si
			push ax
			push bx
			mov si, 0
			mov bx, enemies
			add bx, bx
stEneHeaLp:	cmp si, bx
			ja stEnHHelp
			cmp level, 3					; level 1 -3 {
			ja setEneRngA
			mov ax, 10
			mul level
			jmp stEneLpEnd					; }
setEneRngA:	cmp level, 6					; level 4-6 {
			ja setEneEngB
			mov ax, 15						
			mul level
			jmp stEneLpEnd					; }
setEneEngB:	cmp level, 9
			ja setEneEngC
			mov ax, 20
			mul level
			jmp stEneLpEnd
setEneEngC: cmp level, 12
			ja setEneEngD
			mov ax, 25
			mul level
			jmp stEneLpEnd
stEnHHelp:	jmp stEnHeaEx
setEneEngD:	cmp level, 15
			ja setEneEngE
			mov ax, 35
			mul level
			jmp stEneLpEnd
setEneEngE:	cmp level, 18
			ja setEneEngF
			mov ax, 40
			mul level
			jmp stEneLpEnd
setEneEngF:	cmp level, 25
			ja setEneEngG
			mov ax, 55
			mul level
			jmp stEneLpEnd
setEneEngG:	cmp level, 30
			ja setEneEngH
			mov ax, 60
			mul level
			jmp stEneLpEnd
setEneEngH:	cmp level, 40
			ja setEneEngI
			mov ax, 75
			mul level
			jmp stEneLpEnd
setEneEngI:	mov ax, 100
			mul level
			jmp stEneLpEnd
stEneLpEnd:	mov enemyHealth[si], ax			; EXIT {
			add si, 2						; word array			
			jmp stEneHeaLp					; }
stEnHeaEx:	pop bx
			pop ax	
			pop si
			ret
f_setEneHea	endp
;
; Function resets the direction
f_resetDir	proc
			push si
			mov si, 0
rstDirLp:	cmp si, enemies
			je rstDirExt
			mov enemyDirect[si], 1			; right direction
			inc si
			jmp rstDirLp
rstDirExt:	pop si
			ret
f_resetDir	endp
;
; Function get next position for enemy
; @param dl - x coord
; @param dh - y coord
; @param al - direction
; @return (dl, dh) - new x,y positions
f_getNxtPos	proc
			cmp al, 1
			jne chkPosLeft
			inc dl
			ret
chkPosLeft:	cmp al, 2
			jne chkPosUp
			dec dl
			ret
chkPosUp:	cmp al, 3
			jne chkPosDown
			dec dh
			ret
chkPosDown:	inc dh
			ret
f_getNxtPos	endp

; Function checks if the enemies are out of bound, if it then reduce their health to 0
; and decrease 1 life from the player
; @param dh - y coord
; @param si - enemy index
f_chkOutBnd	proc
			push ax
			push bx
			push si
			cmp dh, -1						; out of bounds
			jne	outLpExt
			mov ax, si
			mov bx, 2
			mul bx
			mov si, ax
			mov word ptr enemyHealth[si], 0	; enemy health = 0
			dec lives						; lives--
			cmp lives, -1
			jne outLpExt
			mov lives, 0
outLpExt:	pop si
			pop bx
			pop ax
			ret
f_chkOutBnd	endp
;
; Function checks if the enemy still has health
; @param si - enemy index
; @return ah - 1 enemy is alive, 0 enemy is dead
f_chkEneLiv	proc
			push bx
			push si
			push ax
			mov tempRegA, al				; saves the al register
			mov ax, si						; moves ax, si
			mov bx, 2						; moves bx, 2
			mul bx							; multiples by 2 because word array
			mov si, ax						; restores si index
			pop ax							; restores ax registry
			cmp word ptr enemyHealth[si], 0	; checks if the enemy has 0 life
			jz eneDead						; if it does then go to eneDead
			mov ah, 1						; enemy is alive
			jmp chkEneLivE
eneDead:	mov ah, 0						; enemy is dead
chkEneLivE:	pop si
			pop bx
			mov al, tempRegA				; restores al register
			ret
f_chkEneLiv	endp
;
; Function to move the enemies
f_moveEnemy proc
			push si
			push dx
			mov si, 0						; si = 0
moveEneLp:	cmp si, enemies					; while si < 20, amount of enemies
			je moveEneXt					; if it is exit
			call f_chkEneLiv
			cmp ah, 0						; checks if enemy is dead
			je getNxtEne					; if (enemy == dead) { jmp to inc}
			mov dl, enemyXCoord[si]			; gets the x coord
			mov dh, enemyYCoord[si]			; gets the y coord
			mov al, enemyDirect[si]			; gets the direction
			call f_getNxtPos				; gets next position
			call f_chkNxtPos				; checks if there is a turn
			call f_chkOutBnd				; checks if enemy is out of bounds
			mov enemyXCoord[si], dl			; replace x coord
			mov enemyYCoord[si], dh			; replace y coord
			mov enemyDirect[si], al			; replace direction
getNxtEne:	inc si							; increment index
			jmp moveEneLp					; loop
moveEneXt:	pop dx
			pop si
			ret
f_moveEnemy	endp
;
; Function gets the enemy ascii character
; @return al - enemy ascii
f_getEneAsc	proc
			mov ax, level					; ax = level
			dec ax							; ax = ax - 1, array starts at 0
			mov bx, eneAsciiTot				; bx = enemyAscii
			div bl							; ax = ax/bx
			mov al, ah						; remainder gets moved to al
			mov ah, 0						; blank out ah
			mov bx, ax						; move into bx because bx is the index of array
			mov al, enemyAscii[bx]			; al = ascii character to print
			ret
f_getEneAsc	endp
;
; Function draw enemies onto the screen, there is no al here because it is set in the loop
; @param al - ascii character
f_dspEnemy	proc
			push cx
			push si
			push bx
			mov si, 0
pntLp:		cmp si, enemies
			je exitPntLp
			mov tempReg1, si
			add si, si
			mov bx, enemyHealth[si]
			mov si, tempReg1
			cmp bx, 0
			je skipDspEne
			mov dl, enemyXCoord[si]
			mov dh, enemyYCoord[si]
			mov cx, 1 						; 1 enemy
			mov bl, 0eh						; enemy color
			cmp dh, -1						; if it reaches the end exit
			je skipDspEne
			cmp dl, 128						; negative number
			ja skipDspEne
			call f_paint
skipDspEne: inc si
			jmp pntLp
exitPntLp:	pop bx
			pop si
			pop cx
			ret
f_dspEnemy	endp
;
; Function enemies
f_intEneLoc proc
			push si
			push dx
			push ax
			push cx
			mov si, 0 						; enemy location index
			mov dl, 0 						; starting column
			mov al, -13						; starting location off screen
intEneLp:	cmp dl, 13						; 20 enemies, pattern is 2 enemies, 1 enemies etc
			je finEnemyInt					; if number = 13 exit loop
			push dx							; save dx
			mov dh, 0						; dh = 0 in order to do cx = dx
			mov cx, dx						; cx = dx to do even, odd comparison
			pop dx							; restore dx
			and cx, 00000001b				; checks if it is an even or odd number
			jnz intOddEne					; if it is an Even number
			mov enemyXCoord[si], al			; {
			mov enemyYCoord[si], 2			; y coord for 2 enemies
			inc si							; incremnet si index
			mov enemyXCoord[si], al			; al = x coord
			mov enemyYCoord[si], 4			; y coord for 2 enemies
			inc si							; increment enemy array index
			inc dl							; dl, loop
			inc al							; increment x loc
			jmp intEneLp					; } else
intOddEne:	mov enemyXCoord[si], al			; {
			mov enemyYCoord[si], 3			; y coord for single enemy
			inc si							; si index
			inc dl							; 13 paths
			inc al							; increment x loc
			jmp intEneLp					;}
finEnemyInt:pop cx
			pop ax
			pop dx
			pop si
			ret
f_intEneLoc endp
;
; Function draws the border, straight line down the screen
f_drawBdr	proc
			mov dh, 0
			mov dl, stageDiv
			mov tempReg2, 80
			mov cx, 1
			mov bl, 0Fh
			mov al, vertBorder
			call f_paintVert
f_drawBdr	endp
;
; Function prints characters down a line vertically
; @param (DL,DH) - Cursor Location
; @param CX - Number of chars to print vertically
; @param BL - Color
; @param AL - Ascii Character
; @param tempReg2 - # of Vertical Lines
f_paintVert	proc
pVertLp:	cmp tempReg2, 0
			je pVertExt
			call f_paint
			inc dh
			dec tempReg2
			jmp pVertLp
pVertExt:	ret
f_paintVert	endp
;
; Function to draw the right menu
f_drawRMenu	proc
			call f_blankDsp					; clears display
			call f_dspLives					; display lives
			call f_dspScore					; display scores
			call f_dspGold					; display gold
			call f_dspLevel					; display level
			ret
f_drawRMenu	endp
;
; Function that acts as a helper method to write things to the screen
; @param si - offset of the text to write
; @param bx - score to write / number to write
f_drawText proc
			push ax
			push cx
			push bx
			mov dl, stageDiv+2				; starting col of text
			mov cx, 1						; amount of times to print character 
			mov bl, textColor				; textColor
			call f_setCurPos				; sets cursor location
dtxtlp:		mov al, byte ptr 0[si]			; al is char to be printed
			call f_paint					; calls the paint ASCII function
			inc si							; increments si
			inc dl							; move the row counter
			cmp al, 0						; check for end of prompt
			jne dtxtlp						; if not the end keep looping
			inc dl							; moves one space over
			pop bx							; restores the print value
			cmp bx, 0FFh
			je drwTxtEnd
			mov ax, bx						; stores the printed value
drwTxtEnd:	call f_printAx					; writes the score to screen
			pop cx
			pop ax
			ret
f_drawText	endp
;
; Function that acts as a helper method to write things to the screen, can change color
; @param si - offset of the text to write
; @param bl - text color
f_drawTxt2 	proc
			push cx
			mov dl, stageDiv+2				; starting col of text
			mov cx, 1						; amount of times to print character 
			call f_setCurPos				; sets cursor location
dtxt2lp:	mov al, byte ptr 0[si]			; al is char to be printed
			call f_paint					; calls the paint ASCII function
			inc si							; increments si
			inc dl							; move the row counter
			cmp al, 0						; check for end of prompt
			jne dtxt2lp						; if not the end keep looping
			pop cx
			ret
f_drawTxt2	endp
;
; Function draw text 3
; @param (dl,dh) - x, y coordinates
f_drawTxt3 	proc
			push cx
			mov cx, 1						; amount of times to print character 
			call f_setCurPos				; sets cursor location
dtxt3lp:	mov al, byte ptr 0[si]			; al is char to be printed
			call f_paint					; calls the paint ASCII function
			inc si							; increments si
			inc dl							; move the row counter
			cmp al, 0						; check for end of prompt
			jne dtxt3lp						; if not the end keep looping
			pop cx
			ret
f_drawTxt3	endp
;
; Function blanks out display area
f_blankDsp	proc
			push ax
			push bx
			push cx
			push dx
			mov dl, 72
			mov dh, 1
			mov al, ' '
			mov bl, textColor						; 
			mov cx, 6
			mov tempReg2, 4
			call f_paintVert
			pop dx
			pop cx
			pop bx
			pop ax
			ret
f_blankDsp	endp
;
; Function to write out what tower is selected
f_dspSelect	proc
			push ax
			push cx
			push bx
			push dx
			push si
			mov bl, 0
			mov dh, 15
			mov si, offset txtSelect
			call f_drawText
			mov dh, 15
			mov dl, 77
			call f_setCurPos
			mov al, towerSelect
			mov cx, 1
			mov bl, 0fh
			call f_paint
			pop si
			pop dx
			pop bx
			pop cx
			pop ax
			ret
f_dspSelect	endp

; Function to write the gold to the stage
f_dspGold	proc
			push bx
			push dx
			push si
			mov bx, gold
			mov dh, goldRow
			mov si, offset txtGold
			call f_drawText
			pop si
			pop dx
			pop bx
			ret
f_dspGold	endp
;
; Function to write the score to the stage
f_dspLives	proc
			push bx
			push dx
			push si
			mov bx, lives
			mov dh, livesRow
			mov si, offset txtLives
			call f_drawText
			pop si
			pop dx
			pop bx
			ret
f_dspLives	endp
;
; Function to write the score to the stage
f_dspScore	proc
			push bx
			push dx
			push si
			mov bx, score
			mov dh, scoreRow
			mov si, offset txtScore
			call f_drawText
			pop si
			pop dx
			pop bx
			ret
f_dspScore	endp
;
; Function to write the level to the stage
f_dspLevel	proc
			push bx
			push dx
			push si
			mov bx, level
			mov dh, levelRow
			mov si, offset txtLevel			
			call f_drawText
			pop si
			pop dx
			pop bx
			ret
f_dspLevel	endp
;
; Function sets the graphics mode to the text color
f_setGphM	proc
			mov ah, 0bh
			mov bh, 1
			mov bl, textColor
			int 10h
			call f_paint
			ret
f_setGphM	endp
; 
; Function clears out the printTowerMenu area
f_clrPTwrM	proc
			push dx
			push cx
			mov dl, stageDiv+2				; x loc
			mov dh,	15
			mov cx, 12
			mov tempReg2, 6
			mov bl, textColor
			mov al, ' '
			call f_paintVert
			call f_setOffSrn
			pop cx
			pop dx
			ret
f_clrPTwrM	endp
;
; Function clears the screen
f_cls		proc
			mov dx, 0						; location = 0
			mov cx, stageWidth*stageHeight	; full screen
			mov bl, dosColor				; set doscolor
			mov al, ' '						; empty character
			call f_paint					; paint to screen
			ret
f_cls		endp
;
; Function to print out a specific digit
f_prtDigit 	proc
			push ax							; saves ax
			mov ah, 0eh						; video
			mov al, bl						; moves al = bl, gets ready to print digit
			add al, '0'						; converts it to an ascii digit
			int 10h							; prints out ascii
			pop ax							; restores ax
			ret
f_prtDigit	endp
;
; Function to print out up a 5 digit number
; @param AX - the location of the number
f_printAx	proc
			push dx							; saves dx
			push cx							; saves cx
			push bx							; saves bx
			mov cl, 0						; if cl is turned to a 1 then print out zeros
			mov dx, 10000					; move dx, 10000, subtract by 10000
			mov bx, 0						; clears out bx register
			cmp ax, dx						; this compare is check if it is necessary to skip the first loop
			jb thousandx					; if(ax < dx) jump to thousandx, skip print
tenthd:		cmp ax, dx						; while(ax<10000) {
			jb thousand						; if it is lower then break loop
			inc bl 							; print counter
			sub ax, dx						; subtract ax = ax - 10000
			jmp tenthd						; }
thousand:	call f_prtDigit					; prints digit
			mov cl, 1
thousandx:	mov dx, 1000					; jumps to this spot and skips the print
			mov bl, 0						; move bl = 0
			cmp cl, 1
			je pthds
			cmp ax, dx						; this compare is to check if it is necessary to skip the next loop
			jb hundredx						; if(ax < dx) jump to hundredx, skip print
pthds:		cmp ax, dx						; while(ax<1000)
			jb hundred						; { if it is lower jump out of loop
			inc bl							; increment counter
			sub ax, dx						; ax = ax - 1000;
			jmp pthds						; }
hundred:	call f_prtDigit					; prints digit
			mov cl, 1
hundredx:	mov dx, 100						; dx = 100
			mov bl, 0						; clears bl
			cmp cl, 1
			je phds
			cmp ax, dx						; this compare is to check if it is necessary to skip the next loop
			jb tensx						; if(ax<dx) jumps to tensx, skip print
phds:		cmp ax, dx						; compare ax to dx
			jb tens							; if ax < 100 then jump to tens 
			inc bl							; bl = hundreds places
			sub ax, dx						; ax = ax - 100
			jmp phds						; jump back to hundreds loop
tens:		call f_prtDigit					; prints digit
			mov cl, 1
tensx:		mov dx, 10 						; tens digit divide
			cmp ax, dx						; if(ax < dx) check if there is tens digit
			jb onesx						; if there is no tens place then jump to print only ones digit
			div dl							; ax = ax / dx (10)
			mov bl, al						; moves bl = al
			call f_prtDigit					; print tens
			jmp one							; if there is a tens digit skip the next step
onesx:		cmp cl, 1
			jne onskp
			mov bl, 0
			call f_prtDigit
onskp:		div dl							; this line is only called if there isn't a tens digit, it moves ah = al
one:		mov bl, ah						; bl = ah, bl = the item being printed
			call f_prtDigit					; print ones
			pop bx							; restore values bx
			pop cx							; restore values cx
			pop dx							; restore values dx
			ret
f_printAx	endp
;
; Function sets cursor off screen
f_setOffSrn	proc
			push dx
			mov dl, 80
			mov dh, 25
			call f_setCurPos
			pop dx
			ret
f_setOffSrn	endp
;
; Function sets the cursor to a position on the screen
; @param DH - Row
; @param DL - Col
f_setCurPos proc
			push ax
			push bx
			mov bh, 0
			mov ah, 2
			int 10h
			pop bx
			pop ax
			ret
f_setCurPos	endp
;
; Function prints an ascii character at the appropriate cursor locatoin
; @param (DL,DH) - Cursor Location
; @param CX - Number of characters to print
; @param BL - Color
; @param AL- Ascii Character
f_paint		proc
			push ax
			push bx
			call f_setCurPos
			mov bh, 0
			mov ah, 9
			int 10h
			pop bx
			pop ax
			ret
f_paint		endp
;
; Function readers the character at the specific cursor location
; @param dl - x cursor
; @param dh - y cursor
; @return al - ascii character
f_readChar	proc
			call f_setCurPos
			mov ah, 8
			int 10h
			ret
f_readChar	endp
;
; Function initializes the mouse
f_initMouse	proc
			push ax
			push bx
			mov ax, 0
			int 33h
			mov ax, 1
			int 33h
			pop bx
			pop ax
			ret
f_initMouse	endp
;
;
;  Delay routine, if we had no delay, then things would move so rapidly
;  we could not tell what was going on, and could not move the paddle
;  fast enough to keep up with the play!
;
DELAY      PROC
      PUSH  AX             ; save registers
      PUSH  DX
      MOV   DH,25          ; get cursor off screen area
      MOV   DL,0           ;      (cleaner appearence)
      CALL  f_setCurPos
      SUB   AX,AX          ; zero frequency for rest
      MOV   DX,5          ; delay of 0.25 secs is reasonable
      CALL  NOTE           ; execute delay
      POP   DX             ; restore registers
      POP   AX
      RET                  ; return to caller
DELAY      ENDP
;
;
;  Routine to play note on speaker
;
;      (AX)           Frequency in Hz (32 - 32000)
;      (DX)           Duration in units of 1/100 second
;      CALL  NOTE
;
;  Note: a frequency of zero, means rest (silence) for the indicated
;  time, allowing this routine to be used simply as a timing delay.
;
;  Definitions for timer gate control
;
CTRL      EQU   61H           ; timer gate control port
TIMR      EQU   00000001B     ; bit to turn timer on
SPKR      EQU   00000010B     ; bit to turn speaker on
;
;  Definitions of input/output ports to access timer chip
;
TCTL      EQU   043H          ; port for timer control
TCTR      EQU   042H          ; port for timer count values
;
;  Definitions of timer control values (to send to control port)
;
TSQW      EQU   10110110B     ; timer 2, 2 bytes, sq wave, binary
LATCH     EQU   10000000B     ; latch timer 2
;
;  Define 32 bit value used to set timer frequency
;
FRHI      EQU   0012H          ; timer frequency high (1193180 / 256)
FRLO      EQU   34DCH          ; timer low (1193180 mod 256)
;
NOTE      PROC
      PUSH  AX          ; save registers
      PUSH  BX
      PUSH  CX
      PUSH  DX
      PUSH  SI
      MOV   BX,AX          ; save frequency in BX
      MOV   CX,DX          ; save duration in CX
;
;  We handle the rest (silence) case by using an arbitrary frequency to
;  program the clock so that the normal approach for getting the right
;  delay functions, but we will leave the speaker off in this case.
;
      MOV   SI,BX          ; copy frequency to BX
      OR    BX,BX          ; test zero frequency (rest)
      JNZ   NOT1           ; jump if not
      MOV   BX,256         ; else reset to arbitrary non-zero
;
;  Initialize timer and set desired frequency
;
NOT1: MOV   AL,TSQW          ; set timer 2 in square wave mode
      OUT   TCTL,AL
      MOV   DX,FRHI          ; set DX:AX = 1193180 decimal
      MOV   AX,FRLO          ;      = clock frequency
      DIV   BX               ; divide by desired frequency
      OUT   TCTR,AL          ; output low order of divisor
      MOV   AL,AH            ; output high order of divisor
      OUT   TCTR,AL
;
;  Turn the timer on, and also the speaker (unless frequency 0 = rest)
;
      IN    AL,CTRL          ; read current contents of control port
      OR    AL,TIMR          ; turn timer on
      OR    SI,SI            ; test zero frequency
      JZ    NOT2             ; skip if so (leave speaker off)
      OR    AL,SPKR          ; else turn speaker on as well
;
;  Compute number of clock cycles required at this frequency
;
NOT2: OUT   CTRL,AL          ; rewrite control port
      XCHG  AX,BX            ; frequency to AX
      MUL   CX               ; frequency times secs/100 to DX:AX
      MOV   CX,100           ; divide by 100 to get number of beats
      DIV   CX
      SHL   AX,1             ; times 2 because two clocks/beat
      XCHG  AX,CX            ; count of clock cycles to CX
;
;  Loop through clock cycles
;
NOT3:      CALL  RCTR          ; read initial count
;
;  Loop to wait for clock count to get reset. The count goes from the
;  value we set down to 0, and then is reset back to the set value
;
NOT4: MOV   DX,AX          ; save previous count in DX
      CALL  RCTR           ; read count again
      CMP   AX,DX          ; compare new count : old count
      JB    NOT4           ; loop if new count is lower
      LOOP  NOT3           ; else reset, count down cycles
;
;  Wait is complete, so turn off clock and return
;
      IN    AL,CTRL           ; read current contents of port
      AND   AL,0FFH-TIMR-SPKR ; reset timer/speaker control bits
; note that the above statement is an equation
      OUT   CTRL,AL           ; rewrite control port
      POP   SI                ; restore registers
      POP   DX
      POP   CX
      POP   BX
      POP   AX
      RET               ; return to caller
NOTE      ENDP
;
;  Routine to read count, returns current timer 2 count in AX
;
RCTR      PROC
      MOV   AL,LATCH         ; latch the counter
      OUT   TCTL,AL          ; latch counter
      IN    AL,TCTR          ; read lsb of count
      MOV   AH,AL
      IN    AL,TCTR          ; read msb of count
      XCHG  AH,AL            ; count is in AX
      RET                    ; return to caller
RCTR      ENDP
;
;
;
;
; Function checks the next position and sets the new direction and position
; @param dl - x coord
; @param dh - y coord
; @return (dl,dh,al) - new positions and direction
f_chkNxtPos proc
			; first turn
			cmp dl, 13						; if(dl != 13) 
			jne cnpIf2						; { jump to next loop }
			cmp dh, 2						; else if(dh != 3)
			jne cnpIf1a						; { jump to next loop }
			mov dh, 5						; new dh loc
			mov dl, 12						; new dl loc
			mov al, 4						; movement down
			jmp chkExit
cnpIf1a:	cmp dh, 3
			jne cnpIf1b
			mov dh, 5
			mov dl, 11
			mov al, 4
			jmp chkExit
cnpIf1b:	cmp dh, 4
			jne cnpIf2
			mov dl, 10
			mov dh, 5
			mov al, 4
			jmp chkExit
			; second turn
cnpIf2:		cmp dh, 11
			jne cnpIf3
			cmp dl, 10
			jne cnpIf2a
			mov dh, 10
			mov dl, 13
			mov al, 1
			jmp chkExit
cnpIf2a:	cmp dl, 11
			jne cnpIf2b
			mov dl, 13
			mov dh, 9
			mov al, 1
			jmp chkExit
cnpIf2b:	cmp dl, 12
			jne cnpIf3
			mov dh, 8
			mov dl, 13
			mov al, 1
			jmp chkExit
			; third turn
cnpIf3:		cmp dl, 21
			jne cnpIf4
			cmp dh, 8
			jne chkIf3a
			mov al, 3
			mov dh, 7
			mov dl, 18
			jmp chkExit
chkIf3a:	cmp dh, 9
			jne chkIf3b
			mov dh, 7
			mov dl, 19
			mov al, 3
			jmp chkExit
chkIf3b:	cmp dh, 10
			jne cnpIf4
			mov dh, 7
			mov dl, 20
			mov al, 3
			jmp chkExit
			; fourth turn
cnpIf4:		cmp dh, 3
			jne cnpIf5
			cmp dl, 18
			jne chkIf4a
			mov dl, 21
			mov dh, 4
			mov al, 1
			jmp chkExit
chkIf4a:	cmp dl, 19
			jne chkIf4b
			mov dl, 21
			mov dh, 5
			mov al, 1
			jmp chkExit
chkIf4b:	cmp dl, 20
			jne cnpIf5
			mov dl, 21
			mov dh, 6
			mov al, 1
			jmp chkExit
			; fifth turn
cnpIf5:		cmp dl, 32
			jne cnpIf6
			cmp dh, 4
			jne chkIf5a
			mov dl, 31
			mov dh, 7
			mov al, 4
			jmp chkExit
chkIf5a:	cmp dh, 5
			jne chkIf5b
			mov dh, 7
			mov dl, 30
			mov al, 4
			jmp chkExit
chkIf5b:	cmp dh, 6
			jne cnpIf6
			mov dh, 7
			mov dl, 29
			mov al, 4
			jmp chkExit
			; sixth turn
cnpIf6:		cmp dh, 18
			jne cnpIf7
			cmp dl, 29
			jne chkIf6a
			mov dl, 28
			mov dh, 15
			mov al, 2
			jmp chkExit
chkIf6a:	cmp dl, 30
			jne chkIf6b
			mov dl, 28
			mov dh, 16
			mov al, 2
			jmp chkExit
chkIf6b:	cmp dl, 31
			jne cnpIf7
			mov dl, 28
			mov dh, 17
			mov al, 2
			jmp chkExit
			; seventh turn
cnpIf7:		cmp dl, 4
			jne cnpIf8
			cmp dh, 15
			jne chkIf7a
			mov dl, 5
			mov dh, 18
			mov al, 4
			jmp chkExit
chkIf7a:	cmp dh, 16
			jne chkIf7b
			mov dh, 18
			mov dl, 6
			mov al, 4
			jmp chkExit
chkIf7b:	cmp dh, 17
			jne cnpIf8
			mov dl, 7
			mov dh, 18
			mov al, 4
			jmp chkExit
			; eighth turn
cnpIf8:		cmp dh, 24
			jne cnpIf9
			cmp dl, 5
			jne chkIf8a
			mov dh, 23
			mov dl, 8
			mov al, 1
			jmp chkExit
chkIf8a:	cmp dl, 6
			jne chkIf8b
			mov dh, 22
			mov dl, 8
			mov al, 1
			jmp chkExit
chkIf8b:	cmp dl, 7
			jne cnpIf9
			mov dh, 21
			mov dl, 8
			mov al, 1
			jmp chkExit
			; ninth turn
cnpIf9:		cmp dl, 58
			jne cnpIf10
			cmp dh, 21
			jne chkIf9a
			mov dl, 55
			mov dh, 20
			mov al, 3
			jmp chkExit
chkIf9a:	cmp dh, 22
			jne chkIf9b
			mov dl, 56
			mov dh, 20
			mov al, 3
			jmp chkExit
chkIf9b:	cmp dh, 23
			jne cnpIf10
			mov dl, 57
			mov dh, 20
			mov al, 3
			jmp chkExit
			; tenth turn
cnpIf10:	cmp dh, 13
			jne cnpIf11
			cmp dl, 55
			jne chkIf10a
			mov dh, 16
			mov dl, 54
			mov al, 2
			jmp chkExit
chkIf10a:	cmp dl, 56
			jne chkIf10b
			mov dh, 15
			mov dl, 54
			mov al, 2
			jmp chkExit
chkIf10b:	cmp dl, 57
			jne cnpIf11
			mov dh, 14
			mov dl, 54
			mov al, 2
			jmp chkExit
			; eleventh turn
cnpIf11:	cmp dl, 37
			jne cnpIf12
			cmp dh, 14
			jne chkIf11a
			mov dh, 13
			mov dl, 40
			mov al, 3
			jmp chkExit
chkIf11a:	cmp dh, 15
			jne chkIf11b
			mov dh, 13
			mov dl, 39
			mov al, 3
			jmp chkExit
chkIf11b:	cmp dh, 16
			jne cnpIf12
			mov dh, 13
			mov dl, 38
			mov al, 3
			jmp chkExit
			; twelfth turn
cnpIf12:	cmp dh, 5
			jne cnpIf13
			cmp dl, 38
			jne chkIf12a
			mov dl, 41
			mov dh, 6
			mov al, 1
			jmp chkExit
chkIf12a:	cmp dl, 39
			jne chkIf12b
			mov dh, 7
			mov dl, 41
			mov al, 1
			jmp chkExit
chkIf12b:	cmp dl, 40
			jne cnpIf13
			mov dh, 8
			mov dl, 41
			mov al, 1
			jmp chkExit
			; thirteenth turn
cnpIf13:	cmp dl, 61
			jne chkExit						; there are no more paths
			cmp dh, 6
			jne chkIf13a
			mov dh, 5
			mov dl, 58
			mov al, 3
			jmp chkExit
chkIf13a:	cmp dh, 7
			jne chkIf13b
			mov dh, 5
			mov dl, 59
			mov al, 3
			jmp chkExit
chkIf13b:	cmp dh, 8
			jne chkExit						; there are no more paths
			mov dh, 5
			mov dl, 60
			mov al, 3
chkExit:	ret
f_chkNxtPos	endp
;
; Function draws the main path, also acts to clear off enemies
f_colorRoad	proc
			push ax
			push bx
			push cx
			mov al, roadAscii
			mov bl, roadColor
			; area A
			mov dl, 0
			mov dh, 2
			mov cx, 13
			mov tempReg2, 3
			call f_paintVert
			; area B
			mov dl, 10
			mov dh, 5
			mov cx, 3
			mov tempReg2, 6
			call f_paintVert
			; area C
			mov dl, 13
			mov dh, 8
			mov cx, 8
			mov tempReg2, 3
			call f_paintVert
			; area D
			mov dl, 18
			mov dh, 4
			mov cx, 3
			mov tempReg2, 4
			call f_paintVert
			; area E
			mov dl, 21
			mov dh, 4
			mov cx, 11
			mov tempReg2, 3
			call f_paintVert
			; area F
			mov dl, 29
			mov dh, 7
			mov cx, 3
			mov tempReg2, 11
			call f_paintVert
			; area G
			mov dl, 5
			mov dh, 15
			mov cx, 24
			mov tempReg2, 3
			call f_paintVert
			; area H
			mov dl, 5
			mov dh, 18
			mov cx, 3
			mov tempReg2, 6
			call f_paintVert
			; area I
			mov dl, 8
			mov dh, 21
			mov cx, 50
			mov tempReg2, 3
			call f_paintVert
			; area J
			mov dl, 55
			mov dh, 14
			mov cx, 3
			mov tempReg2, 7
			call f_paintVert
			; area K
			mov dl, 38
			mov dh, 14
			mov cx, 17
			mov tempReg2, 3
			call f_paintVert
			; area L
			mov dl, 38
			mov dh, 6
			mov cx, 3
			mov tempReg2, 8
			call f_paintVert
			; area M
			mov dl, 41
			mov dh, 6
			mov cx, 20
			mov tempReg2, 3
			call f_paintVert
			; area N
			mov dl, 58
			mov dh, 0
			mov cx, 3
			mov tempReg2, 6
			call f_paintVert
			pop cx
			pop bx
			pop ax
			ret
f_colorRoad	endp
;
; Function draws the grass field which the towers can be built on
f_drawField	proc
			mov al, field
			mov bl, fieldColor
			; area 1
			mov dx, 0
			mov cx, 14
			mov tempReg2, 1
			call f_paintVert
			; area 2
			mov dh, 0
			mov dl, 14
			mov cx, 3
			mov tempReg2, 7
			call f_paintVert
			; area 3
			mov dh, 0
			mov dl, 17
			mov cx, 16
			mov tempReg2, 3
			call f_paintVert
			; area 4
			mov dh, 0
			mov dl, 33
			mov cx, 24
			mov tempReg2, 5
			call f_paintVert
			; area 5
			mov dl, 33
			mov dh, 5
			mov cx, 4
			mov tempReg2, 15
			call f_paintVert
			; area 6
			mov dl, 9
			mov dh, 19
			mov cx, 24
			mov tempReg2, 1
			call f_paintVert
			; area 7
			mov dl, 37
			mov dh, 18
			mov cx, 17
			mov tempReg2, 2
			call f_paintVert
			; area 8
			mov dl, 0
			mov dh, 6
			mov tempReg2, 19
			mov cx, 4
			call f_paintVert
			; area 9
			mov dl, 4
			mov dh, 6
			mov tempReg2, 8
			mov cx, 5
			call f_paintVert
			; area 10
			mov dl, 9
			mov dh, 12
			mov cx, 13
			mov tempReg2, 2
			call f_paintVert
			; area 11
			mov dl, 22
			mov dh, 8
			mov cx, 6
			mov tempReg2, 6
			call f_paintVert
			; area 12
			mov dl, 62
			mov dh, 0
			mov cx, 3
			mov tempReg2, 10
			call f_paintVert
			; area 13
			mov dl, 42
			mov dh, 10			
			mov cx, 23
			mov tempReg2, 3
			call f_paintVert
			; area 14
			mov dl, 59
			mov dh, 13
			mov cx, 6
			mov tempReg2, 13
			call f_paintVert
			ret
f_drawField	endp
;
; Function draws the path which the enemies will be traveling at
f_drawPath	proc
			mov bl, pathColor 				; path color
			mov al, horzPath				; horizontal ascii char
			; (1,1) - (13,1)
			mov dh, 1
			mov dl, 0
			mov cx, 14
			call f_paint
			; (1,6) - (6,9)
			mov dh, 5
			mov cx, 10
			call f_paint
			; (13,8) - (17,8)
			mov dh, 7
			mov dl, 13
			mov cx, 5
			call f_paint
			; (9,11) - (21,21)
			mov dh, 11
			mov dl, 9
			mov cx, 13
			call f_paint
			;(17,4) - (32,4)
			mov dh, 3
			mov dl, 17
			mov cx, 16
			call f_paint
			; (21,8) - (28,8)
			mov dh, 7
			mov dl, 21
			mov cx, 8
			call f_paint
			; (4,15) - (28,15)
			mov dh, 14
			mov dl, 4
			mov cx, 25
			call f_paint
			; (8,19) - (32,19)
			mov dh, 18
			mov dl, 8
			mov cx, 25
			call f_paint
			; (8,21) - (53,21)
			mov dh, 20
			mov dl, 8
			mov cx, 46
			call f_paint
			; (4,25) - (58,25)
			mov dh, 24
			mov dl, 4
			mov cx, 55
			call f_paint
			; (37,16) - (54,16)
			mov dh, 17
			mov dl, 37
			mov cx, 17
			call f_paint
			; (41,13) - (58,13)
			mov dh, 13
			mov dl, 41
			mov cx, 18
			call f_paint
			; (41,9) - (61,9)
			mov dh, 9
			mov dl, 41
			mov cx, 21
			call f_paint
			; (37,5) - (56,5)
			mov dh, 5
			mov dl, 37
			mov cx, 20
			call f_paint
			mov cx, 1
			mov al, vertPath				; vertical ascii char
			; (13,3) - (13,7)
			mov dh, 2
			mov dl, 13
			mov tempReg2, 5
			call f_paintVert
			; (9,7) - (9,11)
			mov dh, 6
			mov dl, 9
			mov tempReg2, 5
			call f_paintVert
			;(17,5)-(17,7)
			mov dh, 4
			mov dl, 17
			mov tempReg2, 3
			call f_paintVert
			; (21,9) - (21,12)
			mov dh, 8
			mov dl, 21
			mov tempReg2, 3
			call f_paintVert
			;(28,9) - (28,14)
			mov dh, 8
			mov dl, 28
			mov tempReg2, 6
			call f_paintVert
			;(4,16) - (4,25)
			mov dh, 15
			mov dl, 4
			mov tempReg2, 9
			call f_paintVert
			; (32,5) - (32,18)
			mov dh, 4
			mov dl, 32
			mov tempReg2, 14
			call f_paintVert
			; (37,5) - (37,16)
			mov dh, 5
			mov dl, 37
			mov tempReg2, 12
			call f_paintVert
			; (41,10)-(41,12)
			mov dh, 10
			mov dl, 41
			mov tempReg2, 3
			call f_paintVert
			;(57,1) - (57,5)
			mov dh, 0
			mov dl, 57
			mov tempReg2, 5
			call f_paintVert
			;(53,18)-(53,20)
			mov dh, 18
			mov dl, 54
			mov tempReg2, 2
			call f_paintVert
			;(58,14) - (58,24)
			mov dh, 14
			mov dl, 58
			mov tempReg2, 10
			call f_paintVert
			; (61,1)-(61,8)
			mov dh, 0
			mov dl, 61
			mov tempReg2, 9
			call f_paintVert
			;(8,20)
			mov dh, 19
			mov dl, 8
			mov cx, 1
			call f_paint
			mov al, trPath
			; (13,1)
			mov dh, 1
			mov dl, 13
			call f_paint
			;(9,5)
			mov dh, 5
			mov dl, 9
			call f_paint
			;(28,7)
			mov dh, 7
			mov dl, 28
			call f_paint
			;(32,3)
			mov dh, 3
			mov dl, 32
			call f_paint
			;(58,13)
			mov dh, 13
			mov dl, 58
			call f_paint
			;(54,17)
			mov dh, 17
			mov dl, 54
			call f_paint
			mov al, blPath
			; (13,7)
			mov dh, 7
			mov dl, 13
			call f_paint
			; (9,12)
			mov dh, 11
			mov dl, 9
			call f_paint
			; (8,21)
			mov dh, 20
			mov dl, 8
			call f_paint
			; (4,25)
			mov dh, 24
			mov dl, 4
			call f_paint
			; (37,17)
			mov dh, 17
			mov dl, 37
			call f_paint
			; (41,13)
			mov dh, 13
			mov dl, 41
			call f_paint
			mov al, tlPath
			; (17,4)
			mov dh, 3
			mov dl, 17
			call f_paint
			; (21,7)
			mov dh, 7
			mov dl, 21
			call f_paint
			; (4,15)
			mov dh, 14
			mov dl, 4
			call f_paint
			; (8,19)
			mov dh, 18
			mov dl, 8
			call f_paint
			; (37,5)
			mov dh, 5
			mov dl, 37
			call f_paint
			; (41,9)
			mov dh, 9
			mov dl, 41
			call f_paint
			mov al, brPath
			; (17,8)
			mov dh, 7
			mov dl, 17
			call f_paint
			; (21,12)
			mov dh, 11
			mov dl, 21
			call f_paint
			; (28,15)
			mov dh, 14
			mov dl, 28
			call f_paint
			; (32,18)
			mov dh, 18
			mov dl, 32
			call f_paint
			; (54,20)
			mov dh, 20
			mov dl, 54
			call f_paint
			; (58,24)
			mov dh, 24
			mov dl, 58
			call f_paint
			; (61,9)
			mov dh, 9
			mov dl, 61
			call f_paint
			; (57,5)
			mov dh, 5
			mov dl, 57
			call f_paint
			ret
f_drawPath	endp
			end
			