unit ctrlBoxPropertiesF;

interface

uses
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ExtCtrls,
  Dialogs, StdCtrls, TCustom, TEditVal, EnterToTab, Windows, Buttons,
  VRWReportIF,
  DesignerTypes,    // Common designer types and interfaces
  ctrlBox, ComCtrls, Mask, BorBtns
  ;

type
  TBoxPropertiesMode = (bpmAdd, bpmEdit);

  TfrmBoxProperties = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    EnterToTab1: TEnterToTab;
    PaintBox1: TPaintBox;
    btnApplyBottom: TBitBtn;
    btnApplyRight: TBitBtn;
    btnApplyTop: TBitBtn;
    btnApplyLeft: TBitBtn;
    radTransparent: TBorRadio;
    cbFillColor: TColorBox;
    Bevel1: TBevel;
    Label82: Label8;
    lbStyle: TListBox;
    Label81: Label8;
    lblColor: TLabel;
    cbColor: TColorBox;
    ext8Pt1: Text8Pt;
    Label83: Label8;
    udWidth: TSBSUpDown;
    btnApplyAll: TBitBtn;
    btnClearAll: TBitBtn;
    Bevel3: TBevel;
    radFill: TBorRadio;
    EnterToTab2: TEnterToTab;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lbStyleDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure PaintBox1Paint(Sender: TObject);
    procedure btnApplyLeftClick(Sender: TObject);
    procedure btnApplyTopClick(Sender: TObject);
    procedure btnApplyRightClick(Sender: TObject);
    procedure btnApplyBottomClick(Sender: TObject);
    procedure btnClearAllClick(Sender: TObject);
    procedure btnApplyAllClick(Sender: TObject);
    procedure radFillClick(Sender: TObject);
    procedure cbFillColorChange(Sender: TObject);
    procedure udWidthClick(Sender: TObject; Button: TUDBtnType);
    procedure ext8Pt1Change(Sender: TObject);
  private
    { Private declarations }
    FBoxControl : TVRWBoxControl;
    FMode : TBoxPropertiesMode;
    FDlgBoxDets : TTempBoxDets;
    Function GetLineStyle : TPenStyle;
    Procedure SetBoxControl (Value : TVRWBoxControl);
    procedure PopulateLineStyles;
  public
    { Public declarations }
    Property BoxControl : TVRWBoxControl Read FBoxControl Write SetBoxControl;

    Constructor Create (AOwner: TComponent; Mode : TBoxPropertiesMode); Reintroduce;
  end;


// Adds a Box control into the specified region at the specified region client co-ords
Function AddBoxControl(Const Region : TWinControl; Const X, Y : Integer) : Boolean;

// Displays the properties dialog for the passed Box Control, returns TRUE
// if the user Saved the changes or FALSE if they cancelled the dialog
Function DisplayBoxOptions (DesignerControl : TVRWBoxControl;
  TheForm: TForm = nil) : Boolean;


implementation

{$R *.dfm}

uses DesignerUtil, Region;

const
  LineStyles: array[0..5] of string =
    (
      'Clear',
      'Solid',
      'Dash',
      'Dot',
      'Dash Dot',
      'Dash Dot Dot'
    );

//=========================================================================

// Adds a Box control into the specified region at the specified region client co-ords
Function AddBoxControl(Const Region : TWinControl; Const X, Y : Integer) : Boolean;
Var
  frmBoxProperties : TfrmBoxProperties;
  NewBoxIntf       : IVRWBoxControl;
Begin // AddBoxControl
  frmBoxProperties := TfrmBoxProperties.Create(Application.MainForm, bpmAdd);
  Try
    // Centre the window over the mouse click
    With Region.ClientToScreen(Point(X,Y)) Do CentreOverCoords (frmBoxProperties, X, Y);

    // Create new text object in RepEngine.Dll
    NewBoxIntf := TRegion(Region).reRegionDets.rgControls.Add(TRegion(Region).reRegionDets.RgReport, ctBox) As IVRWBoxControl;

    // Create a new hidden wrapper control for the designer - setup minimum basic info
    frmBoxProperties.BoxControl := TVRWBoxControl.Create (TRegion(Region).reManager, NewBoxIntf);
    frmBoxProperties.BoxControl.Visible := False;
    frmBoxProperties.BoxControl.ParentRegion := TRegion(Region);
    frmBoxProperties.BoxControl.SetBounds (X, Y, 90, 21); // LTWH

    Result := (frmBoxProperties.ShowModal = mrOK);
    If Result Then
    Begin
      // Need to size intelligently and position according to the grid
      //frmBoxProperties.BoxControl.CalcInitialSize (frmTextProperties.TextControl.ControlDets.vcCaption);
      frmBoxProperties.BoxControl.SnapToGrid;

      // Select the control
      TRegion(Region).reManager.SelectControl(frmBoxProperties.BoxControl, False);

      // Finally, show the control
      frmBoxProperties.BoxControl.Visible := True;
    End // If Result
    Else
    Begin
      // Cancelled - remove control and destroy RepEngine object
      frmBoxProperties.BoxControl.Free;
      frmBoxProperties.BoxControl := NIL;
      TRegion(Region).reRegionDets.rgControls.Delete(NewBoxIntf.vcName);
    End; // Else
  Finally
    NewBoxIntf := NIL;
    FreeAndNIL(frmBoxProperties);
  End; // Try..Finally
