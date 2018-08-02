unit regprog;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, ExtCtrls, StdCtrls, ComCtrls;

type
  TRegisterProgress = class(TSetupTemplate)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ProgressBar1: TProgressBar;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Function  GetDescr : String;
    Procedure SetDescr (Value : String);

    Function  GetProgMax : Integer;
    Procedure SetProgMax (Value : Integer);

    Function  GetProgMin : Integer;
    Procedure SetProgMin (Value : Integer);

    Function  GetProgPos : Integer;
    Procedure SetProgPos (Value : Integer);

    Function  GetProgInfo : Boolean;
    Procedure SetProgInfo (Value : Boolean);

    Function  GetTitle : String;
    Procedure SetTitle (Value : String);
  public
    { Public declarations }
    Property Descr : String Read GetDescr Write SetDescr;
    Property ProgMax : Integer Read GetProgMax Write SetProgMax;
    Property ProgMin : Integer Read GetProgMin Write SetProgMin;
    Property ProgPos : Integer Read GetProgPos Write SetProgPos;
    Property ShowProgInfo : Boolean Read GetProgInfo Write SetProgInfo;
    Property Title : String Read GetTitle Write SetTitle;
  end;


implementation

{$R *.DFM}

procedure TRegisterProgress.FormCreate(Sender: TObject);
begin
  inherited;

  SetProgInfo (False);
end;

Function  TRegisterProgress.GetDescr : String;
Begin
  Result := InstrLbl.Caption;
End;

Procedure TRegisterProgress.SetDescr (Value : String);
Begin
  InstrLbl.Caption := Value;
End;

Function  TRegisterProgress.GetProgInfo : Boolean;
Begin
  Result := ProgressBar1.Visible;
End;

Procedure TRegisterProgress.SetProgInfo (Value : Boolean);
Begin
  Label1.Visible := Value;
  Label2.Visible := Value;
  Label3.Visible := Value;
  Label4.Visible := Value;
  ProgressBar1.Visible := Value;
End;

Function  TRegisterProgress.GetTitle : String;
Begin
  Result := TitleLbl.Caption;
End;

Procedure TRegisterProgress.SetTitle (Value : String);
Begin
  TitleLbl.Caption := Value;
End;

Function  TRegisterProgress.GetProgMax : Integer;
Begin
  Result := ProgressBar1.Max;
End;

Procedure TRegisterProgress.SetProgMax (Value : Integer);
Begin
  ProgressBar1.Max := Value;
End;

Function  TRegisterProgress.GetProgMin : Integer;
Begin
  Result := ProgressBar1.Min;
End;

Procedure TRegisterProgress.SetProgMin (Value : Integer);
Begin
  ProgressBar1.Min := Value;
End;

Function  TRegisterProgress.GetProgPos : Integer;
Begin
  Result := ProgressBar1.Position;
End;

Procedure TRegisterProgress.SetProgPos (Value : Integer);
Begin
  ProgressBar1.Position := Value;
End;


end.
