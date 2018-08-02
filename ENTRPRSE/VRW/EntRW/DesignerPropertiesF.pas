unit DesignerPropertiesF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BorBtns, StdCtrls, TCustom, TEditVal, DesignerTypes, ComCtrls,
  Mask;

type
  TfrmDesignerProperties = class(TForm)
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    btnApply: TSBSButton;
    GroupBox1: TGroupBox;
    chkShowGrid: TBorCheckEx;
    Label81: Label8;
    edtYMM: Text8Pt;
    udYMM: TSBSUpDown;
    Label82: Label8;
    edtXMM: Text8Pt;
    udXMM: TSBSUpDown;
    procedure btnApplyClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FRegionManager : IRegionManager;
    OrigGrid : Boolean;
    OrigYmm : Byte;
    OrigXmm : Byte;
    Procedure SetRegionManager(Value : IRegionManager);
  public
    { Public declarations }
    Property RegionManager : IRegionManager Read FRegionManager Write SetRegionManager;
  end;


// Displays the Designer Properties dialog
Procedure DisplayDesignerProperties (Const DesignerForm : TForm; Const RegionManager : IRegionManager);


implementation

{$R *.dfm}

//=========================================================================

Procedure DisplayDesignerProperties (Const DesignerForm : TForm; Const RegionManager : IRegionManager);
var
  frmDesignerProperties: TfrmDesignerProperties;
Begin // DisplayDesignerProperties
  frmDesignerProperties := TfrmDesignerProperties.Create(DesignerForm);
  Try
    frmDesignerProperties.RegionManager := RegionManager;
    frmDesignerProperties.ShowModal;
  Finally
    FreeAndNIL(frmDesignerProperties);
  End; // Try..Finally
End; // DisplayDesignerProperties

//=========================================================================

Procedure TfrmDesignerProperties.SetRegionManager(Value : IRegionManager);
Begin // SetRegionManager
  FRegionManager := Value;
  If Assigned(FRegionManager) Then
  Begin
    chkShowGrid.Checked := FRegionManager.rmShowGrid;
    udYMM.Position := FRegionManager.rmGridSizeYmm;
    udXMM.Position := FRegionManager.rmGridSizeXmm;

    OrigGrid := FRegionManager.rmShowGrid;
    OrigYmm := FRegionManager.rmGridSizeYmm;
    OrigXmm := FRegionManager.rmGridSizeXmm;
  End; // If Assigned(FRegionManager)
End; // SetRegionManager

//-------------------------------------------------------------------------

procedure TfrmDesignerProperties.btnApplyClick(Sender: TObject);
begin
  FRegionManager.rmShowGrid := chkShowGrid.Checked;
  FRegionManager.rmGridSizeYmm := udYMM.Position;
  FRegionManager.rmGridSizeXmm := udXMM.Position;
end;

//-------------------------------------------------------------------------

procedure TfrmDesignerProperties.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  If (ModalResult = mrOK) Then
  Begin
    // Update the grid settings
    FRegionManager.rmShowGrid := chkShowGrid.Checked;
    FRegionManager.rmGridSizeYmm := udYMM.Position;
    FRegionManager.rmGridSizeXmm := udXMM.Position;
  End // If (ModalResult = mrOK)
  Else
  Begin
    // Restore original settings
    FRegionManager.rmShowGrid := OrigGrid;
    FRegionManager.rmGridSizeYmm := OrigYmm;
    FRegionManager.rmGridSizeXmm := OrigXmm;
  End; // Else
end;

//-------------------------------------------------------------------------

end.
