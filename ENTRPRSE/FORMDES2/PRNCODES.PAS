unit PrnCodes;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, EPrntDef, TEditVal, IniFiles;

type
  TForm_PrnCodes = class(TForm)
    lbExchPrinters: TListBox;
    lbWinPrinters: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    Label81: Label8;
    btnEditPrinterCodes: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lbWinPrintersClick(Sender: TObject);
    procedure lbExchPrintersClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnEditPrinterCodesClick(Sender: TObject);
  private
    { Private declarations }
    procedure SaveToIni;
  public
    { Public declarations }
  end;


Function GetControlCode(Printer : ShortString) : SmallInt;
Procedure InitPrnCodes;
Procedure PrinterControlCodes; Export;
Procedure GetPreviewFont (Var PrevFont : TFont);
Procedure WritePreviewFont (PrevFont : TFont);

Procedure GetDefPCCInfo (Var PrnStr         : ShortString;
                         Var PrnNo          : SmallInt;
                         Var BinNo, PaperNo : LongInt);
Procedure WriteDefPCCInfo (PrnNo : ShortString; BinNo, PaperNo : LongInt);

implementation

{$R *.DFM}

Uses Globvar, RpDevice, PrintersSetup;

Const
  SectName   = 'PrinterCodes';
  PrevSect   = 'PreviewFont';
  DefPCCSect = 'PCCDefaults';
Var
  IniF : TIniFile;

//=========================================================================

{ Reads the default printer dialog settings from the INI file }
Procedure GetDefPCCInfo (Var PrnStr         : ShortString;
                         Var PrnNo          : SmallInt;
                         Var BinNo, PaperNo : LongInt);
Var
  DefStr : ShortString;
  I      : SmallInt;
Begin
  { Printer }
  PrnNo  := 0;    { Default }
  If (RpDev.Printers.Count > 0) Then DefStr := RpDev.Printers[0] Else DefStr := '';
  PrnStr := IniF.ReadString(DefPCCSect, 'Printer', '');
  If (Trim(PrnStr) <> '') And (RpDev.Printers.Count > 0) Then
    For I := 0 to Pred(RpDev.Printers.Count) Do
      If (UpperCase(PrnStr) = UpperCase(Copy(RpDev.Printers[I], 1, Length(PrnStr)))) Then Begin
        PrnNo := I;
        Break;
      End; { If }

  { Bin }
  BinNo := IniF.ReadInteger (DefPCCSect, 'BinNo', 0);

  { Paper }
  PaperNo := IniF.ReadInteger (DefPCCSect, 'PaperNo', 0);
End;

//-------------------------------------------------------------------------

{ Writes the default PCC form printer settings to the INI file }
Procedure WriteDefPCCInfo (PrnNo : ShortString; BinNo, PaperNo : LongInt);
Begin
  IniF.WriteString  (DefPCCSect, 'Printer', PrnNo);
  IniF.WriteInteger (DefPCCSect, 'BinNo',   BinNo);
  IniF.WriteInteger (DefPCCSect, 'PaperNo', PaperNo);
End;

//-------------------------------------------------------------------------

{ Reads the preview dialogs font information from the ini file }
Procedure GetPreviewFont (Var PrevFont : TFont);
Var
  TmpStr  : ShortString;
  LI      : LongInt;
  ErrCode : Integer;
Begin
  { Font Name }
  PrevFont.Name := IniF.ReadString(PrevSect, 'Name', 'Courier New');

  { Font Size }
  TmpStr := IniF.ReadString(PrevSect, 'Size', '8');
  Val (TmpStr, LI, ErrCode);
  If (ErrCode = 0) And (LI In [6..72]) Then
    PrevFont.Size := LI;

  { Style }
  TmpStr := IniF.ReadString(PrevSect, 'Style', '');
  If (Pos('B', TmpStr) > 0) Then PrevFont.Style :=  PrevFont.Style + [fsBold];
  If (Pos('I', TmpStr) > 0) Then PrevFont.Style :=  PrevFont.Style + [fsItalic];
  If (Pos('U', TmpStr) > 0) Then PrevFont.Style :=  PrevFont.Style + [fsUnderline];
  If (Pos('S', TmpStr) > 0) Then PrevFont.Style :=  PrevFont.Style + [fsStrikeout];

  { Color }
  TmpStr := IniF.ReadString(PrevSect, 'Colour', '0');
  Val (TmpStr, LI, ErrCode);
  If (ErrCode = 0) Then
    PrevFont.Color := LI;
