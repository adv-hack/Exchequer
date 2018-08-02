unit jcardmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jcObj, StdCtrls, ExtCtrls, uMultiList, uDBMultiList,
  uExDatasets, uBtrieveDataset, TCustom, Menus, ComCtrls;

type
  TfrmCoPayLink = class(TForm)
    BtrieveDataset1: TBtrieveDataset;
    Panel1: TPanel;
    dmlCompany: TDBMultiList;
    Panel2: TPanel;
    SBSButton1: TSBSButton;
    ScrollBox1: TScrollBox;
    btnAdd: TSBSButton;
    btnEdit: TSBSButton;
    btnDelete: TSBSButton;
    btnOpts: TSBSButton;
    SBSButton3: TSBSButton;
    mnuOpts: TPopupMenu;
    Directories1: TMenuItem;
    Employees1: TMenuItem;
    ViewLogFiles1: TMenuItem;
    Panel3: TPanel;
    lblProgress: TLabel;
    procedure BtrieveDataset1GetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SBSButton1Click(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure Directories1Click(Sender: TObject);
    procedure btnOptsClick(Sender: TObject);
    procedure Employees1Click(Sender: TObject);
    procedure SBSButton3Click(Sender: TObject);
    procedure dmlCompanyRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure ViewLogFiles1Click(Sender: TObject);
  private
    { Private declarations }
    FMCM : TMCMObject;
    FEmp : TEmpObject;
    function GetCurrentRecord(Lock : Boolean = False) : Boolean;
    function ProcessTSHOurRef(s : string) : string;
    procedure DoProgress(const sMessage : string);
  public
    { Public declarations }
    procedure PadEmpRecords;
  end;

var
  frmCoPayLink: TfrmCoPayLink;

implementation

{$R *.dfm}
uses
  ExportO, LogO, BtrvU2, jcVar, CoDet, Enterprise01_TLB, ComObj, jcFuncs,
  Dirs, JCIni, FileUtil, empLst, ExpForm, SelectLg, SecCodes, CtkUtil;

procedure TfrmCoPayLink.BtrieveDataset1GetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
begin
  with PMCMRecType(PData)^ do
  begin
    Case FieldName[1] of
      'C'  :  FieldValue := CoCode;
      'N'  :  FieldValue := CoName;
      'P'  :  FieldValue := PayID;
      'F'  :  FieldValue := FileName;
    end;//case
  end;
end;

procedure TfrmCoPayLink.btnAddClick(Sender: TObject);
var
  Res : Integer;
begin
  with TfrmCoDetails.Create(nil) do
  Try
    Caption := 'Add Company/Payroll ID link';
    OK := False;
    ShowModal;
    if OK then
    begin
      FMCM.CoCode := cbCode.Items[cbCode.ItemIndex];
      FMCM.CoName := edtName.Text;
      FMCM.PayID := edtPayID.Text;
      FMCM.FileName := edtFileName.Text;
      Res := FMCM.AddRec;
      if Res <> 0 then
        ShowMessage('Error adding new record. Btrieve error ' + IntToStr(Res));
    end;
  Finally
    Free;
  End;
  dmlCompany.RefreshDB;
end;

procedure TfrmCoPayLink.FormCreate(Sender: TObject);
var
  Res : Integer;
  a, b, c, i : longint;
  GroupName : string;
begin
  Caption := jcName + '.  ' + JobCardVersion;
  oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
  with oToolkit do
  begin
    EncodeOpCode(97, a, b, c);
    Configuration.SetDebugMode(a, b, c);
  end;
  Res := oToolkit.OpenToolkit;
  if Res = 0 then
    UseDosKeys := oToolkit.SystemSetup.ssUseDosKeys
  else
    UseDosKeys := False;
  oToolkit.CloseToolkit;
  TheIni := TJCIniObject.Create;
  FMCM := TMCMObject.Create;
  FEmp := TEmpObject.Create;
  FullGroupList := TStringList.Create;
  FullGroupList.Sorted := True;
  GroupName := GetEnterpriseDirectory + GroupFileName;
  GroupList := TStringList.Create;
  if FileExists(GroupName) then
  begin
    FullGroupList.LoadFromFile(GroupName);
    for i := 0 to FullGroupList.Count - 1 do
    begin
      if Pos(',', FullGroupList[i]) = 0 then
      begin //Conversion from old format
        GroupList.AddStrings(FullGroupList);
        FullGroupList.Clear;
        Break;
      end;
    end;
    CurrentCompany := CompanyCodeFromPath(oToolkit, GetEnterpriseDirectory);
    GroupListToFullGroupList;
  end;
  Res := FMCM.OpenFile;
  if Res <> 0 then
    ShowMessage('Unable to open file ' + GetEnterpriseDirectory + MCMFileName +
                        '. Error: ' + IntToStr(Res));
  Res := FEmp.OpenFile;
  if Res <> 0 then
    ShowMessage('Unable to open file ' + GetEnterpriseDirectory + EmpFileName +
                       '. Error: ' + IntToStr(Res))
  else
    PadEmpRecords;

  dmlCompany.Active := True;
end;

procedure TfrmCoPayLink.FormDestroy(Sender: TObject);
begin
  FMCM.Free;
  FEmp.Free;
  oToolkit := nil;
  FullGroupList.SaveToFile(GetEnterpriseDirectory + 'JC\AcGroups.dat');
  TheIni.Free;
end;

procedure TfrmCoPayLink.SBSButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmCoPayLink.btnEditClick(Sender: TObject);
var
  Res : Integer;
begin
  with TfrmCoDetails.Create(nil) do
  Try
    Caption := 'Edit Company/Payroll ID link';

    if GetCurrentRecord(True) then
    begin
      cbCode.ItemIndex := cbCode.Items.IndexOf(FMCM.CoCode);
      DoCodeChange;
      edtPayID.Text := FMCM.PayID;
      edtFileName.Text := FMCM.FileName;
      OK := False;
      ShowModal;
      if OK then
      begin
        FMCM.CoCode := cbCode.Items[cbCode.ItemIndex];
        FMCM.CoName := edtName.Text;
        FMCM.PayID := edtPayID.Text;
        FMCM.FileName := edtFileName.Text;
        Res := FMCM.PutRec;
      end
      else
        FMCM.UnlockRecord;
    end;
  Finally
    Free;
  End;
  dmlCompany.RefreshDB;
end;

function TfrmCoPayLink.GetCurrentRecord(Lock : Boolean = False) : Boolean;
var
  Res : Integer;
  mcm : MCMRecType;
  P : Pointer;
begin
  P := BtrieveDataset1.GetRecord;
  if Assigned(P) then
  begin
    mcm := MCMRecType(P^);
    FMCM.Index := 2;
    Res := FMCM.FindRec(LJVar(mcm.CoCode, 6) + mcm.PayID, B_GetEq, Lock);
    Result := Res = 0;
  end
  else
    Result := False;
end;

procedure TfrmCoPayLink.btnDeleteClick(Sender: TObject);
begin
  if GetCurrentRecord then
  begin
    if MessageDlg('Are you sure you wish to delete company ' + QuotedStr(FMCM.CoName) + '?',
             mtConfirmation, mbYesNoCancel, 0) = mrYes then
    begin
      FMCM.DelRec;
      dmlCompany.RefreshDB;
    end;
  end;
end;

procedure TfrmCoPayLink.Directories1Click(Sender: TObject);
begin
  with TfrmSelectDir.Create(nil) do
  Try
    edtEntDir.Text := EntDir;
    edtPayDir.Text := TheIni.PayDir;
    edtLogDir.Text := TheIni.LogDir;
    ShowModal;
    if ModalResult = mrOK then
    begin
//      TheIni.EntDir := edtEntDir.Text;
      TheIni.PayDir := edtPayDir.Text;
      TheIni.LogDir := edtLogDir.Text;
    end;
  Finally
    Free;
  End;
end;

procedure TfrmCoPayLink.btnOptsClick(Sender: TObject);
var
  p : TPoint;
begin
  p := btnOpts.ClientToScreen(Point(btnOpts.Left, btnOpts.Height));
  mnuOpts.Popup(p.x, p.y);
end;

procedure TfrmCoPayLink.Employees1Click(Sender: TObject);
var
  Res, i : Integer;
  s, CCode : string;
  P : Pointer;
begin
  P := BtrieveDataset1.GetRecord;
  if Assigned(P) then
  begin
    CCode := Trim(MCMRecType(P^).CoCode);
    with oToolkit do
    begin
      OpenTheToolkit(CCode);
      with TfrmEmpList.CreateWithCompany(nil, CCode) do
      Try
        EmployeeRec := FEmp;
        Toolkit := oToolkit;
        ShowModal;
      Finally
        CloseTheToolkit;
        Free;
      End;
    end; //with oToolkit
  end;
end;

procedure TfrmCoPayLink.SBSButton3Click(Sender: TObject);
var
  bRes : Boolean;
  msg : string;
  LastEntTSH : string;

  procedure GetLastEntTSH;
  var
    Res : Longint;
  begin
    Res := oToolkit.Transaction.GetLessThanOrEqual('TSHZ99999');
    if (Res = 0) and (oToolkit.Transaction.thDocType = dtTSH) then
      LastEntTSH := oToolkit.Transaction.thOurRef
    else
      LastEntTSH := '';
  end;

begin
  if GetCurrentRecord then
  begin
    OpenTheToolkit(FMCM.CoCode);
    GetLastEntTSH;
    with TfrmExport.Create(Self) do
    Try
      CompanyCode := FMCM.CoCode;
      edtPy.PeriodsInYear := oToolkit.SystemSetup.ssPeriodsInYear;
      edtPy.EPeriod := oToolkit.SystemSetup.ssCurrentPeriod;
      edtPy.EYear := oToolkit.SystemSetup.ssCurrentYear;
      edtTSFrom.Text := TheIni.LastTimesheet;
      edtTSTo.Text := LastEntTSH;
      chkLineFromAnal.Checked := TheIni.LineTypeFromAnalysisType;
      ShowModal;
      if ModalResult = mrOK then
      begin
        Screen.Cursor := crHourGlass;
        TheIni.LineTypeFromAnalysisType := chkLineFromAnal.Checked;
        with TJCExportObject.Create(TheIni.PayDir + FMCM.FileName + '.' + FMCM.PayID) do
        Try
          LineTypeFromAnal := chkLineFromAnal.Checked;
          TheLog := TJCLog.Create;
          TheLog.Filename := TheIni.LogDir + TheIni.LogFileName;
          TheLog.Open(Trim(FMCM.CoCode) + '/' + FMCM.PayID);
          Toolkit := oToolkit;
          CompanyCode := FMCM.CoCode;
          EmpObject := FEmp;

          Employee := Trim(edtEmp.Text);

          if edtWk.Text = '' then
            WeekMonth := -1
          else
            WeekMonth := StrToInt(edtWk.Text);

          RangeStart := ProcessTSHOurRef(edtTSFrom.Text);
          RangeEnd := ProcessTSHOurRef(edtTSTo.Text);
          if (RangeStart = '') then
          begin
            Period := edtPy.EPeriod;
            Year := edtPy.EYear;
          end
          else
          begin
            Period := 0;
            Year := 0;
          end;


          AllowPosted := chkPosted.Checked;
          UseLineRate := chkUseLineRates.Checked;
          AllowExported := chkAllowExported.Checked;
          ExcludeSubcontractors := chkExcludeSubs.Checked;

          OverwritePayments := TheIni.OverwritePayments;

          OnProgress := DoProgress;

          if Write then
          begin
            msg := 'Export completed successfully to ' + Filename;
            ShowMessage(msg);
            TheLog.LogIt(msg);
            TheIni.LastTimeSheet := edtTSTo.Text;
          end
          else
          begin
            //show log
            ShowMessage('There were errors. Please check log for details.');
          end;

        Finally
          DoProgress('');
          TheLog.Free;
          Free;
          Screen.Cursor := crDefault;
        End;


      end;
    Finally
      CloseTheToolkit;
      Free;
    End;

  end;
end;

procedure TfrmCoPayLink.dmlCompanyRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnEdit.Click;
end;

function TfrmCoPayLink.ProcessTSHOurRef(s : string) : string;
var
  i, j : integer;
  s1 : string;
begin
  if Trim(s) <> '' then
  begin
    if Pos('TSH', s) = 1 then
      s := Copy(s, 4, Length(s));
    if Length(s) < 6 then
      s := StringOfChar('0', 6 - Length(s)) + s;
    Result := 'TSH' + s;
  end
  else
    Result := '';
end;

procedure TfrmCoPayLink.ViewLogFiles1Click(Sender: TObject);
begin
  with TfrmSelectLog.Create(nil) do
  Try
    Screen.Cursor := crHourGlass;
    LoadList;
    Screen.Cursor := crDefault;
    ShowModal;
  Finally
    Free;
  End;
end;

procedure TfrmCoPayLink.PadEmpRecords;
var
  Res : Integer;
begin
  Screen.Cursor := crHourGlass;
  Res := FEmp.FindRec('', B_GetFirst, True);

  While Res in [0, 84, 85] do
  begin
    if (Length(FEmp.EmpCode) <> 6) or (Length(FEmp.CoCode) <> 6) then
    begin
      FEmp.EmpCode := FEmp.EmpCode;
      FEmp.CoCode := FEmp.CoCode;
      FEmp.PutRec;
    end;

    Res := FEmp.FindRec('', B_GetNext, True);
  end;

  Screen.Cursor := crDefault;
end;

procedure TfrmCoPayLink.DoProgress(const sMessage: string);
begin
  lblProgress.Caption := sMessage;
  lblProgress.Refresh;
  Application.ProcessMessages;
end;

end.
