
{*******************************************************}
{                                                       }
{       RichView                                        }
{       Conditionals for RichView.                      }
{       This file is included in all RichView PAS-files.}
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

{$B-}
{$H+}
{$J+}
{$T-}

{------------------------------------------------------------------------------}
{                  Determining Delphi/C++Builder version                       }

{$DEFINE RICHVIEW}

{$IFNDEF VER80}                         {       not Delphi 1.0           }
  {$IFNDEF VER90}                       {       not Delphi 2.0           }
    {$DEFINE RICHVIEWCBDEF1}            (* C++Builder 1.0+              *)
    {$IFNDEF VER93}                     {       not C++Builder 1.0       }
      {$DEFINE RICHVIEWCBDEF3}          (* C++Builder 3.0+              *)
      {$IFNDEF VER110}                  {       not C++Builder 3.0       }
        {$DEFINE RICHVIEWDEF3}          (* Delphi 3.0+, C++Builder 4.0+ *)
        {$IFNDEF VER100}                {       not Delphi 3.0           }
          {$DEFINE RICHVIEWDEF4}        (* Delphi 4.0+                  *)
          {$IFNDEF VER120}              {       not Delphi 4.0           }
            {$IFNDEF VER125}            {       not C++Builder 4.0       }
              {$DEFINE RICHVIEWDEF5}    (* Delphi 5.0+                  *)
              {$IFNDEF VER130}          {       not Delphi 5.0           }
                 {$IFNDEF VER135}       {       not C++Builder 5.0       }
                   {$DEFINE RICHVIEWDEF6}(* Delphi 6.0+                 *)
                   {$IFNDEF VER140}     {       not Delphi 6.0           }
                     {$IFNDEF VER145}   {       not C++Builder 6.0       }
                       {$DEFINE RICHVIEWDEF7}(* Delphi 7.0+             *)
                       {$IFNDEF VER150} {       not Delphi 7.0           }
                         {$DEFINE RICHVIEWDEF9}   (* Delphi 2005+            *)
                         {$DEFINE RICHVIEWDEF2005}(* Delphi 2005+            *)
                         {$IFNDEF VER170} {       not Delphi 2005     }
                           {$DEFINE RICHVIEWDEF10}   (* Delphi 2006+            *)
                           {$DEFINE RICHVIEWDEF2006} (* Delphi 2006+            *)
                           {$DEFINE RICHVIEWDEF2007} (* Delphi 2007 defines both VER180 and VER185 *)
                           {$IFNDEF VER180}  {       not Delphi 2006-2007     }
                             {$DEFINE RICHVIEWDEF2009} 
                             {$IFNDEF VER200}
                               {$DEFINE RICHVIEWDEF2010}
                                 {$IFNDEF VER210}
                                   {$DEFINE RICHVIEWDEFXE} (* Delphi XE defines VER220 *)
                                 {$ENDIF}
                             {$ENDIF}
                           {$ENDIF}
                         {$ENDIF}
                       {$ENDIF}
                     {$ENDIF}
                   {$ENDIF}
                 {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFDEF VER180}{$IFNDEF VER185}
{$UNDEF RICHVIEWDEF2007} // this is D2006, not D2007
{$ENDIF}{$ENDIF}


{$IFDEF RICHVIEWDEF7}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$ENDIF}

