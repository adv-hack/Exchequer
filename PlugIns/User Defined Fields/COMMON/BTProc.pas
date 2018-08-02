unit BTProc;

interface
uses
  SQLUtils, Windows, Classes, VarConst, StrUtil, Inifiles, FileUtil, LicUtil
  , DataModule, LicRec;

const
  NoOfEntities = 31;
  aINIRefs : array [1..NoOfEntities] of string = ('CustUser', 'SuppUser', 'LineUser'
  , 'TransUser','SINHead', 'SINLine','SRCHead', 'SRCLine', 'SQUHead', 'SQULine'
  , 'SORHead', 'SORLine', 'PINHead', 'PINLine', 'PPYHead', 'PPYLine', 'PQUHead'
  , 'PQULine', 'PORHead', 'PORLine', 'NOMHead', 'NOMLine', 'StockUser', 'ADJHead'
  , 'ADJLine', 'WORHead', 'WORLine', 'JobUser', 'EmpUser', 'TSHHead', 'TSHLine');

  aEntityDescs : array [1..NoOfEntities] of string =
  ('Customer'
  , 'Supplier'
  , 'Transaction Line (All Types)'
  , 'Transaction Header (All Types)'
  , 'Sales Invoice Headers (SIN, SCR, SJI, SJC, SRI, SRF)'
  , 'Sales Invoice Lines (SIN, SCR, SJI, SJC, SRI, SRF)'
  , 'Sales Receipt Headers (SRC)'
  , 'Sales Receipt Lines (SRC)'
  , 'Sales Quotation Headers (SQU)'
  , 'Sales Quotation Lines (SQU)'
  , 'Sales Order & Delivery Note Headers (SOR, SDN)'
  , 'Sales Order & Delivery Note Lines (SOR, SDN)'
  , 'Purchase Invoice Headers (PIN, PCR, PJI, PJC, PPI, PRF)'
  , 'Purchase Invoice Lines (PIN, PCR, PJI, PJC, PPI, PRF)'
  , 'Purchase Payment Headers (PPY)'
  , 'Purchase Payment Lines (PPY)'
  , 'Purchase Quotation Headers (PQU)'
  , 'Purchase Quotation Lines (PQU)'
  , 'Purchase Order & Delivery Note Headers (POR, PDN)'
  , 'Purchase Order & Delivery Note Lines (POR, PDN)'
  , 'Nominal Headers (NOM) *'
  , 'Nominal Lines (NOM) *'
  , 'Stock Record *'
  , 'Stock Adjustment Headers (ADJ) *'
  , 'Stock Adjustment Lines (ADJ) *'
  , 'Works Order Headers (WOR) *'
  , 'Works Order Lines (WOR) *'
  , 'Job Record'
  , 'Employee Record *'
  , 'Timesheet Headers (TSH) *'
  , 'Timesheet Lines (TSH) *');

  aAVTXTypeDesc : array[1..10] of string =
  ('Job Contract Term Header (JCT)', 'Job Contract Term Lines (JCT)'
  , 'Job Sales Terms Header (JST)', 'Job Sales Terms Lines (JST)'
  , 'Job Purchase Terms Header (JPT)', 'Job Purchase Terms Lines (JPT)'
  , 'Job Purchase Applications Header (JPA)', 'Job Purchase Applications Lines (JPA)'
  , 'Job Sales Applications Header (JSA)', 'Job Sales Applications Lines (JSA)');
  aTXTypes : array[1..10] of string = ('JCT', 'JCT', 'JST', 'JST', 'JPT', 'JPT', 'JPA', 'JPA', 'JSA', 'JSA');

  NoOfNewTypes = 4;
  aTXTypeDesc : array[1..NoOfNewTypes] of string =
  ('Sales Return Header (SRN)', 'Sales Return Lines (SRN)'
  , 'Purchase Return Header (PRN)', 'Purchase Return Lines (PRN)');
  aRetTXTypes : array[1..NoOfNewTypes] of string = ('SRN', 'SRN', 'PRN', 'PRN');

  Function FullNomKey(ncode : Longint) : String20;
  function GetNextFolioNo(iFileNo : integer) : integer;
