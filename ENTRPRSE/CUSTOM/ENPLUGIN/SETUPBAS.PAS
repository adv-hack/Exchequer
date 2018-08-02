unit SetupBas;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TSetupTemplate = class(TForm)
    HelpBtn: TButton;
    Panel1: TPanel;
    Bevel1: TBevel;
    ExitBtn: TButton;
    BackBtn: TButton;
    NextBtn: TButton;
    TitleLbl: TLabel;
    InstrLbl: TLabel;
    Image1: TImage;
    imgSide: TImage;
    procedure HelpBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FExitCode : Char;
    FExitMsg : Byte;
    WinPosData  : Array [1..9] Of LongInt;
    Procedure SetContext(Value : THelpContext);
    Procedure SetExitMsg(Value : Byte);
    Procedure SetInstructions(Value : ShortString);
    Procedure SetTitle(Value : ShortString);
  protected
    Function  ValidOk(VCode : Char) : Boolean; Virtual;
    Function  ReplaceStrings(InStr, ReplStr, NewStr : String) : String;
    Procedure DoBitmapStuff;
  public
    { 1=Overwrite Existing System }
    { 2=Upgrading Local Program Files directory (SCuD) }
    { 3=Upgrading and module ver is worsening e.g. SPOP->STK }
    { 4=Upgrading C/S to Non-C/S }
    { 5=Upgrading Global To Euro }
    { 6=Upgrading and User Count reducing }
    GlobFlags : Array[1..6] Of Byte;

    { Public declarations }
    Property ExitCode : Char read FExitCode write FExitCode;
    Property ExitMsg : Byte Read FExitMsg Write SetExitMsg;
    Property HelpContextID : THelpContext write SetContext;
    Property Instructions : ShortString write SetInstructions;
    Property Title : ShortString write SetTitle;

    Procedure AutoResize (Const VMode, HMode : Byte);
  end;

Var
  SetupTemplate: TSetupTemplate;

implementation

{$R *.DFM}

Const
  posBevelOfs    = 1;
  posBevelHOfs   = 2;
  posBtnTopOfs   = 3;
  posBtnNextOfs  = 4;
  posBtnBackOfs  = 5;
  posImgPanHOfs  = 6;
  posCaptLblOfs  = 7;
  posInstrLblOfs = 8;
  posImgHOfs     = 9;

{ Initialise local variables }
procedure TSetupTemplate.FormCreate(Sender: TObject);
Var
  I : Byte;
begin
  { HM 02/07/98: Centre on WISE Setup style screen - was formerly screen centred }
  {              which made it appear slightly low                               }
  Self.Left := (Screen.Width - Self.Width) Div 2;
  Self.Top := (Screen.Height - Self.Height - GetSystemMetrics(SM_CYCAPTION)) Div 2;

  Caption := 'Exchequer Accounting System Installation';
  ExitCode := '?';
  FExitMsg := 1;

  For I := Low(GlobFlags) To High(GlobFlags) Do
    GlobFlags[I] := 0;

  { Generate postion data for dynamic resizing }
  WinPosData[posBevelOfs]    := Height - Bevel1.Top;
  WinPosData[posBevelHOfs]   := Width - Bevel1.Width;

  WinPosData[posBtnTopOfs]   := Height - HelpBtn.Top;
  WinPosData[posBtnNextOfs]  := Width - NextBtn.Left;
  WinPosData[posBtnBackOfs]  := NextBtn.Left - BackBtn.Left;

  WinPosData[posImgPanHOfs]  := Height - Panel1.Height;
  WinPosData[posImgHOfs]     := Panel1.Height - Image1.Height;

  WinPosData[posCaptLblOfs]  := Width - TitleLbl.Width;
  WinPosData[posInstrLblOfs] := Width - InstrLbl.Width;

  { HM 11/10/99: Copy logo bitmap into temporary bitmap for dynamic resizing }
  imgSide.Picture.Bitmap.Assign (Image1.Picture.Bitmap);
  imgSide.Height := Image1.Height;
  imgSide.Width := Image1.Width;
  DoBitmapStuff;
end;

{ Sets the Help Context ID for a Dialog }
Procedure TSetupTemplate.SetContext(Value : THelpContext);
Begin
  If (Value <> Self.HelpContext) Then Begin
    Self.HelpContext := Value;
  End; { If }
