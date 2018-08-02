unit InpPWU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal,
  GlobVar,VarConst, ExtCtrls, SBSPanel;

type
  TInputPW = class(TForm)
    OkCP1Btn: TButton;
    ClsCP1Btn: TButton;
    ADL1F: Text8Pt;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure ADL1FEnter(Sender: TObject);
    procedure ADL1FExit(Sender: TObject);
  private
    { Private declarations }

    PrevHState
             :  Boolean;
    CompPW   :  Str10;

  public
    { Public declarations }

    RecepMode  :  Boolean;

    Function ConfirmPW(OPW  :  Str10)  :  Boolean;


  end;

  Function VerifyPassword(OPW     :  Str10;
                          AOwner  :  TWinControl)  :  Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  BTKeys1U,
  BTSupU1,
  BTSupU2,
  CryptO;

{$R *.DFM}



procedure TInputPW.FormCreate(Sender: TObject);
begin
  RecepMode:=BOff;
  ClientHeight:=64;
  ClientWidth:=188;
end;

{ ==== Procedure to Display Address ==== }

procedure TInputPW.ADL1FEnter(Sender: TObject);
begin
  ADL1F.Text:=Trim(ADL1F.Text);
end;

procedure TInputPW.ADL1FExit(Sender: TObject);

Var
  ECInp  :  String;

begin
  If (ActiveControl<>ClsCP1Btn) then
  Begin
    EcInp:=Encode(Trim(ADL1F.Text));

    If (EcInp<>CompPW) then
    Begin
      ADL1F.Text:='';
      ADL1F.SetFocus;
    end;

  end;
end;

Function TInputPW.ConfirmPW(OPW  :  Str10)  :  Boolean;
Begin
  CompPW:=OPW;

  ChangeCryptoKey (23130);

  SetAllowHotKey(BOff,PrevHState);

  ShowModal;

  SetAllowHotKey(BOn,PrevHState);

  Result:=(Encode(Trim(ADL1F.Text))=CompPW);

end;

procedure TInputPW.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TInputPW.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

Function VerifyPassword(OPW     :  Str10;
                        AOwner  :  TWinControl)  :  Boolean;

Begin
  Result:=BOff;

  With TInputPW.Create(AOWner) do
  Try
    Result:=ConfirmPW(OPW);
  finally
    Free;
  end;

end;


end.
