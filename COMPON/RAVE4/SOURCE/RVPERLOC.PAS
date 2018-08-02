{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVPERLoc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RVClass, RVCsRpt, RVUtil, RVTool, RPDefine;

type
  TReprintLocsDialog = class(TForm)
    GroupBox1: TGroupBox;
    BodyHeaderCB: TCheckBox;
    GroupHeaderCB: TCheckBox;
    RowHeaderCB: TCheckBox;
    MasterCB: TCheckBox;
    DetailCB: TCheckBox;
    RowFooterCB: TCheckBox;
    GroupFooterCB: TCheckBox;
    BodyFooterCB: TCheckBox;
    OKButton: TButton;
    CancelButton: TButton;
    AllButton: TButton;
    NoneButton: TButton;
    procedure OKButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AllButtonClick(Sender: TObject);
    procedure NoneButtonClick(Sender: TObject);
  private
    { Private declarations }
    FReprintLocs: TBandPrintLocSet;

    procedure SetReprintLocs(Value: TBandPrintLocSet);
  public
    { Public declarations }
    property ReprintLocs: TBandPrintLocSet read FReprintLocs write SetReprintLocs;
  end;

  procedure RaveRegister;

var
  ReprintLocsDialog: TReprintLocsDialog;

implementation

{$R *.DFM}

type
  TRaveReprintLocsPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    procedure Edit; override;
    function GetValue: string; override;
  end; { TRaveReprintLocsPropertyEditor }

  procedure RaveRegister;

  begin { RaveRegister }
  {TransOff}
    RegisterRavePropertyEditor(TypeInfo(TBandPrintLocSet),TRaveBand,'ReprintLocs',
     TRaveReprintLocsPropertyEditor);
  {TransOn}
  end;  { RaveRegister }

(*****************************************************************************}
( class TRaveReprintLocsPropertyEditor
(*****************************************************************************)

  function TRaveReprintLocsPropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poReadOnly,poEditor,poMultiSelect];
  end;  { GetOptions }

  function TRaveReprintLocsPropertyEditor.GetValue: string;

    procedure IncChar(var Value: string;
                          Ch: char;
                          Loc: TBandPrintLoc);

    begin { IncChar }
      If Loc in TRaveBand(Instance[0]).ReprintLocs then begin
        Value := Value + Ch;
      end; { if }
    end;  { IncChar }

  begin { GetValue }
    Result := '';
    IncChar(Result,'B',plBodyHeader);
    IncChar(Result,'G',plGroupHeader);
    IncChar(Result,'R',plRowHeader);
    IncChar(Result,'M',plMaster);
    IncChar(Result,'D',plDetail);
    IncChar(Result,'r',plRowFooter);
    IncChar(Result,'g',plGroupFooter);
    IncChar(Result,'b',plBodyFooter);
    If Result = {Trans-}'BGRMDrgb' then begin
      Result := Trans('All');
    end; { if }
    If Result = '' then begin
      Result := Trans('None');
    end; { if }
    Result := '(' + Result + ')';
  end;  { GetValue }

  procedure TRaveReprintLocsPropertyEditor.Edit;

  var
    I1: integer;
    TempLocs: TBandPrintLocSet;

  begin { Edit }
    With TReprintLocsDialog.Create(Application) do try
      I1 := GetOrdValue(0);
      Move(I1,TempLocs,SizeOf(TempLocs));
      ReprintLocs := TempLocs;
      If ShowModal = mrOK then begin
      { Copy from dialog contents }
        For I1 := 0 to InstCount - 1 do begin
          TRaveBand(Instance[I1]).ReprintLocs := ReprintLocs;
          TRaveBand(Instance[I1]).Invalidate;
        end; { for }
        Modified;
      end; { if }
    finally
      Free;
    end; { with }
  end;  { Edit }

(*****************************************************************************}
( class TReprintLocsDialog
(*****************************************************************************)

  procedure TReprintLocsDialog.SetReprintLocs(Value: TBandPrintLocSet);

  begin { SetReprintLocs }
  { Copy values from ReprintLocs to checkboxes }
    FReprintLocs := Value;
    BodyHeaderCB.Checked := plBodyHeader in FReprintLocs;
    GroupHeaderCB.Checked := plGroupHeader in FReprintLocs;
    RowHeaderCB.Checked := plRowHeader in FReprintLocs;
    MasterCB.Checked := plMaster in FReprintLocs;
    DetailCB.Checked := plDetail in FReprintLocs;
    RowFooterCB.Checked := plRowFooter in FReprintLocs;
    GroupFooterCB.Checked := plGroupFooter in FReprintLocs;
    BodyFooterCB.Checked := plBodyFooter in FReprintLocs;
  end;  { SetReprintLocs }

  procedure TReprintLocsDialog.OKButtonClick(Sender: TObject);
  begin
  { Copy values from checkboxes to ReprintLocs }
    FReprintLocs := [];
    If BodyHeaderCB.Checked then begin
      Include(FReprintLocs,plBodyHeader);
    end; { if }
    If GroupHeaderCB.Checked then begin
      Include(FReprintLocs,plGroupHeader);
    end; { if }
    If RowHeaderCB.Checked then begin
      Include(FReprintLocs,plRowHeader);
    end; { if }
    If MasterCB.Checked then begin
      Include(FReprintLocs,plMaster);
    end; { if }
    If DetailCB.Checked then begin
      Include(FReprintLocs,plDetail);
    end; { if }
    If RowFooterCB.Checked then begin
      Include(FReprintLocs,plRowFooter);
    end; { if }
    If GroupFooterCB.Checked then begin
      Include(FReprintLocs,plGroupFooter);
    end; { if }
    If BodyFooterCB.Checked then begin
      Include(FReprintLocs,plBodyFooter);
    end; { if }
  end;

  procedure TReprintLocsDialog.FormCreate(Sender: TObject);
  begin
    FormTrans(self);
    PrepareToolWin(self);
  end;

  procedure TReprintLocsDialog.FormDestroy(Sender: TObject);
  begin
    SaveToolWin(self);
  end;

  procedure TReprintLocsDialog.FormShow(Sender: TObject);
  begin
    RestoreToolWin(self);
  end;

  procedure TReprintLocsDialog.AllButtonClick(Sender: TObject);
  begin
    ReprintLocs := [plBodyHeader..plBodyFooter];
  end;

  procedure TReprintLocsDialog.NoneButtonClick(Sender: TObject);
  begin
    ReprintLocs := [];
  end;

initialization
  RegisterProc('RVCL',RaveRegister);
end.
