unit PWUpG7U;

{ markd6 17:09 06/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses
  ComCtrls,
  VarConst;


Function SetPWord_vLte(Verbose  :  Boolean;
                   Var ProgBar  :  TProgressBar)  :  Integer;

Function NeedToRunvLte(Var  ErrStr         :  String;
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
   NoPWords1    =  569;   {Where old password end}

   {Page 1 next counter = 9}

   NoPWords     =  582;

   {Last pword no is 572. Page 2 last pno is 82}

   SetPWord  :  Array[NoPWords1+1..NoPWords] of PassListType =


{* EL: Note, you must set both PassNo, & PassLNo for index purposes.
On page 1 onwards, PassNo is record order relative to page only so it will always start
at 1 for each new page as Passno is a byte

*}



   {570}  ((PassList:''; PassGrp:039; PassNo:72;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock Record - Allow Edit of G/L Codes';
                        PassPage:02;  PassLNo:570),

   {571}  (PassList:''; PassGrp:040; PassNo:73;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock Adjustment - Allow Edit of G/L Code';
                        PassPage:02;  PassLNo:571),

   {572}  (PassList:''; PassGrp:032; PassNo:74;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Nominal Transfers - Use Standard Journal Creation';
                        PassPage:02;  PassLNo:572),

   {573}  (PassList:''; PassGrp:039; PassNo:75;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Stock Serial/Batch - Generate Sales Return';
                        PassPage:02;  PassLNo:573),


   {574}  (PassList:''; PassGrp:152; PassNo:76;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Works Orders - Generate Purchase Return';
                        PassPage:02;  PassLNo:574),



   {575}  (PassList:''; PassGrp:175; PassNo:77;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Access to Daybook';
                        PassPage:02;  PassLNo:575),


   {576}  (PassList:''; PassGrp:175; PassNo:78;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Access to History Daybook';
                        PassPage:02;  PassLNo:576),

   {577}  (PassList:''; PassGrp:176; PassNo:79;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Add a Transaction';
                        PassPage:02;  PassLNo:577),

   {578}  (PassList:''; PassGrp:176; PassNo:80;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Edit a Transaction';
                        PassPage:02;  PassLNo:578),

   {579}  (PassList:''; PassGrp:176; PassNo:81;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Print a Transaction';
                        PassPage:02;  PassLNo:579),

   {580}  (PassList:''; PassGrp:176; PassNo:82;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Find a Transaction';
                        PassPage:02;  PassLNo:580),

   {193}  (PassList:''; PassGrp:054; PassNo:193; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Access to Report Writer';PassPage:00;  PassLNo:193),
   {194}  (PassList:''; PassGrp:054; PassNo:194; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Report Writer - Edit Report Layouts';PassPage:00;  PassLNo:194)
  );







  { Result

    -1 Routine failed to initilaise, prob caused by bad Btrieve installation or bad dir

     0 = Success

     1-255  Btrieve error in file PwrdF

  }


Function SetPWord_vLTE(Verbose  :  Boolean;
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

Function NeedToRunvLTE(Var  ErrStr         :  String;
                       Var  TotalProgress  :  LongInt;
                            ForceRun       :  Boolean)  :  Boolean;

Var
  KeyF          :   Str255;
  NextNo        :   Integer;

Begin
  Result:=False;

  ErrStr:='Addition of IAO Passwords & RW.';

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
