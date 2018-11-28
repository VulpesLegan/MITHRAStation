/obj/item/device/radio/fluff/radiola
	name = "\improper Radiola Pro 7550 two-way radio"
	desc = "A Radiola radio. Water-resistant to 20 metres, shock resistant, and features a full-colour display and a bettery life of up to 16 hours on a single charge. "
	icon = 'modular_mithra/motorola_radio/xpr.dmi'		//todo add that in.
	icon_state = "xpr7550"
	description_fluff = "The Radiola Telecommunications Company was, once, the name to beat when it came to consumer- and professional-grade radio equipment and communicators. After a series of mergers, RTC eventually split into two smaller companies - Radiola Mobile Commmunications, Inc., and Radiola Solutions. After a hefty decline in sales, Radiola Mobile Communications went bankrupt and was acquired by Ward-Takahashi. Radiola Solutions continues to dominate the professional radio industry, but Ward-Takahashi has them cornered in the consumer-grade radio market."

/obj/item/device/radio/fluff/radiola/update_icon()
	//Screen and keypad backlight
	var/image/screen_overlay = image(icon, "screen")	//Screen overlay is static, so we can get away with this here.
	screen_overlay.plane = PLANE_LIGHTING_ABOVE
	
	//LED at top
	var/image/led_overlay		//LED state is dynamic, so we can't declare a variable here yet.
	led_overlay.plane = PLANE_LIGHTING_ABOVE

	//LED state variable
	var/led_state = "ledamber-solid"

	//And now the fun begins.
	//First things first, let's stop looking at our overlays.
	overlays.Cut()

	//If we're on, let's show the screen overlay.
	if(on)
		overlays += screen_overlay
	
	//Now let's make our LED coloured.
	if(panic_enabled)		//if we're in panic alarm
		if(!listening)
			led_state = "ledred-panic"		//Isophase, red.
		else
			led_state = "ledred-solid"		//Solid red
	
	//if we're hotmiked
	else if(broadcasting)
		led_state = "ledgreen-hotmic"			//Flashing, green
		
	//if our radio is even on
	else if(listening)
		led_state = "ledamber-standby"			//Double-flashing, amber

	else
		led_state = "blank"				//nothing.

	led_overlay = image(icon, led_state)
	
	overlays += led_overlay