unit EntSettings;

interface

uses
  Graphics;

const
  EXE_NAME_LENGTH    = 20;
  USER_NAME_LENGTH   = 10;
  COMP_NAME_LENGTH   = 40;
  FONT_NAME_LENGTH   = 40;

  PARENT_REC_SIZE    = 2000;

  SettingsDir = 'Misc\';

  WindowTableName = 'WinSet';
  ParentTableName = 'ParSet';
  ColumnTableName = 'ColSet';

  WindowFileName = SettingsDir + WindowTableName + '.Dat';
  ParentFileName = SettingsDir + ParentTableName + '.Dat';
  ColumnFileName = SettingsDir + ColumnTableName + '.Dat';

  iDummyChar = 33;

  
type

  PWindowPositionRec = ^TWindowPositionRec;
  TWindowPositionRec = Record
    wpExeName     : string[EXE_NAME_LENGTH];
    wpUserName    : string[USER_NAME_LENGTH];
    wpWindowName  : string[COMP_NAME_LENGTH];
    wpLeft        : LongInt;
    wpTop         : LongInt;
    wpWidth       : LongInt;
    wpHeight      : LongInt;
    Spare         : Array[1..255] of Char;
  end;

  TStoreFontStyle = Byte;  //Bit 0 = fsBold; Bit 1 = fsUnderline; Bit 2 = fsItalic; Bit 3 = fsStrikeOut

  PParentSettingsRec = ^TParentSettingsRec;
  TParentSettingsRec = Record
    psExeName                    : string[EXE_NAME_LENGTH];
    psUserName                   : string[USER_NAME_LENGTH];
    psWindowName                 : string[COMP_NAME_LENGTH];
    psName                       : string[COMP_NAME_LENGTH];
    psBackgroundColor            : TColor;
    psFontName                   : string[FONT_NAME_LENGTH];
    psFontSize                   : LongInt;
    psFontColor                  : TColor;
    psFontStyle                  : TStoreFontStyle;
    psHeaderBackgroundColor      : TColor;
    psHeaderFontName             : string[FONT_NAME_LENGTH];
    psHeaderFontSize             : LongInt;
    psHeaderFontColor            : TColor;
    psHeaderFontStyle            : TStoreFontStyle;
    psHighlightBackgroundColor   : TColor;
    psHighlightFontColor         : TColor;
    psHighlightFontStyle         : TStoreFontStyle;
    psMultiSelectBackgroundColor : TColor;
    psMultiSelectFontColor       : TColor;
    psMultiSelectFontStyle       : TStoreFontStyle;
    Spare         : Array[1..255] of Char;
  end;

  PColumnSettingsRec = ^TColumnSettingsRec;
  TColumnSettingsRec = Record
    csExeName      : string[EXE_NAME_LENGTH];
    csUserName     : string[USER_NAME_LENGTH];
    csWindowName   : string[COMP_NAME_LENGTH];
    csParentName   : string[COMP_NAME_LENGTH];
    csColumnNo     : LongInt;
    DummyChar      : Char; //'!';
    csOrder        : LongInt;
    csLeft         : LongInt;
    csWidth        : LongInt;
    csTop          : LongInt;
    csHeight       : LongInt;
    Spare          : Array[1..255] of Char;
  end;



implementation


end.
