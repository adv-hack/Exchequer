unit prntprev;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RPBase, RPCanvas, RPFPrint, RPreview, Buttons, ExtCtrls,
  SBSPanel, TEditVal, ComCtrls, Menus, BtSupU1, RPDefine, RpDevice,
  ImgList, ToolWin;

Const
  WM_PrintProgress = WM_USER + $101;
  WM_PrintAbort    = WM_USER + $102;
  WM_InPrint       = WM_USER + $103;
  CRLF             = #10#13;

type

  EDeleteFile = Class(Exception);

  TForm_PrintPreview = class(TForm)
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
    CoolBar1: TCoolBar;
    ToolBar: TToolBar;
    BitBtn_ZoomIn: TToolButton;
    BitBtn_ZoomOut: TToolButton;
    BitBtn_ZoomPage: TToolButton;
    ToolButton4: TToolButton;
    BitBtn_PrevPage: TToolButton;
    BitBtn_NextPage: TToolButton;
    ToolButton5: TToolButton;
    BitBtn_Print: TToolButton;
    ToolButton2: TToolButton;
    Button_Close: TToolButton;
    ToolButton1: TToolButton;
    Panel2: TPanel;
    Panel_Pages: TPanel;
    ilTBar24Bit: TImageList;
    ilTBar24BitHot: TImageList;
    ilTBar16Col: TImageList;
    ilTBar24BitDis: TImageList;
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
    procedure FormDestroy(Sender: TObject);
    procedure Panel_PagesDblClick(Sender: TObject);
  private
    { Private declarations }
    PreviewMode  : Byte;      { 1 - Form Designer Modal, 2 - Enterprise mdi child }
    ScPage       : LongInt;
    PrintStatus  : Byte;
    SysMenuH     : HWnd;
    PageF, PageL : LongInt;
    PrintInfo    : PSBSPrintSetupInfo;

    Procedure EnableButts(PageNo : SmallInt);
    procedure InPrint(var Msg: TMessage); message WM_InPrint;
    Procedure WMRWPrint(Var Message  :  TMessage); message WM_PrintRep;

    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
    procedure UpdateSysMenu;
    procedure SetSysMenu;
    Procedure MaxSize;
  public
    { Public declarations }
    NoCopies : SmallInt;
    Procedure SetMode (Const PrevMode : Byte);
    Procedure StartPreview;
    Procedure DoMenu;
    Procedure SetPrintInfo(Value : TSBSPrintSetupInfo);
  end;

var
  Form_PrintPreview: TForm_PrintPreview;

Procedure DeletePrintFile (Const PrintFile : String);

implementation

{$R *.DFM}

Uses {FormUtil,
     PrntForm,}
     SBSFuncs,
     GlobVar,
     RWPrintR,
     PageDlg,
     VarConst,
     GFXUtil;


Const
  CM_AutoMin  =  CM_BASE + $F0;
  CM_AutoMax  =  CM_BASE + $F1;

Procedure DeletePrintFile (Const PrintFile : String);
Var
  Res : Boolean;
