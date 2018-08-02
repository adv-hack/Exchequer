unit JobApWzU;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WIZTEMPU, StdCtrls, TEditVal, TCustom, ExtCtrls, SBSPanel,
  ComCtrls, Mask,
  GlobVar,
  VarConst,
  JobSup2U,
  ExWrap1U, BorBtns;



type
  TJobAppWizard = class(TWizTemplate)
    Label812: Label8;
    JCodeF: Text8Pt;
    Label816: Label8;
    JDeF: Text8Pt;
    Label87: Label8;
    PCurrF: TSBSComboBox;
    PQuotF: TCurrencyEdit;
    A1StartDF: TEditDate;
    Label82: Label8;
    I4JAnalL: Label8;
    I4JobAnalF: Text8Pt;
    J1BASISF: TSBSComboBox;
    A1ValueBasis: TSBSComboBox;
    A1JSTFBudgetcb: TBorCheckEx;
    A1UseValcb: TBorCheckEx;
    SeriesF: TCurrencyEdit;
    Label83: Label8;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure JCodeFExit(Sender: TObject);
    procedure I4JobAnalFExit(Sender: TObject);
    procedure A1UseValcbClick(Sender: TObject);
  private
    { Private declarations }

    awWarned,
    JustCreated:  Boolean;
    JTMode     :  Byte;
    DocHed     :  DocTypes;
    ExLocal    :  TdExLocal;
    AccCode    :  Str10;
    wJCode     :  Str10;

    Function GetPageCount  :  Integer; Override;

    Function GetEndPageCount  :  Integer; Override;

    procedure Form2Wizard;

    Function Valid_TempType(DT  :  DocTypes)  :  Boolean;

    Function wLink_To_Job(JC  :  Str10)  :  Boolean;

    Function CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

    procedure SetJSTcb(Sender: TObject);

    procedure Display_GlobalTrans(Mode  :  Byte);

    procedure TryFinishWizard; Override;

    procedure SetWizHelp;

  public
    { Public declarations }
    JAppWizRec  :  tJAppWizRec;
  end;

Procedure Set_JPAJCT(LInv  :  InvRec;
                     LId   :  IDetail;
                     JDoc  :  DocTypes;
                     ACode,
                     JCode :  Str10;
                     JMode :  Byte;
                     LAddr :  LongInt);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  VarRec2U,
  InvListU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BTSupU1,
  BTSupU2,
  BTKeys1U,
  SBSComp2,
  GenWarnU,
  ThemeFix,
  Tranl1U;

{$R *.dfm}



Var
  LocalInv   :  ^InvRec;
  LocalId    :  ^Idetail;
  LocalJCTAddr
             :  LongInt;

  LocalDoc   :  DocTypes;
  LocalMode  :  Byte;
  LocalAc,
  LocalJob   :  Str10;
  JPAWizard  :  TJobAppWizard;
  JPAWActive :  Boolean;


{ Mode. 0 = Normal call
        1 = Called from Job record to add JCT/JST, so job code already known
        2 = Called from J?T so base it on that}

Procedure Set_JPAJCT(LInv  :  InvRec;
                     LId   :  IDetail;
                     JDoc  :  DocTypes;
                     ACode,
                     JCode :  Str10;
                     JMode :  Byte;
                     LAddr :  LongInt);

Begin
  If (Not Assigned(LocalInv)) then
    New(LocalInv);

  LocalInv^:=LInv;

  If (Not Assigned(LocalId)) then
    New(LocalId);

  LocalId^:=LId;

  If (LocalJCTAddr<>LAddr) then
    LocalJCTAddr:=LAddr;

  If (LocalMode<>JMode) then
    LocalMode:=JMode;

  If (LocalDoc<>JDoc) then
    LocalDoc:=JDoc;

  If (LocalAc<>ACode) then
    LocalAc:=ACode;

  If (LocalJob<>JCode) then
    LocalJob:=JCode;

end;


procedure TJobAppWizard.FormCreate(Sender: TObject);

