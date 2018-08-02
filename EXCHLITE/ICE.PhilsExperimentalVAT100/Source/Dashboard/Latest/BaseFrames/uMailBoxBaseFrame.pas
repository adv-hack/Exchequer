{-----------------------------------------------------------------------------
 Unit Name: umailBoxBaseFrame
 Author:    vmoura
 Purpose:
 History:

 panel - color = $00FDEADA
         colorto = $00E4AE88
-----------------------------------------------------------------------------}
Unit uMailBoxBaseFrame;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Variants, Dateutils, ExtCtrls, AdvPanel, Activex, Math,
  AdvOutlookList, OutlookGroupedList, uConsts,
  ImgList,

  uInterfaces, StdCtrls, AdvProgressBar
  ;

Const
  cHTMLTEXT =
    '<P align="left"><FONT color="#00723708" face="Tahoma" ><b>%s</></FONT></P>';

  cHTMLTEXTIMAGE = '<P align="right"><IMG src="%s"></P>';

  { inbox and outbox name fields. Loaded dynamically }
  InboxFieldsDesc: Array[0..4] Of String = ('From', 'Subject', 'Received',
    'Total Items', 'Status');

  OutboxFieldsDesc: Array[0..4] Of String = ('To', 'Subject', 'Sent',
    'Total Items', 'Status');

  RecycleFieldDesc: Array[0..4] Of String = ('To', 'Company', 'Subject', 'Sent',
    'Total Items');

  FieldsSize: Array[0..4] Of Integer = (115, 141, 90, 55, 60);
  FieldsSizePer: Array[0..4] Of Integer = (22, 30, 19, 14, 12);

  RecycleFieldsSize: Array[0..4] Of Integer = (106, 93, 156, 75, 37);
  RecycleFieldsPer: Array[0..4] Of Integer = (22, 19, 33, 16, 10);

  // group consts
  cGrToday = 'Date: Today';
  cGrYesterday = 'Date: Yesterday';
  cGrTwoDays = 'Date: Two Days Ago';
  cGrThreeDays = 'Date: Three Days Ago';
  cGrFourDays = 'Date: Four Days Ago';
  cGrFiveDays = 'Date: Five Days Ago';
  cGrSixDays = 'Date: Six Days Ago';
  cGrLastWeek = 'Date: Last Week';
  cGrOlder = 'Date: Older';

  cBOLD = '<b>%s</b>';

Type

  {update the inbox node with new messages}
  TOnUpdateInboxNode = Procedure(pCompany: Integer; Const pText: String) Of Object;
  {process information after load messages}
  TOnAfterLoadMessages = Procedure(Sender: TObject; pResult: Longword) Of Object;
  {resume a thread to update the companies treeview}
  TOnUpdateCompany = Procedure Of Object;
  {do something after call the dsr functions}
  TOnAfterCallDSR = Procedure(pResult: Longword) Of Object;

  {delete/change status of a message}
  TOnDeleteMessage = Function(pGuid: TGuid): Longword Of Object;

  {do something before delete}
  TOnBeforeDelete = Procedure(pGuid: TGuid) Of Object;

  {usefull for refreshing data info}
  TOnAfterDelete = Procedure(Sender: TObject) Of Object;

  {check if it is possible to delete this message}
  TOnCanDelete = Procedure(pGuid: TGuid; pStatus: Longword; pMode: Smallint; Var
    pCanDelete: Boolean) Of Object;

  {update the status bar}
  TOnAfterUpdateMessage = Procedure(Sender: TObject; pMsg: TMessageInfo) Of Object;

  {update the main form when a new message arrives}
  TOnNewMessageArrived = Procedure(Sender: TObject; Const pText: String) Of Object;

  {update the main form when the user select a frame}
  TOnFrameSelected = Procedure(Sender: TObject) Of Object;

  TOnAfterMessageSelected = Procedure(Sender: TObject; pMsg: TMessageInfo) Of
    Object;

  TBoxType = (btNone, btInbox, btOutbox, btRecycle);

  TfrmMailBoxBaseFrame = Class(TFrame)
    advPanelMail: TAdvPanel;
    AdvOutlook: TAdvOutlookList;
    imgStatus: TImageList;
    advPanelCaption: TAdvPanel;
    tmBox: TTimer;
    advPanelDetails: TAdvPanel;
    mmSubject: TMemo;
    lblFrom: TLabel;
    lblTo: TLabel;
    lblTo_: TLabel;
    lblDt: TLabel;
    lblAttachments: TLabel;
    lblAttach: TLabel;
    lblDateTime: TLabel;
    lbSt: TLabel;
    lblStatus: TLabel;
    AdvProgress: TAdvProgressBar;
    Procedure FrameEnter(Sender: TObject);
    Procedure FrameExit(Sender: TObject);
    Procedure AdvOutlookDrawItemProp(Sender: TObject; Item: POGLItem;
      Column: Integer; AValue: String; ABrush: TBrush; AFont: TFont);
    Procedure FrameResize(Sender: TObject);
    Procedure AdvOutlookSelectionChange(Sender: TObject);
    Procedure AdvOutlookItemClick(Sender: TObject; Item: POGLItem;
      Column: Integer);
  Private
    fBoxType: TBoxType;
    fHasFocus: Boolean;
    fLastUpdate: Double;
    fMenuActive: Boolean;
    fCompany: Integer;
    fOnUpdateInboxNode: TOnUpdateInboxNode;
    fArchive: Boolean;
    fOnAfterLoadMessages: TOnAfterLoadMessages;
    fOnUpdateCompany: TOnUpdateCompany;
    fOnAfterCallDSR: TOnAfterCallDSR;
    fOnDeleteMessage: TOnDeleteMessage;
    fOnBeforeDelete: TOnBeforeDelete;
    fOnCanDelete: TOnCanDelete;
    fMailBoxName: String;
    fOnAfterUpdateMessage: TOnAfterUpdateMessage;
