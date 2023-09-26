﻿/*
/*
Evaluates and classifies file type based on it's extension as;
Audio,Video,Raster Image, Vector Image, 3D Image, Backup file, CAD file, RAW Camera file, Compressed, Data file, Developer file, Disk Image, eBook, Encoded, Executable, Font, Game file, 
GIS file, Page Layout file, Plugin file, Settings file, Spreadsheet, System file, Text, Web Format File & Misc file(doesn't fit in any other category) such as '.torrent'...

FILE format listings used were retrieved from:
https://fileinfo.com/browse
*/


; Loop{
; FileSelectFile, SelectedFile, , C:\#TMP, Select a file to evaluate!
; MsgBox, % FileIsType(SelectedFile)
; }
; Esc::ExitApp


FileIsType(fPath){	;if no filtype match is found,returns nothing.
;re/sets global variables so as to remove the need to check for each type file format category,i.e an 'is_video' check can be true/false,even if the file is also detected as another type as well.
Global is_audio,is_video,is_rasterImage,is_vectorImage,is_web,is_spreadsheet,is_system,is_pageLayout,is_encoded,is_gis,is_3dImage,is_diskImage,is_cameraRaw,is_cad,is_backup,is_compressed,is_database,is_data,is_developer,is_eBook,is_text,is_executable,is_plugin,is_font,is_misc
Global gvarList
gvarList=is_audio,is_video,is_rasterImage,is_vectorImage,is_web,is_spreadsheet,is_system,is_pageLayout,is_encoded,is_gis,is_3dImage,is_diskImage,is_cameraRaw,is_cad,is_backup,is_compressed,is_database,is_data,is_developer,is_eBook,is_text,is_executable,is_plugin,is_font,is_misc
varList=audio,video,rasterImage,vectorImage,web,spreadsheet,system,game,settings,pageLayout,encoded,gis,3dImage,diskImage,cameraRaw,cad,backup,compressed,database,data,developer,eBook,text,executable,plugin,font,misc

SplitPath, fPath ,,, fPathExt
if (!fPath OR !fPathExt)
	Return

audio=
(
3GA,4MP,5XB,5XE,5XS,669,8SVX,A2B,A2I,A2M,AA,AA3,AAC,AAX,AB,ABC,ABM,AC3,ACB,ACD,ACD-BAK,ACD-ZIP,ACM,ACP,ACT,ADG,ADT,ADTS,ADV,AFC,AGM,AGR,AIF,AIFC,AIFF,AIMPPL,AKP,ALC,ALL,ALS,AMF,AMR,AMS,AMS,AMXD,AMZ,ANG,AOB,APE,APL,ARIA,ARIAX,ASD,AT3,AU,AUD,AUP,AVASTSOUNDS,AY,B4S,BAND,BAP,BDD,BIDULE,BNK,BRSTM,BUN,BWF,BWG,BWW,CAF,CAFF,CDA,CDDA,CDLX,CDO,CDR,CEL,CFA,CGRP,CIDB,CKB,CKF,CONFORM,COPY,CPR,CPT,CSH,CTS,CWB,CWP,CWS,CWT,DCF,DCM,DCT,DEWF,DF2,DFC,DFF,DIG,DIG,DLS,DM,DMC,DMF,DMSA,DMSE,DRA,DRG,DS,DS2,DSF,DSM,DSS,DTM,DTS,DTSHD,DVF,DWD,EFA,EFE,EFK,EFQ,EFS,EFV,EMD,EMP,EMX,ESPS,EXPRESSIONMAP,EXS,F2R,F32,F3R,F4A,F64,FDP,FEV,FLAC,FLM,FLP,FLP,FPA,FRG,FSB,FSC,FSM,FTM,FTM,FTMX,FZF,FZV,G721,G723,G726,GBPROJ,GBS,GIG,GP5,GPBANK,GPK,GPX,GROOVE,GSF,GSFLIB,GSM,H0,H4B,H5B,H5E,H5S,HBE,HDP,HMA,HSB,IAA,ICS,IFF,IGP,IGR,IMP,INS,INS,ISMA,ITI,ITLS,ITS,JAM,JSPF,K26,KAR,KFN,KMP,KOZ,KOZ,KPL,KRZ,KSC,KSF,KT3,L,LA,LOF,LOGIC,LOGICX,LSO,LWV,M3U,M3U8,M4A,M4B,M4P,M4R,M5P,MA1,MBR,MDC,MDR,MED,MGV,MID,MIDI,MINIGSF,MINIPSF,MINIUSF,MKA,MMF,MMLP,MMM,MMP,MMPZ,MO3,MOD,MOGG,MP2,MP3,MPA,MPC,MPDP,MPGA,MPU,MSCX,MSCZ,MSV,MT2,MTE,MTF,MTI,MTM,MTP,MTS,MUI,MUS,MUS,MUS,MUSX,MUX,MX3,MX4,MX5,MX5TEMPLATE,MXL,MXMF,MYR,NARRATIVE,NBS,NCW,NKB,NKC,NKI,NKM,NKS,NKX,NML,NMSV,NOTE,NPL,NRA,NRT,NSA,NST,NTN,NVF,NWC,OBW,ODM,OFR,OGA,OGG,OKT,OMA,OMF,OMG,OMX,OPUS,OTS,OVE,OVW,OVW,PAC,PANDORA,PBF,PCA,PCAST,PCG,PEAK,PEK,PHO,PHY,PK,PKF,PLA,PLS,PLY,PNA,PNO,PPC,PPCX,PRG,PSF,PSF1,PSM,PSY,PTCOP,PTF,PTM,PTS,PTT,PTX,PTXT,PVC,QCP,R1M,RA,RAM,RAW,RAX,RBS,RBS,RCY,REX,RFL,RGRP,RIP,RMI,RMJ,RMX,RNG,RNS,ROL,RSN,RSO,RTA,RTI,RTS,RVX,RX2,S3I,S3M,S3Z,SAF,SAP,SBG,SBI,SC2,SCS11,SD,SD,SD2,SD2F,SDAT,SDS,SDT,SEQ,SES,SESX,SF2,SFAP0,SFK,SFL,SFPACK,SFS,SFZ,SGP,SHN,SIB,SLP,SLX,SMA,SMF,SMP,SMP,SMPX,SND,SND,SND,SNG,SNG,SNS,SONG,SOU,SPPACK,SPRG,SPX,SSEQ,SSEQ,SSM,SSND,STAP,STM,STX,STY,SVD,SVX,SWA,SXT,SYH,SYN,SYW,SYX,TAK,TAK,TD0,TG,TOC,TRAK,TTA,TXW,U,UAX,ULT,UNI,USF,USFLIB,UST,UW,UWF,VAG,VAP,VB,VC3,VDJ,VGM,VGZ,VIP,VLC,VMD,VMF,VMF,VMO,VOC,VOX,VOXAL,VPL,VPM,VPW,VQF,VRF,VSQ,VSQX,VTX,VYF,W01,W64,WAV,WAVE,WAX,WEM,WFB,WFD,WFM,WFP,WMA,WOW,WPK,WPP,WPROJ,WRK,WTPL,WTPT,WUS,WUT,WV,WVC,WVE,WWU,XA,XA,XFS,XM,XMF,XMU,XRNS,XSP,XSPF,YOOKOO,ZPA,ZPL,ZVD
)


video=
(
264,3G2,3GP,3GP2,3GPP,3GPP2,3MM,3P2,60D,787,890,AAF,AEC,AEP,AEPX,AET,AETX,AJP,ALE,AM,AMC,AMV,AMX,ANIM,ANX,AQT,ARCUT,ARF,ASF,ASX,AVB,AVC,AVCHD,AVD,AVI,AVM,AVP,AVS,AVS,AVV,AWLIVE,AXM,AXV,BDM,BDMV,BDT2,BDT3,BIK,BIN,BIX,BMC,BMK,BNP,BOX,BS4,BSF,BU,BVR,BYU,CAMPROJ,CAMREC,CAMV,CED,CEL,CINE,CIP,CLK,CLPI,CMMP,CMMTPL,CMPROJ,CMREC,CMV,CPI,CPVC,CREC,CST,CVC,CX3,D2V,D3V,DASH,DAT,DAV,DB2,DCE,DCK,DCR,DCR,DDAT,DIF,DIR,DIVX,DLX,DMB,DMSD,DMSD3D,DMSM,DMSM3D,DMSS,DMX,DNC,DPA,DPG,DREAM,DSY,DV,DV-AVI,DV4,DVDMEDIA,DVR,DVR-MS,DVX,DXR,DZM,DZP,DZT,EDL,EVO,EVO,EXO,EYE,EYETV,EZT,F4F,F4M,F4P,F4V,FBR,FBR,FBZ,FCARCH,FCP,FCPROJECT,FFD,FFM,FLC,FLH,FLI,FLIC,FLV,FLX,FPDX,FTC,G2M,G64,GCS,GFP,GIFV,GL,GOM,GRASP,GTS,GVI,GVP,GXF,H264,HDMOV,HDV,HKM,IFO,IMOVIELIBRARY,IMOVIEMOBILE,IMOVIEPROJ,IMOVIEPROJECT,INP,INT,IRCP,IRF,ISM,ISMC,ISMCLIP,ISMV,IVA,IVF,IVR,IVS,IZZ,IZZY,JMV,JSS,JTS,JTV,K3G,KDENLIVE,KMV,KTN,LREC,LRV,LSF,LSX,LVIX,M15,M1PG,M1V,M21,M21,M2A,M2P,M2T,M2TS,M2V,M4E,M4U,M4V,M75,MANI,META,MGV,MJ2,MJP,MJPEG,MJPG,MK3D,MKV,MMV,MNV,MOB,MOD,MODD,MOFF,MOI,MOOV,MOV,MOVIE,MP21,MP21,MP2V,MP4,MP4INFOVID,MP4V,MPE,MPEG,MPEG1,MPEG2,MPEG4,MPF,MPG,MPG2,MPG4,MPGINDEX,MPL,MPL,MPLS,MPROJ,MPSUB,MPV,MPV2,MQV,MSDVD,MSE,MSH,MSWMM,MT2S,MTS,MTV,MVB,MVC,MVD,MVE,MVEX,MVP,MVP,MVY,MXF,MXV,MYS,N3R,NCOR,NFV,NSV,NTP,NUT,NUV,NVC,OGM,OGV,OGX,ORV,OSP,OTRKEY,PAC,PAR,PDS,PGI,PHOTOSHOW,PIV,PJS,PLAYLIST,PLPROJ,PMF,PMV,PNS,PPJ,PREL,PRO,PRO4DVD,PRO5DVD,PROQC,PRPROJ,PRTL,PSB,PSH,PSSD,PVA,PVR,PXV,QT,QTCH,QTINDEX,QTL,QTM,QTZ,R3D,RCD,RCPROJECT,RCREC,RCUT,RDB,REC,RM,RMD,RMD,RMP,RMS,RMV,RMVB,ROQ,RP,RSX,RTS,RTS,RUM,RV,RVID,RVL,SAN,SBK,SBT,SBZ,SCC,SCM,SCM,SCN,SCREENFLOW,SDV,SEC,SEC,SEDPRJ,SEQ,SFD,SFERA,SFVIDCAP,SIV,SMI,SMI,SMIL,SMK,SML,SMV,SNAGPROJ,SPL,SQZ,SRT,SSF,SSM,STL,STR,STX,SVI,SWF,SWI,SWT,TDA3MT,TDT,TDX,THEATER,THP,TID,TIVO,TIX,TOD,TP,TP0,TPD,TPR,TREC,TRP,TS,TSP,TTXT,TVLAYER,TVRECORDING,TVS,TVSHOW,USF,USM,V264,VBC,VC1,VCPF,VCR,VCV,VDO,VDR,VDX,VEG,VEM,VEP,VF,VFT,VFW,VFZ,VGZ,VID,VIDEO,VIEWLET,VIV,VIVO,VIX,VLAB,VMLF,VMLT,VOB,VP3,VP6,VP7,VPJ,VR,VRO,VS4,VSE,VSP,VTT,W32,WCP,WEBM,WFSP,WGI,WLMP,WM,WMD,WMMP,WMV,WMX,WOT,WP3,WPL,WSVE,WTV,WVE,WVM,WVX,WXP,XEJ,XEL,XESC,XFL,XLMV,XML,XMV,XVID,Y4M,YOG,YUV,ZEG,ZM1,ZM2,ZM3,ZMV
)


rasterImage=
(
001,2BP,360,411,73I,8CA,8CI,8PBS,8XI,9PNG,ABM,ACCOUNTPICTURE-MS,ACORN,ACR,ADC,AFX,AGIF,AGP,AIC,AIS,ALBM,APD,APM,APNG,APS,APX,ARR,ART,ARTWORK,ARW,AVATAR,AVB,AWD,AWD,BLKRT,BLZ,BM2,BMC,BMF,BMP,BMQ,BMX,BMZ,BPG,BRK,BRN,BRT,BSS,BTI,BW,C4,CAL,CALS,CAM,CAN,CD5,CDC,CDG,CE,CID,CIMG,CIN,CIT,CLIP,CMR,COLZ,CPBITMAP,CPC,CPD,CPG,CPS,CPT,CPX,CSF,CT,CUT,DC2,DCM,DCX,DDB,DDS,DDT,DGT,DIB,DIC,DICOM,DJV,DJVU,DM3,DMI,DPX,DRZ,DT2,DTW,DVL,ECW,EPP,EXR,FAC,FACE,FAL,FAX,FBM,FIL,FITS,FLIF,FPG,FPOS,FPPX,FPX,FRM,G3,GBR,GCDP,GFB,GFIE,GGR,GIF,GIH,GIM,GMBCK,GMSPR,GP4,GPD,GRO,GROB,GRY,HDP,HDR,HDRP,HF,HPI,HR,HRF,I3D,IC1,IC2,IC3,ICA,ICB,ICN,ICON,ICPR,ILBM,IMG,IMJ,INFO,INK,INT,IPHOTOPROJECT,IPICK,IPX,ITC2,ITHMB,IVR,IVUE,IWI,J,J2C,J2K,JAS,JB2,JBF,JBG,JBIG,JBIG2,JBMP,JBR,JFI,JFIF,JIA,JIF,JIFF,JNG,JP2,JPC,JPD,JPE,JPEG,JPF,JPG,JPG2,JPS,JPX,JTF,JWL,JXR,KDI,KDK,KFX,KIC,KODAK,KPG,LB,LBM,LIF,LIP,LJP,LRPREVIEW,LZP,MAC,MAT,MAX,MBM,MBM,MCS,MET,MIC,MIFF,MIP,MIX,MNG,MNR,MPF,MPO,MRB,MRXS,MSK,MSP,MXI,MYL,NCD,NCR,NCT,NEO,NLM,NOL,OC3,OC4,OC5,OCI,ODI,OMF,OPLC,ORA,OTA,OTB,OTI,OZB,OZJ,OZT,PAC,PAL,PANO,PAP,PAT,PBM,PC1,PC2,PC3,PCD,PCX,PDD,PDN,PE4,PE4,PFI,PFR,PGF,PGM,PI1,PI2,PI2,PI3,PI4,PI5,PI6,PIC,PIC,PIC,PICNC,PICT,PICTCLIPPING,PISKEL,PIX,PIX,PIXADEX,PJPEG,PJPG,PM,PM3,PMG,PNC,PNG,PNI,PNM,PNS,PNT,PNTG,POP,POV,POV,PP4,PP5,PPF,PPM,PRW,PSB,PSD,PSDX,PSE,PSF,PSP,PSPBRUSH,PSPIMAGE,PTEX,PTG,PTK,PTS,PTX,PTX,PVR,PWP,PX,PXD,PXICON,PXM,PXR,PYXEL,PZA,PZP,PZS,QIF,QMG,QTI,QTIF,RAS,RCL,RCU,RGB,RGB,RGBA,RGF,RIC,RIF,RIFF,RIX,RLE,RLI,RPF,RRI,RS,RSB,RSR,RTL,RVG,S2MV,SAI,SAR,SBP,SCG,SCI,SCN,SCP,SCT,SCU,SDR,SEP,SFC,SFF,SFW,SGD,SGI,SHG,SID,SID,SIG,SIG,SIM,SKITCH,SKM,SKYPEEMOTICONSET,SLD,SMP,SOB,SPA,SPC,SPE,SPH,SPIFF,SPJ,SPP,SPR,SPRITE,SPRITE2,SPU,SR,STE,SUMO,SUN,SUNIFF,SUP,SVA,SVM,T2B,TAAC,TARGA,TB0,TBN,TEX,TFC,TG4,TGA,THM,THM,THUMB,TIF,TIF,TIFF,TJP,TM2,TN,TN1,TN2,TN3,TNY,TPF,TPI,TPS,TRIF,TSR,TUB,U,UFO,UGA,UGOIRA,URT,USERTILE-MS,V,VDA,VFF,VIC,VICAR,VIFF,VNA,VPE,VRIMG,VRPHOTO,VSS,VST,WB0,WB1,WB2,WBC,WBD,WBM,WBMP,WBP,WBZ,WDP,WEBP,WI,WIC,WMP,WPB,WPE,WVL,XBM,XCF,XPM,XWD,Y,YSP,YUV,ZIF,ZVI
)


vectorImage=
(
ABC,AC5,AC6,AF2,AF3,AFDESIGN,AI,ART,ARTB,ASY,AWG,CAG,CCX,CDD,CDDZ,CDLX,CDMM,CDMT,CDMTZ,CDMZ,CDR,CDS,CDSX,CDT,CDTX,CDX,CDX,CGM,CIL,CLARIFY,CMX,CNV,COR,CSY,CV5,CVG,CVI,CVS,CVX,CWT,CXF,DCS,DDRW,DED,DESIGN,DHS,DIA,DPP,DPR,DPX,DRAWING,DRAWIT,DRW,DRW,DSF,DXB,EGC,EMF,EMZ,EP,EPS,EPSF,ESC,EZDRAW,FH10,FH11,FH3,FH4,FH5,FH6,FH7,FH8,FH9,FHD,FIF,FIG,FMV,FS,FT10,FT11,FT7,FT8,FT9,FTN,FXG,GDRAW,GEM,GKS,GLOX,GLS,GRAFFLE,GSD,GSTENCIL,GTEMPLATE,HGL,HPG,HPGL,HPL,IDEA,IGT,IGX,IMD,INK,INK,LMK,MGC,MGCB,MGMF,MGMT,MGMX,MGS,MGTX,MMAT,MP,MVG,NAP,ODG,OTG,OVP,OVR,PAT,PCS,PD,PEN,PFD,PFV,PL,PLT,PLT,PMG,POBJ,PS,PSID,PWS,RDL,SCV,SDA,SK1,SK2,SKETCH,SLDDRT,SMF,SNAGITSTAMPS,SNAGSTYLES,SSK,STD,STN,SVF,SVG,SVGZ,SXD,TLC,TNE,TPL,UFR,VBR,VEC,VML,VSD,VSDM,VSDX,VST,VSTM,VSTX,WMF,WMZ,WPG,WPI,XAR,XMIND,XMMAP,XPR,YAL,ZGM
)


web=
(
A4P,A5W,ADR,AEX,ALX,AN,AP,APPCACHE,ARO,ASA,ASAX,ASCX,ASHX,ASMX,ASP,ASPX,ASR,ATOM,ATT,AWM,AXD,BML,BOK,BR,BROWSER,BTAPP,BWP,CCBJS,CDF,CER,CFM,CFML,CHA,CHAT,CHM,CMS,CODASITE,COMPRESSED,CON,CPG,CPHD,CRL,CRT,CSHTML,CSP,CSR,CSS,DAP,DBM,DCR,DER,DHTML,DISCO,DISCOMAP,DLL,DML,DO,DOCHTML,DOCMHTML,DOTHTML,DOWNLOAD,DWT,ECE,EDGE,EPIBRW,ESPROJ,EWP,FCGI,FMP,FREEWAY,FWP,FWTB,FWTEMPLATE,FWTEMPLATEB,GNE,GSP,HDM,HDML,HTACCESS,HTC,HTM,HTML,HTX,HXS,HYPE,HYPERESOURCES,HYPESYMBOL,HYPETEMPLATE,IDC,IQY,ITMS,ITPC,IWDGT,JCZ,JHTML,JNLP,JS,JSF,JSON,JSP,JSPA,JSPX,JSS,JST,JVS,JWS,KIT,LASSO,LBC,LESS,MAFF,MAP,MAPX,MASTER,MHT,MHTML,MOZ,MSPX,MUSE,MVC,MVR,NOD,NXG,NZB,OAM,OBML,OBML15,OBML16,OGNC,OLP,OPML,OTH,P12,P7,P7B,P7C,PAC,PAGE,PEM,PHP,PHP2,PHP3,PHP4,PHP5,PHTM,PHTML,PPTHTML,PPTMHTML,PRF,PRO,PSP,PTW,PUB,QBO,QBX,QF,QRM,RFLW,RHTML,RJS,RSS,RT,RW3,RWP,RWSW,RWTHEME,SASS,SAVEDDECK,SCSS,SDB,SEAM,SHT,SHTM,SHTML,SITE,SITEMAP,SITES,SITES2,SPC,SRF,SSP,STC,STL,STM,STML,STP,SUCK,SVC,SVR,SWZ,TVPI,TVVI,UCF,UHTML,URL,VBD,VBHTML,VDW,VLP,VRML,VRT,VSDISCO,WBS,WBXML,WDGT,WEB,WEBARCHIVE,WEBARCHIVEXML,WEBBOOKMARK,WEBHISTORY,WEBLOC,WEBSITE,WGP,WGT,WHTT,WIDGET,WML,WN,WOA,WPP,WPX,WRF,WSDL,XBEL,XBL,XFDL,XHT,XHTM,XHTML,XPD,XSS,XUL,XWS,ZFO,ZHTML,ZHTML,ZUL,ZVZ
)


spreadsheet=
(
123,AST,AWS,BKS,CELL,DEF,DEX,DFG,DIS,EDX,EDXZ,ESS,FCS,FM,FODS,FP,GNM,GNUMERIC,GSHEET,HCDT,IMP,MAR,NB,NCSS,NMBTEMPLATE,NUMBERS,NUMBERS-TEF,ODS,OTS,PMD,PMV,QPW,RDF,SDC,STC,SXC,TMV,TMVT,UOS,WKI,WKS,WKS,WKU,WQ1,WQ2,XAR,XL,XLR,XLS,XLSB,XLSHTML,XLSM,XLSMHTML,XLSX,XLTHTML,XLTM,XLTX
)


system=
(
0,000,208,2FS,386,3FS,73U,8CU,8XU,ADM,ADML,ADMX,ADV,AML,ANI,ANN,AOS,ASEC,ATAHD,AUTOMATICDESTINATIONS-MS,BASH_HISTORY,BASH_PROFILE,BASHRC,BCD,BIN,BIO,BK1,BK2,BLF,BMK,BOM,BUD,C32,CAB,CANNEDSEARCH,CAP,CAT,CDMP,CGZ,CHG,CHK,CHS,CHT,CI,CLB,CNT,CONFIGPROFILE,CPI,CPL,CPQ,CPR,CRASH,CUR,CUSTOMDESTINATIONS-MS,DAT,DESKLINK,DESKTHEMEPACK,DEV,DEVICEMETADATA-MS,DFU,DIAGCAB,DIAGCFG,DIAGPKG,DIMAX,DIT,DLL,DLX,DMP,DRPM,DRV,DSS,DTHUMB,DVD,DYC,EBD,EDJ,EFI,EFIRES,ELF,EMERALD,ESCOPY,ETL,EVT,EVTX,FFA,FFL,FFO,FFX,FID,FL1,FLG,FOTA,FPBF,FTF,FTG,FTS,FX,GMMP,GRL,GROUP,GRP,H1S,HCD,HDMP,HELP,HHC,HHK,HIV,HLP,HPJ,HSH,HTT,ICL,ICNS,ICO,ICONPACKAGE,IDI,IDX,IFW,IM4P,IME,IMG3,INF_LOC,INS,INTERNETCONNECT,ION,IOPLIST,IPOD,IPTHEME,ITEMDATA-MS,ITS,IUS,JOB,JPN,KBD,KEXT,KEY,KO,KOR,KS,LFS,LIBRARY-MS,LNK,LOCKFILE,LOG1,LOG2,LPD,LPD,LST,MANIFEST,MAPIMAIL,MBN,MBR,MDMP,ME,MEM,METADATA_NEVER_INDEX,MI4,MLC,MOBILECONFIG,MOD,MSC,MSP,MSSTYLE,MSSTYLES,MTZ,MUI,MUI_CCCD5AE0,MUM,MYDOCS,NB0,NBH,NETWORKCONNECT,NFO,NLS,NT,NTFS,ODEX,PANIC,PAT,PCK,PDR,PFX,PID,PIT,PK2,PNF,POL,PPD,PPM,PREFPANE,PRF,PRINTEREXPORT,PROFILE,PROP,PROVISIONPROFILE,PRT,PS1,PS2,PWL,QKY,QVM,RC1,RC2,RCO,REG,REGTRANS-MS,RFW,RMT,RS,RUF,RVP,SAVEDSEARCH,SAVER,SB,SBF,SBN,SCAP,SCF,SCHEMAS,SCR,SDB,SDT,SEARCHCONNECTOR-MS,SERVICE,SFCACHE,SHD,SHSH,SO0,SPL,SPX,SQM,STR,SWP,SYS,SYS,TDZ,THA,THEME,TRX_DLL,UCE,VGA,VGD,VX_,VXD,WDF,WDGT,WEBPNP,WER,WGZ,WPH,WPX,XFB,XRM-MS,ZONEIDENTIFIER
)


game=
(
0,001,3DS,3DSX,68K,AAO,ACF,ACWW,ACX,ADT,AGE3REC,AGE3SAV,AGE3SCN,AGE3XREC,AGE3XSAV,AGE3YREC,AGE3YSAV,AIN,AM1,AR,ARCH00,ARP,B,BA2,BAR,BDAE,BEJEWELED2DELUXESAVEDGAME,BFG,BFS,BGL,BIF,BIG,BIK,BIN,BIN,BLACKHAWKSTRIKER2,BLASTERBALL3SAVEDGAME,BLORB,BLP,BLS,BLZ,BMD,BME,BMS,BMZ,BNK,BNS,BO2,BO3,BOOKWORMDELUXESAVEDGAME,BPS,BRRES,BS1,BSA,BSB,BSP,BUS,BZW,C4K,CARC,CBH,CBV,CDP,CDP2,CGF,CGZ,CHD,CHK,CLIP,COMPILED,CON,COURSE,CPN,CRP,CRS,CT,CTX,CTY,DAT,DAT_NEW,DAZIP,DDB,DDT,DEK,DEK,DEK,DEM,DIF,DL,DM2,DM_82,DM_83,DM_84,DMB,DMO,DMO,DNF,DNS,DOL,DSG,DUC,DUN,DV2,E2GM,EGM,ELF,ELM,ENG,EPK,ERB,ERF,ERP,ESCAPE,ESG,ESM,ESM,ESP,ESP,ESS,FAR,FCM,FCS,FF,FGD,FL,FML,FOMOD,FORGE,FOS,FPG,FPK,FPOP,FPS,FRZ,FS2,FSM,FSSAVE,FST,FUK,G3X,GALAXY,GAM,GAME,GB,GBA,GBASKIN,GBC,GBCSKIN,GBX,GCF,GDG,GDI,GEN,GFX,GMA,GMRES,GPF,GR2,GRF,GRF,GRP,GSC,H3M,H4R,H5U,HIT,HONMOD,HOT,HPS,HUM,IBT,IDX0,IDX255,IFP,IMG,INFO,INFORM,IPL,IPS,ISR,ITR,IWD,J2I,J2L,JAP,JG4,JMF,JST,KODU,KWREPLAY,LDB,LDW,LGL,LGP,LIP,LIP,LITEMOD,LL,LMP,LMU,LOD,LOVE,LRF,LSD,LSW,LTX,LUXB,LVL,M2,MAE,MAHJONGTITANSSAVE-MS,MAP,MAP,MAPLET,MAS,MASSEFFECTPROFILE,MASSEFFECTSAVE,MCA,MCR,MCSERVER,MD2,MD3,MDL,MENU,MGL,MGX,MGX,MII,MINESWEEPERSAVE-MS,MIS,MIS,MIX,MP2M,MP2S,MPM,MPQ,MRS,MUL,MWL,N-GAGE,N3PMESH,N64,NAR,NARC,NCF,NDS,NES,NGAGE,NGP,NL2SCRIPT,NLTRACK,NPA,NS1,NSBCA,NSBMD,NSBTX,NTRK,OMOD,OSK,OSR,OSZ,OVH,P3T,PACKAGE,PAK,PAPA,PBN,PBP,PCC,PCK,PCSAV,PEGN,PGN,PHN,PHZ,PJ,PK3,PK4,PKG,PKX,PLAYER,PLAYMISSION,PLN,PLR,PLR,POD,PQHERO,PRK,PSS,PSSG,PSV,PUZ,PWF,PXP,QC,QVM,QWD,RADQ,RAW,RBXL,RBXM,RBXMX,REP,REP,REZ,RFGS_PC,RFM,RGD,RGSS3A,RGSSAD,ROFL,ROM,ROT,RPF,RPGPROJECT,RPL,RPY,RTTEX,RVDATA,RVDATA2,RVPROJ,RVPROJ2,RWS,RXDATA,S2Z,SAD,SAMI,SAV,SAV,SAV,SC2ARCHIVE,SC2ASSETS,SC2BANK,SC2DATA,SC2MA,SC2MAP,SC2MOD,SC2REPLAY,SC2SAVE,SC4,SC4DESC,SC4LOT,SCHEMATIC,SCM,SCN,SCN,SCS,SCS,SCWORLD,SCX,SCX,SD7,SDT,SDZ,SFAR,SFC,SFO,SG0,SGA,SGB,SGB,SGF,SGM,SGPBPRJ,SID,SII,SIMS2PACK,SIMS3,SIMS3PACK,SLI,SM,SMC,SMD,SMRAILROADSSAVEDGAME,SMZIP,SOEPSX,SPB,SPC,SPLANE,SPRITE,SQF,SQM,SRM,SSC,STA,STENCYL,SUD,SV5,SVS,SWC,TBM,TED,TIGER,TIM,TOC,TOR,TTARCH,TWT,U,UASSET,UC,UDK,UKX,UMD,UMOD,UMX,UNF,UNITY,UNITY3D,UNITYPROJ,UNR,UOP,UPK,UPS,USA,USX,UT2,UT2MOD,UT3,UT4MOD,UTC,UTX,UVX,UXX,V64,VB,VCM,VDF,VFS0,VMF,VMV,VMV,VOB,VOL,VPK,VTF,W3G,W3M,W3N,W3X,W3Z,WAD,WAD,WAGAME,WAL,WAM,WBT,WDB,WHIRLD,WL6,WLD,WMO,WORLD,WORLD,WORLD,WOTREPLAY,WPM,WTD,WTF,WZ,WZ,XBE,XDS,XEN,XEX,XMB,XMB,XNB,XOM,XP3,XPD,XPK,XS,YCM,YDC,YDK,YDR,YFS,Z2F,Z3,Z4,Z5,Z64,ZBLORB,ZDS,ZIP,ZMAP,ZS0,ZS1,ZS2,ZS3,ZS4,ZS5,ZS6,ZS7,ZS8,ZS9,ZST,ZTD,ZTMP
)


settings=
(
A2M,A2THEME,A7P,ABS,ACB,ACB,ACO,ACROBATSECURITYSETTINGS,ACT,ACV,ACW,ADPP,AHL,AHS,AHU,AIA,AIP,AIT,AIU,ALL,ALV,ALX,AMS,AOM,APPLICATION,APPREF-MS,ARG,ARP,ARS,ASE,ASEF,ASK,ASL,ASP,AST,ASW,ASWCS,ASWS,ATC,ATH,ATN,ATZ,AUX,AVE,AVS,AVS,AWCAV,AXT,BAU,BCMX,BCP,BCP,BGI,BIN,BITPIM,BKS,BLOB,BLT,BLW,BOOT,BRG,BS7,BTSEARCH,BXX,C2R,CAMP,CDT,CEX,CFG,CFG,CFG,CFG,CFG,CGR,CHL,CHX,CLG,CLR,CLR,CMATE,CMP,CNF,CNF,COMP,CONF,CONF,COPRESET,COS,COSTYLE,CPDX,CPF,CPG,CPR,CPS,CPTM,CPX,CSAPLAN,CSF,CSKIN,CSPLAN,CST,CTB,CTBODYFITTING,CUI,CUIX,CVA,CWF,CWY,CYBERDUCKLICENSE,CYBERDUCKPROFILE,DAR,DBB,DBG,DCL,DCP,DCST,DDF,DEFT,DICPROOF,DINFO,DIRECTORY,DOK,DOLPHINVIEW,DOWNLOADHOST,DR5,DRM,DS_STORE,DSD,DSF,DSW,DSX,DTSCONFIG,DUCK,DUN,DVTCOLORTHEME,DXLS,DXP,EFTX,EHI,ELM,EMM,ENS,ENV,ENZ,EQF,EQL,EQP,EUM,EWPRJ,EXAMPLE,EXE4J,EXP,EXPORTEDUI,FAT,FAVORITEMETADATA,FBT,FC,FCC,FD,FETCHMIRROR,FFX,FLST,FLT,FLW,FMOD,FMP,FMT,FNC,FRAMES,FT,FTH,FTH,FTPQUOTA,FVP,FWT,FXP,GCSX,GID,GIN,GMW,GPS,GPS,GQSX,GRD,GROWLTICKET,GTKRC,GTP,GVIMRC,GWS,GXT,HDT,HID,HME,HT,IAF,ICA,ICC,ICD,ICM,ICST,ICURSORFX,IDPP,IHW,IIP,IIT,IKF,IKMP,INF,INI,INI,INI,INMS,INS,IPCC,IPYNB,IRS,ISP,ISS,ISS,ITT,IX,JDF,JKM,JOY,JSF,JWS,KBD,KDS,KEY,KSF,KYS,L4D,LCC,LFO,LH3D,LNST,LOOK,LOP,LRSMCOL,LRTEMPLATE,LVA,LVF,LXSOPT,LYT,M2S,MAILHOST,MASK,MATERIAL,MCL,MCW,MDS,MGK,MLK,MMDC,MMP,MNS,MNU,MOF,MPDCONF,MSF,MSKN,MSM,MSN,MST,MST,MSW,MTF,MXS,MXSKIN,MYCOLORS,NCFG,ND,NDC,NGRR,NJI,NKP,NPFX,NPS,NSX,NVC,NVP,NWV,OBI,OBT,OCE,ODC,OEM,OFFICEUI,OMS,ONETOC2,OPS,OPT,OSDX,OSS,OTZ,OVPN,P2M,PAL,PAPERS,PBS,PC3,PCTL,PDADJ,PDP,PEN,PERFMONCFG,PGP,PH,PHB,PIE,PIO,PIP,PJS,PKG,PLIST,PMC,PMJ,PML,PMP,POLICY,PR,PREF,PRF,PRF,PRF,PRFPSET,PRM,PRO5TEMPLATE,PROFILE,PROFIMAIL,PROPDESC,PROPERTIES,PROPS,PRS,PRST,PRX,PS1XML,PSC1,PSF,PSP,PSY,PTF,PVS,PXB,PXG,QAT,QF,QPX,QRC,QSS,QTP,QVPP,QVT,RAD,RASKINPLACE,RCF,RCT,RDF,RDO,RDP,RDW,REG,RES,RESMONCFG,RFQ,RLL,RMSKIN,RNX,RPK,RPROJ,RPS,RTS,RULESET,RWSTYLE,S2ML,SBV,SCACFG,SCH,SCPCFG,SED,SEQU,SET,SETTINGCONTENT-MS,SETTINGS,SFO,SGT,SIF,SKI,SKIN,SKIN,SKN,SKN,SKZ,SL,SLT,SMT,SNX,SOL,SPF,SPFX,SPJ,SQD,SRS,SSL,SSL2,SSS,SSS,STARTUPINFO,STB,STD,STE,STORYISTTHEME,STT,STYLE,SW2,SYNW-PROJ,SZ,T3D,TDF,TERMINAL,THE,THEME,THEME,THEMEPACK,THMX,TLO,TMTHEME,TPARK,TPF,TRX,TSI,TSK,TSM,TSZ,TTS,TVC,TVTEMPLATE,TWC,TYPEIT4ME,UCT,UDCX,UIS,UPF,USERPROFILE,USF,UTZ,VBOX,VBX6SETTINGS,VCOMPS,VCPREF,VEGASWINDOWLAYOUT,VIM,VIMRC,VLT,VMC,VMCX,VMPL,VMTM,VMX,VMX,VMXF,VNC,VPH,VPS,VQC,VSPROPS,VSSETTINGS,VSTPRESET,VUE,WC,WCX,WCZ,WFC,WIF,WME,WMS,WMZ,WORK,WORKSPACE,WPS,WZCONFIG,XCU,XDR,XLB,XLB,XMS,XPADDERCONTROLLER,XPL,XST,XTODVD,XTP,XTREME,XUI,XUR,XVM,ZAP,ZON,ZON,ZPF,ZPI
)


pageLayout=
(
4UI,ADB,AFP,ANH,ANTMPL,AO,AP,ARTICLE,AV,AVERY,BCF,BCP,BIZ,BLK,BMML,BOOK,BOOK,BOOKTEMPLATE,BPF,BRO,BRO,BTW,CADOC,CAJ,CAL,CBF,CD2,CDF,CDML,CDOC,CEDPRJ,CH3,CHAI,CHAIT,CL2ARC,CL2DOC,CL2LYT,CL2TPL,CLD,CLKB,CLKBD,CLKC,CLKD,CLT,CNDX,COMIC,COMICDOC,COMICLIFE,COMPOSITIONTEMPLATE,CONSIS,COV,CPE,CPH,CPY,CRTR,CSD,CST,CVW,CW,CWT,DCX,DE,DMTEMPLATE,DOT,DOTM,DOTX,DPD,DRMX,DRMZ,DTL,DTP,DTX,DWDOC,EDDX,EDRWX,EL4,ENC,ENV,FADEIN,FAX,FCDT,FD2,FDD,FDT,FEY,FGC,FLB,FLOWCHART,FM,FOLIO,FORM,FP3,FR3,FRDOC,FRF,FSD,FXM,GEM,GSLIDES,GSP,GWB,HCR,HFD,HFT,HMK,HPD,HPT,HWDT,ICAP,ICML,ICMT,IDAP,IDML,IDMS,IDPK,IFD,ILDOC,IMM,IMTX,IMX,INCD,INCT,INCX,IND,INDB,INDD,INDL,INDP,INDS,INDT,INFOPATHXML,INP,INX,ISALE,ISALETEMPLATE,ISALLIC,ISD,JTP,JTX,JTX,LAB,LBL,LBL,LLD,LMA,LPDF,LSC,LST,LTF,MAILSTATIONERY,MARS,MAX,MBBK,MCSP,MCSX,MDI,MFO,MFP,MFT,MGA,MIF,MML,MRG,MTC,MVD,MVDX,MVTX,NPP,NUD,OLA,OMP,OO3TEMPLATE,OPD,OXPS,P65,PA,PCL,PCT,PDE,PDER,PDF,PDFXML,PDG,PDH,PDM,PDP,PDR,PDW,PDWR,PDZ,PEX,PFF,PFL,PGS,PM4,PM5,PM6,PMD,PMX,PNH,PPP,PPX,PRN,PSG,PSPROJ,PSR,PTX,PUB,PUBLICATION,PWT,PZF,PZFX,Q3C,QDF,QPT,QXB,QXD,QXP,QXT,RAP,RB4,RELS,RFD,RLF,RMR,RPC,RPTR,RSM,RWT,RWT,SBK,SBV,SCUT4,SDT,SIMP,SJD,SMMX,SNP,SP,SPL,SPL7,SPUB,STUDIO,STUDIO3,SUBLIME-SNIPPET,T2D,TOTALSLAYOUT,TP3,VFC,VP,WEBTEMPLATE,WEBTHEME,WLP,WMGA,WPT,WWF,XDW,XIF,XMT,XPS,XSN,XTP,XZFX,ZDL,ZDP,ZDS,ZFX,ZNO
)


encoded=
(
ACID,AEP,AES,AFP,ASC,AXX,AZF,AZS,B2A,BC5B,BFA,BHX,BIN,BPK,BPW,BSK,BTOA,BVD,CCF,CDOC,CEF,CERBER,CERBER2,CGP,CHML,CLX,CNG,CPIO,CPT,CRYPT,CRYPTED,CRYPTRA,DC4,DCD,DCF,DCO,DDOC,DIM,DIME,DLC,E4A,EFL,EFR,EFU,EMC,ENC,ENX,ENX,ESF,ESLOCK,EXC,FILM,FPENC,FSM,GFE,GXK,HBX,HEX,HID,HID2,HQX,HTPASSWD,IDEA,IWA,JAC,JCEKS,JCRYPT,JKS,JMC,JMCE,JMCK,JMCP,JMCR,JMCX,KDE,KEYSTORE,KLQ,KS,KSD,KXX,LASTLOGIN,LCN,LOCKED,LOCKY,LVIVT,MCRP,MEO,MFS,MIM,MIME,MJD,MME,MNC,MSE,NC,NXL,PACK,PDC,PFILE,PFO,PKEY,PLP,PPDF,PSW6,PWV,PXX,RDI,RSDF,RZK,RZX,SAFE,SCB,SDO,SDOC,SDTID,SEB,SEF,SEF,SFI,SGZ,SHY,SJPG,SME,SNK,SPD,SPDF,STXT,SUF,SWITCH,SXLS,SXML,TARMD5,UEA,UU,UUD,UUE,VDATA,VIIVO,VLT,VP,WALLET,WLS,WLU,WNCRY,WPE,WRYPT,XMDX,XTBL,XXE,YENC,YNC,ZEPTO,ZPS,ZZZZZ
)


gis=
(
3D,3DC,3DD,3DL,477,ADF,APL,APR,AQM,AT5,ATX,AUX,AVL,AXE,AXT,BIL,BPW,BT,COR,CSF,CUB,CVI,DEM,DIV,DIX,DLG,DMF,DMT,DT0,DT1,DT2,DVC,E00,EMBR,ERS,EST,ETA,FBL,FDS,FFS,FIT,FLS,FME,FMI,FMV,FMW,GEOJSON,GFW,GLB,GMAP,GMF,GML,GPF,GPRX,GPS,GPX,GRB,GSB,GSI,GSM,GSR,GSR2,GST,GWS,HDR,HGT,IMD,IMG,IMG,IMI,JGW,JNX,JPGW,JPR,JPW,KML,KMZ,LAN,LPK,MAP,MAP,MDC,MGM,MID,MIF,MMM,MMZ,MNH,MPK,MPS,MSD,MWX,MXD,MXT,NGT,NM2,NM3,NMAP,NMC,NMF,NV2,OCD,OSB,OSC,OSM,OV2,PIN,PIX,PMF,PRM,PTM,PTT,RDC,RDF,REF,RGN,RMP,RRD,RST,SAF,SBN,SBN,SDF,SDM,SDW,SHP,SLD,SMM,SMP,SP3,SSF,STT,STYLE,SVX,SXD,SYM,TAB,TFRD,TFW,TH,TPX,TTKGP,VCT,VDC,VEC,WFD,WLD,WLX,WOR,XOL
)


3dImage=
(
3D,3D2,3D4,3DA,3DC,3DC,3DF,3DL,3DM,3DMF,3DMK,3DON,3DP,3DS,3DV,3DW,3DX,3DXML,3MF,A2C,A3D,A8S,AC,ACT,ALBUM,AMF,AN8,ANIM,ANIM,ANIM,ANIMSET,ANIMSET_INGAME,ANM,AOF,AOI,ASAT,ATF,ATL,ATM,B3D,BIO,BIP,BLD,BLEND,BR3,BR4,BR5,BR6,BR7,BRG,BRO,BSK,BTO,BVH,C3Z,C4D,CAF,CAL,CAL,CAS,CCB,CCP,CFG,CG,CG3,CGA,CGFX,CHR,CHR,CHRPARAMS,CM2,CMF,CMOD,CMZ,CPY,CR2,CRF,CRZ,CSD,CSF,CSM,CSO,D3D,DAE,DAZ,DBC,DBL,DBM,DBS,DDD,DES,DFF,DFS,DIF,DMC,DRF,DS,DSA,DSB,DSD,DSE,DSF,DSI,DSI,DSO,DSV,DUF,DWF,E57,EGG,EXP,F3D,FACEFX,FACEFX_INGAME,FBX,FC2,FCP,FCZ,FG,FIG,FLT,FNC,FP,FP3,FPE,FPF,FPJ,FRY,FSH,FSQ,FUN,FX,FXA,FXL,FXM,FXS,FXT,GEO,GLF,GLM,GMF,GMMOD,GMT,GRN,HD2,HDZ,HIP,HIPNC,HLSL,HR2,HRZ,HXN,IFC,IGES,IGI,IGM,IGS,IK,IRR,IRRMESH,IV,IVE,J3O,JAS,KFM,KMC,KMCOBJ,KTZ,LDM,LLM,LND,LP,LPS,LT2,LTZ,LWO,LWS,LXF,LXO,M3,M3D,M3D,MA,MAKERBOT,MAT,MAX,MAXC,MB,MC5,MC6,MCZ,MD5ANIM,MD5CAMERA,MD5MESH,MDD,MDL,MDX,MEB,MESH,MESH,MGF,MIX,MNM,MOT,MP,MPJ,MQO,MRML,MS3D,MSH,MTL,MTX,MTZ,MU,MUD,MXM,MXS,N2,N3D,NFF,NIF,NM,NSBTA,OBJ,OBP,OBZ,OCT,OFF,OGF,OL,P21,P2Z,P3D,P3L,P3M,P3R,P5D,PAR,PAT,PHY,PIGM,PIGS,PKG,PKG,PL0,PL1,PL2,PLY,PMD,PMD,PMX,PP2,PPZ,PRC,PREFAB,PRIMITIVES,PRIMITIVES_PROCESSED,PRM,PRO,PRO,PRV,PSA,PSK,PZ2,PZ3,PZZ,QC,RAD,RAD,RAY,RCS,RDS,RFT,RIG,S,S3G,SC4MODEL,SDB,SESSION,SGN,SH3D,SH3F,SHP,SI,SKL,SKP,SM,SMD,SRF,STC,STEP,STO,STP,T3D,T3D,TCN,TDDD,TGO,THING,THL,TMD,TME,TMO,TPS,TRI,TRI,TRUCK,TS1,TVM,U3D,UMS,V3D,V3O,VAC,VEG,VISUAL,VISUAL_PROCESSED,VMD,VMO,VOB,VOX,VP,VPD,VRL,VS,VSH,VSO,VTX,VUE,VVD,W3D,WFT,WRL,WRP,WRZ,X,X3D,X3G,XAF,XAF,XMF,XMM,XOF,XPR,XRF,XSF,XSI,XV0,YAODL,YDL,Z3D,ZT
)


diskImage=
(
000,2MG,AA,ADF,ADZ,AFD,AFF,AFM,ASHDISC,ATR,AVHD,B5I,B5T,B6I,B6T,BDF,BIF,BIN,BWA,BWI,BWS,BWT,BWZ,C2D,CCD,CD,CDI,CDM,CDR,CDT,CFS,CIF,CISO,CL5,CSO,CUE,CUE,D00,D01,D64,D88,DAA,DAO,DAX,DBR,DCF,DISC,DISK,DMG,DMGPART,DMS,DSK,DVD,DVDR,DXP,E01,ECM,EDA,EDE,EDK,EDQ,EDS,EDV,EUI,EX01,FCD,FDD,FDI,FLG,FLP,G41,GBI,GCD,GDRIVE,GI,GKH,HC,HDD,HDI,HDS,HFS,HFV,I00,I01,I02,IBB,IBP,IBQ,IMA,IMAGE,IMG,IMG,IMG,IMZ,IPF,ISO,ISO,ISZ,IXA,K3B,L01,LCD,LNX,LX01,MBI,MD0,MD1,MD1,MD2,MDF,MDS,MDX,MINISO,MIR,MLC,MRIMG,NCD,NDIF,NFI,NN,NRG,NRI,OMG,P01,P01,P2G,P2I,PARTIMG,PDI,PGD,PGX,PMF,PQI,PVM,PXI,QCOW,QCOW2,RATDVD,RCL,RDF,SCO,SDI,SDSK,SIMG,SMI,SOPT,SPARSEBUNDLE,SPARSEIMAGE,SQFS,ST,SUB,SWM,T64,TAO,TAP,TC,TD0,TIB,TOAST,TOC,TZX,UDF,UFS,UIBAK,UIF,VAPORCD,VC4,VC6,VC8,VCD,VCD,VCO,VCX,VDI,VDI,VFD,VHD,VHDX,VMDK,VMWAREVM,VOLARCHIVE,WBI,WII,WIL,WIM,WINCLONE,WLZ,WMT,X64,XA,XDI,XMD,XMF,XVA,XVD
)


cameraRaw=
(
3FR,ARI,ARW,BAY,CR2,CRW,CS1,CXI,DCR,DNG,EIP,ERF,FFF,IIQ,J6I,K25,KDC,MEF,MFW,MOS,MRW,NEF,NRW,ORF,PEF,RAF,RAW,RW2,RWL,RWZ,SR2,SRF,SRW,X3F
)


cad=
(
123,123C,123D,123DX,2D,3DC,3DL,3W,A2L,ACT,ADI,ADT,AFD,AFS,ANY,ARD,ART,ASC,ASM,ASY,ATT,BBCD,BCD,BDC,BDL,BIMX,BIT,BLK,BMF,BPM,BPMC,BPZ,BRD,BRD,BXL,CAD,CAM,CATDRAWING,CATPART,CATPRODUCT,CDDX,CDL,CDW,CEL,CF2,CFF,CGR,CIB,CIRCUIT,CKD,CMP,CMP,CNC,CNC,CND,CPA,CRV,CYP,CZD,DB1,DBQ,DC,DC1,DC2,DC2,DC3,DCD,DES,DFT,DFX,DGB,DGK,DGN,DLV,DLX,DRA,DRA,DRG,DRU,DRWDOT,DSG,DSN,DST,DST,DVG,DWFX,DWG,DWS,DWT,DXE,DXF,DXX,EASM,EDF,EDN,EDRW,ELD,EPF,EPRT,EQN,EWB,EWD,EXB,EZC,EZP,FAN,FCD,FCSTD,FCW,FLX,FMZ,FNC,FPD,FPP,FZ,FZB,FZM,FZP,FZZ,G,G3D,GBX,GCD,GDS,GINSPECT_PRJ,GSM,GXC,GXD,GXH,GXM,HCP,HSC,HSF,HUS,IAM,IBA,IC3D,ICD,ICS,IDE,IDV,IDW,IF,IFCXML,IFCZIP,IGS,IPF,IPJ,IPN,IPT,ISE,ISO,ISOZ,JAM,JBC,JOB,JT,JVSG,KIT,L3B,LCF,LDR,LDT,LI3D,LIN,LIZD,LOGICLY,LTL,LYC,LYR,MC9,MCD,MCX,MDL,MHS,MIN,MIN,MOD,MODEL,MODFEM,MP10,MP11,MP12,MP13,MP14,MP7,MP8,MP9,MS11,MS12,MS13,MS14,MS7,MS9,MSM,MVS,NC,NC1,NEU,NGC,NGD,NPL,NWC,NWD,NWF,OLB,OPJ,OPT,PAT,PC6,PC7,PCS,PHJ,PHO,PIPD,PIPE,PLA,PLN,PM3,PRG,PRO,PRT,PRT,PRT,PRT,PSF,PSM,PSS,PSU,PSV,PWD,PWT,QPM,RCD,RDF,RED,RIG,RML,RRA,RS,RSG,RSM,RTD,SAB,SAT,SBP,SCAD,SCDOC,SCH,SCH,SDG,SEW,SHX,SKF,SLDASM,SLDDRW,SLDPRT,SPT,STL,SVD,SYM,T3001,TAK,TBP,TC2,TC3,TCD,TCD,TCM,TCP,TCT,TCW,TCX,TOP,TOPPRJ,TOPVIW,TSC,TSF,ULD,UNT,UPF,VET,VND,VTF,VWX,WDP,X_B,X_T,XISE,XV3
)


backup=
(
$$$,$DB,001,001,002,003,113,73B,__A,__B,AB,ABA,ABBU,ABF,ABK,ABU,ACP,ACR,ADI,ADI,AEA,AFI,ARC,ARC,AS4,ASD,ASHBAK,ASV,ASVX,ATE,ATI,BAC,BACKUP,BACKUPDB,BAK,BAK,BAK,BAK,BAK2,BAK3,BAKX,BAK~,BBB,BBZ,BCK,BCKP,BCM,BDB,BFF,BIF,BIFX,BK1,BK1,BKC,BKF,BKP,BKP,BKUP,BKZ,BLEND1,BLEND2,BM3,BMK,BOOKEXPORT,BPA,BPB,BPM,BPN,BPS,BUP,BUP,CAA,CBK,CBS,CBU,CENON~,CK9,CMF,CRDS,CSD,CSM,DA0,DASH,DBA,DBK,DBK,DIM,DIY,DNA,DOV,DPB,DSB,DSS,FBC,FBF,FBK,FBK,FBU,FBW,FH,FHF,FLKA,FLKB,FPSX,FTMB,FUL,FWBACKUP,FZA,FZB,GB1,GB2,GBP,GHO,GHS,IBK,ICBU,ICF,INPROGRESS,IPD,IV2I,J01,JBK,JDC,JPA,JPS,KB2,LBF,LCB,LLX,MBF,MBK,MBW,MDBACKUP,MDDATA,MDINFO,MEM,MIG,MPB,MSIM,MV_,NB7,NBA,NBAK,NBD,NBD,NBF,NBF,NBI,NBK,NBK,NBS,NBU,NCO,NDA,NFB,NFC,NPF,NPS,NRBAK,NRS,NWBAK,OBK,OEB,OLD,ONEPKG,ORI,ORIG,OYX,PAQ,PBA,PBB,PBD,PBF,PBF,PBJ,PBX5SCRIPT,PBXSCRIPT,PDB,PFI,PQB,PQB-BACKUP,PRV,PSA,PTB,PVC,PVHD,QBATLG,QBB,QBK,QBM,QBMB,QBMD,QBX,QIC,QSF,QUALSOFTCODE,QUICKEN2015BACKUP,QUICKEN2016BACKUP,QUICKEN2017BACKUP,QUICKENBACKUP,QV~,RBC,RBF,RBF,RBF,RBK,RBS,RDB,RGMB,RMBAK,RRR,SAV,SBB,SBS,SBU,SDC,SIM,SIS,SKB,SME,SN1,SN2,SNA,SNS,SPF,SPG,SPI,SPS,SQB,SRR,STG,SV$,SV2I,TBK,TDB,TIBKP,TIG,TIS,TLG,TMP,TMP,TMR,TRN,TTBK,UCI,V2I,VBK,VBM,VBOX-PREV,VPCBACKUP,VRB,W01,WALLETX,WBB,WBCAT,WBK,WIN,WIN,WJF,WPB,WSPAK,WX,XBK,XLK,YRCBCK,~CW
)


compressed=
(
0,000,7Z,7Z001,7Z002,A00,A01,A02,ACE,AGG,AIN,ALZ,APZ,AR,ARC,ARCHIVER,ARDUBOY,ARH,ARI,ARJ,ARK,ASR,B1,B64,BA,BDOC,BH,BNDL,BOO,BUNDLE,BZ,BZ2,BZA,BZIP,BZIP2,C00,C01,C02,C10,CAR,CB7,CBA,CBR,CBT,CBZ,CDZ,COMPPKGHAUPTWERKRAR,COMPPKG_HAUPTWERK_RAR,CP9,CPGZ,CPT,CXARCHIVE,CZIP,DAR,DD,DEB,DGC,DIST,DL_,DZ,ECS,EDZ,EFW,EGG,EPI,F,FDP,FP8,FZBZ,FZPZ,GCA,GMZ,GZ,GZ2,GZA,GZI,GZIP,HA,HBC,HBC2,HBE,HKI,HKI1,HKI2,HKI3,HPK,HYP,IADPROJ,ICE,IPG,IPK,ISH,ISX,ITA,IZE,J,JARPACK,JGZ,JIC,JSONLZ4,KGB,KZ,LAYOUT,LBR,LEMON,LHA,LHZD,LIBZIP,LNX,LQR,LZ,LZH,LZM,LZMA,LZO,LZX,MD,MINT,MOU,MPKG,MZP,MZP,NEX,NZ,OAR,OZ,P01,P19,PACKGZ,PACKAGE,PAE,PAK,PAQ6,PAQ7,PAQ8,PAQ8F,PAQ8L,PAQ8P,PAR,PAR2,PAX,PBI,PCV,PEA,PET,PF,PIM,PIT,PIZ,PKG,PKGTARXZ,PSZ,PUP,PUP,PUZ,PWA,QDA,R0,R00,R01,R02,R03,R04,R1,R2,R21,R30,RAR,REV,RK,RNC,RP9,RPM,RSS,RTE,RZ,S00,S01,S02,S7Z,SAR,SBX,SBX,SDC,SDN,SEA,SEN,SFG,SFS,SFX,SH,SHAR,SHK,SHR,SIFZ,SIT,SITX,SMPF,SNAPPY,SNB,SPT,SQX,SREP,STPROJ,SY_,TARBZ2,TARGZ,TARGZ2,TARLZ,TARLZMA,TARXZ,TARZ,TAZ,TBZ,TBZ2,TG,TGZ,TLZ,TLZMA,TRS,TX_,TXZ,TZ,UC2,UFSUZIP,UHA,UZIP,VEM,VOCA,VSI,WA,WAFF,WAR,WLB,WOT,XAPK,XAR,XEF,XEZ,XIP,XMCDZ,XX,XZ,XZM,Y,YZ,YZ1,Z,Z01,Z02,Z03,Z04,ZAP,ZFSENDTOTARGET,ZI,ZIP,ZIPX,ZIX,ZL,ZOO,ZPI,ZSPLIT,ZW,ZZ
)


database=
(
$ER,4DD,4DL,^^^,ABCDDB,ABS,ABX,ACCDB,ACCDC,ACCDE,ACCDR,ACCDT,ACCDW,ACCFT,ADB,ADB,ADE,ADF,ADN,ADP,ALF,ASK,BTR,CAT,CDB,CDB,CDB,CKP,CMA,CPD,CRYPT12,CRYPT5,CRYPT6,CRYPT7,CRYPT8,CRYPT9,DACONNECTIONS,DACPAC,DAD,DADIAGRAMS,DASCHEMA,DB,DB,DB-SHM,DB-WAL,DBCRYPT12,DBCRYPT8,DB2,DB3,DBC,DBF,DBS,DBT,DBV,DBX,DCB,DCT,DCX,DDL,DLIS,DP1,DQY,DSK,DSN,DTSX,DXL,ECO,ECX,EDB,EPIM,FCD,FDB,FIC,FLEXOLIBRARY,FM5,FMP,FMP12,FMPSL,FOL,FP3,FP4,FP5,FP7,FPT,FRM,GDB,GDB,GRDB,GWI,HDB,HIS,IB,IDB,IHX,ITDB,ITW,JET,JTX,KDB,KEXI,KEXIC,KEXIS,LGC,LWX,MAF,MAQ,MAR,MARSHAL,MAS,MAV,MAW,MDB,MDBHTML,MDF,MDN,MDT,MFD,MPD,MRG,MUD,MWB,MYD,NDF,NNT,NRMLIB,NS2,NS3,NS4,NSF,NV,NV2,NWDB,NYF,ODB,ODB,OQY,ORA,ORX,OWC,P96,P97,PAN,PDB,PDB,PDM,PNZ,QRY,QVD,RBF,RCTD,ROD,ROD,RODX,RPD,RSD,SAS7BDAT,SBF,SCX,SDB,SDB,SDB,SDB,SDF,SIS,SPQ,SQL,SQLITE,SQLITE3,SQLITEDB,TE,TEACHER,TMD,TPS,TRC,TRC,TRM,UDB,UDL,USR,V12,VIS,VPD,WDB,WMDB,WRK,XDB,XLD,XMLFF
)


data=
(
3DR,4DV,AAM,AB3,ABCD,ABP,ABY,ACC,ADCP,ADT,ADX,AFT,AIFB,ALD,ALI,ANME,AW,BCI,BCM,BDIC,BGL,BGT,BIN,BJO,BK,BLB,BLD,BLG,BOX,BRW,BTM,BVP,CAP,CAPT,CDF,CDX,CDX,CEL,CELTX,CKT,CLM,CLP,CMA,CNA,CONTACT,CRTX,CSA,CSV,CTF,CUB,CVN,DAL,DAM,DAS,DAT,DBD,DCF,DCM,DCMD,DDC,DDCX,DFPROJ,DIF,DII,DM2,DMSP,DOCKZIP,DRL,DSB,DSY,DSZ,DVDPROJ,DVO,DWI,EBUILD,EDI,EFX,EGP,EMB,EMLXPART,ENEX,ENL,EPW,ER1,ESX,EV,EXIF,EXP,EXX,FCPEVENT,FCS,FDB,FDB,FFWP,FHC,FIL,FLO,FLP,FLT,FMAT,FMC,FO,FOB,FOP,FOX,FRO,FSC,FTW,FXP,GAN,GBR,GC,GCW,GDT,GED,GEDCOM,GGB,GMS,GNO,GPI,GRADE,GRF,GRK,GRR,GRV,GS,GTP,GWK,H12,H13,H16,HCI,HCU,HDA,HDF,HL,HML,HST,HUH,HYV,I5Z,IBA,ID2,IDX,IDX,IGC,II,IIF,IMA,IMT,IN,INK,INP,INX,IP,ISF,ITL,ITM,ITMSP,ITX,IVT,IXB,JDB,JEF,JMP,JNT,JOBOPTIONS,JOINED,JPH,JRPRINT,JRXML,KAP,KDC,KEY,KEYCHAIN,KID,KMS,KPF,KPP,KPR,KPX,KPZ,KTH,L6T,LBL,LCM,LDIF,LGH,LGI,LIB,LIVEREG,LIVEUPDATE,LIX,LIX,LMS,LMX,LP7,LSF,LSL,LVM,M,MAI,MAT,MBG,MBG,MBX,MCD,MCDX,MDC,MDF,MDJ,MDL,MDL,MDM,MDSX,MDX,MENC,MET,MEX,MFO,MJK,MLS,MMAP,MMC,MMF,MMP,MMP,MNC,MNO,MOHO,MOSAIC,MOX,MPH,MPKT,MPP,MPT,MPX,MTH,MTW,MW,MWF,MWS,MYI,NBP,NCORX,NDK,NDX,NET,NITF,NOT,NOTEBOOK,NP,NPL,NPT,NRL,OBJ,ODP,ODX,OEACCOUNT,OFC,OFT,OFX,OMP,OND,ONE,OO3,OPX,OPX,OTLN,OTP,OUT,OVA,OVF,PAB,PAF,PC,PCAPNG,PCB,PCR,PD4,PD5,PDAS,PDB,PDS,PDX,PDX,PFC,PHB,PHM,PHOTOSLIBRARY,PJ2,PJM,PKA,PKB,PKH,PKS,PKT,PLW,PMO,POD,POI,POTM,POTX,PPF,PPF,PPS,PPSM,PPSX,PPT,PPTM,PPTX,PRJ,PRJ,PRO5PLX,PRS,PST,PTB,PTF,PTN,PTZ,PXF,PXL,Q08,Q09,QB2009,QB2011,QB2012,QB2013,QB2014,QBW,QDF,QFX,QIF,QMBL,QMTF,QPB,QRP,QUICKEN2015,QUICKEN2017,QUICKENDATA,QVW,RAL,RBT,RCG,RDB,RET,RFA,RFO,RGO,RNQ,ROADTRIP,ROD,RODZ,ROU,ROX,RP,RPP,RPT,RSC,RTE,RTE,RVT,SAR,SAV,SC45,SCA,SCD,SDF,SDF,SDP,SDS,SEN,SEO,SGML,SHW,SLE,SLP,SLX,SNAG,SNAPFIRESHOW,SPS,SPUB,SPV,SQ,SQD,SQR,STA,STM,STP,STYK,STYKZ,SVF,SWK,T05,T06,T07,T08,T09,T10,T11,T12,T13,T16,TA6,TAR,TAX2009,TAX2010,TAX2011,TAX2013,TAX2015,TAX2016,TB,TBK,TBL,TCC,TCX,TDB,TDM,TDT,TE3,TEF,TET,TFA,TKFL,TMX,TOPC,TPB,TPF,TRA,TRD,TRK,TRS,TRS,TST,TSV,TT10,TT12,TT13,TT16,TTK,TWB,TWH,TXD,TXF,U10,UCCAPILOG,ULF,ULZ,UPOI,USR,UWL,VCD,VCE,VCF,VCS,VDB,VDF,VDX,VI,VMT,VOK,VRD,VSX,VTX,VXML,WAB,WB2,WB3,WDF,WEA,WGT,WGT,WINDOWSLIVECONTACT,WJR,WNK,WPC,WTB,XDB,XDNA,XEM,XFD,XFDF,XFO,XFT,XLC,XLF,XLT,XMCD,XML,XMLPER,XPG,XPJ,XPT,XRDML,XRP,XSL,XSLT,ZAP,ZDC,ZMC
)


developer=
(
PL,CPP,VB,C,JAVA,FLA,H,CLASS,PY,DTD,XCODEPROJ,LUA,SH,CS,M,SLN,VCXPROJ,SWIFT,OCX,MD,PLAYGROUND,ERB,PAS,GFAR,SRC,XSD,NIB,YML,RB,PCH,DPR,RES,DPROJ,VCPROJ,VDPROJ,GS,AS,HPP,GMK,POD,IML,VBPROJ,DEX,R,REXX,CP,PAS,GROUPPROJ,CSPROJ,GEM,TRX,ISE,MSHC,ASC,RESX,FS,FSX,FSPROJ,PRO,SDEF,FTL,V,VTM,PSM1,RKT,EXP,M,PBXUSER,PBXPROJ,MM,AS3PROJ,WIXPROJ,JSPF,XQ,BBPROJECTD,RBW,DCPROJ,PBJ,PROTO,MARKDOWN,CCS,CBL,COB,HH,SQLPROJ,BAS,BCP,CC,INC,TWIG,DCUIL,CAPROJ,VBX,ODL,GEMSPEC,GREENFOOT,VBP,WSC,ASM,F,NW,GITIGNORE,PYX,NUSPEC,WDP,NUPKG,ANE,XCAPPDATA,ENT,RUL,DGML,CP,COD,CONFIG,A2W,LBI,PKGDEF,JPR,JPX,AWK,GMX,M4,F90,FOR,MSS,DSP,MAK,RC,DPKW,SCRIPTTERMINOLOGY,AP_,RSRC,SPEC,A,O,SO,P,EQL,FXC,MDZIP,GMD,PYD,TCL,TK,MPR,PJX,PRG,QPR,PDM,DM1,S,MK,EX,LNT,DEF,BPG,DCU,DFM,RES,DCP,DPK,BPL,DPL,SB2,FORTH,LPROJ,FRAMEWORK,GORM,CXP,BBC,HS,LHS,HAS,LIT,VDM,JIC,VBG,DOB,DOX,FRX,CLS,VBZ,PM,RNC,RBP,LBS,DF1,AU3,GAMEPROJ,SNIPPET,PTL,SC,SUD,SUP,CSI,CAF,OMO,S19,BB,GM6,LDS,OCA,DEC,XAML,AGI,TPU,FXL,MOD,BS2,PL,ACD,WIQ,PLC,YMP,SAS,LGO,RBC,FSPROJ,SSC,DGSL,ADS,TARGETS,FGL,D,UI,KDEVPRJ,INO,KDEVELOP,SLOGO,CTL,GED,FPM,VGC,WIXLIB,BLUEJ,GS3,GROOVY,VHD,TDS,FBP,SUO,IDB,PB,BET,VC,MF,4DB,PYW,T,TU,TUR,SWD,B,APA,HBS,MER,IWS,XT,SWC,MAGIK,PO,POT,AM6,AM7,AM4,AM5,SMA,CSI,XIB,PRG,PLE,MYAPP,CD,VSSSCC,VSPSCC,MO,GMO,LICX,LICENSES,MFA,CCN,R,WDL,MOM,OWL,PL1,PLI,HPF,AIA,XAP,C,MXML,NXC,BDSPROJ,NFM,FBZ7,RODL,ARTPROJ,DBO,PH,PXD,CAPX,SB,WPW,STORYBOARD,ALB,ASI,R,SCRIPTSUITE,PWN,CLIPS,RSS,W,GSZIP,RESJSON,ENTITLEMENTS,CTP,WDW,FXCPROJ,ISM,PIKA,IST,IPR,HAL,RISE,NLS,DBA,CDF,MSHA,MSHI,SS,SVN-BASE,MSP,JSFL,CCP,KPL,GLD,CSP,ERL,MV,CFC,SMALI,CSX,FSSCRIPT,FSI,XCDATAMODELD,DBPROJ,VDP,VCP,LSPROJ,CXX,TLI,TLH,HXX,INL,IDL,ASM,XOML,RDLC,RESOURCES,VSMACROS,VSMPROJ,VSMDI,TESTSETTINGS,ADDIN,TESTRUNCONFIG,TT,DBML,EDMX,NCB,BSC,XAMLX,CCGAME,REFRESH,APPX,APPXUPLOAD,ABC,RPY,VSZ,ML,PDE,EXW,PRI,I,CSN,EDML,DMD,SSI,VTML,VTV,NQC,SLTNG,FXPL,JCP,MSL,BRX,NK,SRCRPM,ASVF,PBXBTREE,DEVICEIDS,CTXT,V,SCC,IPR,FXML,P3D,LUCIDSNIPPET,WXL,WDGT,WXI,WXS,LISP,YPR,UML,WIXOBJ,APS,Y,L,WIXOUT,WIXPDB,WIXMSP,WIXMST,NVV,NBC,AS2PROJ,XQUERY,XQL,LTB,XQM,NED,DIFF,LXSPROJ,ARSC,DSGM,TNS,ILK,TMPROJ,PKGUNDEF,BBPROJECT,TEXTFACTORY,CVSRC,TMLANGUAGE,CBP,WORKSPACE,CLW,IPCH,SBPROJ,LIVECODE,IDT,CU,TLD,WSP,VM,4TH,PCP,XPP,PATCH,AUTOPLAY,SYM,NSI,NSH,GCH,XOJO_PROJECT,GITATTRIBUTES,MCP,HAML,PSC,XOJO_XML_PROJECT,XOJO_BINARY_PROJECT,RAV,XCARCHIVE,XCSNAPSHOTS,MRT,WDGTPROJ,XCWORKSPACE,OCTEST,PBK,PBG,XOJO_MENU,DBA,DBPRO,PPC,YAML,XCCONFIG,IWB,ICONSET,V11SUO,W32,FTN,GM81,RC2,V12SUO,RESW,PRI,AIDL,VSP,VSPS,VSPX,LUC
)


ebook=
(
ACSM,AEP,APNX,AVA,AZW,AZW1,AZW3,AZW4,BKK,BPNUEB,CBC,CEB,DNL,EA,EAL,EBK,EDN,EPUB,ETD,FB2,FKB,HAN,HTML0,HTMLZ,HTXT,HTZ4,HTZ5,IBOOKS,KOOB,LIT,LRF,LRS,LRX,MART,MBP,MOBI,NCX,NVA,OEB,OEBZIP,OPF,ORB,PEF,PHL,PML,PMLZ,POBI,PRC,QMK,RZB,RZS,SNB,TCR,TK3,TPZ,TR,TR3,VBK,WEBZ,YBK
)


text=
(
1ST,ABW,ACT,ADOC,AIM,ANS,APKG,APT,ASC,ASC,ASCII,ASE,ATY,AWP,AWT,AWW,BAD,BBS,BDP,BDR,BEAN,BIB,BIB,BIBTEX,BML,BNA,BOC,BRX,BTD,BZABW,CALCA,CHARSET,CHART,CHORD,CNM,COD,CRWL,CWS,CYI,DCA,DFTI,DGS,DIZ,DNE,DOC,DOC,DOCM,DOCX,DOCXML,DOCZ,DOX,DROPBOX,DSC,DVI,DWD,DX,DXB,DXP,EIO,EIT,EMF,EML,EMLX,EMULECOLLECTION,EPP,ERR,ERR,ETF,ETX,EUC,FADEINTEMPLATE,FAQ,FBL,FCF,FDF,FDR,FDS,FDT,FDX,FDXT,FFT,FGS,FLR,FODT,FOUNTAIN,FPT,FRT,FWD,FWDN,GDOC,GMD,GPD,GPN,GSD,GTHR,GV,HBK,HHT,HS,HWP,HWP,HZ,IDX,IIL,IPF,IPSPOT,JARVIS,JIS,JNP,JOE,JP1,JRTF,KES,KLG,KLG,KNT,KON,KWD,LATEX,LBT,LIS,LNT,LOG,LP2,LST,LST,LTR,LTX,LUE,LUF,LWP,LXFML,LYT,LYX,MAN,MBOX,MCW,MD5TXT,ME,MELL,MELLEL,MIN,MNT,MSG,MW,MWD,MWP,NB,NDOC,NFO,NGLOSS,NJX,NOTES,NOW,NWCTXT,NWM,NWP,OCR,ODIF,ODM,ODO,ODT,OFL,OPEICO,OPENBSD,ORT,OTT,P7S,PAGES,PAGES-TEF,PDPCMD,PFX,PJT,PLANTUML,PMO,PRT,PRT,PSW,PU,PVJ,PVM,PWD,PWDP,PWDPL,PWI,PWR,QDL,QPF,RAD,README,RFT,RIS,RPT,RST,RTD,RTF,RTFD,RTX,RUN,RVF,RZK,RZN,SAF,SAFETEXT,SAM,SAM,SAVE,SCC,SCM,SCRIV,SCRIVX,SCT,SCW,SDM,SDOC,SDW,SE,SESSION,SGM,SIG,SKCARD,SLA,SLAGZ,SMF,SMS,SSA,STORY,STRINGS,STW,STY,SUB,SUBLIME-PROJECT,SUBLIME-WORKSPACE,SXG,SXW,TAB,TAB,TDF,TDF,TEMPLATE,TEX,TEXT,TEXTCLIPPING,THP,TLB,TM,TMD,TMV,TPC,TRELBY,TVJ,TXT,U3I,UNAUTH,UNX,UOF,UOT,UPD,UTF8,UTXT,VCT,VNT,VW,WBK,WEBDOC,WN,WP,WP4,WP5,WP6,WP7,WPA,WPD,WPD,WPD,WPL,WPS,WPS,WPT,WPT,WPW,WRI,WSD,WTT,WTX,XBDOC,XBPLATE,XDL,XDL,XWP,XWP,XWP,XY,XY3,XYP,XYW,ZABW,ZRTF,ZW
)


executable=
(
0XE,73K,89K,8CK,A6P,A7R,AC,ACC,ACR,ACTC,ACTION,ACTM,AHK,AIR,APK,APP,APP,APP,APPLESCRIPT,ARSCRIPT,ASB,AZW2,BA_,BAT,BEAM,BIN,BIN,BTM,CACTION,CEL,CELX,CGI,CMD,COF,COFFEE,COM,COMMAND,CSH,CYW,DEK,DLD,DMC,DS,DXL,E_E,EAR,EBM,EBS,EBS2,ECF,EHAM,ELF,EPK,ES,ESH,EX4,EX5,EX_,EX_,EXE,EXE,EXE1,EXOPC,EZS,EZT,FAS,FAS,FKY,FPI,FRS,FXP,GADGET,GPE,GPU,GS,HAM,HMS,HPF,HTA,ICD,IIM,IPA,IPF,ISU,ITA,JAR,JS,JSE,JSX,KIX,KSH,KX,LO,LS,M3G,MAM,MCR,MCR,MEL,MEM,MIO,MM,MPX,MRC,MRP,MS,MS,MSL,MXE,N,NEXE,ORE,OSX,OTM,OUT,PAF,PAFEXE,PEX,PHAR,PIF,PLSC,PLX,PRC,PRG,PRG,PS1,PVD,PWC,PYC,PYO,QIT,QPX,RBX,RFU,RGS,ROX,RPJ,RUN,RXE,S2A,SBS,SCA,SCAR,SCB,SCPT,SCPTD,SCR,SCRIPT,SCT,SEED,SHB,SMM,SPR,TCP,THM,TMS,U3P,UDF,UPX,VBE,VBS,VBSCRIPT,VDO,VEXE,VLX,VPM,VXP,WCM,WIDGET,WIDGET,WIZ,WORKFLOW,WPK,WPM,WS,WSF,WSH,X86,XAP,XBAP,XLM,XQT,XYS,ZL9
)


plugin=
(
8BA,8BC,8BE,8BF,8BF,8BI,8BI8,8BL,8BS,8BX,8BY,8LI,AAUI,AAXPLUGIN,ABA,ABI,ACCDA,ACCDU,ACROPLUGIN,ADDON,AEX,AFZPLUG,AGMODULE,AIP,ALP,AMX,AMXX,APD,APE,API,APL,APLG,APLP,ARPACK,ARX,ASI,ASSETPROJ,ATX,AVX,AVX,AX,BAV,BBLM,BKZ,BLU,BMI,BRI,BRM,BRO,BUNDLE,BZPLUG,CCIP,CCX,CDL,CLEO,CMP,CODAPLUGIN,COLORPICKER,COMPONENT,COX,CRX,CST,CVT,DBX,DFP,DLO,DLR,DLU,DPM,DVTPLUGIN,EAZ,ECF,EPK2,EXT,EXV,FFT,FLT,FLT,FMPLUGIN,FMX,FPI,FS,FSB,FWACTION,FWACTIONB,FXT,FZIP,FZP,HVPL,IADACTION,IADCLASS,IADCOMPONENT,IADPAGE,IADPLUG,IADSTYLE,IBPLUGIN,IDEPLUGIN,INDESIGNPLUGIN,INFO,INX,JSXBIN,KMM,LNG,LNG,LRMODULE,LRPLUGIN,LRWEBENGINE,M2P,MAT,MDA,MDE,MDE,MDIMPORTER,MFW,MFX,MILK,MLL,MMIP,MOD,MODE,MODULE,MOX,MTX,MXADDON,MXP,NBM,NBP,NET,NY,OEX,OIV,OSAX,OXT,P,P64,PBA,PFL,PIM,PLG,PLN,PLUGIN,PLUGIN,PLW,PLX,PLX64,PPA,PPAM,PPMOD,PRM,PSET,Q1Q,Q2Q,Q4Q,Q5R,Q7Q,Q8R,Q9R,Q9S,QAR,QLGENERATOR,QPX,QTR,QTX,RBZ,REV,REZ,RHP,ROCK,RPI,RPLIB,RPLN,RPM,RWPLUGIN,SA9,SAFARIEXTZ,SCM,SEPLUGIN,SKYPECHATSTYLE,SO-ABI,SPARC,SPD,SPE,SUBLIME-PACKAGE,SUGAR,SYN,T3X,TBP,TKO,TMBUNDLE,TPI,VBOX-EXTPACK,VDF,VSIX,VSL,VST,WBM,WIE,WLL,WLZ,WOWSL,X32,XADD,XBA,XCODEPLUGIN,XCPLUGIN,XLA,XLAM,XLL,XLV,XMD,XNT,XPI,XPT,XSIADDON,ZLB,ZXP
)


font=
(
ABF,ACFM,AFM,AMFM,BDF,CHA,CHR,COMPOSITEFONT,DFONT,EOT,ETX,EUF,F3F,FFIL,FNT,FON,FOT,GDR,GF,GXF,LWFN,MCF,MF,MXF,NFTR,ODTTF,OTF,PCF,PFA,PFB,PFM,PFR,PK,PMT,SFD,SFP,SUIT,T65,TFM,TTC,TTE,TTF,TXF,VFB,VLW,VNF,WOFF,WOFF2,XFN,XFT,YTF
)


misc=
(
!BT,!UT,000,1,3DC,83P,8XP,_EML,_NWS,_SYSLFO,AAWDEF,ABR,AC$,ACB,ACL,ACS,ADADOWNLOAD,ADD,ADI,AEPKEY,AFPLOC,AHD,AHI,AIF,ALT,AML,AOD,AOI,APF,APPDOWNLOAD,APPUP,ARIA2,ARR,ASS,AUZ,AVASTLIC,AVGDX,AZ!,BBL,BC,BC!,BFC,BKMK,BLF,BMK,BND,BOOTSKIN,BOX,BP2,BP3,BPDX,BPL,BPS,BQY,BST,BT!,BUP,CACHE,CALIBRE,CAS,CBDS,CBT,CCH,CDF-MS,CERBER3,CFL,CFS,CHK,CHUNK001,CHW,CL,CLKK,CLKT,CLKW,CLKX,CLR,CLS,CML,CMM,CONTOUR,COS2,CP3,CRASHED,CRC,CRD,CRD,CRDOWNLOAD,CSH,CTF,CTF,CTG,CUL,CVF,CVR,CXF,DA2,DAL,DAP,DAT,DAT,DB,DBX,DCOVER,DCT,DCTMP,DECRYPT,DEK,DESKTOP,DIC,DISABLED,DISKDEFINES,DLM,DMX-INFO,DOC#,DOWNLOADING,DR,DRC,DSC,DSKIN,DSTUDIO,DTAPART,DTF,DWC,DWL,DWLIBRARY,DWN,EBN,EDC,EF2,EFL,ENC,ENF,ERL,ERR,ESD,EVENT,EXD,EXT,EYB,EZLOG,EZW,FB!,FDR,FEEDBACK,FILE,FLF,FMELIC,FND,FNLF,FPFV,FRM,FRZ,FTIL,FTPLOC,FW,G3A,GAU,GG,GLINK,GOD,GP4,GPG,GROWLREGDICT,GSP,GTA,HDK,HEX,HLX,HMX,HPS,HS,HXA,HXC,HXE,HXK,HYP,ICAL,ICALENDAR,ICMA,ICONTAINER,ICS,ID,IDLK,IDX,IFL,IMAPMBOX,IML,IMY,IN,INCA,INDK,INETLOC,INFO,INFO,ING,INLK,IPSW,ISN,ITC,JAD,JC,JC!,JCL,JCW,JMS,JMT,JMX,JQZ,JRS,KEY,KEY,KHD,KHI,KWM,KYR,LAY,LCK,LDB,LETTER,LIC,LICENSEKEY,LID,LINK,LINX,LOCK,LOGONVISTA,LOGONXP,LOOV,LRC,LRS,LSN,LTF,LWTP,LXA,LYR,MAB,MAG,MAILPLANELICENSE,MAILTOLOC,MANIFEST,MAP,MAR,MAT,MB,MBB,MBS,MC2,MCF,MCFI,MCFP,MCO,MD5,MDF,MDL,MDW,MERLINLICENSE,MFIL,MGDATABASE,MGO,MGT,MIF,MJDOC,MLS,MMO,MNL,MNX,MOBILEPROVISION,MONTAGE,MPCPL,MRK,MSF,MSI,MSO,MSO,MSRCINCIDENT,MSU,MTA,MTD,MTHD,MVI,MWF,MWLIC,MXN,MZZ,NA2,NAV2,NCW,NDL,NFS,NICK,NJB,NK2,NOMEDIA,NSS,NTF,NTH,NUP,NVI,NWM,NWP,OB!,ODF,OLB,OPDOWNLOAD,OPF,OST,OTC,OTF,P10,P2P,P7M,P7R,PAD,PAMP,PANDO,PART,PARTIAL,PDPCOMP,PEKEY,PES,PGP,PID,PKPASS,PLA,PLF,PLSK,PN,PPK,PSAR,PSF,PSI,PSW,PTH,PTR,PVK,PVM,QDS,QUA,QWQ,QXL,RADIUMKEY2,RASKINLICENSE,RAT,RELOC,REM,REQ,REQ,RFB,RFC,RFN,RFP,RFT,RJS,RMF,RMH,RML,RND,RND,ROM,ROV,RPMSG,RSA,RSA,RTC,RTM,RWLIBRARY,RWZ,RXC,SBC,SC,SC2LOCALE,SCW,SDR,SDX,SEARCH-MS,SEC,SF,SFT,SFV,SHA1,SHA512,SHORTCUT,SHS,SHV,SHX,SIDB,SIDD,SIDN,SIS,SISDM,SISX,SISXDM,SKBA,SKINDEX,SKR,SLB,SLF,SLUPKG-MS,SMRD,SMWT,SNF,SNM,SNT,SPD,SPK,SR0,SSC,SSD,SSLF,SST,SSW,STH,STMB,STORYMILL,SUM,SVN-WORK,SWJ,SWP,SXM,T$M,TBS,TCR,TD,TDL,TEC,TEMP,TFIL,THM,TIP,TLB,TLS,TMB,TNEF,TNSP,TOC,TORRENT,TPKEY,TPL,TPM,TPM,TRACE,TSTREAM,TTX,ULS,UNKNOWN,UNL,UPG,VBT,VBT,VFS,VIR,VMDK-CONVERTTMP,VMF_AUTOSAVE,VMG,VMHF,VMHR,VNCLOC,VOL,VOR,VPA,VPC6,VPC7,W,WAL,WBA,WCM,WDSEML,WJE,WJF,WLX,WORDLIST,WRTS,WSZ,WTC,WWD,WZMUL,XENSEARCH,XLNK,XLW,XMP,XNK,XOL,XPR,XSLIC,XWF,XXX,YBD,YBK,YPS,Z1,Z80,ZM1,ZM2,ZM3,ZM9,ZML,ZTF,ZTR,ZVPL,ZZZ
)


is_audio:=""
is_video:=""
is_rasterImage:=""
is_vectorImage:=""
is_web:=""
is_spreadsheet:=""
is_system:=""
is_game:=""
is_settings:=""
is_pageLayout:=""
is_encoded:=""
is_gis:=""
is_3dImage:=""
is_diskImage:=""
is_cameraRaw:=""
is_cad:=""
is_backup:=""
is_compressed:=""
is_database:=""
is_data:=""
is_developer:=""
is_eBook:=""
is_text:=""
is_executable:=""
is_plugin:=""
is_font:=""
is_misc:=""

Loop, Parse, varList, `,	;loop through list of variables
{
this_varName:=A_LoopField
this_var:=%A_LoopField%
Loop, Parse, this_var, `,	;loop through the contents of the current variable
	IfEqual, A_LoopField, %fPathExt%
		is_%this_varName%:="YES"
}

Loop, Parse, gvarList, `,	;loop through list of variables
{
this_varName:=A_LoopField
this_var:=%A_LoopField%
Loop, Parse, this_var, `,	;loop through the contents of the current variable
	if A_LoopField
		Return %this_varName%		;if multiple type matches were found then a global variable check for is_'varName' should allow checking if an explicit filetype match was found
}

}

