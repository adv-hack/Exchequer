unit RepInpGU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, bkgroup, BTSupU3, TEditVal, Mask, Animate,
  SBSPanel;

type
  TRepInpMsgG = class(TRepInpMsg)
    Label86: Label8;
    I1TransDateF: TEditDate;
    Label87: Label8;
    I2TransDateF: TEditDate;
    Label84: Label8;
    CurrF: TSBSComboBox;
    Label811: Label8;
    CurrF2: TSBSComboBox;
    Label88: Label8;
    Id3CCF: Text8Pt;
    Id3DepF: Text8Pt;
    AccLab: Label8;
    AccF3: Text8Pt;
    Label810: Label8;
    DocFiltF: Text8Pt;
    LocLab: Label8;
    LocF: Text8Pt;
    Label83: Label8;
    SxSF: TSBSComboBox;
    lblAccountTypes: Label8;
    cbAccountTypes: TSBSComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Id3CCFExit(Sender: TObject);
    procedure AccF3Exit(Sender: TObject);
    procedure DocFiltFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure LocFExit(Sender: TObject);
  private
    { Private declarations }
    RepMode    :  Byte;

    CRepParam  :  PBrkRepPtr;

    procedure SetHelpContextIDs; // NF: 10/05/06

  public
    { Public declarations }
  end;

Var
  PBRNo  :  Byte;

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
  ReportCU,
  SysU1,
  SysU2,
  SBSComp2,
  BTSupU2;


{$R *.DFM}



procedure TRepInpMsgG.FormCreate(Sender: TObject);


Var
  HideLoc,
  HideCC  :  Boolean;
  TB      :  Byte;

begin
  inherited;

  ClientHeight:=253;
  ClientWidth:=335;

  RepMode:=PBRNo;

  {$IFDEF MC_On}

    Set_DefaultCurr(CurrF.Items,BOn,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);
    CurrF.ItemIndex:=0;

    Set_DefaultCurr(CurrF2.Items,BOn,BOff);
    Set_DefaultCurr(CurrF2.ItemsL,BOn,BOn);
    CurrF2.ItemIndex:=0;

  {$ELSE}
    Label84.Visible:=BOff;
    CurrF.Visible:=BOff;
    Label811.Visible:=BOff;
    CurrF2.Visible:=BOff;

  {$ENDIF}

    HideCC:=BOff;


  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=(Not Syss.UseCCDep or (Repmode=1));

  {$ENDIF}

  {$IFNDEF SOP}

    HideLoc:=BOn;
    Label83.Visible:=BOff;
    SxSF.Visible:=BOff;

  {$ELSE}

    HideLoc:=(Not Syss.UseMLoc);
    SxSF.ItemIndex:=0;

  {$ENDIF}

  // MH 02/10/2013 MRD1.2.27/28: Added drop-down list to filter account types
  // 10 - Stock Sales by Product
  // 11 - Stock Sales by Customer Report
  lblAccountTypes.Visible := (RepMode In [10, 11]) And Syss.ssConsumersEnabled;
  cbAccountTypes.Visible := lblAccountTypes.Visible;

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

  I1TransDateF.DateValue:=Today;
  I2TransDateF.DateValue:=MaxUntilDate;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;


  If (RepMode=11) then
    Caption:='Stock Sales by Customer Report';

  SetLastValues;

  SetHelpContextIDs; // NF: 10/05/06 Fix for incorrect Context IDs
end;

procedure TRepInpMsgG.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;



procedure TRepInpMsgG.Id3CCFExit(Sender: TObject);
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



procedure TRepInpMsgG.AccF3Exit(Sender: TObject);
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

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOn,0));


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

procedure TRepInpMsgG.DocFiltFExit(Sender: TObject);
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

procedure TRepInpMsgG.LocFExit(Sender: TObject);
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

procedure TRepInpMsgG.OkCP1BtnClick(Sender: TObject);
begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;

        {$IFDEF MC_On}
          RCr:=CurrF.ItemIndex;
          RTxCr:=CurrF2.ItemIndex;
        {$ENDIF}

        OrderMode:=(SxSF.ItemIndex=1);

        RCCDep[BOff]:=Id3DepF.Text;
        RCCDep[BOn]:=Id3CCF.Text;
        LocFilt:=LocF.Text;

        CustFilt:=AccF3.Text;
        StkToo:=DocFiltF.Text;

        SDate:=I1TransDateF.DateValue;
        EDate:=I2TransDateF.DateValue;

        // 10 - Stock Sales by Product
        // 11 - Stock Sales by Customer Report
        If (RepMode In [10, 11]) Then
        Begin
          // MH 02/10/2013 MRD1.1.27: Added report filter on account types
          Case cbAccountTypes.ItemIndex Of
            // Customers & Consumers
            0 : IncludeAccountTypes := atCustomersAndConsumers;
            // Customers Only
            1 : IncludeAccountTypes := atCustomersOnly;
            // Consumers Only
            2 : IncludeAccountTypes := atConsumersOnly;
          End; // Case cbAccountTypes.ItemIndex
        End; // If (RepMode In [10, 11])

        AddProdRep2Thread(RepMode,CRepParam,Owner);
      end;

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;

// NF: 10/05/06 Fix for incorrect Context IDs
procedure TRepInpMsgG.SetHelpContextIDs;
var
  bProduct : boolean;
begin
  bProduct := RepMode = 10;

  if bProduct then
  begin
    // Stock Sales by Product
    HelpContext := 662;
  end else
  begin
    // Stock Sales by Customer
    HelpContext := 663;
  end;
end;

Initialization

  PBRNo:=0;

end.
