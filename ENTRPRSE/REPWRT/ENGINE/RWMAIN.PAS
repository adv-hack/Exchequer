unit RWMain;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, SBSPanel, ExtCtrls, StdCtrls, Gauges, ComCtrls, sbsprint, Menus,
  TEditVal, BtSupU1, ImgList, ToolWin;

Const
  WM_PrintProgress = WM_USER + $101;
  WM_InPrint       = WM_USER + $103;

type
  TForm_RWMain = class(TForm)
    MainMenu1: TMainMenu;
    Menu_File: TMenuItem;
    Menu_File_Print: TMenuItem;
    Menu_File_PrintSetup: TMenuItem;
    Menu_File_SepBar1: TMenuItem;
    Menu_File_Exit: TMenuItem;
    Records1: TMenuItem;
    ReportTree1: TMenuItem;
    Utilities1: TMenuItem;
    ExportReports1: TMenuItem;
    ImportReports1: TMenuItem;
    N2: TMenuItem;
    FreeRecursiveReports1: TMenuItem;
    FileDump1: TMenuItem;
    Window1: TMenuItem;
    Cascade1: TMenuItem;
    Tile1: TMenuItem;
    ArrangeAll1: TMenuItem;
    MinimizeAll1: TMenuItem;
    Menu_Help: TMenuItem;
    HBG1: TMenuItem;
    N1: TMenuItem;
    Menu_Help_Contents: TMenuItem;
    Menu_Help_What: TMenuItem;
    Menu_Help_SepBar1: TMenuItem;
    Menu_Help_About: TMenuItem;
    OpenDialog1: TOpenDialog;
    SBSPanel1: TSBSPanel;
    StatusBar: TStatusBar;
    SBSPanel2: TSBSPanel;
    Gauge1: TGauge;
    SBSPanel3: TSBSPanel;
    Gauge2: TGauge;
    SBSPanel_Print: TSBSPanel;
    Gauge3: TGauge;
    Label_PrntProg: TLabel;
    Image1: TImage;
    Image2: TImage;
    SelectField1: TMenuItem;
    ilTBar24Bit: TImageList;
    ilMenu16Col: TImageList;
    ilTBar16Col: TImageList;
    ilTBar24BitHot: TImageList;
    ilMenu24Bit: TImageList;
    CoolBar1: TCoolBar;
    ToolBar: TToolBar;
    MainStockBtn: TToolButton;
    PrintBtn: TToolButton;
    ImportBtn: TToolButton;
    ExportBtn: TToolButton;
    ToolButton15: TToolButton;
    ExitBtn: TToolButton;
    WhatTBtn: TToolButton;
    ToolButton1: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Menu_File_PrintSetupClick(Sender: TObject);
    procedure Menu_File_ExitClick(Sender: TObject);
    procedure Menu_Help_ContentsClick(Sender: TObject);
    procedure Menu_Help_WhatClick(Sender: TObject);
    procedure Menu_Help_AboutClick(Sender: TObject);
    procedure MainStockBtnClick(Sender: TObject);
    procedure HBG1Click(Sender: TObject);
    procedure Menu_HelpClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FreeRecursiveReports1Click(Sender: TObject);
    procedure Cascade1Click(Sender: TObject);
    procedure Tile1Click(Sender: TObject);
    procedure ArrangeAll1Click(Sender: TObject);
    procedure MinimizeAll1Click(Sender: TObject);
    procedure ImportBtnClick(Sender: TObject);
    procedure ExportBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure SelectField1Click(Sender: TObject);
    procedure Utilities1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    DoneRepTree,
    InRepTree : Boolean;

    HideBkGnd : Boolean;

    FClientInstance,
    FPrevClientProc : TFarProc;

    fDriveNo,
    fDiskSize,
    fDiskFree       : Int64;

    ONCMetrics,
    NCMetrics       :  PNonClientMetrics;

    OldHint, OldActive : TNotifyEvent;

    procedure ClientWndProc(VAR Message: TMessage);
    Procedure DrawBkGnd(Var Message  :  TMessage);
    procedure PrintProgress(var Msg: TMessage); message WM_PrintProgress;
    Procedure Reset_NonClientInfo;
    procedure ResetPalette(Var Message  : TMessage);
    Procedure Set_NonClientInfo;
    procedure ShowHint(Sender: TObject);
    Procedure Update_DriveResource;
    procedure UpdateMenuItems(Sender: TObject);
    procedure UpdateRepTree(var Msg: TMessage); message WM_UpdateTree;
    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;
    Procedure WMKeyDown(Var Message  :  TMessage); Message WM_KeyDown;
    Procedure WMPaletteChanged(Var Message  :  TMessage); Message WM_PaletteChanged;
    Procedure WMQueryNewPalette(Var Message  :  TMessage); Message WM_QueryNewPalette;

    procedure EntException(Sender  :  TObject; E  :  Exception);

    procedure ApplicationActive(Sender : TObject);
    procedure EntDeActivate(Sender : TObject);
  public
    { Public declarations }
  end;

