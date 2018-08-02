unit RETInpU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, BTSupU1, BTSupU3,
  BorBtns, Mask, TEditVal,
  GlobVar,VarConst, ComCtrls, RetSup1U;


type
  TRETInpMsg = class(TRepInpMsg)
    Label87: Label8;
    Sum2: TBorCheck;
    AgeInt: TCurrencyEdit;
    PDNote: TSBSComboBox;
    PrnScrnB: TBorCheck;
    Label83: Label8;
    ACFF: Text8Pt;
    Sum1: TCurrencyEdit;
    Label82: Label8;
    Label81: Label8;
    PInvDoc: TSBSComboBox;
    Sum3: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
  private
    { Private declarations }
    SingDoc,
    PrevHState
             :  Boolean;
    SOPInp   :  SOPInpRec;
    DocHed   :  DocTypes;
    SOPMode  :  Byte;

    NextRNo  :  LongInt;
    CRepParam:  PPickRepPtr;


    Procedure Send_UpdateList(Mode   :  Integer);

    procedure FormSetRO;

    procedure SetCaption;


    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    
  public
    { Public declarations }
    RIRetWizRec:  tRetWizRec;

  end;



procedure Start_RETRun(IDMode  :  DocTypes;
                       SPMode  :  Byte;
                       OneDoc  :  Boolean;
                       RetWizRec
                               :  tRetWizRec;
                       AOwner  :  TComponent);

Var
  RDocHed   :  DocTypes;
  SMode     :  Byte;
  ODoc      :  Boolean;
  LRetWizRec:  tRetWizRec;

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
  Exthrd2U;



{$R *.DFM}






procedure TRETInpMsg.FormSetRO;

Begin
  Sum1.Enabled:=(SopMode In [100,101]);

  AgeInt.ReadOnly:=Sum1.Enabled;
  AgeInt.TabStop:=Not AgeInt.ReadOnly;


  If (SOPMode In [101]) then
  Begin
    PDNote.HelpContext:=0;
    Self.HelpContext:=0;
  end;

  Sum2.Visible:=(SOPMode=102) and (DocHed In StkRetSalesSplit);
  PDNote.Visible:=Sum2.Visible;
  PrnScrnB.Visible:=Sum2.Visible;
  Sum3.Visible:=Sum2.Visible;
  PInvDoc.Visible:=Sum2.Visible;

  {$IFDEF SOP}
    If (Not UseEMLocStk) or (Not Sum1.Enabled) then
  {$ENDIF}
  Begin
    AcFF.Visible:=BOff;
    Label83.Visible:=BOff;
  end;

end;


procedure TRETInpMsg.SetCaption;

Begin
  Case SOPMode of

    100 :  Begin
             If (DocHed In StkRetSplit) then
               Caption:='Receive Stock for '
             else
               Caption:='Send Stock for ';

             Caption:=Caption+DocNames[DocHed]+'s';

           end;
    101 :  Caption:='Complete all '+DocNames[DocHed]+'s';

    102 :  Caption:='Reprint '+DocNames[DocHed]+'s Action run';

  end; {Case..}
end;

procedure TRETInpMsg.FormCreate(Sender: TObject);


