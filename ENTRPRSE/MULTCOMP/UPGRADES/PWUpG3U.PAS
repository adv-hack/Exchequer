unit PWUPG3U;

{ markd6 17:09 06/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses
  ComCtrls,
  VarConst;


Function SetPWord_v550(Verbose  :  Boolean;
                   Var ProgBar  :  TProgressBar)  :  Integer;

Function NeedToRunv550(Var  ErrStr         :  String;
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
   NoPWords1    =  416;   {Where old password end}

   {Page 1 next counter = 9}

   NoPWords     =  429;

   {Last pword no is 429. Page 1 last pno is 190}

   SetPWord  :  Array[NoPWords1+1..NoPWords+8] of PassListType =


{* EL: Note, you must set both PassNo, & PassLNo for index purposes.
On page 1 onwards, PassNo is record order relative to page only so it will always start
at 1 for each new page as Passno is a byte

*}



   {246} ((PassList:''; PassGrp:160; PassNo:246;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'CIS/RCT - Access Ledger';
                        PassPage:0;  PassLNo:246),

   {247}  (PassList:''; PassGrp:160; PassNo:247;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'CIS/RCT - Allow Voucher/Certificate Generation';
                        PassPage:0;  PassLNo:247),

   {248}  (PassList:''; PassGrp:162; PassNo:248;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Reports, CIS/RCT Return';
                        PassPage:0;  PassLNo:248),

   {249}  (PassList:''; PassGrp:043; PassNo:249;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Details - Access CIS/RCT Ledger';
                        PassPage:0;  PassLNo:249),

   {250}  (PassList:''; PassGrp:104; PassNo:250;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Employee Records, - Access CIS/RCT Ledger';
                        PassPage:0;  PassLNo:250),

   {251}  (PassList:''; PassGrp:164; PassNo:251;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'CIS/RCT Ledger - Add';
                        PassPage:0;  PassLNo:251),
   {252}  (PassList:''; PassGrp:164; PassNo:252;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'CIS/RCT Ledger - Edit';
                        PassPage:0;  PassLNo:252),

   {253}  (PassList:''; PassGrp:164; PassNo:253;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'CIS/RCT Ledger - Allocate PIN';
                        PassPage:0;  PassLNo:253),

   {417}  (PassList:''; PassGrp:164; PassNo:178;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'CIS/RCT Ledger - Delete';
                        PassPage:01;  PassLNo:417),

   {418}  (PassList:''; PassGrp:164; PassNo:179;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'CIS/RCT Ledger - Filter';
                        PassPage:01;  PassLNo:418),
   {419}  (PassList:''; PassGrp:164; PassNo:180;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'CIS/RCT Ledger - Match';
                        PassPage:01;  PassLNo:419),

   {420}  (PassList:''; PassGrp:164; PassNo:181;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'CIS/RCT Ledger - Print';
                        PassPage:01;  PassLNo:420),

   {421}  (PassList:''; PassGrp:164; PassNo:182;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'CIS/RCT Ledger - Check';
                        PassPage:01;  PassLNo:421),

   {422}  (PassList:''; PassGrp:69; PassNo:183;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing -  Access to CIS/RCT Set-Up';
                        PassPage:01;  PassLNo:422),

   {423}  (PassList:''; PassGrp:39; PassNo:184;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock Locations - Access to Location Records';
                        PassPage:01;  PassLNo:423),

   {424}  (PassList:''; PassGrp:043; PassNo:185;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Details - View Balance Information';
                        PassPage:1;  PassLNo:424),

   {425}  (PassList:''; PassGrp:035; PassNo:186;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - Untag all tagged Orders';
                        PassPage:1;  PassLNo:425),

   {426}  (PassList:''; PassGrp:036; PassNo:187;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Orders - Untag all tagged Orders';
                        PassPage:1;  PassLNo:426),

   {427}  (PassList:''; PassGrp:047; PassNo:188;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Functions - Access to ObjectCredit Controller';
                        PassPage:1;  PassLNo:427),

   {428}  (PassList:''; PassGrp:081; PassNo:189;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Job Records, Move';
                        PassPage:1;  PassLNo:428),


   {429}  (PassList:''; PassGrp:047; PassNo:190;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'CIS/RCT - Access EDI Export';
                        PassPage:1;  PassLNo:429)


  );






  { Result

    -1 Routine failed to initilaise, prob caused by bad Btrieve installation or bad dir

     0 = Success

     1-255  Btrieve error in file PwrdF

  }


Function SetPWord_v550(Verbose  :  Boolean;
                   Var ProgBar  :  TProgressBar)  :  Integer;


var
   KeyF          :   Str255;

   NextNo        :   LongInt;

Begin
  Result:=-1; {Never got started}

  Open_System(PWrdF,PWrdF);

  try

    For NextNo:=NoPWords1+1 to NoPwords+8 do
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

Function NeedToRunv550(Var  ErrStr         :  String;
                       Var  TotalProgress  :  LongInt;
                            ForceRun       :  Boolean)  :  Boolean;

Var
  KeyF          :   Str255;
  NextNo        :   Integer;

Begin
  Result:=False;

  ErrStr:='Addition of v5.50 Passwords.';

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
