unit PIAbFram;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, oTrade, ExtCtrls;

type
  TPlugInAboutFrame = class(TFrame)
    lblPlugInName: TLabel;
    lblClassName: TLabel;
    btnPlugInConfiguration: TButton;
    bvTopBevel: TBevel;
    bvBottomBevel: TBevel;
    procedure btnPlugInConfigurationClick(Sender: TObject);
  private
    { Private declarations }
    lPlugIn  : TTradeConnectionPoint;
  public
    { Public declarations }
    Procedure SetDets (Const Idx : Integer; const PlugIn: TTradeConnectionPoint);
  end;

implementation

{$R *.dfm}

//---------------------------------------------------------------------------

procedure TPlugInAboutFrame.SetDets(Const Idx : Integer; const PlugIn: TTradeConnectionPoint);
begin
  // Take Local Reference for possible future use
  lPlugIn := PlugIn;

  // Only display Top Bevel on first Plug-In otherwise they will double-up
  bvTopBevel.Visible := (Idx = 1);

  // Check to see if the Configure button is required by the Plug-In
  btnPlugInConfiguration.Visible := (Pos('CONFIG', UpperCase(lPlugIn.piCustomisationSupport)) > 0);

  // Setup Plug-In Details
  With lPlugIn Do Begin
    lblPlugInName.Caption := piName;
    lblClassName.Caption := piClassName;

(*  Plug-In properties on lPlugIn object
  Property piClassName : ShortString Read FClassName;
  Property piName : ShortString Read FPlugInName;
  Property piVersion : ShortString Read FPlugInVersion;
  Property piAuthor : ShortString Read FPlugInAuthor;
  Property piSupportMsg : ShortString Read FPlugInSupportMsg;
  Property piCopyright : ShortString Read FPlugInCopyright;
  Property piCustomisationSupport : ShortString Read FCustomisationSupport;
*)
  End; { With lPlugIn }
end;

//---------------------------------------------------------------------------

procedure TPlugInAboutFrame.btnPlugInConfigurationClick(Sender: TObject);
begin
  lPlugIn.Configure (Self.Handle);
end;

end.
