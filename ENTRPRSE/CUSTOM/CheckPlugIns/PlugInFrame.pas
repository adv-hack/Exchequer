unit PlugInFrame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TSinglePlugInFrame = class(TFrame)
    lblPlugInName: TLabel;
    lblPlugInDesc: TLabel;
    lblInstallPlugIn: TLabel;
    lblPlugInInstalled: TLabel;
    procedure lblInstallPlugInClick(Sender: TObject);
  private
    FPlugInFilename : ShortString;
    FPlugInName : ShortString;
    FPlugInDesc : ShortString;
    FPlugInInstaller : ShortString;

    Procedure SetPlugInName(Value : ShortString);
    Procedure SetPlugInDesc(Value : ShortString);
    Procedure SetPlugInInstaller(Value : ShortString);
  public
    Property pifFilename : ShortString Read FPlugInFilename Write FPlugInFilename;
    Property pifName : ShortString Read FPlugInName Write SetPlugInName;
    Property pifDescription : ShortString Read FPlugInDesc Write SetPlugInDesc;
    Property pifInstallerPath : ShortString Read FPlugInInstaller Write SetPlugInInstaller;
  end;

implementation

{$R *.dfm}

//=========================================================================

Procedure TSinglePlugInFrame.SetPlugInName(Value : ShortString);
Begin // SetPlugInName
  FPlugInName := Trim(Value);
  lblPlugInName.Caption := FPlugInName;
End; // SetPlugInName

//------------------------------

Procedure TSinglePlugInFrame.SetPlugInDesc(Value : ShortString);
Begin // SetPlugInDesc
  FPlugInDesc := Trim(Value);
  lblPlugInDesc.Caption := FPlugInDesc;
  lblPlugInDesc.Width := 605;
  Self.Height := lblPlugInDesc.Top + lblPlugInDesc.Height + 9;
End; // SetPlugInDesc

//------------------------------

Procedure TSinglePlugInFrame.SetPlugInInstaller(Value : ShortString);
Begin // SetPlugInInstaller
  FPlugInInstaller := Trim(Value);
  lblInstallPlugIn.Visible := (FPlugInInstaller <> '');
End; // SetPlugInInstaller

//-------------------------------------------------------------------------

procedure TSinglePlugInFrame.lblInstallPlugInClick(Sender: TObject);
Var
  sPath : ANSIString;
begin
  sPath := ExpandFileName(FPlugInInstaller);
  WinExec(PCHAR(sPath), SW_SHOWNORMAL	);
  lblPlugInInstalled.Visible := True;
end;

//=========================================================================

end.
