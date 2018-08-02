unit Untils;


interface

Uses
  Windows,
  Messages,
  Graphics,
  WinTypes,
  Classes,
  Controls,
  StdCtrls,
  ComCtrls,
  Forms,
  GlobVar;



Const
  WM_CustGetRec    =  WM_User+$1;

  CompRegKey1  = '\System\CurrentControlSet\Services\NWlnkIpx\NetConfig';
  CompRegKey3  = '\System\CurrentControlSet\Services\NWlnkIpx\Parameters';
  CompRegTest  = '\System\CurrentControlSet\Control\keyboard layouts';

  BTProtocols  :  Array[0..4] of Str20 = ('Not Set!','SPX','TCPIP','SPX,TCPIP','TCPIP,SPX');

  BTRegKeys    :  Array[1..11] of Str30  = ('Max Files',
                                           'Max Handles',
                                           'Max Locks',
                                           'Create 5x Files',
                                           'Compression Buffer Size',
                                           'Systrans Bundle Limit',
                                           'Systrans Time Limit',
                                           'File Sharing On Remote Drives',
                                           'Local',
                                           'Requester',
                                           'Supported Protocols');

Var
  TakenCopy  :  Boolean;

Function Get_FreeResources  :  Integer;

Function Color_ResourceMon(Value  :  Integer)  :  TColor;

Procedure MDI_ForceParentBkGnd(WholeScreen  :  Boolean);


procedure GlobFormKeyDown(Sender : TObject;
                      var Key    : Word;
                          Shift  : TShiftState;
                          ActiveControl
                                 :  TWinControl;
                          Handle :  THandle);

procedure GlobFormKeyPress(Sender: TObject;
                       var Key   : Char;
                           ActiveControl
                                 :  TWinControl;
                           Handle:  THandle);

Function Get_OS_Vers  :  TOSVersionInfo;

Function Set_DetectOS  :  Integer;

Function IPXMaxPktSize(SetOn     :  Boolean;
                       WSOS,
                       NewVal    :  Integer;
                       CardName  :  Str255)  :  Integer;

Function IPXVirtualNo(SetOn     :  Boolean;
                      WSOS,
                      NewVal    :  Integer)  :  Integer;

Procedure GetWin95RegVers(Var SVI,
                              Vers,
                              VN     :String);

Function GetWinSystemPath(IsNT  :  Boolean)  :  String;

Function NovellBSPX(SetOn,
                    UseTRing
                           :  Boolean;
                    FName  :  Str255)  :  Boolean;

Function ExtractOnlyFileName(FName  :  String)  :  String;


Function GetBTRegSettings(SetOn,
                          UseServer
                                 :  Boolean;
                          SetNo,
                          SetVal :  Integer)  :  Integer;

Function Srv_IsNT(OS  :  Integer)  :  Boolean;

Function Srv_IsNovell(OS  :  Integer)  :  Boolean;

Function WS_IsNovell(OS  :  Integer)  :  Boolean;

Function WS_IsNT(OS  :  Integer)  :  Boolean;


Function UpdateDLLIni (SetOn,
                       MCOn   :  Boolean;
                       FName,
                       FPath  :  Str255)  :  Boolean;

Function BT_LoadedOk(Var CSMode  :  Boolean)  :  Integer;

Function TimeVal : LongInt;


Function GLFileExists(GL  :  Byte)  :  Boolean;

Procedure WriteGL(GL  :  Byte);

Function DeleteGL(GL  :  Byte)  :  Boolean;

Function FmtTime(Tim    :  Double;
                 ShowU  :  Boolean)  :  Str80;


Function RestoreMastDat(RM  :  Byte;
                        Rest:  Boolean)  :  Boolean;

Procedure MDI_SetFormCoord(Var F  :  TForm);


Procedure Report_BError(Fnum,
                        ErrNo  :  Integer);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  SysUtils,
  Grids,
  TEditVal,
  BorBtns,
  ETDateU,
  ETStrU,
  ETMiscU,
  LocalVar,
  BtrvU2,
  PathUtil,
  Registry;


Const
    gfsr_SystemResources  = $0000;

Var
  _MyGetFreeSystemResources32  :  function(Mode  :  Integer)  :  Integer stdcall;
  _MyGSRHandle                 :  THandle;
  StartDate                    :  LongDate;

