unit CardLstF;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

{$I DEFOVR.Inc}

{$F+}

uses
  Classes, Dialogs, Forms, Messages, SysUtils, Windows,
  Buttons, Controls, ExtCtrls, Graphics, Menus, StdCtrls, SBSPanel,
  TEditVal, ComCtrls, Tabnotbk,

  ETMiscU, GlobVar, VarConst, SBSComp, SBSComp2, ExWrap1U, BTSupU1,
  {ColCtrlU,} BtSupU2,
  //CmpCtrlU,

  {$IFDEF LTR}
    {Letters,}
  {$ENDIF}

  //CardRec,

  Grids;




type

 {=== Cust List ===}

  TCustList  =  Class(TMULCtrl)

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    {Procedure Find_ListCoord(GlobComp  :  TGlobCompRec);}

    {procedure Store_ListCoord(GlobComp  :  TGlobCompRec);}

  end;


  TfrmCardList = class(TForm)
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    Popup_Add: TMenuItem;
    Popup_Edit: TMenuItem;
    N2: TMenuItem;
    Popup_Find: TMenuItem;
    Popup_Notes: TMenuItem;
    N3: TMenuItem;
    Popup_Delete: TMenuItem;
    Popup_Print: TMenuItem;
    Popup_Links: TMenuItem;
    ScrolBox5: TScrollBox;
    TLCompPanel: TSBSPanel;
    TLAccPanel: TSBSPanel;
    TLCatPanel: TSBSPanel;
    TLBalPanel: TSBSPanel;
    SBSPanel1: TSBSPanel;
    TLAccLab: TSBSPanel;
    TLCompLab: TSBSPanel;
    TLBalLab: TSBSPanel;
    TLCatLab: TSBSPanel;
    btnPanel: TSBSPanel;
    Button13: TButton;
    ScrolBox6: TScrollBox;
    TLCAddBtn: TButton;
    TLCEditBtn: TButton;
    TLCFindBtn: TButton;
    TLCDelBtn: TButton;
    TLCNoteBtn: TButton;
    TLCPrnBtn: TButton;
    TLCLetrBtn: TButton;
    panScroll: TSBSPanel;
    TLTelLab: TSBSPanel;
    TLTelPanel: TSBSPanel;
    btnLedger: TButton;
    Popup_Ledger: TMenuItem;
    btnSort: TButton;
    Popup_SortMenu: TMenuItem;
    Popup_Sort: TPopupMenu;
    Popup_Sort_CardNo: TMenuItem;
    Popup_Sort_MembCode: TMenuItem;
    Popup_Sort_MembName: TMenuItem;
    Popup_SortCardN0: TMenuItem;
    Popup_SortMembCode: TMenuItem;
    Popup_SortMembName: TMenuItem;
    PopupMenu2: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure TLAccPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TLAccLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TLAccLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure TLCloseBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure TLCAddBtnClick(Sender: TObject);
    procedure TLCFindBtnClick(Sender: TObject);
    procedure TLCHistBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure TLCPrnBtnClick(Sender: TObject);
    procedure TLCChkBtnClick(Sender: TObject);
    procedure btnSortClick(Sender: TObject);
    procedure SortListBy(Sender: TObject);

  private
    { Private declarations }
    MULCtrlO   :  TCustList;

    ListOfSet  :  Integer;

    ListActive,
    StoreCoord,
    InAutoRefresh,
    fNeedCUpdate,
    LastCoord,
    SetDefault,
    GotCoord   :  Boolean;

    ListIdxNo  : Byte;


    {PageP,
    ScrollAP,
    ScrollBP,
    Misc1P,
    PanelP}
    ptList,
    ptListPan,
    ptScrlPan,
    ptBtnPanel   :  TPoint;


    StartSize,
    InitSize   :  TPoint;

    CardActive  : Boolean;
    {CardRecForm : TCardRec;}

    CustBtnList:  TVisiBtns;

    procedure Display_Account(Mode  :  Byte);

    procedure FormSetOfSet;

    procedure PrimeButtons;


    Procedure Send_ParentMsg(Mode   :  Integer);

    Procedure SetDeleteStat(CustR  :  CustRec);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    procedure SendObjectCC;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;

    Function KeyPressOk  :  Boolean;

