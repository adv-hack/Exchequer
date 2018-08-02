unit PLUDet;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, BTSupU1
  , TEditVal, Mask, ExtCtrls, ComCtrls, NeilProc, SBSPanel, BorBtns, ExWrap1U, VarConst, ETStrU
  , AdPacket, OoMisc, AdPort, MPComms, BTList, SBSComp, GlobVar, ETDateU, CardProc, BTKeys1U
  , BTrvU2,TXDetail, Menus, FindCard, IniFiles, aPIUtil, TCustom;

type
  TFrmPLUDetails = class(TForm)
    panDButtons: TSBSPanel;
    btnDOK: TSBSButton;
    btnDCancel: TSBSButton;
    btnDClose: TSBSButton;
    sbDetails: TScrollBox;
    Bevel5: TBevel;
    lPLUNameDesc: TLabel;
    lPLUNoDesc: TLabel;
    edDiscount: TCurrencyEdit;
    lDiscount: TLabel;
    Label2: TLabel;
    lPLUName: TLabel;
    Label1: TLabel;
    lGroup: TLabel;
    lPLUNumber: TLabel;
    Bevel1: TBevel;
    Label3: TLabel;
    lGroupDisc: TLabel;
    Bevel2: TBevel;
    btnDEdit: TSBSButton;
    cbOverride: TBorCheck;
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
    procedure cbOverrideClick(Sender: TObject);
  private
    FormStuff : TFormStuff;
    FormMode : TFormMode;
    bFormClosing : boolean;
    procedure WMGetMinMaxInfo(var message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    function SaveCardDetails : boolean;
    Procedure Form2PLU;
    procedure PLU2Form;
  public
    ExLocal : TdExLocal;
    function SetFormMode(fmSetTo : TFormMode) : boolean;
    procedure UpdateDetails(bAssign : boolean);
  end;

implementation

uses Cardlist, Comms;

{$R *.DFM}


{TFrmCardDetails}

procedure TFrmPLUDetails.FormClose(Sender: TObject;
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
      + 'Do you wish to save the changes that you have made to this record ?',mtConfirmation, [mbYes,mbNo],mbYes,'PLU Details');
      case iMResult of
        mrYes : btnDOKClick(Self);
        mrNo : btnDCancelClick(Self);
      end;{case}
    end;{if}
    SendMessage(TForm(Owner).Handle,WM_FormCloseMsg,1,0);
    Action := caFree;
  end;{if}
end;

procedure TFrmPLUDetails.FormCreate(Sender: TObject);
var
  sFileName : string;
  bLock : boolean;
begin
  bFormClosing := FALSE;

  bLock := FALSE;
  GetMultiSys(FALSE,bLock);
  edDiscount.Enabled := Syss.UseSplDisc;
  lDiscount.Enabled := Syss.UseSplDisc;
  cbOverride.Enabled := Syss.UseSplDisc;

  {Assign / Create INI File}
  sFileName := sEXEDir + 'FUNCBOOK.INI';

  ExLocal.Create; {create local record instance for independant data manipulation}
  FormStuff := TFormStuff.Create(1);

  {set default size}
  ClientHeight := 176;
  ClientWidth := 376;

  {Setup List Properties}
  with FormStuff do begin
    bFillList := FALSE;
    SetLength(aColumns[0],1);
    aFileNos[0] := 0;
    asbMain[0] := sbDetails;
    acPrimeKeys[0] := ' ';
    apanTitle[0] := nil;
    asbButtons[0] := nil;
    apanButtons[0] := panDButtons;
    aMULCtrlO[0] := nil;
    apanScrollBar[0] := nil;
    aCaseSensSearch[0] := TRUE;
    aiKeys[0] := 0;
    asStartKeys[0] := '';
    ReadFormProperties(Self, FormStuff);
    FormResize(Self);
  end;{with}

end;

function TFrmPLUDetails.SetFormMode(fmSetTo: TFormMode) : boolean;
var
  iComp : integer;
begin
  Result := TRUE;
  case fmSetTo of
    fmEdit : begin
      if LockRecord(ItemF, siTypeK, ExLocal, TRUE) then PLU2Form
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
            if (Components[iComp] is TBorCheck) and (TBorCheck(Components[iComp]).Tag > 0)
            then TBorCheck(Components[iComp]).Enabled := Ord(fmSetTo) > 0
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
    fmEdit : begin
      edDiscount.Enabled := cbOverRide.Checked;
      lDiscount.Enabled := cbOverRide.Checked;
      ActiveControl := cbOverride;
    end;{if}
  end;{case}

  if not Syss.UseSplDisc then btnDEdit.Enabled := FALSE;
end;

procedure TFrmPLUDetails.btnDCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmPLUDetails.btnDCancelClick(Sender: TObject);
begin
  if (FormMode = fmEdit) then LockRecord(ItemF, siTypeK, ExLocal, FALSE);
  SetFormMode(fmView);
  if not (Sender is TForm) then UpdateDetails(FALSE);
end;

procedure TFrmPLUDetails.btnDAddClick(Sender: TObject);
begin
  SetFormMode(fmAdd);
end;

procedure TFrmPLUDetails.btnDEditClick(Sender: TObject);
begin
  SetFormMode(fmEdit);
end;

procedure TFrmPLUDetails.UpdateDetails(bAssign : boolean);
begin
  with ExLocal do begin
    if bAssign then begin
      AssignFromGlobal(ItemF); {makes a local copy of the global record}
      LGetRecAddr(ItemF);
      AssignFromGlobal(GroupF); {makes a local copy of the global record}
      LGetRecAddr(GroupF);
    end;{if}
    PLU2Form;
  end;{with}
end;

procedure TFrmPLUDetails.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;
  FormStuff.Free;
end;

procedure TFrmPLUDetails.btnDOKClick(Sender: TObject);
begin
  if (SaveCardDetails) and (not (Sender is TForm)) then SetFormMode(fmView);
  SendMessage((Owner as TForm).Handle,WM_CustGetRec,200,0);
end;

procedure TFrmPLUDetails.FormResize(Sender: TObject);
begin
  DoFormResize(Self, FormStuff);
end;

procedure TFrmPLUDetails.panLDescTitMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {depresses the column header}
  if (Sender is TSBSPanel) and (not TSBSPanel(Sender).ReadytoDrag) and (Button = MBLeft)
  then FormStuff.aMULCtrlO[TSBSPanel(Sender).Tag].VisiList.PrimeMove(Sender); {begin column drag/drop}
end;

procedure TFrmPLUDetails.panLDescTitMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  {visually moves column header to show the change about to be made (drag/drop}
  if (Sender is TSBSPanel) then FormStuff.aMULCtrlO[TSBSPanel(Sender).Tag].VisiList.MoveLabel(X,Y);
end;

procedure TFrmPLUDetails.panLDescTitMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender is TSBSPanel) then DoMoveAlignCols(TSBSPanel(Sender), FormStuff, TSBSPanel(Sender).Tag);
end;

procedure TFrmPLUDetails.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 385;
    ptMinTrackSize.Y := 202;

    ptMaxTrackSize.X := 385;
    ptMaxTrackSize.Y := 202;
  end;{with}
  Message.Result := 0;
  inherited;
end;

function TFrmPLUDetails.SaveCardDetails : boolean;
begin
  Form2PLU;
  with ExLocal, LItemRec do begin
    if StrToFloat(edDiscount.Text) > 100 then
      begin
        MessageDlg('Please input a valid discount rate.',mtWarning,[mbOk],0);
        ActiveControl := edDiscount;
        Result := FALSE;
      end
    else begin
      Result := TRUE;
      {save record}
      case FormMode of
        fmEdit : begin
          SaveRecord(ItemF, ExLocal);
          LockRecord(ItemF, siTypeK, ExLocal, FALSE);
        end;
      end;{case}
    end;{if}
  end;{with}
end;

procedure TFrmPLUDetails.Form2PLU;
{Copies the values on the screen into the local record instance}
begin
  with ExLocal, LItemRec do begin
    siOverride := cbOverride.Checked;
    siDiscount := StrToFloat(edDiscount.Text);
  end;{with}
end;

procedure TFrmPLUDetails.PLU2Form;
begin
  with ExLocal, LItemRec do begin
    lGroup.Caption := IntToStr(LGroupRec.grArrayNo) + '. ' + LGroupRec.grName;
    lGroupDisc.Caption := MoneyToStr(LGroupRec.grDiscount);
    lPLUNumber.Caption := IntToStr(siNumber);
    lPLUName.Caption := siName;
    cbOverride.Checked := siOverride;
    edDiscount.Text := MoneyToStr(siDiscount);
    if siType = 'P' then
      begin
        {PLU}
        Caption := 'PLU Details';
        lPLUNoDesc.Caption := 'PLU Number :';
        lPLUNameDesc.Caption := 'PLU Name :';
      end
    else begin
      {DEPT}
      Caption := 'Department Details';
      lPLUNoDesc.Caption := 'Dept. Number :';
      lPLUNameDesc.Caption := 'Dept. Name :';
    end;
  end;{with}
end;

procedure TFrmPLUDetails.cbOverrideClick(Sender: TObject);
begin
  edDiscount.Enabled := cbOverRide.Checked;
  lDiscount.Enabled := cbOverRide.Checked;
end;

end.

