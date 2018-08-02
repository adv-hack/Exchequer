unit JobDbk2U;

interface

{$I DEFOVR.Inc}

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ComCtrls, ExtCtrls, SBSPanel,
  GlobVar,VarConst,SBSComp,SBSComp2,ExWrap1U,BTSupU1,ColCtrlU,
  CmpCtrlU,SupListU, Menus, Math,

  ExtGetU,

  DayBk2,
  {$IFDEF CU}
  // 23/01/2013 PKR ABSEXCH-13449
  CustomBtnHandler,
  {$ENDIF}

  // MH 08/03/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
  WindowExport, ExportListIntf, oExcelExport,

  DocSupU1, TCustom;
  
type
  {=== Daybook List ===}

  TJDayBkMList  =  Class(TDayBkMList)

   Public
    LinePosted  :  Boolean;

    Function SetCheckKey  :  Str255; Override;

    Function SetFilter  :  Str255; Override;

    Function CheckRowEmph :  Byte; Override;

    Function Ok2Del :  Boolean; Override;

    Function Link2InvLine :  Boolean;

    Function Link2Inv(Var  InvPosted  :  Boolean)  :  Boolean;

    // PKR. 17/11/2015. ABSEXCH-16318. Add Transaction Owner (User Name) column to daybooks
    function GetTransactionOwner(aLineORef : string) : string;

    Function OutJobAct(Col  :  Byte)  :  Str255;

    Function OutTSLine(Col  :  Byte)  :  Str255;

    Function OutJALine(Col  :  Byte)  :  Str255;

    Function OutJobReten(Col  :  Byte)  :  Str255;

    Function OutLine(Col  :  Byte)  :  Str255; Override;


  end;



  TJobDaybk = class(TForm)
    DPageCtrl1: TPageControl;
    MainPage: TTabSheet;
    QuotesPage: TTabSheet;
    db1SBox: TScrollBox;
    db1HedPanel: TSBSPanel;
    db1ORefLab: TSBSPanel;
    db1DateLab: TSBSPanel;
    db1AccLab: TSBSPanel;
    db1WkLab: TSBSPanel;
    db1StatLab: TSBSPanel;
    db1PrLab: TSBSPanel;
    AutoPage: TTabSheet;
    db1OrefPanel: TSBSPanel;
    db1DatePanel: TSBSPanel;
    db1PrPanel: TSBSPanel;
    db1AccPanel: TSBSPanel;
    db1PstdPanel: TSBSPanel;
    db1StatPanel: TSBSPanel;
    db1OwnerPanel: TSBSPanel;
    HistoryPage: TTabSheet;
    PopupMenu1: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Find1: TMenuItem;
    Notes1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    Hold1: TMenuItem;
    Copy1: TMenuItem;
    Convert1: TMenuItem;
    Post1: TMenuItem;
    Print1: TMenuItem;
    Remove1: TMenuItem;
    db1DescPanel: TSBSPanel;
    db1DescLab: TSBSPanel;
    db1ListBtnPanel: TSBSPanel;
    db1BtnPanel: TSBSPanel;
    db1BSBox: TScrollBox;
    Adddb1Btn: TButton;
    Editdb1Btn: TButton;
    Finddb1Btn: TButton;
    Printdb1Btn: TButton;
    Holddb1Btn: TButton;
    Convdb1Btn: TButton;
    CopyDb1Btn: TButton;
    Notedb1Btn: TButton;
    Postdb1Btn: TButton;
    Remdb1Btn: TButton;
    Clsdb1Btn: TButton;
    Viewdb1Btn: TButton;
    View1: TMenuItem;
    PopupMenu2: TPopupMenu;
    Copy2: TMenuItem;
    Reverse1: TMenuItem;
    PopupMenu3: TPopupMenu;
    HQ1: TMenuItem;
    MenuItem3: TMenuItem;
    HC1: TMenuItem;
    N5: TMenuItem;
    HSP1: TMenuItem;
    HR1: TMenuItem;
    EntCustom1: TCustomisation;
    CustdbBtn1: TSBSButton;
    CustdbBtn2: TSBSButton;
    Custom1: TMenuItem;
    Custom2: TMenuItem;
    db1JCPanel: TSBSPanel;
    db1JCLab: TSBSPanel;
    db1ExpPanel: TSBSPanel;
    db1ExpLab: TSBSPanel;
    db1QtyLab: TSBSPanel;
    db1QtyPanel: TSBSPanel;
    db1ChrgPanel: TSBSPanel;
    db1WkPanel: TSBSPanel;
    db1CostLab: TSBSPanel;
    db1ChrgLab: TSBSPanel;
    db1PstdLab: TSBSPanel;
    db1CostPanel: TSBSPanel;
    SBSPopupMenu1: TSBSPopupMenu;
    ViewR1: TMenuItem;
    ViewR2: TMenuItem;
    SBSPopupMenu2: TSBSPopupMenu;
    PostJD1: TMenuItem;
    PostJD2: TMenuItem;
    db1UpliftPanel: TSBSPanel;
    db1UpLab: TSBSPanel;
    SBSPopupMenu3: TSBSPopupMenu;
    EdtChmi: TMenuItem;
    Edtulmi: TMenuItem;
    PLAPage: TTabSheet;
    TSHistPage: TTabSheet;
    SLAPage: TTabSheet;
    PLAHPage: TTabSheet;
    SLAHPage: TTabSheet;
    SBSPopupMenu4: TSBSPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    PopupMenu7: TPopupMenu;
    Tag2: TMenuItem;
    Untag1: TMenuItem;
    AggTag1: TMenuItem;
    CustdbBtn3: TSBSButton;
    CustdbBtn4: TSBSButton;
    CustdbBtn5: TSBSButton;
    CustdbBtn6: TSBSButton;
    Custom3: TMenuItem;
    Custom4: TMenuItem;
    Custom5: TMenuItem;
    Custom6: TMenuItem;
    db1OwnerLab: TSBSPanel;
    WindowExport: TWindowExport;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure DPageCtrl1Change(Sender: TObject);
    procedure Clsdb1BtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure db1OrefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure db1ORefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure db1ORefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure Adddb1BtnClick(Sender: TObject);
    procedure DPageCtrl1Changing(Sender: TObject;
                               var AllowChange: Boolean);
    procedure FormDeactivate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CopyDb1BtnClick(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure Holddb1BtnClick(Sender: TObject);
    procedure HQ1Click(Sender: TObject);
    procedure Printdb1BtnClick(Sender: TObject);
    procedure Remdb1BtnClick(Sender: TObject);
    procedure Finddb1BtnClick(Sender: TObject);
    procedure PrintDoc1Click(Sender: TObject);
    procedure Viewdb1BtnClick(Sender: TObject);
    procedure ViewR1Click(Sender: TObject);
    procedure Postdb1BtnClick(Sender: TObject);
    procedure PostJD1Click(Sender: TObject);
    procedure Notedb1BtnClick(Sender: TObject);
    procedure EdtChmiClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure Convdb1BtnClick(Sender: TObject);
    procedure Tag2Click(Sender: TObject);
    procedure Untag1Click(Sender: TObject);
    procedure CustdbBtn1Click(Sender: TObject);
    function WindowExportEnableExport: Boolean;
    procedure WindowExportExecuteCommand(const CommandID: Integer;
      const ProgressHWnd: HWND);
    function WindowExportGetExportDescription: String;


  private
    { Private declarations }

    UpDateFromPost,
    INHBeen,
    ListActive,
    KeepLive,
    fNeedCUpdate,
    FColorsChanged,
    fFrmClosing,
    fDoingClose,
    StoreCoord,
    LastCoord,
    SetDefault,
    ForApps,
    GotCoord   :  Boolean;

    PagePoint  :  Array[0..4] of TPoint;

    StartSize,
    InitSize   :  TPoint;

    LastDocHed,
    PSOPDocHed,
    DocHed     :  DocTypes;

    CustBtnList:  TVisiBtns;

    FormBitMap :  TBitMap;

    RetRecPtr  :  Array[BOff..Bon] of Pointer;

    DispTransPtr
               :  Array[BOff..Bon] of Pointer;


    SysMenuH     :  HWnd;

    {$IFDEF CU}
    // 25/01/2013  PKR   ABSEXCH-13449/38
    FormPurpose : TFormPurpose;
    RecordState : TRecordState;
    {$ENDIF}
    
    procedure Find_Page1Coord(PageNo  :  Integer);

    procedure Store_Page1Coord(UpMode  :  Boolean);

    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Function ChkPWord(PageNo :  Integer;
                      HelpS,
                      HelpP,
                      HelpN,
                      HelpA,
                      HelpSA,
                      HelpPA  :  LongInt) :  LongInt;


    Function SetHelpC(PageNo :  Integer;
                      Pages  :  TIntSet;
                      Help0,
                      Help1,
                      Help2,
                      Help3,
                      Help4,
                      Help5 :  LongInt) :  LongInt;


    procedure PrimeButtons(PageNo  :  Integer;
                           PWRef   :  Boolean);

    procedure SetTabs2;


    procedure BuildMenus;

    Procedure Send_ParentMsg(Mode   :  Integer);

    procedure HidePanels(PageNo  :  Byte);

    procedure Page1Create(Sender   : TObject;
                          NewPage  : Byte);

    procedure PrintRetCr;

    procedure PrintDoc(Sender: TObject);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    procedure SetFormProperties;


    procedure Display_Trans(Mode  :  Byte;
                            IsApp :  Boolean );


    Procedure WMDayBkGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure UpdatePostStatus(PageNo  :  Integer);

    Procedure WMFormCloseMsg(Var Message  :  TMessage); Message WM_FormCloseMsg;

    Procedure WMSetFocus(Var Message  :  TMessage); Message WM_SetFocus;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;

    

    {$IFDEF DBD}
      Procedure DebugProc;
    {$ENDIF}


    {$IFDEF GF}
      procedure FindDbItem(Sender: TObject);
    {$ENDIF}

    Function ScanMode(IsApp  :  Boolean)  :  Boolean;

    procedure SendObjectCC;

    procedure AddDocCtrl(Sender: TObject);

    procedure DeleteDoc;

    procedure Display_RetRec(Mode     :  Byte;
                             IsSales  :  Boolean);

    procedure EditRetRec(Sender  : TObject;
                         IsSales : Boolean);

    procedure EditCharge(ORMode   :  Byte);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    Function CheckListFinished  :  Boolean;

    Function GetTagNo(Var TNo  :  Byte;
                          Mode :  Byte)  :  Boolean;

    procedure TagTrans(Sender: TObject);

  public
    { Public declarations }

    ExLocal    :  TdExLocal;

    LastHRunNo :  LongInt;

    ListOfSet  :  Integer;

    MULCtrlO   :  Array[0..8] of TJDayBkMList;


    Function Current_Page  :  Integer;

    Procedure SetPageHelp(NewIndex  :  Integer);

    Procedure ChangePage(NewPage  :  Integer);

  end;

Var
  SetForApps  :  Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BTSupU2,
  BTSupU3,
  BtKeys1U,
  VarJCstU,
  ComnUnit,
  ComnU2,
  PWarnU,
  CurrncyU,
  SysU1,
  SalTxl1U,

  {$IFDEF GF}
    FindCtlU,
  {$ENDIF}

  {$IFDEF INV}
    Tranl1U,
  {$ENDIF}

  {$IFDEF DBD}
    DebugU,
  {$ENDIF}



  {$IFDEF Frm}
    DefProcU,
  {$ENDIF}

   ConvDocU,

  {$IFDEF C_On}
     NoteSupU,
  {$ENDIF}

  JobSup1U,
  JCRet1U,

    JobMn2U,

  {$IFDEF POST}
    JobPostU,
    JPstInpU,
    {$IFDEF JAP}
      PostingU,
    {$ENDIF}
  {$ENDIF}

  {$IFDEF CU}
    Event1U,
    // MH 01/02/2016 2016-R1 ABSEXCH-16487: For Timesheets check the Transaction Security hook points
    CustInit, CustIntU,
  {$ENDIF}
  TagInpU,
  JobSup2U,
  JobApWzU,
  JobPAppU,
  JAPstIpU,
  ExThrd2U,
  InvListU,

  {$IFDEF JAP}
    SOPCT1U,

  {$ENDIF}

  SysU2;




Const
  PostPage  =  0;
  TSPage    =  1;
  HistPage  =  2;
  PLAppsPage=  3;
  PLAppsHPage= 4;
  SLAppsPage=  5;
  SLAppsHPage= 6;
  PLRetPage =  7;
  SLRetPage =  8;




{$R *.DFM}



{ ============== TJDayBkMList Methods =============== }



{ ======= Extended search routines ========= }





Function TJDayBkMList.SetCheckKey  :  Str255;


Var
  DumStr    :  Str255;

  TmpRunNo,
  TmpFolio  :  LongInt;

Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  Case DisplayMode of
    1  :  With JobDetl^,JobActual do
            DumStr:=PartCCKey(RecPfix,SubType)+RunKey;


    2..7
       :
          With Inv do
          Begin
            If (UseSet4End) and (CalcEndKey) then  {* If A special end key calculation is needed *}
              TmpFolio:=LastAddrD
            else
              TmpFolio:=FolioNum;

            DumStr:=FullDayBkKey(RunNo,TmpFolio,DocCodes[InvDocHed]);
          end;

    8,9 : With JobDetl^,JobReten do
            DumStr:=PartCCKey(RecPfix,SubType)+InvoiceKey;

  end; {Case..}

  SetCheckKey:=DumStr;
end;



Function TJDayBkMList.SetFilter  :  Str255;

Begin

  Case DisplayMode of
     2..7
        :   Result:=Inv.OurRef;
     else   Result:=JobDetl^.RecPFix;
  end; {Case..}

end;




Function TJDayBkMList.Ok2Del :  Boolean;

Begin
  Result:=DisplayMode In [8,9];
end;


Function TJDayBkMList.CheckRowEmph :  Byte;

Var
  InvPosted  :  Boolean;

Begin
  Case DisplayMode of
    1  :  Begin
            Link2Inv(InvPosted);

            Result:=Ord(InvPosted);
          end;

    8,9
       :  Result:=Ord(JobDetl^.JobReten.RetDate<=Today);

    else  Result:=0;

  end; {case...}
end;


Function TJDayBkMList.Link2InvLine :  Boolean;

Const
  Fnum     =  IDetailF;
  Keypath  =  IdLinkK;


Var
  GenStr :  Str255;


Begin
  With JobDetl^.JobActual do
  Begin
    If (Id.FolioRef<>LineFolio)  or (Id.ABSLineNo<>LineNo) then
    Begin
      GenStr:=FullRunNoKey(LineFolio,LineNo);

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,GenStr);
    end;

    Result:=StatusOk;

  end;

