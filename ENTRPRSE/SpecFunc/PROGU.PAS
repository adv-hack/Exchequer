unit ProgU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ComCtrls, bkgroup;

type
  TGenProg = class(TForm)
    SBSBackGroup1: TSBSBackGroup;
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

  public
    { Public declarations }
    Aborted,
    WaitingMode  :  Boolean;

  end;

  procedure ClearRich;

  procedure Write_FixLogFmt(FileNo  :  Integer;
                            LM      :  String;
                            LMode  :  Byte);

  procedure Write_FixMsgFmt(LM     :  String;
                            LMode  :  Byte);

  procedure Write_FixLog(FileNo  :  Integer;LM  :  String);

  procedure Write_FixLogFilt(FileNo  :  Integer;LM  :  String);

  procedure Write_FixMsg(LM  :  String);

  Procedure Warn_NewHed(FileNo  :  Integer);

  Function Warn_Backup  :  Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  GlobVar,
  VarConst,
  ETStrU,
  BtrvU2,
  REMain,
  SFHeaderU,
  Untils;

{$R *.DFM}


Procedure TGenProg.Send_UpdateList(Mode   :  Integer);

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

    Send_UpDateList(10+Ord(WaitingMode));
  end;


end;

procedure TGenProg.FormCreate(Sender: TObject);
begin
  BeenFlg:=BOff;  Aborted:=BOff;
end;



procedure Write_FixLog(FileNo  :  Integer;LM  :  String);

Begin
  With TMainForm(Application.MainForm) do
  Begin
    Write_FixMsgFmt(FileNames[FileNo]+': '+Strip('A',[#0..#31,'\','/',#126..#255],Copy(LM,1,255)),0);

  end;

end;

procedure Write_FixLogFilt(FileNo  :  Integer;LM  :  String);

Begin
  With TMainForm(Application.MainForm) do
  Begin
    Write_FixLog(FileNo,Strip('A',[#0..#31,'\','/',#126..#255],Copy(LM,1,255)));

  end;

end;


procedure Write_FixLogFmt(FileNo  :  Integer;LM  :  String; LMode  :  Byte);

Begin
  With TMainForm(Application.MainForm) do
  Begin
    Write_FixMsgFmt(FileNames[FileNo]+': '+Strip('A',[#0..#31,'\','/',#126..#255],Copy(LM,1,255)),LMode);

  end;

end;


procedure ClearRich;

Begin
  With TMainForm(Application.MainForm) do
  Begin
    RichEdit1.Clear;

  end;

end;


procedure Write_FixMsg(LM  :  String);

Begin
  With TMainForm(Application.MainForm) do
  Begin
    Write_FixMsgFmt(LM,0);

  end;

end;




procedure Write_FixMsgFmt(LM     :  String;
                          LMode  :  Byte);
Begin
  With TMainForm(Application.MainForm) do
  Begin
    WriteToOutput(LM,(LMode<>0));

    Case LMode of
      1  :  SetOutputStyle(osNormal);
      2  :  SetOutputStyle(osSubHeader);
      3  :  SetOutputStyle(osInfo);
      4  :  SetOutputStyle(osWarning);
      5  :  SetOutputStyle(osList);
    end;
  end;

end;


{ =================== Message to Warn Header re written ============== }

Procedure Warn_NewHed(FileNo  :  Integer);


Begin

  ShowMessage(' - WARNING! - '+#13+
              FileNames[FileNo]+' is corrupt.'+#13+
              'You will need to restore the backup before attempting'+#13+
              'to use Exchequer');

end;



Function Warn_Backup  :  Boolean;

Var
  mbRet  :  Word;

Begin
  mbRet:=MessageDlg('Please confirm you have taken a backup',mtConfirmation, [mbYes, mbNo], 0);

  Result:=(mbRet=mrYes);

end;






end.
