unit AltNum;

{Copyright 1995  Luis A. Bardi.  FreeWare, use it as you please}

interface

uses SysUtils,Messages,WinTypes, WinProcs, Classes, Graphics, Controls, Mask;

type

  TKind = (meCurrency, meString, meDate);

  TMyEdit = class(TMaskEdit)
  private
    FKind:TKind;
    FValue:double;
    FMaxValue:double;
    FMinValue:double;
    FDecimals:integer;
    function GetValue: double;
    procedure SetKind(aValue: TKind);
    procedure SetValue(aValue: double);
    procedure SetMaxValue(aValue: double);

    procedure SetMinValue(aValue: double);
    procedure SetDecimals(aValue: integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure KeyPress(var Key: Char); override;
  published
    property Kind: TKind read FKind write SetKind default meCurrency;
    property Value: double read GetValue write SetValue;
    property MaxValue: double read FMaxValue write SetMaxValue;
    property MinValue: double read FMinValue write SetMinValue;
    property Decimals: integer read FDecimals write SetDecimals;
  public
    procedure MyValidate;
    constructor Create(AOwner: TComponent);
  end;

procedure Register;

implementation

 type

    DoubleAndInts=Record
                case a:integer of
                  1: (d:double);
                  2:(i1:integer;
                         i2:integer;
                         i3:integer;
                         i4:integer);
              end;

  var gNaN:double; {holds the Not A Number value, faster than calling NAN
everytime}

  function NaN:double;
  var d:DoubleAndInts;
  begin
    d.i4:=$7FF4;
    d.i3:=$0010;
    d.i2:=0;
    d.i1:=0;
    NaN:=d.d;
  end;


  function IsANumber(d1:double):boolean;
  var d:doubleAndInts;
  begin
    d.d:=d1;
    if d.i4=$7FF4 then IsANumber:=FALSE
                  else IsANumber:=TRUE;
  end;

constructor TMyEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TMyEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if FKind=meCurrency then Params.Style := Params.Style or ES_MULTILINE or
ES_RIGHT;
end;


function TMyEdit.GetValue: double;

begin
  Result := FValue;
end;

procedure TMyEdit.SetKind(aValue: TKind);
begin
  if FKind <> aValue then
  begin
    FKind := aValue;
    RecreateWnd;
  end;
end;

procedure TMyEdit.SetValue(aValue: double);
begin
  FValue := aValue;
  if IsANumber(aValue) then Text:=FloatToStrF(aValue,ffFixed,15,FDecimals)
                                                                        else
Text:='';
end;

procedure TMyEdit.SetMaxValue(aValue: double);

begin
  FMaxValue := aValue;
end;

procedure TMyEdit.SetMinValue(aValue: double);
begin
  FMinValue := aValue;
end;

procedure TMyEdit.SetDecimals(aValue: integer);
begin
  FDecimals := aValue;
end;


procedure TMyEdit.KeyPress(var Key: Char);
var i:integer;
begin
  if (Key in [#32..#255]) then
  begin
    if FKind=meCurrency then if (NOT(Key in ['0'..'9','-','.'])) then
    begin

      Key := #0;
      MessageBeep(0);
    end;
  end;
  if (Key in [#32..#255]) then
  begin
    i:=MaxLength;
    if i>0 then if GetTextLen>=i then
    begin
      Key := #0;
      MessageBeep(0);
    end;
  end;
  case Key of
    #9: Key := #0;
    #13:
      begin
        MyValidate;
        SelectAll;
        Key := #0;
      end;
  end;

  if Key <> #0 then inherited KeyPress(Key);
end;

procedure TMyEdit.CMExit(var Message: TCMExit);
begin
  if not (csDesigning in ComponentState) then
  begin
    MyValidate;
    SelectAll;
  end;
  inherited;
end;

procedure TMyEdit.MyValidate;
var s:string;
    d:double;
begin
  if FKind=meCurrency then
  begin
    s:=Text;
    if s='' then d:=gNaN
            else d:=StrToFloat(s);

    if IsANumber(d) then if (d>FMaxValue) OR (d<FMinValue) then
    begin
      SetFocus;
      SelectAll;
      raise EDBEditError.Create('Value Out of Range'); {To Do: Show actual Min
& Max limits here}
    end;
    SetValue(d);
  end;
end;

procedure Register;
begin
  RegisterComponents('Custom',[TMyEdit]);
end;

begin
  gNan:=NaN;
end.

