unit ImportF2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls,
  Enterprise_TLB,      // Data Query Server Type Library
  oDataQ;              // Base Data Query Server Object

type
  TfrmFilterCritera = class(TForm)
    Bevel1: TBevel;
    TitleLbl: TLabel;
    lblInstructions: TLabel;
    imgSide: TImage;
    btnHelp: TButton;
    Panel1: TPanel;
    Image1: TImage;
    btnClose: TButton;
    btnBack: TButton;
    btnNext: TButton;
    nbFilters: TNotebook;
    lblAccountRangeStart: TLabel;
    edtAccountRangeStart: TEdit;
    lblAccountRangeEnd: TLabel;
    edtAccountRangeEnd: TEdit;
    chkAccountRange: TCheckBox;
    chkCCDeptRange: TCheckBox;
    lblCCDeptRangeStart: TLabel;
    edtCCDeptRangeStart: TEdit;
    lblCCDeptRangeEnd: TLabel;
    edtCCDeptRangeEnd: TEdit;
    chkLocationRange: TCheckBox;
    lblLocationRangeStart: TLabel;
    edtLocationRangeStart: TEdit;
    edtLocationRangeEnd: TEdit;
    lblLocationRangeEnd: TLabel;
    chkGLParent: TCheckBox;
    lblGLParent: TLabel;
    edtGLParent: TEdit;
    chkGLType: TCheckBox;
    chkGLProfitLoss: TCheckBox;
    chkGLBalSheet: TCheckBox;
    chkGLControl: TCheckBox;
    chkGLCarryFwd: TCheckBox;
    lblGLType: TLabel;
    chkGLHeading: TCheckBox;
    chkGLFirstLevel: TCheckBox;
    chkJobParent: TCheckBox;
    lblJobParent: TLabel;
    edtJobParent: TEdit;
    chkJobLevel1Only: TCheckBox;
    chkJobRange: TCheckBox;
    lblJobRangeStart: TLabel;
    lblJobRangeEnd: TLabel;
    edtJobRangeEnd: TEdit;
    edtJobRangeStart: TEdit;
    chkJobType: TCheckBox;
    lblJobType: TLabel;
    chkJobJobs: TCheckBox;
    chkJobContracts: TCheckBox;
    chkStockParent: TCheckBox;
    lblStockParent: TLabel;
    edtStockParent: TEdit;
    chkStockLevel1Only: TCheckBox;
    chkStockRange: TCheckBox;
    lblStockRangeStart: TLabel;
    lblStockRangeEnd: TLabel;
    edtStockRangeEnd: TEdit;
    edtStockRangeStart: TEdit;
    chkStockType: TCheckBox;
    lblStockType: TLabel;
    chkStockProduct: TCheckBox;
    chkStockGroup: TCheckBox;
    chkStockDescOnly: TCheckBox;
    chkStockBOM: TCheckBox;
    chkStockDiscontinued: TCheckBox;
    chkJobStatus: TCheckBox;
    lblJobStatus: TLabel;
    chkJobsQuotation: TCheckBox;
    chkJobsActive: TCheckBox;
    chkJobsSuspended: TCheckBox;
    chkJobsCompleted: TCheckBox;
    chkJobsClosed: TCheckBox;
    lblSelectAcType: TLabel;
    chkIncludeCustomers: TCheckBox;
    chkIncludeConsumers: TCheckBox;
    procedure btnNextClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure chkAccountRangeClick(Sender: TObject);
    procedure chkCCDeptRangeClick(Sender: TObject);
    procedure chkLocationRangeClick(Sender: TObject);
    procedure chkGLParentClick(Sender: TObject);
    procedure chkGLTypeClick(Sender: TObject);
    procedure chkJobRangeClick(Sender: TObject);
    procedure chkJobParentClick(Sender: TObject);
    procedure chkJobTypeClick(Sender: TObject);
    procedure chkStockParentClick(Sender: TObject);
    procedure chkStockRangeClick(Sender: TObject);
    procedure chkStockTypeClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure chkJobStatusClick(Sender: TObject);
  private
    { Private declarations }
    FDataQuery : TDataQuery;

    Procedure ConfigControls;
    procedure CopyFields;
    Procedure DoBitmapStuff;

    Procedure CMDialogKey(Var Msg:TWMKey); message CM_DIALOGKEY;
  public
    { Public declarations }
    ExitCode : Char;

    Constructor Create(AOwner: TComponent; Const DataQuery : TDataQuery); ReIntroduce;
  end;

