unit RegBtrv;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, SetupU, SetupReg, CompUtil,
  StdCtrls, ExtCtrls;

type
  TLFormMode = (fmBtrieve, fmCustomisation);

  TfrmRegisterBtrieve = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    lMessage: TLabel;
    procedure FormActivate(Sender: TObject);
  private
    sTCMPath, sEnterpriseDir{, WiseStr} : string;
    iPVPersion, iPSQLVersion : integer;
    { Private declarations }
  public
    FormMode : TLFormMode;
  end;

  function RegisterCustomisation(var DLLParams: ParamRec): LongBool; StdCall; export;
  function RegisterBtrieve(var DLLParams: ParamRec): LongBool; StdCall; export;


implementation
uses
  EntLic, LicRec, APIUtil;

{$R *.DFM}

function RegisterCustomisation(var DLLParams: ParamRec): LongBool;
Var
  frmRegisterBtrieve : TfrmRegisterBtrieve;
  sPath : string;
Begin { WorkStationSetup }
  Result := TRUE;

  try
    frmRegisterBtrieve := TfrmRegisterBtrieve.Create(Application);
    frmRegisterBtrieve.FormMode := fmCustomisation;
    GetVariable(DLLParams, 'NEWTRADEEXE', sPath);
    frmRegisterBtrieve.sTCMPath := sPath;
    frmRegisterBtrieve.ShowModal;
  finally
    frmRegisterBtrieve.Release;
  end;{try}

End; { WorkStationSetup }

function RegisterBtrieve(var DLLParams: ParamRec): LongBool;
Var
  frmRegisterBtrieve : TfrmRegisterBtrieve;
  sPV : string;
Begin { WorkStationSetup }
  Result := TRUE;
  try
    frmRegisterBtrieve := TfrmRegisterBtrieve.Create(Application);
    frmRegisterBtrieve.FormMode := fmBtrieve;
//    GetVariable(DLLParams, 'INSTALLTO', frmRegisterBtrieve.WiseStr);
    GetVariable(DLLParams, 'ENTERDIR', frmRegisterBtrieve.sEnterpriseDir);
    GetVariable(DLLParams, 'PVVERSION', sPV);
    frmRegisterBtrieve.iPVPersion := StrToIntDef(sPV,0);
    GetVariable(DLLParams, 'PSQLVERSION', sPV);
    frmRegisterBtrieve.iPSQLVersion := StrToIntDef(sPV,0);
    frmRegisterBtrieve.ShowModal;
  finally
    frmRegisterBtrieve.Release;
  end;{try}
End; { WorkStationSetup }

procedure TfrmRegisterBtrieve.FormActivate(Sender: TObject);
Var
  RegSetup : TSetupEntRegistry;
  LicRec : EntLicenceRecType;
begin
  Refresh;

  case FormMode of
    fmBtrieve : begin
      lMessage.Caption := 'Registering Btrieve Settings...';
      lMessage.Refresh;
      Application.ProcessMessages;
      RegSetup := TSetupEntRegistry.Create;
      Try
        With RegSetup Do Begin

          // New Workgroup Stuff
          RegSetup.PSQLWorkgroupVer := iPSQLVersion;
          RegSetup.PervasiveVersion := iPVPersion;

          { Get Registration Directory from WISE }
          sEnterpriseDir := IncludeTrailingBackslash(sEnterpriseDir);
          EntDir := sEnterpriseDir;

          { Get Client/Server-ness from entrprse.dat}
          ReadEntLic(sEnterpriseDir + 'Entrprse.dat', LicRec);
          ClientServer := LicRec.licEntClSvr = 1;

          { Setup Btrieve }
          SetupBtrieve615;

        End; { With }
      Finally
        RegSetup.Free;
      End;
    end;

    fmCustomisation : begin
      lMessage.Caption := 'Registering TCM Customisation...';
      lMessage.Refresh;
      Application.ProcessMessages;
      RunApp(sTCMPath + ' /REGSERVER', True);
    end;
  end;{case}

  PostMessage(handle, WM_Close, 0, 0);
end;

end.
