unit Warning_BaseFrame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DataConversionWarnings, StdCtrls;

type
  TWarningBaseFrame = class(TFrame)
    lblWarningDescription: TLabel;
    lblDumpFileLink: TLabel;
    Label1: TLabel;
    lblCompany: TLabel;
    procedure lblDumpFileLinkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Constructor Create(AOwner : TComponent; Const Warning : TBaseDataConversionWarning);
  end;

implementation

{$R *.dfm}

Uses APIUtil;

//=========================================================================

Constructor TWarningBaseFrame.Create(AOwner : TComponent; Const Warning : TBaseDataConversionWarning);
Begin // Create
  Inherited Create(AOwner);
  If (Warning.DumpFileName <> '') Then
    lblDumpFileLink.Caption := Warning.DumpFileName
  Else
    lblDumpFileLink.Visible := False;
  lblCompany.Caption := Trim(Warning.DataPacket.CompanyDetails.ccCompanyCode) + '  (' + Trim(Warning.DataPacket.CompanyDetails.ccCompanyPath) + ')';
End; // Create

//-------------------------------------------------------------------------

procedure TWarningBaseFrame.lblDumpFileLinkClick(Sender: TObject);
begin
  RunFile(ExtractFilePath(Application.ExeName) + 'Logs\' + lblDumpFileLink.Caption);
end;

//-------------------------------------------------------------------------

end.
