unit AppsVals;

// Contains Apps & Vals extensions to the OLE Server

interface

Uses Classes, Dialogs, SysUtils, GlobVar, VarConst, OLEBtrO, VarJCstU;

Type
  TAppsAnalMode = (aamJobTotals, aamSubcontractorTotals, aamCustomerTotals);

  //------------------------------

  TAppAnalysisTotals = Class(TObject)
  Public
    aatApplied      : Double;
    aatCertified    : Double;

    Procedure Zero;
  End; // TAppAnalysisTotals

  //------------------------------

  TApplicationsAnalysisCache = Class(TObject)
  Private
    FCacheMode : TAppsAnalMode;
    FJobCode   : ShortString;
    FEmplCode  : ShortString;

    FPurchaseTotals : TAppAnalysisTotals;
    FSalesTotals : TAppAnalysisTotals;

    FPurchaseAnalysisList : TStringList;
    FSalesAnalysisList : TStringList;

    Function GetPurchaseAnalysisTotals (Analysis : String) : TAppAnalysisTotals;
    Function GetSalesAnalysisTotals (Analysis : String) : TAppAnalysisTotals;

    Procedure ClearList (TotalsList : TStringList);
    Function GetAnalysisTotals (TotalsList : TStringList; Analysis : String) : TAppAnalysisTotals;
  Public
    Property EmplCode : ShortString Read FEmplCode Write FEmplCode;
    Property JobCode : ShortString Read FJobCode Write FJobCode;

    Property PurchaseAnalysisTotals [Analysis : String] : TAppAnalysisTotals Read GetPurchaseAnalysisTotals;
    Property PurchaseTotals : TAppAnalysisTotals Read FPurchaseTotals;

    Property SalesAnalysisTotals [Analysis : String] : TAppAnalysisTotals Read GetSalesAnalysisTotals;
    Property SalesTotals : TAppAnalysisTotals Read FSalesTotals;

    Constructor Create;
    Destructor Destroy; Override;

    Function UpdateJobTotals(CacheMode : TAppsAnalMode; CompanyBtr : TdOLEExLocalPtr; JobCode, EmplCode, CustCode : String) : SmallInt;
  End; // TApplicationsAnalysisCache

  //------------------------------

  TAppsLineTypeMode = (ltmTransTotals, ltmJobPurchaseTotals, ltmJobSalesTotals);

  //------------------------------

  TAppValLineTypeAnalysisCache = Class(TObject)
  Private
    FCacheMode : TAppsLineTypeMode;
    FOurRef : String[10];
    FJobCode   : String[10];

    FLineTypeTotals : tJALLTTypes;             // Extended Line Type Totals for Apps/Vals

    Function GetTotal(LineType : Byte) : Double;

    // Processes the lines for the passed transaction and updates the totals
    Procedure UpdateTransTotals (CompanyBtr : TdOLEExLocalPtr; InvR : InvRec);
  Public
    Property ltaTotal [LineType : Byte] : Double Read GetTotal;

    Constructor Create;

    // Rebuilds the line type totals for the specified transaction
    Procedure BuildTransTotals (CompanyBtr : TdOLEExLocalPtr; InvR : InvRec);
    Procedure BuildJobTotals(CacheMode : TAppsLineTypeMode; CompanyBtr : TdOLEExLocalPtr; JobCode : ShortString);
  End; // TAppValLineTypeAnalysisCache

implementation

Uses Btrvu2, BTKeys1U, BTSupU1, ETStrU;

//=========================================================================

Procedure TAppAnalysisTotals.Zero;
Begin // Zero
  aatApplied      := 0.00;
  aatCertified    := 0.00;
End; // Zero

//=========================================================================

Constructor TApplicationsAnalysisCache.Create;
Begin
  Inherited Create;

  FJobCode := '';
  FPurchaseTotals := TAppAnalysisTotals.Create;
  FSalesTotals := TAppAnalysisTotals.Create;
  FPurchaseAnalysisList := TStringList.Create;
  FSalesAnalysisList := TStringList.Create;
End;

//------------------------------

