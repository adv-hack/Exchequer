unit ctrlTextPropertiesF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, TEditVal, EnterToTab,
  VRWReportIF,
  DesignerTypes,    // Common designer types and interfaces
  ctrlText
  ;

type
  TTextPropertiesMode = (tpAdd, tpEdit);

  TfrmTextProperties = class(TForm)
    GroupBox1: TGroupBox;
    Label81: Label8;
    memText: TMemo;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    Label82: Label8;
    cbAlignment: TComboBox;
    GroupBox2: TGroupBox;
    lblFontExample: TLabel;
    btnChangeFont: TSBSButton;
    FontDialog1: TFontDialog;
    EnterToTab1: TEnterToTab;
    procedure btnChangeFontClick(Sender: TObject);
    procedure cbAlignmentClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure memTextChange(Sender: TObject);
  private
    { Private declarations }
    FMode : TTextPropertiesMode;
    FTextControl : TVRWTextControl;
    Procedure SetTextControl (Value : TVRWTextControl);
  public
    { Public declarations }
    Property TextControl : TVRWTextControl Read FTextControl Write SetTextControl;

    Constructor Create (AOwner: TComponent; Mode : TTextPropertiesMode); Reintroduce;
  end;


// Adds a text control into the specified region at the specified region client co-ords
Function AddTextControl(Const Region : TWinControl; Const X, Y : Integer) : Boolean;

// Displays the properties dialog for the passed Text Control, returns TRUE
// if the user Saved the changes or FALSE if they cancelled the dialog
Function DisplayTextOptions (DesignerControl : TVRWTextControl;
  TheForm: TForm = nil) : Boolean;


implementation

{$R *.dfm}

Uses DesignerUtil, Region;

//=========================================================================

// Adds a text control into the specified region at the specified region client co-ords
Function AddTextControl(Const Region : TWinControl; Const X, Y : Integer) : Boolean;
Var
  frmTextProperties : TfrmTextProperties;
  NewTextIntf       : IVRWTextControl;
Begin // AddTextControl
  frmTextProperties := TfrmTextProperties.Create(Application.MainForm, tpAdd);
  Try
    // Centre the window over the mouse click
    With Region.ClientToScreen(Point(X,Y)) Do CentreOverCoords (frmTextProperties, X, Y);

    // Create new text object in RepEngine.Dll
    NewTextIntf := TRegion(Region).reRegionDets.rgControls.Add(TRegion(Region).reRegionDets.RgReport, ctText) As IVRWTextControl;

    // Create a new hidden wrapper control for the designer - setup minimum basic info
    frmTextProperties.TextControl := TVRWTextControl.Create (TRegion(Region).reManager, NewTextIntf);
    frmTextProperties.TextControl.Visible := False;
    frmTextProperties.TextControl.ParentRegion := TRegion(Region);
    frmTextProperties.TextControl.SetBounds (X, Y, 90, 21); // LTWH

    Result := (frmTextProperties.ShowModal = mrOK);
    If Result Then
    Begin
      // Need to size intelligently and position according to the grid
      frmTextProperties.TextControl.CalcInitialSize (frmTextProperties.TextControl.ControlDets.vcCaption);
      frmTextProperties.TextControl.SnapToGrid;

      // Select the control
      TRegion(Region).reManager.SelectControl(frmTextProperties.TextControl, False);

      // Finally, show the control
      frmTextProperties.TextControl.Visible := True;
    End // If Result
    Else
    Begin
      // Cancelled - remove control and destroy RepEngine object
      frmTextProperties.TextControl.Free;
      frmTextProperties.TextControl := NIL;
      TRegion(Region).reRegionDets.rgControls.Delete(NewTextIntf.vcName);
    End; // Else
  Finally
    NewTextIntf := NIL;
    FreeAndNIL(frmTextProperties);
  End; // Try..Finally
End; // AddTextControl

//-------------------------------------------------------------------------

// Displays the properties dialog for the passed Text Control, returns TRUE
// if the user Saved the changes or FALSE if they cancelled the dialog
Function DisplayTextOptions (DesignerControl : TVRWTextControl;
  TheForm: TForm) : Boolean;
Var
  frmTextProperties : TfrmTextProperties;
Begin // DisplayTextOptions
  frmTextProperties := TfrmTextProperties.Create(Application.MainForm, tpEdit);
  Try
    if TheForm <> nil then
      CentreOverForm(frmTextProperties, TheForm)
    else
      CentreOverControl (frmTextProperties, DesignerControl);
    frmTextProperties.TextControl := DesignerControl;
    Result := (frmTextProperties.ShowModal = mrOK);
  Finally
    FreeAndNIL(frmTextProperties);
  End; // Try..Finally
End; // DisplayTextOptions

//=========================================================================

Constructor TfrmTextProperties.Create (AOwner: TComponent; Mode : TTextPropertiesMode);
Begin // Create
  Inherited Create(AOwner);

  FMode := Mode;
End; // Create

//-------------------------------------------------------------------------

procedure TfrmTextProperties.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  If (ModalResult = mrOK) Then
  Begin
    FTextControl.ControlDets.vcCaption := memText.Text;

    Case cbAlignment.ItemIndex Of
      0 : FTextControl.ControlDets.vcFieldFormat := 'L';
      1 : FTextControl.ControlDets.vcFieldFormat := 'C';
      2 : FTextControl.ControlDets.vcFieldFormat := 'R';
    End; // Case cbAlignment.ItemIndex

    // Update the font, also causes a repaint and sets the changed flag
    FTextControl.UpdateFont(lblFontExample.Font);
  End; // If (ModalResult = mrOK)
end;

//------------------------------

Procedure TfrmTextProperties.SetTextControl (Value : TVRWTextControl);
Begin // SetTextControl
  FTextControl := Value;
  If Assigned(FTextControl) Then
  Begin
    memText.Text := FTextControl.ControlDets.vcCaption;

    CopyIFontToFont (FTextControl.ControlDets.vcFont, lblFontExample.Font);

    lblFontExample.Alignment := FTextControl.FieldAlignment;
    Case FTextControl.FieldAlignment Of
      taCenter       : cbAlignment.ItemIndex := 1;
      taRightJustify : cbAlignment.ItemIndex := 2;
    Else
      cbAlignment.ItemIndex := 0;
    End; // Case FTextControl.FieldAlignment
  End; // If Assigned(FTextControl)
End; // SetTextControl

//-------------------------------------------------------------------------

procedure TfrmTextProperties.memTextChange(Sender: TObject);
begin
  lblFontExample.Caption := memText.Text;
end;

//-------------------------------------------------------------------------

procedure TfrmTextProperties.cbAlignmentClick(Sender: TObject);
begin
  Case cbAlignment.ItemIndex Of
    0 : lblFontExample.Alignment := taLeftJustify;
    1 : lblFontExample.Alignment := taCenter;
    2 : lblFontExample.Alignment := taRightJustify;
  End; // Case cbAlignment.ItemIndex
end;

//-------------------------------------------------------------------------

procedure TfrmTextProperties.btnChangeFontClick(Sender: TObject);
begin
  FontDialog1.Font.Assign(lblFontExample.Font);
  If FontDialog1.Execute Then
  Begin
    lblFontExample.Font.Assign(FontDialog1.Font);
  End; // If FontDialog1.Execute
end;

//-------------------------------------------------------------------------

end.
