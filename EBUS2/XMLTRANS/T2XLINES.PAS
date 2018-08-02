unit t2xlines;

{ prutherford440 09:53 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ComObj, Enterprise03_TLB, Classes, t2xline, xmlTrans, Logfile;


type

  TTransLineType = Record
    IdNo : SmallInt;
    TLO  : TXmlTransactionLine;
    TLI  : IXmlTransactionLine;
  End;
  pTransLineType = ^TTransLineType;

  TXmlTransactionLines = class(TLogAutoIntf, IXmlTransactionLines)
  private
    // Parent Transaction Object (as TObject to avoid circular references)
    FTransaction : TObject;

    // List of Transaction Lines for current transaction
    FLines       : TList;
    FIdControl   : TBits;

    // Transaction Folio Number of loaded lines
    FLoadedFolio : LongInt;
  protected
    // ITransactionLines
    function  Get_thLineCount: Integer; safecall;
    function  Get_thLine(Index: Integer): IXmlTransactionLine; safecall;
    function  Add: IXmlTransactionLine; safecall;
    procedure Delete(Index: Integer); safecall;

    Procedure InitObjects;
    Procedure KillLines;
  public
    Constructor Create(Const ParentTrans : TObject);
    Destructor Destroy; override;

    Procedure AddNewLine (Const TL : TXmlTransactionLine);
    Property Lines : TList Read FLines;
    Property LoadedFolio : LongInt Read FLoadedFolio Write FLoadedFolio;
  End; { TXmlTransactionLines }


implementation

uses t2xml, ComServ, SysUtils;


{-------------------------------------------------------------------------------------------------}

Constructor TXmlTransactionLines.Create(Const ParentTrans : TObject);
Begin { Create }
  //Inherited Create (ComServer.TypeLib, ITransactionLines);
  Inherited Create (ComServer.TypeLib, IXmlTransactionLines);

  // Initialise Btrieve Ancestor
  InitObjects;
  FLines := TList.Create;
  FIdControl := TBits.Create;

  // Init Local variables
  FTransaction := ParentTrans;
  FLoadedFolio := -1919191919;
End; { Create }

{-----------------------------------------}

Destructor TXmlTransactionLines.Destroy;
Begin { Destroy }
  { Remove any loaded lines }
  KillLines;

  { Destroy sub-objects }
  FreeAndNil(FIdControl);
  FreeAndNil(FLines);
  InitObjects;

  inherited Destroy;
End; { Destroy }

{-----------------------------------------}

Procedure TXmlTransactionLines.InitObjects;
Begin { InitObjects }
  // Reference to parent TTransaction object (as TObject to avoid circular references) }
  FTransaction := Nil;

End; { InitObjects }

{-----------------------------------------}

// Empties the Transaction Line List
Procedure TXmlTransactionLines.KillLines;
Var
  TmpLine : pTransLineType;
Begin { KillLines }
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
End; { KillLines }

{-----------------------------------------}


function TXmlTransactionLines.Get_thLineCount: Integer;
begin
  If Assigned(FLines) Then
    Result := FLines.Count
  Else
    Result := 0;
end;

function TXmlTransactionLines.Get_thLine(Index: Integer): IXmlTransactionLine;
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
    Raise Exception.Create('Invalid Transaction Line Number (' + IntToStr(Index) + ')');
end;


// Returns new Transaction Line object for adding a new line
Function TXmlTransactionLines.Add: IXmlTransactionLine;
Var
  TmpLine    : pTransLineType;
  oTransLine : TXmlTransactionLine;
  NewTL      : TBatchTLRec;
  IdNo       : LongInt;
begin { Add }
  // Initialise dummy TL Record
  FillChar (NewTL, SizeOf(NewTL), #0);   // Defaults set in TXmlTransactionLine.InitNewLine;

  // Calculate next available line number
  If (FLines.Count > 0) Then
    For IdNo := 0 To Pred(FLines.Count) Do Begin
      // Extract references to Transaction Line
      TmpLine := FLines.Items[IdNo];

      // Check Line Number }
      If (TmpLine.TLI.tlLineNo > NewTL.LineNo) Then
        NewTL.LineNo := TmpLine.TLI.tlLineNo;
    End; { For I}
  Inc(NewTL.LineNo, 2);  // Must leave a space otherwise Enterprise Insert routine has problems

  // Allocate unique Id number
  IdNo := FIdControl.OpenBit;
  FIdControl.Bits[IdNo] := True;

  NewTL.TransRefNo := TXmlTransaction(FTransaction).TH.OurRef;

  // Create new Transaction Line object
  oTransLine := TXmlTransactionLine.Create(IdNo, FTransaction, Self, NewTL);
  oTransLine.InitNewLine;

  Result := oTransLine;
End; { Add }

// Called by the Transaction Line created in .Add to add itself into the list
Procedure TXmlTransactionLines.AddNewLine (Const TL : TXmlTransactionLine);
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

End; { AddNewLine }

{-----------------------------------------}

// Delete method on Transaction Lines object
Procedure TXmlTransactionLines.Delete(Index: Integer);
Var
  TmpLine : pTransLineType;
Begin { Delete}
    // Check Line Index is valid
    If (Index >= 1) And (Index <= FLines.Count) Then Begin
      // remove object references
      TmpLine := FLines.Items[Pred(Index)];
      With TmpLine^ Do Begin
        TLO := Nil;
        TLI := Nil;
      End; { With TmpLine }
      Dispose(TmpLine);

      // Destroy List Entry
      FLines.Delete(Pred(Index));
    End { If (Index >= 1) And (Index <= (FLines.Count)) }
    Else
      Raise Exception.Create ('ITransactionLines.Delete - Invalid Transaction Line number specified (' + IntToStr(Index) + ')');
End; { Delete }


end.
