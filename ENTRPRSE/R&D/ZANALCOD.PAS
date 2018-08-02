unit zAnalCod;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU;

type
  TCOMJobAnalysis = class(TAutoIntfObject, ICOMJobAnalysis, ICOMJobAnalysis2)
  private
    FEntSysObj   : TEnterpriseSystem;
    FJobAnalysis : TAbsJobAnalysis2;
  protected
    { Property methods }
    function Get_AccessRights: TRecordAccessStatus; safecall;
    function Get_anCode: WideString; safecall;
    procedure Set_anCode(const Value: WideString); safecall;
    function Get_anDescription: WideString; safecall;
    procedure Set_anDescription(const Value: WideString); safecall;
    function Get_anType: Integer; safecall;
    procedure Set_anType(Value: Integer); safecall;
    function Get_anCategory: Integer; safecall;
    procedure Set_anCategory(Value: Integer); safecall;
    function Get_anWIPGL: Integer; safecall;
    procedure Set_anWIPGL(Value: Integer); safecall;
    function Get_anPandLGL: Integer; safecall;
    procedure Set_anPandLGL(Value: Integer); safecall;
    function Get_anLineType: Integer; safecall;
    procedure Set_anLineType(Value: Integer); safecall;

    // ICOMJobAnalysis2
    function Get_anDeductType: Integer; safecall;
    procedure Set_anDeductType(Value: Integer); safecall;
    function Get_anCalcDeductBeforeRetent: WordBool; safecall;
    procedure Set_anCalcDeductBeforeRetent(Value: WordBool); safecall;
    function Get_anDeductAnalysisMode: Integer; safecall;
    procedure Set_anDeductAnalysisMode(Value: Integer); safecall;
    function Get_anDeductCalcMode: Integer; safecall;
    procedure Set_anDeductCalcMode(Value: Integer); safecall;
    function Get_anPayrollDeductCode: WideString; safecall;
    procedure Set_anPayrollDeductCode(const Value: WideString); safecall;
    function Get_anRetentionType: Integer; safecall;
    procedure Set_anRetentionType(Value: Integer); safecall;
    function Get_anRetentionPercentage: Double; safecall;
    procedure Set_anRetentionPercentage(Value: Double); safecall;
    function Get_anRetentionExpiryMode: Integer; safecall;
    procedure Set_anRetentionExpiryMode(Value: Integer); safecall;
    function Get_anRetentionExpiryInterval: Integer; safecall;
    procedure Set_anRetentionExpiryInterval(Value: Integer); safecall;
    function Get_anPreserveToRetention: WordBool; safecall;
    procedure Set_anPreserveToRetention(Value: WordBool); safecall;
  public
    Constructor Create;

    procedure InitJobAnalysis(EntSysObj: TEnterpriseSystem);
  End; { TCOMJobAnalysis }

implementation

uses ComServ, CustIntU, ZUtils;

//=========================================================================

Constructor TCOMJobAnalysis.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMJobAnalysis2);

  FEntSysObj := Nil;
End; { Create }

//-------------------------------------------------------------------------

procedure TCOMJobAnalysis.InitJobAnalysis(EntSysObj: TEnterpriseSystem);
begin
  FEntSysObj := EntSysObj;
  FJobAnalysis := FEntSysObj.JobCosting.JobAnalysis As TAbsJobAnalysis2;
end;

//-------------------------------------------------------------------------

function TCOMJobAnalysis.Get_AccessRights: TRecordAccessStatus;
begin
  Result := Ord(FJobAnalysis.AccessRights);
end;

//------------------------------

function TCOMJobAnalysis.Get_anCode: WideString;
begin
  Result := FJobAnalysis.anCode;
end;

procedure TCOMJobAnalysis.Set_anCode(const Value: WideString);
begin
  FJobAnalysis.anCode := Value;
end;

//------------------------------

function TCOMJobAnalysis.Get_anDescription: WideString;
begin
  Result := FJobAnalysis.anDescription;
end;

procedure TCOMJobAnalysis.Set_anDescription(const Value: WideString);
begin
  FJobAnalysis.anDescription := Value;
end;

//------------------------------

function TCOMJobAnalysis.Get_anType: Integer;
begin
  Result := FJobAnalysis.anType;
end;

procedure TCOMJobAnalysis.Set_anType(Value: Integer);
begin
  FJobAnalysis.anType := Value;
end;

//------------------------------

function TCOMJobAnalysis.Get_anCategory: Integer;
begin
  Result := FJobAnalysis.anCategory;
