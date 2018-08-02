
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TfrmRVDesign: form for design-time component    }
{       editor for TRichView.                           }
{       This unit must not be used by applications      }
{       themselves.                                     }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVDsgn;

interface

{$INCLUDE RV_Defs.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, RVScroll, RichView, RVStyle, Registry;

type
  TfrmRVDesign = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    pc: TPageControl;
    tsStyles: TTabSheet;
    Label1: TLabel;
    rg: TRadioGroup;
    lv: TListView;
    TabSheet1: TTabSheet;
    cbStylesDefault: TCheckBox;
    cbTagsDefault: TCheckBox;
    rgTag: TRadioGroup;
    Label2: TLabel;
    Image1: TImage;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    cbRVFSaveBackground: TCheckBox;
    cbRVFSaveLayout: TCheckBox;
    GroupBox2: TGroupBox;
    cbRVFDefault: TCheckBox;
    Image2: TImage;
    Label3: TLabel;
    cbRVFSaveDocProperties: TCheckBox;
    GroupBox3: TGroupBox;
    cbRVFIgnoreUnknownPictures: TCheckBox;
    cbRVFIgnoreUnknownControls: TCheckBox;
    cbRVFInvStyles: TCheckBox;
    cbRVFInvImageIndices: TCheckBox;
    cbRVFIgnoreUnknownCtrlProps: TCheckBox;
    Label4: TLabel;
    cbRVFLoadBackground: TCheckBox;
    Label5: TLabel;
    cbRVFLoadLayout: TCheckBox;
    Label6: TLabel;
    cbRVFLoadDocProperties: TCheckBox;
    cbRVFBinary: TCheckBox;
    cbRVFSavePictures: TCheckBox;
    cbRVFSaveControls: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure rgClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  protected
    rv: TCustomRichView;
    Initialized: Boolean;
    procedure SaveReg;    
  public
    { Public declarations }
    procedure SetRichView(rv: TCustomRichView);
  end;

implementation

{$R *.DFM}
const
 PropertyCount = 6;
 PropertyNames: array [0..PropertyCount-1] of String =
 ('RVFTextStylesReadMode',
  'RVFParaStylesReadMode',
  'RVFOptions',
  'RVFOptions',
  'RTFReadProperties.TextStyleMode',
  'RTFReadProperties.ParaStyleMode');

 PropertyValues: array [0..PropertyCount-1, Boolean] of String =
 (('rvf_sInsertMap', 'rvf_sInsertMerge'),
  ('rvf_sInsertMap', 'rvf_sInsertMerge'),
  ('-[rvfoSaveTextStyles]', '+[rvfoSaveTextStyles]'),
  ('-[rvfoSaveParaStyles]', '+[rvfoSaveParaStyles]'),
  ('rvrsUseClosest', 'rvrsAddIfNeeded'),
  ('rvrsUseClosest', 'rvrsAddIfNeeded'));

  RVFReaderStyleModes: array [TRVFReaderStyleMode] of String =
    ('rvf_sIgnore', 'rvf_sInsertMap', 'rvf_sInsertMerge');
  RVReaderStyleModes: array [TRVReaderStyleMode] of String =
    ('rvrsUseSpecified', 'rvrsUseClosest', 'rvrsAddIfNeeded');


procedure TfrmRVDesign.FormActivate(Sender: TObject);
var i: Integer;
begin
  if Initialized then
    exit;
  lv.Columns.Clear;
  with lv.Columns.Add do begin
    Caption := 'Property';
    Width   := 180;
  end;
  with lv.Columns.Add do begin
    Caption := 'Old Value';
    Width   := 120;
  end;
  with lv.Columns.Add do begin
    Caption := 'New Value';
    Width   := 120;
  end;

  lv.Items.Clear;
  for i := 0 to PropertyCount-1 do
    lv.Items.Add.Caption := PropertyNames[i];

  lv.Items[0].SubItems.Add(RVFReaderStyleModes[rv.RVFTextStylesReadMode]);
  lv.Items[1].SubItems.Add(RVFReaderStyleModes[rv.RVFParaStylesReadMode]);
  lv.Items[2].SubItems.Add(PropertyValues[2, rvfoSaveTextStyles in rv.RVFOptions]);
  lv.Items[3].SubItems.Add(PropertyValues[3, rvfoSaveParaStyles in rv.RVFOptions]);
  lv.Items[4].SubItems.Add(RVReaderStyleModes[rv.RTFReadProperties.TextStyleMode]);
  lv.Items[5].SubItems.Add(RVReaderStyleModes[rv.RTFReadProperties.ParaStyleMode]);

