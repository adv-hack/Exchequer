unit JCEmpL1U;

interface

{$I DEFOVR.Inc}

{$F+}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ComCtrls, ExtCtrls, SBSPanel, Tabnotbk, Buttons,
  ETMiscU,GlobVar,VarConst,SBSComp,SBSComp2,ExWrap1U,BTSupU1,ColCtrlU,  CmpCtrlU,

  SupListU,

  {$IFDEF LTR}
    Letters,
  {$ENDIF}

  JCEmpR3U,

  Menus,
  // SSK 21/05/2018 2018-R1.1 ABSEXCH-20308: Added support for exporting lists
  WindowExport, ExportListIntf, oExcelExport;




type

 {=== Cust List ===}

  TEmplBList  =  Class(TGenList)

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function Ok2Del :  Boolean; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    Procedure GetMiniRec(OMode     :   Byte);

  end;


  TEmplList = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    ScrolBox5: TScrollBox;
    TLCompPanel: TSBSPanel;
    TLBalPanel: TSBSPanel;
    TLAccPanel: TSBSPanel;
    TLTelPanel: TSBSPanel;
    SBSPanel1: TSBSPanel;
    Panel1: TSBSPanel;
    SBSPanel14: TSBSPanel;
    Button13: TButton;
    ScrolBox6: TScrollBox;
    TLCAddBtn: TButton;
    TLCEditBtn: TButton;
    TLCFindBtn: TButton;
    TLCDelBtn: TButton;
    TLCNoteBtn: TButton;
    TLCChkBtn: TButton;
    TLCPrnBtn: TButton;
    TLCLedBtn: TButton;
    TLCHistBtn: TButton;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    N2: TMenuItem;
    Find1: TMenuItem;
    Ledger1: TMenuItem;
    Notes1: TMenuItem;
    N3: TMenuItem;
    Delete1: TMenuItem;
    Hist1: TMenuItem;
    Print1: TMenuItem;
    PopupMenu2: TPopupMenu;
    SEC1: TMenuItem;
    SES1: TMenuItem;
    TLAccLab: TSBSPanel;
    TLCompLab: TSBSPanel;
    TLBalLab: TSBSPanel;
    TLTelLab: TSBSPanel;
    TLCLetrBtn: TButton;
    TLCSABtn: TButton;
    TLCTSBtn: TButton;
    StkAnal1: TMenuItem;
    SES2: TMenuItem;
    Rate1: TMenuItem;
    Rate2: TMenuItem;
    Leters1: TMenuItem;
    TLStatusLab: TSBSPanel;
    TLStatusPanel: TSBSPanel;
    WindowExport: TWindowExport;
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
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure TLCAddBtnClick(Sender: TObject);
    procedure TLCFindBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TLCLetrBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SEC1Click(Sender: TObject);
    procedure TLCSABtnClick(Sender: TObject);
    procedure TLCHistBtnClick(Sender: TObject);
    function WindowExportEnableExport: Boolean;
    function WindowExportGetExportDescription: String;
    procedure WindowExportExecuteCommand(const CommandID: Integer;const ProgressHWnd: HWND);


  private
    { Private declarations }


    MULCtrlO   :  Array[0..3] of TEmplBList;

    ListOfSet  :  Integer;

    ListActive,
    StoreCoord,
    InAutoRefresh,
    fFrmClosing,
    fDoingClose,
    fNeedCUpdate,
    LastCoord,
    SetDefault,
    GotCoord   :  Boolean;



    PageP,
    ScrollAP,
    ScrollBP,
    Misc1P,
    PanelP     :  TPoint;

    StartSize,
    InitSize   :  TPoint;

    CustActive :  Array[0..3] of Boolean;

    CustRecForm:  Array[0..3] of TJEmpRec;

    CustBtnList:  Array[0..3] of TVisiBtns;

    {$IFDEF Ltr}
      LettersActive: Array[0..3] of Boolean;
      LettersForm:   Array[0..3] of TLettersList;
    {$ENDIF}

    procedure Display_Account(Mode  :  Byte);

    procedure FormSetOfSet;

    procedure BuildMenus;

    procedure PrimeButtons(PageNo  :  Integer;
                           PWRef   :  Boolean);


    procedure SetTabs2;

    Procedure Send_ParentMsg(Mode   :  Integer);

    Procedure SetDeleteStat(CPage  :  Integer);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    Function KeyPressOk  :  Boolean;

    procedure SetFormProperties;

    procedure Find_FormCoord;

    procedure Store_FormCoord;


    procedure Page1Create(Sender: TObject);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    Function CheckListFinished  :  Boolean;

  public
    { Public declarations }
    ExLocal    :  TdExLocal;

    Function Current_Page  :  Integer;

    Procedure ChangePage(NewPage  :  Integer);

  end;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  DebugU,
  BTSupU2,
  BtrvU2,
  VarJCstU,
  {$IFDEF GF}
    {FindRecU,}
    FindCtlU,
  {$ENDIF}

  JobSup1U,

  BTKeys1U,
  InvListU,

  SysU2,
  PWarnU,
  ExThrd2U,
  BTSupU3,
  GDPRConst,
  EntWindowSettings;

