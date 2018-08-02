unit SOPB2BWU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Wiztempu, StdCtrls, TEditVal, TCustom, ExtCtrls, SBSPanel, ComCtrls,
  Mask, BorBtns,
  GlobVar,VarConst;


type
  TB2BWizard = class(TWizTemplate)
    BorRadio1: TBorRadio;
    BorRadio2: TBorRadio;
    Label82: Label8;
    Label818: Label8;
    ECIEPF: Text8Pt;
    Label85: Label8;
    IncList: TListBox;
    Inc1: TButton;
    IncAll: TButton;
    Exc1: TButton;
    ExcAll: TButton;
    ExcList: TListBox;
    Label87: Label8;
    TWFinBtn: TSBSButton;
    TabSheet3: TTabSheet;
    Label88: Label8;
    Label810: Label8;
    BorRadio3: TBorRadio;
    BorRadio5: TBorRadio;
    Label83: Label8;
    BorCheck3: TBorCheck;
    BorRadio4: TBorRadio;
    BorRadio6: TBorRadio;
    BorCheck1: TBorCheck;
    BorCheck2: TBorCheck;
    chkUseSORDeliveryAddress: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure TWPrevBtnClick(Sender: TObject);
    procedure TWFinBtnClick(Sender: TObject);
    procedure ECIEPFExit(Sender: TObject);
    procedure BorRadio1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Inc1Click(Sender: TObject);
    procedure Exc1Click(Sender: TObject);
    procedure IncListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure IncListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TWClsBtnClick(Sender: TObject);

  private
    { Private declarations }
    InFormCreate,
    fFrmClosing,
    fDoingClose

               :       Boolean;

    fSetPageCount
               :       LongInt;

    B2BCtrl    :       B2BInpRec;

    procedure FormDesign;

    procedure SetIncList;

    procedure OutWizard;

    Function BuildIncSet  :  Integer;

    procedure Form2Wizard;

    procedure Display_Trans(Mode  :  Byte);

    procedure SetHelpContextIDs; // NF: 11/05/06

  public
    { Public declarations }

    SORInv     :       InvRec;
    SORAddr    :       LongInt;


    Function GetPageCount  :  Integer; Override;
    Function GetEndPageCount  :  Integer; Override;


    procedure TryFinishWizard;

  end;


Procedure Run_B2BWizard(LInv    :  InvRec;
                        AOWner  :  TWinControl);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  BtrvU2,
  BTSupU1,
  BTSupU2,
  BTKeys1U,
  InvListU,
  Exthrd2U,
  SysU2,

  {$IFDEF LTE}
    Brand,
  {$ENDIF}

  SOPCT5U;

{$R *.DFM}


Type
  B2BLineType  =  Class (TObject)
                    LT  :  Integer;
                  end;

  B2BLinePtr   =  B2BLineType;



Var
  LocalInv   :  ^InvRec;
  LocalSORAddr
             :  LongInt;
  B2BWizard  :  TB2BWizard;
  B2BWActive :  Boolean;



Procedure Set_SORInv(LInv  :  InvRec;
                     LAddr :  LongInt);

Begin
  If (Not Assigned(LocalInv)) then
    New(LocalInv);

  LocalInv^:=LInv;

  If (LocalSORAddr<>LAddr) then
    LocalSORAddr:=LAddr;

end;

Function TB2BWizard.GetPageCount  :  Integer;

Begin
  Result:=fSetPageCount;

end;


Function TB2BWizard.GetEndPageCount  :  Integer;

Begin
  With PageControl1 do
    Result:=PageCount;
end;


procedure TB2BWizard.FormCreate(Sender: TObject);
Var
  n  :  Integer;
  BMap1
     :  TBitMap;

  RectD
     :  TRect;
