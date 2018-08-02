unit InitFieldsClass;

interface

uses
  VarConst, BtrvU2, InitFieldsIntf;


  function GetInitFieldsObject(WhichOne : TInitFieldsType) : IInitialiseFields;


implementation

uses
  SysUtils, GlobVar, etMiscU, VarRec2U, EtStrU, StrUtil, SHA3HashUtil, Crypto;

type
  TInitialiseFields = Class(TInterfacedObject, IInitialiseFields)
  protected
    FFileNumber : Integer;
    FIndex : Integer;
    FErrorString : string;

    FCurrentRecord  : Integer;

    function GetFileNumber : Integer;
    procedure SetFileNumber(Value : Integer);

    function GetIndex : Integer;
    procedure SetIndex(Value : Integer);

    function GetErrorString : string;

    procedure IterateThroughFile; virtual;
    procedure UpdateRecord(const pRecord : Pointer); virtual; abstract;
  public
    constructor Create;
    function Execute : Boolean;

    property FileNumber : integer read GetFileNumber write SetFileNumber;
    property Index : integer read GetIndex write SetIndex;
    property ErrorString : string read GetErrorString;
  end;

  TInitaliseConsumerFields = Class(TInitialiseFields)
  protected
    procedure UpdateRecord(const pRecord : Pointer); override;
  public
    constructor Create;
  end;

  //PR: 08/05/2015 ABSEXCH-12684 v7.0.14 T2-147 Object to initialise PPD mode on customer/supplier records
  TInitialisePPDFields = Class(TInitaliseConsumerFields)
  protected
    procedure UpdateRecord(const pRecord : Pointer); override;
  end;

  //PR: 06/09/2017 v2017 R2 ABSEXCH-18856
  TUpgradePasswordFields = Class(TInitialiseFields)
  protected
    procedure IterateThroughFile; override;
  public
    constructor Create;
  end;

function GetInitFieldsObject(WhichOne : TInitFieldsType) : IInitialiseFields;
begin
  Case WhichOne of
    ifConsumers : Result := TInitaliseConsumerFields.Create;
    ifPPDMode : Result := TInitialisePPDFields.Create;
    ifPassword : Result := TUpgradePasswordFields.Create;
  end;
end;

{ TInitialiseFields }

constructor TInitialiseFields.Create;
begin
  inherited;
  FIndex := 0;
  FFileNumber := 0;
end;

function TInitialiseFields.Execute: Boolean;
begin
  Result := True;
  Try
    Open_System(FFileNumber, FFileNumber);
    Try
      IterateThroughFile;
    Finally
      Close_Files(True);
    End;
  Except
    on E:Exception do
    begin
      Result := False;
      FErrorString := E.Message;
    end;
  End;
end;

function TInitialiseFields.GetErrorString: string;
begin
  Result := FErrorString;
end;

function TInitialiseFields.GetFileNumber: Integer;
begin
  Result := FFileNumber;
end;

function TInitialiseFields.GetIndex: Integer;
begin
  Result := FIndex;
end;

procedure TInitialiseFields.IterateThroughFile;
var
  Res : Integer;
  KeyS : Str255;
  CurrentRecord : Integer;
begin
  Res := Find_Rec(B_GetFirst, F[FFileNumber], FFileNumber, RecPtr[FFileNumber]^, FIndex, KeyS);
  CurrentRecord := 0;

  while (Res = 0) do
  begin
    inc(CurrentRecord);

    //Do initialisation
    UpdateRecord(RecPtr[FFileNumber]);

    //Store record
    Res := Put_Rec(F[FFileNumber], FFileNumber, RecPtr[FFileNumber]^, FIndex);

    if Res <> 0 then
      raise Exception.Create(Format('Error %d  occurred when storing record number %d', [Res, CurrentRecord]));

    //get next record
    Res := Find_Rec(B_GetNext, F[FFileNumber], FFileNumber, RecPtr[FFileNumber]^, FIndex, KeyS);
  end;
end;

procedure TInitialiseFields.SetFileNumber(Value: Integer);
begin
  FFileNumber := Value;
end;

procedure TInitialiseFields.SetIndex(Value: Integer);
begin
  FIndex := Value;
end;


{ TInitaliseCustSuppSubType }

constructor TInitaliseConsumerFields.Create;
begin
  inherited;
  FFileNumber := CustF;
end;

procedure TInitaliseConsumerFields.UpdateRecord(const pRecord: Pointer);
var
  pCust : ^CustRec;
