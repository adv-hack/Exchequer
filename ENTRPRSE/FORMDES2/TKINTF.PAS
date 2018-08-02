// Toolkit DLL Printing Interface Structures & Routines
unit TKIntf;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

{$IF Defined(EXDLL)}
Uses RPDevice;
{$IFEND}

Type
  TTKDLLPrintBatchInfo = Record
    tkDevIdx          : LongInt;          { DeviceIndex in RpDev }

    tkFormNo          : LongInt;          { Windows Form Id }
    tkFormName        : String[255];      { Windows Form Description }

    tkBinNo           : LongInt;          { Windows Bin Id }
    tkBinName         : String[255];      { Windows Bin Description }

    { Vars used internally in printing routines - not part of RpDev }
    tkPreview         : Boolean;          { True = Preview, False = Print }
    tkNoCopies        : SmallInt;         { Copies of form to print }
    tkpbLabel1        : SmallInt;         { Start of Label 1 Pos }
    tkTestMode        : Boolean;          { Indicates test mode }
    tkLabelMode       : Boolean;          { Tells PrntFrm Label Mode }
    tkChequeMode      : Boolean;          { Enables Cheque No processing fields }
    tkfePrintMethod   : Byte;             { Flag: 0=Printer, 1=Fax, 2=Email, 3=XML, 4=File } {*en431 XML}
    tkfeBatch         : Boolean;          { Flag: Printing a batch - disable To details as specified later }
    tkfeTypes         : LongInt;          { Flag: 2=Allow Fax, 4=AllowEmail, 8=AllowXML }

    tkfeCoverSheet    : String[8];        { Cover Sheet }

    tkfeFaxMethod     : Byte;             { Fax: Send method:- 0=Exchequer, 1=MAPI,  }
    tkfeFaxPrinter    : SmallInt;         { Fax: Selected Printer }
    tkfeFaxFrom       : String[50];       { Fax: From Name }
    tkfeFaxFromNo     : String[30];       { Fax: From Fax Number }
    tkfeFaxTo         : String[50];       { Fax: To Name }
    tkfeFaxToNo       : String[30];       { Fax: To Fax Number }
    tkfeFaxMsg        : PChar;            { Fax: Message (max 255) }

    tkfeEmailMAPI     : Boolean;          { Email: Send using MAPI }
    tkfeEmailFrom     : String[50];       { Email: From Name }
    tkfeEmailFromAd   : String[50];       { Email: From Address }
    tkfeEmailTo       : PChar;            { Email: Name }
    tkfeEmailToAddr   : PChar;            { Email: Addr}
    tkfeEmailCc       : PChar;
    tkfeEmailBcc      : PChar;
    tkfeEmailSubj     : PChar;            { Email: Subject }
    tkfeEmailMsg      : PChar;            { Email: Message (max 255) }
    tkfeEmailAttach   : PChar;            { Email: Attachments (for future use - maybe) }
    tkfeEmailPriority : Byte;             { Email: Priority - 0=Low, 1=Normal, 2=High }
    tkfeEmailReader   : Boolean;          { Email: Attach Acrobat/Exchequer Reader }
    tkfeEmailZIP      : Byte;             { Email: ZIP Attachment as self-extracting .EXE }
    tkfeEmailAtType   : Byte;             { Email: Attachment methodology:- 0-RPPro, 1-Adobe, 2-RAVE PDF, 3-RAVE HTML }

    tkfeJobtitle      : String[80];       { Job title for Exchequer Faxing }

    tkfeFaxPriority   : Byte;             { Fax: Priority:- 0=Urgent, 1=Normal, 2=OffPeak }

    {*en431 XML}
    tkfeXMLType       : Byte;             { XML Method: 0=File, 1=Email }
    tkfeXMLCreateHTML : Boolean;          { XML: Also create HTML file }
    tkfeXMLFileDir    : PChar;            { XML: Path to save .XML File in }

    { HM 30/01/01: added new field to store the intelligent name for form attachments }
    tkfeEmailFName    : String[30];   { Email form attachment name }

    // HM 20/11/01: Added support for User Profiles
    tkfeUserId        : String[10];

    tkSpare           : Array [1..1000] Of Byte;  {*en431 XML}
  End; { TTKDLLPrintBatchInfo }

