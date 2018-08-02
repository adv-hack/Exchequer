unit UserDefinedFieldUpgrade;

interface
uses
  BtrvU2,
  VarConst,
  BTConst,
  GlobVar;

type
UDFDataRec = record
  fCaption : string;
  fEnabled : boolean;
  fNewIndex : longint;
end;

type
  TUDFUpgrade = Class
  private
   fCustomFieldDat : TFileVar;
   function SaveData(udfData : UDFDataRec) : longint;
   function ProcessVatRec(VatRec : SysRec) : longint;
   function ProcessCustomRec(ctmRec : SysRec) : longint;
   function ProcessCustom2Rec(ct2Rec : SysRec) : longint;
   function GetNewFieldIndex(searchKey : string; index : longint) : longint;
  public
   function InitialiseUpgrade : longint;
end;

implementation
Uses
  CustomFieldsVar, BTUtil, SysUtils, Dialogs;
const
 searchKeys : Array[1..3] of Str255 = ('VAT', 'CTM', 'CT2');

function TUDFUpgrade.InitialiseUpgrade() : longint;
var
  index : integer;
  Syss : Array[1..3] of SysRec;
  fileB : TFileVar;
  vRec : VatRec;
begin
  //Too many IF statements!!!
  index := 1;

  //Load Exchqss.dat and read in the VATR, CstmFr and CstmFr2 records
  result := BTOpenFile(fileB, SetDrive + 'exchqss.dat', 0);

  //Populate SysRec Array with record objects
  if(result = 0) then
  begin
    for index := 1 to 3 do
    begin
      result := BTFindRecord(B_GetEq,fileB,Syss[index],SizeOf(Syss[index]),0,searchKeys[index]);
    end;
 
    BTCloseFile(fileB);
  end;

  //Load Customfields.dat and build index key
  if(result = 0) then
  begin
    result := BTOpenFile(fCustomFieldDat, SetDrive + 'Misc\Customfields.dat', 0, NIL, ExBTOWNER);

    //Process each record
    if(result = 0) then
      result := ProcessVatRec(Syss[1]);

    if(result = 0) then
      result := ProcessCustomRec(Syss[2]);

    if(result = 0) then
      result :=  ProcessCustom2Rec(Syss[3]);

    BTCloseFile(fCustomFieldDat);
  end;
end;

function TUDFUpgrade.SaveData(udfData : UDFDataRec) : longint;
var
  dataPath : string;
  indexKey : Str255;
  CustomFieldSettings : TCustomFieldSettings;
begin
  indexKey := BTFullNomKey(udfData.fNewIndex) + '!';

  //Attempt to find new record index.
  result := BTFindRecord(B_GetEq,fCustomFieldDat,CustomFieldSettings,SizeOf(CustomFieldSettings),0,indexKey);

  //Assign caption and enabled flags then perform an update if record is found.
  if(result = 0) then
  begin
    CustomFieldSettings.cfCaption := udfData.fCaption;
    CustomFieldSettings.cfEnabled := udfData.fEnabled;

    result := BTUpdateRecord(fCustomFieldDat, CustomFieldSettings, SizeOf(CustomFieldSettings), 0, indexKey);
  end
end;

function TUDFUpgrade.ProcessVatRec(VatRec : SysRec) : longint;
var
  udfData : UDFDataRec;
  vatRecLength, index : integer;
begin
 FillChar(udfData,SizeOf(udfData),0);
 //Calculate number of UDFields to be iterated through
 vatRecLength := Length(vatRec.VatRates._UDFCaption);

 //Assign caption to data record and if applicable assign the Hide/Show Param
 for index := 1 to vatRecLength do
 begin
   udfData.fCaption := vatRec.VatRates._UDFCaption[index];

   case index of
      3 : udfData.fEnabled := not vatRec.VatRates._HideLType[0];
      4 : udfData.fEnabled := not vatRec.VatRates._HideLType[5];
      7 : udfData.fEnabled := not vatRec.VatRates._HideLType[1];
      8 : udfData.fEnabled := not vatRec.VatRates._HideLType[2];
      9 : udfData.fEnabled := not vatRec.VatRates._HideLType[3];
     10 : udfData.fEnabled := not vatRec.VatRates._HideLType[4];
     13 : udfData.fEnabled := not vatRec.VatRates._HideLType[6];
     14 : udfData.fEnabled := not vatRec.VatRates._HideUDF[7];
     17 : udfData.fEnabled := not vatRec.VatRates._HideUDF[8];
     18 : udfData.fEnabled := not vatRec.VatRates._HideUDF[9];
     19 : udfData.fEnabled := not vatRec.VatRates._HideUDF[10];
     20 : udfData.fEnabled := not vatRec.VatRates._HideUDF[11];
   else
     udfData.fEnabled := True;
   end;

  //Search for the records field in the new table
  udfData.fNewIndex := GetNewFieldIndex('VAT', index);
  //Save Record to the new table.
  result := SaveData(udfData);
 end;
end;

function TUDFUpgrade.ProcessCustomRec(ctmRec : SysRec) : longint;
var
  udfData : UDFDataRec;
  index : integer;
begin
  FillChar(udfData,SizeOf(udfData),0);
  //Assign caption to data record and if applicable assign the Hide/Show tr
 for index := 1 to 54 do
 begin
   udfData.fCaption := ctmRec.CustomFDefs._fCaptions[index];

   if(index >= 3) and (index <= 50) then
     udfData.fEnabled := not ctmRec.CustomFDefs._fHide[index]
   else
     udfData.fEnabled := True;

   //Search for the records field in the new table
   udfData.fNewIndex := GetNewFieldIndex('CTM', index);
   //Save Record to the new table.
   result := SaveData(udfData);
 end;