//    fCompanyActive: Boolean;
    fPaneVisible: Boolean;
    fOnNewMessageArrived: TOnNewMessageArrived;
    fClearItemsAllowed: Boolean;
    fOnFrameSelected: TOnFrameSelected;
    fOnAfterMessageSelected: TOnAfterMessageSelected;
    fOnAfterDelete: TOnAfterDelete;

    Procedure SetBoxType(Const Value: TBoxType);
    Function GetItemsCount: Longword;
    Function GetPanelCaption: String;
    Procedure SetPanelCaption(Const Value: String);
    Function GetBold(pCond: Boolean): String;
    Function GetSelectedMsgInfo: TMessageInfo;
    Function GetTimerActive: Boolean;
    Procedure SetTimerActive(Const Value: Boolean);
    Procedure SetHasFocus(Const Value: Boolean);
    Function GetSelectedItemsCount: Longword;
  Protected
    Procedure SetPaneVisible(Const Value: Boolean); Virtual;
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;

    Procedure ResizeHeaders;
    Function GetFocused: TStrings; Virtual;
    Function GetMailInfo: TMessageInfo; Virtual;
    Function MailExists(Const pGuid: String): TStrings;
    Procedure DeleteItem(pInfo: TMessageInfo);

    Procedure LoadMessages(pMsgs: Olevariant; Const pShowAlert: Boolean =
      False; Const pForceUpdate: Boolean = False); Virtual;
    Function GetGroup(pDate: TDate): TOutlookGroup;
    Function GroupExists(Const pName: String): TOutlookGroup;
    Procedure ClearItems;
    Procedure AddMessageDetail(Var pMail: TStrings; Var pInfo: TMessageInfo;
      Const pCaption: String; Const pUseBold: Boolean = False); Virtual;
    Procedure DeleteSelectedMessages; Virtual;
    Procedure SetFirstValidItem;
    Procedure SetPaneNoInfo;
    Procedure ClearPaneInfo;
    Procedure GetMail; Virtual;
    Function CheckMessageBox: Boolean;
  Published
    Property OnUpdateInboxNode: TOnUpdateInboxNode Read fOnUpdateInboxNode Write
      fOnUpdateInboxNode;
    Property OnAfterLoadMessages: TOnAfterLoadMessages Read fOnAfterLoadMessages
      Write fOnAfterLoadMessages;
    Property OnUpdateCompany: TOnUpdateCompany Read fOnUpdateCompany Write
      fOnUpdateCompany;
    Property OnAfterCallDSR: TOnAfterCallDSR Read fOnAfterCallDSR Write
      fOnAfterCallDSR;
    Property OnDeleteMessage: TOnDeleteMessage Read fOnDeleteMessage Write
      fOnDeleteMessage;
    Property OnBeforeDelete: TOnBeforeDelete Read fOnBeforeDelete Write
      fOnBeforeDelete;
    Property OnAfterDelete: TOnAfterDelete Read fOnAfterDelete Write fOnAfterDelete;
    Property OnCanDelete: TOnCanDelete Read fOnCanDelete Write fOnCanDelete;
    Property OnAfterUpdateMessage: TOnAfterUpdateMessage Read
      fOnAfterUpdateMessage Write fOnAfterUpdateMessage;
    Property OnNewMessageArrived: TOnNewMessageArrived Read fOnNewMessageArrived
      Write fOnNewMessageArrived;
    Property OnFrameSelected: TOnFrameSelected Read fOnFrameSelected Write
      fOnFrameSelected;
    Property OnAfterMessageSelected: TOnAfterMessageSelected Read
      fOnAfterMessageSelected Write fOnAfterMessageSelected;

    /////////////////////////////////////////////////////////////////////////
    Property BoxType: TBoxType Read fBoxType Write SetBoxType Default btNone;
    Property Count: Longword Read GetItemsCount;
    Property SelectedCount: Longword Read GetSelectedItemsCount;
    Property PanelCaption: String Read GetPanelCaption Write SetPanelCaption;
    Property HasFocus: Boolean Read fHasFocus Write SetHasFocus;
    Property SelectedMsgInfo: TMessageInfo Read GetSelectedMsgInfo;
    Property LastUpdate: Double Read fLastUpdate Write fLastUpdate;
    Property MenuActive: Boolean Read fMenuActive Write fMenuActive Default
      False;
    Property Company: Integer Read fCompany Write fCompany;
    Property Archive: Boolean Read fArchive Write fArchive;
    Property TimerActive: Boolean Read GetTimerActive Write SetTimerActive
      Default False;
    Property MailBoxName: String Read fMailBoxName Write fMailBoxName;
    Property PaneVisible: Boolean Read fPaneVisible Write SetPaneVisible;
    Property ClearItemsAllowed: Boolean Read fClearItemsAllowed Write
      fClearItemsAllowed Default True;
  End;

