unit PaperWS2;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, BorBtns, TEditVal;

type
  TfrmPaperWSAdv = class(TForm)
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    Label84: Label8;
    Label85: Label8;
    chkEntWorkS: TBorCheck;
    chkEntSender: TBorCheck;
    chkStWorkS: TBorCheck;
    chkEntAdmin: TBorCheck;
    chkStSender: TBorCheck;
    chkStAdmin: TBorCheck;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    OK : Boolean;
  end;

implementation

{$R *.DFM}

Uses Version;

procedure TfrmPaperWSAdv.FormCreate(Sender: TObject);
begin
  OK := False;

  (* HM 25/05/00: Restored Win2000 support of Fax Driver
  If IsWin2000 Then Begin
    chkEntWorkS.Enabled := False;
    chkStWorkS.Enabled := False;
  End; { If }
  *)
end;

procedure TfrmPaperWSAdv.btnOKClick(Sender: TObject);
begin
  OK := True;
  Close;
end;

procedure TfrmPaperWSAdv.btnCancelClick(Sender: TObject);
begin
  OK := False;
  Close;
end;

end.
