unit NmlCCDU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  GlobVar,VarConst,ETStrU,BtrvU2,BTSupU1, BTKeys1U,  ExWrap1U, Menus, ImgModu,
  StdCtrls, Grids, SBSOutl, ExtCtrls, Buttons, TEditVal, ComCtrls, ToolWin,
  AdvGlowButton, AdvToolBar, AdvToolBarStylers, SBSPanel;

type
  TCCDepView = class(TForm)
    NLDPanel: TSBSPanel;
    NLCrPanel: TSBSPanel;
    NLDrPanel: TSBSPanel;
    NLOLine: TSBSOutlineB;
    PopupMenu1: TPopupMenu;
    MIHist: TMenuItem;
    Graph1: TMenuItem;
    Recon1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    AdvStyler: TAdvToolBarOfficeStyler;
    AdvDockPanel: TAdvDockPanel;
    AdvToolBar: TAdvToolBar;
    AdvToolBarSeparator2: TAdvToolBarSeparator;
    GraphBtn: TAdvGlowButton;
    HistBtn: TAdvGlowButton;
    ReconBtn: TAdvGlowButton;
    Panel2: TPanel;
    Button1: TButton;
    SBSPanel1: TSBSPanel;
    Bevel6: TBevel;
    GlValueF: TCurrencyEdit;
    GLCaption: TSBSPanel;
    OptBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure OptBtnClick(Sender: TObject);
    procedure ClsI1BtnClick(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure NLOLineExpand(Sender: TObject; Index: Integer);
    procedure NLOLineNeedValue(Sender: TObject);
    procedure HistBtnClick(Sender: TObject);
    procedure NLOLineDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private declarations }
    Lab1Ofset,
    Lab2Ofset,
    Lab3Ofset,
    Lab4Ofset,
    LastSelItem,
    ChrWidth     :   LongInt;

    StoreCoord,
    fNeedCUpdate,
    FColorsChanged,
    LastCoord,
    SetDefault,
    GotCoord     :   Boolean;

    StartSize,
    InitSize     :  TPoint;

    ChrsXross    :   Double;

    ColXAry      :   Array[1..2] of LongInt;

    ExLocal      :   TdExLocal;

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure SetFormProperties(SetList  :  Boolean);

    Function AddTreeNode(ParentIdx  :  LongInt;
                         LineText   :  String;
                         Level      :  LongInt;
                         IsCCDep    :  Byte;
                         CCCode     :  Str10;
                         Mode       :  Byte)  :  Integer;

    Procedure Prime_Tree;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    procedure GetCombinationLinks(CCode  :  Str10; Index  :  Integer);

    procedure GetMoreLinks(Index  :  Integer);


    procedure Call_History(Index     :  Integer;
                           ShowGraph :  Boolean;
                           ShowRecon :  Boolean);


    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;


  public
    { Public declarations }

    UseYTD   :  Boolean;

    CCNom    :  NominalRec;

    TotalBal :  Double;

    CCDepNHCtrl
             :  TNHCtrlRec;

    ThisCCCode
             :  Str255;
    ThisCCMode,
    InGraph,
    InHist,
    InRecon
             :  Boolean;

    procedure Show_Link;

  end;

Const
  InitWidth  =  128; {118}
  TDpth      =  70;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETMiscU,
  CmpCtrlU,
  ColCtrlU,
  ComnU2,
  BtSupU2,
  VarRec2U,
  CurrncyU,

  Nominl1U,

  SysU1;


{$R *.DFM}


Const
  CCDepShortTitle  :   Array[BOff..BOn] of Str10 = ('Dp','CC');

Procedure  TCCDepView.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TCCDepView.Find_FormCoord;


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

    PrimeKey:='C';

    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
      StoreCoord:=BOff;
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);

    end;

    If GetbtControlCsm(NLOLine) then
      NLOLine.BarColor:=ColOrd;

    If GetbtControlCsm(NLDPanel) then
      NLOLine.BarTextColor:=ColOrd;

    GetbtControlCsm(NLCrPanel);

    GetbtControlCsm(NLDrPanel);

    {If GetbtControlCsm(Period) then
      SetFieldProperties;}

  end; {With GlobComp..}


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


