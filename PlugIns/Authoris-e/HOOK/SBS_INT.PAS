unit sbs_int;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Forms, Graphics, Windows, Messages, Classes, Enterprise04_TLB, ComObj, dllInt,
  GlobType, RpDevice;

{$I EXCHDLL.INC}


const

  WM_PrintProgress = WM_USER + $101;   { Also in Splash1U.Pas }
  WM_PrintAbort    = WM_USER + $102;
  WM_InPrint       = WM_USER + $103;   { Also in Splash1U.Pas }

type
  Str255  =  String[255];


function InitSBS(Form : TForm; const DataPath : ShortString) : Boolean;
procedure DeInitSBS;

function AddJob(Key : longint; const OurRef, FormName : ShortString) : Boolean;

Function PrintToEmail (P           : Pointer;
                       PSize       : LongInt;
                       ToRecip     : PChar;
                       CCRecip     : PChar;
                       BCCRecip    : PChar;
                       MsgText     : PChar;
                       Attachments : PChar;
                       UseMapi     : Boolean) : SmallInt;

function DefFormName(WhichForm : SmallInt) : string;

function InitDefForm(const DataPath : string) : Boolean;
procedure EndDefForm;


implementation

uses
  SysUtils, AuthObjs, UseDllU, AuthVar;

var
  ALog : TStringList;

procedure LogIt(const s : string);
begin
{$IFDEF DEBUGLOG}
  ALog.Add(s);
{$ENDIF}
end;

Function pfFind_DefaultPrinter(DefName  :  Str255)  :  Integer;

Var
  n, i         :  Integer;
  FoundOk   :  Boolean;

Begin
  LogIt('Start pfFind_DefaultPrinter');
  FoundOk:=False;
  i := Length(DefName);
  For n:=0 to Pred(RpDev.Printers.Count) do
  Begin
//  FoundOk:=(CheckKey(DefName,RpDev.Printers[n],Length(DefName),BOff)) and (DefName<>'');
    FoundOk:=(Copy(UpperCase(Trim(DefName)), 1, i) =
              Copy(UpperCase(Trim(RpDev.Printers[n])), 1, i)) and (DefName<>'');

    If (FoundOk) then
      Break;
  end;
  LogIt('After Printers.Count');

  If (FoundOk) then
    Result:=n
  else
    If (RpDev.Printers.Count>0) then
      Result:=RpDev.DeviceIndex
    else
      Result:=-1;
  LogIt('End pfFind_DefaultPrinter');
end;


function DefFormName(WhichForm : SmallInt) : string;
var
  TheRec : TDefaultFormRecType;
  Res : SmallInt;
