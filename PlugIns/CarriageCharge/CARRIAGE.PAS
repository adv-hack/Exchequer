unit Carriage;

interface

uses
  FileUtil, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms
  , ChainU, Dialogs, StdCtrls, TCustom, CustAbsU, TEditVal, ExtCtrls;

type
  TfrmCarriage = class(TForm)
    btnOK: TButton;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    lstCarriers: TComboBox;
    ccyWeight: TCurrencyEdit;
    ccyCharge: TCurrencyEdit;
    btnCancel: TButton;
    Bevel1: TBevel;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstCarriersClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure ccyWeightExit(Sender: TObject);
    procedure ccyChargeExit(Sender: TObject);
  private
    { Private declarations }
    ChargeChanged : Boolean;
  public
    { Public declarations }
    OK        : Boolean;
    LineDesc  : ShortString;
    EventData : TAbsEnterpriseSystem;
  end;



Procedure DisplayCarriageDlg(EventData : TAbsEnterpriseSystem);

implementation

{$R *.DFM}

Uses IniU;

Procedure DisplayCarriageDlg(EventData : TAbsEnterpriseSystem);
Var
  frmCarriage : TfrmCarriage;
  Cont        : Boolean;
  I, J        : SmallInt;
  MsgStr      : String[20];
  bAtLeastOnePickedLine, WantDlg     : Boolean;
  TotalWeight : Double;
Begin { DisplayCarriageDlg }
  With EventData Do
  begin

    WantDlg := False;

    {Check for SORs}
    If (Transaction.thInvDocHed = cuSOR) Then
    begin

      if not Assigned(IniLine) then Cont := LoadINI
      else Cont := True;

      if not Cont then
      begin
        ShowMessage('Error : INI File (' + GetEnterpriseDirectory + DLLChain.ModuleName + '.INI'
        + ') could not be found.');
      end else
      begin
        { Accumulate weight of picked lines }
        //WantDlg := False;
        TotalWeight := 0.00;
        bAtLeastOnePickedLine := FALSE;
        With Transaction, thLines Do Begin
          For I := 1 To thLineCount Do Begin
            { Add up total weight of lines }
            If (thLine[I].tlLineType <> 4) Then Begin
              With thLine[I] Do Begin

                if tlQtyPicked > 0 then bAtLeastOnePickedLine := TRUE; {.209}

                { Check something picked OR trigger on all Orders}
                If (tlQtyPicked > 0)
                or (IniLine^.ilTriggerOnAllOrders) then {.208}
                begin
                  { Link to stock item }
                  If LinkToStock Then
                  begin
                    {.211}
