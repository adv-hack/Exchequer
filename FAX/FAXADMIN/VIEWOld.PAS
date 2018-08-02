unit VIEWOld;

{ nfrewer440 10:19 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  WinTypes,
  WinProcs,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Menus,
  ExtCtrls,
  Buttons,
  StdCtrls,
  ooMisc,                                                        {!!.11}
  AdFView,
  AdFaxPrn,
  AdFPStat,
  FaxClass, ComCtrls, ToolWin, ImgList, ActnList;

type
  TfrmViewOldFax = class(TForm)
    CoolBar2: TCoolBar;
    ToolBar: TToolBar;
    tbZoomIn: TToolButton;
    tbZoomOut: TToolButton;
    ToolButton3: TToolButton;
    tbPrevPage: TToolButton;
    tbNextPage: TToolButton;
    tbPrinterSetup: TToolButton;
    ToolButton1: TToolButton;
    tbPrint: TToolButton;
    tbRotate: TToolButton;
    ToolButton5: TToolButton;
    mnuRotate: TPopupMenu;
    Rotate1: TMenuItem;
    N90Degrees1: TMenuItem;
    N180Degrees1: TMenuItem;
    N270Degrees1: TMenuItem;
    Panel1: TPanel;
    ilToolbar16Col: TImageList;
    ActionList1: TActionList;
    Zoom1: TAction;
    StatusBar: TStatusBar;
    ilToolbar24Bit: TImageList;
    ilToolbar24BitHot: TImageList;
    ilToolbar24BitDis: TImageList;
    procedure ExitItemClick(Sender: TObject);
    procedure SelectAllItemClick(Sender: TObject);
    procedure CopyItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FaxViewerPageChange(Sender: TObject);
    procedure FaxViewerViewerError(Sender: TObject; ErrorCode: Integer);
    procedure CloseItemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tbPrevPageClick(Sender: TObject);
    procedure tbNextPageClick(Sender: TObject);
    procedure tbPrinterSetupClick(Sender: TObject);
    procedure tbPrintClick(Sender: TObject);
    procedure Rotate1Click(Sender: TObject);
    procedure tbCloseClick(Sender: TObject);
    procedure Zoom1Execute(Sender: TObject);
    procedure FaxViewerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
  private
    bHiRes, bHiWidth, bLenWords : boolean;
    FaxPrinter: TApdFaxPrinter;
    FaxViewer: TApdFaxViewer;
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
  public
    ViewPercent : Integer;
    procedure UpdateViewPercent(const NewPercent : Integer);
    procedure OpenFile(const FileName : string);  {!!.10}
    procedure CloseFile; {!!.10}
  end;

var
  frmViewOldFax: TfrmViewOldFax;

implementation
uses
 GlobVar, GfxUtil;

{$R *.DFM}

procedure TfrmViewOldFax.CloseFile;
begin
end;

procedure TfrmViewOldFax.OpenFile(const FileName : string);
begin
  FaxViewer.BeginUpdate;
  FaxViewer.Scaling   := False;
  FaxViewer.HorizMult := 1;
  FaxViewer.HorizDiv  := 1;
  FaxViewer.VertMult  := 1;
  FaxViewer.VertDiv   := 1;
  FaxViewer.EndUpdate;
  try
    FaxViewer.FileName := FileName;
    UpdateViewPercent(40);               {!!.01}
    StatusBar.Panels[0].Text := Format(' Page 1 of %d', [FaxViewer.NumPages]);
    Caption := 'View Fax : ' + sDocName;
    tbPrevPage.Enabled := (FaxViewer.NumPages > 1) and (FaxViewer.ActivePage <> 1);
    tbNextPage.Enabled := (FaxViewer.NumPages > 1) and (FaxViewer.ActivePage <> FaxViewer.NumPages);
  except
    CloseFile;
    MessageDlg('Error opening fax file '+FileName, mtError, [mbOK], 0);
  end;
end;

procedure TfrmViewOldFax.CloseItemClick(Sender: TObject);
begin
  CloseFile;
end;

procedure TfrmViewOldFax.ExitItemClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmViewOldFax.SelectAllItemClick(Sender: TObject);
begin
  FaxViewer.SelectImage;
end;

procedure TfrmViewOldFax.CopyItemClick(Sender: TObject);
begin
  FaxViewer.CopyToClipBoard;
end;

procedure TfrmViewOldFax.FormCreate(Sender: TObject);
begin
{  tbPrinterSetup.Visible := False;
  tbPrint.Left := tbPrint.Left - 29;}
  FaxPrinter := TApdFaxPrinter.Create(Self);
  FaxViewer := TApdFaxViewer.Create(Self);
  FaxViewer.Parent := Panel1;
  FaxViewer.Align := alClient;
  if ColorMode(Canvas) in [cm256Colors, cm16Colors, cmMonochrome] then
    begin
      ToolBar.Images := ilToolbar16Col;
      ToolBar.HotImages := nil;
      ToolBar.DisabledImages := nil;
      ilToolbar24Bit.Free;
      ilToolbar24BitHot.Free;
      ilToolbar24BitDis.Free;
    end
  else begin
    ToolBar.Images := ilToolbar24Bit;
    ToolBar.HotImages := ilToolbar24BitHot;
    ToolBar.DisabledImages := ilToolbar24BitDis;
    ilToolbar16Col.Free;
  end;{if}

  FaxViewer.Cursor := 22;
end;

procedure TfrmViewOldFax.UpdateViewPercent(const NewPercent : Integer);
begin
  if (NewPercent = ViewPercent) then
    Exit;

  ViewPercent := NewPercent;

  if (NewPercent = 100) then
    FaxViewer.Scaling := False
  else begin
    FaxViewer.BeginUpdate;
    FaxViewer.Scaling   := True;
    FaxViewer.HorizMult := NewPercent;
    FaxViewer.HorizDiv  := 100;
    FaxViewer.VertMult  := NewPercent;
    FaxViewer.VertDiv   := 100;
    FaxViewer.EndUpdate;
  end;
end;

procedure TfrmViewOldFax.FaxViewerPageChange(Sender: TObject);
var
  W : Word;
begin
  if (FaxViewer.FileName <> '') then
    begin
      StatusBar.Panels[0].Text := Format(' Page %d of %d', [FaxViewer.ActivePage
      ,FaxViewer.NumPages]);
      W := FaxViewer.PageFlags;
      bHiRes := W and ffHighRes <> 0;
      bHiWidth := W and ffHighWidth <> 0;
      bLenWords := W and ffLengthWords <> 0;
      tbPrevPage.Enabled := FaxViewer.ActivePage <> 1;
      tbNextPage.Enabled := FaxViewer.ActivePage <> FaxViewer.NumPages;
    end
  else
    begin
      StatusBar.Panels[0].Text := '  No file loaded';
    end;
end;

procedure TfrmViewOldFax.FaxViewerViewerError(Sender: TObject;
  ErrorCode: Integer);
begin
  MessageDlg(Format('Viewer error %d', [ErrorCode]), mtError, [mbOK], 0);
end;

procedure TfrmViewOldFax.FormShow(Sender: TObject);
begin
  OpenFile(sFileName);
end;

procedure TfrmViewOldFax.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfrmViewOldFax.tbPrevPageClick(Sender: TObject);
begin
  if FaxViewer.ActivePage > 1 then begin
    Screen.Cursor := crHourglass;
    FaxViewer.ActivePage := FaxViewer.ActivePage - 1;
    Screen.Cursor := crDefault;
  end;{if}
end;

procedure TfrmViewOldFax.tbNextPageClick(Sender: TObject);
begin
  if FaxViewer.ActivePage < FaxViewer.NumPages then begin
    Screen.Cursor := crHourglass;
    FaxViewer.ActivePage := FaxViewer.ActivePage + 1;
    Screen.Cursor := crDefault;
  end;{if}
end;

procedure TfrmViewOldFax.tbPrinterSetupClick(Sender: TObject);
begin
  FaxPrinter.PrintSetup;
end;

procedure TfrmViewOldFax.tbPrintClick(Sender: TObject);
begin
  if (FaxViewer.FileName <> '') then begin
    FaxPrinter.FileName := FaxViewer.FileName;
    FaxPrinter.PrintFax;
  end;
end;

procedure TfrmViewOldFax.Rotate1Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  FaxViewer.Rotation := TViewerRotation(TMenuItem(Sender).Tag);
  TMenuItem(Sender).Checked := True;
  Screen.Cursor := crDefault;
end;

procedure TfrmViewOldFax.tbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmViewOldFax.Zoom1Execute(Sender: TObject);
var
  iPercent : Integer;
  iMode : ShortInt;
begin
  {Toolbutton Click}
  if TToolbutton(Sender).Name = 'tbZoomIn' then iMode := 1
  else iMode := -1;

  if ((ViewPercent mod 10) = 0) then iPercent := ViewPercent + (10 * iMode)
  else iPercent := ViewPercent + ((10 - (ViewPercent mod 10)) * iMode);

  if ((iPercent < 20) and (iMode = -1))
  or ((iPercent > 300) and (iMode = 1))then begin
    MessageBeep(0);
    Exit;
  end;{if}
  UpdateViewPercent(iPercent);
end;

procedure TfrmViewOldFax.FaxViewerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then Zoom1Execute(tbZoomIn)
  else Zoom1Execute(tbZoomOut);
end;

procedure TfrmViewOldFax.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 200;
    ptMinTrackSize.Y := 150;
  end;{with}
  Message.Result := 0;
  inherited;
end;

procedure TfrmViewOldFax.FormDestroy(Sender: TObject);
begin
  FaxViewer.Free;
  FaxPrinter.Free;
end;

end.