begin
  fSetPageCount:=3;

  inherited;
  B2BWActive:=BOn;  InFormCreate:=BOn;


  fDoingClose:=BOff;
  fFrmClosing:=BOff;
  
  SORInv:=LocalInv^;
  SORAddr:=LocalSORAddr;

  For n:=0 to PageControl1.PageCount-1 do {Hide Tabs}
  With PageControl1 do
  Begin
    If (Assigned(Pages[n])) then
    Begin
      Pages[n].TabVisible:=BOff;
      Pages[n].Visible:=BOn;
    end;

  end; {Loop}

  PageControl1.ActivePage:=TabSheet1;

  fSetPageCount:=PageControl1.PageCount;


  Label86.Caption:=SORInv.OurRef+Label86.Caption;

  Self.Caption:=SORInv.OurRef+Caption;

  n:=-1-(2*Ord(SORInv.InvDocHed=WOR));

  B2BCtrl:=Get_LastB2BVal(FullB2BKey(AllocB2BICode,n,EntryRec^.Login),n);

  FormDesign;

  If Not NoXLogo then
  Begin
    {$IFDEF LTE}
      {$IFDEF DBD}
        InitBranding(SetDrive); // Not Necessary at run time taken from Main Co direct not data set directory
      {$ENDIF}

      With Branding do
      If (BrandingFileExists ('EntSplash')) then
        With BrandingFile('EntSplash') Do
      Begin

        If Image1.Visible Then

        Begin

          // Get appropriate bitmap from branding file

          ExtractImageCD (Image1, 'B2BWIZ');


        end;
      end; {With..}
    {$ENDIF}
  end;

  OutWizard;
  SetIncList;
  SetStepCaption;

  InFormCreate:=BOff;

  SetHelpContextIDs; // NF: 11/05/06 Fix for incorrect Context IDs
end;


procedure TB2BWizard.FormDestroy(Sender: TObject);


begin
  B2BWActive:=BOff;

  

  inherited;

end;



procedure TB2BWizard.FormDesign;

Begin
  With B2BCtrl do
  Begin
    If (Not MultiMode) then
    Begin
      Label818.Caption:='Supplier Code: ';
      Label83.Visible:=BOff;

    end {With..}
    else
    Begin
      Label818.Caption:='Default Supplier Code: ';
      Label83.Visible:=BOn;


    end;

    BorCheck1.Visible:=(SORInv.InvDocHed=WOR);

    BorCheck3.Visible:=(Not BORCheck1.Visible) or (Not Is_StdWOP);

    // CJS 2014-07-16 - ABSEXCH-15526 - Delivery Address option should be hidden on WOR wizard
    if (SORInv.InvDocHed = WOR) then
    begin
      chkUseSORDeliveryAddress.Visible := False;
      // For Works Orders, use the Supplier delivery address
      chkUseSORDeliveryAddress.Checked := False;
    end;

    TabSheet2.Visible:=BOn;

    If (SORInv.InvDocHed=WOR) then
      Label88.Caption:='Determine which Stock line types are included in the Purchase Order.';

  end;

end;


procedure TB2BWizard.FormClose(Sender: TObject; var Action: TCloseAction);

Var
  n  :  Integer;

begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    inherited;

    With IncList,Items do
      For n:=0 to Count-1 do
      Begin
        If (Assigned(Items.Objects[n])) then
          B2BLinePtr(Items.Objects[n]).Destroy;

      end;


    With ExcList,Items do
      For n:=0 to Count-1 do
      Begin
        If (Assigned(Items.Objects[n])) then
          B2BLinePtr(Items.Objects[n]).Destroy;

      end;
  end;
end;



procedure TB2BWizard.SetIncList;


Var
  n     :  Byte;
  LTBo  :  Integer;
  PDR   :  B2BLinePtr;


Begin
  With B2BCtrl do
  For n:=0 to StdDocTList.Count-1 do
  Begin
    LTBo:=LT2Boolean(n);
    PDR:=B2BLineType.Create;
    PDR.LT:=LTBo;
    If ((IncludeLT and  LTBo = LTBo)) then
      IncList.Items.AddObject(StdDocTList.Strings[n],PDR)
    else
      ExcList.Items.AddObject(StdDocTList.Strings[n],PDR);

  end;


end;



procedure TB2BWizard.OutWizard;

Begin
  With B2BCtrl do
  Begin
    BorRadio2.Checked:=MultiMode;
    ECIEPF.Text:=Trim(SuppCode);
    BorCheck3.Checked:=AutoPick;
    BorRadio4.Checked:=(QtyMode=1);
    BorRadio5.Checked:=(QtyMode=2);
    BorRadio6.Checked:=(QtyMode=3);
    BorCheck1.Checked:=ExcludeBOM;
    BorCheck2.Checked:=KeepLDates;


  end; {With..}
end;


Function TB2BWizard.BuildIncSet  :  Integer;

Var
  n     :  Integer;
  PDR   :  B2BLinePtr;

Begin
  Result:=0;

  With IncList,Items do
    For n:=0 to Count-1 do
    Begin
      If (Assigned(Items.Objects[n])) then
      Begin
        PDR:=B2BLinePtr(Items.Objects[n]);
        Result:=Result+PDR.LT;

      end;
    end;

