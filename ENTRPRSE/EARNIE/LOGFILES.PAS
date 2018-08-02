unit LogFiles;

{ nfrewer440 16:25 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  {Ex_ListView,} ExtCtrls, Menus, StdCtrls, ImgList, Buttons;

type
  TFrmLogFiles = class(TForm)
    BtnClose: TBitBtn;
    ViewBtn: TBitBtn;
    Label1: TLabel;
    lbLogFile: TListBox;
    procedure FormShow(Sender: TObject);
    procedure lbLogFileClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Open1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure ViewBtnClick(Sender: TObject);
  private
    { Private declarations }
    fLogFilePath : String;
  public
    { Public declarations }
    constructor create(aOwner : TComponent;logFilePath : String);
    property LogFilePath : String read fLogFilePath write fLogFilePath;
  end;

var
  FrmLogFiles: TFrmLogFiles;

implementation

uses LogFileViewer;

{$R *.DFM}


constructor TFrmLogFiles.create(aOwner : TComponent;logFilepath : String);
begin
  inherited create(Aowner);
  Self.logFilePath := logFilePath;
end;

procedure TFrmLogFiles.FormShow(Sender: TObject);
var
  sr: TSearchRec;
{  RowNum : integer;}

begin
{  rowNum := 1;}
  lbLogFile.clear;
  if FindFirst(LogFilePath + '\*.log',faAnyFile,sr) = 0 then
  begin
    LbLogFile.Items.Add(sr.name);
    while FindNext(sr) = 0 do
    begin
{      inc(RowNum);}
      LbLogFile.Items.add(sr.name);
    end;
    FindClose(sr);
  end;
end;

procedure TFrmLogFiles.lbLogFileClick(Sender: TObject);
var
  SelectedlogFileName : String;
  List : TListBox;

begin
  try
  if (Sender is TListBox) then
  begin
    List := (Sender as TListBox);
    if list.itemindex <> -1 then
    begin
      SelectedlogFileName := List.Items[list.itemindex];
      frmLogFileViewer := TFrmLogFileViewer.create(self,LogFilePath + '\' + SelectedlogFileName);
      frmLogFileViewer.ShowModal;
    end
    else
      messageDlg('Please Select a log File first',mtinformation,[mbok],0);
  end;
  except
    messageDlg('Could Not display log File',mtinformation,[mbok],0);
  end;
end;

procedure TFrmLogFiles.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmLogFiles.Open1Click(Sender: TObject);
begin
 lbLogFileClick(lbLogFile);
end;

procedure TFrmLogFiles.Close1Click(Sender: TObject);
begin
  close;
end;

procedure TFrmLogFiles.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmLogFiles.ViewBtnClick(Sender: TObject);
begin
  lbLogFileClick(lbLogFile);
end;

end.
