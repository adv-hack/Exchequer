unit SBSDCal;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, ExtCtrls, Buttons, Calendar;

type
  TCalForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    PrevMonthBtn: TSpeedButton;
    NextMonthBtn: TSpeedButton;
    MonthYear: TPanel;
    BorderEdge: TShape;
    CalGrid: TCalendar;

    procedure ShowMonth;
    procedure NextMonthBtnClick(Sender: TObject);
    procedure PrevMonthBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CalGridDblClick(Sender: TObject);
    procedure MonthYearDblClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;

      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }

    FontRatio,
    TopOfset,
    CalOfset  :  TPoint;

    fGridModified,
    InFCreate :  Boolean;

    Function ReadfGridModified  :  Boolean;


  public
    { Public declarations }
    DateSelection : TDateTime;

    Property GridModified  :  Boolean read ReadfGridModified write fGridModified;
    
  end;

var

  InitialDate   : TDateTime;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$R *.DFM}

Uses
  ETMiscU;

(********************)
(* Calendar Wrapper *)
(********************)

procedure TCalForm.ShowMonth;
begin
  MonthYear.Caption := FormatDateTime('mmmm yyyy',CalGrid.CalendarDate);
end;

procedure TCalForm.NextMonthBtnClick(Sender: TObject);
begin
  CalGrid.NextMonth;
  ShowMonth;
end;

procedure TCalForm.PrevMonthBtnClick(Sender: TObject);

begin
  CalGrid.PrevMonth;
  ShowMonth;
end;

Function TCalForm.ReadfGridModified  :  Boolean;

Begin
  Result:=fGridModified;

  fGridModified:=False;
end;

procedure TCalForm.FormCreate(Sender: TObject);
begin
  InFCreate:=True;

  ClientHeight:=124;
  ClientWidth:=165;


  If InitialDate > 0 then
    CalGrid.CalendarDate := InitialDate
  else
    CalGrid.CalendarDate := Now;

  TopOfset.X:=ClientWidth-Panel2.Width;
  TopOfset.Y:=Panel2.Width-NextMonthBtn.Left;

  CalOfset.X:=ClientWidth-CalGrid.Width;
  CalOfset.Y:=ClientHeight-CalGrid.Height;

  FontRatio.X:=ClientWidth*ClientHeight;
  FontRatio.Y:=CalGrid.Font.Size;

  ShowMonth;

  GridModified:=False;

  InFCreate:=False;
end;

procedure TCalForm.CalGridDblClick(Sender: TObject);
begin
  DateSelection := CalGrid.CalendarDate;

  GridModified:=True;
  ModalResult := mrOK;
end;

procedure TCalForm.MonthYearDblClick(Sender: TObject);
begin
  CalGrid.CalendarDate := Now;
  ShowMonth;
end;

procedure TCalForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of

    VK_RETURN   : ModalResult := mrOK;
    VK_ESCAPE   : ModalResult := mrCancel;
    VK_TAB      : begin
                    if Shift = [ssShift] then
                      CalGrid.PrevMonth
                    else
                      CalGrid.NextMonth;
                    ShowMonth;
                  end;
    VK_ADD      : begin
                    CalGrid.CalendarDate :=
                      CalGrid.CalendarDate + 1.0;
                    GridModified:=True;
                    ShowMonth;
                  end;
    VK_SUBTRACT : begin
                    CalGrid.CalendarDate :=

                      CalGrid.CalendarDate - 1.0;

                    GridModified:=True;
                    ShowMonth;
                  end;
  end;
end;

procedure TCalForm.FormResize(Sender: TObject);
begin
  If (Not InFCreate) then
  Begin

    Panel2.Width:=ClientWidth-TopOfset.X;
    NextMonthBtn.Left:=Panel2.Width-TopOfset.Y;

    CalGrid.Width:=ClientWidth-CalOfset.X;
    CalGrid.Height:=ClientHeight-CalOfset.Y;

    MonthYear.Left:=Round((Panel2.Width-MonthYear.Width)/2);

    CalGrid.Font.Size:=Round(DivWChk((ClientWidth*ClientHeight),FontRatio.X)*FontRatio.Y);

    If (CalGrid.Font.Size>8) then
      CalGrid.Font.Name:='Arial'
    else
      CalGrid.Font.Name:='Smal Fonts';
  end;
end;


begin
  InitialDate := 0;

end.


