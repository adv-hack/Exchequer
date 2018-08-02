{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVPEAnch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, RVDefine, RVUtil, RVClass, RVTool, RPDefine;

type
  TAnchorEditor = class(TForm)
    HorizRG: TRadioGroup;
    VertRG: TRadioGroup;
    OKBtn: TButton;
    CancelBtn: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ImageV6: TImage;
    ImageV5: TImage;
    ImageV4: TImage;
    ImageV3: TImage;
    ImageV2: TImage;
    ImageV1: TImage;
    ImageH6: TImage;
    ImageH5: TImage;
    ImageH1: TImage;
    ImageH4: TImage;
    ImageH3: TImage;
    ImageH2: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure VertRGClick(Sender: TObject);
    procedure HorizRGClick(Sender: TObject);
  private
    FAnchor: TRaveAnchor;
  public
    property Anchor: TRaveAnchor read FAnchor write FAnchor;
  end;

  procedure RaveRegister;

var
  AnchorEditor: TAnchorEditor;

implementation

{$R *.DFM}

type
  TRaveAnchorPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    procedure Edit; override;
    function GetValue: string; override;
  end; { TRaveAnchorPropertyEditor }

  procedure RaveRegister;

  begin { RaveRegister }
  {TransOff}
    RegisterRavePropertyEditor(TypeInfo(TRaveAnchor),nil,'Anchor',
     TRaveAnchorPropertyEditor);
  {TransOn}
  end;  { RaveRegister }

(*****************************************************************************}
( class TRaveAnchorPropertyEditor
(*****************************************************************************)

  function TRaveAnchorPropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poReadOnly,poEditor,poMultiSelect];
  end;  { GetOptions }

  function TRaveAnchorPropertyEditor.GetValue: string;

  begin { GetValue }
    Case GetOrdValue(0) div 16 of
      0: Result := '(' + Trans('Top');
      1: Result := '(' + Trans('Bottom');
      2: Result := '(' + Trans('V-Center');
      3: Result := '(' + Trans('V-Stretch');
      4: Result := '(' + Trans('V-Resize');
      5: Result := '(' + Trans('V-Spread');
    end; { case }
    Result := Result + {Trans-}' / ';
    Case GetOrdValue(0) mod 16 of
      0: Result := Result + Trans('Left') + ')';
      1: Result := Result + Trans('Right') + ')';
      2: Result := Result + Trans('H-Center') + ')';
      3: Result := Result + Trans('H-Stretch') + ')';
      4: Result := Result + Trans('H-Resize') + ')';
      5: Result := Result + Trans('H-Spread') + ')';
    end; { case }
  end;  { GetValue }

  procedure TRaveAnchorPropertyEditor.Edit;

  begin { Edit }
    With TAnchorEditor.Create(Application) do try
      Anchor := GetOrdValue(0);
      If ShowModal = mrOK then begin
        SetOrdValue(Anchor);
      end; { if }
    finally
      Free;
    end; { with }
  end;  { Edit }

(*****************************************************************************}
( class TAnchorEditor
(*****************************************************************************)

  procedure TAnchorEditor.FormCreate(Sender: TObject);

  begin
    FormTrans(self);
    PrepareToolWin(self);
  end;

  procedure TAnchorEditor.FormDestroy(Sender: TObject);

  begin
    SaveToolWin(self);
  end;

  procedure TAnchorEditor.FormShow(Sender: TObject);

  begin
    RestoreToolWin(self);
    VertRG.ItemIndex := Anchor div 16;
    VertRGClick(VertRG);
    HorizRG.ItemIndex := Anchor mod 16;
    HorizRGClick(HorizRG);
  end;

  procedure TAnchorEditor.OKBtnClick(Sender: TObject);

  begin
    Anchor := VertRG.ItemIndex * 16 + HorizRG.ItemIndex;
  end;

  procedure TAnchorEditor.VertRGClick(Sender: TObject);

  begin
    Case VertRG.ItemIndex of
      0: ImageV1.BringToFront;
      1: ImageV2.BringToFront;
      2: ImageV3.BringToFront;
      3: ImageV4.BringToFront;
      4: ImageV5.BringToFront;
      5: ImageV6.BringToFront;
    end; { case }
  end;

  procedure TAnchorEditor.HorizRGClick(Sender: TObject);

  begin
    Case HorizRG.ItemIndex of
      0: ImageH1.BringToFront;
      1: ImageH2.BringToFront;
      2: ImageH3.BringToFront;
      3: ImageH4.BringToFront;
      4: ImageH5.BringToFront;
      5: ImageH6.BringToFront;
    end; { case }
  end;

initialization
  RegisterProc('RVCL',RaveRegister);
end.