var
  frmFilterCritera: TfrmFilterCritera;

implementation

{$R *.dfm}

Uses Brand,
     UA_Const, 
     {$IFDEF EXEVER}
       Enterprise01_TLB;    // COM Toolkit Type Library // DLL Version for .EXE EntDataQ
     {$ELSE}
       Enterprise04_TLB;    // COM Toolkit Type Library // MH 08/09/2008: Switched to .EXE COM Toolkit
     {$ENDIF}

//-----------------------------------------------------------------------------------------

Procedure TfrmFilterCritera.CMDialogKey(Var Msg:TWMKey);
Begin
  If NOT (ActiveControl Is TButton) Then
    If Msg.Charcode = 13 Then
      Msg.Charcode := 9;

  inherited;
End;

//-----------------------------------------------------------------------------------------

Constructor TfrmFilterCritera.Create(AOwner: TComponent; Const DataQuery : TDataQuery);
begin
  Inherited Create (AOwner);

  FDataQuery := DataQuery;

  ExitCode := 'X';

  // Set default size
  ClientHeight := 288;
  ClientWidth := 460;

  // Need to set the size of the bmp otherwise we can't paint into it
  Image1.Picture.Bitmap.Height := Image1.Height;
  Image1.Picture.Bitmap.Width := Image1.Width;

  Icon := Branding.pbProductIcon;
  Branding.BrandingFile(ebfSetup).ExtractImage (imgSide, 'TallWizd');

  // Paint bitmap
  DoBitmapStuff;

  // Customise text to be topical
  Caption := Branding.pbProductName + ' Data Query Wizard - ' + FDataQuery.TypeDesc[tsdDataPlural];
  lblInstructions.Caption := lblInstructions.Caption + FDataQuery.TypeDesc[tsdDataPlural] + ' selected by the data query:-';

  If (Branding.pbProduct = ptLITE) Then
  Begin
    chkStockParent.Caption := 'Filter by Parent Group';
    chkStockLevel1Only.Visible := False;
  End; // If (Branding.pbProduct = ptLITE)

  // Link into the correct page in the help
  HelpContext := FDataQuery.TypeContext;

  // Customise Controls
  ConfigControls;
end;

//-----------------------------------------------------------------------------------------

