unit BarGU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, Gauges;

type
  TBarP = class(TForm)
    SBSPanel1: TSBSPanel;
    Label81: Label8;
    SBSPanel2: TSBSPanel;
    Gauge1: TGauge;
    CanCP1Btn: TButton;
    procedure CanCP1BtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    private

      RunningOk  :  Boolean;

      Procedure Send_UpdateList(Mode   :  Integer);

    public
      { Public declarations }
      KeyR  :  TModalResult;

      procedure ShutDown;


  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  GlobVar,
  VarConst,
  BTSupU1,
  BTSupU2;

{$R *.DFM}



procedure TBarP.CanCP1BtnClick(Sender: TObject);
begin
  KeyR:=mrAbort;
end;


Procedure TBarP.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode;
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}

procedure TBarP.FormActivate(Sender: TObject);
begin
  If (Not RunningOk) then
  Begin
    Send_UpDateList(38);
    RunningOk:=BOn;
  end;
end;


procedure TBarP.ShutDown;

Begin
  PostMessage(Self.Handle,WM_Close,0,0);
end;


procedure TBarP.FormCreate(Sender: TObject);
begin
  RunningOk:=BOff;
end;

end.
