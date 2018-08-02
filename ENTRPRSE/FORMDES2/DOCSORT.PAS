unit DocSort;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Dialogs,
     Classes,
     Forms,
     SysUtils,
     GlobVar,
     VarConst,
     VarRec2U,
     GlobType,
     BtrvU2,
     ScratchO,
     ScratchF,
     Scrtch1U;


// Build a scratch file containing sorted ADJ lines
Procedure BuildADJLines (Const ADJMode   : Byte;
                         Const oScratch  : ScratchPtr);

// Builds a scratch file containing sorted Transaction Lines
Procedure BuildTransLines (Const SortMode               : Byte;
                           Const oScratch               : ScratchPtr;
                           Const HeaderRec              : fdHeaderRecType;
                           Const ApplyPickingListFilter : Boolean);

// Takes the input file for a non-Serial/Batch/Bin Consolidated Picking List and sorts it
// into a user selected order
Procedure BuildSortedConsolidatedPickingList (Const SortMode : Byte;
                                              Const oScratch : ScratchPtr);

// Builds a Single Picking List including Multi-Bin information
Procedure BuildSinglePickListWithBins (Const ShowAllStock, ShowDescLines, ShowHiddenBoM : Boolean);

// Runs through the Scratch File passed in from Exchequer containing the Transaction
// Lines to be included within the Consolidated Picking List and builds a second scratch
// file for the print job including the Multi-Bin information
Procedure BuildConsolPickListWithBins (Const oScratch     : ScratchPtr;    // Scratch file of ID lines to be included
                                       Const ShowAllStock : Boolean);

implementation

Uses ETStrU, ETMiscU, ComnU2, BtKeys1U, InvListU, SysU2, BTSupU1, DicLinkU,
     SavePos,      // TBtrieveSavePosition object
     PickListUtil, // Picking List utility functions
     oSerialBatch, // Serial/Batch Classes
     IIFFuncs;

Type
  TBtrieveFileSavePos = Record
    fsFileNo   : SmallInt;
    fsKeyPath  : Integer;
    fsStatus   : SmallInt;
    fsRecAddr  : LongInt;
  End; { TBtrieveFileSavePos }

  pIDetail = ^IDetail;

//  TBinInfo = Class(TObject)
//  Public
//    biBinCode   : String[BinLocLen];
//    biStockCode : String[StkKeyLen];
//    biQty       : Double;
//
//    // Saved position in Id     (Trans Line)
//    biIDPos     : TBtrieveFileSavePos;
//
//    // Saved Position in MLocF  (Bin Record)
//    biBinPos    : TBtrieveFileSavePos;
//
//    // Saved Position in StockF (Stock Record)
//    biStockPos  : TBtrieveFileSavePos;
//  End; // TBinInfo

  //------------------------------

  TBinList = Class(TScratchFile)
  Private
    // Counter to control the allocation of unique Id numbers
    FNextStockId : LongInt;

    // Flag indicates whether Description Lines should be included within the Picking List
    FShowDescLines : Boolean;

    // Keeps track of which set of transaction lines if any is loaded into the lines cache
    FFolioRef, FABSLineNo : LongInt;

    // Transaction Lines cache when printing Additional Description Lines - need to cache them
    // as it is likely that one line can generate multiple bin entries so this will be far more
    // effective than re-reading them every time.
    FDescLines : TList;

    // The KitLink expected for the description lines, normally this will be the Stock Folio, but
    // for exploded BOM's this will be the Stock Folio from the original BOM Component
    FDescKitLink : LongInt;

    Procedure ClearCache;
    Procedure BuildDescCache (Const TransLine : IDetail);
    Procedure AddDescLine (Const TransLine                                                    : IDetail;
                           Const StockCode, BinCode, LocCode, Priority, StockIdStr, LineNoStr : ShortString;
                           Const LineNo, StockId                                              : LongInt);
  Public
    Property DescKitLink : LongInt Read FDescKitLink Write FDescKitLink;
    Property ShowDescLines : Boolean Read FShowDescLines;

    Constructor Create (Const ProcessId : LongInt; Const ShowDesc : Boolean);
    Destructor Destroy; Override;

    Procedure AddBinInfo (Const TransLine                                      : IDetail;
                                BinCode, LocCode, Priority                     : ShortString;
                          Const PickedQty, UnpickedQty                         : Double;
                          Const SaveIdPos, SaveBinPos, SaveStkPos, AddingTotal : Boolean);

    // Looks up the current Bin in the usage totals (sfProcessId + 1000) and
    // adjusts the Bins availability figures accordingly
    Procedure CheckBinUsage (StockCode, BinCode, LocCode : ShortString);
  End;

  // Caching structure used by transaction line sorting functions
  CacheRecType = Record
    caStockCode   : String[StkKeyLen];
    caLocation    : String[MLocKeyLen];
    caBinLocation : String[BinLocLen];

    caCompCode    : String[StkKeyLen];
    caCompLoc     : String[MLocKeyLen];
    caCompBinLoc  : String[BinLocLen];
  End; { CacheRecType }



//--------------------------------------------------------------------------

Procedure GetStockByFolio (Const StockFolio : LongInt);
Var
  lStatus : SmallInt;
  KeyS    : Str255;
Begin { GetStockByFolio }
  KeyS := FullNomKey (StockFolio);
  lStatus := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkFolioK, KeyS);
End; { GetStockByFolio }

//------------------------------

// Build a scratch file containing sorted ADJ lines
Procedure BuildADJLines (Const ADJMode   : Byte;
                         Const oScratch  : ScratchPtr);
Var
  IdSavePos, StkSavePos : TBtrieveFileSavePos;
  RecAddr               : LongInt;
  lStatus               : SmallInt;
  KeyS, SortKey         : Str255;
  LineStock             : ^StockRec;