end;


procedure TB2BWizard.Form2Wizard;

Begin
  With B2BCtrl do
  Begin
    MultiMode:=BorRadio2.Checked;
    SuppCode:=FullCustCode(ECIEPF.Text);
    AutoPick:=BorCheck3.Checked;
    QtyMode:=(1*Ord(BorRadio4.Checked))+(2*Ord(BorRadio5.Checked))+(3*Ord(BorRadio6.Checked));
    IncludeLT:=BuildIncSet;
    GenOrder:=0;

    If (SORInv.InvDocHed=WOR) then
    Begin
      ExcludeBOM:=BorCheck1.Checked;

      If (Is_StdWOP) then
        AutoPick:=BOff; {We cannot part pick any WOR}
    end;

    KeepLDates:=BorCheck2.Checked;

  end; {With..}
end;




procedure TB2BWizard.TWPrevBtnClick(Sender: TObject);


begin
  {If (SORInv.InvDocHed=WOR) and (PageControl1.ActivePage<>TabSheet2) then
  Begin
    AdvancePages:=1
  end;}

  inherited;

  TWNextBtn.Visible:=Not IsFinish;

  AdvancePages:=0;

  SetHelpContextIDs; // NF: 11/05/06 Fix for incorrect Context IDs
end;


procedure TB2BWizard.BorRadio1Click(Sender: TObject);
begin
  inherited;

  If (Not InFormCreate) then
  Begin
    Form2Wizard;
    FormDesign;
  end;
end;

procedure TB2BWizard.ECIEPFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    FoundCode:=Name;

    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If (AltMod) and (ActiveControl<>TWClsBtn)  then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOff,3,));


      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;

      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;



procedure TB2BWizard.Inc1Click(Sender: TObject);

Var
  n,m,i  :  Integer;

  SendAll
       :  Boolean;

begin
  inherited;

  SendAll:=(Sender=IncAll);

  With IncList do
  If (SelCount>0) or (SendAll) then
  Begin
    n:=0; m:=0;

    i:=Items.Count-1;

    While (m<=i) do
    Begin
      {$B-}

      If (SendAll) or (Selected[n]) then

      {$B+}
      Begin
        ExcList.Items.AddObject(Items[n],Items.Objects[n]);

        {Dispose(Items.Objects[n]);}

        Items.Delete(n);
      end
      else
        Inc(n);

      Inc(m);
    end;
  end;

end;


procedure TB2BWizard.Exc1Click(Sender: TObject);
Var
  n,m,i  :  Integer;

  SendAll
       :  Boolean;

begin
  inherited;

  SendAll:=(Sender=ExcAll);

  With ExcList do
  If (SelCount>0) or (SendAll) then
  Begin
    n:=0; m:=0;

    i:=Items.Count-1;

    While (m<=i) do
    Begin
      {$B-}

      If (SendAll) or (Selected[n]) then

      {$B+}
      Begin
        IncList.Items.AddObject(Items[n],Items.Objects[n]);

        Items.Delete(n);
      end
      else
        Inc(n);

      Inc(m);
    end;

  end;
end; {Porc..}



procedure TB2BWizard.IncListDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  inherited;
  If (Source=ExcList) then
    Exc1Click(Nil)
  else
    If (Source =IncList) then
      Inc1Click(Nil);

end;

procedure TB2BWizard.IncListDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  Accept:=(Sender = IncList) or (Sender = ExcList);
end;



{ ======= Link to Trans display ======== }

procedure TB2BWizard.Display_Trans(Mode  :  Byte);

Begin
  If (Owner is TForm) then
    PostMessage((Self.Owner as TForm).Handle,WM_FormCloseMsg,66,0);

end;





procedure TB2BWizard.TryFinishWizard;

Const
  OrderDesc  :  Array[BOff..BOn] of Str20 = ('order','orders');
Var
  SuppOk  :  Boolean;
  mbRet   :  Word;
  FoundCode
          :  Str20;