End;

//-------------------------------------------------------------------------

{ Writes the Prevint Preview Font info to the ini file }
Procedure WritePreviewFont (PrevFont : TFont);
Var
  StyleStr : String[4];
Begin
  With PrevFont Do Begin
    IniF.WriteString(PrevSect, 'Name', Name);
    IniF.WriteString(PrevSect, 'Size', IntToStr(Size));
    IniF.WriteString(PrevSect, 'Colour', IntToStr(Color));

    StyleStr := '';
    If (fsBold In Style) Then StyleStr := StyleStr + 'B';
    If (fsItalic In Style) Then StyleStr := StyleStr + 'I';
    If (fsUnderline In Style) Then StyleStr := StyleStr + 'U';
    If (fsStrikeout In Style) Then StyleStr := StyleStr + 'S';
    IniF.WriteString(PrevSect, 'Style', StyleStr);
  End; { With }
End;

//-------------------------------------------------------------------------

{ Returns the Index of a Control Code from the INI file - returns -1 if no set }
Function GetControlCode(Printer : ShortString) : SmallInt;
Var
  PrnCode : ShortString;
  I       : SmallInt;
Begin
  Result := -1;

  Printer := Copy(Trim(Printer), 1, 20);
  If (Trim(Printer) <> '') Then Begin
    { Have a printer name }
    PrnCode := Trim(IniF.ReadString(SectName, Printer, ''));

    If (PrnCode <> '') Then
      { Run through DOS Printers to match name }
      For I := Low(Printer_defFile) To High(Printer_defFile) Do
        If (Trim(Printer_defFile[I].Name) = PrnCode) Then Begin
          { Got match }
          Result := I;
          Break;
        End; { If }
  End; { If }
End;

//=========================================================================

{ Displays the System Setup - Printer Control Codes dialog }
Procedure PrinterControlCodes;
Var
  Form_PrnCodes : TForm_PrnCodes;
Begin
  Form_PrnCodes := TForm_PrnCodes.Create(Application.MainForm);
  Try
    If (Form_PrnCodes.lbExchPrinters.Items.Count > 0) Then Begin
      If (Form_PrnCodes.lbWinPrinters.Items.Count > 0) Then Begin

        Form_PrnCodes.ShowModal;

      End { If }
      Else
        MessageDlg ('No Printers are defined in Windows', mtError, [mbOk], 0);
    End { If }
    Else
      MessageDlg ('No Exchequer Printer Codes are defined', mtError, [mbOk], 0);
    Finally
    Form_PrnCodes.Free;
  End;
End;

//-------------------------------------------------------------------------

procedure TForm_PrnCodes.FormCreate(Sender: TObject);
Var
  TransTable     : Array[1..PDefNo] of SmallInt;
  DefIdx, PrnIdx : SmallInt;
  I              : Byte;
begin
  { Load Exchequer Printers }
  lbExchPrinters.Clear;
  For I := Low(Printer_defFile) To High(Printer_defFile) Do
    With Printer_defFile[I] Do Begin
      If (Trim (Name) <> '') Then Begin
        TransTable[I] := lbExchPrinters.Items.Count;
        lbExchPrinters.Items.AddObject (Trim(Name) + ' on LPT' + IntToStr(Port), Pointer(I));
      End { If }
      Else
        TransTable[I] := 0;
    End; { With }

  { Load Windows Printers }
  lbWinPrinters.Clear;
  If (RpDev.Printers.Count > 0) Then
    For I := 0 To Pred (RpDev.Printers.Count) Do Begin
      { Get index of matching Printer Control Code }
      DefIdx := GetControlCode(RpDev.Printers[I]);
      If (DefIdx In [Low(TransTable)..High(TransTable)]) Then
        PrnIdx := TransTable[DefIdx]
      Else
        PrnIdx := 0;

      lbWinPrinters.Items.AddObject (RpDev.Printers[I], Pointer(PrnIdx + 100));
    End; { If }

  lbWinPrinters.ItemIndex := 0;
  lbWinPrintersClick(Sender);
