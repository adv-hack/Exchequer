unit DemoF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, E365UtilIntf, StdCtrls;

type
  TfrmDemo = class(TForm)
    btnCreateMap: TButton;
    btnDestroyMap: TButton;
    btnClearMap: TButton;
    Label1: TLabel;
    edtCompanyCode: TEdit;
    Label2: TLabel;
    edtUserID: TEdit;
    Label3: TLabel;
    edtPassword: TEdit;
    btnAddCompanyDetails: TButton;
    procedure btnCreateMapClick(Sender: TObject);
    procedure btnDestroyMapClick(Sender: TObject);
    procedure btnClearMapClick(Sender: TObject);
    procedure btnAddCompanyDetailsClick(Sender: TObject);
  private
    { Private declarations }
    procedure ShowError (Const Res : Integer; Const ErrorDesc : ShortString);
  public
    { Public declarations }
  end;

var
  frmDemo: TfrmDemo;

implementation

{$R *.dfm}

//=========================================================================

procedure TfrmDemo.ShowError (Const Res : Integer; Const ErrorDesc : ShortString);
Var
  pLastError : PCHAR;
  sLastError : ANSIString;
Begin // ShowError
  If (Res <> 0) Then
  Begin
    // Get error message
    pLastError := LastErrorString;
    sLastError := ' - ' + pLastError;
    StrDispose(pLastError);
  End //
  Else
    sLastError := '';
  ShowMessage (ErrorDesc + ': ' + IntToStr(Res) + sLastError);
End; // ShowError

//------------------------------

procedure TfrmDemo.btnCreateMapClick(Sender: TObject);
Var
  Res : LongInt;
begin
  // Create a new empty memory map
  Res := CreateMemoryMap;
  ShowError (Res, 'CreateMemoryMap');
end;

//------------------------------

procedure TfrmDemo.btnDestroyMapClick(Sender: TObject);
Var
  Res : LongInt;
begin
  // Destroy an existing memory map created by this app
  Res := DestroyMemoryMap;
  ShowError (Res, 'DestroyMemoryMap');
end;

//------------------------------

procedure TfrmDemo.btnClearMapClick(Sender: TObject);
Var
  Res : LongInt;
begin
  // Clear out the contents of an existing mempory map
  Res := ClearMemoryMap;
  ShowError (Res, 'ClearMemoryMap');
end;

//------------------------------

procedure TfrmDemo.btnAddCompanyDetailsClick(Sender: TObject);
Var
  CompanyCode, UserId, Password : ANSIString;
  Res : LongInt;
begin
  CompanyCode := edtCompanyCode.Text;
  UserId := edtUserID.Text;
  Password := edtPassword.Text;
  Res := AddCompanyUser (PCHAR(CompanyCode), PCHAR(UserId), PCHAR(Password));
  ShowError (Res, 'AddCompanyUser');
end;

//=========================================================================

end.
