unit oCards;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  Classes, ComCtrls, ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, SysUtils
  , EPOSProc, EPOSCnst, CustomP, DLLInc, oCard;

type

  TTradeTCMSetupCreditCards = class(TAutoIntfObject, ITradeTCMSetupCreditCards)
  private
    lCreditCards : TCreditCards;

    FCards       : TList;
    FIdControl   : TBits;
  protected
    function Get_ccCard(Index: Integer): ITradeTCMSetupCreditCard; safecall;
    function Get_ccNoOfCards: Integer; safecall;

    Procedure KillCards;
  public
    Property Cards : TList Read FCards;
    Constructor Create(CreditCards : TCreditCards);
    Destructor Destroy; override;
    Procedure CheckForCards;
  End; { TTradeEventTransCards }

implementation
uses
  ComServ, TXHead;

type
  TCardType = Record
    IdNo : SmallInt;
    CardO  : TTradeTCMSetupCreditCard;
    CardI  : ITradeTCMSetupCreditCard;
  End;
  pCardType = ^TCardType;


Constructor TTradeTCMSetupCreditCards.Create(CreditCards : TCreditCards);
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeEventTransaction);

  lCreditCards := CreditCards;

  FCards := TList.Create;
  FIdControl := TBits.Create;

  CheckForCards;
End; { Create }

Destructor TTradeTCMSetupCreditCards.Destroy;
Begin { Destroy }

  FreeAndNil(FCards);
  FreeAndNil(FIdControl);

  Inherited;
End; { Destroy }

Procedure TTradeTCMSetupCreditCards.CheckForCards;
Var
  iPos : Integer;
  oCard : pCardType;
Begin { CheckForCards }

  KillCards;

  For iPos := 0 to 19 do begin

    New (oCard);
    With oCard^ Do Begin
      // Allocate unique Id number
      IdNo := FIdControl.OpenBit;
      FIdControl.Bits[IdNo] := True;

      // Create lines object
      CardO  := TTradeTCMSetupCreditCard.Create(lCreditCards[iPos].Desc, lCreditCards[iPos].GLCode);
      CardI  := oCard.CardO;

    End; { With oCard }

   // Add into Cards List
    FCards.Add(oCard);

  end;{For}

End; { CheckForCards }

// Empties the Transaction Line List
Procedure TTradeTCMSetupCreditCards.KillCards;
Var
  TmpLine : pCardType;
Begin { KillCards }
  While (FCards.Count > 0) Do Begin
    // remove object references
    TmpLine := FCards.Items[0];
    TmpLine.CardO := Nil;
    TmpLine.CardI := Nil;
    Dispose(TmpLine);

    // Destroy List Entry
    FCards.Delete(0);
  End; { While (FCards.Count > 0) }

  // Shrink TBits to reset all flags back to false
  FIdControl.Size := 1;
End; { KillCards }


function TTradeTCMSetupCreditCards.Get_ccNoOfCards: Integer;
begin
  If Assigned(FCards) Then
    Result := FCards.Count
  Else
    Result := 0;
end;

function TTradeTCMSetupCreditCards.Get_ccCard(Index: Integer): ITradeTCMSetupCreditCard;
Var
  oCard : pCardType;
begin
  // Check its a valid line number
  If (Index >= 1) And (Index <= FCards.Count) Then Begin
    // Extract interface from list
    oCard := FCards.Items[Index - 1];
    Result := oCard.CardI;
  End { If (Index >= 1) And (Index <= FCards.Count) }
  Else
    Raise EValidation.Create('Invalid Card Number (' + IntToStr(Index) + ')');
end;


end.
