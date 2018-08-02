{*******************************************************************************
* Unit      : frmCipherTest                                                    *
********************************************************************************
* Purpose   : Provides a testing harness for TSM encryption components         *
********************************************************************************
* Copyright : This unit is copyright TSM Inc. 1999                             *
*             This source code may not be distributed to third parties in      *
*             or in part without the written permission of TSM Inc.            *
*             All rights reserved. Liability limited to replacement of         *
*             this original source code in the case of loss or damage because  *
*             the use or misuse of this software.                              *
********************************************************************************
* Version   : 25.02.98  - 1.0   Original unit                                  *
*             10.08.98  - 1.10  Tidied up                                      *
*             22.01.99  - 1.14  Tidied up and added streams and blocks         *
*******************************************************************************}

unit frmctest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,StdCtrls,
  ExtCtrls, {See below!!}Blowfish;
  // if you get the message 'blowfish.dcu not found, please either put the
  // blowfish.dcu file into the 'lib' Delphi subdirectory, or update the Delphi
  // search path. See the Blowfish help file for more details ('Installing')

{*******************************************************************************
* Type      : TfrmCipherTest                                                   *
********************************************************************************
* Purpose   : Defines the form                                                 *
*******************************************************************************}
type
  TfrmCipherTest = class(TForm)
    grpText:          TGroupBox;
    btnDecrypt:       TButton;
    btnEncrypt:       TButton;
    edtTestText:      TEdit;
    lblTestText:      TLabel;
    grpFile:          TGroupBox;
    btnFileEncrypt:   TButton;
    odlFileEnc:       TOpenDialog;
    sdlFileEnc:       TSaveDialog;
    btnFileDecrypt:   TButton;
    odlFileDec:       TOpenDialog;
    sdlFileDec:       TSaveDialog;
    edtVersion:       TEdit;
    lblVersion:       TLabel;
    Bevel1:           TBevel;
    Blowfish1:        TBlowfish;
    grpStream:        TGroupBox;
    lblStreamTest:    TLabel;
    edtStreamTest:    TEdit;
    btnStreamEncrypt: TButton;
    btnStreamDecrypt: TButton;
    grpCipherMode:    TGroupBox;
    rdbECB:           TRadioButton;
    rdbCBC:           TRadioButton;
    rdbCFB:           TRadioButton;
    rdbOFB:           TRadioButton;
    grpCBCMAC:        TGroupBox;
    lblCBCMAC:        TLabel;
    btmMakeMAC:       TButton;
    edtCBCMAC:        TEdit;
    grpBlock:         TGroupBox;
    edtKeyBytes1:     TEdit;
    lblBlockKey:      TLabel;
    edtKeyBytes2:     TEdit;
    edtKeyBytes3:     TEdit;
    edtKeyBytes4:     TEdit;
    rdb64:            TRadioButton;
    rdb128:           TRadioButton;
    edtPlainBytes1:   TEdit;
    edtPlainBytes2:   TEdit;
    edtCipherBytes1:  TEdit;
    edtCipherBytes2:  TEdit;
    lblPlainText:     TLabel;
    lblCipherText:    TLabel;
    btnBlockEnc:      TButton;
    btnBlockDec:      TButton;
    grpTimeTrial:     TGroupBox;
    lblSpeedDisp:     TLabel;
    lblSpeed:         TLabel;
    lblKBs:           TLabel;
    btnTestSpeed:     TButton;
    procedure btnFileEncryptClick(Sender: TObject);
    procedure btnEncryptClick(Sender: TObject);
    procedure btnDecryptClick(Sender: TObject);
    procedure btnFileDecryptClick(Sender: TObject);
    procedure rdbECBClick(Sender: TObject);
    procedure rdbCBCClick(Sender: TObject);
    procedure rdbCFBClick(Sender: TObject);
    procedure rdbOFBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnStreamEncryptClick(Sender: TObject);
    procedure btnStreamDecryptClick(Sender: TObject);
    procedure rdb64Click(Sender: TObject);
    procedure rdb128Click(Sender: TObject);
    procedure btnBlockEncClick(Sender: TObject);
    procedure btmMakeMACClick(Sender: TObject);
    procedure btnBlockDecClick(Sender: TObject);
    procedure btnTestSpeedClick(Sender: TObject);
  private
    procedure ParseHalfBlock(const StringToParse: string;
                             var   KeyBytes: array of Byte;
                             const Offset: integer);
    function ConvertNibble(Nibble: Char): integer;
  end;


