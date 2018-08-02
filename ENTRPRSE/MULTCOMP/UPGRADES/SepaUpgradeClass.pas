unit SepaUpgradeClass;

interface

uses
  VarConst, BtrvU2;

type
  //Class to copy old Sort Code/Bank account fields to new SEPA compatible fields
  TSepaUpgradeClass = Class
  private
    fErrorString : string;
    NeedToUpgrade : Boolean;

    function NeedToCopy(const OldFields : string; const NewFields : string) : Boolean;

    procedure CopyCustSuppFields;
    procedure UpdateAllCustSupp;

    procedure CopyBankAccFields;
    procedure UpdateAllBankAcc;

    procedure CopySystemSetupFields;
    procedure UpdateSystemSetup;

  public
    function Execute : Integer;

    property ErrorString : string read FErrorString write FErrorString;
  end;

  function RunSepaUpgrade(var ErrStr : string) : Integer;

implementation

uses
  SysUtils, Varrec2U, GlobVar, EncryptionUtils;

type
  //Exception class to pass back betrieve errors
  EBtrieveError = Class(Exception)
  private
    FErrNo : Integer;
  public
    constructor Create(ErrNo, FileNo : Integer);
    property ErrorNo : integer read FErrNo write FErrNo;
  end;

const
  KeyStart = 'K3';  //For Bank Account record

{ TSepaUpgradeClass }

procedure TSepaUpgradeClass.CopyBankAccFields;
begin
  with MLocCtrl^.BacsDbRec do
    if NeedToCopy(brOldSortCode + brOldAccountCode + brUserId + brUserId2,
                  brBankSortCode + brBankAccountCode + brUserIdEx + brUserId2Ex) then
    begin
      //Copy fields
      MLocCtrl^.BacsDbRec.brBankSortCode := EncryptBankSortCode(Trim(MLocCtrl^.BacsDbRec.brOldSortCode));
      MLocCtrl^.BacsDbRec.brBankAccountCode := EncryptBankAccountCode(Trim(MLocCtrl^.BacsDbRec.brOldAccountCode));
      MLocCtrl^.BacsDbRec.brUserIdEx := EncryptBankUserID(Trim(MLocCtrl^.BacsDbRec.brUserId));
      MLocCtrl^.BacsDbRec.brUserId2Ex := EncryptBankUserID(Trim(MLocCtrl^.BacsDbRec.brUserId2));

      //Blank original fields
      FillChar(MLocCtrl^.BacsDbRec.brOldSortCode[0], SizeOf(MLocCtrl^.BacsDbRec.brOldSortCode), 0);
      FillChar(MLocCtrl^.BacsDbRec.brOldAccountCode[0], SizeOf(MLocCtrl^.BacsDbRec.brOldAccountCode), 0);
      FillChar(MLocCtrl^.BacsDbRec.brUserId[0], SizeOf(MLocCtrl^.BacsDbRec.brUserId), 0);
      FillChar(MLocCtrl^.BacsDbRec.brUserId2[0], SizeOf(MLocCtrl^.BacsDbRec.brUserId2), 0);
    end;
end;

procedure TSepaUpgradeClass.CopyCustSuppFields;
begin
  if NeedToCopy(Cust.oldBankSort + Cust.oldBankAcc, Cust.acBankSortCode + Cust.acBankAccountCode) then
  begin
    //Copy fields
    Cust.acBankSortCode := EncryptBankSortCode(Trim(Cust.oldBankSort));
    Cust.acBankAccountCode := EncryptBankAccountCode(Trim(Cust.oldBankAcc));

    //Blank original fields
    FillChar(Cust.oldBankSort[0], SizeOf(Cust.oldBankSort), 0);
    FillChar(Cust.oldBankAcc[0], SizeOf(Cust.oldBankAcc), 0);
  end;
end;

procedure TSepaUpgradeClass.CopySystemSetupFields;
begin
  if NeedToCopy(Syss.oldUserSort + Syss.oldUserAcc, Syss.ssBankSortCode + Syss.ssBankAccountCode) then
  begin
    //Copy fields
    Syss.ssBankSortCode := EncryptBankSortCode(Trim(Syss.oldUserSort));
    Syss.ssBankAccountCode := EncryptBankAccountCode(Trim(Syss.oldUserAcc));

    //Blank original fields
    FillChar(Syss.oldUserSort[0], SizeOf(Syss.oldUserSort), 0);
    FillChar(Syss.oldUserAcc[0], SizeOf(Syss.oldUserAcc), 0);
  end;