{    procedure SetFormProperties;}

    {procedure Find_FormCoord;
    procedure Store_FormCoord(UpMode  :  Boolean);}


    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

  public
    { Public declarations }
    ExLocal    :  TdExLocal;

    Procedure ChangePage;

  end;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  //DebugU,
  //BTSupU2,

  {$IFDEF GF}
    {FindCtlU,}
  {$ENDIF}

  {$IFDEF FRM}
    {DefProcU,}
  {$ENDIF}

  BTKeys1U;

  {$IFDEF POST}
     {PostingU,}
  {$ENDIF}

  //SysU2,
  //PWarnU,
  //BTSupU3,
  {CustR3U,}

  //CardKeys;

{$R *.DFM}



{ ============== TCustList Methods =============== }
Function TCustList.SetCheckKey  :  Str255;


Var
  DumStr  :  Str255;

Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  DumStr:=Cust.CustCode;

  SetCheckKey:=DumStr;
end;




Function TCustList.SetFilter  :  Str255;

Begin

  Result:=Cust.CustSupp;

end;


Function TCustList.Ok2Del :  Boolean;

Begin
  Result:=BOff;
end;



{ ========== Generic Function to Return Formatted Display for List ======= }


Function TCustList.OutLine(Col  :  Byte)  :  Str255;


Var
  FoundCode  :  Str10;
  FoundOk    :  Boolean;
  Dnum       :  Double;

Begin
   With Cust Do Begin
     Case Col Of
       { Code }
       0  :  OutLine:=CustCode;

       { Company Name }
       //1  :  OutLine:=csCardFullName (csCard, True, True);

       { Club Memership Code }
       2  :  OutLine:=ClubNo;

       { Club Category }
       3  :  OutLine:=ClubCat;

       { Phone Number }
       4  :  OutLine:=Phone;

       else
             OutLine:='';

     end; {Case..}
   End; { With }
end;



(*
Procedure TCustList.Find_ListCoord(GlobComp  :  TGlobCompRec);

Var
  TmpList :  TList;

  n       :  Byte;

  TmpColO :  Integer;

  TmpPanel:  TSBSPanel;

  LoopCtrl:  Boolean;

Begin
  LoopCtrl:=BOff;

  TmpList:=TList.Create;


  With GlobComp^,VisiList do
  Begin

    For n:= 0 to Pred(Count) do
    Begin
      TmpList.Add(nil);
    end;

    For n:= 0 to Pred(Count) do
    Begin

      VisiRec:=List[n];

      With VisiRec^ ,ColAppear^[n] do
      Begin

        TmpPanel:=(PanelObj as TSBSPanel);

        Repeat

          If GetbtControlCsm(TmpPanel) then
          Begin
            HBkColor:=HLite;
            HTextColor:=HTLite;

            If (Not LoopCtrl) and (HasCoord) then
            Begin
              TmpList.Items[ColOrd]:=Items[n];
            end
          end;


          TmpPanel:=(LabelObj as TSBSPanel);


          LoopCtrl:=Not LoopCtrl;

        Until (Not LoopCtrl);

      end; {With..}
    end; {Loop..}

    If (TmpList.Items[0]<>nil) then
    For n:= 0 to Pred(Count) do
    Begin
      Items[n]:=TmpList.Items[n];
    end;

    TmpList.Free;
  end; {With..}
end; {Proc..}


procedure TCustList.Store_ListCoord(GlobComp  :  TGlobCompRec);


Var
  n       :  Byte;

  TmpPanel:  TSBSPanel;

  LoopCtrl:  Boolean;


Begin

  With GlobComp^ do
  Begin


    LoopCtrl:=BOff;

    With VisiList do
    Begin
      For n:= 0 to Pred(Count) do
      Begin

        VisiRec:=List[n];

        With VisiRec^ ,ColAppear^[n] do
        Begin

          TmpPanel:=(PanelObj as TSBSPanel);

          Repeat

            ColOrd:=n;

            HLite:=HBkColor;
            HTLite:=HTextColor;

            StorebtControlCsm(TmpPanel);


            TmpPanel:=(LabelObj as TSBSPanel);

            LoopCtrl:=Not LoopCtrl;

          Until (Not LoopCtrl);

        end;
      end; {Loop..}

    end; {With..}

  end; {With GlobComp..}

end;
*)

