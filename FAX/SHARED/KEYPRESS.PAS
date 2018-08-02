unit KeyPress;

{ nfrewer440 10:20 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


// Routines to allow screen handling to work as per Enterprise standard
// e.g. Return moves through the fields
// Note that KeyPreview on the form needs to be set to true

interface

uses
  Controls,
  Windows,
  Classes;

procedure GlobFormKeyPress(Sender: TObject;
                       var Key   : Char;
                           ActiveControl :  TWinControl);

procedure GlobFormKeyDown(Sender : TObject;
                      var Key    : Word;
                          Shift  : TShiftState;
                          ActiveControl :  TWinControl;
                          Handle :  THandle);

implementation

uses
  StdCtrls,
  ComCtrls,
  TEditVal,
  Grids,
  SBSOutL,
  BorBtns,
  Messages;

procedure GlobFormKeyPress(Sender: TObject;
                       var Key   : Char;
                           ActiveControl :  TWinControl);
var
  IrqKey  :  Boolean;
begin
  IrqKey := true;

  If (ActiveControl is TSBSComboBox) then
    With (ActiveControl as TSBSComboBox) do
    Begin

      IrqKey:=(IrqKey and (Not InDropDown));

    end
    else
      If (ActiveControl is TStringGrid) or
         (ActiveControl is TUpDown) or
         (ActiveControl is TSBSOutLineB) then {* switched off so it does not interfere with a list *}
        IrqKey:=false;

  If ((Key=#13)  or (Key=#10)) and (IrqKey) then
  begin

    Key:=#0;

  end;
end;

procedure GlobFormKeyDown(Sender : TObject;
                      var Key    : Word;
                          Shift  : TShiftState;
                          ActiveControl
                                 :  TWinControl;
                          Handle :  THandle);

var
  IrqKey  :  Boolean;

begin

  IrqKey:=((Not (ssCtrl In Shift)) and (Not (ssAlt In Shift)) and (Not (ssShift In Shift)));

  If (ActiveControl is TSBSComboBox) then
    With (ActiveControl as TSBSComboBox) do
  begin

    IrqKey:=(IrqKey and (Not InDropDown));

  end
  else
    if (ActiveControl is TStringGrid) or
       (ActiveControl is TUpDown) or
       (ActiveControl is TSBSOutLineB) then {* Could combine with a switch, as there maybe cases where a
                                                                                 a string grid is used without the list... *}
      IrqKey:=false;


  if (IrqKey) then
  case Key of


    VK_Up  :  begin
                PostMessage(Handle,wm_NextDlgCtl,1,0);
                Key:=0;
              end;
    VK_Return,
    VK_Down
           :  begin
                if ((Not (ActiveControl is TBorCheck)) and (not(ActiveControl is TBorRadio))) or (Key=VK_Return) then
                begin
                  PostMessage(Handle,wm_NextDlgCtl,0,0);
                  Key:=0;
                end
                else
                  Key:=Vk_Tab;

              end;
  end; // case
end;

end.
