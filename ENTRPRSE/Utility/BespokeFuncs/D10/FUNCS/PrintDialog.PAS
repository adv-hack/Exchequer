unit PrintDialog;

{ nfrewer440 12:19 22/02/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, BorBtns, Mask, Menus, RpDefine, RpDevice,
  Key, ExtCtrls, Buttons, FileUtil, ComCtrls, EnterToTab;

type
  TPrintDlg = class(TForm)
    btnSetup: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    OpenDialog1: TOpenDialog;
    pcTabs: TPageControl;
    tsPrinter: TTabSheet;
    tsOther: TTabSheet;
    lCopies: Label8;
    edCopies: TCurrencyEdit;
    Label82: Label8;
    rbPrinter: TRadioButton;
    rbPreview: TRadioButton;
    lFilename: Label8;
    edFilename: TEdit;
    btnBrowse: TSpeedButton;
    cmbExportTo: TComboBox;
    lExportTo: Label8;
    Bevel1: TBevel;
    Combo_Printers: TSBSComboBox;
    Label81: Label8;
    Bevel3: TBevel;
    Label84: Label8;
    Bevel2: TBevel;
    Label83: Label8;
    Label85: Label8;
    Bevel4: TBevel;
    cbOpenFile: TCheckBox;
    EnterToTab1: TEnterToTab;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSetupClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RadioButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CopiesFChange(Sender: TObject);
    procedure Combo_PrintersClick(Sender: TObject);
    procedure edFilenameChange(Sender: TObject);
    procedure cmbExportToChange(Sender: TObject);
    procedure edFilenameExit(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure pcTabsChange(Sender: TObject);
  private
    { Private declarations }
    bXLSRunnerExists, OkPressed : Boolean;
    procedure EnableDisable;
  public
    { Public declarations }
    PrintDest        : Byte;  { 0 = Printer, 1 = Screen, 2 = Other}
    ShowForm         : Boolean;
    UseAutoMode      : Boolean;
    Automode         : Byte;
    UseForm          : ShortString;
    ThisFont         : TFont;
    PrnSetup         : TSBSPrintSetupInfo;

    { HM 06/09/99: Added for v4.331 compatibility }
    ThisOrient       : TOrientation;
    DefSuggPrinter   : Integer;
    NeedLabel        : Boolean;


    //Function Execute : Boolean;
    Function Execute(FormName : ShortString;Var PrnInfo : TSBSPrintSetupInfo) : Boolean;

  end;

var
  PrintDlg: TPrintDlg;
  PrintToPrinter: Boolean;
  PrintShowForm : Boolean;
  LastExcelPath : string;

Function SelectPrinter(Var PrnInfo : TSBSPrintSetupInfo) : Boolean;

implementation

{$R *.DFM}

Uses
  Registry{, ETStrU};

Function SelectPrinter(Var PrnInfo : TSBSPrintSetupInfo) : Boolean;
Var
  PrnSel  : TPrintDlg;
Begin
  Result := False;

  PrnSel := TPrintDlg.Create(Application.MainForm);
  With PrnInfo Do
    Try
      PrnSel.PrnSetup := PrnInfo;
      if NoCopies < 1 then NoCopies := 1;
      PrnSel.edCopies.Value := NoCopies;

      If PrnSel.Execute('',PrnInfo) Then Begin
        PrnInfo := PrnSel.PrnSetup;
        Result := True;
      End;
    Finally
      PrnSel.Free;
    End;
End;

//Function TPrintDlg.Execute : Boolean;
Function TPrintDlg.Execute(FormName : ShortString;Var PrnInfo : TSBSPrintSetupInfo) : Boolean;
Begin
  { Load PrnSetup with current printer details }
  Combo_PrintersClick(Self);

  ShowModal;

  Result := OkPressed;

  if Result then begin
    with PrnSetup Do Begin
      NoCopies := Round(edCopies.Value);
      Preview := rbPreview.Checked;
      if PrintDest = 2 then
        begin
          fePrintMethod := cmbExportTo.ItemIndex + 5;
          feXMLFileDir := edFilename.Text;
          feMiscOptions[1] := cbOpenFile.checked;
        end
      else begin
        fePrintMethod := 0;
        feXMLFileDir := '';
      end;{if}
    end;{with}
  end;{if}
End;

procedure TPrintDlg.FormCreate(Sender: TObject);
Var
  I : Integer;
begin
  OkPressed := False;
  PrintDest := 0; { Printer }

  ShowForm:=PrintShowForm;

  { load printers }
  With RpDev do
    If (Printers.Count > 0) Then Begin
      For I := 0 To Pred(Printers.Count) Do
        Combo_Printers.Items.Add (Printers[I]);

      Combo_Printers.ItemIndex := RpDev.DeviceIndex
    End; { If }

  { Default to global flag }
{  If PrintToPrinter Then
    ActiveControl:=rbPrinter
  Else
    ActiveControl:=rbPreview;}

  // Lookup .XLS in HKEY_CLASSES_ROOT
  With TRegistry.Create Do
    Try
      Access := KEY_READ;
      RootKey := HKEY_CLASSES_ROOT;

      // Only enable the auto-open if there is an app to open XLS files
      bXLSRunnerExists := KeyExists ('.XLS');
    Finally
      Free;
    End;

  edFilename.Text := LastExcelPath;
  If (Trim(LastExcelPath) = '') Then
  Begin
    // Get My Documents path from registry and use as default path
    With TRegistry.Create Do
      Try
        Access := KEY_READ;
        RootKey := HKEY_CURRENT_USER;

        // Look for default path
        If KeyExists('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders') Then
          If OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False) Then
            If ValueExists('Personal') Then
              LastExcelPath := ReadString('Personal');
      Finally
        Free;
      End;

    If (Trim(LastExcelPath) <> '') And DirectoryExists (LastExcelPath) Then begin
      LastExcelPath := IncludeTrailingPathDelimiter(LastExcelPath);
      edFilename.Text := LastExcelPath;
    end;{if}
  End; // If (Trim(LastExcelPath) = '')

  RadioButtonClick(Sender);
end;


procedure TPrintDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Set global default flag }
  PrintToPrinter:= rbPrinter.Checked;