End;

{ Sets the Instruction Label text }
Procedure TSetupTemplate.SetInstructions(Value : ShortString);
begin
  InstrLbl.Caption := Value;
end;

{ Sets the Title Label text }
Procedure TSetupTemplate.SetTitle(Value : ShortString);
begin
  TitleLbl.Caption := Value;
end;

{ Help Button }
procedure TSetupTemplate.HelpBtnClick(Sender: TObject);
begin
  If (HelpContext <> 0) Then
    Application.HelpContext (HelpContext);
end;

{ Exit Installation Button }
procedure TSetupTemplate.ExitBtnClick(Sender: TObject);
begin
  ExitCode := '?';
  Close;
end;

{ << Back button }
procedure TSetupTemplate.BackBtnClick(Sender: TObject);
begin
  If ValidOk('B') Then Begin
    ExitCode := 'B';
    Close;
  End; { If }
end;

{ Next >> button }
procedure TSetupTemplate.NextBtnClick(Sender: TObject);
begin
  If ValidOk('N') Then Begin
    ExitCode := 'N';
    Close;
  End { If }
end;

{ Perform any required validation - should be overridden }
Function TSetupTemplate.ValidOk(VCode : Char) : Boolean;
Begin
  ValidOk := True;
End;

procedure TSetupTemplate.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
Var
  TheText, TheCaption : AnsiString;
begin
  If (ExitCode = '?') And (ExitMsg <> 255) Then Begin
    Case FExitMsg Of
      { Security Code Wizard }
      2  : Begin
             TheText    := 'Are you sure you want to skip the Security Code Wizard';
             TheCaption := 'Security Code Wizard';
           End;
      { SCuD Conversion }
      3  : Begin
             TheText    := 'Are you sure you want to exit the Exchequer Conversion Program';
             TheCaption := 'Exchequer Conversion Program';
           End;

      { Miscellaneous }
      99 : Begin
             TheText    := 'Are you sure you want to exit ' + QuotedStr(TitleLbl.Caption);
             TheCaption := TitleLbl.Caption;
           End;

      { Miscellaneous - No Message }
      255 : ;
    Else
      TheText    := 'Are you sure you want to abort this installation?';
      TheCaption := 'Install';
    End; { Case }

    If (Application.MessageBox (PCHAR(TheText), PCHAR(TheCaption), MB_ICONQUESTION OR MB_YESNO) = IDYES) Then Begin
      ExitCode := 'X';
      CanClose := True;
    End { If }
    Else
      CanClose := False;
  End { If }
  Else
    CanClose := True;
end;


Procedure TSetupTemplate.AutoResize (Const VMode, HMode : Byte);
Var
  hScrRes, vScrRes : Byte;
Begin { AutoResize }
  With Screen Do Begin
    vScrRes := 0;
    If (Height < 600) Then Begin
      { Screen Resolution: - 800x600 }
      vScrRes := 1;
    End { If }
    Else Begin
      If (Height >= 600) And (Height < 768) Then Begin
        { Screen Resolution: 800x600 - 1024x768 }
        vScrRes := 2;
      End { If }
      Else Begin
        If (Height >= 768) Then Begin
          { Screen Resolution: 1024x768 - }
          vScrRes := 3;
        End { If }
      End; { Else }
    End; { Else }

    hScrRes := 0;
    If (Width < 800) Then Begin
      { Screen Resolution: - 800x600 }
      hScrRes := 1;
    End { If }
    Else Begin
      If (Width >= 800) And (Width < 1024) Then Begin
        { Screen Resolution: 800x600 - 1024x768 }
        hScrRes := 2;
      End { If }
      Else Begin
        If (Width >= 1024) Then Begin
          { Screen Resolution: 1024x768 - }
          hScrRes := 3;
        End { If }
      End; { Else }
    End; { Else }
  End; { With Screen }

  Case VMode Of
    { Licence Dialog - maximise height }
    1 : Begin
          Case vScrRes Of
            { 640x480 - Drop bottom down - top unchanged }
            1 : Self.Height := Trunc(((Screen.Height - Self.Top) * 0.9));

            { 800x600 }
            2 : Begin
                  Self.Top    := Trunc(Screen.Height * 0.16);
                  Self.Height := Trunc(((Screen.Height - Self.Top) * 0.9));
                End;

            { 1024x768 }
            3 : Begin
                  Self.Top    := Trunc(Screen.Height * 0.2);
                  Self.Height := Trunc(Screen.Height * 0.7);
                End;
          End { Case ScrRes }
        End;

    { Directory Dialog - subtle height increase }
    2 : Begin
          Case vScrRes Of
            { 800x600 }
            2 : Self.Height := Self.Height + Trunc((Screen.Height - Self.Height) * 0.3);

            { 1024x768 }
            3 : Begin
                  Self.Height := Self.Height + Trunc((Screen.Height - Self.Height) * 0.3);
                  Self.Top := (Screen.Height - Self.Height) Div 2;
                End;
          End { Case ScrRes }
        End;
  End; { Case VMode }

  Case HMode Of
    { Licence Dialog - maximise width }
    1 : Begin
          Self.Left := Trunc(Screen.Width * 0.05);
          Self.Width := Trunc(Screen.Width * 0.9);
        End;
  End; { Case HMode }

  FormResize(Self);
