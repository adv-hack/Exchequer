unit oLines;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarCnst3, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     oLine, MiscFunc, oBtrieve, ExBtTH1U, GlobList;

type
  EnumLinesProc = Procedure (Const oTL : TTransactionLine; Const iTL : ITransactionLine; Ptr : Pointer; Mode : LongInt) Of Object;

  //TTransactionLines = class(TAutoIntfObject, ITransactionLines)
  TTransactionLines = class(TBtrieveFunctions, ITransactionLines)
  private
    // Interface Type - imGeneral, imAdd, imUpdate, imClone
    FIntfType    : TInterfaceMode;

    // Parent Transaction Object (as TObject to avoid circular references)
    FTransaction : TObject;

    // Main Toolkit Object (as TObject to avoid circular references)
    FToolkit     : TObject;

    // List of Transaction Lines for current transaction
    FLines       : TList;
    FIdControl   : TBits;

    // Transaction Folio Number of loaded lines
    FLoadedFolio : LongInt;
    FJAPLineNo : longint; //line number for JAP deduction & retention lines
    FAccRec : CustRec;
  protected
    // ITransactionLines
    function  Get_thLineCount: Integer; safecall;
    function  Get_thLine(Index: Integer): ITransactionLine; safecall;
    function  Add: ITransactionLine; safecall;
    procedure Delete(Index: Integer); safecall;

    Procedure InitObjects;
    Procedure KillLines;
  public
    Constructor Create(Const IType       : TInterfaceMode;
                       Const Toolkit     : TObject;
                       Const ParentTrans : TObject;
                       Const BtrIntf     : TCtkTdPostExLocalPtr);
    Destructor Destroy; override;

    Procedure AddNewLine (Const TL : TTransactionLine);
    Procedure CheckForLines(WhichLines : SmallInt = 0);
    Procedure EnumLines (Enum : EnumLinesProc; Ptr : Pointer; Mode : LongInt);
    Procedure Transform (Const IType : TInterfaceMode);

    Property Lines : TList Read FLines;
    Property LoadedFolio : LongInt Read FLoadedFolio Write FLoadedFolio;
    property AccRec : CustRec read FAccRec write FAccRec;
  End; { TTransactionLines }


implementation

uses ComServ, BtrvU2, BTKeys1U, oTrans, DLLTH_Up, LogFile;

Type
  TTransLineType = Record
    IdNo : SmallInt;
    TLO  : TTransactionLine;
    TLI  : ITransactionLine2;
  End;
  pTransLineType = ^TTransLineType;

{-------------------------------------------------------------------------------------------------}

Constructor TTransactionLines.Create(Const IType       : TInterfaceMode;
                                     Const Toolkit     : TObject;
                                     Const ParentTrans : TObject;
                                     Const BtrIntf     : TCtkTdPostExLocalPtr);
Begin { Create }
  //Inherited Create (ComServer.TypeLib, ITransactionLines);
  Inherited Create (ComServer.TypeLib, ITransactionLines, BtrIntf);

//  LogF.AddLogMessage ('ITransactionLines', 'Create');

  // Initialise Btrieve Ancestor
  FFileNo := IDetailF;

  // Init Local Objects
  InitObjects;
  FLines := TList.Create;
  FIdControl := TBits.Create;

  // Init Local variables
  FIntfType := IType;
  FTransaction := ParentTrans;
  FLoadedFolio := -1919191919;

  FToolkit := Toolkit;
End; { Create }

{-----------------------------------------}

Destructor TTransactionLines.Destroy;
Begin { Destroy }
  { Remove any loaded lines }
  KillLines;

  { Destroy sub-objects }
  FreeAndNil(FIdControl);
  FreeAndNil(FLines);
  InitObjects;

  inherited Destroy;

//  LogF.AddLogMessage ('ITransactionLines', 'Destroy');
End; { Destroy }

{-----------------------------------------}

Procedure TTransactionLines.InitObjects;
Begin { InitObjects }
  // Reference to parent TTransaction object (as TObject to avoid circular references) }
  FTransaction := Nil;

  // Reference to main Toolkit object
  FToolkit := Nil;
End; { InitObjects }

{-----------------------------------------}

// Empties the Transaction Line List
Procedure TTransactionLines.KillLines;
Var
  TmpLine : pTransLineType;
Begin { KillLines }
//  LogF.AddLogMessage ('ITransactionLines', 'KillLines (Start)');

  While (FLines.Count > 0) Do Begin
    // remove object references
    TmpLine := FLines.Items[0];
    TmpLine.TLO := Nil;
    TmpLine.TLI := Nil;
    Dispose(TmpLine);

    // Destroy List Entry
    FLines.Delete(0);
  End; { While (FLines.Count > 0) }

  // Shrink TBits to reset all flags back to false
  FIdControl.Size := 1;

