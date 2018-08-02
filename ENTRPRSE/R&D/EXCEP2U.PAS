unit Excep2U;

{$I DEFOVR.Inc}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel, GlobVar, VarConst;

Var
  UserLogFN :  String;

{$IFDEF SY}

type
  TErrorLogFrm = class(TForm)
    Memo1: TMemo;
    SBSPanel1: TSBSPanel;
    PBtn: TButton;
    DBtn: TButton;
    GBtn: TButton;
    ClsBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure GBtnClick(Sender: TObject);
    procedure ClsBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PBtnClick(Sender: TObject);
  private
    { Private declarations }
    LogCount  :  Integer;

    Procedure BuildMemo(SearchRec  :  TSearchRec;
                        FirstGo    :  Boolean);

    Procedure BuildList(BMode  :  Byte);

    Procedure Send_UpdateList(Mode   :  Integer);

  public
    { Public declarations }
  end;


Const
  LogDirN  :  String =  'LOGS\';



Function GetTempLogFName(SwapName :  Str10)  :  Str255;


Function AddLog(Msg1,Msg2,FileN  :  ANSIString;
                Catagory         :  Byte)  :  Boolean;

Procedure Reset_EntLogOn;

{$ENDIF}

Procedure AddErrorLog(Msg1,Msg2  :  ANSIString;
                      Cat        :  Byte);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  FileCtrl,ETStrU, ExThrd2U,
  Excep3U,
  BTSupU1

  {$IFDEF Frm}
    ,PrintFrm
  {$ENDIF}

  {$IFDEF Rp}
   ,RPDefine,
    RPDevice,
    ReportHU;
  {$ELSE}
    ;
  {$ENDIF}




{$R *.DFM}




Var
  BeenWarned  :  Boolean;

{$IFDEF SY}

procedure TErrorLogFrm.FormCreate(Sender: TObject);
begin
  ClientHeight:=349;
  ClientWidth:=440;
  
  BuildList(0);

  With Memo1, Lines do
  Begin
    Clear;

    If (LogCount>0) then
    Begin
      If (LogCount>1) then
        Add('There are '+IntToStr(LogCount)+' error logs.')
      else
        Add('There is one error log.');

      Add('');
      Add('Please click on the Get button to view the error logs.');
    end
    else
    Begin
      Add('There are no error logs available to view.');
      GBtn.Enabled:=BOff;
    end;
  end;
end;


Procedure TErrorLogFrm.BuildMemo(SearchRec  :  TSearchRec;
                                 FirstGo    :  Boolean);

Var
  FileH  :  TextFile;
  ChkIO  :  Integer;

  E      :  Exception;

  mbRet  :  Word;

  FileOk :  Boolean;

  Line   :  String;

Begin
  {I+}

  Try
    With Memo1,Lines do
    Begin
      If (FirstGo) then
        Clear;

      AssignFile(FileH,SetDrive+LogDirN+SearchRec.Name);

      Reset(FileH);

      FileOk:=BOn;

      ReadLn(FileH,Line);

      While (FileOk) do
      Begin
        FileOk:=(Not EOF(FileH));

        Application.ProcessMessages;

        Add(Line);

        If (FileOk) then
          ReadLn(FileH,Line);

      end;

      CloseFile(FileH);

      Add(ConstStr('=',60));

    end; {With..}
  except
    On  E :  Exception do
    Begin
      mbRet:=MessageDlg('It was not possible to read the error log file '+SetDrive+LogDirN+SearchRec.Name+', due to the following error'+#13+#13+
                        E.Message,
                     mtWarning,[mbOk],0);
    end;

  end; {try..}

  {$I-}

end; {Proc..}


Procedure TErrorLogFrm.BuildList(BMode  :  Byte);

Var
  SearchRec  :   TSearchRec;
  FirstGo    :   Boolean;
  ChkIO      :   Integer;
  mbRet      :   Word;
  UserFN     :   String;

