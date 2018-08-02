program GenPWord;

Uses Crt,BtrvU2;


Const

{$I FilePath.Inc}


  NoBACSTot =  4;


type

  AnyStr    =  String[255];
  Str20     =  String[20];

  PTermAry  =  Array[1..5] of String[40];  { Stored Ary }
  Windx     =  Array[1..7] of Byte;
  Totals    =  Array[1..4] of Real;
  Date      =  String[6];
  TradeTermType = Array[1..2] of String[80];
  AddrTyp   =  Array[1..5] of String[30];

  BACSAnalType
            =  Array[0..NoBACSTot] of Double;

  CCDepType =  Array[False..True] of String[3];  {  CC/Dep Type }


    { ================ Password Control File ============= }

Const

  PWrdF     =     1;

  PwNofKeys =     2;

  PWK       =     0;
  HelpNdxK  =     1;

  PWNofSegs =     4;



Type
    { ================ Login Check Record ================ }


    PassEntryType = Record
               {002}  Login     :  String[12];   {  Login Name }
               {015}  Pword     :  String[9];    {  PassWord }
               {024}  Access    :  Array[0..255] of Byte;
                                                 {  Menu / User Access }
               {280}  LastPno   :  Byte;         {  Last Printer Used  }
                    end;



    { ================ Password Check List =============== }

    PassListType  = Record
              {002}   PassList  :  String[12];   { Group+No }
              {015}   PassGrp   :  Byte;         { Group - for ordering }
              {016}   PassNo    :  Byte;         { No Within Group }

              {017}   Spare1    :  Array[1..8] of
                                     Byte;
              {026}   PassDesc  :  String[80];   { Access Description }

              {106}   Spare2    :  Array[1..176] of
                                     Byte;
                    end;

    { ================ Help Record =============== }

    HelpType     =  Record
              {001}   Spare1    :  Byte;         { Ndx Ofset Marker }
              {002}   HelpNo    :  Longint;      { Help Lookup No. }
              {006}   HelpOrd   :  LongInt;      { Line No. Within Help }
              {010}   HelpStop  :  Char;         { End Key Marker to stop incomplete ndx being returned }

              {011}   Spare2    :  Array[1..3] of { If this changes change fullhelpKey! }
                                     Byte;

              {014}   Spare3    :  Array[1..10] of
                                     Byte;

              {025}   HelpMsg   :  String[255];

              {280}   Spare4    :  Byte;
                    end;


    { ================ Notes Record db List =============== }

    NotesType    =  Record
              {002}   NoteNo    :  String[12];   { Folio/CustCode + NType + LineNo}

              {015}   NoteDate  :  Date;

              {021}   Spare3    :  Array[1..3] of Byte;

              {025}   NoteAlarm :  Date;

              {031}   Spare4    :  Array[1..5] of Byte;

              {037}   NoteFolio :  String[10];

              {047}   NType     :  Char;

              {048}   Spare1    :  Array[1..2] of
                                     Byte;

              {050}   LineNo    :  LongInt;

              {055}   NoteLine  :  String[100]; { Note Line }

              {156}   NoteUser  :  String[10];  { Note owner }

              {166}   Spare2    :  Array[1..114] of Byte;
                    end;


    { ================ Matched payments Record db List =============== }

    MatchPayType =  Record
              {002}   DocCode   :  String[12];

              {014}   Spare1    :  Array[1..10] of
                                     Byte;

              {025}   PayRef    :  String[10];

              {035}   SettledVal:  Real;           {* Level 0 settled *}

              {041}   OwnCVal   :  Real;           {* Own currency settled *}

              {047}   MCurrency :  Byte;
              {048}   MatchType :  Char;           {* A for Accounting based, O for ,orders *}

              {049}   AltRef    :  String[10];     {* Alt YourRef *}

              {060}   Spare2    :  Array[1..221] of Byte;
                    end;



    { ================ Bill of Materials List =============== }

    BillMatType  =  Record
              {002}   StockLink :  String[12];

              {014}   Spare1    :  Array[1..10] of
                                     Byte;

              {025}   BillLink  :  String[10];

              {035}   QtyUsed   :  Real;           {* Batch Qty Used *}

              {041}   QtyCost   :  Real;           {* Unit Cost of Item *}

              {047}   QCurrency :  Byte;           {* Unit Cost Currency *}

              {049}   FullStkCode                  {* Actual Stock Code  *}
                                :  String[20];

              {069}   Spare2    :  Array[1..212] of Byte;
                    end;

    { ================ Bacs Ctrl Record =============== }

    BacsCType= Record
              {002}   TagCode   :  String[12];      {  '!'+RunNo }

              {014}   Spare1    :  Array[1..10] of Byte;

              {025}   Spare3K   :  String[10];      {  Spare K }

              {035}   TagRunNo  :  LongInt;         {  Tag Run Ctrl}

              {039}   PayType   :  Char;            {  Bacs/Cq Run}

              {040}   BankNom   :  LongInt;         {  Bank Nominal }

              {044}   PayCurr   :  Byte;            {  Pay In Currency }

              {045}   InvCurr   :  Byte;            {  Inv Currency }

              {046}   CQStart   :  LongInt;         {  CQ Number Start }

              {050}   AgeType   :  Byte;            {  Ageing Type  }

              {051}   AgeInt    :  Integer;         {  Ageing Interval }

              {053}   TagStatus :  Boolean;         {  Has Report been finished }

              {054}   TotalTag  :  BACSAnalType;    {  Total Tagged & OS }

              {095}   TagAsDate :  Date;            {  Tagged As At }

              {101}   TagCount  :  LongInt;         {  Total No. of Items in List }

              {106}   TagCCDep  :  CCDepType;       {  Default CC/DEP }

              {110}   {Dep Addr}

              {114}   TagRunDate:  Date;            {  Date of Payment }
              {120}   TagRunYr  :  Byte;            {  Year of Payment }
              {121}   TagRunPr  :  Byte;            {  Period of Payment }

              {122}   Spare2    :  Array[1..159] of Byte;


                   end;


    { ================ Export Last File =============== }

    ExportFileType =  Record

              {002}     ExportCode
                                  :  String[12];

              {014}     Spare1    :  Array[1..10] of
                                       Byte;

              {025}     SecondKey :  String[10];

              {035}     LastPath  :  String[80];     {* Last File Path Used *}

              {115}     Spare2    :  Array[1..166] of Byte;

                      end;



    { ================ Temp Stock Allocation File =============== }

    AllocFileType =  Record

              {002}     AllocCode
                                  :  String[12];

              {014}     Spare1    :  Array[1..10] of
                                       Byte;

              {025}     SecondKey :  String[10];

              {034}     AllocSF   :  Real;

              {040}     Spare2    :  Array[1..241] of Byte;

                      end;




    { ================ MultiCompany Control List =============== }

    MultiCompType = Record
               {002}  CompCode  :  String[12];   { }
               {015}  PWord     :  String[9];

               {025}  Company   :  String[30];   { Company Name }

               {056}  ExDir     :  String[80];   { Location of Ex Files including Drive }

               {136}  Spare1    :  Array[1..145] of
                                     Byte;

                    end;


    { ================ Cost Center Record =============== }

    CostCtrType= Record
              {002}   PCostC    :  String[12];      {  Cost Center Code }

              {014}   Spare1    :  Array[1..10] of Byte;

              {025}   CCDesc    :  String[30];      {  Cost Centre Description }

              {055}   CCTag     :  Boolean;         {  Tagged for Report }

              {056}   Spare2    :  Array[1..225] of Byte;


                    end;


    PassWordRec  =  Record
                      RecPfix   :  Char;         {  Record Prefix }
                      SubType   :  Char;         {  Subsplit Record Type }



                      Case Integer of
                        1  :  (PassEntryRec  :  PassEntryType);
                        2  :  (PassListRec   :  PassListType);
                        3  :  (HelpRec       :  HelpType);
                        4  :  (NotesRec      :  NotesType);
                        5  :  (MatchPayRec   :  MatchPayType);
                        6  :  (BillMatRec    :  BillMatType);
                        7  :  (BacsCRec      :  BacsCtype);
                        8  :  (ExportFileRec :  ExportFileType);
                        9  :  (AllocFileRec  :  AllocFileType);
                       10  :  (MultiCompRec  :  MultiCompType);
                       11  :  (CostCtrRec    :  CostCtrType);


                    end;


    PassWord_FileDef   =   Record
                             RecLen,
                             PageSize,
                             NumIndex  :  Integer;
                             NotUsed   :  LongInt;
                             Variable  :  Integer;
                             Reserved  :  array[1..4] of Char;
                             KeyBuff   :  array[1..PwNofSegs] of KeySpec;
                             AltColt   :  AltColtSeq;
                           end;








     { ================ Numerical Sequence Counts ================ }


