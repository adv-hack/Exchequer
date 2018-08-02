unit oReportDetail;

interface

Uses Classes, SysUtils, RWRIntF;

Type
  TReportDetails = Class(TInterfacedObject, IReportDetails)
  Private
    FReportHed : ReportHedType;
    FHeadingLines : TList;
    FInputLines : TList;
    FReportLines : TList;

    // IReportDetails methods
    Function GetReportHeader : ReportHedType;
    Function GetHeadingLineCount : SmallInt;
    Function GetHeadingLines (Index: SmallInt) : ReportDetailType;
    Function GetInputLineCount : SmallInt;
    Function GetInputLines (Index: SmallInt) : ReportDetailType;
    Function GetReportLineCount : SmallInt;
    Function GetReportLines (Index: SmallInt) : ReportDetailType;
  Public
    Constructor Create (Const ReportHed : ReportHedType);
    Destructor Destroy; Override;

    Procedure AddReportLine (Const RepLine : ReportDetailType);
  End; // TReportDetails

implementation

Type
  pReportDetailType = ^ReportDetailType;

//-------------------------------------------------------------------------

Constructor TReportDetails.Create (Const ReportHed : ReportHedType);
Begin // Create
  Inherited Create;

  FHeadingLines := TList.Create;
  FInputLines := TList.Create;
  FReportLines := TList.Create;

  FReportHed := ReportHed;
End; // Create

//------------------------------

Destructor TReportDetails.Destroy;

  Procedure ClearAndNILList (Var TheList : TList);
  Var
    oRepline : pReportDetailType;
  Begin // ClearAndNILList
    While Assigned(TheList) And (TheList.Count > 0) Do
    Begin
      oRepLine := pReportDetailType(TheList[0]);
      Dispose(oRepLine);

      TheList.Delete(0);
    End; // While Assigned(TheList) And (TheList.Count > 0)

    FreeAndNIL(TheList);
  End; // ClearAndNILList

Begin // Destroy
  ClearAndNILList (FHeadingLines);
  ClearAndNILList (FInputLines);
  ClearAndNILList (FReportLines);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TReportDetails.AddReportLine (Const RepLine : ReportDetailType);
Var
  oRepline : pReportDetailType;
Begin // AddReportLine
  New(oRepLine);
  oRepLine^ := RepLine;

  Case oRepLine^.VarType Of
    'H' : FHeadingLines.Add (oRepLine);
    'I' : FInputLines.Add (oRepLine);
    'R' : FReportLines.Add (oRepLine);
  End; // Case oRepLine^.VarType Of
End; // AddReportLine

//-------------------------------------------------------------------------

Function TReportDetails.GetReportHeader : ReportHedType;
Begin // GetReportHeader
  Result := FReportHed;
End; // GetReportHeader

//------------------------------

Function TReportDetails.GetHeadingLineCount : SmallInt;
Begin // GetHeadingLineCount
  Result := FHeadingLines.Count;
End; // GetHeadingLineCount

Function TReportDetails.GetHeadingLines (Index: SmallInt) : ReportDetailType;
Begin // GetHeadingLines
  If (Index >= 0) And (Index < FHeadingLines.Count) Then
    Result := pReportDetailType(FHeadingLines[Index])^
  Else
    Raise Exception.Create ('TReportDetails.GetHeadingLines: Invalid HeadingLines Index (' + IntToStr(Index) + ')');
End; // GetHeadingLines

//------------------------------

Function TReportDetails.GetInputLineCount : SmallInt;
Begin // GetInputLineCount
  Result := FInputLines.Count;
End; // GetInputLineCount

Function TReportDetails.GetInputLines (Index: SmallInt) : ReportDetailType;
Begin // GetInputLines
  If (Index >= 0) And (Index < FInputLines.Count) Then
    Result := pReportDetailType(FInputLines[Index])^
  Else
    Raise Exception.Create ('TReportDetails.GetInputLines: Invalid InputLines Index (' + IntToStr(Index) + ')');
End; // GetInputLines

//------------------------------

Function TReportDetails.GetReportLineCount : SmallInt;
Begin // GetReportLineCount
  Result := FReportLines.Count;
End; // GetReportLineCount

Function TReportDetails.GetReportLines (Index: SmallInt) : ReportDetailType;
Begin // GetReportLines
  If (Index >= 0) And (Index < FReportLines.Count) Then
    Result := pReportDetailType(FReportLines[Index])^
  Else
    Raise Exception.Create ('TReportDetails.GetReportLines: Invalid ReportLines Index (' + IntToStr(Index) + ')');
End; // GetReportLines

//-------------------------------------------------------------------------


end.