{ =================================================================================== }


procedure TfrmCardList.Display_Account(Mode  :  Byte);
{Var
  Card : csCardRecType;}
Begin
  (*
  If Not Assigned(CardRecForm) Then Begin
    Set_CustFormMode(1);

    CardRecForm := TCardRec.Create(Self);
  End; { If }

  Try
    CardActive:=BOn;

    With CardRecForm Do Begin
      WindowState:=wsNormal;

      CanAllocate:=BOn;
      SetTabs;

      If (Mode In [1..9]) Then
        Show;

      If (Not ExLocal.InAddEdit) Then
        ShowLink;

      If (Mode In [1..3]) and (Not ExLocal.InAddEdit) Then Begin
        { Add/Edit/Delete and not already adding/editing }
        ChangePage(1);

        If (Mode=3) then
          DeleteAccount
        else
          EditAccount(Mode = 2);
      End; { If }

      Case Mode of
        { Ledger }
        4  : ChangePage(1);

        { Notes }
        5  : ChangePage(2);

        { Links }
        6  : ChangePage(3);
      End; { Case }
    End; {With..}
  Except
   CardActive := BOff;
   CardRecForm.Free;
  End; { Try }
  *)
end;


Procedure  TfrmCardList.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

(*
{ Load form co-ordinates from file }
Procedure TfrmCardList.Find_FormCoord;
Var
  ThisForm:  TForm;

  VisibleRect
          :  TRect;

  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOn));

  ThisForm:=Self;

  With GlobComp^ do
  Begin

    GetValues:=BOn;

    If (GetbtControlCsm(ThisForm)) then
    Begin
      StoreCoord:=(ColOrd=1);
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);

    end;

    GetbtControlCsm(ScrolBox5);

    GetbtControlCsm(ScrolBox6);

    GetbtControlCsm(BtnPanel);

    GetbtControlCsm(panScroll);

    GetbtControlCsm(SBSPanel1);

    MULCtrlO.Find_ListCoord(GlobComp);

  end; {With GlobComp..}

  SBSPanel1.Color:=TLAccLab.Color;

  Dispose(GlobComp,Destroy);

      {* Check form is within current visible range *}

  With TForm(Owner) do
    VisibleRect:=Rect(0,0,ClientWidth,ClientHeight);

  If (Not PtInRect(VisibleRect,Point(Left,Top))) then
  Begin
    Left:=0;
    Top:=0;
  end;

    {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TfrmCardList.Store_FormCoord(UpMode  :  Boolean);
Var
  GlobComp:  TGlobCompRec;
Begin { Store_FormCoord }
  New(GlobComp,Create(BOff));

  With GlobComp^ Do Begin
    GetValues:=UpMode;

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(ScrolBox5);

    StorebtControlCsm(ScrolBox6);

    StorebtControlCsm(BtnPanel);

    StorebtControlCsm(SBSPanel1);

    StorebtControlCsm(panScroll);

    MULCtrlO.Store_ListCoord(GlobComp);
  end; {With GlobComp..}

  GlobComp.Destroy;
End; { Store_FormCoord }
*)


procedure TfrmCardList.FormSetOfSet;
Begin
  ptList.X := Self.Width - ScrolBox5.Width;
  ptList.Y := Self.Height - ScrolBox5.Height;

  ptListPan.Y := ScrolBox5.ClientHeight - TLAccPanel.Height;

  ptBtnPanel.X := Self.Width - BtnPanel.Left;
  ptBtnPanel.Y := BtnPanel.Height - ScrolBox6.Height;

  ptScrlPan.X := Self.Width - panScroll.Left;
  ptScrlPan.Y := Self.Height - panScroll.Height;

  GotCoord:=BOn;
