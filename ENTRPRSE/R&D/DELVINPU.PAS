unit DelvinpU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, BTSupU1, BTSupU3,
  BorBtns, Mask, TEditVal,
  GlobVar,VarConst, ComCtrls, AdvEdit, AdvEdBtn, AdvDirectoryEdit;


type
  TSOPInpMsg = class(TRepInpMsg)
    Label87: Label8;
    Sum6: TBorCheck;
    Sum7: TBorCheck;
    Sum2: TBorCheck;
    Sum3: TBorCheck;
    Sum4: TBorCheck;
    AgeInt: TCurrencyEdit;
    Sum5: TBorCheck;
    PDNote: TSBSComboBox;
    PDLab: TSBSComboBox;
    PConN: TSBSComboBox;
    PPLab: TSBSComboBox;
    PrnScrnB: TBorCheck;
    PPaper: TBorCheck;
    Label83: Label8;
    ACFF: Text8Pt;
    Label81: Label8;
    Sum1: TCurrencyEdit;
    Label82: Label8;
    Label811: Label8;
    FilterX: TSBSComboBox;
    lblXMLLocation: Label8;
    edtXMLLocation: TAdvDirectoryEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure Sum1KeyPress(Sender: TObject; var Key: Char);
    procedure Sum6Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    SingDoc,
    PrevHState,
    UseDirect

             :  Boolean;
    SOPInp   :  SOPInpRec;
    DocHed   :  DocTypes;
    SOPMode  :  Byte;

    NextRNo  :  LongInt;

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure FormSetRO;

    procedure SetCaption;

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    procedure SetHelpContextIDs; // NF: 11/05/06

    procedure EnableXML;

  private
    { Private declarations }
    CRepParam  :  PPickRepPtr;

  public
    { Public declarations }

  end;



procedure Start_SopRun(IDMode  :  DocTypes;
                       SPMode,
                       PTagNo  :  Byte;
                       OneDoc,
                       OPinDirect
                               :  Boolean;
                       AOwner  :  TComponent);

Var
  RDocHed  :  DocTypes;
  SMode   :  Byte;
  ODoc     :  Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  RPDefine,
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,

  {$IFDEF FRM}
    PrintFrm,
    DelvRunU,
  {$ENDIF}

  SOPCT2U,

  BTKeys1U,
  SysU1,
  SysU2,
  BTSupU2,
  ComnUnit,
  InvListU,
  MiscU,
  SOPCT3U,
  {$IFDEF CU}
    Event1U,
  {$ENDIF}

  EXWrap1U,
  Exthrd2U,

  oProcessLock;



{$R *.DFM}


var
  PinDirect   :  Boolean;
  PurchTagNo  :  Byte;



procedure TSOPInpMsg.FormSetRO;

Begin
  Sum1.Enabled:=(SopMode In [1..3]);

  AgeInt.ReadOnly:=Sum1.Enabled;
  AgeInt.TabStop:=Not AgeInt.ReadOnly;

  Sum3.Enabled:=(SopMode In [1,11]);
  Sum4.Enabled:=(SopMode In [1,11]);
  Sum5.Enabled:=(SopMode In [1,11]);

  Sum6.Enabled:=(SopMode<>2);

  PPaper.Enabled:=(SopMode In [1,3]);

  Sum7.Enabled:=Sum1.Enabled;

  PDLab.ReadOnly:=Not Sum3.Enabled;
  PConN.ReadOnly:=Not Sum4.Enabled;
  PPLab.ReadOnly:=Not Sum5.Enabled;

  PDLab.TabStop:=Sum3.Enabled;
  PConN.TabStop:=Sum4.Enabled;
  PPLab.TabStop:=Sum5.Enabled;

  If (SOPMode In [2,12]) then
  Begin
    Sum3.HelpContext:=491;
    Sum4.HelpContext:=491;
    Sum5.HelpContext:=491;
    PDLab.HelpContext:=491;
    PConN.HelpContext:=491;
    PPLab.HelpContext:=491;
    Self.HelpContext:=493;
    Sum6.HelpContext:=491;
  end;

  If (SOPMode In [11..13]) or (Not UseEMLocStk) then
  Begin
    AcFF.Visible:=BOff;
    Label83.Visible:=BOff;
  end;

  If (SOPMode In [2,12]) and (eCommsModule) then {We are generating Invoice print run so lets offer paperless filter}
  Begin
    FilterX.Visible:=BOn;
    Label811.Visible:=BOn;
  end;

  {$IFDEF LTE}
    Sum7.Visible:=BOff;
  {$ENDIF}

  if ((SOPMode in [1,2]) and eBusModule) then
  begin
    //PR: 27/04/2016 ABSEXCH-10939 Display fields for xml output
    FilterX.Items.Add('eBis XML');

    lblXMLLocation.Visible := True;
    edtXMLLocation.Visible := True;
    edtXMLLocation.Text := SetDrive + 'Reports\';   //Default to company reports folder at DR's request

    EnableXML;
  end
  else
  begin
    //Move up check boxes
    Sum6.Top := 214;
    Sum7.Top := 233;
    PPaper.Top := 253;
    PrnScrnB.Top := 273;

    //Shorten panel and forms, and move up buttons
    SBSPanel4.Height := 297;
    ClientHeight := 327;

    OKCP1Btn.Top := 303;
    ClsCP1Btn.Top := 303;
  end;


