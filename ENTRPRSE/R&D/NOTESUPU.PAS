unit NoteSupU;

interface

Uses
  GlobVar,
  VarConst;


Const
  FirstDDate    =  '19500101';

  //PR: 02/11/2011 Moved from NoteU
  ntAudit = '3';


Function PartNoteKey(RC,ST  :  Char;
                     CCode  :  Str20)  :  Str30;

Function PartGNoteKey(RC,ST,NT  :  Char;
                      CCode     :  Str10)  :  Str30;

Function FullRNoteKey(CCode  :  Str10;
                      NT     :  Char;
                      LineNo :  LongInt)  :  Str20;

Procedure Delete_Notes(NoteType  :  Char;
                       NoteFolio :  Str10);

Procedure ChangeNoteFolio(NoteType
                                 :  Char;
                          OCode,
                          NCode  :  Str10);

Procedure CopyNoteFolio(ONoteType,
                        NNoteType
                               :  Char;
                        OCode,
                        NCode  :  Str10;
                        LNoOffset
                               :  Integer);


Function Check_NoteNo(NoteType  :  Char;
                      NoteFolio :  Str10)  :  LongInt;


Function ExtNoteKey(NK  :  Str30)  :  Str30;

Function GetNoteType(NT  :  Char)  :  Byte;

Procedure LinkFNote(NC  :  Char;
                    NK  :  Str10);

Function NoteSource_Desc(NC  :  Char;
                         NK  :  Str10)  :  Str80;


Procedure Add_Notes(NoteType,
                    NoteSType  :  Char;
                    FolioCode  :  Str10;
                    NDate      :  LongDate;
                    NDesc      :  Str80;
                Var DLineCount :  LongInt);

//PR: 10/07/2012 ABSEXCH-12784 Function to check if a transaction has any notes other than audit notes.
function HasNonAuditNotes(const InvR : InvRec) : Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Forms,
  ETMiscU,
  BtrvU2,
  BtKeys1U,
  BTSupU1,
  BTSupU2,
  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF} // EXSQL
  InvListU;



{ ============ Key Building routines =========== }

Function PartNoteKey(RC,ST  :  Char;
                     CCode  :  Str20)  :  Str30;

Begin

  PartNoteKey:=RC+ST+CCode;

end; {Func..}


Function PartGNoteKey(RC,ST,NT  :  Char;
                      CCode     :  Str10)  :  Str30;


Begin

  PartGNoteKey:=PartNoteKey(RC,ST,FullNCode(CCode))+NT;

end;


Function FullRNoteKey(CCode  :  Str10;
                      NT     :  Char;
                      LineNo :  LongInt)  :  Str20;


Begin

  FullRNoteKey:=FullNCode(CCode)+NT+Dec2Hex(LineNo);

end;



{ ============= Procedure to Delete Cust / Docs Notes =========== }

Procedure Delete_Notes(NoteType  :  Char;
                       NoteFolio :  Str10);

Const
  Fnum      =  PWrdF;

  Keypath   =  PWk;

Var
  GenStr    :  Str255;

  TmpStat,
  TmpKPath    :  Integer;

  TmpRecAddr
              :  LongInt;


Begin

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

  GenStr:=PartNoteKey(NoteTCode,NoteType,FullNCode(NoteFolio));

  DeleteLinks(GenStr,Fnum,Length(GenStr),Keypath,BOff);

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOn);

end;



{ ================== Procedure to Change All Codes Associated with One Link ============= }

Procedure ChangeNoteFolio(NoteType
                                 :  Char;
                          OCode,
                          NCode  :  Str10);

Const
  Fnum      =  PWrdF;

  Keypath   =  PWk;


Var
  KeyS,
  KeyChk
        :  AnyStr;
  Locked:  Boolean;
  B_Func:  Integer;

  LAddr :  LongInt;

  TmpStat,
  TmpKPath    :  Integer;

  TmpRecAddr
              :  LongInt;

  TmpPWrd     :  PassWordRec;


Begin

  KeyChk:=PartNoteKey(NoteTCode,NoteType,OCode);

  KeyS:=KeyChk;

  TmpPWrd:=PassWord;

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);


  B_Func:=B_GetNext;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);



  While (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (StatusOk) do
  With PassWord do
  With NotesRec do
  Begin

    //PR: 04/11/2011 Prevent audit notes being copied from one owner to another
    if NType <> ntAudit then
    begin
      Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);


      If (Ok) and (Locked) then
      Begin

        NoteFolio:=NCode;

        NoteNo:=FullRNoteKey(NoteFolio,NType,LineNo);

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

        If (Debug) then Status_Means(Status);

        If (StatusOk) then
          B_Func:=B_GetGEq;

        Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
      end
      else
        B_Func:=B_GetNext;

    end //if NType <> ntAudit
    else
      B_Func:=B_GetNext;
      
    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

  PassWord:=TmpPWrd;