procedure TCCDepView.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='C';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    ColOrd:=NLOLine.BarColor;

    StorebtControlCsm(NLOLine);

    ColOrd:=NLOLine.BarTextColor;

    StorebtControlCsm(NLDPanel);

    StorebtControlCsm(NLDrPanel);

    StorebtControlCsm(NLCrPanel);

    {StorebtControlCsm(Period);}


  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;




procedure TCCDepView.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  InitSize.Y:=327;
  InitSize.X:=384;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=349;
  Width:=590;}

  MDI_SetFormCoord(TForm(Self));

  GotCoord:=BOff;
  NeedCUpdate:=BOff;
  FColorsChanged := False;

  ThisCCMode:=BOff; ThisCCCode:='';

  {Lab4Ofset:=Height-Panel4.Top+2;}

  Find_FormCoord;

  Lab1Ofset:=Width-(NLDPanel.Width);
  Lab2Ofset:=Width-NLCrPanel.Left;
  Lab3Ofset:=Width-NLDrPanel.Left;

  InGraph:=BOff;
  InHist:=BOff;
  InRecon:=BOff;
  LastSelItem:=0;


  With TForm(Owner) do
  Begin
    Self.Left:=Left+Width;
    Self.Top:=Top;
  end;

  ChrWidth:=InitWidth;

  ChrsXRoss:=(ChrWidth/Width);

  Prime_Tree;

  GotCoord:=BOn;

  NLOLine.TreeColor   := NLOLine.Font.Color;

  FormReSize(Self);
end;

procedure TCCDepView.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  {* Inform parent closing *}

  If (NeedCUpdate) And (StoreCoord Or FColorsChanged) then
    Store_FormCoord(Not SetDefault);

  Send_UpdateList(43);

end;

procedure TCCDepView.FormClose(Sender: TObject; var Action: TCloseAction);
Var
  N       :  LongInt;

  ONomRec :  ^OutNomType;


begin

  With NLOLine do {* Tidy up attached objects *}
  Begin
    For n:=1 to ItemCount do
    Begin
      ONomRec:=Items[n].Data;
      If (ONomRec<>nil) then
        Dispose(ONomRec);
    end;

  end;

  ExLocal.Destroy;

  Action:=caFree;

end;




procedure TCCDepView.FormResize(Sender: TObject);
begin
  If (GotCoord) then
  Begin
    GotCoord:=BOff;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    NLOLine.Width:=ClientWidth-5;
    NLOLine.Height:=ClientHeight-104;
    NLDPanel.Width:=Width-Lab1Ofset;
    NLCrPanel.Left:=Width-Lab2Ofset;
    NLDrPanel.Left:=Width-Lab3Ofset;

    {Panel4.Top:=Height-Lab4Ofset;
    Panel5.Top:=Height-Lab4Ofset;

    ClsI1Btn.Top:=Height-Lab4Ofset;}

    ColXAry[1]:=NLDrPanel.Width+NLDrPanel.Left-4;
    ColXAry[2]:=NLCrPanel.Width+NLCrPanel.Left-4;

    GLCaption.Width:=NLDPanel.Width;
    //GLCaption.Top:=NLOLine.Top+NLOLine.Height+3;
    GLValueF.Left:=NLCrPanel.Left;
    //GLValueF.Top:=GLCaption.Top;
    //OptBtn.Top:=GLCaption.Top;

    Bevel6.Left := NLOLine.Left;
    Bevel6.Width := NLOLine.Width;

    ChrWidth:=Round(Width*ChrsXRoss);

    NLOLine.HideText:=(Width<=183);

    {ClsI1Btn.Left:=NLDrPanel.Left+4;}

    //OptBtn.Left:=NLDrPanel.Left+4;

    {Update_OutLines(NomF,NomCodeK);}

    GotCoord:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end;


