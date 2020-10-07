# Breakout-Game---System-Verilog (DE1_SOC)
This version of Breakout that we implemented, is a single player game that has one level with 50 bricks, a paddle, and a ball. The goal is to destroy every brick displayed in the game with the ball. The difficult part of this game is keeping the ball from hitting the bottom of the screen. The ball must only ricochet off the paddle. Usings the left and right keys on the keyboard, you can move the paddle to where you think the ball will fall next. The score of the game is kept on the HEX0, and HEX1 of the DE1_SoC board. For every brick destroyed, the player is awarded one point, and there is a total of 50 points available to be awarded. If the ball ever touches the bottom of the screen, the game is over, and the player is presented with a red screen. Likewise, when the player destroys all 50 blocks, they are presented with a fully green screen, and a score of 50.

The demonstrations below are created by my lab partner 
Link to brief DEMO: https://drive.google.com/file/d/1gL8194jqigkFkuEVFNLQLLOTgaAWnThU/view?usp=sharing
Link to Full DEMO: https://drive.google.com/file/d/1cIJjaEUw8DzCNWlmfwkVHgRa61dTYlJX/view?usp=sharing
