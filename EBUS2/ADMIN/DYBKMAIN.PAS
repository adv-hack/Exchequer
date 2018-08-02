unit Dybkmain;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ComCtrls, ExtCtrls, SBSPanel,
  SBSComp, SBSComp2, BTSupU1, ColCtrlU, GlobVar, ETDateU, EBusCnst,
  CmpCtrlU, SupListU, Menus, BtrvList, DybkTrns, ActnList, {HTMLView,}
 { HTMLLite,}
  LogView, LibXmlComps, ImgList, Htmlview;   (*IpHtml, IpUtils, IpBroker, OleCtrls, SHDocVw*)

type
  TEBusTransList = class(TGenList)
    public
      function SetCheckKey : Str255; override;
      function OutLine(Col : byte) : str255; override;
  end;

  TfrmDayBook = class(TForm)
    mnuPopup: TPopupMenu;
    mniClose: TMenuItem;
    mniEdit: TMenuItem;
    mniHold: TMenuItem;
    mniTag: TMenuItem;
    mniPost: TMenuItem;
    mniSubPostCurrent: TMenuItem;
    mniSubPostTagged: TMenuItem;
    mniSubPostAll: TMenuItem;
    mniDelete: TMenuItem;
    mnuPopupSep1: TMenuItem;
    mniProperties: TMenuItem;
    mnuPopupSep2: TMenuItem;
    mniSaveOnExit: TMenuItem;
    mniRefresh: TMenuItem;
    actDaybookMain: TActionList;
    actRefresh: TAction;
    mniView: TMenuItem;
    mnuDelete: TPopupMenu;
    mniDeleteCurrent: TMenuItem;
    mniDeleteTagged: TMenuItem;
    mniDeleteErrors: TMenuItem;
    mnuPost: TPopupMenu;
    mniPostCurrent: TMenuItem;
    mniPostTagged: TMenuItem;
    mniPostAll: TMenuItem;
    mnuTag: TPopupMenu;
    mniTagCurrent: TMenuItem;
    mniTagAll: TMenuItem;
    mniUntagAll: TMenuItem;
    actClose: TAction;
    actEditTrans: TAction;
    actViewTrans: TAction;
    actHoldTrans: TAction;
    actTagTrans: TAction;
    actHTML: TAction;
    pnlClient: TPanel;
    sptFormDivider: TSplitter;
    pnlButtons: TSBSPanel;
    sbxButtons: TScrollBox;
    btnEdit: TButton;
    btnPost: TButton;
    btnDelete: TButton;
    btnTag: TButton;
    btnHold: TButton;
    btnRefresh: TButton;
    btnView: TButton;
    btnClose: TButton;
    sbxMain: TScrollBox;
    pnlDate: TSBSPanel;
    pnlORef: TSBSPanel;
    pnlPer: TSBSPanel;
    pnlAC: TSBSPanel;
    pnlAmnt: TSBSPanel;
    pnlStat: TSBSPanel;
    pnlColumnHeaders: TSBSPanel;
    pnlORefHead: TSBSPanel;
    pnlDateHead: TSBSPanel;
    pnlACHead: TSBSPanel;
    pnlAmntHead: TSBSPanel;
    pnlStatHead: TSBSPanel;
    pnlPerHead: TSBSPanel;
    pnlYRefHead: TSBSPanel;
    pnlYRef: TSBSPanel;
    pnlListControls: TSBSPanel;
    pnlBottom: TPanel;
    pgcTransactions: TPageControl;
    tabImportLog: TTabSheet;
    tabHTML: TTabSheet;
    edtLog: TRichEdit;
    Panel1: TPanel;
    mniSubDeleteCurrent: TMenuItem;
    mniSubDeleteTagged: TMenuItem;
    mniSubDeleteErrors: TMenuItem;
    btnShowHide: TButton;
    actHideShow: TAction;
    mniHideDetails: TMenuItem;
    cbxStyleSheet: TComboBox;
    tabXML: TTabSheet;
    lvXML: TListView;
    ImageList1: TImageList;
    HTMLViewer: THTMLViewer;
    PrintDialog1: TPrintDialog;
    btnPrint: TButton;
    XmlScanner: TXmlScanner;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HeadersMouseDownExecute(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HeadersMouseMoveExecute(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MoveAlignColsExecute(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mniSaveOnExitClick(Sender: TObject);
    procedure mniPropertiesClick(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure btnClickShowPopup(Sender: TObject);
    procedure mniDeleteClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure actCloseExecute(Sender: TObject);
    procedure actEditTransExecute(Sender: TObject);
    procedure actViewTransExecute(Sender: TObject);
    procedure actHoldTransExecute(Sender: TObject);
    procedure actTagTransExecute(Sender: TObject);
    procedure mniPostClick(Sender: TObject);
    procedure mnuPopupPopup(Sender: TObject);
    procedure btnViewLogClick(Sender: TObject);
    procedure actHTMLExecute(Sender: TObject);
    procedure sptFormDividerMoved(Sender: TObject);
    procedure sptFormDividerCanResize(Sender: TObject;
      var NewSize: Integer; var Accept: Boolean);
    procedure actHideShowExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pgcTransactionsChange(Sender: TObject);
    procedure cbxStyleSheetChange(Sender: TObject);
    procedure XmlScannerXmlProlog(Sender: TObject; XmlVersion,
      Encoding: String; Standalone: Boolean);
    procedure XmlScannerContent(Sender: TObject; Content: String);
    procedure XmlScannerEmptyTag(Sender: TObject; TagName: String;
      Attributes: TAttrList);
    procedure XmlScannerEndTag(Sender: TObject; TagName: String);
    procedure XmlScannerStartTag(Sender: TObject; TagName: String;
      Attributes: TAttrList);
    procedure btnPrintClick(Sender: TObject);
  private
    FormStuff : TFormStuff;
    BottomPanelRatio : single;
    frmOneTransaction : TfrmOneTransaction;
//    frmHTMLView : TfrmHTMLTransViewer;
    frmLogView : TfrmLogFileViewer;
    fHTMLFileName : string;

    LoadingXSL,
    fDoingClose   :  Boolean;

    CurrIndentLevel : integer;
    LatestItem : TListItem;

    function GETXSLPath : string;
    function ArchivedXMLPath : string;
    function  ArchivedXMLFileName : string;
    function  EquivalentHTMLFileName : string;
    function  EquivalentLogFileName : string;
    procedure WMSysCommand(var Message : TMessage); message WM_SysCommand;
    procedure WMCustGetRec(var Message : TMessage); message WM_CustGetRec;
    procedure WMFormCloseMsg(var Message : TMessage); message WM_FormCloseMsg;
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure RefreshList;
    procedure RefreshOneLine(Edited : boolean);
    procedure ShowTransDetailsForm(EditMode : TFormActivate);
    procedure LinkTransDetailsForm;
    procedure LoadLog;
    procedure LoadHTML(ForceReload  :  Boolean);
    procedure ReadStyleSheets;
    procedure CloseForm(ViaDestroy  :  Boolean);
    procedure LoadXml;

  public
  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


{$R *.DFM}

uses
  BtrvU2, VarConst, AdmnUtil, EBusVar, BTKeys1U, UseDLLU, EBusUtil, PostMsgU,
  ComnUnit, XMLFuncs, FileUtil, XMLUtil, TKUtil, MathUtil, PostTran, TagInpU,
  ADOConnect, SQLUtils;

const
  DEF_CLIENT_HEIGHT = 352;
  DEF_CLIENT_WIDTH = 625;
  BASE_FORM_LETTER = 'C';

//-----------------------------------------------------------------------

function TEBusTransList.SetCheckKey : Str255;
begin
  FillChar(Result,Sizeof(Result), 0);
  with Inv do
    Result := FullDayBkKey(RunNo, FolioNum, OurRef);
end;

//-----------------------------------------------------------------------

function TEBusTransList.OutLine(Col : byte) : str255;
var
  OurRefPrefix : string;
begin
  with Inv do
  begin
    Result := '';
    case Col of
      0: Result := OurRef;
      1: Result := POutDate(TransDate);
      2: Result := Format('%.2d/%d', [AcPr, TxLateYrVal(AcYr, false)]);
      3: Result := CustCode;
      4: begin
           OurRefPrefix := copy(OurRef, 1, 3);
           if (OurRefPrefix = EBUS_SOR) or (OurRefPrefix = EBUS_POR) then
             //PR 15/09/03 subtract discamount so that display is consistent with enterprise
             Result := ToFixedDP(InvNetVal - DiscAmount, 2, Currency)
           else
             Result := ToFixedDP(ITotal(Inv), 2, Currency);
         end;
      5: Result := YourRef;
      6: Result := HoldStatusDescription(HoldFlg, Tagged);
     end; // case
  end; // with
end;


//=======================================================================

function TfrmDayBook.GETXSLPath : string;
begin
  // Post : Returns Main Company\EBUS\XML\XSL
  Result := CurCompSettings.CompanyPath +
    IncludeTrailingBackSlash(EBUS_DIR) +
    IncludeTrailingBackslash(EBUS_XML_DIR) +
    IncludeTrailingBackslash(EBUS_XSL_DIR);
end;


//=======================================================================

function TfrmDayBook.ArchivedXMLPath : string;
begin
  // Assumes that archived XML files are in company\EBUS\XML\Archived ...
  Result := CurCompSettings.CompanyPath +
    IncludeTrailingBackslash(EBUS_DIR) +
    IncludeTrailingBackslash(EBUS_XML_DIR) +
    IncludeTrailingBackslash(EBUS_XML_ARCHIVED_DIR);
end;


//=======================================================================

function TfrmDayBook.ArchivedXMLFileName : string;
begin
  // Assumes that archived XML files are in company\EBUS\XML\Archived ...
  Result := ArchivedXMLPath+Inv.DocUser1;
end;

//-----------------------------------------------------------------------

function TfrmDayBook.EquivalentHTMLFileName : string;
begin
  Result := ArchivedXMLPath +
    ChangeFileExt(ExtractFileName(ArchivedXMLFileName), '.HTM');
end;

//-----------------------------------------------------------------------

function TfrmDayBook.EquivalentLogFileName : string;
begin
  Result := CurCompSettings.CompanyPath +
    IncludeTrailingBackslash(EBUS_DIR) +
    IncludeTrailingBackslash(EBUS_LOGS_DIR) +
    IncludeTrailingBackslash(EBUS_LOGS_IMPORTED_DIR) +
    TransNoToLogName(Inv.OurRef);
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.WMCustGetRec(var Message : TMessage);
begin
  with Message do
    case WParam of
      0: // Double click
         ShowTransDetailsForm(actEdit);
      1: // Row with data gets focus
         // Message relaying to avoid problems with mouse up event
         begin
           PostMessage(Self.Handle, WM_FormCloseMsg,1000+WParam,0);
         end;
      2: // Right click
          mnuPopup.PopUp(LParamLo, lParamHi);
      200: // Add / update performed
          with FormStuff.aMUlCtrlO[0] do
            RefreshOneLine(LParam=1);
      300: // Delete performed
          RefreshList;
      EBUS_FORM_CLOSE:
        case LParam of
          FORM_TRANS :
            begin
              frmOneTransaction := nil;
              // Details which are on the main list might have been updated
              // e.g. customer code etc.
              RefreshOneLine(true);
            end;
        //  FORM_HTML_VIEW : frmHTMLView := nil;
          FORM_LOG_VIEW  : frmLogView := nil;
        end;
    end; // case
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.WMFormCloseMsg(var Message : TMessage);
begin
  // Avoids problem with coordination between parent and child form refresh
  with Message do
    case WParam of
      1001 : LinkTransDetailsForm;
    end;
end; // TfrmEBusinessOrders.WMFormCloseMsg


//-----------------------------------------------------------------------

procedure TfrmDayBook.CloseForm(ViaDestroy  :  Boolean);
begin
  If (Not fDoingClose) and (Not Application.Terminated) then
  Begin
    fDoingClose:=BOn;

    If (Assigned(FormStuff)) then
    Begin
      with FormStuff do
        StoreFormProperties(Self, FormStuff, bStoreCoord, bSetDefaults, bLastCoord, BASE_FORM_LETTER);

      FormStuff.Free;
      FormStuff:=Nil;
    end;

    CloseEBusCompanyFile(InvF);
    CloseEBusCompanyFile(IDetailF);
    SendMessage((Owner as TForm).Handle, WM_CustGetRec, EBUS_FORM_CLOSE, FORM_DAYBOOK);
  end;
end;


//-----------------------------------------------------------------------

procedure TfrmDayBook.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  Action := caFree;
  CloseForm(BOff);

end;

//-----------------------------------------------------------------------


procedure TfrmDayBook.FormDestroy(Sender: TObject);
begin
  //PR: 01/02/2016 ABSEXCH-17116 v2016 R1
  if SQLUtils.UsingSQL then
    TerminateGlobalADOConnection;
  CloseForm(BOn);
end;


procedure TfrmDayBook.LinkTransDetailsForm;
begin
  with FormStuff.aMULCtrlO[0] do
    RefreshLine(MUListBoxes[0].Row, false);
  if Assigned(frmOneTransaction) then
    frmOneTransaction.RefreshDetails;
  LoadLog;
  LoadHTML(BOff);
  LoadXml;
(*  if Assigned(frmHTMLView) then
    frmHTMLView.RefreshHTML(Inv.OurRef, ArchivedXMLFileName); *)
end; // TfrmDayBook.LinkTransDetailsForm

//-----------------------------------------------------------------------

procedure TfrmDayBook.ShowTransDetailsForm(EditMode : TFormActivate);
begin
  if (EditMode = actEdit) then
    if not ThisUser.CanEdit then
      EditMode := actShow;
  if not Assigned(frmOneTransaction) and FormStuff.aMulCtrlO[0].ValidLine then
  begin
    frmOneTransaction := TfrmOneTransaction.Create(self);
    frmOneTransaction.EditMode := EditMode;
    frmOneTransaction.ReadTransaction;
(*    if EditMode = actShow then
      LinkTransDetailsForm; *)
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.actRefreshExecute(Sender: TObject);
begin
  RefreshList;
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.HeadersMouseDownExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {depresses the column header}
  if (Sender is TSBSPanel) and (not TSBSPanel(Sender).ReadytoDrag) and (Button = MBLeft)
  then FormStuff.aMULCtrlO[0].VisiList.PrimeMove(Sender); {begin column drag/drop}
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.HeadersMouseMoveExecute(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  {visually moves column header to show the change about to be made (drag/drop}
  if (Sender is TSBSPanel) then FormStuff.aMULCtrlO[0].VisiList.MoveLabel(X,Y);
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.MoveAlignColsExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender is TSBSPanel) then DoMoveAlignCols(TSBSPanel(Sender), FormStuff, 0);
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.FormResize(Sender: TObject);
begin
  DoFormResize(Self, FormStuff, pnlClient);
  if pnlBottom.Height <> 0 then
  begin
    BottomPanelRatio := pnlBottom.Height / ClientHeight;
    actHideShow.Caption := '&Hide Details';
  end
  else
    actHideShow.Caption := '&Show Details';
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.FormCreate(Sender: TObject);
begin
  fDoingClose:=BOff;
  LoadingXSL:=BOn;
  
  OpenEBusCompanyFile(InvF, CurCompSettings.CompanyCode, true);
  OpenEBusCompanyFile(IDetailF, CurCompSettings.CompanyCode, true);
  OpenEBusCompanyFile(PwrdF, CurCompSettings.CompanyCode, true);

  FormStuff := TFormStuff.Create(1);

  ClientHeight := DEF_CLIENT_HEIGHT;
  ClientWidth := DEF_CLIENT_WIDTH;

  with FormStuff do
  begin
    Try
      bFillList := true;
      SetLength(aColumns[0], 7);
      // Our Reference
      aColumns[0,0].ColPanel := pnlORef;
      aColumns[0,0].HeadPanel := pnlORefHead;
      // Transaction date
      aColumns[0,1].ColPanel := pnlDate;
      aColumns[0,1].HeadPanel := pnlDateHead;
      // Financial period
      aColumns[0,2].ColPanel := pnlPer;
      aColumns[0,2].HeadPanel := pnlPerHead;
      // Account code
      aColumns[0,3].ColPanel := pnlAC;
      aColumns[0,3].HeadPanel := pnlACHead;
      // Amount
      aColumns[0,4].ColPanel := pnlAmnt;
      aColumns[0,4].HeadPanel := pnlAmntHead;
      aColumns[0,4].Alignment := taRightJustify;
      aColumns[0,4].DecPlaces := 2;
      // Your reference
      aColumns[0,5].ColPanel := pnlYRef;
      aColumns[0,5].HeadPanel := pnlYRefHead;
      // Status
      aColumns[0,6].ColPanel := pnlStat;
      aColumns[0,6].HeadPanel := pnlStatHead;

      aFileNos[0] := InvF;
      asbMain[0] := sbxMain;
      apanTitle[0] := pnlColumnHeaders;
      asbButtons[0] := sbxButtons;
      apanButtons[0] := pnlButtons;
      aMULCtrlO[0] := TEBusTransList.Create(Self);
      apanScrollBar[0] := pnlListControls;
      aiKeys[0] := 0;
      aKeyStart[0] := FullDayBkKey(0, 0, 'E');
      aKeyEnd[0] := FullDayBkKey(0, MAXLONGINT, 'E');
      aKeyLength[0] := 5;

      sbxMain.HorzScrollBar.Position := 0;
      sbxMain.VertScrollBar.Position := 0;

      // Added panel parameter !!!
      ReadFormProperties(Self, FormStuff, BASE_FORM_LETTER, pnlClient);
      FormResize(Self);
    except
      FormStuff.Free;
      FormStuff:=Nil;
    end;
  end;
  pgcTransactions.ActivePage := tabImportLog;
  if pnlBottom.Height = 0 then
    BottomPanelRatio := 0.4
  else
    BottomPanelRatio := pnlBottom.Height / ClientHeight;
  ReadStyleSheets;

  btnEdit.Enabled := ThisUser.CanEdit;
  btnDelete.Enabled := ThisUser.CanDelete;
  btnHold.Enabled := ThisUser.CanHold;
  btnPost.Enabled := ThisUser.CanPost;
  tabHTML.Tabvisible := ThisUser.CanViewHTML;
  btnPrint.Enabled := ThisUser.CanViewHTML;
  tabXML.TabVisible := ThisUser.CanViewXML;
  tabImportLog.TabVisible := ThisUser.CanViewImpLogs;

  //PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Needed for SystemSetup singleton
  if SQLUtils.UsingSQL then
    InitialiseGlobalADOConnection (CurCompSettings.CompanyPath);
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.mniSaveOnExitClick(Sender: TObject);
begin
  FormStuff.bStoreCoord := not FormStuff.bStoreCoord;
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.mniPropertiesClick(Sender: TObject);
begin
  with FormStuff do
    ListProperties(Self, aMULCtrlO[0], bSetDefaults, 'EBusiness Daybook Properties');
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.WMSysCommand(var Message : TMessage);
// Notes : Prevent the form from maximising when the maximise title bar
//         button is clicked.  Standard Enterprise behaviour for an MDI child.
begin
  with Message do
    case WParam of
      SC_Maximize :
        begin
          Self.ClientHeight := DEF_CLIENT_HEIGHT;
          Self.ClientWidth := DEF_CLIENT_WIDTH;
          WParam := 0;
        end;
    end; // case
  inherited;
end; // TfrmEBusinessOrders.WMSysCommand

//-----------------------------------------------------------------------

procedure TfrmDayBook.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
begin
  with Message.MinMaxInfo^ do
  begin
    ptMinTrackSize.X:=242;
    ptMinTrackSize.Y:=182;
  end;
  Message.Result := 0;
  Inherited;
end; // TfrmEBusinessOrders.WMGetMinMaxInfo

//-----------------------------------------------------------------------

procedure TfrmDayBook.RefreshList;
// Notes : This routine refreshes the whole list - use for deletes
//         and updates that affect multiple rows.
begin
 with FormStuff.aMulCtrlO[0] do
   if (MUListBox1.Row <> 0) and (PageKeys[0] <> 0) then
     PageUpDn(0, true)
   else
     InitPage;
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.RefreshOneLine(Edited : boolean);
// Pre   : Edited = true  => line has been edited in list (update highlighted row)
//         Edited = false => line has been added to list
// Notes : Use when one line is updated only e.g. single line edited or
//         single line added.
begin                               
  with FormStuff.aMUlCtrlO[0] do
    AddNewRow(MUListBoxes[0].Row, Edited);
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.btnClickShowPopup(Sender: TObject);
var
  Posn : TPoint;
begin
  if FormStuff.aMulCtrlO[0].ValidLine then
  begin
    // Position pop-up menu over button
    Posn := Point(1,1);
    with TControl(Sender) do
      Posn := ClientToScreen(Posn);

    if Sender = btnPost then
      mnuPost.PopUp(Posn.X, Posn.Y);
    if Sender = btnDelete then
      mnuDelete.PopUp(Posn.X, Posn.Y);
    if Sender = btnTag then
      mnuTag.PopUp(Posn.X, Posn.Y);
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.mniDeleteClick(Sender: TObject);
var
  Status : integer;
  KeyS : str255;
  Msg : string;
  DelCur,      // Delete current row selected
  DelTagged,   // Delete tagged rows selected
  DelErrors,   // Delete error rows selected
  AllDeleted,
  DeleteLine : boolean;

  procedure DeleteDayBookRecord(WarnOnLocked : boolean);
  // Pre   : WarnOnLocked = true => inform user transaction cannot be deleted as it is
  //         locked.
  // Notes : When processing multiple transactions, probably best not to warn on each
  //         locked record
  var
    FolioNum : longint;
    SearchKey,
    CurKey : str255;
    Choice : word;
    Status : integer;
  begin
    FolioNum := Inv.FolioNum;

    repeat
      Status := Delete_Rec(F[InvF], InvF, 0);
      Choice := mrNone;
      if (Status in [84, 85]) and WarnOnLocked then
        Choice := MessageDlg('Record in use by another station!',
          mtConfirmation, [mbRetry, mbCancel], 0);
    until not (Status in [84, 85]) or (Choice in [mrNone, mrCancel]);

    AllDeleted := AllDeleted and (Status = 0);

    if not (Status in [0, 84, 85]) then
      MessageDlg(Format('Attempting to delete transaction %s returned status %d'
        + #13#10 + '%s', [Inv.OurRef, Status, Set_StatMes(Status)]), mtError, [mbOK], 0)
    else
    begin // Delete associated details lines
      SearchKey := FullNomKey(FolioNum);
      CurKey := SearchKey;
      Status := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, 0, CurKey);
      while (Status = 0) and (copy(CurKey,1,4) = copy(SearchKey,1,4)) do
      begin
        Delete_Rec(F[IDetailF], IDetailF, 0);
        DeletePreserveLine(Inv.OurRef, Id.LineNo);
        Status := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, 0, CurKey);
      end;

      //Delete notes
      SearchKey := 'ND' + FullNomKey(FolioNum);
      CurKey := SearchKey;
      Status := Find_Rec(B_GetGEq, F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0, CurKey);
      while (Status = 0) and (copy(CurKey,1,6) = copy(SearchKey,1,6)) do
      begin
        Delete_Rec(F[PwrdF], PwrdF, 0);
        Status := Find_Rec(B_GetNext, F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0, CurKey);
      end;

    end;
  end; // DeleteDayBookRecord

begin // TfrmDayBook.mniDeleteClick
  DelCur := (Sender = mniDeleteCurrent) or (Sender = mniSubDeleteCurrent);
  DelTagged := (Sender = mniDeleteTagged) or (Sender = mniSubDeleteTagged);
  DelErrors := (Sender = mniDeleteErrors) or (Sender = mniSubDeleteErrors);

  with FormStuff.aMulCtrlO[0], Inv do
  begin
    if DelCur then
    begin
      if ConfirmRecordDelete('this record') then
      begin // Delete the current row
        GetSelRec(false);
        // Locking ???
        DeleteDayBookRecord(true);
        RefreshList;
      end;
    end
    else
    begin
      AllDeleted := true;
      if DelErrors then
        Msg := 'error! records'
      else
        Msg := 'tagged records';
      if ConfirmRecordDelete(Msg) then
      begin // Delete all tagged rows
        KeyS := FullDayBkKey(0, 0, 'E');
        Status := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, 0, KeyS);
        while (Status = 0) and (Inv.RunNo = 0) do
        begin
          DeleteLine := (DelTagged and (Tagged > 0)) (* or
           ((Sender = mniDeleteErrors) and (HoldFlg AND HOLD_STAT_ERROR = HOLD_STAT_ERROR))*);
          if DeleteLine then
            DeleteDayBookRecord(false);
          Status := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, 0, KeyS);
        end;
        if not AllDeleted then
          MessageDlg('Not all selected lines could be deleted', mtInformation, [mbOK], 0);
        RefreshList;
      end;
    end;
  end; // with
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.mniPostClick(Sender: TObject);
begin
  if (Sender = mniPostCurrent) or (Sender = mniSubPostCurrent) then
  begin
    FormStuff.aMulCtrlO[0].GetSelRec(false);
    PostSingleTransaction;
  end
  else
    if (Sender = mniPostTagged) or (Sender = mniSubPostTagged) then
      PostTaggedTransactions
    else
      if (Sender = mniPostAll) or (Sender = mniSubPostAll) then
      begin
        PostAllTransactions;
        FormStuff.aMulCtrlO[0].MuListBox1.Row := 0;
      end;
   RefreshList;
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
// Notes : USe F5 from the form to refresh the list similar to a list view
begin
  if Key = VK_F5 then
    actRefreshExecute(self);
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.actCloseExecute(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.actEditTransExecute(Sender: TObject);
begin
  ShowTransDetailsForm(actEdit);
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.actViewTransExecute(Sender: TObject);
begin
  ShowTransDetailsForm(actShow);
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.actHoldTransExecute(Sender: TObject);
const
  FNum = InvF;
begin
  with FormStuff.aMulCtrlO[0], Inv do
  begin
    if ValidLine then
    begin
      GetSelRec(true);
      // Prevent tagged record from being put on / off Hold as user can't see this is
      // happening.  "Tagged" takes priority over "Hold" in status column
//      if Tagged > 0 then exit;
      HoldFlg := HoldFlg xor HOLD_STAT_HOLD;
      // Assume safest to use key already active in Btrieve list
      Put_Rec(F[FNum], FNum, RecPtr[FNum]^, 0);
      PageUpDn(0, true) // Refresh the list
    end; // with
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.actTagTransExecute(Sender: TObject);
const
  FNum = InvF;
var
  Status : integer;
  KeyS : str255;
  UpdateTag : boolean;
  TmpTag : SmallInt;
begin
  with FormStuff.aMulCtrlO[0], Inv do
  begin
    if (Sender = mniTagCurrent) or (Sender = mniTag) then
    begin // Switch the tagged status of the current line
      GetSelRec(false);
      if Tagged = 0 then
      begin
        TmpTag := Tagged;
        GetTagNo(TmpTag);
        Tagged := TmpTag;
      end
      else
        Tagged := 0;
      // Locking ???
      Put_Rec(F[FNum], FNum, RecPtr[FNum]^, 0);
      PageUpDn(0, true); // Refresh the list
    end
    else
    begin // Untag all tagged
      TmpTag := 0;
      if (Sender = mniTagAll) and not (Tagged > 0) then
        GetTagNo(TmpTag);
      KeyS := FullDayBkKey(0, 0, 'E');
      Status := Find_Rec(B_GetGEq, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
      while (Status = 0) and (Inv.RunNo = 0) do
      begin
        UpdateTag := false;
        if (Sender = mniUntagAll) and (Tagged > 0) then
        begin
          Tagged := 0;
          UpdateTag := true;
        end
        else
          if (Sender = mniTagAll) and not (Tagged > 0) then
          begin
            Tagged := TmpTag;
            UpdateTag := true;
          end;
        // Locking ???
        if UpdateTag then
          Put_Rec(F[FNum], FNum, RecPtr[FNum]^, 0);
        Status := Find_Rec(B_GetNext, F[FNum], FNum, RecPtr[FNum]^, 0, KeyS);
      end;
      PageUpDn(0, true); // Refresh the list
    end;
  end; // with
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.mnuPopupPopup(Sender: TObject);
var
  OnAValidLine : boolean;
begin
  OnAValidLine := FormStuff.aMulCtrlO[0].ValidLine;
  mniSaveOnExit.Checked := FormStuff.bStoreCoord;
  mniDelete.Enabled := OnAValidLine and ThisUser.CanDelete;
  mniHold.Enabled := OnAValidLine and ThisUser.CanHold;
  mniTag.Enabled := OnAValidLine;
  mniPost.Enabled := OnAValidLine and ThisUser.CanPost;
  mniEdit.Enabled := OnAValidLine and ThisUser.CanEdit;
  mniView.Enabled := OnAValidLine;
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.btnViewLogClick(Sender: TObject);
begin
  if not assigned(frmLogView) and FormStuff.aMulCtrlO[0].ValidLine then
    frmLogView := DisplaySingleLog(Inv.OurRef, self);
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.actHTMLExecute(Sender: TObject);
begin
(*  if not assigned(frmHTMLView) then
  begin
    frmHTMLView := TfrmHTMLTransViewer.Create(self);
    frmHTMLView.RefreshHTML(Inv.OuArchivedXMLFileName);
    frmHTMLView.Show;
  end; *)
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.sptFormDividerMoved(Sender: TObject);
begin
  FormResize(Self);
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.LoadLog;
begin
  if (pgcTransactions.ActivePage = tabImportLog) and (Assigned(FormStuff)) then
  with FormStuff.aMulCtrlO[0], Inv do
  begin

    try
      If (ValidLine) and (OurRef<>'') then
        edtLog.Lines.LoadFromFile(EquivalentLogFileName);
    except
    end;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.LoadHTML(ForceReload  :  Boolean);
var
  InitInfo : xmlInitInfoType;
  HTMLInfo : xmlHTMLInfoType;
  HTMLFileName,
  XSLFileName : string;
begin
  {if (pgcTransactions.ActivePage = tabHTML) then}
  begin
    HTMLFileName := EquivalentHTMLFileName;
    XSLFileName:=GetXSLPath+cbxStyleSheet.Text;

    If (Not FileExists(XSLFileName)) then
      XSLFileName:='';

    if FileExists(ArchivedXMLFileName) and ((ForceReLoad) or (not FileExists(HTMLFileName))) then
    begin
      HTMLInfo.xtLoadDir := ArchivedXMLFileName;
      HTMLInfo.xtSaveDir := ArchivedXMLPath;
      HTMLInfo.xtXSLLocation:=XSLFileName;
      InitInfo.xiDataPath := CurCompSettings.CompanyPath;
      InitInfo.xiCCyVer := GetMultiCurrencyCode;
      if xmlCreateHTMFile(InitInfo,HTMLInfo) = 0 then
        HTMLFileName := HTMLInfo.xtSaveDir;
    end;

 // When the HTML is being displayed all sorts of nasty access violations !!!
  if FileExists(HTMLFileName) then
      HTMLViewer.LoadfromFile(HTMLFileName);
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.ReadStyleSheets;
var
  SearchRec : TSearchRec;
  Status : integer;
begin
  LoadingXSL:=BOn;

  If (FileExists(GetXSLPath+EBus_XSL_DefXSL)) then {* Always add our first*}
    cbxStyleSheet.Items.Add(EBus_XSL_DefXSL);

  Status := FindFirst(GetXSLPath+ '*.XSL', faAnyFile, SearchRec);
  while Status = 0 do
  begin
    If (UpperCase(SearchRec.Name)<>UpperCase(EBus_XSL_DefXSL)) then {* We have already added it *}
      cbxStyleSheet.Items.Add(SearchRec.Name);

    Status := FindNext(SearchRec);
  end;
  SysUtils.FindClose(SearchRec);
  if cbxStyleSheet.Items.Count > 0 then
    cbxStyleSheet.ItemIndex := 0;

  LoadingXSL:=BOff;
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.sptFormDividerCanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
// Notes : Splitter is bottom aligned and therefore associated with the bottom panel
const
  MIN_LIST_HEIGHT = 154;
begin
  if (ClientHeight - NewSize) < MIN_LIST_HEIGHT then
    NewSize := ClientHeight - MIN_LIST_HEIGHT;
end;

//-----------------------------------------------------------------------

procedure TfrmDayBook.actHideShowExecute(Sender: TObject);
begin
  if pnlBottom.Height = 0 then
    pnlBottom.Height := round(ClientHeight * BottomPanelRatio)
  else
    pnlBottom.Height := 0;
  FormResize(self);
end;



procedure TfrmDayBook.pgcTransactionsChange(Sender: TObject);
begin
  With pgcTransactions do
  Begin
    cbxStyleSheet.Visible:=(Activepage=tabHTML);

    If (Activepage=tabHTML)  then
    Begin

      LoadHTML(BOff);

    end
    else
    if ActivePage = tabXML then
    begin
      LoadXml;
    end;


  end;
end;

procedure TfrmDayBook.cbxStyleSheetChange(Sender: TObject);
begin
  If (Not LoadingXSL) then
    LoadHTML(BOn);
end;

procedure TfrmDayBook.XmlScannerXmlProlog(Sender: TObject; XmlVersion,
  Encoding: String; Standalone: Boolean);
begin
  if lvXML.Items.Count = 0 then
    lvXML.Items.Add.Caption := '<?xml version="' + XmlVersion + '" ?>';

end;

procedure TfrmDayBook.XmlScannerContent(Sender: TObject; Content: String);
begin
  with LatestItem do
  begin
    Caption := Caption + Content;
{    Indent := CurrIndentLevel + 1;}
    Data := Pointer(1);
  end;

end;

procedure TfrmDayBook.XmlScannerEmptyTag(Sender: TObject; TagName: String;
  Attributes: TAttrList);
begin
  LatestItem := lvXML.Items.Add;
  with LatestItem do
  begin
   Caption := '<' + TagName + '/>';
   Indent := CurrIndentLevel;
  end;

end;

procedure TfrmDayBook.XmlScannerEndTag(Sender: TObject; TagName: String);
begin
  if Integer(LatestItem.Data) <> 1 then
  begin
    LatestItem := lvXML.Items.Add;
    with LatestItem do
    begin
      Caption := '</' + TagName + '>';
      Indent := CurrIndentLevel - 1;
    end;
  end
  else
  begin
    LatestItem.Caption := LatestItem.Caption + '</' + TagName + '>';
    LatestItem.Data := Pointer(2);
  end;


  if CurrIndentLevel > 0 then dec(CurrIndentLevel);

end;

procedure TfrmDayBook.XmlScannerStartTag(Sender: TObject; TagName: String;
  Attributes: TAttrList);
var
  s : string;
  i : integer;
begin
  s := TagName;
  FOR i := 0 TO Attributes.Count-1 DO
    s := s + ' ' + Attributes.Name (i)+'="'+Attributes.Value(i) + '"';
  LatestItem := lvXML.Items.Add;
  with LatestItem do
  begin
   Caption := '<' + s + '>';
   Indent := CurrIndentLevel;
   inc(CurrIndentLevel);
  end;
end;

procedure TfrmDayBook.btnPrintClick(Sender: TObject);
begin
//  if pgcTransactions.ActivePage = tabHtml then
  with PrintDialog1 do
  begin
    if Execute then
    begin
      if pgcTransactions.ActivePage <> tabHTML then
         LoadHTML(BOff);
{      if PrintRange = prAllPages then}
        HtmlViewer.Print(1, 9999);
{      else
        HtmlViewer.Print(FromPage, ToPage);}
    end;
  end;
end;

procedure TfrmDayBook.LoadXml;
begin
  if pgcTransactions.ActivePage = tabXml then
  begin
     Try
       CurrIndentLevel := 0;
       lvXML.Items.Clear;
       XMLScanner.Filename := ArchivedXMLFileName;
       XMLScanner.Execute;
     Except
     End;
  end;
end;

end.




