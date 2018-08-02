unit TXRep;

{ nfrewer440 16:26 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, CheckLst, RPFiler, RPDefine, RPBase,
  RPCanvas, RPFPrint, PrntDlg, Scrtch1u, PSProc;

{$I EXCHDLL.INC}

const
  iProcessID = 1; {Unique Process ID for this report}

type
  ENoUnique = class(Exception);

  TTenderTotals = record
    Cash : Real;
    Card : Real;
    Cheque : Real;
    WrittenOff : Real;
    LeftOnAccount : Real;
    SettlementDiscount : Real;
    Total : Real;
  end;

  TfrmTXReport = class(TForm)
    edStartDate: TDateTimePicker;
    Label1: TLabel;
    edEndDate: TDateTimePicker;
    Label2: TLabel;
    Bevel2: TBevel;
    Label5: TLabel;
    Bevel4: TBevel;
    lstTills: TCheckListBox;
    btnOK: TButton;
    btnCancel: TButton;
    btnAll: TButton;
    Label3: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Bevel1: TBevel;
    Label4: TLabel;
    cbIncludeAccType: TCheckBox;
    Bevel3: TBevel;
    edIncludeAccType: TEdit;
    cbExcludeAccType: TCheckBox;
    edExcludeAccType: TEdit;
    Label6: TLabel;
    cbSCR: TCheckBox;
    cmbSCRForm: TComboBox;
    edSCRForm: TEdit;
    btnSCRBrowse: TButton;
    cbSIN: TCheckBox;
    cmbSINForm: TComboBox;
    edSINForm: TEdit;
    btnSINBrowse: TButton;
    cbSOR: TCheckBox;
    cmbSORForm: TComboBox;
    edSORForm: TEdit;
    btnSORBrowse: TButton;
    cbSRF: TCheckBox;
    cmbSRFForm: TComboBox;
    edSRFForm: TEdit;
    btnSRFBrowse: TButton;
    cbSRI: TCheckBox;
    cmbSRIForm: TComboBox;
    edSRIForm: TEdit;
    btnSRIBrowse: TButton;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnAllClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstTillsClickCheck(Sender: TObject);
    procedure AccCheckClick(Sender: TObject);
    procedure TypeCheckClick(Sender: TObject);
    procedure cmbFormChange(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
  private
    procedure EnableDisableFormSelect(iComp : integer);
    function PrintTransaction(sRefNo : string; iFolioNum : integer) : integer;
  public
    { Public declarations }
  end;

{var
  frmEODReport: TfrmEODReport;}

implementation
uses
  GlobVar, BtrvU2, VarConst, BtKeys1U, BTSupU1, StrUtil, TillName, RPDevice, EPOSComn
  , DLLInt, RepUtil, EPOSCnst, {NeilProc,} MiscU, ComnU2, MathUtil, UseDLLU, CurrncyU, APIUtil;

{$R *.DFM}

procedure TfrmTXReport.FormCreate(Sender: TObject);
var
  oTillInfo : TTillInfo;
  iPos : integer;
begin
  edStartDate.Date := SysUtils.Date;
  edEndDate.Date := SysUtils.Date;

  {load Tills List}
  oTillInfo := TTillInfo.Load(FALSE);
  lstTills.Items := oTillInfo.Names;
  For iPos := 0 to lstTills.Items.Count - 1 do lstTills.items[iPos] := IntToStr(iPos + 1) + ' - ' + lstTills.items[iPos];
  oTillInfo.Unload;

  btnAllClick(btnAll);
//  btnAllClick(btnTypeAll);
  OpenDLL(sGlobalCompanyPath);
end;

procedure TfrmTXReport.btnOKClick(Sender: TObject);
var
  iLineStatus, iTHIndex, iTLIndex, iStatus : smallint;
  sKey : Str255;
  iPos, FVar, iTillNo, iRecAddress : LongInt;
  TillsToReportOn : set of 1..99;
  RepFName, BaseDir : string;
  PrnInfo : TSBSPrintSetupInfo;
  rTotalOS : real;
  sAdditionalInfo : string[100];
  bFirstLine : boolean;
begin

  Screen.Cursor := crHourglass;

  {builds a [Set] of tills to report on}
  TillsToReportOn := [];
  For iPos := 0 to lstTills.Items.Count - 1 do begin
    if lstTills.Checked[iPos] then TillsToReportOn := TillsToReportOn + [iPos + 1];
  end;{for}

  iTHIndex := InvDateK; {trans date order}
  iTLIndex := IdFolioK; {folio number order}
  sKey := DateTimeAsLongDate(edStartDate.Date);

  iStatus := Find_Rec(B_GetGEq, F[InvF], InvF,RecPtr[InvF]^, iTHIndex, sKey);
  While (iStatus = 0) and (ToDateTime(Inv.TransDate) <= Trunc(edEndDate.Date)) do begin

    // TCM Transaction ?
    if copy(Inv.DocUser4,1,4) = 'EPOS' then begin
      iTillNo := StrToIntDef(copy(Inv.DocUser4, 5, 2), 0);

      // Are we reporting on this Till  ?
      if iTillNo in TillsToReportOn then begin
//        if Inv.TransTime = 0
        PrintTransaction(Inv.OurRef, Inv.FolioNum);
      end;{if}
    end;{if}
    iStatus := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, iTHIndex, sKey);
  end;{while}

  Screen.Cursor := crDefault;
end;

function TfrmTXReport.PrintTransaction(sRefNo : string; iFolioNum : integer) : integer;
var
{  iParam : smallint;
  PrBatch : PrintBatchRecType;
  PrnInfo  : TSBSPrintSetupInfo;
  sPrinter : string;}
  bReceipt : boolean;
begin
(*  if PrintBatch_ClearBatch then
    begin

      FillChar (PrBatch, SizeOf (PrBatch), #0);
      With PrBatch Do Begin
        { ** This section needs to be built by users }
        pbDefMode   := 1;          { Invoice }
        if bReceipt then pbEFDName := SetupRecord.ReceiptFormName
        else begin
          case SetupRecord.TransactionType of
            0 : pbEFDName := SetupRecord.InvoiceFormName;  { Invoice Form Name }
            1,2 : pbEFDName := SetupRecord.OrderFormName;  { Invoice Form Name }
          end;{case}
        end;{if}

        pbMainFNum  := InvF;       { Document file InvF }
        pbMainKPath := InvOurRefK; { Our Ref Key }
        pbMainKRef  := sRefNo;     { Reference No SIN****** }
        pbTablFNum  := IDetailF;   { Details File IDetailF }
        pbTablKPath := IdFolioK;   { Details Folio Key }
        pbTablKRef  := '****';
        Move (iFolioNum, pbTablKRef[1], 4); { Folio Number }
        pbLbCopies  := 1;
      End; { With }

      if PrintBatch_AddJob(PrBatch) then
        begin
          if bReceipt then sPrinter := SetupRecord.ReceiptPrinter
          else begin
            case SetupRecord.TransactionType of
              0 : sPrinter := SetupRecord.InvoicePrinter;
              1,2 : sPrinter := SetupRecord.OrderPrinter;
            end;{case}
          end;{if}

          if RPDev.SelectPrinter(sPrinter, FALSE) then
            begin
              if bReceipt then
                begin
                  RPDev.SelectPaper(RPDev.WalkList(RpDev.Papers, SetupRecord.RecPrintPaper), FALSE);
                  if SetupRecord.RecPrintBin >= 0 then RPDev.SelectBin(RPDev.WalkList(RpDev.Bins, SetupRecord.RecPrintBin), FALSE);
                end
              else begin
                case SetupRecord.TransactionType of
                  0 : begin
                    RPDev.SelectPaper(RPDev.WalkList(RpDev.Papers, SetupRecord.InvPrintPaper), FALSE);
                    if SetupRecord.InvPrintBin >= 0 then RPDev.SelectBin(RPDev.WalkList(RpDev.Bins, SetupRecord.InvPrintBin), FALSE);
                  end;

                  1,2 : begin
                    RPDev.SelectPaper(RPDev.WalkList(RpDev.Papers, SetupRecord.OrderPrintPaper), FALSE);
                    if SetupRecord.OrderPrintBin >= 0 then RPDev.SelectBin(RPDev.WalkList(RpDev.Bins, SetupRecord.OrderPrintBin), FALSE);
                  end;
                end;{case}

              end;{if}

              PrnInfo := RPDev.SBSSetupInfo;

              PrnInfo.Preview := FALSE;
              For iParam := 1 to ParamCount do begin
                if UpperCase(Paramstr(iParam)) = '/PREVIEW:' then PrnInfo.Preview := TRUE;
              end;{for}

              PrnInfo.NoCopies := 1;
              if not PrintBatch_Print('Receipt Print Preview', PrnInfo)
              then MsgBox('PrintBatch_Print Failed.',mtError,[mbOK], mbOK, 'Printing Error');
            end
          else MsgBox('SelectPrinter Failed.',mtError,[mbOK], mbOK, 'Printing Error');
        end
      else MsgBox('PrintBatch_AddJob Failed.',mtError,[mbOK], mbOK, 'Printing Error');
    end
  else MsgBox('PrintBatch_ClearBatch Failed.',mtError,[mbOK], mbOK, 'Printing Error');*)
end;


procedure TfrmTXReport.Button1Click(Sender: TObject);
var
  oTillInfo : TTillInfo;
begin
  oTillInfo := TTillInfo.Load(FALSE);
//  oTillInfo.Add('Bar Till');
//  oTillInfo.Add('Restaurant Till');
  oTillInfo.Unload;
end;

procedure TfrmTXReport.btnAllClick(Sender: TObject);
var
  bNewState : boolean;
  iPos : integer;
begin
  bNewState := TButton(Sender).Caption = 'Select All';

  if TButton(Sender).name = 'btnAll' then
    begin
      For iPos := 0 to lstTills.Items.Count - 1 do lstTills.Checked[iPos] := bNewState;
    end
  else begin
//    For iPos := 0 to lstTypes.Items.Count - 1 do lstTypes.Checked[iPos] := bNewState;
  end;{if}

  if bNewState then TButton(Sender).Caption := 'Deselect All'
  else TButton(Sender).Caption := 'Select All';

  lstTillsClickCheck(nil);
end;

procedure TfrmTXReport.FormDestroy(Sender: TObject);
begin
  Ex_CloseData;
end;

procedure TfrmTXReport.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  If (Key = VK_F1) and (Not (ssAlt In Shift)) then Application.HelpCommand(HELP_Finder,0);
end;

procedure TfrmTXReport.lstTillsClickCheck(Sender: TObject);
var
  iComp, iPos : integer;
  bSomethingIsSelected : boolean;
begin
  bSomethingIsSelected := FALSE;
  For iPos := 0 to lstTills.Items.Count - 1 do begin
    if lstTills.Checked[iPos] then bSomethingIsSelected := TRUE;
  end;{for}

  if bSomethingIsSelected then begin
    bSomethingIsSelected := FALSE;

    For iComp := 0 to (ComponentCount - 1) do begin
      if (Components[iComp] is TCheckBox) and (TCheckBox(Components[iComp]).Tag in [1..5])
      and TCheckBox(Components[iComp]).Checked then bSomethingIsSelected := TRUE;
    end;{for}

  end;{if}

  btnOK.enabled := bSomethingIsSelected;
end;

procedure TfrmTXReport.AccCheckClick(Sender: TObject);
begin
  // only allow one checkbox to be selected
  if cbIncludeAccType.checked and cbExcludeAccType.checked then begin
    case TCheckBox(Sender).Tag of
      1 : cbExcludeAccType.checked := FALSE;
      2 : cbIncludeAccType.checked := FALSE;
    end;{case}
  end;{if}

  // enable / disable edit boxes
  edExcludeAccType.Enabled := cbExcludeAccType.checked;
  edIncludeAccType.Enabled := cbIncludeAccType.checked;

end;

procedure TfrmTXReport.TypeCheckClick(Sender: TObject);
var
  iComp, iTag : integer;
  bEnabled : boolean;
begin
  iTag := TCheckBox(Sender).Tag;
  bEnabled := TCheckBox(Sender).Checked;

  For iComp := 0 to (ComponentCount - 1) do begin
    if (Components[iComp] is TComboBox) and (TComboBox(Components[iComp]).Tag = iTag)
    then TComboBox(Components[iComp]).Enabled := bEnabled;

    if (Components[iComp] is TEdit) or (Components[iComp] is TButton)
    and (TComboBox(Components[iComp]).Tag = iTag) then EnableDisableFormSelect(iComp);
  end;{for}
  lstTillsClickCheck(nil);
end;

procedure TfrmTXReport.EnableDisableFormSelect(iComp : integer);
begin
  if (Components[iComp] is TEdit) or (Components[iComp] is TButton) then begin
    with TWinControl(Components[iComp]) do begin
      case Tag of
        1 : Enabled := cbSCR.Checked and (cmbSCRForm.ItemIndex = 2);
        2 : Enabled := cbSIN.Checked and (cmbSINForm.ItemIndex = 2);
        3 : Enabled := cbSOR.Checked and (cmbSORForm.ItemIndex = 2);
        4 : Enabled := cbSRF.Checked and (cmbSRFForm.ItemIndex = 2);
        5 : Enabled := cbSRI.Checked and (cmbSRIForm.ItemIndex = 2);
      end;{case}
    end;{with}
  end;{if}
end;


procedure TfrmTXReport.cmbFormChange(Sender: TObject);
var
  iComp : integer;
begin
  For iComp := 0 to (ComponentCount - 1) do EnableDisableFormSelect(iComp);
end;

procedure TfrmTXReport.btnBrowseClick(Sender: TObject);
var
  sFormName : string12;
begin
  OpenDialog1.InitialDir := sCurrCompPath + 'FORMS\';
{$IFDEF EX600}
  OpenDialog1.Filter := 'Exchequer form files|*.EFX;*.DEF; ';
{$ELSE}
  OpenDialog1.Filter := 'Exchequer form files|*.EFD;*.DEF; ';
{$ENDIF}
  if OpenDialog1.Execute then begin
    if UpperCase(ExtractShortPathName(ExtractFilePath(OpenDialog1.FileName))) = UpperCase(sCurrCompPath + 'FORMS\') then
      begin
        sFormName := ExtractFileName(ExtractShortPathName(OpenDialog1.FileName));
        case TButton(Sender).Tag of
          1 : edSCRForm.Text := ChangeFileExt(sFormName,'');
          2 : edSINForm.Text := ChangeFileExt(sFormName,'');
          3 : edSORForm.Text := ChangeFileExt(sFormName,'');
          4 : edSRFForm.Text := ChangeFileExt(sFormName,'');
          5 : edSRIForm.Text := ChangeFileExt(sFormName,'');
        end;{case}
      end
    else begin
      MsgBox('You must select a form from the current company''s "FORMS" directory.',mtInformation,[mbOK],mbOK,'Invalid Form');
    end;{if}
  end;{if}
end;

end.
