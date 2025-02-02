﻿;******************* Scintilla.ahk *********************
;  one part of functions are borowed from TillaGoto
;  other part is modified by Ixiko
;  last modification date: 04.11.2018
;******************************************************

; Main Scintilla Functions
{
		global SCI_ADDTEXT:=2001,SCI_ADDSTYLEDTEXT:=2002,SCI_INSERTTEXT:=2003,SCI_CLEARALL:=2004,SCI_CLEARDOCUMENTSTYLE:=2005,SCI_GETLENGTH:=2006
		,SCI_GETCHARAT:=2007,SCI_GETCURRENTPOS:=2008,SCI_GETANCHOR:=2009,SCI_GETSTYLEAT:=2010,SCI_REDO:=2011,SCI_SETUNDOCOLLECTION:=2012
		,SCI_SELECTALL:=2013,SCI_SETSAVEPOINT:=2014,SCI_GETSTYLEDTEXT:=2015,SCI_CANREDO:=2016,SCI_MARKERLINEFROMHANDLE:=2017
		,SCI_MARKERDELETEHANDLE:=2018,SCI_GETUNDOCOLLECTION:=2019,SCI_GETVIEWWS:=2020,SCI_SETVIEWWS:=2021,SCI_POSITIONFROMPOINT:=2022
		,SCI_POSITIONFROMPOINTCLOSE:=2023,SCI_GOTOLINE:=2024,SCI_GOTOPOS:=2025,SCI_SETANCHOR:=2026,SCI_GETCURLINE:=2027,SCI_GETENDSTYLED:=2028
		,SCI_CONVERTEOLS:=2029,SCI_GETEOLMODE:=2030,SCI_SETEOLMODE:=2031,SCI_STARTSTYLING:=2032,SCI_SETSTYLING:=2033,SCI_GETBUFFEREDDRAW:=2034
		,SCI_SETBUFFEREDDRAW:=2035,SCI_SETTABWIDTH:=2036,SCI_GETTABWIDTH:=2121,SCI_SETCODEPAGE:=2037,SCI_SETUSEPALETTE:=2039,SCI_MARKERDEFINE:=2040
		,SCI_MARKERSETFORE:=2041,SCI_MARKERSETBACK:=2042,SCI_MARKERADD:=2043,SCI_MARKERDELETE:=2044,SCI_MARKERDELETEALL:=2045,SCI_MARKERGET:=2046
		,SCI_MARKERNEXT:=2047,SCI_MARKERPREVIOUS:=2048,SCI_MARKERDEFINEPIXMAP:=2049,SCI_MARKERADDSET:=2466,SCI_MARKERSETALPHA:=2476
		,SCI_SETMARGINTYPEN:=2240,SCI_GETMARGINTYPEN:=2241,SCI_SETMARGINWIDTHN:=2242,SCI_GETMARGINWIDTHN:=2243,SCI_SETMARGINMASKN:=2244
		,SCI_GETMARGINMASKN:=2245,SCI_SETMARGINSENSITIVEN:=2246,SCI_GETMARGINSENSITIVEN:=2247,SCI_STYLECLEARALL:=2050,SCI_STYLESETFORE:=2051
		,SCI_STYLESETBACK:=2052,SCI_STYLESETBOLD:=2053,SCI_STYLESETITALIC:=2054,SCI_STYLESETSIZE:=2055,SCI_STYLESETFONT:=2056
		,SCI_STYLESETEOLFILLED:=2057,SCI_STYLEGETFORE:=2481,SCI_STYLEGETBACK:=2482,SCI_STYLEGETBOLD:=2483,SCI_STYLEGETITALIC:=2484
		,SCI_STYLEGETSIZE:=2485,SCI_STYLEGETFONT:=2486,SCI_STYLEGETEOLFILLED:=2487,SCI_STYLEGETUNDERLINE:=2488,SCI_STYLEGETCASE:=2489
		,SCI_STYLEGETCHARACTERSET:=2490,SCI_STYLEGETVISIBLE:=2491,SCI_STYLEGETCHANGEABLE:=2492,SCI_STYLEGETHOTSPOT:=2493,SCI_STYLERESETDEFAULT:=2058
		,SCI_STYLESETUNDERLINE:=2059,SCI_STYLESETCASE:=2060,SCI_STYLESETCHARACTERSET:=2066,SCI_STYLESETHOTSPOT:=2409,SCI_SETSELFORE:=2067
		,SCI_SETSELBACK:=2068,SCI_GETSELALPHA:=2477,SCI_SETSELALPHA:=2478,SCI_SETCARETFORE:=2069,SCI_ASSIGNCMDKEY:=2070,SCI_CLEARCMDKEY:=2071
		,SCI_CLEARALLCMDKEYS:=2072,SCI_SETSTYLINGEX:=2073,SCI_STYLESETVISIBLE:=2074,SCI_GETCARETPERIOD:=2075,SCI_SETCARETPERIOD:=2076
		,SCI_SETWORDCHARS:=2077,SCI_BEGINUNDOACTION:=2078,SCI_ENDUNDOACTION:=2079,SCI_INDICSETSTYLE:=2080,SCI_INDICGETSTYLE:=2081
		,SCI_INDICSETFORE:=2082,SCI_INDICGETFORE:=2083,SCI_SETWHITESPACEFORE:=2084,SCI_SETWHITESPACEBACK:=2085,SCI_SETSTYLEBITS:=2090
		,SCI_GETSTYLEBITS:=2091,SCI_SETLINESTATE:=2092,SCI_GETLINESTATE:=2093,SCI_GETMAXLINESTATE:=2094,SCI_GETCARETLINEVISIBLE:=2095
		,SCI_SETCARETLINEVISIBLE:=2096,SCI_GETCARETLINEBACK:=2097,SCI_SETCARETLINEBACK:=2098,SCI_STYLESETCHANGEABLE:=2099,SCI_AUTOCSHOW:=2100
		,SCI_AUTOCCANCEL:=2101,SCI_AUTOCACTIVE:=2102,SCI_AUTOCPOSSTART:=2103,SCI_AUTOCCOMPLETE:=2104,SCI_AUTOCSTOPS:=2105
		,SCI_AUTOCSETSEPARATOR:=2106,SCI_AUTOCGETSEPARATOR:=2107,SCI_AUTOCSELECT:=2108,SCI_AUTOCSETCANCELATSTART:=2110
		,SCI_AUTOCGETCANCELATSTART:=2111,SCI_AUTOCSETFILLUPS:=2112,SCI_AUTOCSETCHOOSESINGLE:=2113,SCI_AUTOCGETCHOOSESINGLE:=2114
		,SCI_AUTOCSETIGNORECASE:=2115,SCI_AUTOCGETIGNORECASE:=2116,SCI_USERLISTSHOW:=2117,SCI_AUTOCSETAUTOHIDE:=2118,SCI_AUTOCGETAUTOHIDE:=2119
		,SCI_AUTOCSETDROPRESTOFWORD:=2270,SCI_AUTOCGETDROPRESTOFWORD:=2271,SCI_REGISTERIMAGE:=2405,SCI_CLEARREGISTEREDIMAGES:=2408
		,SCI_AUTOCGETTYPESEPARATOR:=2285,SCI_AUTOCSETTYPESEPARATOR:=2286,SCI_AUTOCSETMAXWIDTH:=2208,SCI_AUTOCGETMAXWIDTH:=2209
		,SCI_AUTOCSETMAXHEIGHT:=2210,SCI_AUTOCGETMAXHEIGHT:=2211,SCI_SETINDENT:=2122,SCI_GETINDENT:=2123,SCI_SETUSETABS:=2124,SCI_GETUSETABS:=2125
		,SCI_SETLINEINDENTATION:=2126,SCI_GETLINEINDENTATION:=2127,SCI_GETLINEINDENTPOSITION:=2128,SCI_GETCOLUMN:=2129,SCI_SETHSCROLLBAR:=2130
		,SCI_GETHSCROLLBAR:=2131,SCI_SETINDENTATIONGUIDES:=2132,SCI_GETINDENTATIONGUIDES:=2133,SCI_SETHIGHLIGHTGUIDE:=2134
		,SCI_GETHIGHLIGHTGUIDE:=2135,SCI_GETLINEENDPOSITION:=2136,SCI_GETCODEPAGE:=2137,SCI_GETCARETFORE:=2138,SCI_GETUSEPALETTE:=2139
		,SCI_GETREADONLY:=2140,SCI_SETCURRENTPOS:=2141,SCI_SETSELECTIONSTART:=2142,SCI_GETSELECTIONSTART:=2143,SCI_SETSELECTIONEND:=2144
		,SCI_GETSELECTIONEND:=2145,SCI_SETPRINTMAGNIFICATION:=2146,SCI_GETPRINTMAGNIFICATION:=2147,SCI_SETPRINTCOLORMODE:=2148
		,SCI_GETPRINTCOLORMODE:=2149,SCI_FINDTEXT:=2150,SCI_FORMATRANGE:=2151,SCI_GETFIRSTVISIBLELINE:=2152,SCI_GETLINE:=2153
		,SCI_GETLINECOUNT:=2154,SCI_SETMARGINLEFT:=2155,SCI_GETMARGINLEFT:=2156,SCI_SETMARGINRIGHT:=2157,SCI_GETMARGINRIGHT:=2158
		,SCI_GETMODIFY:=2159,SCI_SETSEL:=2160,SCI_GETSELTEXT:=2161,SCI_GETTEXTRANGE:=2162,SCI_HIDESELECTION:=2163,SCI_POINTXFROMPOSITION:=2164
		,SCI_POINTYFROMPOSITION:=2165,SCI_LINEFROMPOSITION:=2166,SCI_POSITIONFROMLINE:=2167,SCI_LINESCROLL:=2168,SCI_SCROLLCARET:=2169
		,SCI_REPLACESEL:=2170,SCI_SETREADONLY:=2171,SCI_NULL:=2172,SCI_CANPASTE:=2173,SCI_CANUNDO:=2174,SCI_EMPTYUNDOBUFFER:=2175,SCI_UNDO:=2176
		,SCI_CUT:=2177,SCI_COPY:=2178,SCI_PASTE:=2179,SCI_CLEAR:=2180,SCI_SETTEXT:=2181,SCI_GETTEXT:=2182,SCI_GETTEXTLENGTH:=2183
		,SCI_GETDIRECTFUNCTION:=2184,SCI_GETDIRECTPOINTER:=2185,SCI_SETOVERTYPE:=2186,SCI_GETOVERTYPE:=2187,SCI_SETCARETWIDTH:=2188
		,SCI_GETCARETWIDTH:=2189,SCI_SETTARGETSTART:=2190,SCI_GETTARGETSTART:=2191,SCI_SETTARGETEND:=2192,SCI_GETTARGETEND:=2193
		,SCI_REPLACETARGET:=2194,SCI_REPLACETARGETRE:=2195,SCI_SEARCHINTARGET:=2197,SCI_SETSEARCHFLAGS:=2198,SCI_GETSEARCHFLAGS:=2199
		,SCI_CALLTIPSHOW:=2200,SCI_CALLTIPCANCEL:=2201,SCI_CALLTIPACTIVE:=2202,SCI_CALLTIPPOSSTART:=2203,SCI_CALLTIPSETHLT:=2204
		,SCI_CALLTIPSETBACK:=2205,SCI_CALLTIPSETFORE:=2206,SCI_CALLTIPSETFOREHLT:=2207,SCI_CALLTIPUSESTYLE:=2212,SCI_VISIBLEFROMDOCLINE:=2220
		,SCI_DOCLINEFROMVISIBLE:=2221,SCI_WRAPCOUNT:=2235,SCI_SETFOLDLEVEL:=2222,SCI_GETFOLDLEVEL:=2223,SCI_GETLASTCHILD:=2224
		,SCI_GETFOLDPARENT:=2225,SCI_SHOWLINES:=2226,SCI_HIDELINES:=2227,SCI_GETLINEVISIBLE:=2228,SCI_SETFOLDEXPANDED:=2229
		,SCI_GETFOLDEXPANDED:=2230,SCI_TOGGLEFOLD:=2231,SCI_ENSUREVISIBLE:=2232,SCI_SETFOLDFLAGS:=2233,SCI_ENSUREVISIBLEENFORCEPOLICY:=2234
		,SCI_SETTABINDENTS:=2260,SCI_GETTABINDENTS:=2261,SCI_SETBACKSPACEUNINDENTS:=2262,SCI_GETBACKSPACEUNINDENTS:=2263,SCI_SETMOUSEDWELLTIME:=2264
		,SCI_GETMOUSEDWELLTIME:=2265,SCI_WORDSTARTPOSITION:=2266,SCI_WORDENDPOSITION:=2267,SCI_SETWRAPMODE:=2268,SCI_GETWRAPMODE:=2269
		,SCI_SETWRAPVISUALFLAGS:=2460,SCI_GETWRAPVISUALFLAGS:=2461,SCI_SETWRAPVISUALFLAGSLOCATION:=2462,SCI_GETWRAPVISUALFLAGSLOCATION:=2463
		,SCI_SETWRAPSTARTINDENT:=2464,SCI_GETWRAPSTARTINDENT:=2465,SCI_SETLAYOUTCACHE:=2272,SCI_GETLAYOUTCACHE:=2273,SCI_SETSCROLLWIDTH:=2274
		,SCI_GETSCROLLWIDTH:=2275,SCI_TEXTWIDTH:=2276,SCI_SETENDATLASTLINE:=2277,SCI_GETENDATLASTLINE:=2278,SCI_TEXTHEIGHT:=2279
		,SCI_SETVSCROLLBAR:=2280,SCI_GETVSCROLLBAR:=2281,SCI_APPENDTEXT:=2282,SCI_GETTWOPHASEDRAW:=2283,SCI_SETTWOPHASEDRAW:=2284
		,SCI_TARGETFROMSELECTION:=2287,SCI_LINESJOIN:=2288,SCI_LINESSPLIT:=2289,SCI_SETFOLDMARGINCOLOR:=2290,SCI_SETFOLDMARGINHICOLOR:=2291
		,SCI_ZOOMIN:=2333,SCI_ZOOMOUT:=2334,SCI_MOVECARETINSIDEVIEW:=2401,SCI_LINELENGTH:=2350,SCI_BRACEHIGHLIGHT:=2351,SCI_BRACEBADLIGHT:=2352
		,SCI_BRACEMATCH:=2353,SCI_GETVIEWEOL:=2355,SCI_SETVIEWEOL:=2356,SCI_GETDOCPOINTER:=2357,SCI_SETDOCPOINTER:=2358,SCI_SETMODEVENTMASK:=2359
		,SCI_GETEDGECOLUMN:=2360,SCI_SETEDGECOLUMN:=2361,SCI_GETEDGEMODE:=2362,SCI_SETEDGEMODE:=2363,SCI_GETEDGECOLOR:=2364,SCI_SETEDGECOLOR:=2365
		,SCI_SEARCHANCHOR:=2366,SCI_SEARCHNEXT:=2367,SCI_SEARCHPREV:=2368,SCI_LINESONSCREEN:=2370,SCI_USEPOPUP:=2371,SCI_SELECTIONISRECTANGLE:=2372
		,SCI_SETZOOM:=2373,SCI_GETZOOM:=2374,SCI_CREATEDOCUMENT:=2375,SCI_ADDREFDOCUMENT:=2376,SCI_RELEASEDOCUMENT:=2377,SCI_GETMODEVENTMASK:=2378
		,SCI_SETFOCUS:=2380,SCI_GETFOCUS:=2381,SCI_SETSTATUS:=2382,SCI_GETSTATUS:=2383,SCI_SETMOUSEDOWNCAPTURES:=2384,SCI_GETMOUSEDOWNCAPTURES:=2385
		,SCI_SETCURSOR:=2386,SCI_GETCURSOR:=2387,SCI_SETCONTROLCHARSYMBOL:=2388,SCI_GETCONTROLCHARSYMBOL:=2389,SCI_SETVISIBLEPOLICY:=2394
		,SCI_SETXOFFSET:=2397,SCI_GETXOFFSET:=2398,SCI_CHOOSECARETX:=2399,SCI_GRABFOCUS:=2400,SCI_SETXCARETPOLICY:=2402,SCI_SETYCARETPOLICY:=2403
		,SCI_SETPRINTWRAPMODE:=2406,SCI_GETPRINTWRAPMODE:=2407,SCI_SETHOTSPOTACTIVEFORE:=2410,SCI_SETHOTSPOTACTIVEBACK:=2411
		,SCI_SETHOTSPOTACTIVEUNDERLINE:=2412,SCI_SETHOTSPOTSINGLELINE:=2421,SCI_POSITIONBEFORE:=2417,SCI_POSITIONAFTER:=2418
		,SCI_COPYRANGE:=2419,SCI_COPYTEXT:=2420,SCI_SETSELECTIONMODE:=2422,SCI_GETSELECTIONMODE:=2423,SCI_GETLINESELSTARTPOSITION:=2424
		,SCI_GETLINESELENDPOSITION:=2425,SCI_SETWHITESPACECHARS:=2443,SCI_SETCHARSDEFAULT:=2444,SCI_AUTOCGETCURRENT:=2445,SCI_ALLOCATE:=2446
		,SCI_TARGETASUTF8:=2447,SCI_SETLENGTHFORENCODE:=2448,SCI_ENCODEDFROMUTF8:=2449,SCI_FINDCOLUMN:=2456,SCI_GETCARETSTICKY:=2457
		,SCI_SETCARETSTICKY:=2458,SCI_TOGGLECARETSTICKY:=2459,SCI_SETPASTECONVERTENDINGS:=2467,SCI_GETPASTECONVERTENDINGS:=2468
		,SCI_SETCARETLINEBACKALPHA:=2470,SCI_GETCARETLINEBACKALPHA:=2471,SCI_STARTRECORD:=3001,SCI_STOPRECORD:=3002,SCI_SETLEXER:=4001
		,SCI_GETLEXER:=4002,SCI_COLORISE:=4003,SCI_SETPROPERTY:=4004,SCI_SETKEYWORDS:=4005,SCI_SETLEXERLANGUAGE:=4006,SCI_LOADLEXERLIBRARY:=4007
		,SCI_GETPROPERTY:=4008,SCI_GETPROPERTYEXPANDED:=4009,SCI_GETPROPERTYINT:=4010,SCI_GETSTYLEBITSNEEDED:=4011
	}

