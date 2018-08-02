unit DictRecord;

{ nfrewer440 11:48 26/08/2004: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface
uses
  BTUtil, GlobVar;

const
  NoOfDataTypes = 12;
  aDataTypeDesc : array [1..NoOfDataTypes] of string = ('String', 'Real'
  , 'Double', 'Date', 'Character' , 'LongInt', 'Integer', 'Byte', 'Currency'
  , 'Period', 'Yes/No', 'Time');

  NoOfVarDecTypes = 3;
  aVarDecTypeDesc : array [1..NoOfVarDecTypes] of string = ('Cost Price'
  , 'Sale Price', 'Quantity');

  NoOfInputTypes = 15;
  aInputTypeDesc : array [1..NoOfInputTypes] of string = ('None', 'Date'
  , 'Period', 'Value', 'ASCII', 'Currency', 'Document No.', 'Customer Code'
  , 'Supplier Code', 'Nominal Code', 'Stock Code', 'Cost Centre Code'
  , 'Department Code', 'Location Code', 'Job Code');

  NoOfAvailFiles = 34;
  aAvailFilesDesc : array [1..NoOfAvailFiles] of string = ('Customer', 'Supplier'
  , 'Document Header', 'Document Detail', 'Nominal', 'Stock', 'Cost Centre', 'Department'
  , 'Fixed Asset Reg', 'Bill of Materials', 'Job Costing', 'Multi Location Stock'
  , 'User List', 'Discount Matrix', 'Job Notes', 'Serial / Batch', 'Analysis Codes'
  , 'Job Types', 'Time Rates', 'FIFO', 'Employees', 'Job Records', 'Job Actuals'
  , 'Job Retentions', 'Job Budgets', 'Locations', 'Stock Locations', 'Matched Payment'
  , 'Customer Notes', 'Supplier Notes', 'Stock Notes', 'Transaction Notes'
  , 'CIS Vouchers', 'Multi-Bins');
  aAvailFilesBitFlag : array [1..NoOfAvailFiles] of longint = (1, 2, 4, 8, 16, 32, 64
  , 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536, 131072, 262144, 524288
  , 1048576, 2097152, 4194304, 8388608, 16777216, 33554432, 67108864, 134217728
  , 268435456, 536870912, 1073741824, 1, 2, 4);

{  NoOfExchVersions = 13;
  aExchVersionsDesc : array [1..NoOfExchVersions] of string = ('Standard'
  , 'Standard + Stock', 'Professional', 'Professional + Stock'
  , 'Professional + SPOP', 'Professional + SPOP + JC', 'Multi-Currency'
  , 'Multi-Currency + Stock', 'Multi-Currency + SPOP', 'Multi-Currency + SPOP + JC'
  , 'Form Designer Single-Currency', 'Form Designer Multi-Currency', 'NOT Form Designer');
  aExchVersionsBitFlag : array [1..NoOfExchVersions] of longint = (1,2,4,8,16,32,64
  ,128,256,1024,1048576,2097152,4194304);}

  NoOfExchVersions = 14;
  aExchVersionsDesc : array [1..NoOfExchVersions] of string = ('Standard'
  , 'Standard + Stock', 'Professional', 'Professional + Stock'
  , 'Professional + SPOP', 'Professional + SPOP + JC', 'Multi-Currency'
  , 'Multi-Currency + Stock', 'Multi-Currency + SPOP', 'Multi-Currency + SPOP + JC'
  , 'Form Designer Single-Currency', 'Form Designer Multi-Currency', 'NOT Form Designer'
  , 'NOT IAO');
  aExchVersionsBitFlag : array [1..NoOfExchVersions] of longint = (1,2,4,8,16,32,64
  ,128,256,1024,1048576,2097152,4194304,8388608);



type

  AltColtSeq  = Record
                 SigByte     :  Char;
                 Header      :  array[1..8] of Char;
                 AltColtChars:  array[0..255] of Char;
               end;

  KeySpec  =  Record
     KeyPos,
     KeyLen,
     KeyFlags                :  SmallInt;
     NotUsed                 :  LongInt;
     ExtTypeVal              :  Byte;
     NullValue               :  Byte;
     Reserved                :  Array[1..4] of Char;
  end;
  

{$I VARRECRP.PAS}

implementation

//{$I VARCNST3.PAS}

end.
