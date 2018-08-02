unit oPaper;

{$I DEFOVR.INC}

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, CustAbsU, GlobVar, VarConst,
     CustTypU, VarRec2U, ExWrap1U, RpDevice;

Type
  TPaperlessEmailAddress = Class(TAbsPaperlessEmailAddress)
  Private
    FName : ShortString;
    FAddress : ShortString;
  Protected
    Function GetName : cuStr50; Override;
    Procedure SetName (Value : cuStr50); Override;
    Function GetAddress : cuStr100; Override;
    Procedure SetAddress (Value : cuStr100); Override;
  Public
    Constructor Create (Const Name, Address : ShortString);
  End; // TPaperlessEmailAddress

  //------------------------------

  TPaperlessEmailAddressArray = Class(TAbsPaperlessEmailAddressArray)
  Private
    FAddresses : TList;
  Protected
    function GetItems(Index: SmallInt): TAbsPaperlessEmailAddress; Override;
    function GetCount: SmallInt; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    function AddAddress(const Name: cuStr50; const Address: cuStr100): Integer; Override;
    procedure Delete(Index: SmallInt); Override;
    procedure Clear; Override;

    Procedure LoadFromString(TheString : ANSIString);
    Function ToString : ANSIString;
  End; // TPaperlessEmailAddressArray

  //------------------------------

  TPaperlessEmailAttachments = Class(TAbsPaperlessEmailAttachments)
  Private
    FAttachments : TStringList;
  Protected
    function GetItems(Index: SmallInt): cuStr255; Override;
    Procedure SetItems(Index: SmallInt; Value: cuStr255); Override;
    function GetCount: SmallInt; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    function Add(const FileName: cuStr255): Integer; Override;
    procedure Delete(Index: SmallInt); Override;
    procedure Clear; Override;

    Procedure LoadFromString(TheString : ANSIString);
    Function ToString : ANSIString;
  End; // TPaperlessEmailAttachments

  //------------------------------

  TPaperlessEmail = Class(TAbsPaperlessEmail)
  Private
    RecAccess  : TRecAccessStatus;
    PropAccess : Array [1..11] Of TPropertyAccess;
    FuncAccess : Array [1..1] Of TFunctionAccess;
    RecChanged : Boolean;

    FToAddresses : TPaperlessEmailAddressArray;
    FCCAddresses : TPaperlessEmailAddressArray;
    FBCCAddresses : TPaperlessEmailAddressArray;
    FAttachments : TPaperlessEmailAttachments;

    EntSys     : TEnterpriseSystem;

    FDataRec, FOrigRec : TSBSPrintSetupInfo;
  Protected
    Function GetDataRec : TSBSPrintSetupInfo;
    Procedure SetDataRec(Value : TSBSPrintSetupInfo);

    Function  GetRecStatus : TRecAccessStatus; Override;
    Function  GetRecChanged : Boolean; Override;

    Function GetSenderName : cuStr50; Override;
    Procedure SetSenderName (Value : cuStr50); Override;
    Function GetSenderAddress : cuStr50; Override;
    Procedure SetSenderAddress (Value : cuStr50); Override;
    Function GetToRecipients : TAbsPaperlessEmailAddressArray; Override;
    Function GetCCRecipients : TAbsPaperlessEmailAddressArray; Override;
    Function GetBCCRecipients : TAbsPaperlessEmailAddressArray; Override;
    Function GetSubject : cuStr255; Override;
    Procedure SetSubject (Value : cuStr255); Override;
    Function GetMessageText : ANSIString; Override;
    Procedure SetMessageText (Value : ANSIString); Override;
    Function GetAttachments : TAbsPaperlessEmailAttachments; Override;
    Function GetPriority : TEmailPriority; Override;
    Procedure SetPriority (Value : TEmailPriority); Override;
    Function GetCoverSheet : cuStr8; Override;
    Procedure SetCoverSheet (Value : cuStr8); Override;
    Function GetSendReader : Boolean; Override;
    Procedure SetSendReader (Value : Boolean); Override;
  Public
    // PrintInfo property allows the email data to be easily imported and exported from the object
    Property PrintInfo : TSBSPrintSetupInfo Read GetDataRec Write SetDataRec;

    Constructor Create (hEntSys : TEnterpriseSystem);
    Destructor Destroy; Override;

    Procedure Assign (Const WinId, HandlerId : LongInt; Const ExLocal : TdExLocal);
  End; // TPaperlessEmail

  //------------------------------

  { NOTE: Must be kept in sync with CustAbsU.Pas }
  TPaperless = Class(TAbsPaperless)
  Private
    FEmail : TPaperlessEmail;
  Protected
    Function GetRecChanged : Boolean; Override;
    Function GetEmail : TAbsPaperlessEmail; Override;
  Public
    Property oEmail : TPaperlessEmail Read FEmail;

    Constructor Create (Const hEntSys : TEnterpriseSystem);
    Destructor Destroy; Override;

    Procedure Assign (Const WinId, HandlerId : LongInt; Const ExLocal : TdExLocal);
  End; // TPaperless

  //------------------------------

