unit RetLTL1U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, ComCtrls, BTSupU1,GlobVar, VarConst,SBSComp,SBSComp2,
  ExWrap1U, Menus, SupListU, RetLTR1U, Animate;

type

  TRNMList  =  Class(TGenList)

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;


type
  TRetLTList = class(TForm)
    PageControl1: TPageControl;
    ItemPage: TTabSheet;
    PListBtnPanel: TSBSPanel;
    PBtnPanel: TSBSPanel;
    P1BSBox: TScrollBox;
    AddBtn: TButton;
    Clsd1Btn: TButton;
    D1SBox: TScrollBox;
    PHedPanel: TSBSPanel;
    PDescLab: TSBSPanel;
    PYNPanel: TSBSPanel;
    PDescPanel: TSBSPanel;
    PYNLab: TSBSPanel;
    PopupMenu1: TPopupMenu;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    Edit1: TMenuItem;
    EditBtn: TButton;
    DelBtn: TButton;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Clsd1BtnClick(Sender: TObject);
    procedure PYNLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PYNLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PYNLabMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure AddBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    BeenIn,
    JustCreated,
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord,
    fNeedCUpdate,
    fDoingClose,
    CanDelete    :  Boolean;

    PagePoint    :  Array[0..4] of TPoint;

    StartSize,
    InitSize     :  TPoint;

    DNDepRec     :  TRetLineType;


    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    procedure Display_Rec(Mode  :  Byte);

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

  public
    { Public declarations }

    ExLocal      :  TdExLocal;

    ListOfSet    :  Integer;

    MULCtrlO     :  TRNMList;


    procedure FormDesign;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);


    procedure SetFormProperties;

    procedure Auto_SetNewList(Fnum,Keypath  :  Integer);


  end;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  BTSupU2,
  BTSupU3,
  BTKeys1U,
  CmpCtrlU,
  ColCtrlU,

  TEditVal,
  ComnUnit,
  ComnU2,
  CurrncyU,
  GenWarnU,
  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  SysU1,
  SysU2;
  {IntMU,
  MiscU,
  PayF2U,
  Warn1U,}

{$R *.DFM}



{$I RTLTIU.PAS}