begin
  inherited;

  Form2Wizard;

  With B2BCtrl do
    SuppOk:=((Trim(SuppCode)<>'') and (GetCust(Self,SuppCode,FoundCode,BOff,-1)));

  If (Not SuppOk) then
  Begin
    Set_BackThreadMVisible(BOn);

    MessageDlg(Trim(B2BCtrl.SuppCode)+#13+'That supplier code is not valid.',mtWarning,[mbOK],0);

    Set_BackThreadMVisible(BOff);

  end
  else
  Begin
    Set_BackThreadMVisible(BOn);

    mbRet:=MessageDlg('Please confirm you wish to generate the back to back '+OrderDesc[B2BCtrl.MultiMode],mtConfirmation,[mbYes,mbNo],0);

    Set_BackThreadMVisible(BOff);

    SuppOk:=(mbRet=mrYes);

    If (SuppOK) then
    Begin

      Put_LastB2BVal(AllocB2BICode,B2BCtrl,-1-(2*Ord(SORInv.InvDocHed=WOR)),EntryRec^.Login);

      // CJS 2014-07-07 - ABSEXCH-2925 - delivery address on back to back orders
      Generate_MB2BPOR(SORInv,SORAddr,B2BCtrl,not chkUseSORDeliveryAddress.Checked);


      With B2BCtrl do
      If (GenOrder=1) then
      Begin
        Display_Trans(2);
      end;

      PostMessage(Self.Handle,WM_Close,0,0);
    end;
  end;

end;

procedure TB2BWizard.TWFinBtnClick(Sender: TObject);

Begin
  TryFinishWizard;

end;

procedure TB2BWizard.TWClsBtnClick(Sender: TObject);

Var
  LStatus  :  Integer;

begin
  LStatus:=0;
  
  inherited;
  {* Explicitly remove multi lock *}

  If (SORAddr<>0) then
  Begin
    LStatus:=UnLockMultiSing(F[InvF],InvF,SORAddr);

    Report_BError(InvF,LStatus);
  end
end;

// NF: 11/05/06 Fix for incorrect Context IDs
procedure TB2BWizard.SetHelpContextIDs;
begin
  case PageControl1.ActivePage.PageIndex of
    0 : begin
      // Step 1
      BorRadio1.HelpContext := 1731;
      BorRadio2.HelpContext := 1732;
      ECIEPF.HelpContext := 1733;
      BorCheck3.HelpContext := 1734;
      BorCheck2.HelpContext := 1735;

      TWClsBtn.HelpContext := 1736;
//      TWPrevBtn.HelpContext := ;
      TWNextBtn.HelpContext := 1737;
      TWFinBtn.HelpContext := 1738;

      HelpContext := 1748;
    end;
    1 : begin
      // Step 2
      IncList.HelpContext := 1739;
      Inc1.HelpContext := IncList.HelpContext;
      IncAll.HelpContext := IncList.HelpContext;
      Exc1.HelpContext := IncList.HelpContext;
      ExcAll.HelpContext := IncList.HelpContext;
      ExcList.HelpContext := IncList.HelpContext;

      TWClsBtn.HelpContext := 1740;
      TWPrevBtn.HelpContext := 1741;
      TWNextBtn.HelpContext := 1742;
      TWFinBtn.HelpContext := 1743;

      HelpContext := 1829;
    end;
    2 : begin
      // Step 3
      BorRadio3.HelpContext := 1744;
      BorRadio4.HelpContext := BorRadio3.HelpContext;
      BorRadio6.HelpContext := BorRadio3.HelpContext;
      BorRadio5.HelpContext := BorRadio3.HelpContext;

      TWClsBtn.HelpContext := 1745;
      TWPrevBtn.HelpContext := 1746;
//      TWNextBtn.HelpContext := ;
      TWFinBtn.HelpContext := 1747;

      HelpContext := 1830;
    end;
  end;{case}

  PageControl1.HelpContext := HelpContext;
  PageControl1.ActivePage.HelpContext := HelpContext;
end;

{ == Procedure to display wizard == }

Procedure Run_B2BWizard(LInv    :  InvRec;
                        AOWner  :  TWinControl);

Var
  LAddr  :  LongInt;
  Locked :  Boolean;
  KeyS   :  Str255;

Begin
  Locked:=BOff;

  KeyS:=LInv.OurRef;

  If GetMultiRecAddr(B_GetEq,B_MultLock,KeyS,InvOurRefK,InvF,BOff,Locked,LAddr) then
  Begin

    Set_SORInv(LInv,LAddr);

    If (Assigned(B2BWizard)) and (B2BWActive) then
      B2BWizard.Show
    else
    Begin
      B2BWizard:=TB2BWizard.Create(AOWner);



    end;
  end;

end;









Initialization
  LocalInv:=Nil;
  B2BWizard:=Nil;
  B2BWActive:=BOff;

  LocalSORAddr:=0;

Finalization
  If (Assigned(LocalInv)) then
    Dispose(LocalInv);

end.
