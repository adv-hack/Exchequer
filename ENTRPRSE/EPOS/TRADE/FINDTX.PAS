unit FindTX;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IAeverButton, ExtCtrls;

type
  TFrmFindTX = class(TForm)
    Panel1: TPanel;
    Shape5: TShape;
    edSINNo: TEdit;
    btnSINNo: TIAeverButton;
    btnCustName: TIAeverButton;
    btnOrderNo: TIAeverButton;
    Panel2: TPanel;
    Shape2: TShape;
    edCustName: TEdit;
    Panel3: TPanel;
    Shape3: TShape;
    edOrderNo: TEdit;
    btnCancel: TIAeverButton;
    btnFind: TIAeverButton;
    Panel4: TPanel;
    Shape1: TShape;
    edAccCode: TEdit;
    btnAccountCode: TIAeverButton;
    btnSRINo: TIAeverButton;
    Panel5: TPanel;
    Shape4: TShape;
    edSRINo: TEdit;
    lSIN: TLabel;
    lSRI: TLabel;
    Panel6: TPanel;
    Shape6: TShape;
    Label3: TLabel;
    edSCRNo: TEdit;
    Panel7: TPanel;
    Shape7: TShape;
    Label4: TLabel;
    edSRFNo: TEdit;
    btnSRFNo: TIAeverButton;
    btnSCRNo: TIAeverButton;
    btnListNonTCM: TIAeverButton;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFindClick(Sender: TObject);
    procedure btnSINNoClick(Sender: TObject);
    procedure btnCustNameClick(Sender: TObject);
    procedure btnOrderNoClick(Sender: TObject);
    procedure btnAccountCodeClick(Sender: TObject);
    procedure edChange(Sender: TObject);
    procedure btnSRINoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSRFNoClick(Sender: TObject);
    procedure btnSCRNoClick(Sender: TObject);
    procedure btnListNonTCMClick(Sender: TObject);
  private
    sSINSOR : string;
    bEditChanging : boolean;
    procedure FindTransaction(iIndex : integer; sToFind : string; bTCM : boolean);
  public
    bFind : boolean;
  end;

var
  FrmFindTX: TFrmFindTX;

implementation
uses
  EPOSKey, TXList, StrUtil, BtrvU2, VarConst, GlobVar, BTSupU1, EPOSCnst, EPOSProc, GfxUtil,
  BackGrnd;

{$R *.DFM}

procedure TFrmFindTX.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TFrmFindTX.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LocalKey : Word;
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
  LocalKey := Key;
  Key := 0;

  {trap function Keys}
  If (LocalKey In [VK_F1..VK_F12]) and (Not (ssAlt In Shift)) then
    begin
      case LocalKey of
//        VK_F1 : Application.HelpCommand(HELP_Finder,0);
        VK_F2 : btnSINNoClick(nil);
        VK_F3 : btnSRINoClick(nil);
        VK_F4 : btnSRFNoClick(nil);
        VK_F5 : btnSCRNoClick(nil);
        VK_F6 : btnCustNameClick(nil);
        VK_F7 : btnOrderNoClick(nil);
        VK_F8 : btnAccountCodeClick(nil);
        VK_F11 : btnListNonTCMClick(nil);
        VK_F12 : btnFindClick(btnFind);
        else Key := LocalKey;
      end;{case}
    end
  else Key := LocalKey;
end;

procedure TFrmFindTX.btnFindClick(Sender: TObject);
var
  sToFind : string;
  iIndex, iCont, iPanCont : integer;
begin
  if btnFind.Enabled then begin

    sToFind := '';
    iIndex := 2;

    {Find the edit box with the text in}
    sToFind := '';
    for iCont := 0 to ControlCount - 1 do begin
      if Controls[iCont] is TPanel then begin
        for iPanCont := 0 to TPanel(Controls[iCont]).ControlCount - 1 do begin
          if (TPanel(Controls[iCont]).Controls[iPanCont] is TEdit)
          and (TEdit(TPanel(Controls[iCont]).Controls[iPanCont]).Text <> '')
          then begin
            with TEdit(TPanel(Controls[iCont]).Controls[iPanCont]) do begin
              {The edit control with the text in, has been found}

