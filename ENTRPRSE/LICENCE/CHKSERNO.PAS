unit ChkSerNo;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl;

type
  TfrmCheckSNo = class(TForm)
    DriveComboBox1: TDriveComboBox;
    btnCheck: TButton;
    ListBox1: TListBox;
    procedure btnCheckClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

procedure TfrmCheckSNo.btnCheckClick(Sender: TObject);
Type
  CharArrType = Array[1..4] Of Byte;
Var
  OldErrorMode               : Integer;
  pDrive, pVolName, pSysName : PChar;
  pSerial, NotUsed, VolFlags : DWord;
  CharArr                    : ^CharArrType;
  I                          : Byte;

  Function ByteToHexStr (Const TheByte : Byte) : ShortString;
  Begin { ByteToHexStr }
    { Convert Byte to hex string equivalent }
    Result := Format ('%2x', [TheByte]);

    { Check for blank leading byte }
    If (Result[1] = ' ') Then
      Result[1] := '0';
  End; { ByteToHexStr }

begin
  pDrive := StrAlloc (100);
  StrPCopy (pDrive, DriveComboBox1.Drive + ':\');

  { Get Volume Information:- File System + Compression }
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    pVolName := StrAlloc (200);
    pSysName := StrAlloc (200);
    pSerial  := 0;

    aasdasdasd

    If GetVolumeInformation(pDrive,           { Drive }
                            pVolName,         { Volume Name }
                            200,              { Volume Name Length }
                            @pSerial,         { Volume Serial Number }
                            NotUsed,          { Max filename length }
                            VolFlags,         { Volume Flags }
                            pSysName,         { File System Name }
                            100) Then Begin   { File system Name Length }

      CharArr := @pSerial;

      ListBox1.Items.Add (Format ('SerialNo (%3s): %2x%2x-%2x%2x', [pDrive,CharArr[4],CharArr[3],CharArr[2],CharArr[1]]));
      ListBox1.Items.Add (Format ('  %3d  %3d  %3d  %3d', [CharArr[4],CharArr[3],CharArr[2],CharArr[1]]));
      ListBox1.Items.Add (Format ('  %2s%2s-%2s%2s', [ByteToHexStr(CharArr[4]),ByteToHexStr(CharArr[3]),ByteToHexStr(CharArr[2]),ByteToHexStr(CharArr[1])]));
    End; { If }

    StrDispose(pVolName);
    StrDispose(pSysName);
  Finally
    SetErrorMode(OldErrorMode);
  End;
end;

end.