{$R *.DFM}

var
  WindowSettings: IWindowSettings;

{ ============== TEmplBList Methods =============== }


Function TEmplBList.SetCheckKey  :  Str255;


Var
  DumStr  :  Str255;

Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  With JobMisc^,JobAnalRec do
  Begin
    DumStr:=FullJAKey(RecPfix,SubType,JAnalCode);
  end;

  SetCheckKey:=DumStr;
end;




Function TEmplBList.SetFilter  :  Str255;

Begin

  Result:=JobMisc^.RecPFix;

end;


Function TEmplBList.Ok2Del :  Boolean;

Begin
  Result:=(Not CheckExsists(JobMisc^.EmplRec.EmpCode,InvF,InvBatchK));
end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TEmplBList.OutLine(Col  :  Byte)  :  Str255;


Var
  FoundCode  :  Str10;
  FoundOk    :  Boolean;
  Dnum       :  Double;

Begin

   With JobMisc^,EmplRec do
     Case Col of

       0  :  OutLine:=EmpCode;
       1  :  begin
               // HV 30/11/2017 ABSEXCH-19394: Implements anonymisation behaviour for Emp
               if GDPROn and (emAnonymisationStatus = asAnonymised) then
                 OutLine:= capAnonymised
               else
                 OutLine:= EmpName;
             end;

       
       2  :  Begin
               If Global_GetMainRec(CustF,Supplier) then
                 OutLine:=Cust.Company
               else
                 OutLine:='';
             end;
       3  :  Begin
               OutLine:=EmplTDescL^[EType];
             end;
       4  :  begin
               //RB 28/11/2017 2018-R1 ABSEXCH-19499: 6.3.2.4 (Before ABSEXCH-19393) - Add Status field to Employee and Button to change status for employee
               OutLine := Show_EmpStatus(emStatus);
             end;
       else
             OutLine:='';

     end; {Case..}
end;


Procedure TEmplBList.GetMiniRec(OMode     :   Byte);


Const
  ModeMess  :  Array[1..3] of String[20] = ('Job Type','Analysis Code','Employee');

Var
  InpOk       :  Boolean;
  FoundCode   :  Str20;
  KeyS,
  KeyChk      :  Str255;
  GMMode      :  Byte;

  SCode       :  String;



Begin

  KeyChk:='';

  GMMode:=0;

  Begin
    KeyS:='';

    InpOk:=InputQuery('Find '+ModeMess[OMode],'Search for which '+ModeMess[OMode]+'?',SCode);


    {*EX32 if a copy last is required, set here *}


    If (InpOk) then
    Begin
      KeyS:=UpCaseStr(SCode);

      Case ScanFileNum of


        JMiscF  :   Begin

                     Case OMode of

                       1..3
                             :  Begin

                                  InpOk:=GetJobMisc(Self.Owner,KeyS,FoundCode,OMode,0);

                                  If (InpOk) then
                                  Begin
                                    KeyChk:=PartCCKey(JARCode,JASubAry[OMode])+FoundCode;
                                    KeyS:=KeyChk;

                                    Status:=Find_Rec(B_GetGEq,F[ScanFileNum],
                                                     ScanFileNum,RecPtr[ScanFileNum]^,JMK,KeyS);

                                    If (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) then
                                      AddNewRow(0,BOn);
                                  end;

                                end;


                     end; {Case..}

                   end;



      end; {Case..}

    end;
  end;
