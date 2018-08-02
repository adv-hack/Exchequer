Unit SCRTCH1U;

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




Interface

Uses GlobVar,
     VarConst;


Type

  ScratchPtr  = ^ScratchFile;


  ScratchFile = Object

                  SFnum,
                  SKeypath  :  Integer;
                  Process   :  LongInt;

                  OpenOk,
                  Belongs2Me,
                  KeepFile
                            :  Boolean;

                  Constructor Init(ProNo  :  LongInt);

                  Destructor Done;

                  Function GetScrSwapName(SeedName  :  Str255)  :  Str255;

                  Procedure Add_Scratch(FNo,
                                        KPath  :  Integer;
                                        RAddr  :  LongInt;
                                        KeySCr,
                                        MatchK :  Str255);


                  Procedure Get_Scratch(TRepScr:  RepScrRec);

                end; {Object}


  Function GetSwapName(SwapName :  Str10)  :  Str255;

  Function FullScratchKey(ProNo  :  LongInt;
                          KeyScr :  Str255;
                          HedRec :  Boolean)  :  Str255;


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   SysUtils,
   ETStrU,
   ETMiscU,
   BtrvU2,
   BTKeys1U,
   Excep3U,
{$IFDEF EXSQL}
   SQLUtils,
{$ENDIF}
   BTSupU1;


 Var
   ScrtCount  :  Integer;


{ ===== Function to Make up SratchK ===== }


Function FullScratchKey(ProNo  :  LongInt;
                        KeyScr :  Str255;
                        HedRec :  Boolean)  :  Str255;



Begin

  If (HedRec) then
    FullScratchKey:=KeyScr+FullNomKey(ProNo)+HelpKStop
  else
    FullScratchKey:=FullNomKey(ProNo)+KeyScr+HelpKStop;

end; {Func..}


{ ============= Function to Return Next Available Swap File Name, For MultiUser reasons =============== }

Function GetSwapName(SwapName :  Str10)  :  Str255;

Const
  SwapDefaultExt  =  '.SWP';

Var
  n,IOChk     :  Integer;

  SwapFileName,
  TDirN       :  Str255;
  NumStr      :  Str10;

