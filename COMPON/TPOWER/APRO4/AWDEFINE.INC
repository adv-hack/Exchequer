{*********************************************************}
{*                   AWDEFINE.INC 4.03                   *}
{*      Assorted conditional compilation directives      *}
{*      Copyright (c) TurboPower Software 1996-2002      *}
{*                 All rights reserved.                  *}
{*********************************************************}

{Because AWDEFINE.INC is included in all APW units, you can specify global
compiler options here. AWDEFINE is included *before* each units' required
compiler options, so options specified here might be overridden by hardcode
options in the source file.}

{$S- No stack overflow checking}
{$R- No range checking}
{$B- Incomplete boolean evaluation}
{$P- No open string parameters}
{$Q- No arithmetic overflow checking}
{$T- No type-checked pointers}
{$V- No var string checking}
{$X+ Extended syntax}
{$Z- Enumeration size is 256}

{$IFDEF Win32}    { not available in D1 for the 16-bit fax printer driver }
  {$H+ Long string support}
  {$J+ Writeable typed constants}
  {$IFOPT H+}
    {$DEFINE HugeStr}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER140}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}

{.$DEFINE TapiDebug}

{-------- !! DON'T CHANGE DEFINES BELOW THIS LINE !! -----------------}

{$IFDEF VER80}                {Delphi 1.0}
  {$IFNDEF PRNDRV}
  !! Error: APRO is a 32-bit library
  {$ENDIF}
{$ENDIF}

{$IFDEF VER90}                {Delphi 2.0}
  !! Error: APRO is compatible with Delphi 3 and above
{$ENDIF}

{$IFDEF VER93}                {C++ Builder 1.0}
  !! Error: APRO is compatible with C++ Builder 3 and above
{$ENDIF}


{$IFDEF VER100}                {Delphi 3.0}
  {$DEFINE AproDelphi}
{$ENDIF}

{$IFDEF VER120}                {Delphi 4.0}
  {$DEFINE AproDelphi}
{$ENDIF}

{$IFDEF VER130}
  {$IFNDEF BCB}
   {$DEFINE AproDelphi}        {Delphi 5.0}
  {$ENDIF}
{$ENDIF}

{$IFDEF Ver140}
  {$IFNDEF BCB}
    {$DEFINE AproDelphi}       {Delphi 6.0}
  {$ENDIF}
{$ENDIF}

{$IFNDEF VER80}
 {$IFNDEF VER90}
  {$IFNDEF VER93}
    {$DEFINE Delphi3}         {Delphi 3.0 or higher}
    {$DEFINE VERSION3}        {Delphi 3.0^ or BCB 3.0^}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

{$IFDEF Delphi3}
  {$IFNDEF VER100}
    {$IFNDEF Ver110}
      {$DEFINE Delphi4}       {Delphi 4.0 or higher}
      {$DEFINE VERSION4}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF Delphi4}
  {$IFNDEF VER120}
    {$IFNDEF Ver125}
      {$DEFINE Delphi5}       {Delphi 5.0 or higher}
      {$DEFINE VERSION5}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF Delphi5}
  {$IFNDEF VER130}
      {$DEFINE Delphi6}       {Delphi 6.0 or higher}
      {$DEFINE VERSION6}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER110}               {C++ Builder 3.0}
  {$ObjExportAll On}
  {$DEFINE AproBCB}
{$ENDIF}

{$IFDEF VER125}               {C++ Builder 4.0}
  {$ObjExportAll On}
  {$DEFINE AproBCB}
{$ENDIF}

{$IFDEF Ver130}               {C++ Builder 5.0}
  {$IFDEF BCB}
    {$ObjExportAll On}
    {$DEFINE AproBCB}
  {$ENDIF}
{$ENDIF}

{$IFDEF Ver140}               {C++ Builder 6.0}
  {$IFDEF BCB}
    {$ObjExportAll On}
    {$DEFINE AproBCB}
  {$ENDIF}
{$ENDIF}

