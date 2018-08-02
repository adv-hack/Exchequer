//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "DM.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "RPCon"
#pragma link "RPConBDE"
#pragma link "RPConDS"
#pragma link "RPDefine"
#pragma resource "*.dfm"
TDataModule1 *DataModule1;
//---------------------------------------------------------------------------
__fastcall TDataModule1::TDataModule1(TComponent* Owner)
  : TDataModule(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TDataModule1::CustomCXNEOF(TRPCustomConnection *Connection,
      bool &Eof)
{
  Eof = (Connection->DataIndex > 1000);
}
//---------------------------------------------------------------------------
void __fastcall TDataModule1::CustomCXNGetCols(
      TRPCustomConnection *Connection)
{
  Connection->WriteField("Index",dtInteger,8,"Index Field","This field is the index of each row.");
  Connection->WriteField("Name",dtString,30,"Name Field","This field is the name of each row.");
  Connection->WriteField("Amount",dtFloat,20,"Amount Field","This field is the amount of each row.");
}
//---------------------------------------------------------------------------
void __fastcall TDataModule1::CustomCXNGetRow(
      TRPCustomConnection *Connection)
{
  Connection->WriteIntData("",Connection->DataIndex);
  Connection->WriteStrData("","Name" + IntToStr(Connection->DataIndex));
  Connection->WriteFloatData("",Connection->DataIndex * 123.45);
}
//---------------------------------------------------------------------------
void __fastcall TDataModule1::ItemsTableCalcFields(TDataSet *DataSet)
{
  ItemsTableTotalPrice->AsCurrency = ItemsTable->FieldByName("ListPrice")->AsCurrency *
   ItemsTable->FieldByName("Qty")->AsInteger *
   ((100.0 - ItemsTable->FieldByName("Discount")->AsFloat) / 100.0);
}
//---------------------------------------------------------------------------
void __fastcall TDataModule1::CustomMasterCXNGetCols(
      TRPCustomConnection *Connection)
{
  Connection->WriteField("MasterKey",dtInteger,8,"","");
  Connection->WriteField("MasterName",dtString,40,"","");
}
//---------------------------------------------------------------------------

void __fastcall TDataModule1::CustomMasterCXNGetRow(
      TRPCustomConnection *Connection)
{
  Connection->WriteIntData("",Connection->DataIndex);
  AnsiString S1 = MoneyToLongName(Connection->DataIndex);
  S1.Delete(S1.Length() - 10,11); // Delete " and 00/100" from end
  Connection->WriteStrData("","Master (" + S1 + ")");
}
//---------------------------------------------------------------------------

void __fastcall TDataModule1::CustomMasterCXNOpen(
      TRPCustomConnection *Connection)
{
  Connection->DataRows = 10;
}
//---------------------------------------------------------------------------

void __fastcall TDataModule1::CustomDetail1CXNGetCols(
      TRPCustomConnection *Connection)
{
  Connection->WriteField("MasterKey",dtInteger,8,"","");
  Connection->WriteField("Detail1Key",dtInteger,8,"","");
  Connection->WriteField("Detail1Name",dtString,40,"","");
}
//---------------------------------------------------------------------------

void __fastcall TDataModule1::CustomDetail1CXNGetRow(
      TRPCustomConnection *Connection)
{
  Connection->WriteIntData("",Connection->DataIndex / 10);
  Connection->WriteIntData("",Connection->DataIndex % 10);
  AnsiString S1 = MoneyToLongName(Connection->DataIndex);
  S1.Delete(S1.Length() - 10,11); // Delete " and 00/100" from end
  Connection->WriteStrData("","Detail #1 (" + S1 + ")");
}
//---------------------------------------------------------------------------

void __fastcall TDataModule1::CustomDetail1CXNOpen(
      TRPCustomConnection *Connection)
{
  Connection->DataRows = 100;
}
//---------------------------------------------------------------------------

void __fastcall TDataModule1::CustomDetail2CXNGetCols(
      TRPCustomConnection *Connection)
{
  Connection->WriteField("MasterKey",dtInteger,8,"","");
  Connection->WriteField("Detail1Key",dtInteger,8,"","");
  Connection->WriteField("Detail2Key",dtInteger,8,"","");
  Connection->WriteField("Detail2Name",dtString,40,"","");
}
//---------------------------------------------------------------------------

void __fastcall TDataModule1::CustomDetail2CXNGetRow(
      TRPCustomConnection *Connection)
{
  Connection->WriteIntData("",Connection->DataIndex / 100);
  Connection->WriteIntData("",(Connection->DataIndex / 10) % 10);
  Connection->WriteIntData("",Connection->DataIndex % 10);
  AnsiString S1 = MoneyToLongName(Connection->DataIndex);
  S1.Delete(S1.Length() - 10,11); // Delete " and 00/100" from end
  Connection->WriteStrData("","Detail #2 (" + S1 + ")");
}
//---------------------------------------------------------------------------

void __fastcall TDataModule1::CustomDetail2CXNOpen(
      TRPCustomConnection *Connection)
{
  Connection->DataRows = 1000;
}
//---------------------------------------------------------------------------