; Styles, Markers and Indicators
{
		global MARKER_MAX:=31,STYLE_DEFAULT:=32,STYLE_LINENUMBER:=33,STYLE_BRACELIGHT:=34,STYLE_BRACEBAD:=35,STYLE_CONTROLCHAR:=36
		,STYLE_INDENTGUIDE:=37,STYLE_CALLTIP:=38,STYLE_LASTPREDEFINED:=39,STYLE_MAX:=127,INDIC_MAX:=7,INDIC_PLAIN:=0,INDIC_SQUIGGLE:=1,INDIC_TT:=2
		,INDIC_DIAGONAL:=3,INDIC_STRIKE:=4,INDIC_HIDDEN:=5,INDIC_BOX:=6,INDIC_ROUNDBOX:=7,INDIC0_MASK:=0x20,INDIC1_MASK:=0x40,INDIC2_MASK:=0x80
		,INDICS_MASK:=0xE0,SCI_START:=2000,SCI_OPTIONAL_START:=3000,SCI_LEXER_START:=4000,SCWS_INVISIBLE:=0,SCWS_VISIBLEALWAYS:=1
		,SCWS_VISIBLEAFTERINDENT:=2,SC_EOL_CRLF:=0,SC_EOL_CR:=1,SC_EOL_LF:=2,SC_CP_UTF8:=65001,SC_CP_DBCS:=1,SC_MARK_CIRCLE:=0,SC_MARK_ROUNDRECT:=1
		,SC_MARK_ARROW:=2,SC_MARK_SMALLRECT:=3,SC_MARK_SHORTARROW:=4,SC_MARK_EMPTY:=5,SC_MARK_ARROWDOWN:=6,SC_MARK_MINUS:=7,SC_MARK_PLUS:=8
		,SC_MARK_VLINE:=9,SC_MARK_LCORNER:=10,SC_MARK_TCORNER:=11,SC_MARK_BOXPLUS:=12,SC_MARK_BOXPLUSCONNECTED:=13,SC_MARK_BOXMINUS:=14
		,SC_MARK_BOXMINUSCONNECTED:=15,SC_MARK_LCORNERCURVE:=16,SC_MARK_TCORNERCURVE:=17,SC_MARK_CIRCLEPLUS:=18,SC_MARK_CIRCLEPLUSCONNECTED:=19
		,SC_MARK_CIRCLEMINUS:=20,SC_MARK_CIRCLEMINUSCONNECTED:=21,SC_MARK_BACKGROUND:=22,SC_MARK_DOTDOTDOT:=23,SC_MARK_ARROWS:=24
		,SC_MARK_PIXMAP:=25,SC_MARK_FULLRECT:=26,SC_MARK_CHARACTER:=10000,SC_MARKNUM_FOLDEREND:=25,SC_MARKNUM_FOLDEROPENMID:=26
		,SC_MARKNUM_FOLDERMIDTAIL:=27,SC_MARKNUM_FOLDERTAIL:=28,SC_MARKNUM_FOLDERSUB:=29,SC_MARKNUM_FOLDER:=30,SC_MARKNUM_FOLDEROPEN:=31
		,SC_MASK_FOLDERS:=0xFE000000,SC_MARGIN_SYMBOL:=0,SC_MARGIN_NUMBER:=1
	}

