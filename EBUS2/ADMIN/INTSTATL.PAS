unit IntStatL;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel, VarConst,
  GlobVar, bkgroup;

type
  TfrmIntraStatLine = class(TForm)
    btnOK: TButton;
    btnClose: TButton;
    edtCommodCode: Text8Pt;
    edtStockUnits: TCurrencyEdit;
    edtUnitWeight: TCurrencyEdit;
    edtCountryOfOrigin: Text8Pt;
    edtUpLift: TCurrencyEdit;
    SBSPanel1: TSBSBackGroup;
    Label81: Label8;
    Label83: Label8;
    Label84: Label8;
    lblUplift: Label8;
    Label848: Label8;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure edtCountryOfOriginExit(Sender: TObject);
  private
    HeaderRec : InvRec;
    fSettingsUpdated: boolean;
    fStockUnits: double;
    fUnitWeight: double;
    fUpLift: double;
    fCountryOfOrigin: string;
    fCommodityCode: string;
    procedure SetBoolean(const Value: boolean);
    procedure SetDouble(const Index: Integer; const Value: double);
    procedure SetString(const Index: Integer; const Value: string);
  public
    procedure SetFormProperties(SetFont : TFont; SetColour : TColor);
    property  SettingsUpdated : boolean read fSettingsUpdated write SetBoolean;
    property  CommodityCode : string index 1 read fCommodityCode write SetString;
    property  StockUnits : double index 1 read fStockUnits write SetDouble;
    property  UnitWeight : double index 2 read fUnitWeight write SetDouble;
    property  CountryOfOrigin : string index 2 read fCountryOfOrigin write SetString;
    property  Uplift : double index 3 read fUpLift write SetDouble;
    procedure EnableEditing;
  end;

implementation
uses
  BTSupU1,
  BTSupU2,
  MathUtil;

{$R *.DFM}

procedure TfrmIntraStatLine.SetFormProperties(SetFont : TFont; SetColour : TColor);
var
  i : integer;
begin
  for i := 0 to ComponentCount -1 do
  begin
    if Components[i] is Text8Pt then
      with (Components[i] as Text8Pt) do
      begin
        Font.Assign(SetFont);
        Color := SetColour;
      end;
    if Components[i] is TCurrencyEdit then
      with (Components[i] as TCurrencyEdit) do
      begin
        Font.Assign(SetFont);
        Color := SetColour;
      end;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatLine.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatLine.EnableEditing;
var
  i : integer;
begin
  edtCommodCode.ReadOnly := false;
  edtStockUnits.ReadOnly := false;
  edtUnitWeight.ReadOnly := false;
  edtCountryOfOrigin.ReadOnly := false;
  edtUpLift.ReadOnly := false;
  // Modal result on OK button should be mrCancel in the Object Inspector
  btnOK.ModalResult := mrOK;
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatLine.SetBoolean(const Value: boolean);
begin
  fSettingsUpdated := Value;
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatLine.SetDouble(const Index: Integer; const Value: double);
begin
  case Index of
    1: if not ZeroFloat(abs(fStockUnits - Value)) then
       begin
         fStockUnits := Value;
         edtStockUnits.Value := Value;
         SettingsUpdated := true;
       end;
    2: if not ZeroFloat(abs(fUnitWeight - Value)) then
       begin
         fUnitWeight := Value;
         edtUnitWeight.Value := Value;
         SettingsUpdated := true;
       end;
    3: if not ZeroFloat(abs(fUplift - Value)) then
       begin
         fUplift := Value;
         edtUplift.Value := Value;
         SettingsUpdated := true;
       end;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatLine.SetString(const Index: Integer; const Value: string);
begin
  case Index of
    1 : if fCommodityCode <> Value then
        begin
          fCommodityCode := Value;
          edtCommodCode.Text := Value;
          SettingsUpdated := true;
        end;
    2 : if fCountryOfOrigin <> Value then
        begin
          fCountryOfOrigin := Value;
          edtCountryOfOrigin.Text := Value;
          SettingsUpdated := true;
        end;
  end; // case
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatLine.FormShow(Sender: TObject);
begin
  // Uplift only shown in Eire
  if (CurrentCountry <> IECCode) then
  begin
    lblUplift.Visible := false;
    edtUplift.Visible := false;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmIntraStatLine.edtCountryOfOriginExit(Sender: TObject);
begin
  (* Enterprise doesn't validate these codes but they should be for EC states ...
     Austria     AT
     Belgium     BE
     Denmark     DK
     Finland     FI
     France      FR
     Germany     DE
     Greece      GR
     Eire        IE
     Italy       IT
     Luxembourg  LU
     Netherlands NL
     Portugal    PT
     Spain       ES
     Sweden      SE
     UK          GB *)
end;

end.
