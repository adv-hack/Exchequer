unit BTSupU1;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses
  Windows,
  Messages,
  Graphics,
  GlobVar,
  VarConst,
  BtrvU2;

Const
  WM_CustGetRec    =  WM_User+$1;
  WM_FormCloseMsg  =  WM_User+$2;
  {WM_CallViaComp  =  WM_User + $3; In TeditVal}
  WM_ChangeComp    =  WM_User+$4;
  WM_SBSFDMsg      =  WM_User+$100;
  WM_ThreadPrintP  =  WM_User+$101;  {* This has been deliberately set to WM_PrintProgress to avoid having to include GlobTypes *}
  {WM_PrintProgress = WM_USER + $101;   In GlobType.Pas/RwMain.Pas }
  {WM_PrintAbort    = WM_USER + $102;                              }
  {WM_InPrint       = WM_USER + $103;                              }
  WM_PrintRep      =  WM_User+$200;   { Used in Report Writer and Print Preview }
  WM_ExportRep     =  WM_User+$201;   { Used in Report Writer }
  WM_UpdateTree    =  WM_User+$202;   { Used in Report Writer }


  GenPcntMask   =  ' #0.0%;-#0.0%';
  GenPcnt2dMask =  ' #0.00%;-#0.00%';
  GenProfileMask=  '#0.00 ;#0.00-';
  WildCha       =  '*';
  WildChQ       =  '?';
  DescTrig      =  '/';
  sdbTrig       =  '>'; 
  supTrig       =  '!';
  BarCTrig      =  '<';



Var
  GenRealMask,
  GenRNDMask,
  GenQtyMask     :  Str255;

  GenUnitMask    :  Array[BOff..BOn] of Str255;  {On=Sales, Off=Purch}



Function CheckKey(KeyRef,Key2Chk  :  AnyStr;
                  KeyLen          :  Integer;
                  AsIs            :  Boolean) :  Boolean;

Function CheckKeyRange(KeyRef,
                       KeyRef2,
                       Key2Chk  :  AnyStr;
                       KeyLen   :  Integer;
                       AsIs     :  Boolean) :  Boolean;


Procedure ResetRec(FNum  :  Integer);

Procedure SetDataRecOfs(FileNum  :  Integer;
                        Ofset    :  LongInt);

Procedure SetDataRecOfsPtr(FileNum  :  Integer;
                           Ofset    :  LongInt;
                       Var DataRec);

Procedure Report_MTBError(Fnum,
                          ErrNo    :  Integer;
                          ClientId :  Pointer);

Procedure Report_BError(Fnum,
                        ErrNo  :  Integer);

Procedure Report_IOError(IOCode  :  Integer;
                         Fname   :  Str255);

Function GetMultiRecAddr(Func      :  Integer;
                         LockType  :  Integer;
                     Var Key2S     :  Str255;
                         KeyPth    :  Integer;
                         Fnum      :  Integer;
                         Wait      :  Boolean;
                     Var Locked    :  Boolean;
                     Var LRecAddr  :  LongInt) : Boolean;

Function GetMultiRec(Func      :  Integer;
                     LockType  :  Integer;
                 Var Key2S     :  Str255;
                     KeyPth    :  Integer;
                     Fnum      :  Integer;
                     Wait      :  Boolean;
                 Var Locked    :  Boolean) : Boolean;

Function  CheckExsists(KeyR  :  AnyStr;
                       FileNum,KeyPath
                             :  Integer)  :  Boolean;

Function  CheckRecExsists(KeyR  :  AnyStr;
                          FileNum,KeyPath
                               :  Integer)  :  Boolean;

Function Check4DupliGen(KEyS  :  Str255;
                        Fnum,
                        KeyP  :  Integer;
                        DupliP:  Str80)  :   Boolean;

Function Global_GetMainRec(Fnum  :  Integer;
                           KeyS  :  Str255)  :  Boolean;


Function GetTempFNameExt(SwapName,ExtN :  Str10)  :  Str255;

Function GetTempFName(SwapName :  Str10)  :  Str255;

Procedure SetAllowHotKey(State      :  Boolean;
                     Var PrevState  :  Boolean);

Function Get_FreeResources  :  Integer;

Procedure Free_ResourceMon;