End; // AddBoxControl

//-------------------------------------------------------------------------

// Displays the properties dialog for the passed Box Control, returns TRUE
// if the user Saved the changes or FALSE if they cancelled the dialog
Function DisplayBoxOptions (DesignerControl : TVRWBoxControl;
  TheForm: TForm) : Boolean;
Var
  frmBoxProperties : TfrmBoxProperties;
Begin // DisplayBoxOptions
  frmBoxProperties := TfrmBoxProperties.Create(Application.MainForm, bpmEdit);
  Try
    if TheForm <> nil then
      CentreOverForm(frmBoxProperties, TheForm)
    else
      CentreOverControl (frmBoxProperties, DesignerControl);
    frmBoxProperties.BoxControl := DesignerControl;
    Result := (frmBoxProperties.ShowModal = mrOK);
    If Result Then // DesignerControl.Invalidate;
      DesignerControl.ParentRegion.Invalidate;
  Finally
    FreeAndNIL(frmBoxProperties);
  End; // Try..Finally
End; // DisplayBoxOptions

//=========================================================================

Constructor TfrmBoxProperties.Create (AOwner: TComponent; Mode : TBoxPropertiesMode);
Begin // Create
  Inherited Create(AOwner);

  FMode := Mode;

  PopulateLineStyles;
End; // Create

//-------------------------------------------------------------------------

procedure TfrmBoxProperties.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Var
  I : TVRWBoxLineIndex;
begin
  If (ModalResult = mrOK) Then
  Begin
    // Copy the details back into the actual control
    FBoxControl.BoxDets.vcFilled := FDlgBoxDets.vcFilled;
    FBoxControl.BoxDets.vcFillColor := FDlgBoxDets.vcFillColor;

    For I := Low(TVRWBoxLineIndex) to High(TVRWBoxLineIndex) Do
    Begin
      FBoxControl.BoxDets.vcBoxLines[I].vcLineStyle := FDlgBoxDets.vcBoxLines[I].vcLineStyle;
      FBoxControl.BoxDets.vcBoxLines[I].vcLineColor := FDlgBoxDets.vcBoxLines[I].vcLineColor;
      FBoxControl.BoxDets.vcBoxLines[I].vcLineWidth := FDlgBoxDets.vcBoxLines[I].vcLineWidth;
    End; // For I
  End; // If (ModalResult = mrOK)
end;

//------------------------------

Procedure TfrmBoxProperties.SetBoxControl (Value : TVRWBoxControl);
Var
  I : TVRWBoxLineIndex;
Begin // SetTextControl
  FBoxControl := Value;

  If Assigned(FBoxControl) Then
  Begin
    // Copy the details locally so we can change them and still cancel the dialog
    FDlgBoxDets.vcFilled := FBoxControl.BoxDets.vcFilled;
    FDlgBoxDets.vcFillColor := FBoxControl.BoxDets.vcFillColor;

    For I := Low(TVRWBoxLineIndex) to High(TVRWBoxLineIndex) Do
    Begin
      FDlgBoxDets.vcBoxLines[I].vcLineStyle := FBoxControl.BoxDets.vcBoxLines[I].vcLineStyle;
      FDlgBoxDets.vcBoxLines[I].vcLineColor := FBoxControl.BoxDets.vcBoxLines[I].vcLineColor;
      FDlgBoxDets.vcBoxLines[I].vcLineWidth := FBoxControl.BoxDets.vcBoxLines[I].vcLineWidth;
    End; // For I

    // Setup the controls on the form
    cbFillColor.Selected := FDlgBoxDets.vcFillColor;
    radTransparent.Checked := Not FDlgBoxDets.vcFilled;
    radFill.Checked := FDlgBoxDets.vcFilled;

  End; // If Assigned(FBoxControl)
