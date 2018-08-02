unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Email, Grids, DBGrids, DB, DBTables, StdCtrls, Buttons, ExtCtrls,
  ComCtrls, Menus, DBCtrls, Spin;

type
  TForm1 = class(TForm)
    Email1: TEmail;
    Panel1: TPanel;
    SendfaxButton: TBitBtn;
    Mergedat1: TBitBtn;
    ScrollBox1: TScrollBox;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    Bevel1: TBevel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    MergeSendBt1: TBitBtn;
    Bevel2: TBevel;
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    SpinEdit1: TSpinEdit;
    Label2: TLabel;
    Bevel3: TBevel;
    Label3: TLabel;
    Bevel4: TBevel;
    TabSheet1: TTabSheet;
    RP1: TMemo;
    Table1: TTable;
    DataSource1: TDataSource;
    Table1FAXNUMBER: TStringField;
    Table1NAME: TStringField;
    Table1ADD1: TStringField;
    Table1ADD2: TStringField;
    Table1ADD3: TStringField;
    Table1ADD4: TStringField;
    Table1ADD5: TStringField;
    Table1ADD6: TStringField;
    Table1ADD7: TStringField;
    Table1ADD8: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SendfaxButtonClick(Sender: TObject);
    procedure Mergedat1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure MergeSendBt1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure About1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Fproc : boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  if (Email1.logon <> EMAIL_OK) then
  begin
    MessageDlg('MAPI Logon failed', mtError, [mbAbort],0);
  end;
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  if (Email1.logoff <> EMAIL_OK) then
  begin
    MessageDlg('MAPI Logoff failed', mtError, [mbAbort],0);
  end;
end;

procedure TForm1.SendfaxButtonClick(Sender: TObject);
begin
  {Save Rich Fax Data}
  RP1.lines.savetofile('c:\faxdemo\letter.rp1');

  {Add Fax Number}
  Email1.recipient.clear;
  Email1.recipient.add('[FAX:'+Table1FAXNUMBER.value+']');

  {Send Fax - Mail Attachments is set to c:\faxdemo\letter.rp1}
  if (Email1.sendmail <> email_ok) then
  begin
    Messagedlg('MAPI Send Fax - Failed', mtError, [mbAbort],0);
  end;
end;

procedure TForm1.Mergedat1Click(Sender: TObject);
begin
	 {Create Merge Data File}
  RP1.clear;
  RP1.lines.add(Table1NAME.value);
  RP1.lines.add(Table1FAXNUMBER.value);

  RP1.lines.add(Table1ADD1.value);
  RP1.lines.add(Table1ADD2.value);
  RP1.lines.add(Table1ADD3.value);
  RP1.lines.add(Table1ADD4.value);
  RP1.lines.add(Table1ADD5.value);
  RP1.lines.add(Table1ADD6.value);
  RP1.lines.add(Table1ADD7.value);
  RP1.lines.add(Table1ADD8.value);
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.MergeSendBt1Click(Sender: TObject);
begin
	 {Set Spooler - Merge & Send}
  Fproc := false;
  Timer1.enabled := not timer1.enabled;
  mergedat1.enabled := not timer1.enabled;
  sendfaxbutton.enabled := not timer1.enabled;
  if timer1.enabled = false then
     Statusbar1.panels.items[1].text := 'Spooling OFF '
     else Statusbar1.panels.items[1].text := 'Spooling ON ';
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if Fproc = false then
  begin
     if not table1.eof then
     begin
       pagecontrol1.activepage := TTabsheet(TabSheet2);
       Fproc := true;
       Mergedat1Click(Self);
       SendfaxButtonClick(Self);
       Statusbar1.panels.items[1].text := 'Spooled: '+table1NAME.value;
       table1.next;
       Fproc := false;
     end else
     begin
          MergeSendbt1Click(self);
          Messagedlg('Everything has now been spooled.', mtInformation, [mbOK],0);
     end;
  end;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  timer1.interval := spinedit1.value*1000;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  application.messagebox('By Michael Wilcox, Version: 1.00','Fax Letter - Demo',mb_OK);
end;

end.
