unit Enterprise02_TLB;

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
// File generated on 29/05/2009 14:18:55 from Type Library described below.

// ************************************************************************  //
// Type Lib: W:\601\EBUS2\COMPRICE\ENTPRICE.tlb (1)
// LIBID: {6423F86A-18E6-11D3-8440-0080C83B252B}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINDOWS\system32\stdvcl40.dll)
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
  Enterprise02MajorVersion = 1;
  Enterprise02MinorVersion = 0;

  LIBID_Enterprise02: TGUID = '{6423F86A-18E6-11D3-8440-0080C83B252B}';

  IID_IEnterprisePriceCalc: TGUID = '{6423F86B-18E6-11D3-8440-0080C83B252B}';
  CLASS_COMPricing: TGUID = '{6423F86D-18E6-11D3-8440-0080C83B252B}';
  IID_IEnterprisePriceCalc2: TGUID = '{B67F8306-FB68-4398-B3E9-9DD3D2F6DEC9}';
  IID_IEnterprisePriceCalc3: TGUID = '{6F0A4FEC-7E18-4E78-98B3-71A5EE6533D0}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IEnterprisePriceCalc = interface;
  IEnterprisePriceCalcDisp = dispinterface;
  IEnterprisePriceCalc2 = interface;
  IEnterprisePriceCalc2Disp = dispinterface;
  IEnterprisePriceCalc3 = interface;
  IEnterprisePriceCalc3Disp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  COMPricing = IEnterprisePriceCalc;


// *********************************************************************//
// Interface: IEnterprisePriceCalc
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6423F86B-18E6-11D3-8440-0080C83B252B}
// *********************************************************************//
  IEnterprisePriceCalc = interface(IDispatch)
    ['{6423F86B-18E6-11D3-8440-0080C83B252B}']
    function CalcPrice(const Directory: WideString; const AccountCode: WideString; 
                       const StockCode: WideString; CurrencyNum: Smallint; Quantity: Double; 
                       out Price: OleVariant): Smallint; safecall;
    function Get_TestMode: WordBool; safecall;
    procedure Set_TestMode(Value: WordBool); safecall;
    function GetCurrency(const Directory: WideString; CurrencyNum: Smallint; 
                         out CurrencyName: OleVariant; out CurrencySymbol: OleVariant): Smallint; safecall;
    function GetCurrencyArray(const Directory: WideString; out CurrencyArray: OleVariant): Smallint; safecall;
    function UpdatePriceData(const UploadDir: WideString; const InstallDir: WideString; 
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
    function CalcPrice(const Directory: WideString; const AccountCode: WideString; 
                       const StockCode: WideString; CurrencyNum: Smallint; Quantity: Double; 
                       out Price: OleVariant): Smallint; dispid 1;
    property TestMode: WordBool dispid 2;
    function GetCurrency(const Directory: WideString; CurrencyNum: Smallint; 
                         out CurrencyName: OleVariant; out CurrencySymbol: OleVariant): Smallint; dispid 3;
    function GetCurrencyArray(const Directory: WideString; out CurrencyArray: OleVariant): Smallint; dispid 4;
    function UpdatePriceData(const UploadDir: WideString; const InstallDir: WideString; 
                             out ErrorMsg: WideString): Smallint; dispid 5;
  end;

// *********************************************************************//
// Interface: IEnterprisePriceCalc2
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B67F8306-FB68-4398-B3E9-9DD3D2F6DEC9}
// *********************************************************************//
  IEnterprisePriceCalc2 = interface(IEnterprisePriceCalc)
    ['{B67F8306-FB68-4398-B3E9-9DD3D2F6DEC9}']
    function Get_UseLocation: WordBool; safecall;
    procedure Set_UseLocation(Value: WordBool); safecall;
    function Get_DefaultLocation: WideString; safecall;
    procedure Set_DefaultLocation(const Value: WideString); safecall;
    property UseLocation: WordBool read Get_UseLocation write Set_UseLocation;
    property DefaultLocation: WideString read Get_DefaultLocation write Set_DefaultLocation;
  end;

