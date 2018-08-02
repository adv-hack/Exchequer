unit SysSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, BTUtil, BTConst, BTFile, PPayProc, Menus, uSettings
  , APIUtil;

type
  TfrmSystemSetup = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    cmbDaysField: TComboBox;
    cmbHoldFlagField: TComboBox;
    btnCancel: TButton;
    btnOK: TButton;
    pmMain: TPopupMenu;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    cbBaseInterestOnDueDate: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    bRestore : boolean;
    procedure LoadAllSettings;
    procedure SaveAllSettings;
  public
    { Public declarations }
  end;

var
  frmSystemSetup: TfrmSystemSetup;

implementation

{$R *.dfm}

procedure TfrmSystemSetup.btnOKClick(Sender: TObject);
var
  PPSetupRec : TPPSetupRec;
  iStatus : integer;
  KeyS : TStr255;
begin
  if cmbDaysField.ItemIndex = cmbHoldFlagField.ItemIndex then begin
    MsgBox('You cannot set both the fields to the same user defined field.',mtError,[mbOK],mbOK,'System Setup Error');
    exit;
  end;{if}

  // Find Setup Record
  KeyS := BTFullNomKey(1) + IDX_DUMMY_CHAR;
  iStatus := BTFindRecord(BT_GetEqual, ppFileVar[ppSetupF], PPSetupRec, ppBufferSize[ppSetupF]
  , ppsFolioNoIdx, KeyS);
  case iStatus of
    0 : begin // Edit existing record
      PPSetupRec.ppsDaysField := cmbDaysField.ItemIndex + 1;
      PPSetupRec.ppsHoldFlagField := cmbHoldFlagField.ItemIndex + 1;
      PPSetupRec.ppsBaseInterestOnDueDate := cbBaseInterestOnDueDate.Checked;

      iStatus := BTUpdateRecord(ppFileVar[ppSetupF], PPSetupRec, ppBufferSize[ppSetupF]
      , ppsFolioNoIdx, KeyS);
      BTShowError(iStatus, 'BTUpdateRecord', CompanyRec.Path + ppFileName[ppSetupF]);
      ModalResult := mrOK;
    end;

    4, 9 : begin // Create New record
      FillChar(PPSetupRec, SizeOf(PPSetupRec), #0);
      PPSetupRec.ppsFolioNo := 1;
      PPSetupRec.ppsDummyChar := IDX_DUMMY_CHAR;;
      PPSetupRec.ppsDaysField := cmbDaysField.ItemIndex + 1;
      PPSetupRec.ppsHoldFlagField := cmbHoldFlagField.ItemIndex + 1;
      BTShowError(BTAddRecord(ppFileVar[ppSetupF], PPSetupRec, ppBufferSize[ppSetupF]
      , ppsFolioNoIdx), 'BTAddRecord', CompanyRec.Path + ppFileName[ppSetupF]);
      ModalResult := mrOK;
    end;

    else begin // error
      BTShowError(iStatus, 'BTFindRecord', CompanyRec.Path + ppFileName[ppSetupF]);
    end;
  end;{case}
end;

procedure TfrmSystemSetup.FormCreate(Sender: TObject);
var
  PPSetupRec : TPPSetupRec;
  iStatus : integer;
  KeyS : TStr255;
begin
  bRestore := FALSE;
  LoadAllSettings;

  // Find Setup Record
  KeyS := BTFullNomKey(1) + IDX_DUMMY_CHAR;
  iStatus := BTFindRecord(BT_GetEqual, ppFileVar[ppSetupF], PPSetupRec, ppBufferSize[ppSetupF]
  , ppsFolioNoIdx, KeyS);
  case iStatus of
    0 : begin // read existing record
      cmbDaysField.ItemIndex := PPSetupRec.ppsDaysField - 1;
      cmbHoldFlagField.ItemIndex := PPSetupRec.ppsHoldFlagField - 1;
      cbBaseInterestOnDueDate.Checked := PPSetupRec.ppsBaseInterestOnDueDate;
    end;

    4, 9 : begin
      // Default to screen layout
    end;

    else begin // Error
      BTShowError(iStatus, 'BTFindRecord', CompanyRec.Path + ppFileName[ppSetupF]);
    end;
  end;{case}
end;

procedure TfrmSystemSetup.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadParentToControl(Self.Name, Self.Name, cmbDaysField);
  oSettings.ColorFieldsFrom(cmbDaysField, Self);
end;

procedure TfrmSystemSetup.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(nil, Self.Name, cmbDaysField) of
    mrOK : oSettings.ColorFieldsFrom(cmbDaysField, Self);
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmSystemSetup.SaveAllSettings;
begin
  oSettings.SaveParentFromControl(cmbDaysField, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;

procedure TfrmSystemSetup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
end;

end.