Function Color_ResourceMon(Value  :  Integer)  :  TColor;

Function FreeDiskSpacePcnt  :  Double;

procedure Delay(dt  :  Word;
                SAPM:  Boolean);

Procedure Set_SDefDecs;


{$IFDEF DBD}
  Var
    DebugTime  :  Array[0..99,BOff..BOn] of LongInt;
    DebugTitle :  Array[0..99] of Str10;


  Procedure StartBDebug(DN  :  Byte; DT  :  Str10);

  Procedure StopBDebug(DN  :  Byte);

  Procedure FinishBDebug;

{$ENDIF}



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  Dialogs,
  SysUtils,
  Controls,
  TEditVal,
  Forms,
  BTKeys1U,
  //ComnUnit,

  {$IFDEF PF_On}
    {$IFNDEF EDLL}
      {$IFNDEF OLE}
        {$IFNDEF RW}
          {$IFNDEF COMP}
            {$IFNDEF ENDV}   { Customisation Interface }
            {$IFNDEF WCA}    { Windows Card System }
              {$IFNDEF XO}
                //InvLst2U,      { Boy, Is this module popular, or what? }
                //Excep2U,
              {$ENDIF}
            {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}

  {$ENDIF}

  {$IFDEF DBD}
    DebugU,
    ClipBrd,
  {$ENDIF}

  //ComnU2,
  //IntMU,
  BTSFrmU1;


Const
    gfsr_SystemResources  = $0000;

Var
  _MyGetFreeSystemResources32  :  function(Mode  :  Integer)  :  Integer stdcall;
  _MyGSRHandle                 :  THandle;



{ ================ Procedure to Compare Search Keys ============= }

Function CheckKey(KeyRef,Key2Chk  :  AnyStr;
                  KeyLen          :  Integer;
                  AsIs            :  Boolean) :  Boolean;

Begin
  If (Length(Key2Chk)>=KeyLen) then
    CheckKey:=(UpcaseStrList(Copy(Key2Chk,1,KeyLen),AsIs)=UpcaseStrList(Copy(KeyRef,1,KeyLen),AsIs))
  else
    CheckKey:=False;
end;



{ =============== Function to Compare Search Keys by Range ================== }

Function CheckKeyRange(KeyRef,
                       KeyRef2,
                       Key2Chk  :  AnyStr;
                       KeyLen   :  Integer;
                       AsIs     :  Boolean) :  Boolean;
Var
  KeyRefLen  :  Integer;
Begin
  KeyRefLen:=Length(KeyRef);
  If (KeyRefLen>KeyLen) or (KeyRef2='') then KeyRefLen:=KeyLen;
  If (KeyRef2='') then KeyRef2:=KeyRef;     { Set To Main Compatibility }

  If (Length(Key2Chk)>=KeyRefLen) then CheckKeyRange := ((UpcaseStrList(Copy(Key2Chk,1,KeyLen)
  ,AsIs)>=UpcaseStrList(Copy(KeyRef,1,KeyRefLen),AsIs)) and (UpcaseStrList(Copy(Key2Chk,1,KeyLen),AsIs)
  <=UpcaseStrList(Copy(KeyRef2,1,KeyLen),AsIs)))
  else CheckKeyRange:=False;
end;

{ ================ Procedure to Reset Current Record ============== }
procedure ResetRec(FNum : Integer);
begin
  case Fnum of
    CustF : FillChar(Cust,FileRecLen[FNum],0);
    InvF : FillChar(Inv,FileRecLen[FNum],0);
    SalesDetF : FillChar(SalesDetRec,FileRecLen[FNum],0);
    SysF : FillChar(Syss,FileRecLen[FNum],0);
    GroupF : FillChar(GroupRec,FileRecLen[FNum],0);
    ItemF : FillChar(ItemRec,FileRecLen[FNum],0);
{    IncF : FillChar(Count,FileRecLen[FNum],0);}
  end;{case}
end;