Begin
  {$I-}

  n:=1;

  TDirN:=GetSwapDir;

  Repeat

    Str(n:0,NumStr);

    {$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
     SwapFileName:=TDirN+SwapName+NumStr+'.DAT'
    else
    {$ENDIF}
      SwapFileName:=TDirN+SwapName+NumStr+SwapDefaultExt;

    Inc(n);

  //RB 07/06/2017 2017-R2 ABSEXCH-14156: Temporary Data Files limited to 255 files- Causing Form Printing to Crash (Exch365)
  //$REP9999 max Limit of 8 character according to 8.3 filenames
{$IFDEF EXSQL}
  Until (Not SQLUtils.TableExists(SetDrive+SwapFileName)) or (n>9999);
{$ELSE}
  Until (Not FileExists(SetDrive+SwapFileName)) or (n>9999);
{$ENDIF}

  {$I+}

  GetSwapName:=SwapFileName;
end; {Func..}




{ ---------------------------------------------------------------- }

{  ScratchFile Methods }

{ ---------------------------------------------------------------- }



  Constructor ScratchFile.Init(ProNo  :  LongInt);

  Var
    KeyS       :  Str255;

    SetAccel   :  Integer;

    iTries     :  Integer;
  Begin

    Process:=ProNo;

    SFnum:=ReportF;
    SKeypath:=RPK;

    SetAccel:=0;

    OpenOk:=BOn; {Assume already open}

    Belongs2Me:=BOff;

    KeepFile := BOff; { Delete file as default }

    Inc(ScrtCount);

    {* Unlike the DOS system, these scratch files can be shut down in any order, hence
       Belongs2Me cannot be relied upon to control the deletion of the file, instead a count
       is used to keep track of how many scratch objects are currently active, only when the count
       is down to 0, will the file be destroyed. *}

    If (Used_Recs(F[SFnum],SFnum)=0) then {* File Not Opened *}
    Begin

      SetAccel:=-1*Ord(AccelMode);

      {$IFDEF EXSQL}
      if SQLUtils.UsingSQL then
        FileNames[SFnum]:=GetScrSwapName('REP')
      else
      {$ENDIF}
        FileNames[SFnum]:=GetScrSwapName('$REP');

      //PR: 08/04/2011 Running the Report Engine from Sentimail there could be clashes between different sentinels
      //               creating scratch files at practically the same instant and both trying to use the
      //               same number. To avoid this, keep trying until the file can be created.
      {$IFDEF SENTREPENG}
      iTries := 1;
      repeat
        Status:=Make_File(F[SFnum],SetDrive+FileNames[SFnum],FileSpecOfs[SFnum]^,FileSpecLen[SFnum]);

        inc(iTries);

        if Status <> 0 then
        begin
          {$IFDEF EXSQL}
          if SQLUtils.UsingSQL then
            FileNames[SFnum]:=GetScrSwapName('REP')
          else
          {$ENDIF}
            FileNames[SFnum]:=GetScrSwapName('$REP');
        end;
      until (Status = 0) or (iTries > 255);
      {$ELSE}
        Status:=Make_File(F[SFnum],SetDrive+FileNames[SFnum],FileSpecOfs[SFnum]^,FileSpecLen[SFnum]);
      {$ENDIF}

      If (StatusOk) then
        Status:=Open_File(F[SFnum],SetDrive+FileNames[SFnum],SetAccel);

      Report_BError(SFnum,Status);

      OpenOk:=StatusOk;

      Belongs2Me:=OpenOk;  {* Make this instance owner of file *}

      If (OpenOk) then {* Set up Owner of file *}
        Add_Scratch(0,-2,0,'','');

    end {If used..}
    else
    Begin  {* Already open, in case same instance has been here before,
              delete all ocurrences of process number *}
      DeleteLinks(FullNomKey(Process),SFnum,Sizeof(Process),SKeypath,BOff);

    end;


  end; {Proc..}


  Destructor ScratchFile.Done;

  Var
    DelF    :  File of Byte;


  Begin
    Dec(ScrtCount);

    If (ScrtCount<=0) then
    Begin

      Status:=Close_File(F[SFnum]);

      If (StatusOk) and (Not KeepFile) then
      Begin

{$IFDEF EXSQL}

        SQLUtils.DeleteTable(SetDrive+FileNames[SFnum]);

{$ELSE}

        {$I-}

        AssignFile(DelF,SetDrive+FileNames[SFnum]);

        Erase(DelF);

        Report_IOError(IOResult,SetDrive+FileNames[SFnum]);

        {$I+}

{$ENDIF}

      end;

    end; {If Ok..}

  end; {Proc..}


  Function ScratchFile.GetScrSwapName(SeedName  :  Str255)  :  Str255;

  Var
    TmpStr  :  Str255;
    L       :  Byte;

  Begin

    TmpStr:=GetSwapName(SeedName);

    GetScrSwapName:=TmpStr;

  end;



  Procedure ScratchFile.Add_Scratch(FNo,
                                    KPath  :  Integer;
                                    RAddr  :  LongInt;
                                    KeySCr,
                                    MatchK :  Str255);



  Begin

    ResetRec(SFnum);


    With RepScr^ do
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
      Status:=Add_Rec(F[SFnum],SFnum,RecPtr[SFnum]^,SKeypath);

      Report_BError(SFNum,Status);

    end;

  end; {Proc..}


  Procedure ScratchFile.Get_Scratch(TRepScr:  RepScrRec);

  Var
    KeyS  :  Str255;

  Begin

    KeyS:='';

    ResetRec(TRepScr.FileNo);

    If ((OpenOk) and (TRepScr.Keypath>=0)) then {* Ignore Id Rec *}
    With TRepScr do
    Begin

      If (UseRad) then {* Access by Record Addr *}
      Begin

        SetDataRecOfs(FileNo,RecAddr);

        If (RecAddr<>0) then
          Status:=GetDirect(F[FileNo],FileNo,RecPtr[Fileno]^,KeyPath,0);

      end
      else
      Begin
        KeyS:=KeyStr;

        Status:=Find_Rec(B_GetEq,F[FileNo],FileNo,RecPtr[FileNo]^,Keypath,KeyS);

      end;

    end; {With..}

  end; {Proc..}


Initialization

  ScrtCount:=0;

end.
