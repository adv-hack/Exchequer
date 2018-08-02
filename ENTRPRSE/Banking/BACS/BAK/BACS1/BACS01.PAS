unit bacs01;

interface

     BACS1IntRec  =  Record
                      DESTSort  :  Array[1..6] of Char;
                      DESTAcc   :  Array[1..8] of Char;
                      ZFill1    :  Char;
                      TranCode  :  Array[1..2] of Char;
                      CompSort  :  Array[1..6] of Char;
                      CompAcc   :  Array[1..8] of Char;
                      ZFill2    :  Array[1..4] of Char;
                      AmountP   :  Array[1..11] of Char;
                      CompName  :  Array[1..18] of Char;
                      CompRef   :  Array[1..18] of Char;
                      DestName  :  Array[1..18] of Char;
                      CrLF      :  Array[1..2] of Char;
                    end;


     TBacs1Control = Record
        CtrlGL     : LongInt;
        BankGl     : LongInt;
        SalesPurch : Boolean;
        Amount     : Double;
        PayRun     : LongInt;
     end;

  TBacs1Obj  = Class
    private
      TotalPenceWritten : longint;
      OutFile : File of Bacs1IntRec;
      Failed : SmallInt;
      RunAborted : Boolean;
      ProcControl : TBacs1Control;
    public
       constructor Create;
       destructor Destroy;
       function CreateOutFile(const AFileName : string) : integer;
       function EraseOutFile : Boolean;
       function CloseOutFile : integer;
       function BACS_Safe(TStr  :  Str255)  :  Str255;
       function WriteRec(const EventData : TAbsEnterpriseSystem;
                         Mode : Word) : Boolean; override;
       function ZeroesAtFront(v : double; ASize : integer) : Str255;
       procedure GetEventData(const EventData : TAbsEnterpriseSystem);
       Procedure Str2_Char(const LStr   :  Str255;
                             Var CharAry;
                                 SO     :  Integer);

    end;

var
  Bacs1Obj : TBacs1Obj;

implementation

constructor TBacs1Obj.Create;
begin
  inherited Create;
  TotalPenceWritten := 0;
  Failed := 0;
  RunAborted := False;
end;

destructor TBacs1Obj.Destroy;
begin
  inherited Destroy;
end;

function TBacs1Obj.CreateOutFile(const AFileName : string) : integer;
begin
{$I-}
  OutFileName := AFilename;
  AssignFile(OutFile, AFileName);
  Rewrite(OutFile);
  Result := IOResult;
  if Result <> 0 then
    ShowMessage('Unable to create file ' + AFileName);
{$I+}
end;

function TBacs1Obj.CloseOutFile : integer;
begin
{$I-}
  CloseFile(OutFile);
  Result := IOResult;
  if Result <> 0 then
    ShowMessage('Unable to close file ' + AFileName);
{$I+}
end;

