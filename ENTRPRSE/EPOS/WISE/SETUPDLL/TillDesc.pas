unit TillDesc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, CompUtil, {NeilProc,}
  setupbas, StdCtrls, ExtCtrls, SetupU, Mask, TEditVal, BrwseDir, FileCtrl, IniFiles, APIUtil,
  Spin, TillName;

type
  TfrmGetTillDesc = class(TSetupTemplate)
    lDir: TLabel;
    edTillDesc: TEdit;
    lTillNo: TLabel;
    procedure NextBtnClick(Sender: TObject);
  private
    iNextTillNo : integer;
    oTillInfo : TTillInfo;
    { Private declarations }
  public
    sCDDir : string;
    { Public declarations }
  end;


  function GetTillDesc(var DLLParams: ParamRec): LongBool; StdCall; export;
  function AddTillName(var DLLParams: ParamRec): LongBool; StdCall; export;

implementation
uses
  ShellAPI, StrUtil, EPOSCnst;

{$R *.DFM}


function GetTillDesc(var DLLParams: ParamRec): LongBool;
{ Asks for the Till Description }
var
  sTillDesc, sEnterDir, DlgPN, HlpPath : String;
  frmGetTillDesc : TfrmGetTillDesc;

begin{AskInstallUpdate}
  Application.HelpFile := HlpPath + 'TRADE.HLP';
  frmGetTillDesc := TfrmGetTillDesc.Create(Application);
  With frmGetTillDesc Do
  Begin
    Try
      GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);
      GetVariable(DLLParams,'ENTERDIR',sEnterDir);
//      sEnterDir := Copy(sEnterDir,1,Pos('\TRADE\..\',sEnterDir));

      GetVariable(DLLParams,'TILLDESC',sTillDesc);
      edTillDesc.Text := sTillDesc;

      sCentralTradePath := sEnterDir + 'TRADE\';

// Showmessage('sCentralTradePath : ' + sCentralTradePath);

      oTillInfo := TTillInfo.Load(FALSE);
      iNextTillNo := oTillInfo.GetNextTillNo;

      lTillNo.Caption := 'The till you are about to install, will be till number '
      + IntToStr(iNextTillNo) + '.';

      { Display dialog }
      ShowModal;

      Case ExitCode Of
        { Back }
        'B' : SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3)); { New Method - 3 character Id for each Dialog }

        { Next }
        'N' : begin
          SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));{ New Method - 3 character Id for each Dialog }
          SetVariable(DLLParams,'TILLNO',PadString(psLeft,IntToStr(iNextTillNo),'0',2));
          SetVariable(DLLParams,'TILLDESC',edTillDesc.Text);
          SetVariable(DLLParams,'ENTERDIR',sEnterDir);

{          oTillInfo.Add(edTillDesc.Text)}
        end;

        { Exit Installation }
        'X' : SetVariable(DLLParams,'DIALOG','999'){ New Method - 3 character Id for each Dialog }
      End;{case}
      oTillInfo.UnLoad;
    Finally
      Release;
    End;{try}
  End;{With}
  Result := False;
end;{AskInstallUpdate}

function AddTillName(var DLLParams: ParamRec): LongBool;
{ Asks for the Till Description }
var
  sTillNo, sEnterDir, sTillDesc, HlpPath : String;
begin{AskInstallUpdate}
  Application.HelpFile := HlpPath + 'TRADE.HLP';
  With TfrmGetTillDesc.Create(Application) Do Begin
    Try
      GetVariable(DLLParams,'TILLDESC',sTillDesc);
      GetVariable(DLLParams,'ENTERDIR',sEnterDir);
      GetVariable(DLLParams,'TILLNO',sTillNo);

      sCentralTradePath := sEnterDir + 'TRADE\';

      oTillInfo := TTillInfo.Load(TRUE);
      oTillInfo.Add(StrToIntDef(sTillNo, 0), sTillDesc,'');
      oTillInfo.UnLoad;
    Finally
      Release;
    End;{try}
  End;{With}
  Result := False;
end;{AskInstallUpdate}

{---------------------------------------------------------------------------}

procedure TfrmGetTillDesc.NextBtnClick(Sender: TObject);
var
  iPos : integer;
  bError : boolean;
begin

  bError := FALSE;
  For iPos := 0 to oTillInfo.Names.Count - 1 do begin
    if oTillInfo.Names[iPos] = edTillDesc.Text then begin
      MsgBox('You have entered a till name that has already been used.' + #13#13
      + 'Please choose a different name for this till.',mtInformation,[mbOK],mbOK,'Duplicate Name');
      bError := TRUE;
    end;{if}
  end;{for}

  if NextBtn.enabled and (not bError) then inherited;
end;

end.

