unit LinkList;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  VarConst;

type
  pLLCardType =  ^LLCardType;

  LLCardType = Record
    Card     : LongInt;
    RetMap   : GuestSale_Retrieved;
    Next     : pLLCardType;
  End; { LLCardType }

  TLinkList_Card = Class(TObject)
{  TLinkList_Card = Object}
    public
      FirstCard    : pLLCardType; { Points to first card added }
      CurrCard     : pLLCardType; { Poins to current card }
      LastCard     : pLLCardType; { Points to last card added }
      Found        : Boolean;
      Count        : Byte;

      Constructor Init;
      Destructor  Done;
      Procedure AddCard (TheCard : LongInt; RetrievedMap : GuestSale_Retrieved);
      Procedure GetFirst;
      Procedure GetNext;
      Procedure Clear;
  End;{TLinkList_Card }

  pLLSalesType =  ^LLSalesType;

  LLSalesType = Record
    itType      : Char;         { 'D' Dept, 'P' PLU }
    itNumber    : LongInt;
    itName      : String [16];
    itQuantity  : Real;
    itAmount    : Real;
    itRate      : Real;
    itIncAmount : Real;

    Next        : pLLSalesType;
  End; { LLSalesType }

  TLinkList_Sales = Class(TObject)
{  TLinkList_Sales = Object}
    public
      FirstItem   : pLLSalesType; { Points to first item added }
      CurrItem    : pLLSalesType; { Poins to current item }
      LastItem    : pLLSalesType; { Points to last item added }
      Found       : Boolean;

      Constructor Init;
      Destructor  Done;

      Procedure AddItem (itType:Char;itNumber:LongInt;itName:String;itQuantity:Real;itAmount:Real;itRate:Real);
      Procedure FindItem (fType:Char;fNumber:LongInt);
      Procedure GetFirst;
      Procedure GetNext;
      Procedure Clear;
  End; { TLinkList_Sales }

implementation


{******************************************************}
{* TLinkList_Card (Member Till Numbers - Linked List) *}
{******************************************************}
Constructor TLinkList_Card.Init;
Begin { TLinkList_Card.Init }
  Inherited create;
  FirstCard := NIL;
  CurrCard  := NIL;
  LastCard  := NIL;

  Found     := False;
  Count     := 0;
End;  { TLinkList_Card.Init }


Destructor  TLinkList_Card.Done;
Begin { TLinkList_Card.Done }
  Clear;
End;  { TLinkList_Card.Done }


Procedure TLinkList_Card.AddCard (TheCard : LongInt; RetrievedMap : GuestSale_Retrieved);
Var
  TmpCard : PLLCardType;
Begin { TLinkList_Card.AddCard }
{  If DebugLL Then Writeln (LST, 'LL_Card.Add: ', TheCard);}

  New (TmpCard);

  With TmpCard^ Do Begin
    Card   := TheCard;
    RetMap := RetrievedMap;
    Next   := NIL;
  End; { With }

  { Check to see if already got a record }
  If (FirstCard = NIL) Then Begin
    { Adding First record }
    FirstCard := TmpCard;
    LastCard  := TmpCard;
    CurrCard  := TmpCard;
  End { If }
  Else Begin
    { Adding another record to the list }
    LastCard^.Next := TmpCard;
    LastCard := LastCard^.Next;
  End; { If }

  Found := (CurrCard <> NIL);
  Inc (Count);
End;  { TLinkList_Card.AddCard }


Procedure TLinkList_Card.GetFirst;
Begin { TLinkList_Card.GetFirst }
  { Move to first item in list }
  CurrCard := FirstCard;

  { Set found flag }
  Found := (CurrCard <> NIL);
End;  { TLinkList_Card.GetFirst }


Procedure TLinkList_Card.GetNext;
Begin { TLinkList_Card.GetNext }
  { Move to first item in list }
  CurrCard := CurrCard^.Next;

  { Set found flag }
  Found := (CurrCard <> NIL);
