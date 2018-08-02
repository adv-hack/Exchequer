unit grpview;

interface
{$WARN SYMBOL_PLATFORM OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uExDatasets, uBtrieveDataset, StdCtrls, TCustom, uMultiList,
  uDBMultiList, ExtCtrls, Tranl1U, TranFile, BtSupU1, ReconObj;

type
  TfrmGroupView = class(TForm)
    Panel1: TPanel;
    btData: TBtrieveDataset;
    mlTrans: TDBMultiList;
    pnlButtons: TPanel;
    btnView: TSBSButton;
    btnClose: TSBSButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btDataFilterRecord(Sender: TObject; PData: Pointer;
      var Include: Boolean);
    procedure btDataGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure btnCloseClick(Sender: TObject);
    procedure mlTransRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnViewClick(Sender: TObject);
    procedure mlTransChangeSelection(Sender: TObject);
    procedure mlTransColumnClick(Sender: TObject; ColIndex: Integer;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    DispTrans    :  TFInvDisplay;
    function StatusString(Stat : Word) : string;
    procedure DisplayTrans(Mode: Byte; DetailRec : TTempTransDetails);
    procedure ShowDetails;
    function ScanMode : Boolean;
  public
    { Public declarations }
    CallBack : TNotifyEvent;
    PayRef, LineDate : string;
    GroupBy : TGroupBy; //PR: 14/10/2011 ABSEXCH-10076
    RecAddr : longint;
    procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;
  end;

var
  frmGroupView: TfrmGroupView;

  procedure ShowGroupList(TransDet : PTempTransDetails; ACallBack : TNotifyEvent; AGroupBy : TGroupBy);

implementation

{$R *.dfm}

uses
   etDateU, GlobVar, SQLUtils;

procedure ShowGroupList(TransDet : PTempTransDetails; ACallBack : TNotifyEvent; AGroupBy : TGroupBy);
begin
  if not Assigned(frmGroupView) then
    frmGroupView := TfrmGroupView.Create(Application.MainForm);

  frmGroupView.PayRef := TransDet.btdPayInRef;
  frmGroupView.LineDate := TransDet.btdDate;
  frmGroupView.GroupBy := AGroupBy;
  frmGroupView.RecAddr := TransDet.btdLineAddr;
  frmGroupView.btData.FileName := IncludeTrailingBackslash(SetDrive) + TmpFilename;
  frmGroupView.mlTrans.Active := True;
  frmGroupView.CallBack := ACallBack;
  if (Trim(TransDet.btdPayInRef) <> '') then
    frmGroupView.Caption := 'Group Details for ' + Trim(TransDet.btdPayInRef)
  else
   frmGroupView.Caption := 'Group Details';
  frmGroupView.BringToFront;
  frmGroupView.SetFocus;
end;

procedure TfrmGroupView.FormCreate(Sender: TObject);
begin
  ClientHeight := 246;
  ClientWidth := 504;
end;

procedure TfrmGroupView.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  if Assigned(CallBack) then
    CallBack(Self);
end;

procedure TfrmGroupView.btDataFilterRecord(Sender: TObject; PData: Pointer;
  var Include: Boolean);

  function PayRefOk : Boolean;
  begin
    with PTempTransDetails(PData)^ do
      Result := (btdPayInRef = PayRef) and (Trim(btdPayinRef) <> '');
  end;

  function DateOK : Boolean;
  begin
    with PTempTransDetails(PData)^ do
      Result := (btdDate = LineDate) or (GroupBy = gbRefOnly);
  end;

  function PayRefBlank : Boolean;
  begin
    with PTempTransDetails(PData)^ do
      Result := (Trim(btdPayinRef) = '') and (btdLineAddr = RecAddr);
  end;

begin
//PR: 14/10/2011 Added check for GroupBy ABSEXCH-10076 v6.9 + refactored the checks into functions to make clearer
  with PTempTransDetails(PData)^ do
    Include := (btdDocType <> 'RUN') and
               (
                 (PayRefOK and DateOK) or
                  PayRefBlank
               );
end;

function TfrmGroupView.StatusString(Stat : Word) : string;
begin
  Case Stat of
    0 : Result := '';
    1 : Result := 'Cleared';
    2 : Result := 'Cancelled';
    3 : Result := 'Returned';
  end; //Case
end;


procedure TfrmGroupView.btDataGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
var
  TransDetails : PTempTransDetails;
begin
  TransDetails := PData;
  with TransDetails^ do
  begin
    Case FieldName[1] of
      'D'  : FieldValue := btdDocType;
      'P'  : FieldValue := SOutPeriod(btdPeriod, btdYear);
      'A'  : FieldValue := Trim(btdAcCode);
      'N'  : FieldValue := Trim(btdPayInRef);
      'M'  : FieldValue := ProcessValue(btdAmount);
      'S'  : FieldValue := StatusString(btdStatus); //Status = ?
      'T'  : FieldValue := POutDate(btdDate);
    end;
  end;
end;

procedure TfrmGroupView.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmGroupView.DisplayTrans(Mode: Byte; DetailRec : TTempTransDetails);
begin
  If (DispTrans=nil) then
    DispTrans:=TFInvDisplay.Create(Self);

    try


      With DispTrans do
      Begin
        LastDocHed:=DetailRec.btdIdDocHed;
        DocRunRef:=DetailRec.btdOurRef;
        DocHistRunNo:=DetailRec.btdPostedRun;

        {$IFDEF SOP}
//          DocHistCommPurch:=(DocHistRunNo=CommitOrdRunNo) and (oGL.glCode=Syss.NomCtrlCodes[PurchComm]);

        {$ENDIF}

        If ((LastFolio<>DetailRec.btdFolioRef) or (Mode<>100)) {and (InHBeen)} then
          Display_Trans(Mode,DetailRec.btdFolioRef,True,(Mode<>100));

      end; {with..}

    except

      DispTrans.Free;

    end;

end;

procedure TfrmGroupView.mlTransRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  ShowDetails;
end;

procedure TfrmGroupView.btnViewClick(Sender: TObject);
begin
  ShowDetails;
end;

procedure TfrmGroupView.ShowDetails;
begin
  DisplayTrans(99, PTempTransDetails(btData.GetRecord)^)
end;

procedure TfrmGroupView.WMCustGetRec(var Message: TMessage);
begin
end;

procedure TfrmGroupView.mlTransChangeSelection(Sender: TObject);
begin
  if Assigned(DispTrans) and ScanMode then
    ShowDetails;
end;

function TfrmGroupView.ScanMode: Boolean;
Var
  n  :  Byte;

Begin
  If (Assigned(DispTrans)) then
  With DispTrans do
  Begin
    For n:=Low(TransActive) to High(TransActive) do
    Begin
      Result:=TransActive[n];

      If (Result) then
        break;
    end;
  end
  else
    Result:=False;

end;

procedure TfrmGroupView.mlTransColumnClick(Sender: TObject;
  ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  Case ColIndex of
    0 : mlTrans.HelpContext := 1920;
    1 : mlTrans.HelpContext := 1925;
    2 : mlTrans.HelpContext := 1921;
    3 : mlTrans.HelpContext := 2007;
    4 : mlTrans.HelpContext := 1923;
    5 : mlTrans.HelpContext := 1928;
    6 : mlTrans.HelpContext := 1924;
  end;
end;

procedure TfrmGroupView.FormResize(Sender: TObject);
var
  iCentre : Integer;
begin
  //PR: 14/10/2011 Improve button positioning when resizing.
  iCentre := pnlButtons.Width div 2;
  btnView.Left := iCentre - 84;
  btnClose.Left := iCentre + 4;
end;

end.
