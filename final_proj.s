			area lab8, code, readonly


            export __main

__main     	proc
		
			;set up for pins on port 4. currently pins 0-5 are buttons
			ldr r5, = 0x40004C21
			mov r2, #0x00
			strb r2, [r5, r2] ;sets direction
			mov r2, #0xFF
			strb r2, [r5, #0x06]
			
			;set up for output and input pins on port5. port 0 will be input. the rest may be output
			ldr r7, =0x40004C40 ;port 5
			mov r2, #0x36
			strb r2, [r7, #0x04] ;sets direction
			mov r2, #0x01 ;activates resistor
			strb r2, [r7, #0x06]
			mov r2, #0x01
			strb r2, [r7, #0x02] ;sets it as pull up
			;-----------FINISHED WITH SET UP ------------
			b state0

			endp
				
				
state0		proc ;default locked state
			mov r2, #0x05
			strb r2, [r7, #0x02]
loop		ldrb r8, [r5, #0x00]
			cmp r8, #0x02 ;if correct button is pressed, go to next state
			beq state1
			cmp r8, #0x20 ;checks if the sentry mode button is pressed
			beq sentryMode
			b loop
			endp
state1		proc ;state after the first correct button is presed
			;bl unlocked1
			bl delay
			bl delay
loop2		ldrb r8, [r5, #0x00]
			;bl delay
			cmp r8, #0x01 ;if number 1 is pressed, goes to next state if this button is pressed
			beq state2
			cmp r8, #0x02 ;if number 2 is pressed, which is the wrong combo, return to state 0
			beq state0
			cmp r8, #0x04 ;if number 3 is pressed, which is the wrong combo, return to state 0
			beq state0
			cmp r8, #0x08 ;if number 4 is pressed, which is the wrong combo, return to state 0
			beq state0
			cmp r8, #0x10 ;if enter is pressed, which is the wrong combo, return to state 0
			beq state0
			cmp r8, #0x20 ;go to sentry mode
			beq sentryMode
			b loop2
			endp
state2		proc ;state after the second correct button is pressed
			;bl unlocked1
			bl delay
			;bl delay
loop3		ldrb r8, [r5, #0x00]
			cmp r8, #0x01 ;if number 1 is pressed, which is the wrong combo, return to state 0
			beq state0
			cmp r8, #0x02 ;if number 2 is pressed, which is the wrong combo, return to state 0
			beq state0
			cmp r8, #0x04 ;if number 3 is pressed, goes to next state if this button is pressed
			beq state3
			cmp r8, #0x08 ;if number 4 is pressed, which is the wrong combo, return to state 0
			beq state0
			cmp r8, #0x10 ;if enter is pressed, which is the wrong combo, return to state 0
			beq state0
			cmp r8, #0x20 ;go to sentry mode
			beq sentryMode
			b loop3
			endp
state3		proc ;stater after the third correct button is pressed
			bl delay
			bl delay
loop5		ldrb r8, [r5, #0x00]
			cmp r8, #0x01 ;if number 1 is pressed, which is the wrong combo, return to state 0
			beq state0
			cmp r8, #0x02 ;if number 2 is pressed, which is the wrong combo, return to state 0
			beq state0
			cmp r8, #0x04 ;if number 3 is pressed, which is the wrong combo, return to state 0
			beq state0
			cmp r8, #0x08 ;if number 4 is pressed goes to next state if this button is pressed
			beq state4
			cmp r8, #0x10 ;if enter is pressed, which is the wrong combo, return to state 0
			beq state0
			cmp r8, #0x20 ;goes to sentry mode
			beq sentryMode
			b loop5
			endp
state4		proc ;state after the fourth correct button is pressed.
			;bl unlocked1
			bl delay
loop6		ldrb r8, [r5, #0x00]
			;bl delay
			cmp r8, #0x01 ;if number 1 is pressed, which is the wrong combo, return to state 0
			beq state0
			cmp r8, #0x02 ;if number 2 is pressed, which is the wrong combo, return to state 0
			beq state0
			cmp r8, #0x04 ;if number 3 is pressed, which is the wrong combo, return to state 0
			beq state0
			cmp r8, #0x08 ;if number 4 is pressed remains in this state even if button 4 is pressed again
			beq state4
			cmp r8, #0x10 ;if enter is pressed unlocks if the enter button is pressed since the combo was correctly pressed.
			beq unlocked1
			cmp r8, #0x20 ;go to sentry mode
			beq sentryMode
			b loop6
			endp
unlocked1	proc ;trigers the motor and led
			;bl unlockedmsg
			mov r2, #0x33 ;temp move
			strb r2, [r7, #0x02] ;turns on the motor to turn it and turns on green led
			bl delay
			bl delay
			mov r2, #0x11
			strb r2, [r7, #0x02] ;turns off the motor but keeps green led on
waitlock	ldrb r8, [r5, #0x00] ;waits for the lock button to be pressed
			cmp r8, #0x10
			beq state0
			b waitlock
			endp

sentryMode	proc ;sentry mode logic
ino			ldrb r9, [r7, #0x00] ;loops to check if the sensor detects anything
			;logic here, if pin 0 is set to 0, ring buzzer until reset
			mov r12, #1;
			and r9, #0x01
			cmp r9, r12
			bne lol1
			b ino
lol1		ldrb r9, [r5, #0x00] ;starts the buzzer if something is detected until sentry button is pressed
			mov r12, #0x20
			cmp r9, r12
			beq state1
						
			mov r2, #0x25
			strb r2, [r7, #0x02]
			bl delay
			mov r2, #0x05
			strb r2, [r7, #0x02]
			bl delay
			b lol1
			endp
	
delay		proc		
			mov r10,#1000
yyy			mov r9, #100

xxx			subs r9, #1
			bne xxx
			subs r10, #1
			bne yyy
			bx lr
			endp
;exitt		proc
;			ldrh r1, [r0, #0x00]
;			orr r1, #0x0001
;			strh r1, [r0, #0x00]
;			
;			endp
			end