Procedure TfrmFilterCritera.ConfigControls;
Begin { ConfigControls }
  With FDataQuery Do
    Case DataType Of
      dqmCustomer,
      dqmSupplier    : Begin
                         // Select correct page
                         nbFilters.ActivePage := 'Account';

                         // Initialise the Account Range section
                         chkAccountRange.Checked := FilterByRange;
                         chkAccountRangeClick(chkAccountRange);

                         edtAccountRangeStart.Text := FilterStartStr;
                         edtAccountRangeEnd.Text := FilterEndStr;

                         // MH 28/11/2013 v7.0.8 ABSEXCH-14797: Added Consumer Support
                         // Determine whether to show the Customer/Consumer inclusion options
                         If (DataType = dqmCustomer) Then
                         Begin
                           // Customers - Check Consumers are enabled and the user has permissions
                           If (COMTK.Status = tkOpen) And
                              ((COMTK.SystemSetup As ISystemSetup9).ssConsumersEnabled) And
                              (COMTK.Functions.entCheckSecurity(FDataQuery.UserName, uaConsumerDetailsAccess) = 0) Then
                           Begin
                             // Customers or Consumers
                             chkIncludeCustomers.Checked := True;
                             chkIncludeConsumers.Checked := True;
                           End // If (COMTK.Status = tkOpen) And (...
                           Else
                           Begin
                             // Customers Only - hide options
                             lblSelectAcType.Visible := False;
                             chkIncludeCustomers.Visible := False;
                             chkIncludeConsumers.Visible := False;
                           End; // Else
                         End //
                         Else
                         Begin
                           // Suppliers
                           lblSelectAcType.Visible := False;
                           chkIncludeCustomers.Visible := False;
                           chkIncludeConsumers.Visible := False;
                         End; // Else
                       End;

      dqmCostCentre,
      dqmDepartment  : Begin
                         // Select correct page
                         nbFilters.ActivePage := 'CCDept';

                         // Set topical description
                         chkCCDeptRange.Caption := chkCCDeptRange.Caption + FDataQuery.TypeDesc[tdsDataSingular] + ' Code';

                         // Initialise the Range section
                         chkCCDeptRange.Checked := FilterByRange;
                         chkCCDeptRangeClick(chkCCDeptRange);

                         edtCCDeptRangeStart.Text := FilterStartStr;
                         edtCCDeptRangeEnd.Text := FilterEndStr;
                       End;


      dqmLocation    : Begin
                         // Select correct page
                         nbFilters.ActivePage := 'Location';

                         // Initialise the Location Range section
                         chkLocationRange.Checked := FilterByRange;
                         chkLocationRangeClick(chkLocationRange);

                         edtLocationRangeStart.Text := FilterStartStr;
                         edtLocationRangeEnd.Text := FilterEndStr;
                       End;

      dqmGLCode      : Begin
                         // Set Custom Size
                         ClientHeight := 310;

                         // Select correct page
                         nbFilters.ActivePage := 'GLCode';

                         // Initialise the GL Parent section
                         chkGLParent.Checked := FilterByParent;
                         chkGLParentClick(chkGLParent);

                         edtGLParent.Text := FilterParentStr;
                         chkGLFirstLevel.Checked := FilterLevel1Only;

                         // Initialise the GL Type section
                         chkGLType.Checked := FilterByType;
                         chkGLTypeClick(chkGLType);

                         chkGLProfitLoss.Checked := FilterGLTypes[glTypeProfitLoss];
                         chkGLBalSheet.Checked := FilterGLTypes[glTypeBalanceSheet];
                         chkGLControl.Checked := FilterGLTypes[glTypeControl];
                         chkGLCarryFwd.Checked := FilterGLTypes[glTypeCarryFwd];
                         chkGLHeading.Checked := FilterGLTypes[glTypeHeading];
                       End;

      dqmJob         : Begin
                         // Set Custom Size
                         ClientHeight := 420;

                         // Select correct page
                         nbFilters.ActivePage := 'Job';

                         // Initialise the Job Parent section
                         chkJobParent.Checked := FilterByParent;
                         chkJobParentClick(chkJobParent);

                         edtJobParent.Text := FilterParentStr;
                         chkJobLevel1Only.Checked := FilterLevel1Only;

                         // Initialise the Job Range section
                         chkJobRange.Checked := FilterByRange;
                         chkJobRangeClick(chkJobRange);

                         edtJobRangeStart.Text := FilterStartStr;
                         edtJobRangeEnd.Text := FilterEndStr;

                         // Initialise the Job Type section
                         chkJobType.Checked := FilterByType;
                         chkJobTypeClick(chkJobType);

                         chkJobJobs.Checked := FilterJobTypes[JTypeJob];
                         chkJobContracts.Checked := FilterJobTypes[JTypeContract];

                         // Initialise the Job Status section
                         chkJobStatus.Checked := FilterByStatus;
                         chkJobStatusClick(chkJobStatus);

                         chkJobsQuotation.Checked := FilterJobStatus[JStatusQuotation];
                         chkJobsActive.Checked := FilterJobStatus[JStatusActive];
                         chkJobsSuspended.Checked := FilterJobStatus[JStatusSuspended];
                         chkJobsCompleted.Checked := FilterJobStatus[JStatusCompleted];
                         chkJobsClosed.Checked := FilterJobStatus[JStatusClosed];
                       End;

      dqmStock       : Begin
                         // Set Custom Size
                         ClientHeight := 371;

                         // Select correct page
                         nbFilters.ActivePage := 'Stock';

                         // Initialise the Stock Parent section
                         chkStockParent.Checked := FilterByParent;
                         chkStockParentClick(chkStockParent);

                         edtStockParent.Text := FilterParentStr;
                         chkStockLevel1Only.Checked := FilterLevel1Only;

                         // Initialise the Stock Range section
                         chkStockRange.Checked := FilterByRange;
                         chkStockRangeClick(chkStockRange);

                         edtStockRangeStart.Text := FilterStartStr;
                         edtStockRangeEnd.Text := FilterEndStr;

                         // Initialise the Stock Type section
                         chkStockType.Checked := FilterByType;
                         chkStockTypeClick(chkStockType);

                         chkStockProduct.Checked := FilterStockTypes[stTypeProduct];
                         chkStockGroup.Checked := FilterStockTypes[stTypeGroup];
                         chkStockDescOnly.Checked := FilterStockTypes[stTypeDescription];
                         chkStockBOM.Checked := FilterStockTypes[stTypeBillOfMaterials];
                         chkStockDiscontinued.Checked := FilterStockTypes[stTypeDiscontinued];
                       End;
    End; { Case FDataQuery.DataType }
