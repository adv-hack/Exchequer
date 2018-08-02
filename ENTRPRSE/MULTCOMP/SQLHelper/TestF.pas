unit TestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, StrUtils;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edtVMainDir: TEdit;
    Label3: TLabel;
    edtVDemoData: TEdit;
    Label4: TLabel;
    edtV_SQLDBNAME: TEdit;
    Label5: TLabel;
    edtVDLLERROR: TEdit;
    Label6: TLabel;
    edtVSQLCREATEDB: TEdit;
    cbSQLSERVER: TComboBox;
    btnCreateDatabase: TButton;
    Label7: TLabel;
    edtResult: TEdit;
    btnCreateCompany: TButton;
    Label8: TLabel;
    edtV_GETCOMPCODE: TEdit;
    Label9: TLabel;
    edtV_GETCOMPNAME: TEdit;
    Label10: TLabel;
    edtSQL_DATA: TEdit;
    Label11: TLabel;
    edtV_COMPDIR: TEdit;
    Label12: TLabel;
    edtSQL_USERLOGIN: TEdit;
    Label13: TLabel;
    edtSQL_USERPASS: TEdit;
    chkDebugMode: TCheckBox;
    Label14: TLabel;
    edtV_SQLCREATECOMP: TEdit;
    btnAdminPassword: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCreateDatabaseClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCreateCompanyClick(Sender: TObject);
    procedure btnAdminPasswordClick(Sender: TObject);
  private
    { Private declarations }
    oVariableControls : TStringList;
    Procedure SetupVariables (Const FuncID : LongInt);
    Procedure RunSQLHelper;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Uses SQLH_MemMap, APIUtil, SQLUtils;

//=========================================================================

procedure TForm1.FormCreate(Sender: TObject);
begin
  oVariableControls := TStringList.Create;
end;

//------------------------------

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(oVariableControls);
end;

//-------------------------------------------------------------------------

Procedure TForm1.SetupVariables (Const FuncID : LongInt);

  Procedure AddMapVariable (Const VarName, VarValue : ShortString; Const Control : TWinControl = NIL);
  Begin // AddMapVariable
    GlobalSetupMap.AddVariable (VarName, VarValue);
    If Assigned(Control) Then
    Begin
      oVariableControls.AddObject (VarName, Control);
      If (Control Is TEdit) Then
        TEdit(Control).Font.Color := clBlack
      Else If (Control Is TComboBox) Then
        TComboBox(Control).Font.Color := clBlack;
    End; // If Assigned(Control)
  End; // AddMapVariable

Begin // SetupVariables
  oVariableControls.Clear;

  GlobalSetupMap.Clear;
  GlobalSetupMap.FunctionId := FuncID;

  AddMapVariable ('L_DBTYPE', '1');
  AddMapVariable ('SQLSERVER', cbSQLSERVER.Text, cbSQLSERVER);
  AddMapVariable ('V_MAINDIR', edtVMainDir.Text, edtVMainDir);
  AddMapVariable ('V_DEMODATA', edtVDemoData.Text, edtVDemoData);
  AddMapVariable ('V_SQLDBNAME', edtV_SQLDBNAME.Text, edtV_SQLDBNAME);

  AddMapVariable ('V_GETCOMPCODE', edtV_GETCOMPCODE.Text, edtV_GETCOMPCODE);
  AddMapVariable ('V_GETCOMPNAME', edtV_GETCOMPNAME.Text, edtV_GETCOMPNAME);
  AddMapVariable ('SQL_DATA', edtSQL_DATA.Text, edtSQL_DATA);
  AddMapVariable ('V_COMPDIR', edtV_COMPDIR.Text, edtV_COMPDIR);
  AddMapVariable ('SQL_USERLOGIN', edtSQL_USERLOGIN.Text, edtSQL_USERLOGIN);
  AddMapVariable ('SQL_USERPASS', edtSQL_USERPASS.Text, edtSQL_USERPASS);

  AddMapVariable ('V_DLLERROR', edtVDLLERROR.Text, edtVDLLERROR);
  AddMapVariable ('V_SQLCREATEDB', edtVSQLCREATEDB.Text, edtVSQLCREATEDB);
  AddMapVariable ('V_SQLCREATECOMP', edtV_SQLCREATECOMP.Text, edtV_SQLCREATECOMP);
End; // SetupVariables

//-------------------------------------------------------------------------

Procedure TForm1.RunSQLHelper;
Var
  I, Idx : LongInt;
  oControl : TWinControl;
Begin // RunSQLHelper
  If chkDebugMode.Checked Then
    ShowMessage ('Debug SQLHelpr.Exe Now')
    //ShowMessage ('Run ' + IncludeTrailingPathDelimiter(GlobalSetupMap.Variables[GlobalSetupMap.IndexOf ('V_MAINDIR')].vdValue) + 'SQLHELPR.EXE /SQLBODGE')
  Else
    RunApp(ExtractFilePath(Application.ExeName) + 'SQLHELPR.EXE /SQLBODGE', True);

  edtResult.Text := BoolToStr(GlobalSetupMap.Result, True);

  // Extract any changed parameters - V_DLLERROR etc...
  For I := 1 To GlobalSetupMap.VariableCount Do
  Begin
    With GlobalSetupMap.Variables[I] Do
    Begin
      If vdChanged Then
      Begin
        Idx := oVariableControls.IndexOf (vdName);
        If (Idx > -1) Then
        Begin
          oControl := TWinControl(oVariableControls.Objects[Idx]);
          If (oControl Is TEdit) Then
          Begin
            TEdit(oControl).Text := vdValue;
            TEdit(oControl).Font.Color := clRed;
          End // If (oControl Is TEdit)
          Else If (oControl Is TComboBox) Then
          Begin
            TComboBox(oControl).Text := vdValue;
            TComboBox(oControl).Font.Color := clRed;
          End // If (oControl Is TComboBox)
        End; // If (Idx > -1)
      End; // If gvdChanged
    End; // With GlobalSetupMap.Variables[I]
  End; // For I
End; // RunSQLHelper

//-------------------------------------------------------------------------

procedure TForm1.btnCreateDatabaseClick(Sender: TObject);
begin
  SetupVariables(fnCreateSQLDatabase);
  RunSQLHelper;
end;

//------------------------------

procedure TForm1.btnCreateCompanyClick(Sender: TObject);
begin
  SetupVariables(fnCreateSQLCompany);
  RunSQLHelper;
end;

//------------------------------



procedure TForm1.btnAdminPasswordClick(Sender: TObject);

//  {generate an admin password based on a guid}
//  Function AdminPassword: String;
//  Const
//    Symbols : Array[1..10] of String = ('$', '*', '-', '!', '#', '@', '%', '&', '~', '.');
//    Alpha   : Array[1..26] Of String = ('a','b','c','d','e','f','g','h','j','i','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z');
//    Numeric : Array[1..10] Of String = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
//  Var
//    GUID: TGUID;
//    sGUID : ShortString;
//  Begin
//    CreateGUID(GUID);
//    sGUID := StringReplace(GUIDToString(GUID), '-', '', [rfReplaceAll]);
//
//    // Due to possible password complexity requirements within SQL Server always have 1 symbol + 1 lowercase + 1 uppercase + 1 number
//    Result := RandomFrom(Symbols) + RandomFrom(Alpha) + UpperCase(RandomFrom(Alpha)) + RandomFrom(Numeric) + Copy(sGUID, 2, 26);
//  End;

begin
  ShowMessage (AdminPassword);
end;

end.
