unit Stklocldf;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, Enterprise_TLB, StkLocLF;

type
  TfrmStkLocDetl = class(TForm)
    GroupBox1: TGroupBox;
    Label827: TLabel;
    Label831: TLabel;
    Label836: TLabel;
    Label835: TLabel;
    Label837: TLabel;
    Label838: TLabel;
    Label834: TLabel;
    Label86: TLabel;
    SRMIF: TEdit;
    SRMXF: TEdit;
    SRISF: TEdit;
    SRPOF: TEdit;
    SRALF: TEdit;
    SRFRF: TEdit;
    SROOF: TEdit;
    SRPCK: TEdit;
    GroupBox2: TGroupBox;
    Label828: TLabel;
    Label829: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    WIPLab: TLabel;
    Label88: TLabel;
    Label810: TLabel;
    CCLab: TLabel;
    Label85: TLabel;
    LabCur2: TLabel;
    Label3: TLabel;
    LabMg: TLabel;
    SRCPCF: TComboBox;
    SRCPF: TEdit;
    SRRPF: TEdit;
    SRRPCF: TComboBox;
    SalGL: TEdit;
    COSGL: TEdit;
    WOGL: TEdit;
    SVGL: TEdit;
    WIPGL: TEdit;
    SRFSF: TEdit;
    SRBLF: TEdit;
    SRCCF: TEdit;
    SRDepF: TEdit;
    SRSBox2: TScrollBox;
    Label818: TLabel;
    Label819: TLabel;
    Label820: TLabel;
    Label821: TLabel;
    Label822: TLabel;
    Label823: TLabel;
    Label824: TLabel;
    Label825: TLabel;
    SRSP1F: TEdit;
    SRSP2F: TEdit;
    SRSP3F: TEdit;
    SRSP4F: TEdit;
    SRSP5F: TEdit;
    SRSP6F: TEdit;
    SRSP7F: TEdit;
    SRSP8F: TEdit;
    SRSPC1F: TComboBox;
    SRSPC2F: TComboBox;
    SRSPC3F: TComboBox;
    SRSPC4F: TComboBox;
    SRSPC5F: TComboBox;
    SRSPC6F: TComboBox;
    SRSPC8F: TComboBox;
    SRGP1: TEdit;
    SRGP2: TEdit;
    SRGP3: TEdit;
    SRGP4: TEdit;
    SRGP5: TEdit;
    SRGP6: TEdit;
    SRGP7: TEdit;
    SRGP8: TEdit;
    SRSPC7F: TComboBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

{----------------------------------------}

procedure TfrmStkLocDetl.FormCreate(Sender: TObject);
begin
  //
end;

{----------------------------------------}

end.
