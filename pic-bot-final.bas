; 	Variable Index:

; 	b0 --> Stores a random number for turns
;	b1 --> Stores the count during for loops
; 	b2,b3,b4,b5 --> Button press variables

startup:		; Plays startup tune and flashes orange LED briefly
			tune B.4, 5, ($47,$45,$42,$0A) ; Plays the startup tune
			
			for b1 = 0 to 7 step 1 ; Flashes the orange LED a few times
				toggle B.3
				pause 200
			next

			pause 500
			goto moveForward ; Robot begins to move forward

moveForward:	; Moves the robot forward infinitely until a button is triggered, Green LEDs ON
			low B.1 ; Moves robot forwards and green LEDs turn on
			low B.3
			low B.6
			high B.2 
			high B.7
		
			random w0 ; Cycles to the next random number (for varying CW/CCW turns)
			
			button C.0,1,200,255,b2,1,leftBumper ; Check for button press on left (C.0)
			button C.1,1,200,255,b3,1,rightBumper ; Check for button press on right (C.1)
			button C.5,1,200,255,b5,1,pauseBot ; Check for pause button press (C.5)
				
			goto moveForward ; Loops the move forward command
			
leftBumper:		; Code that runs on front left bumper press (C.0)
			low B.1 ; Brakes robot and red LEDs turns on
			low B.2
			low B.6
			low B.7 			
			high B.5
			
			tune B.4, 5, ($47,$45,$6A,$00) ; Plays the bumper sound effect
			pause 1250
			low B.5 ; Turns the red LED off
			
			for b1 = 0 to 125 step 1 
				high B.1 ; Moves Backward, both yellow LEDs on
				high B.6
				button C.2,1,200,255,b4,1,backBumper ; Check for back button press (C.2)
				button C.5,1,200,255,b5,1,pauseBot ; Check for pause button press (C.5)
				pause 10
			next
			gosub resetM ; Resets motor values
			
			for b1 = 0 to 100 step 1 
				high B.2 ; Turns CW (Left turn), one green and one yellow LED on
				high B.6
				button C.5,1,200,255,b5,1,pauseBot ; Check for pause button press (C.5)
				pause 10
			next 
		
			for b1 = 0 to b0 step 2 ; Turns CW for an additional random time 
				high B.2
				high B.6
				button C.5,1,200,255,b5,1,pauseBot ; Check for pause button press (C.5)
				pause 10
			next
			gosub resetM ; Resets motor values
			
			goto moveForward ; Robot resumes moving forward

rightBumper:	; Runs code on right button press (C.1)
			low B.1 ; Brakes robot and red LEDs turns on
			low B.2
			low B.6
			low B.7 			
			high B.5
			
			tune B.4, 5, ($47,$45,$6A,$00) ; Plays the bumper sound effect
			pause 1250
			low B.5 ; Turns the red LEDs off

			for b1 = 0 to 125 step 1 
				high B.1 ; Moves backward, both yellow LEDs on
				high B.6
				button C.2,1,200,255,b4,1,backBumper ; Check for back button press (C.2)
				button C.5,1,200,255,b5,1,pauseBot ; Check for pause button press (C.5)
				pause 10
			next
			gosub resetM ; Resets motor values
			
			for b1 = 0 to 100 step 1 
				high B.1 ; Turns CCW (left turn), one green and one yellow LED on
				high B.7
				button C.5,1,200,255,b5,1,pauseBot ; Check for pause button press (C.5)
				pause 10
			next
		
			for b1 = 0 to b0 step 2 ; Turns CCW for an additional random time
				high B.1
				high B.7
				button C.5,1,200,255,b5,1,pauseBot ; Check for pause button press (C.5)
				pause 10
			next
			gosub resetM ; Resets motor values
			
			goto moveForward ; Robot resumes moving forward

backBumper:		;Runs code on back button press (C.2)		
			tune B.4, 5, ($47,$45,$6A,$00) ; Plays the bumper sound effect
			
			gosub resetM ; Resets the motor values
			
			for b1 = 0 to 125 step 1 
				high B.2 ; Moves forward, both green LEDs on
				high B.7
				button C.5,1,200,255,b5,1,pauseBot ; Check for pause button press (C.5)
				pause 10
			next
			gosub resetM ; Resets the motor values
			
			for b1 = 0 to b0 step 1 
				high B.2 ; Turns CW for an random amount of time, one yellow/one green LED on
				high B.6
				pause 10 
				button C.5,1,200,255,b5,1,pauseBot ; Check for pause button press (C.5)
			next
			gosub resetM ; Resets the motor values
			
			goto moveForward ; Robot resumes moving forward
			
pauseBot:		; Stops the robot when a push button (C.5) is pressed, resumes when button is pressed again 
			low B.1 ; Brakes the robot
			low B.2
			low B.6
			low B.7 
			
			do ; loop here until the pause is cleared (C.5 pressed again)
				pause 250 
				toggle B.3 ; Flashes the orange LED
				button C.5,1,200,255,b5,1,gracePeriod ; Check for button press to resume movement
			loop while pinC.5 = 0
		
gracePeriod: 	; Delay on the resuming of the robot movement after a pause is ended
			pause 1500
			goto moveForward ; Robot begins to move forward again
			
resetM:		; Resets all the h-bridge inputs, is used every time motors must change direction
			low B.1
			low B.2
			low B.6
			low B.7
			
			pause 100
			return ; Returns back to the previous location (before resetM was called)