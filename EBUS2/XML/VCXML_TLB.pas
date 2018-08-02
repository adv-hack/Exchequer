unit VCXML_TLB;

{ prutherford440 09:52 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


// ************************************************************************ //
// WARNING                                                                  //
// -------                                                                  //
// The types declared in this file were generated from data read from a     //
// Type Library. If this type library is explicitly or indirectly (via      //
// another type library referring to this type library) re-imported, or the //
// 'Refresh' command of the Type Library Editor activated while editing the //
// Type Library, the contents of this file will be regenerated and all      //
// manual modifications will be lost.                                       //
// ************************************************************************ //

// PASTLWTR : $Revision:   1.11.1.75  $
// File generated on 28/09/00 16:22:39 from Type Library described below.

// ************************************************************************ //
// Type Lib: vcxml10.dll
// IID\LCID: {E96FC475-F1C2-11D2-BD4B-0060086EBD80}\0
// Helpfile: 
// HelpString: Vivid Creations ActiveDOM 2.0.12 - http://www.vivid-creations.com
// Version:    1.0
// ************************************************************************ //

interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:      //
//   Type Libraries     : LIBID_xxxx                                    //
//   CoClasses          : CLASS_xxxx                                    //
//   DISPInterfaces     : DIID_xxxx                                     //
//   Non-DISP interfaces: IID_xxxx                                      //
// *********************************************************************//
const
  LIBID_VCXML: TGUID = '{E96FC475-F1C2-11D2-BD4B-0060086EBD80}';
  IID_IXMLDOMNode: TGUID = '{475BD672-F1DA-11D2-BD4B-0060086EBD80}';
  IID_IXMLDOMDocument: TGUID = '{E96FC481-F1C2-11D2-BD4B-0060086EBD80}';
  CLASS_DOMDocument: TGUID = '{E96FC482-F1C2-11D2-BD4B-0060086EBD80}';
  IID_IXMLDOMNodeList: TGUID = '{A1E33EE4-F696-11D2-B883-000000000000}';
  IID_IXMLDOMNamedNodeMap: TGUID = '{1BB05524-F5D5-11D2-B881-000000000000}';
  IID_IXMLDOMElement: TGUID = '{8B105E8F-F1D9-11D2-BD4B-0060086EBD80}';
  IID_IXMLDOMAttribute: TGUID = '{1BB05526-F5D5-11D2-B881-000000000000}';
  IID_IXMLDOMCharacterData: TGUID = '{6C6A8CF0-F4B8-11D2-B880-000000000000}';
  IID_IXMLDOMText: TGUID = '{CECC2F33-F1EB-11D2-B87A-000000000000}';
  IID_IXMLDOMComment: TGUID = '{9056DD06-F4AF-11D2-B880-000000000000}';
  IID_IXMLDOMProcessingInstruction: TGUID = '{553024C3-F4F9-11D2-B880-000000000000}';
  IID_IXMLDOMCDATASection: TGUID = '{261683F3-F56E-11D2-B881-000000000000}';
  IID_IXMLDOMEntityReference: TGUID = '{261683F5-F56E-11D2-B881-000000000000}';
  IID_IXMLDOMParseError: TGUID = '{261683F7-F56E-11D2-B881-000000000000}';
  IID_IXSLTEngine: TGUID = '{4F79E12E-A9B9-47FF-8F37-BA520FF067FD}';
  CLASS_XSLTEngine: TGUID = '{43107B99-2291-45D1-95D6-BDCC8F8A316F}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                  //
// *********************************************************************//
// eDOMNodeType constants
type
  eDOMNodeType = TOleEnum;
const
  DOM_ELEMENT_NODE = $00000001;
  DOM_ATTRIBUTE_NODE = $00000002;
  DOM_TEXT_NODE = $00000003;
  DOM_CDATA_SECTION_NODE = $00000004;
  DOM_ENTITY_REFERENCE_NODE = $00000005;
  DOM_ENTITY_NODE = $00000006;
  DOM_PROCESSING_INSTRUCTION_NODE = $00000007;
  DOM_COMMENT_NODE = $00000008;
  DOM_DOCUMENT_NODE = $00000009;
  DOM_DOCUMENT_TYPE_NODE = $0000000A;
  DOM_DOCUMENT_FRAGMENT_NODE = $0000000B;
  DOM_NOTATION_NODE = $0000000C;

type

// *********************************************************************//
// Forward declaration of interfaces defined in Type Library            //
// *********************************************************************//
  IXMLDOMNode = interface;
  IXMLDOMNodeDisp = dispinterface;
  IXMLDOMDocument = interface;
  IXMLDOMDocumentDisp = dispinterface;
  IXMLDOMNodeList = interface;
  IXMLDOMNodeListDisp = dispinterface;
  IXMLDOMNamedNodeMap = interface;
  IXMLDOMNamedNodeMapDisp = dispinterface;
  IXMLDOMElement = interface;
  IXMLDOMElementDisp = dispinterface;
  IXMLDOMAttribute = interface;
  IXMLDOMAttributeDisp = dispinterface;
  IXMLDOMCharacterData = interface;
  IXMLDOMCharacterDataDisp = dispinterface;
  IXMLDOMText = interface;
  IXMLDOMTextDisp = dispinterface;
  IXMLDOMComment = interface;
  IXMLDOMCommentDisp = dispinterface;
  IXMLDOMProcessingInstruction = interface;
  IXMLDOMProcessingInstructionDisp = dispinterface;
  IXMLDOMCDATASection = interface;
  IXMLDOMCDATASectionDisp = dispinterface;
  IXMLDOMEntityReference = interface;
  IXMLDOMEntityReferenceDisp = dispinterface;
  IXMLDOMParseError = interface;
  IXMLDOMParseErrorDisp = dispinterface;
  IXSLTEngine = interface;
  IXSLTEngineDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                     //
// (NOTE: Here we map each CoClass to its Default Interface)            //
// *********************************************************************//
  DOMDocument = IXMLDOMDocument;
  XSLTEngine = IXSLTEngine;


// *********************************************************************//
// Interface: IXMLDOMNode
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {475BD672-F1DA-11D2-BD4B-0060086EBD80}
// *********************************************************************//
  IXMLDOMNode = interface(IDispatch)
    ['{475BD672-F1DA-11D2-BD4B-0060086EBD80}']
    function Get_nodeName: WideString; safecall;
    procedure Set_nodeValue(const value: WideString); safecall;
    function Get_nodeValue: WideString; safecall;
    function Get_firstChild: IXMLDOMNode; safecall;
    function Get_lastChild: IXMLDOMNode; safecall;
    function Get_nodeType: eDOMNodeType; safecall;
    function Get_parentNode: IXMLDOMNode; safecall;
    function Get_childNodes: IXMLDOMNodeList; safecall;
    function Get_previousSibling: IXMLDOMNode; safecall;
    function Get_nextSibling: IXMLDOMNode; safecall;
    procedure appendChild(const newChild: IXMLDOMNode); safecall;
    function hasChildNodes: WordBool; safecall;
    function Get_ownerDocument: IXMLDOMDocument; safecall;
    function Get_attributes: IXMLDOMNamedNodeMap; safecall;
    function insertBefore(const newChild: IXMLDOMNode; const refChild: IXMLDOMNode): IXMLDOMNode; safecall;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; safecall;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; safecall;
    function Get_text: WideString; safecall;
    function Get_xml: WideString; safecall;
    function Get_internal_identity: Integer; safecall;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; safecall;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; safecall;
    procedure Set_text(const text: WideString); safecall;
    function Get_namespaceURI: WideString; safecall;
    function Get_prefix: WideString; safecall;
    procedure Set_prefix(const prefixString: WideString); safecall;
    function Get_baseName: WideString; safecall;
    procedure Set_baseName(const localName: WideString); safecall;
    function Get_nodeValueEx: OleVariant; safecall;
    procedure Set_nodeValueEx(pVal: OleVariant); safecall;
    function evalExpression(const sExpression: WideString): WordBool; safecall;
    property nodeName: WideString read Get_nodeName;
    property nodeValue: WideString read Get_nodeValue write Set_nodeValue;
    property firstChild: IXMLDOMNode read Get_firstChild;
    property lastChild: IXMLDOMNode read Get_lastChild;
    property nodeType: eDOMNodeType read Get_nodeType;
    property parentNode: IXMLDOMNode read Get_parentNode;
    property childNodes: IXMLDOMNodeList read Get_childNodes;
    property previousSibling: IXMLDOMNode read Get_previousSibling;
    property nextSibling: IXMLDOMNode read Get_nextSibling;
    property ownerDocument: IXMLDOMDocument read Get_ownerDocument;
    property attributes: IXMLDOMNamedNodeMap read Get_attributes;
    property text: WideString read Get_text write Set_text;
    property xml: WideString read Get_xml;
    property internal_identity: Integer read Get_internal_identity;
    property namespaceURI: WideString read Get_namespaceURI;
    property prefix: WideString read Get_prefix write Set_prefix;
    property baseName: WideString read Get_baseName write Set_baseName;
    property nodeValueEx: OleVariant read Get_nodeValueEx write Set_nodeValueEx;
  end;

// *********************************************************************//
// DispIntf:  IXMLDOMNodeDisp
// Flags:     (4544) Dual NonExtensible OleAutomation Dispatchable
// GUID:      {475BD672-F1DA-11D2-BD4B-0060086EBD80}
// *********************************************************************//
  IXMLDOMNodeDisp = dispinterface
    ['{475BD672-F1DA-11D2-BD4B-0060086EBD80}']
    property nodeName: WideString readonly dispid 1;
    property nodeValue: WideString dispid 0;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property nodeType: eDOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    procedure appendChild(const newChild: IXMLDOMNode); dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; const refChild: IXMLDOMNode): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    property text: WideString dispid 27;
    property xml: WideString readonly dispid 157;
    property internal_identity: Integer readonly dispid 50;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 198;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString dispid 33;
    property baseName: WideString dispid 34;
    property nodeValueEx: OleVariant dispid 199;
    function evalExpression(const sExpression: WideString): WordBool; dispid 200;
  end;