end;

//-------------------------------------------------------------------------

procedure TForm_PrnCodes.lbWinPrintersClick(Sender: TObject);
begin
  If (lbWinPrinters.ItemIndex > -1) Then Begin
    { Highlight Exchequer Printer for current Window Printer }
    If (LongInt(lbWinPrinters.Items.Objects[lbWinPrinters.ItemIndex]) >= 100) Then Begin
      { Have an Exch Prn - select it in list }
      lbExchPrinters.ItemIndex := LongInt(lbWinPrinters.Items.Objects[lbWinPrinters.ItemIndex]) - 100;
    End { If }
    Else Begin
      { No printer already selected - default to first }
      lbExchPrinters.ItemIndex := -1;
      lbExchPrintersClick(Sender);
    End; { Else }
  End { If }
  Else
    { Shouldn't happen - but just in case, I've used VB too much! }
    lbExchPrinters.ItemIndex := -1;
end;

procedure TForm_PrnCodes.lbExchPrintersClick(Sender: TObject);
begin
  If (lbWinPrinters.ItemIndex > -1) And (lbExchPrinters.ItemIndex > -1) Then Begin
    lbWinPrinters.Items.Objects[lbWinPrinters.ItemIndex] := Pointer(lbExchPrinters.ItemIndex + 100);
  End; { If }
end;

procedure TForm_PrnCodes.btnOKClick(Sender: TObject);
Var
  Ok : Boolean;
  I  : SmallInt;
begin
  OK := True;
  For I := 0 To Pred(lbWinPrinters.Items.Count) Do Begin
    Ok := Ok And (((LongInt(lbWinPrinters.Items.Objects[I]) - 100) >= 0) And
                  ((LongInt(lbWinPrinters.Items.Objects[I]) - 100) <= lbExchPrinters.Items.Count));

    If (Not Ok) Then Begin
      lbWinPrinters.ItemIndex := I;
      MessageDlg ('The Exchequer Printer Code isn''t set for ' +
                  lbWinPrinters.Items.Strings[I],
                  mtError, [mbOk], 0);
      Break;
    End; { If }
  End; { If }

  If Ok Then Begin
    SaveToIni;
    Close;
  End; { If }
end;

procedure TForm_PrnCodes.btnCancelClick(Sender: TObject);
begin
  Close;
end;


procedure TForm_PrnCodes.SaveToIni;
Var
  I : Byte;
Begin
  { Save printer info to INI}
  For I := 0 To Pred (lbWinPrinters.Items.Count) Do Begin
    IniF.WriteString (SectName,
                      Copy(lbWinPrinters.Items.Strings[I], 1, 20),
                      Printer_defFile[LongInt(lbExchPrinters.Items.Objects[LongInt(lbWinPrinters.Items.Objects[I])-100])].Name);
  End; { For }
End;


Procedure InitPrnCodes;
Begin
  { Create an INI object for INI access }
  IniF := TIniFile.Create(SetDrive+'PrnCodes.Ini');

  { Load the Printer Codes }
  GetPdef;
End;

//-------------------------------------------------------------------------

procedure TForm_PrnCodes.btnEditPrinterCodesClick(Sender: TObject);
begin
  If (MessageDlg ('Any changes you have made will be lost, do you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
  Begin
    RunPrintersSetup;
    FormCreate(NIL);  // Reload the details
  End; // If (MessageDlg ('...
end;

//-------------------------------------------------------------------------

Initialization
  IniF := Nil;
Finalization
  If Assigned(IniF) Then
    IniF.Free;
end.
