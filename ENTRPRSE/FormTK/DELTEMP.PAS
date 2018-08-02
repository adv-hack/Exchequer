// NOTE: Used by both the COM Toolkit and Forms Toolkit for keeping track
// of and deleting the temporary files created by the printing.
unit DelTemp;

interface

Uses Classes, SysUtils;

Procedure AddToDeleteList (Const FName : ShortString);
Procedure ClearDelList;

Var
  DeleteOnDestroy : Boolean;

implementation

Var
  DelList : TStringList;

//-----------------------------------------------------------------------------

Procedure AddToDeleteList (Const FName : ShortString);
Begin { AddToDeleteList }
  // Create list the first time through
  If (Not Assigned(DelList)) Then
    DelList := TStringList.Create;

  // Add file into cache if it exists
  If FileExists (FName) Then
    DelList.Add (FName);
End; { AddToDeleteList }

//-----------------------------------------------------------------------------

Procedure ClearDelList;
Var
  I : Integer;
Begin { ClearDelList }
  // run through any items in the cache and try to delete them if they still exist
  If (DelList.Count > 0) Then
    For I := 0 To Pred(DelList.Count) Do
      If FileExists(DelList[I]) Then
        SysUtils.DeleteFile(DelList[I]);
End; { ClearDelList }

//-----------------------------------------------------------------------------

Initialization
  DeleteOnDestroy := True;
  DelList := NIL;
Finalization
  If Assigned(DelList) Then Begin
    If DeleteOnDestroy Then
      ClearDelList;

    FreeAndNIL(DelList);
  End; { If Assigned(DelList) }
end.
