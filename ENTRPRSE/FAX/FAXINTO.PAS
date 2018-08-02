unit FaxIntO;

interface

Uses Classes, Dialogs, SysUtils, Windows, RpDevice;

// Force word alignment off
{$A-}

Type
  TFaxDetails = record
    // Keys ...
    FaxDocName       : string[80];  // Document name as would appear in print spooler
    FaxAPFName       : string[12];  // DOS 8.3 File name; extension = APF
    FaxUserName      : string[20];  // This is the Login Name of the user

    // Other data ...
    FaxCancel        : boolean;     // = true => don't send fax and delete associated *.APF
    FaxHold          : boolean;     // = true => Hold Fax
    FaxNumber        : string[20];  // Fax number to dial
    FaxPriority      : char;        // 'N'ormal, 'U'rgent, 'O'ff-peak (see below)
    FaxUserDesc      : string[80];  // User's description of the document
    FaxFinishTime    : TDateTime;   // Time fax finished / failed sending
    FaxSenderName    : string[40];  //
    FaxRecipientName : string[40];  //
    FaxSenderEmail   : string[100]; // E-mail address of fax sender for notification
    FaxErrorCode     : longint;
    FaxBusyRetries   : Byte;     // Retry Fax Later (time specified by user)
                                    // e.g. 10 means 10 retries left to do
  end;
  PFaxDetails = ^TFaxDetails;

  TEntFaxInt = Class(TObject)
  Private
    FFaxDir : ShortString;
    FDocName : ShortString;
    FPriority : Char;
    FRecipName : ShortString;
    FRecipNumber : ShortString;
    FSenderName : ShortString;
    FSenderNumber : ShortString;
    FUserDesc : ShortString;

    Procedure SetFaxDir (Value : ShortString);
    Procedure SetPriority (Value : Char);
  Public
    Property fxFaxDir : ShortString Read FFaxDir Write SetFaxDir;

    Property fxDocName : ShortString Read FDocName Write FDocName;

    Property fxPriority : Char Read FPriority Write SetPriority;

    Property fxRecipName : ShortString Read FRecipName Write FRecipName;
    Property fxRecipNumber : ShortString Read FRecipNumber Write FRecipNumber;

    Property fxSenderName : ShortString Read FSenderName Write FSenderName;
    Property fxSenderEmail : ShortString Read FSenderNumber Write FSenderNumber;

    Property fxUserDesc : ShortString Read FUserDesc Write FUserDesc;

    Constructor Create;
    Destructor Destroy; Override;

    Procedure InitFromPrnInfo (Const PrnInfo : TSBSPrintSetupInfo);

    { Sends the email: 0=OK, 1=Error Storing Details, 3=DLL Not Found }
    Function StoreDetails : SmallInt;
  End; { TEntFaxInt }


implementation

Uses FileUtil;   // x:\entrprse\funcs\

Constructor TEntFaxInt.Create;
Begin { TEntFaxInt.Create }
  Inherited Create;

  FDocName      := '';
  FRecipName    := '';
  FRecipNumber  := '';
  FSenderName   := '';
  FSenderNumber := '';
  FPriority     := 'N'; { Normal }
  FUserDesc     := '';
End; { TEntFaxInt.Create }


Destructor TEntFaxInt.Destroy;
Begin { TEntFaxInt.Destroy }

  Inherited Destroy;
End; { TEntFaxInt.Destroy }


