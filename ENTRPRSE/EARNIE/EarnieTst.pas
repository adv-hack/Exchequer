unit EarnieTst;

{ nfrewer440 16:25 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Contnrs;

type


  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Button2: TButton;
    Button3: TButton;
    ListBox2: TListBox;
    Edit1: TEdit;
    Label3: TLabel;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    recList : TObjectList;
  end;

var
  Form1: TForm1;

implementation

uses ExpEarnie;

{$R *.DFM}



Function GetTotalHoursForEmployee(RecList : TObjectList) : TObjectList;
var
  ExportRec : TExportRec;
  AccumExpRec : TExportRec;
  EmpCode : String;
  Rate    : Integer;
  cnt : integer;
  TotList : TObjectList;
  Eof : Boolean;

begin
  RecList.pack;
  totList := TObjectList.create;

  cnt := 0;

  Eof := GetRecord(RecList,Cnt,ExportRec);
  if not eof then
  begin

    AccumExpRec := TExportRec.create;

    AccumExpRec.EmpCode := ExportRec.EmpCode;
    AccumExpRec.Rate    := ExportRec.Rate;
    AccumExprec.NoHour  := 0;

    EmpCode := AccumExpRec.EmpCode;
    Rate    := AccumExpRec.Rate;

    While not (Eof) do
    begin

      While (EmpCode = ExportRec.EmpCode) and  not(eof)do
      begin

        While (EmpCode = ExportRec.EmpCode) and (Rate = ExportRec.Rate) and  not(eof)do
        begin
          AccumExprec.NoHour :=
            AccumExprec.NoHour + ExportRec.NoHour;

           eof := GetRecord(RecList,Cnt,ExportRec);
        end;
        //add this record to the list
        TotList.add(AccumExpRec);

        Rate := ExportRec.rate;

        if not(Eof) then
        begin
          AccumExpRec := TExportRec.create;

          AccumExpRec.EmpCode := ExportRec.EmpCode;
          AccumExpRec.Rate    := ExportRec.Rate;
          AccumExprec.NoHour  := 0;
        end;

      end;
      //add this record to the list
      EmpCode :=ExportRec.EmpCode;
    end;
  end;
  Result := TotList;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  RecList := TObjectList.Create;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  ExpRec : TExportRec;
  
begin
  ExpRec := TExportRec.Create;
  ExpRec.EmpCode := combobox1.text;
  Exprec.Rate := strtoint(Combobox2.text);
  ExpRec.NoHour := strtoint(Edit1.text);
  RecList.add(ExpRec);

  with expRec do
  ListBox1.items.add(empCode + '      ' + inttostr( Rate)  + '    '+floattostr(noHour));
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  cnt : integer;
begin
  RecList.Sort(ByEmployeeCodeAndPayrollNo);//sort the list by payroll no   i.e by employee code

  ListBox1.clear;
  for cnt := 1 to recList.count do
  begin
    ListBox1.items.add(TExportRec(RecList[cnt-1]).empCode + '      ' + inttostr(TExportRec(RecList[cnt-1]).Rate) + '    '+ floattostr(TExportRec(RecList[cnt-1]).noHour));
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  cnt : integer;
begin
  RecList := GetTotalHoursForEmployee(RecList); //accumulate totals hours for payrollno
  ListBox2.Clear;

  for cnt := 1 to recList.count do
  begin
    ListBox2.items.add(TExportRec(RecList[cnt-1]).empCode + '      ' +inttostr(TExportRec(RecList[cnt-1]).Rate)  + '    '+floattostr(TExportRec(RecList[cnt-1]).noHour));
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  reclIst.clear;
  Listbox1.items.clear;
end;

end.


12 1
12 2
13 2
13 2
14 3


while not eof do
begin
  While not eof and a = newa and b = newb do
  begin


  end;
  a := newA; b := newb;
end;
