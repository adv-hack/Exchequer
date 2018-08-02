{*******************************************************}
{                                                       }
{       RichView                                        }
{       TRVWordEnumThread: thread for word enumeration. }
{       Used for live spelling check.                   }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVThread;

{$I RV_Defs.inc}

interface
uses Windows, Classes,
     RVScroll, CRVData, RVTypes;

{$IFNDEF RVDONOTUSELIVESPELL}

{$IFDEF RICHVIEWDEF2010}
  {$WARN SYMBOL_DEPRECATED OFF} // Temporal solution: turning off warnings for
    // deprecated Suspend/Resume
{$ENDIF}

type
  { ---------------------------------------------------------------------------
    TRVWordEnumThread: thread for enumeration of word in TCustomRichView
    (used for live spelling check).
    Fields:
    - FRichView - the component to check;
    - CurRVData, CurItem - item being checked;
    - CurItemCheckStarted - true, if current item checking is already started;
    - CurText - text of curent item;
    - CurTextStartPtr = CurText;
    - CurTextPtr - current position in CurText;
    - StopWorking is used to stop the thread at a safe place. Possible values:
      0 - working;
      1 - is set from the main process; the thread must stop at the safe place
          and set StopWorking to 2;
      2 - thread is ready to stop;
      3 - thread's Execute is finished.
    - WordOffs, WordLen - current word position, used in AddMisspelling;
    - NextRVData, NextItemNo, NextOffs - used to set the spell checking position
      when the thread will be ready to resume.
    - HasModifiedWord - there is a word (in area that's already checked) that
      was modified and should be checked later.
    - CheckUnchecked - the thread must check an item containing modified word.
      Except for this word, this item was checked, and may already contain
      marked misspellings.
    - Delaying - is set to True in ContinueCheck. Instructs the thread to sleep for
      some time.
    - EditedWhileDelayed - is set to True in ContinueCheck. If the tread is sleeping,
      it will be put asleep again when it will wake up.
  }
  TRVWordEnumThread = class (TThread)
    private
      NextItemNo, NextOffs: Integer;
      StopWorking: Integer;
      CurText: String;
      CurTextPtr, CurTextStartPtr: PChar;
      FRichView: TRVScroller;
      CurItemNo, WordOffs, WordLen: Integer;
      CurItemCheckStarted: Boolean;
      NextRVData, CurRVData: TCustomRVData;
      FForceSetBack: Boolean;
      Delaying, EditedWhileDelayed: Boolean;
      procedure AddMisspelling;
      procedure SyncProc;
      function GetNextWord: String;
      procedure GetMisspellingDrawItems(var DItemNo1, DItemNo2: Integer);
      procedure SetBack;
    protected
      procedure Execute; override;
      procedure DoTerminate; override;
    public
      HasModifiedWord, CheckUnchecked: Boolean;
      constructor Create;
      procedure Reset(RichView: TRVScroller);
      procedure LaterSetBackTo(RVData: TCustomRVData; ItemNo, Offs: Integer);
      procedure SetBackToCurItem(RVData: TCustomRVData; ItemNo: Integer);
      function IsChecked(RVData: TCustomRVData; ItemNo: Integer): Boolean;
      procedure RemoveRVData(RVData: TCustomRVData);
      destructor Destroy; override;
      procedure Stop(ResetNexts: Boolean);
      procedure ContinueCheck;
      procedure Finish;
  end;
{$ENDIF}

var RichViewApostropheInWord: Boolean = True;

implementation
{$IFNDEF RVDONOTUSELIVESPELL}
uses RichView, CRVFData, RVItem, RVFuncs, RVStr, Forms;
{================================= TRVWordEnumThread ==========================}
{ Constructor. }
constructor TRVWordEnumThread.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
  Priority := tpLowest;
  //MessageBox(0, 'Live spelling thread is created', 'LS', 0);
end;
{------------------------------------------------------------------------------}
{ Destructor. }
destructor TRVWordEnumThread.Destroy;
begin
  inherited;
end;
procedure TRVWordEnumThread.DoTerminate;
begin
  inherited;
  //MessageBox(Application.Handle, 'Live spelling thread is destroyed', 'LS', 0);
end;
{------------------------------------------------------------------------------}
{ If RichView<>nil, restarts the thread for RichView.
  If RichView=nil, prepares for detaching this thread. }
procedure TRVWordEnumThread.Reset(RichView: TRVScroller);
begin
  FRichView := RichView;
  if RichView<>nil then begin
    CurRVData := TCustomRichView(RichView).RVData;
    CurItemNo := 0;
    CurItemCheckStarted := False;
    FForceSetBack := False;
    CheckUnchecked := False;
    HasModifiedWord := False;
    NextRVData := nil;
    NextItemNo := -1;
  end;
end;
{------------------------------------------------------------------------------}
{ Waits while finishing processing the current item and suspends the thread.
  if ResetNexts, (NextRVData,NextItemNo,NextOffs) are set to "undefined".
  ResetNexts=False is used only before resuming stopped thread (for any case -
  it must already be stopped).
  Important case: if the tread is sleeping (Delaying=True), it will not be stopped.
  But, if it will wake up, it will do nothing because StopWorking=1.
  Context: main process (caller). }
procedure TRVWordEnumThread.Stop(ResetNexts: Boolean);
{$IFNDEF RICHVIEWDEF6}
var Msg: TMsg;
{$ENDIF}
begin
  if (StopWorking=3) then
    exit;
  if ResetNexts then begin
    NextRVData := nil;
    NextItemNo := -1;
    NextOffs   := -1;
  end;
  if Suspended then
    exit;
  StopWorking := 1;
  if not Delaying then begin
    Priority := tpNormal;
    while (StopWorking=1) and not Suspended do
      {$IFDEF RICHVIEWDEF6}CheckSynchronize;{$ELSE}
      if PeekMessage(Msg, 0, $8FFF, $8FFF, PM_REMOVE) then
          DispatchMessage(Msg);
      {$ENDIF};
    if not Suspended then
      Suspend;
  end;
  if ResetNexts and (CurRVData<>nil) and (CurItemNo>=0) and
     (CurItemNo<CurRVData.GetRVData.ItemCount) then
    CurRVData.GetRVData.GetItem(CurItemNo).ClearLiveSpellingResult;
  CurItemCheckStarted := False;
  Priority := tpLowest;
end;
{------------------------------------------------------------------------------}
{ Resumes the thread stopped with Stop.
  If (NextRVData,NextItemNo,NextOffs) are defined, calls SetBackTo("undefined").
  Context: main process (caller). }
procedure TRVWordEnumThread.ContinueCheck;
begin
  if NextItemNo>=0 then
    SetBack;
  Delaying := True;
  EditedWhileDelayed := True;
  StopWorking := 0;
  if Suspended then
    Resume;
end;
{------------------------------------------------------------------------------}
{ Waits while finishing processing the current item and closes the thread.
  Context: main process (caller) }
procedure TRVWordEnumThread.Finish;
{$IFNDEF RICHVIEWDEF6}
var Msg: TMsg;
{$ENDIF}
begin
  if StopWorking=3 then
    exit;
  StopWorking := 1;
  Priority := tpNormal;
  while (StopWorking=1) and not Suspended do
    {$IFDEF RICHVIEWDEF6}CheckSynchronize;{$ELSE}
    if PeekMessage(Msg, 0, $8FFF, $8FFF, PM_REMOVE) then
        TranslateMessage(Msg);
    {$ENDIF};
  if Suspended then begin
    Terminate;
    Resume;
    end
  else
    Terminate;
end;
{------------------------------------------------------------------------------}
{ Adds info about misspelling for CurRVData.GetRVData.GetItem(CurItemNo).
  WordOffs, WordLen defines the misspelled word.
  DItemNo1..DItemNo2 - range of draw items displaying this word.
  Context: main process (Synchronize). }
procedure TRVWordEnumThread.AddMisspelling;
var i: Integer;
    DItemNo1, DItemNo2: Integer;
begin
  with TCustomRVFormattedData(CurRVData.GetRVData) do begin
    GetItem(CurItemNo).AddMisspelling(WordOffs, WordLen);
    GetMisspellingDrawItems(DItemNo1, DItemNo2);
    if (DItemNo1>=0) and (DrawItems.Count>DItemNo2) then
      try
        for i := DItemNo1 to DItemNo2 do
          InvalidateDrawItem(i, 3);
      except
      end;
  end;
end;
{------------------------------------------------------------------------------}
{ This procedure is called using Synchronize before suspending the thread when
  all work is complete. It prevents suspending the thread while calling
  Stop or Finish (ony inside CheckSynchronize). }
procedure TRVWordEnumThread.SyncProc;
begin

end;
{------------------------------------------------------------------------------}
{ Assigns (NextRVData,NextItemNo,NextOffs) if they are undefined or
  if they define a position after the position specified in parameters.
  It's assumed that if (NextItemNo,NextOffs) are defined they are
  inside the same RVData, or, if RVDatas are different, the parameters define
  the position before (NextRVData,NextItemNo,NextOffs) }
procedure TRVWordEnumThread.LaterSetBackTo(RVData: TCustomRVData; ItemNo, Offs: Integer);
begin
  if (RVData<>NextRVData) or (NextItemNo<0) or
     ((ItemNo<NextItemNo) or ((NextItemNo=ItemNo) and (Offs<NextOffs))) then begin
    NextRVData := RVData;
    NextItemNo := ItemNo;
    NextOffs   := Offs;
  end;
end;
{------------------------------------------------------------------------------}
{ If HasModifiedWord, sets (NextRVData,NextItemNo,NextOffs) to the beginning
  of (RVData, ItemNo) (if this position is before the current position).
  This procedure is called at the beginning of all editing operations (except
  for typing), the caret position is passed in parameters. }
procedure TRVWordEnumThread.SetBackToCurItem(RVData: TCustomRVData; ItemNo: Integer);
var r: Integer;
begin
  if not HasModifiedWord then
    exit;
  HasModifiedWord := False;
  r := RVCompareLocations(CurRVData, CurItemNo, RVData, ItemNo);
  if r>=0 then begin
    if r>0 then
      RVData.GetRVData.GetItem(ItemNo).ClearLiveSpellingResult
    else
      CheckUnchecked := True;
    NextRVData := RVData;
    NextItemNo := ItemNo;
    NextOffs   := 0;
    CheckUnchecked := False;
    SetBack;
  end;
end;
{------------------------------------------------------------------------------}
{ This method is called when RVData becomes invalid (for example, table cell is
  deleted. If this RVData=CurRVData, we set FForceSetBack flag.
  This flag prevents calling RVCompareLocations() in the SetBackMethod. }
procedure TRVWordEnumThread.RemoveRVData(RVData: TCustomRVData);
begin
  if RVData = CurRVData then
    FForceSetBack := True;
end;
{------------------------------------------------------------------------------}
{ Set the current position to (NextRVData,NextItemNo, NextOffs),
  if this position is before the current position.
  Context: main process (caller), the thread is suspended. }
procedure TRVWordEnumThread.SetBack;
var r: Integer;
    RVData : TCustomRVData;
    ItemNo, Offs: Integer;
begin
  if NextItemNo<0 then begin
    if FForceSetBack then
      Reset(FRichView);
    exit;
  end;
  RVData := NextRVData;
  ItemNo := NextItemNo;
  Offs   := NextOffs;
  NextItemNo := -1;
  NextOffs   := -1;
  NextRVData := nil;
  if FForceSetBack then
    r := 1
  else
    r := RVCompareLocations(CurRVData, CurItemNo, RVData, ItemNo);
  if r>=0 then begin
    CurRVData := RVData;
    CurItemNo := ItemNo;
    if r>0 then begin
      CurItemCheckStarted := Offs>1;
      if Offs>1 then begin
        {$IFDEF RVUNICODESTR}
        CurText := CurRVData.GetRVData.GetItemTextW(CurItemNo);
        {$ELSE}
        CurText := CurRVData.GetRVData.GetItemTextA(CurItemNo);
        {$ENDIF}
        CurTextStartPtr := PChar(CurText);
        CurTextPtr := CurTextStartPtr+Offs-1;
        if CurTextPtr>CurTextStartPtr then
          dec(CurTextPtr);
        while (CurTextPtr>CurTextStartPtr) and
          {$IFDEF RVUNICODESTR}
          not CurRVData.IsDelimiterW(CurTextPtr^)
          {$ELSE}
          not CurRVData.IsDelimiterA(CurTextPtr^, CP_ACP)
          {$ENDIF}
          do
          dec(CurTextPtr);
      end;
      end
    else if r=0 then begin
      if not CheckUnchecked then
        CurRVData.GetRVData.GetItem(CurItemNo).ClearLiveSpellingResult;
      CurItemCheckStarted := False;
    end
  end;
  FForceSetBack := False;  
end;
{------------------------------------------------------------------------------}
{ Was this item already checked? }
function TRVWordEnumThread.IsChecked(RVData: TCustomRVData; ItemNo: Integer): Boolean;
begin
  Result := RVCompareLocations(CurRVData, CurItemNo, RVData, ItemNo)>=0;
end;
{------------------------------------------------------------------------------}
{ Returns the next word for for the current text item.
  Item text is stored in CurText,
  pointer to the start of CurText - in CurTextStartPtr,
  pointer to the current position in text - in CurTextPtr.
  Returns '' if the item is completely processed.
  Context: thread. }
function TRVWordEnumThread.GetNextWord: String;
var StartPtr: PChar;
    CM: Boolean;
  {............................................................................}
  function IsEndingDelimiter(Str: PChar): Boolean;
  begin
    if RichViewApostropheInWord and ((Str^='''') or (Str^=RVCHAR_RQUOTE)) then
      Result := ((Str+1)^=#0) or
      {$IFDEF RVUNICODESTR}
      CurRVData.IsDelimiterW((Str+1)^) or (Str^='&')
      {$ELSE}
      CurRVData.IsDelimiterA((Str+1)^, CP_ACP) or (Str^='&')
      {$ENDIF}
    else
      {$IFDEF RVUNICODESTR}
      Result := CurRVData.IsDelimiterW(Str^) or (Str^='&');
      {$ELSE}
      Result := CurRVData.IsDelimiterA(Str^, CP_ACP) or (Str^='&');
      {$ENDIF}
  end;
  {............................................................................}
begin
  Result := '';
  CM := True;
  while True do begin
    if CurTextPtr^=#0 then begin
      CheckUnchecked := False;
      exit;
    end;
    if not (RichViewApostropheInWord and ((CurTextPtr^='''') or (CurTextPtr^=RVCHAR_RQUOTE))) and
      {$IFDEF RVUNICODESTR}
      not (CurRVData.IsDelimiterW(CurTextPtr^) or (CurTextPtr^='&'))
      {$ELSE}
      not (CurRVData.IsDelimiterA(CurTextPtr^, CP_ACP) or (CurTextPtr^='&'))
      {$ENDIF}
      then begin
      if CM and (not CheckUnchecked or
        not CurRVData.GetRVData.GetItem(CurItemNo).IsMisspelled(CurTextPtr-CurTextStartPtr+1)) then
        break
      else
        CM := False;
      end
    else
      CM := True;
    inc(CurTextPtr);
  end;
  StartPtr := CurTextPtr;
  while (CurTextPtr^<>#0) and not IsEndingDelimiter(CurTextPtr) do
    inc(CurTextPtr);
  WordOffs := StartPtr-CurTextStartPtr+1;
  WordLen := CurTextPtr-StartPtr;
  Result := Copy(CurText, WordOffs, WordLen);
end;
{------------------------------------------------------------------------------}
{ Returns a range of drawing items used to display misspelling
  in (DItemNo1, DItemNo2).
  Misspelling is defined by CurRVData, CurItemNo, WordOffs, WordLen.
  Context: main process (Synchronize).  }
procedure TRVWordEnumThread.GetMisspellingDrawItems(var DItemNo1, DItemNo2: Integer);
var offs: Integer;
begin
  if TCustomRVFormattedData(CurRVData.GetRVData).DrawItems.Count=0 then begin
    DItemNo1 := -1;
    DItemNo2 := -1;
    exit;
  end;
  try
    TCustomRVFormattedData(CurRVData.GetRVData).Item2DrawItem(CurItemNo, WordOffs, DItemNo1, Offs, rvdpStrict);
    TCustomRVFormattedData(CurRVData.GetRVData).Item2DrawItem(CurItemNo, WordOffs+WordLen, DItemNo2, Offs, rvdpStrict);
  except
    DItemNo1 := -1;
    DItemNo2 := -1;  
  end;
end;
{------------------------------------------------------------------------------}
{ Main thread procedure. }
procedure TRVWordEnumThread.Execute;
var CurWord: String;
    StoreSub: TRVStoreSubRVData;
    TempRVData: TCustomRVData;
    Misspelled: Boolean;
begin
  try
    while not Terminated do begin
      if Delaying then begin
        EditedWhileDelayed := False;
        Windows.Sleep(50);
        Delaying := EditedWhileDelayed;
        continue;
      end;
      case StopWorking of
        0:
          begin
            if Assigned(FRichView) then
              if CurItemNo>=CurRVData.GetRVData.ItemCount then begin
                if (CurRVData=TCustomRichView(FRichView).RVData) then begin
                  // spelling check is complete
                  if not Terminated then begin
                    Synchronize(SyncProc);
                    if StopWorking=0 then
                      Suspend;
                  end;
                  end
                else begin
                  // spelling check of cell is complete
                  CurRVData.GetParentInfo(CurItemNo, StoreSub);
                  TempRVData :=
                    TCustomRVData(CurRVData.GetAbsoluteParentData.GetItem(CurItemNo).GetSubRVData(StoreSub, rvdNext));
                  if TempRVData<>nil then begin
                    // going to the next cell
                    CurRVData := TempRVData;
                    CurItemNo := 0;
                    end
                  else begin
                    // continuing after the table
                    CurRVData := CurRVData.GetAbsoluteParentData;
                    inc(CurItemNo);
                  end;
                  CurRVData := CurRVData.GetSourceRVData;
                  StoreSub.Free;
                  StoreSub := nil;
                end;
                end
              else begin
                if (CurRVData.GetRVData.GetItemStyle(CurItemNo)>=0) and
                   (CheckUnchecked or
                    not (rvisSpellChecked in CurRVData.GetRVData.GetItem(CurItemNo).ItemState)) then begin
                  // checking a text item
                  if not CurItemCheckStarted then begin
                    {$IFDEF RVUNICODESTR}
                    CurText := CurRVData.GetRVData.GetItemTextW(CurItemNo);
                    {$ELSE}
                    CurText := CurRVData.GetRVData.GetItemTextA(CurItemNo);
                    {$ENDIF}
                    if (CurRVData.GetRVStyle<>nil) and
                       (
                        CurRVData.GetRVStyle.TextStyles[CurRVData.GetRVData.GetItemStyle(CurItemNo)].Jump and
                        (RVIsURL(CurText) or RVIsEmail(CurText))
                       )
                       {$IFDEF RICHVIEWCBDEF3}
                        or
                       (CurRVData.GetRVStyle.TextStyles[CurRVData.GetRVData.GetItemStyle(CurItemNo)].Charset=SYMBOL_CHARSET)
                       {$ENDIF}
                        then begin
                       CurRVData.GetRVData.GetItem(CurItemNo).ClearLiveSpellingResult;
                       CurText := '';
                       end
                    else if not CheckUnchecked then
                      CurRVData.GetRVData.GetItem(CurItemNo).ClearLiveSpellingResult;
                    CurTextStartPtr := PChar(CurText);
                    CurTextPtr := CurTextStartPtr;
                    CurItemCheckStarted := True;
                  end;
                  CurWord := GetNextWord;
                  if CurWord='' then begin
                    Include(CurRVData.GetRVData.GetItem(CurItemNo).ItemState, rvisSpellChecked);
                    inc(CurItemNo);
                    CurItemCheckStarted := False;
                    end
                  else begin
                    Misspelled := False;
                    {$IFDEF RVLIVESPELLEXEVENT}
                    if Assigned(TCustomRichView(FRichView).OnSpellingCheckEx) then
                      TCustomRichView(FRichView).OnSpellingCheckEx(TCustomRichView(FRichView), CurWord,
                        CurRVData, CurItemNo, WordOffs, Misspelled)
                    else
                    {$ENDIF}
                    if Assigned(TCustomRichView(FRichView).OnSpellingCheck) then
                      TCustomRichView(FRichView).OnSpellingCheck(TCustomRichView(FRichView), CurWord,
                        CurRVData.GetRVData.GetItemStyle(CurItemNo), Misspelled);
                    if Misspelled then
                      Synchronize(AddMisspelling);
                  end;
                  end
                else begin
                  TempRVData := TCustomRVData(CurRVData.GetRVData.GetItem(CurItemNo).GetSubRVData(StoreSub, rvdFirst));
                  if TempRVData<>nil then begin
                    // entering table
                    CurRVData := TempRVData;
                    CurItemNo := 0;
                    StoreSub.Free;
                    StoreSub := nil;
                    end
                  else
                    inc(CurItemNo);
                end;
              end;
          end;
        1:
          begin
            StopWorking := 2;
          end;
      end;
    end;
  finally
    StopWorking := 3;
    CurText := '';
  end;
end;
{$ENDIF}

end.