unit testcons;

{ prutherford440 09:55 04/12/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface


const

  //Validation constants
  vaPath     = 0;
  vaNominal  = 1;
  vaCC       = 2;
  vaDept     = 3;
  vaVAT      = 4;
  vaCurrency = 5;
  vaUnknown  = 6;

  MaxConfigItems = 19;



  DetailLogFileName = 'ComtkLog.rtf';

  //Version = 'b500.102';     { Beta Version Number }
  //Version = 'v7.1.119';   <-- redirect to Exchequer Release
  BuildNo = '121';



  ConfigNames     :  Array[1..MaxConfigItems] of String[25] = (
                                        {01}   'Auto_Set_Period',
                                        {02}   'Default_Nominal',
                                        {03}   'Default_Cost_Centre',
                                        {04}   'Default_Department',
                                        {05}   'Default_VAT_Code',   {* 19.08.99 *}
                                        {06}   'Auto_Set_Stock_Cost',
                                        {07}   'Deduct_BOM_Stock',
                                        {08}   'Deduct_MultiLoc_Stock',
                                        {09}   'Overwrite_Trans_No',
                                        {10}   'Overwrite_Note_Pad',
                                        {11}   'Use_Ex_Currency',
                                        {12}   'Allow_Trans_Edit',
                                        {13}   //'Report_to_Printer',
                                        {14}   //'Report_to_File',
                                        {15}   'Exchequer_Path',
					{16}   'Multi_Currency',
                                        {17}   'Default_Currency',
					{18}   'Update_Account_Bal',
                                        {19}   'Update_Stock_Levels',
                                        {20}   'Ignore_JobCost_Validation',
                                        {21}   //'Last_Batch_Date'
                                        {22}   'No_Trans_To_Closed_Jobs'
                                              );


   //0 = switch, 1 = integer, 2 = string, 3 = path, 4 = date, 5 = split

  ConfigTypes : Array[1..MaxConfigItems] of byte = (0, 1, 2, 2, 6, 0, 0, 0, 0, 0,
                                                    0, 0, {5, 5,} 3, 0, 1, 0, 0, 0,
                                                    {4} 0);



function HelpString(i : integer) : string;

function TestCOMVersion : string;


implementation

uses
  ExchequerRelease;

function TestCOMVersion : string;
begin
  Result := ExchequerModuleVersion(emTestCOM, BuildNo);
end;

function HelpString(i : integer) : string;
begin
  Case i of
    1   :  Result := 'If set to ON the DLL will overwrite the period specified in ' +
                     'a Transaction Record with a period generated from the ' +
                     'Transaction''s Transaction Date. If set to OFF the period ' +
                     'in the Transaction Record is kept.';

    2   :  Result := 'This is a Nominal Code which will be used if a ' +
                     'Nominal Code specified in a record is invalid.';

    3   :  Result := 'This is a Cost Centre Code which will be used if a ' +
                     'Cost Centre specified in a record is invalid.';

    4   :  Result := 'This is a Department Code which will be used if a ' +
                     'Department specified in a record is invalid.';

    5   :  Result := 'This is a VAT code which will be used if a ' +
                     'VAT code specified in a record is invalid.';

    6   :  Result := 'If set to ON this will cause the line cost on Sales Transactions ' +
                     'to be calculated from the cost of the stock items sold. If set to ' +
                     'OFF the specified cost will be kept.';

    7   :  Result := 'If set to ON it will cause the BOM components of a stock ' +
                     'item to be deducted from stock. If set to OFF, the stock item ' +
                     'itself will be deducted.'#10#13#10#13 +
                     'NOTE: Requires Update Stock Levels to be set to ON for this ' +
                     'option to have any effect.';

    8   :  Result := 'OFF :  Don''t deduct stock from defined location.' +
                     #10#13 +
                     'ON   :  Stock from defined location will be deducted.';

    9   :  Result := 'If set to ON the transaction number is automatically generated ' +
                     'by the DLL in the same way as Exchequer ' +
                     'would generate it. If set to OFF the Transaction number ' +
                     'is specified in the transaction record.';

    10  :  Result := 'If this is set, Note lines will be deleted from database ' +
                     'and new note lines will be added.';

    11  :  Result := 'If set to ON this will cause any currency rates in record structures ' +
                     'to be overwritten with the Exchequer Currency Rates. If set to OFF ' +
                     'the currency rates in records will be kept.';

    12  :  Result := 'If set to ON users will be allowed to edit transactions added ' +
                     'through the DLL. If set to OFF they cannot edit them.';

{    13  :  Result := 'Not Currently Used';

    14  :  Result := 'Not Currently Used';}

    13  :  Result := 'This is a MS-DOS 8.3 format directory path which must point ' +
                     'to the directory containing the Exchequer Data. It must end with ' +
                     'a backslash.';

    14  :  Result := 'If you are linking to a Multi-Currency version of Exchequer ' +
                     'then this should be set to ON, otherwise set it to OFF.';

    15  :  Result := 'This is a Currency Number which will be used if a ' +
                     'Currency specified in a record is invalid. For Single ' +
                     'Currency systems this should be set to 0 (zero). For ' +
                     'Multi-Currency systems this should be set to a valid ' +
                     'currency number in the range 1-89.';

    16  : Result := 'If set to ON this will cause Customer and Supplier account ' +
                    'balances to be updated as transactions are processed. If set ' +
                    'to OFF the account balances will not be updated.';

    17  : Result := 'If set to ON this will cause stock levels to be updated by ' +
                    'transactions. If set to OFF, stock levels will not be changed.';

    18  : Result := 'OFF :  Job Code and Job Analysis Code will be validated.' +
                    #10#13 +
                    'ON   :  Ignore to validate Job Code and Job Analysis Code.';

//    21  : Result := 'To update the Bank Transactions import date.';
    19  : Result := 'If set to ON the DLL will not allow transactions to be stored ' +
                     'for jobs which have been closed';

    else
      Result := '';
  end;{Case}
end;



end.
