﻿ScriptStruct(){
static GUID:="ulong  Data1,ushort Data2,ushort Data3,uchar Data4[8]"
  ,NOTIFYICONDATA :="DWORD cbSize,HWND hWnd,UINT uID,UINT uFlags,UINT uCallbackMessage,HICON hIcon,WCHAR szTip[128],DWORD dwState,DWORD dwStateMask,WCHAR szInfo[256],{UINT uTimeout,UINT uVersion},WCHAR szInfoTitle[64],DWORD dwInfoFlags,ScriptStruct(GUID) guidItem"
  ,FuncParam := "ScriptStruct(Var) *var,WORD is_byref,default_type,{LPTSTR default_str,Int64 default_int64,Double default_double}"
    ,Func:="PTR vTable,LPTSTR mName,{struct{ScriptStruct(Line) *mJumpToLine,ScriptStruct(FuncParam) *mParam,PTR *mClass},struct{PTR mBIF,UCHAR *mOutputVars,PTR mID}},Int mParamCount,MinParams,ScriptStruct(Label) *mFirstLabel,*mLastLabel,ScriptStruct(Var) **mGlobalvar,**mVar,**mLazyVar,**mStaticVar,**mStaticLazyVar,Int mGlobalVarCount,mVarCount,mVarCountMax,mLazyVarCount,mStaticVarCount,mStaticLazyVarCount,Instances,BYTE mDefaultVarType,bool mIsBuiltIn,mIsVariadic,mHasReturn"
    ,Var:="{Int64 mContentsInt64,Double mContentsDouble,PTR mobject,PTR mVV},{char *mByteContents,LPTSTR mCharContents},{UINT_PTR mLength,ScriptStruct(Var) *mAliasFor},{UINT_PTR mCapacity,UINT_PTR mBIV},BYTE mHowAllocated,mAttrib,mScope,mType,LPTSTR mName"
  ,ExprTokenType:="{__int64 value_int64,double value_double,struct{{PTR *object,ScriptStruct(DerefType) *deref,ScriptStruct(Var) *var,LPTSTR marker},{LPTSTR buf,size_t marker_length}}},UINT symbol,{ScriptStruct(ExprTokenType) *circuit_token,LPTSTR mem_to_free}"
  ,DerefType:="LPTSTR marker,{ScriptStruct(Var) *var,ScriptStruct(Func) *func,ScriptStruct(DerefType) *next,int symbol},Byte type,BYTE param_count,WORD length"
  ,ArgStruct:="BYTE type,bool is_expression,WORD length,LPTSTR text,ScriptStruct(DerefType) *deref,ScriptStruct(ExprTokenType) *postfix"
  ,BreakPoint := "INT id,BYTE type,BYTE state,bool temporary"
  ,Line:="BYTE mActionType,mArgc,WORD mFileIndex,UINT mLineNumber,ScriptStruct(ArgStruct) *mArg,PTR *mAttribute,ScriptStruct(Line) *mPrevLine,*mNextLine,*mRelatedLine,*mParentLine,ScriptStruct(BreakPoint) *mBreakPoint"
  ,Label:="LPTSTR mName,ScriptStruct(Line) *mJumpToLine,ScriptStruct(Label) *mPrevLabel,*mNextLabel"
  ,ScriptTimer:="ScriptStruct(Label) *mLabel,DWORD mPeriod,DWORD mTimeLastRun,int mPriority,UCHAR mExistingThreads,bool mEnabled,bool mRunOnlyOnce,ScriptStruct(ScriptTimer) *mNextTimer"
  ,UserMenuItem:="LPTSTR mName,size_t mNameCapacity,UINT mMenuID,ScriptStruct(Label) *mLabel,ScriptStruct(UserMenu) *mSubmenu,ScriptStruct(UserMenu) *mMenu,int mPriority,bool mEnabled,bool mChecked,ScriptStruct(UserMenuItem) *mNextMenuItem,{HICON mIcon,HBITMAP mBitmap}"
  ,UserMenu:="LPTSTR mName,ScriptStruct(UserMenuItem) *mFirstMenuItem,ScriptStruct(UserMenuItem) *mLastMenuItem,ScriptStruct(UserMenuItem) *mDefault,bool mIncludeStandardItems,int mClickCount,UINT mMenuItemCount,ScriptStruct(UserMenu) *mNextMenu,HMENU mMenu,int mMenuType,PTR mBrush,DWORD mColor"
  ,CStringW:="UInt m_sNull,PTR m_pData,bool m_bDirty"
  ,WinGroup:="LPTSTR mName;ScriptStruct(WindowSpec) *mFirstWindow, *mLastWindow;ScriptStruct(WinGroup) *mNextGroup;UINT mWindowCount"
  ,WindowSpec:="LPTSTR mTitle, mText, mExcludeTitle, mExcludeText,ScriptStruct(WindowSpec) *mNextWindow"
  ,Script:="ScriptStruct(Var) **mVar,**mLazyVar;int mVarCount,mVarCountMax,mLazyVarCount;ScriptStruct(WinGroup) *mFirstGroup,*mLastGroup;int mCurrentFuncOpenBlockCount;bool mNextLineIsFunctionBody;int mClassObjectCount;PTR *mClassObject[5];TCHAR mClassName[256];PTR *mUnresolvedClasses;PTR *mClassProperty;LPTSTR mClassPropertyDef;int mCurrFileIndex;UINT mCombinedLineNumber;bool mNoHotkeyLabels,mMenuUseErrorLevel;ScriptStruct(NOTIFYICONDATA) mNIC;ScriptStruct(Line) *mFirstLine,*mLastLine,*mFirstStaticLine,*mLastStaticLine;ScriptStruct(Label) *mFirstLabel,*mLastLabel;ScriptStruct(Func) **mFunc;int mFuncCount,mFuncCountMax;ScriptStruct(Line) *mTempLine;ScriptStruct(Label) *mTempLabel;ScriptStruct(Func) *mTempFunc;ScriptStruct(Line) *mCurrLine;ScriptStruct(Label) *mPlaceholderLabel;TCHAR mThisMenuItemName[261],mThisMenuName[261];LPTSTR mThisHotkeyName,mPriorHotkeyName;HWND mNextClipboardViewer;bool mOnClipboardChangeIsRunning;ScriptStruct(Func) *mOnClipboardChangeFunc,*mOnExitFunc;int mExitReason;ScriptStruct(ScriptTimer) *mFirstTimer,*mLastTimer;UINT mTimerCount,mTimerEnabledCount;ScriptStruct(UserMenu) *mFirstMenu,*mLastMenu;UINT mMenuCount;DWORD mThisHotkeyStartTime,mPriorHotkeyStartTime;TCHAR mEndChar;BYTE mThisHotkeyModifiersLR;LPTSTR mFileSpec,mFileDir,mFileName,mOurEXE,mOurEXEDir,mMainWindowTitle;bool mIsReadyToExecute,mAutoExecSectionIsRunning,mIsRestart,mErrorStdOut;PTR *mIncludeLibraryFunctionsThenExit;int mUninterruptedLineCountMax,mUninterruptibleTime;DWORD mLastPeekTime;ScriptStruct(CStringW) mRunAsUser,mRunAsPass,mRunAsDomain;HICON mCustomIcon,mCustomIconSmall;LPTSTR mCustomIconFile;bool mIconFrozen;LPTSTR mTrayIconTip;UINT mCustomIconNumber;ScriptStruct(UserMenu) *mTrayMenu"
  ,s:=Struct(Script,A_ScriptStruct)
  return s
}