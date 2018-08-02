unit OLEProgr;

{ markd6 12:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, bkgroup;

type
  TfrmOLEProgress = class(TForm)
    btnAbort: TButton;
    lblProg: TLabel;
    lstInfo: TListBox;
    SBSBackGroup1: TSBSBackGroup;
    SBSBackGroup2: TSBSBackGroup;
    procedure FormCreate(Sender: TObject);
    procedure btnAbortClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Aborted : Boolean;
  end;

implementation

{$R *.DFM}

procedure TfrmOLEProgress.FormCreate(Sender: TObject);
begin
  Aborted := False;
end;

procedure TfrmOLEProgress.btnAbortClick(Sender: TObject);
begin
  Aborted := True;
end;

end.