end;


Function TJDayBkMList.Link2Inv(Var  InvPosted  :  Boolean)  :  Boolean;

Const
  Fnum2     =  InvF;

  Keypath2  =  InvOurRefK;

Var
  KeyI  :  Str255;


Begin
  InvPosted:=BOn;

  Case DisplayMode of
    1  :
          With JobDetl^.JobActual do
          Begin
            If (Inv.OurRef<>LineORef) then
            Begin
              KeyI:=LineORef;

              Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyI);
            end
            else
              Status:=0;

            InvPosted:=((StatusOk) and (Inv.RunNo<>0) and (Inv.RunNo<>BatchRunNo));

            Result:=StatusOk;
          end;

    else  Result:=BOn;


  end; {case..}

  LinePosted:=InvPosted;
end;


// PKR. 17/11/2015. ABSEXCH-16318. Add Transaction Owner (User Name) column to daybooks.
{ ========== Generic Function to Return Transaction Owner ======= }
function TJDayBkMList.GetTransactionOwner(aLineORef : string) : string;
var
  lStatus : Smallint;
  KeyS : Str255;
  trans : InvRec;
  ExLocal : TdExLocal;
begin
  Result := ''; // Default return value.

  // Lookup the transaction
  ExLocal.Create;
  KeyS := aLineORef;
  lStatus := Find_Rec(B_GetEq, F[InvF], InvF, ExLocal.LRecPtr[InvF]^, InvOurRefK, KeyS);
  if (lStatus = 0) then
  begin
    // Get the User Name (OpName) field
    Result := Exlocal.LInv.OpName;
  end;
end;

{ ========== Generic Function to Return Formatted Display for List ======= }


Function TJDayBkMList.OutJobAct(Col  :  Byte)  :  Str255;


Var
  FoundCode  :  Str20;
  FoundOk,
  InvPosted  :  Boolean;

  Dnum       :  Double;

  GenStr     :  Str255;

Begin
  Link2Inv(InvPosted);

   With JobDetl^.JobActual do
   Begin
     If (JobRec^.JobCode<>JobCode) then
       Global_GetMainRec(JobF,JobCode);

     Case Col of

       0  :  Result:=JobCode;

       2  :  Result:=LineORef;

       6  :  Result:=FormatBFloat(GenQtyMask,Qty,BOff);

       7  :  Begin
               If (Not (JDDT In JAPSplit)) then
                 Dnum:=(Round_Up(Qty*Cost,2)*DocCnst[JDDT])
               else
                 Dnum:=(Round_Up(Cost,2)*DocCnst[JDDT]);

               Result:=FormatCurFloat(GenUnitMask[BOn],Dnum,BOff,ActCurr);
             end;

       8  :  Begin
               If (Not (JDDT In JAPSplit)) then
                 Dnum:=(Round_Up(Qty*UpliftTotal,2)*DocCnst[JDDT])
               else
                 Dnum:=(Round_Up(UpliftTotal,2)*DocCnst[JDDT]);

               Result:=FormatCurFloat(GenUnitMask[BOn],Dnum,BOff,ActCurr);
             end;

       9  :  Begin
               If (JDDT<>TSH) then
               Begin
                 Dnum:=Currency_ConvFT(Charge,CurrCharge,JobRec^.CurrPrice,UseCoDayRate);


                 Result:=FormatCurFloat(GenUnitMask[BOn],Dnum,BOff,JobRec^.CurrPrice);
               end
               else
                 Result:=FormatCurFloat(GenUnitMask[BOn],Charge,BOff,CurrCharge);
             end;

      10  :  Begin

               {$IFDEF XJCZZZ} {* Always use line description *}

                 If (JDDT=TSH) then
                   Result:=Get_StdPRDesc(StockCode,JCtrlF,JCK,-1)
                 else
                 Begin
                   {$IFDEF STK}
                     If (Not EmptyKey(StockCode,StkKeyLen)) then
                     Begin

                       If (Stock.StockCode<>StockCode) then
                         Global_GetMainRec(StockF,StockCode);

                       Result:=Stock.Desc[1];
                     end
                     else
                   {$ENDIF}
                     Begin
                       If (Link2InvLine) then
                         Result:=Id.Desc
                       else
                         Result:='';
                     end;
                 end;

               {$ELSE}
                 If (Link2InvLine) then
                   Result:=Id.Desc
                 else
                   Result:='';
               {$ENDIF}

             end;

      12  :  Result:=YesNoBo(InvPosted);

      13  :  If (HoldFlg<>0) then
               Result:=DisplayHold(HoldFlg)
             else
               Result:='';

      // PKR. 17/11/2015. ABSEXCH-16318. Add Transaction Owner (User Name) column to daybooks.
      14  :  begin
               Result := GetTransactionOwner(LineORef);
             end;

       else
             Result:='';

     end; {Case..}
   end; {With..}
end;


Function TJDayBkMList.OutTSLine(Col  :  Byte)  :  Str255;


Var
  FoundCode  :  Str20;
  FoundOk,
  GenStr     :  Str255;

Begin

   With Inv do
   Begin

     Case Col of

       1  :  Result:=BatchLink;

       2  :  Result:=OurRef;

       3  :  Result:=POutDate(TransDate);

       4  :  Result:=PPR_OutPr(AcPr,AcYr);

       
       10 :  Begin
               Result:=TransDesc;
             end;
       11 :  Result:=Form_Int(DiscDays,0);

       13 :  If (HoldFlg<>0) then
               Result:=DisplayHold(HoldFlg)
             else
               Result:='';

       // PKR. 17/11/2015. ABSEXCH-16318. Add Transaction Owner (User Name) column to daybooks.
       14 :  begin
               // MH 08/03/2018: Changed as it was breaking the List Export - plus its really F'ing stupid code
               //Result := GetTransactionOwner(OurRef);
               Result := OpName;
             end;

       else
             Result:= '';

     end; {Case..}
   end; {With..}
end;

Function TJDayBkMList.OutJALine(Col  :  Byte)  :  Str255;


Var
  FoundCode  :  Str20;
  FoundOk,
  GenStr     :  Str255;

  Dnum       :  Double;

Begin

   With Inv do
   Begin

     Case Col of

       1  :  If (InvDocHed In JAPSalesSplit) then
               Result:=CustCode
             else
               Result:=CISEmpl;

       2  :  Result:=OurRef;

       3  :  Result:=POutDate(TransDate);

       4  :  Result:=PPR_OutPr(AcPr,AcYr);

       7  :  Begin
               If (PDiscTaken) then
                 Dnum:=(Round_Up(InvNetVal,2))
               else
                 Dnum:=(Round_Up(TotalCost,2));

               Result:=FormatCurFloat(GenUnitMask[BOn],Dnum,BOff,Currency);
             end;

       10 :  Begin
               Result:=YourRef;

               If (YourRef<>'') then
                   Result:=Result+' / ';

               Result:=Result+CISEmpl+' : ';

               If (JobRec^.JobCode<>DJobCode) then
                 GetJob(Self.Owner,DJobCode,FoundCode,-1);

               With JobRec^ do
                 Result:=Result+dbFormatName(JobCode,JobDesc);
             end;

       11 :  Begin
               Result:=AppsStatusStr(Inv,BOff,BOff,BOn);
             end;

       13 :  Begin
               Result:=Disp_HoldPStat(HoldFlg,Tagged,PrintedDoc,PDiscTaken,BOff);

             end;

       // PKR. 17/11/2015. ABSEXCH-16318. Add Transaction Owner (User Name) column to daybooks.
       14 :  begin
               Result := GetTransactionOwner(OurRef);
             end;

       else
             Result:='';

     end; {Case..}
   end; {With..}
end;



{ ========== Generic Function to Return Formatted Display for List ======= }


Function TJDayBkMList.OutJobReten(Col  :  Byte)  :  Str255;

Const
  RetStatus :  Array[BOff..BOn] of Str20 = ('O/S','Invoiced');

Var
  Dnum       :  Double;
  GenStr     :  Str255;

Begin

   With JobDetl^.JobReten do
   Begin
     Case Col of

       1  :  Result:=RetCustCode;

       2  :  Result:=RetCrDoc;

       3  :  Result:=POutDate(OrigDate);

       5  :  Result:=POutDate(RetDate);

       7  :  Begin
               Dnum:=RetValue;

               Result:=FormatCurFloat(GenUnitMask[BOn],Dnum,BOff,RetCurr);
             end;


      13  :  Result:=RetStatus[Invoiced];

      // PKR. 17/11/2015. ABSEXCH-16318. Add Transaction Owner (User Name) column to daybooks.
      14  :  begin
               Result := GetTransactionOwner(RetCrDoc);
             end;

       else
             Result:='';

     end; {Case..}
   end; {With..}
end;


Function TJDayBkMList.OutLine(Col  :  Byte)  :  Str255;


Begin
  Case DisplayMode of
    1    :  Result:=OutJobAct(Col);

    2..3
         :  Result:=OutTSLine(Col);
    4..7
         :  Result:=OutJALine(Col);

    8,9  :  Result:=OutJobReten(Col);


  end; {Case..}
end;



{ =================================================================================== }




Function TJobDaybk.Current_Page  :  Integer;


Begin


  Result:=pcLivePage(DPageCtrl1);

end;



procedure TJobDaybk.Find_Page1Coord(PageNo  :  Integer);


Var

  n       :  Integer;

  GlobComp:  TGlobCompRec;


Begin

  If (MULCtrlO[PageNo]<>nil) then
  With MULCtrlO[PageNo] do
  Begin

    New(GlobComp,Create(BOn));

    With GlobComp^ do
    Begin
      GetValues:=BOn;

      PrimeKey:='J';

      HasCoord:=LastCoord;


      Find_ListCoord(GlobComp);

    end; {With GlobComp..}


    Dispose(GlobComp,Destroy);

  end;
end;


procedure TJobDaybk.Store_Page1Coord(UpMode  :  Boolean);


Var
  n       :  Byte;
  GlobComp:  TGlobCompRec;


Begin
  
  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin

    GetValues:=UpMode;

    SaveCoord:=StoreCoord;

    PrimeKey:='J';

    For n:=1 to High(MULCtrlO) do
    If (MULCtrlO[n]<>nil) then
      MULCtrlO[n].Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;


