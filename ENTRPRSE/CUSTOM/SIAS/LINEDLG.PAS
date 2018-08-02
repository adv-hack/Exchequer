unit LineDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, CustAbsU, ExtCtrls, Mask;

type
  TfrmSIASLine = class(TForm)
    lblQty: TLabel;
    lblUPrice: TLabel;
    lblTotal: TLabel;
    ccyWeight: TCurrencyEdit;
    btnOK: TButton;
    edtRawMat: Text8Pt;
    edtBatchRef: Text8Pt;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    WinName : ShortString;
  public
    { Public declarations }
    IsNom   : Boolean;
  end;

implementation

{$R *.DFM}

Uses ChainU;


procedure TfrmSIASLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TfrmSIASLine.btnOKClick(Sender: TObject);
begin
  If IsNom Then Begin
    { Check weight >= 0 }
    If (ccyWeight.Value >= 0.0) Then Begin
      { string fields can be left blank for NOM's }
      Close;
    End { If }
    Else Begin
      { Weight must be >= 0.0 }
      MessageDlg ('The Weight must be >= 0', mtWarning, [mbOk], 0);
      If ccyWeight.CanFocus Then ccyWeight.SetFocus;
    End; { Else }
  End { If }
  Else Begin
    { for non-NOM transactions Raw Material and Batch Ref must be set }
    If (Trim(edtRawMat.Text) <> '') Then Begin
      If (Trim(edtBatchRef.Text) <> '') Then Begin
        { Check weight >= 0 }
        If (ccyWeight.Value >= 0.0) Then Begin
          Close;
        End { If }
        Else Begin
          { Weight must be >= 0.0 }
          MessageDlg ('The Weight must be >= 0', mtWarning, [mbOk], 0);
          If ccyWeight.CanFocus Then ccyWeight.SetFocus;
        End; { Else }
      End { If }
      Else Begin
        { Batch Reference is blank }
        MessageDlg ('The Batch Reference must be specified', mtWarning, [mbOk], 0);
        If edtBatchRef.CanFocus Then edtBatchRef.SetFocus;
      End; { Else }
    End { If }
    Else Begin
      { Raw Material is blank }
      MessageDlg ('The Raw Material Code must be specified', mtWarning, [mbOk], 0);
      If edtRawMat.CanFocus Then edtRawMat.SetFocus;
    End; { Else }
  End; { Else }
end;

end.
