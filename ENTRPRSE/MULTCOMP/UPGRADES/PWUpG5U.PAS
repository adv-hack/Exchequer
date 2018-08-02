unit PWUpG5U;

{ markd6 17:09 06/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses
  ComCtrls,
  VarConst;


Function SetPWord_v560(Verbose  :  Boolean;
                   Var ProgBar  :  TProgressBar)  :  Integer;

Function NeedToRunv560(Var  ErrStr         :  String;
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
   NoPWords1    =  433;   {Where old password end}

   {Page 1 next counter = 9}

   NoPWords     =  504;

   {Last pword no is 504. Page 2 last pno is 7}

   SetPWord  :  Array[NoPWords1+1..NoPWords] of PassListType =


{* EL: Note, you must set both PassNo, & PassLNo for index purposes.
On page 1 onwards, PassNo is record order relative to page only so it will always start
at 1 for each new page as Passno is a byte

*}



   {434}  ((PassList:''; PassGrp:166; PassNo:195;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Purchase Applications - Access Daybook ';
                        PassPage:01;  PassLNo:434),

   {435}  (PassList:''; PassGrp:166; PassNo:196;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Purchase Applications - Add ';
                        PassPage:01;  PassLNo:435),

   {436}  (PassList:''; PassGrp:166; PassNo:197;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Purchase Applications - Edit ';
                        PassPage:01;  PassLNo:436),

   {437}  (PassList:''; PassGrp:166; PassNo:198;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Purchase Applications - Find ';
                        PassPage:01;  PassLNo:437),

   {438}  (PassList:''; PassGrp:166; PassNo:199;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Purchase Applications - Hold ';
                        PassPage:01;  PassLNo:438),


   {439}  (PassList:''; PassGrp:166; PassNo:200;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Purchase Applications - Daybook Post ';
                        PassPage:01;  PassLNo:439),

   {440}  (PassList:''; PassGrp:166; PassNo:201;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Purchase Applications - Print';
                        PassPage:01;  PassLNo:440),

   {441}  (PassList:''; PassGrp:166; PassNo:202;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Purchase Applications - Delete';
                        PassPage:01;  PassLNo:441),


   {442}  (PassList:''; PassGrp:166; PassNo:203;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Purchase Applications - Copy/Reverse';
                        PassPage:01;  PassLNo:442),


   {443}  (PassList:''; PassGrp:168; PassNo:204;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Sales Applications - Access Daybook ';
                        PassPage:01;  PassLNo:443),

   {444}  (PassList:''; PassGrp:168; PassNo:205;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Sales Applications - Add ';
                        PassPage:01;  PassLNo:444),

   {445}  (PassList:''; PassGrp:168; PassNo:206;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Sales Applications - Edit ';
                        PassPage:01;  PassLNo:445),

   {446}  (PassList:''; PassGrp:168; PassNo:207;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Sales Applications - Find ';
                        PassPage:01;  PassLNo:446),

   {447}  (PassList:''; PassGrp:168; PassNo:208;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Sales Applications - Hold ';
                        PassPage:01;  PassLNo:447),


   {448}  (PassList:''; PassGrp:168; PassNo:209;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Sales Applications - Daybook Post ';
                        PassPage:01;  PassLNo:448),

   {449}  (PassList:''; PassGrp:168; PassNo:210;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Sales Applications - Print';
                        PassPage:01;  PassLNo:449),

   {450}  (PassList:''; PassGrp:168; PassNo:211;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Sales Applications - Delete';
                        PassPage:01;  PassLNo:450),


   {451}  (PassList:''; PassGrp:168; PassNo:212;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Sales Applications - Copy/Reverse';
                        PassPage:01;  PassLNo:451),


   {452}  (PassList:''; PassGrp:081; PassNo:213;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Job View, Access Purchase Terms';
                        PassPage:01;  PassLNo:452),


   {453}  (PassList:''; PassGrp:081; PassNo:214;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Job View, Access Sales Terms';
                        PassPage:01;  PassLNo:453),

   {454}  (PassList:''; PassGrp:081; PassNo:215;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Job View, Access Contract Terms';
                        PassPage:01;  PassLNo:454),


   {455}  (PassList:''; PassGrp:104; PassNo:216;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Employee Records, Access Contract Terms';
                        PassPage:01;  PassLNo:455),

   {456}  (PassList:''; PassGrp:104; PassNo:217;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Employee Records, Access Applications';
                        PassPage:01;  PassLNo:456),

   {457}  (PassList:''; PassGrp:170; PassNo:218;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Sales Applications - Allow Cummulative Edit on Terms';
                        PassPage:01;  PassLNo:457),

   {458}  (PassList:''; PassGrp:170; PassNo:219;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Sales Applications - Allow Override of Discounts on Application';
                        PassPage:01;  PassLNo:458),

   {459}  (PassList:''; PassGrp:170; PassNo:220;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Sales Applications - Allow Override of Retentions on Application';
                        PassPage:01;  PassLNo:459),


   {460}  (PassList:''; PassGrp:171; PassNo:221;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Purchase Applications - Allow Cummulative Edit on Terms';
                        PassPage:01;  PassLNo:460),

   {461}  (PassList:''; PassGrp:171; PassNo:222;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Purchase Applications - Allow Override of Discounts on Application';
                        PassPage:01;  PassLNo:461),

   {462}  (PassList:''; PassGrp:171; PassNo:223;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Purchase Applications - Allow Override of Retentions on Application';
                        PassPage:01;  PassLNo:462),


   {463}  (PassList:''; PassGrp:042; PassNo:224;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Customer Details - View Job Costing Applications';
                        PassPage:01;  PassLNo:463),

   {464}  (PassList:''; PassGrp:043; PassNo:225;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Details - View Job Costing Applications';
                        PassPage:01;  PassLNo:464),


   {465}  (PassList:''; PassGrp:172; PassNo:226;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Valuations - Allow Edit of Job Budget Record';
                        PassPage:01;  PassLNo:465),

   {466}  (PassList:''; PassGrp:172; PassNo:227;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Valuations - Allow Contract Valuations to lower levels';
                        PassPage:01;  PassLNo:466),

   {467}  (PassList:''; PassGrp:172; PassNo:228;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Valuations - Set Job Valuation based on Expenditure';
                        PassPage:01;  PassLNo:467),

   {468}  (PassList:''; PassGrp:174; PassNo:229;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Reports, Access Application Reports';
                        PassPage:01;  PassLNo:468),

   {469}   (PassList:''; PassGrp:040; PassNo:230; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Stock Records - View';
                     PassPage:1;  PassLNo:469),

   {470}   (PassList:''; PassGrp:042; PassNo:231; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Customer Details - Stock Analysis - Delete Entry';
                     PassPage:1;  PassLNo:470),

   {471}   (PassList:''; PassGrp:043; PassNo:232; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Supplier Details - Stock Analysis - Delete Entry';
                     PassPage:1;  PassLNo:471),

   {472}   (PassList:''; PassGrp:040; PassNo:233; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Stock Records - Copy';
                     PassPage:1;  PassLNo:472),

   {473}   (PassList:''; PassGrp:040; PassNo:234; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Stock Records - Check';
                     PassPage:1;  PassLNo:473),

   {474}   (PassList:''; PassGrp:040; PassNo:235; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Stock Records - Access Sale Prices';
                     PassPage:1;  PassLNo:474),

{-------------->>>}
   {475}   (PassList:''; PassGrp:145; PassNo:236; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Get Customer Fields';
                     PassPage:1;  PassLNo:475),

   
   {476}   (PassList:''; PassGrp:145; PassNo:237; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Get Customer Aging';
                     PassPage:1;  PassLNo:476),

   {477}   (PassList:''; PassGrp:145; PassNo:238; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Get Customer History';
                     PassPage:1;  PassLNo:477),

   {478}   (PassList:''; PassGrp:145; PassNo:239; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Save Customer Fields';
                     PassPage:1;  PassLNo:478),

   
   {494}   (PassList:''; PassGrp:145; PassNo:253; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Get/Save TeleSales Entry';
                     PassPage:1;  PassLNo:494),


   {480}   (PassList:''; PassGrp:146; PassNo:241; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Get Supplier Fields';
                     PassPage:1;  PassLNo:480),


   {481}   (PassList:''; PassGrp:146; PassNo:242; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Get Supplier Aging';
                     PassPage:1;  PassLNo:481),

   {482}   (PassList:''; PassGrp:146; PassNo:243; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Get Supplier History';
                     PassPage:1;  PassLNo:482),


   {483}   (PassList:''; PassGrp:146; PassNo:244; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Save Supplier Fields';
                     PassPage:1;  PassLNo:483),

   
   {485}   (PassList:''; PassGrp:146; PassNo:246; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Get Cost Centre';
                     PassPage:1;  PassLNo:485),

   {486}   (PassList:''; PassGrp:146; PassNo:247; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Get Department';
                     PassPage:1;  PassLNo:486),

   {487}   (PassList:''; PassGrp:146; PassNo:248; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Access to G/L Functions';
                     PassPage:1;  PassLNo:487),

   {488}   (PassList:''; PassGrp:146; PassNo:247; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Add Nom Transfer';
                     PassPage:1;  PassLNo:488),

   {489}   (PassList:''; PassGrp:147; PassNo:248; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Get Stock Fields';
                     PassPage:1;  PassLNo:489),

   {490}   (PassList:''; PassGrp:147; PassNo:249; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Get Stock History';
                     PassPage:1;  PassLNo:490),

   {491}   (PassList:''; PassGrp:147; PassNo:250; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Save Stock Fields';
                     PassPage:1;  PassLNo:491),

   {492}   (PassList:''; PassGrp:147; PassNo:251; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Save Stock Budgets';
                     PassPage:1;  PassLNo:492),

   {493}   (PassList:''; PassGrp:147; PassNo:252; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Get/Save Alt Stk Fields';
                     PassPage:1;  PassLNo:493),

   {479}   (PassList:''; PassGrp:149; PassNo:240; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Get Job Analysis Code Fields';
                     PassPage:1;  PassLNo:479),

   {484}   (PassList:''; PassGrp:149; PassNo:245; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Save Job Analysis Code Fields';
                     PassPage:1;  PassLNo:484),

   {495}   (PassList:''; PassGrp:149; PassNo:254; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Get Employee Fields';
                     PassPage:1;  PassLNo:495),

   {496}   (PassList:''; PassGrp:149; PassNo:255; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Get Time Rate Fields';
                     PassPage:1;  PassLNo:496),

   {497}   (PassList:''; PassGrp:149; PassNo:1; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Add Job';
                     PassPage:2;  PassLNo:513),


   {498}   (PassList:''; PassGrp:149; PassNo:2; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Get Job Fields';
                     PassPage:2;  PassLNo:514),


   {499}   (PassList:''; PassGrp:149; PassNo:3; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Get Job History';
                     PassPage:2;  PassLNo:515),

   {500}   (PassList:''; PassGrp:149; PassNo:4; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Save Job Fields';
                     PassPage:2;  PassLNo:516),

   {501}   (PassList:''; PassGrp:149; PassNo:4; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Save Job History';
                     PassPage:2;  PassLNo:517),

   {502}   (PassList:''; PassGrp:149; PassNo:5; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Save Timesheet';
                     PassPage:2;  PassLNo:518),

   {503}   (PassList:''; PassGrp:149; PassNo:6; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Excel OLE - Allow Save Timesheet with Cost';
                     PassPage:2;  PassLNo:519),

   {504}   (PassList:''; PassGrp:054; PassNo:7; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Report Writer - Change Security';
                     PassPage:2;  PassLNo:520)

  );






  { Result

    -1 Routine failed to initilaise, prob caused by bad Btrieve installation or bad dir

     0 = Success

     1-255  Btrieve error in file PwrdF

  }


Function SetPWord_v560(Verbose  :  Boolean;
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

Function NeedToRunv560(Var  ErrStr         :  String;
                       Var  TotalProgress  :  LongInt;
                            ForceRun       :  Boolean)  :  Boolean;

Var
  KeyF          :   Str255;
  NextNo        :   Integer;

Begin
  Result:=False;

  ErrStr:='Addition of v5.60 Passwords.';

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
