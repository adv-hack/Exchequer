{*********************************************************}
{*                   APFGEN.PAS 4.01                     *}
{*      Copyright (c) TurboPower Software 1998-2001      *}
{*                 All rights reserved.                  *}
{*********************************************************}


Library ApfGen;
  {- APF Printer Driver front-end which works with generic APD applications}

{.$DEFINE DebugApfGen}

{$IFDEF Win32}
  !! 16-bit printer driver.  Must be compiled with Delphi 1.0 !!
  !! This is because the printing subsystem in Win9x/ME is 16 bit
{$ENDIF}

{$IFNDEF PRNDRV}
  !! Define PRNDRV in  Options | Project | Directories/Conditionals
  !! this will reduce the size of the driver
{$ENDIF}

{.$I AwDefine.Inc}
{$C MOVEABLE DISCARDABLE DEMANDLOAD}
{$I-,S-}

{$D DDRV APFGEN}      {! The module name must be in this format !}
{$R APFGEN}

uses 
  Messages,
  SysUtils,
  ShellApi,
  WinProcs,
  WinTypes,
  OoMisc,
  ApfPDEng,
  LFN;

type
  PUserInstanceData = ^TUserInstanceData;
  TUserInstanceData =
    record
      docName   : array[0..255] of Char;  { print job description }
      faxFile   : array[0..255] of Char;  { remember the filename }
    end;

{$IFDEF DebugApfGen}
var
  DebugFile : TextFile;
{$ENDIF}

function MyStartJobCallback (var uiData : Pointer;
                             JobDescription : PChar;
                             Filename : PChar) : Boolean; Far;
var
  tempfilename : PChar;
  strbuffer    : ^String;

begin
  MyStartJobCallback := False;
  Filename^ := #0;
  {$IFDEF DebugApfGen}
  Assign(DebugFile, 'C:\APFGEN.LOG');
  if FileExists('C:\APFGEN.LOG') then begin
    Append(DebugFile);
    WriteLn(DebugFile, '-----------------');
  end else
    Rewrite(DebugFile);
  WriteLn(DebugFile, DateTimeToStr(Now), ' MyStartJobCallback');
  WriteLn(DebugFile, '  ', JobDescription);
  {$ENDIF}

  {allocate the user instance data}
  GetMem(uiData, sizeof(TUserInstanceData));
  if uiData = nil then
    exit;

  {copy the job name to the instance data}
  StrCopy(PUserInstanceData(uiData)^.docName, JobDescription);

  { generate a unique temporary filename }
  with PUserInstanceData(uiData)^ do begin
    GetMem(strbuffer, 256);
    StrPCopy(faxFile, 'c:\default.apf');
    { fully qualify the temp file and erase file with 'tmp' extension }
    strbuffer^ := StrPas(faxFile);
    strbuffer^ := ExpandFilename(strbuffer^);
    DeleteFile(strbuffer^);
    strbuffer^ := ChangeFileExt(strbuffer^, '.' +
    DefApfExt);
    StrPCopy(filename, strbuffer^);
    StrCopy(faxFile, filename);

    MyStartJobCallback := (strbuffer^ <> '');
    FreeMem(strbuffer, 256);
  end;
end;

procedure CopyFile(const Source,Target : string);
const
  BufferSize = 4096;
type
  TBuffer = array[0..pred(BufferSize)] of byte;
  PBuffer = ^TBuffer;
var
  Buffer : PBuffer;
  SF,TF : ^File;
  BytesRead : Integer;
