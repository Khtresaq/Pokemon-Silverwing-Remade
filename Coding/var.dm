mob
	icon = 'Eevee.dmi' //determines a mob's default icon

	var
		muted = 0 //tells whether or not the person is muted (1 for muted, 0 for unmuted)
		admin = 0 //tells whether or not a person is an admin (1 for admin, 0 for non-admin)
		a_rank = "" //own, sco, co, adm, mod //tells what admin rank a person is (Rank2Text() Values defined below)
		//own = owner
		//sco = special co owner
		//co = co-owner
		//adm = admin
		//mod = moderator

		a_rank_num = 0 //number used in ranking admin powers
		afk = 0
		move = 1
		atr = 1 //ability to ask to rename
		atrtimerpreset = 3000 //amount of time this person must wait in between atr requests (1 = 10 milliseconds)

		pvp = 0 //1 = can be attacked by other players;0 = can not be attacked by other players

		level = 1 //level (duh)
		atk = 10 //attack
		def = 10 //defense
		satk = 5 //special attack
		sdef = 5 //special defense

		hp = 100
		maxhp = 100



		surf = 0

		exp = 0 //current exp
		expreq = 100 //exp required for level up

		tmp
			selpok
			n = 0
			atrtimer = 0
			targetting = 0
			mob
				target