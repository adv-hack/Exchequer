{***************************************************************************}
{                                                                           }
{  Gnostice RaveRender                                                      }
{                                                                           }
{  Copyright © 2000-2003 Gnostice Information Technologies Private Limited  }
{  http://www.gnostice.com                                                  }
{                                                                           }
{***************************************************************************}

{---- ZLib Compression Support ------------------------------------------------}
{     Remove dot(.) below to include the ZLib compression library and enable   }
{     text compression. The ZLib compression library does not install          }
{     automatically with Delphi/C++Builder. It has to be manually installed.   }
{     The library ships on the Delphi CD from version 5 onwards and you should }
{     find it under \Info\Extras\Zlib.                                         }
{     To install:                                                              }
{       Copy the whole Zlib sub-tree to your hard-disk and include             }
{       both ...Zlib and ...Zlib\Obj under                                     }
{       Tools|Environment Options|Library path                                 }
{     If the library is not present on your CD you could download one of       }
{     several available from http://www.torry.ru                               }

{.$DEFINE ZLib}

{------------------------------------------------------------------------------}

{---- GIF Support -------------------------------------------------------------}
{     Remove ONE of the dots(.) below to get built-in support for GIF images   }
{     Make sure you have the appropriate units installed first                 }

{---- GIF using RxGIF unit (http://www.rxlib.com)}
{.$DEFINE GIFByRx}

{---- GIF using Anders Melander's GIF unit (http://www.melander.dk)}
{.$DEFINE GIFByAM}

{------------------------------------------------------------------------------}

{---- Report Emailing Support -------------------------------------------------}
{     Remove ONE of the dots(.) below to get built-in support for              }
{     FastNet or Indy Units.                                                   }
{     Make sure you have the appropriate units installed first                 }

{---- Email using FastNet units}
{.$DEFINE EmailWithFastNet}

{---- Email using Indy units}
{.$DEFINE EmailWithIndy}

{---- Indy Version Support ----------------------------------------------------}
{     Remove dot(.) before $DEFINE below to configure gtRaveRender to          }
{     support Indy versions above 9.00. By Default gtRaveRender                }
{     is configured to work with Indy Version below 9.00.                      }

{.$DEFINE Indy900Up}

{------------------------------------------------------------------------------}

{---- Image resampling support ------------------------------------------------}
{     Remove dot(.) to enable gtRaveRender to use the resampling functions     }
{     written by Anders Melander (http://www.melander.dk)                      }
{     When images need to be Stretch Drawn, these routines are used            }
{     instead of the StretchDraw method of TCanvas. Helps stretched images     }
{     retain their original quality better than when done with StretchDraw     }
{     NOTE: If you are using an older version of resample.pas...               }
{           Open the file                                                      }
{           Look for '$IFDEF VER100'                                           }
{           Comment or delete the $IFDEF and the $ENDIF associated with it     }

{---- Rave Version Support ----------------------------------------------------}
{     Add dot(.) before $DEFINE below to configure gtRaveRender to             }
{     support Rave versions below 4.07. By Default gtRaveRender                }
{     is configured to work with Rave Version 4.07 and above.                  }

{.$DEFINE Rave407Up}


{.$DEFINE Rave50Up}
{------------------------------------------------------------------------------}

{.$DEFINE AMResample}

{------------------------------------------------------------------------------}

{---- Silent Mode -------------------------------------------------------------}
{     Remove dot(.) to render in silent mode. When SilentMode is enabled       }
{     all dialogs are switched off by default.                                 }

{.$DEFINE SilentMode}

{------------------------------------------------------------------------------}

{---- Nothing to change below -------------------------------------------------}


{$IFDEF GIFByRx}
	{$DEFINE GIFSupport}
{$ENDIF}
{$IFDEF GIFByAM}
	{$DEFINE GIFSupport}
{$ENDIF}

{$IFDEF EmailWithIndy}
	{$UNDEF EmailWithFastNet}
{$ENDIF}

{$IFDEF Rave50Up}
	{$DEFINE Rave407Up}
{$ENDIF}

{------------------------------------------------------------------------------}
{------------------------------------------------------------------------------}

