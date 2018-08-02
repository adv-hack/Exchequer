unit RepTree;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Buttons, Grids, SBSOutl, ExtCtrls, SBSPanel, Menus, StdCtrls,
  GlobVar, VarConst, BtSupU1, RepDet, RPDefine, RPBase, RPFiler, RwOpenF,
  OutLine;

type
  TForm_RepTree = class(TForm)
    Panel_Footer: TSBSPanel;
    Bevel6: TBevel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel_Outline: TSBSPanel;
    NLDPanel: TPanel;
    NLRunPanel: TPanel;
    SBSPanel2: TSBSPanel;
    db1BtnPanel: TSBSPanel;
    db1BSBox: TScrollBox;
    Clsdb1Btn: TButton;
    NLOLine: TSBSOutlineC;
    PopupMenu1: TPopupMenu;
    Edit1: TMenuItem;
    Notes1: TMenuItem;
    Copy1: TMenuItem;
    Delete1: TMenuItem;
    Print1: TMenuItem;
    Add2: TMenuItem;
    MIFind: TMenuItem;
    Expand1: TMenuItem;
    MIETL: TMenuItem;
    MIEAL: TMenuItem;
    EntireGeneralLedger1: TMenuItem;
    MIColl: TMenuItem;
    MICTL: TMenuItem;
    EntireGeneralLedger2: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    Panel1: TPanel;
    FilePan: TPanel;
    N3: TMenuItem;
    SaveDialog1: TSaveDialog;
    TmpFontLbl: TLabel;
    Popup_View: TMenuItem;
    BtnPan1: TSBSPanel;
    BtnPan2: TSBSPanel;
    BtnPan3: TSBSPanel;
    AddBtn: TButton;
    EditBtn: TButton;
    DeleteBtn: TButton;
    FindBtn: TButton;
    PrintBtn: TButton;
    NotesBtn: TButton;
    CopyBtn: TButton;
    ViewBtn: TButton;
    ConvBtn: TButton;
    Popup_Convert: TMenuItem;
    LayBtn: TButton;
    procedure NLOLineNeedValue(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MIFindClick(Sender: TObject);
    procedure MIEALClick(Sender: TObject);
    procedure NLOLineExpand(Sender: TObject; Index: Longint);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Clsdb1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NLOLineDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure AddBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure ConvBtnClick(Sender: TObject);
    procedure ViewBtnClick(Sender: TObject);
    procedure LayBtnClick(Sender: TObject);
  private
    { Private declarations }
    InitSize     :  TPoint;

    RepActive    : Boolean;   { True if rep detail form is active }
    StopDetail   : Boolean;   { If True detail window isn't displayed on expand }

    LastCoord,
    SetDefault,
    StoreCoord   : Boolean;
    ColXAry      : Array[1..3] of LongInt;

    RepDetail    : TReportRec;

    EditNode     : TSBSOutLNode;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;

    {Procedure Add_OutLines(      Depth,
                                 DepthLimit,
                                 OIndex        :   LongInt;
                                 RepGroup      :   Str20;
                           Const Fnum,
                                 Keypath       :   Integer);}
    Function CheckSecurity(GrpCode : Str20; GrpIdx : LongInt) : Boolean;
    {Procedure Drill_OutLines(Depth,
                             DepthLimit,
                             PIndex      :  LongInt);}

    Procedure Update_OutLines;
    Procedure Delete_OutLines(PIndex      :  LongInt;
                              DelSelf     :  Boolean);
    Function FormLineText(ONomRec : OutNomType) : String;

    Function GetRepGenRec : Boolean;
    procedure SetFormProperties;

    procedure Find_FormCoord;
    procedure Store_FormCoord(UpMode  :  Boolean);

    function  FindReportCode(RepCode : String) : Integer;
    {Procedure PlaceRepCode(FindCode : String);}
    procedure Display_Report (Mode : Byte;Const ChangeFocus : Boolean);

    Procedure WMDayBkGetRec(Var Message  :  TMessage); Message WM_CustGetRec;
    Procedure WMRWPrint(Var Message  :  TMessage); Message WM_PrintRep;
    Procedure WMRWExport(Var Message  :  TMessage); Message WM_ExportRep;
    procedure UpdateRepTree(var Msg: TMessage); message WM_UpdateTree;

    procedure RepLink;

    {Procedure PlaceRepCode2(Const FindRep : String; Const Select : Boolean);}
    procedure SetButts;

    Procedure AddRepNode(Const ParentIdx : LongInt;
                         Const TheRep    : RepGenRec;
                         Const Select    : Boolean);

    Procedure Add_OutLines2(Const RepGroup  : Str20;
                            Const ParentIdx : LongInt);

    Procedure FindAndShowReport(Const RepName : ShortString; Const Select : Boolean);

    Function RepPWordOK(Const ONomRec : OutNomType) : Boolean;
  public
    { Public declarations }
    Procedure AddEditLine(OpStat : Byte);
  end;

var
  Form_RepTree: TForm_RepTree;

  Procedure ConvertReport (Const RpName : ShortString; Const Ask : Boolean);

implementation

{$R *.DFM}

Uses
  BtrvU2,
  BtSupU2,
  EtStrU,
  EtDateU,
  VarFPosU,
  RwFuncs,
  RWPrintR,
  ColCtrlU,
  CmpCtrlU,
  PWarnU,
  LayRep,
  PWordDlg,
  RpCommon;

Const
  {InitWidth  =  118;}
  TDpth      =  70;


Procedure TForm_RepTree.WMSysCommand(Var Message  :  TMessage);
Begin
  With Message do
    Case WParam of
      SC_Maximize  :  Begin
                        Self.ClientHeight:=InitSize.Y;
                        Self.ClientWidth:=InitSize.X;

                        WParam:=0;
                      end;
    End; { Case }

  Inherited;
end;




procedure TForm_RepTree.Find_FormCoord;
Var
  ThisForm    : TForm;
  VisibleRect : TRect;
  GlobComp    : TGlobCompRec;
Begin
  New(GlobComp,Create(BOn));

  ThisForm:=Self;

  With GlobComp^ do Begin
    GetValues:=BOn;

    PrimeKey:='S';

    If (GetbtControlCsm(ThisForm)) then Begin
      StoreCoord:=(ColOrd=1);
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);
    end;

    If GetbtControlCsm(NLOLine) then
      NLOLine.BarColor:=ColOrd;

    If GetbtControlCsm(NLDPanel) then
      NLOLine.BarTextColor:=ColOrd;

    GetbtControlCsm(NLRunPanel);

    GetbtControlCsm(Panel_Footer);
  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

  {* Check form is within current visible range *}

  With TForm(Owner) do
    VisibleRect:=Rect(0,0,ClientWidth,ClientHeight);

  If (Not PtInRect(VisibleRect,Point(Left,Top))) then Begin
    Left:=0;
    Top:=0;
  end;
end;


procedure TForm_RepTree.Store_FormCoord(UpMode  :  Boolean);
Var
  GlobComp:  TGlobCompRec;
Begin
  New(GlobComp,Create(BOff));

  With GlobComp^ do Begin
    GetValues:=UpMode;

    PrimeKey:='S';

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

    StorebtControlCsm(NLRunPanel);

    StorebtControlCsm(Panel_Footer);
  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;


Procedure TForm_RepTree.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);
Begin
  With Message.MinMaxInfo^ Do Begin
    ptMinTrackSize.X:=390;
    ptMinTrackSize.Y:=220;

    {ptMaxSize.X:=530;
    ptMaxSize.Y:=368;
    ptMaxPosition.X:=1;
    ptMaxPosition.Y:=1;}
  End; { With }

  Message.Result:=0;

  Inherited;
end;


procedure TForm_RepTree.FormCreate(Sender: TObject);
begin
  { Load the list with the root reports/groups }
  //Add_OutLines(0,2,0,'',RepGenF,RGK);
  Add_OutLines2('', 0);

  InitSize.X   := 550;
  InitSize.Y   := 343;

  ClientHeight := InitSize.Y;
  ClientWidth  := InitSize.X;

  {MDI_SetFormCoord(TForm(Self));}

  Find_FormCoord;

  { Set security }
  If (Not ChkAllowed_In(194)) Then Begin
    { Hide buttons }
    BtnPan1.Visible := False;
    BtnPan2.Top := BtnPan1.Top;
    BtnPan3.Visible := False;

    { hide options on popup menu }
    Add2.Visible := False;
    Edit1.Visible := False;
    Delete1.Visible := False;
    Copy1.Visible := False;
    Popup_View.Visible := False;
    Popup_Convert.Visible := False;
  End; { If }

  SetButts;