Var
  n     :  Byte;
  JRef  :  Str10;

  BasisSet
        :  Boolean;


begin

  inherited;

  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ExLocal.Create;

  JPAWActive:=BOn;  awWarned:=BOff;  BasisSet:=BOff;

  FillChar(JAppWizRec,Sizeof(JAppWizRec),#0);


  JustCreated:=BOn;

  {$IFNDEF MC_On}
    PCurrF.Visible:=BOff;
    PQuotF.Left:=PCurrF.Left;

  {$ELSE}

    Set_DefaultCurr(PCurrF.Items,BOff,BOff);
    Set_DefaultCurr(PCurrF.ItemsL,BOff,BOn);

    PCurrF.ItemIndex:=0;
  {$ENDIF}

  A1StartDF.DateValue:=Today;

  {LastValueObj.GetAllLastValuesFull(Self);}

  DocHed:=LocalDoc;

  JTMode:=LocalMode;

  AccCode:=LocalAc;

  wJCode:=LocalJob;

  Label86.Caption:=DocNames[DocHed]+' '+Label86.Caption;

  ClientHeight:=291;
  ClientWidth:=533;

  I4JAnalL.Visible:=(Not (DocHed In [JPT]));
  I4JobAnalF.Visible:=I4JAnalL.Visible;

  If (Not I4JAnalL.Visible) then
  Begin
    J1BasisF.Left:=I4JAnalL.Left;

    SeriesF.Visible:=(DocHed<>JST);
    Label83.Visible:=SeriesF.Visible;
  end
  else
    If (DocHed In [JSA,JST]) then
      I4JAnalL.Caption:='JST'
    else
      If (DocHed=JCT) then
        I4JAnalL.Caption:='JPT';

  If (DocHed In [JPT,JST]) then
    A1JSTFBudgetcb.Visible:=BOn
  else
    If (DocHed In [JSA]) then
    Begin
      A1UseValcb.Visible:=BOn;
      A1UseValcb.Top:=A1ValueBasis.Top;
    end;

  For n:=0 to PageControl1.PageCount-1 do {Hide Tabs}
  With PageControl1 do
  Begin
    If (Assigned(Pages[n])) then
    Begin
      Pages[n].TabVisible:=BOff;
      Pages[n].Visible:=BOn;
    end;

  end; {Loop}

  If (wJCode<>'') and (JTMode=1) then
  Begin
    JCodeF.Text:=wJCode;

    With JCodeF do
    Begin
      TabStop:=BOff;
      ReadOnly:=BOn;
      Color:=clBtnFace;
    end;

    If Global_GetMainRec(JobF,wJCode) then
    With JobRec^ do
    Begin
      JDeF.Text:=JobDesc;

      If (DocHed=JCT) then
        JRef:=JPTOurRef
      else
        If (DocHed In [JSA,JST]) then
        Begin
          JRef:=JSTOurRef;
        end;

      A1JSTFBudgetcb.Enabled:=BOn;

      If (JRef<>'') then
      Begin
        I4JobAnalF.Text:=JRef;

        I4JobAnalFExit(I4JobAnalF);

        BasisSet:=BOn;
      end;

    end;
  end;

  If (DocHed In [JSA,JPA]) then
  Begin
    Set_DefaultJARet(J1BASISF.ITems,BOn,BOff);

    J1BASISF.ItemIndex:=1;
  end
  else
  Begin
    With J1BASISF do
    Begin
      Items.Clear;
      Items.Add('Incremental');
      Items.Add('Gross Incremntl');
      Items.Add('Gross');
    end;

    {Label87.Visible:=BOff;

    PCurrF.Visible:=BOff;}

    Label87.Caption:='Currency';

    PQuotF.Visible:=BOff;

    If (Not BasisSet) then
      J1BASISF.ItemIndex:=0
    else
      I4JobAnalFExit(I4JobAnalF);


    A1ValueBasis.Visible:=BOn;
    A1ValueBasis.ItemIndex:=0;
  end;

  If (JTMode=2) then
  Begin
    I4JobAnalF.Text:=LocalInv^.OurRef;
    I4JobAnalFExit(I4JobAnalF);
  end;


  {If (JTMode=0) then
    Self.ActiveControl:=JCodeF
  else}
    Self.ActiveControl:=I4JobAnalF;

  JustCreated:=BOff;

  SetWizHelp;
end;

procedure TJobAppWizard.FormDestroy(Sender: TObject);
begin
  inherited;

  ExLocal.Destroy;

  JPAWActive:=BOff;

end;


procedure TJobAppWizard.Form2Wizard;

Begin
  With JAppWizRec do
  Begin
    awJobCode:=JCodeF.Text;
    awJCTRef:=I4JobAnalF.Text;
    awDate:=A1StartDF.DateValue;
    awPCurr:=Succ(PCurrF.ItemIndex);
    awPrice:=Round_Up(PQuotF.Value,2);

    If (J1BasisF.ItemIndex>=0) then
      awBasis:=J1BasisF.ItemIndex;

    awDT:=DocHed;
    awACode:=AccCode;

    If (A1ValueBasis.ItemIndex>=0) then
      awCopyBudget:=A1ValueBasis.ItemIndex;

    awJSTFromBudget:=A1JSTFBudgetcb.Checked;
    awJSAFromVal:=A1UseValcb.Checked;
    
    awSeries:=Trunc(SeriesF.Value);
  end;
end;

Function TJobAppWizard.CheckCompleted(Edit,MainChk  :  Boolean)  : Boolean;

Const
  NofMsgs      =  6;

Type
  PossMsgType  = Array[1..NofMsgs] of Str255;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  Test     :  Byte;

  FoundCode:  Str20;

  Loop,
  ShowMsg  :  Boolean;

  mbRet    :  Word;

  MaxBuild,
  FoundLong
           :  LongInt;

  GenStr   :  Str255;


Begin
  New(PossMsg);


  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:=' is not a valid Job code.';
  PossMsg^[2]:=' is not a valid transaction reference';
  PossMsg^[3]:=' does not belong to this employee';
  PossMsg^[4]:='The application basis is not valid because previous applications for more advanced (Practical/Final) stages have already been generated';
  PossMsg^[5]:='Warn no parent';
  PossMsg^[6]:='You must complete either the job code or base the application on a templete contract terms.';


  Loop:=BOff;

  Test:=1;

  Result:=BOn;

  MaxBuild:=0;

  While (Test<=NofMsgs) and (Result) do
  With JAppWizRec do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=(Trim(awJobCode)='');

              If (Not Result) then
              Begin
                Result:=Global_GetMainRec(JobF,awJobCode);
              end;

              ExtraMsg:=Trim(awJobCode);


            end;

      2  :  Begin
              Result:=(Trim(awJCTRef)='');

              GenStr:=awJCTRef;

              If (Not Result) then
              Begin
                Result:=(Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,GenStr)=0);

                If (Result) then
                Begin
                  ExLocal.AssignFromGlobal(InvF);
                  
                  Result:=Valid_TempType(Inv.InvDocHed);

                  JAppWizRec.awDoc:=Inv;

                end;

                If (Result) and (JTMode=1) and (JobRec^.JPTOurRef<>'') and (DocHed=JCT) then
                  Result:=(awJCTRef=JobRec^.JPTOurRef)
                else
                  If (Result) and (JTMode=1) and (JobRec^.JSTOurRef<>'') and (DocHed=JST) then
                    Result:=(awJCTRef=JobRec^.JSTOurRef);

              end;

              ExtraMsg:=Trim(awJCTRef);


            end;


      3  :  Begin
              Result:=(Trim(awACode)='') or (Trim(awJCTRef)='');

              If (Not Result) then
              Begin
                Case awDT of
                  JST,JSA  :  Result:=(Trim(awACode)=Trim(Inv.CustCode));
                  JCT      :  Result:=(Copy(awJCTRef,1,3)=DocCodes[JPT]);
                  else        Result:=(Trim(awACode)=Trim(Inv.CISEmpl));
                end; {Case..}
              end;

              ExtraMsg:=Trim(awJCTRef);


            end;

      4  :  Begin {New app must be on a basis equal or greater then its template part}
              Result:=(Not (awDT in [JPA,JSA])) or (awJCTRef='') or (Not (awDoc.InvDocHed In [JCT,JST]));

              If (Not Result) then
              Begin
                Result:=(awBasis>=awDoc.TransNat);

              end;
            end;

      5  :  With JAppWizRec do
            Begin
              If (awDT In JAPJAPSplit) and (awJCTRef='') and (Not awWarned) then
              Begin
                ShowMsg:=BOff;

                awWarned:=BOn;

                Result:=(CustomDlg(Self,'Please note!','Stand alone creation',
                           'If you create this '+DocNames[awDT]+' as a stand alone transaction,'+
                           ' no cumulative values will be recorded for it.'+#13+#13+
                           'If you require cumulative values to be recorded then base this transaction on a '+I4JAnalL.Caption,
                           mtConfirmation,
                           [mbOk,mbCancel])=mrOk);


              end;
            end;

      6  :  With JAppWizRec do
            Begin
              {Check based on job or temepelte }
              Result:=(Not (awDT in [JPA,JSA])) or (awJCTRef<>'') or (awJobCode<>'');

            end;



    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}