end;




{ =================================================================================== }



Function TEmplList.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(PAgeControl1);

end;


procedure TEmplList.Display_Account(Mode  :  Byte);

Var
  CPage    :  Integer;

  TSBtn    :  TObject;

Begin
  GlobPRateMode:=Ord(Mode=8);

  CPage:=0+GlobPRateMode;


  If (CustRecForm[CPage]=nil) then
  Begin

    {Set_CustFormMode(1-CPage);}

    CustRecForm[CPage]:=TJEmpRec.Create(Self);

  end
  else //HV 06/12/2017 ABSEXCH-19535: Anonymised Trader > The height of the window gets increased if "Save coordinates" is ticked
    CustRecForm[CPage].ListScanningOn  := True;

  Try

   CustActive[CPage]:=BOn;

   With CustRecForm[CPage] do
   Begin

     // HV 29/11/2017 ABSEXCH-19394: Implements anonymisation behaviour for trader
     If (Not ExLocal.InAddEdit) then      // SSK 08/12/2017 ABSEXCH-19546: this needs to be checked
       AnonymisationON := GDPROn and (Mode <> 1) and (JobMisc^.EmplRec.emAnonymisationStatus in [asPending, asAnonymised]);

     WindowState:=wsNormal; 

     CanDelete:=TLCDelBtn.Enabled;

     If (Not ExLocal.InAddEdit) and (GlobPRate=0) then
       ShowLink;


     If (Mode In [1..3]) and (Not ExLocal.InAddEdit) then
     Begin
       ChangePage(0);

       If (Mode=3) then
         DeleteAccount
       else
         EditAccount((Mode=2));
     end;

     Case Mode of

       5..7  :  ChangePage(Mode-4);
       8     :  ChangePage(3);

       9     :  If (HistFormPtr=nil) then
                  Display_History(1,BOn);

     end;



   end; {With..}


  except

   CustActive[Current_Page]:=BOff;

   CustRecForm[Current_Page].Free;

  end;


end;




Procedure  TEmplList.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TEmplList.Find_FormCoord;
begin
  //GS: 05/04/11 ABSEXCH-10804 changed the load form settings code to use the new IWindowSettings interface object
  //populate the object with setting data stored in the database
  WindowSettings.LoadSettings;
  //extract the form settings and apply them to the given form object
  WindowSettings.SettingsToWindow(self);
  //extract the multi list settings and apply them to the multi control object
  WindowSettings.SettingsToParent(MULCtrlO[0]);
  //'SettingsToWindow' resizing the form with non default coords will trigger the FormResize event, inadvertently
  //making 'NeedCUpdate' true, so, force 'need coordinate update' to false, we only want it true when the user resizes the form
  fNeedCUpdate := False;
  //record the new form dimensions that 'SettingsToWindow' has just loaded
  //so the program can determine if the form has been resized or not
  StartSize.X := Self.Width;
  StartSize.Y := Self.Height;
end;//end Find_FormCoord

procedure TEmplList.Store_FormCoord;
begin
  //GS: 05/05/11 ABSEXCH-10804 changed old 'store form settings' code to use the new IWindowSettings interface object
  //load the form, and the multi list controls settings into the IWindowSettings object
  WindowSettings.WindowToSettings(self);
  WindowSettings.ParentToSettings(MULCtrlO[0],MULCtrlO[0]);
  //store the settings inside the database; coordinate settings
  //are saved if the user selected the 'save' popup menu command
  WindowSettings.SaveSettings(StoreCoord);
end;//end Store_FormCoord

procedure TEmplList.FormSetOfSet;


Begin
  PageP.X:=ClientWidth-(PageControl1.Width);
  PageP.Y:=ClientHeight-(PageControl1.Height);

  ScrollAP.X:=PageControl1.Width-(ScrolBox5.Width);
  ScrollAP.Y:=PageControl1.Height-(ScrolBox5.Height);

  ScrollBP.X:=PageControl1.Width-(Panel1.Left);
  ScrollBP.Y:=PageControl1.Height-(Panel1.Height);

  Misc1P.X:=Panel1.Height-(ScrolBox6.Height);
  Misc1P.Y:=ScrolBox5.ClientHeight-(TLAccPanel.Height);

  PanelP.X:=PageControl1.Width-(SBSPanel14.Left);
  PanelP.Y:=Panel1.Height-(SBSPanel14.Height);


  GotCoord:=BOn;