//  function AddEntity(cType : char; sFormat, sDesc : string; bShowErrors, bSQL : boolean; iFolioNo : integer = 0) : integer;
//  function AddField(sDesc, sCaption, sLookup : string; iEntityFolio, iFieldNo, iMode : integer; bShowErrors : boolean) : integer;
  procedure AddListItem(sDesc : string; iFieldFolio, iLineNo : integer; bShowErrors : boolean; SQLDataModule : TSQLDataModule);
  procedure RunConversion; stdcall;
  procedure RunConversion_V63(sCompanyCode : ANSIString); stdcall;
  function GetFieldRecFromLookUp(sLookUp : string; SQLDataModule : TSQLDataModule) : TFieldRec;
  function GetDateFormat(SQLDataModule : TSQLDataModule) : string;
  procedure SetDateFormat(sFormat : string; SQLDataModule : TSQLDataModule);
  procedure FillSLWithListItems(iFieldFolio : integer; Strings : TStrings; SQLDataModule : TSQLDataModule);
//  procedure AddMuBinSupport;
//  procedure AddAppsAndValsSupport;
//  procedure AddReturnsSupport;
  procedure DeleteAllitemsForField(iFieldFolio : integer; SQLDataModule : TSQLDataModule);

implementation
uses
  UDefProc, SysUtils, Dialogs, APIUtil, Globvar, BtrvU2, Forms, Controls;

Function FullNomKey(ncode : Longint) : String20;
Var
  TmpStr : Str20;
