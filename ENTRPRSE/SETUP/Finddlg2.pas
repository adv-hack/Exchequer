unit Finddlg2;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, ExtCtrls, StdCtrls, FileCtrl, FilCtl95;

type
  TfrmFindDlg = class(TSetupTemplate)
    lstDirs: TListBox;
    btnSearch: TButton;
    Label2: TLabel;
    lblSearch: TLabel;
    DriveComboBox1: TDrive95ComboBox;
    procedure btnSearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstDirsDblClick(Sender: TObject);
  private
    { Private declarations }
    Procedure SearchDir (Const DirPath : ShortString);
    Function  PathSpace (Const OutText : String; Const OutLabel : TLabel) : String;

    Function  ValidOk(VCode : Char) : Boolean; OverRide;
  public
    { Public declarations }
    FindMode : Byte;
    CurrMode : Char;
    PathList : TComboBox;
  end;


implementation

{$R *.DFM}

procedure TfrmFindDlg.btnSearchClick(Sender: TObject);
begin
  inherited;

  { Stop them doing multiple searches simultaneously }
  btnSearch.Enabled := False;
  BackBtn.Enabled := False;
  NextBtn.Enabled := False;
  Try
    { Clear out any existing items }
    lstDirs.Items.Clear;

    { Do the search }
    Label2.Caption := 'Searching:';
    Label2.Refresh;

    SearchDir (DriveComboBox1.Text[1] + ':\');
    lblSearch.Caption := '';
    Label2.Caption := '';

    If (lstDirs.Items.Count > 0) Then Begin
      lstDirs.ItemIndex := 0;
    End; { If }
  Finally
    btnSearch.Enabled := True;
    BackBtn.Enabled := True;
    NextBtn.Enabled := (lstDirs.Items.Count > 0);
  End;
end;

Procedure TfrmFindDlg.SearchDir (Const DirPath : ShortString);
Var
  Info   : TSearchRec;
  Res    : SmallInt;
  GotSys : Boolean;
Begin { SearchDir }
  lblSearch.Caption := PathSpace (DirPath, lblSearch);
  lblSearch.Refresh;

  { Look for a System in the current directory }
  If FileExists(DirPath + 'exchqss.dat') Then Begin
    GotSys := False;
    Case FindMode Of
      1 : Begin { Find Exchequer }
            GotSys := FileExists (DirPath + 'ENTER1.EXE') And
                      DirectoryExists (DirPath + '\FORMS');
          End;
      2 : Begin { Find Exchequer DOS }
            GotSys := FileExists (DirPath + 'REX.BAT') And
                      Not DirectoryExists (DirPath + '\FORMS');
          End;
      3 : Begin { Find Exchequer DOS OR Exchequer}
            GotSys := FileExists (DirPath + 'REX.BAT') Or
                      FileExists (DirPath + 'ENTER1.EXE');
          End;
    End; { Case }

    If GotSys And (FindMode In [1..3]) Then Begin
      { Valid System - Check Currency Version is correct }
      If (CurrMode = 'S') Then Begin
        { Single Currency - check for DEFPF044.SYS and not DEFMC044.SYS }
        GotSys := FileExists (DirPath + 'DEFPF044.SYS') And Not FileExists (DirPath + 'DEFMC044.SYS');
      End { If }
      Else Begin
        { Multi Currency - check for DEFMC044.SYS and not DEFPF044.SYS }
        GotSys := FileExists (DirPath + 'DEFMC044.SYS') And Not FileExists (DirPath + 'DEFPF044.SYS');
      End; { Else }
    End; { If }

//ShowMessage ('DirPath: ' + DirPath +
//             #13'FindMode: ' + IntToStr(FindMode) +
//             #13'GotSys: ' + IntToStr(Ord(GotSys)));

    If GotSys Then Begin
      lstDirs.Items.Add (UpperCase(DirPath));

      If Assigned(PathList) Then
      Begin
        PathList.Items.Add (UpperCase(DirPath));
      End; { If }
    End; { If }
  End; { If }

  Res :=  FindFirst(DirPath + '*.*', faDirectory, Info);
  While (Res = 0) Do Begin
    If ((Info.Attr And faDirectory) = faDirectory) And
       (Info.Name[1] <> '.') Then Begin
      SearchDir (DirPath + Info.Name + '\');
    End; { If }

    Res := FindNext(Info);
  End; { While }

  FindClose (Info);
End;  { SearchDir }

Function TfrmFindDlg.ValidOk(VCode : Char) : Boolean;
Var
  TmpPath : String;
Begin
  Result := True;

  If (VCode = 'N') Then Begin
    { Check they have selected a path }
    Result := (lstDirs.ItemIndex > -1);

    If (Not Result) Then Begin
      MessageDlg ('A path must be selected', mtWarning, [mbOk], 0);
    End; { If }
  End; { If }
End;

procedure TfrmFindDlg.FormCreate(Sender: TObject);
begin
  inherited;

  NextBtn.Enabled := False;
end;

{ Converts a path to the ... version used in Win95 }
Function TfrmFindDlg.PathSpace (Const OutText : String; Const OutLabel : TLabel) : String;
Var
  ThePChar : PChar;
  p4       : TRect;
Begin
  ThePChar := StrAlloc (400);

  StrPCopy (ThePChar, OutText);

  p4 := Rect(0, 0, OutLabel.Width, OutLabel.Height);

  DrawTextEx(Self.Canvas.Handle,
             ThePChar,
             -1,
             p4,
             DT_CALCRECT Or DT_PATH_ELLIPSIS Or DT_MODIFYSTRING,
             Nil);

  Result := ThePChar;

  StrDispose(ThePChar);
End;


procedure TfrmFindDlg.lstDirsDblClick(Sender: TObject);
begin
  inherited;

  NextBtnClick(Sender);
end;

end.
