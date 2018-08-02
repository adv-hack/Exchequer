unit AddTransaction;

interface
 uses enterprise04_tlb, INIFiles, AddObject;

type TAddTransaction = class(TAddObject)
private
  fTransaction : ITransaction;
  fDocType : Integer;
public
  function SaveObject : longint; virtual;
  property transaction : ITransaction read fTransaction write fTransaction;
  property DocumentType : Integer read fDocType write fDocType;
end;

type TAddTimeSheet = class(TAddTransaction)
published
  function SaveObjectFromIni : longint; override;
end;

type TAddSalesPurchase = class(TAddTransaction)
published
 constructor Create(docType : integer);
 function SaveObjectFromIni : longint; override;
end;

type TAddNominal = class(TAddTransaction)
published
 function SaveObjectFromIni : longint; override;
end;

type TAddAdjustment = class(TAddTransaction)
published
 function SaveObjectFromIni : longint; override;
end;

implementation

function TAddTransaction.SaveObject : longint;
begin

end;

constructor TAddSalesPurchase.Create(docType : integer);
begin                                                 
  DocumentType := docType;
end;

function TAddSalesPurchase.SaveObjectFromIni;
begin
  ReadINI;

  transaction := fToolkit.Transaction.Add(DocumentType);
  with transaction do
  begin
    ImportDefaults;
    thAcCode := iniFile.ReadString('Main','thAcCode','ABAP01');
    with thLines.Add do
    begin
      tlDescr := iniFile.ReadString('Main','tlDescr','');
      tlGLCode :=  iniFile.ReadInteger('Main','tlGLCode',-1);
      tlCurrency :=  iniFile.ReadInteger('Main','tlCurrency',-1);
      tlDailyRate :=  iniFile.ReadInteger('Main','tlDailyRate',-1);
      tlNetValue :=  iniFile.ReadInteger('Main','tlNetValue',-1);
      tlCompanyRate :=  iniFile.ReadInteger('Main','tlCompanyRate',-1);
      tlStockCode := iniFile.ReadString('Main','tlStockCode','');
      tlLocation := iniFile.ReadString('Main','tlLocation','');

      tlCostCentre := iniFile.ReadString('Main','tlCostCentre','');
      tlDepartment := iniFile.ReadString('Main','tlDepartment','');

      Save;
    end;
  end;
 Result := transaction.Save(True);
end;

function TAddNominal.SaveObjectFromIni;
begin
  ReadINI;

  transaction := fToolkit.Transaction.Add(dtNmt);
  With transaction Do
  Begin
    ImportDefaults;
    thAcCode := 'ABAP01';
    
    With thLines.Add Do
    Begin
      tlDescr := iniFile.ReadString('Main','tlDescr','');
      tlGLCode := iniFile.ReadInteger('Main','tlGLCode',0);
      tlCurrency := iniFile.ReadInteger('Main','tlCurrency',0);
      tlDailyRate := iniFile.ReadInteger('Main','tlDailyRate',0);
      tlNetValue := iniFile.ReadInteger('Main','tlNetValue',0);
      tlCompanyRate := iniFile.ReadInteger('Main','tlCompanyRate',0);

      tlCostCentre := iniFile.ReadString('Main','tlCostCentre','');
      tlDepartment := iniFile.ReadString('Main','tlDepartment','');

      Save;
    End;

    With thLines.Add Do
    Begin
      tlDescr := iniFile.ReadString('Main','tlDescr2','');
      tlGLCode := iniFile.ReadInteger('Main','tlGLCode2',0);
      tlCurrency := iniFile.ReadInteger('Main','tlCurrency2',0);
      tlDailyRate := iniFile.ReadInteger('Main','tlDailyRate2',0);
      tlNetValue := iniFile.ReadInteger('Main','tlNetValue2',0);
      tlCompanyRate := iniFile.ReadInteger('Main','tlCompanyRate2',0);

      tlCostCentre := iniFile.ReadString('Main','tlCostCentre2','');
      tlDepartment := iniFile.ReadString('Main','tlDepartment2','');

      Save;
    End;
  End;
 Result := transaction.Save(True);
end;

function TAddTimeSheet.SaveObjectFromIni;
begin
  ReadINI;

  transaction := fToolkit.Transaction.Add(dtTsh);
  with transaction do
  begin
    thEmployeeCode := iniFile.ReadString('Main','thEmployeeCode','');
    thSettleDiscDays := iniFile.ReadInteger('Main','thSettleDiscDays',-1);

    ImportDefaults;

    with thLines.Add do
    begin
      tlJobCode := iniFile.ReadString('Main','tlJobCode','');
      tlAnalysisCode := iniFile.ReadString('Main','tlAnalysisCode','');
      tlStockCode := iniFile.ReadString('Main','tlStockCode','');
      tlCurrency := iniFile.ReadInteger('Main','tlCurrency',-1);

      tlDescr := iniFile.ReadString('Main','tlDescr','');
      tlQty := iniFile.ReadInteger('Main','tlQty',-1);
      Save;
    end;
  end;
 Result := transaction.Save(True);
end;

function TAddAdjustment.SaveObjectFromIni;
begin
  ReadINI;

  transaction := fToolkit.Transaction.Add(dtADJ);
  with transaction do
  begin
    ImportDefaults;
    thEmployeeCode := iniFile.ReadString('Main','thEmployeeCode','');
    thSettleDiscDays := iniFile.ReadInteger('Main','thSettleDiscDays',-1);

    with thLines.Add do
    begin
      tlStockCode := iniFile.ReadString('Main','tlStockCode','');
      tlQty := iniFile.ReadInteger('Main','tlQty',-1);
      tlBOMKitLink := iniFile.ReadInteger('Main','tlBOMKitLink',-1);

      ImportDefaults;
      Save;
    end;
  end;
 Result := transaction.Save(True);
end;

end.
