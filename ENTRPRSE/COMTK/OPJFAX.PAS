unit oPJFax;

interface

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},// COM Toolkit Type Library
     EnterpriseForms_TLB,      // Forms Toolkit Type Library
     ExceptIntf;

Type
  TPrintJobFaxInfo = class(TAutoIntfObjectEx, IPrintJobFaxInfo)
  private
    FFTKFax : IEFPrintJobFaxInfo;
  protected
    // IPrintJobFaxInfo
    function Get_fxType: TFaxMethod; safecall;
    function Get_fxSenderName: WideString; safecall;
    procedure Set_fxSenderName(const Value: WideString); safecall;
    function Get_fxSenderFaxNumber: WideString; safecall;
    procedure Set_fxSenderFaxNumber(const Value: WideString); safecall;
    function Get_fxRecipientName: WideString; safecall;
    procedure Set_fxRecipientName(const Value: WideString); safecall;
    function Get_fxRecipientFaxNumber: WideString; safecall;
    procedure Set_fxRecipientFaxNumber(const Value: WideString); safecall;
    function Get_fxFaxPrinterIndex: Integer; safecall;
    property fxType: TFaxMethod read Get_fxType;
    function Get_fxFaxingPath: WideString; safecall;
    function Get_fxCoverSheet: WideString; safecall;
    procedure Set_fxCoverSheet(const Value: WideString); safecall;
    function Get_fxPriority: TFaxPriority; safecall;
    procedure Set_fxPriority(Value: TFaxPriority); safecall;
    function Get_fxMessageText: WideString; safecall;
    procedure Set_fxMessageText(const Value: WideString); safecall;
    function Get_fxFaxDescription: WideString; safecall;
    procedure Set_fxFaxDescription(const Value: WideString); safecall;
  public
    Constructor Create (Const FTKFax : IEFPrintJobFaxInfo);
    Destructor Destroy; override;
  End; { TPrintJobFaxInfo }

implementation

uses ComServ,
     Miscfunc;     // Miscellaneous Types and routines for COMTK

Constructor TPrintJobFaxInfo.Create (Const FTKFax : IEFPrintJobFaxInfo);
Begin { Create }
  Inherited Create(ComServer.TypeLib, IPrintJobFaxInfo);

  FFTKFax := FTKFax;
End; { Create }

//----------------------------------------

Destructor TPrintJobFaxInfo.Destroy;
Begin { Destroy }
  FFTKFax := NIL;

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

function TPrintJobFaxInfo.Get_fxType: TFaxMethod;
begin
  Case FFTKFax.fxType Of
  {$IFNDEF WANTEXE}
    EnterpriseForms_TLB.ftEnterpriseEComms : Result := Enterprise01_TLB.fmEnterprise;
    EnterpriseForms_TLB.ftMAPI             : Result := Enterprise01_TLB.fmMAPI;
    EnterpriseForms_TLB.ftThirdParty       : Result := Enterprise01_TLB.fmThirdParty;
  {$ELSE}
    EnterpriseForms_TLB.ftEnterpriseEComms : Result := Enterprise04_TLB.fmEnterprise;
    EnterpriseForms_TLB.ftMAPI             : Result := Enterprise04_TLB.fmMAPI;
    EnterpriseForms_TLB.ftThirdParty       : Result := Enterprise04_TLB.fmThirdParty;
  {$ENDIF}
  Else
    Raise EUnknownValue.Create ('Unknown Faxing Type (' + IntToStr(Ord(FFTKFax.fxType)) + ')');
  End; { Case FFTKEmail.emType }
end;

//----------------------------------------

function TPrintJobFaxInfo.Get_fxFaxPrinterIndex: Integer;
begin
  Result := FFTKFax.fxFaxPrinterIndex;
end;

//----------------------------------------

function TPrintJobFaxInfo.Get_fxSenderName: WideString;
begin
  Result := FFTKFax.fxSenderName;
end;

procedure TPrintJobFaxInfo.Set_fxSenderName(const Value: WideString);
begin
  FFTKFax.fxSenderName := Value;
end;

//----------------------------------------

function TPrintJobFaxInfo.Get_fxSenderFaxNumber: WideString;
begin
  Result := FFTKFax.fxSenderFaxNumber;
end;