Function TJobAppWizard.GetPageCount  :  Integer;
Begin
  Result:=1;

end;


Function TJobAppWizard.GetEndPageCount  :  Integer;
Begin
  Result:=1;

end;

{ ======= Link to Trans display ======== }

procedure TJobAppWizard.Display_GlobalTrans(Mode  :  Byte);

Var
  KeyS  :  Str255;
Begin

  ExLocal.LastInv:=ExLocal.LInv;

  With TFInvDisplay.Create(Self.Owner) do
  Begin
    ExLocal.AssignToGlobal(InvF);
    try

      KeyS:=ExLocal.LInv.OurRef;

      With ExLocal do
      If (Find_Rec(B_GetEq,F[InvF],InvF,LRecPtr[InvF]^,InvOurRefK,KeyS)=0) then
      Begin

        LastDocHed:=LInv.InvDocHed;

        Display_Trans(Mode,0,BOff,BOn);

      end; {with..}

    except

      Free;

    end;
  end;

  ExLocal.LInv:=ExLocal.LastInv;
end;

procedure TJobAppWizard.TryFinishWizard;

Var
  SuppOk  :  Boolean;

Begin
  Form2Wizard;

  SuppOk:=CheckCompleted(BOff,BOff);


  If (SuppOk) then
  Begin
    {Create J?A}

    LastValueObj.UpdateAllLastValues(Self);

    Self.Enabled:=BOff;

    Generate_JAFromJT(ord(JAppWizRec.awJCTRef=''),JAppWizRec,ExLocal);


    Display_GlobalTrans(2);

    PostMessage(TForm(Self.Owner).Handle,WM_CustGetRec,108,0);

    PostMessage(Self.Handle,WM_Close,0,0);
  end;