// *********************************************************************//
// Interface: IXMLDOMDocument
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E96FC481-F1C2-11D2-BD4B-0060086EBD80}
// *********************************************************************//
  IXMLDOMDocument = interface(IXMLDOMNode)
    ['{E96FC481-F1C2-11D2-BD4B-0060086EBD80}']
    function load(const xmlSource: WideString): WordBool; safecall;
    procedure save(const xmlDest: WideString); safecall;
    function Get_documentElement: IXMLDOMElement; safecall;
    function createElement(const tagName: WideString): IXMLDOMElement; safecall;
    function createTextNode(const data: WideString): IXMLDOMText; safecall;
    function createComment(const data: WideString): IXMLDOMComment; safecall;
    function createProcessingInstruction(const target: WideString; const data: WideString): IXMLDOMProcessingInstruction; safecall;
    function createCDATASection(const data: WideString): IXMLDOMCDATASection; safecall;
    function createEntityReference(const name: WideString): IXMLDOMEntityReference; safecall;
    function Get_parseError: IXMLDOMParseError; safecall;
    function createAttribute(const name: WideString): IXMLDOMAttribute; safecall;
    function getElementsByTagName(const tagName: WideString): IXMLDOMNodeList; safecall;
    function Get_validateOnParse: WordBool; safecall;
    procedure Set_validateOnParse(isValidating: WordBool); safecall;
    function loadXML(const bstrXML: WideString): WordBool; safecall;
    procedure setFeature(const name: WideString; const value: WideString); safecall;
    function loadEx(xmlSource: OleVariant): WordBool; safecall;
    function saveEx(xmlSource: OleVariant): WordBool; safecall;
    function createElementNS(const URI: WideString; const qualifiedName: WideString): IXMLDOMElement; safecall;
    function createAttributeNS(const URI: WideString; const qualifiedName: WideString): IXMLDOMAttribute; safecall;
    function getElementsByTagNameNS(const URI: WideString; const localName: WideString): IXMLDOMNodeList; safecall;
    property documentElement: IXMLDOMElement read Get_documentElement;
    property parseError: IXMLDOMParseError read Get_parseError;
    property validateOnParse: WordBool read Get_validateOnParse write Set_validateOnParse;
  end;