Begin
  {$I-}

  mbRet:=mrNone;

  Try
    ChkIO:=FindFirst(SetDrive+LogDirN+'E*.Log',faAnyFile,SearchRec);

    FirstGo:=BOn;

    UserFN:=ExtractFileName(UserLogFN);

    While (ChkIO=0)  and (IOResult=0) and (mbRet<>mrAbort) do
    Begin
      Application.ProcessMessages;

      If (SearchRec.Name<>UserFN) then {* Ignore the current log.*}
      Begin
        Case BMode of
          0  :  Inc(LogCount);

          1  :  Begin
                  BuildMemo(SearchRec,FirstGo);
                end;


          2  :  Begin
                  FileSetAttr(SetDrive+LogDirN+SearchRec.Name,0);

                  If Not DeleteFile(SetDrive+LogDirN+SearchRec.Name) then
                  Begin
                    mbRet:=MessageDlg('It was not possible to delete '+SetDrive+LogDirN+SearchRec.Name,
                       mtWarning,[mbOk,mbAbort],0);
                  end;
                end;

        end; {Case..}

        FirstGo:=BOff;
      end;

      If (mbRet<>mrAbort) then
        ChkIO:=FindNext(SearchRec);

    end; {While..}

    If (BMode<>0) then
      GBtn.Enabled:=BOff;

    If (BMode In [1,2]) then
    Begin
      PBtn.Enabled:=(BMode =1);
      DBtn.Enabled:=(BMode=1);
    end;

  Finally

    FindClose(SearchRec);

  end; {try..}

  {$I+}
end;


procedure TErrorLogFrm.GBtnClick(Sender: TObject);

Var
  DelMode  :  Boolean;

begin
  DelMode:=(Sender=DBtn);

  BuildList(1+Ord(DelMode));

  If (DelMode) then
    SendMessage(Self.Handle,WM_Close,0,0);
end;

procedure TErrorLogFrm.ClsBtnClick(Sender: TObject);
begin
  Close;
end;

{ == Function to count up to 100 error logs == }

Function Count_ErrorLogs(FilePattern  :  Str255)  :  Integer;

Var
  FoundFile  :  TSearchRec;

  FStat      :  Integer;