end;


procedure TPrintDlg.FormDestroy(Sender: TObject);
begin
  If (Assigned(ThisFont)) then
    ThisFont.Free;
end;

procedure TPrintDlg.btnOKClick(Sender: TObject);
begin
  If (Combo_Printers.ItemIndex >= 0)  Then
  Begin
    { Set printer }
    If (ShowForm) then
      RpDev.DeviceIndex := Combo_Printers.ItemIndex;

    OkPressed := True;
    ModalResult:=mrOk;
  End; { If }
end;

procedure TPrintDlg.btnCancelClick(Sender: TObject);
begin
  OkPressed := False;
  ModalResult:=mrCancel;
end;

procedure TPrintDlg.btnSetupClick(Sender: TObject);
Var
  oPrnInfo : TSBSPrintSetupInfo;
  oOrient  : TOrientation;
begin
  { save current print setup }
  oPrnInfo := RpDev.SBSSetupInfo;
  oOrient  := RpDev.Orientation;

  { Load PrnInfo with printer setup info }
  RpDev.SetPrnSetup(PrnSetup);
  If RpDev.PrinterSetUpDialog Then Begin
    PrnSetup := RpDev.SBSSetupInfo;
    Combo_Printers.ItemIndex := RpDev.DeviceIndex;
  End; { If }

  { restore previous print setup }
  RpDev.SetPrnSetup(oPrnInfo);
  RpDev.Orientation := oOrient;
end;

procedure TPrintDlg.RadioButtonClick(Sender: TObject);
begin
  if rbPrinter.Checked then PrintDest := 0  { Printer }
  else begin
    PrintDest := 1 { Screen }
  end;


//  if (PrintDest = 2) then OtherFrame.Pen.Color := clBlack
//  else OtherFrame.Pen.Color := clGray;

  EnableDisable;
end;


