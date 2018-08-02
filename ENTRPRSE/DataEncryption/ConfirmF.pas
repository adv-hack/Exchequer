unit ConfirmF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, EnterToTab, rtflabel;

const
  S_REQUESTED = '{\rtf1\ansi You have requested encryption of \b ''%s''\b0  %s.\par}';
  S_EXCLUSIVE = '{\rtf1\ansi No-one can use %s whilst the file is being ' +
                'encrypted and the process cannot be stopped once it has started. If the \par}';

  S_ESTIMATE  = 'We estimate that it will take %s to complete, but that ' +
                'does not take into account any local conditions that could affect performance.';
  S_PROCEED   = '{\rtf1\ansi Do you want to proceed with the encryption of \b ''%s''\b0  %s?\par}';
  S_SYSTEM    = 'the system';


type
  TfrmConfirmation = class(TForm)
    lblEstimate: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    chkDamaged: TCheckBox;
    chkExclusive: TCheckBox;
    chkBackup: TCheckBox;
    chkNoEstimate: TCheckBox;
    btnYes: TButton;
    btnNo: TButton;
    EnterToTab1: TEnterToTab;
    lblRequested: TRTFLabel;
    lblProceed: TRTFLabel;
    lblExclusive: TRTFLabel;
    Label1: TLabel;
    procedure chkNoEstimateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetInfo(const Company : string;
                      const Filename : string;
                      const Estimate : string);
  end;

var
  frmConfirmation: TfrmConfirmation;

implementation

uses
  StrUtils;

{$R *.dfm}

procedure TfrmConfirmation.chkNoEstimateClick(Sender: TObject);
begin
  btnYes.Enabled := chkBackup.Checked and chkDamaged.Checked and
                    chkExclusive.Checked and chkNoEstimate.Checked;
end;

procedure TfrmConfirmation.SetInfo(const Company, Filename,
  Estimate: string);
var
  GlobalFile : Boolean;
  CompanyString : string;
  EscapedFilename : string;
begin
  EscapedFilename := AnsiReplaceStr(Filename, '\', '\\');
  //Go round the houses to keep messages sensible despite having company files and global files.
  GlobalFile := Company = S_SYSTEM;
  lblRequested.RichText := Format(S_REQUESTED, [EscapedFilename, IfThen(GlobalFile, '', 'in company \b ''' + Company + '''\b0')]);
  lblExclusive.RichText := Format(S_EXCLUSIVE, [IfThen(GlobalFile, Company, 'company \b ''' + Copy(Company, 1, 6) + '''\b0 ')]);
  lblExclusive.WordWrap := True;
  lblEstimate.Caption  := Format(S_ESTIMATE,  [Estimate]);
  lblProceed.RichText   := Format(S_PROCEED,   [EscapedFilename, IfThen(GlobalFile, '', 'in company \b ''' + Company + '''\b0 ')]);

end;

procedure TfrmConfirmation.FormCreate(Sender: TObject);
begin
  ActiveControl := btnNo;
end;

end.