end;

procedure TEmplList.BuildMenus;

Begin
  {}
  CreateSubMenu(PopUpMenu2,StkAnal1);
end;


procedure TEmplList.PrimeButtons(PageNo  :  Integer;
                                 PWRef   :  Boolean);

Var
  LastPage  :  TTabSheet;


Begin
  If (PWRef) and (Assigned(CustBtnList[PageNo])) then
  Begin
    LastPage:=PageControl1.ActivePage;

    SetTabs2;

    If (PageControl1.ActivePage<>LastPage) then
      PageControl1.ActivePage:=LastPage;

    CustBtnList[PageNo].ResetButtons;
    CustBtnList[PageNo].Free;
    CustBtnList[PageNo]:=nil;
  end;

  If (CustBtnList[PageNo]=Nil) then
  Begin
    CustBtnList[PageNo]:=TVisiBtns.Create;

    try

      With CustBtnList[PageNo] do
      Case PageNo of

        0   :  Begin
            {00} PWAddVisiRec(TLCAddBtn,BOff,-255);
            {01} PWAddVisiRec(TLCEditBtn,BOff,-255);
            {02} PWAddVisiRec(TLCFindBtn,BOff,-255);
            {03} PWAddVisiRec(TLCDelBtn,BOff,-255);
            {04} PWAddVisiRec(TLCLedBtn,BOff,223);
            {05} PWAddVisiRec(TLCHistBtn,BOff,224);
            {06} PWAddVisiRec(TLCNoteBtn,BOff,-255);
            {07} PWAddVisiRec(TLCTSBtn,BOff,222);
            {08} PWAddVisiRec(TLCChkBtn,BOff,235);
            {09} PWAddVisiRec(TLCSABtn,BOff,-255);
            {10} PWAddVisiRec(TLCPrnBtn,BOn,-255);
            {11} PWAddVisiRec(TLCLetrBtn,BOff,-255);
            

                 HideButtons;
               end;


      end; {Case..}

    except

      CustBtnList[PageNo].Free;

    end; {Try..}

  end;

end;

procedure TEmplList.SetTabs2;

Begin
  {}
end;

procedure TEmplList.FormCreate(Sender: TObject);
Var
  n  :  Integer;

  StartPanel
     :  TSBSPanel;

  KeyStart
     :  Str255;

begin

  //GS: 05/05/11 ABSEXCH-10804 get an instance of the IWindowSettings interface object, used for storing the forms settings
  WindowSettings := EntWindowSettings.GetWindowSettings(self.Name);

  PrimeButtons(0,BOff);

  BuildMenus;

  ListActive:=BOff;
  GotCoord:=BOff;

  LastCoord:=BOff;
  NeedCUpdate:=BOff;

  InAutoRefresh:=BOff;
  fFrmClosing:=BOff;
  fDoingClose:=BOff;

  ExLocal.Create;


  SetTabs2;

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;


  MULCtrlO[0]:=TEmplBList.Create(Self);

  PageControl1.ActivePage:=TabSheet1;


  Try
    StartPanel := nil;
    With MULCtrlO[0] do
    Begin

      Try

        With VisiList do
        Begin
          AddVisiRec(TLAccPanel,TLAccLab);
          AddVisiRec(TLCompPanel,TLCompLab);
          AddVisiRec(TLBalPanel,TLBalLab);
          AddVisiRec(TLTelPanel,TLTelLab);
          //RB 28/11/2017 2018-R1 ABSEXCH-19499: 6.3.2.4 (Before ABSEXCH-19393) - Add Status field to Employee and Button to change status for employee
          AddVisiRec(TLStatusPanel, TLStatusLab);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          LabHedPanel:=SBSPanel1;

        end;
      except
        VisiList.Free;

      end;

      {InitSize.Y:=366;
      InitSize.X:=472;

      Self.Height:=InitSize.Y;
      Self.Width:=InitSize.X;}

      InitSize.Y:=340;
      InitSize.X:=584;

      Self.ClientHeight:=InitSize.Y;
      Self.ClientWidth:=InitSize.X;


      MDI_SetFormCoord(TForm(Self));





      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      //RB 28/11/2017 2018-R1 ABSEXCH-19499: 6.3.2.4 (Before ABSEXCH-19393) - Add Status field to Employee and Button to change status for employee
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

      end;

      Self.Refresh;

      ListCreate;


      Set_Buttons(SBSPanel14);

      AbortOnEmpty:=BOn;

      KeyStart:=PartCCKey(JARCode,JASubAry[3]);

      StartList(JMiscF,JMK,KeyStart,'','',Length(KeyStart),BOff);


      ListOfSet:=10;



    end {With}


  Except

    MULCtrlO[0].Free;
    MULCtrlO[0]:=Nil;
  end;


  FormSetOfSet;
  Find_FormCoord;
  //GS: 05/05/11 ABSEXCH-10804 invoke the forms 'resize' event, as this contains code for
  //resizing the forms columns
  FormReSize(Self);
