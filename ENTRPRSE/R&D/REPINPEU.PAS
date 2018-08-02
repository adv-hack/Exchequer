unit RepInpEU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, bkgroup, BTSupU3, Mask, TEditVal, BorBtns,
  Animate, SBSPanel, TCustom;

const
  // Report modes.
  VAT_RETURN         = 0;
  INTRASTAT_DISPATCH = 100;
  INTRASTAT_ARRIVALS = 200;
  
type
  // Form used to enter parameters for the VAT Return and Intrastat reports.
  TRepInpMsgE = class(TRepInpMsg)
    Label85: Label8;
    Label81: Label8;
    Label82: Label8;
    I1PrYrF: TEditPeriod;
    Sum1: TBorCheck;
    Sum2: TBorCheck;
    grpExportFile: TSBSGroup;
    Label87: Label8;
    edXMLPath: Text8Pt;
    btnXMLSetDir: TSBSButton;
    TextFileLAB1: Label8;
    chkExportToXML: TBorCheck;
    VatReturnImg: TImage;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure I1PrYrFExit(Sender: TObject);
    procedure btnXMLSetDirClick(Sender: TObject);
    procedure Label87Click(Sender: TObject);
    procedure edXMLPathChange(Sender: TObject);
    procedure chkExportToXMLClick(Sender: TObject);
  private
    { Private declarations }
    RepMode    :  Byte;
    CRepParam  :  VATRepPtr;
    CRepParam2 :  ISVATRepPtr;
    CompPr     :  String;
    HookEngaged  :  Boolean;
    ExportOption :  Boolean;
    procedure SetHelpContextIDs; // NF: 11/05/06
  public
    { Public declarations }
  end;

Var
  VMNo  :  Byte;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  VarConst,

  InvListU,

  ReportKU,

  {$IFDEF PF_On}
    {$IFDEF STK}
       IntrastatReport,
       IntrastatExport,
    {$ENDIF}
  {$ENDIF}

  {$IFDEF CU}
    ExWrap1U,
    Event1U,
    CustWinU,
  {$ENDIF}

  BrwseDir,
  GenWarnU,
  PWarnU,
  SysU1,
  SysU2,

  BTSupU2,
  ComnUnit;

{$R *.DFM}



//------------------------------------------------------------------------------
// Create the report input form.
procedure TRepInpMsgE.FormCreate(Sender: TObject);
Var
  VSYr,VSPr
     :  Word;

  CVYr,CVPr,
  NYear,
  n          :  Integer;

  {$IFDEF CU}
    HKStr    :  Str255;
    ExLocal  :  TdExLocal;

  {$ENDIF}

begin
  inherited;

  // Original Setting
