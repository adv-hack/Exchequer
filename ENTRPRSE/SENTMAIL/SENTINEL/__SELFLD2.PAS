unit selfld2;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls,{SBSPanel,} BtrvU2, {BTSupU1, GlobVar, GlobType,
  VarConst, DataDict, bkgroup, }ComCtrls, BorBtns;

Const
  TabNo_Account  = 1;
  TabNo_Trans    = 2;
  TabNo_Lines    = 3;
  TabNo_Stock    = 4;
  TabNo_Location = 5;
  TabNo_Serial   = 6;
  TabNo_JobCost  = 7;
  TabNo_Misc     = 8;
  TabNo_System   = 9;

type
  String10 = String[10];

  TForm_SelectField2 = class(TForm)
    Button_Select: TButton;
    Button_Cancel: TButton;
    PageControl1: TPageControl;
    tabAccount: TTabSheet;
    tabTrans: TTabSheet;
    tabDetail: TTabSheet;
    tabStock: TTabSheet;
    tabSerialNo: TTabSheet;
    lstAccount: TListBox;
    tabSystem: TTabSheet;
    lstNotes: TListBox;
    lstTrans: TListBox;
    lstDetail: TListBox;
    lstStock: TListBox;
    lstSerialNo: TListBox;
    lstSystem: TListBox;
    tabJobCost: TTabSheet;
    tabMisc: TTabSheet;
    tabLocation: TTabSheet;
    lstLocation: TListBox;
    lstJobCost: TListBox;
    lstMisc: TListBox;
    chkLoadAsXRef: TCheckBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button_SelectClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure lstAccountClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PageControl1Change(Sender: TObject);
    procedure chkLoadAsXRefClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lstAccountMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lstAccountKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    WantStr : String;
    WantIndex : Longint;
    MDown : Boolean;
    Procedure SetPage (Const NewPage : Byte);
    procedure LoadNotes;
  public
    { Public declarations }
    ActiveList : TListBox;
    Ok : Boolean;
    SC : String[2];
    ShortCode : String10;
    FirstTime : Boolean;
    Procedure SetShortCode (NewCode : String10; Const DefPage : Byte);
  end;

var
  Form_SelectField2: TForm_SelectField2;

implementation

{$R *.DFM}

//Uses {ETStrU, FormUtil;

uses
  RwOpenF, Math;

type
  Str255 = String[255];

function LJVar(const s : ShortString; Len : SmallInt) : ShortString;
begin
  Result := s + Copy(StringOfChar(' ', Len), 1, Len);
end;

procedure LoadDDList(AList : TListBox; Prefix : ShortString);
Const
  FNum    = DictF;
  KeyPath = DIK;
var
  Res : SmallInt;
  KeyS : String[255];
  DataRec             : DataDictRec;
