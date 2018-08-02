unit Prntdlg3;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, BorBtns, Mask, Menus, RpDefine, RpDevice, GlobVar,
  VarConst, GlobType;

type
  TPrintDlg = class(TForm)
    Radio_Printer: TBorRadio;
    Radio_Preview: TBorRadio;
    Label81: Label8;
    Combo_Printers: TSBSComboBox;
    Button_Setup: TButton;
    Button_OK: TButton;
    Button_Cancel: TButton;
    Label82: Label8;
    FontDialog1: TFontDialog;
    Label83: Label8;
    CopiesF: TCurrencyEdit;
    OpenDialog1: TOpenDialog;
    Radio_Test: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure Button_OKClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure Button_SetupClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RadioButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CopiesFChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Combo_PrintersClick(Sender: TObject);
  private
    { Private declarations }
    OkPressed : Boolean;
  public
    { Public declarations }
    PrintDest        : Byte;  { 0 - Printer, 1 = Screen }
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

    { HM 06/09/99: Added for v4.331 compatibility }
    procedure FormPrnInfo(fmInfo : FormInfoType;Var PrnInfo : TSBSPrintSetupInfo);
  end;

var
  PrintDlg: TPrintDlg;
  PrintToQueue,
  PrintToPrinter: Boolean;
  PrintShowForm : Boolean;

{Function SelectPrinter(Var PNo, Cop : SmallInt;Var ToPrn : Boolean) : Boolean;}
Function SelectPrinter(Var PrnInfo : TSBSPrintSetupInfo) : Boolean;
Function SelectCDFFile(Var LastPath : ShortString) : Boolean;

Procedure SetEcommsFromCust(Const LCust    :  CustRec;
                            Var   PrnInfo  :  TSBSPrintSetupInfo;
                                  ExLocal  :  Pointer;
                                  Update   :  Boolean);

implementation

{$R *.DFM}

Uses ETStrU,
     ExThrd2U,
     BTSupU2;

Function SelectCDFFile (Var LastPath : ShortString) : Boolean;
Var
  SaveDialog1: TSaveDialog;
Begin
  Set_BackThreadMVisible(BOn);
  Set_BackThreadSuspend (BOn);

  SaveDialog1 := TSaveDialog.Create(Application.MainForm);
  Try
    With SaveDialog1 Do Begin
      DefaultExt := 'CSV';
      FileName := LastPath;
      Filter := 'CSV Files|*.CSV|All Files|*.*';
      FilterIndex := 1;
      Options := [ofOverwritePrompt, ofPathMustExist];
      Title := 'Print CSV report to';
    End; { With }

    Result := SaveDialog1.Execute;

    If Result Then Begin
      { filename & path selected }
      LastPath := SaveDialog1.FileName;
    End; { If }
  Finally
    SaveDialog1.Free;
  End;

  Set_BackThreadSuspend (BOff);
  Set_BackThreadMVisible(BOff);
End;

{Function SelectPrinter(Var PNo, Cop : SmallInt;Var ToPrn : Boolean) : Boolean;}
Function SelectPrinter(Var PrnInfo : TSBSPrintSetupInfo) : Boolean;
Var
  PrnSel  : TPrintDlg;
Begin
  Result := False;

  Set_BackThreadMVisible(BOn);
  Set_BackThreadSuspend (BOn);

  PrnSel := TPrintDlg.Create(Application.MainForm);
  With PrnInfo Do
    Try
      PrnSel.PrnSetup := PrnInfo;
      PrnSel.CopiesF.Value := NoCopies;

      If PrnSel.Execute('',PrnInfo) Then Begin
        PrnInfo := PrnSel.PrnSetup;
        Result := True;
      End;
    Finally
      PrnSel.Free;
    End;

  Set_BackThreadSuspend (BOff);
  Set_BackThreadMVisible(BOff);
End;

//Function TPrintDlg.Execute : Boolean;
Function TPrintDlg.Execute(FormName : ShortString;Var PrnInfo : TSBSPrintSetupInfo) : Boolean;
Begin
  { Load PrnSetup with current printer details }
  Combo_PrintersClick(Self);

  ShowModal;

  Result := OkPressed;

  If Result Then
    With PrnSetup Do Begin
      NoCopies := Round(CopiesF.Value);
      Preview := Not Radio_Printer.Checked;
    End; { With }
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
  If PrintToPrinter Then
    ActiveControl:=Radio_Printer
  Else
    ActiveControl:=Radio_Preview;

  RadioButtonClick(Sender);
end;


procedure TPrintDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Set global default flag }
  PrintToPrinter:= Radio_Printer.Checked;


end;


procedure TPrintDlg.FormDestroy(Sender: TObject);
begin
  If (Assigned(ThisFont)) then
    ThisFont.Free;
end;

procedure TPrintDlg.Button_OKClick(Sender: TObject);
Var
  Device, Driver, Port : Array [0..79] Of Char;
  DeviceMode           : THandle;
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

procedure TPrintDlg.Button_CancelClick(Sender: TObject);
begin
  OkPressed := False;
  ModalResult:=mrCancel;
end;

procedure TPrintDlg.Button_SetupClick(Sender: TObject);
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
  If Radio_Printer.Checked Then
    PrintDest := 0  { Printer }
  Else
    PrintDest := 1; { Screen }
end;


procedure TPrintDlg.CopiesFChange(Sender: TObject);
begin
  With CopiesF do
    If (ActiveControl<>Button_Cancel) then Begin
      If (Not (StrToInt(Trim(Text)) In [1..99])) then Begin
        ShowMessage('The number of copies must be between 1-99');
        Text:='1';
        SetFocus;
      end;
    end;
end;

procedure TPrintDlg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TPrintDlg.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
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

procedure TPrintDlg.FormPrnInfo(fmInfo : FormInfoType;Var PrnInfo : TSBSPrintSetupInfo);
begin { FormPrnInfo }
end; { FormPrnInfo }

Procedure SetEcommsFromCust(Const LCust    :  CustRec;
                            Var   PrnInfo  :  TSBSPrintSetupInfo;
                                  ExLocal  :  Pointer;
                                  Update   :  Boolean);
begin { SetEcommsFromCust }
end; { SetEcommsFromCust }

Initialization
  PrintToPrinter := True;
  PrintToQueue:=False;
end.
