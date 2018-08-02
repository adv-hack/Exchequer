{-----------------------------------------------------------------------------
 Unit Name: uDashboardBaseFrame
 Author:    vmoura
 Purpose:
 History:

 panel - color = $00FDEADA
         colorto = $00E4AE88
-----------------------------------------------------------------------------}
Unit uDashboardBaseFrame;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Variants, Dateutils, ExtCtrls, AdvAlertWindow, AdvPanel,
  AdvOutlookList, OutlookGroupedList, 
  ImgList, 

  uInOutInterfaces
  ;

Const
  // inbox and outbox name fields. Load dynamically
  InboxFieldsDesc: Array[0..4] Of String = ('From', 'Subject', 'Received',
    'Total Items', 'Status');
  OutboxFieldsDesc: Array[0..4] Of String = ('To', 'Subject', 'Sent',
    'Total Items', 'Status');
  FieldsSize: Array[0..4] Of Integer = (220, 220, 150, 60, 40);

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
  TBoxType = (btNone, btInbox, btOutbox);

  TfrmMailBoxBaseFrame = Class(TFrame)
    advPanelMail: TAdvPanel;
    advAlert: TAdvAlertWindow;
    AdvOutlook: TAdvOutlookList;
    imgStatus: TImageList;
    imgAlert: TImageList;
    advPanelCaption: TAdvPanel;
    procedure actDailyScheduleExecute(Sender: TObject);
  Private
    fBoxType: TBoxType;
    Procedure SetBoxType(Const Value: TBoxType);
    Function GetItemsCount: Integer;
    Function GetPanelCaption: String;
    Procedure SetPanelCaption(Const Value: String);
  Protected
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;

    Procedure LoadMessages(pMsgs: Olevariant; Const pShowAlert: Boolean =
      False);
      Virtual;
    Function GetGroup(pDate: TDate): TOutlookGroup;
    Function GroupExists(Const pName: String): TOutlookGroup;
    Procedure ClearItems;
    Procedure ShowAlert(Const pText: String);
    procedure ShowSchedule(const pCaption: String; var pFrame: TFrame);
  Published
    Property BoxType: TBoxType Read fBoxType Write SetBoxType Default btNone;
    Property Count: Integer Read GetItemsCount;
    Property PanelCaption: String Read GetPanelCaption Write SetPanelCaption;
  End;

Implementation

uses uSchedule, uDailyFrame;

{$R *.dfm}

{ TfrmDashboardBase }

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
        _FreeAndNil(lItem);
      End; // object <> nil

      Try
        AdvOutlook.Groups[i].RemoveChild(J);
      Except
      End;
    End; // for childcount

    If AdvOutlook.Groups[i].ChildCount > 0 Then
    Try
      AdvOutlook.Groups[i].ClearChilds;
    Except
    End;
  End; // for group count

  If AdvOutlook.GroupCount > 0 Then
  Try
    AdvOutlook.ClearGroups;
  Except
  End;
End;

Constructor TfrmMailBoxBaseFrame.Create(AOwner: TComponent);
Begin
  Inherited Create(Aowner);
End;

Destructor TfrmMailBoxBaseFrame.Destroy;
Begin
  ClearItems;
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: GetGroup
  Author:    vmoura
  Arguments: pDate: TDate
  Result:    TOutlookGroup
-----------------------------------------------------------------------------}
Function TfrmMailBoxBaseFrame.GetGroup(pDate: TDate): TOutlookGroup;
Var
  lGroup: TOutlookGroup;
Begin
  Case DayOf(Date) - DayOf(pDate) Of
    0: lGroup := GroupExists(cGrToday);
    1: lGroup := GroupExists(cGrYesterday);
    2: lGroup := GroupExists(cGrTwoDays);
    3: lGroup := GroupExists(cGrThreeDays);
    4: lGroup := GroupExists(cGrFourDays);
    5: lGroup := GroupExists(cGrFiveDays);
    6: lGroup := GroupExists(cGrSixDays);
    7..13: lGroup := GroupExists(cGrLastWeek);
  Else
    Begin // older or something else
      lGroup := GroupExists(cGrOlder);
    End;
  End;

  Result := lGroup;
End;

Function TfrmMailBoxBaseFrame.GetItemsCount: Integer;
Var
  lCont: Integer;
