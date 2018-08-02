unit rpinput;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, ComCtrls,
  GlobVar,VarConst,SBSComp,SBSComp2,BTSupU1,ExWrap1U,SupListU, Menus,
  TEditVal, BorBtns, Mask, RwOpenF, RepInp;

type
  TMAMList  =  Class(TGenList )
    Function SetCheckKey  :  Str255; Override;
    Function SetFilter  :  Str255; Override;
    Function Ok2Del :  Boolean; Override;
    Function OutLine(Col  :  Byte)  :  Str255; Override;
  end;

  TRepInputs = class(TForm)
    PnlButt: TPanel;
    PopupMenu1: TPopupMenu;
    Edit1: TMenuItem;
    N3: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    OkBtn: TButton;
    CancelBtn: TButton;
    InpBox: TScrollBox;
    IHedPanel: TSBSPanel;
    IVarLabel: TSBSPanel;
    IDescLabel: TSBSPanel;
    IInpLabel: TSBSPanel;
    IDefLabel: TSBSPanel;
    IVarPanel: TSBSPanel;
    IDescPanel: TSBSPanel;
    IInpPanel: TSBSPanel;
    IDefPanel: TSBSPanel;
    EditBtn: TButton;
    MListBtnPanel: TSBSPanel;
    procedure RRefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RRefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RRefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CancelBtnClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure EditBtnClick(Sender: TObject);
  private
    { Private declarations }
    FClosing,
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord     :  Boolean;
    PagePoint    :  Array[0..3] of TPoint;
    InpLine      : TFrmInpLine;   { Input Line Form }

    procedure Find_FormCoord;
    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;
    procedure PrimeButtons;
    Procedure BuildDesign;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;
    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    Procedure Send_UpdateList(WPar, LPar :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure SetCaption;
  public
    { Public declarations }

    ExLocal      :  TdExLocal;

    ListOfSet    :  Integer;

    MULCtrlO     :  TMAMList;

    RepRec       : RepGenPtr;

    procedure FormDesign;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    procedure ShowLink;
    procedure SetFormProperties;
  end;

Procedure SetRepInputs (Const RepName : ShortString);



Implementation

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  BTSupU2,
  CmpCtrlU,
  ColCtrlU,

  ComnU2,
  CurrncyU,

  RepDet,
  RwPrintR,

  VarFPosU,
  RpCommon,
  RwFuncs;

{$R *.DFM}

Var
  {DDFormMode  :  TNHCtrlRec;}
  ReportName   : ShortString;

{$I RpInput2.PAS}

{ ========= Exported function to set View type b4 form is created ========= }
Procedure SetRepInputs (Const RepName : ShortString);
Begin
  ReportName := RepName;
End;


procedure TRepInputs.Find_FormCoord;
Var
  ThisForm:  TForm;
  VisibleRect:  TRect;
  GlobComp:  TGlobCompRec;
  I        : Integer;
Begin
  New(GlobComp,Create(BOn));

  ThisForm:=Self;

  With GlobComp^ do Begin
    GetValues:=BOn;

    PrimeKey:='M';

    If (GetbtControlCsm(ThisForm)) then Begin
      StoreCoord:=(ColOrd=1);
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then Begin{* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);
        FormResize(Self);
      End; { If }
    end;

    GetbtControlCsm(IHedPanel);
  End; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;


procedure TRepInputs.Store_FormCoord(UpMode  :  Boolean);
Var
  GlobComp : TGlobCompRec;
  I        : Integer;
Begin
  New(GlobComp,Create(BOff));

  With GlobComp^ do Begin
    GetValues:=UpMode;

    PrimeKey:='M';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(IHedPanel);

    GetValues:=UpMode;
    SaveCoord:=StoreCoord;
    PrimeKey:='K';

    If Assigned(MULCtrlO) Then
      MULCtrlO.Store_ListCoord(GlobComp);
  end; {With GlobComp..}

  GlobComp.Destroy;
end;

{ Takes a copy of key positions used for resizing }
procedure TRepInputs.FormSetOfSet;
Begin
  { Take points for button panel }
  PagePoint[0].X:=ClientWidth - PnlButt.Left;
  PagePoint[0].Y:=ClientHeight - PnlButt.Height;

  { Take points for Btrieve List scroll box }
  PagePoint[1].X:=ClientWidth-InpBox.Width;
  PagePoint[1].Y:=ClientHeight-InpBox.Height;

  { Take points for Btrieve Scroll Button Panel }
  PagePoint[2].X:=ClientWidth-MListBtnPanel.Left;
  PagePoint[2].Y:=ClientHeight-MListBtnPanel.Height;

  { Take a point for column heights in the Btrieve List scroll box }
  PagePoint[3].Y:=InpBox.Height-IVarPanel.Height;

  GotCoord:=BOn;
end;


Procedure TRepInputs.WMCustGetRec(Var Message  :  TMessage);
Begin
  With Message Do
    Case WParam of
      0, 169 : Begin { 0 = dbl click on line, 169 = pressed drill down button}
                 If (WParam=169) then
                   MULCtrlO.GetSelRec(BOff);

                 EditBtnClick(EditBtn);
               End;

      { Selected line changed }
      1      : ;

      { pressed right click over list }
      2      : ShowRightMeny(LParamLo,LParamHi,1);

      { Sent when Report Line dialog closes }
      100    : InpLine := Nil;

      { Sent when an update has been performed }
      200..209
             : With MULCtrlO do Begin
                 AddNewRow(MUListBoxes[0].Row,(LParam=1));
               End;

      300..309
             :  With MULCtrlO do
                  If (MUListBox1.Row<>0) then
                    PageUpDn(0,BOn)
                  else
                    InitPage;
    End; { Case }

  Inherited;
end;


{ == Procedure to Send Message to Get Record == }
Procedure TRepInputs.Send_UpdateList(WPar, LPar :  Integer);
Var
  Message1 :  TMessage;
  MessResult :  LongInt;
Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do Begin
    MSg:=WM_CustGetRec;
    WParam := 100 + WPar;
    LParam := LPar;
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);
end; {Proc..}

