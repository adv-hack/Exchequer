unit ZUserPro;

interface

uses
  ComObj, ActiveX, AxCtrls, Classes, Dialogs, StdVcl, SysUtils,
  Enterprise_TLB, CustTypU, CustAbsU, oUserPro;

type
  TCOMUserProfile = class(TAutoIntfObject, ICOMUserProfile,
                                           ICOMUserProfile2,  // PR: 18/08/2011 Changed for UserProfile2.  ABSEXCH-7994
                                           ICOMUserProfile3,  // PR: 12/07/2012 Added UserProfile3 ABSEXCH-12452
                                           ICOMUserProfile4,  // MH 06/09/2017 2017-R2 ABSEXCH-18855: Added new User Profile fields into Customisation
                                           ICOMUserProfile5)  //RB 22/11/2017 2018-R1 ABSEXCH-19403: GDPR (POST User Profile Mods) - 8.3.1.1.2 - DLL + COM Customisation Support

  private
    FD5UserProfile  : TAbsUserProfile5; //PR: 18/08/2011 Changed for UserProfile2.  ABSEXCH-7994
                                        //PR: 12/07/2012 Added UserProfile3 ABSEXCH-12452
                                        // MH 06/09/2017 2017-R2 ABSEXCH-18855: Added new User Profile fields into Customisation
                                        //RB 22/11/2017 2018-R1 ABSEXCH-19403: GDPR (POST User Profile Mods) - 8.3.1.1.2 - DLL + COM Customisation Support
  protected
    { Property methods }
    function Get_upUserId: WideString; safecall;
    function Get_upName: WideString; safecall;
    function Get_upEmail: WideString; safecall;
    function Get_upLockOutMins: Integer; safecall;
    function Get_upDefSRICust: WideString; safecall;
    function Get_upDefPPISupp: WideString; safecall;
    function Get_upDefCostCentre: WideString; safecall;
    function Get_upDefDepartment: WideString; safecall;
    function Get_upDefCCDeptRule: Integer; safecall;
    function Get_upDefLocation: WideString; safecall;
    function Get_upDefLocRule: Integer; safecall;
    function Get_upDefSalesBankGL: Integer; safecall;
    function Get_upDefPurchBankGL: Integer; safecall;
    function Get_upMaxSalesAuth: Double; safecall;
    function Get_upMaxPurchAuth: Double; safecall;
    function Get_upReportPrinter: WideString; safecall;
    function Get_upFormPrinter: WideString; safecall;
    function Get_upPwordExpiryMode: Integer; safecall;
    function Get_upPwordExpiryDays: Integer; safecall;
    function Get_upPwordExpiryDate: WideString; safecall;
    function Get_upSecurityFlags(Index: Integer): Integer; safecall;

    //PR: 18/08/2011 ABSEXCH-7994
    function Get_upShowGLCodesInTree: WordBool; safecall;

    //PR: 12/07/2012 Added UserProfile3 ABSEXCH-12452
    function Get_upShowProductTypesInTree: WordBool; safecall;
    function Get_upShowStockCodesInTree: WordBool; safecall;

    // MH 06/09/2017 2017-R2 ABSEXCH-18855: Added new User Profile fields into Customisation
    function Get_upWindowsUserID: WideString; safecall;
    procedure Set_upWindowsUserID(const Value: WideString); safecall;

    //RB 22/11/2017 2018-R1 ABSEXCH-19403: GDPR (POST User Profile Mods) - 8.3.1.1.2 - DLL + COM Customisation Support
    function Get_upHighlightPIIFields: WordBool; safecall;
    procedure Set_upHighlightPIIFields(Value: WordBool); safecall;
    function Get_upHighlighPIIColour: Integer; safecall;
    procedure Set_upHighlighPIIColour(Value: Integer); safecall;
  public
    Constructor Create;
    Destructor Destroy; Override;

    Procedure InitProfile(D5Profile : TAbsUserProfile);
  End; { TCOMUserProfile }

implementation

uses ComServ, CustIntU;

{-------------------------------------------------------------------------------------------------}

Constructor TCOMUserProfile.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ICOMUserProfile5);

End; { Create }

{-----------------------------------------}

Destructor TCOMUserProfile.Destroy;
Begin { Destroy }
  { Destroy Sub Objects }

  Inherited Destroy;
End; { Destroy }

{-----------------------------------------}

