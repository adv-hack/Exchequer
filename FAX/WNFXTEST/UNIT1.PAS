unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComObj;

const
  WM_FAX = WM_USER + $10;

type
  TFaxThread = class(TThread)
  protected
    procedure Execute; override;
  private
    procedure Post;
  end;

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

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    procedure WMFax(var message : TMessage); message WM_Fax;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  FaxDetails : TFaxDetails;

implementation

{$R *.DFM}


procedure TFaxThread.Post;
begin
  PostMessage(Form1.Handle, WM_FAX, 0, LongInt(@FaxDetails));
end;

procedure TFaxThread.Execute;
begin
  FaxDetails.FaxDocName := 'TEST';
  FaxDetails.FaxNumber := '01202';
  Synchronize(Post);
end;

procedure TForm1.WMFax(var Message : TMessage);
const
  ResNames : Array[0..4] of PChar = ('FAXBTRV',
                                     'OpenFaxFileWithPath',
                                     'CloseFaxFile',
                                     'InsertFaxDetails',
                                     'GetUniqueRef');
Var
  OpenFaxFileWithPath : function (DisplayError : boolean; Path : shortstring) : boolean; stdcall;
  CloseFaxFile        : procedure;
  InsertFaxDetails    : function (Details : PFaxDetails) : longint;
  GetUniqueRef        : function : shortstring;
  MyGSRHandle         : THandle;
  DLLAddr              : TFarProc;
  Info                 : PFaxDetails;
  TmpStr               : ShortString;
  Res                  : LongInt;
  PDllPath             : ANSIString;
  Result : integer;

  FFaxDir : ShortString;
  FDocName : ShortString;
  FPriority : Char;
  FRecipName : ShortString;
  FRecipNumber : ShortString;
  FSenderName : ShortString;
  FSenderNumber : ShortString;
  FUserDesc : ShortString;