var
  Form_RWMain: TForm_RWMain;

implementation

{$R *.DFM}
{$R WinXPMan.Res}     // Windows XP Manifest File

Uses
  RpDevice,
  GlobVar,
  VarConst,
  BtrvU2,
  BtSupU2,
  EtStrU,
  EtMiscU,
  OverWrit,
  RwOpenF,
  RpCommon,
  RepTree,
  RepDet,
  PWarnU,
  ExThrd2U,
  FaxIntO,
  HelpSupU,
  AboutU,
{$IFDEF DBF}
  DbfInt,
{$ENDIF}
  GfxUtil;

Var
  ExitSave : Pointer;

{ Generic procedure to close down all files }
Procedure Ex_Abort;  far;
Begin
  ExitProc:=ExitSave;

  Close_Files(BOn);
end;


procedure TForm_RWMain.FormCreate(Sender: TObject);
Var
  CDir : ShortString;
begin
  { Temporary fix to enable security on the distibution version }
  {EntryRec^.Access[194] := 1;}

  if Syss.UseClassToolB or (ColorMode(self.canvas) in [cm256Colors, cm16Colors, cmMonochrome]) then
    begin
      {colour mode = 256 colours or less}

      {Set image lists for toolbar}
      ToolBar.Images := ilTBar16Col;
      ToolBar.HotImages := nil;
//      ToolBar.DisabledImages := nil;

      {Set image list for Menu}
      MainMenu1.Images := ilMenu16Col;

      {free unused image lists}
      FreeandNil(ilTBar24Bit);
      FreeandNil(ilTBar24BitHot);
      FreeandNil(ilMenu24Bit);
//      FreeandNil(ilTBar24BitDis);
    end
  else begin
    {colour mode > 256 colours}

    {Set image lists for toolbar}
    ToolBar.Images := ilTBar24Bit;
    ToolBar.HotImages := ilTBar24BitHot;
//    ToolBar.DisabledImages := ilTBar24BitDis;

    {Set image list for Menu}
    MainMenu1.Images := ilMenu24Bit;

    {free unused image lists}
    FreeandNil(ilTBar16Col);
    FreeandNil(ilMenu16Col);
  end;{if}

  Application.OnException:=EntException;

  InRepTree := False;
  DoneRepTree := False;

  // HM 14/05/02: Modified so that the /NL: parameter hides the background automatically
  HideBkGnd := FindCmdLineSwitch ('NL:', ['-', '/'], True);

  OldHint := Application.OnHint;
  Application.OnHint := ShowHint;
  Application.Hintpause:=1200;

  OldActive := Screen.OnActiveFormChange;
  Screen.OnActiveFormChange:=UpdateMenuItems;

  { Set Tag to 1010, so window can be ID'd uniquely }
  SetWindowLong (Handle, GWL_USERDATA, 1010);

  If (Screen.Width>640) then
    Image1.Picture:=Image2.Picture;

  FClientInstance := MakeObjectInstance(ClientWndProc);
  FPrevClientProc := Pointer(GetWindowLong(ClientHandle, GWL_WNDPROC));
  SetWindowLong(ClientHandle, GWL_WNDPROC, LongInt(FClientInstance));

  Set_NonClientInfo;

  { Initialise the resource gauges }
  If (SetDrive='') Then
    GetDir(0,Cdir)
  Else
    Cdir:=SetDrive;

  fDriveNo:=Ord(UPCase(CDir[1]))-64;
  fDiskSize:=DiskSize(fDriveNo);
  If (fDiskSize<-1) then fDiskSize:=MaxLongInt+fDiskSize;

  Update_DriveResource;

  eCommsModule:=Check_ModRel(8,BOn);

  { Do Security }
  Utilities1.Visible := ChkAllowed_In(194);
//  ToolPan2.Visible := ChkAllowed_In(194);
  ImportBtn.Enabled := ChkAllowed_In(194);
  ExportBtn.Enabled := ChkAllowed_In(194);

  // HM 31/01/02: Added code to switch application title
  Application.OnActivate   := ApplicationActive;
  Application.OnDeactivate := EntDeActivate;
  Application.OnMinimize   := EntDeActivate;
  Application.OnRestore    := ApplicationActive;


end;


procedure TForm_RWMain.Menu_File_PrintSetupClick(Sender: TObject);
begin
  RpDev.PrinterSetupDialog;
end;


procedure TForm_RWMain.Menu_File_ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_RWMain.Menu_Help_ContentsClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_Finder,0);
end;

