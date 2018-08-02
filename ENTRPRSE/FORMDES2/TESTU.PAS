unit TestU;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, Menus, GlobType;

type
  TForm_MDIMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    SpeedButton1: TSpeedButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Print1: TMenuItem;
    PrintPCC: TMenuItem;
    Window1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    Tile1: TMenuItem;
    ArrangeIcons1: TMenuItem;
    MinimizeAll1: TMenuItem;
    About1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure PrintPCCClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Tile1Click(Sender: TObject);
    procedure ArrangeIcons1Click(Sender: TObject);
    procedure MinimizeAll1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
    { Private declarations }
    InPrint : Boolean;
    PrintHwnd : HWnd;
    procedure PrintProgress(var Msg: TMessage); message WM_PrintProgress;
  public
    { Public declarations }
  end;

var
  Form_MDIMain: TForm_MDIMain;
  BasePath : ShortString;

implementation

{$R *.DFM}

Uses GlobVar, VarConst, FormFile, Register, selfield, PrntForm,
     SysU1, SysU2, BtSupU1, BTSupU2, PrnCodes, RpDevice, PrintU, PCCOpts,
     ETDateU, EtStrU;

Var
  ExitSave    : Pointer;

Procedure Ex_Abort;  far;
Begin
  ExitProc:=ExitSave;

  Close_Files(BOn);
end;

Procedure sbsForm_DeInitialise; Export;
begin
  { Close the field select window }
  If Assigned (Form_SelectField) Then Begin
    Form_SelectField.Release;
    Form_SelectField := Nil;
  End; { If }

  { Free any preview windows floating about }
  FreePrevWins;

  { Close Files }
  FF_CloseFiles (True); { True = ?? }

  { Close Btrieve }
End;

Function sbsForm_Initialise (    SysInfo : SystemInfoType;
                             Var CRTab   : Boolean) : Boolean; Export;
Type
  VerRec   =  Record
                Ver,Rel  :  Integer;
                Typ      :  Char;
              end;
Var
  n       : Byte;
  ConRec  : Array[1..3] of VerRec;
begin
  Result := True;

  SystemInfo := SysInfo;
  { Make sure its turned off for Exchequer }
  {SystemInfo.DebugOpen := SystemInfo.DebugOpen And
                          Assigned(SystemInfo.ControllerHandle);}

  SetDrive := SysInfo.ExDataPath;

  { Open all data files }
  Open_System(1,TotFiles);

  { Open form designer data Files - merge with normal }
  If FF_OpenFiles Then Begin
    { Load system records }
    FF_Loadsys;
    TxLateCR := Syss.TxLateCR;
    CRTab := Syss.TxLateCR;

    { Initialise global arrays }
    Init_STDVATList;
    Init_STDCurrList;
    Init_STDDocTList;

    {$IFDEF STK}
      Init_STDStkTList;
      Init_STDValList;
    {$ENDIF}

    Set_SDefDecs;

    (*  HM 27/2/97 Moved to PrintFormDef in PrintU.Pas so updates to invoices are loaded
    { Get data into records for printing }
    FF_GetData;
    *)

    { Load DOS-type printer stuff }
    InitPrnCodes;
  End { If }
  Else Begin
    sbsForm_DeInitialise;
    Result := False;
  End; { Else }
end;

{---------------------------------------------------------------------------}

procedure TForm_MDIMain.FormCreate(Sender: TObject);
Var
  SysInfo : SystemInfoType;
  CRTab   : Boolean;
begin
  InPrint := False;
  PrintHwnd := 0;

  With SysInfo Do Begin
    ExVersionNo      := 11;
    MainForm         := Self;
    AppHandle        := Application;
    ExDataPath       := ExtractFilePath(Application.ExeName);
    ControllerHandle := Nil;
    DefaultFont      := Nil;
    FormDesVer       := '';
    DebugOpen        := False;
    AppPrinter       := Nil;
  End; { With }
  sbsForm_Initialise(SysInfo, CRTab);

  {$OPTIMIZATION OFF}
    RPDev.DeviceIndex := RPDev.DeviceIndex;
  {$OPTIMIZATION OFF}
end;

procedure TForm_MDIMain.FormDestroy(Sender: TObject);
begin
  sbsForm_DeInitialise;
end;

procedure TForm_MDIMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm_MDIMain.PrintPCCClick(Sender: TObject);
Var
  Form_PCCOpts : TForm_PCCOpts;
begin
  If RpDev.PrinterSetupDialog Then
    Form_PCCOpts := TForm_PCCOpts.Create(Application.MainForm);
end;

procedure TForm_MDIMain.N1Click(Sender: TObject);
begin
  Cascade;
end;

procedure TForm_MDIMain.Tile1Click(Sender: TObject);
begin
  Tile;
end;

procedure TForm_MDIMain.ArrangeIcons1Click(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TForm_MDIMain.MinimizeAll1Click(Sender: TObject);
var
  I: Integer;
begin
  { Must be done backwards through the MDIChildren array }
  for I := MDIChildCount - 1 downto 0 do
    MDIChildren[I].WindowState := wsMinimized;
end;

procedure TForm_MDIMain.About1Click(Sender: TObject);
begin
  ShowMessage ('SBSForm.DLL Testing Utility');
end;


procedure TForm_MDIMain.PrintProgress(var Msg: TMessage);
Begin
  With Msg Do Begin
    { Mode passes in WParam }
    Case WParam Of
      0  : ; { ? }
      1  : ; { Set Progress percentage within threads bar graph}

      { Set HWnd }
      2  : PrintHwnd := LParam;

      { Set InPrint Flag }
      3  : InPrint := (LParam = 1);

      { Check InPrint Flag }
      4  : SendMessage(LParam,WM_InPrint,Ord(InPrint),0);

      10 : ; { Clear Progress }
      11 : ; { Set Progress percentage }
    End; { Case }
  End; { With }
End;

Initialization
  ExitSave:=ExitProc;
  ExitProc:=@Ex_Abort;

  BasePath := ExtractFilePath (Application.ExeName);
  If Not (Copy(BasePath,Length(BasePath),1)[1] In [':', '\']) Then
    BasePath := BasePath + '\';
end.
