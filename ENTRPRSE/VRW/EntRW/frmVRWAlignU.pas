unit frmVRWAlignU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, BorBtns;

type
  TControlAlignment = (caHorzNoChange, caHorzLeft, caHorzRight,
                       caHorzEqual, caHorzRegionCentre,
                       caVertNoChange, caVertTop, caVertBottom,
                       caVertEqual, caVertRegionCentre);
  TfrmVRWAlign = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    HorizontalGrp: TGroupBox;
    chkHorzNoChange: TBorRadio;
    chkHorzLeft: TBorRadio;
    chkHorzRight: TBorRadio;
    chkHorzEqual: TBorRadio;
    chkHorzRegionCentre: TBorRadio;
    VerticalGrp: TGroupBox;
    chkVertNoChange: TBorRadio;
    chkVertTop: TBorRadio;
    chkVertBottom: TBorRadio;
    chkVertEqual: TBorRadio;
    chkVertRegionCentre: TBorRadio;
    procedure OnCheckClick(Sender: TObject);
  private
    FVertical: TControlAlignment;
    FHorizontal: TControlAlignment;
    FIsMultiRegion: Boolean;
    FCanSpaceEqually: Boolean;
    procedure EnableRadioButton(Button: TBorRadio; Enable: Boolean);
    procedure SetHorizontal(const Value: TControlAlignment);
    procedure SetVertical(const Value: TControlAlignment);
    procedure SetCanSpaceEqually(const Value: Boolean);
    procedure SetIsMultiRegion(const Value: Boolean);
  public
    { Public declarations }
    property Horizontal: TControlAlignment read FHorizontal write SetHorizontal;
    property Vertical: TControlAlignment read FVertical write SetVertical;
    property IsMultiRegion: Boolean
      read FIsMultiRegion
      write SetIsMultiRegion;
    property CanSpaceEqually: Boolean
      read FCanSpaceEqually
      write SetCanSpaceEqually;
  end;

var
  frmVRWAlign: TfrmVRWAlign;

implementation

{$R *.dfm}

{ TfrmVRWAlign }

procedure TfrmVRWAlign.EnableRadioButton(Button: TBorRadio;
  Enable: Boolean);
begin
  Button.Enabled := Enable;
  if Enable then
    Button.Font.Color := clWindowText
  else
    Button.Font.Color := clGrayText;
end;

procedure TfrmVRWAlign.OnCheckClick(Sender: TObject);
begin
  if (Sender is TBorRadio) then
    with (Sender as TBorRadio) do
      case Tag of
         1: FHorizontal := caHorzNoChange;
         2: FHorizontal := caHorzLeft;
         3: FHorizontal := caHorzRight;
         4: FHorizontal := caHorzEqual;
         5: FHorizontal := caHorzRegionCentre;
         6: FVertical   := caVertNoChange;
         7: FVertical   := caVertTop;
         8: FVertical   := caVertBottom;
         9: FVertical   := caVertEqual;
        10: FVertical   := caVertRegionCentre;
      end;
end;

procedure TfrmVRWAlign.SetCanSpaceEqually(const Value: Boolean);
begin
  FCanSpaceEqually := Value;
  EnableRadioButton(chkHorzEqual, CanSpaceEqually);
  EnableRadioButton(chkVertEqual, CanSpaceEqually and not IsMultiRegion);
end;

procedure TfrmVRWAlign.SetHorizontal(const Value: TControlAlignment);
begin
  if (FHorizontal <> Value) then
  begin
    FHorizontal := Value;
    case Horizontal of
      caHorzNoChange:     chkHorzNoChange.Checked     := True;
      caHorzLeft:         chkHorzLeft.Checked         := True;
      caHorzRight:        chkHorzRight.Checked        := True;
      caHorzEqual:        chkHorzEqual.Checked        := True;
      caHorzRegionCentre: chkHorzRegionCentre.Checked := True;
    end;
  end;
end;

procedure TfrmVRWAlign.SetIsMultiRegion(const Value: Boolean);
begin
  FIsMultiRegion := Value;
  EnableRadioButton(chkVertTop,          not IsMultiRegion);
  EnableRadioButton(chkVertBottom,       not IsMultiRegion);
  EnableRadioButton(chkVertEqual,        CanSpaceEqually and not IsMultiRegion);
  EnableRadioButton(chkVertRegionCentre, not IsMultiRegion);
end;

procedure TfrmVRWAlign.SetVertical(const Value: TControlAlignment);
begin
  if (FVertical <> Value) then
  begin
    FVertical := Value;
    case Vertical of
      caVertNoChange:     chkVertNoChange.Checked     := True;
      caVertTop:          chkVertTop.Checked          := True;
      caVertBottom:       chkVertBottom.Checked       := True;
      caVertEqual:        chkVertEqual.Checked        := True;
      caVertRegionCentre: chkVertRegionCentre.Checked := True;
    end;
  end;
end;

end.
