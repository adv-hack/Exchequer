unit AuthSlct;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AuthBase;

type
  TfrmSelectAuth = class(TForm)
    Button1: TButton;
    btnAuto: TButton;
    Button3: TButton;
    gbApp: TGroupBox;
    gbAuth: TGroupBox;
    lbApprovers: TListBox;
    lbAuthorisers: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lbApproversClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAutoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
     Auto : Boolean;
     procedure LoadApprovers;
     procedure LoadAuthorisers;
  public
    { Public declarations }
    AuthObject : TPaAuthorizer;
    RequestAmount : Double;
    WantApprovers : Boolean;
    Approver, Authoriser, UserID, ApproverCode : ShortString;
    TransRef : String;
    procedure SetUp;
  end;

var
  frmSelectAuth: TfrmSelectAuth;

implementation

{$R *.DFM}
uses
 { ComU,} AppCode;

procedure TfrmSelectAuth.LoadApprovers;
var
  Res : SmallInt;
begin
  if Assigned(AuthObject) then
  with AuthObject do
  begin
    Index := 0;
    Res := GetFirst;

    while Res = 0 do
    begin
      if CanAuthorize(TransRef) then
      begin

        lbApprovers.Items.Add(Name);
        if Name = UserID then
          ApproverCode := AuthCode;
      end;

      Res := GetNext;
    end;
  end;

end;

procedure TfrmSelectAuth.LoadAuthorisers;
var
  Res : SmallInt;
begin
  if Assigned(AuthObject) then
  with AuthObject do
  begin
    Index := 0;
    Res := GetFirst;

    while Res = 0 do
    begin
      if CanAuthorize(TransRef) and not ApprovalOnly and (MaxAuthAmount >= RequestAmount) then
        lbAuthorisers.Items.Add(Name);

      Res := GetNext;
    end;
  end;

end;


procedure TfrmSelectAuth.FormCreate(Sender: TObject);
begin
  AuthObject := nil;
  RequestAmount := 0.0;
  WantApprovers := True;
  Auto := False;
end;

procedure TfrmSelectAuth.SetUp;
begin
  LoadAuthorisers;

  if WantApprovers then
    LoadApprovers
  else
  begin
    lbApprovers.Enabled := False;
    gbApp.Visible := False;
    gbAuth.Top := gbApp.Top;
    Height := 145;
  end;
end;

procedure TfrmSelectAuth.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  Appform : TfrmAppCode;
begin
  CanClose := (ModalResult <> mrOK) or (((lbAuthorisers.ItemIndex >= 0) or Auto) and
              (not WantApprovers or (lbApprovers.ItemIndex >= 0)) );
  if CanClose and (ModalResult = mrOK) and WantApprovers and
     (lbApprovers.Items[lbApprovers.ItemIndex] = UserID) then
  begin
    AppForm := TfrmAppCode.Create(Application);
    Try
      AppForm.ShowModal;
      if AppForm.ModalResult = mrOK then
      begin
        CanClose := Trim(Appform.edtAppcode.Text) = Trim(ApproverCode);
        if not CanClose then
          ShowMessage('Incorrect authorisation code');
      end
      else
        CanClose := False;
    Finally
      AppForm.Free;
    End;
  end;
end;

procedure TfrmSelectAuth.lbApproversClick(Sender: TObject);
var
  i : integer;
  s : string;
begin
  if lbApprovers.ItemIndex >= 0 then
  begin
    s := lbApprovers.Items[lbApprovers.ItemIndex];
    if AuthObject.GetEqual(s) = 0 then
      s := AuthObject.DefaultAuthoriser;
    i := lbAuthorisers.Items.IndexOf(s);
    if i >= 0 then
      lbAuthorisers.ItemIndex := i;
  end;
end;

procedure TfrmSelectAuth.FormActivate(Sender: TObject);
begin
{  if not IsLibrary then
    Form1.EntCustom1.IntF.SysFunc.entActivateClient(Self.Handle);}
end;

procedure TfrmSelectAuth.FormDestroy(Sender: TObject);
begin
{  if not IsLibrary then
    SetForegroundWindow(Form1.EntCustom1.IntF.SysFunc.hwnd);}
end;

procedure TfrmSelectAuth.btnAutoClick(Sender: TObject);
begin
  Auto := True;
end;

procedure TfrmSelectAuth.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ModalResult = mrOK then
  begin
    if WantApprovers then
      Approver := lbApprovers.Items[lbApprovers.ItemIndex];
    if Auto then
      Authoriser := ''
    else
      Authoriser := lbAuthorisers.Items[lbAuthorisers.ItemIndex];
  end;
end;

end.
