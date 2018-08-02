unit Noteu;

{
  CJS 01/11/2010 - Note that "warp" in this code should actually be "wrap", and
  refers to the case where this dialog is being used for adding multi-line
  notes.
}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs,
  Globvar,VarConst,SBSComp,SupListU,Grids, StdCtrls, Buttons,
  Mask, ExtCtrls, TEditVal, SBSPanel, BorBtns,ExWrap1U, Menus,
  BtSupU1, SpellCheck4Modal, EntWindowSettings;

Const
  WM_NoteGetLine  =  WM_User+$111;

type

  //PR: 19/10/2011 Added types for handling addition of Audit Notes
  TNoteMode = (nmGeneral, nmDated, nmAudit);

  TNoteSwitchProc = procedure(Sender : TObject; NewMode : TNoteMode) of Object;

  TNotePadSetUp  =  Record

                      ColPanels   :  Array[0..11] of TSBSPanel;

                      ScrollBox   :  TScrollBox;

                      PropPopUp   :  TMenuItem;

                      XtraMode    :  Byte;
                      CoorPrime   :  Char;
                      CoorHasCoor :  Boolean;
                    end;


  TNoteList  =  Class(TGenList)

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function OutNLine(Col  :  Byte)  :  Str255;

    Function OutDLine(Col  :  Byte)  :  Str255;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    Procedure SetMoveData(IVal  :  LongInt); Override;

  end;



  TNoteCtrl = class(TForm)
    Panel24: TPanel;
    NPLine: Text8Pt;
    NBOkBtn: TBitBtn;
    NBCanBtn: TBitBtn;
    NPNotePanel: TPanel;
    Label89: Label8;
    Panel4: TPanel;
    NPDate: TEditDate;
    NPDateChk: TBorCheck;
    NPAlaChk: TBorCheck;
    NPAlarm: TEditDate;
    NotesPopupM: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    Insert1: TMenuItem;
    Switch1: TMenuItem;
    Label81: Label8;
    NPFor: Text8Pt;
    Label82: Label8;
    NPRepeat: TCurrencyEdit;
    Label83: Label8;
    Clear1: TMenuItem;
    View1: TMenuItem;
    SpellCheck4Modal1: TSpellCheck4Modal;
    GeneralNotes1: TMenuItem;
    DatedNotes1: TMenuItem;
    AuditHistoryNotes1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NBOkBtnClick(Sender: TObject);
    procedure NPDateKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NPDateKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure NPDateChkClick(Sender: TObject);
    procedure NPNotePanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NPNotePanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure NPNotePanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Add1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure NotesPopupMPopup(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Clear1Click(Sender: TObject);
    procedure View1Click(Sender: TObject);
    procedure TeleSales1Click(Sender: TObject);
    procedure NPForExit(Sender: TObject);
    procedure NPRepeatKeyPress(Sender: TObject; var Key: Char);
    procedure GeneralNotes1Click(Sender: TObject);
    procedure DatedNotes1Click(Sender: TObject);
    procedure AuditHistoryNotes1Click(Sender: TObject);
  private
    { Private declarations }

    fDoingClose,
    NeedToStore,

    InsWrap,
    PrevHState   :  Boolean;

    FNextLineNo  :  LongInt;

    Fnum,
    KeyPath      :  Integer;


    GetSubType   :  Char;


    WarpStore    :  Str100;


    ScrollCont   :  TScrollBox;
    FormStoreCoord
                 :  TMenuItem;

    LastPWrd     :  ^PassWordRec;

    GenNoteMode  :  Boolean;


    //PR: 08/11/2010
    FSettings : IWindowSettings;
    FOnSwitch : TNoteSwitchProc;

    //PR: 19/10/2011 v6.9
    FNoteMode : TNoteMode;

    Procedure SetNextLineNo(GLNo  :  Longint);

    procedure NPWarpStore(Var Key  :  Char);

    Procedure WMNoteGetLine(Var Message  :  TMessage); message WM_NoteGetLine;

    procedure SetHelpContextIDs; // NF: 10/05/06

    //PR: 15/11/2011 Added procedure to enable or disable controls to allow Audit Notes to be shown read-only
    procedure EnableControls(Enable : Boolean);

  public
    GetNType     :  Char;


    GetFolio     :  Str10;

    DefaultDateOn,
    fParentLocked,
    KillList     :  Boolean;

    {
      CJS 01/11/2010 - If ForceAlarmed is True, the note will always be an
      alarmed note, and the user cannot change this (the Alarm checkbox is
      automatically ticked and then disabled). This flag is set when this
      dialog is called from the Workflow Diary, which only displays alarmed
      notes.
    }
    ForceAlarmed: Boolean;

    { Public declarations }

    MULCtrlO  :  TNoteList;

    ExLocal   :  TdExLocal;

    //PR: 18/10/2011 v6.9 Added new variable and function to deal with Audit Notes
    procedure SwitchNoteMode(NewMode : TNoteMode);


    Procedure HookOnMouse;
    Procedure UnHookOnMouse;

    procedure Find_NotePageCoord(CPrimeKey  :  Char;
                                 CHCoor     :  Boolean);

    Procedure CreateList(AOwner          :  TComponent;
                         NotePadSetup    :  TNotePadSetup;
                         NSub,
                         NTyp            :  Char;
                         NFolio          :  Str10);



    Procedure RefreshList(NFolio  :  Str10;
                          NTyp    :  Char);


    //Leave existing procedure for now
    Procedure SwitchGenMode;

    Procedure OutNote;

    Procedure Form2Note;

    procedure ProcessNote(Edit,
                          InsMode,
                          ViewOnly,
                          WarpMode   :  Boolean);

    procedure StoreNote(Edit,WarpMode       :  Boolean);

    procedure DeleteNoteLine;

    procedure AddEditNote(Edit,InsMode  :  Boolean);

    Procedure Update_Parent(MMode  :  Word);


    procedure SetFormProperties;

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure Clear_Alarm;

    Property GetLineNo  :  LongInt Read FNextLineNo Write SetNextLineNo;

    property WindowSettings : IWindowSettings read FSettings write FSettings;

    //PR: 19/10/2011 v6.9 Audit notes
    property OnSwitch : TNoteSwitchProc read FOnSwitch write FOnSwitch;
    property NoteMode : TNoteMode read FNoteMode write FNoteMode;
  end;




{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


{$R *.DFM}


Uses
  ETStrU,
  ETDateU,
  BtrvU2,
  BtKeys1U,
  InvListU,
  BTSupU2,
  NoteSupU,
  ColCtrlU,
  PWarnU,
  CmpCtrlU,
  // MH 08/03/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
  ExportListIntf;




{ ============ TNoteList Methods ================= }



Function TNoteList.SetCheckKey  :  Str255;


Var
  DumStr  :  Str255;

Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With Password do
    Case Keypath of
      PWK       :  DumStr:=PartNoteKey(RecPFix,SubType,NotesRec.NoteNo);
      HelpNDXK  :  DumStr:=PartNoteKey(RecPfix,SubType,NotesRec.NoteAlarm);
    end; {Case..}

  SetCheckKey:=DumStr;
end;




Function TNoteList.SetFilter  :  Str255;

Var
  MatchFor  :  Str10;

Begin

  Case KeyPath of

    PWK   :  Result:=Password.NotesRec.Ntype;

    HelpNdxK
          :  With Password.NotesRec do
             Begin
               {* Only include alarms up to today *}
                 MatchFor:=Strip('R',[#32],NoteFor);

                 If (((NoteAlarm>Today) or (NoteAlarm<FirstDDate)
                    or ((Not CheckKey(MatchFor,EntryRec^.Login,Length(MatchFor),BOff)) and (Syss.UsePassWords)))
                    and (Displaymode<>4)) then
                   Result:='1'
                 else
                   Result:='0';
             end;

  end; {Case..}

end;


Function TNoteList.Ok2Del :  Boolean;

Begin
  Case DisplayMode of
    1,2
       :  Result:=BOn;
    else  Result:=BOff;
  end; {Case..}

end;


{ ========== Generic Function to Return Formatted Display for List ======= }

Function TNoteList.OutNLine(Col  :  Byte)  :  Str255;

Begin
   With PassWord,NotesRec do
     Case Col of
       0  :  If ((ShowDate) and (NType=NoteCDCode)) or (NType = ntAudit) then
               OutNLine:=PoutDate(NoteDate)
             else
               OutNLine:='';

       1  :  OutNLine:=NoteLine;

       2  :  OutNLine:=NoteUser;

     end; {Case..}
end;



Function TNoteList.OutDLine(Col  :  Byte)  :  Str255;

Begin
   With PassWord,NotesRec do
     Case Col of
       0  :  OutDLine:=PoutDate(NoteAlarm);

       1  :  OutDLine:=NoteLine;

       2  :  OutDLine:=NoteUser;

       3  :  OutDLine:=NoteSource_Desc(SubType,ExtNoteKey(NoteNo));

       4  :  OutDLine:=NoteFor;

     end; {Case..}
end;


Function TNoteList.OutLine(Col  :  Byte)  :  Str255;

Begin
  Case DisplayMode of
    3,4  :  Result:=OutDLine(Col);
    else    Result:=OutNLine(Col);
  end; {Case..}
end;


Procedure TNoteList.SetMoveData(IVal  :  LongInt);

Begin

  With PassWord do
  With NotesRec do
  Begin
    LineNo:=LineNo+IVal;

    NoteNo:=FullRNoteKey(NoteFolio,NType,LineNo);

   end;

end;





{ ============ TNoteCtrl Methods ================= }

procedure TNoteCtrl.FormCreate(Sender: TObject);
begin
  ExLocal.Create;

  ClientHeight:=56;
  ClientWidth:=587;

  fDoingClose:=BOff;

  KillList:=BOff;
  NeedToStore:=BOff;

  Fnum:=PWrdF;
  KeyPath:=PWK;
  New(LastPWrd);

  DefaultDateOn:=BOn;

  fParentLocked:=BOff;

  WarpStore:='';

  InsWrap:=BOff;

  ForceAlarmed := False;

  FillChar(LastPWrd^,Sizeof(LastPWrd^),0);

  ScrollCont:=Nil;

  SetHelpContextIDs; // NF: 10/05/06 Fix for incorrect Context IDs
  FSettings := nil;

  //TG 21-04-2017 ABSEXCH-17888- The notes on Job Records are not working correctly.

 { Commented this line because the proper assignment of the notemode occurs in SwitchNodeMode and executes successfully
 	 only when the MULCtrl are assigned which occurs after this method in TJobRec.PageControl1Change of jobMn2u.pas   }

 // NoteMode := nmDated; //PR: 19/10/2011 v6.9 Default to dated notes.
end;


procedure TNoteCtrl.FormShow(Sender: TObject);
begin
  NPLine.SetFocus;
  //GS 01/08/2011 ABSEXCH-10223:
  //enable displaying dates on the note line before the dialog is shown
  //this re-enables date stamps after a long, wrapped note has been added ('wrapping' unchecks this control!)
  NPDateChk.Checked := True;
end;

procedure TNoteCtrl.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

  If (NeedToStore) then {* Only Update Parent if an add has occurred *}
  Begin
    Update_Parent(0);
    NeedToStore:=BOff;
  end;

end;


procedure TNoteCtrl.FormDestroy(Sender: TObject);
begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Dispose(LastPWrd);

    ExLocal.Destroy;

    Begin
      Try
        If (MULCtrlO<>Nil) then
          MULCtrlO.Destroy; {* Must be destroyed here, as owned by ROB1...}

      Finally

        MULCtrlO:=Nil;

      end; {Finally..}

    end;

  end;

  FSettings := nil;
end;



Procedure TNoteCtrl.SetNextLineNo(GLNo  :  Longint);

Begin

  If (fNextLineNo<>GLNo) then
  Begin
    If (GLNo>0) then
      fNextLineNo:=GLNo
    else
      fNextLineNo:=1;
  end;

end;


Procedure TNoteCtrl.HookOnMouse;

Var
  n  :  Byte;

Begin

  With MULCtrlO,VisiList do
  Begin

    For n:=0 to Count-1 do
    Begin
      VisiRec:=List[n];

      With VisiRec^ do
      Begin
        TSBSPanel(PanelObj).OnMouseUp:=NPNotePanelMouseUp;

        TSBSPanel(LabelObj).OnMouseMove:=NPNotePanelMouseMove;

        TSBSPanel(LabelObj).OnMouseDown:=NPNotePanelMouseDown;

        TSBSPanel(LabelObj).OnMouseUp:=NPNotePanelMouseUp;

      end; {With..}

    end; {Loop..}
  end; {With..}

end;


// MH 11/01/2011 v?.? ABSEXCH-10718: Experimental fix to prevent access violations if mouse moved across Notes column titles whilst form closes
Procedure TNoteCtrl.UnHookOnMouse;

Var
  n  :  Byte;

Begin
  With MULCtrlO, VisiList do
  Begin
    For n:=0 to Count-1 do
    Begin
      VisiRec:=List[n];

      With VisiRec^ do
      Begin
        TSBSPanel(PanelObj).OnMouseUp := NIL;

        TSBSPanel(LabelObj).OnMouseMove := NIL;

        TSBSPanel(LabelObj).OnMouseDown := NIL;

        TSBSPanel(LabelObj).OnMouseUp := NIL;

      end; {With..}

    end; {Loop..}
  end; {With..}

end;



procedure TNoteCtrl.Find_NotePageCoord(CPrimeKey  :  Char;
                                       CHCoor     :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin
  if Assigned(FSettings) then
  begin
    FSettings.SettingsToParent(MULCtrlO);
    EXIT;
  end;

  New(GlobComp,Create(BOn));

  With GlobComp^ do
  Begin
    GetValues:=BOn;

    PrimeKey:=CPrimeKey;
    HasCoord:=CHCoor;

    MULCtrlO.Find_ListCoord(GlobComp);

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);


end;


Procedure TNoteCtrl.CreateList(AOwner          :  TComponent;
                               NotePadSetup    :  TNotePadSetup;
                               NSub,
                               NTyp            :  Char;
                               NFolio          :  Str10);

Var
  Key2F    :  Str255;

  StartPanel
           :  TSBSPanel;

  n        :  Byte;

  XtraCols :  Boolean;


Begin
  StartPanel := nil; //PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Initialise to avoid warning

  XtraCols:=BOff;

  If (NotePadSetUp.XtraMode In [3,4]) then
  Begin
    Key2F:=NoteTCode;
    Keypath:=HelpNDXK;
  end
  else
    Key2F:=PartGNoteKey(NoteTCode,NSub,NTyp,NFolio);

  If (AOwner is TForm) and (MULCtrlO=Nil) then
  Begin


    MULCtrlO:=TNoteList.Create(Self);
    MulCtrlO.Name := 'List_Notes';

    Try

      With MULCtrlO do
      Begin

        Try

          With VisiList,NotePadSetUp do
          Begin
            AddVisiRec(ColPanels[0],ColPanels[1]);
            AddVisiRec(ColPanels[2],ColPanels[3]);
            AddVisiRec(ColPanels[4],ColPanels[5]);

            {
	              CJS: 28/03/2011 ABSEXCH-11141
              Moved assignment of header label panel to here so that it is
              picked up when the window settings are loaded.
            }
            VisiList.LabHedPanel:=ColPanels[6];

            If (Assigned(ColPanels[8])) and (XtraMode<>0) then
            Begin
              AddVisiRec(ColPanels[8],ColPanels[9]);
              AddVisiRec(ColPanels[10],ColPanels[11]);

              XtraCols:=BOn;


            end;

            // MH 08/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
            ColAppear^[0].ExportMetadata := emtDate;


            VisiRec:=List[0];

            StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

            ScrollCont:=ScrollBox;

            If (NotePadSetUp.XtraMode=1) and (XtraCols) then
            Begin
              SetHidePanel(3,BOn,BOff);
              SetHidePanel(4,BOn,BOn);
            end;

            FormStoreCoord:=PropPopUp;

            Find_NotePageCoord(CoorPrime,CoorHasCoor);

            DisplayMode:=XtraMode;

             If (XtraMode In [3,4]) then
               Filter[1,1]:='1'; {* Exclude forward dated items *}

          end;

        except
          VisiList.Free;

        end;

        {Find_FormCoord;}


        HookOnMouse;

        TabOrder := -1;
        TabStop:=BOff;
        Visible:=BOff;
        BevelOuter := bvNone;
        ParentColor := False;
        Color:=StartPanel.Color;
        MUTotCols:=2+(2*Ord(XtraCols));
        Font:=StartPanel.Font;
        LinkOtherDisp:=Bon;

        WM_ListGetRec:=WM_NoteGetLine;


        Parent:=StartPanel.Parent;

        MessHandle:=Self.Handle;

        For n:=0 to MUTotCols do
        With ColAppear^[n] do
        Begin
          AltDefault:=BOn;
        end;
        
        ListCreate;

        With NotePadSetUp do
        Begin
          {
            CJS: 28/03/2011 ABSEXCH-11141
            Moved assignment of header label panel earlier so that it is
            picked up when the window settings are loaded.
          }
//        VisiList.LabHedPanel:=ColPanels[6];

          Set_Buttons(ColPanels[7]);
        end;

        StartList(Self.Fnum,Self.Keypath,Key2F,Key2F,'',Length(Key2F),BOff);

      end {With}


    Except

      MULCtrlO.Free;
      MULCtrlO:=Nil;
    end;


    {FormSetOfSet;}


  end
  else
    If (MULCtrlO<>Nil) then
    With MULCtrlO do
      StartList(Self.Fnum,Self.KeyPath,Key2F,Key2F,'',Length(Key2F),(NFolio=GetFolio));

  GetSubType:=NSub;
  GetNType:=NTyp;
  GetFolio:=NFolio;

end; {Proc..}


{ ======= Refresh list for scan  ====== }

Procedure TNoteCtrl.RefreshList(NFolio  :  Str10;
                                NTyp    :  Char);

Var
  OldKey2F,
  Key2F  :  Str255;

Begin

{$B-}
  If Assigned(MULCtrlO) and (MULCtrlO.DisplayMode In [3,4]) then
  Begin
    OldKey2F:='';
    Key2F:=NFolio;
  end
  else
  Begin
    OldKey2F:=PartGNoteKey(NoteTCode,GetSubType,GetNType,GetFolio);

    Key2F:=PartGNoteKey(NoteTCode,GetSubType,NTyp,NFolio);
  end;

  {$B+}

  If (MULCtrlO<>Nil) then
  With MULCtrlO do
    StartList(Self.Fnum,Self.KeyPath,Key2F,Key2F,'',Length(Key2F),(Key2F=OldKey2F));

  GetFolio:=NFolio;
  GetNType:=NTyp;

end; {Proc..}

Procedure TNoteCtrl.SwitchGenMode;

Const
  GenDesc  :  Array[BOff..BOn] of Str10 = ('','General ');

Var
  GenFilter  :  Char;

Begin
  //PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Unnecessary initialisation to avoid warning
  GenFilter := #0;

  GenNoteMode:=Not GenNoteMode;

  Case GenNoteMode of

    BOff  :  Begin
               GenFilter:=NoteCDCode;

             end;

    BOn  :   Begin
               GenFilter:=NoteCGCode;

             end;

  end; {Case..}


  With MULCtrlO,VisiList do
  Begin
    VisiRec:=List[FindxColOrder(1)];

    TSBSPanel(VisiRec^.LabelObj).Caption:=GenDesc[GenNoteMode]+'Notes';

    SetHidePanel(0,GenNoteMode,BOn);
    ReAssignCols;
  end;

  RefreshList(GetFolio,GenFilter);

end;

//PR: 18/10/2011 v6.9 New function to deal with Audit Notes
Procedure TNoteCtrl.SwitchNoteMode(NewMode : TNoteMode);

Const
//  GenDesc  :  Array[BOff..BOn] of Str10 = ('','General ');
  NoteDesc : Array[nmGeneral..nmAudit] of String[14] = ('General ', '', 'Audit History ');
  NoteFilters : Array[nmGeneral..nmAudit] of Char = (NoteCGCode, NoteCDCode, '3' );
Var
  GenFilter  :  Char;

Begin
  if NoteMode <> NewMode then
  begin
    NoteMode := NewMode;
    GenFilter := NoteFilters[NoteMode];
    //checking assignment to prevent crashing
	//TG 21-04-2017 ABSEXCH-17888- The notes on Job Records are not working correctly.
    if Assigned(MULCtrlO) then
    begin
      With MULCtrlO,VisiList do
      Begin
      	VisiRec:=List[FindxColOrder(1)];
        //TSBSPanel(VisiRec^.LabelObj).Caption:=GenDesc[GenNoteMode]+'Notes';
        TSBSPanel(VisiRec^.LabelObj).Caption:=NoteDesc[NoteMode]+'Notes';
        //SetHidePanel(0,GenNoteMode,BOn);
        SetHidePanel(0,NoteMode <> nmDated,BOn);
        ReAssignCols;
	  end;
    end;

    RefreshList(GetFolio,GenFilter);

    if Assigned(FOnSwitch) then
      FOnSwitch(Self, NoteMode);
  end;
end;

{ === Procedure to Output one Line record === }

Procedure TNoteCtrl.OutNote;

Begin

  With ExLocal.LPassWord.NotesRec  do
  Begin
    NPDateChk.Checked:=ShowDate;
    NPDate.DateValue:=NoteDate;
    NPLine.Text:=NoteLine;
    NPAlarm.DateValue:=NoteAlarm;
    NPFor.Text:=NoteFor;
    NPRepeat.Value:=RepeatNo;
    NPAlaChk.Checked:=Not EmptyKey(NoteAlarm,LDateKeyLen);

    If (Not NPAlaChk.Checked) then
      NPAlarm.DateValue:=Today;

  end; {with..}

end; {Proc..}

{ === Procedure to Output one cust record === }

Procedure TNoteCtrl.Form2Note;

Begin

  With EXLocal.LPassWord.NotesRec do
  Begin
    ShowDate:=NPDateChk.Checked;

    NoteDate:=NpDate.DateValue;

    NoteLine:=NpLine.Text;

    If (NpAlaChk.Checked) then
      NoteAlarm:=NpAlarm.DateValue
    else
      Blank(NoteAlarm,Sizeof(NoteAlarm));

    NoteFor:=NPFor.Text;
    RepeatNo:=Trunc(NPRepeat.Value);
  end; {with..}

end; {Proc..}




(*  Add is used to add Notes *)

procedure TNoteCtrl.ProcessNote(Edit,
                                InsMode,
                                ViewOnly,
                                WarpMode   :  Boolean);

Var
  KeyS  :  Str255;

  CurrRLine
        :  LongInt;

  TTop  :  Integer;

Begin
  //PR: Moved positioning code so that it can be used to display Audit Note (read-only)
  Left:=10;
  With MULCtrlO.MUListBoxes[0] do
  Begin
    TTop:=Top+(Row*DefaultRowHeight)+90;
  end;

  Top:=TTop;

  if (NoteMode <> nmAudit) then
  begin
    EnableControls(True);



    Addch:=ResetKey;

    KeyS:='';

    CurrRLine:=0;

    ExLocal.InAddEdit:=BOn;

    ExLocal.LastEdit:=Edit;
    ExLocal.LastIns:=InsMode;
    ExLocal.LViewOnly:=ViewOnly;

    If (Edit) or (InsMode) then
      With MULCtrlO do
      Begin
        RefreshLine(MUListBoxes[0].Row,BOn);
        ExLocal.AssignFromGlobal(Fnum);
      end;

    If (Edit) then
    Begin

      With ExLocal do
      Begin
        LGetRecAddr(Fnum);
      end;

    end;


    With ExLocal,LPassWord do
    begin

      If (Not Edit) then
      Begin

        CurrRLine:=NotesRec.LineNo+Ord(InsWrap);

        LResetRec(Fnum);

        RecPFix:=NoteTCode;
        SubType:=GetSubType;

        With NotesRec do
        Begin
          If (InsMode) and (CurrRLine>0) then  {* Do not allow insert on first blank line! *}
            LineNo:=CurrRLine
          else
            LineNo:=GetLineNo;

          NoteFolio:=GetFolio;

          NoteDate:=Today;

          ShowDate:=((Not WarpMode) and (DefaultDateOn));

          NType:=GetNType;

          NoteNo:=FullRNoteKey(NoteFolio,NType,LineNo);

          NoteUser:=EntryRec^.Login;

          If (WarpMode) then
            NoteLine:=WarpStore;

        end;
      end;

      LastPWrd^:=PassWord;

      OutNote;

      //TW 05/08/2011(ABSEXCH-11034): Now checks to see who the form owner is
      //                              if it is eparentu then the alarm should be checked.
      if (self.Owner <> nil) and (self.Owner.Owner <> nil) then
        ForceAlarmed := ForceAlarmed or (self.Owner.Owner.Name = 'EParentU');

      if (ForceAlarmed) then
      begin
        NPAlaChk.Enabled := False;
        NPAlaChk.Checked := True;
      end;

      If (WarpMode) then
      Begin
        NPLine.ForceEnd;
      end;

    end; {If Abort..}

    If (Not WarpMode) then
    Begin
  {    Panel4.Visible:=Not GenNoteMode;

      NPAlaChk.Visible:=Not GenNoteMode;

      NPAlarm.Visible:=Not GenNoteMode;

      NPDate.Visible:=Not GenNoteMode;}

      Panel4.Visible := NoteMode = nmDated;

      NPAlaChk.Visible := NoteMode = nmDated;

      NPAlarm.Visible := NoteMode = nmDated;

      NPDate.Visible := NoteMode = nmDated;


      SetAllowHotKey(BOff,PrevHState);

      ShowModal;

      SetAllowHotKey(BOn,PrevHState);
    end;
  end
  else
  begin
    EnableControls(False); //Audit Note - display read-only
    OutNote;
    ShowModal;
  end;

end; {Proc..}


procedure TNoteCtrl.StoreNote(Edit,WarpMode       :  Boolean);

Var
  COk  :  Boolean;
  TmpPWrd
       :  PassWordRec;

  KeyS,
  ChkCode,
  OneLCode,
  LastLCode   :  Str255;




Begin
  KeyS:='';

  Form2Note;
  
  With ExLocal,LPassWord do
    With NotesRec do
  Begin

    Cursor:=CrHourGlass;

    If (Edit) then
    Begin

      If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
      Begin

        TmpPWrd:=LPassWord;

        LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

        Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

        LPassWord:=TmpPWrd;

      end;

      Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

    end
    else
    Begin

      If (LastIns) then
      Begin
        TmpPWrd:=LPassWord;

        ChkCode:=PartNoteKey(NoteTCode,SubType,NoteFolio);

        LastLCode:=Strip('B',[#0],PartNoteKey(NoteTCode,SubType,FullRNoteKey(NoteFolio,NType,65535)));

        OneLCode:=Strip('B',[#0],PartNoteKey(NoteTCode,SubType,FullRNoteKey(NoteFolio,NType,LineNo)));


        MULCtrlO.MoveEmUp(ChkCode,
                          LastLCode,
                          OneLCode,
                          1);


        LPassWord:=TmpPWrd;
      end;

      GetLineNo:=GetLineNo+1;

      Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

      DefaultDateOn:=ShowDate;

    end;

    Report_BError(Fnum,Status);

    If (StatusOk) then
    Begin


      With MULCtrlO do
      Begin
        AddNewRow(MUListBoxes[0].Row,Edit);
      end;

     end;

    Cursor:=CrDefault;

    InAddEdit:=Boff;

    MULCtrlO.PageUpDn(0,BOn);
    MULCtrlO.SetListFocus;


    NeedToStore:=BOn;
  end; {With..}

  If (Not WarpMode) then
    ModalResult:=mrOk;
end;



procedure TNoteCtrl.NBOkBtnClick(Sender: TObject);
var
  NoteString: String;
  NoteSubString: String;
  i: Integer;
  SpaceIndex: Integer;
begin

  If (Sender=NBOKBtn) then
  begin
    // Move focus to OK button to force OnExit validation/formatting to kick in
    If NBOkBtn.CanFocus Then
      NBOkBtn.SetFocus;
    // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
    If (ActiveControl = NBOkBtn) Then
    begin
      StoreNote(ExLocal.LastEdit,BOff);
    end;
  end
  else
  Begin
    {Visible:=Boff;}

    ModalResult:=mrCancel;

    ExLocal.InAddEdit:=Boff; 
  end;

end;


procedure TNoteCtrl.NPDateChkClick(Sender: TObject);
begin
  If (NPDateChk.Checked) and (Not ValidDate(NPDate.DateValue)) then
    NPDate.DateValue:=Today;
end;


procedure TNoteCtrl.NPDateKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

end;


procedure TNoteCtrl.NPWarpStore(Var Key  :  Char);

Var
  Idx,
  Inum  :  Byte;

Begin
  With NPLine do
  Begin

    Idx:=WordCnt(Text);

    //GS 01/08/2011 ABSEXCH-10223:
    //if the notes line only has one (very long!) word
    //then skip attempting to find a space to implement the line break / word wrap (as there wont be one!)
    //corrects the issue of very long strings producing blank note lines

    if Idx > 1 then
    begin

      Inum:=PosWord(Idx,Text);

      WarpStore:='';

      If (Not (Key In [#32,',','.','-',';'])) then
      Begin
        WarpStore:=Copy(Text,Inum,Succ(Length(Text)-Inum));

        Text:=ExtractWords(1,Pred(Idx),Text);
      end
      else
      Begin
        Text:=Text+Key;
        Key:=#0;
      end;
    end;

    StoreNote(BOff,BOn);
    InsWrap:=ExLocal.LastIns;

    ProcessNote(BOff,ExLocal.LastIns,BOff,BOn);


  end; {With..}

end;


procedure TNoteCtrl.NPDateKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);

  With ExLocal do
    If (Sender=NPLine) and ((Not LastEdit) or (LastIns))  then
    With NPLine do
    Begin
      If (Length(Text)=Pred(MaxLength)) then
      Begin
        NPWarpStore(Key);
      end
      else
        if (Length(Text)=MaxLength-2) then
          MessageBeep(0);
    end;

end;


{ ============= proc to delete one line of invoice ========== }


procedure TNoteCtrl.DeleteNoteLine;

Var
  MbRet  :  Word;
  KeyS   :  Str255;

Begin
  if (NoteMode <> nmAudit) then
  With ExLocal,MULCtrlO do
    {$B-}
    If (PageKeys^[MUListBoxes[0].Row]<>0) and (Allowed_In(BOn,403)) then
    {$B+}
    Begin
      MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Line',
                         mtConfirmation,[mbYes,mbNo],0);

      If (MbRet=MrYes) then
      Begin

        RefreshLine(MUListBoxes[0].Row,BOff);

        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,ScanFileNum,BOn,GlobLocked);

        If (Ok) and (GlobLocked) then
        Begin

          Status:=Delete_Rec(F[ScanFileNum],ScanFilenum,KeyPath);

          Report_BError(ScanFileNum,Status);
        end;

        If (StatusOk) then
        Begin
          With MULCtrlO do
          Begin
            If (MUListBox1.Row<>0) then
              PageUpDn(0,BOn)
            else
              InitPage;
          end;

          Update_Parent(0);

        end;
      end;
    end; {If line is valid for deletion..}
end; {PRoc..}

Procedure TNoteCtrl.WMNoteGetLine(Var Message  :  TMessage);

Var
  TBo  :  Boolean;

Begin

  With Message do
  Case WParam of

    0  :  If (Not ExLocal.InAddEdit) and (Not fParentLocked) then
          With Exlocal do
          {$B+}
            If (Allowed_In(BOn,401)) then
          {$B-}

          Begin
            AssignFromGlobal(Fnum);
            LGetRecAddr(Fnum);
            ProcessNote(BOn,BOff,fParentLocked,BOff);

          end;

    2  :  ShowRightMeny(LParamLo,LParamHi,1);

  end;

end;


procedure TNoteCtrl.NPNotePanelMouseDown(Sender: TObject;
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
      UpDate_Parent(18);

    end
    else
      If (Button=mbRight) then
      Begin
        ListPoint:=ClientToScreen(Point(X,Y));

        ShowRightMeny(ListPoint.X,ListPoint.Y,0);
      end;

  end;
end;

procedure TNoteCtrl.NPNotePanelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin
    MULCtrlO.VisiList.MoveLabel(X,Y);

    If (MULCtrlO.VisiList.MovingLab) then
      UpDate_Parent(18);

  end;

end;

procedure TNoteCtrl.NPNotePanelMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

  Var
    BarPos :  Integer;
    PanRSized
           :  Boolean;



begin
  PanRSized := False; //PR: 22/03/2016 v2016 R2 ABSEXCH-17390
  BarPos:=0;

  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    PanRSized:=ReSized;

    If (ScrollCont<>nil) then
      BarPos:=ScrollCont.HorzScrollBar.Position;

    If (PanRsized) then
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);


    MULCtrlO.FinishColMove(BarPos+(10*Ord(PanRSized)),PanRsized);
  end;

  If (MULCtrlO.VisiList.MovingLab or PanRSized) then
    UpDate_Parent(18);

end;


{ =========== Procedure to Update parent of notes ========= }

{ == Procedure to Send Message to Get Record == }

Procedure TNoteCtrl.Update_Parent(MMode  :  Word);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=7+MMode;
  end;

  With Message1 do
    MessResult:=SendMEssage(TForm(Owner).Handle,Msg,WParam,0);

end; {Proc..}


procedure TNoteCtrl.SetFormProperties;


Var
  TmpPanel    :  Array[1..3] of TPanel;

  n           :  Byte;

  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;

Begin
  //PR: 08/11/2010 Only notelist for Trader Window currently uses new settings system.
  if Assigned(FSettings) then
  begin
    FSettings.Edit(MULCtrlO, MULCtrlO);
    EXIT;
  end;

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
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,Self.Caption+' Properties',BeenChange,ResetDefaults);

        If (BeenChange) or (ResetDefaults) then
          UpDate_Parent(18);

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
    Update_Parent(10);
  end;

end;

procedure TNoteCtrl.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With NotesPopUpM do
  Begin
    PopUp(X,Y);

  end;


end;

procedure TNoteCtrl.AddEditNote(Edit,InsMode  :  Boolean);
Begin

  With MULCtrlO do
  {$B+}
    If (NoteMode <> nmAudit) and ((PageKeys[MUListBoxes[0].Row]<>0) or (Not Edit)) and (Not InListFind) and
    (Allowed_In(BOn,(402*Ord(InsMode))+(401*Ord(Edit))+(400*Ord(Not Edit and Not InsMode)))) then
  {$B-}
      ProcessNote(Edit,InsMode,BOff,BOff);

end;



procedure TNoteCtrl.Add1Click(Sender: TObject);
begin
  If (NoteMode <> nmAudit) and (Not fParentLocked) then
    AddEditNote((Sender=Edit1),(Sender=Insert1));
end;

procedure TNoteCtrl.Delete1Click(Sender: TObject);
begin
  With MULCtrlO do
    If (NoteMode <> nmAudit) and (ValidLine) and (Not InListFind) and (Not fParentLocked) then
      DeleteNoteLine;
end;

procedure TNoteCtrl.NotesPopupMPopup(Sender: TObject);
begin
 // RJha 21.01.206 ABSEXCH-16048 Users cann't add notes to documents already open on another workstation
  StoreCoordFlg.Checked:=FormStoreCoord.Checked;
  Add1.Visible := (NoteMode <> nmAudit) and (not fParentLocked);
  Edit1.Visible := (NoteMode <> nmAudit) and (not fParentLocked);
  Delete1.Visible :=(NoteMode <> nmAudit) and (not fParentLocked);
  Insert1.Visible := (NoteMode <> nmAudit) and (not fParentLocked);
  Clear1.Visible := (NoteMode <> nmAudit) and (not fParentLocked);
  View1.Visible := (NoteMode <> nmAudit) and (not fParentLocked);

end;

procedure TNoteCtrl.StoreCoordFlgClick(Sender: TObject);
begin
  With FormStoreCoord do
  Begin
    Checked:=Not StoreCoordFlg.Checked;
    OnClick(Sender);

    UpDate_Parent(18);
  end;
end;

procedure TNoteCtrl.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;


procedure TNoteCtrl.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);

end;

procedure TNoteCtrl.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


{ ===== Routine to input Alarm date ===== }

Procedure TNoteCtrl.Clear_Alarm;

Var
  RLocked,
  LOk  :  Boolean;
  KeyS :  Str255;


Begin
  {$B-}
  If (Assigned(MULCtrlO)) and (MulCtrlO.ValidLine) then
  With MULCtrlO,ExLocal, LPassword,NotesRec do
  Begin
    {$B+}

    LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,ScanFileNum,BOn,RLocked);

    If (LOk) and (RLocked) then
    Begin
      LGetRecAddr(ScanFileNum);

      If (RepeatNo<>0) then
      Begin
        NoteAlarm:=CalcDueDate(NoteAlarm,RepeatNo);
      end
      else
      Begin
        Blank(NoteAlarm,Sizeof(NoteAlarm));
        Blank(NoteUser,Sizeof(NoteUser));
        Blank(NoteFor,Sizeof(NoteFor));

      end;

      Status:=Put_Rec(F[ScanFileNum],ScanFilenum,LRecPtr[ScanFilenum]^,KeyPath);

      Report_BError(ScanFileNum,Status);

      UnLockMLock(ScanFileNum,LastRecAddr[ScanFileNum]);


      //PR: 08/07/2009 Copied this from Delete method - Row = 0 needs to be handled differently (20081016142429)
      If (MUListBox1.Row<>0) then
        PageUpDn(0,BOn)
      else
        InitPage;


//      PageUpDn(0,BOn);
    end; {If Locked..}
  end; {With..}

end; {Proc..}


procedure TNoteCtrl.Clear1Click(Sender: TObject);
begin
  if (NoteMode <> nmAudit) then
    Clear_Alarm;
end;

procedure TNoteCtrl.View1Click(Sender: TObject);
begin
  if (NoteMode <> nmAudit) then
    Update_Parent(301);
end;

procedure TNoteCtrl.TeleSales1Click(Sender: TObject);
begin
  Update_Parent(302);
end;

procedure TNoteCtrl.NPForExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

begin

  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Text;

      If (AltMod) and  (FoundCode<>'') and (OrigValue<>Text) and (ActiveControl<>NBCanBtn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetUser(TForm(Self.Owner),FoundCode,FoundCode,0));

        If (FoundOk) then
        Begin
          Text:=FoundCode;

          {* Weird bug when calling up a list caused the Enter/Exit methods
               of the next field not to be called. This fix sets the focus to the next field, and then
               sends a false move to previous control message ... *}


          {FieldNextFix(Self.Handle,ActiveControl,Sender);}
        end
        else
        Begin
          SetFocus;
        end; {If not found..}
      end;
    end; {with..}
  {$ENDIF}
end;

// NF: 10/05/06 Fix for incorrect Context IDs
procedure TNoteCtrl.SetHelpContextIDs;
begin
  NBOkBtn.HelpContext := 1720;
  NBCanBtn.HelpContext := 1721;
end;


// CJS 21/03/2011 ABSEXCH-11089
procedure TNoteCtrl.NPRepeatKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = '-') then
    Key := #0;
end;


//PR: 18/10/2011 v6.9 Sub-menu options to deal with addition of Audit History Notes
procedure TNoteCtrl.GeneralNotes1Click(Sender: TObject);
begin
  SwitchNoteMode(nmGeneral);
end;

procedure TNoteCtrl.DatedNotes1Click(Sender: TObject);
begin
  SwitchNoteMode(nmDated);
end;

procedure TNoteCtrl.AuditHistoryNotes1Click(Sender: TObject);
begin
  SwitchNoteMode(nmAudit);
end;

//PR: 15/11/2011 Added procedure to enable or disable controls to allow Audit Notes to be shown read-only
procedure TNoteCtrl.EnableControls(Enable: Boolean);
begin
  NPDateChk.Enabled := Enable;
  NPAlaChk.Enabled := Enable;
  NPFor.ReadOnly := not Enable;
  NPAlarm.ReadOnly := not Enable;
  NPRepeat.ReadOnly := not Enable;
  NPDate.ReadOnly := not Enable;
  NPLine.ReadOnly := not Enable;
  NBOkBtn.Enabled := Enable;

end;

end.

