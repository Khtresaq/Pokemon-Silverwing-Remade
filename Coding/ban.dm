//Holds all ban procs AND the procs having to do with admin saves

var
	key_list[0]
	admin_list[0]

mob
	proc

		BanPlayer() //Bans players based on key

			key_list.Add(src.ckey)
			world.SaveBans()

			del(src)

		UnBan(t as text) //unbans players by text input
			var/ckey = ckey(t)
			if(key_list.Find("[ckey]"))
				key_list.Remove(ckey)
				world.SaveBans()
			else
				src << "\red Error: Key not found in Bans list!"
				return

		UnBan2() //uses above proc, plus a little list looping to make the unban interface MUCH nicer
		//	var/list/bannedkeys = list()
		//	for(var/v in key_list)
		//		bannedkeys.Add(v)

			var/ubp = input("Which player do you wish to unban?","Unban") in key_list + "Cancel"

			if(ubp == "Cancel")
				return

			src.UnBan("[ubp]") //using above Unban proc to actually unban the player

			MessageAdmins("\green [src.key]([src.Rank2Text()]) has unbanned [ubp]")

		AddAdmin()
			admin_list.Add(src.ckey)
			admin_list[src.ckey] = src.a_rank

			world.SaveAdmins()

		RemoveAdmin()
			admin_list.Remove(src.ckey)

			world.SaveAdmins()


		UpdateAdmins() //will add all currently logged-on admins to the admin file (basically, a quick-n-easy way to add them, when the file may not have updated correctly when they were given GM)
		//	for(var/v in admin_list)
		//		admin_list.Remove(v)

			for(var/mob/m in world) //for every mob in the world
				if(m.client) //if they are a player
					if(m.admin == 1) //if they are an admin
						if(!admin_list.Find(m.ckey)) //if we cant find their name in the list of admins according to the savefile
							admin_list.Add("[m.ckey]") //add their key (in ckey form)
							admin_list[m.ckey] = m.a_rank //make their key have an association of their rank
							src << "\green [m.key] added!" //inform caller of proc this person has been NEWLY added
						else if(admin_list.Find(m.ckey)) //if we can find them
							if(admin_list[m.ckey] != m.a_rank) //and their rank is already up-to-date
								admin_list[m.ckey] = m.a_rank
								src << "\green [m.key]'s rank has been updated!" //tell caller that they are already in the admin_list
							else //if their rank is not up-to-date
								src << "\green [m.key] is already in <tt>\"admin_list\"" //tell the caller of this action

			src << "\green Complete!" //when we are done updating, tell the caller
			world.SaveAdmins() //lastly, save the admins list

world
	proc
		LoadBans()
			var/savefile/s = new/savefile("Bans.ban")

			s["key[0]"] >> key_list

			if(!length(key_list))
				key_list=list()

		SaveBans()
			var/savefile/s = new/savefile("Bans.ban")

			s["key[0]"] << key_list

		LoadAdmins()
			var/savefile/s = new/savefile("Admins.sav")

			s["key[0]"] >> admin_list

			if(!length(admin_list))
				admin_list = list()

		SaveAdmins()
			var/savefile/s = new/savefile("Admins.sav")

			s["key[0]"] << admin_list