//////////////////////////////////////////////////////
// Wrapper Unit for common calls to the COM Toolkit //
//////////////////////////////////////////////////////

unit CTKUTIL;

{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  StdCtrls, Enterprise01_TLB, APIUtil, SysUtils, Dialogs, ComObj, SecCodes;

type
  TVATInfo = class
    rRate : real;
    cCode : string;
    constructor create(Rate : real; Code : string);
  end;

  Procedure ShowTKError(sMessage : string; iResult : integer);
  Function OpenToolkit(sDataDir : string; bUseBackDoor : boolean) : IToolkit;
  function CompanyCodeFromPath(const oToolkit : IToolkit;
                               const Path     : ShortString) : string;
  function CompanyPathFromCode(const oToolkit : IToolkit;
                               const Code     : ShortString) : string;
  function CreateToolkitWithBackdoor : IToolkit;
  procedure CopyLineProperties(const oFromLine, oToLine : ITransactionLine; Mode : Byte = 0);
  procedure CopyTransactionProperties(const oFromTrans, oToTrans : ITransaction);
  procedure CopyStockProperties(const oFromStock, oToStock : IStock);
  procedure CopyNote(oNotesFrom, oNotesTo : INotes);
  function CopyStockNotes(sStockCodeFrom, sStockCodeTo : string; oToolkit : IToolkit) : integer;
  procedure CopyBOMComponents(oFromStock, oToStock : IStock);
  procedure FillVATCombo(oToolkit : IToolkit; cmbVATRate : TComboBox);

{A separate copy of this file is now maintained to allow either Enterprise01 (now the in-proc COM
 Toolkit) or Enterprise04 (the out-of-proc COM Toolkit.) Use this file for Enterprise01 and
 CtkUtil04.pas for Enterprise04.

 The implementation section was moved into CTKUtilImplementation.inc so that it could also be used
 by CtkUtil04.pas. Any new procedures/functions added to this file should be implemented in
 CTKUtilImplementation.inc and declared also in CtkUtil04.pas}

Implementation

{uses}

const sClassName = 'Enterprise01.Toolkit';

{$I CTKUtilImplementation.inc}
end.
