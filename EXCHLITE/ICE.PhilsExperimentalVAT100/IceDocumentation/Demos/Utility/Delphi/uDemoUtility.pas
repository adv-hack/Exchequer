Unit uDemoUtility;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  // add the dsr utility here...
  DSRUtility_TLB
  ;

const
  cXML =

'<?xml version="1.0"?>'+
'<val:version xmlns:val="urn:www-iris-co-uk:version">'+
'<message guid="{04A2802D-10B3-4244-9467-DDC38A26D33E}" number="1" count="1" ' +
'  source="test@exchequer.com" destination="test2@exchequer.com" flag="0" plugin="Sys" datatype="16" desc="" '+
'  xsl="version.xsl" xsd="version.xsd" startperiod="0" startyear="0" endperiod="0" endyear="0">'+
'		<vrdetails>'+
'			<vrmodule>2</vrmodule>'+
'			<vrcurrency>2</vrcurrency>'+
'			<vrproduct>1</vrproduct>'   +
'		</vrdetails>' +
'		<vrmodules>' +
'			<vrinstalled>4</vrinstalled>'+
'			<vrinstalled>10</vrinstalled>'+
'			<vrinstalled>20</vrinstalled>'+
'			<vrinstalled>21</vrinstalled>'+
'		</vrmodules>'+
'	</message>'+
'</val:version>';

Type
  {DSR record structure}
  PFileHeader = ^TFileHeader;
  TFileHeader = Record
    StartChar: Char;
    BatchId: String[38]; { batch identification }
    Version,            { version of DSR }
    ExCode: String[16]; {exchequer company code}
    CompGuid: String[38]; {company guid. Added for better security}
    CheckSum, { check sum of the file }
      Order, { order of the file. }
      Total, { total files of the batch }
      Split, { if this file contains more parts }
      SplitTotal, { total of parts }
      SplitCheckSum: Longword; { check sum of part }
    Flags: Word; { kind of message }
    Mode: shortint;
    EndChar: Char;
  End;

  TfrmDemoUtility = Class(TForm)
    btnCompress: TButton;
    btnDecompress: TButton;
    btnEncrypt: TButton;
    btnDecrypt: TButton;
    odFiles: TOpenDialog;
    btnGetXml: TButton;
    btnCreateFile: TButton;
    Procedure FormCreate(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure btnCompressClick(Sender: TObject);
    Procedure btnDecompressClick(Sender: TObject);
    Procedure btnEncryptClick(Sender: TObject);
    Procedure btnDecryptClick(Sender: TObject);
    procedure btnGetXmlClick(Sender: TObject);
    procedure btnCreateFileClick(Sender: TObject);
  Private
    // declare a com object
    fUtil: IDSRUtil;
  Public
  End;

Var
  frmDemoUtility: TfrmDemoUtility;

Implementation

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: FormCreate
-----------------------------------------------------------------------------}
Procedure TfrmDemoUtility.FormCreate(Sender: TObject);
Begin
  fUtil := CoDSRUtil.Create;
End;

{-----------------------------------------------------------------------------
  Procedure: FormClose
-----------------------------------------------------------------------------}
Procedure TfrmDemoUtility.FormClose(Sender: TObject;
  Var Action: TCloseAction);
Begin
  If Assigned(fUtil) Then
    fUtil := Nil;
End;

{-----------------------------------------------------------------------------
  Procedure: btnCompressClick
-----------------------------------------------------------------------------}
Procedure TfrmDemoUtility.btnCompressClick(Sender: TObject);
Var
  lResult: WordBool;
Begin
  If odFiles.Execute Then
  Begin
    If Assigned(fUtil) Then
    Begin
      lResult := fUtil.Compress(odFiles.FileName, '');

      If lResult Then
        ShowMessage('Sucess')
      Else
        ShowMessage('Failure')
    End; // if assigned
  End; // if execute
End;

{-----------------------------------------------------------------------------
  Procedure: btnDecompressClick
-----------------------------------------------------------------------------}
Procedure TfrmDemoUtility.btnDecompressClick(Sender: TObject);
Var
  lResult: WordBool;
Begin
  If odFiles.Execute Then
  Begin
    If Assigned(fUtil) Then
    Begin
      lResult := fUtil.DeCompress(odFiles.FileName, '');

      If lResult Then
        ShowMessage('Sucess')
      Else
        ShowMessage('Failure')
    End; // if assigned
  End; // if execute
End;

{-----------------------------------------------------------------------------
  Procedure: btnEncryptClick
-----------------------------------------------------------------------------}
Procedure TfrmDemoUtility.btnEncryptClick(Sender: TObject);
Var
  lResult: WordBool;
Begin
  If odFiles.Execute Then
  Begin
    If Assigned(fUtil) Then
    Begin
      lResult := fUtil.EnCrypt(odFiles.FileName, '');

      If lResult Then
        ShowMessage('Sucess')
      Else
        ShowMessage('Failure')
    End; // if assigned
  End; // if execute
End;

{-----------------------------------------------------------------------------
  Procedure: btnDecryptClick
-----------------------------------------------------------------------------}
Procedure TfrmDemoUtility.btnDecryptClick(Sender: TObject);
Var
  lResult: WordBool;
Begin
  If odFiles.Execute Then
  Begin
    If Assigned(fUtil) Then
    Begin
      lResult := fUtil.Decrypt(odFiles.FileName, '');

      If lResult Then
        ShowMessage('Sucess')
      Else
        ShowMessage('Failure')
    End; // if assigned
  End; // if execute
End;

{-----------------------------------------------------------------------------
  Procedure: btnGetXmlClick
-----------------------------------------------------------------------------}
procedure TfrmDemoUtility.btnGetXmlClick(Sender: TObject);
Var
  lResult: WideString;
Begin
  If odFiles.Execute Then
  Begin
    If Assigned(fUtil) Then
    Begin
      lResult := fUtil.GetXml(odFiles.FileName);

      If lResult <> '' Then
        ShowMessage('Sucess')
      Else
        ShowMessage('Failure')
    End; // if assigned
  End; // if execute
end;

procedure TfrmDemoUtility.btnCreateFileClick(Sender: TObject);
var
  lFileHeader: TFileHeader;
begin
   if Assigned(fUtil) then
   begin

     FillChar(lFileHeader, SizeOf(TFileHeader), 0);
     with lFileHeader do
     begin
      StartChar := '|';
      BatchId := '{61020536-110A-4993-BE22-BDDCD6EDF2DD}';
      Version := '0.0.0.0h';
      ExCode:= 'COMP01';
      CompGuid:= '{04C276B2-B6D3-4D8B-9384-61536DFD7FDC}';
      Flags:= 0;
      Mode:= 0;
      EndChar:= '|';
     end;

     fUtil.CreateDSRFile(
        pChar(@lFileHeader),
        ExtractFilePath(Application.ExeName) + 'Sample.xml',
        cXML);
   end;
end;

End.

