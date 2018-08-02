unit Options;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , SecCodes, Enterprise01_TLB, CustAbsU, Dialogs, StdCtrls, BTFile, BTConst
  , BTUtil, PPayProc, APIUtil, Progress, MiscUtil;

type

  TfrmOptions = class(TForm)
    btnHoldFlag: TButton;
    btnCreateSJI: TButton;
    procedure btnHoldFlagClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCreateSJIClick(Sender: TObject);
  private
//    procedure SetSecondHoldFlag(TX : ITransaction2; PPSetupRec : TPPSetupRec);
    function GetHoldFlag(bSet : boolean) : boolean;
  public
    LEventData : TAbsEnterpriseSystem;
  end;

var
  frmOptions: TfrmOptions;

implementation
uses
  StrUtil, ComObj;

{$R *.dfm}

procedure TfrmOptions.btnHoldFlagClick(Sender: TObject);
begin
  GetHoldFlag(TRUE);
end;

function TfrmOptions.GetHoldFlag(bSet : boolean) : boolean;
var
  PPSetupRec : TPPSetupRec;
  iStatus : integer;
  KeyS : TStr255;
  pUserField : pWideString;
  TX : ITransaction2;
begin
  OpenFiles;

  // Find Setup Record
  KeyS := BTFullNomKey(1) + IDX_DUMMY_CHAR;
  iStatus := BTFindRecord(BT_GetEqual, ppFileVar[ppSetupF], PPSetupRec, ppBufferSize[ppSetupF]
  , ppsFolioNoIdx, KeyS);
  case iStatus of
    0 : ;

    4, 9 : begin
      PPSetupRec.ppsDaysField := 1;
      PPSetupRec.ppsHoldFlagField := 2;
    end;

    else begin // Error
      BTShowError(iStatus, 'BTFindRecord', CompanyRec.Path + ppFileName[ppSetupF]);
    end;
  end;{case}

  StartToolkit(LEventData);

  try
    with oToolkit, Transaction do begin
      Index := thIdxOurRef;
      iStatus := GetEqual(BuildOurRefIndex(LEventData.Transaction.thOurRef));
      if (iStatus = 0) then begin
        Result := GetSecondHoldFlag(Transaction as ITransaction2, PPSetupRec) = SHF_HELD;
        if bSet then begin
          TX := (transaction as ITransaction2).UpdateEx(umDefault);
          with TX do begin
            SetSecondHoldFlag(TX, PPSetupRec);
            ReportTXSaveError(Save(FALSE));
          end;{with}
          TX := nil;
        end;{if}
      end;{if}
    end;{with}
  finally
    oToolkit.CloseToolkit;
    oToolkit := NIL;
  end;{try}

//  Showmessage(LEventData.Transaction.thOurRef);

  CloseFiles;
  Close;

end;


procedure TfrmOptions.FormShow(Sender: TObject);
begin
  if GetHoldFlag(FALSE) then btnHoldFlag.caption := 'Reset Late Payment Hold Flag'
  else btnHoldFlag.caption := 'Set Late Payment Hold Flag';
end;

procedure TfrmOptions.btnCreateSJIClick(Sender: TObject);
var
  frmProgress: TfrmProgress;
begin
  FrmProgress := TfrmProgress.Create(self);
  FrmProgress.LEventData := LEventData;
  FrmProgress.ShowModal;
  FrmProgress.Release;
  Close;
end;

end.
