unit PrintToF;

// Generic Select Printer dialog

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_DEPRECATED OFF}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RpDevice, BorBtns, StdCtrls, TEditVal, bkgroup;

type
  TfrmPrintTo = class(TForm)
    PageControl1: TPageControl;
    tabshPrinter: TTabSheet;
    SBSBackGroup3: TSBSBackGroup;
    Label81: Label8;
    lstPrinters: TSBSComboBox;
    btnSetupPrinter: TButton;
    SBSBackGroup4: TSBSBackGroup;
    radPrinter: TBorRadio;
    radPreview: TBorRadio;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSetupPrinterClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure lstPrintersClick(Sender: TObject);
  private
    { Private declarations }
    FPrintJobInfo : TSBSPrintSetupInfo;
  public
    { Public declarations }
    Property PrintJobInfo : TSBSPrintSetupInfo Read FPrintJobInfo Write FPrintJobInfo;
  end;

// Displays the Print To dialog, returns TRUE if OK clicked
Function ShowPrintTo (Const ParentForm : TForm; Const WinCaption : ShortString; Var PrintJobInfo : TSBSPrintSetupInfo) : Boolean;

// Generates a unique .SWP file name for temporary reporting files
Function GetUniqueName (BaseDir : ShortString)  : ShortString;


implementation

{$R *.dfm}

//-------------------------------------------------------------------------

// Displays the Print To dialog, returns TRUE if OK clicked
Function ShowPrintTo (Const ParentForm : TForm; Const WinCaption : ShortString; Var PrintJobInfo : TSBSPrintSetupInfo) : Boolean;
Var
  frmPrintTo : TfrmPrintTo;
Begin // ShowPrintTo
  frmPrintTo := TfrmPrintTo.Create(ParentForm);
  Try
    frmPrintTo.Caption := WinCaption;

    Result := (frmPrintTo.ShowModal = mrOK);
    If Result Then
    Begin
      PrintJobInfo := frmPrintTo.PrintJobInfo
    End; // If Result
  Finally
    FreeAndNIL(frmPrintTo);
  End; // Try..Finally
End; // ShowPrintTo;

//=========================================================================

// Generates a unique .SWP file name for temporary reporting files
Function GetUniqueName (BaseDir : ShortString)  : ShortString;
Var
  RepFName : ShortString;
  FVar     : LongInt;
Begin { GetUniqueName }
  Result := '';

  { Ensure path is formatted correctly }
  BaseDir := IncludeTrailingBackslash(UpperCase(Trim(BaseDir)));

  { Generate Unique Filename for report file }
  FVar := 0;
  Repeat
    RepFName := BaseDir + '!REP' + IntToStr(FVar) + '.SWP';
    Inc (FVar);
  Until (Not FileExists (RepFName)) Or (FVar > 9999);

  { Check filename was found OK }
  If (FVar > 9999) Then
    Raise Exception.Create('Unable to generate Unique Filename, please check SWAP directory')
  Else
    Result := RepFName;
End; { GetUniqueName }

//=========================================================================

procedure TfrmPrintTo.FormCreate(Sender: TObject);
Var
  I : SmallInt;
begin
  // Load the printers combo
  If (RpDev.Printers.Count > 0) Then
  Begin
    For I := 0 To Pred(RpDev.Printers.Count) Do
    Begin
      lstPrinters.Items.Add (RpDev.Printers[I]);
    End; // For I

    If (RpDev.DeviceIndex <= Pred(lstPrinters.Items.Count)) Then
    Begin
      lstPrinters.ItemIndex := RpDev.DeviceIndex;
    End // If (RpDev.DeviceIndex <= Pred(lstPrinters.Items.Count))
    Else
    Begin
      lstPrinters.ItemIndex := 0;
    End; // Else
  End; // If (RpDev.Printers.Count > 0)
end;

//-------------------------------------------------------------------------

procedure TfrmPrintTo.lstPrintersClick(Sender: TObject);
begin
  RpDev.DeviceIndex := lstPrinters.ItemIndex;
end;

//-------------------------------------------------------------------------

procedure TfrmPrintTo.btnSetupPrinterClick(Sender: TObject);
begin
  RpDev.PrinterSetUpDialog;
end;

//-------------------------------------------------------------------------

procedure TfrmPrintTo.btnOKClick(Sender: TObject);
begin
  FPrintJobInfo := RpDev.SBSSetupInfo;
  FPrintJobInfo.Preview := radPreview.Checked;
  ModalResult := mrOk;
end;

//-------------------------------------------------------------------------

end.