// *********************************************************************//
// DispIntf:  IXMLDOMDocumentDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E96FC481-F1C2-11D2-BD4B-0060086EBD80}
// *********************************************************************//
  IXMLDOMDocumentDisp = dispinterface
    ['{E96FC481-F1C2-11D2-BD4B-0060086EBD80}']
    function load(const xmlSource: WideString): WordBool; dispid 100;
    procedure save(const xmlDest: WideString); dispid 101;
    property documentElement: IXMLDOMElement readonly dispid 102;
    function createElement(const tagName: WideString): IXMLDOMElement; dispid 103;
    function createTextNode(const data: WideString): IXMLDOMText; dispid 104;
    function createComment(const data: WideString): IXMLDOMComment; dispid 105;
    function createProcessingInstruction(const target: WideString; const data: WideString): IXMLDOMProcessingInstruction; dispid 106;
    function createCDATASection(const data: WideString): IXMLDOMCDATASection; dispid 107;
    function createEntityReference(const name: WideString): IXMLDOMEntityReference; dispid 108;
    property parseError: IXMLDOMParseError readonly dispid 109;
    function createAttribute(const name: WideString): IXMLDOMAttribute; dispid 110;
    function getElementsByTagName(const tagName: WideString): IXMLDOMNodeList; dispid 112;
    property validateOnParse: WordBool dispid 113;
    function loadXML(const bstrXML: WideString): WordBool; dispid 114;
    procedure setFeature(const name: WideString; const value: WideString); dispid 115;
    function loadEx(xmlSource: OleVariant): WordBool; dispid 116;
    function saveEx(xmlSource: OleVariant): WordBool; dispid 117;
    function createElementNS(const URI: WideString; const qualifiedName: WideString): IXMLDOMElement; dispid 118;
    function createAttributeNS(const URI: WideString; const qualifiedName: WideString): IXMLDOMAttribute; dispid 119;
    function getElementsByTagNameNS(const URI: WideString; const localName: WideString): IXMLDOMNodeList; dispid 120;
    property nodeName: WideString readonly dispid 1;
    property nodeValue: WideString dispid 0;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property nodeType: eDOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    procedure appendChild(const newChild: IXMLDOMNode); dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; const refChild: IXMLDOMNode): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    property text: WideString dispid 27;
    property xml: WideString readonly dispid 157;
    property internal_identity: Integer readonly dispid 50;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 198;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString dispid 33;
    property baseName: WideString dispid 34;
    property nodeValueEx: OleVariant dispid 199;
    function evalExpression(const sExpression: WideString): WordBool; dispid 200;
  end;

