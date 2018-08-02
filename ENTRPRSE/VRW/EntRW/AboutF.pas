unit AboutF;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, TEditVal, SBSPanel, IniFiles;

type
  TAboutFrm= class(TForm)
    Memo1: TMemo;
    VerF: Label8;
    OkI1Btn: TButton;
    DLLVer: Label8;
    SBSPanel1: TSBSPanel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Implementation

Uses
  History,
  RptEngDll,
  Brand
  ;

{$R *.DFM}

procedure TAboutFrm.FormCreate(Sender: TObject);
var
  oBranding : IProductBrandingFile;
  iLines, iText : SmallInt;
begin
  VerF.Caption   := 'Version: ' + EntRWVer;
  DLLVer.Caption := 'Dll Version: ' + RepEngineDllVer;

  Caption := 'About ' + Branding.pbProductName + ' Visual Report Writer';

  // Check for the existance of the branding file for the about dialog
  If Branding.BrandingFileExists (ebfAbout) Then
  Begin
    oBranding := Branding.BrandingFile(ebfAbout);
    Try
      oBranding.ExtractImage (Image1, 'Logo');

      { CJS - 2013-07-08 - ABSEXCH-14438 - updated branding and copyright }
      // If (Branding.pbProduct = ptLITE) Then
      Begin
        Memo1.Lines.Clear;
        iLines := oBranding.pbfData.GetInteger('Lines', 0);
        For iText := 1 To iLines Do
        Begin
          Memo1.Lines.Add(oBranding.pbfData.GetString('Line' + IntToStr(iText)));
        End; // With Memo1.Lines
      End; // If (Branding.pbProduct = ptLITE)
    Finally
      oBranding := NIL;
    End; // Try..Finally
  End; // If Branding.BrandingFileExists (ebfAbout)

end;

procedure TAboutFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