; Character Sets and Printing
{
		global SC_CHARSET_ANSI:=0,SC_CHARSET_DEFAULT:=1,SC_CHARSET_BALTIC:=186
		,SC_CHARSET_CHINESEBIG5:=136,SC_CHARSET_EASTEUROPE:=238,SC_CHARSET_GB2312:=134,SC_CHARSET_GREEK:=161,SC_CHARSET_HANGUL:=129
		,SC_CHARSET_MAC:=77,SC_CHARSET_OEM:=255,SC_CHARSET_RUSSIAN:=204,SC_CHARSET_CYRILLIC:=1251,SC_CHARSET_SHIFTJIS:=128
		,SC_CHARSET_SYMBOL:=2,SC_CHARSET_TURKISH:=162,SC_CHARSET_JOHAB:=130,SC_CHARSET_HEBREW:=177,SC_CHARSET_ARABIC:=178,SC_CHARSET_VIETNAMESE:=163
		,SC_CHARSET_THAI:=222,SC_CHARSET_8859_15:=1000, SC_CASE_MIXED:=0,SC_CASE_UPPER:=1,SC_CASE_LOWER:=2,SC_PRINT_NORMAL:=0,SC_PRINT_INVERTLIGHT:=1
		,SC_PRINT_BLACKONWHITE:=2,SC_PRINT_COLORONWHITE:=3,SC_PRINT_COLORONWHITEDEFAULTBG:=4
	}

