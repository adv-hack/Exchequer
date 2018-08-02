unit ViewerF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MemoryMap, StdCtrls, BlowFish;

type
  TfrmOLEServerMapViewer = class(TForm)
    memData: TMemo;
    btnRefresh: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOLEServerMapViewer: TfrmOLEServerMapViewer;

implementation

{$R *.dfm}

//=========================================================================

procedure TfrmOLEServerMapViewer.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
  GlobalOLEMemoryMap := TOLEServerMemoryMap.Create(False);
  btnRefreshClick(Self);
end;

//-------------------------------------------------------------------------

procedure TfrmOLEServerMapViewer.btnRefreshClick(Sender: TObject);
Var
  I : Integer;
begin
  memData.Clear;
  If GlobalOLEMemoryMap.Defined Then
  Begin
    memData.Lines.Add ('Version: ' + IntToStr(GlobalOLEMemoryMap.Version));
    memData.Lines.Add ('Company Details Count: ' + IntToStr(GlobalOLEMemoryMap.CompanyCount));
    For I := 1 To GlobalOLEMemoryMap.CompanyCount Do
    Begin
      With GlobalOLEMemoryMap.Companies[I] Do
      Begin
        memData.Lines.Add ('CompanyDetails[' + IntToStr(I) + ']:');
        memData.Lines.Add ('    Company:  ' + cdCompanyCode);
        memData.Lines.Add ('    User ID:  ' + cdUserID);
        //memData.Lines.Add ('    Password: ' + cdPassword);
      End; // With GlobalOLEMemoryMap.Companies[I]
    End; // For I
  End // If GlobalOLEMemoryMap.Defined
  Else
    memData.Lines.Add ('Memory Map Not Defined');
end;

//=========================================================================

end.
