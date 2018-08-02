unit ContProc;

{ nfrewer440 16:07 13/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  ADODB, Varconst, SysUtils, ContDet, GlobVar, BtrvU2, Forms, Controls, Dialogs
  , APIUtil, DataModule, PickAcc, ContSel;

var
//  frmContactDetails: TfrmContactDetails;
//  frmContactMain: TfrmContactMain;
  LockPos : longint;

  function GetAddressString(ContactRec : TContactRecType) : string;
  function GetAddressStringSQL(qContact : TADOQuery) : string;
  Function GetFirstAddressLine(ContactRec : TContactRecType) : string;
  function FillContactDetails(sCompany, sAccountCode, sContactCode : string; bEdit : boolean) : integer;
  procedure PopulateContactRec(var ContactRec : TContactRecType; qContact : TADOQuery);
  function LockRecord : Smallint;
  function UnlockRecord : Smallint;
  function NextContactCode(const Company, Surname : shortstring) : Shortstring;

implementation

function GetAddressString(ContactRec : TContactRecType) : string;
begin
  with ContactRec do begin
    Result := '';
    if Trim(coAddress1) <> '' then Result := Result + Trim(coAddress1) + ', ';
    if Trim(coAddress2) <> '' then Result := Result + Trim(coAddress2) + ', ';
    if Trim(coAddress3) <> '' then Result := Result + Trim(coAddress3) + ', ';
    if Trim(coAddress4) <> '' then Result := Result + Trim(coAddress4) + ', ';
    if Trim(coPostCode) <> '' then Result := Result + Trim(coPostCode);
    if Copy(Result,Length(Result) - 1, 2) = ', ' then Result := Copy(Result,1, Length(Result) - 2);
  end;{with}
end;

function GetAddressStringSQL(qContact : TADOQuery) : string;
begin
  with qContact do
  begin
    Result := '';
    if Trim(qContact.FieldByName('coAddress1').AsString) <> '' then Result := Result + Trim(qContact.FieldByName('coAddress1').AsString) + ', ';
    if Trim(qContact.FieldByName('coAddress2').AsString) <> '' then Result := Result + Trim(qContact.FieldByName('coAddress2').AsString) + ', ';
    if Trim(qContact.FieldByName('coAddress3').AsString) <> '' then Result := Result + Trim(qContact.FieldByName('coAddress3').AsString) + ', ';
    if Trim(qContact.FieldByName('coAddress4').AsString) <> '' then Result := Result + Trim(qContact.FieldByName('coAddress4').AsString) + ', ';
    if Trim(qContact.FieldByName('coPostCode').AsString) <> '' then Result := Result + Trim(qContact.FieldByName('coPostCode').AsString);
    if Copy(Result,Length(Result) - 1, 2) = ', ' then Result := Copy(Result,1, Length(Result) - 2);
  end;{with}
end;

Function GetFirstAddressLine(ContactRec : TContactRecType) : string;

  function SpaceIfNotEmpty(sString : string) : string;
  begin
    if sString = '' then Result := ''
    else Result := ' ';
  end;

  function GetInitials(sFirstnames : string) : string;
  var
    iPos : integer;
  begin
    if Length(sFirstnames) > 0 then begin
      Result := sFirstnames[1] + ' ';
      For iPos := 1 to Length(sFirstnames) do begin
        if sFirstNames[iPos] = ' ' then Result := Result + sFirstNames[iPos + 1] + ' ';
      end;{for}
    end;{if}
    Result := Trim(Result);
  end;

begin
  with ContactRec do begin
    Result := Trim(coTitle) + SpaceIfNotEmpty(coFirstName) + Trim(coFirstName)
    + SpaceIfNotEmpty(coSurname) + Trim(coSurname);
    if Length(Result) > 30 then begin
      Result := Trim(coTitle) + SpaceIfNotEmpty(coFirstName) + GetInitials(Trim(coFirstName))
      + SpaceIfNotEmpty(coSurname) + Trim(coSurname);
      if Length(Result) > 30 then begin
        Result := Trim(coTitle) + SpaceIfNotEmpty(coSurname) + Trim(coSurname);
        if Length(Result) > 30 then Result := Trim(coSurname);
      end;{if}
    end;{if}
  end;{with}
end;

function FillContactDetails(sCompany, sAccountCode, sContactCode : string; bEdit : boolean) : integer;
var
  frmContactDetails: TfrmContactDetails;

  procedure ContactRec2Form(ContactRec : TContactRecType);
  begin{ContactRec2Form}
    with frmContactDetails, ContactRec do
    begin
      edtCode.Text := Trim(coCode);
      edtTitle.Text := Trim(coTitle);
      edtFirstName.Text := Trim(coFirstName);
      edtSurname.Text := Trim(coSurname);
      edtPosition.Text := Trim(coPosition);
      edtSalutation.Text := Trim(coSalutation);
      edtContactNo.Text := Trim(coContactNo);
      edtFaxNumber.Text := Trim(coFaxNumber);
      edtEmailAddr.Text := Trim(coEmailAddr);
      edAddress1.Text := Trim(coAddress1);
      edAddress2.Text := Trim(coAddress2);
      edAddress3.Text := Trim(coAddress3);
      edAddress4.Text := Trim(coAddress4);
      edPostCode.Text := Trim(coPostCode);
    end;{with}
  end;{ContactRec2Form}

  function ShowDetails : smallInt;
  var
    qContact : TADOQuery;
    CurrentContactRec : TContactRecType;
  begin{ShowDetails}
    Result := 0;
    frmContactDetails := TfrmContactDetails.Create(application);
    with frmContactDetails do
    begin
      try
        ContactRec2Form(ContactRec);
        bAllowEdits := bEdit;
        bFind := FALSE;
        ShowModal;
        if (ModalResult = mrOK) and bEdit then
        begin
          if bSQL then
          begin
            // MS-SQL
            SQLDataModule.ADOConnection_Common.BeginTrans;
            qContact := SQLDataModule.SQLGetContact(ContactRec.coAccount, ContactRec.coCode);
            PopulateContactRec(CurrentContactRec, qContact);
            qContact.Close;
            qContact := nil;

            if CompareMem(@CurrentContactRec, @ContactRec, SizeOf(CurrentContactRec)) then
            begin
              // Record has not been updated since we last read it
              DetailsToRec(ContactRec.coCompany, ContactRec.coAccount, frmContactDetails);
              SQLDataModule.SQLUpdateContact(ContactRec.coCode, ContactRec);
              SQLDataModule.ADOConnection_Common.CommitTrans;
              Result := 0;
            end
            else
            begin
              // Record has been updated since we last read it
              SQLDataModule.ADOConnection_Common.RollbackTrans;
              MsgBox('This contact has been updated by another user since you opened it for editing.'#13#13
              + 'Sorry - Your updates could not be stored.', mtWarning, [mbOK], mbOK, 'Update Contact');
              Result := 999;
            end;{if}
          end
          else
          begin
            // Pervasive
            // update the record
            DetailsToRec(sCompany, sAccountCode, frmContactDetails);
            Result := Put_Rec(F[ContactF],ContactF,RecPtr[ContactF]^,CoCodeIdx);
            if Result <> 0 then ShowMessage('Put_Rec Error: ' + IntToStr(Result))
          end;{if}
        end
        else
        begin
          if bSQL then
          begin
            // MS-SQL
            Result := -1;
          end
          else
          begin
            // Pervasive
            if bEdit then UnlockRecord;
            Result := -1;
          end;{if}
        end;{if}
      finally
        Freeandnil(frmContactDetails);
      end;{try}
    end;{with}
  end;{ShowDetails}

var
  qContact : TADOQuery;
  KeyS : Str255;
   LStatus : smallInt;
begin
  if bSQL then
  begin
    // MS-SQL

    // Get Contact details
    qContact := SQLDataModule.SQLGetContact(sAccountCode, sContactCode);
    PopulateContactRec(ContactRec, qContact);
    qContact.Close;
    qContact := nil;

    // Show Datails Dialog
    Result := ShowDetails;
  end
  else
  begin
    // Pervasive
    KeyS := BuildCodeIndex(sCompany, sAccountCode, sContactCode);
    LStatus := Find_Rec(B_GetEq, F[ContactF],ContactF,RecPtr[ContactF]^,CoCodeIdx, KeyS);
    if LStatus = 0 then
    begin
      if bEdit then LStatus := LockRecord;
      if LStatus = 0 then
      begin
        LStatus := ShowDetails;
(*        frmContactDetails := TfrmContactDetails.Create(application);
        with frmContactDetails do
        begin
          try
            ContactRec2Form(ContactRec);
            bAllowEdits := bEdit;
            bFind := FALSE;
            ShowModal;
            if ModalResult = mrOK then
            begin
              // update the record
              DetailsToRec(sCompany, sAccountCode, frmContactDetails);
              LStatus := Put_Rec(F[ContactF],ContactF,RecPtr[ContactF]^,CoCodeIdx);
              if LStatus <> 0 then ShowMessage('Put_Rec Error: ' + IntToStr(LStatus))
            end
            else
            begin
              if bEdit then UnlockRecord;
              LStatus := -1;
            end;{if}
          finally
            Freeandnil(frmContactDetails);
          end;{try}
        end;{with}*)
      end;{if}
    end;{if}
    Result := LStatus;
  end;{if}
end;

function LockRecord : Smallint;
begin
  Result := GetPos(F[ContactF], ContactF, LockPos);

  if Result = 0 then
  begin
    Move(LockPos, RecPtr[ContactF]^, SizeOf(LockPos));
    Result := GetDirect(F[ContactF], ContactF, RecPtr[ContactF]^, coCodeIdx,
                       B_SingLock + B_SingNWLock);
  end;
end;

function UnlockRecord : Smallint;
var
  KeyS : Str255;
begin
   FillChar(KeyS, SizeOf(KeyS), #0);
   Move(LockPos, RecPtr[ContactF]^, SizeOf(LockPos));
   Result := Find_Rec(B_Unlock, F[ContactF], ContactF, RecPtr[ContactF]^,
                        0, KeyS);
   if Result <> 0 then
     ShowMessage('Error ' + IntToStr(Result) + ' unlocking record');
end;

procedure PopulateContactRec(var ContactRec : TContactRecType; qContact : TADOQuery);
begin
  fillChar(ContactRec, SizeOf(ContactRec), #0);
  ContactRec.coCompany := qContact.FieldByName('coCompany').AsString;
  ContactRec.coAccount := qContact.FieldByName('coAccount').AsString;
  ContactRec.coCode := qContact.FieldByName('coCode').AsString;
  ContactRec.coTitle := qContact.FieldByName('coTitle').AsString;
  ContactRec.coFirstName := qContact.FieldByName('coFirstName').AsString;
  ContactRec.coSurname := qContact.FieldByName('coSurname').AsString;
  ContactRec.coPosition := qContact.FieldByName('coPosition').AsString;
  ContactRec.coSalutation := qContact.FieldByName('coSalutation').AsString;
  ContactRec.coContactNo := qContact.FieldByName('coContactNo').AsString;
  ContactRec.coDate := qContact.FieldByName('coDate').AsString;
  ContactRec.coFaxNumber := qContact.FieldByName('coFaxNumber').AsString;
  ContactRec.coEmailAddr := qContact.FieldByName('coEmailAddr').AsString;
  ContactRec.coAddress1 := qContact.FieldByName('coAddress1').AsString;
  ContactRec.coAddress2 := qContact.FieldByName('coAddress2').AsString;
  ContactRec.coAddress3 := qContact.FieldByName('coAddress3').AsString;
  ContactRec.coAddress4 := qContact.FieldByName('coAddress4').AsString;
  ContactRec.coPostCode := qContact.FieldByName('coPostCode').AsString;
end;{if}

function NextContactCode(const Company, Surname : shortstring) : Shortstring;
//Add three digit number to surname and increment until it's unique for this
//company
var
  LStatus : smallInt;
  KeyS : Str255;
  i : integer;
begin
  if bSQL then
  begin
    // MS-SQL
    Result := SQLDataModule.SQLGetNextContactCode(Surname);
  end
  else
  begin
    // Pervasive
    i := 1;
    Repeat
      Result := Copy(UpperCase(Surname), 1, 17) + Copy('000', 1, 3 - Length(IntToStr(i)))
                         + IntToStr(i);
      KeyS := BuildUniqueIndex(Company, Result);
      LStatus := Find_Rec(B_GetEq, F[ContactF],ContactF,RecPtr[ContactF]^,CoUniqueIdx, KeyS);
      inc(i);
    Until LStatus <> 0;

    if LStatus <> 4 {Record not found} then
    begin
      Raise EContactError.Create('Btrieve error ' + IntToStr(LStatus) + ' while creating Contact Code');
    end;{if}
  end;
end;

end.
