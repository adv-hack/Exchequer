unit PreviewF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Enterprise01_TLB, OleCtrls, entPrevX_TLB;

type
  TfrmPreview = class(TForm)
    btnZoomIn: TButton;
    btnZoomOut: TButton;
    btnZoomPage: TButton;
    btnPreviousPage: TButton;
    btnNextPage: TButton;
    btnClose: TButton;
    entPreviewX1: TentPreviewX;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnZoomInClick(Sender: TObject);
    procedure btnZoomOutClick(Sender: TObject);
    procedure btnZoomPageClick(Sender: TObject);
    procedure btnPreviousPageClick(Sender: TObject);
    procedure btnNextPageClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    lTempPrintFile : IPrintTempFile;
  public
    { Public declarations }
    Procedure SetTempPrint(Const TempPrintFile : IPrintTempFile);
  end;

var
  frmPreview: TfrmPreview;

implementation

{$R *.DFM}

Procedure TfrmPreview.SetTempPrint(Const TempPrintFile : IPrintTempFile);
Begin // SetTempPrint
  // Make a local copy of the reference so we can use it later, and
  // preventing it being destroyed until the Preview Window is closed
  lTempPrintFile := TempPrintFile;

  With entPreviewX1 Do Begin
    FileName := lTempPrintFile.pfFileName;
    Active := True;
  End; // With entPreviewX1
End; // SetTempPrint

procedure TfrmPreview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Close the preview session
  entPreviewX1.Active := False;

  // Remove reference to object allowing it to be destroyed correctly
  lTempPrintFile := NIL;
end;

procedure TfrmPreview.btnZoomInClick(Sender: TObject);
begin
  entPreviewX1.ZoomIn;
end;

procedure TfrmPreview.btnZoomOutClick(Sender: TObject);
begin
  entPreviewX1.ZoomOut;
end;

procedure TfrmPreview.btnZoomPageClick(Sender: TObject);
begin
  entPreviewX1.Zoom := entPreviewX1.ZoomPage;
end;

procedure TfrmPreview.btnPreviousPageClick(Sender: TObject);
begin
  entPreviewX1.PreviousPage;
end;

procedure TfrmPreview.btnNextPageClick(Sender: TObject);
begin
  entPreviewX1.NextPage;
end;

procedure TfrmPreview.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