end;


procedure TEmplList.FormActivate(Sender: TObject);
begin
  If (MULCtrlO[0]<>nil) then
    MULCtrlO[0].SetListFocus;

  ListActive:=BOn;
end;


procedure TEmplList.FormDestroy(Sender: TObject);

Var
  n  :  Byte;

begin

  ExLocal.Destroy;

  For n:=Low(CustBtnList) to High(CustBtnList) do
    If (CustBtnList[n]<>nil) then
    Begin
      CustBtnList[n].Free;
      CustBtnList[n]:=nil;
    end;


  {$IFDEF XXXXX} {*EN430}
    For n:=0 to High(MULCtrlO) do  {* Seems to crash here if form open and you close app... *}
      If (MULCtrlO[n]<>nil) then
      Begin
        MULCtrlO[n].Destroy;
        MULCtrlO[n]:=nil;
      end;

  {$ENDIF}

end;




procedure TEmplList.Page1Create(Sender: TObject);

begin

end;

Procedure TEmplList.SetDeleteStat(CPage  :  Integer);

Var
  CanDelete  :  Boolean;

Begin
  If (Assigned(MULCtrlO[0])) then
  Begin
    CanDelete:=MULCtrlO[0].Ok2Del;

    Case Current_Page of

      0  :  TLCDelBtn.Enabled:=CanDelete;

    end; {Case..}
  end;
end;


Procedure TEmplList.WMCustGetRec(Var Message  :  TMessage);


Begin


  With Message do
  Begin

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

    100,
    101  :  With MULCtrlO[WParam-100] do
            Begin
              AddNewRow(MUListBoxes[0].Row,(LParam=1));
            end;

    170  :  ;{TLCPrnBtnClick(nil);}
    175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);

    177  :  Begin
              PrimeButtons(Current_Page,BOn);

              Check_TabAfterPW(PageControl1,Self,WM_CustGetRec);

            end;


    200,
    201  :  Begin
              CustActive[WParam-200]:=Boff;
              CustRecForm[WParam-200]:=nil;

            end;

    300,
    301  :  With MULCtrlO[WParam-300] do
            Begin
              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;
            end;


    400,
    401  :  Begin
              {$IFDEF Ltr}
                LettersActive[0]:=Boff;
                LettersForm[0]:=nil;
              {$ENDIF}
            end;

    3000,
    3001  : With MULCtrlO[WParam-3000] do
            Begin
              Find_OnList(Cust.CustCode,CustCodeK);

              With MUListBoxes[0] do
                If (CanFocus) then
                  SetFocus;
            end;

    3100,
    3101  : With MULCtrlO[WParam-3100] do
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
     SetDeleteStat(Current_Page);

  end;
  Inherited;
end;



