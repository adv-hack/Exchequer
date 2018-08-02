{-----------------------------------------------------------------------------
 Unit Name: uXMLList
 Author:    vmoura
 Purpose:
 History:

 thijn class to hold a list of XML
-----------------------------------------------------------------------------}
unit uXMLList;

interface

uses Classes;

type
  TXMLItem = Class(TCollectionItem)
  Private
    fXml: WideString;
    fPack_Id: Integer;
    fPluginLink: String;
    fDeleteFile: Boolean;
  Published
    Property XML: WideString Read fXml Write fXml;
    Property Pack_Id: Integer Read fPack_Id Write fPack_Id;
    property PluginLink: String read fPluginLink write fPluginLink;
    property DeleteFile: Boolean read fDeleteFile write fDeleteFile;
  Public
    Destructor Destroy; Override;
  End;

  TXMLList = Class(TCollection)
  Private
    fDeleteFiles: Boolean;
    Function GetItem(Index: Integer): TXMLItem;
    Procedure SetItem(Index: Integer; Value: TXMLItem);
  Public
    Function Add: TXMLItem;
    Constructor Create(AOwner: TComponent);
    Destructor Destroy; Override;
    Property Items[Index: Integer]: TXMLItem Read GetItem Write SetItem; Default;
    property DeleteFiles: Boolean read fDeleteFiles write fDeleteFiles;
  End;


implementation

uses uCommon;

Destructor TXMLItem.Destroy;
Begin
{$IFNDEF DELETEXML}
  Try
    if fDeleteFile then
      If _FileSize(fXml) > 0 Then
        _DelFile(fXML);
  Except
  End;
{$ENDIF}

  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: Add
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TXMLList.Add: TXMLItem;
Begin
  Result := TXMLItem(Inherited Add);
  Result.DeleteFile := fDeleteFiles;
End;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TXMLList.Create(AOwner: TComponent);
Begin
  Inherited Create(TXMLItem);
  fDeleteFiles := True;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TXMLList.Destroy;
Var
  lCont: Integer;
Begin
{$IFNDEF DELETEXML}
  For lCont := 0 To Self.Count - 1 Do
  Try
    if fDeleteFiles then
      If _FileSize(Self.Items[lCont].XML) > 0 Then
        _DelFile(Self.Items[lCont].XML)
  Except
  End;
{$ENDIF}

  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: GetItem
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TXMLList.GetItem(Index: Integer): TXMLItem;
Begin
  Result := TXMLItem(Inherited GetItem(Index));
End;

{-----------------------------------------------------------------------------
  Procedure: SetItem
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TXMLList.SetItem(Index: Integer; Value: TXMLItem);
Begin
  Inherited SetItem(Index, Value);
End;

end.