procedure TForm_RWMain.Menu_Help_WhatClick(Sender: TObject);
begin
  PostMessage(Self.Handle,WM_SysCommand,SC_CONTEXTHELP,0);
end;

procedure TForm_RWMain.Menu_Help_AboutClick(Sender: TObject);
Var
  AboutFrm   :  TAboutFrm;
begin
  AboutFrm:=TAboutFrm.Create(Self);
  Try
    Set_BackThreadMVisible(BOn);
    AboutFrm.ShowModal;
    Set_BackThreadMVisible(BOff);
  Finally
    AboutFrm.Free;

    MDI_ForceParentBKGnd(BOn);
  End;
end;

procedure TForm_RWMain.MainStockBtnClick(Sender: TObject);
begin
  { Create Report Tree window }
  If (Not InRepTree) Then
    Form_RepTree := TForm_RepTree.Create(Self)
  Else
    With Form_RepTree Do Begin
      If (WindowState=wsMinimized) then
        WindowState:=wsNormal;

      Show;
    End; { With }

  InRepTree:=BOn;
end;

Procedure TForm_RWMain.WMFormCloseMsg(Var Message  :  TMessage);

  Procedure Fax_File(SetAddr  :  LongInt);
  Var
    EntFaxO : TEntFaxInt;
    Res     : SmallInt;

  Begin
    EntFaxO:=Pointer(SetAddr);

    Try
      With EntFaxO do
      Begin
        Res := StoreDetails;
      end;
    Finally
      EntFaxO.Destroy;
    end;
  end;

Begin
  Case Message.WParam Of
    { HM 09/05/00: Added for faxing }
    99  :  Fax_File(Message.LParam);

    100 : Begin
            InRepTree := BOff;
            Form_RepTree := Nil;
          End;
  End; { Case }
End;


Procedure TForm_RWMain.DrawBkGnd(Var Message  :  TMessage);
Var
  MyDC       : hDC;
  Ro, Co     : Word;
  OldPalette : HPalette;


Begin


  MyDC := TWMEraseBkGnd(Message).DC;

  OldPalette:=SelectPalette(MyDC,Image1.Picture.BitMap.Palette,False);
  try
    RealizePalette(MyDC);

    for Ro := 0 TO ClientHeight DIV Image1.Picture.Height DO
       for Co := 0 TO ClientWIDTH DIV Image1.Picture.Width DO
         BitBlt(MyDC, Co*Image1.Picture.Width, Ro*Image1.Picture.Height,
                Image1.Picture.Width, Image1.Picture.Height,
                Image1.Picture.Bitmap.Canvas.Handle, 0, 0, SRCCOPY);
  finally
    SelectPalette(MyDC,OldPalette,true);
  end; {try..}

end;


procedure TForm_RWMain.ResetPalette(Var Message  : TMessage);