Procedure  TJobDaybk.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TJobDaybk.Find_FormCoord;


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

    PrimeKey:='J';

    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
      StoreCoord:=BOff;
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);

    end;

    GetbtControlCsm(DPageCtrl1);

    GetbtControlCsm(db1SBox);

    GetbtControlCsm(db1BSBox);

    GetbtControlCsm(db1BtnPanel);

    GetbtControlCsm(db1ListBtnPanel);

    GetbtControlCsm(db1HedPanel);

    MULCtrlO[0].Find_ListCoord(GlobComp);

  end; {With GlobComp..}

  With MULCtrlO[0].VisiList do
    LabHedPanel.Color:=IdPanel(0,BOn).Color;

  Dispose(GlobComp,Destroy);

      {* Check form is within current visible range *}

  With TForm(Owner) do
    VisibleRect:=Rect(0,0,ClientWidth,ClientHeight);

  If (Not PtInRect(VisibleRect,Point(Left,Top))) then
  Begin
    Left:=0;
    Top:=0;
  end;

  StartSize.X:=Width; StartSize.Y:=Height;


end;


procedure TJobDaybk.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='J';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(DPageCtrl1);

    StorebtControlCsm(db1SBox);

    StorebtControlCsm(db1BSBox);

    StorebtControlCsm(db1BtnPanel);

    StorebtControlCsm(db1ListBtnPanel);

    StorebtControlCsm(db1HedPanel);

    MULCtrlO[0].Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);

  {Store_Page1Coord(UpMode); Not required, as all are based on first list *}
end;



procedure TJobDaybk.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(DPageCtrl1.Width);
  PagePoint[0].Y:=ClientHeight-(DPageCtrl1.Height);

  PagePoint[1].X:=DPageCtrl1.Width-(db1SBox.Width);
  PagePoint[1].Y:=DPageCtrl1.Height-(db1SBox.Height);

  PagePoint[2].X:=DPageCtrl1.Width-(db1BtnPanel.Left);
  PagePoint[2].Y:=DPageCtrl1.Height-(db1BtnPanel.Height);

  PagePoint[3].X:=db1BtnPanel.Height-(db1BSBox.Height);
  PagePoint[3].Y:=db1SBox.ClientHeight-(db1ORefPanel.Height);

  PagePoint[4].X:=DPageCtrl1.Width-(db1ListBtnPanel.Left);
  PagePoint[4].Y:=DPageCtrl1.Height-(db1ListBtnPanel.Height);

  GotCoord:=BOn;

end;




Function TJobDaybk.ChkPWord(PageNo :  Integer;
                            HelpS,
                            HelpP,
                            HelpN,
                            HelpA,
                            HelpSA,
                            HelpPA  :  LongInt) :  LongInt;


Begin
  Result:=-255;

  Case PageNo of
    PostPage
       :  Result:=HelpS;
    TSPage,HistPage
       :  Result:=HelpP;
    SLRetPage
       :  Result:=HelpN;
    PLRetPage
       :  Result:=HelpA;
    SLAppsPage,SLAppsHPage
       :  Result:=HelpSA;
    PLAppsPage,PLAppsHPage
       :  Result:=HelpPA;

  end;

end;


Function TJobDaybk.SetHelpC(PageNo :  Integer;
                          Pages  :  TIntSet;
                          Help0,
                          Help1,
                          Help2,
                          Help3,
                          Help4,
                          Help5 :  LongInt) :  LongInt;

Begin
  If (PageNo In Pages) then
  Begin
    Case PageNo of
      PostPage
         :  Result:=Help0;
      TSPage,HistPage
         :  Result:=Help1;
      SLRetPage
         :  Result:=Help2;
      PLRetPage
         :  Result:=Help3;
      SLAppsPage,SLAppsHPage
         :  Result:=Help4;
      PLAppsPage,PLAppsHPage
         :  Result:=Help5;
    end; {Case..}
  end
  else
    Result:=-1;


end;


procedure TJobDaybk.PrimeButtons(PageNo  :  Integer;
                               PWRef   :  Boolean);

Var
  LastPage    :  TTabSheet;
  TheCaption  :  ShortString;

{$IFDEF CU}
  // 25/01/2013 PKR ABSEXCH-13449
  cBtnIsEnabled : Boolean;
  TextID        : integer;
{$ENDIF}
  
Begin
  If (CustBtnList=nil) then
  Begin
    CustBtnList:=TVisiBtns.Create;

    try

      With CustBtnList do
      Begin

      {0} AddVisiRec(AddDb1Btn,BOff);
      {1} AddVisiRec(EditDb1Btn,BOff);
      {2} AddVisiRec(FindDb1Btn,BOff);
      {3} AddVisiRec(HoldDb1Btn,BOff);
      {4} AddVisiRec(CopyDb1Btn,BOff);
      {5} AddVisiRec(ConvDb1Btn,BOn);
      {6} AddVisiRec(PostDb1Btn,BOff);
      {7} AddVisiRec(NoteDb1Btn,BOff);
      {8} AddVisiRec(PrintDb1Btn,BOff);
      {9} AddVisiRec(RemDb1Btn,BOn);
     {10} AddVisiRec(ViewDb1Btn,BOff);

     {$IFDEF CU}
        // 25/01/2013 PKR ABSEXCH-13449
        // 6 Custom buttons available.  Use the new custom button handler.
        formPurpose := fpJobDaybook;
        recordState := rsAny;
     
            cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn1.Tag);
      {11}  AddVisiRec(CustdbBtn1, Not cBtnIsEnabled);
      
            cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn2.Tag);
      {12}  AddVisiRec(CustdbBtn2, Not cBtnIsEnabled);

            cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn3.Tag);
      {13}  AddVisiRec(CustdbBtn3, Not cBtnIsEnabled);
      
            cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn4.Tag);
      {14}  AddVisiRec(CustdbBtn4, Not cBtnIsEnabled);
      
            cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn5.Tag);
      {15}  AddVisiRec(CustdbBtn5, Not cBtnIsEnabled);
      
            cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn6.Tag);
      {16}  AddVisiRec(CustdbBtn6, Not cBtnIsEnabled);

(*
      {11}  AddVisiRec(CustdbBtn1, Not EnableCustBtns(5000,120+PageNo));
      {12}  AddVisiRec(CustdbBtn2, Not EnableCustBtns(5000,130+PageNo));
*)      
    {$ELSE}

     {11} AddVisiRec(CustdbBtn1,BOn);
     {12} AddVisiRec(CustdbBtn2,BOn);
          // 17/01/2013 PKR ABSEXCH-13449
          // Custom buttons 3..6 now available
     {13} AddVisiRec(CustdbBtn3,BOn);
     {14} AddVisiRec(CustdbBtn4,BOn);
     {15} AddVisiRec(CustdbBtn5,BOn);
     {16} AddVisiRec(CustdbBtn6,BOn);
    {$ENDIF}
        end; {With..}

    except

      CustBtnList.Free;
      CustBtnList:=nil;
    end; {Try..}

  end; {If needs creating }


  try

    With CustBtnList do
    Begin

      PWSetHideBtn(0,(Not (PageNo In [TSPage,PLAppsPage,SLAppsPage])),BOff,ChkPWord(PageNo,215,-255,-255,-255,444,435));
      SetBtnHelp(0,SetHelpC(PageNo,[TSPage..PLRetPage],0,930,88,128,0,0));

      // MH 02/02/2016 2016-R1 ABSEXCH-16487: Hid rogue Edit button on TSH History tab
      PWSetHideBtn(1,False,BOff,ChkPWord(PageNo,-255,-255,-255,-255,445,436));

      SetBtnHelp(1,SetHelpC(PageNo,[PostPage..PLRetPage],26,930,1120,1120,0,0));

      PWSetHideBtn(2,(Not (PageNo In [PostPage..HistPage,PLAppsPage..SLAppsHPage])),BOff,ChkPWord(PageNo,-255,-255,-255,-255,446,437));
      SetBtnHelp(2,SetHelpC(PageNo,[PostPage..HistPage],27,27,88,128,0,0));

      PWSetHideBtn(3,(Not (PageNo In [PostPage,TSPage,PLAppsPage,SLAppsPage])),BOff,ChkPWord(PageNo,-255,-255,-255,-255,447,438));
      SetBtnHelp(3,SetHelpC(PageNo,[PostPage,TSPage],1013,1013,88,128,0,0));

      PWSetHideBtn(4,(Not (PageNo In [TSPage..HistPage,PLAppsPage..SLAppsHPage])),BOff,ChkPWord(PageNo,-255,-255,-255,-255,451,442));
      SetBtnHelp(4,SetHelpC(PageNo,[TSPage..HistPage],0,28,88,128,0,0));

      SetHideBtn(5,(Not (PageNo In [PLAppsPage,SLAppsPage])),BOff);
      SetBtnHelp(5,SetHelpC(PageNo,[TSPage..HistPage],0,0,0,0,0,0));

      PWSetHideBtn(6,(Not (PageNo In [PostPage,TSPage,PLAppsPage,SLAppsPage])),BOff,ChkPWord(PageNo,216,218,0,0,448,439));

      SetBtnHelp(6,SetHelpC(PageNo,[PostPage,TSPage,PLAppsPage,SLAppsPage],1014,1014,89,0,0,0));

      SetHideBtn(7,(Not (PageNo In [TSPage,HistPage,PLAppsPage..SLAppsHPage])),BOff);

      SetBtnHelp(7,SetHelpC(PageNo,[TSPage,HistPage],30,30,27,0,0,0));

      {SetHideBtn(8,(Not (PageNo In [0,1])),BOff);}

      SetBtnHelp(8,SetHelpC(PageNo,[PostPage..HistPage,PLAppsPage..SLAppsHPage],31,31,1078,1078,0,0));
      PWSetHideBtn(8,BOff,BOff,ChkPWord(PageNo,-255,-255,-255,-255,449,440));

      {$IFDEF CU} {Set customised buttons caption}
        // 25/01/2013  PKR   ABSEXCH-13449/38
        // 6 custom buttons available
        // Use the custom button handler.
        cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn1.Tag);
        SetHideBtn(11, not cBtnIsEnabled, BOff);

        cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn2.Tag);
        SetHideBtn(12, not cBtnIsEnabled, BOff);

        cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn3.Tag);
        SetHideBtn(13, not cBtnIsEnabled, BOff);

        cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn4.Tag);
        SetHideBtn(14, not cBtnIsEnabled, BOff);

        cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn5.Tag);
        SetHideBtn(15, not cBtnIsEnabled, BOff);

        cBtnIsEnabled := custBtnHandler.IsCustomButtonEnabled(FormPurpose, PageNo, recordState, CustDbBtn6.Tag);
        SetHideBtn(16, not cBtnIsEnabled, BOff);
(*
        SetHideBtn(11,Not EnableCustBtns(5000,120+PageNo),BOff);
        SetHideBtn(12,Not EnableCustBtns(5000,130+PageNo),BOff);
*)        
      {$ENDIF}

      SetHideBtn(9,(Not (PageNo In [PLRetPage,SLRetPage])),BOn);
      SetBtnHelp(9,SetHelpC(PageNo,[2..3],156,156,1126,1126,0,0));

      SetBtnHelp(10,SetHelpC(PageNo,[PostPage..PLRetPage],32,32,1079,1079,0,0));


      {$IFDEF CU} {Set customised buttons caption}
        // 25/01/2013  PKR   ABSEXCH-13449/38
        // Use the custom button handler to calculate TextID to make it easier to support.
        If (CustdbBtn1.Visible) then
        Begin
          TheCaption:='';
          TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn1.tag);
          EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn1.Font);
          CustdbBtn1.Caption:=TheCaption;
        end;

        If (CustdbBtn2.Visible) then
        Begin
          TheCaption:='';
          TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn2.tag);
          EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn2.Font);
          CustdbBtn2.Caption:=TheCaption;
        end;

        If (CustdbBtn3.Visible) then
        Begin
          TheCaption:='';
          TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn3.tag);
          EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn3.Font);
          CustdbBtn3.Caption:=TheCaption;
        end;

        If (CustdbBtn4.Visible) then
        Begin
          TheCaption:='';
          TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn4.tag);
          EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn4.Font);
          CustdbBtn4.Caption:=TheCaption;
        end;
        If (CustdbBtn5.Visible) then
        Begin
          TheCaption:='';
          TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn5.tag);
          EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn5.Font);
          CustdbBtn5.Caption:=TheCaption;
        end;

        If (CustdbBtn6.Visible) then
        Begin
          TheCaption:='';
          TextID := custBtnHandler.GetTextID(formPurpose, PageNo, recordState, CustDbBtn6.tag);
          EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, TextID, TheCaption, CustdbBtn6.Font);
          CustdbBtn6.Caption:=TheCaption;
        end;

        
