library Dummy;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  View-Project Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the DELPHIMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using DELPHIMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  ShareMem,
  EntMenuU in 'EntMenuU.pas',
  HandlerU in 'Handleru.pas',
  CustAbsU in '\ENTRPRSE\R&D\Custabsu.pas',
  TCustAbs in '\SBSLIB\WIN\WIN32\Tcustabs.pas',
  ChainU in 'X:\ENTRPRSE\CUSTOM\EntCustm.ReallyOld\Chainu.pas',
  LabelU in 'Labelu.pas';

// Interface function called by COM Label Customisation to add info into the internal
// label customisation database
Procedure AddCustomText (Const WindowId, TextId                                   : LongInt;
                         Const Caption, FontName                                  : ShortString;
                         Const FontSize                                           : SmallInt;
                         Const FontBold, FontItalic, FontUnderline, FontStrikeOut : WordBool;
                         Const FontColorRed, FontColorGreen, FontColorBlue        : SmallInt);
Begin { AddCustomText }
End; { AddCustomText }

Exports
  AddCustomText,
  
  { CustomU.Pas - Menu Customisation }
  CustomMenus,
  CloseCustomMenus,

  { HandlerU.Pas - Customisation Hooks }
  InitCustomHandler,
  TermCustomHandler,
  ExecCustomHandler,

  { LabelU.Pas - Label Customisation }
  EntDoCustomText,
  EntGetCustomText;
end.
