unit nntplst;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, msNNTP, msSocket;

type
  TNGListDlg = class(TForm)
    SelectButton: TButton;
    CloseButton: TButton;
    Bevel1: TBevel;
    ListBox1: TListBox;
    RetrieveButton: TButton;
    LoadButton: TButton;
    SaveButton: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    CancelButton: TButton;
    procedure RetrieveButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
    procedure LinesRcvProgress(Sender: TObject; Perc, ByteCount, LineCount: LongInt);
    procedure NewsgroupListToListBox;
  public
    { Public declarations }
    NNTPClient: TmsNNTPClient;
  end;

var
  NGListDlg: TNGListDlg;

implementation

{$R *.DFM}

uses msDef;

procedure TNGListDlg.LinesRcvProgress(Sender: TObject; Perc, ByteCount, LineCount: LongInt);
begin
  Label1.Caption:=IntToStr(LineCount)+' retrieved';
end;

procedure TNGListDlg.RetrieveButtonClick(Sender: TObject);
var
  SaveProgressHandler: TmsProgressEvent;
begin
  CancelButton.Enabled:=true;
  LoadButton.Enabled:=false;
  SaveButton.Enabled:=false;
  SelectButton.Enabled:=false;
  CloseButton.Enabled:=false;
  SaveProgressHandler:=NNTPClient.OnTransferProgress;
  NNTPClient.OnTransferProgress:=LinesRcvProgress;
  try
    NNTPClient.Login;
    try
      NNTPClient.RetrieveNewsgroupList;
      NNTPClient.Logout;
    except
      on EmsServerError do
      begin
        NNTPClient.Logout;
        raise;
      end
      else
        raise;
    end;
    NewsgroupListToListBox;
  finally
    NNTPClient.OnTransferProgress:=SaveProgressHandler;
    Label1.Caption:='';
    CancelButton.Enabled:=false;
    LoadButton.Enabled:=true;
    SaveButton.Enabled:=true;
    SelectButton.Enabled:=true;
    CloseButton.Enabled:=true;
  end;
end;

procedure TNGListDlg.FormCreate(Sender: TObject);
begin
  Label1.Caption:='';
end;

procedure TNGListDlg.NewsgroupListToListBox;
var
  i: Integer;
begin
  for i:=0 to NNTPClient.NewsgroupList.Count-1 do
    ListBox1.Items.Add(NNTPClient.NewsgroupList[i].Name);
  if ListBox1.Items.Count>0 then
  begin
    ListBox1.ItemIndex:=0;
    SelectButton.Enabled:=true;
  end;
end;

procedure TNGListDlg.LoadButtonClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    NNTPClient.LoadNewsgroupList(OpenDialog1.FileName);
    NewsgrouplistToListBox;
  end;
end;

procedure TNGListDlg.SaveButtonClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    NNTPClient.SaveNewsgroupList(SaveDialog1.FileName);
end;

procedure TNGListDlg.CancelButtonClick(Sender: TObject);
begin
  NNTPClient.Cancel;
end;

procedure TNGListDlg.ListBox1DblClick(Sender: TObject);
begin
  if ListBox1.ItemIndex>-1 then
    ModalResult:=mrOk;
end;

end.
