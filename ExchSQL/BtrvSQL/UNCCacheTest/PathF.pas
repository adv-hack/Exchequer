unit PathF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function GetLongPathName(ShortPathName: PChar; LongPathName: PChar;
    cchBuffer: Integer): Integer; stdcall; external kernel32 name 'GetLongPathNameA';

procedure TForm1.FormCreate(Sender: TObject);

  //------------------------------

  // Converts a Long Path into the Short Filename equivalent
  function ToShortPath(Const Path : String) : String;
  Var
    LongPath, ShortPath: PChar;
    PLen: SmallInt;
  Begin // ToShortPath
    Result := Trim(Path);
    If (Result <> '') Then
    Begin
      LongPath  := StrAlloc(250);
      ShortPath := StrAlloc(250);

      StrPCopy (LongPath, Trim(Path));
      PLen := GetShortPathName(LongPath, ShortPath, StrBufSize(ShortPath));
      If (PLen > 0) Then
        Result := Trim(StrPas(ShortPath));

      StrDispose (LongPath);
      StrDispose (ShortPath);
    End; // If (Result <> '')
  End; // ToShortPath

  //------------------------------

  // Converts a Long Path into the Short Filename equivalent
  function ToLongPath(Const Path : String) : String;
  (*             *)
  Var
    LongPath, ShortPath: PChar;
    PLen: SmallInt;
  Begin // ToLongPath
    Result := Trim(Path);
    If (Result <> '') Then
    Begin
      LongPath  := StrAlloc(250);
      ShortPath := StrAlloc(250);

      StrPCopy (ShortPath, Trim(Path));
      PLen := GetLongPathName(ShortPath, LongPath, StrBufSize(LongPath));
      If (PLen > 0) Then
        Result := Trim(StrPas(LongPath));

      StrDispose (LongPath);
      StrDispose (ShortPath);
    End; // If (Result <> '')
  (*
  Var
    fncGetLongPathName: function (lpszShortPath: LPCTSTR; lpszLongPath: LPTSTR; cchBuffer: DWORD): DWORD stdcall;
    szBuffer: array[0..MAX_PATH] of Char;
    bSuccess : Boolean;
  Begin // ToLongPath
    // try to use the function "GetLongPathNameA" (Win98/2000 and up)
    @fncGetLongPathName := GetProcAddress(GetModuleHandle('Kernel32.dll'), 'GetLongPathNameA');
    if (Assigned(fncGetLongPathName)) then
    begin
      bSuccess := fncGetLongPathName(PChar(Path), szBuffer, SizeOf(szBuffer)) <> 0;
      if bSuccess then
        Result := szBuffer;
    end
    else
      Result := '?';
      *)
  End; // ToLongPath


  //------------------------------

  Procedure ProcessPath (Const ThePath : String);
  Var
    sTitle, sShortPath : String;
  Begin // ProcessPath
    sTitle := 'ProcessPath (' + ThePath + ')';
    Memo1.Lines.Add (sTitle);
    Memo1.Lines.Add (StringOfChar('=', Length(sTitle) + 2));

    Memo1.Lines.Add ('Short Path=' + ToShortPath(ThePath));

    Memo1.Lines.Add ('Long Path=' + ToLongPath(ThePath));

    Memo1.Lines.Add ('ExpandUNCFileName=' + ExpandUNCFileName(ToLongPath(ThePath)));
    // Convert to Long Path


    Memo1.Lines.Add ('');
  End; // ProcessPath

  //------------------------------

begin
  ProcessPath ('V:\EXCH20~2.SQL\COMPAN~1\DEMO01\');
//  ProcessPath ('V:\EXCH20~2.SQL\COMPAN~1\NEWB01\');
//  ProcessPath ('V:\EXCH20~2.SQL\');
end;

end.
