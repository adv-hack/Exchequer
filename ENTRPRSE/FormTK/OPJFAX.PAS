unit oPJFax;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     EnterpriseForms_TLB, RpDevice;

type
  TEFPrintJobFaxInfo = class(TAutoIntfObject, IEFPrintJobFaxInfo)
  private
    // Local Reference to parent PrintJob object
    FPrintJob : TObject;

    // Fax Printer number
    FFaxPrnNo : Integer;

    // Fax Cover Sheet (needs to be local so it doesn't interfere with Email cover sheet)
    FCoverSheet : String[8];

    // Description displayed in Exchequer Fax Administrator for fax
    FFaxDesc  : String[80];
  protected
    // IEFPrintJobFaxInfo
    function Get_fxType: TEFFaxType; safecall;
    function Get_fxFaxPrinterIndex: Integer; safecall;
    function Get_fxSenderName: WideString; safecall;
    procedure Set_fxSenderName(const Value: WideString); safecall;
    function Get_fxSenderFaxNumber: WideString; safecall;
    procedure Set_fxSenderFaxNumber(const Value: WideString); safecall;
    function Get_fxRecipientName: WideString; safecall;
    procedure Set_fxRecipientName(const Value: WideString); safecall;
    function Get_fxRecipientFaxNumber: WideString; safecall;
    procedure Set_fxRecipientFaxNumber(const Value: WideString); safecall;
    function Get_fxFaxingPath: WideString; safecall;
    function Get_fxCoverSheet: WideString; safecall;
    procedure Set_fxCoverSheet(const Value: WideString); safecall;
    function Get_fxPriority: TEFFaxPriority; safecall;
    procedure Set_fxPriority(Value: TEFFaxPriority); safecall;
    function Get_fxMessageText: WideString; safecall;
    procedure Set_fxMessageText(const Value: WideString); safecall;
    function Get_fxFaxDescription: WideString; safecall;
    procedure Set_fxFaxDescription(const Value: WideString); safecall;

    // Local methods
  public
    Constructor Create (Const PrintJob : TObject);

    function  CheckJobInfo : Integer;
    procedure Initialise;
    procedure UpdatePrnSetup (Const pFTKData : pFormToolkitData);
  End; { TEFPrintJobFaxInfo }


implementation

Uses ComServ,
     GlobVar,          // Exchequer Global Constants/Types
     VarConst,         // Exchequer Global Constants/Types/Variables
     Register,         // FormDes routines for accessing EFD Files
     oPrntJob,         // TEFPrintJob object
     MiscFunc;         // Miscellaneous Functions / Types / Constants for the Form TK

//-----------------------------------------------------------------------------

Constructor TEFPrintJobFaxInfo.Create (Const PrintJob : TObject);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IEFPrintJobFaxInfo);

  FPrintJob := PrintJob;
End;

//-----------------------------------------------------------------------------

procedure TEFPrintJobFaxInfo.Initialise;
Var
  I : Integer;
begin
  With SyssEDI2^.EDI2Value, FPrintJob as TEFPrintJob, PrintJobSetupInfo Do Begin
    // Fax Type
    feFaxMethod := FxUseMAPI;

    // Fax Printer Number
    FFaxPrnNo := -1;
    If (RpDev.Printers.Count > 0) Then
      For I := 0 To Pred(RpDev.Printers.Count) Do
        If (UpperCase(Trim(FaxPrnN)) = UpperCase(Trim(RpDev.Printers[I]))) Then Begin
          FFaxPrnNo := I;
          Break;
        End; { If }

    // Fax Cover Sheet
    FCoverSheet := '';

    // Fax Priority
    feFaxPriority := 1; // fpNormal;

    // Fax Description
    FFaxDesc := '';
  End; { With SyssEDI2^.EDI2Value, FPrintJob as TEFPrintJob }
end;

//-----------------------------------------------------------------------------

procedure TEFPrintJobFaxInfo.UpdatePrnSetup (Const pFTKData : pFormToolkitData);
begin
  With SyssEDI2^.EDI2Value, FPrintJob as TEFPrintJob, PrintJobSetupInfo Do Begin
    // Setup Printer Index
    Case feFaxMethod Of
      0,            // Exchequer E-Comms
      2 : Begin     // Third-Party
            // Change normal printer to Fax Printer and print direct to it
            DevIdx := FFaxPrnNo;

            // Remove form/bin info
            FormNo := 0;
            FormName := '';
            BinNo := 0;
            BinName := '';
          End;

      // MAPI
      1 : Begin
            // No changes required - normal printer used for generating EDF and then
            // printed to MAPI
          End;
    Else
      Raise EUnknownValue.Create ('IEFPrintJobFaxInfo.UpdatePrnSetup - Unknown Faxing Method (' + IntToStr(Ord(feFaxMethod)) + ')');
    End; { Case }

    // Cover Sheet
    feCoverSheet := FCoverSheet;

    // Fax Description
    pFTKData^.ftdFaxDesc := FFaxDesc;
  End; { With FPrintJob as TEFPrintJob }
end;

//-----------------------------------------------------------------------------

// Validates the fax details prior to starting the print job
function TEFPrintJobFaxInfo.CheckJobInfo : Integer;
begin { CheckJobInfo }
  Result := 0;

  With FPrintJob as TEFPrintJob, PrintJobSetupInfo Do Begin
    // Recipient Name
    If (Trim(feFaxTo) = '') Then
      Result := 4000;

    // Recipient Fax Number
    If (Result = 0) And (Trim(feFaxToNo) = '') Then
      Result := 4001;

    // Sender Name
    If (Result = 0) And (Trim(feFaxFrom) = '') Then
      Result := 4002;

    // Sender Fax Number
    If (Result = 0) And (Trim(feFaxFromNo) = '') Then
      Result := 4003;

    // Cover Sheet blank or of correct form type
    If (Result = 0) And (Trim(FCoverSheet) <> '') And (FormsListI.pfCount > 0) Then
      // Test form type of coversheet against the first form in the print job
      If (GetFormType (FCoverSheet) <> GetFormType (FormsListI.pfForms[1].fdFormName)) Then
        // Error - Forms of different types cannot be included within the same print job
        Result := 4004;
  End; { With FPrintJob as TEFPrintJob, PrintJobSetupInfo }