function TBacs1Obj.EraseOutFile : Boolean;
{assumes that the file has been closed}
begin
  Result := DeleteFile(OutFileName);
  if not Result then {could still be open so let's try just in case}
  begin
    if CloseOutFile = 0 then
     Result := DeleteFile(OutFileName);
  end;
  if not Result  then
    ShowMessage('Unable to erase file ' + AFileName);
end;


procedure TBacs1Obj.GetEventData(const EventData : TAbsEnterpriseSystem);
var
  n : Byte;
begin
  With EventData, ProcControl do
  begin
    PayRun := Stock.stStockFolio;
    CtrlGL := Stock.stSalesGL;
    BankGl := Stock.stCosgl;
    SalesPurch := Stock.stReOrderFlag;
  end;
end;

  { ===== Function to Filter an NON BACS legal Chars copied from bacs2u.pas ====== }


Function TBacs1Obj.BACS_Safe(TStr  :  Str255)  :  Str255;
Const
  BACSAll :  CharSet = [#32,'&','-','.','/','0'..'9','A'..'Z'];

Var
  L,n  :  Byte;

Begin
  L:=Length(TStr);

  For n:=1 to L do
  Begin
    TStr[n]:=Upcase(Tstr[n]);
    If (Not (TStr[n] In BACSAll)) then
      TStr[n]:=#32;
  end;

  BACS_Safe:=TStr;
end;


  { ==== Function to convert Real No into Pennies Equivalent copied from bacs2u.pas ==== }

Function TPayBatch.Pennies(Inum  :  Real) : LongInt;
Begin
  Pennies:=Round(Inum * 100);
end;




function TBacs1Obj.WriteRec(const EventData : TAbsEnterpriseSystem; Mode : Word) : Boolean;
var
  OutRec : BACS1IntRec;
  i : integer;
  TempStr : Str255;
  pence : longint;
begin
{supplier}
  FillChar(OutRec, SizeOf(OutRec), 32);
  with EventData, OutRec do
  begin
    if Mode = IsContra then
    begin
      Str2_Char(Ssetup.ssUserBankAc, DestAcc, SizeOf(DestAcc));
      Str2_Char(Ssetup.ssUserBankSort, DestSort, SizeOf(DestSort));
      ZFill1 := '0';
      TranCode := '17';
      Str2_Char(Ssetup.ssUserBankAc, CompAcc, SizeOf(CompAcc));
      Str2_Char(Ssetup.ssUserBankSort, CompSort, SizeOf(CompSort));
      TempStr := '0000';
      Str2_Char(TempStr, ZFill2, SizeOf(ZFill2));
      TempStr := ZeroesAtFront(TotalPenceWritten, SizeOf(AmountP);
      Str2_Char(TempStr, AmountP, SizeOf(AmountP));
      GetEventData;
      TempStr := 'BACS ' + ProcControl.PayRun;
      Str2_Char(TempStr, CompName, SizeOf(CompName));
      TempStr := 'CONTRA';
      Str2_Char(TempStr, CompRef, SizeOf(CompRef));
      Str2_Char(Bacs_Safe(Ssetup.ssUserName), DestName, SizeOf(DestName));

    end
    else
    if Mode = PayLine then
    begin
      Str2_Char(Supplier.acBankSort, DestSort, SizeOf(DestSort));
      Str2_Char(Supplier.acBankAc, DestAcc, SizeOf(DestAcc));
      ZFill1 := '0';
      TranCode := '99'

      Str2_Char(Ssetup.ssUserBankAc, CompAcc, SizeOf(CompAcc));
      Str2_Char(Ssetup.ssUserBankSort, CompSort, SizeOf(CompSort));
      TempStr := '0000';
      Str2_Char(TempStr, ZFill2, SizeOf(ZFill2));
      Pence := Pennies(Transaction.thTotalInvoiced);
      TempStr := ZeroesAtFront(Pence, SizeOf(AmountP);
      Str2_Char(TempStr, AmountP, SizeOf(AmountP));
      Str2_Char(Bacs_Safe(Ssetup.ssUserName), CompName, SizeOf(CompName));

      Str2_Char(Bacs_Safe(Supplier.acCompany), DestName, SizeOf(DestName));
      Str2_Char(Transaction.thOurRef, CompRef, SizeOf(CompRef));
      TotalPenceWritten := TotalPenceWritten + Pence;
    end; {not contra}

    CrLF[1] := Char(13);
    CrLF[2] := Char(10);


  end; {with}
  {write record here}
{$I-}
  Write(OutFile, OutRec);
  Result := (IOResult = 0);
{$I+}
end;

function TBacs1Obj.ZeroesAtFront(AValue : longint; ASize : integer) : Str255;
begin
  Result := Format('%.*d',[ASize, AValue]);
end;

Procedure TBacs1Obj.Str2_Char(const LStr   :  Str255;
                                Var CharAry;
                                    SO     :  Integer);
var
  TempStr : Str255;
  MoveSize : integer;
begin
  TempStr := Copy(LStr, 1, SO);
  if Length(TempStr) < SO then
    MoveSize := Length(TempStr)
  else
    MoveSize := SO;
  Move(TempStr[1], CharAry, MoveSize);
end;











end.
