unit BPWarnUU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,GlobVar,VarConst;

type
  TWarnUsrs = class(TForm)
    lvList: TListView;
    Label1: TLabel;
    btnOK: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    iCounter : integer;
  public
    { Public declarations }
    bpMode   : Boolean;
    MyUsrNo  : LongInt;

    procedure BuildList;

  end;

  Procedure Show_LIUsers(SPMode  :  Boolean;
                         UsrNo   :  LongInt);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  BTKeys1U,
  BTSupU1,
  BTSFrmU1,
  BPyItemU;

{$R *.dfm}


procedure TWarnUsrs.Button1Click(Sender: TObject);
var
  sCounter : string;
begin
  sCounter := IntToStr(iCounter);
  with lvList.Items.Add do begin
    Caption := 'User #' + sCounter;
    SubItems.Add(sCounter + '/12/2002');
    SubItems.Add(sCounter + ':24:45');
    SubItems.Add('NeilFrewerV' + sCounter);
    SubItems.Add('NeilsCPU' + sCounter);
  end;
  inc(iCounter);
end;

procedure TWarnUsrs.FormCreate(Sender: TObject);
begin
  iCounter := 1;

end;

{ == Proc to display other users == }

procedure TWarnUsrs.BuildList;

Const
  Fnum     =  PWrdF;
  Keypath  =  PWK;

Var
  TmpPWord  :  PassWordRec;

  FoundOk   :  Boolean;

  BCode,
  TKeypath,
  B_Func,
  TmpStat   :  Integer;
  LAddr,
  TmpRecAddr:  LongInt;

  KeyChk,
  KeyS      :  Str255;


Begin
  TmpPWord:=PassWord;

  TKeypath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TKeypath,F[Fnum],TmpRecAddr,BOff,BOff);

  KeyChk:=BACSUsrKey2(bpMode);


  KeyS:=KeyChk;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  FoundOk:=BOff;

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
  With PassWord.BACSURec do
  Begin
    Application.ProcessMessages;

    B_Func:=B_GetNext;

    If (LIUCount<>MyUsrNo) then
    Begin
      BCode:=Try_Lock(B_GetDirect,B_SingNWLock+B_MultLock,KeyS,Keypath,Fnum,RecPtr[Fnum]);

      FoundOk:=(BCode = 84) or (BCode=85);


      If (BCode=0) then
      Begin {If are tidying up and its not us then get rid of it}
        GetPos(F[Fnum],Fnum,LAddr);

        Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
      end
      else
        If (FoundOk) then
        with lvList.Items.Add do
        begin
          Caption := OpoName;
          SubItems.Add(PoutDate(StartDate));
          SubItems.Add(StartTime);
          SubItems.Add(WINLogName);
          SubItems.Add(WINCPUName);
        end;

    end;

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end;

  TmpStat:=Presrv_BTPos(Fnum,TKeypath,F[Fnum],TmpRecAddr,BOn,BOff);

  PassWord:=TmpPWord;
end; {Proc..}


Procedure Show_LIUsers(SPMode  :  Boolean;
                       UsrNo   :  LongInt);

Begin
  With TWarnUsrs.Create(Application.MainForm) do
  Try
    bpMode:=SPMode;
    MyUsrNo:=UsrNo;
    BuildList;
    ShowModal;

  Finally
    Free;

  end;

end;


end.