procedure TPrintJobFaxInfo.Set_fxSenderFaxNumber(const Value: WideString);
begin
  FFTKFax.fxSenderFaxNumber := Value;
end;

//----------------------------------------

function TPrintJobFaxInfo.Get_fxRecipientName: WideString;
begin
  Result := FFTKFax.fxRecipientName;
end;

procedure TPrintJobFaxInfo.Set_fxRecipientName(const Value: WideString);
begin
  FFTKFax.fxRecipientName := Value;
end;

//----------------------------------------

function TPrintJobFaxInfo.Get_fxRecipientFaxNumber: WideString;
begin
  Result := FFTKFax.fxRecipientFaxNumber;
end;

procedure TPrintJobFaxInfo.Set_fxRecipientFaxNumber(const Value: WideString);
begin
  FFTKFax.fxRecipientFaxNumber := Value;
end;

//----------------------------------------

function TPrintJobFaxInfo.Get_fxFaxingPath: WideString;
begin
  Result := FFTKFax.fxFaxingPath;
end;

//----------------------------------------

function TPrintJobFaxInfo.Get_fxCoverSheet: WideString;
begin
  Result := FFTKFax.fxCoverSheet;
end;

procedure TPrintJobFaxInfo.Set_fxCoverSheet(const Value: WideString);
begin
  FFTKFax.fxCoverSheet := Value;
end;

//----------------------------------------

function TPrintJobFaxInfo.Get_fxPriority: TFaxPriority;
begin
  Case FFTKFax.fxPriority Of
  {$IFNDEF WANTEXE}
    EnterpriseForms_TLB.fpOffPeak : Result := Enterprise01_TLB.fpOffPeak;
    EnterpriseForms_TLB.fpNormal  : Result := Enterprise01_TLB.fpNormal;
    EnterpriseForms_TLB.fpUrgent  : Result := Enterprise01_TLB.fpUrgent;
  {$ELSE}
    EnterpriseForms_TLB.fpOffPeak : Result := Enterprise04_TLB.fpOffPeak;
    EnterpriseForms_TLB.fpNormal  : Result := Enterprise04_TLB.fpNormal;
    EnterpriseForms_TLB.fpUrgent  : Result := Enterprise04_TLB.fpUrgent;
  {$ENDIF}
  Else
    Raise EUnknownValue.Create ('Unknown Fax Priority (' + IntToStr(Ord(FFTKFax.fxPriority)) + ')');
  End; { Case FFTKEmail.emType }
end;

procedure TPrintJobFaxInfo.Set_fxPriority(Value: TFaxPriority);
begin
  Case Value Of
  {$IFNDEF WANTEXE}
    Enterprise01_TLB.fpOffPeak : FFTKFax.fxPriority := EnterpriseForms_TLB.fpOffPeak;
    Enterprise01_TLB.fpNormal  : FFTKFax.fxPriority := EnterpriseForms_TLB.fpNormal;
    Enterprise01_TLB.fpUrgent  : FFTKFax.fxPriority := EnterpriseForms_TLB.fpUrgent;
  {$ELSE}
    Enterprise04_TLB.fpOffPeak : FFTKFax.fxPriority := EnterpriseForms_TLB.fpOffPeak;
    Enterprise04_TLB.fpNormal  : FFTKFax.fxPriority := EnterpriseForms_TLB.fpNormal;
    Enterprise04_TLB.fpUrgent  : FFTKFax.fxPriority := EnterpriseForms_TLB.fpUrgent;
  {$ENDIF}
  Else
    Raise EUnknownValue.Create ('Unknown Fax Priority (' + IntToStr(Ord(Value)) + ')');
  End; { Case FFTKEmail.emType }
end;

//----------------------------------------

function TPrintJobFaxInfo.Get_fxMessageText: WideString;
begin
  Result := FFTKFax.fxMessageText;
end;

procedure TPrintJobFaxInfo.Set_fxMessageText(const Value: WideString);
begin
  FFTKFax.fxMessageText := Value;
end;

//----------------------------------------

function TPrintJobFaxInfo.Get_fxFaxDescription: WideString;
begin
  Result := FFTKFax.fxFaxDescription;
end;

procedure TPrintJobFaxInfo.Set_fxFaxDescription(const Value: WideString);
begin
  FFTKFax.fxFaxDescription := Value;
end;

//-----------------------------------------------------------------------------

end.
