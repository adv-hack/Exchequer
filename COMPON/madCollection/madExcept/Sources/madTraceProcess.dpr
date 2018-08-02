program madTraceProcess;

// dontTouchUses  <- this tells madExcept to not touch the uses clause

uses madExcept, madLinkDisAsm, Windows, Messages, SysUtils, Forms, Buttons,
     Controls, StdCtrls, ExtCtrls, Graphics, Math, madStrings, madKernel,
     madTypes, Clipbrd, madRemote, ComObj, ActiveX;

{$R madExcept.res}

function Choice(title, msg: AnsiString; const choices: array of AnsiString) : integer;
const mcHorzMargin  =  20; mcVertMargin   = 14; mcHorzSpacing   = 20; mcVertSpacing  = 20;
      mcButtonWidth = 120; mcButtonHeight = 33; mcButtonSpacing = 14; mcButtonMargin = 24;
var HorzMargin, VertMargin, VertSpacing, ButtonWidth, ButtonHeight, ButtonSpacing, ButtonMargin : cardinal;
    form        : TForm;
    c1          : cardinal;
    buffer      : array [0..51] of AnsiChar;
    DialogUnits : TPoint;
    pan1,pan2   : TPanel;
    i1,i2,i3    : integer;
    s1          : AnsiString;
    cx,cy       : cardinal;
    TextRect    : TRect;
    columns     : array of record
                    left  : integer;
                    width : integer;
                  end;
