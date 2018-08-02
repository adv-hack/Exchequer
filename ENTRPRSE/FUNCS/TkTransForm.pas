unit TkTransForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uMultiList, StdCtrls, ExtCtrls, Enterprise01_TLB;

type
  TfrmTKTrans = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    memCustDets: TMemo;
    edtAcCode: TEdit;
    edtTransDate: TEdit;
    edtDueDate: TEdit;
    edtPerYear: TEdit;
    edtYourRef: TEdit;
    edtAltRef: TEdit;
    edtOurRef: TEdit;
    edtOperator: TEdit;
    Panel2: TPanel;
    btnClose: TButton;
    edtTotal: TEdit;
    edtVATContent: TEdit;
    edtNetTotal: TEdit;
    mlLines: TMultiList;
    Edit1: TEdit;
    Label12: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetTransaction(const oToolkit : IToolkit;
                             const oTrans   : ITransaction);
  end;


implementation

{$R *.dfm}

{ TfrmTKTrans }

procedure TfrmTKTrans.SetTransaction(const oToolkit : IToolkit;
                                     const oTrans   : ITransaction);
Var
  TmpAccI : IAccount;
  I       : SmallInt;
  sTmp    : string;
begin

  With oToolkit, Functions, oTrans Do Begin
    TmpAccI := thAcCodeI;
    If Assigned (TmpAccI) Then
      With TmpAccI Do Begin
        memCustDets.Lines.Add (Trim(acCompany));
        memCustDets.Lines.Add (Trim(acAddress[1]));
        memCustDets.Lines.Add (Trim(acAddress[2]));
        memCustDets.Lines.Add (Trim(acAddress[3]));
        memCustDets.Lines.Add (Trim(acAddress[4]));
        memCustDets.Lines.Add (Trim(acAddress[5]));
      End; { With TmpAccI }

    edtAcCode.Text := thAcCode;
    edtTransDate.Text := entFormatDate(thTransDate, 'S');
    edtDueDate.Text := entFormatDate(thDueDate, 'S');

    edtPerYear.Text := entFormatPeriodYear(thPeriod, thYear);
    edtYourRef.Text := thYourRef;
    edtAltRef.Text := thLongYourRef;

    edtOurRef.Text := thOurRef;
    edtOperator.Text := thOperator;

    With thLines Do Begin
      // Remove any pre-existing lines

      If (thLineCount > 0) Then
        For I := 1 To thLineCount Do
          With thLines[I] Do Begin
            // Stock Code
            mlLines.DesignColumns[0].Items.Add(Trim(tlStockCode));

            // Quantity - to SystemSetup.ssQtyDecimals decimal places
            If (tlQty <> 0.0) Then
              mlLines.DesignColumns[1].Items.Add(Format('%0.' + IntToStr(SystemSetup.ssQtyDecimals) + 'f', [tlQty]))
            Else
              mlLines.DesignColumns[1].Items.Add('');

            // Line Description
            mlLines.DesignColumns[2].Items.Add (tlDescr);

            // Line Total - no Qty = no value
            If (tlQty <> 0.0) Then
              mlLines.DesignColumns[3].Items.Add(Format('%0.2n', [entLineTotal(True, 0)]))
            Else
              mlLines.DesignColumns[3].Items.Add('');

            If (tlQty <> 0.0) Then
              mlLines.DesignColumns[4].Items.Add(tlVatCode)
            Else
              mlLines.DesignColumns[4].Items.Add('');

            // Line Total - no Qty = no value
            If (tlQty <> 0.0) Then
              mlLines.DesignColumns[5].Items.Add(Format('%0.2n', [tlNetValue]))
            Else
              mlLines.DesignColumns[5].Items.Add('');

            If (tlDiscount <> 0.0) Then
              mlLines.DesignColumns[6].Items.Add(Format('%0.2n%s', [tlDiscount * 100, tlDiscFlag]))
            Else
              mlLines.DesignColumns[6].Items.Add('');



          End; { With lvlines.Items.Add  }
    End; { With thLines }

    // Transaction Totals
    edtNetTotal.Text := Format('%0.2f', [thTotals[TransTotNetInCcy]]);
    edtVATContent.Text := Format('%0.2f', [thTotalVAT]);
    edtTotal.Text := Format('%0.2f', [thTotals[TransTotInCcy]]);
  End; { With TranDetail }
end;

end.
