unit CompDelt;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_DEPRECATED OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, bkgroup, BorBtns;

type
  TDeleteCompany = class(TForm)
    CancelBtn: TButton;
    Remove: TBorRadio;
    Delete: TBorRadio;
    DelBtn: TButton;
    SBSBackGroup1: TSBSBackGroup;
    SBSBackGroup4: TSBSBackGroup;
    Label81: Label8;
    Label82: Label8;
    Label83: Label8;
    Label84: Label8;
    Label85: Label8;
    Label86: Label8;
    procedure CancelBtnClick(Sender: TObject);
    procedure DelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DelAreaClick(Sender: TObject);
    procedure RemoveAreaClick(Sender: TObject);
    procedure DoCheckyChecky(Sender: TObject);
  private
    { Private declarations }
    LockPos : LongInt;
  public
    { Public declarations }
    CompLocked : Boolean;
  end;

implementation

{$R *.DFM}

Uses GlobVar, VarConst, VarFPosU,
     GroupCompFile,   // Definition of GroupCmp.Dat (GroupCompXrefF) and utility functions
     EntLicence,
     CompInfo,
{$IFDEF EXSQL}
     SQLUtils,
{$ENDIF}
     BtrvU2, BtSupU1;

procedure TDeleteCompany.FormCreate(Sender: TObject);
Var
  Key2F      : Str255;
  OK, Locked : Boolean;
