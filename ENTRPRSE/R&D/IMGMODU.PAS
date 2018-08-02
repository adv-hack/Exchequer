unit ImgModu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList;

type
  TImageRepos = class(TDataModule)
    ilTBar24Bit: TImageList;
    ilTBar24BitHot: TImageList;
    ilTBar16Col: TImageList;
    MulCtrlImages: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ImageRepos: TImageRepos;

implementation

{$R *.DFM}

Initialization

  ImageRepos := TImageRepos.Create(nil);

Finalization

  FreeAndNil(ImageRepos);

end.
