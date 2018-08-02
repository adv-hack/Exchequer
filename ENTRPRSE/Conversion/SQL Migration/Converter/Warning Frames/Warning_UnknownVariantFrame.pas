unit Warning_UnknownVariantFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Warning_BaseFrame, DataConversionWarnings, StdCtrls;

type
  TTWarningUnknownVariantFrame = class(TWarningBaseFrame)
    Label3: TLabel;
    lblVariant: TLabel;
    Label2: TLabel;
    memHexData: TMemo;
  private
    { Private declarations }
    FWarning : TSQLUnknownVariantWarning;
  public
    { Public declarations }
    Constructor Create(AOwner : TComponent; Const Warning : TSQLUnknownVariantWarning);
  end;

implementation

uses oDataPacket, SQLConvertUtils;

{$R *.dfm}

//=========================================================================

Constructor TTWarningUnknownVariantFrame.Create(AOwner : TComponent; Const Warning : TSQLUnknownVariantWarning);
Begin // Create
  Inherited Create (AOwner, Warning);

  FWarning := Warning;
  lblWarningDescription.Caption := 'Unknown Variant in file ' + FWarning.DataPacket.TaskDetails.dctPervasiveFilename;
  lblVariant.Caption := FWarning.Variant;
  memHexData.Text := ToHexString(FWarning.DataPacket.dpData, FWarning.DataPacket.dpDataSize);
End; // Create

//-------------------------------------------------------------------------


end.
