BindMoniker(pmk, grfOpt, iidResult, ppvResult) => DllCall('Ole32\BindMoniker', 'ptr', pmk, 'uint', grfOpt, 'ptr', iidResult, 'ptr', ppvResult, 'int')
CLSIDFromProgID(lpszProgID, lpclsid) => DllCall('Ole32\CLSIDFromProgID', 'str', lpszProgID, 'ptr', lpclsid, 'int')
CLSIDFromProgIDEx(lpszProgID, lpclsid) => DllCall('Ole32\CLSIDFromProgIDEx', 'str', lpszProgID, 'ptr', lpclsid, 'int')
CLSIDFromString(lpsz, pclsid) => DllCall('Ole32\CLSIDFromString', 'str', lpsz, 'ptr', pclsid, 'int')
CoAddRefServerProcess() => DllCall('Ole32\CoAddRefServerProcess', 'uint')
CoAllowSetForegroundWindow(pUnk, lpvReserved) => DllCall('Ole32\CoAllowSetForegroundWindow', 'ptr', pUnk, 'ptr', lpvReserved, 'int')
CoCancelCall(dwThreadId, ulTimeout) => DllCall('Ole32\CoCancelCall', 'uint', dwThreadId, 'uint', ulTimeout, 'int')
CoCopyProxy(pProxy, ppCopy) => DllCall('Ole32\CoCopyProxy', 'ptr', pProxy, 'ptr', ppCopy, 'int')
CoCreateFreeThreadedMarshaler(punkOuter, ppunkMarshal) => DllCall('Ole32\CoCreateFreeThreadedMarshaler', 'ptr', punkOuter, 'ptr', ppunkMarshal, 'int')
CoCreateGuid(pguid) => DllCall('Ole32\CoCreateGuid', 'ptr', pguid, 'int')
CoCreateInstance(rclsid, pUnkOuter, dwClsContext, riid, ppv) => DllCall('Ole32\CoCreateInstance', 'ptr', rclsid, 'ptr', pUnkOuter, 'uint', dwClsContext, 'ptr', riid, 'ptr', ppv, 'int')
CoCreateInstanceEx(rclsid, punkOuter, dwClsCtx, pServerInfo, dwCount, pResults) => DllCall('Ole32\CoCreateInstanceEx', 'ptr', rclsid, 'ptr', punkOuter, 'uint', dwClsCtx, 'ptr', pServerInfo, 'uint', dwCount, 'ptr', pResults, 'int')
CoDisableCallCancellation(pReserved) => DllCall('Ole32\CoDisableCallCancellation', 'ptr', pReserved, 'int')
CoDisconnectContext(dwTimeout) => DllCall('Ole32\CoDisconnectContext', 'uint', dwTimeout, 'int')
CoDisconnectObject(pUnk, dwReserved) => DllCall('Ole32\CoDisconnectObject', 'ptr', pUnk, 'uint', dwReserved, 'int')
CoDosDateTimeToFileTime(nDosDate, nDosTime, lpFileTime) => DllCall('Ole32\CoDosDateTimeToFileTime', 'ushort', nDosDate, 'ushort', nDosTime, 'ptr', lpFileTime, 'int')
CoEnableCallCancellation(pReserved) => DllCall('Ole32\CoEnableCallCancellation', 'ptr', pReserved, 'int')
CoFileTimeNow(lpFileTime) => DllCall('Ole32\CoFileTimeNow', 'ptr', lpFileTime, 'int')
CoFileTimeToDosDateTime(lpFileTime, lpDosDate, lpDosTime) => DllCall('Ole32\CoFileTimeToDosDateTime', 'ptr', lpFileTime, 'ptr', lpDosDate, 'ptr', lpDosTime, 'int')
CoFreeAllLibraries() => DllCall('Ole32\CoFreeAllLibraries', 'int')
CoFreeLibrary(hInst) => DllCall('Ole32\CoFreeLibrary', 'ptr', hInst, 'int')
CoFreeUnusedLibraries() => DllCall('Ole32\CoFreeUnusedLibraries', 'int')
CoFreeUnusedLibrariesEx(dwUnloadDelay, dwReserved) => DllCall('Ole32\CoFreeUnusedLibrariesEx', 'uint', dwUnloadDelay, 'uint', dwReserved, 'int')
CoGetApartmentType(pAptType, pAptQualifier) => DllCall('Ole32\CoGetApartmentType', 'ptr', pAptType, 'ptr', pAptQualifier, 'int')
CoGetCallContext(riid, ppInterface) => DllCall('Ole32\CoGetCallContext', 'ptr', riid, 'ptr', ppInterface, 'int')
CoGetCallerTID(lpdwTID) => DllCall('Ole32\CoGetCallerTID', 'ptr', lpdwTID, 'int')
CoGetCancelObject(dwThreadId, iid, ppUnk) => DllCall('Ole32\CoGetCancelObject', 'uint', dwThreadId, 'ptr', iid, 'ptr', ppUnk, 'int')
CoGetClassObject(rclsid, dwClsContext, pServerInfo, riid, ppv) => DllCall('Ole32\CoGetClassObject', 'ptr', rclsid, 'uint', dwClsContext, 'ptr', pServerInfo, 'ptr', riid, 'ptr', ppv, 'int')
CoGetContextToken(pToken) => DllCall('Ole32\CoGetContextToken', 'uptr', pToken, 'int')
CoGetCurrentLogicalThreadId(pguid) => DllCall('Ole32\CoGetCurrentLogicalThreadId', 'ptr', pguid, 'int')
CoGetCurrentProcess() => DllCall('Ole32\CoGetCurrentProcess', 'uint')
CoGetDefaultContext(aptType, riid, ppv) => DllCall('Ole32\CoGetDefaultContext', 'int', aptType, 'ptr', riid, 'ptr', ppv, 'int')
CoGetInstanceFromFile(pServerInfo, pClsid, punkOuter, dwClsCtx, grfMode, pwszName, dwCount, pResults) => DllCall('Ole32\CoGetInstanceFromFile', 'ptr', pServerInfo, 'ptr', pClsid, 'ptr', punkOuter, 'uint', dwClsCtx, 'uint', grfMode, 'wstr', pwszName, 'uint', dwCount, 'ptr', pResults, 'int')
CoGetInstanceFromIStorage(pServerInfo, pClsid, punkOuter, dwClsCtx, pstg, dwCount, pResults) => DllCall('Ole32\CoGetInstanceFromIStorage', 'ptr', pServerInfo, 'ptr', pClsid, 'ptr', punkOuter, 'uint', dwClsCtx, 'ptr', pstg, 'uint', dwCount, 'ptr', pResults, 'int')
CoGetInterceptor(iidIntercepted, punkOuter, iid, ppv) => DllCall('Ole32\CoGetInterceptor', 'ptr', iidIntercepted, 'ptr', punkOuter, 'ptr', iid, 'ptr', ppv, 'int')
CoGetInterfaceAndReleaseStream(pStm, iid, ppv) => DllCall('Ole32\CoGetInterfaceAndReleaseStream', 'ptr', pStm, 'ptr', iid, 'ptr', ppv, 'int')
CoGetMalloc(dwMemContext, ppMalloc) => DllCall('Ole32\CoGetMalloc', 'uint', dwMemContext, 'ptr', ppMalloc, 'int')
CoGetMarshalSizeMax(&pulSize, riid, pUnk, dwDestContext, pvDestContext, mshlflags) => DllCall('Ole32\CoGetMarshalSizeMax', 'uint*', &pulSize, 'ptr', riid, 'ptr', pUnk, 'uint', dwDestContext, 'ptr', pvDestContext, 'uint', mshlflags, 'int')
CoGetObject(pszName, pBindOptions, riid, ppv) => DllCall('Ole32\CoGetObject', 'wstr', pszName, 'ptr', pBindOptions, 'ptr', riid, 'ptr', ppv, 'int')
CoGetObjectContext(riid, ppv) => DllCall('Ole32\CoGetObjectContext', 'ptr', riid, 'ptr', ppv, 'int')
CoGetPSClsid(riid, pClsid) => DllCall('Ole32\CoGetPSClsid', 'ptr', riid, 'ptr', pClsid, 'int')
CoGetStandardMarshal(riid, pUnk, dwDestContext, pvDestContext, mshlflags, ppMarshal) => DllCall('Ole32\CoGetStandardMarshal', 'ptr', riid, 'ptr', pUnk, 'uint', dwDestContext, 'ptr', pvDestContext, 'uint', mshlflags, 'ptr', ppMarshal, 'int')
CoGetStdMarshalEx(pUnkOuter, smexflags, ppUnkInner) => DllCall('Ole32\CoGetStdMarshalEx', 'ptr', pUnkOuter, 'uint', smexflags, 'ptr', ppUnkInner, 'int')
CoGetTreatAsClass(clsidOld, pClsidNew) => DllCall('Ole32\CoGetTreatAsClass', 'ptr', clsidOld, 'ptr', pClsidNew, 'int')
CoImpersonateClient() => DllCall('Ole32\CoImpersonateClient', 'int')
CoInitialize(pvReserved) => DllCall('Ole32\CoInitialize', 'ptr', pvReserved, 'int')
CoInitializeEx(pvReserved, dwCoInit) => DllCall('Ole32\CoInitializeEx', 'ptr', pvReserved, 'uint', dwCoInit, 'int')
CoInitializeSecurity(pSecDesc, cAuthSvc, asAuthSvc, pReserved1, dwAuthnLevel, dwImpLevel, pAuthList, dwCapabilities, pReserved3) => DllCall('Ole32\CoInitializeSecurity', 'ptr', pSecDesc, 'int', cAuthSvc, 'ptr', asAuthSvc, 'ptr', pReserved1, 'uint', dwAuthnLevel, 'uint', dwImpLevel, 'ptr', pAuthList, 'uint', dwCapabilities, 'ptr', pReserved3, 'int')
CoInstall(pbc, dwFlags, pClassSpec, pQuery, pszCodeBase) => DllCall('Ole32\CoInstall', 'ptr', pbc, 'uint', dwFlags, 'ptr', pClassSpec, 'ptr', pQuery, 'wstr', pszCodeBase, 'int')
CoInvalidateRemoteMachineBindings(pszMachineName) => DllCall('Ole32\CoInvalidateRemoteMachineBindings', 'str', pszMachineName, 'int')
CoIsHandlerConnected(pUnk) => DllCall('Ole32\CoIsHandlerConnected', 'ptr', pUnk, 'int')
CoIsOle1Class(rclsid) => DllCall('Ole32\CoIsOle1Class', 'ptr', rclsid, 'int')
CoLoadLibrary(lpszLibName, bAutoFree) => DllCall('Ole32\CoLoadLibrary', 'str', lpszLibName, 'int', bAutoFree, 'ptr')
CoLockObjectExternal(pUnk, fLock, fLastUnlockReleases) => DllCall('Ole32\CoLockObjectExternal', 'ptr', pUnk, 'int', fLock, 'int', fLastUnlockReleases, 'int')
CoMarshalHresult(pstm, hresult) => DllCall('Ole32\CoMarshalHresult', 'ptr', pstm, 'int', hresult, 'int')
CoMarshalInterThreadInterfaceInStream(riid, pUnk, ppStm) => DllCall('Ole32\CoMarshalInterThreadInterfaceInStream', 'ptr', riid, 'ptr', pUnk, 'ptr', ppStm, 'int')
CoMarshalInterface(pStm, riid, pUnk, dwDestContext, pvDestContext, mshlflags) => DllCall('Ole32\CoMarshalInterface', 'ptr', pStm, 'ptr', riid, 'ptr', pUnk, 'uint', dwDestContext, 'ptr', pvDestContext, 'uint', mshlflags, 'int')
CoQueryAuthenticationServices(&pcAuthSvc, asAuthSvc) => DllCall('Ole32\CoQueryAuthenticationServices', 'uint*', &pcAuthSvc, 'ptr', asAuthSvc, 'int')
CoQueryClientBlanket(&pAuthnSvc, &pAuthzSvc, pServerPrincName, &pAuthnLevel, &pImpLevel, pPrivs, &pCapabilities) => DllCall('Ole32\CoQueryClientBlanket', 'uint*', &pAuthnSvc, 'uint*', &pAuthzSvc, 'wstr', pServerPrincName, 'uint*', &pAuthnLevel, 'uint*', &pImpLevel, 'ptr', pPrivs, 'uint*', &pCapabilities, 'int')
CoQueryProxyBlanket(pProxy, &pwAuthnSvc, &pAuthzSvc, pServerPrincName, &pAuthnLevel, &pImpLevel, pAuthInfo, &pCapabilites) => DllCall('Ole32\CoQueryProxyBlanket', 'ptr', pProxy, 'uint*', &pwAuthnSvc, 'uint*', &pAuthzSvc, 'wstr', pServerPrincName, 'uint*', &pAuthnLevel, 'uint*', &pImpLevel, 'ptr', pAuthInfo, 'uint*', &pCapabilites, 'int')
CoRegisterChannelHook(ExtensionUuid, pChannelHook) => DllCall('Ole32\CoRegisterChannelHook', 'ptr', ExtensionUuid, 'ptr', pChannelHook, 'int')
CoRegisterClassObject(rclsid, pUnk, dwClsContext, flags, lpdwRegister) => DllCall('Ole32\CoRegisterClassObject', 'ptr', rclsid, 'ptr', pUnk, 'uint', dwClsContext, 'uint', flags, 'ptr', lpdwRegister, 'int')
CoRegisterInitializeSpy(pSpy, puliCookie) => DllCall('Ole32\CoRegisterInitializeSpy', 'ptr', pSpy, 'ptr', puliCookie, 'int')
CoRegisterMallocSpy(pMallocSpy) => DllCall('Ole32\CoRegisterMallocSpy', 'ptr', pMallocSpy, 'int')
CoRegisterMessageFilter(lpMessageFilter, lplpMessageFilter) => DllCall('Ole32\CoRegisterMessageFilter', 'ptr', lpMessageFilter, 'ptr', lplpMessageFilter, 'int')
CoRegisterPSClsid(riid, rclsid) => DllCall('Ole32\CoRegisterPSClsid', 'ptr', riid, 'ptr', rclsid, 'int')
CoRegisterSurrogate(pSurrogate) => DllCall('Ole32\CoRegisterSurrogate', 'ptr', pSurrogate, 'int')
CoReleaseMarshalData(pStm) => DllCall('Ole32\CoReleaseMarshalData', 'ptr', pStm, 'int')
CoReleaseServerProcess() => DllCall('Ole32\CoReleaseServerProcess', 'uint')
CoResumeClassObjects() => DllCall('Ole32\CoResumeClassObjects', 'int')
CoRevertToSelf() => DllCall('Ole32\CoRevertToSelf', 'int')
CoRevokeClassObject(dwRegister) => DllCall('Ole32\CoRevokeClassObject', 'uint', dwRegister, 'int')
CoRevokeInitializeSpy(uliCookie) => DllCall('Ole32\CoRevokeInitializeSpy', 'int64', uliCookie, 'int')
CoRevokeMallocSpy() => DllCall('Ole32\CoRevokeMallocSpy', 'int')
CoSetCancelObject(pUnk) => DllCall('Ole32\CoSetCancelObject', 'ptr', pUnk, 'int')
CoSetProxyBlanket(pProxy, dwAuthnSvc, dwAuthzSvc, pServerPrincName, dwAuthnLevel, dwImpLevel, pAuthInfo, dwCapabilities) => DllCall('Ole32\CoSetProxyBlanket', 'ptr', pProxy, 'uint', dwAuthnSvc, 'uint', dwAuthzSvc, 'wstr', pServerPrincName, 'uint', dwAuthnLevel, 'uint', dwImpLevel, 'ptr', pAuthInfo, 'uint', dwCapabilities, 'int')
CoSuspendClassObjects() => DllCall('Ole32\CoSuspendClassObjects', 'int')
CoSwitchCallContext(pNewObject, ppOldObject) => DllCall('Ole32\CoSwitchCallContext', 'ptr', pNewObject, 'ptr', ppOldObject, 'int')
CoTaskMemAlloc(cb) => DllCall('Ole32\CoTaskMemAlloc', 'uptr', cb, 'ptr')
CoTaskMemFree(pv) => DllCall('Ole32\CoTaskMemFree', 'ptr', pv, 'int')
CoTaskMemRealloc(pv, cb) => DllCall('Ole32\CoTaskMemRealloc', 'ptr', pv, 'uptr', cb, 'ptr')
CoTestCancel() => DllCall('Ole32\CoTestCancel', 'int')
CoTreatAsClass(clsidOld, clsidNew) => DllCall('Ole32\CoTreatAsClass', 'ptr', clsidOld, 'ptr', clsidNew, 'int')
CoUninitialize() => DllCall('Ole32\CoUninitialize', 'int')
CoUnmarshalHresult(pstm, &phresult) => DllCall('Ole32\CoUnmarshalHresult', 'ptr', pstm, 'int*', &phresult, 'int')
CoUnmarshalInterface(pStm, riid, ppv) => DllCall('Ole32\CoUnmarshalInterface', 'ptr', pStm, 'ptr', riid, 'ptr', ppv, 'int')
CoWaitForMultipleHandles(dwFlags, dwTimeout, cHandles, pHandles, lpdwindex) => DllCall('Ole32\CoWaitForMultipleHandles', 'uint', dwFlags, 'uint', dwTimeout, 'uint', cHandles, 'ptr', pHandles, 'ptr', lpdwindex, 'int')
CreateAntiMoniker(ppmk) => DllCall('Ole32\CreateAntiMoniker', 'ptr', ppmk, 'int')
CreateBindCtx(reserved, ppbc) => DllCall('Ole32\CreateBindCtx', 'uint', reserved, 'ptr', ppbc, 'int')
CreateClassMoniker(rclsid, ppmk) => DllCall('Ole32\CreateClassMoniker', 'ptr', rclsid, 'ptr', ppmk, 'int')
CreateDataAdviseHolder(ppDAHolder) => DllCall('Ole32\CreateDataAdviseHolder', 'ptr', ppDAHolder, 'int')
CreateDataCache(pUnkOuter, rclsid, iid, ppv) => DllCall('Ole32\CreateDataCache', 'ptr', pUnkOuter, 'ptr', rclsid, 'ptr', iid, 'ptr', ppv, 'int')
CreateFileMoniker(lpszPathName, ppmk) => DllCall('Ole32\CreateFileMoniker', 'str', lpszPathName, 'ptr', ppmk, 'int')
CreateGenericComposite(pmkFirst, pmkRest, ppmkComposite) => DllCall('Ole32\CreateGenericComposite', 'ptr', pmkFirst, 'ptr', pmkRest, 'ptr', ppmkComposite, 'int')
CreateILockBytesOnHGlobal(hGlobal, fDeleteOnRelease, ppLkbyt) => DllCall('Ole32\CreateILockBytesOnHGlobal', 'ptr', hGlobal, 'int', fDeleteOnRelease, 'ptr', ppLkbyt, 'int')
CreateItemMoniker(lpszDelim, lpszItem, ppmk) => DllCall('Ole32\CreateItemMoniker', 'str', lpszDelim, 'str', lpszItem, 'ptr', ppmk, 'int')
CreateObjrefMoniker(punk, ppmk) => DllCall('Ole32\CreateObjrefMoniker', 'ptr', punk, 'ptr', ppmk, 'int')
CreateOleAdviseHolder(ppOAHolder) => DllCall('Ole32\CreateOleAdviseHolder', 'ptr', ppOAHolder, 'int')
CreatePointerMoniker(punk, ppmk) => DllCall('Ole32\CreatePointerMoniker', 'ptr', punk, 'ptr', ppmk, 'int')
CreateStreamOnHGlobal(hGlobal, fDeleteOnRelease, ppstm) => DllCall('Ole32\CreateStreamOnHGlobal', 'ptr', hGlobal, 'int', fDeleteOnRelease, 'ptr', ppstm, 'int')
DllDebugObjectRPCHook(fTrace, lpOrpcInitArgs) => DllCall('Ole32\DllDebugObjectRPCHook', 'int', fTrace, 'ptr', lpOrpcInitArgs, 'int')
DoDragDrop(pDataObj, pDropSource, dwOKEffects, pdwEffect) => DllCall('Ole32\DoDragDrop', 'ptr', pDataObj, 'ptr', pDropSource, 'uint', dwOKEffects, 'ptr', pdwEffect, 'int')
FmtIdToPropStgName(pfmtid, oszName) => DllCall('Ole32\FmtIdToPropStgName', 'ptr', pfmtid, 'str', oszName, 'int')
FreePropVariantArray(cVariants, rgvars) => DllCall('Ole32\FreePropVariantArray', 'uint', cVariants, 'ptr', rgvars, 'int')
GetClassFile(szFilename, pclsid) => DllCall('Ole32\GetClassFile', 'str', szFilename, 'ptr', pclsid, 'int')
GetConvertStg(pStg) => DllCall('Ole32\GetConvertStg', 'ptr', pStg, 'int')
GetHGlobalFromILockBytes(pLkbyt, phglobal) => DllCall('Ole32\GetHGlobalFromILockBytes', 'ptr', pLkbyt, 'ptr', phglobal, 'int')
GetHGlobalFromStream(pstm, phglobal) => DllCall('Ole32\GetHGlobalFromStream', 'ptr', pstm, 'ptr', phglobal, 'int')
GetRunningObjectTable(reserved, pprot) => DllCall('Ole32\GetRunningObjectTable', 'uint', reserved, 'ptr', pprot, 'int')
IIDFromString(lpsz, lpiid) => DllCall('Ole32\IIDFromString', 'str', lpsz, 'ptr', lpiid, 'int')
IsAccelerator(hAccel, cAccelEntries, lpMsg, &lpwCmd) => DllCall('Ole32\IsAccelerator', 'ptr', hAccel, 'int', cAccelEntries, 'ptr', lpMsg, 'ushort*', &lpwCmd, 'int')
IsEqualGUID(rguid1, rguid2) => DllCall('Ole32\IsEqualGUID', 'ptr', rguid1, 'ptr', rguid2, 'int')
MkParseDisplayName(pbc, szUserName, &pchEaten, ppmk) => DllCall('Ole32\MkParseDisplayName', 'ptr', pbc, 'str', szUserName, 'uint*', &pchEaten, 'ptr', ppmk, 'int')
MonikerCommonPrefixWith(pmkThis, pmkOther, ppmkCommon) => DllCall('Ole32\MonikerCommonPrefixWith', 'ptr', pmkThis, 'ptr', pmkOther, 'ptr', ppmkCommon, 'int')
MonikerRelativePathTo(pmkSrc, pmkDest, ppmkRelPath, dwReserved) => DllCall('Ole32\MonikerRelativePathTo', 'ptr', pmkSrc, 'ptr', pmkDest, 'ptr', ppmkRelPath, 'int', dwReserved, 'int')
OleConvertIStorageToOLESTREAM(pStg, lpolestream) => DllCall('Ole32\OleConvertIStorageToOLESTREAM', 'ptr', pStg, 'ptr', lpolestream, 'int')
OleConvertIStorageToOLESTREAMEx(pStg, cfFormat, lWidth, lHeight, dwSize, pmedium, lpolestm) => DllCall('Ole32\OleConvertIStorageToOLESTREAMEx', 'ptr', pStg, 'ushort', cfFormat, 'int', lWidth, 'int', lHeight, 'uint', dwSize, 'ptr', pmedium, 'ptr', lpolestm, 'int')
OleConvertOLESTREAMToIStorage(lpolestream, pstg, ptd) => DllCall('Ole32\OleConvertOLESTREAMToIStorage', 'ptr', lpolestream, 'ptr', pstg, 'ptr', ptd, 'int')
OleConvertOLESTREAMToIStorageEx(lpolestm, pstg, pcfFormat, &plWidth, &plHeight, &pdwSize, pmedium) => DllCall('Ole32\OleConvertOLESTREAMToIStorageEx', 'ptr', lpolestm, 'ptr', pstg, 'ptr', pcfFormat, 'int*', &plWidth, 'int*', &plHeight, 'uint*', &pdwSize, 'ptr', pmedium, 'int')
OleCreate(rclsid, riid, renderopt, pFormatEtc, pClientSite, pStg, ppvObj) => DllCall('Ole32\OleCreate', 'ptr', rclsid, 'ptr', riid, 'uint', renderopt, 'ptr', pFormatEtc, 'ptr', pClientSite, 'ptr', pStg, 'ptr', ppvObj, 'int')
OleCreateDefaultHandler(clsid, pUnkOuter, riid, lplpObj) => DllCall('Ole32\OleCreateDefaultHandler', 'ptr', clsid, 'ptr', pUnkOuter, 'ptr', riid, 'ptr', lplpObj, 'int')
OleCreateEmbeddingHelper(clsid, pUnkOuter, flags, pCF, riid, lplpObj) => DllCall('Ole32\OleCreateEmbeddingHelper', 'ptr', clsid, 'ptr', pUnkOuter, 'uint', flags, 'ptr', pCF, 'ptr', riid, 'ptr', lplpObj, 'int')
OleCreateEx(rclsid, riid, dwFlags, renderopt, cFormats, &rgAdvf, rgFormatEtc, lpAdviseSink, &rgdwConnection, pClientSite, pStg, ppvObj) => DllCall('Ole32\OleCreateEx', 'ptr', rclsid, 'ptr', riid, 'uint', dwFlags, 'uint', renderopt, 'uint', cFormats, 'uint*', &rgAdvf, 'ptr', rgFormatEtc, 'ptr', lpAdviseSink, 'uint*', &rgdwConnection, 'ptr', pClientSite, 'ptr', pStg, 'ptr', ppvObj, 'int')
OleCreateFromData(pSrcDataObj, riid, renderopt, pFormatEtc, pClientSite, pStg, ppvObj) => DllCall('Ole32\OleCreateFromData', 'ptr', pSrcDataObj, 'ptr', riid, 'uint', renderopt, 'ptr', pFormatEtc, 'ptr', pClientSite, 'ptr', pStg, 'ptr', ppvObj, 'int')
OleCreateFromDataEx(pSrcDataObj, riid, dwFlags, renderopt, cFormats, &rgAdvf, rgFormatEtc, lpAdviseSink, &rgdwConnection, pClientSite, pStg, ppvObj) => DllCall('Ole32\OleCreateFromDataEx', 'ptr', pSrcDataObj, 'ptr', riid, 'uint', dwFlags, 'uint', renderopt, 'uint', cFormats, 'uint*', &rgAdvf, 'ptr', rgFormatEtc, 'ptr', lpAdviseSink, 'uint*', &rgdwConnection, 'ptr', pClientSite, 'ptr', pStg, 'ptr', ppvObj, 'int')
OleCreateFromFile(rclsid, lpszFileName, riid, renderopt, lpFormatEtc, pClientSite, pStg, ppvObj) => DllCall('Ole32\OleCreateFromFile', 'ptr', rclsid, 'str', lpszFileName, 'ptr', riid, 'uint', renderopt, 'ptr', lpFormatEtc, 'ptr', pClientSite, 'ptr', pStg, 'ptr', ppvObj, 'int')
OleCreateFromFileEx(rclsid, lpszFileName, riid, dwFlags, renderopt, cFormats, &rgAdvf, rgFormatEtc, lpAdviseSink, &rgdwConnection, pClientSite, pStg, ppvObj) => DllCall('Ole32\OleCreateFromFileEx', 'ptr', rclsid, 'str', lpszFileName, 'ptr', riid, 'uint', dwFlags, 'uint', renderopt, 'uint', cFormats, 'uint*', &rgAdvf, 'ptr', rgFormatEtc, 'ptr', lpAdviseSink, 'uint*', &rgdwConnection, 'ptr', pClientSite, 'ptr', pStg, 'ptr', ppvObj, 'int')
OleCreateLink(pmkLinkSrc, riid, renderopt, lpFormatEtc, pClientSite, pStg, ppvObj) => DllCall('Ole32\OleCreateLink', 'ptr', pmkLinkSrc, 'ptr', riid, 'uint', renderopt, 'ptr', lpFormatEtc, 'ptr', pClientSite, 'ptr', pStg, 'ptr', ppvObj, 'int')
OleCreateLinkEx(pmkLinkSrc, riid, dwFlags, renderopt, cFormats, &rgAdvf, rgFormatEtc, lpAdviseSink, &rgdwConnection, pClientSite, pStg, ppvObj) => DllCall('Ole32\OleCreateLinkEx', 'ptr', pmkLinkSrc, 'ptr', riid, 'uint', dwFlags, 'uint', renderopt, 'uint', cFormats, 'uint*', &rgAdvf, 'ptr', rgFormatEtc, 'ptr', lpAdviseSink, 'uint*', &rgdwConnection, 'ptr', pClientSite, 'ptr', pStg, 'ptr', ppvObj, 'int')
OleCreateLinkFromData(pSrcDataObj, riid, renderopt, pFormatEtc, pClientSite, pStg, ppvObj) => DllCall('Ole32\OleCreateLinkFromData', 'ptr', pSrcDataObj, 'ptr', riid, 'uint', renderopt, 'ptr', pFormatEtc, 'ptr', pClientSite, 'ptr', pStg, 'ptr', ppvObj, 'int')
OleCreateLinkFromDataEx(pSrcDataObj, riid, dwFlags, renderopt, cFormats, &rgAdvf, rgFormatEtc, lpAdviseSink, &rgdwConnection, pClientSite, pStg, ppvObj) => DllCall('Ole32\OleCreateLinkFromDataEx', 'ptr', pSrcDataObj, 'ptr', riid, 'uint', dwFlags, 'uint', renderopt, 'uint', cFormats, 'uint*', &rgAdvf, 'ptr', rgFormatEtc, 'ptr', lpAdviseSink, 'uint*', &rgdwConnection, 'ptr', pClientSite, 'ptr', pStg, 'ptr', ppvObj, 'int')
OleCreateLinkToFile(lpszFileName, riid, renderopt, lpFormatEtc, pClientSite, pStg, ppvObj) => DllCall('Ole32\OleCreateLinkToFile', 'str', lpszFileName, 'ptr', riid, 'uint', renderopt, 'ptr', lpFormatEtc, 'ptr', pClientSite, 'ptr', pStg, 'ptr', ppvObj, 'int')
OleCreateLinkToFileEx(lpszFileName, riid, dwFlags, renderopt, cFormats, &rgAdvf, rgFormatEtc, lpAdviseSink, &rgdwConnection, pClientSite, pStg, ppvObj) => DllCall('Ole32\OleCreateLinkToFileEx', 'str', lpszFileName, 'ptr', riid, 'uint', dwFlags, 'uint', renderopt, 'uint', cFormats, 'uint*', &rgAdvf, 'ptr', rgFormatEtc, 'ptr', lpAdviseSink, 'uint*', &rgdwConnection, 'ptr', pClientSite, 'ptr', pStg, 'ptr', ppvObj, 'int')
OleCreateMenuDescriptor(hmenuCombined, lpMenuWidths) => DllCall('Ole32\OleCreateMenuDescriptor', 'ptr', hmenuCombined, 'ptr', lpMenuWidths, 'ptr')
OleCreateStaticFromData(pSrcDataObj, iid, renderopt, pFormatEtc, pClientSite, pStg, ppvObj) => DllCall('Ole32\OleCreateStaticFromData', 'ptr', pSrcDataObj, 'ptr', iid, 'uint', renderopt, 'ptr', pFormatEtc, 'ptr', pClientSite, 'ptr', pStg, 'ptr', ppvObj, 'int')
OleDestroyMenuDescriptor(holemenu) => DllCall('Ole32\OleDestroyMenuDescriptor', 'ptr', holemenu, 'int')
OleDoAutoConvert(pStg, pClsidNew) => DllCall('Ole32\OleDoAutoConvert', 'ptr', pStg, 'ptr', pClsidNew, 'int')
OleDraw(pUnknown, dwAspect, hdcDraw, lprcBounds) => DllCall('Ole32\OleDraw', 'ptr', pUnknown, 'uint', dwAspect, 'ptr', hdcDraw, 'ptr', lprcBounds, 'int')
OleDuplicateData(hSrc, cfFormat, uiFlags) => DllCall('Ole32\OleDuplicateData', 'ptr', hSrc, 'ushort', cfFormat, 'uint', uiFlags, 'ptr')
OleFlushClipboard() => DllCall('Ole32\OleFlushClipboard', 'int')
OleGetAutoConvert(clsidOld, pClsidNew) => DllCall('Ole32\OleGetAutoConvert', 'ptr', clsidOld, 'ptr', pClsidNew, 'int')
OleGetClipboard(ppDataObj) => DllCall('Ole32\OleGetClipboard', 'ptr', ppDataObj, 'int')
OleGetIconOfClass(rclsid, lpszLabel, fUseTypeAsLabel) => DllCall('Ole32\OleGetIconOfClass', 'ptr', rclsid, 'str', lpszLabel, 'int', fUseTypeAsLabel, 'ptr')
OleGetIconOfFile(lpszPath, fUseFileAsLabel) => DllCall('Ole32\OleGetIconOfFile', 'str', lpszPath, 'int', fUseFileAsLabel, 'ptr')
OleInitialize(pvReserved) => DllCall('Ole32\OleInitialize', 'ptr', pvReserved, 'int')
OleIsCurrentClipboard(pDataObj) => DllCall('Ole32\OleIsCurrentClipboard', 'ptr', pDataObj, 'int')
OleIsRunning(pObject) => DllCall('Ole32\OleIsRunning', 'ptr', pObject, 'int')
OleLoad(pStg, riid, pClientSite, ppvObj) => DllCall('Ole32\OleLoad', 'ptr', pStg, 'ptr', riid, 'ptr', pClientSite, 'ptr', ppvObj, 'int')
OleLoadFromStream(pStm, iidInterface, ppvObj) => DllCall('Ole32\OleLoadFromStream', 'ptr', pStm, 'ptr', iidInterface, 'ptr', ppvObj, 'int')
OleLockRunning(pUnknown, fLock, fLastUnlockCloses) => DllCall('Ole32\OleLockRunning', 'ptr', pUnknown, 'int', fLock, 'int', fLastUnlockCloses, 'int')
OleMetafilePictFromIconAndLabel(hIcon, lpszLabel, lpszSourceFile, iIconIndex) => DllCall('Ole32\OleMetafilePictFromIconAndLabel', 'ptr', hIcon, 'str', lpszLabel, 'str', lpszSourceFile, 'uint', iIconIndex, 'ptr')
OleNoteObjectVisible(pUnknown, fVisible) => DllCall('Ole32\OleNoteObjectVisible', 'ptr', pUnknown, 'int', fVisible, 'int')
OleQueryCreateFromData(pSrcDataObject) => DllCall('Ole32\OleQueryCreateFromData', 'ptr', pSrcDataObject, 'int')
OleQueryLinkFromData(pSrcDataObject) => DllCall('Ole32\OleQueryLinkFromData', 'ptr', pSrcDataObject, 'int')
OleRegEnumFormatEtc(clsid, dwDirection, ppenum) => DllCall('Ole32\OleRegEnumFormatEtc', 'ptr', clsid, 'uint', dwDirection, 'ptr', ppenum, 'int')
OleRegEnumVerbs(clsid, ppenum) => DllCall('Ole32\OleRegEnumVerbs', 'ptr', clsid, 'ptr', ppenum, 'int')
OleRegGetMiscStatus(clsid, dwAspect, &pdwStatus) => DllCall('Ole32\OleRegGetMiscStatus', 'ptr', clsid, 'uint', dwAspect, 'uint*', &pdwStatus, 'int')
OleRegGetUserType(clsid, dwFormOfType, pszUserType) => DllCall('Ole32\OleRegGetUserType', 'ptr', clsid, 'uint', dwFormOfType, 'ptr', pszUserType, 'int')
OleRun(pUnknown) => DllCall('Ole32\OleRun', 'ptr', pUnknown, 'int')
OleSave(pPS, pStg, fSameAsLoad) => DllCall('Ole32\OleSave', 'ptr', pPS, 'ptr', pStg, 'int', fSameAsLoad, 'int')
OleSaveToStream(pPStm, pStm) => DllCall('Ole32\OleSaveToStream', 'ptr', pPStm, 'ptr', pStm, 'int')
OleSetAutoConvert(clsidOld, clsidNew) => DllCall('Ole32\OleSetAutoConvert', 'ptr', clsidOld, 'ptr', clsidNew, 'int')
OleSetClipboard(pDataObj) => DllCall('Ole32\OleSetClipboard', 'ptr', pDataObj, 'int')
OleSetContainedObject(pUnknown, fContained) => DllCall('Ole32\OleSetContainedObject', 'ptr', pUnknown, 'int', fContained, 'int')
OleSetMenuDescriptor(holemenu, hwndFrame, hwndActiveObject, lpFrame, lpActiveObj) => DllCall('Ole32\OleSetMenuDescriptor', 'ptr', holemenu, 'ptr', hwndFrame, 'ptr', hwndActiveObject, 'ptr', lpFrame, 'ptr', lpActiveObj, 'int')
OleTranslateAccelerator(lpFrame, lpFrameInfo, lpmsg) => DllCall('Ole32\OleTranslateAccelerator', 'ptr', lpFrame, 'ptr', lpFrameInfo, 'ptr', lpmsg, 'int')
OleUninitialize() => DllCall('Ole32\OleUninitialize', 'int')
ProgIDFromCLSID(clsid, lplpszProgID) => DllCall('Ole32\ProgIDFromCLSID', 'ptr', clsid, 'ptr', lplpszProgID, 'int')
PropStgNameToFmtId(oszName, pfmtid) => DllCall('Ole32\PropStgNameToFmtId', 'str', oszName, 'ptr', pfmtid, 'int')
PropVariantClear(pvar) => DllCall('Ole32\PropVariantClear', 'ptr', pvar, 'int')
PropVariantCopy(pvarDest, pvarSrc) => DllCall('Ole32\PropVariantCopy', 'ptr', pvarDest, 'ptr', pvarSrc, 'int')
ReadClassStg(pStg, pclsid) => DllCall('Ole32\ReadClassStg', 'ptr', pStg, 'ptr', pclsid, 'int')
ReadClassStm(pStm, pclsid) => DllCall('Ole32\ReadClassStm', 'ptr', pStm, 'ptr', pclsid, 'int')
ReadFmtUserTypeStg(pStg, pcf, lplpszUserType) => DllCall('Ole32\ReadFmtUserTypeStg', 'ptr', pStg, 'ptr', pcf, 'ptr', lplpszUserType, 'int')
RegisterDragDrop(hwnd, pDropTarget) => DllCall('Ole32\RegisterDragDrop', 'ptr', hwnd, 'ptr', pDropTarget, 'int')
ReleaseStgMedium(pMedium) => DllCall('Ole32\ReleaseStgMedium', 'ptr', pMedium, 'int')
RevokeDragDrop(hwnd) => DllCall('Ole32\RevokeDragDrop', 'ptr', hwnd, 'int')
SetConvertStg(pStg, fConvert) => DllCall('Ole32\SetConvertStg', 'ptr', pStg, 'int', fConvert, 'int')
StgConvertPropertyToVariant(prop, CodePage, pvar, pma) => DllCall('Ole32\StgConvertPropertyToVariant', 'ptr', prop, 'ushort', CodePage, 'ptr', pvar, 'ptr', pma, 'uchar')
StgConvertVariantToProperty(pvar, CodePage, pprop, &pcb, pid, fReserved, &pcIndirect) => DllCall('Ole32\StgConvertVariantToProperty', 'ptr', pvar, 'ushort', CodePage, 'ptr', pprop, 'uint*', &pcb, 'uint', pid, 'uchar', fReserved, 'uint*', &pcIndirect, 'ptr')
StgCreateDocfile(pwcsName, grfMode, reserved, ppstgOpen) => DllCall('Ole32\StgCreateDocfile', 'wstr', pwcsName, 'uint', grfMode, 'uint', reserved, 'ptr', ppstgOpen, 'int')
StgCreateDocfileOnILockBytes(plkbyt, grfMode, reserved, ppstgOpen) => DllCall('Ole32\StgCreateDocfileOnILockBytes', 'ptr', plkbyt, 'uint', grfMode, 'uint', reserved, 'ptr', ppstgOpen, 'int')
StgCreatePropSetStg(pStorage, dwReserved, ppPropSetStg) => DllCall('Ole32\StgCreatePropSetStg', 'ptr', pStorage, 'uint', dwReserved, 'ptr', ppPropSetStg, 'int')
StgCreatePropStg(pUnk, fmtid, pclsid, grfFlags, dwReserved, ppPropStg) => DllCall('Ole32\StgCreatePropStg', 'ptr', pUnk, 'ptr', fmtid, 'ptr', pclsid, 'uint', grfFlags, 'uint', dwReserved, 'ptr', ppPropStg, 'int')
StgCreateStorageEx(pwcsName, grfMode, stgfmt, grfAttrs, pStgOptions, pSecurityDescriptor, riid, ppObjectOpen) => DllCall('Ole32\StgCreateStorageEx', 'wstr', pwcsName, 'uint', grfMode, 'uint', stgfmt, 'uint', grfAttrs, 'ptr', pStgOptions, 'ptr', pSecurityDescriptor, 'ptr', riid, 'ptr', ppObjectOpen, 'int')
StgGetIFillLockBytesOnFile(pwcsName, ppflb) => DllCall('Ole32\StgGetIFillLockBytesOnFile', 'wstr', pwcsName, 'ptr', ppflb, 'int')
StgGetIFillLockBytesOnILockBytes(pilb, ppflb) => DllCall('Ole32\StgGetIFillLockBytesOnILockBytes', 'ptr', pilb, 'ptr', ppflb, 'int')
StgIsStorageFile(pwcsName) => DllCall('Ole32\StgIsStorageFile', 'wstr', pwcsName, 'int')
StgIsStorageILockBytes(plkbyt) => DllCall('Ole32\StgIsStorageILockBytes', 'ptr', plkbyt, 'int')
StgOpenAsyncDocfileOnIFillLockBytes(ppflb, grfmode, asyncFlags, ppstgOpen) => DllCall('Ole32\StgOpenAsyncDocfileOnIFillLockBytes', 'ptr', ppflb, 'uint', grfmode, 'uint', asyncFlags, 'ptr', ppstgOpen, 'int')
StgOpenPropStg(pUnk, fmtid, grfFlags, dwReserved, ppPropStg) => DllCall('Ole32\StgOpenPropStg', 'ptr', pUnk, 'ptr', fmtid, 'uint', grfFlags, 'uint', dwReserved, 'ptr', ppPropStg, 'int')
StgOpenStorage(pwcsName, pstgPriority, grfMode, snbExclude, reserved, ppstgOpen) => DllCall('Ole32\StgOpenStorage', 'wstr', pwcsName, 'ptr', pstgPriority, 'uint', grfMode, 'ptr', snbExclude, 'uint', reserved, 'ptr', ppstgOpen, 'int')
StgOpenStorageEx(pwcsName, grfMode, stgfmt, grfAttrs, pStgOptions, reserved2, riid, ppObjectOpen) => DllCall('Ole32\StgOpenStorageEx', 'wstr', pwcsName, 'uint', grfMode, 'uint', stgfmt, 'uint', grfAttrs, 'ptr', pStgOptions, 'ptr', reserved2, 'ptr', riid, 'ptr', ppObjectOpen, 'int')
StgOpenStorageOnILockBytes(plkbyt, pStgPriority, grfMode, snbExclude, reserved, ppstgOpen) => DllCall('Ole32\StgOpenStorageOnILockBytes', 'ptr', plkbyt, 'ptr', pStgPriority, 'uint', grfMode, 'ptr', snbExclude, 'uint', reserved, 'ptr', ppstgOpen, 'int')
StgPropertyLengthAsVariant(pProp, cbProp, CodePage, bReserved) => DllCall('Ole32\StgPropertyLengthAsVariant', 'ptr', pProp, 'uint', cbProp, 'ushort', CodePage, 'uchar', bReserved, 'uint')
StgSetTimes(lpszName, pctime, patime, pmtime) => DllCall('Ole32\StgSetTimes', 'wstr', lpszName, 'ptr', pctime, 'ptr', patime, 'ptr', pmtime, 'int')
StringFromCLSID(rclsid, lplpsz) => DllCall('Ole32\StringFromCLSID', 'ptr', rclsid, 'ptr', lplpsz, 'int')
StringFromGUID2(rguid, lpsz, cchMax) => DllCall('Ole32\StringFromGUID2', 'ptr', rguid, 'str', lpsz, 'int', cchMax, 'int')
StringFromIID(rclsid, lplpsz) => DllCall('Ole32\StringFromIID', 'ptr', rclsid, 'ptr', lplpsz, 'int')
WriteClassStg(pStg, rclsid) => DllCall('Ole32\WriteClassStg', 'ptr', pStg, 'ptr', rclsid, 'int')
WriteClassStm(pStm, rclsid) => DllCall('Ole32\WriteClassStm', 'ptr', pStm, 'ptr', rclsid, 'int')
WriteFmtUserTypeStg(pStg, cf, lpszUserType) => DllCall('Ole32\WriteFmtUserTypeStg', 'ptr', pStg, 'ushort', cf, 'ptr', lpszUserType, 'int')