{              if Name = 'edAnyField' then sToFind := '**' + sToFind;}

              sToFind := Text;
              iIndex := Tag;

              {Find by SIN / SOR}
              if Name = 'edSINNo' then begin
                if (UpperCase(Copy(sToFind,1,3)) = sSINSOR) then sToFind := Copy(sToFind,4,6);
                sToFind := sSINSOR + PadString(psLeft,sToFind,'0',6);
              end;{if}

              {Find by SRI}
              if Name = 'edSRINo' then begin
                if (Copy(sToFind,1,3) = 'SRI') then sToFind := Copy(sToFind,4,6);
                sToFind := 'SRI' + PadString(psLeft,sToFind,'0',6);
              end;{if}

              {Find by SRF}
              if Name = 'edSRFNo' then begin
                if (Copy(sToFind,1,3) = 'SRF') then sToFind := Copy(sToFind,4,6);
                sToFind := 'SRF' + PadString(psLeft,sToFind,'0',6);
              end;{if}

              {Find by SCR}
              if Name = 'edSCRNo' then begin
                if (Copy(sToFind,1,3) = 'SCR') then sToFind := Copy(sToFind,4,6);
                sToFind := 'SCR' + PadString(psLeft,sToFind,'0',6);
              end;{if}

              SelectAll;
            end;{with}
          end;{if}
        end;{for}
      end;{if}
    end;{for}
    FindTransaction(iIndex, UpperCase(sToFind), TWinControl(Sender).Tag = 1);
  end;{if}
end;

procedure TFrmFindTX.btnSINNoClick(Sender: TObject);
begin
  ActiveControl := edSINNo;
end;

procedure TFrmFindTX.btnCustNameClick(Sender: TObject);
begin
  ActiveControl := edCustName;
end;

procedure TFrmFindTX.btnOrderNoClick(Sender: TObject);
begin
  ActiveControl := edOrderNo;
end;

procedure TFrmFindTX.btnAccountCodeClick(Sender: TObject);
begin
  ActiveControl := edAccCode;
end;

procedure TFrmFindTX.edChange(Sender: TObject);
var
  iCont, iPanCont : integer;
begin
  {Blanks all edit controls, other than the one you have just typed in}
  if not bEditChanging then begin
    bEditChanging := TRUE;
    for iCont := 0 to ControlCount - 1 do begin
      if Controls[iCont] is TPanel then begin
        for iPanCont := 0 to TPanel(Controls[iCont]).ControlCount - 1 do begin

          {blank any other edit cells}
          if (TPanel(Controls[iCont]).Controls[iPanCont] is TEdit)
          and (TEdit(TPanel(Controls[iCont]).Controls[iPanCont]).name <> TEdit(Sender).name)
          then TEdit(TPanel(Controls[iCont]).Controls[iPanCont]).Text := '';

        end;{for}
      end;{if}
    end;{for}
    bEditChanging := FALSE;
  end;{if}
end;

procedure TFrmFindTX.btnSRINoClick(Sender: TObject);
begin
  ActiveControl := edSRINo;
end;

procedure TFrmFindTX.FindTransaction(iIndex : integer; sToFind : string; bTCM : boolean);
var
  iNoOfChar, iStatus : smallint;
  sFindMe : Str255;

  function GetCheckValue : str255;
  begin
    case iIndex of
      1 : Result := Copy(Inv.CustCode,1,iNoOfChar);
      2 : Result := Copy(Inv.OurRef,1,iNoOfChar);
      6 : Result := Copy(Inv.YourRef,1,iNoOfChar);
      8 : Result := Copy(Inv.TransDesc,1,iNoOfChar);
    end;{case}
    Result := UpperCase(Result);
  end;{GetCheckValue}

  function GetNextMatchingRecord : smallint;
  begin
    Repeat
      {next record}
      Result := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, iIndex, sFindMe);
//    if Result <> 9 then Report_BError(InvF,Result);
    until ((Copy(Inv.DocUser4,1,4) = 'EPOS') and (sToFind = GetCheckValue)) or (Result <> 0) or (sToFind <> GetCheckValue)
  end;{GetNextMatchingRecord}