Procedure TEmplList.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of
      1001  : {* This handling was placed here so to give the list a chance to see the mouse up event *}

            Begin
              If (CustRecForm[Current_Page]<>nil) and (CustActive[Current_Page]) then
              With CustRecForm[Current_Page] do
              Begin
                If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit) and (JobMisc^.EmplRec.EmpCode<>ExLocal.LJobMisc^.EmplRec.EmpCode) then
                Begin
                  CanDelete:=TLCDelBtn.Enabled;
                  //HV 06/12/2017 ABSEXCH-19535: Anonymised Trader > The height of the window gets increased if "Save coordinates" is ticked
                  ListScanningOn := True;
                  AnonymisationON := GDPROn and (JobMisc^.EmplRec.emAnonymisationStatus in [asPending, asAnonymised]);
                  ShowLink;
                end;
              end;


              {$IFDEF Ltr}
                { Check for link to letters }
                If Assigned(LettersForm[Current_Page]) And LettersActive[Current_Page] Then
                  With LettersForm[Current_Page] Do Begin
                    If (WindowState <> wsMinimized) and (JobMisc^.EmplRec.EmpCode <> ExLocal.LJobMisc^.EmplRec.EmpCode) Then Begin
                      {ShowLink(True);}
                      LoadLettersFor (JobMisc^.EmplRec.EmpCode,
                                      JobMisc^.EmplRec.EmpCode,
                                      Trim(JobMisc^.EmplRec.EmpCode),
                                      LetterEmplCode,
                                      Nil, Nil, Nil, Nil, JobMisc);
                    End; { If }
                  End; { With }
              {$ENDIF}
            End; { 1 }


    end; {Case..}

  end; {With..}

end; {Proc..}



Procedure TEmplList.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

procedure TEmplList.TLAccPanelMouseUp(Sender: TObject;
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

    Case Current_Page of
      0  :  BarPos:=ScrolBox5.HorzScrollBar.Position;
    end;

    If (PanRsized) then
      MULCtrlO[Current_Page].ResizeAllCols(MULCtrlO[Current_Page].VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO[Current_Page].FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO[Current_Page].VisiList.MovingLab or PanRSized);
  end;

end;


procedure TEmplList.TLAccLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      MULCtrlO[Current_Page].VisiList.PrimeMove(Sender);
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

procedure TEmplList.TLAccLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    MULCtrlO[Current_Page].VisiList.MoveLabel(X,Y);
    NeedCUpdate:=MULCtrlO[Current_Page].VisiList.MovingLab;
  end;

end;

procedure TEmplList.FormResize(Sender: TObject);

Var
  n          :  Byte;


begin

  If (GotCoord) and (Not fDoingClose) then
  Begin
    MULCtrlO[Current_Page].LinkOtherDisp:=BOff;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    PageControl1.Width:=ClientWidth-PageP.X;
    PageControl1.Height:=ClientHeight-PageP.Y;


    ScrolBox5.Width:=PageControl1.Width-ScrollAP.X;
    ScrolBox5.Height:=PageControl1.Height-ScrollAP.Y;

    Panel1.Left:=PageControl1.Width-ScrollBP.X;
    Panel1.Height:=PageControl1.Height-ScrollBP.Y;

    ScrolBox6.Height:=Panel1.Height-Misc1P.X;

    {SBSPanel14.Left:=PageControl1.Width-PanelP.X;}
    SBSPanel14.Height:=Panel1.Height-PanelP.Y;


    For n:=0 to 1 do
    If (MULCtrlO[n]<>nil) then
    Begin
      With MULCtrlO[n].VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=ScrolBox5.ClientHeight-Misc1P.Y;
      end;


      With MULCtrlO[n] do
      Begin
        ReFresh_Buttons;

        RefreshAllCols;
      end;
    end;{Loop..}

    MULCtrlO[Current_Page].LinkOtherDisp:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end; {Proc..}

procedure TEmplList.TLCloseBtnClick(Sender: TObject);
begin
  If (Not MULCtrlO[Current_Page].InListFind) then
    Close;
end;

procedure TEmplList.SetFormProperties;


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

    With MULCtrlO[Current_Page].VisiList do
    Begin
      VisiRec:=List[0];

      TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
      TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

      TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
      TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;


      TmpPanel[3].Color:=MULCtrlO[Current_Page].ColAppear^[0].HBKColor;
    end;

    TmpPanel[3].Font.Assign(TmpPanel[1].Font);

    TmpPanel[3].Font.Color:=MULCtrlO[Current_Page].ColAppear^[0].HTextColor;


    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,'Employee List Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then
        Begin

          For n:=1 to 3 do
            With TmpPanel[n] do
              Case n of
                1,2  :  MULCtrlO[Current_Page].ReColorCol(Font,Color,(n=2));

                3    :  MULCtrlO[Current_Page].ReColorBar(Font,Color);
              end; {Case..}

          MULCtrlO[Current_Page].VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
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

procedure TEmplList.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TEmplList.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;


procedure TEmplList.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

  With CustBtnList[Current_Page] do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);

    With PopUpMenu1 do
    For n:=0 to Pred(Count) do
      SetMenuFBtn(Items[n],n);

  end;


