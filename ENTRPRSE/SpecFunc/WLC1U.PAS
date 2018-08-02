unit Wlc1U;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Buttons, bkgroup, ExtCtrls, SBSPanel, AccelLbl;

type
  TOpenForm = class(TForm)
    SBSBackGroup1: TSBSBackGroup;
    Label81: Label8;
    Wiz1OkBtn: TButton;
    Image1: TImage;
    SBSPanel1: TSBSPanel;
    Label82: Label8;
    OpenButton: TSpeedButton;
    SBSPanel2: TSBSPanel;
    FAddBtn: TSpeedButton;
    Label83: Label8;
    SBSAccelLabel1: TSBSAccelLabel;
    SBSAccelLabel2: TSBSAccelLabel;
    procedure OpenButtonClick(Sender: TObject);
    procedure SBSAccelLabel1Accel(Sender: TObject; AccChar: Char);
    procedure SBSAccelLabel2Accel(Sender: TObject; AccChar: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    Procedure Send_UpdateList(Mode   :  Integer);

  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  GlobVar,
  VarFPosU,
  Untils;

{$R *.DFM}




Procedure TOpenForm.Send_UpdateList(Mode   :  Integer);
Var
  Message1 :  TMessage;
Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode;
    LParam:=0;
  end;

  With Message1 do SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);
end; {Proc..}



procedure TOpenForm.OpenButtonClick(Sender: TObject);
begin
  Send_UpdateList(300+Ord(Sender=FAddBtn)+Ord(Sender=SBSPanel2)+Ord(Sender=Label83));
  PostMessage(Self.Handle,WM_Close,0,0);
end;


procedure TOpenForm.SBSAccelLabel1Accel(Sender: TObject; AccChar: Char);
begin
  OpenButtonClick(OpenButton);
end;

procedure TOpenForm.SBSAccelLabel2Accel(Sender: TObject; AccChar: Char);
begin
  OpenButtonClick(FAddBtn);

end;

procedure TOpenForm.FormCreate(Sender: TObject);
begin
  {$IFDEF WCBuild}
    SBSPanel2.Visible:=TRUE;
  {$ELSE}
    SBSPanel2.Visible:=GotDailyPW;
  {$ENDIF}
end;

end.