//  LogF.AddLogMessage ('ITransactionLines', 'KillLines (Finish)');
End; { KillLines }

{-----------------------------------------}

// Checks to see if the transaction lines need to be loaded, either because
// we haven't loaded them, or because the transaction has changed
Procedure TTransactionLines.CheckForLines(WhichLines : SmallInt = 0);
Var
  SaveInfo                   : TBtrieveFileSavePos;
  lIdetail                   : IDetail;
  //TmpRecAddr                 : LongInt;
  {TmpStat, TmpKPath,} lStatus : Integer;
  TKLine                     : TBatchTLRec;
  oLine                      : pTransLineType;
  KeyS                       : Str255;
  RecPos                     : LongInt;

  function WantThisLine : Boolean;
  begin
    Result := ((FTransaction As TTransaction).TH.FolioNum = FBtrIntf^.LId.FolioRef);

    if (WhichLines < 0) then
      Result := Result and (FBtrIntf.LId.LineNo = WhichLines);
  end;

Begin { CheckForLines }
//  LogF.AddLogMessage ('ITransactionLines', 'CheckForLines (Start)');

  // Check to see if lines have been loaded for current transaction
  FJAPLineNo := WhichLines;
  With FBtrIntf^, FTransaction As TTransaction Do
    If (TH.FolioNum <> FLoadedFolio) Then Begin
      // Lines not loaded - remove and pre-existing lines
      KillLines;

      If (FIntfType <> imAdd) And (TH.FolioNum <> 0) Then Begin
        // Save current position in IDetail
        SaveExLocalPos (SaveInfo);

        // Build Folio Key and find first line
        if WhichLines = 0 then
          KeyS    := FullNomKey (TH.FolioNum)
        else
          KeyS := FullIdKey(TH.FolioNum, WhichLines);


        lStatus := LFind_Rec (B_GetGEq, IDetailF, IdFolioK, KeyS);
//        While (lStatus = 0) And (TH.FolioNum = LId.FolioRef) Do Begin
        While (lStatus = 0) And WantThisLine Do Begin
          // Convert Line to a Toolkit TBatchTLRec
          CopyEntIdToTKId (lID, TKLine);

          // Get Record Position
          LGetPos(IDetailF, RecPos);

          // Create and initialise a Transaction Line object
          New (oLine);
          With oLine^ Do Begin
            // Allocate unique Id number
            IdNo := FIdControl.OpenBit;
            FIdControl.Bits[IdNo] := True;

            // Create lines object
            TLO  := TTransactionLine.Create(IdNo, FIntfType, FToolkit, FTransaction, Self, FBtrIntf, TKLine, True, RecPos);
            TLO.LineDetail := lID;
            TLI  := oLine.TLO;
          End; { With oLine }

          // Add into Lines List
          FLines.Add(oLine);

          // get next line
          lStatus := LFind_Rec (B_GetNext, IDetailF, IdFolioK, KeyS);
        End; { While (lStatus = 0) And (TH.FolioNum = lId.FolioNum) }

        // Restore previous position in IDetail
        RestoreExLocalPos (SaveInfo);
      End; { If (FIntfType <> imAdd) And (TH.FolioNum <> 0) }

      FLoadedFolio := TH.FolioNum;
    End; { If (TH.FolioNum <> LoadedFolio) }

//  LogF.AddLogMessage ('ITransactionLines', 'CheckForLines (Finish)');
End; { CheckForLines }

{-----------------------------------------}

function TTransactionLines.Get_thLineCount: Integer;
begin
  If Assigned(FLines) Then
    Result := FLines.Count
  Else
    Result := 0;
end;

{-----------------------------------------}

function TTransactionLines.Get_thLine(Index: Integer): ITransactionLine;
Var
  oLine : pTransLineType;
begin
  // Check its a valid line number
  If (Index >= 1) And (Index <= FLines.Count) Then Begin
    // Extract interface from list
    oLine := FLines.Items[Index - 1];
    Result := oLine.TLI;
  End { If (Index >= 1) And (Index <= FLines.Count) }
  Else
    Raise EInvalidMethod.Create('Invalid Transaction Line Number (' + IntToStr(Index) + ')');
end;

{-----------------------------------------}

Procedure TTransactionLines.EnumLines (Enum : EnumLinesProc; Ptr : Pointer; Mode : LongInt);
Var
  TmpLine : pTransLineType;
  I       : SmallInt;
