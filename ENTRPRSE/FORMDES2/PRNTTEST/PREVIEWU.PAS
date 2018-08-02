unit PreviewU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, RPreview, RPDefine, RPBase, RPCanvas, RPFPrint, StdCtrls, Buttons,
  ExtCtrls, SBSPanel;

type
  TForm2 = class(TForm)
    Panel_Toolbar: TSBSPanel;
    Panel1: TPanel;
    Button_Close: TButton;
    Panel_Pages: TPanel;
    BitBtn_Print: TBitBtn;
    BitBtn_ZoomIn: TBitBtn;
    BitBtn_ZoomOut: TBitBtn;
    BitBtn_ZoomPage: TBitBtn;
    BitBtn_NextPage: TBitBtn;
    BitBtn_PrevPage: TBitBtn;
    Panel_ScrollBar: TSBSPanel;
    ScrollBar_Pages: TScrollBar;
    ScrollBox_Preview: TScrollBox;
    FilePrinter1: TFilePrinter;
    FilePreview1: TFilePreview;
    Popup_Preview: TPopupMenu;
    Popup_Preview_ZoomIn: TMenuItem;
    Popup_Preview_ZoomOut: TMenuItem;
    Popup_Preview_ZoomToPage: TMenuItem;
    Popup_Preview_ZoomToNormal: TMenuItem;
    Popup_Preview_SepBar1: TMenuItem;
    Popup_Preview_PrevPage: TMenuItem;
    Popup_Preview_NextPage: TMenuItem;
    Popup_Preview_SepBar2: TMenuItem;
    Popup_Preview_Print: TMenuItem;
    procedure BitBtn_ZoomInClick(Sender: TObject);
    procedure BitBtn_ZoomOutClick(Sender: TObject);
    procedure BitBtn_ZoomPageClick(Sender: TObject);
    procedure BitBtn_PrevPageClick(Sender: TObject);
    procedure BitBtn_NextPageClick(Sender: TObject);
    procedure BitBtn_PrintClick(Sender: TObject);
    procedure ScrollBar_PagesChange(Sender: TObject);
    procedure ScrollBar_PagesScroll(Sender: TObject;
      ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure Button_CloseClick(Sender: TObject);
    procedure Popup_Preview_ZoomToNormalClick(Sender: TObject);
  private
    { Private declarations }
    ScPage      : LongInt;
    Procedure EnableButts(PageNo : SmallInt);
  public
    { Public declarations }
    Procedure StartPreview;
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

procedure TForm2.BitBtn_ZoomInClick(Sender: TObject);
begin
  FilePreview1.ZoomIn;
end;

procedure TForm2.BitBtn_ZoomOutClick(Sender: TObject);
begin
  FilePreview1.ZoomOut;
end;

procedure TForm2.BitBtn_ZoomPageClick(Sender: TObject);
begin
  FilePreview1.ZoomFactor := FilePreview1.ZoomPageFactor;
end;

procedure TForm2.BitBtn_PrevPageClick(Sender: TObject);
Var
  NP : Integer;
begin
  NP := ScrollBar_Pages.Position - 1;
  If (NP >= ScrollBar_Pages.Min) And (NP <= ScrollBar_Pages.Max) Then Begin
    ScrollBar_PagesScroll (Sender, scPosition, NP);
    ScrollBar_Pages.Position := NP;
  End; { If }
end;

procedure TForm2.BitBtn_NextPageClick(Sender: TObject);
Var
  NP : Integer;
begin
  NP := ScrollBar_Pages.Position + 1;
  If (NP >= ScrollBar_Pages.Min) And (NP <= ScrollBar_Pages.Max) Then Begin
    ScrollBar_PagesScroll(Sender, scPosition, NP);
    ScrollBar_Pages.Position := NP;
  End; { If }
end;

procedure TForm2.BitBtn_PrintClick(Sender: TObject);
begin
  Try
    FilePrinter1.Execute;
  Except
    On Ex : Exception Do
      MessageDlg ('The following error occured printing to printer:' +
                  #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                  'Please notify Technical Support', mtError, [mbOk], 0);
  End;
end;

procedure TForm2.ScrollBar_PagesChange(Sender: TObject);
begin
  Panel_Pages.Caption := 'Page ' +
                          IntToStr(ScrollBar_Pages.Position) +
                          ' of ' +
                          IntToStr(ScrollBar_Pages.Max);
end;

procedure TForm2.ScrollBar_PagesScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  If (ScrollCode <> scTrack) And (ScPage <> ScrollPos) Then Begin
    { Update display - disable scrollbar as it stops a bug which   }
    { causes it to automatically scroll whenever the mouse is over }
    { the button which was clicked                                 }
    ScPage := ScrollPos;
    FilePreview1.PrintPage(ScrollPos);
    EnableButts(ScrollPos);
  End; { If }
end;


Procedure TForm2.StartPreview;
Var
  Tmp : Integer;
Begin
  ScPage := -1;
  FilePreview1.Start;

  Tmp := Round(FilePreview1.Pages * 0.1);
  If (Tmp < 1) Then Tmp := 1;
  ScrollBar_Pages.LargeChange := Tmp;
  ScrollBar_Pages.SetParams (1, 1, FilePreview1.Pages);
  ScrollBar_Pages.Enabled := (FilePreview1.Pages > 1);
  Panel_ScrollBar.Visible := (FilePreview1.Pages > 1);
  EnableButts(ScrollBar_Pages.Position);
end;


Procedure TForm2.EnableButts(PageNo : SmallInt);
begin
  Popup_Preview_PrevPage.Enabled := (PageNo > ScrollBar_Pages.Min);
  Popup_Preview_NextPage.Enabled := (PageNo < ScrollBar_Pages.Max);
  BitBtn_PrevPage.Enabled := Popup_Preview_PrevPage.Enabled;
  BitBtn_NextPage.Enabled := Popup_Preview_NextPage.Enabled;
End;

procedure TForm2.Button_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure TForm2.Popup_Preview_ZoomToNormalClick(Sender: TObject);
begin
  FilePreview1.ZoomFactor := 100;
end;

end.
