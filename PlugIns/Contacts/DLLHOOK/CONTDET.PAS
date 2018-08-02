unit ContDet;

{ nfrewer440 16:07 13/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , uSettingsSQL, StdCtrls, TCustom, TEditVal, Mask, ExtCtrls, GlobVar, BTrvU2
  , Menus, EnterToTab;

type
  TfrmContactDetails = class(TForm)
    btnOk: TSBSButton;
    btnCancel: TSBSButton;
    panCode: TPanel;
    Label81: Label8;
    edtCode: Text8Pt;
    panContact: TPanel;
    Label87: Label8;
    Label88: Label8;
    Label89: Label8;
    edtContactNo: Text8Pt;
    edtFaxNumber: Text8Pt;
    edtEmailAddr: Text8Pt;
    edAddress1: Text8Pt;
    edAddress2: Text8Pt;
    edAddress3: Text8Pt;
    edAddress4: Text8Pt;
    edPostCode: Text8Pt;
    Label811: Label8;
    Label812: Label8;
    panName: TPanel;
    Label82: Label8;
    Label83: Label8;
    Label86: Label8;
    Label84: Label8;
    Label85: Label8;
    edtTitle: Text8Pt;
    edtFirstName: Text8Pt;
    edtSalutation: Text8Pt;
    edtSurname: Text8Pt;
    edtPosition: Text8Pt;
    pmMain: TPopupMenu;
    Properties1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    EnterToTab1: TEnterToTab;
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Properties1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    bRestore : boolean;
    procedure SaveAllSettings;
    procedure LoadAllSettings;
  public
    bFind, bAllowEdits : boolean;
//    function FillContactDetails(sCompany, sAccountCode, sContactCode : string; bEdit : boolean) : integer;
  end;

{var
  frmContactDetails: TfrmContactDetails;}

implementation
uses
  VarConst, ContSel{, Contkey};

{$R *.DFM}

(*
function TfrmContactDetails.FillContactDetails(sCompany, sAccountCode, sContactCode : string; bEdit : boolean) : integer;
var
  LStatus : smallInt;
  KeyS : Str255;
begin
  KeyS := BuildCodeIndex(sCompany, sAccountCode, sContactCode);
  LStatus := Find_Rec(B_GetEq, F[ContactF],ContactF,RecPtr[ContactF]^,CoCodeIdx, KeyS);
  if LStatus = 0 then
  begin
    if bEdit then LStatus := frmContactMain.LockRecord;
    if LStatus = 0 then
    begin
     frmContactDetails := TfrmContactDetails.Create(application);
     with frmContactDetails do begin
      Try
        with ContactRec do
        begin
          edtCode.Text := Trim(coCode);

          edtTitle.Text := Trim(coTitle);
          edtFirstName.Text := Trim(coFirstName);
          edtSurname.Text := Trim(coSurname);
          edtPosition.Text := Trim(coPosition);
          edtSalutation.Text := Trim(coSalutation);
          edtContactNo.Text := Trim(coContactNo);
          edtFaxNumber.Text := Trim(coFaxNumber);
          edtEmailAddr.Text := Trim(coEmailAddr);
          edAddress1.Text := Trim(coAddress1);
          edAddress2.Text := Trim(coAddress2);
          edAddress3.Text := Trim(coAddress3);
          edAddress4.Text := Trim(coAddress4);
          edPostCode.Text := Trim(coPostCode);
        end;
        bAllowEdits := bEdit;
        bFind := FALSE;
        ShowModal;
        if ModalResult = mrOK then
          begin
          //update the record
            DetailsToRec(sCompany, sAccountCode, frmContactDetails);
            LStatus := Put_Rec(F[ContactF],ContactF,RecPtr[ContactF]^,CoCodeIdx);
            if LStatus <> 0 then ShowMessage('Put_Rec Error: ' + IntToStr(LStatus))
          end
        else begin
          if bEdit then frmContactMain.UnlockRecord;
          LStatus := -1;
        end;{if}
      Finally
        Freeandnil(frmContactDetails);
      End;
     end;
    end;
  end;
  Result := LStatus;
end;
*)
procedure TfrmContactDetails.FormShow(Sender: TObject);
var
  iComp, iCont : integer;
begin
  bRestore := FALSE;
  For iComp := 0 to (ComponentCount - 1) do begin
    if (Components[iComp] is TPanel) then begin
      with TPanel(Components[iComp]) do begin
        For iCont := 0 to (controlcount - 1) do begin
          if (Controls[iCont] is Text8Pt)
          then Text8Pt(Controls[iCont]).ReadOnly := not bAllowEdits;
        end;{for}
      end;{with}
    end;{if}
  end;{for}
  btnCancel.Visible := bAllowEdits;

  if bFind or (not bAllowEdits) then btnOK.Cancel := TRUE; 
end;

procedure TfrmContactDetails.FormKeyPress(Sender: TObject; var Key: Char);
begin
//  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TfrmContactDetails.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TfrmContactDetails.Properties1Click(Sender: TObject);
begin
  case oSettings.Edit(nil, Self.Name, edtTitle) of
    mrOK : oSettings.ColorFieldsFrom(edtTitle, Self);
    mrRestoreDefaults : begin
      oSettings.RestoreParentDefaults(Self, Self.Name);
      oSettings.RestoreFormDefaults(Self.Name);
      bRestore := TRUE;
    end;
  end;{case}
end;

procedure TfrmContactDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if not bRestore then SaveAllSettings;
end;

procedure TfrmContactDetails.SaveAllSettings;
begin
  oSettings.SaveParentFromControl(edtTitle, Self.Name);
  if SaveCoordinates1.Checked then oSettings.SaveForm(Self);
end;

procedure TfrmContactDetails.LoadAllSettings;
begin
  oSettings.LoadForm(Self);
  oSettings.LoadParentToControl(Self.Name, Self.Name, edtTitle);
  oSettings.ColorFieldsFrom(edtTitle, Self);
end;

procedure TfrmContactDetails.FormCreate(Sender: TObject);
begin
  LoadAllSettings;
end;

end.
