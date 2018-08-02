unit CCListU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel,
  GlobVar,VarConst,SBSComp,SBSComp2,BTSupU1,ExWrap1U,SupListU, Menus,EntWindowSettings,

  {$IFDEF NP}
    DiarLstU,
  {$ENDIF}

  CCInpU;


type


  TCCMList  =  Class(TGenList)

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function CheckRowEmph :  Byte; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

  end;

type
  TCCDepList = class(TForm)
    CSBox: TScrollBox;
    CCPanel: TSBSPanel;
    DescPanel: TSBSPanel;
    CHedPanel: TSBSPanel;
    CBtnPanel: TSBSPanel;
    CListBtnPanel: TSBSPanel;
    ClsCP1Btn: TButton;
    CCBSBox: TScrollBox;
    AddBtn: TButton;
    EditBtn: TButton;
    DelBtn: TButton;
    TagBtn: TButton;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    ClrBtn: TButton;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    Tag1: TMenuItem;
    Clear1: TMenuItem;
    N2: TMenuItem;
    DescLab: TSBSPanel;
    CCLab: TSBSPanel;
    NteBtn: TButton;
    Notes1: TMenuItem;
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure CCPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CCLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CCLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure TagBtnClick(Sender: TObject);
    procedure ClrBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure NteBtnClick(Sender: TObject);
  private
        { Private declarations }

    RecMode,
    BeenIn,
    JustCreated,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    fFrmClosing,
    fDoingClose,
    GotCoord,
    CanDelete    :  Boolean;

    PagePoint    :  Array[0..4] of TPoint;

    StartSize,
    InitSize     :  TPoint;

    CCDepRec     :  TCCDepRec;

    {$IFDEF NP}
      NoteCtrl   :  TDiaryList;
    {$ENDIF}
    FWindowSettings: IWindowSettings;   ////HV 09/03/2016 2016-R2 ABSEXCH-16396 : AV when closing CC or Dept screen while resize screen
    procedure Find_FormCoord;

    procedure Store_FormCoord;

    procedure FormSetOfSet;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    procedure Display_Rec(Mode  :  Byte);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;


    procedure Get_Notes;


    {$IFDEF NP}
      Procedure NoteUpdate(NewLineNo  :  LongInt);
    {$ENDIF}

    procedure SetHelpContextIDs; // NF: 12/05/06

  public
    { Public declarations }

    ExLocal      :  TdExLocal;

    ListOfSet    :  Integer;

    MULCtrlO     :  TCCMList;


    procedure FormDesign;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    procedure SetCaption;

    procedure SetFormProperties;

  end;


  Procedure Set_CCFormMode(State  :  Boolean);

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

  ComnUnit,
  ComnU2,
  CurrncyU,
  InvListU,

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}

  SysU1,
  SysU2,
  {IntMU,
  MiscU,
  PayF2U,
  Warn1U,}
  SQLUtils,
  SalTxl1U,
  PWarnU,
  UA_Const;

{$R *.DFM}



Var
  CCFormMode  :  Boolean;







