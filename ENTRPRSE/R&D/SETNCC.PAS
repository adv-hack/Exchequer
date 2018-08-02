unit SetNCC;


{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, TEditVal, BorBtns, ExtCtrls,
  AuditIntf,  // CA 12/02/2013 v7.0.2 : ABSEXCH-14003 : New Audit for this screen has been done
  GlobVar,VarConst, bkgroup;


type
  TSetGLCC = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    ext8Pt1: Text8Pt;
    ext8Pt2: Text8Pt;
    ext8Pt3: Text8Pt;
    D1F: Text8Pt;
    GL1F: Text8Pt;
    SD1F: Text8Pt;
    D2F: Text8Pt;
    GL2F: Text8Pt;
    SD2F: Text8Pt;
    D3F: Text8Pt;
    GL3F: Text8Pt;
    Sd3F: Text8Pt;
    D4F: Text8Pt;
    GL4F: Text8Pt;
    SD4F: Text8Pt;
    D5F: Text8Pt;
    GL5F: Text8Pt;
    SD5F: Text8Pt;
    D6F: Text8Pt;
    GL6F: Text8Pt;
    SD6F: Text8Pt;
    D7F: Text8Pt;
    GL7F: Text8Pt;
    SD7F: Text8Pt;
    D8F: Text8Pt;
    GL8F: Text8Pt;
    SD8F: Text8Pt;
    D9F: Text8Pt;
    GL9F: Text8Pt;
    SD9F: Text8Pt;
    D10F: Text8Pt;
    GL10F: Text8Pt;
    SD10F: Text8Pt;
    D11F: Text8Pt;
    GL11F: Text8Pt;
    SD11F: Text8Pt;
    D12F: Text8Pt;
    GL12F: Text8Pt;
    SD12F: Text8Pt;
    D13F: Text8Pt;
    GL13F: Text8Pt;
    SD13F: Text8Pt;
    D14F: Text8Pt;
    GL14F: Text8Pt;
    SD14F: Text8Pt;
    SD15F: Text8Pt;
    GL15F: Text8Pt;
    D15F: Text8Pt;
    D16F: Text8Pt;
    GL16F: Text8Pt;
    SD16F: Text8Pt;
    JCTSLab: Label8;
    D17F: Text8Pt;
    D18F: Text8Pt;
    D19F: Text8Pt;
    GL19F: Text8Pt;
    GL18F: Text8Pt;
    GL17F: Text8Pt;
    SD17F: Text8Pt;
    SD18F: Text8Pt;
    SD19F: Text8Pt;
    D20F: Text8Pt;
    GL20F: Text8Pt;
    SD20F: Text8Pt;
    DSettlementWriteOff: Text8Pt;
    GLSettlementWriteOff: Text8Pt;
    SDSettlementWriteOff: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure GL1FExit(Sender: TObject);
  private
    { Private declarations }

    BeenStored,
    BadCode  :  Boolean;

    GLCCAry  :  Array[NomCtrlType] of Text8Pt;
    GLSDAry  :  Array[NomCtrlType] of Text8Pt;

    JCTSCAry :  Array[1..3] of Text8pt;
    JCTSDAry :  Array[1..3] of Text8pt;

    GLCCEnd  :  NomCtrlType;

    // CA 12/02/2013 v7.0.2 ABSEXCH-14003: Added the NCC Setup Audit Trail files
    NCCSetupAudit    : IBaseAudit;
    NCCJobSetupAudit : IBaseAudit;
	// MH 06/05/2015 v7.0.14 ABSEXCH-16284: Added new 'Settlement Write-Off' Control Code for PPD
    NCCSystemSetupAudit : IBaseAudit;

    function GLFindAry(Sender: TObject)  :  NomCtrlType;

    function JCGLFindAry(Sender: TObject)  :  Byte;

    Function Check4DupliNT(NT        :  NomCtrlType;
                           Nom2Chk   :  LongInt;
                           DispMsg   :  Boolean)  :  Boolean;

    procedure OutGLCC;

    Procedure Send_UpdateList(Mode   :  Integer);

    procedure SetSyssStore(EnabFlag,
                           VOMode  :  Boolean);


    Function CheckCompleted  : Boolean;

    procedure StoreSyss;

  public
    { Public declarations }
    procedure ProcessSyss;

  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  BtrvU2,
  ETDateU,
  EtStrU,
  ETMiscU,
  ComnUnit,
  ComnU2,
  BTSupU1,
  BTSupU2,
  InvListU,

  // MH 06/05/2015 v7.0.14 ABSEXCH-16284: Added new 'Settlement Write-Off' Control Code for PPD
  oSystemSetup,

  oProcessLock;


{$R *.DFM}


procedure TSetGLCC.OutGLCC;

Var
  n  :  NomCtrlType;
  m  :  Byte;

  FoundLong
     :  LongInt;

begin
  With Syss do
  Begin
    For n:=InVAT to GLCCEnd do
    Begin
      GLCCAry[n].Text:=Form_Int(NomCtrlCodes[n],0);

      If (GetNom(Self,GLCCAry[n].Text,FoundLong,-1)) then
        GLSDAry[n].Text:=Nom.Desc;
    end;
  end;

  With SyssJob^.JobSetUp do
    For m:=Low(JCTSCAry) to High(JCTSCAry) do
    Begin
      JCTSCAry[m].Text:=Form_Int(EmployeeNom[m,BOff],0);

      If (GetNom(Self,JCTSCAry[m].Text,FoundLong,-1)) then
        JCTSDAry[m].Text:=Nom.Desc;
    end;

  // MH 06/05/2015 v7.0.14 ABSEXCH-16284: Added new 'Settlement Write-Off' Control Code for PPD
  GLSettlementWriteOff.Text := Form_Int(SystemSetup.ControlCodes.ssSettlementWriteOffCtrlGL, 0);
  If GetNom(Self, GLSettlementWriteOff.Text, FoundLong, -1) then
    SDSettlementWriteOff.Text:= Nom.Desc;
end;

procedure TSetGLCC.FormCreate(Sender: TObject);

Var
  Locked  : Boolean;
Begin
  // CA 12/02/2013 v7.0.2 ABSEXCH-14003: Initialising NCCSetupAudit and NCCJobSetupAudit
  NCCSetupAudit    := NIL;
  NCCJobSetupAudit := NIL;
  
  InGLCC :=BOn;
  {$IFDEF RET}
    GLCCEnd:=RetSurcharge;
  {$ELSE}
    GLCCEnd:=PurchComm;
  {$ENDIF}

  ClientHeight:=494;

  ClientWidth:=452;

  BadCode:=BOff;
  BeenStored:=BOff;

  MDI_SetFormCoord(TForm(Self));

  Locked:=BOff;

  GetMultiSys(BOff,Locked,SysR);

  {$IFDEF JC}
    GetMultiSys(BOff,Locked,JobsR);
  {$ENDIF}

  // MH 13/02/2013 v7.0.2: Moved setting of BeforeData AFTER the records have been read :-)
  // CA 12/02/2013 v7.0.2 ABSEXCH-14003: Setting up the before NCCSetupAudit and NCCJobSetupAudit
  //                                     to hold the info before any data changes
  NCCSetupAudit := NewAuditInterface(atNCCSetup);
  NCCSetupAudit.BeforeData := @Syss;

  NCCJobSetupAudit := NewAuditInterface(atNCCJobSetup);
  NCCJobSetupAudit.BeforeData := SyssJob;

  // MH 06/05/2015 v7.0.14 ABSEXCH-16284: Added new 'Settlement Write-Off' Control Code for PPD
  NCCSystemSetupAudit := NewAuditInterface(atSystemSetupTable);
  NCCSystemSetupAudit.BeforeData := SystemSetup(True).AuditData;      // True = Refresh Settings

  GLCCAry[InVAT]:=GL1F;
  GLCCAry[OutVAT]:=GL2F;
  GLCCAry[Debtors]:=GL3F;
  GLCCAry[Creditors]:=GL4F;
  GLCCAry[DiscountGiven]:=GL5F;
  GLCCAry[DiscountTaken]:=GL6F;
  GLCCAry[LDiscGiven]:=GL7F;
  GLCCAry[LDiscTaken]:=GL8F;
  GLCCAry[ProfitBF]:=GL9F;
  GLCCAry[CurrVar]:=GL10F;
  GLCCAry[UnRCurrVar]:=GL11F;
  GLCCAry[PLStart]:=GL12F;
  GLCCAry[PLEnd]:=GL13F;
  GLCCAry[FreightNC]:=GL17F;
  GLCCAry[SalesComm]:=GL18F;
  GLCCAry[PurchComm]:=GL19F;

  GLCCAry[RetSurcharge]:=GL20F;

  GLSDAry[InVAT]:=SD1F;
  GLSDAry[OutVAT]:=SD2F;
  GLSDAry[Debtors]:=SD3F;
  GLSDAry[Creditors]:=SD4F;
  GLSDAry[DiscountGiven]:=SD5F;
  GLSDAry[DiscountTaken]:=SD6F;
  GLSDAry[LDiscGiven]:=SD7F;
  GLSDAry[LDiscTaken]:=SD8F;
  GLSDAry[ProfitBF]:=SD9F;
  GLSDAry[CurrVar]:=SD10F;
  GLSDAry[UnRCurrVar]:=SD11F;
  GLSDAry[PLStart]:=SD12F;
  GLSDAry[PLEnd]:=SD13F;
  GLSDAry[FreightNC]:=SD17F;
  GLSDAry[SalesComm]:=SD18F;
  GLSDAry[PurchComm]:=SD19F;

  GLSDAry[RetSurcharge]:=SD20F;

  JCTSCAry[1]:=GL14F;
  JCTSCAry[2]:=GL15F;
  JCTSCAry[3]:=GL16F;

  JCTSDAry[1]:=SD14F;
  JCTSDAry[2]:=SD15F;
  JCTSDAry[3]:=SD16F;



  D1F.Text:=CCVatName^+D1F.Text;
  D2F.Text:=CCVatName^+D2F.Text;

  {$IFNDEF MC_On}
    D10F.Visible:=BOff;
    GL10F.Visible:=BOff;
    SD10F.Visible:=BOff;
    D11F.Text:='Suspense Account';
  {$ENDIF}

  {$IFNDEF RET}
    D20F.Visible:=BOff;
    GL20F.Visible:=BOff;
    SD20F.Visible:=BOff;
  {$ELSE}
    D20F.Visible:=RetMOn;
    GL20F.Visible:=RetMOn;
    SD20F.Visible:=RetMOn;
  {$ENDIF}

  JCTSLab.Visible:=JBCostOn;
  D14F.Visible:=JBCostOn;
  D15F.Visible:=JBCostOn;
  D16F.Visible:=JBCostOn;
  GL14F.Visible:=JBCostOn;
  GL15F.Visible:=JBCostOn;
  GL16F.Visible:=JBCostOn;
  SD14F.Visible:=JBCostOn;
  SD15F.Visible:=JBCostOn;
  SD16F.Visible:=JBCostOn;

  If (Not JBCostOn) then
  Begin
    ClientHeight:=ClientHeight - 84;
    CanCP1Btn.Top:=CanCP1Btn.Top - 84;
    OKCP1Btn.Top:=CanCP1Btn.Top;
  end;

  {$IF Not Defined(STK) or Defined(LTE)}
    GL17F.Visible:=BOff;
    D17F.Visible:=BOff;
    SD17F.Visible:=BOff;
  {$IFEND}

  {$IFNDEF SOP}
    GL18F.Visible:=BOff;
    D18F.Visible:=BOff;
    SD18F.Visible:=BOff;
    GL19F.Visible:=BOff;
    D19F.Visible:=BOff;
    SD19F.Visible:=BOff;
  {$ENDIF}

  {$IFDEF LTE}

  {$ENDIF}


end;


{ == Procedure to Send Message to Get Record == }

Procedure TSetGLCC.Send_UpdateList(Mode   :  Integer);

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
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


procedure TSetGLCC.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  Send_UpdateList(63);
end;

procedure TSetGLCC.FormClose(Sender: TObject; var Action: TCloseAction);

Var
  LStatus  :  Integer;
begin
  Action:=caFree;
  InGLCC:=BOff;

  // CA 12/02/2013 v7.0.2 ABSEXCH-14003: Initialising NCCSetupAudit and NCCJobSetupAudit
  NCCSetupAudit    := NIL;
  NCCJobSetupAudit := NIL;
  // MH 06/05/2015 v7.0.14 ABSEXCH-16284: Added new 'Settlement Write-Off' Control Code for PPD
  NCCSystemSetupAudit := NIL;

  If (Not BeenStored) then
  Begin
    LStatus:=UnlockMultiSing(F[SysF],SysF,SysAddr[SysR]);

    {$IFDEF JC}
      LStatus:=UnlockMultiSing(F[SysF],SysF,SysAddr[JobSR]);
    {$ENDIF}
  end;

  //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Release process lock
  SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plControlCodes), 0);