Procedure TRepInputs.SetCaption;
Begin
  With ExLocal Do
    Caption := 'Input Fields for ''' + Trim(LRepGen^.ReportHed.RepDesc) + '''';
End;

procedure TRepInputs.ShowLink;
begin
  ExLocal.AssignFromGlobal(RepGenF);
  ExLocal.LGetRecAddr(RepGenF);

  SetCaption;

  FormBuildList(BOn);

  { Update lists }
  RefreshList(BOn, BOn);
end;


procedure TRepInputs.FormDesign;
begin
  { Take a copy of positions for resizing }
  FormSetOfSet;

  { Load in the saved coordinates }
  Find_FormCoord;

  { Setup the button control object }
  PrimeButtons;
end;

Procedure TRepInputs.BuildDesign;
Begin
  { Adjust depending on mode }
End;

procedure TRepInputs.PrimeButtons;
Begin
  {  }
End;

procedure TRepInputs.RefreshList(ShowLines,
                                 IgMsg      :  Boolean);
Var
  KeyStart    :  Str255;
  LKeyLen     :  Integer;
Begin
  KeyStart := FullRepKey_NDX(ReportGenCode, RepLineTyp, ReportName);
  LKeyLen  := Length(KeyStart);

  With MULCtrlO do Begin
    IgnoreMsg:=IgMsg;

    StartList(RepGenF,RGK,KeyStart,'','',LKeyLen,(Not ShowLines));

    IgnoreMsg:=BOff;
  End; { With }
end;


procedure TRepInputs.FormBuildList(ShowLines  :  Boolean);
Var
  GlobComp    :  TGlobCompRec;
  StartPanel  :  TSBSPanel;
  n           :  Byte;
Begin
  MULCtrlO := TMAMList.Create(Self);

  Try
    With MULCtrlO do Begin
      Try
        With VisiList do Begin
          AddVisiRec(IVarPanel,  IVarLabel);
          AddVisiRec(IDescPanel, IDescLabel);
          AddVisiRec(IInpPanel,  IInpLabel);
          AddVisiRec(IDefPanel,  IDefLabel);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {HidePanels(0);}

          LabHedPanel:=IHedPanel;

          ListOfSet:=10;

          SetHedPanel(ListOfSet);
        end;
      except
        VisiList.Free;
      end;

      { Get Coordinates/Colours }
      New(GlobComp,Create(BOn));
      With GlobComp^ do Begin
        GetValues:=BOn;
        PrimeKey:='K';
        HasCoord:=LastCoord;
        Find_ListCoord(GlobComp);
      End; { With }
      Dispose(GlobComp, Destroy);

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=3;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOff;

      WM_ListGetRec:=WM_CustGetRec;

      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
        With ColAppear^[n] Do
          AltDefault:=BOn;

      ListLocal:=@ExLocal;

      ListCreate;

      {UseSet4End:=BOn;}

      NoUpCaseCheck:=BOn;

      Set_Buttons(MListBtnPanel);

      ReFreshList(ShowLines,BOff);
    end {With}
  Except
    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;

  FormSetOfSet;

  {FormReSize(Self);}
end;

procedure TRepInputs.FormCreate(Sender: TObject);
Var
  KeyS : Str255;
  n    :  Integer;
begin
  ExLocal.Create;

  FClosing := False;
  LastCoord:=BOff;
  GotCoord := False;

  ClientHeight := 189;
  ClientWidth  := 571;

  MDI_SetFormCoord(TForm(Self));

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;
  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  SetCaption;

  FormDesign;
end;

procedure TRepInputs.FormDestroy(Sender: TObject);
Var
  n  :  Byte;
begin
  ExLocal.Destroy;
end;


procedure TRepInputs.FormCloseQuery(Sender: TObject;
                                          var CanClose: Boolean);
Var
  n  : Integer;

begin
  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  Store_FormCoord(Not SetDefault);
end;

procedure TRepInputs.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If (Not FClosing) And Assigned(MULCtrlO) Then Begin
    FClosing := True;

    MULCtrlO.Destroy;
    MULCtrlO := Nil;
  End; { If (Not FClosing) And Assigned(MULCtrlO)  }

  Action:=caFree;
end;

procedure TRepInputs.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;
begin
  If (GotCoord) then Begin
    LockWindowUpDate(Handle);

    { Resize/position the buttons }
    PnlButt.Left   := ClientWidth - PagePoint[0].X;
    PnlButt.Height := ClientHeight - PagePoint[0].Y;

    { Resize Input Lines Btrieve List scroll box }
    InpBox.Width  := ClientWidth - PagePoint[1].X;
    InpBox.Height := ClientHeight - PagePoint[1].Y;

    { Resize Btrieve List Button Panel }
    MListBtnPanel.Left   := ClientWidth - PagePoint[2].X;
    MListBtnPanel.Height := ClientHeight - PagePoint[2].Y;

    { Resize column heights in the Btrieve List scroll box }
    IVarPanel.Height := InpBox.Height - PagePoint[3].Y;

    If Assigned(MULCtrlO) Then
      With MULCtrlO, VisiList Do Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=IVarPanel.Height;

        ReFresh_Buttons;

        RefreshAllCols;
      End; { With }

    LockWindowUpDate(0);
  End; { If }
end;

procedure TRepInputs.RRefPanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  BarPos     :  Integer;
  PanRSized  :  Boolean;
begin
  If (Sender is TSBSPanel) then
    With (Sender as TSBSPanel) do Begin
      PanRSized:=ReSized;

      BarPos:=InpBox.HorzScrollBar.Position;

      If (PanRsized) then
        MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

      MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);
    end;
end;


procedure TRepInputs.RRefLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;
begin
  If (Sender is TSBSPanel) then
    With (Sender as TSBSPanel) do Begin
      If (Not ReadytoDrag) and (Button=MBLeft) then Begin
        If (MULCtrlO<>nil) then
          MULCtrlO.VisiList.PrimeMove(Sender);
      end
      else
        If (Button=mbRight) then Begin
          ListPoint:=ClientToScreen(Point(X,Y));

          ShowRightMeny(ListPoint.X,ListPoint.Y,0);
        end;
    end;
end;


procedure TRepInputs.RRefLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
    With (Sender as TSBSPanel) do Begin
      If (MULCtrlO<>nil) then
        MULCtrlO.VisiList.MoveLabel(X,Y);
    end;
end;



procedure TRepInputs.SetFormProperties;
Var
  TmpPanel    :  Array[1..3] of TPanel;
  n           :  Byte;
  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;
Begin
  ResetDefaults:=BOff;

  For n:=1 to 3 do Begin
    TmpPanel[n]:=TPanel.Create(Self);
  end;

  try
    With MULCtrlO.VisiList do Begin
      VisiRec:=List[0];

      TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
      TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

      TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
      TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;

      TmpPanel[3].Color:=MULCtrlO.ColAppear^[0].HBKColor;
      TmpPanel[3].Font.Assign(TmpPanel[1].Font);
      TmpPanel[3].Font.Color:=MULCtrlO.ColAppear^[0].HTextColor;
    End;

    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,'Match Properties',BeenChange,ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then Begin
          For n:=1 to 3 do
            With TmpPanel[n] do
              Case n of
                1,2  :  MULCtrlO.ReColorCol(Font,Color,(n=2));

                3    :  MULCtrlO.ReColorBar(Font,Color);
              end; {Case..}

          MULCtrlO.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
        End; { If }
      end;
    finally
      ColourCtrl.Free;
    end;
  Finally
    For n:=1 to 3 do
      TmpPanel[n].Free;
  end;

  If (ResetDefaults) then Begin
    SetDefault:=BOn;
    Close;
  end;
end;

procedure TRepInputs.ShowRightMeny(X,Y,Mode  :  Integer);
Begin
  With PopUpMenu1 do Begin
    PopUp(X,Y);
  end;
end;

procedure TRepInputs.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordFlg.Checked:=StoreCoord;
end;

procedure TRepInputs.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TRepInputs.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord := Not StoreCoord;
end;

Procedure TRepInputs.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);
Begin
  With Message.MinMaxInfo^ do Begin
    ptMinTrackSize.X:=300;
    ptMinTrackSize.Y:=190;
  end;

  Message.Result:=0;

  Inherited;
end;

procedure TRepInputs.ClsCP1BtnClick(Sender: TObject);
begin
  Close;
end;

procedure TRepInputs.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TRepInputs.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TRepInputs.CancelBtnClick(Sender: TObject);
begin
  Close;
End;

procedure TRepInputs.OkBtnClick(Sender: TObject);
begin
  { Print Report }
  AddRepToQueue (ReportName);
  Close;
end;


procedure TRepInputs.EditBtnClick(Sender: TObject);
Var
  WasNew  :  Boolean;
Begin
  WasNew:=BOff;

  { Check we've got a valid line to edit where necessary }
  If MulCtrlO.ValidLine Then Begin
    If Not Assigned(InpLine) then Begin
      SetInpLineDets(IVarPanel, ExLocal.LRepGen, 7);
      InpLine := TFrmInpLine.Create(Self);

      WasNew:=BOn;
    End; { If }

    Try
      With InpLine Do Begin
        WindowState:=wsNormal;

        If (Not ExLocal.InAddEdit) Then Begin
          ExLocal.AssignFromGlobal(RepGenF);
          ExLocal.LGetRecAddr(RepGenF);

          EditLine(True);
        End { If }
        Else
          Show;
      End; { With }
    Except
      InpLine.Free;
      InpLine := Nil;
    End;
  End; { If }
end;

end.
