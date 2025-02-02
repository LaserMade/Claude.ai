AddMRUStringW(hMRU, szString) => DllCall('Comctl32\AddMRUStringW', 'ptr', hMRU, 'str', szString, 'int')
CreateMRUListW(lpmi) => DllCall('Comctl32\CreateMRUListW', 'ptr', lpmi, 'int')
CreateMappedBitmap(hInstance, idBitmap, wFlags, lpColorMap, iNumMaps) => DllCall('Comctl32\CreateMappedBitmap', 'ptr', hInstance, 'ptr', idBitmap, 'uint', wFlags, 'ptr', lpColorMap, 'int', iNumMaps, 'ptr')
CreatePropertySheetPage(lppsp) => DllCall('Comctl32\CreatePropertySheetPage', 'ptr', lppsp, 'ptr')
CreateStatusWindow(style, lpszText, hwndParent, wID) => DllCall('Comctl32\CreateStatusWindow', 'int', style, 'str', lpszText, 'ptr', hwndParent, 'uint', wID, 'ptr')
CreateToolbarEx(hwnd, ws, wID, nBitmaps, hBMInst, wBMID, lpButtons, iNumButtons, dxButton, dyButton, dxBitmap, dyBitmap, uStructSize) => DllCall('Comctl32\CreateToolbarEx', 'ptr', hwnd, 'uint', ws, 'uint', wID, 'int', nBitmaps, 'ptr', hBMInst, 'uptr', wBMID, 'ptr', lpButtons, 'int', iNumButtons, 'int', dxButton, 'int', dyButton, 'int', dxBitmap, 'int', dyBitmap, 'uint', uStructSize, 'ptr')
CreateUpDownControl(dwStyle, x, y, cx, cy, hParent, nID, hInst, hBuddy, nUpper, nLower, nPos) => DllCall('Comctl32\CreateUpDownControl', 'uint', dwStyle, 'int', x, 'int', y, 'int', cx, 'int', cy, 'ptr', hParent, 'int', nID, 'ptr', hInst, 'ptr', hBuddy, 'int', nUpper, 'int', nLower, 'int', nPos, 'ptr')
DPA_Clone(hdpaSource, hdpaNew) => DllCall('Comctl32\DPA_Clone', 'ptr', hdpaSource, 'ptr', hdpaNew, 'ptr')
DPA_Create(cpGrow) => DllCall('Comctl32\DPA_Create', 'int', cpGrow, 'ptr')
DPA_CreateEx(cpGrow, hheap) => DllCall('Comctl32\DPA_CreateEx', 'int', cpGrow, 'ptr', hheap, 'ptr')
DPA_DeleteAllPtrs(pdpa) => DllCall('Comctl32\DPA_DeleteAllPtrs', 'ptr', pdpa, 'int')
DPA_DeletePtr(pdpa, index) => DllCall('Comctl32\DPA_DeletePtr', 'ptr', pdpa, 'int', index, 'ptr')
DPA_Destroy(pdpa) => DllCall('Comctl32\DPA_Destroy', 'ptr', pdpa, 'int')
DPA_DestroyCallback(pdpa, pfnCB, pData) => DllCall('Comctl32\DPA_DestroyCallback', 'ptr', pdpa, 'ptr', pfnCB, 'ptr', pData, 'int')
DPA_EnumCallback(pdpa, pfnCB, pData) => DllCall('Comctl32\DPA_EnumCallback', 'ptr', pdpa, 'ptr', pfnCB, 'ptr', pData, 'int')
DPA_GetPtr(pdpa, index) => DllCall('Comctl32\DPA_GetPtr', 'ptr', pdpa, 'int', index, 'ptr')
DPA_GetPtrIndex(hdpa, pvoid) => DllCall('Comctl32\DPA_GetPtrIndex', 'ptr', hdpa, 'ptr', pvoid, 'int')
DPA_GetSize(pdpa) => DllCall('Comctl32\DPA_GetSize', 'ptr', pdpa, 'uint64')
DPA_Grow(hdpa, cp) => DllCall('Comctl32\DPA_Grow', 'ptr', hdpa, 'int', cp, 'int')
DPA_InsertPtr(pdpa, index, p) => DllCall('Comctl32\DPA_InsertPtr', 'ptr', pdpa, 'int', index, 'ptr', p, 'int')
DPA_LoadStream(ppdpa, pfn, pstm, pvInstData) => DllCall('Comctl32\DPA_LoadStream', 'ptr', ppdpa, 'ptr', pfn, 'ptr', pstm, 'ptr', pvInstData, 'int')
DPA_Merge(hdpaDest, hdpaSrc, dwFlags, pfnCompare, pfnMerge, lParam) => DllCall('Comctl32\DPA_Merge', 'ptr', hdpaDest, 'ptr', hdpaSrc, 'uint', dwFlags, 'ptr', pfnCompare, 'ptr', pfnMerge, 'uptr', lParam, 'int')
DPA_SaveStream(pdpa, pfn, pstm, pvInstData) => DllCall('Comctl32\DPA_SaveStream', 'ptr', pdpa, 'ptr', pfn, 'ptr', pstm, 'ptr', pvInstData, 'int')
DPA_Search(pdpa, pFind, iStart, pfnCmp, lParam, options) => DllCall('Comctl32\DPA_Search', 'ptr', pdpa, 'ptr', pFind, 'int', iStart, 'ptr', pfnCmp, 'uptr', lParam, 'uint', options, 'int')
DPA_SetPtr(pdpa, index, p) => DllCall('Comctl32\DPA_SetPtr', 'ptr', pdpa, 'int', index, 'ptr', p, 'int')
DPA_Sort(pdpa, pfnCmp, lParam) => DllCall('Comctl32\DPA_Sort', 'ptr', pdpa, 'ptr', pfnCmp, 'uptr', lParam, 'int')
DSA_Clone(hdsa) => DllCall('Comctl32\DSA_Clone', 'ptr', hdsa, 'ptr')
DSA_Create(cbItem, cbItemGrow) => DllCall('Comctl32\DSA_Create', 'int', cbItem, 'int', cbItemGrow, 'ptr')
DSA_DeleteAllItems(hdsa) => DllCall('Comctl32\DSA_DeleteAllItems', 'ptr', hdsa, 'int')
DSA_DeleteItem(hdsa, nPosition) => DllCall('Comctl32\DSA_DeleteItem', 'ptr', hdsa, 'int', nPosition, 'int')
DSA_Destroy(pdsa) => DllCall('Comctl32\DSA_Destroy', 'ptr', pdsa, 'int')
DSA_DestroyCallback(pdsa, pfnCB, pData) => DllCall('Comctl32\DSA_DestroyCallback', 'ptr', pdsa, 'ptr', pfnCB, 'ptr', pData, 'int')
DSA_EnumCallback(hdsa, pfnCB, pData) => DllCall('Comctl32\DSA_EnumCallback', 'ptr', hdsa, 'ptr', pfnCB, 'ptr', pData, 'int')
DSA_GetItem(pdsa, index, pitem) => DllCall('Comctl32\DSA_GetItem', 'ptr', pdsa, 'int', index, 'ptr', pitem, 'int')
DSA_GetItemPtr(pdsa, index) => DllCall('Comctl32\DSA_GetItemPtr', 'ptr', pdsa, 'int', index, 'ptr')
DSA_GetSize(hdsa) => DllCall('Comctl32\DSA_GetSize', 'ptr', hdsa, 'uint64')
DSA_InsertItem(pdsa, index, pItem) => DllCall('Comctl32\DSA_InsertItem', 'ptr', pdsa, 'int', index, 'ptr', pItem, 'int')
DSA_SetItem(hdsa, index, pItem) => DllCall('Comctl32\DSA_SetItem', 'ptr', hdsa, 'int', index, 'ptr', pItem, 'int')
DSA_Sort(pdsa, pfnCompare, lParam) => DllCall('Comctl32\DSA_Sort', 'ptr', pdsa, 'ptr', pfnCompare, 'uptr', lParam, 'int')
DefSubclassProc(hWnd, uMsg, wParam, lParam) => DllCall('Comctl32\DefSubclassProc', 'ptr', hWnd, 'uint', uMsg, 'uptr', wParam, 'uptr', lParam, 'ptr')
DestroyPropertySheetPage(hPSPage) => DllCall('Comctl32\DestroyPropertySheetPage', 'ptr', hPSPage, 'int')
DrawInsert(handParent, hLB, nItem) => DllCall('Comctl32\DrawInsert', 'ptr', handParent, 'ptr', hLB, 'int', nItem, 'int')
DrawShadowText(hdc, pszText, cch, pRect, dwFlags, crText, crShadow, ixOffset, iyOffset) => DllCall('Comctl32\DrawShadowText', 'ptr', hdc, 'wstr', pszText, 'uint', cch, 'ptr', pRect, 'uint', dwFlags, 'uint', crText, 'uint', crShadow, 'int', ixOffset, 'int', iyOffset, 'int')
DrawStatusText(hdc, lprc, pszText, uFlags) => DllCall('Comctl32\DrawStatusText', 'ptr', hdc, 'ptr', lprc, 'str', pszText, 'uint', uFlags, 'int')
EnumMRUListW(hMRU, nItem, lpData, uLen) => DllCall('Comctl32\EnumMRUListW', 'ptr', hMRU, 'int', nItem, 'ptr', lpData, 'uint', uLen, 'int')
FlatSB_EnableScrollBar(hwnd, wSBflags, wArrows) => DllCall('Comctl32\FlatSB_EnableScrollBar', 'ptr', hwnd, 'int', wSBflags, 'uint', wArrows, 'int')
FlatSB_GetScrollInfo(hwnd, fnBar, lpsi) => DllCall('Comctl32\FlatSB_GetScrollInfo', 'ptr', hwnd, 'int', fnBar, 'ptr', lpsi, 'int')
FlatSB_GetScrollPos(hwnd, code) => DllCall('Comctl32\FlatSB_GetScrollPos', 'ptr', hwnd, 'int', code, 'int')
FlatSB_GetScrollProp(hwnd, index, pValue) => DllCall('Comctl32\FlatSB_GetScrollProp', 'ptr', hwnd, 'uint', index, 'ptr', pValue, 'int')
FlatSB_GetScrollRange(hwnd, code, lpMinPos, lpMaxPos) => DllCall('Comctl32\FlatSB_GetScrollRange', 'ptr', hwnd, 'int', code, 'ptr', lpMinPos, 'ptr', lpMaxPos, 'int')
FlatSB_SetScrollInfo(hwnd, fnBar, lpsi, fRedraw) => DllCall('Comctl32\FlatSB_SetScrollInfo', 'ptr', hwnd, 'int', fnBar, 'ptr', lpsi, 'int', fRedraw, 'int')
FlatSB_SetScrollPos(hwnd, code, nPos, fRedraw) => DllCall('Comctl32\FlatSB_SetScrollPos', 'ptr', hwnd, 'int', code, 'int', nPos, 'int', fRedraw, 'int')
FlatSB_SetScrollProp(hwnd, index, newValue, fRedraw) => DllCall('Comctl32\FlatSB_SetScrollProp', 'ptr', hwnd, 'uint', index, 'ptr', newValue, 'int', fRedraw, 'int')
FlatSB_SetScrollRange(hwnd, code, nMinPos, nMaxPos, fRedraw) => DllCall('Comctl32\FlatSB_SetScrollRange', 'ptr', hwnd, 'int', code, 'int', nMinPos, 'int', nMaxPos, 'int', fRedraw, 'int')
FlatSB_ShowScrollBar(hwnd, code, fShow) => DllCall('Comctl32\FlatSB_ShowScrollBar', 'ptr', hwnd, 'int', code, 'int', fShow, 'int')
FreeMRUList(hMRU) => DllCall('Comctl32\FreeMRUList', 'ptr', hMRU, 'int')
GetEffectiveClientRect(hWnd, lprc, &lpInfo) => DllCall('Comctl32\GetEffectiveClientRect', 'ptr', hWnd, 'ptr', lprc, 'int*', &lpInfo, 'int')
GetMUILanguage() => DllCall('Comctl32\GetMUILanguage', 'ushort')
GetWindowSubclass(hWnd, pfnSubclass, uIdSubclass, pdwRefData) => DllCall('Comctl32\GetWindowSubclass', 'ptr', hWnd, 'ptr', pfnSubclass, 'uptr', uIdSubclass, 'uptr', pdwRefData, 'int')
HIMAGELIST_QueryInterface(himl, riid, ppv) => DllCall('Comctl32\HIMAGELIST_QueryInterface', 'ptr', himl, 'ptr', riid, 'ptr', ppv, 'int')
ImageList_Add(himl, hbmImage, hbmMask) => DllCall('Comctl32\ImageList_Add', 'ptr', himl, 'ptr', hbmImage, 'ptr', hbmMask, 'int')
ImageList_AddMasked(himl, hbmImage, crMask) => DllCall('Comctl32\ImageList_AddMasked', 'ptr', himl, 'ptr', hbmImage, 'uint', crMask, 'int')
ImageList_BeginDrag(himlTrack, iTrack, dxHotspot, dyHotspot) => DllCall('Comctl32\ImageList_BeginDrag', 'ptr', himlTrack, 'int', iTrack, 'int', dxHotspot, 'int', dyHotspot, 'int')
ImageList_CoCreateInstance(rclsid, punkOuter, riid, ppv) => DllCall('Comctl32\ImageList_CoCreateInstance', 'ptr', rclsid, 'ptr', punkOuter, 'ptr', riid, 'ptr', ppv, 'int')
ImageList_Copy(himlDst, iDst, himlSrc, iSrc, uFlags) => DllCall('Comctl32\ImageList_Copy', 'ptr', himlDst, 'int', iDst, 'ptr', himlSrc, 'int', iSrc, 'uint', uFlags, 'int')
ImageList_Create(cx, cy, flags, cInitial, cGrow) => DllCall('Comctl32\ImageList_Create', 'int', cx, 'int', cy, 'uint', flags, 'int', cInitial, 'int', cGrow, 'ptr')
ImageList_Destroy(himl) => DllCall('Comctl32\ImageList_Destroy', 'ptr', himl, 'int')
ImageList_DragEnter(hwndLock, x, y) => DllCall('Comctl32\ImageList_DragEnter', 'ptr', hwndLock, 'int', x, 'int', y, 'int')
ImageList_DragLeave(hwndLock) => DllCall('Comctl32\ImageList_DragLeave', 'ptr', hwndLock, 'int')
ImageList_DragMove(x, y) => DllCall('Comctl32\ImageList_DragMove', 'int', x, 'int', y, 'int')
ImageList_DragShowNolock(fShow) => DllCall('Comctl32\ImageList_DragShowNolock', 'int', fShow, 'int')
ImageList_Draw(himl, i, hdcDst, x, y, fStyle) => DllCall('Comctl32\ImageList_Draw', 'ptr', himl, 'int', i, 'ptr', hdcDst, 'int', x, 'int', y, 'uint', fStyle, 'int')
ImageList_DrawEx(himl, i, hdcDst, x, y, dx, dy, rgbBk, rgbFg, fStyle) => DllCall('Comctl32\ImageList_DrawEx', 'ptr', himl, 'int', i, 'ptr', hdcDst, 'int', x, 'int', y, 'int', dx, 'int', dy, 'uint', rgbBk, 'uint', rgbFg, 'uint', fStyle, 'int')
ImageList_DrawIndirect(pimldp) => DllCall('Comctl32\ImageList_DrawIndirect', 'ptr', pimldp, 'int')
ImageList_Duplicate(himl) => DllCall('Comctl32\ImageList_Duplicate', 'ptr', himl, 'ptr')
ImageList_EndDrag() => DllCall('Comctl32\ImageList_EndDrag', 'int')
ImageList_GetBkColor(himl) => DllCall('Comctl32\ImageList_GetBkColor', 'ptr', himl, 'uint')
ImageList_GetDragImage(ppt, pptHotspot) => DllCall('Comctl32\ImageList_GetDragImage', 'ptr', ppt, 'ptr', pptHotspot, 'ptr')
ImageList_GetIcon(himl, i, flags) => DllCall('Comctl32\ImageList_GetIcon', 'ptr', himl, 'int', i, 'uint', flags, 'ptr')
ImageList_GetIconSize(himl, &cx, &cy) => DllCall('Comctl32\ImageList_GetIconSize', 'ptr', himl, 'int*', &cx, 'int*', &cy, 'int')
ImageList_GetImageCount(himl) => DllCall('Comctl32\ImageList_GetImageCount', 'ptr', himl, 'int')
ImageList_GetImageInfo(himl, i, pImageInfo) => DllCall('Comctl32\ImageList_GetImageInfo', 'ptr', himl, 'int', i, 'ptr', pImageInfo, 'int')
ImageList_LoadImage(hi, lpbmp, cx, cGrow, crMask, uType, uFlags) => DllCall('Comctl32\ImageList_LoadImage', 'ptr', hi, 'str', lpbmp, 'int', cx, 'int', cGrow, 'uint', crMask, 'uint', uType, 'uint', uFlags, 'ptr')
ImageList_Merge(himl1, i1, himl2, i2, dx, dy) => DllCall('Comctl32\ImageList_Merge', 'ptr', himl1, 'int', i1, 'ptr', himl2, 'int', i2, 'int', dx, 'int', dy, 'ptr')
ImageList_Read(pstm) => DllCall('Comctl32\ImageList_Read', 'ptr', pstm, 'ptr')
ImageList_ReadEx(dwFlags, pstm, riid, ppv) => DllCall('Comctl32\ImageList_ReadEx', 'uint', dwFlags, 'ptr', pstm, 'ptr', riid, 'ptr', ppv, 'int')
ImageList_Remove(himl, i) => DllCall('Comctl32\ImageList_Remove', 'ptr', himl, 'int', i, 'int')
ImageList_Replace(himl, i, hbmImage, hbmMask) => DllCall('Comctl32\ImageList_Replace', 'ptr', himl, 'int', i, 'ptr', hbmImage, 'ptr', hbmMask, 'int')
ImageList_ReplaceIcon(himl, i, hicon) => DllCall('Comctl32\ImageList_ReplaceIcon', 'ptr', himl, 'int', i, 'ptr', hicon, 'int')
ImageList_SetBkColor(himl, clrBk) => DllCall('Comctl32\ImageList_SetBkColor', 'ptr', himl, 'uint', clrBk, 'uint')
ImageList_SetDragCursorImage(himlDrag, iDrag, dxHotspot, dyHotspot) => DllCall('Comctl32\ImageList_SetDragCursorImage', 'ptr', himlDrag, 'int', iDrag, 'int', dxHotspot, 'int', dyHotspot, 'int')
ImageList_SetIconSize(himl, cx, cy) => DllCall('Comctl32\ImageList_SetIconSize', 'ptr', himl, 'int', cx, 'int', cy, 'int')
ImageList_SetImageCount(himl, uNewCount) => DllCall('Comctl32\ImageList_SetImageCount', 'ptr', himl, 'uint', uNewCount, 'int')
ImageList_SetOverlayImage(himl, iImage, iOverlay) => DllCall('Comctl32\ImageList_SetOverlayImage', 'ptr', himl, 'int', iImage, 'int', iOverlay, 'int')
ImageList_Write(himl, pstm) => DllCall('Comctl32\ImageList_Write', 'ptr', himl, 'ptr', pstm, 'int')
ImageList_WriteEx(himl, dwFlags, pstm) => DllCall('Comctl32\ImageList_WriteEx', 'ptr', himl, 'uint', dwFlags, 'ptr', pstm, 'int')
InitCommonControls() => DllCall('Comctl32\InitCommonControls', 'int')
InitCommonControlsEx(lpInitCtrls) => DllCall('Comctl32\InitCommonControlsEx', 'ptr', lpInitCtrls, 'int')
InitMUILanguage(uiLang) => DllCall('Comctl32\InitMUILanguage', 'ushort', uiLang, 'int')
InitializeFlatSB(hwnd) => DllCall('Comctl32\InitializeFlatSB', 'ptr', hwnd, 'int')
LBItemFromPt(hLB, pt, bAutoScroll) => DllCall('Comctl32\LBItemFromPt', 'ptr', hLB, 'uint64', pt, 'int', bAutoScroll, 'int')
LoadIconMetric(hinst, pszName, lims, phico) => DllCall('Comctl32\LoadIconMetric', 'ptr', hinst, 'wstr', pszName, 'int', lims, 'ptr', phico, 'int')
LoadIconWithScaleDown(hinst, pszName, cx, cy, phico) => DllCall('Comctl32\LoadIconWithScaleDown', 'ptr', hinst, 'wstr', pszName, 'int', cx, 'int', cy, 'ptr', phico, 'int')
MakeDragList(hLB) => DllCall('Comctl32\MakeDragList', 'ptr', hLB, 'int')
MenuHelp(uMsg, wParam, lParam, hMainMenu, hInst, hwndStatus, lpwIDs) => DllCall('Comctl32\MenuHelp', 'uint', uMsg, 'uptr', wParam, 'uptr', lParam, 'ptr', hMainMenu, 'ptr', hInst, 'ptr', hwndStatus, 'ptr', lpwIDs, 'int')
PropertySheet(lppsph) => DllCall('Comctl32\PropertySheet', 'ptr', lppsph, 'ptr')
RemoveWindowSubclass(hWnd, pfnSubclass, uIdSubclass) => DllCall('Comctl32\RemoveWindowSubclass', 'ptr', hWnd, 'ptr', pfnSubclass, 'uptr', uIdSubclass, 'int')
SetWindowSubclass(hWnd, pfnSubclass, uIdSubclass, dwRefData) => DllCall('Comctl32\SetWindowSubclass', 'ptr', hWnd, 'ptr', pfnSubclass, 'uptr', uIdSubclass, 'uptr', dwRefData, 'int')
ShowHideMenuCtl(hWnd, uFlags, lpInfo) => DllCall('Comctl32\ShowHideMenuCtl', 'ptr', hWnd, 'uptr', uFlags, 'ptr', lpInfo, 'int')
Str_SetPtr(ppszCurrent, pszNew) => DllCall('Comctl32\Str_SetPtr', 'ptr', ppszCurrent, 'str', pszNew, 'int')
TaskDialog(hWndParent, hInstance, pszWindowTitle, pszMainInstruction, pszContent, dwCommonButtons, pszIcon, &pnButton) => DllCall('Comctl32\TaskDialog', 'ptr', hWndParent, 'ptr', hInstance, 'wstr', pszWindowTitle, 'wstr', pszMainInstruction, 'wstr', pszContent, 'uint', dwCommonButtons, 'wstr', pszIcon, 'int*', &pnButton, 'int')
TaskDialogIndirect(pTaskConfig, &pnButton, &pnRadioButton, &pfVerificationFlagChecked) => DllCall('Comctl32\TaskDialogIndirect', 'ptr', pTaskConfig, 'int*', &pnButton, 'int*', &pnRadioButton, 'int*', &pfVerificationFlagChecked, 'int')
UninitializeFlatSB(hwnd) => DllCall('Comctl32\UninitializeFlatSB', 'ptr', hwnd, 'int')
_TrackMouseEvent(lpEventTrack) => DllCall('Comctl32\_TrackMouseEvent', 'ptr', lpEventTrack, 'int')