End;  { TLinkList_Card.GetNext }

Procedure TLinkList_Card.Clear;
Begin { TLinkList_Card.Clear }
  { Release any pointers still hanging around }
  While (FirstCard <> NIL) Do Begin
    { take copy of child }
    CurrCard := FirstCard^.Next;

    { Deallocate main duff record }
    Dispose (FirstCard);

    { Copy child back into main duff record }
    FirstCard := CurrCard;
  End; { While }

  Found := False;
  Count := 0;
End;  { TLinkList_Card.Clear }


{***********************}
{* Sales - Linked List *}
{***********************}
Constructor TLinkList_Sales.Init;
Begin { TLinkList_Sales.Init }
  Inherited create;
  FirstItem := NIL;
  CurrItem  := NIL;
  LastItem  := NIL;

  Found     := False;
End;  { TLinkList_Sales.Init }

Destructor TLinkList_Sales.Done;
Begin { TLinkList_Sales.Done }
  Clear;
End;  { TLinkList_Sales.Done }


Procedure TLinkList_Sales.AddItem (itType     : Char;
                                   itNumber   : LongInt;
                                   itName     : String;
                                   itQuantity : Real;
                                   itAmount   : Real;
                                   itRate     : Real);
Var
  TmpSales : pLLSalesType;
Begin { TLinkList_Sales.AddItem }
{  If DebugLL Then Writeln (LST, 'LL_Sales.Add: ',
                                 itType, ' ',
                                 itNumber:5, ' ',
                                 itName:16, ' ',
                                 itAmount:8:2, ' ',
                                 itRate:10:4);}

  New (TmpSales);

  TmpSales^.itType      := itType;
  TmpSales^.itNumber    := itNumber;
  TmpSales^.itName      := itName;
  TmpSales^.itQuantity  := itQuantity;
  TmpSales^.itAmount    := itAmount;
  TmpSales^.itRate      := itRate;
  TmpSales^.itIncAmount := ABS(itAmount);
  TmpSales^.Next        := NIL;

  { Check to see if already got a record }
  If (FirstItem = NIL) Then Begin
    { Adding First record }
    FirstItem := TmpSales;
    LastItem  := TmpSales;
    CurrItem  := TmpSales;
  End { If }
  Else Begin
    { Adding another record to the list }
    LastItem^.Next := TmpSales;
    LastItem := LastItem^.Next;
  End; { If }

  Found := (CurrItem <> NIL);
End;  { TLinkList_Sales.AddItem }

Procedure TLinkList_Sales.FindItem (fType:Char;fNumber:LongInt);
Begin { TLinkList_Sales.FindItem }
  GetFirst;

  While Found And
        ( (CurrItem^.itType <> fType) Or
          (CurrItem^.itNumber <> fNumber) ) Do
    GetNext;
End;  { TLinkList_Sales.FindItem }

Procedure TLinkList_Sales.GetFirst;
Begin { TLinkList_Sales.GetFirst }
  { Move to first item in list }
  CurrItem := FirstItem;

  { Set found flag }
  Found := (CurrItem <> NIL);
End;  { TLinkList_Sales.GetFirst }


Procedure TLinkList_Sales.GetNext;
Begin { TLinkList_Sales.GetNext }
  { Move to first item in list }
  CurrItem := CurrItem^.Next;

  { Set found flag }
  Found := (CurrItem <> NIL);
End;  { TLinkList_Sales.GetNext }

Procedure TLinkList_Sales.Clear;
Begin { TLinkList_Sales.Clear }
  { Release any pointers still hanging around }
  While (FirstItem <> NIL) Do Begin
    { take copy of child }
    CurrItem := FirstItem^.Next;

    { Deallocate main duff record }
    Dispose (FirstItem);

    { Copy child back into main duff record }
    FirstItem := CurrItem;
  End; { While }

  Found := False;
End;  { TLinkList_Sales.Clear }

end.
