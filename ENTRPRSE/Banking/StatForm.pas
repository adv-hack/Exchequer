unit StatForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, uExDatasets, uComTKDataset, uMultiList,
  uDBMultiList, ExtCtrls, Enterprise04_TLB, Menus, uSettings;


type
  TStatementFilter = (sfAll, sfMatched, sfUnmatched);

  TfrmStatement = class(TForm)
    Panel1: TPanel;
    pnlBtns: TPanel;
    mlStatements: TDBMultiList;
    ctkData: TComTKDataset;
    Panel3: TPanel;
    edtDate: TEdit;
    edtRef: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnClose: TSBSButton;
    btnFilter: TSBSButton;
    btnTag: TSBSButton;
    popFilter: TPopupMenu;
    Allitems1: TMenuItem;
    MatchedItemsonly1: TMenuItem;
    UnmatchedItemsonly1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Close1: TMenuItem;
    Filter1: TMenuItem;
    Match1: TMenuItem;
    N1: TMenuItem;
    Properties1: TMenuItem;
    N2: TMenuItem;
    SaveCoordinates1: TMenuItem;
    btnAuto: TSBSButton;
    procedure btnCloseClick(Sender: TObject);
    procedure ctkDataGetFieldValue(Sender: TObject; ID: IDispatch;
      FieldName: String; var FieldValue: String);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure mlStatementsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure btnTagClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mlStatementsAfterLoad(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFilterClick(Sender: TObject);
    procedure ctkDataFilterRecord(Sender: TObject; ID: IDispatch;
      var Include: Boolean);
    procedure Allitems1Click(Sender: TObject);
    procedure MatchedItemsonly1Click(Sender: TObject);
    procedure UnmatchedItemsonly1Click(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure btnAutoClick(Sender: TObject);
    procedure mlStatementsColumnClick(Sender: TObject; ColIndex: Integer;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    InitSize : TPoint;
    Closing, FirstTime : Boolean;
    StatementFilter : TStatementFilter;
    bRestore : Boolean;
    function StatusString(const StatLine : IBankStatementLine) : string;
    procedure SetStatementFilter(FilterType : TStatementFilter);
    procedure SaveAllSettings;
    procedure LoadAllSettings;
  public
    { Public declarations }
    oStatement : IBankStatement;
    oToolkit : IToolkit3;
    ParentHandle : THandle;
    function Match(const StatLine : IBankStatementLine) : Integer;
    function UnMatch(const StatLine : IBankStatementLine) : Integer;
  end;

{var
  frmStatement: TfrmStatement;}

{  procedure ShowStatementForm(AHandle    : THandle;
                        const AToolkit   : IToolkit3;
                        const AStatement : IBankStatement);}

implementation

{$R *.dfm}
uses
  EtDateU, BtSupU1, TransLst, ApiUtil, ReconObj, TranFile, BtrvU2, GlobVar, BtKeys1U, VarConst;

{procedure ShowStatementForm(AHandle    : THandle;
                      const AToolkit   : IToolkit3;
                      const AStatement : IBankStatement);
begin
  if not Assigned(frmStatement) then
    frmStatement := TfrmStatement.Create(Application.MainForm);

  with frmStatement do
  begin
    oStatement := AStatement;
    oToolkit := AToolkit;
    ParentHandle := AHandle;
    edtDate.Text := POutDate(oStatement.bsDate);
    edtRef.Text := oStatement.bsReference;
    ctkData.ToolkitObject := oStatement.bsStatementLine as IBtrieveFunctions2;
    mlStatements.Active := True;
  end;

  frmStatement.BringToFront;
end;}

procedure TfrmStatement.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmStatement.ctkDataGetFieldValue(Sender: TObject;
  ID: IDispatch; FieldName: String; var FieldValue: String);
begin
  with ID as IBankStatementLine do
  begin
    Case FieldName[1] of
      'L'  :  FieldValue := IntToStr(bslLineNo);
      'D'  :  FieldValue := POutDate(bslLineDate);
      'A'  :  FieldValue := ProcessValue(bslValue);
      'R'  :  FieldValue := Trim(bslReference);
      'S'  :  FieldValue := StatusString(ID as IBankStatementLine);
    end;
  end;
end;

procedure TfrmStatement.FormCreate(Sender: TObject);
begin
//By default set form to appear just to the right of Reconciliation form
  Width := 459;
  Height := 341;
  if Assigned(Owner) then
  begin
    Left := 1 + (Owner As TForm).Left + (Owner as TForm).Width;
    Top := (Owner As TForm).Top;
  end;
  InitSize.X := Width;
  InitSize.Y := Height;

  FirstTime := True;
  Closing := False;

  oSettings.EXEName := ExtractFilename(GetModuleName(HInstance));
  oSettings.UserName := GetUserID;
  bRestore := False;
  LoadAllSettings;
end;

procedure TfrmStatement.FormResize(Sender: TObject);
begin
  pnlBtns.Left := Panel1.Width - pnlBtns.Width - 4;
  mlStatements.Width := pnlBtns.Left  - mlStatements.Left - 4;
  Panel3.Width := mlStatements.Width;
  pnlBtns.Height := Panel1.Height - 8;
  mlStatements.Height :=  Panel1.Height - Panel3.Height - 12;
end;

procedure TfrmStatement.mlStatementsDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  if Source is TDBMultiList then
    Accept := True;
end;

function TfrmStatement.Match(const StatLine : IBankStatementLine): Integer;
var
  Res, i : Integer;
  LDetailRec : TTempTransDetails;
  KeyS : Str255;
  WhichPage : Integer;
  RecAddr : longint;
begin
  Result := 0;
  if Abs(StatLine.bslValue - (Owner as TfrmTransList).TaggedValue) < 0.001 then
  begin

    if (Owner as TfrmTransList).ListSettings.MultiSelect then
    begin
      with Owner as TfrmTransList do
      begin
        while mlTrans.MultiSelected.Count > 0 do
        begin
          LDetailRec := GetMultiSelectRecord(0);
          LDetailRec.btdStatus := iMatch;
          ReconcileObj.AddMatch(StatLine, LDetailRec);
          mlTrans.MultiSelected.Delete(0);
        end;
      end;
    end
    else
    begin
      WhichPage := (Owner as TfrmTransList).TabControl1.TabIndex;
      Res := Find_Rec(B_GetLast, TmpFile, RecTempF, LDetailRec, 2, KeyS);

      while (Res = 0) and (LDetailRec.btdStatus and iTag = iTag) do
      begin
        //Store position
        Res := GetPos(TmpFile, RecTempF, RecAddr);
        if (ReconcileObj.FindLine(LDetailRec.btdLineKey, 1) <> 0) and
           ((WhichPage = 1) or (LDetailRec.btdDocType <> 'RUN')) then
        begin
          LDetailRec.btdStatus := iMatch;
          LDetailRec.btdStatLine := StatLine.bslLineNo;
          if LDetailRec.btdDocType = 'RUN' then
            LDetailRec.btdNumberMatched :=  LDetailRec.btdNoOfItems;
          Put_Rec(TmpFile, RecTempF, LDetailRec, 2);
          if LDetailRec.btdDocType = 'RUN' then
          begin
            ReconcileObj.NoUpdate := True;
            ReconcileObj.AddMatch(StatLine, LDetailRec);
            ReconcileObj.NoUpdate := False;
          end
          else
            ReconcileObj.AddMatch(StatLine, LDetailRec);

          if (LDetailRec.btdDocType <> 'RUN') then
            UpdateGroupMatched(LDetailRec.btdPayInRef, LDetailRec.btdDate, True, StatLine.bslLineNo)
          else
            UpdateGroupLines(LDetailRec.btdPayInRef, LDetailRec.btdFullPayInRef, LDetailRec.btdDate, iMatch, LDetailRec.btdStatLine);
        end;
//        LDetailRec.btdStatus := LDetailRec.btdStatus and not Tag;
//        Put_Rec(TmpFile, RecTempF, LDetailRec, 2);

        //Restore Position
        Move(RecAddr, LDetailRec, SizeOf(RecAddr));
        Res := GetDirect(TmpFile, RecTempF, LDetailRec, 2, 0);

        Res := Find_Rec(B_GetLast, TmpFile, RecTempF, LDetailRec, 2, KeyS);
      end;
    end;
    PostMessage(ParentHandle, WM_CustGetRec, 58, 0);
//    (Owner as TfrmTransList).RefreshList;
    //Move to the next statement line in the list
    if mlStatements.Selected < mlStatements.ItemsCount - 1 then
      mlStatements.Selected := mlStatements.Selected + 1;

  end
  else
    msgBox('The value of the tagged items does not match the value of this statement line',
            mtWarning, [mbOK], mbOK, 'Bank Reconciliation');
end;

procedure TfrmStatement.btnTagClick(Sender: TObject);
var
  StatLine : IBankStatementLine;
begin
  StatLine := ctkData.GetRecord as IBankStatementLine;
  if StatusString(StatLine) = '' then
    Match(StatLine)
  else
    UnMatch(StatLine);
  if Assigned(frmTransList) then
    frmTransList.ShowBalances;
end;

procedure TfrmStatement.FormDestroy(Sender: TObject);
begin
  if Closing then
    (Owner as TfrmTransList).StatementFormClosed(Self);
end;

procedure TfrmStatement.mlStatementsAfterLoad(Sender: TObject);
begin
  if FirstTime then
  begin
    mlStatements.Selected := 0;
    FirstTime := False;
//    ActiveControl := mlStatements;
  end;
end;

procedure TfrmStatement.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
  Closing := True;
  Action := caFree;
end;

function TfrmStatement.StatusString(const StatLine : IBankStatementLine) : string;
begin
  if StatLine.bslStatus = bslsComplete then
    Result := 'Complete'
  else
  if ((ReconcileObj.FindLine(FullNomKey(MaxInt) + FullNomKey(StatLine.bslLineNo), 2) = 0) and
       (ReconcileObj.bnkDetail.brLineStatus = iMatch)) or
     ReconcileObj.FindGroupMatchForStatement(StatLine.bslReference, StatLine.bslLineNo) then
      Result := 'Matched'
  else
    Result := '';
end;

procedure TfrmStatement.btnFilterClick(Sender: TObject);
var
  ListPoint : TPoint;
begin
  ListPoint.X:=1;
  ListPoint.Y:=1;

  ListPoint:=btnFilter.ClientToScreen(ListPoint);

  popFilter.Popup(ListPoint.X, ListPoint.Y);
end;

procedure TfrmStatement.ctkDataFilterRecord(Sender: TObject; ID: IDispatch;
  var Include: Boolean);
begin
  Include := (StatementFilter = sfAll) or
             ((StatementFilter = sfUnmatched) xor
              (ReconcileObj.FindLine(FullNomKey(MaxInt) + FullNomKey((ID as IBankStatementLine).bslLineNo), 2) = 0));
end;

procedure TfrmStatement.SetStatementFilter(FilterType: TStatementFilter);
begin
  StatementFilter := FilterType;
  mlStatements.RefreshDB;
end;


procedure TfrmStatement.Allitems1Click(Sender: TObject);
begin
  SetStatementFilter(sfAll);
end;


procedure TfrmStatement.MatchedItemsonly1Click(Sender: TObject);
begin
  SetStatementFilter(sfMatched);
end;

procedure TfrmStatement.UnmatchedItemsonly1Click(Sender: TObject);
begin
  SetStatementFilter(sfUnmatched);
end;

procedure TfrmStatement.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(mlStatements, Self.Name, nil) of
{    mrOK : oSettings.ColorFieldsFrom(cmbCompany, Self);}
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      oSettings.RestoreListDefaults(mlStatements, Self.Name);
      bRestore := TRUE;
    end;
  end;{case}

end;

procedure TfrmStatement.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadList(mlStatements, Self.Name);
end;

procedure TfrmStatement.SaveAllSettings;
begin
  oSettings.SaveList(mlStatements, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;

procedure TfrmStatement.btnAutoClick(Sender: TObject);
begin
  if Assigned(frmTransList) then
  begin
    btnAuto.Enabled := False;
    frmTransList.Reconcile(oStatement);
  end;
end;

function TfrmStatement.UnMatch(
  const StatLine: IBankStatementLine): Integer;
var
  LDetailRec : TTempTransDetails;
begin
  Result := 0;
  LDetailRec := frmTransList.CurrentDetailsRecord;
  if (LDetailRec.btdStatLine = StatLine.bslLineNo) {or ReconcileObj.FindGroupMatch(LDetailRec.btdPayInRef,
                                                                                    LDetailRec.btdDate,
                                                                                    LDetailRec.btdLineKey)} then
  begin
    ReconcileObj.DeleteMatch(LDetailRec.btdPayInRef, LDetailRec.btdDate, True);
    ReconcileObj.DeleteMatch(FullNomKey(MaxInt) + FullNomKey(StatLine.bslLineNo), LDetailRec.btdDate, False);

    ReconcileObj.NoUpdate := True;
    UpdateGroupMatched(LDetailRec.btdPayInRef, LDetailRec.btdDate, False);
    ReconcileObj.NoUpdate := False;

  //  (Owner as TfrmTransList).RefreshList;
    UpdateGroupLines(LDetailRec.btdPayInRef, LDetailRec.btdFullPayInRef, LDetailRec.btdDate, 0, 0);
    PostMessage(ParentHandle, WM_CustGetRec, 58, 0);
  end;
end;

procedure TfrmStatement.mlStatementsColumnClick(Sender: TObject;
  ColIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  mlStatements.HelpContext := 2013 + ColIndex;
end;

end.