Procedure TCOMUserProfile.InitProfile(D5Profile : TAbsUserProfile);
Begin { InitProfile }
  FD5UserProfile := D5Profile as TAbsUserProfile5; //PR: 18/08/2011 Changed for UserProfile2.  ABSEXCH-7994
End; { InitProfile }

{-----------------------------------------}

function TCOMUserProfile.Get_upDefCCDeptRule: Integer;
begin
  Result := FD5UserProfile.upDefCCDeptRule;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upDefCostCentre: WideString;
begin
  Result := FD5UserProfile.upDefCostCentre;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upDefDepartment: WideString;
begin
  Result := FD5UserProfile.upDefDepartment;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upDefLocation: WideString;
begin
  Result := FD5UserProfile.upDefLocation;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upDefLocRule: Integer;
begin
  Result := FD5UserProfile.upDefLocRule;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upDefPPISupp: WideString;
begin
  Result := FD5UserProfile.upDefPPISupp;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upDefPurchBankGL: Integer;
begin
  Result := FD5UserProfile.upDefPurchBankGL;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upDefSalesBankGL: Integer;
begin
  Result := FD5UserProfile.upDefSalesBankGL;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upDefSRICust: WideString;
begin
  Result := FD5UserProfile.upDefSRICust;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upEmail: WideString;
begin
  Result := FD5UserProfile.upEmail;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upFormPrinter: WideString;
begin
  Result := FD5UserProfile.upFormPrinter;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upLockOutMins: Integer;
begin
  Result := FD5UserProfile.upLockOutMins;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upMaxPurchAuth: Double;
begin
  Result := FD5UserProfile.upMaxPurchAuth;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upMaxSalesAuth: Double;
begin
  Result := FD5UserProfile.upMaxSalesAuth;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upName: WideString;
begin
  Result := FD5UserProfile.upName;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upPwordExpiryDate: WideString;
begin
  Result := FD5UserProfile.upPwordExpiryDate;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upPwordExpiryDays: Integer;
begin
  Result := FD5UserProfile.upPwordExpiryDays;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upPwordExpiryMode: Integer;
begin
  Result := FD5UserProfile.upPwordExpiryMode;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upReportPrinter: WideString;
begin
  Result := FD5UserProfile.upReportPrinter;
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upSecurityFlags(Index: Integer): Integer;
begin
  Result := FD5UserProfile.upSecurityFlags[Index];
end;

{-----------------------------------------}

function TCOMUserProfile.Get_upUserId: WideString;
begin
  Result := FD5UserProfile.upUserId;
end;

//PR: 18/08/2011 ABSEXCH-7994
function TCOMUserProfile.Get_upShowGLCodesInTree: WordBool;
begin
  Result := FD5UserProfile.upShowGLCodesInTree;
end;

function TCOMUserProfile.Get_upShowProductTypesInTree: WordBool;
begin
  Result := FD5UserProfile.upShowProductTypesInTree;
end;

function TCOMUserProfile.Get_upShowStockCodesInTree: WordBool;
begin
  Result := FD5UserProfile.upShowStockCodesInTree;
end;

//-------------------------------------------------------------------------

// MH 06/09/2017 2017-R2 ABSEXCH-18855: Added new User Profile fields into Customisation
function TCOMUserProfile.Get_upWindowsUserID: WideString;
begin
  Result := FD5UserProfile.upWindowsUserID
end;
procedure TCOMUserProfile.Set_upWindowsUserID(const Value: WideString);
begin
  FD5UserProfile.upWindowsUserID := Value
end;

//-------------------------------------------------------------------------

//RB 22/11/2017 2018-R1 ABSEXCH-19403: GDPR (POST User Profile Mods) - 8.3.1.1.2 - DLL + COM Customisation Support
function TCOMUserProfile.Get_upHighlighPIIColour: Integer;
begin
  Result := FD5UserProfile.upHighlightPIIColour;
end;
procedure TCOMUserProfile.Set_upHighlighPIIColour(Value: Integer);
begin
  FD5UserProfile.upHighlightPIIColour := Value;
end;

//-------------------------------------------------------------------------

function TCOMUserProfile.Get_upHighlightPIIFields: WordBool;
begin
  Result := FD5UserProfile.upHighlightPIIFields;
end;
procedure TCOMUserProfile.Set_upHighlightPIIFields(Value: WordBool);
begin
  FD5UserProfile.upHighlightPIIFields := Value;
end;

//=========================================================================

end.
