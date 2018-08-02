unit Uplftdlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles, CustAbsU;

type
  TfrmUplift = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    grpPackage: TGroupBox;
    lblBoxes: TLabel;
    edtAmount: TEdit;
    lstCcy: TComboBox;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    radWeight: TRadioButton;
    radValue: TRadioButton;
    radQuantity: TRadioButton;
    GroupBox2: TGroupBox;
    chkLine0: TCheckBox;
    chkLine1: TCheckBox;
    chkLine2: TCheckBox;
    chkLine3: TCheckBox;
    chkLine4: TCheckBox;
    chkExclNonStk: TCheckBox;
    chkExclBOM: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtAmountKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    EvData      : TAbsEnterpriseSystem;

    FrAmount    : Double;
    FrLineType  : Array [cuLineTIndex] Of Boolean;

    function LoadTKDLL : Boolean;
    Function UpdateTrans : Boolean;
  public
    { Public declarations }
    Procedure SetData (Const EventData : TAbsEnterpriseSystem);
  end;


Procedure CalcUplift (Const EventData : TAbsEnterpriseSystem);


implementation

{$R *.DFM}

Uses UseDLLU, TKUtil;

{$I ExDLLBt.Inc}        {* BTrieve Command Constant File *}
{$I ExchDll.Inc}        {* Record Structure File *}

FUNCTION EX_CONV_TCURR(P : POINTER; PSIZE  : SMALLINT) : SMALLINT;
         STDCALL; EXTERNAL 'ENTDLL32.DLL';


Var
  DLLOpen       : Boolean;


Procedure CalcUplift (Const EventData : TAbsEnterpriseSystem);
Var
  frmUplift    : TfrmUplift;
  OK           : Boolean;
  TransCode    : String[3];
Begin
  With EventData, Transaction Do Begin
    { Check Transaction Types }
    If (thInvDocHed In [cuPOR, cuPIN, cuPDN, cuPJI, cuPPI]) Then Begin
      { Check its not already posted or allocated }
      If (thRunNo <= 0) And (thSettled = 0) Then Begin
        If (thLines.thLineCount > 0) Then Begin
          { Display dialog }
          frmUplift := TfrmUplift.Create(Application.MainForm);
          Try
            frmUplift.SetData(EventData);

            frmUplift.ShowModal;
          Finally
            frmUplift.Free;
          End; { Try }
        End { If }
        Else Begin
          { No transaction lines }
          MessageDlg ('Freight cannot be applied to a Transaction with no lines', mtInformation, [mbOk], 0);
        End; { Else }
      End { If }
      Else Begin
        { Already posted or settled }
        MessageDlg ('Freight cannot be applied to a posted or allocated transaction', mtInformation, [mbOk], 0);
      End; { Else }
    End { If }
    Else Begin
      { Invalid Transaction Type }
      MessageDlg ('Freight cannot be applied to this Transaction Type', mtInformation, [mbOk], 0);
    End; { Else }
  End; { With }
End;


{==============================================================================}


Procedure TfrmUplift.FormCreate(Sender: TObject);
Begin
  { Centre over Enterprise }
  Top := Application.MainForm.Top + (Application.MainForm.Height div 2) - (Height Div 2);
  Left := Application.MainForm.Left + (Application.MainForm.Width div 2) - (Width Div 2);

  { Read in defaults from .INI file }
End;


{ Display info and selects the default Service Code from the list }
Procedure TfrmUplift.SetData(Const EventData : TAbsEnterpriseSystem);
Var
  TransStr : ShortString;
  I, P     : SmallInt;