{------------------------------------------------------------------------------}
{ CONDITIONAL DEFINES.                                                         }
{ Do not modify this file, use Project|Options, Directories/Conditionals,      }
{ Conditional defines instead.                                                 }
{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
{ Defines for shrinking exe size / improving speed and memory usage by         }
{ turning off unused features.                                                 }
{------------------------------------------------------------------------------}

{NOT$DEFINE RVDONOTUSESTYLETEMPLATES}
{
  Define if you do not want to use TRVStyle.StyleTemplates and related functions.

{NOT$DEFINE RVDONOTUSEALLCAPS}
{NOT$DEFINE RVDONOTUSESOFTHYPHENS}
{NOT$DEFINE RVDONOTUSECHARSCALE}
{
   Define it if you do not wish to use rvfsAllCaps option, soft hyphens,
   CharScale.
   Some speed up of text drawing and formatting.
}

{NOT$DEFINE RVDONOTUSESMARTPOPUP}


{NOT$DEFINE RVDONOTUSEANIMATION}
{
  Define if you do not wish to display animations.
  Saves memory and resources.
}

{NOT$DEFINE RVDONOTUSETABS}
{
  Define if you do not wish to use tab stops. All code for importing tabs will
  be excluded. But code for processing tabs (if they appeared in document) remains.
}

{NOT$DEFINE RVDONOTUSEJPEGIMAGE}
{
   Define it if you do not wish to use Delphi jpeg units.
   This will cause saving images to HTML as bitmaps, and turning off special
   support for jpegs in paletted display mode.
}

{NOT$DEFINE RVDONOTUSEHTML}
{
   Define it to remove all HTML-related methods.
}

{NOT$DEFINE RVDONOTUSERTF}
{
   Define it to remove all RTF-export related methods
}

{NOT$DEFINE RVDONOTUSERTFIMPORT}
{
   Define it to remove all RTF-import related methods.
}

{NOT$DEFINE RVDONOTUSERVF}
{
   Define it to remove all RVF-related methods.
   You can do it only if you do not use TRichViewEdit. Editor requires
   RVF methods.
}


{NOT$DEFINE RVDONOTUSEUNICODE}
{
   Define it to disable Unicode support.
   Cannot be activated in Delphi/C++Builder 2009+
}
{NOT$DEFINE RVDONOTUSECHARSPACING}
{
  Define it to disable CharSpacing. Somewhat faster
}

{NOT$DEFINE RVDONOTUSETABLES}
{
  Define, if you do not use tables. Exe-file will be smaller.
}

{NOT$DEFINE RVDONOTUSELISTS}
{
  Define, if you do not use bullets and numbering
}

{NOT$DEFINE RVDONOTUSESEQ}
{
  Define, if you do not use numbered sequences and footnotes
}

{NOT$DEFINE RVDONOTUSEINI}
{
  Define, if you do not save/load RVStyle in ini-files and the Registry
}

{NOT$DEFINE RVDONOTUSEDRAGDROP}
{
  Define, if you do not use OLE drag&drop
}

{NOT$DEFINE RVDONOTUSEITEMHINTS}
{
  Define, if you do not want to use item titles (popup hints).
  Saves 4 bytes per item in memory
}

{NOT$DEFINE RVDONOTUSELIVESPELL}
{
  Define, if you do not want to use live spelling.
  Saves 8 bytes per item in memory, reduces exe file size
}

{NOT$DEFINE RVDONOTUSELINEARPOSITIONS}
{
  Define, if you do not need to process EM_GETSEL, EM_GETTEXTRANGE and EM_SETSEL
}

{NOT$DEFINE RVDONOTUSERVMEMORYSTREAM}
{
  Disables custom (more efficient for saving large data) memory stream
  implementation. Reduces exe file size
}

{NOT$DEFINE RVDONOTUSEDOCPARAMS}
{
  Define to exclude TCustomRichView.DocParameters
}

{NOT$DEFINE RVDONOTUSEOLECONTAINER}
{
  Does nothing. Reserved.
}

{$IFDEF RVDONOTUSETABLES}
  {$DEFINE RVDONOTUSEINPLACE}
{$ENDIF}
{------------------------------------------------------------------------------}
{ Other defines                                                                }
{------------------------------------------------------------------------------}
{NOT$DEFINE RVPBEARCOMPAT}
{
  Define to make HTML output more compatible with THTMLViewer (www.pbear.com)
  Some unnecessary tags will be saved.
}

{NOT$DEFINE RVFPICTURENEEDED2}
{
  Define to add OnRVFPictureNeeded2. It is the same as OnRVFPictureNeeded,
  but called for pictures that stored in RVF, before they are loaded.
  You can provide your own picture instead of the picture stored in RVF
}

{NOT$IFDEF RVDRAWPARAMARKSBEFORE}
{
  Activate to draw paragraph marks (in show-special-characters mode) not
  only at the end of paragraphs, but also before them.
}


{NOT$DEFINE RVEDITIGNORESESCAPE}
{
  If defined, TRichViewEdit and TDBRichViewEdit (if IgnoreEscape=True) controls
  do not receive messages when Escape is pressed. Useful when placed in modal
  dialogs, so that editors do not steal Escape from a Cancel button.
}


{NOT$DEFINE RVLANGUAGEPROPERTY}
{
  If defined, text style has additional property - Language: Cardinal
}
{NOT$DEFINE RVLIVESPELLEXEVENT}
{
  If defined, RichView has additional event - OnSpellingCheckEx.
  This event has higher priority than OnSpellingCheck.
}

{NOT$DEFINE RVUSETEXTHOVERCOLORWITHSELECTED}
{
  Define if you wish to return behavior of v1.2-, where text hover color was
  used even for selected text.
}

{NOT$DEFINE DONOTDECVSCROLLUNITS}
{
  Define to forbid RichView to decrease vertical scrolling units automatically
  when needed (if you wish to control scrolling units yourself).
}

{NOT$DEFINE RVDONOTCORRECTWMFSCALE}
{
  There is a problem in Delphi TMetafile class (wrong size) when pasting
  some metafiles from Clipboard. RichView tries to correct it.
  Turn this define on, if you have troubles with metafile sizes when pasting.
}

{$DEFINE RVALLOWCPBYCP}
{
  RichView since version 1.0 does not allow to add one checkpoint just after
  another.
  When defined (default), second checkpoint is ignored.
  When not defined, RichView raises exception.
}

{NOT$DEFINE RVRECHECKRTFPARA}
{
  If defined, when importing RTF file, paragraph properties are rechecked
  when inserting each item (otherwise, only when inserting the first paragraph's
  item). Slows reading down, but provides the same results as MS Word when
  RTF file contains contradicting data for the same paragraph (buggy RTF files)
}


{------------------------------------------------------------------------------}
{ Addons                                                                       }
{------------------------------------------------------------------------------}

{
  Define if you use import of MS Word DOC files.
}
{NOT$DEFINE RVUSEWORDDOC}

{------------------------------------------------------------------------------}
{ Automatical defines:                                                         }
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF1}
{
 IME (Input Method Editor) support is disabled for Delphi 2.
 D2 has required library file - Imm.pas in sources, but does not have it in library (?!).
 So I think support for D2 is possible, but requires some IDE configuration...

}

{$IFNDEF RVDONOTUSEUNICODE}

{$DEFINE RVUSEIME} // Using IME

{$ENDIF}
{$ENDIF}

{$IFNDEF RICHVIEWDEF3}
// Turning off Jpeg support for Delphi2, C++Builder 1,3
{$DEFINE RVDONOTUSEJPEGIMAGE}

{$ENDIF}

{$IFNDEF RICHVIEWCBDEF3}
// Turning off D&D support for Delphi2, C++Builder 1
{$DEFINE RVDONOTUSEDRAGDROP}
{$ENDIF}

{$IFNDEF RVDONOTUSELISTS}
  {$DEFINE RVUSELISTORSEQ}
{$ELSE}
  {$IFNDEF RVDONOTUSESEQ}
    {$DEFINE RVUSELISTORSEQ}
  {$ENDIF}
{$ENDIF}

{$IFDEF RICHVIEWDEF2009}
  {$DEFINE RVUNICODESTR}
  {$DEFINE RVUNICODEWINDOW}
{$ENDIF}

{.$DEFINE RVDEBUG}

{.$DEFINE RVFLATSCROLLBARS}

{.$DEFINE RVONCUT}

{.$DEFINE RVWATERMARK}

{.$DEFINE RVUSEBASELINE}