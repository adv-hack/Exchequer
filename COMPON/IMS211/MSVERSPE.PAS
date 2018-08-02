(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msVersPe;

{$I msDef.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
{$IFDEF VER140}
  DesignIntf,
  DesignWindows,
  DesignEditors,
{$ELSE}
  DsgnIntf,
{$ENDIF}
  msDef, ExtCtrls, ShellAPI;

type
  TmsVersionDlg = class(TForm)
    Bevel1: TBevel;
    ProgramName: TLabel;
    Label2: TLabel;
    ProductVersion: TLabel;
    Label4: TLabel;
    Image1: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Label1: TLabel;
    OKButton: TButton;
    RegisterButton: TButton;
    procedure Label6Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure RegisterButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TmsVersionProperty = class(TStringProperty)
    procedure Edit; override;
    function GetAttributes : TPropertyAttributes; override;
  end;

var
  msVersionDlg: TmsVersionDlg;

implementation

{$R *.DFM}

procedure TmsVersionProperty.Edit;
begin
  with TmsVersionDlg.Create(Application) do
  try
    ProgramName.Caption:='Internet Mail Suite';
    ProductVersion.Caption:=msVersion;
{$IFDEF UNREGISTERED}
    ProductVersion.Caption:=ProductVersion.Caption+' (Unregistered)';
    RegisterButton.Visible:=true;
{$ENDIF}
    ShowModal;
  finally
    Free;
  end;
end;

function TmsVersionProperty.GetAttributes: TPropertyAttributes;
begin
  Result:=[paDialog,paReadOnly];
end;

procedure TmsVersionDlg.Label6Click(Sender: TObject);
begin
  ShellExecute(Handle,'open','mailto:support@argosoft.com','','',SW_SHOW);
end;

procedure TmsVersionDlg.Label7Click(Sender: TObject);
begin
  ShellExecute(Handle,'open','http://www.argosoft.com','','',SW_SHOW);
end;

procedure TmsVersionDlg.RegisterButtonClick(Sender: TObject);
begin
  ShellExecute(Handle,'open','http://www.argosoft.com/delphi/register.html','','',SW_SHOW);
end;

end.
