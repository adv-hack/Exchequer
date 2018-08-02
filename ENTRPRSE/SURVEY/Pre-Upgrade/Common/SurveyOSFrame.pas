unit SurveyOSFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SurveyBaseFrame, ComCtrls, IniFiles, oSurveyStore;

type
  TSurveyFrameOperatingSystems = class(TSurveyFrameBase)
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label9: TLabel;
    Label32: TLabel;
    edtWindows95: TEdit;
    udWindows95: TUpDown;
    edtWindows98: TEdit;
    udWindows98: TUpDown;
    edtWindowsME: TEdit;
    udWindowsME: TUpDown;
    edtWindowsNT: TEdit;
    udWindowsNT: TUpDown;
    edtWindows2000: TEdit;
    udWindows2000: TUpDown;
    edtWindowsXP: TEdit;
    udWindowsXP: TUpDown;
    lstNetOs: TComboBox;
    edtOtherNetOs: TEdit;
    edtWindows2003: TEdit;
    udWindows2003: TUpDown;
    edtWindowsVista: TEdit;
    udWindowsVista: TUpDown;
    Label1: TLabel;
    lstCitrixUse: TComboBox;
    lstNetOSSP: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtWindows8: TEdit;
    udWindows8: TUpDown;
    edtWindows7: TEdit;
    udWindows7: TUpDown;
    procedure lstNetOsClick(Sender: TObject);
  private
    { Private declarations }
    procedure EnableOther(MainList : TComboBox; OtherEdit : TEdit; OtherEditLabel : TLabel);
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
Procedure TSurveyFrameOperatingSystems.InitialiseFromIni(Const InitIni : TIniFile);
Var
  sList : TStringList;
  I : SmallInt;
Begin // InitialiseFromIni
  With InitIni Do
  Begin
    sList := TStringList.Create;
    Try
      ReadSectionValues('NetOS', sList);
      lstNetOS.Clear;
      If (sList.Count > 0) Then
        For I := 0 To Pred(sList.Count) Do
          lstNetOS.Items.Add (sList.Values[sList.Names[I]]);
      I := ReadInteger ('Defaults', 'NetOS', 0);
      If (I >= 0) And (I < lstNetOS.Items.Count) Then
        lstNetOS.ItemIndex := I;

      //------------------------------

      ReadSectionValues('CitrixOptions', sList);
      lstCitrixUse.Clear;
      If (sList.Count > 0) Then
      Begin
        For I := 0 To Pred(sList.Count) Do
          lstCitrixUse.Items.Add (sList.Values[sList.Names[I]]);
        lstCitrixUse.ItemIndex := 0;
      End; // If (sList.Count > 0)

      //NF: 16/01/2008
      ReadSectionValues('ServicePacks', sList);
      lstNetOSSP.Clear;
      If (sList.Count > 0) Then
      Begin
        For I := 0 To Pred(sList.Count) Do
          lstNetOSSP.Items.Add (sList.Values[sList.Names[I]]);
        lstNetOSSP.ItemIndex := -1;
      End; // If (sList.Count > 0)

    Finally
      sList.Free;
    End;
  End; // With InitIni
End; // InitialiseFromIni

//-------------------------------------------------------------------------

// Updates the from with data from the global oSurveyInfo singleton
Procedure TSurveyFrameOperatingSystems.LoadPreviousData;
Begin // LoadPreviousData
  With oSurveyInfo Do
  Begin
    udWindows95.Position := OSVersions[osWin95];
    udWindows98.Position := OSVersions[osWin98];
    udWindowsME.Position := OSVersions[osWinME];
    udWindowsNT.Position := OSVersions[osWinNT];
    udWindows2000.Position := OSVersions[osWin2000];
    udWindowsXP.Position := OSVersions[osWinXP];
    udWindows2003.Position := OSVersions[osWin2003];
    udWindowsVista.Position := OSVersions[osWinVista];
    udWindows7.Position := OSVersions[osWin7];
    udWindows8.Position := OSVersions[osWin8];

    If (Trim(NetOS) <> '') Then lstNetOS.ItemIndex := lstNetOS.Items.IndexOf(NetOS);
    edtOtherNetOS.Text := OtherNetOS;
    lstNetOsClick(Self);

    //NF: 16/01/2008
    If (Trim(NetOSSP) <> '') Then lstNetOSSP.ItemIndex := lstNetOSSP.Items.IndexOf(NetOSSP);

    If (Trim(CitrixUse) <> '') Then lstCitrixUse.ItemIndex := lstCitrixUse.Items.IndexOf(CitrixUse);
  End; // With oSurveyInfo
End; // LoadPreviousData

//-------------------------------------------------------------------------

// Updates the global oSurveyInfo singleton with data from the frame
Procedure TSurveyFrameOperatingSystems.SaveData;
Begin // SaveData
  With oSurveyInfo Do
  Begin
    OSVersions[osWin95] := udWindows95.Position;
    OSVersions[osWin98] := udWindows98.Position;
    OSVersions[osWinME] := udWindowsME.Position;
    OSVersions[osWinNT] := udWindowsNT.Position;
    OSVersions[osWin2000] := udWindows2000.Position;
    OSVersions[osWinXP] := udWindowsXP.Position;
    OSVersions[osWin2003] := udWindows2003.Position;
    OSVersions[osWinVista] := udWindowsVista.Position;
    OSVersions[osWin7] := udWindows7.Position;
    OSVersions[osWin8] := udWindows8.Position;

    NetOS := lstNetOS.Text;
    OtherNetOS := edtOtherNetOS.Text;
    NetOSSP := lstNetOSSP.Text; //NF: 16/01/2008
    CitrixUse := lstCitrixUse.Text;
  End; // With oSurveyInfo
End; // SaveData

//-------------------------------------------------------------------------

// Returns TRUE if the details are OK and we can move onto the next dialog
Function TSurveyFrameOperatingSystems.Validate : Boolean;
Begin // Validate

//  Result := True;

  //NF: 16/01/2008
  Result := (lstNetOs.ItemIndex >= 0) and (lstNetOSSP.ItemIndex >= 0) and (lstCitrixUse.ItemIndex >= 0);
  if lstNetOSSP.ItemIndex < 0 then
  begin
    MessageDlg('Server Operating System - Service Pack' + #13#13
    + 'You must select a valid value for the Service Pack of your Server OS.', mtWarning, [mbOK], 0);
  end;{if}
End; // Validate

//-------------------------------------------------------------------------

procedure TSurveyFrameOperatingSystems.EnableOther(MainList : TComboBox; OtherEdit : TEdit; OtherEditLabel : TLabel);
begin
  OtherEdit.Enabled := (UpperCase(Trim(MainList.Text)) = 'OTHER');
  If (Not OtherEdit.Enabled) Then
    OtherEdit.Text := '';
  OtherEditLabel.Enabled := OtherEdit.Enabled;
end;

//------------------------------

procedure TSurveyFrameOperatingSystems.lstNetOsClick(Sender: TObject);
begin
  EnableOther(lstNetOs, edtOtherNetOs, Label29);
end;

//--------------------------------------------------------------------------




end.

