unit CISEDIWU;

{$I DEFOVR.Inc}

{$WARN UNIT_PLATFORM OFF}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Wiztempu, StdCtrls, TEditVal, TCustom, ExtCtrls, SBSPanel, ComCtrls, Mask,
  GlobVar,BorBtns, FileCtrl,
  VarRec2U,BTSupU3;

type
  TCISEDIWizard = class(TWizTemplate)
    Label82: Label8;
    I1TransDateF: TEditDate;
    Label87: Label8;
    I2TransDateF: TEditDate;
    Label83: Label8;
    TestModeChk: TBorCheck;
    CRLFChk: TBorCheck;
    OutputCB: TSBSComboBox;
    Label84: Label8;
    Label89: Label8;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Label810: Label8;
    Label811: Label8;
    EDINWCB: TSBSComboBox;
    Label812: Label8;
    EDICEIdF: Text8Pt;
    EDIRPWF: Text8Pt;
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
    SendEBC: TBorCheck;
    Label818: Label8;
    ECIEPF: Text8Pt;
    Image2: TImage;
    Label85: Label8;
    EDITIdF: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure DirLB1Change(Sender: TObject);
    procedure TWPrevBtnClick(Sender: TObject);
    procedure OutputCBChange(Sender: TObject);
    procedure EDINWCBChange(Sender: TObject);
    procedure DirPathExit(Sender: TObject);
    procedure DriveCB1Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }

    InOutPut   :       Boolean;

    TotPages,
    NowPage    :       Integer;

    PopDir     :       String;

    Stations   :  Array[0..3] of Boolean;

    CRepParam  :  JobCRep1Ptr;

    procedure SetWizardCaption;

    procedure OutWizard;

    procedure Form2Wizard;

    procedure ApplyModes;

  public
    { Public declarations }
    WizMode  :  Byte;

    procedure SetStepCaption; Override;

    procedure TryFinishWizard; Override;

  end;


Var
  {EDI wizard mode. 0 = Voucher Run. 2 = EOY}
  CEDIMode  :  Byte;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Math,
  ETStrU,
  ETMiscU,
  ETDateU,
  VarConst,
  BTSupU1,
  SysU1,

   {$IFDEF Rp}
     CISEDITU,
   {$ENDIF}
  IntMU, 
  JChkUseU,
  ExThrd2U,
  ExpVED2U;


{$R *.DFM}




procedure TCISEDIWizard.FormCreate(Sender: TObject);

Var
  Locked             :  Boolean;

  VYr,VPr
                     :  Byte;

  CVYr,CVPr,NYear,n  :  Integer;

  BMap1              :  TBitMap;

  RectD              :  TRect;


begin
  inherited;

  Caption:=CCCISName^+' EDI Wizard.';

  Label86.Caption:=Caption;

  WizMode:=CEDIMode;


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

  
  With OutPutCB do
  Begin
    ItemIndex:=1;
    Enabled:=Debug or SBSIn;
    TabStop:=Debug or SBSIn;
  end;


  EDIEMPF.ItemIndex:=0;


  try
    With Self.CRepParam^ do
    Begin
      FillChar(Self.CRepParam^,Sizeof(Self.CRepParam^),0);

      
    end;
  except
    Dispose(Self.CRepParam);
    Self.CRepParam:=nil;
  end;



  Case WizMode of

    0   : Begin {Two files for taxable and non taxable vouchers}
            Label87.Visible:=BOff;
            I1TransDateF.Visible:=BOff;
            I2TransDateF.Left:=I1TransDateF.Left;

            Self.ActiveControl:=I2TransDateF;


          end;

    2
       :  Begin

          end;


  end; {Case..}


  If (CurrentCountry=IECCode) then
  Begin

  end;

  SetWizardCaption;

  Locked:=BOff;

  GetMultiSys(BOff,Locked,CISR);

  With CRepParam^ do
  Begin
    Case WizMode of

      0  :  Begin

              RepSDate:=SyssCIS^.CISRates.CurrPeriod; RepEDate:=RepSDate;

            end;

      2
         :  Begin
              Calc_CISEOYRange(RepSDate,RepEDate,BOff);

            end;

    end; {Case..}

    I1TransDateF.DateValue:=RepSDate;
    I2TransDateF.DateValue:=RepEDate;

  end; {with..}

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
end;


procedure TCISEDIWizard.FormDestroy(Sender: TObject);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;



procedure TCISEDIWizard.SetWizardCaption;

Const
  VEDITitle  :  Array[0..2] of Str50 = ('Voucher','','End of Year');


