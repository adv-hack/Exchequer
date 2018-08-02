unit SpellCheck4Modal;

interface

uses
  Windows, Forms, Messages, SysUtils, Classes, Controls, Dialogs;

type
  TSpellCheck4Modal = class(TComponent)
  private
    FName : TComponentName;
    FTag : LongInt;
    FOnKeyDown: TKeyEvent;
  protected
    procedure Loaded; Override;
    Function GetVersion : ShortString;
    Procedure SetVersion(Value  : ShortString);
  public
    Constructor Create(AOwner: TComponent); Override;
    procedure ProcessKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  published
    Property Name : TComponentName Read FName;
    Property Tag : LongInt Read FTag;
    Property Version : ShortString Read GetVersion Write SetVersion;
  end;

procedure Register;

implementation

Uses
  SpellUtil;

//-------------------------------------------------------------------------

procedure Register;
begin
  RegisterComponents('SBS', [TSpellCheck4Modal]);
end;

//=========================================================================

Constructor TSpellCheck4Modal.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
end;

//------------------------------

// Component and properties now loaded
procedure TSpellCheck4Modal.Loaded;
begin
  Inherited Loaded;

  // CJS 03/06/2011 ABSEXCH-11452 - added csDesigning check to prevent this
  // component from replacing the KeyDown handler at design-time.
  If (Owner Is TForm) and (not (csDesigning in ComponentState)) then
  Begin
    With (Owner As TForm) Do
    Begin
      KeyPreview := True;
      FOnKeyDown := OnKeyDown;
      OnKeyDown  := ProcessKeyDown;
    End; // With (Owner As TForm)
  End; // If (Owner Is TForm)
end;

//-------------------------------------------------------------------------

procedure TSpellCheck4Modal.ProcessKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If (Owner Is TForm) Then
  Begin
    if (Key = VK_F12) and (ssShift in Shift)  // Shift+F12
    then SpellCheckControl((Owner As TForm).ActiveControl);
  end;{if}

  If Assigned(FOnKeyDown) Then FOnKeyDown(Sender, Key, Shift);
end;

Function TSpellCheck4Modal.GetVersion : ShortString;
begin
  Result := 'TSpellCheck4Modal v5.70.001 for Delphi 6.01';
end;

Procedure TSpellCheck4Modal.SetVersion(Value  : ShortString);
begin
  // Setter proc needed to make version show in Property Inspector
end;

end.
