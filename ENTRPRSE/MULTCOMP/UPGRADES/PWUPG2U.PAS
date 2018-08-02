unit PWUPG2U;

{ markd6 17:09 06/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses
  ComCtrls,
  VarConst;


Function SetPWord_v440(Verbose  :  Boolean;
                   Var ProgBar  :  TProgressBar)  :  Integer;

Function NeedToRunv440(Var  ErrStr         :  String;
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
   NoPWords1    =  348;   {Where old password end}

   {Page 1 next counter = 9}

   NoPWords     =  416;

   {Last pword no is 416. Page 1 last pno is 177}

   SetPWord  :  Array[NoPWords1+1..NoPWords+4] of PassListType =


{* EL: Note, you must set both PassNo, & PassLNo for index purposes.
On page 1 onwards, PassNo is record order relative to page only so it will always start
at 1 for each new page as Passno is a byte

*}



   {349} ((PassList:''; PassGrp:046; PassNo:111;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Misc - Allow change of form when printing transactions';
                        PassPage:1;  PassLNo:349),

   {350}  (PassList:''; PassGrp:069; PassNo:112;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Utilities - Ability to Change My Password';
                        PassPage:1;  PassLNo:350),

   {351}  (PassList:''; PassGrp:069; PassNo:113;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Utilities - Ability to Lock Enterprise';
                        PassPage:1;  PassLNo:351),


   {352}  (PassList:''; PassGrp:045; PassNo:114;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Functions - Access to Change Global Period';
                        PassPage:1;  PassLNo:352),

   {353}  (PassList:''; PassGrp:042; PassNo:115;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Customer Details - View Works Order Ledger';
                        PassPage:1;  PassLNo:353),

   {354}  (PassList:''; PassGrp:035; PassNo:116;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - Allow Generation of Works Order';
                        PassPage:1;  PassLNo:354),

   {355}  (PassList:''; PassGrp:019; PassNo:117;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Ability to create Invoice (SIN)';
                        PassPage:1;  PassLNo:355),

   {356}  (PassList:''; PassGrp:019; PassNo:118;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Ability to create Receipt (SRC)';
                        PassPage:1;  PassLNo:356),

   {357}  (PassList:''; PassGrp:019; PassNo:119;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Ability to create Credit Note (SCR)';
                        PassPage:1;  PassLNo:357),

   {358}  (PassList:''; PassGrp:019; PassNo:120;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Ability to create Quotation (SQU)';
                        PassPage:1;  PassLNo:358),

   {359}  (PassList:''; PassGrp:019; PassNo:121;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Ability to create Journal Invoice (SJI)';
                        PassPage:1;  PassLNo:359),

   {360}  (PassList:''; PassGrp:019; PassNo:122;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Ability to create Journal Credit (SJC)';
                        PassPage:1;  PassLNo:360),

   {361}  (PassList:''; PassGrp:019; PassNo:123;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Ability to create Receipt with Invoice (SRI)';
                        PassPage:1;  PassLNo:361),

   {362}  (PassList:''; PassGrp:019; PassNo:124;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Ability to create Refund (SRF)';
                        PassPage:1;  PassLNo:362),

   {363}  (PassList:''; PassGrp:019; PassNo:125;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Ability to create Batch (SBT)';
                        PassPage:1;  PassLNo:363),


   {364}  (PassList:''; PassGrp:029; PassNo:126;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Ability to create Invoice (PIN)';
                        PassPage:1;  PassLNo:364),

   {365}  (PassList:''; PassGrp:029; PassNo:127;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Ability to create Payment (PPY)';
                        PassPage:1;  PassLNo:365),

   {366}  (PassList:''; PassGrp:029; PassNo:128;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Ability to create Credit Note (PCR)';
                        PassPage:1;  PassLNo:366),

   {367}  (PassList:''; PassGrp:029; PassNo:129;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Ability to create Quotation (PQU)';
                        PassPage:1;  PassLNo:367),

   {368}  (PassList:''; PassGrp:029; PassNo:130;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Ability to create Journal Invoice (PJI)';
                        PassPage:1;  PassLNo:368),

   {369}  (PassList:''; PassGrp:029; PassNo:131;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Ability to create Journal Credit (PJC)';
                        PassPage:1;  PassLNo:369),

   {370}  (PassList:''; PassGrp:029; PassNo:132;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Ability to create Payment with Invoice (PPI)';
                        PassPage:1;  PassLNo:370),

   {371}  (PassList:''; PassGrp:029; PassNo:133;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Ability to create Refund (PRF)';
                        PassPage:1;  PassLNo:371),

   {372}  (PassList:''; PassGrp:029; PassNo:134;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Ability to create Batch (PBT)';
                        PassPage:1;  PassLNo:372),

   {373}  (PassList:''; PassGrp:150; PassNo:135;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Order Processing - Access to Daybook';
                        PassPage:1;  PassLNo:373),


   {374}  (PassList:''; PassGrp:151; PassNo:136;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Order Processing - Access to History Daybook';
                        PassPage:1;  PassLNo:374),

   {375}  (PassList:''; PassGrp:152; PassNo:137;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Orders - Add a Transaction';
                        PassPage:1;  PassLNo:375),

   {376}  (PassList:''; PassGrp:152; PassNo:138;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Orders - Edit a Transaction';
                        PassPage:1;  PassLNo:376),

   {377}  (PassList:''; PassGrp:152; PassNo:139;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Orders - Print a Transaction';
                        PassPage:1;  PassLNo:377),

   {378}  (PassList:''; PassGrp:152; PassNo:140;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Orders - Find a Transaction';
                        PassPage:1;  PassLNo:378),

   {379}  (PassList:''; PassGrp:152; PassNo:141;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Orders - Hold a Transaction';
                        PassPage:1;  PassLNo:379),

   {380}  (PassList:''; PassGrp:152; PassNo:142;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Orders - Copy a Transaction';
                        PassPage:1;  PassLNo:380),

   {381}  (PassList:''; PassGrp:152; PassNo:143;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Orders - Issue an Individual Order';
                        PassPage:1;  PassLNo:381),

   {382}  (PassList:''; PassGrp:152; PassNo:144;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Orders - Prompt to issue when storing';
                        PassPage:1;  PassLNo:382),

   {383}  (PassList:''; PassGrp:152; PassNo:145;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Orders - Issue Picked Orders';
                        PassPage:1;  PassLNo:383),

   {384}  (PassList:''; PassGrp:152; PassNo:146;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Orders - Build an Individual Order';
                        PassPage:1;  PassLNo:384),

   {385}  (PassList:''; PassGrp:152; PassNo:147;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Orders - Prompt to build when storing';
                        PassPage:1;  PassLNo:385),

   {386}  (PassList:''; PassGrp:152; PassNo:148;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Orders - Build Picked Orders';
                        PassPage:1;  PassLNo:386),

   {387}  (PassList:''; PassGrp:152; PassNo:149;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Order Processing - Re-Print Issue Run';
                        PassPage:1;  PassLNo:387),

   {388}  (PassList:''; PassGrp:152; PassNo:150;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Order Processing - Re-Print Build Run';
                        PassPage:1;  PassLNo:388),


   {389}  (PassList:''; PassGrp:153; PassNo:151;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Order Processing - Access to Reports';
                        PassPage:1;  PassLNo:389),

   {390}  (PassList:''; PassGrp:154; PassNo:152;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Order Processing - Reports, Fulfilment';
                        PassPage:1;  PassLNo:390),

   {391}  (PassList:''; PassGrp:154; PassNo:153;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Order Processing - Reports, Order Explosion';
                        PassPage:1;  PassLNo:391),

   {392}  (PassList:''; PassGrp:154; PassNo:154;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Order Processing - Reports, Order Status';
                        PassPage:1;  PassLNo:392),

   {393}  (PassList:''; PassGrp:154; PassNo:155;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Order Processing - Reports, Work In Progress';
                        PassPage:1;  PassLNo:393),

   {394}  (PassList:''; PassGrp:155; PassNo:156;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Order - Add Line';
                        PassPage:1;  PassLNo:394),

   {395}  (PassList:''; PassGrp:155; PassNo:157;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Order - Edit Line';
                        PassPage:1;  PassLNo:395),

   {396}  (PassList:''; PassGrp:155; PassNo:158;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Order - Delete Line';
                        PassPage:1;  PassLNo:396),

   {397}  (PassList:''; PassGrp:155; PassNo:159;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Order - Insert Line';
                        PassPage:1;  PassLNo:397),

   {398}  (PassList:''; PassGrp:155; PassNo:159;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Order - Access Auto Menu';
                        PassPage:1;  PassLNo:398),

   {399}  (PassList:''; PassGrp:155; PassNo:160;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Works Order - Generate Works Order';
                        PassPage:1;  PassLNo:399),


   {400}  (PassList:''; PassGrp:048; PassNo:161;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Misc - Notes - Add Notes';
                        PassPage:1;  PassLNo:400),

   {401}  (PassList:''; PassGrp:048; PassNo:162;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Misc - Notes - Edit Notes';
                        PassPage:1;  PassLNo:401),

   {402}  (PassList:''; PassGrp:048; PassNo:163;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Misc - Notes - Insert Notes';
                        PassPage:1;  PassLNo:402),

   {403}  (PassList:''; PassGrp:048; PassNo:164;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Misc - Notes - Delete Notes';
                        PassPage:1;  PassLNo:403),

   {404}  (PassList:''; PassGrp:042; PassNo:165;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Customer Details - View Balance Information';
                        PassPage:1;  PassLNo:404),

   {405}  (PassList:''; PassGrp:158; PassNo:166;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sentimail - Access to Sentinel Manager';
                        PassPage:1;  PassLNo:405),

   {406}  (PassList:''; PassGrp:91; PassNo:167;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Timesheet Allow Cost Price Override';
                        PassPage:1;  PassLNo:406),

   {52}   (PassList:''; PassGrp:046; PassNo:52;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Functions - Access to ObjectPrint';
                        PassPage:0;  PassLNo:52),

   {195}  (PassList:''; PassGrp:062; PassNo:195; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Utilities - Access Data Recovery';
                        PassPage:0;  PassLNo:195),

   {407}  (PassList:''; PassGrp:140; PassNo:168;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Trade Counter - Allow Access to all Layaways';
                        PassPage:1;  PassLNo:407),

   {408}  (PassList:''; PassGrp:140; PassNo:169;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Trade Counter - Allow Delete Layaways';
                        PassPage:1;  PassLNo:408),

   {409}  (PassList:''; PassGrp:140; PassNo:170;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Trade Counter - Allow Find Global Transactions';
                        PassPage:1;  PassLNo:409),

   {410}  (PassList:''; PassGrp:019; PassNo:171;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Use Wizard to Create Sales Receipt';
                        PassPage:1;  PassLNo:410),

   {411}  (PassList:''; PassGrp:042; PassNo:172;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Customer Details - Use Wizard to Allocate';
                        PassPage:1;  PassLNo:411),

   {412}  (PassList:''; PassGrp:042; PassNo:173;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Customer Details - Allow Block Unallocate';
                        PassPage:1;  PassLNo:412),

   {413}  (PassList:''; PassGrp:029; PassNo:174;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Use Wizard to Create Purchase Payment';
                        PassPage:1;  PassLNo:413),

   {414}  (PassList:''; PassGrp:043; PassNo:175;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Details - Use Wizard to Allocate';
                        PassPage:1;  PassLNo:414),

   {415}  (PassList:''; PassGrp:043; PassNo:176;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Details - Allow Block Unallocate ';
                        PassPage:1;  PassLNo:415),

   {291}  (PassList:''; PassGrp:042; PassNo:36;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Customer Discounts - Check';
                        PassPage:1;  PassLNo:291),

   {292}  (PassList:''; PassGrp:043; PassNo:37;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Discounts - Add';
                        PassPage:1;  PassLNo:292),


   {416}  (PassList:''; PassGrp:053; PassNo:177;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Reports - Print On Order Report';
                        PassPage:1;  PassLNo:416)


  );



    No2Del    =  2;

  SetDelPWord :  Array[1..No2Del] of  PassListType =

    (
  {291}  (PassList:''; PassGrp:042; PassNo:36;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Customer Discounts - Check';
                        PassPage:1;  PassLNo:292),

  {140}   (PassList:''; PassGrp:053; PassNo:140; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print On Order Report';
                        PassPage:0;  PassLNo:140)


         );



  { Result

    -1 Routine failed to initilaise, prob caused by bad Btrieve installation or bad dir

     0 = Success

     1-255  Btrieve error in file PwrdF

  }


Function SetPWord_v440(Verbose  :  Boolean;
                   Var ProgBar  :  TProgressBar)  :  Integer;


var
   KeyF          :   Str255;

   NextNo        :   LongInt;

Begin
  Result:=-1; {Never got started}

  Open_System(PWrdF,PWrdF);

  try

    {Delete the ones which are being re-positioned first}
    For NextNo:=1 to No2Del do
    With PassWord do
    Begin
      Result:=0;

      Application.ProcessMessages;

      KeyF:='L'+#0+SetPadNo(Form_Int(SetDelPWord[NextNo].PassGrp,0),3)+SetPadNo(Form_Int(SetDelPWord[NextNo].PassLNo,0),3);


      Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,0,KeyF);

      If (Status=0) then
      Begin
        Status:=Delete_Rec(F[PWrdF],PWrdF,0);

        Inc(TotalCount);

        If (Verbose) and (Assigned(ProgBar)) then
          ProgBar.Position:=TotalCount;

        Application.ProcessMessages;

        If (Result=0) then {* only show this once *}
          Report_BError(PwrdF,Status);

        If (Status<>0) then
          Result:=Status;

      end;

    end;


    If (Result=0) then
    For NextNo:=NoPWords1+1 to NoPwords+4 do
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

Function NeedToRunv440(Var  ErrStr         :  String;
                       Var  TotalProgress  :  LongInt;
                            ForceRun       :  Boolean)  :  Boolean;

Var
  KeyF          :   Str255;
  NextNo        :   Integer;

Begin
  Result:=False;

  ErrStr:='Addition of v5.00 Passwords.';

  Open_System(PWrdF,PWrdF);

  try
    NextNo:=NoPWords;

    KeyF:='L'+#0+SetPadNo(Form_Int(SetPWord[NextNo].PassGrp,0),3)+SetPadNo(Form_Int(SetPWord[NextNo].PassLNo,0),3);

    Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,0,KeyF);

    Result:=(Status In [4]);

    If (ForceRun) then
      Result:=true;

    If (Result) then
      TotalProgress:=TotalProgress+(NoPWords-NoPWords1);
  finally


    Close_Files(True);

  end; {try..}


end;


end.