  for i := 0 to PropertyCount-1 do
    lv.Items[i].SubItems.Add('');

  if (rv.RVFTextStylesReadMode=rvf_sInsertMap) and
     (rv.RVFParaStylesReadMode=rvf_sInsertMap) and
     not (rvfoSaveTextStyles in rv.RVFOptions) and
     not (rvfoSaveParaStyles in rv.RVFOptions) and
     (rv.RTFReadProperties.TextStyleMode=rvrsUseClosest) and
     (rv.RTFReadProperties.ParaStyleMode=rvrsUseClosest) then
    rg.ItemIndex := 0
  else if (rv.RVFTextStylesReadMode=rvf_sInsertMerge) and
     (rv.RVFParaStylesReadMode=rvf_sInsertMerge) and
     (rvfoSaveTextStyles in rv.RVFOptions) and
     (rvfoSaveParaStyles in rv.RVFOptions) and
     (rv.RTFReadProperties.TextStyleMode=rvrsAddIfNeeded) and
     (rv.RTFReadProperties.ParaStyleMode=rvrsAddIfNeeded) then
     rg.ItemIndex := 1;
  if rvoTagsArePChars in rv.Options then
    rgTag.ItemIndex := 1
  else
    rgTag.ItemIndex := 0;
  //btnOk.Enabled := rg.ItemIndex>=0;

  cbRVFSaveBackground.Checked := rvfoSaveBack         in rv.RVFOptions;
  cbRVFSaveLayout.Checked     := rvfoSaveLayout       in rv.RVFOptions;
  cbRVFBinary.Checked         := rvfoSaveBinary       in rv.RVFOptions;
  cbRVFSavePictures.Checked   := rvfoSavePicturesBody in rv.RVFOptions;
  cbRVFSaveControls.Checked   := rvfoSaveControlsBody in rv.RVFOptions;
  cbRVFLoadBackground.Checked := rvfoLoadBack         in rv.RVFOptions;
  cbRVFLoadLayout.Checked     := rvfoLoadLayout       in rv.RVFOptions;
  cbRVFIgnoreUnknownPictures.Checked := rvfoIgnoreUnknownPicFmt in rv.RVFOptions;
  cbRVFIgnoreUnknownControls.Checked := rvfoIgnoreUnknownCtrls  in rv.RVFOptions;
  cbRVFIgnoreUnknownCtrlProps.Checked := rvfoIgnoreUnknownCtrlProperties in rv.RVFOptions;
  cbRVFInvStyles.Checked      := rvfoConvUnknownStylesToZero    in rv.RVFOptions;
  cbRVFInvImageIndices.Checked := rvfoConvLargeImageIdxToZero   in rv.RVFOptions;
  cbRVFSaveDocProperties.Checked := rvfoSaveDocProperties       in rv.RVFOptions;
  cbRVFLoadDocProperties.Checked := rvfoLoadDocProperties       in rv.RVFOptions;
  Windows.SetFocus(rg.Handle);
  cbStylesDefault.Enabled := rg.ItemIndex>=0;
  Initialized := True;
end;
{------------------------------------------------------------------------------}
procedure TfrmRVDesign.SetRichView(rv: TCustomRichView);
begin
  Self.rv := rv;
end;
{------------------------------------------------------------------------------}
procedure TfrmRVDesign.rgClick(Sender: TObject);
var i: Integer;
begin
  if not Visible or (rg.ItemIndex<0) then
    exit;
  for i := 0 to PropertyCount-1 do
    lv.Items[i].SubItems[1] := PropertyValues[i,rg.ItemIndex>0];
  btnOk.Enabled := True;
  cbStylesDefault.Enabled := rg.ItemIndex>=0;  
end;
{------------------------------------------------------------------------------}
procedure TfrmRVDesign.btnOkClick(Sender: TObject);

