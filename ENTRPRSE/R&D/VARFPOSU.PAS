Unit VarFPOSU;




{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 31/07/90                      }
{                                                              }
{               Global variables & Type definitions            }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}



Interface



const
  {$IFDEF SOP}
    DelAcrualRunNo  =  -23;
  {$ENDIF}

  {$IFDEF RET}
    {RETAcrualRunNo  =  -25;}
  {$ENDIF}



{* File Constants *}


{$I FilePath.Inc}



Var

  ULFirstIn,
  GotUserLic  :  Boolean;
  ExMainCoPath  :  ^ShortString;



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}




Begin

   
  GotUserLic:=FALSE;

  ULFirstIn:=FALSE;

  New(ExMainCoPath);

  FillChar(ExMainCoPath^,Sizeof(ExMainCoPath^),0);


end.