begin
  If (FLines.Count > 0) Then
    For I := 0 To Pred(FLines.Count) Do Begin
      TmpLine := FLines.Items[I];

      Enum(TmpLine.TLO, TmpLine.TLI, Ptr, Mode);
    End; { For I }
end;

{-----------------------------------------}

// Returns new Transaction Line object for adding a new line
Function TTransactionLines.Add: ITransactionLine;
Var
  TmpLine    : pTransLineType;
  oTransLine : TTransactionLine;
  NewTL      : TBatchTLRec;
  IdNo       : LongInt;
begin { Add }
  // Initialise dummy TL Record
  FillChar (NewTL, SizeOf(NewTL), #0);   // Defaults set in TTransactionLine.InitNewLine;

  // Calculate next available line number
  If (FLines.Count > 0) Then
    For IdNo := 0 To Pred(FLines.Count) Do Begin
      // Extract references to Transaction Line
      TmpLine := FLines.Items[IdNo];

      // Check Line Number }
      If (TmpLine.TLI.tlLineNo > NewTL.LineNo) Then
        NewTL.LineNo := TmpLine.TLI.tlLineNo;
    End; { For I}
  //PR 20/01/03 BOM Line of WOR needs to  be line no 1
  if (TTransaction(FTransaction).TH.TransDocHed  = 'WOR') and (NewTL.LineNo = 0) then
    NewTL.LineNo := 1
  else
    Inc(NewTL.LineNo, 2);  // Must leave a space otherwise Enterprise Insert routine has problems

  if FJAPLineNo < 0 then
    NewTL.LineNo := FJAPLineNo;

  // Allocate unique Id number
  IdNo := FIdControl.OpenBit;
  FIdControl.Bits[IdNo] := True;

  // Create new Transaction Line object
  if IsApplication(TTransaction(FTransaction).TH.TransDocHed) then
    oTransLine := TTransactionLine2.Create(IdNo, imAdd, FToolkit, FTransaction, Self, FBtrIntf, NewTL, False, 0)
  else
    oTransLine := TTransactionLine.Create(IdNo, imAdd, FToolkit, FTransaction, Self, FBtrIntf, NewTL, False, 0);

  oTransLine.InitNewLine;

  Result := oTransLine;
End; { Add }

// Called by the Transaction Line created in .Add to add itself into the list
Procedure TTransactionLines.AddNewLine (Const TL : TTransactionLine);
Var
  oLine : pTransLineType;
Begin { AddNewLine }
  // Create and initialise a list object
  New (oLine);
  With oLine^ Do Begin
    // Allocate unique Id number
    IdNo := TL.IdNo;
    TLO  := TL;
    TLI  := TL;
  End; { With oLine }

  // Add into Lines List
  FLines.Add(oLine);

  // Transform Line from 'Add' mode to standard mode
  TL.Transform(FIntFType);
End; { AddNewLine }

{-----------------------------------------}

// Delete method on Transaction Lines object
Procedure TTransactionLines.Delete(Index: Integer);
Var
  TmpLine : pTransLineType;
Begin { Delete}
  // Check interface type - can only delete when Adding/Updating Transactions
  If (FIntfType In [imAdd, imCopy, imUpdate, imUpdateEx2]) Then Begin
    // Check Line Index is valid
    If (Index >= 1) And (Index <= FLines.Count) Then Begin
      // remove object references
      TmpLine := FLines.Items[Pred(Index)];

      if TmpLine^.TLO.OkToUpdate(True) then
      begin
        With TmpLine^ Do Begin
          TLO := Nil;
          TLI := Nil;
        End; { With TmpLine }
        Dispose(TmpLine);

        // Destroy List Entry
        FLines.Delete(Pred(Index));
      end
      else
        raise EInvalidMethod.Create('This line cannot be deleted');
    End { If (Index >= 1) And (Index <= (FLines.Count)) }
    Else
      Raise EInvalidMethod.Create ('ITransactionLines.Delete - Invalid Transaction Line number specified (' + IntToStr(Index) + ')');
  End { If (FIntfType In [imAdd, imUpdate]) }
  Else
    Raise EInvalidMethod.Create ('The ITransactionLines.Delete method is not available');
End; { Delete }

{-----------------------------------------}

Procedure TTransactionLines.Transform (Const IType : TInterfaceMode);
Var
  TmpLine : pTransLineType;
  I       : SmallInt;
Begin { SetInterfaceType }
  // Change mode of Lines container object
  FIntfType := IType;

  // change mode of lines
  If (FLines.Count > 0) Then
    For I := 0 To Pred(FLines.Count) Do Begin
      TmpLine := FLines.Items[I];
      TmpLine.TLO.Transform (IType);
    End; { For I }
End; { SetInterfaceType }

{-----------------------------------------}

end.
