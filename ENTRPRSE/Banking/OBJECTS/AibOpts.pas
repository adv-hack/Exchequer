unit AibOpts;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

const
  MaxFileNo = 968; {for Bank of Ireland.  AIB doesn't specify max so could be 999,
                    but safer to keep both the same when possible}
  MaxVolNo = 99;

type
{Change to use date for volno rather than VolPrefix & VolNo.  Also don't show dialog - for
security reasons UserID is only to be in the ini file}
  TEftOptionsRec = Record
    UserID : String[6];
    VolPrefix : String[4];
    VolNo    : Word;
    FileNo   : Word;
    OutCurr  : Byte;
  end;

  TfrmAibOpts = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    edtUserID: TEdit;
    Label1: TLabel;
    edtVolNo: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edtVolPrefix: TEdit;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


function  GetEFTOptions(const Filename : string;
                        var     TheRec : TEFTOptionsRec;
                               ShowDlg : Boolean;
                               IsReceipt : Boolean = False) : Boolean;
                               
function  GetEFTOptionsDlg(const Filename : string;
                             var   TheRec : TEFTOptionsRec) : Boolean;

implementation

uses
  IniFiles, {$IFDEF MultiBacs}MultIni, {$ENDIF}Aib01;


function ReadEFTSettings(Const Filename : string; IsReceipt : Boolean = False) : TEFTOptionsRec;
var
  TheIni : TIniFile;


begin
  FillChar(Result, SizeOf(TEftOptionsRec), ' ');
  TheIni := TIniFile.Create(Filename);
  Try
   with Result do
   begin
     if (ExtractFilename(Filename) = DefaultBIEFTIniFile) and IsReceipt then
       UserID := TheIni.ReadString('EFT','RecUserID','')
     else
       UserID := TheIni.ReadString('EFT','UserID','');
     OutCurr := TheIni.ReadInteger('EFT','OutputCurrency',1);
   end;
  Finally
   TheIni.Free;
  End;
end;

procedure WriteEFTSettings(const Filename : string; TheRec : TEFTOptionsRec);
var
  TheIni : TIniFile;
begin
  TheIni := TIniFile.Create(Filename);
  Try
   with TheRec do
   begin
     TheIni.WriteString('EFT','UserID',UserID);
   end;
  Finally
   TheIni.Free;
  End;
end;

function GetEFTOptionsDlg(const Filename : string;
                             var   TheRec : TEFTOptionsRec) : Boolean;
{Filename should be name of ini file including full path}
var
  frmAibOpts: TfrmAibOpts;
begin
  Result := False;
  frmAibOpts := TfrmAibOpts.Create(Application);
  Try
    with frmAibOpts do
    begin
      TheRec := ReadEFTSettings(Filename);
      with TheRec do
      begin
        edtUserID.Text := UserID;
        edtVolPrefix.Text := VolPrefix;
        edtVolNo.Text := IntToStr(VolNo);
      end;
      ShowModal;
      if ModalResult = mrOK then
      begin
        with TheRec do
        begin
          UserID := edtUserID.Text;
          VolPrefix := edtVolPrefix.Text;
          Try
            VolNo := StrToInt(edtVolNo.Text);
          Except
            VolNo := 0;
          End;
        end;
        WriteEFTSettings(Filename, TheRec);
        Result := True;
      end;
    end;
  Finally
    frmAibOpts.Free;
  End;
end;

function  GetEFTOptions(const Filename : string;
                        var     TheRec : TEFTOptionsRec;
                               ShowDlg : Boolean;
                               IsReceipt : Boolean = False) : Boolean;
begin
  if ShowDlg then
    Result := GetEFTOptionsDlg(Filename, TheRec)
  else
  begin
   Result := True;   

   TheRec := ReadEFTSettings(Filename, IsReceipt);
   {$IFDEF MultiBacs}
   //PR 16/11/05 Request from Ian Conner to allow userid to be specified in mbacs in file
   //PR 17/05/06 Extended to cover all Irish banks
   //HV 20-01-2016 ABSEXCH-10283, Using Sales Receipts on the Ebanking module picks up the USER ID assigned for Payments and not the SRCs ID as supposed to. 
   if IsReceipt then
     TheRec.UserID := UserRecID
   else if {(ExtractFilename(Filename) = DefaultUlsterBankIniFile) and} (UserID <> '') then
     TheRec.UserID := UserID;
   if OutputCurr > 0 then
     TheRec.OutCurr := OutputCurr;
   {$ENDIF}
   if TheRec.UserID = '' then
     Result := False;
  end;
end;


{$R *.DFM}

procedure TfrmAibOpts.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  w : Word;
begin
  CanClose := True;
  if ModalResult = mrOK then
  begin
    Try
      w := StrToInt(edtVolNo.Text);
      if w > MaxVolNo then
      begin
        CanClose := False;
        ShowMessage('Volume number cannot be more than ' + IntToStr(MaxVolNo));
      end;
    Except
      edtVolNo.Text := '0';
    End;

  end; {if modal result}


end;

end.
