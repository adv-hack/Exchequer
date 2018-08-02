unit setupts2;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    GroupBox2: TGroupBox;
    Button2: TButton;
    Label1: TLabel;
    SpaceDir: TComboBox;
    DirType: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    DefDir: TComboBox;
    CB_MC: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses SetupDir, DiskU;

procedure TForm1.Button1Click(Sender: TObject);
var
  DirectoryDialog : TDirectoryDialog;
  DlgPN           : ShortString;
begin
  DirectoryDialog := TDirectoryDialog.Create(Application);
  Try
    With DirectoryDialog Do Begin
      DlgPN := DefDir.Text;

      If CB_MC.Checked Then CurrMode := 'M' Else CurrMode := 'S';
      ValidMode := DirType.Text[1];
      Case ValidMode Of
        'A' : Begin { Install Connectivity Kit }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory containing your Exchequer or Exchequer Enterprise system files:';
                Title := 'Main Company';
              End;
        'B' : Begin { Upgrade Connectivity Kit }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the Connectivity Kit directory you want to upgrade:';
                Title := 'Upgrade Connectivity Kit';
              End;
        'C' : Begin { Install New Company - System }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory containing your Exchequer Enterprise system ' +
                                'files or click the &Find button to search for the directory:';
                Title := 'Main Company';

                WantFindEnt := 1;
              End; { C }
        'c',
        'k' : Begin { Install New Company - Data }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory you want to install the new company data files into:';
                Title := 'New Company';
              End; { c }
        'I' : Begin { Install Enterprise }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory where you want to install Exchequer Enterprise:';
                Title := 'Install Enterprise';
              End; { I }
        'K' : Begin { Connectivity Kit - Install New Company - System }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory containing your Exchequer system files:';
                Title := 'Main Company';
              End; { K }
        'N' : Begin { Networked Enterprise directory }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory containing your Networked Enterprise system ' +
                                'or click the &Find button to search for the directory:';
                Title := 'Network Enterprise';

                WantFindEnt := 1;
              End; { N }
        'n' : Begin { Local Enterprise dir for program files on workstation }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the Local directory where you want the Exchequer Enterprise ' +
                                'Program Files to be installed:';
                Title := 'Local Enterprise';
              End; { n }
        'R' : Begin { Register }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory containing your Exchequer Enterprise system ' +
                                'files or click the &Find button to search your computer for the directory:';
                Title := 'Register Enterprise';

                WantFindEnt := 1;
              End; { R }
        'r' : Begin { Register Connectivity Kit }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory containing the Connectivity Kit ' +
                                'you want to register:';
                Title := 'Register Connectivity Kit';
              End; { R }
        'T' : Begin { Toolkit DLL }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory you want to install the Toolkit DLL into:';
                Title := 'Toolkit DLL';
              End; { U }
        'U' : Begin { Upgrade from Exchequer }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory containing the Exchequer system to be ' +
                                'upgraded to Exchequer Enterprise or click the &Find button to search ' +
                                'for the directory:';
                Title := 'Upgrade Exchequer';

                WantFindEnt := 2;
              End; { U }
        'u' : Begin { Upgrade Enterprise }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the Exchequer Enterprise directory you want to upgrade ' +
                                'or click the &Find button to search for the directory:';
                Title := 'Upgrade Enterprise';

                WantFindEnt := 1;
              End; { u }
        'W' : Begin { Workstation }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory containing the Exchequer Enterprise system ' +
                                'you want to setup on this computer or click the &Find button to search ' +
                                'for the directory:';
                Title := 'Workstation Setup';

                WantFindEnt := 1;
              End; { W }
        'w' : Begin { Workstation - Connectivity Kit }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory containing the Connectivity Kit you want ' +
                                'to setup on this machine:';
                Title := 'Workstation Setup';
              End; { W }
        'X' : Begin { Crystal Reports directory }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory containing your copy of Crystal Reports:';
                Title := 'Crystal Reports';
              End;
        'Z' : Begin { Install Toolkit DLL }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory you want to install the Toolkit DLL into:';
                Title := 'Toolkit DLL';
              End; { U }
        'z' : Begin { Upgrade Toolkit DLL }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory containing the Toolkit DLL:';
                Title := 'Upgrade Toolkit DLL';
              End; { U }
        'Y' : Begin { Configure Toolkit DLL }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory containing the Toolkit DLL:';
                Title := 'Configure Toolkit DLL';
              End; { U }
        'V' : Begin { Compass - Enterprise Directory }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory containing the Enterprise System:';
                Title := 'Enterprise Directory';
                Caption := 'Exchequer Enterprise Compass Installation';
              End; { U }
        'v' : Begin { Customisation - Enterprise Directory }
                HelpContextID := 10005;
                InstallPath := DlgPN;
                Instructions := 'Please specify the directory containing the Enterprise System:';
                Title := 'Enterprise Directory';
                Caption := 'Exchequer Enterprise Customisation Setup';
              End; { U }
      End; { Case }

      ShowModal;

      ShowMessage ('Install To ''' + InstallPath + '''');
    End; { With }
  Finally
    DirectoryDialog.Free;
  End;
end;

procedure TForm1.Button2Click(Sender: TObject);
Var
  fDriveNo : SmallInt;
begin
  fDriveNo:=Ord(UPCase(SpaceDir.Text[1]))-64;

  ShowMessage ('Drive: ' + IntToStr(fDriveNo) + #10#13 +
               'Total: ' + FloatToStr(sbsDiskSize(fDriveNo)) + #10#13 +
               'Free: ' + FloatToStr(sbsDiskFree(fDriveNo)));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DirType.ItemIndex := 0;
end;

end.
