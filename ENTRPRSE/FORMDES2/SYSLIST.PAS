unit syslist;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, SBSPanel, StdCtrls, ExtCtrls, SBSComp, ExWrap1U, SupListU, GlobVar,
  VarConst, BTSupU1, Buttons;

type
  TMAMList  =  Class(TGenList)
    Function SetCheckKey  :  Str255; Override;
    Function SetFilter  :  Str255; Override;
    Function Ok2Del :  Boolean; Override;
    Function OutLine(Col  :  Byte)  :  Str255; Override;
  end;

  TSysFrmLst = class(TForm)
    PnlButt: TPanel;
    CloseBtn: TButton;
    AddBtn: TButton;
    InpBox: TScrollBox;
    IHedPanel: TSBSPanel;
    IVarLabel: TSBSPanel;
    IDescLabel: TSBSPanel;
    IVarPanel: TSBSPanel;
    IDescPanel: TSBSPanel;
    MListBtnPanel: TSBSPanel;
    PopupMenu1: TPopupMenu;
    Edit1: TMenuItem;
    N3: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    EditBtn: TButton;
    DelBtn: TButton;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    CopyBtn: TButton;
    Copy1: TMenuItem;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure RRefPanelMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure RRefLabMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure RRefLabMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure DelBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    StoreCoord,
    LastCoord,
    SetDefault,
    GotCoord     :  Boolean;
    PagePoint    :  Array[0..3] of TPoint;

    procedure FormBuildList(ShowLines  :  Boolean);
    procedure FormDesign;
    procedure Find_FormCoord;
    procedure FormSetOfSet;
    procedure RefreshList(ShowLines, IgMsg : Boolean);
    procedure ShowRightMeny(X,Y,Mode  :  Integer);
    procedure Store_FormCoord(UpMode  :  Boolean);
    procedure SetFormProperties;
    Procedure WMCustGetRec(Var Message : TMessage); Message WM_CustGetRec;
    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
    ExLocal      :  TdExLocal;
    ListOfSet    :  Integer;
    MULCtrlO     :  TMAMList;
  end;

var
  SysFrmLst: TSysFrmLst;

  Procedure SetupFormDefinitions; Export;

implementation

Uses BtrvU2, CmpCtrlU, ColCtrlU, FormUtil, SysFDet, EntLicence;


{$R *.DFM}

{$I SysList2.PAS}


Procedure SetupFormDefinitions;
Var
  TempSyss  : Sysrec;
  PrevCur   : TCursor;
begin
  CursorToHourglass (PrevCur);

  { Take copy of sys record }
  TempSyss := Syss;

  If (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct]) Then
    // IRIS Accounts Office / LITE
    EditGlobalFormDefs
  Else
  Begin
    // Exchequer
    SysFrmLst := TSysFrmLst.Create (Application.MainForm);
    Try
     { Init form here }

      CursorForDialog;
      SysFrmLst.ShowModal;
      CursorFromDialog;
    Finally
      SysFrmLst.Free;
    End;
  End; // Else

  { Restore copy of sys record }
  Syss := TempSyss;

  RestoreCursor (PrevCur);
end;


procedure TSysFrmLst.FormCreate(Sender: TObject);
Var
  N : SmallInt;
begin
  ExLocal.Create;

  LastCoord:=BOff;
  GotCoord := False;

  ClientHeight := 209;
  ClientWidth  := 383;

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;
  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  FormDesign;
end;

procedure TSysFrmLst.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
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

procedure TSysFrmLst.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;
end;

procedure TSysFrmLst.FormDesign;
begin
  { Take a copy of positions for resizing }
  FormSetOfSet;

  { Load in the saved coordinates }
  Find_FormCoord;

  { Setup the list }
  FormBuildList(BOff);
end;


procedure TSysFrmLst.Find_FormCoord;
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

      {* Go get postion, as would not have been set initianly *}
      If (HasCoord) then Begin
        SetPosition(ThisForm);
        FormResize(Self);
      End; { If }
    end;

    GetbtControlCsm(IHedPanel);
  End; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;


procedure TSysFrmLst.Store_FormCoord(UpMode  :  Boolean);
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

procedure TSysFrmLst.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordFlg.Checked:=StoreCoord;
end;

procedure TSysFrmLst.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord := Not StoreCoord;
end;

procedure TSysFrmLst.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;


procedure TSysFrmLst.SetFormProperties;
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

procedure TSysFrmLst.FormBuildList(ShowLines  :  Boolean);
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
      MUTotCols:=1;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;

      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
        With ColAppear^[n] Do
          AltDefault:=BOn;

      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;

      Set_Buttons(MListBtnPanel);

      ReFreshList(ShowLines,BOff);
    end {With}
  Except
    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;
end;

procedure TSysFrmLst.RefreshList(ShowLines, IgMsg : Boolean);
Var
  KeyStart    :  Str255;
  LKeyLen     :  Integer;