{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_CCFormMode(State  :  Boolean);

Begin

  CCFormMode:=State;

end;


{$I CCTI1U.PAS}





Procedure  TCCDepList.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TCCDepList.Find_FormCoord;
begin
  //GS: 04/04/11 ABSEXCH-10804 changed the load form settings code to use the new IWindowSettings interface object
  //populate the object with setting data stored in the database
  FWindowSettings.LoadSettings;
  //extract the form settings and apply them to the given form object
  FWindowSettings.SettingsToWindow(self);
  //extract the multi list settings and apply them to the multi control object
  FWindowSettings.SettingsToParent(MULCtrlO);
  //'SettingsToWindow' resizing the form with non default coords will trigger the FormResize event, inadvertently
  //making 'NeedCUpdate' true, so, force 'need coordinate update' to false, we only want it true when the user resizes the form
  fNeedCUpdate := False;
  //record the new form dimensions that 'SettingsToWindow' has just loaded
  //so the program can determine if the form has been resized or not
  StartSize.X := Self.Width;
  StartSize.Y := Self.Height;
end;//end Find_FormCoord

procedure TCCDepList.Store_FormCoord;
Begin
  //GS: 04/05/11 ABSEXCH-10804 changed old 'store form settings' code to use the new IWindowSettings interface object
  //load the form, and the multi list controls settings into the IWindowSettings object
  FWindowSettings.WindowToSettings(self);
  FWindowSettings.ParentToSettings(MULCtrlO,MULCtrlO);
  //store the settings inside the database; coordinate settings
  //are saved if the user selected the 'save' popup menu command
  FWindowSettings.SaveSettings(StoreCoord);
end;//end Store_FormCoord

procedure TCCDepList.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(CBtnPanel.Left);
  PagePoint[0].Y:=ClientHeight-(CBtnPanel.Height);

  PagePoint[1].X:=ClientWidth-(CSBox.Width);
  PagePoint[1].Y:=ClientHeight-(CSBox.Height);

  PagePoint[3].X:=CBtnPanel.Height-(CCBSBox.Height);
  PagePoint[3].Y:=CSBox.ClientHeight-(CCPanel.Height);

  PagePoint[4].Y:=CBtnPanel.Height-(CListBtnPanel.Height);

  GotCoord:=BOn;

end;



Procedure TCCDepList.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      0,169
         :  Begin
              If (WParam=169) then
                MULCtrlO.GetSelRec(BOff);

              //PR: 09/03/2009 Added check for edit allowed.
              if Edit1.Enabled then
                AddBtnClick(Edit1);

            end;

      {$IFDEF NP}

       1  :  Begin
               If (Assigned(NoteCtrl)) then
               With NoteCtrl, PassWord.CostCtrRec do
               Begin
                 TNKey:=FullNCode(PCostC);
                 SetCaption(dbFormatName(PCostC,CCDesc));
                 ShowLink(BOff,BOff);
               end;


             end;

      {$ENDIF}


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


      202:  CCDepRec:=nil;

      {$IFDEF NP}
        213  :  NoteCtrl:=nil;

        250  :  NoteUpdate(LParam);

      {$ENDIF}


    end; {Case..}

  end;
  Inherited;
end;


{ == Procedure to Send Message to Get Record == }

Procedure TCCDepList.Send_UpdateList(Mode   :  Integer);

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


Procedure TCCDepList.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

procedure TCCDepList.SetCaption;

Var
  LevelStr  :  Str255;

Begin

  Caption:=CostCtrTitle[RecMode]+' List';

  If (Not RecMode) then
    CCLab.Caption:='Dep';

end;



procedure TCCDepList.FormDesign;


begin
  If (ICEDFM=2) then
    AddBtn.Visible:=BOff;

  Add1.Visible:=AddBtn.Visible;

end;





procedure TCCDepList.RefreshList(ShowLines,
                               IgMsg      :  Boolean);

Var
  KeyStart    :  Str255;
  LKeypath,
  LKeyLen     :  Integer;
  WhereClause :  string;
  RecPFix, SubType: string;
Begin

  KeyStart:=PartCCKey(CostCCode,CSubCode[RecMode]);
  LKeyLen:=Length(KeyStart);

{
  if (SQLUtils.UsingSQL) then
  begin
    RecPFix := SQLUtils.GetDBColumnName(SetDrive + FileNames[PwrdF], 'rec_pfix', '');
    SubType := SQLUtils.GetDBColumnName(SetDrive + FileNames[PwrdF], 'sub_type', '');
    WhereClause := RecPFix + ' = ''' + CostCCode + ''' AND ' +
                   SubType + ' = ' + IntToStr(Ord(CSubCode[RecMode]));
  end
  else
}
    WhereClause := '';

  With MULCtrlO do
  Begin
    IgnoreMsg:=IgMsg;

    StartList(PWrdF,PWK,KeyStart,'','',LKeyLen,(Not ShowLines), WhereClause);

    IgnoreMsg:=BOff;
  end;

end;


procedure TCCDepList.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TCCMList.Create(Self);
  StartPanel := nil;

  Try

    With MULCtrlO do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(CCPanel,CCLab);
          AddVisiRec(DescPanel,DescLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {HidePanels(0);}

          LabHedPanel:=CHedPanel;

          ListOfSet:=10;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;




      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=1;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;
      {ChooseXCol:=BOn;}

      WM_ListGetRec:=WM_CustGetRec;

      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;


      end;


      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOff;

      NoUpCaseCheck:=BOn;

      HighLiteStyle[1]:=[fsBold];
      HighLiteStyle[2]:=[fsItalic];
      HighLiteStyle[3]:=[fsBold,fsItalic];

      Set_Buttons(CListBtnPanel);

      ReFreshList(ShowLines,BOff);



    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;



  FormSetOfSet;
  Find_FormCoord;
  FormReSize(Self);

  RefreshList(BOn,BOn);

end;


procedure TCCDepList.FormCreate(Sender: TObject);

Var
  n  :  Integer;
  FormMode: String;

begin
  fFrmClosing:=BOff;
  fDoingClose:=BOff;
  ExLocal.Create;

  LastCoord:=BOff;

  NeedCUpdate:=BOff;

  JustCreated:=BOn;

  InitSize.Y:=217;
  InitSize.X:=362;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=244;
  Width:=370;}


  BeenIn:=BOff;

  RecMode:=CCFormMode;
  SetCaption;

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;


  {$IFDEF NP}
    NoteCtrl:=Nil;
  {$ENDIF}

  CCDepRec:=nil;

  DelBtn.Enabled:=(ICEDFM=0);
  Delete1.Enabled:=DelBtn.Enabled;

  //PR 26/01/2009 Enable/Disable Add, Edit & Delete buttons according to new v6.01 passwords
  //PR: 09/03/2009 Forgot to set right menu buttons - doh!
  AddBtn.Enabled  := (RecMode and ChkAllowed_In(uaAddCostCentre)) or
                     (not RecMode and  ChkAllowed_In(uaAddDepartment));
  Add1.Enabled := AddBtn.Enabled;

  EditBtn.Enabled := (RecMode and ChkAllowed_In(uaEditCostCentre)) or
                     (not RecMode and  ChkAllowed_In(uaEditDepartment));
  Edit1.Enabled := EditBtn.Enabled;

  DelBtn.Enabled  := DelBtn.Enabled and ((RecMode and ChkAllowed_In(uaDeleteCostCentre)) or
                       (not RecMode and  ChkAllowed_In(uaDeleteDepartment)));
  Delete1.Enabled := DelBtn.Enabled;

  FormDesign;

  //GS: 04/05/11 ABSEXCH-10804 get an IWindowSettings interface object instance used for storing the forms settings
  //this form is used for both Cost Centre and Department; determine what it's intended use is
  //by looking at the 'CCFormMode' boolean
  if(CCFormMode) then
    FormMode := 'CostCentreList'
  else
    FormMode := 'DepartmentList';
  //load a settings record from the database corresponding to the forms current mode (CC or Dept)
  FWindowSettings := EntWindowSettings.GetWindowSettings(FormMode);
  FormBuildList(BOff);

  SetHelpContextIDs; // NF: 12/05/06 Fix for incorrect Context IDs
end;



procedure TCCDepList.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;

  {$IFDEF NP}
    If (Assigned(NoteCtrl)) then
    Begin
      NoteCtrl.Free;
      NoteCtrl:=nil;
    end;


  {$ENDIF}
end;

procedure TCCDepList.FormCloseQuery(Sender: TObject;
                              var CanClose: Boolean);
Var
  n  : Integer;

begin
  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;

    Try
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
        Store_FormCoord;

      Send_UpdateList(48+Ord(RecMode));
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;

end;

procedure TCCDepList.FormClose(Sender: TObject; var Action: TCloseAction);
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
        begin
          MULCtrlO:=nil;
          //GS: 04/05/11 ABSEXCH-10804 Dereference IWindowSettings interface object
          FWindowSettings := NIL;
        end;
      end;
    end;

  end;
end;


procedure TCCDepList.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) then
  Begin

    CBtnPanel.Left:=ClientWidth-PagePoint[0].X;

    CBtnPanel.Height:=ClientHeight-PagePoint[0].Y;


    CSBox.Width:=ClientWidth-PagePoint[1].X;
    CSBox.Height:=ClientHeight-PagePoint[1].Y;

    CCBSBox.Height:=CBtnPanel.Height-PagePoint[3].X;

    CListBtnPanel.Height:=CBtnPanel.Height-PagePoint[4].Y;

    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO,VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=CSBox.ClientHeight-PagePoint[3].Y;

        RefreshAllCols;
      end;

      LockWindowUpDate(0);

      MULCtrlO.ReFresh_Buttons;

      MULCtrlO.LinkOtherDisp:=BOn;

    end;{Loop..}


    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end;





procedure TCCDepList.SetFormProperties;


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

end;

procedure TCCDepList.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;


procedure TCCDepList.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;


end;



procedure TCCDepList.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TCCDepList.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;





procedure TCCDepList.ClsCP1BtnClick(Sender: TObject);
begin
  Close;
end;

procedure TCCDepList.CCPanelMouseUp(Sender: TObject; Button: TMouseButton;
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

    BarPos:=CSBox.HorzScrollBar.Position;

    If (PanRsized) then
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);
  end;

end;



procedure TCCDepList.CCLabMouseMove(Sender: TObject; Shift: TShiftState; X,
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

procedure TCCDepList.CCLabMouseDown(Sender: TObject; Button: TMouseButton;
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


procedure TCCDepList.Display_Rec(Mode  :  Byte);

Var
  WasNew  :  Boolean;

  Begin
    WasNew:=BOff;


    If (CCDepRec=nil) then
    Begin
      CCDepRec:=TCCDepRec.Create(Self);
      
      WasNew:=BOn;

    end;

    Try


     With CCDepRec do
     Begin
       CCDepMode:=RecMode;

       ExLocal.AssignFromGlobal(PWrdF);

       WindowState:=wsNormal;

       If (Mode In [1..3]) then
       Begin

         Case Mode of

           1..2  :   If (Not ExLocal.InAddEdit) then
                       EditLine((Mode=2))
                     else
                       Show;
              3  :  If (Not ExLocal.InAddEdit) then
                       DeleteBOMLine(PWrdF,PWK);
                     else
                       Show;

         end; {Case..}

       end;



     end; {With..}


    except

     CCDepRec.Free;
     CCDepRec:=nil;
    end;

  end;



procedure TCCDepList.AddBtnClick(Sender: TObject);
begin
  If (Assigned(MULCtrlO)) then
    With MULCtrlO do
    Begin
      {$IFDEF NP}
        If (Assigned(NoteCtrl)) then
          NoteCtrl.Close;
      {$ENDIF}


      GetSelRec(BOff);

      {$B-}
      If (TComponent(Sender).Tag=1) or (ValidLine) then
      {$B+}
        Display_Rec(TComponent(Sender).Tag);
    end;
end;

procedure TCCDepList.TagBtnClick(Sender: TObject);
begin
  With MULCtrlO,ExLocal,LPassWord,CostCtrRec do
  Begin
    GetSelRec(BOff);

    AssignFromGlobal(PWrdF);


    Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyRef,KeyPAth,ScanFileNum,BOff,GlobLocked);

    If (Ok) and (GlobLocked) then
    Begin
      LGetRecAddr(ScanFileNum);

      CCTag:=Not CCTag;

      Status:=Put_Rec(F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,KeyPAth);

      Report_Berror(ScanFileNum,Status);

      {* Explicitly remove multi lock *}

      UnLockMLock(ScanFileNum,LastRecAddr[ScanFileNum]);

      PageUpDn(0,BOn);
    end;
  end;

end;




procedure TCCDepList.ClrBtnClick(Sender: TObject);

Var
  KeyS,
  KeyChk    :    Str255;

  GLocked   :    Boolean;

  MsgForm   :    TForm;

  mbRet     :    Word;


Begin

  GLocked:=BOff;

  mbRet:=MessageDlg('Please Confirm you wish to clear all tags',mtConfirmation,[mbYes,mbNo],0);

  if (mbRet=mrYes) then
  Begin
    MsgForm:=CreateMessageDialog('Please Wait.... Clearing Tags...',mtInformation,[mbAbort]);
    MsgForm.Show;
    MsgForm.Update;

    With ExLocal,MULCtrlO do
    Begin

      KeyChk:=KeyRef;

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[ScanFileNum],ScanFilenum,LRecPtr[ScanFilenum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
      With LPassWord,CostCtrRec do
      Begin

        If (CCTag) then
        Begin
          Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyRef,KeyPAth,ScanFileNum,BOn,GLocked);

          If (Ok) and (GLocked) then
          Begin
            LGetRecAddr(ScanFileNum);

            CCTag:=BOff;

            Status:=Put_Rec(F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,KeyPAth);

            Report_Berror(ScanFileNum,Status);

            {* Explicitly remove multi lock *}

            UnLockMLock(ScanFileNum,LastRecAddr[ScanFileNum]);


          end;
        end;

        Status:=Find_Rec(B_GetNext,F[ScanFileNum],ScanFilenum,LRecPtr[ScanFilenum]^,Keypath,KeyS);

      end; {While..}

      PageUpDn(0,BOn);

    end; {With..}

    MsgForm.Free;
  end;
end; {Proc..}






procedure TCCDepList.FormActivate(Sender: TObject);
begin
  If (Assigned(MULCtrlO))  then
    MULCtrlO.SetListFocus;

end;


procedure TCCDepList.Get_Notes;

Var
  WasNew  :  Boolean;

Begin
  {$IFDEF NP}
    WasNew:=Not Assigned(NoteCtrl);

    With ExLocal,PassWord.CostCtrRec do
      Set_NFormMode(FullNCode(PCostC),NoteDpCode[RecMode],1,NLineCount);

    If (WasNew) then
    Begin
      NoteCtrl:=TDiaryList.Create(Self);


    end;


    try
      With NoteCtrl do
      Begin
        With PassWord.CostCtrRec do
          SetCaption(dbFormatName(PCostC,CCDesc));

        Show;

      end;
    except
      NoteCtrl.Free;
      NoteCtrl:=nil;

    end;
  {$ENDIF}
end;

procedure TCCDepList.NteBtnClick(Sender: TObject);
begin
  {$IFDEF NP}

    If (Assigned(MULCtrlO)) then
      If (MULCtrlO.ValidLine) then
        Get_Notes;

  {$ENDIF}
end;


{$IFDEF NP}

  Procedure TCCDepList.NoteUpdate(NewLineNo  :  LongInt);


  Const
    Fnum     =  PWrdF;
    Keypath  =  PWK;


  Var
    KeyChk,
    KeyS    :  Str255;

    HoldMode:  Byte;

    B_Func  :  Integer;

    LOk,
    Locked,
    TmpBo   :  Boolean;


  Begin

    Locked:=BOff;

    KeyS:=FullCCKey(CostCCode,CSubCode[RecMode],NoteCtrl.NotesCtrl.GetFolio);

    With ExLocal do
    Begin
      LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

      If (LOk) and (Locked) then
      With LPassWord.CostCtrRec do
      Begin
        LGetRecAddr(Fnum);

        NLineCount:=NewLineNo;

        Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,Keypath);

        Report_BError(Fnum,Status);
        {* Explicitly remove multi lock *}

        UnLockMLock(Fnum,LastRecAddr[Fnum]);
      end;

    end; {With..}

  end; {Func..}

{$ENDIF}

// NF: 12/05/06 Fix for incorrect Context IDs
procedure TCCDepList.SetHelpContextIDs;
begin
  ClsCP1Btn.HelpContext := 1756;
  if CCFormMode then
  begin
    // Cost Centre List
    AddBtn.HelpContext := 1757;
    EditBtn.HelpContext := 1758;
    DelBtn.HelpContext := 1759;
    TagBtn.HelpContext := 1760;
    ClrBtn.HelpContext := 1761;
    HelpContext := 1767;
  end else
  begin
    // Department List
    AddBtn.HelpContext := 1762;
    EditBtn.HelpContext := 1763;
    DelBtn.HelpContext := 1764;
    TagBtn.HelpContext := 1765;
    ClrBtn.HelpContext := 1766;
    HelpContext := 1768;
  end;{if}
end;


Initialization


end.
