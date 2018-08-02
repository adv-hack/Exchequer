unit FuncDet;

{ nfrewer440 09:07 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, BTSupU1, TEditVal, Mask, {TCustom,} ExtCtrls, ComCtrls, APIUtil,
  SBSPanel, BorBtns, ExWrap1U, VarConst, ETStrU, AdPacket, OoMisc, AdPort,
  MPComms, BTList, SBSComp, GlobVar, ETDateU, CardProc, BTKeys1U, BTrvU2
  ,TXDetail, Menus, FindCard, IniFiles, NeilProc, StrUtil, TCustom;

type
  TFrmFunctionDetails = class(TForm)
    panDButtons: TSBSPanel;
    btnDOK: TSBSButton;
    sbDButtons: TScrollBox;
    btnDAdd: TSBSButton;
    btnDEdit: TSBSButton;
    btnDelete: TSBSButton;
    btnDCancel: TSBSButton;
    btnDClose: TSBSButton;
    sbDetails: TScrollBox;
    Bevel5: TBevel;
    Label5: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    lCurrentBalance: TLabel;
    edAmount: TCurrencyEdit;
    edDiscount: TCurrencyEdit;
    Label18: TLabel;
    lDiscount: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbCategory: TSBSComboBox;
    edDescription: Text8Pt;
    lName: TLabel;
    edCardNo: Text8Pt;
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnDCloseClick(Sender: TObject);
    procedure btnDCancelClick(Sender: TObject);
    procedure btnDAddClick(Sender: TObject);
    procedure btnDEditClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnDOKClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure panLDescTitMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure panLDescTitMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure panLDescTitMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnDeleteClick(Sender: TObject);
    procedure edCardNoExit(Sender: TObject);
    procedure cbCategoryChange(Sender: TObject);
  private
    FormStuff : TFormStuff;
    FormMode : TFormMode;
    bFormClosing : boolean;
    FuncBookIni : TIniFile;
    procedure WMGetMinMaxInfo(var message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    function SaveCardDetails : boolean;
    Procedure Form2Func;
    procedure Func2Form;
    procedure FillCustDetails(CustR : CustRec);
    Procedure ReadCatDefaults(cSection : char);
  public
    ExLocal : TdExLocal;
    function SetFormMode(fmSetTo : TFormMode) : boolean;
    procedure UpdateDetails(bAssign : boolean);
  end;

implementation

uses Cardlist, Comms;

{$R *.DFM}


{TFrmCardDetails}

procedure TFrmFunctionDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  iMResult : byte;
begin
  if not bFormClosing then begin
    bFormClosing := TRUE;
    Application.ProcessMessages; {so it doesn't crash hideously !}
{    with FormStuff do begin
      StoreFormProperties(Self, OpMode, bStoreCoord, bSetDefaults, bLastCoord
      , apanTitle, aMULCtrlO, acPrimeKeys);
    end;{with}
    if FormMode <> fmView then begin
      iMResult := MsgBox('You are currently editing a record.' + #13 + #13
      + 'Do you wish to save the changes that you have made to this record ?',mtConfirmation, [mbYes,mbNo],mbYes,'Function Details');
      case iMResult of
        mrYes : btnDOKClick(Self);
        mrNo : btnDCancelClick(Self);
      end;{case}
    end;{if}
    SendMessage(TForm(Owner).Handle,WM_FormCloseMsg,1,0);
    Action := caFree;
  end;{if}
end;

procedure TFrmFunctionDetails.FormCreate(Sender: TObject);
var
  iCat : byte;
  sFileName : string;
  bLock : boolean;
begin
  bFormClosing := FALSE;

  bLock := FALSE;
  GetMultiSys(FALSE,bLock);
  edDiscount.Visible := Syss.UseSplDisc;
  lDiscount.Visible := Syss.UseSplDisc;

  {Assign / Create INI File}
  sFileName := sEXEDir + 'FUNCBOOK.INI';
  FuncBookIni := TIniFile.Create(sFileName);

  ExLocal.Create; {create local record instance for independant data manipulation}
  FormStuff := TFormStuff.Create(1);

  {set default size}
  ClientHeight := 200;
  ClientWidth := 454;

  {Setup List Properties}
  with FormStuff do begin
    bFillList := FALSE;
    SetLength(aColumns[0],1);
    aFileNos[0] := 0;
    asbMain[0] := sbDetails;
    acPrimeKeys[0] := ' ';
    apanTitle[0] := nil;
    asbButtons[0] := sbDButtons;
    apanButtons[0] := panDButtons;
    aMULCtrlO[0] := nil;
    apanScrollBar[0] := nil;
    aCaseSensSearch[0] := TRUE;
    aiKeys[0] := 0;
    asStartKeys[0] := '';
    ReadFormProperties(Self, FormStuff);
    FormResize(Self);
  end;{with}

  For iCat := 0 to (NoOfFuncCats - 1) do cbCategory.Items.Add('Function ' + CHR(65 + iCat));
end;

function TFrmFunctionDetails.SetFormMode(fmSetTo: TFormMode) : boolean;
var
  iComp : integer;
  cSection : char;
begin
  Result := TRUE;
  case fmSetTo of
    fmEdit : begin
      if LockRecord(InvF, InvCustK, ExLocal, TRUE) then Func2Form
      else fmSetTo := fmView;
    end;
  end;{case}

  ExLocal.InAddEdit := fmSetTo <> fmView; {set edit mode of local record}
  FormMode := fmSetTo;

  {enable / disable components dependant on FormMode}
  For iComp := 0 to (ComponentCount - 1) do begin
    if (Components[iComp] is TSBSComboBox) and (TSBSComboBox(Components[iComp]).Tag > 0)
    then TSBSComboBox(Components[iComp]).ReadOnly := Ord(fmSetTo) < 1
    else begin
      if (Components[iComp] is Text8pt) and (Text8pt(Components[iComp]).Tag > 0)
      then Text8pt(Components[iComp]).ReadOnly := Ord(fmSetTo) < 1
      else begin
        if (Components[iComp] is TCurrencyEdit) and (TCurrencyEdit(Components[iComp]).Tag > 0)
        then TCurrencyEdit(Components[iComp]).ReadOnly := Ord(fmSetTo) < 1
        else begin
          if (Components[iComp] is TEditDate) and (TEditDate(Components[iComp]).Tag > 0)
          then TEditDate(Components[iComp]).ReadOnly := Ord(fmSetTo) < 1
          else begin
            if (Components[iComp] is TCheckBox) and (TCheckBox(Components[iComp]).Tag > 0)
            then TCheckBox(Components[iComp]).Enabled := Ord(fmSetTo) > 0
            else begin
              if (Components[iComp] is TTabSheet) and (TTabSheet(Components[iComp]).Name <> 'tabDetails')
              then TTabSheet(Components[iComp]).TabVisible := (fmSetTo = fmView) and (TTabSheet(Components[iComp]).Tag <> -1)
              else begin
                if (Components[iComp] is TSBSButton)
                then TSBSButton(Components[iComp]).Enabled := (Ord(fmSetTo) > 0) and (TSBSButton(Components[iComp]).Tag = 1)
                or (Ord(fmSetTo) = 0) and (TSBSButton(Components[iComp]).Tag = 0);
              end;{if}
            end;{if}
          end;{if}
        end;{if}
      end;{if}
    end;{if}
  end;{for}

  {set active control dependant on FormMode}
  case fmSetTo of
    fmView : ActiveControl := btnDClose;
    fmEdit : ActiveControl := cbCategory;
    fmAdd  : begin
      ActiveControl := cbCategory;
      For iComp := 0 to (ComponentCount - 1) do begin
        if ((Components[iComp] is TSBSComboBox)
        or (Components[iComp] is Text8pt)
        or (Components[iComp] is TCurrencyEdit)
        or (Components[iComp] is TEditDate))
        then TEdit(Components[iComp]).Text := '';
      end;{for}
      lCurrentBalance.Caption := '';
      lName.Caption := '';

      cSection := FuncBookIni.ReadString('LastCat','Category','A')[1];
      ReadCatDefaults(cSection);
      cbCategory.ItemIndex := Ord(cSection) - 65;
    end;
  end;{case}
end;

procedure TFrmFunctionDetails.btnDCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmFunctionDetails.btnDCancelClick(Sender: TObject);
begin
  if (FormMode = fmEdit) then LockRecord(InvF, InvCustK, ExLocal, FALSE);
  SetFormMode(fmView);
  if not (Sender is TForm) then UpdateDetails(FALSE);
end;

procedure TFrmFunctionDetails.btnDAddClick(Sender: TObject);
begin
  SetFormMode(fmAdd);
end;

procedure TFrmFunctionDetails.btnDEditClick(Sender: TObject);
begin
  if (ExLocal.LInv.OurRef <> '') then SetFormMode(fmEdit);
end;

procedure TFrmFunctionDetails.UpdateDetails(bAssign : boolean);
begin
  with ExLocal do begin
    if bAssign then begin
      AssignFromGlobal(InvF); {makes a local copy of the global variable}
      LGetRecAddr(InvF);
    end;{if}
    Func2Form;
  end;{with}
end;

procedure TFrmFunctionDetails.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;
  FormStuff.Free;
  FuncBookIni.Free;
end;

procedure TFrmFunctionDetails.btnDOKClick(Sender: TObject);
begin
  if (SaveCardDetails) and (not (Sender is TForm)) then SetFormMode(fmView);
  SendMessage((Owner as TForm).Handle,WM_CustGetRec,200,0);
end;

procedure TFrmFunctionDetails.FormResize(Sender: TObject);
begin
  DoFormResize(Self, FormStuff);
end;

procedure TFrmFunctionDetails.panLDescTitMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {depresses the column header}
  if (Sender is TSBSPanel) and (not TSBSPanel(Sender).ReadytoDrag) and (Button = MBLeft)
  then FormStuff.aMULCtrlO[TSBSPanel(Sender).Tag].VisiList.PrimeMove(Sender); {begin column drag/drop}
end;

procedure TFrmFunctionDetails.panLDescTitMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  {visually moves column header to show the change about to be made (drag/drop}
  if (Sender is TSBSPanel) then FormStuff.aMULCtrlO[TSBSPanel(Sender).Tag].VisiList.MoveLabel(X,Y);
end;

procedure TFrmFunctionDetails.panLDescTitMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender is TSBSPanel) then DoMoveAlignCols(TSBSPanel(Sender), FormStuff, TSBSPanel(Sender).Tag);
end;

procedure TFrmFunctionDetails.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 300;
    ptMinTrackSize.Y := 156;

    ptMaxTrackSize.X := 462;
    ptMaxTrackSize.Y := 227;
  end;{with}
  Message.Result := 0;
  inherited;
end;

function TFrmFunctionDetails.SaveCardDetails : boolean;
var
  sSection : string;
begin
  Form2Func;
  with ExLocal, LInv do begin
    if not CardExists(edCardNo.Text) then
      begin
        MessageDlg('You have not picked a valid card',mtWarning,[mbOk],0);
        Result := FALSE;
      end
    else begin
      if StrToFloat(edAmount.Text) <= 0 then
        begin
          MessageDlg('You need to input a positive amount.',mtWarning,[mbOk],0);
          Result := FALSE;
        end
      else begin
        Result := TRUE;
        {save record}
        case FormMode of
          fmEdit : begin
            SaveRecord(InvF, ExLocal);
            LockRecord(InvF, InvCustK, ExLocal, FALSE);
          end;

          fmAdd : begin
            Source := isFuncBook;
            CustCode := FuncKey;
            OurRef := 'FBK/' + SetPadNo(Form_Int(Syss.BookCount, 0), 6);
            FolioNum := -Syss.BookCount;
            RunNo := -1;

            ILineCount := 1;
            TransDate := Today;

            { Invoice Header }
            If (Syss.VatMode = vmAdv) Then InvDocHed := SRI
            Else InvDocHed := NMT;

            { Payment Type }
            PayType := PayTypes [4]; { Forfeit }

            AddRecord(InvF, ExLocal);{Write to database}

            {Update INI file}
            sSection := CHR(cbCategory.ItemIndex + 65);
            FuncBookIni.WriteString(sSection,'LastDescription',TransDesc);
            FuncBookIni.WriteString(sSection,'LastAmount',MoneyToStr(InvNetVal));
            if Syss.UseSplDisc then FuncBookIni.WriteString(sSection,'LastDiscount',MoneyToStr(Discount));
            FuncBookIni.WriteString('LastCat','Category',sSection);
            IncBookCount;
          end;
        end;{case}
      end;{if}
    end;{if}
  end;{with}
end;

procedure TFrmFunctionDetails.Form2Func;
{Copies the values on the screen into the local record instance}
begin
  with ExLocal, LInv do begin
    if FormMode = fmAdd then LResetRec(InvF);
    CustCode := FuncKey;
    FBookCust := PadString(psRight, edCardNo.Text, ' ', CardKeyLen);
    InvNetVal := StrToFloat(edAmount.Text);
    if Syss.UseSplDisc then Discount := StrToFloat(edDiscount.Text)
    else Discount := 0;
    TransDesc := edDescription.Text;
    FBookCat := cbCategory.ItemIndex;
  end;{with}
end;

procedure TFrmFunctionDetails.Func2Form;
{fills controls from local record instance}
begin
  with ExLocal, LInv do begin
    if (OurRef <> '') then begin
      if CustCode <> '' then begin
        GetCustFromInv(ExLocal, TRUE);
        FillCustDetails(LCust);
      end;{if}
      edAmount.Text := MoneyToStr(InvNetVal);
      if Syss.UseSplDisc then edDiscount.Text := MoneyToStr(Discount);
      edDescription.Text := TransDesc;
      cbCategory.ItemIndex := FBookCat;
    end;{if}
  end;{with}
end;

procedure TFrmFunctionDetails.btnDeleteClick(Sender: TObject);
begin
  if (ExLocal.LInv.OurRef <> '') and (msgBox('Are you sure you want to delete this function ?',mtConfirmation,[mbYes,mbNo],mbNo
  ,'Delete Function') = mrYes) and LockRecord(InvF, InvCustK, ExLocal, TRUE) then begin
    {delete function record}
    screen.cursor := crHourglass;
    Report_Berror(InvF, Delete_Rec(F[InvF],InvF,InvCustK));
    SendMessage((Owner as TForm).Handle,WM_CustGetRec,200,0);
    SendMessage((Owner as TForm).Handle,WM_CustGetRec,1,0);
    screen.cursor := crDefault;
  end;{if}
end;

procedure TFrmFunctionDetails.edCardNoExit(Sender: TObject);
begin
  if (FormMode in [fmAdd, fmEdit]) and (ActiveControl <> btnDCancel)
  and (ActiveControl <> cbCategory) then begin
    if CardExists(edCardNo.Text) then FillCustDetails(Cust){found}
    else FillCustDetails(DoFindCard(UpperCase(edCardNo.Text)));{not found}
  end;{if}
end;

procedure TFrmFunctionDetails.FillCustDetails(CustR : CustRec);
begin
  with CustR do begin
    if CustCode <> '' then begin
      edCardNo.Text := CustCode;
      lName.Caption := CardFullName(CustR, True, True);{Members Name}
      lCurrentBalance.Caption := MoneyToStr(CurrBalance);
      if CustR.CurrBalance > 0 then lCurrentBalance.Font.Color := clRed
      else lCurrentBalance.Font.Color := $00003973;
    end;{if}
  end;{with}
end;

Procedure TFrmFunctionDetails.ReadCatDefaults(cSection : char);
begin
  edDescription.Text := FuncBookIni.ReadString(cSection,'LastDescription','');
  edAmount.Text := FuncBookIni.ReadString(cSection,'LastAmount','0');
  if Syss.UseSplDisc then begin
    edDiscount.Text := FuncBookIni.ReadString(cSection,'LastDiscount','0');
    if edDiscount.Text = '0' then edDiscount.Text := MoneyToStr(Syss.MarkUp);
  end;{if}
end;

procedure TFrmFunctionDetails.cbCategoryChange(Sender: TObject);
begin
  if (FormMode = fmAdd) then ReadCatDefaults(CHR(cbCategory.ItemIndex + 65));
end;

end.

