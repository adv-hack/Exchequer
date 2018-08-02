unit Existng;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, ExtCtrls, BorBtns;

type
  TfrmIncomplete = class(TForm)
    Panel1: TPanel;
    SBSButton1: TSBSButton;
    lblDate: TLabel;
    Label2: TLabel;
    rbFinish: TBorRadio;
    rbStart: TBorRadio;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetDateLabel(const DateString : string; UserID : string = '');
  end;

var
  frmIncomplete: TfrmIncomplete;

implementation

{$R *.dfm}
uses
  SbsComp2;

procedure TfrmIncomplete.FormCreate(Sender: TObject);
begin
  rbFinish.Checked := True;
  LastValueObj.GetAllLastValuesFull(Self);
end;

procedure TfrmIncomplete.SetDateLabel(const DateString: string; UserID : string = '');
begin
  if UserID = '' then
    UserID := 'You';
  lblDate.Caption
    := Format('%s stored an incomplete reconciliation for this bank account on %s.', [UserID, DateString]);
end;

procedure TfrmIncomplete.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  LastValueObj.UpdateAllLastValuesFull(Self);
end;

end.
