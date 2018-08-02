unit EMailData;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmEMailData = class(TForm)
    pnlMain: TPanel;
    pnlSend: TPanel;
    lblTo: TLabel;
    lblCC: TLabel;
    lblBCC: TLabel;
    edTo: TEdit;
    edCC: TEdit;
    edBCC: TEdit;
    pnlConnect: TPanel;
    lblHost: TLabel;
    lblUserID: TLabel;
    lblPassword: TLabel;
    edUserID: TEdit;
    edHost: TEdit;
    edPassword: TEdit;
    pnlSubject: TPanel;
    lblSubject: TLabel;
    edSubject: TEdit;
    btnSend: TButton;
    lblFrom: TLabel;
    edFrom: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    memoBody: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEMailData: TfrmEMailData;

implementation

{$R *.DFM}

end.
