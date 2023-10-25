#Requires AutoHotkey v2
#Include <Directives\__AE.v2>
; --------------------------------------------------------------------------------
/**
 * @function Common_Abbrevations
*/
; --------------------------------------------------------------------------------

; --------------------------------------------------------------------------------
; Section .....: Functions
; Function ....: Run() script function and scripts
; --------------------------------------------------------------------------------
OSTitle := Map(
    "1-0", "1-0, ",
    "1-0t", "Safeguards During Construction, Alteration and Demolition",
    "1-1", "1-1, ",
    "1-1t", "Firesafe Building Construction and Materials",
)
return
:*:1-0f:: 
{
SendLevel(1)
Send("1-0, ")
Sleep(100)
Send("^i")
Send("Safeguards During Construction, Alteration and Demolition")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-1f::
{
SendLevel(1)
Send("1-1, ")
Sleep(100)
Send("^i")
Send("Firesafe Building Construction and Materials")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-2f::
{
SendLevel(1)
Send("1-2, ")
Sleep(100)
Send("^i")
Send("Earthquakes")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-3f::
{
SendLevel(1)
Send("1-3, ")
Sleep(100)
Send("^i")
Send("High-Rise Buildings")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-4f::
{
SendLevel(1)
Send("1-4, ")
Sleep(100)
Send("^i")
Send("Fire Tests")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-6f::
{
SendLevel(1)
Send("1-6, ")
Sleep(100)
Send("^i")
Send("Cooling Towers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-8f::
{
SendLevel(1)
Send("1-8, ")
Sleep(100)
Send("^i")
Send("Antenna Towers and Signs")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-9f::
{
SendLevel(1)
Send("1-9, ")
Sleep(100)
Send("^i")
Send("Roof Anchorage for Older, Wood-Roofed Buildings")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-10f::
{
SendLevel(1)
Send("1-10, ")
Sleep(100)
Send("^i")
Send("Smoke and Heat Venting in Sprinklered Buildings")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-11f::
{
SendLevel(1)
Send("1-11, ")
Sleep(100)
Send("^i")
Send("Fire Following Earthquakes")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-12f::
{
SendLevel(1)
Send("1-12, ")
Sleep(100)
Send("^i")
Send("Ceilings and Concealed Spaces")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-13f::
{
SendLevel(1)
Send("1-13, ")
Sleep(100)
Send("^i")
Send("Chimneys")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-15f::
{
SendLevel(1)
Send("1-15, ")
Sleep(100)
Send("^i")
Send("Roof Mounted Solar Photovoltaic Panels")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-17f::
{
SendLevel(1)
Send("1-17, ")
Sleep(100)
Send("^i")
Send("Reflective Ceiling Insulation")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-20f::
{
SendLevel(1)
Send("1-20, ")
Sleep(100)
Send("^i")
Send("Protection Against Exterior Fire Exposure")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-21f::
{
SendLevel(1)
Send("1-21, ")
Sleep(100)
Send("^i")
Send("Fire Resistance of Building Assemblies")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-22f::
{
SendLevel(1)
Send("1-22, ")
Sleep(100)
Send("^i")
Send("Maximum Foreseeable Loss")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-24f::
{
SendLevel(1)
Send("1-24, ")
Sleep(100)
Send("^i")
Send("Protection Against Liquid Damage")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-26f::
{
SendLevel(1)
Send("1-26, ")
Sleep(100)
Send("^i")
Send("Steep-Slope Roof Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-27f::
{
SendLevel(1)
Send("1-27, ")
Sleep(100)
Send("^i")
Send("Windstorm  Retrofit and Loss Expectancy (LE) Guidelines")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-28f::
{
SendLevel(1)
Send("1-28, ")
Sleep(100)
Send("^i")
Send("Wind Design")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-29f::
{
SendLevel(1)
Send("1-29, ")
Sleep(100)
Send("^i")
Send("Roof Deck Securement and Above-Deck Roofing Components")
Sleep(100)
Send("^i")
Send(A_Space)
return
}
:*:1-30f::
{
SendLevel(1)
Send("1-30, ")
Sleep(100)
Send("^i")
Send("Repair of Wind Damaged Roof Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-31f::
{
SendLevel(1)
Send("1-31, ")
Sleep(100)
Send("^i")
Send("Panel Roof Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-32f::
{
SendLevel(1)
Send("1-32, ")
Sleep(100)
Send("^i")
Send("Inspection and Maintenance of Roof Assemblies")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-33f::
{
SendLevel(1)
Send("1-33, ")
Sleep(100)
Send("^i")
Send("Safeguarding Torch - Applied Roof Installations")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-34f::
{
SendLevel(1)
Send("1-34, ")
Sleep(100)
Send("^i")
Send("Hail Damage")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-35f::
{
SendLevel(1)
Send("1-35, ")
Sleep(100)
Send("^i")
Send("Vegetative Roof Systems Vegetative Roof Systems, Occupied Roof Areas & Decks")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-36f::
{
SendLevel(1)
Send("1-36, ")
Sleep(100)
Send("^i")
Send("Mass Engineered Timber")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-37f::
{
SendLevel(1)
Send("1-37, ")
Sleep(100)
Send("^i")
Send("Hospitals")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-40f::
{
SendLevel(1)
Send("1-40, ")
Sleep(100)
Send("^i")
Send("Flood")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-41f::
{
SendLevel(1)
Send("1-41, ")
Sleep(100)
Send("^i")
Send("Dam Evaluations")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-42f::
{
SendLevel(1)
Send("1-42, ")
Sleep(100)
Send("^i")
Send("MFL Limiting Factors")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-44f::
{
SendLevel(1)
Send("1-44, ")
Sleep(100)
Send("^i")
Send("Damage-Limiting Construction")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-45f::
{
SendLevel(1)
Send("1-45, ")
Sleep(100)
Send("^i")
Send("Air Conditioning and Ventilating Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-49f::
{
SendLevel(1)
Send("1-49, ")
Sleep(100)
Send("^i")
Send("Perimeter Flashing")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-52f::
{
SendLevel(1)
Send("1-52, ")
Sleep(100)
Send("^i")
Send("Field  Verification of Roof Wind Uplift Resistance")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-53f::
{
SendLevel(1)
Send("1-53, ")
Sleep(100)
Send("^i")
Send("Anechoic Chambers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-54f::
{
SendLevel(1)
Send("1-54, ")
Sleep(100)
Send("^i")
Send("Roof Loads and Drainage")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-55f::
{
SendLevel(1)
Send("1-55, ")
Sleep(100)
Send("^i")
Send("Weak Construction and Design")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-56f::
{
SendLevel(1)
Send("1-56, ")
Sleep(100)
Send("^i")
Send("Cleanrooms")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-57f::
{
SendLevel(1)
Send("1-57, ")
Sleep(100)
Send("^i")
Send("Plastics in Construction")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-59f::
{
SendLevel(1)
Send("1-59, ")
Sleep(100)
Send("^i")
Send("Fabric and Membrane Covered Structures")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-60f::
{
SendLevel(1)
Send("1-60, ")
Sleep(100)
Send("^i")
Send("Asphalt-Coated/Protected Metal Buildings")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-61f::
{
SendLevel(1)
Send("1-61, ")
Sleep(100)
Send("^i")
Send("Impregnated Fire-Retardant Lumber")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-62f::
{
SendLevel(1)
Send("1-62, ")
Sleep(100)
Send("^i")
Send("Cranes")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-63f::
{
SendLevel(1)
Send("1-63, ")
Sleep(100)
Send("^i")
Send("Exterior Insulation and Finish Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:1-64f::
{
SendLevel(1)
Send("1-64, ")
Sleep(100)
Send("^i")
Send("Exterior Walls and Facades")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:2-0f::
{
SendLevel(1)
Send("2-0, ")
Sleep(100)
Send("^i")
Send("Installation Guidelines for Automatic Sprinklers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:2-1f::
{
SendLevel(1)
Send("2-1, ")
Sleep(100)
Send("^i")
Send("Corrosion in Automatic Sprinkler Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:2-8f::
{
SendLevel(1)
Send("2-8, ")
Sleep(100)
Send("^i")
Send("Earthquake Protection for Water-Based Fire Protection Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:2-81f::
{
SendLevel(1)
Send("2-81, ")
Sleep(100)
Send("^i")
Send("Fire Safety Inspections and Sprinkler System Maintenance")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:2-89f::
{
SendLevel(1)
Send("2-89, ")
Sleep(100)
Send("^i")
Send("Pipe Friction Loss Tables")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:3-0f::
{
SendLevel(1)
Send("3-0, ")
Sleep(100)
Send("^i")
Send("Hydraulics of Fire Protection Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:3-1f::
{
SendLevel(1)
Send("3-1, ")
Sleep(100)
Send("^i")
Send("Tanks and Reservoirs for Interconnected Fire Service and Public Mains")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:3-2f::
{
SendLevel(1)
Send("3-2, ")
Sleep(100)
Send("^i")
Send("Water Tanks for Fire Protection")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:3-3f::
{
SendLevel(1)
Send("3-3, ")
Sleep(100)
Send("^i")
Send("Cross Connections")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:3-4f::
{
SendLevel(1)
Send("3-4, ")
Sleep(100)
Send("^i")
Send("Embankment-Supported Fabric Tanks")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:3-6f::
{
SendLevel(1)
Send("3-6, ")
Sleep(100)
Send("^i")
Send("Lined Earth Reservoirs for Fire Protection")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:3-7f::
{
SendLevel(1)
Send("3-7, ")
Sleep(100)
Send("^i")
Send("Fire Protection Pump")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:3-10f::
{
SendLevel(1)
Send("3-10, ")
Sleep(100)
Send("^i")
Send("Installation/Maintenance of  Fire Service Mains")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:3-11f::
{
SendLevel(1)
Send("3-11, ")
Sleep(100)
Send("^i")
Send("Flow and Pressure Regulating Devices for Fire Protection Service")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:3-26f::
{
SendLevel(1)
Send("3-26, ")
Sleep(100)
Send("^i")
Send("Fire Protection Water Demand for Nonstorage Sprinklered Properties")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:3-29f::
{
SendLevel(1)
Send("3-29, ")
Sleep(100)
Send("^i")
Send("Reliability of Fire Protection Water Supplies")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:4-0f::
{
SendLevel(1)
Send("4-0, ")
Sleep(100)
Send("^i")
Send("Special Protection Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:4-1Nf::
{
SendLevel(1)
Send("4-1N, ")
Sleep(100)
Send("^i")
Send("Fixed Water Spray Systems for Fire Protection")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:4-2f::
{
SendLevel(1)
Send("4-2, ")
Sleep(100)
Send("^i")
Send("Water Mist Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:4-3Nf::
{
SendLevel(1)
Send("4-3N, ")
Sleep(100)
Send("^i")
Send("Medium and High Expansion Foam Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:4-4Nf::
{
SendLevel(1)
Send("4-4N, ")
Sleep(100)
Send("^i")
Send("Standpipe and Hose Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:4-5f::
{
SendLevel(1)
Send("4-5, ")
Sleep(100)
Send("^i")
Send("Portable Extinguishers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:4-6f::
{
SendLevel(1)
Send("4-6, ")
Sleep(100)
Send("^i")
Send("Hybrid Fire Extinguishing Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:4-8Nf::
{
SendLevel(1)
Send("4-8N, ")
Sleep(100)
Send("^i")
Send("Halon 1301 Extinguishing Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:4-9f::
{
SendLevel(1)
Send("4-9, ")
Sleep(100)
Send("^i")
Send("Halocarbon and Inert Gas (Clean Agent) Fire Extinguishing Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:4-10f::
{
SendLevel(1)
Send("4-10, ")
Sleep(100)
Send("^i")
Send("Dry Chemical Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:4-11Nf::
{
SendLevel(1)
Send("4-11N, ")
Sleep(100)
Send("^i")
Send("Carbon Dioxide Extinguishing Systems (NFPA)")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:4-12f::
{
SendLevel(1)
Send("4-12, ")
Sleep(100)
Send("^i")
Send("Foam Water Extinguishing  Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:4-13f::
{
SendLevel(1)
Send("4-13, ")
Sleep(100)
Send("^i")
Send("Oxygen Reduction Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-1f::
{
SendLevel(1)
Send("5-1, ")
Sleep(100)
Send("^i")
Send("Electrical Equipment in Hazardous (Classified) Locations")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-3f::
{
SendLevel(1)
Send("5-3, ")
Sleep(100)
Send("^i")
Send("Hydroelectric Power Plants")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-4f::
{
SendLevel(1)
Send("5-4, ")
Sleep(100)
Send("^i")
Send("Transformers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-8f::
{
SendLevel(1)
Send("5-8, ")
Sleep(100)
Send("^i")
Send("Static Electricity")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-11f::
{
SendLevel(1)
Send("5-11, ")
Sleep(100)
Send("^i")
Send("Lightning and Surge Protection for Electrical Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-12f::
{
SendLevel(1)
Send("5-12, ")
Sleep(100)
Send("^i")
Send("Electric AC Generators")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-14f::
{
SendLevel(1)
Send("5-14, ")
Sleep(100)
Send("^i")
Send("Telecommunications")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-17f::
{
SendLevel(1)
Send("5-17, ")
Sleep(100)
Send("^i")
Send("Motors & Adjustable Speed Drives")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-18f::
{
SendLevel(1)
Send("5-18, ")
Sleep(100)
Send("^i")
Send("Protection of Electrical Equipment")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-19f::
{
SendLevel(1)
Send("5-19, ")
Sleep(100)
Send("^i")
Send("Switchgear and Circuit Breakers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-20f::
{
SendLevel(1)
Send("5-20, ")
Sleep(100)
Send("^i")
Send("Electrical Testing")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-21f::
{
SendLevel(1)
Send("5-21, ")
Sleep(100)
Send("^i")
Send("Metal Halide High-Intensity Discharge Lighting")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-23f::
{
SendLevel(1)
Send("5-23, ")
Sleep(100)
Send("^i")
Send("Design and Fire Protection for Emergency and Standby Power Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-24f::
{
SendLevel(1)
Send("5-24, ")
Sleep(100)
Send("^i")
Send("Miscellaneous Electrical Equipment")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-25f::
{
SendLevel(1)
Send("5-25, ")
Sleep(100)
Send("^i")
Send("High Voltage Direct Current Converter  Stations")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-28f::
{
SendLevel(1)
Send("5-28, ")
Sleep(100)
Send("^i")
Send("DC Battery Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-30f::
{
SendLevel(1)
Send("5-30, ")
Sleep(100)
Send("^i")
Send("Power Factor Correction and Static Reactive Compensator Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-31f::
{
SendLevel(1)
Send("5-31, ")
Sleep(100)
Send("^i")
Send("Cables and Bus Bars")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-32f::
{
SendLevel(1)
Send("5-32, ")
Sleep(100)
Send("^i")
Send("Data Centers and Related Facilities")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-33f::
{
SendLevel(1)
Send("5-33, ")
Sleep(100)
Send("^i")
Send("Electrical Energy Storage Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-40f::
{
SendLevel(1)
Send("5-40, ")
Sleep(100)
Send("^i")
Send("Fire Alarm Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-48f::
{
SendLevel(1)
Send("5-48, ")
Sleep(100)
Send("^i")
Send("Automatic Fire Detection")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:5-49f::
{
SendLevel(1)
Send("5-49, ")
Sleep(100)
Send("^i")
Send("Gas and Vapor Detectors and Analysis Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-0f::
{
SendLevel(1)
Send("6-0, ")
Sleep(100)
Send("^i")
Send("Elements of Industrial Heating Equipment")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-2f::
{
SendLevel(1)
Send("6-2, ")
Sleep(100)
Send("^i")
Send("Pulverized Coal Fired  Boilers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-3f::
{
SendLevel(1)
Send("6-3, ")
Sleep(100)
Send("^i")
Send("Induction and Dielectric Heating Equipment")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-4f::
{
SendLevel(1)
Send("6-4, ")
Sleep(100)
Send("^i")
Send("Oil- and Gas-Fired Single-Burner Boilers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-5f::
{
SendLevel(1)
Send("6-5, ")
Sleep(100)
Send("^i")
Send("Oil- or Gas-Fired Multiple Burner Boilers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-6f::
{
SendLevel(1)
Send("6-6, ")
Sleep(100)
Send("^i")
Send("Boiler-Furnaces Implosions")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-7f::
{
SendLevel(1)
Send("6-7, ")
Sleep(100)
Send("^i")
Send("Fluidized Bed Combustors")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-8f::
{
SendLevel(1)
Send("6-8, ")
Sleep(100)
Send("^i")
Send("Combustion Air Heaters")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-9f::
{
SendLevel(1)
Send("6-9, ")
Sleep(100)
Send("^i")
Send("Industrial Ovens and Dryers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-10f::
{
SendLevel(1)
Send("6-10, ")
Sleep(100)
Send("^i")
Send("Process Furnaces")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-11f::
{
SendLevel(1)
Send("6-11, ")
Sleep(100)
Send("^i")
Send("Thermal and Regenerative Catalytic Oxidizers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-12f::
{
SendLevel(1)
Send("6-12, ")
Sleep(100)
Send("^i")
Send("Low-Water Protection")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-13f::
{
SendLevel(1)
Send("6-13, ")
Sleep(100)
Send("^i")
Send("Waste Fuel Fired Facilities")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-14f::
{
SendLevel(1)
Send("6-14, ")
Sleep(100)
Send("^i")
Send("Waste Heat Boilers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-17f::
{
SendLevel(1)
Send("6-17, ")
Sleep(100)
Send("^i")
Send("Rotary Kilns and Dryers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-21f::
{
SendLevel(1)
Send("6-21, ")
Sleep(100)
Send("^i")
Send("Chemical Recovery Boilers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-22f::
{
SendLevel(1)
Send("6-22, ")
Sleep(100)
Send("^i")
Send("Firetube Boilers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:6-23f::
{
SendLevel(1)
Send("6-23, ")
Sleep(100)
Send("^i")
Send("Watertube Boilers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-0f::
{
SendLevel(1)
Send("7-0, ")
Sleep(100)
Send("^i")
Send("Causes and Effects of Fires and Explosions")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-1f::
{
SendLevel(1)
Send("7-1, ")
Sleep(100)
Send("^i")
Send("Fire Protection for Textile Mills")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-2f::
{
SendLevel(1)
Send("7-2, ")
Sleep(100)
Send("^i")
Send("Waste Solvent Recovery")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-3f::
{
SendLevel(1)
Send("7-3, ")
Sleep(100)
Send("^i")
Send("Flight Simulator System Protection")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-4f::
{
SendLevel(1)
Send("7-4, ")
Sleep(100)
Send("^i")
Send("Paper Machines and Pulp Dryers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-6f::
{
SendLevel(1)
Send("7-6, ")
Sleep(100)
Send("^i")
Send("Heated Plastic and Plastic-Lined Tanks")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-7f::
{
SendLevel(1)
Send("7-7, ")
Sleep(100)
Send("^i")
Send("Semiconductor Fabrication Facilities")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-9f::
{
SendLevel(1)
Send("7-9, ")
Sleep(100)
Send("^i")
Send("Dip Tanks, Flow Coaters and Roll Coaters")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-10f::
{
SendLevel(1)
Send("7-10, ")
Sleep(100)
Send("^i")
Send("Wood Processing and Woodworking Facilities")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-11f::
{
SendLevel(1)
Send("7-11, ")
Sleep(100)
Send("^i")
Send("Belt Conveyors")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-12f::
{
SendLevel(1)
Send("7-12, ")
Sleep(100)
Send("^i")
Send("Mining and Mineral Processing")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-13f::
{
SendLevel(1)
Send("7-13, ")
Sleep(100)
Send("^i")
Send("Mechanical Refrigeration")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-14f::
{
SendLevel(1)
Send("7-14, ")
Sleep(100)
Send("^i")
Send("Fire Protection for Chemical Plants")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-15f::
{
SendLevel(1)
Send("7-15, ")
Sleep(100)
Send("^i")
Send("Garages")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-17f::
{
SendLevel(1)
Send("7-17, ")
Sleep(100)
Send("^i")
Send("Explosion Suppression Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-19Nf::
{
SendLevel(1)
Send("7-19N, ")
Sleep(100)
Send("^i")
Send("Fire Hazard Properties of Flammable Liquids, Gases, and Volatile Solids")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-20f::
{
SendLevel(1)
Send("7-20, ")
Sleep(100)
Send("^i")
Send("Oil Cookers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-21f::
{
SendLevel(1)
Send("7-21, ")
Sleep(100)
Send("^i")
Send("Rolling Mills")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-22f::
{
SendLevel(1)
Send("7-22, ")
Sleep(100)
Send("^i")
Send("Hydrazine and its Derivatives")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-23f::
{
SendLevel(1)
Send("7-23, ")
Sleep(100)
Send("^i")
Send("Data on General Class of Chemicals")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-23Nf::
{
SendLevel(1)
Send("7-23N, ")
Sleep(100)
Send("^i")
Send("Hazardous Chemicals Data")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-24f::
{
SendLevel(1)
Send("7-24, ")
Sleep(100)
Send("^i")
Send("Blowing Agents")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-25f::
{
SendLevel(1)
Send("7-25, ")
Sleep(100)
Send("^i")
Send("Molten Steel Production")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-26f::
{
SendLevel(1)
Send("7-26, ")
Sleep(100)
Send("^i")
Send("Glass Manufacturing")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-27f::
{
SendLevel(1)
Send("7-27, ")
Sleep(100)
Send("^i")
Send("Spray Application of Ignitable and Combustible Materials")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-28f::
{
SendLevel(1)
Send("7-28, ")
Sleep(100)
Send("^i")
Send("Energetic Materials")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-29f::
{
SendLevel(1)
Send("7-29, ")
Sleep(100)
Send("^i")
Send("Ignitable Liquid Storage in Portable Containers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-31f::
{
SendLevel(1)
Send("7-31, ")
Sleep(100)
Send("^i")
Send("Storage of Aerosol Products")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-32f::
{
SendLevel(1)
Send("7-32, ")
Sleep(100)
Send("^i")
Send("Ignitable Liquid Operations")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-33f::
{
SendLevel(1)
Send("7-33, ")
Sleep(100)
Send("^i")
Send("High-Temperature Molten Materials")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-35f::
{
SendLevel(1)
Send("7-35, ")
Sleep(100)
Send("^i")
Send("Air Separation Processes")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-36f::
{
SendLevel(1)
Send("7-36, ")
Sleep(100)
Send("^i")
Send("Pharmaceutical Operations")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-37f::
{
SendLevel(1)
Send("7-37, ")
Sleep(100)
Send("^i")
Send("Cutting Fluids")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-39f::
{
SendLevel(1)
Send("7-39, ")
Sleep(100)
Send("^i")
Send("Industrial Trucks")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-40f::
{
SendLevel(1)
Send("7-40, ")
Sleep(100)
Send("^i")
Send("Heavy Duty Mobile Equipment")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-41f::
{
SendLevel(1)
Send("7-41, ")
Sleep(100)
Send("^i")
Send("Heat Treating of Materials Using Oil Quenching and Molten Salt Baths")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-42f::
{
SendLevel(1)
Send("7-42, ")
Sleep(100)
Send("^i")
Send("Vapor Cloud Explosions")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-43f::
{
SendLevel(1)
Send("7-43, ")
Sleep(100)
Send("^i")
Send("Process Safety")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-45f::
{
SendLevel(1)
Send("7-45, ")
Sleep(100)
Send("^i")
Send("Instrumentation and Control in Safety Applications")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-46f::
{
SendLevel(1)
Send("7-46, ")
Sleep(100)
Send("^i")
Send("Chemical Reactors and Reactions")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-49f::
{
SendLevel(1)
Send("7-49, ")
Sleep(100)
Send("^i")
Send("Emergency Venting of Vessels")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-50f::
{
SendLevel(1)
Send("7-50, ")
Sleep(100)
Send("^i")
Send("Compressed Gases in Cylinders")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-51f::
{
SendLevel(1)
Send("7-51, ")
Sleep(100)
Send("^i")
Send("Acetylene")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-53f::
{
SendLevel(1)
Send("7-53, ")
Sleep(100)
Send("^i")
Send("Liquefied Natural Gas (LNG)")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-54f::
{
SendLevel(1)
Send("7-54, ")
Sleep(100)
Send("^i")
Send("Natural Gas and Gas Piping")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-55f::
{
SendLevel(1)
Send("7-55, ")
Sleep(100)
Send("^i")
Send("Liquefied Petroleum Gas")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-58f::
{
SendLevel(1)
Send("7-58, ")
Sleep(100)
Send("^i")
Send("Chlorine Dioxide")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-59f::
{
SendLevel(1)
Send("7-59, ")
Sleep(100)
Send("^i")
Send("Inerting and Purging of Vessels and Equipment")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-61f::
{
SendLevel(1)
Send("7-61, ")
Sleep(100)
Send("^i")
Send("Facilities Processing Radioactive Materials")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-64f::
{
SendLevel(1)
Send("7-64, ")
Sleep(100)
Send("^i")
Send("Aluminum Industries")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-72f::
{
SendLevel(1)
Send("7-72, ")
Sleep(100)
Send("^i")
Send("Reformer and Cracking Furnace")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-73f::
{
SendLevel(1)
Send("7-73, ")
Sleep(100)
Send("^i")
Send("Dust Collectors and Collection Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-74f::
{
SendLevel(1)
Send("7-74, ")
Sleep(100)
Send("^i")
Send("Distilleries")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-75f::
{
SendLevel(1)
Send("7-75, ")
Sleep(100)
Send("^i")
Send("Grain Storage and Milling")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-76f::
{
SendLevel(1)
Send("7-76, ")
Sleep(100)
Send("^i")
Send("Prevention and Mitigation of Combustible Dust Explosions and Fires")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-77f::
{
SendLevel(1)
Send("7-77, ")
Sleep(100)
Send("^i")
Send("Testing Internal Combustion Engines and Accessories")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-78f::
{
SendLevel(1)
Send("7-78, ")
Sleep(100)
Send("^i")
Send("Industrial Exhaust Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-79f::
{
SendLevel(1)
Send("7-79, ")
Sleep(100)
Send("^i")
Send("Fire Protection for Gas Turbine and Electric Generators")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-80f::
{
SendLevel(1)
Send("7-80, ")
Sleep(100)
Send("^i")
Send("Organic Peroxides")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-83f::
{
SendLevel(1)
Send("7-83, ")
Sleep(100)
Send("^i")
Send("Drainage Systems for Ignitable Liquids")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-85f::
{
SendLevel(1)
Send("7-85, ")
Sleep(100)
Send("^i")
Send("Combustible and Reactive Metals")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-86f::
{
SendLevel(1)
Send("7-86, ")
Sleep(100)
Send("^i")
Send("Cellulose Nitrate")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-88f::
{
SendLevel(1)
Send("7-88, ")
Sleep(100)
Send("^i")
Send("Outdoor Ignitable Storage Tanks")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-89f::
{
SendLevel(1)
Send("7-89, ")
Sleep(100)
Send("^i")
Send("Ammonium Nitrate and Mixed Fertilizers Containing Ammonium Nitrate")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-91f::
{
SendLevel(1)
Send("7-91, ")
Sleep(100)
Send("^i")
Send("Hydrogen")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-92f::
{
SendLevel(1)
Send("7-92, ")
Sleep(100)
Send("^i")
Send("Ethylene Oxide")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-93f::
{
SendLevel(1)
Send("7-93, ")
Sleep(100)
Send("^i")
Send("Aircraft Hangars, Aircraft Manufacturing / Assembly Facilities and Protection of Aircraft Interior During Assembly")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-95f::
{
SendLevel(1)
Send("7-95, ")
Sleep(100)
Send("^i")
Send("Compressors")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-96f::
{
SendLevel(1)
Send("7-96, ")
Sleep(100)
Send("^i")
Send("Printing Plants")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-97f::
{
SendLevel(1)
Send("7-97, ")
Sleep(100)
Send("^i")
Send("Metal Cleaning")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-98f::
{
SendLevel(1)
Send("7-98, ")
Sleep(100)
Send("^i")
Send("Hydraulic Fluids")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-99f::
{
SendLevel(1)
Send("7-99, ")
Sleep(100)
Send("^i")
Send("Heat Transfer Fluid Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-101f::
{
SendLevel(1)
Send("7-101, ")
Sleep(100)
Send("^i")
Send("Fire Protection for Steam Turbines and Electric Generators")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-103f::
{
SendLevel(1)
Send("7-103, ")
Sleep(100)
Send("^i")
Send("Turpentine Recovery in Pulp and Paper Mills")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-104f::
{
SendLevel(1)
Send("7-104, ")
Sleep(100)
Send("^i")
Send("Metal Treatment Processes for Steel Mills")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-105f::
{
SendLevel(1)
Send("7-105, ")
Sleep(100)
Send("^i")
Send("Concentrating Solar Power")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-106f::
{
SendLevel(1)
Send("7-106, ")
Sleep(100)
Send("^i")
Send("Ground Mounted Photovoltaic Solar Power")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-107f::
{
SendLevel(1)
Send("7-107, ")
Sleep(100)
Send("^i")
Send("Natural Gas Transmission and Storage")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-108f::
{
SendLevel(1)
Send("7-108, ")
Sleep(100)
Send("^i")
Send("Silane")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-109f::
{
SendLevel(1)
Send("7-109, ")
Sleep(100)
Send("^i")
Send("Fuel Fired Thermal Electric Power Generation Facilities")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-110f::
{
SendLevel(1)
Send("7-110, ")
Sleep(100)
Send("^i")
Send("Industrial Control Systems ")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-111f::
{
SendLevel(1)
Send("7-111, ")
Sleep(100)
Send("^i")
Send("Chemical Process Industries ")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-111Af::
{
SendLevel(1)
Send("7-111A, ")
Sleep(100)
Send("^i")
Send("Fuel-Grade Ethanol ")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-111Bf::
{
SendLevel(1)
Send("7-111B, ")
Sleep(100)
Send("^i")
Send("Carbon Black ")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-111Cf::
{
SendLevel(1)
Send("7-111C, ")
Sleep(100)
Send("^i")
Send("Titanium Dioxide")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-111Df::
{
SendLevel(1)
Send("7-111D, ")
Sleep(100)
Send("^i")
Send("Oilseed Processing ")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-111Ef::
{
SendLevel(1)
Send("7-111E, ")
Sleep(100)
Send("^i")
Send("Chloro-Alkali ")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-111Ff::
{
SendLevel(1)
Send("7-111F, ")
Sleep(100)
Send("^i")
Send("Sulfuric Acid ")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-111Gf::
{
SendLevel(1)
Send("7-111G, ")
Sleep(100)
Send("^i")
Send("Ammonia and Ammonia Derivatives ")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-111Hf::
{
SendLevel(1)
Send("7-111H, ")
Sleep(100)
Send("^i")
Send("Olefins")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:7-111If::
{
SendLevel(1)
Send("7-111I, ")
Sleep(100)
Send("^i")
Send("Ink, Paint and Coating Formulations")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:8-1f::
{
SendLevel(1)
Send("8-1, ")
Sleep(100)
Send("^i")
Send("Commodity Classification")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:8-3f::
{
SendLevel(1)
Send("8-3, ")
Sleep(100)
Send("^i")
Send("Rubber Tire Storage")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:8-7f::
{
SendLevel(1)
Send("8-7, ")
Sleep(100)
Send("^i")
Send("Baled Fiber Storage")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:8-9f::
{
SendLevel(1)
Send("8-9, ")
Sleep(100)
Send("^i")
Send("Storage of Class 1, 2, 3, 4 and Plastic Commodities")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:8-10f::
{
SendLevel(1)
Send("8-10, ")
Sleep(100)
Send("^i")
Send("Coal and Charcoal Storage")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:8-18f::
{
SendLevel(1)
Send("8-18, ")
Sleep(100)
Send("^i")
Send("Storage of Hanging Garments")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:8-21f::
{
SendLevel(1)
Send("8-21, ")
Sleep(100)
Send("^i")
Send("Roll Paper Storage")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:8-22f::
{
SendLevel(1)
Send("8-22, ")
Sleep(100)
Send("^i")
Send("Storage of Baled Waste Paper")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:8-23f::
{
SendLevel(1)
Send("8-23, ")
Sleep(100)
Send("^i")
Send("Rolled Nonwoven Fabric Storage")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:8-24f::
{
SendLevel(1)
Send("8-24, ")
Sleep(100)
Send("^i")
Send("Idle Pallet Storage")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:8-27f::
{
SendLevel(1)
Send("8-27, ")
Sleep(100)
Send("^i")
Send("Storage of Wood Chips")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:8-28f::
{
SendLevel(1)
Send("8-28, ")
Sleep(100)
Send("^i")
Send("Pulpwood and Outdoor Log Storage")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:8-30f::
{
SendLevel(1)
Send("8-30, ")
Sleep(100)
Send("^i")
Send("Storage of Carpets")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:8-33f::
{
SendLevel(1)
Send("8-33, ")
Sleep(100)
Send("^i")
Send("Carousel Storage and Retrieval Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:8-34f::
{
SendLevel(1)
Send("8-34, ")
Sleep(100)
Send("^i")
Send("Protection for Automatic Storage and Retrieval Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:9-0f::
{
SendLevel(1)
Send("9-0, ")
Sleep(100)
Send("^i")
Send("Asset Integrity")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:9-1f::
{
SendLevel(1)
Send("9-1, ")
Sleep(100)
Send("^i")
Send("Supervision of Property")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:9-16f::
{
SendLevel(1)
Send("9-16, ")
Sleep(100)
Send("^i")
Send("Burglary and Theft")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:9-18f::
{
SendLevel(1)
Send("9-18, ")
Sleep(100)
Send("^i")
Send("Prevention of Freeze-ups")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:9-19f::
{
SendLevel(1)
Send("9-19, ")
Sleep(100)
Send("^i")
Send("Wildland Fire")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:10-0f::
{
SendLevel(1)
Send("10-0, ")
Sleep(100)
Send("^i")
Send("The Human Factor of Property Conservation")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:10-1f::
{
SendLevel(1)
Send("10-1, ")
Sleep(100)
Send("^i")
Send("Pre-Incident Planning with the Public Fire Service")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:10-3f::
{
SendLevel(1)
Send("10-3, ")
Sleep(100)
Send("^i")
Send("Hot Work Management")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:10-4f::
{
SendLevel(1)
Send("10-4, ")
Sleep(100)
Send("^i")
Send("Contractor Management")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:10-5f::
{
SendLevel(1)
Send("10-5, ")
Sleep(100)
Send("^i")
Send("Disaster Recovery and Contingency Plan")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:10-6f::
{
SendLevel(1)
Send("10-6, ")
Sleep(100)
Send("^i")
Send("Protection Against Arson and Other Incendiary Fires")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:10-7f::
{
SendLevel(1)
Send("10-7, ")
Sleep(100)
Send("^i")
Send("Fire Protection Impairment Management")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:10-8f::
{
SendLevel(1)
Send("10-8, ")
Sleep(100)
Send("^i")
Send("Operators")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:12-2f::
{
SendLevel(1)
Send("12-2, ")
Sleep(100)
Send("^i")
Send("Vessels & Piping")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:12-3f::
{
SendLevel(1)
Send("12-3, ")
Sleep(100)
Send("^i")
Send("Continuous Digesters & Related Vessels")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:12-6f::
{
SendLevel(1)
Send("12-6, ")
Sleep(100)
Send("^i")
Send("Batch Digesters & Related Vessels")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:12-43f::
{
SendLevel(1)
Send("12-43, ")
Sleep(100)
Send("^i")
Send("Pressure Relief Devices")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:12-53f::
{
SendLevel(1)
Send("12-53, ")
Sleep(100)
Send("^i")
Send("Absorption Refrigeration Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:13-1f::
{
SendLevel(1)
Send("13-1, ")
Sleep(100)
Send("^i")
Send("Cold Mechanical Repairs")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:13-2f::
{
SendLevel(1)
Send("13-2, ")
Sleep(100)
Send("^i")
Send("Hydroelectric Power Plants")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:13-3f::
{
SendLevel(1)
Send("13-3, ")
Sleep(100)
Send("^i")
Send("Steam Turbines")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:13-6f::
{
SendLevel(1)
Send("13-6, ")
Sleep(100)
Send("^i")
Send("Flywheels and Pulleys")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:13-7f::
{
SendLevel(1)
Send("13-7, ")
Sleep(100)
Send("^i")
Send("Gears")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:13-8f::
{
SendLevel(1)
Send("13-8, ")
Sleep(100)
Send("^i")
Send("Power Presses")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:13-10f::
{
SendLevel(1)
Send("13-10, ")
Sleep(100)
Send("^i")
Send("Wind Turbines and Farms")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:13-17f::
{
SendLevel(1)
Send("13-17, ")
Sleep(100)
Send("^i")
Send("Gas Turbines")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:13-18f::
{
SendLevel(1)
Send("13-18, ")
Sleep(100)
Send("^i")
Send("Industrial Clutches and Clutch Couplings")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:13-24f::
{
SendLevel(1)
Send("13-24, ")
Sleep(100)
Send("^i")
Send("Fans and Blowers")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:13-26f::
{
SendLevel(1)
Send("13-26, ")
Sleep(100)
Send("^i")
Send("Internal Combustion Engines")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:13-27f::
{
SendLevel(1)
Send("13-27, ")
Sleep(100)
Send("^i")
Send("Heavy Duty Mobile Equipment")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:13-28f::
{
SendLevel(1)
Send("13-28, ")
Sleep(100)
Send("^i")
Send("Aluminum Industries")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:17-0f::
{
SendLevel(1)
Send("17-0, ")
Sleep(100)
Send("^i")
Send("Asset Integrity")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:17-2f::
{
SendLevel(1)
Send("17-2, ")
Sleep(100)
Send("^i")
Send("Process Safety")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:17-4f::
{
SendLevel(1)
Send("17-4, ")
Sleep(100)
Send("^i")
Send("Monitoring and Diagnosis of Vibration in Rotating Machinery")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:17-11f::
{
SendLevel(1)
Send("17-11, ")
Sleep(100)
Send("^i")
Send("Chemical Reactors and Reactions")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:17-12f::
{
SendLevel(1)
Send("17-12, ")
Sleep(100)
Send("^i")
Send("Semiconductor Fabrication Facilities")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
:*:17-16f::
{
SendLevel(1)
Send("17-16, ")
Sleep(100)
Send("^i")
Send("Cranes")
Sleep(100)
Send("^i")
Send(A_Space)
}
return



::nfpa 13::
{
SendLevel(1)
Send("NFPA 13, ")
Sleep(100)
Send("^i")
Send("Installation of Sprinkler Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}

::nfpa 25::
{
SendLevel(1)
Send("NFPA 25, ")
Sleep(100)
Send("^i")
Send("Installation of Sprinkler Systems")
Sleep(100)
Send("^i")
Send(A_Space)
}
return
/*
;#[AHK Script - OS Numbers and Titles Italicized]
;#Hotstring C1 B0 O EndChars f
#Hotstring B0
#Hotstring O
#Hotstring EndChars f ; the "f" can be modified to whatever you chose
;SendLevel 1 ; ...: 100% required in order to actuate another hotstring
; ...............: apparently not required. 
}
::1-0::
::1-1::
::1-2::
::1-3::
::1-4::
::1-6::
::1-8::
::1-9::
::1-10::
::1-11::
::1-12::
::1-13::
::1-15::
::1-17::
::1-20::
::1-21::
::1-22::
::1-24::
::1-26::
::1-27::
::1-28::
::1-29::
::1-30::
::1-31::
::1-32::
::1-33::
::1-34::
::1-35::
::1-36::
::1-37::
::1-40::
::1-41::
::1-42::
::1-44::
::1-45::
::1-49::
::1-52::
::1-53::
::1-54::
::1-55::
::1-56::
::1-57::
::1-59::
::1-60::
::1-61::
::1-62::
::1-63::
::1-64::
::2-0::
::2-1::
::2-8::
::2-81::
::2-89::
::3-0::
::3-1::
::3-2::
::3-3::
::3-4::
::3-6::
::3-7::
::3-10::
::3-11::
::3-26::
::3-29::
::4-0::
::4-1N::
::4-2::
::4-3N::
::4-4N::
::4-5::
::4-6::
::4-8N::
::4-9::
::4-10::
::4-11N::
::4-12::
::4-13::
::5-1::
::5-3::
::5-4::
::5-8::
::5-11::
::5-12::
::5-14::
::5-17::
::5-18::
::5-19::
::5-20::
::5-21::
::5-23::
::5-24::
::5-25::
::5-28::
::5-30::
::5-31::
::5-32::
::5-33::
::5-40::
::5-48::
::5-49::
::6-0::
::6-2::
::6-3::
::6-4::
::6-5::
::6-6::
::6-7::
::6-8::
::6-9::
::6-10::
::6-11::
::6-12::
::6-13::
::6-14::
::6-17::
::6-21::
::6-22::
::6-23::
::7-0::
::7-1::
::7-2::
::7-3::
::7-4::
::7-6::
::7-7::
::7-9::
::7-10::
::7-11::
::7-12::
::7-13::
::7-14::
::7-15::
::7-17::
::7-19N::
::7-20::
::7-21::
::7-22::
::7-23::
::7-23N::
::7-24::
::7-25::
::7-26::
::7-27::
::7-28::
::7-29::
::7-31::
::7-32::
::7-33::
::7-35::
::7-36::
::7-37::
::7-39::
::7-40::
::7-41::
::7-42::
::7-43::
::7-45::
::7-46::
::7-49::
::7-50::
::7-51::
::7-53::
::7-54::
::7-55::
::7-58::
::7-59::
::7-61::
::7-64::
::7-72::
::7-73::
::7-74::
::7-75::
::7-76::
::7-77::
::7-78::
::7-79::
::7-80::
::7-83::
::7-85::
::7-86::
::7-88::
::7-89::
::7-91::
::7-92::
::7-93::
::7-95::
::7-96::
::7-97::
::7-98::
::7-99::
::7-101::
::7-103::
::7-104::
::7-105::
::7-106::
::7-107::
::7-108::
::7-109::
::7-110::
::7-111::
::7-111A::
::7-111B::
::7-111C::
::7-111D::
::7-111E::
::7-111F::
::7-111G::
::7-111H::
::7-111I::
::8-1::
::8-3::
::8-7::
::8-9::
::8-10::
::8-18::
::8-21::
::8-22::
::8-23::
::8-24::
::8-27::
::8-28::
::8-30::
::8-33::
::8-34::
::9-0::
::9-1::
::9-16::
::9-18::
::9-19::
::10-0::
::10-1::
::10-3::
::10-4::
::10-5::
::10-6::
::10-7::
::10-8::
::12-2::
::12-3::
::12-6::
::12-43::
::12-53::
::13-1::
::13-2::
::13-3::
::13-6::
::13-7::
::13-8::
::13-10::
::13-17::
::13-18::
::13-24::
::13-26::
::13-27::
::13-28::
::17-0::
::17-2::
::17-4::
::17-11::
::17-12::
::17-16::
{ ; V1toV2: Added bracket
SendLevel 1
MakeOSItalic(A_ThisLabel)
#Hotstring B O0
#Hotstring EndChars
*/
;---------------------------------------------------------------------------
;                      Version 4 - OS Abbreviations
;---------------------------------------------------------------------------
/* ; Version 4 - Working Hotstrings
}
::1-0::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-1::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-2::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisHotKey)
return
}
::1-3::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-4::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-6::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-8::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-9::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-10::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-11::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-12::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-13::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-15::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-17::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-20::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-21::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-22::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-24::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-26::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-27::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-28::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-29::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-30::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-31::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-32::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-33::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-34::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-35::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-36::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-37::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-40::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-41::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-42::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-44::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-45::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-49::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-52::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-53::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-54::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-55::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-56::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-57::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-59::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-60::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-61::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-62::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-63::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::1-64::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::2-0::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::2-1::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::2-8::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::2-81::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::2-89::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::3-0::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::3-1::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::3-2::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::3-3::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::3-4::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::3-6::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::3-7::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::3-10::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::3-11::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::3-26::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::3-29::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::4-0::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::4-1N::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::4-2::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::4-3N::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::4-4N::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::4-5::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::4-6::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::4-8N::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::4-9::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::4-10::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::4-11N::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::4-12::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::4-13::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-1::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-3::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-4::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-8::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-11::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-12::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-14::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-17::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-18::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-19::
;MakeOSItalic(A_ThisLabel)
;return
::5-20::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-21::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-23::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-24::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-25::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-28::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-30::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-31::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-32::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-33::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-40::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-48::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::5-49::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-0::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-2::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-3::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-4::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-5::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-6::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-7::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-8::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-9::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-10::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-11::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-12::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-13::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-14::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-17::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-21::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-22::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::6-23::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-0::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-1::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-2::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-3::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-4::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-6::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-7::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-9::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-10::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-11::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-12::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-13::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-14::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-15::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-17::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-19N::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-20::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-21::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-22::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-23::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-23N::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-24::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-25::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-26::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-27::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-28::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-29::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-31::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-32::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-33::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-35::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-36::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-37::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-39::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-40::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-41::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-42::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-43::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-45::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-46::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-49::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-50::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-51::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-53::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-54::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-55::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-58::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-59::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-61::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-64::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-72::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-73::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-74::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-75::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-76::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-77::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-78::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-79::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-80::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-83::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-85::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-86::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-88::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-89::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-91::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-92::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-93::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-95::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-96::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-97::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-98::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-99::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-101::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-103::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-104::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-105::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-106::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-107::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-108::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-109::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-110::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-111::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-111A::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-111B::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-111C::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-111D::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-111E::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-111F::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-111G::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-111H::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::7-111I::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::8-1::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::8-3::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::8-7::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::8-9::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::8-10::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::8-18::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::8-21::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::8-22::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::8-23::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::8-24::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::8-27::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::8-28::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::8-30::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::8-33::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::8-34::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::9-0::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::9-1::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::9-16::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::9-18::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::9-19::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::10-0::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::10-1::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::10-3::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::10-4::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::10-5::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::10-6::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::10-7::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::10-8::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::12-2::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::12-3::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::12-6::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::12-43::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::12-53::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::13-1::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::13-2::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::13-3::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::13-6::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::13-7::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::13-8::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::13-10::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::13-17::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::13-18::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::13-24::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::13-26::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::13-27::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::13-28::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::17-0::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::17-2::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::17-4::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::17-11::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::17-12::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
}
::17-16::
{ ; V1toV2: Added bracket
MakeOSItalic(A_ThisLabel)
return
#Hotstring
*/
;---------------------------------------------------------------------------
;                      Original - OS Abbreviations
;---------------------------------------------------------------------------
/* ; original MakeOSItalic("")
}
:*:1-1f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-1, Firesafe Building Construction and Materials")
return
}
:*:1-2f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-2, Earthquakes")
return
}
:*:1-3f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-3, High-Rise Buildings")
return
}
:*:1-4f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-4, Fire Tests")
return
}
:*:1-6f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-6, Cooling Towers")
return
}
:*:1-8f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-8, Antenna Towers and Signs")
return
}
:*:1-9f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-9, Roof Anchorage for Older, Wood-Roofed Buildings")
return
}
:*:1-10f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-10, Smoke and Heat Venting in Sprinklered Buildings")
return
}
:*:1-11f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-11, Fire Following Earthquakes")
return
}
:*:1-12f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-12, Ceilings and Concealed Spaces")
return
}
:*:1-13f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-13, Chimneys")
return
}
:*:1-15f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-15, Roof Mounted Solar Photovoltaic Panels")
return
}
:*:1-17f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-17, Reflective Ceiling Insulation")
return
}
:*:1-20f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-20, Protection Against Exterior Fire Exposure")
return
}
:*:1-21f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-21, Fire Resistance of Building Assemblies")
return
}
:*:1-22f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-22, Maximum Foreseeable Loss")
return
}
:*:1-24f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-24, Protection Against Liquid Damage")
return
}
:*:1-26f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-26, Steep-Slope Roof Systems")
return
}
:*:1-27f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-27, Windstorm  Retrofit and Loss Expectancy (LE) Guidelines")
return
}
:*:1-28f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-28, Wind Design")
return
}
:*:1-29f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-29, Roof Deck Securement and Above-Deck Roofing  Components")
return
}
:*:1-30f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-30, Repair of Wind Damaged Roof Systems")
return
}
:*:1-31f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-31, Panel Roof Systems")
return
}
:*:1-32f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-32, Inspection and Maintenance of Roof Assemblies")
return
}
:*:1-33f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-33, Safeguarding Torch - Applied Roof Installations")
return
}
:*:1-34f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-34, Hail Damage")
return
}
:*:1-35f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-35, Vegetative Roof Systems Vegetative Roof Systems, Occupied Roof Areas & Decks ")
return
}
:*:1-36f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-36, Mass Engineered Timber")
return
}
:*:1-37f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-37, Hospitals ")
return
}
:*:1-40f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-40, Flood")
return
}
:*:1-41f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-41, Dam Evaluations")
return
}
:*:1-42f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-42, MFL Limiting Factors ")
return
}
:*:1-44f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-44, Damage-Limiting Construction")
return
}
:*:1-45f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-45, Air Conditioning and Ventilating Systems")
return
}
:*:1-49f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-49, Perimeter Flashing")
return
}
:*:1-52f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-52, Field  Verification of Roof Wind Uplift Resistance")
return
}
:*:1-53f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-53, Anechoic Chambers")
return
}
:*:1-54f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-54, Roof Loads and Drainage")
return
}
:*:1-55f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-55, Weak Construction and Design")
return
}
:*:1-56f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-56, Cleanrooms")
return
}
:*:1-57f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-57, Plastics in Construction")
return
}
:*:1-59f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-59, Fabric and Membrane Covered Structures")
return
}
:*:1-60f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-60, Asphalt-Coated/Protected Metal Buildings")
return
}
:*:1-61f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-61, Impregnated Fire-Retardant Lumber")
return
}
:*:1-62f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-62, Cranes")
return
}
:*:1-63f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-63, Exterior Insulation and Finish Systems")
return
}
:*:1-64f::
{ ; V1toV2: Added bracket
MakeOSItalic("1-64, Exterior Walls and Facades")
return
}
:*:2-0f::
{ ; V1toV2: Added bracket
MakeOSItalic("2-0, Installation Guidelines for Automatic Sprinklers")
return
}
:*:2-1f::
{ ; V1toV2: Added bracket
MakeOSItalic("2-1, Corrosion in Automatic Sprinkler Systems")
return
}
:*:2-8f::
{ ; V1toV2: Added bracket
MakeOSItalic("2-8, Earthquake Protection for Water-Based Fire Protection Systems")
return
}
:*:2-81f::
{ ; V1toV2: Added bracket
MakeOSItalic("2-81, Fire Safety Inspections and Sprinkler System Maintenance")
return
}
:*:2-89f::
{ ; V1toV2: Added bracket
MakeOSItalic("2-89, Pipe Friction Loss Tables")
return
}
:*:3-0f::
{ ; V1toV2: Added bracket
MakeOSItalic("3-0, Hydraulics of Fire Protection Systems")
return
}
:*:3-1f::
{ ; V1toV2: Added bracket
MakeOSItalic("3-1, Tanks and Reservoirs for Interconnected Fire Service and Public Mains")
return
}
:*:3-2f::
{ ; V1toV2: Added bracket
MakeOSItalic("3-2, Water Tanks for Fire Protection")
return
}
:*:3-3f::
{ ; V1toV2: Added bracket
MakeOSItalic("3-3, Cross Connections")
return
}
:*:3-4f::
{ ; V1toV2: Added bracket
MakeOSItalic("3-4, Embankment-Supported Fabric Tanks")
return
}
:*:3-6f::
{ ; V1toV2: Added bracket
MakeOSItalic("3-6, Lined Earth Reservoirs for Fire Protection")
return
}
:*:3-7f::
{ ; V1toV2: Added bracket
MakeOSItalic("3-7, Fire Protection Pump")
return
}
:*:3-10f::
{ ; V1toV2: Added bracket
MakeOSItalic("3-10, Installation/Maintenance of  Fire Service Mains")
return
}
:*:3-11f::
{ ; V1toV2: Added bracket
MakeOSItalic("3-11, Flow and Pressure Regulating Devices for Fire Protection Service")
return
}
:*:3-26f::
{ ; V1toV2: Added bracket
MakeOSItalic("3-26, Fire Protection Water Demand for Nonstorage Sprinklered Properties")
return
}
:*:3-29f::
{ ; V1toV2: Added bracket
MakeOSItalic("3-29, Reliability of Fire Protection Water Supplies")
return
}
:*:4-0f::
{ ; V1toV2: Added bracket
MakeOSItalic("4-0, Special Protection Systems")
return
}
:*:4-1Nf::
{ ; V1toV2: Added bracket
MakeOSItalic("4-1N, Fixed Water Spray Systems for Fire Protection")
return
}
:*:4-2f::
{ ; V1toV2: Added bracket
MakeOSItalic("4-2, Water Mist Systems")
return
}
:*:4-3Nf::
{ ; V1toV2: Added bracket
MakeOSItalic("4-3N, Medium and High Expansion Foam Systems")
return
}
:*:4-4Nf::
{ ; V1toV2: Added bracket
MakeOSItalic("4-4N, Standpipe and Hose Systems")
return
}
:*:4-5f::
{ ; V1toV2: Added bracket
MakeOSItalic("4-5, Portable Extinguishers")
return
}
:*:4-6f::
{ ; V1toV2: Added bracket
MakeOSItalic("4-6, Hybrid Fire Extinguishing Systems")
return
}
:*:4-8Nf::
{ ; V1toV2: Added bracket
MakeOSItalic("4-8N, Halon 1301 Extinguishing Systems")
return
}
:*:4-9f::
{ ; V1toV2: Added bracket
MakeOSItalic("4-9, Halocarbon and Inert Gas (Clean Agent) Fire Extinguishing Systems")
return
}
:*:4-10f::
{ ; V1toV2: Added bracket
MakeOSItalic("4-10, Dry Chemical Systems")
return
}
:*:4-11Nf::
{ ; V1toV2: Added bracket
MakeOSItalic("4-11N, Carbon Dioxide Extinguishing Systems (NFPA)")
return
}
:*:4-12f::
{ ; V1toV2: Added bracket
MakeOSItalic("4-12, Foam Water Extinguishing  Systems")
return
}
:*:4-13f::
{ ; V1toV2: Added bracket
MakeOSItalic("4-13, Oxygen Reduction Systems")
return
}
:*:5-1f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-1, Electrical Equipment in Hazardous (Classified) Locations")
return
}
:*:5-3f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-3, Hydroelectric Power Plants")
return
}
:*:5-4f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-4, Transformers")
return
}
:*:5-8f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-8, Static Electricity")
return
}
:*:5-11f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-11, Lightning and Surge Protection for Electrical Systems")
return
}
:*:5-12f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-12, Electric AC Generators")
return
}
:*:5-14f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-14, Telecommunications")
return
}
:*:5-17f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-17, Motors & Adjustable Speed Drives")
return
}
:*:5-18f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-18, Protection of Electrical Equipment")
return
}
:*:5-19f::
;RegExMatch(A_ThisHotkey, "([0-9]{1,2}-[0-9]*)f",match)
;IniRead, OSTitle, OSTitle.ini,OS,% match
{ ; V1toV2: Added bracket
MsgBox % A_ThisHotkey
return
;:*:5-19f::
;MakeOSItalic("5-19, Switchgear and Circuit Breakers")
;return
}
:*:5-20f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-20, Electrical Testing")
return
}
:*:5-21f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-21, Metal Halide High-Intensity Discharge Lighting")
return
}
:*:5-23f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-23, Design and Fire Protection for Emergency and Standby Power Systems")
return
}
:*:5-24f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-24, Miscellaneous Electrical Equipment")
return
}
:*:5-25f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-25, High Voltage Direct Current Converter Stations")
return
}
:*:5-28f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-28, DC Battery Systems")
return
}
:*:5-30f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-30, Power Factor Correction and Static Reactive Compensator Systems")
return
}
:*:5-31f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-31, Cables and Bus Bars")
return
}
:*:5-32f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-32, Data Centers and Related Facilities")
return
}
:*:5-33f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-33, Electrical Energy Storage Systems")
return
}
:*:5-40f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-40, Fire Alarm Systems")
return
}
:*:5-48f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-48, Automatic Fire Detection")
return
}
:*:5-49f::
{ ; V1toV2: Added bracket
MakeOSItalic("5-49, Gas and Vapor Detectors and Analysis Systems")
return
}
:*:6-0f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-0, Elements of Industrial Heating Equipment")
return
}
:*:6-2f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-2, Pulverized Coal Fired  Boilers")
return
}
:*:6-3f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-3, Induction and Dielectric Heating Equipment")
return
}
:*:6-4f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-4, Oil- and Gas-Fired Single-Burner Boilers")
return
}
:*:6-5f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-5, Oil- or Gas-Fired Multiple Burner Boilers")
return
}
:*:6-6f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-6, Boiler-Furnaces Implosions")
return
}
:*:6-7f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-7, Fluidized Bed Combustors")
return
}
:*:6-8f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-8, Combustion Air Heaters")
return
}
:*:6-9f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-9, Industrial Ovens and Dryers")
return
}
:*:6-10f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-10, Process Furnaces")
return
}
:*:6-11f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-11, Thermal and Regenerative Catalytic Oxidizers")
return
}
:*:6-12f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-12, Low-Water Protection")
return
}
:*:6-13f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-13, Waste Fuel Fired Facilities")
return
}
:*:6-14f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-14, Waste Heat Boilers")
return
}
:*:6-17f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-17, Rotary Kilns and Dryers")
return
}
:*:6-21f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-21, Chemical Recovery Boilers")
return
}
:*:6-22f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-22, Firetube Boilers")
return
}
:*:6-23f::
{ ; V1toV2: Added bracket
MakeOSItalic("6-23, Watertube Boilers")
return
}
:*:7-0f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-0, Causes and Effects of Fires and Explosions")
return
}
:*:7-1f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-1, Fire Protection for Textile Mills")
return
}
:*:7-2f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-2, Waste Solvent Recovery")
return
}
:*:7-3f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-3, Flight Simulator System Protection")
return
}
:*:7-4f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-4, Paper Machines and Pulp Dryers")
return
}
:*:7-6f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-6, Heated Plastic and Plastic-Lined Tanks")
return
}
:*:7-7f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-7, Semiconductor Fabrication Facilities")
return
}
:*:7-9f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-9, Dip Tanks, Flow Coaters and Roll Coaters")
return
}
:*:7-10f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-10, Wood Processing and Woodworking Facilities")
return
}
:*:7-11f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-11, Conveyors")
return
}
:*:7-12f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-12, Mining and Mineral Processing")
return
}
:*:7-13f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-13, Mechanical Refrigeration")
return
}
:*:7-14f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-14, Fire Protection for Chemical Plants")
return
}
:*:7-15f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-15, Garages")
return
}
:*:7-17f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-17, Explosion Suppression Systems")
return
}
:*:7-19Nf::
{ ; V1toV2: Added bracket
MakeOSItalic("7-19N, Fire Hazard Properties of Flammable Liquids, Gases, and Volatile Solids")
return
}
:*:7-20f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-20, Oil Cookers")
return
}
:*:7-21f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-21, Rolling Mills")
return
}
:*:7-22f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-22, Hydrazine and its Derivatives")
return
}
:*:7-23f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-23, Data on General Class of Chemicals")
return
}
:*:7-23Nf::
{ ; V1toV2: Added bracket
MakeOSItalic("7-23N, Hazardous Chemicals Data")
return
}
:*:7-24f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-24, Blowing Agents")
return
}
:*:7-25f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-25, Molten Steel Production")
return
}
:*:7-26f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-26, Glass Manufacturing")
return
}
:*:7-27f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-27, Spray Application of Ignitable and Combustible Materials")
return
}
:*:7-28f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-28, Energetic Materials")
return
}
:*:7-29f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-29, Ignitable Liquid Storage in Portable Containers")
return
}
:*:7-31f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-31, Storage of Aerosol Products")
return
}
:*:7-32f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-32, Ignitable Liquid Operations")
return
}
:*:7-33f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-33, High-Temperature Molten Materials")
return
}
:*:7-35f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-35, Air Separation Processes")
return
}
:*:7-36f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-36, Pharmaceutical Operations")
return
}
:*:7-37f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-37, Cutting Fluids")
return
}
:*:7-39f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-39, Industrial Trucks")
return
}
:*:7-40f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-40, Heavy Duty Mobile Equipment")
return
}
:*:7-41f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-41, Heat Treating of Materials Using Oil Quenching and Molten Salt Baths")
return
}
:*:7-42f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-42, Vapor Cloud Explosions")
return
}
:*:7-43f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-43, Process Safety")
return
}
:*:7-45f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-45, Instrumentation and Control in Safety Applications")
return
}
:*:7-46f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-46, Chemical Reactors and Reactions")
return
}
:*:7-49f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-49, Emergency Venting of Vessels")
return
}
:*:7-50f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-50, Compressed Gases in Cylinders")
return
}
:*:7-51f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-51, Acetylene")
return
}
:*:7-53f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-53, Liquefied Natural Gas (LNG)")
return
}
:*:7-54f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-54, Natural Gas and Gas Piping")
return
}
:*:7-55f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-55, Liquefied Petroleum Gas")
return
}
:*:7-58f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-58, Chlorine Dioxide")
return
}
:*:7-59f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-59, Inerting and Purging of Vessels and Equipment")
return
}
:*:7-61f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-61, Facilities Processing Radioactive Materials")
return
}
:*:7-64f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-64, Aluminum Industries")
return
}
:*:7-72f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-72, Reformer and Cracking Furnace")
return
}
:*:7-73f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-73, Dust Collectors and Collection Systems")
return
}
:*:7-74f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-74, Distilleries")
return
}
:*:7-75f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-75, Grain Storage and Milling")
return
}
:*:7-76f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-76, Prevention and Mitigation of Combustible Dust Explosions and Fires")
return
}
:*:7-77f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-77, Testing Internal Combustion Engines and Accessories")
return
}
:*:7-78f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-78, Industrial Exhaust Systems")
return
}
:*:7-79f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-79, Fire Protection for Gas Turbine and Electric Generators")
return
}
:*:7-80f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-80, Organic Peroxides")
return
}
:*:7-83f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-83, Drainage Systems for Ignitable Liquids")
return
}
:*:7-85f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-85, Combustible and Reactive Metals")
return
}
:*:7-86f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-86, Cellulose Nitrate")
return
}
:*:7-88f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-88, Outdoor Ignitable Storage Tanks")
return
}
:*:7-89f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-89, Ammonium Nitrate and Mixed Fertilizers Containing Ammonium Nitrate")
return
}
:*:7-91f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-91, Hydrogen")
return
}
:*:7-92f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-92, Ethylene Oxide")
return
}
:*:7-93f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-93, Aircraft Hangars, Aircraft Manufacturing / Assembly Facilities and Protection of Aircraft Interior During Assembly")
return
}
:*:7-95f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-95, Compressors")
return
}
:*:7-96f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-96, Printing Plants")
return
}
:*:7-97f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-97, Metal Cleaning")
return
}
:*:7-98f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-98, Hydraulic Fluids")
return
}
:*:7-99f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-99, Heat Transfer Fluid Systems")
return
}
:*:7-101f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-101, Fire Protection for Steam Turbines and Electric Generators")
return
}
:*:7-103f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-103, Turpentine Recovery in Pulp and Paper Mills")
return
}
:*:7-104f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-104, Metal Treatment Processes for Steel Mills")
return
}
:*:7-105f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-105, Concentrating Solar Power")
return
}
:*:7-106f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-106, Ground Mounted Photovoltaic Solar Power")
return
}
:*:7-107f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-107, Natural Gas Transmission and Storage")
return
}
:*:7-108f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-108, Silane")
return
}
:*:7-109f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-109, Fuel Fired Thermal Electric Power Generation Facilities")
return
}
:*:7-110f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-110, Industrial Control Systems ")
return
}
:*:7-111f::
{ ; V1toV2: Added bracket
MakeOSItalic("7-111, Chemical Process Industries ")
return
}
:*:7-111Af::
{ ; V1toV2: Added bracket
MakeOSItalic("7-111A, Fuel-Grade Ethanol ")
return
}
:*:7-111Bf::
{ ; V1toV2: Added bracket
MakeOSItalic("7-111B, Carbon Black ")
return
}
:*:7-111Cf::
{ ; V1toV2: Added bracket
MakeOSItalic("7-111C, Titanium Dioxide")
return
}
:*:7-111Df::
{ ; V1toV2: Added bracket
MakeOSItalic("7-111D, Oilseed Processing ")
return
}
:*:7-111Ef::
{ ; V1toV2: Added bracket
MakeOSItalic("7-111E, Chloro-Alkali ")
return
}
:*:7-111Ff::
{ ; V1toV2: Added bracket
MakeOSItalic("7-111F, Sulfuric Acid ")
return
}
:*:7-111Gf::
{ ; V1toV2: Added bracket
MakeOSItalic("7-111G, Ammonia and Ammonia Derivatives ")
return
}
:*:7-111Hf::
{ ; V1toV2: Added bracket
MakeOSItalic("7-111H, Olefins")
return
}
:*:7-111If::
{ ; V1toV2: Added bracket
MakeOSItalic("7-111I, Ink, Paint and Coating Formulations")
return
}
:*:8-1f::
{ ; V1toV2: Added bracket
MakeOSItalic("8-1, Commodity Classification")
return
}
:*:8-3f::
{ ; V1toV2: Added bracket
MakeOSItalic("8-3, Rubber Tire Storage")
return
}
:*:8-7f::
{ ; V1toV2: Added bracket
MakeOSItalic("8-7, Baled Fiber Storage")
return
}
:*:8-9f::
{ ; V1toV2: Added bracket
MakeOSItalic("8-9, Storage of Class 1, 2, 3, 4 and Plastic Commodities")
return
}
:*:8-10f::
{ ; V1toV2: Added bracket
MakeOSItalic("8-10, Coal and Charcoal Storage")
return
}
:*:8-18f::
{ ; V1toV2: Added bracket
MakeOSItalic("8-18, Storage of Hanging Garments")
return
}
:*:8-21f::
{ ; V1toV2: Added bracket
MakeOSItalic("8-21, Roll Paper Storage")
return
}
:*:8-22f::
{ ; V1toV2: Added bracket
MakeOSItalic("8-22, Storage of Baled Waste Paper")
return
}
:*:8-23f::
{ ; V1toV2: Added bracket
MakeOSItalic("8-23, Rolled Nonwoven Fabric Storage")
return
}
:*:8-24f::
{ ; V1toV2: Added bracket
MakeOSItalic("8-24, Idle Pallet Storage")
return
}
:*:8-27f::
{ ; V1toV2: Added bracket
MakeOSItalic("8-27, Storage of Wood Chips")
return
}
:*:8-28f::
{ ; V1toV2: Added bracket
MakeOSItalic("8-28, Pulpwood and Outdoor Log Storage")
return
}
:*:8-30f::
{ ; V1toV2: Added bracket
MakeOSItalic("8-30, Storage of Carpets")
return
}
:*:8-33f::
{ ; V1toV2: Added bracket
MakeOSItalic("8-33, Carousel Storage and Retrieval Systems")
return
}
:*:8-34f::
{ ; V1toV2: Added bracket
MakeOSItalic("8-34, Protection for Automatic Storage and Retrieval Systems")
return
}
:*:9-0f::
{ ; V1toV2: Added bracket
MakeOSItalic("9-0, Asset Integrity")
return
}
:*:9-1f::
{ ; V1toV2: Added bracket
MakeOSItalic("9-1, Supervision of Property")
return
}
:*:9-16f::
{ ; V1toV2: Added bracket
MakeOSItalic("9-16, Burglary and Theft")
return
}
:*:9-18f::
{ ; V1toV2: Added bracket
MakeOSItalic("9-18, Prevention of Freeze-ups")
return
}
:*:9-19f::
{ ; V1toV2: Added bracket
MakeOSItalic("9-19, Wildland Fire")
return
}
:*:10-0f::
{ ; V1toV2: Added bracket
MakeOSItalic("10-0, The Human Factor of Property Conservation")
return
}
:*:10-1f::
{ ; V1toV2: Added bracket
MakeOSItalic("10-1, Pre-Incident and Emergency Response Planning")
return
}
:*:10-3f::
{ ; V1toV2: Added bracket
MakeOSItalic("10-3, Hot Work Management")
return
}
:*:10-4f::
{ ; V1toV2: Added bracket
MakeOSItalic("10-4, Contractor Management")
return
}
:*:10-5f::
{ ; V1toV2: Added bracket
MakeOSItalic("10-5, Disaster Recovery and Contingency Plan")
return
}
:*:10-6f::
{ ; V1toV2: Added bracket
MakeOSItalic("10-6, Protection Against Arson and Other Incendiary Fires")
return
}
:*:10-7f::
{ ; V1toV2: Added bracket
MakeOSItalic("10-7, Fire Protection Impairment Management")
return
}
:*:10-8f::
{ ; V1toV2: Added bracket
MakeOSItalic("10-8, Operators")
return
}
:*:12-2f::
{ ; V1toV2: Added bracket
MakeOSItalic("12-2, Vessels & Piping")
return
}
:*:12-3f::
{ ; V1toV2: Added bracket
MakeOSItalic("12-3, Continuous Digesters & Related Vessels")
return
}
:*:12-6f::
{ ; V1toV2: Added bracket
MakeOSItalic("12-6, Batch Digesters & Related Vessels")
return
}
:*:12-43f::
{ ; V1toV2: Added bracket
MakeOSItalic("12-43, Pressure Relief Devices")
return
}
:*:12-53f::
{ ; V1toV2: Added bracket
MakeOSItalic("12-53, Absorption Refrigeration Systems")
return
}
:*:13-1f::
{ ; V1toV2: Added bracket
MakeOSItalic("13-1, Cold Mechanical Repairs")
return
}
:*:13-2f::
{ ; V1toV2: Added bracket
MakeOSItalic("13-2, Hydroelectric Power Plants")
return
}
:*:13-3f::
{ ; V1toV2: Added bracket
MakeOSItalic("13-3, Steam Turbines")
return
}
:*:13-6f::
{ ; V1toV2: Added bracket
MakeOSItalic("13-6, Flywheels and Pulleys")
return
}
:*:13-7f::
{ ; V1toV2: Added bracket
MakeOSItalic("13-7, Gears")
return
}
:*:13-8f::
{ ; V1toV2: Added bracket
MakeOSItalic("13-8, Power Presses")
return
}
:*:13-10f::
{ ; V1toV2: Added bracket
MakeOSItalic("13-10, Wind Turbines and Farms")
return
}
:*:13-17f::
{ ; V1toV2: Added bracket
MakeOSItalic("13-17, Gas Turbines")
return
}
:*:13-18f::
{ ; V1toV2: Added bracket
MakeOSItalic("13-18, Industrial Clutches and Clutch Couplings")
return
}
:*:13-24f::
{ ; V1toV2: Added bracket
MakeOSItalic("13-24, Fans and Blowers")
return
}
:*:13-26f::
{ ; V1toV2: Added bracket
MakeOSItalic("13-26, Internal Combustion Engines")
return
}
:*:13-27f::
{ ; V1toV2: Added bracket
MakeOSItalic("13-27, Heavy Duty Mobile Equipment")
return
}
:*:13-28f::
{ ; V1toV2: Added bracket
MakeOSItalic("13-28, Aluminum Industries")
return
}
:*:17-0f::
{ ; V1toV2: Added bracket
MakeOSItalic("17-0, Asset Integrity")
return
}
:*:17-2f::
{ ; V1toV2: Added bracket
MakeOSItalic("17-2, Process Safety")
return
}
:*:17-4f::
{ ; V1toV2: Added bracket
MakeOSItalic("17-4, Monitoring and Diagnosis of Vibration in Rotating Machinery")
return
}
:*:17-11f::
{ ; V1toV2: Added bracket
MakeOSItalic("17-11, Chemical Reactors and Reactions")
return
}
:*:17-12f::
{ ; V1toV2: Added bracket
MakeOSItalic("17-12, Semiconductor Fabrication Facilities")
return
}
:*:17-16f::
{ ; V1toV2: Added bracket
MakeOSItalic("17-16, Cranes")
return
}


::nfpa 13::
{ ; V1toV2: Added bracket
MakeOSItalic("NFPA 13, Installation of Sprinkler Systems")
return
}

::nfpa 25::
{ ; V1toV2: Added bracket
MakeOSItalic("NFPA 25, Standard for the Inspection, Testing and Maintenance of Water-Based Fire Protection Systems")
return
*/
;---------------------------------------------------------------------------

; } ; V1toV2: Added bracket in the end
