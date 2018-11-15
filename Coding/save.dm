//Save/Load coding borrowed from Pokemon Silverwing (Made by Commander_ACE)

mob
	proc
		Save()
			var/savefile/S = new/savefile("Players/[src.ckey].sav")

			S["last_x"] << x
			S["last_y"] << y
			S["last_z"] << z

			Write(S)

		Load()
			if(fexists("Players/[usr.ckey].sav"))
				var/savefile/S = new/savefile("Players/[src.ckey].sav")
				Read(S)

				var/last_x
				var/last_y
				var/last_z
				S["last_x"] >> last_x
				S["last_y"] >> last_y
				S["last_z"] >> last_z

				var/destination = locate(last_x, last_y, last_z)

				if (!Move(destination))
					loc = destination