end;

procedure TEmplList.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin
    N3.Tag:=99*Mode;

    PopUp(X,Y);

    N3.Tag:=0;
  end;


end;


{ == Procedure to Send Message to Get Record == }

Procedure TEmplList.Send_ParentMsg(Mode   :  Integer);

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

procedure TEmplList.FormClose(Sender: TObject; var Action: TCloseAction);

Var
  n  :  Byte;

begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

    Send_ParentMsg(56); {Form closing..}

    For n:=Low(MULCtrlO) to High(MULCtrlO) do  {* Seems to crash here if form open and you close app... *}
      If (MULCtrlO[n]<>nil) then
      Begin
        MULCtrlO[n].Destroy;
        MULCtrlO[n]:=nil;
        //GS: 05/05/11 ABSEXCH-10804 Dereference IWindowSettings interface object
        WindowSettings := NIL;
      end;

  end;

end;

Function TEmplList.CheckListFinished  :  Boolean;

Var
  n       :  Byte;
  mbRet   :  Word;
Begin
  Result:=BOn;

  For n:=Low(MULCtrlO) to High(MULCtrlO) do
  Begin
    If (Assigned(MULCtrlO[n])) then
      Result:=Not MULCtrlO[n].ListStillBusy;

    If (Not Result) then
    Begin
      Set_BackThreadMVisible(BOn);

      mbRet:=MessageDlg('One of the lists is still busy.'+#13+#13+
                        'Do you wish to interrupt the list so that you can exit?',mtConfirmation,[mbYes,mbNo],0);

      If (mBRet=mrYes) then
      Begin
        MULCtrlO[n].IRQSearch:=BOn;

        ShowMessage('Please wait a few seconds, then try closing again.');
      end;

      Set_BackThreadMVisible(BOff);

      Break;
    end;
  end;
end;


procedure TEmplList.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

Var
  n  :  Integer;

begin

  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;

    Try
      GenCanClose(Self,Sender,CanClose,BOn);

      If (CanClose) then
        CanClose:=CheckListFinished;

      If (CanClose) then
        CanClose:=Not InAutoRefresh;

      If (CanClose) then
      Begin
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
      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;
end;




procedure TEmplList.PageControl1Change(Sender: TObject);
Var
  n,
  NewIndex  :  Integer;
begin

  If (Sender is TPageControl) then
    With Sender as TPageControl do
    Begin
      NewIndex:=pcLivePage(Sender);

      Case NewIndex of
        0  :  ;
      end; {Case..}

      If (MULCtrlO[NewIndex]<>nil) and (ListActive) then
        MULCtrlO[NewIndex].SetListFocus;
    end;

end;

procedure TEmplList.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);

begin

  Release_PageHandle(Sender);

end;

Procedure TEmplList.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With PageControl1 do
  Begin
    Case NewPage of

      0  :  ActivePage:=TabSheet1;
      2  :  ActivePage:=TabSheet3;
      3  :  ActivePage:=TabSheet4;

    end; {Case..}

    PageControl1Change(PageControl1);
  end; {With..}
end; {Proc..}


Function TEmplList.KeyPressOk  :  Boolean;

Begin
  If (Assigned(MULCtrlO[Current_Page])) then
    Result:=Not MULCtrlO[Current_Page].InListFind
  else
    Result:=BOn;
end;

procedure TEmplList.TLCAddBtnClick(Sender: TObject);

Var
  EditMode,
  DelMode,
  NoteMode,
  HistMode,
  LedgMode,
  GlobMode,
  RateMode   :  Boolean;

begin
  If (Not MULCtrlO[Current_Page].InListFind) then
  Begin

    With MULCtrlO[Current_Page] do
      RefreshLine(MUListBoxes[0].Row,BOff);

    EditMode:=((Sender=TLCEditBtn) or (Sender=Edit1));

    DelMode:=((Sender=TLCDelBtn) or (Sender=Delete1));

    NoteMode:=((Sender=TLCNoteBtn) or (Sender=Notes1));

    LedgMode:=((Sender=TLCLedBtn) or (Sender=Ledger1));

    RateMode:=((Sender=TLCTSBtn) or (Sender=Rate1));

    GlobMode:=((Sender=TLCChkBtn) or (Sender=Rate2));

    Display_Account(1+(1*Ord(EditMode))+(2*Ord(DelMode))+(4*Ord(NoteMode))+(5*Ord(LedgMode))+(6*Ord(RateMode))+(7*Ord(GlobMode)));

  end;
