# microcontroller-final-project

We were tasked to create a functional program in assembly for the MSP432.

I chose to create a safelock system. It consits of 6 buttons, a motor, an obstacle sensor, and an RGB led. The first 4 buttons indicate the numbers 1-4, the 5th button is the enter button, and the 6th button sets the system to "sentry mode".

My thinking process behind the logic to enter the combination was seperating the program into different states. If the correct number is pressed, it moves on to the next state where it waits for the next number entry. It will continue moving up states until finally it reaches a state where if the combination is correct and the enter button is pressed, the system unlocks, triggering a motor to spin, changing the led to green, and buzzing the buzzer for a second.

If the wrong combination is pressed during the code entry phase, or if the lock button is pressed, the program returns to its default state.

During sentry mode, the obstacle sensor is activated. If it detects any object infront of it, it will cause the buzzer to constanly sound like an alarm and will lock the keypad until it is deactivated by pressing the sentry mode button again.