Destructor TApplicationsAnalysisCache.Destroy;
Begin
  FreeAndNIL(FPurchaseTotals);
  FreeAndNIL(FSalesTotals);

  If Assigned(FPurchaseAnalysisList) Then
  Begin
    ClearList (FPurchaseAnalysisList);
  End;
  FreeAndNIL(FPurchaseAnalysisList);

  If Assigned(FSalesAnalysisList) Then
  Begin
    ClearList (FSalesAnalysisList);
  End;
  FreeAndNIL(FSalesAnalysisList);

  Inherited Destroy;
End;

//-------------------------------------------------------------------------

Procedure TApplicationsAnalysisCache.ClearList (TotalsList : TStringList);
Var
  AnalTotals : TAppAnalysisTotals;
Begin // ClearList
  While (TotalsList.Count > 0) Do
  Begin
    AnalTotals := TAppAnalysisTotals(TotalsList.Objects[0]);
    AnalTotals.Free;
    TotalsList.Delete(0);
  End; // While (TotalsList.Count > 0)
End; // ClearList

//-------------------------------------------------------------------------

Function TApplicationsAnalysisCache.UpdateJobTotals(CacheMode : TAppsAnalMode; CompanyBtr : TdOLEExLocalPtr; JobCode, EmplCode, CustCode : String) : SmallInt;

  //------------------------------

  Procedure ProcessTransactions (Const DoJSAs : Boolean; TypeTotals : TAppAnalysisTotals; AnalTotals : TStringList);
  Const
    WantDoc : Array [False..True] Of DocTypes = (JPA, JSA);
  Var
    sKey, sCheck  : Str255;
    iStatus       : SmallInt;
  Begin // ProcessTransactions
    With CompanyBtr^ Do
    Begin
      sKey := FullJAPJobKey (False, JobCode, False, DoJSAs);
      sCheck := Copy (sKey, 1, 11);
      iStatus := LFind_Rec(B_GetGEq, InvF, InvLYRefK, sKey);
      While (iStatus = 0) And CheckKey(sCheck,sKey,Length(sCheck),BOn) Do
      Begin
        // Check this transaction should be included within the totals
        If (LInv.InvDocHed = WantDoc[DoJSAs]) And
           (
             (CacheMode = aamJobTotals)
             Or
             ((CacheMode = aamSubcontractorTotals) And (CompanyBtr^.LInv.CISEmpl = EmplCode))
             Or
             ((CacheMode = aamCustomerTotals) And (CompanyBtr^.LInv.CustCode = CustCode))
           ) Then
        Begin
          // Update Type Totals
          TypeTotals.aatApplied   := TypeTotals.aatApplied + LInv.TotalCost;
          TypeTotals.aatCertified := TypeTotals.aatCertified + LInv.InvNetVal;

          // Run though Lines for Analysis Totals
          sKey := FullIdKey (LInv.FolioNum, 1);
          iStatus := LFind_Rec(B_GetGEq, IDetailF, IdFolioK, sKey);
          While (iStatus = 0) And (LId.FolioRef = LInv.FolioNum) Do
          Begin
            If (Trim(LId.AnalCode) <> '') Then
            Begin
              With GetAnalysisTotals (AnalTotals, LId.AnalCode) Do
              Begin
                aatApplied   := aatApplied + LId.CostPrice;
                aatCertified := aatCertified + LId.NetValue;
              End; // With GetAnalysisTotals (AnalTotals, LId.AnalCode)
            End; // If (Trim(LId.AnalCode) <> '')

            iStatus := LFind_Rec(B_GetNext, IDetailF, IdFolioK, sKey);
          End; // While (iStatus = 0) And (LId.FolioRef = LInv.FolioNum)
        End; // If (LInv.InvDocHed = WantDoc)

        iStatus := LFind_Rec(B_GetNext, InvF, InvLYRefK, sKey);
      End; // While (iStatus = 0) ...
    End; // With CompanyBtr^
  End; // ProcessTransactions

  //------------------------------

