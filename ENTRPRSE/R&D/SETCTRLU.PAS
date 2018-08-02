unit SetCtrlU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel,
  GlobVar,VarConst;

type
  TSettleForm = class(TForm)
    SetPanel: TSBSPanel;
    CanCP1Btn: TButton;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    PrevHState  :  Boolean;
    
    fMode       :  Byte;

    fFnum,
    fKeypath    :  Integer;

    fMainK      :  Str255;

    fPayInv     :  InvRec;



  public
    { Public declarations }

    Procedure Prime_Settle(Fnum,
                           Keypath  :  Integer;
                           MainK    :  Str255;
                           PayInv   :  InvRec;
                           Mode     :  Byte);

  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  BTSupU1,
  LedgSu2U;

{$R *.DFM}



Procedure TSettleForm.Prime_Settle(Fnum,
                                   Keypath  :  Integer;
                                   MainK    :  Str255;
                                   PayInv   :  InvRec;
                                   Mode     :  Byte);


Begin
  fKeyPath:=KeyPath;
  fFnum:=Fnum;
  fMainK:=MainK;
  fPayInv:=PayInv;
  fMode:=Mode;

  SetPanel.Caption:='Please Wait... Allocating Transactions';

  SetAllowHotKey(BOff,PrevHState);

  ShowModal;

  SetAllowHotKey(BOn,PrevHState);
end;

procedure TSettleForm.FormActivate(Sender: TObject);
begin
  Auto_Settle(fFnum,fKeypath,fMainK,fPayInv,fMode,Self);

  PostMEssage(Self.Handle,WM_Close,0,0);
end;

procedure TSettleForm.FormCreate(Sender: TObject);
begin
  ClientHeight:=104;
  ClientWidth:=236;

end;

end.
