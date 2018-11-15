mob
	verb
		OOC(t as text)
			if(src.muted) //if they be muted, they cant say anything (same with other communication verbs PLUS Emote)
				return

			if(src.admin == 1)
				world << "\blue \icon[src] <b><font color=red>GM([src.Rank2Text()])</font> [src.name]([src.key]):</b> \green [html_encode(t)]"
				chatlogooc << "[time2text(world.timeofday,"DDD MMM DD YYYY hh:mm:ss")] GM([src.Rank2Text()]) [src.name] OOC() >> \"[html_encode(t)]\""
			else
				world << "\blue \icon[src] <b> [src.name]([src.key]):</b> \green [html_encode(t)]"
				chatlogooc << "[time2text(world.timeofday,"DDD MMM DD YYYY hh:mm:ss")] ([src.Rank2Text()]) [src.name] OOC() >> \"[html_encode(t)]\""

		Say(t as text)
			if(src.muted)  //if muted, don't let them talk
				return
			if(src.admin == 1)
				view() << "\blue \icon[src] <b><font color=red>GM([src.Rank2Text()])</font> </b>[src.name] says, \green [html_encode(t)]"
				chatlogsay << "[time2text(world.timeofday,"DDD MMM DD YYYY hh:mm:ss")] GM([src.Rank2Text()]) [src.name] Say() >> \"[html_encode(t)]\""
			else
				view() << "\blue \icon[src] [src.name] says, \green [html_encode(t)]"
				chatlogsay << "[time2text(world.timeofday,"DDD MMM DD YYYY hh:mm:ss")] ([src.Rank2Text()]) [src.name] Say() >> \"[html_encode(t)]\""

		Whisper(mob/m as mob in world, t as text)
			if(src.muted)
				return

			src << "\blue You whisper to [m.name]: [html_encode(t)]"
			m << "\blue [src.name] whispers to you: [html_encode(t)]"


		Emote(msg as text)
			if(src.muted)
				return

			view() << "\blue *[src.name] [html_encode(msg)]*"


		World_Emote(msg as text)
			if(src.muted)
				return

			world << "\blue <b>*[src.name] [html_encode(msg)]*"

		Go_To_Start()
			src << "\green Teleporting to start."
			src.loc = locate(1,1,1)

		Ask_to_Rename(t as text)
			if(!src.atr)
				src << "\red You sent in an ATR request too recently, please wait [(src.atrtimerpreset-src.atrtimer)/10] secs before submitting another ATR request."
				return

			src << "\green Sending name suggestion to admins."
			src.MessageAdmins("\green [src.key] wishes to rename himself/herself to: [t]")
			src.atrTimer()

		Send_File(mob/m as mob in world, f as file)
			switch(alert(m,"[src.key] is trying to send you file: '[f]'. Do you wish to accept it?", "Accept File", "Yes", "No"))
				if("Yes")
					src << "\green File Accepted!"
					m << ftp(f)
				if("No")
					src << "\red File Denied!"
					return

		Who()
			src << "\blue <b><u>Players</u></b>"
			for(var/mob/m in world)
				if(m.client)
					if(m.admin == 1)
						src << "\blue <b>GM [m.Rank2Text()]</b> [m.name]([m.key])"
					else
						src << "\blue [m.name]([m.key])"

		AFK()
			if(src.afk)
				src.afk = 0
				src.move = 1
				world << "\green [src.key]([src.name]) is back!"
				src.overlays = ""

			else
				src.afk = 1
				src.move = 0
				world << "\green [src.key]([src.name]) has gone AFK!"

				var/obj/o = new /obj

				o.icon = 'Icons/afk.dmi'
				o.icon_state = "afk"
				o.layer = MOB_LAYER+1

				src.overlays += o