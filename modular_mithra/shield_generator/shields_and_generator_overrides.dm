// /code/modules/shieldgen/shield_gen.dm

/obj/machinery/shield_gen		//Bubble Shield Generator
	max_strengthen_rate = 0.5		//originally 0.5
	energy_conversion_rate = 0.0009		//originally 6/10'000
	max_field_strength = 12		//originally 10; would be 12.5, but I don't want
								//to deal with rounding.

/obj/machinery/shield_gen/advanced		//Advanced Bubble Shield Generator
	energy_conversion_rate = 0.0018		//originally 12/10'000
	max_field_strength = 15		//originally 10

// /code/modules/shieldgen/shield_gen_external.dm

/*
/obj/machinery/shield_gen/external		//Hull Shield Generator
		//Inherits from above, theoretically. No code required here.
*/

/obj/machinery/shield_gen/external/advanced		//Advanced Hull Shield Generator
	energy_conversion_rate = 0.0018		//originally 12/10'000
	max_field_strength = 15		//originally 10

// /code/modules/shieldgen/energy_field.dm

/obj/effect/energy_field		//Energy Shield Field
/* 
 * Impact divisor is used in calculating how much damage to the shields a meteor
 * will do. Lower numbers here mean the meteor will do more damage to the shield
 * and the station is more at risk. The actual maths is as follows:
 *
 * adjust_strength(-max((meteor.wall_power * meteor.hits) / impact_divisor, 0))
 */

	impact_divisor = 800		//Default: 800