end;


procedure TfrmCardList.PrimeButtons;
Begin { PrimeButtons }
  If Not Assigned(CustBtnList) Then Begin
    CustBtnList:=TVisiBtns.Create;

    Try
      With CustBtnList do Begin
        PresEnab:=BOff;

        AddVisiRec(TLCAddBtn,BOff);
        AddVisiRec(TLCEditBtn,BOff);
        AddVisiRec(TLCDelBtn,BOff);
        AddVisiRec(btnLedger,BOff);
        AddVisiRec(TLCNoteBtn,BOff);
        AddVisiRec(TLCLetrBtn,BOff);
        AddVisiRec(TLCFindBtn,BOff);
        AddVisiRec(TLCPrnBtn,BOff);
        AddVisiRec(btnSort,BOff);
      End; { With CustBtnList }
    Except
      CustBtnList.Free;
      CustBtnList := Nil;
    End; { Try }
  End; { If Not Assigned(CustBtnList) }

  If Assigned(CustBtnList) Then Begin
    Try
      With CustBtnList do Begin
        SetHideBtn(0, False, BOff);   { Add }
        SetHideBtn(1, False, BOff);   { Edit }
        SetHideBtn(2, False, BOff);   { Delete }
        SetHideBtn(3, False, BOff);   { Ledger }
        SetHideBtn(4, False, BOff);   { Notes }
        SetHideBtn(5, False, BOff);   { Links }
        SetHideBtn(6, False, BOff);   { Find }
        SetHideBtn(7, False, BOff);   { Print }
      End; { With CustBtnList }
    Except
      CustBtnList.Free;
      CustBtnList := Nil;
    End; { Try }
  End; { If Not Assigned(CustBtnList) }
End;  { PrimeButtons }


procedure TfrmCardList.FormCreate(Sender: TObject);
Var
  n  :  Byte;

  StartPanel
     :  TSBSPanel;

