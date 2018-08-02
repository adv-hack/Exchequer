{*********************************************************}
{*                   ADSTATE0.PAS 4.03                   *}
{*      Copyright (c) TurboPower Software 1996-2002      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit AdStatE0;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdStMach;

type
  TfrmConditionEdit = class(TForm)
    Button1: TButton;
    Button2: TButton;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    edtCaption: TEdit;
    cbxColor: TComboBox;
    edtWidth: TEdit;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Label9: TLabel;
    edtStartString: TEdit;
    edtEndString: TEdit;
    edtPacketSize: TEdit;
    edtTimeout: TEdit;
    cbxNextState: TComboBox;
    chkIgnoreCase: TCheckBox;
    edtErrorCode: TEdit;
    procedure cbxColorDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
  private
    FAvailStates: TStringList;
    { Private declarations }
    procedure ColorCallback(const S: string);
    procedure SetAvailStates(const Value: TStringList);
  public
    { Public declarations }
    procedure Clear;
    procedure SetNextState(S : string);
    procedure SetColor(C : string);
    property AvailStates : TStringList
      read FAvailStates write SetAvailStates;
  end;

var
  frmConditionEdit: TfrmConditionEdit;

implementation

{$R *.dfm}

{ TfrmConditionEdit }

procedure TfrmConditionEdit.cbxColorDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
  function GetBorderColor(Color: TColor): TColor;
  type
    TColorCast = record
      Red,
      Green,
      Blue,
      dummy: Byte;
    end;
  begin
    if (TColorCast(Color).Red > 170) or
       (TColorCast(Color).Green > 170) or
       (TColorCast(Color).Blue > 170) then
      Result := clBlack
    else if odSelected in State then
      Result := clWhite
    else
      Result := clWindow;
  end;
var
  R: TRect;
  BGColor: TColor;
  I : Integer;
begin
  { doing custom drawing to simulate a color selection combo box }
  with cbxColor.Canvas do
  begin
    FillRect(Rect);
    BGColor := Brush.Color;

    R := Rect;
    R.Right := R.Bottom - R.Top + R.Left;
    InflateRect(R, -1, -1);
    IdentToColor(cbxColor.Items[Index], I);
    Brush.Color := I;
    FillRect(R);
    Brush.Color := GetBorderColor(ColorToRGB(Brush.Color));
    FrameRect(R);
    Brush.Color := BGColor;
    Rect.Left := R.Right + 4;
    TextRect(Rect, Rect.Left,
      Rect.Top + (Rect.Bottom - Rect.Top - TextHeight(cbxColor.Items[Index])) div 2,
      cbxColor.Items[Index]);
  end;
end;


procedure TfrmConditionEdit.FormCreate(Sender: TObject);
begin
  { get list of available colors }
  GetColorValues(ColorCallback);
  FAvailStates := TStringList.Create;
end;

procedure TfrmConditionEdit.ColorCallback(const S: string);
begin
  cbxColor.Items.Add(S);
end;

procedure TfrmConditionEdit.SetAvailStates(const Value: TStringList);
begin
  cbxNextState.Items := Value;
end;

procedure TfrmConditionEdit.Clear;
begin
  { resets all controls to default values }
  edtStartString.Text := '';
  edtEndString.Text := '';
  chkIgnoreCase.Checked := True;
  edtPacketSize.Text := '0';
  edtTimeout.Text := '2048';
  edtErrorCode.Text := '0';
  cbxNextState.Text := '';
  cbxNextState.ItemIndex := -1;
  edtCaption.Text := 'Connectoid';
  cbxColor.ItemIndex := cbxColor.Items.IndexOf('clBlue'); 
  edtWidth.Text := '2';
end;

procedure TfrmConditionEdit.SetNextState(S: string);
begin
  cbxNextState.ItemIndex := cbxNextState.Items.IndexOf(S);
end;

procedure TfrmConditionEdit.SetColor(C: string);
begin
  cbxColor.ItemIndex := cbxColor.Items.IndexOf(C);
end;

end.
