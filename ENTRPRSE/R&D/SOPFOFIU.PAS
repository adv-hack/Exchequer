unit SOPFOFIU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, Mask, TEditVal, Animate, ExtCtrls, SBSPanel, bkgroup,
  GlobVar, BorBtns;


type
  TSOPROFiFrm = class(TRepInpMsg)
    Label81: Label8;
    ACFF: Text8Pt;
    Label89: Label8;
    AccF3: Text8Pt;
    BorCheck1: TBorCheck;
    procedure FormCreate(Sender: TObject);
    procedure ACFFExit(Sender: TObject);
    procedure AccF3Exit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }

    Procedure Send_UpdateList(Mode   :  Integer);

  public
    { Public declarations }

    SCode  :  Str10;
    KCode  :  Str20;
    BOMWOR :  Boolean;

    Procedure SetFields;
  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  VarConst,
  BtrvU2,
  BTKeys1U,
  InvListU,
  SysU1,
  SysU2,
  BTSupU1,
  SBSComp2;

{$R *.DFM}



procedure TSOPROFiFrm.FormCreate(Sender: TObject);


begin
  inherited;
  ClientHeight:=161;
  ClientWidth:=299;

  BorCheck1.Visible:=FullWOP;

end;


procedure TSOPROFiFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Send_UpdateList(116);
end;


Procedure TSOPROFiFrm.SetFields;

Begin
  ACFF.Text:=KCode;
  AccF3.Text:=SCode;
  BorCheck1.Checked:=BOMWOR;
end;

procedure TSOPROFiFrm.ACFFExit(Sender: TObject);
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

      FoundOk:=(GetStock(Application.MainForm,FoundCode,FoundCode,1));


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



procedure TSOPROFiFrm.AccF3Exit(Sender: TObject);
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

      FoundOk:=(GetCust(Application.MainForm,FoundCode,FoundCode,BOff,0));


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



{ == Procedure to Send Message to Get Record == }

Procedure TSOPROFiFrm.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode+100;
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}



procedure TSOPROFiFrm.OkCP1BtnClick(Sender: TObject);
Var
  TB  :  Byte;

Begin
  If (Sender=OkCP1Btn) then
  Begin
    If (Not EmptyKey(FullStockCode(AcFF.Text),StkKeyLen)) then
      KCode:=AcFF.Text
    else
      KCode:='';

    If (Not EmptyKey(FullCustCode(AccF3.Text),CustKeyLen)) then
      SCode:=AccF3.Text
    else
      SCode:='';

    BOMWOR:=BorCheck1.Checked;

    OKCp1Btn.Enabled:=BOff;
    ClsCp1Btn.Enabled:=BOff;

  end;

  Send_UpDateList(114+Ord(Sender=OKCp1Btn));

  LastValueObj.UpdateAllLastValues(Self);

end;






Initialization


end.
