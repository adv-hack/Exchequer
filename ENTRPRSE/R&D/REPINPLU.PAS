unit RepInpLU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, BorBtns, StdCtrls, TEditVal, Mask, ExtCtrls, BTSupU3, bkgroup,
  Animate, SBSPanel;

type
  TRepInpMsgL = class(TRepInpMsg)
    Label83: Label8;
    AccLab: Label8;
    Label85: Label8;
    Label86: Label8;
    DocFiltF: Text8Pt;
    I1PrYrF: TEditPeriod;
    I2PrYrF: TEditPeriod;
    Id3CCF: Text8Pt;
    Id3DepF: Text8Pt;
    ACFF: Text8Pt;
    Label81: Label8;
    Label811: Label8;
    CurrF: TSBSComboBox;
    CurrF2: TSBSComboBox;
    Sum1: TBorCheck;
    I1TransDateF: TEditDate;
    Label88: Label8;
    I2TransDateF: TEditDate;
    UDF: TBorRadio;
    UPF: TBorRadio;
    Label810: Label8;
    ProdF: Text8Pt;
    LocLab: Label8;
    LocF: Text8Pt;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure ProdFExit(Sender: TObject);
    procedure Id3CCFExit(Sender: TObject);
    procedure DocFiltFExit(Sender: TObject);
    procedure I1TransDateFEnter(Sender: TObject);
    procedure I1PrYrFEnter(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure LocFExit(Sender: TObject);
    function I1PrYrFConvDate(Sender: TObject; const IDate: String;
      const Date2Pr: Boolean): String;
    function I1PrYrFShowPeriod(Sender: TObject; const EPr: Byte): String;
  private
    { Private declarations }
    RepMode    :  Byte;

    CRepParam  :  SHistRepPtr;

  public
    { Public declarations }
  end;

Var
  SHRNo  :  Byte;

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
  ReportEU,
  SysU1,
  SysU2,
  BTSupU2;


{$R *.DFM}



procedure TRepInpMsgL.FormCreate(Sender: TObject);


Var
  HideLoc,
  HideCC  :  Boolean;
  TB,LYr,LPr
          :  Byte;

begin
  inherited;

  ClientHeight:=251;
  ClientWidth:=356;

  RepMode:=SHRNo;

  {$IFDEF MC_On}

    Set_DefaultCurr(CurrF.Items,BOn,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);
    CurrF.ItemIndex:=0;

    Set_DefaultCurr(CurrF2.Items,BOn,BOff);
    Set_DefaultCurr(CurrF2.ItemsL,BOn,BOn);
    CurrF2.ItemIndex:=0;

  {$ELSE}
    Label81.Visible:=BOff;
    CurrF.Visible:=BOff;
    Label811.Visible:=BOff;
    CurrF2.Visible:=BOff;

  {$ENDIF}

    HideCC:=BOff;


  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;

  {$ENDIF}


    {$IFNDEF SOP}

    HideLoc:=BOn;

  {$ELSE}

    HideLoc:=(Not Syss.UseMLoc);

  {$ENDIF}


  If (HideLoc) then
  Begin
    LocF.Visible:=BOff;
    LocLab.Visible:=BOff;
  end
  else
    If (HideCC) then
    Begin
      LocLab.Left:=(AccLab.Left+AccLab.Width)-LocLab.Width;
      LocF.Left:=Id3CCF.Left;
    end;


  Id3CCF.Visible:=Not HideCC;
  Id3DepF.Visible:=Not HideCC;
  Label88.Visible:=Not HideCC;

  TB:=1;

  UPF.Checked:=BOn;

  LPr:=GetLocalPr(0).CPr;
  LYr:=GetLocalPr(0).CYr;

  I1PrYrF.InitPeriod(TB,LYr,BOn,BOn);
  I2PrYrF.InitPeriod(LPr,LYr,BOn,BOn);



  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  SetLastValues;
end;

procedure TRepInpMsgL.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;


procedure TRepInpMsgL.ACFFExit(Sender: TObject);
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

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOn,99));


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



procedure TRepInpMsgL.ProdFExit(Sender: TObject);
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

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetStock(Self,FoundCode,FoundCode,99));


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



procedure TRepInpMsgL.Id3CCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  IsCC       :  Boolean;


