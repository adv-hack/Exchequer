UNIT USEDLLU;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }



{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 21/07/93                      }
{                                                              }
{                     Internal Export MODEule                  }
{                                                              }
{               Copyright (C) 1993 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}





INTERFACE

  PROCEDURE EX_TESTMODE (MODE : WORDBOOL); {$IFDEF WIN32} STDCALL; {$ENDIF}
  FUNCTION EX_GETACCOUNT(P            :  POINTER;
                         PSIZE        :  LONGINT;
                         SEARCHKEY    :  PCHAR;
                         SEARCHPATH   :  SMALLINT;
                         SEARCHMODE   :  SMALLINT;
                         ACCTYPE      :  SMALLINT;
                         LOCK         :  WORDBOOL) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_STOREACCOUNT(P            :  POINTER;
                           PSIZE        :  LONGINT;
                           SEARCHPATH   :  SMALLINT;
                           SEARCHMODE   :  SMALLINT) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

{$IFDEF WIN32}

  FUNCTION EX_STOREDISCMATRIX(P            :  POINTER;
                              PSIZE        :  LONGINT;
                              SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                              {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_GETDISCMATRIX(P            :  POINTER;
                            PSIZE        :  LONGINT;
                            SEARCHPATH   :  SMALLINT;
                            SEARCHMODE   :  SMALLINT;
                            LOCK         :  WORDBOOL)  :  SMALLINT;
                            {$IFDEF WIN32} STDCALL; {$ENDIF}
{$ENDIF}


  FUNCTION EX_UNLOCKACCOUNT : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_GETACCOUNTBALANCE(P          :  POINTER;
                                PSIZE      :  LONGINT;
                                ACCODE     :  PCHAR;
                                SEARCHMODE :  SMALLINT) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_GETTRANS(P,
                       PLINES         :  POINTER;
                       PSIZE          :  LONGINT;
                       PLSIZE         :  LONGINT;
                       SEARCHKEY      :  PCHAR;
                       SEARCHPATH     :  SMALLINT;
                       SEARCHMODE     :  SMALLINT;
                       LOCK           :  WORDBOOL) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}


  FUNCTION EX_STORETRANS( P,
                          PL         :  POINTER;
                          PSIZE      :  LONGINT;
                          PLSIZE     :  LONGINT;
                          SEARCHPATH :  SMALLINT;
                          SEARCHMODE :  SMALLINT) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_GETNEXTTRANSNO(DOCSTR   :  PCHAR;
                             NEXTNO   :  PCHAR;
                             UPDATE   :  WORDBOOL) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_GETTOTALTRANSLINES(DOCREF : PCHAR) : LONGINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_GETTRANSHED(P              :  POINTER;
                          PSIZE          :  LONGINT;
                          SEARCHKEY      :  PCHAR;
                          SEARCHPATH     :  SMALLINT;
                          SEARCHMODE     :  SMALLINT;
                          LOCK           :  WORDBOOL) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}


  FUNCTION EX_GETTRANSLINE(PLINE          :  POINTER;
                           PLSIZE         :  LONGINT;
                           SEARCHKEY      :  PCHAR;
                           SEARCHPATH     :  SMALLINT;
                           SEARCHMODE     :  SMALLINT;
                           LOCK           :  WORDBOOL) : SMALLINT;
                           {$IFDEF WIN32} STDCALL {$ENDIF}


  FUNCTION EX_GETSTOCK(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHKEY    :  PCHAR;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT;
                       LOCK         :  WORDBOOL) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_STORESTOCK(P            :  POINTER;
                         PSIZE        :  LONGINT;
                         SEARCHPATH   :  SMALLINT;
                         SEARCHMODE   :  SMALLINT) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_UNLOCKSTOCK : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_INITDLL : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_CLOSEDLL : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_CLOSEDATA : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_GETGLACCOUNT(P            :  POINTER;
                           PSIZE        :  LONGINT;
                           SEARCHKEY    :  PCHAR;
                           SEARCHPATH   :  SMALLINT;
                           SEARCHMODE   :  SMALLINT;
                           LOCK         :  WORDBOOL) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_STOREGLACCOUNT(P            :  POINTER;
                             PSIZE        :  LONGINT;
                             SEARCHPATH   :  SMALLINT;
                             SEARCHMODE   :  SMALLINT) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}


  FUNCTION EX_GETSTOCKBOM(P               :  POINTER;
                          PSIZE           :  LONGINT;
                          SEARCHKEY       :  PCHAR;
                          SEARCHMODE      :  SMALLINT) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_STORESTOCKBOM(P               :  POINTER;
                            PSIZE           :  LONGINT;
                            SEARCHKEY       :  PCHAR) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_GETSTKALT(P           :  POINTER;
                        PSIZE       :  LONGINT;
                        SEARCHKEY   :  PCHAR;
                        SEARCHPATH  :  SMALLINT;
                        SEARCHMODE  :  SMALLINT;
                        LOCK        :  WORDBOOL)  :  SMALLINT;   {$IFDEF WIN32} STDCALL {$ENDIF}


  FUNCTION EX_STORESTKALT(P          :  POINTER;
                          PSIZE      :  LONGINT;
                          SEARCHPATH :  SMALLINT;
                          SEARCHMODE :  SMALLINT)  :  SMALLINT;  {$IFDEF WIN32} STDCALL {$ENDIF}


  FUNCTION EX_GETLINESERIALNOS(P               :  POINTER;
                               PSIZE           :  LONGINT;
                               SEARCHKEY       :  PCHAR;
                               SEARCHLINENO    :  LONGINT;
                               SEARCHMODE      :  SMALLINT) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_ACCOUNTFILESIZE  :  LONGINT;  {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_HASOUTSTANDING(CUSTCODE  :  PCHAR) : WORDBOOL;  {$IFDEF WIN32} STDCALL; {$ENDIF}


  FUNCTION EX_GETJOB(P            :  POINTER;
                     PSIZE        :  LONGINT;
                     SEARCHKEY    :  PCHAR;
                     SEARCHPATH   :  SMALLINT;
                     SEARCHMODE   :  SMALLINT;
                     LOCK         :  WORDBOOL) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_STOREJOB(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT) : SMALLINT;  {$IFDEF WIN32} STDCALL; {$ENDIF}


FUNCTION EX_GETJOBANALYSIS(P          :  POINTER;
                           PSIZE      :  LONGINT;
                           SEARCHKEY  :  PCHAR;
                           SEARCHPATH :  SMALLINT;
                           SEARCHMODE :  SMALLINT;
                           LOCK       :  WORDBOOL)  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}


