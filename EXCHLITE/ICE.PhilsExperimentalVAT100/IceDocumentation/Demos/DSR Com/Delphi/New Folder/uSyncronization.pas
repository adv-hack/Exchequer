Unit uSyncronization;

Interface

Uses
  Windows, ActiveX, ComObj, ComCaller_TLB;

Type
  TSyncEvent = Procedure(pNewMsg: Longword) Of Object;

  TDSRSink = Class(TInterfacedObject, IUnknown, IDispatch)
  Private
    fUpdateInbox,
    fUpdateOutbox: TSyncEvent;
  Protected
    //Method resolution clause to allow QueryInterface to be redefined
    Function QueryInterface(Const IID: TGUID; Out Obj): HResult; Stdcall;
    Function GetTypeInfoCount(Out Count: Integer): HResult; Stdcall;
    Function GetTypeInfo(Index, LocaleID: Integer; Out TypeInfo): HResult;
      Stdcall;
    Function GetIDsOfNames(Const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; Stdcall;
    Function Invoke(DispID: Integer; Const IID: TGUID; LocaleID: Integer;
      Flags: Word; Var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult;
      Stdcall;
  Published
    Property OnUpdateInbox: TSyncEvent Read fUpdateInbox Write fUpdateInbox;
    property OnUpdateOutbox: TSyncEvent Read fUpdateOutbox Write fUpdateOutbox;
  End;

Implementation

{ TDSRSink }

Function TDSRSink.GetIDsOfNames(Const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
Begin
  Result := E_NOTIMPL;
End;

Function TDSRSink.GetTypeInfo(Index, LocaleID: Integer;
  Out TypeInfo): HResult;
Begin
  Result := E_NOTIMPL;
End;

Function TDSRSink.GetTypeInfoCount(Out Count: Integer): HResult;
Begin
  Count := 0;
  Result := S_OK;
End;

Function TDSRSink.Invoke(DispID: Integer; Const IID: TGUID;
  LocaleID: Integer; Flags: Word; Var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HResult;
Var
  Args: PVariantArgList;
  lNewMsg: Longword;
Begin
  Result := S_OK;
  //This is called to trigger an event interface method, if implemented
  //We need to check which one it is (by DispID) and do something sensible if we
  //support the triggered event
  lNewMsg := 0;

  //extract the params
  Try
    Args := TDispParams(Params).rgvarg;
  //Params are in reverse order:
  //Last parameter is at pos. 0
  //First parameter is at pos. cArgs - 1
    lNewMsg := OleVariant(Args^[0]);
  Except
  End;

  Case DispID Of
    1: {update inbox}
      If Assigned(fUpdateInbox) Then
        fUpdateInbox(lNewMsg);
       {update outbox} 
    2: if Assigned(fUpdateOutbox) then
       fUpdateOutbox(lNewMsg);
  End
End;

Function TDSRSink.QueryInterface(Const IID: TGUID; Out Obj): HResult;
Begin
  Result := E_NOINTERFACE;
  //If events interface requested, return IDispatch
  // use the following string guid
  If IsEqualIID(IID, DIID_IDSRCOMCallerEvents) Then
  Begin
    If GetInterface(IDispatch, Obj) Then
      Result := S_OK
  End
  Else If GetInterface(IID, Obj) Then
    {Handle other interface requests normally}
    Result := S_OK
End;

End.

