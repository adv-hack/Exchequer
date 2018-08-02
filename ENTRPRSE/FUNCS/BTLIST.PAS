unit BTList;

interface
uses
  {SupListU, CmpCtrlU, }Forms, SBSPanel, Windows, Controls, BTSupU1
  , Graphics, ExtCtrls, SBSComp2, SBSComp, Classes, GlobVar, SysUtils;
{, ColCtrlU}
type
  TColumnInfo = Record
    ColPanel : TSBSPanel;
    HeadPanel : TSBSPanel;
    DecPlaces : Byte;
  end;{TColumnInfo}

  TAllColumns = Array of Array of TColumnInfo;
  TPrimeKeys = Array of Char;

  TPoints = Record
    List : TPoint;
    BtnPanel : TPoint;
    ScrlPan : TPoint;
    ListPan : TPoint;
  end;{TPoints}

  TFormStuff = Class
    aColumns : TAllColumns;  // tabs / colums per pg
    aiKeys : Array of integer; // indexes per tab
    asStartKeys : Array of str255; // indexes per tab
    asEndKeys : Array of str255; // indexes per tab
    aFileNos : Array of integer; // custf per tab
    asbButtons : Array of TScrollBox; // scroll box for button panedl per t
    asbMain : Array of TScrollBox; // scroll box for main list per t
    aMULCtrlO : Array of TMULCtrl; // btrieve list per tab
    aPoints : Array of TPoints; // location coords for position - ignore internal
    apanScrollBar : Array of TSBSPanel; // arrow controls
    apanButtons : Array of TSBSPanel; // main button panel on right
    apanTitle : Array of TSBSPanel; // title panel all list column headers on this
    aCaseSensSearch : Array of boolean;
    // internal type stuff
    acPrimeKeys : TPrimeKeys; // colour weirdness
    bSetDefaults : boolean;  // colour weirdness
    bGotCoord : boolean;
    bLastCoord : boolean;
    bStoreCoord : boolean;
    bFillList : boolean;
    constructor Create(iNoOfPages : integer);
    destructor Destroy; override;
  end;{TFormStuff}

  procedure ReadFormProperties(TheForm : TForm; FormStuff : TFormStuff);
  procedure StoreFormProperties(TheForm : TForm; OpMode : Byte; bStoreCoord, bSetDefaults
  ,bLastCoord : Boolean; apanTitle : array of TSBSPanel; aMULCtrlO : array of TMULCtrl; acPrimeKey : TPrimeKeys);
{  procedure SetDefaultSize(TheForm : TForm; var Points : TPoints; iDefClientHeight, iDefClientWidth : integer);}
  procedure DoFormResize(TheForm : TForm; FormStuff : TFormStuff);
{  procedure ListProperties(TheForm : TForm; MULCtrlO : TMULCtrl; var bSetDefaults : boolean; sCaption : string);{Change List Colours}
  procedure DoMoveAlignCols(ThePanel : TSBSPanel; FormStuff : TFormStuff; iPage : Integer);
  function SetSBMainScrollBar(MULCtrlO : TMULCtrl; sbMain : TScrollBox): boolean;

implementation


{TFormStuff}

constructor TFormStuff.Create(iNoOfPages : integer);
begin
  inherited create;
  SetLength(aColumns,iNoOfPages);
  SetLength(aPoints,iNoOfPages);
  SetLength(aFileNos,iNoOfPages);
  SetLength(asbMain,iNoOfPages);
  SetLength(acPrimeKeys,iNoOfPages);
  SetLength(apanTitle,iNoOfPages);
  SetLength(asbButtons,iNoOfPages);
  SetLength(apanButtons,iNoOfPages);
  SetLength(aMULCtrlO,iNoOfPages);
  SetLength(apanScrollBar,iNoOfPages);
  SetLength(aiKeys,iNoOfPages);
  SetLength(asStartKeys,iNoOfPages);
  SetLength(asEndKeys,iNoOfPages);
  SetLength(aCaseSensSearch,iNoOfPages);
end;

destructor TFormStuff.Destroy;
var
  iPos : integer;
begin
  For iPos := 0 to High(aColumns) do SetLength(aColumns[iPos],0);
  SetLength(aColumns,0);
  SetLength(aPoints,0);
  SetLength(aFileNos,0);
  SetLength(asbMain,0);
  SetLength(acPrimeKeys,0);
  SetLength(apanTitle,0);
  SetLength(asbButtons,0);
  SetLength(apanButtons,0);

  For iPos := 0 to High(aMULCtrlO) do begin
    if aMULCtrlO[iPos] <> nil
    then freeandnil(aMULCtrlO[iPos]);
  end;{for}
  SetLength(aMULCtrlO,0);

  SetLength(apanScrollBar,0);
  SetLength(aiKeys,0);
  SetLength(asStartKeys,0);
  SetLength(asEndKeys,0);
  SetLength(aCaseSensSearch,0);

  inherited destroy;
end;


{*** Procedures ***}

procedure ReadFormProperties(TheForm : TForm; FormStuff : TFormStuff);
{Call this to read in the saved properties of your form (colours / position / size etc.}
var
{  GlobComp : TGlobCompRec;}
  iPos, iCol : integer;
  StartPanel : TSBSPanel;
begin
  {stores current co-ordinates of various components}
  with TheForm do begin
    with FormStuff do begin
      bGotCoord := FALSE;
      For iPos := 0 to High(aMULCtrlO) do begin
        with aPoints[iPos] do begin

          if assigned(asbMain[iPos]) then begin
            List.X := Width - asbMain[iPos].Width;
            List.Y := Height - asbMain[iPos].Height;
          end;{if}

          if apanButtons[iPos] <> nil then begin
            BtnPanel.X := Width - apanButtons[iPos].Left;
            if asbButtons[iPos] = nil then
            else BtnPanel.Y := apanButtons[iPos].Height - asbButtons[iPos].Height;
          end;{if}

          if apanScrollBar[iPos] <> nil then begin
            ScrlPan.X := Width - apanScrollBar[iPos].Left;
            ScrlPan.Y := Height - apanScrollBar[iPos].Height;
          end;{if}

          if aColumns[iPos,0].ColPanel <> nil then begin
            if assigned(asbMain[iPos])
            then ListPan.Y := asbMain[iPos].ClientHeight - aColumns[iPos,0].ColPanel.Height;
          end;{if}
        end;{with}
        bGotCoord := TRUE;

    (*    New(GlobComp,Create(TRUE));
        with GlobComp^ do begin
          GetValues := TRUE;
          PrimeKey := Chr(Ord(cPrimeKey) + 1 + OpMode);
          if (GetbtControlCsm(TheForm)) then begin
            bStoreCoord := (ColOrd = 1);
            HasCoord := (HLite = 1);
            bLastCoord := HasCoord;
            {Go get position, as it would not have been set initially}
            if (HasCoord) then SetPosition(TheForm);
          end;{if}
          GetbtControlCsm(panTitle);
        end;{with}
        Dispose(GlobComp,Destroy);*)

        if aMULCtrlO[iPos] <> nil then begin
          try
            {Setup List}
            with aMULCtrlO[iPos] do begin
              try
                with VisiList do begin
                  For iCol := 0 to High(aColumns[iPos])
                  do AddVisiRec(aColumns[iPos, iCol].ColPanel,aColumns[iPos, iCol].HeadPanel);
                  VisiRec := List[0];
                  StartPanel := (VisiRec^.PanelObj as TSBSPanel);
                  LabHedPanel := apanTitle[iPos];
                end;{with}
              except
                VisiList.Free;
              end;{try}

              {Get Coordinates/Colours}
      {        New(GlobComp,Create(TRUE));
              with GlobComp^ do begin
                GetValues := TRUE;
                PrimeKey := cPrimeKey;
                HasCoord := bLastCoord;
                Find_ListCoord(GlobComp);
              end;{with}
      {        Dispose(GlobComp, Destroy);}

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
              for iCol := 0 to MUTotCols do begin
                with ColAppear^[iCol] do begin
                  AltDefault := TRUE;
                  {Right Justifys Columns whose header panels are right justified}
                  if aColumns[iPos,iCol].HeadPanel.Alignment = taRightJustify then begin
                    DispFormat := SGFloat;
                    NoDecPlaces := aColumns[iPos,iCol].DecPlaces; {need to make this optional}
                  end;{if}
                end;{with}
              end;{if}
              ListLocal := nil;
              ListCreate;
              UseSet4End := FALSE;
              NoUpCaseCheck := aCaseSensSearch[iPos];{needs to be set to TRUE for integer searches}
              HighLiteStyle[1] := [fsBold];
              Set_Buttons(apanScrollBar[iPos]);
              Filter[1,0] := '';
              {$IFDEF TRADE}
                Filter[1,1] := #254;
{                NoUpCaseCheck := FALSE; {needs to be set to false for case insensitive searches}
              {$ENDIF}
              AbortOnEmpty := FALSE;{This turns off the message that there is nothing in the sublist}
              if bFillList then StartList(aFileNos[iPos],aiKeys[iPos],asStartKeys[iPos],''{asEndKeys[iPos]},'',Length(asStartKeys[iPos]),FALSE);
            end{with}
          except
            aMULCtrlO[iPos].Free;
            aMULCtrlO[iPos] := nil;
          end;{try}
        end;{if}
      end{for}
    end;{with}
  end;{with}
end;

procedure StoreFormProperties(TheForm : TForm; OpMode : Byte; bStoreCoord, bSetDefaults
,bLastCoord : Boolean; apanTitle : array of TSBSPanel; aMULCtrlO : array of TMULCtrl; acPrimeKey : TPrimeKeys);
{Call this to save the properties of your form (colours / position / size etc.}
var
{  GlobComp : TGlobCompRec;}
  iPos : SmallInt;
begin
  with TheForm do begin
    for iPos := 0 to Pred(ComponentCount) do begin
      if (Components[iPos] is TScrollBox) then begin
        with TScrollBox(Components[iPos]) do begin
          VertScrollBar.Position := 0;
          HorzScrollBar.Position := 0;
        end;{with}
      end;{if}
    end;{for}
    VertScrollBar.Position := 0;
    HorzScrollBar.Position := 0;

(*    New(GlobComp,Create(FALSE));
    with GlobComp^ do begin
      GetValues := not bSetDefaults;
      PrimeKey := Chr(Ord(cPrimeKey) + OpMode + 1);
      ColOrd := Ord(bStoreCoord);
      HLite := Ord(bLastCoord);
      SaveCoord := bStoreCoord;
      if (not bLastCoord) then HLite := ColOrd;{* Attempt to store last coord *}
      StorebtControlCsm(TheForm);
      StorebtControlCsm(panTitle);
      GetValues := not bSetDefaults;
      SaveCoord := bStoreCoord;
      PrimeKey := cPrimeKey;
      if Assigned(MULCtrlO) then MULCtrlO.Store_ListCoord(GlobComp);
    end;{with}
    Dispose(GlobComp,Destroy);*)
  end;{with}
end;

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

procedure DoFormResize(TheForm : TForm; FormStuff : TFormStuff);
{Attach this to the OnResize Event of your form}
var
  bScrollBarChanged, bHeightChanged : boolean;
  iPos : integer;
begin
  {resizes / positions all controls on the form when it is resized}
  with FormStuff do begin
    For iPos := 0 to High(aMULCtrlO) do begin
      if bGotCoord then begin
        with TheForm, aPoints[iPos] do begin
          {Resize scrollbar panel}
          if apanScrollBar[iPos] <> nil then begin
            apanScrollBar[iPos].Left := Width - ScrlPan.X;
            apanScrollBar[iPos].Height := Height - ScrlPan.Y;
          end;{if}

          {Resize main list ScrollBox}
          if assigned(asbMain[iPos]) then begin
            asbMain[iPos].Width := Width - List.X;
            bHeightChanged := asbMain[iPos].Height <> Height - List.Y;
            asbMain[iPos].Height := Height - List.Y;
          end;{if}

          {Reposition button panel}
          if apanButtons[iPos] <> nil then begin
            apanButtons[iPos].Left := Width - BtnPanel.X;
{            apanButtons[iPos].Height := (asbMain[iPos].Top + asbMain[iPos].Height) - apanButtons[iPos].Top;}
            apanButtons[iPos].Height := Height - List.Y;

            {Resize button ScrollBox within button panel}
            if asbButtons[iPos] <> nil then asbButtons[iPos].Height := apanButtons[iPos].Height - BtnPanel.Y;
          end;{if}
        end;{with}
      end;{if}

      if aMULCtrlO[iPos] <> nil then begin
        if assigned(asbMain[iPos])
        then bScrollBarChanged := SetSBMainScrollBar(aMULCtrlO[iPos], asbMain[iPos]);
        {Resize the list's columns}
        with aMULCtrlO[iPos], VisiList do begin
          if (List <> nil) and (bScrollBarChanged or bHeightChanged) then begin
            Refresh_Buttons; {Repositions the Scrollbar Buttons}
            VisiRec := List[0];
            if assigned(asbMain[iPos])
            then TSBSPanel(VisiRec^.PanelObj).Height := asbMain[iPos].ClientHeight - 31; {Resizes column 1 to fit scroll box}
            RefreshAllCols; {Resizes all columns to match column 1}
          end;{if}
        end;{with}
      end;{if}
    end;{for}
  end;{with}
end;

(*procedure ListProperties(TheForm : TForm; MULCtrlO : TMULCtrl; var bSetDefaults : boolean; sCaption : string);{Change List Colours}
{shows the dialog box allowing you to change the Colours & Fonts for your form}
var
  TmpPanel : array[1..3] of TPanel;
  iPos : integer;
  BeenChange : Boolean;
{  ColourCtrl : TCtrlColor;}
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
end;*)

procedure DoMoveAlignCols(ThePanel : TSBSPanel; FormStuff : TFormStuff; iPage : Integer);
{attach this to the MouseUp event of all column headers and all columns}
var
  iBarPos :  Integer;
  bPanResized :  Boolean;
  iTitlePanRightOffSet : integer;
begin
  {resizes columns / moves columns}
  with FormStuff do begin
    if assigned(asbMain[iPage]) then SetSBMainScrollBar(aMULCtrlO[iPage], asbMain[iPage]);
    iTitlePanRightOffSet := -2;
    with ThePanel do begin
      if Width < 20 then Width := 20; {traps disappearing columns}
      bPanReSized := ReSized;
      if assigned(asbMain[iPage]) then iBarPos := asbMain[iPage].HorzScrollBar.Position;
      If (bPanResized) then aMULCtrlO[iPage].ResizeAllCols(aMULCtrlO[iPage].VisiList.FindxHandle(ThePanel),iBarPos); {Resizes & Moves all the appropriate panels when you resize a column}
      aMULCtrlO[iPage].FinishColMove(iBarPos + (iTitlePanRightOffSet * Ord(bPanReSized)),bPanResized); {Resizes the title panel when you resize a column}
    end;{with}

    if bPanResized and ((TSBSPanel(TVisiRec(aMULCtrlO[iPage].visilist.List[0]^).PanelObj).Height)
    <> (asbMain[iPage].ClientHeight - 31)) and assigned(asbMain[iPage]) then begin
      TSBSPanel(TVisiRec(aMULCtrlO[iPage].visilist.List[0]^).PanelObj).Height := asbMain[iPage].ClientHeight - 31; {Resizes column 1 to fit scroll box}
      aMULCtrlO[iPage].RefreshAllCols; {Resizes all columns to match column 1}
    end;{if}
  end;{with}
end;

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

end.
