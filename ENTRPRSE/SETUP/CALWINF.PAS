unit CalWinF;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, ExtCtrls, StdCtrls, SetupU, FileCtrl;

type
  TfrmDLLWarning = class(TSetupTemplate)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    btnMoveFiles: TButton;
    procedure btnMoveFilesClick(Sender: TObject);
  private
    { Private declarations }
    procedure MoveFile(Const FName : String);
  public
    { Public declarations }
    WinSys : String;
  end;


function SCD_DLLChecks(var DLLParams: ParamRec): LongBool;  {$IFDEF WIN32} StdCall; {$ENDIF} export;

implementation

{$R *.DFM}

function SCD_DLLChecks(var DLLParams: ParamRec): LongBool;
var
  frmDLLWarning : TfrmDLLWarning;
  W_WinSys      : String;
Begin { SCD_DLLChecks }
  Application.HelpFile := '';

  { Get path to Windows\System or WinNT\System32 }
  GetVariable(DLLParams, 'SYS', W_WinSys);
  W_WinSys := IncludeTrailingBackslash (W_WinSys);

  If FileExists (W_WinSys + 'CALWIN32.DLL') Or FileExists (W_WinSys + 'CLNWINTH.DLL') Then Begin
    { Got a dodgy DLL }
    frmDLLWarning := TfrmDLLWarning.Create(Application);
    Try
      With frmDLLWarning Do Begin
        Label3.Caption := Label3.Caption + W_WinSys + '.';
        WinSys := W_WinSys;

        ShowModal;
      End; { With frmDLLWarning }
    Finally
      frmDLLWarning.Release;
    End;
  End; { If }

  Result := False;
End; { SCD_DLLChecks }

{-----------------------------------------------------------------------------}


procedure TfrmDLLWarning.MoveFile(Const FName : String);
Var
  FromF, ToF : PChar;
  Err        : Boolean;
Begin { MoveFile }
  Err := False;

  { Check EntBak directory exists of Win\Sys }
  If (Not DirectoryExists (WinSys + 'EntBak')) Then
    Err := Not ForceDirectories (WinSys + 'EntBak');

  If (Not Err) Then Begin
    { Destination directory exists - Move File }
    FromF := StrAlloc(255);
    ToF   := StrAlloc(255);

    StrPCopy (FromF, WinSys + FName);
    StrPCopy (ToF,   WinSys + 'EntBak\' + FName);

    Err := Not Windows.MoveFile(FromF, ToF);

    StrDispose (FromF);
    StrDispose (ToF);
  End; { If (Not Err) }

  If Err Then
    MessageDlg ('An error occurred trying to move ' + FName + ', please notify your System Administrator', mtError, [mbOk], 0);
End; { MoveFile }

procedure TfrmDLLWarning.btnMoveFilesClick(Sender: TObject);
begin
  inherited;

  If FileExists (WinSys + 'CALWIN32.DLL') Then Begin
    MoveFile('CALWIN32.DLL');
  End; { If FileExists (W_WinSys + 'CALWIN32.DLL') }

  If FileExists (WinSys + 'CLNWINTH.DLL') Then Begin
    MoveFile('CLNWINTH.DLL');
  End; { If FileExists (W_WinSys + 'CLNWINTH.DLL') }

  { Close dialog }
  ExitCode := 'X';
  Close;
end;

End.
