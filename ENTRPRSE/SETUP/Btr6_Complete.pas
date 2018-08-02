unit Btr6_Complete;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, WiseAPI, BorBtns;

type
  TfrmBtr6Complete = class(TSetupTemplate)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{ 'Installation Complete' dialog for IAO Btrieve v6.15 Pre-Installer }
function btr6CompleteDlg (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.dfm}

Uses Brand;

{ 'Installation Complete' dialog for IAO Btrieve v6.15 Pre-Installer }
function btr6CompleteDlg (var DLLParams: ParamRec): LongBool;
Var
  W_Install : String;
Begin // btr6CompleteDlg
  With TfrmBtr6Complete.Create(Application) Do
  Begin
    Try
      Caption := Branding.pbProductName + ' Btrieve v6.15 Pre-Installer';

      ShowModal;
    Finally
      Free;
    End; // Try..Finally
  End; // With TfrmBtr6Complete.Create(Application)

  Result := False;
End; // btr6CompleteDlg

end.