end;

function TUDFUpgrade.ProcessCustom2Rec(ct2Rec : SysRec) : longint;
var
  udfData : UDFDataRec;
  index : integer;
begin
 FillChar(udfData,SizeOf(udfData),0);
 //Assign caption to data record and if applicable assign the Hide/Show Param
 for index := 1 to 44 do
 begin
   udfData.fCaption := ct2Rec.CustomFDefs._fCaptions[index];

   if (index <= 40)  then
     udfData.fEnabled := not ct2Rec.CustomFDefs._fHide[index]
   else
     udfData.fEnabled := True;

   //Search for the records field in the new table
   udfData.fNewIndex := GetNewFieldIndex('CT2', index);
   //Save Record to the new table.
   result := SaveData(udfData);
 end;
end;

function TUDFUpgrade.GetNewFieldIndex(searchKey : string; index : longint) : longint;
var
  newIndex : longint;
begin
  newIndex := -1;

  //Search for index in new table using the searchKey and index.
  if(searchKey = 'VAT') then
  begin
    case index of
      1 : newIndex := 1001;
      2 : newIndex := 1002;
      3 : newIndex := 4001;
      4 : newIndex := 4002;
      5 : newIndex := 22001;
      6 : newIndex := 22002;
      7 : newIndex := 3001;
      8 : newIndex := 3002;
      9 : newIndex := 3003;
      10 : newIndex := 3004;
      11 : newIndex := 1003;
      12 : newIndex := 1004;
      13 : newIndex := 4003;
      14 : newIndex := 4004;
      15 : newIndex := 22003;
      16 : newIndex := 22004;
      17 : newIndex := 5001;
      18 : newIndex := 5002;
      19 : newIndex := 5003;
      20 : newIndex := 5004;
      21 : newIndex := 27001;
      22 : newIndex := 27002;
    end;
  end
  else if (searchKey = 'CTM') then
  begin
    case index of
      1 : newIndex := 27003;
      2 : newIndex := 27004;
      3 : newIndex := 6001;
      4 : newIndex := 6002;
      5 : newIndex := 6003;
      6 : newIndex := 6004;
      7 : newIndex := 7001;
      8 : newIndex := 7002;
      9 : newIndex := 7003;
      10 : newIndex := 7004;
      11 : newIndex := 10001;
      12 : newIndex := 10002;
      13 : newIndex := 10003;
      14 : newIndex := 10004;
      15 : newIndex := 11001;
      16 : newIndex := 11002;
      17 : newIndex := 11003;
      18 : newIndex := 11004;
      19 : newIndex := 12001;
      20 : newIndex := 12002;
      21 : newIndex := 12003;
      22 : newIndex := 12004;
      23 : newindex := 13001;
      24 : newindex := 13002;
      25 : newindex := 13003;
      26 : newindex := 13004;
      27 : newindex := 14001;
      28 : newindex := 14002;
      29 : newindex := 14003;
      30 : newindex := 14004;
      31 : newindex := 15001;
      32 : newindex := 15002;
      33 : newindex := 15003;
      34 : newindex := 15004;
      35 : newindex := 18001;
      36 : newindex := 18002;
      37 : newindex := 18003;
      38 : newindex := 18004;
      39 : newindex := 19001;
      40 : newindex := 19002;
      41 : newindex := 19003;
      42 : newindex := 19004;
      43 : newindex := 20001;
      44 : newindex := 20002;
      45 : newindex := 20003;
      46 : newindex := 20004;
      47 : newindex := 21001;
      48 : newindex := 21002;
      49 : newindex := 21003;
      50 : newindex := 21004;
      51 : newindex := 2001;
      52 : newindex := 2002;
      53 : newindex := 2003;
      54 : newindex := 2004;
      end;
  end
  else if (searchKey = 'CT2') then
  begin
    case index of
      1 : newIndex := 23001;
      2 : newIndex := 23002;
      3 : newIndex := 23003;
      4 : newIndex := 23004;
      5 : newIndex := 24001;
      6 : newIndex := 24002;
      7 : newIndex := 24003;
      8 : newIndex := 24004;
      9 : newIndex := 25001;
      10 : newIndex := 25002;
      11 : newIndex := 25003;
      12 : newIndex := 25004;
      13 : newIndex := 26001;
      14 : newIndex := 26002;
      15 : newIndex := 26003;
      16 : newIndex := 26004;
      17 : newIndex := 29001;
      18 : newIndex := 29002;
      19 : newIndex := 29003;
      20 : newIndex := 29004;
      21 : newIndex := 30001;
      22 : newIndex := 30002;
      23 : newindex := 30003;
      24 : newindex := 30004;
      25 : newindex := 8001;
      26 : newindex := 8002;
      27 : newindex := 8003;
      28 : newindex := 8004;
      29 : newindex := 9001;
      30 : newindex := 9002;
      31 : newindex := 9003;
      32 : newindex := 9004;
      33 : newindex := 16001;
      34 : newindex := 16002;
      35 : newindex := 16003;
      36 : newindex := 16004;
      37 : newindex := 17001;
      38 : newindex := 17002;
      39 : newindex := 17003;
      40 : newindex := 17004;
      41 : newindex := 28001;
      42 : newindex := 28002;
      43 : newindex := 28003;
      44 : newindex := 28004;
      end;
  end;

  //Return new index
  result := newIndex;
end;
end.