Const
   PopGenW  :  Windx  =  (10,17,60,5,Red,White,1);

   NoPWords     =  409;

   {Last pword no is 348. Page 1 last pno is 170}

   SetPWord  :  Array[1..NoPWords] of PassListType =





 {01}  ((PassList:''; PassGrp:010; PassNo:01;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales - Access to Daybook'),
 {303}  (PassList:''; PassGrp:010; PassNo:048;  Spare1:(0,0,0,0,0,0,0,0);
                                                PassDesc:'Sales - Access to Quotation Daybook';
                      PassPage:1;  PassLNo:303),

 {304}  (PassList:''; PassGrp:010; PassNo:049;  Spare1:(0,0,0,0,0,0,0,0);
                                                PassDesc:'Sales - Access to History Daybook';
                      PassPage:1;  PassLNo:304),

 {342}  (PassList:''; PassGrp:010; PassNo:104;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Allow Authorise';
                        PassPage:1;  PassLNo:342),

 {02}   (PassList:''; PassGrp:012; PassNo:02;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales - Add a Transaction'),
 {03}   (PassList:''; PassGrp:013; PassNo:03;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales - Edit a Transaction'),
 {04}   (PassList:''; PassGrp:014; PassNo:04;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales - Print a Transaction'),
 {05 }  (PassList:''; PassGrp:015; PassNo:05;  Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Sales - Find a Transaction'),

 {06}   (PassList:''; PassGrp:016; PassNo:06;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales - Hold a Transaction'),
 {07}   (PassList:''; PassGrp:017; PassNo:07;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales - Convert Quotation to Invoice'),
 {08}   (PassList:''; PassGrp:018; PassNo:08;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales - Daybook Post'),
 {09}   (PassList:''; PassGrp:019; PassNo:09;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales - Remove Quotation'),
 {94}   (PassList:''; PassGrp:019; PassNo:94;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales - Automatic Daybook'),
{101}   (PassList:''; PassGrp:019; PassNo:101; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales - Copy/Reverse a Transaction'),
 {309}  (PassList:''; PassGrp:019; PassNo:054;  Spare1:(0,0,0,0,0,0,0,0);
                                                PassDesc:'Sales - Allow Sale below Cost';
                      PassPage:1;  PassLNo:309),

 {310}  (PassList:''; PassGrp:019; PassNo:055;  Spare1:(0,0,0,0,0,0,0,0);
                                                PassDesc:'Sales - Allow Discount to exceed Sale';
                      PassPage:1;  PassLNo:310),


 {10}   (PassList:''; PassGrp:020; PassNo:10;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase - Access to Daybook'),

 {305}  (PassList:''; PassGrp:020; PassNo:050;  Spare1:(0,0,0,0,0,0,0,0);
                                                PassDesc:'Purchase - Access to Quotation Daybook';
                      PassPage:1;  PassLNo:305),

 {306}  (PassList:''; PassGrp:020; PassNo:051;  Spare1:(0,0,0,0,0,0,0,0);
                                                PassDesc:'Purchase - Access to History Daybook';
                      PassPage:1;  PassLNo:306),


 {343}  (PassList:''; PassGrp:020; PassNo:105;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Allow Authorise';
                        PassPage:1;  PassLNo:343),

 {11}   (PassList:''; PassGrp:021; PassNo:11;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase - Add a Transaction'),
 {12}   (PassList:''; PassGrp:022; PassNo:12;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase - Edit a Transaction'),
 {13}   (PassList:''; PassGrp:023; PassNo:13;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase - Print a Transaction'),
 {14}   (PassList:''; PassGrp:024; PassNo:14;  Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Purchase - Find a Transaction'),

 {15}   (PassList:''; PassGrp:025; PassNo:15;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase - Hold a Transaction'),
 {16}   (PassList:''; PassGrp:026; PassNo:16;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase - Convert Quotation to Invoice'),
 {17}   (PassList:''; PassGrp:027; PassNo:17;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase - DayBook  Post'),
 {18}   (PassList:''; PassGrp:028; PassNo:18;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase - Remove Quotations'),
 {95}   (PassList:''; PassGrp:028; PassNo:95;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase - Automatic Daybook'),
{102}   (PassList:''; PassGrp:028; PassNo:102; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase - Copy/Reverse a Transaction'),

 {19}   (PassList:''; PassGrp:030; PassNo:19;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Nominal Ledger - Access to Nominal Menus'),
 {98}   (PassList:''; PassGrp:030; PassNo:98;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Nominal Ledger - Access to Cost Centres'),
 {99}   (PassList:''; PassGrp:030; PassNo:99;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Nominal Ledger - Access to Dept Codes'),
{106}   (PassList:''; PassGrp:030; PassNo:106; Spare1:(0,0,0,0,0,0,0,0);
                                                               PassDesc:'Nominal Ledger - Access to Reconciliation'),

 {20}   (PassList:''; PassGrp:031; PassNo:20;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Nominal Ledger - View Nominal Tree'),

 {21}   (PassList:''; PassGrp:031; PassNo:21;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Nominal Accounts - Add'),
 {22}   (PassList:''; PassGrp:031; PassNo:22;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Nominal Accounts - Edit'),
 {23}   (PassList:''; PassGrp:031; PassNo:23;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Nominal Accounts - Delete'),
 {24}   (PassList:''; PassGrp:032; PassNo:24;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Nominal Transfers - Access to Daybook'),
 {25}   (PassList:''; PassGrp:032; PassNo:25;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Nominal Transfers - Add a Transaction'),
 {26}   (PassList:''; PassGrp:032; PassNo:26;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Nominal Transfers - Edit a Transaction'),
 {27}   (PassList:''; PassGrp:032; PassNo:27;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Nominal Transfers - Suspend Posting'),
 {28}   (PassList:''; PassGrp:032; PassNo:28;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Nominal Transfers - Hold a Transaction'),
 {29}   (PassList:''; PassGrp:032; PassNo:29;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Nominal Transfers - DayBook Post'),
 {96}   (PassList:''; PassGrp:032; PassNo:96;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Nominal Transfers - Automatic Daybook'),
{103}   (PassList:''; PassGrp:032; PassNo:103; Spare1:(0,0,0,0,0,0,0,0);
                                                               PassDesc:'Nominal Transfers - Print a Transaction'),
{338}  (PassList:''; PassGrp:032; PassNo:101;  Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Nominal Transfers - Access to History Daybook';
                     PassPage:1;  PassLNo:338),

{196}   (PassList:''; PassGrp:031; PassNo:196;  Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Nominal Accounts - Reconcile Entries'),

{197}   (PassList:''; PassGrp:031; PassNo:197;  Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Nominal Accounts - Copy/Reverse a Transaction'),
{198}   (PassList:''; PassGrp:031; PassNo:198; Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Nominal Accounts - Move'),

{203}   (PassList:''; PassGrp:031; PassNo:203; Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Nominal Ledger - Edit CC/Dept'),


{140}   (PassList:''; PassGrp:032; PassNo:140; Spare1:(0,0,0,0,0,0,0,0);
                                                               PassDesc:'Nominal Transfers - Copy/Reverse a Transaction'),


{108}   (PassList:''; PassGrp:039; PassNo:108; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock - Access to Stock Menus'),
{109}   (PassList:''; PassGrp:039; PassNo:109; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock - Access to Stock Ledger'),
{110}   (PassList:''; PassGrp:039; PassNo:110; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock Records - Add'),
{111}   (PassList:''; PassGrp:039; PassNo:111; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock Records - Edit'),
{112}   (PassList:''; PassGrp:039; PassNo:112; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock Records - Delete'),
{113}   (PassList:''; PassGrp:039; PassNo:113; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock Records - Print'),
{114}   (PassList:''; PassGrp:039; PassNo:114; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock Records - Build'),
{146}   (PassList:''; PassGrp:039; PassNo:146; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock Records - Access to Qty Break'),

{147}   (PassList:''; PassGrp:039; PassNo:147; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock List - Access to Qty Break'),

{148}   (PassList:''; PassGrp:039; PassNo:148; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock List - Access to Age Screen'),

{149}   (PassList:''; PassGrp:039; PassNo:149; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock List - Access to Value Screen'),

{200}   (PassList:''; PassGrp:039; PassNo:200; Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Stock Records - Move'),

{115}   (PassList:''; PassGrp:040; PassNo:115; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock - Access to Stock List'),
{116}   (PassList:''; PassGrp:040; PassNo:116; Spare1:(0,0,0,0,0,0,0,0);
                                                               PassDesc:'Stock - Access to Stock Adjustment Daybook'),

{117}   (PassList:''; PassGrp:040; PassNo:117; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock Adjustment - Add'),
{118}   (PassList:''; PassGrp:040; PassNo:118; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock Adjustment - Edit'),
{119}   (PassList:''; PassGrp:040; PassNo:119; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock Adjustment - Print'),
{120}   (PassList:''; PassGrp:040; PassNo:120; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock Adjustment - Suspend'),
{121}   (PassList:''; PassGrp:040; PassNo:121; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock Adjustment - Hold'),
{122}   (PassList:''; PassGrp:040; PassNo:122; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock Adjustment - Daybook Post'),
{123}   (PassList:''; PassGrp:040; PassNo:123; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock Adjustment - Copy/Reverse'),
{174}   (PassList:''; PassGrp:040; PassNo:174; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock Re-Order Screen - Access to'),

{175}   (PassList:''; PassGrp:040; PassNo:175; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Stock Re-Order Screen - Process Orders'),


{176}   (PassList:''; PassGrp:040; PassNo:176; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock Take List - Access to'),

{177}   (PassList:''; PassGrp:040; PassNo:177; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock Take List - Freeze Stock'),

{178}   (PassList:''; PassGrp:040; PassNo:178; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock Take List - Process Stock Take'),



{124}   (PassList:''; PassGrp:041; PassNo:124; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock - Access to Stock Valuation'),
{125}   (PassList:''; PassGrp:041; PassNo:125; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Stock - Access to Price Adjustment'),

{312}   (PassList:''; PassGrp:041; PassNo:061; Spare1:(0,0,0,0,0,0,0,0);
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


 {30}   (PassList:''; PassGrp:042; PassNo:30;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Customer Details - Access to'),
 {31}   (PassList:''; PassGrp:042; PassNo:31;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Customer Details - Add'),
 {32}   (PassList:''; PassGrp:042; PassNo:32;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Customer Details - Edit'),
 {33}   (PassList:''; PassGrp:042; PassNo:33;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Customer Details - View Ledger'),
 {34}   (PassList:''; PassGrp:042; PassNo:34;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Customer Details - Find Records'),
 {35}   (PassList:''; PassGrp:042; PassNo:35;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Customer Details - Delete Records'),
 {36}   (PassList:''; PassGrp:042; PassNo:36;  Spare1:(0,0,0,0,0,0,0,0);
                                                               PassDesc:'Customer Details - Check/Re-Calc Allocations'),
 {37}   (PassList:''; PassGrp:042; PassNo:37;  Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Customer Details - View Order Ledger'),

 {38}   (PassList:''; PassGrp:042; PassNo:38;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Customer Details - View History'),
 {39}   (PassList:''; PassGrp:042; PassNo:39;  Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Customer Details - Print'),

{104}   (PassList:''; PassGrp:042; PassNo:104; Spare1:(0,0,0,0,0,0,0,0);
                                                               PassDesc:'Customer Details - Access to Notes'),
{142}  (PassList:''; PassGrp:042; PassNo:142;  Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Customer Details - Status'),

{202}   (PassList:''; PassGrp:042; PassNo:202; Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Customer Details - Unallocate Transactions'),

 {40}   (PassList:''; PassGrp:043; PassNo:40;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Supplier Details - Access to'),
 {41}   (PassList:''; PassGrp:043; PassNo:41;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Supplier Details - Add'),
 {42}   (PassList:''; PassGrp:043; PassNo:42;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Supplier Details - Edit'),
 {43}   (PassList:''; PassGrp:043; PassNo:43;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Supplier Details - View Ledger'),
 {44}   (PassList:''; PassGrp:043; PassNo:44;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Supplier Details - Find Records'),
 {45}   (PassList:''; PassGrp:043; PassNo:45;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Supplier Details - Delete Records'),
 {46}   (PassList:''; PassGrp:043; PassNo:46;  Spare1:(0,0,0,0,0,0,0,0);
                                                               PassDesc:'Supplier Details - Check/Re-Calc Allocations'),
 {48}   (PassList:''; PassGrp:043; PassNo:48;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Supplier Details - View History'),


 {204}  (PassList:''; PassGrp:043; PassNo:204; Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Supplier Details - Unallocate Transactions'),

 {47}   (PassList:''; PassGrp:042; PassNo:47;  Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Customer Details - Discounts'),

 {49}   (PassList:''; PassGrp:043; PassNo:49;  Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Supplier Details - Print'),

{105}   (PassList:''; PassGrp:043; PassNo:105; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Supplier Details - Access to Notes'),

{179}  (PassList:''; PassGrp:043; PassNo:179;  Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Supplier Details - View Order Ledger'),

{180}  (PassList:''; PassGrp:043; PassNo:180;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Details - Discounts'),

{181}  (PassList:''; PassGrp:043; PassNo:181;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Details - Status'),

 {50}   (PassList:''; PassGrp:044; PassNo:50;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Functions - Access to VAT Set-Up'),
 {51}   (PassList:''; PassGrp:045; PassNo:51;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Functions - Change Period'),
 {52}   (PassList:''; PassGrp:046; PassNo:52;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Functions - Access to Print Queue/ObjectPrint'),
 {53}   (PassList:''; PassGrp:047; PassNo:53;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Functions - Find a Document'),
{126}   (PassList:''; PassGrp:047; PassNo:126; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Functions - Access to Export Data Menu'),

{199}   (PassList:''; PassGrp:047; PassNo:199; Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Functions - Access to Currency Rates'),

{201}   (PassList:''; PassGrp:047; PassNo:201; Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Functions - Access to Diary'),

{107}   (PassList:''; PassGrp:048; PassNo:107; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Misc - Edit Transaction after Printing'),
{143}   (PassList:''; PassGrp:048; PassNo:143;  Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Misc - Show GP% on Screen'),

{182}   (PassList:''; PassGrp:048; PassNo:182;  Spare1:(0,0,0,0,0,0,0,0);
                                                                         PassDesc:'Misc - Allow Negative Stock Levels'),

{144}   (PassList:''; PassGrp:035; PassNo:144; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales Orders - Access to Daybook'),

{145}   (PassList:''; PassGrp:035; PassNo:145; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales Orders - Add a Transaction'),

{156}   (PassList:''; PassGrp:035; PassNo:156; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales Orders - Edit a Transaction'),

{157}   (PassList:''; PassGrp:035; PassNo:157; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales Orders - Print a Transaction'),

{158}   (PassList:''; PassGrp:035; PassNo:158; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales Orders - Find a Transaction'),

{159}   (PassList:''; PassGrp:035; PassNo:159; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales Orders - Hold a Transaction'),

{160}   (PassList:''; PassGrp:035; PassNo:160; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales Orders - Pick Orders'),

{161}   (PassList:''; PassGrp:035; PassNo:161; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales Orders - Process Orders'),

{162}   (PassList:''; PassGrp:035; PassNo:162; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales Orders - Tag Orders'),

{163}   (PassList:''; PassGrp:035; PassNo:163; Spare1:(0,0,0,0,0,0,0,0);
                                                PassDesc:'Sales Orders - Copy/Reverse Transaction'),

{344}  (PassList:''; PassGrp:035; PassNo:106;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - Allow Authorise';
                        PassPage:1;  PassLNo:344),

{164}   (PassList:''; PassGrp:036; PassNo:164; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase Orders - Access to Daybook'),

{165}   (PassList:''; PassGrp:036; PassNo:165; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase Orders - Add a Transaction'),

{166}   (PassList:''; PassGrp:036; PassNo:166; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase Orders - Edit a Transaction'),

{167}   (PassList:''; PassGrp:036; PassNo:167; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Purchase Orders - Print a Transaction'),

{168}   (PassList:''; PassGrp:036; PassNo:168; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase Orders - Find a Transaction'),

{169}   (PassList:''; PassGrp:036; PassNo:169; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase Orders - Hold a Transaction'),

{170}   (PassList:''; PassGrp:036; PassNo:170; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase Orders - Receive Orders'),

{171}   (PassList:''; PassGrp:036; PassNo:171; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase Orders - Process Orders'),

{172}   (PassList:''; PassGrp:036; PassNo:172; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase Orders - Tag Orders'),

{173}   (PassList:''; PassGrp:036; PassNo:173; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Purchase Orders - Copy/Reverse Transaction'),

{183}   (PassList:''; PassGrp:035; PassNo:183; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales Orders - Deliver Individual Order'),

{184}   (PassList:''; PassGrp:035; PassNo:184; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales Orders - Deliver Picked Orders'),

{185}   (PassList:''; PassGrp:035; PassNo:185; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales Orders - Invoice Single Delivery'),

{186}   (PassList:''; PassGrp:035; PassNo:186; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales Orders - Invoice All Deliveries'),

{187}   (PassList:''; PassGrp:035; PassNo:187; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Sales - Show Daybook Totals'),

{307}   (PassList:''; PassGrp:035; PassNo:052;  Spare1:(0,0,0,0,0,0,0,0);
                                                PassDesc:'Sales Orders - Access to History Daybook';
                      PassPage:1;  PassLNo:307),

{311}  (PassList:''; PassGrp:035; PassNo:056;  Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Sales Orders - Allow Edit of Picking List options';
                     PassPage:1;  PassLNo:311),

{346}  (PassList:''; PassGrp:035; PassNo:108;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - TeleSales Create Order';
                        PassPage:1;  PassLNo:346),

{347}  (PassList:''; PassGrp:035; PassNo:109;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - TeleSales Create Invoice';
                        PassPage:1;  PassLNo:347),

{348}  (PassList:''; PassGrp:035; PassNo:110;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - TeleSales Create Quotation';
                        PassPage:1;  PassLNo:348)


{188}   (PassList:''; PassGrp:036; PassNo:188; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Purchase Orders - Deliver Individual Order'),

{189}   (PassList:''; PassGrp:036; PassNo:189; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Purchase Orders - Deliver Received Orders'),

{190}   (PassList:''; PassGrp:036; PassNo:190; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Purchase Orders - Invoice Single Delivery'),

{191}   (PassList:''; PassGrp:036; PassNo:191; Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Purchase Orders - Invoice Tagged Deliveries'),

{192}   (PassList:''; PassGrp:036; PassNo:192; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Purchase - Show Daybook Totals'),

{308}  (PassList:''; PassGrp:036; PassNo:053;  Spare1:(0,0,0,0,0,0,0,0);
                                               PassDesc:'Purchase Orders - Access to History Daybook';
                     PassPage:1;  PassLNo:308),

{345}  (PassList:''; PassGrp:036; PassNo:107;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Orders - Allow Authorise';
                        PassPage:1;  PassLNo:345),

 {54}   (PassList:''; PassGrp:050; PassNo:54;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Access to Reports Menu'),
 {55}   (PassList:''; PassGrp:051; PassNo:55;  Spare1:(0,0,0,0,0,0,0,0);
                                                               PassDesc:'Reports - Access to Credit Control Reports'),
 {56}   (PassList:''; PassGrp:051; PassNo:56;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Payments due by Report'),
 {57}   (PassList:''; PassGrp:051; PassNo:57;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Receipts due by Report'),
 {58}   (PassList:''; PassGrp:051; PassNo:58;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Aged Debtors Report'),
 {59}   (PassList:''; PassGrp:051; PassNo:59;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Aged Creditors Report'),
 {60}   (PassList:''; PassGrp:051; PassNo:60;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Statements Run'),
 {61}   (PassList:''; PassGrp:051; PassNo:61;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Chase Letters Run'),
{150}   (PassList:''; PassGrp:051; PassNo:150; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Batch Payments - Access to'),

{151}   (PassList:''; PassGrp:051; PassNo:151; Spare1:(0,0,0,0,0,0,0,0);
                                                PassDesc:'Batch Payments - Access to Payments Screen'),

{152}   (PassList:''; PassGrp:051; PassNo:152; Spare1:(0,0,0,0,0,0,0,0);
                                                PassDesc:'Batch Payments - Access to Payments Report'),

{153}   (PassList:''; PassGrp:051; PassNo:153; Spare1:(0,0,0,0,0,0,0,0);
                                                PassDesc:'Batch Payments - Re-Print Payments Report'),

{154}   (PassList:''; PassGrp:051; PassNo:154; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Batch Payments - Send to BACS'),

{155}   (PassList:''; PassGrp:051; PassNo:155; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Batch Payments - Process Batch'),


 {62}   (PassList:''; PassGrp:052; PassNo:62;  Spare1:(0,0,0,0,0,0,0,0);
                                                               PassDesc:'Reports - Access to Nominal Based Reports'),
 {63}   (PassList:''; PassGrp:052; PassNo:63;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Trial Balance'),
 {64}   (PassList:''; PassGrp:052; PassNo:64;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Profit and Loss'),
 {65}   (PassList:''; PassGrp:052; PassNo:65;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Balance Sheet'),
 {66}   (PassList:''; PassGrp:052; PassNo:66;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Source and Application'),
 {67}   (PassList:''; PassGrp:052; PassNo:67;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Nominal History'),
 {68}   (PassList:''; PassGrp:052; PassNo:68;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Nominal Codes List'),
 {100}  (PassList:''; PassGrp:052; PassNo:100; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print CC/Dept Analysis'),
 {69}   (PassList:''; PassGrp:053; PassNo:69;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Access to General Reports'),
 {70}   (PassList:''; PassGrp:053; PassNo:70;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print DayBook Reports'),
 {71}   (PassList:''; PassGrp:053; PassNo:71;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Document Analysis Report'),
 {72}   (PassList:''; PassGrp:053; PassNo:72;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Bank Reconciliation'),
 {73}   (PassList:''; PassGrp:053; PassNo:73;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Customer List'),
 {74}   (PassList:''; PassGrp:053; PassNo:74;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Supplier List'),
 {75}   (PassList:''; PassGrp:053; PassNo:75;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print VAT Returns Report'),
 {76}   (PassList:''; PassGrp:053; PassNo:76;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Audit Trail'),
{131}   (PassList:''; PassGrp:053; PassNo:131; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Access to Stock Reports'),
{132}   (PassList:''; PassGrp:053; PassNo:132; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Sales Analysis'),
{133}   (PassList:''; PassGrp:053; PassNo:133; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Price List'),
{134}   (PassList:''; PassGrp:053; PassNo:134; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Stock List'),
{135}   (PassList:''; PassGrp:053; PassNo:135; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Re-Order List'),
{136}   (PassList:''; PassGrp:053; PassNo:136; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Stock Valuation'),
{137}   (PassList:''; PassGrp:053; PassNo:137; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Stock History'),
{138}   (PassList:''; PassGrp:053; PassNo:138; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Backlog Report'),
{139}   (PassList:''; PassGrp:053; PassNo:139; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Shortages Report'),
{140}   (PassList:''; PassGrp:053; PassNo:140; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print On Order Report'),
{141}   (PassList:''; PassGrp:053; PassNo:141; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Print Stock Take List'),
{193}   (PassList:''; PassGrp:054; PassNo:193; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Reports - Access to Report Writer'),
{194}   (PassList:''; PassGrp:054; PassNo:194; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Report Writer - Edit Report Layouts'),

{205}   (PassList:''; PassGrp:080; PassNo:205; Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Job Costing - Access to Job Menus')


 {77}   (PassList:''; PassGrp:060; PassNo:77;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Utilities - Access to Utilities Menu'),
 {78}   (PassList:''; PassGrp:061; PassNo:78;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Utilities - Access to Posting Menu'),
 {79}   (PassList:''; PassGrp:061; PassNo:79;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Utilities - Post All DayBooks'),
 {80}   (PassList:''; PassGrp:061; PassNo:80;  Spare1:(0,0,0,0,0,0,0,0);
                                                               PassDesc:'Utilities - Print a Previous Posting Report'),
 {97}   (PassList:''; PassGrp:061; PassNo:97;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Utilities - Post All Automatic Daybooks'),
 {81}   (PassList:''; PassGrp:062; PassNo:81;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Utilities - Re-Calc Status Flags'),
 {195}  (PassList:''; PassGrp:062; PassNo:195; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Utilities - Access Data Recovery'),

 {82}   (PassList:''; PassGrp:063; PassNo:82;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Utilities - Currency Re-Valuation'),
 {83}   (PassList:''; PassGrp:064; PassNo:83;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Utilities - Edit Form Definitions'),
 {84}   (PassList:''; PassGrp:065; PassNo:84;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Utilities - Access to Wordprocessor'),
 {85}   (PassList:''; PassGrp:066; PassNo:85;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Utilities - Access to SBS System'),
 {86}   (PassList:''; PassGrp:067; PassNo:86;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Utilities - Backup'),
 {87}   (PassList:''; PassGrp:068; PassNo:87;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Utilities - Delete Audited Data'),
 {88}   (PassList:''; PassGrp:069; PassNo:88;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Utilities - Access to System Set-Up'),
 {89}   (PassList:''; PassGrp:069; PassNo:89;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Utilities - Access to General Settings'),
 {90}   (PassList:''; PassGrp:069; PassNo:90;  Spare1:(0,0,0,0,0,0,0,0);
                                                               PassDesc:'Utilities - Access to Nominal Control Codes'),
 {91}   (PassList:''; PassGrp:069; PassNo:91;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Utilities - Access to Document Numbers'),
 {92}   (PassList:''; PassGrp:069; PassNo:92;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Utilities - Access to Passwords!'),
 {93}   (PassList:''; PassGrp:069; PassNo:93;  Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Utilities - Access to Printers Set-Up'),
{127}   (PassList:''; PassGrp:075; PassNo:127; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Export - Nominal Data'),
{128}   (PassList:''; PassGrp:075; PassNo:128; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Export - Daybook Data'),
{129}   (PassList:''; PassGrp:075; PassNo:129; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Export - Account Data'),
{130}   (PassList:''; PassGrp:075; PassNo:130; Spare1:(0,0,0,0,0,0,0,0); PassDesc:'Export - Stock Data')
{206}   (PassList:''; PassGrp:080; PassNo:206; Spare1:(0,0,0,0,0,0,0,0);
                                                      PassDesc:'Job Costing - Access to Job Records'),
{207}   (PassList:''; PassGrp:081; PassNo:207; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Job Records, Add'),
{208}   (PassList:''; PassGrp:081; PassNo:208; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Job Records, View Totals'),

{209}   (PassList:''; PassGrp:081; PassNo:209; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Job View, Edit'),

{210}   (PassList:''; PassGrp:081; PassNo:210; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Job View, Access Retentions'),

{211}   (PassList:''; PassGrp:081; PassNo:211; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Job View, Status'),
{212}   (PassList:''; PassGrp:081; PassNo:212; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Set Job Budget'),

{213}   (PassList:''; PassGrp:084; PassNo:213; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Access Transaction Menu'),

{214}   (PassList:''; PassGrp:087; PassNo:214; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Access Unposted Daybook'),

{215}   (PassList:''; PassGrp:089; PassNo:215; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Edit Job Actual'),

{216}   (PassList:''; PassGrp:089; PassNo:216; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Post Actuals Daybook'),

{217}   (PassList:''; PassGrp:091; PassNo:217; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Access Timesheet Daybook'),

{218}   (PassList:''; PassGrp:094; PassNo:218; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Post Timesheet Daybook'),

{219}   (PassList:''; PassGrp:096; PassNo:219; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Access Sales Retentions'),

{220}   (PassList:''; PassGrp:096; PassNo:220; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Access Purchase Retentions'),

{221}   (PassList:''; PassGrp:100; PassNo:221; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Access Employee Records'),

{222}   (PassList:''; PassGrp:104; PassNo:222; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Employee Records, Rates'),

{223}   (PassList:''; PassGrp:104; PassNo:223; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Employee Records, Ledger'),

{224}   (PassList:''; PassGrp:104; PassNo:224; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Employee Records, History'),

{225}   (PassList:''; PassGrp:106; PassNo:225; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Access Reports'),

{226}   (PassList:''; PassGrp:108; PassNo:226; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Reports, Print Backing Sheet'),

{227}   (PassList:''; PassGrp:108; PassNo:227; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Reports, Employee List'),

{228}   (PassList:''; PassGrp:108; PassNo:228; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Reports, Job History'),

{229}   (PassList:''; PassGrp:108; PassNo:229; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Reports, Customer Exposure'),

{230}   (PassList:''; PassGrp:108; PassNo:230; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Reports, Budget Analysis'),

{231}   (PassList:''; PassGrp:108; PassNo:231; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Reports, Actual Analysis'),

{232}   (PassList:''; PassGrp:108; PassNo:232; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Reports, Work in Progress'),

{233}   (PassList:''; PassGrp:108; PassNo:233; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Reports, Billing Report'),

{234}   (PassList:''; PassGrp:110; PassNo:234; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Access Utilities'),

{235}   (PassList:''; PassGrp:112; PassNo:235; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Access Time Rates'),

{236}   (PassList:''; PassGrp:112; PassNo:236; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Access Analysis Codes'),

{237}   (PassList:''; PassGrp:112; PassNo:237; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Access Job Types'),

{238}   (PassList:''; PassGrp:112; PassNo:238; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Generate Contract Budgets'),

{239}   (PassList:''; PassGrp:112; PassNo:239; Spare1:(0,0,0,0,0,0,0,0);
                                                 PassDesc:'Job Costing - Access System SetUp'),


   {240} ((PassList:''; PassGrp:042; PassNo:240;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Customer Details - Allow Bank Details Edit';
                        PassPage:0;  PassLNo:240),

   {241}  (PassList:''; PassGrp:042; PassNo:241;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Customer Details - Allow Credit Limit Edit';
                        PassPage:0;  PassLNo:241),

   {254}  (PassList:''; PassGrp:042; PassNo:254;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Customer Details - Allow Copy/Reverse';
                        PassPage:0;  PassLNo:254),

   {281}  (PassList:''; PassGrp:042; PassNo:26;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Customer Details- Allow Settle';
                        PassPage:1;  PassLNo:281),

   {285}  (PassList:''; PassGrp:042; PassNo:30;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Customer Details - Allow Allocate';
                        PassPage:1;  PassLNo:285),

   {287}  (PassList:''; PassGrp:042; PassNo:32;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Customer Discounts - Add';
                        PassPage:1;  PassLNo:287),

   {288}  (PassList:''; PassGrp:042; PassNo:33;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Customer Discounts - Edit';
                        PassPage:1;  PassLNo:288),

   {289}  (PassList:''; PassGrp:042; PassNo:34;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Customer Discounts - Delete';
                        PassPage:1;  PassLNo:289),

   {290}  (PassList:''; PassGrp:042; PassNo:35;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Customer Discounts - Copy';
                        PassPage:1;  PassLNo:290),

   {291}  (PassList:''; PassGrp:042; PassNo:36;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Customer Discounts - Check';
                        PassPage:1;  PassLNo:292),

   {242}  (PassList:''; PassGrp:043; PassNo:242;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Details - Allow Bank Details Edit';
                        PassPage:0;  PassLNo:242),

   {243}  (PassList:''; PassGrp:043; PassNo:243;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Details - Allow Credit Limit Edit';
                        PassPage:0;  PassLNo:243),

   {255}  (PassList:''; PassGrp:043; PassNo:255;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Details - Allow Copy/Reverse';
                        PassPage:0;  PassLNo:255),

   {282}  (PassList:''; PassGrp:043; PassNo:27;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Details - Allow Settle';
                        PassPage:1;  PassLNo:282),

   {286}  (PassList:''; PassGrp:043; PassNo:31;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Details - Allow Allocate';
                        PassPage:1;  PassLNo:286),

   {292}  (PassList:''; PassGrp:043; PassNo:37;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Discounts - Add';
                        PassPage:1;  PassLNo:292),

   {293}  (PassList:''; PassGrp:043; PassNo:38;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Discounts - Edit';
                        PassPage:1;  PassLNo:293),

   {294}  (PassList:''; PassGrp:043; PassNo:39;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Discounts - Delete';
                        PassPage:1;  PassLNo:294),

   {295}  (PassList:''; PassGrp:043; PassNo:40;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Discounts - Copy';
                        PassPage:1;  PassLNo:295),

   {296}  (PassList:''; PassGrp:043; PassNo:41;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Supplier Discounts - Check';
                        PassPage:1;  PassLNo:296),


   {244}  (PassList:''; PassGrp:039; PassNo:244;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock - Serial/Batch - Allow Incomplete Allocation';
                        PassPage:0;  PassLNo:244),

   {278}  (PassList:''; PassGrp:039; PassNo:023;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock - FIFO - Add Record ';
                        PassPage:1;  PassLNo:278),

   {279}  (PassList:''; PassGrp:039; PassNo:024;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock - FIFO - Edit Record ';
                        PassPage:1;  PassLNo:279),

   {280}  (PassList:''; PassGrp:039; PassNo:025;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock - FIFO - Delete Record ';
                        PassPage:1;  PassLNo:280),

   {275}  (PassList:''; PassGrp:039; PassNo:020;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock - Serial/Batch - Add Record ';
                        PassPage:1;  PassLNo:275),

   {276}  (PassList:''; PassGrp:039; PassNo:021;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock - Serial/Batch - Edit Record ';
                        PassPage:1;  PassLNo:276),

   {277}  (PassList:''; PassGrp:039; PassNo:022;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock - Serial/Batch - Delete Record ';
                        PassPage:1;  PassLNo:277),

   {297}  (PassList:''; PassGrp:039; PassNo:42;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock Discounts - Add';
                        PassPage:1;  PassLNo:297),

   {298}  (PassList:''; PassGrp:039; PassNo:43;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock Discounts - Edit';
                        PassPage:1;  PassLNo:298),

   {299}  (PassList:''; PassGrp:039; PassNo:44;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock Discounts - Delete';
                        PassPage:1;  PassLNo:299),

   {300}  (PassList:''; PassGrp:039; PassNo:45;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock Discounts - Copy';
                        PassPage:1;  PassLNo:300),

   {301}  (PassList:''; PassGrp:039; PassNo:46;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock Discounts - Check';
                        PassPage:1;  PassLNo:301),

   {302}  (PassList:''; PassGrp:040; PassNo:47;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Stock List - Access to History';
                        PassPage:1;  PassLNo:302),


   {245}  (PassList:''; PassGrp:035; PassNo:245;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - Access TeleSales';
                        PassPage:0;  PassLNo:245),

   {256}  (PassList:''; PassGrp:019; PassNo:001;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Allow Edit of Unit Price on Invoices';
                        PassPage:1;  PassLNo:256),

   {283}  (PassList:''; PassGrp:017; PassNo:028;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Convert Quotation to Order';
                        PassPage:1;  PassLNo:283),

   {257}  (PassList:''; PassGrp:028; PassNo:002;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Allow Edit of Unit Price on Invoices';
                        PassPage:1;  PassLNo:257),

   {284}  (PassList:''; PassGrp:026; PassNo:029;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Convert Quotation to Order';
                        PassPage:1;  PassLNo:284),


   {258}  (PassList:''; PassGrp:035; PassNo:003;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - Allow Edit of Unit Price';
                        PassPage:1;  PassLNo:258),

   {259}  (PassList:''; PassGrp:035; PassNo:004;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - Allow Edit of Nominal Code';
                        PassPage:1;  PassLNo:259),

   {268}  (PassList:''; PassGrp:035; PassNo:007;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - Allow Commitment to go over budget';
                        PassPage:1;  PassLNo:268),


   {270}  (PassList:''; PassGrp:035; PassNo:008;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - Allow Update of Sales Commitment';
                        PassPage:1;  PassLNo:270),

   {271}  (PassList:''; PassGrp:035; PassNo:013;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - Allow Generation of Sales Accrual';
                        PassPage:1;  PassLNo:271),

   {260}  (PassList:''; PassGrp:019; PassNo:005;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Allow Edit of Nominal Code on Invoices';
                        PassPage:1;  PassLNo:260),

   {261}  (PassList:''; PassGrp:028; PassNo:006;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Allow Edit of Nominal Code on Invoices';
                        PassPage:1;  PassLNo:261),



   {262}  (PassList:''; PassGrp:036; PassNo:014;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Orders - Allow Edit of Unit Price';
                        PassPage:1;  PassLNo:262),

   {263}  (PassList:''; PassGrp:036; PassNo:015;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Orders - Allow Edit of Nominal Code';
                        PassPage:1;  PassLNo:263),

   {269}  (PassList:''; PassGrp:036; PassNo:016;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Orders - Allow Commitment to go over budget';
                        PassPage:1;  PassLNo:269),

   {272}  (PassList:''; PassGrp:036; PassNo:017;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Orders - Allow Update of Purchase Commitment';
                        PassPage:1;  PassLNo:272),

   {273}  (PassList:''; PassGrp:036; PassNo:018;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Orders - Allow Generation of Purchase Accrual';
                        PassPage:1;  PassLNo:273),

   {264}  (PassList:''; PassGrp:051; PassNo:009;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Batch Payments - Allow Discount Override';
                        PassPage:1;  PassLNo:264),

   {265}  (PassList:''; PassGrp:051; PassNo:010;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Batch Receipts - Allow Discount Override';
                        PassPage:1;  PassLNo:265),

   {266}  (PassList:''; PassGrp:048; PassNo:011;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Misc - Allow Print to email';
                        PassPage:1;  PassLNo:266),

   {267}  (PassList:''; PassGrp:048; PassNo:012;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Misc - Allow Print to Fax';
                        PassPage:1;  PassLNo:267),

   {274}  (PassList:''; PassGrp:048; PassNo:019;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Misc - Allow Removal of Committed Balances';
                        PassPage:1;  PassLNo:274)



{319}   (PassList:''; PassGrp:130; PassNo:080;  Spare1:(0,0,0,0,0,0,0,0);
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
                      PassPage:1;  PassLNo:341)

 {342}  (PassList:''; PassGrp:010; PassNo:104;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales - Allow Authorise';
                        PassPage:1;  PassLNo:342),

 {343}  (PassList:''; PassGrp:020; PassNo:105;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase - Allow Authorise';
                        PassPage:1;  PassLNo:343),

 {344}  (PassList:''; PassGrp:035; PassNo:106;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - Allow Authorise';
                      PassPage:1;  PassLNo:344),

 {345}  (PassList:''; PassGrp:036; PassNo:107;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Purchase Orders - Allow Authorise';
                        PassPage:1;  PassLNo:345),

 {346}  (PassList:''; PassGrp:035; PassNo:108;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - TeleSales Create Order';
                        PassPage:1;  PassLNo:346),

 {347}  (PassList:''; PassGrp:035; PassNo:109;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - TeleSales Create Invoice';
                        PassPage:1;  PassLNo:347),

 {348}  (PassList:''; PassGrp:035; PassNo:110;  Spare1:(0,0,0,0,0,0,0,0);
                                                  PassDesc:'Sales Orders - TeleSales Create Quotation';
                        PassPage:1;  PassLNo:348)

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
                        PassPage:1;  PassLNo:409)




);





var
   Password      :   PasswordRec;
   PassFile      :   PassWord_FileDef;

   Ok      :   Boolean;
   Ch      :   Char;

   Choice,Status        :   Integer;
   Addch         :   Char;
   Elded         :   Boolean;
   n,m           :   Byte;


   KeyF          :   String;

   NextNo        :   LongInt;





procedure Beep;

Begin
write(chr(7));
end;






Procedure DefinePassWord;

Const
  Idx = PWrdF;

Begin
  With PassFile do
  Begin
    FileSpecLen[Idx]:=Sizeof(PassFile);                      { <<<<<<<<******** Change }
    Fillchar(PassFile,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(PassWord);                                  { <<<<<<<<******** Change }
    PageSize:=DefPageSize;
    NumIndex:=PwNofKeys;                                      { <<<<<<<<******** Change }
    Variable:=1;

    { 00 - (RecPfix+SubType) + Login  (PWK)  }                     { <<<<<<<<******** Change }

    KeyBuff[1].KeyPos:=1;
    KeyBuff[1].KeyLen:=2;
    KeyBuff[1].KeyFlags:=DupModSeg+AltColSeq;

    KeyBuff[2].KeyPos:=4;
    KeyBuff[2].KeyLen:=12;
    KeyBuff[2].KeyFlags:=DupMod+AltColSeq;


    { 01 - (RecPfix+SubType) + Access [1..11] (PWK)  }                     { <<<<<<<<******** Change }

    KeyBuff[3].KeyPos:=1;
    KeyBuff[3].KeyLen:=2;
    KeyBuff[3].KeyFlags:=DupModSeg+AltColSeq+Mank;

    KeyBuff[4].KeyPos:=27;
    KeyBuff[4].KeyLen:=11;
    KeyBuff[4].KeyFlags:=DupMod+AltColSeq+Mank;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}
  FileRecLen[Idx]:=Sizeof(PassWord);                             { <<<<<<<<******** Change }

  Fillchar(PassWord,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  RecPtr[Idx]:=Ptr(Seg(PassWord),Ofs(PassWord));                 { <<<<<<<<******** Change }

  FileSpecOfs[Idx]:=Ptr(Seg(PassFile),Ofs(PassFile));    { <<<<<<<<******** Change }


  FileNames[Idx]:=Path3+PassNam;                         { <<<<<<<<******** Change }


  Begin
    Writeln('PassWord: .. ',FileRecLen[Idx]:4);
    Writeln('FileDef.:',FileSpecLen[Idx]:4);
    Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
    Writeln;
  end;


end; {..}






Procedure Open_System;

Begin

  Choice:=1;

   { =========== Open Files ========== }
{$I-}
    If (Check4BtrvOK) then
    While (Choice<=TotFiles) and (Ch<>#27) do
    Begin
    Repeat
      Status:=Open_File(F[Choice],FileNames[Choice],0);
      If Status <>0 then
      Begin
        Status_Means(Status);
        Elded:=FALSE;
        Writeln('*** ERROR! *** File:'+FileNames[Choice]);
        Writeln('Press <Y> to Create a New File, <Esc> to Abort');
        Ch:=Upcase(ReadKey);
        If Ch='Y' then
        Begin
          Status:=Make_File(F[Choice],FileNames[Choice],FileSpecOfs[Choice]^,FileSpecLen[Choice]);

          Status_Means(Status);
        end
        else
        Addch:='A';
      end
      else
      Elded:=True;
    Until (Elded) or (Ch=#27);
    Choice:=Choice+1;
    end {while..}
    else
    Begin
      Writeln('*** ERROR! ***');
      Writeln('The System has been Started Incorrectly ...');
      WriteLn('Re-start using the Correct Procedure. (Check Manual)');
      Ch:=ReadKey;
      Addch:='A';
    end;
    Elded:=False;
end;

(*  ConstStr returns a string with N characters of value C *)

function ConstStr(C :  Char; N : Integer) : AnyStr;
var
  S : AnyStr;
begin
  if N < 0 then
    N := 0;
  S[0] := Chr(N);
  FillChar(S[1],N,C);
  ConstStr := S;
end;


{ ====== Function to Format an Integer No. & return in Str Format ===== }

Function Form_Int (Inum    :  LongInt;
                   Dig     :  Integer)  :  Str20;

Var
  TmpStr  :  Str20;

Begin
  TmpStr:='';
  Str(Inum:Dig,TmpStr);
  Form_Int:=TmpStr;
end;


{ ================== Pad Number with Digits*'0's =============== }

Function SetPadNo(Ino  :  Str20;
                  Digit:  Byte) :  String;

Begin
  SetPadNo:=(ConstStr('0',(Digit-Length(Ino)))+Ino);
end;


Begin

  ClrScr;

  DefinePassWord;

  Ch:=#0;

  TotFiles:=1;

  Open_System;

  Writeln;

  NextNo:=1;

  For NextNo:=1 to NoPwords do
  With PassWord do
  Begin

    KeyF:='L'+#0+SetPadNo(Form_Int(SetPWord[NextNo].PassGrp,0),3)+SetPadNo(Form_Int(SetPWord[NextNo].PassNo,0),3);


    Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,0,KeyF);

    If (Status=0) then
      Status:=Delete_Rec(F[PWrdF],PWrdF,0);

    FillChar(PassWord,Sizeof(PassWord),0);

    RecPfix:='L';

    PassListRec:=SetPWord[NextNo];

    FillChar(PassListRec.Spare2,Sizeof(PassListRec.Spare2),0);

    PassListRec.PassList:=SetPadNo(Form_Int(PassListRec.PassGrp,0),3)+SetPadNo(Form_Int(PassListRec.PassNo,0),3);

    Status:=Add_Rec(F[PWrdF],PWrdF,RecPtr[PWrdF]^,0);

    Writeln(PassListRec.PassDesc,' - Status: ',Status:5);
  end;


Choice:=1;


{$I-}
        Status:=Close_File(F[1]);
        Status_Means(Status);
{$I+}

end.
