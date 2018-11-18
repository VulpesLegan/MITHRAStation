// code/game/objects/items/devices/radio/radio.dm

/obj/item/device/radio
	action_button_name = "Toggle Emergency Function"		//helpful icon at top of screen.
	var/can_toggle_emergency_mode = TRUE		//Can the panic function be toggled?
	var/panic_enabled = FALSE
	
	//Storage variables.
	var/panic_prev_frequency
	var/panic_speaker_state
	var/panic_mic_state
	var/panic_frequency_lock = FALSE		//Is the frequency locked because of us?

/obj/item/device/radio/headset
	can_toggle_emergency_mode = FALSE		//regular headsets don't get a panic function.
	action_button_name = ""		//no panic alarm, so no helpful icon.

/obj/item/device/radio/ui_action_click()
	panic_alarm(usr)

//Panic alarm proc. Called when someone toggles the emergency function on their radio.
/obj/item/device/radio/proc/panic_alarm(mob/user, bypass_checks = FALSE)
	if(!user)		//Null check, so if you bypass stuff it doesn't break things
		user = usr
	ASSERT(user)	//null check, so if there wasn't a usr it doesn't break things.
	if(!src)		//null check.
		return FALSE

	if(!bypass_checks)		//Should the need arise, admins can bypass the checks (e.g. for events).
		if(!can_toggle_emergency_mode)		//can we even toggle it?
			return FALSE

		if(!(ishuman(user) || issilicon(user)))		//ghosts, simplemobs, etc
			to_chat(user, "<span class='warning'>You lack the required dexterity to toggle \the [src]'s panic function.</span>")
			return FALSE

		if(user.stat != CONSCIOUS)		//are we unconscious or dead?
			to_chat(user, "<span class='warning'>You cannot activate \the [src]'s panic function in your current state.</span>")
			return FALSE

		if(user.incapacitated & INCAPACITATION_DISABLED)		//If you are knocked down but conscious, stunned, or knocked out.
		// NOTE: Restraints (e.g. handcuffed) are intentionally left out of this check!
			to_chat(user, "<span class='warning'>You cannot activate \the [src]'s panic function in your current state.</span>")
			return FALSE

// All the checks have either passed or been bypassed so far, so we definitely CAN use the panic button.

	if(user.incapacitated & INCAPACITATION_DEFAULT)	//if we are restrained or fully buckled, it'll be a little bit harder to use our panic button.
		user.visible_message("<span class='warning'>[user] begins to reach for [src].</span>","<span class='notice'>You begin reaching for the panic button on [src].</span>")		//Give the hostage taker a chance to stop us.
		if(do_after(user, 5 SECONDS))
			toggle_panic_button(user, TRUE, FALSE)
			return TRUE
		else		//you were moved, so sad...
			to_chat(user,"<span class='warning'>You fail to activate \the [src]'s emergency function.</span>")
			return FALSE

	else		//we're not under arrest, so we get to go ahead and just press the damn thing.
		toggle_panic_button(user, TRUE, FALSE)
		return TRUE


/obj/item/device/radio/proc/toggle_panic_alarm(mob/user, sanity_checks_pass = FALSE, admin_called = TRUE)
	if(!sanity_checks_pass)
		/* 
		 *Okay, I'm going to go off on a tangent for a second here. This proc
		 * has NO sanity checks whatsoever. Therefore, we need to check and see
		 * if the proper sanity checks have already been performed. If they were
		 * not, then either the proc was called directly by admin intervention,
		 * or by a faulty passthrough. The admin_called parameter is only used 
		 * to tell if an adminstrator called the proc directly, and give feed-
		 * back to them to correct their mistake.
		 */
		if(admin_called)		//This was never set, so we assume admin intervention.
			//give feedback to the admin trying
			message_admins("[usr]/([usr.key]) - operating on \"[src]\" at ([loc.x], [loc.y], [loc.z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>JMP</a>): it is dangerous to call toggle_panic_alarm() directly, crashing proc")

			//log to console.
			CRASH("[usr] attempted to call proc directly without bypassing safeguards")
		else
			CRASH("[src] at [loc.x], [loc.y], [loc.z]: Sanity checks did not complete before this proc was called")

	if(wires.IsIndexCut(WIRE_TRANSMIT) || wires.IsIndexCut(WIRE_SIGNAL) || wires.IsIndexCut(WIRE_RECEIVE))		//all our wires gotta be intact, yo.
		to_chat(user, "<span class='warning'>\icon[src] Nothing happens...</span>")
		return FALSE

	panic_enabled = !panic_enabled		//toggle panic alarm
	to_chat(user, "<span class='notice'>You [panic_enabled ? "activate" : "deactivate"] \the [src]'s emergency function.</span>")
	if(panic_enabled)		//We're now enabled.
		//First things first, let's store our old frequency, mic and speaker states so we can recall them later.
		panic_prev_frequency = frequency	//frequency
		panic_speaker_state = listening		//speaker state
		panic_mic_state = broadcasting		//mic state
		
		//We also want to check and see if the frequency is locked. If not, we should lock it and make a note somewhere that we were the ones to lock it.
		if(!freqlock)
			freqlock = TRUE
			panic_frequency_lock = TRUE

		//now let's shut off our speaker, in case we're already on the panic alarm channel, so as not to tip off our assailants, and then broadcast a warning to those listening in that we're in trouble.
		listening = FALSE
		global_announcer.autosay("Radio emergency function activated by [user] in [get_area(src)]. Hotmike in 2 seconds.", "[src]", "Emergency")
		
		//wait 2 seconds before we hotmike.
		spawn(20)
			frequency = PANIC_FREQ
			broadcasting = TRUE			//Hotmike so emergency responders can hear what's going on around you, e.g. shouting
		return TRUE
	else		//We're now disabled.
		//Let everyone know the emergency has passed.
		global_announcer.autosay("Radio emergency function deactivated by [user].", "[src]", "Emergency")
		
		//recall our previous frequency, mic status, and speaker status.
		frequency = panic_prev_frequency
		listening = panic_speaker_state
		broadcasting = panic_mic_state
		
		//Check if the frequency was locked because of us. If so, clear that flag and unlock it.
		if(panic_frequency_lock)
			panic_frequency_lock = FALSE
			freqlock = FALSE
		return TRUE