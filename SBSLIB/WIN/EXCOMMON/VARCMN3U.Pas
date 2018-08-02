Const


 { ============= General Note Settings =========== }

  NoteTmpCode    =  #126; {* Tmp Note code for import. Allows delete to take place without deleting imported
                             notes. At the end of the import, the new notes are renumbered.*}
  NoteManualCode =  #2;   { Notes which have been added directly from the Workflow Diary form. }
  NoteTCode      =  'N';
  NoteCCode      =  'A';  {* Cust Note Types (1)*}
  NoteDCode      =  'D';  {* Doc NoteTypes   (1)*}
  NoteSCode      =  'S';  {* Stock NoteTypes (1)*}
  NoteRCode      =  'R';  {* Serial No. Notes *}
  NoteDP1Code    =  'P';
  NoteDP2Code    =  'T';
  NoteDpCode     :  Array[False..True] of Char =  (NoteDP1Code,NoteDP2Code);  {* Cc/Dep Notes *}
  NoteLCode      =  'L';  {* Location Code *}
  NotesdbCode    =  'B';  {* Supplier Alt Stk db*}
  NoteJCode      =  'J';  {* Job NoteTypes *}
  NoteECode      =  'E';  {* Employee NoteType *}
  NoteCDCode     =  '2';  {* Dated Notes Sub Code *}
  NoteCGCode     =  '1';  {* General Notes Sub Code *}

  {* (1) These codes used as part of initial search for diary,
         if they are ever expanded, adjust Check_Diary *}


  { =================================================== }

  {* Job Costing ==========================================  *}

  JobCodeLen     =  10;


  JobXRev        =  1;
  JobXMat        =  3;
  JobXOH         =  2;
  JobXLab        =  4;


  SysAnlsRcpt    =  07;
{$IFDEF ExWin}

  SysAnlsWIP     =  08;
{$ENDIF}
  SysAnlsPRet    =  10;
  SysAnlsSRet    =  09;


  JobClosed      =  5;
  JobCompl       =  4;

  CPChargeType   =  3;
  TMChargeType   =  1;

  EmpHistCode    =  '\';

  CommitHCode    =  '[';


  { === Job Analysis Record === }

  JARCode      =  'J';
  JATCode      =  'T';
  JAACode      =  'A';
  JAECode      =  'E';

  JASubAry     :  Array[1..3] of Char = (JATCode,JAACode,JAECode);

  { === Job Budget Record === }

  JBRCode      =  'J';
  JBBCode      =  'B';
  JBSCode      =  'S';
  JBECode      =  'E';
  JBPCode      =  'R';
  JBMCode      =  'M';

  JBSubAry     :  Array[1..7] of Char = (JBBCode,JBSCode,JBECode,JBPCode,JBMCode,JBBCode,JBSCode);




  { ========================================================== }

  {* Country specific codes *}

  // MH 21/11/2014 Order Payments Credit Card ABSEXCH-15836: Moved to standalone include file for portability
  {$I ExchequerCountryCodes.inc}


  { ======= Holding / Reconcilliation Statuses ======== }


  HoldQ          =  1;   {* Hold Query *}
  HoldA          =  2;   {* Hold Until Allocated *}
  HoldSA         =  202; {* Set    "       "     *}
  HoldP          =  3;   {* Authorise Payment *}
  HoldSP         =  203; {* Set    "       "     *}
  HoldS          =  4;   {* Hold Any Order lines unless stock is available for thr entire line *}
  HoldSS         =  204; {* Set    "       "     *}
  HoldO          =  5;   {* Hold until entire order is complete *}
  HoldSO         =  205; {* Set    "       "     *}
  HoldC          =  6;   {* Hold until credit cleared *}
  HoldSC         =  206; {* Set    "       "     *}

  HoldSuspend    =  128; {* Suspend Posting Here *}

  HoldDel	 =  208; {* Remove HoldStatus *}

  HoldNotes      =  32;  {* Doc Has Notes        *}

  HoldNDel       =  209;

  HoldStatus     :  Array[0..HoldC] of String[10]     =  (' ','Query','UntilAlloc','Authorise','Wait Stk','WaitAllStk',
                                                          'Credit Hld');

  SuspendStatus  =                                       'Suspend';

  NoteStatus     =                                       'Notes';

  DiscStatus     :  Array[0..2] of Char               =  (#32,'A','Y');  {* N=Non Avail,A=Avail - Not taken,Y=Avail & Taken *}

  ReconC         =  1; { Item Cleared }
  ReconA         =  2; { Item cAncelled }
  ReconR         =  3; { Item Returned }
  ReconN         =  201; { Menu Weighted Item }

  ReconStatus    :  Array[0..ReconR] of String[6]    =  (' ','Cleard','Cancld','Rturnd');

  NotClearedSet  =  [0,ReconA,ReconR]; { Definition of not cleared }

  PayInRStatus   :  Array[0..ReconA] of String[6]    =  (' ','P/Clrd','Cleard');

  VODelChar      =  'D';       { View Delivery Address on View Only Invoice.. }

  { ============= Lock Move routines Settings =========== }

  PostMCode      =  'M';

  CuStkHistCode  =  'E';

  { =================================================== }

  IOVATCh        :  Array[False..True] of Char =  ('I','O');   {* VAT Input/Output Flg *}

  RevaluedCode   =  'R';  {* Flag to indicate an invoice has been revalued *}

  VATSchC        =  'C';

  VATCRDTTyp     =  16; {* Intra Stat defaults  - Credit note *}

  VATINVTTyp     =  10; {*         "      "       Invoices    *}
  VATIEINVTTyp   =  1; {*         "      "       Invoices    *}

  // CJS 2014-09-08 - ABSEXCH-15576 - default NoTC value
  VATIECrdTTyp   =  2;  {*        "      "      - Irish Credit notes *}


  CustHistCde    =  'U';   {* Constant Code for Customer Histories System switch dependant *}
  CustHistPCde   =  'V';   {*     "      "   "     "         "     Updated by posting only *}
                           {* This ensures that we are able to check the aged debtors by the
                              posted balance *}
  CustHistGPCde  =  'W';   {* Constant Code of Customer GP History *}

  CustHistPOCde  =  '?';   {* Constant code used to hide automaticly generated docs during SPOP run, and
                              as a means of checking for a constant present *}

  CustHistJPCde  =  '}';   {* Constant code used to hide automaticly generated docs during application posting, and
                              as a means of checking for a constant present *}

  {* Please note 'D' & 'T' are used within CustSupp to differentiate between order items, and
     strictly accounting items for seperation on the ledger, these equate to Succ(Equiv TradeCode) *}

  CustHistAry    :  Array[1..3] of Char = (CustHistCde,CustHistPCde,CustHistGpCde);   {* Convineient Access method *}


  CCWLen         =  12;      {* Length of CCDep Hidden Field *}
  NomWLen        =  30;      {* Length of Nom Hidden Field *}
  FNWLen         =  80;      {* Length of hidden path *}

                                                               

  NomHedCode                     =  'H';
  YTD                            =  255;    { YTD Weighting for history }
  YTDNCF                         =  254;    { YTD Weighting for History, but not carry forward bal type }

  YTDStr                         =  'YTD';  { YTD Str equivalent }
  CarryFlg                       =  'F';
  CarryMsg                       =  ' C/Fwrd to';
  CtrlNHCode			 =  'C';
  BankNHCode			 =  'B';
  PLNHCode		         =  'A';

  NVRCode                        =  'N';
  NVVSCode                       =  'V';
  NVCSCode                       =  'C';
  ViewHedCode                    =  '9';
  ViewBalCode                    =  '8';

  StkGrpCode                     =  'G';    { Stock Header Line }
  StkStkCode                     =  'P';    { Stock Item Code }
  StkDescCode                    =  'D';    { Descriptive Look-up Line }
  StkDListCode                   =  'X';    { Stock Item De-Listed }
  StkBillCode                    =  'M';
  StkStkQCode                    =  #239;   { Qty only History Code }
  StkDLQCode                     =  #247;   { Qty only History Code }
  StkBillQCode                   =  #236;   {  "    "     "      "  }

  StkLCCode                      =  'C';    { Default Last Cost Code }



  { ====== M Loc Stk ====== }

  {* Job Costing ==========================================  *}

  JobGrpCode     =  'K';
  JobJobCode     =  'J';
  JobPhzCode     =  'Z';


  LocKeyLen    =   3;


  { ======================= }


  NHCodeLen                      =  20;     { Nominal History Code Length }


  StkLineNo                      =  -1;     { Hidden Stock deduct line nos }

  StkHTypWeight                  =  159;    { Ascii weigting to arrive at Qty only History Code }

  StkProdSet                     =  [StkStkCode,StkBillCode,StkDListCode];  {* Records classified as full stock records *}

  StkBandSet                     =  ['A'..'H']; {* Price Band ranges *}

  StkAdjNomMode                  =  2;    {* Renconcilliation Separator *}
  TSTNomMode                     =  3;


  MaxNCode                       =  999999;      { Largest Nominal Code Possible }

  MaxLineValue   :  Real         =  9999999999.99;  { Largest Displayable Value }
  MaxLineValue32 :  Real         =999999999999.99;   { Largest Displayable value Ent }

  MaxStkPBands   :  Byte         =  8; {* Max No. of Selling Price Bands *}
  MaxStkDescs    :  Byte         =  6; {* Max No. of Stock Description Lines*}



  NRanges        :  Byte         =  2; {No of Period Inputs}

                                                                                    { Types with YTD History }

  YTDSet         :  CharSet      =  [BankNHCode,CtrlNHCode,StkStkQCode,StkBillQCode,StkDLQCode,
                                     JobGrpCode,JobPhzCode,JobJobCode,ViewHedCode,ViewBalCode];

                                    { Types with Non C/F YTD History }

  YTDNCFSet      :  CharSet      =  [CustHistGPCde,StkGrpCode,StkStkCode,StkDescCode,StkBillCode,StkDListCode,PLNHCode];

  ProfitBFSet    :  CharSet      =  [PLNHCode];               { Nom Types affecting Profit b/f }

  BankSet        :  CharSet      =  [BankNHCode];             { Nom Types with Cleared Balance }



  { ============= General Pay-in Mode Control Settings =========== }


    PayInCode      =  #1;
    PayOutCode     =  #2;

    PayInRunNo     =  -5;   {* Negative Run No *}

    PayInNomMode   =  1;    {* Renconcilliation Separator *}


      { ============= Match Document Settings =========== }


    MatchTCode     =  'T';
    MatchSCode     =  'P'; {* Also used for revaluation temp posting to MCr Acc *}

    //PR: 07/08/2014 v7 Order Payments T038 Order Payment sub-type
    MatchOrderPaymentCode
                   =  'R';

    {$IFDEF ExWin}
      MatchCCode     =  'C'; {* Also used for revaluation temp posting to MCr Acc *}

      RetRLCode   =   'R';
      RetPFCode   =   '1';

      LteBankRCode  =  'K';
      {LteBankSType  =  '1'    {For Bank rec header
                        '2'    { "    "   "  Details
                        '3'    {For eBank "  Table
                        '4'    { "    "      Header
                        '5'    {For   "      Details}
    {$ENDIF}

    { NOTE: SubTypes of 0-4 are used for Custom Matching in Enterprise }


    { =================================================== }

    {* Change on report gen *}
    { ============= General FIFO Settings ============= }

    MFIFOCode       =  'F'; {* Also used for revaluation temp posting to MCr Acc *}
    MFIFOSub        =  'S';
    MSERNSub        =  'R';


    {$IFDEF ExWin}
        BRRecCode  =  'I'; {* Multi bin sub record *}
    {$ENDIF}

    { =================================================== }
    { ============= General Password Settings =========== }


    PassUCode      =  'P';
    PassLCode      =  'L';


    { ============= Lock post routines Settings =========== }


    PostUCode      =  'L';
    PostLCode      =  'K';


    { =================================================== }

    { =================================================== }



    { =================================================== }


    { ============= General Help Settings =========== }


    HelpTCode      =  'H';
    HelpICode      =  'I';
    HelpKStop      =  '!';



    { =================================================== }


    { ============= General Cost Centre Settings =========== }


     CostCCode      =  'C';
     CSubCode       :  Array[False..True] of Char = ('D','C');
                                                  {   ^   ^------- [C][C] = Cost center line }
                                                  {   |------------[C][D] = Dept Line }

     CostCtrTitle   :  Array[False..True] of String[16] = ('Department Codes','Cost Centres');

     CostCtrRTitle  :  Array[False..True] of String[12] = ('Department:','Cost Centre:');

   { =================================================== }


    { =================================================== }