End; { ConfigControls }

//-----------------------------------------------------------------------------------------

Procedure TfrmFilterCritera.DoBitmapStuff;
Var
  FromRect, ToRect : TRect;
begin
  Image1.Picture.Bitmap.Height := Image1.Height;
  Image1.Picture.Bitmap.Width := Image1.Width;

  FromRect := Rect (0, imgSide.Picture.Height - Image1.Height, imgSide.Picture.Width, imgSide.Picture.Height);
  ToRect   := Rect (0, 0, Image1.Width, Image1.Height);

  DeleteObject(Image1.Picture.Bitmap.Palette);
  Image1.Picture.Bitmap.Palette:=CopyPalette(imgSide.Picture.Bitmap.Palette);
  Image1.Picture.Bitmap.Canvas.CopyRect(ToRect, imgSide.Picture.Bitmap.Canvas, FromRect);
end;

//-----------------------------------------------------------------------------------------

// Copies the fields from screen into the Data Query object
procedure TfrmFilterCritera.CopyFields;
begin { CopyFields }
  With FDataQuery Do
    Case DataType Of
      dqmCustomer,
      dqmSupplier    : Begin
                         // Range
                         FilterByRange := chkAccountRange.Checked;
                         FilterStartStr := Trim(edtAccountRangeStart.Text);
                         FilterEndStr := Trim(edtAccountRangeEnd.Text);
                       End;

      dqmCostCentre,
      dqmDepartment  : Begin
                         // Range
                         FilterByRange := chkCCDeptRange.Checked;
                         FilterStartStr := Trim(edtCCDeptRangeStart.Text);
                         FilterEndStr := Trim(edtCCDeptRangeEnd.Text);
                       End;

      dqmLocation    : Begin
                         // Range
                         FilterByRange := chkLocationRange.Checked;
                         FilterStartStr := Trim(edtLocationRangeStart.Text);
                         FilterEndStr := Trim(edtLocationRangeEnd.Text);
                       End;

      dqmGLCode     : Begin
                         // Parent
                         FilterByParent := chkGLParent.Checked;
                         FilterParentStr := Trim(edtGLParent.Text);
                         FilterLevel1Only := chkGLFirstLevel.Checked;

                         // Type
                         FilterByType := chkGLType.Checked;
                         FilterGLTypes[glTypeProfitLoss] := chkGLProfitLoss.Checked;
                         FilterGLTypes[glTypeBalanceSheet] := chkGLBalSheet.Checked;
                         FilterGLTypes[glTypeControl] := chkGLControl.Checked;
                         FilterGLTypes[glTypeCarryFwd] := chkGLCarryFwd.Checked;
                         FilterGLTypes[glTypeHeading] := chkGLHeading.Checked;
                       End;


      dqmJob         : Begin
                         // Parent
                         FilterByParent := chkJobParent.Checked;
                         FilterParentStr := edtJobParent.Text;
                         FilterLevel1Only := chkJobLevel1Only.Checked;

                         // Range
                         FilterByRange := chkJobRange.Checked;
                         FilterStartStr := edtJobRangeStart.Text;
                         FilterEndStr := edtJobRangeEnd.Text;

                         // Type
                         FilterByType := chkJobType.Checked;
                         FilterJobTypes[JTypeJob] := chkJobJobs.Checked;
                         FilterJobTypes[JTypeContract] := chkJobContracts.Checked;

                         // Status
                         FilterByStatus := chkJobStatus.Checked;
                         FilterJobStatus[JStatusQuotation] := chkJobsQuotation.Checked;
                         FilterJobStatus[JStatusActive] := chkJobsActive.Checked;
                         FilterJobStatus[JStatusSuspended] := chkJobsSuspended.Checked;
                         FilterJobStatus[JStatusCompleted] := chkJobsCompleted.Checked;
                         FilterJobStatus[JStatusClosed] := chkJobsClosed.Checked;
                       End;

      dqmStock       : Begin
                         // Parent
                         FilterByParent := chkStockParent.Checked;
                         FilterParentStr := edtStockParent.Text;
                         FilterLevel1Only := chkStockLevel1Only.Checked;

                         // Range
                         FilterByRange := chkStockRange.Checked;
                         FilterStartStr := edtStockRangeStart.Text;
                         FilterEndStr := edtStockRangeEnd.Text;

                         // Type
                         FilterByType := chkStockType.Checked;
                         FilterStockTypes[stTypeProduct] := chkStockProduct.Checked;
                         FilterStockTypes[stTypeGroup] := chkStockGroup.Checked;
                         FilterStockTypes[stTypeDescription] := chkStockDescOnly.Checked;
                         FilterStockTypes[stTypeBillOfMaterials] := chkStockBOM.Checked;
                         FilterStockTypes[stTypeDiscontinued] := chkStockDiscontinued.Checked;
                       End;
    End; { Case DataType }
