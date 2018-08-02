//
//
//  NOTE:  This module is a copy of the standard ColCtrlU with the
//  following modifications:-
//
//    1)  A handler has been added for WMWindowPosChanged
//
//    2)  The FormStyle has been changes to fsStayOnTop
//

unit colctrlu;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  SBSPanel, StdCtrls, ExtCtrls, ComCtrls, Menus;

type
  TColourCtrl = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    SBSPanel1: TSBSPanel;
    Panel2: TPanel;
    Label2: TLabel;
    Button3: TButton;
    Button4: TButton;
    SBSPanel2: TSBSPanel;
    Panel3: TPanel;
    Label3: TLabel;
    Button5: TButton;
    SBSPanel3: TSBSPanel;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    PropOkBtn: TButton;
    PropCanBtn: TButton;
    Button6: TButton;
    PropDefaultBtn: TButton;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure PropOkBtnClick(Sender: TObject);
  private
    { Private declarations }

    PrevHState   :  Boolean;

    NewFont      :  Array[1..3] of TFont;
    NewColour    :  Array[1..3] of TColor;
    TestCaption  :  String;

    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;
  public
    { Public declarations }

    ResetDefaults,
    ApplyOk  :  Boolean;

    Procedure UpdateDisplay;

  end;


  TCtrlColor = class(TWinControl)

    PropForm   :  TColourCtrl;

  private
    Constructor Create(AOwner  : TComponent);

    Destructor Destroy; override;



  public
    { Public declarations }

Procedure SetProperties(Var SetPanel1,
                            SetPanel2,
                            SetPanel3    :  TPanel;
                            Mode         :  Byte;
                            Prompt       :  String;
                        Var BeenChange,
                            RDefaults    :  Boolean);


  end;

{Const
    gfsr_SystemResources  = $0000;


function GetFreeSystemResources(SysResource: Integer): Integer; StdCall;}



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  BTSupU1;

{$R *.DFM}


{function GetFreeSystemResources;           external 'USER32'     index 284;}

{function GetFreeSystemResources(SysResource: Integer): Integer;  Far; StdCall;
                                           external 'Q:\WINDOWS\SYSTEM\RSRC32' name '_MyGetFreeSystemResources32@4';}

Procedure TColourCtrl.UpdateDisplay;
Begin

  With SBSPanel1 do
  Begin
    Color:=NewColour[1];
    Font:=NewFont[1];
  end;

  With SBSPanel2 do
  Begin
    Color:=NewColour[2];
    Font:=NewFont[2];
  end;

  With SBSPanel3 do
  Begin
    Color:=NewColour[3];
    Font:=NewFont[3];
  end;
end;


procedure TColourCtrl.Button1Click(Sender: TObject);
begin
  If (Sender is TButton) then
    With (Sender as TButton) do
    Begin
      {If (Tag<>2) then
        ColorDialog1.Options:=[cdSolidColor];}

      ColorDialog1.Color:=NewColour[Tag];

      If (ColorDialog1.Execute) then
      Begin
        NewColour[Tag]:=ColorDialog1.Color;

        UpdateDisplay;
      end;
    end;
end;

procedure TColourCtrl.Button2Click(Sender: TObject);

Var
  TagValue  :  LongInt;

begin
  TagValue:=(Sender as TButton).Tag;

  FontDialog1.Device:=fdScreen;

  FontDialog1.Font.Assign(NewFont[TagValue]);

  If (FontDialog1.Execute) then
  Begin
    NewFont[TagValue].Assign(FontDialog1.Font);

    UpDateDisplay;
  end;
end;

procedure TColourCtrl.PropOkBtnClick(Sender: TObject);
begin
  ApplyOk:=(Sender=PropOkBtn);
  ResetDefaults:=(Sender=PropDefaultBtn);
  Close;
end;


Constructor TCtrlColor.Create(AOwner  :  TComponent);


Begin
  Inherited;

end;

Destructor TCtrlColor.Destroy;


Begin

  Inherited;

end;

Procedure TCtrlColor.SetProperties(Var SetPanel1,
                                       SetPanel2,
                                       SetPanel3    :  TPanel;
                                       Mode         :  Byte;
                                       Prompt       :  String;
                                   Var BeenChange,
                                       RDefaults    :  Boolean);

Begin

  PropForm:=TColourCtrl.Create(Owner);

  try

    With PropForm do
    Begin
      Caption:=Prompt;

      NewFont[1]:=SetPanel1.Font;
      NewColour[1]:=SetPanel1.Color;

      NewFont[2]:=SetPanel2.Font;
      NewColour[2]:=SetPanel2.Color;

      NewFont[3]:=SetPanel3.Font;

      NewColour[3]:=SetPanel3.Color;

      UpdateDisplay;

      Panel3.Enabled:=(Mode<>0);
      Button5.Enabled:=(Mode<>0);
      Button6.Enabled:=(Mode<>0);

      SetAllowHotKey(False,PrevHState);

      ShowModal;

      SetAllowHotKey(True,PrevHState);
      
      If (ApplyOk) then
      Begin
        SetPanel1.Font:=NewFont[1];
        SetPanel1.Color:=NewColour[1];

        SetPanel2.Font:=NewFont[2];
        SetPanel2.Color:=NewColour[2];

        SetPanel3.Font:=NewFont[3];
        SetPanel3.Color:=NewColour[3];
      end;

      BeenChange:=(ApplyOk and (Not ResetDefaults));
      RDefaults:=ResetDefaults;

    end; {With..}

  finally

    PropForm.Free;

  end;
end;


// IMPORTANT NOTE: This message handler is required to ensure the form stays
// on top, as it has a habit of losing its Stay-On-Top'ness at runtime.
procedure TColourCtrl.WMWindowPosChanged(var Msg : TMessage);
Begin
  // Do standard message processing
  Inherited;

  // Restore TopMost back to window
  //SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE)
End;


end.
