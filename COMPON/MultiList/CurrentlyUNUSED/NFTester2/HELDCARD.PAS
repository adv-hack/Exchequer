unit HeldCard;

{ nfrewer440 09:07 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, VarConst;

type
  TFrmHeldCardsList = class(TForm)
    chkExpired: TCheckBox;
    Label1: TLabel;
    Bevel1: TBevel;
    chkSuspended: TCheckBox;
    chkOverLimit: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    Bevel2: TBevel;
    chkOnHold: TCheckBox;
    chkAllowedCredit: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure chkExpiredClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{var
  FrmHeldCardsList: TFrmHeldCardsList;}

implementation

uses Reports;

{$R *.DFM}

procedure TFrmHeldCardsList.btnOKClick(Sender: TObject);
var
  Hold : THeldCards;
begin
  FillChar(Hold,sizeof(Hold),#0);
  with Hold do begin
    OnlyShowHolds := TRUE;
    Status[hsExpired] := chkExpired.Checked;
    Status[hsSuspended] := chkSuspended.Checked;
    Status[hsOverLimit] := chkOverLimit.Checked;
    if Status[hsOverLimit] then begin
      Status[hsOnHold] := chkOnHold.Checked;
      Status[hsAllowedCredit] := chkAllowedCredit.Checked;
    end;{if}
  end;{with}
  ModReports.PrintCardsOnHold(Hold, FALSE);
end;

procedure TFrmHeldCardsList.chkExpiredClick(Sender: TObject);
begin
  btnOK.Enabled := chKExpired.Checked or chkOverlimit.Checked or chkSuspended.Checked;
  chkOnHold.Enabled := chkOverlimit.Checked;
  chkAllowedCredit.Enabled := chkOverlimit.Checked;
end;

end.
