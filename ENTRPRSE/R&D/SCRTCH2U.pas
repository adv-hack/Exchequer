Unit SCRTCH2U;

{.$O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 28/01/94                      }
{                                                              }
{                    File Scratch Controller II                }
{                                                              }
{               Copyright (C) 1994 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}



{ == Thread safe scratch file == }


Interface

Uses GlobVar,
     VarConst,
     ExBtTh1U;



Type


  Scratch2Ptr  = ^Scratch2File;


  Scratch2File = Object

                  SFnum,
                  SKeypath  :  Integer;
                  Process   :  LongInt;

                  OpenOk,
                  Belongs2Me,
                  KeepFile
                            :  Boolean;

                  MTExLocal :  TdPostExLocalPtr;

                  Constructor Init(ProNo   :  LongInt;
                                   ExLocal :  TdPostExLocalPtr;
                                   SetKeep :  Boolean);

                  //PR: 24/08/2012 ABSEXCH-12650 Add a new constructor so that existing records in an open file
                  //don't get deleted
                  Constructor InitWithOpenTable(ProNo   :  LongInt;
                                                ExLocal :  TdPostExLocalPtr;
                                                SetKeep :  Boolean);


                  {Destructor Done(KeepFile  :  Boolean); Virtual;}


                  Destructor Done;

                  Function GetScrSwapName(SeedName  :  Str255)  :  Str255;

                  Procedure Add_Scratch(FNo,
                                        KPath  :  Integer;
                                        RAddr  :  LongInt;
                                        KeySCr,
                                        MatchK :  Str255);


                  Procedure Get_Scratch(TRepScr:  RepScrRec);

                  Function In_Scratch(KeyMatch  :  Str255;
                                      KeyAddr   :  LongInt;
                                      FindXAddr :  Boolean)  :  Boolean;

                  Function Find_ScratchK(KeyMatch  :  Str255)  :  Boolean;


                end; {Object}


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   SysUtils,
   ETStrU,
   ETMiscU,
   BtrvU2,
   BTKeys1U,
   BTSupU1,
{$IFDEF EXSQL}
   SQLUtils,
{$ENDIF}
   Scrtch1U;



 Var
   Scrt2Count  :  Integer;


{ ---------------------------------------------------------------- }

{  Scratch2File Methods }

{ ---------------------------------------------------------------- }



  Constructor Scratch2File.Init(ProNo   :  LongInt;
                                ExLocal :  TdPostExLocalPtr;
                                SetKeep :  Boolean);

  Var
    KeyS       :  Str255;

    SetAccel   :  Integer;


  Begin

    Process:=ProNo;

    MTExLocal:=ExLocal;

    SFnum:=ReportF;
    SKeypath:=RPK;

    SetAccel:=0;

    OpenOk:=BOn; {Assume already open}

    KeepFile:=SetKeep;

    Belongs2Me:=BOff;

    Inc(Scrt2Count);

    {* Unlike the DOS system, these scratch files can be shut down in any order, hence
       Belongs2Me cannot be relied upon to control the deletion of the file, instead a count
       is used to keep track of how many scratch objects are currently active, only when the count
       is down to 0, will the file be destroyed. *}

    If (Assigned(MTExLocal)) then
    Begin
      With MTExLocal^ do
      Begin

        If (Used_RecsCId(LocalF^[SFnum],SFnum,ExCLientId)=0) then {* File Not Opened *}
        Begin

          SetAccel:=-1*Ord(AccelMode);

          {$IFDEF EXSQL}
          if SQLUtils.UsingSQL then
            FileNames[SFnum]:=GetScrSwapName('REP')
          else
          {$ENDIF}
            FileNames[SFnum]:=GetScrSwapName('$REP');

          LStatus:=Make_FileCID(LocalF^[SFnum],SetDrive+FileNames[SFnum],FileSpecOfs[SFnum]^,FileSpecLen[SFnum],ExClientId);

          If (LStatusOk) then
            LStatus:=Open_FileCId(LocalF^[SFnum],SetDrive+FileNames[SFnum],SetAccel,ExClientId);


          LReport_BError(SFnum,LStatus);

          OpenOk:=LStatusOk;

          Belongs2Me:=OpenOk;  {* Make this instance owner of file *}

          If (OpenOk) then {* Set up Owner of file *}
            Add_Scratch(0,-2,0,'','');

        end {If used..}
        else
        Begin  {* Already open, in case same instance has been here before,
                  delete all ocurrences of process number *}
          LDeleteLinks(FullNomKey(Process),SFnum,Sizeof(Process),SKeypath,BOff);

        end;
      end; {With..}
    end; {If Mt ok..}

  end; {Proc..}

  //PR: 24/08/2012 ABSEXCH-12650 Add a new constructor so that existing records in an open scratch file
  //don't get deleted - it removes the section that creates the file or deletes its records.
  Constructor Scratch2File.InitWithOpenTable(ProNo   :  LongInt;
                                             ExLocal :  TdPostExLocalPtr;
                                             SetKeep :  Boolean);
  Begin

    Process:=ProNo;

    MTExLocal:=ExLocal;

    SFnum:=ReportF;
    SKeypath:=RPK;

    OpenOk:=BOn; {Assume already open}

    KeepFile:=SetKeep;

    Belongs2Me:=BOff;

    Inc(Scrt2Count);

  end; {Proc..}




  {Destructor Scratch2File.Done(KeepFile  :  Boolean);}
  Destructor Scratch2File.Done;


  Var
    DelF    :  File of Byte;


  Begin
    Dec(Scrt2Count);


    If (Scrt2Count<=0) then
    With MTExLocal^ do
    Begin

      LStatus:=Close_FileCId(LocalF[SFnum],ExClientId);

      If (LStatusOk) and (Not KeepFile) then
      Begin