end;

procedure TCOMJobAnalysis.Set_anCategory(Value: Integer);
begin
  FJobAnalysis.anCategory := Value;
end;

//------------------------------

function TCOMJobAnalysis.Get_anWIPGL: Integer;
begin
  Result := FJobAnalysis.anWIPGL;
end;

procedure TCOMJobAnalysis.Set_anWIPGL(Value: Integer);
begin
  FJobAnalysis.anWIPGL := Value;
end;

//------------------------------

function TCOMJobAnalysis.Get_anPandLGL: Integer;
begin
  Result := FJobAnalysis.anPandLGL;
end;

procedure TCOMJobAnalysis.Set_anPandLGL(Value: Integer);
begin
  FJobAnalysis.anPandLGL := Value;
end;

//------------------------------

function TCOMJobAnalysis.Get_anLineType: Integer;
begin
  Result := FJobAnalysis.anLineType;
end;

procedure TCOMJobAnalysis.Set_anLineType(Value: Integer);
begin
  FJobAnalysis.anLineType := Value;
end;

//------------------------------

function TCOMJobAnalysis.Get_anDeductType: Integer;
begin
  Result := FJobAnalysis.anDeductType;
end;

procedure TCOMJobAnalysis.Set_anDeductType(Value: Integer);
begin
  FJobAnalysis.anDeductType := Value;
end;

//------------------------------

function TCOMJobAnalysis.Get_anCalcDeductBeforeRetent: WordBool;
begin
  Result := FJobAnalysis.anCalcDeductBeforeRetent;
end;

procedure TCOMJobAnalysis.Set_anCalcDeductBeforeRetent(Value: WordBool);
begin
  FJobAnalysis.anCalcDeductBeforeRetent := Value;
end;

//------------------------------

function TCOMJobAnalysis.Get_anDeductAnalysisMode: Integer;
begin
  Result := FJobAnalysis.anDeductAnalysisMode;
end;

procedure TCOMJobAnalysis.Set_anDeductAnalysisMode(Value: Integer);
begin
  FJobAnalysis.anDeductAnalysisMode := Value;
end;

//------------------------------

function TCOMJobAnalysis.Get_anDeductCalcMode: Integer;
begin
  Result := FJobAnalysis.anDeductCalcMode;
end;

procedure TCOMJobAnalysis.Set_anDeductCalcMode(Value: Integer);
begin
  FJobAnalysis.anDeductCalcMode := Value;
end;

//------------------------------

function TCOMJobAnalysis.Get_anPayrollDeductCode: WideString;
begin
  Result := FJobAnalysis.anPayrollDeductCode;
end;

procedure TCOMJobAnalysis.Set_anPayrollDeductCode(const Value: WideString);
begin
  FJobAnalysis.anPayrollDeductCode := Value;
end;

//------------------------------

function TCOMJobAnalysis.Get_anRetentionType: Integer;
begin
  Result := FJobAnalysis.anRetentionType;
end;

procedure TCOMJobAnalysis.Set_anRetentionType(Value: Integer);
begin
  FJobAnalysis.anRetentionType := Value;
end;

//------------------------------

function TCOMJobAnalysis.Get_anRetentionPercentage: Double;
begin
  Result := FJobAnalysis.anRetentionPercentage;
end;

procedure TCOMJobAnalysis.Set_anRetentionPercentage(Value: Double);
begin
  FJobAnalysis.anRetentionPercentage := Value;
end;

//------------------------------

function TCOMJobAnalysis.Get_anRetentionExpiryMode: Integer;
begin
  Result := FJobAnalysis.anRetentionExpiryMode;
end;

procedure TCOMJobAnalysis.Set_anRetentionExpiryMode(Value: Integer);
begin
  FJobAnalysis.anRetentionExpiryMode := Value;
end;

//------------------------------

function TCOMJobAnalysis.Get_anRetentionExpiryInterval: Integer;
begin
  Result := FJobAnalysis.anRetentionExpiryInterval;
end;

procedure TCOMJobAnalysis.Set_anRetentionExpiryInterval(Value: Integer);
begin
  FJobAnalysis.anRetentionExpiryInterval := Value;
end;

//------------------------------

function TCOMJobAnalysis.Get_anPreserveToRetention: WordBool;
begin
  Result := FJobAnalysis.anPreserveToRetention;
end;

procedure TCOMJobAnalysis.Set_anPreserveToRetention(Value: WordBool);
begin
  FJobAnalysis.anPreserveToRetention := Value;
end;

//=========================================================================

end.
