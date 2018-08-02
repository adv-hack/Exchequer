unit BtrvList;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  SupListU, CmpCtrlU, Forms, SBSPanel, Windows, Controls, BTSupU1, Graphics,
  ExtCtrls, SBSComp2, SBSComp, Classes, ColCtrlU, TEditVal;

type
  TColumnInfo = record
    ColPanel  : TSBSPanel;
    HeadPanel : TSBSPanel;
    Alignment : TAlignment;  // Unit Classes
    DecPlaces : Byte;
  end; // TColumnInfo

  TAllColumns = array of array of TColumnInfo;

  TPoints = Record
    List     : TPoint;
    BtnPanel : TPoint;
    ScrlPan  : TPoint;
    ListPan  : TPoint;
  end;{TPoints}

  // Multiple Btrieve lists on a page control
  TFormStuff = class
    public {for now at least - may change }
    // Need to set the following from calling code ...
    // array of page tabs / columns per page tab
    aColumns   : TAllColumns;
    // indexes per page tab
    aiKeys     : array of integer;
    // starting position on key e.g. with variant records
    aKeyStart : array of string;
    // ending position on key e.g. with variant records
    aKeyEnd   : array of string;
    // length of the key to use - will be set to a default value
    aKeyLength : array of integer;
    // Btrieve file no. per page tab (e.g. CustF)
    aFileNos   : array of integer;
    // Scroll box for buttons that scroll on the right hand panel per tab
    asbButtons : array of TScrollBox;
    // Scroll box for main Btrieve list per page tab
    asbMain : array of TScrollBox;

    // Key is Longint, special handling needed
    aUseSet4End : array of Boolean;

    

    // Btrieve lists per page tab
    aMULCtrlO : array of TGenList;
    // Filter field:
    // FilterType[1,0] = first filter include setting
    // FilterType[1,1] = first filter exclude setting
    // FilterType[2,0] = second filter include setting etc
    aFilters : array of FilterType;
    // Location coordinates for positioning - don't need to set
    aPoints : array of TPoints;
    // Scrollbar on the right of the Btrieve list with the arrow icons on it
    apanScrollBar : array of TSBSPanel;
    // Main button panel on the right
    apanButtons : array of TSBSPanel;
    // Title panel on which all the list column header panels are on
    apanTitle : array of TSBSPanel;
    // Set of columns to hide if a feature is not enabled
    aHideColumns : set of byte;

    // The following don't need to be set to set up the form
    bSetDefaults : boolean;
    bGotCoord : boolean;
    bLastCoord : boolean;
    bStoreCoord : boolean;
    bFillList : boolean;
    constructor Create(iNoOfPages : integer);
    destructor  Destroy; override;
  end;{TFormStuff}

  procedure FillBtrieveList(FormStuff : TFormStuff; ListNum : integer);
  procedure ReadFormProperties(TheForm : TForm; FormStuff : TFormStuff; acPrimeKey : char;
    ThePanel : TPanel = nil);
  procedure StoreFormProperties(TheForm : TForm; FormStuff : TFormStuff;
    bStoreCoord, bSetDefaults, bLastCoord : Boolean; acPrimeKey : char);
{  procedure SetDefaultSize(TheForm : TForm; var Points : TPoints; iDefClientHeight, iDefClientWidth : integer);}
  procedure DoFormResize(TheForm : TForm; FormStuff : TFormStuff; ThePanel : TPanel = nil);
  procedure ListProperties(TheForm : TForm; MULCtrlO : TMULCtrl; var bSetDefaults : boolean; sCaption : string);
  procedure DoMoveAlignCols(ThePanel : TSBSPanel; FormStuff : TFormStuff; iPage : Integer);
  function SetSBMainScrollBar(MULCtrlO : TMULCtrl; sbMain : TScrollBox): boolean;

  procedure FormColourProperties(TheForm : TForm; var bSetDefaults : boolean; sCaption : string);
  procedure StoreJustFormCoord(TheForm : TForm; SampleField : Text8Pt;
    bStoreCoord, bSetDefaults, bLastCoord : Boolean; acPrimeKey : char; StoreForm : boolean);
  procedure FindJustFormCoord(TheForm : TForm; SampleField : Text8Pt;
    bStoreCoord, bSetDefaults, bLastCoord : Boolean; acPrimeKey : char; ReadForm : boolean);

