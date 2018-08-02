unit PWUPG1U;

{ markd6 17:09 06/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses
  ComCtrls,
  VarConst;


Function SetPWord_v432(Verbose  :  Boolean;
                   Var ProgBar  :  TProgressBar)  :  Integer;

Function NeedToRunv432(Var  ErrStr         :  String;
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
   NoPWords1    =  302;   {Where old password end}

   {Page 1 next counter = 9}

   NoPWords     =  348;

   {Last pword no is 345. Page 1 last pno is 110}

   SetPWord  :  Array[NoPWords1+1..NoPWords+2] of PassListType =


{* EL: Note, you must set both PassNo, & PassLNo for index purposes.
On page 1 onwards, PassNo is record order relative to page only so it will always start
at 1 for each new page as Passno is a byte

*}



   {303} ((PassList:''; PassGrp:010; PassNo:048;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Access to Quotation Daybook';
                        PassPage:1;  PassLNo:303),

   {304}  (PassList:''; PassGrp:010; PassNo:049;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Access to History Daybook';
                        PassPage:1;  PassLNo:304),

   {342}  (PassList:''; PassGrp:010; PassNo:104;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Allow Authorise';
                        PassPage:1;  PassLNo:342),


   {305}  (PassList:''; PassGrp:020; PassNo:050;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Access to Quotation Daybook';
                        PassPage:1;  PassLNo:305),

   {306}  (PassList:''; PassGrp:020; PassNo:051;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Access to History Daybook';
                        PassPage:1;  PassLNo:306),

   {343}  (PassList:''; PassGrp:020; PassNo:105;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Allow Authorise';
                        PassPage:1;  PassLNo:343),

   {307}  (PassList:''; PassGrp:035; PassNo:052;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - Access to History Daybook';
                        PassPage:1;  PassLNo:307),

   {344}  (PassList:''; PassGrp:035; PassNo:106;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - Allow Authorise';
                        PassPage:1;  PassLNo:344),

   {308}  (PassList:''; PassGrp:036; PassNo:053;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Orders - Access to History Daybook';
                        PassPage:1;  PassLNo:308),

   {345}  (PassList:''; PassGrp:036; PassNo:107;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Orders - Allow Authorise';
                        PassPage:1;  PassLNo:345),

   {309}  (PassList:''; PassGrp:019; PassNo:054;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Allow Sale below Cost';
                        PassPage:1;  PassLNo:309),

   {310}  (PassList:''; PassGrp:019; PassNo:055;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Allow Discount to exceed Sale';
                        PassPage:1;  PassLNo:310),

   {311}  (PassList:''; PassGrp:035; PassNo:056;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - Allow Edit of Picking List options';
                        PassPage:1;  PassLNo:311),

   {338}  (PassList:''; PassGrp:032; PassNo:101;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Nominal Transfers - Access to History Daybook';
                        PassPage:1;  PassLNo:338),

   {205}  (PassList:''; PassGrp:081; PassNo:205;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Access to Job Menus';
                        PassPage:0;  PassLNo:205),

   {206}  (PassList:''; PassGrp:081; PassNo:206;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Access to Job Records';
                        PassPage:0;  PassLNo:206),

   {312}  (PassList:''; PassGrp:041; PassNo:061;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock Records - Allow Edit of Sales Prices';
                        PassPage:1;  PassLNo:312),

   {313}  (PassList:''; PassGrp:041; PassNo:063;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock Records - Allow Edit of Cost Price';
                        PassPage:1;  PassLNo:313),

   {314}  (PassList:''; PassGrp:041; PassNo:064;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock Ledger - Allow Copy/Reverse';
                        PassPage:1;  PassLNo:314),

   {315}  (PassList:''; PassGrp:041; PassNo:070;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock BOM - Allow Add of BOM Component';
                        PassPage:1;  PassLNo:315),

   {316}  (PassList:''; PassGrp:041; PassNo:071;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock BOM - Allow Edit of BOM Component';
                        PassPage:1;  PassLNo:316),

   {317}  (PassList:''; PassGrp:041; PassNo:072;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock BOM - Allow Delete of BOM Component';
                        PassPage:1;  PassLNo:317),

   {318}  (PassList:''; PassGrp:041; PassNo:073;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock BOM - Allow Insert of BOM Component';
                        PassPage:1;  PassLNo:318),



   {319}  (PassList:''; PassGrp:130; PassNo:080;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'eb Admin - Allow Access to Admin Module';
                        PassPage:1;  PassLNo:319),

   {320}  (PassList:''; PassGrp:131; PassNo:081;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'eb Admin - Allow Edit';
                        PassPage:1;  PassLNo:320),

   {321}  (PassList:''; PassGrp:131; PassNo:083;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'eb Admin - Allow Post';
                        PassPage:1;  PassLNo:321),

   {322}  (PassList:''; PassGrp:131; PassNo:084;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'eb Admin - Allow Delete';
                        PassPage:1;  PassLNo:322),

   {323}  (PassList:''; PassGrp:131; PassNo:085;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'eb Admin - Allow Hold';
                        PassPage:1;  PassLNo:323),

   {324}  (PassList:''; PassGrp:131; PassNo:086;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'eb Admin - View HTML';
                        PassPage:1;  PassLNo:324),

   {325}  (PassList:''; PassGrp:131; PassNo:087;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'eb Admin - View XML';
                        PassPage:1;  PassLNo:325),

   {326}  (PassList:''; PassGrp:132; PassNo:088;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'eb Admin - Allow Access to Import Logs';
                        PassPage:1;  PassLNo:326),

   {327}  (PassList:''; PassGrp:133; PassNo:089;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'eb Admin - Allow Access to Posting Logs';
                        PassPage:1;  PassLNo:327),

   {328}  (PassList:''; PassGrp:136; PassNo:090;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Trade Counter Admin - Allow Access to Admin Module';
                        PassPage:1;  PassLNo:328),

   {329}  (PassList:''; PassGrp:137; PassNo:091;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Trade Counter Admin - Allow Access to Set-Up';
                        PassPage:1;  PassLNo:329),

   {330}  (PassList:''; PassGrp:138; PassNo:092;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Trade Counter Admin - Allow Access to Reports';
                        PassPage:1;  PassLNo:330),

   {331}  (PassList:''; PassGrp:139; PassNo:093;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Trade Counter - Allow Access to Trade Counter';
                        PassPage:1;  PassLNo:331),

   {332}  (PassList:''; PassGrp:140; PassNo:094;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Trade Counter - Allow Write Off';
                        PassPage:1;  PassLNo:332),

   {333}  (PassList:''; PassGrp:140; PassNo:095;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Trade Counter - Allow Discount Override';
                        PassPage:1;  PassLNo:333),

   {334}  (PassList:''; PassGrp:140; PassNo:096;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Trade Counter - Allow Negative Entries';
                        PassPage:1;  PassLNo:334),

   {335}  (PassList:''; PassGrp:140; PassNo:097;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Trade Counter - Allow Refunds';
                        PassPage:1;  PassLNo:335),

   {336}  (PassList:''; PassGrp:140; PassNo:098;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Trade Counter - Allow Deposits';
                        PassPage:1;  PassLNo:336),

   {337}  (PassList:''; PassGrp:140; PassNo:099;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Trade Counter - Allow Find';
                        PassPage:1;  PassLNo:337),

   {339}  (PassList:''; PassGrp:140; PassNo:100;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Trade Counter - Allow Copy';
                        PassPage:1;  PassLNo:339),

   {340}  (PassList:''; PassGrp:140; PassNo:102;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Trade Counter - Allow Zero Price Override';
                        PassPage:1;  PassLNo:340),

   {341}  (PassList:''; PassGrp:140; PassNo:103;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Trade Counter - Allow Tax Code Override';
                        PassPage:1;  PassLNo:341),

   {346}  (PassList:''; PassGrp:035; PassNo:108;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - TeleSales Create Order';
                        PassPage:1;  PassLNo:346),

   {347}  (PassList:''; PassGrp:035; PassNo:109;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - TeleSales Create Invoice';
                        PassPage:1;  PassLNo:347),

   {348}  (PassList:''; PassGrp:035; PassNo:110;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - TeleSales Create Quotation';
                        PassPage:1;  PassLNo:348)




  );


  No2Del    =  3;

  SetDelPWord :  Array[1..No2Del] of  PassListType =


  {205}  ((PassList:''; PassGrp:080; PassNo:205;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Access to Job Menus';
                        PassPage:0;  PassLNo:205),

   {206}  (PassList:''; PassGrp:080; PassNo:206;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Access to Job Records';
                        PassPage:0;  PassLNo:206),

   {338}  (PassList:''; PassGrp:140; PassNo:100;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Job Costing - Access to Job Records';
                        PassPage:1;  PassLNo:338)

         );





  { Result

    -1 Routine failed to initilaise, prob caused by bad Btrieve installation or bad dir

     0 = Success

     1-255  Btrieve error in file PwrdF

  }


Function SetPWord_v432(Verbose  :  Boolean;
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
    For NextNo:=NoPWords1+1 to NoPwords+2 do
    With PassWord do
    Begin
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

Function NeedToRunv432(Var  ErrStr         :  String;
                       Var  TotalProgress  :  LongInt;
                            ForceRun       :  Boolean)  :  Boolean;

Var
  KeyF          :   Str255;
  NextNo        :   Integer;

Begin
  Result:=False;

  ErrStr:='Addition of v4.32 Passwords.';

  Open_System(PWrdF,PWrdF);

  try
    NextNo:=NoPWords+2;

    KeyF:='L'+#0+SetPadNo(Form_Int(SetPWord[NextNo].PassGrp,0),3)+SetPadNo(Form_Int(SetPWord[NextNo].PassLNo,0),3);

    Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,0,KeyF);

    Result:=(Status In [4]);

    If (ForceRun) then
      Result:=true;
      
    If (Result) then
      TotalProgress:=TotalProgress+(NoPWords+2-NoPWords1);
  finally


    Close_Files(True);

  end; {try..}


end;


end.
