unit InHU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, bkgroup, Animate, ExtCtrls, SBSPanel, Untils, ComCtrls;

type
  TInHForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    OkCP1Btn: TButton;
    ClsCP1Btn: TButton;
    SBSPanel4: TSBSBackGroup;
    TitlePnl: TPanel;
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
     
      Procedure WMCustGetRec(Var Message  :  TMessage);  Message WM_CustGetRec;



    public
      { Public declarations }
      KeyR        :  TModalResult;

       Procedure Send_UpdateList(Mode   :  Integer);

      procedure ShutDown;
  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  GlobVar;

{$R *.DFM}


Procedure TInHForm.WMCustGetRec(Var Message  :  TMessage);

Begin
  With Message do
  Begin


    Case WParam of

      0
         :  Begin

            end;


    end; {Case..}

  end; {With..}

  Inherited;

end;



Procedure TInHForm.Send_UpdateList(Mode   :  Integer);

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

procedure TInHForm.ShutDown;

Begin
  PostMessage(Self.Handle,WM_Close,0,0);
end;




procedure TInHForm.OkCP1BtnClick(Sender: TObject);
begin
  ShutDown;

  
end;

procedure TInHForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TInHForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TInHForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
  If (Tag<>0) then
    Send_UpDateList(Tag);
end;

end.
