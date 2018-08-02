unit ProgU;

{ markd6 17:09 06/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ComCtrls, bkgroup;

type
  TGenProg = class(TForm)
    ProgressBar1: TProgressBar;
    AbortBtn: TButton;
    ProgLab: Label8;
    Label81: Label8;
    procedure AbortBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    BeenFlg  :  Boolean;

    Procedure Send_UpdateList(Mode   :  Integer);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_User+1;

    Function RunUpgrade(UpNo      :  Integer;
                        Verbose   :  Boolean;
                        IntParam  :  Integer;
                        StrParam  :  String)  :  Integer;

    procedure Execute_Upgrades;

  public
    { Public declarations }
    Aborted,
    WaitingMode  :  Boolean;

  end;

Var
  UResult,
  UCount   :  Integer;

  { == Do we need to run it again == }

Function NeedToRunUpgrade(UPNo    :  Integer;
                          VerNo   :  String;
                      Var ErrStr  :  String;
                          ForceRun:  Boolean)  :  Boolean; STDCALL;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  GlobVar,
  VarConst,
  BtrvU2,
  CommonU,
  PWUpG1U,
  PWUpG2U,
  PWUpG3U,
  PWUpG4U,
  PWUpG5U,
  PWUpG6U,
  PWUpG7U,
  PwUpgrade,
  UserDefinedFieldUpgrade;

{$R *.DFM}


{ == Do we need to run it again == }

Function NeedToRunUpgrade(UPNo    :  Integer;
                          VerNo   :  String;
                      Var ErrStr  :  String;
                          ForceRun:  Boolean)  :  Boolean;

Begin
  Case UPNo of
    1  :  Result:=NeedToRunv432(ErrStr,TotalProgress,ForceRun);
    2  :  Result:=NeedToRunv440(ErrStr,TotalProgress,ForceRun);
    3  :  Result:=NeedToRunv550(ErrStr,TotalProgress,ForceRun);
    4  :  Result:=NeedToRunv552(ErrStr,TotalProgress,ForceRun);
    5  :  Result:=NeedToRunv560(ErrStr,TotalProgress,ForceRun);
    6  :  Result:=NeedToRunv570(ErrStr,TotalProgress,ForceRun);
    7  :  Result:=NeedToRunvLTE(ErrStr,TotalProgress,ForceRun);

    else //PR 23/01/2009 Add generic function for 6.01 and later (in PwUpgrade.pas)
      Result:=NeedToUpgradePermissions(UpNo, ErrStr, TotalProgress,ForceRun);

  end; {Case..}

end;



Procedure TGenProg.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_User+1;
    WParam:=Mode;
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


procedure TGenProg.AbortBtnClick(Sender: TObject);
Var
 mbRet  :  Word;

begin
  mbRet:=MessageDlg('Please confirm you wish to abort this rebuild',mtConfirmation, [mbYes, mbNo], 0);

  If (mbRet=mrYes) then
  Begin

    AbortBtn.Enabled:=BOff;
    ProgLab.Caption:='Please Wait... Aborting.';

    Aborted:=BOn;

    Send_UpDateList(99);
  end;
end;

procedure TGenProg.FormActivate(Sender: TObject);
begin
  If (Not BeenFlg) then
  Begin
    BeenFlg:=BOn;

    PostMessage(Self.Handle,WM_User+1,1,0);
  end;


end;

procedure TGenProg.FormCreate(Sender: TObject);
begin
  BeenFlg:=BOff;  Aborted:=BOff;
end;

Function TGenProg.RunUpgrade(UpNo      :  Integer;
                             Verbose   :  Boolean;
                             IntParam  :  Integer;
                             StrParam  :  String)  :  Integer;
var
 UpgradeUDFields : TUDFUpgrade;
 errStr : string;
 progress : integer;
Begin
  Case UpNo of
    1  :  Result:=SetPWord_v432(Verbose,ProgressBar1);
    2  :  Result:=SetPWord_v440(Verbose,ProgressBar1);
    3  :  Result:=SetPWord_v550(Verbose,ProgressBar1);
    4  :  Result:=SetPWord_v552(Verbose,ProgressBar1);
    5  :  Result:=SetPWord_v560(Verbose,ProgressBar1);
    6  :  Result:=SetPWord_v570(Verbose,ProgressBar1);
    7  :  Result:=SetPWord_vLTE(Verbose,ProgressBar1);
    else  //PR 23/01/2009 Add generic function for 6.01 and later (in PwUpgrade.pas)
    begin
      //TW 19/10/2011 v6.9: Migrate old data from exchqss to new custom fields table.
      UpgradeUDFields := TUDFUpgrade.Create;

      try
        //PR: 20/05/2014 ABSEXCH-15304 TW set ForceRun parameter to True which caused the
        //                             user field upgrade to run regardless. Change to False.
        if (UpNo >= 10) and (NeedToUpgradePermissions(10, errStr, progress, False)) then
          result := UpgradeUDFields.InitialiseUpgrade
        else
          result := 0;

        if(result <> 0) then
          MessageDlg('Error updating custom fields settings. Error: ' + IntToStr(result),
           mtError,[mbOk],0);
      finally
        UpgradeUDFields.Free;
      end;

      if (result = 0) then
        Result := SetPermissions(UpNo, Verbose, ProgressBar1);
    end;
  end; {case..}

end;


procedure TGenProg.Execute_Upgrades;

Begin
  For UCount:=1 to High(UpgradeList) do
  Begin
    If (UpgradeList[UCount].RunIt) then
    Begin
      ProgLab.Caption:='Processing '+UpgradeList[UCount].ErrStr;
      UResult:=RunUpgrade(UCount,True,0,CtrlUpgrade.VerNo);

      If (UResult<>0) then
        Break;
    end;

  end;

  ModalResult:=mrOk;

  PostMessage(Self.Handle,WM_Close,0,0);

end;

Procedure TGenProg.WMCustGetRec(Var Message  :  TMessage);

Begin
  With Message do
  Begin
    Case WParam of
      1  : Begin
             ProgressBar1.Max:=TotalProgress;

             Execute_Upgrades;
           end;

    end; {Case..}

  end;
end;

Begin
  UResult:=0; UCount:=0;

end.
