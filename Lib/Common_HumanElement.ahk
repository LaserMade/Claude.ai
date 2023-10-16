#Requires AutoHotkey v2+

:*:millitm::
{ ; V1toV2: Added bracket
SendLevel(1)
txt := "
(
Design:
Size: 11 ft. dia. x 13 ft.
Motor: 900 HP
Mill RPM: [unk] 
TPH (Max): 120 TPH
TPH (Used/Avg): 100 TPH
Ring Gear (Cast or Forged): Cast
Ring Gear Reversable?: [unk]
Rotation Reversal: N/A

Motor Design: 
HP: 900 hp
RPM: 897 rpm
FLA: 114 Amps
Voltage: 4.16 kV
Phase(s): 3 phases
Freq: 60 Hz
Relays (ANSI #s): 

Spares:
- Pinion gears  
- Motor
- ring gear (forged or cast?)
- bearings

ITM:
Temp Monitoring:
- Temp gun: every shift
Vib - continuous
NDE: Annual UT (Metzo); tracking/trending cracks (in-progress)
C&SD: Annual

Ring Gear: 
- Visuals:
   - Walkdown: Shift
   - Strobe inspection: Shift
   - Temp gun: Shift
   - Lube Oil visual - every shift
- IR scan: No. Discussed w/ site and showed examples
- Lining (PIN Profile)
   - Quarterly, replacements every 24 mo
   - Slurry racing inspections
- Charge monitoring - via kW

NDE:
Type: UT
Objects: trunnion (feed and disch.), ring gear, pinion, segment bolts
Indications: Yes
Last performed: 4/2023

Continuous Monitoring:
- Vibration: motor
- Temperature: bearings, L/O, ring gear L/O
- Pressure, Flow: bearing L/O

Additional Eqpt Notes:
Final Drive Pinion - inst

Extra History:
- Updated RV to $7.8 M per EVG
)"
A_Clipboard:= txt
Errorlevel := !ClipWait(1)
Send("^v")
return
} ; V1toV2: Added Bracket before hotkey or Hotstring


:*:elecitm::
{ ; V1toV2: Added bracket
SendLevel(1)
A_Clipboard:= ""
Sleep(100)
txt:="
(
[-Design-]
Single feed, to 13.8 kV switchgear; additional 13.8 kV swgr direct tie. Stepped down to 4160 and 2400 as needed

[-Notes-]
- Arc flash event 2/2019 in ER20.
- Main xfmr's oil was filtered in 2022 - tested-filtered-retested. DGA retest noted - No history - due to filtering.
- Arc-flash: 2019
- Swgr Replcmnt Proj: Started 2022

[-Special Note-] (AJB - 04/2023) 
The site was unable to validate the following statement included in a previous RR:
- The K2 DC drive was found to have an undersized breaker and was reportedly followed-up on by the plant immediately.

[-Xfmrs (>5MVA)-]
[Online]
Vis: D
IR: A
DGA/O: A
[Offline]
Testing: 3 yr
Last 2022
Prior: No
[5-4:Tbl 2]
Windings:
- Insul R
- Winding R
- PI
- Turns ratio
- pf/capacitance
Bushings:
- pf
- Capacitance
Core:
- Insul R

[-Xfmrs (<5MVA)-]
[Online]
Vis: D
IR: A
DGA/O: A
[Offline]
Testing: 3 yr
[5-20: Table 6]
- Low R
- Insul R
- pf
Last: 2022
Prev: No History

[-MV Swgr-]
[Online]
Vis: W
IR: A
PD: No
C/C/D/T: No
[Offline]
C/I/E: A
Bkr Testing:
- Tbl 1a: 3yr
- Tbl 1b: 3yr
Relay Testing: 3yr
Last: 2022
Prev: 2019
[Tbl 1a]
- Low R
- Contact R
- Insul. R
- Trip/Close Pwr
- Contact timing
- pf/diss.
- overpot

[-Batts-]
Date Code: 5/2021
C/D/T: No
Cool: No
[Online]
IR: No
Vis: M
W/T: M
Capacitance (Internal Ohmic): No
[Offline]
Capacity: No
[Rmt Mon]
Temp: No
Low Voltage: No

[-LV Swgr-]
[Online]
Vis: W
IR: A
C/D/T: Y
Clean: Ok
[Offline]
C/I/E: A
[5-20:Tbl 1]
- Low R
- Contact R
- Insul. R
- 1°/2° Inj testing
Last : 2022
Prev: 2019

[-EDG-] (quarry portable crusher)
ITM: S/A, A
No Loads: W
Load Xfr: M
Load Bank: A
Batts: rplc. 5yrs
)"
A_Clipboard:= txt
Errorlevel := !ClipWait(1)
Send("^v")
Sleep(100)
return
} ; V1toV2: Added bracket in the end