FUNCTION EX_GETJOBEMPLOYEE(P          :  POINTER;
                           PSIZE      :  LONGINT;
                           SEARCHKEY  :  PCHAR;
                           SEARCHPATH :  SMALLINT;
                           SEARCHMODE :  SMALLINT;
                           LOCK       :  WORDBOOL)  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}


FUNCTION EX_GETJOBTIMERATE(P          :  POINTER;
                           PSIZE      :  LONGINT;
                           SEARCHPATH :  SMALLINT;
                           SEARCHMODE :  SMALLINT;
                           LOCK       :  WORDBOOL)  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}

FUNCTION EX_GETJOBTYPE(P          :  POINTER;
                       PSIZE      :  LONGINT;
                       SEARCHKEY  :  PCHAR;
                       SEARCHMODE :  SMALLINT;
                       LOCK       :  WORDBOOL)  :  SMALLINT;
                       {$IFDEF WIN32} STDCALL; {$ENDIF}


  FUNCTION EX_GETSTOCKLOC(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHKEY    :  PCHAR;
                          SEARCHLOC    :  PCHAR;
                          LOCK         :  WORDBOOL )  :  SMALLINT;  {$IFDEF WIN32} STDCALL; {$ENDIF}


  FUNCTION EX_STORESTOCKLOC(P            :  POINTER;
                            PSIZE        :  LONGINT;
                            SEARCHMODE   :  SMALLINT)  :  SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_GETLOCATION(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHKEY    :  PCHAR;
                          SEARCHPATH   :  SMALLINT;
                          SEARCHMODE   :  SMALLINT;
                          LOCK         :  WORDBOOL)  :  SMALLINT;   {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_STORELOCATION(P            :  POINTER;
                            PSIZE        :  LONGINT;
                            SEARCHPATH   :  SMALLINT;
                            SEARCHMODE   :  SMALLINT)  :  SMALLINT;   {$IFDEF WIN32} STDCALL; {$ENDIF}


  FUNCTION EX_ROUNDUP(INPUTVALUE     :  DOUBLE;
                      DECIMALPLACES  :  SMALLINT)  :  DOUBLE;  {$IFDEF WIN32} STDCALL; {$ENDIF}


   TYPE
    {$IFNDEF WIN32}
       SHORTSTRING = STRING;
    {$ENDIF}
    STR4    =  STRING[4];

   FUNCTION EX_VERSION : SHORTSTRING; {$IFDEF WIN32} STDCALL; {$ENDIF}

   FUNCTION EX_CONVERTFOLIO(FOLIONUMBER  :  LONGINT)  :  SHORTSTRING; {$IFDEF WIN32} STDCALL; {$ENDIF}


  FUNCTION EX_GETMATCH(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHKEY    :  PCHAR;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT;
                       LOCK         :  WORDBOOL)  :  SMALLINT;   {$IFDEF WIN32} STDCALL; {$ENDIF}


  FUNCTION EX_STOREMATCH(P            :  POINTER;
                         PSIZE        :  LONGINT;
                         SEARCHPATH   :  SMALLINT;
                         SEARCHMODE   :  SMALLINT)  :  SMALLINT;   {$IFDEF WIN32} STDCALL; {$ENDIF}


  FUNCTION EX_GETNOTES(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHKEY    :  PCHAR;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT;
                       LOCK         :  WORDBOOL)  :  SMALLINT;   {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_STORENOTES(P            :  POINTER;
                         PSIZE        :  LONGINT;
                         SEARCHPATH   :  SMALLINT;
                         SEARCHMODE   :  SMALLINT)  :  SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION EX_GETCCDEP(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHKEY    :  PCHAR;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT;
                       CCDEPTYPE    :  SMALLINT;
                       LOCK         :  WORDBOOL) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION  EX_CALCSTOCKPRICE(P      :  POINTER;
                              PSIZE  :  LONGINT)   :  SMALLINT;  {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION  EX_GETVATRATE(P      :  POINTER;
                          PSIZE  :  LONGINT)   :  SMALLINT;  {$IFDEF WIN32} STDCALL; {$ENDIF}

  PROCEDURE EX_SILENTLOCK(SILENT  :  WORDBOOL);  {$IFDEF WIN32} STDCALL; {$ENDIF}

  PROCEDURE EX_SETRELEASECODE(RELCODE : PCHAR);  {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION  EX_INITDLLPATH(EXPATH    :  PCHAR;
                           MCSYSTEM  :  WORDBOOL) :  SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}

  FUNCTION  EX_GETTLLINE(FOLIONUMBER,
                         LINENUMBER  :  LONGINT;
                         PLINE       :  POINTER;
                         PLSIZE      :  LONGINT)  :  SMALLINT;
                         {$IFDEF WIN32} STDCALL {$ENDIF}

  FUNCTION  EX_GETTHBYFOLIO(FOLIONUMBER :  LONGINT;
                            P           :  POINTER;
                            PSIZE       :  LONGINT)  :  SMALLINT;
                            {$IFDEF WIN32} STDCALL {$ENDIF}


  FUNCTION  EX_GETDATAPATH(VAR EXDATAPATH  :  PCHAR)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL {$ENDIF}


{$IFDEF WIN32}

  FUNCTION EX_INITPRINTFORM(DATAPATH :  PCHAR)  :  SMALLINT;  STDCALL;

  FUNCTION EX_ADDTRANSFORM(REFNO     :  PCHAR;
                           FORMNAME  :  PCHAR)  :  SMALLINT;  STDCALL;

  FUNCTION EX_PRINTFORM(PREVIEWSTAT :  WORDBOOL;
                        NOOFCOPIES  :  SMALLINT )  :  SMALLINT;  STDCALL;

  PROCEDURE EX_ENDPRINTFORM;  STDCALL;

{$ENDIF}

FUNCTION EX_ERRORDESCRIPTION(INDEXNO   :  SMALLINT;
                             ERRORCODE :  SMALLINT) : SHORTSTRING;
                             {$IFDEF WIN32} STDCALL {$ENDIF}

FUNCTION EX_GETTHBYRUNNO(P          :  POINTER;
                         PSIZE      :  LONGINT;
                         RUNNO      :  LONGINT;
                         SEARCHMODE :  SMALLINT;
                         LOCK       :  WORDBOOL) : SMALLINT;
                         {$IFDEF WIN32} STDCALL {$ENDIF}

FUNCTION EX_STORETH(P          :  POINTER;
                    PSIZE      :  SMALLINT;             {* Size of TH *}
                    SEARCHPATH :  SMALLINT;
                    UPDATEMODE :  SMALLINT;
                    AUTHCODE   :  LONGINT)  :  SMALLINT;
                    {$IFDEF WIN32} STDCALL {$ENDIF}

FUNCTION EX_GETCURRENCY(P     : POINTER;
                        PSIZE : LONGINT;
                        CURR  : SMALLINT) : SMALLINT;
                        {$IFDEF WIN32} STDCALL; {$ENDIF}

FUNCTION EX_GETSYSDATA(P            :  POINTER;
                       PSIZE        :  LONGINT)  :  SMALLINT;
                       {$IFDEF WIN32} STDCALL; {$ENDIF}


{$IFDEF WIN32}

FUNCTION EX_STOREAUTOBANK(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL; {$ENDIF}

{$ENDIF}


Function EX_UPDATEUPLIFT (Const TRANSREF  : PCHAR;
                          Const TRANSLINE : LONGINT;
                          Const STOCKCODE : PCHAR;
                          Const UPLIFTAMT : DOUBLE) : SmallInt;
                          {$IFDEF WIN32} STDCALL {$ENDIF}

Function EX_UPDATEUPLIFT2 (Const LOCKTRANS : BOOLEAN;
                           Const TRANSREF  : PCHAR;
                           Const TRANSLINE : LONGINT;
                           Const STOCKCODE : PCHAR;
                           Const UPLIFTAMT : DOUBLE) : SmallInt;
                           {$IFDEF WIN32} STDCALL {$ENDIF}

FUNCTION EX_STOREEACHBOMLINE(P          :  POINTER;
                             PSIZE      :  LONGINT;
                             SEARCHMODE :  SMALLINT)  :  SMALLINT;
                             {$IFDEF WIN32} STDCALL; {$ENDIF}


FUNCTION EX_GETSERIALBATCH(P            :  POINTER;
                           PSIZE        :  LONGINT;
                           SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}


FUNCTION EX_STORESERIALBATCH(P            :  POINTER;
                             PSIZE        :  LONGINT;
                             SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                             {$IFDEF WIN32} STDCALL; {$ENDIF}


FUNCTION EX_USESERIALBATCH(P            :  POINTER;
                           PSIZE        :  LONGINT;
                           SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}

FUNCTION EX_CONVERTAMOUNT(FROMCURR   :  SMALLINT;
                          TOCURR     :  SMALLINT;
                      VAR AMOUNT     :  DOUBLE;
                          RATETYPE   :  SMALLINT)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL; {$ENDIF}

{$IFDEF WIN32}

FUNCTION EX_CHECKPASSWORD(USERNAME      :  PCHAR;
                          USERPASSWORD  :  PCHAR)  :  SMALLINT; STDCALL;


FUNCTION EX_GETRECORDADDRESS(    FILENUM     :  SMALLINT;
                             VAR RECADDRESS  :  LONGINT)  :  SMALLINT;  STDCALL;


FUNCTION EX_GETRECWITHADDRESS(FILENUM,
                              KEYPATH  :  SMALLINT;
                              TRECADDR :  LONGINT )  :  SMALLINT;  STDCALL;

Function  EX_INITSTRUCTURE  (Var   Struct     : Pointer;
                             Const StructSize : LongInt) : SmallInt; StdCall;

{$ENDIF}

FUNCTION EX_STORETRANSHED(P      : POINTER;
                          PSIZE  : SMALLINT) :  SMALLINT;
                          {$IFDEF WIN32} STDCALL; {$ENDIF}

FUNCTION EX_INITBTRIEVE : SMALLINT;

FUNCTION EX_GETLINETOTAL(P      : POINTER;
                         PSIZE  : SMALLINT;
                         USEDISCOUNT : WORDBOOL;
                         SETTLEDISC : DOUBLE;
                         var LINETOTAL : DOUBLE): SMALLINT;
                         {$IFDEF WIN32} STDCALL; {$ENDIF}

PROCEDURE EX_SETCALCLINECOUNT(WANTCOUNT : WORDBOOL);
                             {$IFDEF WIN32} STDCALL; {$ENDIF}

FUNCTION EX_OVERRIDEINI(SETTING, VALUE : PCHAR) : SMALLINT;
                        {$IFDEF WIN32} STDCALL {$ENDIF};

FUNCTION EX_READINIVALUE(SETTING : PCHAR; VAR VALUE : PCHAR) : SMALLINT;
                         {$IFDEF WIN32} STDCALL {$ENDIF};

FUNCTION EX_TRANCANBEUPDATED(DOCREF   :  PCHAR)  :  SMALLINT;
                            {$IFDEF WIN32} STDCALL; {$ENDIF}

FUNCTION EX_UNLOCKRECORD(FILENUM : SMALLINT; RECORDPOSN : LONGINT) : SMALLINT;
                            {$IFDEF WIN32} STDCALL; {$ENDIF}

FUNCTION EX_STORETRANSDETL(P      : POINTER; PSIZE  : SMALLINT) :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}

FUNCTION EX_CHECKSECURITY(UserName : PChar; AreaCode : longint; var SecurityResult : smallint): smallint;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}

FUNCTION EX_GETECOMMSDATA(P            :  POINTER;
                          PSIZE        :  LONGINT) :  SMALLINT;
                          {$IFDEF WIN32} STDCALL; {$ENDIF}

FUNCTION EX_FILESIZE(FILENUM  :  SMALLINT)  :  LONGINT;
                    {$IFDEF WIN32} STDCALL; {$ENDIF}

FUNCTION EX_DATETOENTPERIOD(TRANSDATE : PCHAR;
                            VAR FINPERIOD,
                                FINYEAR : SMALLINT) : SMALLINT;
                            {$IFDEF WIN32} STDCALL; {$ENDIF}

Function EX_DEFAULTFORM (P : POINTER; PSIZE : LONGINT) : SmallInt;
                            {$IFDEF WIN32} STDCALL; {$ENDIF}

Function EX_DEFAULTEMAILDETS (P           : Pointer;
                              PSize       : LongInt;
                              ToRecip     : PChar;
                              CCRecip     : PChar;
                              BCCRecip    : PChar;
                              MsgText     : PChar;
                              UserCode    : PChar;
                              AcCode      : PChar) : SmallInt;
                              {$IFDEF WIN32} STDCALL; {$ENDIF}

Function EX_PRINTTOEMAIL (P           : Pointer;
                          PSize       : LongInt;
                          ToRecip     : PChar;
                          CCRecip     : PChar;
                          BCCRecip    : PChar;
                          MsgText     : PChar;
                          Attachments : PChar) : SmallInt;
                          {$IFDEF WIN32} STDCALL; {$ENDIF}

FUNCTION EX_CALCULATETRANSTOTAL(THOURREF     :  PCHAR;
                                USEVARIANCE  :  WORDBOOL;
                                USEROUNDUP   :  WORDBOOL;
                            VAR TOTALVALUE   :  DOUBLE)  :  SMALLINT;
                                {$IFDEF WIN32} STDCALL; {$ENDIF}

FUNCTION EX_STOREEBUSTRANS(P,
                           PL         :  POINTER;
                           PSIZE,
                           PLSIZE     :  LONGINT;
                           SEARCHPATH :  SMALLINT;
                           SEARCHMODE :  SMALLINT) : SMALLINT;
                           {$IFDEF WIN32} STDCALL {$ENDIF}

FUNCTION EX_CALCLINETAX(P      : POINTER;
                         PSize  : SMALLINT;
                         SettleDisc : double): smallint;
                         {$IFDEF WIN32} STDCALL; {$ENDIF}

FUNCTION EX_GETCORRECTVATCODE(P : POINTER; PSize : SMALLINT): smallint;
                         {$IFDEF WIN32} STDCALL; {$ENDIF}

FUNCTION EX_GETSTOCKBYFOLIO(P           :  POINTER;
                            PSIZE       :  LONGINT;
                            FOLIONUM    :  LONGINT;
                            SEARCHMODE  :  SMALLINT;
                            LOCK        :  WORDBOOL)  :  SMALLINT;
                            {$IFDEF WIN32} STDCALL; {$ENDIF}

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 IMPLEMENTATION


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


{* Index No. 206 to 219 will be used for VB functions/procedures *}
CONST
   {$IFDEF WIN32}
     DllNAME = 'ENTDLL32.DLL';
   {$ELSE}
     { Important Note: In 16-bit Windows the '.DLL' is not required, if present }
     {                 it will cause the dLL to fail to load.                   }
     DLLNAME = 'ENTDLL16';
   {$ENDIF}



  PROCEDURE EX_TESTMODE (MODE : WORDBOOL); {$IFDEF WIN32} STDCALL; {$ENDIF}
                         EXTERNAL DLLNAME INDEX 34;

  FUNCTION EX_GETACCOUNT(P            :  POINTER;
                         PSIZE        :  LONGINT;
                         SEARCHKEY    :  PCHAR;
                         SEARCHPATH   :  SMALLINT;
                         SEARCHMODE   :  SMALLINT;
                         ACCTYPE      :  SMALLINT;
                         LOCK         :  WORDBOOL) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                         EXTERNAL DLLNAME INDEX 3;

  FUNCTION EX_STOREACCOUNT(P            :  POINTER;
                           PSIZE        :  LONGINT;
                           SEARCHPATH   :  SMALLINT;
                           SEARCHMODE   :  SMALLINT) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXTERNAL DLLNAME INDEX 4;

  FUNCTION EX_UNLOCKACCOUNT : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                              EXTERNAL DLLNAME INDEX 5;

  FUNCTION EX_GETACCOUNTBALANCE(P          :  POINTER;
                                PSIZE      :  LONGINT;
                                ACCODE     :  PCHAR;
                                SEARCHMODE :  SMALLINT) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                                EXTERNAL DLLNAME INDEX 6;

{$IFDEF WIN32}

  FUNCTION EX_STOREDISCMATRIX(P            :  POINTER;
                              PSIZE        :  LONGINT;
                              SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                              {$IFDEF WIN32} STDCALL; {$ENDIF}
                              EXTERNAL DLLNAME INDEX 7;

  FUNCTION EX_GETDISCMATRIX(P            :  POINTER;
                            PSIZE        :  LONGINT;
                            SEARCHPATH   :  SMALLINT;
                            SEARCHMODE   :  SMALLINT;
                            LOCK         :  WORDBOOL)  :  SMALLINT;
                            {$IFDEF WIN32} STDCALL; {$ENDIF}
                            EXTERNAL DLLNAME INDEX 8;

  FUNCTION EX_INITBTRIEVE : SMALLINT; EXTERNAL DLLNAME INDEX 9;

{$ENDIF}



  FUNCTION EX_GETTRANS(P,
                       PLINES         :  POINTER;
                       PSIZE          :  LONGINT;
                       PLSIZE         :  LONGINT;
                       SEARCHKEY      :  PCHAR;
                       SEARCHPATH     :  SMALLINT;
                       SEARCHMODE     :  SMALLINT;
                       LOCK           :  WORDBOOL) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                       EXTERNAL DLLNAME INDEX 20;


  FUNCTION EX_STORETRANS(P,
                         PL         :  POINTER;
                         PSIZE      :  LONGINT;
                         PLSize     :  LONGINT;
                         SEARCHPATH :  SMALLINT;
                         SEARCHMODE :  SMALLINT) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                         EXTERNAL DLLNAME INDEX 21;

  FUNCTION EX_GETNEXTTRANSNO(DOCSTR : PCHAR;
                             NEXTNO : PCHAR;
                             UPDATE : WORDBOOL) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                             EXTERNAL DLLNAME INDEX 22;

  FUNCTION EX_GETTOTALTRANSLINES(DOCREF : PCHAR) : LONGINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                             EXTERNAL DLLNAME INDEX 23;

  FUNCTION EX_GETTRANSHED(P              :  POINTER;
                          PSIZE          :  LONGINT;
                          SEARCHKEY      :  PCHAR;
                          SEARCHPATH     :  SMALLINT;
                          SEARCHMODE     :  SMALLINT;
                          LOCK           :  WORDBOOL) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                          EXTERNAL DLLNAME INDEX 24;

  FUNCTION EX_GETTRANSLINE(PLINE          :  POINTER;
                           PLSIZE         :  LONGINT;
                           SEARCHKEY      :  PCHAR;
                           SEARCHPATH     :  SMALLINT;
                           SEARCHMODE     :  SMALLINT;
                           LOCK           :  WORDBOOL) : SMALLINT;
                           {$IFDEF WIN32} STDCALL {$ENDIF}
                           EXTERNAL DLLNAME INDEX 25;


  FUNCTION EX_CONVERTFOLIO(FOLIONUMBER  :  LONGINT)  :  SHORTSTRING; {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXTERNAL DLLNAME INDEX 26;


  FUNCTION EX_GETSTOCK(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHKEY    :  PCHAR;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT;
                       LOCK         :  WORDBOOL) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                       EXTERNAL DLLNAME INDEX 30;

   FUNCTION EX_STORESTOCK(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHPATH   :  SMALLINT;
                          SEARCHMODE   :  SMALLINT) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                          EXTERNAL DLLNAME INDEX 31;

  FUNCTION EX_UNLOCKSTOCK : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                            EXTERNAL DLLNAME INDEX 32;

  FUNCTION EX_INITDLL : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                        EXTERNAL DLLNAME INDEX 1;

  FUNCTION EX_CLOSEDLL : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                         EXTERNAL DLLNAME INDEX 2;

  FUNCTION EX_VERSION : SHORTSTRING; {$IFDEF WIN32} STDCALL; {$ENDIF}
                        EXTERNAL DLLNAME INDEX 33;


  FUNCTION EX_GETGLACCOUNT(P            :  POINTER;
                           PSIZE        :  LONGINT;
                           SEARCHKEY    :  PCHAR;
                           SEARCHPATH   :  SMALLINT;
                           SEARCHMODE   :  SMALLINT;
                           LOCK         :  WORDBOOL) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXTERNAL DLLNAME INDEX 44;

  FUNCTION EX_STOREGLACCOUNT(P            :  POINTER;
                             PSIZE        :  LONGINT;
                             SEARCHPATH   :  SMALLINT;
                             SEARCHMODE   :  SMALLINT) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                             EXTERNAL DLLNAME INDEX 45;


  FUNCTION EX_GETSTOCKBOM(P               :  POINTER;
                          PSIZE           :  LONGINT;
                          SEARCHKEY       :  PCHAR;
                          SEARCHMODE      :  SMALLINT) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                          EXTERNAL DLLNAME INDEX 46;


  FUNCTION EX_GETLINESERIALNOS(P               :  POINTER;
                               PSIZE           :  LONGINT;
                               SEARCHKEY       :  PCHAR;
                               SEARCHLINENO    :  LONGINT;
                               SEARCHMODE      :  SMALLINT) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                               EXTERNAL DLLNAME INDEX 47;

  FUNCTION EX_ACCOUNTFILESIZE  :  LONGINT;  {$IFDEF WIN32} STDCALL; {$ENDIF}
                                  EXTERNAL DLLNAME INDEX 48;

  FUNCTION EX_HASOUTSTANDING(CUSTCODE :  PCHAR) : WORDBOOL; {$IFDEF WIN32} STDCALL; {$ENDIF}
                             EXTERNAL DLLNAME INDEX 49;

  FUNCTION EX_STORESTOCKBOM(P               :  POINTER;
                            PSIZE           :  LONGINT;
                            SEARCHKEY       :  PCHAR) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                            EXTERNAL DLLNAME INDEX 50;

FUNCTION EX_GETSTKALT(P           :  POINTER;
                      PSIZE       :  LONGINT;
                      SEARCHKEY   :  PCHAR;
                      SEARCHPATH  :  SMALLINT;
                      SEARCHMODE  :  SMALLINT;
                      LOCK        :  WORDBOOL)  :  SMALLINT;   {$IFDEF WIN32} STDCALL {$ENDIF}
                      EXTERNAL DLLNAME INDEX 51;


FUNCTION EX_STORESTKALT(P          :  POINTER;
                        PSIZE      :  LONGINT;
                        SEARCHPATH :  SMALLINT;
                        SEARCHMODE :  SMALLINT)  :  SMALLINT;  {$IFDEF WIN32} STDCALL {$ENDIF}
                        EXTERNAL DLLNAME INDEX 52;



  FUNCTION EX_GETJOB(P            :  POINTER;
                     PSIZE        :  LONGINT;
                     SEARCHKEY    :  PCHAR;
                     SEARCHPATH   :  SMALLINT;
                     SEARCHMODE   :  SMALLINT;
                     LOCK         :  WORDBOOL) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                     EXTERNAL DLLNAME INDEX 60;

  FUNCTION EX_STOREJOB(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT) : SMALLINT;  {$IFDEF WIN32} STDCALL; {$ENDIF}
                       EXTERNAL DLLNAME INDEX 61;

FUNCTION EX_GETJOBANALYSIS(P          :  POINTER;
                           PSIZE      :  LONGINT;
                           SEARCHKEY  :  PCHAR;
                           SEARCHPATH :  SMALLINT;
                           SEARCHMODE :  SMALLINT;
                           LOCK       :  WORDBOOL)  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXTERNAL DLLNAME INDEX 62;

FUNCTION EX_GETJOBEMPLOYEE(P          :  POINTER;
                           PSIZE      :  LONGINT;
                           SEARCHKEY  :  PCHAR;
                           SEARCHPATH :  SMALLINT;
                           SEARCHMODE :  SMALLINT;
                           LOCK       :  WORDBOOL)  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXTERNAL DLLNAME INDEX 63;

FUNCTION EX_GETJOBTIMERATE(P          :  POINTER;
                           PSIZE      :  LONGINT;
                           SEARCHPATH :  SMALLINT;
                           SEARCHMODE :  SMALLINT;
                           LOCK       :  WORDBOOL)  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXTERNAL DLLNAME INDEX 64;

FUNCTION EX_GETJOBTYPE(P          :  POINTER;
                       PSIZE      :  LONGINT;
                       SEARCHKEY  :  PCHAR;
                       SEARCHMODE :  SMALLINT;
                       LOCK       :  WORDBOOL)  :  SMALLINT;
                       {$IFDEF WIN32} STDCALL; {$ENDIF}
                       EXTERNAL DLLNAME INDEX 126;  

  FUNCTION EX_GETSTOCKLOC(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHKEY    :  PCHAR;
                          SEARCHLOC    :  PCHAR;
                          LOCK         :  WORDBOOL )  :  SMALLINT;  {$IFDEF WIN32} STDCALL; {$ENDIF}
                          EXTERNAL DLLNAME INDEX 70;


  FUNCTION EX_STORESTOCKLOC(P            :  POINTER;
                            PSIZE        :  LONGINT;
                            SEARCHMODE   :  SMALLINT)  :  SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                            EXTERNAL DLLNAME INDEX 71;

  FUNCTION EX_GETLOCATION(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHKEY    :  PCHAR;
                          SEARCHPATH   :  SMALLINT;
                          SEARCHMODE   :  SMALLINT;
                          LOCK         :  WORDBOOL)  :  SMALLINT;   {$IFDEF WIN32} STDCALL; {$ENDIF}
                          EXTERNAL DLLNAME INDEX 72;

  FUNCTION EX_STORELOCATION(P            :  POINTER;
                            PSIZE        :  LONGINT;
                            SEARCHPATH   :  SMALLINT;
                            SEARCHMODE   :  SMALLINT)  :  SMALLINT;   {$IFDEF WIN32} STDCALL; {$ENDIF}
                            EXTERNAL DLLNAME INDEX 73;

  FUNCTION EX_ROUNDUP(INPUTVALUE     :  DOUBLE;
                      DECIMALPLACES  :  SMALLINT)  :  DOUBLE;  {$IFDEF WIN32} STDCALL; {$ENDIF}
                      EXTERNAL DLLNAME INDEX 74;


  FUNCTION EX_GETMATCH(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHKEY    :  PCHAR;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT;
                       LOCK         :  WORDBOOL)  :  SMALLINT;   {$IFDEF WIN32} STDCALL; {$ENDIF}
                       EXTERNAL DLLNAME INDEX 75;

  FUNCTION EX_STOREMATCH(P            :  POINTER;
                         PSIZE        :  LONGINT;
                         SEARCHPATH   :  SMALLINT;
                         SEARCHMODE   :  SMALLINT)  :  SMALLINT;   {$IFDEF WIN32} STDCALL; {$ENDIF}
                         EXTERNAL DLLNAME INDEX 76;

  FUNCTION EX_GETNOTES(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHKEY    :  PCHAR;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT;
                       LOCK         :  WORDBOOL)  :  SMALLINT;   {$IFDEF WIN32} STDCALL; {$ENDIF}
                       EXTERNAL DLLNAME INDEX 77;

  FUNCTION EX_STORENOTES(P            :  POINTER;
                         PSIZE        :  LONGINT;
                         SEARCHPATH   :  SMALLINT;
                         SEARCHMODE   :  SMALLINT)  :  SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                         EXTERNAL DLLNAME INDEX 78;

  FUNCTION EX_GETCCDEP(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHKEY    :  PCHAR;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT;
                       CCDEPTYPE    :  SMALLINT;
                       LOCK         :  WORDBOOL) : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                       EXTERNAL DLLNAME INDEX 79;

  FUNCTION EX_CALCSTOCKPRICE(P      :  POINTER;
                             PSIZE  :  LONGINT)   :  SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                             EXTERNAL DLLNAME INDEX 80;

  FUNCTION EX_GETVATRATE(P      :  POINTER;
                         PSIZE  :  LONGINT)   :  SMALLINT;  {$IFDEF WIN32} STDCALL; {$ENDIF}
                         EXTERNAL DLLNAME INDEX 81;

  PROCEDURE EX_SILENTLOCK(SILENT  :  WORDBOOL);  {$IFDEF WIN32} STDCALL; {$ENDIF}
                          EXTERNAL DLLNAME INDEX 82;

  PROCEDURE EX_SETRELEASECODE(RELCODE : PCHAR);  {$IFDEF WIN32} STDCALL; {$ENDIF}
                          EXTERNAL DLLNAME INDEX 83;

  FUNCTION  EX_INITDLLPATH(EXPATH    :  PCHAR;
                           MCSYSTEM  :  WORDBOOL) :  SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXTERNAL DLLNAME INDEX 84;


  FUNCTION EX_GETTLLINE(FOLIONUMBER,
                        LINENUMBER  :  LONGINT;
                        PLINE       :  POINTER;
                        PLSIZE      :  LONGINT)  :  SMALLINT;
                        {$IFDEF WIN32} STDCALL {$ENDIF}
                        EXTERNAL DLLNAME INDEX 85;


  FUNCTION EX_GETDATAPATH(VAR EXDATAPATH  :  PCHAR)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL {$ENDIF}
                          EXTERNAL DLLNAME INDEX 86;

  FUNCTION EX_GETTHBYFOLIO(FOLIONUMBER :  LONGINT;
                           P           :  POINTER;
                           PSIZE       :  LONGINT)  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL {$ENDIF}
                           EXTERNAL DLLNAME INDEX 87;



{$IFDEF WIN32}

  FUNCTION EX_INITPRINTFORM(DATAPATH :  PCHAR)  :  SMALLINT;  STDCALL;
                            EXTERNAL DLLNAME INDEX 200;

  FUNCTION EX_ADDTRANSFORM(REFNO     :  PCHAR;
                           FORMNAME  :  PCHAR)  :  SMALLINT;  STDCALL;
                           EXTERNAL DLLNAME INDEX 201;

  FUNCTION EX_PRINTFORM(PREVIEWSTAT :  WORDBOOL;
                        NOOFCOPIES  :  SMALLINT )  :  SMALLINT;  STDCALL;
                        EXTERNAL DLLNAME INDEX 202;

  PROCEDURE EX_ENDPRINTFORM;  STDCALL;
            EXTERNAL DLLNAME INDEX 203;

{$ENDIF}

FUNCTION EX_ERRORDESCRIPTION(INDEXNO   :  SMALLINT;
                             ERRORCODE :  SMALLINT) : SHORTSTRING;
                             {$IFDEF WIN32} STDCALL {$ENDIF}
                             EXTERNAL DLLNAME INDEX 1000;

FUNCTION EX_GETTHBYRUNNO(P          :  POINTER;
                         PSIZE      :  LONGINT;
                         RUNNO      :  LONGINT;
                         SEARCHMODE :  SMALLINT;
                         LOCK       :  WORDBOOL) : SMALLINT;
                         {$IFDEF WIN32} STDCALL {$ENDIF}
                         EXTERNAL DLLNAME INDEX 88;

FUNCTION EX_STORETH(P          :  POINTER;
                    PSIZE      :  SMALLINT;             {* Size of TH *}
                    SEARCHPATH :  SMALLINT;
                    UPDATEMODE :  SMALLINT;
                    AUTHCODE   :  LONGINT)  :  SMALLINT;
                    {$IFDEF WIN32} STDCALL {$ENDIF}
                    EXTERNAL DLLNAME INDEX 89;

FUNCTION EX_GETCURRENCY(P     : POINTER;
                        PSIZE : LONGINT;
                        CURR  : SMALLINT) : SMALLINT;
                        {$IFDEF WIN32} STDCALL; {$ENDIF}
                        EXTERNAL DLLNAME INDEX 90;


FUNCTION EX_GETSYSDATA(P            :  POINTER;
                       PSIZE        :  LONGINT)  :  SMALLINT;
                       {$IFDEF WIN32} STDCALL; {$ENDIF}
                        EXTERNAL DLLNAME INDEX 91;


{$IFDEF WIN32}

FUNCTION EX_STOREAUTOBANK(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL; {$ENDIF}
                          EXTERNAL DLLNAME INDEX 92;


{$ENDIF}

Function EX_UPDATEUPLIFT (Const TRANSREF  : PCHAR;
                          Const TRANSLINE : LONGINT;
                          Const STOCKCODE : PCHAR;
                          Const UPLIFTAMT : DOUBLE) : SmallInt;
                          {$IFDEF WIN32} STDCALL; {$ENDIF}
                          EXTERNAL DLLNAME INDEX 93;

Function EX_UPDATEUPLIFT2 (Const LockTrans : Boolean;
                           Const TRANSREF  : PCHAR;
                           Const TRANSLINE : LONGINT;
                           Const STOCKCODE : PCHAR;
                           Const UPLIFTAMT : DOUBLE) : SmallInt;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXTERNAL DLLNAME INDEX 98;


FUNCTION EX_STOREEACHBOMLINE(P          :  POINTER;
                             PSIZE      :  LONGINT;
                             SEARCHMODE :  SMALLINT)  :  SMALLINT;
                             {$IFDEF WIN32} STDCALL; {$ENDIF}
                             EXTERNAL DLLNAME INDEX 94;


FUNCTION EX_GETSERIALBATCH(P            :  POINTER;
                           PSIZE        :  LONGINT;
                           SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXTERNAL DLLNAME INDEX 95;


FUNCTION EX_STORESERIALBATCH(P            :  POINTER;
                             PSIZE        :  LONGINT;
                             SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                             {$IFDEF WIN32} STDCALL; {$ENDIF}
                             EXTERNAL DLLNAME INDEX 96;


FUNCTION EX_USESERIALBATCH(P            :  POINTER;
                           PSIZE        :  LONGINT;
                           SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXTERNAL DLLNAME INDEX 97;

{* 98 = UpLift function *}

FUNCTION EX_CONVERTAMOUNT(FROMCURR   :  SMALLINT;
                          TOCURR     :  SMALLINT;
                      VAR AMOUNT     :  DOUBLE;
                          RATETYPE   :  SMALLINT)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL {$ENDIF}
                          EXTERNAL DLLNAME INDEX 99;

{$IFDEF WIN32}

FUNCTION EX_CHECKPASSWORD(USERNAME      :  PCHAR;
                          USERPASSWORD  :  PCHAR)  :  SMALLINT;
                          STDCALL;
                          EXTERNAL DLLNAME INDEX 120;

FUNCTION EX_CLOSEDATA : SMALLINT; {$IFDEF WIN32} STDCALL; {$ENDIF}
                         EXTERNAL DLLNAME INDEX 121;

FUNCTION EX_GETRECORDADDRESS(    FILENUM     :  SMALLINT;
                             VAR RECADDRESS  :  LONGINT)  :  SMALLINT;
                             STDCALL;
                             EXTERNAL DLLNAME INDEX 122;

FUNCTION EX_GETRECWITHADDRESS(FILENUM,
                              KEYPATH  :  SMALLINT;
                              TRECADDR :  LONGINT )  :  SMALLINT;  STDCALL;
                              EXTERNAL DLLNAME INDEX 123;


Function  EX_INITSTRUCTURE  (Var   Struct     : Pointer;
                             Const StructSize : LongInt) : SmallInt; StdCall;
                             EXTERNAL DLLNAME INDEX 206;


{$ENDIF}

FUNCTION EX_STORETRANSHED(P      : POINTER;
                          PSIZE  : SMALLINT) :  SMALLINT;
                          {$IFDEF WIN32} STDCALL {$ENDIF}
                          EXTERNAL DLLNAME INDEX 125;



FUNCTION EX_GETLINETOTAL(P      : POINTER;
                         PSIZE  : SMALLINT;
                         USEDISCOUNT : WORDBOOL;
                         SETTLEDISC : DOUBLE;
                         var LINETOTAL : DOUBLE): SMALLINT;
                         {$IFDEF WIN32} STDCALL {$ENDIF}
                         EXTERNAL DLLNAME INDEX 127;

PROCEDURE EX_SETCALCLINECOUNT(WANTCOUNT : WORDBOOL);
                             {$IFDEF WIN32} STDCALL; {$ENDIF}
                              EXTERNAL DLLNAME INDEX 128;

FUNCTION EX_OVERRIDEINI(SETTING, VALUE : PCHAR) : SMALLINT;
                        {$IFDEF WIN32} STDCALL {$ENDIF}
                         EXTERNAL DLLNAME INDEX 129;

FUNCTION EX_TRANCANBEUPDATED(DOCREF   :  PCHAR)  :  SMALLINT;
                            {$IFDEF WIN32} STDCALL; {$ENDIF}
                             EXTERNAL DLLNAME INDEX 130;

FUNCTION EX_READINIVALUE(SETTING : PCHAR; VAR VALUE : PCHAR) : SMALLINT;
                            {$IFDEF WIN32} STDCALL; {$ENDIF}
                            EXTERNAL DLLNAME INDEX 131;

FUNCTION EX_UNLOCKRECORD(FILENUM : SMALLINT; RECORDPOSN : LONGINT) : SMALLINT;
                            {$IFDEF WIN32} STDCALL; {$ENDIF}
                            EXTERNAL DLLNAME INDEX 132;

FUNCTION EX_STORETRANSDETL(P      : POINTER;
                           PSIZE  : SMALLINT) :  SMALLINT;
                           {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXTERNAL DLLNAME INDEX 133;

FUNCTION EX_CHECKSECURITY(UserName : PChar; AreaCode : longint; var SecurityResult : smallint): smallint;
                           {$IFDEF WIN32} STDCALL; {$ENDIF} EXTERNAL DLLNAME INDEX 134;

FUNCTION EX_GETECOMMSDATA(P            :  POINTER;
                          PSIZE        :  LONGINT) :  SMALLINT;
                          {$IFDEF WIN32} STDCALL; {$ENDIF} EXTERNAL DLLNAME INDEX 135;

FUNCTION EX_FILESIZE(FILENUM  :  SMALLINT)  :  LONGINT;
                    {$IFDEF WIN32} STDCALL {$ENDIF} EXTERNAL DLLNAME INDEX 137;

FUNCTION EX_DATETOENTPERIOD(TRANSDATE : PCHAR;
                            VAR FINPERIOD,
                                FINYEAR : SMALLINT) : SMALLINT;
                            {$IFDEF WIN32} STDCALL; {$ENDIF}
                            EXTERNAL DLLNAME INDEX 138;

Function EX_DEFAULTFORM (P : POINTER; PSIZE : LONGINT) : SmallInt;
                            {$IFDEF WIN32} STDCALL; {$ENDIF}
                            EXTERNAL DLLNAME INDEX 139;

Function EX_DEFAULTEMAILDETS (P           : Pointer;
                              PSize       : LongInt;
                              ToRecip     : PChar;
                              CCRecip     : PChar;
                              BCCRecip    : PChar;
                              MsgText     : PChar;
                              UserCode    : PChar;
                              AcCode      : PChar) : SmallInt;
                              {$IFDEF WIN32} STDCALL; {$ENDIF}
                              EXTERNAL DLLNAME INDEX 140;

Function EX_PRINTTOEMAIL (P           : Pointer;
                          PSize       : LongInt;
                          ToRecip     : PChar;
                          CCRecip     : PChar;
                          BCCRecip    : PChar;
                          MsgText     : PChar;
                          Attachments : PChar) : SmallInt;
                          {$IFDEF WIN32} STDCALL; {$ENDIF}
                           EXTERNAL DLLNAME INDEX 141;


FUNCTION EX_CALCULATETRANSTOTAL(THOURREF     :  PCHAR;
                                USEVARIANCE  :  WORDBOOL;
                                USEROUNDUP   :  WORDBOOL;
                            VAR TOTALVALUE   :  DOUBLE)  :  SMALLINT;
                                {$IFDEF WIN32} STDCALL {$ENDIF}
                                EXTERNAL DLLNAME INDEX 142;

FUNCTION EX_STOREEBUSTRANS(P,
                           PL         :  POINTER;
                           PSIZE,
                           PLSIZE     :  LONGINT;
                           SEARCHPATH :  SMALLINT;
                           SEARCHMODE :  SMALLINT) : SMALLINT;
                           {$IFDEF WIN32} STDCALL {$ENDIF}
                           EXTERNAL DLLNAME INDEX 143;

FUNCTION EX_CALCLINETAX(P      : POINTER;
                         PSize  : SMALLINT;
                         SettleDisc : double): smallint;
                         {$IFDEF WIN32} STDCALL {$ENDIF}
                         EXTERNAL DLLNAME INDEX 144;

FUNCTION EX_GETCORRECTVATCODE(P : POINTER; PSize : SMALLINT): smallint;
                         {$IFDEF WIN32} STDCALL {$ENDIF}
                         EXTERNAL DLLNAME INDEX 145;

FUNCTION EX_GETSTOCKBYFOLIO(P           :  POINTER;
                            PSIZE       :  LONGINT;
                            FOLIONUM    :  LONGINT;
                            SEARCHMODE  :  SMALLINT;
                            LOCK        :  WORDBOOL)  :  SMALLINT;
                            {$IFDEF WIN32} STDCALL {$ENDIF}
                            EXTERNAL DLLNAME INDEX 146;

END.