end;


procedure TSOPInpMsg.SetCaption;

Begin
  Case SOPMode of
    1  :  Caption:='Deliver all picked Orders';
    2  :  Caption:='Invoice all Delivery Notes';
   11  :  Caption:='Re-print Delivery Run';
   12  :  Caption:='Re-print Invoice Run';

  end; {Case..}
end;

procedure TSOPInpMsg.FormCreate(Sender: TObject);


begin
  inherited;

  ClientHeight:=360;
  ClientWidth:=299;

  PrevHState:=BOff;

  New(CRepParam);

  DocHed:=RDocHed;
  SOPMode:=SMode;
  SingDoc:=ODoc;

  UseDirect:=PinDirect;

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);

    With CRepParam^.PParam do
    Begin
      PBatch:=BOn;
      PDevRec.Preview:=BOn;
      PDevRec.NoCopies:=1;
      Orient:=poPortrait;
      UFont:=Nil;
      RepCaption:='Order Processing';
    end;
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  If (Not Get_LastSOPVal(FullSOPFile(AllocTCode,AllocSCode,1),SOPInp)) then
  Begin

    Init_SOPInp(SOPInp);

  end;


  {$IFDEF Frm}
    With SOPInp do
    Begin
      pfSet_DefaultPrinter(PDNote,WPrnName[1]);
      pfSet_DefaultPrinter(PDLab,WPrnName[3]);
      pfSet_DefaultPrinter(PConN,WPrnName[2]);
      pfSet_DefaultPrinter(PPLab,WPrnName[4]);
    end; {With..}
  {$ENDIF}

  {NextRNo:=GetNextCount(SDG,BOff,BOff,0);}

  NextRNo:=SetNextSOPRunNo(Set_MatchLinkDoc(DocHed,SOPMode),BOff,0);


  If (SOPMode In [11..13]) then
    NextRNo:=Pred(NextRNo);

  SetCaption;

  With SOPInp do
  Begin

    Case SOPMode of
      1,3  :  Begin
                Sum1.Value:=DelTag;
                Sum7.Checked:=DelCons;
              end;
      2    :  Begin
                Sum1.Value:=InvTag;
                Sum7.Checked:=InvCons;
                Sum2.Caption:='Print Invoices :';
              end;
    end; {Case..}


    Sum2.Checked:=DelPrn[1];
    Sum3.Checked:=DelPrn[3];
    Sum4.Checked:=DelPrn[2];
    Sum5.Checked:=DelPrn[4];
    Sum6.Checked:=SOR2Inv;
    AcFF.Text:=SOPMLoc;

    PPaper.Checked:=PapChange;

    PrnScrnB.Checked:=PrnScrn;

    AgeInt.Value:=NextRNo;

    FilterX.ItemIndex:=0;


  end; {With..}

  If (SingDoc) or (DocHed In PurchSplit) then
  Begin
    Width:=0;

    Height:=0;

    Animated1.Play:=BOff;

    If (DocHed In PurchSplit) and (Not SingDoc) then
      Sum1.Value:=PurchTagNo;

    OKCP1Btn.Click;
  end
  else
    FormSetRO;

  SetHelpContextIDs; // NF: 11/05/06 Fix for incorrect Context IDs

end;

procedure TSOPInpMsg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;



Procedure TSOPInpMsg.WMCustGetRec(Var Message  :  TMessage);

