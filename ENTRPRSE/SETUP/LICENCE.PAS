unit Licence;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns, ComCtrls;

type
  TfrmLicence = class(TSetupTemplate)
    rtfLicence: TRichEdit;
    btnPrint: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private
    { Private declarations }
    LocPosData  : Array [1..3] Of LongInt;
  public
    { Public declarations }
  end;

function DispEntLicence (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.DFM}

Uses CompUtil, IRISLicenceDLL;

Const
  posRTFHOfs    = 1;   // HM 09/07/99: Horizontal and Vertical around wrong way!!!
  posRTFVOfs    = 2;
  posBtnPrnHOfs = 3;


function DispEntLicence (var DLLParams: ParamRec): LongBool; StdCall; export;
var
  frmLicence              : TfrmLicence;
  DlgPN, LicPath, WiseStr : String;

  DLLPath, LicencePath    : ANSIString;
Begin { DispEntLicence }
  Result := False;

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  // Get Installation Source directory as basis for help file
  GetVariable(DLLParams, 'INST', WiseStr);
  FixPath(WiseStr);
  Application.HelpFile := WiseStr + 'SETUP.HLP';
  DLLPath := WiseStr + 'ExchLicence.Dll';

  // Get CD Source directory to pickup the licence text
  GetVariable(DLLParams, 'INST', WiseStr);
  While Not (WiseStr[Length(WiseStr)] In [':', '\']) Do Delete (WiseStr, Length(WiseStr), 1);
  FixPath(WiseStr);
  LicPath := WiseStr + 'Docs\';
  LicencePath := WiseStr + 'Docs\Exchequer.Licence';

  (*
  { Get Country }
  GetVariable(DLLParams, 'I_COUNTRY', WiseStr);
  Case StrToInt(WiseStr) Of
    { NZ }
    2 : LicPath := LicPath + 'LicNZ.RTF';
    { Singapore }
    3 : LicPath := LicPath + 'LicSING.RTF';
    { Australia }
    4 : LicPath := LicPath + 'LicAUSTR.RTF';
    { EIRE }
    5 : LicPath := LicPath + 'LicEIRE.RTF';
    { South Africa }
    6 : LicPath := LicPath + 'LicSAFR.RTF';
  Else
    { UK - also default and unknown }
    LicPath := LicPath + 'LicUK.RTF';
  End; { Case StrToInt(WiseStr) }
  *)

  With TIRISLicence.Create ('') Do
  Begin
    Try
      If (LoadDLL (PCHAR(DLLPath)) > 0) Then
      Begin
        If (ShowLicence(PCHAR(LicencePath)) = -1) Then
          SetVariable(DLLParams,'DIALOG','999')
        Else
          SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));
      End // If (LoadDLL (PCHAR(DLLPath)) > 0)
      Else
      Begin
        MessageDlg ('Unable to load Licence Information - please notify your technical support', mtError, [mbOK], 0);
        SetVariable(DLLParams,'DIALOG','999')
      End; // Else
    Finally
      Free;
    End; // Try..Finally
  End; // With TIRISLicence.Create ('...

(**** MH 05/03/2009: Modified to use IRISLicence.Dll
  { HM 18/08/99: Modified to have a general licence }
  LicPath := LicPath + 'LICENCE.RTF';

  frmLicence := TfrmLicence.Create(Application);
  Try
    With frmLicence Do Begin
      { Resize for the resolution }
      AutoResize (1, 1);

      { Load licence RTF file from CD }
      If FileExists(LicPath) Then Begin
        { Load Licence file }
        rtfLicence.Lines.LoadFromFile(LicPath);
      End; { If }

      ShowModal;

      Case ExitCode Of
        'N' : Begin { Next }
                SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));
              End;
        'B',        { Back }
        'X' : Begin { Exit Installation }
                SetVariable(DLLParams,'DIALOG','999')
              End;
      End; { If }
    End; { With }
  Finally
    frmLicence.Free;
  End;
****)


End; { DispEntLicence }

{----------------------------------------------------------------------------}

procedure TfrmLicence.FormCreate(Sender: TObject);
begin
  inherited;

  { Generate postion data for dynamic resizing }
  LocPosData[posRTFHOfs]   := Height - rtfLicence.Height;
  LocPosData[posRTFVOfs]   := Width - rtfLicence.Width;
  LocPosData[posBtnPrnHOfs] := BackBtn.Left - btnPrint.Left;
end;

procedure TfrmLicence.FormResize(Sender: TObject);
begin
  inherited;

  { Resize RTF }
  rtfLicence.Height := Height - LocPosData[posRTFHOfs];
  rtfLicence.Width := Width - LocPosData[posRTFVOfs];

  { Reposition Print button }
  btnPrint.Left := ExitBtn.Left;
  btnPrint.Top  := BackBtn.Top;
end;

procedure TfrmLicence.btnPrintClick(Sender: TObject);
begin
  inherited;

  rtfLicence.Print ('Exchequer Licence');
end;

end.