Begin // UpdateJobTotals
  Result := 0;

  // Check to see if what we want is already loaded
  JobCode := FullJobCode(JobCode);
  EmplCode := UpperCase(LJVar(EmplCode,EmplKeyLen));
  If (FCacheMode <> CacheMode) Or (FJobCode <> JobCode) Or (FEmplCode <> EmplCode) Then
  Begin
    // Rebuild the cache
    FCacheMode := CacheMode;
    FJobCode := JobCode;
    FEmplCode := EmplCode;

    // Re-initialise all totals
    FPurchaseTotals.Zero;
    FSalesTotals.Zero;
    ClearList (FPurchaseAnalysisList);
    ClearList (FSalesAnalysisList);

    // Search for transactions
    Case CacheMode Of
      aamJobTotals           : Begin
                                 ProcessTransactions(False, FPurchaseTotals, FPurchaseAnalysisList);   // JPA
                                 ProcessTransactions(True, FSalesTotals, FSalesAnalysisList);          // JSA
                               End; // aamJobTotals
      aamSubcontractorTotals : Begin
                                 ProcessTransactions(False, FPurchaseTotals, FPurchaseAnalysisList);   // JPA
                               End; // aamSubcontractorTotals
      aamCustomerTotals      : Begin
                                 ProcessTransactions(True, FSalesTotals, FSalesAnalysisList);          // JSA
                               End; // aamCustomerTotals
    End; // Case CacheMode
  End // If (FJobCode <> JobCode)
End; // UpdateJobTotals

//-------------------------------------------------------------------------

Function TApplicationsAnalysisCache.GetAnalysisTotals (TotalsList : TStringList; Analysis : String) : TAppAnalysisTotals;
Var
  Idx : SmallInt;
Begin // GetAnalysisTotals
  Analysis := FullJACode(Analysis);

  Idx := TotalsList.IndexOf (Analysis);
  If (Idx >= 0) Then
  Begin
    // Got Match - return object
    Result := TAppAnalysisTotals(TotalsList.Objects[Idx]);
  End // If (Idx >= 0)
  Else
  Begin
    // Not found - create a new entry and return it
    Result := TAppAnalysisTotals.Create;
    TotalsList.AddObject (Analysis, Result);
  End; // Else
End; // GetAnalysisTotals

//------------------------------

Function TApplicationsAnalysisCache.GetPurchaseAnalysisTotals (Analysis : String) : TAppAnalysisTotals;
Begin // GetPurchaseAnalysisTotals
  Result := GetAnalysisTotals (FPurchaseAnalysisList, Analysis);
End; // GetPurchaseAnalysisTotals

//------------------------------

Function TApplicationsAnalysisCache.GetSalesAnalysisTotals (Analysis : String) : TAppAnalysisTotals;
Begin // GetSalesAnalysisTotals
  Result := GetAnalysisTotals (FSalesAnalysisList, Analysis);
End; // GetSalesAnalysisTotals

//=========================================================================