// *********************************************************************//
// Interface: IXMLDOMNodeList
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A1E33EE4-F696-11D2-B883-000000000000}
// *********************************************************************//
  IXMLDOMNodeList = interface(IDispatch)
    ['{A1E33EE4-F696-11D2-B883-000000000000}']
    function Get_item(index: Integer): IXMLDOMNode; safecall;
    function Get_length: Integer; safecall;
    function nextNode: IXMLDOMNode; safecall;
    procedure reset; safecall;
    property item[index: Integer]: IXMLDOMNode read Get_item; default;
    property length: Integer read Get_length;
  end;

// *********************************************************************//
// DispIntf:  IXMLDOMNodeListDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A1E33EE4-F696-11D2-B883-000000000000}
// *********************************************************************//
  IXMLDOMNodeListDisp = dispinterface
    ['{A1E33EE4-F696-11D2-B883-000000000000}']
    property item[index: Integer]: IXMLDOMNode readonly dispid 0; default;
    property length: Integer readonly dispid 1;
    function nextNode: IXMLDOMNode; dispid 76;
    procedure reset; dispid 77;
  end;

// *********************************************************************//
// Interface: IXMLDOMNamedNodeMap
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1BB05524-F5D5-11D2-B881-000000000000}
// *********************************************************************//
  IXMLDOMNamedNodeMap = interface(IDispatch)
    ['{1BB05524-F5D5-11D2-B881-000000000000}']
    function getNamedItem(const name: WideString): IXMLDOMNode; safecall;
    function setNamedItem(const newItem: IXMLDOMNode): IXMLDOMNode; safecall;
    function removeNamedItem(const name: WideString): IXMLDOMNode; safecall;
    function Get_item(index: Integer): IXMLDOMNode; safecall;
    function Get_length: Integer; safecall;
    function getNamedItemNS(const namespaceURI: WideString; const localName: WideString): IXMLDOMNode; safecall;
    function setNamedItemNS(const newItem: IXMLDOMNode): IXMLDOMNode; safecall;
    function removeNamedItemNS(const namespaceURI: WideString; const localName: WideString): IXMLDOMNode; safecall;
    property item[index: Integer]: IXMLDOMNode read Get_item; default;
    property length: Integer read Get_length;
  end;

// *********************************************************************//
// DispIntf:  IXMLDOMNamedNodeMapDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1BB05524-F5D5-11D2-B881-000000000000}
// *********************************************************************//
  IXMLDOMNamedNodeMapDisp = dispinterface
    ['{1BB05524-F5D5-11D2-B881-000000000000}']
    function getNamedItem(const name: WideString): IXMLDOMNode; dispid 1;
    function setNamedItem(const newItem: IXMLDOMNode): IXMLDOMNode; dispid 2;
    function removeNamedItem(const name: WideString): IXMLDOMNode; dispid 3;
    property item[index: Integer]: IXMLDOMNode readonly dispid 0; default;
    property length: Integer readonly dispid 4;
    function getNamedItemNS(const namespaceURI: WideString; const localName: WideString): IXMLDOMNode; dispid 6;
    function setNamedItemNS(const newItem: IXMLDOMNode): IXMLDOMNode; dispid 7;
    function removeNamedItemNS(const namespaceURI: WideString; const localName: WideString): IXMLDOMNode; dispid 8;
  end;

