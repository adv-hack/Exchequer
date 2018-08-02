{-----------------------------------------------------------------------------
 Unit Name: uDashXMLViewer
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uCISResponse;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, HTMListB, AdvGlowButton, AdvPanel,

  MSXML2_TLB,

  ufrmbase, ComCtrls
  ;

Const
  cINFO = '%s CIS Response';
  cCISTITTLE = 'CIS Response';

Type
  //TfrmCISResponse = Class(TForm)
  TfrmCISResponse = Class(TFrmbase)
    advPanel: TAdvPanel;
    pnlButton: TAdvPanel;
    btnClose: TAdvGlowButton;
    lbFiles: THTMListBox;
    mmResponse: TMemo;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    btnPrint: TAdvGlowButton;
    Procedure FormKeyDown(Sender: TObject; Var Key: Word;
      Shift: TShiftState);
    Procedure btnCloseClick(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure lbFilesEnter(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure btnPrintClick(Sender: TObject);
  Private
    fDoc: DOMDocument;
    Procedure LoadXml(Const pXml: WideString);
  Public
    Procedure LoadXmlFileList(pGuid: TGuid);
  End;

Var
  frmCISResponse: TfrmCISResponse;

Implementation

Uses uConsts, uCommon, uDashSettings, uAdoDSR, uDSR, uInterfaces, printers,
  shellapi, uDashGlobal, strutils;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: FormKeyDown
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCISResponse.FormKeyDown(Sender: TObject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key = VK_ESCAPE Then
    btnCloseClick(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: LoadXml
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCISResponse.LoadXml(Const pXml: WideString);
Var
  lAck, lCorrelationId: String;
  lMessage: WideString;
  lNode: IXMLDOMNode;
  lNodeList: IXMLDOMNodeList;
  lCont: Integer;
Begin
  If pXml <> '' Then
  Begin
    mmResponse.Clear;

    If Assigned(fDoc) Then
    Begin
      fDoc.LoadXml('');
      fDoc.LoadXml(pXml);

      If fDoc.xml <> '' Then
      Begin
        lAck := Lowercase(_GetNodeValue(fDoc, cCISQUALIFIERNODE));
        lCorrelationId := _GetNodeValue(fDoc, cCORRELATIONIDNODE);

        mmResponse.Lines.Add('CIS ID: (' + ifthen(Trim(lCorrelationId) = '', 'none', Trim(lCorrelationId)) + ')');

        If lAck = Lowercase(cCISQUALIFIERACK) Then
          mmResponse.Lines.Add('Type of message: Acknowledgement (Message successfully sent)')
        Else If lAck = lowercase(cCISQUALIFIERERROR) Then
        Begin
          mmResponse.Lines.Add('Type of message: Error (An error has been returned)');
          mmResponse.Lines.Add('');

          Try
            lNode := _GetNodeByName(fDoc, 'ErrorResponse');

            If lNode = Nil Then
            Begin
              lNode := _GetNodeByName(fDoc, 'Error');
              lNodeList := lNode.childNodes;
            End
            Else
              lNodeList := lNode.selectNodes('Error');

            {load node details from the xml}
            If lNodeList <> Nil Then
              For lCont := 0 To lNodeList.length - 1 Do
              if lNodeList.item[lCont] <> nil then
                if lNodeList.item[lCont].hasChildNodes then
                Begin
                  mmResponse.Lines.Add('Error identifier ' + inttostr(lCont + 1));
                  mmResponse.Lines.Add('');
                  mmResponse.Lines.Add('Raized by: ' +
                    _GetNodeValue(lNodeList.item[lCont], 'RaisedBy'));
                  mmResponse.Lines.Add('Number: ' +
                    _GetNodeValue(lNodeList.item[lCont], 'Number'));
                  mmResponse.Lines.Add('Type: ' +
                    _GetNodeValue(lNodeList.item[lCont], 'Type'));
                  mmResponse.Lines.Add('Text: ' +
                    _GetNodeValue(lNodeList.item[lCont], 'Text'));
                  mmResponse.Lines.Add('Location: ' +
                    _GetNodeValue(lNodeList.item[lCont], 'Location'));
                  mmResponse.Lines.Add('');
                End; {for lCont:= 0 to lNodeList.length - 1 do}
          Except
          End;
        End
        Else If lAck = lowercase(cCISQUALIFIERRESPONSE) Then
        Begin
          mmResponse.Lines.Add('Type of message: Response (Message processed)');
          mmResponse.Lines.Add('');

        {load message from the gateway (if there is any)}
          Try
            lMessage := _GetNodeValue(fDoc, cCISQUALIFIERMESSAGE);
          Except
            lMessage := '';
          End;

          If Trim(lMessage) <> '' Then
          Begin
          {remove wrong ctrl characters}
            lMessage := StringReplace(lMessage, #10, #13 + #10, [rfReplaceAll]);

            mmResponse.Lines.Add('CIS Message: ');
            mmResponse.Lines.Add('');
            mmResponse.Lines.Add(lMessage);
          End; {if Trim(lMessage) <> '' then}
        End; {else begin}
      End
      Else
        mmResponse.Lines.Add('The required CIS XML response could not bed loaded.');
    End
    Else
      mmResponse.Lines.Add('The required CIS XML response could not bed loaded.');
  End {If pXml <> '' Then}
  Else
    mmResponse.Lines.Add('The required CIS XML response could not bed loaded.')
End;

{-----------------------------------------------------------------------------
  Procedure: btnCloseClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCISResponse.btnCloseClick(Sender: TObject);
Begin
  Close;
End;

{-----------------------------------------------------------------------------
  Procedure: FormClose
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCISResponse.FormClose(Sender: TObject;
  Var Action: TCloseAction);
Var
  lCont: Integer;
  lObj: TCISMessage;
Begin
  If lbFiles.Items.Count > 0 Then
    For lCont := lbFiles.Items.Count - 1 Downto 0 Do
      If lbFiles.Items.Objects[lCont] <> Nil Then
      Begin
        lObj := TCISMessage(lbFiles.Items.Objects[lCont]);
        If Assigned(lObj) Then
          lObj.Free;
      End; {If lbFiles.Items.Objects[lCont] <> Nil Then}

  If Assigned(fDoc) Then
    fDoc := Nil;
End;

{-----------------------------------------------------------------------------
  Procedure: LoadXmlFileList
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCISResponse.LoadXmlFileList(pGuid: TGuid);
Var
  lCis: TCISMessage;
  lDb: TADODSR;
  lFileList: Olevariant;
  lTotal, lCont: Integer;
Begin
  Try
    lDb := TADODSR.Create(_DashboardGetDBServer);
  Except
    On e: exception Do
      _LogMSG('Error connecting database. Error: ' + e.message);
  End; {try}

  If Assigned(lDb) And lDb.Connected Then
  Begin
    lFileList := null;
    {load cis entries }
    lFileList := lDb.GetCISMessageDetail(pGuid);
    lTotal := _GetOlevariantArraySize(lFileList);
    If lTotal > 0 Then
    Begin
      For lCont := 0 To lTotal - 1 Do
      Begin
        lCis := _CreateCISMsgInfo(lFileList[lCont]);

        If Assigned(lCis) Then
          lbFiles.Items.AddObject('File ' + inttostr(lCont + 1), lCis);
      End; {For lCont := 0 To lTotal - 1 Do}

      If lbFiles.Items.Count > 0 Then
        lbFiles.ItemIndex := 0;
    End; {If lTotal > 0 Then}

    lDb.Free;
  End; {if Assigned(lDb) and lDb.Connected then}
End;

{-----------------------------------------------------------------------------
  Procedure: lbFilesEnter
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCISResponse.lbFilesEnter(Sender: TObject);
Var
  lXml: WideString;
  lOutGuid, lFilGuid: TGuid;
Begin
  If (lbFiles.Items.Count > 0) And (lbFiles.ItemIndex >= 0) Then
  Begin
    mmResponse.Clear;
    lXml := '';

    Try
      With lbFiles, lbFiles.Items Do
      Begin
        lOutGuid := StringToGUID(TCISMessage(Objects[ItemIndex]).OutboxGuid);
        lFilGuid := StringToGUID(TCISMessage(Objects[ItemIndex]).FileGuid);
      End; {With lbFiles, lbFiles.Items Do}

      TDsr.DSR_ViewCISResponse(_DashboardGetDSRServer, _DashboardGetDSRPort,
        lOutGuid, lFilGuid, lXml);
    Except
      On e: exception Do
        _LogMSG('lbFilesEnter :- Error loading xml. Error: ' + e.Message);
    End; {try}

    LoadXml(lXml);
  End; {if lbFiles.Items.Count > 0 then}
End;

{-----------------------------------------------------------------------------
  Procedure: FormCreate
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCISResponse.FormCreate(Sender: TObject);
Begin
  Inherited;

  {for some bloody reason, few xmls returned from ggw came in a format that
  our component (using domdocument40 because the validation) cann't load properly
  and i am forced to user a "normal" domdocument}
  Try
    fDoc := CoDOMDocument.Create;
  Except
    On e: exception Do
    Begin
      _LogMSG('TfrmCISResponse.FormCreate :- Error creating XML Object. Error: ' +
        e.Message);
      fDoc := Nil;
    End;
  End; {try}

  CheckCIS(_DashboardGetDBServer);

  lblInfo.Caption := Format(cINFO, [_GetProductName(glProductNameIndex)]);
End;

{-----------------------------------------------------------------------------
  Procedure: btnPrintClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmCISResponse.btnPrintClick(Sender: TObject);
Var
(*  Device: Array[0..255] Of Char;
  Driver: Array[0..255] Of Char;
  Port: Array[0..255] Of Char;
  S: String;
  hDeviceMode: THandle;
  lFile: String;*)

//  lAdvMemo: TAdvMemo;
  lRichEdit: TRichEdit;
  lText: String;
Begin
(*  Printer.PrinterIndex := -1; // select a printer, in this case default
  Printer.GetPrinter(Device, Driver, Port, hDeviceMode);
  S := Format('"%s" "%s" "%s"', [Device, Driver, Port]);

  lFile := _GetApplicationPath + 'CISReturn.txt';
  mmResponse.Lines.SaveToFile(lFile);

  ShellExecute(Handle, 'printto', PChar(lFile), PChar(S), Nil, SW_HIDE);*)

//  _LockControl(Advpanel, True);

//  RichEdit1.Print('Test');

(*
  lAdvMemo:= TAdvMemo.Create(Application);
  try
    try
      lAdvMemo.Visible := False;
    except
    end;

    lAdvMemo.Parent := advPanel;

    try
      lAdvMemo.Visible := False;
    except
    end;

    lAdvMemo.AutoIndent := True;
    lAdvMemo.Height := mmResponse.Height;
    lAdvMemo.Width := mmResponse.Width * 2;

    lAdvMemo.Font.Name := 'Courier New';
    lAdvMemo.PrintOptions.Title := 'CIS Response';

    lAdvMemo.Lines.Clear;
    lAdvMemo.Lines.Add('');

    lText := mmResponse.Lines.Text;

    lText := StringReplace(lText, #13+#10, #13, [rfReplaceAll]);

    //lAdvMemo.Lines.Add(mmResponse.Lines.Text);
    lAdvMemo.Lines.Text := #13+#13+lText;

    lAdvMemo.WordWrap := wwClientWidth;

    lAdvMemo.Print;
  finally
    FreeAndNil(lAdvMemo);
  end;

  //  _LockControl(Advpanel, False);
  *)


  lRichEdit:= TRichEdit.Create(Application);
  try
    lRichEdit.Visible := False;
    lRichEdit.Parent := Self;
    
    lText := mmResponse.Lines.Text;

    lText := StringReplace(lText, #13+#10, #13, [rfReplaceAll]);

    lRichEdit.Font.Name := 'Courier New';
    lRichEdit.Font.Size := 10;
    lRichEdit.Lines.Text := #13+#13+lText;
    lRichEdit.Lines.Insert(0, cCISTITTLE);


    lRichEdit.SelStart := 0;
    lRichEdit.SelLength := Length(lRichEdit.Lines[0]);

    if lRichEdit.SelText = cCISTITTLE then
      lRichEdit.Paragraph.Alignment := taCenter;

    lRichEdit.SelLength := 0;  

    lRichEdit.Print(cCISTITTLE);
  finally
    FreeAndNil(lRichEdit);
  end;

  Application.ProcessMessages;

  SelectNext(Sender as TWincontrol, True, True);
End;

End.