{ =============== Routines to manage resource monitoring =========== }

Procedure Init_ResourceMon;

Const
  ResNames  :  Array[0..1] of PChar = ('RSRC32','_MyGetFreeSystemResources32@4');

Var
  DLLAddr  :  TFarProc;

Begin
  _MyGetFreeSystemResources32:=nil;

  _MyGSRHandle:=LoadLibrary(ResNames[0]);

  try
    If (_MyGSRHandle>HInstance_Error) then
    Begin
      DLLAddr:=GetProcAddress(_MyGSRHandle,ResNames[1]);

      If (DLLAddr<>nil) then
        _MyGetFreeSystemResources32:=DLLAddr
      else
      Begin
        _MyGSRHandle:=0;
        FreeLibrary(_MyGSRHandle);
      end;
    end
    else
      _MyGSRHandle:=0;

  except

    FreeLibrary(_MyGSRHandle);
    _MyGSRHandle:=0;

    _MyGetFreeSystemResources32:=nil;


  end; {except..}

end; {Proc..}

Function Get_FreeResources  :  Integer;
Begin

  If (_MyGSRHandle<>0) then
    Result:=_MyGetFreeSystemResources32(gfsr_SystemResources)
  else
    Result:=100;
end;


Procedure Free_ResourceMon;
Begin
  If (_MyGSRHandle<>0) then
  Begin
    FreeLibrary(_MyGSRHandle);

    _MyGSRHandle:=0;

    _MyGetFreeSystemResources32:=nil;
  end;
end;

Function Color_ResourceMon(Value  :  Integer)  :  TColor;

Begin

  Case Value of



    0..20   :  Result:=clRed;

    21..35  :  Result:=$000080FF;

    36..50  :  Result:=clYellow;

    else       Result:=clLime;

  end; {Case..}


end;


Function GetMaxColors(Handle  :  HDC)  :  Integer;

Var
  TInt  :  Integer;

Begin

  TInt:=GetDeviceCaps(Handle,BITSPIXEL);

  Case TInt of

    4  :  Result:=0;
    8  :  Result:=1;
    16..256
       :  Result:=2;
    else  Result:=0;

  end;

end;


Procedure MDI_ForceParentBkGnd(WholeScreen  :  Boolean);
Var
  MForm  :  TForm;

Begin

  {$B-}

  If (Assigned(Application.MainForm)) and (GetMaxColors(Application.MainForm.Canvas.Handle) <2) then

  {$B+}

  Begin
    MForm:=TForm.Create(Application.MainForm);
    try
      With MForm do
      Begin
        If (WholeScreen) then
        Begin
          {FormStyle:=fsMDIChild;}
          Top:=1;
          Left:=1;
          Height:=Application.MainForm.ClientHeight+75;
          Width:=Application.MainForm.ClientWidth;
        end
        else
        Begin
          Top:=Application.MainForm.ClientHeight-10;
          Height:=1;
          Width:=1;
        end;

        BorderStyle:=bsNone;
        BorderIcons:=[];
        Show;
      end;
    finally
      Mform.Free;
    end;
  end;

end;


{ ================ Global Key handling routines =============== }

procedure GlobFormKeyPress(Sender: TObject;
                       var Key   : Char;
                           ActiveControl
                                 :  TWinControl;
                           Handle:  THandle);

Var
  IrqKey  :  Boolean;

