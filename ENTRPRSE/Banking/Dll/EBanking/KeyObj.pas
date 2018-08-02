unit KeyObj;

interface

uses
  Classes, Forms, Messages, Windows, StdCtrls, Controls;

type
  TKeyDownObject = Class
  private
    FForm : TForm;
    FShiftKeyDown : Boolean;
    FAltKeyDown : Boolean;
    FOriginalAppMessage : TMessageEvent;
    FOriginalKeyDown,
    FOriginalKeyUp  : TKeyEvent;
    procedure DoCancelButton;
    procedure DoAltButtons(KeyCode : Char);
    procedure AppMessage (var Msg: TMsg; var Handled: Boolean);
    procedure ObjectKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ObjectKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  public
    constructor Create;
    procedure Start(Sender : TForm);
    procedure Stop;
  end;

  function KeyDownObject : TKeyDownObject;

implementation

uses
  KeyUtils, Dialogs, SysUtils;

var
  KeyDownO : TKeyDownObject;

function KeyDownObject : TKeyDownObject;
begin
  if not Assigned(KeyDownO) then
    KeyDownO := TKeyDownObject.Create;

  Result := KeyDownO;
end;

{ TKeyDownObject }

procedure TKeyDownObject.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
    If (Msg.message = WM_KEYDOWN) then
    begin
      case Msg.wParam of
        9 : // Tab Key Down
          // Tabs do not work in this scenario
          // : MDI form in a DLL when not shown modally
             PostMessage(FForm.Handle,wm_NextDlgCtl,Ord(FShiftKeyDown),0); // Tab to Next / Previous control


        // Trap Enter Key
        13 :   // Enter Key down
          if (FForm.ActiveControl is TButton) then
          begin
            // The 'Click' event does not appear to trigger on buttons when you press enter
            (FForm.ActiveControl as TButton).Click;
          end else
          begin
            // Replace Enter with Tab
            if ReplaceEntersForControl(FForm.ActiveControl)
            then PostMessage(Screen.ActiveForm.Handle,wm_NextDlgCtl,0,0); // Tab to Next control
          end;{if}

        16 : //ShiftKey
             FShiftKeyDown := True;

        18 : //Alt Key - this never gets here - alt key is handled in ObjectKeyDown
             FAltKeyDown := True;


        // Trap Escape Key
        27 : begin  // Escape Key down
              // The 'Click' event does not appear to trigger on buttons that have cancel set to true, when you press ESC
              //btnCancel.Click;
               DoCancelButton;
             end;

        38 : //Up Arrow
            if ReplaceEntersForControl(FForm.ActiveControl)
            then PostMessage(Screen.ActiveForm.Handle,wm_NextDlgCtl,1,0); // Tab to Next control

        40 : //Up Arrow
            if ReplaceEntersForControl(FForm.ActiveControl)
            then PostMessage(Screen.ActiveForm.Handle,wm_NextDlgCtl,0,0); // Tab to Next control

        65..91
           : DoAltButtons(Char(Msg.wParam));

      end;{case}
//      ShowMessage(IntToStr(Msg.wParam));
    end{if}
    else
    if (Msg.message = WM_KEYUP) then
    begin
      Case Msg.wParam of
      //Shift Key
        16 : FShiftKeyDown := False;
      //Alt Key - this never gets here - alt key is handled in ObjectKeyUp
        18 : FAltKeyDown := False;
      end;
    end;


end;

constructor TKeyDownObject.Create;
begin
  FShiftKeyDown := False;
  FAltKeyDown := True;
end;

procedure TKeyDownObject.DoAltButtons(KeyCode : Char);
var
  i : integer;
begin
  if FAltKeyDown then
  with FForm do
  begin
    for i := 0 to ComponentCount - 1 do
      if Components[i] is TButton then
      begin
        with Components[i] as TButton do
          if Visible and Enabled and (Pos('&' + KeyCode, Caption) > 0) then
          begin
            Click;
            Break;
          end;
      end;
  end;
end;

procedure TKeyDownObject.DoCancelButton;
var
  i : integer;
begin
  {Called when Escape key pressed. If any of the form's components is a button with Cancel
  set to true then click it.}
  with FForm do
  begin
    for i := 0 to ComponentCount - 1 do
      if Components[i] is TButton then
        with Components[i] as TButton do
          if Visible and Enabled and Cancel then
          begin
            Click;
            Break;
          end;
  end;
end;

procedure TKeyDownObject.ObjectKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //Alt key down & ascii keys while alt don't go through Application.MessageEvent, so
  //deal with them here - same for alt key up
  Case Key of
    18 :  FAltKeyDown := True;
    65..90 : DoAltButtons(Char(Key));
  end;
end;

procedure TKeyDownObject.ObjectKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 18 then
    FAltKeyDown := False;
end;

procedure TKeyDownObject.Start(Sender : TForm);
begin
  FForm := Sender;
  FOriginalAppMessage := Application.OnMessage;
  Application.OnMessage := AppMessage;
  FOriginalKeyDown := FForm.OnKeyDown;
  FForm.OnKeyDown := ObjectKeyDown;
  FOriginalKeyUp := FForm.OnKeyUp;
  FForm.OnKeyUp := ObjectKeyUp;
end;

procedure TKeyDownObject.Stop;
begin
  Application.OnMessage := FOriginalAppMessage;
  FForm.OnKeyDown := FOriginalKeyDown;
  FForm.OnKeyUp := FOriginalKeyUp;
end;

Initialization
  KeyDownO := nil;

Finalization
  if Assigned(KeyDownO) then
    KeyDownO.Free;

end.
