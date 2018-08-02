unit EntPrice_TLB;

{ prutherford440 09:49 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


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

// PASTLWTR : $Revision:   1.88.1.0.1.0  $
// File generated on 07/03/2001 15:20:29 from Type Library described below.

// ************************************************************************ //
// Type Lib: X:\EBUS2\COMPrice\ENTPRICE.tlb (1)
// IID\LCID: {6423F86A-18E6-11D3-8440-0080C83B252B}\0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, OleCtrls, StdVCL;

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  EntPriceMajorVersion = 1;
  EntPriceMinorVersion = 0;

  LIBID_EntPrice: TGUID = '{6423F86A-18E6-11D3-8440-0080C83B252B}';

  IID_IEnterprisePriceCalc: TGUID = '{6423F86B-18E6-11D3-8440-0080C83B252B}';
  CLASS_EnterprisePriceCalc: TGUID = '{6423F86D-18E6-11D3-8440-0080C83B252B}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IEnterprisePriceCalc = interface;
  IEnterprisePriceCalcDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  EnterprisePriceCalc = IEnterprisePriceCalc;


// *********************************************************************//
// Interface: IEnterprisePriceCalc
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6423F86B-18E6-11D3-8440-0080C83B252B}
// *********************************************************************//
  IEnterprisePriceCalc = interface(IDispatch)
    ['{6423F86B-18E6-11D3-8440-0080C83B252B}']
    function  CalcPrice(const Directory: WideString; const AccountCode: WideString; 
                        const StockCode: WideString; CurrencyNum: Smallint; Quantity: Double; 
                        out Price: OleVariant): Smallint; safecall;
    function  Get_TestMode: WordBool; safecall;
    procedure Set_TestMode(Value: WordBool); safecall;
    function  GetCurrency(const Directory: WideString; CurrencyNum: Smallint; 
                          out CurrencyName: OleVariant; out CurrencySymbol: OleVariant): Smallint; safecall;
    function  GetCurrencyArray(const Directory: WideString; out CurrencyArray: OleVariant): Smallint; safecall;
    function  UpdatePriceData(const UploadDir: WideString; const InstallDir: WideString; 
                              out ErrorMsg: WideString): Smallint; safecall;
    property TestMode: WordBool read Get_TestMode write Set_TestMode;
  end;

// *********************************************************************//
// DispIntf:  IEnterprisePriceCalcDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6423F86B-18E6-11D3-8440-0080C83B252B}
// *********************************************************************//
  IEnterprisePriceCalcDisp = dispinterface
    ['{6423F86B-18E6-11D3-8440-0080C83B252B}']
    function  CalcPrice(const Directory: WideString; const AccountCode: WideString; 
                        const StockCode: WideString; CurrencyNum: Smallint; Quantity: Double; 
                        out Price: OleVariant): Smallint; dispid 1;
    property TestMode: WordBool dispid 2;
    function  GetCurrency(const Directory: WideString; CurrencyNum: Smallint; 
                          out CurrencyName: OleVariant; out CurrencySymbol: OleVariant): Smallint; dispid 3;
    function  GetCurrencyArray(const Directory: WideString; out CurrencyArray: OleVariant): Smallint; dispid 4;
    function  UpdatePriceData(const UploadDir: WideString; const InstallDir: WideString; 
                              out ErrorMsg: WideString): Smallint; dispid 5;
  end;

// *********************************************************************//
// The Class CoEnterprisePriceCalc provides a Create and CreateRemote method to          
// create instances of the default interface IEnterprisePriceCalc exposed by              
// the CoClass EnterprisePriceCalc. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoEnterprisePriceCalc = class
    class function Create: IEnterprisePriceCalc;
    class function CreateRemote(const MachineName: string): IEnterprisePriceCalc;
  end;

implementation

uses ComObj;

class function CoEnterprisePriceCalc.Create: IEnterprisePriceCalc;
begin
  Result := CreateComObject(CLASS_EnterprisePriceCalc) as IEnterprisePriceCalc;
end;

class function CoEnterprisePriceCalc.CreateRemote(const MachineName: string): IEnterprisePriceCalc;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_EnterprisePriceCalc) as IEnterprisePriceCalc;
end;

end.
