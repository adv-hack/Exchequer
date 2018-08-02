unit Key;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  Windows, Controls, Classes, Messages, uMultiList, uDBMultiList, uScrollBar;

Const
  WM_CustGetRec    =  WM_User+$1;

  procedure GlobFormKeyPress(Sender: TObject; var Key : Char; ActiveControl : TWinControl
  ; Handle: THandle);
  procedure GlobFormKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState
  ; ActiveControl : TWinControl; Handle : THandle);

implementation

uses
  StdCtrls, Grids, ComCtrls, Forms, TEditVal{, BTSupU1};

procedure GlobFormKeyPress(Sender: TObject; var Key : Char; ActiveControl : TWinControl
; Handle: THandle);
Var
  bReplaceReturns : Boolean;
begin
  bReplaceReturns := TRUE;

  If (ActiveControl is TStringGrid) or (ActiveControl is TUpDown)
  or ((ActiveControl is TMemo) and (Not (ActiveControl is TCurrencyEdit)))
  or (ActiveControl is TMultiList) or (ActiveControl is TDBMultiList)
  or (ActiveControl is TCustomScrollBar)
  then bReplaceReturns := FALSE;

  if ((Key = #13) or (Key = #10)) and (bReplaceReturns) then Key := #0;
end;

procedure GlobFormKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState
; ActiveControl : TWinControl; Handle : THandle);
Var
  bReplaceReturns : Boolean;

  procedure ClickOk(Sender : TObject; Var VKey : Word);
  Var
    n : Integer;
  Begin
    If (Sender is TForm) then begin
      With TForm(Sender) do Begin
        For n := 0 to Pred(ComponentCount) do begin
          If (Components[n] is TButton) then begin
            With TButton(Components[n]) do begin
              If ((Caption = 'OK') or (Caption = '&OK') or (ModalResult = mrOk)) and (Enabled) and (Visible) and (CanFocus)
              then begin
                VKey := 0;
                Click;
                Exit;
              end;{if}
            end;{with}
          end;{if}
        end;{for}
      end;{with}
    end;{if}
  end;{ClickOk}

begin
  bReplaceReturns := ((Not (ssCtrl In Shift)) and (Not (ssAlt In Shift)) and (Not (ssShift In Shift)));

  If (ActiveControl is TStringGrid) or (ActiveControl is TUpDown)
  or ((ActiveControl is TMemo) and (Not (ActiveControl is TCurrencyEdit)))
  or (ActiveControl is TMultiList) or (ActiveControl is TDBMultiList)
  or (ActiveControl is TCustomScrollBar)
  then bReplaceReturns := FALSE;

  If bReplaceReturns then begin
    Case Key of
{      VK_Up : Begin
        if (Not(ActiveControl is TComboBox)) and (Not(ActiveControl is TListView))
        and (Not(ActiveControl is TListBox)) then begin
          PostMessage(Handle, wm_NextDlgCtl, 1, 0);
          Key := 0;
        end;{if}
{      end;}

      VK_Return{, VK_Down} : Begin
        If (Key = VK_Return) and (Not bReplaceReturns) then Exit;

        If ((Not (ActiveControl is TCheckbox)) and (Not(ActiveControl is TRadioButton))
        and (Not(ActiveControl is TComboBox))) and (Not(ActiveControl is TListView))
        and (Not(ActiveControl is TListBox)) or (Key = VK_Return) then
          Begin
            PostMessage(Handle, wm_NextDlgCtl, 0, 0);
            Key := 0;
          end
        else begin
          if (Not(ActiveControl is TComboBox)) and (Not(ActiveControl is TListView))
          and (Not(ActiveControl is TListBox)) then Key := Vk_Tab;
        end;{if}
      end;
    end;{case}
  end;{if}

  If (Key In [VK_Prior,VK_Next]) and (ssCtrl In Shift)
  then PostMessage(Handle,wm_CustGetRec,175,Ord(Key=VK_Prior));

  If ((Key=VK_Return) and (ssCtrl In Shift)) then ClickOK(Sender,Key);
end;

end.
