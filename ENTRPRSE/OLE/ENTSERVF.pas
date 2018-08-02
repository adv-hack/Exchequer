unit entservf;

{ markd6 12:58 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, Menus, IniFiles;

type
  TForm_EnterpriseOleServer = class(TForm)
    List_Info: TListBox;
    Label_Ver: Label8;
    Panel_Bitmap: TPanel;
    Image_About256: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    AutoMin        : Boolean;
    OrigLCount     : Integer;
    SysMenuH       : HWnd;
    FOnUpdateStats : TNotifyEvent;

    procedure UpdateSysMenu;
    procedure SetSysMenu;
    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
    procedure SetupGraphics;
    Procedure SetUpStats(Value : TNotifyEvent);
  public
    { Public declarations }
    DispComps,
    DispStats  : Boolean;

    Procedure InitList;
    Property OnUpdateStats : TNotifyEvent read FOnUpdateStats write SetUpStats;
  end;

var
  Form_EnterpriseOleServer : TForm_EnterpriseOleServer;
  SkipLogon                : Boolean;  { Disable logon cos someone has cancelled }
  ShowGraphics             : Boolean = True;

implementation

{$R *.DFM}

Uses GlobVar, VarConst, BtrvU2, OleServr, History, PathUtil, VAOUtil, Brand;

Const
  CM_DispStats    = $F0;
  CM_DispComps    = $F1;
  CM_SkipLogon    = $F2;
  CM_DispGraphics = $F3;

Var
  ScrSaveActive  : ^Boolean;


Procedure TForm_EnterpriseOleServer.SetUpStats(Value : TNotifyEvent);
Begin
  FOnUpdateStats := Value;

  If Assigned (FOnUpdateStats) Then
    FOnUpdateStats(Self);
End;

Procedure TForm_EnterpriseOleServer.WMSysCommand(Var Message : TMessage);
Begin
  With Message do
    Case WParam of
      CM_DispStats    : Begin
                          DispStats := Not DispStats;

                          UpdateSysMenu;

                          InitList;
                          If Assigned (FOnUpdateStats) Then
                            FOnUpdateStats(Self);
                        End;
      CM_DispComps    : Begin
                          DispComps := Not DispComps;

                          UpdateSysMenu;

                          InitList;
                          If Assigned (FOnUpdateStats) Then
                            FOnUpdateStats(Self);
                        End;
      CM_SkipLogon    : Begin
                          SkipLogon := False;
                        End;

      CM_DispGraphics : Begin
                          ShowGraphics := Not ShowGraphics;

                          With TIniFile.Create (ChangeFileExt (Application.ExeName, '.INI')) Do
                            Try
                              WriteBool('SystemConfig', 'ShowGraphics', ShowGraphics)
                            Finally
                              Free;
                            End;

                          UpdateSysMenu;
                          SetupGraphics;
                        End;
    End; { Case }

  Inherited;
end;


{ Update check mark on system menu - disp stats }
procedure TForm_EnterpriseOleServer.UpdateSysMenu;
Var
  MF_Check  :  Integer;
Begin
  // HM 06/08/04: Don't show options for VAO system
  If (VAOInfo.vaoMode <> smVAO) Then
  Begin
    If DispComps then
      MF_Check:=MF_Checked
    else
      MF_Check:=0;

    ModifyMenu(SysMenuH,CM_DispComps,MF_ByCommand+MF_String+MF_Check,CM_DispComps,'&Display Companies');

    //----------------------------

    If ShowGraphics then
      MF_Check:=MF_Checked
    else
      MF_Check:=0;

    ModifyMenu(SysMenuH,CM_DispGraphics,MF_ByCommand+MF_String+MF_Check,CM_DispGraphics,'Display &Graphics');

    //----------------------------

    If DispStats then
      MF_Check:=MF_Checked
    else
      MF_Check:=0;

    ModifyMenu(SysMenuH,CM_DispStats,MF_ByCommand+MF_String+MF_Check,CM_DispStats,'D&isplay Statistics');
  End; // If (VAOInfo.vaoMode <> smVAO)
end;


{ Add options onto system menu }
procedure TForm_EnterpriseOleServer.SetSysMenu;
Begin
  // HM 06/08/04: Don't show options for VAO system
  If (VAOInfo.vaoMode <> smVAO) Then
  Begin
    SysMenuH:=GetSystemMenu(Handle,False);

    AppendMenu(SysMenuH,MF_SEPARATOR,0,'');

    AppendMenu(SysMenuH,MF_String,CM_DispComps,'');

    AppendMenu(SysMenuH,MF_String,CM_DispGraphics,'');

    AppendMenu(SysMenuH,MF_String,CM_DispStats,'');

    AppendMenu(SysMenuH,MF_SEPARATOR,0,'');

    AppendMenu(SysMenuH,MF_String,CM_SkipLogon,'Reset &Login Skipping');

    UpdateSysMenu;
  End; // If (VAOInfo.vaoMode <> smVAO)
end;


procedure TForm_EnterpriseOleServer.FormCreate(Sender: TObject);
Var
  oBranding : IProductBrandingFile;
  iLines, iText : SmallInt;
begin
  // MH 07/04/06: Rebranding for IAO/Exchequer support
  Caption := 'About ' + Branding.pbProductName + ' OLE Server';
  Application.Title := 'OLE Server - ' + Branding.pbProductName;

  // Check for the existance of the branding file for the about dialog
  If Branding.BrandingFileExists (ebfAbout) Then
  Begin
    oBranding := Branding.BrandingFile(ebfOLE);
    Try
      oBranding.ExtractImage (Image_About256, 'Logo');
    Finally
      oBranding := NIL;
    End; // Try..Finally

    oBranding := Branding.BrandingFile(ebfAbout);
    Try
      List_Info.Clear;
      iLines := oBranding.pbfData.GetInteger('OLELines', 0);
      For iText := 1 To iLines Do
      Begin
        List_Info.Items.Add(oBranding.pbfData.GetString('OLELine' + IntToStr(iText)));
      End; // With Memo1.Lines
    Finally
      oBranding := NIL;
    End; // Try..Finally
  End; // If Branding.BrandingFileExists (ebfAbout)

  { Add OLE Server path to list }
  List_Info.Items.Add ('');
  List_Info.Items.Add ('Exe Path: ' + LowerCase (PathToShort (Application.ExeName)));
  List_Info.Items.Add ('Company Path: ' + LowerCase (PathToShort (SetDrive)));

  AutoMin   := True;
  DispComps := False;
  DispStats := False;
  OrigLCount := List_Info.Items.Count;

  { Customise System Menu }
  SetSysMenu;

  { Set Tag to 1010, so window can be ID'd uniquely }
  SetWindowLong (Handle, GWL_USERDATA, 1020);

  Label_Ver.Caption := 'Server Version: ' + Trim(CurrVersion_OLE);

  SetupGraphics;
end;

// HM 11/03/02: Extended to support hiding Graphics for Terminal Server systems (AKA Mobile Destop)
procedure TForm_EnterpriseOleServer.SetupGraphics;
Begin { SetupGraphics }
  Panel_Bitmap.Visible := ShowGraphics;
End; { SetupGraphics }

procedure TForm_EnterpriseOleServer.FormActivate(Sender: TObject);
Var
  WaitTime : LongInt;

  { Returns time in seconds }
  Function TimeVal : LongInt;
  Var
    Hour, Min, Sec, MSec : Word;
  begin
    DecodeTime(Now, Hour, Min, Sec, MSec);

    Result := Sec + (60 * (Min + (Hour * 60)));
  end;

begin
  If AutoMin Then Begin
    { Wait 3 seconds }
    WaitTime := TimeVal + 3;
    Repeat
      Application.ProcessMessages;
    Until (TimeVal >= WaitTime);

    { Hide app }
    Application.Minimize;

    AutoMin := False;
  End; { If }
end;


Procedure TForm_EnterpriseOleServer.InitList;
Const
  FNum    = CompF;
  KeyPath : Integer = CompCodeK;
Var
  I         : Integer;
  KeyS, Sep : Str255;
Begin
  If (List_Info.Items.Count > OrigLCount) Then
    For I := OrigLCount To Pred(List_Info.Items.Count) Do
      List_Info.Items.Delete (OrigLCount);

  If DispComps Then Begin
    FillChar (Sep, SizeOf(Sep), '-');
    Sep[0] := #255;

    List_Info.Items.Add(Sep);
    List_Info.Items.Add('Companies: ');

    KeyS := cmCompDet;
    Status := Find_Rec(B_GetGEq, F[FNum], FNum, RecPtr[FNum]^, KeyPath, KeyS);
    While StatusOk And (Company^.RecPFix = cmCompDet) Do Begin
      With Company^, CompDet Do
        List_Info.Items.Add('  ' + CompCode + #9 + CompName);

      Status := Find_Rec(B_GetNext, F[FNum], FNum, RecPtr[FNum]^, KeyPath, KeyS);
    End; { While }
  End; { If }

End;


procedure TForm_EnterpriseOleServer.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
Var
  MsgStr : ShortString;
begin
  If (Instances > 0) Then Begin
    MsgStr := IntToStr(Instances) + ' client';
    If (Instances > 1) Then
      MsgStr := MsgStr + 's are'
    Else
      MsgStr := MsgStr + ' is';
    MsgStr := MsgStr + ' still active. Closing the OLE Server while clients ' +
                       'are still active can cause the OLE Server and any clients ' +
                       'still running to crash.';

    CanClose := (MessageDlg (MsgStr +
                             #10#13#10#13 +
                             'Do you want to close the OLE Server anyway?',
                             mtWarning, [mbYes, mbNo], 0) = mrYes);
  End; { If }
end;

//----------------------------------------------------------------------------

Procedure CheckGraphics;
Begin { CheckGraphics }
  // HM 06/08/04: Don't show graphics for VAO system
  If (VAOInfo.vaoMode = smVAO) Then
  Begin
    ShowGraphics := False;
  End // If (VAOInfo.vaoMode = smVAO)
  Else
  Begin
    If FileExists (ChangeFileExt (Application.ExeName, '.INI')) Then
      With TIniFile.Create (ChangeFileExt (Application.ExeName, '.INI')) Do
        Try
          ShowGraphics := ReadBool('SystemConfig', 'ShowGraphics', True)
        Finally
          Free;
        End;
  End; // Else
End; { CheckGraphics }

//----------------------------------------------------------------------------

Initialization
  Application.HelpFile := ExtractFilePath(Application.ExeName) + 'EnterOle.Hlp';

  { Temporarily disable screen savers whilst OLE Server is running }
  New (ScrSaveActive);
  ScrSaveActive^ := False;
  If SystemParametersInfo(SPI_GETSCREENSAVEACTIVE,0,ScrSaveActive,0) Then Begin
    If ScrSaveActive^ Then
      SystemParametersInfo(SPI_SETSCREENSAVEACTIVE,0,Nil,0);
  End; { If }

  CheckGraphics;
Finalization
  { Restore screen saver }
  If Assigned(ScrSaveActive) Then Begin
    If ScrSaveActive^ Then Begin
      SystemParametersInfo(SPI_SETSCREENSAVEACTIVE,1,Nil,0);
    End; { If }

    Dispose (ScrSaveActive);
    ScrSaveActive := Nil;
  End; { If }
end.