begin
  (*
  If Assigned(CompanyDlgManager) Then
    CompanyDlgManager.RegList (Self);
  *)

  PrimeButtons;

  ListActive:=BOff;
  GotCoord:=BOff;

  LastCoord:=BOff;
  NeedCUpdate:=BOff;

  InAutoRefresh:=BOff;

  ExLocal.Create;

  ScrolBox5.HorzScrollBar.Position:=0;
  ScrolBox5.VertScrollBar.Position:=0;

  MULCtrlO:=TCustList.Create(Self);

  Try
    { Setup Customers List }
    With MULCtrlO Do Begin
      Try
        With VisiList Do Begin
          AddVisiRec(TLAccPanel,TLAccLab);
          AddVisiRec(TLCompPanel,TLCompLab);
          AddVisiRec(TLBalPanel,TLBalLab);
          AddVisiRec(TLCatPanel,TLCatLab);
          AddVisiRec(TLTelPanel,TLTelLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          LabHedPanel:=SBSPanel1;
        End; { With }
      Except
        VisiList.Free;
      End; { Try }

      InitSize.Y:=317;
      InitSize.X:=532;

      Self.ClientHeight:=InitSize.Y;
      Self.ClientWidth:=InitSize.X;

      { Position window }
      MDI_SetFormCoord(TForm(Self));

      { Load form co-ordinates }
      {Find_FormCoord;}

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=4;
      Font:=StartPanel.Font;
      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        {HBkColor:=ClHighLight;
        HTextColor:=ClHighLightText;}

        {If (n=2) then
        Begin
          DispFormat:=SGFloat;
          NoDecPlaces:=2;
        end;}
      end;

      Filter[1,0]:='';

      Self.Refresh;

      ListCreate;

      Set_Buttons(panScroll);

      AbortOnEmpty:=BOn;

      ListIdxNo := 0;
      StartList(CustF,ListIdxNo,'','','',0,BOff);

      ListOfSet:=10;
    end {With}
  Except
    MULCtrlO.Free;
    MULCtrlO:=Nil;
  End; { Try }

  FormSetOfSet;

  ChangePage;
End;


procedure TfrmCardList.FormActivate(Sender: TObject);
begin
  If (MULCtrlO<>nil) then
    MULCtrlO.SetListFocus;

  ListActive:=BOn;
end;


procedure TfrmCardList.FormDestroy(Sender: TObject);

Var
  n  :  Byte;

begin

  ExLocal.Destroy;

  If (CustBtnList<>nil) then
    CustBtnList.Free;


  {For n:=0 to High(MULCtrlO) do  {* Seems to crash here if you have scrolled list
    If (MULCtrlO[n]<>nil) then
      MULCtrlO[n].Free;}


end;


{ Enables/Disables the delete button depending on the highlighted card }
Procedure TfrmCardList.SetDeleteStat(CustR  :  CustRec);
Begin { SetDeleteStat }
  With CustR Do Begin
    TLCDelBtn.Enabled := (CurrBalance = 0);
  End; { With }
End; { SetDeleteStat }


Procedure TfrmCardList.WMCustGetRec(Var Message  :  TMessage);
Begin { WMCustGetRec }
  With Message Do Begin
    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of


      0,169
         :  Begin

              Display_Account(0);

            end;

      1  :  PostMessage(Self.Handle,WM_FormCloseMsg,1000+WParam,0); {* This was placed here to stop the mouse up event from being corrupted *}


      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      25 :  NeedCUpdate:=BOn;

    100..107
         :  With MULCtrlO do
            Begin
              AddNewRow(MUListBoxes[0].Row,(LParam=1));
            end;

    170  :  TLCPrnBtnClick(nil);

    175  :  ChangePage;

    177  :  Begin
              PrimeButtons;

              {Check_TabAfterPW(PageControl1,Self,WM_CustGetRec);}

            end;


    200..207
         :  Begin
              CardActive:=Boff;
              //CardRecForm:=nil;
            end;

    300..307
         :  With MULCtrlO do
            Begin
              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;
            end;


    3000..3007
          : With MULCtrlO do Begin
              Find_OnList(Cust.CustCode,CustCodeK);

              With MUListBoxes[0] do
                If (CanFocus) then
                  SetFocus;
            end;

    3100..3107
          : With MULCtrlO do
            Begin
              InAutoRefresh:=BOn;
              try

                StartList(CustF,CustCodeK,Cust.CustCode,'','',0,BOff);

                KeyRef:='';

                With MUListBoxes[0] do
                  If (CanFocus) then
                    SetFocus;
              finally
                InAutoRefresh:=BOff;
              end;
            end;


    end; {Case..}

    If (WParam in [1,2]) then
     SetDeleteStat(Cust);
  End; { Case }

  Inherited;
end;


procedure TfrmCardList.SendObjectCC;

Begin
  {SendToObjectCC(Cust.CustCode,0);}
end;


Procedure TfrmCardList.WMFormCloseMsg(Var Message  :  TMessage);
{ar
  Comp : CustRec;}
Begin

  With Message do
  Begin

    Case WParam of
      1001  : {* This handling was placed here so to give the list a chance to see the mouse up event *}

            Begin
              (*
              If Assigned(CardRecForm) And CardActive Then
                With CardRecForm Do Begin
                  If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit) and (csCard.csCustCode<>ExLocal.LcsCard.csCustCode) Then Begin
                    {* When in ledger filtmode, mouseup event is destryoed, so force it off here *}
                    If (InOSFilt) then
                      Self.MULCtrlO.AutoRepeat1:=BOff;

                    ShowLink;
                  end;
                End; { With }
              *)

              (*
              SendObjectCC;

              {$IFDEF Ltr}
                { Check for link to letters }
                If Assigned(LettersForm[Current_Page]) And LettersActive[Current_Page] Then
                  With LettersForm[Current_Page] Do Begin
                    If (WindowState <> wsMinimized) and (Cust.CustCode <> ExLocal.LCust.CustCode) Then Begin
                      {ShowLink(True);}
                      LoadLettersFor (Cust.CustCode,
                                      Cust.CustCode,
                                      Trim(Cust.CustCode),
                                      TradeCode[(Current_Page = 0)],
                                      @Cust, Nil, Nil);
                    End; { If }
                  End; { With }
              {$ENDIF}
              *)
            End; { 1 }


    end; {Case..}

  end; {With..}

end; {Proc..}



Procedure TfrmCardList.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

Begin

  With Message.MinMaxInfo^ do
  Begin

    ptMinTrackSize.X:=200;
    ptMinTrackSize.Y:=210;

    {ptMaxSize.X:=530;
    ptMaxSize.Y:=368;
    ptMaxPosition.X:=1;
    ptMaxPosition.Y:=1;}

  end;

  Message.Result:=0;

  Inherited;

end;


Procedure TfrmCardList.WMSysCommand(Var Message  :  TMessage);


Begin
  With Message do
    Case WParam of

      SC_Maximize  :  Begin
                        {Self.Height:=InitSize.Y;
                        Self.Width:=InitSize.X;}

                        Self.ClientHeight:=InitSize.Y;
                        Self.ClientWidth:=InitSize.X;

                        WParam:=0;
                      end;

    end; {Case..}

  Inherited;
end;

procedure TfrmCardList.TLAccPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

Var
  BarPos :  Integer;
  PanRSized
         :  Boolean;



begin
  BarPos:=0;

  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    PanRSized:=ReSized;

    BarPos:=ScrolBox5.HorzScrollBar.Position;

    If (PanRsized) then
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);
  end;