begin
  Inherited;

  {$IFDEF PF_On}

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      FoundCode:=Name;

      IsCC:=Match_Glob(Sizeof(FoundCode),'CC',FoundCode,FoundOk);

      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If (AltMod) and (ActiveControl<>ClsCP1Btn) and
          (Syss.UseCCDep)  and (FoundCode<>'') and (Not Has_CCWildChar(FoundCode)) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetCCDep(Self,FoundCode,FoundCode,IsCC,0));


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
  {$ENDIF}
end;

procedure TRepInpMsgL.DocFiltFExit(Sender: TObject);
const
  invalidDocTypes = [SDG,NDG,OVT,DEB,SDT,NDT,IVT,CRE,RUN,FOL,AFL, ADC,ACQ,API,
                     SKF,JBF,JRN,WIN];
Var
  DT, i : DocTypes;
  isValidDocType : boolean;
begin
  inherited;

  DT:=SIN;
 
  //TW 11/08/2011: Added document filtering.
  if Length(DocFiltF.Text) > 0 then
  begin
    isValidDocType := false;
    for i :=low(DocTypes) to high(DocTypes)  do
    begin
      if not (i in invalidDocTypes) then
      begin
        if (copy(DocCodes[i], 1, length(trim(DocFiltF.Text))) = DocFiltF.Text) then
        begin
         isValidDocType := true;
         Break;
        end;
      end;
    end;
  end
  else
    isValidDocType := true;

  If  (isValidDocType) then
    Dt := DocTypeFCode(Strip('B',[#32],DocFiltF.Text))
  else if (isvalidDocType = false) and (ActiveControl<>ClsCP1Btn) then
  begin
     MessageBox(self.Handle, PChar(Format('%S is not a valid document type', [DocFiltF.Text])) , 'Warning', MB_SYSTEMMODAL + mb_OK +
     MB_ICONWARNING);
   DocFiltF.SetFocus;
  end;
  {If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If (AltMod) and (ActiveControl<>ClsCP1Btn) and (FoundCode<>'') then
    Begin
      Dt:=DocTypeFCode(FoundCode);


      If (DT=SKF) then
      Begin
        ShowMessage('That filter is not valid.'+#13+#13+'Please enter a full, or part document type.');
        SetFocus;
      end;
    end;
  end;}
end;

procedure TRepInpMsgL.I1TransDateFEnter(Sender: TObject);
begin
  inherited;

  I1TransDateF.ReadOnly:=UPF.Checked;
  I2TransDateF.ReadOnly:=UPF.Checked;

end;

procedure TRepInpMsgL.I1PrYrFEnter(Sender: TObject);
begin
  inherited;

  I1PrYrF.ReadOnly:=UDF.Checked;
  I2PrYrF.ReadOnly:=UDF.Checked;

end;


procedure TRepInpMsgL.LocFExit(Sender: TObject);
Var
  FoundCode  :  Str10;

  FoundOk,
  AltMod     :  Boolean;


begin
  {$IFDEF SOP}
    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetMLoc(Self,FoundCode,FoundCode,'',0));


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
  {$ENDIF}
end;


function TRepInpMsgL.I1PrYrFConvDate(Sender: TObject; const IDate: String;
  const Date2Pr: Boolean): String;
begin
  inherited;
  Result:=RepInpConvInpPr(IDate,Date2Pr);
end;

function TRepInpMsgL.I1PrYrFShowPeriod(Sender: TObject;
  const EPr: Byte): String;
begin
  inherited;
  Result:=RepInpPPr_Pr(EPr);
end;

procedure TRepInpMsgL.OkCP1BtnClick(Sender: TObject);
Begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;

        {$IFDEF MC_On}
          If (CurrF.ItemIndex>=0) then
            RCr:=CurrF.ItemIndex;

          If (CurrF2.ItemIndex>=0) then
            RTxCr:=CurrF2.ItemIndex;
        {$ENDIF}


        RCCDep[BOff]:=Id3DepF.Text;
        RCCDep[BOn]:=Id3CCF.Text;
        LocFilt:=LocF.Text;

        If (UPF.Checked) then
        Begin
          I1PrYrF.InitPeriod(RPr,RYr,BOff,BOff);
          I2PrYrF.InitPeriod(RPr2,RYr2,BOff,BOff);
        end
        else
        Begin
          SDate:=I1TransDateF.DateValue;
          EDate:=I2TransDateF.DateValue;
          RYr:=1;
        end;

        CustFilt:=AcFF.Text;
        DocWanted:=DocFiltF.Text;

        Summary:=Sum1.Checked;

        StkToo:=FullStockCode(ProdF.Text);

        AddSHistRep2Thread(RepMode,CRepParam,Owner);
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;




end.