Begin
  FillChar(TmpStr,Sizeof(TmpStr),#0);
  Move(ncode,TmpStr[1],Sizeof(ncode));
  TmpStr[0]:=Chr(Sizeof(ncode));
  FullNomKey:=TmpStr;
end;

function GetNextFolioNo(iFileNo : integer) : integer;
var
  KeyS : Str255;
  EntityRec : TEntityRec;
  FieldRec : TFieldRec;
  ListItemRec : TListItemRec;
  iStatus, iNextFolio : LongInt;
begin
  // get original record
  FillChar(KeyS, SizeOf(KeyS), #0);
  iNextFolio := 1;
  case iFileNo of
    EntityF : begin
      iStatus := Find_Rec(B_GetLast, F[iFileNo], iFileNo, EntityRec, etFolioIdx, KeyS);
      if iStatus = 0 then iNextFolio := EntityRec.etFolioNo + 1;
    end;

    FieldF : begin
      iStatus := Find_Rec(B_GetLast, F[iFileNo], iFileNo, FieldRec, fiFolioIdx, KeyS);
      if iStatus = 0 then iNextFolio := FieldRec.fiFolioNo + 1;
    end;

  end;{case}

  Result := iNextFolio;

//DebugToFile(IntToStr(IFileNo) + ' : ' + IntToStr(iNextFolio));

  if not (iStatus in [0,4,9]) then ShowBTError(iStatus, 'Find_Rec', FileNames[iFileNo]);
end;

procedure AddListItem(sDesc : string; iFieldFolio, iLineNo : integer; bShowErrors : boolean; SQLDataModule : TSQLDataModule);
var
  iStatus : integer;
  ListItemRec : TListItemRec;
  KeyS : Str255;
begin
  if Assigned(SQLDataModule) then
  begin
    // SQL
    SQLDataModule.SQLAddListItem(sDesc, iFieldFolio, iLineNo, bShowErrors);
  end
  else
  begin
    // Pervasive
    FillChar(ListItemRec,SizeOf(ListItemRec),#0);
    ListItemRec.liDescription := PadString(psRight,sDesc,#0,length(ListItemRec.liDescription));
    ListItemRec.liFieldFolio := iFieldFolio;
    ListItemRec.liLineNo := iLineNo;
    ListItemRec.liDummyChar := IDX_DUMMY_CHAR;
    iStatus := Add_Rec(F[ListItemF], ListItemF, ListItemRec, 0);
    if bShowErrors then begin
      if iStatus = 5 then MsgBox('You already have a List Item with the given value'
      , mtInformation, [mbOK], mbOK, 'Duplicate List Item')
      else ShowBTError(iStatus, 'Add_Rec', FileNames[ListItemF]);
    end;{if}
  end;{if}
end;

procedure RunConversion;
var
  bSQL : boolean; {.046}
  iFieldFolio, iEntityFolio, iEntity, iPos : integer;
  IniF : TIniFile;
//  SQLDataModule : TSQLDataModule;

  function AddEntity(cType : char; sFormat, sDesc : string; bShowErrors : boolean; iFolioNo : integer = 0) : integer;
  var
    EntityRec : TEntityRec;
    iStatus : integer;
    KeyS : Str255;
  begin{AddEntity}
    if bSQL then
    begin
      /////////
      // SQL //
      /////////
      if SQLDataModule.SQLEntityExists(sDesc, Result) then
      begin
        if bShowErrors then
        begin
          MsgBox('You already have an Entity with the given value'
          , mtInformation, [mbOK], mbOK, 'Duplicate Entity (SQL)');
        end;{if}
      end
      else
      begin
        Result := SQLDataModule.SQLAddEntity(cType, sFormat, sDesc, iFolioNo);
      end;{if}
    end else
    begin
      ///////////////
      // Pervasive //
      ///////////////
      FillChar(EntityRec,SizeOf(EntityRec),#0);
      if iFolioNo = 0 then EntityRec.etFolioNo := GetNextFolioNo(EntityF)
      else EntityRec.etFolioNo := iFolioNo;
      EntityRec.etDescription := PadString(psRight,sDesc,#0,length(EntityRec.etDescription));
      EntityRec.etFormat := sFormat;
      EntityRec.etType := cType;
      EntityRec.etDummyChar := IDX_DUMMY_CHAR;
      iStatus := Add_Rec(F[EntityF], EntityF, EntityRec, 0);
      if bShowErrors then
      begin
        if iStatus = 5 then MsgBox('You already have an Entity with the given value'
        , mtInformation, [mbOK], mbOK, 'Duplicate Entity')
        else ShowBTError(iStatus, 'Add_Rec', FileNames[EntityF]);
      end else
      begin
        if iStatus = 5 then begin
          KeyS := EntityRec.etDescription;
          Find_Rec(B_GetEq, F[EntityF], EntityF, EntityRec, etDescriptionIdx, KeyS);
        end;{if}
      end;{if}
      Result := EntityRec.etFolioNo;
    end;{if}
  end;{AddEntity}

  function AddField(sDesc, sCaption, sLookup : string; iEntityFolio, iFieldNo, iMode : integer; bShowErrors : boolean) : integer;
  var
    iStatus : integer;
    FieldRec : TFieldRec;
    KeyS : Str255;
  begin
    if bSQL then
    begin
      /////////
      // SQL //
      /////////
      if SQLDataModule.SQLFieldExists(sLookup, Result) then
      begin
        if bShowErrors then
        begin
          MsgBox('You already have an Field with the given value'
          , mtInformation, [mbOK], mbOK, 'Duplicate Field (SQL)');
        end;{if}
      end
      else
      begin
        Result := SQLDataModule.SQLAddField(sDesc, iEntityFolio, iFieldNo, iMode, sCaption, sLookup);
      end;{if}
    end else
    begin
      ///////////////
      // Pervasive //
      ///////////////
      FillChar(FieldRec,SizeOf(FieldRec),#0);
      FieldRec.fiFolioNo := GetNextFolioNo(FieldF);
      FieldRec.fiDescription := PadString(psRight,sDesc,#0,length(FieldRec.fiDescription));
      FieldRec.fiEntityFolio := iEntityFolio;
      FieldRec.fiLineNo := iFieldNo;
      FieldRec.fiValidationMode := iMode;
      FieldRec.fiWindowCaption := sCaption;
      FieldRec.fiLookupRef := PadString(psRight,sLookup,#0,length(FieldRec.fiLookupRef));
    //  FieldRec.fiINIRef := sINIRef;
      FieldRec.fiDummyChar := IDX_DUMMY_CHAR;
      iStatus := Add_Rec(F[FieldF], FieldF, FieldRec, 0);
      if bShowErrors then
      begin
        if iStatus = 5 then MsgBox('You already have an field with the given value'
        , mtInformation, [mbOK], mbOK, 'Duplicate Field')
        else ShowBTError(iStatus, 'Add_Rec', FileNames[FieldF]);
      end else
      begin
        if iStatus = 5 then begin
          KeyS := FullNomKey(iEntityFolio) + FullNomKey(iFieldNo) + IDX_DUMMY_CHAR;
          iStatus := Find_Rec(B_GetEq, F[FieldF], FieldF, FieldRec, fiEntityFolioIdx, KeyS);
        end;
      end;{if}
      Result := FieldRec.fiFolioNo;
    end;{if}
  end;

  procedure AddListItemsFor(iFieldFolioNo : integer; sSection : string; SQLDataModule : TSQLDataModule);
  var
    iPos, iListItem, iListItemCount, iSection : integer;
  begin{AddAllListItems}
    iListItemCount := IniF.ReadInteger(sSection,'ListItemCount',0);
    for iListItem := 1 to iListItemCount do
    begin
      AddListItem(IniF.ReadString(sSection,'ListItem' + IntToStr(iListItem), ''), iFieldFolioNo, iListItem, FALSE, SQLDataModule);
    end;{for}
  end;{AddAllListItems}

  procedure AddMuBinSupport;
  var
    KeyS : str255;
    iStatus : integer;
    EntityRec : TEntityRec;
  begin{AddMuBinSupport}
    if bSQL then
    begin
      /////////
      // SQL //
      /////////
      AddEntity(ET_CATEGORY,'',ENTITY_MUBIN,FALSE, MU_BIN_ENTITY_NO);
      AddField('Codes', ENTITY_MUBIN, 'MuBinCode', MU_BIN_ENTITY_NO, 1, PM_DISABLED, FALSE); // Multi Bin Category only has 1 field
    end
    else
    begin
      ///////////////
      // Pervasive //
      ///////////////
      if GetEnterpriseVersion(GetEnterpriseDirFromReg) >= ev552 then
      begin
        KeyS := FullNomKey(MU_BIN_ENTITY_NO) + IDX_DUMMY_CHAR;
        iStatus := Find_Rec(B_GetEq, F[EntityF], EntityF, EntityRec, etFolioIdx, KeyS);
        if iStatus in [4,9] then
        begin
          // No MuBin Records found in dbase, so add them in
          AddEntity(ET_CATEGORY,'',ENTITY_MUBIN,FALSE, MU_BIN_ENTITY_NO);
          AddField('Codes', ENTITY_MUBIN, 'MuBinCode', MU_BIN_ENTITY_NO, 1, PM_DISABLED, FALSE); // Multi Bin Category only has 1 field
        end;{if}
      end;{if}
    end;{if}
  end;{AddMuBinSupport}

  procedure AddAppsAndValsSupport(ignoreHeader : boolean);
  var
    KeyS : str255;
    iEntityFolio, iField, iPos, iStatus : integer;
    EntityRec : TEntityRec;
  begin
    if (GetModuleLicence(modAppVal, GetEnterpriseDirFromReg) = 0)
    or FALSE then
    begin
      For iPos := 1 to 10 do
      begin
        if not bSQL then
        begin
          // Pervasive
          KeyS := PadString(psRight,aAVTXTypeDesc[iPos],#0,length(EntityRec.etDescription));
          iStatus := Find_Rec(B_GetEq, F[EntityF], EntityF, EntityRec, etDescriptionIdx, KeyS);
        end;

        if bSQL or (iStatus in [4,9]) or ignoreHeader then
        begin
          // No Entity Record found in dbase, so add them in
          iEntityFolio := AddEntity(ET_CATEGORY,'',aAVTXTypeDesc[iPos],FALSE);

          // All other Categories have 4 fields
          For iField := 1 to UDF_HEADER_FIELDS do         //PS 06/06/2016 2016-R2 ABSEXGENERIC-393 : Extended User Defined Fields Plug-In for 2x new TH User Fields (eRCT)
          begin
            if iPos in [1,3,5,7,9] then
            begin
              // Header Fields
              AddField('Field ' + IntToStr(iField), aTXTypes[iPos] + ' Header'
              + ' - ' + 'Field ' + IntToStr(iField), aTXTypes[iPos] + 'Head' + IntToStr(iField)
              , iEntityFolio, iField, PM_DISABLED, FALSE);
            end
            else
            begin
              if iField <= UDF_LINE_FIELDS then   //PS 06/06/2016 2016-R2 ABSEXGENERIC-393 : Extended User Defined Fields Plug-In for 2x new TH User Fields (eRCT)
              begin
              // Line Fields
                AddField('Field ' + IntToStr(iField), aTXTypes[iPos] + ' Line'
                  + ' - ' + 'Field ' + IntToStr(iField), aTXTypes[iPos] + 'Line' + IntToStr(iField)
                  , iEntityFolio, iField, PM_DISABLED, FALSE);
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  procedure AddReturnsSupport(ignoreHeader : boolean);
  var
    KeyS : str255;
    iEntityFolio, iField, iPos, iStatus : integer;
    EntityRec : TEntityRec;
  begin
    if (GetModuleLicence(modGoodsRet, GetEnterpriseDirFromReg) = 0) then
    begin
      For iPos := 1 to NoOfNewTypes do
      begin
        if not bSQL then
        begin
          // Pervasive
          KeyS := PadString(psRight,aTXTypeDesc[iPos],#0,length(EntityRec.etDescription));
          iStatus := Find_Rec(B_GetEq, F[EntityF], EntityF, EntityRec, etDescriptionIdx, KeyS);
        end;
        
        if bSQL or (iStatus in [4,9]) or ignoreHeader then
        begin
          // No Entity Record found in dbase, so add them in
          iEntityFolio := AddEntity(ET_CATEGORY,'',aTXTypeDesc[iPos],FALSE);

          // All Categories 4 fields
          For iField := 1 to UDF_HEADER_FIELDS do  //PS 06/06/2016 2016-R2 ABSEXGENERIC-393 : Extended User Defined Fields Plug-In for 2x new TH User Fields (eRCT)
          begin
            if iPos in [1,3] then
            begin
              // Header Fields
              AddField('Field ' + IntToStr(iField), aRetTXTypes[iPos] + ' Header'
              + ' - ' + 'Field ' + IntToStr(iField), aRetTXTypes[iPos] + 'Head' + IntToStr(iField)
              , iEntityFolio, iField, PM_DISABLED, FALSE);
            end
            else
            begin
              if iField <= UDF_LINE_FIELDS then  //PS 06/06/2016 2016-R2 ABSEXGENERIC-393 : Extended User Defined Fields Plug-In for 2x new TH User Fields (eRCT)
              begin
              // Line Fields
                AddField('Field ' + IntToStr(iField), aRetTXTypes[iPos] + ' Line'
                  + ' - ' + 'Field ' + IntToStr(iField), aRetTXTypes[iPos] + 'Line' + IntToStr(iField)
                  , iEntityFolio, iField, PM_DISABLED, FALSE);
              end
            end;
          end;
        end;
      end;
    end;
  end;

var
  iEntitiesInTable, iStatus, fieldCount : integer;
  bSQLConnected, addNewFields : boolean;
  FieldRec : TFieldRec;
  KeyS : Str255;
begin
  Screen.Cursor := crHourglass;
  bSQL := UsingSQL;

  if (bSQL) then
  begin
     if(not Assigned(SQLDataModule)) then
     begin
       SQLDataModule := TSQLDataModule.Create(nil);
       bSQLConnected := SQLDataModule.Connect(asCompanyPath);
     end
     else
       bSQLConnected := true;
  end
  else
    SQLDataModule := nil;
 
  if (not bSQL) or (bSQLConnected) then
  begin
    //Search for customer field 5
    KeyS := FullNomKey(1) + FullNomKey(5) + '!';
    iStatus := Find_Rec(B_GetEq, F[FieldF], FieldF, FieldRec, fiEntityFolioIdx, KeyS);

    if(iStatus <> 0) then
      addNewFields := true
    else
      addNewFields := false;

    if bSQL then iEntitiesInTable := SQLDataModule.SQLGetNoOfEntities;

    if (not bSQL) or (iEntitiesInTable < (NoOfEntities + 1)) or (addNewFields) then
    begin
      IniF := TIniFile.Create(asCompanyPath + INI_FILENAME);

      // Add All Entity Records
      For iEntity := 1 to NoOfEntities do begin
        iEntityFolio := AddEntity(ET_CATEGORY, '', aEntityDescs[iEntity], FALSE);

        if(aEntityDescs[iEntity] = 'Employee Record *') then
          fieldCount := 4
        else
        if (AnsiPos(('Header'), (aEntityDescs[iEntity])) >1)  then
          fieldCount := UDF_HEADER_FIELDS    //PS 06/06/2016 2016-R2 ABSEXGENERIC-393 : Extended User Defined Fields Plug-In for 2x new TH User Fields (eRCT)
        else
          fieldCount := UDF_LINE_FIELDS;

        //iPos = Field index
        For iPos := 1 to fieldCount do
        begin
          iFieldFolio := AddField('Field ' + IntToStr(iPos)
          , Trim(IniF.ReadString (aINIRefs[iEntity] + IntToStr(iPos)
          , 'WindowCaption', '')), aINIRefs[iEntity] + IntToStr(iPos), iEntityFolio, iPos
          , IniF.ReadInteger(aINIRefs[iEntity] + IntToStr(iPos), 'Mode', PM_DISABLED), FALSE);

          // Add All List Item Records for this Field
          AddListItemsFor(iFieldFolio, aINIRefs[iEntity] + IntToStr(iPos), SQLDataModule);
        end;
      end;

      // Add Entity Record for the Data Format
      AddEntity(ET_DATE_FORMAT, IniF.ReadString('General', 'DateFormat','dd/mm/yyyy'),'Date Format',FALSE);

      IniF.Destroy;
    end;


    if (not bSQL) or (iEntitiesInTable < 47 {there should always be 47 entities}) then
    begin
      AddMuBinSupport;
      AddAppsAndValsSupport(false);
      AddReturnsSupport(false);
    end;

  if(addNewFields) then
  begin
     AddAppsAndValsSupport(true);
     AddReturnsSupport(true);
  end;

    if FileExists(asCompanyPath + INI_FILENAME) then
      MoveFile(PChar(asCompanyPath + INI_FILENAME), PChar(asCompanyPath + 'ENTUSERF.ONO'));
  end;
  Screen.Cursor := crDefault;
end;


procedure RunConversion_V63(sCompanyCode : ANSIString); stdcall;
begin
  if Trim(sCompanyCode) <> '' then asCompanyCode := sCompanyCode;
  RunConversion;
end;

function GetFieldRecFromLookUp(sLookUp : string; SQLDataModule : TSQLDataModule) : TFieldRec;
var
  Keys : Str255;
  iStatus : integer;
begin
  if Assigned(SQLDataModule) then
  begin
    // SQL
    Result := SQLDataModule.SQLGetFieldRecFromLookup(sLookUp);
  end
  else
  begin
   // Pervasive
    KeyS := PadString(psRight,sLookUp, #0, length(Result.fiLookupRef));
    iStatus := Find_Rec(B_GetEq, F[FieldF], FieldF, Result, fiLookupRefIdx, KeyS);
    ShowBTError(iStatus, 'Find_Rec on "' + KeyS + '" ',  FileNames[FieldF]);
  end;
end;

function GetDateFormat(SQLDataModule : TSQLDataModule) : string;
var
  Keys : Str255;
  iStatus : integer;
  EntityRec : TEntityRec;
begin{GetDateFormat}
  Result := 'dd/mm/yyyy';
  if Assigned(SQLDataModule) then
  begin
    // SQL
    Result := SQLDataModule.SQLGetDateFormat;
  end
  else
  begin
    // Pervasive
    Keys := 'Date Format';
    iStatus := Find_Rec(B_GetEq, F[EntityF], EntityF, EntityRec, etDescriptionIdx, KeyS);
    if iStatus = 0 then Result := EntityRec.etFormat;
  end;{if}
end;{GetDateFormat}

procedure SetDateFormat(sFormat : string; SQLDataModule : TSQLDataModule);
var
  Keys : Str255;
  iStatus : integer;
  EntityRec : TEntityRec;
begin{SetDateFormat}
  if Assigned(SQLDataModule) then
  begin
    // SQL
    SQLDataModule.SQLSetDateFormat(sFormat);
  end
  else
  begin
    // Pervasive
    Keys := 'Date Format';
    iStatus := Find_Rec(B_GetEq, F[EntityF], EntityF, EntityRec, etDescriptionIdx, KeyS);
    if iStatus = 0 then begin
      EntityRec.etFormat := sFormat;
      iStatus := Put_Rec(F[EntityF], EntityF, EntityRec, etDescriptionIdx);
      if iStatus <> 0 then ShowBTError(iStatus, 'Put_Rec', FileNames[EntityF]);
    end;{if}
  end;{if}
end;{SetDateFormat}

procedure FillSLWithListItems(iFieldFolio : integer; Strings : TStrings; SQLDataModule : TSQLDataModule);
var
  Keys : Str255;
  iStatus : integer;
  ListItemRec : TListItemRec;
begin
  Strings.Clear;
  if Assigned(SQLDataModule) then
  begin
    // SQL
    SQLDataModule.SQLFillSLWithListItems(iFieldFolio, Strings);
  end
  else
  begin
    // Pervasive
    FillChar(Keys,Sizeof(KeyS),#0);
    KeyS := FullNomKey(iFieldFolio);
    iStatus := Find_Rec(B_GetGEq, F[ListItemF], ListItemF, ListItemRec, liFieldLineDescIdx, KeyS);
    while (iStatus = 0) and (ListItemRec.liFieldFolio = iFieldFolio) do begin
      Strings.Add (ListItemRec.liDescription);
      iStatus := Find_Rec(B_GetNext, F[ListItemF], ListItemF, ListItemRec, liFieldLineDescIdx, KeyS);
    end;{while}
  end;{if}
end;

procedure DeleteAllitemsForField(iFieldFolio : integer; SQLDataModule : TSQLDataModule);
var
  KeyS : str255;
  iStatus : integer;
  ListItemRec : TListItemRec;
begin
  if Assigned(SQLDataModule) then
  begin
    // SQL
    SQLDataModule.SQLDeleteAllitemsForField(iFieldFolio);
  end
  else
  begin
    // Pervasive
    FillChar(Keys,Sizeof(KeyS),#0);
    KeyS := FullNomKey(iFieldFolio);
    iStatus := Find_Rec(B_GetGEq, F[ListItemF], ListItemF, ListItemRec, liFieldLineDescIdx, KeyS);
    while (iStatus = 0) and (iFieldFolio = ListItemRec.liFieldFolio) do begin
      iStatus := Delete_Rec(F[ListItemF], ListItemF, liFieldLineDescIdx);
      if iStatus <> 0 then ShowBTError(iStatus, 'Delete_Rec', FileNames[ListItemF]);

      KeyS := FullNomKey(iFieldFolio);
      iStatus := Find_Rec(B_GetGEq, F[ListItemF], ListItemF, ListItemRec, liFieldLineDescIdx, KeyS);
    end;{while}
  end;{if}
end;



end.
