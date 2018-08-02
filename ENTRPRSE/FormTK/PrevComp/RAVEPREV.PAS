unit RavePrev;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Forms, RPDefine, RPFPrint, RPreview;

type
  TRavePreview = class(TCustomPanel)
  private
    { Private declarations }

    // Sub-Components
    scrlPreview : TScrollBox;        // Scroll-Box to display Preview
    FilePreview : TFilePreview;      // Rave Preview component

    // Properties
    FActive      : Boolean;
    FCurrentPage : Integer;

    // Events
    FOnPageChanged : TNotifyEvent;
    FOnPreviewActivated : TNotifyEvent;
    FOnPreviewStopped : TNotifyEvent;
    function GetZoomInc: Integer;
    procedure SetZoomInc(const Value: Integer);
  protected
    { Protected declarations }
    procedure PreviewPageChange(Sender : TObject);

    // Property Get/Set methods
    function GetPages: Integer;
    procedure SetActive(const Value: Boolean);
    function GetFileName: ShortString;
    procedure SetFileName(const Value: ShortString);
    procedure SetCurrentPage(const Value: Integer);
    function GetZoom: Double;
    procedure SetZoom(const Value: Double);
    function GetZoomPage: Double;
    function GetZoomPageWidth: Double;
    procedure SetDummyDbl(const Value: Double);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy; Override;
  published
    { Published declarations }

    // Inherited Properties
    Property Align;
    Property Anchors;

    // Properties
    Property Active : Boolean Read FActive Write SetActive;
    Property CurrentPage : Integer Read FCurrentPage Write SetCurrentPage;
    Property Filename : ShortString Read GetFileName Write SetFileName;
    Property Pages : Integer Read GetPages;
    Property Zoom : Double Read GetZoom Write SetZoom;
    Property ZoomInc : Integer Read GetZoomInc Write SetZoomInc;
    Property ZoomPage : Double Read GetZoomPage Write SetDummyDbl;
    Property ZoomPageWidth : Double Read GetZoomPageWidth Write SetDummyDbl;

    // Events
    Property OnPageChanged : TNotifyEvent Read FOnPageChanged Write FOnPageChanged;
    Property OnPreviewActivated : TNotifyEvent Read FOnPreviewActivated Write FOnPreviewActivated;
    Property OnPreviewStopped : TNotifyEvent Read FOnPreviewStopped Write FOnPreviewStopped;

    // Methods
    Procedure FirstPage;
    Procedure PreviousPage;
    Procedure NextPage;
    Procedure LastPage;
    Procedure ZoomIn;
    Procedure ZoomOut;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SbsForm', [TRavePreview]);
end;

//-----------------------------------------------------------------------------

constructor TRavePreview.Create(AOwner: TComponent);
begin
  Inherited Create (AOwner);

  BevelInner := bvNone;
  BevelOuter := bvNone;
  Caption := '';

  // Initialise Properties
  FActive := False;
  FCurrentPage := 0;

  FOnPageChanged := NIL;
  FOnPreviewActivated := NIL;
  FOnPreviewStopped := NIL;

  // Create scroll-box to display Preview
  scrlPreview := TScrollBox.Create(Self);
  With scrlPreview Do Begin
    Parent := Self;
    Align := alClient;
  End; { With scrlPreview }

  // Create RAVE File Preview component
  FilePreview := TFilePreview.Create(Self);
  With FilePreview Do Begin
    ScrollBox := scrlPreview;
    StreamMode := smFile;
    ZoomFactor := 115;
    ZoomInc := 25;

    OnPageChange := PreviewPageChange;
  End; { With FilePreview }
end;

destructor TRavePreview.Destroy;
begin
  FreeAndNIL(FilePreview);
  FreeAndNIL(scrlPreview);

  inherited;
end;

//-----------------------------------------------------------------------------

procedure TRavePreview.PreviewPageChange(Sender : TObject);
begin
  If Assigned(FOnPageChanged) Then
    FOnPageChanged(Self);
end;

//-----------------------------------------------------------------------------