End; { CopyFields }

//-----------------------------------------------------------------------------------------

procedure TfrmFilterCritera.btnNextClick(Sender: TObject);
Var
  OK     : Boolean;
  LI     : LongInt;

  //------------------------

  Function ValidGLCode (Const GLStr : ShortString; Var TheGLCode : LongInt; Const Validate : Boolean) : Boolean;
  Var
    FuncRes : LongInt;
    ErrCode : Integer;
  Begin { ValidGLCode }
    // Convert String to Long Integer
    Val (GLStr, TheGLCode, ErrCode);
    Result := (ErrCode = 0);

    If Result And Validate And (TheGLCode <> 0) Then
      // Validate the GL Code using the COM Toolkit
      With FDataQuery.COMTK.GeneralLedger Do Begin
        FuncRes := GetEqual (BuildCodeIndex(TheGLCode));
        Result := (FuncRes = 0);
      End; { With FDataQuery.COMTK.GeneralLedger }
  End; { ValidGLCode }

  //------------------------

  Function ValidJobCode (Const JobStr : ShortString) : Boolean;
  Var
    FuncRes : LongInt;
  Begin { ValidJobCode }
    // Validate the Job Code using the COM Toolkit
    With FDataQuery.COMTK.JobCosting.Job Do Begin
      FuncRes := GetEqual (BuildCodeIndex(JobStr));
      Result := (FuncRes = 0);
    End; { With FDataQuery.COMTK.JobCosting.Job }
  End; { ValidJobCode }

  //------------------------

  Function ValidStockCode (Const StockStr : ShortString) : Boolean;
  Var
    FuncRes : LongInt;
  Begin { ValidStockCode }
    // Validate the Stock Code using the COM Toolkit
    With FDataQuery.COMTK.Stock Do Begin
      FuncRes := GetEqual (BuildCodeIndex(StockStr));
      Result := (FuncRes = 0);
    End; { With FDataQuery.COMTK.Stock }
  End; { ValidStockCode }

  //------------------------

