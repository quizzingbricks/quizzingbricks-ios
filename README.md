Quizzing Bricks iOS application
==================

##Testing
Get Xcode 5.0 or later and iOS SDK 7.0 or later.
Open up the project in xcode and hit run.

Currently some parts use the old API and some parts the new. 
Login and Register works as intended. GET friends works but POST friends (add new friend) currently has some API differences. Working on solution.

##Features
###Registration
Allows you to enter an email-address and a password to create an account

###Login
Allows you to log in to your account.

###Create game
Creates a lobby and pushes the lobby-view.

###Join random
Currently not implemented, should just create a lobby with the randoms-allowd and invites dissabled by default and if possible match you in an existing lobby. The lobby will not be pushed and you have to check current games. Not sure if final.

###Current games
Not implemented. Should display both all the lobbies you are currently in and all the ongoing games. 

###Friends
Pushed a friends-view and allows you to view all your friend. The plus-sign in the upper right corner allows you to add a friend. Clicking done will always dismiss the view and failure or success is only determined by if the friend appears in the list or not. The list is updated automagically once the view is dismissed.

###Lobby view
Reached by either creating a game or by choosing an existing lobby in the current games list. The user can invite friends and ask to fill rest of slots with randoms. All users invited to this lobby is viewed and a status that shows if the user has accepted or not. This lobby will disapear once enough players have accepted. To reach the game you'll have to go back to current games and find it.

###Gameview
Dissabled in current state.
Shows a gameboard that allows you to click anywhere. Missing is the communication to the server on press and the question-view. 