//  ClientHeight:=162;
//  ClientWidth:=299;

  ClientHeight:=220;
  ClientWidth:=484;

  RepMode:=VMNo;

  // CA 05/09/2012 ABSEXCH-12708

  ExportOption := False;

  if (RepMode = INTRASTAT_DISPATCH) Or (RepMode = INTRASTAT_ARRIVALS) Then
  Begin
     grpExportFile.Visible := True;
     ExportOption          := True;

     // CA 02/11/2012 Jira ABSEXCH-12708
     if (OkCP1Btn.Enabled) then
        OkCP1Btn.Enabled := (Trim(edXMLPath.Text) <> '');

     if (RepMode = INTRASTAT_DISPATCH) Then
       TextFileLAB1.Caption := TextFileLAB1.Caption + 'IntrastatDispatchExp.CSV'
     else
        if (RepMode = INTRASTAT_ARRIVALS) Then
          TextFileLAB1.Caption := TextFileLAB1.Caption + 'IntrastatArrivalsExp.CSV'
  End;

  // CJS 2015-11-12 - ABSEXCH-17023 - Remove VAT Submission option for Cash Accounting
  chkExportToXML.Visible := False;
  VATReturnImg.Visible := False;

  { CJS 2013-08-08 - Added graphic and check for country code }
  if (RepMode = VAT_RETURN) and (CurrentCountry = UKCCode) then
  begin
    // ABSEXCH-13793. 08/05/2013. Add option to export VAT Return to XML format
    // CJS 2015-11-12 - ABSEXCH-17023 - Remove VAT Submission option for Cash Accounting
    if (not VAT_CashAcc(SyssVAT^.VATRates.VATScheme)) then
    begin
    chkExportToXML.Visible := true;
    VATReturnImg.Visible := True;
    end;
    OkCP1Btn.Enabled := true;
  end;

  New(Self.CRepParam);
  New(Self.CRepParam2);

  try
    With Self.CRepParam^ do
    Begin
      FillChar(Self.CRepParam^,Sizeof(Self.CRepParam^),0);
      VATEndD:=SyssVat.VATRates.CurrPeriod;

      {$IFDEF CU}
        HookEngaged:=EnableCustBtns(MiscBase+1,05);
      {$ELSE}
        HookEngaged:=BOff;
      {$ENDIF}

      If (HookEngaged) and (RepMode = VAT_RETURN) then
      Begin
        {$IFDEF CU}
          ExLocal.Create;
          HKStr:=TextExitHook(MiscBase+1,5,'',ExLocal);

          If (Copy(HKStr,3,1)<>'/') then
            HKStr:='01/2000';

          VPr:=IntStr(Copy(HKStr,1,2));
          NYear:=IntStr(Copy(HKStr,4,4));

          ExLocal.Destroy;
        {$ENDIF}
      end
      else
      Begin


        NYear:=Part_Date('Y',VATEndd);

        VPr:=Part_Date('M',VATEndd);
      end;

      VYr:=TxlateYrVal(NYear,BOn);
      CVYr:=NYear; CVPr:=VPr;

      I1PrYrF.InitPeriod(VPr,VYr,BOn,BOn);

      I1PrYrF.PeriodsInYear:=12;

      CompPr:=I1PrYrF.Text;
    end;
  except
    Dispose(Self.CRepParam);
    Self.CRepParam:=nil;
  end;

  try
    With Self.CRepParam2^ do
    Begin
      FillChar(Self.CRepParam2^,Sizeof(Self.CRepParam2^),0);

    end;
  except
    Dispose(Self.CRepParam2);
    Self.CRepParam2:=nil;
  end;

  Sum1.Visible:=BoChkAllowed_In((RepMode=VAT_RETURN),50) and (Not HookEngaged) and (ICEDFM=0);

  If (RepMode<>VAT_RETURN) then
  Begin

  end
  else
  Begin
    Sum2.Visible:=BOff;


  end;

  If (RepMode=VAT_RETURN) then
    Caption:=CCVATName^+' '+Caption

  else
  Begin
    Caption:='Intra EC Trade Statistics';
    HelpContext:=708;
    I1PrYrF.HelpContext:=636;
  end;

  SetLastValues;

  // If it's a VAT Return, and the "Close Period after Report" checkbox is checked...
  If (RepMode = VAT_RETURN) and (Sum1.Checked) then
  With CRepParam^ do
  Begin
    I1PrYrF.InitPeriod(VPr,VYr,BOn,BOn);

    I1PrYrF.PeriodsInYear:=12;

    Sum1.Checked:=BOff;
  end;

  SetHelpContextIDs; // NF: 11/05/06 Fix for incorrect Context IDs
  
end;


//------------------------------------------------------------------------------
procedure TRepInpMsgE.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);

  If (Assigned(CRepParam2)) then
    Dispose(CRepParam2);
end;


//------------------------------------------------------------------------------
// Exit event from the Period/Year input field.
// Enables the "Close VAT period after report" checkbox if it's the end of a VAT period.
procedure TRepInpMsgE.I1PrYrFExit(Sender: TObject);
begin
  inherited;

  If (RepMode = VAT_RETURN) and (Sum1.Visible) then
  Begin
    With CRepParam^ do
      Sum1.Enabled:=(CompPr=I1PrYrF.Text);

    // Uncheck the checkbox if it is disabled.
    If (Sum1.Checked) and (Not Sum1.Enabled) then
      Sum1.Checked:=BOff;
  end;
end;

//------------------------------------------------------------------------------
// Handle a click on the OK button
procedure TRepInpMsgE.OkCP1BtnClick(Sender: TObject);
Var
  VSYr,VSPr,
  AVPr,
  mrResult
     :  Word;

  CVYr,CVPr,
  NYear,
  n  :  Integer;
  ExportMode  : String;
  VATChk      :  Char;
