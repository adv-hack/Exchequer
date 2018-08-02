{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 20/10/90                      }
{                                                              }
{                     Version Control Sheet                    }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}

  {$IFNDEF OLE}
    {$IFNDEF LTE}
      //
      // Exchequer aka Enterprise
      //
      {$IFNDEF DBD}
          { Enterprise release version }
          //
          // v7.0 - Normal Exchequer
          //
          //CurrVersion =  'b2018R11.013 '; // Development / Beta Version
          CurrVersion = '2018 R1.1 ';  // Release Version

      {$ELSE}
          { Enterprise under test }
          CurrVersion      =  'b610.064 ';   // Not Used
      {$ENDIF}
    {$ELSE}
      //
      // LITE aka IRIS Accounts Office
      //
      {$IFNDEF DBD}
        CurrVersion      =  {'v1.00 ';} 'b101.052 ';    { IAO release version }
      {$ELSE}
        CurrVersion      =  'b101.052 ';      { IAO under test}
      {$ENDIF}
    {$ENDIF}

  {$ELSE}

    CurrVersion      =  'b550.027' {'v5.01.024'};   { OLE Server }

  {$ENDIF}

  {$IFDEF ESPLASH}
    // Enterprise Splash Screen
    CurrVersion_Splash  =  'b500.002' {'v5.00.001'};
  {$ENDIF}
  {$IFDEF FDES}
    CurrVersion_FD   =  {'b501.033'} 'v5.00.033';   { Form Designer version }
  {$ENDIF}
  {$IFDEF EDLL}
    CurrVersion_DLL  =  'b550.057' {'v5.01.052'};   { DLL version }
  {$ENDIF}
  {$IFDEF RW}
    CurrVersion_RW  =   {'b500.039'} 'v7.0.5.061';   { Report Writer version }
  {$ENDIF}
  {$IFDEF COMP}
    CurrVersion_Comp =  'b550.127' {'5.00.129'};   { Multi-Company Manager version }
  {$ENDIF}
  {$IFDEF U2L}
    CurrVersion_U2L =   {'b500.330'} 'v5.00.331';   { Crystal U2L version }
  {$ENDIF}
  {$IFDEF ODLL}
    CurrVersion_ODLL =  {'b500.330'} 'v5.00.330';   { ODBC Functions DLL version }
  {$ENDIF}
  {$IFDEF XO}
    CurrVersion_XO  =   'b106' {'v4.21'};   { XO version }
  {$ENDIF}
  {$IFDEF REG}
    CurrVersion_Reg  =   'b501.019' {'v5.00.017'};   { EntReg version }
  {$ENDIF}
  {$IFDEF WCA}
    CurrVersion_WCA     =   'b159' {'v4.23'};   { Windows Card System version }
    {$IFDEF U2L}
      CurrVersion_WCA_U2L =   'b157' {'v4.23'};   { Card System Crystal U2L version }
    {$ENDIF}
  {$ENDIF}

  {$IFDEF SETAR}
    // HM 26/03/02: Modified to be a Build Number only so that it doesn't look like the
    //              Enterprise Version Number
    //CurrVer_SetupAutoRun  =  {'b500.303'} 'v5.00';
    CurrVer_SetupAutoRun  =  'Build 309';           { Enterprise Setup - Auto Run Program }
  {$ENDIF}
  {$IFDEF SETCD}
    CurrVer_CDGenLic  =  'b550.308' {''};   { Enterprise Setup - CD Licence Generator }
  {$ENDIF}
  {$IFDEF SETVW}
    CurrVer_ViewLic  =  'b561.306' {'v1.12'};   { Enterprise Setup - View Licence Utility }
  {$ENDIF}
  {$IFDEF VWERC}
    CurrVer_ViewERC  =  {'b000.400'} 'v1.40';   { Enterprise Setup - View ERC File Utility }
  {$ENDIF}

{$IFDEF MC_On}

    VerNo           =  CurrVersion+'ProMC';

  {$ELSE}

    {$IFDEF PF_On}

      VerNo           =  CurrVersion+'ProSC';

    {$ELSE}

      VerNo           =  CurrVersion+'SC';

    {$ENDIF}

{$ENDIF}

{$IFDEF SOP}

  STKVer          =  '/SOP';

{$ELSE}

  {$IFDEF STK}

    STKVer          =  '/Stk';

  {$ELSE}

    STKVer           = '';

  {$ENDIF}

{$ENDIF}

{$IFDEF BCS}

   Ver            :  ShortString =  VerNo+STKVer+'/SQL ';

{$ELSE}

   Ver            :  ShortString =  VerNo+STKVer+'/WGE ';

{$ENDIF}
