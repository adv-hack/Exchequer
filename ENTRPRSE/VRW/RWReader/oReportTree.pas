unit oReportTree;

interface

Uses Classes, SysUtils, RWRIntF;

Type
  TReportItem = Class;

  //------------------------------

  TReportTree = Class(TInterfacedObject, IReportTree)
  Private
    FReportItems : TInterfaceList;

    // IReportTree methods
    Function GetReportCount : SmallInt;
    Function GetReportItems (Index: SmallInt) : IReportTreeElement;
  Public
    Property ReportCount : SmallInt Read GetReportCount;

    Constructor Create;
    Destructor Destroy; Override;

    Procedure AddSubReport(RepItem : TReportItem);
    //Function AddReportItem (Const RepCode, RepName, Pword : ShortString; Const IsGroup : Boolean) : TReportItem;
  End; // TReportTree

  //------------------------------

  TReportItem = Class(TReportTree, IReportTreeElement)
  Private
    FCode : ShortString;
    FName : ShortString;
    FType : TReportType;
    FPWord : ShortString;

    // IReportTreeElement mehtods
    Function GetCode : ShortString;
    Function GetName : ShortString;
    Function GetType : TReportType;
    Function GetPWord : ShortString;
  Public
    Constructor Create (Const RepCode, RepName, PWord : ShortString; Const IsGroup : Boolean);
    destructor Destroy; override;
  End; // TReportItem


implementation

//=========================================================================

Constructor TReportTree.Create;
Begin // Create
  Inherited Create;
  FReportItems := TInterfaceList.Create;
End; // Create

//------------------------------

Destructor TReportTree.Destroy;
Begin // Destroy
  FreeAndNIL(FReportItems);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TReportTree.GetReportCount : SmallInt;
Begin // GetReportCount
  Result := FReportItems.Count;
End; // GetReportCount

//------------------------------

Function TReportTree.GetReportItems (Index: SmallInt) : IReportTreeElement;
Begin // GetReportItems
  If (Index >= 0) And (Index < FReportItems.Count) Then
  Begin
    Result := FReportItems[Index] As IReportTreeElement;
  End // If (Index >= 0) And (Index < FReportItems.Count)
  Else
    Raise Exception.Create ('TReportTree.GetReportItems: Invalid ReportItems Index (' + IntToStr(Index) + ')');
End; // GetReportItems

//-------------------------------------------------------------------------

Procedure TReportTree.AddSubReport(RepItem : TReportItem);
Begin // AddReportItem
  FReportItems.Add(Repitem)
End; // AddReportItem

//=========================================================================

Constructor TReportItem.Create (Const RepCode, RepName, PWord : ShortString; Const IsGroup : Boolean);
Begin // Create
  Inherited Create;

  FCode := RepCode;
  FName := RepName;
  FPWord := Pword;
  If IsGroup Then FType := rtGroup Else FType := rtReport;
End; // Create

//-------------------------------------------------------------------------

Function TReportItem.GetCode : ShortString;
Begin // GetCode
  Result := FCode;
End; // GetCode

//------------------------------

Function TReportItem.GetName : ShortString;
Begin // GetName
  Result := FName;
End; // GetName

//------------------------------

Function TReportItem.GetType : TReportType;
Begin // GetType
  Result := FType;
End; // GetType

//------------------------------

Function TReportItem.GetPWord : ShortString;
Begin // GetPWord
  Result := FPWord;
End; // GetPWord

//=========================================================================


destructor TReportItem.Destroy;
begin
  inherited;
end;

end.
