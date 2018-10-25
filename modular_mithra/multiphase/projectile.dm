/*
	projectiles for the Multiphase port go here
*/

/obj/item/projectile/beam/stun/disabler
	name = "disabler beam"
	icon_state = "stun"
	taser_effect = 0
	agony = 20

	muzzle_type = /obj/effect/projectile/lightning/tracer
	tracer_type = /obj/effect/projectile/lightning/muzzle
	impact_type = /obj/effect/projectile/lightning/impact