begin
  VATChk := #0;
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With Self.CRepParam^ do
      Begin
        I1PrYrFExit(Nil);

        If (Sum1.Checked) then {Warn about implications of closing the VAT period}
        Begin
          // If the user elects NOT to close the VAT period, then uncheck that option.
          Sum1.Checked:=(CustomDlg(Application.MainForm,'Please Note!','The '+CCVATName^+' period is about to be closed',
                                   'Closing the '+CCVATName^+' period will prevent you from posting any future transactions to this '+
                                   CCVATName^+' period again.'+#13+
                                   'You should only close the current '+CCVATName^+' period once you have confirmed the report is '+
                                   'correct.'+#13+
                                   'You can also close the period via the '+CCVATName^+' setup screen (F5).'+#13+
                                   'Please confirm you wish to close the current '+CCVATName^+' period.',
                                   mtWarning,
                                   [mbYes,mbNo])=mrOK);



        end;


        OKCP1Btn.Enabled:=BOff;

        I1PrYrF.InitPeriod(VPr,VYr,BOff,BOff);

        NYear:=ConvTxYrVal(VYr,BOff);

        VSYr:=NYear; VSPr:=VPr;

        VISYr:=VYr; VISPr:=VPr;


        If (VPr=2) then {* Compensate for period 2 *}
          AVPr:=Pred(Monthdays[VPr])
        else
          AVPr:=Monthdays[VPr];

        // CJS 2015-11-04 - ABSEXCH-14234 - Cash Account VAT Report is blank for February
        // Use the Adjusted VAT Period value, instead of MonthDays[VPr].
        VATEndD := StrDate(NYear, VPr, AVPr);

        VATStartD:=StrDate(NYear,VPr,AVPr);

        {VATStartD:=VATEndD;}

        AutoCloseVAT:=Sum1.Checked;

    
        With CRepParam2^ do
        Begin
          VPr:=CRepParam^.VPr;
          VYr:=CRepParam^.VYr;

          Summary:=Sum2.Checked;
        end;

        Case RepMode of
          VAT_RETURN :
            begin
              // ABSEXCH-13793. 08/05/2013. Add option to export VAT Return to 
              //  XML format with an HMRC GovLink wrapper.
              if chkExportToXML.Checked then
              begin
                CRepParam^.WantXMLOutput := true;
                CRepParam^.XMLOutputPath := edXMLPath.Text;
              end;
            
              AddVATRRep22Thread(0,CRepParam,Owner);
            end

        {$IFDEF PF_On}
        {$IFDEF STK}
        else
          if (RepMode = INTRASTAT_ARRIVALS) Or
             (RepMode = INTRASTAT_DISPATCH) Then
          Begin
            Case RepMode of
              INTRASTAT_DISPATCH :
                    Begin
                      VATChk     := VATECDCode;
                      ExportMode := 'A';
                    End;
              INTRASTAT_ARRIVALS :
                    Begin
                      VATChk     := VATEECCode;
                      ExportMode := 'D';
                    End;
            end;

            AddISVATExportThread(RepMode, StrDate(NYear,VPr,01) ,StrDate(NYear,VPr, MonthDays[VPr]),
                                 VATChk, CRepParam2^.Summary, edXMLPath.Text, I1PrYrF.Text, Owner)
          end
          else
          begin
            AddISVATRep3Thread(RepMode,CRepParam2,Owner);
          end;
        {$ENDIF}
        {$ENDIF}

        end; {Case..}
        
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;

// NF: 11/05/06 Fix for incorrect Context IDs
procedure TRepInpMsgE.SetHelpContextIDs;
begin
  Sum2.HelpContext := 1723;
end;


procedure TRepInpMsgE.btnXMLSetDirClick(Sender: TObject);
Var
  OrigDir, DirPath  :  String;
begin {*en431 XML}
  { Save current directory }
  OrigDir := GetCurrentDir;

  (* HM 14/09/00: Modified to use Ebus directory selection dialog
  DirPath := edXMLPath.Text;

  If SelectDirectory (DirPath, [sdAllowCreate, sdPerformCreate, sdPrompt], edXMLPath.HelpContext) then
    edXMLPath.Text := DirPath;
  *)

  With TFrmDirBrowse.Create(Self) Do
    Try
      // default directory on dialog to currently selected path
      lbDirectory.Directory := edXMLPath.Text;

      If (ShowModal = mrOk) Then Begin
        edXMLPath.Text := lbDirectory.Directory;
      End; { If (ShowModal = mrOk) }
    Finally
      Free;
    End;

  { Restore original current directory }
  SetCurrentDir(OrigDir);
end;

procedure TRepInpMsgE.Label87Click(Sender: TObject);
begin
  ShowMessage ('Current Directory: ' + GetCurrentDir);
end;


//------------------------------------------------------------------------------
procedure TRepInpMsgE.edXMLPathChange(Sender: TObject);
begin
  inherited;

  // CA 02/11/2012 Jira ABSEXCH-13649
  OkCP1Btn.Enabled := (Trim(edXMLPath.Text) <> '');

  if (OkCP1Btn.Enabled) Then
     OkCP1Btn.Enabled := DirectoryExists(Trim(edXMLPath.Text));
end;

//------------------------------------------------------------------------------
// Handles a change in state of the "Export to XML" checkbox.
procedure TRepInpMsgE.chkExportToXMLClick(Sender: TObject);
var
  XMLFilePath : string;
begin
  // ABSEXCH-13793. 08/05/2013. Add option to export VAT Return to XML format
  inherited;

  // ABSEXCH-14371. 17/07/2013.  PKR.
  // We are now enforcing the destination directory, so the input box is no longer required.
  OkCP1Btn.Enabled := true;

  // Although the path edit box is now hidden, we can use it to pass on the 
  // enforced location.
  // This will be:
  // {CompanyRoot}\AUDIT\VAT100\Rawfiles\Sent\
  if chkExportToXML.Checked then
  begin
    XMLFilePath    := SetDrive + 'AUDIT\VAT100\Rawfiles\';
    if not DirectoryExists(XMLFilePath) then
    begin
      // Switch off this option
      chkExportToXML.Checked := false;
      ShowMessage('The VAT100 XML working directories do not exist.' +chr(13)+chr(10)+
                  'This option is not currently available.');
    end;
    edXMLPath.Text := XMLFilePath;
  end;
end;


//------------------------------------------------------------------------------
Initialization

  VMNo:=0;

end.
