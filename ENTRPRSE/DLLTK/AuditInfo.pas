unit AuditInfo;
{
  CJS: 25/03/2011 ABSEXCH-10687 - Auditing
}

interface

procedure InitAudit;

implementation

uses
  Forms,
  {$IFDEF COMTK}
  COMTKVER,
  {$ENDIF}
  VarConst,
  VarCnst3,
  AuditIntf;

{$I Version.Inc}

procedure InitAudit;
begin
  {$IFDEF COMTK}
    {$IFDEF WANTEXE}
    { CJS - 2013-07-08 - ABSEXCH-14438 - update branding and copyright }
    AuditSystemInformation.asApplicationDescription := 'Exchequer COM Toolkit';
    {$ELSE}
    AuditSystemInformation.asApplicationDescription := Application.ExeName + ' (COM Toolkit)';
    {$ENDIF}
    AuditSystemInformation.asApplicationVersion := COMTKVersion;
  {$ELSE}
  AuditSystemInformation.asApplicationDescription := Application.ExeName + ' (DLL Toolkit)';
  AuditSystemInformation.asApplicationVersion := Ver;
  {$ENDIF}
  AuditSystemInformation.asExchequerUser := 'N/A (Toolkit)';
  AuditSystemInformation.asCompanyDirectory := ExSyss.ExPath;
  AuditSystemInformation.asCompanyName := Syss.UserName;
end;

end.