; Search Flags
{
		global SCFIND_WHOLEWORD:=2,SCFIND_MATCHCASE:=4
		,SCFIND_WORDSTART:=0x00100000,SCFIND_REGEXP:=0x00200000,SCFIND_POSIX:=0x00400000
	}

; Folding
{
		global SC_FOLDLEVELBASE:=0x400,SC_FOLDLEVELWHITEFLAG:=0x1000
		,SC_FOLDLEVELHEADERFLAG:=0x2000,SC_FOLDLEVELBOXHEADERFLAG:=0x4000,SC_FOLDLEVELBOXFOOTERFLAG:=0x8000,SC_FOLDLEVELCONTRACTED:=0x10000
		,SC_FOLDLEVELUNINDENT:=0x20000,SC_FOLDLEVELNUMBERMASK:=0x0FFF,SC_FOLDFLAG_LINEBEFORE_EXPANDED:=0x0002,SC_FOLDFLAG_LINEBEFORE_CONTRACTED:=0x0004
		,SC_FOLDFLAG_LINEAFTER_EXPANDED:=0x0008,SC_FOLDFLAG_LINEAFTER_CONTRACTED:=0x0010,SC_FOLDFLAG_LEVELNUMBERS:=0x0040,SC_FOLDFLAG_BOX:=0x0001
	}

; Keys
{
		global SCMOD_NORM:=0, SCMOD_SHIFT:=1,SCMOD_CTRL:=2,SCMOD_ALT:=4, SCK_DOWN:=300,SCK_UP:=301,SCK_LEFT:=302,SCK_RIGHT:=303,SCK_HOME:=304,SCK_END:=305
		,SCK_PRIOR:=306,SCK_NEXT:=307,SCK_DELETE:=308,SCK_INSERT:=309,SCK_ESCAPE:=7,SCK_BACK:=8,SCK_TAB:=9,SCK_RETURN:=13,SCK_ADD:=310,SCK_SUBTRACT:=311
		,SCK_DIVIDE:=312
	}

; Lexing
{
		global SCLEX_CONTAINER:=0,SCLEX_NULL:=1,SCLEX_PYTHON:=2,SCLEX_CPP:=3,SCLEX_HTML:=4,SCLEX_XML:=5,SCLEX_PERL:=6,SCLEX_SQL:=7,SCLEX_VB:=8
		,SCLEX_PROPERTIES:=9,SCLEX_ERRORLIST:=10,SCLEX_MAKEFILE:=11,SCLEX_BATCH:=12,SCLEX_XCODE:=13,SCLEX_LATEX:=14,SCLEX_LUA:=15,SCLEX_DIFF:=16
		,SCLEX_CONF:=17,SCLEX_PASCAL:=18,SCLEX_AVE:=19,SCLEX_ADA:=20,SCLEX_LISP:=21,SCLEX_RUBY:=22,SCLEX_EIFFEL:=23,SCLEX_EIFFELKW:=24
		,SCLEX_TCL:=25,SCLEX_NNCRONTAB:=26,SCLEX_BULLANT:=27,SCLEX_VBSCRIPT:=28,SCLEX_BAAN:=31,SCLEX_MATLAB:=32,SCLEX_SCRIPTOL:=33
		,SCLEX_ASM:=34,SCLEX_CPPNOCASE:=35,SCLEX_FORTRAN:=36,SCLEX_F77:=37,SCLEX_CSS:=38,SCLEX_POV:=39,SCLEX_LOUT:=40,SCLEX_ESCRIPT:=41
		,SCLEX_PS:=42,SCLEX_NSIS:=43,SCLEX_MMIXAL:=44,SCLEX_CLW:=45,SCLEX_CLWNOCASE:=46,SCLEX_LOT:=47,SCLEX_YAML:=48,SCLEX_TEX:=49
		,SCLEX_METAPOST:=50,SCLEX_POWERBASIC:=51,SCLEX_FORTH:=52,SCLEX_ERLANG:=53,SCLEX_OCTAVE:=54,SCLEX_MSSQL:=55,SCLEX_VERILOG:=56,SCLEX_KIX:=57
		,SCLEX_GUI4CLI:=58,SCLEX_SPECMAN:=59,SCLEX_AU3:=60,SCLEX_APDL:=61,SCLEX_BASH:=62,SCLEX_ASN1:=63,SCLEX_VHDL:=64,SCLEX_CAML:=65
		,SCLEX_BLITZBASIC:=66,SCLEX_PUREBASIC:=67,SCLEX_HASKELL:=68,SCLEX_PHPSCRIPT:=69,SCLEX_TADS3:=70,SCLEX_REBOL:=71,SCLEX_SMALLTALK:=72
		,SCLEX_FLAGSHIP:=73,SCLEX_CSOUND:=74,SCLEX_FREEBASIC:=75,SCLEX_INNOSETUP:=76,SCLEX_OPAL:=77,SCLEX_SPICE:=78,SCLEX_D:=79,SCLEX_CMAKE:=80
		,SCLEX_GAP:=81,SCLEX_PLM:=82,SCLEX_PROGRESS:=83,SCLEX_ABAQUS:=84,SCLEX_ASYMPTOTE:=85,SCLEX_R:=86,SCLEX_MAGIK:=87,SCLEX_POWERSHELL:=88
		,SCLEX_MYSQL:=89,SCLEX_PO:=90,SCLEX_TAL:=91,SCLEX_COBOL:=92,SCLEX_TACL:=93,SCLEX_SORCUS:=94,SCLEX_POWERPRO:=95,SCLEX_NIMROD:=96,SCLEX_SML:=97
		,SCLEX_MARKDOWN:=98,SCLEX_TXT2TAGS:=99,SCLEX_A68K:=100,SCLEX_MODULA:=101,SCLEX_COFFEESCRIPT:=102,SCLEX_TCMD:=103,SCLEX_AVS:=104,SCLEX_ECL:=105
		,SCLEX_OSCRIPT:=106,SCLEX_VISUALPROLOG:=107,SCLEX_LITERATEHASKELL:=108,SCLEX_AHKL:=109
		,SCE_AHKL_NEUTRAL:=0,SCE_AHKL_IDENTIFIER:=1,SCE_AHKL_COMMENTDOC:=2,SCE_AHKL_COMMENTLINE:=3,SCE_AHKL_COMMENTBLOCK:=4,SCE_AHKL_COMMENTKEYWORD:=5
		,SCE_AHKL_STRING:=6,SCE_AHKL_STRINGOPTS:=7,SCE_AHKL_STRINGBLOCK:=8,SCE_AHKL_STRINGCOMMENT:=9,SCE_AHKL_LABEL:=10,SCE_AHKL_HOTKEY:=11
		,SCE_AHKL_HOTSTRING:=12,SCE_AHKL_HOTSTRINGOPT:=13,SCE_AHKL_HEXNUMBER:=14,SCE_AHKL_DECNUMBER:=15,SCE_AHKL_VAR:=16,SCE_AHKL_VARREF:=17
		,SCE_AHKL_OBJECT:=18,SCE_AHKL_USERFUNCTION:=19,SCE_AHKL_DIRECTIVE:=20,SCE_AHKL_COMMAND:=21,SCE_AHKL_PARAM:=22,SCE_AHKL_CONTROLFLOW:=23
		,SCE_AHKL_BUILTINFUNCTION:=24,SCE_AHKL_BUILTINVAR:=25,SCE_AHKL_KEY:=26,SCE_AHKL_USERDEFINED1:=27,SCE_AHKL_USERDEFINED2:=28,SCE_AHKL_ESCAPESEQ:=30
		,SCE_AHKL_ERROR:=31,AHKL_LIST_DIRECTIVES:=0,AHKL_LIST_COMMANDS:=1,AHKL_LIST_PARAMETERS:=2,AHKL_LIST_CONTROLFLOW:=3,AHKL_LIST_FUNCTIONS:=4
		,AHKL_LIST_VARIABLES:=5,AHKL_LIST_KEYS:=6,AHKL_LIST_USERDEFINED1:=7,AHKL_LIST_USERDEFINED2:=8,SCLEX_AUTOMATIC:=1000
	}