{$IFDEF EXSQL}
        SQLUtils.DeleteTable(SetDrive+FileNames[SFnum]);
{$ELSE}

        {$I-}

        AssignFile(DelF,SetDrive+FileNames[SFnum]);

        Erase(DelF);

        LReport_IOError(IOResult,SetDrive+FileNames[SFnum]);

        {$I+}

{$ENDIF}

      end;

    end; {If Ok..}

  end; {Proc..}

 

  Function Scratch2File.GetScrSwapName(SeedName  :  Str255)  :  Str255;

  Var
    TmpStr  :  Str255;
    L       :  Byte;

  Begin

    TmpStr:=GetSwapName(SeedName);

    GetScrSwapName:=TmpStr;

  end;

 

  Procedure Scratch2File.Add_Scratch(FNo,
                                    KPath  :  Integer;
                                    RAddr  :  LongInt;
                                    KeySCr,
                                    MatchK :  Str255);



  Begin

    With MTExLocal^ do
    Begin
      LResetRec(SFnum);


      With LRepScr^ do
      Begin

        RepFolio:=Process;

        If (KPath=-2) then
        Begin

          AccessK:=FullScratchKey(Process,FullNomKey(FirstAddrD),BOn);


        end
        else
        Begin

          AccessK:=FullScratchKey(Process,KeyScr,BOff);

          FileNo:=FNo;

          Keypath:=KPath;

          RecAddr:=RAddr;

          UseRad:=(RecAddr<>0);

          KeyStr:=MatchK;

        end;

      end; {With..}

      If (OpenOk) then
      Begin
        LStatus:=LAdd_Rec(SFnum,SKeypath);

        LReport_BError(SFNum,LStatus);

      end;
    end; {With..}
  end; {Proc..}


  Procedure Scratch2File.Get_Scratch(TRepScr:  RepScrRec);

  Var
    KeyS  :  Str255;

  Begin

    KeyS:='';

    With MTExLocal^ do
    Begin
      LResetRec(TRepScr.FileNo);

      If ((OpenOk) and (TRepScr.Keypath>=0)) then {* Ignore Id Rec *}
      With TRepScr do
      Begin

        If (UseRad) then {* Access by Record Addr *}
        Begin

          LSetDataRecOfs(FileNo,RecAddr);

          If (RecAddr<>0) then
            LStatus:=LGetDirect(FileNo,KeyPath,0);

        end
        else
        Begin
          KeyS:=KeyStr;

          LStatus:=LFind_Rec(B_GetEq,FileNo,Keypath,KeyS);

        end;

      end; {With..}

    end; {With..}
  end; {Proc..}


  Function Scratch2File.In_Scratch(KeyMatch  :  Str255;
                                   KeyAddr   :  LongInt;
                                   FindXAddr :  Boolean)  :  Boolean;

  Const
    Fnum     =  ReportF;


  Var
    KeyS,
    KeyChk  :  Str255;

    FoundOk :  Boolean;

    TmpStat,
    TKeypath :  Integer;
    TmpRecAddr
             :  LongInt;


  Begin
    TKeypath:=RpK;

    With MTExLocal^ do
    Begin
      TmpStat:=LPresrv_BTPos(Fnum,TKeyPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

      KeyChk:=FullNomKey(Process);
      KeyS:=KeyChk;

      FoundOk:=BOff;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,TKeypath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
      With LRepScr^ do
      Begin
        FoundOk:=((CheckKey(KeyMatch,KeyStr,Length(KeyMatch),BOff) and (Not FindxAddr)) or
                 ((KeyAddr=RecAddr) and (FindXAddr)));

        If (Not FoundOk) then
          LStatus:=LFind_Rec(B_GetNext,Fnum,TKeypath,KeyS);

      end;

      TmpStat:=LPresrv_BTPos(Fnum,TKeyPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
    end; {With..}

    In_Scratch:=FoundOk;

  end;



  Function Scratch2File.Find_ScratchK(KeyMatch  :  Str255)  :  Boolean;

  Const
    Fnum     =  ReportF;


  Var
    KeyS,
    KeyChk  :  Str255;

    FoundOk :  Boolean;

    TmpStat,
    TKeypath :  Integer;
    TmpRecAddr
             :  LongInt;


  Begin
    TKeypath:=RpK;

    With MTExLocal^ do
    Begin
      TmpStat:=LPresrv_BTPos(Fnum,TKeyPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

      KeyChk:=FullScratchKey(Process,KeyMatch,BOff);

      KeyS:=KeyChk;

      FoundOk:=BOff;


      LStatus:=LFind_Rec(B_GetGEq,Fnum,TKeypath,KeyS);

      FoundOk:=((LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)));

      TmpStat:=LPresrv_BTPos(Fnum,TKeyPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

    end; {With..}

    Find_ScratchK:=FoundOk;

  end;





Initialization

  Scrt2Count:=0;


end.