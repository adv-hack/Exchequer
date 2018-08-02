unit DataPacketViewerF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GmXml, StdCtrls, Menus, FileCtrl, FlCtrlEx;

type
  TfrmDataPacketViewer = class(TForm)
    memInfo: TMemo;
    DirectoryListBoxEx1: TDirectoryListBoxEx;
    FileListBoxEx1: TFileListBoxEx;
    DriveComboBoxEx1: TDriveComboBoxEx;
    procedure FormCreate(Sender: TObject);
    procedure FileListBoxEx1Click(Sender: TObject);
  private
    { Private declarations }
    Procedure LoadDataPacket (Const DPPath : ANSIString);
    Procedure ProcessHexData (Const TaskFileName : ShortString; Const HexData : ANSIString);
  public
    { Public declarations }
  end;

var
  frmDataPacketViewer: TfrmDataPacketViewer;

implementation

{$R *.dfm}

Uses DPView_Document, DPView_History, DPView_CustSupp, DPView_Details,
  DPView_MLocStk, DPView_AccountContactRole;

//=========================================================================

procedure TfrmDataPacketViewer.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
  DirectoryListBoxEx1.Directory := 'C:\Temp\';
end;

//-------------------------------------------------------------------------

procedure TfrmDataPacketViewer.FileListBoxEx1Click(Sender: TObject);
begin
  LoadDataPacket (FileListBoxEx1.FileName)
end;

//-------------------------------------------------------------------------

Procedure TfrmDataPacketViewer.LoadDataPacket (Const DPPath : ANSIString);
Var
  oXML : TGmXML;
  oMainNode, oCompanyDetailsNode, oTaskDetailsNode, oDataPacketNode, oDataNode : TGmXMLNode;
  S, sTaskFileName : ShortString;
Begin // LoadDataPacket
  memInfo.Clear;

  // Crack the XML and display the data packet info
  oXML := TGmXML.Create(NIL);
  Try
    oXML.LoadFromFile(DPPath);

    oMainNode := oXML.Nodes.NodeByName['DataPacketDump'];
    If Assigned(oMainNode) Then
    Begin
      // Extraxt DataPacketDump attributes
      S := 'DataPacketDump (' + DPPath + ')';
      memInfo.Lines.Add (S);
      memInfo.Lines.Add (StringOfChar('=', Length(S)));
      memInfo.Lines.Add ('Date: ' + oMainNode.Attributes.ElementByName['Date'].Value);
      memInfo.Lines.Add ('Time: ' + oMainNode.Attributes.ElementByName['Time'].Value);
      memInfo.Lines.Add ('Machine: ' + oMainNode.Attributes.ElementByName['Machine'].Value);
      memInfo.Lines.Add ('User: ' + oMainNode.Attributes.ElementByName['User'].Value);

      oCompanyDetailsNode := oMainNode.Children.NodeByName['CompanyDetails'];
      If Assigned(oCompanyDetailsNode) Then
      Begin
        memInfo.Lines.Add ('');
        memInfo.Lines.Add ('CompanyDetails');
        memInfo.Lines.Add ('--------------');
        memInfo.Lines.Add ('Code: ' + oCompanyDetailsNode.Attributes.ElementByName['Code'].Value);
        memInfo.Lines.Add ('Path: ' + oCompanyDetailsNode.Attributes.ElementByName['Path'].Value);
      End; // If Assigned(oCompanyDetailsNode)

      oTaskDetailsNode := oMainNode.Children.NodeByName['TaskDetails'];
      If Assigned(oTaskDetailsNode) Then
      Begin
        sTaskFileName := oTaskDetailsNode.Attributes.ElementByName['Filename'].Value;

        memInfo.Lines.Add ('');
        memInfo.Lines.Add ('TaskDetails');
        memInfo.Lines.Add ('-----------');
        memInfo.Lines.Add ('Description: ' + oTaskDetailsNode.Attributes.ElementByName['Description'].Value);
        memInfo.Lines.Add ('Filename: ' + sTaskFileName);
      End; // If Assigned(oTaskDetailsNode)

      oDataPacketNode := oMainNode.Children.NodeByName['DataPacket'];
      If Assigned(oDataPacketNode) Then
      Begin
        memInfo.Lines.Add ('');
        memInfo.Lines.Add ('DataPacket');
        memInfo.Lines.Add ('-----------');
        memInfo.Lines.Add ('Position: ' + oDataPacketNode.Attributes.ElementByName['Position'].Value);
        memInfo.Lines.Add ('KeyString: ' + oDataPacketNode.Attributes.ElementByName['KeyString'].Value);

        oDataNode := oDataPacketNode.Children.NodeByName['Data'];
        If Assigned(oDataNode) Then
        Begin
          memInfo.Lines.Add ('Data: ' + oDataNode.AsString);
          memInfo.Lines.Add ('');
          ProcessHexData (sTaskFileName, oDataNode.AsString);
        End; // If Assigned(oDataNode)
      End; // If Assigned(oDataPacketNode)
    End; // If Assigned(oMainNode)
  Finally
    oXML.Free;
  End; // Try..Finally
