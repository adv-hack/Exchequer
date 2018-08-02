unit sbs_int;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Forms, Graphics, Windows, Messages, Classes, Enterprise01_TLB, ComObj, dllInt,
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

Function PrintToFile (P, P2       : Pointer;
                      PSize       : LongInt;
                      AttType     : Byte) : SmallInt;


implementation

uses
  SysUtils;




function InitSBS(Form : TForm; const DataPath : ShortString) : Boolean;
var
  CRTab : Boolean;
  SystemInfo : SystemInfoType;
begin
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
end;

procedure DeInitSBS;
begin
  sbsForm_DeInitialise;
end;

function AddJob(Key : longint; const OurRef, FormName : ShortString ) : Boolean;
var
  PBatch :  PrintBatchRecType;

begin
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
    pbDescr     := 'Sentimail Attachment';               { Description displayed on error }

    pbLabel1    := 0;
    pbLbCopies  := 1;
    pbTestMode  := False;

    FillChar(pbRepInfo, SizeOf(BatchRepInfoType), #0);
  End; { PrintBatchRecType }

  Result :=  PrintBatch_AddJob(PBatch);
end;


Function PrintToFile (P, P2       : Pointer;
                      PSize       : LongInt;
                      AttType     : Byte) : SmallInt;
Var
  lEmailInfo : ^TEmailPrintInfoType;
  lPrnInfo   : TSBSPrintSetupInfo;
  SigFile    : TStrings;
  RdrText    : AnsiString;
  FName      : ShortString;
  OK         : Boolean;
Begin
  Result:=0;

  // Check pointer is assigned and correctly sized
  If Assigned(P) and (PSize = Sizeof(TEmailPrintInfoType)) Then
  Begin
    // Check Paperless Module is available
      lEmailInfo := P;

      // Validate email Details
      OK := True;
      If OK Then
      Begin
        // Check SBSFORM.DLL is loaded and happy
            {$OPTIMIZATION OFF}
            // Bug Fix - sometime get Access Violation - this fixes it!
          { RPDev.DeviceIndex := RPDev.DeviceIndex;}
            {$OPTIMIZATION ON}

            RdrText := '';

            // Build TSBSPrintSetupInfo structure for Print job
            FillChar (lPrnInfo, SizeOf(lPrnInfo), #0);
            With lPrnInfo Do
            Begin

              DevIdx := RpDev.DeviceIndex; //Default printer
              FormNo := 0;
              FormName := '';
              BinNo := 0;
              BinName := '';
              Preview := False;     { True = Preview, False = Print }
              NoCopies := 1;                             { Copies of form to print }
              pbLabel1 := 1;                    { N/A }  { Start of Label 1 Pos }
              TestMode := False;                { N/A }  { Indicates test mode }
              LabelMode := False;               { N/A }  { Tells PrntFrm Label Mode }
              ChequeMode := False;              { N/A }  { Enables Cheque No processing fields }
              fePrintMethod := 4;                        { Flag: 0=Printer, 1=Fax, 2=Email, 3=XML } {*en431 XML}
              feBatch := False;
              if AttType in [1, 2] then                          { Flag: Printing a batch - disable To details as specified later }
                feEmailZIP    := 0
              else
                feEmailZip := 2;
              feEmailAtType := AttType;


 //             feCoverSheet := Coversheet;  { Cover Sheet }
              feDataPtr := P2;

(*              feEmailMAPI     := UseMapi;  { Email: Send using MAPI }
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
              {if lEmailinfo^.emCompress then
                feEmailZIP    := 2
              else
                feEmailZip    := 0;         { Email: ZIP Attachment as self-extracting .EXE }
              feEmailAtType   := {SyssEDI2^.EDI2Value.emAttchMode}0;{ Email: Attachment methodology:- 0-RPPro, 1-Adobe }
            End; { With lPrnInfo } *)

            if not PrintBatch_Print('abcdefgh', lPrnInfo) then
              Result := 1008
            else
              PrintBatch_ClearBatch;
          end;
      End; { If OK }
    End; { If }

End; { Ex_PrintToEmail }






end.
