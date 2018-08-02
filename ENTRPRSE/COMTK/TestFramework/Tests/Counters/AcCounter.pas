unit AcCounter;

interface

uses
  Counters, Enterprise04_TLB;

const
  AC_DISCOUNTS      = 0;
  AC_MULTIBUY       = 1;
  AC_LINKS          = 2;
  AC_DATED_NOTES    = 3;
  AC_GENERAL_NOTES  = 4;
  AC_SALES_ANALYSIS = 5;

  SubObjectNames : Array[AC_DISCOUNTS..AC_SALES_ANALYSIS] of string[18] =
                     ('Discounts', 'MultiBuy Discounts', 'Links', 'Dated Notes', 'General Notes', 'Sales Analysis');


type
  TAccountCounter = Class(TCounter)
  protected
    FAccount : IAccount3;
    FName    : string;
    FStartObj : Integer;
    FEndObj : Integer;
    procedure LoadCodeList; override;
    function GetSubObject(WhichObject : Integer) : TAccountSubObjectCounter;
  public
    procedure Execute; override;
  end;

  TCustomerAcCounter = Class(TAccountCounter)
  protected
    procedure SetBaseObject; override;
  end;

  TSupplierAcCounter = Class(TAccountCounter)
  protected
    procedure SetBaseObject; override;
  end;

implementation

{ TAccountCounter }

procedure TAccountCounter.Execute;
var
  iAcCount, iSubObjectCount : integer;
  oCounter : TRecordCounter;
  oSubCounter : TAccountSubObjectCounter;
begin
  inherited;
  AddCount(FName, '', FCodeList.Count);

  //Loop through all sub-objects and add the counts to the result list
  for iSubObjectCount := FStartObj to FEndObj do
  begin
    for iAcCount := 0 to FCodeList.Count - 1 do
    begin
      oSubcounter := GetSubObject(iSubObjectCount);
      Try
        oSubCounter.Toolkit := FToolkit;
        oSubCounter.Code := FCodeList[iAcCount];
        if oSubCounter.Execute then
          AddCount(oSubCounter.Code, SubObjectNames[iSubObjectCount], oSubCounter.RecordCount);
      Finally
        oSubCounter.Free;
      End;
    end;
  end;

end;

function TAccountCounter.GetSubObject(
  WhichObject: Integer): TAccountSubObjectCounter;
begin
  Case WhichObject of
    SO_DISCOUNTS      : Result := TAccountDiscountCounter.Create(FAccount);
    SO_MULTIBUY       : Result := TAccountMultiBuyCounter.Create(FAccount);
    SO_LINKS          : Result := TAccountLinksCounter.Create(FAccount);
    SO_DATED_NOTES    : Result := TAccountDatedNotesCounter.Create(FAccount);
    SO_GENERAL_NOTES  : Result := TAccountGeneralNotesCounter.Create(FAccount);
    SO_SALES_ANALYSIS : Result := TAccountSalesAnalysisCounter.Create(FAccount);
  end;
  Result.Toolkit := oToolkit;
end;

procedure TAccountCounter.LoadCodeList;
var
  Res : Integer;
begin
  Res := FAccount.GetFirst;

  while Res = 0 do
  begin
    FCodeList.Add(FAccount.acCode);

    Res := FAccount.GetNext;
  end;
end;

{ TCustomerAcCounter }

procedure TCustomerAcCounter.SetBaseObject;
begin
  FName := 'Customers';
  FStartObj := AC_DISCOUNTS;
  FEndObj := AC_SALES_ANALYSIS;
  FAccount := FToolkit.Customer as IAccount3;
end;

{ TSupplierAcCounter }

procedure TSupplierAcCounter.SetBaseObject;
begin
  FName := AccountNames[AC_SUPPLIER];
  FStartObj := AC_DISCOUNTS;
  FEndObj := AC_GENERAL_NOTES;
  FAccount := FToolkit.Supplier as IAccount3;
end;

end.
