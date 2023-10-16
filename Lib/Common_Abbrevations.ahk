; Section .....: Auto-Execution

SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
SetTitleMatchMode(2) ; sets title matching to search for "containing" instead of "exact"
DetectHiddenText(true)
DetectHiddenWindows(true)
#Requires Autohotkey v2.0
;---
; .............: End Section
;=======================================================================================================================
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; ----------------------------------------------------------------------------------------------------------------------
; Name .........: Common_Abbrevations
; Section ......: CHANGELOG
; Description ..: This is a hotstring library to call the MakeOSItalic() function [located in personal Lib folder]
; AHK Version ..: AHK 1.1+ x32/64 Unicode
; Author .......: Overcast (Adam Bacon), and Terry Keatts
; License ......: WTFPL - http://www.wtfpl.net/txt/copying/
; Changelog ....: 2/24/2023 ..: v1.0 - First version. 
; ..............: Status: Published
; ..............: Notes: Modified to correct a few standard titles and add the "densityf" hotstring with input for the varibles.
; ..............: Also modified to break this script out into a sub-script to make maintenance easier for users, so they
; ..............: are not forced to update the starter script with all the personal information, which likely won't change
; ..............: as much as the sub-scripts.
; ..............: 
; ..............: 03/06/2023 ..: v2.0 
; ..............: Status: Published
; ..............: Notes: Added the Shift+Ctrl+WIN+O hot key for fast launch of a specific OS.
; ..............: 
; ..............: 03/07/2023 ..: v3.0 
; ..............: Status: Published
; ..............: Notes: OS Titles now input in italics except for Horizon.
; ..............: 
; ..............: ??? .........: v?.?
; ..............: Status: Published
; ..............: Notes: OS Titles now input in italics for Horizon.
; ..............: 
; ..............: 04/11/2023 ..: v3.1 
; ..............: Status: Published
; ..............: Notes: Updated OS 10-1 title. Improved fast launch of OS GUI.
; ..............: 
; ..............: 04/27/2023 ..: v3.2 
; ..............: Status: Published
; ..............: Notes: Updated OS 7-11 title.
; ..............: 
; ..............: 05/03/2023 ..: v3.3 
; ..............: Status: Published
; ..............: Notes: Added case specific hot string areas to reduce rework on strange cases.
; ..............: 
; ..............: 05/30/2023 ..: v3.4 
; ..............: Status: Published
; ..............: Notes: Changed "sgsv" to "sgsvf" based on user feedback. Added "degf" for addeding a degree symbol.
; ..............: Notes: Added "degf" for addeding a degree symbol..
; ..............: 
; ..............: 05/31/2023 ..: v4.0 
; ..............: Status: Un-Published, Pending review by Terry Keatts
; ..............: Notes: Added #Hotstring C1 O B0
; ..............: Notes: #Hotstring EndChars f ; ===> the "f" can be modified to whatever you chose <===
; ..............: Cont.: ===> TODO <=== Make this an initial input for the user to choose. Currently set to existing "f"
; ..............: Notes: Added SendLevel 1 - this is to ensure that a hotstring can call another hotstring and/or hotkey
; ..............: Notes: All OS numbers and titles transferred to OSTitle.ini
; ..............: Notes: Modified hotstring modifier from :*:#-##:: to ::#-##:: => "*" = ending character not required.  
; ..............: Cont.: Added B0 to remove any backspacing (e.g., replacement previously used by ":*:")
; ..............: Notes: Removed "f" from end of hotstring (see above) => ::1-0f:: to ::1-0::
; ..............: Notes: See MakeOSItalic.ahk for additional details.
; ..............: Notes: Used this regex to update =>>> MakeOSItalic\("[0-9].*-[0-9].*, [a-z].*[A-Z].*+
; ..............: 
; ..............: 06/01/2023 ..: v5.0 
; ..............: Status: Un-Published, Pending review by Terry Keatts
; ..............: Notes: Used this regex to update =>>> MakeOSItalic\([A-z].*+\nreturn
; ..............: 
; ..............: 00/00/0000 ..: v0.0 
; ..............: Status: 
; ..............: Notes: 
; ********************************************** ... First Return ... **************************************************
;return
; --------------------------------------------------------------------------------

:*c:ahkf::AutoHotkey
:*c:ahkv2::AutoHotkey v2+
:*c:AHKf::AutoHotkey
:*c:ahk v2::AutoHotkey v2+
:*c:qapf::Quick Access Pop-up
:*c:QAPf::Quick Access Pop-up
; --------------------------------------------------------------------------------
;                          General Abbreviations ;#[AHK Script - General Abbreviations]
; --------------------------------------------------------------------------------
; #HotString C1 B O *
#HotString *
; #HotString EndChars f

; ................................................
:B0:msdn:: win32 
::potiential::potential
::accellerated::accelerated
::resiliancy::resiliency
::tendancy::tendency
::dsf::Data Sheet
::gsuf::generator step up (GSU)
::dgaf::dissolved gas analysis (DGA)
::as-builtf::as-built electrical single-line diagram
::delinieation::delineation
::agf::Approval Guide
::FMDSf::FM Global Property Loss Prevention Data Sheet
::sgsvf::seismic gas shutoff valve
:*:erpf::emergency response plan
:*:ferpf::flood emergency response plan
::wstf::water supply tool
::efcf::eFC
::wdtf::water delivery time
:*:wpivf::wall post-indicator valve
:*:pivf::post-indicator valve
:*:ulf::Underwriters Laboratories
:*:uupf::uncartoned unexpanded plastic
:*:uepf::uncartoned expanded plastic
:*:cupf::cartoned unexpanded plastic
:*:cepf::cartoned expanded plastic
:*:sopf::standard operating procedure (SOP)
:*:eopf::emergency operating procedure (EOP)
:*:oocf::out of commission (OOC)
:*:oshpd::Office of Statewide Health Planning and Development (OSHPD)
:*:hospitalinds::OSHPD
::ooof::out of office
::OSY::OS&Y
::sq.ft.::sq. ft.
:*:oemf::original equipment manufacturer (OEM)
:*:ndef::nondestructive examination (NDE)
:*:ndtf::nondestructive testing (NDT)
:*:ndetf::nondestructive examination/testing (NDE/T)
:*:mehpf::minimum end head pressure
:*:mawpf::maximum allowable working pressure (MAWP)
:*:mipf::metal insulating panels
::lwcof::low water cutout (LWCO)
::lwfcof::low water fuel cutoff
::lfpilf::low flash point ignitable liquid
::hfpilf::high flash point ignitable liquid
:*:lmgtfyf::https://letmegooglethat.com/?q=
:*:itmf::inspection, testing, and maintenance (ITM)
:*:irasf::in-rack automatic sprinklers
::ilf::ignitable liquid
:*:hrlf::higher RelativeLikelihood
:*:htff::heat transfer fluid
::gpf::generally protected
:*:FMRTPS::FM Global Red Tag Permit System
:*:FMHWPS::FM Global Hot Work Permit System
:*:DSf::Data Sheet
:*:FMAf::FM Approved
:*:FMILSC::FM Approved Ignitable Liquid Storage Cabinet
:*:FRPf::fiber-reinforced plastic panels
:*:epof::emergency power off
:*:blrbf::black liquor recovery boiler
::efile::eFile
:*:icsi::industrial control systems (ICS)
:*:icsf::industrial control systems (ICS), or the information/operational technology (IT/OT) networks
:*:otf::operational technology network (OT)
:*:itf::information technology network (IT)
:*:mfaf::multi factor authentication (MFA)
:*:bmf::boiler and machinery (B&M)
:*:fnhf::fire and natural hazards (F&NH)
:*:2oo3::two out of three-voting logic
:*:ostt::overspeed trip test
:*:o/sf::overspeed
:*:the majority of::most of
:*:in the near future::soon
:*:as a result of::because of
::recsf::recommendations
:*:cbtf::computer-based training
:*:recf::recommendation

:*:densityf::   ; input density and area in statement
{
    IB := InputBox("Density in gpm/sq. ft.", "Sprinkler System Density", "w300 h125"), density := IB.Value
    IB := InputBox("Area in sq. ft.", "Demand Area", "w300 h125"), area := IB.Value
    Send(density " gpm/sq. ft. over " area " sq. ft.")
    return
}

;---------------------------------------------------------------------------
;                    Brand Assurance Spellings/Language ;#[AHK Script - Brand Assurance corrections]
;---------------------------------------------------------------------------
:*:<FM>::FM Diamond
:*:FM diamond::FM Diamond
:*:FMGf::FM Global
:*:not FM approved::non-FM Approved
:*:not FM Approved::non-FM Approved
:*:non-storage sprinkler::nonstorage sprinkler
:*:bd.ft.::bd. ft.
:*:kvaf::kVA
:*:KVAf::kVA
; :*:hz::Hz
:*:HZf::Hz
:?*:KVf:: kV
:?*:kvf:: kV
:?*:KWf:: kW
:*:kwf::kW
:*:anti-virus::antivirus
:*:anti-siphon::antisiphon
:*:anti-freeze::antifreeze
:*:auto-ignite::autoignite
:*:built up roof::built-up roof
:*:C clamp::C-clamp
:*:cross main::crossmain
:*:feed main::feedmain
:*:branchline::branch line
:*:crawlspace::crawl space
:*:cyberattack::cyber attack
:*:cyber-attack::cyber attack
:*:cybersecurity::cyber security
:*:cybercrime::cyber crime
:*:cyberhygiene::cyber hygiene
:*:cyber space::cyberspace
:*:cyberwarfare::cyber warfare
:*:cyberrisk::cyber risk
:*:cyberevent::cyber event
:*:decision maker::decision-maker
:*:double row racks::double-row racks
:*:single row racks::single-row racks
:*:multi row racks::multi-row racks
:*:double stacked::double-stacked
:*:dry type system::dry-type system
:*:dry pipe valve::dry-pipe valve
:*:firewatch::fire watch
:*:four way brace::four-way brace
:*:guard house::guardhouse
:*:half life::half-life
:*:half full::half-full
:*:head end::headend
:*:K factor::K-factor
:*:liquid level indicator::liquid-level indicator
:*:low liquid level::low-liquid level
:*:multi-rack::multirack
:*:main frame::mainframe
:*:multi-story::multistory
:*:molded case circuit breaker::molded-case circuit breaker (MCCB)
:*:waste paper::wastepaper
:*:waste water::wastewater
:*:wild fire::wildfire
:*:wild land fire::wildland fire
:*:water tube::watertube
:*:fire tube::firetube
:*:i.e.::e.g.,
:*:fodf::foreign objects of destruction (FOD)
:*:bcpf::business continuity plan (BCP)
:*:ecpf::equipment contingency plan (ECP)
:*:frca::root cause analysis (RCA)
:*:rca::RCA
:*:rtdf::resistance temperature detector (RTD)
:*:rtdsf::resistance temperature detectors (RTDs)
:*:scrsf::silicon controlled rectifiers (SCRs)
:*:scrf::silicon controlled rectifier (SCR)
:*:irf::infrared thermographic scanning (IR)
:*:pdfs::partial discharge (PD)
:*:usfs::ultrasonic scanning
:*:fmef::foreign material exclusion (FME)
:*:fmes::FME
:*:LOTOf::lock-out tag-out (LOTO)
:*:asbuiltf::as-built electrical single-line diagram
:*:afhs::arc flash hazard analysis
:*:vrlaf::valve regulated lead acid (VRLA)
:*:vlaf::flooded/vented lead acid (VLA)
:*:NiCdf::Nickle Cadmium (NiCd)
:*:expidite::expedite
:*:knowledgable::knowledgeable



;---------------------------------------------------------------------------
;                           Inclusive Language
;---------------------------------------------------------------------------
:*:manned::attended
:*:man door::personnel door
:*:crewman::crew member
:*:chairman::chairperson
:*:fireman::firefighter
:*:foreman::supervisor
:*:manpower::workforce
:*:manhole::maintenance hole
:*:policeman::police officer
:*:spokesman::spokesperson
:*:undermanned::understaffed
:*:watchman::security guard
:*:whitelisting::allowlisting
:*:blacklisting::blocklisting
:*:whitelist::allowlist
:*:blacklist::blocklist