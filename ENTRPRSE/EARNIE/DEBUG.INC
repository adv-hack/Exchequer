Ver             =  'v5.61.402';

Debug           =  Off;

SetDrive        =  ''; {'N:\exch\';}      {********* Very Important ***********}
SetDir          =  ''; {'N'\exch\';}      {********* For Ex Link ******** }



(*

Include Directories

\exchdev3;
\exchdev3\exlink;
\exchdev3\eximport;
\sbslib\dos\exunit3;
\sbslib\dos;
\sbslib\dos\opro

Unit Directories

d:\bp\units;
d:\bp\bin;
\exchdev3\exlink;
\exchdev3;
\exchdev3\eximport;
\sbslib\dos\exunit3;
\sbslib\dos;
\sbslib\dos\opro;

Object Directories

\exchdev3;
\exchdev3\exlink;
\exchdev3\eximport;
\sbslib\dos\exunit3;
\sbslib\dos;
\sbslib\dos\opro


12.08.99 - Earnie (Y/N) option has been added for
           CMS Business Services (New Zealand).
           If Yes, export for Earnie link.i.e. Pay Rate is 1..10 only.
           If No, export for other use, Pay Rate could be 1..99.

           Exch. one TSH = two lines in export file:-

           Line 1 = PayrollNo(10cha)+PayRateCode(2cha)+No.ofHours(10cha)
           Line 2 = PayrollNo(10cha)+Identifier(2cha) +Amount(10cha)

           Identifier = PayRateCode + 20
           Amount     = PayRateCode * 100

           Since Identifier field width is 2 character, EL advised that
           if "NO", export as Identifier = PayRateCode.

18.08.99 - Sent to Exchequer (New Zealand).


*)