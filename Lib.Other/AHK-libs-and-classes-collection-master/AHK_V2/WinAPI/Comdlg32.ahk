ChooseColor(lpcc) => DllCall('Comdlg32\ChooseColor', 'ptr', lpcc, 'int')
ChooseFont(lpcf) => DllCall('Comdlg32\ChooseFont', 'ptr', lpcf, 'int')
CommDlgExtendedError() => DllCall('Comdlg32\CommDlgExtendedError', 'uint')
FindText(lpfr) => DllCall('Comdlg32\FindText', 'ptr', lpfr, 'ptr')
GetFileTitle(lpszFile, lpszTitle, cchSize) => DllCall('Comdlg32\GetFileTitle', 'str', lpszFile, 'str', lpszTitle, 'ushort', cchSize, 'short')
GetOpenFileName(lpofn) => DllCall('Comdlg32\GetOpenFileName', 'ptr', lpofn, 'int')
GetSaveFileName(lpofn) => DllCall('Comdlg32\GetSaveFileName', 'ptr', lpofn, 'int')
PageSetupDlg(lppsd) => DllCall('Comdlg32\PageSetupDlg', 'ptr', lppsd, 'int')
PrintDlg(lppd) => DllCall('Comdlg32\PrintDlg', 'ptr', lppd, 'int')
PrintDlgEx(lppd) => DllCall('Comdlg32\PrintDlgEx', 'ptr', lppd, 'int')
ReplaceText(lpfr) => DllCall('Comdlg32\ReplaceText', 'ptr', lpfr, 'ptr')
