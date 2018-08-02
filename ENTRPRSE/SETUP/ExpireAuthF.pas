unit ExpireAuthF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TCustom;

type
  TfrmAuthoriseExpire = class(TForm)
    Panel1: TPanel;
    btnContinue: TSBSButton;
    btnCancel: TSBSButton;
    chkContinue: TCheckBox;
    Label5: TLabel;
    Image1: TImage;
    procedure chkContinueClick(Sender: TObject);
    procedure Label5MouseEnter(Sender: TObject);
    procedure Label5MouseLeave(Sender: TObject);
    procedure Label5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SetupPath : string;
  end;

  function ContinueWithExpireAuthorise(const ExchequerPath : string; CDPath : string) : Boolean;

var
  frmAuthoriseExpire: TfrmAuthoriseExpire;

implementation

uses
  SQLH_MemMap, IniFiles, WiseUtil, ApiUtil;


{$R *.dfm}
function ContinueWithExpireAuthorise(const ExchequerPath : string; CDPath : string) : Boolean;

  //Reads EntCustm.ini and returns true if ExpaHook is in the HookChain section of EntCustm.ini
  function AuthoriseInIniFile : Boolean;
  var
    IniFileName : string;
    CustIni : TIniFile;
    i : integer;
    AList : TStringList;
  begin
    Result := False;
    IniFileName := IncludeTrailingBackslash(ExchequerPath) + 'EntCustm.ini';
    if FileExists(IniFileName) then
    begin
      CustIni := TIniFile.Create(IniFileName);
      AList := TStringList.Create;
      with AList do
      Try
        CustIni.ReadSectionValues('HOOKCHAIN', AList);
        for i := 0 to AList.Count - 1 do
        begin
          if Pos('EXPAHOOK', UpperCase(AList[i])) > 0 then
          begin
            Result := True;
            Break;
          end;
        end;
      Finally
        Free;
      End;
    end;
  end;

begin
  //Only show message if Expahook.dll is in the Enterprise folder and in the hookchain in EntCustm.ini
  if FileExists(IncludeTrailingBackslash(ExchequerPath) + 'ExpaHook.dll') and AuthoriseInIniFile then
  begin
    with TfrmAuthoriseExpire.Create(nil) do
    Try
      SetupPath := CDPath;
      ShowModal;
    Finally
      Result := (ModalResult = mrOK) and (chkContinue.Checked);
      Free;
    End;
  end
  else
    Result := True;
end;

procedure TfrmAuthoriseExpire.chkContinueClick(Sender: TObject);
begin
  //Only allow user to continue if the tick the check box
  btnContinue.Enabled := chkContinue.Checked;
end;

procedure TfrmAuthoriseExpire.Label5MouseEnter(Sender: TObject);
begin
  Screen.Cursor := crHandPoint;
end;

procedure TfrmAuthoriseExpire.Label5MouseLeave(Sender: TObject);
begin
  Screen.Cursor := crDefault;
end;

procedure TfrmAuthoriseExpire.Label5Click(Sender: TObject);
begin
  GlobalSetupMap.Clear;
  GlobalSetupMap.FunctionId := fnExpireAuthWebpage;

  RunApp(SetupPath + 'SETHELPR.EXE /SETUPBODGE', True);
end;

end.
