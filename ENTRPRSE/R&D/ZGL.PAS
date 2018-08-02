unit ZGL;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

type
  TCOMGLCode = class(TAutoIntfObject, ICOMGLCode)
  private
    FEntSysObj : TEnterpriseSystem;
  protected
    function  Get_AccessRights: TRecordAccessStatus; safecall;
    function  Get_DataChanged: WordBool; safecall;
    function  Get_glCode: Integer; safecall;
    procedure Set_glCode(Value: Integer); safecall;
    function  Get_glName: WideString; safecall;
    procedure Set_glName(const Value: WideString); safecall;
    function  Get_glParent: Integer; safecall;
    procedure Set_glParent(Value: Integer); safecall;
    function  Get_glType: WideString; safecall;
    procedure Set_glType(const Value: WideString); safecall;
    function  Get_glAltCode: WideString; safecall;
    procedure Set_glAltCode(const Value: WideString); safecall;
    function  Get_glDefCurr: TCurrencyType; safecall;
    procedure Set_glDefCurr(Value: TCurrencyType); safecall;
  public
    Constructor Create;

    Procedure InitGLCode(EntSysObj : TEnterpriseSystem);
  End; { TCOMGLCode }

implementation

uses ComServ, CustIntU;

{-------------------------------------------------------------------------------------------------}

Constructor TCOMGLCode.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMGLCode);

End; { Create }

{-----------------------------------------}

Procedure TCOMGLCode.InitGLCode(EntSysObj : TEnterpriseSystem);
Begin { InitGLCode }
  FEntSysObj := EntSysObj;

End; { InitGLCode }

{-----------------------------------------}

function TCOMGLCode.Get_AccessRights: TRecordAccessStatus;
Begin { Get_AccessRights }
  Result := Ord(FEntSysObj.GLCode.AccessRights);
End; { Get_AccessRights }

{-----------------------------------------}

function TCOMGLCode.Get_DataChanged: WordBool;
Begin { Get_DataChanged }
  Result := FEntSysObj.GLCode.DataChanged;
End; { Get_DataChanged }

{-----------------------------------------}

function TCOMGLCode.Get_glCode: Integer;
Begin { Get_glCode }
  Result := FEntSysObj.GLCode.glCode;
End; { Get_glCode }

procedure TCOMGLCode.Set_glCode(Value: Integer);
Begin { Set_glCode }
  FEntSysObj.GLCode.glCode := Value;
End; { Set_glCode }

{-----------------------------------------}

function TCOMGLCode.Get_glName: WideString;
Begin { Get_glName }
  Result := FEntSysObj.GLCode.glName;
End; { Get_glName }

procedure TCOMGLCode.Set_glName(const Value: WideString);
Begin { Set_glName }
  FEntSysObj.GLCode.glName := Value;
End; { Set_glName }

{-----------------------------------------}

function TCOMGLCode.Get_glParent: Integer;
Begin { Get_glParent }
  Result := FEntSysObj.GLCode.glParent;
End; { Get_glParent }

procedure TCOMGLCode.Set_glParent(Value: Integer);
Begin { Set_glParent }
  FEntSysObj.GLCode.glParent := Value;
End; { Set_glParent }

{-----------------------------------------}

function TCOMGLCode.Get_glType: WideString;
Begin { Get_glType }
  Result := FEntSysObj.GLCode.glType;
End; { Get_glType }

procedure TCOMGLCode.Set_glType(const Value: WideString);
Var
  Ch : Char;
Begin { Set_glType }
  If (Length(Value) > 0) Then
    Ch := Chr(Ord(Value[1]))
  Else
    Ch := '*';

  FEntSysObj.GLCode.glType := Ch;
End; { Set_glType }

{-----------------------------------------}

function TCOMGLCode.Get_glAltCode: WideString;
Begin { Get_glAltCode }
  Result := FEntSysObj.GLCode.glAltCode;
End; { Get_glAltCode }

procedure TCOMGLCode.Set_glAltCode(const Value: WideString);
Begin { Set_glAltCode }
  FEntSysObj.GLCode.glAltCode := Value;
End; { Set_glAltCode }

{-----------------------------------------}

function TCOMGLCode.Get_glDefCurr: TCurrencyType;
Begin { Get_glDefCurr }
  Result := FEntSysObj.GLCode.glDefCurr;
End; { Get_glDefCurr }

procedure TCOMGLCode.Set_glDefCurr(Value: TCurrencyType);
Begin { Set_glDefCurr }
  FEntSysObj.GLCode.glDefCurr := Value;
End; { Set_glDefCurr }

end.