{ ============ Low Level Proc to Set Data Record for 4-byte offset ========== }
procedure SetDataRecOfs(FileNum : Integer; Ofset : LongInt);
begin
  case FileNum  of
    CustF : Move(Ofset,Cust,Sizeof(Ofset));
    InvF : Move(Ofset,Inv,Sizeof(Ofset));
    SalesDetF : Move(Ofset,SalesDetRec,Sizeof(Ofset));
    SysF : Move(Ofset,Syss,Sizeof(Ofset));
    GroupF : Move(Ofset,GroupRec,Sizeof(Ofset));
    ItemF : Move(Ofset,ItemRec,Sizeof(Ofset));
{    IncF : Move(Ofset,Count,Sizeof(Ofset));}
  end; {Case..}
end;


{ ============ Low Level Proc to Set Data Record for 4-byte offset ========== }

Procedure SetDataRecOfsPtr(FileNum  :  Integer;
                           Ofset    :  LongInt;
                       Var DataRec);

Begin

  Move(Ofset,DataRec,Sizeof(Ofset));

end;



{ =========== Report IOError =========== }


Procedure Report_IOError(IOCode  :  Integer;
                         Fname   :  Str255);
Const
  IOMess1  =  ' WARNING! - I/O Error ';
  IOMess3  =  ' in file';
