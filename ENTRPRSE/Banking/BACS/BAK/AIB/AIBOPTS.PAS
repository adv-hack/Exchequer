unit AibOpts;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

const
  MaxFileNo = 968; {for Bank of Ireland.  AIB doesn't specify max so could be 999,
                    but safer to keep both the same when possible}
  MaxVolNo = 99;

type
{at the moment i think we only need the user id but make it easy to add more if
necessary}
  TEftOptionsRec = Record
    UserID : String[6];
    VolPrefix : String[4];
    VolNo    : Word;
    FileNo   : Word;
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
                               ShowDlg : Boolean) : Boolean;
function  GetEFTOptionsDlg(const Filename : string;
                             var   TheRec : TEFTOptionsRec) : Boolean;

implementation

uses
  IniFiles;


function ReadEFTSettings(Const Filename : string) : TEFTOptionsRec;
var
  TheIni : TIniFile;


begin
  FillChar(Result, SizeOf(TEftOptionsRec), ' ');
  TheIni := TIniFile.Create(Filename);
  Try
   with Result do
   begin
     UserID := TheIni.ReadString('EFT','UserID','');
     VolPrefix := TheIni.ReadString('EFT','VolPrefix','EFT');
     VolNo     := TheIni.ReadInteger('EFT','VolNo',0);
     Inc(VolNo);
     if VolNo > MaxVolNo then
       VolNo := 0;
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
     TheIni.WriteString('EFT','VolPrefix',VolPrefix);
     TheIni.WriteInteger('EFT','VolNo',VolNo);
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
                               ShowDlg : Boolean) : Boolean;
begin
  if ShowDlg then
    Result := GetEFTOptionsDlg(Filename, TheRec)
  else
  begin
   Result := True;
   TheRec := ReadEFTSettings(Filename);
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
      CanClose := False;
      ShowMessage('Invalid number in Volume Number field');
    End;

  end; {if modal result}


end;

end.