procedure TPrintDlg.CopiesFChange(Sender: TObject);
begin
  With edCopies do
    If (ActiveControl<>btnCancel) then Begin
      If (Not (StrToInt(Trim(Text)) In [1..99])) then Begin
        ShowMessage('The number of copies must be between 1-99');
        Text:='1';
        SetFocus;
      end;
    end;
end;

procedure TPrintDlg.Combo_PrintersClick(Sender: TObject);
Var
  TmpInfo : TSBSPrintSetupInfo;
  oOrient : TOrientation;
begin
  { Save current printer setup }
  TmpInfo := RpDev.SBSSetupInfo;
  oOrient := RpDev.Orientation;

  { Load current setup }
  RpDev.SetPrnSetup(PrnSetup);

  { Load PrnInfo with new printer setup info }
  RpDev.DeviceIndex := Combo_Printers.ItemIndex;
  PrnSetup := RpDev.SBSSetupInfo;

  { restore previous print setup }
  RpDev.SetPrnSetup(TmpInfo);
  RpDev.Orientation := oOrient;
end;

procedure TPrintDlg.edFilenameChange(Sender: TObject);
begin
  EnableDisable;
  edFilename.Hint := edFilename.Text;
end;

procedure TPrintDlg.EnableDisable;
begin
//  BtnOK.Enabled := rbPrinter.Checked or rbPreview.Checked
//  or (rbOther.Checked and (edFilename.text <> '') and (ExtractFilename(edFilename.text) <> ''));

  cmbExportTo.Enabled := PrintDest = 2;
  edFilename.Enabled := PrintDest = 2;
  btnBrowse.Enabled := PrintDest = 2;
  lExportTo.Enabled := PrintDest = 2;
  lFilename.Enabled := PrintDest = 2;
  lCopies.Enabled := PrintDest = 0;
  edCopies.Enabled := PrintDest = 0;

  cbOpenFile.Enabled := (cmbExportTo.ItemIndex = 1)
  or ((cmbExportTo.ItemIndex = 0) and bXLSRunnerExists);
  if not cbOpenFile.Enabled then cbOpenFile.checked := FALSE;

  BtnOK.Enabled := (pcTabs.ActivePage = tsPrinter)
  or ((pcTabs.ActivePage = tsOther) and (edFilename.text <> '') and (ExtractFilename(edFilename.text) <> ''));
end;

procedure TPrintDlg.cmbExportToChange(Sender: TObject);
begin
  edFilenameExit(nil);
end;

procedure TPrintDlg.edFilenameExit(Sender: TObject);
var
  sFilename : string;
begin
  if length(edFilename.Text) > 0 then begin
    sFilename := ExtractFilename(edFilename.Text);
    case cmbExportTo.ItemIndex of
      0 : Check83ValidFileWithExt(sFilename,'XLS');
      1 : Check83ValidFileWithExt(sFilename,'TXT');
    end;{case}
    edFilename.Text := ExtractFilePath(edFilename.Text) + sFileName;
  end;{if}
  EnableDisable;
end;

procedure TPrintDlg.btnBrowseClick(Sender: TObject);
begin
  OpenDialog1.InitialDir := ExtractFilePath(edFilename.Text); 
  if OpenDialog1.Execute then edFilename.Text := OpenDialog1.FileName;
  edFilenameExit(nil);
end;

procedure TPrintDlg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TPrintDlg.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TPrintDlg.FormShow(Sender: TObject);
begin
  pcTabs.ActivePage := tsPrinter;
  If PrintToPrinter Then
    ActiveControl:=rbPrinter
  Else
    ActiveControl:=rbPreview;
  EnableDisable;
end;

procedure TPrintDlg.pcTabsChange(Sender: TObject);
begin
  if pcTabs.ActivePage = tsPrinter then
  begin
    if rbPrinter.Checked then PrintDest := 0  { Printer }
    else PrintDest := 1; { Screen }
  end else
  begin
    PrintDest := 2; { Other }
  end;{if}
  EnableDisable;
end;

Initialization
  PrintToPrinter := True;
  LastExcelPath := '';

end.
