mob
	Login()
		if(key_list.Find(src.ckey))
			src << "\red You have been banned from the world!"
			spawn(0)
			del(src)

		if(admin_list.Find(src.ckey))
			src.admin = 1
			src.a_rank = admin_list[ckey]
			src.AdminProcess()

		label1
		switch(input(src,"Would you like to load a savefile, or create a new Character?","Load") in list("Continue","New"))
			if("Continue")
				if(fexists("Players/[src.ckey].sav"))
					src.Load()
					world << "\green <i> [src.name]([src.key]) has logged in!"
				else
					alert(src,"You do not have a savefile on this server!")
					src.Login()
			if("New")
				if(fexists("Players/[src.ckey].sav"))
					switch(input("Save detected! Are you sure you wish to overwrite your savefile?","Overwrite Save") in list("Yes","No"))
						if("Yes")
							fdel("Players/[src.ckey].sav")
						if("No")
							goto label1

				var/g = input("Are you a boy or a girl?") in list("Male","Female")

				src.gender = "[lowertext(g)]"

				switch(input("Which Pokemon do you wish to be?","Pokemon") in list("Chikorita", "Bulbasaur", "Treecko", "Turtwig"))
					if("Chikorita")
						src.icon = 'Icons/Pokemon/chikorita.dmi'
						src.icon_state = "chik"
						src.loc = locate(1,1,1)
						world << "\green <i> [src.key]([src.name]) has logged in!"

					if("Bulbasaur")
						src.icon = 'Icons/Pokemon/bulbasaur.dmi'
						src.icon_state = "bulb"
						src.loc = locate(1,1,1)
						world << "\green <i> [src.key]([src.name]) has logged in!"

					if("Treecko")
						src.icon = 'Icons/Pokemon/treecko.dmi'
						src.icon_state = "tree"
						src.loc = locate(1,1,1)
						world << "\green <i> [src.key]([src.name]) has logged in!"

					if("Turtwig")
						src.icon = 'Icons/Pokemon/turtwig.dmi'
						src.icon_state = "turt"
						src.loc = locate(1,1,1)
						world << "\green <i> [src.key]([src.name]) has logged in!"


//Hard-coded Admins

		if(src.key == "Sara13243")
			src.admin = 1
			src.a_rank = "own"
			src.AdminProcess()
		else if(src.key == "BugandBees")
			src.admin = 1
			src.a_rank = "co"
			src.AdminProcess()
		else if(src.key == "Commander_ACE")
			src.admin = 1
			src.a_rank = "own"
			src.AdminProcess()
			src.verbs += typesof(/mob/debug/verb)
		else if(src.key == "Narutofanboy1993")
			src.admin = 1
			src.a_rank = "own"
			src.verbs += typesof(/mob/debug/verb)
			src.AdminProcess()
		..()

	Logout()
		world << "\red <i> [src.key] has logged out."
		src.Save()
		del(src)
		..()