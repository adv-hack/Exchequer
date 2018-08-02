unit SelDataF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FuncList, StdCtrls, TEditVal, Menus, ExtCtrls, SBSPanel,
  GlobVar,       // Exchequer Global Const, Type & Var
  VarConst,      // Exchequer Global Const, Type & Var
  VarRec2U,      // Additional Exchequer Global Const, Type & Var
  SBSComp,       // Btrieve List Routines
  SupListU,      // Btrieve List Classes (TGenList)
  SBSComp2,      // Routines for Loading/Saving Window Colours/Co-Ordinates
  BTSupU1,       // Misc Messages and Btrieve Funcs
  BTSupU3,       // Misc Global Record Structures  (TReturnCtrlRec)
  SelDataO, ComCtrls;      // Btrieve List Objects for Select Data window

type
  TfrmSelectData = class(TForm)
    PageControl: TPageControl;
    SearchPage: TTabSheet;
    GFScrollBox: TScrollBox;
    GFLabPanel: TSBSPanel;
    GFAccLab: TSBSPanel;
    GFCompLab: TSBSPanel;
    GFBalLab: TSBSPanel;
    GFAccPanel: TSBSPanel;
    GFCompPanel: TSBSPanel;
    GFBalPanel: TSBSPanel;
    GFListBtnPanel: TSBSPanel;
    btnFind: TButton;
    btnClose: TButton;
    Panel1: TPanel;
    Label81: Label8;
    Label82: Label8;
    cmbSearchFor: TSBSComboBox;
    cmbSearchBy: TSBSComboBox;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    procedure btnFindClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure GFAccLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GFAccLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure GFAccLabMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FFoundText  : ShortString;
    FSelectType : TDataSelectType;
    GotCoord    : Boolean;
    InitSize    : TPoint;
    ListOffset   : Integer;
    NeedCUpdate : Boolean;

    PagePoint   : array[1..3] of TPoint;

    OwnList     : TGenList;           // Generic Ancestor of Btr Lists objects to hold specific data object for list
    ReturnCtrl  : TReturnCtrlRec;     // Structure containing config details for search
    OKey2F      : Str255;             // Text we are searching for
    OKLen       : SmallInt;
    OFnum       : SmallInt;

    Procedure WMFindFindRec(Var Message  :  TMessage); message WM_CustGetRec;
    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;

    function  GetSearchText: ShortString;
    procedure SetSearchText(const Value: ShortString);
    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    procedure PrimeSearchBy;
  protected
  public
    { Public declarations }
    procedure Initialise(SelType: TDataSelectType);
    property FoundText : ShortString read FFoundText;
    property SearchText : ShortString read GetSearchText write SetSearchText;
    property SelectType: TDataSelectType read FSelectType write FSelectType;
  end;

implementation

{$R *.dfm}

Uses EtStrU,
     ETMiscU,
     BtrvU2,
     BTKeys1U;

Const
  cmbAnyFieldText = 'Any Field';
  StopModeCaption = 'Sto&p';
  FindModeCaption = '&Find Now';

Var
  // Array contains a StringList for each dialog which contains
  // the searches that have been done during the lifetime of this
  // instance of the Drill-Down COM Server
  SearchMemList : Array [TDataSelectType] Of TStringList;


//=========================================================================

procedure TfrmSelectData.FormResize(Sender: TObject);
Begin { FormResize }
  If GotCoord then
  Begin
    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    GFScrollBox.Width     := Width  - (InitSize.X - 375);
    GFScrollBox.Height    := Height - (InitSize.Y - 149);
    GFListBtnPanel.Left   := Width  - (InitSize.X - 385);
    GFListBtnPanel.Height := Height - (InitSize.Y - 122);

    PageControl.Width     := Width  - (InitSize.X - 415);
    PageControl.Height    := Height - (InitSize.Y - 262);

    If (Assigned(OwnList)) then
    Begin
      OwnList.LinkOtherDisp := BOff;

      with OwnList.VisiList do
      begin
        VisiRec := List[0];
        with (VisiRec^.PanelObj as TSBSPanel) do
          Height:= GFScrollBox.ClientHeight - PagePoint[3].Y;
      end; { With OwnList.VisiList  }

      With OwnList do
      Begin
        ReFresh_Buttons;

        RefreshAllCols;
      end;{Loop..}

      OwnList.LinkOtherDisp:=BOn;
    end;
  End; { If GotCoord }
