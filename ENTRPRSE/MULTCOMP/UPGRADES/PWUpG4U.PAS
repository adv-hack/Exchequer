unit PWUpG4U;

{ markd6 17:09 06/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses
  ComCtrls,
  VarConst;


Function SetPWord_v552(Verbose  :  Boolean;
                   Var ProgBar  :  TProgressBar)  :  Integer;

Function NeedToRunv552(Var  ErrStr         :  String;
                       Var  TotalProgress  :  LongInt;
                            ForceRun       :  Boolean)  :  Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  GlobVar,
  Dialogs,
  Forms,
  ETStrU,
  ETMiscU,
  VarRec2U,
  BtrvU2,
  CommonU;



Const
   NoPWords1    =  429;   {Where old password end}

   {Page 1 next counter = 9}

   NoPWords     =  433;

   {Last pword no is 433. Page 1 last pno is 194}

   SetPWord  :  Array[NoPWords1+1..NoPWords] of PassListType =


{* EL: Note, you must set both PassNo, & PassLNo for index purposes.
On page 1 onwards, PassNo is record order relative to page only so it will always start
at 1 for each new page as Passno is a byte

*}



   {430} ((PassList:''; PassGrp:039; PassNo:191;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock - Bin - Allow Incomplete Allocation';
                        PassPage:01;  PassLNo:430),

   {431}  (PassList:''; PassGrp:039; PassNo:192;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock - Bin - Add Record ';
                        PassPage:01;  PassLNo:431),

   {432}  (PassList:''; PassGrp:039; PassNo:193;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock - Bin - Edit Record ';
                        PassPage:01;  PassLNo:432),

   {433}  (PassList:''; PassGrp:039; PassNo:194;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock - Bin - Delete Record ';
                        PassPage:01;  PassLNo:433)



  );






  { Result

    -1 Routine failed to initilaise, prob caused by bad Btrieve installation or bad dir

     0 = Success

     1-255  Btrieve error in file PwrdF

  }


Function SetPWord_v552(Verbose  :  Boolean;
                   Var ProgBar  :  TProgressBar)  :  Integer;


var
   KeyF          :   Str255;

   NextNo        :   LongInt;

Begin
  Result:=-1; {Never got started}

  Open_System(PWrdF,PWrdF);

  try

    For NextNo:=NoPWords1+1 to NoPwords do
    With PassWord do
    Begin
      Result:=0;

      Application.ProcessMessages;

      KeyF:='L'+#0+SetPadNo(Form_Int(SetPWord[NextNo].PassGrp,0),3)+SetPadNo(Form_Int(SetPWord[NextNo].PassLNo,0),3);


      Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,0,KeyF);

      If (Status=0) then
        Status:=Delete_Rec(F[PWrdF],PWrdF,0);

      FillChar(PassWord,Sizeof(PassWord),0);

      RecPfix:='L';

      PassListRec:=SetPWord[NextNo];

      FillChar(PassListRec.Spare2,Sizeof(PassListRec.Spare2),0);

      PassListRec.PassList:=SetPadNo(Form_Int(PassListRec.PassGrp,0),3)+SetPadNo(Form_Int(PassListRec.PassLNo,0),3);

      Inc(TotalCount);

      If (Verbose) and (Assigned(ProgBar)) then
        ProgBar.Position:=TotalCount;

      Application.ProcessMessages;

      Status:=Add_Rec(F[PWrdF],PWrdF,RecPtr[PWrdF]^,0);

      If (Result=0) then {* only show this once *}
        Report_BError(PwrdF,Status);

      If (Status<>0) then
        Result:=Status;

      //Writeln(PassListRec.PassDesc,' - Status: ',Status:5);
    end;

  Finally

    Close_Files(True);


  end; {Try..}
end; {Proc..}

{ == Function to check if last password present == }

Function NeedToRunv552(Var  ErrStr         :  String;
                       Var  TotalProgress  :  LongInt;
                            ForceRun       :  Boolean)  :  Boolean;

Var
  KeyF          :   Str255;
  NextNo        :   Integer;

Begin
  Result:=False;

  ErrStr:='Addition of v5.52 Passwords.';

  Open_System(PWrdF,PWrdF);

  try
    NextNo:=NoPWords;

    KeyF:='L'+#0+SetPadNo(Form_Int(SetPWord[NextNo].PassGrp,0),3)+SetPadNo(Form_Int(SetPWord[NextNo].PassLNo,0),3);

    Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,0,KeyF);

    Result:=(Status In [4]);

    If (ForceRun) then
      Result:=true;

    If (Result) then
      TotalProgress:=TotalProgress+(NoPWords-NoPWords1+8);
  finally


    Close_Files(True);

  end; {try..}


end;


end.