Begin
  If (IOCode<>0) then
  Begin

    MessageDlg(IOMess1+#13+IOError(IOCode)+IOMEss3+#13+Fname,mtError,[mbOk],0);

    {$IFDEF PF_On}
        {$IFNDEF EDLL}
          {$IFNDEF OLE}
            {$IFNDEF RW}
              {$IFNDEF COMP}
                {$IFNDEF ENDV}   { Customisation Interface }
                {$IFNDEF WCA}    { Windows Card System }
                  {$IFNDEF XO}
                    AddErrorLog(IOMess1+#13+IOError(IOCode),'In File : '+Fname,0);
                  {$ENDIF}
                {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
    {$ENDIF}


  end;

end;

{ ============= Function to Report Btrieve Error ============= }

Procedure Report_MTBError(Fnum,
                          ErrNo    :  Integer;
                          ClientId :  Pointer);
Var
  ErrStr    :  Str255;
  ThStr     :  Str255;
{  ClientIdR :  ClientIdType;}

Begin
  ThStr:='';

  If (ErrNo<>0) then
  Begin
    ErrStr:=Set_StatMes(ErrNo);

    If (Assigned(ClientId)) then
      ThStr:=#13+#13+'In thread '+Form_Int(ClientIdType(ClientId^).TaskId,0);

    MessageDlg('Error in file : '+FileNAmes[Fnum]+#13+'Error '+Form_Int(ErrNo,0)+', '+#13+ErrStr+ThStr,
           mtError,[mbOk],0);

    {$IFDEF PF_On}
        {$IFNDEF EDLL}
          {$IFNDEF OLE}
            {$IFNDEF RW}
              {$IFNDEF COMP}
                {$IFNDEF ENDV}   { Customisation Interface }
                {$IFNDEF WCA}    { Windows Card System }
                  {$IFNDEF XO}
                      AddErrorLog('Btrieve Error in file : '+FileNAmes[Fnum]+#13+'Error '+Form_Int(ErrNo,0)+', '+#13+ErrStr+ThStr,'',3);
                  {$ENDIF}
                {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
    {$ENDIF}

  end;
end; {Proc..}



Procedure Report_BError(Fnum,
                        ErrNo  :  Integer);

Begin

  If (ErrNo<>0) and (Debug) then
    MessageBeep(0);

  Report_MTBError(Fnum,ErrNo,nil);

end; {Proc..}






{ ======= General Routine to Atempt a Record Lock ========= }

Function GetMultiRecAddr(Func      :  Integer;
                         LockType  :  Integer;
                     Var Key2S     :  Str255;
                         KeyPth    :  Integer;
                         Fnum      :  Integer;
                         Wait      :  Boolean;
                     Var Locked    :  Boolean;
                     Var LRecAddr  :  LongInt) : Boolean;

Var
  Bcode,
  Fcode    :  Integer;
  MbRet    :  Word;
  TmpForm  :  TBTWaitLock;

Begin
  Locked:=BOff;
{  Fcode:=0;}

{  TmpForm:=NIL;}

  BCode:=Try_Lock(Func,B_SingNWLock+LockType,Key2S,Keypth,Fnum,RecPtr[Fnum]);


  If (Bcode<>0) then
  Case Bcode of
       81     :  Report_Berror(Fnum,BCode);  {* Lock table full *}

       84,85  {$IFDEF Su_On}

              :  Begin
                   mbRet:=MessageDlg('Network Violation! - Closing System',
                                      mtError,[mbOk],0);

                   Halt;
                 end;

              {$ELSE}


              :  If (Not Wait) then
                 Begin
                   {* Establish if record found at all *}

                   Fcode:=Find_Rec(Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPth,Key2s);

                   Repeat

                     mbRet:=MessageDlg('Record in use by another station!',
                                        MtConfirmation,[mbRetry,mbCancel],0);

                     BCode:=Try_Lock(Func,B_SingNWLock+LockType,Key2S,Keypth,Fnum,RecPtr[Fnum]);

                   Until (MbRet=IdCancel) or (Bcode=0);

                   Locked:=(Bcode=0);

                   {* Set record found *}
                   Bcode:=Fcode;

                 end
                 else
                 Begin

                   If (Assigned(Application.Mainform)) then
                     TmpForm:=TBTWaitLock.Create(Application.Mainform)
                   else
                     TmpForm:=TBTWaitLock.Create(Application);

                   Try

                     TMpForm.Init_Test(Func,Fnum,Keypth,LockType,Key2S,RecPtr[Fnum],nil);

                     BCode:=(TmpForm.ShowModal-mrOk);

                   Finally

                     TmpForm.Free;

                   end;

                   Locked:=(Bcode=0);

                 end;

               {$ENDIF}

       22      : Begin
                   Locked:=(VariFile[Fnum]);
                   If (Locked) then
                     Bcode:=0;
                 end;


  end {Case..}
  else
    Locked:=BOn;

  Addch:=#0; {* Reset Lock Key *}

  GetMultiRecAddr:=(Bcode=0);

  If (BCode=0) then
    GetPos(F[Fnum],Fnum,LRecAddr);

end;


{ ======= General Routine to Atempt a Record Lock ========= }

Function GetMultiRec(Func      :  Integer;
                     LockType  :  Integer;
                 Var Key2S     :  Str255;
                     KeyPth    :  Integer;
                     Fnum      :  Integer;
                     Wait      :  Boolean;
                 Var Locked    :  Boolean) : Boolean;

Var
  LRecAddr  :  LongInt;

Begin

  LRecAddr:=0;

  GetMultiRec:=GetMultiRecAddr(Func,LockType,Key2S,Keypth,Fnum,Wait,Locked,LRecAddr);

end;

{ Duplicate copt in tdMTExLocal }

{ =========== Function to Check Exsistance of Given Code without disturbing record ========= }


Function  CheckExsists(KeyR  :  AnyStr;
                       FileNum,KeyPath
                             :  Integer)  :  Boolean;

Var
  KeyS     :  AnyStr;
  {TmpFn    :  FileVar;}

  TmpKPath,
  CEStatus :  Integer;

  TmpRecAddr
           :  LongInt;


Begin
  KeyS:=KeyR;

  {* TmpFn:=F[FileNum]; Stopped using this v4.21, as suspected C/S was getting corrupted  *}

  TmpKPath:=GetPosKey;

  Presrv_BTPos(Filenum,TmpKPath,F[FileNum],TmpRecAddr,BOff,BOff);


  CEStatus:=Find_Rec(B_GetGEq+B_KeyOnly,F[FileNum],FileNum,RecPtr[FileNum]^,KeyPath,KeyS);

  CheckExsists:=((CEStatus=0) and (CheckKey(KeyR,KeyS,Length(KeyR),BOn)));

  Presrv_BTPos(Filenum,TmpKPath,F[FileNum],TmpRecAddr,BOn,BOff);

end;



{ =========== Function to Check Exsistance of Given Code and return record if found ========= }


Function  CheckRecExsists(KeyR  :  AnyStr;
                          FileNum,KeyPath
                               :  Integer)  :  Boolean;

Var
  KeyS     :  AnyStr;
  {TmpFn    :  FileVar;}

  TmpKPath,
  CEStatus :  Integer;

  TmpRecAddr
           :  LongInt;



Begin
  KeyS:=KeyR;

  {* TmpFn:=F[FileNum]; Stopped using this v4.21, as suspected C/S was getting corrupted  *}


  TmpKPath:=GetPosKey;

  Presrv_BTPos(Filenum,TmpKPath,F[FileNum],TmpRecAddr,BOff,BOff);


  CEStatus:=Find_Rec(B_GetGEq,F[FileNum],FileNum,RecPtr[FileNum]^,KeyPath,KeyS);

  If (CEStatus<>0) then
    ResetRec(FileNum);

  CheckRecExsists:=((CEStatus=0) and (CheckKey(KeyR,KeyS,Length(KeyR),BOn)));

  Presrv_BTPos(Filenum,TmpKPath,F[FileNum],TmpRecAddr,BOn,BOff);

end;


{ ================ Procedrue to Check for Duplicate XXX Records,.. ===}

Function Check4DupliGen(KEyS  :  Str255;
                        Fnum,
                        KeyP  :  Integer;
                        DupliP:  Str80)  :   Boolean;

Var
{  Sure  :  Boolean;
  TmpCh :  Char;
  Count :  Byte;    }

  TmpKPath : Integer;
  TmpRecAddr : LongInt;

  {TmpFn :  FileVar;}

Begin
  {* TmpFn:=F[FileNum]; Stopped using this v4.21, as suspected C/S was getting corrupted  *}


  TmpKPath:=GetPosKey;

  Presrv_BTPos(Fnum,TmpKPath,F[FNum],TmpRecAddr,BOff,BOff);


  Status:=Find_Rec(B_GetEq+B_KeyOnly,F[FNum],Fnum,RecPtr[Fnum]^,KeyP,KeyS);

  Presrv_BTPos(Fnum,TmpKPath,F[FNum],TmpRecAddr,BOn,BOff);

  If (Status=0) then
  Begin
    MessageDlg('That '+DupliP+' already exists!',
                       mtWarning,[mbOk],0);

  end
  else If (Debug) and (Status<>4) then Status_Means(Status);

  Check4DupliGen:=(Status=0);

end;


{ ==== General purpose Get main rec via main key ==== }

Function Global_GetMainRec(Fnum  :  Integer;
                           KeyS  :  Str255)  :  Boolean;


Begin
  Result:=BOff;

  If (KeyS<>'') then
    Result:=(Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS)=0);

end;


Procedure Set_SDefDecs;

Begin

  {GenRealMask:='###'+ThousandSeparator+'###'+ThousandSeparator+'##0'+DecimalSeparator+'00 ;###'+
               ThousandSeparator+'###'+ThousandSeparator+'##0'+DecimalSeparator+'00-';

  GenRNDMask:=' ###'+ThousandSeparator+'###'+ThousandSeparator+'##0;-###'+
               ThousandSeparator+'###'+ThousandSeparator+'##0';

  The actual format specifier must be , for thousdands, and . for decimal. Formatfloat will substitute regional settings

 }

  GenRealMask:='###,###,##0.00 ;###,###,##0.00-';

  GenRNDMask:=' ###,###,##0;-###,###,##0';

  GenQtyMask:=GenRealMask;
  GenUnitMask[BOff]:=GenRealMask;
  GenUnitMask[BOn]:=GenRealMask;

  GenQtyMAsk:=FormatDecStrSD(2{Syss.NoQtyDec},GenRealMask,BOff);
  GenUnitMask[BOn]:=FormatDecStrSD(2{Syss.NoNetDec},GenRealMask,BOff);
  GenUnitMask[BOff]:=FormatDecStrSD(2{Syss.NoCosDec},GenRealMask,BOff);
end;

{ ============= Function to Return Next Available Swap File Name, For MultiUser reasons =============== }

Function GetTempFNameExt(SwapName,ExtN :  Str10)  :  Str255;


Var
  n{,IOChk}     :  Integer;

  SwapFileName:  Str255;
  NumStr      :  Str10;

Begin
  {$I-}

  n:=1;

  Repeat

    Str(n:0,NumStr);

    SwapFileName:=SwapName+NumStr+ExtN;

    Inc(n);

  Until (Not FileExists(SetDrive+SwapFileName)) or (n>9999);

  {$I+}

  Result:=SetDrive+SwapFileName;
end; {Func..}


{ ============= Function to Return Next Available Swap File Name, For MultiUser reasons =============== }

Function GetTempFName(SwapName :  Str10)  :  Str255;


Begin
  Result:=GetTempFNameExt(SwapName,'.SWP');
end; {Func..}


{ ============ Function to set AllowHot key =========== }

Procedure SetAllowHotKey(State      :  Boolean;
                     Var PrevState  :  Boolean);

Begin
  Case State of

    BOff  :  Begin
               PrevState:=AllowHotKey;
               AllowHotKey:=State;
             end;
    BOn   :  AllowHotKey:=PrevState;

  end; {Case..}

end;


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


Function FreeDiskSpacePcnt  :  Double;

Var
  lpRootN  :  PChar;
  lpSPC,
  lpBPS,
  lpNOFC,
  lpTNpC   :  DWord;

Begin
{  Result:=0.0;}

  lpSPC:=0; lpBPS:=0; lpNOFC:=0; lpTNpC:=0;

  Try
    lpRootN:=StrAlloc(255);

    If (SetDrive<>'') then
      StrPCopy(lpRootN,Copy(SetDrive,1,2)+'\')
    else
      StrPCopy(lpRootN,SetDrive);


    If  GetDiskFreeSpace(lpRootN,lpSPC,lpBPS,lpNOFC,lpTNpc) then
    Begin
      Result:=DivWChk(lpNOFC,lpTNPC)*100;
    end
    else
      Result:=100.0;
  Finally
    StrDispose(lpRootN);
  end;
end;



procedure Delay(dt  :  Word;
                SAPM:  Boolean);

Var
  ThTimeS,
  thTimeN   :  TDateTime;

  thGap     :  Double;

Begin
  thTimeS:=Now;

  thGap:=dt/1e8;

  Repeat
    thTimeN:=Now-ThTimeS;

    If (SAPM) then
      Application.ProcessMessages;

  Until (thTimeN>thgap);

end;



{ ================= Various routines to time btrieve =============== }

{$IFDEF DBD}

  { Returns time in milli-seconds }
Function TimeVal : LongInt;
Var
  Hour, Min, Sec, MSec : Word;
begin
  DecodeTime(Now, Hour, Min, Sec, MSec);

  Result := MSec + (1000 * (Sec + (60 * (Min + (Hour * 60)))));
end;

  Procedure StartBDebug(DN  :  Byte; DT  :  Str10);

  Begin
    DebugTime[DN,BOff]:=Timeval;
    DebugTitle[DN]:=DT;
  end;


  Procedure StopBDebug(DN  :  Byte);

  Begin
    DebugTime[DN,BOn]:=TimeVal-DebugTime[DN,Boff];

    DebugForm.Add(DebugTitle[DN]+' : '+Form_Int(DebugTime[DN,BOn],0));
  end;

  Procedure FinishBDebug;

  Var
    n        :  Integer;
    TotTime  :  LongInt;

    RLines   :  ANSIString;

    Buff     :  PChar;

  Begin
    TotTime:=0;

    For n:=Low(DebugTime) to High(DebugTime) do
       TotTime:=TotTime+DebugTime[n,Bon];

    DebugForm.Add('    -------------- ');

    DebugForm.Add('Total Time : '+Form_Int(TotTime,0));

    DebugForm.Add('    -------------- ');

    RLines:='';

    Buff:=StrAlloc(4096);

    try
      With DebugForm,DeBugBox1,Clipboard do
      Begin
        For n:=0 to Pred(DebugList.Items.Count) do
        Begin
          RLines:=RLines+DebugList.Items[n]+#13+#10;
        end;

        For n:=0 to Length(Rlines) do
          Buff[n]:=RLines[n];

        StrPCopy(Buff,RLines);

        ClipBoard.SetTextBuf(Buff);


      end;

    finally


    end; {try..}

  end;

{$ENDIF}



Initialization
  {$IFNDEF EDLL}

    { Don't initialise the resource monitor if its the Enterprise DLL }
    Init_ResourceMon;

    {$IFDEF DBD}
      FillChar(DebugTime,Sizeof(DebugTime),0);
      FillChar(DebugTitle,Sizeof(DebugTitle),0);

    {$ENDIF}

  {$ENDIF}
end.