// *********************************************************************//
// DispIntf:  IEnterprisePriceCalc2Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B67F8306-FB68-4398-B3E9-9DD3D2F6DEC9}
// *********************************************************************//
  IEnterprisePriceCalc2Disp = dispinterface
    ['{B67F8306-FB68-4398-B3E9-9DD3D2F6DEC9}']
    property UseLocation: WordBool dispid 6;
    property DefaultLocation: WideString dispid 7;
    function CalcPrice(const Directory: WideString; const AccountCode: WideString; 
                       const StockCode: WideString; CurrencyNum: Smallint; Quantity: Double; 
                       out Price: OleVariant): Smallint; dispid 1;
    property TestMode: WordBool dispid 2;
    function GetCurrency(const Directory: WideString; CurrencyNum: Smallint; 
                         out CurrencyName: OleVariant; out CurrencySymbol: OleVariant): Smallint; dispid 3;
    function GetCurrencyArray(const Directory: WideString; out CurrencyArray: OleVariant): Smallint; dispid 4;
    function UpdatePriceData(const UploadDir: WideString; const InstallDir: WideString; 
                             out ErrorMsg: WideString): Smallint; dispid 5;
  end;

// *********************************************************************//
// Interface: IEnterprisePriceCalc3
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6F0A4FEC-7E18-4E78-98B3-71A5EE6533D0}
// *********************************************************************//
  IEnterprisePriceCalc3 = interface(IEnterprisePriceCalc2)
    ['{6F0A4FEC-7E18-4E78-98B3-71A5EE6533D0}']
    function Get_UseMultiBuys: WordBool; safecall;
    procedure Set_UseMultiBuys(Value: WordBool); safecall;
    function GetValueBasedDiscount(const Directory: WideString; const AccountCode: WideString; 
                                   Currency: Smallint; TransactionValue: Double; 
                                   out DiscountValue: OleVariant; out DiscountFlag: OleVariant): Smallint; safecall;
    property UseMultiBuys: WordBool read Get_UseMultiBuys write Set_UseMultiBuys;
  end;

// *********************************************************************//
// DispIntf:  IEnterprisePriceCalc3Disp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6F0A4FEC-7E18-4E78-98B3-71A5EE6533D0}
// *********************************************************************//
  IEnterprisePriceCalc3Disp = dispinterface
    ['{6F0A4FEC-7E18-4E78-98B3-71A5EE6533D0}']
    property UseMultiBuys: WordBool dispid 8;
    function GetValueBasedDiscount(const Directory: WideString; const AccountCode: WideString; 
                                   Currency: Smallint; TransactionValue: Double; 
                                   out DiscountValue: OleVariant; out DiscountFlag: OleVariant): Smallint; dispid 9;
    property UseLocation: WordBool dispid 6;
    property DefaultLocation: WideString dispid 7;
    function CalcPrice(const Directory: WideString; const AccountCode: WideString; 
                       const StockCode: WideString; CurrencyNum: Smallint; Quantity: Double; 
                       out Price: OleVariant): Smallint; dispid 1;
    property TestMode: WordBool dispid 2;
    function GetCurrency(const Directory: WideString; CurrencyNum: Smallint; 
                         out CurrencyName: OleVariant; out CurrencySymbol: OleVariant): Smallint; dispid 3;
    function GetCurrencyArray(const Directory: WideString; out CurrencyArray: OleVariant): Smallint; dispid 4;
    function UpdatePriceData(const UploadDir: WideString; const InstallDir: WideString; 
                             out ErrorMsg: WideString): Smallint; dispid 5;
  end;

// *********************************************************************//
// The Class CoCOMPricing provides a Create and CreateRemote method to          
// create instances of the default interface IEnterprisePriceCalc exposed by              
// the CoClass COMPricing. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCOMPricing = class
    class function Create: IEnterprisePriceCalc;
    class function CreateRemote(const MachineName: string): IEnterprisePriceCalc;
  end;

implementation

uses ComObj;

class function CoCOMPricing.Create: IEnterprisePriceCalc;
begin
  Result := CreateComObject(CLASS_COMPricing) as IEnterprisePriceCalc;
end;

class function CoCOMPricing.CreateRemote(const MachineName: string): IEnterprisePriceCalc;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_COMPricing) as IEnterprisePriceCalc;
end;

end.