(*
        If (CustdbBtn1.Visible) then
        Begin
          TheCaption:='';
          EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, 10+PageNo, TheCaption, CustdbBtn1.Font);

          {If (TheCaption='') then
            EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, 1+(2*Ord(DocHed In PurchSplit)), TheCaption, CustdbBtn1.Font);}

          CustdbBtn1.Caption:=TheCaption;
        end;

        If (CustdbBtn2.Visible) then
        Begin
          TheCaption:='';
          EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, 20+PageNo, TheCaption, CustdbBtn2.Font);

          {If (TheCaption='') then
            EntCustom1.FCustDLL.GetCustomise(EntCustom1.WindowId, 2+(2*Ord(DocHed In PurchSplit)), TheCaption, CustdbBtn2.Font);}

          CustdbBtn2.Caption:=TheCaption;
        end;
*)        
      {$ENDIF}


    end;

  except
    CustBtnList.Free;
    CustBtnList:=nil;
  end; {try..}

end;


procedure TJobDaybk.BuildMenus;

Begin
  CreateSubMenu(PopUpMenu2,Copy1);
  CreateSubMenu(PopUpMenu3,Hold1);
  {CreateSubMenu(SBSPopUpMenu2,Post1); Dialog used instead}

  
end;



procedure TJobDaybk.SetTabs2;

Begin
  MainPage.TabVisible:=(Not ForApps);

  QuotesPage.TabVisible:=ChkAllowed_In(217) and (Not ForApps);

  TSHistPage.TabVisible:=QuotesPage.TabVisible and (Not ForApps);

  AutoPage.TabVisible:=ChkAllowed_In(220) and (Not ForApps);
  HistoryPage.TabVisible:=ChkAllowed_In(219) and (Not ForApps);

  PLAPage.TabVisible:=(JAPOn) and (ForApps) and ChkAllowed_In(434);
  SLAPage.TabVisible:=(JAPOn) and (ForApps) and ChkAllowed_In(443);
  PLAHPage.TabVisible:=PLAPage.TabVisible;
  SLAHPage.TabVisible:=SLAPage.TabVisible;

  
end;




procedure TJobDaybk.FormCreate(Sender: TObject);
Var
  DKeyLen,
  n  :  Byte;

  StartPanel
     :  TSBSPanel;

  KeyStart,
  KeyEnd,
  KeyPrime
     :  Str255;

begin
  ForApps:=SetForApps;
  SetForApps:=BOff;

  ListActive:=BOff;

  LastCoord:=BOff;

  GotCoord:=BOff;
  NeedCUpdate:=BOff;
  FColorsChanged := False;
  UpdateFromPost:=BOff;
  InHBeen:=BOff;

  fFrmClosing:=BOff;
  fDoingClose:=BOff;

  ExLocal.Create;

  DocHed:=TSH;
  LastDocHed:=DocHed;


  db1SBox.HorzScrollBar.Position:=0;
  db1SBox.VertScrollBar.Position:=0;
  db1BSBox.HorzScrollBar.Position:=0;
  db1BSBox.VertScrollBar.Position:=0;

  DPageCtrl1.ActivePage:=MainPage;

  DispTransPtr[BOff]:=nil;
  DispTransPtr[BOn]:=nil;
  RetRecPtr[BOff]:=nil;
  RetRecPtr[BOn]:=nil;

  MULCtrlO[0]:=TJDayBkMList.Create(Self);


  Try

    With MULCtrlO[0] do
    Begin

      Try

        With VisiList do
        Begin
          AddVisiRec(db1JCPanel,db1JcLab);        // Job Code
          AddVisiRec(db1AccPanel,db1AccLab);      // A/C
          AddVisiRec(db1ORefPanel,db1ORefLab);    // Our Ref
          AddVisiRec(db1DatePanel,db1DateLab);    // Date
          AddVisiRec(db1PrPanel,db1PrLab);        // Period
          AddVisiRec(db1ExpPanel,db1ExpLab);      // Expires
          AddVisiRec(db1QtyPanel,db1QtyLab);      // Hrs/Qty
          AddVisiRec(db1CostPanel,db1CostLab);    // Cost
          AddVisiRec(db1UpliftPanel,db1UpLab);    // Uplift
          AddVisiRec(db1ChrgPanel,db1ChrgLab);    // Charge
          AddVisiRec(db1DescPanel,db1DescLab);    // Description
          AddVisiRec(db1WkPanel,db1WkLab);        // Ref
          AddVisiRec(db1PstdPanel,db1PstdLab);    // Posted
          AddVisiRec(db1StatPanel,db1StatLab);    // Status
          // PKR. 17/11/2015. ABSEXCH-16318. Add Transaction Owner (User Name) column
          AddVisiRec(db1OwnerPanel, db1OwnerLab); // User Name

          // MH 08/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
          ColAppear^[3].ExportMetadata := emtDate;
          ColAppear^[4].ExportMetadata := emtPeriod;
          ColAppear^[5].ExportMetadata := emtDate;
          ColAppear^[6].ExportMetadata := emtQuantity;
          ColAppear^[7].ExportMetadata := emtCurrencyAmount;
          ColAppear^[8].ExportMetadata := emtCurrencyAmount;
          ColAppear^[9].ExportMetadata := emtCurrencyAmount;

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          HidePanels(0);

          LabHedPanel:=db1HedPanel;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;

      {InitSize.Y:=368;
      InitSize.X:=530;

      Self.Height:=InitSize.Y;
      Self.Width:=InitSize.X;}

      InitSize.Y:=341;
      InitSize.X:=615;

      Self.ClientHeight:=InitSize.Y;
      Self.ClientWidth:=InitSize.X;

      MDI_SetFormCoord(TForm(Self));

      Find_FormCoord;

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      // PKR. 17/11/2015. ABSEXCH-16318 Add Transaction Owner (User Name) column.
      MUTotCols:=14;
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

        If (n In [6..9]) then
        Begin
          DispFormat:=SGFloat;
          NoDecPlaces:=2;
        end;

        Case n of
          6   :  NoDecPlaces:=Syss.NoQtyDec;
        end;

      end;



      ListCreate;

      UseSet4End:=BOff;

      NoUpCaseCheck:=BOn;

      DisplayMode:=1;

      Set_Buttons(db1ListBtnPanel);

      {* Include all including batches *}

      If (Not ForApps) then
        Page1Create(Nil,0);

      ListOfSet:=10;



    end {With}


  Except

    MULCtrlO[0].Free;
    MULCtrlO[0]:=Nil;
  end;


  SetPageHelp(0);

  FormSetOfSet;

  FormReSize(Self);

  PrimeButtons(0,BOff);

  BuildMenus;


  If (ForApps) then
  Begin
    
    If (PLAPage.TabVisible) and ChkAllowed_In(434) then
      ChangePage(PLAppsPage)
    else
      ChangePage(SLAppsPage);
  end
  else
    ChangePage(PostPage);

  {$IFDEF CU}
  //PR: 26/02/2013 ABSEXCH-14081 Remove this as it uses incorrect text ids.
(*
  try
    EntCustom1.Execute;
  except
    ShowMessage('Customisation Control Failed to initialise');
  end;
*)
  {$ENDIF}

  SetTabs2;


end;


procedure TJobDaybk.FormActivate(Sender: TObject);
begin

  If (Assigned(FormBitMap)) then
    FormResize(nil);

  If (Assigned(MULCtrlO[0])) then
  Begin
    If (Assigned(MULCtrlO[Current_Page]))  {and (Not ListActive)} then
      MULCtrlO[Current_Page].SetListFocus;
  end;

  ListActive:=BOn;
end;


{* These routines free up resources, by freeing up the handle for DPageCtrl1
   as soon as the focus is lost. To give the illusion of continuity, a bit map is created
   of the image of the form, and this is displayed instead of the form.
   Whilst this is a good idea, no updating can go on of the form whilst it does not have the
   focus.

   Routines used: FormDeactivate, Formpaint, FormActivate, WMSendFocus FormResize Formmouse down
                  Apparently, if the focus is returned from a form which is not an MDI
                  child, OnActivate does not get called, so we rely on the user clicking
                  crude, and gives the impresion that the firat click is ignored.

*}

procedure TJobDaybk.FormDeactivate(Sender: TObject);
begin
  If (Not KeepLive) and (Syss.ConsvMem) then
  Begin
    FormBitMap:=GetFormImage;
    LockWindowUpDate(Handle);
    THintWindow(DPageCtrl1).ReleaseHandle;
    LockWindowUpDate(0);
  end;
end;

procedure TJobDaybk.FormPaint(Sender: TObject);
begin
  If (Assigned(FormBitMap)) then
    Canvas.Draw(0,0,FormBitMap);
end;

procedure TJobDaybk.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If (Assigned(FormBitMap)) then
    FormResize(nil);
end;

procedure TJobDaybk.FormResize(Sender: TObject);

Var
  n           :  Byte;
  ParentForm  :  TCustomForm;


begin
  If (Assigned(FormBitMap)) then
  Begin
    FormBitMap.Free;
    FormBitMap:=nil;

    LockWindowUpdate(Handle);
    DPageCtrl1.HandleNeeded;
    ParentForm:=GetParentForm(DPageCtrl1);
    ParentForm.ActiveControl:=DPageCtrl1;
    With DPageCtrl1 do
    Begin
      BringToFront;
      Visible:=BOff;
      Visible:=BOn;
    end;

    With db1BtnPanel do
    Begin
      BringToFront;
      Visible:=BOff;
      Visible:=BOn;
    end;

    LockWindowUpdate(0);

  end;


  If (GotCoord) and (Not fDoingClose) then
  Begin

    MULCtrlO[Current_Page].LinkOtherDisp:=BOff;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    DPageCtrl1.Width:=ClientWidth-PagePoint[0].X;
    DPageCtrl1.Height:=ClientHeight-PagePoint[0].Y;


    db1SBox.Width:=DPageCtrl1.Width-PagePoint[1].X;
    db1SBox.Height:=DPageCtrl1.Height-PagePoint[1].Y;


    db1BtnPanel.Left:=DPageCtrl1.Width-PagePoint[2].X;
    db1BtnPanel.Height:=DPageCtrl1.Height-PagePoint[2].Y;


    db1BSBox.Height:=db1BtnPanel.Height-PagePoint[3].X;

    db1ListBtnPanel.Left:=DPageCtrl1.Width-PagePoint[4].X;
    db1ListBtnPanel.Height:=DPageCtrl1.Height-PagePoint[4].Y;


    n:=0;
    If (MULCtrlO[n]<>nil) then
    Begin
      With MULCtrlO[n].VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=db1SBox.ClientHeight-PagePoint[3].Y;
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


end;



Procedure TJobDaybk.Send_ParentMsg(Mode   :  Integer);

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


Function TJobDaybk.CheckListFinished  :  Boolean;

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


procedure TJobDaybk.FormClose(Sender: TObject; var Action: TCloseAction);

begin

  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

    Send_ParentMsg(17);


    If (MULCtrlO[0]<>nil) then
    Begin
      FreeAndNil(MULCtrlO[0]); //PL: 05/10/2016 ABSEXCH-17746 Closing Job daybook on red cross is returning and access violation
    end;

  end;

end;

procedure TJobDaybk.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;

    Try

      GenCanClose(Self,Sender,CanClose,BOn);

      If (CanClose) then
        CanClose:=CheckListFinished;

      If (CanClose) then
        CanClose:=GenCheck_InPrint and (Not UpdateFromPost);

      If (CanClose) then
      Begin
        db1SBox.HorzScrollBar.Position:=0;
        db1SBox.VertScrollBar.Position:=0;
        db1BSBox.HorzScrollBar.Position:=0;
        db1BSBox.VertScrollBar.Position:=0;

        If (NeedCUpdate) And (StoreCoord Or FColorsChanged) then
          Store_FormCoord(Not SetDefault);
      end;
    finally
      fFrmClosing:=BOff;
    end; {Try..}
  end
  else
    CanClose:=BOff;

end;

procedure TJobDaybk.FormDestroy(Sender: TObject);

Var
  n  :  Byte;

begin
  ExLocal.Destroy;

  If (CustBtnList<>nil) then
    CustBtnList.Free;

  {If (Assigned(MULCtrlO[0])) then
  Begin
    MULCtrlO[0].Destroy;
    MULCtrlO[0]:=nil;
  end;}
end;


procedure TJobDaybk.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;



{ ======= Link to Trans display ======== }

procedure TJobDaybk.Display_Trans(Mode  :  Byte;
                                  IsApp :  Boolean );

Var
  DispTrans  :  TFInvDisplay;
  InvPosted  :  Boolean;
  KeyI       :  Str255;
  DisplayOptions : TransactionDisplayOptionsSet;