; Notifications
{
		global SCEN_CHANGE:=768,SCEN_SETFOCUS:=512,SCEN_KILLFOCUS:=256, SCN_STYLENEEDED:=2000,SCN_CHARADDED:=2001
		,SCN_SAVEPOINTREACHED:=2002,SCN_SAVEPOINTLEFT:=2003,SCN_MODIFYATTEMPTRO:=2004,SCN_KEY:=2005,SCN_DOUBLECLICK:=2006,SCN_UPDATEUI:=2007
		,SCN_MODIFIED:=2008,SCN_MACRORECORD:=2009,SCN_MARGINCLICK:=2010,SCN_NEEDSHOWN:=2011,SCN_PAINTED:=2013,SCN_USERLISTSELECTION:=2014
		,SCN_URIDROPPED:=2015,SCN_DWELLSTART:=2016,SCN_DWELLEND:=2017,SCN_ZOOM:=2018,SCN_HOTSPOTCLICK:=2019,SCN_HOTSPOTDOUBLECLICK:=2020
		,SCN_CALLTIPCLICK:=2021,SCN_AUTOCSELECTION:=2022
	}

; Other
{
		global SCI_LINEDOWN:=2300,SCI_LINEDOWNEXTEND:=2301,SCI_LINEDOWNRECTEXTEND:=2426
		,SCI_LINESCROLLDOWN:=2342,SCI_LINEUP:=2302,SCI_LINEUPEXTEND:=2303,SCI_LINEUPRECTEXTEND:=2427,SCI_LINESCROLLUP:=2343,SCI_PARADOWN:=2413
		,SCI_PARADOWNEXTEND:=2414,SCI_PARAUP:=2415,SCI_PARAUPEXTEND:=2416,SCI_CHARLEFT:=2304,SCI_CHARLEFTEXTEND:=2305,SCI_CHARLEFTRECTEXTEND:=2428
		,SCI_CHARRIGHT:=2306,SCI_CHARRIGHTEXTEND:=2307,SCI_CHARRIGHTRECTEXTEND:=2429,SCI_WORDLEFT:=2308,SCI_WORDLEFTEXTEND:=2309,SCI_WORDRIGHT:=2310
		,SCI_WORDRIGHTEXTEND:=2311,SCI_WORDLEFTEND:=2439,SCI_WORDLEFTENDEXTEND:=2440,SCI_WORDRIGHTEND:=2441,SCI_WORDRIGHTENDEXTEND:=2442
		,SCI_WORDPARTLEFT:=2390,SCI_WORDPARTLEFTEXTEND:=2391,SCI_WORDPARTRIGHT:=2392,SCI_WORDPARTRIGHTEXTEND:=2393,SCI_HOME:=2312
		,SCI_HOMEEXTEND:=2313,SCI_HOMERECTEXTEND:=2430,SCI_HOMEDISPLAY:=2345,SCI_HOMEDISPLAYEXTEND:=2346,SCI_HOMEWRAP:=2349
		,SCI_HOMEWRAPEXTEND:=2450,SCI_VCHOME:=2331,SCI_VCHOMEEXTEND:=2332,SCI_VCHOMERECTEXTEND:=2431,SCI_VCHOMEWRAP:=2453,SCI_VCHOMEWRAPEXTEND:=2454
		,SCI_LINEEND:=2314,SCI_LINEENDEXTEND:=2315,SCI_LINEENDRECTEXTEND:=2432,SCI_LINEENDDISPLAY:=2347,SCI_LINEENDDISPLAYEXTEND:=2348
		,SCI_LINEENDWRAP:=2451,SCI_LINEENDWRAPEXTEND:=2452,SCI_DOCUMENTSTART:=2316,SCI_DOCUMENTSTARTEXTEND:=2317,SCI_DOCUMENTEND:=2318
		,SCI_DOCUMENTENDEXTEND:=2319,SCI_PAGEUP:=2320,SCI_PAGEUPEXTEND:=2321,SCI_PAGEUPRECTEXTEND:=2433,SCI_PAGEDOWN:=2322,SCI_PAGEDOWNEXTEND:=2323
		,SCI_PAGEDOWNRECTEXTEND:=2434,SCI_STUTTEREDPAGEUP:=2435,SCI_STUTTEREDPAGEUPEXTEND:=2436,SCI_STUTTEREDPAGEDOWN:=2437
		,SCI_STUTTEREDPAGEDOWNEXTEND:=2438,SCI_DELETEBACK:=2326,SCI_DELETEBACKNOTLINE:=2344,SCI_DELWORDLEFT:=2335,SCI_DELWORDRIGHT:=2336
		,SCI_DELLINELEFT:=2395,SCI_DELLINERIGHT:=2396,SCI_LINEDELETE:=2338,SCI_LINECUT:=2337,SCI_LINECOPY:=2455,SCI_LINETRANSPOSE:=2339
		,SCI_LINEDUPLICATE:=2404,SCI_LOWERCASE:=2340,SCI_UPPERCASE:=2341,SCI_CANCEL:=2325,SCI_EDITTOGGLEOVERTYPE:=2324,SCI_NEWLINE:=2329
		,SCI_FORMFEED:=2330,SCI_TAB:=2327,SCI_BACKTAB:=2328,SCI_SELECTIONDUPLICATE:=2469,SCI_SCROLLTOSTART:=2628,SCI_SCROLLTOEND:=2629
		,SCI_DELWORDRIGHTEND:=2518,SCI_VERTICALCENTRECARET:=2619,SCI_MOVESELECTEDLINESUP:=2620,SCI_MOVESELECTEDLINESDOWN:=2621
		,SC_TIME_FOREVER:=10000000,SC_WRAP_NONE:=0,SC_WRAP_WORD:=1,SC_WRAP_CHAR:=2,SC_WRAPVISUALFLAG_NONE:=0x0000,SC_WRAPVISUALFLAG_END:=0x0001
		,SC_WRAPVISUALFLAG_START:=0x0002,SC_WRAPVISUALFLAG_MARGIN:=0x0004, SC_WRAPVISUALFLAGLOC_DEFAULT:=0x0000,SC_WRAPVISUALFLAGLOC_END_BY_TEXT:=0x0001
		,SC_WRAPVISUALFLAGLOC_START_BY_TEXT:=0x0002,SC_CACHE_NONE:=0,SC_CACHE_CARET:=1,SC_CACHE_PAGE:=2,SC_CACHE_DOCUMENT:=3,EDGE_NONE:=0,EDGE_LINE:=1
		,EDGE_BACKGROUND:=2,SC_CURSORNORMAL:=-1,SC_CURSORWAIT:=4,VISIBLE_SLOP:=0x01,VISIBLE_STRICT:=0x04,CARET_SLOP:=0x01,CARET_STRICT:=0x04
		,CARET_JUMPS:=0x10,CARET_EVEN:=0x08,SC_SEL_STREAM:=0,SC_SEL_RECTANGLE:=1,SC_SEL_LINES:=2,SC_ALPHA_TRANSPARENT:=0,SC_ALPHA_OPAQUE:=255
		,SC_ALPHA_NOALPHA:=256,KEYWORDSET_MAX:=8,SC_MOD_INSERTTEXT:=0x1,SC_MOD_DELETETEXT:=0x2,SC_MOD_CHANGESTYLE:=0x4,SC_MOD_CHANGEFOLD:=0x8
		,SC_PERFORMED_USER:=0x10,SC_PERFORMED_UNDO:=0x20,SC_PERFORMED_REDO:=0x40,SC_MULTISTEPUNDOREDO:=0x80,SC_LASTSTEPINUNDOREDO:=0x100
		,SC_MOD_CHANGEMARKER:=0x200,SC_MOD_BEFOREINSERT:=0x400,SC_MOD_BEFOREDELETE:=0x800,SC_MULTILINEUNDOREDO:=0x1000,SC_MODEVENTMASKALL:=0x1FFF
		,SC_WEIGHT_NORMAL:=400, SC_WEIGHT_SEMIBOLD:=600, SC_WEIGHT_BOLD:=700
	}