Begin
  If FileExists (PrintFile) Then Begin
    Try
      Res := DeleteFile (PrintFile);
    Except
    {$IFNDEF SENT}
      MessageDlg ('Error:' +
                  CRLF + CRLF +
                  'An error has occurred deleting the temporary file, ''' +
                  PrintFile +
                  '''.',
                  mtError,
                  [mbOk],
                  0);
    {$ELSE}
      on E : Exception do
       raise EDeleteFile.Create(PrintFile + ':' + E.Message);
    {$ENDIF}
    End;
  End; { If }
End;

Procedure TForm_PrintPreview.WMSysCommand(Var Message  :  TMessage);

Var
  MF_Check     : Integer;
  Locked, TBo  : Boolean;
Begin
  With Message do
    Case WParam of
      CM_AutoMin,
      CM_AutoMax    :  Begin
                         Locked:=Bon;

                         GetMultiSys(BOn,Locked,SysR);

                         TBo:=(WParam=CM_AutoMax);

                         Syss.AMMPreview[TBO] := Not Syss.AMMPreview[TBO];
                         Syss.AMMPreview[Not TBO] := False;

                         PutMultiSys(SysR,BOn);

                         UpdateSysMenu;
                       End;

      SC_MAXIMIZE    : Begin
                         ModifyMenu(SysMenuH,CM_AutoMin,MF_ByCommand+MF_DISABLED+MF_GRAYED,CM_AutoMin,'&Auto Minimize');
                         ModifyMenu(SysMenuH,CM_AutoMax,MF_ByCommand+MF_DISABLED+MF_GRAYED,CM_AutoMax,'A&uto Maximize');
                       End;

      SC_RESTORE,
      SC_MINIMIZE    : Begin
                         UpdateSysMenu;
                       End;

      (*
      CM_AutoMin,
      CM_AutoMax    :  Begin
                         Locked:=Bon;

                         TBo:=(WParam=CM_AutoMax);

                         GetMultiSys(BOn,Locked,SysR);

                         Syss.AMMPreview[TBo]:=Not Syss.AMMPreview[TBo];

                         If (Syss.AMMPreview[Not TBo]) and (Syss.AMMPreview[TBo]) then
                           Syss.AMMPreview[Not TBo]:=BOff;

                         PutMultiSys(SysR,BOn);

                         UpdateSysMenu;

                       end;
      *)
      (*
      SC_Maximize  :  If (FormStyle = fsMDIChild) Then Begin
                        { In Enterprise }
                        MaxSize;

                        WParam:=0;
                      End;
      *)
    end; {Case..}

  Inherited;
end;

Procedure TForm_PrintPreview.MaxSize;
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

procedure TForm_PrintPreview.UpdateSysMenu;

Var
  MF_Check  :  Integer;

Begin
  {If (SystemInfo.ControllerHandle = Nil) Then Begin}
    If (Syss.AMMPreview[BOff]) then
      MF_Check:=MF_Checked
    else
      MF_Check:=0;

    ModifyMenu(SysMenuH,CM_AutoMin,MF_ByCommand+MF_String+MF_Check,CM_AutoMin,'&Auto Minimize');
  (*
  End { If }
  Else
    ModifyMenu(SysMenuH,CM_AutoMin,MF_ByCommand+MF_Disabled+MF_GRAYED,CM_AutoMin,'&Auto Minimize');
  *)

  If (Syss.AMMPreview[BOn]) And (Not Syss.AMMPreview[BOff]) then
    MF_Check:=MF_Checked
  else
    MF_Check:=0;

  ModifyMenu(SysMenuH,CM_AutoMax,MF_ByCommand+MF_String+MF_Check,CM_AutoMax,'A&uto Maximize');
end;

procedure TForm_PrintPreview.SetSysMenu;
Begin
  SysMenuH:=GetSystemMenu(Handle,BOff);

  AppendMenu(SysMenuH,MF_SEPARATOR,0,'');

  AppendMenu(SysMenuH,MF_String,CM_AutoMin,'');

  AppendMenu(SysMenuH,MF_String,CM_AutoMax,'');

  UpdateSysMenu;
end;

{ function called after changing form to MDI child, as that screws everything up }
Procedure TForm_PrintPreview.DoMenu;
begin
  SetSysMenu;

  FormResize (Application);

  If Syss.AMMPreview[BOn] Then MaxSize;
end;

procedure TForm_PrintPreview.FormCreate(Sender: TObject);
begin
  if ColorMode(self.canvas) in [cm256Colors, cm16Colors, cmMonochrome] then
    begin
      {colour mode = 256 colours or less}

      {Set image lists for toolbar}
      ToolBar.Images := ilTBar16Col;
      ToolBar.HotImages := nil;
      ToolBar.DisabledImages := nil;

      {free unused image lists}
      FreeandNil(ilTBar24Bit);
      FreeandNil(ilTBar24BitHot);
      FreeandNil(ilTBar24BitDis);
    end
  else begin
    {colour mode > 256 colours}

    {Set image lists for toolbar}
    ToolBar.Images := ilTBar24Bit;
    ToolBar.HotImages := ilTBar24BitHot;
    ToolBar.DisabledImages := ilTBar24BitDis;

    {free unused image list}
    FreeandNil(ilTBar16Col);
  end;{if}

  New(PrintInfo);

  Inc(NumPrevWins);

  NoCopies := 1;
  PrintStatus := 0;
  Panel_Pages.Caption := '';
  PageF := 1;
  PageL := 1;

  SetSysMenu;

  If (Syss.AMMPreview[BOff]) Then Begin
    //WindowState := wsMinimized;
    PostMessage (Self.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
  End { If }
  Else
    { Set to maximised only if running from Form Designer }
    If (Syss.AMMPreview[BOn]) Then
      //WindowState := wsMaximized;
      PostMessage (Self.Handle, WM_SYSCOMMAND, SC_MAXIMIZE, 0);
end;

procedure TForm_PrintPreview.FormClose(Sender: TObject;
  var Action: TCloseAction);
Var
  PrevCur           : TCursor;
begin
  {CursorToHourglass (PrevCur);}

  { Free form handle from list in dll }
  {FreeFormHandle (Handle);}

  { Finish Preview }
  Try
    If FilePreview1.Printing Then
      FilePreview1.Finish;
  Except
    On Exception Do ;
  End;

  Dispose(PrintInfo);

  { Delete report file if necessary }
  DeletePrintFile (FilePreview1.FileName);

  { Deallocate form resources }
  Action := caFree;

  {RestoreCursor (PrevCur);}

end;

procedure TForm_PrintPreview.FormDestroy(Sender: TObject);
begin
  Dec(NumPrevWins);
end;

procedure TForm_PrintPreview.FormActivate(Sender: TObject);
begin
  If (PreviewMode = 1) And (Not FilePreview1.Printing) Then Begin
    Refresh;
    LockWindowUpdate(Handle);
    StartPreview;
    LockWindowUpdate(0);
  End; { If }
End;

Procedure TForm_PrintPreview.StartPreview;
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

Procedure TForm_PrintPreview.SetMode (Const PrevMode : Byte);
Begin
  PreviewMode := PrevMode;
End;

procedure TForm_PrintPreview.FormKeyDown(Sender: TObject; var Key: Word;
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
  End; { With }
end;

procedure TForm_PrintPreview.Button_PrintClick(Sender: TObject);
Var
  PageSetupDlg : TPageSetupDlg;
  PrevCur : TCursor;
begin
  Case PrintInfo^.fePrintMethod Of
    0 : Begin { Printer }
          PageSetupDlg := TPageSetupDlg.Create(Self);
          Try
            With PageSetupDlg Do Begin
              Copies := NoCopies;
              NoPages := FilePreview1.Pages;
              CurrPage := ScrollBar_Pages.Position;
            End; { With }

            If PageSetupDlg.Execute Then Begin
              PageF := PageSetupDlg.FPage;
              PageL := PageSetupDlg.LPage;
              NoCopies := PageSetupDlg.Copies;

              PrintStatus := 1; { Checking for print }

              { Send message to check inprint flag }
              SendMessage (Application.MainForm.Handle, WM_PrintProgress, 4, Handle);
            End; { If }
          Finally
            PageSetupDlg.Free;
          End;
        End; { Printer }

    1 : Begin { Fax }
          { Send message to check inprint flag }
          SendMessage (Application.MainForm.Handle, WM_PrintProgress, 4, Handle);
        End; { Fax }

    2 : Begin { Email }
          { Send message to check inprint flag }
          SendMessage (Application.MainForm.Handle, WM_PrintProgress, 4, Handle);
        End; { Email }
  End; { Case }
end;

procedure TForm_PrintPreview.InPrint(var Msg: TMessage);
Var
  PrevCur : TCursor;
  I       : SmallInt;
begin
  {CursorToHourglass (PrevCur);}
  With Msg Do
    { Check the inprint flag }
    If (WParam = Ord(False)) Then Begin
      { Set inprint }
      {SendMessage (Application.MainForm.Handle, WM_PrintProgress, 3, 1);}
      SendMessage (Application.MainForm.Handle, WM_PrintProgress, 3, 1);

      Case PrintInfo^.fePrintMethod Of
        0 : Begin { Printer }
              { Print file }
              If (NoCopies < 1) Then NoCopies := 1;
              If (NoCopies > 99) Then NoCopies := 99;
              For I := 1 To NoCopies Do
                FilePrinter1.ExecuteCustom(PageF, PageL, 1);
            End;

        1 : Begin { Fax }
              { Temporarily end preview so we don't get any clashes }
              FilePreview1.Finish;

              Case PrintInfo^.feFaxMethod Of
                { via Enterprise }
                0 : SendEntFax (PrintInfo^, FilePrinter1, FilePrinter1.FileName, True);
                { via MAPI }
                1 : SendMAPIFax (PrintInfo^, FilePrinter1.FileName);
                { Third-Party Fax Software }
                2 : SendEntFax (PrintInfo^, FilePrinter1, FilePrinter1.FileName, False);
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

              SendEmailFile2 (PrintInfo^, FilePrinter1, FilePrinter1.FileName, False);

              { Restore preview }
              FilePreview1.Start;
            End; { Email }
      End; { Case }

      { reset inprint }
      {SendMessage (Application.MainForm.Handle, WM_PrintProgress, 3, 0);}
      SendMessage (Application.MainForm.Handle, WM_PrintProgress, 3, 0);
    End { If }
    Else
      MessageDlg ('Something else is already printing',
                  mtInformation, [mbOk], 0);

  PrintStatus := 0;
end;


{ Zoom in }
procedure TForm_PrintPreview.BitBtn_ZoomInClick(Sender: TObject);
begin
  FilePreview1.ZoomIn;
end;

{ Zoom Out }
procedure TForm_PrintPreview.BitBtn_ZoomOutClick(Sender: TObject);
begin
  FilePreview1.ZoomOut;
end;

{ Show Page }
procedure TForm_PrintPreview.BitBtn_ZoomPageClick(Sender: TObject);
begin
  FilePreview1.ZoomFactor := FilePreview1.ZoomPageFactor;
end;

{ Return to initial zoom size }
procedure TForm_PrintPreview.Popup_Preview_ZoomToNormalClick(
  Sender: TObject);
begin
  FilePreview1.ZoomFactor := 100;
end;

procedure TForm_PrintPreview.Popup_Preview_PrevPageClick(Sender: TObject);
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

procedure TForm_PrintPreview.Popup_Preview_NextPageClick(Sender: TObject);
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

Procedure TForm_PrintPreview.EnableButts(PageNo : SmallInt);
begin
  Popup_Preview_PrevPage.Enabled := (PageNo > ScrollBar_Pages.Min);
  Popup_Preview_NextPage.Enabled := (PageNo < ScrollBar_Pages.Max);
  BitBtn_PrevPage.Enabled := Popup_Preview_PrevPage.Enabled;
  BitBtn_NextPage.Enabled := Popup_Preview_NextPage.Enabled;
End;

procedure TForm_PrintPreview.Panel_ScrollBarResize(Sender: TObject);
begin
  ScrollBar_Pages.Height := Panel_ScrollBar.Height - 4;
end;

procedure TForm_PrintPreview.ScrollBar_PagesScroll(Sender: TObject;
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

procedure TForm_PrintPreview.Button_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_PrintPreview.FormResize(Sender: TObject);
Var
  MF_Check  :  Integer;
begin
  (* HM 07/09/99: Removed as a D4 bug means that the WindowState isn't updated until AFTER the
     FormResize code has finished. This means that WindowState is always set to the previous value!
  If (WindowState = wsMaximized) Then Begin
    { disable the menu options }
    ModifyMenu(SysMenuH,CM_AutoMin,MF_ByCommand+MF_DISABLED+MF_GRAYED,CM_AutoMin,'&Auto Minimize');
    ModifyMenu(SysMenuH,CM_AutoMax,MF_ByCommand+MF_DISABLED+MF_GRAYED,CM_AutoMax,'A&uto Maximize');
  End { IF }
  Else Begin
    {If (SystemInfo.ControllerHandle = Nil) Then Begin}
      { re-enable them }
      If (Syss.AMMPreview[BOff]) then
        MF_Check:=MF_Checked
      else
        MF_Check:=0;
      ModifyMenu(SysMenuH,CM_AutoMin,MF_ByCommand+MF_ENABLED+MF_Check,CM_AutoMin,'&Auto Minimize');
    {End; { If }

    If (Syss.AMMPreview[BOn]) then
      MF_Check:=MF_Checked
    else
      MF_Check:=0;
    ModifyMenu(SysMenuH,CM_AutoMax,MF_ByCommand+MF_ENABLED+MF_Check,CM_AutoMax,'A&uto Maximize');
  End; { Else }
  *)
end;

procedure TForm_PrintPreview.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := (PrintStatus = 0);

  If (Not CanClose) Then
    MessageDlg ('The Preview window cannot be closed while printing is in progress', mtInformation, [mbOk], 0)
  Else
    If (FormStyle = fsMDIChild) And (WindowState = wsMaximized) Then
      WindowState := wsMinimized;
end;

procedure TForm_PrintPreview.ScrollBar_PagesChange(Sender: TObject);
begin
  Panel_Pages.Caption := 'Page ' +
                          IntToStr(ScrollBar_Pages.Position) +
                          ' of ' +
                          IntToStr(ScrollBar_Pages.Max);
end;

Procedure TForm_PrintPreview.WMRWPrint(Var Message  :  TMessage);
begin
  If BitBtn_Print.Enabled Then
    Button_PrintClick(Self);
end;


procedure TForm_PrintPreview.Panel_PagesDblClick(Sender: TObject);
begin
  ShowMessage ('Report Printer ' + FilePrinter1.Version);
end;


Procedure TForm_PrintPreview.SetPrintInfo(Value : TSBSPrintSetupInfo);
begin
  PrintInfo^ := Value;

  { Cannot print if faxing and not using the MAPI/Enterprise faxing }
  BitBtn_Print.Visible :=  (Value.fePrintMethod <> 1) Or
                           ((Value.fePrintMethod = 1) And (Value.feFaxMethod In [0, 1]));
end;


end.