Begin
  {$IFDEF Inv}
    If (DispTransPtr[IsApp]=nil) then
    Begin
      DispTrans:=TFInvDisplay.Create(Self);
      DispTransPtr[IsApp]:=DispTrans;
    end
    else
      DispTrans:=DispTransPtr[IsApp];

      try

        With ExLocal,DispTrans do
        Begin
          If (Current_Page In [PostPage]) and (Mode<>1) then
            With MULCtrlO[Current_Page] do
            Begin
              Link2Inv(InvPosted);

            end;

          If (Mode<>1) then
            LastDocHed:=Inv.InvDocHed
          else
            LastDocHed:=Self.LastDocHed;

          If ((LastFolio<>Inv.FolioNum) or (Mode<>100)) and (InHBeen) then
          begin
            if (Current_Page = HistPage) and (Mode = 2) then
              DisplayOptions := [GDPR_AllowPostedEdit]
            else
              DisplayOptions := [];

            Display_Trans(Mode,Inv.FolioNum,BOn,(Mode<>100), DisplayOptions);
          end;

        end; {with..}

      except

        DispTrans.Free;

      end;
  {$ENDIF}
end;



procedure TJobDaybk.SendObjectCC;

Begin
  SendToObjectCC(Inv.CustCode,0);
end;


Function TJobDaybk.ScanMode(IsApp  :  Boolean)  :  Boolean;

Var
  n  :  Byte;

Begin
  If (Assigned(DispTransPtr[IsApp])) then
  With TFInvDisplay(DispTransPtr[IsApp]) do
  Begin
    For n:=Low(TransActive) to High(TransActive) do
    Begin
      Result:=TransActive[n];

      If (Result) then
        break;
    end;
  end
  else
    Result:=BOff;
end;


Procedure TJobDaybk.WMDayBkGetRec(Var Message  :  TMessage);

Var
  UseFONL, OKShow, WhoCaresAboutThisParam : Boolean;
  ListPoint  :  TPoint;
  TmpInv : InvRec;
Begin
  UseFONL:=BOff;


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of

      0,169
         :  Begin
              If (WParam=169) then
                MULCtrlO[Current_Page].GetSelRec(BOff);

              LastDocHed:=Inv.InvDocHed;


              If (MULCtrlO[Current_Page].ValidLine) then
              Case Current_Page of
                PostPage..SLAppsHPage
                     :  Begin
                          // MH 01/02/2016 2016-R1 ABSEXCH-16487: Check the Transaction Security hook points
                          //                                      for all transaction types
                          {$IFDEF CU}
                          If (Current_Page In [PostPage, TSPage, HistPage]) Then
                          Begin
                            // Save the pre-existing LInv locally as I have no idea what it is being used for
                            TmpInv := ExLocal.LInv;
                            ExLocal.LInv := Inv;
                            // Use the View hook point on the Timesheet History tab as the transactions aren't editable
                            OKShow := ExecuteCustBtn(2000, IfThen(Current_Page=HistPage, 155, 150), ExLocal);  // Transaction Security - View / Edit
                            ExLocal.LInv := TmpInv;
                          End // If (Current_Page In [PostPage, TSPage, HistPage])
                          Else
                          {$ENDIF}
                            OKShow := True;

                          If OKShow Then
                          Begin
                            InHBeen:=BOn;

                            // MH 01/02/2016 2016-R1 ABSEXCH-16487: Go into View mode on TSH History tab instead of Edit
                            Display_Trans(IfThen(Current_Page=HistPage, 0, 2),(Current_Page In [TSPage,HistPage]));
                          End; // If OKShow
                        end;

                PLRetPage,SLRetPage
                     :  Begin
                          GetCursorPos(ListPoint);
                          ScreenToClient(ListPoint);

                          SBSPopupMenu1.PopUp(ListPoint.X,ListPoint.Y);
                        end;
              end;


            end;


      1  :  Begin
              {Link to disp trans for scan...}

              InHBeen:=((InHBeen) and ScanMode((Current_Page In [TSPage,HistPage])));

              // MH 01/02/2016 2016-R1 ABSEXCH-16487: For Timesheets check the Transaction Security hook points
              {$IFDEF CU}
              // Check to see if the hook point is actually enabled - go direct to customisation
              // to avoid the overhead of creating/destroying a customisation object for each row
              // the user scrolls down
              If (Current_Page In [PostPage, TSPage, HistPage]) And CustomisationEnabled Then
              Begin
                // Check whether the Transaction Security - List Scanning hook point is turned on
                If (CustomHandlers.CheckHandlerStatus (102000, 156) = 1) Then
                Begin
                  // For the Job Pre-Postings tab it makes sense to run this against all transaction
                  // types, otherwise it potentially opens up a security loophole

                  // Job Pre-Postings tab runs off Job Actuals, not TH, so need to load Inv from Job Actuals
                  If (Current_Page = PostPage) Then
                    MulCtrlO[Current_Page].Link2Inv(WhoCaresAboutThisParam);

                  // Save the pre-existing LInv locally as I have no idea what it is being used for
                  TmpInv := ExLocal.LInv;
                  ExLocal.LInv := Inv;
                  OKShow := ExecuteCustBtn(2000, 156, ExLocal);  // Transaction Security - List Scanning
                  ExLocal.LInv := TmpInv;
                End // If (CustomHandlers.CheckHandlerStatus (2000, 156) = 1)
                Else
                  OKShow := True;
              End // If (Current_Page In [PostPage, TSPage, HistPage]) And CustomisationEnabled
              Else
              {$ENDIF}
                OKShow := True;

              If OKShow Then
              Begin
                Display_Trans(2+(98*WParam),(Current_Page In [TSPage,HistPage]));

                If (Current_Page=PostPage ) then
                Begin
                  SendObjectCC;
                end;
              End; // If OKShow
            end;


      2  :  ShowRightMeny(LParamLo,LParamHi,1);

            {* This siwtch used here to stop the screen from freeing up memory
            while the please wait message is shown, otherwise the list is not
            updated *}

     20,    {* Do not disable screen whilst please wait message is on *}
     21  :  KeepLive:=(WParam=20);

     25  :  NeedCUpdate:=BOn;


    106..108
         :  With MULCtrlO[0] do
            Begin
              InHBeen:=BOff;
              
              AddNewRow(MUListBoxes[0].Row,(LParam=1));

            end;

    170  :  If (Current_Page<PLRetPage) and (Assigned(MULCtrlO[Current_Page])) then
            Begin
              Printdb1BtnClick(nil);
            end;

    175  :  With DPageCtrl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex);

    177  :  Begin
              PrimeButtons(Current_Page,BOn);

              Check_TabAfterPW(DPageCtrl1,Self,WM_CustGetRec);
            end;

    182  :  With MULCtrlO[Current_Page] do
            Begin
              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;
            end;

    200
         :  Begin
              {* Link to Disp Trans *}

              {* Cancel keep line whilst scanning *}

              DispTransPtr[(Current_Page In [TSPage,HistPage])]:=nil;

              KeepLive:=BOff;

            end;


    {300,
    301  :  With MULCtrlO[WParam-300] do
            Begin
              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;
            end;     }




  {$IFDEF GF}

    3002
          : If (Assigned(FindCust)) then
              With MULCtrlO[LParam],FindCust,ReturnCtrl do
              Begin
                InFindLoop:=BOn;

                // MH 07/07/2009: Re-instated the IF section which EL had removed and added check
                // on tab page because the Else clause that he had left intact didn't work for
                // the Timesheet and Timesheet History tabs which list transactions not Job Actuals.
                If (SearchMode=5) And (Self.Current_Page In [TSPage, HistPage]) then
                Begin
                  UseFONL:=Not FindxOurRef(SearchKey);

                  If (UseFONL) then
                    ShowMessage('Unable to locate '+SearchKey);
                end
                else
                Begin
                  UseFONL:=BOn;

                  If (UseFONL) then
                    Find_OnList(SearchMode+10,SearchKey);
                end;

                With MUListBoxes[0] do
                  If (CanFocus) then
                    SetFocus;

                InFindLoop:=BOff;
              end;

  {$ENDIF}

    end; {Case..}

  end;
  Inherited;
end;


Procedure TJobDaybk.UpdatePostStatus(PageNo  :  Integer);

Begin
  If (Assigned(MULCtrlO[PageNo])) then {* Update list from posting Thread *}
  With MULCtrlO[PageNo] do
  Begin
    PageUpDn(0,BOn);

    If (PageKeys^[0]=0) then
      InitPage;
  end;
end;


Procedure TJobDaybk.WMFormCloseMsg(Var Message  :  TMessage);


Begin

  With Message do
  Begin

    Case WParam of

      {0,1 Reserved for posting notification - not sure why?}


      74  :  Begin {* Update list from posting Thread *}
               UpDatePostStatus(Current_Page);

               UpdateFromPost:=BOff;
               Clsdb1Btn.Enabled:=BOn;
             end;

      84  :  Begin {* Update list from posting Thread *}
               UpdateFromPost:=BOn;
               Clsdb1Btn.Enabled:=BOff;
             end;

      145,
      146:  Begin
              RetRecPtr[WParam=146]:=nil;
            end;

       150,151
         :  Begin
              With MULCtrlO[WParam-143] do
              Begin

               AddNewRow(MUListBoxes[0].Row,(LParam=1));

              end;
            end;

       158,159
          : With MULCtrlO[WParam-151] do
            Begin

              If (MUListBox1.Row<>0) then
                PageUpDn(0,BOn)
              else
                InitPage;

            end;

       188
         :  Begin
              With ExLocal,LInv do
              Begin
                AssignfromGlobal(InvF);

                If (InvDocHed In[JSA,JPA]) then
                Begin
                  InHBeen:=BOn;

                  CalcJAPVATTotals(LInv,ExLocal,BOn,3);
                  Display_Trans(8,BOn);
                end;

              end;

            end;



    end; {Case..}

  end;

  Inherited;
end;


Procedure TJobDaybk.WMSetFocus(Var Message  :  TMessage);
Begin

  FormActivate(nil);

end;


Procedure TJobDaybk.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

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

procedure TJobDaybk.HidePanels(PageNo  :  Byte);

Var
  NomDayBk  :  Boolean;

Begin
  With MULCtrlO[PageNo],VisiList do
  Begin
    SetHidePanel(FindxColOrder(0),(PageNo<>PostPage),BOff);
    SetHidePanel(FindxColOrder(1),(PageNo=PostPage),BOff);
    SetHidePanel(FindxColOrder(3),(PageNo=PostPage),BOff);
    SetHidePanel(FindxColOrder(4),(Not (PageNo In [TSPage,HistPage])),BOff);
    SetHidePanel(FindxColOrder(5),(Not (PageNo In [PLRetPage,SLRetPage])),BOff);
    SetHidePanel(FindxColOrder(6),(PageNo<>PostPage),BOff);
    SetHidePanel(FindxColOrder(7),(PageNo In [TSPage,HistPage]),BOff);

    SetHidePanel(FindxColOrder(8),(PageNo<>PostPage),BOff);

    SetHidePanel(FindxColOrder(9),(PageNo<>PostPage),BOff);
    {SetHidePanel(FindxColOrder(10),(Not (PageNo In [PostPage..HistPage])),BOff);}
    SetHidePanel(FindxColOrder(11),(Not (PageNo In [TSPage,HistPage,PLAppsPage,PLAppsHPage,SLAppsPage,SLAppsHPage])),BOff);
    SetHidePanel(FindxColOrder(12),(PageNo<>PostPage),BOn);

    Case PageNo of
      TSPage,HistPage  :      Begin
                                db1AccLab.Caption:='Emp Code';
                                db1WKLab.Caption:='Ref.';
                              end;
      PLAppsPage,PLAppsHPage,SLAppsPage,SLAppsHPage
                       :      Begin
                                If (Not (PageNo In [SLAppsPage,SLAppsHPage])) then
                                  db1AccLab.Caption:='S/C'
                                else
                                  db1AccLab.Caption:='A/C';

                                db1WKLab.Caption:='Type';
                              end;

      else                    db1AccLab.Caption:='A/C';
    end; {Case..}
  end;
end;


procedure TJobDaybk.Page1Create(Sender   : TObject;
                              NewPage  : Byte);

Var
  n           :  Byte;

  StartPanel  :  TSBSPanel;

  TKeyLen,
  TFnum,
  TKeypath    :  Integer;

  KeyStart,
  KeyPrime,
  KeyEnd      :  Str255;