// *********************************************************************//
// Interface: IXMLDOMElement
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8B105E8F-F1D9-11D2-BD4B-0060086EBD80}
// *********************************************************************//
  IXMLDOMElement = interface(IXMLDOMNode)
    ['{8B105E8F-F1D9-11D2-BD4B-0060086EBD80}']
    function Get_tagName: WideString; safecall;
    function getAttribute(const name: WideString): WideString; safecall;
    procedure setAttribute(const name: WideString; const value: WideString); safecall;
    function getElementsByTagName(const tagName: WideString): IXMLDOMNodeList; safecall;
    procedure removeAttribute(const name: WideString); safecall;
    function getAttributeNode(const name: WideString): IXMLDOMAttribute; safecall;
    function setAttributeNode(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; safecall;
    function removeAttributeNode(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; safecall;
    procedure normalize; safecall;
    function supports(const feature: WideString; const version: WideString): WordBool; safecall;
    function getAttributeNS(const namespaceURI: WideString; const localName: WideString): WideString; safecall;
    procedure setAttributeNS(const namespaceURI: WideString; const qualifiedName: WideString; 
                             const value: WideString); safecall;
    function getElementsByTagNameNS(const namespaceURI: WideString; const localName: WideString): IXMLDOMNodeList; safecall;
    procedure removeAttributeNS(const namespaceURI: WideString; const localName: WideString); safecall;
    function getAttributeNodeNS(const namespaceURI: WideString; const localName: WideString): IXMLDOMAttribute; safecall;
    function setAttributeNodeNS(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; safecall;
    function removeAttributeNodeNS(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; safecall;
    function hasAttribute(const rawName: WideString): WordBool; safecall;
    function hasAttributeNS(const namespaceURI: WideString; const localName: WideString): WordBool; safecall;
    property tagName: WideString read Get_tagName;
  end;

// *********************************************************************//
// DispIntf:  IXMLDOMElementDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {8B105E8F-F1D9-11D2-BD4B-0060086EBD80}
// *********************************************************************//
  IXMLDOMElementDisp = dispinterface
    ['{8B105E8F-F1D9-11D2-BD4B-0060086EBD80}']
    property tagName: WideString readonly dispid 1000;
    function getAttribute(const name: WideString): WideString; dispid 1001;
    procedure setAttribute(const name: WideString; const value: WideString); dispid 1002;
    function getElementsByTagName(const tagName: WideString): IXMLDOMNodeList; dispid 1003;
    procedure removeAttribute(const name: WideString); dispid 1004;
    function getAttributeNode(const name: WideString): IXMLDOMAttribute; dispid 1005;
    function setAttributeNode(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; dispid 1006;
    function removeAttributeNode(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; dispid 1007;
    procedure normalize; dispid 1008;
    function supports(const feature: WideString; const version: WideString): WordBool; dispid 1009;
    function getAttributeNS(const namespaceURI: WideString; const localName: WideString): WideString; dispid 1010;
    procedure setAttributeNS(const namespaceURI: WideString; const qualifiedName: WideString; 
                             const value: WideString); dispid 1011;
    function getElementsByTagNameNS(const namespaceURI: WideString; const localName: WideString): IXMLDOMNodeList; dispid 1012;
    procedure removeAttributeNS(const namespaceURI: WideString; const localName: WideString); dispid 1013;
    function getAttributeNodeNS(const namespaceURI: WideString; const localName: WideString): IXMLDOMAttribute; dispid 1014;
    function setAttributeNodeNS(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; dispid 1015;
    function removeAttributeNodeNS(const DOMAttribute: IXMLDOMAttribute): IXMLDOMAttribute; dispid 1016;
    function hasAttribute(const rawName: WideString): WordBool; dispid 1017;
    function hasAttributeNS(const namespaceURI: WideString; const localName: WideString): WordBool; dispid 1018;
    property nodeName: WideString readonly dispid 1;
    property nodeValue: WideString dispid 0;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property nodeType: eDOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    procedure appendChild(const newChild: IXMLDOMNode); dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; const refChild: IXMLDOMNode): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    property text: WideString dispid 27;
    property xml: WideString readonly dispid 157;
    property internal_identity: Integer readonly dispid 50;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 198;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString dispid 33;
    property baseName: WideString dispid 34;
    property nodeValueEx: OleVariant dispid 199;
    function evalExpression(const sExpression: WideString): WordBool; dispid 200;
  end;

// *********************************************************************//
// Interface: IXMLDOMAttribute
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1BB05526-F5D5-11D2-B881-000000000000}
// *********************************************************************//
  IXMLDOMAttribute = interface(IXMLDOMNode)
    ['{1BB05526-F5D5-11D2-B881-000000000000}']
    function Get_name: WideString; safecall;
    function Get_value: WideString; safecall;
    procedure Set_value(const attributeValue: WideString); safecall;
    function Get_specified: WordBool; safecall;
    function Get_ownerElement: IXMLDOMElement; safecall;
    property name: WideString read Get_name;
    property value: WideString read Get_value write Set_value;
    property specified: WordBool read Get_specified;
    property ownerElement: IXMLDOMElement read Get_ownerElement;
  end;

// *********************************************************************//
// DispIntf:  IXMLDOMAttributeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {1BB05526-F5D5-11D2-B881-000000000000}
// *********************************************************************//
  IXMLDOMAttributeDisp = dispinterface
    ['{1BB05526-F5D5-11D2-B881-000000000000}']
    property name: WideString readonly dispid 118;
    property value: WideString dispid 120;
    property specified: WordBool readonly dispid 121;
    property ownerElement: IXMLDOMElement readonly dispid 122;
    property nodeName: WideString readonly dispid 1;
    property nodeValue: WideString dispid 0;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property nodeType: eDOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    procedure appendChild(const newChild: IXMLDOMNode); dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; const refChild: IXMLDOMNode): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    property text: WideString dispid 27;
    property xml: WideString readonly dispid 157;
    property internal_identity: Integer readonly dispid 50;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 198;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString dispid 33;
    property baseName: WideString dispid 34;
    property nodeValueEx: OleVariant dispid 199;
    function evalExpression(const sExpression: WideString): WordBool; dispid 200;
  end;

// *********************************************************************//
// Interface: IXMLDOMCharacterData
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C6A8CF0-F4B8-11D2-B880-000000000000}
// *********************************************************************//
  IXMLDOMCharacterData = interface(IXMLDOMNode)
    ['{6C6A8CF0-F4B8-11D2-B880-000000000000}']
    function Get_data: WideString; safecall;
    procedure Set_data(const data: WideString); safecall;
    function Get_length: Integer; safecall;
    function substringData(offset: Integer; count: Integer): WideString; safecall;
    procedure appendData(const data: WideString); safecall;
    procedure insertData(offset: Integer; const data: WideString); safecall;
    procedure deleteData(offset: Integer; count: Integer); safecall;
    procedure replaceData(offset: Integer; count: Integer; const data: WideString); safecall;
    property data: WideString read Get_data write Set_data;
    property length: Integer read Get_length;
  end;

// *********************************************************************//
// DispIntf:  IXMLDOMCharacterDataDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6C6A8CF0-F4B8-11D2-B880-000000000000}
// *********************************************************************//
  IXMLDOMCharacterDataDisp = dispinterface
    ['{6C6A8CF0-F4B8-11D2-B880-000000000000}']
    property data: WideString dispid 5000;
    property length: Integer readonly dispid 5001;
    function substringData(offset: Integer; count: Integer): WideString; dispid 5002;
    procedure appendData(const data: WideString); dispid 5003;
    procedure insertData(offset: Integer; const data: WideString); dispid 5004;
    procedure deleteData(offset: Integer; count: Integer); dispid 5005;
    procedure replaceData(offset: Integer; count: Integer; const data: WideString); dispid 5006;
    property nodeName: WideString readonly dispid 1;
    property nodeValue: WideString dispid 0;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property nodeType: eDOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    procedure appendChild(const newChild: IXMLDOMNode); dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; const refChild: IXMLDOMNode): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    property text: WideString dispid 27;
    property xml: WideString readonly dispid 157;
    property internal_identity: Integer readonly dispid 50;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 198;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString dispid 33;
    property baseName: WideString dispid 34;
    property nodeValueEx: OleVariant dispid 199;
    function evalExpression(const sExpression: WideString): WordBool; dispid 200;
  end;

// *********************************************************************//
// Interface: IXMLDOMText
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CECC2F33-F1EB-11D2-B87A-000000000000}
// *********************************************************************//
  IXMLDOMText = interface(IXMLDOMCharacterData)
    ['{CECC2F33-F1EB-11D2-B87A-000000000000}']
  end;

// *********************************************************************//
// DispIntf:  IXMLDOMTextDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CECC2F33-F1EB-11D2-B87A-000000000000}
// *********************************************************************//
  IXMLDOMTextDisp = dispinterface
    ['{CECC2F33-F1EB-11D2-B87A-000000000000}']
    property data: WideString dispid 5000;
    property length: Integer readonly dispid 5001;
    function substringData(offset: Integer; count: Integer): WideString; dispid 5002;
    procedure appendData(const data: WideString); dispid 5003;
    procedure insertData(offset: Integer; const data: WideString); dispid 5004;
    procedure deleteData(offset: Integer; count: Integer); dispid 5005;
    procedure replaceData(offset: Integer; count: Integer; const data: WideString); dispid 5006;
    property nodeName: WideString readonly dispid 1;
    property nodeValue: WideString dispid 0;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property nodeType: eDOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    procedure appendChild(const newChild: IXMLDOMNode); dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; const refChild: IXMLDOMNode): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    property text: WideString dispid 27;
    property xml: WideString readonly dispid 157;
    property internal_identity: Integer readonly dispid 50;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 198;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString dispid 33;
    property baseName: WideString dispid 34;
    property nodeValueEx: OleVariant dispid 199;
    function evalExpression(const sExpression: WideString): WordBool; dispid 200;
  end;

