unit ZCCDept;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

type
  TCOMCCDept = class(TAutoIntfObject, ICOMCCDept)
  private
    CCDept     : TAbsCCDept;
    FEntSysObj : TEnterpriseSystem;
  protected
    function  Get_AccessRights: TRecordAccessStatus; safecall;
    function  Get_DataChanged: WordBool; safecall;
    function  Get_cdCode: WideString; safecall;
    procedure Set_cdCode(const Value: WideString); safecall;
    function  Get_cdDescription: WideString; safecall;
    procedure Set_cdDescription(const Value: WideString); safecall;
    function  Get_cdTag: WordBool; safecall;
    procedure Set_cdTag(Value: WordBool); safecall;
    function  Get_cdLastAccessDate: WideString; safecall;
    procedure Set_cdLastAccessDate(const Value: WideString); safecall;
  public
    Constructor Create;

    Procedure InitCCDept(RecType : Char; EntSysObj : TEnterpriseSystem);
  End; { TCOMSetupUserFields }

implementation

uses ComServ, CustIntU;

{-------------------------------------------------------------------------------------------------}

Constructor TCOMCCDept.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMCCDept);

End; { Create }

{-----------------------------------------}

Procedure TCOMCCDept.InitCCDept(RecType : Char; EntSysObj : TEnterpriseSystem);
Begin { InitCCDept }
  FEntSysObj := EntSysObj;

  If (RecType = 'C') Then
    CCDept := FEntSysObj.CostCentre
  Else
    CCDept := FEntSysObj.Department;
End; { InitCCDept }

{-----------------------------------------}

function TCOMCCDept.Get_AccessRights: TRecordAccessStatus;
Begin { Get_AccessRights }
  Result := Ord(CCDept.AccessRights);
End; { Get_AccessRights }

{-----------------------------------------}

function TCOMCCDept.Get_DataChanged: WordBool;
Begin { Get_DataChanged }
  Result := CCDept.DataChanged;
End; { Get_DataChanged }

{-----------------------------------------}

function TCOMCCDept.Get_cdCode: WideString;
Begin { Get_cdCode }
  Result := CCDept.cdCode;
End; { Get_cdCode }

procedure TCOMCCDept.Set_cdCode(const Value: WideString);
Begin { Set_cdCode }
  CCDept.cdCode := Value;
End; { Set_cdCode }

{-----------------------------------------}

function TCOMCCDept.Get_cdDescription: WideString;
Begin { Get_cdDescription }
  Result := CCDept.cdDescription;
End; { Get_cdDescription }

procedure TCOMCCDept.Set_cdDescription(const Value: WideString);
Begin { Set_cdDescription }
  CCDept.cdDescription := Value;
End; { Set_cdDescription }

{-----------------------------------------}

function TCOMCCDept.Get_cdTag: WordBool;
Begin { Get_cdTag }
  Result := CCDept.cdTag;
End; { Get_cdTag }

procedure TCOMCCDept.Set_cdTag(Value: WordBool);
Begin { Set_cdTag }
  CCDept.cdTag := Value;
End; { Set_cdTag }

{-----------------------------------------}

function TCOMCCDept.Get_cdLastAccessDate: WideString;
Begin { Get_cdLastAccessDate }
  Result := CCDept.cdLastAccessDate;
End; { Get_cdLastAccessDate }

procedure TCOMCCDept.Set_cdLastAccessDate(const Value: WideString);
Begin { Set_cdLastAccessDate }
  CCDept.cdLastAccessDate := Value;
End; { Set_cdLastAccessDate }


end.