End; // LoadDataPacket

//-------------------------------------------------------------------------

// Converts the raw data supplied in hex form, see below, into an array of byte for processing
// as a typed record to allow intelligent analysis
//
//   0x1B090000064B455649303100000000010950494E303231303336001425010001670308323030333033323808 ...
//
Procedure TfrmDataPacketViewer.ProcessHexData (Const TaskFileName : ShortString; Const HexData : ANSIString);
Var
  DataBlock : Array [1..10000] of Byte;
  DataLen, I : Integer;
  CharLine: string;
Begin // ProcessHexData
  If (Length(HexData) > 2) And ((Length(HexData) Mod 2) = 0) Then
  Begin
    DataLen := (Length(HexData) Div 2) - 1;
    FillChar(DataBlock, SizeOf(DataBlock), #0);

    CharLine := '';
    memInfo.Lines.Add ('DataString');
    memInfo.Lines.Add ('----------');

    // Skip the '0x' prefix and process the rest of the string
    For I := 2 To DataLen Do
    begin
      DataBlock[I-1] := StrToInt('$'+Copy(HexData,(I*2)-1, 2));
      // Build the ASCII-character string
      if (DataBlock[I-1] > 32) and (DataBlock[I-1] < 127) then
        CharLine := CharLine + Char(DataBlock[I-1])
      else
        CharLine := CharLine + '.';
      // Break the string at 80 characters
      if Length(CharLine) > 79 then
      begin
        memInfo.Lines.Add(CharLine);
        CharLine := '';
      end;
    end;

    memInfo.Lines.Add ('');

    If (UpperCase(TaskFileName) = 'TRANS\DOCUMENT.DAT') Then
    Begin
      ProcessDocument(memInfo, @DataBlock, DataLen);
    End // If (UpperCase(TaskFileName) = 'TRANS\DOCUMENT.DAT')
    Else If (UpperCase(TaskFileName) = 'TRANS\HISTORY.DAT') Then
    Begin
      ProcessHistory(memInfo, @DataBlock, DataLen);
    End // If (UpperCase(TaskFileName) = 'TRANS\DOCUMENT.DAT')
    Else If (UpperCase(TaskFileName) = 'CUST\CUSTSUPP.DAT') Then
    Begin
      ProcessCustSupp(memInfo, @DataBlock, DataLen);
    End // If (UpperCase(TaskFileName) = 'CUST\CUSTSUPP.DAT')
    Else If (UpperCase(TaskFileName) = 'TRANS\DETAILS.DAT') Then
    Begin
      ProcessDetails(memInfo, @DataBlock, DataLen);
    End // If (UpperCase(TaskFileName) = 'TRANS\DETAILS.DAT')
    Else If (UpperCase(TaskFileName) = 'STOCK\MLOCSTK.DAT') Then
    Begin
      ProcessMLocStk(memInfo, @DataBlock, DataLen);
    End // If (UpperCase(TaskFileName) = 'STOCK\MLOCSTK.DAT')
    Else If (UpperCase(TaskFileName) = 'CUST\ACCOUNTCONTACTROLE.DAT') Then
    Begin
      ProcessAccountContactRole(memInfo, @DataBlock, DataLen);
    End;
  End // If (Length(HexData) > 2) And ((Length(HexData) Div 2) = 0)
  Else
    MemInfo.Lines.Add ('*** Invalid Data String ***')
End; // ProcessHexData

//-------------------------------------------------------------------------

end.
