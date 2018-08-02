unit MainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdxObj, StdCtrls, ExtCtrls, uMultiList, uDBMultiList,
  uExDatasets, uBtrieveDataset;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    Button1: TButton;
    Btd1: TBtrieveDataset;
    mlID: TDBMultiList;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Btd1GetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
  private
    { Private declarations }
    FAddIndex : TAddIndex;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  VarConst, BtrvU2;


{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  OpenDialog1.InitialDir := ExtractFileDir(Application.ExeName) + 'Trans';
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Res : Integer;
  tc : Cardinal;
begin
  if OpenDialog1.Execute then
  begin
    Label1.Caption := 'File: ' + OpenDialog1.Filename;
    FAddIndex := TAddIndex.Create;
    Try
      FAddIndex.Filename := OpenDialog1.Filename;
      FAddIndex.FileNumber := 3; //Details
      FAddIndex.IndexNumber := 9;

      //Segment 1 - SSD Commodity Code
      with FAddIndex.AddSegment do
      begin
        KeyPosition := BTKeyPos(@Id.SSDCommod[1], @Id);
        KeyLength := SizeOf(Id.SSDCommod) - 1;
        KeyFlags := DupModSeg+Mank;
      end;

      //Segment 2 - B2B Link No
      with FAddIndex.AddSegment do
      begin
        KeyPosition := BTKeyPos(@Id.B2BLink, @Id);
        KeyLength := SizeOf(Id.B2BLink);
        KeyFlags := DupMod+ExtType+Mank;
        ExtendedType := BInteger;
      end;

      tc := GetTickCount;

      Res := FAddIndex.Execute;

      if Res > 30000 then
        ShowMessage('Error opening file: ' + IntToStr(Res - 30000))
      else
      if Res <> 0 then
        ShowMessage('Error creating index: ' + IntToStr(Res))
      else
      begin
        btd1.Filename := OpenDialog1.Filename;
        mlId.Active := True;
        ShowMessage('Index created successfully: ' + IntToStr((GetTickCount - tc) div 1000) + ' seconds');
      end;

    Finally
      FAddIndex.Free;
    End;

  end;
end;

procedure TForm1.Btd1GetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
var
  pID : ^IDetail;
begin
  pID := PData;
  Case FieldName[1] of
    'S' : FieldValue := pID.SSDCommod;
    'B' : FieldValue := IntToStr(pID.B2BLink);
    'F' : FieldValue := IntToStr(pID.FolioRef);
  end;
end;

end.