procedure TRavePreview.SetActive(const Value: Boolean);
begin
  // Check for changed status
  If (Value <> FActive) Then Begin
    If FActive And (Not Value) Then Begin
      // Currently Active and disabling
      FilePreview.Finish;

      // Change Active status
      FActive := False;

      // Execute the OnPreviewActivated to allow the preview window to be updated
      If Assigned(FOnPreviewStopped) Then
        FOnPreviewStopped(Self);
    End { If FActive And (Not Value) }
    Else Begin
      // Currently disabled and enabling - check a preview filename has been specified
      If (Trim(FilePreview.FileName) <> '') And FileExists(FilePreview.FileName) Then Begin
        // Change Active status
        FActive := True;

        // Start the Preview
        FCurrentPage := 1;
        FilePreview.Start;

        // Execute the OnPreviewActivated to allow the preview window to be updated
        If Assigned(FOnPreviewActivated) Then
          FOnPreviewActivated(Self);
      End { If (Trim(FilePreview.FileName) <> ... }
      Else
        Raise Exception.Create ('The FileName property must be set before the preview can be activated');
    End; { Else }
  End; { If (Value <> FActive) }
end;

//--------------------------------------

function TRavePreview.GetFileName: ShortString;
begin
  Result := FilePreview.FileName;
end;

procedure TRavePreview.SetFileName(const Value: ShortString);
begin
  If (Not Active) Then Begin
    // Check Filename exists
    If FileExists(Value) Or (Trim(Value) = '') Then
      FilePreview.FileName := Value
    Else
      Raise Exception.Create ('The File specified does not exist');
  End { If (Not Active) }
  Else
    Raise Exception.Create ('The FileName cannot be changed whilst the Preview Component is Active');
end;

//--------------------------------------

procedure TRavePreview.SetCurrentPage(const Value: Integer);
begin
  // Check for changes
  If FActive And (FCurrentPage <> Value) Then Begin
    // Check new page is valid page number
    If (Value >= 1) And (Value <= FilePreview.Pages) Then Begin
      FCurrentPage := Value;
      FilePreview.PrintPage (FCurrentPage);
    End { If (Value >= 1) ... }
    Else
      Raise Exception.Create ('The specified Page Number is not within the page range of the current document');
  End; { If (FCurrentPage <> Value) }
end;

//--------------------------------------

function TRavePreview.GetPages: Integer;
begin
  If FActive Then
    Result := FilePreview.Pages
  Else
    Result := 0;
end;

//--------------------------------------

function TRavePreview.GetZoom: Double;
begin
  Result := FilePreview.ZoomFactor
end;

procedure TRavePreview.SetZoom(const Value: Double);
begin
  If (FilePreview.ZoomFactor <> Value) Then
    FilePreview.ZoomFactor := Value;
end;

function TRavePreview.GetZoomInc: Integer;
begin
  Result := FilePreview.ZoomInc
end;

procedure TRavePreview.SetZoomInc(const Value: Integer);
begin
  FilePreview.ZoomInc := Value;
end;

function TRavePreview.GetZoomPage: Double;
begin
  If FActive Then
    Result := FilePreview.ZoomPageFactor
  Else
    Result := 0;
end;

function TRavePreview.GetZoomPageWidth: Double;
begin
  If FActive Then
    Result := FilePreview.ZoomPageWidthFactor
  Else
    Result := 0;
end;

procedure TRavePreview.SetDummyDbl(const Value: Double);
begin
  // Write method for Read-Only properties to force them to display in Object Inspector
end;

//-----------------------------------------------------------------------------

Procedure TRavePreview.FirstPage;
begin
  If FActive Then CurrentPage := 1
end;

Procedure TRavePreview.PreviousPage;
begin
  If FActive And (CurrentPage > 1) Then CurrentPage := CurrentPage - 1;
end;

Procedure TRavePreview.NextPage;
begin
  If FActive And (CurrentPage < FilePreview.Pages) Then CurrentPage := CurrentPage + 1;
end;

Procedure TRavePreview.LastPage;
begin
  If FActive Then CurrentPage := FilePreview.Pages;
end;

//-----------------------------------------------------------------------------

procedure TRavePreview.ZoomIn;
begin
  FilePreview.ZoomIn;
end;

procedure TRavePreview.ZoomOut;
begin
  FilePreview.ZoomOut;
end;

//-----------------------------------------------------------------------------

end.
