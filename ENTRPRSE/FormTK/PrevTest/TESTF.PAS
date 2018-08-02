unit TestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ToolWin, ImgList, RavePrev,
  PrevComp, RPDefine, RPBase, RPCanvas, RPFPrint, RPreview;

type
  TForm1 = class(TForm)
    ilTBar24Bit: TImageList;
    ilTBar16Col: TImageList;
    ilTBar24BitHot: TImageList;
    ilTBar24BitDis: TImageList;
    CoolBar1: TCoolBar;
    ToolBar: TToolBar;
    SpeedButton1: TToolButton;
    SpeedButton2: TToolButton;
    SpeedButton3: TToolButton;
    ToolButton4: TToolButton;
    spbtnPrevPage: TToolButton;
    spbtnNextPage: TToolButton;
    ToolButton5: TToolButton;
    spbtnPrint: TToolButton;
    ToolButton2: TToolButton;
    Button_Close: TToolButton;
    ToolButton1: TToolButton;
    Panel2: TPanel;
    panPageStatus: TPanel;
    sbPages: TScrollBar;
    RavePreview1: TRavePreview;
    FilePreview1: TFilePreview;
    procedure FormCreate(Sender: TObject);
    procedure Button_CloseClick(Sender: TObject);
    procedure RavePreview1PageChanged(Sender: TObject);
    procedure RavePreview1PreviewActivated(Sender: TObject);
    procedure RavePreview1PreviewStopped(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sbPagesScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure spbtnPrevPageClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure spbtnNextPageClick(Sender: TObject);
    procedure spbtnPrintClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//-----------------------------------------------------------------------------

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Setup the preview component
  With RavePreview1 Do Begin
    FileName := 'M:\Preview.Edf';
    Active := True;
  End; { With RavePreview1 }
end;

//--------------------------------------

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RavePreview1.Active := False;
end;

//-----------------------------------------------------------------------------

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  RavePreview1.ZoomIn;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  RavePreview1.ZoomOut;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  RavePreview1.Zoom := RavePreview1.ZoomPage;
end;

procedure TForm1.spbtnPrevPageClick(Sender: TObject);
begin
  RavePreview1.PreviousPage;

  // Update Pages scroll-bar so it doesn't get out of sync with the buttons
  If sbPages.Enabled Then sbPages.Position := RavePreview1.CurrentPage;
end;

procedure TForm1.spbtnNextPageClick(Sender: TObject);
begin
  RavePreview1.NextPage;

  // Update Pages scroll-bar so it doesn't get out of sync with the buttons
  If sbPages.Enabled Then sbPages.Position := RavePreview1.CurrentPage;
end;

procedure TForm1.spbtnPrintClick(Sender: TObject);
begin
  ShowMessage ('Print not coded');
end;

procedure TForm1.Button_CloseClick(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------------

procedure TForm1.RavePreview1PageChanged(Sender: TObject);
begin
  panPageStatus.Caption := Format('Page %d of %d', [RavePreview1.CurrentPage, RavePreview1.Pages]);

  // Setup Toolbar Buttons
  spbtnPrevPage.Enabled := (RavePreview1.CurrentPage > 1);
  spbtnNextPage.Enabled := (RavePreview1.CurrentPage < RavePreview1.Pages);
end;

procedure TForm1.RavePreview1PreviewActivated(Sender: TObject);
Var
  LargeChange : Integer;
begin
  // Setup Pages Scroll-Bar
  sbPages.Enabled := (RavePreview1.Pages > 1);
  If sbPages.Enabled Then Begin
    // Set starting position, min value and max value
    sbPages.SetParams (1, 1, RavePreview1.Pages);

    // Setup the scroll-bars large change as 10% of the pages with a 1 page minimum
    LargeChange := Round(RavePreview1.Pages * 0.1);
    If (LargeChange < 1) Then LargeChange := 1;
    sbPages.LargeChange := LargeChange;
  End; { If sbPages.Enabled }
end;

procedure TForm1.RavePreview1PreviewStopped(Sender: TObject);
begin
  //
end;

procedure TForm1.sbPagesScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  RavePreview1.CurrentPage := ScrollPos;
end;

end.
