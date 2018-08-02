unit JobListF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComObj, Enterprise01_TLB, StdCtrls;

type
  TfrmJobList = class(TForm)
    lstJobs: TListBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure LoadTree (Const ParentCode, Indent : ShortString);
  public
    { Public declarations }
  end;

var
  frmJobList : TfrmJobList;
  oToolkit   : IToolkit;

implementation

{$R *.DFM}

procedure TfrmJobList.FormCreate(Sender: TObject);
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

    If (FuncRes = 0) Then
      // Load Job Tree
      LoadTree (oToolkit.JobCosting.Job.BuildCodeIndex(''), '')
    Else Begin
      // Error opening Toolkit - display error and shutdown app normally
      MessageDlg ('The following error occured opening the Toolkit:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                  mtError, [mbOk], 0);
      Application.Terminate;
    End; { Else }
  End; { If Assigned(oToolkit) }
end;

{----------------------------------------}

procedure TfrmJobList.LoadTree (Const ParentCode, Indent : ShortString);
Var
  FuncRes, SavedPosition : LongInt;
begin { LoadTree }
  With oToolkit.JobCosting.Job Do Begin
    // Save position in file - keep local copy of position as the recursion will
    // overwrite the saved position in the GeneralLedger object many times.
    SavePosition;
    SavedPosition := Position;

    Index := jrIdxParent;
    FuncRes := GetGreaterThanOrEqual(BuildParentIndex(ParentCode, ''));
    While (FuncRes = 0) And (jrParent = ParentCode) Do Begin
      lstJobs.Items.Add (Indent + jrCode + ' ' + jrDesc);

      If (jrType = JTypeContract) Then
        // Header - load any child Jobs
        LoadTree (jrCode, Indent + '    ');

      FuncRes := GetNext;
    End; { While (Res = 0) }

    // Restore starting position
    Position := SavedPosition;
    RestorePosition;
  End; { With oToolkit.JobCosting.Jobs }
End; { LoadTree }

{----------------------------------------}

end.
