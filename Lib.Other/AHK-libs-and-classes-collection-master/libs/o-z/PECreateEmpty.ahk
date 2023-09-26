﻿; ----------------------------------------------------------------------------------------------------------------------
; Function .....: PECreateEmpty
; Description ..: Create an empty PE binary file. This dummy executable was created with Visual C++ 2010 Express, with
; ..............: all possible optimizations so that the final size is 1KB. If run, this executable will show a message
; ..............: box and return.
; Parameters ...: sFile - Path to the file to be created.
; Author .......: Cyruz - http://ciroprincipe.info
; License ......: WTFPL - http://www.wtfpl.net/txt/copying/
; Changelog ....: Jan. 12, 2015 - v0.1 - First Version.
; ----------------------------------------------------------------------------------------------------------------------
PECreateEmpty(sFile) {
    Static sDummy := "" ; Dummy executable.
    . "4d5a90000300000004000000ffff0000b8000000000000004000000000000000000000000000000000000000000000000000000000000000"
    . "00000000c00000000e1fba0e00b409cd21b8014ccd21546869732070726f6772616d2063616e6e6f742062652072756e20696e20444f5320"
    . "6d6f64652e0d0d0a240000000000000061af10dc25ce7e8f25ce7e8f25ce7e8f2cb6ed8f26ce7e8f25ce7f8f24ce7e8f4ab8d58f24ce7e8f"
    . "4ab8e38f24ce7e8f5269636825ce7e8f0000000000000000504500004c010100a4a8b2540000000000000000e00003010b010a0000020000"
    . "0000000000000000ca1000000010000000200000000040000010000000020000050001000000000005000100000000000020000000020000"
    . "00000000020000850000100000100000000010000010000000000000100000000000000000000000e4100000280000000000000000000000"
    . "000000000000000000000000000000000000000000000000101000001c000000000000000000000000000000000000000000000000000000"
    . "0000000000000000000000000000000000100000080000000000000000000000000000000000000000000000000000002e74657874000000"
    . "2e01000000100000000200000002000000000000000000000000000020000060000000000000000000000000000000000000000000000000"
    . "00000000000000001411000000000000000000000000000000000000a4a8b254000000000200000079000000501000005002000054686973"
    . "20697320612064756d6d792065786563757461626c652e0044756d6d79000000525344537702078caf1e054581291db9c1339ef103000000"
    . "3030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030303030"
    . "3030303030303030303030303030303030303030303030303030303030303030303030303030303000006a006848104000682c1040006a00"
    . "ff150010400033c040c210000c11000000000000000000002211000000100000000000000000000000000000000000000000000014110000"
    . "000000000e024d657373616765426f7841005553455233322e646c6c00000000000000000000000000000000000000000000000000000000"
    . "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    . "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    . "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    . "0000000000000000000000000000000"
    If ( !IsObject(objFile := FileOpen(sFile, "w")) )
        Return 0
    szBuf := VarSetCapacity(cBuf, StrLen(sDummy)//2)
    Loop % StrLen(sDummy)//2 ; Laszlo's MCode.
        NumPut("0x" . SubStr(sDummy, 2*A_Index-1, 2), cBuf, A_Index-1, "Char")
    objFile.RawWrite(&cBuf, szBuf)
    objFile.Close()
    Return 1
}