end;


Procedure TCCDepView.WMCustGetRec(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of
       1  :  HistBtnClick(Nil);


    end; {Case..}

  end;
  Inherited;
end;


procedure TCCDepView.PopupMenu1Popup(Sender: TObject);

begin
  StoreCoordFlg.Checked:=StoreCoord;
  N3.Tag:=Ord(ActiveControl Is TSBSOutLineB);
end;

procedure TCCDepView.OptBtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin
  With TWinControl(Sender) do
  Begin
    ListPoint.X:=1;
    ListPoint.Y:=1;

    ListPoint:=ClientToScreen(ListPoint);

  end;


  PopUpMenu1.PopUp(ListPoint.X,ListPoint.Y);
end;


{ == Procedure to Send Message to Get Record == }

Procedure TCCDepView.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_FormCloseMsg;
    WParam:=Mode;
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}




procedure TCCDepView.ClsI1BtnClick(Sender: TObject);
begin
  Close;
end;


procedure TCCDepView.SetFormProperties(SetList  :  Boolean);

Const
  PropTit     :  Array[BOff..BOn] of Str5 = ('Form','List');



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

    If (SetList) then
    Begin
      With NLOLine do
      Begin
        TmpPanel[1].Font:=Font;
        TmpPanel[1].Color:=Color;

        TmpPanel[2].Font:=NLDPanel.Font;
        TmpPanel[2].Color:=NLDPanel.Color;


        TmpPanel[3].Color:=BarColor;
        TmpPanel[3].Font.Assign(TmpPanel[1].Font);
        TmpPanel[3].Font.Color:=BarTextColor;
      end;


    end
    else
    Begin
      {TmpPanel[1].Font:=Period.Font;
      TmpPanel[1].Color:=Period.Color;

      TmpPanel[2].Font:=Panel4.Font;
      TmpPanel[2].Color:=Panel4.Color;}
    end;


    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],Ord(SetList),Self.Caption+' '+PropTit[SetList]+' Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);
        FColorsChanged := NeedCUpdate;

        If (BeenChange) and (not ResetDefaults) then
        Begin

          If (SetList) then
          With NLOLine do
          Begin
            Font.Assign(TmpPanel[1].Font);
            Color:=TmpPanel[1].Color;

            NLDPanel.Font.Assign(TmpPanel[2].Font);
            NLDPanel.Color:=TmpPanel[2].Color;


            BarColor:=TmpPanel[3].Color;
            BarTextColor:=TmpPanel[3].Font.Color;

            NLCrPanel.Font.Assign(TmpPanel[2].Font);
            NLCrPanel.Color:=TmpPanel[2].Color;

            NLDrPanel.Font.Assign(TmpPanel[2].Font);
            NLDrPanel.Color:=TmpPanel[2].Color;

            NLOLine.TreeColor   := NLOLine.Font.Color;
          end
          else
          Begin
            {Period.Font.Assign(TmpPanel[1].Font);
            Period.Color:=TmpPanel[1].Color;

            SetFieldProperties;}
          end;
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

end;


procedure TCCDepView.PropFlgClick(Sender: TObject);
begin
  SetFormProperties(BOn);
  N3.Tag:=0;
end;

procedure TCCDepView.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;

end;


Function TCCDepView.AddTreeNode(ParentIdx  :  LongInt;
                                LineText   :  String;
                                Level      :  LongInt;
                                IsCCDep    :  Byte;
                                CCCode     :  Str10;
                                Mode       :  Byte)  :  Integer;
Var
  ONomRec   :  ^OutNomType;

