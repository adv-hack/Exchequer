unit VATWarnF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, TEditVal, TCustom, ExtCtrls, SBSPanel, GlobVar, VarConst;

type
  TfrmVATWarning = class(TForm)
    Panel1: TPanel;
    btnCancel: TSBSButton;
    btnOK: TSBSButton;
    Image1: TImage;
    SBSPanel2: TSBSPanel;
    CLMsgL: Label8;
    Label86: Label8;
    Label85: Label8;
    Label2: TLabel;
    Label3: TLabel;
    Panel2: TPanel;
    Label1: TLabel;
    edtPassword: Text8Pt;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure edtPasswordChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function AuthoriseVATChange(Const OrigReturnDate, NewReturnDate : LongDate; Const OrigInterval, NewInterval : Byte) : Boolean;

implementation

uses
  Crypto, ApiUtil, SecSup2U, SQLUtils, SysU1, ETDateU;

{$R *.dfm}


//=========================================================================


//PR: 16/02/2010 New function to write log file when BOM Kitting Option is changed.
procedure WriteVATChangeLogFile(OrigReturnDate, NewReturnDate : LongDate; Const OrigInterval, NewInterval : Byte);
const
  S_FILENAME = 'DOCS\VCL.DAT';
var
  sFile : string;
  F : TextFile;
  Attr : Integer;
begin
  sFile := SetDrive + S_FILENAME;
  AssignFile(F, sFile);


  if FileExists(sFile) then
    Append(F)
  else
    Rewrite(F);

  WriteLn(F, '  ');
  WriteLn(F, 'VAT Setup Options Changed');
  WriteLn(F, '=========================');
  WriteLn(F, 'Date/Time:         ' + FormatDateTime('c', Now));
  WriteLn(F, 'Return Date changed from ' + POutDate(OrigReturnDate) + ' to ' + POutDate(NewReturnDate));
  WriteLn(F, 'Interval changed from ' + IntToStr(OrigInterval) + ' to ' + IntToStr(NewInterval));
  WriteLn(F, 'Workstation:       ' + WinGetComputerName);
  WriteLn(F, 'Windows User ID:   ' + WinGetUserName);
  WriteLn(F, 'Exchequer User ID: ' + EntryRec.LogIn);
  WriteLn(F, 'Last Folio Used:   ' + IntToStr(GetNextCount(FOL, False, False, 0) - 1));
  WriteLn(F, '  ');

  CloseFile(F);
end;

//=========================================================================

Function AuthoriseVATChange(Const OrigReturnDate, NewReturnDate : LongDate; Const OrigInterval, NewInterval : Byte) : Boolean;
Begin // AuthoriseVATChange
  Result := False;

  With TfrmVATWarning.Create(nil) Do
    Try
      ActiveControl := edtPassword;
      ShowModal;
      Result := ModalResult = mrOK;
      if Result then
        WriteVATChangeLogFile(OrigReturnDate, NewReturnDate, OrigInterval, NewInterval);
    Finally
      Free;
    End;
End; // AuthoriseVATChange

//-------------------------------------------------------------------------

procedure TfrmVATWarning.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult = mrOK then
  begin
    CanClose := edtPassWord.Text = Get_TodaySecurity; //This checks Daily Password
    if not CanClose then
    begin
      ShowMessage('Invalid Password');
      ActiveControl := edtPassword;
    end;
  end;
end;

procedure TfrmVATWarning.FormShow(Sender: TObject);
Var
  BMap1       :  TBitMap;
  RectD       :  TRect;
begin
  If Not NoXLogo then
  Begin
    BMap1:=TBitMap.Create;

    BMap1.Handle:=LoadBitMap(HInstance,'EXCLAM_2');

    With BMap1 do
      RectD:=Rect(0,0,Width,Height);


    With Image1.Picture.Bitmap do
    Begin
      Width:=BMap1.Width;
      Height:=BMap1.Height;

      Canvas.Brush.Color:=clBtnFace;
      Canvas.BrushCopy(RectD,BMap1,RectD,clSilver);
    end;

    BMap1.Free;
  end;{If..}

end;

procedure TfrmVATWarning.edtPasswordChange(Sender: TObject);
begin
  btnOK.Enabled := Trim(edtPassword.Text) <> '';
end;

end.
