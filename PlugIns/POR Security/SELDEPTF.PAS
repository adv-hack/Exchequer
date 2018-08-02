unit SelDeptF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfrmSelectDept = class(TForm)
    lvDepartments: TListView;
    btnSelect: TButton;
    procedure btnSelectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Function SelectDept : ShortString;

implementation

{$R *.DFM}

Uses INIIntf;

Function SelectDept : ShortString;
Begin { SelectDept }
  With TfrmSelectDept.Create(Application.MainForm) Do
    Try
      ShowModal;

      Result := lvDepartments.Selected.Caption;
    Finally
      Free;
    End;
End; { SelectDept }

{-------------------------------------------}

procedure TfrmSelectDept.FormCreate(Sender: TObject);
begin
  Settings.ReadDeptsIntoListView (lvDepartments);
end;

{-------------------------------------------}

procedure TfrmSelectDept.btnSelectClick(Sender: TObject);
begin
  If Assigned(lvDepartments.Selected) Then
    Close
  Else
    MessageDlg('A valid Department Code must be selected', mtWarning, [mbOK], 0);
end;

end.