Begin
  { Set customer details }
  With EventData, Setup, Transaction Do Begin
    { Load Currency List }
    For I := 1 To 30 Do Begin
      With ssCurrency[cuCurrencyType(I)] Do Begin
        { Add into list - translate £ signs first }
        TransStr := scSymbol;
        P := Pos(#156, TransStr);
        While (P > 0) Do Begin
          TransStr[P] := '£';

          P := Pos(#156, TransStr);
        End; { While }

        lstCcy.Items.Add (TransStr + ' - ' + scDesc);
      End; { With ssCurrency[cuCurrencyType(I)] }
    End; { For I }

    { Select Base Currency }
    lstCcy.ItemIndex := 0;
  End; { With EventData }

  { Take local copy of EventData Handle for use during the export }
  EvData := EventData;
End;


{ OK Button - Validate the info, close the dialog and continue the export }
procedure TfrmUplift.btnOKClick(Sender: TObject);
Var
  Err : Integer;
  OK  : Boolean;

  Function ConvertAmount (Const FreightCurr, THCurr : Byte;
                          Var   FreightAmt          : Double) : Boolean;
  Var
    ConvRec : ^TBatchConvTCurr;
    OK      : Boolean;
    Res     : SmallInt;
  Begin { ConvertAmount }
    OK := True;

    // check not already in Base Currency
    If (FreightCurr <> 1) Then Begin
      // Convert Uplift Amount to Base currency with Global Rates
      OK := (EX_ConvertAmount (FreightCurr, 1, FreightAmt, 0) = 0);
    End; { If (FreightCurr <> 1) }

    If OK Then Begin
      // Check to see if further conversion needed
      If (THCurr <> 1) Then Begin
        // Convert Uplift from Base to Transaction Currency using Transaction Rates
        New (ConvRec);
        FillChar (ConvRec^, SizeOf(ConvRec^), #0);
        With ConvRec^ Do Begin
          Amount       := FreightAmt;
          AmtCurr      := THCurr;
          ConvMode     := 0;
          ConvTo       := True;  { Base To AmtCurr }

          If (EvData.Setup.ssTotalConv = 'C') Then
            // Company Rate
            Rate  := EvData.Transaction.thCompanyRate
          Else
            // Daily Rate
            Rate  := EvData.Transaction.thDailyRate;
        End; { With ConvRec }

        Res := Ex_Conv_Tcurr(ConvRec, SizeOf(ConvRec^));
        OK := (Res = 0);
        If OK Then
          FreightAmt := ConvRec.RtnValue;
        Dispose (ConvRec);
      End; { If (THCurr <> 1) }
    End; { If OK }

    Result := OK;
  End; { ConvertAmount }

begin
  { Move focus to this button, this solves problem with CurrencyEdit controls }
  { not recognising the number until you leave the control.                   }
  btnOK.SetFocus;

  { Initialise Variables }
  FrAmount := 0.0;
  FillChar (FrLineType, SizeOf(FrLineType), #0);

  { Check Amount }
  OK := (Trim(edtAmount.Text) <> '');
  If OK Then Begin
    Val(edtAmount.Text, FrAmount, Err);
    OK := (Err = 0);

    If OK Then Begin
      OK := (FrAmount > 0.00);
    End; { If }
  End; { If }
  If (Not OK) Then Begin
    { Invalid Amount }
    If edtAmount.CanFocus Then edtAmount.SetFocus;
    MessageDlg ('The Freight Amount must be set correctly', mtWarning, [mbOk], 0);
  End; { If }

  If OK And (Not DLLOpen) Then Begin
    { Load Toolkit DLL }
    OK := LoadTKDLL;
    If (Not OK) Then Begin
      MessageDlg ('The Exchequer Toolkit DLL cannot be loaded', mtError, [mbOk], 0);
    End; { If (Not OK) }
  End; { If }

  If OK Then Begin
    { Check Currency }
    OK := (lstCcy.ItemIndex > -1);

    With EvData, Transaction Do Begin
      { Check currency is different }
      If OK Then Begin
        If (thCurrency <> Succ(lstCcy.ItemIndex)) Then Begin
          // HM 15/06/00: Modified Uplift Amount conversion to use transaction rates
          { Convert amount to transaction currency }
          {OK := (EX_ConvertAmount (Succ(lstCcy.ItemIndex), thCurrency, FRAmount, 0) = 0);}
          OK := ConvertAmount (Succ(lstCcy.ItemIndex), thCurrency, FRAmount);

          If (Not OK) Then Begin
            { Invalid Currency Exchange Rate }
            If lstCcy.CanFocus Then lstCcy.SetFocus;
            MessageDlg ('The amount could not be converted to transaction currency', mtWarning, [mbOk], 0);
          End; { If }
        End; { If }
      End { If OK }
      Else Begin
        { Currency Not Set }
        If lstCcy.CanFocus Then lstCcy.SetFocus;
        MessageDlg ('The Currency must be set', mtWarning, [mbOk], 0);
      End; { If }
    End; { With EvData, ... }
  End; { If }

  If OK Then Begin
    { Check at least 1 line type is selected }
    OK := chkLine0.Checked Or chkLine1.Checked Or chkLine2.Checked Or
          chkLine3.Checked Or chkLine4.Checked;
    If OK Then Begin
      { Copy Line Type flags into global array }
      FrLineType[0] := chkLine0.Checked;
      FrLineType[1] := chkLine1.Checked;
      FrLineType[2] := chkLine2.Checked;
      FrLineType[3] := chkLine3.Checked;
      FrLineType[4] := chkLine4.Checked;
    End { If }
    Else Begin
      If chkLine0.CanFocus Then chkLine0.SetFocus;
      MessageDlg ('At least one line type must be selected', mtWarning, [mbOk], 0);
    End; { If }
  End; { If }

  If OK Then Begin
    If UpdateTrans Then Begin
      Close;
    End; { If }
  End; { If }

  // HM 08/01/02: Closed Toolkit to prevent shared memory problems with other Plug-Ins
  If DLLOpen Then Begin
    Ex_CloseData;
    DLLOpen := False;
  End; { If DLLOpen }
end;


{ Cancel Button - Close dialog and cancel the export }
procedure TfrmUplift.btnCancelClick(Sender: TObject);
begin
  Close;
end;


{ Updates the Transaction with the number of boxes }
Function TfrmUplift.UpdateTrans : Boolean;
Var
  (*
  LocalTH    : TBatchTHRec;
  pTH        : ^TBatchTHRec;
  PC, PCPath : PChar;
  RecLockOk  : Boolean;
  mbRet      : Word;
  *)
  TotUnits, TransFr, UnitFr, LineUnits, LineFreight, LineQty : Double;
  I, NoWantLines                                             : SmallInt;
  {PCPath, }pOurRef, pStock                                    : PChar;
  B_Stat                                                     : SmallInt;
  TStr                                                       : ShortString;

  Function CalcQtyMul(Const TheLine : TAbsInvLine) : Double;
  Begin { CalcQtyMul }
    Result := 1;

  //PR: 16/11/2016 ABSEXGENERIC-403, ABSEXCH-17813 Uplift function in tk now calculates
  //    the quantity using QtyMul if necessary, so this is not needed. 
  {  If TheLine.tlUseQtyMul Then
      Result := TheLine.tlQtyMul;}
  End; { CalcQtyMul }

  { Returns True if we want the line }
  Function WantTL (TheLineNo : SmallInt) : Boolean;
  Var
    I : SmallInt;
  Begin { WantTL }
    Result := False;

    With EvData, Transaction.thLines, thLine[TheLineNo] Do Begin
      { Check Filters - Line Type }
      Result := FrLineType[tlLineType];

      If Result And chkExclNonStk.Checked Then Begin
        { Exclude Non-Stock Lines }
        Result := (Trim(tlStockCode) <> '');
      End; { If }

      If Result Then Begin
        { Process the 'Exclude BOM Kits' }
        If (Trim(tlStockCode) <> '') Then Begin
          { Stock Code Line }
          If (tlBomKitLink = 0) Then Begin
            { non-kit item - see if its the originating stock code }
            LinkToStock;

            If (Stock.stStockType = 'M') Then Begin
              { Bill Of Materials - exclude depending on flag and whether it is exploded onto Purchase Transactions }
              Result := chkExclBOM.Checked Or (Not Stock.stKitOnPurch);
            End { If }
            Else Begin
              { AOK }
              Result := True;
            End; { Else }
          End { If }
          Else Begin
            { Kit Item - exclude depending on flag }
            Result := (Not chkExclBOM.Checked);
          End; { Else }
        End { If }
        Else Begin
          { Description Line - check to see if its an additional description }
          { line or a manually entered line (tlBomKitLink = 0).              }
          Result := (tlBomKitLink = 0);
          If (Not Result) Then Begin
            { Additional description line - find parent stock code }
            If (TheLineNo > 1) Then Begin
              { look through previous lines for line containing stock code }
              For I := Pred(TheLineNo) DownTo 1 Do Begin
                If (Trim(thLine[I].tlStockCode) <> '') Then Begin
                  { Have found parent stock code - check its not a kit item }
                  If (thLine[I].tlBomKitLink = 0) Then Begin
                    { non kit item }
                    Result := True;
                  End { If }
                  Else Begin
                    { Additional description line on kit item - exclude depending on flag }
                    Result := (Not chkExclBOM.Checked);
                  End; { Else }

                  Break;
                End; { If }
              End; { For }
            End; { If }
          End; { If }
        End; { Else }
      End; { If }
    End; { With TheLine }
  End; { WantTL }

  { Returns number of units in the Trans Line }
  Function TLUnits (TheLine : TAbsInvLine) : Double;
  Var
    WantIt  : Boolean;
  Begin { TLUnits }
    Result := 0.00;

    With EvData, Setup, TheLine Do Begin
      { Calculate line units }
      If radWeight.Checked Then Begin
        { Line Weight = Unit Weight * Line Quantity }
        // HM 12/09/00: Changed for JW for pack qty support
        Result := entRound(tlQty * CalcQtyMul(TheLine) * tlUnitWeight, 2);
      End { If }
      Else Begin
        If radValue.Checked Then Begin
          { Return the line total in currency }
          Result := entInvLTotal(True, 0.0);
        End { If }
        Else Begin
          { Must be quantity - nothing else left }
          // HM 12/09/00: Changed for JW for pack qty support
          Result := entRound(tlQty * CalcQtyMul(TheLine), ssNoQtyDec);
        End; { Else }
      End; { Else }
    End; { With TheLine }
  End; { TLUnits }

Begin
  Result := True;

  With EvData, Setup, Transaction, thLines Do Begin
    { Calc Total units in transaction }
    TotUnits := 0.0;
    NoWantLines := 0;
    If (thLineCount > 0) Then Begin
      For I := 1 To thLineCount Do Begin
        If WantTL(I) Then Begin
          { Calculate the units of the line }
          LineUnits := TLUnits(thLine[I]);
          If (LineUnits > 0.0) Then Begin
            TotUnits := TotUnits + LineUnits;
            Inc (NoWantLines);
          End; { If }
        End; { If }
      End; { For I }
    End; { If }

    { Check there is something to split against }
    Result := (TotUnits > 0.0) And (NoWantLines > 0);

    If Result Then Begin
      TransFr := FrAmount;

      { Calc Freight Charge per unit }
      UnitFr := entRound(TransFr / TotUnits, 10);

      { Allocate Freight Charges to the lines }
      If (thLineCount > 0) Then Begin
        For I := 1 To thLineCount Do Begin
          { Check we want the line }
          If WantTL(I) Then Begin
            { Calculate the units of the line }
            LineUnits := TLUnits(thLine[I]);
            If (LineUnits > 0.0) Then Begin
              { Calculate Line Freight }
              If (NoWantLines = 1) Then Begin
                { Last Line - take remaining freight }
                LineFreight := TransFr;
              End { If }
              Else Begin
                { Calculate freight due to the line }
                LineFreight := entRound(LineUnits * UnitFr, Setup.ssNoCOSDec);
              End; { Else }

              { Reduce to per unit amount }
              // HM 12/09/00: Changed for JW for pack qty support
              LineQty := entRound(thLine[I].tlQty * CalcQtyMul(thLine[I]), Setup.ssNoQtyDec);
              LineFreight := entRound(LineFreight / LineQty, Setup.ssNoCOSDec);

              { Reduce Remaining Freight Amount }
              TransFr := TransFr - entRound(LineFreight * LineQty, Setup.ssNoCOSDec);

              { Apply the Freight Amount }
              Try
                If LoadTKDll Then Begin
                  { Update Uplift for line }
                  If (Trim(thLine[I].tlStockCode) = '') Then Begin
                    { Update line directly as no FIFO/Serial Numbers behind it }
                    thLine[I].tlCost := LineFreight;
                    thLine[I].Save;
                  End { If }
                  Else Begin
                    { Use DLL to Update Uplift with FIFO/Serial Numbers/etc... }
                    pOurRef := StrAlloc(100);
                    pStock  := StrAlloc(100);
                    StrPCopy (pOurRef, thOurRef);
                    StrPCopy (pStock, thLine[I].tlStockCode);
                    B_Stat := EX_UPDATEUPLIFT2 (False, pOurRef, thLine[I].tlLineNo, pStock, LineFreight);
                    StrDispose(pOurRef);
                    StrDispose(pStock);

                    If (B_Stat <> 0) Then begin
                      TStr:=Ex_ErrorDescription(1, B_Stat);
                      ShowMessage ('EX_UPDATEUPLIFT Status : '+IntToStr(B_Stat)+
                                   #13#10+#13#10+TStr);
                    End { If }
                  End; { Else }
                End; { Else }
              Except
                On Ex:Exception Do Begin
                  MessageDlg ('The following error occurred applying Uplift to line ' + IntToStr(I) + ':' + #13#13 +
                              Ex.Message, mtError, [mbOk], 0);
                  Break;
                End; { On }
              End;

              Dec (NoWantLines);
            End; { If }

            If (NoWantLines = 0) Then Break;
          End; { If }
        End; { For I }
      End; { If }
    End { If }
    Else Begin
      MessageDlg ('No lines or units were found to allow the Freight to be split', mtInformation, [mbOk], 0);
    End; { Else }
  End; { With }
End; {Proc..}


procedure TfrmUplift.edtAmountKeyPress(Sender: TObject; var Key: Char);
begin
  If Not (Key In [#8, '0'..'9', '.']) Then Begin
    Key := #0;
  End; { If }
end;


function TfrmUplift.LoadTKDLL : Boolean;
Var
  OpenStat : SmallInt;
  PCPath   : PChar;
  TStr     : ShortString;
Begin { LoadTKDll }
  Result := DLLOpen;

  If (Not Result) Then Begin
    { DLL Not Loaded - Load It }
    Try
      PCPath := StrAlloc (255);
      Try
        { Setup the path to the data }
        StrPCopy(PCPath, EvData.SetUp.ssDataPath);
        OpenStat := EX_INITDLLPATH(PCPath,True);

        // Backdoor the Toolkit DLl to avoid release code requirement
        ToolkitOK;

        { open the data files }
        OpenStat := Ex_InitDLL;

        DLLOpen := (OpenStat = 0);
        Result := DLLOpen;

        If (OpenStat <> 0) Then begin
          { An error has occured }
          TStr:=Ex_ErrorDescription(1, OpenStat);
          ShowMessage ('Ex_InitDLL Status : '+IntToStr(OpenStat)+ #13#13+TStr);
        End; { If }
      Finally
        {* dispose allocated buffer of PC *}
        StrDispose(PCPath);
      End;
    Except
      On Ex:Exception Do
        ShowMessage ('The following error occurred whilst calling Ex_InitDLL:' + #13#13 + Ex.Message);
    End;
  End; { If (Not Result) }
End; { LoadTKDll }


Initialization
  DLLOpen := False;
Finalization
  { Unload Toolkit DLL if loaded }
  If DLLOpen then
    Ex_CLoseDLL;
end.