End; { FormResize }

//-------------------------------------------------------------------------

Procedure TfrmSelectData.WMFindFindRec(Var Message : TMessage);
Begin
  With Message do
    If (WParam = 0) Then Begin
      // 0 = dbl click on line - Return selected code and close dialog
      Case FSelectType Of
        dstCostCentre,
        dstDepartment  : FFoundText := Password.CostCtrRec.PCostC;

        dstCustomer,
        dstSupplier    : FFoundText := Cust.CustCode;

        dstGLCode      : FFoundText := IntToStr(Nom.NomCode);

        dstLocation    : FFoundText := MLocCtrl.MLocLoc.loCode;

        dstStock       : FFoundText := Stock.StockCode;

        dstJob         : FFoundText := JobRec.JobCode;

        dstEmployee    : FFoundText := JobMisc.EmplRec.EmpCode;

        dstAnalysis    : FFoundText := JobMisc.JobAnalRec.JAnalCode;

        dstJobType     : FFoundText := JobMisc.JobTypeRec.JobType;
      Else
        Raise Exception.Create('TfrmSelectData.WMFindFindRec: Unhandled Data Selection Type whilst returning selected data')
      End; { Case FSelectType }
      FFoundText := Trim(FFoundText);
      ModalResult := mrOk;
    End { If (WParam = 0) }
    Else Begin
{$IFDEF DRILLDEBUG}
      Caption := 'Msg (WParam=' + IntToStr(WParam)+ ') at ' + FormatDateTime('HH:MM.ss', Now);
{$ENDIF}
    End; { Else }

  Inherited;
end;


//-------------------------------------------------------------------------

// IMPORTANT NOTE: This message handler is required to ensure the form stays
// on top, as it has a habit of losing its Stay-On-Top'ness at runtime.
procedure TfrmSelectData.WMWindowPosChanged(var Msg : TMessage);
Var
  TopWindow : TWinControl;
Begin
  // Do standard message processing
  Inherited;

  // HM 22/10/03: Added Visible check as it hangs under win 98 otherwise
  If Self.Visible Then
  Begin
    // Check to see if the TopMost window is a Drill-Down window
    TopWindow := FindControl(PWindowPos(Msg.LParam).hwndInsertAfter);
    If Not Assigned(TopWindow) Then
      // Restore TopMost back to window
      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);
  End; // If Self.Visible
End;

//-------------------------------------------------------------------------

