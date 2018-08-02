unit CopyGl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles, MiscUtil, BTFile, BTConst, BTUtil;

type
  TCCDeptInfo = class
    Details : TCCDeptRec;
  end;

  TfrmCopyGLCode = class(TForm)
    cbSourceGL: TComboBox;
    cbDestinationGL: TComboBox;
    lbSourceGL: TLabel;
    lbDestinationGL: TLabel;
    lbPrompt: TLabel;
    btnCopy: TButton;
    btnClose: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure cbGLChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{var
  frmCopyGLCode: TfrmCopyGLCode; }

implementation

uses
  StrUtil;

{$R *.dfm}

procedure TfrmCopyGLCode.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmCopyGLCode.btnCopyClick(Sender: TObject);
var
  Combinations : TList;
  iPos, iSourceGL, iDestGL : integer;
  BTRec : TBTRec;
  CCDeptRec : TCCDeptRec;
  CCDeptInfo : TCCDeptInfo;
begin
  Combinations := TList.Create;
  iSourceGL := StrToIntDef(cbSourceGL.Text,0);

  // add valid combinations into list
  BTRec.KeyS := CD_VALID + BTFullNomKey(iSourceGL);
  BTRec.Status := BTFindRecord(BT_GetGreaterOrEqual, aFileVar[CCDeptF], CCDeptRec
  , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);

  while (BTRec.Status = 0) and (CCDeptRec.cdType = CD_VALID)
  and (CCDeptRec.cdGLCode = iSourceGL) do
  begin
    CCDeptInfo := TCCDeptInfo.Create;
    CCDeptInfo.Details := CCDeptRec;
    Combinations.Add(CCDeptInfo);

    // next record
    BTRec.Status := BTFindRecord(BT_GetNext, aFileVar[CCDeptF], CCDeptRec
    , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);
  end;{while}

  // add Invalid combinations into list
  BTRec.KeyS := CD_INVALID + BTFullNomKey(iSourceGL);
  BTRec.Status := BTFindRecord(BT_GetGreaterOrEqual, aFileVar[CCDeptF], CCDeptRec
  , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);

  while (BTRec.Status = 0) and (CCDeptRec.cdType = CD_INVALID)
  and (CCDeptRec.cdGLCode = iSourceGL) do
  begin
    CCDeptInfo := TCCDeptInfo.Create;
    CCDeptInfo.Details := CCDeptRec;
    Combinations.Add(CCDeptInfo);

    // next record
    BTRec.Status := BTFindRecord(BT_GetNext, aFileVar[CCDeptF], CCDeptRec
    , aBufferSize[CCDeptF], idxGetCombinations, BTRec.KeyS);
  end;{while}

  // Add new records for destination GL
  iDestGL := StrToIntDef(cbDestinationGL.Text,0);
  For iPos := 0 to Combinations.Count - 1 do
  begin
    CCDeptRec := TCCDeptInfo(Combinations[iPos]).Details;
    CCDeptRec.cdGLCode := iDestGL;

    BTRec.Status := BTAddRecord(aFileVar[CCDeptF], CCDeptRec, aBufferSize[CCDeptF], idxGetCombinations);
    if BTRec.Status = 0 then
    begin
      // added OK
    end else
    begin
      if BTRec.Status = 5 then
      begin
        // ignore duplicates
      end else
      begin
        BTShowError(BTRec.Status, 'BTAddRecord', aFileName[CCDeptF]);
      end;{if}
    end;{if}
  end;{for}

  ClearList(Combinations);
  Combinations.Free;

  Close;
end;


procedure TfrmCopyGLCode.cbGLChange(Sender: TObject);
begin
  btnCopy.Enabled := (cbDestinationGL.ItemIndex >= 0) and (cbSourceGL.ItemIndex >= 0)
  and (cbDestinationGL.ItemIndex <> cbSourceGL.ItemIndex);
end;

procedure TfrmCopyGLCode.FormShow(Sender: TObject);
begin
  cbGLChange(nil);
end;

end.
