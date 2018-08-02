Unit ReBuildU;




{**************************************************************}
{                                                              }
{        ====----> E X C H E Q U E R Translate <----===        }
{                                                              }
{                      Created : 27/08/91                      }
{                                                              }
{                                                              }
{                     Common Overlaid Unit                     }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}


Interface

Uses
  GlobVar,
  VarConst,
  SFHeaderU,
  ProgU;

const
  SINGLE_SPACING_ON  = 502;
  SINGLE_SPACING_OFF = 503;


Procedure ReBuild_Files(ReSort,
                        AfterPurge  :  Boolean;
                        ProgBar     :  TSFProgressBar);


Procedure Calc_FileStats;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
     Windows,
     SysUtils,
     Messages,
     Forms,
     ETStrU,
     ETDateU,
     ETMiscU,
     BtrvU2,
     UnTils,
     Rebuld1U,
     LocalVar,
     ReBuld2U;











{ ========= Procedure to Rebuild a Single Btrieve file ======== }

Procedure ReBuild_File(Fnum,
                       Keypath
                             :  Integer;
                   Var RunOk :  Boolean;
                       TotalCount
                             :  LongInt;
                   Var LCount,
                       RCount:  LongInt;
                       ReSort:  Boolean;
                   Var WarnRN:  Boolean;
                       ProgBar
                             :  TSFProgressBar);



Var
  B_Func,
  B_Next,
  TStatus     :  Integer;

  Loop,
  AllDisp     :  Boolean;

  StartTime   :  Double;

  LocalCount,
  LastPos,
  CurrPos     :  LongInt;

  KeyS        :  Str255;

  procedure SetRTFSingleSpacing(Value : Integer);
  begin
    if Assigned(Application.MainForm) then
      SendMessage(Application.MainForm.Handle, WM_CUSTGETREC, Value, 0);
  end;

