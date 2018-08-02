unit ClntUser;

{ nfrewer440 10:19 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Inifiles;

type
  TfrmClientLoginList = class(TForm)
    lvUsers: TListView;
    btnClose: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmClientLoginList: TfrmClientLoginList;

implementation

{$R *.DFM}

procedure TfrmClientLoginList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmClientLoginList.FormCreate(Sender: TObject);
var
  slUsers : TStringList;
  sIniFileName : string;
  iPos2, iPos : integer;
  NewItem: TListItem;
begin
  slUsers := TStringList.Create;
  sIniFileName := ExtractFilePath(application.ExeName) + 'CLNTUSER.INI';
  with TIniFile.Create(sIniFileName) do begin
    try
      UpdateFile;
      ReadSectionValues('Logged In', slUsers);
      slUsers.Sorted := TRUE;
      for iPos := 0 to slUsers.Count - 1 do begin
        iPos2 := Pos('=',slUsers[iPos]);
        NewItem := lvUsers.Items.Add;
        with NewItem do begin
          Caption := Copy(slUsers[iPos],1,iPos2 -1);
          SubItems.Add(Copy(slUsers[iPos],iPos2 + 1,255));
        end;{with}
      end;{for}
    finally
      Free;
    end;{try}
  end;{with}
  if lvUsers.Items.Count > 0 then lvUsers.Selected := lvUsers.Items[0];
end;

end.
