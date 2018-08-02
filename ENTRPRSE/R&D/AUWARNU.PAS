unit AUWarnU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, Buttons, Mask,
  Globvar,Varconst, VarRec2U;

type
  TAuthWarnForm = class(TForm)
    SBSPanel1: TSBSPanel;
    Label81: Label8;
    Label82: Label8;
    SBSPanel2: TSBSPanel;
    CLMsgL: Label8;
    Label86: Label8;
    Image1: TImage;
    Label83: Label8;
    SCodeF: Text8Pt;
    Label84: Label8;
    DescF: Text8Pt;
    ExplainLab: Label8;
    OKCP1Btn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SCodeFExit(Sender: TObject);
    procedure DescFExit(Sender: TObject);
  private
    { Private declarations }
    GotUser,
    GotPWord     :  Boolean;
    AuthUser     :  tPassDefType;

  public
    { Public declarations }
    AuthRequired :  Double;
    Authorised,
    AuthMode     :  Boolean;

    EntryRec2    :  PassEntryType;

  end;


  Function Check_UserAuthorisation(Owner  :  TWinControl;
                                   InvR  :  InvRec;
                               Var AuthBy:  Str10)  :  Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  BtrvU2,
  BTKeys1U,
  CrypTo,
  PassWR2U,
  CurrncyU,
  BTSupU2;

{$R *.DFM}

procedure TAuthWarnForm.FormCreate(Sender: TObject);

Const
  ExClamName  :  Array[BOff..BOn] of PChar = ('EXCLAM_2','EXCLAM_3');

Var
  BMap1       :  TBitMap;

  RectD       :  TRect;
begin
  ClientHeight:=259;
  ClientWidth:=275;


  BMap1:=TBitMap.Create;

  BMap1.Handle:=LoadBitMap(HInstance,ExClamName[BOff]);

  With BMap1 do
    RectD:=Rect(0,0,Width,Height);


  With Image1.Picture.Bitmap do
  Begin
    Width:=BMap1.Width;
    Height:=BMap1.Height;

    Canvas.Brush.Color:=clBtnFace;
    Canvas.BrushCopy(RectD,BMap1,RectD,clSilver);
  end;

  BMap1.Free;

  ExplainLab.Caption:='The value of this transaction exceeds your authorisation limit.'+#13+
                      'You must seek further authorisation from another user, or reduce its value.';

  GotUser:=BOff; GotPWord:=BOff;

  Blank(AuthUser,Sizeof(AuthUser));
  Blank(EntryRec2,Sizeof(EntryRec2));
  Authorised:=BOff;
  AuthMode:=BOff;
end;

procedure TAuthWarnForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TAuthWarnForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TAuthWarnForm.SCodeFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  KeyS       :  Str255;

begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>OKCP1Btn) then
    Begin

      StillEdit:=BOn;

      {$B-}
        KeyS:=FullPWordKey(PassUCode,Chr(0),FoundCode);

        Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,PWK,KeyS);

        GotUser:=StatusOk;

        If (StatusOk)  then
        Begin
          EntryRec2:=PassWord.PassEntryRec;
          AuthUser:=Get_PWDefaults(FoundCode);

        end;



      {$B+}

      If (Not GotUser) and (CanFocus) then
      Begin
        SetFocus;
      end; {If not found..}
    end;


  end; {with..}
end;




procedure TAuthWarnForm.DescFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  UserAuthorisation
             :  Double;



begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=UpCaseStr(Strip('B',[#32],Text));

    If (FoundCode<>'') then
    Begin

      StillEdit:=BOn;

      ChangeCryptoKey(23130);

      With EntryRec2 do
        GotPWord:=(Strip('B',[#32],DeCode(PWord))=FoundCode);

                        

      If (GotPWord) then
      With AuthUser do
      Begin
        If (AuthMode) then
          UserAuthorisation:=MaxSalesA
        else
          UserAuthorisation:=MaxPurchA;

        {Check auth value}

        Authorised:=(AuthRequired<=UserAuthorisation) or (UserAuthorisation=0.0);

        If (Not Authorised) then
          ShowMessage(Trim(SCodeF.Text)+' does not have sufficient authorisation for this transaction.');

      end
      else
        If (CanFocus) then
        Begin
          SetFocus;
        end; {If not found..}
    end;


  end; {with..}
end;


{ == Check Authorisation Level == }

Function Check_UserAuthorisation(Owner  :  TWinControl;
                                 InvR  :  InvRec;
                             Var AuthBy:  Str10)  :  Boolean;

Var
  UserAuthorisation,
  RequiredAmount  :  Double;

  DCnst           :  Integer;

Begin
  AuthBy:='';

  With InvR,UserProfile^ do
    If (InvDocHed In SalesSplit) then
      UserAuthorisation:=MaxSalesA
    else
      UserAuthorisation:=MaxPurchA;

  If (InvR.InvDocHed In CreditSet+DeliverSet) then
    DCnst:=-1
  else
    DCnst:=1;


  If (UserAuthorisation<>0.0) then
    RequiredAmount:=ConvCurrITotal(InvR,BOff,BOn,BOn) * DCnst
  else
    RequiredAmount:=0.0;

                                                                           {* Amount already authorised *}
  Result:=(RequiredAmount<=UserAuthorisation) or (UserAuthorisation=0.0) or (RequiredAmount<=(InvR.AuthAmnt* DCnst)) or
          (Not Syss.UsePasswords);

  If (Not Result) then
  With TAuthWarnForm.Create(Owner) do
  try
    Begin
      WindowState:=wsNormal;

      AuthRequired:=RequiredAmount;
      AuthMode:=InvR.InvDocHed In SalesSplit;

      ShowModal;

      Result:=Authorised;
      AuthBy:=EntryRec2.Login;
    end;
  finally
    Free;

  end; {Try..}
end;


end.
