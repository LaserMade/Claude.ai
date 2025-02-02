﻿; Title:
; Link:   	https://www.autohotkey.com/boards/viewtopic.php?p=379114#p379114
; Author:	Tigerlily
; Date:
; for:     	AHK_L

/*


*/

ChangeBackgroundMode(radio, *){

    static userBg := DllCall("user32\GetSysColor", "int", 1) ; Get user's desktop background color
    static backgroundModes := Map(
    "Normal"  , Map(0x000000, 0xC8C8C8, 1, userBg,   2, 0xD1B499, 3, 0xDBCDBF, 4, 0xF0F0F0, 5, 0xFFFFFF, 6, 0x646464, 7, 0x000000, 8, 0x000000, 9, 0x000000, 10, 0xB4B4B4, 11, 0xFCF7F4, 12, 0xABABAB, 13, 0xD77800, 14, 0xFFFFFF, 15, 0xF0F0F0, 16, 0xA0A0A0, 17, 0x6D6D6D, 18, 0x000000, 19, 0x000000, 20, 0xFFFFFF, 21, 0x696969, 22, 0xE3E3E3, 23, 0x000000, 24, 0xE1FFFF, 26, 0xCC6600, 27, 0xEAD1B9, 28, 0xF2E4D7, 29, 0xD77800, 30, 0xF0F0F0),
    "Morning" , Map(0x000000, 0xC7EDCC, 1, userBg,   2, 0xD1B499, 3, 0xC7EDCC, 4, 0xC7EDCC, 5, 0xC7EDCC, 6, 0x646464, 7, 0x000000, 8, 0x000000, 9, 0x000000, 10, 0xB4B4B4, 11, 0xFCF7F4, 12, 0xC7EDCC, 13, 0xD77800, 14, 0xFFFFFF, 15, 0xC7EDCC, 16, 0xA0A0A0, 17, 0x6D6D6D, 18, 0x000000, 19, 0x000000, 20, 0xFFFFFF, 21, 0x696969, 22, 0xE3E3E3, 23, 0x000000, 24, 0xE1FFFF, 26, 0xCC6600, 27, 0xEAD1B9, 28, 0xF2E4D7, 29, 0xD77800, 30, 0xF0F0F0),
    "Day"	  , Map(0x000000, 0xABABAB, 1, userBg,   2, 0xD1B499, 3, 0xABABAB, 4, 0xABABAB, 5, 0xABABAB, 6, 0x646464, 7, 0x000000, 8, 0x000000, 9, 0x000000, 10, 0xB4B4B4, 11, 0xFCF7F4, 12, 0xABABAB, 13, 0xD77800, 14, 0xFFFFFF, 15, 0xABABAB, 16, 0xA0A0A0, 17, 0x6D6D6D, 18, 0x000000, 19, 0x000000, 20, 0xFFFFFF, 21, 0x696969, 22, 0xE3E3E3, 23, 0x000000, 24, 0xE1FFFF, 26, 0xCC6600, 27, 0xEAD1B9, 28, 0xF2E4D7, 29, 0xD77800, 30, 0xF0F0F0),
    "Night"	  , Map(0x000000, 0x000000, 1, 0x000000, 2, 0x595757, 3, 0x595757, 4, 0x595757, 5, 0x595757, 6, 0x000000, 7, 0x000000, 8, 0xC6C8C5, 9, 0xC6C8C5, 10, 0x000000, 11, 0x000000, 12, 0x595757, 13, 0x5A5A57, 14, 0xC6C8C5, 15, 0x595757, 16, 0x000000, 17, 0x808080, 18, 0xC6C8C5, 19, 0xC6C8C5, 20, 0x5A5A57, 21, 0x000000, 22, 0x5A5A57, 23, 0xC6C8C5, 24, 0x000000, 26, 0xF0B000, 27, 0x000000, 28, 0x000000, 29, 0x5A5A57, 30, 0x000000),
    "Evening" , Map(0x000000, 0x000000, 1, 0x000000, 2, 0x222223, 3, 0x222223, 4, 0x222223, 5, 0x222223, 6, 0x000000, 7, 0x000000, 8, 0xC6C8C5, 9, 0xC6C8C5, 10, 0x000000, 11, 0x000000, 12, 0x222223, 13, 0x5A5A57, 14, 0xC6C8C5, 15, 0x222223, 16, 0x000000, 17, 0x808080, 18, 0xC6C8C5, 19, 0xC6C8C5, 20, 0x5A5A57, 21, 0x000000, 22, 0x5A5A57, 23, 0xC6C8C5, 24, 0x000000, 26, 0xF0B000, 27, 0x000000, 28, 0x000000, 29, 0x5A5A57, 30, 0x000000),
    "Midnight", Map(0x000000, 0x000000, 1, 0x000000, 2, 0xC6C8C5, 3, 0x000000, 4, 0x000000, 5, 0x000000, 6, 0x000000, 7, 0x000000, 8, 0xC6C8C5, 9, 0xC6C8C5, 10, 0x000000, 11, 0x000000, 12, 0x000000, 13, 0x5A5A57, 14, 0xC6C8C5, 15, 0x000000, 16, 0x000000, 17, 0x808080, 18, 0xC6C8C5, 19, 0xC6C8C5, 20, 0x000000, 21, 0x000000, 22, 0x000000, 23, 0xC6C8C5, 24, 0x000000, 26, 0xF0B000, 27, 0x000000, 28, 0x000000, 29, 0x5A5A57, 30, 0x000000),
    "Twilight", Map(0x000000, 0x000000, 1, 0x000000, 2, 0x8C3230, 3, 0x000000, 4, 0x000000, 5, 0x000000, 6, 0x000000, 7, 0x000000, 8, 0x8C3230, 9, 0xC6C8C5, 10, 0x000000, 11, 0x000000, 12, 0x000000, 13, 0x080816, 14, 0xC04B48, 15, 0x000000, 16, 0x000000, 17, 0x808080, 18, 0x8C3230, 19, 0x8C3230, 20, 0x000000, 21, 0x000000, 22, 0x000000, 23, 0x8C3230, 24, 0x000000, 26, 0xC04B48, 27, 0x000000, 28, 0x000000, 29, 0x5A5A57, 30, 0x000000))

    for displayElement, color in backgroundModes[radio.Name]
        try DllCall("user32\SetSysColors", "Int", 1, "IntP", displayElement, "UIntP", color)
}