Begin

  LocalCount:=0;

  Loop:=ReSort;

  LastPos:=0;
  CurrPos:=0;

  TStatus:=0;

  AllDisp:=BOff;

  FillChar(KeyS,Sizeof(KeyS),0);

  If (ReSort) then
  Begin
    B_Func:=B_GetFirst;
    B_Next:=B_GetNext;

  end
  else
  Begin
    B_Func:=B_StepFirst;
    B_Next:=B_StepNext;
  end;


  StartTime:=TimeVal;

  Write_FixLogFmt(Fnum,DateTimeToStr(Now)+' > Begin rebuild of file... ',3);
  Write_FixLogFmt(Fnum,DateTimeToStr(Now)+' > Data path : '+SetDrive,3);


  Repeat

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    Status:=GetPos(F[Fnum],Fnum,CurrPos);

    While (Status In [0,54,22]) and (CurrPos<>LastPos) and (RunOk) do
    Begin

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));

      Application.ProcessMessages;

      AllDisp:=BOff;


      IF (Not RunOk) and (FixFile[Fnum].HedFixed) then
        Warn_NewHed(Fnum);

      If (Status In [22,54]) then
      Begin
        Disp_PartialRec(Fnum,LCount);

        AllDisp:=BOn;
      end;

      Status:=Add_Rec(F[BuildF],BuildF,RecPtr[BuildF]^,0);

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to temporary file, report error '+Form_Int(Status,0),4);

        If (Not AllDisp) then {* Don't display again *}
          Disp_PartialRec(Fnum,LCount);

      end
      else
      Begin

        Inc(RCount);

        Inc(LocalCount);

      end;

      Inc(LCount);



      RunOk:=(RunOk and (Status In [0,5]));

      If (LCount<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=LCount;



      Status:=Find_Rec(B_Next,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      If (Status In [0,54,22]) then {* Get posn, but keep error code *}
        TStatus:=GetPos(F[Fnum],Fnum,CurrPos);


    end; {While..}

    If (Not Loop) and (Status<>9) then
      Status:=GetPos(F[Fnum],Fnum,LastPos);



    B_Func:=B_StepLast;
    B_Next:=B_StepPrev;

    Loop:=Not Loop;

  Until (Status=9) or (Not Loop) or (Not RunOk);


  {* Close current BT Files *}


  Status:=Close_File(F[Fnum]);

  Status:=Close_File(F[BuildF]);


  If (RunOk) then
  Begin
    {* Write Summary of repair to log *}


    Write_FixLogFmt(Fnum,DateTimeToStr(Now)+' > Rebuild completed. Time Taken : '+FmtTime(TimeVal-StartTime,BOn),3);
    Write_FixMsg('');
    Write_FixLogFmt(Fnum,'Total No. records stored: '+#9+Form_Int(FixFile[Fnum].RecCount,0),3);
    Write_FixLogFmt(Fnum,'Total No. records recovered: '+#9+Form_Int(LocalCount,0),3);

    //PR: 14/03/2012 ABSEXCH-12118 Explicitly report if the number of records read is different from the number
    //according to the file header.
    //PR: 29/03/2012 ABSESXCH-12118 Was checking LCount (Grand total) instead of LocalCount (File Total).
    if FixFile[Fnum].RecCount <> LocalCount then
    begin
      Write_FixMsg('');
      Write_FixLogFmt(Fnum, '', 4);
      SetRTFSingleSpacing(SINGLE_SPACING_ON);
      Write_FixMsgFmt('There was a mismatch between the number of records found (' + Form_Int(LocalCount,0) + ')',4);
      Write_FixMsgFmt('and the number of records reported by the Pervasive file header (' + Form_Int(FixFile[Fnum].RecCount,0)+ ')',4);
      SetRTFSingleSpacing(SINGLE_SPACING_OFF);
    end;
    Write_FixMsg('');




    If (DeleteFile(SetDrive+FileNames[Fnum])) then {* Rename Temp File *}
    Begin
      If (Not ReNameFile(SetDrive+FileNames[BuildF],SetDrive+FileNames[Fnum])) then
      Begin
        WarnRN:=BOn;

        Write_FixMsgFmt('Unable to rename '+Filenames[BuildF]+' to '+FileNames[Fnum]+'.',4);
        Write_FixMsgFmt('Please rename manually before attempting to use ' + sAppName + '.',4);

      end
    end
    else
    Begin
      WarnRN:=BOn;

      Write_FixMsgFmt('Unable to erase '+Filenames[Fnum]+'!!',4);
      Write_FixMsgFmt('Please erase manually and rename '+Filenames[BuildF]+' to '+FileNames[Fnum]+',',4);

      Write_FixMsgFmt('before attempting to use ' + sAppName + '.',4);

    end;

  end
  else
  Begin  {* Its been aborted *}

    {* Write to Repair Log *}

    Write_FixLogFmt(Fnum,'Rebuild Aborted...'+DateTimeToStr(Now),4);

    Write_FixLog(Fnum,'');

    If (FixFile[Fnum].HedFixed) then
    Begin

      Write_FixLogFmt(Fnum,'This file has been modified due to data corruption and can no longer be',4);

      Write_FixLogFmt(Fnum,'used. The backup taken prior to this rebuild must be restored.',4);

    end;



    If (Not DeleteFile(SetDrive+FileNames[BuildF])) then {* Erase Temp File *}

    Begin

      Write_FixLogFmt(Fnum,'Unable to delete file '+FileNAmes[BuildF]+'. Please delete manually.',4);

    end;

  end;


  Write_FixMsg(ConstStr('-',80));


end; {Convert..}




{ ======== Procedure to Rebuild Selective Exchequer Data Files ====== }

Procedure ReBuild_Files(ReSort,
                        AfterPurge  :  Boolean;
                        ProgBar     :  TSFProgressBar);



Var
  n        :  Byte;


  Count,
  RCount,
  TotalCount
           :  LongInt;

  FreeSpace,
  KSpaceReq,
  SpaceReq :  Int64;

  RunOk,
  WarnFail :  Boolean;

  StartTime:  Double;


Begin

  RunOk:=BOn;  WarnFail:=BOff;

  Addch:=ResetKey;



  If (Addch<>Esc) then
  Begin

    StartTime:=TimeVal;

    For n:=1 to Totfiles do
      If (FixFile[n].Rebuild) then
        Open_RepairFiles(n,n,BOff,BOn,ProgBar); {* Open all files and check for a Rebuild header *}

    For n:=1 to Totfiles do
      If (FixFile[n].Rebuild) then
        Status:=Close_File(F[n]);

    Close_Files(BOn);

    FreeSpace:=DiskFree(0);

    If (FreeSpace<=0) then {* Then assume Its a massive value ! *}
      FreeSpace:=MaxLongInt;

    SpaceReq:=Check_FileSize;

    KSpaceReq:=Round(DivWChk(SpaceReq,1024));

    Count:=0;
    RCount:=0;
    TotalCount:=0;

    For n:=1 to Totfiles do
    With FixFile[n] do
    Begin

      Application.ProcessMessages;

      ReBuild:=(ReBuild and (FreeSpace>FileLength));

      If (ReBuild) then
      Begin

        PageSize:=GetPageSize(n);


        If (FixHed) then
        Begin

          MakeTempFile(n);

          If (CreateNFile) then
          Begin

            Status:=Close_File(F[BuildF]);

            Write_FixLogFmt(n,'Header rebuilt due to corruption.',4);

            ReBuild_Hed(n);

            Open_RepairFiles(n,n,BOff,BOn,ProgBar); {* Open file and check for a Rebuild header again *}

            ReBuild:=(Not FixHed);

            If (DeleteFile(SetDrive+FileNames[BuildF])) then ; {* Get rid of temp file *}

            If (Not ReBuild) then
            Begin

              Write_FixLogFmt(n,'This file requires manual data recovery. Please contact your dealer.',4);

            end;
          end; {If Temp File created ok}
        end {If Fix Hed}
        else
          Open_RepairFiles(n,n,BOff,BOn,ProgBar); {* Open file and check for a Rebuild header again *}

      end
      else
        If (FileLength>FreeSpace) then
        Begin

          Write_FixLogFmt(n,'Insufficieint free disk space. Required :'+Form_Int(FileLength,0)+'Kb. Available :'+
                          Form_Int(FreeSpace,0)+'Kb.',4);

        end;
    end; {* Loop..}


    For n:=1 to TotFiles do
    With FixFile[n] do
      If (ReBuild) then
      Begin

        RecCount:=Used_Recs(F[n],n);

        TotalCount:=TotalCount+RecCount;

      end;

    If (Assigned(ProgBar)) then
    Begin
      ProgBar.ProgressBar1.Max:=TotalCount;
      ProgBar.ProgLab.Caption:='Data Rebuild';
    end;

    Begin

      n:=1;

      While (RunOk) and (n<=TotFiles) do
      With FixFile[n] do
      Begin
        Application.ProcessMessages;

        If (ReBuild) then
        Begin

          If (Assigned(ProgBar)) then
            ProgBar.InfoLbl.Caption:='Rebuilding : '+SetDrive+FileNames[n];

          MakeTempFile(n);

          If (CreateNFile) then
            ReBuild_File(n,ProcessKey,RunOK,TotalCount,Count,RCount,ReSort,WarnFail,ProgBar);

        end;

        Inc(n);

      end; {Loop..}

    end; {If enough records present}

    If (WarnFail) then
    Begin
      Write_FixMsgFmt('WARNING! The ' + sAppName + ' Data Rebuild has NOT completed correctly.',4);
      Write_FixMsgFmt('It was not possible to either rename or delete some files.',4);
      Write_FixMsgFmt('Check the log above, and correct the cause of this failure,',4);
      Write_FixMsgFmt('before attempting to run this rebuild again.',4)
    end
    else
      Write_FixMsgFmt(sAppName + ' Data Rebuild completed.',3);


    Write_FixMsg('');
    Write_FixMsgFmt('Grand Total No. records stored . : '+#9+Form_Int(TotalCount,0),3);
    Write_FixMsgFmt('Grand Total No. records recovered: '+#9+Form_Int(RCount,0),3);
    Write_FixMsgFmt('Total Time Taken : '+#9+#9+#9+FmtTime(TimeVal-StartTime,BOn),3);
    Write_FixMsg('');
    Write_FixMsgFmt(ConstStr('=',80),3);


//    PostMessage(ProgBar.Handle,WM_Close,0,0);

  end; {If Abort..}

  FixFile[BuildF].ReBuild:=BOff;

end; {Proc..}




Procedure Calc_FileStats;

Var
  n,fv,Lowv  :  SmallInt;
  ThisVer    :  Integer;

Function Txlate_FVer  :  Byte;

Begin
  Case ThisVer of
    $50..$59  :  Result:=5;
    $60..$69  :  Result:=6;
    $70..$79  :  Result:=7;
    $80..$89  :  Result:=8;
    $90..$99  :  Result:=9;
    else         Result:=0;
  end; {Case..}
end;

Begin
  Lowv:=255;

  For n:=1 to TotFiles do
    FixFile[n].Rebuild:=BOn;

  Open_RepairFiles(1,TotFiles,BOff,BOn,Nil);

  Try
    Write_FixMsgFmt('Pervasive P.SQL '+sAppName+' file version check.',3);


    For n:=1 to TotFiles do
    If FixFile[n].Rebuild then
    Begin
      ThisVer:=File_VerCId(F[n],n,Nil);

      fv:=Txlate_FVer;

      If (fv<Lowv) then
        Lowv:=fv;

      If (fv>=6) then
        Write_FixMsgFmt(SetDrive+Filenames[n]+': v'+IntToStr(fv)+' format. OK',3)
      else
        If (fv=5) then
          Write_FixMsgFmt(SetDrive+Filenames[n]+': v'+IntToStr(fv)+' format. This file should be rebuilt to v6 format.',3)
        else
          Write_FixMsgFmt(setDrive+Filenames[n]+' Pre v5 data format, this file must be rebuilt before using Exchequer.',4);

      FixFile[n].Rebuild:=BOff;

    end;

    If (Lowv<6) then
    Begin
      Write_FixMsgFmt('One or more of the files has been in created in a format which will prevent protected mode posting',4);
      Write_FixMsgFmt('Rebuild these files before using Exchequer',4);
    end;
  finally;


   Close_Files(BOn);

  end; {Try..Fin}

end;











end. {Unit..}



  { ========= Proc to convert account data ========== }

Procedure PFMC_Customers(Var RunOk :  Boolean;
                         Var TotalCount,
                             LCount,
                             PCount:  LongInt;
                             ProgBar
                                   :  TGenProg);


Const
  Fnum      =  CustF;

Var
  KeyS  :  Str255;
  StartTime
        :  Int64;


Begin
  KeyS:='';

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting Accounts';

  StartTime:=TimeVal;

  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  While (StatusOk) and (RunOk) do
  With Cust do
  Begin
    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


    If (Currency=0) then
    Begin

      Inc(PCount);

      Currency:=1;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update Account record '+CustCode+', '+Company+
                ', report error '+Form_Int(Status,0),4);

      end;
    end;

    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  end; {While..}


  Begin
    Write_FixLogFmt(FNum,'Account currency update completed. '+FmtTime(TimeVal-StartTime,BOn),3);

  end; {With..}

end; {Proc..}