  procedure SetRVFOption(Value: Boolean; Option: TRVFOption);
  begin
    if Value then
      rv.RVFOptions := rv.RVFOptions + [Option]
    else
      rv.RVFOptions := rv.RVFOptions - [Option];
  end;

begin
  case rg.ItemIndex of
    0:
      begin
        rv.RVFTextStylesReadMode := rvf_sInsertMap;
        rv.RVFParaStylesReadMode := rvf_sInsertMap;
        rv.RVFOptions := rv.RVFOptions-[rvfoSaveTextStyles, rvfoSaveParaStyles];
        rv.RTFReadProperties.TextStyleMode := rvrsUseClosest;
        rv.RTFReadProperties.ParaStyleMode := rvrsUseClosest;
      end;
    1:
      begin
        rv.RVFTextStylesReadMode := rvf_sInsertMerge;
        rv.RVFParaStylesReadMode := rvf_sInsertMerge;
        rv.RVFOptions := rv.RVFOptions+[rvfoSaveTextStyles, rvfoSaveParaStyles];
        rv.RTFReadProperties.TextStyleMode := rvrsAddIfNeeded;
        rv.RTFReadProperties.ParaStyleMode := rvrsAddIfNeeded;
      end;
  end;
  case rgTag.ItemIndex of
    0:
    begin
      rv.Options := rv.Options-[rvoTagsArePChars];
    end;
    1:
    begin
      rv.Options := rv.Options+[rvoTagsArePChars];
    end;
  end;
  SetRVFOption(cbRVFSaveBackground.Checked, rvfoSaveBack);
  SetRVFOption(cbRVFSaveLayout.Checked,     rvfoSaveLayout);
  SetRVFOption(cbRVFBinary.Checked,         rvfoSaveBinary);
  SetRVFOption(cbRVFSavePictures.Checked,   rvfoSavePicturesBody);
  SetRVFOption(cbRVFSaveControls.Checked,   rvfoSaveControlsBody);
  SetRVFOption(cbRVFLoadBackground.Checked, rvfoLoadBack);
  SetRVFOption(cbRVFLoadLayout.Checked,     rvfoLoadLayout);
  SetRVFOption(cbRVFIgnoreUnknownPictures.Checked, rvfoIgnoreUnknownPicFmt);
  SetRVFOption(cbRVFIgnoreUnknownControls.Checked, rvfoIgnoreUnknownCtrls);
  SetRVFOption(cbRVFIgnoreUnknownCtrlProps.Checked,     rvfoIgnoreUnknownCtrlProperties);  
  SetRVFOption(cbRVFInvStyles.Checked,             rvfoConvUnknownStylesToZero);
  SetRVFOption(cbRVFInvImageIndices.Checked,       rvfoConvLargeImageIdxToZero);
  SetRVFOption(cbRVFSaveDocProperties.Checked,     rvfoSaveDocProperties);
  SetRVFOption(cbRVFLoadDocProperties.Checked,     rvfoLoadDocProperties);
  SaveReg;
end;


procedure TfrmRVDesign.SaveReg;
var reg: TRegistry;
begin
  if not (cbStylesDefault.Checked or cbTagsDefault.Checked or cbRVFDefault.Checked) then
    exit;
  reg := TRegistry.Create;
  try
    if reg.OpenKey('Software\TRichView', True) then begin
      if cbStylesDefault.Checked then
        reg.WriteInteger('Styles', rg.ItemIndex);
      if cbTagsDefault.Checked then
        reg.WriteInteger('Tags', rg.ItemIndex);
      if cbRVFDefault.Checked then begin
        reg.WriteBool('rvf01',  cbRVFSaveBackground.Checked);
        reg.WriteBool('rvf02',  cbRVFSaveLayout.Checked);
        reg.WriteBool('rvf03',  cbRVFBinary.Checked);
        reg.WriteBool('rvf04',  cbRVFSavePictures.Checked);
        reg.WriteBool('rvf05',  cbRVFSaveControls.Checked);
        reg.WriteBool('rvf06',  cbRVFLoadBackground.Checked);
        reg.WriteBool('rvf07',  cbRVFLoadLayout.Checked);
        reg.WriteBool('rvf08',  cbRVFIgnoreUnknownPictures.Checked);
        reg.WriteBool('rvf09',  cbRVFIgnoreUnknownControls.Checked);
        reg.WriteBool('rvf10',  cbRVFInvStyles.Checked);
        reg.WriteBool('rvf11',  cbRVFInvImageIndices.Checked);
        reg.WriteBool('rvf12',  cbRVFSaveDocProperties.Checked);
        reg.WriteBool('rvf13',  cbRVFLoadDocProperties.Checked);
        reg.WriteBool('rvf14',  cbRVFIgnoreUnknownCtrlProps.Checked);
      end;
    end;
  finally
    reg.Free;
  end;
end;

end.