Var
  MyDC       : hDC;
  OldPalette : HPalette;


Begin

  MyDC:=GetDC(Self.Handle);

  try
    OldPalette:=SelectPalette(MyDC,Image1.Picture.BitMap.Palette,False);

    try
      Message.Result:=RealizePalette(MyDC);

    finally

      SelectPalette(MyDC,OldPalette,true);
    end;

  finally

    ReleaseDC(Self.Handle,MyDC);

  end;

end;


procedure TForm_RWMain.ClientWndProc(VAR Message: TMessage);


begin
  with Message do
  Begin
    {ReDrawBk:=((Msg=WM_HSCROLL) or (Msg=WM_VSCROLL));}


    If (Not HideBkGnd) and (Not Syss.HideEXLogo) then
    Begin
      case Msg of
        WM_ERASEBKGND:
          begin
            DrawBkGnd(Message);
            Result := 1;
          end;
        WM_KeyDown:
          begin
            WMKeyDown(Message);

          end;

        WM_VSCROLL, WM_HSCROLL :
          begin
            InvalidateRect(ClientHandle, nil, True);
            Result := CallWindowProc(FPrevClientProc, ClientHandle, Msg, wParam, lParam);
          end;

        WM_QUERYNEWPALETTE  :
          ResetPalette(Message);

        WM_PALETTECHANGED  :
          If (WParam<>Self.Handle) then
            ResetPalette(Message);

      else
        Result := CallWindowProc(FPrevClientProc, ClientHandle, Msg, wParam, lParam);
      end;
    end
    else
    Begin
      case Msg of
        WM_KeyDown:
          begin
            WMKeyDown(Message);

          end;

      else
        Result := CallWindowProc(FPrevClientProc, ClientHandle, Msg, wParam, lParam);
      end;
    end;
  end; {With..}
end;


Procedure TForm_RWMain.WMQueryNewPalette(Var Message  :  TMessage);
Begin
  ResetPalette(Message);
end;

Procedure TForm_RWMain.WMPaletteChanged(Var Message  :  TMessage);
Begin
  If (Message.WParam<>Self.Handle) then
    ResetPalette(Message);
end;


Procedure TForm_RWMain.Set_NonClientInfo;
Var
  MCCancel   :  Boolean;
  SBW,SBH    :  Integer;
Begin
  New(NCMetrics);
  New(ONCMetrics);

  FillChar(ONCMetrics^,Sizeof(ONCMetrics^),0);

  MCCancel:=BOff;

  ONCMetrics^.cbSize:=Sizeof(ONCMetrics^);

  If (SystemParametersInfo(SPI_GETNONCLIENTMETRICS,0,ONCMETRICS,0)) then
  Begin
    With ONCMetrics^ do
    Begin
      Move(iScrollWidth,SBW,Sizeof(SBW));
      Move(iScrollHeight,SBH,Sizeof(SBH));
    end;

    If (SBW<>16) or (SBH<>16) then
    With NCMetrics^ do
    Begin
      NCMetrics^:=ONCMetrics^;

      SBW:=16;
      SBH:=16;

      Move(SBW,iScrollWidth,Sizeof(SBW));
      Move(SBH,iScrollHeight,Sizeof(SBH));

      MCCancel:=Not SystemParametersInfo(SPI_SETNONCLIENTMETRICS,0,NCMETRICS,{SPIF_SENDWININICHANGE}0);
    end
    else
      MCCancel:=BOn;

  end
  else
    MCCancel:=BOn;

  If (MCCancel) then Begin
    Dispose(ONCMetrics);
    ONCMetrics:=nil;

    Dispose(NCMetrics);
    NCMetrics:=nil;
  end;
end;


Procedure TForm_RWMain.Reset_NonClientInfo;
Begin
  If (Assigned(ONCMetrics))  then Begin
    SystemParametersInfo(SPI_SETNONCLIENTMETRICS,0,ONCMETRICS,{SPIF_SENDWININICHANGE}0);

    Dispose(ONCMetrics);
    ONCMetrics:=nil;

    Dispose(NCMetrics);
    NCMetrics:=nil;
  end;
end;


