unit CISXMLWU;

{$I DEFOVR.Inc}

{$WARN UNIT_PLATFORM OFF}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Wiztempu, StdCtrls, TEditVal, TCustom, ExtCtrls, SBSPanel, ComCtrls, Mask,
  GlobVar,BorBtns, FileCtrl,
  VarRec2U,BTSupU3;

type
  TCISXMLWizard = class(TWizTemplate)
    Label82: Label8;
    I1TransDateF: TEditDate;
    Label87: Label8;
    I2TransDateF: TEditDate;
    Label83: Label8;
    TestModeChk: TBorCheck;
    Label89: Label8;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Label810: Label8;
    Label811: Label8;
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
    Label84: Label8;
    ECAuthF: Text8Pt;
    Label88: Label8;
    ECTOF: Text8Pt;
    Label819: Label8;
    ECTRF: Text8Pt;
    ECESCb: TBorCheckEx;
    ECSVcb: TBorCheckEx;
    ECNoPaycb: TBorCheckEx;
    Label85: Label8;
    Label812: Label8;
    Label820: Label8;
    procedure FormCreate(Sender: TObject);
    procedure DirLB1Change(Sender: TObject);
    procedure TWPrevBtnClick(Sender: TObject);
    procedure DirPathExit(Sender: TObject);
    procedure DriveCB1Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure EDICEIdFExit(Sender: TObject);
    procedure EDIRPWFExit(Sender: TObject);
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
  {XML wizard mode. 0 = Statement Run. 2 = EOY}
  CXMLMode  :  Byte;

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
  JobSup1U,
   {$IFDEF Rp}
     CISXMLTU,
   {$ENDIF}
  IntMU,
  JChkUseU,
  ExThrd2U,
  ExpVED2U;


{$R *.DFM}




procedure TCISXMLWizard.FormCreate(Sender: TObject);

Var
  Locked             :  Boolean;

  VYr,VPr
                     :  Byte;

  CVYr,CVPr,NYear,n  :  Integer;

  RectD              :  TRect;


begin
  inherited;

  Caption:=CCCISName^+' Monthly Return Wizard.';

  Label86.Caption:=Caption;

  WizMode:=CXMLMode;


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
  GetMultiSys(BOff,Locked,CIS340R);

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

  OutWizard;

  SetStepCaption;
end;


procedure TCISXMLWizard.FormDestroy(Sender: TObject);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

end;



procedure TCISXMLWizard.SetWizardCaption;

Const
  VEDITitle  :  Array[0..2] of Str50 = ('Statement','','End of Year');


Begin
  Label83.Caption:='The '+CCCISName^+' Monthly Return wizard will guide you through the creation of the '+VEDITitle[WizMode]+
                   ' return.'+#13+'The details below are required in order to complete the sumbission to HMRC';

  Label89.Caption:=Label83.Caption;

  Label810.Caption:=Label83.Caption;

  Label811.Caption:='Please choose the directory path where you want the submission file to be placed.';

  CRepParam^.EDIHedTit:=VEDITitle[WizMode];
end;


procedure TCISXMLWizard.DirLB1Change(Sender: TObject);
begin
  inherited;
  DirPath.Text:=DirLB1.Directory;
end;


procedure TCISXMLWizard.OutWizard;

Var
  Locked    :  Boolean;
  TmpDrive  :  String;

Begin
  Locked:=BOff;

  If (Not InOutPut) then
  With SyssCIS^.CISRates, SyssCIS340^.CIS340 do
  Begin
    InOutPut:=BOn;

    TestModeChk.Checked:=ITestMode;


    ECIEPF.Text:=IGWUId;
    ECAuthF.Text:=IGWIRef;
    ECTOF.Text:=IGWTO;
    ECTRF.Text:=IGWTR;
    EDICEIDf.Text:=CISCUTR;
    EDIRpwF.Text:=CISACCONo;
    ECESCb.Checked:=IXConfEmp;
    ECSVcb.Checked:=IXVerSub;
    ECNoPaycb.Checked:=IXNoPay;



    If (DirectoryExists(IXMLDirPath)) then
    Begin
      DirPath.Text:=IXMLDirPath;
      TmpDrive:=ExtractFileDrive(IXMLDirPath);

      If (TmpDrive[1] In ['A'..'Z']) then
        DriveCB1.Drive:=TmpDrive[1];

      DirLB1.Directory:=BuildPath(IXMLDirPath);
    end;

    SendEBC.Checked:=ISendEmail;


    InOutPut:=BOff;
  end;

  ApplyModes;
end;


procedure TCISXMLWizard.Form2Wizard;