begin
  inherited;

  ClientHeight:=187;
  ClientWidth:=336;

  PrevHState:=BOff;

  New(CRepParam);

  DocHed:=RDocHed;
  SOPMode:=SMode;
  SingDoc:=ODoc;
  RIRetWizRec:=LRetWizRec;

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);

    With CRepParam^.PParam do
    Begin
      PBatch:=BOn;
      PDevRec.Preview:=BOn;
      PDevRec.NoCopies:=1;
      Orient:=poPortrait;
      UFont:=Nil;
      RepCaption:=DocNames[DocHed]+'s';
    end;
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  If (Not Get_LastSOPVal(FullSOPFile(AllocTCode,AllocSCode,101),SOPInp)) then
  Begin

    Init_SOPInp(SOPInp);

  end;


  {$IFDEF Frm}
    With SOPInp do
    Begin
      pfSet_NDPDefaultPrinter(PDNote,WPrnName[1],2);


      If (PDNote.ItemIndex<0) then
        PDNote.ItemIndex:=0;

      If (WPrnName[1]<>'') then
        PdNote.Text:=WPrnName[1];

      pfSet_NDPDefaultPrinter(PInvDoc,WPrnName[2],2);


      If (PInvDoc.ItemIndex<0) then
        PInvDoc.ItemIndex:=0;

      If (WPrnName[2]<>'') then
        PInvDoc.Text:=WPrnName[2];

    end; {With..}
  {$ENDIF}

  NextRNo:=SetNextWOPRunNo(DocHed,BOff,0);


  If (SOPMode In [102]) then
    NextRNo:={Pred(NextRNo);}0;

  SetCaption;

  With SOPInp do
  Begin

    Case SOPMode of
      100  :  Begin
                Sum1.Value:=DelTag;
              end;
      101  :  Begin
                Sum1.Value:=InvTag;
              end;
    end; {Case..}


    Sum2.Checked:=DelPrn[1];
    Sum3.Checked:=DelPrn[2];

    AcFF.Text:=SOPMLoc;

    PrnScrnB.Checked:=PrnScrn;

    AgeInt.Value:=NextRNo;

  end; {With..}

  Animated1.Visible:=BOff;

  If (SingDoc) then
  Begin
    Width:=0;
    Height:=0;
    Animated1.Play:=BOff;
    OKCP1Btn.Click;
  end
  else
    FormSetRO;

end;

procedure TRETInpMsg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;



Procedure TRETInpMsg.WMCustGetRec(Var Message  :  TMessage);

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



Procedure TRETInpMsg.Send_UpdateList(Mode   :  Integer);

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


procedure TRETInpMsg.ACFFExit(Sender: TObject);
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

      {$IFDEF SOP}
        FoundOk:=(GetMLoc(Self.Owner,FoundCode,FoundCode,'',0));
      {$ENDIF}

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

procedure TRETInpMsg.OkCP1BtnClick(Sender: TObject);

Var
  TStr  :  Str10;

  {$IFDEF FRM}

    MsgForm  :  TSOPRunFrm;

  {$ENDIF}

  ExLocal  :  TdExLocal;

  AddHook  :  Boolean;

  TInv     :  InvRec;

begin
  AddHook:=Sender=OkCP1Btn;

  TInv:=Inv;

  {$IFDEF CUXX}

    ExLocal.Create;


    If (AddHook) and (Not SingDoc) and (SOPMode In [90,91]) then
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
      DelPrn[2]:=Sum3.Checked;

      PrnScrn:=PrnScrnB.Checked;

      NextRNo:=Round(AgeInt.Value);

      WPrnName[1]:=Copy(PDNote.Text,1,20);
      WPrnName[2]:=Copy(PInvDoc.Text,1,20);

      SOPMLoc:=AcFF.Text;

      Case SOPMode of
       100   :  Begin
                  DelTag:=Round(Sum1.Value);
                end;

       101   :  Begin
                  InvTag:=Round(Sum1.Value);
                end;
      end;



      If (SOPMode In [100,101]) and (DocHed In StkRetSplit) and (Not SingDoc) then
        Put_LastSOPVal(AllocSCode,SOPInp,101);


      PSopInp:=SopInp;


      {$IFDEF FRM}

        MsgForm:=TSOPRunFrm.Create(Self);

        try
          With MsgForm do
          Begin
            {* Update here for single document *}

            If (SingDoc) then
              NextRNo:=SetNextWOPRunNo(DocHed,SingDoc,0);

            PCRepParam:=CRepParam;
            PDocHed:=DocHed;
            ThisRun:=NextRNo;
            ThisMode:=SOPMode;
            SingleDoc:=SingDoc;
            DRetWizRec:=RIRetWizRec;


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

end;


procedure Start_RETRun(IDMode  :  DocTypes;
                       SPMode  :  Byte;
                       OneDoc  :  Boolean;
                       RetWizRec
                               :  tRetWizRec;
                       AOwner  :  TComponent);

  Var
    RepInpMsg1  :  TRETInpMsg;

  Begin
    RDocHed:=IDMode;
    SMode:=SPMode;
    ODoc:=OneDoc;
    LRetWizRec:=RetWizRec;


    RepInpMsg1:=TRETInpMsg.Create(AOwner);

  end;



Initialization

FillChar(LRetWizRec,Sizeof(LRetWizRec),#0);


end.
