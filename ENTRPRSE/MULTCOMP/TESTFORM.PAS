unit testform;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Button1: TButton;
    Label1: TLabel;
    SysPath: TEdit;
    OCXOnly: TCheckBox;
    MultiUserBtr: TCheckBox;
    ClServer: TCheckBox;
    Button2: TButton;
    GroupBox3: TGroupBox;
    Button3: TButton;
    Label2: TLabel;
    ExeDir: TEdit;
    Label3: TLabel;
    DataDir: TEdit;
    Label4: TLabel;
    TypeList: TComboBox;
    GroupBox7: TGroupBox;
    Button7: TButton;
    Label5: TLabel;
    ExeDir2: TEdit;
    GroupBox4: TGroupBox;
    Button4: TButton;
    Label6: TLabel;
    Label7: TLabel;
    ExeDir3: TComboBox;
    DataDir3: TComboBox;
    GroupBox5: TGroupBox;
    Button5: TButton;
    Label8: TLabel;
    ExeDir4: TComboBox;
    Connect: TCheckBox;
    GroupBox6: TGroupBox;
    Label9: TLabel;
    Button6: TButton;
    ExeDir7: TComboBox;
    GroupBox8: TGroupBox;
    Label10: TLabel;
    Button8: TButton;
    ExeDir5: TComboBox;
    Label11: TLabel;
    InstDir: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses GlobVar, VarConst, EntInitU, EntRegU, CompUtil, EntReplU,
     EntDataU, CompList, EntOdbcU;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ClientWidth := 518;
  ClientHeight := 428;

  TypeList.ItemIndex := 5;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  DllStatus := 0;

  SystemDir := SysPath.Text;

  RegisterSystem(MultiUserBtr.Checked, OCXOnly.Checked, Connect.Checked);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  DllStatus := 0;

  SetClServer(ClServer.Checked);
end;

procedure TForm1.Button3Click(Sender: TObject);
Var
  InitComp, InitSec, IsDemo, MainSec, IsUpdate : Boolean;
begin
  DllStatus := 0;

  If (TypeList.ItemIndex In [0, 1, 2, 3, 5, 7]) Then Begin
    { Re-Initialise the security if installing or adding a new company }
    InitSec := (TypeList.ItemIndex In [0, 1, 5, 7]);

    { Copy security from main system if adding a new company }
    MainSec := (TypeList.ItemIndex In [5, 7]);

    { Initialise the Company data if installing blank data, or new blank company }
    InitComp := (TypeList.ItemIndex In [1, 5]);

    { If its a demo they cannot be allowed to change the company name }
    IsDemo := (TypeList.ItemIndex = 0);

    { Don't display company dialog if its an update and company entry already exists }
    IsUpdate := (TypeList.ItemIndex In [2, 3]);

    InitCompany (ExeDir.Text, DataDir.Text, InstDir.Text, InitSec, MainSec, InitComp, IsDemo, IsUpdate);

    If (DllStatus <> 0) Then ShowMessage ('InitCompany: Error');
  End { If }
  Else
    ShowMessage ('No action required for this installation type');
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  SystemDir := ExeDir2.Text;

  ProcessReplication;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  CopyCompanyData (ExeDir3.Text, DataDir3.Text);
  ShowMessage ('CopyCompanyData: ' + IntToStr(DllStatus));
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  { need to open data files }
  SetDrive := ExeDir4.Text;

  { Open data files }
  Open_System(MiscF, MiscF);
  Open_System(CompF, CompF);

  LoadCompanyOpt;

  CompListMode := 3;
  Form_CompanyList := TForm_CompanyList.Create(Application);
  Try
    Form_CompanyList.CmdParam := '';
    Form_CompanyList.SplashHandle := 0;
    Form_CompanyList.ShowModal;
  Finally
    Form_CompanyList.Free;
  End;

end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  ModRexBat(ExeDir7.Text);
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  CheckForSources(ExeDir5.Text);
end;

end.