Begin
  If (LineText<>'XNANX') then {* Exclude those which cannot be found *}
  With NLOLine do
  Begin
    New(ONomRec);
    FillChar(ONomRec^,Sizeof(ONomRec^),0);
    With ONomRec^ do
    Begin
      OutNomCat:=IsCCDep;
      OutStkCode:=CCCode;
      LastCCFilt[IsCCDep<>0]:=CCCode;
      OutDepth:=Level;
      MoreLink:=(Mode In [0,2]);
      PRateMode:=(Mode=2);
    end;

    Result:=AddChildObject(ParentIdx,LineText,ONomRec);

    With Items[Result] do
    Case IsCCDep of
      0  :  UseLeafX:=obLeaf2;
      else  UseLeafX:=obLeaf;
    end; {Case..}

    If (Result>-1) then
    With Items[Result] do
    Begin
      ShowCheckBox:=BOff;

      If (Mode In [0,2]) then
        AddChild(Result,'Child place holder');

    end;

  end; {With..}


end;

Procedure TCCDepView.Prime_Tree;

Begin
  AddTreeNode(0,'Cost Centre',0,1,'',0);
  AddTreeNode(0,'Departments',0,0,'',0);

  If (Syss.PostCCDCombo) then
  Begin
    AddTreeNode(0,'Cost Centres + Depts',0,1,'',2);
    AddTreeNode(0,'Departments + CCs',0,0,'',2);
  end;
end;


procedure TCCDepView.GetMoreLinks(Index  :  Integer);

Const
  Fnum     =  PWrdF;
  Keypath  =  PWK;

Var
  ONomRec :  ^OutNomType;

  pIdx    :  Integer;
  KeyS,
  KeyChk,
  LineText:  Str255;

  
Begin
  With NLOLine do
  Begin
    ONomRec:=Items[Index].Data;


    If (ONomRec<>nil) then
    With ONomRec^ do
    If (OutStkCode<>'') or (MoreLink) then
    Begin
      MoreLink:=BOff;

      KeyChk:=PartCCKey(CostCCode,CSubCode[(OutNomCat=1)]);

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
      With PassWord,CostCtrRec do
      Begin
        LineText:=dbFormatName(PCostC,CCDesc);

        If (PRateMode) then
          LineText:=CCDepShortTitle[(OutNomCat=1)]+': '+LineText;

        PIdx:=AddTreeNode(Index,LineText,OutDepth,OutNomCat,PCostC,1+Ord(PRateMode));

        
        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      end;
    end;

  end; {With..}

end;


procedure TCCDepView.GetCombinationLinks(CCode  :  Str10; Index  :  Integer);

Const
  Fnum     =  PWrdF;
  Keypath  =  PWK;

Var
  ONomRec :  ^OutNomType;

  IsCC    :  Boolean;

  TmpKPath,
  TmpStat :  Integer;

  TmpRecAddr
          :  LongInt;

  pIdx    :  Integer;
  KeyS,
  KeyChk,
  LineText :  Str255;

  BCCDep  :  CCDepType;


Begin
  With NLOLine do
  Begin
    ONomRec:=Items[Index].Data;

    Blank(BCCDep,Sizeof(BCCDep));

    
    If (ONomRec<>nil) then
    With ONomRec^ do
    Begin
      TmpKPath:=Keypath;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      MoreLink:=BOff;

      IsCC:=(OutNomCat=1);

      BCCDep[IsCC]:=CCode;

      KeyChk:=PartCCKey(CostCCode,CSubCode[Not IsCC]);

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
      With PassWord,CostCtrRec do
      Begin
        LineText:=dbFormatName(PCostC,CCDesc);

        BCCDep[Not IsCC]:=PCostC;

        PIdx:=AddTreeNode(Index,LineText,OutDepth,OutNomCat,CalcCCDepKey(IsCC,BCCDep),1);

        With Items[PIdx] do
          Case OutNomCat of
            1  :  UseLeafX:=obLeaf2;
            else  UseLeafX:=obLeaf;
          end; {Case..}


        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      end;

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

    end;

  end; {With..}

end;


procedure TCCDepView.NLOLineExpand(Sender: TObject; Index: Integer);
Var
  ONomRec :  ^OutNomType;
  ChildIdx:  Integer;

