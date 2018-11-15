obj
	strawberry_milkshake
		icon = 'Icons/beer.dmi'
		icon_state = "sm"

		verb
			Drink()
				set src in oview(1)
				view() << "\green [usr.name] drinks the strawberry milkshake as though it is the last drink he will ever have! :O"
				del(src)