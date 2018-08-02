unit uDBMDemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uMultiList, uDBMultiList, Spin, Menus, Buttons,
  StdCtrls, Inifiles;

type
  TfrmDBMDemo = class(TForm)
    pnlMDI: TPanel;
    lblDatabase: TLabel;
    cbFiletype: TComboBox;
    sbNewSession: TSpeedButton;
    menuMain: TMainMenu;
    procedure sbNewSessionClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Paths1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Cascade1Click(Sender: TObject);
    procedure ileHorizontal1Click(Sender: TObject);
    procedure ileVertical1Click(Sender: TObject);
  private
    fPathsIni: TInifile;
  end;

var
  frmDBMDemo: TfrmDBMDemo;

implementation

uses uBtrieveDataset, uDBMDChild, uDBMDPaths;

{$R *.dfm}

//*** Startup and Shutdown *****************************************************

procedure TfrmDBMDemo.FormCreate(Sender: TObject);
begin
  fPathsIni:= TInifile.Create(ChangeFileExt(ParamStr(0), '.ini'));
end;

procedure TfrmDBMDemo.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmDBMDemo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fPathsIni.Free;
end;

//******************************************************************************

procedure TfrmDBMDemo.sbNewSessionClick(Sender: TObject);
begin
  with TfrmDBMChild.Create(Self), TBtrieveDataset(DBM.Dataset) do
  begin
    TableType:= TTableType(cbFileType.ItemIndex);

    FileName:= fPathsIni.ReadString(Trim(cbFileType.Text), 'FilePath', '');
    SearchIndex:= fPathsIni.ReadInteger(Trim(cbFileType.Text), 'SearchIndex', 0);
    SearchKey:= fPathsIni.ReadString(Trim(cbFileType.Text), 'SearchKey', '');

    case TableType of
      ttCustomers: AddColumns(4);
      ttDetails: AddColumns(7);
    end;
  end;
end;

procedure TfrmDBMDemo.Paths1Click(Sender: TObject);
begin
  with fPathsIni, TfrmPaths.Create(Self) do
  try

    edCustomers.Text:= ReadString('Customers', 'FilePath', 'C:\Entrprse\Cust\CustSupp.dat');
    edSuppliers.Text:= ReadString('Suppliers', 'FilePath', 'C:\Entrprse\Cust\CustSupp.dat');
    edJobs.Text:= ReadString('Jobs', 'FilePath', 'C:\Entrprse\Jobs\Jobs.dat');
    edMisc.Text:= ReadString('Misc', 'FilePath', 'C:\Entrprse\Misc\Misc.dat');

    if ShowModal = mrOK then
    begin
      WriteString('Customers', 'FilePath', Trim(edCustomers.Text));
      WriteString('Suppliers', 'FilePath', Trim(edSuppliers.Text));
      WriteString('Jobs', 'FilePath', Trim(edJobs.Text));
      WriteString('Misc', 'FilePath', Trim(edMisc.Text));
    end;

  finally
    Free;
  end;
end;

procedure TfrmDBMDemo.Cascade1Click(Sender: TObject);
begin
  Cascade;
end;

procedure TfrmDBMDemo.ileHorizontal1Click(Sender: TObject);
begin
  TileMode:= tbHorizontal;
  Tile;
end;

procedure TfrmDBMDemo.ileVertical1Click(Sender: TObject);
begin
  TileMode:= tbVertical;
  Tile;
end;

end.
