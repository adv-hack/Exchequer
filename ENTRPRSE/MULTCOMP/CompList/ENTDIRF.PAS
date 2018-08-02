unit EntDirF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, ExtCtrls, StdCtrls;

type
  TfrmEnterpriseDir = class(TSetupTemplate)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure HelpBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Function ValidOk(VCode : Char) : Boolean; OverRide;
  end;

var
  frmEnterpriseDir: TfrmEnterpriseDir;

implementation

{$R *.dfm}

Uses MainF;

//--------------------------------------------------------------------------

procedure TfrmEnterpriseDir.FormCreate(Sender: TObject);
begin
  inherited;

  Caption := Application.Title;
  ExitMsg := 255;
end;

//--------------------------------------------------------------------------

procedure TfrmEnterpriseDir.HelpBtnClick(Sender: TObject);
begin
  //inherited;

  Close;
end;

//--------------------------------------------------------------------------

procedure TfrmEnterpriseDir.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;

  If CanClose And (ExitCode = '?') Then Application.MainForm.Close;
end;

//--------------------------------------------------------------------------

procedure TfrmEnterpriseDir.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  Action := caFree;
end;

//--------------------------------------------------------------------------

Function TfrmEnterpriseDir.ValidOk(VCode : Char) : Boolean;
Begin { ValidOK }
  Result := Inherited ValidOK (VCode);

  If (VCode = 'N') Then Begin


    ControlWizard (Stage_Scan);
  End; { If (VCode = 'N') }
End; { ValidOK }

//--------------------------------------------------------------------------

end.