Begin
  Label83.Caption:='The '+CCCISName^+' EDI wizard will guide you through the creation of the '+VEDITitle[WizMode]+
                   ' submission file.'+#13+'The details below indicate the type of file you wish to produce, and how '+
                   'you intend to send it.';

  Label89.Caption:='You have selected to send your '+VEDITitle[WizMode]+' submission file via EDI.'+#13+
                   'You must now choose which Value Added Network (VAN) you are using, and your identity code '+
                   'on that network.  The Revenue identity code will be provided automatically.';

  Label810.Caption:='You have selected to send your '+VEDITitle[WizMode]+' submission file via Internet Email.'+#13+
                   'You must now supply your return email address, and confirm the suggested Revenue email address.';

  Label811.Caption:='Please choose the directory path where you want the submission file to be placed.';

  CRepParam^.EDIHedTit:=VEDITitle[WizMode];
end;


procedure TCISEDIWizard.DirLB1Change(Sender: TObject);
begin
  inherited;
  DirPath.Text:=DirLB1.Directory;
end;


procedure TCISEDIWizard.OutWizard;

Var
  Locked    :  Boolean;
  TmpDrive  :  String;

Begin
  Locked:=BOff;

  If (Not InOutPut) then
  With SyssCIS^.CISRates do
  Begin
    InOutPut:=BOn;

    TestModeChk.Checked:=ITestMode;
    CRLFChk.Checked:=IUseCRLF;

    If (Debug or SBSIn) then
      OutPutCB.ITemIndex:=IEDIMethod;

    EDINWCB.ItemIndex:=IVANMode;
    EDICEIdF.Text:=IVANIRId;
    EDITIdF.Text:=IVANUId;
    EDIRPWF.Text:=IVANPW;
    ECIEPF.Text:=IIREDIRef;

    If (OutPutCB.ItemIndex=2) then
    Begin
      EDIYEMF.Text:=IVANUId;;
      EDICEMF.Text:=IVANIRId;;

      If (EDIYEMF.Text='') then
      With SyssEDI2^.EDI2Value do
      Begin
        If GetMultiSys(BOff,Locked,EDI2R) then
        Begin
          EDIYEMF.Text:=EmAddress;
          EDIEMPF.ItemIndex:=EmPriority;
        end;
      end;
    end;

    If (DirectoryExists(IDirPath)) then
    Begin
      DirPath.Text:=IDirPath;
      TmpDrive:=ExtractFileDrive(IDirPath);

      If (TmpDrive[1] In ['A'..'Z']) then
        DriveCB1.Drive:=TmpDrive[1];

      DirLB1.Directory:=BuildPath(IDirPath);
    end;

    SendEBC.Checked:=ISendEmail;


    OutputCBChange(Nil);

    InOutPut:=BOff;
  end;

  ApplyModes;
end;


procedure TCISEDIWizard.Form2Wizard;


Begin
  With SyssCIS^.CISRates, CRepParam^ do
  Begin
    Case WizMode of

      0  :  Begin

              RepEDate:=I2TransDateF.DateValue;
              RepSDate:=RepEDate;
            end;

       2
         :  Begin
              RepSDate:=I1TransDateF.DateValue;

              RepEDate:=I2TransDateF.DateValue;

            end;

    end; {Case..}


    ITestMode:=TestModeChk.Checked;
    IUseCRLF:=CRLFChk.Checked;

    If (OutPutCB.ITemIndex<>-1) and (Debug or SBSIn) then
      IEDIMethod:=OutPutCB.ITemIndex
    else
      IEDIMethod:=1;


    If (EDINWCB.ItemIndex<>-1) then
      IVANMode:=EDINWCB.ItemIndex;

    IIREDIRef:=ECIEPF.Text;

    IVANIRId:=UpCaseStr(EDICEIdF.Text);

    IVANUId:=UpCaseStr(EDITIdF.Text);

    IVANPW:=EDIRPWF.Text;

    If (EDIEMPF.ItemIndex<>-1) then
      IEPriority:=EDIEMPF.ItemIndex;

    If (IEDIMethod=2) then
    Begin
      IVanIRId:=UpCaseStr(EDICEMF.Text);

      IVanUId:=UpCaseStr(EDIYEMF.Text);
    end;

    IDirPath:=DirPath.Text;

    ISendEmail:=SendEBC.Checked;

    RepType:=99;

  end; {With..}


end;



procedure TCISEDIWizard.ApplyModes;


Var
  n  :  Byte;

