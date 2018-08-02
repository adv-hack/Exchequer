unit AcSubCounterClasses;

interface

uses
  BaseCounterClasses, Enterprise04_TLB, EnterpriseBeta_TLB;

type

  TAccountSubObjectCounter = Class(TSubObjectCounter)
  private
    FAccount : IAccount3;
  protected
    function GetDatabaseFunctions : IDatabaseFunctions; virtual; abstract;
  public
    constructor Create(const AnAccount : IAccount3);
    function Execute : Boolean; override;
  end;


  //=================== Account Discounts ================================
  TAccountDiscountCounter = Class(TAccountSubObjectCounter)
  protected
    function GetDatabaseFunctions : IDatabaseFunctions; override;
  end;

//=================== Sales Analysis ================================

  TAccountSalesAnalysisCounter = Class(TAccountSubObjectCounter)
  protected
    function GetDatabaseFunctions : IDatabaseFunctions; override;
  end;

//=================== Links ================================

  TAccountLinksCounter = Class(TAccountSubObjectCounter)
  protected
    function GetDatabaseFunctions : IDatabaseFunctions; override;
  end;

//=================== MultiBuy ================================

  TAccountMultiBuyCounter = Class(TAccountSubObjectCounter)
  protected
    function GetDatabaseFunctions : IDatabaseFunctions; override;
  end;

//=================== DatedNotes ================================

  TAccountDatedNotesCounter = Class(TAccountSubObjectCounter)
  protected
    function GetDatabaseFunctions : IDatabaseFunctions; override;
  end;

//=================== GeneralNotes ================================

  TAccountGeneralNotesCounter = Class(TAccountSubObjectCounter)
  protected
    function GetDatabaseFunctions : IDatabaseFunctions; override;
  end;


implementation

{ TAccountSubObjectCounter }

constructor TAccountSubObjectCounter.Create(const AnAccount: IAccount3);
begin
  FAccount := AnAccount;
end;

function TAccountSubObjectCounter.Execute: Boolean;
var
  Res : Integer;
begin
  Result := False;
  Res := FAccount.GetEqual(FAccount.BuildCodeIndex(FCode));
  if Res = 0 then
  begin
    FCounter := TRecordCounter.Create;
    Try
      FCounter.Toolkit := FToolkit;
      FCounter.DatabaseFunctions := GetDatabaseFunctions;
      Result := FCounter.Execute;
      if Result then
        FRecordCount := FCounter.RecordCount;
    Finally
      FCounter.Free;
    End;
  end;
end;


{ TAccountDiscountCounter }

function TAccountDiscountCounter.GetDatabaseFunctions: IDatabaseFunctions;
begin
  Result := FAccount.acDiscounts as IDatabaseFunctions;
end;

{ TAccountSalesAnalysisCounter }

function TAccountSalesAnalysisCounter.GetDatabaseFunctions: IDatabaseFunctions;
begin
  Result := FAccount.acSalesAnalysis as IDatabaseFunctions;
  Result.Index := 1;
end;

{ TAccountLinksCounter }

function TAccountLinksCounter.GetDatabaseFunctions: IDatabaseFunctions;
begin
  Result := FAccount.acLinks as IDatabaseFunctions;
end;

{ TAccountMulitBuyCounter }

function TAccountMultiBuyCounter.GetDatabaseFunctions: IDatabaseFunctions;
begin
  Result := FAccount.acMultiBuy as IDatabaseFunctions;
end;

{ TAccountDatedNotesCounter }

function TAccountDatedNotesCounter.GetDatabaseFunctions: IDatabaseFunctions;
begin
  FAccount.acNotes.ntType := ntTypeDated;
  Result := FAccount.acNotes as IDatabaseFunctions;
end;


{ TAccountGeneralNotesCounter }

function TAccountGeneralNotesCounter.GetDatabaseFunctions: IDatabaseFunctions;
begin
  FAccount.acNotes.ntType := ntTypeGeneral;
  Result := FAccount.acNotes as IDatabaseFunctions;
end;


end.