implementation

Uses CustWinU, EtStrU, BtKeys1U, BtrvU2;

Const
  EmailRecErrStr = 'Email ';

//=========================================================================

Constructor TPaperlessEmailAddress.Create (Const Name, Address : ShortString);
Begin // Create
  Inherited Create;

  FName := Name;
  FAddress := Address;
End; // Create

//-------------------------------------------------------------------------

Function TPaperlessEmailAddress.GetName : cuStr50;
Begin // GetName
  Result := FName;
End; // GetName
Procedure TPaperlessEmailAddress.SetName (Value : cuStr50);
Begin // SetName
  FName := Value;
End; // SetName

//------------------------------

Function TPaperlessEmailAddress.GetAddress : cuStr100;
Begin // GetAddress
  Result := FAddress;
End; // GetAddress
Procedure TPaperlessEmailAddress.SetAddress (Value : cuStr100);
Begin // SetAddress
  FAddress := Value;
End; // SetAddress

//=========================================================================

Constructor TPaperlessEmailAddressArray.Create;
Begin // Create
  Inherited Create;

  FAddresses := TList.Create;
End; // Create

//------------------------------

Destructor TPaperlessEmailAddressArray.Destroy;
Begin // Destroy
  Clear;
  FreeAndNIL(FAddresses);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

function TPaperlessEmailAddressArray.GetItems(Index: SmallInt): TAbsPaperlessEmailAddress;
Begin // GetItems
  If (Index >= 0) And (Index < FAddresses.Count) Then
    Result := TAbsPaperlessEmailAddress(FAddresses[Index])
  Else
    Raise Exception.Create ('Invalid Email Address Index');
End; // GetItems

//------------------------------

function TPaperlessEmailAddressArray.GetCount: SmallInt;
Begin // GetCount
  Result := FAddresses.Count;
End; // GetCount

//-------------------------------------------------------------------------

function TPaperlessEmailAddressArray.AddAddress(const Name: cuStr50; const Address: cuStr100): Integer;
Begin // AddAddress
  FAddresses.Add (TPaperlessEmailAddress.Create(Name, Address));
End; // AddAddress

//-------------------------------------------------------------------------

procedure TPaperlessEmailAddressArray.Delete(Index: SmallInt);
Begin // Delete
  If (Index >= 0) And (Index < FAddresses.Count) Then
    FAddresses.Delete(Index)
  Else
    Raise Exception.Create ('Invalid Email Address Index');
End; // Delete

//-------------------------------------------------------------------------

procedure TPaperlessEmailAddressArray.Clear;
Var
  oAddress : TPaperlessEmailAddress;
Begin // Clear
  While (FAddresses.Count > 0) Do
  Begin
    oAddress := TPaperlessEmailAddress(FAddresses[0]);
    oAddress.Free;

    FAddresses.Delete(0);
  End; // While (FAddresses.Count > 0)
End; // Clear

//-------------------------------------------------------------------------