Begin { BuildADJLines }
  // Save position in Details.Dat
  With IdSavePos Do Begin
    fsFileNo  := IDetailF;
    fsKeyPath := GetPosKey;
    fsStatus  := Presrv_BTPos (fsFileNo, fsKeyPath, F[fsFileNo], fsRecAddr, BOff, BOff);
  End; { With IdSavePos }

  // Save position in Stock.Dat
  With StkSavePos Do Begin
    fsFileNo  := StockF;
    fsKeyPath := GetPosKey;
    fsStatus  := Presrv_BTPos (fsFileNo, fsKeyPath, F[fsFileNo], fsRecAddr, BOff, BOff);
  End; { With StkSavePos }

  New (LineStock);
  FillChar (LineStock^, SizeOf(LineStock^), #0);

  // Find first line
  KeyS := FullNomKey (Inv.FolioNum) + FullNomKey(-1);
  lStatus := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, KeyS);
  While (lStatus = 0) And (Id.FolioRef = Inv.FolioNum) Do Begin
    // Check to see if Stock Record is needed
    If (ADJMode In [4, 5, 7, 8, 11, 12, 15]) Then
      // Stock record needed for sorting
      If (LineStock^.StockCode <> Id.StockCode) then Begin
        GetStock(Application.MainForm, Id.StockCode, Id.StockCode, -1);
        LineStock^ := Stock;
      End; { If (LineStock^.StockCode <> Id.StockCode) }

    // Get Record Position
    GetPos(F[IDetailF], IDetailF, RecAddr);

    // Build sort key
    SortKey := '';
    Case ADJMode Of
      // Build Order
      1  : SortKey := 'A';

      // Sort by Stock Code
      2  : SortKey := FullStockCode(Id.StockCode);
      // Sort by Location and Stock Code
      3  : SortKey := Full_MLocKey(Id.MLocStk) + FullStockCode(Id.StockCode);
      // Sort by Location and Build Order
      6  : SortKey := Full_MLocKey(Id.MLocStk);

      // Sort by Bin Location and Stock Code
      4  : SortKey := LJVar(LineStock^.BinLoc, BinLocLen) + FullStockCode(Id.StockCode);
      // Sort by Location, Bin Location and Stock Code
      5  : SortKey := Full_MLocKey(Id.MLocStk) + LJVar(LineStock^.BinLoc, BinLocLen) + FullStockCode(Id.StockCode);
      // Sort by Bin Location and Build Order
      7  : SortKey := LJVar(LineStock^.BinLoc, BinLocLen);
      // Sort by Location, Bin Location and Build Order
      8  : SortKey := Full_MLocKey(Id.MLocStk) + LJVar(LineStock^.BinLoc, BinLocLen);


      9,  // Sort by Component - Stock Code Order
      10, // Sort by Component - Build Order
      11, // Sort by Component - Bin Location and Stock Code Order
      12, // Sort by Component - Bin Location and Build Order
      13, // Sort by Component - Location and Stock Code Order
      14, // Sort by Component - Location and Build Order
      15 : Begin // Sort by Component - Location, Bin Location and Stock Code Order
             If (Id.LineNo <> -1) Then
               // Main Component line
               SortKey := FullStockCode(Id.StockCode) + '01'
             Else Begin
               // Sub-Component

               // Get main component stock record using BOM Kit Link
               If (Stock.StockFolio <> Id.KitLink) Then
                 // Load stock record
                 GetStockByFolio (Id.KitLink);

               // Set base SortKey for a sub-component line
               SortKey := FullStockCode(Stock.StockCode) + '02';

               Case ADJMode Of
                 // Sort by Component - Stock Code Order
                 9  : SortKey := SortKey + FullStockCode(Id.StockCode);
                 // Sort by Component - Build Order
                 10 : ; { No additional sorting required }
                 // Sort by Component - Bin Location and Stock Code Order
                 11 : SortKey := SortKey + LJVar(LineStock^.BinLoc, BinLocLen) + FullStockCode(Id.StockCode);
                 // Sort by Component - Bin Location and Build Order
                 12 : SortKey := SortKey + LJVar(LineStock^.BinLoc, BinLocLen);
                 // Sort by Component - Location and Stock Code Order
                 13 : SortKey := SortKey + Full_MLocKey(Id.MLocStk) + FullStockCode(Id.StockCode);
                 // Sort by Component - Location and Build Order
                 14 : SortKey := SortKey + Full_MLocKey(Id.MLocStk);
                 // Sort by Component - Location, Bin Location and Stock Code Order
                 15 : SortKey := SortKey + Full_MLocKey(Id.MLocStk) + LJVar(LineStock^.BinLoc, BinLocLen) + FullStockCode(Id.StockCode);
               End; { Case ADJMode }
             End; { Else }
           End;
    End; { Case }

    {ShowMessage ('Id.FolioRef: ' + IntToStr(Id.FolioRef) + #13 +
                 'Id.AbsLineNo: ' + IntToStr(Id.ABSLineNo) + #13 +
                 'Id.StockCode: ' + Id.StockCode + #13 +
                 'SortKey: ' + SortKey);}

    // Add entry into scratch file
    oScratch.Add_Scratch (IDetailF, IdFolioK, RecAddr, SortKey, '');

    // get next record
    lStatus := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, KeyS);
  End; { While }

  Dispose (LineStock);

  // Restore starting position in Stock.Dat
  With StkSavePos Do
    If (FsStatus = 0) Then
      fsStatus := Presrv_BTPos(fsFileNo, fsKeyPath, F[fsFileNo], fsRecAddr, BOn, BOff);

  // Restore starting position in Details.Dat
  With IdSavePos Do
    If (FsStatus = 0) Then
      fsStatus := Presrv_BTPos(fsFileNo, fsKeyPath, F[fsFileNo], fsRecAddr, BOn, BOff);
End; { BuildADJLines }

//--------------------------------------------------------------------------

Function ProcessLine (Const SortMode : Byte; Var Cache : CacheRecType; Var LineStock : StockRec; Var LineStockLoc : MStkLocType; Var RecAddr : LongInt; Const ForceStockLoad : Boolean = False) : String;
Var
  KeyS : Str255;
  lStatus : SmallInt;