End; { AutoResize }

procedure TSetupTemplate.FormResize(Sender: TObject);
begin
  If ((Height - WinPosData[posImgPanHOfs] - WinPosData[posImgHOfs]) <= imgSide.Picture.Height) Then Begin
    { Repostion.Resize Bevel }
    Bevel1.Top := Height - WinPosData[posBevelOfs];
    Bevel1.Width := Width - WinPosData[posBevelHOfs];

    { Reposition Buttons }
    HelpBtn.Top := Height - WinPosData[posBtnTopOfs];
    ExitBtn.Top := HelpBtn.Top;
    BackBtn.Top := HelpBtn.Top;
    NextBtn.Top := HelpBtn.Top;

    NextBtn.Left := Width - WinPosData[posBtnNextOfs];
    BackBtn.Left := NextBtn.Left - WinPosData[posBtnBackOfs];

    { Resize Image }
    Panel1.Height := Height - WinPosData[posImgPanHOfs];
    Image1.Height := Panel1.Height - WinPosData[posImgHOfs];

    { Resize Title and Instruction labels }
    TitleLbl.Width := Width - WinPosData[posCaptLblOfs];
    InstrLbl.Width := Width - WinPosData[posInstrLblOfs];

    DoBitmapStuff;
  End { If }
  Else Begin
    Height := imgSide.Picture.Height + WinPosData[posImgPanHOfs] + WinPosData[posImgHOfs];
  End; { Else }
end;

{ HM 11/10/99: Added image resizing code for new bitmap }
Procedure TSetupTemplate.DoBitmapStuff;
Var
  FromRect, ToRect : TRect;
begin
  //Image1.Picture.Bitmap.Height := imgSide.Picture.Height;
  //Image1.Picture.Bitmap.Width := imgSide.Picture.Width;

  FromRect := Rect (0, imgSide.Picture.Height - Image1.Height, imgSide.Picture.Width, imgSide.Picture.Height);
  ToRect   := Rect (0, 0, Image1.Width, Image1.Height);

  Image1.Picture.Bitmap.Canvas.CopyRect(ToRect, imgSide.Picture.Bitmap.Canvas, FromRect);
end;

Function TSetupTemplate.ReplaceStrings(InStr, ReplStr, NewStr : String) : String;
Var
  TmpStr : String;
  I      : Integer;
begin
  TmpStr := InStr;

  I := Pos (ReplStr, TmpStr);

  While (I > 0) Do Begin
    Delete (TmpStr, I, Length(ReplStr));
    Insert (NewStr, TmpStr, I);

    I := Pos (ReplStr, TmpStr);
  End; { While }

  Result := TmpStr;
end;

Procedure TSetupTemplate.SetExitMsg(Value : Byte);
Begin { SetExitMsg }
  If (Value <> ExitMsg) Then Begin
    FExitMsg := Value;

    { Form Customisation }
    Case ExitMsg Of
      { Security Code Wizard }
      2 : ;

      { SCuD Conversion }
      3 : Begin
            { Hide Help button }
            HelpBtn.Visible := False;

            { and move Exit button into its place }
            ExitBtn.Caption := 'E&xit Convert';
            ExitBtn.Left := HelpBtn.Left;
          End;
    End; { Case }
  End { If }
End; { SetExitMsg }

end.