var
  frmCipherTest: TfrmCipherTest;

implementation

{$R *.DFM}

{*******************************************************************************
* Procedure : btnEncryptClick                                                  *
********************************************************************************
* Purpose   : Encrypts a the line of text in the edit box                      *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.btnEncryptClick(Sender: TObject);
var
     Tempstr: string;
begin
     Blowfish1.LoadIVString('Init Vector');
     Blowfish1.InitialiseString('Pass Phrase');

     // encrypt the string
     Blowfish1.EncString(edtTestText.Text, TempStr);

     // and copy it back to the edit box
     edtTestText.Text := TempStr;

     // destroy sensitive information
     Blowfish1.Burn;
end; {TfrmCipherTest.btnEncryptClick}

{*******************************************************************************
* Procedure : btnDecryptClick                                                  *
********************************************************************************
* Purpose   : Decrypts a the line of text in the edit box                      *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.btnDecryptClick(Sender: TObject);
var
     Tempstr: string;
begin
     Blowfish1.InitialiseString('Pass Phrase');
     Blowfish1.LoadIVString('Init Vector');

     // decrypt the string
     Blowfish1.DecString(edtTestText.Text,Tempstr);

     // and copy it back into the edit box
     edtTestText.Text := TempStr;

     // destroy sensitive information
     Blowfish1.Burn;
end; {TfrmCipherTest.btnDecryptClick}

{*******************************************************************************
* Procedure : btnFileEncryptClick                                              *
********************************************************************************
* Purpose   : Selects a file to encrypt and encrypts it to the specified       *
*             destination file                                                 *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.btnFileEncryptClick(Sender: TObject);
begin
     Blowfish1.LoadIVString('Init Vector');
     Blowfish1.InitialiseString('Pass Phrase');

     // check if a source and destination file has been selected
     if odlFileEnc.Execute and sdlFileEnc.Execute then
     begin
          // perform the encryption
          Blowfish1.EncFile(odlFileEnc.FileName, sdlFileEnc.FileName);
     end; {if}

     // destroy sensitive information
     Blowfish1.Burn;
end; {TfrmCipherTest.btnFileEncryptClick}

{*******************************************************************************
* Procedure : btnFileDecryptClick                                              *
********************************************************************************
* Purpose   : Selects a file to decrypt and decrypts it to the specified       *
*             destination file                                                 *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.btnFileDecryptClick(Sender: TObject);
begin
     Blowfish1.LoadIVString('Init Vector');
     Blowfish1.InitialiseString('Pass Phrase');

     // check if a source and destination file has been selected
     if odlFileDec.Execute and sdlFileDec.Execute then
     begin
          // perform the decryption
          Blowfish1.DecFile(odlFileDec.FileName, sdlFileDec.FileName);
     end;

     // destroy sensitive information
     Blowfish1.Burn;
end; {TfrmCipherTest.btnFileDecryptClick}

{*******************************************************************************
* Procedure : rdbECBClick                                                      *
********************************************************************************
* Purpose   : Sets the cipher mode to ECB                                      *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.rdbECBClick(Sender: TObject);
begin
     Blowfish1.CipherMode := ECB;
end; {TfrmCipherTest.rdbECBClick}

{*******************************************************************************
* Procedure : rdbCBCClick                                                      *
********************************************************************************
* Purpose   : Sets the cipher mode to CBC                                      *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.rdbCBCClick(Sender: TObject);
begin
     Blowfish1.CipherMode := CBC;
end; {TfrmCipherTest.rdbCBCClick}

{*******************************************************************************
* Procedure : rdbCFBClick                                                      *
********************************************************************************
* Purpose   : Sets the cipher mode to CFB                                      *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.rdbCFBClick(Sender: TObject);
begin
     Blowfish1.CipherMode := CFB;
end; {TfrmCipherTest.rdbCFBClick}

{*******************************************************************************
* Procedure : rdbOFBClick                                                      *
********************************************************************************
* Purpose   : Sets the cipher mode to OFB                                      *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.rdbOFBClick(Sender: TObject);
begin
     Blowfish1.CipherMode := OFB;
end; {TfrmCipherTest.rdbOFBClick}

{*******************************************************************************
* Procedure : FormCreate                                                       *
********************************************************************************
* Purpose   : Retrieves the cipher version and set the cipher mode to ECB      *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.FormCreate(Sender: TObject);
begin
     edtVersion.Text := Blowfish1.GetVersion;
     rdbECBClick(Self);
end; {TfrmCipherTest.FormCreate}

{*******************************************************************************
* Procedure : btnStreamEncryptClick                                            *
********************************************************************************
* Purpose   : Decrypts the contents of the text box using stream methods and   *
*             places the result back in the edit box                           *
*             **NOTE** Because we are dealing with strings and displaying them *
*             in an edit box, the encryption can sometimes contain binary zero *
*             which will cause an incorrect decryption. (This is why we often  *
*             use the Base64 option in encrypt and decrypt string functions)   *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.btnStreamEncryptClick(Sender: TObject);
var
     InStream: TMemoryStream;
     OutStream: TMemoryStream;
     TempString: string;
begin
     // set the keys
     Blowfish1.LoadIVString('Init Vector');
     Blowfish1.InitialiseString('Pass Phrase');

     // create the streams
     InStream := TMemoryStream.Create;
     OutStream := TMemoryStream.Create;

     // read the text into the stream - going through a tempstring avoids type problems
     TempString := edtStreamTest.Text;
     InStream.WriteBuffer(TempString[1], Length(TempString));

     // perform the encryption
     Blowfish1.EncStream(InStream, OutStream);

     // read the string back out of the stream and display it
     OutStream.Seek(0, soFromBeginning);
     SetLength(TempString, OutStream.Size);
     OutStream.ReadBuffer(TempString[1], OutStream.Size);
     edtStreamTest.Text := TempString;

     // burn sensitive information
     Blowfish1.Burn;
end; {TfrmCipherTest.btnStreamEncryptClick}

{*******************************************************************************
* Procedure : btnStreamDecryptClick                                            *
********************************************************************************
* Purpose   : Decrypts the contents of the text box using stream methods and   *
*             places the result back in the edit box                           *
*             **NOTE** Because we are dealing with strings and displaying them *
*             in an edit box, the encryption can sometimes contain binary zero *
*             which will cause an incorrect decryption. (This is why we often  *
*             use the Base64 option in encrypt and decrypt string functions)   *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.btnStreamDecryptClick(Sender: TObject);
var
     InStream: TMemoryStream;
     OutStream: TMemoryStream;
     TempString: string;
begin
     // set the keys
     Blowfish1.InitialiseString('Pass Phrase');
     Blowfish1.LoadIVString('Init Vector');

     // create the streams
     InStream := TMemoryStream.Create;
     OutStream := TMemoryStream.Create;

     // read the text into the stream - going through a tempstring avoids type problems
     TempString := edtStreamTest.Text;
     InStream.WriteBuffer(TempString[1], Length(TempString));

     // perform the decryption
     Blowfish1.DecStream(InStream, OutStream);

     // read the string back out of the stream and display it
     OutStream.Seek(0, soFromBeginning);
     SetLength(TempString, OutStream.Size);
     OutStream.ReadBuffer(TempString[1], OutStream.Size);
     edtStreamTest.Text := TempString;

     // burn sensitive information
     Blowfish1.Burn;
end; {TfrmCipherTest.btnStreamDecryptClick}

{*******************************************************************************
* Procedure : btmMakeMACClick                                                  *
********************************************************************************
* Purpose   : creates the CBC-MAC 'text to encrypt' edit box                   *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.btmMakeMACClick(Sender: TObject);
var
     TempString: String;
begin
     // set the key and IV up
     Blowfish1.InitialiseString('CBC-MAC secret key');
     Blowfish1.LoadIVString('CBC-MAC secret Init Vector');

     // load the data into the internal RC6 registers
     // the result of the encryption can be thrown away
     // or better, the mac can be produced during the encryption
     // and simply read out at the end
     Blowfish1.EncString(edtTestText.Text, TempString);

     // see if we are in CBC mode (needed for CBC-MAC)
     try
          Blowfish1.CBCMACString(TempString);
     except
          // if we are in the wrong mode, show an error
          ShowMessage('You must set the mode to CBC to produce a CBC-MAC!');
          Exit;
     end;

     // burn the blowfish internal information
     Blowfish1.Burn;

     // show the CBC-MAC
     edtCBCMAC.Text := TempString;
end; {TfrmCipherTest.btnMakeMACClick}

{*******************************************************************************
* Procedure : rdb64Click                                                       *
********************************************************************************
* Purpose   : Sets the key length of the block encryption to 64 bits           *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.rdb64Click(Sender: TObject);
begin
     edtKeyBytes3.Enabled := False;
     edtKeyBytes4.Enabled := False;
end; {TfrmCipherTest.rdb64Click}

{*******************************************************************************
* Procedure : rdb128Click                                                      *
********************************************************************************
* Purpose   : Sets the key length of the block encryption to 128 bits          *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.rdb128Click(Sender: TObject);
begin
     edtKeyBytes3.Enabled := True;
     edtKeyBytes4.Enabled := True;
end; {TfrmCipherTest.rdb128Click}

{*******************************************************************************
* Procedure : btnBlockEncClick                                                 *
********************************************************************************
* Purpose   : converts the hexedecimal numbers into binary and performs an     *
*             encryption, converting again to hex before display               *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.btnBlockEncClick(Sender: TObject);
var
     KeyBytes: array[0..15] of Byte;
     KeyLength: integer;
     InputBlock: TBlock;
     OutputBlock: TBlock;
     i: integer;
begin
     // Convert the keybytes text into bytes
     ParseHalfBlock(edtKeyBytes1.Text, KeyBytes, 0);
     ParseHalfBlock(edtKeyBytes2.Text, KeyBytes, 4);
     KeyLength := 8;

     // check if we need to do the top 64 bits
     if rdb128.Checked then
     begin
          ParseHalfBlock(edtKeyBytes3.Text, KeyBytes, 8);
          ParseHalfBlock(edtKeyBytes4.Text, KeyBytes, 12);
          KeyLength := 16;
     end; {if}

     // set the key
     Blowfish1.InitialiseByte(KeyBytes, KeyLength);

     // Convert the plain Bytes
     ParseHalfBlock(edtPlainBytes1.Text, KeyBytes, 0);
     ParseHalfBlock(edtPlainBytes2.Text, KeyBytes, 4);

     // move into the TBlock
     Move(KeyBytes[0], InputBlock, BLOCKSIZE);

     // do the encryption
     Blowfish1.EncBlock(InputBlock, OutputBlock);

     // show the result
     edtCipherBytes1.Text := '';
     edtCipherBytes2.Text := '';

     for i := 0 to 3 do
     begin
          edtCipherBytes1.Text := edtCipherBytes1.Text + IntToHex(OutputBlock[i],2);
          edtCipherBytes2.Text := edtCipherBytes2.Text + IntToHex(OutputBlock[i+4],2);
     end;

     //  burn the information
     Blowfish1.Burn;
end; {TfrmCipherTest.btnBlockEncClick}

{*******************************************************************************
* Procedure : btnBlockDecClick                                                 *
********************************************************************************
* Purpose   : converts the hexedecimal numbers into binary and performs an     *
*             decryption, converting again to hex before display               *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.btnBlockDecClick(Sender: TObject);
var
     KeyBytes: array[0..15] of Byte;
     KeyLength: integer;
     InputBlock: TBlock;
     OutputBlock: TBlock;
     i: integer;
begin
     // Convert the keybytes text into bytes
     ParseHalfBlock(edtKeyBytes1.Text, KeyBytes, 0);
     ParseHalfBlock(edtKeyBytes2.Text, KeyBytes, 4);
     KeyLength := 8;

     // check if we need to do the top 64 bits
     if rdb128.Checked then
     begin
          ParseHalfBlock(edtKeyBytes3.Text, KeyBytes, 8);
          ParseHalfBlock(edtKeyBytes4.Text, KeyBytes, 12);
          KeyLength := 16;
     end; {if}

     // set the key
     Blowfish1.InitialiseByte(KeyBytes, KeyLength);

     // Convert the plain Bytes
     ParseHalfBlock(edtCipherBytes1.Text, KeyBytes, 0);
     ParseHalfBlock(edtCipherBytes2.Text, KeyBytes, 4);

     // move into the TBlock
     Move(KeyBytes[0], InputBlock, BLOCKSIZE);

     // do the encryption
     Blowfish1.DecBlock(InputBlock, OutputBlock);

     // show the result
     edtPlainBytes1.Text := '';
     edtPlainBytes2.Text := '';

     for i := 0 to 3 do
     begin
          edtPlainBytes1.Text := edtPlainBytes1.Text + IntToHex(OutputBlock[i],2);
          edtPlainBytes2.Text := edtPlainBytes2.Text + IntToHex(OutputBlock[i+4],2);
     end;

     //  burn the information
     Blowfish1.Burn;
end; {TfrmCipherTest.btnBlockDecClick}

{*******************************************************************************
* Procedure : ParseHalfBlock                                                   *
********************************************************************************
* Purpose   : converts 32 bits of hexedecimal into a 32 bit binary integer,    *
*             and writes it into the KeyBytes array at the given offset        *
********************************************************************************
* Paramters : StringToParse - the 8 digit string to be converted               *
*             KeyBytes - array of Byte which holds the key                     *
*             Offset - the offset in the key array which will be written       *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.ParseHalfBlock(const StringToParse: string;
                                        var   KeyBytes: array of Byte;
                                        const Offset: integer);
var
     i: integer;
     Pos: integer;
     TempString: string;
begin
     // check the validity of the string - first the length
     if Length(StringtoParse) <> 8 then
     begin
          raise Exception.Create('Half block hex string has wrong length');
          Exit;
     end;

     // set the pointer in the key array
     Pos := Offset;

     // convert to upper case
     TempString := UpperCase(StringToParse);

     // parse the string
     for i := 0 to 3 do
     begin
          KeyBytes[Pos+i] := ConvertNibble(TempString[(i*2)+1])*16 +
                             ConvertNibble(TempString[(i*2)+2]);
     end;
end; {TfrmCipherTest.ParseHalfBlock}

{*******************************************************************************
* Procedure : ConvertNibble                                                    *
********************************************************************************
* Purpose   : converts a nibble into a decimal equivalent. Input must be upper *
*             case                                                             *
********************************************************************************
* Paramters : Nibble - Hex digit to be converted (0-9, A-F)                    *
********************************************************************************
* Returns   : the decimal value of the hex digit (0-15)                        *
*******************************************************************************}
function TfrmCipherTest.ConvertNibble(Nibble: Char): integer;
const
     HexDigits: set of '0'..'Z' = ['0'..'9', 'A'..'F'];
begin
     if not (Nibble in HexDigits) then
     begin
          Raise Exception.Create('Invalid hex character in input string');
          Exit;
     end;

     Result := Ord(Nibble) - Ord('0');
     if Result > 9 then
     begin
          Result := Result -7;
     end;
end; {TfrmCipherTest.ConvertNibble}

{*******************************************************************************
* Procedure : btnTestSpeedClick                                                *
********************************************************************************
* Purpose   : performs a speed check on the encryption algorithm using the     *
*             EncryptBlock method                                              *
********************************************************************************
* Paramters : None                                                             *
********************************************************************************
* Returns   : None                                                             *
*******************************************************************************}
procedure TfrmCipherTest.btnTestSpeedClick(Sender: TObject);
var
     StartTime: TDateTime;
     LengthTime: TDateTime;
     Hour: word;
     Min: word;
     Sec: word;
     MSec: word;
     i: Longint;
     Input: TBlock;
     Output: TBLock;
begin
     // test the speed of the encryption
     Blowfish1.InitialiseString('This is a temp key');
     Blowfish1.CipherMode := ECB;
     StartTime := Now;
     FillChar(Input, Sizeof(Input), #0);
     lblSpeed.Caption := 'Working';
     lblSpeed.Repaint;

     // perform the loop
     for i := 0 to 799999 do
     begin
          Blowfish1.EncBlock(Input, Output);
     end;

     LengthTime := Now - StartTime;

     DecodeTime(LengthTime, Hour, Min, Sec, MSec);
     LengthTime := (Hour*3600000 + Min*60000 + Sec*1000 + MSec);

     // we have encryped 6400kb data
     lblSpeed.Caption := IntToStr(Trunc(6400000/LengthTime));
end; {TfrmCipherTest.btnTestSpeedClick}

end.

