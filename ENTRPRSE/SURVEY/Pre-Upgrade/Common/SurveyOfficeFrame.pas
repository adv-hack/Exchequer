unit SurveyOfficeFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SurveyBaseFrame, StdCtrls, ComCtrls, IniFiles, oSurveyStore;

type
  TSurveyFrameOfficeVersions = class(TSurveyFrameBase)
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label9: TLabel;
    edtOffice95: TEdit;
    udOffice95: TUpDown;
    edtOffice97: TEdit;
    udOffice97: TUpDown;
    edtOffice2000: TEdit;
    udOffice2000: TUpDown;
    edtOfficeXP: TEdit;
    udOfficeXP: TUpDown;
    edtOffice2003: TEdit;
    udOffice2003: TUpDown;
    edtOffice2007: TEdit;
    udOffice2007: TUpDown;
    Label1: TLabel;
    Label2: TLabel;
    edtOffice2010: TEdit;
    udOffice2010: TUpDown;
    edtOffice2013: TEdit;
    udOffice2013: TUpDown;
  private
    { Private declarations }
  public
    // Loads the pre-defined information from ExSurvey.Dat
    Procedure InitialiseFromIni(Const InitIni : TIniFile); Override;
    // Updates the from with data from the global oSurveyInfo singleton
    Procedure LoadPreviousData; Override;
    // Updates the global oSurveyInfo singleton with data from the frame
    Procedure SaveData; Override;
    // Returns TRUE if the details are OK and we can move onto the next dialog
    Function Validate : Boolean; Override;
  end;

implementation

{$R *.dfm}

//=========================================================================

// Loads the pre-defined information from ExSurvey.Dat
Procedure TSurveyFrameOfficeVersions.InitialiseFromIni(Const InitIni : TIniFile);
Begin // InitialiseFromIni
  With InitIni Do
  Begin
    // N/A
  End; // With InitIni
End; // InitialiseFromIni

//-------------------------------------------------------------------------

// Updates the from with data from the global oSurveyInfo singleton
Procedure TSurveyFrameOfficeVersions.LoadPreviousData;
Begin // LoadPreviousData
  With oSurveyInfo Do
  Begin
    udOffice95.Position := OfficeVersions[msOffice95];
    udOffice97.Position := OfficeVersions[msOffice97];
    udOffice2000.Position := OfficeVersions[msOffice2000];
    udOfficeXP.Position := OfficeVersions[msOfficeXP];
    udOffice2003.Position := OfficeVersions[msOffice2003];
    udOffice2007.Position := OfficeVersions[msOffice2007];
    udOffice2010.Position := OfficeVersions[msOffice2010];
    udOffice2013.Position := OfficeVersions[msOffice2013];
  End; // With oSurveyInfo
End; // LoadPreviousData

//-------------------------------------------------------------------------

// Updates the global oSurveyInfo singleton with data from the frame
Procedure TSurveyFrameOfficeVersions.SaveData;
Begin // SaveData
  With oSurveyInfo Do
  Begin
    OfficeVersions[msOffice95] := udOffice95.Position;
    OfficeVersions[msOffice97] := udOffice97.Position;
    OfficeVersions[msOffice2000] := udOffice2000.Position;
    OfficeVersions[msOfficeXP] := udOfficeXP.Position;
    OfficeVersions[msOffice2003] := udOffice2003.Position;
    OfficeVersions[msOffice2007] := udOffice2007.Position;
    OfficeVersions[msOffice2010] := udOffice2010.Position;
    OfficeVersions[msOffice2013] := udOffice2013.Position;
  End; // With oSurveyInfo
End; // SaveData

//-------------------------------------------------------------------------

// Returns TRUE if the details are OK and we can move onto the next dialog
Function TSurveyFrameOfficeVersions.Validate : Boolean;
Begin // Validate
  Result := True;
End; // Validate

//-------------------------------------------------------------------------



end.