begin
  result := -1;
  form := TForm.CreateNew(Application);
  with form do
    try
      Canvas.Font   := Font;
      for c1 := 0 to 25 do buffer[c1     ] := AnsiChar(c1 + ord('A'));
      for c1 := 0 to 25 do buffer[c1 + 26] := AnsiChar(c1 + ord('a'));
      GetTextExtentPointA(Canvas.Handle, buffer, 52, TSize(DialogUnits));
      DialogUnits.X := DialogUnits.X div 52;
      BorderStyle   := bsDialog;
      Caption       := string(title);
      Position      := poScreenCenter;
      KeyPreview    := true;
      HorzMargin    := MulDiv(mcHorzMargin,    DialogUnits.X,  8);
      VertMargin    := MulDiv(mcVertMargin,    DialogUnits.Y, 16);
      VertSpacing   := MulDiv(mcVertSpacing,   DialogUnits.Y, 16);
      ButtonWidth   := MulDiv(mcButtonWidth,   DialogUnits.X,  8);
      ButtonHeight  := MulDiv(mcButtonHeight,  DialogUnits.Y, 16);
      ButtonSpacing := MulDiv(mcButtonSpacing, DialogUnits.X,  8);
      ButtonMargin  := MulDiv(mcButtonMargin,  DialogUnits.X, 16);
      SetRect(TextRect, 0, 0, Screen.Width div 2, 0);
      DrawTextA(Canvas.Handle, PAnsiChar(msg), -1, TextRect, DT_CALCRECT or DT_WORDBREAK);
      SetLength(columns,(length(choices)*(17+integer(VertMargin) div 4)*2 div Screen.Height)+1);
      i2 := (length(choices) + length(columns) - 1) div length(columns);
      for i1 := low(choices) to high(choices) do
        with columns[i1 div i2] do
          width := max(width, Canvas.TextWidth(string(choices[i1])) + integer(HorzMargin) * 3 div 2);
      i3 := 0;
      for i1 := 0 to high(columns) do begin
        columns[i1].left := i3;
        inc(i3, columns[i1].width + integer(HorzMargin));
      end;
      if TextRect.Right > i3 - integer(HorzMargin) then begin
        if TextRect.Right > Screen.Width div 2 then begin
          TextRect.Bottom := 0;
          DrawTextA(Canvas.Handle, PAnsiChar(msg), -1, TextRect, DT_CALCRECT or DT_WORDBREAK);
        end;
      end else
        TextRect.Right := i3 - integer(HorzMargin);
      ClientWidth := Max(TextRect.Right + integer(HorzMargin) * 2,
                         ButtonWidth * 2 + ButtonSpacing + HorzMargin + 4);
      i3 := (ClientWidth - integer(HorzMargin) * 2 - (i3 - integer(HorzMargin))) div Length(columns);
      if i3 > 0 then
        for i1 := 0 to high(columns) do begin
          if i1 > 0 then
            inc(columns[i1].left, i3);
          inc(columns[i1].width, i3);
        end;
      pan1 := TPanel.Create(form);
      with pan1 do begin
        Parent     := form;
        Caption    := '';
        Align      := alTop;
        bevelInner := bvLowered;
      end;
      with TLabel.Create(form) do begin
        Parent     := pan1;
        WordWrap   := True;
        Caption    := string(msg);
        BoundsRect := TextRect;
        SetBounds(HorzMargin, VertMargin + 1, TextRect.Right, TextRect.Bottom);
      end;
      cy := 0;
      i3 := 0;
      for i1 := 0 to high(choices) do
        with TRadioButton.Create(form) do begin
          Name      := string('Radio' + IntToStrEx(i1));
          Parent    := pan1;
          tag       := i1;
          Caption   := string(choices[i1]);
          if i1 = 0 then
            Checked := true;
          if i1 mod i2 = 0 then
            cy := cardinal(TextRect.Bottom) + VertMargin + VertSpacing;
          SetBounds(integer(HorzMargin) + Columns[i1 div i2].left, cy, Columns[i1 div i2].width, Height);
          inc(cy, cardinal(Height) + VertMargin div 4);
          i3 := max(i3, cy);
        end;
      cy := i3 + integer(VertMargin);
      pan1.Height := cy;
      cy := cy + ButtonMargin;
      cx := cardinal(ClientWidth) - ButtonWidth * 2 - ButtonSpacing - HorzMargin div 2 - 2;
      pan2 := TPanel.Create(form);
      with pan2 do begin
        Parent     := form;
        Caption    := '';
        Align      := alClient;
        BevelOuter := bvNone;
      end;
      with TBitBtn.Create(form) do begin
        Parent      := pan2;
        Kind        := bkOK;
        Default     := true;
        ModalResult := mrOk;
        Caption     := '&OK';
        SetBounds(cx, ButtonMargin, ButtonWidth, ButtonHeight);
        Inc(cx, ButtonWidth + ButtonSpacing);
      end;
      with TBitBtn.Create(form) do begin
        Parent      := pan2;
        Kind        := bkAbort;
        Cancel      := true;
        ModalResult := mrAbort;
        TabStop     := false;
        Caption     := '&Abort';
        SetBounds(cx, ButtonMargin, ButtonWidth, ButtonHeight);
      end;
      ClientHeight := cy + ButtonHeight + ButtonMargin;
      Left := (Screen.Width  - Width ) div 2;
      Top  := (Screen.Height - Height) div 2;
      if ShowModal = mrOk then
        for i1 := 0 to ComponentCount - 1 do
          if posTextIs1('Radio', Components[i1].Name) and
             (Components[i1] as TRadioButton).Checked then begin
            result := Components[i1].tag;
            break;
          end;
    finally Free end;
end;

procedure EnableAllPrivileges;
type TTokenPrivileges = record
       PrivilegeCount : dword;
       Privileges     : array [0..maxInt shr 4 - 1] of TLUIDAndAttributes;
     end;
var c1, c2 : dword;
    i1     : integer;
    ptp    : ^TTokenPrivileges;
