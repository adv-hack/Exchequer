unit EnterpriseDBF_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision:   1.130.3.0.1.0  $
// File generated on 16-04-2002 17:07:32 from Type Library described below.

// ************************************************************************  //
// Type Lib: X:\ENTRPRSE\REPWRT\DBF\DBFWRITE.tlb (1)
// LIBID: {3BDEF7B4-4C61-4E42-BA0D-F2441D84B32C}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}

interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  EnterpriseDBFMajorVersion = 1;
  EnterpriseDBFMinorVersion = 0;

  LIBID_EnterpriseDBF: TGUID = '{3BDEF7B4-4C61-4E42-BA0D-F2441D84B32C}';

  IID_IDBFWriter: TGUID = '{BC4F2F3C-7304-4B8F-AE6A-3DCC4D6FEC64}';
  CLASS_DBFWriter: TGUID = '{48112D20-34AE-49EF-B894-998E6B336BC2}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IDBFWriter = interface;
  IDBFWriterDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  DBFWriter = IDBFWriter;


// *********************************************************************//
// Interface: IDBFWriter
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BC4F2F3C-7304-4B8F-AE6A-3DCC4D6FEC64}
// *********************************************************************//
  IDBFWriter = interface(IDispatch)
    ['{BC4F2F3C-7304-4B8F-AE6A-3DCC4D6FEC64}']
    function Get_Filename: WideString; safecall;
    procedure Set_Filename(const Value: WideString); safecall;
    function CreateFile(const FileDef: WideString): Smallint; safecall;
    procedure SetFieldValue(FieldNo: Integer; const Value: WideString); safecall;
    procedure CloseFile; safecall;
    procedure Clear; safecall;
    procedure AddRec; safecall;
    procedure SaveRec; safecall;
    procedure AddIndex(const FieldName: WideString; IsDescending: WordBool); safecall;
    function Get_Version: WideString; safecall;
    property Filename: WideString read Get_Filename write Set_Filename;
    property Version: WideString read Get_Version;
  end;

// *********************************************************************//
// DispIntf:  IDBFWriterDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BC4F2F3C-7304-4B8F-AE6A-3DCC4D6FEC64}
// *********************************************************************//
  IDBFWriterDisp = dispinterface
    ['{BC4F2F3C-7304-4B8F-AE6A-3DCC4D6FEC64}']
    property Filename: WideString dispid 1;
    function CreateFile(const FileDef: WideString): Smallint; dispid 3;
    procedure SetFieldValue(FieldNo: Integer; const Value: WideString); dispid 4;
    procedure CloseFile; dispid 5;
    procedure Clear; dispid 2;
    procedure AddRec; dispid 6;
    procedure SaveRec; dispid 7;
    procedure AddIndex(const FieldName: WideString; IsDescending: WordBool); dispid 8;
    property Version: WideString readonly dispid 9;
  end;

// *********************************************************************//
// The Class CoDBFWriter provides a Create and CreateRemote method to          
// create instances of the default interface IDBFWriter exposed by              
// the CoClass DBFWriter. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDBFWriter = class
    class function Create: IDBFWriter;
    class function CreateRemote(const MachineName: string): IDBFWriter;
  end;

implementation

uses ComObj;

class function CoDBFWriter.Create: IDBFWriter;
begin
  Result := CreateComObject(CLASS_DBFWriter) as IDBFWriter;
end;

class function CoDBFWriter.CreateRemote(const MachineName: string): IDBFWriter;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_DBFWriter) as IDBFWriter;
end;

end.
