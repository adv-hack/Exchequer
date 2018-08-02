unit PWUpG6U;

{ markd6 17:09 06/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses
  ComCtrls,
  VarConst;


Function SetPWord_v570(Verbose  :  Boolean;
                   Var ProgBar  :  TProgressBar)  :  Integer;

Function NeedToRunv570(Var  ErrStr         :  String;
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
   NoPWords1    =  504;   {Where old password end}

   {Page 1 next counter = 9}

   NoPWords     =  569;  {546 is readding of Misc negative pwords, so new page counts remmain}

   {Last pword no is 569. Page 2 last pno is 71}

   SetPWord  :  Array[NoPWords1+1..NoPWords] of PassListType =


{* EL: Note, you must set both PassNo, & PassLNo for index purposes.
On page 1 onwards, PassNo is record order relative to page only so it will always start
at 1 for each new page as Passno is a byte

*}



   {505}  ((PassList:''; PassGrp:019; PassNo:8;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Generate Sales Return';
                        PassPage:02;  PassLNo:505),

   {506}  (PassList:''; PassGrp:028; PassNo:9;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Purchase - Generate Purchase Return';
                        PassPage:02;  PassLNo:506),

   {507}  (PassList:''; PassGrp:035; PassNo:10;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Sales Orders - Generate Sales Return';
                        PassPage:02;  PassLNo:507),

   {508}  (PassList:''; PassGrp:036; PassNo:11;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Purchase Orders - Generate Purchase Return';
                        PassPage:02;  PassLNo:508),

   {509}  (PassList:''; PassGrp:042; PassNo:12;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Customer Details - View Returns Ledger';
                        PassPage:02;  PassLNo:509),

   {510}  (PassList:''; PassGrp:043; PassNo:13;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Supplier Details - View Returns Ledger';
                        PassPage:02;  PassLNo:510),


   {511}  (PassList:''; PassGrp:041; PassNo:14;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Stock Ledger - Generate Return';
                        PassPage:02;  PassLNo:511),

   {512}  (PassList:''; PassGrp:039; PassNo:15;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Stock Serial/Batch - Generate Purchase Return';
                        PassPage:02;  PassLNo:512),

   {513}  (PassList:''; PassGrp:039; PassNo:16;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Stock Serial/Batch - Generate Sales Return';
                        PassPage:02;  PassLNo:513),


   {514}  (PassList:''; PassGrp:152; PassNo:17;  Spare1:(0,0,0,0,0,0,0,0);
                                                    PassDesc:'Works Orders - Generate Purchase Return';
                        PassPage:02;  PassLNo:514),



   {515}  (PassList:''; PassGrp:175; PassNo:18;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Access to Daybook';
                        PassPage:02;  PassLNo:515),


   {516}  (PassList:''; PassGrp:175; PassNo:19;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Access to History Daybook';
                        PassPage:02;  PassLNo:516),

   {517}  (PassList:''; PassGrp:176; PassNo:20;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Add a Transaction';
                        PassPage:02;  PassLNo:517),

   {518}  (PassList:''; PassGrp:176; PassNo:21;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Edit a Transaction';
                        PassPage:02;  PassLNo:518),

   {519}  (PassList:''; PassGrp:176; PassNo:22;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Print a Transaction';
                        PassPage:02;  PassLNo:519),

   {520}  (PassList:''; PassGrp:176; PassNo:23;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Find a Transaction';
                        PassPage:02;  PassLNo:520),

   {521}  (PassList:''; PassGrp:176; PassNo:24;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Hold a Transaction';
                        PassPage:02;  PassLNo:521),

   {522}  (PassList:''; PassGrp:176; PassNo:25;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Copy a Transaction';
                        PassPage:02;  PassLNo:522),

   {523}  (PassList:''; PassGrp:176; PassNo:26;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Action an Individual Return';
                        PassPage:02;  PassLNo:523),

   {524}  (PassList:''; PassGrp:176; PassNo:27;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Prompt to action when storing';
                        PassPage:02;  PassLNo:524),

   {525}  (PassList:''; PassGrp:176; PassNo:28;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Action all Returns';
                        PassPage:02;  PassLNo:525),

   {526}  (PassList:''; PassGrp:176; PassNo:29;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Re-Print Action Run';
                        PassPage:02;  PassLNo:526),

   {527}  (PassList:''; PassGrp:176; PassNo:30;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Generate Purchase Return';
                        PassPage:02;  PassLNo:527),

   {528}  (PassList:''; PassGrp:177; PassNo:31;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Access to Reports';
                        PassPage:02;  PassLNo:528),



   {529}  (PassList:''; PassGrp:179; PassNo:32;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Return - Access to Daybook';
                        PassPage:02;  PassLNo:529),


   {530}  (PassList:''; PassGrp:179; PassNo:33;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Return - Access to History Daybook';
                        PassPage:02;  PassLNo:530),

   {531}  (PassList:''; PassGrp:180; PassNo:34;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Return - Add a Transaction';
                        PassPage:02;  PassLNo:531),

   {532}  (PassList:''; PassGrp:180; PassNo:35;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Return - Edit a Transaction';
                        PassPage:02;  PassLNo:532),

   {533}  (PassList:''; PassGrp:180; PassNo:36;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Return - Print a Transaction';
                        PassPage:02;  PassLNo:533),

   {534}  (PassList:''; PassGrp:180; PassNo:37;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Return - Find a Transaction';
                        PassPage:02;  PassLNo:534),

   {535}  (PassList:''; PassGrp:180; PassNo:38;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Return - Hold a Transaction';
                        PassPage:02;  PassLNo:535),

   {536}  (PassList:''; PassGrp:180; PassNo:39;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Return - Copy a Transaction';
                        PassPage:02;  PassLNo:536),

   {537}  (PassList:''; PassGrp:180; PassNo:40;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Return - Action an Individual Return';
                        PassPage:02;  PassLNo:537),

   {538}  (PassList:''; PassGrp:180; PassNo:41;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Return - Prompt to action when storing';
                        PassPage:02;  PassLNo:538),

   {539}  (PassList:''; PassGrp:180; PassNo:42;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Return - Action all Returns';
                        PassPage:02;  PassLNo:539),

   {540}  (PassList:''; PassGrp:176; PassNo:43;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Allow Daybook Post';
                        PassPage:02;  PassLNo:540),


   {541}  (PassList:''; PassGrp:181; PassNo:44;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Return - Access to Reports';
                        PassPage:02;  PassLNo:541),


   {542}  (PassList:''; PassGrp:182; PassNo:45;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Return - Allow Generation of Purchase Accrual';
                        PassPage:02;  PassLNo:542),

   {543}  (PassList:''; PassGrp:183; PassNo:46;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Return - Allow Generation of Sales Accrual';
                        PassPage:02;  PassLNo:543),

   {544}  (PassList:''; PassGrp:180; PassNo:47;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Return - Allow Daybook Post';
                        PassPage:02;  PassLNo:544),

   {545}  (PassList:''; PassGrp:175; PassNo:48;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Returns - Allow Access to Return Line Reasons List';
                        PassPage:02;  PassLNo:545),

   {546}  (PassList:''; PassGrp:048; PassNo:182;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Misc - Allow Negative Stock Levels';
                        PassPage:00;  PassLNo:182),


   {547}  (PassList:''; PassGrp:031; PassNo:49;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L Views - Access G/L Views Tree';
                        PassPage:02;  PassLNo:546),

   {548}  (PassList:''; PassGrp:031; PassNo:50;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L View Ctrl Records - Show Inactive Accounts';
                        PassPage:02;  PassLNo:547),

   {549}  (PassList:''; PassGrp:031; PassNo:51;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L View Ctrl Records - Add';
                        PassPage:02;  PassLNo:548),

   {550}  (PassList:''; PassGrp:031; PassNo:52;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L View Ctrl Records - Edit';
                        PassPage:02;  PassLNo:549),

   {551}  (PassList:''; PassGrp:031; PassNo:53;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L View Ctrl Records - Delete';
                        PassPage:02;  PassLNo:550),

   {552}  (PassList:''; PassGrp:031; PassNo:54;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L View Ctrl Records - Copy';
                        PassPage:02;  PassLNo:551),


   {553}  (PassList:''; PassGrp:031; PassNo:55;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L View Line Records - Add';
                        PassPage:02;  PassLNo:552),

  {554}  (PassList:''; PassGrp:031; PassNo:56;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L View Line Records - Edit';
                        PassPage:02;  PassLNo:553),

  {555}  (PassList:''; PassGrp:031; PassNo:57;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L View Line Records - Delete';
                        PassPage:02;  PassLNo:554),

  {556}  (PassList:''; PassGrp:031; PassNo:58;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L View Line Records - Delete All Views';
                        PassPage:02;  PassLNo:555),

  {557}  (PassList:''; PassGrp:031; PassNo:59;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L View Line Records - Refresh Totals';
                        PassPage:02;  PassLNo:556),


  {558}  (PassList:''; PassGrp:031; PassNo:60;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L Views - Access View 001-100';
                        PassPage:02;  PassLNo:557),

  {559}  (PassList:''; PassGrp:031; PassNo:61;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L Views - Access View 101-200';
                        PassPage:02;  PassLNo:558),

  {560}  (PassList:''; PassGrp:031; PassNo:62;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L Views - Access View 201-300';
                        PassPage:02;  PassLNo:559),

  {561}  (PassList:''; PassGrp:031; PassNo:63;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L Views - Access View 301-400';
                        PassPage:02;  PassLNo:560),

  {562}  (PassList:''; PassGrp:031; PassNo:64;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L Views - Access View 401-500';
                        PassPage:02;  PassLNo:561),

  {563}  (PassList:''; PassGrp:031; PassNo:65;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L Views - Access View 501-600';
                        PassPage:02;  PassLNo:562),


  {564}  (PassList:''; PassGrp:031; PassNo:66;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L Views - Access View 601-700';
                        PassPage:02;  PassLNo:563),

  {565}  (PassList:''; PassGrp:031; PassNo:67;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L Views - Access View 701-800';
                        PassPage:02;  PassLNo:564),


  {566}  (PassList:''; PassGrp:031; PassNo:68;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L Views - Access View 801-900';
                        PassPage:02;  PassLNo:565),


  {567}  (PassList:''; PassGrp:031; PassNo:69;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L Views - Access View 901-999';
                        PassPage:02;  PassLNo:566),

  {568}  (PassList:''; PassGrp:146; PassNo:70;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Excel OLE - Allow Access to G/L View Functions';
                        PassPage:02;  PassLNo:567),

  {569}  (PassList:''; PassGrp:031; PassNo:71;  Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'G/L View Line Records - Copy G/L Structure';
                        PassPage:02;  PassLNo:568)


  );







  { Result

    -1 Routine failed to initilaise, prob caused by bad Btrieve installation or bad dir

     0 = Success

     1-255  Btrieve error in file PwrdF

  }


Function SetPWord_v570(Verbose  :  Boolean;
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

      If (PassListRec.PassLNo<513) or (PassListRec.PassLNo>520) then {* Ignore the Returns pw as these numbers conflict with the OLE save passwords *}
      Begin
        Status:=Add_Rec(F[PWrdF],PWrdF,RecPtr[PWrdF]^,0);

        If (Result=0) then {* only show this once *}
          Report_BError(PwrdF,Status);
      end;

      If (Status<>0) then
        Result:=Status;

      //Writeln(PassListRec.PassDesc,' - Status: ',Status:5);
    end;

  Finally

    Close_Files(True);


  end; {Try..}
end; {Proc..}

{ == Function to check if last password present == }

Function NeedToRunv570(Var  ErrStr         :  String;
                       Var  TotalProgress  :  LongInt;
                            ForceRun       :  Boolean)  :  Boolean;

Var
  KeyF          :   Str255;
  NextNo        :   Integer;

Begin
  Result:=False;

  ErrStr:='Addition of v5.70 Passwords.';

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
