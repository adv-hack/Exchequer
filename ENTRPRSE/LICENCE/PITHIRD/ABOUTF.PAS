unit AboutF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, ExtCtrls, StdCtrls;

type
  TfrmPlugInAbout = class(TSetupTemplate)
    memReport: TMemo;
    lblVersion: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

Uses DetailF, SplashF, oConfig;

procedure TfrmPlugInAbout.FormCreate(Sender: TObject);
Var
  I : SmallInt;
begin
  inherited;

  // Setup form as required
  Caption := 'About ' + Application.Title;
  ExitMsg := 255;
  lblVersion.Caption := lblVersion.Caption + UtilVerNo;

  // Add report text
  With memReport, Lines Do Begin
    Add (Application.Title);
    Add ('Version ' + UtilVerNo);
    Add ('Copyright © Exchequer Software Ltd 1986-2002');
    Add ('');
    Add ('Licenced to ' + oLicence.Licencee);
    If oLicence.Expired Then
      Add ('*** Licence Expired ***')
    Else
      Add ('Licence Expires ' + FormatDateTime ('DD/MM/YYYY', oLicence.Expiry));

    Add ('');
    If (oLicence.PlugInCount > 0) Then
      For I := 0 To Pred(oLicence.PlugInCount) Do
        With oLicence.PlugIn[I] , oConfiguration.cfgPlugIns[piCode] Do Begin
          Add ('  Code: ' + Trim(piCode));
          Add ('  Name: ' + Trim(piName));
          If Expired Then
            Add ('  Expires: *** EXPIRED ***')
          Else
            Add ('  Expires: ' + FormatDateTime ('DD/MM/YYYY', piExpiry));
          Add (Format('  Stats:  Full %d,  30-Day %d,  Users %dx%d', [picSystemFullInst,
                                                                      picSystem30DayInst,
                                                                      picUserCountInst,
                                                                      picUserCountTotal]));
          Add ('');
        End { With oLicence.PlugIn[I] , oConfiguration.cfgPlugIns[piCode] }
    Else
      Add ('');
  End; { With memReport }
end;

end.
 