begin
  OK := True;

  // Update FDataQuery from the form
  CopyFields;

  // Do type specific validation
  With FDataQuery Do
    Case DataType Of
      dqmCustomer,
      dqmSupplier    : Begin
                         If FilterByRange Then Begin
                           // Validate Start/End strings
                           OK := (FilterStartStr <= FilterEndStr);
                           If (Not OK) Then Begin
                             MessageDlg ('The Starting Range Code must be before the Ending Range Code', mtError, [mbOk], 0);
                             If edtAccountRangeStart.CanFocus Then edtAccountRangeStart.SetFocus;
                           End; { If (Not OK) }
                         End; { If chkAccountRange.Checked }

                         // MH 28/11/2013 v7.0.8 ABSEXCH-14797: Added Consumer Support
                         If (DataType = dqmCustomer) Then
                         Begin
                           // Check whether Consumers are available
                           If (chkIncludeConsumers.Visible) Then
                           Begin
                             // Customers or Consumers
                             IncludeAccountTypes := [];
                             If chkIncludeCustomers.Checked Then
                               IncludeAccountTypes := IncludeAccountTypes + [Ord(asCustomer)];
                             If chkIncludeConsumers.Checked Then
                               IncludeAccountTypes := IncludeAccountTypes + [Ord(asConsumer)];
                           End // If (chkIncludeConsumers.Visible)
                           Else
                             // Customers Only
                             IncludeAccountTypes := [Ord(asCustomer)];
                         End //
                         Else
                           // Suppliers
                           IncludeAccountTypes := [Ord(asSupplier)];
                       End;

      dqmCostCentre,
      dqmDepartment  : Begin
                         If FilterByRange Then Begin
                           // Validate Start/End strings
                           OK := (FilterStartStr <= FilterEndStr);
                           If (Not OK) Then Begin
                             MessageDlg ('The Starting Range Code must be before the Ending Range Code', mtError, [mbOk], 0);
                             If edtCCDeptRangeStart.CanFocus Then edtCCDeptRangeStart.SetFocus;
                           End; { If (Not OK) }
                         End; { If chkCCDeptRange.Checked }
                       End;

      dqmLocation    : Begin
                         If FilterByRange Then Begin
                           // Validate Start/End strings
                           OK := (FilterStartStr <= FilterEndStr);
                           If (Not OK) Then Begin
                             MessageDlg ('The Starting Range Code must be before the Ending Range Code', mtError, [mbOk], 0);
                             If edtLocationRangeStart.CanFocus Then edtLocationRangeStart.SetFocus;
                           End; { If (Not OK) }
                         End; { If chkLocationRange.Checked }
                       End;

      dqmGLCode     : Begin
                         // Parent
                         If FilterByParent Then Begin
                           // Validate the Parent GL Code and convert to Long
                           If Not ValidGLCode (FilterParentStr, LI, True) Then Begin
                             OK := False;
                             MessageDlg ('The Parent GL Code is not a valid GL Code', mtError, [mbOk], 0);
                             If edtGLParent.CanFocus Then edtGLParent.SetFocus;
                           End { If Not ValidGLCode}
                           Else
                             FilterParentLong := LI;
                         End; { If FilterByParent }

                         // Type
                         If OK And FilterByType Then Begin
                           // Ensure at least one type is selected
                           OK := FilterGLTypes[glTypeProfitLoss] Or
                                 FilterGLTypes[glTypeBalanceSheet] Or
                                 FilterGLTypes[glTypeControl] Or
                                 FilterGLTypes[glTypeCarryFwd] Or
                                 FilterGLTypes[glTypeHeading];
                           If (Not OK) Then Begin
                             MessageDlg ('At least one GL Type must be included within the GL Type Filter', mtError, [mbOk], 0);
                             If chkGLProfitLoss.CanFocus Then chkGLProfitLoss.SetFocus;
                           End; { If (Not OK) }
                         End; { If OK And FilterByType }
                       End;

      dqmJob         : Begin
                         // Parent
                         If FilterByParent Then Begin
                           // Validate the Parent Job Code
                           If (Trim(FilterParentStr) <> '') Then
                             // Not blank - check its a valid Job Code
                             If Not ValidJobCode (FilterParentStr) Then Begin
                               OK := False;
                               MessageDlg ('The Parent Job Code is not valid', mtError, [mbOk], 0);
                               If edtJobParent.CanFocus Then edtJobParent.SetFocus;
                             End; { If Not ValidJobCode }
                         End; { If FilterByParent }

                         // Range
                         If OK And FilterByRange Then Begin
                           // Validate Start/End strings
                           OK := (FilterStartStr <= FilterEndStr);
                           If (Not OK) Then Begin
                             MessageDlg ('The Starting Range Code must be before the Ending Range Code', mtError, [mbOk], 0);
                             If edtJobRangeStart.CanFocus Then edtJobRangeStart.SetFocus;
                           End; { If (Not OK) }
                         End; { If OK And FilterByRange }

                         // Type
                         If OK And FilterByType Then Begin
                           // Ensure at least one type is selected
                           OK := FilterJobTypes[JTypeJob] Or FilterJobTypes[JTypeContract];
                           If (Not OK) Then Begin
                             MessageDlg ('At least one Job Type must be included within the Job Type Filter', mtError, [mbOk], 0);
                             If chkJobJobs.CanFocus Then chkJobJobs.SetFocus;
                           End; { If (Not OK) }
                         End; { If OK And FilterByType }
                       End;

      dqmStock       : Begin
                         // Parent
                         If FilterByParent Then Begin
                           // Validate the Parent Job Code
                           If (Trim(FilterParentStr) <> '') Then
                             // Not blank - check its a valid Stock Code
                             If Not ValidStockCode (FilterParentStr) Then Begin
                               OK := False;
                               MessageDlg ('The Parent Stock Code is not valid', mtError, [mbOk], 0);
                               If edtStockParent.CanFocus Then edtStockParent.SetFocus;
                             End; { If Not ValidStockCode }
                         End; { If FilterByParent }

                         // Range
                         If OK And FilterByRange Then Begin
                           // Validate Start/End strings
                           OK := (FilterStartStr <= FilterEndStr);
                           If (Not OK) Then Begin
                             MessageDlg ('The Starting Range Code must be before the Ending Range Code', mtError, [mbOk], 0);
                             If edtStockRangeStart.CanFocus Then edtStockRangeStart.SetFocus;
                           End; { If (Not OK) }
                         End; { If OK And FilterByRange }

                         // Type
                         If OK And FilterByType Then Begin
                           // Ensure at least one type is selected
                           OK := FilterStockTypes[stTypeProduct] Or
                                 FilterStockTypes[stTypeGroup] Or
                                 FilterStockTypes[stTypeDescription] Or
                                 FilterStockTypes[stTypeBillOfMaterials] Or
                                 FilterStockTypes[stTypeDiscontinued];

                           If (Not OK) Then Begin
                             MessageDlg ('At least one Stock Type must be included within the Stock Type Filter', mtError, [mbOk], 0);
                             If chkStockProduct.CanFocus Then chkStockProduct.SetFocus;
                           End; { If (Not OK) }
                         End; { If OK And FilterByType }
                       End;
    End; { Case DataType }

  If OK Then Begin
    ExitCode := 'N';
    Close;
  End; { If OK }