End; // SetTextControl

//-------------------------------------------------------------------------

// Owner-draw event for line style list
procedure TfrmBoxProperties.lbStyleDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
Var
  Y : SmallInt;
begin
  With TListBox(Control).Canvas Do
  Begin
    If (odSelected In State) Then Brush.Color := clHighLight Else Brush.Color := clWindow;
    Brush.Style := bsSolid;
    FillRect (Rect);

    Case Index Of
      0 : Pen.Style := psClear;
      1 : Pen.Style := psSolid;
      2 : Pen.Style := psDash;
      3 : Pen.Style := psDot;
      4 : Pen.Style := psDashDot;
      5 : Pen.Style := psDashDotDot;
    End; // Case Index

    If (odSelected In State) Then Pen.Color := clWindow Else Pen.Color := clBlack;
    Pen.Width := 1;
    Y := Rect.Top + (Rect.Bottom - Rect.Top) Div 2;
    MoveTo (Rect.Left + 10, Y);
    LineTo (Rect.Right - 10, Y);
  End; // With TListBox(Control).Canvas
end;

//-------------------------------------------------------------------------

// Pain event for paintbox 'preview' of the box
procedure TfrmBoxProperties.PaintBox1Paint(Sender: TObject);
Var
  BoxRect : TRect;

  Procedure PaintLine (Const Start, Finish : TPoint; Const LineDets : TTempBoxLine; Const OffsetModifier : SmallInt);
  Var
    I : SmallInt;
  Begin // PaintLine
    If (LineDets.vcLineStyle <> psClear) Then
    Begin
      With PaintBox1.Canvas Do
      Begin
        Pen.Color := LineDets.vcLineColor;
        Pen.Style := LineDets.vcLineStyle;
        Pen.Width := 1;

        For I := 0 To (LineWidthInPixels (LineDets.vcLineWidth) - 1) Do
        Begin
          If (Start.X = Finish.X) Then
          Begin
            // Vertical
            MoveTo(Start.X + (I * OffsetModifier), Start.Y);
            LineTo(Finish.X + (I * OffsetModifier), Finish.Y);
            Pixels[Finish.X + (I * OffsetModifier), Finish.Y] := LineDets.vcLineColor;
          End // If (Start.X = Finish.X)
          Else
          Begin
            // Horizontal
            MoveTo(Start.X, Start.Y + (I * OffsetModifier));
            LineTo(Finish.X, Finish.Y + (I * OffsetModifier));
            Pixels[Finish.X, Finish.Y + (I * OffsetModifier)] := LineDets.vcLineColor;
          End; // Else
        End; // For I
      End; // With PaintBox1.Canvas
    End; // If (vcLineStyle <> psClear)   
  End; // PaintLine

begin
  With PaintBox1.Canvas Do
  Begin
    Brush.Color := clWindow;
    Brush.Style := bsSolid;
    FillRect(ClientRect);

    BoxRect := Rect (10, 10, PaintBox1.Width - 10, PaintBox1.Height - 10); // LTRB

    If FDlgBoxDets.vcFilled Then
    Begin
      Brush.Color := FDlgBoxDets.vcFillColor;
      FillRect (BoxRect);
    End; // If FDlgBoxDets.vcFilled

    // NOTE: Drawing co-ords take into account that the last pixel of a line isn't painted

    // Draw Left
    PaintLine (BoxRect.TopLeft, Point(BoxRect.Left, BoxRect.Bottom - 1), FDlgBoxDets.vcBoxLines[biLeft], 1);

    // Draw Right
    PaintLine (Point(BoxRect.Right-1, BoxRect.Top), Point(BoxRect.Right-1, BoxRect.Bottom - 1), FDlgBoxDets.vcBoxLines[biRight], -1);

    // Draw Top
    PaintLine (BoxRect.TopLeft, Point(BoxRect.Right - 1, BoxRect.Top), FDlgBoxDets.vcBoxLines[biTop], 1);

    // Draw Bottom
    PaintLine (Point(BoxRect.Left, BoxRect.Bottom - 1), Point(BoxRect.Right - 1, BoxRect.Bottom - 1), FDlgBoxDets.vcBoxLines[biBottom], -1);
  End; // With PaintBox1.Canvas
end;

//-------------------------------------------------------------------------

