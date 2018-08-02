unit main;

{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function GetUDPeriodYear_Ext(pDataPath, pDate : pChar; var iPeriod : smallint; var iYear : smallint) : smallint; stdcall; external 'UDPeriod.dll';
function GetDateFromUDPY_Ext(pDataPath : pChar; var pDate : PChar; iPeriod, iYear : smallint) : smallint; stdcall; external 'UDPeriod.dll';
function GetUDPeriodYear(sDataPath, sDate : string; var iPeriod : Byte; var iYear : Byte) : boolean; stdcall; external 'UDPeriod.dll';
function GetDateFromUDPY(sDataPath : string; var sDate : shortstring; iPeriod, iYear : Byte) : boolean; stdcall; external 'UDPeriod.dll';
function GetEndDateOfUDPY(pDataPath : pChar; var pDate : PChar; iPeriod, iYear : smallint) : smallint; stdcall; external 'UDPeriod.dll';

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  iResult, iPeriod, iYear : smallint;
  pDataPath, pDate : pChar;
begin
  pDataPath := StrAlloc(255);
  pDate := StrAlloc(255);

  StrPCopy(pDataPath, 'c:\iaoffice\');
  StrPCopy(pDate, '20060612');

//  pDataPath := 'c:\iaoffice\';
//  pDate := '20060612';
//  iPeriod := 0;
//  iYear := 0;

  iResult := GetUDPeriodYear_Ext(pDataPath, pDate, iPeriod, iYear);

  StrDispose(pDataPath);
  StrDispose(pDate);

  Showmessage('Result : ' + IntToStr(iResult));
  Showmessage('iPeriod : ' + IntToStr(iPeriod));
  Showmessage('iYear : ' + IntToStr(iYear));
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  iResult, iPeriod, iYear : smallint;
  pDataPath, pDate : pChar;
begin
  pDataPath := StrAlloc(255);
  pDate := StrAlloc(255);

  StrPCopy(pDataPath, 'c:\iaoffice\');
//  StrPCopy(pDate, '20060612');

//  pDataPath := 'c:\iaoffice\';
//  pDate := '20060612';
  iPeriod := 6;
  iYear := 106;

  iResult := GetDateFromUDPY_Ext(pDataPath, pDate, iPeriod, iYear);

  Showmessage('Result : ' + IntToStr(iResult));
  Showmessage('pDate : ' + pDate);

  StrDispose(pDataPath);
  StrDispose(pDate);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  iResult, iPeriod, iYear : smallint;
  pDataPath, pDate : pChar;
begin
  pDataPath := StrAlloc(255);
  pDate := StrAlloc(255);

  StrPCopy(pDataPath, 'c:\ENTV561\');
//  StrPCopy(pDate, '20060612');

//  pDataPath := 'c:\iaoffice\';
//  pDate := '20060612';
  iPeriod := 39;
  iYear := 106;

  iResult := GetEndDateOfUDPY(pDataPath, pDate, iPeriod, iYear);

  Showmessage('Result : ' + IntToStr(iResult));
  Showmessage('pDate : ' + pDate);

  StrDispose(pDataPath);
  StrDispose(pDate);
end;

end.