end;

//-----------------------------------------------------------------------------------------

procedure TfrmFilterCritera.btnCloseClick(Sender: TObject);
begin
  ExitCode := 'X';
  Close;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmFilterCritera.btnBackClick(Sender: TObject);
begin
  // Make a copy of any data entered so it isn't lost
  CopyFields;

  ExitCode := 'B';
  Close;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmFilterCritera.chkAccountRangeClick(Sender: TObject);
begin
  // Enable/Disable Edit Boxes and Labels depending on the CheckBox state
  edtAccountRangeStart.Enabled := chkAccountRange.Checked;
  edtAccountRangeEnd.Enabled := edtAccountRangeStart.Enabled;

  lblAccountRangeStart.Enabled := edtAccountRangeStart.Enabled;
  lblAccountRangeEnd.Enabled := edtAccountRangeStart.Enabled;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmFilterCritera.chkCCDeptRangeClick(Sender: TObject);
begin
  // Enable/Disable Edit Boxes and Labels depending on the CheckBox state
  edtCCDeptRangeStart.Enabled := chkCCDeptRange.Checked;
  edtCCDeptRangeEnd.Enabled := edtCCDeptRangeStart.Enabled;

  lblCCDeptRangeStart.Enabled := edtCCDeptRangeStart.Enabled;
  lblCCDeptRangeEnd.Enabled := edtCCDeptRangeStart.Enabled;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmFilterCritera.chkLocationRangeClick(Sender: TObject);
begin
  // Enable/Disable Edit Boxes and Labels depending on the CheckBox state
  edtLocationRangeStart.Enabled := chkLocationRange.Checked;
  edtLocationRangeEnd.Enabled := edtLocationRangeStart.Enabled;

  lblLocationRangeStart.Enabled := edtLocationRangeStart.Enabled;
  lblLocationRangeEnd.Enabled := edtLocationRangeStart.Enabled;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmFilterCritera.chkGLParentClick(Sender: TObject);
begin
  // Enable/Disable Edit Boxes and Labels depending on the CheckBox state
  edtGLParent.Enabled := chkGLParent.Checked;
  lblGLParent.Enabled := edtGLParent.Enabled;
  chkGLFirstLevel.Enabled := edtGLParent.Enabled;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmFilterCritera.chkGLTypeClick(Sender: TObject);
