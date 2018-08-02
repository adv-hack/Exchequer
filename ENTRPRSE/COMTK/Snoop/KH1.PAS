unit kh1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BrwseDir, StdCtrls, Buttons, ExtCtrls;

type
  TfrmFileList = class(TForm)
    BitBtn1: TBitBtn;
    Panel1: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    Panel2: TPanel;
    list: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure listClick(Sender: TObject);
  private
    { Private declarations }
    DirDlg : TBrowseDirDialog;
    CurrentDir : string;
    CurrentIdx : integer;
    FList : TStringList;
    procedure LoadList;
    procedure CopyText;
  public
    { Public declarations }
  end;

  procedure SetHook; export;
  function HookProc(Code : Integer; wParam : WPARAM; lParam : LPARAM) : LRESULT stdcall;
  procedure EndHook; export;

var
  frmFileList: TfrmFileList;

implementation

{$R *.dfm}

uses
  ClipBrd, Stat;

var
  KHook : THandle;

  CtrlPressed : Boolean;


procedure SetHook;
begin

{  KHook := SetWindowsHookEx(WH_KEYBOARD, @HookProc, HInstance, 0);
  Result := KHook <> 0;}
  frmFileList := TfrmFileList.Create(nil);

end;

function HookProc(Code : Integer; wParam : WPARAM; lParam : LPARAM) : LRESULT;
begin
 if not Assigned(frmFileList) then
   SetHook;
 Result := 0;
 if Code >= 0 then
 begin
   if (wParam = vk_Control) then
    begin
      CtrlPressed := {(lparam and KF_Up) = 0}True;
    end
    else
    if wParam in [49, 50, 51] then
    begin
      if CtrlPressed then
      begin
        Case wParam of
          49  : frmFileList.CopyText;
          50  : frmFileList.Show;
          51  : frmFileList.Hide;
        end; //case
        CtrlPressed := False;
      end;
    end
    else
      CtrlPressed := False;
  end
  else
   { Result := CallNextHookEx(KHook, Code, wParam, lParam)};
end;

procedure EndHook;
begin
{  UnhookWindowsHookEx(KHook);}
  if Assigned(frmFileList) then
    frmFileList.Free;
end;


procedure TfrmFileList.FormCreate(Sender: TObject);
begin
  DirDlg := TBrowseDirDialog.Create;
  FList := TStringList.Create;
  frmStatus := TfrmStatus.Create(Self);
end;

procedure TfrmFileList.FormDestroy(Sender: TObject);
begin
  DirDlg.Free;
  FList.Free;
  frmStatus.Free;
end;

procedure TfrmFileList.BitBtn1Click(Sender: TObject);
begin
  if DirDlg.Execute then
  begin
    CurrentDir := IncludeTrailingBackSlash(DirDlg.Directory);
    Label1.Caption := 'Current Directory: ' + CurrentDir;
    LoadList;
  end;
end;

procedure TfrmFileList.LoadList;
var
  sr: TSearchRec;
begin
  List.Items.Clear;                                  
  if FindFirst(CurrentDir + '*.txt', faAnyFile, sr) = 0 then
    begin
      repeat
        List.Items.Add(ExtractFileName(sr.Name));
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
   List.ItemIndex := 0;
   ListClick(Self);
end;

procedure TfrmFileList.CopyText;
begin
  Try
    FList.Clear;
    FList.LoadFromFile(CurrentDir + List.Items[List.itemIndex]);
    frmStatus.Show;
    ClipBoard.SetTextBuf(FList.GetText);
    frmStatus.Hide;
    List.ItemIndex := List.ItemIndex + 1;
    if List.ItemIndex >= List.Items.Count then
      List.ItemIndex := List.Items.Count - 1;
  Except
  End;
end;

procedure TfrmFileList.listClick(Sender: TObject);
begin
  Label2.Caption := 'CurrentFile: ' + List.Items[List.ItemIndex];
end;

Initialization
//  frmFileList := TfrmFileList.Create(nil);
Finalization
//  frmFileList.Free;

end.