{$IF Defined(EXDLL)}     // Toolkit DLL
  // Returns an initialised TTKDLLPrintBatchInfo structure with PChars allocated, etc...
  Function InitTKDLLBatch (Const WinTitle : ShortString; Const PrnInfo : TSBSPrintSetupInfo) : TTKDLLPrintBatchInfo;

  // Reverses InitTKDLLBatch when the structure is finished - de-allocates PChars, etc...
  Procedure DeInitTKDLLBatch (Var TKBatch : TTKDLLPrintBatchInfo);
{$IFEND}

{$IF Defined(EDLL2)}     // SBSForm2.Dll
  Function TKDLL_PrintBatch (Const pPrnBatch : Pointer) : Boolean; StdCall; Export;
{$IFEND}

implementation

{$IF Defined(EXDLL)}

Uses SysUtils;

// Returns an initialised TTKDLLPrintBatchInfo structure with PChars allocated, etc...
Function InitTKDLLBatch (Const WinTitle : ShortString; Const PrnInfo : TSBSPrintSetupInfo) : TTKDLLPrintBatchInfo;
Begin { InitTKDLLBatch }
  FillChar (Result, SizeOf(Result), #0);
  With Result, PrnInfo Do Begin
    tkDevIdx    := DevIdx;      { DeviceIndex in RpDev }

    tkFormNo    := FormNo;      { Windows Form Id }
    tkFormName  := FormName;    { Windows Form Description }

    tkBinNo     := BinNo;       { Windows Bin Id }
    tkBinName   := BinName;     { Windows Bin Description }

    { Vars used internally in printing routines - not part of RpDev }
    tkPreview         := Preview;        { True = Preview, False = Print }
    tkNoCopies        := NoCopies;       { Copies of form to print }
    tkpbLabel1        := pbLabel1;       { Start of Label 1 Pos }
    tkTestMode        := TestMode;       { Indicates test mode }
    tkLabelMode       := LabelMode;      { Tells PrntFrm Label Mode }
    tkChequeMode      := ChequeMode;     { Enables Cheque No processing fields }
    tkfePrintMethod   := fePrintMethod;  { Flag: 0=Printer, 1=Fax, 2=Email, 3=XML, 4=File } {*en431 XML}
    tkfeBatch         := feBatch;        { Flag: Printing a batch - disable To details as specified later }
    tkfeTypes         := feTypes;        { Flag: 2=Allow Fax, 4=AllowEmail, 8=AllowXML }

    tkfeCoverSheet    := feCoverSheet;   { Cover Sheet }

    tkfeFaxMethod     := feFaxMethod;    { Fax: Send method:- 0=Exchequer, 1=MAPI,  }
    tkfeFaxPrinter    := feFaxPrinter;   { Fax: Selected Printer }
    tkfeFaxFrom       := feFaxFrom;      { Fax: From Name }
    tkfeFaxFromNo     := feFaxFromNo;    { Fax: From Fax Number }
    tkfeFaxTo         := feFaxTo;        { Fax: To Name }
    tkfeFaxToNo       := feFaxToNo;      { Fax: To Fax Number }
    tkfeFaxMsg        := StrAlloc(1024); { Fax: Message (max 255) }
    StrPCopy (tkfeFaxMsg, feFaxMsg);     { Fax: Message (max 255) }

    tkfeEmailMAPI     := feEmailMAPI;          { Email: Send using MAPI }
    tkfeEmailFrom     := feEmailFrom;          { Email: From Name }
    tkfeEmailFromAd   := feEmailFromAd;        { Email: From Address }
    tkfeEmailTo       := StrAlloc(1024);       { Email: Name }
    StrPCopy (tkfeEmailTo, feEmailTo);         { Email: Name }
    tkfeEmailToAddr   := StrAlloc(1024);       { Email: Addr}
    StrPCopy (tkfeEmailToAddr, feEmailToAddr); { Email: Addr}
    tkfeEmailCc       := StrAlloc(1024);
    StrPCopy (tkfeEmailCc, feEmailCc);
    tkfeEmailBcc      := StrAlloc(1024);
    StrPCopy (tkfeEmailBcc, feEmailBcc);
    tkfeEmailSubj     := StrAlloc(1024);       { Email: Subject }
    StrPCopy (tkfeEmailSubj, feEmailSubj);     { Email: Subject }
    tkfeEmailMsg      := StrAlloc(1024);       { Email: Message (max 255) }
    StrPCopy (tkfeEmailMsg, feEmailMsg);       { Email: Message (max 255) }
    tkfeEmailAttach   := StrAlloc(1024);       { Email: Attachments (for future use - maybe) }
    StrPCopy (tkfeEmailAttach, feEmailAttach); { Email: Attachments (for future use - maybe) }
    tkfeEmailPriority := feEmailPriority;      { Email: Priority - 0=Low, 1=Normal, 2=High }
    tkfeEmailReader   := feEmailReader;        { Email: Attach Acrobat/Exchequer Reader }
    tkfeEmailZIP      := feEmailZIP;           { Email: ZIP Attachment as self-extracting .EXE }
    tkfeEmailAtType   := feEmailAtType;        { Email: Attachment methodology:- 0-RPPro, 1-Adobe, 2-RAVE PDF, 3-RAVE HTML }

    tkfeJobtitle      := feJobtitle;         { Job title for Exchequer Faxing }

    tkfeFaxPriority   := feFaxPriority;      { Fax: Priority:- 0=Urgent, 1=Normal, 2=OffPeak }

    {*en431 XML}
    tkfeXMLType       := feXMLType;          { XML Method: 0=File, 1=Email }
    tkfeXMLCreateHTML := feXMLCreateHTML;    { XML: Also create HTML file }
    tkfeXMLFileDir    := StrAlloc(1024);     { XML: Path to save .XML File in }
    StrPCopy (tkfeXMLFileDir, feXMLFileDir); { XML: Path to save .XML File in }

    { HM 30/01/01: added new field to store the intelligent name for form attachments }
    tkfeEmailFName    := feEmailFName;     { Email form attachment name }

    // HM 20/11/01: Added support for User Profiles
    tkfeUserId        := feUserId;
  End; { With Result }
End; { InitTKDLLBatch }

// Reverses InitTKDLLBatch when the structure is finished - de-allocates PChars, etc...
Procedure DeInitTKDLLBatch (Var TKBatch : TTKDLLPrintBatchInfo);
Begin { DeInitTKDLLBatch }
  With TKBatch Do Begin
    StrDispose (tkfeFaxMsg);        { Fax: Message (max 255) }
    StrDispose (tkfeEmailTo);       { Email: Name }
    StrDispose (tkfeEmailToAddr);   { Email: Addr}
    StrDispose (tkfeEmailCc);
    StrDispose (tkfeEmailBcc);
    StrDispose (tkfeEmailSubj);     { Email: Subject }
    StrDispose (tkfeEmailMsg);      { Email: Message (max 255) }
    StrDispose (tkfeEmailAttach);   { Email: Attachments (for future use - maybe) }
    StrDispose (tkfeXMLFileDir);    { XML: Path to save .XML File in }
  End; { With TKBatch }
End; { DeInitTKDLLBatch }

{$IFEND}

{$IF Defined(EDLL2)}

Uses RpDevice, PrintU;

//---------------------------------------------------------------------------

// Copies to data from a Toolkit PrintInfo structure to the FormDes TSBSPrintSetupInfo structure
Function TKInfoToFDesInfo (Const pTKInfo : Pointer; Var WinTitle : ShortString) : TSBSPrintSetupInfo;
Var
  TKInfo : ^TTKDLLPrintBatchInfo;
Begin { TKInfoToFDesInfo }
  // Dereference Pointer for access to structure
  TKInfo := pTKInfo;

  // Copy details across into standard TSBSPrintSetupInfo structure
  FillChar (Result, SizeOf(Result), #0);
  With Result, TKInfo^ Do Begin
    DevIdx    := tkDevIdx;      { DeviceIndex in RpDev }

    FormNo    := tkFormNo;      { Windows Form Id }
    FormName  := tkFormName;    { Windows Form Description }

    BinNo     := tkBinNo;       { Windows Bin Id }
    BinName   := tkBinName;     { Windows Bin Description }

    { Vars used internally in printing routines - not part of RpDev }
    Preview         := tkPreview;        { True = Preview, False = Print }
    NoCopies        := tkNoCopies;       { Copies of form to print }
    pbLabel1        := tkpbLabel1;       { Start of Label 1 Pos }
    TestMode        := tkTestMode;       { Indicates test mode }
    LabelMode       := tkLabelMode;      { Tells PrntFrm Label Mode }
    ChequeMode      := tkChequeMode;     { Enables Cheque No processing fields }
    fePrintMethod   := tkfePrintMethod;  { Flag: 0=Printer, 1=Fax, 2=Email, 3=XML, 4=File } {*en431 XML}
    feBatch         := tkfeBatch;        { Flag: Printing a batch - disable To details as specified later }
    feTypes         := tkfeTypes;        { Flag: 2=Allow Fax, 4=AllowEmail, 8=AllowXML }

    feCoverSheet    := tkfeCoverSheet;   { Cover Sheet }

    feFaxMethod     := tkfeFaxMethod;    { Fax: Send method:- 0=Exchequer, 1=MAPI,  }
    feFaxPrinter    := tkfeFaxPrinter;   { Fax: Selected Printer }
    feFaxFrom       := tkfeFaxFrom;      { Fax: From Name }
    feFaxFromNo     := tkfeFaxFromNo;    { Fax: From Fax Number }
    feFaxTo         := tkfeFaxTo;        { Fax: To Name }
    feFaxToNo       := tkfeFaxToNo;      { Fax: To Fax Number }
    feFaxMsg        := tkfeFaxMsg;       { Fax: Message (max 255) }

    feEmailMAPI     := tkfeEmailMAPI;    { Email: Send using MAPI }
    feEmailFrom     := tkfeEmailFrom;    { Email: From Name }
    feEmailFromAd   := tkfeEmailFromAd;  { Email: From Address }
    feEmailTo       := tkfeEmailTo;      { Email: Name }
    feEmailToAddr   := tkfeEmailToAddr;  { Email: Addr}
    feEmailCc       := tkfeEmailCc;
    feEmailBcc      := tkfeEmailBcc;
    feEmailSubj     := tkfeEmailSubj;      { Email: Subject }
    feEmailMsg      := tkfeEmailMsg;       { Email: Message (max 255) }
    feEmailAttach   := tkfeEmailAttach;    { Email: Attachments (for future use - maybe) }
    feEmailPriority := tkfeEmailPriority;  { Email: Priority - 0=Low, 1=Normal, 2=High }
    feEmailReader   := tkfeEmailReader;    { Email: Attach Acrobat/Exchequer Reader }
    feEmailZIP      := tkfeEmailZIP;       { Email: ZIP Attachment as self-extracting .EXE }
    feEmailAtType   := tkfeEmailAtType;    { Email: Attachment methodology:- 0-RPPro, 1-Adobe, 2-RAVE PDF, 3-RAVE HTML }

    feJobtitle      := tkfeJobtitle;       { Job title for Exchequer Faxing }

    feFaxPriority   := tkfeFaxPriority;    { Fax: Priority:- 0=Urgent, 1=Normal, 2=OffPeak }

    {*en431 XML}
    feXMLType       := tkfeXMLType;        { XML Method: 0=File, 1=Email }
    feXMLCreateHTML := tkfeXMLCreateHTML;  { XML: Also create HTML file }
    feXMLFileDir    := tkfeXMLFileDir;     { XML: Path to save .XML File in }

    { HM 30/01/01: added new field to store the intelligent name for form attachments }
    feEmailFName    := tkfeEmailFName;     { Email form attachment name }

    // HM 20/11/01: Added support for User Profiles
    feUserId        := tkfeUserId;
  End; { With Result }
End; { TKInfoToFDesInfo }

//---------------------------------------------------------------------------

Function TKDLL_PrintBatch (Const pPrnBatch : Pointer) : Boolean; Export;
Var
  WinTitle : ShortString;
  PrnInfo  : TSBSPrintSetupInfo;
Begin { TKDLL_PrintBatch }
  // Convert Toolkit format info into standard format info
  PrnInfo := TKInfoToFDesInfo (pPrnBatch, WinTitle);

  // Call standard function to print the batch
  Result := PrintBatch_Print (WinTitle, PrnInfo);
End; { TKDLL_PrintBatch }

//---------------------------------------------------------------------------

{$IFEND}

end.