Implementation

Uses uCommon, uDailyFrame, uDashSettings, uDashGlobal;

{$R *.dfm}

{ TfrmDashboardBase }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TfrmMailBoxBaseFrame.Create(AOwner: TComponent);
Begin
  Inherited Create(Aowner);
  fLastUpdate := Now;
  fOnUpdateInboxNode := Nil;
  fOnAfterLoadMessages := Nil;
  fOnUpdateCompany := Nil;
  fOnAfterCallDSR := Nil;
  fOnDeleteMessage := Nil;
  fOnBeforeDelete := Nil;
  fOnCanDelete := Nil;
  fOnAfterUpdateMessage := Nil;
  fOnNewMessageArrived := Nil;
  fOnFrameSelected := Nil;
  fOnAfterMessageSelected := Nil;
  fOnAfterDelete := Nil;
  fClearItemsAllowed := True;

  {resize form}
//  Self.Perform(WM_SIZE, 0, 0);
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TfrmMailBoxBaseFrame.Destroy;
Begin
  If tmBox.Enabled Then
    tmBox.Enabled := False;

  ClearItems;

  If Assigned(fOnUpdateInboxNode) Then
    fOnUpdateInboxNode := Nil;

  If Assigned(fOnAfterLoadMessages) Then
    fOnAfterLoadMessages := Nil;

  If Assigned(fOnUpdateCompany) Then
    fOnUpdateCompany := Nil;

  If Assigned(fOnAfterCallDSR) Then
    fOnAfterCallDSR := Nil;

  If Assigned(fOnDeleteMessage) Then
    fOnDeleteMessage := Nil;

  If Assigned(fOnBeforeDelete) Then
    fOnBeforeDelete := Nil;

  If Assigned(fOnCanDelete) Then
    fOnCanDelete := Nil;

  If Assigned(fOnAfterUpdateMessage) Then
    fOnAfterUpdateMessage := Nil;

  If Assigned(fOnNewMessageArrived) Then
    fOnNewMessageArrived := Nil;

  If Assigned(fOnFrameSelected) Then
    fOnFrameSelected := Nil;

  If Assigned(fOnAfterMessageSelected) Then
    fOnAfterMessageSelected := Nil;

  If Assigned(fOnAfterDelete) Then
    fOnAfterDelete := Nil;

  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: ClearItems
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.ClearItems;
Var
  i, j: Integer;
  lItem: TMessageInfo;
Begin
  For i := AdvOutlook.GroupCount - 1 Downto 0 Do
  Begin
    For j := AdvOutlook.Groups[i].ChildCount - 1 Downto 0 Do
    Begin
      If AdvOutlook.Groups[i].ChildItem[j].Objects[0] <> Nil Then
      Begin
        lItem := TMessageInfo(AdvOutlook.Groups[i].ChildItem[j].Objects[0]);

        If Assigned(lItem) Then
          FreeAndNil(lItem);
      End; { object <> nil}

      Try
        AdvOutlook.Groups[i].RemoveChild(J);
      Except
      End;
    End; { for childcount}

    If AdvOutlook.Groups[i].ChildCount > 0 Then
    Try
      AdvOutlook.Groups[i].ClearChilds;
    Except
    End; {If AdvOutlook.Groups[i].ChildCount > 0 Then}
  End; { for group count}

  If AdvOutlook.GroupCount > 0 Then
  Try
    AdvOutlook.ClearGroups;
  Except
  End; {If AdvOutlook.GroupCount > 0 Then}

  If PaneVisible Then
    SetPaneNoInfo;
End;

