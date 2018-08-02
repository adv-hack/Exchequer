procedure TfrmTKPickList.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmTKPickList.GetFieldValue(Sender: TObject;
  ID: IDispatch; FieldName: String; var FieldValue: String);
begin
  case plType of
    plSupplier, plCustomer : begin
      with (ID as IAccount) do begin
        case FieldName[1] of
          'C' : FieldValue := acCode;
          'D' : FieldValue := acCompany;
        end;{case}
      end;{with}
    end;

    plSupersededBy : begin
      with (ID as IAltStockCode) do begin
        case FieldName[1] of
          'C' : FieldValue := ascAltCode;
          'D' : FieldValue := ascAltDesc;
        end;{case}
      end;{with}
    end;

    plProduct, plProductAndBOM, plProductNoBOM, plProductOnly, plBOM, plProductGroup
    , plProductAndGroup, plProductInAGroup, plProductDescOnly : begin
      with (ID as IStock) do begin
        case FieldName[1] of
          'C' : FieldValue := stCode;
          'D' : FieldValue := stDesc[1];
        end;{case}
      end;{with}
    end;

    plGLCode : begin
      with (ID as IGeneralLedger) do begin
        case FieldName[1] of
          'C' : FieldValue := IntToStr(glCode);
          'D' : FieldValue := glName;
        end;{case}
      end;{with}
    end;

    plCC, plDept : begin
      with (ID as ICCDept) do begin
        case FieldName[1] of
          'C' : FieldValue := cdCode;
          'D' : FieldValue := cdName;
        end;{case}
      end;{with}
    end;

    plLocation : begin
      with (ID as ILocation) do begin
        case FieldName[1] of
          'C' : FieldValue := loCode;
          'D' : FieldValue := loName;
        end;{case}
      end;{with}
    end;

    plCustSalesAnalysis : begin
      with (ID as ICustomerSalesAnalysis) do begin
        case FieldName[1] of
          'C' : FieldValue := saStockCode;
          'D' : FieldValue := GetStockDescFromCode(saStockCode);
        end;{case}
      end;{with}
    end;

    plJob : begin
      with (ID as IJob) do begin
        case FieldName[1] of
          'C' : FieldValue := jrCode;
          'D' : FieldValue := jrDesc;
        end;{case}
      end;{with}
    end;

    plJobAnalysis : begin
      with (ID as IJobAnalysis) do begin
        case FieldName[1] of
          'C' : FieldValue := anCode;
          'D' : FieldValue := anDescription;
        end;{case}
      end;{with}
    end;

    plUser : begin
      with (ID as IUserProfile) do begin
        case FieldName[1] of
          'C' : FieldValue := upUserID;
          'D' : FieldValue := upName;
        end;{case}
      end;{with}
    end;
  end;{case}
