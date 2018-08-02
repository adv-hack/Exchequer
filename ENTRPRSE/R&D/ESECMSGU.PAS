unit ESecMsgU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, TEditVal, Mask, SBSPanel,  GlobVar;


type
  TESecFrm = class(TForm)
    UserLab: Label8;
    VerF: Label8;
    SecLab: Label8;
    OKBtn: TButton;
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }

    
  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  VarConst,
  ETStrU,
  SysU2,
  BTSupU1,
  BTSupU2;


{$R *.DFM}



procedure TESecFrm.FormCreate(Sender: TObject);
begin
  ClientHeight := 214;
  ClientWidth := 357;

// MH 15/09/08: Removed graphic as we had nothing suitable and it was though advisable to avoid
// slowing the system down further by loading graphics from branding files anyway   
//  Image1.Visible := Not NoXLogo;

  Show;
  Update;
end;


end.