Begin
  Result := 0;
  For lCont := 0 To AdvOutlook.GroupCount - 1 Do
    Result := Result + AdvOutlook.Groups[lCont].ChildCount;
End;

Function TfrmMailBoxBaseFrame.GetPanelCaption: String;
Begin
  Result := advPanelCaption.Text;
End;

{-----------------------------------------------------------------------------
  Procedure: GroupExists
  Author:    vmoura
  Arguments: Const pName: String
  Result:    TOutlookGroup
-----------------------------------------------------------------------------}
Function TfrmMailBoxBaseFrame.GroupExists(Const pName: String): TOutlookGroup;
Var
  lCont: Integer;
Begin
  Result := Nil;
  For lCont := 0 To AdvOutlook.GroupCount - 1 Do
  Begin
    // search for an already created group
    If Lowercase(AdvOutlook.Groups[lCont].Caption) = Lowercase(pName) Then
    Begin
      Result := AdvOutlook.Groups[lCont];
      Break;
    End; // if groupname = pname
  End; // for

  If Result = Nil Then
    Result := AdvOutlook.AddGroup(pName);
End;

{-----------------------------------------------------------------------------
  Procedure: SetBoxType
  Author:    vmoura
  Arguments: const Value: TBoxType
  Result:    None

  Load the Listfields according to the box type.
-----------------------------------------------------------------------------}

Procedure TfrmMailBoxBaseFrame.LoadMessages(pMsgs: Olevariant;
  Const pShowAlert: Boolean);
Begin
  ClearItems;
End;

Procedure TfrmMailBoxBaseFrame.SetBoxType(Const Value: TBoxType);
Var
  lCont: Integer;
Begin
  fBoxType := Value;
  ClearItems;
  // load the field names and columns size dyanamically
  With AdvOutlook Do
  Begin
    LockWindowUpdate(AdvOutlook.Handle);
//    BeginUpdate;
    Columns.Clear;
    Columns.Add;

    // create the fields to the list
    Case fBoxType Of
      btInbox:
        For lCont := 0 To High(InboxFieldsDesc) Do
          With Columns.Add Do
          Begin
            Caption := InboxFieldsDesc[lCont];
            Width := FieldsSize[lCont];
            Alignment := taLeftJustify;
            HeaderAlignment := taLeftJustify;
            If Lowercase(Caption) = 'status' Then
            Begin
              ColumnType := ctImage;
              HeaderImageIndex := 1;
            End;
          End;
      btOutbox:
        For lCont := 0 To High(OutboxFieldsDesc) Do
          With Columns.Add Do
          Begin
            Caption := OutboxFieldsDesc[lCont];
            Width := FieldsSize[lCont];
            Alignment := taLeftJustify;
            HeaderAlignment := taLeftJustify;
            If Lowercase(Caption) = 'status' Then
            Begin
              ColumnType := ctImage;
              HeaderImageIndex := 1;
            End;
          End;
    End;

//    EndUpdate;
    LockWindowUpdate(0);
  End; // with outlook
End;

Procedure TfrmMailBoxBaseFrame.SetPanelCaption(Const Value: String);
Begin
  advPanelCaption.Text := Value;
End;

Procedure TfrmMailBoxBaseFrame.ShowAlert(Const pText: String);
Begin
  With AdvAlert Do
  Try
        // alert the user about a new message (s)
    With AlertMessages.Add Do
      Text.Text := pText;

    Show;
  Except
  End; // with advalert
End;

procedure TfrmMailBoxBaseFrame.ShowSchedule(const pCaption: String;
  var pFrame: TFrame);
begin
  //Application.CreateForm(TfrmSchedule, frmSchedule);
  with TfrmSchedule.Create(Nil) do begin
    Caption := pCaption;
    pFrame.Parent := advPanelSchedule;
    ShowModal;
    _FreeAndNil(pFrame);
    Free;
  end;
end;

procedure TfrmMailBoxBaseFrame.actDailyScheduleExecute(Sender: TObject);
var
  lFrame: TfrmDailyFrame;
begin
  lFrame:= TfrmDailyFrame.Create(Nil);
  ShowSchedule('Daily Schedule', TFrame(lFrame));
end;

End.

