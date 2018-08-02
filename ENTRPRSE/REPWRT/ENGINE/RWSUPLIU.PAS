unit rwSupLiU;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel,SBSComp,  GlobVar, Menus,CmpCtrlU;

Const
   WM_CustListFinish   =  WM_User+$101;

type
  TRWGenList  =  Class(TMULCtrl)
  public
    UseWildCard  :  Boolean;
    KeyWildM     :  Str255;

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    Procedure Find_ListCoord(GlobComp  :  TGlobCompRec);

    procedure Store_ListCoord(GlobComp  :  TGlobCompRec);


  end;


  TRWPopUpList = class(TForm)
    ListCol1Panel: TSBSPanel;
    ListCol2Panel: TSBSPanel;
    ListCol1Lab: TSBSPanel;
    ListCol2Lab: TSBSPanel;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    BtnPanel: TSBSPanel;
    ListCanBttn: TButton;
    ListOkBttn: TButton;
    ListBtnPanel: TSBSPanel;


    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListCanBttnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListCol1LabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListCol1LabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ListCol1PanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private

   { Private declarations }

   ListOfSet  :  Integer;

   StoreCoord,
   LastCoord,
   SetDefault,
   GotCoord   :  Boolean;

    PageP,
    ScrollAP,
    ScrollBP,
    Misc1P,
    PanelP     :  TPoint;

    InitSize   :  TPoint;

  public
    { Public declarations }

    FFoundOk    :  Boolean;

    OwnList     :  TRWGenList;

    OFnum,
    OKeypath,
    OKLen       :  Integer;

    OKey2F      :  Str255;

    ListPFix    :  Char;

    procedure FormSetOfSet;

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    Procedure WMCustFindRec(Var Message  :  TMessage); message WM_CustListFinish;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;

    Function StartLookup  :  Boolean;

    Procedure Send_StartList(Mode   :  Integer);

    procedure CreateOwnList(TOList     :  TRWGenList;
                            SFnum,
                            SKeypath   :  Integer;
                            Key2F      :  Str255;
                            KLen       :  Integer;
                            CFilters   :  FilterType);

    Procedure FinishList(State  :  Boolean);

    procedure SetFormProperties;

    procedure ShowRightMeny(X,Y,Mode  :  Integer);


  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  VarConst,
  ColCtrlU,
  BTSupU2;

{$R *.DFM}



{ ============ TRWGenList Methods ================= }



Function TRWGenList.SetCheckKey  :  Str255;



Begin
  Result:='';
end;




Function TRWGenList.SetFilter  :  Str255;

Begin

end;


Function TRWGenList.Ok2Del :  Boolean;

Begin
  Result:=BOff;
end;


{ ========== Generic Function to Return Formatted Display for List ======= }

Function TRWGenList.OutLine(Col  :  Byte)  :  Str255;

Begin

end;


Procedure TRWGenList.Find_ListCoord(GlobComp  :  TGlobCompRec);

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
      TmpList.Items[n]:=nil;
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

            If (Not LoopCtrl) and (HasCoord) and (GlobWidth>0) and (GlobHeight>0) then
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
      If (TmpList.Items[n]<>nil) then
        Items[n]:=TmpList.Items[n];
    end;

    TmpList.Free;
  end; {With..}
end; {Proc..}


procedure TRWGenList.Store_ListCoord(GlobComp  :  TGlobCompRec);


Var
  n       :  Integer;

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

{-------------------------------------------------------------------------}



procedure TRWPopUpList.FormSetOfSet;


Begin
  PageP.X:=ClientWidth-(ListBtnPanel.Left)+2;
  PageP.Y:=ClientHeight-(ListBtnPanel.Height)+2;

  {ScrollAP.X:=PageControl1.Width-(ScrollBox5.Width);
  ScrollAP.Y:=PageControl1.Height-(ScrollBox5.Height);

  ScrollBP.X:=PageControl1.Width-(Panel1.Left);
  ScrollBP.Y:=PageControl1.Height-(Panel1.Height);}

  {Misc1P.X:=ListPanel.Height-(ListBtnPanel.Height);}
  Misc1P.Y:=ClientHeight-(ListCol1Panel.Height);

  PanelP.X:=ClientWidth-(BtnPanel.Left);
  PanelP.Y:=ClientHeight-(BtnPanel.Top);


  GotCoord:=BOn;

