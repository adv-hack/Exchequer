{-----------------------------------------------------------------------------}
{ Descendants of Delphi's TDirectoryListBox and TDriveComboBox components     }
{ with Windows 95 style pictures                                              }
{ Copyright 1997, Stefan Schultze. All Rights reserved.                       }
{ This components can be freely used and distributed in commercial and private}
{ environments, provided this notice is not modified in any way and there is  }
{ no charge for it other than nomial handling fees. Contact me directly for   }
{ modifications to this agreement.                                            }
{-----------------------------------------------------------------------------}
{ My address: Stefan Schultze                                                 }
{             Rheinstraﬂe 148                                                 }
{             41749 Viersen                                                   }
{                                                                             }
{             Germany                   ( eMail address changes very often )  }
{-----------------------------------------------------------------------------}
{ Date last modified:  27/4/97                                                }
{-----------------------------------------------------------------------------}

unit FilCtl95;

interface

{$Warn Unit_Platform Off}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl;

type
  TDirectory95ListBox = class(TDirectoryListBox)
  protected
    procedure ReadBitmaps; override;
  end;

  TDrive95ComboBox = class(TDriveComboBox)
  public
    constructor Create(AOwner: TComponent); override;
  end;

procedure Register;

implementation

{$R FILCTL95.RES}

procedure TDirectory95ListBox.ReadBitmaps;
begin
  OpenedBMP := {TFolderBitmap}TBitmap.Create;
  OpenedBMP.Handle := LoadBitmap(HInstance, 'OPENFOLDER_95');
  ClosedBMP := {TFolderBitmap}TBitmap.Create;
  ClosedBMP.Handle := LoadBitmap(HInstance, 'CLOSEDFOLDER_95');
  CurrentBMP := {TFolderBitmap}TBitmap.Create;
  CurrentBMP.Handle := LoadBitmap(HInstance, 'CURRENTFOLDER_95');
end;

constructor TDrive95ComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FloppyBMP.Free;
  FloppyBMP := TBitmap.Create;
  FloppyBMP.Handle := LoadBitmap(HInstance, 'FLOPPY_95');

  FixedBMP.Free;
  FixedBMP := TBitmap.Create;
  FixedBMP.Handle := LoadBitmap(HInstance, 'FIXED_95');

  NetworkBMP.Free;
  NetworkBMP := TBitmap.Create;
  NetworkBMP.Handle := LoadBitmap(HInstance, 'NETWORK_95');

  CDROMBMP.Free;
  CDROMBMP := TBitmap.Create;
  CDROMBMP.Handle := LoadBitmap(HInstance, 'CDROM_95');

  RAMBMP.Free;
  RAMBMP := TBitmap.Create;
  RAMBMP.Handle := LoadBitmap(HInstance, 'FLOPPY_95');

  Perform(CM_FONTCHANGED, 0, 0);
end;

procedure Register;
begin
  RegisterComponents('System', [TDirectory95ListBox, TDrive95ComboBox]);
end;

end.
