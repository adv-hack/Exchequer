unit CompWiz2;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, StdCtrls, Mask, TEditVal, ExtCtrls;

type
  TCompDetail2 = class(TSetupTemplate)
    cpAddr1: Text8Pt;
    cpAddr2: Text8Pt;
    cpAddr3: Text8Pt;
    cpAddr4: Text8Pt;
    cpAddr5: Text8Pt;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
