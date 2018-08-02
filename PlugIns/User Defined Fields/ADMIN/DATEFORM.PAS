unit DateForm;

{ nfrewer440 09:40 03/09/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, StrUtil, Menus, uSettingsSQL;

type
  TfrmDateFormat = class(TForm)
    cmbFormat: TComboBox;
    Label1: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    cmbSeparator: TComboBox;
    Button1: TButton;
    Button2: TButton;
    pmMain: TPopupMenu;
    Properties2: TMenuItem;
    SaveCoordinates2: TMenuItem;
    procedure cmbSeparatorChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Properties2Click(Sender: TObject);
  private
    { Private declarations }
    cCurrentSeparator : char;
    bRestore : boolean;
    function GetSeparatorChar(iIndex : integer) : char;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
  public
    procedure SetCombos(sFormat : string);
  end;

var
  frmDateFormat: TfrmDateFormat;

implementation

{$R *.dfm}

procedure TfrmDateFormat.cmbSeparatorChange(Sender: TObject);
var
  iPrevItemIndex, iPos : integer;
  sLine : string;
  cNewSeparator : char;

  procedure InsertSeparator(var sFormat : string; cSeparator : char);
  var
    sNewString : string;
    cPrev : char;
    iPos : integer;
  begin{InsertSeparator}
    if cSeparator = #0 then exit;
    cPrev := sFormat[1];
    For iPos := 1 to length(sFormat) do begin
      if sFormat[iPos] = cPrev then sNewString := sNewString + sFormat[iPos]
      else sNewString := sNewString + cSeparator + sFormat[iPos];
      cPrev := sFormat[iPos];
    end;{for}
    sFormat := sNewString;
  end;{InsertSeparator}

begin
  cNewSeparator := GetSeparatorChar(cmbSeparator.itemindex);
  iPrevItemIndex := cmbFormat.ItemIndex;
  For iPos := 0 to cmbFormat.Items.Count - 1 do begin
    sLine := cmbFormat.items[iPos];
    if cCurrentSeparator <> #0 then sLine := RemoveAllChars(sLine,cCurrentSeparator);
    InsertSeparator(sLine, cNewSeparator);
    cmbFormat.items[iPos] := sLine;
  end;{for}
  cmbFormat.ItemIndex := iPrevItemIndex;
  cCurrentSeparator := cNewSeparator;
end;

procedure TfrmDateFormat.FormCreate(Sender: TObject);
begin
  bRestore := FALSE;
  LoadAllSettings;
  cCurrentSeparator := GetSeparatorChar(cmbSeparator.itemindex);
end;

function TfrmDateFormat.GetSeparatorChar(iIndex : integer) : char;
begin
  case cmbSeparator.itemindex of
    0,1,2 : Result := cmbSeparator.Items[cmbSeparator.itemindex][1];
    3 : Result := #0;
  end;{case}
end;

procedure TfrmDateFormat.SetCombos(sFormat : string);
var
  iPos : integer;
  sSeparator : string;
begin
  sSeparator := '(none)';
  For iPos := 1 to length(sFormat) do begin
    if not (sFormat[iPos] in ['d','m','y']) then sSeparator := sFormat[iPos];
  end;{for}

  cmbSeparator.ItemIndex := cmbSeparator.Items.IndexOf(sSeparator);
  cmbSeparatorChange(cmbSeparator);
  cmbFormat.ItemIndex := cmbFormat.Items.IndexOf(sFormat);
end;

procedure TfrmDateFormat.SaveAllSettings;
begin
  oSettings.SaveParentFromControl(cmbSeparator, Self.Name);
  if SaveCoordinates2.Checked then oSettings.SaveForm(Self);
end;

procedure TfrmDateFormat.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadParentToControl(Self.Name, Self.Name, cmbSeparator);
  oSettings.ColorFieldsFrom(cmbSeparator, Self);
end;

procedure TfrmDateFormat.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
end;

procedure TfrmDateFormat.Properties2Click(Sender: TObject);
begin
  case oSettings.Edit(nil, Self.Name, cmbSeparator) of
    mrOK : oSettings.ColorFieldsFrom(cmbSeparator, Self);
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

end.
