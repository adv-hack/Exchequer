unit PILICNCE;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, BorBtns, ComCtrls, WiseUtil;

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

// Displays the Licence Agreement Dialog
function DisplayLicence : smallint; StdCall; export;

// Wrapper function around DisplayLicence to allow it to be called from
// the WISE Setup Programs
function Wise7_DisplayLicence(var DLLParams: ParamRec): LongBool; StdCall; export;


implementation

{$R *.DFM}

Const
  posRTFHOfs    = 1;   // HM 09/07/99: Horizontal and Vertical around wrong way!!!
  posRTFVOfs    = 2;
  posBtnPrnHOfs = 3;

var
  sInstallDir, sPlugInDesc : string;

function Wise7_DisplayLicence(var DLLParams: ParamRec): LongBool;
// Wrapper function around DisplayLicence to allow it to be called from
// the WISE Setup Programs
Begin

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'PLUGINDESC', sPlugInDesc);

  { Get Installation Source directory }
  GetVariable(DLLParams, 'INST', sInstallDir);

  { Set Result After Calling DisplayLicence}
  SetVariable(DLLParams, 'FUNCRES', IntToStr(DisplayLicence));

End;

{----------------------------------------------------------------------------}

function DisplayLicence : smallint;
// Displays the Licence Agreement Dialog
//
// Return Values :      0       =       Exit Installation
//                      1       =       Licence Agreement Declined
//                      2       =       Licence Agreement Accepted

var
  frmLicence              : TfrmLicence;
  LicPath : String;
Begin { DispEntLicence }

  LicPath := IncludeTrailingBackslash(sInstallDir) + 'PILICNCE.RTF';

  frmLicence := TfrmLicence.Create(Application);
  Try
    With frmLicence Do Begin
      { Resize for the resolution }
      AutoResize (1, 1);

      { Load licence RTF file from CD }
      If FileExists(LicPath) Then rtfLicence.Lines.LoadFromFile(LicPath);

      ShowModal;

      Case ExitCode Of
        'X' : Result := 0;
        'B' : Result := 1;
        'N' : Result := 2;
      End; {case}
    End; { With }
  Finally
    frmLicence.Free;
  End;
End; {DisplayLicence}


procedure TfrmLicence.FormCreate(Sender: TObject);
begin
  inherited;
  { Generate postion data for dynamic resizing }
  LocPosData[posRTFHOfs]   := Height - rtfLicence.Height;
  LocPosData[posRTFVOfs]   := Width - rtfLicence.Width;
  LocPosData[posBtnPrnHOfs] := BackBtn.Left - btnPrint.Left;
  Caption := 'Licence Agreement';
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
  rtfLicence.Print(sPlugInDesc);
end;

end.