end;


procedure TEmplList.TLCHistBtnClick(Sender: TObject);
begin
  If (KeyPressOk) then
  Begin
    With MULCtrlO[Current_Page] do
      GetSelRec(BOff);

    Display_Account(9);
  end;
end;


procedure TEmplList.TLCFindBtnClick(Sender: TObject);


begin

  If (Not MULCtrlO[Current_Page].InListFind)  then
  Begin
    MULCtrlO[Current_Page].GetMiniRec(3);
  end;
end;


procedure TEmplList.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TEmplList.TLCLetrBtnClick(Sender: TObject);
Var
  CPage : Integer;
begin
  If (KeyPressOk) then
  Begin

  {$IFDEF Ltr}

    { Take copy of page }
    CPage := Current_Page;

    { Create form if not already created }
    If Not Assigned (LettersForm[CPage]) Then Begin
      { Create letters form }
      LettersForm[CPage] := TLettersList.Create (Self);
    End; { If }

    Try
      { mark form as active }
      LettersActive[CPage] := BOn;

      { Get customer record }
      MULCtrlO[Current_Page].GetSelRec(BOff);

      With LettersForm[CPage] Do Begin
        { Display form }
        WindowState := wsNormal;
        Show;

        LoadLettersFor (JobMisc^.EmplRec.EmpCode,
                        JobMisc^.EmplRec.EmpCode,
                        Trim(JobMisc^.EmplRec.EmpCode),
                        LetterEmplCode,
                        Nil, Nil, Nil, Nil, JobMisc);
      End; { With }
    Except
     LettersActive[Current_Page] := BOff;
     LettersForm[Current_Page].Free;
    End;
  {$ENDIF}
  end;
end;


procedure TEmplList.SEC1Click(Sender: TObject);
begin
  If Assigned(MULCtrlO[Current_Page]) and (Sender is TMenuItem) then
  With MULCtrlO[Current_Page] do
  Begin
    Case TMenuItem(Sender).Tag of
      0  :  Keypath:=JMK;
      1  :  Keypath:=JMSecK;
      2  :  Keypath:=JMTrdK;

    end; {Case..}

    InitPage;
  end;

end;

procedure TEmplList.TLCSABtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;

begin

  If (KeyPressOk) then
  Begin

    If (Current_Page=0) then
    Begin
      Begin
        With TWinControl(Sender) do
        Begin
          ListPoint.X:=1;
          ListPoint.Y:=1;

          ListPoint:=ClientToScreen(ListPoint);

        end;

        PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);
      end;
    end;
  end;
end;

function TEmplList.WindowExportEnableExport: Boolean;
begin
  Result := True;
  WindowExport.AddExportCommand (ecIDCurrentRow, ecdCurrentRow);
  WindowExport.AddExportCommand (ecIDCurrentPage, ecdCurrentPage);
  WindowExport.AddExportCommand (ecIDEntireList, ecdEntireList);
end;

procedure TEmplList.WindowExportExecuteCommand(const CommandID: Integer;const ProgressHWnd: HWND);
Var
  ListExportIntf : IExportListData;
begin
  // Returns a new instance of an "Export Btrieve List To Excel" object
  ListExportIntf := NewExcelListExport;
  try
    ListExportIntf.ExportTitle := WindowExportGetExportDescription;

    // Connect to Excel
    If ListExportIntf.StartExport Then
    begin
      // Get the active Btrieve List to export the data
      MulCtrlO[Current_Page].ExportList (ListExportIntf, CommandID, ProgressHWnd);

      ListExportIntf.FinishExport;
    end; // If ListExportIntf.StartExport(sTitle)
  finally
    ListExportIntf := NIL;
  end; // Try..Finally

end;

function TEmplList.WindowExportGetExportDescription: String;
begin
  Result := 'Employee Sub-Contractor List';
end;


Initialization


end.
