unit CuStkT4U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, TEditVal, bkgroup, BTSupU1,
  SalTxl1U, GlobVar,VarConst,VarRec2U,ExWrap1U, SBSPanel;

type
  TCuStkT4 = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    SBSPanel1: TSBSPanel;
    Label84: Label8;
    TSHMCBox: TSBSComboBox;
    Label81: Label8;
    TSSCBox: TSBSComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CanCP1BtnClick(Sender: TObject);

  private

    Function TxLateTCOM(TCM  :  Integer)  :  Integer;

    procedure Form2Id;

  public
    { Public declarations }

    TeleSHed  :  MLocPtr;

    Procedure OutId;

  end;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  BorBtns,
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BtKeys1U,

  BTSupU2,
  SBSComp2,
  CmpCtrlU,
  CurrncyU,
  ComnUnit,
  ComnU2,
  SysU2,

  ColCtrlU,

  {SysU2,}
  {MLoc0U,}
  InvListU,

  {InvLst3U,}

  ThemeFix,

  CuStkA4U,
  CuStkA2U,
  CuStkA3U,
  CuStkL1U;

  {PayF2U,

  {PayLineU,}

  {DocSupU1;}

  {Saltxl1U;}




{$R *.DFM}









procedure TCuStkT4.FormCreate(Sender: TObject);
begin
  // MH 10/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  ClientHeight:=178;
  ClientWidth:=401;

  With TForm(Owner) do
    Self.Left:=Left+2;

  New(TeleSHed);

end;




procedure TCuStkT4.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TCuStkT4.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TCuStkT4.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;



Function TCuStkT4.TxLateTCOM(TCM  :   Integer)  :  Integer;

Begin
  If (TCM=2) then
    Result:=1
  else
    If (TCM=1) then
      Result:=2
    else
      Result:=TCM;

end;



{ ============== Display Id Record ============ }

Procedure TCuStkT4.OutId;


Begin

  With TeleSHed^,TeleSRec do
  Begin
    TSHMCBox.ItemIndex:=TxLateTCOM(tcOrdMode);
    TSSCBox.ItemIndex:=tcScaleMode;

  end;


end;


procedure TCuStkT4.Form2Id;


Begin
  With TeleSHed^,TeleSRec do
  Begin
    tcOrdMode:=TxLateTCOM(TSHMCBox.ItemIndex);
    tcScaleMode:=TSSCBox.ItemIndex;

  end;


end; {Proc..}






procedure TCuStkT4.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      Form2Id;
      SendMEssage((Self.Owner as TForm).Handle,WM_CustGetRec,205,LongInt(@TeleSHed^));
      Close;
    end
    else
      If (ModalResult=mrCancel) then
      Begin
        SendMEssage((Self.Owner as TForm).Handle,WM_CustGetRec,205,0);
        Begin
          Close;
          Exit;
        end;
      end;
  end; {With..}

end;



Initialization

end.
