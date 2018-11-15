mob
	verb
		/*
		Attack(mob/m as mob in get_step(src,src.dir)) //has to be facing a mob
			set category = "Attack"
			if(m.type == /mob/training_dummy) //code for what happens when attacking training dummies
				var/n = rand(src.atk-round(src.atk*0.1),src.atk+round(src.atk*0.1)) //a random number between -10% and +10% of the player's attack variable

				src << "\green Attacked Training Dummy for [n] damage!"

				m.hp -= n

				if(m.hp <= 0)
					view() << "\red <b> [m] has fainted!"
					m.Respawn(250, m) //calling respawn proc for training dummy


			else if(m.client) //code for what happens when attacking players
				src << "\green Attacked player."
		*/

		Attack2()
			set category = "Attack"
			if(!src.target)
				return
			else if(src.target.type == /mob/training_dummy) //code for what happens when attacking training dummies
				var/n = rand(src.atk-round(src.atk*0.1),src.atk+round(src.atk*0.1)) //a random number between -10% and +10% of the player's attack variable

				src << "\green Attacked Training Dummy for [n] damage!"
				src << "\red DEBUG: SRC.TARGET.LEVEL: [src.target.level]"

				src.target.hp -= n

				if(src.target.hp <= 0)
					view() << "\red <b> [src.target] has fainted!"
					src.target.Respawn(250, src.target) //calling respawn proc for training dummy


			else if(src.target.client) //code for what happens when attacking players
				src << "\green Attacked player."
			else
				return

	training_dummy
		icon = 'pikachu.dmi'
		icon_state = "Pikachu"
		name = "Training Dummy"

		var
			spawnloc //holds spawn location of training dummy

		New()
			..()
			spawnloc = loc //set spawn location
			level = rand(1,100)

	proc
		Respawn(n as num, var/mob/training_dummy/m as mob)
			usr.Untarget()
			m.loc = locate(1,1,2)
			usr.ExpCalc(m.level)
			sleep(n)
			m.hp = m.maxhp
			m.loc = m.spawnloc