begin
   Db1SBox.HorzScrollBar.Position:=0;

   If (Not Assigned(MULCtrlO[NewPage])) then
     MULCtrlO[NewPage]:=MULCtrlO[0];

   HidePanels(NewPage);

   KeyPrime:='';

   With MULCtrlO[NewPage] do
   Begin
     HighLiteStyle[1]:=[fsBold];

     RefreshAllCols;

     Case NewPage of

       PostPage
          :  Begin
               KeyStart:=PartCCKey(JBRCode,JBECode)+FullNomKey(0);

               TKeyLen:=Length(KeyStart);

               KeyEnd:=KeyStart;

               OrigKey:=KeyStart;
               OKLen:=TKeyLen;

               TKeyPath:=JdPostedK;
               TFnum:=JDetlF;

               UseSet4End:=BOff;

               NoUpCaseCheck:=BOn;

             end;

       TSPage,HistPage
          :  Begin
               TKeyLen:=5;

               DocHed:=TSH;

               If (NewPage=TSPage) then
               Begin
                 KeyStart:=FullDayBkKey(0,FirstAddrd,DocCodes[DocHed]);

                 KeyEnd:=FullDayBkKey(0,MaxInt,DocCodes[DocHed]);
               end
               else
               Begin
                 KeyStart:=FullDayBkKey(TSTPostRunNo,FirstAddrd,DocCodes[DocHed]);

                 KeyEnd:=FullDayBkKey(TSTPostRunNo,MaxInt,DocCodes[DocHed]);
               end;

               OrigKey:=KeyStart;
               OKLen:=TKeyLen;

               TKeyPath:=InvRNoK;
               TFnum:=InvF;

               UseSet4End:=BOn;

               NoUpCaseCheck:=BOn;

               DayBkListMode:=0;

               DayBkDocHed:=DocHed;

             end;

       PLAppsPage..SLAppsHPage
          :  Begin
               Case NewPage of
                 SLAppsPage,
                 SLAppsHPage  :  DocHed:=JSA;
                 else            DocHed:=JPA; 
               end;

               TKeyLen:=5;

               If (NewPage In [PLAppsPage,SLAppsPage]) then
               Begin
                 KeyStart:=FullDayBkKey(Set_JAPRunNo(DocHed,BOff,BOff),FirstAddrd,DocCodes[DocHed]);

                 KeyEnd:=FullDayBkKey(Set_JAPRunNo(DocHed,BOff,BOff),MaxInt,DocCodes[DocHed]);
               end
               else
               Begin
                 KeyStart:=FullDayBkKey(Set_JAPRunNo(DocHed,BOff,BOn),FirstAddrd,DocCodes[DocHed]);

                 KeyEnd:=FullDayBkKey(Set_JAPRunNo(DocHed,BOff,BOn),MaxInt,DocCodes[DocHed]);
               end;

               OrigKey:=KeyStart;
               OKLen:=TKeyLen;

               TKeyPath:=InvRNoK;
               TFnum:=InvF;

               UseSet4End:=BOn;

               NoUpCaseCheck:=BOn;

               DayBkListMode:=0;

               DayBkDocHed:=DocHed;

             end;


       PLRetPage,SLRetPage
          :  Begin
               KeyStart:=PartCCKey(JBRCode,JBPCode)+TradeCode[(NewPage=SLRetPage)];


               TKeyLen:=Length(KeyStart);

               KeyEnd:=KeyStart;

               OrigKey:=KeyStart;
               OKLen:=TKeyLen;

               TKeyPath:=JdAnalK;
               TFnum:=JDetlF;

               UseSet4End:=BOff;

               NoUpCaseCheck:=BOff;

             end;

     end; {case...}

     DisplayMode:=Succ(NewPage);


     StartList(TFnum,TKeyPath,KeyStart,KeyEnd,KeyPrime,TKeyLen,BOff);

   end; {With..}


   MDI_UpdateParentStat;


end;

procedure TJobDaybk.DPageCtrl1Changing(Sender: TObject;
  var AllowChange: Boolean);

Var
  OldIndex  :  Integer;

begin

  OldIndex:=pcLivePage(DPageCtrl1);

  If (OldIndex<>PostPage) and (MULCtrlO[OldIndex]<>nil) and (Syss.ConsvMem) then
  With MULCtrlO[OldIndex] do
  Begin
    {* Preserve Last position *}

    {* This was disabled as when on formActivate is called, for some reason the
       list being destroyed here is not being recognised as nil, and causes a GPF
       when trying to SetListFocus *}

    {MULAddr[OldIndex]:=PageKeys^[MUListBoxes[0].Row];

    Destroy;

    MULCtrlO[OldIndex]:=nil;}
  end;

  Release_PageHandle(Sender);

end;


Procedure TJobDaybk.SetPageHelp(NewIndex  :  Integer);

Begin
  {With DPageCtrl1 do
    Case NewIndex of
      0  :  ActivePage.HelpContext:=1;
      1  :  ActivePage.HelpContext:=1;
      2  :  ActivePage.HelpContext:=1;
      3  :  ActivePage.HelpContext:=1;
    end; {Case..


    db1BtnPanel.HelpContext:=DPageCtrl1.ActivePage.HelpContext;}
end;

procedure TJobDaybk.DPageCtrl1Change(Sender: TObject);
Var
  NewIndex  :  Integer;
begin

  Begin
    NewIndex:=pcLivePage(DPageCtrl1);


    Case NewIndex of

      PostPage..SLRetPage  :  Page1Create(Sender,NewIndex);

    end; {Case..}

    SetPageHelp(NewIndex);

    {If (NewIndex<>0) then
      DeleteSubMenu(Post1)
    else
      CreateSubMenu(SBSPopUpMenu2,Post1);}

    DeleteSubMenu(View1);
    DeleteSubMenu(Post1);
    DeleteSubMenu(Convert1);

    AggTag1.Visible:=(NewIndex In [PLAppsPage,SLAppsPage]) ;

    If (NewIndex In [PLRetPage,SLRetPage]) then
      CreateSubMenu(SBSPopUpMenu1,View1);

    If (NewIndex In [PLAppsPage,SLAppsPage]) then
    Begin
      CreateSubMenu(SBSPopUpMenu4,Post1);
      CreateSubMenu(PopUpMenu7,Convert1);
    end;

    Db1SBox.Parent:=DPageCtrl1.ActivePage;
    Db1ListBtnPanel.Parent:=DPageCtrl1.ActivePage;


    If (MULCtrlO[NewIndex]<>nil) and (ListActive) then
    With MULCtrlO[NewIndex] do
    Begin
      {If (Not (NewIndex In [3,5])) then}
      Begin
        If (MUListBox1.Row<>0) then
          PageUpDn(0,BOn)
        else
          InitPage;
      end;

      SetListFocus;
    end;

    PrimeButtons(NewIndex,BOff);

  end;

end;




Procedure TJobDaybk.ChangePage(NewPage  :  Integer);


Begin

  If (Current_Page<>NewPage) then
  With DPageCtrl1 do
  Begin
    Case NewPage of

      PostPage
         :  ActivePage:=MainPage;
      TSPage
         :  ActivePage:=QuotesPage;
      HistPage
         :  ActivePage:=TSHistPage;

      PLAppsPage
         :  ActivePage:=PLAPage;
      SLAppsPage
         :  ActivePage:=SLAPage;
      PLAppsHPage
         :  ActivePage:=PLAHPage;
      SLAppsHPage
         :  ActivePage:=SLAHPage;

      PLRetPage
         :  ActivePage:=AutoPage;
      SLRetPage
         :  ActivePage:=HistoryPage;

    end; {Case..}

    DPageCtrl1Change(ActivePage);


  end; {With..}
end; {Proc..}

procedure TJobDaybk.Clsdb1BtnClick(Sender: TObject);
begin
  If (Not MULCtrlO[Current_Page].InListFind) then
    Close;
end;

procedure TJobDaybk.db1OrefPanelMouseUp(Sender: TObject;
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

    BarPos:=db1SBox.HorzScrollBar.Position;

      If (PanRsized) then
        MULCtrlO[Current_Page].ResizeAllCols(MULCtrlO[Current_Page].VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO[Current_Page].FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO[Current_Page].VisiList.MovingLab or PanRSized);
  end;

end;

procedure TJobDaybk.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin
    LastDocHed:=Inv.InvDocHed;

    PopUp(X,Y);

  end;


end;


procedure TJobDaybk.SetFormProperties;


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
        // MH 07/11/2012 v7.0 ABSEXCH-13676: List Headings options being shown when not applicable
        SupportListHeadingBackground := False;

        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,Self.Caption+' Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);
        FColorsChanged := NeedCUpdate;

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

procedure TJobDaybk.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TJobDaybk.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;


procedure TJobDaybk.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

  {$IFDEF CU}
  Custom1.Caption := CustdbBtn1.Caption;
  Custom2.Caption := CustdbBtn2.Caption;
  // 17/01/2013 PKR ABSEXCH-13449
  // Custom buttons 3..6 now available
  Custom3.Caption := CustdbBtn3.Caption;
  Custom4.Caption := CustdbBtn4.Caption;
  Custom5.Caption := CustdbBtn5.Caption;
  Custom6.Caption := CustdbBtn6.Caption;
  {$ENDIF}

  With CustBtnList do
  Begin
    ResetMenuStat(PopUpMenu1,BOn,BOn);

    With PopUpMenu1 do
    For n:=0 to Pred(Count) do
      SetMenuFBtn(Items[n],n);

  end; {With..}

end;




procedure TJobDaybk.db1ORefLabMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      If (MULCtrlO[Current_Page]<>nil) then
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

procedure TJobDaybk.db1ORefLabMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO[Current_Page]<>nil) then
      MULCtrlO[Current_Page].VisiList.MoveLabel(X,Y);

    NeedCUpdate:=MULCtrlO[Current_Page].VisiList.MovingLab;
  end;

end;

{$IFDEF DBD}

Procedure TJobDaybk.DebugProc;

Begin


end;


{$ENDIF}


procedure TJobDaybk.AddDocCtrl(Sender: TObject);

Var
  Mode  :  Byte;
  OkShow:  Boolean;
  TmpInv : InvRec;
begin
  Mode:=0;

  OkShow:=BOn;

  If ((Sender Is TButton) or (Sender Is TMenuItem)) and (Not MULCtrlO[Current_Page].InListFind)
     and ((MULCtrlO[Current_Page].ValidLine) or (Sender=Adddb1Btn) or (Sender=Add1)) then
  Begin
    With MULCtrlO[Current_Page] do
      RefreshLine(MUListBoxes[0].Row,BOff);

    If (Sender=Adddb1Btn) or (Sender=Editdb1Btn) or (Sender=Edit1) or (Sender=Add1) then
      Mode:=1+Ord(Sender=Editdb1Btn)+Ord(Sender=Edit1);

    Case Mode of

     {$IFNDEF INV}
       1  :
     {$ELSE}
       1  :  LastDocHed:=DocHed;
     {$ENDIF}

      2  :  Begin
              LastDocHed:=Inv.InvDocHed;
              OKShow:=MULCtrlO[Current_Page].ValidLine;

              // MH 01/02/2016 2016-R1 ABSEXCH-16487: For Timesheets check the Transaction Security hook points
              {$IFDEF CU}
              If OKShow And (Inv.InvDocHed = TSH) And (Current_Page In [TSPage, HistPage]) Then
              Begin
                // Save the pre-existing LInv locally as I have no idea what it is being used for
                TmpInv := ExLocal.LInv;
                ExLocal.LInv := Inv;
                OKShow := ExecuteCustBtn(2000, 150, ExLocal);  // Transaction Security - Edit
                ExLocal.LInv := TmpInv;
              End; // If OKShow And (Inv.InvDocHed = TSH) And (Current_Page = TSPage)
              {$ENDIF}
            end;
    end; {Case..}

    InHBeen:=OkShow;

    If (OkShow) then
    Begin
      If (DocHed In [JSA,JPA]) and (Mode=1) then
      Begin
        Set_JPAJCT(Inv,Id,DocHed,'','',0,0);

        with TJobAppWizard.Create(Self) do
          Show;

      end
      else
        Display_Trans(Mode,(Current_Page In [TSPage,HistPage]));

    end;
  end;

end;



{ ======= Retention based control ======= }

procedure TJobDaybk.Display_RetRec(Mode     :  Byte;
                                   IsSales  :  Boolean);

Var
  WasNew  :  Boolean;
  TRetRec :  TJCRetFrm;


  Begin
    WasNew:=BOff;

    With ExLocal do
    Begin
      Set_JRFormMode(IsSales);
    end;


    If (RetRecPtr[IsSales]=nil) then
    Begin
      TRetRec:=TJCRetFrm.Create(Self);

      WasNew:=BOn;

      RetRecPtr[IsSales]:=TRetRec;
    end
    else
      TRetRec:=RetRecPtr[IsSales];

    Try


     With TRetRec do
     Begin
       If (Mode=1) then
         ResetRec(JDetlF);
         
       ExLocal.AssignFromGlobal(JDetlF);

       WindowState:=wsNormal;


       If (Mode In [1..3]) then
       Begin

         Case Mode of

           1..2  :   If (Not ExLocal.InAddEdit) then
                       EditLine((Mode=2))
                     else
                       Show;
              3  :  If (Not ExLocal.InAddEdit) then
                       DeleteBOMLine(JDetlF,JDLedgerK);
                     else
                       Show;

         end; {Case..}

       end;



     end; {With..}


    except

     TRetRec.Free;
     RetRecPtr[IsSales]:=nil;

    end;

  end;


procedure TJobDaybk.EditRetRec(Sender  : TObject;
                               IsSales : Boolean);

Var
  EMode  :  Byte;

Begin
  EMode:=1*Ord((Sender = Adddb1Btn) or (Sender = Add1)) +
         2*Ord((Sender = Editdb1Btn) or (Sender = Edit1))+
         3*Ord((Sender = Remdb1Btn) or (Sender = Remove1));

  {$B-}
  If (EMode=1) or (MULCtrlO[PLRetPage+Ord(IsSales)].ValidLine) then
  {$B+}
    Display_RetRec(EMode, IsSales);
end;


procedure TJobDaybk.EditCharge(ORMode   :  Byte);

Begin
  If (Assigned(MULCtrlO[0])) then
    If (MULCtrlO[0].ValidLine) then
    With MULCtrlO[0] do
    Begin

      EditActCharge(Self,db1JCPanel.Color,db1JCPanel.Font,ORMode,ExLocal,ScanFileNum,KeyPath,JobDetl^.JobActual.CurrCharge);

      RefreshLine(MUListBoxes[0].Row,BOn);

    end;

end;

procedure TJobDaybk.EdtChmiClick(Sender: TObject);
begin
  If (Sender is TMenuItem) then
  With TMenuItem(Sender) do
    EditCharge(Tag);
end;


procedure TJobDaybk.Adddb1BtnClick(Sender: TObject);

Var
  ListPoint   :  TPoint;

begin
  Case Current_Page of
    PostPage
         :   Begin
               {$B-}
               If (Assigned(MULCtrlO[0])) and (MULCtrlO[0].ValidLine) and (Not MULCtrlO[0].LinePosted) then
               {$B+}
               Begin
                 GetCursorPos(ListPoint);
                 ScreenToClient(ListPoint);

                 SBSPopupMenu3.PopUp(ListPoint.X,ListPoint.Y);
               end
               else
                 EditCharge(0);
             end;

    PLRetPage,SLRetPage
         :   EditRetRec(Sender,Current_Page=SLRetPage);

    else     AddDocCtrl(Sender);

  end; {Case..}

end;




procedure TJobDaybk.CopyDb1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

begin
  With MULCtrlO[Current_Page] do
  Begin
    If (ValidLine) and (Not InListFind) then
    Begin
      RefreshLine(MUListBoxes[0].Row,BOff);
      LastDocHed:=Inv.InvDocHed;


       With TWinControl(Sender) do
       Begin
         ListPoint.X:=1;
         ListPoint.Y:=1;

         ListPoint:=ClientToScreen(ListPoint);

       end;



       PopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);
    end;
  end;{with..}
