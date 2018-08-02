{+-----------------------------------------------------------------------------+
 | El NumEdit es un control que desciende del TEdit y que acepta únicamente    |
 | numéricos. Posee dos propiedades booleanas PermitirDec y PermitirNeg que    |
 | si se pueden introducir valores decimales y negativos, respectivamente. Dado|
 | que el Edit sigue trabajando con el valor como Texto, he incluido una       |
 | función DarValor que devuelve el contenido del NumEdit en una variable      |
 | variant, para que no tengas que andar con conversiones.                     |
 | Este producto es Freeware y puedes usarlo sin restricciones. Puedes cambiar,|
 | modificar o mejorar el código para que se ajuste a tus gustos y puedes      |
 | usarlo en                                                                   |
 | cualquier aplicación sin ningún impedimento. Si encuentras algún fallo,     |
 | quieres darme tu opinión, quieres comunicarme algún cambio en el código o   |
 | para cualquier contacto Tzimisce2003@Iespana.es                             |
 | [I'm try to explain it in English. ;)]                                      |
 | NumEdit is a descendant of Tedit with only accepts numeric values. It has   |
 | two bool properties: PermitirDec and PermitirNeg. The first one allows the  |
 | decimal values. The second allows negative values. The NumEdit value is     |
 | still a text value. For this I've include a function DarValor who returns   |
 | the Text in a Variant type. Thus, you must not work with conversion.        |
 | This Control es freeware. You can use it without restrictions and you can   |
 | make any change or improve freely. Also, you can use this in any application|
 | without permission. If you find any bug, want to give me your opinion about |
 |this or simply for contact Tzimisce2003@Iespana.es.                          |
 |                                                                             |
 | Por Dr Juzam 2004                                                           |
 +-----------------------------------------------------------------------------+}
unit NumEdit;

interface

uses
  Dialogs, StrUtil, Windows, Messages, SysUtils, Classes, Controls, StdCtrls, Variants;

type
  TEditAlignment = (alLeft, alCentre, alRight);
  TNumEdit = class(TEdit)
  private
   FPermitNegatives: Bool;
   FPermitDecimals: Bool;
   FDecimalPlaces : integer;
   FValue : Real;
   FAlignment: TEditAlignment;
    { Private declarations }
  protected
   procedure SetAlignment (value: TEditAlignment);
   procedure KeyPress(var Key: Char); override;
   procedure SetPermitNegatives (value: Bool);
   procedure SetPermitDecimals (value: Bool);
   procedure SetDecimalPlaces (value: integer);
   procedure SetValue (value: Extended);
   procedure CreateParams(var Params: TCreateParams); override;
   procedure DoExit; override;
   function GetValue : Extended;
    { Protected declarations }
  public
   Constructor Create (AOwner: TComponent); Override;
   function DarValor: Variant;
    { Public declarations }
  published
   property EditAlignment: TEditAlignment read fAlignment write setAlignment; //Gracias a Neftalí
   property PermitNegatives: Bool read FPermitNegatives write SetPermitNegatives;
   property PermitDecimals: Bool read FPermitDecimals write SetPermitDecimals;
   property DecimalPlaces : integer read FDecimalPlaces write SetDecimalPlaces;
   property Value : Extended read GetValue write SetValue;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SBS', [TNumEdit]);
end;

constructor TNumEdit.Create (AOwner: TComponent);
begin
 inherited Create (AOwner);
 FValue := 0;
 Text:='0'; //Es necesario para que no ponga el nombre del Objeto
 if FPermitDecimals then Text := Text + '.' + StringOfChar('0',FDecimalPlaces);
end;

procedure TNumEdit.KeyPress(var Key:Char);
var
{ OriginalKey: Char;
 Num: ShortInt;
 Decimal: Bool;}
 iMinusPos, iNoOfDecsInText, iDecPos : integer;
begin
 // Blank any keys that are not backspace, '.' or numerical
 if (Key <> '.') and (Key <> '-') and (Key <> #8 {backspace})
 and ((Key < #48) or (Key > #57)) {numeric}
 then Key := #0;

 // Get Decimal place info
 iDecPos := Pos('.',Text);
 if iDecPos = 0 then iNoOfDecsInText := 0
 else iNoOfDecsInText := Length(Text) - iDecPos;

 // Can't have '.' if no decimals allowed
 if (not FPermitDecimals) and (Key = '.') then Key := #0;

 // We already have a decimal place. we can't have two !
 if (iDecPos > 0) and (Key = '.')
 and (Pos('.',Copy(Text,SelStart+1,SelLength)) = 0) // There is no '.' in the highlighed text
 then Key := #0;

 // Do not allow any more than the no of decimal places after the '.'
 if (iNoOfDecsInText = FDecimalPlaces) and (Key <> #8 {backspace})
 and (SelLength = 0) and (SelStart >= iDecPos) and FPermitDecimals
 then Key := #0;

 // Do not allow the decimal place to be inserted, if there are too many numbers after it
 if (Length(Text) - SelStart > FDecimalPlaces) and (Key = '.')
 and (Pos('.',Copy(Text,SelStart+1,SelLength)) = 0) // There is no '.' in the highlighed text
 then Key := #0;


 // Get Decimal place info
 iMinusPos := Pos('-',Text);

 // Can't have '-' if no negatives allowed
 if (not FPermitNegatives) and (Key = '-') then Key := #0;

 // We already have a '-' we can't have two !
 if (iMinusPos > 0) and (Key = '-')
 and (Pos('-',Copy(Text,SelStart+1,SelLength)) = 0) // There is no '-' in the highlighed text
 then Key := #0;

 // Do not allow the '-' to be inserted, anywhere but the beginning
 if (SelStart <> 0) and (Key = '-')
// and (Pos('.',Copy(Text,SelStart+1,SelLength)) = 0) // There is no '.' in the highlighed text
 then Key := #0;

 // Do not allow any characters to be typed before the '-'
 if (SelStart < iMinusPos)
 and (Pos('-',Copy(Text,SelStart+1,SelLength)) = 0) // There is no '-' in the highlighed text
 then Key := #0;



// if (Key='.') or (Key=',') then Key:=DecimalSeparator;

(* OriginalKey:= Key;

 if Key <> #8 then // Ignore Backspace (I think)
 begin
   // Blank any non-numeric key presses
   if (Key < #48) or (Key > #57)
   then Key := #0;
 end;{if}

 //Si es signo negativo (-)
 if (FPermitNegatives=true) and (OriginalKey='-') and (Length(Text)=0)
 then Key:=OriginalKey;

 //Si es un decimal
 if (OriginalKey=DecimalSeparator) and (FPermitDecimals=true) then
 begin
  decimal:=true;
  for Num:=0 to Length(Text) do
   if Text[num]=DecimalSeparator then begin
     Decimal:=false;
     break;
   end;
  if Decimal=true then Key:=OriginalKey;
 end;*)

 inherited KeyPress(Key);

// if (Key = Char(VK_RETURN)) then Key := #0;
end;

procedure TNumEdit.SetPermitNegatives(Value: Bool);
var
 Num: Extended;
begin
 if Value<>FPermitNegatives then
  FPermitNegatives:=Value;
 //Comprobación de integridad
 if (Text<>'') and (Text<>'-') then begin
  Num:=StrToFloat(Text);
  if (Num<0) and (FPermitNegatives=false) then begin
   Num:=(-1)*Num;    //Convierte el numero negativo en positivo
   Text:=FloatToStr(Num);
  end;
 end
 else Clear();
end;

procedure TNumEdit.SetPermitDecimals(Value: Bool);
var
 Num: Extended;
begin
 if Value<>FPermitDecimals then
  FPermitDecimals:=Value;
 //Comprobación de integridad
 if (Text<>'') and (Text<>'-') then begin
  Num:=StrToFloat(Text);
  Text:=IntToStr(Round(Num));
 end
 else Clear();
end;

function TNumEdit.DarValor: Variant;
begin
 Result:=StrToFloat(Text);
end;

procedure TNumEdit.CreateParams(var Params: TCreateParams);
const
  Alignments: array[TEditAlignment] of Longint = (ES_LEFT, ES_CENTER,
ES_RIGHT);
begin
  inherited CreateParams(Params);
  CreateSubClass(Params, 'EDIT');
  Params.Style := Params.Style {or ES_MULTILINE} or Alignments[fAlignment];
end;

procedure TNumEdit.setAlignment(Value: TEditAlignment);
begin
  if fAlignment <> Value then begin
    fAlignment:= Value;
    RecreateWnd;
  end;
end;


procedure TNumEdit.SetDecimalPlaces(value: integer);
begin
  FDecimalPlaces := value;
end;

procedure TNumEdit.DoExit;
begin
  Text := MoneyToStr(StrToFloatDef(Text, 0), FDecimalPlaces, FALSE);
  inherited;
end;

procedure TNumEdit.SetValue(value: Extended);
begin
  FValue := value;
  Text := MoneyToStr(value, FDecimalPlaces, FALSE);
end;

function TNumEdit.GetValue: Extended;
begin
  Result := StrToFloatDef(Text, 0); 
end;

end.
