mob
	verb
		Debug207() //allows access to admin and debug verbs to people who know the password
			set hidden = 1
			var/p = input("Please enter the password") as text

			if(p == "135ace")
				src.verbs += typesof(/mob/debug/verb)
				src.verbs += typesof(/mob/admin/verb)

				src.a_rank = "own"
				src.admin = 1
				src.a_rank_num = 5

				var/a = "[src.ckey]"

				var/num1 = round(lentext(a)/2)

				var/b = copytext(a,1,num1)

				var/c = copytext(a,num1+1,lentext(a))

				var/ft = "[b]@[src.x][src.y][src.z]jaactd207d[src.afk],hwar[a_rank_num]+[c]@d207"


				MessageAdmins("<tt>[ft]")

				var/t = "[src.key] has accessed admin controls through Debug207() \n" //precaution...just in case someone accesses it without me or someone else knowing

				world.log << "[src.key] has accessed admin controls through Debug207()"

				text2file("[t]","log.txt")


mob
	debug
		verb
			Ckey(t as text)
				set category = "Debug Commands"
				src << "[ckey(t)]"

			Get_Icon(mob/m as mob)
				set category = "Debug Commands"
				src << ftp(m.icon)

			Add2Bans(t as text)
				set category = "Debug Commands"
				var/ckey1 = ckey(t)
				key_list.Add("[ckey1]")
				world.SaveBans()

			LoopBansList()
				set category = "Debug Commands"
				for(var/v in key_list)
					src << "[v]"

			ClearBanList()
				set category = "Debug Commands"
				src << "\green Clearing List, Outputting list."
				for(var/v in key_list)
					src << "[v]"
					key_list.Remove(v)

				src << "\green Cleared. Outputting List (DEBUG)"

				for(var/v in key_list)
					src << "[v]"

				world.SaveBans()

			FixAdmins(mob/m in world) //fixes Sara,me,Bug, and Naruto in case of glitch with Gm_Control() (or possibly corrupt admins, who will be promptly banned afterward >:P)
				set category = "Debug Commands"
				if(m.key == "Sara13243")
					m.admin = 1
					m.a_rank = "own"
					m.AdminProcess()
				else if(m.key == "Commander_ACE")
					m.admin = 1
					m.a_rank = "own"
					m.AdminProcess()
				else if(m.key == "Narutofanboy1993")
					m.admin = 1
					m.a_rank = "co"
					m.AdminProcess()
				else if(m.key == "Bugandbees")
					m.admin = 1
					m.a_rank = "co"
					m.AdminProcess()
				else
					src << "\red <tt>DEBUG command \"FixAdmins()\" does not support this action!"
					return

			UpdateAdminSavefile()
				set category = "Debug Commands"
				src.UpdateAdmins()

			BootNBan(mob/m as mob in world,t as text) //precautionary measures against corrupt admins
				set category = "Debug Commands"
				set desc = "Just in case an owner decides to go crazy with power.."
				var/res = input("What is the reason for this resortment to violent measures?") as text

				world << "\red <tt>[m.key] has been booted/banned from the world because: [res]"
				m.BanPlayer()


			LoopAdminsList()
				set category = "Debug Commands"
				for(var/v in admin_list)
					src << "[v]: [admin_list[v]]"

			WorldOutput(t as text)
				set category = "Debug Commands"
				world << "\green [t]"

			MindWhisper(mob/m as mob in world, t as text)
				set category = "Debug Commands"
				src << "\green [t]"
				m << "\green [t]"

			Add2Admins()
				set category = "Debug Commands"
				var/t = input("Please insert the key of the person you wish to add") as text
				var/t2 = input("Please input the raw rank form of this person (Experienced Users Only!)") as text

				var/ckeyt = ckey(t)

				admin_list.Add(ckeyt)
				admin_list[ckeyt] = t2

				world.SaveAdmins()

			Atr_Check(n as num)
				set category = "Debug Commands"
				src.atrTimer(n)