// *********************************************************************//
// Interface: IXMLDOMComment
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9056DD06-F4AF-11D2-B880-000000000000}
// *********************************************************************//
  IXMLDOMComment = interface(IXMLDOMCharacterData)
    ['{9056DD06-F4AF-11D2-B880-000000000000}']
  end;

// *********************************************************************//
// DispIntf:  IXMLDOMCommentDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {9056DD06-F4AF-11D2-B880-000000000000}
// *********************************************************************//
  IXMLDOMCommentDisp = dispinterface
    ['{9056DD06-F4AF-11D2-B880-000000000000}']
    property data: WideString dispid 5000;
    property length: Integer readonly dispid 5001;
    function substringData(offset: Integer; count: Integer): WideString; dispid 5002;
    procedure appendData(const data: WideString); dispid 5003;
    procedure insertData(offset: Integer; const data: WideString); dispid 5004;
    procedure deleteData(offset: Integer; count: Integer); dispid 5005;
    procedure replaceData(offset: Integer; count: Integer; const data: WideString); dispid 5006;
    property nodeName: WideString readonly dispid 1;
    property nodeValue: WideString dispid 0;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property nodeType: eDOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    procedure appendChild(const newChild: IXMLDOMNode); dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; const refChild: IXMLDOMNode): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    property text: WideString dispid 27;
    property xml: WideString readonly dispid 157;
    property internal_identity: Integer readonly dispid 50;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 198;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString dispid 33;
    property baseName: WideString dispid 34;
    property nodeValueEx: OleVariant dispid 199;
    function evalExpression(const sExpression: WideString): WordBool; dispid 200;
  end;

