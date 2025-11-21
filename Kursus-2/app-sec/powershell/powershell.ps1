foreach($user in Get-Content users.txt) {
	Invoke-Expression -Command "Echo 'Creating new user with name: $user'"
	#Do something to create the user in DB...
}