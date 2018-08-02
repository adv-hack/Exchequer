unit zMiscDat;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

type
  TCOMMiscData = class(TAutoIntfObject, ICOMMiscData)
  private
    FEntSysObj : TEnterpriseSystem;
  protected
    function  Get_AccessRights: TRecordAccessStatus; safecall;
    function  Get_DataChanged: WordBool; safecall;
    function  Get_mdBoolean(Index: Integer): WordBool; safecall;
    procedure Set_mdBoolean(Index: Integer; Value: WordBool); safecall;
    function  Get_mdDouble(Index: Integer): Double; safecall;
    procedure Set_mdDouble(Index: Integer; Value: Double); safecall;
    function  Get_mdLongInt(Index: Integer): Integer; safecall;
    procedure Set_mdLongInt(Index: Integer; Value: Integer); safecall;
    function  Get_mdString(Index: Integer): WideString; safecall;
    procedure Set_mdString(Index: Integer; const Value: WideString); safecall;
    function  Get_mdVariant(Index: Integer): OleVariant; safecall;
    procedure Set_mdVariant(Index: Integer; Value: OleVariant); safecall;
  public
    Constructor Create;

    Procedure InitMiscData(EntSysObj : TEnterpriseSystem);
  End; { TCOMMiscData }

implementation

uses ComServ, CustIntU;

{-------------------------------------------------------------------------------------------------}

Constructor TCOMMiscData.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMMiscData);

End; { Create }

{-----------------------------------------}

Procedure TCOMMiscData.InitMiscData(EntSysObj : TEnterpriseSystem);
Begin { InitGLCode }
  FEntSysObj := EntSysObj;

End; { InitGLCode }

{-----------------------------------------}

function TCOMMiscData.Get_AccessRights: TRecordAccessStatus;
Begin { Get_AccessRights }
  Result := Ord(FEntSysObj.MiscData.AccessRights);
End; { Get_AccessRights }

{-----------------------------------------}

function TCOMMiscData.Get_DataChanged: WordBool;
Begin { Get_DataChanged }
  Result := FEntSysObj.MiscData.DataChanged;
End; { Get_DataChanged }

{-----------------------------------------}

function TCOMMiscData.Get_mdBoolean(Index: Integer): WordBool;
Begin { Get_mdBoolean }
  Result := FentSysObj.MiscData.mdBoolean[Index];
End; { Get_mdBoolean }

procedure TCOMMiscData.Set_mdBoolean(Index: Integer; Value: WordBool);
Begin { Set_mdBoolean }
  FentSysObj.MiscData.mdBoolean[Index] := Value;
End; { Set_mdBoolean }

{-----------------------------------------}

function TCOMMiscData.Get_mdDouble(Index: Integer): Double;
Begin { Get_mdDouble }
  Result := FentSysObj.MiscData.mdDouble[Index];
End; { Get_mdDouble }

procedure TCOMMiscData.Set_mdDouble(Index: Integer; Value: Double);
Begin { Set_mdDouble }
  FentSysObj.MiscData.mdDouble[Index] := Value;
End; { Set_mdDouble }

{-----------------------------------------}

function TCOMMiscData.Get_mdLongInt(Index: Integer): Integer;
Begin { Get_mdLongInt }
  Result := FentSysObj.MiscData.mdLongInt[Index];
End; { Get_mdLongInt }

procedure TCOMMiscData.Set_mdLongInt(Index: Integer; Value: Integer);
Begin { Set_mdLongInt }
  FentSysObj.MiscData.mdLongInt[Index] := Value;
End; { Set_mdLongInt }

{-----------------------------------------}

function TCOMMiscData.Get_mdString(Index: Integer): WideString;
Begin { Get_mdString }
  Result := FentSysObj.MiscData.mdString[Index];
End; { Get_mdString }

procedure TCOMMiscData.Set_mdString(Index: Integer; const Value: WideString);
Begin { Set_mdString }
  FentSysObj.MiscData.mdString[Index] := Value;
End; { Set_mdString }

{-----------------------------------------}

function TCOMMiscData.Get_mdVariant(Index: Integer): OleVariant;
Begin { Get_mdVariant }
  Result := FentSysObj.MiscData.mdVariant[Index];
End; { Get_mdVariant }

procedure TCOMMiscData.Set_mdVariant(Index: Integer; Value: OleVariant);
Begin { Set_mdVariant }
  FentSysObj.MiscData.mdVariant[Index] := Value;
End; { Set_mdVariant }

{-----------------------------------------}

end.

