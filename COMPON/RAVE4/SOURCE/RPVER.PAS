{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

{$IFDEF VER80} { Delphi 1.0 }
  {$DEFINE DELPHI }
{$ENDIF}
{$IFDEF VER90} { Delphi 2.0 }
  {$DEFINE DELPHI }
{$ENDIF}
{$IFDEF VER93} { C++Builder 1.0 }
  {$DEFINE CBUILDER }
{$ENDIF}
{$IFDEF VER100} { Delphi 3.0 }
  {$DEFINE LEVEL3 }
  {$DEFINE DELPHI }
{$ENDIF}
{$IFDEF VER110} { C++Builder 3.0 }
  {$DEFINE LEVEL3 }
  {$DEFINE CBUILDER }
{$ENDIF}
{$IFDEF VER120} { Delphi 4.0 }
  {$DEFINE LEVEL3 }
  {$DEFINE LEVEL4 }
  {$DEFINE DELPHI }
{$ENDIF}
{$IFDEF VER125} { C++Builder 4.0 }
  {$DEFINE LEVEL3 }
  {$DEFINE LEVEL4 }
  {$DEFINE CBUILDER }
{$ENDIF}
{$IFDEF VER130} { Delphi 5.0/C++Builder 5.0 }
  {$DEFINE LEVEL3 }
  {$DEFINE LEVEL4 }
  {$DEFINE LEVEL5 }
{$ENDIF}
{$IFDEF VER140} { Delphi 6.0/C++Builder 6.0 }
  {$DEFINE LEVEL3 }
  {$DEFINE LEVEL4 }
  {$DEFINE LEVEL5 }
  {$DEFINE LEVEL6 }
{$ENDIF}
{$IFDEF VER150} { Delphi 7.0/C++Builder 7.0 }
  {$DEFINE LEVEL3 }
  {$DEFINE LEVEL4 }
  {$DEFINE LEVEL5 }
  {$DEFINE LEVEL6 }
  {$DEFINE LEVEL7 }
{$ENDIF}
{$IFDEF VER160} { Delphi 8.0/C++Builder 8.0 }
  {$DEFINE LEVEL3 }
  {$DEFINE LEVEL4 }
  {$DEFINE LEVEL5 }
  {$DEFINE LEVEL6 }
  {$DEFINE LEVEL7 }
  {$DEFINE LEVEL8 }
{$ENDIF}
{$IFDEF VER170} { Delphi 9.0/C++Builder 9.0 }
  {$DEFINE LEVEL3 }
  {$DEFINE LEVEL4 }
  {$DEFINE LEVEL5 }
  {$DEFINE LEVEL6 }
  {$DEFINE LEVEL7 }
  {$DEFINE LEVEL8 }
  {$DEFINE LEVEL9 }
{$ENDIF}

{$IFDEF BCB}
  {$DEFINE CBUILDER }
{$ELSE}
  {$DEFINE DELPHI }
{$ENDIF}