begin
  if OpenProcessToken(windows.GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, c1) then
    try
      c2 := 0;
      GetTokenInformation(c1, TokenPrivileges, nil, 0, c2);
      if c2 <> 0 then begin
        ptp := pointer(LocalAlloc(LPTR, c2 * 2));
        if GetTokenInformation(c1, TokenPrivileges, ptp, c2 * 2, c2) then begin
          // enabling backup/restore privileges breaks Explorer's Samba support
          for i1 := 0 to integer(ptp^.PrivilegeCount) - 1 do
            ptp^.Privileges[i1].Attributes := ptp^.Privileges[i1].Attributes or SE_PRIVILEGE_ENABLED;
          AdjustTokenPrivileges(c1, false, PTokenPrivileges(ptp)^, c2, PTokenPrivileges(nil)^, cardinal(pointer(nil)^));
        end;
        LocalFree(dword(ptp));
      end;
    finally CloseHandle(c1) end;
end;

type
  ICatalog = interface(IDispatch)
    ['{6EB22870-8A19-11D0-81B6-00A0C9231C29}']
    function  GetCollection(const bstrCollName: WideString): IDispatch; safecall;
    function  Connect(const bstrConnectString: WideString): IDispatch; safecall;
  end;
  ICatalogCollection = interface(IDispatch)
    ['{6EB22872-8A19-11D0-81B6-00A0C9231C29}']
    function  Get__NewEnum: IUnknown; safecall;
    function  Get_Item(lIndex: Integer): IDispatch; safecall;
    function  Get_Count: Integer; safecall;
    procedure Remove(lIndex: Integer); safecall;
    function  Add: IDispatch; safecall;
    procedure Populate; safecall;
    function  SaveChanges: Integer; safecall;
    function  GetCollection(const bstrCollName: WideString; varObjectKey: OleVariant): IDispatch; safecall;
    function  Get_Name: OleVariant; safecall;
    function  Get_AddEnabled: WordBool; safecall;
    function  Get_RemoveEnabled: WordBool; safecall;
    function  GetUtilInterface: IDispatch; safecall;
    function  Get_DataStoreMajorVersion: Integer; safecall;
    function  Get_DataStoreMinorVersion: Integer; safecall;
    procedure PopulateByKey(aKeys: pointer); safecall;
    procedure PopulateByQuery(const bstrQueryString: WideString; lQueryType: Integer); safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Item[lIndex: Integer]: IDispatch read Get_Item;
    property Count: Integer read Get_Count;
  end;
  ICatalogObject = interface(IDispatch)
    ['{6EB22871-8A19-11D0-81B6-00A0C9231C29}']
    function  Get_Value(const bstrPropName: WideString): OleVariant; safecall;
    procedure Set_Value(const bstrPropName: WideString; retval: OleVariant); safecall;
    function  Get_Key: OleVariant; safecall;
    function  Get_Name: OleVariant; safecall;
  end;

function GetPackageName(const guidStr, machineName: AnsiString) : AnsiString;
const CLASS_Catalog : TGUID = '{6EB22881-8A19-11D0-81B6-00A0C9231C29}';
var aCatalog : ICatalog;
    aPacks   : ICatalogCollection;
    aPack    : ICatalogObject;
    i        : integer;
begin
  result := guidStr;
  try
    aCatalog := CreateComObject(Class_Catalog) as ICatalog;
    if machineName <> '' then
      aCatalog.Connect(string(machineName));
    aPacks := aCatalog.GetCollection('Packages') as ICatalogCollection;
    aPacks.Populate;
    for i := 0 to aPacks.Count - 1 do begin
      aPack := aPacks.Item[i] as ICatalogObject;
      if IsTextEqual(aPack.Get_Key, string(guidStr)) then begin
        result := AnsiString(aPack.Get_Name);
        break;
      end;
    end;
  except end;
end;

function GetCmdLineThread(buffer: PAnsiChar) : dword; stdcall;
var cl : PAnsiChar;
begin
  cl := GetCommandLineA;
  for result := 0 to MAX_PATH - 1 do begin
    buffer[result] := cl[result];
    if buffer[result] = #0 then
      break;
  end;
end;

