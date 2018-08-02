unit ViewMain;

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
  FaxClass, ComCtrls, ToolWin, ImgList, ActnList, OleCtrls, SCRIBBLELib_TLB;

type
  TfrmViewFax = class(TForm)
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
    ivFax: TImageViewer;
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
  private
    bHiRes, bHiWidth, bLenWords : boolean;
    CurrentPage, TotalPages : Integer;
    CurrentRotate : Integer;
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure SetPageButtons;
    procedure LoadPage;
    procedure DoRotate(NewRotate : Integer);
  public
    ViewPercent : Integer;
    FaxFileName : String;
    procedure UpdateViewPercent(const NewPercent : Integer);
    procedure OpenFile(const FileName : string);  {!!.10}
    procedure CloseFile; {!!.10}
  end;

var
  frmViewFax: TfrmViewFax;

implementation
uses
 GlobVar, GfxUtil;

{$R *.DFM}

procedure TfrmViewFax.CloseFile;
begin
end;

procedure TfrmViewFax.OpenFile(const FileName : string);
begin
{  FaxViewer.BeginUpdate;
  FaxViewer.Scaling   := False;
  FaxViewer.HorizMult := 1;
  FaxViewer.HorizDiv  := 1;
  FaxViewer.VertMult  := 1;
  FaxViewer.VertDiv   := 1;
  FaxViewer.EndUpdate;}
  try
    ivFax.LoadMultiPage( FileName, 1);
    FaxFilename := Filename;
    TotalPages := ivFax.GetTotalPage;
    ivFax.View := 8;
    UpdateViewPercent(40);               {!!.01}
    StatusBar.Panels[0].Text := Format(' Page 1 of %d', [TotalPages]);
    Caption := 'View Fax : ' + sDocName;
    SetPageButtons;
  except
    CloseFile;
    MessageDlg('Error opening fax file '+FileName, mtError, [mbOK], 0);
  end;
end;

procedure TfrmViewFax.CloseItemClick(Sender: TObject);
begin
  CloseFile;
end;

procedure TfrmViewFax.ExitItemClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmViewFax.SelectAllItemClick(Sender: TObject);
begin
//  FaxViewer.SelectImage;
  ivFax.DrawSelectionRect(0, 0, ivFax.FileWidth, ivFax.FileHeight);
end;

procedure TfrmViewFax.CopyItemClick(Sender: TObject);
begin
  with ivFax do
  begin
    if (SelectionRectWidth = FileWidth) and (SelectionRectHeight = FileHeight) then
      Copy2ClipBoard
    else
      Crop2ClipBord(SelectionRectLeft, SelectionRectTop, SelectionRectWidth, SelectionRectHeight);
  end;
//  FaxViewer.CopyToClipBoard;

end;

procedure TfrmViewFax.FormCreate(Sender: TObject);
begin
  ivFax.LicenseKey := '12500 single developer license';
  CurrentPage := 1;
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


//  FaxViewer.Cursor := 22;
end;

procedure TfrmViewFax.UpdateViewPercent(const NewPercent : Integer);
var
  dView : Double;
begin
  if (NewPercent = ViewPercent) then
    Exit;

  ViewPercent := NewPercent;

  dView := ViewPercent;

  ivFax.ViewSize := dView / 100;

{  if (NewPercent = 100) then
    FaxViewer.Scaling := False
  else begin
    FaxViewer.BeginUpdate;
    FaxViewer.Scaling   := True;
    FaxViewer.HorizMult := NewPercent;
    FaxViewer.HorizDiv  := 100;
    FaxViewer.VertMult  := NewPercent;
    FaxViewer.VertDiv   := 100;
    FaxViewer.EndUpdate;
  end;}
end;

procedure TfrmViewFax.FaxViewerPageChange(Sender: TObject);
var
  W : Word;
begin
{  if (ivFax.FileName <> '') then
    begin
      StatusBar.Panels[0].Text := Format(' Page %d of %d', [CurrentPage
      ,TotalPages]);
      W := FaxViewer.PageFlags;
      bHiRes := W and ffHighRes <> 0;
      bHiWidth := W and ffHighWidth <> 0;
      bLenWords := W and ffLengthWords <> 0;
      SetPageButtons;
    end
  else
    begin
      StatusBar.Panels[0].Text := '  No file loaded';
    end; }
end;

procedure TfrmViewFax.FaxViewerViewerError(Sender: TObject;
  ErrorCode: Integer);
begin
  MessageDlg(Format('Viewer error %d', [ErrorCode]), mtError, [mbOK], 0);
end;

procedure TfrmViewFax.FormShow(Sender: TObject);
begin
//  OpenFile(FaxFileName);
end;

procedure TfrmViewFax.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
end;

procedure TfrmViewFax.tbPrevPageClick(Sender: TObject);
begin
  Screen.Cursor := crHourglass;
  Dec(CurrentPage);
  LoadPage;
  SetPageButtons;
  Screen.Cursor := crDefault;
end;

procedure TfrmViewFax.tbNextPageClick(Sender: TObject);
begin
  Screen.Cursor := crHourglass;
  Inc(CurrentPage);
  LoadPage;
  SetPageButtons;
  Screen.Cursor := crDefault;
end;

procedure TfrmViewFax.tbPrinterSetupClick(Sender: TObject);
begin
//  FaxPrinter.PrintSetup;
end;

procedure TfrmViewFax.tbPrintClick(Sender: TObject);
begin
{  if (FaxViewer.FileName <> '') then begin
    FaxPrinter.FileName := FaxViewer.FileName;
    FaxPrinter.PrintFax;
  end;}
  if ivFax.FileName <> '' then
    ivFax.PrintImage(True);
end;

procedure TfrmViewFax.Rotate1Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
//  FaxViewer.Rotation := TViewerRotation(TMenuItem(Sender).Tag);
  DoRotate(TMenuItem(Sender).Tag);
  TMenuItem(Sender).Checked := True;
  Screen.Cursor := crDefault;
end;

procedure TfrmViewFax.tbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmViewFax.Zoom1Execute(Sender: TObject);
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

procedure TfrmViewFax.FaxViewerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then Zoom1Execute(tbZoomIn)
  else Zoom1Execute(tbZoomOut);
end;

procedure TfrmViewFax.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 200;
    ptMinTrackSize.Y := 150;
  end;{with}
  Message.Result := 0;
  inherited;
end;

procedure TfrmViewFax.SetPageButtons;
begin
  tbPrevPage.Enabled := (TotalPages > 1) and (CurrentPage > 1);
  tbNextPage.Enabled := (TotalPages > 1) and (CurrentPage < TotalPages);
end;

procedure TfrmViewFax.LoadPage;
var
  TempRotate : Integer;
begin
  ivFax.LoadMultiPage(FaxFileName, CurrentPage);
  if CurrentRotate <> 0 then
  begin //Newpage is always loaded as normal orientation (ie 0)
     TempRotate := CurrentRotate;
     CurrentRotate := 0;
     DoRotate(TempRotate);
  end;
  StatusBar.Panels[0].Text := Format(' Page %d of %d', [CurrentPage
   ,TotalPages]);
end;

procedure TfrmViewFax.DoRotate(NewRotate: Integer);
begin
  if CurrentRotate = NewRotate then
    Exit;

  Case NewRotate - CurrentRotate of
    -3 : ivFax.Rotate90;
    -2 : ivFax.Rotate180;
    -1 : ivFax.Rotate270;
     1 : ivFax.Rotate90;
     2 : ivFax.Rotate180;
     3 : ivFax.Rotate270;
  end;

  CurrentRotate := NewRotate;
end;

end.
