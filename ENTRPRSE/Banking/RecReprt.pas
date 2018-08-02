unit RecReprt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, ExtCtrls,
  GlobVar,VarConst,VarRec2U, BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU,
  EnterToTab, BorBtns, Enterprise04_TLB, BankDetl, Mask, TEditVal, BankList,
  Scrtch1U;

type
  TfrmReconcileReport = class(TForm)
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    EnterToTab1: TEnterToTab;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    chkGroup: TBorCheck;
    edtGLCode: Text8Pt;
    edtGLDesc: Text8Pt;
    edtReconcile: Text8Pt;
    cbSortBy: TSBSComboBox;
    lblReconBy: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure edtGLCodeExit(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtReconcileExit(Sender: TObject);
  private
    { Private declarations }
    oRecToolkit : IToolkit3;
    ReconcileFolio : longint;
    FOnClosed : TNotifyProc;
    FUserID : String;
  public
    { Public declarations }
    property OnClosed : TNotifyProc read FOnClosed write FOnClosed; 
  end;

  TReconRepParams = Record
    GLCode : Integer;
    GLDesc : String[60];
    ReconFolio : longint;
    SortOrder : Byte;
    GroupItems : Boolean;
    UserID : String[60];
  end;

  TReconcileReport = Object(TGenReport)
    HeaderRec : BnkRHRecType; //Reconcile Header
    StatHed   : eBankHRecType;
    StatLine  : eBankLRecType;
    OpenBalance,
    CloseBalance : Double;
    Params : TReconRepParams;
    oScratch : ScratchFile;       {Scratch File Object}
    GroupTotal : Double;
    GroupRef,
    GroupDate : String;
    GroupLine : Integer;
    TotalRecs : longint;
    function GetReportInput  :  Boolean; virtual;
    Procedure PrintReportLine; Virtual;
    function IncludeRecord  :  Boolean; Virtual;
    Procedure RepSetTabs; Virtual;
    procedure RepPrintPageHeader; Virtual;
    Procedure PrintEndPage; Virtual;
    procedure PrintHedTit; Virtual;
    function BankString : string;
    function Start : Boolean; Virtual;
    Procedure PrintStdPage; Virtual;
    procedure Process; Virtual;
    Procedure RepPrint(Sender  :  TObject); Virtual;
  end;

  Procedure AddBankReconcileRep2Thread(LMode    :  Byte;
                                       AParams : TReconRepParams;
                                       AOwner   :  TObject);

  procedure BankReconciliationReport;

var
  frmReconcileReport: TfrmReconcileReport;

implementation

{$R *.dfm}
uses
  Printers,
  ETDateU,
  ETStrU,
  ExThrd2U,
  BtSupU1,
  RpDefine,
  InvListU,
  BtKeys1U,
  ComObj,
  SbsComp2,
  BtSupU2,
  ReconObj,
  GetRecon,
  CtkUtil04,
  TranFile,
  SQLUtils;

var
  sDebugKey : Str255;

procedure ReconcileReportFormClosed(Sender : TObject);
begin
  if Sender is TfrmReconcileReport then
    frmReconcileReport := nil;
end;

procedure BankReconciliationReport;
begin
  if not Assigned(frmReconcileReport) then
  begin
    frmReconcileReport := TfrmReconcileReport.Create(Application.MainForm);
    frmReconcileReport.OnClosed := ReconcileReportFormClosed;
  end;

  frmReconcileReport.BringToFront;
end;


procedure TfrmReconcileReport.FormCreate(Sender: TObject);
var
  Res : Integer;
begin
  Height := 214;
  Width := 380;

  oRecToolkit := CreateToolkitWithBackDoor as IToolkit3;;
  oRecToolkit.Configuration.DataDirectory := SetDrive;
  Res := oRecToolkit.OpenToolkit;
  LastValueObj.GetAllLastValuesFull(Self);
  ReconcileFolio := 0;
end;

Function ReverseFullNomKey(ncode  :  Longint)  :  Str20;
Var
  TmpStr, TmpStr2  :  Str20;
  i : integer;
Begin
  FillChar(TmpStr,Sizeof(TmpStr),0);
  FillChar(TmpStr2,Sizeof(TmpStr2),0);

  Move(ncode,TmpStr[1],Sizeof(ncode));

  TmpStr[0]:=Chr(Sizeof(ncode));
  TmpStr2[0] := TmpStr[0];
  //reverse string
  for i := 1 to 4 do
    TmpStr2[i] := TmpStr[5-i];

  Result := TmpStr2;
end;


function TReconcileReport.GetReportInput  :  Boolean;
begin
  RepTitle:= 'Bank Statement Report';
  PageTitle := 'Bank Statement Report for ' + Params.GLDesc;
  THTitle:=RepTitle;

  RFnum:=MLocF;
  Result := True;
end;

procedure TReconcileReport.RepPrintPageHeader;
begin
  With RepFiler1 do
  Begin
    DefFont(0,[fsBold]);
    SendLine (#9 + 'Date'+ #9 + 'Reference' + #9 + 'Matching Transaction' + #9 + 'Customer/Supplier' + #9 + 'Amount' + #9 + 'Line No' );

    DefFont(0,[]);
  end;
end;

Procedure TReconcileReport.PrintReportLine;
var
  sCred, sDeb : string;
  sLineNo : string;

  //PR: 01/07/2009 If a line doesn't have a payinref then the brPayRef field
  //will have FolioNum+LineNo in FullNomKey format - this shouldn't be displayed.
  function ProcessPayRef(const s : string) : string;
  var
    i : longint;
  begin
    Result := s;
    if Length(Result) = 8 then
    begin
      Move(Result[5], i, SizeOf(i));
      if i = MLocCtrl^.BnkRDRec.brLineNo then
        Result := '';
    end;
  end;
begin

//  With MTExLocal^ do
  Begin
    DefFont (0,[]);

    if not Params.GroupItems then
    begin
      with MLocCtrl^.BnkRDRec do
      begin
        SendRepDrillDown(3, 3, 3, FullOurRefKey(brMatchRef),InvF,InvOurRefK,0);
        SendRepDrillDown(4, 4, 4, FullCustCode(brCustCode),CustF,CustCodeK,0);
        if brStatLine > 0 then
          sLineNo := IntToStr(brStatLine)
        else
          sLineNo := '';
        SendLine (#9 + POutDate(brLineDate) +
                  #9 + Trim(ProcessPayRef(brPayRef)) +
                  #9 + Trim(brMatchRef) +
                  #9 + Trim(brCustCode) +
                  #9 + ProcessValue(brValue, False) +
                  #9 + sLineNo);

      end;
    end
    else
    begin
      if GroupLine > 0 then
        sLineNo := IntToStr(GroupLine)
      else
        sLineNo := '';
      SendLine(#9 + POutDate(GroupDate) + #9 + Trim(ProcessPayRef(GroupRef)) + #9#9#9 +
                Format('%11.2f', [GroupTotal]) + #9 + sLineNo);
    end;


  end;
end;

function TReconcileReport.IncludeRecord  :  Boolean;
begin
  with MLocCtrl^ do
    Result := (RecPFix = LteBankRCode) and
              (SubType = '2') and
              (BnkRDRec.brFolioLink = HeaderRec.brIntRef);
end;

Procedure TReconcileReport.RepSetTabs;
begin
  With RepFiler1 do
  Begin
    SetTab (MarginLeft, pjLeft, 20, 4, 0, 0); //Date
    SetTab (NA, pjLeft, 35, 4, 0, 0);        //Ref
    SetTab (NA, pjLeft, 35, 4, 0, 0);         //Matched Trans OurRef
    SetTab (NA, pjLeft, 28, 4, 0, 0);        //Account
    SetTab (NA, pjRight, 18, 4, 0, 0);        //Amount
    SetTab (NA, pjRight, 20, 4, 0, 0);          //LineNo
{    SetTab (NA, pjLeft, 20, 4, 0, 0);
    SetTab (NA, pjRight,20, 4, 0, 0);}

    SetTabCount;
  end;
end;

Procedure AddBankReconcileRep2Thread(LMode    :  Byte;
                                     AParams  : TReconRepParams;
                                     AOwner   :  TObject);


Var
  EntTest  :  ^TReconcileReport;

Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        ReportMode:=LMode;
       // HeaderRec := HedRec;
        RepKey := LteBankRCode + '2' +
                  FullNomKey(AParams.GLCode)  + LJVar(AParams.UserID, 10) + FullNomKey(AParams.ReconFolio);
        HideRecCount := True;
        Params := AParams;
        RKeyPath := 0;
        If (Create_BackThread) and (Start) then
        Begin
          With BackThread do
            AddTask(EntTest,ThTitle);
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(EntTest,Destroy);
        end;
      end; {with..}

    except
      Dispose(EntTest,Destroy);

    end; {try..}
  end; {If process got ok..}

end;



procedure TReconcileReport.PrintEndPage;
var
  sCred, sDeb : string;
begin
  with RepFiler1 do
  begin
    sCred := '';
    sDeb := '';
{    if Balance >= 0 then
      sCred := FormatFloat(GenRealMask,Balance)
    else
      sDeb := FormatFloat(GenRealMask,Balance);
    DefLine(-2,TabStart(1),TabEnd(5),0);
    SendLine(#9 + ' ' + #9#9 + 'Balance:' + #9 + sCred +
             #9 + sDeb);
    SendLine('');}
  end;

  inherited PrintEndPage;
end;

procedure TReconcileReport.PrintHedTit;
var
  s : string;
begin
  inherited;
  inherited PrintStdPage;
  With RepFiler1 do
  Begin
    DefFont (0,[fsBold]);
{    if Trim(HeaderRec.brReconRef) <> '' then
      s := Trim(HeaderRec.brReconRef) + ' (' + POutDate(HeaderRec.brReconDate) + ')'
    else
      s := POutDate(HeaderRec.brReconDate);}
    PrintLeft(Format('Reconciliation:  %s', [Trim(HeaderRec.brReconRef){, BankString}]), MarginLeft);
    PrintRight(Format('Opening Balance: %11.2f', [HeaderRec.brOpenBal]),PageWidth-MarginRight);
    CRLF;

    PrintLeft(ConCat('Reconciled on:  ',POutDate(HeaderRec.brReconDate)), MarginLeft);
    PrintRight(Format('Statement Balance: %11.2f', [HeaderRec.brStatBal]),PageWidth-MarginRight);
    CRLF;

    PrintLeft(ConCat('Reconciled by:  ',Trim(HeaderRec.brUserId)), MarginLeft);
//    PrintRight(Format('Closing Balance: %11.2f', [HeaderRec.brCloseBal]),PageWidth-MarginRight);

    DefFont (0,[]);

    CRLF;
    CRLF;

  end;

end;

function TReconcileReport.BankString: string;
begin
  Result := Trim(Params.GLDesc){ + '(' + IntToStr(Params.GLCode) + ')'};
end;

function TReconcileReport.Start: Boolean;
var
  Res : Integer;
  i : integer;
  s : string;
begin
  TotalRecs := 0;
  GroupTotal := 0;
  GroupRef := '';
  Result := Inherited Start;

  if Result then
  begin
  //PR: 07/08/2009 Wasn't reopening files - eek.
    if SQLUtils.UsingSQL then
       ReOpen_LocalThreadfiles;

    //PR: 06/07/2017 ABSEXCH-12358 v2017 R2 Changed to use changed index
    KeyS := LteBankRCode + BankRecHeadKey + BuildHeadFolioIndex(Params.UserID, Params.GLCode, Params.ReconFolio);


    Res := MTExLocal^.LFind_Rec(B_GetEq, MLocF, 2, KeyS);

    Result := Res = 0;

    if Result then
      Move(MTExLocal^.LMLocCtrl^.BnkRHRec, HeaderRec, SizeOf(HeaderRec));

  //PR: 07/08/2009 Now close files again.
    if SQLUtils.UsingSQL then
      Reset_LocalThreadFiles;
  end;

end;



procedure TfrmReconcileReport.edtGLCodeExit(Sender: TObject);
var
  oGL : IGeneralLedger;
  c : integer;
  gl : longint;
begin
  if  (ActiveControl <> btnCancel) then
  begin
{    Val(edtGLCode.Text, gl, c);
    if c > 0 then
      gl := 0;}
    oGL := GetGLCode(oRecToolkit, edtGLCode.Text, Self);
    if Assigned(oGL) then
    with oGL do
    begin
      edtGLCode.Text := IntToStr(glCode);
      edtGLDesc.Text := Trim(glName);
    end
    else
      ActiveControl := edtGLCode;

  end;
end;

procedure TfrmReconcileReport.FormDestroy(Sender: TObject);
begin
  oRecToolkit := nil;
  if Assigned(FOnClosed) then
    FOnClosed(Self);
end;

procedure TfrmReconcileReport.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  LastValueObj.UpdateAllLastValuesFull(Self);
  Action := caFree;
end;

procedure TfrmReconcileReport.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TfrmReconcileReport.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;



procedure TfrmReconcileReport.btnOKClick(Sender: TObject);
var
  KeyS : Str255;
  Params : TReconRepParams;
  HeadRec : BnkRHRecType;
begin
  if btnOK.CanFocus then
    btnOK.SetFocus;
  if (ActiveControl = btnOK) then
  begin
    if ReconcileFolio = 0 then
      edtReconcileExit(Self);

    if ReconcileFolio <> 0 then
    begin
      //PR: 17/08/2009 Disable buttons to avoid them being clicked again before thread kicks off
      btnOK.Enabled := False;
      btnCancel.Enabled := False;
      Params.GLCode := StrToInt(edtGLCode.Text);
      Params.GLDesc := Trim(edtGLDesc.Text);
      Params.UserID := FUserID;
      Params.ReconFolio := ReconcileFolio;
      Params.SortOrder := cbSortBy.ItemIndex;
      Params.GroupItems := chkGroup.Checked;

      AddBankReconcileRep2Thread(0, Params, Application.MainForm);
      Close;
    end;
  end;
end;

procedure TfrmReconcileReport.btnCancelClick(Sender: TObject);
begin
  Close;
end;


procedure TfrmReconcileReport.edtReconcileExit(Sender: TObject);
var
  BankRec : BnkRHRecType;
  Res : Boolean;
  UserID : String;
begin
  UserID := GetUserID;
  if (ActiveControl <> btnCancel) then
  begin
    if not GetReconciliation(UserID, StrToInt(edtGLCode.Text), edtReconcile.Text, BankRec) then
      ActiveControl := edtReconcile
    else
    begin
      ReconcileFolio := BankRec.brIntRef;
      edtReconcile.Text := Trim(BankRec.brReconRef);
      lblReconBy.Caption := Format('Reconciled by %s on %s', [Trim(BankRec.brUserID), POutDate(BankRec.brReconDate)]);
      FUserID := BankRec.brUserID;
    end;
  end;
end;

procedure TReconcileReport.PrintStdPage;
begin
  //Do nothing
end;

procedure TReconcileReport.Process;
const
  iProcessID = 1;               {Unique Process ID for this report}
var
  iIndex, iStatus : smallint;
  sCheck, sKey : Str255;
  iRecAddress : LongInt;
  ScratchKey : Str255;
  slLineNo : TStringList; //PR: 28/01/2011 ABSEXCH-10262

  //PR: 28/01/2011 ABSEXCH-10262
  function LineIsUnique(const sLineNo : String) : Boolean;
  begin
    Result := slLineNo.IndexOf(sLineNo) = -1;
    if Result then
      slLineNo.Add(sLineNo);
  end;
begin
  //PR: 07/08/2009 Wasn't reopening files - eek.
    if SQLUtils.UsingSQL then
       ReOpen_LocalThreadfiles;

  oScratch.Init(iProcessID);

  FillChar(sKey,sizeof(sKey),#0);
  iIndex := 0;

  with MTExLocal^ do
  begin
    slLineNo := TStringList.Create; //PR: 28/01/2011 ABSEXCH-10262
    Try
      sKey := RepKey;
      sCheck := sKey;
      iStatus := LFind_Rec(B_GetGEq, MLocF, 1, sKey);
      While (iStatus = 0) and CheckKey(sCheck, sKey, Length(sCheck), True)  do
      begin
        //PR: 28/01/2011 ABSEXCH-10262
        //Because of a fault in the finalisation of reconciliations it was possible for duplicate lines to be added. This
        //has now been fixed, but we still need to deal with reporting on reconciliations created with unfixed versions.
        //Consequently, check the line number (from the temporary file) which should always be unique, and don't add
        //if it already exists.
        if LineIsUnique(IntToStr(LMLocCtrl^.BnkRDRec.brLineNo)) then
        begin
          iStatus:=LGetPos(MLocF, iRecAddress);

          if Params.GroupItems then
            ScratchKey := LJVar(LMLocCtrl^.BnkRDRec.brPayRef, 10) + LMLocCtrl^.BnkRDRec.brLineDate
          else
            Case Params.SortOrder of
              0  :  ScratchKey := LMLocCtrl^.BnkRDRec.brLineDate;
              1  :  ScratchKey := LMLocCtrl^.BnkRDRec.brPayRef;
              2  :  ScratchKey := FullNomKey(LMLocCtrl^.BnkRDRec.brStatLine);
            end;

          if LMLocCtrl^.BnkRDRec.brLineStatus = 32 then
          begin
            oScratch.Add_Scratch(MLocF, 0, iRecAddress, ScratchKey, ScratchKey);
            Inc(TotalRecs);
          end;
        end;

        iStatus := LFind_Rec(B_GetNext, MLocF, 1, sKey);
      end;
    Finally
      slLineNo.Free; //PR: 28/01/2011 ABSEXCH-10262
    End;
  end;

  inherited Process;
end;

procedure TReconcileReport.RepPrint(Sender: TObject);
const
  iProcessId = 1;
Var
  TmpStat      :  Integer;
  TmpRecAddr   :  LongInt;
  iScratch, iStatus : longint;
  sKey, sCheck : Str255;
  TempRepScr : RepScrRec;
  CurrentKey : Str255;
  CurrentTotal : Double;
  CurrentDate, CurrentRef, CurrentMatch : String;
  CurrentLine : Integer;
  NewGroup : Boolean;
  TmpDble : Double;
  TmpInt, GCount : Integer;
Begin
  CurrentLine := 0;
  NewGroup := False;
  CurrentKey := '';
  CurrentRef := '';
  CurrentTotal := 0;
  ShowStatus(2,'Printing Report.');

  InitProgress(100);
  UpdateProgress(0);

  With {MTExLocal^,}RepFiler1 do
  Begin


    sCheck := fullNomKey(iProcessID);
    sKey := sCheck;

    iStatus := Find_Rec(B_GetGEq, F[oScratch.SFNum], oScratch.SFNum,TempRepScr,oScratch.SKeypath,sKey);

    If (Assigned(ThreadRec)) then
      RepAbort:=ThreadRec^.THAbort;

    While (iStatus = 0) and (CheckKey(sCheck,sKey,Length(sCheck),BOn)) and (Not RepAbort) do
    Begin
//      TmpStat:=LPresrv_BTPos(RFnum,RKeypath,LocalF^[RFnum],TmpRecAddr,BOff,BOff);

      oScratch.Get_Scratch(TempRepScr);

      If (IncludeRecord) then
      Begin
        if Params.GroupItems then
        begin
          if Trim(CurrentKey) = '' then
          begin
            CurrentKey := Trim(TempRepScr.KeyStr);
            CurrentRef := MLocCtrl^.BnkRDRec.brPayRef;
            CurrentDate := MLocCtrl^.BnkRDRec.brLineDate;
            CurrentTotal := MLocCtrl^.BnkRDRec.brValue;
            CurrentLine := MLocCtrl^.BnkRDRec.brStatLine;
            NewGroup := False;
            GCount := 0;
          end
          else
          begin
            if Trim(CurrentKey) = Trim(TempRepScr.KeyStr) then
            begin
              CurrentTotal := CurrentTotal + MLocCtrl^.BnkRDRec.brValue;
              inc(GCount);
            end
            else
            begin
              GroupTotal := CurrentTotal;
              GroupRef := CurrentRef;
              GroupDate := CurrentDate;
              GroupLine := CurrentLine;
              CurrentTotal := MLocCtrl^.BnkRDRec.brValue;
              CurrentRef := MLocCtrl^.BnkRDRec.brPayRef;
              CurrentDate := MLocCtrl^.BnkRDRec.brLineDate;
              CurrentLine := MLocCtrl^.BnkRDRec.brStatLine;
              CurrentKey := Trim(TempRepScr.KeyStr);   //PR: 27/08/2009 wasn't resetting Current Key
              NewGroup := True;
              GCount := 0;
            end;
          end;
        end;

        if not Params.GroupItems or NewGroup then
        begin
          ThrowNewPage(5);
          PrintReportLine;
          NewGroup := False;
        end;
        Inc(ICount);
      end; {If Ok..}

      Inc(RCount);

      TmpDble := RCount;

      TmpInt := Trunc((TmpDble / TotalRecs) * 100);

      If (Assigned(ThreadRec)) then
        UpDateProgress(TmpInt);

//      TmpStat:=LPresrv_BTPos(RFnum,RKeypath,LocalF^[RFnum],TmpRecAddr,BOn,BOff);

      iStatus := Find_Rec(B_GetNext, F[oScratch.SFNum], oScratch.SFNum,TempRepScr,oScratch.SKeypath,sKey);

      If (Assigned(ThreadRec)) then
        RepAbort:=ThreadRec^.THAbort;
    end; {While..}

    if Params.GroupItems and (ICount > 0) then
    begin
      //PR: 27/08/2009 Was adding on the value on the record for some reason.
      GroupTotal := CurrentTotal;
      GroupRef := CurrentRef;
      GroupDate := CurrentDate;
      GroupLine := CurrentLine;
      ThrowNewPage(5);
      PrintReportLine;
    end;

    ThrowNewPage(5);

    {If ((RDevRec.fePrintMethod <> 5) or (RDevRec.feMiscOptions[3])) then}
      PrintEndPage;


  end; {With..}
  oScratch.Done;
end;

Initialization
  sDebugKey := '';

end.
