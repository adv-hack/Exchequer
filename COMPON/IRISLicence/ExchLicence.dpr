library ExchLicence;

uses
  SysUtils,
  Classes,
  ViewLicenceForm in 'ViewLicenceForm.pas' {frmViewLicence},
  TIRISLicenceViewerClass in 'TIRISLicenceViewerClass.pas',
  Encryption in 'Encryption.pas';

{$R *.res}


exports
  ShowLicence,
  EncryptLicenceFile,
  DecryptLicenceFile,
  ReadAcceptanceData,
  WriteAcceptanceData;

begin

end.
