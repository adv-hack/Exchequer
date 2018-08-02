unit PIAboutF;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, oTrade, PIAbFram;

type
  TfrmPlugInList = class(TForm)
    Bevel1: TBevel;
    TitleLbl: TLabel;
    InstrLbl: TLabel;
    imgSide: TImage;
    Panel1: TPanel;
    Image1: TImage;
    btnClose: TButton;
    scrlPlugIns: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    FrameArray  : Array Of TPlugInAboutFrame;
    PlugInCount : Integer;
    NextTop     : Integer;
  public
    { Public declarations }
    Procedure AddPlugIn (Const PlugIn : TTradeConnectionPoint);
  end;

var
  frmPlugInList: TfrmPlugInList;

implementation

{$R *.dfm}

//---------------------------------------------------------------------------

procedure TfrmPlugInList.FormCreate(Sender: TObject);
begin
  PlugInCount := 0;
  NextTop := 1;
end;

//---------------------------------------------------------------------------

// Adds the Plug-In Details into the ScrollBox
procedure TfrmPlugInList.AddPlugIn(const PlugIn: TTradeConnectionPoint);
begin
  Inc (PlugInCount);

  // Create a Frame for the Plug-In Security stuff
  SetLength (FrameArray, PlugInCount);
  FrameArray[Pred(PlugInCount)] := TPlugInAboutFrame.Create (Self);

  With FrameArray[Pred(PlugInCount)] Do Begin
    // Position within the Scroll Box
    Name := Name + IntToStr(PlugInCount);
    Parent := scrlPlugIns;
    Top := NextTop;
    Left := 1;

    // Set the Plug-In Details
    SetDets (PlugInCount, PlugIn);

    // Update position for next frame
    NextTop := NextTop + Height;
  End; { With FrameArray[Pred(PlugInCount)] }
end;

//---------------------------------------------------------------------------

procedure TfrmPlugInList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//---------------------------------------------------------------------------

end.
