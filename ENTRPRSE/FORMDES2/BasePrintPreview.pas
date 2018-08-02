unit BasePrintPreview;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RPBase, RPCanvas, RPFPrint, RPreview, Buttons, ExtCtrls,
  SBSPanel, TEditVal, ComCtrls, Menus, GlobType, RPDefine, RpDevice,
  ImgList, ToolWin, AbBase, AbBrowse, AbZBrows;

type
  TForm_BasePrintPreview = class(TForm)
    FilePreview1: TFilePreview;
    FilePrinter1: TFilePrinter;
    Panel_ScrollBox: TSBSPanel;
    ScrollBox_Preview: TScrollBox;
    Popup_Preview: TPopupMenu;
    Popup_Preview_SepBar1: TMenuItem;
    Popup_Preview_Print: TMenuItem;
    Popup_Preview_ZoomIn: TMenuItem;
    Popup_Preview_ZoomOut: TMenuItem;
    Popup_Preview_ZoomToPage: TMenuItem;
    Popup_Preview_ZoomToNormal: TMenuItem;
    Popup_Preview_SepBar2: TMenuItem;
    Popup_Preview_PrevPage: TMenuItem;
    Popup_Preview_NextPage: TMenuItem;
    Panel_ScrollBar: TSBSPanel;
    ScrollBar_Pages: TScrollBar;
    OpenDialog1: TOpenDialog;
    ToolBar: TToolBar;
    ToolButton4: TToolButton;
    ToolButton7: TToolButton;
    ToolButton9: TToolButton;
    btnPrint: TToolButton;
    btnNext: TToolButton;
    btnPrevious: TToolButton;
    btnFullPage: TToolButton;
    btnZoomOut: TToolButton;
    btnZoomIn: TToolButton;
    btnClose: TToolButton;
    ToolButton1: TToolButton;
    Panel_Pages: TPanel;
    ilTBar24BitDisaaa: TImageList;
    ilTBar24BitHotaaa: TImageList;
    ilTBar24Bitaaa: TImageList;
    procedure FormActivate(Sender: TObject);
    procedure Button_PrintClick(Sender: TObject);
    procedure BitBtn_ZoomInClick(Sender: TObject);
    procedure BitBtn_ZoomOutClick(Sender: TObject);
    procedure BitBtn_ZoomPageClick(Sender: TObject);
    procedure Popup_Preview_ZoomToNormalClick(Sender: TObject);
    procedure Popup_Preview_PrevPageClick(Sender: TObject);
    procedure Popup_Preview_NextPageClick(Sender: TObject);
    procedure Panel_ScrollBarResize(Sender: TObject);
    procedure ScrollBar_PagesScroll(Sender: TObject;
      ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure Button_CloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ScrollBar_PagesChange(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Panel_PagesDblClick(Sender: TObject);
    procedure FilePreview1DrillDown(Sender: TObject; const LevelNo: Byte;
      const DDS1: ShortString; const DDI1, DDI2: Smallint;
      const DDB1: Byte);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
    PreviewMode : Byte;      { 1 - Form Designer Modal, 2 - Exchequer mdi child }
    ScPage      : LongInt;
    PrintStatus : Byte;
    SysMenuH    : HWnd;
    PrintInfo   : PSBSPrintSetupInfo;
    HaveClosed  : Boolean;
    fDeletePrintFileOnClose: Boolean;
    Procedure EnableButts(PageNo : SmallInt);
    procedure InPrint(var Msg: TMessage); message WM_InPrint;

    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
    procedure UpdateSysMenu;
    procedure SetSysMenu;
    Procedure MaxSize;
  protected
    procedure ConvertEDFFileToXLS;
    procedure ConvertEDFFileToHTML;
    procedure SendEmail;
    procedure SendFaxViaExchequer;
    procedure SendFaxViaMAPI;
    procedure SendFaxViaThirdParty;
  public
    { Public declarations }
    NoCopies     : SmallInt;
    PageF, PageL : LongInt;
    Procedure SetMode (Const PrevMode : Byte);
    Procedure StartPreview;
    Procedure DoMenu;
    Procedure SetCaption (Const JobName : ShortString);
    Procedure SetPrintInfo(Value : TSBSPrintSetupInfo);
    property DeletePrintFileOnClose: Boolean read FDeletePrintFileOnClose write FDeletePrintFileOnClose;
  end;

var
  Form_BasePrintPreview: TForm_BasePrintPreview;

Procedure DeletePrintFile (Const PrintFile : String); StdCall;

implementation

{$R *.DFM}

Uses FormUtil,
     SBSFuncs,
     GlobVar,
     VarConst,
     PageDlg,
     {CommsInt,}
     BtSupU1,
     GfxUtil

//     , Exscreen
     ;


Const
  CM_AutoMin  =  CM_BASE + $F0;
  CM_AutoMax  =  CM_BASE + $F1;

Procedure DeletePrintFile (Const PrintFile : String);
Begin
  If FileExists (PrintFile) Then Begin
    Try
      DeleteFile (PrintFile);
    Except
      MessageDlg ('Error:' +
                  CRLF + CRLF +
                  'An error has occured deleting the temporary file, ''' +
                  PrintFile +
                  '''.',
                  mtError,
                  [mbOk],
                  0);
    End;
  End; { If }
End;

Procedure TForm_BasePrintPreview.WMSysCommand(Var Message  :  TMessage);

Var
  Locked,
  TBo  :  Boolean;

Begin
  With Message do
    Case WParam of
      CM_AutoMin,
      CM_AutoMax    :  Begin
                         Locked:=Bon;

                         TBo:=(WParam=CM_AutoMax);

                         GetMultiSys(BOn,Locked,SysR);

                         (* HM 23/03/00: Fixed min/max problems caused by WindowState bug
                         Syss.AMMPreview[TBo]:=Not Syss.AMMPreview[TBo];
                         If (Syss.AMMPreview[Not TBo]) and (Syss.AMMPreview[TBo]) then
                           Syss.AMMPreview[Not TBo]:=BOff;
                         *)

                         Syss.AMMPreview[TBO] := Not Syss.AMMPreview[TBO];
                         Syss.AMMPreview[Not TBO] := False;

                         PutMultiSys(SysR,BOn);

                         UpdateSysMenu;
                       end;

      SC_MAXIMIZE    : Begin
                         ModifyMenu(SysMenuH,CM_AutoMin,MF_ByCommand+MF_DISABLED+MF_GRAYED,CM_AutoMin,'&Auto Minimize');
                         ModifyMenu(SysMenuH,CM_AutoMax,MF_ByCommand+MF_DISABLED+MF_GRAYED,CM_AutoMax,'A&uto Maximize');
                       End;

      SC_RESTORE,
      SC_MINIMIZE    : Begin
                         UpdateSysMenu;
                       End;

      (*
      SC_Maximize  :  If (FormStyle = fsMDIChild) Then Begin
                        { In Exchequer }
                        MaxSize;

                        WParam:=0;
                      End;
      *)
    end; {Case..}

  Inherited;
end;

Procedure TForm_BasePrintPreview.MaxSize;
Begin
  (*
  Top    := 1;
  Left   := 1;
  Width  := Application.MainForm.ClientWidth - 2 - GetSystemMetrics (SM_CXVSCROLL);
  Height := Application.MainForm.ClientHeight - Application.MainForm.Tag - 2 - GetSystemMetrics (SM_CYHSCROLL);
  WindowState := wsNormal;
  *)
  WindowState := wsMaximized;
End;

procedure TForm_BasePrintPreview.UpdateSysMenu;

Var
  MF_Check  :  Integer;

Begin
  If (SystemInfo.ControllerHandle = Nil) Then Begin
    If (Syss.AMMPreview[BOff]) then
      MF_Check:=MF_Checked
    else
      MF_Check:=0;

    ModifyMenu(SysMenuH,CM_AutoMin,MF_ByCommand+MF_String+MF_Check,CM_AutoMin,'&Auto Minimize');
  End { If }
  Else
    ModifyMenu(SysMenuH,CM_AutoMin,MF_ByCommand+MF_Disabled+MF_GRAYED,CM_AutoMin,'&Auto Minimize');

  If (Syss.AMMPreview[BOn]) And (Not Syss.AMMPreview[BOff]) then
    MF_Check:=MF_Checked
  else
    MF_Check:=0;

  ModifyMenu(SysMenuH,CM_AutoMax,MF_ByCommand+MF_String+MF_Check,CM_AutoMax,'A&uto Maximize');
end;

procedure TForm_BasePrintPreview.SetSysMenu;
Begin
  SysMenuH:=GetSystemMenu(Handle,BOff);

  AppendMenu(SysMenuH,MF_SEPARATOR,0,'');

  AppendMenu(SysMenuH,MF_String,CM_AutoMin,'');

  AppendMenu(SysMenuH,MF_String,CM_AutoMax,'');

  UpdateSysMenu;
end;

{ function called after changing form to MDI child, as that screws everything up }
Procedure TForm_BasePrintPreview.DoMenu;
begin
  SetSysMenu;

  FormResize (Application);

  If Syss.AMMPreview[BOn] Then MaxSize;
end;

procedure TForm_BasePrintPreview.FormCreate(Sender: TObject);
begin
  { Set Tag to 1010, so window can be ID'd uniquely }
  SetWindowLong (Handle, GWL_USERDATA, 1010);

  if ColorMode(self.canvas) in [cm256Colors, cm16Colors, cmMonochrome] then
    begin
      {colour mode = 256 colours or less}

      {Set image lists for toolbar}
//      ToolBar.Images := ilTBar16Col;
//      ToolBar.HotImages := nil;
//      ToolBar.DisabledImages := nil;

      {free unused image lists}
{      FreeandNil(ilTBar24Bit);
      FreeandNil(ilTBar24BitHot);
      FreeandNil(ilTBar24BitDis);}
    end
  else begin
    {colour mode > 256 colours}

    {Set image lists for toolbar}
//    ToolBar.Images := ilTBar24Bit;
//    ToolBar.HotImages := ilTBar24BitHot;
//    ToolBar.DisabledImages := ilTBar24BitDis;

    {free unused image list}
{    FreeandNil(ilTBar16Col);}
  end;{if}

  New(PrintInfo);

  NoCopies := 1;
  PrintStatus := 0;
  Panel_Pages.Caption := '';
  PageF := 1;
  PageL := 1;

  HaveClosed := False;

  SetSysMenu;

  FDeletePrintFileOnClose := True;

  If (Syss.AMMPreview[BOff]) Then Begin
    If (SystemInfo.ControllerHandle = Nil) Then
      WindowState := wsMinimized
      //PostMessage (Self.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0)   // HM Doesn't work in MDI Child!
  End { If }
  Else
    { Set to maximised only if running from Form Designer }
    If (Syss.AMMPreview[BOn]) And (SystemInfo.ControllerHandle <> Nil) Then
      WindowState := wsMaximized;
      //PostMessage (Self.Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0);  // HM Doesn't work in MDI Child!
end;

procedure TForm_BasePrintPreview.FormClose(Sender: TObject;
  var Action: TCloseAction);
Var
  PrevCur           : TCursor;
begin
  If (Not HaveClosed) Then Begin
    CursorToHourglass (PrevCur);

    HaveClosed := True;

    { Free form handle from list in dll }
    { TODO: Implement in descendant }
    // FreeFormHandle (Handle);

    { Finish Preview }
    Try
      If FilePreview1.Printing Then
        FilePreview1.Finish;
    Except
      On Exception Do ;
    End;

    { Delete report file if necessary }
    if DeletePrintFileOnClose then
      DeletePrintFile (FilePreview1.FileName);

    { Deallocate form resources }
    Action := caFree;

    Dispose(PrintInfo);

    RestoreCursor (PrevCur);
  End; { If }
end;

procedure TForm_BasePrintPreview.FormActivate(Sender: TObject);
begin
  If (PreviewMode = 1) Then Begin
    Refresh;
    LockWindowUpdate(Handle);
    StartPreview;
    LockWindowUpdate(0);
  End; { If }
End;

Procedure TForm_BasePrintPreview.StartPreview;
Var
  Tmp : Integer;
Begin
  ScPage := -1;
  FilePreview1.Start;

  Tmp := Round(FilePreview1.Pages * 0.1);
  If (Tmp < 1) Then Tmp := 1;
  ScrollBar_Pages.LargeChange := Tmp;
  ScrollBar_Pages.SetParams (1, 1, FilePreview1.Pages);
  ScrollBar_Pages.Enabled := (FilePreview1.Pages > 1);
  Panel_ScrollBar.Visible := (FilePreview1.Pages > 1);
  EnableButts(ScrollBar_Pages.Position);
end;

Procedure TForm_BasePrintPreview.SetMode (Const PrevMode : Byte);
Begin
  PreviewMode := PrevMode;
End;

procedure TForm_BasePrintPreview.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var
  Incr, NewPos : SmallInt;
  NP           : Integer;
begin
  With ScrollBox_Preview Do Begin
    If (ssCtrl In Shift) And (Not (ssAlt In Shift)) Then Begin
      Case Key Of
        VK_PRIOR : Popup_Preview_PrevPageClick(Sender);
        VK_NEXT  : Popup_Preview_NextPageClick(Sender);
        VK_HOME  : Begin
                     NP := ScrollBar_Pages.Min;
                     ScrollBar_PagesScroll(Sender, scPosition, NP);
                     ScrollBar_Pages.Position := NP;
                   End;
        VK_END   : Begin
                     NP := ScrollBar_Pages.Max;
                     ScrollBar_PagesScroll(Sender, scPosition, NP);
                     ScrollBar_Pages.Position := NP;
                   End;
      End; { Case }
    End; { If }

    If (ssAlt In Shift) Then Begin
      If (Key = VK_HOME) Then
        VertScrollBar.Position := 0;

      If (Key = VK_END) Then
        VertScrollBar.Position := VertScrollBar.Range;

      If (Key In [VK_PRIOR, VK_Up, VK_Down, VK_NEXT]) Then Begin
        If (Key In [VK_PRIOR, VK_NEXT]) Then
          { Calc Distance to move - 10% }
          Incr := Height
        Else
          Incr := Round(Height * 0.25);

        { Reverse sign if moving up }
        If (Key In [VK_PRIOR, VK_Up]) Then Incr := -Incr;

        { Check its ok }
        NewPos := VertScrollBar.Position + Incr;
        If (NewPos < 0) Then NewPos := 0;
        If (NewPos > VertScrollBar.Range) Then NewPos := VertScrollBar.Range;

        { move the scrollbar}
        VertScrollBar.Position := NewPos;
      End; { If }

      If (Key In [VK_Left, VK_Right]) Then Begin
        Incr := Round(Width * 0.25);

        { Reverse sign if moving up }
        If (Key In [VK_Left]) Then Incr := -Incr;

        { Check its ok }
        NewPos := HorzScrollBar.Position + Incr;
        If (NewPos < 0) Then NewPos := 0;
        If (NewPos > HorzScrollBar.Range) Then NewPos := HorzScrollBar.Range;

        { move the scrollbar}
        HorzScrollBar.Position := NewPos;
      End; { If }
    End; { If }

    { HM: Added processing of shortcuts for close button - Delphi5 doesn't seem to do it correctly }
    If ((Shift = []) And (Key = 27)) Or
       ((Shift = [ssAlt]) And ((Key = Ord('C')) Or (Key = Ord('c')))) Then Begin
      { Escape or Alt-C }
      Button_CloseClick(Self);
    End; { If }
  End; { With }
end;

procedure TForm_BasePrintPreview.Button_PrintClick(Sender: TObject);
Var
  PageSetupDlg : TPageSetupDlg;
  PrevCur      : TCursor;
begin
  CursorToHourglass (PrevCur);

  Case PrintInfo^.fePrintMethod Of
    0 : Begin { Printer }
          PageSetupDlg := TPageSetupDlg.Create(Self);
          Try
            With PageSetupDlg Do Begin
              Copies := NoCopies;
              NoPages := FilePreview1.Pages;
              CurrPage := ScrollBar_Pages.Position;
            End; { With }

            CursorForDialog;
            If PageSetupDlg.Execute Then Begin
              CursorFromDialog;

              PageF := PageSetupDlg.FPage;
              PageL := PageSetupDlg.LPage;
              NoCopies := PageSetupDlg.Copies;

              PrintStatus := 1; { Checking for print }

              { Send message to check inprint flag }
              {SendMessage (Application.MainForm.Handle, WM_PrintProgress, 4, Handle);}
              SendMessage (SystemInfo.MainForm.Handle, WM_PrintProgress, 4, Handle);
            End { If }
            Else
              CursorFromDialog;
          Finally
            PageSetupDlg.Free;
          End;
        End; { Printer }

    1 : Begin { Fax }
          { Send message to check inprint flag }
          SendMessage (SystemInfo.MainForm.Handle, WM_PrintProgress, 4, Handle);
        End; { Fax }

    2 : Begin { Email }
          { Send message to check inprint flag }
          SendMessage (SystemInfo.MainForm.Handle, WM_PrintProgress, 4, Handle);
        End; { Email }
    5 : Begin // Excel
          { Temporarily end preview so we don't get any clashes }
          FilePreview1.Finish;

          // Convert the EDF File to an XLS worksheet
          ConvertEDFFileToXLS;

          { Restore preview }
          FilePreview1.Start;
        End;
    7 : Begin // HTML
          { Temporarily end preview so we don't get any clashes }
          FilePreview1.Finish;

          // Convert the EDF File to an HTML File
          ConvertEDFFileToHTML;

          { Restore preview }
          FilePreview1.Start;
        End;
  End; { Case }

  RestoreCursor (PrevCur);
end;

procedure TForm_BasePrintPreview.InPrint(var Msg: TMessage);
Var
  PrevCur : TCursor;
  I       : SmallInt;
begin
  CursorToHourglass (PrevCur);

  With Msg Do
    { Check the inprint flag }
    If (WParam = Ord(False)) Then Begin
      { Set inprint }
      {SendMessage (Application.MainForm.Handle, WM_PrintProgress, 3, 1);}
      SendMessage (SystemInfo.MainForm.Handle, WM_PrintProgress, 3, 1);

      Case PrintInfo^.fePrintMethod Of
        0 : Begin { Printer }
              { Print file }
              If (NoCopies < 1) Then NoCopies := 1;
              If (NoCopies > 99) Then NoCopies := 99;
              For I := 1 To NoCopies Do
                {FilePrinter1.Execute;}
                FilePrinter1.ExecuteCustom(PageF, PageL, 1);
            End; { Printer }

        1 : Begin { Fax }
              { Temporarily end preview so we don't get any clashes }
              FilePreview1.Finish;

              Case PrintInfo^.feFaxMethod Of
                { via Exchequer }
                0: SendFaxViaExchequer;
                { via MAPI }
                1: SendFaxViaMAPI;
                { Third-Party Fax Software }
                2: SendFaxViaThirdParty;
              Else
                MessageDlg ('Unknown Fax Method (' + IntToStr(PrintInfo^.feFaxMethod) + ') - Fax not sent',
                            mtError, [mbOk], 0);
              End; { Case }

              { Restore preview }
              FilePreview1.Start;
            End; { Fax }

        2 : Begin { Email }
              { Temporarily end preview so we don't get any clashes }
              FilePreview1.Finish;

              SendEmail;

              { Restore preview }
              FilePreview1.Start;
            End; { Email }
      End; { Case }

      { reset inprint }
      {SendMessage (Application.MainForm.Handle, WM_PrintProgress, 3, 0);}
      SendMessage (SystemInfo.MainForm.Handle, WM_PrintProgress, 3, 0);
    End { If }
    Else
      MessageDlg ('Something else is already printing',
                  mtInformation, [mbOk], 0);

  PrintStatus := 0;

  RestoreCursor (PrevCur);
end;


{ Zoom in }
procedure TForm_BasePrintPreview.BitBtn_ZoomInClick(Sender: TObject);
begin
  FilePreview1.ZoomIn;
end;

{ Zoom Out }
procedure TForm_BasePrintPreview.BitBtn_ZoomOutClick(Sender: TObject);
begin
  FilePreview1.ZoomOut;
end;

{ Show Page }
procedure TForm_BasePrintPreview.BitBtn_ZoomPageClick(Sender: TObject);
begin
  FilePreview1.ZoomFactor := FilePreview1.ZoomPageFactor;
end;

{ Return to initial zoom size }
procedure TForm_BasePrintPreview.Popup_Preview_ZoomToNormalClick(
  Sender: TObject);
begin
  FilePreview1.ZoomFactor := 100;
end;

procedure TForm_BasePrintPreview.Popup_Preview_PrevPageClick(Sender: TObject);
Var
  NP : Integer;
begin
  (*
  If (ScrollBar_Pages.Position > ScrollBar_Pages.Min) Then Begin
    { Print Page }
    FilePreview1.PrevPage;

    Refresh;
    Application.ProcessMessages;
  End; { If }

  ScrollBar_Pages.Position := FilePreview1.CurrentPage;
  EnableButts(ScrollBar_Pages.Position);
  *)
  NP := ScrollBar_Pages.Position - 1;
  If (NP >= ScrollBar_Pages.Min) And (NP <= ScrollBar_Pages.Max) Then Begin
    ScrollBar_PagesScroll(Sender, scPosition, NP);
    ScrollBar_Pages.Position := NP;
  End; { If }
End;

procedure TForm_BasePrintPreview.Popup_Preview_NextPageClick(Sender: TObject);
Var
  NP : Integer;
begin
  (*
  If (ScrollBar_Pages.Position < ScrollBar_Pages.Max) Then Begin
    { Print Page }
    FilePreview1.NextPage;

    Refresh;
    Application.ProcessMessages;
  End; { If }

  ScrollBar_Pages.Position := FilePreview1.CurrentPage;
  EnableButts(ScrollBar_Pages.Position);
  *)
  NP := ScrollBar_Pages.Position + 1;
  If (NP >= ScrollBar_Pages.Min) And (NP <= ScrollBar_Pages.Max) Then Begin
    ScrollBar_PagesScroll(Sender, scPosition, NP);
    ScrollBar_Pages.Position := NP;
  End; { If }
end;

Procedure TForm_BasePrintPreview.EnableButts(PageNo : SmallInt);
begin
  Popup_Preview_PrevPage.Enabled := (PageNo > ScrollBar_Pages.Min);
  Popup_Preview_NextPage.Enabled := (PageNo < ScrollBar_Pages.Max);
//  spbtnPrevPage.Enabled := Popup_Preview_PrevPage.Enabled;
//  spbtnNextPage.Enabled := Popup_Preview_NextPage.Enabled;
  btnPrevious.Enabled := Popup_Preview_PrevPage.Enabled;
  btnNext.Enabled := Popup_Preview_NextPage.Enabled;
End;
    
procedure TForm_BasePrintPreview.Panel_ScrollBarResize(Sender: TObject);
begin
  ScrollBar_Pages.Height := Panel_ScrollBar.Height - 4;
end;

procedure TForm_BasePrintPreview.ScrollBar_PagesScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  If (ScrollCode <> scTrack) And (ScPage <> ScrollPos) Then Begin
    { Update display - disable scrollbar as it stops a bug which   }
    { causes it to automatically scroll whenever the mouse is over }
    { the button which was clicked                                 }
    {ScrollBar_Pages.Enabled := False;}
    ScPage := ScrollPos;
    FilePreview1.PrintPage(ScrollPos);
    {Refresh;}
    EnableButts(ScrollPos);
    {ScrollBar_Pages.Enabled := True;}
  End; { If }
end;

procedure TForm_BasePrintPreview.Button_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_BasePrintPreview.FormResize(Sender: TObject);
{Var
  MF_Check  :  Integer;}
begin
  (* HM 23/03/00: Fixed min/max problems caused by WindowState bug
  {
  Button_Close.Left := Panel_Toolbar.ClientWidth - Button_Close.Width - BitBtn_ZoomIn.Left;
  }
  If (WindowState = wsMaximized) Then Begin
    { disable the menu options }
    ModifyMenu(SysMenuH,CM_AutoMin,MF_ByCommand+MF_DISABLED+MF_GRAYED,CM_AutoMin,'&Auto Minimize');
    ModifyMenu(SysMenuH,CM_AutoMax,MF_ByCommand+MF_DISABLED+MF_GRAYED,CM_AutoMax,'A&uto Maximize');
  End { IF }
  Else Begin
    If (SystemInfo.ControllerHandle = Nil) Then Begin
      { re-enable them }
      If (Syss.AMMPreview[BOff]) then
        MF_Check:=MF_Checked
      else
        MF_Check:=0;
      ModifyMenu(SysMenuH,CM_AutoMin,MF_ByCommand+MF_ENABLED+MF_Check,CM_AutoMin,'&Auto Minimize');
    End; { If }

    If (Syss.AMMPreview[BOn]) then
      MF_Check:=MF_Checked
    else
      MF_Check:=0;
    ModifyMenu(SysMenuH,CM_AutoMax,MF_ByCommand+MF_ENABLED+MF_Check,CM_AutoMax,'A&uto Maximize');
  End; { Else }
  *)
end;

procedure TForm_BasePrintPreview.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := (PrintStatus = 0);

  If (Not CanClose) Then
    MessageDlg ('The Preview window cannot be closed while printing is in progress', mtInformation, [mbOk], 0)
  Else
    If (FormStyle = fsMDIChild) And (WindowState = wsMaximized) Then
      WindowState := wsMinimized;
end;

procedure TForm_BasePrintPreview.ScrollBar_PagesChange(Sender: TObject);
begin
  Panel_Pages.Caption := 'Page ' +
                          IntToStr(ScrollBar_Pages.Position) +
                          ' of ' +
                          IntToStr(ScrollBar_Pages.Max);
end;

procedure TForm_BasePrintPreview.FormDeactivate(Sender: TObject);
begin
  If (WindowState = wsMaximized) Then
    WindowState := wsNormal;
end;

procedure TForm_BasePrintPreview.Panel_PagesDblClick(Sender: TObject);
Var
  ZipInfo : ShortString;
begin
  // HM 14/03/02: Added Abbrevia version as well
  Try
    With TAbZipBrowser.Create (Self) Do
      Try
        ZipInfo := #13 + 'PK-Zip Library ' + Version;
      Finally
        Free;
      End;
  Except
    ZipInfo := '';
  End;

  ShowMessage ('Report Printer ' + FilePrinter1.Version + ZipInfo);
end;

procedure TForm_BasePrintPreview.SetCaption (Const JobName : ShortString);
Var
  JobType : String[10];
Begin { SetCaption }
  JobType := 'Print';

  If Assigned(PrintInfo) Then Begin
    Case PrintInfo^.fePrintMethod Of
      1 : JobType := 'Fax';
      2 : JobType := 'Email';
    End; { Case }
  End; { If }

  Self.Caption := JobType + ' Preview - ' + Trim(JobName);
End; { SetCaption }

Procedure TForm_BasePrintPreview.SetPrintInfo(Value : TSBSPrintSetupInfo);
Begin { SetPrintInfo }
  PrintInfo^ := Value;

  { Cannot print if faxing and not using the MAPI/Exchequer faxing }
//  spbtnPrint.Visible :=  (Value.fePrintMethod <> 1) Or
//                          ((Value.fePrintMethod = 1) And (Value.feFaxMethod In [0, 1]));
  btnPrint.Visible :=  (Value.fePrintMethod <> 1) Or
                          ((Value.fePrintMethod = 1) And (Value.feFaxMethod In [0, 1]));

End; { SetPrintInfo }

// RPDD HM 28/11/02: Added Drill-Down support
procedure TForm_BasePrintPreview.FilePreview1DrillDown(      Sender     : TObject;
                                                   const LevelNo    : Byte;
                                                   const DDS1       : ShortString;
                                                   const DDI1, DDI2 : Smallint;
                                                   const DDB1       : Byte);
Var
  DrillRec : EntCopyDataRecType;
  CopyData : TCopyDataStruct;
begin
  {ShowMessage (Format('TForm_PrintPreview.FilePreview1DrillDown(LevelNo=%d, DrillDownKey=%s)',
                      [LevelNo, QuotedStr(DrillDownKey)]));}

  // Setup the Drill-Down structure
  FillChar (DrillRec, SizeOf(DrillRec), #0);
  With DrillRec Do Begin
    DataId      := 1;
    ddLevelNo   := LevelNo;
    ddKeyString := DDS1;
    ddFileNo    := DDI1;
    ddIndexNo   := DDI2;
    ddMode      := DDB1;
  End; { With DrillRec }

  // Setup the CopyData structure
  With CopyData Do Begin
    lpData := @DrillRec;
    cbData := SizeOf(DrillRec);
  End; { With CopyData }

  // Use WM_CopyData to send the data directly to the main application window
  SendMessage (SystemInfo.MainForm.Handle, WM_CopyData, Self.Handle, Integer(@CopyData));
end;

procedure TForm_BasePrintPreview.FormMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
var
  OriginalPos, ScrollPos: Integer;
begin
  LockWindowUpdate(self.Handle);
  try
    OriginalPos := ScrollBox_Preview.VertScrollBar.Position;
    ScrollBox_Preview.VertScrollBar.Position := ScrollBox_Preview.VertScrollBar.Position + ScrollBox_Preview.VertScrollBar.Increment;
    if (ScrollBox_Preview.VertScrollBar.Position = OriginalPos) and
       (ScrollBar_Pages.Position < FilePreview1.Pages) then
    begin
      ScrollPos := ScrollBar_Pages.Position + 1;
      ScPage := ScrollPos;
      ScrollBar_Pages.Position := ScrollPos;
      FilePreview1.PrintPage(ScrollPos);
      ScrollBox_Preview.VertScrollBar.Position := 0;
      EnableButts(ScrollPos);
    end;
    Handled := True;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TForm_BasePrintPreview.FormMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
var
  OriginalPos, ScrollPos: Integer;
begin
  LockWindowUpdate(self.Handle);
  try
    OriginalPos := ScrollBox_Preview.VertScrollBar.Position;
    ScrollBox_Preview.VertScrollBar.Position := ScrollBox_Preview.VertScrollBar.Position - ScrollBox_Preview.VertScrollBar.Increment;
    if (ScrollBox_Preview.VertScrollBar.Position = OriginalPos) and
       (ScrollBar_Pages.Position > 1) then
    begin
      ScrollPos := ScrollBar_Pages.Position - 1;
      ScPage := ScrollPos;
      ScrollBar_Pages.Position := ScrollPos;
      FilePreview1.PrintPage(ScrollPos);
      // Setting the scroll bar to a high number will force it to display the
      // bottom of the page (there is no obvious way to calculate the correct
      // scroll bar position).
      ScrollBox_Preview.VertScrollBar.Position := 32768;
      EnableButts(ScrollPos);
    end;
    Handled := True;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TForm_BasePrintPreview.SendEmail;
begin
  { TODO: Implement in descendant }
  // SendEmailFile2 (PrintInfo^, FilePrinter1, FilePrinter1.FileName, False);
end;

procedure TForm_BasePrintPreview.SendFaxViaExchequer;
begin
  { TODO: Implement in descendant }
  // SendEntFax (PrintInfo^, FilePrinter1, FilePrinter1.FileName, True);
end;

procedure TForm_BasePrintPreview.SendFaxViaMAPI;
begin
  { TODO: Implement in descendant }
  // SendMAPIFax (PrintInfo^, FilePrinter1.FileName);
end;

procedure TForm_BasePrintPreview.SendFaxViaThirdParty;
begin
  { TODO: Implement in descendant }
  // SendEntFax (PrintInfo^, FilePrinter1, FilePrinter1.FileName, False);
end;

procedure TForm_BasePrintPreview.ConvertEDFFileToHTML;
begin
  { TODO: Implement in descendant }
  // ConvertEDFToHTML (FilePrinter1.FileName, PrintInfo^.feXMLFileDir, PrintInfo^.feMiscOptions[1]);
end;

procedure TForm_BasePrintPreview.ConvertEDFFileToXLS;
begin
  { TODO: Implement in descendant }
  // ConvertEDFToXLS (FilePrinter1.FileName, PrintInfo^.feXMLFileDir, PrintInfo^.feMiscOptions[1]);
end;

end.

