unit RepInpJU;

{$I DEFOVR.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, ExtCtrls, BTSupU3, bkgroup, BorBtns, TEditVal, Mask,
  Animate, SBSPanel;

type
  TRepInpMsgJ = class(TRepInpMsg)
    Label81: Label8;
    Label89: Label8;
    Label83: Label8;
    ACFF: Text8Pt;
    AccF3: Text8Pt;
    SxSF: TSBSComboBox;
    Sum1: TBorCheck;
    DocFiltF: Text8Pt;
    Label810: Label8;
    LocLab: Label8;
    LocF: Text8Pt;
    Sum2: TBorCheck;
    chkPrintParameters: TBorCheck;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure AccF3Exit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure LocFExit(Sender: TObject);
  private
    { Private declarations }
    RepMode    :  Byte;

    CRepParam  :  SListRepPtr;

  public
    { Public declarations }
  end;

Var
  SLRNo  :  Byte;

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
  ComnU2,
  BTSupU1,
  InvListU,
  ReportU,
  ReportDU,
  SysU1,
  SysU2,

  {$IFDEF SOP}
    {$IFDEF POST}
      ReValueU,
    {$ENDIF}
  {$ENDIF}  

  BTSupU2;


{$R *.DFM}



procedure TRepInpMsgJ.FormCreate(Sender: TObject);


Var
  HideLoc  :  Boolean;

begin
  inherited;

//  ClientHeight:=211;
  ClientHeight:=236;
  ClientWidth:=299;

  RepMode:=SLRNo;

  SxSF.ItemIndex:=0;

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;

  
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

  // MH 17/03/2010 v6.3: Suppressed Print Parameters check-box for inapplicable reports
  // MH 23/03/2010 v6.3: Added Stock Take List (2) which is a descendant of this
  chkPrintParameters.Visible := RepMode In [2,10];

  Case RepMode of
    1,10
       :  Begin
            Case RepMode of
              1  :  Caption:='Stock Re-Order List';
             10  :  Caption:='Stock Valuation';
            end; {Case..}

            Sum1.Visible:=BOff;
            AcFF.Visible:=BOff;
            SxSF.Visible:=BOff;
            DocFiltF.Visible:=BOff;
            AccF3.Visible:=BOff;
            Label81.Visible:=BOff;
            Label83.Visible:=BOff;
            Label89.Visible:=BOff;
            Label810.Visible:=BOff;
            LocF.Top:=Sum1.Top;
            LocLab.Top:=Sum1.Top;
            Sum2.Visible:=BOff;
            If (RepMode=10) then
              HelpContext:=666;
          end;

    3  :  Begin
            Caption:='Stock List';
            Sum1.Visible:=BOff;
            Sum2.Visible:=BOff;
//            HelpContext:=628; // NF: 11/05/06
            HelpContext:=665; // NF: 11/05/06 Fix for incorrect Context ID
          end;

    7  :  Begin
            Caption:='Stock Labels';
            Sum1.Visible:=BOff;
            Sum2.Visible:=BOff;
            Label81.Caption:='Product Code/Group :';
            LocLab.Visible:=BOff;
            LocF.Visible:=BOff;
            Label89.Visible:=BOff;
            AccF3.Visible:=BOff;
            HelpContext:=676;
          end;
  end; {Case..}

  {$IFDEF LTE}
    Label810.Visible:=BOff;
    DocFiltF.Visible:=BOff;
    Sum2.Visible:=BOff;

  {$ENDIF}

  SetLastValues;

  Case RepMode of
    1,10
       :  Begin
            AcFF.Text:='';    {* These need resetting as prev values may then be applied from oter modes *}
            DocFiltF.Text:='';
            AccF3.Text:='';
          end;

    7  :  Begin
            LocF.Text:='';

            AccF3.Text:='';
          end;
  end; {Case..}

end;

procedure TRepInpMsgJ.FormClose(Sender: TObject; var Action: TCloseAction);

begin
  inherited;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);
end;





procedure TRepInpMsgJ.ACFFExit(Sender: TObject);
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

      FoundOk:=(GetStock(Self,FoundCode,FoundCode,1+(98*Ord(RepMode=7))));


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

procedure TRepInpMsgJ.AccF3Exit(Sender: TObject);
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

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOff,0));


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


procedure TRepInpMsgJ.LocFExit(Sender: TObject);
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


procedure TRepInpMsgJ.OkCP1BtnClick(Sender: TObject);
Const
  SxSA  :  Array[0..2] of Char = ('C','D','B');
  SxSI  :  Array[0..2] of Byte = (0,3,7);

Var
  CRepParam2  :  CustRepPtr;

begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      With CRepParam^ do
      Begin
        OKCP1Btn.Enabled:=BOff;

        CustFilt:=AccF3.Text;

        StkToo:=FullStockCode(ACFF.Text);

        ShowQty:=Sum1.Checked;

        ShowBins:=Sum2.Checked;

        RepValType:=DocFiltF.Text;

        LocFilt:=LocF.Text;

        If (SxSF.ItemIndex>=0) then
          RepOrd:=SxSA[SxSF.ItemIndex];

        //PR: 22/10/2009
        PrintParameters := chkPrintParameters.Checked;

        If (RepMode<>7) then
        Begin
        {$IFDEF SOP}
          Case RepMode of
            10  :  {$IFDEF POST}
                     AddStkValue2Thread(Self,LocFilt);
                   {$ELSE}
                     ;
                   {$ENDIF}

            else   AddSListRep2Thread(RepMode,CRepParam,Owner);
          end; {Case..}
        {$ELSE}
          AddSListRep2Thread(RepMode,CRepParam,Owner);
        {$ENDIF}
        end
        else
          Begin
            New(CRepParam2);
            Blank(CRepParam2^,Sizeof(CRepParam2^));

            With CRepParam2^ do
            try
              StaStart:=StkToo;
              //PR: 03/02/2011 Added check to avoid possible range error
              If (SxSF.ItemIndex>=0) then
                SAgeInt:=SxSI[SxSF.ItemIndex];
              AccTFilt:=RepValType;

              If (Is_FullStkCode(StaStart)) then
              Begin
                If (Global_GetMainRec(StockF,StaStart)) then
                Begin
                  ShowOS:=Stock.StockType<>StkGrpCode;

                  If (ShowOS) then
                    SAgeInt:=StkCodeK;
                end;

              end;

              AddStaRep2Thread(11,CRepParam2,Owner);
            finally
              Dispose(CRepParam2);
            end; {try..}
          end;
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
