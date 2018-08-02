unit oPJEmail;

interface

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},         // COM Toolkit Type Library
     EnterpriseForms_TLB,      // Forms Toolkit Type Library
     oPJEmail2,                // Email Recipient sub-object    (IEmailAddressArray)
     oPJEmail3,                // Email Attachments sub-object  (IEmailAttachments)
     ExceptIntf;

Type
  TPrintJobEmailInfo = class(TAutoIntfObjectEx, IPrintJobEmailInfo)
  private
    // Local reference to Email Info sub-object within the Forms TK PrintJob object
    FFTKEmail  : IEFPrintJobEmailInfo;

    // Local reference to base PrintJob object within the COM Toolkit
    FCTKPrintJob : TObject;

    // Email To sub-object
    FEmailToO  : TEmailAddressArray;
    FEmailToI  : IEmailAddressArray;

    // Email CC sub-object
    FEmailCCO  : TEmailAddressArray;
    FEmailCCI  : IEmailAddressArray;

    // Email BCC sub-object
    FEmailBCCO : TEmailAddressArray;
    FEmailBCCI : IEmailAddressArray;

    // Email Attachments sub-object
    FFileAttachO : TEmailAttachments;
    FFileAttachI : IEmailAttachments;
  protected
    // IPrintJobEmailInfo
    function Get_emType: TEmailType; safecall;
    function Get_emSenderName: WideString; safecall;
    procedure Set_emSenderName(const Value: WideString); safecall;
    function Get_emSenderAddress: WideString; safecall;
    procedure Set_emSenderAddress(const Value: WideString); safecall;
    function Get_emToRecipients: IEmailAddressArray; safecall;
    function Get_emCCRecipients: IEmailAddressArray; safecall;
    function Get_emBCCRecipients: IEmailAddressArray; safecall;
    function Get_emSubject: WideString; safecall;
    procedure Set_emSubject(const Value: WideString); safecall;
    function Get_emMessageText: WideString; safecall;
    procedure Set_emMessageText(const Value: WideString); safecall;
    function Get_emAttachments: IEmailAttachments; safecall;
    function Get_emPriority: TEmailPriority; safecall;
    procedure Set_emPriority(Value: TEmailPriority); safecall;
    function Get_emCoverSheet: WideString; safecall;
    procedure Set_emCoverSheet(const Value: WideString); safecall;
    function Get_emSMTPServer: WideString; safecall;
    function Get_emFormCompression: TEmailAttachmentZIPType; safecall;
    procedure Set_emFormCompression(Value: TEmailAttachmentZIPType); safecall;
    function Get_emSendReader: WordBool; safecall;
    procedure Set_emSendReader(Value: WordBool); safecall;
  public
    Constructor Create (Const CTKPrintJob : TObject; Const FTKEmail : IEFPrintJobEmailInfo);
    Destructor Destroy; override;
  End; { TPrintJobEmailInfo }

implementation

uses ComServ,
     Miscfunc;     // Miscellaneous Types and routines for COMTK

//-----------------------------------------------------------------------------

Constructor TPrintJobEmailInfo.Create (Const CTKPrintJob : TObject; Const FTKEmail : IEFPrintJobEmailInfo);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IPrintJobEmailInfo);

  FCTKPrintJob := CTKPrintJob;
  FFTKEmail := FTKEmail;

  // Email To sub-object
  FEmailToO  := TEmailAddressArray.Create (FCTKPrintJob, FFTKEmail.emToRecipients);
  FEmailToI  := FEmailToO;

  // Email CC sub-object
  FEmailCCO  := TEmailAddressArray.Create (FCTKPrintJob, FFTKEmail.emCCRecipients);
  FEmailCCI  := FEmailCCO;

  // Email BCC sub-object
  FEmailBCCO := TEmailAddressArray.Create (FCTKPrintJob, FFTKEmail.emBCCRecipients);
  FEmailBCCI := FEmailBCCO;

  // Email Attachments sub-object
  FFileAttachO := NIL;
  FFileAttachI := NIL;
End; { Create }

//----------------------------------------

Destructor TPrintJobEmailInfo.Destroy;
Begin { Destroy }
  FCTKPrintJob := NIL;
  FFTKEmail := NIL;

  // Email To sub-object
  FEmailToO  := NIL;
  FEmailToI  := NIL;

  // Email CC sub-object
  FEmailCCO  := NIL;
  FEmailCCI  := NIL;

  // Email BCC sub-object
  FEmailBCCO := NIL;
  FEmailBCCI := NIL;

  inherited Destroy;
