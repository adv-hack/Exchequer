unit PreviewF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ToolWin, ImgList, RavePrev,
  EnterpriseForms_TLB, AdvGlowButton, AdvToolBar, AdvToolBarStylers;

type
  TfrmFTKPreview = class(TForm)
    sbPages: TScrollBar;
    RavePreview1: TRavePreview;
    AdvToolBarStyler: TAdvToolBarOfficeStyler;
    AdvDockPanel: TAdvDockPanel;
    AdvToolBar: TAdvToolBar;
    AdvToolBarSeparator1: TAdvToolBarSeparator;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    AdvToolBarSeparator3: TAdvToolBarSeparator;
    AdvToolBarSeparator4: TAdvToolBarSeparator;
    AdvGlowButton1: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    AdvGlowButton3: TAdvGlowButton;
    spbtnPrevPage: TAdvGlowButton;
    spbtnNextPage: TAdvGlowButton;
    spbtnPrint: TAdvGlowButton;
    Button_Close: TAdvGlowButton;
    panPageStatus: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Button_Close_Click(Sender: TObject);
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
    procedure spbtnPrint_Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FTmpFile : IEFPrintTempFile;

    function GetiTmpFile: IEFPrintTempFile;
    procedure SetiTmpFile(const Value: IEFPrintTempFile);
    procedure SetPreviewFile(const Value: ShortString);
    function GetPreviewFile: ShortString;
  public
    { Public declarations }
    Property iTmpFile : IEFPrintTempFile Read GetiTmpFile Write SetiTmpFile;
    Property PreviewFile : ShortString Read GetPreviewFile Write SetPreviewFile;
  end;

var
  frmFTKPreview: TfrmFTKPreview;

implementation

{$R *.dfm}

Uses PageDlg, GlobType;

//-----------------------------------------------------------------------------

procedure TfrmFTKPreview.FormCreate(Sender: TObject);
begin
  FTmpFile := NIL;
  RavePreview1.ZoomInc := 25;
end;

//--------------------------------------

procedure TfrmFTKPreview.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RavePreview1.Active := False;
  FTmpFile := NIL;   // duplicated in Destroy just in case...
end;

//------------------------------

procedure TfrmFTKPreview.FormDestroy(Sender: TObject);
begin
  FTmpFile := NIL;   // duplicated in Close just in case...
end;

//-----------------------------------------------------------------------------

function TfrmFTKPreview.GetPreviewFile: ShortString;
begin
  Result := RavePreview1.Filename;
end;

procedure TfrmFTKPreview.SetPreviewFile(const Value: ShortString);
begin
  RavePreview1.Filename := Value;
end;

//-----------------------------------------------------------------------------

procedure TfrmFTKPreview.SpeedButton1Click(Sender: TObject);
begin
  RavePreview1.ZoomIn;
end;

procedure TfrmFTKPreview.SpeedButton2Click(Sender: TObject);
begin
  RavePreview1.ZoomOut;
end;

procedure TfrmFTKPreview.SpeedButton3Click(Sender: TObject);
begin
  RavePreview1.Zoom := RavePreview1.ZoomPage;
end;

procedure TfrmFTKPreview.spbtnPrevPageClick(Sender: TObject);
begin
  RavePreview1.PreviousPage;

  // Update Pages scroll-bar so it doesn't get out of sync with the buttons
  If sbPages.Enabled Then sbPages.Position := RavePreview1.CurrentPage;
end;

procedure TfrmFTKPreview.spbtnNextPageClick(Sender: TObject);
begin
  RavePreview1.NextPage;

  // Update Pages scroll-bar so it doesn't get out of sync with the buttons
  If sbPages.Enabled Then sbPages.Position := RavePreview1.CurrentPage;
end;

procedure TfrmFTKPreview.spbtnPrint_Click(Sender: TObject);
Var
  Res  : Integer;
  Cont : Boolean;
begin
  // Stop Preview whilst printing to avoid problems
  RavePreview1.Active := False;

  Cont := True;
  If (FTmpFile.pfType = tfdPrinter) Then
   // For jobs going to print ask for the page range
   With TPageSetupDlg.Create(Self) Do
     Try
       Copies := FTmpFile.pfCopies;
       NoPages := FTmpFile.pfPages;
       CurrPage := RavePreview1.CurrentPage;

       If Execute Then Begin
        FTmpFile.pfStartPage := FPage;
        FTmpFile.pfFinishPage := LPage;
        FTmpFile.pfCopies := Copies;
       End { If Execute }
       Else
         Cont := False;
     Finally
       Free;
     End;

  If Cont Then Begin
    // Send the print job to its destination (printer/email/fax)
    Res := FTmpFile.SendToDestination;
    If (Res <> 0) Then
      MessageDlg ('The following error occurred whilst printing the Print Job:'#13#13+
                  IntToStr(Res) + ': ' + LastErDesc, mtInformation, [mbOk], 0);
  End; { If Cont }

  // Restart Preview
  RavePreview1.Active := True;
end;

procedure TfrmFTKPreview.Button_Close_Click(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------------

procedure TfrmFTKPreview.RavePreview1PageChanged(Sender: TObject);
begin
  panPageStatus.Caption := Format('Page %d of %d', [RavePreview1.CurrentPage, RavePreview1.Pages]);

  // Setup Toolbar Buttons
  spbtnPrevPage.Enabled := (RavePreview1.CurrentPage > 1);
  spbtnNextPage.Enabled := (RavePreview1.CurrentPage < RavePreview1.Pages);
end;

procedure TfrmFTKPreview.RavePreview1PreviewActivated(Sender: TObject);
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

procedure TfrmFTKPreview.RavePreview1PreviewStopped(Sender: TObject);
begin
  //
end;

procedure TfrmFTKPreview.sbPagesScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  RavePreview1.CurrentPage := ScrollPos;
end;

procedure TfrmFTKPreview.FormActivate(Sender: TObject);
begin
  RavePreview1.Active := True;
end;

//-------------------------------------------------------------------------

function TfrmFTKPreview.GetiTmpFile: IEFPrintTempFile;
begin
  Result := FTmpFile;
end;

procedure TfrmFTKPreview.SetiTmpFile(const Value: IEFPrintTempFile);
begin
  FTmpFile := Value;
end;

//=========================================================================

end.
