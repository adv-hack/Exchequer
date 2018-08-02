unit SecMethd;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, ExtCtrls, StdCtrls, Mask, TEditVal, TCustom;

type
  TfrmSecMethod = class(TSetupTemplate)
    SBSButton1: TSBSButton;
    SBSButton2: TSBSButton;
    SBSButton3: TSBSButton;
    Label1: TLabel;
    procedure SBSButton1Click(Sender: TObject);
    procedure SBSButton2Click(Sender: TObject);
    procedure SBSButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}


procedure TfrmSecMethod.SBSButton1Click(Sender: TObject);
begin
  inherited;

  ExitCode := '1';
  Close;
end;

procedure TfrmSecMethod.SBSButton2Click(Sender: TObject);
begin
  inherited;

  ExitCode := '2';
  Close;
end;

procedure TfrmSecMethod.SBSButton3Click(Sender: TObject);
begin
  inherited;

  ExitCode := '3';
  Close;
end;

end.
