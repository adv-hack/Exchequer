unit ADMIN;

{ nfrewer440 17:10 08/12/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, ExtCtrls, uMultiList, Math, Menus, StrUtil, Enterprise01_TLB
  , FUPROC, APIUtil, DB, Grids, TKPickList, ComCtrls, EnterToTab, AddNote;

type
  TfrmAdmin = class(TForm)
    btnClose: TButton;
    cmbCompany: TComboBox;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Utilities1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Import1: TMenuItem;
    Update1: TMenuItem;
    Exit1: TMenuItem;
    pcTabs: TPageControl;
    tsLines: TTabSheet;
    tsHeader: TTabSheet;
    Label2: TLabel;
    edTransaction: TEdit;
    btnLoad: TButton;
    Label3: TLabel;
    lStatus: TLabel;
    Bevel1: TBevel;
    tsNotes: TTabSheet;
    EnterToTab1: TEnterToTab;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    lDueDate: TLabel;
    edHDueDate: TDateTimePicker;
    Bevel5: TBevel;
    Bevel6: TBevel;
    edHUDF1: TEdit;
    edHUDF2: TEdit;
    edHUDF3: TEdit;
    edHUDF4: TEdit;
    edLUDF1: TEdit;
    edLUDF2: TEdit;
    edLUDF3: TEdit;
    edLUDF4: TEdit;
    btnLSave: TButton;
    btnHSave: TButton;
    btnHReload: TButton;
    btnLReload: TButton;
    mlLines: TMultiList;
    Bevel7: TBevel;
    Label12: TLabel;
    Bevel8: TBevel;
    mlNotes: TMultiList;
    Bevel9: TBevel;
    btnNShow: TButton;
    btnNAdd: TButton;
    edHUDF5: TEdit;
    lHUDF5: TLabel;
    lHUDF6: TLabel;
    edHUDF6: TEdit;
    lHUDF7: TLabel;
    edHUDF7: TEdit;
    lHUDF8: TLabel;
    edHUDF8: TEdit;
    lHUDF9: TLabel;
    edHUDF9: TEdit;
    lHUDF10: TLabel;
    edHUDF10: TEdit;
    lLUDF5: TLabel;
    edLUDF5: TEdit;
    lLUDF6: TLabel;
    edLUDF6: TEdit;
    lLUDF7: TLabel;
    edLUDF7: TEdit;
    lLUDF8: TLabel;
    edLUDF8: TEdit;
    lLUDF9: TLabel;
    edLUDF9: TEdit;
    lLUDF10: TLabel;
    edLUDF10: TEdit;
    Bevel10: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mlSuppliersAfterLoad(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cmbCompanyChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnHReloadClick(Sender: TObject);
    procedure mlLinesChangeSelection(Sender: TObject);
    procedure btnLReloadClick(Sender: TObject);
    procedure btnLSaveClick(Sender: TObject);
    procedure btnHSaveClick(Sender: TObject);
    procedure btnNShowClick(Sender: TObject);
    procedure btnNAddClick(Sender: TObject);
  private
    v69orLater, bDatedNotes, bEditable : boolean;
    oTX : ITransaction;
    oTXLine : ITransactionLine;
    procedure EnableDisable;
    Procedure WMGetMinMaxInfo (Var Message : TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    Procedure TX2Form;
    procedure PopulateHeaderFields;
    procedure FillLineList;
    procedure PopulateLineFields;
    procedure PopulateNotes;
    function GetUpdateTX : ITransaction;
    procedure SaveUpdateTX(oUpdateTX : ITransaction);
  public
//    sCustCode : string;
  end;

var
  frmAdmin: TfrmAdmin;

implementation

uses
  FileUtil, PISecure, SecCodes, ComObj, ETStrU, ExchequerRelease;

{$R *.dfm}

procedure TfrmAdmin.FormCreate(Sender: TObject);

  procedure InitToolkit;
  var
    a, b, c : LongInt;
    iSelect, iPos : integer;
    CompanyInfo : TCompanyInfo;
  begin{InitToolkit}
    // Create COM Toolkit object
    oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

    // Check it created OK
    If Assigned(oToolkit) Then
    Begin

      EncodeOpCode(97, a, b, c);
      oToolkit.Configuration.SetDebugMode(a, b, c);
      oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;

      iSelect := 0;

      For iPos := 1 to oToolkit.Company.cmCount do
      begin
        CompanyInfo := TCompanyInfo.Create;
        CompanyInfo.CompanyRec.Path := Trim(oToolkit.Company.cmCompany[iPos].coPath);
        CompanyInfo.CompanyRec.Name := Trim(oToolkit.Company.cmCompany[iPos].coName);
        CompanyInfo.CompanyRec.Code := Trim(oToolkit.Company.cmCompany[iPos].coCode);
        cmbCompany.Items.AddObject(oToolkit.Company.cmCompany[iPos].coCode + ' - '
        + oToolkit.Company.cmCompany[iPos].coName, CompanyInfo);

        if WinGetShortPathName(CompanyInfo.CompanyRec.Path)
        = WinGetShortPathName(oToolkit.Enterprise.enCompanyPath)
        then iSelect := iPos-1;
      end;{for}

      if cmbCompany.Items.Count > 0 then
      begin
        cmbCompany.ItemIndex := iSelect;
        cmbCompanyChange(cmbCompany);
      end;
    End { If Assigned(oToolkit) }
    Else
      // Failed to create COM Object
      ShowMessage ('Cannot create COM Toolkit instance');
  end;{InitToolkit}

begin{FormCreate}
  Caption := sPlugInName;

  bDatedNotes := FALSE;
  oToolkit := nil;
  oTXLine := nil;
  oTX := nil;

  pcTabs.ActivePageIndex := 0;

  //Check Plug-In Security
  if PICheckSecurity(sPlugInCode, sSecurityCode, sPlugInName, '', stSystemOnly,
                     ptStandaloneEXE, ExtractFileName(Application.EXEName))
  then begin
    InitToolkit;
  end;{if}

  v69orLater := (oToolkit <> nil) and (oToolkit.Version > 'TKCOM-69');

  EnableDisable;
end;

procedure TfrmAdmin.FormShow(Sender: TObject);
begin
{  if cmbCompany.items.count > 0 then
  begin
    cmbCompany.ItemIndex := 0;
    cmbCompanyChange(cmbCompany);
  end;{if}

end;

procedure TfrmAdmin.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
{  With Message.MinMaxInfo^ Do Begin
    ptMinTrackSize.X:=350;
    ptMinTrackSize.Y:=250;
  End; { With Message }
end;

procedure TfrmAdmin.EnableDisable;
begin
  edHUDF1.ReadOnly := (oTX = nil) or (not bEditable);
  edHUDF2.ReadOnly := edHUDF1.ReadOnly;
  edHUDF3.ReadOnly := edHUDF1.ReadOnly;
  edHUDF4.ReadOnly := edHUDF1.ReadOnly;
  edHUDF5.ReadOnly := edHUDF1.ReadOnly;
  edHUDF5.Enabled := v69orLater;
  lHUDF5.Enabled := edHUDF5.Enabled;
  edHUDF6.ReadOnly := edHUDF1.ReadOnly;
  edHUDF6.Enabled := v69orLater;
  lHUDF6.Enabled := edHUDF6.Enabled;
  edHUDF7.ReadOnly := edHUDF1.ReadOnly;
  edHUDF7.Enabled := v69orLater;
  lHUDF7.Enabled := edHUDF7.Enabled;
  edHUDF8.ReadOnly := edHUDF1.ReadOnly;
  edHUDF8.Enabled := v69orLater;
  lHUDF8.Enabled := edHUDF8.Enabled;
  edHUDF9.ReadOnly := edHUDF1.ReadOnly;
  edHUDF9.Enabled := v69orLater;
  lHUDF9.Enabled := edHUDF9.Enabled;
  edHUDF10.ReadOnly := edHUDF1.ReadOnly;
  edHUDF10.Enabled := v69orLater;
  lHUDF10.Enabled := edHUDF10.Enabled;
  edHDueDate.Enabled := Assigned(oTX) and bEditable
  and (oTX.thDocType in [dtPIN, dtPPI, dtPJI, dtPCR, dtPQU, dtSIN, dtSRI, dtSJI, dtSCR, dtSQU]);
  lDueDate.Enabled := edHDueDate.Enabled;
  btnHSave.Enabled := Assigned(oTX) and bEditable;
  btnHReload.Enabled := btnHSave.Enabled;

  edLUDF1.ReadOnly := (oTXLine = nil) or (not bEditable);
  edLUDF2.ReadOnly := edLUDF1.ReadOnly;
  edLUDF3.ReadOnly := edLUDF1.ReadOnly;
  edLUDF4.ReadOnly := edLUDF1.ReadOnly;
  edLUDF5.ReadOnly := edLUDF1.ReadOnly;
  edLUDF5.Enabled := v69orLater;
  lLUDF5.Enabled := edLUDF5.Enabled;
  edLUDF6.ReadOnly := edLUDF1.ReadOnly;
  edLUDF6.Enabled := v69orLater;
  lLUDF6.Enabled := edLUDF6.Enabled;
  edLUDF7.ReadOnly := edLUDF1.ReadOnly;
  edLUDF7.Enabled := v69orLater;
  lLUDF7.Enabled := edLUDF7.Enabled;
  edLUDF8.ReadOnly := edLUDF1.ReadOnly;
  edLUDF8.Enabled := v69orLater;
  lLUDF8.Enabled := edLUDF8.Enabled;
  edLUDF9.ReadOnly := edLUDF1.ReadOnly;
  edLUDF9.Enabled := v69orLater;
  lLUDF9.Enabled := edLUDF9.Enabled;
  edLUDF10.ReadOnly := edLUDF1.ReadOnly;
  edLUDF10.Enabled := v69orLater;
  lLUDF10.Enabled := edLUDF10.Enabled;
  btnLSave.Enabled := Assigned(oTXLine) and bEditable;
  btnLReload.Enabled := btnLSave.Enabled;

  btnNShow.Enabled := Assigned(oTX) and bEditable;
  btnNAdd.Enabled := Assigned(oTX) and bEditable;
end;

procedure TfrmAdmin.mlSuppliersAfterLoad(Sender: TObject);
begin
  EnableDisable;
end;

procedure TfrmAdmin.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAdmin.FormResize(Sender: TObject);
begin
//  cmbCompany.Width := ClientWidth - 160;
end;

procedure TfrmAdmin.cmbCompanyChange(Sender: TObject);
var
  FuncRes : integer;
begin
  Screen.Cursor := crHourglass;

  if (oToolkit.Status = tkOpen) Then begin
    // Close all
    oToolkit.CloseToolkit;
//    CloseFiles;
//    mlSuppliers.Active := FALSE;
  end;{if}

  With oToolkit Do Begin
    // Open Default Company
    CompanyRec := TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).CompanyRec;
    oToolkit.Configuration.DataDirectory := CompanyRec.Path;

    FuncRes := OpenToolkit;

    // Check it opened OK
    If (FuncRes = 0) then
    begin
//      FillList(CompanyRec.Code);

    end
    else begin
      // Error opening Toolkit - display error
      ShowMessage ('The following error occurred opening the Toolkit:-'#13#13
      + QuotedStr(oToolkit.LastErrorString));
    end;{if}

  End; { With OToolkit }

  // blank TX details
  edTransaction.Text := '';
  oTX := nil;
  oTXLine := nil;
  TX2Form;

  EnableDisable;

  Screen.Cursor := crDefault;
end;


procedure TfrmAdmin.FormDestroy(Sender: TObject);
begin
  If Assigned(oToolkit) Then Begin
    // Close COM Toolkit and remove reference
    oToolkit.CloseToolkit;
    oToolkit := NIL;
  End; { If Assigned(oToolkit) }
end;

procedure TfrmAdmin.FormActivate(Sender: TObject);
begin
  if oToolkit = nil then close;
end;

procedure TfrmAdmin.About1Click(Sender: TObject);
begin
  MessageDlg(sPlugInName + #13#13 +
             ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + #13#13 +
             DoubleAmpers(GetCopyrightMessage) + #13 +
             'All rights reserved.', mtInformation, [mbOk], 0);
end;

procedure TfrmAdmin.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmAdmin.btnLoadClick(Sender: TObject);

  function PadOurRef(sOurRef : string) : string;
  begin{PadOurRef}
    Result := Copy(sOurRef, 1, 3) + PadString(psLeft, Copy(sOurRef, 4, 6), '0', 6);
  end;{PadOurRef}

var
  sOurRef : string;
  iStatus : integer;
begin
  sOurref := PadOurRef(edTransaction.Text);
  edTransaction.Text := sOurref;
  iStatus := oToolkit.Transaction.GetEqual(oToolkit.Transaction.BuildOurRefIndex(sOurRef));
  if iStatus = 0 then
  begin
    oTX := oToolkit.Transaction;
    TX2Form;
  end
  else
  begin
    MsgBox('Transaction could not be found : ' + sOurRef, mtInformation, [mbOK]
    , mbOK, 'Find Transaction (' + IntToStr(iStatus) + ')');
    oTX := nil;
    oTXLine := nil;
    TX2Form;
  end;{if}
end;

procedure TfrmAdmin.TX2Form;

  Procedure GetStatus;
  begin{GetStatus}
    if oTX = nil then
    begin
      lStatus.Caption := '(not found)';
    end
    else
    begin
      if (oTX.thRunNo > 0) then
      begin
        lStatus.Caption := 'Posted';
        bEditable := TRUE;
      end
      else
      begin
        Case oTX.thRunNo of
          -1, -2 :
          begin
            lStatus.Caption := 'Auto';
            bEditable := FALSE;
          end;

          -5 :
          begin
            lStatus.Caption := 'Paying in Control Identifier';
            bEditable := FALSE;
          end;

          -10 :
          begin
            lStatus.Caption := 'Member of a batch';
            bEditable := FALSE;
          end;

          -11 :
          begin
            lStatus.Caption := 'Posted Batch Header Record';
            bEditable := FALSE;
          end;

          -30 :
          begin
            lStatus.Caption := 'Posted ADJ';
            bEditable := TRUE;
          end;

          -35 :
          begin
            lStatus.Caption := 'Posted TSH';
            bEditable := TRUE;
          end;

          -40 :
          begin
            lStatus.Caption := 'Unposted (SOP)';
            bEditable := TRUE;
          end;

          -41 :
          begin
            lStatus.Caption := 'Unposted Auto (SOP)';
            bEditable := FALSE;
          end;

          -42 :
          begin
            lStatus.Caption := 'Posted (SOP)';
            bEditable := TRUE;
          end;

          -50 :
          begin
            lStatus.Caption := 'Unposted (POP)';
            bEditable := TRUE;
          end;

          -51 :
          begin
            lStatus.Caption := 'Unposted Auto (POP)';
            bEditable := FALSE;
          end;

          -52 :
          begin
            lStatus.Caption := 'Posted (POP)';
            bEditable := TRUE;
          end;

{          -60, -115, -118, -125, -128 :
          begin
            lStatus.Caption := 'UnPosted';
            bEditable := TRUE;
          end;}

          -62, -116, -119, -126, -129 :
          begin
            lStatus.Caption := 'Posted';
            bEditable := TRUE;
          end;

          // ALL OTHER 0 or -VE run nos
          else begin
            lStatus.Caption := 'Unposted';
            bEditable := TRUE;
          end;
        end;{case}
      end;{if}
    end;{if}
  end;{GetStatus}

begin
  GetStatus;
  PopulateHeaderFields;
  FillLineList;
  PopulateNotes;

  if Assigned(oTX) and (oTX.thDocType = dtTSH)
  then mlLines.DesignColumns[0].Caption := 'Job Code'
  else mlLines.DesignColumns[0].Caption := 'Stock Code';

  EnableDisable;
end;

procedure TfrmAdmin.PopulateHeaderFields;
begin
  if oTX = nil then
  begin
    edHUDF1.Text := '';
    edHUDF2.Text := '';
    edHUDF3.Text := '';
    edHUDF4.Text := '';
    edHUDF5.Text := '';
    edHUDF6.Text := '';
    edHUDF7.Text := '';
    edHUDF8.Text := '';
    edHUDF9.Text := '';
    edHUDF10.Text := '';
    edHDueDate.Date := 0;
  end
  else
  begin
    edHUDF1.Text := Trim(oTX.thUserField1);
    edHUDF2.Text := Trim(oTX.thUserField2);
    edHUDF3.Text := Trim(oTX.thUserField3);
    edHUDF4.Text := Trim(oTX.thUserField4);

    if v69orLater then
    begin
      edHUDF5.Text := Trim(ITransaction9(oTX).thUserField5);
      edHUDF6.Text := Trim(ITransaction9(oTX).thUserField6);
      edHUDF7.Text := Trim(ITransaction9(oTX).thUserField7);
      edHUDF8.Text := Trim(ITransaction9(oTX).thUserField8);
      edHUDF9.Text := Trim(ITransaction9(oTX).thUserField9);
      edHUDF10.Text := Trim(ITransaction9(oTX).thUserField10);
    end;{if}
    edHDueDate.Date := Str8ToDate(oTX.thDueDate);
  end;{if}
end;

procedure TfrmAdmin.PopulateLineFields;
begin
  if oTXLine = nil then
  begin
    edLUDF1.Text := '';
    edLUDF2.Text := '';
    edLUDF3.Text := '';
    edLUDF4.Text := '';
    edLUDF5.Text := '';
    edLUDF6.Text := '';
    edLUDF7.Text := '';
    edLUDF8.Text := '';
    edLUDF9.Text := '';
    edLUDF10.Text := '';
  end
  else
  begin
    edLUDF1.Text := oTXLine.tlUserField1;
    edLUDF2.Text := oTXLine.tlUserField2;
    edLUDF3.Text := oTXLine.tlUserField3;
    edLUDF4.Text := oTXLine.tlUserField4;

    if v69orLater then
    begin
      edLUDF5.Text := ITransactionLine9(oTXLine).tlUserField5;
      edLUDF6.Text := ITransactionLine9(oTXLine).tlUserField6;
      edLUDF7.Text := ITransactionLine9(oTXLine).tlUserField7;
      edLUDF8.Text := ITransactionLine9(oTXLine).tlUserField8;
      edLUDF9.Text := ITransactionLine9(oTXLine).tlUserField9;
      edLUDF10.Text := ITransactionLine9(oTXLine).tlUserField10;
    end;{if}
  end;{if}
end;

procedure TfrmAdmin.btnHReloadClick(Sender: TObject);
begin
  PopulateHeaderFields;
end;

procedure TfrmAdmin.FillLineList;
var
  iDecs, iLine : integer;
begin
  mlLines.ClearItems;
  if assigned(oTX) then
  begin
    For iLine := 1 to oTX.thLines.thLineCount do
    begin
      // Stock code
      case oTX.thDocType of
        dtNMT :
        begin
          mlLines.DesignColumns[0].Items.Add('');
        end;

        dtTSH :
        begin
          mlLines.DesignColumns[0].Items.Add(oTX.thLines.thLine[iLine].tlJobCode);
        end;

        else
        begin
          mlLines.DesignColumns[0].Items.Add(oTX.thLines.thLine[iLine].tlStockCode);
        end;
      end;{case}

      // Description
      case oTX.thDocType of
        dtADJ, dtWOR, dtTSH :
        begin
          mlLines.DesignColumns[1].Items.Add('');
        end;

        else
        begin
          mlLines.DesignColumns[1].Items.Add(oTX.thLines.thLine[iLine].tlDescr);
        end;
      end;{case}

      // Description
      case oTX.thDocType of
        dtNMT :
        begin
          mlLines.DesignColumns[2].Items.Add('');
        end;

        else
        begin
          mlLines.DesignColumns[2].Items.Add(MoneyToStr(oTX.thLines.thLine[iLine].tlQty
          , oToolkit.SystemSetup.ssQtyDecimals));
        end;
      end;{case}

      // Line Total
      mlLines.DesignColumns[3].Items.Add(MoneyToStr(oTX.thLines.thLine[iLine].entLineTotal(TRUE
      , oTX.thSettleDiscPerc), 2));
    end;{for}
    if mlLines.ItemsCount > 0 then mlLines.Selected := 0;
  end
  else
  begin
    // Blank Line fields;
    PopulateLineFields;
  end;{if}
end;

procedure TfrmAdmin.mlLinesChangeSelection(Sender: TObject);
begin
  oTXLine := oTX.thLines.thLine[mlLines.Selected+1];
  PopulateLineFields;
end;

procedure TfrmAdmin.btnLReloadClick(Sender: TObject);
begin
  PopulateLineFields;
end;

procedure TfrmAdmin.btnLSaveClick(Sender: TObject);
var
  oUpdateTX : ITransaction;
  iLine : integer;
begin
  iLine := mlLines.Selected+1;
  oUpdateTX := GetUpdateTX;
  if Assigned(oUpdateTX) then
  begin
    oUpdateTX.thLines.thLine[iLine].tlUserField1 := edLUDF1.Text;
    oUpdateTX.thLines.thLine[iLine].tlUserField2 := edLUDF2.Text;
    oUpdateTX.thLines.thLine[iLine].tlUserField3 := edLUDF3.Text;
    oUpdateTX.thLines.thLine[iLine].tlUserField4 := edLUDF4.Text;

    if v69orLater then
    begin
      ITransactionLine9(oUpdateTX.thLines.thLine[iLine]).tlUserField5 := edLUDF5.Text;
      ITransactionLine9(oUpdateTX.thLines.thLine[iLine]).tlUserField6 := edLUDF6.Text;
      ITransactionLine9(oUpdateTX.thLines.thLine[iLine]).tlUserField7 := edLUDF7.Text;
      ITransactionLine9(oUpdateTX.thLines.thLine[iLine]).tlUserField8 := edLUDF8.Text;
      ITransactionLine9(oUpdateTX.thLines.thLine[iLine]).tlUserField9 := edLUDF9.Text;
      ITransactionLine9(oUpdateTX.thLines.thLine[iLine]).tlUserField10 := edLUDF10.Text;
    end;{if}

    SaveUpdateTX(oUpdateTX);
    btnLoadClick(nil);
    mlLines.Selected := iLine-1;
  end;{if}
end;

procedure TfrmAdmin.SaveUpdateTX(oUpdateTX : ITransaction);
var
  iStatus : integer;
begin
  iStatus := oUpdateTX.Save(FALSE);
  if iStatus = 0 then
  begin
    MsgBox('Transaction Successfully Updated.', mtConfirmation, [mbOK], mbOK
    , 'Save Transaction');
  end
  else
  begin
    MsgBox('An error occurred when saving this transaction.'
    + #13#13'Error : ' + IntToStr(iStatus) + ' - ' + oToolkit.LastErrorString
    , mtError, [mbOK], mbOK
    , 'Save Transaction');
  end;
end;

function TfrmAdmin.GetUpdateTX : ITransaction;
var
  iStatus : integer;
begin
  if oTX.thDocType in [dtSQU, dtPQU] then
  begin
    // Use Update, as UpdateEx will not allow duedate updates on Quotes
    Result := oTX.Update;
    if Result = nil then
    begin
      MsgBox('An error occurred when getting the update object for this transaction.'
      , mtError, [mbOK], mbOK, 'Transaction - Update');
    end;{if}
  end
  else
  begin
    Result := ITransaction6(oTX).UpdateEx(umDefault);
    if Result = nil then
    begin
      MsgBox('An error occurred when getting the update object for this transaction.'
      , mtError, [mbOK], mbOK, 'Transaction - UpdateEx');
    end;{if}
  end;{if}
end;

procedure TfrmAdmin.btnHSaveClick(Sender: TObject);
var
  oUpdateTX : ITransaction;
begin
  oUpdateTX := GetUpdateTX;
  if Assigned(oUpdateTX) then
  begin
    oUpdateTX.thUserField1 := edHUDF1.Text;
    oUpdateTX.thUserField2 := edHUDF2.Text;
    oUpdateTX.thUserField3 := edHUDF3.Text;
    oUpdateTX.thUserField4 := edHUDF4.Text;

    if v69orLater then
    begin
      ITransaction9(oUpdateTX).thUserField5 := edHUDF5.Text;
      ITransaction9(oUpdateTX).thUserField6 := edHUDF6.Text;
      ITransaction9(oUpdateTX).thUserField7 := edHUDF7.Text;
      ITransaction9(oUpdateTX).thUserField8 := edHUDF8.Text;
      ITransaction9(oUpdateTX).thUserField9 := edHUDF9.Text;
      ITransaction9(oUpdateTX).thUserField10 := edHUDF10.Text;
    end;{if}

    if edHDueDate.Enabled then oUpdateTX.thDueDate := DateToStr8(edHDueDate.Date);
    SaveUpdateTX(oUpdateTX);
    btnLoadClick(nil);
  end;{if}
end;

procedure TfrmAdmin.PopulateNotes;
var
  iStatus : integer;
begin
  mlNotes.ClearItems;
  mlNotes.DesignColumns[0].Visible := bDatedNotes;
  if Assigned(oTX) then
  begin
    if bDatedNotes then oTX.thNotes.ntType := ntTypeDated
    else oTX.thNotes.ntType := ntTypeGeneral;

    iStatus := oTX.thNotes.GetFirst;
    while iStatus = 0 do
    begin
      if bDatedNotes then
      begin
        mlNotes.DesignColumns[0].Items.Add(Str8ToScreenDate(oTX.thNotes.ntDate));
        mlNotes.DesignColumns[1].Items.Add(oTX.thNotes.ntText);
      end
      else
      begin
        mlNotes.DesignColumns[0].Items.Add('');
        mlNotes.DesignColumns[1].Items.Add(oTX.thNotes.ntText);
      end;{if}

      // Get Next
      iStatus := oTX.thNotes.GetNext;
    end;{while}
    if mlNotes.ItemsCount > 0 then mlNotes.Selected := 0; 
  end;{if}
end;


procedure TfrmAdmin.btnNShowClick(Sender: TObject);
begin
  if bDatedNotes then btnNShow.Caption := '&Show Dated'
  else btnNShow.Caption := '&Show General';
  bDatedNotes := not bDatedNotes;
  PopulateNotes;
end;

procedure TfrmAdmin.btnNAddClick(Sender: TObject);
var
  iNewNoteNo, iStatus : integer;
  oNote : INotes;
begin
  frmAddNote := TfrmAddNote.Create(self);
  frmAddNote.edDate.Date := Date;
  frmAddNote.edDate.Enabled := bDatedNotes;
  frmAddNote.lDate.Enabled := bDatedNotes;
  if frmAddNote.ShowModal = mrOK then
  begin
    oTX.thNotes.GetLast;
    iNewNoteNo := oTX.thNotes.ntLineNo+1;

    oNote := oTX.thNotes.Add;
    if Assigned(oNote) then
    begin
      if bDatedNotes then oNote.ntDate := DateToStr8(frmAddNote.edDate.Date);
      oNote.ntText := frmAddNote.edText.Text;
      oNote.ntLineNo := iNewNoteNo;
      iStatus := oNote.Save;
      if iStatus = 0 then
      begin
        PopulateNotes;
      end
      else
      begin
        MsgBox('Error : Unable to save a new note to this transaction.'#13#13
        + 'Error : ' + IntToStr(iStatus), mtError, [mbOK], mbOK, 'Save Note');
      end;
    end
    else
    begin
      MsgBox('Error : Unable to add a note to this transaction.', mtError, [mbOK], mbOK, 'Add Note');
    end;{if}
  end;
  frmAddNote.Release;
end;

end.