Procedure TPaperlessEmailAddressArray.LoadFromString(TheString : ANSIString);
Var
  sName : ShortString;
  iPos  : SmallInt;
Begin // LoadFromString
  Clear;

  iPos := Pos(';', TheString);
  While (iPos > 0) Do
  Begin
    // Extract Name
    sName := Copy(TheString, 1, iPos-1);
    System.Delete (TheString, 1, iPos);

    iPos := Pos(';', TheString);
    If (iPos > 0) Then
    Begin
      // Extract Address and add into the list
      AddAddress(sName, Copy(TheString, 1, iPos-1));
      System.Delete (TheString, 1, iPos);

      iPos := Pos(';', TheString);
    End; // If (iPos > 0)
  End; // While (iPos > 0) Do
End; // LoadFromString

//------------------------------

Function TPaperlessEmailAddressArray.ToString : ANSIString;
Var
  oAddress : TPaperlessEmailAddress;
  I        : SmallInt;
Begin // ToString
  Result := '';
  If (FAddresses.Count > 0) Then
  Begin
    For I := 0 To (FAddresses.Count - 1) Do
    Begin
      oAddress := TPaperlessEmailAddress(FAddresses[I]);
      Result := Result + Trim(oAddress.eaName) + ';' + Trim(oAddress.eaAddress) + ';';
    End; // For I
  End; // If (FAttachments.Count > 0)
End; // ToString

//=========================================================================

Constructor TPaperlessEmailAttachments.Create;
Begin // Create
  Inherited Create;
  FAttachments := TStringList.Create;
End; // Create

//------------------------------

Destructor TPaperlessEmailAttachments.Destroy;
Begin // Destroy
  FreeAndNIL(FAttachments);
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

function TPaperlessEmailAttachments.GetItems(Index: SmallInt): cuStr255;
Begin // GetItems
  If (Index >= 0) And (Index < FAttachments.Count) Then
    Result := FAttachments[Index]
  Else
    Raise Exception.Create ('Invalid Email Attachment Index');
End; // GetItems
Procedure TPaperlessEmailAttachments.SetItems(Index: SmallInt; Value: cuStr255);
Begin // SetItems
  If (Index >= 0) And (Index < FAttachments.Count) Then
    FAttachments[Index] := Value
  Else
    Raise Exception.Create ('Invalid Email Attachment Index');
End; // SetItems

//------------------------------

function TPaperlessEmailAttachments.GetCount: SmallInt;
Begin // GetCount
  Result := FAttachments.Count
End; // GetCount

//-------------------------------------------------------------------------

function TPaperlessEmailAttachments.Add(const FileName: cuStr255): Integer;
Begin // Add
  FAttachments.Add(Filename);
End; // Add

//-------------------------------------------------------------------------

procedure TPaperlessEmailAttachments.Delete(Index: SmallInt);
Begin // Delete
  If (Index >= 0) And (Index < FAttachments.Count) Then
    FAttachments.Delete(Index)
  Else
    Raise Exception.Create ('Invalid Email Attachment Index');
End; // Delete

//-------------------------------------------------------------------------

procedure TPaperlessEmailAttachments.Clear;
Begin // Clear
  FAttachments.Clear;
End; // Clear

//-------------------------------------------------------------------------

Procedure TPaperlessEmailAttachments.LoadFromString(TheString : ANSIString);
Var
  iPos : SmallInt;
Begin // LoadFromString
  Clear;

  If (Trim(TheString) <> '') Then
  Begin
    // Check for multiple attachments
    iPos := Pos(';', TheString);
    While (iPos > 0) Do
    Begin
      Add(Trim(Copy(TheString, 1, iPos-1)));
      System.Delete (TheString, 1, iPos);
      iPos := Pos(';', TheString);
    End; // While (iPos > 0) Do

    Add(Trim(TheString));
  End; // If (Trim(TheString) <> '')
End; // LoadFromString

//------------------------------

Function TPaperlessEmailAttachments.ToString : ANSIString;
Var
  I : SmallInt;