FoldChildren() {

	oScite	:= GetSciTEInstance()
	scitehwnd  	:= oSciTE.SciTEHandle
	ControlGet, hSci, Hwnd,, Scintilla1, ahk_id %scitehwnd%
	foldLine:= Sci_CurrentLine() ;- 1
	SendMessage, 2231, % foldline, 0,, ahk_id %hSci%

}

Scite_SelectCurrLineAndReadIt() {
	SendInput, {Home}
		sleep, 20
	SendInput, {LShift Down}{End}{LShift Up}
		sleep, 20
	return Sci_GetSelection()
}

;get - retrieve text, get informations
GetSciTEInstance() {
	
	olderr := ComObjError()
	ComObjError(false)
	scite := ComObjActive("{D7334085-22FB-416E-B398-B5038A5A0784}")
	ComObjError(olderr)
	return IsObject(scite) ? scite : ""
}
Sci_GetCP() {
	; Retrieve active codepage. SCI_GETCODEPAGE
	SendMessage, 2137, 0, 0,, ahk_id %hSci%
	return ErrorLevel
}
Sci_GetCurLine(ByRef uLine) {
	;https://autohotkey.com/board/topic/38186-tillagoto-go-to-functions-labels-hks-in-your-script/page-5
    SendMessage, 2152, 0, 0,, ahk_id %hSci% ;SCI_GETFIRSTVISIBLELINE
    uLine := ErrorLevel
    SendMessage 2008, 0, 0,, ahk_id %hSci% ;SCI_GETCURRENTPOS
    uLine += ErrorLevel << 16
}
Sci_GetCurPos() {
	; Get the current position. SCI_GETCURRENTPOS
	SendMessage, 2008, 0, 0,, ahk_id %hSci%
	return ErrorLevel
}
Sci_GetFirstVisibleLine(line) {																											
    	
	 ;--Get the first visible line
    SendMessage, 2152, 0, 0,, ahk_id %hSci%
    
    If (ErrorLevel < line - 1) {
        
        ;Get the number of lines on screen. SCI_LINESONSCREEN
        SendMessage, 2370, 0, 0,, ahk_id %hSci%
        
        ;Go to the line wanted + lines on screen. SCI_GOTOLINE
        ;SendMessage, 2024, line - 1 + ErrorLevel, 0,, ahk_id %hSci%
    }
    
    SendMessage, 2024, line - 1, 0,, ahk_id %hSci%
}
Sci_GetLineEndPosition(line) {
    SendMessage % SCI_GETLINEENDPOSITION, % line - 1, 0,, ahk_id %hSci%
    Return ErrorLevel
}
Sci_GetLineState(line) {
	SCI_GETLINESTATE:=2093
    SendMessage % SCI_GetlineState, % line, 0,, ahk_id %hSci%
    Return ErrorLevel 
}
Sci_GetMarker(line) {
	SCI_MARKERGET:=2046
    SendMessage % SCI_MARKERGET, % line, 0,, ahk_id %hSci%
    Return ErrorLevel 
}
Sci_GetSelection() {	
	
	;Get length. SCI_GETSELTEXT
	SendMessage, 2161, 0, 0,, ahk_id %hSci%
	iLength := ErrorLevel + 1
	
	;Check if the line is empty
	if iLength = 1
		return
	
	; Open remote buffer
	RemoteBuf_Open(hBuf, hSci, iLength)
	
	; Fill buffer. SCI_GETSELTEXT
	SendMessage, 2161, 0, RemoteBuf_Get(hBuf),, ahk_id %hSci%
	
	; Prep var
	VarSetCapacity(sText, iLength)
	RemoteBuf_Read(hBuf, sText, iLength)
	
	; Done
	RemoteBuf_Close(hBuf)
	return StrGet(&sText, "CP" Sci_GetCP())
}
Sci_GetLine(Line) {
	
	; Retrieve line length. SCI_LINELENGTH
	SendMessage, 2350, % Line - 1, 0,, ahk_id %hSci%
	iLength := ErrorLevel
	
	; Open remote buffer (add 1 for 0 at the end of the string)
	RemoteBuf_Open(hBuf, hSci, iLength + 1)
	
	; Fill buffer with text. SCI_GETLINE
	SendMessage, 2153, % Line - 1, RemoteBuf_Get(hBuf),, ahk_id %hSci%
	
	; Read buffer
	VarSetCapacity(sText, iLength)
	RemoteBuf_Read(hBuf, sText, iLength + 1)
	
	; We're done with the remote buffer
	RemoteBuf_Close(hBuf)
	
	; Trim off ending characters & return
	return Trim(StrGet(&sText, "CP" Sci_GetCP()), "`r`n")
}
Sci_GetText() {	
	; Retrieve text length. SCI_GETLENGTH
	SendMessage, 2006, 0, 0,, ahk_id %hSci%
	iLength := ErrorLevel
	
	; Open remote buffer (add 1 for 0 at the end of the string)
	RemoteBuf_Open(hBuf, hSci, iLength + 1)
	
	; Fill buffer with text. SCI_GETTEXT
	SendMessage, 2182, iLength + 1, RemoteBuf_Get(hBuf),, ahk_id %hSci%
	
	; Read buffer
	VarSetCapacity(sText, iLength)
	RemoteBuf_Read(hBuf, sText, iLength + 1)
	
	; We're done with the remote buffer
	RemoteBuf_Close(hBuf)
	return sText
	;return StrGet(&sText, "CP" Sci_GetCP(hSci))
}
Sci_LineIsVisible(line) {
	SCI_GETLINEVISIBLE:=2228
    SendMessage % SCI_GetlineVisible, 0, 0,, ahk_id %hSci%
    Return ErrorLevel 
}

