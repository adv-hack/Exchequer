unit CCListF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComObj, Enterprise01_TLB;

type
  TfrmCCDept = class(TForm)
    lstCC: TListBox;
    Label1: TLabel;
    lstDept: TListBox;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure LoadList;
  public
    { Public declarations }
  end;

var
  frmCCDept : TfrmCCDept;
  oToolkit  : IToolkit;

implementation

{$R *.DFM}

procedure TfrmCCDept.FormCreate(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  // Create as OLE Object
  oToolkit := CreateOleObject ('Enterprise01.Toolkit') As IToolkit;

  // Check it created OK
  If Assigned(oToolkit) Then Begin
    // Open Toolkit
    FuncRes := oToolkit.OpenToolkit;

    If (FuncRes = 0) Then
      // Load Location List
      LoadList
    Else Begin
      // Error opening Toolkit - display error and shutdown app normally
      MessageDlg ('The following error occured opening the Toolkit:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                  mtError, [mbOk], 0);
      Application.Terminate;
    End; { Else }
  End; { If Assigned(oToolkit) }
end;

{----------------------------------------}

// Load List view with CostCentre/Department details
procedure TfrmCCDept.LoadList;
Var
  FuncRes, FuncRes2 : LongInt;
begin { LoadList }
  If Assigned(oToolkit) Then
    With oToolkit Do Begin
      // Clear out any previous data
      lstCC.Clear;
      lstDept.Clear;

      // Traverse Databases adding items into list in parallel - proves not
      // interference between CostCentre and Department objects
      With CostCentre Do Begin
        Index := cdIdxCode;
        FuncRes := GetFirst;
      End; { With CostCentre }

      With Department Do Begin
        Index := cdIdxCode;
        FuncRes2 := GetFirst;
      End; { With Department }

      While (FuncRes = 0) or (FuncRes2 = 0) Do Begin
        If (FuncRes = 0) Then
          With CostCentre Do Begin
            lstCC.Items.Add (cdCode + #9 + cdName);
            FuncRes := GetNext;
          End; { With CostCentre }

        If (FuncRes2 = 0) Then
          With Department Do Begin
            lstDept.Items.Add (cdCode + #9 + cdName);
            FuncRes2 := GetNext;
          End; { With Department }
      End; { While (FuncRes = 0) or (FuncRes2 = 0) }
    End; { With oToolkit }
end; { LoadList }

{----------------------------------------}

end.