Begin // ToString
  Result := '';
  If (FAttachments.Count > 0) Then
  Begin
    For I := 0 To (FAttachments.Count - 1) Do
    Begin
      Result := Result + FAttachments[I] + ';'
    End; // For I
  End; // If (FAttachments.Count > 0)
End; // ToString

//=========================================================================

Constructor TPaperlessEmail.Create (hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  EntSys := hEntSys;

  FillChar (FDataRec, SizeOf (FDataRec), #0);
  FillChar (FOrigRec, SizeOf (FOrigRec), #0);

  FToAddresses := TPaperlessEmailAddressArray.Create;
  FCCAddresses := TPaperlessEmailAddressArray.Create;
  FBCCAddresses := TPaperlessEmailAddressArray.Create;
  FAttachments := TPaperlessEmailAttachments.Create;
End;

//------------------------------

Destructor TPaperlessEmail.Destroy;
Begin { Destroy }
  FreeAndNIL(FToAddresses);
  FreeAndNIL(FCCAddresses);
  FreeAndNIL(FBCCAddresses);
  FreeAndNIL(FAttachments);

  EntSys := NIL;

  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TPaperlessEmail.Assign (Const WinId, HandlerId : LongInt; Const ExLocal : TdExLocal);
Var
  I : SmallInt;
Begin { Assign }
  // Set Security Access to Record by hook point location
  Case WinId of
//    wiAccount     : RecAccess := ReadOnly;
//    wiTransaction : RecAccess := ReadOnly;
//    wiBACS        : RecAccess := ReadOnly;
//    wiStock       : RecAccess := ReadOnly;
//    wiStockDetail : RecAccess := ReadOnly;
//    wiSerialBatch : RecAccess := ReadOnly;
//    wiTransLine   : RecAccess := ReadOnly;
//    wiJobRec      : RecAccess := ReadOnly;
//    wiLocation    : RecAccess := ReadOnly;
//    wiStockLoc    : RecAccess := ReadOnly;
    wiPrint       : RecAccess := ReadOnly;
//    wiMisc        : RecAccess := ReadOnly;
//    wiSystemOps   : RecAccess := ReadOnly;
  Else
    RecAccess := NotAvailable;
  End; { If }

  // Data loaded separately by hook point
  FillChar (FDataRec, SizeOf (FDataRec), #0);
  FOrigRec := FDataRec;

  { Adjust Security Access for field by Window and Event }
  If (RecAccess <> NotAvailable) Then Begin
    { Set Default Security options }
    For I := Low(PropAccess) To High(PropAccess) Do
      If (RecAccess = ReadOnly) Then
        PropAccess[I] := paReadOnly
      Else
        PropAccess[I] := paReadWrite;

    { Disable additional functions }
    For I := Low(FuncAccess) To High(FuncAccess) Do
      FuncAccess[I] := pfDisabled;

    //
    // IMPORTANT NOTE: When enabling fields check the Set method for
    //                 the field to ensure the validation is correct
    //

//    Case ((WinId * 1000) + HandlerId) Of
//      103100002  {BrBincode Entry}
//           :   Begin
//                 PropAccess[01] := paReadWrite; {brBincode}
//               end;
//
//    end; {Case..}
  End; { If }
End; { Assign }

//-------------------------------------------------------------------------

Function TPaperlessEmail.GetDataRec : TSBSPrintSetupInfo;
Begin // GetDataRec
  // Update the DataRec
  FDataRec.feEmailTo := FToAddresses.ToString;
  FDataRec.feEmailCC := FCCAddresses.ToString;
  FDataRec.feEmailBCC := FBCCAddresses.ToString;

  FDataRec.feEmailAttach := FAttachments.ToString;

  Result := FDataRec;
End; // GetDataRec
Procedure TPaperlessEmail.SetDataRec(Value : TSBSPrintSetupInfo);
Begin // SetDataRec
  FOrigRec := Value;
  FDataRec := FOrigRec;

  // Load To/CC/BCC lists
  FToAddresses.LoadFromString(FDataRec.feEmailTo);
  FCCAddresses.LoadFromString(FDataRec.feEmailCC);
  FBCCAddresses.LoadFromString(FDataRec.feEmailBCC);

  // Load attachments lists
  FAttachments.LoadFromString(FDataRec.feEmailAttach);
End; // SetDataRec

//-------------------------------------------------------------------------

Function TPaperlessEmail.GetRecStatus : TRecAccessStatus;
Begin
  Result := RecAccess;
End;

//-------------------------------------------------------------------------

Function TPaperlessEmail.GetRecChanged : Boolean;
Begin
  // Need to update DataRec in order to check whether the lists have changed
  GetDataRec;
  Result := RecChanged Or (FOrigRec.feEmailTo <> FDataRec.feEmailTo) Or (FOrigRec.feEmailCC <> FDataRec.feEmailCC) Or
            (FOrigRec.feEmailBCC <> FDataRec.feEmailBCC) Or (FOrigRec.feEmailAttach <> FDataRec.feEmailAttach);
End;

//-------------------------------------------------------------------------

function TPaperlessEmail.GetSenderName: cuStr50;
begin
  If (RecAccess <> NotAvailable) Then
    Result := FDataRec.feEmailFrom
  Else
    EntSys.DataAccessErrDlg(True, EmailRecErrStr + 'emSenderName');
end;
procedure TPaperlessEmail.SetSenderName(Value: cuStr50);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (FDataRec.feEmailFrom <> Value) Then
    Begin
      FDataRec.feEmailFrom := Value;
      RecChanged := True;
    End; // If (FDataRec.feEmailFrom <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, EmailRecErrStr + 'emSenderName');
end;

//------------------------------

function TPaperlessEmail.GetSenderAddress: cuStr50;
begin
  If (RecAccess <> NotAvailable) Then
    Result := FDataRec.feEmailFromAd
  Else
    EntSys.DataAccessErrDlg(True, EmailRecErrStr + 'emSenderAddress');
end;
procedure TPaperlessEmail.SetSenderAddress(Value: cuStr50);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (FDataRec.feEmailFromAd <> Value) Then
    Begin
      FDataRec.feEmailFromAd := Value;
      RecChanged := True;
    End; // If (FDataRec.feEmailFromAd <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, EmailRecErrStr + 'emSenderAddress');
end;

//-----------------------------------

function TPaperlessEmail.GetBCCRecipients: TAbsPaperlessEmailAddressArray;
begin
  If (RecAccess <> NotAvailable) Then
    Result := FBCCAddresses
  Else
    EntSys.DataAccessErrDlg(True, EmailRecErrStr + 'emBCCRecipients');
end;

//-----------------------------------

function TPaperlessEmail.GetCCRecipients: TAbsPaperlessEmailAddressArray;
begin
  If (RecAccess <> NotAvailable) Then
    Result := FCCAddresses
  Else
    EntSys.DataAccessErrDlg(True, EmailRecErrStr + 'emCCRecipients');
end;

//-----------------------------------

function TPaperlessEmail.GetToRecipients: TAbsPaperlessEmailAddressArray;
begin
  If (RecAccess <> NotAvailable) Then
    Result := FToAddresses
  Else
    EntSys.DataAccessErrDlg(True, EmailRecErrStr + 'emToRecipients');
end;

//-----------------------------------

function TPaperlessEmail.GetSubject: cuStr255;
begin
  If (RecAccess <> NotAvailable) Then
    Result := FDataRec.feEmailSubj
  Else
    EntSys.DataAccessErrDlg(True, EmailRecErrStr + 'emSubject');
end;
procedure TPaperlessEmail.SetSubject(Value: cuStr255);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (FDataRec.feEmailSubj <> Value) Then
    Begin
      FDataRec.feEmailSubj := Value;
      RecChanged := True;
    End; // If (FDataRec.feEmailSubj <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, EmailRecErrStr + 'emSubject');
end;

//-----------------------------------

function TPaperlessEmail.GetMessageText: ANSIString;
begin
  If (RecAccess <> NotAvailable) Then
    Result := FDataRec.feEmailMsg
  Else
    EntSys.DataAccessErrDlg(True, EmailRecErrStr + 'emMessageText');
end;
procedure TPaperlessEmail.SetMessageText(Value: ANSIString);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (FDataRec.feEmailMsg <> Value) Then
    Begin
      FDataRec.feEmailMsg := Value;
      RecChanged := True;
    End; // If (FDataRec.feEmailMsg <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, EmailRecErrStr + 'emMessageText');
end;

//------------------------------

function TPaperlessEmail.GetAttachments: TAbsPaperlessEmailAttachments;
begin
  If (RecAccess <> NotAvailable) Then
    Result := FAttachments
  Else
    EntSys.DataAccessErrDlg(True, EmailRecErrStr + 'emAttachments');
end;

//------------------------------

function TPaperlessEmail.GetPriority: TEmailPriority;
begin
  If (RecAccess <> NotAvailable) Then
    Result := TEmailPriority(FDataRec.feEmailPriority)
  Else
    EntSys.DataAccessErrDlg(True, EmailRecErrStr + 'emPriority');
end;
procedure TPaperlessEmail.SetPriority(Value: TEmailPriority);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (FDataRec.feEmailPriority <> Ord(Value)) Then
    Begin
      FDataRec.feEmailPriority := Ord(Value);
      RecChanged := True;
    End; // If (FDataRec.feEmailPriority <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, EmailRecErrStr + 'emPriority');
end;

//------------------------------

function TPaperlessEmail.GetCoverSheet: cuStr8;
begin
  If (RecAccess <> NotAvailable) Then
    Result := FDataRec.feCoverSheet
  Else
    EntSys.DataAccessErrDlg(True, EmailRecErrStr + 'emCoverSheet');
end;
procedure TPaperlessEmail.SetCoverSheet(Value: cuStr8);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (FDataRec.feCoverSheet <> Value) Then
    Begin
      FDataRec.feCoverSheet := Value;
      RecChanged := True;
    End; // If (FDataRec.feCoverSheet <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, EmailRecErrStr + 'emCoverSheet');
end;

//------------------------------

function TPaperlessEmail.GetSendReader: Boolean;
begin
  If (RecAccess <> NotAvailable) Then
    Result := FDataRec.feEmailReader
  Else
    EntSys.DataAccessErrDlg(True, EmailRecErrStr + 'emSendReader');
end;
procedure TPaperlessEmail.SetSendReader(Value: Boolean);
begin
  If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite) Then
  Begin
    If (FDataRec.feEmailReader <> Value) Then
    Begin
      FDataRec.feEmailReader := Value;
      RecChanged := True;
    End; // If (FDataRec.feEmailReader <> Value)
  End // If (RecAccess <> NotAvailable) And (PropAccess[01] = paReadWrite)
  Else
    EntSys.DataAccessErrDlg(False, EmailRecErrStr + 'emSendReader');
end;

//=========================================================================

Constructor TPaperless.Create (Const hEntSys : TEnterpriseSystem);
Begin
  Inherited Create;

  FEmail := TPaperlessEmail.Create(hEntSys);
End;

//-------------------------------------------------------------------------

Destructor TPaperless.Destroy;
Begin { Destroy }
  FreeAndNIL(FEmail);

  Inherited Destroy;
End; { Destroy }

//-------------------------------------------------------------------------

Procedure TPaperless.Assign (Const WinId, HandlerId : LongInt; Const ExLocal : TdExLocal);
Begin { Assign }
  // NOTE: FJob already done from TEnterpriseSystem
  TPaperlessEmail(FEmail).Assign(WinId, HandlerId, ExLocal);
End; { Assign }

//-------------------------------------------------------------------------

Function TPaperless.GetRecChanged : Boolean;
Begin // GetRecChanged
  Result := FEmail.RecChanged;
End; // GetRecChanged

//------------------------------

Function TPaperless.GetEmail : TAbsPaperlessEmail;
Begin // GetEmail
  Result := FEmail;
End; // GetEmail

//=========================================================================

end.
