unit SCTDet;

{ nfrewer440 16:57 09/07/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , StdCtrls, ExtCtrls, VarConst, BtrvU2, StrUtil, APIUtil, Globvar, Dialogs
  , SComProc, MiscUtil;

type
  TFrmSCTDetails = class(TForm)
    Bevel1: TBevel;
    edSCT: TEdit;
    Label1: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    iFolioNo : LongInt;
    fmFormMode : TFormMode;
    { Public declarations }
  end;

var
  FrmSCTDetails: TFrmSCTDetails;

implementation

uses Admin;

{$R *.dfm}

procedure TFrmSCTDetails.FormShow(Sender: TObject);
begin
  case fmFormMode of
    fmAdd : caption := 'Add Sales Code Type';
    fmEdit : caption := 'Edit Sales Code Type';
  end;
//  sOrigValue := edSCT.Text;
end;

procedure TFrmSCTDetails.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmSCTDetails.btnOKClick(Sender: TObject);
var
  SalesCodeTypeRec  : TSalesCodeTypeRec;
  iStatus : integer;
  KeyS : str255;
begin

  case fmFormMode of
    fmAdd : begin
      FillChar(SalesCodeTypeRec,SizeOf(SalesCodeTypeRec),#0);
      SalesCodeTypeRec.sctFolioNo := GetNextFolio(SalesCodeTypeF);
      SalesCodeTypeRec.sctDescription := PadString(psRight,edSCT.Text,' ',10);
      SalesCodeTypeRec.sctDummyChar := IDX_DUMMY_CHAR;
      iStatus := Add_Rec(F[SalesCodeTypeF], SalesCodeTypeF, SalesCodeTypeRec, 0);
      if iStatus = 5 then MsgBox('You already have a Sales Code Type with the given value'
      , mtInformation, [mbOK], mbOK, 'Duplicate Sales Code Type')
      else ShowBTError(iStatus, 'Add_Rec', FileNames[SalesCodeTypeF]);
    end;

    fmEdit : begin

      // get record with new value
      KeyS := PadString(psRight,edSCT.Text,' ',10);
      iStatus := Find_Rec(B_GetEq, F[SalesCodeTypeF], SalesCodeTypeF, SalesCodeTypeRec, sctDescriptionIdx, KeyS);
      if (iStatus = 0) and (SalesCodeTypeRec.sctFolioNo <> iFolioNo) then
        begin
          MsgBox('You already have a Sales Code Type with the given value'
          , mtInformation, [mbOK], mbOK, 'Duplicate Sales Code Type');
          iStatus := 5;
        end
      else begin
        // get original record
        KeyS := FrmAdmin.mlSalesCodes.FullNomKey(iFolioNo) + IDX_DUMMY_CHAR;
        iStatus := Find_Rec(B_GetEq, F[SalesCodeTypeF], SalesCodeTypeF, SalesCodeTypeRec, sctFolioIdx, KeyS);
        if iStatus = 0 then
          begin
            // store update to record
//            FillChar(SalesCodeTypeRec,SizeOf(SalesCodeTypeRec),#0);
            SalesCodeTypeRec.sctDescription := PadString(psRight,edSCT.Text,' ',10);
            iStatus := Put_Rec(F[SalesCodeTypeF], SalesCodeTypeF, SalesCodeTypeRec, sctFolioIdx);
            ShowBTError(iStatus, 'Put_Rec', FileNames[SalesCodeTypeF]);
          end
        else ShowBTError(iStatus, 'Find_Rec', FileNames[SalesCodeTypeF]);
      end;
    end;
  end;{case}

  if iStatus = 0 then ModalResult := mrOK;
end;

end.