{-----------------------------------------------------------------------------
  Procedure: GetGroup
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmMailBoxBaseFrame.GetGroup(pDate: TDate): TOutlookGroup;
Var
  lGroup: TOutlookGroup;
Begin
  //Case DayOf(Date) - DayOf(pDate) Of
  Case DaysBetween(Date, Trunc(pDate)) Of
    0: lGroup := GroupExists(cGrToday);
    1: lGroup := GroupExists(cGrYesterday);
    2: lGroup := GroupExists(cGrTwoDays);
    3: lGroup := GroupExists(cGrThreeDays);
    4: lGroup := GroupExists(cGrFourDays);
    5: lGroup := GroupExists(cGrFiveDays);
    6: lGroup := GroupExists(cGrSixDays);
    7..13: lGroup := GroupExists(cGrLastWeek);
  Else
    lGroup := GroupExists(cGrOlder);
  End;

  Result := lGroup;
End;

{-----------------------------------------------------------------------------
  Procedure: GetItemsCount
  Author:    vmoura

  get the total itens by group
-----------------------------------------------------------------------------}
Function TfrmMailBoxBaseFrame.GetItemsCount: Longword;
Var
  lCont: Integer;
Begin
  Result := 0;
  For lCont := 0 To AdvOutlook.GroupCount - 1 Do
    Result := Result + AdvOutlook.Groups[lCont].ChildCount;
End;

{-----------------------------------------------------------------------------
  Procedure: GetSelectedItemsCount
  Author:    vmoura
  count the amount of selected items that are not groups
-----------------------------------------------------------------------------}
Function TfrmMailBoxBaseFrame.GetSelectedItemsCount: Longword;
Var
  i, j: Integer;
Begin
  Result := 0;
  For i := 0 To AdvOutlook.GroupCount - 1 Do
    For j := 0 To AdvOutlook.Groups[i].ChildCount - 1 Do
      If AdvOutlook.IsItemSelected(AdvOutlook.Groups[i].ChildOGLItem[j]) Then
        Inc(Result);
End;

{-----------------------------------------------------------------------------
  Procedure: GetFocused
  Author:    vmoura

  get the selected item on screen
-----------------------------------------------------------------------------}
Function TfrmMailBoxBaseFrame.GetFocused: TStrings;
Var
  lStr: TStrings;
Begin
  Result := Nil;
  If AdvOutlook.FocusedItem <> Nil Then
    If Not AdvOutlook.IsGroupItem(AdvOutlook.FocusedItem) Then
    Begin
      lStr := AdvOutlook.GetItemData(AdvOutlook.FocusedItem);
      Result := lStr;
    End {if not AdvOutlook.IsGroupItem(AdvOutlook.FocusedItem) then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetMailInfo
  Author:    vmoura

  retrive the mail info object held by the focused item
-----------------------------------------------------------------------------}
Function TfrmMailBoxBaseFrame.GetMailInfo: TMessageInfo;
Var
  lStr: TStrings;
Begin
  Result := Nil;
  lStr := GetFocused;
  If lStr <> Nil Then
    REsult := _GetMailInfoFromStrings(lStr);
End;

{-----------------------------------------------------------------------------
  Procedure: MailExists
  Author:    vmoura

  look up for a guid into the strings
-----------------------------------------------------------------------------}
Function TfrmMailBoxBaseFrame.MailExists(Const pGuid: String): TStrings;
Var
  lStr: TStrings;
  lCont1, lCont2: Integer;
  lGuid: TGuid;
Begin
  Result := Nil;

  Try
    lGuid := StringToGUID(pGuid)
  Except
    lGuid := GUID_NULL;
  End;

  If _isValidGuid(lGuid) And Not IsEqualGUID(lGuid, GUID_NULL) Then
  {check groups and theirs childs}
    For lCont1 := 0 To AdvOutlook.GroupCount - 1 Do
    Begin
      If AdvOutlook.Groups[lCont1].ChildCount > 0 Then
        For lCont2 := 0 To AdvOutlook.Groups[lCont1].ChildCount - 1 Do
        Begin
          lStr := AdvOutlook.Groups[lCont1].ChildItem[lCont2];
          If lStr <> Nil Then
            If lStr.Count > 0 Then
              If (lStr.Objects[0] <> Nil) And (lStr.Objects[0] Is TMessageInfo)
                Then
                If IsEqualGUID(TMessageInfo(lStr.Objects[0]).Guid, lGuid) Then
                Begin
                  Result := lStr;
                  Break;
                End; {If IsEqualGUID(TMessageInfo(lStr.Objects[0]).Guid, pGuid) Then}
        End; {For lCont2 := 0 To AdvOutlook.Groups[lCont1].ChildCount - 1 Do}

      If Result <> Nil Then
        Break;
    End; {For lCont1 := 0 To AdvOutlook.GroupCount - 1 Do}
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteItem
  Author:    vmoura

  delete an item from the list
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.DeleteItem(pInfo: TMessageInfo);
Var
  lStr: TStrings;
  lCont1, lCont2: Integer;
  lInfo: TMessageInfo;
  lBreak: Boolean;
Begin
  If pInfo <> Nil Then
  {check groups and theirs childs}
    For lCont1 := 0 To AdvOutlook.GroupCount - 1 Do
    Begin
      lBreak := False;
      If AdvOutlook.Groups[lCont1].ChildCount > 0 Then
        For lCont2 := AdvOutlook.Groups[lCont1].ChildCount - 1 Downto 0 Do
        Begin
          lStr := AdvOutlook.Groups[lCont1].ChildItem[lCont2];
          If lStr <> Nil Then
            If lStr.Count > 0 Then
              If (lStr.Objects[0] <> Nil) And (lStr.Objects[0] Is TMessageInfo) Then
                If IsEqualGUID(TMessageInfo(lStr.Objects[0]).Guid, pInfo.Guid) Then
                Try
                  lBreak := True;
                  lInfo := TMessageInfo(lStr.Objects[0]);

                  If Assigned(lInfo) Then
                    FreeAndNil(lInfo);

                  AdvOutlook.Groups[lCont1].RemoveChild(lCont2);

                  Try
                    If AdvOutlook.Groups[lCont1].ChildCount = 0 Then
                      AdvOutlook.DeleteGroup(lCont1);
                  Except
                  End;

                  Break; {stop the second loop}
                Except
                End; {If IsEqualGUID(TMessageInfo(lStr.Objects[0]).Guid, pGuid) Then}
        End; {For lCont2 := 0 To AdvOutlook.Groups[lCont1].ChildCount - 1 Do}

      If lBreak Then {stop the first loop}
        Break;
    End; {For lCont1 := 0 To AdvOutlook.GroupCount - 1 Do}
End;

{-----------------------------------------------------------------------------
  Procedure: GetPanelCaption
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmMailBoxBaseFrame.GetPanelCaption: String;
Begin
  Result := advPanelCaption.Text;
End;

{-----------------------------------------------------------------------------
  Procedure: GroupExists
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmMailBoxBaseFrame.GroupExists(Const pName: String): TOutlookGroup;
Var
  lCont: Integer;
Begin
  Result := Nil;
  For lCont := 0 To AdvOutlook.GroupCount - 1 Do
  Begin
    { search for an already created group}
    If Lowercase(AdvOutlook.Groups[lCont].Caption) = Lowercase(pName) Then
    Begin
      Result := AdvOutlook.Groups[lCont];
      Break;
    End; { if groupname = pname}
  End; { for}

  If Result = Nil Then
    Result := AdvOutlook.AddGroup(pName);
End;

{-----------------------------------------------------------------------------
  Procedure: LoadMessages
  Author:    vmoura

  Load the Listfields according to the box type.
-----------------------------------------------------------------------------}

Procedure TfrmMailBoxBaseFrame.LoadMessages(pMsgs: Olevariant; Const pShowAlert:
  Boolean = False; Const pForceUpdate: Boolean = False);
Begin
  ClearItems;
End;

{-----------------------------------------------------------------------------
  Procedure: GetMail
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.GetMail;
Begin

End;

{-----------------------------------------------------------------------------
  Procedure: SetBoxType
  Author:    vmoura

  modify the advoutlook according to type of mail box
  both have the same sizes, but not the same names
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.SetBoxType(Const Value: TBoxType);
Var
  lCont: Integer;
  lColumn: TAdvOutlookColumn;
Begin
  fBoxType := Value;
  ClearItems;
  { load the field names and columns size dynamically}
  With AdvOutlook Do
  Begin
    Columns.Clear;
    Columns.Add;

    { create headers of the list}
    Case fBoxType Of
      btInbox:
        For lCont := 0 To High(InboxFieldsDesc) Do
        Begin
          lColumn := Columns.Add;
          With lColumn Do
          Begin
            Caption := InboxFieldsDesc[lCont];
            Width := FieldsSize[lCont];
            Alignment := taLeftJustify;
            HeaderAlignment := taLeftJustify;
            Font.Name := 'Arial';
            HeaderFont.Name := 'Arial';
            Font.Size := 8;
            HeaderFont.Size := 8;
          End; {With Columns.Add Do}

        End; {btinbox}
      btOutbox:
        Begin
          For lCont := 0 To High(OutboxFieldsDesc) Do
          Begin
            lColumn := Columns.Add;
            With lColumn Do
            Begin
              Caption := OutboxFieldsDesc[lCont];
              Width := FieldsSize[lCont];
              Alignment := taLeftJustify;
              HeaderAlignment := taLeftJustify;
              Font.Name := 'Arial';
              HeaderFont.Name := 'Arial';
              Font.Size := 8;
              HeaderFont.Size := 8;
            End; {With Columns.Add Do}
          End;
        {extra scheduled column}
          With Columns.Add Do
          Begin
            Width := 10;
            ColumnType := ctImage;
            HeaderImageIndex := 0;
            Font.Name := 'Arial';
            HeaderFont.Name := 'Arial';
            Font.Size := 8;
            HeaderFont.Size := 8;
          End; {With Columns.Add Do}
        End; {btoutbox}
      btRecycle:
        Begin
          For lCont := 0 To High(RecycleFieldDesc) Do
          Begin
            lColumn := Columns.Add;
            With lColumn Do
            Begin
              Caption := RecycleFieldDesc[lCont];
              Width := RecycleFieldsSize[lCont];
              Alignment := taLeftJustify;
              HeaderAlignment := taLeftJustify;
              Font.Name := 'Arial';
              HeaderFont.Name := 'Arial';
              Font.Size := 8;
              HeaderFont.Size := 8;
            End; {With Columns.Add Do}
          End; {For lCont := 0 To High(RecycleFieldDesc) Do}
        End; {btrecycle}
    End; {Case fBoxType Of}
  End; {With AdvOutlook Do}

  ResizeHeaders;
End;

{-----------------------------------------------------------------------------
  Procedure: SetPanelCaption
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.SetPanelCaption(Const Value: String);
Begin
  advPanelCaption.Text := Value;
End;

{-----------------------------------------------------------------------------
  Procedure: FrameEnter
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.FrameEnter(Sender: TObject);
Begin
  fHasFocus := True;

  If Assigned(fOnFrameSelected) Then
    fOnFrameSelected(Self);
End;

{-----------------------------------------------------------------------------
  Procedure: FrameExit
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.FrameExit(Sender: TObject);
Begin
  fHasFocus := False;
End;

{-----------------------------------------------------------------------------
  Procedure: AddMessageDetail
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.AddMessageDetail(Var pMail: TStrings; Var pInfo:
  TMessageInfo; Const pCaption: String; Const pUseBold: Boolean);
Var
//  lBold: String;
  lInfo: TMessageInfo;
Begin
  If Assigned(pMail) And Assigned(pInfo) Then
    With pMail Do
    Begin
      {if this message already exists, the messageinfo object must be deleted}
      If Count > 0 Then
        If (Objects[0] <> Nil) And (Objects[0] Is TMessageInfo) Then
        Begin
          lInfo := TMessageInfo(Objects[0]);
          If Assigned(lInfo) Then
            FreeAndNil(lInfo);
        End; {If (Objects[0] <> Nil) And (Objects[0] Is TMessageInfo) Then}

      Clear;

      {add the line detail}
(*      lBold := GetBold((pInfo.Status In [cREADYIMPORT]) And pUseBold);
      AddObject(Format(lBold, [pCaption]), pInfo);

      Add(Format(lBold, [pInfo.Subject]));
      Add(Format(lBold, [datetimetostr(pInfo.Date)]));
      Add(Format(lBold, [Inttostr(pInfo.TotalItens)]));

      Add(Format(lBold, [_GetStatusMessate(pInfo.Status)]));*)

      AddObject(pCaption, pInfo);
      Add(pInfo.Subject);
      Add(datetimetostr(pInfo.Date));
      Add(Inttostr(pInfo.TotalItens));
      Add(_GetStatusMessage(pInfo.Status));

      If pInfo.ScheduleId > 0 Then
        Add('1');

      If pInfo <> Nil Then
        If Assigned(fOnAfterUpdateMessage) Then
          fOnAfterUpdateMessage(Self, pInfo);
    End; {With pMail Do}
End;

{-----------------------------------------------------------------------------
  Procedure: GetBold
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmMailBoxBaseFrame.GetBold(pCond: Boolean): String;
Begin
  If pCond Then
    Result := cBold
  Else
    Result := '%s';
End;

{-----------------------------------------------------------------------------
  Procedure: AdvOutlookDrawItemProp
  Author:    vmoura

  change color when this mail is in drip feed mode.
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.AdvOutlookDrawItemProp(Sender: TObject;
  Item: POGLItem; Column: Integer; AValue: String; ABrush: TBrush;
  AFont: TFont);

  Procedure _ChangeFont;
  Begin
    AFont.Name := 'Arial';
    Afont.Style := [fsBold];

//    if nsSelected in Item.States then
//      Afont.Color := clWhite
//    else
//      Afont.Color := clBlack;
  End;

  Procedure _UnChangeFont;
  Begin
    AFont.Name := 'Arial';
    Afont.Style := [];
//    Afont.Color := clBlack;
  End;

Var
  lStr: TStrings;
  lMsg: TMessageInfo;
Begin
  lStr := AdvOutlook.GetItemData(Item);
  If lStr <> Nil Then
  Begin
    lMsg := _GetMailInfoFromStrings(lStr);
    If lMsg <> Nil Then
    Begin
      //_UnChangeFont;
      {if message has changed to drip feed then change the color}
      If (lMsg.Mode In [Ord(rmSync), Ord(rmBulk), Ord(rmDripFeed)]) Then
      Begin
        If (lMsg.Status = cREADYIMPORT) Then
          _ChangeFont;
        ABrush.Color := $00CAFFFF;
      End
      Else If (lMsg.Mode = Ord(rmNormal)) Then
      Begin
        If (lMsg.Status In [cSYNCDENIED, cSYNCFAILED, cREMOVESYNC, cACKNOWLEDGE])
          Then
          _ChangeFont;

        Case lMsg.Status Of
          cSYNCDENIED,
            cSYNCFAILED: ABrush.Color := $00BBEBFF;
          cREMOVESYNC: ABrush.Color := $006295FF;
        End; {case}
      End; {begin}
    End {if lMsg <> nil then}
  End {if lStr <> nil then}
End;

{-----------------------------------------------------------------------------
  Procedure: GetSelectedMsgInfo
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmMailBoxBaseFrame.GetSelectedMsgInfo: TMessageInfo;
Begin
  Result := GetMailInfo;
End;

{-----------------------------------------------------------------------------
  Procedure: GetTimerActive
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmMailBoxBaseFrame.GetTimerActive: Boolean;
Begin
  Result := tmBox.Enabled;
End;

{-----------------------------------------------------------------------------
  Procedure: SetTimerActive
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.SetTimerActive(Const Value: Boolean);
Begin
  tmBox.Enabled := Value;
End;

{-----------------------------------------------------------------------------
  Procedure: DeleteSelectedMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.DeleteSelectedMessages;
Var
  lStr: TStrings;
  lGuids: TStringlist;
  lCont: Integer;
  lItem, lChild: POGLItem;
  lMsg: TMessageInfo;
(*  lCallDSR, *)
  lRes: Longword;
  lCanDelete: Boolean;
  lGuid: TGUID;
Begin
  lGuids := TStringlist.Create;

  {stop the timer to avoid refreshing...}
  tmBox.Enabled := False;

  {get the first group and search for selected items}
  lItem := AdvOutlook.FirstGroupItem;

  While lItem <> Nil Do
  Begin
    {only items, not groups}
    //If lItem.ChildSelectedCount > 0 Then
    If lItem.ChildCount > 0 Then
    Begin
      lChild := lItem.FirstChild;

      While lChild <> Nil Do
      Begin
        If AdvOutlook.IsItemSelected(lChild) Then
        Try
          {select the string holding the objects}
          lStr := AdvOutlook.GetItemData(lChild);
          If lStr <> Nil Then
          Begin
            {retrieve mail information}
            Try
              lMsg := _GetMailInfoFromStrings(lStr);
            Except
              lMsg := Nil;
            End;

            If lMsg <> Nil Then
            Begin
              lCanDelete := True;
              If Assigned(fOnCanDelete) Then
                fOnCanDelete(lMsg.Guid, lMsg.Status, lMsg.Mode, lCanDelete);

              If lCanDelete Then
                lGuids.Add(GUIDToString(lMsg.Guid));
            End; {If lMsg <> Nil Then}
          End; {If lStr <> Nil Then}
        Except
        End; {try}

        lChild := lChild.NextSibling;
      End; {While lChild <> Nil Do}
    End; {If lItem.ChildSelectedCount > 0 Then}

    {get next group item}
    lItem := lItem.NextSibling;
  End; {While lItem <> Nil Do}

//  tmBox.Enabled := True;

//  lCallDSR := S_OK;
  lRes := S_OK;
  {delete selected items}
  For lCont := 0 To lGuids.Count - 1 Do
    If (lGuids[lCont] <> '') And _IsValidGuid(lGuids[lCont]) Then
    Begin
      lGuid := StringToGUID(lGuids[lCont]);

      If Assigned(fOnBeforeDelete) Then
        fOnBeforeDelete(lGuid);

      If Assigned(fOnDeleteMessage) Then
        lRes := fOnDeleteMessage(lGuid);

//      If lRes <> S_OK Then
//        lCallDSR := lRes
//      Else
      If lRes = S_OK Then
      Begin
        {check for the string qith that guid}
        lStr := MailExists(lGuids[lCont]);

        {get object from the strings}
        If lStr <> Nil Then
          lMsg := _GetMailInfoFromStrings(lStr);

        {delete mail info from screen}
        If lMsg <> Nil Then
          DeleteItem(lMsg);
      End; {else Begin}
    End; {If (lGuids[lCont] <> '') And _IsValidGuid(lGuids[lCont]) Then}

  If Assigned(lGuids) Then
    FreeAndNil(lGuids);

  If Assigned(fOnAfterDelete) Then
    fOnAfterDelete(Self);

  {enable timer for a new refresh...}
  tmBox.Enabled := True;

  {check the dsr...}
//  If lCallDSR <> S_OK Then
//    If Assigned(fOnAfterCallDSR) Then
//      fOnAfterCallDSR(lCallDSR);
End;

{-----------------------------------------------------------------------------
  Procedure: FrameResize
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.FrameResize(Sender: TObject);
Begin
  ResizeHeaders
End;

{-----------------------------------------------------------------------------
  Procedure: ResizeHeaders
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.ResizeHeaders;
Var
  lCont: Integer;
Begin

  {reset fields size. using percentage gives a better screen proportion}
  With AdvOutlook Do
  Try
    { create headers of the list}
    Case fBoxType Of
      btInbox:
        For lCont := 1 To Columns.Count - 1 Do
          With Columns[lCont] Do
            Width := Trunc((FieldsSizePer[lCont - 1] / 100) * AdvOutlook.Width);
      btOutbox:
        Begin
          {i took 1% of all fields to be able to show the image field}
          For lCont := 1 To Columns.Count - 1 Do
            With Columns[lCont] Do
              Width := Trunc(((FieldsSizePer[lCont - 1] - 1) / 100) *
                AdvOutlook.Width);

          {image field resize}
          Columns[Columns.Count - 1].Width := Trunc((5 / 100 * AdvOutlook.Width));
        End; {btoutbox}
      btRecycle:
        For lCont := 1 To Columns.Count - 1 Do
          With Columns[lCont] Do
            Width := Trunc((RecycleFieldsPer[lCont - 1] / 100) * AdvOutlook.Width);
    End; {Case fBoxType Of}
  Finally

  End; {With AdvOutlook Do}
End;

{-----------------------------------------------------------------------------
  Procedure: SetHasFocus
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.SetHasFocus(Const Value: Boolean);
Begin
  fHasFocus := Value;
End;

{-----------------------------------------------------------------------------
  Procedure: SetPaneVisible
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.SetPaneVisible(Const Value: Boolean);
Begin
  fPaneVisible := Value;
  advPanelDetails.Visible := Value;
  _DashboardSetReadPane(Value);
End;

{-----------------------------------------------------------------------------
  Procedure: AdvOutlookItemClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.AdvOutlookSelectionChange(Sender: TObject);
Var
  lMsg: TMessageInfo;
Begin
  lMsg := GetSelectedMsgInfo;

  {check object is nil}
  If lMsg <> Nil Then
  Begin
    {clear old pane info information}
    ClearPaneInfo;
    {load details of the pane info}
    lblTo.Visible := True;
    lblAttachments.Visible := True;
    lblDt.Visible := True;
    mmSubject.Lines.Text := lMsg.Subject;
    lblFrom.Caption := lMsg.From;
    lblTo_.Caption := lMsg.To_;
    lblAttach.Caption := inttostr(lMsg.TotalItens);
    lblDt.Visible := True;
    Try
      lblDateTime.Caption := datetimetostr(lMsg.Date);
    Except
      lblDateTime.Caption := '';
      lblDt.Visible := False;
      lblDateTime.Visible := False;
    End; {try}
    lbSt.Visible := True;
    lblStatus.Caption := _GetStatusMessage(lMsg.Status);

    {show progress bar}
    If (lMsg.Status In [cPOPULATING, cBULKPROCESSING, cCHECKING, cSENDING,
      cLOADINGFILES, cRECEIVINGDATA]) {and (BoxType in [btInbox, btOutbox])} Then
    Begin
      AdvProgress.Visible := True;
      AdvProgress.Position := ifthen(lMsg.TotalDone > 100, 100, lMsg.TotalDone);
    End {if lMsg.Status in [cPOPULATING, cBULKPROCESSING, cRECEIVINGDATA] then}
    Else
    Begin
      AdvProgress.Visible := False;
      AdvProgress.Position := 0;
    End; {else begin}

    If Assigned(fOnAfterMessageSelected) Then
      fOnAfterMessageSelected(Sender, lMsg);
  End; {If lMsg <> Nil Then}

  If Assigned(fOnFrameSelected) Then
    fOnFrameSelected(Self);
End;

{-----------------------------------------------------------------------------
  Procedure: ClearPaneInfo
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.ClearPaneInfo;
Begin
  mmSubject.Clear;
  lblFrom.Caption := '';
  lblTo_.Caption := '';
  lblAttach.Caption := '';
  lblDateTime.Caption := '';
  lblStatus.Caption := '';
  AdvProgress.Visible := False;
End;

{-----------------------------------------------------------------------------
  Procedure: AdvOutlookItemClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.AdvOutlookItemClick(Sender: TObject;
  Item: POGLItem; Column: Integer);
Begin
  AdvOutlookSelectionChange(Sender);
End;

{-----------------------------------------------------------------------------
  Procedure: SetFirstValidItem
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.SetFirstValidItem;
Var
  lItem, lChild: POGLItem;
Begin
  {get the first group and search for selected items}
  lItem := AdvOutlook.FirstGroupItem;

  While lItem <> Nil Do
  Begin
    {only items, not groups}
    If lItem.ChildSelectedCount = 0 Then
    Begin
      lChild := lItem.FirstChild;

      While lChild <> Nil Do
      Begin
        If Not AdvOutlook.IsGroupItem(lChild) Then
          If Not AdvOutlook.IsItemSelected(lChild) Then
          Begin
            AdvOutlook.SelectItem(lChild);
            AdvOutlook.FocusedItem := lChild;
            Break;
          End; {If Not AdvOutlook.IsItemSelected(lChild) Then}

        lChild := lChild.NextSibling;
      End; {While lChild <> Nil Do}
    End; {If lItem.ChildSelectedCount > 0 Then}

    {get next group item}
    //lItem := lItem.NextSibling;

    If AdvOutlook.FocusedItem <> Nil Then
    Begin
      AdvOutlookSelectionChange(Self);
      Break;
    End; {If AdvOutlook.FocusedItem <> Nil Then}
  End; {While lItem <> Nil Do}
End;

{-----------------------------------------------------------------------------
  Procedure: SetPaneNoInfo
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmMailBoxBaseFrame.SetPaneNoInfo;
Begin
  ClearPaneInfo;
  mmSubject.Lines.Text := 'There are no details to show in this view';
  lblTo.Visible := False;
  lblAttachments.Visible := False;
  lblDt.Visible := False;
  lbSt.Visible := False;
End;

{-----------------------------------------------------------------------------
  Procedure: CheckMessageBox
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmMailBoxBaseFrame.CheckMessageBox: Boolean;
Var
  lCont: Integer;
Begin
  {avoid refreshing the advoutlook while there is a message being diplayed}
  Result := False;
  For lCont := 0 To Screen.FormCount - 1 Do
    //If lowercase(Screen.Forms[lCont].Caption) = lowercase('confirm') Then
    If lowercase(Screen.Forms[lCont].Caption) = lowercase(cDialogTitle) Then
      If Screen.Forms[lCont].Showing Then
      Begin
        Result := True;
        Break;
      End;
End;

End.

