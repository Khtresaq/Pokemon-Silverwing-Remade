mob
	DblClick()
		if(usr == src)
			return

		if(usr.targetting)
			if(usr.target == src)
				usr.Untarget()
				return

			usr.Untarget()
			usr.Target(src)

		else
			usr.Target(src)

	proc
		Untarget()
			src.target = null
			src.client.images = null
			src.targetting = 0

		Target(mob/m as mob)
			src.target = m
			var/image/i = image('target.dmi',m)
			src << i
			src.targetting = 1

client
	Move()
		if(ismob(src.mob.target))
			if(get_dist(src.mob.target,src.mob) > 5)
				src.mob.Untarget()

		..()