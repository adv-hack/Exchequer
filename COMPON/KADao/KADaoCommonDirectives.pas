//******************************************************************************
// COMMON PREPROCESSOR DIRECTIVES
//******************************************************************************
{$DEFINE DYNADAO}        //This is the preffered way to use DAO - disable if
                         //one of the bottom options are enabled
{DEFINE DAO35}           //Disable DYNADAO and DAO36 to USE
{DEFINE DAO36}           //Disable DYNADAO and DAO35 to USE
//******************************************************************************
// Protection for absent-minded people
//******************************************************************************
{$IFDEF DYNADAO}
  {$IFDEF DAO36}
   YOU CANNOT DEFINE BOTH DYNADAO AND DAO36
  {$ENDIF}
  {$IFDEF DAO35}
   YOU CANNOT DEFINE BOTH DYNADAO AND DAO35
  {$ENDIF}
{$ELSE}
  {$IFDEF DAO36}
     {$IFDEF DAO35}
        YOU CANNOT DEFINE BOTH DAO35 AND DAO36
     {$ENDIF}
  {$ENDIF}
{$ENDIF}
{$IFNDEF DYNADAO}
  {$IFNDEF DAO35}
   {$IFNDEF DAO36}
      YOU MUST DEFINE DAO35 OR DAO36 OR DYNADAO
     {$ENDIF}
  {$ENDIF}
{$ENDIF}
//******************************************************************************
{**************************************************** defines for C++Builder 1 }
{$IFDEF VER93}
  {$DEFINE D1UP}
  {$DEFINE D2UP}
  {$DEFINE CBUILDER}
  {$DEFINE CBUILDER1}
  {$DEFINE CBUILDER1UP}
{$ENDIF}

{********************************************************  defines for Delphi 3 }
{$IFDEF VER100}
  {$DEFINE DELPHI}
  {$DEFINE DELPHI3}
  {$DEFINE D1UP}
  {$DEFINE D2UP}
  {$DEFINE D3UP}
{$ENDIF}

{****************************************************  defines for C++Builder 3 }
{$IFDEF VER110}
  {$DEFINE D1UP}
  {$DEFINE D2UP}
  {$DEFINE D3UP}
  {$DEFINE CBUILDER}
  {$DEFINE CBUILDER3}
  {$DEFINE CBUILDER1UP}
  {$DEFINE CBUILDER3UP}
{$ENDIF}

{********************************************************  defines for Delphi 4 }
{$IFDEF VER120}
  {$DEFINE DELPHI}
  {$DEFINE DELPHI4}
  {$DEFINE D1UP}
  {$DEFINE D2UP}
  {$DEFINE D3UP}
  {$DEFINE D4UP}
{$ENDIF}

{****************************************************  defines for C++Builder 4 }
{$IFDEF VER125}
  {$DEFINE D1UP}
  {$DEFINE D2UP}
  {$DEFINE D3UP}
  {$DEFINE D4UP}
  {$DEFINE CBUILDER}
  {$DEFINE CBUILDER4}
  {$DEFINE CBUILDER1UP}
  {$DEFINE CBUILDER3UP}
  {$DEFINE CBUILDER4UP}
{$ENDIF}

{************************************* defines for Delphi 5 and/or C++Builder 5 }
{$IFDEF VER130}
  {$DEFINE D1UP}
  {$DEFINE D2UP}
  {$DEFINE D3UP}
  {$DEFINE D4UP}
  {$DEFINE D5UP}
  {$IFNDEF BCB}
    {$DEFINE DELPHI}
    {$DEFINE DELPHI5}
  {$ELSE}
    {$DEFINE CBUILDER}
    {$DEFINE CBUILDER5}
    {$DEFINE CBUILDER1UP}
    {$DEFINE CBUILDER3UP}
    {$DEFINE CBUILDER4UP}
    {$DEFINE CBUILDER5UP}
  {$ENDIF}
{$ENDIF}

{***************************************************** **** defines for Delphi 6 }
{$IFDEF VER140}
  {$DEFINE DELPHI}
  {$DEFINE DELPHI6}
  {$DEFINE D1UP}
  {$DEFINE D2UP}
  {$DEFINE D3UP}
  {$DEFINE D4UP}
  {$DEFINE D5UP}
  {$DEFINE D6UP}
{$ENDIF}

{$IFDEF WIN32}
  {$DEFINE MSWINDOWS}
  {$DEFINE 32BIT}
{$ENDIF}

{$IFDEF DELPHI}
  {$IFDEF D2UP}
    {$DEFINE DELPHI_32BIT}
  {$ENDIF}
{$ENDIF}

{$IFDEF CBUILDER}
  {$DEFINE CBUILDER_32BIT}
{$ENDIF}
//******************************************************************************