End; { Destroy }

//-----------------------------------------------------------------------------

function TPrintJobEmailInfo.Get_emType: TEmailType;
begin
  Case FFTKEmail.emType Of
  {$IFNDEF WANTEXE}
    Enterprise01_TLB.emtMAPI : Result := EnterpriseForms_TLB.emtMAPI;
    Enterprise01_TLB.emtSMTP : Result := EnterpriseForms_TLB.emtSMTP;
  {$ELSE}
    Enterprise04_TLB.emtMAPI : Result := EnterpriseForms_TLB.emtMAPI;
    Enterprise04_TLB.emtSMTP : Result := EnterpriseForms_TLB.emtSMTP;
  {$ENDIF}
  Else
    Raise EUnknownValue.Create ('Unknown Email Type (' + IntToStr(Ord(FFTKEmail.emType)) + ')');
  End; { Case FFTKEmail.emType }
end;

//----------------------------------------

function TPrintJobEmailInfo.Get_emSenderName: WideString;
begin
  Result := FFTKEmail.emSenderName;
end;

procedure TPrintJobEmailInfo.Set_emSenderName(const Value: WideString);
begin
  FFTKEmail.emSenderName := Value;
end;

//----------------------------------------

function TPrintJobEmailInfo.Get_emSenderAddress: WideString;
begin
  Result := FFTKEmail.emSenderAddress;
end;

procedure TPrintJobEmailInfo.Set_emSenderAddress(const Value: WideString);
begin
  FFTKEmail.emSenderAddress := Value;
end;

//----------------------------------------

function TPrintJobEmailInfo.Get_emToRecipients: IEmailAddressArray;
begin
  Result := FEmailToI;
end;

//----------------------------------------

function TPrintJobEmailInfo.Get_emCCRecipients: IEmailAddressArray;
begin
  Result := FEmailCCI;
end;

//----------------------------------------

function TPrintJobEmailInfo.Get_emBCCRecipients: IEmailAddressArray;
begin
  Result := FEmailBCCI;
end;

//----------------------------------------

function TPrintJobEmailInfo.Get_emSubject: WideString;
begin
  Result := FFTKEmail.emSubject;
end;

procedure TPrintJobEmailInfo.Set_emSubject(const Value: WideString);
begin
  FFTKEmail.emSubject := Value;
end;

//----------------------------------------

function TPrintJobEmailInfo.Get_emMessageText: WideString;
begin
  Result := FFTKEmail.emMessageText;
end;

procedure TPrintJobEmailInfo.Set_emMessageText(const Value: WideString);
begin
  FFTKEmail.emMessageText := Value;
end;

//----------------------------------------

function TPrintJobEmailInfo.Get_emAttachments: IEmailAttachments;
begin
  If (Not Assigned(FFileAttachO)) Then Begin
    { Create and initialise the Attachments sub-object }
    FFileAttachO := TEmailAttachments.Create(FCTKPrintJob, FFTKEmail.emAttachments);

    FFileAttachI := FFileAttachO;
  End; { If (Not Assigned(FFileAttachO)) }

  Result := FFileAttachI;
end;

//----------------------------------------

function TPrintJobEmailInfo.Get_emPriority: TEmailPriority;
begin
  Case FFTKEmail.emPriority Of
  {$IFNDEF WANTEXE}
    EnterpriseForms_TLB.empLow    : Result := Enterprise01_TLB.epLow;
    EnterpriseForms_TLB.empNormal : Result := Enterprise01_TLB.epNormal;
    EnterpriseForms_TLB.empHigh   : Result := Enterprise01_TLB.epHigh;
  {$ELSE}
    EnterpriseForms_TLB.empLow    : Result := Enterprise04_TLB.epLow;
    EnterpriseForms_TLB.empNormal : Result := Enterprise04_TLB.epNormal;
    EnterpriseForms_TLB.empHigh   : Result := Enterprise04_TLB.epHigh;
  {$ENDIF}
  Else
    Raise EUnknownValue.Create ('Unknown Email Priority (' + IntToStr(Ord(FFTKEmail.emType)) + ')');
  End; { Case FFTKEmail.emType }
end;

