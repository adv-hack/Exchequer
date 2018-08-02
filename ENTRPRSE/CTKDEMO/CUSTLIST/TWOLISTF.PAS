unit TwoListF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComObj, Enterprise01_TLB;

type
  TForm1 = class(TForm)
    lstCust: TListBox;
    btnGetFirstCust: TButton;
    btnGetPrevCust: TButton;
    btnGetNextCust: TButton;
    btnGetLastCust: TButton;
    lstSupp: TListBox;
    btnGetFirstSupp: TButton;
    btnGetPrevSupp: TButton;
    btnGetNextSupp: TButton;
    btnGetLastSupp: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnGetFirstCustClick(Sender: TObject);
    procedure btnGetPrevCustClick(Sender: TObject);
    procedure btnGetNextCustClick(Sender: TObject);
    procedure btnGetLastCustClick(Sender: TObject);
    procedure btnGetFirstSuppClick(Sender: TObject);
    procedure btnGetPrevSuppClick(Sender: TObject);
    procedure btnGetNextSuppClick(Sender: TObject);
    procedure btnGetLastSuppClick(Sender: TObject);
    procedure lstSuppDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1    : TForm1;
  oToolkit : IToolkit;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  // Create as OLE Object
  oToolkit := CreateOleObject ('Enterprise01.Toolkit') As IToolkit;

  // Check it created OK
  If Assigned(oToolkit) Then Begin
    // Open Toolkit
    //oToolkit.Configuration.DataDirectory := 'f:\431sep19\';
    //oToolkit.Configuration.EnterpriseDirectory := 'f:\431sep19\';
    FuncRes := oToolkit.OpenToolkit;

    If (FuncRes <> 0) Then Begin
      // Error opening Toolkit - display error and shutdown app normally
      MessageDlg ('The following error occured opening the Toolkit:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                  mtError, [mbOk], 0);
      Application.Terminate;
    End; { If (FuncRes <> 0) }
  End; { If Assigned(oToolkit) }
end;

procedure TForm1.btnGetFirstCustClick(Sender: TObject);
begin
  With oToolkit.Customer Do
    If GetFirst = 0 Then
      lstCust.Items.Add (acCode + ' - ' + acCompany);
end;

procedure TForm1.btnGetPrevCustClick(Sender: TObject);
begin
  With oToolkit.Customer Do
    If GetPrevious = 0 Then
      lstCust.Items.Add (acCode + ' - ' + acCompany);
end;

procedure TForm1.btnGetNextCustClick(Sender: TObject);
begin
  With oToolkit.Customer Do
    If GetNext = 0 Then
      lstCust.Items.Add (acCode + ' - ' + acCompany);
end;

procedure TForm1.btnGetLastCustClick(Sender: TObject);
begin
  With oToolkit.Customer Do
    If GetLast = 0 Then
      lstCust.Items.Add (acCode + ' - ' + acCompany);
end;

procedure TForm1.btnGetFirstSuppClick(Sender: TObject);
begin
  With oToolkit.Supplier Do
    If GetFirst = 0 Then
      lstSupp.Items.Add (acCode + ' - ' + acCompany);
end;

procedure TForm1.btnGetPrevSuppClick(Sender: TObject);
begin
  With oToolkit.Supplier Do
    If GetPrevious = 0 Then
      lstSupp.Items.Add (acCode + ' - ' + acCompany);
end;

procedure TForm1.btnGetNextSuppClick(Sender: TObject);
begin
  With oToolkit.Supplier Do
    If GetNext = 0 Then
      lstSupp.Items.Add (acCode + ' - ' + acCompany);
end;

procedure TForm1.btnGetLastSuppClick(Sender: TObject);
begin
  With oToolkit.Supplier Do
    If GetLast = 0 Then
      lstSupp.Items.Add (acCode + ' - ' + acCompany);
end;

procedure TForm1.lstSuppDblClick(Sender: TObject);
begin
  With Sender as TListBox Do
    Clear;
end;

end.
