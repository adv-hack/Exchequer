unit selectlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uMultiList, StdCtrls, ComCtrls, TCustom;

type
  TfrmSelectLog = class(TForm)
    Label1: TLabel;
    lvLogs: TListView;
    SBSButton1: TSBSButton;
    btnView: TSBSButton;
    SBSButton3: TSBSButton;
    procedure btnViewClick(Sender: TObject);
    procedure lvLogsDblClick(Sender: TObject);
    procedure SBSButton3Click(Sender: TObject);
  private
    { Private declarations }
    
    procedure LoadItem(const s : string);
  public
    { Public declarations }
    procedure LoadList;
  end;

var
  frmSelectLog: TfrmSelectLog;

implementation

{$R *.dfm}
uses
  JcIni, JcVar, LogView;

procedure TfrmSelectLog.LoadList;
var
  R : TSearchRec;
  Res : Integer;
  Path, Mask : string;
begin
  Path := TheIni.LogDir;
  Mask := 'Exp*.log';
  Res := FindFirst(Path + Mask, faAnyFile, R);

  while Res = 0 do
  begin
    LoadItem(Path + R.Name);

    Res := FindNext(R);
  end;

end;

procedure TfrmSelectLog.LoadItem(const s : string);
var
  F : TextFile;
  s1 : string;
  i : integer;
begin

  AssignFile(F, s);
  Reset(F);
  Try
    ReadLn(F, s1);
    if (Pos(ExportString, s1) > 0) or (Pos(ImportString, s1) > 0) then
    begin
      ReadLn(F, s1);
      ReadLn(F, s1);
      ReadLn(F, s1);
      Delete(s1, 1, 20);
      i := Pos('/', s1);
      if i > 0 then
      begin
        with lvLogs.Items.Add do
        begin
          Caption := Copy(s1, 1, i - 1); //Company code
          if i > 0 then
            SubItems.Add(Copy(s1, i + 1, Length(s1))) //Payroll ID
          else
            SubItems.Add('Import Employees');

          ReadLn(F, s1);
          ReadLn(F, s1);
          SubItems.Add(s1); //Date/Time
          SubItems.Add(s); //Filename;
        end;
      end;
    end;
  Finally
    CloseFile(F);
  End;
end;

procedure TfrmSelectLog.btnViewClick(Sender: TObject);
begin
  if Assigned(lvLogs.Selected) then
    ShowLog(lvLogs.Selected.SubItems[2]);
end;

procedure TfrmSelectLog.lvLogsDblClick(Sender: TObject);
begin
  btnView.Click;
end;

procedure TfrmSelectLog.SBSButton3Click(Sender: TObject);
var
  s : string;
begin
  if MessageDlg('Are you sure you wish to delete this log file?',
               mtConfirmation, mbYesNoCancel, 0) = mrYes then
  begin
    if Assigned(lvLogs.Selected) then
      DeleteFile(lvLogs.Selected.SubItems[2]);
    lvLogs.Items.Clear;
    LoadList;
  end;
end;

end.