end; {Proc..}


{ ================== Procedure to Change All Codes Associated with One Link ============= }

Procedure CopyNoteFolio(ONoteType,
                        NNoteType
                               :  Char;
                        OCode,
                        NCode  :  Str10;
                        LNoOffset
                               :  Integer);

Const
  Fnum      =  PWrdF;

  Keypath   =  PWk;


Var
  KeyS,
  KeyChk
           :  AnyStr;
  Locked   :  Boolean;

  TmpStat,
  TmpKPath :  Integer;

  TmpRecAddr
           :  LongInt;

Begin

  KeyChk:=PartNoteKey(NoteTCode,ONoteType,OCode);

  KeyS:=KeyChk;


  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  TmpKPath:=Keypath;


  While (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (StatusOk) do
  With PassWord do
  With NotesRec do
  Begin

    //PR: 02/11/2011 Prevent audit notes being copied from one owner to another
    if NType <> ntAudit then
    begin
      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

      NoteFolio:=NCode;

      NoteNo:=FullRNoteKey(NoteFolio,NType,LineNo+LNoOffset);

      SubType:=NNoteType;

      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      If (Debug) then Status_Means(Status);

      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
    end;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


  end; {While..}

end; {Proc..}






{ ============= Function to Calculate the next actual Note No. ============ }
{ == Replicated in Exbtth1u for thread safe == }


Function Check_NoteNo(NoteType  :  Char;
                      NoteFolio :  Str10)  :  LongInt;


Const
  Fnum      =  PWrdF;

  Keypath   =  PWk;

Var
  KeyChk,
  KeyS,
  NewKey    :  Str255;

  BigCount, FNK  :  LongInt;

  B_Func    :  Integer;


Begin
  BigCount := 0;
  {$IFDEF EXSQL}
    If SQLUtils.UsingSQLAlternateFuncs And (NoteType In ['A', 'S']) Then
    Begin
      If (NoteType = 'A') Then
        // Customer / Supplier
        BigCount := GetLineNumberAccounts(SetDrive, NoteFolio)
      Else If (NoteType = 'S') Then
      Begin
        // Stock
        Move (NoteFolio[1], FNK, SizeOf(FNK));
        BigCount := GetLineNumberStock(SetDrive, FNK);
      End; // If (NoteType = 'S')
    End // If SQLUtils.UsingSQLAlternateFuncs
    Else
  {$ENDIF}
    Begin
      BigCount:=1;

      B_Func:=B_GetNext;

      NewKey:='';

      KeyChk:=PartNoteKey(NoteTCode,NoteType,FullNCode(NoteFolio));

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With Password.NotesRec do
      Begin

        If (LineNo>BigCount) then
          BigCount:=LineNo;


        {$IFDEF PREV432001} {Taken out as some corrupt ledgers can exceed 1E6 and then build keys which are in a loop}
          NewKey:=FullRNoteKey(NoteFolio,NType,LineNo);

          If (NewKey<>NoteNo) then {* Its the old form of numbering *}
          Begin

            NoteNo:=NewKey;

            Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

            B_Func:=B_GetGEq;
          end
          else
            B_Func:=B_GetNext;
        {$ENDIF}

        Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      end; {While..}

      If (BigCount>1) then {* Set Next Line to 1 more than largest line, leave if not used yet *}
        BigCount:=Succ(BigCount);
    End;

  Check_NoteNo:=BigCount;
end; {Func..}



Function GetNoteType(NT  :  Char)  :  Byte;
Begin
  Case NT of
    NoteManualCode: Result := 11;         // #2 - Workflow Diary
    NoteCCode  :  Result:=1;              // 'A' - Traders
    NoteDCode  :  Result:=2;              // 'D' - Transactions
    NoteSCode  :  Result:=3;              // 'S' - Stock
    NoteRCode  :  Result:=4;              // 'R' - Serial/Batch
    NoteLCode  :  Result:=7;              // 'L' - Location
    NoteJCode  :  Result:=8;              // 'J' - Job
    NotesdbCode:  Result:=9;              // 'B' - Alt Stock Code
    NoteECode  :  Result:=10;             // 'E' - Employee
    else          Begin
                    If (NT=NoteDpCode[BOff]) then
                      Result:=5           // 'P' - Dept
                    else
                      If (NT=NoteDpCode[BOn]) then
                        Result:=6         // 'T' - Cost Centre
                      else
                        Result:=0;
                 end;
  end; {Case..}
end;


Function ExtNoteKey(NK  :  Str30)  :  Str30;

Begin
  ExtNoteKey:=Copy(NK,1,CustKeyLen);
end;

Procedure LinkFNote(NC  :  Char;
                    NK  :  Str10);


Var
  NT    :  Byte;
  LStatus,
  Fnum
        :  Integer;
  Found10
        :  Str10;
  Found20
        :  Str20;
  KeyS  :  Str255;


Begin
  Found10:=''; Found20:='';

  NT:=GetNoteType(NC);

  Case NT of
    1  :  Begin
            Global_GetMainRec(CustF,NK);
          end;

    2  :  Begin
            KeyS:=NK;

            Fnum:=InvF;

            LStatus:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,InvFolioK,KeyS);

          end;

    3  :  Begin
            KeyS:=NK;

            Fnum:=StockF;

            LStatus:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,StkFolioK,KeyS);

          end;


    {$IFDEF SOP}

      4  :  Begin
              {* Wound need to search sequential thru *}
            end;

      7  :  GetMLoc(Application.MainForm,NK,Found10,Found20,-1);


    {$ENDIF}

    {$IFDEF PF_On}
    5,6  :  Begin

              GetCCDep(Application.MainForm,NK,Found20,(NT=6),-1);

            end;
    {$ENDIF}

    {$IFDEF JC}
    8  :  Begin
            KeyS:=NK;

            Fnum:=JobF;

            LStatus:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,JobFolioK,KeyS);

          end;

   10  :  Begin
            KeyS:=PartCCKey(JARCode,JASubAry[3])+NK;

            Fnum:=JMiscF;

            LStatus:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,JMK,KeyS);

          end;

    {$ENDIF}

    9  :  ;
  end; {Case..}

