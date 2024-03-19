/************************************************************************
 * @description Alternate AutoComplete
 * @file AutoComplete.v2.altmethod.ahk
 * @author mikeyww
 * @author Doregowda (text selection)
 * @date 2024/01/12
 * @version 2023.01.22
 * @link https://www.autohotkey.com/boards/viewtopic.php?t=112927
 * @example
	Auto-complete for AHK v2 -------------------------------------
	This script provides a type-ahead (auto-complete) feature.
	A word appears from a list of words. The user can press TAB to accept the selection.
	By mikeyww, with text selection by Raghava Doregowda
	22 January 2023 • For AutoHotkey version 2.0.2
	https://www.autohotkey.com/boards/viewtopic.php?p=503278#p503278
 ***********************************************************************/

#Requires AutoHotkey v2.0
#Include <Directives\__AE.v2>
; #Include <Includes\Includes_Runner>
; wordList := "
; (
; amanda
; alex
; amir
; )"
wordList := "
(
1-0, Safeguards During Construction, Alteration and Demolition
1-1, Firesafe Building Construction and Materials
1-2, Earthquakes
1-3, High-Rise Buildings
1-4, Fire Tests
1-6, Cooling Towers
1-8, Antenna Towers and Signs
1-9, Roof Anchorage for Older, Wood-Roofed Buildings
1-10, Smoke and Heat Venting in Sprinklered Buildings
1-11, Fire Following Earthquakes
1-12, Ceilings and Concealed Spaces
1-13, Chimneys
1-15, Roof Mounted Solar Photovoltaic Panels
1-17, Reflective Ceiling Insulation
1-20, Protection Against Exterior Fire Exposure
1-21, Fire Resistance of Building Assemblies
1-22, Maximum Foreseeable Loss
1-24, Protection Against Liquid Damage
1-26, Steep-Slope Roof Systems
1-27, Windstorm  Retrofit and Loss Expectancy (LE) Guidelines
1-28, Wind Design
1-29, Roof Deck Securement and Above-Deck Roofing  Components
1-30, Repair of Wind Damaged Roof Systems
1-31, Panel Roof Systems
1-32, Inspection and Maintenance of Roof Assemblies
1-33, Safeguarding Torch - Applied Roof Installations
1-34, Hail Damage
1-35, Vegetative Roof Systems Vegetative Roof Systems, Occupied Roof Areas & Decks 
1-36, Mass Engineered Timber
1-37, Hospitals 
1-40, Flood
1-41, Dam Evaluations
1-42, MFL Limiting Factors 
1-44, Damage-Limiting Construction
1-45, Air Conditioning and Ventilating Systems
1-49, Perimeter Flashing
1-52, Field  Verification of Roof Wind Uplift Resistance
1-53, Anechoic Chambers
1-54, Roof Loads and Drainage
1-55, Weak Construction and Design
1-56, Cleanrooms
1-57, Plastics in Construction
1-59, Fabric and Membrane Covered Structures
1-60, Asphalt-Coated/Protected Metal Buildings
1-61, Impregnated Fire-Retardant Lumber
1-62, Cranes
1-63, Exterior Insulation and Finish Systems
1-64, Exterior Walls and Facades
2-0, Installation Guidelines for Automatic Sprinklers
2-1, Corrosion in Automatic Sprinkler Systems
2-8, Earthquake Protection for Water-Based Fire Protection Systems
2-81, Fire Protection System Inspection, Testing and Maintenance
2-89, Pipe Friction Loss Tables
3-0, Hydraulics of Fire Protection Systems
3-1, Tanks and Reservoirs for Interconnected Fire Service and Public Mains
3-2, Water Tanks for Fire Protection
3-3, Cross Connections
3-4, Embankment-Supported Fabric Tanks
3-6, Lined Earth Reservoirs for Fire Protection
3-7, Fire Protection Pump
3-10, Installation/Maintenance of  Fire Service Mains
3-11, Flow and Pressure Regulating Devices for Fire Protection Service
3-26, Fire Protection Water Demand for Nonstorage Sprinklered Properties
3-29, Reliability of Fire Protection Water Supplies
4-0, Special Protection Systems
4-1N, Fixed Water Spray Systems for Fire Protection
4-2, Water Mist Systems
4-3N, Medium and High Expansion Foam Systems
4-4N, Standpipe and Hose Systems
4-5, Portable Extinguishers
4-6, Hybrid Fire Extinguishing Systems
4-8N, Halon 1301 Extinguishing Systems
4-9, Halocarbon and Inert Gas (Clean Agent) Fire Extinguishing Systems
4-10, Dry Chemical Systems
4-11N, Carbon Dioxide Extinguishing Systems (NFPA)
4-12, Foam Water Extinguishing  Systems
4-13, Oxygen Reduction Systems
5-1, Electrical Equipment in Hazardous (Classified) Locations
5-3, Hydroelectric Power Plants
5-4, Transformers
5-8, Static Electricity
5-11, Lightning and Surge Protection for Electrical Systems
5-12, Electric AC Generators
5-14, Telecommunications
5-17, Motors & Adjustable Speed Drives
5-18, Protection of Electrical Equipment
5-19, ^iSwitchgear and Circuit Breakers^i
5-20, Electrical Testing
5-21, Metal Halide High-Intensity Discharge Lighting
5-23, Design and Fire Protection for Emergency and Standby Power Systems
5-24, Miscellaneous Electrical Equipment
5-25, High Voltage Direct Current Converter  Stations
5-28, DC Battery Systems
5-30, Power Factor Correction and Static Reactive Compensator Systems
5-31, Cables and Bus Bars
5-32, Data Centers and Related Facilities
5-33, Electrical Energy Storage Systems 
5-40, Fire Alarm Systems
5-48, Automatic Fire Detection
5-49, Gas and Vapor Detectors and Analysis Systems
6-0, Elements of Industrial Heating Equipment
6-2, Pulverized Coal Fired  Boilers
6-3, Induction and Dielectric Heating Equipment
6-4, Oil- and Gas-Fired Single-Burner Boilers
6-5, Oil- or Gas-Fired Multiple Burner Boilers
6-6, Boiler-Furnaces Implosions
6-7, Fluidized Bed Combustors
6-8, Combustion Air Heaters
6-9, Industrial Ovens and Dryers
6-10, Process Furnaces
6-11, Thermal and Regenerative Catalytic Oxidizers
6-12, Low-Water Protection
6-13, Waste Fuel Fired Facilities
6-14, Waste Heat Boilers
6-17, Rotary Kilns and Dryers
6-21, Chemical Recovery Boilers
6-22, Firetube Boilers
6-23, Watertube Boilers
7-0, Causes and Effects of Fires and Explosions
7-1, Fire Protection for Textile Mills
7-2, Waste Solvent Recovery
7-3, Flight Simulator System Protection
7-4, Paper Machines and Pulp Dryers
7-6, Heated Plastic and Plastic-Lined Tanks
7-7, Semiconductor Fabrication Facilities
7-9, Dip Tanks, Flow Coaters and Roll Coaters
7-10, Wood Processing and Woodworking Facilities
7-11, Conveyors
7-12, Mining and Mineral Processing
7-13, Mechanical Refrigeration
7-14, Fire Protection for Chemical Plants
7-15, Garages
7-17, Explosion Suppression Systems
7-19N, Fire Hazard Properties of Flammable Liquids, Gases, and Volatile Solids
7-20, Oil Cookers
7-21, Rolling Mills
7-22, Hydrazine and its Derivatives
7-23, Data on General Class of Chemicals
7-23N, Hazardous Chemicals Data
7-24, Blowing Agents
7-25, Molten Steel Production
7-26, Glass Manufacturing
7-27, Spray Application of Ignitable and Combustible Materials
7-28, Energetic Materials
7-29, Ignitable Liquid Storage in Portable Containers
7-31, Storage of Aerosol Products
7-32, Ignitable Liquid Operations
7-33, High-Temperature Molten Materials
7-35, Air Separation Processes
7-36, Pharmaceutical Operations
7-37, Cutting Fluids
7-39, Industrial Trucks
7-40, Heavy Duty Mobile Equipment
7-41, Heat Treating of Materials Using Oil Quenching and Molten Salt Baths
7-42, Vapor Cloud Explosions
7-43, Process Safety
7-45, Instrumentation and Control in Safety Applications
7-46, Chemical Reactors and Reactions
7-49, Emergency Venting of Vessels
7-50, Compressed Gases in Cylinders
7-51, Acetylene
7-53, Liquefied Natural Gas (LNG)
7-54, Natural Gas and Gas Piping
7-55, Liquefied Petroleum Gas
7-58, Chlorine Dioxide
7-59, Inerting and Purging of Vessels and Equipment
7-61, Facilities Processing Radioactive Materials
7-64, Aluminum Industries
7-72, Reformer and Cracking Furnace
7-73, Dust Collectors and Collection Systems
7-74, Distilleries
7-75, Grain Storage and Milling
7-76, Prevention and Mitigation of Combustible Dust Explosion and Fire
7-77, Testing Internal Combustion Engines and Accessories
7-78, Industrial Exhaust Systems
7-79, Fire Protection for Gas Turbine and Electric Generators
7-80, Organic Peroxides
7-83, Drainage Systems for Ignitable Liquids
7-85, Combustible and Reactive Metals
7-86, Cellulose Nitrate
7-88, Outdoor Ignitable Storage Tanks
7-89, Ammonium Nitrate and Mixed Fertilizers Containing Ammonium Nitrate
7-91, Hydrogen
7-92, Ethylene Oxide
7-93, Aircraft Hangars, Aircraft Manufacturing and Assembly Facilities
7-95, Compressors
7-96, Printing Plants
7-97, Metal Cleaning
7-98, Hydraulic Fluids
7-99, Heat Transfer Fluid Systems
7-101, Fire Protection for Steam Turbines and Electric Generators
7-103, Turpentine Recovery in Pulp and Paper Mills
7-104, Metal Treatment Processes for Steel Mills
7-105, Concentrating Solar Power
7-106, Ground Mounted Photovoltaic Solar Power
7-107, Natural Gas Transmission and Storage
7-108, Silane
7-109, Fuel Fired Thermal Electric Power Generation Facilities
7-110, Industrial Control Systems 
7-111, Chemical Process Industries 
7-111A, Fuel-Grade Ethanol 
7-111B, Carbon Black 
7-111C, Titanium Dioxide
7-111D, Oilseed Processing 
7-111E, Chloro-Alkali 
7-111F, Sulfuric Acid 
7-111G, Ammonia and Ammonia Derivatives 
7-111H, Olefins
7-111I, Ink, Paint and Coating Formulations
8-1, Commodity Classification
8-3, Rubber Tire Storage
8-7, Baled Fiber Storage
8-9, Storage of Class 1, 2, 3, 4 and Plastic Commodities
8-10, Coal and Charcoal Storage
8-18, Storage of Hanging Garments
8-21, Roll Paper Storage
8-22, Storage of Baled Waste Paper
8-23, Rolled Nonwoven Fabric Storage
8-24, Idle Pallet Storage
8-27, Storage of Wood Chips
8-28, Pulpwood and Outdoor Log Storage
8-30, Storage of Carpets
8-33, Carousel Storage and Retrieval Systems
8-34, Protection for Automatic Storage and Retrieval Systems
9-0, Asset Integrity
9-1, Supervision of Property
9-16, Burglary and Theft
9-18, Prevention of Freeze-ups
9-19, Wildland Fire
10-0, The Human Factor of Property Conservation
10-1, Pre-Incident and Emergency Response Planning
10-3, Hot Work Management
10-4, Contractor Management
10-5, Disaster Recovery and Contingency Plan
10-6, Protection Against Arson and Other Incendiary Fires
10-7, Fire Protection Impairment Management
10-8, Operators
12-2, Vessels & Piping
12-3, Continuous Digesters & Related Vessels
12-6, Batch Digesters & Related Vessels
12-43, Pressure Relief Devices
12-53, Absorption Refrigeration Systems
13-1, Cold Mechanical Repairs
13-2, Hydroelectric Power Plants
13-3, Steam Turbines
13-6, Flywheels and Pulleys
13-7, Gears
13-8, Power Presses
13-10, Wind Turbines and Farms
13-17, Gas Turbines
13-18, Industrial Clutches and Clutch Couplings
13-24, Fans and Blowers
13-26, Internal Combustion Engines
13-27, Heavy Duty Mobile Equipment
13-28, Aluminum Industries
17-0, Asset Integrity
17-2, Process Safety
17-4, Monitoring and Diagnosis of Vibration in Rotating Machinery
17-11, Chemical Reactors and Reactions
17-12, Semiconductor Fabrication Facilities
17-16, Cranes
)"
mList := Map(
	'1-0', 'Safeguards During Construction, Alteration and Demolition',
	'1-1', 'Firesafe Building Construction and Materials',
	'1-2', 'Earthquakes',
	'1-3', 'High-Rise Buildings',
	'1-4', 'Fire Tests',
	'1-6', 'Cooling Towers',
	'1-8', 'Antenna Towers and Signs',
	'1-9', 'Roof Anchorage for Older, Wood-Roofed Buildings',
	'1-10', 'Smoke and Heat Venting in Sprinklered Buildings ',
	'1-11', 'Fire Following Earthquakes ',
	'1-12', 'Ceilings and Concealed Spaces ',
	'1-13', 'Chimneys ',
	'1-15', 'Roof Mounted Solar Photovoltaic Panels ',
	'1-17', 'Reflective Ceiling Insulation ',
	'1-20', 'Protection Against Exterior Fire Exposure ',
	'1-21', 'Fire Resistance of Building Assemblies ',
	'1-22', 'Maximum Foreseeable Loss ',
	'1-24', 'Protection Against Liquid Damage ',
	'1-26', 'Steep-Slope Roof Systems ',
	'1-27', 'Windstorm  Retrofit and Loss Expectancy (LE) Guidelines ',
	'1-28', 'Wind Design ',
	'1-29', 'Roof Deck Securement and Above-Deck Roofing  Components ',
	'1-30', 'Repair of Wind Damaged Roof Systems ',
	'1-31', 'Panel Roof Systems ',
	'1-32', 'Inspection and Maintenance of Roof Assemblies ',
	'1-33', 'Safeguarding Torch - Applied Roof Installations ',
	'1-34', 'Hail Damage ',
	'1-35', 'Vegetative Roof Systems Vegetative Roof Systems, Occupied Roof Areas & Decks' ,
	'1-36', 'Mass Engineered Timber ',
	'1-37', 'Hospitals' ,
	'1-40', 'Flood ',
	'1-41', 'Dam Evaluations ',
	'1-42', 'MFL Limiting Factors' ,
	'1-44', 'Damage-Limiting Construction ',
	'1-45', 'Air Conditioning and Ventilating Systems ',
	'1-49', 'Perimeter Flashing ',
	'1-52', 'Field  Verification of Roof Wind Uplift Resistance ',
	'1-53', 'Anechoic Chambers ',
	'1-54', 'Roof Loads and Drainage ',
	'1-55', 'Weak Construction and Design ',
	'1-56', 'Cleanrooms ',
	'1-57', 'Plastics in Construction ',
	'1-59', 'Fabric and Membrane Covered Structures ',
	'1-60', 'Asphalt-Coated/Protected Metal Buildings ',
	'1-61', 'Impregnated Fire-Retardant Lumber ',
	'1-62', 'Cranes ',
	'1-63', 'Exterior Insulation and Finish Systems ',
	'1-64', 'Exterior Walls and Facades ',
	'2-0', 'Installation Guidelines for Automatic Sprinklers ',
	'2-1', 'Corrosion in Automatic Sprinkler Systems ',
	'2-8', 'Earthquake Protection for Water-Based Fire Protection Systems ',
	'2-81', 'Fire Protection System Inspection, Testing and Maintenance ',
	'2-89', 'Pipe Friction Loss Tables ',
	'3-0', 'Hydraulics of Fire Protection Systems ',
	'3-1', 'Tanks and Reservoirs for Interconnected Fire Service and Public Mains ',
	'3-2', 'Water Tanks for Fire Protection ',
	'3-3', 'Cross Connections ',
	'3-4', 'Embankment-Supported Fabric Tanks ',
	'3-6', 'Lined Earth Reservoirs for Fire Protection ',
	'3-7', 'Fire Protection Pump ',
	'3-10', 'Installation/Maintenance of  Fire Service Mains ',
	'3-11', 'Flow and Pressure Regulating Devices for Fire Protection Service ',
	'3-26', 'Fire Protection Water Demand for Nonstorage Sprinklered Properties ',
	'3-29', 'Reliability of Fire Protection Water Supplies ',
	'4-0', 'Special Protection Systems ',
	'4-1N', 'Fixed Water Spray Systems for Fire Protection ',
	'4-2', 'Water Mist Systems ',
	'4-3N', 'Medium and High Expansion Foam Systems ',
	'4-4N', 'Standpipe and Hose Systems ',
	'4-5', 'Portable Extinguishers ',
	'4-6', 'Hybrid Fire Extinguishing Systems ',
	'4-8N', 'Halon 1301 Extinguishing Systems ',
	'4-9', 'Halocarbon and Inert Gas (Clean Agent) Fire Extinguishing Systems ',
	'4-10', 'Dry Chemical Systems ',
	'4-11N', 'Carbon Dioxide Extinguishing Systems (NFPA)',
	'4-12', 'Foam Water Extinguishing  Systems ',
	'4-13', 'Oxygen Reduction Systems ',
	'5-1', 'Electrical Equipment in Hazardous (Classified) Locations ',
	'5-3', 'Hydroelectric Power Plants ',
	'5-4', 'Transformers ',
	'5-8', 'Static Electricity ',
	'5-11', 'Lightning and Surge Protection for Electrical Systems ',
	'5-12', 'Electric AC Generators ',
	'5-14', 'Telecommunications ',
	'5-17', 'Motors & Adjustable Speed Drives ',
	'5-18', 'Protection of Electrical Equipment ',
	'5-19', 'Switchgear and Circuit Breakers ',
	'5-20', 'Electrical Testing ',
	'5-21', 'Metal Halide High-Intensity Discharge Lighting ',
	'5-23', 'Design and Fire Protection for Emergency and Standby Power Systems ',
	'5-24', 'Miscellaneous Electrical Equipment ',
	'5-25', 'High Voltage Direct Current Converter  Stations ',
	'5-28', 'DC Battery Systems ',
	'5-30', 'Power Factor Correction and Static Reactive Compensator Systems ',
	'5-31', 'Cables and Bus Bars ',
	'5-32', 'Data Centers and Related Facilities ',
	'5-33', 'Electrical Energy Storage Systems' ,
	'5-40', 'Fire Alarm Systems ',
	'5-48', 'Automatic Fire Detection ',
	'5-49', 'Gas and Vapor Detectors and Analysis Systems ',
	'6-0', 'Elements of Industrial Heating Equipment ',
	'6-2', 'Pulverized Coal Fired  Boilers ',
	'6-3', 'Induction and Dielectric Heating Equipment ',
	'6-4', 'Oil- and Gas-Fired Single-Burner Boilers ',
	'6-5', 'Oil- or Gas-Fired Multiple Burner Boilers ',
	'6-6', 'Boiler-Furnaces Implosions ',
	'6-7', 'Fluidized Bed Combustors ',
	'6-8', 'Combustion Air Heaters ',
	'6-9', 'Industrial Ovens and Dryers ',
	'6-10', 'Process Furnaces ',
	'6-11', 'Thermal and Regenerative Catalytic Oxidizers ',
	'6-12', 'Low-Water Protection ',
	'6-13', 'Waste Fuel Fired Facilities ',
	'6-14', 'Waste Heat Boilers ',
	'6-17', 'Rotary Kilns and Dryers ',
	'6-21', 'Chemical Recovery Boilers ',
	'6-22', 'Firetube Boilers ',
	'6-23', 'Watertube Boilers ',
	'7-0', 'Causes and Effects of Fires and Explosions ',
	'7-1', 'Fire Protection for Textile Mills ',
	'7-2', 'Waste Solvent Recovery ',
	'7-3', 'Flight Simulator System Protection ',
	'7-4', 'Paper Machines and Pulp Dryers ',
	'7-6', 'Heated Plastic and Plastic-Lined Tanks ',
	'7-7', 'Semiconductor Fabrication Facilities ',
	'7-9', 'Dip Tanks, Flow Coaters and Roll Coaters ',
	'7-10', 'Wood Processing and Woodworking Facilities ',
	'7-11', 'Conveyors ',
	'7-12', 'Mining and Mineral Processing ',
	'7-13', 'Mechanical Refrigeration ',
	'7-14', 'Fire Protection for Chemical Plants ',
	'7-15', 'Garages ',
	'7-17', 'Explosion Suppression Systems ',
	'7-19N', 'Fire Hazard Properties of Flammable Liquids, Gases, and Volatile Solids ',
	'7-20', 'Oil Cookers ',
	'7-21', 'Rolling Mills ',
	'7-22', 'Hydrazine and its Derivatives ',
	'7-23', 'Data on General Class of Chemicals ',
	'7-23N', 'Hazardous Chemicals Data ',
	'7-24', 'Blowing Agents ',
	'7-25', 'Molten Steel Production ',
	'7-26', 'Glass Manufacturing ',
	'7-27', 'Spray Application of Ignitable and Combustible Materials ',
	'7-28', 'Energetic Materials ',
	'7-29', 'Ignitable Liquid Storage in Portable Containers ',
	'7-31', 'Storage of Aerosol Products ',
	'7-32', 'Ignitable Liquid Operations ',
	'7-33', 'High-Temperature Molten Materials ',
	'7-35', 'Air Separation Processes ',
	'7-36', 'Pharmaceutical Operations ',
	'7-37', 'Cutting Fluids ',
	'7-39', 'Industrial Trucks ',
	'7-40', 'Heavy Duty Mobile Equipment ',
	'7-41', 'Heat Treating of Materials Using Oil Quenching and Molten Salt Baths ',
	'7-42', 'Vapor Cloud Explosions ',
	'7-43', 'Process Safety ',
	'7-45', 'Instrumentation and Control in Safety Applications ',
	'7-46', 'Chemical Reactors and Reactions ',
	'7-49', 'Emergency Venting of Vessels ',
	'7-50', 'Compressed Gases in Cylinders ',
	'7-51', 'Acetylene ',
	'7-53', 'Liquefied Natural Gas (LNG) ',
	'7-54', 'Natural Gas and Gas Piping ',
	'7-55', 'Liquefied Petroleum Gas ',
	'7-58', 'Chlorine Dioxide ',
	'7-59', 'Inerting and Purging of Vessels and Equipment ',
	'7-61', 'Facilities Processing Radioactive Materials ',
	'7-64', 'Aluminum Industries ',
	'7-72', 'Reformer and Cracking Furnace ',
	'7-73', 'Dust Collectors and Collection Systems ',
	'7-74', 'Distilleries ',
	'7-75', 'Grain Storage and Milling ',
	'7-76', 'Prevention and Mitigation of Combustible Dust Explosion and Fire ',
	'7-77', 'Testing Internal Combustion Engines and Accessories ',
	'7-78', 'Industrial Exhaust Systems ',
	'7-79', 'Fire Protection for Gas Turbine and Electric Generators ',
	'7-80', 'Organic Peroxides ',
	'7-83', 'Drainage Systems for Ignitable Liquids ',
	'7-85', 'Combustible and Reactive Metals ',
	'7-86', 'Cellulose Nitrate ',
	'7-88', 'Outdoor Ignitable Storage Tanks ',
	'7-89', 'Ammonium Nitrate and Mixed Fertilizers Containing Ammonium Nitrate ',
	'7-91', 'Hydrogen ',
	'7-92', 'Ethylene Oxide ',
	'7-93', 'Aircraft Hangars, Aircraft Manufacturing and Assembly Facilities ',
	'7-95', 'Compressors ',
	'7-96', 'Printing Plants ',
	'7-97', 'Metal Cleaning ',
	'7-98', 'Hydraulic Fluids ',
	'7-99', 'Heat Transfer Fluid Systems ',
	'7-101', 'Fire Protection for Steam Turbines and Electric Generators ',
	'7-103', 'Turpentine Recovery in Pulp and Paper Mills ',
	'7-104', 'Metal Treatment Processes for Steel Mills ',
	'7-105', 'Concentrating Solar Power ',
	'7-106', 'Ground Mounted Photovoltaic Solar Power ',
	'7-107', 'Natural Gas Transmission and Storage ',
	'7-108', 'Silane ',
	'7-109', 'Fuel Fired Thermal Electric Power Generation Facilities ',
	'7-110', 'Industrial Control Systems' ,
	'7-111', 'Chemical Process Industries' ,
	'7-111A', 'Fuel-Grade Ethanol',
	'7-111B', 'Carbon Black',
	'7-111C', 'Titanium Dioxide ',
	'7-111D', 'Oilseed Processing',
	'7-111E', 'Chloro-Alkali',
	'7-111F', 'Sulfuric Acid',
	'7-111G', 'Ammonia and Ammonia Derivatives',
	'7-111H', 'Olefins ',
	'7-111I', 'Ink, Paint and Coating Formulations ',
	'8-1', 'Commodity Classification ',
	'8-3', 'Rubber Tire Storage ',
	'8-7', 'Baled Fiber Storage ',
	'8-9', 'Storage of Class 1, 2, 3, 4 and Plastic Commodities ',
	'8-10', 'Coal and Charcoal Storage ',
	'8-18', 'Storage of Hanging Garments ',
	'8-21', 'Roll Paper Storage ',
	'8-22', 'Storage of Baled Waste Paper ',
	'8-23', 'Rolled Nonwoven Fabric Storage ',
	'8-24', 'Idle Pallet Storage ',
	'8-27', 'Storage of Wood Chips ',
	'8-28', 'Pulpwood and Outdoor Log Storage ',
	'8-30', 'Storage of Carpets ',
	'8-33', 'Carousel Storage and Retrieval Systems ',
	'8-34', 'Protection for Automatic Storage and Retrieval Systems ',
	'9-0', 'Asset Integrity ',
	'9-1', 'Supervision of Property ',
	'9-16', 'Burglary and Theft ',
	'9-18', 'Prevention of Freeze-ups ',
	'9-19', 'Wildland Fire ',
	'10-0', 'The Human Factor of Property Conservation ',
	'10-1', 'Pre-Incident and Emergency Response Planning ',
	'10-3', 'Hot Work Management ',
	'10-4', 'Contractor Management ',
	'10-5', 'Disaster Recovery and Contingency Plan ',
	'10-6', 'Protection Against Arson and Other Incendiary Fires ',
	'10-7', 'Fire Protection Impairment Management ',
	'10-8', 'Operators ',
	'12-2', 'Vessels & Piping ',
	'12-3', 'Continuous Digesters & Related Vessels ',
	'12-6', 'Batch Digesters & Related Vessels ',
	'12-43', 'Pressure Relief Devices ',
	'12-53', 'Absorption Refrigeration Systems ',
	'13-1', 'Cold Mechanical Repairs ',
	'13-2', 'Hydroelectric Power Plants ',
	'13-3', 'Steam Turbines ',
	'13-6', 'Flywheels and Pulleys ',
	'13-7', 'Gears ',
	'13-8', 'Power Presses ',
	'13-10', 'Wind Turbines and Farms ',
	'13-17', 'Gas Turbines ',
	'13-18', 'Industrial Clutches and Clutch Couplings ',
	'13-24', 'Fans and Blowers ',
	'13-26', 'Internal Combustion Engines ',
	'13-27', 'Heavy Duty Mobile Equipment ',
	'13-28', 'Aluminum Industries ',
	'17-0', 'Asset Integrity ',
	'17-2', 'Process Safety ',
	'17-4', 'Monitoring and Diagnosis of Vibration in Rotating Machinery ',
	'17-11', 'Chemical Reactors and Reactions ',
	'17-12', 'Semiconductor Fabrication Facilities ',
	'17-16', 'Cranes',
)
wordList := Sort(wordList)
kList := []
vList := []
kL := ''
for key, value in mList {
	kList.SafePush(key)
	vList.SafePush(value)
}

