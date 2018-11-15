mob
	proc
		MessageAdmins(t as text) //a simple proc used to message any online admins ((looks to be terribly simple, and fundamentally flawed, will fix later))
			var/num //determines num of admins online
			for(var/mob/m in world) //loop through all people in world
				if(m.admin) //if they are an admin
					num += 1 //add 1 to the numofadmins var
					m << "[t]" //send message to the said admin

			if(num == 0) //if no admins online
				src << "\red Sorry, but there are no Administrators online!" //tell them so

		AdminProcess() //used for processing admin ranks and giving out appropriate verbs based on rank
			src.verbs += typesof(/mob/admin/verb)
			if(src.a_rank == "own")
				src.a_rank_num = 5
			if(src.a_rank == "sco")
				src.a_rank_num = 4
				src.verbs -= /mob/admin/verb/Strawberry
			if(src.a_rank == "co")
				src.a_rank_num = 3
				src.verbs -= /mob/admin/verb/Possess
				src.verbs -= /mob/admin/verb/Strawberry
			if(src.a_rank == "adm")
				src.a_rank_num = 2
				src.verbs -= /mob/admin/verb/Boot
				src.verbs -= /mob/admin/verb/Ban
				src.verbs -= /mob/admin/verb/Unban
				src.verbs -= /mob/admin/verb/Possess
				src.verbs -= /mob/admin/verb/Icon_Control
				src.verbs -= /mob/admin/verb/Rename
				src.verbs -= /mob/admin/verb/Play_Music
				src.verbs -= /mob/admin/verb/Stop_Music
				src.verbs -= /mob/admin/verb/Strawberry
			if(src.a_rank == "mod")
				src.a_rank_num = 1
				src.verbs -= /mob/admin/verb/Possess
				src.verbs -= /mob/admin/verb/Boot
				src.verbs -= /mob/admin/verb/Ban
				src.verbs -= /mob/admin/verb/Unban
				src.verbs -= /mob/admin/verb/Icon_Control
				src.verbs -= /mob/admin/verb/Gm_Control
				src.verbs -= /mob/admin/verb/Rename
				src.verbs -= /mob/admin/verb/Play_Music
				src.verbs -= /mob/admin/verb/Stop_Music
				src.verbs -= /mob/admin/verb/Strawberry
			if(src.a_rank == "")
				src.verbs -= typesof(/mob/admin/verb)

		Rank2Text() //used to turn the raw rank vars into understandable text
			var/rank = ""

			if(src.a_rank == "own")
				rank = "Owner"
				return rank
			if(src.a_rank == "sco")
				rank = "Special Co-Owner"
				return rank
			if(src.a_rank == "co")
				rank = "Co-Owner"
				return rank
			if(src.a_rank == "adm")
				rank = "Admin"
				return rank
			if(src.a_rank == "mod")
				rank = "Moderator"
				return rank
			if(src.a_rank == "")
				rank = "Player"
				return rank

		NumRankProcess() //Processes admin powers based on number (used in promotion/demotion)
			if(src.a_rank_num == 0)
				src.a_rank = ""
				src.AdminProcess()
				src.Save()
			if(src.a_rank_num == 1)
				src.a_rank = "mod"
				src.AdminProcess()
				src.Save()
			if(src.a_rank_num == 2)
				src.a_rank = "adm"
				src.AdminProcess()
				src.Save()
			if(src.a_rank_num == 3)
				src.a_rank = "co"
				src.AdminProcess()
				src.Save()
			if(src.a_rank_num == 4)
				src.a_rank = "sco"
				src.AdminProcess()
				src.Save()
			if(src.a_rank_num == 5)
				src.a_rank = "own"
				src.AdminProcess()
				src.Save()

		Evolve(reqlvl as num, reqis as text, nevo as text, nis as text)
			if(src.level >= reqlvl)
				if(src.icon_state == "[reqis]")
					switch(input(src, "Would you like to evolve into [nevo]?") in list("Yes", "No"))
						if("Yes")
							view() << "\green [src] is evolving..."
							sleep(25) //wait 2.5 seconds
							view() << "\green [src] has evolved into a [nevo]!"
							src.icon_state = "[nis]"
						if("No")
							src << "\red You chose not to evolve."
							return

		ExpReqCheck(n as num)
			var/expreq2 = round(sqrt(sqrt(round(src.expreq/4)**3)))
//			src.lvl += 1 //Debug Line
			src << "\red DEBUG: EXPReqCheck([n]): expreq2: [expreq2]"


			if(n >= 90)
				expreq2 += 100
//				src << "+100"

			else if(n >= 65)
				expreq2 += 60
//				src << "+60"

			else if(n >= 30)
				expreq2 += 30
//				src << "+30"

			else
				expreq2 += 15
//				src << "+15"


			src.expreq += expreq2

		ExpCalc(n as num)
			src.exp += round(sqrt(n*2)*2)*4+n

			src << "\red DEBUG: [src.exp] += [round(sqrt(n*2)*2)*4+n]"

			while(src.exp >= src.expreq)
				src.exp = src.exp-src.expreq
				src.LevelUp()

		LevelUp()

			src << "\green You have reached level [src.level+1]! Congrats!"

			src.level += 1
			src.ExpReqCheck(src.level)

			src.atk += round(src.level*1.2)-rand(1,src.level)
			src.def += round(src.level*1.2)-rand(1,src.level)
			src.satk += round(src.level*1.2)-rand(1,src.level)
			src.sdef += round(src.level*1.2)-rand(1,src.level)

			src.maxhp += round(sqrt(src.level*2))
			src.hp = src.maxhp

			src.Evolve(18, "turt", "Grotle", "grot")  //turtwig to grotle evo
			src.Evolve(32, "grot", "Torterra", "tort")  //grotle to torterra evo
			src.Evolve(16, "bulb", "Ivysaur", "ivy")  //bulbasaur to ivysaur evo
			src.Evolve(32, "ivy", "Venusaur", "venu")  //ivysaur to venusaur evo
			src.Evolve(16, "chik", "Bayleef", "bay")  //chikorita to bayleef evo
			src.Evolve(16, "tree", "Grovyle", "grov")  //treecko to grovyle evo
			src.Evolve(36, "grov", "Sceptile", "scep")  //grovyle to sceptile evo
			src.Evolve(32, "bay", "Meganium", "mega")  //bayleef to meganium evo

		atrTimer()
			src.atr = 0 //set ability to rename to zero
			src.atrtimer = 0 //redundancy check
			label2
			while(src.atrtimer<src.atrtimerpreset) //loop for timer
				sleep(1)
				src.atrtimer+=1
				goto label2

			src.atr = 1 //re-enable ability to rename once atrtimer = atrtimerpreset (5 minutes at time of typing this)
			src.atrtimer = 0 //another redundancy check lol