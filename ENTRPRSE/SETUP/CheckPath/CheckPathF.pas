unit CheckPathF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Registry;

type
  TForm1 = class(TForm)
    lblInfo: TLabel;
    btnFixPATH: TButton;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFixPATHClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    Reg : TRegistry;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Const
  RegSection = '\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\';

//=========================================================================

procedure TForm1.FormCreate(Sender: TObject);
begin
  Self.Caption := Application.Title;

  // Create a Registry object to look at the PATH
  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;

  // Check the type of the PATH entry
  If Reg.OpenKey(RegSection, False) Then
  Begin
    If Reg.ValueExists('Path') Then
    Begin
      If (Reg.GetDataType('Path') <> rdExpandString) Then
      Begin
        lblInfo.Caption := 'The PATH in Registry has the wrong data type, click the ''Fix PATH'' button below to correct this issue.';
        btnFixPath.Enabled := True;
      End // If (Reg.GetDataType('Path') <> rdExpandString)
      Else
      Begin
        lblInfo.Caption := 'The PATH in Registry has the correct data type.';
        btnFixPath.Enabled := False;
      End; // Else
    End // If Reg.ValueExists('Path')
    Else
    Begin
      lblInfo.Caption := 'The registry entry for the PATH could not be found.';
      btnFixPath.Enabled := False;
    End; // Else

    Reg.CloseKey;
  End // If Reg.OpenKey(RegSection, False)
  Else
  Begin
    lblInfo.Caption := 'This utility was unable to open the Registry Key required to see the PATH.';
    btnFixPath.Enabled := False;
  End; // Else
end;

//------------------------------

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Reg.Free;
end;

//-------------------------------------------------------------------------

procedure TForm1.btnFixPATHClick(Sender: TObject);
Var
  sEnvPath  : ANSIString;

  //------------------------------

  // Broadcasts a message to all applications (including Windows) to tell it the PATH has changed
  Procedure BroadCastUpdateMessage;
  Var
    lParam, wParam : Integer;
    Buf     : Array[0..10] of Char;
    aResult : Cardinal;
  Begin // BroadCastUpdateMessage
    Buf := 'Environment';
    wParam := 0;
    lParam := Integer(@Buf[0]);
    SendMessageTimeout (HWND_BROADCAST,
                        WM_SETTINGCHANGE,
                        wParam,
                        lParam,
                        SMTO_NORMAL,
                        4000,
                        aResult);
  End; // BroadCastUpdateMessage

  //------------------------------

begin
  // Open the registry so we can save the path using the correct data type
  If Reg.OpenKey(RegSection, False) Then
  Begin
    If Reg.ValueExists('Path') Then
    Begin
      // Check the PATH entry has the known problem
      If (Reg.GetDataType('Path') <> rdExpandString) Then
      Begin
        // Get the current PATH value
        sEnvPath := Reg.ReadString('Path');

        // Write it back using the correct data type
        Reg.WriteExpandString('Path', sEnvPath);

        // Post a message to cause Windows/other apps to detect the change
        BroadCastUpdateMessage;

        MessageDlg('The PATH has been updated', mtInformation, [mbOK], 0);
        PostMessage(Self.Handle, WM_Close, 0, 0);
      End; // If (Reg.GetDataType('Path') <> rdExpandString)
    End // If Reg.ValueExists('Path')
    Else
      // Shouldn't ever happen
      MessageDlg('The registry entry for the PATH could not be found', mtError, [mbOK], 0);

    Reg.CloseKey;
  End // If Reg.OpenKey(RegSection, False)
  Else
    // Shouldn't ever happen
    MessageDlg('This utility was unable to open the Registry Key required to see the PATH', mtError, [mbOK], 0);
end;

//-------------------------------------------------------------------------

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//=========================================================================

end.

