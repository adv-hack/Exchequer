unit RepIRT1U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, BTSupU3,
  TEditVal, BorBtns, Mask, VarConst;

type
  TRepInpRT = class(TRepInpMsg)
    Label81: Label8;
    ACFF: Text8Pt;
    Label89: Label8;
    AccF3: Text8Pt;
    Label86: Label8;
    I1TransDateF: TEditDate;
    LocLab: Label8;
    LocF: Text8Pt;
    I2TransDateF: TEditDate;
    Label82: Label8;
    SorF: Text8Pt;
    SorTF: Text8Pt;
    Label83: Label8;
    Label84: Label8;
    Label85: Label8;
    AgeX: TSBSComboBox;
    CBFiltF: TSBSComboBox;
    Label87: Label8;
    Label88: Label8;
    Sum1: TCurrencyEdit;
    Label810: Label8;
    lbXReason: TListBox;
    Label811: Label8;
    lbXStatus: TListBox;
    Label812: Label8;
    cbSumm: TBorCheckEx;
    Label813: Label8;
    Label814: Label8;
    CurrF: TSBSComboBox;
    Label815: Label8;
    CurrF2: TSBSComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure AccF3Exit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure LocFExit(Sender: TObject);
    procedure SorFExit(Sender: TObject);
    procedure CBFiltFClick(Sender: TObject);
    procedure I1TransDateFExit(Sender: TObject);
  private
    CRepParam  :  RETRepPtr;
    RMode      :  Byte;
    RDocHed    :  DocTypes;

  public
    { Public declarations }
  end;

Var
  RepRMode  :  Byte;
  RepRSales :  Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,

  BtrvU2,
  BTKeys1U,
  InvListU,
  BTSupU2,
  RepRet1U,
  RetSup1U,
  SysU1,
  SysU2;

{$R *.DFM}



procedure TRepInpRT.FormCreate(Sender: TObject);

Var
  HideLoc  :  Boolean;

begin
  inherited;

  
  ClientHeight:=356;
  ClientWidth:=380;

  New(CRepParam);

  RMode:=RepRMode;

  If (RepRSales) then
    RDocHed:=SRN
  else
    RDocHed:=PRN;

  Caption:=DocNames[RDocHed]+Caption;

  I2TransDateF.DateValue:=MaxUntilDate;
  I1TransDateF.DateValue:=Today;

  AgeX.ItemIndex:=0;
  CBFiltF.ItemIndex:=0;

  Animated1.Visible:=BOff;

  {$IFDEF MC_On}

    Set_DefaultCurr(CurrF.Items,BOn,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);
    CurrF.ItemIndex:=0;

    Set_DefaultCurr(CurrF2.Items,BOn,BOff);
    Set_DefaultCurr(CurrF2.ItemsL,BOn,BOn);
    CurrF2.ItemIndex:=0;

  {$ELSE}
    Label814.Visible:=BOff;
    CurrF.Visible:=BOff;

    Label815.Visible:=BOff;
    CurrF2.Visible:=BOff;

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
  end;

  Case RMode of

    2  :  Begin
            Caption:=DocNames[RDocHed]+' Matching Summary';

            CBFiltF.Visible:=BOn;
            Label810.Visible:=BOn;


          end;

  end; {Case..}

  Set_RetLineStat(lbXReason.Items);

  Set_DefaultRetStat(lbXStatus.ITems,RepRSales,BOff);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);

    With CRepParam^ do
    Begin
      UseSales:=RepRSales;
    end;



  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  SetLastValues;

  CBFiltFClick(Nil);
end;


procedure TRepInpRT.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;


procedure TRepInpRT.ACFFExit(Sender: TObject);
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

      FoundOk:=(GetStock(Application.MainForm,FoundCode,FoundCode,99));


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



procedure TRepInpRT.AccF3Exit(Sender: TObject);
Var
  FoundCode  :  Str20;

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

      FoundOk:=(GetCust(Application.MainForm,FoundCode,FoundCode,CRepParam^.UseSales,0));


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

procedure TRepInpRT.CBFiltFClick(Sender: TObject);
begin
  inherited;

  I1TransDateF.Enabled:=(CBFiltF.ITemIndex<>0);

  With I1TransDateF do
  Begin
    ReadOnly:=Not Enabled;
    TabStop:=Enabled;
  end;

  I2TransDateF.Enabled:=I1TransDateF.Enabled;
  I2TransDateF.ReadOnly:=I1TransDateF.ReadOnly;
  I2TransDateF.TabStop:=I1TransDateF.TabStop;

end;


procedure TRepInpRT.LocFExit(Sender: TObject);
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

procedure TRepInpRT.SorFExit(Sender: TObject);
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
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundCode:=AutoSetInvKey(Text,0);

      GenStr:=FoundCode;

      Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,GenStr);

      FoundOk:=StatusOk and (((Inv.InvDocHed In StkRetSaleSsplit) and (CRepParam^.UseSales)) or ((Inv.InvDocHed In StkRetPurchSplit) and (Not CRepParam^.UseSales)));

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


procedure TRepInpRT.I1TransDateFExit(Sender: TObject);
begin
  inherited;

  If (I1TransDateF.DateValue>I2TransDateF.DateValue) and (ActiveControl<>ClsCP1Btn) then
    I2TransDateF.DateValue:=I1TransDateF.DateValue;
end;


procedure TRepInpRT.OkCP1BtnClick(Sender: TObject);
Var
  n,
  TB  :  Byte;

Begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;
        STCode:=AcFF.Text;
        CustFilt:=AccF3.Text;
        SDate:=I1TransDateF.DateValue;
        EDate:=I2TransDateF.DateValue;
        StartDocNo:=SORF.Text;
        EndDocNo:=SORTF.Text;
        RepDocHed:=RDocHed;
        Summary:=cbSumm.Checked;

        If (AgeX.ItemIndex>=0) then
          SortOrd:=AgeX.ItemIndex;

        If (CBFiltF.ItemIndex>=0) then
          FiltOrd:=CBFiltF.ItemIndex;

        {$IFDEF MC_On}
          RCr:=CurrF.ItemIndex;
          RTxCr:=CurrF2.ItemIndex;
        {$ENDIF}


        TagFilt:=Round(Sum1.Value);

        LocFilt:=LocF.Text;

    SetLength(XReasonCodes, lbXReason.Count);
        For n:=0 to lbXReason.Count-1 do
          XReasonCodes[n]:=lbXReason.Selected[n];

        For n:=0 to lbXStatus.Count-1 do
          XStatusCodes[n]:=lbXStatus.Selected[n];


        AddRET1Rep2Thread(RMode,CRepParam,Owner);

      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;








Initialization

  RepRMode:=1;
  RepRSales:=BOff;
end.
