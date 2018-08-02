//---------------------------------------------------------------------------
#ifndef DMH
#define DMH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "RPCon.hpp"
#include "RPConBDE.hpp"
#include "RPConDS.hpp"
#include "RPDefine.hpp"
#include <Db.hpp>
#include <DBTables.hpp>
//---------------------------------------------------------------------------
class TDataModule1 : public TDataModule
{
__published:	// IDE-managed Components
  TTable *CustomerTable;
  TTable *OrdersTable;
  TQuery *CustrOrdQuery;
  TTable *ClientsTable;
  TTable *PartsTable;
  TTable *BioLifeTable;
  TTable *MasterTable;
  TRPTableConnection *MasterCXN;
  TRPTableConnection *BioLifeCXN;
  TRPTableConnection *PartsCXN;
  TRPTableConnection *ClientsCXN;
  TRPQueryConnection *CustOrdCXN;
  TRPTableConnection *OrdersCXN;
  TRPTableConnection *CustomerCXN;
  TTable *ItemsTable;
  TFloatField *ItemsTableOrderNo;
  TFloatField *ItemsTableItemNo;
  TFloatField *ItemsTablePartNo;
  TIntegerField *ItemsTableQty;
  TFloatField *ItemsTableDiscount;
  TCurrencyField *ItemsTableListPrice;
  TCurrencyField *ItemsTableTotalPrice;
  TTable *VendorsTable;
  TRPTableConnection *ItemsCXN;
  TRPTableConnection *VendorsCXN;
  TRPCustomConnection *CustomCXN;
  TRPCustomConnection *CustomMasterCXN;
  TRPCustomConnection *CustomDetail1CXN;
  TRPCustomConnection *CustomDetail2CXN;
  void __fastcall CustomCXNEOF(TRPCustomConnection *Connection, bool &Eof);
  void __fastcall CustomCXNGetCols(TRPCustomConnection *Connection);
  void __fastcall CustomCXNGetRow(TRPCustomConnection *Connection);
  void __fastcall ItemsTableCalcFields(TDataSet *DataSet);
  void __fastcall CustomMasterCXNGetCols(TRPCustomConnection *Connection);
  void __fastcall CustomMasterCXNGetRow(TRPCustomConnection *Connection);
  void __fastcall CustomMasterCXNOpen(TRPCustomConnection *Connection);
  void __fastcall CustomDetail1CXNGetCols(TRPCustomConnection *Connection);
  void __fastcall CustomDetail1CXNGetRow(TRPCustomConnection *Connection);
  void __fastcall CustomDetail1CXNOpen(TRPCustomConnection *Connection);
  void __fastcall CustomDetail2CXNGetCols(TRPCustomConnection *Connection);
  void __fastcall CustomDetail2CXNGetRow(TRPCustomConnection *Connection);
  void __fastcall CustomDetail2CXNOpen(TRPCustomConnection *Connection);
private:	// User declarations
public:		// User declarations
  __fastcall TDataModule1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TDataModule1 *DataModule1;
//---------------------------------------------------------------------------
#endif