Begin
  With SyssCIS^.CISRates, SyssCIS340^.CIS340, CRepParam^ do
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

    IGWUId:=ECIEPF.Text;
    IGWIRef:=ECAuthF.Text;
    IGWTO:=ECTOF.Text;
    IGWTR:=ECTRF.Text;
    CISCUTR:=EDICEIDf.Text;
    CISACCONo:=EDIRpwF.Text;
    IXConfEmp:=ECESCb.Checked;
    IXVerSub:=ECSVcb.Checked;
    IXNoPay:=ECNoPaycb.Checked;


    IXMLDirPath:=DirPath.Text;

    ISendEmail:=SendEBC.Checked;

    RepType:=99;

  end; {With..}


end;



procedure TCISXMLWizard.ApplyModes;


Var
  n  :  Byte;

Begin

  Stations[1]:=BOn;
  Stations[2]:=BOff;

  TotPages:=0;
  For n:=Low(Stations) to High(Stations) do
  Begin
    TotPages:=TotPages+Ord(Stations[n]);
  end;
end;


procedure TCISXMLWizard.SetStepCaption;


Begin
  Label81.Caption:='Step '+IntToStr(NowPage)+' of '+IntToStr(TotPages);
end;

procedure TCISXMLWizard.TWPrevBtnClick(Sender: TObject);

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

procedure TCISXMLWizard.DirPathExit(Sender: TObject);
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

procedure TCISXMLWizard.DriveCB1Change(Sender: TObject);
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

procedure TCISXMLWizard.TryFinishWizard;

Var
  Locked,
  Ok2Cont  :  Boolean;
  mbRet    :  Word;

  ThisCIS  :   CISRecT;
  ThisCIS340
           :   CIS340RecT;


Begin
  Form2Wizard;

  Ok2Cont:=BOn;

  With SyssCIS^.CISRates,SyssCIS340^.CIS340, CRepParam^ do
  Begin
    If (DirectoryExists(IXMLDirPath)) then
    Begin
      CISFName:=XMLCISFName(WizMode,RepEDate);

      If FileExists(BuildPath(IXMLDirPath)+CISFName) then
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
      If (IGWUId<>'') and (IGWIRef<>'') then
      Begin
        {* Gateway details present ok!*}

      end
      else
        Begin
          Ok2Cont:=BOff;

          Set_BackThreadMVisible(BOn);

          ShowMEssage('Your Contractor Id and/or Contractor Authentication are not valid! Please correct.');

          Set_BackThreadMVisible(BOff);

        end;

        If (Ok2Cont) and ({(CISTaxRef='') or} (IGWTO='')) then
        Begin
          Ok2Cont:=BOff;

          Set_BackThreadMVisible(BOn);

          ShowMessage('The Tax Office and/or the Tax Office Reference are not valid.  Please correct.');

          Set_BackThreadMVisible(BOff);

        end;

        If (Ok2Cont) and ((Not CISValid_UTR(CISCUTR)) or (Not CISValid_AccOff(CISACCONo))) then
        Begin
          Ok2Cont:=BOff;

          Set_BackThreadMVisible(BOn);

          ShowMessage('Your Contractors UTR and/or Contractors Account Office Reference are not valid.  Please correct.');

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

          ThisCIS340:=SyssCIS340^;

          If (GetMultiSys(BOn,Locked,CIS340R)) and (Locked) then
          Begin
            SyssCIS340^:=ThisCIS340;

            PutMultiSys(CIS340R,BOn);
          end;
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
          AddCISXML2Thread(Application.MainForm,WizMode,CRepParam);
        {$ENDIF}

        Close;
      end
      else
        NowPage:=NowPage-1;
    end;


  end; {With..}

end;






procedure TCISXMLWizard.FormCloseQuery(Sender: TObject;
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


procedure TCISXMLWizard.EDICEIdFExit(Sender: TObject);
begin
  inherited;
  If (Sender is TMaskEdit) and (ActiveControl<>TWClsBtn) then
  With (Sender as TMaskEdit) do
  Begin
    If (Not CISValid_UTR(Text)) then
    Begin
      MessageDlg('That Unique Tax Reference is not valid. (Must be a number).',
                     mtWarning,[mbOk],0);


      SetFocus;

    end;
  end;
end;



procedure TCISXMLWizard.EDIRPWFExit(Sender: TObject);
begin
  inherited;
  If (Sender is TMaskEdit) and (ActiveControl<>TWClsBtn) then
  With (Sender as TMaskEdit) do
  Begin
    If (Not CISValid_AccOff(Text)) then
    Begin
      MessageDlg('That Accounts Office Reference is not valid. (NNNpANNNNNNNN)',
                     mtWarning,[mbOk],0);


      SetFocus;

    end;
  end;

end;

Initialization

  CXMLMode:=0;

end.
