unit About1;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TentPreviewXAbout = class(TForm)
    CtlImage: TSpeedButton;
    NameLbl: TLabel;
    OkBtn: TButton;
    CopyrightLbl: TLabel;
    DescLbl: TLabel;
    Label1: TLabel;
  end;

procedure ShowentPreviewXAbout;

implementation

{$R *.DFM}

procedure ShowentPreviewXAbout;
begin
  with TentPreviewXAbout.Create(nil) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

end.
