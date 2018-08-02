unit GLTreeF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Enterprise01_TLB, COMObj;

type
  TDialogMode = (mdAdd, mdEdit, mdView);

  TfrmGeneralLedger = class(TForm)
    lstGLCodes: TListBox;
    btnAddGL: TButton;
    btnEditGL: TButton;
    btnViewGL: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAddGLClick(Sender: TObject);
    procedure btnEditGLClick(Sender: TObject);
    procedure btnViewGLClick(Sender: TObject);
  private
    { Private declarations }
    procedure DisplayGLCode (DlgMode : TDialogMode; ParentGL : LongInt);
    procedure LoadTree(ParentCode : LongInt; Const Indent : ShortString);
  public
    { Public declarations }
  end;

var
  frmGeneralLedger    : TfrmGeneralLedger;
  oToolkit : IToolkit;

implementation

{$R *.DFM}

Uses GLDetlF;

procedure TfrmGeneralLedger.FormCreate(Sender: TObject);
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
      // Load General Ledger Tree
      LoadTree(0, '')
    Else Begin
      // Error opening Toolkit - display error and shutdown app normally
      MessageDlg ('The following error occured opening the Toolkit:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                  mtError, [mbOk], 0);
      Application.Terminate;
    End; { Else }
  End; { If Assigned(oToolkit) }
end;

{----------------------------------------}

procedure TfrmGeneralLedger.LoadTree(ParentCode : LongInt; Const Indent : ShortString);
Var
  FuncRes, SavedPosition : LongInt;
Begin { LoadTree }
  If Assigned(oToolkit) Then
    With oToolkit.GeneralLedger Do Begin
      // Save position in file - keep local copy of position as the recursion will
      // overwrite the saved position in the GeneralLedger object many times.
      SavePosition;
      SavedPosition := Position;

      Index := glIdxParent;
      FuncRes := GetGreaterThanOrEqual(BuildCodeIndex(ParentCode));

      While (FuncRes = 0) And (glParent = ParentCode) Do Begin
        lstGLCodes.Items.Add (Indent + IntToStr(glCode) + ' ' + glName);

        If (glType = glTypeHeading) Then
          // Header - load any child GL Codes
          LoadTree (glCode, Indent + '    ');

        // Get next General Ledger Code in index
        FuncRes := GetNext;
      End; { While (FuncRes = 0) }

      // Restore starting position
      Position := SavedPosition;
      RestorePosition;
    End; { With GeneralLedger }
End; { LoadTree }

{----------------------------------------}

procedure TfrmGeneralLedger.DisplayGLCode (DlgMode : TDialogMode; ParentGL : LongInt);
Var
  FuncRes, FindCode : LongInt;
  TmpO              : IGeneralLedger;
  TmpS              : ShortString;
begin
  With oToolkit, GeneralLedger Do
    // Check 1 item is selected for editing
    If (DlgMode = mdAdd) Or (lstGLCodes.ItemIndex >= 0) Then Begin
      If (DlgMode <> mdAdd) Then Begin
        // Extract GL Code from list
        TmpS := TrimLeft(lstGLCodes.Items[lstGLCodes.ItemIndex]);
        Delete (TmpS, Pos (' ', TmpS), Length(TmpS));
        FindCode := StrToInt(TmpS);

        // Retrieve selected GL Code Details for View/Edit
        Index := glIdxCode;
        FuncRes := GetEqual(BuildCodeIndex(FindCode));
        If (FuncRes <> 0) Then
          MessageDlg ('The following error occured getting the GL Code Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                      mtError, [mbOk], 0);
      End { If (DlgMode <> mdAdd) }
      Else
        // Adding - no need to do anything
        FuncRes := 0;

      If (FuncRes = 0) Then Begin
        // AOK - create GL Detail window
        With TfrmGLDetail.Create(Self) Do
          Try
            // Position form nicely
            Left := Self.Left + 35;
            Top := Self.Top + 35;

            // Set window mode
            Mode := DlgMode;

            // Set Transaction Interface on detail window
            Case DlgMode Of
              mdAdd  : Begin
                         TmpO := GeneralLedger.Add;
                         TmpO.glParent := ParentGL;
                         GLDetail := TmpO;
                       End;
              mdEdit : GLDetail := GeneralLedger.Update;
              mdView : GLDetail := GeneralLedger.Clone;
            End; { Case }

            // Check we got a valid interface
            If Assigned (GLDetail) Then Begin
              // Display dialog
              ShowModal;

              // Reload list if changes were made
              If NeedRefresh Then Begin
                lstGLCodes.Clear;
                LoadTree (0, '');
              End; { If NeedRefresh }
            End { If Assigned (AccDetail) }
            Else
              ShowMessage ('The GL Code Detail is not available - someone else may be editing the GL Code');
          Finally
            Free;
          End;
      End; { If (FuncRes = 0) }
    End { If (DlgMode = mdAdd) Or (ItemIndex >= 0) }
    Else
      // No Item selected in list
      ShowMessage ('An item must be selected before it can be viewed');
end;

{----------------------------------------}

procedure TfrmGeneralLedger.btnAddGLClick(Sender: TObject);
Var
  FuncRes, FindCode : LongInt;
  TmpS              : ShortString;
begin
  With oToolkit.GeneralLedger Do Begin
    If (lstGLCodes.ItemIndex >= 0) Then Begin
      // Extract GL Code from list
      TmpS := TrimLeft(lstGLCodes.Items[lstGLCodes.ItemIndex]);
      Delete (TmpS, Pos (' ', TmpS), Length(TmpS));
      FindCode := StrToInt(TmpS);

      // Retrieve selected GL Code Details for View/Edit
      Index := glIdxCode;
      FuncRes := GetEqual(BuildCodeIndex(FindCode));
    End { If (lstGLCodes.ItemIndex >= 0) }
    Else
      // Force entry of root item
      FuncRes := -1;

    If (FuncRes = 0) Then Begin
      // Loophole: following code doesn't allow root items to be added - really
      // needs separate buttons for 'add child' and 'add sibling'

      If (glType = glTypeHeading) Then
        // Heading - Add as child of heading
        DisplayGLCode (mdAdd, glCode)
      Else
        // non-heading - add as sibling
        DisplayGLCode (mdAdd, glParent);
    End { If (FuncRes = 0) }
    Else
      DisplayGLCode (mdAdd, 0);
  End; { With oToolkit.GeneralLedger }
end;

{----------------------------------------}

procedure TfrmGeneralLedger.btnEditGLClick(Sender: TObject);
begin
  DisplayGLCode (mdEdit, 0);
end;

{----------------------------------------}

procedure TfrmGeneralLedger.btnViewGLClick(Sender: TObject);
begin
  DisplayGLCode (mdView, 0);
end;

{----------------------------------------}

end.
