Unit DEFProcU;

//PR: 02/09/2011 Added Stub version of DefProcU for Scheduler to avoid compiling in all reports. 

Interface

Uses Windows,Controls,GlobVar,ExWrap1U;


Procedure Control_DefProcess(Mode          :  Byte;
                             Fnum,KeyPAth  :  Integer;
                             KeyRef        :  Str255;
                             ExLocal       :  TdExLocal;
                             Ask4Prn       :  Boolean);

Function Get_CustPrint(THandle  :  TWinControl;
                       ListPoint:  TPoint;
                       Mode     :  Byte)  :  Byte;

Procedure PrintDocument(ExLocal  :  TdExLocal;
                        Ask4Prn  :  Boolean);

  Procedure Print_StockDef(ExLocal  :  TdExLocal;
                           Ask4It   :  Boolean;
                           PMode    :  Byte;
                           ThisForm :  Str10);


  Procedure PrintStockRecord(ExLocal  :  TdExLocal;
                             Ask4Prn  :  Boolean);


Implementation

{$WARNINGS OFF}

Procedure Control_DefProcess(Mode          :  Byte;
                             Fnum,KeyPAth  :  Integer;
                             KeyRef        :  Str255;
                             ExLocal       :  TdExLocal;
                             Ask4Prn       :  Boolean);
Begin
end;

Function Get_CustPrint(THandle  :  TWinControl;
                       ListPoint:  TPoint;
                       Mode     :  Byte)  :  Byte;
Begin
end;

Procedure PrintDocument(ExLocal  :  TdExLocal;
                        Ask4Prn  :  Boolean);

Begin
end; {Proc..}



Procedure Print_StockDef(ExLocal  :  TdExLocal;
                         Ask4It   :  Boolean;
                         PMode    :  Byte;
                         ThisForm :  Str10);
Begin
end;



Procedure PrintStockRecord(ExLocal  :  TdExLocal;
                           Ask4Prn  :  Boolean);
begin
end; {Proc..}


{$WARNINGS ON}
end. 