Begin
  If (OutPutCB.ItemIndex=2) and (Pos('@',EDICEMF.Text)=0) then
    EDICEMF.Text:='edcs@edcsdata.hmce.gov.uk'
  else
    If (OutPutCB.ItemIndex=1) and (EDICEIDF.Text='') then
      EDICEIDF.Text:='INLANDREVENUE';


  Stations[1]:=(OutPutCB.ItemIndex=1);
  Stations[2]:=(OutPutCB.ItemIndex=2);

  TotPages:=0;
  For n:=Low(Stations) to High(Stations) do
  Begin
    TotPages:=TotPages+Ord(Stations[n]);
  end;
end;


procedure TCISEDIWizard.SetStepCaption;


Begin
  Label81.Caption:='Step '+IntToStr(NowPage)+' of '+IntToStr(TotPages);
end;

procedure TCISEDIWizard.TWPrevBtnClick(Sender: TObject);

Var
  Dir         :  Boolean;
  ThisPage,
  ICnt,DCnst  :  Integer;

begin
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

  // CJS: 05/01/2011 - If NowPage and Current_Page do not tally, the attempt
  // to change pages failed (probably because of a validation error on the
  // current page), so set NowPage back to the current page.
  if (NowPage <> (Current_Page + 1)) then
    NowPage := Current_Page + IfThen(Current_Page > 2, 0, 1);

  SetStepCaption;

end;

procedure TCISEDIWizard.OutputCBChange(Sender: TObject);
begin
  inherited;

  EDINWCBChange(Sender);

  If (Assigned(Sender)) then
    Form2Wizard;

  With SyssCIS^.CISRates do
    If (IEDIMethod<>1) then
      IVANUId:=Copy(UpCaseStr(VEDIFmtStr(Syss.UserName)),1,35);

  OutWizard;
end;

procedure TCISEDIWizard.EDINWCBChange(Sender: TObject);
begin
  inherited;

  If (Assigned(Sender)) then
    Form2Wizard;

  With SyssCIS^.CISRates do
    EDICEIDF.Text:=CEDIMethodID(IEDIMethod,IVanMode);

end;

procedure TCISEDIWizard.DirPathExit(Sender: TObject);
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

procedure TCISEDIWizard.DriveCB1Change(Sender: TObject);
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

procedure TCISEDIWizard.TryFinishWizard;

Var
  Locked,
  Ok2Cont  :  Boolean;
  mbRet    :  Word;

  ThisCIS  :   CISRecT;


Begin
  Form2Wizard;

  Ok2Cont:=BOn;

  With SyssCIS^.CISRates, CRepParam^ do
  Begin
    If (DirectoryExists(IDirPath)) then
    Begin
      CISFName:=EDICISFName(ITestMode,WizMode,RepEDate);

      If FileExists(BuildPath(IDirPath)+CISFName) then
      Begin
        Set_BackThreadMVisible(BOn);

        mbRet:=MessageDlg(CISFName+' already exists in that directory. Overwrite?',mtConfirmation,[mbYes,mbNo],0);

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
      If (IIREDIRef<>'') and (CISTaxRef<>'') then
      Begin
        {* VAT Reg ok!*}

      end
      else
        Begin
          Ok2Cont:=BOff;

          Set_BackThreadMVisible(BOn);

          ShowMEssage('Your Company '+CCCISName^+' Contractor Reference is not valid! Please correct.');

          Set_BackThreadMVisible(BOff);

        end;

        If (Ok2Cont) and (OutPutCB.ItemIndex=2) and ((IVANIRId='') or (IVANUId='')) then
        Begin
          Ok2Cont:=BOff;

          Set_BackThreadMVisible(BOn);

          ShowMessage('The email address is not valid.  Please correct.');

          Set_BackThreadMVisible(BOff);

        end;

        If (Ok2Cont) and (EDINWCB.ItemIndex=4) and (IVANPW='') then
        Begin
          Ok2Cont:=BOff;

          Set_BackThreadMVisible(BOn);

          ShowMessage('Submissions to Tradanet require a password.  Please correct.');

          Set_BackThreadMVisible(BOff);

        end;


      If (Ok2Cont) then
      Begin
        Locked:=BOn;

        ThisCIS:=SyssCIS^;

        GetMultiSys(BOn,Locked,CISR);


        If (GetMultiSys(BOn,Locked,CISR)) and (Locked) then
        Begin
          SyssCIS^:=ThisCIS;

          PutMultiSys(CISR,BOn);

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
          AddCISEDI2Thread(Application.MainForm,WizMode,CRepParam);
        {$ENDIF}

        Close;
      end;
    end;


  end; {With..}

end;






procedure TCISEDIWizard.FormCloseQuery(Sender: TObject;
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


Initialization

  CEDIMode:=0;

end.
