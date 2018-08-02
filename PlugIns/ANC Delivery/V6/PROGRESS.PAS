unit Progress;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, TCustom;

type
  TfrmProgress = class(TForm)
    SBSGroup1: TSBSGroup;
    lblExpAction: Label8;
    lblExpStatus: Label8;
    SBSGroup2: TSBSGroup;
    lblDelAction: Label8;
    lblDelStatus: Label8;
    btnClose: TSBSButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Aborted : Boolean;
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.DFM}

Uses ANCDlg;

procedure TfrmProgress.FormCreate(Sender: TObject);
Var
  F : TForm;
begin
  Aborted := False;

  Try
    { Centre over Owner }
    F := TForm(Owner);
    Top := F.Top + (F.Height div 2) - (Height Div 2);
    Left := F.Left + (F.Width div 2) - (Width Div 2);
  Except
    On Exception Do
      ;
  End; { Try }
end;

procedure TfrmProgress.FormActivate(Sender: TObject);
begin
  Timer1.Enabled := True;
end;

procedure TfrmProgress.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmProgress.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;

  With Owner As TfrmANCExport Do Begin
    { Export to DeliverANCe 2000 }
    Aborted := Not ExportToANC;

    If Not Aborted Then Begin
      { Tidy up DeliverANCe 2000 directory }
      TidyUpANC;

      btnClose.Enabled := True;
    End { If }
    Else
      { Export stage failed return to main dialog }
      Self.Close;
  End; { With }
end;

end.
