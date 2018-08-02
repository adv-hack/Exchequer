unit ANCDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles, TEditVal, CustAbsU, FileCtrl, Progress;

type
  TfrmANCExport = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    grpCustomer: TGroupBox;
    lblName: TLabel;
    edtName: TEdit;
    lblAddress: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtAddr1: TEdit;
    edtAddr2: TEdit;
    edtTown: TEdit;
    edtCounty: TEdit;
    edtPostCode: TEdit;
    grpPackage: TGroupBox;
    lblBoxes: TLabel;
    lblWeight: TLabel;
    Label1: TLabel;
    lsService: TListBox;
    ccyBoxes: TCurrencyEdit;
    ccyWeight: TCurrencyEdit;
    btnExport: TButton;
    grpDelRefs: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    edtDespRef1: TEdit;
    edtDespRef2: TEdit;
    Label7: TLabel;
    edtTelephone: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
  private
    { Private declarations }
    frmProgress : TfrmProgress;
    EvData      : TAbsEnterpriseSystem;
    LocalMode   : Byte;
    LocalAcCode : ShortString;
    Procedure UpdateTrans;
  public
    { Public declarations }
    Function  ExportToANC : Boolean;
    Procedure SetData(Const EventData : TAbsEnterpriseSystem;
                      Const TransCode : ShortString;
                      Const Mode      : Byte);
    Procedure TidyUpANC;
  end;


Procedure ANCExport (Const EventData : TAbsEnterpriseSystem; Const Mode : Byte);


implementation

{$R *.DFM}

Uses
  FileUtil, UseDLLU;

Const
  SecCode     = 'SECTESTMODE';

{$I ExDLLBt.Inc}        {* BTrieve Command Constant File *}
{$I ExchDll.Inc}        {* Record Structure File *}

Type
  TListObj = Class(TObject)
  Public
    DefCode : String[30];
    ANCCode : String[3];
  End; { TListObj }

Var
  DefaultList   : TList;
  Services      : TStringList;
  UsingDefaults : Boolean;
  AncPath       : ShortString;
  ContractNo    : String[8];
  ExtMode       : Boolean;
  AncAccount    : String[10];
  SystemId      : ShortString;

{ Unit Initialization - load defaults list from .INI file }
Procedure Initio;
Var
  IniOptions  : TIniFile;
  NumItems, I : LongInt;
  Str1, Str2  : ShortString;
  LO          : TListObj;