end;

Function TJobAppWizard.wLink_To_Job(JC  :  Str10)  :  Boolean;

Begin
  Result:=(Global_GetMainRec(JobF,JC));

end;

procedure TJobAppWizard.SetJSTcb(Sender: TObject);

Begin
  If (DocHed In [JPT,JST]) then
  Begin
    A1JSTFBudgetcb.Enabled:=(JCodeF.Text<>'') and (I4JobAnalF.Text='');

    If (Not A1JSTFBudgetcb.Enabled) then
      A1JSTFBudgetcb.Checked:=BOff;
  end;

end;

procedure TJobAppWizard.JCodeFExit(Sender: TObject);
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

      FoundCode:=Trim(Text);

      If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>TWClsBtn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJob(Self,FoundCode,FoundCode,5));

        If (FoundOk) then {* Credit Check *}
        Begin

          Text:=FoundCode;

          JDeF.Text:=JobRec.JobDesc;

        end
        else
        Begin

          SetFocus;
        end; {If not found..}

      end;

      If (ActiveControl<>TWClsBtn) then
        SetJSTcb(Sender);

    end;
  {$ENDIF}
end;


procedure TJobAppWizard.A1UseValcbClick(Sender: TObject);
begin
  inherited;

  If (A1UseValcb.Checked) then
  Begin
    Form2Wizard;

    If CheckCompleted(BOff,BOff) then
      PQuotF.Value:=Calc_ValuationValue(JAppWizRec,ExLocal)
    else
      A1UseValcb.Checked:=BOff;

  end;

