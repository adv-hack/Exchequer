unit multini;

{ prutherford440 15:10 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface


function ReadIniFile(Const ThePath : string;
                       GLCode : longint) : Boolean;

var
  UserID : string;
  UserRecID : string;
  OutputCurr : Integer;


implementation

uses
   SysUtils, ExWrap, Dialogs, BacConst,
   {$IFDEF UseIni}
     IniFiles;
   {$ELSE}
     {$IFDEF EX600}
       CtkUtil04,
       Enterprise04_TLB,
     {$ELSE}
       CtkUtil,
       Enterprise01_TLB,
     {$ENDIF}
     ActiveX;
   {$ENDIF}

function CheckPath(const ThePath : string) : string;
{takes in a path and adds a backslash at the end if necessary}
var
  i : integer;
begin
  i := Length(ThePath);

  if (i = 0) or (ThePath[i] <> '\') then
    Result := ThePath + '\'
  else
    Result := ThePath;
end;


function ReadIniFile(Const ThePath : string;
                       GLCode : longint) : Boolean;
var
{$IFDEF UseIni}
  TheIni : TIniFile;
  GLString : string;
{$ELSE}
  oToolkit : IToolkit3;
  oBankAcc : IBankAccount;
  Res : longint;
{$ENDIF}
begin
  BacsType := -1;
{$IFDEF UseIni}
  GLString := 'GL Code ' + IntToStr(GLcode);
  TheIni := TIniFile.Create(CheckPath(ThePath) + 'MBacs.ini');
  with TheIni do
  begin
    Try
      if not SectionExists(GLString) then
      begin
        Result := False;
        ShowMessage('Unable to find ' + GLString + ' in ' + Filename + '.'#13#10 +
                    'Please ensure that details are ' +
                      'entered correctly'#13#10#13#10 +
                      'Batch transaction will revert to default BACS format');
      end
      else
      begin
        IniBankSort := TheIni.ReadString(GLString, 'BANK_SORT','');
        IniBankAc   := TheIni.ReadString(GLString, 'BANK_ACC','');
        IniBankRef  := TheIni.ReadString(GLString, 'BANK_REF','');
        IniPayFile  := TheIni.ReadString(GLString, 'PAY_FILE','DefaultPay.txt');
        IniDDFile   := TheIni.ReadString(GLString, 'REC_FILE','DefaultDDeb.txt');

        BacsType    := TheIni.ReadInteger(GLString, 'BACS_TYPE', -1);
        UserID      := TheIni.ReadString(GLString, 'USERID','');
        OutputCurr  := TheIni.ReadInteger(GLString,'OutputCurrency',0);

       //We don't need to check the sort code or acc here as they'll be caught
      //by the validateSystem method. However, we do need to check that we've got
     //a valid export object type
       if (BacsType < 0) or (BacsType > KnownBacsTypes - 1) then
       begin
         Result := False;
         ShowMessage('Unknown BACS type for ' + GLString + ' in ' + Filename + '.');
       end
       else
         Result := True;

      end; {section exists}

    Finally
      Free;
    End;
  end;
{$ELSE}
  CoInitialize(nil);
  oToolkit := OpenToolkit(ThePath, True) as IToolkit3;
  if Assigned(oToolkit) then
  Try
    with oToolkit.Banking do
    begin
      Res := BankAccount.GetEqual(BankAccount.BuildGLCodeIndex(GLCode));
      if Res = 0 then
      begin
        IniBankSort := BankAccount.baSortCode;
        IniBankAc   := BankAccount.baAccountNo;
        IniBankRef  := BankAccount.baReference;
        IniPayFile  := BankAccount.baPayFileName;
        IniDDFile   := BankAccount.baRecFileName;
        //Product in toolkit runs 1-29 to maintain consistency, so need to adjust
        BacsType    := BankAccount.baProduct - 1;
        UserID      := BankAccount.baUserID;
        OutputCurr  := BankAccount.baOutputCurrency;
        OutputPath  := BankAccount.baOutputPath;

        //PR: 21/08/2013 MRD Added receipt user id which seemed to be lacking
        UserRecID   := (BankAccount as IBankAccount2).baReceiptUserID;

        oBankAcc := BankAccount.Update;
        if Assigned(oBankAcc) then
        begin
          oBankAcc.baLastDate := FormatDateTime('yyyymmdd', SysUtils.Date);
          oBankAcc.Save;
        end;
      end
      else
        ShowMessage('Unable to find bank details for GL Code ' + IntToStr(GLCode) + '.'#10#10 +
                    '(Btrieve error ' + IntToStr(Res) + ' on GetEqual)');
    end;
  Finally
    oToolkit := nil;
  End;

{$ENDIF}
end;

Initialization
  UserID := '';

end.