begin
  KeyS := 'DV' + Prefix;
  Res := Find_Rec (B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
  while (Res = 0) and (KeyS[1] = 'D') and (KeyS[2] = 'V') and
        (KeyS[3] = Prefix[1]) and (KeyS[4] = Prefix[2]) do
  begin
    With DictRec^, DataVarRec Do
    begin
      AList.Items.Add(VarName + #9 + Trim(VarDesc));
    end;

    Res := Find_Rec (B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
  end;
end;


procedure TForm_SelectField2.FormCreate(Sender: TObject);
begin
  Ok := False;
  ActiveList := Nil;

  { Set ID Tags on TabSheets }
  tabAccount.Tag := TabNo_Account;
  tabTrans.Tag := TabNo_Trans;
  tabDetail.Tag := TabNo_Lines;
  tabStock.Tag := TabNo_Stock;
  tabLocation.Tag := TabNo_Location;
  tabSerialNo.Tag := TabNo_Serial;
  tabJobCost.Tag := TabNo_JobCost;
  tabMisc.Tag := TabNo_Misc;
  tabSystem.Tag := TabNo_System;

  { Set Visible status on Tabs }
  tabAccount.TabVisible  := True; { All Versions }
  tabTrans.TabVisible    := True; { All Versions }
  tabDetail.TabVisible   := True; { All Versions }
//  tabStock.TabVisible    := (SystemInfo.ExVersionNo In [2, 4..6, 8, 9, 11]); { Stock + SPOP }
//  tabLocation.TabVisible := (SystemInfo.ExVersionNo In [5, 6, 9, 11]); { SPOP }
//  tabSerialNo.TabVisible := (SystemInfo.ExVersionNo In [5, 6, 9, 11]); { SPOP }
//  tabJobCost.TabVisible  := (SystemInfo.ExVersionNo In [6, 11]); { JC Only }
  tabMisc.TabVisible     := True; { All Versions }
  tabSystem.TabVisible   := True; { All Versions }
end;

procedure TForm_SelectField2.Button_SelectClick(Sender: TObject);
begin
  lstAccountClick(ActiveList);
  Ok := True;
  Close;
end;

procedure TForm_SelectField2.Button_CancelClick(Sender: TObject);
begin
  Ok := False;
  Close;
end;


Procedure TForm_SelectField2.SetPage (Const NewPage : Byte);
Begin { SetPage }
  { Switch to Page }
  Case NewPage Of
    TabNo_Account  : PageControl1.ActivePage := tabAccount;
    TabNo_Trans    : PageControl1.ActivePage := tabTrans;
    TabNo_Lines    : PageControl1.ActivePage := tabDetail;
    TabNo_Stock    : PageControl1.ActivePage := tabStock;
    TabNo_Location : PageControl1.ActivePage := tabLocation;
    TabNo_Serial   : PageControl1.ActivePage := tabSerialNo;
    TabNo_JobCost  : PageControl1.ActivePage := tabJobCost;
    TabNo_Misc     : PageControl1.ActivePage := tabMisc;
    TabNo_System   : PageControl1.ActivePage := tabSystem;
  End; { Case }

  { Force it to load list where necessary }
  PageControl1Change(Self);
End; { SetPage }


{ highlight this field in the list }
Procedure TForm_SelectField2.SetShortCode (NewCode : String10; Const DefPage : Byte);
Var
  PrefStr    : String[2];
  ChkLen     : Byte;
  I          : LongInt;
begin
  If (Trim(NewCode) <> '') Then Begin
    { Analyse code to work out file }
    PrefStr := UpperCase(Trim(Copy (NewCode, 1, 2)));
    ChkLen := Length(PrefStr);
    If (ChkLen > 0) Then Begin
      For I := 1 To 12 Do Begin
        Case I Of
          { Customer/Supplier }
          1  : If (PrefStr = Copy ('AC', 1, ChkLen)) Or (PrefStr = Copy ('CU', 1, ChkLen)) Then Begin
                 SetPage(TabNo_Account);
                 Break;
               End; { If }
          { Transaction Header }
          2  : If (PrefStr = Copy ('TH', 1, ChkLen)) Or (PrefStr = Copy ('CH', 1, ChkLen)) Then Begin
                 SetPage(TabNo_Trans);
                 Break;
               End; { If }
          { Transaction Details }
          3  : If (PrefStr = Copy ('TL', 1, ChkLen)) Then Begin
                 SetPage(TabNo_Lines);
                 Break;
               End; { If }
          { Stock }
          4  : If tabStock.TabVisible Then Begin
                 If (PrefStr = Copy ('ST', 1, ChkLen)) Then Begin
                   SetPage(TabNo_Stock);
                   Break;
                 End; { If }
               End; { If }
          { Job Costing }
          5  : If tabJobCost.TabVisible Then Begin
                 If (PrefStr = Copy ('JC', 1, ChkLen)) Or (PrefStr = Copy ('JR', 1, ChkLen)) Then Begin
                   SetPage(TabNo_JobCost);
                   Break;
                 End; { If }
               End; { If }
          { Location/Stock-Location }
          6  : If tabLocation.TabVisible Then Begin
                 If (PrefStr = Copy ('SL', 1, ChkLen)) Or (PrefStr = Copy ('ML', 1, ChkLen)) Then Begin
                   SetPage(TabNo_Location);
                   Break;
                 End; { If }
               End; { If }
          { Batch/Serial Numbers }
          7  : If tabSerialNo.TabVisible Then Begin
                 If (PrefStr = Copy ('SN', 1, ChkLen)) Then Begin
                   SetPage(TabNo_Serial);
                   Break;
                 End; { If }
               End; { If }
          { Misc JC: Employee, Time Rates, Analysis, Job Actuals, Job Budgets, Job Retentions, Job Types }
          8  : If tabJobCost.TabVisible Then Begin
                 If (PrefStr = Copy ('EM', 1, ChkLen)) Or (PrefStr = Copy ('TR', 1, ChkLen)) Or
                    (PrefStr = Copy ('AN', 1, ChkLen)) Or (PrefStr = Copy ('JA', 1, ChkLen)) Or
                    (PrefStr = Copy ('JB', 1, ChkLen)) Or (PrefStr = Copy ('JE', 1, ChkLen)) Or
                    (PrefStr = Copy ('JT', 1, ChkLen)) Then Begin
                   SetPage(TabNo_JobCost);
                   Break;
                 End; { If }
               End; { If }
          { Miscellaneous: Cost Centre/Department, Nominal, Notes, Trade Counter }
          9  : If (PrefStr = Copy ('CC', 1, ChkLen)) Or (PrefStr = Copy ('NM', 1, ChkLen)) Or
                  (PrefStr = Copy ('NO', 1, ChkLen)) Or (PrefStr = Copy ('TC', 1, ChkLen)) Then Begin
                 SetPage(TabNo_Misc);
                 Break;
               End; { If }
          { System Setup }
          10  : If (PrefStr = Copy ('SY', 1, ChkLen)) Or (PrefStr = Copy ('FAX', 1, ChkLen)) Or
                   (PrefStr = Copy ('EML', 1, ChkLen)) Then Begin
                 SetPage(TabNo_System);
                 Break;
               End; { If }
          { Customer Aging }
          11 : If (PrefStr = Copy ('C0', 1, ChkLen)) Or (PrefStr = Copy ('C4', 1, ChkLen)) Or
                  (PrefStr = Copy ('C2', 1, ChkLen)) Or (PrefStr = Copy ('C3', 1, ChkLen)) Or
                  (PrefStr = Copy ('C4', 1, ChkLen)) Or (PrefStr = Copy ('C5', 1, ChkLen)) Or
                  (PrefStr = Copy ('C6', 1, ChkLen)) Or (PrefStr = Copy ('C7', 1, ChkLen)) Or
                  (PrefStr = Copy ('C8', 1, ChkLen)) Or (PrefStr = Copy ('C9', 1, ChkLen)) Then Begin
                 SetPage(TabNo_System);
                 Break;
               End; { If }
          { No valid code specified - default intelligently depending on source }
          12 : Begin
                 SetPage(DefPage);
                 Break
               End;
        End; { Case }
      End; { For }
    End { If }
    Else Begin
      { No code specified - default intelligently depending on source }
      SetPage(DefPage);
    End; { Else }
  End { If }
  Else Begin
    { No code specified - default intelligently depending on source }
    SetPage(DefPage);
  End; { Else }

  If Assigned(ActiveList) Then Begin
    If (ActiveList.ItemIndex < 0) Then
      ActiveList.ItemIndex := 0;

    If (Trim(NewCode) <> '') Then Begin
      If (ActiveList.Items.Count > 0) Then Begin
        { Pad code out to 8 chars }
        NewCode := LJVar (NewCode, 8);

        { Find best match }
        For I := 0 To (ActiveList.Items.Count - 1) Do Begin
          If (Copy (ActiveList.Items.Strings[I], 1, 8) >= NewCode) Then Begin
            ActiveList.ItemIndex := I;
            Break;
          End; { If }
        End; { For }
      End; { If }
    End; { If }

    { Click the list now something is selected }
    If Assigned(ActiveList.OnClick) Then Begin
      ActiveList.OnClick(ActiveList);
    End; { If }
  End; { If }
end;

procedure TForm_SelectField2.lstAccountClick(Sender: TObject);
Var
  TmpStr : ShortString;
begin
  { Clicky clicky }
  With Sender As TListBox Do Begin

{    if not MDown and not FirstTime then
      ItemIndex := WantIndex;}
    MDown := False;
    If (ItemIndex >= 0) Then Begin
      TmpStr := Copy (Items.Strings[ItemIndex], 1, 8);
      If (Pos(#9, TmpStr) > 0) Then
        Delete(TmpStr, Pos(#9, TmpStr), Length(TmpStr));

      ShortCode := TmpStr;

      LoadNotes;
    End { If }
    Else
      ShortCode := '';
  End; { With }
end;

procedure TForm_SelectField2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

procedure TForm_SelectField2.FormKeyPress(Sender: TObject; var Key: Char);
begin
//  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TForm_SelectField2.PageControl1Change(Sender: TObject);
Var
  I : LongInt;
begin
  ActiveList := Nil;
  WantStr := '';
  WantIndex := 0;
{  chkLoadAsXRef.Visible := (PageControl1.ActivePage.Tag In [TabNo_Trans,
                                                            TabNo_Lines,
                                                            TabNo_Stock]);
 }
  Case PageControl1.ActivePage.Tag Of
    TabNo_Account  : Begin
                       If (lstAccount.Items.Count = 0) Then Begin
                         { Load Customer/Supplier Account fields }
                         LoadDDList (lstAccount, 'AC');
                         LoadDDList (lstAccount, 'CU');
                         For I := 0 To 29 Do Begin
                           LoadDDList (lstAccount, 'C' + IntToStr(I) + 'A');
                         End; { For }
                       End; { If }

                       ActiveList := lstAccount;
                     End; { TabNo_Account }
    TabNo_Trans    : Begin
                       If (lstTrans.Items.Count = 0) Or (lstTrans.Tag <> Ord(chkLoadAsXRef.Checked)) Then Begin
                         lstTrans.Clear;
                         lstTrans.Sorted := chkLoadAsXRef.Checked;
                         lstTrans.Tag := Ord(chkLoadAsXRef.Checked);

(*                         If chkLoadAsXRef.Checked Then Begin
                           { Load all XRef records for lines }
                           LoadFieldList(lstTrans, 3, 1);
                         End { If }
                         Else*) Begin
                           { Load Document Header fields }
                           LoadDDList (lstTrans, 'CH');
                           I := lstTrans.Items.Count;
                           LoadDDList (lstTrans, 'TH');

                           { Set Default selected item }
                           If (lstTrans.Items.Count > I) Then Begin
                             lstTrans.ItemIndex := I;
                           End; { If }
                         End; { Else }
                       End; { If }

                       ActiveList := lstTrans;
                     End; { TabNo_Trans }
    TabNo_Lines    : Begin
                       If (lstDetail.Items.Count = 0) Or (lstDetail.Tag <> Ord(chkLoadAsXRef.Checked)) Then Begin
                         lstDetail.Clear;
                         lstDetail.Sorted := chkLoadAsXRef.Checked;
                         lstDetail.Tag := Ord(chkLoadAsXRef.Checked);

(*                         If chkLoadAsXRef.Checked Then Begin
                           { Load all XRef records for lines }
                           LoadFieldList(lstDetail, 4, 1);
                         End { If }
                         Else *) Begin
                           { Load Document Detail fields }
                           LoadDDList (lstDetail, 'TL');
                         End; { Else }
                       End; { If }

                       ActiveList := lstDetail;
                     End; { TabNo_Lines }
    TabNo_Stock    : Begin
                       If (lstStock.Items.Count = 0) Or (lstStock.Tag <> Ord(chkLoadAsXRef.Checked)) Then Begin
                         lstStock.Clear;
                         lstStock.Sorted := chkLoadAsXRef.Checked;
                         lstStock.Tag := Ord(chkLoadAsXRef.Checked);

(*                         If chkLoadAsXRef.Checked Then Begin
                           { Load all XRef records for lines }
                           LoadFieldList(lstStock, 6, 1);
                         End { If }
                         Else *)Begin
                           { Load Stock fields }
                           LoadDDList (lstStock, 'ST');
                         End; { Else }
                       End; { If }

                       ActiveList := lstStock;
                     End; { TabNo_Stock }
    TabNo_Location : Begin
                       If (lstLocation.Items.Count = 0) Then Begin
                         LoadDDList (lstLocation, 'ML');
                         I := lstLocation.Items.Count;
                         LoadDDList (lstLocation, 'SL');

                         { Set Default selected item }
                         If (lstLocation.Items.Count > I) Then Begin
                           lstLocation.ItemIndex := I;
                         End; { If }
                       End; { If }

                       ActiveList := lstLocation;
                     End; { TabNo_Location }
    TabNo_Serial   : Begin
                       If (lstSerialNo.Items.Count = 0) Then Begin
                         LoadDDList (lstSerialNo, 'SN');
                       End; { If }

                       ActiveList := lstSerialNo;
                     End; { TabNo_Serial }
    TabNo_JobCost  : Begin
                       If (lstJobCost.Items.Count = 0) Then Begin
                         LoadDDList (lstJobCost, 'AN');
                         LoadDDList (lstJobCost, 'EM');
                         LoadDDList (lstJobCost, 'JA');
                         //LoadDDList (lstJobCost, 'JB');
                         LoadDDList (lstJobCost, 'JC');
                         //LoadDDList (lstJobCost, 'JE');
                         LoadDDList (lstJobCost, 'JR');
                         //LoadDDList (lstJobCost, 'JT');
                         LoadDDList (lstJobCost, 'TR');
                       End; { If }

                       ActiveList := lstJobCost;
                     End; { TabNo_JobCost }
    TabNo_Misc     : Begin
                       If (lstMisc.Items.Count = 0) Then Begin
                         LoadDDList (lstMisc, 'CC');
                         LoadDDList (lstMisc, 'NM');
                         LoadDDList (lstMisc, 'NO');
                         LoadDDList (lstMisc, 'TC');
                       End; { If }

                       ActiveList := lstMisc;
                     End; { TabNo_Misc }
    TabNo_System   : Begin
                       If (lstSystem.Items.Count = 0) Then Begin
                         LoadDDList (lstSystem, 'EML');
                         LoadDDList (lstSystem, 'FAX');
                         LoadDDList (lstSystem, 'SYS');
                       End; { If }

                       ActiveList := lstSystem;
                     End; { TabNo_System }
  End; { Case }

  If Assigned(ActiveList) Then Begin
    If Assigned(ActiveList.OnClick) Then Begin
      ActiveList.OnClick(ActiveList);
    End; { If }
  End; { If }
end;


procedure TForm_SelectField2.LoadNotes;
Const
  FNum    = DictF;
  KeyPath = DIK;
Var
  KeyS, KeyChk : Str255;
  Status : SmallInt;
Begin { LoadNotes }
(*  lstNotes.Clear;

  If Assigned(ActiveList) Then Begin
    If (ActiveList.ItemIndex > -1) Then Begin
      { Look for notes }
      KeyS := 'NA' + Copy(ActiveList.Items[ActiveList.ItemIndex], 1, 8) + '1';
      KeyChk := KeyS;
      KeyS := KeyS + '0001';
      Status := Find_Rec (B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);

      While StatusOk and CheckKey(KeyChk, KeyS, Length(KeyChk), BOn) Do Begin
        lstNotes.Items.Add (DictRec^.DNotesRec.NoteLine);

        Status := Find_Rec (B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
      End; { While }
    End; { If }
  End; { If } *)
End; { LoadNotes }


procedure TForm_SelectField2.chkLoadAsXRefClick(Sender: TObject);
begin
  If (chkLoadAsXRef.Tag <> Ord(chkLoadAsXRef.Checked)) Then Begin
    { Reload Lines list with XRef/Non-XRef dd fields }
    chkLoadAsXRef.Tag := Ord(chkLoadAsXRef.Checked);
    ActiveList.Clear;
    PageControl1Change(Sender);
  End; { If }
end;

procedure TForm_SelectField2.FormShow(Sender: TObject);
begin
  if ActiveList <> nil then
    ActiveControl := ActiveList
  else
  begin
    ActiveControl := lstAccount;
    ActiveList := lstAccount;
  end;
  WantStr := '';
  WantIndex := 0;
  Label1.Caption := WantStr;
  MDown := False;
end;

procedure TForm_SelectField2.lstAccountMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MDown := True;
end;

procedure TForm_SelectField2.lstAccountKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  i : integer;
  c : Char;
begin
  c := Char(Key);
  if Key = VK_BACK then
    Delete(WantStr, Length(WantStr), 1)
  else
  if c in ['A'..'Z', 'a'..'z'] then
    WantStr := WantStr + c;
  WantStr := UpperCase(WantStr);
  Label1.Caption := WantStr;

  if Assigned(ActiveList) then
  begin
    for i := 0 to ActiveList.Items.Count - 1 do
    begin
      if Pos(WantStr, ActiveList.Items[i]) = 1 then
      begin
     //   WantIndex := i;
        ActiveList.ItemIndex := i;
        Break;
      end;
    end;
  end;


end;

end.