end;

function TSepaUpgradeClass.Execute: Integer;
begin
  NeedToUpgrade := True;

  Open_System(SysF, SysF);
  Open_System(CustF, CustF);
  Open_System(MLocF, MLocF);

  Try
    Try
      UpdateSystemSetup;
      UpdateAllBankAcc;
      UpdateAllCustSupp;
      Result := 0;
    Except
      on E:EBtrieveError do
      begin
        Result := E.ErrorNo;
        FErrorString := E.Message;
      end
      else
        Result := -1;
    End;
  Finally
    Close_Files(True);
  End;

end;

// Function to decide whether we need to copy old fields to new fields
// If old fields are blank then we don't need to copy
// If old fields are populated and new fields are blank then we copy
// If any new field is populated then we've already upgraded the sepa fields, so set NeedToUpgrade variable to false.
function TSepaUpgradeClass.NeedToCopy(const OldFields,
  NewFields: string): Boolean;
begin
  if Trim(NewFields) <> '' then
    NeedToUpgrade := False;

  Result := NeedToUpgrade and (Trim(OldFields) <> '');
end;

procedure TSepaUpgradeClass.UpdateAllBankAcc;
var
  Res : Integer;
  KeyS : Str255;

  function RecordOK : Boolean;
  begin
    Result := Copy(KeyS, 1, 2) = KeyStart;
  end;

begin
  KeyS := KeyStart;
  Res := Find_Rec(B_GetGEQ, F[MLocF], MLocF, RecPtr[MLocF]^, 0, KeyS);

  while (Res = 0) and RecordOK and NeedToUpgrade do
  begin
    CopyBankAccFields;

    if NeedToUpgrade then
    begin
      Res := Put_Rec(F[MLocF], MLocF, RecPtr[MLocF]^, 0);

      if Res = 0 then
        Res := Find_Rec(B_GetNext, F[MLocF], MLocF, RecPtr[MLocF]^, 0, KeyS)
      else
        raise EBtrieveError.Create(Res, MLocF);
    end;
  end;
end;

procedure TSepaUpgradeClass.UpdateAllCustSupp;
var
  Res : Integer;
  KeyS : Str255;
begin
  Res := Find_Rec(B_GetFirst, F[CustF], CustF, RecPtr[CustF]^, 0, KeyS);

  while NeedToUpgrade and (Res = 0) do
  begin
    CopyCustSuppFields;

    if NeedToUpgrade then
    begin
      Res := Put_Rec(F[CustF], CustF, RecPtr[CustF]^, 0);

      if Res = 0 then
        Res := Find_Rec(B_GetNext, F[CustF], CustF, RecPtr[CustF]^, 0, KeyS)
      else
        raise EBtrieveError.Create(Res, CustF);
    end;
  end;
end;

procedure TSepaUpgradeClass.UpdateSystemSetup;
var
  Res : Integer;
  KeyS : Str255;
begin
  KeyS := SysNames[SysR];

  Res := Find_Rec(B_GetEq,F[SysF],SysF,RecPtr[SysF]^,0,KeyS);

  if Res = 0 then
  begin
    CopySystemSetupFields;

    if NeedToUpgrade then
      Res := Put_Rec(F[SysF], SysF, RecPtr[SysF]^, 0);
  end;

  if Res <> 0 then
    raise EBtrieveError.Create(Res, SysF);
end;

{ EBtrieveError }

constructor EBtrieveError.Create(ErrNo, FileNo: Integer);
begin
  inherited CreateFmt('Error code %d in file %s', [ErrNo, Filenames[FileNo]]);
  ErrorNo := ErrNo;
end;

function RunSepaUpgrade(var ErrStr : string) : Integer;
begin
  ErrStr := '';

  with TSepaUpgradeClass.Create do
  Try
    Result := Execute;
    if Result <> 0 then
      ErrStr := ErrorString;
  Finally
    Free;
  End;

end;

end.