begin
  //Cast pointer appropriately
  pCust := pRecord;

  //Set SubType field from CustSupp field
  pCust.acSubType := pCust.CustSupp;

  //Blank new long AC Code
  FillChar(pCust.acLongACCode, SizeOf(pCust.acLongACCode), 0);
end;

//PR: 08/05/2015 ABSEXCH-12684 v7.0.14 T2-147 Object to initialise PPD mode on customer/supplier records
procedure TInitialisePPDFields.UpdateRecord(const pRecord: Pointer);
var
  pCust : ^CustRec;
begin
  //Cast pointer appropriately
  pCust := pRecord;

  //Check if either of settlement discount fields is populated
  if Round_Up(pCust.DefSetDisc + pCust.DefSetDDays, 2) <> 0.00 then
  begin
    if pCust.CustSupp = TradeCode[True] then
    begin
      //Customer
      pCust.acPPDMode := pmPPDEnabledWithAutoJournalCreditNote;
    end
    else
    begin
      //Supplier
      pCust.acPPDMode := pmPPDEnabledWithManualCreditNote;
    end; // if pCust.CustSupp = TradeCodes[True]
  end; //if Round_Up(pCust.DefSetDisc + pCust.DefSetDDays, 2) <> 0.00
end;

{ TUpgradePasswordFields }

procedure TUpgradePasswordFields.IterateThroughFile;
var
  Res : Integer;
  KeyS, KeyChk : Str255;
  CurrentRecord : Integer;

  MLocRes : Integer;
  MLocKey : Str255;

begin
  Randomize;

  //Open MLoc file - Pwrd already opened in Execute
  Open_System(MLocF, MLocF);

  //Key for login recs
  KeyS := 'P'#0;
  KeyChk := KeyS;

  //Find first login
  Res := Find_Rec(B_GetGEq, F[FFileNumber], FFileNumber, RecPtr[FFileNumber]^, FIndex, KeyS);
  CurrentRecord := 0;

  while (Res = 0) and (Copy(KeyS, 1, 2) = KeyChk) do
  begin
    inc(CurrentRecord);

    //Find the profile record for the user
    MlocKey := 'PD' + LJVar(PassWord.PassEntryRec.LogIn, 10);
    MLocRes := Find_Rec(B_GetEq, F[MLocF], MLocF, RecPtr[MLocF]^, MLK, MLocKey);

    if MLocRes <> 0 then
    begin
      //No MLoc Rec found, so add one
      FillChar(MLocCtrl^, SizeOf(MLocCtrl^), 0);
      MLocCtrl^.RecPFix := 'P';
      MLocCtrl^.SubType := 'D';
      MLocCtrl^.PassDefRec.LogIn := LJVar(PassWord.PassEntryRec.LogIn, 10);
      MLocRes := Add_Rec(F[MLocF], MLocF, RecPtr[MLocF]^, MLK);

      //Position on record again to update it
      MlocKey := 'PD' + LJVar(PassWord.PassEntryRec.LogIn, 10);
      MLocRes := Find_Rec(B_GetEq, F[MLocF], MLocF, RecPtr[MLocF]^, MLK, MLocKey);
    end;

    if MLocRes = 0 then
    begin
      //Initialise fields
      MLocCtrl^.PassDefRec.UserStatus := usActive;
      MLocCtrl^.PassDefRec.ForcePasswordChange := False;
      MLocCtrl^.PassDefRec.LoginFailureCount := 0;

      //Create hash from existing password - call CreateSalt function in
      //Funcs\StrUtil to create a random salt for the hash
      MLocCtrl^.PassDefRec.PasswordSalt := StrUtil.CreateSalt;

      //Decode existing password and create the hash
      MLocCtrl^.PassDefRec.PasswordHash :=
                      StrToSHA3Hase(MLocCtrl^.PassDefRec.PasswordSalt +
                                    Trim(Decode(Password.PassEntryRec.PWord)));

      //Store profile record
      MLocRes := Put_Rec(F[MLocF], MLocF, RecPtr[MLocF]^, MLK);

      if MLocRes <> 0 then
        raise Exception.Create(Format('Error %d  occurred when storing record number %d', [Res, CurrentRecord]));
    end; //if MLocRes = 0

    //get next login record
    Res := Find_Rec(B_GetNext, F[FFileNumber], FFileNumber, RecPtr[FFileNumber]^, FIndex, KeyS);
  end; // while (Res = 0) and (Copy(KeyS, 1, 2) = KeyChk)
end;

constructor TUpgradePasswordFields.Create;
begin
  inherited;
  FFileNumber := PwrdF;
end;

end.