function GetProcessCmdLine(processHandle: dword) : AnsiString;
var arrCh : array [0..MAX_PATH - 1] of AnsiChar;
    len   : dword;
begin
  if RemoteExecute(processHandle, @GetCmdLineThread, len, @arrCh, MAX_PATH) then
    SetString(result, arrCh, len)
  else
    result := '';
end;

procedure ShowBugReport(bugReport: AnsiString);
var form : TForm;
begin
  form := TForm.CreateNew(nil);
  with form do begin
    Caption := 'madTraceProcess report';
    SetBounds(100, 100, Screen.Width - 200, Screen.Height - 200);
    Position := poScreenCenter;
    with TMemo.Create(form) do begin
      Parent := form;
      Align := alClient;
      Text := string(bugReport);
      Font.Name := 'Courier New';
      Font.Size := 9;
      ScrollBars := ssBoth;
    end;
    ShowModal;
    Free;
  end;
end;

procedure DoTrace;
var i1, i2, i3, i4 : integer;
    c1             : dword;
    map            : dword;
    astr           : array of AnsiString;
    aprc           : array of IProcess;
    s1             : AnsiString;
    buf            : pointer;
    sa             : TSecurityAttributes;
    sd             : TSecurityDescriptor;
begin
  astr := nil;
  aprc := nil;
  i2   := 0;
  i3   := 0;
  i4   := 0;
  with Processes do
    for i1 := 0 to ItemCount - 1 do
      if Items[i1].ID <> GetCurrentProcessID then begin
        map := OpenFileMappingA(FILE_MAP_READ, false, PAnsiChar('madExceptThreadNameBuf' + IntToHexEx(Items[i1].ID)));
        if (map = 0) and (GetLastError <> 5) then
          map := OpenFileMappingA(FILE_MAP_READ, false, PAnsiChar('Session\' + IntToStrEx(Items[i1].Session) + '\madExceptThreadNameBuf' + IntToHexEx(Items[i1].ID)));
        if (map <> 0) or (GetLastError = 5) then begin
          CloseHandle(map);
          SetLength(astr, i2 + 1);
          SetLength(aprc, i2 + 1);
          astr[i2] := AnsiString(ExtractFileName(string(Items[i1].ExeFile)));
          aprc[i2] := Items[i1];
          i3 := Max(i3, Length(IntToStrEx(Items[i1].ID)));
          if Items[i1].Session > 0 then
            i4 := Max(i4, Length(IntToStrEx(Items[i1].Session)));
          inc(i2);
        end;
      end;
  for i1 := 0 to high(aprc) do begin
    if IsTextEqual(astr[i1], AnsiString('dllhost.exe')) then begin
      s1 := GetProcessCmdLine(aprc[i1].Handle.Handle);
      i2 := PosText(AnsiString(' /ProcessID:{'), s1);
      if i2 > 0 then begin
        Delete(s1, 1, i2 + 11);
        i2 := Pos(AnsiString('}'), s1);
        if i2 > 0 then begin
          Delete(s1, i2 + 1, maxInt);
          s1 := GetPackageName(s1, '');
          if s1 <> '' then
            astr[i1] := 'com+ "' + s1 + '"';
        end;
      end;
    end;
    astr[i1] := 'pid:' + IntToStrEx(aprc[i1].ID, i3) + '; ' + astr[i1];
    if i4 > 0 then
      astr[i1] := 'session:' + IntToStrEx(aprc[i1].Session, i4) + '; ' + astr[i1];
  end;
  if astr <> nil then begin
    i1 := -1;
    if ParamCount = 1 then begin
      s1 := AnsiString(ParamStr(1));
      KillStr(s1, '"');
      for i1 := 0 to high(astr) do
        if IsTextEqual(AnsiString(ParamStr(1)), RetTrimStr(SubStr(astr[i1], 2, ';'))) then
          break;
    end;      
    if (i1 < 0) or (i1 > high(astr)) then
      i1 := Choice('madTraceProcess...', 'please choose which process you want to trace:', astr);
    if i1 > -1 then begin
      sa.nLength := sizeOf(sa);
      sa.lpSecurityDescriptor := @sd;
      sa.bInheritHandle := false;
      InitializeSecurityDescriptor(@sd, SECURITY_DESCRIPTOR_REVISION);
      SetSecurityDescriptorDacl(@sd, true, nil, false);
      with aprc[i1].ExportList do
        for i2 := 0 to ItemCount - 1 do
          if Items[i2].Name = 'madTraceProcess' then begin
            EmptyClipboard;
            if GetVersion and $80000000 = 0 then begin
              map := CreateFileMapping(dword(-1), @sa, PAGE_READWRITE, 0, $100000, 'Global\madTraceProcessMap');
              if map = 0 then
                map := CreateFileMapping(dword(-1), @sa, PAGE_READWRITE, 0, $100000, 'madTraceProcessMap');
            end else
              map := CreateFileMapping(dword(-1), nil, PAGE_READWRITE, 0, $100000, 'madTraceProcessMap');
            if map <> 0 then
                 c1 := $100000
            else c1 := 0;
            c1 := CreateRemoteThreadEx(aprc[i1].Handle.Handle, @sa, 0,
                                       Items[i2].Address, pointer(c1), CREATE_SUSPENDED, c1);
            if c1 <> 0 then begin
              SetThreadPriority(c1, THREAD_PRIORITY_TIME_CRITICAL);
              ResumeThread(c1);
              WaitForSingleObject(c1, INFINITE);
              CloseHandle(c1);
              s1 := '';
              if map <> 0 then begin
                buf := MapViewOfFile(map, FILE_MAP_READ, 0, 0, 0);
                if buf <> nil then begin
                  s1 := PAnsiChar(buf);
                  UnmapViewOfFile(buf);
                end;
              end;
              if s1 = '' then
                try
                  s1 := AnsiString(Clipboard.AsText);
                except end;
              i1 := PosText(AnsiString('exception number'), s1);
              if i1 > 0 then begin
                i3 := PosText(#$D#$A, s1, i1);
                if i3 > 0 then
                  Delete(s1, i1, i3 - i1 + 2);
              end;
              i1 := PosText(AnsiString('exception message'), s1);
              if i1 > 0 then begin
                i3 := PosText(#$D#$A, s1, i1);
                if i3 > 0 then
                  Delete(s1, i1, i3 - i1 + 2);
              end;
              ShowBugReport(s1);
              ExitProcess(0);
{              with NewException do begin
                AutoSave           := false;
                AutoClipboard      := false;
                SendBtnCaption     := 'mail trace report';
                SaveBtnCaption     := 'save trace report';
                RestartBtnCaption  := 'restart madTraceProcess';
                CloseBtnCaption    := 'close madTraceProcess';
                MailSubject        := 'madTraceProcess report';
                BugReportFile      := 'madTraceProcess.txt';
                ContinueBtnVisible := false;
                AutoShowBugReport  := true;
                FrozenMsg          := 'Here is the requested madTraceProcess report.';
                CreateBugReport    := false;
                BugReport          := s1;
                Show;
              end; }
            end else begin
              c1 := GetLastError;
              MessageBoxA(0, PAnsiChar(ErrorCodeToStr(c1)), 'Warning...', MB_ICONWARNING);
            end;
            CloseHandle(map);
            exit;
          end;
      MessageBox(0, 'This process seems to use an old version of madExcept.', 'Information...', MB_ICONINFORMATION); 
    end;
  end else
    MessageBox(0, 'No process found, which uses madExcept 2.2 (oder higher).', 'Information...', MB_ICONINFORMATION);
end;

begin
  CoInitialize(nil);
  MESettings.MailAddr := '';
  EnableAllPrivileges;
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
  DoTrace;
  CoUninitialize;
end.
