unit jcfuncs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, ExtCtrls, Mask, TEditVal, Grids, ComCtrls;


function LJVar(const s : string; Len : integer) : string;
function ZerosAtFront(Value : Integer; Len : Byte) : string;

procedure GlobFormKeyDown(Sender : TObject;
                      var Key    : Word;
                          Shift  : TShiftState;
                          ActiveControl
                                 :  TWinControl;
                          Handle :  THandle);

procedure GlobFormKeyPress(Sender: TObject;
                       var Key   : Char;
                           ActiveControl
                                 :  TWinControl;
                           Handle:  THandle);




implementation

uses
  JcVar;


procedure GlobFormKeyDown(Sender : TObject;
                      var Key    : Word;
                          Shift  : TShiftState;
                          ActiveControl
                                 :  TWinControl;
                          Handle :  THandle);

Var
  IrqKey  :  Boolean;
  TComp   :  TComponent;

begin

  IrqKey:=((Not (ssCtrl In Shift)) and (Not (ssAlt In Shift)) and (Not (ssShift In Shift)));

  If (ActiveControl is TSBSComboBox) then
    With (ActiveControl as TSBSComboBox) do
  Begin

    IrqKey:=(IrqKey and (Not InDropDown));

  end
  else
    If (ActiveControl is TStringGrid) or
       (ActiveControl is TUpDown)  or

         { HM 09/11/99: Was interfering with Memo control on print dialog }
       ((ActiveControl is TMemo) and (Not (ActiveControl is TCurrencyEdit)))  then {* Could combine with a switch, as there maybe cases where a
                                                                                 a string grid is used without the list... *}
      IrqKey:=False;


  If (IrqKey) then
  Case Key of


    VK_Up  :  Begin
                PostMessage(Handle,wm_NextDlgCtl,1,0);
                Key:=0;
              end;
    VK_Return,
    VK_Down
           :  Begin
                If (Key=VK_Return) and (Not UseDosKeys) then
                  Exit;


              {  If (Key=VK_Return) then}
                Begin
                  PostMessage(Handle,wm_NextDlgCtl,0,0);
                  Key:=0;
                end;
{                else
                  Key:=Vk_Tab;}

              end;

  end;
end;

function LJVar(const s : string; Len : integer) : string;
begin
  Result := Copy(s + StringOfChar(' ', Len), 1, Len);
end;

function ZerosAtFront(Value : Integer; Len : Byte) : string;
var
  s : string;
begin
  s := IntToStr(Value);
  while Length(s) < Len do
    s := '0' + s;

  Result := s;
end;

procedure GlobFormKeyPress(Sender: TObject;
                       var Key   : Char;
                           ActiveControl
                                 :  TWinControl;
                           Handle:  THandle);

Var
  IrqKey  :  Boolean;

begin
  IrqKey:= UseDosKeys;

  If (ActiveControl is TSBSComboBox) then
    With (ActiveControl as TSBSComboBox) do
    Begin

      IrqKey:=(IrqKey and (Not InDropDown));

    end
    else
      If (ActiveControl is TStringGrid) or
         (ActiveControl is TUpDown) or
         { HM 09/11/99: Was interfering with Memo control on print dialog }
         ((ActiveControl is TMemo) and (Not (ActiveControl is TCurrencyEdit)))  then {* switched off so it does not interfere with a list *}
        IrqKey:=False;

  If ((Key=#13)  or (Key=#10)) and (IrqKey) then
  Begin

    Key:=#0;

  end;
end;



end.