end;

procedure TForm_RepTree.FormClose(Sender: TObject;
  var Action: TCloseAction);
Var
  N       :  LongInt;
  ONomRec :  ^OutNomType;
begin
  { Tidy up outline data objects }
  With NLOLine do
    For N := 1 To ItemCount Do Begin
      If Assigned(Items[N].Data) Then Begin
        ONomRec:=Items[N].Data;
        Dispose(ONomRec);
      End; { If Assigned }
    End;

  { Close the detail window if its still open }
  If (RepActive) and Assigned(RepDetail) Then Begin
    RepDetail.Free;
    RepActive:=BOff;
  end;

  { free form memory }
  Action:=caFree;
end;

procedure TForm_RepTree.FormResize(Sender: TObject);
Var
  NW : LongInt;
begin
  { calc new outline width }
  NW := Panel_Outline.Width - (2 * NLOLine.Left);

  { Resize bevel }
  Bevel6.Width := Panel_Footer.Width - (2 * Bevel6.Left);

  { Resize Button Panel }
  db1BtnPanel.Height := SBSPanel2.Height - db1BtnPanel.Top;

  { resize button scroll box }
  Db1BSBox.Height := db1BtnPanel.Height - Db1BSBox.Top - 3;

  { resize outline column headers }
  NLRunPanel.Left := NLOLine.Left + (NW - NLRunPanel.Width) - 15;
  NLDPanel.Width := NLRunPanel.Left - NLDPanel.Left - 2;

  If (NLRunPanel.Left < 230) Then Begin
    { starting to overwrite report names - hide run column }
    NLOLine.ShowVALCol := 0;
    NLRunPanel.Visible := False;

    NLDPanel.Width := NW - 15;
  End { If }
  Else
    If (NLOLine.ShowVALCol = 0) Then Begin
      NLOLine.ShowVALCol := 1;
      NLRunPanel.Visible := True;
    End; { If }

  { update column positions }
  ColXAry[1] := NLRunPanel.Left;

  { Resize Outline control }
  NLOLine.Height := Panel_Outline.Height - NLOLine.Top;
  NLOLine.Width  := NW;

  Update_OutLines;
end;

procedure TForm_RepTree.NLOLineNeedValue(Sender: TObject);
Var
  ONomRec      :  ^OutNomType;
  DrawIdxCode  :  LongInt;
begin
  With Sender as TSBSOutLineC do Begin
    DrawIdxCode:=CalcIdx;

    If (DrawIdxCode>0) Then Begin
      ONomRec:=Items[DrawIdxCode].Data;

      If (ONomRec<>nil) Then
        With ONomRec^ Do Begin
          (*If (DrawIdxCode=SelectedItem) then Begin
            DeleteBtn.Enabled := Ok2DelRep (Copy(OBOMLink, 11, 10));
            PrintBtn.Enabled := (OutNomType <> RepHedTyp);
            NotesBtn.Enabled := (OutNomType <> RepHedTyp);
            CopyBtn.Enabled := (OutNomType <> RepHedTyp);
            LayoutBtn.Enabled := (OutNomType <> RepHedTyp);

            Panel5.Caption:=DoubleAmpers (Copy(OBOMLink, 11, 10));

            If (OutNomType <> RepHedTyp) And (OutNomCode In [1..High(DataFilesL^)]) Then
              FilePan.Caption := DataFilesL^[OutNomCode]
            Else
              FilePan.Caption := '';
          End; { If }*)

          If (OutNomCode <> 0) Then Begin
            ColValue := Trim(POutDateB(OutStkCat));

            If (Trim(OutStkCode) <> '') Then
              ColValue := Trim(ColValue + ' by ' + Trim(OutStkCode));
          End; { If }

          With Items[DrawIdxCode] Do
            ColsX:=ColXAry[SetCol];
        End; { With }
    End; { If }
  End; { With }
end;


Function TForm_RepTree.CheckSecurity(GrpCode : Str20; GrpIdx : LongInt) : Boolean;
Begin { CheckSecurity }
  Result := True;

(*
  { Check Group is set }
  If (Trim(GrpCode) <> '') And (GrpIdx <> 0) Then Begin
    Result := MessageDlg('Check Password for ' + GrpCode + ' (' + Trim(NLOLine.Items[GrpIdx].Text) + ')',
                         mtConfirmation,
                         [mbYes, mbNo],
                         0) = mrYes;


  End; { If (Trim(GrpCode) <> '') And (GrpIdx <> 0) }
*)
End; { CheckSecurity }


