unit Consnu;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, TEditVal, StdCtrls, Mask, ExtCtrls, Buttons, Tabs;

type
  TCon_Record = class(TForm)
    Shape1: TShape;
    Shape3: TShape;
    GroupBox1: TGroupBox;
    TabSet1: TTabSet;
    Notebook1: TNotebook;
    Label810: Label8;
    Label811: Label8;
    Label812: Label8;
    Label814: Label8;
    Label817: Label8;
    Panel15: TPanel;
    InvCompany: TLabel;
    InvAddr1: TLabel;
    InvAddr2: TLabel;
    InvAddr3: TLabel;
    InvAddr4: TLabel;
    InvOurRef: Text8Pt;
    InvAcCode: Text8Pt;
    InvYRef2: Text8Pt;
    InvDate: TEditDate;
    OrdNote2: TNotebook;
    RecAddBttn: TSpeedButton;
    RecEditBttn: TSpeedButton;
    RecDelBttn: TSpeedButton;
    RecInsBttn: TSpeedButton;
    OrdTab2: TTabSet;
    Panel3: TPanel;
    Label81: Label8;
    Label83: Label8;
    Label84: Label8;
    Label813: Label8;
    Label815: Label8;
    Panel16: TPanel;
    Panel1: TPanel;
    Panel6: TPanel;
    Panel5: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Label85: Label8;
    Panel7: TPanel;
    Panel11: TPanel;
    Label86: Label8;
    Panel10: TPanel;
    InvTotal: Label8;
    ext8Pt1: Text8Pt;
    Bevel4: TBevel;
    OrdSearchAcc: TSpeedButton;
    Bevel1: TBevel;
    SpeedButton1: TSpeedButton;
    Label87: Label8;
    Panel8: TPanel;
    Panel9: TPanel;
    Label82: Label8;
    LineDesc: Label8;
    Label1: TLabel;
    OrdCanBttn: TSpeedButton;
    OrdOkBttn: TSpeedButton;
    Panel12: TPanel;
    Panel13: TPanel;
    Bevel3: TBevel;
    SpeedButton2: TSpeedButton;
    Label89: Label8;
    Label816: Label8;
    Label818: Label8;
    Label819: Label8;
    Label820: Label8;
    Label821: Label8;
    ext8Pt4: Text8Pt;
    EditValue1: TEditValue;
    EditValue2: TEditValue;
    EditValue7: TEditValue;
    EditValue8: TEditValue;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Panel14: TPanel;
    Panel17: TPanel;
    EditValue3: TEditValue;
    EditValue4: TEditValue;
    Label822: Label8;
    Label823: Label8;
    Button2: TButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Bevel2: TBevel;
    LineDescDetl: Label8;
    Label825: Label8;
    CCDesc: TBevel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Con_Record: TCon_Record;

implementation

{$R *.DFM}

end.