Constructor TAppValLineTypeAnalysisCache.Create;
Begin // Create
  Inherited Create;

  FCacheMode := ltmTransTotals;
  FOurRef := '';
  FJobCode := '';
  FillChar(FLineTypeTotals, SizeOf(FLineTypeTotals), #0);
End; // Create

//-------------------------------------------------------------------------

// Processes the lines for the passed transaction and updates the totals
Procedure TAppValLineTypeAnalysisCache.UpdateTransTotals (CompanyBtr : TdOLEExLocalPtr; InvR : InvRec);
Var
  iStatus : SmallInt;
  sKey    : Str255;
Begin // UpdateTransTotals
  With CompanyBtr^ Do
  Begin
    // Run though Lines for the Line Type Totals
    sKey := FullIdKey (InvR.FolioNum, JALRetLineNo);
    iStatus := LFind_Rec(B_GetGEq, IDetailF, IdFolioK, sKey);
    While (iStatus = 0) And (LId.FolioRef = InvR.FolioNum) Do
    Begin
      // Update the extended line type totals
      If (LId.DocLTLink >= Low(FLineTypeTotals)) and (LId.DocLTLink <= High(FLineTypeTotals)) Then
      Begin
        If InvR.PDiscTaken Then
        Begin
          FLineTypeTotals[LId.DocLTLink] := FLineTypeTotals[LId.DocLTLink] + LId.NetValue;
        End // If InvR.PDiscTaken
        Else
        Begin
          FLineTypeTotals[LId.DocLTLink] := FLineTypeTotals[LId.DocLTLink] + LId.CostPrice;
        End; // Else
      End; // If (Id.DocLTLink >= Low(FLineTypeTotals)) and (Id.DocLTLink <= High(FLineTypeTotals))

      iStatus := LFind_Rec(B_GetNext, IDetailF, IdFolioK, sKey);
    End; // While (iStatus = 0) And (LId.FolioRef = InvR.FolioNum)
  End; // With CompanyBtr^ Do
End; // UpdateTransTotals

//-------------------------------------------------------------------------

// Rebuilds the line type totals for the specified transaction
Procedure TAppValLineTypeAnalysisCache.BuildTransTotals (CompanyBtr : TdOLEExLocalPtr; InvR : InvRec);
Begin // BuildTransTotals
  // Check to see if what we want is already loaded
  If (FCacheMode <> ltmTransTotals) Or (FOurRef <> InvR.OurRef) Then
  Begin
    // Rebuild the cache
    FCacheMode := ltmTransTotals;
    FOurRef := InvR.OurRef;

    // Re-initialise all totals
    FillChar(FLineTypeTotals, SizeOf(FLineTypeTotals), #0);

    UpdateTransTotals (CompanyBtr, InvR);
  End; // If (FCacheMode <> CacheMode) Or (FOurRef <> OurRef)
End; // BuildTransTotals

//-------------------------------------------------------------------------

// Rebuilds the line type totals for the specified transaction
Procedure TAppValLineTypeAnalysisCache.BuildJobTotals(CacheMode : TAppsLineTypeMode; CompanyBtr : TdOLEExLocalPtr; JobCode : ShortString);
Const
  WantDoc : Array [False..True] Of DocTypes = (JPA, JSA);
Var
  sKey, sCheck  : Str255;
  iStatus       : SmallInt;
Begin // BuildTransTotals
  // Check to see if what we want is already loaded
  If (FCacheMode <> CacheMode) Or (FJobCode <> JobCode) Then
  Begin
    // Rebuild the cache
    FCacheMode := CacheMode;
    FJobCode := JobCode;

    // Re-initialise all totals
    FillChar(FLineTypeTotals, SizeOf(FLineTypeTotals), #0);

    With CompanyBtr^ Do
    Begin
      sKey := FullJAPJobKey (False, JobCode, False, (CacheMode = ltmJobSalesTotals));
      sCheck := Copy (sKey, 1, 11);
      iStatus := LFind_Rec(B_GetGEq, InvF, InvLYRefK, sKey);
      While (iStatus = 0) And CheckKey(sCheck,sKey,Length(sCheck),BOn) Do
      Begin
        // Check this transaction should be included within the totals
        If (LInv.InvDocHed = WantDoc[CacheMode = ltmJobSalesTotals]) Then
        Begin
          UpdateTransTotals (CompanyBtr, LInv);
        End; // If (LInv.InvDocHed = WantDoc[CacheMode = ltmJobSalesTotals])

        iStatus := LFind_Rec(B_GetNext, InvF, InvLYRefK, sKey);
      End; // While (iStatus = 0) ...
    End; // With CompanyBtr^
  End; // If (FCacheMode <> CacheMode) Or (FOurRef <> OurRef)
End; // BuildTransTotals

//-------------------------------------------------------------------------

Function TAppValLineTypeAnalysisCache.GetTotal(LineType : Byte) : Double;
Begin
  If (LineType >= Low(FLineTypeTotals)) and (LineType <= High(FLineTypeTotals)) Then
  Begin
    Result := FLineTypeTotals[LineType];
  End // If (Id.DocLTLink >= Low(FLineTypeTotals)) and (Id.DocLTLink <= High(FLineTypeTotals))
  Else
  Begin
    Raise Exception.Create ('TAppValLineTypeAnalysisCache.ltaTotal: Invalid array index (' + IntToStr(LineType) + ')');
  End; // Else
End;

//=========================================================================

end.
