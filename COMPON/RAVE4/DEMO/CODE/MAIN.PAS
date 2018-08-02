unit Main;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, TabNotBk, Buttons, StdCtrls, ExtCtrls, DB, DBTables,
  RPSystem, Demo01, Demo02, Demo03, Demo04, Demo05, Demo06, Demo07, Demo08,
  RTFDemo, ComCtrls;

type
  TMainForm = class(TForm)
    TabbedNotebook1: TTabbedNotebook;
    Timer1: TTimer;

    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;

    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;

    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo6: TMemo;
    Memo7: TMemo;
    Memo8: TMemo;
    Memo9: TMemo;
    Memo10: TMemo;
    Memo11: TMemo;
    Memo12: TMemo;

    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;

    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;

    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    ListBox5: TListBox;
    ListBox6: TListBox;
    ListBox7: TListBox;
    ListBox8: TListBox;
    ListBox9: TListBox;
    ListBox10: TListBox;
    ListBox11: TListBox;
    ListBox12: TListBox;
    ListBox13: TListBox;
    ListBox14: TListBox;
    ListBox15: TListBox;
    ListBox16: TListBox;
    ListBox17: TListBox;
    ListBox18: TListBox;

    procedure ListBox18Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
     var AllowChange: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    XInc: shortint;
    YInc: shortint;
  public
    procedure HideAll;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.HideAll;

begin
  ListBox1.Hide;
  ListBox2.Hide;
  ListBox3.Hide;
  ListBox4.Hide;
  ListBox5.Hide;
  ListBox6.Hide;
  ListBox7.Hide;
  ListBox8.Hide;
  ListBox9.Hide;
  ListBox10.Hide;
  ListBox11.Hide;
  ListBox12.Hide;
  ListBox13.Hide;
  ListBox14.Hide;
  ListBox15.Hide;
  ListBox16.Hide;
  ListBox17.Hide;
end;

procedure TMainForm.ListBox18Click(Sender: TObject);
begin
  HideAll;
  Case (Sender as TListBox).ItemIndex of
    0: ListBox1.Show;
    1: ListBox2.Show;
    2: ListBox3.Show;
    3: ListBox4.Show;
    4: ListBox5.Show;
    5: ListBox6.Show;
    6: ListBox7.Show;
    7: ListBox8.Show;
    8: ListBox9.Show;
    9: ListBox10.Show;
    10: ListBox11.Show;
    11: ListBox12.Show;
    12: ListBox13.Show;
    13: ListBox14.Show;
    14: ListBox15.Show;
    15: ListBox16.Show;
    16: ListBox17.Show;
  end; { case }
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  ListBox18.ItemIndex := 0;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
{ Increse font size }
  If Label32.Font.Size = 36 then begin
    Label32.Font.Size := 6;
  end else begin
    Label32.Font.Size := Label32.Font.Size + 1;
  end; { else }

{ Move bitmaps around }
  If (Image4.Left = 2) and (Image4.Top = 2) then begin
    XInc := 2;
    YInc := 0;
  end else if (Image4.Left = 416) and (Image4.Top = 2) then begin
    XInc := 0;
    YInc := 2;
  end else if (Image4.Left = 416) and (Image4.Top = 32) then begin
    XInc := -2;
    YInc := 0;
  end else if (Image4.Left = 2) and (Image4.Top = 32) then begin
    XInc := 0;
    YInc := -2;
  end; { else }
  Image4.Left := Image4.Left + XInc;
  Image4.Top := Image4.Top + YInc;
  Image5.Left := Image5.Left - XInc;
  Image5.Top := Image5.Top - YInc;
end;

procedure TMainForm.TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  Timer1.Enabled := NewTab = 11;
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
  TabbedNotebook1.PageIndex := 0;
end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
begin
  TabbedNotebook1.PageIndex := TabbedNotebook1.PageIndex - 1;
end;

procedure TMainForm.SpeedButton3Click(Sender: TObject);
begin
  TabbedNotebook1.PageIndex := TabbedNotebook1.PageIndex + 1;
end;

procedure TMainForm.SpeedButton4Click(Sender: TObject);
begin
  TabbedNotebook1.PageIndex := 11;
end;

procedure TMainForm.SpeedButton5Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  With TDemo01Form.Create(self) do try
    ReportSystem1.Execute;
  finally
    Free;
  end; { with }
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  With TDemo02Form.Create(self) do try
    ReportSystem1.Execute;
  finally
    Free;
  end; { with }
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
  With TDemo03Form.Create(self) do try
    ReportSystem1.Execute;
  finally
    Free;
  end; { with }
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  With TDemo04Form.Create(self) do try
    ReportSystem1.Execute;
  finally
    Free;
  end; { with }
end;

procedure TMainForm.Button5Click(Sender: TObject);
begin
  With TDemo05Form.Create(self) do try
    ReportSystem1.Execute;
  finally
    Free;
  end; { with }
end;

procedure TMainForm.Button6Click(Sender: TObject);
begin
  With TDemo06Form.Create(self) do try
    ReportSystem1.Execute;
  finally
    Free;
  end; { with }
end;

procedure TMainForm.Button7Click(Sender: TObject);
begin
  With TDemo07Form.Create(self) do try
    ReportSystem1.Execute;
  finally
    Free;
  end; { with }
end;

procedure TMainForm.Button8Click(Sender: TObject);
begin
  With TDemo08Form.Create(self) do try
    ReportSystem1.Execute;
  finally
    Free;
  end; { with }
end;

procedure TMainForm.Button9Click(Sender: TObject);
begin
  With TRTFDemoForm.Create(self) do try
    ReportSystem1.Execute;
  finally
    Free;
  end; { with }
end;

end.