// *********************************************************************//
// Interface: IXMLDOMProcessingInstruction
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {553024C3-F4F9-11D2-B880-000000000000}
// *********************************************************************//
  IXMLDOMProcessingInstruction = interface(IXMLDOMNode)
    ['{553024C3-F4F9-11D2-B880-000000000000}']
    function Get_target: WideString; safecall;
    function Get_data: WideString; safecall;
    procedure Set_data(const value: WideString); safecall;
    property target: WideString read Get_target;
    property data: WideString read Get_data write Set_data;
  end;

// *********************************************************************//
// DispIntf:  IXMLDOMProcessingInstructionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {553024C3-F4F9-11D2-B880-000000000000}
// *********************************************************************//
  IXMLDOMProcessingInstructionDisp = dispinterface
    ['{553024C3-F4F9-11D2-B880-000000000000}']
    property target: WideString readonly dispid 127;
    property data: WideString dispid 128;
    property nodeName: WideString readonly dispid 1;
    property nodeValue: WideString dispid 0;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property nodeType: eDOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    procedure appendChild(const newChild: IXMLDOMNode); dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; const refChild: IXMLDOMNode): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    property text: WideString dispid 27;
    property xml: WideString readonly dispid 157;
    property internal_identity: Integer readonly dispid 50;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 198;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString dispid 33;
    property baseName: WideString dispid 34;
    property nodeValueEx: OleVariant dispid 199;
    function evalExpression(const sExpression: WideString): WordBool; dispid 200;
  end;

// *********************************************************************//
// Interface: IXMLDOMCDATASection
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {261683F3-F56E-11D2-B881-000000000000}
// *********************************************************************//
  IXMLDOMCDATASection = interface(IXMLDOMText)
    ['{261683F3-F56E-11D2-B881-000000000000}']
  end;

// *********************************************************************//
// DispIntf:  IXMLDOMCDATASectionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {261683F3-F56E-11D2-B881-000000000000}
// *********************************************************************//
  IXMLDOMCDATASectionDisp = dispinterface
    ['{261683F3-F56E-11D2-B881-000000000000}']
    property data: WideString dispid 5000;
    property length: Integer readonly dispid 5001;
    function substringData(offset: Integer; count: Integer): WideString; dispid 5002;
    procedure appendData(const data: WideString); dispid 5003;
    procedure insertData(offset: Integer; const data: WideString); dispid 5004;
    procedure deleteData(offset: Integer; count: Integer); dispid 5005;
    procedure replaceData(offset: Integer; count: Integer; const data: WideString); dispid 5006;
    property nodeName: WideString readonly dispid 1;
    property nodeValue: WideString dispid 0;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property nodeType: eDOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    procedure appendChild(const newChild: IXMLDOMNode); dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; const refChild: IXMLDOMNode): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    property text: WideString dispid 27;
    property xml: WideString readonly dispid 157;
    property internal_identity: Integer readonly dispid 50;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 198;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString dispid 33;
    property baseName: WideString dispid 34;
    property nodeValueEx: OleVariant dispid 199;
    function evalExpression(const sExpression: WideString): WordBool; dispid 200;
  end;

// *********************************************************************//
// Interface: IXMLDOMEntityReference
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {261683F5-F56E-11D2-B881-000000000000}
// *********************************************************************//
  IXMLDOMEntityReference = interface(IXMLDOMNode)
    ['{261683F5-F56E-11D2-B881-000000000000}']
  end;