;get and set position of caret
Sci_CurrentLine() {
    SendMessage 2166, Sci_GetCurPos(), 0,, ahk_id %hSci%
    Return ErrorLevel + 1
}
Sci_GotoLine(line) {                                                             		;GotoLine moves the caret to column 0 in this line 
    SendMessage % Sci_GotoLine, % line - 1, 0,, ahk_id %hSci%
}
Sci_GotoLineEnd(line) {                                                      		;moves caret to the end of line
	Sci_GotoLine(line)
    SendMessage % Sci_LineEnd, 0, 0,, ahk_id %hSci%
}
Sci_GotoLineDown(line, downLines=1) {									;gotoLine and go one or more lines down, prevents accidental unfolding of code, it returns the current line
	
	/*		DESCRIPTION of Sci_GotoLineAndDown()

			Link:					none
			Author:			Ixiko
			Date:				03.11.2018
			for:					AHK_L V1
			Description:		in case of folded lines a goto to the next line will jump inside the folding.
									This function moves the caret without touching the folding. Folded code for example begins at line 100 and ends at line 173.
									Line 101 to 173 are invisible. With a simulated key {Down} Scite will go from line 100 to line 174.
									
	*/
	
	Sci_GotoLine(line)
	Loop, % downLines
			Sci_LineDown()
	return Sci_CurrentLine()
}
Sci_GotoPos(pos) {
	SendMessage % SCI_GotoPos, % pos, 0,, ahk_id %hSci%
}
Sci_LineDown() {
	SendMessage % SCI_LINEDOWN, 0, 0,, ahk_id %hSci%
}
Sci_LineFromPos(pos) {
    
	;from TillaGoto
	Global
    ;SCI_LINEFROMPOSITION
    SendMessage 2166, pos - 1, 0,, ahk_id %hSci%
    Return ErrorLevel + 1
}
Sci_LineUp() {
	SendMessage % SCI_LINEUP, 0, 0,, ahk_id %hSci%
}
Sci_PosFromLine(line) {
    SendMessage % SCI_PosFromLine, % line, 0,, ahk_id %hSci%
    Return ErrorLevel
}
Sci_SetCurLine(ByRef uLine) {
	; https://autohotkey.com/board/topic/38186-tillagoto-go-to-functions-labels-hks-in-your-script/page-5
    SendMessage, 2025, uLine >> 16, 0,, ahk_id %hSci% ;SCI_GOTOPOS
    SendMessage, 2152, 0, 0,, ahk_id %hSci% ;SCI_GETFIRSTVISIBLELINE
    SendMessage, 2168, 0, (uLine & 0xFFFF) - ErrorLevel,, ahk_id %hSci% ;SCI_LINESCROLL
}
Sci_SetCurPos(pos) {
	; Set the current position. SCI_GOTOPOS
	SendMessage, 2025, pos, 0,, ahk_id %hSci%
	; Ensure the caret is visible. SCI_SCROLLCARET
	;SendMessage, 2169, 0, 0,, ahk_id %hSci%
}

;folding
Sci_ContractedFoldNext(line) {
    SendMessage, 2618, %line%, 0,, ahk_id %hSci%
	return (ErrorLevel + 1)
}
Sci_GetFoldExpanded(line) {
    SendMessage, 2230, %line%, 0,, ahk_id %hSci%
	return (ErrorLevel & 0x0FFF)
}
Sci_GetFoldLevel(line) {
    SendMessage, 2223, %line%, 0,, ahk_id %hSci%
	return ( (ErrorLevel & 0x0FFF) - 1024)
}
Sci_GetFoldParent(line) {
    SendMessage, 2225, %line%, 0,, ahk_id %hSci%
	foldParent:=(ErrorLevel & 0x0FFF) + 1
	return (foldParent=4096) ? 0 : foldParent 
}
Sci_GetLastChild(line) {
	;? this is working correct? I don't know!
    SendMessage, 2224, %line%, 0,, ahk_id %hSci%
	return ErrorLevel
}
Sci_ShowLine(line) {																											
    
	;from TillaGoto
	Global
	 ;--Get the first visible line
    SendMessage, 2152, 0, 0,, ahk_id %hSci%
    
    If (ErrorLevel < line - 1) {
        
        ;Get the number of lines on screen. SCI_LINESONSCREEN
        SendMessage, 2370, 0, 0,, ahk_id %hSci%
        
        ;Go to the line wanted + lines on screen. SCI_GOTOLINE
        SendMessage, 2024, % line - 1 + ErrorLevel, 0,, ahk_id %hSci%
    }
    
    SendMessage, 2024, % line - 1, 0,, ahk_id %hSci%
}

;add, change, delete text
Sci_ClearLine(line) {																		;empty's the given line, doesn't delete the whole line!
	Sci_GotoLine(line)
	endpos:= Sci_GetLineEndPosition(line)
	Sci_SetAnchor(endpos)
	Sci_DeleteBack(2)
}
Sci_DeleteBack(option:= 1) {                                                   	;deletes back with two options 1= one DeleteBack, 2= DeleteBackNotLine
	If (option=1)
		SendMessage % SCI_DeleteBack, 0, 0,, ahk_id %hSci%
	else if (option=2)
		SendMessage % SCI_DeleteBackNotLine, 0, 0,, ahk_id %hSci%
}
Sci_InsertText(sText, pos := -1) {
	
	; Prepare a local buffer for conversion
	sNewLen := StrPut(sText, "CP" (cp := Sci_GetCP()))
	VarSetCapacity(sTextCnv, sNewLen)
	
	; Open remote buffer (add 1 for 0 at the end of the string)
	RemoteBuf_Open(hBuf, hSci, sNewLen + 1)
	
	; Convert the text to the destination codepage
	StrPut(sText, &sTextCnv, "CP" cp)
	RemoteBuf_Write(hBuf, sTextCnv, sNewLen + 1)
	
	; Call Scintilla to insert the text. SCI_INSERTTEXT
	SendMessage, 2003, pos, RemoteBuf_Get(hBuf),, ahk_id %hSci%
	
	; Move the caret to the end of the insertion
	Sci_SetCurPos(Sci_GetCurPos() + sNewLen)
	
	; Done
	RemoteBuf_Close(hBuf)
}  