end;


procedure TfrmCardList.TLAccLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      MULCtrlO.VisiList.PrimeMove(Sender);
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

procedure TfrmCardList.TLAccLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    MULCtrlO.VisiList.MoveLabel(X,Y);
    NeedCUpdate:=MULCtrlO.VisiList.MovingLab;
  end;

end;

procedure TfrmCardList.FormResize(Sender: TObject);
Var
  n          :  Byte;
begin
  If GotCoord then Begin
    MULCtrlO.LinkOtherDisp:=BOff;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    { Reposition Button Panel }
    BtnPanel.Left := Self.Width - ptBtnPanel.X;
    BtnPanel.Height := Self.Height - ptList.Y;

    { Resize button Scroll Box within Panel }
    ScrolBox6.Height := BtnPanel.Height - ptBtnPanel.Y;

    { Resize List-Scrollbar panel }
    panScroll.Left := Self.Width - ptScrlPan.X;
    panScroll.Height := Self.Height - ptScrlPan.Y;

    { Resize List }
    ScrolBox5.Width := Self.Width - ptList.X;
    ScrolBox5.Height := Self.Height - ptList.Y;

    If Assigned(MULCtrlO) then Begin
      With MULCtrlO.VisiList Do Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) Do Begin
          Height:=ScrolBox5.ClientHeight - ptListPan.Y;
        End; { If }
      End; { With }

      With MULCtrlO Do Begin
        ReFresh_Buttons;

        RefreshAllCols;
      end;
    End;{ If }

    MULCtrlO.LinkOtherDisp:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
  end; {If time to update}
end; {Proc..}

procedure TfrmCardList.TLCloseBtnClick(Sender: TObject);
begin
  If (Not MULCtrlO.InListFind) then
    Close;
end;

