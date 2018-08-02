unit ObjUnallocateReport;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Grids, VirtualTrees,
  GlobVar,VarConst,VarRec2U, BtrvU2, ETMiscU, BTSupU3, ExBtTh1U, ReportU;


type
  TTreeTrackerLevel = Class(TObject)
  Public
    ttLevel : LongInt;
    ttSiblings : LongInt;

    ttLastPosX : Double;
    ttLastPosY : Double;
  End; // TTreeTrackerLevel

  //------------------------------

  TTreeTracker = Class(TList)
  Protected
    Function GetLevel (Level : LongInt) : TTreeTrackerLevel;
  Public
    Property Levels [Level : LongInt] : TTreeTrackerLevel Read GetLevel;

    Procedure AddLevel (Const TreeLevel, NoSiblings : LongInt);
    Procedure DeleteLevel (Const TreeLevel : LongInt);
  End; // TTreeTracker

  //------------------------------

  TObjectUnallocateReport  =  Object(TGenReport)
     Procedure RepSetTabs; Virtual;
     Procedure RepPrintPageHeader; Virtual;
     Procedure RepPrintHeader(Sender  :  TObject); Virtual;
   private
     TheTree     : TVirtualStringTree;
     fForMatching: Boolean;

     Procedure PrintDueTot;
     Function GetReportInput  :  Boolean; Virtual;
     procedure Print_UOutLine;
   public
     CRepParam  :  ^AllocCType;

     property ForMatching: Boolean read fForMatching write fForMatching;
     Constructor Create(AOwner  :  TObject);
     Destructor  Destroy; Virtual;
     function IncludeRecord  :  Boolean; Virtual;
     Procedure PrintReportLine; Virtual;
     Procedure PrintEndPage; Virtual;
     Procedure Process; Virtual;
     Procedure Finish;  Virtual;
  end; {Class..}


Procedure AddObjectUnallocateRep2Thread(IRepParam  :  MLocRec;
                                        AllocTree  :  TVirtualStringTree;
                                        AOwner     :  TObject;
                                        ForMatching:  Boolean = False);


Implementation

Uses
  Dialogs,
  Forms,
  Printers,
  TEditVal,
  ETDateU,
  ETStrU,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  BTSupU1,
  {InvListU,}
  {RevalU2U,}
  SalTxl1U,
  ObjUnallocateF,

  IntMU,

  {DocSupU1,}
  AllocS1U,
  BPyItemU,
  RpDefine,
  ExThrd2U;

//=========================================================================

Procedure AddObjectUnallocateRep2Thread(IRepParam  :  MLocRec;
                                        AllocTree  :  TVirtualStringTree;
                                        AOwner     :  TObject;
                                        ForMatching:  Boolean = False);
Var
  EntTest  :  ^TObjectUnallocateReport;
Begin // AddObjectUnallocateRep2Thread
  If Create_BackThread then
  Begin
    New(EntTest,Create(AOwner));

    EntTest^.ForMatching := ForMatching;
    try
      With EntTest^ do
      Begin
        ReportMode:=12;

        CRepParam^:=IRepParam.AllocCRec;

        If Assigned(AllocTree) then
          TheTree := AllocTree;

        If Create_BackThread and Start then
          BackThread.AddTask(EntTest,ThTitle)
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(EntTest,Destroy);
        end;
      end; {with..}
    except
      Dispose(EntTest,Destroy);

    end; {try..}
  End; // If Create_BackThread
end; // AddObjectUnallocateRep2Thread

//=========================================================================

Function TTreeTracker.GetLevel (Level : LongInt) : TTreeTrackerLevel;
Begin // GetLevel
  If (Level < Count) Then
    Result := TTreeTrackerLevel(Items[Level])
  Else
    Raise Exception.Create ('TTreeTracker.GetLevel: Invalid Level Request = ' + IntToStr(Level) + ', Count = ' + IntToStr(Count));
End; // GetLevel

//-------------------------------------------------------------------------

Procedure TTreeTracker.AddLevel (Const TreeLevel, NoSiblings : LongInt);
Var
  TreeTrackerLevel : TTreeTrackerLevel;
Begin // AddLevel
  TreeTrackerLevel := TTreeTrackerLevel.Create;
  TreeTrackerLevel.ttLevel := TreeLevel;
  TreeTrackerLevel.ttSiblings := NoSiblings;
  TreeTrackerLevel.ttLastPosX := -1;
  TreeTrackerLevel.ttLastPosY := -1;

  Add (TreeTrackerLevel);