Begin
  { Lock company record }
  Status := 0;
  Locked := BOn;
  Key2F := Company^.RecPFix + Company^.CompDet.CompCode;
  Ok:=GetMultiRec(B_GetEq,B_MultLock,Key2F,CompCodeK,CompF,True,Locked);
  Report_BError(CompF, Status);

  Status:=GetPos(F[CompF],CompF,LockPos);

  CompLocked := OK And StatusOk And Locked;

  { Set caption }
  Caption := 'Detach ''' + Trim(Company^.CompDet.CompName) + '''';
  DoCheckyChecky(Self);
end;

procedure TDeleteCompany.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  { Unlock company record }
  Status:=UnlockMultiSing(F[SysF],SysF,LockPos);
end;

procedure TDeleteCompany.DelBtnClick(Sender: TObject);
Var
  CurDirStr : String;
  Msg       : ShortString;
  iRes      : Integer;

  { Attempts to open the Job Ctrl file exclusively }
  Function Check4Open (CompPath : ShortString) : Boolean;
  Begin
    If EnterpriseLicence.IsSQL Then
      Result := SQLUtils.ExclusiveAccess(CompPath)
    Else
    Begin
      Result := True;

      CompPath := Trim(CompPath) + FileNames[JCtrlF];

      If FileExists (CompPath) Then Begin
        Status:=Open_File(F[JCtrlF], CompPath, -4); { Exclusive }

        If StatusOk Then
          Status := Close_File(F[JCtrlF])
        Else
          Result := False;
      End; { If }
    End; // Else
  End;

  Procedure ProcessDir (Const DirPath, IndStr : ShortString);
  Var
    FileInfo : TSearchRec;
    FStatus  : SmallInt;
    TypeStr  : ShortString;
  Begin
    FStatus := FindFirst(DirPath + '*.*', faDirectory or faHidden or faReadOnly, FileInfo);

    While (FStatus = 0) Do Begin
      If (FileInfo.Name <> '.') And (FileInfo.Name <> '..') Then Begin
        {
        TypeStr := '(';
        If ((FileInfo.Attr And faReadOnly) = faReadOnly) Then TypeStr := TypeStr + 'RO ';
        If ((FileInfo.Attr And faHidden) = faHidden) Then TypeStr := TypeStr + 'HID ';
        If ((FileInfo.Attr And faSysFile) = faSysFile) Then TypeStr := TypeStr + 'SYS ';
        If ((FileInfo.Attr And faVolumeID) = faVolumeID) Then TypeStr := TypeStr + 'VID ';
        If ((FileInfo.Attr And faDirectory) = faDirectory) Then TypeStr := TypeStr + 'DIR ';
        If ((FileInfo.Attr And faArchive) = faArchive) Then TypeStr := TypeStr + 'ARCH ';
        If ((FileInfo.Attr And faAnyFile) = faAnyFile) Then TypeStr := TypeStr + 'ANY ';
        TypeStr := Trim(TypeStr) + ')';

        ListBox1.Items.Add (IndStr + FileInfo.Name + #9 + TypeStr);
        }

        If ((FileInfo.Attr And faDirectory) = faDirectory) Then Begin
          { Delete files in directory }
          ProcessDir (DirPath + FileInfo.Name + '\', '  ' + IndStr);
        End { If }
        Else Begin
          Try
            { Ordinary file - take off any hidden/read only attributes }
            If ((FileInfo.Attr And faHidden) = faHidden) Or
               ((FileInfo.Attr And faReadOnly) = faReadOnly) Then Begin
              { Hidden/Read-Only }
              FileSetAttr (DirPath + FileInfo.Name, 0);
            End; { If }

            { Delete it }
            DeleteFile (DirPath + FileInfo.Name);
          Except
            On Exception Do ;
          End;
        End; { If }
      End; { If }

      FStatus := FindNext(FileInfo);
    End; { While }

    FindClose (FileInfo);

    { Delete main directory }
    Try
      RmDir (DirPath);
    Except
      On Exception Do ;
    End;
  End;

begin
  { Save Current Directory - just in case - And I'm NOT paranoid }
  CurDirStr := GetCurrentDir;

  With Company^, CompDet Do Begin
    { Check to see if company is being used - open Job Control file exclusively }
    If Check4Open (CompPath) Then Begin
      { Time for another dire warning }
      If Remove.Checked Then
        Msg := 'The company ''' + Trim(CompName) + ''' is going to be removed from the list of companies.' + #10#13 +
               #10#13 +
               'The program and data files for the company will be left intact.' + #10#13 +
               #10#13 +
               'Do you want to continue?'
      Else
        Msg := 'The company ''' + Trim(CompName) + ''' is going to be removed from the list and ' +
               'all program and data files for the company will be deleted. Any changes that have ' +
               'been made since your last backup of the company will be lost.' + #10#13 +
               #10#13 +
               {'A deleted company must be restored from a backup if you need to use it again.' + #10#13 +
               #10#13 +}
               'Do you want to continue?';

      If (MessageDlg (Msg, mtWarning, [mbYes, mbNo], 0) = mrYes) Then
      Begin
        If EnterpriseLicence.IsSQL And Remove.Checked Then
        Begin
          // SQL - Detach Company - write Company.Info file needed for re-attachment
          WriteCompInfo (CompDet);
        End; // If EnterpriseLicence.IsSQL

        { Remove from the list }
        Status:=Delete_Rec(F[CompF],CompF,CompCodeK);

        // Remove any group entries for the company
        DeleteCompanyGroups (CompCode);

        // Triple check before deleting the files
        If Delete.Checked Then
        Begin
          // Delete Company
          Msg := 'Are you sure you want to delete all the program and data files for the company?';
          If (MessageDlg (Msg, mtWarning, [mbYes, mbNo], 0) = mrYes) Then Begin
            { OK - Kill the company files }
            ProcessDir (Trim(CompPath), '');
{$IFDEF EXSQL}
            If EnterpriseLicence.IsSQL Then
            Begin
              // SQL - Delete Company
              iRes := SQLUtils.DeleteCompany(CompCode);
              If (iRes <> 0) Then
              Begin
                Msg := 'Delete Company Error ' + IntToStr(iRes) + '"' + GetSQLErrorInformation(iRes) + '", please contact your technical support';
                MessageDlg (Msg, mtError, [mbOK], 0);
              End; // If (iRes <> 0)
            End; // If EnterpriseLicence.IsSQL
{$ENDIF}
          End; { If }
        End // If Delete.Checked
        Else If EnterpriseLicence.IsSQL Then
        Begin
{$IFDEF EXSQL}
          // SQL - Detach Company
          SQLUtils.DetachCompany(CompCode);
{$ENDIF}
        End; // If EnterpriseLicence.IsSQL

        { Update company list }
        SendMessage ((Owner as TForm).Handle, WM_CustGetRec, 300, 0);
      End; { If }
    End { If }
    Else
      { Someone is using it }
      MessageDlg ('Someone is using the company - Deletion Aborted', mtError, [mbOk], 0);
  End; { With }

  Close;

  { Restore Current Directory }
  SetCurrentDir(CurDirStr);
end;

procedure TDeleteCompany.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

(*
procedure TDeleteCompany.Button2Click(Sender: TObject);

  Procedure ProcessDir (Const DirPath, IndStr : ShortString);
  Var
    FileInfo : TSearchRec;
    FStatus  : SmallInt;
    TypeStr  : ShortString;
  Begin
    FStatus := FindFirst(DirPath + '*.*', faDirectory or faReadOnly, FileInfo);

    While (FStatus = 0) Do Begin
      If (FileInfo.Name <> '.') And (FileInfo.Name <> '..') Then Begin
        TypeStr := '(';
        If ((FileInfo.Attr And faReadOnly) = faReadOnly) Then TypeStr := TypeStr + 'RO ';
        If ((FileInfo.Attr And faHidden) = faHidden) Then TypeStr := TypeStr + 'HID ';
        If ((FileInfo.Attr And faSysFile) = faSysFile) Then TypeStr := TypeStr + 'SYS ';
        If ((FileInfo.Attr And faVolumeID) = faVolumeID) Then TypeStr := TypeStr + 'VID ';
        If ((FileInfo.Attr And faDirectory) = faDirectory) Then TypeStr := TypeStr + 'DIR ';
        If ((FileInfo.Attr And faArchive) = faArchive) Then TypeStr := TypeStr + 'ARCH ';
        If ((FileInfo.Attr And faAnyFile) = faAnyFile) Then TypeStr := TypeStr + 'ANY ';
        TypeStr := Trim(TypeStr) + ')';

        ListBox1.Items.Add (IndStr + FileInfo.Name + #9 + TypeStr);

        If ((FileInfo.Attr And faDirectory) = faDirectory) Then
          ProcessDir (DirPath + FileInfo.Name + '\', '  ' + IndStr);
      End; { If }

      FStatus := FindNext(FileInfo);
    End; { While }

    FindClose (FileInfo);
  End;

begin
  ProcessDir ('c:\eal\', '');
end;
*)

procedure TDeleteCompany.DelAreaClick(Sender: TObject);
begin
  Delete.Checked := True;
end;

procedure TDeleteCompany.RemoveAreaClick(Sender: TObject);
begin
  Remove.Checked := True;
end;

procedure TDeleteCompany.DoCheckyChecky(Sender: TObject);
begin
  If Remove.Checked Then
    DelBtn.Caption := 'Detach'
  Else
    DelBtn.Caption := 'Delete';
end;

end.