begin
  {$IFDEF DebugApfGen}
  WriteLn(DebugFile, 'Entering CopyFile(' + Source + ', ' + Target);
  {$ENDIF}

  SF := nil;
  TF := nil;
  Buffer := nil;
  New(SF);
  New(TF);
  New(Buffer);
  try
    AssignFile(SF^,Source);
    Reset(SF^,1);
    AssignFile(TF^,Target);
    Rewrite(TF^,1);
    BlockRead(SF^,Buffer^,sizeof(Buffer^),BytesRead);
    while BytesRead > 0 do begin
      BlockWrite(TF^,Buffer^,BytesRead);
      BlockRead(SF^,Buffer^,sizeof(Buffer^),BytesRead);
    end;
    CloseFile(SF^);
    CloseFile(TF^);
  finally
    if Assigned(Buffer) then
      Dispose(Buffer);
    if Assigned(TF) then
      Dispose(TF);
    if Assigned(SF) then
      Dispose(SF);
  end;
end;

function IsWin95 : Boolean;
var
  L : Word;
begin
  L := LoWord(GetVersion);
  Result := (LoByte(L) > 3) or (HiByte(L) >= 95);
  {$IFDEF DebugApfGen}
  if Result then
    WriteLn(DebugFile, 'IsWin95: yes')
  else begin
    WriteLn(DebugFile, 'IsWin95: no, LoByte=' + IntToStr(LoByte(L)) +
      ', HiByte=' + IntToStr(HiByte(L)));
  end;
  {$ENDIF}
end;

const
  Busy : Boolean = False;
var
  Short,Long,TmpFileName,NewPath : string;

procedure RenameCopy95(NewFileNameS,OldFileNameS : PString);
var
  i : Integer;
