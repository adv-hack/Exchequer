unit glLook;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uExDatasets, uComTKDataset, ExtCtrls, uMultiList, uDBMultiList,
  StdCtrls, TCustom, Enterprise01_TLB;

type
  TfrmGLLookup = class(TForm)
    GroupBox1: TGroupBox;
    btnOK: TSBSButton;
    SBSButton2: TSBSButton;
    mlGL: TMultiList;
    procedure SBSButton2Click(Sender: TObject);
    procedure mlGLRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    GL : string;
  end;

  function GetGLCode(const Code : longint;
                     const Toolkit : IToolkit) : string;
  Function FullNomKey(ncode  :  Longint)  :  ShortString;

var
  frmGLLookup: TfrmGLLookup;

implementation

{$R *.dfm}

Function FullNomKey(ncode  :  Longint)  :  ShortString;


Var
  TmpStr  :  ShortString;

Begin
  FillChar(TmpStr,Sizeof(TmpStr),0);

  Move(ncode,TmpStr[1],Sizeof(ncode));

  TmpStr[0]:=Chr(Sizeof(ncode));

  FullNomKey:=TmpStr;
end;


  function GetGLCode(const Code : longint;
                     const Toolkit : IToolkit) : string;
  var
    CodeOK : Boolean;
    CodeStr : string;
    Res : longint;
  begin
    CodeOK := Toolkit.GeneralLedger.GetEqual(Toolkit.GeneralLedger.BuildCodeIndex(Code)) = 0;

    if CodeOK and (Toolkit.GeneralLedger.glType <> glTypeHeading) then
      Result := IntToStr(Code)
    else
    with TfrmGLLookup.Create(nil) do
    Try
      CodeStr := IntToStr(Code);
      if Code = 0 then
        CodeStr := '';

      with Toolkit.GeneralLedger do
      begin
        Res := GetFirst;

        while Res = 0 do
        begin
          if (glType <> glTypeHeading) and (Copy(IntToStr(glCode), 1, Length(CodeStr)) = CodeStr) then
          begin
            mlGL.DesignColumns[0].Items.Add(IntToStr(glCode));
            mlGL.DesignColumns[1].Items.Add(glName);
          end;

          Res := GetNext;
        end;
      end;
      mlGL.Selected := 0;
      GL := '';
      if mlGL.ItemsCount = 1 then
        GL := mlGL.DesignColumns[0].Items[0]
      else
        ShowModal;
      if GL <> '' then
        Result := GL;
    Finally
      Free;
    End;

  end;


procedure TfrmGLLookup.SBSButton2Click(Sender: TObject);
begin
  GL := '';
end;

procedure TfrmGLLookup.mlGLRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  GL := mlGL.DesignColumns[0].Items[mlGL.Selected];
  Close;
end;

procedure TfrmGLLookup.btnOKClick(Sender: TObject);
begin
  GL := mlGL.DesignColumns[0].Items[mlGL.Selected];
end;

procedure TfrmGLLookup.FormActivate(Sender: TObject);
begin
  btnOK.Enabled := mlGL.ItemsCount > 0;
end;

end.