begin{FindTransaction}
  Screen.Cursor := crHourglass;
  Open_File(F[InvF], sCurrCompPath + FileNames[InvF], 0);

  iStatus := 0;
  sFindMe := '';

  if (sToFind <> '') then begin
    sFindMe := sToFind;
    iNoOfChar := length(sFindMe);

    {Find 1st matching record}
    iStatus := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, iIndex, sFindMe);
    if (iStatus = 0) and (Copy(Inv.DocUser4,1,4) <> 'EPOS') and bTCM
    then iStatus := GetNextMatchingRecord;

    if (iStatus = 0) and (sToFind = GetCheckValue) then
      {an EPOS record with the specified search value was found}
      begin
        {get next match to see if we need to show the list}
        iStatus := GetNextMatchingRecord;
      end
    else begin
      {not found}
      if not (iStatus in [4,9]) then Report_BError(InvF,iStatus);
      MyMsgBox('The Transaction that you are looking for could not be found.',mtInformation
      ,[mbOK],mbOK,'Find Transaction');
      Exit;
    end;{if}
  end;{if}

  if ((iStatus = 9) or ((iStatus = 0) and (sToFind <> GetCheckValue))) and (sFindMe <> '') then
    begin
      {found one matching record}
      sFindMe := sToFind;

      {Get first (and only) matching record}
      iStatus := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, iIndex, sFindMe);
      Report_BError(InvF,iStatus);

      if (Copy(Inv.DocUser4,1,4) <> 'EPOS') and bTCM
      then iStatus := GetNextMatchingRecord;
      Report_BError(InvF,iStatus);

      ModalResult := mrOK;
    end
  else begin
    {found > 1 matching records, so show list}
    with TFrmTXList.Create(Self) do begin
      try
        iIndexNo := iIndex;
        sKey := sToFind;
        TTXList(FormStuff.aMULCtrlO[0]).bTCM := bTCM;
        if (showmodal = mrOK) then Self.ModalResult := mrOK
      finally
        release;
      end;{try}
    end;{with}
  end;{if}
  Close_File(F[InvF]);
end;


procedure TFrmFindTX.FormCreate(Sender: TObject);
begin
  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);

  case SetupRecord.TransactionType of
    TX_SINs : sSINSOR := 'SIN';
    TX_PICKED_SORs, TX_UNPICKED_SORs : sSINSOR := 'SOR';
  end;{case}

  btnSINNo.Caption := 'by ' + sSINSOR + ' Number';
  if ActiveControl <> btnSINNo then SendMessage(btnSINNo.Handle,CM_MOUSEENTER,0,0); {redraw button}
  lSIN.Caption := sSINSOR;

  btnSRINo.Enabled := SetupRecord.TransactionType = TX_SINs;
  edSRINo.Enabled := SetupRecord.TransactionType = TX_SINs;

  btnSRFNo.Enabled := SetupRecord.NegativeTXType = 1;
  edSRFNo.Enabled := SetupRecord.NegativeTXType = 1;

  btnSCRNo.Enabled := SetupRecord.NegativeTXType = 1;
  edSCRNo.Enabled := SetupRecord.NegativeTXType = 1;

end;

procedure TFrmFindTX.btnSRFNoClick(Sender: TObject);
begin
  ActiveControl := edSRFNo;
end;

procedure TFrmFindTX.btnSCRNoClick(Sender: TObject);
begin
  ActiveControl := edSCRNo;
end;

procedure TFrmFindTX.btnListNonTCMClick(Sender: TObject);
var
  sToFind : string;
  iIndex, iCont, iPanCont : integer;
begin
  if btnListNonTCM.Enabled then begin
    Screen.Cursor := crHourglass;
    Open_File(F[InvF], sCurrCompPath + FileNames[InvF], 0);
    with TFrmTXList.Create(Self) do begin
      try
        iIndexNo := 2;
        sKey := '';
        TTXList(FormStuff.aMULCtrlO[0]).bTCM := FALSE;
        if (showmodal = mrOK) then begin
          Self.ModalResult := mrYes;
        end;{if}
      finally
        release;
      end;{try}
    end;{with}
    Close_File(F[InvF]);
  end;{if}
end;

end.
