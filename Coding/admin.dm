
mob
	admin
		verb
			Mute(mob/m as mob in world)
				set name = "Mute/Unmute"
				set category = "Admin"

				switch(input("Would you like to take away this person's ability to use Ask_to_Rename()? (So he wont possibly spam the admins using this command)","Mute") in list("Yes","No"))
					if("Yes")
						src.atr = 0
					if("No")
						src.atr = 1

				if(m.muted)
					m.muted = 0
					m.atr = 1
					src << "\green You have unmuted [m.key]"
					m << "\green <b>You have been unmuted!"
				else
					m.muted = 1
					src << "\red You have muted [m.key]"
					m << "\red <b>You have been muted!"

			Teleport(mob/m as mob in world)
				set category = "Admin"

				src.loc = m.loc
				view() << "\green [src.key] teleported to [m.key]'s location!"

			Summon(mob/m as mob in world)
				set category = "Admin"

				m.loc = src.loc
				view() << "\green [src.key] summons [m.key]!"

			Rename(mob/m as mob in world)
				set category = "Admin"

				var/t = input(src,"What do you wish to change [m.key]'s name to?","Name","[m.name]") as text

				if(t == "") //Prevents a freaking horrible glitch from occuring
					src << "\red <tt>Error: Command \"Rename()\" does not support this action! (No text entered into name field!)"
					return

				for(var/mob/M in world)
					if(M.name == "[t]")
						src << "\red <tt>Error: Command \"Rename()\" does not support this action! (Someone already has this name!)"
						return

				m.name = "[t]"
				m << "\green Your name has changed to \"[t]\"!"
				MessageAdmins("\green [src.key] successfully renamed [m.key] to \"[t]\"")

			Toggle_Density()
				set category = "Admin"
				if(src.density)
					src.density = 0
					view() << "\green [src.name] begins floating in the air!"
				else
					src.density = 1
					view() << "\green [src.name] lands gently on the ground!"

			Admin_Chat(t as text)
				set category = "Admin"
				MessageAdmins("\blue <b>Admin_Chat [src.key]([src.Rank2Text()]):</b> [t]")

			Delete(obj/a as turf|obj|area in world)
				set category = "Admin"
				del(a)

			Boot(mob/m in world)
				set category = "Admin"

				if(m.a_rank_num > src.a_rank_num)
					src << "\red Cant boot admins who are higher ranked than you!"
					return

				var/res = input("What is the reason that you're booting this person?") as text

				world << "\red <b> <center>[m.key] has been booted from the world!<br><br>\"[res]\""

				del(m)

			Gm_Control()
				set category = "Admin"
				var/list/ranks = list() //used to give GM Status
				var/list/options = list() //used to determin what certain ranks can do (strip/give/promote/demote)


				//protect against possibility of glitch happening, where a regular player might somehow get this verb

				if(src.admin == 0)
					src << "\red Error: Variable \[admin] is equal to 0!"
					MessageAdmins("\red Error: [src.key](a regular player) somehow has access to the Give_GM verb, his attempt at using it has been blocked. However, there is a possibility that his/her admin variable was edited to 0, please see to this incident immediately.")
					return
				if(src.a_rank == "")
					return

				//get the appropriate list ready determining who can give what ranks, and determine available options based on rank

				if(src.a_rank == "mod")
					return
				if(src.a_rank == "adm")
					ranks.Add("Moderator")
					options.Add("Give GM Status")
				//	options.Add("Demote a GM") //DEBUG
				if(src.a_rank == "co")
					ranks.Add("Moderator")
					ranks.Add("Admin")
					options.Add("Give GM Status")
					options.Add("Strip GM Status")
				//	options.Add("Demote a GM") //DEBUG
				if(src.a_rank == "sco")
					ranks.Add("Moderator")
					ranks.Add("Admin")
					ranks.Add("Co-Owner")
					options.Add("Give GM Status")
					options.Add("Strip GM Status")
				//	options.Add("Demote a GM") //DEBUG
				if(src.a_rank == "own")
					ranks.Add("Moderator")
					ranks.Add("Admin")
					ranks.Add("Co-Owner")
					ranks.Add("Special Co-Owner")
					ranks.Add("Owner")
					options.Add("Strip GM Status")
					options.Add("Give GM Status")
					options.Add("Demote a GM")
					options.Add("Promote a GM")

				switch(input("What do you wish to do?","GM Control()") in options + "Cancel")
					if("Give GM Status")
						var/mob/m = input("Which player do you wish to give this honor to?") as mob in world

						if(m.admin == 1)
							src << "\red He/she is already an admin!"
							return

						if(m == src)
							src << "\red You should already be an admin! (If, by some odd chance you arent...contact a coder immediately to fix this issue)"
							return

						switch(input("What rank do you wish to give [m.key]?","Rank") in ranks)
							if("Moderator")
								m.a_rank = "mod"
								m.admin = 1
								m.AdminProcess()
								m.AddAdmin()
								src.UpdateAdmins()
								world << "\green <b>[m.key] has been given [m.Rank2Text()] Status by [src.key]([src.Rank2Text()])"
							if("Admin")
								m.a_rank = "adm"
								m.admin = 1
								m.AdminProcess()
								m.AddAdmin()
								src.UpdateAdmins()
								world << "\green <b>[m.key] has been given [m.Rank2Text()] Status by [src.key]([src.Rank2Text()])"
							if("Co-Owner")
								m.a_rank = "co"
								m.admin = 1
								m.AdminProcess()
								m.AddAdmin()
								src.UpdateAdmins()
								world << "\green <b>[m.key] has been given [m.Rank2Text()] Status by [src.key]([src.Rank2Text()])"
							if("Special Co-Owner")
								m.a_rank = "sco"
								m.admin = 1
								m.AdminProcess()
								m.AddAdmin()
								src.UpdateAdmins()
								world << "\green <b>[m.key] has been given [m.Rank2Text()] Status by [src.key]([src.Rank2Text()])"
							if("Owner")
								m.a_rank = "own"
								m.admin = 1
								m.AdminProcess()
								m.AddAdmin()
								src.UpdateAdmins()
								world << "\green <b>[m.key] has been given [m.Rank2Text()] Status by [src.key]([src.Rank2Text()])"

					if("Strip GM Status")
						var/mob/m = input("Which player do you wish to strip of GM Status?","Strip GM") as mob in world

						if(m == src)
							src << "\red Cant strip yourself of your powers! (Dont see why you would want to anyway)"
							return

						if(m.a_rank_num > src.a_rank_num)
							src << "\red You cannot strip a higher ranked GM of his/her status!"
							return
						else
							world << "\red <b>[m.key] was stripped of [src.Rank2Text()] Status by [src.key]([src.Rank2Text()])"
							m.a_rank = ""
							m.admin = 0
							m.RemoveAdmin()
							m.AdminProcess()
							src.UpdateAdmins()
							m.Save()

					if("Promote a GM")
						var/mob/m = input("Which player do you wish to promote?") as mob in world

						if(m.a_rank == "own")
							src << "\red Can't promote [m.key] any further!"
							return

						if(m.a_rank_num > src.a_rank_num) //shouldnt happen at all...but...just in case
							src << "\red Cant promote people who are higher ranked than you!"
							return

						if(m == src)
							src << "\red Cant promote yourself!" //unable to promote yourself
							return

						m.a_rank_num += 1 //promote their rank by one
						m.NumRankProcess() //determins powers based on new rank
						src.UpdateAdmins() //update all current admins in world (updates admin savefile)
						m.Save() //save them //NOT NEEDED ANYMORE (well...it may be needed, further testing nesecarry)

						world << "\green <b>[m.key] was promoted to [m.Rank2Text()] Status by [src.key]([src.Rank2Text()])"

					if("Demote a GM")
						var/mob/m = input("Which player do you wish to demote?") as mob in world

						if(m.a_rank_num > src.a_rank_num)
							src << "\red Can't demote people who are higher ranked than you!"
							return

						if(m == src)
							src << "\red Cant demote yourself! (Dont see why you would want to anyway)"
							return

						if(m.a_rank_num == 0)
							src << "\red They aren't admins!"
							return

						m.a_rank_num -= 1 //demote their rank by one
						m.NumRankProcess() //determine powers based on new rank
						src.UpdateAdmins() //update all the current admins (updates admin savefile)
						m.Save() //save them //NOT NEEDED ANYMORE

						world << "\red <b>[m.key] was demoted to [m.Rank2Text()] Status by [src.key]([src.Rank2Text()])"

					if("Cancel")
						return



			Possess()
				set category = "Admin"

				var/mob/m = input("Which player do you wish to speak as?", "Player") as mob in world

				switch(input("Do you wish to make him/her Say, use OOC, or Whisper?","Chat method") in list("Say","OOC","Whisper","Emote","World Emote"))
					if("Say")
						var/t = input("What do you wish him/her to say?") as text

						m.Say("[t]")
					if("OOC")
						var/t = input("What do you wish him/her to say?") as text

						m.OOC("[t]")
					if("Whisper")
						var/mob/m2 = input("Who will this person whisper to?") as mob in world
						var/t = input("What do you wish him/her to say?") as text

						m.Whisper(m2,"[t]")

						src << "\blue [m.key] whispers to [m.key]: [html_encode(t)]"
					if("Emote")
						var/t = input("What do you wish him/her to emote?") as text

						m.Emote("[html_encode(t)]")
					if("World Emote")
						var/t = input("What do you wish him/her to emote?") as text

						m.World_Emote("[html_encode(t)]")

			Icon_Control()
				set category = "Admin"
				switch(input("What would you like to do?","Icon_Control()") in list("Change my Icon", "Change my Icon State", "Change another player's Icon", "Change another player's Icon State"))
					if("Change my Icon")
						var/I = input("Please select an icon") as file

						if(!isicon(I))
							src << "\red Error: Not an Icon!"
							return
						if(!isfile(I))
							src << "\red Error: Not a valid file!"
							return

						var/list/icon_states = icon_states(I)

						var/i = input(src,"Choose Icon State", "Icon_State") as null|anything in icon_states + "null"

						src.icon = I
						src.icon_state = i

					if("Change my Icon State")
						var/list/icon_states = icon_states(src.icon)

						var/i = input(src,"Choose Icon State", "Icon_State") as null|anything in icon_states + "null"

						src.icon_state = i

					if("Change another player's Icon")
						var/mob/m = input("Please select the player you wish to change.") as mob in world
						var/I = input("Please select an icon") as file

						if(!isicon(I))
							src << "\red Error: Not an Icon!"
							return
						if(!isfile(I))
							src << "\red Error: Not a valid file!"
							return

						var/list/icon_states = icon_states(I)

						var/i = input(src,"Choose Icon State", "Icon_State") as null|anything in icon_states + "null"

						m.icon = I
						m.icon_state = i

					if("Change another player's Icon State")
						var/mob/m = input("Please select the player you wish to change.") as mob in world
						var/list/icon_states = icon_states(m.icon)

						var/i = input(src,"Choose Icon State", "Icon_State") as null|anything in icon_states + "null"

						m.icon_state = i

			Ban(mob/m as mob in world)
				set category = "Admin"

				if(m.admin == 1)
					src << "\red Cant ban admins!"
					return

				world << "\red <b>[m.key] has been banned from the world by [src.key]!"
				m.BanPlayer()

			Unban()
				set category = "Admin"
				if(!length(key_list))
					src << "\red No keys appear to be banned (Which is a good thing I would assume :P)"
					return
				src.UnBan2()

			Reboot_World()
				set category = "Admin"
				world << "\red <center><b>Rebooting in 10 Seconds!</b>"
				sleep(50)
				world << "\red <center><b>5 Seconds!</b>"
				sleep(50)
				world << "\red <center><b>Rebooting!</b>"
				world.Reboot()

			Play_Music(f as file)
				set category = "Admin"
				if(!isfile(f))
					src << "\red Error: Not a valid file!"
					return
				world << "\green [src.key] plays \"[f]\"!"
				world << sound(f)

			Stop_Music()
				set category = "Admin"
				world << "\green [src.key] stops the music!"
				world << sound(null)

			Strawberry()
				set name = "Make Bug a Strawberry Milkshake Because Our Lives Depend On It :o"
				set category = "Admin"

				for(var/mob/m in world)
					if(m.key == "Bugandbees")
						m.icon = 'Icons/beer.dmi'
						m.icon_state = "sm"

						new /obj/strawberry_milkshake (m.loc)

			Edit(a as null|mob|obj|turf|area in world)
				set category = "Admin"

				var/page = GenerateEditPage(a)
				src << browse(page)