begin
  LogIt('Start DefFormName');

  Fillchar(TheRec, SizeOf(TheRec), #0);
  TheRec.dfFormNo := WhichForm;
  TheRec.dfCheckGlobal := True;
  Res := EX_DEFAULTFORM(@TheRec, SizeOf(TheRec));
  if Res = 0 then
    Result := TheRec.dfFormName
  else
    Result := '';
  LogIt('End DefFormName');
end;





function InitSBS(Form : TForm; const DataPath : ShortString) : Boolean;
var
  CRTab : Boolean;
  SystemInfo : SystemInfoType;
begin
  LogIt('Start InitSBS');

            CRTab := False;
            With SystemInfo Do Begin
              ExVersionNo      := 11;
              MainForm         := Form;
              AppHandle        := Application;
              ExDataPath       := DataPath;
              ControllerHandle := Nil;
              DefaultFont      := Nil;
              FormDesVer       := '';
              DebugOpen        := False;
              AppPrinter       := Nil;
            End; { With }
            Result := sbsForm_Initialise(SystemInfo, CRTab);
    LogIt('End InitSBS');
end;

procedure DeInitSBS;
begin
  sbsForm_DeInitialise;
end;

function AddJob(Key : longint; const OurRef, FormName : ShortString ) : Boolean;
var
  PBatch :  PrintBatchRecType;

begin
  LogIt('Start AddJob');

  with PBatch do
  begin
    pbDefMode   := 1;              { Mode of form }
    pbEFDName   := FormName;       { 8 char name of EFD file }
    pbMainFNum  := 2;              { Number of table driving file }
    pbMainKPath := 2;              { key of table driving file}
    pbMainKRef  := OurRef;         { key to match for table }
    pbTablFNum  := 3;              { Number of table driving file }
    pbTablKPath := 0;              { key of table driving file}
    pbTablKRef  := '****';
    Move (Key, pbTablKRef[1], 4); { Folio Number }
    pbDescr     := 'Email Authorisation Request';               { Description displayed on error }

    pbLabel1    := 0;
    pbLbCopies  := 1;
    pbTestMode  := False;

    FillChar(pbRepInfo, SizeOf(BatchRepInfoType), #0);
  End; { PrintBatchRecType }

  Result :=  PrintBatch_AddJob(PBatch);
  Logit('End AddJob');
end;


Function PrintToEmail (P           : Pointer;
                       PSize       : LongInt;
                       ToRecip     : PChar;
                       CCRecip     : PChar;
                       BCCRecip    : PChar;
                       MsgText     : PChar;
                       Attachments : PChar;
                       UseMapi     : Boolean) : SmallInt;
Var
  lEmailInfo : ^TEmailPrintInfoType;
  lPrnInfo   : TSBSPrintSetupInfo;
  SigFile    : TStrings;
  RdrText    : AnsiString;
  FName      : ShortString;
  OK         : Boolean;
  PJ         : IPrintJob;
  Res : longint;
  x : Double;
Begin
  LogIt('Start PrintToEmail');
  x := 0;
  Result:=0;
  PJ := nil;




  // Check pointer is assigned and correctly sized
  If Assigned(P) and (PSize = Sizeof(TEmailPrintInfoType)) Then
  Begin
    // Check Paperless Module is available
      lEmailInfo := P;

      // Validate email Details
      OK := (Trim(ToRecip) <> '');
      If (Not Ok) Then Result := 2001;

      If OK Then Begin
        OK := (Trim(lEmailInfo.emSenderName) <> '');
        If (Not Ok) Then Result := 2002;
      End; { If OK }

      If OK Then Begin
        OK := (Trim(lEmailInfo.emSenderAddr) <> '');
        If (Not Ok) Then Result := 2003;
      End; { If OK }

      If OK Then Begin
        OK := (Trim(lEmailInfo.emSubject) <> '');
        If (Not Ok) Then Result := 2004;
      End; { If OK }

      If OK Then Begin
        OK := (lEmailInfo.emPriority >= 0) And (lEmailInfo.emPriority <= 2);
        If (Not Ok) Then Result := 2005;
      End; { If OK }

      If OK Then Begin
        OK := (lEmailInfo.emSendReader >= 0) And (lEmailInfo.emSendReader <= 2);
        If (Not Ok) Then Result := 2006;
      End; { If OK }

      If OK Then Begin
        // Check SBSFORM.DLL is loaded and happy
            {$OPTIMIZATION OFF}
            // Bug Fix - sometime get Access Violation - this fixes it!
          { RPDev.DeviceIndex := RPDev.DeviceIndex;}
            {$OPTIMIZATION ON}

            RdrText := '';
(*         If (lEmailinfo^.emSendReader = 2) Then Begin
              // Load Reader Text to be inserted into start of message text
              FName := IncludeTrailingBackSlash(SetDrive) + PathMaster + 'reader.txt';
              If FileExists (FName) Then Begin
                SigFile := TStringList.Create;
                Try
                  SigFile.LoadFromFile(FName);

                  RdrText := SigFile.Text;
                Finally
                  SigFile.Destroy;
                End;
              End; { If }
            End; { If (lEmailinfo^.emSendReader = 2) } *)

            // Build TSBSPrintSetupInfo structure for Print job
            FillChar (lPrnInfo, SizeOf(lPrnInfo), #0);
            With lPrnInfo Do Begin
            feDisablePrnStatus := True;
            DevIdx := pfFind_DefaultPrinter(AttachPrinter);
//              DevIdx := RpDev.DeviceIndex; //Default printer
            {  with FToolkit.Transaction as ITransaction2 do
              begin
                SavePosition;
                Res := GetFirst;
                while (PJ = nil) and (Res = 0) do
                begin
                  PJ := Print(thpmDefault);
                  if Assigned(PJ) then
                    DevIdx := PJ.pjFileInfo.fiAttachmentPrinterIndex
                  else
                    Res := GetNext;
                end;
                PJ := nil;
              end;}
              FormNo := 0;
              FormName := '';
              BinNo := 0;
              BinName := '';
              Preview := (lEmailInfo^.emPreview);     { True = Preview, False = Print }
              NoCopies := 1;                             { Copies of form to print }
              pbLabel1 := 1;                    { N/A }  { Start of Label 1 Pos }
              TestMode := False;                { N/A }  { Indicates test mode }
              LabelMode := False;               { N/A }  { Tells PrntFrm Label Mode }
              ChequeMode := False;              { N/A }  { Enables Cheque No processing fields }
              fePrintMethod := 2;                        { Flag: 0=Printer, 1=Fax, 2=Email, 3=XML } {*en431 XML}
              feBatch := False;                          { Flag: Printing a batch - disable To details as specified later }

              feCoverSheet := lEmailinfo^.emCoversheet;  { Cover Sheet }

              feEmailMAPI     := UseMapi;  { Email: Send using MAPI }
              feEmailFrom     := lEmailinfo^.emSenderName;       { Email: From Name }
              feEmailFromAd   := lEmailinfo^.emSenderAddr;       { Email: From Address }
              feEmailTo       := ToRecip;                        { Email: To Name;Addr;Name;Addr; ... }
              feEmailCc       := CCRecip;
              feEmailBcc      := BCCRecip;
              feEmailSubj     := lEmailinfo^.emSubject;          { Email: Subject }
              feEmailMsg      := RdrText + MsgText;              { Email: Message (max 10k from v4.31.004) }
              feEmailAttach   := Attachments;                    { Email: Attachments (for future use - maybe) }
              feEmailPriority := lEmailinfo^.emPriority;         { Email: Priority - 0=Low, 1=Normal, 2=High }
              feEmailReader   := (lEmailinfo^.emSendReader <> 0);{ Email: Attach Acrobat/Exchequer Reader }
              if lEmailinfo^.emCompress then
                feEmailZIP    := 2
              else
                feEmailZip    := 0;         { Email: ZIP Attachment as self-extracting .EXE }
              LogIt('About to set feEmailAtType');
              feEmailAtType   := FToolkit.SystemSetup.ssPaperless.ssAttachMethod;{ Email: Attachment methodology:- 0-RPPro, 1-Adobe }
              LogIt('After set feEmailAtType');
            End; { With lPrnInfo }

            LogIt('About to call PrintBatch_Print');
//            Result := Trunc(10 / x);
            if not PrintBatch_Print('abcdefgh', lPrnInfo) then
            begin
              LogIt('After call PrintBatchPrint - Failure');
              Result := 1008
            end
            else
            begin
              LogIt('After call PrintBatchPrint - About to call PrintBatch_ClearBatch');
              PrintBatch_ClearBatch;
              LogIt('After call ClearBatch');
            end;
      End; { If OK }
    End; { If }

End; { Ex_PrintToEmail }


function InitDefForm(const DataPath : string) : Boolean;
begin
  Result := EX_INITPRINTFORM(PChar(DataPath)) = 0;
end;

procedure EndDefForm;
begin
  EX_ENDPRINTFORM;
end;

procedure SaveLog;
var
  Path : PChar;
  s : string;
begin
  Path := StrAlloc(255);
  GetWindowsDirectory(Path, 255);
  s := strPas(Path);
  ALog.SaveToFile(IncludeTrailingBackslash(s) + 'Authorise.Log');
  StrDispose(Path);
end;

{$IFDEF DEBUGLOG}

Initialization
  ALog := TStringList.Create;

Finalization
  SaveLog;
  ALog.Free;
{$ENDIF}
end.
