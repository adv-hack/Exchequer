unit FDOption;

interface

uses
  {$IFDEF Win32} Windows, {$ELSE} WinTypes, WinProcs, {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, Buttons, ExtCtrls;

type
  TPageOptionsForm = class(TForm)
    PageSizeGroupBox: TGroupBox;
    PageWidthLbl: TLabel;
    PageHeightLbl: TLabel;
    GridOptionsGroupBox: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;                                
    HorzGridSpacingEdit: TMaskEdit;
    VertGridSpacingEdit: TMaskEdit;
    SnapToGridCheckBox: TCheckBox;
    ShowGridCheckBox: TCheckBox;
    PageWidthEdit: TEdit;
    PageHeightEdit: TEdit;
    MeasurementRadioGroup: TRadioGroup;
    PageSizeComboBox: TComboBox;
    Button1: TButton;
    procedure FieldChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure MeasurementRadioGroupClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure PageSizeComboBoxChange(Sender: TObject);
  private
    { Private declarations }
    FIsMetric         : Boolean;
    FPageWidthInches  : Double;
    FPageHeightInches : Double;
    FPageSize         : Integer; {Index into ctPageSizes array}
    ofDataChanged     : Boolean;
    procedure SetIsMetric(AIsMetric : Boolean);
    procedure SetPageWidthInches(APageWidthInches : Double);
    procedure SetPageHeightInches(APageHeightInches : Double);
    procedure SetPageSize(APageSize : Integer);
    function Validate : Boolean;
      {-Returns True if all edit controls contain valid data}
  public
    { Public declarations }
    property IsMetric : Boolean read FIsMetric write SetIsMetric;
    property PageWidthInches : Double read FPageWidthInches write SetPageWidthInches;
    property PageHeightInches : Double read FPageHeightInches write SetPageHeightInches;
    property PageSize : Integer read FPageSize write SetPageSize;
  end;


implementation

uses
  FDUtils;

{$R *.DFM}

type
  TPageSizeRecord = record
    psPageDesc     : string[24];
    psWidthInches  : Double;
    psHeightInches : Double;
  end;

const
{
  ctNumPageSizes = 7;

  ctPageSizes : array[0..ctNumPageSizes-1] of TPageSizeRecord = (
    (psPageDesc : 'Letter (8.5 x 11.0 in)         '; psWidthInches : 8.50;     psHeightInches : 11.00),
    (psPageDesc : 'Legal (8.5 x 14.0 in)          '; psWidthInches : 8.50;     psHeightInches : 14.00),
    (psPageDesc : 'A4-ISO (210 x 297 mm)          '; psWidthInches : 8.2677;   psHeightInches : 11.69289),
    (psPageDesc : 'A3-ISO (297 x 420 mm)          '; psWidthInches : 11.69289; psHeightInches : 16.5354),
    (psPageDesc : 'B5-International (176 x 250 mm)'; psWidthInches : 6.92912;  psHeightInches : 9.8425),
    (psPageDesc : 'B4-Japan (257 x 364 mm)        '; psWidthInches : 10.11809; psHeightInches : 14.33068),
    (psPageDesc : 'B5-Japan (182 x 257 mm)        '; psWidthInches : 7.16534;  psHeightInches : 10.11809));
}

  ctNumPageSizes = 4;

  ctPageSizes : array[0..ctNumPageSizes-1] of TPageSizeRecord = (
    (psPageDesc : 'Letter (8.5 x 11.0 in) '; psWidthInches : 8.50;     psHeightInches : 11.00),
    (psPageDesc : 'Legal (8.5 x 14.0 in)  '; psWidthInches : 8.50;     psHeightInches : 14.00),
    (psPageDesc : 'A4-ISO (210 x 297 mm)  '; psWidthInches : 8.2677;   psHeightInches : 11.69289),
    (psPageDesc : 'B4-Japan (257 x 364 mm)'; psWidthInches : 10.11809; psHeightInches : 14.33068));

procedure TPageOptionsForm.FormCreate(Sender: TObject);
var
  I : Integer;
begin
  for I := Low(ctPageSizes) to High(ctPageSizes) do
    PageSizeComboBox.Items.Add(ctPageSizes[I].psPageDesc);
  PageSizeComboBox.ItemIndex := Low(ctPageSizes);
end;

procedure TPageOptionsForm.FormShow(Sender: TObject);
begin
  ofDataChanged := False;
end;

procedure TPageOptionsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TPageOptionsForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := not ofDataChanged or
              (MessageDlg('Are you sure you want to abandon your changes?',
                          mtConfirmation, [mbYes, mbNo], 0) = mrYes);
end;

procedure TPageOptionsForm.FieldChange(Sender: TObject);
begin
  ofDataChanged := True;
end;

procedure TPageOptionsForm.PageSizeComboBoxChange(Sender: TObject);
begin
  FieldChange(Sender);
  SetPageSize(PageSizeComboBox.ItemIndex);
end;

procedure TPageOptionsForm.SetIsMetric(AIsMetric : Boolean);
begin
  if FIsMetric <> AIsMetric then begin
    FIsMetric := AIsMetric;
    if FIsMetric then begin
      MeasurementRadioGroup.ItemIndex := 1;
      PageWidthLbl.Caption            := ' Width (Millimeters)';
      PageHeightLbl.Caption           := 'Height (Millimeters)';
    end else begin
      MeasurementRadioGroup.ItemIndex := 0;
      PageWidthLbl.Caption            := ' Width (Inches)';
      PageHeightLbl.Caption           := 'Height (Inches)';
    end;
    {Change values displayed in PageWidthEdit and PageHeightEdit to the new unit
     of measurement}
    PageSizeComboBoxChange(nil);
  end;
end;

procedure TPageOptionsForm.SetPageWidthInches(APageWidthInches : Double);
begin
  FPageWidthInches := APageWidthInches;
  if FIsMetric then
    PageWidthEdit.Text := FloatToStr(InchesToMillimeters(FPageWidthInches))
  else
    PageWidthEdit.Text := FloatToStr(FPageWidthInches);
end;

procedure TPageOptionsForm.SetPageHeightInches(APageHeightInches : Double);
begin
  FPageHeightInches := APageHeightInches;
  if FIsMetric then
    PageHeightEdit.Text := FloatToStr(InchesToMillimeters(FPageHeightInches))
  else
    PageHeightEdit.Text := FloatToStr(FPageHeightInches);
end;

procedure TPageOptionsForm.SetPageSize(APageSize : Integer);
begin
  FPageSize := APageSize;
  PageSizeComboBox.ItemIndex := FPageSize;
  SetPageWidthInches(ctPageSizes[FPageSize].psWidthInches);
  SetPageHeightInches(ctPageSizes[FPageSize].psHeightInches);
end;

function TPageOptionsForm.Validate : Boolean;
  {-Returns True if all edit controls contain valid data}

  procedure ShowError(Edit : TCustomEdit; const ErrMsg : string);
  begin
    MessageDlg(ErrMsg, mtError, [mbOK], 0);
    with Edit do begin
      SetFocus;
      SelStart  := 0;
      SelLength := 255;
    end;
  end;

var
  I : Integer;
begin
  Result := True;

  I := 0;  {Just to get rid of a spurious compiler warning}
  try
    I := StrToInt(Trim(HorzGridSpacingEdit.EditText));
  except
    on EConvertError do
      Result := False;
  end;
  if not Result or (I <= 0) then begin
    ShowError(HorzGridSpacingEdit, 'Invalid horizontal grid spacing entered.');
    Exit;
  end;

  try                                   
    I := StrToInt(Trim(VertGridSpacingEdit.EditText));
  except
    on EConvertError do
      Result := False;
  end;
  if not Result or (I <= 0) then
    ShowError(VertGridSpacingEdit, 'Invalid vertical grid spacing entered.');
end;

procedure TPageOptionsForm.OKBtnClick(Sender: TObject);

begin
  if Validate then begin
    ofDataChanged := False;
    ModalResult   := mrOK;
  end else
    ModalResult := mrNone;
end;

procedure TPageOptionsForm.MeasurementRadioGroupClick(Sender: TObject);
begin
  case MeasurementRadioGroup.ItemIndex of
    0 : SetIsMetric(False);
    1 : SetIsMetric(True);
  end;
end;

end.