Begin
  Result:=0;

  FillChar(Foundfile,Sizeof(Foundfile),#0);

  FStat:=FindFirst(FilePattern,0,FoundFile);

  Try
    While (FStat=0) and (Result<=100) and (Not BeenWarned) do
    Begin
      Inc(Result);

      FStat:=FindNext(FoundFile);
    end;
  finally
    FindClose(FoundFile);
  end;  
end;

{ ============= Function to Return Next Available Swap File Name, For MultiUser reasons =============== }

Function GetTempLogFName(SwapName :  Str10)  :  Str255;

Const
  SwapDefaultExt  =  '.Log';

Var
  ThisUserNo,
  n,IOChk     :  Integer;

  SwapFileName:  Str255;
  NumStr      :  Str10;

Begin
  {$I-}

  n:=1;

  Randomize;

  ThisUserNo:=Random(999);

  Repeat

    Str(n:0,NumStr);

    SwapFileName:=SwapName+NumStr+Form_Int(ThisUserNo,0)+SwapDefaultExt;

    Inc(n);

  Until (Not FileExists(SetDrive+SwapFileName)) or (n>9999);

  {$I+}

  Result:=SetDrive+SwapFileName;

  n:=Count_ErrorLogs(SetDrive+SwapName+'*'+SwapDefaultExt);

  If (n>100) and (Not BeenWarned) then
  Begin
    Set_BackThreadMVisible(BOn);

    ShowMessage('There are many error log files.'+#13+'Please contact your supplier to review and delete them.');

    Set_BackThreadMVisible(BOff);

    BeenWarned:=BOn;
  end;

end; {Func..}



Function AddLog(Msg1,Msg2,FileN  :  ANSIString;
                Catagory         :  Byte)  :  Boolean;

Const
  CatMsg  :  Array[0..4] of String = ('System generated error.','Warning. Program was not shutdown correctly.','For your information.','Btrieve Database error.','Posting Run Error.');

Var
  ChkIO    :  Integer;
  Ok2Cont  :  Boolean;
  FileH    :  TextFile;

  E        :  Exception;

  mbRet    :  Word;

Begin
  {$I-}
  Try
    Ok2Cont:=BOn;

    If (Not DirectoryExists(SetDrive+LogDirN)) then
    Begin
      MkDir(SetDrive+LogDirN);

      ChkIO:=IOResult;

      Ok2Cont:=CheckIOError(ChkIO,'Unable to create directory '+SetDrive+LogDirN);

      {ChkIO:=FileSetAttr(SetDrive+LogDirN,FAHidden); Don't bother hiding directory, as sometimes seems to hide main dir!}

    end;

    If (Ok2Cont) then
    Begin
      AssignFile(FileH,SetDrive+LogDirN+FileN);

      ReWrite(FileH);

      Ok2Cont:=CheckIOError(IOResult,'Unable to create file '+SetDrive+LogDirN+FileN);

      Writeln(FileH,'Program. Version : ',Ver);
      Writeln(FileH,ParamStr(0));

      Writeln(FileH,DateTimeToStr(Now),'. User : '+EntryRec^.Login+' Company : '+Syss.UserName);

      Writeln(FileH,ConstStr('-',80));

      Writeln(FileH,'Log Type : ',CatMsg[Catagory]);
      Writeln(FileH,'');

      WriteLn(FileH,Msg1);
      WriteLn(FileH,Msg2);

      Ok2Cont:=CheckIOError(IOResult,'Writing to file '+SetDrive+LogDirN+FileN);

      CloseFile(FileH);

      Ok2Cont:=CheckIOError(IOResult,'Closing file '+SetDrive+LogDirN+FileN);


      ChkIO:=FileSetAttr(SetDrive+LogDirN+FileN,FAHidden or FAReadOnly or FASysFile);

    end;


  except

    On  E :  EInOutError do
    Begin
      Ok2Cont:=BOff;
      Set_BackThreadMVisible(BOn);

      mbRet:=MessageDlg('It was not possible to generate an error log due to the following error'+#13+#13+
                        E.Message,
                     mtWarning,[mbOk],0);

      Set_BackThreadMVisible(BOff);

    end;


  end;

  Result:=Ok2Cont;

  {$I+}

end;



Procedure AddErrorLog(Msg1,Msg2  :  ANSIString;
                      Cat        :  Byte);

Begin
  AddLog(Msg1,Msg2,ExtractFileName(GetTempLogFName(LogDirN+'E')),Cat);
end;


{ == Procedure to Send Message to Get Record == }

Procedure TErrorLogFrm.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_FormCloseMsg;
    WParam:=Mode;
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


procedure TErrorLogFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:=caFree;

end;


procedure TErrorLogFrm.FormCloseQuery(Sender  : TObject;
                                  var CanClose: Boolean);
begin
  Send_UpdateList(64);
end;



procedure TErrorLogFrm.PBtnClick(Sender: TObject);

{$IFDEF Rp}

Var
  RFont      :  TFont;
  ROrient    :  TOrientation;

  RDevRec    :  TSBSPrintSetupInfo;

  Ok2Print   :  Boolean;

  SMemo      :  TStringList;

  n          :  Integer;


begin
  RFont:=TFont.Create;

  try
    RFont.Assign(Application.MainForm.Font);

    ROrient:=RPDefine.PoPortrait;

    {$IFDEF Frm}
      Ok2Print:=pfSelectPrinter(RDevRec,RFont,ROrient);
    {$ELSE}
      Ok2Print:=BOff;
    {$ENDIF}

    If (Ok2Print) then
    Begin
      SMemo:=TStringList.Create;
      Try

        For n:=0 to Pred(Memo1.Lines.Count) do
          SMemo.Add(Memo1.Lines[n]);

        AddMemoRep2Thread(RDevRec,SMemo,'Error Log',Application.MainForm);

      Finally;
        SMemo.Free;
      end;

    end;

  Finally
    RFont.Free;
  end;


{$ELSE}

Begin

{$ENDIF}

end;


Procedure Reset_EntLogOn;


Begin
  {* Attempt to remove last record of logging in *}

  FileSetAttr(UserLogFN,0);
  DeleteFile(UserLogFN);

end;


{$ELSE}
  Procedure AddErrorLog(Msg1,Msg2  :  ANSIString;
                        Cat        :  Byte);

  Begin

  end;


{$ENDIF}






Initialization

  UserLogFN:='';
  BeenWarned:=BOff;

end.
