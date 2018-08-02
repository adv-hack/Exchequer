unit oFormInf;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     EnterpriseForms_TLB,     // Forms Toolkit Type Library
     GlobType;                // Global FormDes Types and Vars

type
  TEFFormDefInfo = class(TAutoIntfObject, IEFFormDefInfo)
  private
    // Form Name
    FFormName : ShortString;

    // Form Type
    FFormType : TEFFormType;

    // Form Information record
    FFormInfo : FormInfoType;

    // Bin, Paper Indices
    FBinIndex     : LongInt;
    FPaperIndex   : LongInt;
  protected
    // IEFFormDefInfo
    function Get_fiType: TEFFormType; safecall;
    function Get_fiDescription: WideString; safecall;
    function Get_fiCopies: Integer; safecall;
    function Get_fiPaperWidth: Integer; safecall;
    function Get_fiPaperHeight: Integer; safecall;
    function Get_fiPortrait: WordBool; safecall;
    function Get_fiContinuation: WideString; safecall;
    function Get_fiPrinterIndex: Integer; safecall;
    function Get_fiBinIndex: Integer; safecall;
    function Get_fiPaperIndex: Integer; safecall;
    function Get_fiLabelTop: Integer; safecall;
    function Get_fiLabelLeft: Integer; safecall;
    function Get_fiLabelWidth: Integer; safecall;
    function Get_fiLabelHeight: Integer; safecall;
    function Get_fiLabelNoCols: Integer; safecall;
    function Get_fiLabelNorows: Integer; safecall;
    function Get_fiLabelInterColGap: Integer; safecall;
    function Get_fiLabelInterRowGap: Integer; safecall;

    // Local methods
  public
    Constructor Create (Const FormName : ShortString);
  End; { TEFFormDefInfo }

implementation

uses ComServ,
     MiscFunc,     // Miscellaneous Functions / Types / Constants for the Form TK
     RpDevice,     // RAVE RPDev Printer Device object
     Register;     // FormDes routines for accessing .EFD files

//-----------------------------------------------------------------------------

Constructor TEFFormDefInfo.Create (Const FormName : ShortString);
Var
  PrnSetupInfo : TSBSPrintSetupInfo;
  FormType     : Byte;
Begin { Create }
  Inherited Create (ComServer.TypeLib, IEFFormDefInfo);

  FFormName := FormName;

  // Check specified form exists
  FormType := GetFormType (FormName);
  If (FormType = 0) Then
    Raise EInvalidForm.Create ('The specified Form Name is invalid (' + FormName + ')')
  Else Begin
    // Load Form Details
    FFormInfo := GetFormInfo (FormName);

    FBinIndex     := 0;
    FPaperIndex   := 0;

    // Setup type dependant on details
    If FormType = 2 Then
      FFormType := EnterpriseForms_TLB.ftPCC
    Else Begin
      // Identify type of EFD form
      If (FFormInfo.FormHeader.fhFormType = GlobType.ftForm) Then
        FFormType := EnterpriseForms_TLB.ftEFDForm
      Else
        FFormType := EnterpriseForms_TLB.ftEFDLabel;

      // use RPDev to get printer info and identify FTK indices for Bin and Paper
      With RpDev Do Begin
        // Record current settings
        PrnSetupInfo := SBSSetupInfo;

        // Load details for correct printer
        RpDev.DeviceIndex := FFormInfo.PrinterNo;

        // Lookup Bin and Paper indices if supported
        If ((DevMode.dmFields And DM_PAPERSIZE) = DM_PAPERSIZE) And (FFormInfo.PaperNo > 0) Then
          FPaperIndex := WalkListIdx(Papers, FFormInfo.PaperNo) + 1;
        If ((DevMode.dmFields And DM_DEFAULTSOURCE) = DM_DEFAULTSOURCE) And (FFormInfo.BinNo > 0) Then
          FBinIndex := WalkListIdx(Bins, FFormInfo.BinNo) + 1;

        // Restore original settings
        SetPrnSetup(PrnSetupInfo);
      End; { With RpDev }
    End; { Else }
  End; { Else }
End; { Create }

//-----------------------------------------------------------------------------

function TEFFormDefInfo.Get_fiType: TEFFormType;
begin
  Result := FFormType;
end;

//-------------------------------

function TEFFormDefInfo.Get_fiDescription: WideString;
begin
  Result := FFormInfo.FormHeader.fhFormDescr;
end;

//-------------------------------

function TEFFormDefInfo.Get_fiBinIndex: Integer;
begin
  Result := FBinIndex;
end;

//-------------------------------

function TEFFormDefInfo.Get_fiContinuation: WideString;
begin
  Result := FFormInfo.FormHeader.fhContinue;
end;

//-------------------------------

function TEFFormDefInfo.Get_fiCopies: Integer;
begin
  Result := FFormInfo.FormHeader.fhCopies;
end;

//-------------------------------

function TEFFormDefInfo.Get_fiLabelLeft: Integer;
begin
  Result := FFormInfo.FormHeader.fhLblLeft;
end;

//-------------------------------

function TEFFormDefInfo.Get_fiLabelHeight: Integer;
begin
  Result := FFormInfo.FormHeader.fhLblHeight;
end;

//-------------------------------

function TEFFormDefInfo.Get_fiLabelInterColGap: Integer;
begin
  Result := FFormInfo.FormHeader.fhLblColGap;
end;

//-------------------------------

function TEFFormDefInfo.Get_fiLabelInterRowGap: Integer;
begin
  Result := FFormInfo.FormHeader.fhLblRowGap;
end;

//-------------------------------

function TEFFormDefInfo.Get_fiLabelNoCols: Integer;
begin
  Result := FFormInfo.FormHeader.fhLblCols;
end;

//-------------------------------

function TEFFormDefInfo.Get_fiLabelNorows: Integer;
begin
  Result := FFormInfo.FormHeader.fhLblRows;
end;

//-------------------------------

function TEFFormDefInfo.Get_fiLabelTop: Integer;
begin
  Result := FFormInfo.FormHeader.fhLblTop;
end;

//-------------------------------

function TEFFormDefInfo.Get_fiLabelWidth: Integer;
begin
  Result := FFormInfo.FormHeader.fhLblWidth;
end;

//-------------------------------

function TEFFormDefInfo.Get_fiPaperHeight: Integer;
begin
  Result := FFormInfo.FormHeader.fhPaperHeight;
end;

//-------------------------------

function TEFFormDefInfo.Get_fiPaperIndex: Integer;
begin
  Result := FPaperIndex;
end;

//-------------------------------

function TEFFormDefInfo.Get_fiPaperWidth: Integer;
begin
  Result := FFormInfo.FormHeader.fhPaperWidth;
end;

//-------------------------------

function TEFFormDefInfo.Get_fiPortrait: WordBool;
begin
  Result := (FFormInfo.FormHeader.fhOrientation = fdoPortrait);
end;

//-------------------------------

function TEFFormDefInfo.Get_fiPrinterIndex: Integer;
begin
  Result := FFormInfo.PrinterNo + 1
end;

//-----------------------------------------------------------------------------

end.