Begin
  With Message do
  Begin


    Case WParam of

      182
         :  Begin
              Send_UpdateList(WParam);
            end;


    end; {Case..}

  end; {With..}

  Inherited;

end;



Procedure TSOPInpMsg.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode;
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


procedure TSOPInpMsg.ACFFExit(Sender: TObject);
Var
  FoundCode  :  Str10;

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

    If (AltMod) and (ActiveControl<>ClsCP1Btn)  and (FoundCode<>'') then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetMLoc(Self.Owner,FoundCode,FoundCode,'',0));

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

procedure TSOPInpMsg.OkCP1BtnClick(Sender: TObject);

Var
  TStr  :  Str10;

  {$IFDEF FRM}

    MsgForm  :  TSOPRunFrm;

  {$ENDIF}

  ExLocal  :  TdExLocal;

  AddHook  :  Boolean;

  TInv     :  InvRec;

Procedure Prime_PrintDev;

Begin
  With CRepParam^,PParam.PDevRec do {Set Paperless options here as normally set by print dialog which is bypassed by this routine}
  Begin
    feFaxMethod     := SyssEDI2^.EDI2Value.FxUseMAPI;

    If (UserProfile^.UserName='') or (Not UserProfile^.Loaded) then
    Begin
      If (SyssEDI2^.EDI2Value.FxName<>'') then
        feFaxFrom:= SyssEDI2^.EDI2Value.FxName
      else
        feFaxFrom:= Syss.UserName;
    end
    else
      feFaxFrom:= UserProfile^.UserName;

    If (SyssEDI2^.EDI2Value.FxPhone<>'') then
      feFaxFromNo:= SyssEDI2^.EDI2Value.FxPhone
    else
      feFaxFromNo:= Syss.DetailFax;

    feFaxPriority   := 1;

    feEmailMAPI     := SyssEDI2^.EDI2Value.EmUseMAPI;

    If (UserProfile^.UserName='') or (Not UserProfile^.Loaded) then
      feEmailFrom:= SyssEDI2^.EDI2Value.EmName
    else
      feEmailFrom:= UserProfile^.UserName;

    If (UserProfile^.EmailAddr='') or (Not UserProfile^.Loaded) then
      feEmailFromAd:= SyssEDI2^.EDI2Value.EmAddress
    else
      feEmailFromAd:= UserProfile^.EmailAddr;

    feEmailPriority := SyssEDI2^.EDI2Value.EmPriority;
    feEmailAtType   := SyssEDI2^.EDI2Value.emAttchMode;

    feInvMode:=BOn; {Tell paperless that we are sending invoices, not statements}

    feCoversheet    := SyssForms^.FormDefs.PrimaryForm[44];

    //PR: 27/04/2016 ABSEXCH-10939 Set xml output file location
    if eBusModule and (Trim(edtXMLLocation.Text) <> '') then
      feXMLFileDir := IncludeTrailingPathDelimiter(Trim(edtXMLLocation.Text));

  end;


end;

begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      AddHook:=Sender=OkCP1Btn;

      TInv:=Inv;

      {$IFDEF CU}

        ExLocal.Create;


        If (AddHook) and (Not SingDoc) and (SOPMode In [1,3]) then
          AddHook:=ValidExitHook(2000,2,ExLocal);

        ExLocal.Destroy;

      {$ENDIF}

      If (AddHook) then
      With CRepParam^,PParam,SopInp do
      Begin


        {$IFDEF FRM}
          If (pf_Check4Printers) then
        {$ENDIF}
        Begin

          DelPrn[1]:=Sum2.Checked;
          DelPrn[3]:=Sum3.Checked;
          DelPrn[2]:=Sum4.Checked;
          DelPrn[4]:=Sum5.Checked;
          PrnScrn:=PrnScrnB.Checked;
          PapChange:=PPaper.Checked;

          SOR2Inv:=Sum6.Checked;

          NextRNo:=Round(AgeInt.Value);

          WPrnName[1]:=Copy(PDNote.Text,1,20);
          WPrnName[3]:=Copy(PDLab.Text,1,20);
          WPrnName[2]:=Copy(PConN.Text,1,20);
          WPrnName[4]:=Copy(PPLab.Text,1,20);

          SOPMLoc:=AcFF.Text;

          Case SOPMode of
            1,3  :  Begin
                      DelTag:=Round(ABS(Sum1.Value));
                      DelCons:=Sum7.Checked;
                      Prime_PrintDev;
                    end;

            2    :  Begin
                      InvTag:=Round(ABS(Sum1.Value));
                      InvCons:=Sum7.Checked;

                      If (FilterX.ItemIndex<>1) then
                        Prime_PrintDev;
                    end;
            //PR: 07/05/2014 ABSEXCH-15311 Initialise email stuff
            12   :  Prime_PrintDev;
          end;



          If (SOPMode In [1..3]) and (DocHed In SalesSplit) and (Not SingDoc) then
            Put_LastSOPVal(AllocSCode,SOPInp,1);

          If (SOPMode In [1..3]) and (DocHed In PurchSplit) then
          Begin
            If (Not SingDoc) then
              Case SOPMode of
                1,3  :  Begin
                          DelTag:=0;
                          DelCons:=BOff;
                          SOPMLoc:='';

                          Sor2Inv:=UseDirect;

                        end;

                2    :  Begin
                          {InvTag:=1;}
                          InvCons:=BOn;
                          SOPMLoc:='';

                          Sor2Inv:=BOff;
                        end;
              end {Case..}
              else
                If (SOPMode In [1,3]) then {Allow for direct conversion }
                  Sor2Inv:=UseDirect;
          end;

          PSopInp:=SopInp;


          {$IFDEF FRM}

            MsgForm:=TSOPRunFrm.Create(Self);

            try
              With MsgForm do
              Begin
                {* Update here for single document *}

                If (SingDoc) then
                  NextRNo:=SetNextSOPRunNo(Set_MatchLinkDoc(DocHed,SOPMode),SingDoc,0);

                  {NextRNo:=GetNextCount(SDG,SingDoc,BOff,0);}

                PCRepParam:=CRepParam;
                PDocHed:=DocHed;
                ThisRun:=NextRNo;
                ThisMode:=SOPMode;
                SingleDoc:=SingDoc;
                SFiltX:=FilterX.ItemIndex;


                SetAllowHotKey(BOff,PrevHState);

                Set_BackThreadMVisible(BOn);

                ShowModal;

                Set_BackThreadMVisible(BOff);

                SetAllowHotKey(BOn,PrevHState);

              end;

            Finally
              MsgForm.Free;
            end; {try..}
          {$ENDIF}
         end
         {$IFDEF FRM}
           else
             MessageDlg ('A printer must be defined before anything can be printed!', mtWarning, [mbOk], 0);
         {$ELSE}
           ;

         {$ENDIF}
      end;

      Inv:=TInv;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;

// NF: 11/05/06 Fix for incorrect Context IDs
procedure TSOPInpMsg.SetHelpContextIDs;
begin
  FilterX.HelpContext := 1751;
  Sum1.HelpContext := 481;

  // NF: 21/06/06 added new ids to differenciate between modes
  Case SOPMode of
    1  :  Sum1.HelpContext := 1849; // Deliver all picked Orders
    2  :  Sum1.HelpContext := 1850; // Invoice all Delivery Notes
//   11  :  Sum1.HelpContext := 1851; // Re-print Delivery Run
//   12  :  Sum1.HelpContext := 1852; // Re-print Invoice Run
  end; {Case..}
end;


procedure Start_SopRun(IDMode  :  DocTypes;
                       SPMode,
                       PTagNo  :  Byte;
                       OneDoc,
                       OPinDirect
                               :  Boolean;
                       AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TSOPInpMsg;

  Begin
    RDocHed:=IDMode;
    SMode:=SPMode;
    ODoc:=OneDoc;
    PurchTagNo:=PTagNo;

    PinDirect:=OPinDirect;

    RepInpMsg1:=TSOPInpMsg.Create(AOwner);

  end;



procedure TSOPInpMsg.Sum1KeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = '-') then
    Key := #0;
end;

procedure TSOPInpMsg.EnableXML;
begin
  if lblXMLLocation.Visible then
    edtXMLLocation.Enabled := (SOPMode = 2) or (Sum6.Checked);
end;

procedure TSOPInpMsg.Sum6Click(Sender: TObject);
begin
  EnableXML;
end;

procedure TSOPInpMsg.FormDestroy(Sender: TObject);
begin
  //PR: 23/05/2017 ABSEXCH-18683 Release lock
  SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plInvoiceDeliveries), 0);

end;

Initialization

  PinDirect:=BOff;
  PurchTagNo:=0;

end.
