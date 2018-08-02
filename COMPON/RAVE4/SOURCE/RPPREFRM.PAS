{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPPreFrm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, RPBase, RPCanvas, RPFPrint,
  RPreview, RPDefine, RPSystem, RPSetFrm, Menus, ActnList,
  ImgList, ComCtrls, ToolWin;

type
  TRPPreviewForm = class(TForm)
    ScrollBox1: TScrollBox;
    FilePrinter1: TFilePrinter;
    FilePreview1: TFilePreview;
    ActionList1: TActionList;
    MainMenu1: TMainMenu;
    PopupMenu1: TPopupMenu;
    actnFile_Print: TAction;
    actnFile_Save: TAction;
    actnFile_Exit: TAction;
    actnFile_Open: TAction;
    sbarMain: TStatusBar;
    actnPage_First: TAction;
    actnPage_Next: TAction;
    actnPage_Previous: TAction;
    actnPage_Last: TAction;
    actnZoom_In: TAction;
    actnZoom_Out: TAction;
    actnZoom_PageWidth: TAction;
    actnZoom_Page: TAction;
    Page1: TMenuItem;
    Zoom1: TMenuItem;
    Help1: TMenuItem;
    actnHelp_About: TAction;
    About1: TMenuItem;
    First1: TMenuItem;
    Next1: TMenuItem;
    Previous1: TMenuItem;
    Last1: TMenuItem;
    N2: TMenuItem;
    GotoPage1: TMenuItem;
    In1: TMenuItem;
    Out1: TMenuItem;
    N3: TMenuItem;
    Page2: TMenuItem;
    PageWidth1: TMenuItem;
    In2: TMenuItem;
    Out2: TMenuItem;
    ilstActions: TImageList;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    dlogOpen: TOpenDialog;
    dlogSave: TSaveDialog;
    File1: TMenuItem;
    Open1: TMenuItem;
    SaveAs1: TMenuItem;
    Print1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    ZoomEdit: TEdit;
    PageEdit: TEdit;
    PageLabel: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    ToolButton9: TToolButton;
    ToolButton15: TToolButton;
    Panel3: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FilePreview1PageChange(Sender: TObject);
    procedure FilePreview1ZoomChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure actnFile_ExitExecute(Sender: TObject);
    procedure actnHelp_AboutExecute(Sender: TObject);
    procedure actnPage_GotoPageExecute(Sender: TObject);
    procedure actnZoom_InExecute(Sender: TObject);
    procedure actnZoom_OutExecute(Sender: TObject);
    procedure actnPage_PreviousExecute(Sender: TObject);
    procedure actnPage_NextExecute(Sender: TObject);
    procedure actnZoom_PageWidthExecute(Sender: TObject);
    procedure actnZoom_PageExecute(Sender: TObject);
    procedure actnFile_PrintExecute(Sender: TObject);
    procedure actnPage_FirstExecute(Sender: TObject);
    procedure actnPage_LastExecute(Sender: TObject);
    procedure actnPage_FirstUpdate(Sender: TObject);
    procedure actnPage_PreviousUpdate(Sender: TObject);
    procedure actnPage_NextUpdate(Sender: TObject);
    procedure actnPage_LastUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actnFile_SaveExecute(Sender: TObject);
    procedure actnFile_OpenExecute(Sender: TObject);
    procedure actnFile_PrintUpdate(Sender: TObject);
    procedure actnFile_SaveUpdate(Sender: TObject);
    procedure actnZoom_InUpdate(Sender: TObject);
    procedure actnZoom_OutUpdate(Sender: TObject);
    procedure actnZoom_PageWidthUpdate(Sender: TObject);
    procedure actnZoom_PageUpdate(Sender: TObject);
    procedure ZoomEditKeyPress(Sender: TObject; var Key: Char);
    procedure ZoomEditExit(Sender: TObject);
    procedure PageEditExit(Sender: TObject);
    procedure PageEditKeyPress(Sender: TObject; var Key: Char);
  protected
    procedure SetSaveOptions(SaveDialog: TSaveDialog);
  public
    ReportSystem: TReportSystem;
    FormClosed: boolean;
    //
    procedure InitFromRPSystem;
    procedure OpenFile(const APathname: string);
    class procedure PreviewFile(const AFilename: string);
  end;

var
  RPPreviewForm: TRPPreviewForm;

implementation
{$R *.DFM}

uses
  RPCursor, RPRender_HTML, RPRender, RPRender_PDF;

procedure TRPPreviewForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FilePreview1.Printing then begin
    FilePreview1.Finish;
  end;
  FormClosed := true;
end;

procedure TRPPreviewForm.FilePreview1PageChange(Sender: TObject);
begin
  With FilePreview1 do begin
    PageEdit.Text := IntToStr(CurrentPage);
    PageLabel.Caption := Trans('of') + ' ' + IntToStr(Pages);
    PageLabel.Width := self.canvas.TextWidth(PageLabel.Caption) + 8;
    sbarMain.SimpleText := Trans('Page') + ' ' + IntToStr(CurrentPage) +
    ' ' + Trans('of') + ' ' + IntToStr(Pages);
  end; { with }
end;

procedure TRPPreviewForm.FilePreview1ZoomChange(Sender: TObject);
var
  S1: string[10];
begin
  Str(FilePreview1.ZoomFactor:1:1,S1);
  ZoomEdit.Text := S1;
  FilePreview1.RedrawPage;
end;

procedure TRPPreviewForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  I1: integer;
begin
  Case Key of
    vk_Up: begin
      If (Shift = []) or (Shift = [ssCtrl]) then begin
        With ScrollBox1.VertScrollBar do begin
          I1 := Position - Increment;
          If I1 < 0 then begin
            If FilePreview1.CurrentPage > 1 then begin
              FilePreview1.PrevPage;
              I1 := Range;
            end else begin
              I1 := 0;
            end;
          end; { if }
          Position := I1;
          Key := 0;
        end; { with }
      end; { if }
    end;
    vk_Down: begin
      If (Shift = []) or (Shift = [ssCtrl]) then begin
        With ScrollBox1.VertScrollBar do begin
          I1 := Position + Increment;
          If I1 >= Range then begin
            I1 := Range - 1;
          end; { if }
          Position := I1;
          If (I1 > Position) and (FilePreview1.CurrentPage < FilePreview1.Pages) then begin
            FilePreview1.NextPage;
            Position := 0;
          end; { if }
          Key := 0;
        end; { with }
      end; { if }
    end;
    vk_Home: begin
      If (Shift = []) or (Shift = [ssCtrl]) then begin
        With ScrollBox1.VertScrollBar do begin
          Position := 0;
          Key := 0;
        end; { with }
      end; { if }
    end;
    vk_End: begin
      If (Shift = []) or (Shift = [ssCtrl]) then begin
        With ScrollBox1.VertScrollBar do begin
          Position := Range - 1;
          Key := 0;
        end; { with }
      end; { if }
    end;
    vk_Prior: begin
      If (Shift = []) or (Shift = [ssCtrl]) then begin
        With ScrollBox1.VertScrollBar do begin
          I1 := Position - ScrollBox1.Height;
          If I1 < 0 then begin
            I1 := 0;
          end; { if }
          Position := I1;
          Key := 0;
        end; { with }
      end; { if }
    end;
    vk_Next: begin
      If (Shift = []) or (Shift = [ssCtrl]) then begin
        With ScrollBox1.VertScrollBar do begin
          I1 := Position + ScrollBox1.Height;
          If I1 >= Range then begin
            I1 := Range - 1;
          end; { if }
          Position := I1;
          Key := 0;
        end; { with }
      end; { if }
    end;
    vk_Left: begin
      With ScrollBox1.HorzScrollBar do begin
        If Shift = [ssCtrl] then begin
          I1 := Position - Increment;
          If I1 < 0 then begin
            I1 := 0;
          end; { if }
          Position := I1;
          Key := 0;
        end else if Shift = [ssCtrl,ssShift] then begin
          I1 := Position - ScrollBox1.Width;
          If I1 < 0 then begin
            I1 := 0;
          end; { if }
          Position := I1;
          Key := 0;
        end; { else }
      end; { with }
    end;
    vk_Right: begin
      With ScrollBox1.HorzScrollBar do begin
        If Shift = [ssCtrl] then begin
          I1 := Position + Increment;
          If I1 >= Range then begin
            I1 := Range - 1;
          end; { if }
          Position := I1;
          Key := 0;
        end else if Shift = [ssCtrl,ssShift] then begin
          I1 := Position + ScrollBox1.Width;
          If I1 >= Range then begin
            I1 := Range - 1;
          end; { if }
          Position := I1;
          Key := 0;
        end; { else }
      end; { with }
    end;
  end; { case }
end;

procedure TRPPreviewForm.FormKeyPress(Sender: TObject; var Key: Char);

var
  ValidKeys: string;

begin
  if (Key = #27) or (Key = 'x') then begin
    actnFile_Exit.Execute;
    Key := #0;
  end else begin
    ValidKeys := 'eEbBwWfFnNpP+-01234567890.'#13#8;
    If Pos(Key, ValidKeys) > 0 then begin
      case Key of
        'b','B': begin
               FilePreview1.PrintPage(1);
               Key := #0;
             end;
        'e','E': begin
               FilePreview1.PrintPage(FilePreview1.Pages);
               Key := #0;
             end;
        '-': begin
               FilePreview1.ZoomOut;
               Key := #0;
             end;
        '+': begin
               FilePreview1.ZoomIn;
               Key := #0;
             end;
        'w','W': begin
               FilePreview1.ZoomFactor := FilePreview1.ZoomPageWidthFactor;
               Key := #0;
             end;
        'f','F': begin
               FilePreview1.ZoomFactor := FilePreview1.ZoomPageFactor;
               Key := #0;
             end;
        'n','N': begin
               FilePreview1.NextPage;
               Key := #0;
             end;
        'p','P': begin
               FilePreview1.PrevPage;
               Key := #0;
             end;
      end; { case }
    end else begin
      Key := #0;
    end; { if }
  end;
  If Key = #0 then begin
    PageEdit.SelStart := 0;
    PageEdit.SelLength := Length(PageEdit.Text);
    ZoomEdit.SelStart := 0;
    ZoomEdit.SelLength := Length(ZoomEdit.Text);
  end; { if }
end;

procedure TRPPreviewForm.actnFile_ExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TRPPreviewForm.actnHelp_AboutExecute(Sender: TObject);
begin
  ShowMessage(Application.Title);
end;

procedure TRPPreviewForm.actnPage_GotoPageExecute(Sender: TObject);
var
  i: integer;
begin
  i := StrToIntDef(Inputbox('Go to Page', 'Enter page to move to:'
   , IntToStr(FilePreview1.CurrentPage)), -1);
  if (i > -1) and (FilePreview1.CurrentPage <> i) then begin
    FilePreview1.PrintPage(i);
  end;
end;

procedure TRPPreviewForm.actnZoom_InExecute(Sender: TObject);
begin
  FilePreview1.ZoomIn;
end;

procedure TRPPreviewForm.actnZoom_OutExecute(Sender: TObject);
begin
  FilePreview1.ZoomOut;
end;

procedure TRPPreviewForm.actnPage_PreviousExecute(Sender: TObject);
begin
  FilePreview1.PrevPage;
end;

procedure TRPPreviewForm.actnPage_NextExecute(Sender: TObject);
begin
  FilePreview1.NextPage;
end;

procedure TRPPreviewForm.actnZoom_PageWidthExecute(Sender: TObject);
begin
  with FilePreview1 do begin
    ZoomFactor := ZoomPageWidthFactor;
  end;
end;

procedure TRPPreviewForm.actnZoom_PageExecute(Sender: TObject);
begin
  with FilePreview1 do begin
    ZoomFactor := ZoomPageFactor;
  end;
end;

procedure TRPPreviewForm.actnFile_PrintExecute(Sender: TObject);
var
  DoPrint: boolean;
  I1: integer;
  ForceCopies: integer;
begin
  If soAllowPrintFromPreview in ReportSystem.SystemOptions then begin
    If ssAllowPreviewSetup in ReportSystem.SystemSetups then begin
      With TRPSetupForm.Create(self) do try
        PreviewSetup := true;
        ReportSystem := Self.ReportSystem;
        If FilePreview1.Stream <> FilePrinter1.Stream then begin
          with FilePrinter1 do begin
            If StreamMode = smFile then begin
              Stream := TFileStream.Create(Filename,fmOpenRead or fmShareDenyWrite);
            end; { if }
          end; { with }
        end; { if }
        FilePrinter := FilePrinter1;
        DoPrint := (ShowModal = mrOK);
        FilePrinter1.IgnoreFileSettings := true;
      finally
        Free;
      end; { with }
    end else begin
      DoPrint := true;
    end; { else }

    If DoPrint then begin
      If (FilePrinter1.MaxCopies <= 1) and (FilePrinter1.Copies > 1) then begin
        ForceCopies := FilePrinter1.Copies;
        FilePrinter1.Copies := 1;
      end else begin
        ForceCopies := 1;
      end; { else }
      FilePrinter1.TotalPasses := ForceCopies;
      For I1 := 1 to ForceCopies do begin
        FilePrinter1.CurrentPass := I1;
        FilePrinter1.Execute;
      end; { for }
    end; { if }
  end; { if }
end;

procedure TRPPreviewForm.actnPage_FirstExecute(Sender: TObject);
begin
  FilePreview1.PrintPage(1);
end;

procedure TRPPreviewForm.actnPage_LastExecute(Sender: TObject);
begin
  FilePreview1.PrintPage(FilePreview1.Pages);
end;

procedure TRPPreviewForm.actnPage_FirstUpdate(Sender: TObject);
begin
  if FilePreview1.Printing then begin
    actnPage_First.Enabled := FilePreview1.CurrentPage > 1;
  end else begin
    actnPage_First.Enabled := false;
  end;
end;

procedure TRPPreviewForm.actnPage_PreviousUpdate(Sender: TObject);
begin
  if FilePreview1.Printing then begin
    actnPage_Previous.Enabled := FilePreview1.CurrentPage > 1;
  end else begin
    actnPage_Previous.Enabled := false;
  end;
end;

procedure TRPPreviewForm.actnPage_NextUpdate(Sender: TObject);
begin
  if FilePreview1.Printing then begin
    actnPage_Next.Enabled := FilePreview1.CurrentPage < FilePreview1.Pages;
  end else begin
    actnPage_Next.Enabled := false;
  end;
end;

procedure TRPPreviewForm.actnPage_LastUpdate(Sender: TObject);
begin
  if FilePreview1.Printing then begin
    actnPage_Last.Enabled := FilePreview1.CurrentPage < FilePreview1.Pages;
  end else begin
    actnPage_Last.Enabled := false;
  end;
end;

procedure TRPPreviewForm.FormCreate(Sender: TObject);
begin
{$IFDEF DESIGNER}
  FormTrans(self);
{$ENDIF}
end;

procedure TRPPreviewForm.OpenFile(const APathname: string);
begin
  With FilePreview1 do begin
    Finish;
    StreamMode := smFile;
    FileName := APathname;
    Start;
  end;
  With FilePrinter1 do begin
    StreamMode := smFile;
    FileName := APathname;
  end;
  Caption := Application.Title + ' - [ ' + ExtractFilename(APathname) + ' ]';
end;

procedure TRPPreviewForm.actnFile_SaveExecute(Sender: TObject);

var
  LDestStream: TFileStream;
  LRender: TRPRenderStream;
  LStreamPos: integer;
  LRenderList: TStrings;

begin
{ TODO: Allow user to select a single page or page range to save/export }
  SetSaveOptions(dlogSave);
  if dlogSave.Execute then begin
    ScreenCursor.Busy;
    try
      LStreamPos := FilePreview1.Stream.Position; // Save this before messing with its stream
      try
        FilePreview1.Stream.Position := 0;

        If dlogSave.FilterIndex > 1 then begin // Do Render
          LRenderList := TStringList.Create;
          try
            RPRender.GetRenderList(LRenderList);
            LRender := TRPRenderStream(LRenderList.Objects[dlogSave.FilterIndex - 2]);
            LRender.PrintRender(FilePreview1.Stream, dlogSave.FileName);
          finally
            LRenderList.Free;
          end; { tryf }
        end else begin // Do NDR
          LDestStream := TFileStream.Create(dlogSave.Filename, fmCreate);
          try
            LDestStream.CopyFrom(FilePreview1.Stream, FilePreview1.Stream.Size);
          finally
            FreeAndNil(LDestStream);
          end;
        end; { else }

      finally
        FilePreview1.Stream.Position := LStreamPos;
      end;
    finally
      ScreenCursor.Restore;
    end;
  end;
end;

procedure TRPPreviewForm.actnFile_OpenExecute(Sender: TObject);
begin
  if dlogOpen.Execute then begin
    OpenFile(dlogOpen.Filename);
  end;
end;

procedure TRPPreviewForm.actnFile_PrintUpdate(Sender: TObject);
begin
  actnFile_Print.Enabled := FilePreview1.Printing;
end;

procedure TRPPreviewForm.actnFile_SaveUpdate(Sender: TObject);
begin
  actnFile_Save.Enabled := FilePreview1.Printing;
end;

procedure TRPPreviewForm.actnZoom_InUpdate(Sender: TObject);
begin
  actnZoom_In.Enabled := FilePreview1.Printing;
end;

procedure TRPPreviewForm.actnZoom_OutUpdate(Sender: TObject);
begin
  actnZoom_Out.Enabled := FilePreview1.Printing;
end;

procedure TRPPreviewForm.actnZoom_PageWidthUpdate(Sender: TObject);
begin
  actnZoom_PageWidth.Enabled := FilePreview1.Printing;
end;

procedure TRPPreviewForm.actnZoom_PageUpdate(Sender: TObject);
begin
  actnZoom_Page.Enabled := FilePreview1.Printing;
end;

procedure TRPPreviewForm.InitFromRPSystem;
begin
  if not FilePreview1.Printing then begin
    FilePreview1.Start;
  end;
  ReportSystem.PreviewShowEvent(FilePreview1);
end;

class procedure TRPPreviewForm.PreviewFile(const AFilename: string);
begin
  with TRPPreviewForm.Create(Application) do begin
    OpenFile(AFilename);
    Visible := True;
  end;
end;

procedure TRPPreviewForm.ZoomEditKeyPress(Sender: TObject; var Key: Char);
begin
  If Pos(Key,'01234567890') > 0 then begin
    With Sender as TEdit do begin
     If (SelLength = 0) and (Pos('.',Text) > 0) and (Length(Text) > Pos('.',Text)) then begin
       Key := #0;
     end; { if }
    end; { with }
  end else if Key = #13 then begin
    ZoomEditExit(Sender);
    With Sender as TEdit do begin
      SelStart := 0;
      SelLength := Length(Text);
    end; { with }
    Key := #0;
  end; { else }
end;

procedure TRPPreviewForm.ZoomEditExit(Sender: TObject);
var
  F1: double;
  ErrCode: integer;

begin
  Val(ZoomEdit.Text,F1,ErrCode);
  If (ErrCode = 0) and (FilePreview1.ZoomFactor <> F1) then begin
    FilePreview1.ZoomFactor := F1;
  end; { if }
end;

procedure TRPPreviewForm.PageEditExit(Sender: TObject);

var
  I1: integer;
  ErrCode: integer;

begin
  Val(PageEdit.Text,I1,ErrCode);
  If (ErrCode = 0) and (FilePreview1.CurrentPage <> I1) then begin
    FilePreview1.PrintPage(I1);
  end; { if }
end;

procedure TRPPreviewForm.PageEditKeyPress(Sender: TObject; var Key: Char);

begin
  if Key = '.' then begin
    Key := #0;
  end else if Key = #13 then begin
    PageEditExit(Sender);
    With Sender as TEdit do begin
      SelStart := 0;
      SelLength := Length(Text);
    end; { with }
    Key := #0;
  end; { if }
end;

procedure TRPPreviewForm.SetSaveOptions(SaveDialog: TSaveDialog);

begin
  dlogSave.Filter := 'Rave Snapshot Files (*.ndr)|*.ndr';
  If RPRender.GetRenderFilter <> '' then begin
    dlogSave.Filter := dlogSave.Filter + '|' + RPRender.GetRenderFilter;
  end; { if }
end;

end.