end;


procedure TRWPopUpList.Find_FormCoord;


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
    PrimeKey:=ListPFix;

    GetValues:=BOn;

    If (GetbtControlCsm(ThisForm)) then
    Begin
      StoreCoord:=(ColOrd=1);
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);

    end;

    GetbtControlCsm(BtnPanel);


    OwnList.Find_ListCoord(GlobComp);

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

      {* Check form is within current visible range *}

  With TForm(Owner) do
    VisibleRect:=Rect(0,0,ClientWidth,ClientHeight);

  If (Not PtInRect(VisibleRect,Point(Left,Top))) then
  Begin
    Left:=TControl(Owner).Width-(Width+10);
    Top:=TControl(Owner).Height-(Height-10);
  end;


end;


procedure TRWPopUpList.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    PrimeKey:=ListPFix;

    GetValues:=UpMode;

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(BtnPanel);

    OwnList.Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;


procedure TRWPopUpList.FormCreate(Sender: TObject);
begin
  FFoundOk:=BOff;


  InitSize.Y:=217;
  InitSize.X:=325;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=240;
  Width:=327;}

  

end;


procedure TRWPopUpList.FormResize(Sender: TObject);

Var
  n  :  Integer;

begin
  If (GotCoord) then
  Begin

    BtnPanel.Left:=(ClientWidth-PanelP.X);
    BtnPanel.Top:=(ClientHeight-PanelP.Y);


     With OwnList,VisiList do
     Begin
       VisiRec:=List[0];

       With (VisiRec^.PanelObj as TSBSPanel) do
         Height:=Self.ClientHeight-Misc1P.Y;

       ReFresh_Buttons;

       RefreshAllCols;

       VisiRec:=List[MUTotCols];

       With (VisiRec^.PanelObj as TSBSPanel) do
       Begin
         ListBtnPanel.Left:=Width+3+Left;
         ListBtnPanel.Height:=Height;
       end;

     end;{with}

     If (StartLookUp) then
       OwnList.MUListBoxes[0].SetFocus;

  end; {If time to update}


end;

procedure TRWPopUpList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=CaFree;
end;

procedure TRWPopUpList.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin

  Store_FormCoord(Not SetDefault);

  CanClose:=BOn;
end;


procedure TRWPopUpList.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {* Disconnected, as form is show modal, and really sure if another form should be
     created during modal state, perhaps best not! *}

  {GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);}
end;


Procedure TRWPopUpList.FinishList(State  :  Boolean);

Begin
  FFoundOk:=State;

  If (FFoundOk) then
    With OwnList do
      RefreshLine(MUListBoxes[0].Row,BOff);

  PostMessage(Handle,WM_Close,0,0);

  {Close;}

end;


procedure TRWPopUpList.ListCanBttnClick(Sender: TObject);
begin
  If (Not OwnList.InListFind) then
    FinishList((Sender=ListOkBttn));
end;

Procedure TRWPopUpList.WMCustFindRec(Var Message  :  TMessage);


Begin

  With Message do
    Case WParam of
      0  :  FinishList(BOn);

      2  :  ShowRightMeny(LParamLo,LParamHi,1);

    9999 :  FinishList(BOff);

    end; {Case..}

  Inherited;
end;


Procedure TRWPopUpList.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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


Procedure TRWPopUpList.WMSysCommand(Var Message  :  TMessage);


Begin
  With Message do
    Case WParam of

      SC_Maximize  :  Begin
                        Self.ClientHeight:=InitSize.Y;
                        Self.ClientWidth:=InitSize.X;

                        WParam:=0;
                      end;

    end; {Case..}

  Inherited;
end;

Function TRWPopUpList.StartLookup  :  Boolean;

Begin


  With OwnList do
  Begin
    StartList(OFnum,OKeyPath,OKey2F,OKey2F,'',OKLen,BOff);
    Result:=Not ExitScan;

  end;

