unit sysfdet;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mask, TEditVal, StdCtrls, Grids, SBSOutl, ExtCtrls, GlobVar, VarConst,
  GlobType, ExWrap1U, Menus;

Const
  GlobDef = 'Global Defaults';

type
  PHWND = ^HWND;

  TSysFrmDet = class(TForm)
    NLDPanel: TPanel;
    NLOLine: TSBSOutlineC;
    NLRunPanel: TPanel;
    Label81: Label8;
    SetNo: TCurrencyEdit;
    Desc: Text8Pt;
    Label82: Label8;
    SaveBtn: TButton;
    CancelBtn: TButton;
    OpenDialog: TOpenDialog;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    ClearBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure NLOLineDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure NLOLineNeedValue(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PropFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure NLOLineDblClick(Sender: TObject);
    procedure NLOLineExpand(Sender: TObject; Index: Longint);
    procedure ClearBtnClick(Sender: TObject);
  private
    { Private declarations }
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord,
    ItemChanged : Boolean;
    LockPos     : LongInt;
    LITEMode : Boolean;
    procedure Find_FormCoord;
    procedure NotifyEnterprise(Const FormSetNo : Integer);
    Procedure Send_UpdateList(WPar, LPar :  Integer);
    procedure SetFormProperties;
    procedure Store_FormCoord(UpMode  :  Boolean);
  public
    { Public declarations }
    DispMode : Byte;
    Procedure DisplayRec;
    Procedure ShowLink;
    Function  ShowNew(WantCopy : Boolean) : Boolean;
  end;

function EnumWndProc (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;

// Used by LITE to edit the global form defs directly as the form definition
// sets are not supported
Procedure EditGlobalFormDefs;

implementation

{$R *.DFM}

Uses BtrvU2, BtSupU1, CmpCtrlU, ColCtrlU, EtStrU, FormUtil, EntLicence, Register;

Const
  TDpth      =  70;
Type
  FlagsType = (IsTitle, IsField, IsStock, IsSPOP, Warn, IsSubTitle);
  FlagsSetType = Set Of FlagsType;

//=========================================================================

// Used by LITE to edit the global form defs directly as the form definition
// sets are not supported
Procedure EditGlobalFormDefs;
Var
  SysFrmDet : TSysFrmDet;
Begin // EditGlobalFormDefs
  SysFrmDet := TSysFrmDet.Create(NIL);
  Try
    SysFrmDet.Caption := 'Default Forms';

    SysFrmDet.DispMode := 2;  // Edit

    // Trick detail window into loading the Global Form Definitions Set
    Syss.IDCode := SysNames[FormR];
    SysFrmDet.ShowLink;

    { Display Window }
    SysFrmDet.ShowModal;
  Finally
    SysFrmDet.Free;
  End;
End; // EditGlobalFormDefs

//=========================================================================

procedure TSysFrmDet.FormCreate(Sender: TObject);
Var
  CurrentParent,                         // Index of the item childred are being added into
  LastBaseTitle,                         // Index of the last root item added
  JobCostingSection,                     // Index of the Job Costing section
  JobApplicationsSection,                // Index of the Job Applications Forms section
  N, LastChild  : Integer;
  IncDiff : SmallInt;

  { Returns a string formatted to display in the outline }
  Function FormLineText(OutDepth : Byte; Title : ShortString) : String;
  Begin
    Result := Spc(1*OutDepth)+Strip('R',[#32],Title);
    Result := Result+Spc(Round((NLOLine.Width-Canvas.TextWidth(Result))/CanVas.TextWidth(' '))-(TDpth*OutDepth));
  End;

  Procedure AddDefType (Flags : FlagsSetType;
                        Title : ShortString;
                        DType : fdFormTypeType;
                        Idx1  : Integer);
  Var
    ONomRec : ^OutNomType;
    Depth   : Byte;
  begin
    New(ONomRec);
    FillChar(ONomRec^,Sizeof(ONomRec^),0);
    With ONomRec^ Do Begin
      If (IsField In Flags) Then Begin
        OutDepth := 1;
        OutNomCode := Idx1;
      End { If }
      Else
        If (IsSubTitle In Flags) Then Begin
          OutDepth := 1;
          OutNomCode := Idx1;
        End { If }
        Else Begin
          // IsTitle
          OutDepth := 0;
          OutNomCode := 0;
        End; { Else }

      LastPr := Ord(DType);
    End; { With }

    If (IsTitle In Flags) Then Begin
      LastBaseTitle := NLOLine.AddObject (LastBaseTitle{CurrentParent}, FormLineText(ONomRec^.OutDepth, Title), ONomRec);
      CurrentParent := LastBaseTitle;
    End { If (IsTitle In Flags) }
    Else
      If (IsSubTitle In Flags) Then
        CurrentParent := NLOLine.AddChildObject (CurrentParent, FormLineText(ONomRec^.OutDepth, Title), ONomRec)
      Else
        LastChild := NLOLine.AddChildObject (CurrentParent, FormLineText(ONomRec^.OutDepth, Title), ONomRec);
  end;

begin
  // Check for IRIS Accounts Office / LITE as we need to redesign the form and
  // suppress various entries in the tree
  LITEMode := (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct]);

  If LITEMode Then
  Begin
    // Hide No/Name fields
    Label81.Visible := False;
    SetNo.Visible := False;
    Label82.Visible := False;
    Desc.Visible := False;

    // Move other fields upp
    IncDiff := NLDPanel.Top - SetNo.Top;
    NLDPanel.Top := NLDPanel.Top - IncDiff;
    NLRunPanel.Top := NLDPanel.Top;
    NLOLine.Top := NLOLine.Top - IncDiff;
    ClearBtn.Top := ClearBtn.Top - IncDiff;
    SaveBtn.Top := ClearBtn.Top;
    CancelBtn.Top := ClearBtn.Top;

    // Resize form
    ClientHeight := ClientHeight - IncDiff;
  End; // If LITEMode

  { Load List }
  ItemChanged := False;
  CurrentParent := 0;
  LastChild := 0;
  LastBaseTitle := 0;
  AddDefType ([IsTitle], 'Customer/Supplier', ftForm, 0);
  AddDefType ([IsField], 'Customer/Supplier Account Details', ftForm, 1);
  AddDefType ([IsField], 'Customer/Supplier Trading History', ftForm, 2);
  AddDefType ([IsField], 'Customer/Supplier Labels', ftLabel, 3);
  AddDefType ([IsField, Warn], 'Customer/Supplier Sales Statement', ftForm, 4);
  AddDefType ([IsField, Warn], 'Supplier Remittance Advice', ftForm, 5);
  AddDefType ([IsField, Warn], 'Debt Chase Letter 1', ftForm, 38);
  AddDefType ([IsField, Warn], 'Debt Chase Letter 2', ftForm, 39);
  AddDefType ([IsField, Warn], 'Debt Chase Letter 3', ftForm, 40);

  AddDefType ([IsTitle], 'Sales', ftForm, 0);
  AddDefType ([IsField], 'Sales Invoice (SIN)', ftForm, 6);
  AddDefType ([IsField], 'Sales Invoice with Receipt (SRI)', ftForm, 7);
  AddDefType ([IsField], 'Sales Credit Note (SCR)', ftForm, 8);
  AddDefType ([IsField], 'Sales Credit with Refund (SRF)', ftForm, 9);
  AddDefType ([IsField], 'Sales Quotation (SQU)', ftForm, 10);
  AddDefType ([IsField], 'Sales Order (SOR/SQU)', ftForm, 11);
  AddDefType ([IsField], 'Sales Pro-Forma (SQU)', ftForm, 12);
  AddDefType ([IsField], 'Sales Delivery Note (SDN/SQU)', ftForm, 13);
  AddDefType ([IsField], 'Sales Receipt (SRC)', ftForm, 14);
  AddDefType ([IsField], 'Sales Journal Invoice (SJI)', ftForm, 15);
  AddDefType ([IsField], 'Sales Journal Credit (SJC)', ftForm, 16);
  AddDefType ([IsField, IsSPOP, Warn], 'Consolidated Picking List', ftForm, 17);
  AddDefType ([IsField, IsSPOP, Warn], 'Individual Picking List', ftForm, 18);
  AddDefType ([IsField, IsSPOP, Warn], 'Sales Consignment Note', ftForm, 19);
  AddDefType ([IsField, IsSPOP, Warn], 'Sales Delivery Label', ftLabel, 20);
  AddDefType ([IsField, IsSPOP, Warn], 'Product Labels for Delivery Run', ftLabel, 21);

  { HM 23/03/00: Added new form }
  AddDefType ([IsField], 'Sales Receipt Details (SRC)', ftForm, 45);

  // MH 15/09/2014: Extended for Order Payment Payment/Refund transactions
  AddDefType ([IsField], 'Order Payment (SRC) as VAT Receipt', ftForm, 65);
  AddDefType ([IsField], 'Order Refund (SRC) as VAT Receipt', ftForm, 66);

  AddDefType ([IsTitle], 'Purchase', ftForm, 0);
  AddDefType ([IsField], 'Purchase Invoice (PIN)', ftForm, 22);
  AddDefType ([IsField], 'Purchase Payment (Remittance Advice)(PPY)', ftForm, 41);
  AddDefType ([IsField], 'Purchase Credit Note (PCR)', ftForm, 23);
  AddDefType ([IsField], 'Purchase Quotation (PQU)', ftForm, 24);
  AddDefType ([IsField, IsSPOP, Warn], 'Purchase Order (POR)', ftForm, 25);
  AddDefType ([IsField], 'Purchase Delivery Note (PDN)', ftForm, 42);
  AddDefType ([IsField], 'Purchase Journal Invoice (PJI)', ftForm, 26);
  AddDefType ([IsField], 'Purchase Journal Credit (PJC)', ftForm, 27);
  AddDefType ([IsField], 'Purchase Payment with Invoice (PPI)', ftForm, 28);
  AddDefType ([IsField], 'Purchase Refund (PRF)', ftForm, 29);

  { HM 23/03/00: Added new form }
  AddDefType ([IsField], 'Purchase Payment Debit Note (PPY)', ftForm, 46);

  AddDefType ([IsTitle, IsStock], 'Stock', ftForm, 0);
  AddDefType ([IsField, IsStock], 'Stock Record with Bill Of Materials List', ftForm, 30);
  AddDefType ([IsField, IsStock], 'Stock Record with Notes', ftForm, 31);
  AddDefType ([IsField, IsStock], 'Stock Adjustment (ADJ)', ftForm, 32);

  If (Not LITEMode) Then
  Begin
    AddDefType ([IsTitle], 'Job Costing', ftForm, 0);
    JobCostingSection := currentParent;
    AddDefType ([IsField], 'Time Sheet', ftForm, 35);
    AddDefType ([IsField], 'Backing Sheet', ftForm, 36);
    AddDefType ([IsField], 'Job Record', ftForm, 37);
    { HM 14/09/00: Added new form }
    AddDefType ([IsField], 'Self Billing Sub Contractor Invoice (PJI)', ftForm, 47);

    // HM 06/01/03: Added CIS Forms
    If CISOn Then Begin
      // Add sub-section for CIS Forms
      AddDefType ([IsSubTitle], 'CIS/RCT Forms', ftForm, 0);
      // MH 01/11/06: Modified for v5.71 CIS340 Changes
      //AddDefType ([IsField], 'CIS23 Voucher/RCT47', ftForm, 52);
      AddDefType ([IsField], 'CIS Gross/RCT47', ftForm, 52);
      AddDefType ([IsField], 'CIS24 Voucher', ftForm, 53);
      // MH 01/11/06: Modified for v5.71 CIS340 Changes
      //AddDefType ([IsField], 'CIS25 Voucher/RCTDC', ftForm, 54);
      AddDefType ([IsField], 'CIS Low/High Statement/RCTDC', ftForm, 54);
    End; { If CISOn }

    // HM 25/02/04: Added Apps & Vals Forms
    If JAPOn Then
    Begin
      CurrentParent := JobCostingSection;
      AddDefType ([IsSubTitle], 'Job Application Forms', ftForm, 0);
      JobApplicationsSection := CurrentParent;
      AddDefType ([IsSubTitle],   'Sales Applications', ftForm, 0);
      AddDefType ([IsField],        'Job Sales Terms (JST)', ftForm, 56);
      AddDefType ([IsField],        'Job Sales Application (JSA)', ftForm, 59);
      AddDefType ([IsField],        'Job Sales Certified Application (JSA)', ftForm, 61);
      CurrentParent := JobApplicationsSection;
      AddDefType ([IsSubTitle],   'Purchase Applications', ftForm, 0);
      AddDefType ([IsField],        'Job Purchase Terms (JPT)', ftForm, 55);
      AddDefType ([IsField],        'Job Contract Terms (JCT)', ftForm, 57);
      AddDefType ([IsField],        'Job Purchase Application (JPA)', ftForm, 58);
      AddDefType ([IsField],        'Job Purchase Certified Application (JPA)', ftForm, 60);
    End; // If JAPOn

    {$IFDEF EN570}
    If RetMOn Then
    Begin
      AddDefType ([IsTitle], 'Returns Module', ftForm, 0);
      AddDefType ([IsField], 'Sales Return (SRN)', ftForm, 62);
      AddDefType ([IsField], 'Sales Return (SRN) as Sales Repair Quotation', ftForm, 63);
      AddDefType ([IsField], 'Purchase Return (PRN) ', ftForm, 64);
    End; // If RetMOn
    {$ENDIF}

    { HM 05/07/01: Added WOP }
    AddDefType ([IsTitle], 'Works Order Processing', ftForm, 0);
    AddDefType ([IsField], 'Consolidated Works Picking List', ftForm, 51);
    AddDefType ([IsField], 'Works Issue Note', ftForm, 48);
    AddDefType ([IsField], 'Works Order', ftForm, 49);
    AddDefType ([IsField], 'Works Picking List', ftForm, 50);
  End; // If (Not LITEMode)

  AddDefType ([IsTitle], 'Miscellaneous', ftForm, 0);
  AddDefType ([IsField], 'Email Cover Sheet', ftForm, 43);
  If (Not LITEMode) Then AddDefType ([IsField], 'Fax Cover Sheet', ftForm, 44);
  AddDefType ([IsField], 'Nominal Transfer (NOM)', ftForm, 33);
  AddDefType ([IsField], 'Sales/Purchase Batch Entry', ftForm, 34);

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;
  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  { Load in the saved coordinates }
  Find_FormCoord;
end;

procedure TSysFrmDet.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
Var
  N : Integer;
begin
  Status:=UnlockMultiSing(F[SysF],SysF,LockPos);

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  Store_FormCoord(Not SetDefault);
end;

procedure TSysFrmDet.FormDestroy(Sender: TObject);
begin
  {  }
end;

procedure TSysFrmDet.NLOLineDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
Var
  ItemInfo    : ^OutNomType;
  DrawIdxCode : LongInt;
begin
  With NLOLine Do Begin
    DrawIdxCode:=CalcIdx;

    If (DrawIdxCode > 0) And (DrawIdxCode = SelectedItem) Then Begin
      ItemInfo := Items[DrawIdxCode].Data;

      If Assigned (ItemInfo) Then Begin
        {  }
      End; { If }
    End; { If }
  End; { With }
end;

procedure TSysFrmDet.NLOLineDblClick(Sender: TObject);
{Var
  ItemInfo    : ^OutNomType;
  DrawIdxCode : LongInt;
  CurDir      : ShortString;
  FilePath    : SplitFNameType;}
begin
  (*
  With Sender as TSBSOutLineC do Begin
    If (SelectedItem > 0) Then Begin
      ItemInfo := Items[SelectedItem].Data;

      If Assigned(ItemInfo) And (ItemInfo^.OutNomCode > 0) Then Begin
        { Save current directory path}
        CurDir := GetCurrentDir;

        OpenDialog.InitialDir := SystemInfo.ExDataPath + FormsPath;

        If OpenDialog.Execute Then Begin
          FilePath := SplitFileName (PathToShort(OpenDialog.FileName));

          { put name of file into edit box }
          If ValidFormDef (FilePath, True) Then Begin
            { Check its in the forms directory }
            If (UpperCase(FilePath.Path) = SplitFileName (SystemInfo.ExDataPath + FormsPath).Path) Then Begin
              SyssForms.FormDefs.PrimaryForm[ItemInfo^.OutNomCode] := Trim(FilePath.Name);
              ItemChanged := True;
              NLOLine.Refresh;
            End { If }
            Else
              MessageDlg ('Only Forms in the Forms directory can be used', mtInformation, [mbOk], 0);
          End; { If }
        End; { If }

        { restore current directory }
        SetCurrentDir(CurDir);
      End; { If }
    End; { If }
  End; { With }
  *)
end;

procedure TSysFrmDet.NLOLineNeedValue(Sender: TObject);
Var
  ItemInfo    : ^OutNomType;
  DrawIdxCode : LongInt;
begin
  With Sender as TSBSOutLineC do Begin
    DrawIdxCode:=CalcIdx;

    If (DrawIdxCode>0) Then Begin
      ItemInfo := Items[DrawIdxCode].Data;

      If Assigned(ItemInfo) Then
        With ItemInfo^ Do Begin
          If (OutNomCode > 0) Then Begin
            ColValue := SyssForms^.FormDefs.PrimaryForm[OutNomCode];
          End { If }
          Else
            ColValue := '';

          With Items[DrawIdxCode] Do
            ColsX:=NLRunPanel.Left;
        End; { With }
    End; { If }
  End; { With }
end;

Procedure TSysFrmDet.DisplayRec;
Begin
  With SyssForms^, FormDefs Do Begin
    { Set caption }
    If (Not LITEMode) Then
    Begin
      If (DispMode = 2) Then
        Caption := 'Edit Form Definition Set'
      Else
        Caption := 'New Form Definition Set';
    End; // If (Not LITEMode)

    { Enable/Disable for mode }
    If (DispMode = 2) Or (IdCode = SysNames[FormR]) Then Begin
      SetNo.ReadOnly := True;
      Desc.ReadOnly := (IdCode = SysNames[FormR]);
    End; { If }

    { Display fields }
    If (IdCode = SysNames[FormR]) Then Begin
      SetNo.Value := 0;
      Desc.Text := GlobDef;
    End { If }
    Else Begin
      SetNo.Value := Ord(IDCode[3]) - 100;
      Desc.Text := Descr;
    End; { Else }
  End; { With }
End;

Procedure TSysFrmDet.ShowLink;
Var
  Key2F      : Str255;
  OK, Locked : Boolean;
Begin
  { Lock record }
  Status := 0;
  Locked := BOn;
  Key2F := Syss.IDCode;
  Ok:=GetMultiRec(B_GetEq,B_MultLock,Key2F,0,SysF,True,Locked);
  Report_BError(SysF, Status);

  Status:=GetPos(F[SysF],SysF,LockPos);

  If OK And StatusOk And Locked Then Begin
    { Copy into forms structure }
    Move(Syss, SyssForms^, Sizeof(SyssForms^));

    { display }
    DisplayRec;
  End; { If }
End;

procedure TSysFrmDet.SaveBtnClick(Sender: TObject);
Var
  KeyS       : Str255;
  ValidError : Boolean;
begin
  With SyssForms^, FormDefs Do Begin
    { Load details into record }
    IdCode := SysNames[FormR];
    If Not Desc.ReadOnly Then
      IdCode[3] := Chr(Round(100 + SetNo.Value));
    Descr := Desc.Text;

    ValidError := False;
    If Not Desc.ReadOnly Then Begin
      { Validate - if we are allowed to modify it }
      If (Not SetNo.ReadOnly) Then Begin
        { Check SetNo is ok }
        If (Round(SetNo.Value) In [1..99]) Then Begin
          { Check number doesn't already exist }
          KeyS := IDCode;
          ValidError := CheckExsists (KeyS, SysF, SysK);

          If ValidError Then
            MessageDlg ('A Form Defintion already exists with this Set Number', mtWarning, [mbOk], 0);
        End { If }
        Else Begin
          { Invalid Set Number }
          ValidError := True;
          MessageDlg ('The Set Number must be in the range 1 to 99', mtWarning, [mbOk], 0);
        End; { Else }
      End; { If }

      If (Not ValidError) Then Begin
        { Check its not blank }
        ValidError := (Trim (Descr) = '');

        If ValidError Then
          MessageDlg ('The Description cannot be left blank', mtWarning, [mbOk], 0);
      End; { If }
    End; { If }
  End; { With }

  If (Not ValidError) Then Begin
    { Move into global syss record }
    Move(SyssForms^,Syss,Sizeof(SyssForms^));

    If (DispMode = 2) Then Begin
      { Edit }
      Status:=Put_Rec(F[SysF],SysF,RecPtr[SysF]^,0);

      { Unlock }
      Status:=UnlockMultiSing(F[SysF],SysF,LockPos);
    End { If }
    Else Begin
      { Add/Copy }
      Status := Add_rec(F[SysF],SysF,RecPtr[SysF]^,0);
    End; { Else }

    Report_BError (SysF, Status);

    If (DispMode = 2) Then
      Send_UpdateList(200,0)
    Else
      Send_UpdateList(100,0);

    // HM 09/10/00: Notify Exchequer of changes to Form Definition Sets
    NotifyEnterprise(Round(SetNo.Value));

    Close;
  End; { If }
end;


{ Callback function to identify the Exchequer window }
function EnumWndProc (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;
var
  ClassName : string;
  Tag       : THandle;
begin
  Result := True;
  SetLength (ClassName, 100);
  GetClassName (Hwnd, PChar (ClassName), Length (ClassName));
  ClassName := PChar (Trim(ClassName));

  If (AnsiCompareText (ClassName, 'TMainForm') = 0) then begin
    Tag := GetWindowLong (Hwnd, GWL_USERDATA);
    If (Tag = 1011) Then Begin
      FoundWnd^ := Hwnd;
      Result := False;
    End; { If }
  End; { If }
end;

// HM 09/10/00: Notify Exchequer of changes to Form Definition Sets
procedure TSysFrmDet.NotifyEnterprise(Const FormSetNo : Integer);
Var
  OldHWnd : HWnd;
begin { NotifyEnterprise }
  // Try to detect Exchequer by enumerating the Windows
  OldHwnd := 0;
  EnumWindows (@EnumWndProc, Longint(@OldHwnd));
  If (OldHwnd <> 0) Then
    // Got Handle - Send notification message
    PostMessage (OldHwnd, WM_PrintProgress, 90, FormSetNo);
end; { NotifyEnterprise }


procedure TSysFrmDet.CancelBtnClick(Sender: TObject);
begin
  { Check for changes }
  If SetNo.Modified Or Desc.Modified Or ItemChanged Then Begin
    If (MessageDlg ('Abandon Changes?', mtConfirmation, [mbYes, mbNo],0) = mrYes) Then
      Close;
  end
  else
    Close;
end;

Function TSysFrmDet.ShowNew(WantCopy : Boolean) : Boolean;
Var
  NS : Byte;

  Function NextSet : Byte;
  Var
    KeyS : Str255;
  Begin
    Result := 0;

    Repeat
      Inc (Result);
      KeyS := Copy (SysNames[FormR], 1, 2) + Chr(100 + Result);
    Until (Result > 99) Or (Not CheckExsists (KeyS, SysF, SysK));

    If (Result > 99) Then
      Result := 0;
  End;

Begin
  Result := True;

  { Initialise Record }
  If (Not WantCopy) Then
    Blank(SyssForms^,Sizeof(SyssForms^))
  Else
    Move(Syss, SyssForms^, Sizeof(SyssForms^));

  { Default SetNo to next available }
  SyssForms^.IdCode := SysNames[FormR];
  NS := NextSet;
  If (NS > 0) Then
    SyssForms^.IdCode[3] := Chr(100 + NS)
  Else
    { no more available numbers }
    Result := False;

  If Result Then
    { display }
    DisplayRec;
End;

{ == Procedure to Send Message to Get Record == }
Procedure TSysFrmDet.Send_UpdateList(WPar, LPar :  Integer);
Var
  Message1 :  TMessage;
  MessResult :  LongInt;
Begin
  If Assigned(Owner) Then
  Begin
    FillChar(Message1,Sizeof(Message1),0);

    With Message1 do Begin
      MSg:=WM_CustGetRec;
      WParam := 100 + WPar;
      LParam := LPar;
    end;

    With Message1 do
      MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);
  End; // If Assigned(Owner)
end; {Proc..}

procedure TSysFrmDet.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TSysFrmDet.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TSysFrmDet.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordFlg.Checked:=StoreCoord;
end;

procedure TSysFrmDet.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TSysFrmDet.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord := Not StoreCoord;
end;


procedure TSysFrmDet.SetFormProperties;
Var
  TmpPanel    :  Array[1..3] of TPanel;
  n           :  Byte;
  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;
Begin
  ResetDefaults:=BOff;

  For n:=1 to 3 do Begin
    TmpPanel[n]:=TPanel.Create(Self);
  end;

  try
    With NLOLine Do Begin
      TmpPanel[1].Font:=Font;
      TmpPanel[1].Color:=Color;

      TmpPanel[2].Font:=NLDPanel.Font;
      TmpPanel[2].Color:=NLDPanel.Color;

      TmpPanel[3].Color:=BarColor;
      TmpPanel[3].Font.Assign(TmpPanel[1].Font);
      TmpPanel[3].Font.Color:=BarTextColor;
    end;

    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,Self.Caption+' List Properties',BeenChange,ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then Begin
          With NLOLine Do Begin
            Font.Assign(TmpPanel[1].Font);
            Color:=TmpPanel[1].Color;

            NLDPanel.Font.Assign(TmpPanel[2].Font);
            NLDPanel.Color:=TmpPanel[2].Color;

            BarColor:=TmpPanel[3].Color;
            BarTextColor:=TmpPanel[3].Font.Color;

            NLRunPanel.Font.Assign(TmpPanel[2].Font);
            NLRunPanel.Color:=TmpPanel[2].Color;

            SetNo.Color := NLOLine.Color;
            SetNo.Font.Assign(NLOLine.Font);

            Desc.Color := NLOLine.Color;
            Desc.Font.Assign(NLOLine.Font);
          End; { With }
        end;
      end;
    finally
      ColourCtrl.Free;
    end;
  Finally
    For n:=1 to 3 do
      TmpPanel[n].Free;
  End;

  If (ResetDefaults) then Begin
    SetDefault:=BOn;
    Close;
  end;
end;

procedure TSysFrmDet.Find_FormCoord;
Var
  ThisForm:  TForm;
  VisibleRect:  TRect;
  GlobComp:  TGlobCompRec;
  I        : Integer;
Begin
  New(GlobComp,Create(BOn));

  ThisForm:=Self;

  With GlobComp^ do Begin
    GetValues:=BOn;

    PrimeKey:='S';

    If (GetbtControlCsm(ThisForm)) then Begin
      StoreCoord:=(ColOrd=1);
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);
    end;

    If GetbtControlCsm(NLOLine) then
      NLOLine.BarColor:=ColOrd;

    If GetbtControlCsm(NLDPanel) then
      NLOLine.BarTextColor:=ColOrd;

    GetbtControlCsm(NLRunPanel);

    SetNo.Color := NLOLine.Color;
    SetNo.Font.Assign(NLOLine.Font);

    Desc.Color := NLOLine.Color;
    Desc.Font.Assign(NLOLine.Font);
  End; { With }
end;

procedure TSysFrmDet.Store_FormCoord(UpMode  :  Boolean);
Var
  GlobComp : TGlobCompRec;
  I        : Integer;
Begin
  New(GlobComp,Create(BOff));

  With GlobComp^ do Begin
    GetValues:=UpMode;

    PrimeKey:='S';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    ColOrd:=NLOLine.BarColor;

    StorebtControlCsm(NLOLine);

    ColOrd:=NLOLine.BarTextColor;

    StorebtControlCsm(NLDPanel);

    StorebtControlCsm(NLRunPanel);
  end; {With GlobComp..}

  GlobComp.Destroy;
end;

procedure TSysFrmDet.NLOLineExpand(Sender: TObject; Index: Longint);
Var
  ItemInfo      : ^OutNomType;
  DrawIdxCode   : LongInt;
  CurDir, FName : ShortString;
  FilePath      : SplitFNameType;
begin
  With Sender as TSBSOutLineC do Begin
    If (SelectedItem > 0) Then Begin
      ItemInfo := Items[SelectedItem].Data;

      If Assigned(ItemInfo) And (ItemInfo^.OutNomCode > 0) Then Begin
        { Save current directory path}
        CurDir := GetCurrentDir;

        { Inteliggently setup extension and file type }
        FName := SetDrive + FormsPath + SyssForms^.FormDefs.PrimaryForm[ItemInfo^.OutNomCode] + DefDotExtension;
        If FileExists (FName) Then Begin
          OpenDialog.FileName := SyssForms^.FormDefs.PrimaryForm[ItemInfo^.OutNomCode] + DefDotExtension;
          {OpenDialog.FilterIndex := 1;}
        End { If }
        Else Begin
          OpenDialog.FileName := SyssForms^.FormDefs.PrimaryForm[ItemInfo^.OutNomCode] + '.' + DefPCCExtension;
          {OpenDialog.FilterIndex := 2;}
        End; { Else }
        OpenDialog.InitialDir := SystemInfo.ExDataPath + FormsPath;

        If OpenDialog.Execute Then Begin
          FilePath := SplitFileName (PathToShort(OpenDialog.FileName));

          { put name of file into edit box }
          If ValidFormDef (FilePath, True) Then Begin
            { Check its in the forms directory }
//ShowMessage ('Company Directory: ' + SystemInfo.ExDataPath + #13 +
//             'Forms Directory: ' + SystemInfo.ExDataPath + FormsPath + #13 +
//             'Selected Form: ' + OpenDialog.FileName + #13 +
//             'Form Path: ' + UpperCase(FilePath.Path) + #13 +
//             'Compare Forms Path: ' + SplitFileName (SystemInfo.ExDataPath + FormsPath).Path);

            If (UpperCase(FilePath.Path) = SplitFileName (SystemInfo.ExDataPath + FormsPath).Path) Then Begin
              { Check its the correcct type - PCC can be anything }
              If (FilePath.Extension = DefPCCExtension) Or
                 (Ord(GetFormInfo (Trim(FilePath.Name)).FormHeader.fhFormType) = ItemInfo^.LastPr) Then Begin
                SyssForms^.FormDefs.PrimaryForm[ItemInfo^.OutNomCode] := Trim(FilePath.Name);
                ItemChanged := True;
                NLOLine.Refresh;
              End { If }
              Else
                MessageDlg ('Invalid Form Type', mtInformation, [mbOk], 0);
            End { If }
            Else
              MessageDlg ('Only Forms in the Forms directory can be used', mtInformation, [mbOk], 0);
          End; { If }
        End; { If }

        { restore current directory }
        SetCurrentDir(CurDir);
      End; { If }
    End; { If }
  End; { With }
end;

procedure TSysFrmDet.ClearBtnClick(Sender: TObject);
Var
  ItemInfo    : ^OutNomType;
  DrawIdxCode : LongInt;
  CurDir      : ShortString;
  FilePath    : SplitFNameType;
begin
  With NLOLine Do Begin
    If (SelectedItem > 0) Then Begin
      ItemInfo := Items[SelectedItem].Data;

      If Assigned(ItemInfo) And (ItemInfo^.OutNomCode > 0) Then Begin
        { Save current directory path}
        CurDir := GetCurrentDir;

        SyssForms^.FormDefs.PrimaryForm[ItemInfo^.OutNomCode] := '';
        ItemChanged := True;
        NLOLine.Refresh;

        { restore current directory }
        SetCurrentDir(CurDir);
      End; { If }
    End; { If }
  End; { With }
end;

end.