begin
  IrqKey:=(True);

  If (ActiveControl is TSBSComboBox) then
    With (ActiveControl as TSBSComboBox) do
    Begin

      IrqKey:=(IrqKey and (Not InDropDown));

    end
    else
      If (ActiveControl is TStringGrid) or
         (ActiveControl is TUpDown) then
        IrqKey:=BOff;

  If ((Key=#13)  or (Key=#10)) and (IrqKey) then
  Begin

    Key:=#0;

  end;
end;

function GetNewTabIdx(PC  :  TPageControl;
                      KC  :  Word)  :  Integer;

{* Could not use, as VK_Home&End seem to be intercepted by list boxes *}
Begin

  Case KC of
    VK_Prior,
    VK_Next   :  With PC do
                   Result:=FindNextPage(ActivePage,(KC=VK_Next),BOn).PageIndex;

    VK_Home   :  Result:=0;
    VK_End    :  Result:=Pred(Pc.PageCount);
    else         Result:=PC.ActivePage.PageIndex;

  end;
end;


procedure ClickOk(Sender  :  TObject;
              Var VKey    :  Word);

Var
  n      :  Integer;
Begin
  If (Sender is TForm) then
    With TForm(Sender) do
    Begin
      For n:=0 to Pred(ComponentCount) do
        If (Components[n] is TButton) then
          With TButton(Components[n]) do
            If (Caption='&OK') and (Enabled) and (Visible) and (CanFocus) then
            Begin
              VKey:=0;
              Click;
              Exit
            end;


    end;

end;



procedure GlobFormKeyDown(Sender : TObject;
                      var Key    : Word;
                          Shift  : TShiftState;
                          ActiveControl
                                 :  TWinControl;
                          Handle :  THandle);

Var
  IrqKey  :  Boolean;
  TComp   :  TComponent;

begin

  IrqKey:=((Not (ssCtrl In Shift)) and (Not (ssAlt In Shift)) and (Not (ssShift In Shift)));

  If (ActiveControl is TSBSComboBox) then
    With (ActiveControl as TSBSComboBox) do
  Begin

    IrqKey:=(IrqKey and (Not InDropDown));

  end
  else
    If (ActiveControl is TStringGrid) or
       (ActiveControl is TUpDown) then
                                                                                 
      IrqKey:=BOff;


  If (IrqKey) then
  Case Key of


    VK_Up  :  Begin
                PostMessage(Handle,wm_NextDlgCtl,1,0);
                Key:=0;
              end;
    VK_Return,
    VK_Down
           :  Begin
                {If (Key=VK_Return) and (Not Syss.TxLateCr) then
                  Exit;}


                If ((Not (ActiveControl is TBorCheck)) and (Not(ActiveControl is TBorRadio))) or (Key=VK_Return) then
                Begin
                  PostMessage(Handle,wm_NextDlgCtl,0,0);
                  Key:=0;
                end
                else
                  Key:=Vk_Tab;

              end;

  end;

  If (Key In [VK_F2..VK_F12]) and (Not (ssAlt In Shift))  then
  Begin
    If (Key=VK_F9) then
    Begin
      If (ActiveControl is TComponent) then
      Begin
        TComp:=TComponent(ActiveControl);
        {LastValueObj.GetValue(TComp);}
        PostMessage(Handle,wm_NextDlgCtl,0,0);
      end;
    end
    else
      PostMessage(Application.MainForm.Handle,wm_KeyDown,Key,Ord((ssShift In Shift)));
  end;

  If (Key In [VK_Prior,VK_Next]) and (ssCtrl In Shift) then {* Select Next/Prev page of tabbed notebook *}
    PostMessage(Handle,wm_CustGetRec,175,Ord(Key=VK_Prior));

  If (Key In [VK_Home,VK_End]) and (ssAlt In Shift) then {* Jump straight to list body *}
    PostMessage(Handle,wm_CustGetRec,176,Ord(Key=VK_Home));

  If ((Key=VK_Return) and (ssCtrl In Shift)) then
    ClickOK(Sender,Key);

end;


{ ==== Function to determine if Winnt is running ==== }

Function Get_OS_Vers  :  TOSVersionInfo;


Var
  OSVerIRec
        :  TOSVersionInfo;


Begin
  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);

  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);

  GetVersionEx(OSVerIRec);

  Result:=OSVerIRec;

end;


Function Set_DetectOS  :  Integer;

Begin
  Result:=5;

  With Get_OS_Vers do
  Begin
    If (dwPlatformId=VER_PLATFORM_WIN32_WINDOWS) then
    Begin
      If (dwMajorVersion=4) then
          Result:=5
      else
        Result:=6;
    end
    else
      If (dwPlatformId=VER_PLATFORM_WIN32_NT) then
      Begin
        If (dwMajorVersion=3) then
          Result:=0
        else
          If (dwMajorVersion=4) then
            Result:=1
          else
            If (dwMajorVersion=5) then
              Result:=2
            else
              Result:=0;
      end
      else
        Result:=5;

  end; {With..}
end;



Function IPXMaxPktSize(SetOn     :  Boolean;
                       WSOS,
                       NewVal    :  Integer;
                       CardName  :  Str255)  :  Integer;

Var
  ThisReg  :  TRegistry;