end;


Procedure TRWPopUpList.Send_StartList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=0;
    WParam:=Mode;
  end;

  With Message1 do
    MessResult:=SendMEssage(Self.Handle,Msg,WParam,LParam);

end; {Proc..}

procedure TRWPopUpList.FormShow(Sender: TObject);
begin
  Find_FormCoord;

  FormSetOfSet;

  {* Reset Left pos so it is always relative *}

  Left:=TControl(Owner).Width-(Width+10);
  Top:=TControl(Owner).Height-(Height-10);

  MDI_UpdateParentStat;
end;


procedure TRWPopUpList.CreateOwnList(TOList     :  TRWGenList;
                                   SFnum,
                                   SKeypath   :  Integer;
                                   Key2F      :  Str255;
                                   KLen       :  Integer;
                                   CFilters   :  FilterType);

Var
  StartPanel
     :  TSBSPanel;

  n  :  Integer;


Begin
  OwnList:=TOList;

  OFnum:=SFnum;
  OKeypath:=SKeypath;
  OKey2F:=Key2F;
  OKLen:=KLen;

  Try
    With OwnList do
    Begin
      
      Try

        YieldMessage:=BOn;

        Filter:=CFilters;

        With VisiList do
        Begin
          AddVisiRec(ListCol1Panel,ListCol1Lab);
          AddVisiRec(ListCol2Panel,ListCol2Lab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

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

      WM_ListGetRec:=WM_CustListFinish;

      AbortOnEmpty:=BOn;

      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;
      end;

      ListCreate;

      Set_Buttons(ListBtnPanel);


      AbortOnEmpty:=BOn;

    end; {With..}

  except

    OwnList.Free;
    OwnList:=Nil;

  end;

end;


procedure TRWPopUpList.SetFormProperties;


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

    With OwnList.VisiList do
    Begin

      VisiRec:=List[0];

      TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
      TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

      TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
      TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;

      TmpPanel[3].Color:=OwnList.ColAppear^[0].HBKColor;
    end;

    TmpPanel[3].Font.Assign(TmpPanel[1].Font);

    TmpPanel[3].Font.Color:=OwnList.ColAppear^[0].HTextColor;


    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,Self.Caption+' Properties',BeenChange,ResetDefaults);


        If (BeenChange) and (not ResetDefaults) then
        Begin

          For n:=1 to 3 do
            With TmpPanel[n] do
              Case n of
                1,2  :  OwnList.ReColorCol(Font,Color,(n=2));

                3    :  OwnList.ReColorBar(Font,Color);
              end; {Case..}

          {OwnList.LabHedPanel.Color:=TmpPanel[2].Color;}
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
    GotCoord:=BOff;
    SetDefault:=BOn;
    Close;
  end;

end;

procedure TRWPopUpList.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordFlg.Checked:=StoreCoord;
end;


procedure TRWPopUpList.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);

  end;


end;

procedure TRWPopUpList.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TRWPopUpList.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
end;


procedure TRWPopUpList.ListCol1LabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      OwnList.VisiList.PrimeMove(Sender);
    end
    else
      If (Button=mbRight) then
      Begin
        ListPoint:=ClientToScreen(Point(X,Y));

        ShowRightMeny(ListPoint.X,ListPoint.Y,0);
      end;

  end;
end;


procedure TRWPopUpList.ListCol1LabMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin
    OwnList.VisiList.MoveLabel(X,Y);
  end;

end;

procedure TRWPopUpList.ListCol1PanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

Var
  BarPos :  Integer;



begin
  BarPos:=0;

  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (REsized) then
    Begin
      OwnList.ResizeAllCols(OwnList.VisiList.FindxHandle(Sender),0);

      {Case Current_Page of
        0  :  BarPos:=ScrollBox5.HorzScrollBar.Position;
        1  :  BarPos:=TLSScrollBox.HorzScrollBar.Position;
      end;}

    end;

    OwnList.FinishColMove(BarPos+ListOfset,Resized);
  end;

end;


Initialization

  Application.Title:='Exchequer Enterprise';

end.