Procedure  TRetLTList.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TRetLTList.Find_FormCoord;


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

    PrimeKey:='R';

    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
      StoreCoord:=BOff;
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);

    end;

    GetbtControlCsm(PageControl1);

    GetbtControlCsm(D1SBox);

    GetbtControlCsm(PListBtnPanel);

    GetbtControlCsm(PBtnPanel);

    MULCtrlO.Find_ListCoord(GlobComp);

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

  {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TRetLTList.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin


  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='R';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(PageControl1);

    StorebtControlCsm(PBtnPanel);

    StorebtControlCsm(D1SBox);

    StorebtControlCsm(PListBtnPanel);

    MULCtrlO.Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;



procedure TRetLTList.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[2].X:=PageControl1.Width-(PBtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(PBtnPanel.Height);

  PagePoint[1].X:=PageControl1.Width-(D1SBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(D1SBox.Height);

  PagePoint[3].X:=PBtnPanel.Height-(P1BSBox.Height);
  PagePoint[3].Y:=D1SBox.ClientHeight-(PYNPanel.Height);

  PagePoint[4].Y:=PBtnPanel.Height-(PListBtnPanel.Height);

  GotCoord:=BOn;

end;



Procedure TRetLTList.WMCustGetRec(Var Message  :  TMessage);

Var
  TmpStat      :  Integer;
  TmpRecAddr   :  LongInt;

Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      0,169
         :  Begin
              MULCtrlO.GetSelRec(BOff);

              AddBtnClick(Edit1);

            end;



      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      25 :  NeedCUpdate:=BOn;

      116
          :  Begin
               With MULCtrlO do
               Begin
                 AddNewRow(MUListBoxes[0].Row,(LParam=1));
               end;
            end;

      117 :  With MULCtrlO do
             Begin
               If (MUListBox1.Row<>0) then
                 PageUpDn(0,BOn)
                else
                  InitPage;
             end;


      202:  DNDepRec:=nil;


    end; {Case..}

  end;
  Inherited;
end;



Procedure TRetLTList.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

{ == Procedure to Send Message to Get Record == }

Procedure TRetLTList.Send_UpdateList(Mode   :  Integer);

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
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}






procedure TRetLTList.FormDesign;


begin

  DelBtn.Visible:=SBSIn;
  
end;


procedure TRetLTList.RefreshList(ShowLines,
                               IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  LKeypath,
  LKeyLen     :  Integer;

Begin

  KeyStart:=PartCCKey(RetRLCode,RetPFCode);
  
  LKeyLen:=Length(KeyStart);

  With MULCtrlO do
  Begin
    IgnoreMsg:=IgMsg;

    StartList(MiscF,MIK,KeyStart,'','',LKeyLen,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;

end;


procedure TRetLTList.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin

  MULCtrlO:=TRNMList.Create(Self);
  StartPanel := nil;

  Try

    With MULCtrlO do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(PYNPanel,PYNLab);
          AddVisiRec(PDescPanel,PDescLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {HidePanels(0);}

          LabHedPanel:=PHedPanel;

          ListOfSet:=10;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;


      Find_FormCoord;

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=1;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n=0) then
        Begin
          DispFormat:=SGFloat;
          NoDecPlaces:=0;
        end;
      end;


      ListLocal:=@ExLocal;

      Filter[1,1]:=FullNomKey(-1);

      ListCreate;

      UseSet4End:=BOff;

      NoUpCaseCheck:=BOn;

      Set_Buttons(PListBtnPanel);

      ReFreshList(ShowLines,BOff);

    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;



  FormSetOfSet;

  FormReSize(Self);


  RefreshList(BOn,BOn);


end;


procedure TRetLTList.Auto_SetNewList(Fnum,Keypath  :  Integer);

Var
  mbRet  :  Word;
  n      :  Integer;
  TS     :  TStringList;
Begin
  mbRet:=CustomDlg(Application.MainForm,'Auto Create Line Reason','Create Line Reasons',
                                'No Return Line Reasons currently exist.'+#13+#13+
                                'Please confirm the creation of default Line Reason Codes.'+#13+#13+
                                '(These can be subsequently amended).',mtConfirmation,[mbOk,mbCancel]);

  If (mbRet=MrOk) then
  With Exlocal, LMiscRecs^,rtReasonRec do
  Begin
    TS:=TStringList.Create;

    With TS do
    try
      XSet_RetLineStat(TS);

      For n:=0 to Pred(Count) do
      Begin
        LResetRec(Fnum);

        RecMfix:=RetRLCode;
        SubType:=RetPFCode;

        ReasonCount:=N;
        CustomKey:=SetPadNo(Form_Int(ReasonCount,0),4);

        ReasonDesc:=TS[n];

        Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        Report_BError(Fnum,Status);

      end;

    Finally
      TS.Free;
    end; {try..}
  end;

end;




procedure TRetLTList.FormCreate(Sender: TObject);
Var
  RectD       :  TRect;

  n           :  Integer;

  KeyS        :  Str255;


begin

  fDoingClose:=BOff;

  ExLocal.Create;

  LastCoord:=BOff;

  JustCreated:=BOn;
  NeedCUpdate:=BOff;

  InitSize.Y:=338;
  InitSize.X:=425;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=360;
  Width:=530;}

  DNDepRec:=nil;



  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;


  FormDesign;

  KeyS:=PartCCKey(RetRLCode,RetPFCode);

  With ExLocal, LMiscRecs^ do
  Begin
    Status:=Find_Rec(B_GetGEq,F[MiscF],MiscF,LRecPtr[MiscF]^,MIK,KeyS);

    If (Not StatusOk) or ((RecMFix<>RetRLCode) or (SubType<>RetPFCode)) then
      Auto_SetNewList(MiscF,MIK);
  end;


  FormBuildList(BOff);

  MDI_SetFormCoord(TForm(Self));

  

end;




procedure TRetLTList.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;


end;

procedure TRetLTList.FormCloseQuery(Sender: TObject;
                             var CanClose: Boolean);
Var
  n  : Integer;

begin
  For n:=0 to Pred(ComponentCount) do
  If (Components[n] is TScrollBox) then
  With TScrollBox(Components[n]) do
  Begin
    VertScrollBar.Position:=0;
    HorzScrollBar.Position:=0;
  end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  If (NeedCUpdate) then
    Store_FormCoord(Not SetDefault);


  Send_UpdateList(44);
end;

procedure TRetLTList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

    If (MULCtrlO<>nil) then
    Begin
      try
        MULCtrlO.Destroy;
      finally
        MULCtrlO:=nil;
      end;
    end;
  end;
end;


procedure TRetLTList.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) then
  Begin


    PageControl1.Width:=ClientWidth-PagePoint[0].X;
    PageControl1.Height:=ClientHeight-PagePoint[0].Y;


    PBtnPanel.Left:=PageControl1.Width-PagePoint[2].X;

    PBtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

    D1SBox.Width:=PageControl1.Width-PagePoint[1].X;
    D1SBox.Height:=PageControl1.Height-PagePoint[1].Y;

    P1BSBox.Height:=PBtnPanel.Height-PagePoint[3].X;


    PListBtnPanel.Height:=PBtnPanel.Height-PagePoint[4].Y;
    PListBtnPanel.Left:=D1SBox.Left+D1SBox.Width+2;

    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO,VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
        Begin
          Height:=D1SBox.ClientHeight-PagePoint[3].Y;
        end;

        RefreshAllCols;
      end;

      MULCtrlO.ReFresh_Buttons;
      LockWindowUpDate(0);

    end;{Loop..}

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
  end; {If time to update}
end;





procedure TRetLTList.SetFormProperties;


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
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,Caption+' Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then
        Begin

          For n:=1 to 3 do
            With TmpPanel[n] do
              Case n of
                1,2  :  Begin
                          MULCtrlO.ReColorCol(Font,Color,(n=2));
                        end;

                3    :  Begin
                          MULCtrlO.ReColorBar(Font,Color);
                        end;

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

end;


procedure TRetLTList.Display_Rec(Mode  :  Byte);

Var
  WasNew  :  Boolean;

  Begin
    WasNew:=BOff;

    If (DNDepRec=nil) then
    Begin
      DNDepRec:=TRetLineType.Create(Self);

      WasNew:=BOn;

    end;

    Try


     With DNDepRec do
     Begin
       ExLocal.AssignFromGlobal(IncF);

       WindowState:=wsNormal;

       If (Mode In [1..5]) then
       Begin

         Case Mode of

           1,2
                 :   If (Not ExLocal.InAddEdit) then
                       EditLine((Mode=2),Mode)
                     else
                       Show;
           3  :  If (Not ExLocal.InAddEdit) then
                       DeleteBOMLine(MiscF,MIK);
                     else
                       Show;


         end; {Case..}

       end;



     end; {With..}


    except

     DNDepRec.Free;

    end;

  end;


procedure TRetLTList.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;



procedure TRetLTList.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TRetLTList.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;

procedure TRetLTList.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordFlg.Checked:=StoreCoord;

end;

procedure TRetLTList.Clsd1BtnClick(Sender: TObject);
begin
  Close;
end;

procedure TRetLTList.PYNLabMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      If (MULCtrlO<>nil) then
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


procedure TRetLTList.PYNLabMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO<>nil) then
    Begin
      MULCtrlO.VisiList.MoveLabel(X,Y);
      NeedCUpdate:=MULCtrlO.VisiList.MovingLab;
    end;
  end;

end;

procedure TRetLTList.PYNLabMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  Var
  BarPos :  Integer;
  PanRSized
         :  Boolean;

begin

  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    PanRSized:=ReSized;

    BarPos:=D1SBox.HorzScrollBar.Position;

    If (PanRsized) then
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);
    NeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);
  end;

end;



procedure TRetLTList.AddBtnClick(Sender: TObject);
begin
  If (Assigned(MULCtrlO)) then
  With MULCtrlO do
  Begin
    {$B-}
      If (TComponent(Sender).Tag=1) or (ValidLine) then
    {$B+}
        Display_Rec(TComponent(Sender).Tag);
  end;
end;

procedure TRetLTList.FormActivate(Sender: TObject);
begin
  If (Assigned(MULCtrlO))   then
    MULCtrlO.SetListFocus;
end;



end.