Function TfrmBoxProperties.GetLineStyle : TPenStyle;
Begin // GetLineStyle
  Case lbStyle.ItemIndex Of
    0 : Result := psClear;
    1 : Result := psSolid;
    2 : Result := psDash;
    3 : Result := psDot;
    4 : Result := psDashDot;
    5 : Result := psDashDotDot;
  Else
    Result := psSolid;
  End; // Case lbStyle.ItemIndex
End; // GetLineStyle

//-------------------------------------------------------------------------

procedure TfrmBoxProperties.btnApplyLeftClick(Sender: TObject);
begin
  With FDlgBoxDets.vcBoxLines[biLeft] Do
  Begin
    vcLineStyle := GetLineStyle;
    vcLineColor := cbColor.Selected;
    vcLineWidth := udWidth.Position;
  End; // With FDlgBoxDets.vcBoxLines[biLeft]

  PaintBox1.Invalidate;
end;

//------------------------------

procedure TfrmBoxProperties.btnApplyTopClick(Sender: TObject);
begin
  With FDlgBoxDets.vcBoxLines[biTop] Do
  Begin
    vcLineStyle := GetLineStyle;
    vcLineColor := cbColor.Selected;
    vcLineWidth := udWidth.Position;
  End; // With FDlgBoxDets.vcBoxLines[biTop]

  PaintBox1.Invalidate;
end;

//------------------------------

procedure TfrmBoxProperties.btnApplyRightClick(Sender: TObject);
begin
  With FDlgBoxDets.vcBoxLines[biRight] Do
  Begin
    vcLineStyle := GetLineStyle;
    vcLineColor := cbColor.Selected;
    vcLineWidth := udWidth.Position;
  End; // With FDlgBoxDets.vcBoxLines[biRight]

  PaintBox1.Invalidate;
end;

//------------------------------

procedure TfrmBoxProperties.btnApplyBottomClick(Sender: TObject);
begin
  With FDlgBoxDets.vcBoxLines[biBottom] Do
  Begin
    vcLineStyle := GetLineStyle;
    vcLineColor := cbColor.Selected;
    vcLineWidth := udWidth.Position;
  End; // With FDlgBoxDets.vcBoxLines[biBottom]

  PaintBox1.Invalidate;
end;

//------------------------------

procedure TfrmBoxProperties.btnClearAllClick(Sender: TObject);
begin
  // NOTE: Because BoxDets is a record must use WITH to write to it - Delphi Bug?
  FDlgBoxDets.vcBoxLines[biLeft].vcLineStyle := psClear;
  FDlgBoxDets.vcBoxLines[biTop].vcLineStyle := psClear;
  FDlgBoxDets.vcBoxLines[biRight].vcLineStyle := psClear;
  FDlgBoxDets.vcBoxLines[biBottom].vcLineStyle := psClear;

  PaintBox1.Invalidate;
end;

//------------------------------

procedure TfrmBoxProperties.btnApplyAllClick(Sender: TObject);
begin
  btnApplyLeftClick(Sender);
  btnApplyTopClick(Sender);
  btnApplyRightClick(Sender);
  btnApplyBottomClick(Sender);
end;

//-------------------------------------------------------------------------

procedure TfrmBoxProperties.radFillClick(Sender: TObject);
begin
  FDlgBoxDets.vcFilled := radFill.Checked;
  cbFillColor.Enabled := FDlgBoxDets.vcFilled;
  FDlgBoxDets.vcFillColor := cbFillColor.Selected;
  PaintBox1.Invalidate;
end;

//------------------------------

procedure TfrmBoxProperties.cbFillColorChange(Sender: TObject);
begin
  FDlgBoxDets.vcFillColor := cbFillColor.Selected;
  PaintBox1.Invalidate;
end;

//-------------------------------------------------------------------------

procedure TfrmBoxProperties.PopulateLineStyles;
var
  i: Integer;
  MaxStyles: Integer;
  StyleIndex: Integer;
begin
  MaxStyles := High(LineStyles);
  StyleIndex := lbStyle.ItemIndex;
  if (udWidth.Position > 1) then
  begin
    MaxStyles := 1;
    if StyleIndex > 1 then
      StyleIndex := 1;
  end;
  lbStyle.Clear;
  for i := Low(LineStyles) to MaxStyles do
    lbStyle.Items.Add(LineStyles[i]);
  lbStyle.ItemIndex := StyleIndex;
end;

procedure TfrmBoxProperties.udWidthClick(Sender: TObject;
  Button: TUDBtnType);
begin
//  PopulateLineStyles;
end;

procedure TfrmBoxProperties.ext8Pt1Change(Sender: TObject);
begin
  PopulateLineStyles;
end;

end.

