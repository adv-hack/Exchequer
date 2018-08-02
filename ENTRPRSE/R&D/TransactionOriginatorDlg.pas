unit TransactionOriginatorDlg;
{
  CJS - 2013-08-14 - MRD2.6 - Transaction Originator - dialog to allow the user
  to select an Originator filter for the Sales/Purchase daybook.
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GlobVar, VarConst, BtrvU2;

type
  TTransactionOriginatorDlg = class(TForm)
    UserLbl: TLabel;
    UserList: TComboBox;
    OkBtn: TButton;
    CancelBtn: TButton;
  private
    { Private declarations }
    function GetUser: string;
    procedure PopulateUserList;
    procedure SetUser(const Value: string);
  public
    { Public declarations }
    procedure Prepare;
    property User: string read GetUser write SetUser;
  end;

implementation

{$R *.dfm}

{ TTransactionOriginatorDlg }

function TTransactionOriginatorDlg.GetUser: string;
begin
  if (UserList.ItemIndex > -1) then
    Result := Trim(UserList.Items[UserList.ItemIndex])
  else
    Result := '';
end;

procedure TTransactionOriginatorDlg.PopulateUserList;
var
  Key: Str255;
  FuncRes: LongInt;
begin
  // Locate the Users in the Password table, and add the log-in names to the
  // list.
  Key := PassUCode + #0;
  FuncRes := Find_Rec(B_GetGEq, F[PwrdF], PWrdF, RecPtr[PWrdF]^, 0, Key);
  while (FuncRes = 0) and (Password.RecPfix = PassUCode) and (Password.SubType = #0) do
  begin
    UserList.Items.Add(Trim(Password.PassEntryRec.Login));
    FuncRes := Find_Rec(B_GetNext, F[PwrdF], PWrdF, RecPtr[PWrdF]^, 0, Key);
  end;
  UserList.ItemIndex := 0;
end;

procedure TTransactionOriginatorDlg.Prepare;
begin
  // Prepare the list of users
  PopulateUserList;
  // Only allow OK if there are actually users in the list (in theory this
  // should always be true)
  OkBtn.Enabled := UserList.Items.Count > 0;
end;

procedure TTransactionOriginatorDlg.SetUser(const Value: string);
begin
  UserList.ItemIndex := UserList.Items.IndexOf(Value);
end;

end.