Begin
  Result:=0;

  If (WSOS In [0..2,8]) and (Trim(CardName)<>'') then
  Begin
    ThisReg:=TRegistry.Create;

    Try
      With ThisReg do
      Begin
        RootKey:=HKey_Local_Machine;

        If OpenKey(CompRegKey1+'\'+CardName,BOff) then
        Begin
          If (SetOn) then
            WriteInteger('MaxPktSize',NewVal);

          Result:=ReadInteger('MaxPktSize');
        end;

      end; {finally..}
    Finally

      ThisReg.Free;
    end; {try..}
  end;
end;


Function IPXVirtualNo(SetOn     :  Boolean;
                      WSOS,
                      NewVal    :  Integer)  :  Integer;

Var
  ThisReg  :  TRegistry;

Begin
  Result:=0;

  If (WSOS In [0..2,8]) then
  Begin
    ThisReg:=TRegistry.Create;

    Try
      With ThisReg do
      Begin
        RootKey:=HKey_Local_Machine;

        If OpenKey(CompRegKey3,BOff) then
        Begin
          If (SetOn) then
            WriteInteger('VirtualNetworkNumber',NewVal);

          Result:=ReadInteger('VirtualNetworkNumber');
        end;

      end; {finally..}
    Finally

      ThisReg.Free;
    end; {try..}
  end;
end;



Procedure GetWin95RegVers(Var SVI,
                              Vers,
                              VN     :String);

Var
  ThisReg  :  TRegistry;

Begin
  SVI:=''; Vers:=''; VN:='';

  ThisReg:=TRegistry.Create;

  Try
    With ThisReg do
    Begin
      RootKey:=HKey_Local_Machine;

      If OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion',BOff) then
      Begin
        SVI:=ReadString('SubVersionNumber');
        Vers:=ReadString('Version');
        VN:=ReadString('VersionNumber');
      end;

    end; {finally..}
  Finally

    ThisReg.Free;
  end; {try..}
end;




Function GetWinSystemPath(IsNT  :  Boolean)  :  String;

Const
  RegKey  :  Array[BOff..BOn] of String = ('SOFTWARE\Microsoft\Windows\CurrentVersion','SOFTWARE\Microsoft\Windows NT\CurrentVersion');

Var
  ThisReg  :  TRegistry;

Begin
  ThisReg:=TRegistry.Create;

  Try
    With ThisReg do
    Begin
      RootKey:=HKey_Local_Machine;

      If OpenKey(RegKey[IsNT],BOff) then
      Begin
        Result:=ReadString('SystemRoot');
      end;

    end; {finally..}
  Finally

    ThisReg.Free;
  end; {try..}
end;



{$I-}


{ =========== Function to Check/Set BSPXCom Setting ============= }

Function NovellBSPX(SetOn,
                    UseTRing
                           :  Boolean;
                    FName  :  Str255)  :  Boolean;

Const
  Match1  =  'LOAD BSPXCOM';
  MatchE  =  '-r=1500';
  MatchT  =  '-r=4096';

Var
  F,FN       :  TextFile;
  Match2,
  ThatLine,
  ThisLine,
  MainPath,
  NewName    :  Str255;
  ChkEOF,
  TBo,
  HaveSet,
  NFOpen     :  Boolean;
  FP         :  LongInt;
  FAT        :  Integer;

  IOChk      :  SmallInt;

Begin

  Result:=BOff; HaveSet:=BOff; NFOpen:=BOff;
  MainPath:='';
  NewName:='';


  If (Trim(FName)<>'') then
  Begin

    If (UseTring) then
      Match2:=MatchT
    else
      Match2:=MatchE;

    FAT:=FileGetAttr(Fname);
    IOChk:=IOResult;

    FileSetAttr(Fname,0);
    IOChk:=IOResult;

    System.AssignFile(F,FName);

    System.Reset(F);

    IOChk:=IOResult;

    If (IOChk=0) and (SetON) then
    Begin
      MainPath:=ExtractFileDir(Fname);
      NewName:=MainPath+'\BSTART.NEW';

      System.AssignFile(FN,NewName);

      System.Rewrite(FN);

      IOChk:=IOResult;

      NFOpen:=IOChk=0;
    end;

    try

      If (IOChk=0) then
      Begin
        ReadLn(F,ThisLine);
        IOChk:=IOResult;
      end;


      FP:=0;
      ChkEOF:=BOff;


      While (Not ChkEOF) and (IOChk=0) and (Not Result) do
      Begin

        ChkEOF:=EOF(F);

        ThatLine:=UpCaseStr(ThisLine);

        If (Match_Glob(Length(ThatLine)+1,UpCaseStr(Match1),ThatLine,TBo)) then
        Begin
          Result:=Match_Glob(Length(ThatLine)+1,UpCaseStr(Match2),ThatLine,TBo);

          If (Not Result) and (SetOn) then
          Begin

            ThisLine:=ThisLine+' '+Match2;

            HaveSet:=BOn;
          end;

        end;


        If (SetOn) then
        Begin
          WriteLn(FN,ThisLine);
          IOChk:=IOResult;
        end;

        If (Not Result) and (IOChk=0) and (Not ChkEOF) then
        Begin
          ReadLn(F,ThisLine);
          IOChk:=IOResult;
        end;

      end;

    finally;

      System.Close(F);


      If (NFOpen) then
        System.Close(FN);

      If (SetOn) and (HaveSet) and (IOChk=0) then
      Begin
        If (DeleteFile(Fname)) then
          If (Not RenameFile(NewName,FName)) then
            ShowMessage('Error renaming '+NewName+' to '+Fname+#13+
                        'Please run Bsetup on your Novell Server, and reconfigure Btrieve as per EntRead.');
      end;

      FileSetAttr(Fname,FAT);
    end;


    If (HaveSet) and (SetOn) then {* Check it was ok..}
      Result:=NovellBSPX(BOff,UseTRing,FName);
  end;

end;


{$I+}


Function ExtractOnlyFileName(FName  :  String)  :  String;

Var
  FS  :  Str255;

Begin
  FS:=ExtractFileName(FName);

  If (Pos('.',FS)<>0) then
    Result:=Copy(FS,1,Length(FS)-4)
  else
    Result:=FS;
end;




Function RetBTProtocol(P  :  Str20)  :  Byte;

Var
  n        :  Byte;
  FoundOk  :  Boolean;
  
Begin
  Result:=0;

  FoundOk:=BOff;
  
  For n:=1 to 4 do
    If (P=BTProtocols[n]) then
    Begin
      FoundOk:=BOn;
      Break;
    end;

  If (FoundOk) then
    Result:=n;

end;


Function GetBTRegSettings(SetOn,
                          UseServer
                                 :  Boolean;
                          SetNo,
                          SetVal :  Integer)  :  Integer;

Const
  BTRegRoot  :  Array[BOff..BOn,BOff..BOn] of String = (('\SOFTWARE\Btrieve Technologies\Microkernel Workstation Engine\Version  6.15\Settings',
                                                         '\SOFTWARE\Btrieve Technologies\Microkernel Engine\Version  6.15\Server Edition\Settings'),
                                                       ('\SOFTWARE\Btrieve Technologies\Microkernel Workstation Engine\Version  6.15\Microkernel Interface\Settings',
                                                        '\SOFTWARE\Btrieve Technologies\Microkernel Engine\Version  6.15\Server Edition\Microkernel Interface\Settings'));

  BTProKey   =  'SOFTWARE\Btrieve Technologies\Communications Requester\Version 6.15\Settings';



  
Var
  ThisReg  :  TRegistry;
  ThisKey  :  String;

Begin
  Result:=0;

  ThisReg:=TRegistry.Create;

  Try
    With ThisReg do
    Begin
      RootKey:=HKey_Local_Machine;

      Case SetNo of
        11  :  ThisKey:=BTProKey;
        else   ThisKey:=BTRegRoot[(SetNo>8),UseServer];
      end;

      If OpenKey(ThisKey,BOff) then
      Begin
        If (SetNo In [4,8]) then
        Begin
          If (SetOn) then
            WriteString(BTRegKeys[SetNo],Form_Int(SetVal,0));

          Result:=StrToInt(ReadString(BTRegKeys[SetNo]));
        end
        else
        If (SetNo=11) then
        Begin
          If (SetOn) then
            WriteString(BTRegKeys[SetNo],BTProtocols[SetVal]);

          Result:=RetBTProtocol(ReadString(BTRegKeys[SetNo]));
        end
        else
          Begin
            If (SetOn) then
              WriteInteger(BTRegKeys[SetNo],SetVal);

            Result:=ReadInteger(BTRegKeys[SetNo]);
          end;
      end;

    end; {finally..}
  Finally

    ThisReg.Free;
  end; {try..}
end;


{ ========= Test =========== }

Function Srv_IsNT(OS  :  Integer)  :  Boolean;
Begin
  Result:=(OS In [0..2,7]);
end;


Function Srv_IsNovell(OS  :  Integer)  :  Boolean;
Begin
  Result:=(OS In [3,4,8]);
end;


Function WS_IsNT(OS  :  Integer)  :  Boolean;
Begin
  Result:=(OS In [0..2]);
end;


Function WS_IsNovell(OS  :  Integer)  :  Boolean;
Begin
  Result:=(OS In [3,4]);
end;




{ =========== Function to Check/Set BSPXCom Setting ============= }

Function UpdateDLLIni (SetOn,
                       MCOn   :  Boolean;
                       FName,
                       FPath  :  Str255)  :  Boolean;

Const
  Match1  =  'Exchequer_Path';
  Match2  =  'Multi_Currency';

Var
  F,FN       :  TextFile;
  ThatLine,
  ThisLine,
  MainPath,
  NewName    :  Str255;
  ChkEOF,
  TBo,
  HaveSet,
  NFOpen     :  Boolean;
  FP         :  LongInt;
  FAT        :  Integer;

  IOChk      :  SmallInt;

Begin

  Result:=BOff; HaveSet:=BOff; NFOpen:=BOff;
  MainPath:='';
  NewName:='';


  If (Trim(FName)<>'') then
  Begin

    FAT:=FileGetAttr(Fname);
    IOChk:=IOResult;

    FileSetAttr(Fname,0);
    IOChk:=IOResult;

    System.AssignFile(F,FName);

    System.Reset(F);

    IOChk:=IOResult;

    If (IOChk=0) and (SetON) then
    Begin
      MainPath:=ExtractFileDir(Fname);
      NewName:=MainPath+'\EXCHDLL.NEW';

      System.AssignFile(FN,NewName);

      System.Rewrite(FN);

      IOChk:=IOResult;

      NFOpen:=IOChk=0;
    end;

    try

      If (IOChk=0) then
      Begin
        ReadLn(F,ThisLine);
        IOChk:=IOResult;
      end;


      FP:=0;
      ChkEOF:=BOff;


      While (Not ChkEOF) and (IOChk=0) and (Not Result) do
      Begin

        ChkEOF:=EOF(F);

        ThatLine:=UpCaseStr(ThisLine);

        If (Match_Glob(Length(ThatLine)+1,UpCaseStr(Match1),ThatLine,TBo)) then
        Begin
          If (SetOn) then
          Begin

            ThisLine:=Match1+ConstStr(' ',14)+FPath+'\';

            HaveSet:=BOn;
          end;
        end
        else
          If (Match_Glob(Length(ThatLine)+1,UpCaseStr(Match2),ThatLine,TBo)) then
          Begin
            If (SetOn) then
            Begin

              If (MCOn) then
                ThisLine:=Match2+ConstStr(' ',14)+'ON'
              else
                ThisLine:=Match2+ConstStr(' ',14)+'OFF';

              HaveSet:=BOn;
            end;
          end;


        If (SetOn) then
        Begin
          WriteLn(FN,ThisLine);
          IOChk:=IOResult;
        end;

        If (Not Result) and (IOChk=0) and (Not ChkEOF) then
        Begin
          ReadLn(F,ThisLine);
          IOChk:=IOResult;
        end;

      end;

    finally;

      System.Close(F);


      If (NFOpen) then
        System.Close(FN);

      If (SetOn) and (HaveSet) and (IOChk=0) then
      Begin
        If (DeleteFile(Fname)) then
          If (Not RenameFile(NewName,FName)) then
            ShowMessage('Error renaming '+NewName+' to '+Fname+#13+
                        'Please edit this file manually.')
          else
            Result:=BOn;
      end;

      FileSetAttr(Fname,FAT);
    end;


  end;

end;


{$I+}



Function BT_LoadedOk(Var CSMode  :  Boolean)  :  Integer;

Type
  VerRec   =  Record
                Ver,Rel  :  Integer;
                Typ      :  Char;

              end;
Var
  n       :  Byte;

  ConRec  :  Array[1..3] of VerRec;

  WinFile :  String;

  LoopCnt
          :  Integer;

  FileB   :  FileVar;

{  DumLen,DumKeyNum  :  Integer;
  DumKey                 :  Str255;
  TmpCh                  :  Char;
  ShowAcc                :  String[2];

   DumRec                 :  Record}
    LVer                  :  SmallInt;
    LRev                  :  SmallInt;
    LTyp                  :  Char;
    RVer                  :  SmallInt;
    RRev                  :  SmallInt;
    RTyp                  :  Char;
    SVer                  :  SmallInt;
    SRev                  :  SmallInt;
    STyp                  :  Char;
{  end;}


Begin
  Result:=12;

  FillChar(ConRec,Sizeof(ConRec),0);

  WinFile:=ExtractFileDir(ParamStr(0));

  LoopCnt:=0;

  CSMode:=BOff;
  
  With CompSysInfo^ do
  If (FileExists(PathToShort(ExPathStr)+'\EXCHQSS.DAT')) then
  Begin

    Repeat
      Status:=Open_File(FileB,PathToShort(ExPathStr)+'\EXCHQSS.DAT',0);

      Inc(LoopCnt);

    Until (Not (Status In [84,85])) or (LoopCnt>999);

    Result:=Status;

    If (Status=0) then
    Begin
      For n:=1 to 3 do
        With ConRec[n] do
          GetBtrvVer(FileB,Ver,Rel,Typ,n);

      With ConRec[3] do
        CSMode:=((Typ=BCSType) or (Typ=BNTCSType));

      Close_File(FileB);
    end;

  end;
end;


  { Returns time in milli-seconds }
Function TimeVal : LongInt;
Var
  Hour, Min, Sec, MSec,Days : Word;
begin
  DecodeTime(Now, Hour, Min, Sec, MSec);

  If (Today<>StartDate) then
  Begin
    Days:=NoDays(StartDate,Today);
  end
  else
    Days:=0;

  Result := MSec + (1000 * (Sec + (60 * (Min + ((Hour+(Days*24)) * 60)))));


end;



Procedure WriteGL(GL  :  Byte);

Var
  F  :   TextFile;
Begin
  {$I-}

  System.Assign(F,ExtractFileDir(ParamStr(0))+'\GL'+Form_Int(GL,0)+'.FLG');

  ReWrite(F);

  If (IOResult=0) then
    Writeln(F,'XX');

  System.Close(F);

  If (IOResult=0) then;


  {$I+}
end;


Function GLFileExists(GL  :  Byte)  :  Boolean;

Begin
  {$I-}
  Result:=FileExists(ExtractFileDir(ParamStr(0))+'\GL'+Form_Int(GL,0)+'.FLG');
  {$I+}

end;


Function DeleteGL(GL  :  Byte)  :  Boolean;

Begin
  {$I-}
  Result:=DeleteFile(ExtractFileDir(ParamStr(0))+'\GL'+Form_Int(GL,0)+'.FLG');
  {$I+}
end;


Function FmtTime(Tim    :  Double;
                 ShowU  :  Boolean)  :  Str80;

Var
  UnitS  :  Str80;
  MinP,
  NewTim :  Double;
  IsMin  :  Boolean;

Begin
  If (ShowU) then
    UnitS:=' ms'
  else
    UnitS:='';

  IsMin:=BOff;

  If (Tim>999) then
  Begin
    NewTim:=Tim/1000;

    If (NewTim>60) then
    Begin
      NewTim:=NewTim/60;

      If (NewTim<60) then
      Begin
        MinP:=NewTim-Trunc(NewTim);

        MinP:=(MinP*60);


        If (ShowU) then
          UnitS:='s';

        IsMin:=BOn;

        UnitS:=Form_Int(Trunc(NewTim),0)+'m'+Form_Int(Round(MinP),0)+UnitS;
      end
      else
      Begin
        NewTim:=NewTim/60;

        MinP:=NewTim-Trunc(NewTim);

        MinP:=(MinP*60);


        If (ShowU) then
          UnitS:='m';

        IsMin:=BOn;

        UnitS:=Form_Int(Trunc(NewTim),0)+'h'+Form_Int(Round(MinP),0)+UnitS;

      end;
    end
    else
      If (ShowU) then
        UnitS:=' s';

    If (IsMin) then
      Result:=UnitS
    else
      Result:=Format('%.2f',[NewTim])+UnitS


  end
  else
    Result:=Format('%d',[Round(Tim)])+UnitS;
end;


Function RestoreMastDat(RM  :  Byte;
                        Rest:  Boolean)  :  Boolean;

Const
  InvFNames  :  Array[1..4] of Str20 = ('\TRANS\DETAILS','\TRANS\DOCUMENT','\TRANS\HISTORY','\EXCHQNUM');

Var
  NewFName,
  OldFName  :  String;

  NPChr,
  OPChr     :  PChar;

  n         :  Byte;

Begin
  Result:=BOff;

  NPChr := StrAlloc (255);
  OPChr := StrAlloc (255);

  Screen.Cursor:=crHourGlass;

  With CompSysInfo^ do
  Case RM of

    0  :  Begin

            NewFName:=ExPAthStr+'\Cust\CustSupp.Cmp';
            OldFName:=ExPAthStr+'\Cust\CustSupp.Dat';

            StrPCopy(NPChr,NewFName);
            StrPCopy(OPChr,OldFName);


            If (FileExists(NewFName)) then
            Begin
              Result:=CopyFile(NPChr,OPChr,False);

              If (Result) and (Rest) then
                Result:=DeleteFile(NewFName);
            end
            else
              If (Not Rest) then
              Begin
                Result:=CopyFile(OPChr,NPChr,False);

                If (Not TakenCopy) then
                  TakenCopy:=Result;
              end;
          end;

    1  :  Begin

            For n:=1 to 4 do
            Begin
              Application.ProcessMessages;

              NewFName:=ExPAthStr+InvFNames[n]+'.Cmp';
              OldFName:=ExPAthStr+InvFNames[n]+'.Dat';

              StrPCopy(NPChr,NewFName);
              StrPCopy(OPChr,OldFName);


              If (FileExists(NewFName)) then
              Begin
                Result:=CopyFile(NPChr,OPChr,False);

                If (Result) and (Rest) then
                  Result:=DeleteFile(NewFName);

              end
              else
                If (Not Rest) then
                Begin
                  Result:=CopyFile(OPChr,NPChr,False);

                  If (Not TakenCopy) then
                    TakenCopy:=Result;
                end;
            end;
          end;
  end; {Case..}


  Screen.Cursor:=crDefault;

  StrDispose (NPChr);
  StrDispose (OPChr);

end;


{ ========= Procedure Set Coordinates of next MDI Child ======= }

Procedure MDI_SetFormCoord(Var F  :  TForm);

Var
  MDIForm  :  TForm;

Begin
  MDIForm:=Application.MainForm.ActiveMDIChild;

  If (MDIForm<>nil)  then
  With MDIForm do
  Begin
    Begin
      F.Left:=Left+20;
      F.Top:=Top+20;
    end
    
  end
  else
  Begin
    F.Left:=1;
    F.Top:=1;
  end;
end;


{ ============= Function to Report Btrieve Error ============= }

Procedure Report_MTBError(Fnum,
                          ErrNo    :  Integer;
                          ClientId :  Pointer);
Var
  ErrStr    :  AnsiString;
  mbRet     :  Word;
  ThStr     :  AnsiString;

Begin
  ThStr:='';

  If (ErrNo<>0) then
  Begin
    ErrStr:=Set_StatMes(ErrNo);

    If (Assigned(ClientId)) then
      ThStr:=#13+#13+'In thread '+Form_Int(ClientIdType(ClientId^).TaskId,0);

    mbRet:=MessageDlg('Error in file : '+FileNAmes[Fnum]+#13+'Error '+Form_Int(ErrNo,0)+', '+#13+ErrStr+ThStr,
           mtError,[mbOk],0);


  end;
end; {Proc..}



Procedure Report_BError(Fnum,
                        ErrNo  :  Integer);

Begin

  If (ErrNo<>0) and (Debug) then
    MessageBeep(0);

  Report_MTBError(Fnum,ErrNo,nil);

end; {Proc..}



Initialization
  Init_ResourceMon;
  TakenCopy:=BOff;
  StartDate:=Today;

Finalization
  Free_ResourceMon;

end.