end;


procedure TJobDaybk.Copy2Click(Sender: TObject);

Var
  Ok2Cont  :  Boolean;
  SCode    :  String;
  TmpInv   : InvRec;
begin
  SCode:='';

  If (Sender Is TMenuItem) then
    With TMenuItem(Sender) do
    Begin
      // Note: Tag = 1 = Copy, Tag = 2 = Reverse

      // MH 01/02/2016 2016-R1 ABSEXCH-16487: For Timesheets check the Transaction Security hook points
      {$IFDEF CU}
      If (Inv.InvDocHed = TSH) And (Current_Page In [TSPage, HistPage]) Then
      Begin
        // Save the pre-existing LInv locally as I have no idea what it is being used for
        TmpInv := ExLocal.LInv;
        ExLocal.LInv := Inv;
        Ok2Cont := ExecuteCustBtn(2000, IfThen (Tag=1, 160, 162), ExLocal);  // Transaction Security - Copy / Copy-Reverse
        ExLocal.LInv := TmpInv;
      End // If (Inv.InvDocHed = TSH) And (Current_Page In [TSPage, HistPage])
      Else
      {$ENDIF}
        Ok2Cont := True;

      If (Ok2Cont) then
      Begin
        ContraCopy_Doc(Inv.FolioNum,Tag,SCode);

        LastDocHed:=Inv.InvDocHed;

        If (Assigned(MULCtrlO[Current_Page])) then
          MULCtrlO[Current_Page].PageUpDn(0,BOn);
      end;
    end;
end;




procedure TJobDaybk.Holddb1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

begin
  With MULCtrlO[Current_Page] do
  Begin
    If (ValidLine) and (Not InListFind) then
    Begin
      RefreshLine(MUListBoxes[0].Row,BOff);
      LastDocHed:=Inv.InvDocHed;


       With TWinControl(Sender) do
       Begin
         ListPoint.X:=1;
         ListPoint.Y:=1;

         ListPoint:=ClientToScreen(ListPoint);

       end;



       PopUpMenu3.PopUp(ListPoint.X,ListPoint.Y);
    end;
  end;{with..}
end;


procedure TJobDaybk.HQ1Click(Sender: TObject);

Var
  KeyS  :  Str255;

  HoldMode
        :  Byte;
  bCont : Boolean;
  TmpInv : InvRec;
begin
  With MULCtrlO[Current_Page],ExLocal do
  Begin
    If (ValidLine) and (Sender is TMenuItem) then
    Begin
      // MH 02/02/2016 2016-R1 ABSEXCH-16488: Add new transaction security hook points on Hold for Query / Cancel Hold
      {$IFDEF CU}
      If (Current_Page = TSPage) And (TMenuItem(Sender).Tag In [1 {Hold for Query}, 5 {Cancel Hold}]) Then
      Begin
        // Save the pre-existing LInv locally as I have no idea what it is being used for
        TmpInv := ExLocal.LInv;
        ExLocal.LInv := Inv;
        bCont := ExecuteCustBtn(2000, IfThen(TMenuItem(Sender).Tag = 1, 164, 165), ExLocal);  // Transaction Security - Hold for Query / Cancel Hold
        ExLocal.LInv := TmpInv;
      End // If (Current_Page = TSPage) And (TMenuItem(Sender).Tag In [1 {Hold for Query}, 5 {Cancel Hold}]) 
      Else
      {$ENDIF}
        bCont := True;

      If bCont Then
      Begin
        RefreshLine(MUListBoxes[0].Row,BOff);

        AssignFromGLobal(ScanFileNum);

        LGetRecAddr(ScanFileNum);

        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,ScanFilenum,BOff,GlobLocked);

        If (Ok) and (GlobLocked) then
        Begin

          With TMenuItem(Sender) do
            Case Tag of
              // 1 = Hold for Query
              0..3  :  HoldMode:=Tag+200;

              // 5 = Cancel Hold
              5     :  HoldMode:=HoldDel;

              4,6   :  HoldMode:=Tag+217;

              7,8   :  HoldMode:=Tag+197;

              10    :  HoldMode:=HoldSC;

              else     HoldMode:=Tag+200;

            end; {Case..}

          AssignToGLobal(ScanFileNum);

          Case Current_Page of
            PostPage  :  SetJobHold(HoldMode,ScanFileNum,Keypath,BOn,JobDetl^);
            TSPage,
            PLAppsPage,
            SLAppsPage
                      :  SetHold(HoldMode,ScanFileNum,Keypath,BOn,Inv);
          end; {Case..}


          UnLockMLock(ScanFileNum,LastRecAddr[ScanFileNum]);

          Set_Row(MUListBoxes[0].Row);
        end;
      End; // If bCont
    End; // If (ValidLine) and (Sender is TMenuItem)
  end;{with..}
end;


procedure TJobDaybk.PrintRetCr;
var
  //PR: 20/05/2014 ABSEXCH-2763
  Ok2Print : Boolean;
Begin
  Ok2Print := True;
  With ExLocal,JobDetl^.JobReten do
  Begin
    If LGetMainRecPosKey(InvF,InvOurRefK,RetCRDoc) then
    Begin
    {$IFDEF CU}
      If (EnableCustBtns(2000,151)) then
        Ok2Print := ExecuteCustBtn(2000,151,ExLocal);
    {$ENDIF}
      {$IFDEF FRM}
      if Ok2Print then
        With LInv do
          Control_DefProcess(DEFDEFMode[InvDocHed],
                             IdetailF,IdFolioK,
                             FullNomKey(FolioNum),ExLocal,BOn);
      {$ENDIF}
    end;
  end;
end;




procedure TJobDaybk.PrintDoc(Sender: TObject);
var
  //PR: 20/05/2014 ABSEXCH-2763
  Ok2Print : Boolean;
{$IFDEF Frm}
  begin
    Ok2Print := True;
    Case Current_Page of
      PLRetPage,SLRetPage
           :  PrintRetCr;

      else    With MulCtrlO[Current_Page],ExLocal Do
              Begin
                GetSelRec(BOff);
                AssignFromGlobal(InvF);

               //PR: 20/05/2014 ABSEXCH-2763
              {$IFDEF CU}
                If (EnableCustBtns(2000,151)) then
                  Ok2Print := ExecuteCustBtn(2000,151,ExLocal);
              {$ENDIF}
                if Ok2Print then
                  With LInv do
                    Control_DefProcess(DEFDEFMode[InvDocHed],
                                      IdetailF,IdFolioK,
                                      FullNomKey(FolioNum),ExLocal,BOn);

              End; { With }
    end; {Case..}
{$ELSE}
  Begin
{$ENDIF}
end;


procedure TJobDaybk.Printdb1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

Begin
  PrintDoc(Sender);
end;

procedure TJobDaybk.PrintDoc1Click(Sender: TObject);
begin
  PrintDoc(Sender);
end;



procedure TJobDaybk.DeleteDoc;


Var
  MbRet  :  Word;
  KeyS   :  Str255;

  Keypath:  Integer;

  LAddr  :  LongInt;


Begin
  With MULCtrlO[Current_Page] do
  Begin
    If (ValidLine) and (Not InListFind) then
    Begin

      MbRet:=MessageDlg('Please confirm you wish'#13+'to delete this Transaction',
                         mtConfirmation,[mbYes,mbNo],0);


      If (MbRet=MrYes) then
      With ExLocal do
      Begin
        GetSelRec(BOff);

        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,Keypath,ScanFileNum,BOff,GlobLocked,LAddr);

        If (Ok) and (GlobLocked) then
        Begin
          Status:=Delete_Rec(F[ScanFileNum],ScanFileNum,Keypath);

          Report_BError(ScanFileNum,Status);

          If (StatusOk) then {* Delete any dependant links etc *}
          Begin

            PageUpDn(0,BOn);

            If (PageKeys^[0]=0) then {* Update screen as we have lost them all!*}
              InitPage

          end;
        end;
      end;
    end; {If confirm delete..}
  end; {If ok..}
end; {PRoc..}




procedure TJobDaybk.Remdb1BtnClick(Sender: TObject);
begin
    Case Current_Page of
      PLRetPage,SLRetPage
           :   EditRetRec(Sender,Current_Page=3);

      else     DeleteDoc;
    end;
end;



{$IFDEF GF}

  procedure TJobDaybk.FindDbItem(Sender: TObject);

  Var
    ReturnCtrl  :  TReturnCtrlRec;

  begin

    If (Not MULCtrlO[Current_Page].InListFind)  then
    Begin

      With ReturnCtrl,MessageReturn do
      Begin
        FillChar(ReturnCtrl,Sizeof(ReturnCtrl),0);

        WParam:=3000;
        LParam:=Current_Page;
        Msg:=WM_CustGetRec;
        DisplayxParent:=BOn;
        ShowOnly:=BOn;
        Pass2Parent:=BOn;

        //PR: 04/12/2013 ABSEXCH-14824
        Ctrl_GlobalFind(Self, ReturnCtrl, tabFindDocument);

      end;
    end; {If in list find..}

  end;

{$ENDIF}

procedure TJobDaybk.Finddb1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;

begin
  {$IFDEF GF}
    FinddbItem(Sender);
  {$ENDIF}

end;



procedure TJobDaybk.Viewdb1BtnClick(Sender: TObject);

Var
  ListPoint  :  TPoint;
  TmpInv : InvRec;
  OK2Cont : Boolean;
