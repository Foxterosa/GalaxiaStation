/datum/job/slave
	title = JOB_PRISONER
	description = "Keep yourself occupied in jail or serve your master."
	department_head = list("The Security Team")
	faction = FACTION_STATION
	total_positions = 12		// NOVA EDIT: Original value (0)
	spawn_positions = 2
	supervisors = "the security team"
	exp_granted_type = EXP_TYPE_CREW
	paycheck = PAYCHECK_LOWER
	config_tag = "PRISONER"

	outfit = /datum/outfit/job/prisoner

	display_order = JOB_DISPLAY_ORDER_PRISONER
	department_for_prefs = /datum/job_department/assistant // NOVA EDIT - ORIGINAL: /datum/job_department/security

	exclusive_mail_goodies = TRUE
	mail_goodies = list (
		/obj/effect/spawner/random/contraband/prison = 1
	)

	family_heirlooms = list()
	rpg_title = "Defeated Miniboss"
	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN | JOB_CANNOT_OPEN_SLOTS

/datum/job/prisoner/New()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_CREWMEMBER_JOINED, PROC_REF(add_pref_crime))

/datum/job/prisoner/proc/add_pref_crime(datum/source, mob/living/crewmember, rank)
	SIGNAL_HANDLER
	if(rank != title)
		return //not a prisoner

	var/crime_name = crewmember.client?.prefs?.read_preference(/datum/preference/choiced/prisoner_crime)
	if(!crime_name)
		return
	if(crime_name == "Random")
		crime_name = pick(assoc_to_keys(GLOB.prisoner_crimes))

	var/datum/prisoner_crime/crime = GLOB.prisoner_crimes[crime_name]
	var/datum/record/crew/target_record = find_record(crewmember.real_name)
	var/datum/crime/past_crime = new(crime.name, crime.desc, "Central Command", "Indefinite.")
	target_record.crimes += past_crime
	to_chat(crewmember, span_warning("You are imprisoned for \"[crime_name]\"."))
	crewmember.add_mob_memory(/datum/memory/key/permabrig_crimes, crimes = crime_name)

/datum/outfit/job/prisoner
	name = "Prisoner"
	jobtype = /datum/job/prisoner

	id_trim = null
	uniform = null // NOVA EDIT ADD
	belt = null
	suit = null
	back = null
	ears = null
	shoes = null
	satchel = null
	duffelbag = null
	messenger = null