procedure TForm_RWMain.FormDestroy(Sender: TObject);
begin
  Application.OnHint := OldHint;
  Screen.OnActiveFormChange := OldActive;

  // HM 31/01/02: Added code to switch application title
  Application.OnActivate   := NIL;
  Application.OnDeactivate := NIL;
  Application.OnMinimize   := NIL;
  Application.OnRestore    := NIL;

  Reset_NonClientInfo;
end;

procedure TForm_RWMain.HBG1Click(Sender: TObject);
begin
  HideBkGnd:=Not HideBkGnd;

  InvalidateRect(0, nil, True);
end;

procedure TForm_RWMain.Menu_HelpClick(Sender: TObject);
begin
  HBG1.Checked:=HideBkGnd;
end;

Procedure TForm_RWMain.WMKeyDown(Var Message  :  TMessage);
Begin
  (*
  If (AllowHotKey) then
    With Message do Begin
      Case WParam of

        1  :  ;

      end; {Case..}

    end;
  *)

  Inherited;
End;

procedure TForm_RWMain.FormActivate(Sender: TObject);
begin
  If (Not DoneRepTree) Then Begin
    DoneRepTree := True;
    MainStockBtnClick(Sender);
  End; { If }
end;

procedure TForm_RWMain.PrintProgress(var Msg: TMessage);
begin
  With Msg Do Begin
    { Mode passes in WParam }
    Case WParam Of
      { Clear Progress }
      0 : { N/A };

      { Set Progress percentage }
      1 : { N/A };

      { Set HWnd }
      2 : { N/A };

      { Set InPrint Flag }
      3 : { N/A };

      { Check InPrint Flag }
      4 : SendMessage(LParam,WM_InPrint,Ord(False),0);
    End; { Case }
  End; { With }
end;

procedure TForm_RWMain.Button1Click(Sender: TObject);
Const
  FNum    = RepGenF;
  KeyPath = RGK;
Var
  OutF : TextFile;
  KeyS : Str255;
Begin
  AssignFile (OutF, 'Rep.Txt');
  Rewrite    (OutF);

  Status:=Find_Rec(B_GetFirst,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
  While (Status = 0) Do Begin
    With RepGenRecs^ Do Begin
      Write (OutF, RecPFix + '    ' + SubType + '    ');

      Case SubType Of
        'D'   : With RNotesRec Do Begin { Notes }
                  {Write (OutF, NType + '    ' + IntToStr(LineNo) + '    ' + NoteLine);}
                  Write (OutF, NoteNo + '    ' + NoteLine);
                End;
        'H'   : With ReportHed Do Begin { Group }
                  Case RepType Of
                    'H' : Write (OutF, 'Hdr');
                    'R' : Write (OutF, 'Rep');
                  Else
                    Write (OutF, RepType + '??');
                  End; { Case }

                  Write (OutF, '    ' + RepGroup + '    ' + RepName + '    ' + RepDesc);
                End;
        'N'   : With ReportNom Do Begin { Nominal }
                  Write (OutF, ReportKey);
                End;
        'L',
        'R'   : With ReportDet Do Begin { Detail }
                  Write (OutF, ReportKey);
                  {Write (OutF, RepName + '    ' + VarType + '    ' + IntToStr(RepVarNo));}
                End; { With }
      End; { Case }

      Writeln (OutF);
    End; { With }

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
  End; { While }

  CloseFile  (OutF);
end;

procedure TForm_RWMain.FreeRecursiveReports1Click(Sender: TObject);
Const
  FNum    = RepGenF;
  KeyPath = RGK;
Var
  KeyS    : Str255;
  Changed : Boolean;
Begin
  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
  While (Status = 0) Do Begin
    With RepGenRecs^ Do
      If (RecPFix = ReportGenCode) And (SubType = RepGroupCode) Then
        With ReportHed Do Begin
          RepName  := FullRepCode(RepName);
          RepGroup := FullRepCode(RepGroup);

          If (RepName = RepGroup) Then
            { points to itself }
            RepGroup := FullRepCode('');

          ReportKey := RepGroup + RepName;

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);
        End; { With }

    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
  End; { While }
end;

