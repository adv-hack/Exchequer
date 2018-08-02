unit Teditdte;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  AltDlgs,Forms, StdCtrls, Mask,EtDateU;

type
  TEditDate= class(TMaskEdit)
  private
    { Private declarations }

    FStoreDate  :  String[10];

    ValidOk     :  Boolean;

    Procedure SetDateVal(FVal  :  String[10]);

    procedure CMExit(var Message: TCMExit);   message CM_EXIT;

  protected
    { Protected declarations }

    procedure KeyPress(var Key: Char); override;

  public
    { Public declarations }


    constructor Create(AOwner:TComponent); Override;

    Procedure ValidateEdit;

  published
    { Published declarations }

    property DateValue  : String[10] read FStoreDate write SetDateVal;

  end;

procedure Register;

implementation

constructor TEditDate.Create(AOwner:TComponent);
begin
  Inherited Create(AOwner);
  EditMask:='00/00/0000;0;';
  MaxLength:=10;
  ValidOk:=False;
end;

Procedure TEditDate.ValidateEdit;

Var
  p   :  Integer;
  mbRet
      :  Word;

  dw,mw,yw
      :  Word;

Begin

  DateStr(Date2Store(EditText),dw,mw,yw);


  ValidOk:=((mw>0) and (mw<=12));

  If (ValidOk) then
    ValidOk:=((dw>0) and (dw<=Monthdays[mw));

  If (Not ValidOk) then
  Begin
    mbRet:=AltMessageDlg(EditText+' is not a valid date.',mtError,[mbok],0);
    EditText:=Text;
    SetFocus;
    SetCursor(0);
  end;

end;



Procedure TEditDate.SetDateVal(FVal  :  String[10]);

Begin
  FStoreDate:=FVal;


  Text:=PBareOutDate(FVal);
end;

procedure TEditDate.KeyPress(var Key: Char);

TmpDte    :  TDateTime;
dw,mw,yw  :  Word;

begin

  If ((Key In ['+','-']) then
  Begin

    ValidateEdit;

    If (ValidOk) then
    Begin
      DateStr(Date2Store(EditText),dw,mw,yw);

      TmpDtw:=EncodeDate(yw,mw,dw);

      TmpDtw:=TmpDtw+(Ord(Key='+'))-(Ord(Key='-'));

      DecodeDate(TmpDtw,yw,mw,dw);

      DateValue:=StrDate(yw,mw,dw);


    end;

    Key:=#0;
  end;

  inherited KeyPress(Key);

end;

procedure TEditDate.CMExit(var Message: TCMExit);
Var
  TmpStr  :  String[50];

begin

  ValidateEdit;

  If (ValidOk) then
  Begin
    TmpStr:=Text;

    DateValue:=Date2Store(TmpStr);

    inherited;
  end;
end;


procedure Register;
begin
  RegisterComponents('Additional', [TEditDate]);
end;

end.