Begin // ProcessLine
  // Check to see if Stock Record is needed
  If (SortMode In [3, 4]) Or ForceStockLoad Then
  Begin
    // Stock record needed for sorting
    If (LineStock.StockCode <> Id.StockCode) then Begin
      ResetRec(StockF);
      GetStock(Application.MainForm, Id.StockCode, Id.StockCode, -1);
      LineStock := Stock;
    End; { If (LineStock.StockCode <> Id.StockCode) }

    // MH 03/03/2010: Extended to read in Stock-Location record to bring in the Bin Location field
    If (Trim(Id.MLocStk) <> '') Then
    Begin                       
      // Load Stock-Location record if not already loaded
      If (Copy(LineStockLoc.lsStkCode, 1, StkKeyLen) <> Id.StockCode) Or (Copy(LineStockLoc.lsLocCode, 1, 3) <> Id.MLocStk) Then
      Begin
        KeyS := PartCCKey(CostCCode, CSubCode[BOff]) + FullStockCode(Id.StockCode) + Full_MLocKey(Id.MLocStk);
        lStatus := Find_Rec(B_GetEq, F[MLocF], MLocF, RecPtr[MLocF]^, MLK, KeyS);
        If (lStatus = 0) then
          LineStockLoc := MLocCtrl^.MStkLoc
        Else
          FillChar (LineStockLoc, SizeOf(LineStockLoc), #0);
      End; // If (Copy(LineStockLoc.lsLocCode, 1, 3) <> Id.MLocStk)

      // Copy fields from Stock-Location record back into Stock record for usage
      LineStock.BinLoc := LineStockLoc.lsBinLoc;
    End; // If (Trim(Id.MLocStk) <> '')
  End; // If (SortMode In [3, 4]) Or ForceStockLoad

  // Get Record Position
  GetPos(F[IDetailF], IDetailF, RecAddr);

  With Cache Do
  Begin
    If Is_FullStkCode (Id.StockCode) Then Begin
      // Stock Code Line
      If (Id.KitLink = 0) Or (Id.LineNo = -1) Then Begin
        // original Stock Code Line - record details for use
        FillChar(Cache, SizeOf(Cache), #0);
        caStockCode   := Id.StockCode;
        caLocation    := Id.MLocStk;
        caBinLocation := LineStock.BinLoc;
      End { If (Id.KitLink = 0) }
      Else Begin
        // sub-component line
        caCompCode    := Id.StockCode;
        caCompLoc     := Id.MLocStk;
        caCompBinLoc  := LineStock.BinLoc;
      End; { Else }
    End { If Is_FullStkCode }
    Else Begin
      If (Id.KitLink = 0) Then Begin
        // Description Only Line - Sort with previous stock/component item
        // MH 09/11/06: Modified to sort non-stock items at the top of the list
        caStockCode   := '';
        caLocation    := '';
        caBinLocation := '';
      End { If (Id.KitLink = 0) }
      Else Begin
        // Additional description line - Sort with previous stock/component item
      End; { Else }
    End; { Else }

    // Build sort key from Cache info (max 100 chars)
    Result := '';
    Case SortMode Of
      // Sort by Stock Code
      1  : Result := FullStockCode(caStockCode) +       // Original Stock Code
                     FullStockCode(caCompCode);         // Component Stock Code

      // Sort by Location and Stock Code
      2  : Result := Full_MLocKey(caLocation) +         // Original Stock Location
                     FullStockCode(caStockCode) +       // Original Stock Code
                     Full_MLocKey(caCompLoc) +          // Component Stock Location
                     FullStockCode(caCompCode);         // Component Stock Code

      // Sort by Bin Location and Stock Code
      3  : Result := LJVar(caBinLocation, BinLocLen) +  // Original Stock Bin
                     FullStockCode(caStockCode) +       // Original Stock Code
                     LJVar(caCompBinLoc, BinLocLen) +   // Component Stock Bin
                     FullStockCode(caCompCode);         // Component Stock Code

      // Sort by Location and Bin Location and Stock Code
      4  : Result := Full_MLocKey(caLocation) +         // Original Stock Location
                     LJVar(caBinLocation, BinLocLen) +  // Original Stock Bin
                     FullStockCode(caStockCode) +       // Original Stock Code
                     Full_MLocKey(caCompLoc) +          // Component Stock Location
                     LJVar(caCompBinLoc, BinLocLen) +   // Component Stock Bin
                     FullStockCode(caCompCode);         // Component Stock Code

      // Sort by Component - Location and Stock Code Order
      5  : Begin
             If (Id.LineNo <> -1) Then
               // Main Component line
               Result := FullStockCode(Id.StockCode) + '01'
             Else Begin
               // Sub-Component

               // Get main component stock record using BOM Kit Link
               If (Stock.StockFolio <> Id.KitLink) Then
                 // Load stock record
                 GetStockByFolio (Id.KitLink);

               // Set base SortKey for a sub-component line
               Result := FullStockCode(Stock.StockCode) + '02';

               Case SortMode Of
                 // Sort by Component - Stock Code Order
                 5  : Result := Result + FullStockCode(Id.StockCode);
                 // Sort by Component - Build Order
                 //10 : ; { No additional sorting required }
                 // Sort by Component - Bin Location and Stock Code Order
                 //11 : SortKey := SortKey + LJVar(LineStock^.BinLoc, BinLocLen) + FullStockCode(Id.StockCode);
                 // Sort by Component - Bin Location and Build Order
                 //12 : SortKey := SortKey + LJVar(LineStock^.BinLoc, BinLocLen);
                 // Sort by Component - Location and Stock Code Order
                 //13  : Result := Result + Full_MLocKey(Id.MLocStk) + FullStockCode(Id.StockCode);
                 // Sort by Component - Location and Build Order
                 //14 : SortKey := SortKey + Full_MLocKey(Id.MLocStk);
                 // Sort by Component - Location, Bin Location and Stock Code Order
                 //15 : SortKey := SortKey + Full_MLocKey(Id.MLocStk) + LJVar(LineStock^.BinLoc, BinLocLen) + FullStockCode(Id.StockCode);
               End; { Case SortMode }
             End; // Else
           End; // 5 - Sort by Component - Location and Stock Code Order
      End; { Case SortMode }
  End; // With Cache^
End; // ProcessLine

//-------------------------------------------------------------------------

// Builds a scratch file containing sorted Transaction Lines
// MH 07/11/06: Extended to do non-Serial/Batch/Bin picking lists
Procedure BuildTransLines (Const SortMode               : Byte;
                           Const oScratch               : ScratchPtr;
                           Const HeaderRec              : fdHeaderRecType;
                           Const ApplyPickingListFilter : Boolean);
Var
  IdSavePos, StkSavePos : TBtrieveFileSavePos;
  StkLocSavePos         : TBtrieveSavePosition;
  RecAddr               : LongInt;
  lStatus               : SmallInt;
  KeyS, SortKey, LastSortKey : Str255;
  LastId                : ^IDetail;
  LineStock, LastStock  : ^StockRec;
  LineStockLoc          : ^MStkLocType;
  Cache                 : ^CacheRecType;
  PrintingSNo, StockUsingSno : Boolean;

  //------------------------------

  Procedure InsertSerialNos;
  Var
    iSerialLine  : LongInt;
  Begin // InsertSerialNos
    If StockUsingSno Then
    Begin
      With TLineSerialBatchDetails.Create (HeaderRec.fhSerialNo, Inv, LastStock^, LastId^) Do
      Begin
        Try
          If (SerialLineCount > 0) Then
          Begin
            For iSerialLine := 0 To (SerialLineCount - 1) Do
              oScratch.Add_Scratch (IDetailF, IdFolioK, 0, LastSortKey, SerialLines[iSerialLine]);
          End; // If (SerialLineCount > 0)
        Finally
          Free;
        End; // Try..Finally
      End; // With TLineSerialBatchDetails.Create
    End; // If StockUsingSno
  End; // InsertSerialNos

  //------------------------------

Begin { BuildTransLines }
  // Save position in Details.Dat
  With IdSavePos Do Begin
    fsFileNo  := IDetailF;
    fsKeyPath := GetPosKey;
    fsStatus  := Presrv_BTPos (fsFileNo, fsKeyPath, F[fsFileNo], fsRecAddr, BOff, BOff);
  End; { With IdSavePos }

  // Save position in Stock.Dat
  With StkSavePos Do Begin
    fsFileNo  := StockF;
    fsKeyPath := GetPosKey;
    fsStatus  := Presrv_BTPos (fsFileNo, fsKeyPath, F[fsFileNo], fsRecAddr, BOff, BOff);
  End; { With StkSavePos }

  // Save position in MLocStk.Dat
  StkLocSavePos := TBtrieveSavePosition.Create;
  Try
    StkLocSavePos.SaveFilePosition (MLocF, GetPosKey);
    StkLocSavePos.SaveDataBlock (MLocCtrl, SizeOf(MLocCtrl^));

    //------------------------------

    New (LastId);
    FillChar (LastId^, SizeOf(LastId^), #0);

    New (LastStock);
    FillChar (LastStock^, SizeOf(LastStock^), #0);

    New (LineStock);
    FillChar (LineStock^, SizeOf(LineStock^), #0);

    New(LineStockLoc);
    FillChar (LineStockLoc^, SizeOf(LineStockLoc^), #0);

    New (Cache);
    FillChar(Cache^, SizeOf(Cache^), #0);

    LastSortKey := '';
    PrintingSNo := (HeaderRec.fhSerialNo > 0);
    StockUsingSno := False;

    // Find first line
    KeyS := FullNomKey (Inv.FolioNum);
    If HeaderRec.fhExplodeBoMs Then
      KeyS := KeyS + FullNomKey(-1);

    lStatus := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, KeyS);
    While (lStatus = 0) And (Id.FolioRef = Inv.FolioNum) Do Begin
      // MH 07/11/06: Added additional filtering to allow routine to generate picking lists
      If (Not ApplyPickingListFilter) Or
         (ApplyPickingListFilter And FilterSinglePickingListLine (HeaderRec.fhInclNewLines, HeaderRec.fhShowDescOnly, HeaderRec.fhShowAddDesc, HeaderRec.fhExplodeBoMs)) Then
      Begin
        // Process the line
        SortKey := ProcessLine (SortMode, Cache^, LineStock^, LineStockLoc^, RecAddr, PrintingSNo);

        // MH 18/09/2009: Modified to support Serial/Batch
        If PrintingSNo Then
        Begin
          // On change of Sortkey (Stock) check to see if Serial Numbers need to be printed
          // NOTE: Works because all SortKeys have the Stock Code in them
          // (LastSortKey <> '') And (LastSortKey <> SortKey) Then
          If (LastSortKey <> '') And ((LastSortKey <> SortKey) Or (LastId^.StockCode = Id.StockCode)) Then
          Begin
            // Check to see if we are using Serial Numbers
            InsertSerialNos;
          End; // If (LastSortKey <> '') And (LastSortKey <> SortKey)

          If (LineStock^.StockCode <> '') Then
          Begin
            // Check to see if we are using Serial Numbers on the current stock item
            StockUsingSno := Is_SerNo(LineStock^.StkValType) And (Abs(Id.SerialQty) > 0);
            LastId^ := Id;
            LastStock^ := Stock;
          End; // If (LineStock^.StockCode <> '')
        End; // If PrintingSNo
        LastSortKey := SortKey;

        // Add entry into scratch file
        oScratch.Add_Scratch (IDetailF, IdFolioK, RecAddr, SortKey, SortKey);
      End; // If (Not ApplyPickingListFilter) Or

      // get next record
      lStatus := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, KeyS);
    End; { While }

    // Check to see if any Serial No's need to be printed for the last line
    If PrintingSNo Then
      InsertSerialNos;

    Dispose (Cache);
    Dispose (LineStockLoc);
    Dispose (LineStock);
    Dispose (LastStock);
    Dispose (LastId);

    //------------------------------

    // Restore position in MLocStk file
    StkLocSavePos.RestoreDataBlock (MLocCtrl);
    StkLocSavePos.RestoreSavedPosition;
  Finally
    StkLocSavePos.Free;
  End; // Try..Finally

  // Restore starting position in Stock.Dat
  With StkSavePos Do
    If (FsStatus = 0) Then
      fsStatus := Presrv_BTPos(fsFileNo, fsKeyPath, F[fsFileNo], fsRecAddr, BOn, BOff);

  // Restore starting position in Details.Dat
  With IdSavePos Do
    If (FsStatus = 0) Then
      fsStatus := Presrv_BTPos(fsFileNo, fsKeyPath, F[fsFileNo], fsRecAddr, BOn, BOff);
End; { BuildTransLines }

//-------------------------------------------------------------------------

// Takes the input file for a non-Serial/Batch/Bin Consolidated Picking List and sorts it
// into a user selected order
Procedure BuildSortedConsolidatedPickingList (Const SortMode : Byte;
                                              Const oScratch : ScratchPtr);
Var
  IdSavePos, StkSavePos, StkLocSavePos   : TBtrieveSavePosition;
  IdSaveRec               : IDetail;
  LineStockLoc            : ^MStkLocType;
  RecAddr                 : LongInt;
  lStatus                 : SmallInt;
  KeyS, SortKey         : Str255;
  LineStock             : ^StockRec;
  Cache                 : ^CacheRecType;
  PickList              : TScratchFile;
Begin // BuildSortedConsolidatedPickingList
  // Save position in Details.Dat
  IdSavePos := TBtrieveSavePosition.Create;
  Try
    IdSavePos.SaveFilePosition (IDetailF, GetPosKey);
    IdSaveRec := Id;

    // Save position in Stock.Dat
    StkSavePos := TBtrieveSavePosition.Create;
    Try
      StkSavePos.SaveFilePosition (StockF, GetPosKey);

      // Save position in Stock.Dat
      StkLocSavePos := TBtrieveSavePosition.Create;
      Try
        StkLocSavePos.SaveFilePosition (MLocF, GetPosKey);

        //------------------------------

        New (LineStock);
        FillChar (LineStock^, SizeOf(LineStock^), #0);

        New (LineStockLoc);
        FillChar (LineStockLoc^, SizeOf(LineStockLoc^), #0);

        New (Cache);
        FillChar(Cache^, SizeOf(Cache^), #0);

        // Create BinList to store & manage the Bin/Stock information
        PickList := TScratchFile.Create(1013);
        Try
          // Find the first entry from the Exchequer Consolidated Picking List in the file
          KeyS := FullNomKey (1);
          lStatus := Find_Rec(B_GetGEq, F[ReportF], ReportF, RecPtr[ReportF]^, RPK, KeyS);
          While (lStatus = 0) And (RepScr^.RepFolio = 1) Do
          Begin
            // Filter out non-database link lines as they crash Get_Scratch
            If (RepScr^.RecAddr <> 0) Then
            Begin
              // Link to Transaction Line
              oScratch.Get_Scratch(RepScr^);

              // Process the line
              SortKey := ProcessLine (SortMode, Cache^, LineStock^, LineStockLoc^, RecAddr);

              // Add a new element with the details
              PickList.InitForAdd;
              PickList.sfSortKey1 := SortKey;
              PickList.sfSortKey2 := SortKey;
              PickList.sfSavePositions[1].SaveRecordPosition (IDetailF, GetPosKey);
              Report_BError(ScratchFileF, PickList.Save);
            End; // If (RepScr^.RecAddr <> 0)

            // Get the next entry from the Exchequer Consolidated Picking List in the file
            lStatus := Find_Rec(B_GetNext, F[ReportF], ReportF, RecPtr[ReportF]^, RPK, KeyS);
          End; // While (lStatus = 0) And (RepScr^.RepFolio = 1)
        Finally
          FreeAndNIL(PickList);
        End; // Try..Finally

        Dispose (Cache);
        Dispose (LineStockLoc);
        Dispose (LineStock);

        //------------------------------

        // Restore position in MLocStk file
        StkLocSavePos.RestoreSavedPosition;
      Finally
        StkLocSavePos.Free;
      End; // Try..Finally

      // Restore position in Stock file
      StkSavePos.RestoreSavedPosition;
    Finally
      StkSavePos.Free;
    End; // Try..Finally

    // Restore position in Transaction Lines file
    IdSavePos.RestoreSavedPosition;
    Id := IdSaveRec;
  Finally
    IdSavePos.Free;
  End; // Try..Finally
End; // BuildSortedConsolidatedPickingList

//=========================================================================

Constructor TBinList.Create (Const ProcessId : LongInt; Const ShowDesc : Boolean);
Begin // Create
  Inherited Create (ProcessId);

  FDescLines := TList.Create;

  FShowDescLines := ShowDesc;
  FNextStockId := 1;

  FFolioRef  := -1;
  FABSLineNo := -1;
End; // Create

//------------------------------

Destructor TBinList.Destroy;
Begin // Destroy
  ClearCache;
  FreeAndNIL(FDescLines);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TBinList.ClearCache;
Var
  pId : pIDetail;
Begin // ClearCache
  While (FDescLines.Count > 0) Do
  Begin
    pId := Pointer(FDescLines.Items[0]);
    Dispose (pId);
    FDescLines.Delete(0);
  End; // While (FDescLines.Count > 0)
End; // ClearCache

//------------------------------

Procedure TBinList.BuildDescCache (Const TransLine : IDetail);
Var
  IdSavePos : TBtrieveSavePosition;
  pId       : pIDetail;
  lStatus   : SmallInt;
  KeyS      : Str255;
Begin // BuildDescCache
  ClearCache;

  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position and record in the transaction lines file
      SaveFilePosition (IDetailF, GetPosKey);
      SaveDataBlock (@Id, SizeOf(Id));

      // Run through the transaction lines DB to find additional desc lines
      KeyS := '';
      lStatus := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, KeyS);
      While (lStatus = 0) And
            (Id.FolioRef = TransLine.FolioRef) And     // Check its the correct transaction
            (Trim(Id.StockCode) = '') And              // Stop if there is a stock code (new line or exploded bom)
            (Id.KitLink = FDescKitLink) Do             // Check KitLink matches the expected KitLink
      Begin
        // Add the line into the desc lines list
        New (pId);
        pId^ := Id;
        FDescLines.Add(pId);

        lStatus := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, KeyS);
      End; // While (lStatus = 0) And (Id.FolioRef = TransLine.FolioRef) And (Id.KitLink = FStock.StockFolio)

      // Restore the record and position in transaction lines file
      RestoreSavedPosition;
      RestoreDataBlock (@Id);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // BuildDescCache

//-------------------------------------------------------------------------

// Adds the Bin Details into the list by updating any matching Bin/Stock element
// or by adding a new element for the Bin/Stock
Procedure TBinList.AddBinInfo (Const TransLine                                      : IDetail;
                                     BinCode, LocCode, Priority                     : ShortString;
                               Const PickedQty, UnpickedQty                         : Double;
                               Const SaveIdPos, SaveBinPos, SaveStkPos, AddingTotal : Boolean);
Var
  BinSavePos                : TBtrieveSavePosition;
  StockCode                 : String[StkKeyLen];
  KeyS, sIdx                : Str255;
  ProcId, StkFolio, StockId : LongInt;
  StockIdStr, LineNoStr     : String[6];
  lStatus, I                : SmallInt;
  pId                       : pIDetail;
Begin // AddBinInfo
  // Build a formatted index string for the Bin + Stock Code Combo
  BinCode   := UpcaseStr(LJVar(BinCode,BinLocLen));
  StockCode := FullStockCode(TransLine.StockCode);
  LocCode   := Full_MLocKey(LocCode);
  Priority  := UpcaseStr(LJVar(Priority,10));

  If AddingTotal Then
  Begin
    // Use 1000 offset to build up a second list which contains the totals already used,
    // as it is a different offset it will survive across Single Picking Lists when doing
    // a Picking List run.  This means that list 2 won't try to re-use stuff on list 1
    ProcId := sfProcessId + 1000;

    // Always write totals to same Stock Id to consolidate them
    StockId := 0;
    StockIdStr := '000000';
  End // If AddingTotal
  Else
  Begin
    ProcId := sfProcessId;

    If FShowDescLines Then
    Begin
      // Showing Additional Description Lines - always write to a new Stock Id as you can't
      // consolidate them without checking the text of all the lines, and I don't have space
      // to store them together so that I can easily compare them.  Would be major league
      // complexity to do that and it would likely slow things down
      StockId := FNextStockId;
      FNextStockId := FNextStockId + 1;
      StockIdStr := Format('%6.6d', [StockId]);
    End // If FShowDescLines
    Else
    Begin
      // Don't show Desc Lines - Always write totals to same Stock Id to consolidate them
      StockId := 0;
      StockIdStr := '000000';
    End;
  End; // Else

  // This is used to ensure the lines sort correctly within each StockId, for all lines
  // except the Additional Description Lines it will be 000000
  LineNoStr := '000000';

  If (Not FShowDescLines) Or AddingTotal Then
  Begin
    // Check to see whether the combo already exists in the list so we can consolidate them
    KeyS := FullNomKey(ProcId) + LJVar(LocCode + BinCode + StockCode + StockIdStr + LineNoStr, SizeOf(sfSortKey1) - 1);
    lStatus := Find_Rec(B_GetEq, F[ScratchFileF], ScratchFileF, RecPtr[ScratchFileF]^, 0, KeyS);
  End // If (Not FShowDescLines) Or AddingTotal
  Else
  Begin
    // Fake an error to cause a new record to be added - can't consolidate when showing description lines
    lStatus := 4;
  End; // Else

  If (lStatus = 0) Then
  Begin
    // Already exists - increment the quantity and counter and update
    sfDoubles[1] := sfDoubles[1] + PickedQty;
    sfDoubles[2] := sfDoubles[2] + UnpickedQty;
    sfBytes[1]   := sfBytes[1] + 1;
    Report_BError(ScratchFileF, Update);
  End // If (IndexOf (sIdx) > -1)
  Else Begin
    // Doesn't exist - add a new element with the details
    InitForAdd;

    OverrideRecProcessId (ProcId);

    // Sort Key for Index 0
    sfSortKey1 := LJVar(LocCode + BinCode + StockCode + StockIdStr + LineNoStr, SizeOf(sfSortKey1) - 1);     // Pad with ' ' for indexing

    // Sort Key for Index 1
    sfSortKey2 := LJVar(StockCode + StockIdStr + LineNoStr + Priority + BinCode, SizeOf(sfSortKey2) - 1);     // Pad with ' ' for indexing

    // Saved record positions for Bin Record and Stock Record
    If SaveBinPos Then
    Begin
      sfSavePositions[1].SaveRecordPosition (MLocF, GetPosKey);

      // If pointing at a Bin Usage record then must try to find the Bin Header record
      // and overwrite the record position - however it may not exists
      If MLocCtrl^.brBinRec.brSold Then
      Begin
        // Bugger - Bin Usage record
        BinSavePos := TBtrieveSavePosition.Create;
        Try
          BinSavePos.SaveFilePosition (MLocF, GetPosKey);

          // Use the Stock Folio + Sold index as this is liable to give best performance
          // as we will only be loading the details of stuff in stock for the location
          // and ignoring all the sold details which are liable to be humongous

          StkFolio := MLocCtrl^.brBinRec.brStkFolio;
          KeyS := brRecCode + MSernSub + FullNomKey(MLocCtrl^.brBinRec.brStkFolio) + Full_MLocKey(MLocCtrl^.brBinRec.brInMLoc) + #0;
          lStatus := Find_Rec (B_GetGEq, F[MLocF], MLocF, RecPtr[MLocF]^, MLSecK, KeyS);
          While (lStatus = 0) And
                (MLocCtrl^.brBinRec.brStkFolio = StkFolio) And
                (MLocCtrl^.brBinRec.brInMLoc = LocCode) And
                (MLocCtrl^.brBinRec.brSold = False) Do
          Begin
            If (Trim(MLocCtrl^.brBinRec.brBinCode1) = Trim(BinCode)) Then
            Begin
              // Match - save position and exit loop
              sfSavePositions[1].SaveRecordPosition (MLocF, GetPosKey);
              lStatus := -1;
            End; // If (Trim(MLocCtrl^.brBinRec.brBinCode1) = Trim(BinCode))

            If (lStatus = 0) Then
            Begin
              lStatus := Find_Rec (B_GetNext, F[MLocF], MLocF, RecPtr[MLocF]^, MLSecK, KeyS);
            End; // If (lStatus = 0)
          End; // While ...

          // Restore position in Bins Table in MLocF
          BinSavePos.RestoreSavedPosition (True);
        Finally
          BinSavePos.Free;
        End; // Try..Finally
      End; // If MLocCtrl^.brBinRec.brSold
    End; // If SaveBinPos

    If SaveStkPos Then sfSavePositions[2].SaveRecordPosition (StockF, GetPosKey);
    If SaveIdPos Then sfSavePositions[3].SaveRecordPosition (IDetailF, GetPosKey);

    // Save Stock Code and Bin Code within strings for easy access
    sfStrings [1] := TransLine.StockCode;
    sfStrings [2] := BinCode;
    sfStrings [3] := Priority;
    sfStrings [4] := LocCode;

    // HM 14/01/04: Added Transaction Line description into the file
    sfLongString := TransLine.Desc;

    // Number of items to be used from the bin and the remainder outstanding
    sfDoubles[1] := PickedQty;         // No of picked items
    sfDoubles[2] := UnpickedQty;       // No of outstanding items that can be fulfilled from the bin

    // Keep a track of how many lines have been consolidated
    sfBytes[1] := 1;

    // HM 14/01/04: Added StockId system for indexing the Additional Description Lines correctly
    sfIntegers[1] := StockId;
    sfIntegers[2] := 0;            // Line No

    // MH 02/04/2009: Extended to set KitLink so that the TLBOMSTK field works
    sfIntegers[3] := TransLine.KitLink;

    // Add the record into the scratch file
    Report_BError(ScratchFileF, Save);

    If FShowDescLines And (Not AddingTotal) Then
    Begin
      // Check to see whether lines are already loaded
      If (FFolioRef <> TransLine.FolioRef) Or (FABSLineNo <> TransLine.ABSLineNo) Then
      Begin
        // Load Additional Description Lines
        FFolioRef  := TransLine.FolioRef;
        FABSLineNo := TransLine.ABSLineNo;

        BuildDescCache (TransLine);
      End; // If ...

      // Add Additional Description Lines
      If (FDescLines.Count > 0) Then
      Begin
        For I := 0 To FDescLines.Count - 1 Do
        Begin
          // Extract the line from the cache and add it into the temp file as an additional desc line
          pId := pIDetail(FDescLines.Items[I]);
          AddDescLine (pId^, StockCode, BinCode, LocCode, Priority, StockIdStr, Format('%6.6d', [I+1]), I+1, StockId);
        End; // For I
      End; // If (FDescLines.Count > 0)
    End; // If FShowDescLines And (Not AddingTotal)
  End; // Else

  If (Not AddingTotal) Then
  Begin
    // Create a duplicate entry with a +1000 offset to use for tracking the used bins - otherwise
    // lines with duplicate stock codes will suggest the same bins every time - no need to store
    // links to other tables though
    AddBinInfo (TransLine, BinCode, LocCode, Priority, PickedQty, UnpickedQty, False, False, False, True);
  End; // If (Not AddingTotal)
End; // AddBinInfo

//-------------------------------------------------------------------------

Procedure TBinList.AddDescLine (Const TransLine                                                    : IDetail;
                                Const StockCode, BinCode, LocCode, Priority, StockIdStr, LineNoStr : ShortString;
                                Const LineNo, StockId                                              : LongInt);
Begin // AddDescLine
  // Add a new element with the details
  InitForAdd;

  // Sort Key for Index 0
  sfSortKey1 := LJVar(LocCode + BinCode + StockCode + StockIdStr + LineNoStr, SizeOf(sfSortKey1) - 1);     // Pad with ' ' for indexing

  // Sort Key for Index 1
  sfSortKey2 := LJVar(StockCode + StockIdStr + LineNoStr + Priority + BinCode, SizeOf(sfSortKey2) - 1);     // Pad with ' ' for indexing

  // Save Stock Code and Bin Code within strings for easy access
  sfStrings [1] := StockCode;
  sfStrings [2] := BinCode;
  sfStrings [3] := Priority;
  sfStrings [4] := LocCode;

  // HM 14/01/04: Added Transaction Line description into the file
  sfLongString := TransLine.Desc;

  // HM 14/01/04: Added StockId system for indexing the Additional Description Lines correctly
  sfIntegers[1] := StockId;
  sfIntegers[2] := LineNo;

  // MH 02/04/2009: Extended to set KitLink so that the TLBOMSTK field works
  sfIntegers[3] := TransLine.KitLink;

  // Add the record into the scratch file
  Report_BError(ScratchFileF, Save);
End; // AddDescLine

//-------------------------------------------------------------------------

// Looks up the current Bin in the usage totals (sfProcessId + 1000) and
// adjusts the Bins availability figures accordingly
Procedure TBinList.CheckBinUsage (StockCode, BinCode, LocCode : ShortString);
Var
  KeyS    : Str255;
  lStatus : SmallInt;
Begin // CheckBinUsage
  // Build a formatted index string for the Bin + Stock Code Combo
  BinCode   := UpcaseStr(LJVar(BinCode,BinLocLen));
  StockCode := FullStockCode(StockCode);
  LocCode   := Full_MLocKey(LocCode);

  KeyS := FullNomKey(sfProcessId + 1000) + LJVar(LocCode + BinCode + StockCode, SizeOf(sfSortKey1) - 1);
  lStatus := Find_Rec(B_GetEq, F[ScratchFileF], ScratchFileF, RecPtr[ScratchFileF]^, 0, KeyS);
  If (lStatus = 0) Then
  Begin
    // Already exists - adjust the global Bin record accordingly
    MLocCtrl^.brBinRec.brQtyUsed := MLocCtrl^.brBinRec.brQtyUsed + sfDoubles[2];
  End; // If Result
End; // CheckBinUsage

//=========================================================================

//Auto Suggest / return from Bins during print of picking runs
//
// IdR is a copy of the line being processed for inclusion in the picking list
// InvR is the parent header for IdR
// QtyP is the quantity of stock we require to pick/ have picked
// Mode. 0 means we are listing all available bin codes up to the QtyP required which could satisfy this demand.
//       1 means we are searching for the bins that were actually used already for this line.
//
// Written by EL, mod'd by MH
Procedure Print_SuggestBin(Var   Idr     : IDetail;
                                 InvR    : InvRec;
                           Const QtyP    : Double;
                           Const Mode    : Byte;
                                 BinList : TBinList;
                           Const ShowAll : Boolean);
Const
  Fnum    =  MLocF;
  Keypath =  MLSecK;

Var
  Locked,
  UseRec,
  LoopCtrl,
  FoundOk :  Boolean;

  B_Func,
  B_Start,
  TmpStat,
  Keypath2:  Integer;

  LAddr,
  TmpRecAddr
          :  Longint;

  KeyS,
  KeyChk  :  Str255;

  QtyAvail,
  QtyB,
  BinCount:  Double;

  TMLoc   :  MLocRec;
Begin
  FoundOk:=BOff;  UseRec:=BOff;  Locked:=BOff;  LoopCtrl:=(InvR.Tagged=0); {Only use secondry loop if order has a tagged setting}

  KeyPath2:=GetPosKey;

  {* Preserve The global FPOS for MLoc, and the MLocCtrl^ record *}

  TMLoc:=MLocCtrl^;

  TmpStat:=Presrv_BTPos(Fnum,KeyPath2,F[Fnum],TmpRecAddr,BOff,BOff);

  Try
    If (QtyP<>0) and (Is_FullStkCode(IdR.StockCode)) then
    Begin
      // Get Stock record
      If (Stock.StockCode<>IdR.StockCode) Then
        GetStock(Application.MainForm, Id.StockCode, Id.StockCode, -1);

      If (Stock.MultiBinMode) and (Stock.StockType in StkProdSet) then
      Begin

        If (Syss.FiltSNoBinLoc) then {* If we are forcing filtering by location, we can narrow the search *}
        Begin
          KeyChk:=FullQDKey(brRecCode,MSernSub,FullNomKey(Stock.StockFolio)+Full_MLocKey(IdR.MLocStk)+Chr(Mode));
        end
        else
          KeyChk:=FullQDKey(brRecCode,MSernSub,FullNomKey(Stock.StockFolio));

        // HM 17/09/03: Moved BinCount outside Repeat loop on EL's instruction
        BinCount:=QtyP;

        Repeat {Mode 0 only. Additional loop for tag match}
          KeyS:=KeyChk;

          Case Mode of
            0  :  Begin {* We are suggesting from unsold bin records which match *}
                    B_Start:=B_GetGEq;
                    B_Func:=B_GetNext;
                  end;
            1  :  Begin {* We are searching for the bin records already used *}
                    B_Start:=B_GetLessEq;
                    B_Func:=B_GetPrev;
                    KeyS:=KeyS+NdxWeight;
                  end;
          end; {Case..}

          // HM 17/09/03: Moved BinCount outside Repeat loop on EL's instruction
          {BinCount:=QtyP;}  QtyB:=0.0; QtyAvail:=0.0;

          Status:=Find_Rec(B_Start,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

          While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
          With MLocCtrl^.brBinRec do
          Begin
            Application.ProcessMessages;

            Case Mode of {Auto use by priority index with additional hold flag filtering }
              0  :  Begin

                      // HM 04/09/03: Change on EL instruction as no check was being made for held bins
                      //UseRec:=((Not brSold) and (Not brBatchChild));
                      // HM 24/09/03: Modified for changed mode meanings
                      //UseRec:=((Not brSold) and (Not brBatchChild) and (brHoldFlg<>1));
                      UseRec:=((Not brSold) and (Not brBatchChild) and (Not (brHoldFlg In [1,2])));

                      If (UseRec) and (Not LoopCtrl) then {Check for a match by tag number}
                      Begin
                        // HM 24/09/03: Modified for changed mode meanings
                        //UseRec:=((brHoldFlg=2) and (brTagNo=InvR.Tagged));
                        UseRec:=((brHoldFlg=3) and (brTagNo=InvR.Tagged));
                      end;

                      If UseRec Then
                      Begin
                        If (Not ShowAll) Then
                        Begin
                          // Check the Bin Information against the Bin Usage Totals being stored within
                          // the TempFile to see if the bin is still available
                          BinList.CheckBinUsage (Id.StockCode, brBinCode1, brInMLoc);
                        End; // If (Not ShowAll)

                        QtyB:=BinCount; {* How much remains to satisfy of the original QtyP *}

                        QtyAvail:=(brBuyQty-brQtyUsed); {* How much of this Bin is avaiable for use *}

                        If (QtyB>QtyAvail) then {* If there is not enough in this bin, use what is there *}
                          QtyB:=QtyAvail;

                        {* We can tell FD about this bin and the QtyB avaialble *}
                        If (QtyB > 0.0) Then
                        Begin
                          BinList.AddBinInfo (Id, brBinCode1, brInMLoc, brPriority,
                                              0.0, IIF(ShowAll, QtyP, QtyB),
                                              True, True, True, False);
                        End; // If (QtyB > 0.0)

                        If (Not ShowAll) Then
                          // HM 24/01/05: Added additional rounding due to problems in Exchequer code which this is based on
                          // Reduce Bincount by amount suggested as a control total as we need to stop once we have found enough
                          //BinCount:=BinCount-Round_Up(QtyB,Syss.NoQtyDec);
                          BinCount:=Round_Up(BinCount-Round_Up(QtyB,Syss.NoQtyDec),Syss.NoQtyDec);
                      end;
                    end;

              1  :  Begin

                      With {InvR,}IdR do
                        UseRec:=(brSold) and (brBatchChild) and
                        ((CheckKey(DocPRef,brOutOrdDoc,Length(DocPRef),BOff)) and (brOutOrdLine=ABSLineNo)
                        and (IdDocHed In OrderSet+[WOR])) or
                        ((CheckKey(DocPRef,brOutDoc,Length(DocPRef),BOff)) and (brSoldLine=ABSLineNo));


                      If (UseRec) then
                      Begin
                        QtyB:=brQtyUsed;

                        {* We can tell FD about this bin and the QtyB used by this bin for this line *}
                        BinList.AddBinInfo (Id, brBinCode1, brInMLoc, brPriority,
                                            QtyB, 0.0,
                                            True, True, True, False);

                        // HM 24/01/05: Added additional rounding due to problems in Exchequer code which this is based on
                        //BinCount:=BinCount-Round_Up(QtyB,Syss.NoQtyDec);
                        BinCount:=Round_Up(BinCount-Round_Up(QtyB,Syss.NoQtyDec),Syss.NoQtyDec);
                      end;

                    end;

            end; {Case..}

            // HM 24/01/05: Added additional rounding due to problems in Exchequer code which this is based on
            //FoundOk:=(BinCount<=0);
            FoundOk:=(Round_Up(BinCount,Syss.NoQtyDec)<=0.0);  {*v5.61 possible rounding failure here causing loop overload *}

            If (Not FoundOk) then
              Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

          end; {While loop..}

          LoopCtrl:=Not LoopCtrl;  {Go round again if no tag match,and one is required}

        Until (Mode<>0) or (FoundOk) or (Not LoopCtrl);

      end; {If Stock not multi bin type..}
    end; {If Qty <>0 ..}
  Finally
    TmpStat:=Presrv_BTPos(Fnum,KeyPath2,F[Fnum],TmpRecAddr,BOn,BOff);

    MLocCtrl^:=TMLoc;

  end; {Try.}
end; {Proc..}

//-------------------------------------------------------------------------

// Builds a Single Picking List including Multi-Bin information from the
// specified transaction
Procedure BuildSinglePickListWithBins (Const ShowAllStock, ShowDescLines, ShowHiddenBoM : Boolean);
Var
  IdSavePos, StkSavePos : TBtrieveSavePosition;
  IdSaveRec             : IDetail;
  BinList               : TBinList;
  lStatus               : SmallInt;
  KeyS                  : Str255;
Begin { BuildSinglePickListWithBins }
  // Save position in Details.Dat
  IdSavePos := TBtrieveSavePosition.Create;
  Try
    IdSavePos.SaveFilePosition (IDetailF, GetPosKey);
    IdSaveRec := Id;

    // Save position in Stock.Dat
    StkSavePos := TBtrieveSavePosition.Create;
    Try
      StkSavePos.SaveFilePosition (StockF, GetPosKey);

      // Create BinList to store & manage the Bin/Stock information
      BinList := TBinList.Create(1010, ShowDescLines);
      Try
        // Find first line in invoice
        KeyS := FullNomKey (Inv.FolioNum);

        // MH 16/03/2009: Added support for printing Hidden BoM lines
        If ShowHiddenBoM Then
          KeyS := KeyS + FullNomKey(-1);

        lStatus := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, KeyS);
        While (lStatus = 0) And (Id.FolioRef = Inv.FolioNum) Do
        Begin
          // Check to see if Stock Code is set - not interested in desc only or non stock on a picking list
          If Is_FullStkCode (Id.StockCode) Then
          Begin
            // Get Stock record
            GetStock(Application.MainForm, Id.StockCode, Id.StockCode, -1);

            // Calculate the KitLink expected for the description lines, normally this will be the
            // Stock Folio, but for exploded BOM's this will be the Stock Folio from the original
            // BOM Component which is stored in the KitLink field for all the BOM sub-items
            If (Id.KitLink = 0) Then
            Begin
              BinList.DescKitLink := Stock.StockFolio;
            End // If (Id.KitLink = 0)
            Else
            Begin
              // Exploded Bill Of Materials
              BinList.DescKitLink := Id.KitLink;
            End; // Else

            // Check Stock to see if Bins are used
            If (Stock.StockType In StkProdSet) And Stock.MultiBinMode Then
            Begin
              // BIN Stock

              // Show existing picked bins
              If (Id.QtyPick <> 0) And (Id.QtyPick <= Id.BinQty) Then
              Begin
                Print_SuggestBin(Id, Inv, Id.QtyPick, 1, BinList, False);
              End; // If (Id.QtyPick <> 0) And (Id.QtyPick <= Id.BinQty)

              // Suggest for outstanding items
              If ((Qty_OS(Id) - Id.QtyPick) > 0.0) Then
              Begin
                Print_SuggestBin(Id, Inv, Qty_OS(Id) - Id.QtyPick, 0, BinList, ShowAllStock);
              End; // If ((Qty_OS(Id) - Id.QtyPick) > 0.0)
            End // If (Stock.StockType In StkProdSet) And Stock.MultiBinMode
            Else Begin
              // Non-BIN Stock - report any picked or outstanding items

              If (Qty_OS(Id) > 0.0) Then
              Begin
                BinList.AddBinInfo (Id, '', '', '',
                                    Id.QtyPick, Round_Up(Qty_OS(Id) - Id.QtyPick,Syss.NoQtyDec),
                                    True, False, True, False);
              End; // If (Qty_OS(Id) > 0.0) Then
            End; // Else
          End; // If Is_FullStkCode (Id.StockCode)

          // get next record
          lStatus := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, KeyS);
        End; // While (lStatus = 0) And (Id.FolioRef = Inv.FolioNum)
      Finally
        FreeAndNIL(BinList);
      End; // Try..Finally

      // Restore position in Stock file
      StkSavePos.RestoreSavedPosition;
    Finally
      StkSavePos.Free;
    End; // Try..Finally

    // Restore position in Transaction Lines file
    IdSavePos.RestoreSavedPosition;
    Id := IdSaveRec;
  Finally
    IdSavePos.Free;
  End; // Try..Finally
End; { BuildSinglePickListWithBins }

//-------------------------------------------------------------------------

// Runs through the Scratch File passed in from Exchequer containing the Transaction
// Lines to be included within the Consolidated Picking List and builds a second scratch
// file for the print job including the Multi-Bin information
Procedure BuildConsolPickListWithBins (Const oScratch     : ScratchPtr;    // Scratch file of ID lines to be included
                                       Const ShowAllStock : Boolean);
Var
  IdSavePos, StkSavePos   : TBtrieveSavePosition;
  IdSaveRec               : IDetail;
  RecAddr                 : LongInt;
  lStatus                 : SmallInt;
  KeyS                    : Str255;
  BinList                 : TBinList;
Begin { BuildConsolPickListWithBins }
  // Save position in Details.Dat
  IdSavePos := TBtrieveSavePosition.Create;
  Try
    IdSavePos.SaveFilePosition (IDetailF, GetPosKey);
    IdSaveRec := Id;

    // Save position in Stock.Dat
    StkSavePos := TBtrieveSavePosition.Create;
    Try
      StkSavePos.SaveFilePosition (StockF, GetPosKey);

      ResetRec (StockF);

      // Create BinList to store & manage the Bin/Stock information
      BinList := TBinList.Create(1011, False);
      Try
        // Find the first entry from the Exchequer Consolidated Picking List in the file
        KeyS := FullNomKey (1);
        lStatus := Find_Rec(B_GetGEq, F[ReportF], ReportF, RecPtr[ReportF]^, RPK, KeyS);
        While (lStatus = 0) And (RepScr^.RepFolio = 1) Do
        Begin
          // Filter out non-database link lines as they crash Get_Scratch
          If (RepScr^.RecAddr <> 0) Then
          Begin
            // Link to Transaction Line
            oScratch.Get_Scratch(RepScr^);

            // Check for a changed Stock Code
            If (Stock.StockCode <> Id.StockCode) Then
            Begin
              // Get Stock record
              GetStock(Application.MainForm, Id.StockCode, Id.StockCode, -1);
            End; // If (Stock.StockCode <> Id.StockCode)

            // Check Stock to see if Bins are used
            If (Stock.StockType In StkProdSet) And Stock.MultiBinMode Then
            Begin
              // BIN Stock

              // Show existing picked bins
              If (Id.QtyPick <> 0) And (Id.QtyPick <= Id.BinQty) Then
              Begin
                Print_SuggestBin(Id, Inv, Id.QtyPick, 1, BinList, False);
              End; // If (Id.QtyPick <> 0) And (Id.QtyPick <= Id.BinQty)

              // Suggest for outstanding items
              If ((Qty_OS(Id) - Id.QtyPick) > 0.0) Then
              Begin
                Print_SuggestBin(Id, Inv, Qty_OS(Id) - Id.QtyPick, 0, BinList, ShowAllStock);
              End; // If ((Qty_OS(Id) - Id.QtyPick) > 0.0)
            End // If (Stock.StockType In StkProdSet) And Stock.MultiBinMode
            Else Begin
              // Non-BIN Stock - report any picked or outstanding items

              If (Qty_OS(Id) > 0.0) Then
              Begin
                BinList.AddBinInfo (Id, '', '', '',
                                    Id.QtyPick, Round_Up(Qty_OS(Id) - Id.QtyPick,Syss.NoQtyDec),
                                    True, False, True, False);
              End; // If (Qty_OS(Id) > 0.0) Then
            End; // Else
          End; // If (RepScr^.RecAddr <> 0)

          // Get the next entry from the Exchequer Consolidated Picking List in the file
          lStatus := Find_Rec(B_GetNext, F[ReportF], ReportF, RecPtr[ReportF]^, RPK, KeyS);
        End; // While (lStatus = 0) And (RepScr^.RepFolio = 1)
      Finally
        FreeAndNIL(BinList);
      End; // Try..Finally

      // Restore position in Stock file
      StkSavePos.RestoreSavedPosition;
    Finally
      StkSavePos.Free;
    End; // Try..Finally

    // Restore position in Transaction Lines file
    IdSavePos.RestoreSavedPosition;
    Id := IdSaveRec;
  Finally
    IdSavePos.Free;
  End; // Try..Finally
End; { BuildConsolPickListWithBins }

//-------------------------------------------------------------------------

end.