end;

procedure TSetGLCC.SetSyssStore(EnabFlag,
                                  VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  OutGLCC;

  OkCP1Btn.Enabled:=Not VOMode;

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is Text8Pt) then
    Begin
      If (Text8Pt(Components[Loop]).Tag=1) then
        Text8Pt(Components[Loop]).ReadOnly:= VOMode;
    end
      else
        If (Components[Loop] is TEditDate) then
        Begin
          If (TEditDate(Components[Loop]).Tag=1) then
            TEditDate(Components[Loop]).ReadOnly:= VOMode;
        end
        else
          If (Components[Loop] is TEditPeriod) then
          Begin
            If (TEditPeriod(Components[Loop]).Tag=1) then
              TEditPeriod(Components[Loop]).ReadOnly:= VOMode;
          end
          else
            If (Components[Loop] is TCurrencyEdit) then
            Begin
              If (TCurrencyEdit(Components[Loop]).Tag=1) then
                TCurrencyEdit(Components[Loop]).ReadOnly:= VOMode;
            end
            else
              If (Components[Loop] is TBorCheck) then
              Begin
                If (TBorCheck(Components[Loop]).Tag=1) then
                  TBorCheck(Components[Loop]).Enabled:= Not VOMode;
              end
              else
                If (Components[Loop] is TSBSComboBox) then
                Begin
                  If (TSBSComboBox(Components[Loop]).Tag=1) then
                    TSBSComboBox(Components[Loop]).ReadOnly:= VOMode;
              end;
  end; {Loop..}