procedure TPrintJobEmailInfo.Set_emPriority(Value: TEmailPriority);
begin
  Case Value Of
  {$IFNDEF WANTEXE}
    Enterprise01_TLB.epLow    : FFTKEmail.emPriority := EnterpriseForms_TLB.empLow;
    Enterprise01_TLB.epNormal : FFTKEmail.emPriority := EnterpriseForms_TLB.empNormal;
    Enterprise01_TLB.epHigh   : FFTKEmail.emPriority := EnterpriseForms_TLB.empHigh;
  {$ELSE}
    Enterprise04_TLB.epLow    : FFTKEmail.emPriority := EnterpriseForms_TLB.empLow;
    Enterprise04_TLB.epNormal : FFTKEmail.emPriority := EnterpriseForms_TLB.empNormal;
    Enterprise04_TLB.epHigh   : FFTKEmail.emPriority := EnterpriseForms_TLB.empHigh;
  {$ENDIF}
  Else
    Raise EUnknownValue.Create ('Unknown Email Priority (' + IntToStr(Ord(Value)) + ')');
  End; { Case FFTKEmail.emType }
end;

//----------------------------------------

function TPrintJobEmailInfo.Get_emCoverSheet: WideString;
begin
  Result := FFTKEmail.emCoverSheet;
end;

procedure TPrintJobEmailInfo.Set_emCoverSheet(const Value: WideString);
begin
  FFTKEmail.emCoverSheet := Value;
end;

//----------------------------------------

function TPrintJobEmailInfo.Get_emSMTPServer: WideString;
begin
  Result := FFTKEmail.emSMTPServer;
end;

//----------------------------------------

function TPrintJobEmailInfo.Get_emFormCompression: TEmailAttachmentZIPType;
begin
  Case FFTKEmail.emFormCompression Of
  {$IFNDEF WANTEXE}
    EnterpriseForms_TLB.fcNone : Result := Enterprise01_TLB.emZIPNone;
    EnterpriseForms_TLB.fcZIP  : Result := Enterprise01_TLB.emZIPPKZIP;
    EnterpriseForms_TLB.fcEDZ  : Result := Enterprise01_TLB.emZIPEDZ;
  {$ELSE}
    EnterpriseForms_TLB.fcNone : Result := Enterprise04_TLB.emZIPNone;
    EnterpriseForms_TLB.fcZIP  : Result := Enterprise04_TLB.emZIPPKZIP;
    EnterpriseForms_TLB.fcEDZ  : Result := Enterprise04_TLB.emZIPEDZ;
  {$ENDIF}
  Else
    Raise EUnknownValue.Create ('Unknown Email Compression Type (' + IntToStr(Ord(FFTKEmail.emFormCompression)) + ')');
  End; { Case FFTKEmail.emType }
end;

procedure TPrintJobEmailInfo.Set_emFormCompression(Value: TEmailAttachmentZIPType);
begin
  Case Value Of
  {$IFNDEF WANTEXE}
    Enterprise01_TLB.emZIPNone  : FFTKEmail.emFormCompression := EnterpriseForms_TLB.fcNone;
    Enterprise01_TLB.emZIPPKZIP : FFTKEmail.emFormCompression := EnterpriseForms_TLB.fcZIP;
    Enterprise01_TLB.emZIPEDZ   : FFTKEmail.emFormCompression := EnterpriseForms_TLB.fcEDZ;
  {$ELSE}
    Enterprise04_TLB.emZIPNone  : FFTKEmail.emFormCompression := EnterpriseForms_TLB.fcNone;
    Enterprise04_TLB.emZIPPKZIP : FFTKEmail.emFormCompression := EnterpriseForms_TLB.fcZIP;
    Enterprise04_TLB.emZIPEDZ   : FFTKEmail.emFormCompression := EnterpriseForms_TLB.fcEDZ;
  {$ENDIF}
  Else
    Raise EUnknownValue.Create ('Unknown Email Compression Type (' + IntToStr(Ord(Value)) + ')');
  End; { Case FFTKEmail.emType }
end;

//----------------------------------------

function TPrintJobEmailInfo.Get_emSendReader: WordBool;
begin
  Result := FFTKEmail.emSendReader;
end;

procedure TPrintJobEmailInfo.Set_emSendReader(Value: WordBool);
begin
  FFTKEmail.emSendReader := Value;
end;

//-----------------------------------------------------------------------------

end.