inputStart()
; ---------------------------------------------------------------------------
; @Step ...: Begin input collection
; ---------------------------------------------------------------------------
inputStart() { 
	Global suffix := ""
	ih :=   InputHook('IV*E', "{LControl}{RControl}{LAlt}{RAlt}{LWin}{RWin}{AppsKey}"
					. "{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}"
					. "{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}"
					. "{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}{Tab}{Esc}")
	ih.Wait(.01)
	; _AE_bInpt_sLvl(1)
	ih.OnChar := (ih, char)   => SetTimer(inputMatch.Bind(ih, char), -750) ; Each char starts the timer
	; _AE_bInpt_sLvl(0)
	ih.OnEnd  := inputEnded    ; Call function when input is terminated
	ih.Start()
}

; ---------------------------------------------------------------------------
; @Section ...: Executes when typing ends & timer expires
; ---------------------------------------------------------------------------
inputMatch(ih, char) {
	Global suffix := ""
	mMatch := []
	static prev := ''
	local txt := '', ctxt := '', hSplit := ''
	; If RegExMatch(ih.Input, "D)\w+$", &prefix) &&                 ; If input ends in word chars,
	; @i ...: If input ends in word chars, and chars match something in word list

	if ((GetKeyState("Delete", "P")) || (GetKeyState("Backspace", "P"))){
		return
	}
	; ---------------------------------------------------------------------------
	; @i ...: To make sure ih.Input is fully a string, and simplify with shorter var
	; ---------------------------------------------------------------------------
	txt := String(ih.Input)
	ctxt := String(ih.Input)
	; ---------------------------------------------------------------------------
	; @i ...: Get the Section number of the DS, and make it static (static prev := '') to remember between calls in the event you mess up and need to change the number.
	; ---------------------------------------------------------------------------
	; hSplit := txt.RegExReplace('(\d+?)\-[\d\w]+', '$1' )
	needle := '(\d{1,2})-[\d\w]+'
	ctxt.RegExMatch(needle, &hSplit )
	prev := hSplit[]
	; ---------------------------------------------------------------------------
	try tooltip(
		'txt: ' txt
		'`n'
		'P: ' prev
		'`n'
		'T[' true '] | F[' false ']'
		'`n'
		'T|F: ' mList.Has(txt)
		'`n'
		'V: ' mList.Get(txt)
		'`n'
		mList[txt]
	)
	; If RegExMatch(ih.Input, "(\d{1,2}-\d{1,2})", &prefix) && RegExMatch(kL, "`nmi)^" prefix[] "\K.*", &suffix) {
	; If RegExMatch(txt, '(\d+?\-[\d\w]+)', &prefix) && RegExMatch(mList.Get(txt), '\' mList[txt] "\K.*", &suffix) {
	If RegExMatch(txt, '(\d+?\-[\d\w]+)', &prefix) && RegExMatch(mList.Get(txt), '\' mList[txt] ".*", &suffix) {
		; ---------------------------------------------------------------------------
		; @i ...: Send to AutoComplete()
		; ---------------------------------------------------------------------------
		Infos(prefix[])
		AutoComplete(txt,mList)
		; Infos.DestroyAll()
		; Infos('p: ' prev)
	}
	ih.KeyOpt("{Tab}{Esc}", suffix = "" ? "-S" : "+S")            ; If suffix exists, suppress these keys
	; ToolTip 'Input = #' ih.Input '#`nSuffix = #' suffix '#'
}

; @Section ...: Executes when input is terminated
inputEnded(ih, vk := "", sc := "") {
	; ToolTip( '#' ih.Input '# #' suffix '# #' ih.EndKey '#')
	; @i ...: F4 = exit this script
	(ih.EndKey = "F4") && (SoundBeep(1500), ExitApp())
	; @i ...: If suffix exists, handle these conditions
	If suffix != "" {
		Switch ih.EndKey {
			; @i ...: TAB is RIGHT: this will preserve the selected text
			Case "Tab"   : Send( '{Right}')
			; @i ESC is BACKSPACE: this will delete the selected text
			Case "Escape": Send( '{BS}')
		}
	}
	inputStart()
}
AutoComplete(CtlObj := '', ListObj := '', GuiObj?) {
	; static CB_GETEDITSEL := 320, CB_SETEDITSEL := 322, valueFound := false
	static EM_GETSEL := 176, EM_SETSEL := 177, valueFound := false
	local Start :=0, End := 0, curr := ''
	cText := ListObj.Get(CtlObj)
	currContent := CtlObj
	ToolTip()
	ToolTip(currContent)
	try sCurr := StrSplit(currContent, '-', ' ')
	try curr := Trim(sCurr[2])
	; try {
		ToolTip()
		ToolTip(curr ' ' curr.length)
	; }
	; CtlObj.Value := currContent
	; ListObj[CtlObj] := currContent
	; ToolTip(currContent ', ' cText)
	; QSGui.Add('Text','Section','Text')
	; QSGui.Show("AutoSize")
	; QSGui.Show()
	if ((GetKeyState("Delete", "P")) || (GetKeyState("Backspace", "P"))){
		return
	}

	valueFound := false
	for key, value in ListObj {
	; for index, value in entries
		; Check if the current value matches the target value
		
		if (key = currContent)
		{
			valueFound := true
			SendLevel(1)
			text := ', ^i' value '^i'
			Send(text)
			Send( "+{Left " StrLen(cText)+(curr.length + 2) "}")
			break ; Exit the loop if the value is found
		}
	}
	if (valueFound){
		
		return ; Exit Nested request
	}
	; Start := 0, End :=0
	MakeShort(0, &Start, &End)
	try {
		; if (ControlChooseString(CtlObj.Text, CtlObj) > 0) {
		if (ListObj.Has(CtlObj)) {
			Start := StrLen(currContent)
			End := StrLen(cText)
			PostMessage(EM_SETSEL, 0, MakeLong(Start, End),,'A')
		}
	} Catch as e {
		; ControlSetText( currContent, CtlObj)
		; ControlSetText((', ^i' cText '^i '), WinActive('A'))
		PostMessage(EM_GETSEL := 176, 0, MakeLong(StrLen(cText), StrLen(cText)),,'A')
	}

	MakeShort(Long, &LoWord, &HiWord) => (LoWord := Long & 0xffff, HiWord := Long >> 16)

	MakeLong(LoWord, HiWord) {
		return (HiWord << 16) | (LoWord & 0xffff)
	}
}