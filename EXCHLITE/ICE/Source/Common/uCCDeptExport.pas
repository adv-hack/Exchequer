unit uCCDeptExport;
{
  Class to export Cost Centre and Department records.

  There is an XML file for Cost Centres and an XML file for Departments, but
  both have identical formats.

  Example format:

    <?xml version="1.0"?>
    <val:ccdep xmlns:val="urn:www-iris-co-uk:ccdep">
      <message guid="" number="" count="" source="" destination="" flag="">
        <ccdeprec>
          <ccdepcode>AAA</ccdepcode>
          <ccdepdesc>Head Office</ccdepdesc>
        </ccdeprec>
        <ccdeprec>
          <ccdepcode>DS1</ccdepcode>
          <ccdepdesc>Branch 1</ccdepdesc>
        </ccdeprec>
        .
        .
        .
      </message>
    </val:ccdep>

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
  TCCDeptExport = class(_ExportBase)
  private
    FExportType: TCCDeptExportType;
    function IsCostCentre: Boolean;
  protected
    function BuildXmlRecord(pCCDept: Pointer): Boolean; overload; override;
  public
    function LoadFromDB: Boolean; override;
    property ExportType: TCCDeptExportType read FExportType write FExportType;
  end;

implementation

uses
  uEXCHBaseClass;

// ===========================================================================
// TCCDeptExport
// ===========================================================================

function TCCDeptExport.IsCostCentre: Boolean;
begin
  Result := (ExportType = cdExportCostCentres);
end;

// ---------------------------------------------------------------------------

function TCCDeptExport.BuildXmlRecord(pCCDept: Pointer): Boolean;
var
  lRootNode, lRecNode: IXMLDomNode;
begin
  Result := False;

  lRootNode := ActiveXMLDoc.Doc;

  { Locate the top node, 'message' -- all the other records will be added as
    child nodes below this node. }
  lRootNode := _GetNodeByName(lRootNode, 'message');

  if (lRootNode <> nil) then
  try

    { Add the record node. }
    lRecNode := lRootNode.appendChild(ActiveXMLDoc.Doc.createElement('ccdeprec'));

    { Attach the fields to the record node. }
    _AddLeafNode(lRecNode, 'cdcode',   PasswordRec(pCCDept^).CostCtrRec.PCostC);
    _AddLeafNode(lRecNode, 'cdname',   PasswordRec(pCCDept^).CostCtrRec.CCDesc);
    _AddLeafNode(lRecNode, 'cdhideac', PasswordRec(pCCDept^).CostCtrRec.HideAC);
    _AddLeafNode(lRecNode, 'cdcctag',  PasswordRec(pCCDept^).CostCtrRec.CCTag);

    Result := True;
  except
    on E:Exception do
      DoLogMessage('TCCDeptExport.BuildXml',
                   cBUILDINGXMLERROR,
                   'Error: ' + E.message);
  end
  else
    DoLogMessage('TCCDeptExport.BuildXml',
                 cINVALIDXMLNODE);
end;

// ---------------------------------------------------------------------------

function TCCDeptExport.LoadFromDB: Boolean;

  function IsValidRecord(Key: string): Boolean;
  begin
    Result := (Copy(Key, 1, 2) = (CostCCode + CSubCode[IsCostCentre]));
  end;

var
  FuncRes: LongInt;
  Key: ShortString;
  ErrorCode: Integer;
  RecPFix, SubType: Char;
  PasswordRecPtr: ^PasswordRec;
  lRecNode: IXMLDOMNode;
begin
  Result := False;
  RecPfix := CostCCode;
  Subtype := CSubCode[IsCostCentre];

  ErrorCode := 0;

  Key := RecPFix + SubType;

  SetDrive := DataPath;

  Clear;

  { Open the table... }
  FuncRes := Open_File(F[PwrdF], SetDrive + FileNames[PwrdF], 0);
  if (FuncRes = 0) then
  begin

    { ...and find the first record. }
    FuncRes := Find_Rec(B_GetGEq, F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0, Key);

    if (FuncRes = 0) then
    begin
      PasswordRecPtr := @Password;

      { Create the XML document handler (in fActiveXMLDoc). }
      CreateXMLDoc;

      { Locate and delete the empty CCDepRec section, because we are going to
        create multiple entries (rather than simply updating the fields in one
        entry). }
      lRecNode := ActiveXMLDoc.Doc;
      lRecNode := _GetNodeByName(lRecNode, 'message');
      lRecNode.removeChild(_GetNodeByName(lRecNode, 'ccdeprec'));

      while (FuncRes = 0) and IsValidRecord(Key) do
      begin
        { Build the required XML record from the Cost Centre/Department
          details. }
        BuildXMLRecord(PasswordRecPtr);
        Result := True;
        FuncRes := Find_Rec(B_GetNext, F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0, Key);
      end;

      ActiveXMLDoc.Load(StringReplace(ActiveXMLDoc.Doc.xml, #13#10, '', [rfReplaceAll]));
      ActiveXMLDoc.RemoveComments;

      List.Add(ActiveXMLDoc);
    end;

    FuncRes := Close_File(F[PwrdF]);
  end
  else
    ErrorCode := cCONNECTINGDBERROR;

  { Log any errors. }
  if (ErrorCode <> 0) then
    DoLogMessage('TCCDeptExport.LoadFromDB', ErrorCode, 'Error: ' + IntToStr(FuncRes));
end;

// ---------------------------------------------------------------------------

end.
