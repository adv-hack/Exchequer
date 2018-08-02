Unit PurgeOU;



{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----====            }
{                                                              }
{                      Created : 03/05/95                      }
{                 Order Processing Purge input                 }
{                                                              }
{                                                              }
{               Copyright (C) 1995 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,
     VarConst;

Type
  Purge_OrdType  = Record
                     PurgePR,
                     PurgeYr  :  Byte;

                     IncCust,
                     ExcCust,
                     IncType,
                     ExcType   :  Str10;

                     PurgeHFName
                               :  Str80;

                     RunRBuild,
                     DelCust,
                     DelSupp,
                     DelStk,
                     DelML,
                     DelSN,
                     OrderMode  :  Boolean;

                     PuSw,
                     PrSw,
                     AISw,
                     AESw,
                     TISw,
                     TESw,
                     RBSw,
                     POSw,
                     DCSw,
                     DSSw,
                     DKSw,
                     DMSw,
                     DNSw     :  Str5;

                   end;


Var
  Purge_OrdRec  :  ^Purge_OrdType;



 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}



Begin

  New(Purge_OrdRec);

  FillChar(Purge_OrdRec^,Sizeof(Purge_OrdRec^),0);

  With Purge_OrdRec^ do
  Begin
    PUSw:='/PU:';
    PRSw:='/PPR:';
    AISw:='/AI:';
    AESw:='/AE:';
    TISw:='/TI:';
    TESw:='/TE:';
    RBSw:='/RB:';
    DCSw:='/DC:';
    DSSw:='/DS:';
    DKSw:='/DK:';
    DMSw:='/DM:';
    DNSw:='/DN:';
    POSw:='/PO:';
    PurgeHFName:=Path2+'HISTPRGE.DAT';
    PurgePr:=12;
    PurgeYr:=100;
  end;

end. {Unit..}