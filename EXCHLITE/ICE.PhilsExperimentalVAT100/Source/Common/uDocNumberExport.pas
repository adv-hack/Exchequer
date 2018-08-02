unit uDocNumberExport;
{
   DocNumber export class.
}


interface

uses
  Classes, SysUtils, ComObj, Controls, Variants,

  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,

  // ICE units
  MSXML2_TLB,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uExportBaseClass
  ;

{$I ice.inc}

type
  TDocNumberExport = Class(_ExportBase)
  protected
    function BuildXmlRecord(pDocNumber: Pointer): Boolean; override;
  public
    function LoadFromDB: Boolean; override;
  end;

implementation

uses
  uEXCHBaseClass;

// ===========================================================================
// TDocNumberExport
// ===========================================================================

function TDocNumberExport.BuildXmlRecord(pDocNumber: Pointer): Boolean;
var
  lRootNode, lRecNode: IXMLDomNode;
  NextDocNumber: LongInt;
const
  AS_CDATA = True;
Begin
  Result := False;

  With IncrementRec(pDocNumber^) Do
  Begin
    lRootNode := ActiveXMLDoc.Doc;

    { Locate the top node, 'message' -- all the other records will be added as
      child nodes below this node. }
    lRootNode := _GetNodeByName(lRootNode, 'message');

    if (lRootNode <> nil) then
    try

      { Add the record node. }
      lRecNode := lRootNode.appendChild(ActiveXMLDoc.Doc.createElement('dnrec'));

      { Add the field nodes. Fields which could potentially hold invalid (for
        HTML) characters, such as '<' or '&', are saved as CDATA nodes. All
        other fields are stored as TEXT nodes. }
      _AddLeafNode(lRecNode, 'dncounttype', CountTyp);
      _AddLeafNode(lRecNode, 'dnlastvalue', LastValue);
      _AddLeafNode(lRecNode, 'dnspare', Spare, AS_CDATA);

      Move(NextCount[1], NextDocNumber, Sizeof(NextDocNumber));
      _AddLeafNode(lRecNode, 'dnnextcount', NextDocNumber);

      Result := True;
    except
      On e: Exception Do
        DoLogMessage('TDocNumberExport.BuildXml', cBUILDINGXMLERROR, 'Error: ' +
          e.message);
    end
    else
      DoLogMessage('TDocNumberExport.BuildXml', cINVALIDXMLNODE);
  end;
end;

// ---------------------------------------------------------------------------

function TDocNumberExport.LoadFromDB: Boolean;
var
  FuncRes: LongInt;
  Key: ShortString;
  ErrorCode: Integer;
  DocNumberRecPtr: ^IncrementRec;
  lRecNode: IXMLDOMNode;
begin
  Result := False;

  ErrorCode := 0;

  SetDrive := DataPath;

  Clear;

  { Open the table... }
  FuncRes := Open_File(F[IncF], SetDrive + FileNames[IncF], 0);
  if (FuncRes = 0) then
  begin

    { ...and find the record. }
    FuncRes := Find_Rec(B_GetFirst, F[IncF], IncF, RecPtr[IncF]^, 0, Key);
    Result := (FuncRes = 0);

    { Create the XML document handler (in fActiveXMLDoc). }
    CreateXMLDoc;

    { Locate and delete the empty DNRec section, because we are going to
      create multiple entries (rather than simply updating the fields in one
      entry). }
    lRecNode := ActiveXMLDoc.Doc;
    lRecNode := _GetNodeByName(lRecNode, 'message');
    lRecNode.removeChild(_GetNodeByName(lRecNode, 'dnrec'));

    DocNumberRecPtr := @Count;
    while (FuncRes = 0) do
    begin
      { Build the required XML record from the Document Number
        details. }
      BuildXMLRecord(DocNumberRecPtr);
      FuncRes := Find_Rec(B_GetNext, F[IncF], IncF, RecPtr[IncF]^, 0, Key);
    end;

    ActiveXMLDoc.Load(StringReplace(ActiveXMLDoc.Doc.xml, #13#10, '', [rfReplaceAll]));
    ActiveXMLDoc.RemoveComments;

    List.Add(ActiveXMLDoc);

    FuncRes := Close_File(F[IncF]);
  end
  else
    ErrorCode := cCONNECTINGDBERROR;

  { Log any errors. }
  if (ErrorCode <> 0) then
    DoLogMessage('TDocNumberExport.LoadFromDB', ErrorCode, 'Error: ' + IntToStr(FuncRes));
End;

// ---------------------------------------------------------------------------

end.
