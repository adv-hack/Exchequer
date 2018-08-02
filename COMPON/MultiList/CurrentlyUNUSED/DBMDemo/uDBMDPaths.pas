unit uDBMDPaths;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TfrmPaths = class(TForm)
    lblCustomers: TLabel;
    lblSuppliers: TLabel;
    lblJobs: TLabel;
    lblMisc: TLabel;
    bnCancel: TButton;
    bnOK: TButton;
    edCustomers: TEdit;
    edSuppliers: TEdit;
    edJobs: TEdit;
    edMisc: TEdit;
    sbCustomers: TSpeedButton;
    sbSuppliers: TSpeedButton;
    sbJobs: TSpeedButton;
    sbMisc: TSpeedButton;
    OpenDialog: TOpenDialog;
    procedure sbCustomersClick(Sender: TObject);
    procedure sbSuppliersClick(Sender: TObject);
    procedure sbJobsClick(Sender: TObject);
    procedure sbMiscClick(Sender: TObject);
  end;

var
  frmPaths: TfrmPaths;

implementation

{$R *.dfm}

//*** File Browsing ************************************************************

procedure TfrmPaths.sbCustomersClick(Sender: TObject);
begin
  with OpenDialog do
  begin
    InitialDir:= ExtractFilePath(ParamStr(0));
    if Execute then edCustomers.Text:= FileName;
  end;
end;

procedure TfrmPaths.sbSuppliersClick(Sender: TObject);
begin
  with OpenDialog do
  begin
    InitialDir:= ExtractFilePath(ParamStr(0));
    if Execute then edSuppliers.Text:= FileName;
  end;
end;

procedure TfrmPaths.sbJobsClick(Sender: TObject);
begin
  with OpenDialog do
  begin
    InitialDir:= ExtractFilePath(ParamStr(0));
    if Execute then edJobs.Text:= FileName;
  end;
end;

procedure TfrmPaths.sbMiscClick(Sender: TObject);
begin
  with OpenDialog do
  begin
    InitialDir:= ExtractFilePath(ParamStr(0));
    if Execute then edMisc.Text:= FileName;
  end;
end;

//******************************************************************************

end.
