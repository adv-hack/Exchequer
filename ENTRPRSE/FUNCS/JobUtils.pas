unit JobUtils;
{
  General-purpose functions for Job records

  -- CJS 2013-09-12
}

interface

uses BtrvU2, VarRec2U, GlobVar, VarConst, SavePos, BtKeys1U;

{
  Reads (into CCDept) the Cost Centre / Department array for the specified
  Job. Returns False if a matching Job record cannot be found. Does not change
  the current record position in the Job table.

  The CCDept array will be cleared if a record cannot be found.
}
function GetJobCCDept(const forJobCode: string; var CCDept: CCDepType): Boolean;

implementation

function GetJobCCDept(const forJobCode: string; var CCDept: CCDepType): Boolean;
var
  FuncRes: LongInt;
  Key: Str255;
begin
  Result := True;
  FillChar(CCDept, SizeOf(CCDept), 0);

  // If Job Costing is not active, do nothing apart from clear the array
  if JBCostOn then
  begin
    with TBtrieveSavePosition.Create Do
    begin
      try
        // Save the current position in the file for the current key
        SaveFilePosition (JobF, GetPosKey);

        // Locate the Job record
        Key := BtKeys1U.FullJobCode(forJobCode);
        FuncRes := Find_Rec(B_GetEq, F[JobF], JobF, RecPtr[JobF]^, JobCodeK, Key);
        if FuncRes = 0 then
          // If found, retrieve the Cost Centre/Department array
          CCDept := JobRec.CCDep
        else
          Result := False;

        // Restore position in file
        RestoreSavedPosition;
      finally
        Free;
      end; // try...
    end; // with TBtrieveSavePosition...
  end; // if JBCostOn...
end;

end.

