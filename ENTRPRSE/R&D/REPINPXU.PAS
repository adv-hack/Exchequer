unit RepInpXU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, BTSupU3,
  TEditVal, BorBtns, Mask;

type
  TRepInpMsgX = class(TRepInpMsg)
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
    BorCheck1: TBorCheck;
    Label811: Label8;
    CBShowF: TSBSComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure AccF3Exit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure LocFExit(Sender: TObject);
    procedure SorFExit(Sender: TObject);
    procedure Sum1KeyPress(Sender: TObject; var Key: Char);
  private
    CRepParam  :  WOPRepPtr;
    RMode      :  Byte;

  public
    { Public declarations }
  end;

Var
  RepWMode  :  Byte;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  VarConst,
  BtrvU2,
  BTKeys1U,
  InvListU,
  ReportWU,

  SysU1,
  SysU2,
  BTSupU2;

{$R *.DFM}



procedure TRepInpMsgX.FormCreate(Sender: TObject);

Var
  HideLoc  :  Boolean;

begin
  inherited;
  ClientHeight:=292;
  ClientWidth:=379;

  New(CRepParam);

  RMode:=RepWMode;

  I2TransDateF.DateValue:=MaxUntilDate;
  I1TransDateF.DateValue:=Today;

  AgeX.ItemIndex:=0;
  CBFiltF.ItemIndex:=0;
  CBShowF.ItemIndex:=0;


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

    1  :  begin
            Caption:='Works Order Fulfilment Report';

            // CJS 2011-06-02 ABSEXCH-10817
            HelpContext := 1224;
          end;

    2  :  Begin
            Caption:='Works Order Status Report';

            CBFiltF.Visible:=BOn;
            Label810.Visible:=BOn;

            // CJS 2011-06-02 ABSEXCH-10817
            HelpContext := 1226;

            {Label86.Visible:=BOff;
            I1TransDateF.Visible:=BOff;
            I2TransDateF.Visible:=BOff;
            Label82.Visible:=BOff;
            SorF.Visible:=BOff;
            SorTF.Visible:=BOff;
            Label83.Visible:=BOff;
            Label84.Visible:=BOff;}

          end;
    11 :  Begin
            Caption:='Works Order Explosion Report';

            Label86.Visible:=BOff;
            I1TransDateF.Visible:=BOff;
            I2TransDateF.Visible:=BOff;

            I2TransDateF.DateValue:='';
            I1TransDateF.DateValue:='';

            {$IFDEF SOP}
              Label82.Caption:='For SOR/WOR No. : ';
            {$ELSE}
              Label82.Caption:='For Works Order No. : ';

            {$ENDIF}

            SorTF.Visible:=BOff;
            Label83.Visible:=BOff;
            Label84.Visible:=BOff;
            Label85.Visible:=BOff;
            AgeX.Visible:=BOff;

            // CJS 2011-06-02 ABSEXCH-10817
            HelpContext := 1225;
          end;

  end; {Case..}

  If (RMode In [1,11]) then
  Begin
    Label810.Caption:='Show : ';
    Label810.Visible:=BOn;
    CBShowF.Visible:=BOn;
    CBShowF.Top:=CBFiltF.Top;
  end;


  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  SetLastValues;
end;


procedure TRepInpMsgX.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;


procedure TRepInpMsgX.ACFFExit(Sender: TObject);
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



procedure TRepInpMsgX.AccF3Exit(Sender: TObject);
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

      FoundOk:=(GetCust(Application.MainForm,FoundCode,FoundCode,BOn,0));


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


procedure TRepInpMsgX.LocFExit(Sender: TObject);
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

procedure TRepInpMsgX.SorFExit(Sender: TObject);
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

      FoundOk:=StatusOk and ((Inv.InvDocHed=WOR) or ((Inv.InvDocHed=SOR) and (RMode=11)));

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

procedure TRepInpMsgX.OkCP1BtnClick(Sender: TObject);
Var
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

        UseSalesOB:=BorCheck1.Checked;

        If (AgeX.ItemIndex>=0) then
          SortOrd:=AgeX.ItemIndex;

        If (CBFiltF.ItemIndex>=0) then
          FiltOrd:=CBFiltF.ItemIndex;

        If (CBShowF.ItemIndex>=0) then
          AnalOrd:=CBShowF.ItemIndex;

        TagFilt:=Round(Sum1.Value);

        LocFilt:=LocF.Text;

        If (RMode=11) then
          LinkDocNo:=StartDocNo;

        AddWOP1Rep2Thread(RMode,CRepParam,Owner);

      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;






procedure TRepInpMsgX.Sum1KeyPress(Sender: TObject; var Key: Char);
begin
  // MH 22/12/2010 v6.6 ABSEXCH-10548: Prevent -ve numbers as stored in Byte
  If (Key = '-') Then
    Key := #0;
end;

Initialization

  RepWMode:=1;

end.
