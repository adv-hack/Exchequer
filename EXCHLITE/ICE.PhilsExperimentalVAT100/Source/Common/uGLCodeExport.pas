unit uGLCodeExport;
{
  General Ledger Code export class.

  Example format:

    <?xml version="1.0"?>
    <val:glcode xmlns:val="urn:www-iris-co-uk:glcode">
      <message guid="" number="" count="" source="" destination="" flag="">
        <glcoderec>
          <glcode>10</glcode>
          <glname>Fixed Assets</glname>
          <glparent>0</glparent>
          <gltype>H</gltype>
          <glpage>False</glpage>
          <glsubtotal>False</glsubtotal>
          <gltotal>False</gltotal>
          <glcarryfwd>0</glcarryfwd>
          <glrevalue>False</glrevalue>
          <glaltcode>10</glaltcode>
          <glprivaterec>0</glprivaterec>
          <glcurrency>0</glcurrency>
          <glforcejc>False</glforcejc>
          <glhideac>0</glhideac>
          <glclass>0</glclass>
          <glspare></glspare>
        </glcoderec>
        <glcoderec>
          <glcode>100</glcode>
          <glname>Buildings/Properties</glname>
          <glparent>10</glparent>
          <gltype>H</gltype>
          <glpage>False</glpage>
          <glsubtotal>False</glsubtotal>
          <gltotal>False</gltotal>
          <glcarryfwd>0</glcarryfwd>
          <glrevalue>False</glrevalue>
          <glaltcode>100</glaltcode>
          <glprivaterec>0</glprivaterec>
          <glcurrency>0</glcurrency>
          <glforcejc>False</glforcejc>
          <glhideac>0</glhideac>
          <glclass>0</glclass>
          <glspare></glspare>
        </glcoderec>
        .
        .
        .
      </message>
    </val:glcode>

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
  TGLCodeExport = Class(_ExportBase)
  private
    procedure AddChildRecords(ParentCode: LongInt);
  protected
    function BuildXmlRecord(pNom: Pointer): Boolean; override;
  public
    function LoadFromDB: Boolean; override;
  end;

implementation

uses
  uEXCHBaseClass,
  SavePos,
  BtKeys1U;

// ===========================================================================
// TGLCodeExport
// ===========================================================================

procedure TGLCodeExport.AddChildRecords(ParentCode: LongInt);
{ Recursive routine for retrieving the GL tree in the correct order (each
  parent record followed by its child records). }

  function IsValidRecord: Boolean;
  { Returns False if the current record no longer matches the parent code (in
    other words, we have gone past the last child record for this parent). }
  begin
    Result := (Nom.Cat = ParentCode);
  end;

var
  FuncRes: Integer;
  NomRecPtr: ^NominalRec;
  Key: ShortString;
begin
  { Find the first child record, if any, for this parent code. }
  Key := FullNomKey(ParentCode);
  FuncRes := Find_Rec(B_GetGEq, F[NomF], NomF, RecPtr[NomF]^, NomCatK, Key);
  NomRecPtr := @Nom;
  { Cycle through all the child records. }
  while (FuncRes = 0) and IsValidRecord do
  begin
    { Add the record to the XML. }
    BuildXMLRecord(NomRecPtr);
    { If the ledger code type is 'Header', it will have child records. }
    if (Nom.NomType = 'H') then
    begin
      { Preserve the current database position (because we are going to call
        this routine recursively, which will move the database cursor to a
        new position). }
      with TBtrieveSavePosition.Create do
      try
        SaveFilePosition(NomF, GetPosKey);
        { Process the child records. }
        AddChildRecords(Nom.NomCode);
      finally
        RestoreSavedPosition;
        Free;
      end;
    end;
    FuncRes := Find_Rec(B_GetNext, F[NomF], NomF, RecPtr[NomF]^, NomCatK, Key);
  end;
end;

// ---------------------------------------------------------------------------

function TGLCodeExport.LoadFromDB: Boolean;
var
  FuncRes: LongInt;
  ErrorCode: Integer;
  lRecNode: IXMLDOMNode;
begin
  Result := False;

  ErrorCode := 0;

  SetDrive := DataPath;

  Clear;

  { Create the XML document handler (in fActiveXMLDoc). }
  CreateXMLDoc;

  { Locate and delete the empty GL record section, because we are going to
    create multiple entries (rather than simply updating the fields in one
    entry). }
  lRecNode := ActiveXMLDoc.Doc;
  lRecNode := _GetNodeByName(lRecNode, 'message');
  lRecNode.removeChild(_GetNodeByName(lRecNode, 'glcoderec'));

  { Open the table. }
  FuncRes := Open_File(F[NomF], SetDrive + FileNames[NomF], 0);
  if (FuncRes = 0) then
  begin

    { Records with no parent have a parent code of 0. Start the processing with
      these records. }
    AddChildRecords(0);

    ActiveXMLDoc.Load(StringReplace(ActiveXMLDoc.Doc.xml, #13#10, '', [rfReplaceAll]));
    ActiveXMLDoc.RemoveComments;

    List.Add(ActiveXMLDoc);

    FuncRes := Close_File(F[NomF]);
    Result := True;
  end
  else
    ErrorCode := cCONNECTINGDBERROR;

  { Log any errors. }
  if (ErrorCode <> 0) then
    DoLogMessage('TGLCodeExport.LoadFromDB', ErrorCode, 'Error: ' + IntToStr(FuncRes));
End;

// ---------------------------------------------------------------------------

function TGLCodeExport.BuildXmlRecord(pNom: Pointer): Boolean;
var
  lRootNode, lRecNode: IXMLDomNode;
  SpareStr: string[47];
const
  AS_CDATA = True;
begin
  Result := False;

  with NominalRec(pNom^) Do
  begin
    lRootNode := ActiveXMLDoc.Doc;

    { Locate the top node, 'message' -- all the other records will be added as
      child nodes below this node. }
    lRootNode := _GetNodeByName(lRootNode, 'message');

    if (lRootNode <> nil) then
    try

      { Add the record node. }
      lRecNode := lRootNode.appendChild(ActiveXMLDoc.Doc.createElement('glcoderec'));

      { Add the field nodes. Fields which could potentially hold invalid (for
        HTML) characters, such as '<' or '&', are saved as CDATA nodes. All
        other fields are stored as TEXT nodes. }

      _AddLeafNode(lRecNode, 'glcode', nomcode);
      _AddLeafNode(lRecNode, 'glname', desc, AS_CDATA);
      _AddLeafNode(lRecNode, 'glparent', cat);
      _AddLeafNode(lRecNode, 'gltype', nomtype);
      _AddLeafNode(lRecNode, 'glpage', nompage);
      _AddLeafNode(lRecNode, 'glsubtotal', subtype);
      _AddLeafNode(lRecNode, 'gltotal', total);
      _AddLeafNode(lRecNode, 'glcarryfwd', carryf);
      _AddLeafNode(lRecNode, 'glrevalue', revalue);
      _AddLeafNode(lRecNode, 'glaltcode', altcode, AS_CDATA);
      _AddLeafNode(lRecNode, 'glprivaterec', privaterec);
      _AddLeafNode(lRecNode, 'glcurrency', defcurr);
      _AddLeafNode(lRecNode, 'glforcejc', forcejc);
      _AddLeafNode(lRecNode, 'glhideac', hideac);
      _AddLeafNode(lRecNode, 'glclass', nomclass);

      Move(Spare[1], SpareStr[1], Length(Spare));
      _AddLeafNode(lRecNode, 'glspare', SpareStr);

      Result := True;
    except
      On e: Exception Do
        DoLogMessage('TGLCodeExport.BuildXml', cBUILDINGXMLERROR, 'Error: ' +
          e.message);
    end
    else
      DoLogMessage('TGLCodeExport.BuildXml', cINVALIDXMLNODE);
  end;
end;

// ---------------------------------------------------------------------------

end.
