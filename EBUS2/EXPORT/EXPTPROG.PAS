unit ExptProg;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ComCtrls, ExtCtrls;

type
  TfrmExportProgress = class(TForm)
    pbrExportProgress: TProgressBar;
    Panel1: TPanel;
    lblProgressMessage: Label8;
    btnCancel: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fTotalRecCount : longint;
    fCurRecCount   : longint;
    procedure SetProgressMessage(Value : string);
    procedure SetCatalogueCode(Value : string);
    procedure SetTotalRecCount(Value : longint);
  public
    property ProgressMsg : string write SetProgressMessage;
    property TotalRecCount : longint read fTotalRecCount write SetTotalRecCount;
    property CatalogueCode : string write SetCatalogueCode;
    procedure IncProgressCounter;
  end;

var
  frmExportProgress: TfrmExportProgress;

implementation

{$R *.DFM}

uses
  DragStk;

//-----------------------------------------------------------------------

procedure TfrmExportProgress.SetProgressMessage(Value : string);
begin
  lblProgressMessage.Caption := Value;
  pbrExportProgress.Position := 0;
end;

//-----------------------------------------------------------------------

procedure TfrmExportProgress.SetCatalogueCode(Value : string);
begin
  Caption := Caption + ' ' + Value;
end;

//-----------------------------------------------------------------------

procedure TfrmExportProgress.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

//-----------------------------------------------------------------------

procedure TfrmExportProgress.btnCancelClick(Sender: TObject);
begin
  CancelExport := true;
  Close;
end;

//-----------------------------------------------------------------------

procedure TfrmExportProgress.FormCreate(Sender: TObject);
begin
  CancelExport := false;
end;

//-----------------------------------------------------------------------

procedure TfrmExportProgress.SetTotalRecCount(Value : longint);
begin
  fTotalRecCount := Value;
end;

//-----------------------------------------------------------------------

procedure TfrmExportProgress.IncProgressCounter;
begin
  inc(fCurRecCount);
  try
    pbrExportProgress.Position := fCurRecCount * 100 div TotalRecCount;
  except
    on EDivByZero do
      pbrExportProgress.Position := 0;
  end;
end;

end.