begin
  With (Sender as TSBSOutLineB) do
  Begin
    ONomRec:=Items[Index].Data;

    If (ONomRec<>nil) then
    With ONomRec^ do
    Begin
      If (ITems[Index].HasItems) or (MoreLink) then
      Begin

        If (MoreLink) then {* Get next load *}
        Begin
          ChildIdx:=ITems[Index].GetFirstChild;

          If (ChildIdx>0) then {Delete the place holder first}
            Delete(ChildIdx);

          //PostMessage(Self.Handle,WM_CustGetRec,250,Index);

          If (PRateMode) and (OutStkCode<>'') then {Add in opposing combinations}
            GetCombinationLinks(OutStkCode,Index)
          else
            GetMoreLinks(Index);
        end;
      end
      else
      Begin
        {Drilldown}

        InRecon:=BOn;
        Call_History(Index,BOn,BOn);


      end;
    end;
  end; {With..}
end;




procedure TCCDepView.NLOLineNeedValue(Sender: TObject);
Var
  ONomRec      :  ^OutNomType;
  DrawIdxCode  :  LongInt;
  Profit,
  Sales,
  Purch,
  CommitValue,
  Cleared      :  Double;

  Loop         :  Boolean;
  StoreD       :  Double;

  MyNom,
  CalcNom      :  TNomView;




begin
  With Sender as TSBSOutLineB do
  Begin
    DrawIdxCode:=CalcIdx;

    If (DrawIdxCode>0) then
    Begin
      ONomRec:=Items[DrawIdxCode].Data;

      If (ONomRec<>nil) then
      With ONomRec^,CCDepNHCtrl do
      Begin

        If ((LastPr<>NHPr) or (LastPrTo<>NHPrTo) or (LastYr<>NHYr) or (LastCr<>NHCr) or (LastYTD<>UseYTD)
          or (LastTxCr<>NHTxCr) or (LastCommitMode<>NHCommitView) or (CCNom.NomCode<>OBOMAddr)) and (OutStkCode<>'')
          then
        Begin
          Profit:=0.0; CommitValue:=0.0;

          Loop:=BOff;  StoreD:=0.0;

          MyNom:=TNomView(Self.Owner);

          CalcNom:=MyNom;

          If (MyNom.ObjectClone2.Checked) then
          Begin
            CalcNom:=MyNom.GrandPNom;
          end;


          Repeat
            With CalcNom do
            Begin
              Profit:=0.0; CommitValue:=0.0;


            {$IFDEF SOP}
              If (NHCommitView In [0,1]) then
                Profit:=Profit_to_DateRange(CCNom.NomType,CalcCCKeyHistP(CCNom.NomCode,(OutNomCat=1),OutStkCode),
                                     NCr,NYr,NPr,NPrTo,Purch,Sales,Cleared,UseYTD);

              If (NHCommitView In [1,2]) then
                CommitValue:=Profit_to_DateRange(CCNom.NomType,CommitKey+CalcCCKeyHistP(CCNom.NomCode,(OutNomCat=1),OutStkCode),
                                     NCr,NYr,NPr,NPrTo,Purch,Sales,Cleared,UseYTD);

              Profit:=Profit+CommitValue;

            {$ELSE}
              Profit:=Profit_to_DateRange(CCNom.NomType,CalcCCKeyHistP(CCNom.NomCode,(OutNomCat=1),OutStkCode),
                                     NCr,NYr,NPr,NPrTo,Purch,Sales,Cleared,UseYTD);
            {$ENDIF}

            end;

            Loop:=Not Loop;

            If (MyNom.ObjectClone2.Checked) then
            Begin
              If (Loop) then
              Begin
                CalcNom:=MyNom.ParentNom;
                StoreD:=Profit;
              end;
              {else
                Profit:=Round_Up(StoreD-Profit,2);}
            end;

         Until (Not Loop) or (Not MyNom.ObjectClone2.Checked);

         ColValue:=0;

         If (MyNom.ObjectClone2.Checked) then
         Begin
           LastDrCr[2]:=Round_Up(StoreD-Profit,2);
           LastDrCr[1]:=Calc_Pcnt(StoreD,LastDrCr[2]);

         end
         else
         Begin
            LastDrCr[2]:=Currency_Txlate(Profit,NHCr,NHTxCr);

            LastDrCr[1]:=Calc_Pcnt(TotalBal,LastDrCr[2]);
         end;





          LastPr:=NHPr;

         LastPrTo:=NHPrTo;


          LastYr:=NHYr;
          LastCr:=NHCr;
          LastTxCr:=NHTxCr;
          LastYTD:=UseYTD;
          OBOMAddr:=CCNom.NomCode;
          LastCommitMode:=NHCOmmitView;

          LastSelItem:=0;
        end; {If settings changed..}

        With Items[DrawIdxCode] do
          If (Not HideValue) then
          Begin
            {If ((Not Expanded) or (Not HasItems)) then}
              ColValue:=LastDrCr[SetCol];

            If (SetCol=1) then
              ColFmt:=GenPcntMask
            else
              ColFmt:=GenRealMask;
          end
          else
            ColValue:=0.0;

          ColsX:=ColXAry[SetCol];
      end;
    end; {If found equiv index..}
  end;