(*procedure TfrmCardList.SetFormProperties;


Var
  TmpPanel    :  Array[1..3] of TPanel;

  n           :  Byte;

  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;

Begin
  ResetDefaults:=BOff;

  For n:=1 to 3 do
  Begin
    TmpPanel[n]:=TPanel.Create(Self);
  end;


  try

    With MULCtrlO.VisiList do
    Begin
      VisiRec:=List[0];

      TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
      TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

      TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
      TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;


      TmpPanel[3].Color:=MULCtrlO.ColAppear^[0].HBKColor;
    end;

    TmpPanel[3].Font.Assign(TmpPanel[1].Font);

    TmpPanel[3].Font.Color:=MULCtrlO.ColAppear^[0].HTextColor;


    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,'Trader List Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then
        Begin

          For n:=1 to 3 do
            With TmpPanel[n] do
              Case n of
                1,2  :  MULCtrlO.ReColorCol(Font,Color,(n=2));

                3    :  MULCtrlO.ReColorBar(Font,Color);
              end; {Case..}

          MULCtrlO.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
        end;

      end;

    finally

      ColourCtrl.Free;

    end;

  Finally

    For n:=1 to 3 do
      TmpPanel[n].Free;

  end;

  If (ResetDefaults) then
  Begin
    SetDefault:=BOn;
    Close;
  end;

end;*)

procedure TfrmCardList.PropFlgClick(Sender: TObject);
begin
{  SetFormProperties;}
end;

procedure TfrmCardList.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;


procedure TfrmCardList.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;
  With PopUpMenu1 Do Begin
    For n:=0 to Items.Count-1 do
      With Items[n] do
        If (Tag=1) then
          Visible:=(N3.Tag=99);
  End;{ With }

  With CustBtnList Do Begin
    SetMenuFBtn (Popup_Add,      0);
    SetMenuFBtn (Popup_Edit,     1);
    SetMenuFBtn (Popup_Delete,   2);
    SetMenuFBtn (Popup_Ledger,   3);
    SetMenuFBtn (Popup_Notes,    4);
    SetMenuFBtn (Popup_Links,    5);
    SetMenuFBtn (Popup_Find,     6);
    SetMenuFBtn (Popup_Print,    7);
    SetMenuFBtn (Popup_SortMenu, 8);

    Popup_Delete.Enabled:=TLCDelBtn.Enabled
  End; { With }
end;

procedure TfrmCardList.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin
    N3.Tag:=99*Mode;

    PopUp(X,Y);

    N3.Tag:=0;
  end;


end;


{ == Procedure to Send Message to Get Record == }

Procedure TfrmCardList.Send_ParentMsg(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_FormCloseMsg;
    WParam:=1;

  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}

procedure TfrmCardList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;

  Send_ParentMsg(0); {Form closing..}

end;

procedure TfrmCardList.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

begin

  GenCanClose(Self,Sender,CanClose,BOn);

  If (CanClose) then
    CanClose:=Not InAutoRefresh;

  If (CanClose) then
  Begin
    ScrolBox5.HorzScrollBar.Position:=0;
    ScrolBox5.VertScrollBar.Position:=0;

    If (NeedCUpdate) then
      {Store_FormCoord(Not SetDefault)};

  end;

end;




procedure TfrmCardList.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);

begin

  //Release_PageHandle(Sender);

end;

Procedure TfrmCardList.ChangePage;


Begin
  If Assigned(MULCtrlO) And ListActive Then Begin
    MULCtrlO.SetListFocus;
  End; { If }
end; {Proc..}


Function TfrmCardList.KeyPressOk  :  Boolean;

Begin
  If (Assigned(MULCtrlO)) then
    Result:=Not MULCtrlO.InListFind
  else
    Result:=BOn;
end;

procedure TfrmCardList.TLCAddBtnClick(Sender: TObject);

Var
  EditMode,
  DelMode,
  NoteMode,
  LedgMode,
  LinkMode   :  Boolean;

begin
  If (Not MULCtrlO.InListFind) Then Begin
    With MULCtrlO do
      RefreshLine(MUListBoxes[0].Row,BOff);

    EditMode := (Sender = TLCEditBtn) or (Sender = Popup_Edit);
    DelMode  := (Sender = TLCDelBtn) or (Sender = Popup_Delete);
    NoteMode := (Sender = TLCNoteBtn) or (Sender = Popup_Notes);
    LinkMode := (Sender = TLCLetrBtn) or (Sender = Popup_Links);
    LedgMode := (Sender = btnLedger) or (Sender = Popup_Ledger);

    Display_Account(1 + (1 * Ord(EditMode)) +
                        (2 * Ord(DelMode)) +
                        (3 * Ord(LedgMode)) +
                        (4 * Ord(NoteMode)) +
                        (5 * Ord(LinkMode)));
  End;