//                    TotalWeight := TotalWeight + (Stock.stSaleUnWeight * tlQtyPicked * tlQtyMul);
                    if (IniLine^.ilTriggerOnAllOrders) then
                    begin
                      TotalWeight := TotalWeight + (Stock.stSaleUnWeight * tlQty * tlQtyMul);
                    end
                    else
                    begin
                      TotalWeight := TotalWeight + (Stock.stSaleUnWeight * tlQtyPicked * tlQtyMul);
                    end;{if}
                  End; { If }

                  WantDlg := True;
                End; { If }
              End; { With }
            End; { If }
          End; { For }
        End; { With }
      end;{if}
    End;  { If }

    {Check for SQUs}
    If (Transaction.thInvDocHed = cuSQU) Then
    begin

      if not Assigned(IniLine) then Cont := LoadINI
      else Cont := True;

      if not Cont then
      begin
        ShowMessage('Error : INI File (' + GetEnterpriseDirectory + DLLChain.ModuleName + '.INI'
        + ') could not be found.');
      end else
      begin

        if IniLine^.ilTriggerOnAllQuotes then
        begin
          { Accumulate weight of picked lines }
          WantDlg := TRUE;
          bAtLeastOnePickedLine := FALSE;
          TotalWeight := 0.00;
          With Transaction, thLines Do Begin
            For I := 1 To thLineCount Do Begin
              { Add up total weight of lines }
              If (thLine[I].tlLineType <> 4) Then Begin
                With thLine[I] Do Begin

                  { Link to stock item }
                  If LinkToStock Then
                  begin
                    TotalWeight := TotalWeight + (Stock.stSaleUnWeight * tlQty * tlQtyMul);
                  End; { If }
                End; { With }
              End; { If }
            End; { For }
          End; { With }
        end;{if}
      end;{if}
    End;  { If }

    If WantDlg Then
    Begin
      frmCarriage := TfrmCarriage.Create(Application.MainForm);
      Try
        frmCarriage.EventData := EventData;

        With frmCarriage Do Begin
          { Select first carrier in list }
          If (lstCarriers.Items.Count > 0) Then
            lstCarriers.ItemIndex := 0;

          { Set weight and recalc charge }
          ccyWeight.Value := TotalWeight;
          lstCarriersClick(frmCarriage);

          ShowModal;

          If OK Then Begin
            With Transaction, thLines Do Begin
              { Delete any undelivered delivery lines }
              I := 1;
              While (I <= thLineCount) Do Begin
                If (thLine[I].tlLineType = 4) Then Begin
                  { Delivery Line - Try to delete }
                  J := thLineCount;

                  thLine[I].Delete;

                  If (J = thLineCount) Then Begin
                    { Delete Failed - move to next line }
                    Inc (I);
                  End; { If }
                End { If }
                Else
                  Inc (I);
              End; { While }

              { Create new detail line }
              thLines.AddNewLine;

              With thLines.thCurrentLine Do Begin
                tlLineType  := 4;
                tlCurrency  := thCurrency;
                tlQty       := 1;
                tlQtyMul    := 1;

                {.209}
                //tlQtyPicked := 1;
                if bAtLeastOnePickedLine then tlQtyPicked := 1
                else tlQtyPicked := 0;

                tlDescr := FormatDateTime('DD/MM/YYYY',Now) + ' ' + frmCarriage.LineDesc;

                Try
                  MsgStr := 'Invalid GL Code';
                  tlGLCode     := IniLine^.ilGLCode;

                  MsgStr := 'Invalid Cost Centre';
                  tlCostCentre := IniLine^.ilCostC;

                  MsgStr := 'Invalid Department';
                  tlDepartment := IniLine^.ilDept;

                  MsgStr := 'Invalid Location';
                  tlLocation   := IniLine^.ilLocation;

                  MsgStr := 'Invalid VAT Code';
                  tlVATCode    := IniLine^.ilVATCode;

                  MsgStr := 'Invalid Net Value';
                  tlNetValue   := ccyCharge.Value;

                  MsgStr := 'Cannot Save Transaction Line';
                  Save;
                Except
                  On Exception Do
                    MessageDlg ('The following error occurred adding the Carriage Charges: ' +
                                #13#13 + '"' + MsgStr + '".', mtError, [mbOk], 0);
                End;
              End; { With }
            End; { With }
          End; { If }
        End; { With }
      Finally
        frmCarriage.Free;
      End;
    End; { If }

  end;{with}
End;  { DisplayCarriageDlg }


{ --------------------------------------------------------------------------- }


procedure TfrmCarriage.FormCreate(Sender: TObject);
Var
  I : LongInt;
begin
  OK := False;
  ChargeChanged := False;
  LineDesc := '';

  { Load Carriers list }
  For I := Low(Carriers) To High(Carriers) Do Begin
    If Carriers[I].caSet Then Begin
      lstCarriers.Items.AddObject (Carriers[I].caName, Pointer(I));
    End; { If }
  End; { For }
end;


procedure TfrmCarriage.lstCarriersClick(Sender: TObject);
Var
  TotWeight : Double;
  CarrierNo : LongInt;
begin
  { Get Carrier Number }
  CarrierNo := LONGINT(lstCarriers.Items.Objects[lstCarriers.ItemIndex]);

  { Round weight to 3dp to avoid rounding problems }
  TotWeight := EventData.entRound(ccyWeight.Value, 3);
  ccyWeight.Value := TotWeight;

  { Calculate cost }
  ccyCharge.Value := EventData.entRound(Carriers[CarrierNo].CalcCharge (EventData, TotWeight),2);
  LineDesc := Carriers[CarrierNo].caLineDesc;
end;


procedure TfrmCarriage.btnCancelClick(Sender: TObject);
begin
  OK := False;
  Close;
end;


procedure TfrmCarriage.btnOKClick(Sender: TObject);
begin
  OK := True;
  Close;
end;

procedure TfrmCarriage.ccyWeightExit(Sender: TObject);
begin
  If ccyWeight.FloatModified And (Not ChargeChanged) Then
    lstCarriersClick(Sender);
end;

procedure TfrmCarriage.ccyChargeExit(Sender: TObject);
begin
  ChargeChanged := ccyCharge.FloatModified;
end;

end.