End; // AddLevel

//-------------------------------------------------------------------------

Procedure TTreeTracker.DeleteLevel (Const TreeLevel : LongInt);
Begin // DeleteLevel
  While (Count > Treelevel) Do
  Begin
    TObject(Items[TreeLevel]).Free;
    Delete (TreeLevel);
  End; // While (Count > Treelevel)
End; // DeleteLevel

//=========================================================================

Constructor TObjectUnallocateReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);
  FillChar(CRepParam^,Sizeof(CRepParam^),0);
  TheTree:=Nil;
end;

//------------------------------

Destructor TObjectUnallocateReport.Destroy;
Begin
  Dispose(CRepParam);
  Inherited Destroy;
end;

//-------------------------------------------------------------------------

Procedure TObjectUnallocateReport.RepSetTabs;
Begin // RepSetTabs
  With RepFiler1 Do
  Begin
    ClearTabs;

    SetTab (MarginLeft+10, pjRight, 30, 4, 0, 0);
    SetTab (NA, pjRight, 29, 4, 0, 0);
    SetTab (NA, pjRight, 30, 4, 0, 0);
    SetTab (NA, pjRight, 29, 4, 0, 0);
    // MH 13/01/2016 2016-R1 ABSEXCH-17139: Added columns for .xlsx version
    SetTab (NA, pjRight, 30, 4, 0, 0);
    SetTab (NA, pjRight, 30, 4, 0, 0);
  End; // With RepFiler1

  SetTabCount;
End; // RepSetTabs

//-------------------------------------------------------------------------

Procedure TObjectUnallocateReport.RepPrintPageHeader;
Begin // RepPrintPageHeader
  With RepFiler1, CRepParam^ Do
  Begin
    RepSetTabs;

    DefFont(0,[fsBold]);

    SendLine('OutLine Page Header');

    DefFont(0,[]);
  end; {With..}
End; // RepPrintPageHeader

//-------------------------------------------------------------------------

Procedure TObjectUnallocateReport.RepPrintHeader(Sender  :  TObject);
Begin // RepPrintHeader
  Inherited RepPrintHeader(Sender);
End; // RepPrintHeader

//-------------------------------------------------------------------------