// Loads the correct search options into the Search By list for the current mode
procedure TfrmSelectData.PrimeSearchBy;

  //------------------------------

  // Safely typecasts the Method enum so that it can be added into the list
  Procedure LoadItem (Const ItemText : ShortString; Const IndexNo : Byte);
  Var
    LI : LongInt;
  Begin { LoadItem }
    LI := IndexNo;
    cmbSearchBy.Items.AddObject (ItemText, Pointer(LI));
  End; { LoadItem }

  //------------------------------

  procedure FormSetOffSet;
  begin { FormSetOfSet }
    // Record co-ordinates for resizing the main scrollbox containing the Btrieve list
    PagePoint[1].X := ClientWidth - (GFScrollBox.Width);
    PagePoint[1].Y := ClientHeight - (GFScrollBox.Height);

    // Record co-ordinates for resizing the btrieve up/down button panel
    PagePoint[2].X := ClientWidth - GFListBtnPanel.Left;
    PagePoint[2].Y := ClientHeight - GFListBtnPanel.Height;

    // Record co-ordinates for resizing the btrieve list panels within the scrollbox
    PagePoint[3].Y := GFScrollBox.ClientHeight - GFACCPanel.Height;

    GotCoord := True;
  end; { FormSetOfSet }

  //------------------------------

  procedure CreateOwnList;
  var
    StartPanel : TSBSPanel;
    n          : Integer;
  begin { CreateOwnList }
    try
      with OwnList do
      begin
        try
          YieldMessage := BOn;
          with VisiList do
          begin
            AddVisiRec (GFAccPanel,  GFAccLab);
            AddVisiRec (GFCompPanel, GFCompLab);
            AddVisiRec (GFBalPanel,  GFBalLab);

            VisiRec := List[0];

            StartPanel := (VisiRec^.PanelObj as TSBSPanel);
          end; { With VisiList  }
        except
          VisiList.Free;
          { Attempting to carry on will cause multiple errors, so... }
          raise;
        end;

        VisiList.LabHedPanel := GFLabPanel;

        TabOrder := -1;
        TabStop := BOff;
        Visible := BOff;
        BevelOuter := bvNone;
        ParentColor := False;
        Color := StartPanel.Color;
        MUTotCols := 2;
        Font := StartPanel.Font;

        LinkOtherDisp:=BOn;

        WM_ListGetRec:=WM_CustGetRec;

        Parent:=StartPanel.Parent;

        MessHandle:=Self.Handle;

        For n:=0 to MUTotCols do
          With ColAppear^[n] Do Begin
            AltDefault:=BOn;

            If (n=2) Then Begin
              // Change format of column 3
              If (FSelectType In [dstCustomer, dstSupplier]) then
              Begin
                DispFormat:=SGFloat;

                Case FSelectType of
                  dstCustomer,
                  dstSupplier   : NoDecPlaces := 2;
                Else
                  Raise Exception.Create('TfrmSelectData.PrimeSearchBy.CreateOwnList: Unhandled Data Type when setting Decimals')
                End; {Case..}
              End { If (FSelectType In ... }
              Else
                If (FSelectType In [dstCostCentre, dstDepartment,
                                    dstJob, dstEmployee, dstAnalysis,
                                    dstJobType]) then
                  // Hide caption
                  GFBalLab.Caption := '';
            End; { If (n=2) }
          End; { With ColAppear^[n] }

        ListCreate;

        AbortOnEmpty:=BOn;

        Set_Buttons(GFListBtnPanel);

        ScanFileNum:=1;
      end; { With OwnList }
    except
      OwnList.Free;
      OwnList := nil;
    end;

    FormSetOffSet;

    FormReSize(Self);
  End; { CreateOwnList }

  //------------------------------

Begin { PrimeSearchBy }
  // Remove any pre-existing items
  cmbSearchBy.Items.Clear;

  // Load the Search By methods
  Case FSelectType Of
    dstCostCentre,
    dstDepartment  : Begin
                       LoadItem ('Code',          PWK);
                       LoadItem ('Description',   HelpNdxK);

                       // Set the File to process
                       OFnum := PwrdF;

                       // Create the Cost Centre/Department List object
                       OwnList := TSDCCDpList.Create(Self);
                       CreateOwnList;
                     End;

    dstCustomer,
    dstSupplier    : Begin
                       LoadItem ('Account Code',      ATCodeK);
                       LoadItem ('Account Name',      ATCompK);
                       LoadItem ('Alt Code',          ATAltK);
                       LoadItem ('Tax Code',          CustCntyK);
                       LoadItem ('Phone No.',         CustTelK);
                       LoadItem ('Post Code',         CustPCodeK);
                       LoadItem ('Their Code for us', CustRCodeK);
                       LoadItem ('Invoice To',        CustInvToK);
                       LoadItem ('Email Addr',        CustEmailK);
                       LoadItem (cmbAnyFieldText,     ATCodeK);

                       // Set the File to process
                       OFnum := CustF;

                       // Create the Customer/Supplier List object
                       OwnList := TSDCustList.Create(Self);
                       CreateOwnList;
                     End;

    dstGLCode      : Begin
                       LoadItem ('GL Code',           NomCodeK);
                       LoadItem ('GL Description',    NomDescK);
                       LoadItem ('Alt Code',          NomAltK);

                       GFAccLab.Caption  := 'GL Code';
                       GFCompLab.Caption := 'Description';
                       GFBalLab.Caption  := 'Alt Code';         GFBalLab.Alignment := taLeftJustify;

                       // Set the File to process
                       OFnum := NomF;

                       // Create the GL List object
                       OwnList := TSDGLList.Create(Self);
                       CreateOwnList;
                     End;

    dstLocation    : Begin
                       LoadItem ('Code',          MLK);
                       LoadItem ('Description',   MLSecK);

                       GFBalLab.Caption  := 'Address';         GFBalLab.Alignment := taLeftJustify;

                       // Set the File to process
                       OFnum := MLocF;

                       // Create the Location List object
                       OwnList := TSDLocList.Create(Self);
                       CreateOwnList;
                     End;


    dstStock       : Begin
                       LoadItem ('Stock Code',        StkCodeK);
                       LoadItem ('Description',       StkDescK);
                       LoadItem ('Alt Code',          StkAltK);
                       LoadItem ('Bar Code',          StkBarCK);
                       //LoadItem ('Alt Code Database', NomAltK);   HOW????
                       LoadItem (cmbAnyFieldText,     StkCodeK);

                       GFAccLab.Caption  := 'Stock Code';
                       GFCompLab.Caption := 'Description';
                       GFBalLab.Caption  := 'Alt Code';         GFBalLab.Alignment := taLeftJustify;

                       // Set the File to process
                       OFnum := StockF;

                       // Create the Stock List object
                       OwnList := TSDStkList.Create(Self);
                       CreateOwnList;
                     End;
    dstJob         : begin
                       LoadItem('Job Code', JobCodeK);
                       LoadItem('Job Description', JobDescK);
                       LoadItem('Alt Code', JobAltK);
                       LoadItem (cmbAnyFieldText, JobCodeK);
                       GFAccLab.Caption := 'Job Code';
                       GFCompLab.Caption := 'Description';
                       GFBalLab.Caption := 'Alt Code';
                       GFBalLab.Alignment := taLeftJustify;

                       OFNum := JobF;

                       OwnList := TSDJobList.Create(self);
                       CreateOwnList;
                     end;
    dstEmployee    : begin
                       LoadItem('Employee Code', JMK);
                       LoadItem('Surname', JMSecK);
                       LoadItem (cmbAnyFieldText, JMK);
                       GFAccLab.Caption := 'Code';
                       GFCompLab.Caption := 'Name';
                       GFBalLab.Caption := '';
//                       GFBalLab.Alignment := taLeftJustify;

                       OFNum := JMiscF;

                       OwnList := TSDEmployeeList.Create(self);
                       CreateOwnList;
                     end;
    dstAnalysis    : begin
                       LoadItem('Analysis Code', JMK);
                       LoadItem('Name', JMSecK);
                       LoadItem (cmbAnyFieldText, JMK);
                       GFAccLab.Caption := 'Code';
                       GFCompLab.Caption := 'Name';
                       GFBalLab.Caption := '';
//                       GFBalLab.Alignment := taLeftJustify;

                       OFNum := JMiscF;

                       OwnList := TSDAnalysisList.Create(self);
                       CreateOwnList;
                     end;
    dstJobType     : begin
                       LoadItem('Job Type Code', JMK);
                       LoadItem('Job Type Name', JMSecK);
                       LoadItem (cmbAnyFieldText, JMK);
                       GFAccLab.Caption := 'Code';
                       GFCompLab.Caption := 'Name';
                       GFBalLab.Caption := '';
//                       GFBalLab.Alignment := taLeftJustify;

                       OFNum := JMiscF;

                       OwnList := TSDJobTypeList.Create(self);
                       CreateOwnList;
                     end;
  else
    Raise Exception.Create ('TfrmSelectData.PrimeSearchBy - Unhandled SelectType whilst initialising the Search By list');
  end; { Case FSelectType }

  // Select the first method automatically
  if (cmbSearchBy.Items.Count > 0) Then
    cmbSearchBy.ItemIndex := 0;

  // Load the remembered search items
  cmbSearchFor.Items.Assign(SearchMemList[FSelectType]);


End; { PrimeSearchBy }

//-------------------------------------------------------------------------

procedure TfrmSelectData.btnFindClick(Sender: TObject);
Var
  ValidError : Boolean;

  //------------------------------

  function TxlateKey (Const IText : Str255; Var VError : Boolean) : Str255;
  Var
    KeyS          : Str255;
    Code, ErrCode : Integer;
    lStatus       : SmallInt;
  Begin { TxlateKey }
    VError := False;

    Case FSelectType Of
      dstCostCentre,
      dstDepartment  : Result := PartCCKey (CostCCode, CSubCode[FSelectType = dstCostCentre]) + UpCaseStr(IText);

      dstCustomer,
      dstSupplier    : Case cmbSearchBy.ItemIndex Of
                         0..3, 8 : Result := TradeCode[FSelectType = dstCustomer] + UpCaseStr(IText);
                       Else
                         Result:=UpCaseStr(IText);
                       End; { Case cmbSearchBy.ItemIndex }

      dstGLCode      : If (cmbSearchBy.ItemIndex = 0) Then Begin
                         // GL Code - Extract number from text and build search
                         If (Trim(cmbSearchFor.Text) <> '') Then Begin
                           Val (cmbSearchFor.Text, Code, ErrCode);
                           If (ErrCode = 0) Then Begin
                             // Try to load GL Record
                             KeyS := FullNomKey(Code);
                             lStatus := Find_Rec(B_GetEq, F[NomF], NomF, RecPtr[NomF]^, NomCodeK, KeyS);
                             If (lStatus = 0) And (Nom.NomCode = Code) Then Begin
                               // Got Record - update Excel and close search window
                               FFoundText := IntToStR(Nom.NomCode);
                               VError := True;
                               PostMessage(Handle,WM_Close, 0, 0);
                             End { If (lStatus = 0) And (Nom.NomCode = Code) }
                             Else Begin
                               MessageDlg ('Invalid GL Code', mtError, [mbOk], 0);
                               VError := True;
                             End { Else }
                           End { If (ErrCode = 0) }
                           Else
                             VError := True;
                         End { If (Trim(cmbSearchFor.Text) <> '') }
                         Else
                           Result := '';
                       End { If (cmbSearchBy.ItemIndex = 0) }
                       Else
                         Result := UpCaseStr(IText);

      dstLocation    : Result := PartCCKey (CostCCode, CSubCode[True]) + UpCaseStr(IText);

      dstStock       : Result:=UpCaseStr(IText);

      dstJob         : Result := UpCaseStr(IText);

      dstEmployee    : Result := JARCode + JAECode + Trim(UpCaseStr(IText));

      dstAnalysis    : Result := JARCode + JAACode + Trim(UpCaseStr(IText));

      dstJobType     : Result := JARCode + JATCode + Trim(UpCaseStr(IText));
//      Serial, Job
//           :  Result:=UpCaseStr(IText);
    Else
      Raise Exception.Create ('TfrmSelectData.btnFindClick.TxlateKey - Unhandled Data Type');
    End; { Case FSelectType }
  End; { TxlateKey }

  //------------------------------

  procedure SetListFilters;
  Begin { SetListFilters }
    If Assigned(OwnList) then
      With OwnList do
        Case FSelectType Of
          dstCustomer,
          dstSupplier    : Filter[1,0] := TradeCode[FSelectType = dstCustomer];
        End; {Case..}
  End; { SetListFilters }

  //------------------------------

  Function StartLookup (Const AdvanceMode : Boolean) : Boolean;
  Var
    SKPath  :  Integer;
  Begin { StartLookup }
    With OwnList Do Begin
      SKPAth := LongInt(cmbSearchBy.Items.Objects[cmbSearchBy.ItemIndex]);

      StartList(OFnum,SKPath,OKey2F,OKey2F,OKey2F,OKLen,AdvanceMode);

      If AdvanceMode then
        Result:=GetCode(0)
      else
        Result:=Not ExitScan;
    end;
  End; { StartLookup }

  //------------------------------

begin
  {$BOOLEVAL OFF}
  if (btnFind.Caption = FindModeCaption) then
  begin
    btnFind.Caption := StopModeCaption;
    try
      If (Not Assigned(OwnList)) Or (Not OwnList.InListFind) Then
      Begin
        // Extract the Search info from the dialog
        With cmbSearchFor Do Begin
          // Extract the text to look for and cache it up for later searches
          If (Items.Indexof(Text)=-1) then
            Items.Insert(0,Text);
          SearchMemList[FSelectType].Assign(cmbSearchFor.Items);

          // Setup the search information for the btrieve list
          OKey2F := TxlateKey(Strip('B',[#32],Text), ValidError);
          ReturnCtrl.SearchKey := OKey2F;

          // Extract the index number from the SearchBy Combo
          ReturnCtrl.SearchPath := LongInt(cmbSearchBy.Items.Objects[cmbSearchBy.ItemIndex]);
        End; { With cmbSearchBy }

        If (Not ValidError) Then
          With ReturnCtrl Do
            If ((Not Pass2Parent) or ShowOnly) Then
              With OwnList Do Begin
                // Set the UserWildCard flag for an Any Field search
                UseWildCard := (cmbSearchBy.Text = cmbAnyFieldText);

                If UseWildCard Then Begin
                  // Any Field Search: Change the filtering mechanism
                  Filter[1,1] := NdxWeight;
                  KeyWildM := WildCha + OKey2F;
                  OKey2F := '';
                End { If UseWildCard }
                Else
                  With OwnList Do Begin
      // HM 11/02/03: Not searching on Invoices at this time
      //                Case OFnum of
      //                  InvF  :  Begin
      //                             If (NdxTxlate[GFCombo2.ItemIndex]=InvYrRefK) or (NdxTxlate[GFCombo2.ItemIndex]=InvLYRefK) then
      //                               Filter[1,1]:=NDXWeight;
      //                           end;
      //                end; {Case..}
                  end;

                // Setup additional filters for data type
                SetListFilters;

                OKLen := Length(OKey2F);

                // Initialise and then load the list
                StartLookUp(BOn);
                If StartLookUp(BOff) And (MUListBoxes[0].CanFocus) Then
                  MUListBoxes[0].SetFocus
              End { With OwnList }
            Else
              //CtrlShowRecord(0, 0);
              Raise Exception.Create ('TfrmSelectData.btnFindClick: CtrlShowRecord Not Supported');
      End; { If (Not Assigned(OwnList)) Or (Not OwnList.InListFind) }
    finally
      btnFind.Caption := FindModeCaption;
    end;
  end
  else
  begin
    if (Assigned(OwnList)) then
      with OwnList do
      begin
        IRQSearch := not IRQSearch;
        btnFind.Caption := FindModeCaption;
        if (not IRQSearch) then
          PageUpDn(MUListBoxes[0].Row,BOn);
      end; {With..}
  end;
end;

//-------------------------------------------------------------------------

procedure TfrmSelectData.btnCloseClick(Sender: TObject);
begin
  {$B-}
  If ((Not Assigned(OwnList)) or (Not OwnList.InListFind)) and (Not ReturnCtrl.InFindLoop) then
    Close
end;

//-------------------------------------------------------------------------

function TfrmSelectData.GetSearchText: ShortString;
begin
  Result := cmbSearchFor.Text;
end;

procedure TfrmSelectData.SetSearchText(const Value: ShortString);
begin
  If (Value <> cmbSearchFor.Text) Then
    cmbSearchFor.Text := Value;
end;

//-------------------------------------------------------------------------

procedure TfrmSelectData.GFAccLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;
begin
  If (Sender is TSBSPanel) and (Assigned(OwnList)) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      OwnList.VisiList.PrimeMove(Sender);
      NeedCUpdate:=BOn;
    end
    else
      If (Button=mbRight) then
      Begin
        ListPoint:=ClientToScreen(Point(X,Y));

        ShowRightMeny(ListPoint.X,ListPoint.Y,0);
      end;

  end;
end;

//------------------------------

procedure TfrmSelectData.GFAccLabMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  If (Sender is TSBSPanel) and (Assigned(OwnList)) then
  With (Sender as TSBSPanel) do
  Begin
    OwnList.VisiList.MoveLabel(X,Y);
    NeedCUpdate:=OwnList.VisiList.MovingLab;
  end;
end;

//------------------------------

procedure TfrmSelectData.GFAccLabMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  BarPos    : Integer;
  PanRSized : Boolean;
begin
  if (Sender is TSBSPanel) and (Assigned(OwnList)) then
  with (Sender as TSBSPanel) do
  begin
    PanRSized:=Resized;

    If (PanRsized) then
      OwnList.ResizeAllCols(OwnList.VisiList.FindxHandle(Sender),0);

    BarPos:=GFScrollBox.HorzScrollBar.Position;

    OwnList.FinishColMove(BarPos + (ListOffset * Ord(PanRsized)), PanRsized);
    NeedCUpdate:=(OwnList.VisiList.MovingLab or PanRSized);
  end;
end;

//-------------------------------------------------------------------------

procedure TfrmSelectData.ShowRightMeny(X,Y,Mode  :  Integer);
Begin
  With PopUpMenu1 do
    PopUp(X,Y);
end;

//=========================================================================

Procedure InitFini (Const Init : Boolean);
Var
  I : TDataSelectType;
Begin { InitFini }
  For I := Low(SearchMemList) To High(SearchMemList) Do
    If Init Then
      SearchMemList[I] := TStringList.Create
    Else
      FreeAndNIL(SearchMemList[I]);
End; { InitFini }

//------------------------------

procedure TfrmSelectData.Initialise(SelType: TDataSelectType);
var
  N : SmallInt;
begin
  FSelectType := SelType;
  // Initialise scroll-bar positions
  For N := 0 To Pred(ComponentCount) Do
    If (Components[n] is TScrollBox) Then
      With TScrollBox(Components[N]) Do Begin
        VertScrollBar.Position := 0;
        HorzScrollBar.Position := 0;
      End; { With TScrollBox(Components[n]) }
  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  // Initialise Form Sizes
  InitSize.Y := 304;
  InitSize.X := 431;
  Self.Height := InitSize.Y;
  Self.Width  := InitSize.X;
  Constraints.MinHeight  := InitSize.Y - 1;
  Constraints.MinWidth   := InitSize.X;
  Constraints.MaxWidth   := InitSize.X;

  // Setup misc internal variables
  GotCoord := BOff;
  ListOffset := 10;
  NeedCUpdate := BOff;
  FFoundText := '';

  // Set Caption
  Case FSelectType Of
    dstCostCentre  : Caption := 'Select Cost Centre';
    dstCustomer    : Caption := 'Select Customer';
    dstDepartment  : Caption := 'Select Department';
    dstGLCode      : Caption := 'Select GL Code';
    dstLocation    : Caption := 'Select Location';
    dstStock       : Caption := 'Select Stock';
    dstSupplier    : Caption := 'Select Supplier';
    dstJob         : Caption := 'Select Job';
    dstEmployee    : Caption := 'Select Employee';
    dstAnalysis    : Caption := 'Select Analysis';
    dstJobType     : Caption := 'Select Job Type';
  Else
    Raise Exception.Create ('TfrmSelectData.Create - Unhandled SelectType setting Caption');
  End; { Case FSelectType }

  // Load the Search Options into the listbox
  PrimeSearchBy;

  // Position form so that the SearchFor field is positioned under the Mouse Pointer
  Top := Mouse.CursorPos.Y - (Height - ClientHeight) - (cmbSearchFor.Top + (cmbSearchFor.Height Div 2) - 5);
  If (Top < 0) Then Top := 0;
  If ((Top + Height) > Screen.Height) Then Top := Screen.Height - Height;

  Left := Mouse.CursorPos.X - (Width - ClientWidth) - (cmbSearchFor.Left + 20);
  If (Left < 0) Then Left := 0;
  If ((Left + Width) > Screen.Width) Then Left := Screen.Width - Width;

  btnFind.Caption := FindModeCaption;
end;

Initialization
  InitFini (True);
Finalization
  InitFini (False);
end.
