RasClearConnectionStatistics(hRasConn) => DllCall('Rasapi32\RasClearConnectionStatistics', 'ptr', hRasConn, 'uint')
RasClearLinkStatistics(hRasConn, dwSubEntry) => DllCall('Rasapi32\RasClearLinkStatistics', 'ptr', hRasConn, 'uint', dwSubEntry, 'uint')
RasConnectionNotification(hrasconn, hEvent, dwFlags) => DllCall('Rasapi32\RasConnectionNotification', 'ptr', hrasconn, 'ptr', hEvent, 'uint', dwFlags, 'uint')
RasCreatePhonebookEntry(hwnd, lpszPhonebook) => DllCall('Rasapi32\RasCreatePhonebookEntry', 'ptr', hwnd, 'str', lpszPhonebook, 'uint')
RasDeleteEntry(lpszPhonebook, lpszEntry) => DllCall('Rasapi32\RasDeleteEntry', 'str', lpszPhonebook, 'str', lpszEntry, 'uint')
RasDeleteSubEntry(lpszPhonebook, lpszEntry, dwSubEntryId) => DllCall('Rasapi32\RasDeleteSubEntry', 'str', lpszPhonebook, 'str', lpszEntry, 'uint', dwSubEntryId, 'uint')
RasDial(lpRasDialExtensions, lpszPhonebook, lpRasDialParams, dwNotifierType, lpvNotifier, lphRasConn) => DllCall('Rasapi32\RasDial', 'ptr', lpRasDialExtensions, 'str', lpszPhonebook, 'ptr', lpRasDialParams, 'uint', dwNotifierType, 'ptr', lpvNotifier, 'ptr', lphRasConn, 'uint')
RasEditPhonebookEntry(hwnd, lpszPhonebook, lpszEntryName) => DllCall('Rasapi32\RasEditPhonebookEntry', 'ptr', hwnd, 'str', lpszPhonebook, 'str', lpszEntryName, 'uint')
RasEnumAutodialAddresses(lppAddresses, lpdwcbAddresses, lpdwcAddresses) => DllCall('Rasapi32\RasEnumAutodialAddresses', 'ptr', lppAddresses, 'ptr', lpdwcbAddresses, 'ptr', lpdwcAddresses, 'uint')
RasEnumConnections(lprasconn, lpcb, lpcConnections) => DllCall('Rasapi32\RasEnumConnections', 'ptr', lprasconn, 'ptr', lpcb, 'ptr', lpcConnections, 'uint')
RasEnumDevices(lpRasDevInfo, lpcb, lpcDevices) => DllCall('Rasapi32\RasEnumDevices', 'ptr', lpRasDevInfo, 'ptr', lpcb, 'ptr', lpcDevices, 'uint')
RasEnumEntries(reserved, lpszPhonebook, lprasentryname, lpcb, lpcEntries) => DllCall('Rasapi32\RasEnumEntries', 'str', reserved, 'str', lpszPhonebook, 'ptr', lprasentryname, 'ptr', lpcb, 'ptr', lpcEntries, 'uint')
RasFreeEapUserIdentity(pRasEapUserIdentity) => DllCall('Rasapi32\RasFreeEapUserIdentity', 'ptr', pRasEapUserIdentity, 'int')
RasGetAutodialAddress(lpszAddress, lpdwReserved, lpAutoDialEntries, lpdwcbAutoDialEntries, lpdwcAutoDialEntries) => DllCall('Rasapi32\RasGetAutodialAddress', 'str', lpszAddress, 'ptr', lpdwReserved, 'ptr', lpAutoDialEntries, 'ptr', lpdwcbAutoDialEntries, 'ptr', lpdwcAutoDialEntries, 'uint')
RasGetAutodialEnable(dwDialingLocation, lpfEnabled) => DllCall('Rasapi32\RasGetAutodialEnable', 'uint', dwDialingLocation, 'ptr', lpfEnabled, 'uint')
RasGetAutodialParam(dwKey, lpvValue, lpdwcbValue) => DllCall('Rasapi32\RasGetAutodialParam', 'uint', dwKey, 'ptr', lpvValue, 'ptr', lpdwcbValue, 'uint')
RasGetConnectStatus(hrasconn, lprasconnstatus) => DllCall('Rasapi32\RasGetConnectStatus', 'ptr', hrasconn, 'ptr', lprasconnstatus, 'uint')
RasGetConnectionStatistics(hRasConn, lpStatistics) => DllCall('Rasapi32\RasGetConnectionStatistics', 'ptr', hRasConn, 'ptr', lpStatistics, 'uint')
RasGetCountryInfo(lpRasCtryInfo, lpdwSize) => DllCall('Rasapi32\RasGetCountryInfo', 'ptr', lpRasCtryInfo, 'ptr', lpdwSize, 'uint')
RasGetCredentials(lpszPhonebook, lpszEntry, lpCredentials) => DllCall('Rasapi32\RasGetCredentials', 'str', lpszPhonebook, 'str', lpszEntry, 'ptr', lpCredentials, 'uint')
RasGetCustomAuthData(pszPhonebook, pszEntry, &pbCustomAuthData, &pdwSizeofCustomAuthData) => DllCall('Rasapi32\RasGetCustomAuthData', 'wstr', pszPhonebook, 'wstr', pszEntry, 'uchar*', &pbCustomAuthData, 'uint*', &pdwSizeofCustomAuthData, 'uint')
RasGetEapUserData(hToken, pszPhonebook, pszEntry, &pbEapData, &pdwSizeofEapData) => DllCall('Rasapi32\RasGetEapUserData', 'ptr', hToken, 'str', pszPhonebook, 'str', pszEntry, 'uchar*', &pbEapData, 'uint*', &pdwSizeofEapData, 'uint')
RasGetEapUserIdentity(pszPhonebook, pszEntry, dwFlags, hwnd, ppRasEapUserIdentity) => DllCall('Rasapi32\RasGetEapUserIdentity', 'astr', pszPhonebook, 'astr', pszEntry, 'uint', dwFlags, 'ptr', hwnd, 'ptr', ppRasEapUserIdentity, 'uint')
RasGetEntryDialParams(lpszPhonebook, lprasdialparams, lpfPassword) => DllCall('Rasapi32\RasGetEntryDialParams', 'str', lpszPhonebook, 'ptr', lprasdialparams, 'ptr', lpfPassword, 'uint')
RasGetEntryProperties(lpszPhonebook, lpszEntry, lpRasEntry, lpdwEntryInfoSize, lpbDeviceInfo, lpdwDeviceInfoSize) => DllCall('Rasapi32\RasGetEntryProperties', 'str', lpszPhonebook, 'str', lpszEntry, 'ptr', lpRasEntry, 'ptr', lpdwEntryInfoSize, 'ptr', lpbDeviceInfo, 'ptr', lpdwDeviceInfoSize, 'uint')
RasGetErrorString(uErrorValue, lpszErrorString, cBufSize) => DllCall('Rasapi32\RasGetErrorString', 'uint', uErrorValue, 'str', lpszErrorString, 'uint', cBufSize, 'uint')
RasGetLinkStatistics(hRasConn, dwSubEntry, lpStatistics) => DllCall('Rasapi32\RasGetLinkStatistics', 'ptr', hRasConn, 'uint', dwSubEntry, 'ptr', lpStatistics, 'uint')
RasGetProjectionInfo(hrasconn, rasprojection, lpprojection, lpcb) => DllCall('Rasapi32\RasGetProjectionInfo', 'ptr', hrasconn, 'int', rasprojection, 'ptr', lpprojection, 'ptr', lpcb, 'uint')
RasGetProjectionInfoEx(Hrasconn, pRasProjection, lpdwSize) => DllCall('Rasapi32\RasGetProjectionInfoEx', 'ptr', Hrasconn, 'ptr', pRasProjection, 'ptr', lpdwSize, 'uint')
RasGetSubEntryHandle(hRasConn, dwSubEntry, lphRasConn) => DllCall('Rasapi32\RasGetSubEntryHandle', 'ptr', hRasConn, 'uint', dwSubEntry, 'ptr', lphRasConn, 'uint')
RasGetSubEntryProperties(lpszPhonebook, lpszEntry, dwSubEntry, lpRasSubEntry, lpdwcb, lpbDeviceConfig, lpcbDeviceConfig) => DllCall('Rasapi32\RasGetSubEntryProperties', 'str', lpszPhonebook, 'str', lpszEntry, 'uint', dwSubEntry, 'ptr', lpRasSubEntry, 'ptr', lpdwcb, 'ptr', lpbDeviceConfig, 'ptr', lpcbDeviceConfig, 'uint')
RasHangUp(hRasConn) => DllCall('Rasapi32\RasHangUp', 'ptr', hRasConn, 'uint')
RasInvokeEapUI(hRasConn, dwSubEntry, lpExtensions, hwnd) => DllCall('Rasapi32\RasInvokeEapUI', 'ptr', hRasConn, 'uint', dwSubEntry, 'ptr', lpExtensions, 'ptr', hwnd, 'uint')
RasRenameEntry(lpszPhonebook, lpszOldEntry, lpszNewEntry) => DllCall('Rasapi32\RasRenameEntry', 'str', lpszPhonebook, 'str', lpszOldEntry, 'str', lpszNewEntry, 'uint')
RasSetAutodialAddress(lpszAddress, dwReserved, lpAutoDialEntries, dwcbAutoDialEntries, dwcAutoDialEntries) => DllCall('Rasapi32\RasSetAutodialAddress', 'str', lpszAddress, 'uint', dwReserved, 'ptr', lpAutoDialEntries, 'uint', dwcbAutoDialEntries, 'uint', dwcAutoDialEntries, 'uint')
RasSetAutodialEnable(dwDialingLocation, fEnabled) => DllCall('Rasapi32\RasSetAutodialEnable', 'uint', dwDialingLocation, 'int', fEnabled, 'uint')
RasSetAutodialParam(dwKey, lpvValue, dwcbValue) => DllCall('Rasapi32\RasSetAutodialParam', 'uint', dwKey, 'ptr', lpvValue, 'uint', dwcbValue, 'uint')
RasSetCredentials(lpszPhonebook, lpszEntry, lpCredentials, fClearCredentials) => DllCall('Rasapi32\RasSetCredentials', 'str', lpszPhonebook, 'str', lpszEntry, 'ptr', lpCredentials, 'int', fClearCredentials, 'uint')
RasSetCustomAuthData(pszPhonebook, pszEntry, &pbCustomAuthData, dwSizeofCustomAuthData) => DllCall('Rasapi32\RasSetCustomAuthData', 'wstr', pszPhonebook, 'wstr', pszEntry, 'uchar*', &pbCustomAuthData, 'uint', dwSizeofCustomAuthData, 'uint')
RasSetEapUserData(hToken, pszPhonebook, pszEntry, &pbEapData, dwSizeofEapData) => DllCall('Rasapi32\RasSetEapUserData', 'ptr', hToken, 'str', pszPhonebook, 'str', pszEntry, 'uchar*', &pbEapData, 'uint', dwSizeofEapData, 'uint')
RasSetEntryDialParams(lpszPhonebook, lprasdialparams, fRemovePassword) => DllCall('Rasapi32\RasSetEntryDialParams', 'str', lpszPhonebook, 'ptr', lprasdialparams, 'int', fRemovePassword, 'uint')
RasSetEntryProperties(lpszPhonebook, lpszEntry, lpRasEntry, dwEntryInfoSize, lpbDeviceInfo, dwDeviceInfoSize) => DllCall('Rasapi32\RasSetEntryProperties', 'str', lpszPhonebook, 'str', lpszEntry, 'ptr', lpRasEntry, 'uint', dwEntryInfoSize, 'ptr', lpbDeviceInfo, 'uint', dwDeviceInfoSize, 'uint')
RasSetSubEntryProperties(lpszPhonebook, lpszEntry, dwSubEntry, lpRasSubEntry, dwcbRasSubEntry, lpbDeviceConfig, dwcbDeviceConfig) => DllCall('Rasapi32\RasSetSubEntryProperties', 'str', lpszPhonebook, 'str', lpszEntry, 'uint', dwSubEntry, 'ptr', lpRasSubEntry, 'uint', dwcbRasSubEntry, 'ptr', lpbDeviceConfig, 'uint', dwcbDeviceConfig, 'uint')
RasUpdateConnection(hrasconn, lprasupdateconn) => DllCall('Rasapi32\RasUpdateConnection', 'ptr', hrasconn, 'ptr', lprasupdateconn, 'uint')
RasValidateEntryName(lpszPhonebook, lpszEntry) => DllCall('Rasapi32\RasValidateEntryName', 'str', lpszPhonebook, 'str', lpszEntry, 'uint')
rasgetnapstatus(hRasConn, pNapState) => DllCall('Rasapi32\rasgetnapstatus', 'ptr', hRasConn, 'ptr', pNapState, 'uint')