{ performs the initial load of root reports/groups }
(*
Procedure TForm_RepTree.Add_OutLines(      Depth,
                                           DepthLimit,
                                           OIndex        :   LongInt;
                                           RepGroup      :   Str20;
                                     Const Fnum,
                                           Keypath       :   Integer);


Var
  KeyS, KeyChk           :  Str255;
  LineText               :  String;
  SpcWidth, NewIdx, NewObj, TmpRecAddr  :  LongInt;
  TmpStat, TmpKPath      :  Integer;
  ONomRec                :  ^OutNomType;
Begin
  If CheckSecurity(RepGroup, OIndex) Then Begin
    TmpKPath:=Keypath;

    With NLOLine Do Begin
      SpcWidth:=NLOLine.Canvas.TextWidth(' ');

      KeyChk:=FullRepKey_NDX (ReportGenCode, RepGroupCode, RepGroup);

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
        With RepGenRecs^, ReportHed Do Begin
          New(ONomRec);
          FillChar(ONomRec^,Sizeof(ONomRec^),0);
          With ONomRec^ Do Begin
            OBOMLink   := ReportKey;     { Report Group + Report Code }
            OutNomCode := DriveFile;     { Driving File No }
            OutStkCat  := LastRun;       { Last Date Run }
            OutStkCode := LastOpo;       { Last printed by }

            OutDepth:=Depth;
            BeenDepth:=DepthLimit;
            OutNomType:=RepType;

            LastYTD := (RepType <> RepHedTyp) And (DefFont.fSize = 0);
          End; { With }

          {LineText:=Spc(1*Depth)+LJVar(Desc,ChrWidth-(20*Depth))}

          {LineText:=FormatLine(ONomRec^,Strip('R',[#32],Desc[1]));}

          NewIdx:=AddChildObject(OIndex,FormLineText(ONomRec^),ONomRec);

          If (RepType=RepHedTyp) and (Depth<DepthLimit) then
          Begin
            TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

            Add_OutLines(Depth+1,DepthLimit,NewIdx,RepName,Fnum,Keypath);

            TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);
          end;

          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
        End; {While..}
      End; {With..}
  End; { If CheckSecurity }
end; {Proc..}
*)
(*
Procedure TForm_RepTree.Drill_OutLines(Depth,
                                       DepthLimit,
                                       PIndex      :  LongInt);
Var
  NextChild       :  LongInt;
  ONomRec         :  ^OutNomType;
  LoopCtrl        :  Boolean;
Begin
  LoopCtrl:=BOff;

  With NLOLine Do Begin
    If (Depth<DepthLimit) then Begin
      ONomRec:=Items[PIndex].Data;

      Repeat
        Case LoopCtrl of
          BOff  :  NextChild:=Items[PIndex].GetFirstChild;
          BOn   :  NextChild:=Items[PIndex].GetNextChild(NextChild);
        end; {Case..}

        If (ONomRec<>Nil) then
        With ONomRec^ do
        Begin
          If (NextChild<1) then {* Try and find more for this level *}
          Begin
            If (Not LoopCtrl) and (Not HedTotal) then
            Begin
              Add_OutLines(Depth,DepthLimit,PIndex,Copy(OBOMLink, 11, 10),RepGenF,RGK);

              ONomRec:=Items[PIndex].Data;
            end;
          end
          else
            Drill_OutLines(Depth+1,DepthLimit,NextChild);
        end;

        If (Not LoopCtrl) then
          LoopCtrl:=BOn;

      Until (NextChild<1);

    end; {If limit reached..}

  end; {With..}
end; {Proc..}
*)

Procedure TForm_RepTree.Update_OutLines;
Const
  Fnum    = RepGenF;
  Keypath = RGK;
Var
  KeyS     : Str255;
  LineText : String;
  N        : LongInt;
  ONomRec  : ^OutNomType;
Begin
  With NLOLine do Begin
    BeginUpdate;

    For n:=1 to ItemCount do Begin
      ONomRec:=Items[n].Data;

      If (ONomRec<>Nil) Then
        With ONomRec^, RepGenRecs^ Do Begin
          KeyS:=FullRepKey_RGK (ReportGenCode, RepGroupCode, OBOMLink);

          Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

          If StatusOk Then Begin
            { update last run info }
            OutStkCat  := ReportHed.LastRun;       { Last Date Run }
            OutStkCode := ReportHed.LastOpo;       { Last printed by }

            Items[n].Text:=FormLineText(ONomRec^);
          End; { If }
        End; { With }
    End; { For }

    EndUpdate;
  end; {With..}
end; {Proc..}


{ Returns a string formatted to display in the outline }
Function TForm_RepTree.FormLineText(ONomRec : OutNomType) : String;
Begin
  With RepGenRecs^, ONomRec Do Begin
    Result := Spc(1*OutDepth)+Strip('R',[#32],ReportHed.RepDesc);
    Result := Result+Spc(Round((NLOLine.Width-Canvas.TextWidth(Result))/CanVas.TextWidth(' '))-(TDpth*OutDepth));
  end;
end;


{ ======= Function to find the node a report code resides at ======= }
function TForm_RepTree.FindReportCode(RepCode : String) : Integer;
Var
  n          : Integer;
  FoundOk    : Boolean;
  ONom       : OutNomType;
Begin
  FoundOk:=BOff;

  With NLOLine do
    For n:=1 to ItemCount do Begin
      ONom := OutNomType(Items[n].Data^);

      FoundOk:=(Copy(ONom.OBOMLink, 11, 10) = RepCode);

      If (FoundOk) then
        Break;
    End; { For }

  If (FoundOk) then
    Result:=n
  else
    Result:=-1;
end;

(*
Procedure TForm_RepTree.PlaceRepCode(FindCode : String);
Const
  Fnum       = RepGenF;
  Keypath    = RGNdxK;
Var
  FoundOk            : Boolean;
  FoundCode, TmpKey  : String;
  KeyS               : Str255;
  n                  : Integer;
  FoundLong          : LongInt;
Begin
  FoundOk:=(RepGenRecs^.ReportHed.RepName=FindCode);

  { make sure we've got the record loaded }
  If (Not FoundOk) then Begin
    KeyS:=FullRepKey_NDX(ReportGenCode, RepGroupCode, FindCode);
    FoundOk:=GetReport(KeyS,FoundCode);
  end;
  TmpKey := RepGenRecs^.ReportHed.ReportKey;

  If (FoundOk) then Begin
    { load the parent group, if any }
    KeyS:=FullRepKey_NDX(ReportGenCode, RepGroupCode, RepGenRecs^.ReportHed.RepGroup);

    If (Not EmptyKey(RepGenRecs^.ReportHed.RepGroup,RepGrpLen)) then
      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (Not EmptyKey(RepGenRecs^.ReportHed.RepGroup,RepGrpLen)) do {* Get to top of this branch *}
    Begin
      KeyS:=FullRepKey_NDX(ReportGenCode, RepGroupCode, RepGenRecs^.ReportHed.RepGroup);

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    end;

    n:=FindReportCode(RepGenRecs^.ReportHed.ReportKey);

    If (n<>-1) then
      With NLOLine do Begin
        BeginUpdate;
        Items[n].FullExpand;
        EndUpdate;

        n:=FindReportCode(TmpKey);

        If (n<>-1) then
          SelectedItem:=n;

        NLOLine.Refresh;
      end;
  end;
end;*)

procedure TForm_RepTree.MIFindClick(Sender: TObject);
Var
  InpOk, FoundOk :  Boolean;
  FoundCode      :  String;
  FoundLong      :  LongInt;
  n,INCode       :  Integer;
  SCode          :  String;
  KeyS           :  Str255;
Begin
  SCode:='';

  Repeat
    FoundOk := False;
    InpOk:=InputQuery('Find Report','Please enter the report code you wish to find',SCode);

    If (InpOk) Then Begin
      SCode := UpperCase(SCode);
      FoundOk:=GetReport(SCode,FoundCode);
    End; { If }
  Until FoundOk or (Not InpOk);

  If FoundOk Then
    {PlaceRepCode2(RepGenRecs^.ReportHed.RepName, True);}
    FindAndShowReport(RepGenRecs^.ReportHed.RepName, True);
end;

(*
Procedure TForm_RepTree.PlaceRepCode2(Const FindRep : String; Const Select : Boolean);
Const
  FNum    : Integer = RepGenF;
  KeyPath : Integer = RGNdxK;
Var
  TmpRep             : ^RepGenRec;
  KeyS               : Str255;
  TmpFn              : FileVar;
  TmpStat, I, ItemNo : Integer;
  TmpRecAddr         : LongInt;
  ONom               : OutNomType;
Begin
  { get record matching FindRep }
  KeyS   := FullRepKey (ReportGenCode, RepGroupCode, FindRep);
  Status := Find_Rec (B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

  If StatusOk Then Begin
    { Do any parents in the tree }
    If (Trim(RepGenRecs^.ReportHed.RepGroup) <> '') Then Begin
      { Save record and position of record }
      New (TmpRep);
      TmpRep^ := RepGenRecs^;
      TmpFn:=F[FNum];
      TmpStat:=Presrv_BTPos(Fnum,KeyPath,TmpFn,TmpRecAddr,BOff,BOff);

      { expand parent }
      PlaceRepCode2(RepGenRecs^.ReportHed.RepGroup, False);

      { Restore record and position }
      TmpStat:=Presrv_BTPos(Fnum,KeyPath,TmpFn,TmpRecAddr,BOn,BOff);
      Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}
      RepGenRecs^ := TmpRep^;
      Dispose (TmpRep);
    End; { If }

    With NLOLine Do Begin
      { find this record in tree }
      ItemNo := 0;
      For I := 1 To ItemCount Do Begin
        If Assigned(Items[I].Data) Then Begin
          ONom := OutNomType(Items[I].Data^);

          If (Copy(ONom.OBOMLink, 11, 10) = FindRep) Then Begin
            ItemNo := I;
            Break;
          End; { If }
        End; { If }
      End; { For }

      If Select Then
        { select item representing FindRep }
        NLOLine.SelectedItem := ItemNo
      Else
        { Expand }
        NLOLine.Items[ItemNo].Expand;
    End; { With }
  End; { If }
End;
*)

procedure TForm_RepTree.MIEALClick(Sender: TObject);
begin
  If (Sender is TMenuItem) then
    With NLOLine do Begin
      StopDetail := True;

      Case TMenuItem(Sender).Tag of
        1  :  Items[SelectedItem].Expand;
        2  :  Items[SelectedItem].FullExpand;
        3  :  FullExpand;
        4  :  Items[SelectedItem].Collapse;
        5  :  FullCollapse;
      end; {case..}

      StopDetail := False;
    end;
end;

procedure TForm_RepTree.NLOLineExpand(Sender: TObject; Index: Longint);
Var
  Depth   :  LongInt;
  ONomRec :  ^OutNomType;
begin
  With (Sender as TSBSOutLineC) do Begin
    { Extract details from selected node }
    ONomRec:=Items[Index].Data;

    If Assigned(ONomRec) Then
      With ONomRec^ Do
        Case OutNomType Of
          { 'H' - Group - continue drilling down tree structure }
          RepGroupCode  : Begin
                            { Check for password }
                            If RepPWordOK(ONomRec^) Then Begin
                              If (Not MoreLink) Then
                                Add_OutLines2(Copy(OBOMLink, 11, 10), Index);
                            End; { If RepPWordOK }
                          End;

          { 'N' - Nominal Based Report }
          RepNomCode,
          { 'R' - Standard Report }
          ReportGenCode : If (Not StopDetail) Then
                            Display_Report (3, BOn);
        End; { Case }
  end; {With..}
end;

procedure TForm_RepTree.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
end;

Function TForm_RepTree.GetRepGenRec : Boolean;
Const
  Fnum    = RepGenF;
  Keypath = RGK;
Var
  ONomRec  : ^OutNomType;
  KeyS     : Str255;
Begin
  Result := False;

  With NLOLine Do
    If (SelectedItem > 0) Then Begin
      ONomRec := Items[SelectedItem].Data;

      KeyS := FullRepKey_RGK(ReportGenCode, RepGroupCode, ONomRec^.OBOMLink);

      Status := Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      Result := StatusOk;
    End; { If }
End;

procedure TForm_RepTree.PopupMenu1Popup(Sender: TObject);
Var
  n        : Integer;
  ONomRec  :  ^OutNomType;
begin
  StoreCoordFlg.Checked:=StoreCoord;

  N3.Tag:=Ord(ActiveControl Is TSBSOutLineC);

  { get current selected record }
  With NLOLine Do Begin
    ONomRec := Nil; { Just In Case }

    If (SelectedItem > 0) Then
      ONomRec := Items[SelectedItem].Data;

    If Assigned (ONomRec) Then Begin
      { Got a selected item }
      Edit1.Enabled := (Not ONomRec^.IsDummy);
      Delete1.Enabled := Ok2DelRep(Copy (ONomRec^.OBomLink, 11, 10)) And (Not ONomRec^.IsDummy);
      Print1.Enabled := (ONomRec^.OutNomType <> RepHedTyp) And (Not ONomRec^.IsDummy);
      Notes1.Enabled := (ONomRec^.OutNomType <> RepHedTyp) And (Not ONomRec^.IsDummy);
      Copy1.Enabled := (ONomRec^.OutNomType <> RepHedTyp) And (Not ONomRec^.IsDummy);
      Popup_View.Enabled := (ONomRec^.OutNomType <> RepHedTyp) And (Not ONomRec^.IsDummy);
      Popup_Convert.Enabled := ONomRec^.LastYTD;
    End { If }
    Else Begin
      { no selected item }
      Edit1.Enabled := False;
      Delete1.Enabled := False;
      Print1.Enabled := False;
      Notes1.Enabled := False;
      Copy1.Enabled := False;
      Popup_View.Enabled := False;
      Popup_Convert.Enabled := False;
    End; { Else }

    { Disable if no items found }
    MIFind.Enabled := (ItemCount > 0);
    Expand1.Enabled := (ItemCount > 0);
    MIColl.Enabled := (ItemCount > 0);
  End; { With }
end;


procedure TForm_RepTree.SetFormProperties;
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
    With NLOLine Do Begin
      TmpPanel[1].Font:=Font;
      TmpPanel[1].Color:=Color;

      TmpPanel[2].Font:=NLDPanel.Font;
      TmpPanel[2].Color:=NLDPanel.Color;


      TmpPanel[3].Color:=BarColor;
      TmpPanel[3].Font.Assign(TmpPanel[1].Font);
      TmpPanel[3].Font.Color:=BarTextColor;
    end;

    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,Self.Caption+' List Properties',BeenChange,ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then Begin
          With NLOLine Do Begin
            Font.Assign(TmpPanel[1].Font);
            Color:=TmpPanel[1].Color;

            NLDPanel.Font.Assign(TmpPanel[2].Font);
            NLDPanel.Color:=TmpPanel[2].Color;

            BarColor:=TmpPanel[3].Color;
            BarTextColor:=TmpPanel[3].Font.Color;

            NLRunPanel.Font.Assign(TmpPanel[2].Font);
            NLRunPanel.Color:=TmpPanel[2].Color;

            Panel_Footer.Font.Assign(TmpPanel[2].Font);
            Panel_Footer.Color:=TmpPanel[2].Color;
          End; { With }
        end;
      end;
    finally
      ColourCtrl.Free;
    end;
  Finally
    For n:=1 to 3 do
      TmpPanel[n].Free;
  End;

  If (ResetDefaults) then Begin
    SetDefault:=BOn;
    Close;
  end;
end;

procedure TForm_RepTree.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
  N3.Tag:=0;
end;

procedure TForm_RepTree.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  If (CanClose) then
    Store_FormCoord(Not SetDefault);

  SendMessage ((Owner as TForm).Handle, WM_FormCloseMsg, 100, 0);
end;

procedure TForm_RepTree.Clsdb1BtnClick(Sender: TObject);
begin
  Close;
end;

{ Displays the report detail window depending on mode }
{ Mode: 0-Add, 1-Edit, 2-Delete, 3-View, 4-Notes, 10 - Copy }
procedure TForm_RepTree.Display_Report (      Mode        : Byte;
                                        Const ChangeFocus : Boolean);
Var
  State   : TNHCtrlRec;
  ONomRec : ^OutNomType;
Begin
  GetRepGenRec;

  If (Not ChkAllowed_In(194)) Then
    Mode := 4;

  If Not Assigned(RepDetail) then Begin
    FillChar(State, Sizeof(State), 0);
    State.NHMode := Mode;
    SetRepDetMode (State);

    RepDetail := TReportRec.Create(Self);
  End; { If }

  Try
    RepActive := BOn;

    With RepDetail do Begin
      WindowState := wsNormal;

      { Enable / Disable relevent tabs }
      {SetTabs;}

      { Display }
      If ChangeFocus Then
        Show;

      { Check to see if detail form is adding/editing }
      If (Not ExLocal.InAddEdit) then Begin
        { Take copy of node for any later updates }
        If (NLOLine.SelectedItem > 0) Then Begin
          EditNode := NLOLine.Items[NLOLine.SelectedItem];

          ONomRec:=EditNode.Data;
        End; { If }

        ShowLink;

        If ChangeFocus Then ChangePage(0);

        Case Mode Of
          0  : Begin { Adding }
                 If (NLOLine.SelectedItem > 0) Then Begin
                   { Get parent for report }
                   ONomRec:=NLOLine.Items[NLOLine.SelectedItem].Data;
                   RepParent := Copy(ONomRec^.OBOMLink, 1, 10);
                   If (Trim(RepParent) = '') And (ONomRec^.OutNomType = RepHedTyp) Then
                     RepParent := Copy(ONomRec^.OBOMLink, 11, 10);
                 End { If }
                 Else
                   RepParent := FullRepCode('');

                 { display report window }
                 EditRep(False);
               End;
          1  : EditRep(True);
          2  : DeleteRep;
          3  : ViewRep;
          4  : ViewNotes;
        End; { Else }
      end;
    end; {With..}
  except
   RepActive := BOff;
   RepDetail.Free;
  end;
End;

Procedure TForm_RepTree.WMDayBkGetRec(Var Message  :  TMessage);
Begin
  With Message do Begin
    Case WParam of
      { Sent when update done in repdet }
      100   : Begin
                RepDetail.ExLocal.AssignToGlobal(RepGenF);
                //AddEditLine((LParam=1));
                AddEditLine(LParam);
                SetButts;
              End;


      200,              { Sent during CloseQuery of RepDet }
      300   : Begin      { Sent whan a report is deleted }
                RepActive := BOff;
                RepDetail := nil;

                If (WParam=300) then
                  With NLOLine do
                    If (SelectedItem>=0) then Begin
                      Delete_OutLines(SelectedItem,BOn);
                      Refresh;
                    End; { If }

                SetButts;
             End;

      { Sent To Do Find }
      400  : Begin
               MIFindClick(Self);
             End;
    end; {Case..}
  end;

  Inherited;
end;

{ Called to update the list }
Procedure TForm_RepTree.AddEditLine(OpStat : Byte);
Var
  ParentIdx, RepIdx  : LongInt;
  ONomRec            : ^OutNomType;
  ParentNode         : TSBSOutLNode;
Begin
  With NLOLine, RepGenRecs^.ReportHed Do Begin
    Case OpStat Of
      { Added }
      1 : Begin
            { Find Parent }
            If (Trim(RepGroup) <> '') Then
              ParentIdx := FindReportCode(RepGroup)
            Else
              ParentIdx := 0;

            { Check parent exists in tree }
            If (ParentIdx >= 0) Then
              { Add report as node of parent and select }
              AddRepNode (ParentIdx, RepGenRecs^, False);

            FindAndShowReport(RepName, True);
          End;

      { Parent Changed }
      2 : Begin
            { Find previous entry in tree and remove }
            RepIdx := FindReportCode(RepName);
            If (RepIdx > 0) Then Begin
              { Find parent of moved report }
              ParentNode := Items[RepIdx].Parent;

              { Remove report }
              Delete_OutLines(RepIdx, True);

              { Check to see if parent node needs rebuilding }
              If Assigned(ParentNode) Then
                If (Not ParentNode.HasItems) Then Begin
                  New(ONomRec);
                  FillChar(ONomRec^,Sizeof(ONomRec^),0);
                  ONomRec.IsDummy := True;
                  NLOLine.AddChildObject(ParentNode.Index,'Empty Folder',ONomRec);
                End; { If }
            End;

            { Now add into new group }
            AddEditLine(1);
          End;

      { Updated }
      3 : Begin
            ONomRec:=EditNode.Data;

            With ONomRec^ Do Begin
              OBOMLink   := ReportKey;     { Report Group + Report Code }
              OutNomCode := DriveFile;     { Driving File No }
              OutStkCat  := LastRun;       { Last Date Run }
              OutStkCode := LastOpo;       { Last printed by }

              OutNomType := RepType;

              GrpDesc    := RepDesc;
              GrpPword   := Pword;         { Password on group }

              LastYTD := (RepType <> RepHedTyp) And (DefFont.fSize = 0);
            End; { With }

            EditNode.Text:=FormLineText(ONomRec^);
            SelectedItem:=EditNode.Index;
          End;
    End; { Case OpStat }
  End; { With }
end;

Procedure TForm_RepTree.Delete_OutLines(PIndex      :  LongInt;
                                        DelSelf     :  Boolean);
Var
  OrigChild,
  NextChild       :  LongInt;
  ONomRec         :  ^OutNomType;
  LoopCtrl        :  Boolean;
Begin
  LoopCtrl:=BOff;

  With NLOLine do Begin
    Repeat
      NextChild:=Items[PIndex].GetFirstChild;

      If (NextChild > 0) then {* Try and find more for this level *}
      Begin
        If Assigned(Items[NextChild].Data) Then Begin
          ONomRec := Items[NextChild].Data;
          Dispose(ONomRec);
        End; { If }

        If (Items[NextChild].HasItems) then {* Delete lower levels *}
          Delete_OutLines(NextChild,BOff);

        Delete(NextChild);
      end;
    Until (NextChild<1);

    If DelSelf then Begin
      If Assigned(Items[PIndex].Data) Then Begin
        ONomRec := Items[PIndex].Data;
        Dispose(ONomRec);
      End; { If }

      Delete(PIndex);
    end;
  end; {With..}
end; {Proc..}


procedure TForm_RepTree.RepLink;
begin
  If Assigned(RepDetail) and (RepActive) then
    With RepDetail do Begin
      GetRepGenRec;

      If (WindowState<>wsMinimized) and
         (Not ExLocal.InAddEdit) and
         (RepGenRecs^.ReportHed.RepType<>RepHedTyp) And
         (RepGenRecs^.ReportHed.ReportKey<>ExLocal.LRepGen^.ReportHed.ReportKey) then
        Display_Report(3,BOff);
    end;
end;


{ Called every time a line is drawn - similar to Click }
procedure TForm_RepTree.NLOLineDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
Var
  ONomRec     :  ^OutNomType;
  DrawIdxCode : LongInt;
begin
  If Assigned(RepDetail) and (RepActive) then
    RepLink;

  With NLOLine Do Begin
    DrawIdxCode:=CalcIdx;

    If (DrawIdxCode > 0) And (DrawIdxCode = SelectedItem) Then Begin
      ONomRec:=Items[DrawIdxCode].Data;

      If Assigned(ONomRec) Then
        With ONomRec^ Do Begin
          Panel5.Caption:=DoubleAmpers (Copy(OBOMLink, 11, 10));

          If (OutNomType <> RepHedTyp) And (OutNomCode In [1..High(DataFilesL^)]) Then
            FilePan.Caption := DataFilesL^[OutNomCode]
          Else
            FilePan.Caption := '';

          SetButts;
        End; { With }
    End; { If }
  End; { With }
end;

procedure TForm_RepTree.SetButts;
Var
  ONomRec     :  ^OutNomType;
Begin
  With NLOLine Do Begin
    ONomRec := Nil; { Just In Case }

    If (SelectedItem > 0) Then
      ONomRec := Items[SelectedItem].Data;

    { These buttons should always be available }
    AddBtn.Enabled := True;

    { These buttons are available when a report is selected }
    If Assigned (ONomRec) Then Begin
      { Got a valid item }
      EditBtn.Enabled   := (Not ONomRec^.IsDummy);
      DeleteBtn.Enabled := Ok2DelRep (Copy(ONomRec^.OBOMLink, 11, 10)) And (Not ONomRec^.IsDummy);
      PrintBtn.Enabled  := (ONomRec^.OutNomType <> RepHedTyp) And (Not ONomRec^.IsDummy);
      NotesBtn.Enabled  := (ONomRec^.OutNomType <> RepHedTyp) And (Not ONomRec^.IsDummy);
      CopyBtn.Enabled   := (ONomRec^.OutNomType <> RepHedTyp) And (Not ONomRec^.IsDummy);
      ViewBtn.Enabled   := (ONomRec^.OutNomType <> RepHedTyp) And (Not ONomRec^.IsDummy);
      ConvBtn.Enabled   := ONomRec^.LastYTD;
      LayBtn.Enabled    := (ONomRec^.OutNomType <> RepHedTyp) And (Not ONomRec^.IsDummy);
    End { If }
    Else Begin
      { No item selected }
      EditBtn.Enabled   := False;
      DeleteBtn.Enabled := False;
      PrintBtn.Enabled  := False;
      NotesBtn.Enabled  := False;
      CopyBtn.Enabled   := False;
      ViewBtn.Enabled   := False;
      ConvBtn.Enabled   := False;
      LayBtn.Enabled    := False;
    End; { Else }

    { These buttons are available if the list isn't empty }
    FindBtn.Enabled := (ItemCount > 0);
  End; { With }
End; { If }

procedure TForm_RepTree.AddBtnClick(Sender: TObject);
Var
  Mode : SmallInt;
begin
  Mode := -1;
  If (Sender = AddBtn) Or (Sender = Add2) Then Mode := 0;
  If (Sender = EditBtn) Or (Sender = Edit1) Then Mode := 1;
  If (Sender = DeleteBtn) Or (Sender = Delete1) Then Mode := 2;
  If (Sender = NotesBtn) Or (Sender = Notes1) Then Mode := 4;
  If (Sender = CopyBtn) Or (Sender = Copy1) Then Mode := 10;

  If (Mode <> -1) Then Begin
    If (Mode In [1, 2, 4, 10]) Then Begin
      { Check we've got a valid row }
      If (NLOLine.SelectedItem > 0) And Assigned(NLOLine.Items[NLOLine.SelectedItem]) Then
        Display_Report (Mode, True);
    End { If }
    Else
      Display_Report (Mode, True);
  End; { If }
end;

procedure TForm_RepTree.PrintBtnClick(Sender: TObject);
Var
  RpName : ShortString;
begin
  GetRepGenRec;

  With RepGenRecs^, ReportHed Do
    If (SubType = RepHedTyp) And (RepType In [RepRepCode, RepNomCode]) Then Begin
      RpName := RepName;

      If (DefFont.fSize = 0) Then Begin
        If ChkAllowed_In(194) Then Begin
          { Needs converting }
          If (MessageDlg ('This report needs to be converted before it will print properly. Do you want to convert it now?', mtWarning, [mbYes, mbNo], 0) = mrYes) Then Begin
            ConvertReport (RpName, False);

            { Print Report }
            PrintRWReport (RpName);
          End; { If }
        End { If }
        Else
          { Needs converting - but security forbids it }
          MessageDlg ('This report needs to be converted before it will print properly.', mtWarning, [mbOk], 0);
      End { If }
      Else
        { Print Report }
        PrintRWReport (RpName);
    End; { If }
end;

Procedure TForm_RepTree.WMRWPrint(Var Message  :  TMessage);
begin
  If PrintBtn.Enabled And PrintBtn.CanFocus Then
    PrintBtnClick(Self);
end;

procedure TForm_RepTree.CopyBtnClick(Sender: TObject);
Const
  FNum    = RepGenF;
  KeyPath : Integer = RGK;
Var
  InpOk, FoundOk        :  Boolean;
  FoundCode, SCode      :  String;
  FoundLong, TmpRecAddr :  LongInt;
  n, I, INCode, TmpStat :  Integer;
  KeyS, KeyF            :  Str255;
  OrigRec, TmpRec       : ^RepGenRec;
Begin
  GetMem (OrigRec, SizeOf (OrigRec^));
  GetMem (TmpRec,  SizeOf (TmpRec^));

  GetRepGenRec;
  SCode:=Trim(RepGenRecs^.ReportHed.RepName);
  OrigRec^ := RepGenRecs^;

  { get new report name }
  Repeat
    FoundOk := False;
    InpOk:=InputQuery('Copy Report','Please enter the new report code',SCode);

    If (InpOk) Then Begin
      SCode := Copy(UpperCase(SCode), 1, 10);
      FoundOk:=GetReport(SCode,FoundCode);
    End; { If }
  Until (Not FoundOk) or (Not InpOk);

  If InpOk And (Not FoundOk) Then Begin
    { Copy Header }
    SCode := FullRepCode(SCode);
    RepGenRecs^ := OrigRec^;
    With RepGenRecs^.ReportHed Do Begin
      RepName := SCode;
      RepDesc := 'Copy of ' + Trim(RepDesc);
      ReportKey := RepGroup + RepName;
    End; { With }
    Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

    If StatusOk Then Begin
      { copy fields }
      For I := 1 To 4 Do Begin
        { Build search key }
        Case I Of
          { Report lines & Sub-Headings }
          1 : KeyS := FullRepKey_NDX(ReportGenCode, RepRepCode, OrigRec^.ReportHed.RepName);
          { Nominal Lines }
          2 : KeyS := FullRepKey_NDX(ReportGenCode, RepNomCode, OrigRec^.ReportHed.RepName);
          { Input Lines }
          3 : KeyS := FullRepKey_NDX(ReportGenCode, RepLineTyp, OrigRec^.ReportHed.RepName);
          { Notes }
          4 : KeyS := FullRepKey_NDX(RepNoteType, RepNoteCode, OrigRec^.ReportHed.RepName);
        End; { Case }
        KeyF := KeyS;

        { Copy records - if any }
        Status := Find_Rec (B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
        While StatusOk And CheckKey(KeyS,KeyF,Length(KeyF),BOn) Do Begin
          { save position }
          TmpRec^ := RepGenRecs^;
          TmpStat := Presrv_BTPos(Fnum,KeyPath,F[FNum],TmpRecAddr,BOff,BOff);

          { Modify record where necessary }
          Case I Of
            { Report lines & Sub-Headings }
            1 : With RepGenRecs^.ReportDet Do Begin
                  RepName := SCode;
                  ReportKey := RepName + VarType + RepPadNo;
                End; { With }
            { Nominal Lines }
            2 : With RepGenRecs^.ReportNom Do Begin
                  RepName := SCode;
                  ReportKey := RepName + RepNomCode + RepPadNo;
                End; { With }
            { Input Lines }
            3 : With RepGenRecs^.ReportDet Do Begin
                  RepName := SCode;
                  ReportKey := RepName + VarType + RepPadNo;
                End; { With }
            { Notes }
            4 : With RepGenRecs^.RNotesRec Do Begin
                  NoteFolio := SCode;
                  NoteNo := NoteFolio + NType + SetPadNo(Form_Int(LineNo, 0), 4);
                End; { With }
          End; { Case }

          { Add record }
          Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

          { restore position }
          TmpStat:=Presrv_BTPos(Fnum,KeyPath,F[FNum],TmpRecAddr,BOn,BOff);
          // HM 07/03/00: Presrv_BTPos already does a GetDirect!
          //Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}
          RepGenRecs^ := TmpRec^;

          { get next record }
          Status := Find_Rec (B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
        End; { While }
      End; { For }

      FoundOk:=GetReport(SCode,FoundCode);
      AddEditLine(1);

      { View New Report }
      AddBtnClick(EditBtn);
    End; { If }
  End; { If }

  FreeMem (OrigRec, SizeOf (OrigRec^));
  FreeMem (TmpRec,  SizeOf (TmpRec^));
end;

Procedure TForm_RepTree.WMRWExport(Var Message  :  TMessage);
Var
  ExpFile : File Of RepGenRec;
  ONomRec : ^OutNomType;
  I       : Integer;

  { Returns true if the item is a descendent of the selected item }
  Function Want (Var Idx : Integer) : Boolean;
  Var
    ParNode : TSBSOutLNode;
  Begin
    Result := False;

    With NLOLine Do
      If (Idx > SelectedItem) And (Idx <= ItemCount) Then Begin
        ParNode := Items[Idx];

        Repeat
          ParNode := ParNode.Parent;

          Result := (ParNode = Items[SelectedItem]);
        Until Result Or (ParNode = Nil);
      End { If }
      Else
        { Could be looking at SelectedItem }
        Result := (Idx = SelectedItem);
  End;

  { Exports a specified report to the export file }
  Procedure ExportReport (Const RpName : ShortString);
  Const
    FNum     = RepGenF;
    KeyPath  : Integer = RGK;
  Var
    KeyF, KeyS   : Str255;
    FoundCode    : String;
    I            : Integer;
  Begin
    { Get header }
    If GetReport(RpName, FoundCode) Then Begin
      { Remove password before exporting }
      RepGenRecs^.ReportHed.Pword := '';
      Write (ExpFile, RepGenRecs^);

      { copy fields }
      For I := 1 To 4 Do Begin
        { Build search key }
        Case I Of
          { Report lines & Sub-Headings }
          1 : KeyS := FullRepKey_NDX(ReportGenCode, RepRepCode, RpName);
          { Nominal Lines }
          2 : KeyS := FullRepKey_NDX(ReportGenCode, RepNomCode, RpName);
          { Input Lines }
          3 : KeyS := FullRepKey_NDX(ReportGenCode, RepLineTyp, RpName);
          { Notes }
          4 : KeyS := FullRepKey_NDX(RepNoteType, RepNoteCode, RpName);
        End; { Case }
        KeyF := KeyS;

        { Copy records - if any }
        Status := Find_Rec (B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
        While StatusOk And CheckKey(KeyS,KeyF,Length(KeyF),BOn) Do Begin
          { Modify record where necessary }
          Case I Of
            { Report lines & Sub-Headings }
            1 : With RepGenRecs^.ReportDet Do Begin
                  RepName := RpName;
                  ReportKey := RepName + VarType + RepPadNo;
                End; { With }
            { Nominal Lines }
            2 : With RepGenRecs^.ReportNom Do Begin
                  RepName := RpName;
                  ReportKey := RepName + VarType + RepPadNo;
                End; { With }
            { Input Lines }
            3 : With RepGenRecs^.ReportDet Do Begin
                  RepName := RpName;
                  ReportKey := RepName + VarType + RepPadNo;
                End; { With }
            { Notes }
            4 : With RepGenRecs^.RNotesRec Do Begin
                  NoteFolio := RpName;
                  NoteNo := NoteFolio + NType + SetPadNo(Form_Int(LineNo, 0), 4);
                End; { With }
          End; { Case }

          { Add record }
          Write (ExpFile, RepGenRecs^);

          { get next record }
          Status := Find_Rec (B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
        End; { While }
      End; { For }
    End; { If }
  End;


  { Writes a header record to the export file }
  Procedure WriteHeader;
  Var
    HedRec : RepGenRec;
  Begin
    Blank (HedRec, SizeOf(HedRec));

    With HedRec.ReportHed Do Begin
      RepName:=ExportSig;

      RepType:='X';

      Write(ExpFile, HedRec);
    End; { With }
  End;

Begin
  If (NLOLine.SelectedItem > 0) Then Begin
    NLOLine.Items[NLOLine.SelectedItem].FullExpand;

    If SaveDialog1.Execute Then Begin
      { Open Export File }
      AssignFile (ExpFile, SaveDialog1.FileName);
      ReWrite    (ExpFile);

      WriteHeader;

      { Work out what to export }
      For I := NLOLine.SelectedItem To NLOLine.ItemCount Do
        If Want(I) Then Begin
          { Export Selected Item }
          ONomRec := NLOLine.Items[I].Data;

          If (Not ONomRec^.IsDummy) Then
            ExportReport (Copy(ONomRec^.OBOMLink, 11, 10));
        End { If }
        Else
          { no further interest }
          Break;

      { Close Export File }
      CloseFile (ExpFile);
    End; { If }
  End; { If }
End;

procedure TForm_RepTree.UpdateRepTree(var Msg: TMessage);
Const
  FNum    : Integer = RepGenF;
  KeyPath : Integer = RGNdxK;
Var
  TmpRep             : ^RepGenRec;
  KeyS               : Str255;
  TmpStat, I, ItemNo : Integer;
  TmpRecAddr         : LongInt;
  ONom               : ^OutNomType;
  PrnNotify          : PrintNotifyPtr;
begin
  { Save record and position of record }
  New (TmpRep);
  TmpRep^ := RepGenRecs^;
  TmpStat:=Presrv_BTPos(Fnum,KeyPath,F[FNum],TmpRecAddr,BOff,BOff);

  PrnNotify := PrintNotifyPtr(Msg.LParam);

  { See if report exists }
  KeyS   := FullRepKey (ReportGenCode, RepGroupCode, PrnNotify^.RepName);
  Status := Find_Rec (B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

  If StatusOk Then
    With NLOLine Do Begin
      { find this record in tree }
      For I := 1 To ItemCount Do Begin
        ONom := Items[I].Data;

        If (Copy(ONom.OBOMLink, 11, 10) = PrnNotify^.RepName) Then Begin
          { Got a match - update parameters }
          ONom.OutStkCat  := RepGenRecs^.ReportHed.LastRun;       { Last Date Run }
          ONom.OutStkCode := RepGenRecs^.ReportHed.LastOpo;       { Last printed by }

          NLOLine.Refresh;

          Break;
        End; { If }
      End; { For }
    End; { With }

  { Restore record and position }
  TmpStat:=Presrv_BTPos(Fnum,KeyPath,F[FNum],TmpRecAddr,BOn,BOff);
  //Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}
  RepGenRecs^ := TmpRep^;
  Dispose (TmpRep);
end;

{ Convert DOS report to windows standard }
procedure TForm_RepTree.ConvBtnClick(Sender: TObject);
Var
  ONom      : ^OutNomType;
begin
  If (NLOLine.SelectedItem > 0) Then Begin
    { Get copy of data object }
    ONom := NLOLine.Items[NLOLine.SelectedItem].Data;

    { Get report }
    ConvertReport(Copy (ONom^.OBOMLink, 11, 10), True);
  End; { If }
end;

{ Converts a form from DOS to window standard }
Procedure ConvertReport (Const RpName : ShortString; Const Ask : Boolean);
Var
  ONom      : ^OutNomType;
  FoundCode : String;

  { Get and update the header record to windows standard }
  Procedure ConvHed;
  Const
    FNum    = RepGenF;
    KeyPath = RGNdxK;
  Var
    Locked  : Boolean;
    LockPos : LongInt;
    Key2F   : Str255;
  Begin
    { Lock record }
    Status := 0;
    Locked := BOn;
    Key2F := FullRepKey (ReportGenCode, RepGroupCode, RpName);
    Ok:=GetMultiRec(B_GetEq,B_MultLock,Key2F,KeyPath,FNum,True,Locked);
    Report_BError(FNum, Status);

    Status:=GetPos(F[FNum],FNum,LockPos);

    If OK And StatusOk And Locked Then Begin
      With RepGenRecs^, ReportHed Do Begin
        { Set font }
        CopyFont (Form_RepTree.TmpFontLbl.Font, DefFont, True);

        { Set col spacing }
        ColSpace   := 3;
      End; { With }

      { Update record }
      Status:=Put_Rec(F[FNum], FNum, RecPtr[FNum]^, KeyPath);

      { Unlock Record }
      Status:=UnlockMultiSing(F[FNum], FNum, LockPos);
    End; { If }
  End;

  { get and update any report/heading lines }
  Procedure ConvLines;
  Const
    FNum     = RepGenF;
    KeyPath  : Integer = RGK;
  Var
    KeyF, KeyS, Key2F   : Str255;
    FoundCode           : String;
    I, TmpStat          : Integer;
    TmpRecAddr, LockPos : LongInt;
    TheRect             : TRect;
    SizeStr             : PChar;
    Locked              : Boolean;
  Begin
    { Report lines & Sub-Headings }
    KeyS := FullRepKey_NDX(ReportGenCode, RepRepCode, RpName);
    KeyF := KeyS;

    { Copy records - if any }
    Status := Find_Rec (B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
    While StatusOk And CheckKey(KeyS,KeyF,Length(KeyF),BOn) Do Begin
      { Save Position }
      TmpStat:=Presrv_BTPos(Fnum,KeyPath,F[FNum],TmpRecAddr,BOff,BOff);

      { Lock record }
      Status := 0;
      Locked := BOn;
      Key2F := FullRepKey (ReportGenCode, RepGroupCode, RpName);
      Ok:=GetMultiRec(B_GetEq,B_MultLock,Key2F,KeyPath,FNum,True,Locked);
      Report_BError(FNum, Status);

      Status:=GetPos(F[FNum],FNum,LockPos);

      With RepGenRecs^.ReportDet Do Begin
        If (VarLen > 0) And (MMWidth < 3) Then Begin
          { Get size of font }
          SizeStr := StrAlloc (VarLen + 1);
          TheRect := Rect (1, 1, 2, 2);
          If (VarLen <= 4) Then
            StrPCopy(SizeStr, ConstStr ('W', VarLen))
          Else
            StrPCopy(SizeStr, ConstStr ('S', VarLen));
          DrawText (Form_RepTree.TmpFontLbl.Canvas.Handle, SizeStr, Length(SizeStr), TheRect, (DT_CALCRECT Or DT_SINGLELINE));
          StrDispose (SizeStr);

          { Set control size }
          MMWidth := Round((TheRect.Right - TheRect.Left) / 3);

          If (MMWidth < 3) Then MMWidth := 3;

          { Update line }
          Status:=Put_Rec(F[FNum], FNum, RecPtr[FNum]^, KeyPath);
        End; { If }
      End; { With }

      { Unlock Record }
      Status:=UnlockMultiSing(F[FNum], FNum, LockPos);

      { Restore Position }
      TmpStat:=Presrv_BTPos(Fnum,KeyPath,F[FNum],TmpRecAddr,BOn,BOff);
      //Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

      { get next record }
      Status := Find_Rec (B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
    End; { While }
  End;


begin
  { Get report }
  If GetReport(RpName, FoundCode)  Then Begin
    { Check it needs converion }
    If (RepGenRecs^.ReportHed.DefFont.fSize = 0) Then
      If (Not Ask) Or (MessageDlg ('Are you sure you want to convert ''' + Trim(RepGenRecs^.ReportHed.RepDesc)
                                   + '''?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then Begin
        FoundCode := RepGenRecs^.ReportHed.RepName;

        { Convert - header }
        ConvHed;

        { Convert report/header fields }
        ConvLines;

        { update data object }
      End; { If }
  End; { If }
end;

procedure TForm_RepTree.ViewBtnClick(Sender: TObject);
Var
  ONom      : ^OutNomType;
begin
  If (NLOLine.SelectedItem > 0) Then Begin
    { Get copy of data object }
    ONom := NLOLine.Items[NLOLine.SelectedItem].Data;

    { Get report }
    If Assigned (ONom) And (Not StopDetail) And (ONom^.OutNomType <> RepHedTyp) Then
      Display_Report (3, BOn);
  End; { If }
end;

procedure TForm_RepTree.LayBtnClick(Sender: TObject);
Var
  LayRep : TLayoutReport;
begin
  GetRepGenRec;

  With RepGenRecs^, ReportHed Do
    If (SubType = RepHedTyp) And (RepType In [RepRepCode, RepNomCode]) Then Begin
      LayRep := TLayoutReport.Create;
      Try
        LayRep.LRName := RepName;

        LayRep.Execute;
      Finally
        LayRep.Free;
      End;
    End; { If }
end;

{----------------------------------------}

Procedure TForm_RepTree.AddRepNode(Const ParentIdx : LongInt;
                                   Const TheRep    : RepGenRec;
                                   Const Select    : Boolean);
Var
  ONomRec : ^OutNomType;
  SelIdx  : LongInt;

  Function AddReport : LongInt;
  Begin { AddReport }
    Result := NLOLine.AddChildObject(ParentIdx,FormLineText(ONomRec^),ONomRec);
  End; { AddReport }

  Function AddGroup : LongInt;
  Var
    GrpIdx : LongInt;
  Begin { AddGroup }
    GrpIdx := NLOLine.AddChildObject(ParentIdx,FormLineText(ONomRec^),ONomRec);

    If (Trim(ONomRec^.GrpPword) <> '') Then Begin
      New(ONomRec);
      FillChar(ONomRec^,Sizeof(ONomRec^),0);
      ONomRec.IsDummy := True;
      NLOLine.AddChildObject(GrpIdx,'Password Protected',ONomRec);
    End { If }
    Else Begin
      New(ONomRec);
      FillChar(ONomRec^,Sizeof(ONomRec^),0);
      ONomRec.IsDummy := True;
      NLOLine.AddChildObject(GrpIdx,'Empty Folder',ONomRec);
    End; { Else }

    Result := GrpIdx;
  End; { AddGroup }

Begin { AddRepNode }
  With TheRep, ReportHed Do Begin
    { Create new detail record for node }
    New(ONomRec);
    FillChar(ONomRec^,Sizeof(ONomRec^),0);
    With ONomRec^ Do Begin
      OBOMLink   := ReportKey;     { Report Group + Report Code }
      OutNomCode := DriveFile;     { Driving File No }
      OutStkCat  := LastRun;       { Last Date Run }
      OutStkCode := LastOpo;       { Last printed by }

      OutNomType := RepType;       { Report Type }

      GrpDesc    := RepDesc;
      GrpPword   := Pword;         { Password on group }

      MoreLink   := False;         { Expanded }

      LastYTD := (RepType <> RepHedTyp) And (DefFont.fSize = 0);
    End; { With }

    { Add into Tree }
    Case RepType Of
      { 'H' - Group }
      RepGroupCode  : SelIdx := AddGroup;

      { 'N' - Nominal Based Report }
      RepNomCode    : SelIdx := AddReport;

      { 'R' - Standard Report }
      ReportGenCode : SelIdx := AddReport;
    End; { Case RepType }
  End; { With TheRep^, ReportHed }

  If Select And (SelIdx > 0) Then
    NLOLine.SelectedItem := SelIdx;
End; { AddRepNode }

{----------------------------------------}

{ performs the initial load of root reports/groups }
Procedure TForm_RepTree.Add_OutLines2(Const RepGroup  : Str20;
                                      Const ParentIdx : LongInt);
Var
  ONomRec       : ^OutNomType;
  KeyS, KeyChk  : Str255;
  LStatus       : SmallInt;
  FirstKid      : Boolean;

  Procedure KillKids(Const ParentIdx : LongInt);
  Var
    ChildIdx : LongInt;
  Begin { KillKids }
    With NLOLine, Items[ParentIdx] Do
      { Check for kiddies }
      If HasItems Then Begin
        { Kill them :-) }
        ChildIdx := GetFirstChild;
        While (ChildIdx <> -1) Do Begin
          Delete (ChildIdx);
          ChildIdx := GetFirstChild;
        End; { While }
      End; { If HasItems }
  End; { KillKids }

Begin
  { Check user has rights to open group }
  If CheckSecurity(RepGroup, ParentIdx) Then Begin
    With NLOLine Do Begin
      { Build key to find specified group children }
      KeyChk:=FullRepKey_NDX (ReportGenCode, RepGroupCode, RepGroup);
      KeyS:=KeyChk;

      FirstKid := True;

      { Run through kiddies loading tree }
      LStatus := Find_Rec(B_GetGEq,F[RepGenF],RepGenF,RecPtr[RepGenF]^,RGK,KeyS);
      While (LStatus = 0) and CheckKey(KeyChk, KeyS, Length(KeyChk), BOn) Do Begin
        If FirstKid And (ParentIdx <> 0) Then Begin
          { Remove any existing child nodes }
          KillKids(ParentIdx);

          { Mark as loaded }
          ONomRec := Items[ParentIdx].Data;
          With ONomRec^ Do
            MoreLink := True;

          FirstKid := False;
        End; { if }

        AddRepNode (ParentIdx, RepGenRecs^, False);

        { Get next report }
        LStatus:=Find_Rec(B_GetNext,F[RepGenF],RepGenF,RecPtr[RepGenF]^,RGK,KeyS);
      End; { While }
    End; { With NLOLine }
  End; { If CheckSecurity }
end; {Proc..}

{----------------------------------------}

{ Finds a report and loads the tree as required in order to show the report }
Procedure TForm_RepTree.FindAndShowReport(Const RepName : ShortString; Const Select : Boolean);
Var
  TmpRep             : ^RepGenRec;
  KeyS               : Str255;
  TmpRecAddr         : LongInt;
  TmpKPath           : Integer;
  LStatus, RepIdx    : SmallInt;
Begin { FindAndShowReport }
  { Save record and position of record in file }
  New (TmpRep);
  TmpKPath := RGNdxK;
  TmpRep^ := RepGenRecs^;
  LStatus := Presrv_BTPos(RepGenF,TmpKPath,F[RepGenF],TmpRecAddr,BOff,BOff);

  { Get Report from file }
  KeyS   := FullRepKey (ReportGenCode, RepGroupCode, RepName);
  LStatus := Find_Rec (B_GetEq, F[RepGenF], RepGenF, RecPtr[RepGenF]^, RGNdxK, KeyS);

  If (LStatus = 0) Then
    With RepGenRecs^ Do Begin
      { Got Report - Check parent }
      If (Trim(ReportHed.RepGroup) <> '') Then
        FindAndShowReport (ReportHed.RepGroup, False);

      { See if report exists }
      RepIdx := FindReportCode(RepGenRecs^.ReportHed.RepName);
      If (RepIdx > 0) Then Begin
        If Select Then
          NLOLine.SelectedItem := RepIdx
        Else Begin
          NLOLineExpand(NLOLine, RepIdx);
          NLOLine.Items[RepIdx].Expanded := True;
        End; { Else }
      End; { Else }
  End; { If }

  { Restore record and position }
  LStatus := Presrv_BTPos(RepGenF,TmpKPath,F[RepGenF],TmpRecAddr,BOn,BOff);
  RepGenRecs^ := TmpRep^;
  Dispose (TmpRep);
End; { FindAndShowReport }

{----------------------------------------}

Function TForm_RepTree.RepPWordOK(Const ONomRec : OutNomType) : Boolean;
Begin { RepPWordOK }
  Result := False;

  { Check for password }
  If (Trim(ONomRec.GrpPword) <> '') Then Begin
    { Check if password has already been given }
    If (Not CheckPwordList (ONomRec.GrpPword)) Then Begin
      { Password not previously supplied - ask }
      If PwordDlg.RequestPassword (ONomRec) Then Begin
        { Got Password }
        Result := True;
      End { If RequestPassword }
      Else
        { Passowrd not given }
        Result := False;
    End { If }
    Else
      { Password already supplied }
      Result := True;
  End { If }
  Else
    { No password }
    Result := True;
End; { RepPWordOK }

end.
