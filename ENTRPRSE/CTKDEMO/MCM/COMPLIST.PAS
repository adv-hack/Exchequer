unit CompList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ComObj, Enterprise01_TLB, StdCtrls;

type
  TfrmMCM = class(TForm)
    lvCompanies: TListView;
    edtEnterpriseDir: TEdit;
    Label1: TLabel;
    btnUpdate: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadList;
  public
    { Public declarations }
  end;

var
  frmMCM   : TfrmMCM;
  oToolkit : IToolkit;

implementation

{$R *.DFM}

procedure TfrmMCM.FormCreate(Sender: TObject);
begin
  // Create as OLE Object
  oToolkit := CreateOleObject ('Enterprise01.Toolkit') As IToolkit;

  // Check it created OK
  If Assigned(oToolkit) Then Begin
    // Open Toolkit
    edtEnterpriseDir.Text := oToolkit.Configuration.EnterpriseDirectory;

    LoadList;
  End; { If Assigned(oToolkit) }
end;

{----------------------------------------}

// Load List view with company details
procedure TfrmMCM.LoadList;
Var
  I : SmallInt;
begin { LoadList }
  If Assigned(oToolkit) Then
    With lvCompanies Do Begin
      // Clear out any previous data
      Items.Clear;

      // Load Companies into list view
      With oToolkit.Company Do
        If (cmCount > 0) Then
          For I := 1 to cmCount Do
            With cmCompany[I], Items.Add Do Begin
              // Add into ListView
              Caption := Trim(coCode);
              SubItems.Add (Trim(coName));
              SubItems.Add (Trim(coPath));
            End; { With cmCompany[I], Items.Add }
    End; { With lvCustomers }
end; { LoadList }

{----------------------------------------}

procedure TfrmMCM.btnUpdateClick(Sender: TObject);
begin
  If Assigned(oToolkit) Then
    With oToolkit Do Begin
      // Reset path to Enterprise directory and reload list
      Configuration.EnterpriseDirectory := edtEnterpriseDir.Text;
      LoadList;
    End; { With oToolkit }
end;

{----------------------------------------}

end.
