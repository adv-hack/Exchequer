unit FindReportF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, uMultiList, TCustom, ExtCtrls, ComCtrls,
  VirtualTrees, Menus, RptEngDLL;

type
  TReportFindMode = (afmReportName, afmReportDesc);

  TfrmFindReport = class(TForm)
    PageControl1: TPageControl;
    tabshSearch: TTabSheet;
    Panel1: TPanel;
    btnFindCancel: TSBSButton;
    btnGroupClose: TSBSButton;
    mulResults: TMultiList;
    Label81: Label8;
    cmbSearchFor: TSBSComboBox;
    Label82: Label8;
    cmbSearchBy: TSBSComboBox;
    PopupMenu1: TPopupMenu;
    popFormProperties: TMenuItem;
    PopupOpt_SepBar3: TMenuItem;
    popSavePosition: TMenuItem;
    procedure btnClose(Sender: TObject);
    procedure btnFindCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mulResultsRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure popFormPropertiesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    AbortSearch : Boolean;
    DoneRestore : Boolean;
    FCacheList : TStringList;
    FGroupCodeFilter : ShortString;  // Group Code filter for searching within groups
    FMode : TReportFindMode;
    FSelectedItem : ShortString;

    // Reference to report tree control so that the reports can be searched
    FRepTree : TVirtualStringTree;

    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    // Runs through the report tree loads any records matching FindKey into the results list
    procedure SearchTree(const FindKey : ShortString);

    // property Set method for CacheList - loads history items into the SearchFor combo
    procedure SetCacheList (const Value : TStringList);

    // Controls the loading/saving of the colours and positions
    //
    // Mode   0=Load Details, 1=Save Details, 2=Delete Details
    procedure SetColoursUndPositions (const Mode : Byte);

    // Control the minimum size that the form can resize to - works better than constraints
    procedure WMGetMinMaxInfo(var message  :  TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
  public
    { Public declarations }

    // reference to the StringList instance being used for caching previous searches
    property CacheList : TStringList read FCacheList write SetCacheList;

    property GroupCodeFilter : ShortString read FGroupCodeFilter write FGroupCodeFilter;

    // Controls data type being selected
    property Mode : TReportFindMode read FMode write FMode;

    // Reference to report tree outline control so that the reports can be searched,
    // this search will then include the security free of charge whereas searching
    // the data file directly won't.
    Property RepTree : TVirtualStringTree Read FRepTree Write FRepTree;

    // Text of selected item from the first column
    property SelectedItem : ShortString read FSelectedItem;
  end;

function FindReport(OwnerForm : TForm; ReportTree : TVirtualStringTree) : Boolean;

implementation

{$R *.dfm}

uses GlobVar, BtrvU2, ETStrU,
     SavePos,         // Object encapsulating the btrieve saveposition/restoreposition functions
     uSettings,       // Colour/Position editing and saving routines
     BTSupu1, BTKeys1U, BTSupu2,
     GlobalTypes;

const
  StopModeCaption = 'Sto&p';
  FindModeCaption = '&Find Now';

var
  // Cache of historical group searches done during this instance of the app
  LastReportSearchIdx   : SmallInt = 0;
  ReportSearchHistory   : TStringList;

//-------------------------------------------------------------------------

function FindNode(Tree: TVirtualStringTree; ParentNode: PVirtualNode;
  SearchFor: ShortString): PVirtualNode;
var
  VRWRec: ^TVRWReportDataRec;
  Node: PVirtualNode;
begin
  Result := Tree.GetFirstChild(ParentNode);
  while (Result <> nil) do
  begin
    VRWRec := Tree.GetNodeData(Result);
    if Uppercase(Trim(VRWRec^.rtRepName)) = Uppercase(Trim(SearchFor)) then
      { Found a matching entry. }
      Break
    else
    begin
      { Recursively search any child nodes }
      Node := FindNode(Tree, Result, SearchFor);
      if (Node <> nil) then
      begin
        Result := Node;
        Break;
      end;
    end;
    Result := Tree.GetNextSibling(Result)
  end;
end;

function FindReport(OwnerForm : TForm; ReportTree : TVirtualStringTree) : Boolean;
Var
  oNodeData            : ^TVRWReportDataRec;
  FoundNode            : PVirtualNode;
  iRepNode, TmpNodeIdx : LongInt;
Begin // FindReport
  With TfrmFindReport.Create(OwnerForm) Do
  Begin
    Try
      // Setup the link from the SearchFor field and the stringlist
      // of previous searches on the Report file
      CacheList := ReportSearchHistory;

      // Default to the last search used
      cmbSearchBy.ItemIndex := LastReportSearchIdx;

      // Link in the Report Tree outline control to act as the data source
      // for the search, this gives us the security checking free of charge.
      RepTree := ReportTree;

      Result := (ShowModal = mrOK);
      If Result Then
      Begin
        // Record the search mode used for next time
        LastReportSearchIdx := cmbSearchBy.ItemIndex;

        // Run through the Report Tree Nodes searching for matching report code
        FoundNode := FindNode(FRepTree, nil, SelectedItem);
        if (FoundNode <> nil) then
        begin
          RepTree.FocusedNode := FoundNode;
          RepTree.Selected[FoundNode] := True;
        end;

      End; // If Result
    Finally
      Free;
    End; // Try..Finally
  End; // With TfrmFindReport.Create(OwnerForm)
End; // FindReport

//=========================================================================

procedure TfrmFindReport.FormCreate(Sender: TObject);
begin
  btnFindCancel.Caption := FindModeCaption;
//  FGroupCodeFilter := '';
//  FSelectedItem := '';

  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := (Width - ClientWidth) + 385;        // take border sizing &
  MinSizeY := (Height - ClientHeight) + 240;      // captions into account

  // Load colours/positions/sizes/etc...
  DoneRestore := False;
  SetColoursUndPositions (0);
end;

//------------------------------

procedure TfrmFindReport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Save colours/positions/sizes/etc...
  SetColoursUndPositions (1);
end;

//------------------------------

procedure TfrmFindReport.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

//------------------------------

procedure TfrmFindReport.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

//-------------------------------------------------------------------------

// Control the minimum size that the form can resize to - works better than constraints
procedure TfrmFindReport.WMGetMinMaxInfo(var message : TWMGetMinMaxInfo);
begin // WMGetMinMaxInfo
  with message.MinMaxInfo^ do
  begin
    ptMinTrackSize.X:=MinSizeX;
    ptMinTrackSize.Y:=MinSizeY;
  end; // with message.MinMaxInfo^

  message.Result:=0;

  Inherited;
end; // WMGetMinMaxInfo

//-------------------------------------------------------------------------

// property Set method for CacheList - loads history items into the SearchFor combo
procedure TfrmFindReport.SetCacheList (const Value : TStringList);
begin // SetCacheList
  FCacheList := Value;
  cmbSearchFor.Items.Assign(FCacheList);
end; // SetCacheList

//-------------------------------------------------------------------------

procedure TfrmFindReport.btnFindCancelClick(Sender: TObject);
var
  OK : Boolean;
begin
  if (btnFindCancel.Caption = FindModeCaption) then
  begin
    // Find Mode - Validate the settings and do the search
    OK := (Trim(cmbSearchFor.Text) <> '');
    if (not OK) then
    begin
      MessageDlg('The ''''Search For'''' field must be set before a search can be started', mtError, [mbOK], 0);
      if cmbSearchFor.CanFocus then
      begin
        cmbSearchFor.SetFocus;
      end; // if cmbSearchFor.CanFocus
    end; // if (not OK)

    if OK then
    begin
      // Change the find button to a cancel button
      btnFindCancel.Caption := StopModeCaption;

      // Update the history cache if the string hasn't been used already
      if (cmbSearchFor.Items.IndexOf(cmbSearchFor.Text) = -1) then
      begin
        cmbSearchFor.Items.Insert(0, cmbSearchFor.Text);
        FCacheList.Assign(cmbSearchFor.Items);
      end; // if (cmbSearchFor.Items.IndexOf(cmbSearchFor.Text) = -1)

      // Clear the results list and then do the search
      FSelectedItem := '';
      AbortSearch := False;
      mulResults.ClearItems;

      // TReportFindMode = (afmReportName, afmReportDesc);
      FMode := TReportFindMode(cmbSearchBy.ItemIndex);

      // Run through the Report Tree Outline Nodes searching for matching data
      SearchTree(cmbSearchFor.Text);

//      case FMode of
//        afmReportName : begin
//                          SearchFile(ReportTreeF, TreeParentIDK, '', cmbSearchFor.Text);
//                      end;
//
//        afmReportDesc : begin
//                          SearchFile(ReportTreeF, TreeParentIDK, '', cmbSearchFor.Text);
//                        end;
//
//        afmAnything   : begin
//                          SearchFile(ReportTreeF, TreeParentIDK, '', cmbSearchFor.Text);
//                        end;
//      else
//        raise Exception.Create ('TfrmAdvancedFind.btnFindCancelClick: Unknown Mode');
//      end; // case FMode

      if (mulResults.ItemsCount > 0) then
      begin
        // Select first item in results list
        MulResults.Selected := 0;

        // Can't move focus to the list as that doesn't work properly!
      end; // if (mulResults.ItemsCount > 0)

      // Restore the find button back to a find button
      btnFindCancel.Caption := FindModeCaption;
    end; // if OK
  end // if (btnFindCancel.Caption = FindModeCaption)
  else
  begin
    if (btnFindCancel.Caption = StopModeCaption) then
    begin
      // Stop the search
      AbortSearch := True;
    end; // if (btnFindCancel.Caption = CancelModeCaption)
  end; // else
end;

//-------------------------------------------------------------------------

// Runs through the report tree loads any records matching FindKey into the results list
procedure TfrmFindReport.SearchTree(const FindKey : ShortString);

  //------------------------------

  // Copied from ETStrU and modified
  function Match_Glob(Fno         :  Integer;
                    Compare     :  Str30;
                var CompWith)  : Boolean;
  const
    WildChar  :  CharSet = ['?','*'];
  var
    n,Sn  :  Integer;
    Fok   :  Boolean;
    Found :  GenAry;
  begin
    n:=1; Sn:=1; Fok:=BOff;

    Blank(Found,Sizeof(Found));

    Move(CompWith,Found,Fno);

    while (n<=Fno) and (not Fok) do
    begin
      // HM: Added the OR section to support wildchars at the start, e.g. ?RAVO
      if (UpCase(Compare[1])=Upcase(Found[n])) or (Compare[1] In WildChar) then
      begin
        Sn:=1; Fok:=BOn;
        while (Sn<=Length(Compare)) and (Fok) do
        begin
          Fok:=((Upcase(Compare[Sn])=Upcase(Found[n+Sn-1])) or (Compare[Sn] In WildChar));
          Sn:=Succ(Sn);
        end; {while..}
      end;

      n:=Succ(n);
    end; {while..}
    Match_Glob:=Fok;
  end;

  //------------------------------
  procedure SearchNode(Tree: TVirtualStringTree; ParentNode: PVirtualNode);
  var
    VRWRec: ^TVRWReportDataRec;
    ChildNode, Node: PVirtualNode;
    Match: Boolean;
  begin
    ChildNode := Tree.GetFirstChild(ParentNode);
    while (ChildNode <> nil) do
    begin
      VRWRec := Tree.GetNodeData(ChildNode);
      case FMode Of
        afmReportName:
          begin
            Match := Match_Glob(Length(VRWRec^.rtRepName), FindKey, VRWRec^.rtRepName[1]);
            if Match then
            begin
              mulResults.DesignColumns[0].items.Add(Trim(VRWRec^.rtRepName));
              mulResults.DesignColumns[1].items.Add(Trim(VRWRec^.rtRepDesc));
            end; // if Match
          end;
        afmReportDesc:
          begin
            Match := Match_Glob(Length(VRWRec^.rtRepDesc), FindKey, VRWRec^.rtRepDesc[1]);
            if Match then
            begin
              mulResults.DesignColumns[0].items.Add(Trim(VRWRec^.rtRepName));
              mulResults.DesignColumns[1].items.Add(Trim(VRWRec^.rtRepDesc));
            end; // if Match
          end;
      End; // Case FMode
      { Recursively search any child nodes }
      SearchNode(Tree, ChildNode);

      ChildNode := Tree.GetNextSibling(ChildNode);

      // do this so that the user can click the 'Stop' button on longer searches, when
      // clicked the caption will
      Application.ProcessMessages;
      If AbortSearch Then
      Begin
        Break;
      End; // If AbortSearch

    end;
  end;


Begin // SearchTree
  // Run through the Report Tree Outline Nodes searching for matching data
  SearchNode(RepTree, nil);
End; // SearchTree

//-------------------------------------------------------------------------

procedure TfrmFindReport.btnClose(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

//-------------------------------------------------------------------------

// Row double-click - if something is selected then return that as
// the result of the search
procedure TfrmFindReport.mulResultsRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  FSelectedItem := mulResults.DesignColumns[0].Items[mulResults.Selected];
  ModalResult := mrOK;
end;

//-------------------------------------------------------------------------

// Controls the loading/saving of the colours and positions
//
// Mode   0=Load Details, 1=Save Details, 2=Delete Details
procedure TfrmFindReport.SetColoursUndPositions (const Mode : Byte);
var
  WantAutoSave : Boolean;
begin // SetColoursUndPositions
  case Mode of
    0 : begin
          oSettings.LoadForm (Self, WantAutoSave);
          popSavePosition.Checked := WantAutoSave;
          oSettings.LoadList (mulResults, Self.Name);
          oSettings.LoadParentToControl (tabshSearch.Name, Self.Name, cmbSearchFor);
          oSettings.ColorFieldsFrom (cmbSearchFor, Self);
        end;
    1 : if (not DoneRestore) then
        begin
          // Only save the details if the user didn't select Restore Defaults
          oSettings.SaveForm (Self, popSavePosition.Checked);
          oSettings.SaveList (mulResults, Self.Name);
          oSettings.SaveParentFromControl (cmbSearchFor, Self.Name, tabshSearch.Name);
        end; // if (not DoneRestore)
    2 : begin
          DoneRestore := True;
          oSettings.RestoreFormDefaults (Self.Name);
          oSettings.RestoreListDefaults (mulResults, Self.Name);
          oSettings.RestoreParentDefaults (tabshSearch, Self.Name);
          popSavePosition.Checked := False;
        end;
  else
    raise Exception.Create ('TfrmFindReport.SetColoursUndPositions - Unknown Mode (' + IntToStr(Ord(Mode)) + ')');
  end; // case Mode
end; // SetColoursUndPositions

//-------------------------------------------------------------------------

procedure TfrmFindReport.popFormPropertiesClick(Sender: TObject);
begin
  // Call the colours dialog
  case oSettings.Edit(mulResults, Self.Name, cmbSearchFor) of
    mrOK              : oSettings.ColorFieldsFrom (cmbSearchFor, Self);
    mrRestoreDefaults : SetColoursUndPositions (2);
  end; // case oSettings.Edit(...
end;

//-------------------------------------------------------------------------

procedure TfrmFindReport.FormResize(Sender: TObject);
begin
  LockWindowUpdate (Handle);

  // Resize Page Control
  PageControl1.Height := ClientHeight - 6;
  PageControl1.Width := clientWidth - 7;

  LockWindowUpdate (0);
end;

//-------------------------------------------------------------------------

initialization
  // Create and destroy the stringlist used for caching the previous
  // search strings.  Supress duplicates within the StringList
  ReportSearchHistory := TStringList.Create;
  ReportSearchHistory.Duplicates := dupIgnore;
finalization
  FreeAndNIL(ReportSearchHistory);
end.