Begin
  If Not Assigned(DefaultList) Then Begin
    { Create Lists }
    DefaultList := TList.Create;
    Services := TStringList.Create;

    { Load default codes from .INI file }
    IniOptions := TIniFile.Create (GetEnterpriseDirectory + 'ENANCEXP.INI');
    Try
      { Get Settings }
      AncPath := UpperCase(Trim(IniOptions.ReadString('Settings','ANCPath','')));
      ContractNo := Trim(IniOptions.ReadString('Settings','ANCContractNo',''));
      ExtMode := IniOptions.ReadBool ('Settings', 'ExtendedMode', False);
      AncAccount := Trim(IniOptions.ReadString ('Settings', 'ANCAccountNo', ''));
      SystemId := Trim(IniOptions.ReadString ('Settings', 'SystemId', ''));

      { Get Default Codes }
      NumItems := IniOptions.ReadInteger('DefaultCodes','NumDefaults',0);
      UsingDefaults := (NumItems > 0);

      If (NumItems > 0) Then
        For I := 1 To NumItems Do Begin
          { Add user tools option }
          Str1 := 'Def'+IntToStr(I);
          Str2 := '';

          { Get code }
          Str2 := Trim(IniOptions.ReadString('DefaultCodes',Str1,''));

          If (Str2 <> '') And (Pos('-', Str2) > 0) Then Begin
            LO := TListObj.Create;
            With LO Do Begin
              DefCode := UpperCase(Trim(Copy (Str2, 1, Pos('-', Str2) - 1)));
              ANCCode := UpperCase(Trim(Copy (Str2, Pos('-', Str2) + 1, 3))) + '   ';
            End; { With }

            DefaultList.Add (LO);
          End; { If }
        End; { For }

      { Get Service Codes }
      NumItems := IniOptions.ReadInteger('ServiceCodes','NumCodes',0);

      If (NumItems > 0) Then
        For I := 1 To NumItems Do Begin
          { Add user tools option }
          Str1 := 'Code'+IntToStr(I);
          Str2 := '';

          { Get title }
          Str2 := Trim(IniOptions.ReadString('ServiceCodes',Str1,''));

          If (Str2 <> '') And (Str2[4] = '-') Then Begin
            Services.Add (UpperCase(Copy(Str2,1,3)) + #9 + Trim(Copy(Str2,5,Length(Str2))));
          End; { If }
        End; { For }
    Finally
      IniOptions.Free;
    End; { Try }
  End; { If }
End;


{ Unit Finalization - unload list }
Procedure Finito;
Var
  LO : TListObj;
Begin
  If Assigned(DefaultList) Then Begin
    { Unload and deallocate all list items }
    While (DefaultList.Count > 0) Do Begin
      LO := TListObj (DefaultList.Items[0]);
      DefaultList.Delete(0);
      LO.Destroy;
    End; { While }

    Services.Destroy;

    { Destroy the list }
    DefaultList.Destroy;
  End; { With }
End;


{==============================================================================}


Procedure ANCExport (Const EventData : TAbsEnterpriseSystem; Const Mode : Byte);
Var
  frmANCExport : TfrmANCExport;
  OK           : Boolean;
  TransCode    : String[3];

  { Looks through the list of Default Codes for a matching code }
  Function FindDefault (Var TxlateCode : ShortString) : Boolean;
  Var
    CheckCode : ShortString;
    I         : SmallInt;
  Begin
    { Check to see if we are using the defaults }
    Result := False;
    TxlateCode := '';

    CheckCode := UpperCase(Trim(Copy(EventData.Transaction.thUser1,1,2)));

    { Step through defaults to find a match }
    If DefaultList.Count > 0 Then
      For I := 0 To Pred(DefaultList.Count) Do
        With TListObj (DefaultList.Items[I]) Do
          { check for match }
          If (DefCode = CheckCode) Then Begin
            Result := True;
            TxlateCode := ANCCode;
            Break;
          End; { If }
  End;

Begin
  With EventData Do Begin
    { Initialise the list of defaults }
    If Not Assigned(DefaultList) Then
      Initio;

    { Check that the ANC Path is valid }
    OK := DirectoryExists(ANCPath) And (AncPath[2] = ':') And (AncPath[3] = '\');
    If OK Then Begin
      { Check the ANC Contract Number is set }
      OK := (Trim(ContractNo) <> '');
      If OK Then Begin
        { Check that Transaction is an SOR }
        OK := (Mode <> 1) Or (Transaction.thInvDocHed = CUSOR);
        If OK Then Begin
          { Check the default is set }
          TransCode := '';
          OK := (Not UsingDefaults) Or (Mode <> 1) Or (UsingDefaults And FindDefault(TransCode));
          If OK Then Begin
            { Display dialog }
            frmANCExport := TfrmANCExport.Create(Application.MainForm);
            Try
              frmANCExport.SetData(EventData, TransCode, Mode);

              frmANCExport.ShowModal;
            Finally
              frmANCExport.Free;
            End; { Try }
          End { If }
          Else
            MessageDlg (Trim(Transaction.thOurRef) + ' is not setup for exporting to DeliverANCe 2000.', mtInformation, [mbOk], 0);
        End { If }
        Else
          MessageDlg ('The Export to DeliverANCe 2000 is only available for Sales Orders', mtInformation, [mbOk], 0);
      End { If }
      Else
        MessageDlg ('The ANC Contract Number in the configuration file is invalid:' + #13#10#13#10 + '"' + ContractNo + '"', mtInformation, [mbOk], 0);
    End { If }
    Else
      MessageDlg ('The ANC Path specified in configuration file is invalid:' + #13#10#13#10 + '"' + ANCPath + '"', mtInformation, [mbOk], 0);
  End; { With }
End;


{==============================================================================}


Procedure TfrmANCExport.FormCreate(Sender: TObject);
Begin
  { Centre over Enterprise }
  Top := Application.MainForm.Top + (Application.MainForm.Height div 2) - (Height Div 2);
  Left := Application.MainForm.Left + (Application.MainForm.Width div 2) - (Width Div 2);

  { Clear any design-time elements from the list }
  lsService.Clear;

  { Load ANC Service codes from .INI file }
  lsService.Items.Assign(Services);
End;


{ Display info and selects the default Service Code from the list }
Procedure TfrmANCExport.SetData(Const EventData : TAbsEnterpriseSystem;
                                Const TransCode : ShortString;
                                Const Mode      : Byte);
Var
  I : SmallInt;
Begin
  { record working mode on form }
  LocalMode := Mode;

  { Set customer details }
  With EventData, Transaction, Customer Do Begin
    Case Mode Of
      { Transaction }
//      1 : With Transaction, Customer Do Begin
      1 : With TABSInvoice5(Transaction), Customer Do Begin
            LocalAcCode := acCode;
            edtName.Text := Trim(acCompany);
            If (Trim(thDelAddr[1]) <> '') Then Begin
              { invoice delivery address }
              edtAddr1.Text    := Trim(thDelAddr[1]);
              edtAddr2.Text    := Trim(thDelAddr[2]);
              edtTown.Text     := Trim(thDelAddr[3]);
              edtCounty.Text   := Trim(thDelAddr[4]);
              edtPostCode.Text := Trim(thDelAddr[5]);
            End { If }
            Else Begin
              edtAddr1.Text    := Trim(acAddress[1]);
              edtAddr2.Text    := Trim(acAddress[2]);
              edtTown.Text     := Trim(acAddress[3]);
              edtCounty.Text   := Trim(acAddress[4]);

              {.208} // NF: Changed to support postcode field (where applicable}
              if Trim(acPostCode) = '' then edtPostCode.Text := Trim(acAddress[5])
              else edtPostCode.Text := Trim(acPostCode);
//              edtPostCode.Text := Trim(acAddress[5]);
            End; { Else }

            edtDespRef1.Text := thOurRef;
            
//            edtDespRef2.Text := thYourRef;
            edtDespRef2.Text := thYourRef20; // NF: 26/07/2007 Changed to support new 20 char yourref for v6

            // HM 17/09/04: Added Telephone No to export
            edtTelephone.Text := Trim(acPhone);
          End; { With }

      { Customer }
      2 : With Customer Do Begin
            LocalAcCode := acCode;
            edtName.Text := Trim(acCompany);
            If (Trim(acDelAddress[1]) <> '') Then Begin
              { invoice delivery address }
              edtAddr1.Text    := Trim(acDelAddress[1]);
              edtAddr2.Text    := Trim(acDelAddress[2]);
              edtTown.Text     := Trim(acDelAddress[3]);
              edtCounty.Text   := Trim(acDelAddress[4]);
              edtPostCode.Text := Trim(acDelAddress[5]);
            End { If }
            Else Begin
              edtAddr1.Text    := Trim(acAddress[1]);
              edtAddr2.Text    := Trim(acAddress[2]);
              edtTown.Text     := Trim(acAddress[3]);
              edtCounty.Text   := Trim(acAddress[4]);

              {.208} // NF: Changed to support postcode field (where applicable}
              if Trim(acPostCode) = '' then edtPostCode.Text := Trim(acAddress[5])
              else edtPostCode.Text := Trim(acPostCode);
//              edtPostCode.Text := Trim(acAddress[5]);
            End; { Else }

            // HM 17/09/04: Added Telephone No to export
            edtTelephone.Text := Trim(acPhone);
          End; { With Customer }

      { Supplier }
      3 : With Supplier Do Begin
            LocalAcCode := acCode;
            edtName.Text := Trim(acCompany);
            If (Trim(acDelAddress[1]) <> '') Then Begin
              { invoice delivery address }
              edtAddr1.Text    := Trim(acDelAddress[1]);
              edtAddr2.Text    := Trim(acDelAddress[2]);
              edtTown.Text     := Trim(acDelAddress[3]);
              edtCounty.Text   := Trim(acDelAddress[4]);
              edtPostCode.Text := Trim(acDelAddress[5]);
            End { If }
            Else Begin
              edtAddr1.Text    := Trim(acAddress[1]);
              edtAddr2.Text    := Trim(acAddress[2]);
              edtTown.Text     := Trim(acAddress[3]);
              edtCounty.Text   := Trim(acAddress[4]);

              {.208} // NF: Changed to support postcode field (where applicable}
              if Trim(acPostCode) = '' then edtPostCode.Text := Trim(acAddress[5])
              else edtPostCode.Text := Trim(acPostCode);
//              edtPostCode.Text := Trim(acAddress[5]);
            End; { Else }

            // HM 17/09/04: Added Telephone No to export
            edtTelephone.Text := Trim(acPhone);
          End; { With Supplier }
    End; { Case Mode }
  End; { With EventData }

  { Set standard entries }
  ccyBoxes.Value := 1;
  ccyWeight.Value := 1;

  edtDespRef1.ReadOnly := (LocalMode = 1);
  edtDespRef2.ReadOnly := (LocalMode = 1);

  { Set default Service Code }
  If (lsService.Items.Count > 0) Then Begin
    lsService.ItemIndex := -1;

    For I := 0 To Pred(lsService.Items.Count) Do
      If (Copy(lsService.Items.Strings[I], 1, 3) = TransCode) Then Begin
        lsService.ItemIndex := I;
        Break;
      End; { If }

    If (lsService.ItemIndex = -1) Then
      lsService.ItemIndex := 0;
  End; { If }

  { Take local copy of EventData Handle for use during the export }
  EvData := EventData;
End;


{ OK Button - Validate the info, close the dialog and continue the export }
procedure TfrmANCExport.btnOKClick(Sender: TObject);
Var
  OK : Boolean;
begin
  { Move focus to this button, this solves problem with CurrencyEdit controls }
  { not recognising the number until you leave the control.                   }
  btnOK.SetFocus;

  { Check name is OK }
  Ok := (Trim(edtName.Text) <> '');
  If Not OK Then Begin
    edtName.SetFocus;
    MessageDlg ('The Customers Name must be set', mtWarning, [mbOk], 0);
  End; { If }

  If OK Then Begin
    { Check Address is set }
    Ok := (Trim(edtAddr1.Text) <> '');
    If Not OK Then Begin
      edtAddr1.SetFocus;
      MessageDlg ('The Customers Address must be set', mtWarning, [mbOk], 0);
    End; { If }
  End; { If }

  If OK Then Begin
    { Check Number of Boxes is set }
    Ok := (ccyBoxes.Value >= 1) And (ccyBoxes.Value <= 999);
    If Not OK Then Begin
      ccyBoxes.SetFocus;
      MessageDlg ('The Number Of Boxes must be in the range 1 to 999', mtWarning, [mbOk], 0);
    End; { If }
  End; { If }

  If OK Then Begin
    { Check Weight is set }
    Ok := (ccyWeight.Value >= 0) And (ccyWeight.Value <= 999);
    If Not OK Then Begin
      ccyWeight.SetFocus;
      MessageDlg ('The Total Weight must be in the range 0 to 999 kilograms', mtWarning, [mbOk], 0);
    End; { If }
  End; { If }

  If OK Then Begin
    { Check Service is set }
    Ok := (lsService.ItemIndex > -1);
    If Not OK Then Begin
      lsService.SetFocus;
      MessageDlg ('An ANC Service must be selected from the list', mtWarning, [mbOk], 0);
    End; { If }
  End; { If }

  If OK Then Begin
    { Create progress dialog }
    frmProgress := TfrmProgress.Create(Self);
    Try
      { Display Progress form - export will auto-start on form activate }
      frmProgress.ShowModal;

      { Aborted set to true if want to remain on this dialog }
      If Not frmProgress.Aborted Then
        Close;
    Finally
      frmProgress.Free;
    End; { Try }
  End; { If }
end;


{ Cancel Button - Close dialog and cancel the export }
procedure TfrmANCExport.btnCancelClick(Sender: TObject);
begin
  Close;
end;


{ Export Data to DelivarANCe 2000 directory }
Function TfrmANCExport.ExportToANC : Boolean;
Var
  OutF              : TextFile;
  OutName, RepFName : ShortString;
  BatchNo           : String[3];
  FVar              : SmallInt;
  GotFile           : Boolean;
Begin
  Result := False;

  Try
    frmProgress.lblExpAction.Caption := 'Checking Export Files...';
    frmProgress.lblExpStatus.Caption := '';
    frmProgress.Refresh;

    { Build file name }
    OutName := AncPath;
    If Not (OutName[Length(OutName)] In [':', '\']) Then
      OutName := OutName + '\';
    OutName := OutName + 'ANC';

    For FVar := 1 To 999 Do Begin
      RepFName := OutName + Format('%3.3d',[FVar]) + '.TXT';

      frmProgress.lblExpStatus.Caption := 'ANC' + Format('%3.3d',[FVar]) + '.TXT';
      frmProgress.Refresh;

      GotFile := FileExists (RepFName);
      If Not GotFile Then Begin
        BatchNo := Format('%3.3d',[FVar]);
        Break;
      End; { If }
    End; { For }

    { We want to return True if export failed and want to repeat dialog }
    Result := Not GotFile;

    If Result Then Begin
      frmProgress.lblExpAction.Caption := 'Exporting To ' + ExtractFileName(RepFName);
      frmProgress.lblExpStatus.Caption := '';
      frmProgress.Refresh;

      { Okilly, Dokilly - we gotta filename }
      OutName := RepFName;

      { Create Export File }
      AssignFile (OutF, OutName);
      Rewrite (OutF);
      Try
        { Write header record }
        Writeln (OutF, '1,', BatchNo, ',', FormatDateTime('dd"/"mm"/"yy', Now), ',');

        { write SOR record }
        Write (OutF, ContractNo, ',');       { Contract Number }
        Write (OutF, LocalAcCode, ',');      { Customer/Account Code }
        Write (OutF, '"' + edtName.Text, '",');     { Customer Name }
        Write (OutF, '"' + edtAddr1.Text, '",');    { Address 1 }
        Write (OutF, '"' + edtAddr2.Text, '",');    { Address 2 }
        Write (OutF, ',');                   { Address 3 }
        Write (OutF, ',');                   { Location }
        Write (OutF, '"' + edtTown.Text, '",');     { Post Town }
        Write (OutF, '"' + edtCounty.Text, '",');   { County }
        Write (OutF, '"' + edtPostCode.Text, '",'); { Post Code } //10
        // HM 17/09/04: Added Telephone No to export
        //Write (OutF, ',');                   { Telephone }
        Write (OutF, '"' + edtTelephone.Text, '",'); { Telephone }
        Write (OutF, ',');                   { Contact }
        Write (OutF, Trim(Copy (lsService.Items[lsService.ItemIndex],1,3)), ','); { Service Code }
        Write (OutF, FormatDateTime('dd"/"mm"/"yy', Now), ',');        { Date }
        Write (OutF, Format('%3.3d', [Trunc(ccyBoxes.Value)]), ',');   { No. of Items }
        Write (OutF, Format('%3.3d', [Trunc(ccyWeight.Value)]), ',');  { Weight in Kg }
        Write (OutF, '"' + Trim(edtDespRef1.Text), '",'); { Despatch Ref 1 }
        Write (OutF, ',');                   { Notes/Instructions 1 }
        Write (OutF, ',');                   { Notes/Instructions 2 }
        Write (OutF, ',');                   { Notes/Instructions 3 } //20
        Write (OutF, 'A,');                  { Carrier Code }
        Write (OutF, ',');                   { Carrier Description }
        Write (OutF, ',');                   { Hazard Flag }
        Write (OutF, ',');                   { Packing Group }
        Write (OutF, ',');                   { Hazard Class }
        Write (OutF, '"' + Trim(edtDespRef2.Text), '",');        { Despatch Ref 2 }

        // HM 07/07/04: Added Extended Mode which exports 7 new optional fields
        If ExtMode Then
        Begin
          Write (OutF, '"' + AncAccount, '",'); { ANC Account }  //27
          Write (OutF, ',');                    { Goods Description }
          Write (OutF, ',');                    { Address Line 4 }
          Write (OutF, ',');                    { User Consol }
          Write (OutF, ',');                    { Customer Notes 1 }
          Write (OutF, ',');                    { Customer Notes 2 }
          Write (OutF, ',');                    { B-Text 2 }
          Write (OutF, ',');                    { B-Text 1 }
          Write (OutF, '"' + SystemId, '"');   { System Id }
        End; // If ExtMode

        frmProgress.lblExpStatus.Caption := 'Complete';
        frmProgress.Refresh;
      Finally
        CloseFile (OutF);
      End;

      If (LocalMode = 1) Then Begin
        { Update Transaction with number of boxes }
        UpdateTrans;
      End; { If }
    End { If }
    Else Begin
      frmProgress.lblExpAction.Caption := 'Export Failed';
      frmProgress.lblExpStatus.Caption := '';
      frmProgress.Refresh;

      MessageDlg ('The existing export files must be processed in DeliverANCe 2000 ' +
                  'before any more orders can be processed', mtError, [mbOk], 0);
    End; { Else }
  Except
    On Ex:Exception Do
      MessageDlg ('The following error occured attempting to export:' +
                  #10#13#10#13 +
                  '''' + Ex.Message + '''.', mtError, [mbOk], 0);
  End;
End;


{ Updates the Transaction with the number of boxes }
Procedure TfrmANCExport.UpdateTrans;
Var
  B_Stat     : SmallInt;
  LocalTH    : TBatchTHRec;
  pTH        : ^TBatchTHRec;
  PC, PCPath : PChar;
  RecLockOk  : Boolean;
  mbRet      : Word;
  TStr       : ShortString;
Begin
  RecLockOk:=False;

  With EvData Do Begin
    Try
      PCPath := StrAlloc (255);

      {* assign Location Code into PC *}
      StrPCopy(PCPath, SetUp.ssDataPath);

      B_Stat:=EX_INITDLLPATH(PCPath,True);

      If (B_Stat=0) then
        EX_SetReleaseCode(SECCode);

      B_Stat:=Ex_InitDLL;

      {* if DLL returns Error *}
      If (B_Stat <> 0) Then begin
        TStr:=Ex_ErrorDescription(1, B_Stat);
        ShowMessage ('Ex_InitDLL Status : '+IntToStr(B_Stat)+
                     #13#10+#13#10+TStr);
      End { If }
      Else Begin
        pTh:=@LocalTH;

        { Get Invoice }
        PC := StrAlloc (255);
        StrPCopy(PC, Transaction.thOurRef);
        Repeat
          StrPCopy(PC, Transaction.thOurRef);
          B_Stat:=Ex_GetTransHed(pTh, Sizeof(LocalTH), PC, 0, B_GetEq, True);

          If (B_Stat=0) and (LocalTH.FolioNum = Transaction.thFolioNum) Then Begin
            RecLockOk:=True;

            { Update No. Of Labels field with No. Of Boxes from dialog }
            LocalTH.thNoLabels := Round(ccyBoxes.Value);

//            B_Stat:=Ex_StoreTH(pTh,Sizeof(LocalTH),0,B_Update,90812966);
            B_Stat:=Ex_StoreTransHed(pTh,Sizeof(LocalTH));

            If (B_Stat <> 0) Then begin
              TStr:=Ex_ErrorDescription(89,B_Stat);
              ShowMessage ('Ex_StoreTH Status : '+IntToStr(B_Stat)+
                            #13#10+#13#10+TStr+#13+
                            'Updating '+Transaction.thOurRef);
            End;
          End { If }
          Else Begin
            mbRet:=MessageDlg('Order '+Transaction.thOurRef+' is currently locked.'+#13+'Do you wish to retry updating this order?',mtConfirmation,[mbYes,mbNo],0);
            RecLockOk:=(mbRet=mrNo);
          End; { Else }
        Until (RecLockOk);

        StrDispose(PC);

        { Unload Toolkit DLL if loaded }
        Ex_CloseData;
      End; { Else }
    finally
      {* dispose allocated buffer of PC *}
      StrDispose(PCPath);
    end; {Try..}
  end; {With..}
End; {Proc..}


{ Tidies up any used files in DelivarANCe 2000 directory }
Procedure TfrmANCExport.TidyUpANC;
Var
  FileInfo : TSearchRec;
  FStatus  : SmallInt;
  FullPath : ShortString;
  Count    : SmallInt;
Begin
  frmProgress.lblDelAction.Caption := 'Checking For Old Files';
  frmProgress.lblDelStatus.Caption := '';
  frmProgress.Refresh;

  FullPath := AncPath;
  If (Not (FullPath[Length(FullPath)] In ['\', ':'])) And (Trim(FullPath) <> '') Then
    FullPath := FullPath + '\';

  FStatus := FindFirst(FullPath + 'ANC???F.TXT', faHidden or faReadOnly, FileInfo);

  Count := 0;
  While (FStatus = 0) Do Begin
    If (FileInfo.Name <> '.') And (FileInfo.Name <> '..') Then Begin
      Try
        { Ordinary file - take off any hidden/read only attributes }
        If ((FileInfo.Attr And faHidden) = faHidden) Or
           ((FileInfo.Attr And faReadOnly) = faReadOnly) Then Begin
          { Hidden/Read-Only }
          FileSetAttr (FullPath + FileInfo.Name, 0);
        End; { If }

        { Delete it }
        frmProgress.lblDelStatus.Caption := UpperCase(FileInfo.Name);
        frmProgress.Refresh;
        DeleteFile (FullPath + FileInfo.Name);
        Inc (Count);
      Except
        On Exception Do ;
      End;
    End; { If }

    FStatus := FindNext(FileInfo);
  End; { While }

  FindClose (FileInfo);

  Case Count Of
    0 : frmProgress.lblDelAction.Caption := 'No Old Files Found';
    1 : frmProgress.lblDelAction.Caption := '1 Old File Deleted';
  Else
    frmProgress.lblDelAction.Caption := IntToStr(Count) + ' Old Files Deleted';
  End;
  frmProgress.lblDelStatus.Caption := '';
  frmProgress.Refresh;
End;


{ Export the address info to CSV file }
procedure TfrmANCExport.btnExportClick(Sender: TObject);
Const
  CSVName = 'ANCADDR.CSV';
Var
  CSVFile : TStringList;
  CSVPath : ShortString;
begin
  CSVFile := TStringList.Create;
  Try
    { Build path to CSV file }
    CSVPath := GetEnterpriseDirectory + CSVName;

    { If it already exists load it in }
    If FileExists(CSVPath) Then Begin
      CSVFile.LoadFromFile (CSVPath);
    End; { If }

    { Add current details to end of file }
    CSVFile.Add ('"' + Trim(edtName.Text) + '",' +
                 '"' + Trim(edtAddr1.Text) + '",' +
                 '"' + Trim(edtAddr2.Text) + '",' +
                 '"' + Trim(edtTown.Text) + '",' +
                 '"' + Trim(edtCounty.Text) + '",' +
                 '"' + Trim(edtPostCode.Text) + '"');

    { save updated details back to disk }
    CSVFile.SaveToFile (CSVPath);
  Finally
    CSVFile.Destroy;
  End; { Try }
end;

Initialization
  DefaultList := Nil;
  UsingDefaults := False;
Finalization
  Finito;
end.