end;

Function TJobAppWizard.Valid_TempType(DT  :  DocTypes)  :  Boolean;

Begin
  Case DocHed of
    JCT  :  Result:=(DT = JPT);
    JPA  :  Result:=(DT In [JPT,JCT]);
    JSA,
    JST  :  Result:=(DT In [JST]);
    else    Result:=BOff;
  end; {Case..}


end;

procedure TJobAppWizard.I4JobAnalFExit(Sender: TObject);
Const
  Fnum     =   InvF;

  Keypath  =   InvOurRefK;

Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  GenStr     :  Str255;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified or JustCreated;

    FoundCode:=Trim(Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>TWClsBtn) then
    Begin

      StillEdit:=BOn;

      FoundCode:=AutoSetInvKey(Text,0);

      GenStr:=FoundCode;

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,GenStr);

      FoundOk:=(StatusOk and (Inv.InvDocHed In JAPSplit-[JPA,JSA]));

      If (FoundOk) then
        FoundOk:=Valid_TempType(Inv.InvDocHed);

      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;

        JCodeF.Text:=Inv.DJobCode;

        If (wLink_To_Job(Inv.DJobCode)) then
          JDeF.Text:=JobRec.JobDesc;

        {$IFDEF MC_On}
          PCurrF.ItemIndex:=Pred(Inv.Currency);
        {$ENDIF}

        If (Inv.NoLabels>0) then
          SeriesF.Value:=Inv.NoLabels
        else
          SeriesF.Value:=1.0;
        
        JAppWizRec.awDoc:=Inv;

        If (DocHed in JapJapSplit) and (Inv.TransNat<=3) and (Inv.TransNat>1) then
          J1BasisF.ItemIndex:=Inv.TransNat
        else
          If (DocHed In [JCT,JST]) then
            J1BasisF.ItemIndex:=Inv.TransMode;
      end
      else
      Begin
        If (CanFocus) then
          SetFocus;
      end; {If not found..}

      A1ValueBasis.TabStop:=FoundOk;
      A1ValueBasis.ReadOnly:=Not FoundOk;
    end;

    If (ActiveControl<>TWClsBtn) then
      SetJSTcb(Sender);

  end; {with..}
end;


procedure TJobAppWizard.SetWizHelp;

Begin
  Case DocHed of
    JCT  :  Begin
              J1BasisF.HelpContext:=1510;
              TWNextBtn.HelpContext:=1524;
              Self.HelpContext:=1523;
            end;
    JPA,
    JSA  :  Begin
              J1BasisF.HelpContext:=1530;
              TWNextBtn.HelpContext:=1529;

              If (DocHed=JSA) then
                Self.HelpContext:=1551
              else
                Self.HelpContext:=1552;

            end;

  end; {Case..}
end;


Initialization
  LocalInv:=Nil;
  LocalId:=Nil;
  JPAWizard:=Nil;
  JPAWActive:=BOff;

  LocalJCTAddr:=0;
  LocalAc:='';
  LocalJob:='';

Finalization
  If (Assigned(LocalInv)) then
    Dispose(LocalInv);

  If (Assigned(LocalId)) then
    Dispose(LocalId);


end.
