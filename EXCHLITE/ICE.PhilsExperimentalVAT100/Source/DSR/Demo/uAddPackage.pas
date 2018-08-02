Unit uAddPackage;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

Type
  TfrmAddPackage = Class(TForm)
    bgtnAddPackage: TButton;
    edtDescription: TEdit;
    edtUserReference: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtFileGuid: TEdit;
    Label3: TLabel;
    edtXml: TEdit;
    edtXSL: TEdit;
    edtXSD: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    btnXml: TSpeedButton;
    btnXSL: TSpeedButton;
    btnXSD: TSpeedButton;
    procedure btnXmlClick(Sender: TObject);
    procedure btnXSLClick(Sender: TObject);
    procedure btnXSDClick(Sender: TObject);
  Private
  Public
  End;

Var
  frmAddPackage: TfrmAddPackage;

Implementation

{$R *.dfm}

procedure TfrmAddPackage.btnXmlClick(Sender: TObject);
Var
  lFile: String;
Begin
  PromptForFileName(lFile, 'XML files (*.xml)|*.XML');
  edtXml.Text := lFile;
end;

procedure TfrmAddPackage.btnXSLClick(Sender: TObject);
Var
  lFile: String;
Begin
  PromptForFileName(lFile, 'XSL files (*.xsl)|*.XSL');
  edtXSL.Text := lFile;
end;

procedure TfrmAddPackage.btnXSDClick(Sender: TObject);
Var
  lFile: String;
Begin
  PromptForFileName(lFile, 'XSD files (*.xsd)|*.XSD');
  edtXSD.Text := lFile;
end;

End.

