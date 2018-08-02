unit RegComF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WiseUtil, RegCom, StdCtrls;

type
  TfrmCOMRegistration = class(TForm)
    lblRegistrationProgress: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Procedure OnNotify (Const NotificationType : TNotificationType; Const Desc : ShortString);
  public
    { Public declarations }
  end;

// Called from the Exchequer/IAO Workstation Setup programs to register the COM Objects
function RegisterCOMObjects(var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.dfm}

Uses Brand;

//-------------------------------------------------------------------------

// Called from the Exchequer/IAO Workstation Setup programs to register the COM Objects,
// returns TRUE and sets V_DLLERROR if an error occurs
function RegisterCOMObjects(var DLLParams: ParamRec): LongBool;
var
  frmCOMRegistration : TfrmCOMRegistration;
  ComRegO            : TExchequerCOMRegistration;
  sRegDir, sDataDir, sRegOutlook  : ANSIString;
  DLLStatus          : LongInt;
Begin // RegisterCOMObjects
  DLLStatus := 0;

  frmCOMRegistration := TfrmCOMRegistration.Create(NIL);
  Try
    // V_REGDIR - Location of .EXE's/.DLL's/etc...
    GetVariable(DLLParams, 'V_LONGREGDIR', sRegDir);

    // V_DATADIR - Location of main company data set
    GetVariable(DLLParams, 'V_LONGDATADIR', sDataDir);

    ComRegO := TExchequerCOMRegistration.Create(sRegDir, sDataDir);
    Try
      ComRegO.OnNotify := frmCOMRegistration.OnNotify;
      frmCOMRegistration.Show;

      // Check whether the Outlook Add-Ins should be registered
      GetVariable(DLLParams, 'VP_OUTLOOKADDINS', sRegOutlook);
      If (sRegOutlook <> 'Y') Then ComRegO.SelectedComponents := ComRegO.SelectedComponents - [ecOutlookToday];

      DLLStatus := ComRegO.RegisterCOMObjects(False);  // Stop at first error
    Finally
      FreeAndNIL(ComRegO);
    End; // Try..Finally
  Finally
    FreeAndNIL(frmCOMRegistration);
  End; // Try..Finally

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; // RegisterCOMObjects

//-------------------------------------------------------------------------

procedure TfrmCOMRegistration.FormCreate(Sender: TObject);
begin
  Caption := 'Registering ' + Branding.pbProductName + ' COM Components';
end;

//-------------------------------------------------------------------------

Procedure TfrmCOMRegistration.OnNotify (Const NotificationType : TNotificationType; Const Desc : ShortString);
Begin // OnNotify
  Case NotificationType Of
    notRegistering : lblRegistrationProgress.Caption := 'Registering ' + Desc + ', please wait...';
    notTesting     : lblRegistrationProgress.Caption := 'Testing ' + Desc + ', please wait...';
    notOK          : lblRegistrationProgress.Caption := Desc + ' is registered correctly';
    notFailed      : lblRegistrationProgress.Caption := 'Registration of ' + Desc + ' failed';
  End; // Case NotificationType
  Self.RePaint;

//  ShowMessage ('TfrmCOMRegistration.OnNotify (' + IntToStr(Ord(NotificationType)) + ', ' + Desc + ')')
End; // OnNotify

//-------------------------------------------------------------------------

end.