;selection
Sci_ClearSelections() {
    SendMessage % SCI_CLEARSELECTIONS, 0, 0,, ahk_id %hSci%
}
Sci_SelectWholeLine(line) {															;set selection to the whole line
	Sci_GotoLine(line)
	endpos:= Sci_GetLineEndPosition(line)
	Sci_SetAnchor(endpos)
}
Sci_SetAnchor(pos) {
    SendMessage % SCI_SetAnchor, % pos, 0,, ahk_id %hSci%
}

;others
Sci_CheckTextClick(x, y) {
	
    Local checkPos, checkline, checklinetext, checki
    
    ;SCI_checkPosITIONFROMPOINTCLOSE
    SendMessage, 2023, x, y,, ahk_id %hSci%
    checkPos := ErrorLevel
    
    ;Check for error
    If (checkPos = -1)
        Return False
    Else {
        
        ;SCI_checklineFROMcheckPosITION
        SendMessage, 2166, checkPos, 0,, ahk_id %hSci%
        checkline := ErrorLevel
        
        ;SCI_checkPosITIONFROMcheckline
        SendMessage, 2167, checkline, 0,, ahk_id %hSci%
        checkPos -= ErrorLevel
        
        ;Get checkline text
        checklinetext := Sci_GetLine(checkline)
        
        ;Trim after the first illegal character
        checki := RegExMatch(checklinetext, "[^a-zA-Z0-9#_@\$\?\[\]]", "", checkPos + 1)
        If checki
            StringLeft, checklinetext, checklinetext, checki - 1
        
        ;Trim before the first illegal character
        ;i := RegExMatch(StringReverse(checklinetext), "[^a-zA-Z0-9#_@\$\?\[\]]", "", StrLen(checklinetext) - checkPos + 1)   ################## Problem hier - keine entsprechende Funktion
        If i
            StringTrimLeft, checklinetext, checklinetext, StrLen(checklinetext) - checki + 1
        
        ;Check if it's a clean match
        checklinetext .= "()"
        Loop %sFuncs0% {
            If (checklinetext = sFuncs%A_Index%) {
                Sci_ShowLine(sFuncs%A_Index%_checkline)
                Return True
            }
        }
        
        StringTrimRight, checklinetext, checklinetext, 2
        checklinetext .= ":"
        Loop %sLabels0% {
            If (checklinetext = sLabels%A_Index%) {
                Sci_ShowLine(sLabels%A_Index%_checkline)
                Return True
            }
        }
    }
    
    Return False
}
Sci_LineHistory(bForward, iRecordMode = 0) {
	; https://autohotkey.com/board/topic/38186-tillagoto-go-to-functions-labels-hks-in-your-script/page-5
    Static
    Static iCurLine := 1, iLines0 := 0
    
    ;Check if we just need to record
    If (iRecordMode = 1)    ;Record current line
        Sci_GetCurLine(iLines%iCurLine%)
    Else If (iRecordMode = 2) { ;Record to the next line
        
        iCurLine += 1
        Sci_GetCurLine(iLines%iCurLine%)
        
        ;Set as the new limit
        iLines0 := iCurLine
        
    } Else If bForward {  ;Forward
        
        ;Check if it is possible
        If (iCurLine = iLines0)
            Return
        
        ;Record the line we're on now
        Sci_GetCurLine(iLines%iCurLine%)
        
        ;Show the next line
        iCurLine += 1
        Sci_SetCurLine(iLines%iCurLine%)
        
    } Else {    ;Backward
        
        ;Check if it is possible
        If (iCurLine = 1)
            Return
        
        ;Record the line we're on now
        Sci_GetCurLine(iLines%iCurLine%)
        
        ;Show the previous line
        iCurLine -=1
        Sci_SetCurLine(iLines%iCurLine%)
    }
}
Sci_Send(hwnd, msg:=0, wParam:=0, lParam:=0) {
	
	;https://github.com/RaptorX/scintilla-wrapper/blob/master/SCI.ahk
	/*
			Function : __sendEditor
			Posts the messages used to modify the control's behaviour.
			*This is an internal function and it is not needed in normal situations. Please use the scintilla object to call all functions.
			They call this function automatically*
			Parameters:
			__sendEditor(hwnd, msg, [wParam, lParam])
			hwnd    -   The hwnd of the control that you want to operate on. Useful for when you have more than 1
						Scintilla components in the same script. The wrapper will remember the last used hwnd,
						so you can specify it once and only specify it again when you want to operate on a different
						component.
						*Note: This is converted internally by the wrapper from the object calling method. It is recommended that you dont use this function.*
			msg     -   The message to be posted, full list can be found here:
						<http://www.scintilla.org/ScintillaDoc.html>
			wParam  -   wParam for the message
			lParam  -   lParam for the message
			Returns:
			Status code of the DllCall performed.
			Examples:
			(Start Code)
			__sendEditor(hSci1, "SCI_SETMARGINWIDTHN",0,40)  ; Set the margin 0 to 40px on the first component.
			__sendEditor(0, "SCI_SETWRAPMODE",1,0)           ; Set wrap mode to true on the last used component.
			__sendEditor(hSci2, "SCI_SETMARGINWIDTHN",0,50)  ; Set the margin 0 to 50px on the second component.
			(End)
	*/
	
    static

    hwnd := !hwnd ? oldhwnd : hwnd, oldhwnd := hwnd, msg := !(msg+0) ? "SCI_" msg : msg

    if !df_%hwnd%
	{
        SendMessage, % SCI_GETDIRECTFUNCTION ,0,0,,ahk_id %hwnd%
        df_%hwnd% := ErrorLevel
        SendMessage, % SCI_GETDIRECTPOINTER ,0,0,,ahk_id %hwnd%
        dp_%hwnd% := ErrorLevel
	}

    if !msg && !wParam && !lParam   ; called only with the hwnd param from SCI_Add
        return                      ; Exit because we did what we needed to do already.

    ; The fast way to control Scintilla
    return DllCall(df_%hwnd%            ; DIRECT FUNCTION
                  ,"UInt" ,dp_%hwnd%    ; DIRECT POINTER
                  ,"UInt" ,!(msg+0) ? %msg% : msg
                  ,"Int"  ,inStr(wParam, "-") ? wParam : (%wParam%+0 ? %wParam% : wParam) ; handles negative ints
                  ,"Int"  ,%lParam%+0 ? %lParam% : lParam)
}


/* more Scintilla Sendmessages and code

		SendMessage, SCI_GETDIRECTFUNCTION,0,0,,ahk_id %hwnd%
			df_%hwnd% := ErrorLevel
        SendMessage, SCI_GETDIRECTPOINTER,0,0,,ahk_id %hwnd%
			dp_%hwnd% := ErrorLevel
			
		SCI_Send("SCI_SETLEXERLANGUAGE",sc,"Int",0,"AStr","ahk1") ;language = ahk1 (from philho's lexer)

		loop,3
		SCI_Send("SCI_SETKEYWORDS",sc,"Int",A_Index-1,"AStr",keywords(a_index))

		loop,20
		SCI_Send("SCI_STYLESETFORE",sc,"Int",A_Index-1,"Int",dcolors(a_index))

		SCI_Send("SCI_SETTEXT",sc,,,"AStr",FileOpen(A_ScriptFullPath,"r").Read())	
*/
