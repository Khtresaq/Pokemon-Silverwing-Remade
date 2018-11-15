mob/proc
	GenerateEditPage(mob/a as null|mob|obj|turf|area)
		var/k
		if(ismob(a)) //Just provides a nice little Heading to the entire page, this tidbit gets the key, and if it doesnt have one, tells us so
			if(!a.client)
				k = "<tt><font color=red>This Mob Has No Key</font></tt>"
			else
				k = "[a.key]"
		else
			k = "[a.name]"

		var/page
		page += "<br><center><b>Editing <u>[k]([a.name])</u></b><br><hr><br><table border=3>"
		for(var/v in a.vars)
			if(istype(a.vars[v], /list)) //Right now, List editing is not supported. So black any lists out.
				page += "<tr><td>[v]</td><td>[a.vars[v]]</td>"
			else if(isnull(a.vars[v]) | a.vars[v] == "") //if the variable is null, no value will show. So provide an edit link for them.
				page += "<tr><td>[v]</td><td><a href=byond://?command=edit;var=[v];mob=\ref[a]>\[Edit]</a></td>"
			else if(v == "key" | v == "ckey" | v == "client" | v == "atrtimer") //variable that you shouldnt edit are blacked out. (aka, not editable)
				page += "<tr><td>[v]</td><td>[a.vars[v]]</td>"
			else //anything else is ok to edit
				page += "<tr><td>[v]</td><td><a href=byond://?command=edit;var=[v];mob=\ref[a]>[a.vars[v]]</a></td>"

			if(istext(a.vars[v])) //tests to see what general type the variable is, and then prints it out to the last cell in the table row
				page += "<td>\[text]</td></tr>"
			else if(isnum(a.vars[v]))
				page += "<td>\[num]</td></tr>"
			else if(isnull(a.vars[v]))
				page += "<td>\[null]</td></tr>"
			else if(istype(a.vars[v], /list))
				page += "<td>\[list]</td></tr>"
			else if(isicon(a.vars[v]))
				page += "<td>\[icon] \icon[a] </td></tr>" //Simply displays the icon next to the type declaration if it is an icon
			else if(isloc(a.vars[v]))
				page += "<td>\[ref]</td></tr>"

		page += "</table></center><br>" //finish out the page generation, close all tags that havent yet been closed
		return page //returns the page variable.

client/Topic(href, list/href_list)
	var/command = href_list["command"]

	var/mob/a = locate(href_list["mob"])
	var/v = href_list["var"]

	//DEBUG LINE vvv
//	src << "Command was [command]. Var was [href_list["var"]]. Mob's name is [a.name]. Mob's key is [a.key]."
	//DEBUG LINE ^^^
	if(command == "edit")
		for(var/b in a.vars)
			if(b == v)
				var/default
				if(istext(a.vars[b]))
					default = "Text"
				else if(isnum(a.vars[b]))
					default = "Num"
				else if(isnull(a.vars[b]))
					default = "Text"
				else if(isicon(a.vars[b]))
					default = "Icon"
				else if(isfile(a.vars[b]))
					default = "File"

				var/typev = input("What type do you wish to make this variable?","Type Select",default) in list("Text","Num","Type","Reference",,"Icon","File","Cancel")

				if(typev == "Cancel")
					return

				switch(typev)
					if("Text")
						var/t = input("Please input \[text]") as text

						a.vars[b] = "[t]"
						var/page = src.mob.GenerateEditPage(a)
						src << browse(page)

					if("Num")
						var/n = input("Please input \[num]") as num

						a.vars[b] = n
						var/page = src.mob.GenerateEditPage(a)
						src << browse(page)

					if("Type")
						var/t = input("Select a Type") in typesof(/mob,/obj,/turf,/area)

						a.vars[b] = t
						var/page = src.mob.GenerateEditPage(a)
						src << browse(page)

					if("Reference")
						var/r = input("Select a Reference") as null|anything in world

						a.vars[b] = r
						var/page = src.mob.GenerateEditPage(a)
						src << browse(page)

					if("Icon")
						var/i = input("Select an Icon") as icon

						if(!isicon(i))
							src << "\red Not a valid icon!"
							return
						else if(!isfile(i))
							src << "\red Not a valid file!"
							return

						a.vars[b] = i
						var/page = src.mob.GenerateEditPage(a)
						src << browse(page)


					if("File")
						var/f = input("Select a File") as file

						a.vars[b] = f
						var/page = src.mob.GenerateEditPage(a)
						src << browse(page)