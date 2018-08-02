unit PrnXML;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, GlobVar, VarConst,
     RpDevice;


Procedure xmlPrintBatch (Const WinTitle : ShortString;
                         Const PrnInfo  : TSBSPrintSetupInfo);

{ DEFINE XMLLOG}

{$IFDEF XMLLOG}
Var
  XmlLogF : TStringList;
{$ENDIF}


implementation


Uses BtrvU2, BtSupU1, GlobType, PrntForm, CommsInt, PrintU, XMLFuncs,
     PrntPrev, CompUtil, XMLInt, VAOUtil;

Var
  XMLIntO : TXMLInterface;

(*
Function LoadXMLDLL : Boolean;
Var
  InitInfo : xmlInitInfoType;
  ErrStr   : ShortString;
  Res      : SmallInt;
Begin { LoadXMLDLL }
  If (Not DLLOpen) Then Begin
    FillChar (InitInfo, SizeOf(InitInfo), #0);
    With InitInfo Do Begin
      xiDataPath := SetDrive;

      If FileExists (ExtractFilePath(Application.ExeName) + 'DEFMC044.SYS') Then
        { Euro/Multi-Currency }
        xiCcyVer := 2
      Else
        { Single-Currency }
        xiCcyVer := 0;
    End; { With }
    Res := xmlInitDLL (InitInfo);

    If (Res <> 0) Then Begin
      Case Res Of
        12    : ErrStr := 'Invalid Exchequer Path';
        13    : ErrStr := 'Not Multi Currency Version';
        15    : ErrStr := 'Attempted to import multi currency data into single currency system';
        16    : ErrStr := 'Attempted to import single-currency data into multi currency system';
        18    : ErrStr := 'Unable to open / find ExchDLL.INI';
        20    : ErrStr := 'Unable to locate Btrieve Library / Invalid Exchequer Path';
        32767 : ErrStr := 'Invalid DLL Release Code';
      Else
        ErrStr := 'Unknown Error';
      End; { Case }

      MessageDlg ('An error occured loading the XML routines' + #13#13 +
                  'Error ' + IntToStr(Res) + ': ' + ErrStr, mtError, [mbOk], 0);
    End; { If }

    DLLOpen := (Res = 0);
  End; { If (Not DLLOpen) }

  Result := DLLOpen;
End; { LoadXMLDLL }
*)

{---------------------------------------------------------------------------}

Procedure xmlPrintBatch (Const WinTitle : ShortString;
                         Const PrnInfo  : TSBSPrintSetupInfo);
Var
  CurrJob          : TPrintBatchObjType;
  EmailO           : TEntEmail;
  JobIdx, Res      : SmallInt;

  {------------------------------------------------------------------------}

  { Create an .XML file }
  Function CreateXMLFile : Boolean;
  Var
    Res       : SmallInt;
  Begin { CreateXMLFile }
    Result := False;

    Try
      With CurrJob.PrintBatch Do Begin
        ResetRec (InvF);

{$IFDEF XMLLOG}
  XmlLogF.Add ('  CreateXMLFile');
{$ENDIF}

        { Load Transaction }
        Status := Find_Rec (B_GetEq, F[pbMainFnum], pbMainFnum, RecPtr[pbMainFnum]^, pbMainKPath, pbMainKRef);

{$IFDEF XMLLOG}
  XmlLogF.Add ('    Key: ' + pbMainKRef + ' (' + IntToStr(pbMainKPath) + ')');
  XmlLogF.Add ('    Status: ' + IntToStr(Status));
{$ENDIF}

        If (Status = 0) Then Begin

{$IFDEF XMLLOG}
  XmlLogF.Add ('    XMLIntO.CreateXMLFile: ' + Inv.OurRef);
{$ENDIF}

          Res := XMLIntO.CreateXMLFile (Inv.OurRef);

{$IFDEF XMLLOG}
  XmlLogF.Add ('      Res: ' + IntToStr(Res));
  XmlLogF.Add ('      XMLPath: ' + XMLIntO.XMLPath);
{$ENDIF}

          Result := (Res = 0);
        End; { If }
      End; { With }
    Except
      Result := False;
    End;
  End; { CreateXMLFile }

  {------------------------------------------------------------------------}

  { Create an .HTM file }
  Function CreateHTMLFile : Boolean;
  Var
    HTMLInfo  : xmlHTMLInfoType;
    Res       : SmallInt;
  Begin { CreateHTMLFile }
    Result := False;

    Try
      With CurrJob.PrintBatch Do Begin
        Res := XMLIntO.CreateHTMFile;

        Result := (Res = 0);
      End; { With }
    Except
      Result := False;
    End;
  End; { CreateHTMLFile }

  {------------------------------------------------------------------------}

  { Copied from PrntForm.Pas }
  Procedure SplitRecipients (RecipStr  : AnsiString;
                             RecipAddr : TStringList);
  Var
    ColPos           : Integer;
    RecName, RecAddr : ShortString;
  Begin { SplitRecipients }
    { Clear out any existing crap }
    RecipAddr.Clear;

    RecipStr := Trim(RecipStr);
    If (RecipStr <> '') Then Begin
      While (RecipStr <> '') Do Begin
        { look for end of name }
        ColPos := Pos (';', RecipStr);
        If (ColPos > 0) Then Begin
          { Extract name from recipients string }
          RecName := Copy (RecipStr, 1, Pred(ColPos));
          Delete (RecipStr, 1, ColPos);

          { look for end of address }
          ColPos := Pos (';', RecipStr);
          If (ColPos > 0) Then Begin
            { Extract Address from recipients string }
            RecAddr := Copy (RecipStr, 1, Pred(ColPos));
            Delete (RecipStr, 1, ColPos);

            RecipAddr.Add (RecAddr);
          End { If }
          Else
            { Address not found - end loop }
            Break;
        End { If }
        Else
          { Name not found - end loop }
          Break;
      End; { While }
    End; { If }
  End; { SplitRecipients }

  {------------------------------------------------------------------------}

  Procedure SplitAttachments (AttachStr  : AnsiString;
                              AttachList : TStringList);
  Var
    ColPos           : Integer;
    AttPath, RecAddr : ShortString;
  Begin { SplitAttachments }
    { Clear out any existing crap }
    AttachList.Clear;

    AttachStr := Trim(AttachStr);
    While (AttachStr <> '') Do Begin
      { look for end of attachment }
      ColPos := Pos (';', AttachStr);
      If (ColPos > 0) Then Begin
        { Extract name from recipients string }
        AttPath := Copy (AttachStr, 1, Pred(ColPos));
        If FileExists (AttPath) Then
          AttachList.Add (AttPath);

        { Remove Crud }
        Delete (AttachStr, 1, ColPos);
        AttachStr := Trim(AttachStr);
      End { If (ColPos > 0) }
      Else Begin
        If FileExists (AttachStr) Then
          AttachList.Add (AttachStr);
        Break;
      End; { Else }
    End; { While }
  End; { SplitAttachments }

  {------------------------------------------------------------------------}

Begin { xmlPrintBatch }
  {ShowMessage ('xmlPrintBatch: ' + #13 +
               '  WinTitle: ' + WinTitle + #13 +
               '  fePrintMethod: ' + IntToStr(PrnInfo.fePrintMethod) + #13 +
               '  feXMLType: ' + IntToStr(PrnInfo.feXMLType) + #13 +
               '  feXMLCreateHTML: ' + IntToStr(Ord(PrnInfo.feXMLCreateHTML)));}

{$IFDEF XMLLOG}
  XmlLogF.Add ('xmlPrintBatch: ' + WinTitle);
  XmlLogF.Add ('  feXMLType: ' + IntToStr(PrnInfo.feXMLType));
{$ENDIF}

  If (Not Assigned(XMLIntO)) Then Begin
{$IFDEF XMLLOG}
  XmlLogF.Add ('  Create XMLIntO');
{$ENDIF}

    Try
      { Create interface object }
      XMLIntO := TXMLInterface.Create;

      { Initialise settings }
      With XMLIntO, PrnInfo Do Begin
        { Path to data }
        If (Trim(SetDrive) <> '') Then
          DataPath := PathToShort (SetDrive)
        Else
          DataPath := PathToShort (ExtractFilePath(Application.ExeName));

        { Currency version (Euro not supported at this time) }
        If FileExists (ExtractFilePath(Application.ExeName) + 'DEFMC044.SYS') Then
          { Euro/Multi-Currency }
          CurrVer := 2
        Else
          { Single-Currency }
          CurrVer := 0;

        { Path to save .XML and .HTM files in }
        If (PrnInfo.feXMLType = 0) Then
          { File - Save in specified directory }
          XMLPath := PrnInfo.feXMLFileDir
        Else
          { Email - Save in .EXE dir }
          XMLPath := ExtractFilePath(Application.ExeName);
        HTMPath := XMLPath;

        { Path of .XSL files }
        XSLPath := '';    { Unknown at this time }
      End; { With }

{$IFDEF XMLLOG}
  XmlLogF.Add ('    DataPath: ' + XMLIntO.DataPath);
  XmlLogF.Add ('    XMLPath: ' + XMLIntO.XMLPath);
  XmlLogF.Add ('    XSLPath: ' + XMLIntO.XSLPath);
  XmlLogF.Add ('    HTMPath: ' + XMLIntO.HTMPath);
{$ENDIF}

    Except
      XMLIntO := Nil;
    End;
  End; { If (Not Assigned(XMLIntO)) }

  If Assigned(XMLIntO) Then Begin
    { Load the XML DLL (if not already loaded) }
    Res := XMLIntO.LoadXMLDLL;

{$IFDEF XMLLOG}
  XmlLogF.Add ('  LoadXMLDLL: ' + IntToStr(Res));
{$ENDIF}

    If (Res = 0) Then Begin
      { Loaded OK or already loaded }
      With PrnInfo Do Begin
        If (feXMLType = 1) Then Begin
          { Email - Init Object }
          EmailO := TEntEmail.Create;
        End; { If (feXMLType = 1) }

        Try  { Finally }
          Try  { Except }
            If (feXMLType = 1) Then Begin
              { Email - Init Email details }
              With EmailO Do Begin
                { Setup email connection info }
                UseMAPI := PrnInfo.feEmailMAPI;
                SMTPServer := SyssEDI2^.EDI2Value.EmSMTP;

                // HM 02/06/00: Fixed as Name and Address around the wrong way
                { Set From details }
                SenderName := PrnInfo.feEmailFrom;
                Sender := PrnInfo.feEmailFromAd;

                { Set To Details }
                SplitRecipients (PrnInfo.feEmailTo, Recipients);
                SplitRecipients (PrnInfo.feEmailCC, CC);
                SplitRecipients (PrnInfo.feEmailBCC, BCC);

                Priority := PrnInfo.feEmailPriority;

                Subject := PrnInfo.feEmailSubj;
                Message := PCHAR(PrnInfo.feEmailMsg);

                SplitAttachments (PrnInfo.feEmailAttach, Attachments);
              End; { With EmailO }
            End; { If (feXMLType = 1) }

            { Pass through batch creating XML/HTML files }
            If (PrintBatchList.Count > 0) Then Begin
              JobIdx := 0;

              While (JobIdx < PrintBatchList.Count) Do Begin
                { Get job info }
                CurrJob := PrintBatchList.Items[JobIdx];

{$IFDEF XMLLOG}
  With CurrJob.PrintBatch Do Begin
    XmlLogF.Add ('  CurrJob:');
    XmlLogF.Add ('    pbDefMode: ' + IntToStr(pbDefMode));
    XmlLogF.Add ('    pbEFDName: ' + pbEFDName);
    XmlLogF.Add ('    pbMainFNum: ' + IntToStr(pbMainFNum));
    XmlLogF.Add ('    pbMainKPath: ' + IntToStr(pbMainKPath));
    XmlLogF.Add ('    pbMainKRef: ' + pbMainKRef);
  End; { With CurrJob.PrintBatch }
{$ENDIF}

                { Create XML file }
                If CreateXMLFile Then
                  If (feXMLType = 1) And (Trim(XMLIntO.XMLPath) <> '') Then Begin
                    { Add XML/HTML to email }
                    EmailO.Attachments.Add (XMLIntO.XMLPath);
                  End; { If (feXMLType = 1) }

                If feXMLCreateHTML Then Begin
                  { Create HTML file }
                  If CreateHTMLFile Then
                    If (feXMLType = 1) And (Trim(XMLIntO.HTMPath) <> '') Then Begin
                      { Add XML/HTML to email }
                      EmailO.Attachments.Add (XMLIntO.HTMPath);
                    End; { If (feXMLType = 1) }
                End; { If feXMLCreateHTML }

                Inc (JobIdx);
              End; { While }
            End; { If }

            If (feXMLType = 1) Then Begin
              { Email - Send it }
              // HM 25/01/05: Don't unload EntComms.Dll if running VAO
              Res := EmailO.Send(VAOInfo.vaoMode <> smVAO);

              If (Res > 0) Then Begin
                { Raise exception to report error }
                Raise EEmailErr.Create(EmailErr(Res));
              End; { If }

              { Delete attachments }
              If FileExists (XMLIntO.XMLPath) Then Begin
                DeletePrintFile(XMLIntO.XMLPath);
              End; { If }
              If FileExists (XMLIntO.HTMPath) Then Begin
                DeletePrintFile(XMLIntO.HTMPath);
              End; { If }
            End; { If (feXMLType = 1) }
          Except
            On Ex:Exception Do
              MessageDlg ('The following error occurred sending an email:' + #13#13 +
                          Ex.Message, mtError, [mbOk], 0);
          End;
        Finally
          If (feXMLType = 1) Then Begin
            { Email - Destroy interface object }
            EmailO.Destroy;
          End; { If (feXMLType = 1) }
        End;
      End; { With PrnInfo }
    End; { If LoadXMLDLL }

    XMLIntO.Destroy;
    XMLIntO := Nil;
  End; { If Assigned(XMLIntO) }

{$IFDEF XMLLOG}
  XmlLogF.Add ('------------------------------------------------------------');
{$ENDIF}
End; { xmlPPrintBatch }


Initialization
  XMLIntO := Nil;

  {$IFDEF XMLLOG}
    XmlLogF := TStringList.Create;
  {$ENDIF}

Finalization

  {$IFDEF XMLLOG}
    XmlLogF.SaveToFile ('c:\xmllog.txt');
    XmlLogF.Destroy;
  {$ENDIF}

end.
