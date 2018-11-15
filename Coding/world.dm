var
	chatlogsay = file("clogworldsay.txt")
	chatlogooc = file("clogworldooc.txt")

world
	hub = "CommanderACE.PokemonSilverwing" //where the game will show up on Hub
	hub_password = "e0e601ac7c87182898362d9fa9640eca"
	turf = /turf/grass //default turf setting for world

	New()
		..()
		LoadBans() //Loads all the banned peoples (poor souls)
		LoadAdmins() // Loads all the admins (too many)

client/Move() //simply modifies the movement proc to incorporate not being able to move at all
	if(src.mob.move)
		..()
	else
		return