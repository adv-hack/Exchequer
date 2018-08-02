unit VwLicnc;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmViewLic = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ListBox1: TListBox;
    btnOpenLicence: TButton;
    OpenDialog1: TOpenDialog;
    procedure btnOpenLicenceClick(Sender: TObject);
  private
    { Private declarations }
    procedure OpenLicence(Const LicPath : ShortString);
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

Uses oLicence, LicGlob;

procedure TfrmViewLic.btnOpenLicenceClick(Sender: TObject);
begin
  OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName);

  If OpenDialog1.Execute Then Begin
    OpenLicence(OpenDialog1.FileName);
  End; { If }
end;

procedure TfrmViewLic.OpenLicence(Const LicPath : ShortString);
Var
  EntLic : TEntLicence;
Begin { OpenLicence }
  EntLic := TEntLicence.Create;
  Try
    With EntLic Do Begin
      FileName := LicPath;

      ListBox1.Clear;
      ListBox1.Items.Add ('Licence:      ' + LicPath);
      ListBox1.Items.Add ('  Version:    ' + IntToStR(Version));
      ListBox1.Items.Add ('  Size:       ' + IntToStR(Size));
      ListBox1.Items.Add ('  Valid:      ' + IntToStr(Ord(Valid)));
      ListBox1.Items.Add ('');
      ListBox1.Items.Add ('  Check1:     ' + IntToStr(Check1));
      ListBox1.Items.Add ('  Check2:     ' + IntToStr(Check2));
      ListBox1.Items.Add ('');
      ListBox1.Items.Add ('  posBinary:  ' + IntToStr(posBinary));
      ListBox1.Items.Add ('  posData:    ' + IntToStr(posData));
      ListBox1.Items.Add ('');
      ListBox1.Items.Add ('  CD Sno:     ' + CDSerial);
      ListBox1.Items.Add ('');
      ListBox1.Items.Add ('  Country:    ' + licCountryStr (Country, False) + ' ' + licTypeToStr (InstType));
      ListBox1.Items.Add ('  ');
      ListBox1.Items.Add ('  CcyVer:     ' + licCurrVerToStr (CurrVer));
      ListBox1.Items.Add ('  Modules:    ' + licEntModsToStr(BaseModules));
      ListBox1.Items.Add ('  Users:      ' + IntToStr(Users));
      ListBox1.Items.Add ('  ');
      ListBox1.Items.Add ('  Cl-Server:  ' + IntToStr(ClSvr));
      ListBox1.Items.Add ('  ClSvr Eng:  ' + IntToStr(ClSvrEng));
      ListBox1.Items.Add ('  ClSvr User: ' + IntToStr(ClSvrUser));
      ListBox1.Items.Add ('  ');
      ListBox1.Items.Add ('  Account Stock Analysis: ' + licEntModRelToStr (Modules[modAccStk]));
      ListBox1.Items.Add ('  Import Module:          ' + licEntModRelToStr (Modules[modImpMod]));
      ListBox1.Items.Add ('  Job Costing:            ' + licEntModRelToStr (Modules[modJobCost]));
      ListBox1.Items.Add ('  ODBC:                   ' + licEntModRelToStr (Modules[modODBC]));
      ListBox1.Items.Add ('  Report Writer:          ' + licEntModRelToStr (Modules[modRepWrt]));
      ListBox1.Items.Add ('  Telesales:              ' + licEntModRelToStr (Modules[modTeleSale]));
      ListBox1.Items.Add ('  Toolkit DLL:            ' + licEntModRelToStr (Modules[modToolDLL]));
    End; { With }
  Finally
    EntLic.Destroy;
  End;
End; { OpenLicence }

end.
