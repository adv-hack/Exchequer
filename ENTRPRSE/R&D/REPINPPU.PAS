unit RepInpPU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, TEditVal,
  BorBtns, Mask, BTSupU3;

type
  TRepInpMsgP = class(TRepInpMsg)
    Label86: Label8;
    I1TransDateF: TEditDate;
    Label87: Label8;
    I2TransDateF: TEditDate;
    Label81: Label8;
    ACFF: Text8Pt;
    Label83: Label8;
    ACCF2: Text8Pt;
    AccLab: Label8;
    AccF3: Text8Pt;
    Sum1: TBorCheck;
    Label84: Label8;
    CurrF: TSBSComboBox;
    Over1Chk: TBorCheck;
    FilterX: TSBSComboBox;
    Label811: Label8;
    PaperCheck: TBorCheck;
    cbUseCustom: TBorCheck;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure AccF3Exit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure PaperCheckClick(Sender: TObject);
  private
    CRepParam  :  PFormRepPtr;
    procedure SetHelpContextIDs; // NF: 11/05/06
  public
    { Public declarations }
  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  VarConst,
  BTKeys1U,
  InvListU,
  FrmThrdU,
  RpDefine,
  {$IFDEF Frm}
    PrintFrm,
  {$ENDIF}

  SysU1,
  SysU2,

  {$IFDEF CU}
    Event1U,
    EXWrap1U,

  {$ENDIF}


  BtSupu2,
  Btrvu2;


{$R *.DFM}



procedure TRepInpMsgP.FormCreate(Sender: TObject);


begin
  inherited;

  ClientHeight:=215;
  ClientWidth:=299;

  {$IFDEF MC_On}

    Set_DefaultCurr(CurrF.Items,BOn,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);
    CurrF.ItemIndex:=0;

  {$ELSE}
    Label84.Visible:=BOff;
    CurrF.Visible:=BOff;
  {$ENDIF}

  I1TransDateF.DateValue:=MinUntilDate;
  I2TransDateF.DateValue:=MaxUntilDate;

  FilterX.ItemIndex:=0;

  FilterX.Visible:=eCommsModule;

  {$IFDEF LTE}
    FilterX.ITems.Delete(2);
  {$ENDIF}


  Label811.Visible:=FilterX.Visible;
  PaperCheck.Visible:=FilterX.Visible;

  {$IFDEF CU}
    cbUseCustom.Visible:=EnableCustBtns(2000,104);
  {$ENDIF}


  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);

    With CRepParam^,PParam,PDevRec do
    Begin
      PBatch:=BOn;
      Preview:=BOn;
      NoCopies:=1;
      Orient:=RPDefine.poPortrait;
      UFont:=Nil;
    end;
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;


  SetLastValues;

  Sum1.Enabled:=(EmptyKey(AccF3.Text,CustKeyLen));

  FilterX.Enabled:=PaperCheck.Checked and PaperCheck.Visible;

  SetHelpContextIDs; // NF: 11/05/06 Fix for incorrect Context IDs
end;

procedure TRepInpMsgP.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;


procedure TRepInpMsgP.ACFFExit(Sender: TObject);

Var
  AltMod     :  Boolean;
  FoundCode  :  Str20;

begin
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) and (Length(FoundCode)>3) then
    Begin
      Text:=AutoSetInvKey(FoundCode,DocKeyLen);
    end;

  end; {With..}

end;


procedure TRepInpMsgP.AccF3Exit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    Sum1.Enabled:=BOn;

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOn,99));


      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;

        Sum1.Enabled:=BOff;
        Sum1.Checked:=BOff;

      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;

procedure TRepInpMsgP.PaperCheckClick(Sender: TObject);
begin
  inherited;

  FilterX.Enabled:=PaperCheck.Checked;
end;

procedure TRepInpMsgP.OkCP1BtnClick(Sender: TObject);

Var
  Ok2Cont  :  Boolean;
  searchKey : Str255;
  funcReturn : longint;

  {$IFDEF CU}
    ExLocal  :  TdExLocal;
  {$ENDIF}

begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      //TW 09/08/2011: Added code below to prompt user if no document results are
      //               found or their range is invalid.
      searchKey := ACFF.Text;
      funcReturn := Find_Rec(B_GetGeq, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, searchKey);
      if (funcReturn = 0) and (Inv.OurRef >= ACFF.Text) and (Inv.OurRef < 
        ACCF2.Text) then
      begin
        With CRepParam^,PParam do
        Begin
          OKCP1Btn.Enabled:=BOff;

          {$IFDEF MC_On}
            RCr:=CurrF.ItemIndex;
          {$ENDIF}

          CustFilt:=AccF3.Text;
          CStart:=ACFF.Text;
          CEnd:=ACCF2.Text;

          SDate:=I1TransDateF.DateValue;
          EDate:=I2TransDateF.DateValue;
          ACCSort:=Sum1.Checked;
          UseOwnForm:=Over1Chk.Checked;
          SFiltX:=FilterX.ItemIndex;

          {$IFDEF LTE}
            If (SFiltX=2) then
              SFiltX:=3;
          {$ENDIF}

          UsePaperLess:=PaperCheck.Checked;
          UseCustomFilter:=cbUseCustom.Checked;

          If (UsePaperless) then {* If using paperless, exclude global email option *}
            PDevRec.feTypes:=14;

          {$IFDEF CU}
            If (cbUseCustom.Checked) then
            Begin
              Ok2Cont:=BOff;

              ExLocal.Create;

              try

                Ok2Cont:=ValidExitHook(2000,105,ExLocal);

              finally;
                ExLocal.Destroy;

              end; {try..}
            end
            else
              Ok2cont:=BOn;

          {$ELSE}
            Ok2Cont:=BOn;
          {$ENDIF}

          {$IFDEF FRM}
            If (Ok2Cont) then
            Begin
              RForm:=pfGetMultiFrmDefs(0).FormDefs.PrimaryForm[6];

              If (pfSelectFormPrinter(PDevRec,BOn,RForm,UFont,Orient)) then
                Start_DocRange(Owner,CRepParam);
            end;
          {$ENDIF}
        end;
      end
      else
      begin
       MessageBox(0, 'No documents were found within the specified range.', 'Warning', +mb_OK +
         MB_ICONWARNING);
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
procedure TRepInpMsgP.SetHelpContextIDs;
begin
  FilterX.HelpContext := 1724;
end;

end.
