unit DrillList;

interface

Uses Classes, Dialogs, SysUtils, Windows;

Type
  // Record stores the details of a single Drill-Down area
  TDrillDownArea = Record
    daX1      : LongInt; //Double;
    daY1      : LongInt; //Double;
    daX2      : LongInt; //Double;
    daY2      : LongInt; //Double;
    daLevelNo : Byte;
    daString1 : ShortString;
    daInt1    : SmallInt;
    daInt2    : SmallInt;
    daByte1   : Byte;
  End; { TDrillDownArea }


  // Class to manage the list of Drill-Down areas for the TFilePreview component
  TDrillDownAreaList = Class(TObject)
  Private
    FDrillArray : Array Of TDrillDownArea;
  Protected
  Public
    Constructor Create;
    Destructor Destroy; Override;

    procedure AddDrillDown (Const X1, Y1, X2, Y2 : Double;
                            Const LevelNo        : Byte;
                            Const DDS1           : ShortString;
                            Const DDI1, DDI2     : SmallInt;
                            Const DDB1           : Byte);

    procedure Clear;

    Function  GotDrillDown (Const X, Y      : LongInt;
                            Var   DrillDets : TDrillDownArea) : Boolean;
  End; { TDrillDownAreaList }

implementation

//=========================================================================

Constructor TDrillDownAreaList.Create;
Begin { Create }
  Inherited;

  // Initialise dynamic array used to store the Drill-Down Area details
  FDrillArray := NIL;
End; { Create }

//----------------------

Destructor TDrillDownAreaList.Destroy;
Begin { Destroy }
  Clear;
  FDrillArray := NIL;

  Inherited;
End; { Destroy }

//-------------------------------------------------------------------------

procedure TDrillDownAreaList.Clear;
Begin { Clear }
  // Remove any pre-existing elements
  SetLength(FDrillArray, 0);
End; { Clear }

//-------------------------------------------------------------------------

procedure TDrillDownAreaList.AddDrillDown (Const X1, Y1, X2, Y2 : Double;
                                           Const LevelNo        : Byte;
                                           Const DDS1           : ShortString;
                                           Const DDI1, DDI2     : SmallInt;
                                           Const DDB1           : Byte);
Begin { DrillDownArea }
  // Add a new element
  SetLength(FDrillArray, Length(FDrillArray) + 1);

  // Copy the parameters into the new element for reference by GotDrillDown
  With FDrillArray[High(FDrillArray)] Do Begin
    daX1      := Round(X1);
    daY1      := Round(Y1);
    daX2      := Round(X2);
    daY2      := Round(Y2);
    daLevelNo := LevelNo;
    daString1 := DDS1;
    daInt1    := DDI1;
    daInt2    := DDI2;
    daByte1   := DDB1;
  End; { With FDrillArray[High(FDrillArray)] }
End; { DrillDownArea }

//-------------------------------------------------------------------------

Function TDrillDownAreaList.GotDrillDown (Const X, Y      : LongInt;
                                          Var   DrillDets : TDrillDownArea) : Boolean;
Var
  I : SmallInt;
Begin { GotDrillDown }
  Result := False;
  FillChar (DrillDets, SizeOf(DrillDets), #0);

  // Check to see if any Drill-Down Areas have been specified
  If (Length(FDrillArray) > 0) Then Begin
    // run through the areas and determine which area
    For I := Low(FDrillArray) To High(FDrillArray) Do
      With FDrillArray[I] Do
        // Check whether the double-click co-ords are within the drill-down area
        If ((X >= daX1) And (X <= daX2)) And ((Y >= daY1) And (Y <= daY2)) Then
          // Got a matching area - check the level
          If (daLevelNo > DrillDets.daLevelNo) Then
            DrillDets := FDrillArray[I];

    // Return True if a Level was found
    Result := (DrillDets.daLevelNo > 0);
  End; { If (Length(FDrillArray) > 0) }
End; { GotDrillDown }

//=========================================================================

end.