begin
  Case Current_Page of
    PostPage..SLAppsHPage
         :  With MULCtrlO[Current_Page] do
            If (ValidLine) then
            Begin
              RefreshLine(MUListBoxes[0].Row,BOff);

              // MH 01/02/2016 2016-R1 ABSEXCH-16487: Check the Transaction Security hook points for
              // all transaction types
              {$IFDEF CU}
              If (Current_Page In [PostPage, TSPage, HistPage]) Then
              Begin
                // Save the pre-existing LInv locally as I have no idea what it is being used for
                TmpInv := ExLocal.LInv;
                ExLocal.LInv := Inv;
                Ok2Cont := ExecuteCustBtn(2000, 155, ExLocal);  // Transaction Security - View
                ExLocal.LInv := TmpInv;
              End // If (Inv.InvDocHed = TSH) And (Current_Page In [TSPage, HistPage])
              Else
              {$ENDIF}
                Ok2Cont := True;

              If OK2Cont Then
              Begin
                InHBeen:=BOn;
                Display_Trans(0,(Current_Page In [TSPage,HistPage]));
              End; // If OK2Cont
            end;

    PLRetPage,SLRetPage
          :  If (Sender<>View1) then
             Begin
               GetCursorPos(ListPoint);
               ScreenToClient(ListPoint);

               SBSPopupMenu1.PopUp(ListPoint.X,ListPoint.Y);
             end;
  end; {Case..}
end;

procedure TJobDaybk.ViewR1Click(Sender: TObject);

Var
  KeyI  :  Str255;

begin
  With MULCtrlO[Current_Page] do
  If (ValidLine) then
  With JobDetl^.JobReten do
  Begin

    If (TMenuItem(Sender).Tag=1) then
      KeyI:=RetDoc
    else
      KeyI:=RetCrDoc;

    InHBeen:=CheckRecExsists(KeyI,InvF,InvOurRefK);

    Display_Trans(2,(Current_Page In [TSPage,HistPage]));

  end;
end;


procedure TJobDaybk.Notedb1BtnClick(Sender: TObject);

Var
  LMode :  Byte;
  TmpInv : InvRec;
  OK2Cont : Boolean;
begin
  If (Sender Is TButton) or (Sender Is TMenuItem) and (Not MULCtrlO[Current_Page].InListFind) then
  Begin
    With MULCtrlO[Current_Page] do
      RefreshLine(MUListBoxes[0].Row,BOff);

    // MH 01/02/2016 2016-R1 ABSEXCH-16487: For Timesheets check the Transaction Security hook points
    {$IFDEF CU}
    If (Inv.InvDocHed = TSH) And (Current_Page In [TSPage, HistPage]) Then
    Begin
      // Save the pre-existing LInv locally as I have no idea what it is being used for
      TmpInv := ExLocal.LInv;
      ExLocal.LInv := Inv;
      Ok2Cont := ExecuteCustBtn(2000, 161, ExLocal);  // Transaction Security - Notes
      ExLocal.LInv := TmpInv;
    End // If (Inv.InvDocHed = TSH) And (Current_Page In [TSPage, HistPage])
    Else
    {$ENDIF}
      Ok2Cont := True;

    If OK2Cont Then
    Begin
      LastDocHed:=Inv.InvDocHed;

      LMode:=7;

      InHBeen:=BOn;

      Display_Trans(LMode,(Current_Page In [TSPage,HistPage]));
    End; // If OK2Cont
  end;

end;


procedure TJobDaybk.Postdb1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;


begin

  With MULCtrlO[Current_Page] do
  Case DisplayMode of
    1  :
         Begin
           {If (Not InListFind) and (Sender<>Post1) then
           Begin

              With TWinControl(Sender) do
              Begin
                ListPoint.X:=1;
                ListPoint.Y:=1;

                ListPoint:=ClientToScreen(ListPoint);

              end;



              SBSPopUpMenu2.PopUp(ListPoint.X,ListPoint.Y);
           end;}

           {$IFDEF POST}
             JPrePostInput(Self,0);

           {$ENDIF}

         end;{with..}

    2 :  Begin
           {$IFDEF POST}

             AddJobPost2Thread(Self,2,'',Nil,Self.Handle);

           {$ENDIF}

         end;
    4,6
      :  Begin
           If (Not InListFind) and (Sender<>Post1) then
           Begin

              With TWinControl(Sender) do
              Begin
                ListPoint.X:=1;
                ListPoint.Y:=1;

                ListPoint:=ClientToScreen(ListPoint);

              end;



              SBSPopUpMenu4.PopUp(ListPoint.X,ListPoint.Y);
           end;
         end;
  end; {Case..}
end;



procedure TJobDaybk.PostJD1Click(Sender: TObject);

Var
  PMode  :  Byte;
begin
  PMode:=1+(2*Ord(TMenuItem(Sender).Tag=1));

  {$IFDEF POST}
    AddJobPost2Thread(Self,PMode,'',Nil,Self.Handle);

  {$ENDIF}
end;


procedure TJobDaybk.MenuItem1Click(Sender: TObject);


begin
  Case TMenuItem(Sender).Tag of
    1  :  {$IFDEF POST}
            With MULCtrlO[Current_Page] do
               If (ValidLine) then
                  Post_SingleApp(Inv,DocHed,Self);
          {$ELSE}
            ;
          {$ENDIF}
    2,3
       :  Begin
            {* Input For run *}

            {$IFDEF POST}

               JAPPrePostInput(Self,DocHed,(TMenuItem(Sender).Tag=3));
            {$ENDIF}

          end;


  end; {Case..}
end;

procedure TJobDaybk.Convdb1BtnClick(Sender: TObject);
Var
  ListPoint  :  TPoint;
  Ok2Exe     :  Boolean;


begin
  Ok2Exe:=BOn;


  With MULCtrlO[Current_Page] do
  Begin
    If (ValidLine) and (Not InListFind) then
    Begin
      RefreshLine(MUListBoxes[0].Row,BOff);
      LastDocHed:=Inv.InvDocHed;

      {$IFDEF CU}
        ExLocal.AssignFromGlobal(InvF);
        Ok2Exe:=ExecuteCustBtn(2000,154,ExLocal);
      {$ENDIF}


       With TWinControl(Sender) do
       Begin
         ListPoint.X:=1;
         ListPoint.Y:=1;

         ListPoint:=ClientToScreen(ListPoint);

       end;


       If (Ok2Exe) then
       Begin
         If (PChkAllowed_In(ChkPWord(Current_Page,00,00,00,00,-255,-255))) then
           PopUpMenu7.PopUp(ListPoint.X,ListPoint.Y)
         else
           TagTrans(Sender);
       end;
    end;
  end;{with..}
end;

procedure TJobDaybk.Tag2Click(Sender: TObject);
begin
  TagTrans(Sender);
end;

procedure TJobDaybk.Untag1Click(Sender: TObject);
Var
  TagNo  :  Byte;
begin
  TagNo:=0;
  {$IFDEF JAP}
    {$IFDEF POST}
       With MULCtrlO[Current_Page] do
         If GetTagNo(TagNo,1) then
           AddUnTagSOP2Thread(Self,KeyRef,KeyLen,ScanFileNum,Keypath,TagNo);
    {$ENDIF}
  {$ENDIF}  
end;


Function TJobDaybk.GetTagNo(Var TNo  :  Byte;
                              Mode :  Byte)  :  Boolean;

Var
  ISCtrl         :  TSetTagNo;
  mrResult       :  TModalResult;

Begin
  Result:=BOff;

  ISCtrl:=TSetTagNo.Create(Self);

  try

    With ISCtrl do
    Begin
      PAValue:=TNo;

      mrResult:=InitIS(TNo,Mode);

      If (mrResult=mrOk) then
      Begin
        TNo:=PAValue;

        Result:=BOn;
      end;
    end;

  finally

    ISCtrl.Free;

  end; {Try..}


end;


  procedure TJobDaybk.TagTrans(Sender: TObject);

  Var
    KeyS   :  Str255;
    LOk,
    LLocked:  Boolean;

    TagNo  :  Byte;

  begin

      With MULCtrlO[Current_Page],ExLocal do
      Begin
        TagNo:=LInv.Tagged;

        If (TagNo=0) then
          TagNo:=1
        else
          TagNo:=0;

        {$IFDEF JAP}

          {$B-}
          If (ValidLine) and (Not InListFind) and (GetTagNo(TagNo,0)) then

          {$B+}
          Begin
            RefreshLine(MUListBoxes[0].Row,BOff);

            AssignFromGLobal(ScanFileNum);

            LGetRecAddr(ScanFileNum);

            LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,ScanFilenum,BOff,LLocked);

            If (LOk) and (LLocked) then
            Begin
              Set_OrderTag(ScanFileNum,Keypath,LastRecAddr[ScanFileNum],TagNo);

              Set_Row(MUListBoxes[0].Row);
            end;
          end; {If ok..}

        {$ENDIF}

      end;{with..}
  end;

procedure TJobDaybk.CustdbBtn1Click(Sender: TObject);

Var
  PageNo  :  Integer;
  KeyI    :  Str255;
  // 23/01/2013 PKR ABSEXCH-13449
  eventID : Integer;
  customButtonNumber : integer;

begin
  PageNo:=Current_Page;

  {$IFDEF CU}
    If (Assigned(MULCtrlO[PageNo])) then
    With MULCtrlO[PageNo],ExLocal do
    Begin
      If (ValidLine) then
      Begin
        If (PageNo In [0..3]) then
        With JobDetl^.JobActual do
        Begin
          KeyI:=LineORef;
          Status:=Find_Rec(B_GetEq,F[InvF],InvF,LRecPtr[InvF]^,InvOurRefK,KeyI);

          If (Not StatusOk) then
            AssignFromGlobal(InvF);
        end
        else
          LInv:=Inv;

        AssignFromGlobal(ScanFileNum);
        
        If (LCust.CustCode<>Inv.CustCode) then
          LGetMainRecPos(CustF,Inv.CustCode);

        // 23/01/2013 PKR ABSEXCH-13449
        // The button or menu item Tag property is set to the button number.
        customButtonNumber := -1;
        if Sender is TSBSButton then
          customButtonNumber := (Sender as TSBSButton).Tag;
        if Sender is TMenuItem then
          customButtonNumber := (Sender as TMenuItem).Tag;

        custBtnHandler.CustomButtonClick(fpJobDaybook,
                                         PageNo,
                                         rsAny,
                                         customButtonNumber,
                                         ExLocal);
//        ExecuteCustBtn(5000,((120+PageNo)*Ord((Sender=CustdbBtn1) or (Sender=Custom1)))+
//                      ((130+PageNo)*Ord((Sender=CustdbBtn2) or (Sender=Custom2))), ExLocal);

      end;
    end; {With..}
  {$ENDIF}
end;

//-------------------------------------------------------------------------

// MH 08/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
function TJobDaybk.WindowExportEnableExport: Boolean;
begin
  Result := (Current_Page In [PostPage, TSPage, HistPage, PLRetPage, SLRetPage]);
  If Result Then
  Begin
    WindowExport.AddExportCommand (ecIDCurrentRow, ecdCurrentRow);
    WindowExport.AddExportCommand (ecIDCurrentPage, ecdCurrentPage);
    WindowExport.AddExportCommand (ecIDEntireList, ecdEntireList);
  End; // If Result
end;

//-------------------------------------------------------------------------

// MH 08/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
procedure TJobDaybk.WindowExportExecuteCommand(const CommandID: Integer; const ProgressHWnd: HWND);
Var
  ListExportIntf : IExportListData;
begin
  // Returns a new instance of an "Export Btrieve List To Excel" object
  ListExportIntf := NewExcelListExport;
  Try
    ListExportIntf.ExportTitle := WindowExportGetExportDescription;

    // Connect to Excel
    If ListExportIntf.StartExport Then
    Begin
      // Get the active Btrieve List to export the data
      MulCtrlO[Current_Page].ExportList (ListExportIntf, CommandID, ProgressHWnd);

      ListExportIntf.FinishExport;
    End; // If ListExportIntf.StartExport(sTitle)
  Finally
    ListExportIntf := NIL;
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

// MH 08/03/2018 2018-R2 ABSEXCH-19172: Added metadata for List Export functionality
function TJobDaybk.WindowExportGetExportDescription: String;
begin
  Case Current_Page Of
    PostPage  : Result := 'Job Pre-Postings';
    TSPage    : Result := 'Time Sheets';
    HistPage  : Result := 'Time Sheet History';
//    PLAppsPage=  3;
//    PLAppsHPage= 4;
//    SLAppsPage=  5;
//    SLAppsHPage= 6;
    PLRetPage : Result := 'P/L Retentions';
    SLRetPage : Result := 'S/L Retentions';
  Else
    Result := 'Job Daybook';
  End; // Case Current_Page
end;

//-------------------------------------------------------------------------

Initialization

  SetForApps:=BOff;


end.
