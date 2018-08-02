unit Demo01;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, RPDefine, RPBase, RPSystem, StdCtrls;

type
  TDemo01Form = class(TForm)
    ReportSystem1: TReportSystem;
    Memo1: TMemo;
    procedure ReportSystem1Print(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Demo01Form: TDemo01Form;

implementation

{$R *.DFM}

procedure TDemo01Form.ReportSystem1Print(Sender: TObject);

var
  I1: integer;
  L1: longint;
  S1: string[20];
  S2: string[20];
  Bitmap: TBitmap;
  PolyLineArr: array[1..6] of TPoint;

begin
  With Sender as TBaseReport do begin
  { Print Header and footer for page }
    SectionTop := 0.75;
    SetFont('Arial',24);
    Underline := true;
    Home;
    YPos := 1.0;
    FontRotation := 15;
    PrintCenter('Report Page Demo',PageWidth / 2);

    SetFont('Times New Roman',8);
    SectionBottom := 10.75;
    PrintFooter('Page ' + IntToStr(CurrentPage),pjLeft);
    PrintFooter('Date 01/20/95',pjRight);
    SectionBottom := 10.5;

    YPos := 1.5;
    SetFont('Times New Roman',12);
    SetTopOfPage;
    Home;

  { Print column headers }
    ClearTabs;
    SetPen(clBlack,psSolid,1,pmCopy); { Set pen to 1 dot width }
    SetTab(0.5,pjCenter,3.5,0,BOXLINEALL,0);
    SetTab(NA,pjCenter,1.0,0,BOXLINEALL,0);
    SetTab(NA,pjCenter,1.5,0,BOXLINEALL,0);
    SetTab(NA,pjCenter,1.5,0,BOXLINEALL,0);
    Bold := true;
    Tab(-2,NA,-2,-2,NA); { Draw tab box with heavy outer borders }
    Print('Name');
    Tab(NA,NA,-2,-2,NA); { Draw tab box with heavy outer borders }
    Print('Number');
    Tab(NA,NA,-2,-2,NA); { Draw tab box with heavy outer borders }
    Print('Amount 1');
    Tab(NA,-2,-2,-2,NA); { Draw tab box with heavy outer borders }
    Println('Amount 2');
    Bold := false;

  { Print data lines in boxes }
    ClearTabs;
    SetTab(0.5,pjLeft,3.5,2,BOXLINEALL,0);
    SetTab(NA,pjCenter,1.0,2,BOXLINEALL,0);
    SetTab(NA,pjRight,1.5,2,BOXLINEALL,10);
    SetTab(NA,pjRight,1.5,2,BOXLINEALL,0);
    For I1 := 1 to 10 do begin
      Str(I1 * 1.23:2:2,S1);
      Str(I1 * 98.76:2:2,S2);
      Print(#9'LastName' + IntToStr(I1) + ', ');
      SetFont('Times New Roman',8);
      Print('FirstName M.');
      SetFont('Times New Roman',12);
      Println(#9 + IntToStr(I1) + #9'$' + S1 + #9'$' + S2);
    end; { for }

  { Print data lines with shading }
    ClearTabs;
    SetTab(0.5,pjLeft,3.5,2,BOXLINENONE,0);
    SetTab(NA,pjCenter,1.0,2,BOXLINENONE,0);
    SetTab(NA,pjRight,1.5,2,BOXLINENONE,0);
    SetTab(NA,pjRight,1.5,2,BOXLINENONE,0);
    For I1 := 11 to 20 do begin
      If Odd(I1) then begin
        TabShade := 0;
      end else begin
        TabShade := 15;
      end; { else }
      Str(I1 * 1.23:2:2,S1);
      Str(I1 * 98.76:2:2,S2);
      Print(#9'LastName' + IntToStr(I1) + ', ');
      SetFont('Times New Roman',8);
      Print('FirstName M.');
      SetFont('Times New Roman',12);
      Println(#9 + IntToStr(I1) + #9'$' + S1 + #9'$' + S2);
    end; { for }
    ClearTabs;

  { Columns demo }
    ClearTabs;
    SetTopOfPage;
    SectionBottom := 8.0;
    Home;
    SetFont('Times New Roman',12);
    Bold := true;
    Underline := true;
    Italic := true;
    Print('Columns (LinesLeft/ColumnLinesLeft/LineNum/ColumnNum)');
    SetTopOfPage; { Set top of page to current YPos }
    Bold := false;
    Underline := false;
    Italic := false;
    Home; { Goto home position }

    SetColumns(4,0.5); { Create 4 columns with 0.5" between each }
    While ColumnLinesLeft > 0 do begin
      Println(IntToStr(LinesLeft) + '/' + IntToStr(ColumnLinesLeft) + '/' +
       IntToStr(LineNum) + '/' + IntToStr(ColumnNum));
    end; { while }

  { Columns demo }
    ClearTabs;
    SetTopOfPage;
    SectionBottom := 10.5;
    Home;
    SetFont('Times New Roman',12);
    Bold := true;
    Italic := true;
    Print('Boxed Columns');
    SetTopOfPage; { Set top of page to current YPos }
    Bold := false;
    Italic := false;
    Home; { Goto home position }

    ClearTabs;
    SetPen(clBlack,psSolid,1,pmCopy); { Set pen to 1 dot width }
    SetTab(0.5,pjCenter,0.375,0,BOXLINEALL,0);
    SetTab(NA,pjCenter,0.375,0,BOXLINEALL,0);
    SetTab(NA,pjCenter,0.375,0,BOXLINEALL,0);
    SetTab(NA,pjCenter,0.375,0,BOXLINEALL,0);
    SetColumns(4,0.5); { Create 4 columns with 0.5" between each }
    While ColumnLinesLeft > 0 do begin
      If LineNum = 1 then begin
        TabShade := 15;
        Println(#9'LL'#9'CLL'#9'L#'#9'C#'); { Print title bar }
      end else begin
        TabShade := 0;
        Println(#9 + IntToStr(LinesLeft) + #9 + IntToStr(ColumnLinesLeft) +
         #9 + IntToStr(LineNum) + #9 + IntToStr(ColumnNum));
      end; { else }
    end; { while }
    SetColumns(1,0);

  {*** Graphics page demonstration ***}
    NewPage;
    ResetSection;
    SetFont('Arial',24);
    Underline := true;
    Home;
    PrintCenter('Graphics Page Demo',PageWidth / 2);
    SetFont('Times New Roman',8);

    SectionBottom := 10.75; { Temporarily move the section bottom down }
    PrintFooter('Page ' + IntToStr(CurrentPage),pjLeft);
    PrintFooter('Date 01/20/95',pjRight);
    SectionBottom := 10.5; { Reset section bottom }

    OriginX := 0.0;
    OriginY := 0.5;
    SetFont('Arial',10);

  { Arc/Chord demo }
    SetPen(clBlack,psSolid,-2,pmCopy); { Set pen to black 2/100ths" wide }
    YPos := 0.95;
    PrintCenter('Arc() and Chord()',2.125);
    Arc(1.125,1.0,3.125,3.0,3.125,2.0,0.0,0.0);
    SetBrush(clBlack,bsClear,nil);
    Chord(1.125,1.0,3.125,3.0,0.0,0.8,3.125,2.25);

  { Pie demo }
    YPos := 0.95;
    PrintCenter('Pie()',4.25);
    SetPen(clBlack,psSolid,-2,pmCopy); { Set pen to black 2/100ths" wide }
    SetBrush(clBlack,bsHorizontal,nil);
    Pie(3.25,1.0,5.25,3.0,5.25,2.0,0.0,0.0);
    SetBrush(clBlack,bsVertical,nil);
    Pie(3.25,1.0,5.25,3.0,0.0,0.0,3.25,7.0);
    SetBrush(clBlack,bsBDiagonal,nil);
    Pie(3.25,1.0,5.25,3.0,3.25,7.0,5.25,2.0);

  { Ellipse demo }
    YPos := 1.2;
    PrintCenter('Ellipse()',6.375);
    SetBrush(clBlack,bsCross,nil);
    Ellipse(5.375,1.25,7.375,2.75);

  { RoundRect Demo }
    YPos := 3.4;
    PrintCenter('RoundRect()',2.125);
    SetBrush(clBlack,bsDiagCross,nil);
    RoundRect(1.125,3.5,3.125,5.0,0.25,0.25);
    YPos := 4.0;
    SetBrush(clBlack,bsSolid,nil);
    TextBKMode := bkOpaque;
    BKColor := clWhite;
    PrintCenter('Opaque Text',2.125);
    YPos := 4.5;
    TextBKMode := bkTransparent;
    PrintCenter('Transparent Text',2.125);

  { Polyline demo }
    YPos := 3.4;
    PrintCenter('psDash w/ PolyLine()',4.25);
    OriginX := 4.25; { Set origin for simpler calc }
    OriginY := 5.0;
    SetPen(clBlack,psDash,-2,pmCopy); { Set pen to black 2/100ths" wide }
    PolyLineArr[1] := CreatePoint(0,-1);
    PolyLineArr[2] := CreatePoint(-0.59,0.81);
    PolyLineArr[3] := CreatePoint(0.95,-0.31);
    PolyLineArr[4] := CreatePoint(-0.95,-0.31);
    PolyLineArr[5] := CreatePoint(0.59,0.81);
    PolyLineArr[6] := CreatePoint(0,-1);
    PolyLine(PolyLineArr);
    OriginX := 0.0; { Reset origin }
    OriginY := 0.5;

  { PaintBitmap demo }
    YPos := 3.4;
    PrintCenter('PaintBitmapRect()',6.375);
    Bitmap := TBitmap.Create;
    Bitmap.LoadFromFile('RPDEMO.BMP');
    PrintBitmapRect(5.375,3.5,7.375,5.5,Bitmap);
    Bitmap.Free;

  { Units demo }
    SetPen(clBlack,psSolid,-1,pmCopy); { Set pen to black 1/100ths" wide }
    GotoXY(1.0,5.5);
    Bold := true;
    Underline := true;
    Italic := true;
    Print('Units Demonstration');
    Bold := false;
    Underline := false;
    Italic := false;

  { Draw inches ruler }
    Units := unInch;
    GotoXY(1.0,5.75);
    Bold := true;
    Print('Inches');
    Bold := false;
    YPos := 6.0;
    MoveTo(1.0,6.25);
    LineTo(7.0,6.25);
    For I1 := 0 to 6 do begin
      PrintCenter(IntToStr(I1),I1 + 1);
      MoveTo(I1 + 1,6.05);
      LineTo(I1 + 1,6.25);
    end; { for }

  { Draw millimeters ruler }
    Units := unMM;
    OriginY := 12.7; { Set to 1/2 inch down }
    GotoXY(25.4,170);
    Bold := true;
    Print('Millimeters');
    Bold := false;
    YPos := 175;
    MoveTo(25.4,180);
    LineTo(175.4,180);
    For I1 := 0 to 15 do begin
      PrintCenter(IntToStr(I1 * 10),I1 * 10 + 25.4);
      MoveTo(I1 * 10 + 25.4,176);
      LineTo(I1 * 10 + 25.4,180);
    end; { for }
    Units := unInch; { Set units back to inches }

  { Text at specific locations }
    OriginX := 0.0; { Set origin to normal }
    OriginY := 0.0;
    GotoXY(1.0,8.5);
    Print('Text @ 1.0,8.5');
    GotoXY(6.0,8.5);
    Println('Text @ 6.0,8.5');
    GotoXY(2.0,9.0);
    Println('Text @ 2.0,9.0');
    GotoXY(3.0,9.5);
    Println('Text @ 3.0,9.5');
  end; { with }
end;

end.
