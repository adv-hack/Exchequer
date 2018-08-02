unit EnterToTab;

interface

uses
  Windows, Forms, Messages, SysUtils, Classes, Controls, Dialogs;

type
  TEnterToTab = class(TComponent)
  private
    { Private declarations }
    FName : TComponentName;
    FTag : LongInt;

    FConvertEnters : Boolean;
    FOverrideFont : Boolean;

    FOnKeyDown: TKeyEvent;
    FOnKeyPress: TKeyPressEvent;
  protected
    { Protected declarations }
    procedure Loaded; Override;

    Function GetVersion : ShortString;
    Procedure SetVersion(Value  : ShortString);
  public
    { Public declarations }
    Constructor Create(AOwner: TComponent); Override;

    procedure ProcessKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ProcessKeyPress(Sender: TObject; var Key: Char);

  published
    { Published declarations }
    Property ConvertEnters : Boolean Read FConvertEnters Write FConvertEnters;
    Property OverrideFont : Boolean Read FOverrideFont Write FOverrideFont;

    Property Name : TComponentName Read FName;
    Property Tag : LongInt Read FTag;
    Property Version : ShortString Read GetVersion Write SetVersion;
  end;

procedure Register;
                         
implementation

Uses KeyUtils;

//-------------------------------------------------------------------------

procedure Register;
begin
  RegisterComponents('SBS', [TEnterToTab]);
end;

//=========================================================================

Constructor TEnterToTab.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);

  FConvertEnters := True;
  FOverrideFont := True;
end;

//------------------------------

// Component and properties now loaded
procedure TEnterToTab.Loaded;
begin
  Inherited Loaded;

  If (Owner Is TForm) {And (Not (csDesigning in ComponentState)) }Then
  Begin
    With (Owner As TForm) Do
    Begin
      If FConvertEnters Then
      Begin
        KeyPreview := True;

        FOnKeyDown := OnKeyDown;
        OnKeyDown  := ProcessKeyDown;

        FOnKeyPress := OnKeyPress;
        OnKeyPress  := ProcessKeyPress;
      End; // If FConvertEnters

      If FOverrideFont Then
      Begin
        With Font Do
        Begin
          Name := 'Arial';
          Size := 8;
        End; // With Font
      End; // If FOverrideFont
    End; // With (Owner As TForm)
  End; // If (Owner Is TForm)
end;

//-------------------------------------------------------------------------

procedure TEnterToTab.ProcessKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  With (Owner As TForm) Do
    GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);

  If Assigned(FOnKeyDown) Then FOnKeyDown(Sender, Key, Shift);
end;

procedure TEnterToTab.ProcessKeyPress(Sender: TObject; var Key: Char);
begin
  With (Owner As TForm) Do
    GlobFormKeyPress(Sender, Key, ActiveControl, Handle);

  If Assigned(FOnKeyPress) Then FOnKeyPress(Sender, Key);
end;

//-------------------------------------------------------------------------

Function TEnterToTab.GetVersion : ShortString;
begin
  //
  // v1.00 - 01/09/04
  // -----------------------------------------------------------------
  //   MH    Initial version written and released into the wild
  //
  // v1.01 - 02/09/04
  // -----------------------------------------------------------------
  //   MH    Added special handling for Memo and Combo Box controls
  //         to improve the usability.  Memo's now Tab out if you try
  //         to cursor off the top or bottom,  Combo Boxes now allow
  //         you to use the normal cursor keys in Drop-Down mode.
  //
  // v1.02 - 20/0705
  // -----------------------------------------------------------------
  //   MH    Extended keyboard routines to include TMLCaptureEdit as
  //         a MultiList component as it was causing Up/Down to move
  //         past the list
  //
  Result := 'TEnterToTab v1.02 for Delphi 6.01';
end;

//------------------------------

Procedure TEnterToTab.SetVersion(Value  : ShortString);
begin
  // Setter proc needed to make version show in Property Inspector
end;

//-------------------------------------------------------------------------

end.