begin
  // Enable/Disable Edit Boxes and Labels depending on the CheckBox state
  chkGLProfitLoss.Enabled := chkGLType.Checked;
  chkGLBalSheet.Enabled := chkGLProfitLoss.Enabled;
  chkGLControl.Enabled := chkGLProfitLoss.Enabled;
  chkGLCarryFwd.Enabled := chkGLProfitLoss.Enabled;
  chkGLHeading.Enabled := chkGLProfitLoss.Enabled;
  lblGLType.Enabled := chkGLProfitLoss.Enabled;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmFilterCritera.chkJobRangeClick(Sender: TObject);
begin
  // Enable/Disable Edit Boxes and Labels depending on the CheckBox state
  edtJobRangeStart.Enabled := chkJobRange.Checked;
  edtJobRangeEnd.Enabled := edtJobRangeStart.Enabled;

  lblJobRangeStart.Enabled := edtJobRangeStart.Enabled;
  lblJobRangeEnd.Enabled := edtJobRangeStart.Enabled;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmFilterCritera.chkJobParentClick(Sender: TObject);
begin
  // Enable/Disable Edit Boxes and Labels depending on the CheckBox state
  edtJobParent.Enabled := chkJobParent.Checked;
  lblJobParent.Enabled := edtJobParent.Enabled;
  chkJobLevel1Only.Enabled := edtJobParent.Enabled;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmFilterCritera.chkJobTypeClick(Sender: TObject);
begin
  // Enable/Disable Edit Boxes and Labels depending on the CheckBox state
  chkJobJobs.Enabled := chkJobType.Checked;
  chkJobContracts.Enabled := chkJobJobs.Enabled;
  lblJobType.Enabled := chkJobJobs.Enabled;
end;

//-------------------------------------------------------------------------

procedure TfrmFilterCritera.chkJobStatusClick(Sender: TObject);
begin
  // Enable/Disable Edit Boxes and Labels depending on the CheckBox state
  chkJobsQuotation.Enabled := chkJobStatus.Checked;
  chkJobsActive.Enabled := chkJobsQuotation.Enabled;
  chkJobsSuspended.Enabled := chkJobsQuotation.Enabled;
  chkJobsCompleted.Enabled := chkJobsQuotation.Enabled;
  chkJobsClosed.Enabled := chkJobsQuotation.Enabled;
  lblJobStatus.Enabled := chkJobsQuotation.Enabled;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmFilterCritera.chkStockParentClick(Sender: TObject);
begin
  // Enable/Disable Edit Boxes and Labels depending on the CheckBox state
  edtStockParent.Enabled := chkStockParent.Checked;
  lblStockParent.Enabled := edtStockParent.Enabled;
  chkStockLevel1Only.Enabled := edtStockParent.Enabled;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmFilterCritera.chkStockRangeClick(Sender: TObject);
begin
  // Enable/Disable Edit Boxes and Labels depending on the CheckBox state
  edtStockRangeStart.Enabled := chkStockRange.Checked;
  edtStockRangeEnd.Enabled := edtStockRangeStart.Enabled;

  lblStockRangeStart.Enabled := edtStockRangeStart.Enabled;
  lblStockRangeEnd.Enabled := edtStockRangeStart.Enabled;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmFilterCritera.chkStockTypeClick(Sender: TObject);
begin
  // Enable/Disable Edit Boxes and Labels depending on the CheckBox state
  lblStockType.Enabled := chkStockType.Checked;
  chkStockProduct.Enabled := lblStockType.Enabled;
  chkStockGroup.Enabled := lblStockType.Enabled;
  chkStockDescOnly.Enabled := lblStockType.Enabled;
  chkStockBOM.Enabled := lblStockType.Enabled;
  chkStockDiscontinued.Enabled := lblStockType.Enabled;
end;

//-----------------------------------------------------------------------------------------

procedure TfrmFilterCritera.btnHelpClick(Sender: TObject);
begin
  If (HelpContext <> 0) Then Begin
    If IsLibrary Then
      Application.HelpFile := 'EnterOle.Chm';
    Application.HelpContext (HelpContext);
  End; { If (HelpContext <> 0) }
end;

//-----------------------------------------------------------------------------------------

procedure TfrmFilterCritera.FormResize(Sender: TObject);
begin
  // Redraw the bitmap for the corrected size
  DoBitmapStuff;
end;


end.
