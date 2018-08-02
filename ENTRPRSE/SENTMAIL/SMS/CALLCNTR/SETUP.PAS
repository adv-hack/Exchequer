unit Setup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Registry, ExtCtrls;

type
  TCallCentreInfo = class
    Number : string;
    Parity : Char;
    DataBits : integer;
    StopBits : integer;
  end;

  TfrmSetup = class(TForm)
    edComPortLogFile: TEdit;
    cmbComNo: TComboBox;
    btnOK: TButton;
    Label1: TLabel;
    cmbDataBits: TComboBox;
    Label2: TLabel;
    cmbParity: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    cmbStopBits: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    btnCancel: TButton;
    udPause: TUpDown;
    edSecsToPause: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    cmbCallCentre: TComboBox;
    Label10: TLabel;
    edTapLogFile: TEdit;
    edCallCentreNo: TEdit;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cmbCallCentreClick(Sender: TObject);
  private
    procedure SetParityField(sParity : string);
  public
    { Public declarations }
  end;

var
  frmSetup: TfrmSetup;
  
implementation
uses
  Inifiles, RegUtil;

{$R *.dfm}

procedure TfrmSetup.FormCreate(Sender: TObject);
var
  CALLCNTRINI : TIniFile;
  SMSCNTRINI : TIniFile;
  sSectionName, sParity : string;
  slSectionKeys : TStringList;
  iPos : integer;
  CallCentreInfo : TCallCentreInfo;
begin
  CALLCNTRINI := TInifile.Create(GetCOMObjectDir('EnterpriseSMS.SMSSender') + 'CALLCNTR.INI');
  with CALLCNTRINI do begin
    {read in call centre details}
    slSectionKeys := TStringList.Create;
    ReadSection('CallCentreNumbers',slSectionKeys);
    cmbCallCentre.Items.Add('(User Defined)');
    For iPos := 0 to slSectionKeys.count - 1 do begin
      sSectionName := ReadString('CallCentreNumbers',slSectionKeys[iPos],'');
      CallCentreInfo := TCallCentreInfo.Create;
      CallCentreInfo.Number := ReadString(sSectionName,'CallCentreNo','');
      CallCentreInfo.Parity := ReadString(sSectionName,'Parity','N')[1];
      CallCentreInfo.DataBits := ReadInteger(sSectionName,'NoOfDataBits',8);
      CallCentreInfo.StopBits := ReadInteger(sSectionName,'NoOfStopBits',1);
      cmbCallCentre.Items.AddObject(sSectionName, CallCentreInfo);
    end;{for}
    Free;
  end;{with}

  SMSCNTRINI := TInifile.Create(GetCOMObjectDir('EnterpriseSMS.SMSSender') + 'SMSCNTR.INI');
  with SMSCNTRINI do begin

    cmbCallCentre.ItemIndex := ReadInteger('Settings','CallCentre',0);
    cmbCallCentreClick(nil);

    edCallCentreNo.Text := ReadString('Settings','CallCentreNo','');

    cmbComNo.ItemIndex := ReadInteger('Settings','ComNo',1) - 1;
    cmbDataBits.ItemIndex := ReadInteger('Settings','NoOfDataBits',8) - 4;

    SetParityField(ReadString('Settings','Parity','N'));

    cmbStopBits.ItemIndex := ReadInteger('Settings','NoOfStopBits',1) - 1;

    udPause.Position := ReadInteger('Settings','NoOfSecsPauseBetweenDials',2);
    edComPortLogFile.Text := ReadString('Settings','ComPortLogFile','SMSPORT.LOG');
    edTapLogFile.Text := ReadString('Settings','TapLogFile','SMSTAP.LOG');
    cmbCallCentre.Text := ReadString('Settings','CallCentreNo','');
    Free;
  end;{with}
end;

procedure TfrmSetup.btnOKClick(Sender: TObject);
var
  SMSCNTRINI : TIniFile;
begin
  SMSCNTRINI := TInifile.Create(GetCOMObjectDir('EnterpriseSMS.SMSSender') + 'SMSCNTR.INI');
  with SMSCNTRINI do begin
    WriteInteger('Settings','CallCentre',cmbCallCentre.ItemIndex);
    WriteString('Settings','CallCentreNo',edCallCentreNo.Text);
    WriteInteger('Settings','ComNo',cmbComNo.ItemIndex + 1);
    WriteInteger('Settings','NoOfDataBits',cmbDataBits.ItemIndex + 4);
    WriteString('Settings','Parity',cmbParity.Items[cmbParity.ItemIndex][1]);
    WriteInteger('Settings','NoOfStopBits',cmbStopBits.ItemIndex + 1);
    WriteInteger('Settings','NoOfSecsPauseBetweenDials',udPause.Position);
    WriteString('Settings','ComPortLogFile',edComPortLogFile.Text);
    WriteString('Settings','TapLogFile',edTapLogFile.Text);
    Free;
  end;{with}
end;

procedure TfrmSetup.cmbCallCentreClick(Sender: TObject);
begin
  if cmbCallCentre.ItemIndex > 0 then begin
    with TCallCentreInfo(cmbCallCentre.Items.Objects[cmbCallCentre.ItemIndex]) do begin
      edCallCentreNo.Text := Number;
      SetParityField(Parity);
      cmbDataBits.ItemIndex := DataBits - 4;
      cmbStopBits.ItemIndex := StopBits - 1;
    end;{with}
  end;{if}

  edCallCentreNo.Enabled := cmbCallCentre.ItemIndex = 0;
  cmbDataBits.Enabled := cmbCallCentre.ItemIndex = 0;
  cmbParity.Enabled := cmbCallCentre.ItemIndex = 0;
  cmbStopBits.Enabled := cmbCallCentre.ItemIndex = 0;
end;

procedure TfrmSetup.SetParityField(sParity : string);
begin
  if length(sParity) > 0 then
    begin
      case sParity[1] of
        'E' : cmbParity.ItemIndex := 0;
        'M' : cmbParity.ItemIndex := 1;
        'N' : cmbParity.ItemIndex := 2;
        'O' : cmbParity.ItemIndex := 3;
        'S' : cmbParity.ItemIndex := 4;
      end;{Case}
    end
  else cmbParity.ItemIndex := 2;
end;


end.
