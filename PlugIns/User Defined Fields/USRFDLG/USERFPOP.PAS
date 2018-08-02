unit USERFPOP;

{ nfrewer440 09:41 03/09/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  CustAbsU, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , StdCtrls, {IniFiles,} UDefProc, ExtCtrls, APIUtil, DateErr, VarConst, BTProc
  , uExDatasets, uBtrieveDataset, uMultiList, uDBMultiList, BtrvU2, Menus, uSettingsSQL
  , ADOSQLUtil, FileUtil, SQLUtils, DataModule, uSQLDatasets;

type
  TActFormProc = procedure(hwnd : LongInt);

  TfrmPopupList = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    lTitle: TLabel;
    panTitle: TPanel;
    mlBins: TDBMultiList;
    pdsUDItem: TBtrieveDataset;
    mlItems: TMultiList;
    pmMain: TPopupMenu;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    sdsUDItem: TSQLDatasets;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure lstItemsDblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure pdsUDItemGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure mlBinsRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure mlItemsRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure Properties1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    ShowForm {v6.30.051 ABSEXCH-9494}, bRestore, bMuBins : boolean;
    sUser : string;
    Procedure WMGetMinMaxInfo (Var Message : TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
  public
    { Public declarations }
    OK       : Byte;
//    Enforce  : Boolean;
    ValidationMode : integer;
    ResText  : ShortString;

    Function  GotMatch (Var FieldText : ShortString) : Boolean;
    procedure FindNearestMatch(FieldText : ShortString);
    {v6.30.051 ABSEXCH-9494}
//    Procedure InitForm (Const FieldCode, FieldCaption : ShortString; Const WinPos : TWinPos; SQLDataModule : TSQLDataModule);
    Procedure InitForm (Const FieldCode, FieldCaption : ShortString; Const WinPos : TWinPos; SQLDataModule : TSQLDataModule; bShowForm : boolean; FieldRec : TFieldRec);
  end;


// Function tests to see if hook should be enabled
{v6.30.051 ABSEXCH-9494}
//Function NeedHook (Const FieldCode : ShortString; sDataPath : String; var sDateFormat : string; SQLDataModule : TSQLDataModule) : Boolean;
Function NeedHook (Const FieldCode : ShortString; sDataPath : String; SQLDataModule : TSQLDataModule; var FieldRec : TFieldRec) : Boolean;


// displays popup list
Function ShowPopupList (Const FieldCode, FieldCaption : ShortString;
                        Var   FieldText               : ShortString;
                        Const WinPos                  : TWinPos;
                        Var   WantActivate            : Boolean;
                        bValidate : boolean; sDataPath, sUserName : string;
                        SQLDataModule : TSQLDataModule;
                        FieldRec : TFieldRec) : Boolean; {v6.30.051 ABSEXCH-9494}


{EXPORTS}

function ExecutePlugIn(sUserDefField, sField, sFieldName, sDataPath, sUserName : string; WinPos : TWinPos
; var bResult, bShown : boolean; bValidate : boolean = FALSE) : string; stdcall;

// v6.30.050
function ExecutePlugIn_V63(sUserDefField, sField, sFieldName, sDataPath, sCompanyCode, sUserName : string; WinPos : TWinPos
; var bResult, bShown : boolean; bValidate : boolean = FALSE) : string; stdcall;

function ExecuteTXPlugIn(dtDocType : cuDocTypes; sHeadLine : string
; iFieldNo : integer; sField : string; var sFieldName : string; sDataPath, sUserName : string
; var bResult : boolean; WinPos : TWinPos; UserFields : TAbsUserFields
; bReverseFlags : boolean; bValidate : boolean) : string; stdcall;

// v6.30.050
function ExecuteTXPlugIn_V63(dtDocType : cuDocTypes; sHeadLine : string
; iFieldNo : integer; sField : string; var sFieldName : string; sDataPath, sCompanyCode, sUserName : string
; var bResult : boolean; WinPos : TWinPos; UserFields : TAbsUserFields
; bReverseFlags : boolean; bValidate : boolean) : string; stdcall;

procedure DisconnectADO; stdcall;

// NF: 08/12/2010 added for .net support
procedure ExecuteTXPlugIn_DotNet(
dtDocType : cuDocTypes;
sHeadLine : string;
iFieldNo : integer;
sField : string;
sFieldName : string;
sDataPath : string;
sCompanyCode : string;
sUserName : string;
var wbResult : wordbool;
wbReverseFlags : wordbool;
wbValidate : wordbool;
var sSelectedValue : string
) stdcall;

implementation

uses
  ValInput;

// .052 - ABSEXCH-9616
var
  frmPopupList : TfrmPopupList;

{$R *.DFM}


{-----------------------------------------------------------------------}

// Function tests to see if hook should be enabled
Function NeedHook (Const FieldCode : ShortString; sDataPath : String; SQLDataModule : TSQLDataModule; var FieldRec : TFieldRec) : Boolean;
var
  iMode : integer;
//  FieldRec : TFieldRec; {v6.30.051 ABSEXCH-9494}
Begin { NeedHook }
  // Create .INI file interface if needed
//  If (Not Assigned(IniF)) Then
    // .Ini file stored in .EXE directory
//    IniF := TIniFile.Create(IncludeTrailingBackslash(Trim(sDataPath))+'EntUserF.Ini');
  FieldRec := GetFieldRecFromLookUp(FieldCode, SQLDataModule);

  // Read 'Mode' from .INI file
//  iMode := IniF.ReadInteger(FieldCode, 'Mode', -1);
  iMode := FieldRec.fiValidationMode;
//if iMode = -1 then
//  begin
      // Old ini file structure
//    Result := IniF.ReadBool (FieldCode, 'Enabled', False);
//  end
//else begin
    Result := iMode in [PM_MANDATORY_LIST, PM_OPTIONAL_LIST, PM_VALIDATION_ONLY
    , PM_MANDATORY_DATE, PM_OPTIONAL_DATE];
//    sDateFormat := Inif.ReadString('General','DateFormat','dd/mm/yyyy');
    if sDateFormat = '' then sDateFormat := GetDateFormat(SQLDataModule);
//end;{if}

End; { NeedHook }


{-----------------------------------------------------------------------}

// displays popup list
Function ShowPopupList (Const FieldCode, FieldCaption : ShortString;
                        Var   FieldText               : ShortString;
                        Const WinPos                  : TWinPos;
                        Var   WantActivate            : Boolean;
                        bValidate : boolean; sDataPath, sUserName : string;
                        SQLDataModule : TSQLDataModule;
                        FieldRec : TFieldRec) : Boolean; {v6.30.051 ABSEXCH-9494}
var
  pMessage : pCHar;
//  IniF : TIniFile;
//  frmPopupList : TfrmPopupList; // .052 - ABSEXCH-9616
  FrmValidation: TFrmValidation;
//  sDateFormat : string;

  function ConvertDateFormat(sFormat : string) : string;
  var
    iPos : integer;
  begin{ConvertDateFormat}
    Result := '';
    For iPos := 1 to length(sFormat) do begin
//      if (sFormat[iPos] in ['.', '/', '-']) then Result := Result + '''' + sFormat[iPos] + ''''
//      else Result := Result + sFormat[iPos];
      if (sFormat[iPos] = 'm') then Result := Result + UpperCase(sFormat[iPos])
      else Result := Result + sFormat[iPos];
    end;{for}
  end;{ConvertDateFormat}

Begin { ShowPopupList }
  // Always default to valid as the result
  Result := True;
//  IniF := nil;

  asCompanyPath := IncludeTrailingBackslash(Trim(sDataPath));

//  if OpenFiles then begin
  if FileExists(asCompanyPath + INI_FILENAME)
  then begin
    RunConversion;
    MoveFile(PChar(asCompanyPath + INI_FILENAME), PChar(asCompanyPath + 'ENTUSERF.ONO'));
  end;
//  end;{if}

  // Check Field is enabled
//If NeedHook (FieldCode, sDataPath, {IniF,} sDateFormat, SQLDataModule) Then {v6.30.051 ABSEXCH-9494}
  Begin

    // Create form if not already created
    // .052 - ABSEXCH-9616
    if (not bValidate){form will be shown} and Assigned(frmPopupList) then
    begin
      // NF: Recreate form - just so that the multi-list can get focus everytime (!) - I can find no other way to do this.
      frmPopupList.Release;
      frmPopupList := TfrmPopupList.Create(Nil);
    end;{if}
    if frmPopupList = nil then frmPopupList := TfrmPopupList.Create(Nil);
//    frmPopupList := TfrmPopupList.Create(Nil);

    Try
      With frmPopupList Do
      Begin
        // Initialise the form for the specific field currently being handled
        sUser := sUserName;
        InitForm(FieldCode, FieldCaption, WinPos, SQLDataModule, not bValidate, FieldRec);

        FieldText := Trim(FieldText);

        case ValidationMode of
          PM_VALIDATION_ONLY : begin
            // Popup Validation Dialog
            if Trim(FieldText) = '' then begin
              if bValidate then Result := FALSE
              else begin
                // Create form if not already created
                FrmValidation := TFrmValidation.Create(Nil);
                with FrmValidation do begin
                  edValue.Text := '';
                  lLabel.Caption := FieldCaption;
                  ShowModal;
                  FieldText := edValue.Text;
                  Release;
                end;{with}
                Result := TRUE;
              end;
            end;{if}
          end;

          PM_MANDATORY_LIST, PM_OPTIONAL_LIST : begin
            // Check to see if FieldText is already valid
            If (Not GotMatch(FieldText)) Then Begin
              // About to display form - so will need to re-activate Enterprise form later
              WantActivate := True;

              // Find nearest match in list to position on
              FindNearestMatch(FieldText);

              // Display Form

              if bValidate then
                begin
                  if ValidationMode = PM_MANDATORY_LIST then OK := 1
                  else OK := 0;
                end
              else begin
  //              ActivateForm(frmPopupList.Handle);
//                sUser := sUserName;
                ShowModal;
              end;{if}

              // Return results
              Case OK Of
                0 : Begin { OK }
                      Result := True;
                      FieldText := ResText;
                    End;
                1 : Begin { Cancel with Enforced }
                      Result := False;
                      FieldText := '';
                    End;
                2 : Begin { Cancel without Enforced }
                      Result := True;
                      { Leave FieldText as typed in Enterprise }
                    End;
              End; { Case OK }
            End; { If (Not GotMatch(FieldText)) }
          end;

          PM_MANDATORY_DATE, PM_OPTIONAL_DATE : begin
//            showmessage('Date type : ' + IntToStr(ValidationMode));
            // Popup Validation Dialog
//            if (Trim(FieldText) = '') and (ValidationMode = PM_OPTIONAL_DATE) then Result := TRUE
//            else begin
              if bValidate then
              begin
                // NF: 27/04/06 Changed to only allow correct dates,
                // or blank values on optional date fields
                Result := ((ValidationMode = PM_OPTIONAL_DATE) and (Trim(FieldText) = ''))
                or ValidateDate(sDateFormat, FieldText)
              end else
              begin
                Result := ValidateDate(sDateFormat, FieldText);
              end;{if}

              if (not Result) and (not bValidate) then begin
                with TFrmDateError.create(application) do begin
                  lFormat.Caption := 'Date Format : ' + sDateFormat;
                  lLabel.Caption := FieldCaption;
                  sFormat := sDateFormat;
                  edDate.Format := ConvertDateFormat(sDateFormat);
//                  edField.MaxLength := Length(sDateFormat);
//                  edDate.Date := StrToDate(FieldText);
                  btnCancel.Enabled := ValidationMode = PM_OPTIONAL_DATE;

                  if (ShowModal = mrOK) or (ValidationMode = PM_MANDATORY_DATE)
                  then FieldText := FormatDateTime(sDateFormat,edDate.Date);
//                  else FieldText := '';

                  Release;
                  Result := TRUE;
                end;{with}
//                MsgBox('The date you have entered does not conform with the date format specified : '
//                + #13#13 + sDateFormat, mtError, [mbOK], mbOK, 'Date Validation Error');
              end;{if}
//            end;{if}
          end;

        end;{case}
      End; { With frmPopupList }
    Except
      On Ex:Exception Do begin
        pMessage := StrAlloc(255);
        pMessage := StrPCopy(pMessage, 'The following error has occured: ' + Ex.Message +
        ', Please contact your Technical Support');
        MessageBox(FrmPopupList.Handle,pMessage,'Exception',MB_OK + MB_ICONERROR + MB_SYSTEMMODAL);
        StrDispose(pMessage);
        WantActivate := True;
      end;{on}
    End;
//    FrmPopupList.release; // .052 - ABSEXCH-9616
  End; { If NeedHook }

//  CloseFiles;

//  IniF.Free;
End; { ShowPopupList }

{-----------------------------------------------------------------------}

{v6.30.051 ABSEXCH-9494}
//Procedure TfrmPopupList.InitForm (Const FieldCode, FieldCaption : ShortString; Const WinPos : TWinPos; SQLDataModule : TSQLDataModule);
Procedure TfrmPopupList.InitForm (Const FieldCode, FieldCaption : ShortString; Const WinPos : TWinPos; SQLDataModule : TSQLDataModule; bShowForm : boolean; FieldRec : TFieldRec);
Var
  I, NoItems : LongInt;
  ItemStr    : ShortString;
//  FieldRec : TFieldRec;
Begin { InitForm }
  // Reinitialise any local variables on the form to the default value
  OK      := 1; { Cancelled }
  ResText := '';
  ShowForm := bShowForm; {v6.30.051 ABSEXCH-9494}

  // Position form based on active window position
  With WinPos Do Begin
    Left := wpLeft + Round((wpWidth - Width) / 2);
    Top  := wpTop + Round((wpHeight - Height) / 2);
  End; { With WinPos }

  // Re-initialise controls on the form
//  lstItems.Clear;

  {v6.30.051 ABSEXCH-9494}
//  FieldRec := GetFieldRecFromLookUp(FieldCode, SQLDataModule);

  if FieldCode = 'MuBinCode' then
  begin
    bMuBins := TRUE;
    mlBins.Visible := TRUE;

    {.046}
    if Assigned(SQLDataModule) then
    begin
      // SQL
      sdsUDItem.ServerAlias := GetServerFromConnectionString(SQLDataModule.ADOConnection_Company.ConnectionString);
      sdsUDItem.Database := GetDatabaseFromConnectionString(SQLDataModule.ADOConnection_Company.ConnectionString);
      sdsUDItem.TableName := asCompanyCode + '.UDITEM';
  //    sdsUDItem.Filter := 'liFieldFolio = ' + IntToStr(iFieldFolio);
  //   sdsUDItem.PrimaryKey := 'liFieldFolio';
      sdsUDItem.PrimaryKey := 'liDescription';
      sdsUDItem.Filter := 'liFieldFolio = ' + IntToStr(FieldRec.fiFolioNo);
      mlBins.Dataset := sdsUDItem;
    end
    else
    begin
      //Pervasive
      pdsUDItem.FileName := FileNames[ListItemF];
      pdsUDItem.SearchKey := FullNomKey(FieldRec.fiFolioNo) + FullNomKey(0);
      mlBins.Dataset := pdsUDItem;
    end;

    mlBins.Active := TRUE;

//    bdsUDItem.FileName := FileNames[ListItemF];
//    bdsUDItem.SearchKey := FullNomKey(FieldRec.fiFolioNo) + FullNomKey(0);
//    mlBins.Dataset := bdsUDItem;
//    mlBins.Active := TRUE;
  end else
  begin
    bMuBins := FALSE;
    mlItems.Visible := TRUE;
    FillSLWithListItems(FieldRec.fiFolioNo, mlItems.DesignColumns[0].items, SQLDataModule);

    If (mlItems.DesignColumns[0].Items.Count > 0)
    then mlItems.selected := 0;
  end;{if}

  {v6.30.051 ABSEXCH-9494}
//  LoadAllSettings;
  if ShowForm then LoadAllSettings;

//  With IniF Do Begin
    // Read in Window Caption


//    Caption := ReadString (FieldCode, 'WindowCaption', 'Select ' + FieldCaption);
    {v6.30.051 ABSEXCH-9494}
//    Caption := FieldRec.fiWindowCaption;
    if ShowForm then Caption := FieldRec.fiWindowCaption;


    // Read 'Mode' from .INI file
//    ValidationMode := IniF.ReadInteger(FieldCode, 'Mode', -1);
    ValidationMode := FieldRec.fiValidationMode;

    // old ini file
//    if ValidationMode = -1 then begin
//      if IniF.ReadBool (FieldCode, 'Enabled', False) then
//        begin
//          if IniF.ReadBool (FieldCode, 'Enforced', False) then ValidationMode := 1
//          else ValidationMode := 2
//        end
//      else ValidationMode := 0;
//    end;{if}

    {v6.30.051 ABSEXCH-9494}
    if ShowForm then
    begin
      case ValidationMode of
        1 : begin
          lTitle.Caption := 'You must pick one of the items from this list, to be able to continue.';
          panTitle.Caption := ' Mandatory List';
          panTitle.Color := clMaroon;
        end;

        2 : begin
          lTitle.Caption := 'Please pick one of the items from this list, or click on cancel to leave your original value intact.';
          panTitle.Caption := ' Optional List';
          panTitle.Color := clNavy;
        end;
      end;{case}
    end;{if}

    // Check to see how many items there are
//    FillSLWithListItems(FieldRec.fiFolioNo, lstItems.Items);

{    NoItems := ReadInteger (FieldCode, 'ListItemCount', 0);

    If (NoItems > 0) Then Begin
      // read in items and add to list
      For I := 1 To NoItems Do Begin
        // Read in item
        ItemStr := Trim(ReadString (FieldCode, 'ListItem' + IntToStr(I), ''));

        If (ItemStr <> '') Then
          // Add to list
          lstItems.Items.Add(ItemStr);
      End; { For I }
{    End; { If (NoItems > 0) }
//  End; { With IniF }

  // .052 - ABSEXCH-9616
{  if ShowForm then
  begin
    if mlBins.Visible then
    begin
      mlBins.
    end
    else
    begin
//      SendMessage(mlItems.Handle, WM_KILLFOCUS, 0, 0);
      PostMessage(mlItems.Handle, WM_SETFOCUS, 0, 0);
    end;
//    PostMessage(self.Handle, WM_SETFOCUS, 0, 0);
  end;{if}
End; { InitForm }

{---------------------------------}

// Check for exact match in list
Function TfrmPopupList.GotMatch (Var FieldText : ShortString) : Boolean;
Var
  I : LongInt;
//  pRec : Pointer;
Begin { GotMatch }
  Result := False;

  if bMuBins then
  begin
    mlBins.SearchColumn(0, TRUE, FieldText);
{    pRec := bdsUDItem.GetRecord;
    if pRec <> nil then begin
      if (Trim(TListItemRec(pRec^).liDescription) = FieldText)
      then Result := True
      else mlBins.SearchColumn(0, TRUE, '');
    end;{if}

    if (Trim(mlBins.DesignColumns[0].Items[mlBins.selected]) = FieldText)
    then Result := True
    else mlBins.SearchColumn(0, TRUE, '');
  end else
  begin
    mlItems.Selected := mlItems.DesignColumns[0].Items.IndexOf(FieldText);
    if mlItems.Selected >= 0 then begin
      if (mlItems.DesignColumns[0].Items[mlItems.Selected]) = FieldText
      then Result := TRUE;
    end;{if}
  end;{if}


(*  If (lstItems.Items.Count > 0) And (FieldText <> '') Then Begin
    // try to find a match in the list
    I := lstItems.Items.IndexOf(FieldText);

    If (I >= 0) Then Begin
      // Found match - highlight in list and return True
      FieldText := lstItems.Items[I];
      lstItems.ItemIndex := I;
      Result := True;
    End; { If (I >= 0) }
  End; { If (lstItems.Items.Count > 0) And (FieldText <> '') }*)
End; { GotMatch }

{---------------------------------}

procedure TfrmPopupList.FindNearestMatch(FieldText : ShortString);
Var
  StrList  : TStringList;
  SelStr   : ShortString;
  I, CompRes : LongInt;
Begin { FindNearestMatch }

  GotMatch(FieldText);

  // Convert original string to uppercase for comparison
(*  FieldText := Trim(FieldText);

  If (FieldText <> '') Then Begin
    StrList := TStringList.Create;
    Try
      // Load list into local copy and sort into alphabetical order
      StrList.Assign(lstItems.Items);
      StrList.Sorted := True;

      If (StrList.Count > 0) Then Begin
        // Scan through list for best match
        For I := 0 To Pred(StrList.Count) Do Begin
          // Extract string and convert to uppercase for comparison
          SelStr := Copy(Trim(StrList[I]), 1, Length(FieldText));

          // Perform case-insensitive compare i.e. A=a, b=B, etc...
          CompRes := CompareText(FieldText, SelStr);

          If (CompRes = 0) Then Begin
            // Exact Match - Select item
            SelStr := StrList[I];
            GotMatch (SelStr);
            Break;
          End { If (CompRes = 0) }
          Else Begin
            If (CompRes < 0) Then Begin
              // FieldText is less than list item - select previous item if available
              If (I = 0) Then
                // First Item
                SelStr := StrList[I]
              Else
                // Select previous item
                SelStr := StrList[Pred(I)];

              // Select Item
              GotMatch (SelStr);

              // Exit loop
              Break;
            End { If (CompRes < 0) }
            Else Begin
              If (CompRes > 0) And (I = Pred(StrList.Count)) Then Begin
                // Required text is > last item - select last item
                SelStr := StrList[I];
                GotMatch (SelStr);
                Break;
              End; { If }
            End; { Else }
          End; { Else }
        End; { For I }
      End; { If (StrList.Count > 0) }
    Finally
      StrList.Destroy;
    End; { Try }
  End; { If (FieldText) <> '') }

  // Nothing is currently selected
  If (lstItems.ItemIndex = -1) And (lstItems.Items.Count > 0) Then
    // Select first item
    lstItems.ItemIndex := 0;*)
End; { FindNearestMatch }

{---------------------------------}

// OK button
procedure TfrmPopupList.btnOKClick(Sender: TObject);
begin
  if bMuBins then
  begin
    if (mlBins.Selected >= 0) Then Begin
      {.046}
//      ResText := Trim(TListItemRec(bdsUDItem.GetRecord^).liDescription);
      ResText := Trim(mlBins.DesignColumns[0].Items[mlBins.selected]);

      OK := 0;
      Close;
    end; { If }
  end else
  begin
    If (mlItems.Selected >= 0) Then Begin
      ResText := Trim(mlItems.DesignColumns[0].Items[mlItems.Selected]);
      OK := 0;
      Close;
    End; { If }
  end;{if}
end;

{---------------------------------}

// Cancel button
procedure TfrmPopupList.btnCancelClick(Sender: TObject);
begin
  ResText := '';
//  OK := 1 + Ord(Not Enforce); {M = 0 / O = 1}
  OK := 1 + (ValidationMode - 1);
  Close;
end;

{---------------------------------}

// Double-Click on list
procedure TfrmPopupList.lstItemsDblClick(Sender: TObject);
begin
//  ResText := lstItems.Items[lstItems.ItemIndex];
  if bMuBins then
  begin
//    ResText := Trim(TListItemRec(bdsUDItem.GetRecord^).liDescription);
    ResText := Trim(mlBins.DesignColumns[0].Items[mlBins.selected]);
    OK := 0; { OK }
    Close;
  end else
  begin
    ResText := Trim(mlItems.DesignColumns[0].Items[mlItems.Selected]);
    OK := 0; { OK }
    Close;
  end;
end;

{---------------------------------}

// Form displayed - use Windows API to activate this app and make window active
procedure TfrmPopupList.FormActivate(Sender: TObject);
begin
  SetForegroundWindow (Self.Handle);
end;

{---------------------------------}

// limit resizing to height only
Procedure TfrmPopupList.WMGetMinMaxInfo (Var Message : TWMGetMinMaxInfo);
Begin { WMGetMinMaxInfo }
  With Message.MinMaxInfo^ Do Begin
    ptMinTrackSize.X:=277;
    ptMinTrackSize.Y:=150;

    ptMaxTrackSize.X:=277;
    ptMaxTrackSize.Y:=Round(Screen.Height * 0.80);
  End; { With Message }
End; { WMGetMinMaxInfo }

{---------------------------------}

// v6.30.050
function ExecutePlugIn(sUserDefField, sField, sFieldName, sDataPath, sUserName : string; WinPos : TWinPos
; var bResult, bShown : boolean; bValidate : boolean = FALSE) : string;
begin
  Result := ExecutePlugIn_V63(sUserDefField, sField, sFieldName, sDataPath, '', sUserName, WinPos, bResult, bShown, bValidate);
end;

// v6.30.050 - Addded Company Code parameter - passed in from plug-in DLL, from the new property in v6.3 customisation
//function ExecutePlugIn(sUserDefField, sField, sFieldName, sDataPath, sUserName : string; WinPos : TWinPos
//; var bResult, bShown : boolean; bValidate : boolean = FALSE) : string;
function ExecutePlugIn_V63(sUserDefField, sField, sFieldName, sDataPath, sCompanyCode, sUserName : string; WinPos : TWinPos
; var bResult, bShown : boolean; bValidate : boolean = FALSE) : string;
var
  FieldText    : ShortString;
//  sDateFormat : string;
  WantActivate : Boolean;
  bSQL : boolean;
  FieldRec : TFieldRec;
//  SQLDataModule : TSQLDataModule;
//  IniF : TIniFile;
begin
  Result := sField;
  asCompanyPath := IncludeTrailingBackslash(Trim(sDataPath));

  // v6.30.050
  if Trim(sCompanyCode) <> '' then asCompanyCode := sCompanyCode;

  bSQL := UsingSQL;
  if bSQL then
  begin
    {v6.30.051 ABSEXCH-9494}
//    SQLDataModule := TSQLDataModule.Create(nil);
//    SQLDataModule.Connect(asCompanyPath);
    if not Assigned(SQLDataModule) then
    begin
      SQLDataModule := TSQLDataModule.Create(nil);
      SQLDataModule.Connect(asCompanyPath);
    end;{if}
  end
  else
  begin
    SQLDataModule := nil;
  end;
//  IniF := nil;


//  if OpenFiles then begin
    if FileExists(asCompanyPath + INI_FILENAME)
    then begin
      RunConversion;
      MoveFile(PChar(asCompanyPath + INI_FILENAME), PChar(asCompanyPath + 'ENTUSERF.ONO'));
    end;{if}
//  end;{if}

  if NeedHook(sUserDefField, sDataPath, {IniF,} {sDateFormat,} SQLDataModule, FieldRec) Then
  begin
//        if (bLastResult) or (sLastField = sUserDefField) then
//        begin
    FieldText := sField;
    bResult := ShowPopupList(sUserDefField, sFieldName, FieldText, WinPos
    , WantActivate, bValidate, sDataPath, sUserName, SQLDataModule, FieldRec);
    If bResult Then Result := FieldText;
    bShown := TRUE;
//            bLastResult := bResult;
//        end
//        else bLastResult := FALSE;
  end
  else
  begin
    bShown := FALSE;
//    if bValidate then bResult := TRUE;
    bResult := TRUE;
//      bLastResult := bResult;
  end;{if}

  {v6.30.051 ABSEXCH-9494}
{  if bSQL then
  begin
    SQLDataModule.Disconnect;
    SQLDataModule.Free;
  end;{if}

//  CloseFiles;

//  IniF.Free;

//  sLastField := sUserDefField;
end;{ExecutePlugIn}

// v6.30.050
function ExecuteTXPlugIn(dtDocType : cuDocTypes; sHeadLine : string
; iFieldNo : integer; sField : string; var sFieldName : string; sDataPath, sUserName : string
; var bResult : boolean; WinPos : TWinPos; UserFields : TAbsUserFields
; bReverseFlags : boolean; bValidate : boolean) : string;
begin{ExecuteTXPlugIn}
  Result := ExecuteTXPlugIn_V63(dtDocType, sHeadLine, iFieldNo, sField, sFieldName
  , sDataPath, '', sUserName, bResult, WinPos, UserFields, bReverseFlags, bValidate);
end;{ExecuteTXPlugIn}

// v6.30.050
//function ExecuteTXPlugIn(dtDocType : cuDocTypes; sHeadLine : string
//; iFieldNo : integer; sField : string; var sFieldName : string; sDataPath, sUserName : string
//; var bResult : boolean; WinPos : TWinPos; UserFields : TAbsUserFields
//; bReverseFlags : boolean; bValidate : boolean) : string;
function ExecuteTXPlugIn_V63(dtDocType : cuDocTypes; sHeadLine : string
; iFieldNo : integer; sField : string; var sFieldName : string; sDataPath, sCompanyCode, sUserName : string
; var bResult : boolean; WinPos : TWinPos; UserFields : TAbsUserFields
; bReverseFlags : boolean; bValidate : boolean) : string;
var
  bFieldEnabled, bShown : boolean;
  sINISection : string;

  procedure GetFieldDetails(var FieldEnabled : boolean; var FieldName : string);

    Function ReverseFlag(bEnabled : Boolean) : boolean;
    // reverses the flag for any class version under 5.00.027 (bug in customisation)
    begin{ReverseFlag}
      if bReverseFlags then Result := not bEnabled
      else Result := bEnabled;
    end;{ReverseFlag}

  begin{GetFieldDetails}
    if sHeadLine = 'Head' then
    begin
      // TX Header
      case dtDocType of
        CUSIN, CUSCR, CUSJI, CUSJC, CUSRI, CUSRF : begin
          FieldEnabled := UserFields.ufSINEnabled[iFieldNo];
          FieldName := UserFields.ufSINDesc[iFieldNo];
        end;

        CUSRC : begin
          FieldEnabled := ReverseFlag(UserFields.ufSRCEnabled[iFieldNo]);
          FieldName := UserFields.ufSRCDesc[iFieldNo];
        end;

        CUSQU : begin
          FieldEnabled := ReverseFlag(UserFields.ufSQUEnabled[iFieldNo]);
          FieldName := UserFields.ufSQUDesc[iFieldNo];
        end;

        CUSOR, CUSDN : begin
          FieldEnabled := ReverseFlag(UserFields.ufSOREnabled[iFieldNo]);
          FieldName := UserFields.ufSORDesc[iFieldNo];
        end;

        CUPIN,CUPCR,CUPJI,CUPJC,CUPPI,CUPRF : begin
          FieldEnabled := ReverseFlag(UserFields.ufPINEnabled[iFieldNo]);
          FieldName := UserFields.ufPINDesc[iFieldNo];
        end;

        CUPPY : begin
          FieldEnabled := ReverseFlag(UserFields.ufPPYEnabled[iFieldNo]);
          FieldName := UserFields.ufPPYDesc[iFieldNo];
        end;

        CUPQU : begin
          FieldEnabled := ReverseFlag(UserFields.ufPQUEnabled[iFieldNo]);
          FieldName := UserFields.ufPQUDesc[iFieldNo];
        end;

        CUPOR,CUPDN : begin
          FieldEnabled := ReverseFlag(UserFields.ufPOREnabled[iFieldNo]);
          FieldName := UserFields.ufPORDesc[iFieldNo];
        end;

        CUNMT : begin
          FieldEnabled := ReverseFlag(UserFields.ufNOMEnabled[iFieldNo]);
          FieldName := UserFields.ufNOMDesc[iFieldNo];
        end;

        CUADJ : begin
          FieldEnabled := ReverseFlag(UserFields.ufADJEnabled[iFieldNo]);
          FieldName := UserFields.ufADJDesc[iFieldNo];
        end;

        CUWOR : begin
          FieldEnabled := ReverseFlag(UserFields.ufWOREnabled[iFieldNo]);
          FieldName := UserFields.ufWORDesc[iFieldNo];
        end;

        CUTSH : begin
          FieldEnabled := ReverseFlag(UserFields.ufTSHEnabled[iFieldNo]);
          FieldName := UserFields.ufTSHDesc[iFieldNo];
        end;

        CUJCT, CUJST, CUJPT, CUJPA, CUJSA : begin
          FieldEnabled := TRUE;
          FieldName := 'UD Field ' + IntToStr(iFieldNo);
        end;

        else begin
          FieldEnabled := TRUE;
          FieldName := 'UD Field ' + IntToStr(iFieldNo);
        end;
      end;{case}
    end
    else
    begin
      // TX Lines
      case dtDocType of
        CUSIN, CUSCR, CUSJI, CUSJC, CUSRI, CUSRF : begin
          FieldEnabled := UserFields.ufSINLineEnabled[iFieldNo];
          FieldName := UserFields.ufSINLineDesc[iFieldNo];
        end;

        CUSRC : begin
          FieldEnabled := ReverseFlag(UserFields.ufSRCLineEnabled[iFieldNo]);
          FieldName := UserFields.ufSRCLineDesc[iFieldNo];
        end;

        CUSQU : begin
          FieldEnabled := ReverseFlag(UserFields.ufSQULineEnabled[iFieldNo]);
          FieldName := UserFields.ufSQULineDesc[iFieldNo];
        end;

        CUSOR, CUSDN : begin
          FieldEnabled := ReverseFlag(UserFields.ufSORLineEnabled[iFieldNo]);
          FieldName := UserFields.ufSORLineDesc[iFieldNo];
        end;

        CUPIN,CUPCR,CUPJI,CUPJC,CUPPI,CUPRF : begin
          FieldEnabled := ReverseFlag(UserFields.ufPINLineEnabled[iFieldNo]);
          FieldName := UserFields.ufPINLineDesc[iFieldNo];
        end;

        CUPPY : begin
          FieldEnabled := ReverseFlag(UserFields.ufPPYLineEnabled[iFieldNo]);
          FieldName := UserFields.ufPPYLineDesc[iFieldNo];
        end;

        CUPQU : begin
          FieldEnabled := ReverseFlag(UserFields.ufPQULineEnabled[iFieldNo]);
          FieldName := UserFields.ufPQULineDesc[iFieldNo];
        end;

        CUPOR,CUPDN : begin
          FieldEnabled := ReverseFlag(UserFields.ufPORLineEnabled[iFieldNo]);
          FieldName := UserFields.ufPORLineDesc[iFieldNo];
        end;

        CUNMT : begin
          FieldEnabled := ReverseFlag(UserFields.ufNOMLineEnabled[iFieldNo]);
          FieldName := UserFields.ufNOMLineDesc[iFieldNo];
        end;

        CUADJ : begin
          FieldEnabled := ReverseFlag(UserFields.ufADJLineEnabled[iFieldNo]);
          FieldName := UserFields.ufADJLineDesc[iFieldNo];
        end;

        CUWOR : begin
          FieldEnabled := ReverseFlag(UserFields.ufWORLineEnabled[iFieldNo]);
          FieldName := UserFields.ufWORLineDesc[iFieldNo];
        end;

        CUTSH : begin
          FieldEnabled := ReverseFlag(UserFields.ufTSHLineEnabled[iFieldNo]);
          FieldName := UserFields.ufTSHLineDesc[iFieldNo];
        end;

        CUJCT, CUJST, CUJPT, CUJPA, CUJSA : begin
          FieldEnabled := TRUE;
          FieldName := 'UD Field ' + IntToStr(iFieldNo);
        end;

        else begin
          FieldEnabled := TRUE;
          FieldName := 'UD Field ' + IntToStr(iFieldNo);
        end;
      end;{case}
    end;{if}

    // These TX Types have been ommited, as they do not appear in the Customisation object :
    //          CUSJC,CUSBT,CUSDG,CUNDG,CUOVT,CUDEB,CUPBT,CUSDT,CUNDT,CUIVT,CUCRE
    //          ,CURUN,CUFOL,CUAFL,CUADC,CUACQ,CUAPI,CUSKF,CUJBF,CUJRN

  end;{GetFieldDetails}

  function Get3CharFromDocType(dtDocType : cuDocTypes) : string;
  begin{Get3CharFromDocType}
    case dtDocType of
      CUSIN,CUSCR,CUSJI,CUSJC,CUSRF,CUSRI : Result := 'SIN';
      CUSRC : Result := 'SRC';
      CUSQU : Result := 'SQU';
      CUSOR, CUSDN : Result := 'SOR';
      CUPIN,CUPCR,CUPJI,CUPJC,CUPRF,CUPPI : Result := 'PIN';
      CUPPY : Result := 'PPY';
      CUPQU : Result := 'PQU';
      CUPOR, CUPDN : Result := 'POR';
      CUNMT : Result := 'NOM';
      CUADJ : Result := 'ADJ';
      CUWOR : Result := 'WOR';
      CUTSH : Result := 'TSH';
      CUJCT : Result := 'JCT';
      CUJST : Result := 'JST';
      CUJPT : Result := 'JPT';
      CUJSA : Result := 'JSA';
      CUJPA : Result := 'JPA';
{      cuDocTypes(46) : Result := 'JCT';
      cuDocTypes(47) : Result := 'JST';
      cuDocTypes(48) : Result := 'JPT';
      cuDocTypes(49) : Result := 'JSA';
      cuDocTypes(50) : Result := 'JPA';}
      CUSRN : Result := 'SRN';
      CUPRN : Result := 'PRN';
    end;{case}
  end;{Get3CharFromDocType}

begin{ExecuteTXPlugIn_V63}

  // TCM and .NET passes in nil for UserFields, so it must assume that the field is enabled
  if UserFields <> nil then GetFieldDetails(bFieldEnabled, sFieldName);
  if bFieldEnabled or (UserFields = nil) then
    begin
      sINISection := Get3CharFromDocType(dtDocType);
      if Trim(sINISection) = '' then
      begin
        Result := sField;
        bResult := TRUE;
      end else
      begin
        sINISection := sINISection + sHeadLine + IntToStr(iFieldNo);
        Result := ExecutePlugIn(sINISection, sField, sFieldName, sDataPath, sUserName
        , WinPos, bResult, bShown, bValidate);
        if not bShown then
        begin
          if sHeadLine = 'Head' then sINISection := 'TransUser' + IntToStr(iFieldNo)
          else sINISection := 'LineUser' + IntToStr(iFieldNo);

          // v6.30.050
//          Result := ExecutePlugIn(sINISection, sField, sFieldName, sDataPath, sUserName
//          , WinPos, bResult, bShown, bValidate);
          Result := ExecutePlugIn_V63(sINISection, sField, sFieldName, sDataPath
          , sCompanyCode, sUserName, WinPos, bResult, bShown, bValidate);

          if not bShown then Result := sField;
        end;{if}
      end;{if}
    end
  else bResult := TRUE; {.012}
end;{ExecuteTXPlugIn_V63}

procedure ExecuteTXPlugIn_DotNet(
dtDocType : cuDocTypes;
sHeadLine : string;
iFieldNo : integer;
sField : string;
sFieldName : string;
sDataPath : string;
sCompanyCode : string;
sUserName : string;
var wbResult : wordbool;
wbReverseFlags : wordbool;
wbValidate : wordbool;
var sSelectedValue : string
) stdcall;
var
  WinPos : TWinPos;
  bResult : boolean;
  sResult : string;
begin
  WinPos.wpLeft := 0;
  WinPos.wpTop := 0;
  WinPos.wpWidth := screen.Width;
  WinPos.wpHeight := screen.Height;
  bResult := wbResult;
  sSelectedValue := ExecuteTXPlugIn_V63(dtDocType, sHeadLine, iFieldNo, sField, sFieldName, sDataPath
  , sCompanyCode, sUserName, bResult, WinPos, nil, wbReverseFlags, wbValidate);
//  Result := sResult;
  wbResult := bResult;
end;

procedure TfrmPopupList.pdsUDItemGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
begin
  with TListItemRec(PData^) do begin
    FieldValue := liDescription;
  end;{with}
end;

procedure TfrmPopupList.mlBinsRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnOKClick(btnOK);
end;

procedure TfrmPopupList.mlItemsRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnOKClick(btnOK);
end;

procedure TfrmPopupList.SaveAllSettings;
begin
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
  if mlItems.Visible then oSettings.SaveList(mlItems, Self.Name)
  else oSettings.SaveList(mlBins, Self.Name);

//  oSettings.DisconnectADO;
end;

procedure TfrmPopupList.LoadAllSettings;
begin
//  sMiscDirLocation := GetEnterpriseDirectory;
  sMiscDirLocation := asCompanyPath;
  oSettings.UserName := sUser;
  oSettings.LoadForm(Self);
  if mlItems.Visible then oSettings.LoadList(mlItems, Self.Name)
  else oSettings.LoadList(mlBins, Self.Name);
end;


procedure TfrmPopupList.Properties1Click(Sender: TObject);
begin
  if mlItems.Visible then
  begin
    if oSettings.Edit(mlItems, Self.Name, nil) = mrRestoreDefaults then begin
      oSettings.RestoreListDefaults(mlItems, Self.Name);
      bRestore := TRUE;
    end;{if}
  end else begin
    if oSettings.Edit(mlBins, Self.Name, nil) = mrRestoreDefaults then begin
      oSettings.RestoreListDefaults(mlBins, Self.Name);
      bRestore := TRUE;
    end;{if}
  end;{if}
end;

procedure TfrmPopupList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  {v6.30.051 ABSEXCH-9494}
//  if (not bRestore) then SaveAllSettings;
  if (not bRestore) and (ShowForm) then SaveAllSettings;
end;

procedure TfrmPopupList.FormCreate(Sender: TObject);
begin
  sUser := '';
end;

procedure TfrmPopupList.FormShow(Sender: TObject);
begin
  bRestore := FALSE;
end;

procedure DisconnectADO;
begin
  // NF: 23/09/2010
  // to fix https://jira.iris.co.uk/browse/ABSEXGENERIC-201
  // To stop Error 11 on local program files
  if Trim(sMiscDirLocation) = '' then sMiscDirLocation := asCompanyPath;

  oSettings.DisconnectADO;

  if Assigned(SQLDataModule) then
  begin
    SQLDataModule.Disconnect;
    SQLDataModule.Free;
    SQLDataModule := nil;
  end;{if}

  // .052 - ABSEXCH-9616
  if Assigned(frmPopupList) then
  begin
    //PR: 08/04/2013 ABSEXGENERIC-222 v7.0.060 Need to set form to nil to avoid access violation
    //if we switch companies.
    frmPopupList.release;
    frmPopupList := nil;
  end;

  sDateFormat := '';
  asCompanyCode := '';
end;

Initialization
  frmPopupList := nil; // .052 - ABSEXCH-9616

Finalization


end.
