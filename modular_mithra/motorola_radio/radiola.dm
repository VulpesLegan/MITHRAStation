/obj/item/device/radio/fluff/radiola
	name = "ruggedised radio"
	desc = "A Radiola Pro 7550 radio. Water-resistant to 20 metres, shock resistant, and features a full-colour display, industry-standard dedicated panic button, and a bettery life of up to 16 hours on a single charge."
	icon = 'modular_mithra/motorola_radio/xpr.dmi'		//todo add that in.
	icon_state = "xpr7550"
	description_fluff = "The Radiola Telecommunications Company was, once, the name to beat when it came to consumer- and professional-grade radio equipment and communicators. After a series of mergers, RTC eventually split into two smaller companies - Radiola Mobile Commmunications, Inc., and Radiola Solutions. After a hefty decline in sales, Radiola Mobile Communications went bankrupt and was acquired by Ward-Takahashi. Radiola Solutions continues to dominate the professional radio industry, but Ward-Takahashi has them cornered in the consumer-grade radio market."
	
/obj/item/device/radio/fluff/radiola/New()
	. = ..()
	update_icon()

/obj/item/device/radio/fluff/radiola/update_icon()
	icon_state = "[initial(icon_state)][on ? "-on" : ""]"
	

/obj/item/device/radio/fluff/radiola/blue		//it's got blue bits!
	icon_state = "xpr7550is"
	desc = "A Radiola Pro 7550-E radio. Water-resistant to 30 metres, shock resistant, and features a full-colour display, industry-standard dedicated panic button, and a bettery life of up to 12 hours on a single charge."