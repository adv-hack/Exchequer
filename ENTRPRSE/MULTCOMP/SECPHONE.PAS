unit SecPhone;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, ExtCtrls, StdCtrls, Mask, TEditVal, TCustom;

type
  TfrmSecPhone = class(TSetupTemplate)
    Label3: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    edtRelCode: Text8Pt;
    edtISN: Text8Pt;
    edtSecCode: Text8Pt;
    Label1: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    procedure SBSButton1Click(Sender: TObject);
    procedure SBSButton2Click(Sender: TObject);
    procedure SBSButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}


Uses GlobVar, VarConst, EtDateU, licGlob, SerialU;

procedure TfrmSecPhone.FormCreate(Sender: TObject);
Var
  I : Byte;
begin
  inherited;

  edtISN.Text := '';
  For I := 1 To 6 Do Begin
    edtISN.Text := edtISN.Text + IntToStr3 (Syss.ExISN[I]);

    If (I < 6) Then
      edtISN.Text := edtISN.Text + '-';
  End; { For I }

  edtSecCode.Text := Syss.ExSecurity;
  edtRelCode.Text := '';
end;

procedure TfrmSecPhone.SBSButton1Click(Sender: TObject);
begin
  inherited;

  ExitCode := '1';
  Close;
end;

procedure TfrmSecPhone.SBSButton2Click(Sender: TObject);
begin
  inherited;

  ExitCode := '2';
  Close;
end;

procedure TfrmSecPhone.SBSButton3Click(Sender: TObject);
begin
  inherited;

  ExitCode := '3';
  Close;
end;

end.