end;



Function NoteSource_Desc(NC  :  Char;
                         NK  :  Str10)  :  Str80;

Var
  NT  :  Byte;

Begin
  NT:=GetNoteType(NC);

  LinkFNote(NC,NK);

  Case NT of
    1  :  With Cust do
            Result:=dbFormatName(CustCode,Company);

    2  :  Result:=Inv.OurRef;

    3  :  With Stock do
            Result:=dbFormatName(StockCode,Desc[1]);

    4  :  Result:='Serial No. Record';

    5,6:  With PassWord.CostCtrRec  do
            Result:=dbFormatName(PCostC,CCDesc);

    7  :  With MLocCtrl^.MLocLoc do
            Result:=dbFormatName(loCode,loName);

    8  :  With JobRec^ do
            Result:=dbFormatName(JobCode,JobDesc);

    9  :  Result:='Stock Alternative Code';

   10  :  With JobMisc^,EmplRec do
             Result:=dbFormatName(EmpCode,EmpName);

   11  :  Result := '';

   else  Result:='Source not known!';


  end; {Case..}

end;



  Procedure Add_Notes(NoteType,
                      NoteSType  :  Char;
                      FolioCode  :  Str10;
                      NDate      :  LongDate;
                      NDesc      :  Str80;
                  Var DLineCount :  LongInt);


 Const
   Fnum      =  PWrdF;

   Keypath   =  PWk;


 Begin
   With Password,NotesRec do
   Begin

     ResetRec(Fnum);

     LineNo:=DLineCount;

     NType:=NoteSType;

     RecPfix:=NoteTCode;
     SubType:=NoteType;

     NoteDate:=NDate;

     NoteLine:=NDesc;

     NoteFolio:=FullNCode(FolioCode);

     NoteNo:=FullRNoteKey(NoteFolio,NType,LineNo);

     ShowDate:=(NoteDate<>'');

     Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

     Report_BError(Fnum,Status);

     If (StatusOk) then
       Inc(DLineCount);

   end; {With..}

 end; {Proc..}

//PR: 10/07/2012 ABSEXCH-12784 Function to check if a transaction has any notes other than audit notes.
function HasNonAuditNotes(const InvR : InvRec) : Boolean;
Var
  KeyChk,
  KeyS    :  Str255;

  B_Func, B_Func2  :  Integer;
  Res     : Integer;
  Belongs : Boolean;
begin
  Result := False;


  KeyChk := PartNoteKey(NoteTCode,NoteDCode,FullNCode(FullNomKey(InvR.FolioNum)));
  KeyS:=KeyChk;

  //Folio number can be +ve or -ve, so set getxxx functions accordingly.
  If (InvR.FolioNum>0) then
  begin
    B_Func:=B_GetGEq;
    B_Func2 := B_GetNext
  end
  else
  begin
    B_Func:=B_GetLessEq;
    B_Func2 := B_GetPrev;

    KeyS:=KeyS+NdxWeight;
  end;


  Repeat
    Res := Find_Rec(B_Func,F[PWrdF],PWrdF,RecPtr[PWrdF]^,PWK,KeyS);

    //Does it belong to this transaction?
    Belongs := (Res = 0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));

    //Is it a non-audit note?
    Result := Belongs and (PassWord.NotesRec.NType <> ntAudit);

    if Belongs and not Result then //keep looking
      B_Func := B_Func2;

  until (Result or not Belongs);

end;


end.