end; { CheckJobInfo }

//-----------------------------------------------------------------------------

function TEFPrintJobFaxInfo.Get_fxType: TEFFaxType;
begin
  With FPrintJob as TEFPrintJob, PrintJobSetupInfo Do
    Case feFaxMethod Of
      0 : Result := ftEnterpriseEComms;
      1 : Result := ftMAPI;
      2 : Result := ftThirdParty;
    Else
      Raise EUnknownValue.Create (Format('Unknown Fax Method (%d) in IEFPrintJobFaxInfo.fxType', [feFaxMethod]));
    End; { Case feFaxMethod }
end;

//----------------------------------------

function TEFPrintJobFaxInfo.Get_fxFaxPrinterIndex: Integer;
begin
  Result := FFaxPrnNo + 1;
end;

//----------------------------------------

function TEFPrintJobFaxInfo.Get_fxSenderName: WideString;
begin
  With FPrintJob as TEFPrintJob, PrintJobSetupInfo Do
    Result := feFaxFrom;
end;

procedure TEFPrintJobFaxInfo.Set_fxSenderName(const Value: WideString);
begin
  With FPrintJob as TEFPrintJob, PrintJobSetupInfo Do
    feFaxFrom := Value;
end;

//----------------------------------------

function TEFPrintJobFaxInfo.Get_fxSenderFaxNumber: WideString;
begin
  With FPrintJob as TEFPrintJob, PrintJobSetupInfo Do
    Result := feFaxFromNo;
end;

procedure TEFPrintJobFaxInfo.Set_fxSenderFaxNumber(const Value: WideString);
begin
  With FPrintJob as TEFPrintJob, PrintJobSetupInfo Do
    feFaxFromNo := Value;
end;

//----------------------------------------

function TEFPrintJobFaxInfo.Get_fxRecipientName: WideString;
begin
  With FPrintJob as TEFPrintJob, PrintJobSetupInfo Do
    Result := feFaxTo;
end;

procedure TEFPrintJobFaxInfo.Set_fxRecipientName(const Value: WideString);
begin
  With FPrintJob as TEFPrintJob, PrintJobSetupInfo Do
    feFaxTo := Value;
end;

//----------------------------------------

function TEFPrintJobFaxInfo.Get_fxRecipientFaxNumber: WideString;
begin
  With FPrintJob as TEFPrintJob, PrintJobSetupInfo Do
    Result := feFaxToNo;
end;

procedure TEFPrintJobFaxInfo.Set_fxRecipientFaxNumber(const Value: WideString);
begin
  With FPrintJob as TEFPrintJob, PrintJobSetupInfo Do
    feFaxToNo := Value;
end;

//----------------------------------------

function TEFPrintJobFaxInfo.Get_fxFaxingPath: WideString;
begin
  With SyssEDI2^.EDI2Value Do
    Result := FaxDLLPath;
end;

//----------------------------------------

function TEFPrintJobFaxInfo.Get_fxCoverSheet: WideString;
begin
  Result := FCoverSheet;
end;

procedure TEFPrintJobFaxInfo.Set_fxCoverSheet(const Value: WideString);
begin
{ TODO : Need to validate the CoverSheet formname here }
  FCoverSheet := Value;
end;

//----------------------------------------

function TEFPrintJobFaxInfo.Get_fxPriority: TEFFaxPriority;
begin
  With FPrintJob as TEFPrintJob, PrintJobSetupInfo Do
    Case feFaxPriority Of
      0 : Result := fpUrgent;
      1 : Result := fpNormal;
      2 : Result := fpOffPeak;
    Else
      Raise EUnknownValue.Create (Format('Unknown Fax Priority (%d) in IEFPrintJobFaxInfo.fxType', [feFaxPriority]));
    End; { Case feFaxPriority }
end;

procedure TEFPrintJobFaxInfo.Set_fxPriority(Value: TEFFaxPriority);
begin
  With FPrintJob as TEFPrintJob, PrintJobSetupInfo Do
    Case Value Of
      fpUrgent  : feFaxPriority := 0;
      fpNormal  : feFaxPriority := 1;
      fpOffPeak : feFaxPriority := 2;
    Else
      Raise EUnknownValue.Create (Format('Unknown Fax Priority (%d) in IEFPrintJobFaxInfo.fxType', [Ord(Value)]));
    End; { Case feFaxPriority }
end;

//----------------------------------------

function TEFPrintJobFaxInfo.Get_fxMessageText: WideString;
begin
  With FPrintJob as TEFPrintJob, PrintJobSetupInfo Do
    Result := feFaxMsg;
end;

procedure TEFPrintJobFaxInfo.Set_fxMessageText(const Value: WideString);
begin
  With FPrintJob as TEFPrintJob, PrintJobSetupInfo Do
    feFaxMsg := Value;
end;

//----------------------------------------

function TEFPrintJobFaxInfo.Get_fxFaxDescription: WideString;
begin
  Result := FFaxDesc;
end;

procedure TEFPrintJobFaxInfo.Set_fxFaxDescription(const Value: WideString);
begin
  FFaxDesc := Value;
end;

//-----------------------------------------------------------------------------


end.
