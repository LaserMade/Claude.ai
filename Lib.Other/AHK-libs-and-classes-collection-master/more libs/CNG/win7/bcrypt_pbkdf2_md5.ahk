﻿MsgBox % bcrypt_pbkdf2_md5("The quick brown fox jumps over the lazy dog", "Secret Salt")
; ==> 8191e192ab4fed8c1918f51eed10f81c



bcrypt_pbkdf2_md5(password, salt, iterations := 4096, keysize := 16)
{
    static BCRYPT_MD5_ALGORITHM        := "MD5"
    static BCRYPT_ALG_HANDLE_HMAC_FLAG := 0x00000008

    if !(hBCRYPT := DllCall("LoadLibrary", "str", "bcrypt.dll", "ptr"))
        throw Exception("Failed to load bcrypt.dll", -1)

    if (NT_STATUS := DllCall("bcrypt\BCryptOpenAlgorithmProvider", "ptr*", hAlgo, "ptr", &BCRYPT_MD5_ALGORITHM, "ptr", 0, "uint", BCRYPT_ALG_HANDLE_HMAC_FLAG) != 0)
        throw Exception("BCryptOpenAlgorithmProvider: " NT_STATUS, -1)

    VarSetCapacity(pbPass, StrPut(password, "UTF-8"), 0) && cbPass := StrPut(password, &pbPass, "UTF-8") - 1
    VarSetCapacity(pbSalt, StrPut(salt, "UTF-8"), 0) && cbSalt := StrPut(salt, &pbSalt, "UTF-8") - 1
    VarSetCapacity(pbDKey, keysize, 0)
    if (NT_STATUS := DllCall("bcrypt\BCryptDeriveKeyPBKDF2", "ptr", hAlgo, "ptr", &pbPass, "uint", cbPass, "ptr", &pbSalt, "uint", cbSalt, "int64", iterations, "ptr", &pbDKey, "uint", keysize, "uint", 0) != 0)
        throw Exception("BCryptDeriveKeyPBKDF2: " NT_STATUS, -1)

    loop % keysize
        pbkdf2 .= Format("{:02x}", NumGet(pbDKey, A_Index - 1, "uchar"))

    DllCall("bcrypt\BCryptCloseAlgorithmProvider", "ptr", hAlgo, "uint", 0)
    DllCall("FreeLibrary", "ptr", hBCRYPT)

    return pbkdf2
}