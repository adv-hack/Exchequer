unit TransCancelF;

// PKR. 18/02/2015. ABSEXCH-16077.
// This form added to advise the user what to do in the event of cancelling a transaction
//  that has got stuck.  This could be due to the payment provider site failing to
//  return to the Portal, comms failure etc.

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TTransCancelForm = class(TForm)
    btnOK: TButton;
    richMsg: TRichEdit;
    btnCancel: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    procedure AddBoldLine(lineText : string);
  public
    { Public declarations }
  end;

var
  TransCancelForm: TTransCancelForm;

implementation

{$R *.dfm}

procedure TTransCancelForm.btnOKClick(Sender: TObject);
begin
  modalResult := mrOK;
end;

//------------------------------------------------------------------------------
procedure TTransCancelForm.AddBoldLine(lineText : string);
var
  lineIndex : integer;
begin
  lineIndex := richMsg.Lines.Add(lineText);
  richMsg.SelStart := richMsg.Perform(EM_LINEINDEX, LineIndex, 0);
  richMsg.SelLength := richMsg.Perform(EM_LINELENGTH, richMsg.SelStart, 0);
  richMsg.SelAttributes.Style := [fsBold];
  richMsg.SelLength := 0;
  richMsg.SelStart := Length(richMsg.Text);
end;

//------------------------------------------------------------------------------
procedure TTransCancelForm.FormShow(Sender: TObject);
begin
  richMsg.Lines.Clear;
  with richMsg do
  begin
    Paragraph.Alignment := taCenter;
    AddBoldLine('IMPORTANT INFORMATION');

    Lines.Add('');
    Paragraph.Alignment := taLeftJustify;
    Lines.Add('If you choose to cancel the transaction, it will be cancelled in ' +
              'Exchequer and in the Exchequer Payments Portal.');
    Lines.Add('However, the status of the transaction with your payment provider is ' +
              'unknown and it is not possible to synchronise the transaction with ' +
              'your payment provider.');
    Lines.Add('');

    AddBoldLine('If you choose to cancel the transaction:');

    Paragraph.Numbering := nsBullet;
    Lines.Add('Log in to your Payment Provider account');
    Lines.Add('');
    Paragraph.Numbering := nsBullet;
    AddBoldLine('If the transaction was a Payment:');

    Paragraph.Numbering := nsBullet;
    Paragraph.FirstIndent := 10;
    Lines.Add('If the payment was successful, issue a Refund from within your Payment Provider Account');
    Lines.Add('If the payment failed, you need do nothing');
    Lines.Add('Try to make the payment again from Exchequer');
    Paragraph.FirstIndent := 0;
    Paragraph.Numbering := nsNone;
    Lines.Add('');

    Paragraph.Numbering := nsBullet;
    AddBoldLine('If the transaction was a Refund:');

    Paragraph.Numbering := nsBullet;
    Paragraph.FirstIndent := 10;
    Lines.Add('If the Refund was successful, add a manual Refund in Exchequer');
    Lines.Add('If the Refund failed, try to make the Refund again from Exchequer');
    Paragraph.FirstIndent := 0;
    Paragraph.Numbering := nsNone;
    Paragraph.Alignment := taLeftJustify;
  end;
end;

procedure TTransCancelForm.btnCancelClick(Sender: TObject);
begin
  modalResult := mrCancel;
end;

end.