end;
(*
procedure TfrmPickList.BuildIndex(Sender: TObject; ID: IDispatch; IndexNo : integer; var KeyStr: String);

  function StrToIndexInt(sKey : string) : integer;
  begin{StrToIndexInt}
    sKey := Trim(sKey);
    if Pos(StringOfChar(#255,200),sKey) > 0 then Result := 2147483647
    else begin
      sKey := RemoveAllChars(sKey,#255);
      Result := StrToIntDef(sKey,0);
    end;
  end;{StrToIndexInt}

begin{BuildIndex}
  exit;
  case plType of
    plSupplier : begin
      with (ID as IAccount) do begin
        case IndexNo of
          acIdxCode : KeyStr := BuildCodeIndex(KeyStr);
          acIdxName : KeyStr := BuildNameIndex(KeyStr);
    //      acIdxAltCode : KeyStr := BuildCodeIndex(KeyStr);
    //      acIdxVATRegNo : KeyStr := BuildCodeIndex(KeyStr);
    //      acIdxEmail : KeyStr := BuildCodeIndex(KeyStr);
    //      acIdxPhone : KeyStr := BuildCodeIndex(KeyStr);
    //      acIdxPostCode : KeyStr := BuildCodeIndex(KeyStr);
    //      acIdxOurCode : KeyStr := BuildCodeIndex(KeyStr);
    //      acIdxInvTo : KeyStr := BuildCodeIndex(KeyStr);
        end;{case}
      end;{with}
    end;

    plGLCode : begin
      with (ID as IGeneralLedger2) do begin
        case IndexNo of
          glIdxCode : KeyStr := BuildCodeIndex(StrToIndexInt(KeyStr));
          glIdxName : KeyStr := BuildNameIndex(KeyStr);
        end;{case}
      end;{with}
    end;
  end;{case}
end;
*)
procedure TfrmTKPickList.SelectRecord(Sender: TObject; SelectType:
TSelectType; Address: integer; ID: IDispatch);
begin
  btnOK.Enabled := TRUE;
{  with (ID as IAccount) do begin
    lCode.caption := acCode;
    lDesc.caption := acCompany;
  end;{with}
end;

procedure TfrmTKPickList.btnOKClick(Sender: TObject);
begin
  if btnOK.enabled then ModalResult := mrOK;
end;
{
procedure TfrmPickList.mlListSortColumn(Sender: TObject;
  ColIndex: Integer; SortAsc: Boolean);
begin
  ctkDataSet.SearchIndex := ColIndex;
  ctkDataSet.SearchDataType := mlList.Columns[ColIndex].DataType;
end;
}
procedure TfrmTKPickList.FormShow(Sender: TObject);
var
  sErrorText : string;
  sFileName : string;
begin
  bRestore := FALSE;
  Try
    case plType of
      plSupplier : begin
        Caption := 'Pick a Supplier';
        {$IFDEF PRE_571002_MULTILIST}
          ctkDataSet.ToolkitObject := oLToolkit.supplier as IBtrieveFunctions2;
        {$ELSE}
          ctkDataSet.ToolkitObject := oLToolkit.supplier as IDatabaseFunctions;
        {$ENDIF}
      end;

      plLocation : begin
        Caption := 'Pick a Location';
        {$IFDEF PRE_571002_MULTILIST}
          ctkDataSet.ToolkitObject := oLToolkit.Location as IBtrieveFunctions2;
        {$ELSE}
          ctkDataSet.ToolkitObject := oLToolkit.Location as IDatabaseFunctions;
        {$ENDIF}
      end;

      plCustomer : begin
        Caption := 'Pick a Customer';
        {$IFDEF PRE_571002_MULTILIST}
          ctkDataSet.ToolkitObject := oLToolkit.customer as IBtrieveFunctions2;
        {$ELSE}
          ctkDataSet.ToolkitObject := oLToolkit.customer as IDatabaseFunctions;
        {$ENDIF}
      end;

      plGLCode : begin
        Caption := 'Pick a GL Code';
        {$IFDEF PRE_571002_MULTILIST}
          ctkDataSet.ToolkitObject := oLToolkit.GeneralLedger as IBtrieveFunctions2;
        {$ELSE}
          ctkDataSet.ToolkitObject := oLToolkit.GeneralLedger as IDatabaseFunctions;
        {$ENDIF}
        //SSK 19/01/2017 2017-R1 ABSEXCH-17283: Changes done here for wildcard characters '/' or '?' to work properly
        if (sFind = '') then sFind := '/';
        if (sFind = '/')  then
          iSearchCol := 1
        else if (sFind = '?') then
        begin
          iSearchCol := 0;
          mlList.DesignColumns[0].IndexNo := 3;
        end;

      end;

      plCC : begin
        Caption := 'Pick a Cost Centre';
        {$IFDEF PRE_571002_MULTILIST}
          ctkDataSet.ToolkitObject := oLToolkit.CostCentre as IBtrieveFunctions2;
        {$ELSE}
          ctkDataSet.ToolkitObject := oLToolkit.CostCentre as IDatabaseFunctions;
        {$ENDIF}
      end;

      plDept : begin
        Caption := 'Pick a Department';
        {$IFDEF PRE_571002_MULTILIST}
          ctkDataSet.ToolkitObject := oLToolkit.Department as IBtrieveFunctions2;
        {$ELSE}
          ctkDataSet.ToolkitObject := oLToolkit.Department as IDatabaseFunctions;
        {$ENDIF}
      end;

      plSupersededBy : begin
        Caption := 'Pick an Alternate Product';
        mlList.DesignColumns[0].IndexNo := 1;
        mlList.DesignColumns[1].IndexNo := 1;
        mlList.DesignColumns[1].Searchable := FALSE;
        mlList.DesignColumns[1].Sortable := FALSE;
        {$IFDEF PRE_571002_MULTILIST}
          ctkDataSet.ToolkitObject := (oLToolkit.Stock as IStock4).stSupersededBy as IBtrieveFunctions2;
        {$ELSE}
          ctkDataSet.ToolkitObject := (oLToolkit.Stock as IStock4).stSupersededBy as IDatabaseFunctions;
        {$ENDIF}
      end;

      plProduct, plBOM, plProductAndBOM, plProductNoBOM, plProductOnly, plProductInAGroup
      , plProductDescOnly : begin
        case plType of
          plProductDescOnly, plProductOnly, plProduct, plProductNoBOM : Caption := 'Pick a Product';
          plBOM : Caption := 'Pick a BOM';
          plProductInAGroup : Caption := 'Pick a Product from ' + sParentCode;
          plProductAndBOM : Caption := 'Pick a Product / BOM';
        end;{case}

        {$IFDEF PRE_571002_MULTILIST}
          ctkDataSet.ToolkitObject := oLToolkit.Stock as IBtrieveFunctions2;
        {$ELSE}
          ctkDataSet.ToolkitObject := oLToolkit.Stock as IDatabaseFunctions;
        {$ENDIF}

        if iCodeIndex = -1 then mlList.DesignColumns[0].IndexNo := 0
        else mlList.DesignColumns[0].IndexNo := iCodeIndex;

        if iDescIndex = -1 then mlList.DesignColumns[1].IndexNo := 3
        else mlList.DesignColumns[1].IndexNo := iDescIndex;
      end;

      plProductGroup : begin
        Caption := 'Pick a Product Group';
        {$IFDEF PRE_571002_MULTILIST}
          ctkDataSet.ToolkitObject := oLToolkit.Stock as IBtrieveFunctions2;
        {$ELSE}
          ctkDataSet.ToolkitObject := oLToolkit.Stock as IDatabaseFunctions;
        {$ENDIF}
        mlList.DesignColumns[0].IndexNo := 0;
        mlList.DesignColumns[1].IndexNo := 3;
      end;

      plProductAndGroup : begin
        Caption := 'Pick a Product / Group';
        {$IFDEF PRE_571002_MULTILIST}
          ctkDataSet.ToolkitObject := oLToolkit.Stock as IBtrieveFunctions2;
        {$ELSE}
          ctkDataSet.ToolkitObject := oLToolkit.Stock as IDatabaseFunctions;
        {$ENDIF}
        mlList.DesignColumns[0].IndexNo := 0;
        mlList.DesignColumns[1].IndexNo := 3;
      end;

      plCustSalesAnalysis : begin
        Caption := 'Pick a Product';
        {$IFDEF PRE_571002_MULTILIST}
          ctkDataSet.ToolkitObject := (oLToolkit.Customer as IAccount2).acSalesAnalysis as IBtrieveFunctions2;
        {$ELSE}
          ctkDataSet.ToolkitObject := (oLToolkit.Customer as IAccount2).acSalesAnalysis as IDatabaseFunctions;
        {$ENDIF}
        mlList.DesignColumns[0].IndexNo := 0;
        mlList.DesignColumns[1].Searchable := TRUE;
        mlList.DesignColumns[1].Sortable := TRUE;
        btnShowAll.Visible := TRUE;
      end;

      plJob : begin
        Caption := 'Pick a Job';
        mlList.DesignColumns[1].IndexNo := 3;
        {$IFDEF PRE_571002_MULTILIST}
          ctkDataSet.ToolkitObject := oLToolkit.JobCosting.Job as IBtrieveFunctions2;
        {$ELSE}
          ctkDataSet.ToolkitObject := oLToolkit.JobCosting.Job as IDatabaseFunctions;
        {$ENDIF}
      end;

      plJobAnalysis : begin
        Caption := 'Pick a Job Analysis Code';
  //      mlList.DesignColumns[1].IndexNo := 3;
        {$IFDEF PRE_571002_MULTILIST}
          ctkDataSet.ToolkitObject := oLToolkit.JobCosting.JobAnalysis as IBtrieveFunctions2;
        {$ELSE}
          ctkDataSet.ToolkitObject := oLToolkit.JobCosting.JobAnalysis as IDatabaseFunctions;
        {$ENDIF}
      end;

      plUser : begin
        Caption := 'Pick a User';
        {$IFDEF PRE_571002_MULTILIST}
          ctkDataSet.ToolkitObject := (oLToolkit as IToolkit2).UserProfile as IBtrieveFunctions2;
        {$ELSE}
          ctkDataSet.ToolkitObject := (oLToolkit as IToolkit2).UserProfile as IDatabaseFunctions;
        {$ENDIF}
      end;
    end;{case}

    if Assigned(Sender) then begin
      mlList.Dataset := ctkDataSet;
      if (iSearchcol <> 0) then       //SSK 20/01/2017 2017-R1 ABSEXCH-17283: this check is done to select the top most Item in the list
        mlList.SearchColumn(iSearchCol, TRUE, sFind);
    end;{if}

    // If set to, Autoselect the only item in the list and close
    if (mlList.ItemsCount = 1) and bAutoSelectIfOnlyOne
    then begin
      mlList.Selected := 0;
      PostMessage(Self.Handle,WM_DoIt,0,CLICK_OK);
    end;{if}

    // If set to, and there are no items in the list, show a message and close
    if (mlList.ItemsCount = 0) and bShowMessageIfEmpty
    then begin
      PostMessage(Self.Handle,WM_DoIt,0,CLICK_CANCEL);
    end;{if}

    // Replace Caption, for a custom caption
    if sCaption <> '' then Caption := sCaption;
  Except
    on E:EIntfCastError do
    begin
      if LowerCase(E.Message) = 'interface not supported' then
      begin
        sFileName := GetEnterpriseDirectory + 'Entlib.001';
        sErrorText := 'An error occurred when trying to populate the list. This was because'#10;

        if not FileExists(sFilename) then
          sErrorText := sErrorText + 'a COM Toolkit component could not be found. This may be'#10 +
                        'due to a network error.'
        else
          sErrorText := sErrorText +
                      'it was not possible to find the IDatabaseFunctions interface in the'#10 +
                      'COM Toolkit. Performing a workstation setup may resolve this problem.';
        msgBox(sErrorText + #10#10 + 'Please contact your technical support for advice and help.', mtError, [mbOK], mbOK, Caption);

      end
      else
        raise;
    end;
  End;
  Screen.Cursor := crDefault;

end;

procedure TfrmTKPickList.mlListAfterInit(Sender: TObject);
begin
//  mlList.SortColumn(0, TRUE);
//  mlList.SearchColumn(iSearchCol, TRUE, sFind);
end;

procedure TfrmTKPickList.mlListRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  btnOKClick(btnOK);
end;

procedure TfrmTKPickList.mlListAfterLoad(Sender: TObject);
begin
// showmessage('mlListAfterLoad');
end;

procedure TfrmTKPickList.mlListBeforeLoad(Sender: TObject;
  var Allow: Boolean);
begin
//  showmessage('mlListBeforeLoad');
end;

procedure TfrmTKPickList.mlListScrollButtonKeyPress(Key: Char);
begin
  Case Ord(Key) of
    27 : ModalResult := mrCancel; //ESC
  end;{case}
end;

procedure TfrmTKPickList.ctkDataSetFilterRecord(Sender: TObject;
  ID: IDispatch; var Include: Boolean);
begin

// Include := TRUE;

  case plType of
    plLocation, plSupplier, plCustomer : begin
      Include := TRUE;

      if plType in [plSupplier, plCustomer] then
      begin
        if bRestrictList and (sFind <> '') and include
        then begin
          case iSearchCol of
            0 : begin // Account Code
              Include := UpperCase(Copy((ID as IAccount).acCode, 1
              , Length(sFind))) = UpperCase(sFind);
            end;
          end;{case}
        end;{if}
      end;{if}

      if include and (iFilterMode <> NO_FILTER) then
      begin
        case iFilterMode of
          FILTER_ALTCODE : begin
            include := UpperCase(Trim((ID as IAccount).acAltCode)) = UpperCase(Trim(sFilter));
          end;
        end;{case}
      end;{if}
    end;

    plCC, plDept : begin
      // Do not include inactive cc/depts
      if supports(ID, ICCDept2) then
      begin
        Include := not (ID as ICCDept2).cdInactive;
      end else
      begin
        Include := TRUE;
      end;{if}

      (*
      {$IFDEF ADDNOMWIZARD}
        Include := not (ID as ICCDept2).cdInactive;
      {$ELSE}
        Include := TRUE;
      {$ENDIF}
      *)

      if Include then
      begin
        // Restrict List to ONLY those that match the search string ?
        if bRestrictList and (sFind <> '')
        then begin
          case iSearchCol of
            0 : begin // CC Code
              Include := UpperCase(Copy((ID as ICCDept).cdCode, 1
              , Length(sFind))) = UpperCase(sFind);
            end;

  {          1 : begin // CC Name
              Include := UpperCase(Copy((ID as IGeneralLedger2).glName, 1, Length(sFind)))
              = UpperCase(sFind);
            end;}
          end;{case}
        end else
        begin
          Include := TRUE;
        end;{if}
      end;{if}
    end;

    plGLCode : begin
      if supports(ID, IGeneralLedger2) then
      begin
        with (ID as IGeneralLedger2) do begin
          Include := (glType in IncludeGLTypes) // GL Code is of the correct "type"
          and ((iGLIncludeClass = glcANY_CLASS) or (glClass = iGLIncludeClass)) // GL Code is of the correct "class"
          and ((iGLCurrency = glccyANY_CURRENCY) or (glCurrency = iGLCurrency) or (glCurrency = glccyCONSOLIDATED)); // GL Code is of the correct currency

          // Resctrict List to ONLY those that match the search string ?
          if Include and bRestrictList and (sFind <> '') and (sFind <> '/') and (sFind <> '?')  //SSK 18/01/2017 2017-R1 ABSEXCH-17283: added condition for wildcard characters '/' or '?' to work properly
          then begin
            case iSearchCol of
              0 : begin // GL Code
                Include := Copy(IntToStr((ID as IGeneralLedger2).glCode), 1
                , Length(IntToStr(BTUnFullNomKey(sFind)))) = IntToStr(BTUnFullNomKey(sFind));
              end;

              1 : begin // GL Name
                Include := UpperCase(Copy((ID as IGeneralLedger2).glName, 1, Length(sFind)))
                = UpperCase(sFind);
              end;
            end;{case}
          end;

        end;{with}
      end else
      begin
        with (ID as IGeneralLedger) do begin
          Include := (glType in IncludeGLTypes) // GL Code is of the correct "type"
          and ((iGLCurrency = glccyANY_CURRENCY) or (glCurrency = iGLCurrency) or (glCurrency = glccyCONSOLIDATED)); // GL Code is of the correct currency

          // Resctrict List to ONLY those that match the search string ?
          if Include and bRestrictList and (sFind <> '') and (sFind <> '/') and (sFind <> '?')  //SSK 18/01/2017 2017-R1 ABSEXCH-17283: added condition for wildcard characters '/' or '?' to work properly
          then begin
            case iSearchCol of
              0 : begin // GL Code
                Include := Copy(IntToStr((ID as IGeneralLedger).glCode), 1
                , Length(IntToStr(BTUnFullNomKey(sFind)))) = IntToStr(BTUnFullNomKey(sFind));
              end;

              1 : begin // GL Name
                Include := UpperCase(Copy((ID as IGeneralLedger).glName, 1, Length(sFind)))
                = UpperCase(sFind);
              end;
            end;{case}
          end;

        end;{with}
      end;{if}
    end;

    plSupersededBy : begin
      Include := TRUE;
    end;

    plProductAndBOM, plProduct, plBOM, plProductOnly, plProductNoBOM, plProductDescOnly : begin
      with (ID as IStock) do begin

        case plType of
          plProduct : Include := stType in [stTypeProduct, stTypeDescription, stTypeBillOfMaterials];
          plBOM : Include := stType in [stTypeBillOfMaterials];
          plProductNoBOM : Include := stType in [stTypeProduct, stTypeDescription];
          plProductOnly : Include := stType in [stTypeProduct];
          plProductAndBOM : Include := stType in [stTypeProduct, stTypeBillOfMaterials];
          plProductDescOnly : Include := stType in [stTypeDescription];
        end;{case}

        if include and (iFilterMode <> NO_FILTER) then
        begin
          case iFilterMode of
            FILTER_ALTCODE : begin
              include := UpperCase(Trim(stAltCode)) = UpperCase(Trim(sFilter));
            end;

            FILTER_PARENTCODE : begin
              include := UpperCase(Trim(stParentCode)) = UpperCase(Trim(sFilter));
            end;

            FILTER_LINETYPE : begin
              include := IntToStr(stDefaultLineType) = Trim(sFilter);
            end;

            FILTER_NO_PARENTCODE : begin
              include := UpperCase(Trim(stParentCode)) <> UpperCase(Trim(sFilter));
            end;
          end;{case}
        end;{if}

        if bRestrictList and (sFind <> '') and include
        then begin
          case iSearchCol of
            0 : begin // Stock Code
              Include := UpperCase(Copy((ID as IStock).stCode, 1
              , Length(sFind))) = UpperCase(sFind);
            end;
          end;{case}
        end;{if}

      end;{with}
    end;

    plProductGroup : begin
      with (ID as IStock) do begin
        Include := stType = stTypeGroup;

        if include and (iFilterMode <> NO_FILTER) then
        begin
          case iFilterMode of
            FILTER_ALTCODE : begin
              include := UpperCase(Trim(stAltCode)) = UpperCase(Trim(sFilter));
            end;

            FILTER_PARENTCODE : begin
              include := UpperCase(Trim(stParentCode)) = UpperCase(Trim(sFilter));
            end;

            FILTER_NO_PARENTCODE : begin
              include := UpperCase(Trim(stParentCode)) <> UpperCase(Trim(sFilter));
            end;
          end;{case}
        end;{if}
      end;{with}
    end;

    plProductAndGroup : begin
      with (ID as IStock) do begin
        Include := stType in [stTypeGroup, stTypeProduct, stTypeDescription, stTypeBillOfMaterials];
      end;{with}
    end;

    plProductInAGroup : begin
      with (ID as IStock) do begin
        Include := (stType in [stTypeProduct, stTypeDescription, stTypeBillOfMaterials])
        and (Trim(stParentCode) = Trim(sParentCode));
      end;{with}
    end;

    plJob : begin
      Include := TRUE;
      if bRestrictList and (sFind <> '') and include
      then begin
        case iSearchCol of
          0 : begin // Job Code
            Include := UpperCase(Copy((ID as IJob).jrCode, 1
            , Length(sFind))) = UpperCase(sFind);
          end;
        end;{case}
      end;{if}
    end;

    plJobAnalysis : begin
      Include := TRUE;
      if bRestrictList and (sFind <> '') and include
      then begin
        case iSearchCol of
          0 : begin // Job Code
            Include := UpperCase(Copy((ID as IJobAnalysis).anCode, 1
            , Length(sFind))) = UpperCase(sFind);
          end;
        end;{case}
      end;{if}
    end;

  end;{case}
end;

procedure TfrmTKPickList.WMGetMinMaxInfo(var Message: TWMGetMinMaxInfo);
begin
  With Message.MinMaxInfo^ Do Begin
    ptMinTrackSize.X:=193;
    ptMinTrackSize.Y:=204;
  End; { With Message }
end;


procedure TfrmTKPickList.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(mlList, Self.Name, nil) of
    mrRestoreDefaults : begin
      oSettings.RestoreListDefaults(mlList, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmTKPickList.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadList(mlList, Self.Name);
end;

procedure TfrmTKPickList.SaveAllSettings;
begin
  oSettings.SaveList(mlList, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;

procedure TfrmTKPickList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
end;

function TfrmTKPickList.GetStockDescFromCode(sStockCode : string) : string;
begin
  Result := '';
  with oLToolkit.Stock do begin
    Index := stIdxCode;
    if GetEqual(BuildCodeIndex(sStockCode)) = 0
    then Result := stDesc[1];
  end;{with}
end;

constructor TfrmTKPickList.CreateWith(Sender: TComponent; AToolkit: IToolkit);
begin
  if Assigned(AToolkit) then begin
    inherited create(sender);
    oLToolkit := AToolkit;
    LoadAllSettings;
  end;{if}
end;

procedure TfrmTKPickList.btnShowAllClick(Sender: TObject);
begin
  if btnShowAll.caption = '&Show All' then
  begin
    // Show All
    plType := plProduct;
    btnShowAll.caption := '&Sales Analysis';
  end else
  begin
   // Sales Analysis
    plType := plCustSalesAnalysis;
    btnShowAll.caption := '&Show All';
  end;
  FormShow(nil);
  mlList.RefreshDB;
end;

procedure TfrmTKPickList.FormResize(Sender: TObject);
begin
  panList.Width := ClientWidth - 16;
  panList.Height := ClientHeight- 44;

  btnShowAll.Top := ClientHeight- 29;
  btnOK.Top := btnShowAll.Top;
  btnCancel.Top := btnShowAll.Top;

  btnOK.Left := ClientWidth - 177;
  btnCancel.Left := ClientWidth - 89;
end;

procedure TfrmTKPickList.FormCreate(Sender: TObject);
begin
  iCodeIndex := -1;
  iDescIndex := -1;
  iGLIncludeClass := glcANY_CLASS;
  iGLCurrency := glccyANY_CURRENCY;
  IncludeGLTypes := [glTypeProfitLoss, glTypeBalanceSheet];
  bRestrictList := FALSE;
  iFilterMode := NO_FILTER;
  bAutoSelectIfOnlyOne := FALSE;
  bShowMessageIfEmpty := FALSE;
  sFind := '';
  sCaption := '';
end;

procedure TfrmTKPickList.WMDoIt(var Message: TMessage);
begin
  case Message.LParam of
    // Click on OK, from FormShow
    1 : begin
      btnOKClick(btnOK);
    end;

    // Click on Cancel, from FormShow
    2 : begin
      MsgBox('No items could be found, that match your search criteria.'
      , mtInformation, [mbOK], mbOK, 'Not Found');
      btnCancelClick(btnCancel);
    end;
  end;{case}
end;