// *********************************************************************//
// DispIntf:  IXMLDOMEntityReferenceDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {261683F5-F56E-11D2-B881-000000000000}
// *********************************************************************//
  IXMLDOMEntityReferenceDisp = dispinterface
    ['{261683F5-F56E-11D2-B881-000000000000}']
    property nodeName: WideString readonly dispid 1;
    property nodeValue: WideString dispid 0;
    property firstChild: IXMLDOMNode readonly dispid 8;
    property lastChild: IXMLDOMNode readonly dispid 9;
    property nodeType: eDOMNodeType readonly dispid 4;
    property parentNode: IXMLDOMNode readonly dispid 6;
    property childNodes: IXMLDOMNodeList readonly dispid 7;
    property previousSibling: IXMLDOMNode readonly dispid 10;
    property nextSibling: IXMLDOMNode readonly dispid 11;
    procedure appendChild(const newChild: IXMLDOMNode); dispid 16;
    function hasChildNodes: WordBool; dispid 17;
    property ownerDocument: IXMLDOMDocument readonly dispid 18;
    property attributes: IXMLDOMNamedNodeMap readonly dispid 12;
    function insertBefore(const newChild: IXMLDOMNode; const refChild: IXMLDOMNode): IXMLDOMNode; dispid 13;
    function replaceChild(const newChild: IXMLDOMNode; const oldChild: IXMLDOMNode): IXMLDOMNode; dispid 14;
    function removeChild(const childNode: IXMLDOMNode): IXMLDOMNode; dispid 15;
    property text: WideString dispid 27;
    property xml: WideString readonly dispid 157;
    property internal_identity: Integer readonly dispid 50;
    function selectSingleNode(const queryString: WideString): IXMLDOMNode; dispid 30;
    function selectNodes(const queryString: WideString): IXMLDOMNodeList; dispid 198;
    property namespaceURI: WideString readonly dispid 32;
    property prefix: WideString dispid 33;
    property baseName: WideString dispid 34;
    property nodeValueEx: OleVariant dispid 199;
    function evalExpression(const sExpression: WideString): WordBool; dispid 200;
  end;

// *********************************************************************//
// Interface: IXMLDOMParseError
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {261683F7-F56E-11D2-B881-000000000000}
// *********************************************************************//
  IXMLDOMParseError = interface(IDispatch)
    ['{261683F7-F56E-11D2-B881-000000000000}']
    function Get_reason: WideString; safecall;
    function Get_line: Integer; safecall;
    function Get_linepos: Integer; safecall;
    function Get_errorCode: Integer; safecall;
    function Get_url: WideString; safecall;
    property reason: WideString read Get_reason;
    property line: Integer read Get_line;
    property linepos: Integer read Get_linepos;
    property errorCode: Integer read Get_errorCode;
    property url: WideString read Get_url;
  end;

// *********************************************************************//
// DispIntf:  IXMLDOMParseErrorDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {261683F7-F56E-11D2-B881-000000000000}
// *********************************************************************//
  IXMLDOMParseErrorDisp = dispinterface
    ['{261683F7-F56E-11D2-B881-000000000000}']
    property reason: WideString readonly dispid 1;
    property line: Integer readonly dispid 2;
    property linepos: Integer readonly dispid 3;
    property errorCode: Integer readonly dispid 0;
    property url: WideString readonly dispid 4;
  end;

// *********************************************************************//
// Interface: IXSLTEngine
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4F79E12E-A9B9-47FF-8F37-BA520FF067FD}
// *********************************************************************//
  IXSLTEngine = interface(IDispatch)
    ['{4F79E12E-A9B9-47FF-8F37-BA520FF067FD}']
    function transformDoc(const sourceTree: IXMLDOMDocument; const stylesheet: IXMLDOMDocument): IXMLDOMDocument; safecall;
  end;

// *********************************************************************//
// DispIntf:  IXSLTEngineDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4F79E12E-A9B9-47FF-8F37-BA520FF067FD}
// *********************************************************************//
  IXSLTEngineDisp = dispinterface
    ['{4F79E12E-A9B9-47FF-8F37-BA520FF067FD}']
    function transformDoc(const sourceTree: IXMLDOMDocument; const stylesheet: IXMLDOMDocument): IXMLDOMDocument; dispid 1;
  end;

  CoDOMDocument = class
    class function Create: IXMLDOMDocument;
    class function CreateRemote(const MachineName: string): IXMLDOMDocument;
  end;

  CoXSLTEngine = class
    class function Create: IXSLTEngine;
    class function CreateRemote(const MachineName: string): IXSLTEngine;
  end;

implementation

uses ComObj;

class function CoDOMDocument.Create: IXMLDOMDocument;
begin
  Result := CreateComObject(CLASS_DOMDocument) as IXMLDOMDocument;
end;

class function CoDOMDocument.CreateRemote(const MachineName: string): IXMLDOMDocument;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DOMDocument) as IXMLDOMDocument;
end;

class function CoXSLTEngine.Create: IXSLTEngine;
begin
  Result := CreateComObject(CLASS_XSLTEngine) as IXSLTEngine;
end;

class function CoXSLTEngine.CreateRemote(const MachineName: string): IXSLTEngine;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_XSLTEngine) as IXSLTEngine;
end;

end.