end;



procedure TfrmCardList.TLCFindBtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;
Begin { TLCFindBtnClick }
  If (Not MULCtrlO.InListFind) Then Begin
    ListPoint.X:=1;
    ListPoint.Y:=1;

    With TWinControl(Sender) do
      ListPoint:=ClientToScreen(ListPoint);

    PopupMenu2.PopUp(ListPoint.X,ListPoint.Y);
  end;
end; { TLCFindBtnClick }


procedure TfrmCardList.TLCHistBtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
(*
  If (KeyPressOk) then
  Begin

    If (Current_Page=0) then
    Begin
      If (Sender<>Hist1) then
      Begin
        With TWinControl(Sender) do
        Begin
          ListPoint.X:=1;
          ListPoint.Y:=1;

          ListPoint:=ClientToScreen(ListPoint);

        end;

        PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);
      end;
    end
    else
      Bal1Click(Bal1);
  end;
*)
end;



procedure TfrmCardList.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TfrmCardList.TLCPrnBtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;
  PrintMode  :  Byte;

begin
  (*

  {$IFDEF FRM}

  If (KeyPressOk) then
  With ExLocal do
    Case Current_Page of

      0,1  :  With MULCtrlO do
              Begin
                GetSelRec(BOff);
                AssignFromGlobal(CustF);

                If (Sender is TButton) then
                With TWinControl(Sender) do
                Begin
                  ListPoint.X:=1;
                  ListPoint.Y:=1;

                  ListPoint:=ClientToScreen(ListPoint);
                end
                else
                Begin
                  GetCursorPos(ListPoint);
                  With ListPoint do
                  Begin
                    X:=X-50;
                    Y:=Y-15;
                  end;
                end;

                PrintMode:=Get_CustPrint(Self,ListPoint,1);

                If (PrintMode>0) then
                  Control_DefProcess(PrintMode,
                                     InvF,InvCustK,
                                     FullCustType(LCust.CustCode,LCust.CustSupp),
                                     ExLocal,
                                     BOn);
              end;

    end; {Case..}

  {$ENDIF}

  *)
end;

procedure TfrmCardList.TLCChkBtnClick(Sender: TObject);
begin
  (*

  {$IFDEF POST}
   If (KeyPressOk) then
   With MULCtrlO do
   Begin
     GetSelRec(BOff);

     If (Not Check_AccountEdit(Cust.CustCode)) then
       AddCheckCust2Thread(Self,Cust.CustCode,BOff,BOn,BOn);

   end;

  {$ENDIF}
  *)
end;


procedure TfrmCardList.btnSortClick(Sender: TObject);
Var
  ListPoint  :  TPoint;
Begin { btnSortClick }
  If (Not MULCtrlO.InListFind) Then Begin
    ListPoint.X:=1;
    ListPoint.Y:=1;

    With TWinControl(Sender) do
      ListPoint:=ClientToScreen(ListPoint);

    Popup_Sort.PopUp(ListPoint.X,ListPoint.Y);
  end;
End; { btnSortClick }

procedure TfrmCardList.SortListBy(Sender: TObject);
begin
  If (Sender Is TMenuItem) Then Begin
    With Sender as TMenuItem Do Begin
      If (Not MULCtrlO.InListFind) Then Begin
        ListIdxNo := Tag;

        With MULCtrlO Do Begin
          IgnoreMsg:=BOff;

          StartList(ScanFileNum,ListIdxNo,KeyRef,'','',Length(KeyRef),BOff);

          IgnoreMsg:=BOff;
        End; { With MulCtrlO }
      End; { If (Not MULCtrlO.InListFind) }
    End; { With Sender as TMenuItem }
  End; { If (Sender Is TMenuItem) }
end;

end.