procedure TForm_RWMain.Cascade1Click(Sender: TObject);
begin
  Cascade;
end;

procedure TForm_RWMain.Tile1Click(Sender: TObject);
begin
  Tile;
end;

procedure TForm_RWMain.ArrangeAll1Click(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TForm_RWMain.MinimizeAll1Click(Sender: TObject);
var
  I: Integer;
begin
  { Must be done backwards through the MDIChildren array }
  for I := MDIChildCount - 1 downto 0 do
    MDIChildren[I].WindowState := wsMinimized;
end;

procedure TForm_RWMain.PrintBtnClick(Sender: TObject);
begin
  If Assigned (Screen.ActiveForm) Then
    SendMessage (Screen.ActiveForm.Handle, WM_PrintRep, 0, 0);
end;

procedure TForm_RWMain.ExportBtnClick(Sender: TObject);
begin
  If InRepTree And Assigned(Form_RepTree) Then
    SendMessage (Form_RepTree.Handle, WM_ExportRep, 0, 0);
end;

procedure TForm_RWMain.ImportBtnClick(Sender: TObject);
Var
  ImpFile                : File Of RepGenRec;
  ImpRec, TmpRec         : RepGenPtr;
  CurrRepNam, TmpRepName : Str10;
  OverWMode              : Byte;

  Function Get_OverWMode (Const RepName : ShortString) : Byte;
  Var
    Form_OverWrite : TForm_OverWrite;
  Begin
    Result := 0;
    
    Form_OverWrite := TForm_OverWrite.Create(Self);
    Try
      With Form_OverWrite Do Begin
        Label1.CAption := RepName + Label1.Caption;

        Set_BackThreadMVisible(BOn);
        ShowModal;
        Set_BackThreadMVisible(BOff);

        If OWAny.Checked Then Result := 1;
        If OWThis.Checked Then Result := 2;
        If NoOWThis.Checked Then Result := 3;
        If NoOWAny.Checked Then Result := 4;
      End; { With }
    Finally
      Form_OverWrite.Free;
    End;
  End;

  Procedure ProcessImport;
  Const
    FNum    = RepGenF;
    KeyPath = RGK;
  Var
    Exists, HedExists, OK2Store : Boolean;
  Begin
    With ImpRec^ Do Begin
      (*
      If (RecPFix = ReportGenCode) Then Begin
        If (SubType = RepGroupCode) Then Begin
          Case ReportHed.RepType Of
            RepGroupCode : ShowMessage ('Group: ' + ReportHed.RepName + ' - ' + ReportHed.RepDesc);
            RepRepCode   : ShowMessage ('Report: ' + ReportHed.RepName + ' - ' + ReportHed.RepDesc);
            RepNomCode   : ShowMessage ('Nominal: ' + ReportHed.RepName + ' - ' + ReportHed.RepDesc);
          End; { Case }
        End; { If }

        If (SubType = RepRepCode) Then Begin
          ShowMessage ('Report Line(' + ReportDet.RepName + '): ' + ReportDet.RepLDesc);
        End; { If }

        If (SubType = RepNomCode) Then Begin
          ShowMessage ('Nominal Line(' + ReportNom.RepName + '): ' + ReportNom.NomRef);
        End; { If }

        If (SubType = RepLineTyp) Then Begin
          ShowMessage ('Input Line(' + ReportDet.RepName + '): ' + ReportDet.RepLDesc);
        End; { If }
      End; { If }

      If (RecPFix = RepNoteType) And (SubType = RepNoteCode) Then Begin
        ShowMessage ('Note(' + RNotesRec.NoteFolio + '): ' + RNotesRec.NoteLine);
      End; { If }
    *)

      Exists := BOff;
      HedExists := BOff;
      OK2Store := BOff;

      If (SubType=RepHedTyp) then
        With ReportHed do Begin
          Exists:=CheckRecExsists(FullRepKey(RecPFix,SubType,RepName),RepGenF,RGNdxK);

          If (Exists) then Begin
            If (OverWMode In [0,2,3]) then
              OverWMode:=Get_OverWMode(Strip('B',[#32],RepName));
          end
          else
            OverWMode:=2;

          If (OverWMode In [1,2]) then Begin
            If (Exists) then
              DeleteRepLines(RepName);

            HedExists:=CheckExsists(FullRepKey(RecPFix,SubType,RepGroup),RepGenF,RGNdxK);

            If (Not HedExists) then Begin
              RepGroup:=FullRepCodE(''); {Rep2Copy.ReportHed.RepGroup;}

              ReportKey:=FullRepGroupKey(RepGroup,RepName);
            End; { If }

            LastRun:='';
            LastOpo:='';
            FirstPos:=0;
            LastPos:=0;

            Ok2Store:=BOn;

            If (RepType In [RepRepCode,RepNomCode]) then
              CurrRepNam:=RepName;
          End; { If }
        End { With }
      Else Begin
        Case RecPFix of
          NoteTCode  :  With ImpRec^.RNotesRec Do
                          Ok2Store:=(NoteFolio=CurrRepNam);

        Else
          With ImpRec^.ReportDet do
            Ok2Store:=(RepName=CurrRepNam);
        End; { Case }
      End; { Else }

      If Ok2Store Then Begin
        RepGenRecs^ := ImpRec^;

        Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);
        Report_BError(FNum, Status);
      End; { If }
    End; { With }
  End;

  Function ValidImp (FName : ShortString) : Boolean;
  Var
    CheckFile : File Of Byte;
    TestRec   : RepGenRec;
  Begin
    Result := False;

    Try
      { Open Export File }
      AssignFile (CheckFile, FName);
      Reset      (CheckFile);

      Result := (FileSize (CheckFile) Mod SizeOf (RepGenRec)) = 0;

      { Close Export File }
      CloseFile  (CheckFile);
    Except
      On Exception Do ;
    End;

    If Result Then
      Try
        Try
          { Check for X record }
          AssignFile (ImpFile, FName);
          Reset      (ImpFile);

          { Must have > 1 record }
          Result := (FileSize(ImpFile) > 1);

          If Result Then Begin
            { Get first record }
            Read (ImpFile, TestRec);

            { Check first record is the export signature record }
            With TestRec.ReportHed Do
              Result := (RepName=ExportSig) and (RepType='X');
          End; { If }
        Except
          Result := False;
        End;
      Finally
        CloseFile (ImpFile);
      End;
  End;

begin
  If OpenDialog1.Execute Then
    { Check its a valid file }
    If ValidImp(OpenDialog1.FileName) Then Begin
      { Allocate memory for local record }
      GetMem (ImpRec, SizeOf (ImpRec^));

      { Initialise local variables }
      OverWMode := 0;

      AssignFile (ImpFile, OpenDialog1.FileName);
      Reset      (ImpFile);
      Seek       (ImpFile, 1);

      If Not EOF(ImpFile) Then
        Repeat
          Read (ImpFile, ImpRec^);

          ProcessImport;
        Until EOF (ImpFile);

      { Close Export File }
      CloseFile  (ImpFile);

      { Update tree (if displayed) }
      If InRepTree And Assigned(Form_RepTree) Then Begin
        RepGenRecs^.ReportHed.RepName := '';
        Form_RepTree.AddEditLine(1);
      End; { If }

      { Free memory for local record }
      FreeMem (ImpRec, SizeOf (ImpRec^));
    End { If }
    Else
      MessageDlg (Trim(OpenDialog1.FileName) + ' is not a valid Report Writer Import File', mtError, [mbOk], 0);
end;

procedure TForm_RWMain.UpdateRepTree(var Msg: TMessage);
begin
  { Create Report Tree window }
  If InRepTree And Assigned(Form_RepTree) Then
    {Form_RepTree.NLOLine.Refresh;}
    SendMessage (Form_RepTree.Handle, WM_UpdateTree, Msg.WParam, Msg.LParam);
end;

procedure TForm_RWMain.ShowHint(Sender: TObject);
begin
  StatusBar.Panels[1].Text:= Application.Hint;
end;

{ ======== Function to Check Drive status ========== }
Procedure TForm_RWMain.Update_DriveResource;

Var
  MemInfo  :  TMemoryStatus;
  FLoad    :  Integer;

Begin
  fDiskFree:=DiskFree(fdriveNo);

  If (fDiskFree<-1) then
    fDiskFree:=MaxLongInt+fDiskFree;

  With Gauge1 do Begin
    //Progress:=Round(DivWChk(fDiskFree,fDiskSize)*100);
    Progress:=Round(FreeDiskSpacePcnt);
    ForeColor:=Color_ResourceMon(Progress);
  end;

  With Gauge2 do Begin
    Progress:=Get_FreeResources;
    ForeColor:=Color_ResourceMon(Progress);
  end;
end;

procedure TForm_RWMain.UpdateMenuItems(Sender: TObject);
begin
  Cascade1.Enabled := MDIChildCount > 0;
  Tile1.Enabled := MDIChildCount > 0;
  ArrangeAll1.Enabled := MDIChildCount > 0;
  MinimizeAll1.Enabled := MDIChildCount > 0;

  Update_DriveResource;
end;


procedure TForm_RWMain.Utilities1Click(Sender: TObject);
Var
  Res : Boolean;
begin
  Res := False;

  If Screen.ActiveControl Is TMemo Then
    {Res := (Screen.ActiveControl.Tag >= 1000)}
    Res := (Screen.ActiveControl.Name = 'RlCalc') Or
           (Screen.ActiveControl.Name = 'RlLink')            { Currency Edit }
  Else
    If Screen.ActiveControl Is Text8Pt Then
      {Res := (Screen.ActiveControl.Tag >= 1000);}
      Res := (Screen.ActiveControl.Name = 'RlRecSel') Or
             (Screen.ActiveControl.Name = 'RlPrnSel');


  SelectField1.Enabled := Res;
end;


procedure TForm_RWMain.SelectField1Click(Sender: TObject);
Var
  KPress : Word;
begin
  {  }
  If Screen.ActiveControl Is TMemo Then
    With Screen.ActiveControl As TMemo Do Begin
      If Assigned(OnKeyDown) Then Begin
        KPress := VK_F2;
        OnKeyDown(Screen.ActiveControl, KPress, []);
      End; { If }
    End { With }
  Else
    If Screen.ActiveControl Is Text8Pt Then
      With Screen.ActiveControl As Text8Pt Do Begin
        If Assigned(OnKeyDown) Then Begin
          KPress := VK_F2;
          OnKeyDown(Screen.ActiveControl, KPress, []);
        End; { If }
      End { With }
    Else
      If Screen.ActiveControl Is TCurrencyEdit Then
        With Screen.ActiveControl As TCurrencyEdit Do Begin
          If Assigned(OnKeyDown) Then Begin
            KPress := VK_F2;
            OnKeyDown(Screen.ActiveControl, KPress, []);
          End; { If }
        End; { With }
end;

procedure TForm_RWMain.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Reset_NonClientInfo;
end;


procedure TForm_RWMain.EntException(Sender  :  TObject; E  :  Exception);
Var
  Msg  :  String;
Begin
  Try
    {Application.ShowException(E);

    AddErrorLog(E.Message,'',0);}

    Msg := E.Message;

    MessageBox(0, PChar(Msg), 'Application Error', mb_Ok or mb_IconStop or mb_TaskModal);

    {AddErrorLog(Msg,'',0);}

  except
    On E: Exception do
      Begin
        Application.ShowException(E);
      end;
  end;
end; {PRoc..}


procedure TForm_RWMain.ApplicationActive(Sender : TObject);
{Var
  Message  :  TMessage;}
Begin
  (* Enterprise background redrawing code - not applicable to FormDes
  FillChar(Message,Sizeof(Message),0);
  ResetPalette(Message);
  MDI_ForceParentBKGnd(BOn);
  *)

  Application.Title:='Report Writer - Exchequer Enterprise. ' + Syss.UserName;
end;

procedure TForm_RWMain.EntDeActivate(Sender : TObject);
Begin
  Application.Title := Syss.UserName+'. Report Writer - Exchequer Enterprise';
end;


Initialization
  ExitSave:=ExitProc;
  ExitProc:=@Ex_Abort;
end.
