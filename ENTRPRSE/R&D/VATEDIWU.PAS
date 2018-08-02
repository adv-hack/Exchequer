unit VATEDIWU;

{$I DEFOVR.Inc}

{$WARN UNIT_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Wiztempu, StdCtrls, TEditVal, TCustom, ExtCtrls, SBSPanel, ComCtrls, Mask,
  GlobVar,BorBtns, FileCtrl,
  VarRec2U,BTSupU3;

type
  TVATEDIWizard = class(TWizTemplate)
    Label82: Label8;
    I1TransDateF: TEditDate;
    Label87: Label8;
    I2TransDateF: TEditDate;
    Label85: Label8;
    I1PrYrF: TEditPeriod;
    Label83: Label8;
    TestModeChk: TBorCheck;
    CRLFChk: TBorCheck;
    OutputCB: TSBSComboBox;
    Label84: Label8;
    EDIFACTFCB: TSBSComboBox;
    Label88: Label8;
    Label89: Label8;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Label810: Label8;
    Label811: Label8;
    EDINWCB: TSBSComboBox;
    Label812: Label8;
    EDICEIdF: Text8Pt;
    EDITIdF: Text8Pt;
    Label813: Label8;
    Label814: Label8;
    EDICEMF: Text8Pt;
    EDIYEMF: Text8Pt;
    EDIEMPF: TSBSComboBox;
    Label815: Label8;
    Label816: Label8;
    Label817: Label8;
    DirLB1: TDirectoryListBox;
    DriveCB1: TDriveComboBox;
    DirPath: Text8Pt;
    CompressChk: TBorCheck;
    SendEBC: TBorCheck;
    Label818: Label8;
    ECIEPF: Text8Pt;
    Image2: TImage;
    lblStatsValueReqd: Label8;
    cbStatsValueReqd: TSBSComboBox;
    procedure FormCreate(Sender: TObject);
    procedure DirLB1Change(Sender: TObject);
    procedure TWPrevBtnClick(Sender: TObject);
    procedure OutputCBChange(Sender: TObject);
    procedure EDINWCBChange(Sender: TObject);
    procedure DirPathExit(Sender: TObject);
    procedure DriveCB1Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure I1TransDateFExit(Sender: TObject);
    procedure I2TransDateFExit(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ECIEPFExit(Sender: TObject);
  private
    { Private declarations }

    InOutPut   :       Boolean;

    TotPages,
    NowPage    :       Integer;

    PopDir     :       String;

    Stations   :  Array[0..3] of Boolean;

    IRVInp     :  IRVInpType;

    CRepParam  :  CVATRepPtr;

    procedure SetWizardCaption;

    Procedure Get_ECSuggest(LastDate  :  LongDate;
                        Var StartDate,
                            EndDate   :  LongDate);

    procedure OutWizard;

    procedure Form2Wizard;

    procedure ApplyModes;

    procedure SetHelpContextIDs; // NF: 11/05/06

  public
    { Public declarations }
    WizMode  :  Byte;

    procedure SetStepCaption; Override;

    procedure TryFinishWizard; Override;

  end;


Var
  VEDIMode  :  Byte;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  StrUtils,
  ETStrU,
  ETMiscU,
  ETDateU,
  VarConst,
  BTSupU1,
  SysU1,

   {$IFDEF Rp}
     VATEDITU,
   {$ENDIF}

   ReportAU,

  RepInpVU,
  ExThrd2U,
  ExpVED2U;


{$R *.DFM}


{ ========= Calculate next EC Suggested sales Range ========= }

Procedure TVATEDIWizard.Get_ECSuggest(LastDate  :  LongDate;
                                  Var StartDate,
                                      EndDate   :  LongDate);



Var

  Ld,Lm,Ly  :  Word;

Begin

  DateStr(LastDate,Ld,Lm,Ly);

  AdjMnth(Lm,Ly,1);

  Ld:=01;

  StartDate:=StrDate(Ly,Lm,Ld);

  AdjMnth(Lm,Ly,2);

  Ld:=Monthdays[Lm];

  EndDate:=StrDate(Ly,Lm,Ld);

end; {Proc..}



procedure TVATEDIWizard.FormCreate(Sender: TObject);

Var
  Locked             :  Boolean;

  VYr,VPr
                     :  Byte;

  CVYr,CVPr,NYear,n  :  Integer;

  BMap1              :  TBitMap;

  RectD              :  TRect;


begin
  inherited;

  If (CurrentCountry=IECCode) Then
    Caption:=CCVATName^+' XML Wizard.'
  Else
    Caption:=CCVATName^+' EDI Wizard.';

  Label86.Caption:=Caption;

  WizMode:=VEDIMode;

  Blank(IRVInp,Sizeof(IRVInp));

  {$I-}

    Try
      GetDir(0,PopDir);

      If (IOResult=0) then;

    except;
      PopDir:=SetDrive;

    end;

  {$I+}

  InOutPut:=BOff;

  FillChar(Stations,Sizeof(Stations),0);

  Stations[0]:=BOn;
  Stations[3]:=BOn;

  TotPages:=2;
  NowPage:=1;

  New(Self.CRepParam);

  try
    With Self.CRepParam^ do
    Begin
      FillChar(Self.CRepParam^,Sizeof(Self.CRepParam^),0);

      VATStartD:=Today; VatEndD:=Today;

    end;
  except
    Dispose(Self.CRepParam);
    Self.CRepParam:=nil;
  end;



  Case WizMode of

    0   : Begin
            Label85.Visible:=BOff;
            I1PrYrF.Visible:=BOff;

            EDIFACTFCB.ItemIndex:=0;
            EDIFACTFCB.Visible:=BOff;
            Label88.Visible:=BOff;

            Self.ActiveControl:=I1TransDateF;


          end;

    1,2
       :  Begin
            Label82.Visible:=BOff;
            I1TransDateF.Visible:=BOff;
            I2TransDateF.Visible:=BOff;

            Label87.Visible:=BOff;

            Self.ActiveControl:=I1PrYrF;
          end;


  end; {Case..}


  If (CurrentCountry=IECCode) then
  Begin
    OutPutCB.ItemIndex:=0;
    OutPutCB.Enabled:=BOff;
    EDIFACTFCB.ItemIndex:=1;
    EDIFACTFCB.Enabled:=BOff;
    ECIEPF.Visible:=(WizMode=0);
    Label818.Visible:=(WizMode=0);

    TestModeChk.Visible:=BOff;  CRLFChk.Visible:=BOff;
    Label88.Visible:=BOff;
    EDIFACTFCB.Visible:=BOff;

    If (Get_LastIRVVal(FullIRVFile(AllocTCode,AllocSCode,2),IRVInp)) then
      ECIEPF.Text:=IRVInp.VIESType;

    // MH 04/04/2012 v6.10.1 ABSEXCH-12554: Added Statistical Value Required field
    If (WizMode In [1, 2]) Then
    Begin
      // Arrivals/Despatches Export

      // Hide irrelevant options
      Label84.Visible := False;
      OutputCB.Visible := False;

      // Reposition controls to correct location
      lblStatsValueReqd.Top := Label85.Top + I1PrYrF.Height + 5;
      lblStatsValueReqd.Visible := True;

      cbStatsValueReqd.Top := I1PrYrF.Top + I1PrYrF.Height + 5;
      cbStatsValueReqd.Visible := True;
    End; // If (WizMode In [1, 2])
  end;

  SetWizardCaption;

  Locked:=BOff;

  GetMultiSys(BOff,Locked,EDI1R);

  With CRepParam^ do
  Case WizMode of

    0  :  Begin

            Get_ECSuggest(SyssVAT.VATRates.LastECSalesDate,VATStartD,VATEndD);

            I1TransDateF.DateValue:=VATStartD;
            I2TransDateF.DateValue:=VATEndD;


          end;

    1,2
       :  Begin
            VATEndD:=SyssVat.VATRates.CurrPeriod;

            NYear:=Part_Date('Y',VATEndd);

            VPr:=Part_Date('M',VATEndd);

            CVYr:=NYear; CVPr:=VPr;

            VYr:=TxlateYrVal(NYear,BOn);

            I1PrYrF.InitPeriod(VPr,VYr,BOn,BOn);

            I1PrYrF.PeriodsInYear:=12;

          end;

  end; {Case..}


  If Not NoXLogo then
  Begin
    BMap1:=TBitMap.Create;

    BMap1.Handle:=LoadBitMap(HInstance,'B2BTICK');

    With BMap1 do
      RectD:=Rect(0,0,Width,Height);


    With Image2.Picture.Bitmap do
    Begin
      Width:=BMap1.Width;
      Height:=BMap1.Height;

      Canvas.Brush.Color:=clBtnFace;
      Canvas.BrushCopy(RectD,BMap1,RectD,clFuchsia);
    end;

    BMap1.Free;
  end;

  OutWizard;

  SetStepCaption;

  SetHelpContextIDs; // NF: 11/05/06 Fix for incorrect Context IDs
end;


procedure TVATEDIWizard.FormDestroy(Sender: TObject);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;



procedure TVATEDIWizard.SetWizardCaption;
Var
  VEDITitle  :  Array[0..2] of Str50;
  EDIWord : String[3];
Begin
  EDIWord := IfThen(CurrentCountry=IECCode, 'XML', 'EDI');

  VEDITitle[0] := IfThen(CurrentCountry=IECCode, 'VIES Statement', 'EC Sales List');
  VEDITitle[1] := 'SSD Dispatches';
  VEDITitle[2] := 'SSD Arrivals';


  Label83.Caption:='The '+CCVATName^+' ' + EDIWord + ' wizard will guide you through the creation of the '+VEDITitle[VEDIMode]+
                   ' submission file.'+#13+'The details below indicate the type of file you wish to produce, and how '+
                   'you intend to send it.';

  Label89.Caption:='You have selected to send your '+VEDITitle[VEDIMode]+' submission file via EDI.'+#13+
                   'You must now choose which Value Added Network (VAN) you are using, and your identity code '+
                   'on that network.  The Customs identity code will be provided automatically.';

  Label810.Caption:='You have selected to send your '+VEDITitle[VEDIMode]+' submission file via Internet Email.'+#13+
                   'You must now supply your return email address, and confirm the suggested Customs email address.';

  Label811.Caption:='Please choose the directory path where you want the submission file to be placed.';

  CRepParam^.EDIHedTit:=VEDITitle[VEDIMode];
end;


procedure TVATEDIWizard.DirLB1Change(Sender: TObject);
begin
  inherited;
  DirPath.Text:=DirLB1.Directory;
end;


procedure TVATEDIWizard.OutWizard;

Var
  Locked    :  Boolean;
  TmpDrive  :  String;

Begin
  Locked:=BOff;

  If (Not InOutPut) then
  With SyssEDI1^.EDI1Value do
  Begin
    InOutPut:=BOn;

    TestModeChk.Checked:=VTestMode;
    CRLFChk.Checked:=VUseCRLF;

    OutPutCB.ITemIndex:=VEDIMethod;

    If (CurrentCountry<>IECCode) then
    Begin
      If (WizMode=0) then
        EDIFACTFCB.ItemIndex:=0  {* Force Instat.. *}
      else
        EDIFACTFCB.ItemIndex:=VEDIFACT;
    end;

    EDINWCB.ItemIndex:=VVANMode;
    EDICEIdF.Text:=VVANCEId;
    EDITIdF.Text:=VVANUId;

    If (VUEMail='') then {Get defaults}
    With SyssEDI2^.EDI2Value do
    Begin
      If GetMultiSys(BOff,Locked,EDI2R) then
      Begin
        VUEMail:=EmAddress;
        VEPriority:=EmPriority;
      end;
    end;

    EDIEMPF.ItemIndex:=VEPriority;
    EDICEMF.Text:=VCEEmail;
    EDIYEMF.Text:=VUEMail;

    If (DirectoryExists(VDirPath)) then
    Begin
      DirPath.Text:=VDirPath;
      TmpDrive:=ExtractFileDrive(VDirPath);

      If (TmpDrive[1] In ['A'..'Z']) then
        DriveCB1.Drive:=TmpDrive[1];

      DirLB1.Directory:=BuildPath(VDirPath);
    end;

    SendEBC.Checked:=VSendEmail;

    CompressChk.Checked:=VCompress;


    OutputCBChange(Nil);

    InOutPut:=BOff;
  end;

  ApplyModes;
end;


procedure TVATEDIWizard.Form2Wizard;

Var
  VYr,VPr
                     :  Byte;

  CVYr,CVPr,NYear,n  :  Integer;

Begin
  With SyssEDI1^.EDI1Value, CRepParam^ do
  Begin
    Case WizMode of

      0  :  Begin
              VATChk:=#0;

              VATStartD:=I1TransDateF.DateValue;
              VATEndD:=I2TransDateF.DateValue;

              VIEECSLP:=ECIEPF.Text;

            end;

      1,2
         :  Begin
              I1PrYrF.InitPeriod(VPr,VYr,BOff,BOff);

              NYear:=ConvTxYrVal(VYr,BOff);

              VatStartD:=StrDate(NYear,VPr,01);

              VATEndD:=StrDate(NYear,VPr,MonthDays[VPr]);

              Case WizMode of
                1  :  VATChk:=VATECDCode;
                2  :  VATChk:=VATEECCode;
              end;



            end;

    end; {Case..}


    VTestMode:=TestModeChk.Checked;
    VUseCRLF:=CRLFChk.Checked;

    If (OutPutCB.ITemIndex<>-1) then
      VEDIMethod:=OutPutCB.ITemIndex;


    If (EDIFACTFCB.ItemIndex<>-1) then
      VEDIFACT:=EDIFACTFCB.ItemIndex;

    If (EDINWCB.ItemIndex<>-1) then
      VVANMode:=EDINWCB.ItemIndex;


    VVANCEId:=UpCaseStr(EDICEIdF.Text);

    VVANUId:=UpCaseStr(EDITIdF.Text);
    VEPriority:=EDIEMPF.ItemIndex;

    VCEEmail:=UpCaseStr(EDICEMF.Text);

    VUEMail:=UpCaseStr(EDIYEMF.Text);

    VDirPath:=DirPath.Text;

    VCompress:=CompressChk.Checked;

    VSendEmail:=SendEBC.Checked;

  end; {With..}


end;



procedure TVATEDIWizard.ApplyModes;


Var
  n  :  Byte;

Begin
  If (OutPutCB.ItemIndex=1) then
  Begin
    CompressChk.Checked:=BOff;
    CompressChk.Visible:=BOff;
  end
  else
    CompressChk.Visible:=(CurrentCountry<>IECCode);

  If (OutPutCB.ItemIndex=2) and (EDICEMF.Text='') then
    EDICEMF.Text:='edcs@edcsdata.hmce.gov.uk';


  Stations[1]:=(OutPutCB.ItemIndex=1);
  Stations[2]:=(OutPutCB.ItemIndex=2);

  TotPages:=0;
  For n:=Low(Stations) to High(Stations) do
  Begin
    TotPages:=TotPages+Ord(Stations[n]);
  end;
end;


procedure TVATEDIWizard.SetStepCaption;


Begin
  Label81.Caption:='Step '+IntToStr(NowPage)+' of '+IntToStr(TotPages);
end;

procedure TVATEDIWizard.TWPrevBtnClick(Sender: TObject);

Var
  Dir, Continue         :  Boolean;
  ThisPage,
  ICnt,DCnst  :  Integer;

begin
  // MH 04/04/2012 v6.10.1 ABSEXCH-12554: Added Statistical Value Required field
  If (Sender = TWNextBtn) And (PageControl1.ActivePage = TabSheet1) And cbStatsValueReqd.Visible Then
  Begin
    // Force acceptable value of Stats Value Required before allowing them to move to the next page
    Continue := (cbStatsValueReqd.ItemIndex >= 0);
    If (Not Continue) Then
    Begin
      MessageDlg ('The Stats Value Required field must be set before you can continue', mtError, [mbOK], 0);
    End; // If (Not Continue)
  End // If If (Sender = TWNextBtn) And (PageControl1.ActivePage = TabSheet1) And cbStatsValueReqd.Visible
  Else
    Continue := True;

  If Continue Then
  Begin
    Dir:=(Sender=TWNextBtn);

    ThisPage:=Current_Page;

    If (Dir) then
      DCnst:=1
    else
      DCnst:=-1;

    If ((ThisPage<3) and (Dir)) or ((ThisPage>0) and (Not Dir)) then
    Begin
      ICnt:=ThisPage;

      Repeat
        ICnt:=ICnt+DCnst;

        If (Not Stations[ICnt]) then
          Inc(AdvancePages);


      Until (ICnt In [0,3]) or (Stations[ICnt]);
    end;

    NowPage:=NowPage+DCnst;

    inherited;

    AdvancePages:=0;

    If (Current_Page=3) and (DirPath.Text='') then
      DirPath.Text:=DirLB1.Directory;

    SetStepCaption;
  End; // If Continue
end;

procedure TVATEDIWizard.I1TransDateFExit(Sender: TObject);
Var
  AltMod  :  Boolean;
  PM,PY   :  Word;

begin
  inherited;

  If (Sender is TEditDate) then
    With (Sender as TEditDate) do
    Begin
      AltMod:=Modified;

      If (AltMod) and (ActiveControl<>TWClsBtn) and (ValidDate(DateValue)) then
      Begin
        PM:=Part_Date('M',DateValue);
        PY:=Part_Date('Y',DateValue);

        AdjMnth(PM,PY,3);

        I2TransDateF.DateValue:=StrDate(PY,PM,MonthDays[PM]);
      end;
    end; {With..}

end;


procedure TVATEDIWizard.I2TransDateFExit(Sender: TObject);
begin
  inherited;
  If (I2TransDateF.DateValue<I1TransDateF.DateValue) then
    I2TransDateF.DateValue:=I2TransDateF.DateValue;
end;


procedure TVATEDIWizard.ECIEPFExit(Sender: TObject);
begin
  inherited;
  With ECIEPF do
  Begin
    If (Text<>'M') and (Text<>'Q') and (Text<>'A1') and (Text<>'A2') then
    Begin
      ShowMessage('The period must be M,Q,A1, or A2');

      SetFocus;
    end;

  end;

end;


procedure TVATEDIWizard.OutputCBChange(Sender: TObject);
begin
  inherited;

  EDINWCBChange(Sender);

  If (Assigned(Sender)) then
    Form2Wizard;

  With SyssEDI1^.EDI1Value do
    If (VEDIMethod<>1) then
      VVANUId:=Copy(UpCaseStr(VEDIFmtStr(Syss.UserName)),1,35)
    else
      If (VEDIMethod=1) then
      Begin
        VCompress:=BOff;
      end;

  OutWizard;
end;

procedure TVATEDIWizard.EDINWCBChange(Sender: TObject);
begin
  inherited;

  If (Assigned(Sender)) then
    Form2Wizard;

  With SyssEDI1^.EDI1Value do
    EDICEIDF.Text:=VEDIMethodID(VEDIMethod,VVanMode);

end;

procedure TVATEDIWizard.DirPathExit(Sender: TObject);
begin
  inherited;

  With DirPath do
  If (DirectoryExists(Text)) then
  Begin
    DirLB1.Directory:=Text;

  end
  else
  Begin
    Set_BackThreadMVisible(BOn);

    ShowMEssage(Text+' is not a valid directory!');

    Set_BackThreadMVisible(BOff);

    If (CanFocus) then
      SetFocus

  end;

end;

procedure TVATEDIWizard.DriveCB1Change(Sender: TObject);
begin
  inherited;

  Try

   DirLB1.Drive:=DriveCB1.Drive;

  Except
    Set_BackThreadMVisible(BOn);

    ShowMessage('Drive '+DriveCB1.Drive+': is not a valid drive!');

    Set_BackThreadMVisible(BOff);

  end;
end;

procedure TVATEDIWizard.TryFinishWizard;

Var
  Locked,
  Ok2Cont  :  Boolean;
  mbRet    :  Word;

  ThisEDI  :   EDI1Rec;
  AlreadyExists: Boolean;
  Filename: string;

Begin
  Form2Wizard;

  Ok2Cont:=BOn;

  With SyssEDI1^.EDI1Value do
  Begin
    If (DirectoryExists(VDirPath)) then
    Begin

      AlreadyExists := False;
      if (WizMode in [0, EC_SALES_EXPORT_MODE]) then
        Filename := BuildPath(VDirPath) +
                    'E' + Copy(I2TransDateF.DateValue, 1, 6) + '.xml'
      else
        Filename := BuildPath(VDirPath) + EDIFName(VTestMode, WizMode);

      If FileExists(Filename) then
      Begin
        Set_BackThreadMVisible(BOn);

//        mbRet:=MessageDlg(EDIFName(VTestMode,WizMode)+' already exists in that directory. Overwrite?',mtConfirmation,[mbYes,mbNo],0);
        mbRet:=MessageDlg(Filename + ' already exists in that directory. Overwrite?',mtConfirmation,[mbYes,mbNo],0);

        Set_BackThreadMVisible(BOff);

        OK2Cont:=(mbRet=mrYes);

      end;
    end
    else
    Begin
      Set_BackThreadMVisible(BOn);

      ShowMEssage(Text+' is not a valid directory!');

      Set_BackThreadMVisible(BOff);

      Ok2Cont:=BOff;
    end;

    If (Ok2Cont) then {* Start thread.?}
    Begin
      If (Syss.UserVATReg<>'') and ((Syss.UserVATReg[1] In ['A'..'Z']) and (Syss.UserVATReg[2] In ['A'..'Z'])) then
      Begin
        {* VAT Reg ok!*}

      end
      else
        Begin
          Ok2Cont:=BOff;

          Set_BackThreadMVisible(BOn);

          ShowMEssage('Your Company '+CCVATName^+' Reg No. is not valid! Please correct.');

          Set_BackThreadMVisible(BOff);

        end;

      With CRepParam^ do
        If (Ok2Cont) and (OutPutCB.ItemIndex=2) and ((VUEmail='') or (VCEEmail='')) then
        Begin
          Ok2Cont:=BOff;

          Set_BackThreadMVisible(BOn);

          ShowMessage('The email address is not valid.  Please correct.');

          Set_BackThreadMVisible(BOff);

        end;


      If (Ok2Cont) then
      Begin
        Locked:=BOn;

        ThisEDI:=SyssEDI1^;

        GetMultiSys(BOn,Locked,EDI1R);


        If (CurrentCountry=IECCode) then
        Begin
          IRVInp.VIESType:=VIEECSLP;

          Put_LastIRVVal(AllocSCode,IRVInp,2);
        end;


        If (GetMultiSys(BOn,Locked,EDI1R)) and (Locked) then
        Begin
          SyssEDI1^:=ThisEDI;

          PutMultiSys(EDI1R,BOn);

        end;

        {* Start thread *}

        {$I-}
          Try
            ChDir(PopDir);


          except;
            ChDir(SetDrive);
          end;

          If (IOResult=0) then;

        {$I+}

        {$IFDEF Rp}
            If (CurrentCountry<>IECCode) then
              AddVATEDI2Thread(Application.MainForm,WizMode,CRepParam)
            else
              // MH 04/04/2012 v6.10.1 ABSEXCH-12554: Passed Statistical Value Required field into XML export
              AddVATXML2Thread(Application.MainForm,WizMode,CRepParam, (cbStatsValueReqd.ItemIndex = 0));
        {$ENDIF}

        Close;
      end;
    end;


  end; {With..}

end;






procedure TVATEDIWizard.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;

  {$I-}
    Try
      ChDir(PopDir);


    except;
      ChDir(SetDrive);
    end;

    If (IOResult=0) then;

  {$I+}

end;

// NF: 11/05/06 Fix for incorrect Context IDs
procedure TVATEDIWizard.SetHelpContextIDs;
begin
  TWClsBtn.HelpContext := 1750;
end;

Initialization

  VEDIMode:=0;

end.
