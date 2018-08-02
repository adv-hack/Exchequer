unit PIAboutF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, IAeverButton, EPOSCnst, GFXUtil
  , VarConst, FileUtil, Globvar, BtrvU2
{$IFDEF TCCU}
  , oTrade, PIAbFram
{$ENDIF}
  ;

type
  TfrmAbout = class(TForm)
    InstrLbl: TLabel;
    scrlPlugIns: TScrollBox;
    lVersion: TLabel;
    lTKVersion: TLabel;
    lCopyright: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    btnClose: TIAeverButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }

  {$IFDEF TCCU}
    FrameArray  : Array Of TPlugInAboutFrame;
  {$ENDIF}

    PlugInCount : Integer;
    NextTop     : Integer;
  public
    { Public declarations }
  {$IFDEF TCCU}
    Procedure AddPlugIn (Const PlugIn : TTradeConnectionPoint);
  {$ENDIF}
  end;

var
  frmAbout: TfrmAbout;

implementation
uses
  UseDllU, StrUtil, ExchequerRelease;

{$R *.dfm}

//---------------------------------------------------------------------------

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
{$IFNDEF TCCU}
  Height := 164;
{$ENDIF}

  PlugInCount := 0;
  NextTop := 1;

  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);

  lVersion.Caption := 'TCM Version : ' + ExchequerModuleVersion (emTradeCounter, sTCMVersionNumber);

  {$IFNDEF TCCU}
    lVersion.Caption := lVersion.Caption + ' (No Customisation)';
//    lVersion.Caption := lVersion.Caption + 'nc';
  {$ENDIF}

  lTKVersion.Caption := 'Toolkit Version : ' + EX_VERSION;
  lCopyright.Caption := GetCopyrightMessage;
end;

//---------------------------------------------------------------------------

{$IFDEF TCCU}
  // Adds the Plug-In Details into the ScrollBox
  procedure TfrmAbout.AddPlugIn(const PlugIn: TTradeConnectionPoint);
  begin
    Inc (PlugInCount);

    // Create a Frame for the Plug-In Security stuff
    SetLength (FrameArray, PlugInCount);
    FrameArray[Pred(PlugInCount)] := TPlugInAboutFrame.Create (Self);

    With FrameArray[Pred(PlugInCount)] Do Begin
      // Position within the Scroll Box
      Name := Name + IntToStr(PlugInCount);
      Parent := scrlPlugIns;
      Top := NextTop;
      Left := 1;

      // Set the Plug-In Details
      SetDets (PlugInCount, PlugIn);

      // Update position for next frame
      NextTop := NextTop + Height;
    End; { With FrameArray[Pred(PlugInCount)] }
  end;
{$ENDIF}
//---------------------------------------------------------------------------

procedure TfrmAbout.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//---------------------------------------------------------------------------

procedure TfrmAbout.Button1Click(Sender: TObject);
var
  sKey : Str255;
  iResult : integer;
begin
  FillChar(sKey,SizeOf(sKey),#0);
  iResult := Find_Rec(B_GetFirst, F[InvF], InvF, RecPtr[InvF]^, 2, sKey);
  while iResult = 0 do begin
    AddLineToFile(Inv.OurRef + #9 + Inv.UntilDate,'c:\inv.txt');
    iResult := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, 2, sKey);
  end;{while}
  Showmessage('done');
//  Showmessage(IntToStr(Sizeof(InvRec)));
end;

end.
