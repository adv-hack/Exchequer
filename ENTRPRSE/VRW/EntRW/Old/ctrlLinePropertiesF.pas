unit ctrlLinePropertiesF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, TEditVal, EnterToTab,
  VRWReportIF,
  DesignerTypes,    // Common designer types and interfaces
  ctrlLine, ExtCtrls
  ;

type
  TLinePropertiesMode = (lpmAdd, lpmEdit);

  TfrmLineProperties = class(TForm)
    lblColor: TLabel;
    edtLineStyle: TLabeledEdit;
    edtLineWidth: TLabeledEdit;
    cbColor: TColorBox;
    btnOK: TButton;
    btnCancel: TButton;
    lbStyle: TListBox;
    lbWidth: TListBox;
    sbSample: TGroupBox;
    shSample: TShape;
    rgOrientation: TRadioGroup;
    EnterToTab1: TEnterToTab;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FLineControl : TVRWLineControl;
    FMode : TLinePropertiesMode;
    Procedure SetLineControl (Value : TVRWLineControl);
  public
    { Public declarations }
    Property LineControl : TVRWLineControl Read FLineControl Write SetLineControl;

    Constructor Create (AOwner: TComponent; Mode : TLinePropertiesMode); Reintroduce;
  end;


// Adds a line control into the specified region at the specified region client co-ords
Function AddLineControl(Const Region : TWinControl; Const X, Y : Integer) : Boolean;

// Displays the properties dialog for the passed Line Control, returns TRUE
// if the user Saved the changes or FALSE if they cancelled the dialog
Function DisplayLineOptions (DesignerControl : TVRWLineControl) : Boolean;


implementation

{$R *.dfm}

Uses DesignerUtil, Region;

//=========================================================================

// Adds a line control into the specified region at the specified region client co-ords
Function AddLineControl(Const Region : TWinControl; Const X, Y : Integer) : Boolean;
Var
  frmLineProperties : TfrmLineProperties;
  NewLineIntf       : IVRWLineControl;
Begin // AddLineControl
  Result := False;

  frmLineProperties := TfrmLineProperties.Create(Application.MainForm, lpmAdd);
  Try
    // Centre the window over the mouse click
    With Region.ClientToScreen(Point(X,Y)) Do CentreOverCoords (frmLineProperties, X, Y);

    // Create new text object in RepEngine.Dll
    NewLineIntf := TRegion(Region).reRegionDets.rgControls.Add(TRegion(Region).reRegionDets.RgReport, ctLine) As IVRWLineControl;

    // Create a new hidden wrapper control for the designer - setup minimum basic info
    frmLineProperties.LineControl := TVRWLineControl.Create (TRegion(Region).reManager, NewLineIntf);
    frmLineProperties.LineControl.Visible := False;
    frmLineProperties.LineControl.ParentRegion := TRegion(Region);
    frmLineProperties.LineControl.SetBounds (X, Y, 90, 21); // LTWH

    Result := (frmLineProperties.ShowModal = mrOK);
    If Result Then
    Begin
      // Need to size intelligently and position according to the grid
      //frmLineProperties.LineControl.CalcInitialSize (frmTextProperties.TextControl.ControlDets.vcCaption);
      frmLineProperties.LineControl.SnapToGrid;

      // Finally, show the control
      frmLineProperties.LineControl.Visible := True;
    End // If Result
    Else
    Begin
      // Cancelled - remove control and destroy RepEngine object
      frmLineProperties.LineControl.Free;
      frmLineProperties.LineControl := NIL;
      TRegion(Region).reRegionDets.rgControls.Delete(NewLineIntf.vcName);
    End; // Else
  Finally
    NewLineIntf := NIL;
    FreeAndNIL(frmLineProperties);
  End; // Try..Finally
End; // AddLineControl

//-------------------------------------------------------------------------

// Displays the properties dialog for the passed Line Control, returns TRUE
// if the user Saved the changes or FALSE if they cancelled the dialog
Function DisplayLineOptions (DesignerControl : TVRWLineControl) : Boolean;
Var
  frmLineProperties : TfrmLineProperties;
Begin // DisplayLineOptions
  frmLineProperties := TfrmLineProperties.Create(Application.MainForm, lpmEdit);
  Try
    CentreOverControl (frmLineProperties, DesignerControl);
    frmLineProperties.LineControl := DesignerControl;
    Result := (frmLineProperties.ShowModal = mrOK);
  Finally
    FreeAndNIL(frmLineProperties);
  End; // Try..Finally
End; // DisplayLineOptions

//=========================================================================

Constructor TfrmLineProperties.Create (AOwner: TComponent; Mode : TLinePropertiesMode);
Begin // Create
  Inherited Create(AOwner);

  FMode := Mode;
End; // Create

//-------------------------------------------------------------------------

procedure TfrmLineProperties.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  If (ModalResult = mrOK) Then
  Begin
    ShowMessage ('Update Control');
//    FTextControl.ControlDets.vcCaption := memText.Text;
//
//    Case cbAlignment.ItemIndex Of
//      0 : FTextControl.ControlDets.vcFieldFormat := 'L';
//      1 : FTextControl.ControlDets.vcFieldFormat := 'C';
//      2 : FTextControl.ControlDets.vcFieldFormat := 'R';
//    End; // Case cbAlignment.ItemIndex
//
//    // Update the font, also causes a repaint and sets the changed flag
//    FTextControl.UpdateFont(lblFontExample.Font);
  End; // If (ModalResult = mrOK)
end;

//------------------------------

Procedure TfrmLineProperties.SetLineControl (Value : TVRWLineControl);
Begin // SetTextControl
  FLineControl := Value;

//  memText.Text := FTextControl.ControlDets.vcCaption;
//
//  CopyIFontToFont (FTextControl.ControlDets.vcFont, lblFontExample.Font);
//
//  lblFontExample.Alignment := FTextControl.FieldAlignment;
//  Case FTextControl.FieldAlignment Of
//    taCenter       : cbAlignment.ItemIndex := 1;
//    taRightJustify : cbAlignment.ItemIndex := 2;
//  Else
//    cbAlignment.ItemIndex := 0;
//  End; // Case FTextControl.FieldAlignment
End; // SetTextControl

//-------------------------------------------------------------------------


end.