begin
  if Busy then
    repeat
      SafeYield;
    until not Busy;
  Busy := True;
  LFNDeleteFile(NewFileNameS^,False,0,0);
  NewPath := ExtractFilePath(NewFileNameS^);
  {$IFDEF DebugApfGen}
  WriteLn(DebugFile, 'RenameCopy95(New:', NewFileNameS^, ', Old:', OldFileNameS^);
  WriteLn(DebugFile, '  NewPath=', NewPath);
  {$ENDIF}
  LFNGetShortPath(False,NewPath,Short);
  LFNGetLongPath(False,NewPath,Long);
  {$IFDEF DebugApfGen}
  WriteLn(DebugFile, '  ShortPath:', Short);
  WriteLn(DebugFile, '  LongPath:', Long);
  {$ENDIF}
  i := 0;
  repeat
    inc(i);
    TmpFileName := format('%s$$%d.$$$',[Short,i]);
  until not FileExists(TmpFileName);
  CopyFile(OldFileNameS^,TmpFileName);
  NewFileNameS^ := ExtractFileName(NewFileNameS^);
  AppendStr(Long,NewFileNameS^);
  {$IFDEF DebugApfGen}
  WriteLn(DebugFile, '  NewFileNameS^: ', NewFileNameS^);
  WriteLn(DebugFile, '  TmpFileName: ', TmpFileName);
  WriteLn(DebugFile, '  Long: ', Long);
  {$ENDIF}
  if LFNRename(TmpFileName,Long) <> 0 then begin
    { couldn't rename the file using long-file name support}
    { do it the old-fashioned way }
    DeleteFile(TmpFileName);
    if not RenameFile(OldFileNameS^,NewFileNameS^) then begin
            DeleteFile(NewFileNameS^);
            CopyFile(OldFileNameS^,NewFileNameS^);
            DeleteFile(OldFileNameS^);
          end;
  end;
  Busy := False;
end;

function MyEndJobCallback (var uiData : Pointer;
                           JobCompletedNormally : Boolean) : Boolean; Far;
const
  AllocSize = 256;
  RetryCount = 1024;
var
  AppHandle   : THandle;
  b           : Integer;
  NewFileName : pChar;
  NewFileNameS: PString;
  OldFileNameS: PString;
  AppName     : pChar;
  Msg         : TMsg;
  Retries     : Integer;
  ShellHandle : Integer;
  ShellName   : PString;

begin
  {$IFDEF DebugApfGen}
  Write(DebugFile, 'MyEndJobCallback: ');
  if JobCompletedNormally then
    WriteLn(DebugFile, 'Job completed normally')
  else
    WriteLn(DebugFile, 'Job did not complete normally');
  {$ENDIF}

  with PUserInstanceData(uiData)^ do begin
    if not JobCompletedNormally then
      { delete the aborted or bad fax file }
      DeleteFile(StrPas(faxFile))
    else begin

      { Stack space is again an issue, so put temporary pchars on the heap }

      GetMem(NewFileName, 256);
      New(NewFileNameS);
      New(OldFileNameS);
      { see if the TApdFaxConverter is doing an idShell conversion }
      {  using GetPrivateProfileString 'cuz GetPrivateProfileInt could overflow }
      { using AppName as a temp container for the shell handle }
      GetMem(AppName,256);
      ShellHandle := GetPrivateProfileString(ApdIniSection,'ShellHandle',
        '-1',AppName,255,ApdIniFileName);
      ShellHandle := StrToIntDef(StrPas(AppName), -1);
      {$IFDEF DebugApfGen}
      WriteLn(DebugFile, 'Shell handle (AppName): ' , AppName);
      WriteLn(DebugFile, 'ShellHandle: ', ShellHandle);
      {$ENDIF}
      { done with our AppName temp usage }
      FreeMem(AppName,256);
      if ShellHandle = -1 then begin
        { not doing an idShell conversion, spawn the app and generate the events }
        AppHandle := FindWindow('TPUtilWindow', ApdPipeName);
        {$IFDEF DebugApfGen}
        if AppHandle = 0 then
          WriteLn(DebugFile, 'TPUtilWindow not found');
        {$ENDIF}

        if AppHandle = 0 then begin
          GetMem(AppName,256);
          GetPrivateProfileString(ApdIniSection,ApdIniKey,'',AppName,
            256,ApdIniFileName);

          if AppName[0] <> #0 then begin
            {$IFDEF DebugApfGen}
            WriteLn(DebugFile, 'Trying to exec ', AppName);
            {$ENDIF}
            ShellExecute(0, nil, AppName, nil, '', sw_ShowNormal);
            {Retries := RetryCount;}
            Retries := GetPrivateProfileInt(ApdIniSection,'Timeout',
              RetryCount, ApdIniFileName);
            {$IFDEF DebugApfGen}
            WriteLn(DebugFile, 'Retries: ', Retries);
            {$ENDIF}
            repeat
              AppHandle := FindWindow('TPUtilWindow', ApdPipeName);
              if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
                if Msg.Message = wm_Quit then
                  begin
                    PostQuitMessage(Msg.WParam);
                    break;
                  end
                else begin
                  TranslateMessage(Msg);
                  DispatchMessage(Msg);
                end;
              dec(Retries);
            until (AppHandle <> 0) or (Retries <= 0);
          end;
          FreeMem(AppName,256);
        end;

        if AppHandle <> 0 then begin
          {$IFDEF DebugApfGen}
          WriteLn(DebugFile, 'TPUtilWindow found');
          WriteLn(DebugFile, '  Generating OnDocStart');
          {$ENDIF}

          SetWindowText(AppHandle,PUserInstanceData(uiData)^.docName);
          SendMessage(AppHandle,apw_BeginDoc,0,0);
          GetWindowText(AppHandle,NewFileName,255);
          NewFileNameS^ := StrPas(NewFileName);
          OldFileNameS^ := StrPas(faxFile);
          {$IFDEF DebugApfGen}
          WriteLn(DebugFile, '  NewFileName: ', NewFileName);
          {$ENDIF}

          if UpperCase(NewFileNameS^) <> UpperCase(OldFileNameS^) then

            if IsWin95 then begin
              RenameCopy95(NewFileNameS,OldFileNameS);
              DeleteFile(OldFileNameS^);
            end else if not RenameFile(OldFileNameS^,NewFileNameS^) then begin
              DeleteFile(NewFileNameS^);
              CopyFile(OldFileNameS^,NewFileNameS^);
              DeleteFile(OldFileNameS^);
            end;

          {$IFDEF DebugApfGen}
          WriteLn(DebugFile, '  Generating OnDocEnd');
          WriteLn(DebugFile, 'File saved to:', NewFileNameS^);
          {$ENDIF}

          SendMessage(AppHandle,apw_EndDoc,0,0);
          SetWindowText(AppHandle,ApdPipeName);
        {$IFNDEF DebugApfGen}
        end;
        {$ELSE}
        end else
          WriteLn(DebugFile, 'File saved to:', FaxFile);
        {$ENDIF}
      end else begin
        { the TApdFaxConverter is doing an idShell conversion }
        GetPrivateProfileString(ApdIniSection,'ShellName',ApdDefFileName,
          NewFileName,255,ApdIniFileName);
        NewFileNameS^ := StrPas(NewFileName);
        OldFileNameS^ := StrPas(faxFile);
        {$IFDEF DebugApfGen}
        WriteLn(DebugFile, '  NewFileName from idShell: ', NewFileName);
        {$ENDIF}
        {we're done with the shell stuff, kill it from the ini file }
        WritePrivateProfileString(ApdIniSection, 'ShellHandle', '',      {!!.01}
          ApdIniFileName);                                               {!!.01}
        WritePrivateProfileString(ApdIniSection, 'ShellName', '',        {!!.01}
          ApdIniFileName);                                               {!!.01}
        WritePrivateProfileString('', '', '', ApdIniFileName);           {!!.01}

        if UpperCase(NewFileNameS^) <> UpperCase(OldFileNameS^) then

          if IsWin95 then begin
            RenameCopy95(NewFileNameS,OldFileNameS);
            DeleteFile(OldFileNameS^);
          end else if not RenameFile(OldFileNameS^,NewFileNameS^) then begin
            DeleteFile(NewFileNameS^);
            CopyFile(OldFileNameS^,NewFileNameS^);
            DeleteFile(OldFileNameS^);
          end;

        {$IFDEF DebugApfGen}
        WriteLn(DebugFile, 'File saved to:', NewFileNameS^);
        WriteLn(DebugFile, 'Posting message to fax converter (' +
          IntToStr(ShellHandle) + ')');
        {$ENDIF}
      end;
      Dispose(OldFileNameS);
      Dispose(NewFileNameS);
      FreeMem(NewFileName,256);
    end;
  end;

  { dispose of UserInstanceData record }
  FreeMem(uiData, sizeof(TUserInstanceData));
  uiData := nil;
  {$IFDEF DebugApfGen}
  Close(DebugFile);
  {$ENDIF}
  MyEndJobCallback := True;
end;

{---------------------------------------------------------------------}
{ Export entry points (by ordinal)                                    }
{---------------------------------------------------------------------}

exports
  DevBitBlt               index 1,
  ColorInfo               index 2,
  Control                 index 3,
  Disable                 index 4,
  Enable                  index 5,
  EnumDFonts              index 6,
  EnumObj                 index 7,
  Output                  index 8,
  Pixel                   index 9,
  RealizeObject           index 10,
  StrBlt                  index 11,
  ScanLR                  index 12,
  DeviceMode              index 13,
  DevExtTextOut           index 14,
  DevGetCharWidth         index 15,
  DeviceBitmap            index 16,
  FastBorder              index 17,
  SetAttribute            index 18,
  DIBBlt                  index 19,
  CreateDIBitmap          index 20,
  SetDIBitsToDevice       index 21,
  StretchBlt              index 27,
  StretchDIB              index 28,
  ExtDeviceMode           index 90,
  DeviceCapabilities      index 91,
  AdvancedSetupDialog     index 93,
  DevInstall              index 94,
  ExtDeviceModePropSheet  index 95,
  fnDump                  index 100;

begin
  StartJobCallback := MyStartJobCallback;
  EndJobCallback := MyEndJobCallback;
  StrCopy(ModuleName, 'APFGEN');
end.