Function TEntFaxInt.StoreDetails : SmallInt;
Const
// HM 01/10/02: Added IFNDEF for Form Printing Toolkit support - otherwise crashes badly
{$IFNDEF NOSHMEM}
  // Use ShareMem'd version
  ResNames : Array[0..4] of PChar = ('FAXBTRV',
{$ELSE}
  // Use version without ShareMem
  ResNames : Array[0..4] of PChar = ('FAXBTRV2',
{$ENDIF}
                                     'OpenFaxFileWithPath',
                                     'CloseFaxFile',
                                     'InsertFaxDetails',
                                     'GetUniqueRef');
Var
  _OpenFaxFileWithPath : function (DisplayError : boolean; Path : shortstring) : boolean; stdcall;
  _CloseFaxFile        : procedure;
  _InsertFaxDetails    : function (Details : PFaxDetails) : longint;
  _GetUniqueRef        : function : shortstring;
  _MyGSRHandle         : THandle;
  DLLAddr              : TFarProc;
  Info                 : PFaxDetails;
  TmpStr               : ShortString;
  Res                  : LongInt;
  PDllPath             : ANSIString;
Begin { TEntFaxInt.StoreDetails }
  Result := 3;


  { Load FAXBTRV.DLL dynamically }
  PDllPath := FFaxDir + ResNames[0];
  _MyGSRHandle := LoadLibrary(PCHAR(PDllPath));

  Try
    If (_MyGSRHandle > HInstance_Error) Then Begin
      { Get Handle of open proc }
      _OpenFaxFileWithPath := GetProcAddress(_MyGSRHandle, ResNames[1]);
      If Assigned(_OpenFaxFileWithPath) then Begin
        { Get handle of close proc }
        _CloseFaxFile := GetProcAddress(_MyGSRHandle, ResNames[2]);
        If Assigned(_CloseFaxFile) then Begin
          { Get handle of instert procedure }
          _InsertFaxDetails := GetProcAddress(_MyGSRHandle, ResNames[3]);
          If Assigned(_InsertFaxDetails) then Begin
            { Get handle of function to privide a unique reference }
            _GetUniqueRef := GetProcAddress(_MyGSRHandle, ResNames[4]);
            If Assigned(_GetUniqueRef) then Begin
              { Open file }
              If _OpenFaxFileWithPath (True, FFaxDir) Then Begin
                { Generate unique document name }
                TmpStr := _GetUniqueRef + ' ';
                Insert (TmpStr, FDocName, 1);

                New(Info);
                FillChar (Info^, SizeOf(Info^), #0);
                With Info^ Do Begin
                  FaxDocName       := Copy (FDocName, 1, 31); // 31=maximum chars in RPPro title string

                  FaxNumber        := FRecipNumber;
                  FaxPriority      := FPriority;
                  FaxUserDesc      := FUserDesc;
                  FaxSenderName    := FSenderName;
                  FaxRecipientName := FRecipName;
                  FaxSenderEmail   := FSenderNumber;
                End; { With }

                { Insert fax details into DB }
                Res := _InsertFaxDetails (Info);

                If (Res = 0) Then
                  { AOK }
                  Result := 0
                Else Begin
                  { Bad things Have Happened }
                  Result := 1;
                  //ShowMessage ('Error: ' + IntToStr(Res));
                End; { Else }

                Dispose(Info);

                { Close Faxing database }
                _CloseFaxFile;
              End; { If }

              _GetUniqueRef := Nil;
            End; { If }

            _InsertFaxDetails := Nil;
          End; { If }

          _CloseFaxFile := Nil;
        End; { If }

        _OpenFaxFileWithPath := Nil;
      End; { If }

      { Unload library }
      FreeLibrary(_MyGSRHandle);
      _MyGSRHandle:=0;
    End; { If }
  Except
{    FreeLibrary(_MyGSRHandle);
    _MyGSRHandle:=0;}
  End;
End; { TEntFaxInt.StoreDetails }


Procedure TEntFaxInt.SetFaxDir (Value : ShortString);
Begin { TEntFaxInt.SetFaxDir }
  // HM 28/02/02: Completely rewrote for proper support of Relative Paths
  FFaxDir := CalcEnterpriseFaxingDirectory (Value);

  (****
  Value := UpperCase(Trim(Value));

  If (FFaxDir <> Value) Then Begin
    FFaxDir := Value;

    If (Length(FFaxDir) > 0) Then Begin
      If (FFaxDir[Length(FFaxDir)] <> '\') Then
        FFaxDir := FFaxDir + '\';
    End; { If }
  End; { If }
  *****)
End; { TEntFaxInt.SetFaxDir }

Procedure TEntFaxInt.SetPriority (Value : Char);
Begin { TEntFaxInt.SetPriority }
  If (Value In ['N', 'O', 'U']) Then Begin
    FPriority := Value;
  End; { If }
End; { TEntFaxInt.SetPriority }

Procedure TEntFaxInt.InitFromPrnInfo (Const PrnInfo : TSBSPrintSetupInfo);
Begin { TEntFaxInt.InitFromPrnInfo }
  With PrnInfo Do Begin
    Case feFaxPriority Of
      0 : FPriority := 'U';   // Urgent
      1 : FPriority := 'N';   // Normal
      2 : FPriority := 'O';   // Off-Peak
    End; { Case }
  End; { With }
End; { TEntFaxInt.InitFromPrnInfo }

end.
