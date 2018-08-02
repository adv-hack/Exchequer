Unit uAddPackage;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, Activex;

Type
  TfrmAddPackage = Class(TForm)
    bgtnAddPackage: TButton;
    edtDescription: TEdit;
    edtUserReference: TEdit;
    Label1: TLabel;
    Label2: TLabel;
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
    edtFileGuid: TMaskEdit;
    Procedure btnXmlClick(Sender: TObject);
    Procedure btnXSLClick(Sender: TObject);
    Procedure btnXSDClick(Sender: TObject);
    Procedure bgtnAddPackageClick(Sender: TObject);
  Private
  Public
  End;

Var
  frmAddPackage: TfrmAddPackage;

Implementation

{$R *.dfm}

Procedure TfrmAddPackage.btnXmlClick(Sender: TObject);
Var
  lFile: String;
Begin
  PromptForFileName(lFile, 'XML files (*.xml)|*.XML');
  edtXml.Text := lFile;
End;

Procedure TfrmAddPackage.btnXSLClick(Sender: TObject);
Var
  lFile: String;
Begin
  PromptForFileName(lFile, 'XSL files (*.xsl)|*.XSL');
  edtXSL.Text := lFile;
End;

Procedure TfrmAddPackage.btnXSDClick(Sender: TObject);
Var
  lFile: String;
Begin
  PromptForFileName(lFile, 'XSD files (*.xsd)|*.XSD');
  edtXSD.Text := lFile;
End;

Procedure TfrmAddPackage.bgtnAddPackageClick(Sender: TObject);
var
  lGuid: TGuid;
Begin
  If edtDescription.Text = '' Then
  Begin
    ShowMessage('Invalid description!');
    Abort;
  End;

  lGuid :=  GUID_NULL;
  try
    lGuid := StringToGUID(edtFileGuid.Text);
  except
  end;

  if IsEqualGUID(lGuid, GUID_NULL) then begin
    ShowMessage('Invalid Guid!');
    Abort;
  end;

  If (edtXml.Text = '') Or Not FileExists(edtXml.Text) Then
  Begin
    ShowMessage('Invalid XML file!');
    Abort;
  End;

  If (edtXSL.Text = '') Or Not FileExists(edtXSL.Text) Then
  Begin
    ShowMessage('Invalid XSL file!');
    Abort;
  End;

  If (edtXSD.Text = '') Or Not FileExists(edtXSD.Text) Then
  Begin
    ShowMessage('Invalid XSD file!');
    Abort;
  End;

  If StrToIntDef(edtUserReference.Text, 0) <= 0 Then
  Begin
    ShowMessage('Invalid user reference!');
    Abort;
  End;

  ModalResult := mrOK;
End;

End.

