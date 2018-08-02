unit SurveyBaseFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles, oSurveyStore;

type
  TSurveyFrameBase = class(TFrame)
  private
    { Private declarations }
  public
    { Public declarations }
    // Loads the pre-defined information from ExSurvey.Dat
    Procedure InitialiseFromIni(Const InitIni : TIniFile); Virtual; Abstract;
    // Updates the from with data from the global oSurveyInfo singleton
    Procedure LoadPreviousData; Virtual; Abstract;
    // Updates the global oSurveyInfo singleton with data from the frame
    Procedure SaveData; Virtual; Abstract;
    // Returns TRUE if the details are OK and we can move onto the next dialog
    Function Validate : Boolean; Virtual; Abstract;
  end;

implementation

{$R *.dfm}

end.