implementation

uses
  Dialogs,
  SysUtils,
  VarConst,
  StdCtrls; // Needed for EntryRec

//-----------------------------------------------------------------------

constructor TFormStuff.Create(iNoOfPages : integer);
// Pre : iNoOfPages = number of pages on tab control
begin
  inherited create;
  SetLength(aColumns,iNoOfPages);
  SetLength(aPoints,iNoOfPages);
  SetLength(aFileNos,iNoOfPages);
  SetLength(asbMain,iNoOfPages);
  SetLength(apanTitle,iNoOfPages);
  SetLength(asbButtons,iNoOfPages);
  SetLength(apanButtons,iNoOfPages);
  SetLength(aMULCtrlO,iNoOfPages);
  SetLength(apanScrollBar,iNoOfPages);
  SetLength(aiKeys,iNoOfPages);
  SetLength(aKeyStart,iNoOfPages);
  SetLength(aKeyEnd,iNoOfPages);
  SetLength(aKeyLength,iNoOfPages);
  SetLength(aUseSet4End,iNoOfPages);
  SetLength(aFilters,iNoOfPages);
// The login name needs to be set if wish to store user specific parameters
// No Login to E-Business at the moment
// EntryRec^.Login := 'DEFAULT';
end;

//-----------------------------------------------------------------------

destructor TFormStuff.Destroy;
var
  iPos : integer;
begin
  For iPos := 0 to High(aColumns) do
    SetLength(aColumns[iPos],0);
  SetLength(aColumns,0);
  SetLength(aPoints,0);
  SetLength(aFileNos,0);
  SetLength(asbMain,0);
  SetLength(apanTitle,0);
  SetLength(asbButtons,0);
  SetLength(apanButtons,0);
  SetLength(aUseSet4End,0);

  for iPos := 0 to High(aMULCtrlO) do
    FreeAndNil(aMULCtrlO[iPos]);

  SetLength(aMULCtrlO,0);
  SetLength(apanScrollBar,0);
  SetLength(aiKeys,0);
  SetLength(aKeyStart,0);
  SetLength(aKeyEnd,0);
  SetLength(aKeyLength,0);
  SetLength(aFilters,0);
  aHideColumns := [];
  inherited destroy;
end;

//-----------------------------------------------------------------------

procedure FillBtrieveList(FormStuff : TFormStuff; ListNum : integer);
// Notes : Initialises the Btrieve list with data from the file
//         If there are multiple lists on a page control use ListNum to enumerate them
//         First one is zero.
begin
  with FormStuff do
  begin
    if aKeyLength[ListNum] = 0 then
      aKeyLength[ListNum] := length(aKeyStart[ListNum]);
    aMULCtrlO[ListNum].StartList(aFileNos[ListNum], aiKeys[ListNum], aKeyStart[ListNum],
      aKeyEnd[ListNum], '', aKeyLength[ListNum], FALSE);
  end;
end;

//-----------------------------------------------------------------------

procedure ReadFormProperties(TheForm : TForm; FormStuff : TFormStuff; acPrimeKey : char;
  ThePanel : TPanel = nil);
// Notes : Call this to read in the saved properties of your form
//         (colours / position / size etc.)
//         VERY IMPORTANT - Make sure the names of panels differ in their
//         first 9 characters as only these are used on the Btrieve index.
// Pre   : Set acPrimeKey to null (#0) to avoid trying to load saved properties
//       : ThePanel = Reference to a panel should the Btrieve list be on one
var
  GlobComp : TGlobCompRec;
  ColCount,
  iPos, iCol, i : integer;
  StartPanel : TSBSPanel;