// Due Sub / Grand Total
Procedure TObjectUnallocateReport.PrintDueTot;
Begin // PrintDueTot
  With RepFiler1, CRepParam^ do
  Begin
    RepSetTabs;
    DefLine(-2,1,PageWidth-MarginRight-1,-0.5);

    SendLine('');

    DefFont(0,[fsBold]);

    SendLine(ConCat(#9,'Total  Debit: ',#9,FormatFloat(GenRealMask,arcOwnTransValue),#9,'Total Credit: ',#9,FormatFloat(GenRealMask,arcOwnSettleD)));

    DefFont(0,[]);

    DefLine(-2,1,PageWidth-MarginRight-1,-0.5);
  End; // With RepFiler1, CRepParam^
End; // PrintDueTot

//-------------------------------------------------------------------------

Procedure TObjectUnallocateReport.PrintReportLine;
Begin
  // Don't do nuffin here
end;

//-------------------------------------------------------------------------

Procedure TObjectUnallocateReport.PrintEndPage;
Begin
  If Assigned(TheTree) Then
  Begin
    Print_UOutLine;
    PrintDueTot;
  End; // If Assigned(TheTree)

  Inherited PrintEndPage;
end;

//-------------------------------------------------------------------------

// Report doesn't actually print any database data - the report is printed using the
// tree passed in as a parameter from the footer
Function TObjectUnallocateReport.IncludeRecord  :  Boolean;
Begin
  Result := BOff;
end; {Func..}

//-------------------------------------------------------------------------

Function TObjectUnallocateReport.GetReportInput  :  Boolean;
Begin
  With CRepParam^ do
  Begin
    // CJS 18/03/2011 - ABSEXCH-9646
    if fForMatching then
    begin
      ThTitle:='Matching Report';
      RepTitle:='Matching Report for '+arcOurRef;
    end
    else
    begin
      ThTitle:='Unallocation Report';
      RepTitle:='Unallocation Matching Report for '+arcOurRef;
    end;
    PageTitle:=RepTitle;

    RFont.Size:=10;
    ROrient:=RPDefine.PoPortrait;

    RFnum:=MiscF;
    RKeyPath:=MIK;
    RepKey:=PartCCKey(MBACSCode,MBACSALSub)+NdxWeight;
  End; // With CRepParam^

  Result := BOn;
end;

//-------------------------------------------------------------------------

procedure TObjectUnallocateReport.Print_UOutLine;
Const
  IndentChars = 4;

Var
  oTreeTracker : TTreeTracker;

  //------------------------------

  Procedure SetReportStuff;
  Begin // SetReportStuff
    With RepFiler1 Do
    Begin
      FontName := RFont.Name;
      FontSize := RFont.Size;
      FontColor := clBlack;
      LineHeight := RFont.Size / 2;
      ResetLineHeight;
      SetPen (clBlack, psSolid, 1, pmBlack);
    End; // With RepFiler1
  End; // SetReportStuff

  //------------------------------

  Procedure PrintItem (TheNode : PVirtualNode; Const TreeLevel, SiblingNo : LongInt);
  Var
    pNodeData : pNodeDataRec;
    CellText, S : WideString;
    iLevel : SmallInt;
    StartXPos : Double;
  Begin // PrintItem
    pNodeData := TheTree.GetNodeData(TheNode);

    // Update reports Total Records count printed in footer
    Inc(ICount);

    With RepFiler1 Do
    Begin
      SetReportStuff;

      // Indent
      // MH 12/01/2016 2016-R1 ABSEXH-17139: Changed to use .xlsx compatible functionality
      Self.Print(StringOfChar (' ', TreeLevel * IndentChars));

      // Tree structure
      If TreeLevel = 0 Then
      Begin
        // Dash for Root Node
        MoveTo (XD2U(CursorXPos) - 3, LineMiddle);
        LineTo (XD2U(CursorXPos) - 1, LineMiddle);
      End // If TreeLevel = 0
      Else With oTreeTracker.Levels[TreeLevel] Do
      Begin
        If (ttLastPosX <> -1) And (ttLastPosY <> -1) Then
          MoveTo (ttLastPosX, ttLastPosY)
        Else
          MoveTo (XD2U(CursorXPos) - 3, LineTop);

        If (ttSiblings > SiblingNo) Then
        Begin
          // More bro's to come
          LineTo (XD2U(CursorXPos) - 3, LineBottom);

          ttLastPosX := XD2U(CursorXPos) - 3;
          ttLastPosY := LineBottom;
        End // If (oTreeTracker.Levels[TreeLeve].ttSiblings > SiblingNo)
        Else
        Begin
          // Last bro
          LineTo (XD2U(CursorXPos) - 3, LineMiddle);

          ttLastPosX := -1;
          ttLastPosY := -1;
        End; // Else

        MoveTo (XD2U(CursorXPos) - 3, LineMiddle);
        LineTo (XD2U(CursorXPos) - 1, LineMiddle);
      End; // With oTreeTracker.Levels[TreeLevel]

      If Assigned(pNodeData) Then
      Begin
        // Record start position for drill-down
        StartXPos := XD2U(CursorXPos);

        // MH 12/01/2016 2016-R1 ABSEXH-17139: Changed to use .xlsx compatible functionality
		If (RDevRec.fePrintMethod = 5 {XLSX}) Then
          S := #9
        Else
          S := '';

        // Actual ourref
        TheTree.OnGetText(TheTree, TheNode, 0, ttNormal, CellText);
        // MH 12/01/2016 2016-R1 ABSEXH-17139: Changed to use .xlsx compatible functionality
		If (RDevRec.fePrintMethod = 5 {XLSX}) Then
          S := S + CellText + #9
        Else
          Self.Print(CellText);

        // Matched Amount
        TheTree.OnGetText(TheTree, TheNode, 1, ttNormal, CellText);
        // MH 12/01/2016 2016-R1 ABSEXH-17139: Changed to use .xlsx compatible functionality
		If (RDevRec.fePrintMethod = 5 {XLSX}) Then
          S := S + CellText + #9
        Else
          Self.Print(', ' + Trim(CellText));

        // YourRef
        TheTree.OnGetText(TheTree, TheNode, 2, ttNormal, CellText);
        // MH 12/01/2016 2016-R1 ABSEXH-17139: Changed to use .xlsx compatible functionality
		If (RDevRec.fePrintMethod = 5 {XLSX}) Then
          S := S + CellText + #9
        Else
          Self.Print(', ' + CellText);

        // Date
        TheTree.OnGetText(TheTree, TheNode, 3, ttNormal, CellText);
        // MH 12/01/2016 2016-R1 ABSEXH-17139: Changed to use .xlsx compatible functionality
		If (RDevRec.fePrintMethod = 5 {XLSX}) Then
        Begin
          S := S + CellText;
          SendText(S);
        End // If (RDevRec.fePrintMethod = 5 {XLSX}) 
        Else
          Self.Print(', ' + CellText);

        // Setup Drill-Down area for printed area
        SendRepSubHedDrillDown (StartXPos, XD2U(CursorXPos), 1, FullOurRefKey(pNodeData^.ndOurRef), InvF, InvOurRefK, 0);

        // MH 12/01/2016 2016-R1 ABSEXH-17139: Changed to use .xlsx compatible functionality
		Self.CRLF;
      End // If Assigned(pNodeData)
      Else
        // MH 12/01/2016 2016-R1 ABSEXH-17139: Changed to use .xlsx compatible functionality
        SendLine('NIL');

      // Check for space on page
      If (LinesLeft < 4) Then
      Begin
        // Draw all outstanding vertical lines to bottom of page
        For iLevel := 0 To (oTreeTracker.Count - 1) Do
          With oTreeTracker.Levels[iLevel] Do
          Begin
            If (ttLastPosX <> -1) And (ttLastPosY <> -1) Then
            Begin
              MoveTo (ttLastPosX, ttLastPosY);
              LineTo (ttLastPosX, LineBottom);
            End; // If (ttLastPosX <> -1) And (ttLastPosY <> -1)
          End; // With oTreeTracker.Levels[iLevel]

        // New Page
        ThrowNewPage(-1);

        // Reset font, line widths, etc... after doing page header and add blank line
        SetReportStuff;
        // MH 12/01/2016 2016-R1 ABSEXH-17139: Changed to use .xlsx compatible functionality
        SendLine('');

        // Reset all outstanding vertical lines to start at top of new page
        For iLevel := 0 To (oTreeTracker.Count - 1) Do
          With oTreeTracker.Levels[iLevel] Do
          Begin
            If (ttLastPosX <> -1) And (ttLastPosY <> -1) Then
            Begin
              ttLastPosY := LineTop;
            End; // If (ttLastPosX <> -1) And (ttLastPosY <> -1)
          End; // With oTreeTracker.Levels[iLevel]
      End; // If (LinesLeft < 20)
    End; // With RepFiler1
  End; // PrintItem

  //------------------------------

  // Routine processes the passed node and then runs through its children recursively
  // calling itself - important to minimise local stack variables in this routine
  Procedure ProcessNode (TheNode : PVirtualNode; Const TreeLevel, SiblingNo : LongInt);
  Var
    ChildNode : PVirtualNode;
    ChildNo : LongInt;
  Begin // ProcessNode
    // Print this node
    PrintItem (TheNode, TreeLevel, SiblingNo);

    // Run through any children of the node
    If (TheNode.ChildCount > 0) Then
    Begin
      // Create new level in tracker
      oTreeTracker.AddLevel(TreeLevel + 1, TheNode.ChildCount);
      Try
        ChildNo := 1;
        ChildNode := TheNode.FirstChild;
        Repeat
          ProcessNode (ChildNode, TreeLevel + 1, ChildNo);
          ChildNode := ChildNode.NextSibling;
          ChildNo := ChildNo + 1;
        Until ChildNode = NIL;
      Finally
        oTreeTracker.DeleteLevel(TreeLevel + 1);
      End; // Try..Finally
    End; // If (TheNode.ChildCount > 0)
  End; // ProcessNode

  //------------------------------

Begin{PrintOutLine}
  SetReportStuff;
  // MH 12/01/2016 2016-R1 ABSEXH-17139: Changed to use .xlsx compatible functionality
  SendLine('');

  oTreeTracker := TTreeTracker.Create;
  Try
    // Create new level in tracker
    oTreeTracker.AddLevel(0, 1);
    Try
      // Our Root Node is the first (and only) child of the Tree's Root Node
      ProcessNode (TheTree.RootNode.FirstChild, 0, 1);
    Finally
      oTreeTracker.DeleteLevel(0);
    End; // Try..Finally
  Finally
    oTreeTracker.Free;
  End; // Try..Finally

  // MH 12/01/2016 2016-R1 ABSEXH-17139: Changed to use .xlsx compatible functionality
  SendLine('');
end;{PrintOutLine}

//-------------------------------------------------------------------------

Procedure TObjectUnallocateReport.Process;
Begin
  Inherited Process;
end;

//-------------------------------------------------------------------------

Procedure TObjectUnallocateReport.Finish;
Begin
  Inherited Finish;
end;

//=========================================================================

end.