end;


procedure TCCDepView.Show_Link;

Begin
  With CCDepNHCtrl,CCNom do
    Caption:=Show_TreeCur(NHCr,NHTxCr)+' '+dbFormatName(Form_Int(NomCode,0),Desc);

  NLOLine.Refresh;

  GLValueF.Value:=TotalBal;
  GLValueF.CurrencySymb:=PSymb(CCDepNHCtrl.NHCr);
  With CCNom do
  GLCaption.Caption:='G/L '+dbFormatName(Form_Int(NomCode,0),Desc);
end;

procedure TCCDepView.Call_History(Index     :  Integer;
                                  ShowGraph,
                                  ShowRecon :  Boolean);

Var
  ONomRec :  ^OutNomType;

begin
  With (NLOLine) do
  Begin
    ONomRec:=Items[Index].Data;

    If (ONomRec<>nil) then
    With ONomRec^ do
    Begin
      ThisCCCode:=OutStkCode;
      ThisCCMode:=(OutNomCat=1);

      Send_UpdateList(44+Ord(ShowGraph)+Ord(ShowRecon));

    end; {WIth..}
  end; {With..}
end;



procedure TCCDepView.HistBtnClick(Sender: TObject);

Var
  DataIndex  :  Integer;
  ThisHist,
  ThisGraph,
  ThisRecon  :  Boolean;


begin
  DataIndex:=NLOLine.SelectedItem;

  If (Sender<>Nil) then
  Begin
    ThisHist:=((Sender=HistBtn) or (Sender=MIHist));
    ThisGraph:=((Sender=GraphBtn) or (Sender=Graph1));
    ThisRecon:=((Sender=ReconBtn) or (Sender=Recon1));

    If ((ThisHist) and (Not InHist)) or ((ThisGraph) and (Not InGraph))
       or ((ThisRecon) and (Not InRecon)) then {Force it through as its coming from a new button}
       LastSelItem:=0;
  end;

  If (DataIndex>0) and (DataIndex<>LastSelItem) then
  With NLOLine do
  Begin
    If (Not Items[DataIndex].HasItems) then
    Begin
      If (Sender<>Nil) then
      Begin
        InHist:=((ThisHist) or (InHist));
        InGraph:=((ThisGraph) or (InGraph));
        InRecon:=((ThisRecon) or (InRecon));
      end;

      LastSelItem:=DataIndex;

      If (InHist or InGraph) then
        Call_History(DataIndex,InGraph,BOff);

      If (InRecon) then
        Call_History(DataIndex,BOn,BOn);

    end;

  end;
end;

procedure TCCDepView.NLOLineDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  If (InHist or InGraph or InRecon) and (Index=NLOLine.SelectedItem)  then
  Begin
    PostMessage(Self.Handle,WM_CustGetRec,1,0);
  end;
end;

end.