Begin
  KeyStart := 'FR';
  LKeyLen  := Length(KeyStart);

  With MULCtrlO do Begin
    IgnoreMsg:=IgMsg;

    StartList(SysF,SysK,KeyStart,'','',LKeyLen,(Not ShowLines));

    IgnoreMsg:=BOff;
  End; { With }
end;

procedure TSysFrmLst.FormActivate(Sender: TObject);
begin
  RefreshList (BOn, BOff);
end;

Procedure TSysFrmLst.WMCustGetRec(Var Message  :  TMessage);
Begin
  With Message Do
    Case WParam of
      { 0 = dbl click on line, 169 = pressed drill down button}
      0, 169 : Begin
                 If (WParam=169) then
                   MULCtrlO.GetSelRec(BOff);

                 AddBtnClick(EditBtn);
               End;

      { Selected line changed }
      1      : DelBtn.Enabled := (Syss.IDCode <> SysNames[FormR]);

      { pressed right click over list }
      2      : ShowRightMeny(LParamLo,LParamHi,1);

      { Sent when Report Line dialog closes }
      100    : {InpLine := Nil};

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

procedure TSysFrmLst.AddBtnClick(Sender: TObject);
Var
  WantEdit, Cont : Boolean;
  SysFrmDet      : TSysFrmDet;
  lDispMode      : Byte;
begin
  If (Sender = EditBtn) Or (Sender = Edit1) Then
    lDispMode := 2
  Else
    If (Sender = AddBtn) Or (Sender = Add1) Then
      lDispMode := 1
    Else
      lDispMode := 4;

  If (lDispMode = 1) Or MulCtrlO.ValidLine Then Begin
    SysFrmDet := TSysFrmDet.Create(Self);
    Try
      With SysFrmDet Do Begin
        DispMode := lDispMode;

        Case DispMode Of
          1 : Begin { Add }
                Cont := ShowNew(BOff);
              End;
          2 : Begin { Edit }
                ShowLink;
                Cont := True;
              End;
          4 : Begin { Copy }
                Cont := ShowNew(BOn);
              End;
        End; { Case }

        { Display Window }
        If Cont Then ShowModal;
      End; { With }
    Finally
      SysFrmDet.Free;
    End;
  End; { If }
end;

procedure TSysFrmLst.DelBtnClick(Sender: TObject);
Var
  KeyS : Str255;
begin
  If MulCtrlO.ValidLine Then Begin
    If (Syss.IDCode <> SysNames[FormR]) Then Begin
      If (MessageDlg ('Are you sure you want to delete the Form Definition ''' + Syss.Formdefs.Descr + '''?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then Begin
        KeyS := Syss.IDCode;

        Ok:=GetMultiRec(B_GetDirect,B_MultLock,KeyS,SysK,SysF,BOn,GlobLocked);

        If Ok and GlobLocked then Begin
          { Delete header record }
          Status:=Delete_Rec(F[SysF],SysF,SysK);
          Report_BError(SysF,Status);

          SendMessage (Self.Handle, WM_CustGetRec, 300, 0);
        End; { If }
      End; { If }
    End { If }
    Else
      MessageDlg ('The ' + GlobDef + ' cannot be deleted', mtWarning, [mbOk], 0);
  End; { If }
end;

procedure TSysFrmLst.ShowRightMeny(X,Y,Mode  :  Integer);
Begin
  With PopUpMenu1 do
    PopUp(X,Y);
end;

procedure TSysFrmLst.RRefPanelMouseUp(Sender: TObject;
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


procedure TSysFrmLst.RRefLabMouseDown(Sender: TObject;
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


procedure TSysFrmLst.RRefLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
    With (Sender as TSBSPanel) do Begin
      If (MULCtrlO<>nil) then
        MULCtrlO.VisiList.MoveLabel(X,Y);
    end;
end;

procedure TSysFrmLst.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TSysFrmLst.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TSysFrmLst.SpeedButton1Click(Sender: TObject);
Const
  FNum    = SysF;
  KeyPath = SysK;
Var
  OutF : TextFile;
  KeyS : Str255;
Begin
  AssignFile (OutF, 'Sys.Txt');
  Rewrite    (OutF);

  Status:=Find_Rec(B_GetFirst,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
  While (Status = 0) Do Begin
    With Syss Do Begin
      Write (OutF, IDCode, '    ');

      If (IDCode = SysNames[FormR]) Then Begin
        Write (OutF, GlobDef);
      End { If }
      Else
        If (Copy(IDCode, 1, 2) = Copy (SysNames[FormR], 1, 2)) Then Begin
          Write (OutF, IntToStr(Ord(IDCode[3])));
        End; { If }

      Writeln (OutF);
    End; { With }

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
  End; { While }

  CloseFile  (OutF);
end;

procedure TSysFrmLst.FormResize(Sender: TObject);
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

{ Takes a copy of key positions used for resizing }
procedure TSysFrmLst.FormSetOfSet;
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

Procedure TSysFrmLst.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);
Begin
  With Message.MinMaxInfo^ do Begin
    ptMinTrackSize.X:=300;
    ptMinTrackSize.Y:=190;
  end;

  Message.Result:=0;

  Inherited;
end;

end.