begin
  {stores current co-ordinates of various components}
  with TheForm, FormStuff do
  begin
    bGotCoord := FALSE;

    for iPos := 0 to High(aMulCtrlO) do
    begin
      with aPoints[iPos] do
      begin
        if assigned(ThePanel) then
        begin
          List.X := ThePanel.Width - asbMain[iPos].Width;
          List.Y := ThePanel.Height - asbMain[iPos].Height;
       (*   List.X := Width - asbMain[iPos].Width;
          List.Y := ClientHeight - asbMain[iPos].Height; *)
        end
        else
        begin
          List.X := Width - asbMain[iPos].Width;
          List.Y := Height - asbMain[iPos].Height;
        end;
        if apanButtons[iPos] <> nil then
        begin
          if assigned(ThePanel) then
            BtnPanel.X := ThePanel.Width - apanButtons[iPos].Left
          else
            BtnPanel.X := Width - apanButtons[iPos].Left;
          if asbButtons[iPos] <> nil then
            BtnPanel.Y := apanButtons[iPos].Height - asbButtons[iPos].Height;
        end;{if}

        if apanScrollBar[iPos] <> nil then
          if assigned(ThePanel) then
          begin
            ScrlPan.X := ThePanel.Width - apanScrollBar[iPos].Left;
            ScrlPan.Y := ThePanel.Height - apanScrollBar[iPos].Height;
          (*  ScrlPan.X := Width - apanScrollBar[iPos].Left;
            ScrlPan.Y := ClientHeight - apanScrollBar[iPos].Height; *)
          end
          else
          begin
            ScrlPan.X := Width - apanScrollBar[iPos].Left;
            ScrlPan.Y := Height - apanScrollBar[iPos].Height;
          end;
        if aColumns[iPos,0].ColPanel <> nil then
          ListPan.Y := asbMain[iPos].ClientHeight - aColumns[iPos,0].ColPanel.Height;
      end; // with aPoints
    end; // for iPos
    bGotCoord := TRUE;

    for iPos := 0 to High(aMulCtrlO) do
    begin
      if assigned(aMulCtrlO[iPos]) then
      with aMULCtrlO[iPos] do
      begin
        if acPrimeKey <> chr(0) then
        begin
          New(GlobComp,Create(TRUE));
          with GlobComp^ do
          begin
            GetValues := TRUE;
            PrimeKey := acPrimeKey;
            if (GetbtControlCsm(TheForm)) then
            begin
              bStoreCoord := (ColOrd = 1);
              HasCoord := (HLite = 1);
              bLastCoord := HasCoord;
              {Go get position, as it would not have been set initially}
              if (HasCoord) then
                SetPosition(TheForm);
            end;
            GetbtControlCsm(apanTitle[iPos]);
          end;{with}
          Dispose(GlobComp,Destroy);
        end; // acPrimeKey not null

        try
          {Setup List}
          with aMULCtrlO[iPos] do
          begin
            try
              with VisiList do
              begin
                For iCol := 0 to High(aColumns[iPos]) do
                  AddVisiRec(aColumns[iPos, iCol].ColPanel,aColumns[iPos, iCol].HeadPanel);
                VisiRec := List[0];
                StartPanel := (VisiRec^.PanelObj as TSBSPanel);
                for ColCount := Low(byte) to High(byte) do
                  if ColCount in aHideColumns then
                  begin
                    SetHidePanel(ColCount, true, true);
                    aPanTitle[iPos].Width := aPanTitle[iPos].Width -
                      aColumns[iPos, ColCount].ColPanel.Width - 2;
                  end;
                LabHedPanel := apanTitle[iPos];
              end;{with}
            except
              VisiList.Free;
            end;{try}

            if acPrimeKey <> chr(0) then
            begin
              New(GlobComp,Create(TRUE));
              with GlobComp^ do
              begin
                GetValues := TRUE;
                PrimeKey := acPrimeKey; // Problems with multiple page lists ???
                HasCoord := bLastCoord;
                Find_ListCoord(GlobComp);
              end;
              Dispose(GlobComp, Destroy);
            end; // acPrimeKey not null

            TabOrder := -1;
            TabStop := FALSE;
            Visible := FALSE;
            BevelOuter := bvNone;
            ParentColor := False;
            Color := StartPanel.Color;
            MUTotCols := High(aColumns[iPos]);
            Font := StartPanel.Font;
            LinkOtherDisp := TRUE;
            WM_ListGetRec := WM_CustGetRec;
            Parent := StartPanel.Parent;
            MessHandle := TheForm.Handle;
            for iCol := 0 to MUTotCols do
            begin
              with ColAppear^[iCol] do
              begin
                AltDefault := TRUE;
                {Right justifies columns whose header panels are right justified}
                if aColumns[iPos,iCol].Alignment = taRightJustify then
                begin
                  DispFormat := SGFloat;
                  NoDecPlaces := aColumns[iPos,iCol].DecPlaces;
                end;{if}
              end;{with}
            end;
            ListLocal := nil;
            ListCreate;
            UseSet4End := aUseSet4End[iPos];
            NoUpCaseCheck := TRUE;
            HighLiteStyle[1] := [fsBold];
            Set_Buttons(apanScrollBar[iPos]);
            for i := 1 to NOfScanFilters do
            begin
              Filter[i,0] := aFilters[iPos,i,0];
              Filter[i,1] := aFilters[iPos,i,1];
            end;
            // Filter[1,0] := ''; - previous version
            AbortOnEmpty := FALSE;{This turns off the message that there is nothing in the sublist}
            if bFillList then
              FillBtrieveList(FormStuff, iPos);
          end
        except
          on E:Exception do
          begin
            ShowMessage('Exception raised in ReadFromProperties: ' +#13#10 + E.Message);
            aMULCtrlO[iPos].Free;
            aMULCtrlO[iPos] := nil;
          end;
        end;
      end;
    end; // for iPos
  end; // with
end; // ReadFormProperties

//-----------------------------------------------------------------------

procedure StoreFormProperties(TheForm : TForm; FormStuff : TFormStuff;
  bStoreCoord, bSetDefaults, bLastCoord : Boolean; acPrimeKey : char);
// Notes : Call this to save the properties of your form (colours/position/size etc.}
// Pre   : Set acPrimeKey to null (#0) to avoid trying to load saved properties
var
  GlobComp : TGlobCompRec;
  iPos : SmallInt;
begin
  with TheForm do
  begin
    for iPos := 0 to Pred(ComponentCount) do
      if (Components[iPos] is TScrollBox) then
      begin
        with TScrollBox(Components[iPos]) do
        begin
          VertScrollBar.Position := 0;
          HorzScrollBar.Position := 0;
        end;{with}
      end;{if}
    VertScrollBar.Position := 0;
    HorzScrollBar.Position := 0;

    if acPrimeKey <> chr(0) then
    with FormStuff do
    begin
      for iPos := 0 to High(aMulCtrlO) do
        if assigned(aMulCtrlO[iPos]) then
        with aMULCtrlO[iPos] do
        begin
          New(GlobComp,Create(FALSE));
          with GlobComp^ do
          begin
            GetValues := not bSetDefaults;
            PrimeKey := acPrimeKey;
            ColOrd := Ord(bStoreCoord);
            HLite := Ord(bLastCoord);
            SaveCoord := bStoreCoord;
            if (not bLastCoord) then
              HLite := ColOrd;{* Attempt to store last coord *}
            StorebtControlCsm(TheForm);
            StorebtControlCsm(apanTitle[iPos]);
            GetValues := not bSetDefaults;
            SaveCoord := bStoreCoord;
            PrimeKey := acPrimeKey; // Problems likely with multiple page lists ????
            if Assigned(aMULCtrlO[iPos]) then
              aMULCtrlO[iPos].Store_ListCoord(GlobComp);
          end; // GlobComp
          dispose(GlobComp,Destroy);
        end; // with aMULCtrlO
    end;
  end;
end; // StoreFormProperties

//-----------------------------------------------------------------------

{procedure SetDefaultSize(TheForm : TForm; var aPoints : array of TPoints; iDefClientHeight, iDefClientWidth : integer);
{Call this to set the default size of your form}
{begin
  with Points do begin
    InitSize.Y := iDefClientHeight;
    InitSize.X := iDefClientWidth;
    TheForm.ClientHeight := InitSize.Y;
    TheForm.ClientWidth := InitSize.X;
  end;{with}
{end;}

//-----------------------------------------------------------------------

procedure DoFormResize(TheForm : TForm; FormStuff : TFormStuff; ThePanel : TPanel = nil);
{Attach this to the OnResize Event of your form}
var
  bScrollBarChanged, bHeightChanged : boolean;
  iPos : integer;
begin
  {resizes / positions all controls on the form when it is resized}
  with FormStuff do begin
    For iPos := 0 to High(aMulCtrlO) do begin
      if bGotCoord then begin
        with TheForm, aPoints[iPos] do begin
          {Resize scrollbar panel}
          if apanScrollBar[iPos] <> nil then
          begin
            if ThePanel <> nil then
            begin
              apanScrollBar[iPos].Left := ThePanel.Width - ScrlPan.X;
              apanScrollBar[iPos].Height := ThePanel.Height - ScrlPan.Y;
            end
            else
            begin
              apanScrollBar[iPos].Left := Width - ScrlPan.X;
              apanScrollBar[iPos].Height := Height - ScrlPan.Y;
            end;
          end;{if}

          {Resize main list ScrollBox}
          if ThePanel <> nil then
          begin
            asbMain[iPos].Width := ThePanel.Width - List.X;
            bHeightChanged := asbMain[iPos].Height <> ThePanel.Height - List.Y;
            asbMain[iPos].Height := ThePanel.Height - List.Y;
          end
          else
          begin
            asbMain[iPos].Width := Width - List.X;
            bHeightChanged := asbMain[iPos].Height <> Height - List.Y;
            asbMain[iPos].Height := Height - List.Y;
          end;

          {Reposition button panel}
          if apanButtons[iPos] <> nil then
          begin
            if ThePanel <> nil then
            begin
              apanButtons[iPos].Left := ThePanel.Width - BtnPanel.X;
              apanButtons[iPos].Height := ThePanel.Height - List.Y;
            end
            else
            begin
              apanButtons[iPos].Left := Width - BtnPanel.X;
              apanButtons[iPos].Height := Height - List.Y;
            end;
            {Resize button ScrollBox within button panel}
            if asbButtons[iPos] <> nil then
              asbButtons[iPos].Height := apanButtons[iPos].Height - BtnPanel.Y;
          end;{if}
        end;{with}
      end;{if}

      if aMULCtrlO[iPos] <> nil then begin
        bScrollBarChanged := SetSBMainScrollBar(aMULCtrlO[iPos], asbMain[iPos]);
        {Resize the list's columns}
        with aMULCtrlO[iPos], VisiList do begin
          if (List <> nil) and (bScrollBarChanged or bHeightChanged) then begin
            Refresh_Buttons; {Repositions the Scrollbar Buttons}
            VisiRec := List[0];
            TSBSPanel(VisiRec^.PanelObj).Height := asbMain[iPos].ClientHeight - 31; {Resizes column 1 to fit scroll box}
            RefreshAllCols; {Resizes all columns to match column 1}
          end;{if}
        end;{with}
      end;{if}
    end;{for}
  end;{with}
end;

//-----------------------------------------------------------------------

procedure ListProperties(TheForm : TForm; MULCtrlO : TMULCtrl; var bSetDefaults : boolean;
  sCaption : string);
{shows the dialog box allowing you to change the Colours & Fonts for your form}
var
  TmpPanel : array[1..3] of TPanel;
  iPos : integer;
  BeenChange : Boolean;
  ColourCtrl : TCtrlColor;
begin
  bSetDefaults := FALSE;
  for iPos := 1 to 3 do TmpPanel[iPos] := TPanel.Create(TheForm);
  try
    {read in current colors}
    with MULCtrlO, VisiList do begin
      VisiRec := List[0];
      TmpPanel[1].Font := (VisiRec^.PanelObj as TSBSPanel).Font;
      TmpPanel[1].Color := (VisiRec^.PanelObj as TSBSPanel).Color;
      TmpPanel[2].Font := (VisiRec^.LabelObj as TSBSPanel).Font;
      TmpPanel[2].Color := (VisiRec^.LabelObj as TSBSPanel).Color;
      TmpPanel[3].Color := ColAppear^[0].HBKColor;
      TmpPanel[3].Font.Assign(TmpPanel[1].Font);
      TmpPanel[3].Font.Color := ColAppear^[0].HTextColor;
    end;{with}

    try
      ColourCtrl := TCtrlColor.Create(TheForm);
      with ColourCtrl do begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1 {Sets current colours and}
        ,sCaption,BeenChange,bSetDefaults);{pops up colour dialog}
        if (BeenChange) and (not bSetDefaults) then begin
          {change colours}
          with MULCtrlO do begin
            ReColorCol(TmpPanel[1].Font,TmpPanel[1].Color,FALSE);
            ReColorCol(TmpPanel[2].Font,TmpPanel[2].Color,TRUE);
            VisiList.LabHedPanel.Color := TmpPanel[2].Color;
            ReColorBar(TmpPanel[3].Font,TmpPanel[3].Color);
          end;{with}
        end;{if}
      end;{with}
    finally
      ColourCtrl.Free;
    end;{try}
  finally
    for iPos := 1 to 3 do TmpPanel[iPos].Free;
  end;{try}
  if bSetDefaults then TheForm.Close;
end;

//-----------------------------------------------------------------------

procedure DoMoveAlignCols(ThePanel : TSBSPanel; FormStuff : TFormStuff; iPage : Integer);
{attach this to the MouseUp event of all column headers and all columns}
var
  iBarPos :  Integer;
  bPanResized :  Boolean;
  iTitlePanRightOffSet : integer;
begin
  {resizes columns / moves columns}
  with FormStuff do begin
    SetSBMainScrollBar(aMULCtrlO[iPage], asbMain[iPage]);
    iTitlePanRightOffSet := -2;
    with ThePanel do begin
      if Width < 20 then Width := 20; {traps disappearing columns}
      bPanReSized := ReSized;
      iBarPos := asbMain[iPage].HorzScrollBar.Position;
      If (bPanResized) then aMULCtrlO[iPage].ResizeAllCols(aMULCtrlO[iPage].VisiList.FindxHandle(ThePanel),iBarPos); {Resizes & Moves all the appropriate panels when you resize a column}
      aMULCtrlO[iPage].FinishColMove(iBarPos + (iTitlePanRightOffSet * Ord(bPanReSized)),bPanResized); {Resizes the title panel when you resize a column}
    end;{with}

    if bPanResized and ((TSBSPanel(TVisiRec(aMULCtrlO[iPage].visilist.List[0]^).PanelObj).Height)
    <> (asbMain[iPage].ClientHeight - 31)) then begin
      TSBSPanel(TVisiRec(aMULCtrlO[iPage].visilist.List[0]^).PanelObj).Height := asbMain[iPage].ClientHeight - 31; {Resizes column 1 to fit scroll box}
      aMULCtrlO[iPage].RefreshAllCols; {Resizes all columns to match column 1}
    end;{if}
  end;{with}
end;

//-----------------------------------------------------------------------

function SetSBMainScrollBar(MULCtrlO : TMULCtrl; sbMain : TScrollBox): boolean;
{shows / hides the horizontal scrollbar of the main scrollbox, as appropriate}
var
  iCol, iTotalWidth, iLastColumn : integer;
  bPrevState : boolean;
begin
  bPrevState := sbMain.HorzScrollBar.Visible;
  iLastColumn := MULCtrlO.visilist.Count - 1;
  iTotalWidth := 0;
  For iCol := 0 to iLastColumn do iTotalWidth := iTotalWidth + TSBSPanel(TVisiRec(MULCtrlO.visilist.List[iCol]^).PanelObj).Width + 4;
  sbMain.HorzScrollBar.Visible := (iLastColumn >= 0) and
  ((TSBSPanel(TVisiRec(MULCtrlO.visilist.List[iLastColumn]^).PanelObj).Left
  + TSBSPanel(TVisiRec(MULCtrlO.visilist.List[iLastColumn]^).PanelObj).Width > sbMain.Clientwidth)
  or (iTotalWidth > sbMain.Clientwidth));
  sbMain.VertScrollBar.Visible := FALSE;
  Result := bPrevState <> sbMain.HorzScrollBar.Visible;
end;

//-----------------------------------------------------------------------

procedure FormColourProperties(TheForm : TForm; var bSetDefaults : boolean; sCaption : string);
// Shows the dialog box allowing you to change the Colours & Fonts
// of a form outside the area of Btrieve list - works with Text8Pt controls
var
  TmpPanel : array[1..3] of TPanel;
  BeenChange : Boolean;
  ColourCtrl : TCtrlColor;
  CompNum : integer;
  Found : boolean;
  iPos : integer;
begin
  bSetDefaults := FALSE;
  for iPos := 1 to 3 do TmpPanel[iPos] := TPanel.Create(TheForm);

  try
    {read in current colors}
    Found := false;
    CompNum := 0;
    while (CompNum < TheForm.ComponentCount) and not Found do
    begin
      Found := TheForm.Components[CompNum] is Text8Pt;
      if not Found then
        inc(CompNum);
    end;

    TmpPanel[1].Font.Assign((TheForm.Components[CompNum] as Text8Pt).Font);
    TmpPanel[1].Color := (TheForm.Components[CompNum] as Text8Pt).Color;

    TmpPanel[2].Font.Assign(TheForm.Font);
    TmpPanel[2].Color := TheForm.Color;

    TmpPanel[3].Color := TheForm.Color;
    TmpPanel[3].Font.Assign(TheForm.Font);
    TmpPanel[3].Font.Color := TheForm.Font.Color;

    try
      ColourCtrl := TCtrlColor.Create(TheForm);
      with ColourCtrl do
      begin
        // Show colour change dialog
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],0,sCaption,BeenChange,bSetDefaults);
        if (BeenChange) and (not bSetDefaults) then
        begin // Change colours
          for CompNum := 0 to TheForm.ComponentCount - 1 do
          begin
            if TheForm.Components[CompNum] is Text8Pt then
              with (TheForm.Components[CompNum] as Text8Pt) do
              begin
                Font.Assign(TmpPanel[1].Font);
                Color := TmpPanel[1].Color;
              end;
          end;
          TheForm.Color := TmpPanel[2].Color
        end; // If change colours
      end;{with}
    finally
      ColourCtrl.Free;
    end;{try}
  finally
    for iPos := 1 to 3 do TmpPanel[iPos].Free;
  end;{try}
  if bSetDefaults then TheForm.Close;
end;

//-----------------------------------------------------------------------

procedure StoreJustFormCoord(TheForm : TForm; SampleField : Text8Pt;
  bStoreCoord, bSetDefaults, bLastCoord : Boolean; acPrimeKey : char; StoreForm : boolean);
// Notes : Use this routine to save information about fields etc on a form which are
//         separate to a Btrieve list.
// Pre   : Set StoreForm to false if a BtrieveList also exists as the main form details
//         will be saved by this code
var
  GlobComp:  TGlobCompRec;
begin
  new(GlobComp,Create(false));
  with GlobComp^ do
  begin
    GetValues := not bSetDefaults;
    PrimeKey := acPrimeKey;
    ColOrd:=Ord(bStoreCoord);
    HLite:=Ord(bLastCoord);
    SaveCoord:=bStoreCoord;

    If (Not bLastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    if StoreForm then
      StorebtControlCsm(TheForm);
    StorebtControlCsm(SampleField);
  end;
  dispose(GlobComp,Destroy);
end;

//-----------------------------------------------------------------------

procedure FindJustFormCoord(TheForm : TForm; SampleField : Text8Pt;
  bStoreCoord, bSetDefaults, bLastCoord : Boolean; acPrimeKey : char; ReadForm : boolean);
var
  GlobComp:  TGlobCompRec;
  CompNum : integer;
begin
  new(GlobComp,Create(true));
  with GlobComp^ do
  begin
    GetValues := true;
    PrimeKey := acPrimeKey;

    if (GetbtControlCsm(TheForm)) and ReadForm then
    begin
      bStoreCoord := (ColOrd=1);
      HasCoord := (HLite=1);
      bLastCoord := HasCoord;

      if (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(TheForm);
    end;

    GetbtControlCsm(SampleField);

    for CompNum := 0 to TheForm.ComponentCount - 1 do
    begin
      if TheForm.Components[CompNum] is Text8Pt then
      with (TheForm.Components[CompNum] as Text8Pt) do
      begin
        Font.Assign(SampleField.Font);
        Color := SampleField.Color;
      end;
    end;

  end; {With GlobComp..}
  dispose(GlobComp,Destroy);
end;
  (*
  // Check form is within current visible range

  with TheForm.Owner do
    VisibleRect := Rect(0,0,ClientWidth,ClientHeight);

  If (Not PtInRect(VisibleRect,Point(Left,Top))) then
  Begin
    Left:=0;
    Top:=0;
  end;
end; *)

end.
