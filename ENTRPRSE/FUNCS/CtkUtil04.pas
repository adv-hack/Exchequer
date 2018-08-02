//////////////////////////////////////////////////////
// Wrapper Unit for common calls to the COM Toolkit //
//////////////////////////////////////////////////////

unit CtkUtil04;

{ nfrewer440 16:35 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  StdCtrls, Enterprise04_TLB, APIUtil, SysUtils, Dialogs, ComObj, SecCodes;

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

Implementation

{uses}

const sClassName = 'Enterprise04.Toolkit';

{$I CTKUtilImplementation.inc}
end.