end;



procedure TSetGLCC.ProcessSyss;


Var
  Locked  :  Boolean;
Begin
  Locked:=BOn;

  OutGLCC;

  If (ICEDFM=0) then
  Begin
    If (GetMultiSys(BOff,Locked,SysR)) and (Locked) then
      {$IFDEF JC}
        If (GetMultiSys(BOff,Locked,JobsR)) and (Locked) then

      {$ENDIF}
      SetSyssStore(BOff,BOff);
  end
  else
    SetSyssStore(BOff,BOn);
end;

procedure TSetGLCC.StoreSyss;

Var
  n  :  NomCtrlType;
  m  :  Byte;
Begin
  With Syss do
  Begin
    For n:=InVAT to GLCCEnd do
      NomCtrlCodes[n]:=IntStr(Strip('B',[#32],GLCCAry[n].Text));
  end;

  With SyssJob^.JobSetUp do
    For m:=Low(JCTSCAry) to High(JCTSCAry) do
      EmployeeNom[m,BOff]:=IntStr(Trim(JCTSCAry[m].Text));
end;


Function TSetGLCC.CheckCompleted  : Boolean;

Const
  NofMsgs      =  6;


Type
  PossMsgType  = Array[1..NofMsgs] of Str80;

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  KeyS     :  Str255;

  Test     :  Byte;

  FoundCode:  Str20;

  FoundOk,
  Loop,
  ShowMsg  :  Boolean;

  FoundLong:  LongInt;

  mbRet    :  Word;

  n        :  NomCtrlType;
  m        :  Byte;


Begin
  New(PossMsg);
  ShowMsg := False;


  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='One of the Control Codes is set to zero!';
  PossMsg^[2]:='One of the Control Codes is not a valid G/L Code!';
  PossMsg^[3]:='One of the Control Codes is duplicated!';
  PossMsg^[4]:='One of the Job Control Codes is set to zero!';
  PossMsg^[5]:='One of the Job Control Codes is not a valid G/L Code!';
  PossMsg^[6]:='The Settlement Write-Off Control Code is not valid';


  Loop:=BOff;

  Test:=1;

  Result:=BOn;


  While (Test<=NofMsgs) and (Result) do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin

              FoundOk:=BOff;

              For n:=InVAT to GLCCEnd do
              Begin
                FoundOk:=(IntStr(Trim(GLCCAry[n].Text))=0);

                {$IFNDEF MC_On}
                   If (FoundOk) and (n=CurrVar) then {* Ignore currency variance *}
                     FoundOk:=BOff;

                {$ENDIF}

                {$IF Not Defined(STK) or Defined(LTE)}
                   If (FoundOk) and (n In [FreightNC]) then {* Ignore Freight Control *}
                     FoundOk:=BOff
                   else
                     If (FoundOk) and (n In [RetSurcharge]) then {* Ignore Returns Surcharge *}
                       FoundOk:=BOff;

                {$ELSE}
                   If (FoundOk) and (n In [FreightNC]) and (Not Syss.UseUpLiftNC) then {* Ignore Freight Control *}
                     FoundOk:=BOff;

                   {$IFNDEF RET}
                     If (FoundOk) and (n In [RetSurcharge]) then {* Ignore Returns Surcharge *}
                       FoundOk:=BOff;

                   {$ELSE}
                     If (FoundOk) and (n In [RetSurcharge]) and (Not RetMOn) then {* Ignore Returns Surcharge *}
                       FoundOk:=BOff;

                   {$ENDIF}

                {$IFEND}

                {$IFNDEF SOP}
                   If (FoundOk) and (n In [SalesComm,PurchComm]) then {* Ignore Commitment *}
                     FoundOk:=BOff;

                {$ELSE}
                   If (FoundOk) and (n In [SalesComm,PurchComm]) and (Not CommitAct) then {* Ignore Commitment *}
                     FoundOk:=BOff;

                {$ENDIF}


                If (FoundOk) then
                  Break;
              end;

              Result:=Not FoundOk;

            end;

      2  :  Begin

              FoundOk:=BOff;

              For n:=InVAT to GLCCEnd do
              Begin
                FoundOk:=(Not GetNom(Self,GLCCAry[n].Text,FoundLong,-1));

                {$IFNDEF MC_On}
                   If (FoundOk) and (n=CurrVar) then {* Ignore currency variance *}
                     FoundOk:=BOff;

                {$ENDIF}


                {$IFNDEF STK}
                   If (FoundOk) and (n In [FreightNC]) then {* Ignore Freight Control *}
                     FoundOk:=BOff
                   else
                     If (FoundOk) and (n In [RetSurcharge]) then {* Ignore Returns Surcharge *}
                       FoundOk:=BOff;


                {$ELSE}
                   If (FoundOk) and (n In [FreightNC]) and (Not Syss.UseUpLiftNC) then {* Ignore Freight Control *}
                     FoundOk:=BOff;

                   {$IFNDEF RET}
                     If (FoundOk) and (n In [RetSurcharge]) then {* Ignore Returns Surcharge *}
                       FoundOk:=BOff;

                   {$ELSE}
                     If (FoundOk) and (n In [RetSurcharge]) and (Not RetMOn) then {* Ignore Returns Surcharge *}
                       FoundOk:=BOff;

                   {$ENDIF}
                {$ENDIF}

                {$IFNDEF SOP}
                   If (FoundOk) and (n In [SalesComm,PurchComm]) then {* Ignore Commitment *}
                     FoundOk:=BOff;

                {$ELSE}
                   If (FoundOk) and (n In [SalesComm,PurchComm]) and (Not CommitAct) then {* Ignore Commitment *}
                     FoundOk:=BOff;

                {$ENDIF}


                If (FoundOk) then
                  Break;
              end;

              Result:=Not FoundOk;

            end;

      3  :  Result:=Not BadCode;

      {$IFDEF JC}

      4  :  If (JBCostOn) then
            Begin

              FoundOk:=BOff;

              For m:=Low(JCTSCAry) to High(JCTSCAry) do
              Begin
                FoundOk:=(IntStr(Trim(JCTSCAry[m].Text))=0);

                If (FoundOk) then
                  Break;
              end;


              Result:=Not FoundOk;

            end;

      5  :  If (JBCostOn) then
            Begin

              FoundOk:=BOff;

              For m:=Low(JCTSCAry) to High(JCTSCAry) do
              Begin
                FoundOk:=(Not GetNom(Self,JCTSCAry[m].Text,FoundLong,-1));

                If (FoundOk) then
                  Break;
              end;


              Result:=Not FoundOk;

            end;
      {$ENDIF}

      // MH 06/05/2015 v7.0.14 ABSEXCH-16284: Added new 'Settlement Write-Off' Control Code for PPD
      6  :  Begin
              FoundOk := GetNom(Self, GLSettlementWriteOff.Text, FoundLong, -1);

              If FoundOK Then
              Begin
                // A or B, Consolidated, Active
                FoundOK := (Nom.NomType In [PLNHCode, BankNHCode]) And
                           {$IFDEF MC_On}
                           (Nom.DefCurr = 0) And
                           {$ENDIF}
                           (Nom.HideAC = 0);
              End; // If FoundOK

              If (Not FoundOK) And GLSettlementWriteOff.CanFocus Then
                GLSettlementWriteOff.SetFocus;

              Result := FoundOK;
            End; // 6
    end;{Case..}

    If (Result) then
      Inc(Test);

  end; {While..}

  If (Not Result) and (ShowMsg) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

  Dispose(PossMsg);

end; {Func..}



procedure TSetGLCC.OkCP1BtnClick(Sender: TObject);

Var
  bOK, WantClose, Locked  :  Boolean;
  Res : Integer;
begin
  // MH 05/01/2011 v6.6 ABSEXCH-10548: Complete rewrite as existing code was a total clusterf**k
  WantClose := False;

  If (Sender = OKCP1Btn) Then
  Begin
    // OK
    // MH 05/01/2011 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
    //                                   fields which processes the text and updates the value
    If (ActiveControl <> OkCP1Btn) Then
      // Move focus to OK button to force any OnExit validation to occur
      OkCP1Btn.SetFocus;

    // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
    If (ActiveControl = OkCP1Btn) And CheckCompleted then
    Begin
      // Update System Setup records from window
      StoreSyss;

      // MH 06/05/2015 v7.0.14: Modified to write audit details AFTER a successfull update!
      bOK := PutMultiSys(SysR,BOn);
      If bOK And Assigned(NCCSetupAudit) Then
      Begin
        NCCSetupAudit.AfterData := @Syss;
        NCCSetupAudit.WriteAuditEntry;
        NCCSetupAudit := NIL;
      End; // If bOK And Assigned(NCCSetupAudit)

      {$IFDEF JC}
        If bOK Then
        Begin
          // MH 06/05/2015 v7.0.14: Modified to write audit details AFTER a successfull update!
          BOK := PutMultiSys(JobsR,BOn);
          If bOK And Assigned(NCCJobSetupAudit) Then
          Begin
            NCCJobSetupAudit.AfterData := SyssJob;
            NCCJobSetupAudit.WriteAuditEntry;
            NCCJobSetupAudit := NIL;
          End;
        End; // If bOK
      {$ENDIF}

      // MH 06/05/2015 v7.0.14 ABSEXCH-16284: Added new 'Settlement Write-Off' Control Code for PPD
      If BOK Then
      Begin
        // check for change in value
        Res := SystemSetup.UpdateValue (siSettlementWriteOffCtrlGL,                                  // Field being changed
                                        IntToStr(SystemSetup.AuditData.isSettlementWriteOffCtrlGL),  // Original value
                                        GLSettlementWriteOff.Text); // new value
        If (Res = 0) Then
        Begin
          If Assigned(NCCSystemSetupAudit) Then
          Begin
            // Audit
            NCCSystemSetupAudit.AfterData := SystemSetup.AuditData;
            NCCSystemSetupAudit.WriteAuditEntry;
            NCCSystemSetupAudit := NIL;
          End; // If (Res = 0) And Assigned(NCCSystemSetupAudit)
        End // If (Res = 0)
        Else If (Res = 2) Then
          MessageDlg ('Error - another user has already changed the Settlement Write-Off GL Control Code, please re-open the window and try again', mtError, [mbOK], 0)
        Else
          MessageDlg ('An error ' + IntToStr(Res) + ' occurred updating the Settlement Write-Off GL Control Code', mtError, [mbOK], 0);
      End; // If bOK

      BeenStored := BOn;
      WantClose := True;
    End; // (ActiveControl = OkCP1Btn) And CheckCompleted
  End // If (Sender = OKCP1Btn)
  Else If (Sender = CanCP1Btn) Then
  Begin
    // Cancel - re-read records to ensure records in memory not affected by this dialog
    Locked:=BOff;
    GetMultiSys(BOff,Locked,SysR);

    {$IFDEF JC}
      Locked:=BOff;
      GetMultiSys(BOff,Locked,JobSR);
    {$ENDIF}

    WantClose := True;
  End; // If (Sender = CanCP1Btn)

  If WantClose Then
    Close;
end;


procedure TSetGLCC.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TSetGLCC.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

function TSetGLCC.GLFindAry(Sender: TObject)  :  NomCtrlType;

Var
  n        :  NomCtrlType;
  FoundOk  :  Boolean;

Begin
  FoundOk:=BOff;

  For n:=InVAT to GLCCEnd do
  Begin
    FoundOk:=(GLCCAry[n]=Sender);

    If (FoundOk) then
      Break;
  end;

  If (FoundOk) then
    Result:=n
  else
    Result:=NSpare14;

end;


function TSetGLCC.JCGLFindAry(Sender: TObject)  :  Byte;

Var
  m        :  Byte;
  FoundOk  :  Boolean;

Begin
  FoundOk:=BOff;

  For m:=Low(JCTSCAry) to High(JCTSCAry) do
  Begin
    FoundOk:=(JCTSCAry[m]=Sender);

    If (FoundOk) then
      Break;
  end;

  If (FoundOk) then
    Result:=m
  else
    Result:=0;

end;


Function TSetGLCC.Check4DupliNT(NT        :  NomCtrlType;
                                Nom2Chk   :  LongInt;
                                DispMsg   :  Boolean)  :  Boolean;
Var
  n        :  NomCtrlType;
  FoundOk  :  Boolean;

Begin
  FoundOk:=BOff;

  For n:=InVAT to GLCCEnd do
  Begin
    FoundOk:=((IntStr(Trim(GLCCAry[n].Text))=Nom2Chk) and (n<>NT));


    If (FoundOk) then
      Break;
  end;

  Result:=Not FoundOk;

  If (FoundOk) and (DispMsg) then
  Begin

    ShowMessage('That General Ledger Control Code already exists!'+#13+#13+
                'Duplicate Control Codes are not allowed.');
  end;

end; {Func..}



procedure TSetGLCC.GL1FExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  SMode,
  FoundLong  :  LongInt;

  n          :  NomCtrlType;
  m          :  Byte;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=(Modified or BadCode);

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='') or (FoundCode='0')) and (ActiveControl<>CanCP1Btn) then
    Begin

      StillEdit:=BOn;

      If (Sender=GL12F) or (Sender=GL13F) then
        SMode:=99
      // MH 06/05/2015 v7.0.14 ABSEXCH-16284: Added new 'Settlement Write-Off' Control Code for PPD
      Else If (Sender = GLSettlementWriteOff) Then
        // Balance Sheet or P&L Only
        SMode := 0
      else
        SMode:=5;

      FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,SMode));


      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=Form_Int(FoundLong,0);

        // MH 06/05/2015 v7.0.14 ABSEXCH-16284: Added new 'Settlement Write-Off' Control Code for PPD
        If (Sender = GLSettlementWriteOff) Then
          SDSettlementWriteOff.Text := Nom.Desc
        Else
        Begin
          n:=GLFindAry(Sender);

          If (n<>NSpare14) then
          Begin
            GLSDAry[n].Text:=Nom.Desc;

            BadCode:= Not Check4DupliNT(n,IntStr(Trim(GLCCAry[n].Text)),BOn);

            If (BadCode) then
              SetFocus;
          end
          else
          Begin
            {$IFDEF JC}
              m:=JCGLFindAry(Sender);

              If (m<>0) then
                JCTSDAry[m].Text:=Nom.Desc;
            {$ENDIF}

          end;
        End; // Else
      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;

end.
