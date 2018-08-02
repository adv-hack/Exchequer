{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVPEImg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ExtDlgs, RVClass, RVCsStd, RPDefine;

type
  TImageEditor = class(TForm)
    Panel1: TPanel;
    RtBtnPanel: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    BgPanel: TPanel;
    LoadBtn: TBitBtn;
    ClearBtn: TBitBtn;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DispImage: TImage;
    OpenPictureDlg: TOpenPictureDialog;
    Panel2: TPanel;
    bbtnSaveAs: TBitBtn;
    sdlgSaveAs: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bbtnSaveAsClick(Sender: TObject);
  private
    { Private declarations }
    FGraphic: TGraphic;
    FImgInst: TRaveGraphicImage;
    procedure SetGraphic(Value: TGraphic);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Image: TGraphic read FGraphic write SetGraphic;
    property ImgInst: TRaveGraphicImage read FImgInst write FImgInst;
  end;

  procedure RaveRegister;

var
  ImageEditor: TImageEditor;

implementation

uses
  RVUtil, RVTool;

{$R *.DFM}

type
  TRaveTextPropertyEditor = class(TRaveStringPropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
  end; { TRaveTextPropertyEditor }

  TRaveGraphicPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    procedure Edit; override;
    function GetValue: string; override;
  end; { TRaveGraphicPropertyEditor }

  TRaveFileNamePropertyEditor = class(TRaveStringPropertyEditor)
  protected
    FFileName: TFileName;
    function GetOptions: TPropertyOptionsSet; override;
    procedure Edit; override;
    procedure SetDlgParams(var Title, Filter: string); virtual;
    function GetFileDialog: TOpenDialog; virtual;
  end; { TRaveFileNamePropertyEditor }

  TRaveFileLinkPropertyEditor = class(TRaveFileNamePropertyEditor)
  protected
    procedure SetDlgParams(var Title, Filter: string); override;
    function GetFileDialog: TOpenDialog; override;
  end; { TRaveFileLinkPropertyEditor }

  TRaveBaseImageAccess = class(TRaveBaseImage)
  end; { TRaveBaseImageAccess }

  TRaveGraphicImageAccess = class(TRaveGraphicImage)
  end; { TRaveGraphicImageAccess }

  procedure RaveRegister;

  begin { RaveRegister }
  {TransOff}
    RegisterRavePropertyEditor(TypeInfo(string),TRaveText,'Text',
     TRaveTextPropertyEditor);

    RegisterRavePropertyEditor(TypeInfo(TGraphic),TRaveGraphicImage,'Image',
     TRaveGraphicPropertyEditor);

    RegisterRavePropertyEditor(TypeInfo(TFileName),nil,'',
     TRaveFileNamePropertyEditor);

    RegisterRavePropertyEditor(TypeInfo(TFileName),TRaveBaseImage,'FileLink',
     TRaveFileLinkPropertyEditor);
  {TransOn}
  end;  { RaveRegister }

(*****************************************************************************}
( class TRaveTextPropertyEditor
(*****************************************************************************)

  function TRaveTextPropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := inherited GetOptions;
    Result := Result + [poLiveUpdate];
  end;  { GetOptions }

(*****************************************************************************}
( class TRaveGraphicPropertyEditor
(*****************************************************************************)

  function TRaveGraphicPropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poReadOnly,poEditor,poMultiSelect];
  end;  { GetOptions }

  function TRaveGraphicPropertyEditor.GetValue: string;

  begin { GetValue }
    If TRaveBaseImageAccess(Instance[0]).ImageValid then begin
      Result := '(' + (Instance[0] as TRaveBaseImage).ImageName + ')';
    end else begin
      Result := '';
    end; { else }
  end;  { GetValue }

  procedure TRaveGraphicPropertyEditor.Edit;

  var
    I1: integer;
    ImgEditor: TImageEditor;

  begin { Edit }
    ImgEditor := TImageEditor.Create(nil);
    With ImgEditor do try
      ImgInst := Instance[0] as TRaveGraphicImage;
      Image := TGraphic(GetOrdValue(0));
      If ShowModal = mrOk then begin
        For I1 := 0 to InstCount - 1 do begin
          If not Assigned(Image) or Image.Empty then begin
            TRaveGraphicImage(Instance[I1]).Image := nil;
          end else begin
            TRaveGraphicImage(Instance[I1]).Image := Image;
          end; { else }
          If Instance[I1] is TRaveControl then begin
           TRaveControl(Instance[I1]).Invalidate;
          end; { if }
        end; { for }
        Modified;
      end; { if }
    finally
      ImgEditor.Free;
    end; { with }
  end;  { Edit }

(*****************************************************************************}
( class TImageEditor
(*****************************************************************************)

  constructor TImageEditor.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
  end;  { Create }

  destructor TImageEditor.Destroy;

  begin { Destroy }
    If Assigned(FGraphic) then begin
      FGraphic.Free;
    end; { if }
    inherited Destroy;
  end;  { Destroy }

  procedure TImageEditor.SetGraphic(Value: TGraphic);

  begin { SetGraphic }
    If not Assigned(Value) or Value.Empty then begin
      BgPanel.Caption := '(' + Trans('None') + ')';
      DispImage.Picture.Assign(nil);
      If Assigned(FGraphic) then begin
        FGraphic.Free;
        FGraphic := nil;
      end; { if }
    end else begin
      BgPanel.Caption := '';
      DispImage.Picture.Assign(Value);
      If not Assigned(FGraphic) then begin
        FGraphic := TRaveGraphicImageAccess(ImgInst).CreateGraphic;
      end; { if }
      FGraphic.Assign(Value);
    end; { else }
  end;  { SetGraphic }

  procedure TImageEditor.FormCreate(Sender: TObject);

  begin { FormCreate }
    FormTrans(self);
    PrepareToolWin(self);
  end;  { FormCreate }

  procedure TImageEditor.FormDestroy(Sender: TObject);

  begin { FormDestroy }
    SaveToolWin(self);
  end;  { FormDestroy }

  procedure TImageEditor.LoadBtnClick(Sender: TObject);

  begin { LoadBtnClick }
    OpenPictureDlg.Title := Trans(Format({Trans+}'Open %s',[ImgInst.ImageName]));
    OpenPictureDlg.Filter := Trans(ImgInst.ImageFilter + '|' + Trans('All Files') +
     {Trans-}' (*.*)|*.*');
    If OpenPictureDlg.Execute then begin
      DispImage.Visible := false;
      If Assigned(FGraphic) then begin
        FGraphic.Free;
      end; { if }
      FGraphic := TRaveGraphicImageAccess(ImgInst).CreateGraphic;
      FGraphic.LoadFromFile(OpenPictureDlg.FileName);
      DispImage.Picture.Assign(FGraphic);
      BgPanel.Caption := '';
      DispImage.Visible := true;
    end; { if }
  end;  { LoadBtnClick }

  procedure TImageEditor.ClearBtnClick(Sender: TObject);

  begin { ClearBtnClick }
    SetGraphic(nil);
    DispImage.Visible := false;
  end;  { ClearBtnClick }

  procedure TImageEditor.FormShow(Sender: TObject);

  begin { FormShow }
    RestoreToolWin(self);
    Caption := Trans(Format({Trans+}'%s Selector',[ImgInst.ImageName]));
  end;  { FormShow }

(*****************************************************************************}
( class TRaveTextPropertyEditor
(*****************************************************************************)

  procedure TRaveFileNamePropertyEditor.Edit;

  var
    OpenDialog: TOpenDialog;

  begin
    OpenDialog := GetFileDialog;
    With OpenDialog do try
      FileName := GetStrValue(0);
      If Execute then begin
        FFileName := OpenDialog.FileName;
        SetStrValue(FFileName);
      end; { if }
    finally
      If Assigned(OpenDialog) then begin
        OpenDialog.Free;
      end; { if }
    end; { with }
  end; { Edit }

  function TRaveFileNamePropertyEditor.GetFileDialog: TOpenDialog;

  var
    Title: string;
    Filter: string;

  begin
    SetDlgParams(Title, Filter);
    Result := TOpenDialog.Create(nil);
    Result.Title := Title;
    Result.Filter := Filter;
  end; { GetFileDialog }

  procedure TRaveFileNamePropertyEditor.SetDlgParams(var Title, Filter: string);

  begin { GetFilter }
    Title := Trans('Open');
    Filter := Trans('All Files') + {Trans-}' (*.*)|*.*';
  end;  { GetFilter }

  function TRaveFileNamePropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poEditor,poMultiSelect];
  end;  { GetOptions }

(*****************************************************************************}
( class TRaveFileLinkPropertyEditor
(*****************************************************************************)

  function TRaveFileLinkPropertyEditor.GetFileDialog: TOpenDialog;

  var
    Title: string;
    Filter: string;

  begin
    SetDlgParams(Title,Filter);
    If Instance[0] is TRaveGraphicImage then begin
      Result := TOpenPictureDialog.Create(nil);
    end else begin
      Result := TOpenDialog.Create(nil);
    end; { else }
    Result.Title := Title;
    Result.Filter := Filter;
  end; { GetFileDialog }

  procedure TRaveFileLinkPropertyEditor.SetDlgParams(var Title,
    Filter: string);

  begin
    With Instance[0] as TRaveBaseImage do begin
      Title := Trans(Format({Trans+}'Open %s',[ImageName]));
      Filter := ImageFilter;
    end; { with }
  end;

  procedure TImageEditor.bbtnSaveAsClick(Sender: TObject);
  begin
    sdlgSaveAs.Title := Trans(Format({Trans+}'Save As %s',[ImgInst.ImageName]));
    sdlgSaveAs.Filter := Trans(ImgInst.ImageFilter + '|' + Trans('All Files') +
     {Trans-}' (*.*)|*.*');
    If sdlgSaveAs.Execute then begin
      FGraphic.SaveToFile(sdlgSaveAs.FileName);
    end; { if }
  end;

initialization
  RegisterProc('RVCL',RaveRegister);
end.