Begin { TEntFaxInt.StoreDetails }
  Result := 3;

  Info := PFaxDetails(Message.lParam);

  { Load FAXBTRV.DLL dynamically }
  PDllPath := 'x:\fax\compiled\faxbtrv.dll';
  MyGSRHandle := LoadLibrary(PCHAR(PDllPath));

  Try
    If (MyGSRHandle > HInstance_Error) Then Begin
      { Get Handle of open proc }
      OpenFaxFileWithPath := GetProcAddress(MyGSRHandle, ResNames[1]);
      If Assigned(OpenFaxFileWithPath) then Begin
        { Get handle of close proc }
        CloseFaxFile := GetProcAddress(MyGSRHandle, ResNames[2]);
        If Assigned(CloseFaxFile) then Begin
          { Get handle of instert procedure }
          InsertFaxDetails := GetProcAddress(MyGSRHandle, ResNames[3]);
          If Assigned(InsertFaxDetails) then Begin
            { Get handle of function to privide a unique reference }
            GetUniqueRef := GetProcAddress(MyGSRHandle, ResNames[4]);
            If Assigned(GetUniqueRef) then Begin
              { Open file }
              If OpenFaxFileWithPath (True, 'x:\fax\compiled\') Then Begin
                { Generate unique document name }
                TmpStr := GetUniqueRef + ' ';

{                New(Info);
                FillChar (Info^, SizeOf(Info^), #0);
                With Info^ Do Begin
                  FaxDocName       := Copy (FDocName, 1, 31); // 31=maximum chars in RPPro title string

                  FaxNumber        := '01202';
                  FaxPriority      := 'N';
                  FaxUserDesc      := 'FUserDesc';
                  FaxSenderName    := 'FSenderName';
                  FaxRecipientName := 'FRecipName';
                  FaxSenderEmail   := 'FSenderNumber';
                End; { With }

                { Insert fax details into DB }
                Res := InsertFaxDetails(Info);

                If (Res = 0) Then
                  { AOK }
                  Result := 0
                Else Begin
                  { Bad things Have Happened }
                  Result := 1;
                  //ShowMessage ('Error: ' + IntToStr(Res));
                End; { Else }

{                Dispose(Info);}

                { Close Faxing database }
                CloseFaxFile;
              End; { If }

              GetUniqueRef := Nil;
            End; { If }

            InsertFaxDetails := Nil;
          End; { If }

          CloseFaxFile := Nil;
        End; { If }

        OpenFaxFileWithPath := Nil;
      End; { If }

      { Unload library }
{      FreeLibrary(_MyGSRHandle);
      _MyGSRHandle:=0;}
    End; { If }
  Except
{    FreeLibrary(_MyGSRHandle);
    _MyGSRHandle:=0;}
  End;
  Print;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  oWinFax : Variant;
begin
  try
    oWinFax := CreateOleObject('WinFax.SDKSend');
  except
    ShowMessage('Could not create a WinFax.SDKSend API object');
    Exit;
  end;{try}

  try
    oWinFax.SetCountryCode('');
    oWinFax.SetAreaCode('');
    oWinFax.SetNumber('01202 298001');
    oWinFax.SetTo('');
    oWinFax.AddRecipient;

    oWinFax.SetSubject('Fax from Exchequer');
    oWinFax.SetPreviewFax(0);
    oWinFax.SetUseCover(0);

    oWinFax.SetPrintFromApp(1);
    oWinFax.Send(0);
    Print;
  except
    ShowMessage('An error occured communicating with the WinFax.SDKSend API object');
  end;{try}
end;

procedure TForm1.Button2Click(Sender: TObject);
const
  ResNames : Array[0..4] of PChar = ('FAXBTRV',
                                     'OpenFaxFileWithPath',
                                     'CloseFaxFile',
                                     'InsertFaxDetails',
                                     'GetUniqueRef');
Var
  OpenFaxFileWithPath : function (DisplayError : boolean; Path : shortstring) : boolean; stdcall;
  CloseFaxFile        : procedure;
  InsertFaxDetails    : function (Details : PFaxDetails) : longint;
  GetUniqueRef        : function : shortstring;
  MyGSRHandle         : THandle;
  DLLAddr              : TFarProc;
  Info                 : PFaxDetails;
  TmpStr               : ShortString;
  Res                  : LongInt;
  PDllPath             : ANSIString;
  Result : integer;

  FFaxDir : ShortString;
  FDocName : ShortString;
  FPriority : Char;
  FRecipName : ShortString;
  FRecipNumber : ShortString;
  FSenderName : ShortString;
  FSenderNumber : ShortString;
  FUserDesc : ShortString;
Begin { TEntFaxInt.StoreDetails }
  Result := 3;


  { Load FAXBTRV.DLL dynamically }
  PDllPath := 'x:\fax\compiled\faxbtrv.dll';
  MyGSRHandle := LoadLibrary(PCHAR(PDllPath));

  Try
    If (MyGSRHandle > HInstance_Error) Then Begin
      { Get Handle of open proc }
      OpenFaxFileWithPath := GetProcAddress(MyGSRHandle, ResNames[1]);
      If Assigned(OpenFaxFileWithPath) then Begin
        { Get handle of close proc }
        CloseFaxFile := GetProcAddress(MyGSRHandle, ResNames[2]);
        If Assigned(CloseFaxFile) then Begin
          { Get handle of instert procedure }
          InsertFaxDetails := GetProcAddress(MyGSRHandle, ResNames[3]);
          If Assigned(InsertFaxDetails) then Begin
            { Get handle of function to privide a unique reference }
            GetUniqueRef := GetProcAddress(MyGSRHandle, ResNames[4]);
            If Assigned(GetUniqueRef) then Begin
              { Open file }
              If OpenFaxFileWithPath (True, 'x:\fax\compiled\') Then Begin
                { Generate unique document name }
                TmpStr := GetUniqueRef + ' ';

                New(Info);
                FillChar (Info^, SizeOf(Info^), #0);
                With Info^ Do Begin
                  FaxDocName       := Copy (FDocName, 1, 31); // 31=maximum chars in RPPro title string

                  FaxNumber        := '01202';
                  FaxPriority      := 'N';
                  FaxUserDesc      := 'FUserDesc';
                  FaxSenderName    := 'FSenderName';
                  FaxRecipientName := 'FRecipName';
                  FaxSenderEmail   := 'FSenderNumber';
                End; { With }

                { Insert fax details into DB }
                Res := InsertFaxDetails(Info);

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
                CloseFaxFile;
              End; { If }

              GetUniqueRef := Nil;
            End; { If }

            InsertFaxDetails := Nil;
          End; { If }

          CloseFaxFile := Nil;
        End; { If }

        OpenFaxFileWithPath := Nil;
      End; { If }

      { Unload library }
{      FreeLibrary(_MyGSRHandle);
      _MyGSRHandle:=0;}
    End; { If }
  Except
{    FreeLibrary(_MyGSRHandle);
    _MyGSRHandle:=0;}
  End;
  Print;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  FaxThread : TFaxThread;
begin
  FaxThread := TFaxThread.create(FALSE);
end;

end.
