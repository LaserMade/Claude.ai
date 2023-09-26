﻿#Requires AutoHotkey v2+
; #Requires AutoHotkey v1+






; AHK Data Types
PTR:=A_PtrSize
UPTR:=PTR
SHORT:=2
USHORT:=SHORT
INT:=4
UINT:=INT
INT64:=8
UINT64:=INT64
DOUBLE:=INT64
FLOAT:=INT
CHAR:=1
UCHAR:=CHAR

;Windows Data Types
TBYTE:= A_IsUnicode ?"CHAR":"SHORT"
TCHAR:=A_IsUnicode?"USHORT":"UCHAR"
HALF_PTR:=A_PtrSize=8?"INT":"SHORT"
UHALF_PTR:=A_PtrSize=8?"UINT":"USHORT"
BOOL:="Int"
INT32:="Int"
LONG:="Int"
LONG32:="Int"
LONGLONG:="Int64"
LONG64:="Int64"
USN:="Int64"
HFILE:="PTR"
HRESULT:="PTR"
INT_PTR:="PTR"
LONG_PTR:="PTR"
POINTER_64:="PTR"
POINTER_SIGNED:="PTR"
SSIZE_T:="PTR"
WPARAM:="PTR"
BOOLEAN:="UCHAR"
BYTE:="UCHAR"
COLORREF:="UInt"
DWORD:="UInt"
DWORD32:="UInt"
LCID:="UInt"
LCTYPE:="UInt"
LGRPID:="UInt"
LRESULT:="UInt"
PBOOL:="UInt"
PBOOLEAN:="UInt"
PBYTE:="UInt"
PCHAR:="UInt"
PCSTR:="UInt"
PCTSTR:="UInt"
PCWSTR:="UInt"
PDWORD:="UInt"
PDWORDLONG:="UInt"
PDWORD_PTR:="UInt"
PDWORD32:="UInt"
PDWORD64:="UInt"
PFLOAT:="UInt"
PHALF_PTR:="UInt"
UINT32:="UInt"
ULONG:="UInt"
ULONG32:="UInt"
DWORDLONG:="UInt64"
DWORD64:="UInt64"
UINT64:="UInt64"
ULONGLONG:="UInt64"
ULONG64:="UInt64"
DWORD_PTR:="UPTR"
HACCEL:="UPTR"
HANDLE:="UPTR"
HBITMAP:="UPTR"
HBRUSH:="UPTR"
HCOLORSPACE:="UPTR"
HCONV:="UPTR"
HCONVLIST:="UPTR"
HCURSOR:="UPTR"
HDC:="UPTR"
HDDEDATA:="UPTR"
HDESK:="UPTR"
HDROP:="UPTR"
HDWP:="UPTR"
HENHMETAFILE:="UPTR"
HFONT:="UPTR"
HGDIOBJ:="UPTR"
HGLOBAL:="UPTR"
HHOOK:="UPTR"
HICON:="UPTR"
HINSTANCE:="UPTR"
HKEY:="UPTR"
HKL:="UPTR"
HLOCAL:="UPTR"
HMENU:="UPTR"
HMETAFILE:="UPTR"
HMODULE:="UPTR"
HMONITOR:="UPTR"
HPALETTE:="UPTR"
HPEN:="UPTR"
HRGN:="UPTR"
HRSRC:="UPTR"
HSZ:="UPTR"
HWINSTA:="UPTR"
HWND:="UPTR"
LPARAM:="UPTR"
LPBOOL:="UPTR"
LPBYTE:="UPTR"
LPCOLORREF:="UPTR"
LPCSTR:="UPTR"
LPCTSTR:="UPTR"
LPCVOID:="UPTR"
LPCWSTR:="UPTR"
LPDWORD:="UPTR"
LPHANDLE:="UPTR"
LPINT:="UPTR"
LPLONG:="UPTR"
LPSTR:="UPTR"
LPTSTR:="UPTR"
LPVOID:="UPTR"
LPWORD:="UPTR"
LPWSTR:="UPTR"
PHANDLE:="UPTR"
PHKEY:="UPTR"
PINT:="UPTR"
PINT_PTR:="UPTR"
PINT32:="UPTR"
PINT64:="UPTR"
PLCID:="UPTR"
PLONG:="UPTR"
PLONGLONG:="UPTR"
PLONG_PTR:="UPTR"
PLONG32:="UPTR"
PLONG64:="UPTR"
POINTER_32:="UPTR"
POINTER_UNSIGNED:="UPTR"
PSHORT:="UPTR"
PSIZE_T:="UPTR"
PSSIZE_T:="UPTR"
PSTR:="UPTR"
PTBYTE:="UPTR"
PTCHAR:="UPTR"
PTSTR:="UPTR"
PUCHAR:="UPTR"
PUHALF_PTR:="UPTR"
PUINT:="UPTR"
PUINT_PTR:="UPTR"
PUINT32:="UPTR"
PUINT64:="UPTR"
PULONG:="UPTR"
PULONGLONG:="UPTR"
PULONG_PTR:="UPTR"
PULONG32:="UPTR"
PULONG64:="UPTR"
PUSHORT:="UPTR"
PVOID:="UPTR"
PWCHAR:="UPTR"
PWORD:="UPTR"
PWSTR:="UPTR"
SC_HANDLE:="UPTR"
SC_LOCK:="UPTR"
SERVICE_STATUS_HANDLE:="UPTR"
SIZE_T:="UPTR"
UINT_PTR:="UPTR"
ULONG_PTR:="UPTR"
ATOM:="Ushort"
LANGID:="Ushort"
WCHAR:="Ushort"
WORD:="Ushort"