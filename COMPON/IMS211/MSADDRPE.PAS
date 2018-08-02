(**********************************************)
(*  The Internet Mail Suite  2.1              *)
(*  (c) ArGo Software Design, 1995-2001       *)
(*  http://www.argosoft.com/delphi            *)
(*  support@argosoft.com                      *)
(**********************************************)
unit msaddrpe;

{$I msdef.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ExtCtrls, StdCtrls,
{$IFDEF VER140}
  DesignIntf,
  DesignWindows,
  DesignEditors,
{$ELSE}
  DsgnIntf,
{$ENDIF}
  msMsgCls;

type
  TAddrEditDlg = class(TForm)
    OKButton: TButton;
    CancelButton: TButton;
    Bevel1: TBevel;
    Panel1: TPanel;
    EditButton: TButton;
    AddButton: TButton;
    DeleteButton: TButton;
    HelpButton: TButton;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
  private
    { Private declarations }
    FAddrList : TMsAddressList;
    procedure SetAddrList(Value : TmsAddressList);
    procedure FillStringGrid;
  public
    { Public declarations }
    property AddrList : TmsAddressList read FAddrList write SetAddrList;
  end;

  TmsAddressListProperty = class(TClassProperty)
    procedure Edit; override;
    function GetAttributes : TPropertyAttributes; override;
  end;

implementation

{$R *.DFM}

{TmsAddressListProperty}
function TmsAddressListProperty.GetAttributes : TPropertyAttributes;
begin
  Result:=[paDialog,paReadOnly];
end;

procedure TmsAddressListProperty.Edit;
var
  AddrEditDlg : TAddrEditDlg;
begin
  AddrEditDlg:=TAddrEditDlg.Create(Application);
  try
    AddrEditDlg.AddrList:=TmsAddressList(GetOrdValue);
    if AddrEditDlg.ShowModal=mrOk then
      SetOrdValue(LongInt(AddrEditDlg.AddrList));
  finally
    AddrEditDlg.Free;
  end;
end;

procedure TAddrEditDlg.FormCreate(Sender: TObject);
begin
  FAddrList:=TmsAddressList.Create;
end;

procedure TAddrEditDlg.FormDestroy(Sender: TObject);
begin
  FAddrList.Free;
end;

procedure TAddrEditDlg.SetAddrList(Value : TmsAddressList);
begin
  FAddrList.Assign(Value);
  FillStringGrid;
end;

procedure TAddrEditDlg.FillStringGrid;
var
  i : Integer;
begin
  with StringGrid1 do
  begin
    Cells[0,0]:='Name';
    Cells[1,0]:='Email Address';
    if FAddrList.Count>0 then
    begin
      RowCount:=FAddrList.Count+1;
      Row:=1;
      EditButton.Enabled:=true;
      DeleteButton.Enabled:=true;
      for i:=0 to FAddrList.Count-1 do
      begin
        Cells[0,i+1]:=TmsMailAddress(FAddrList[i]).Name;
        Cells[1,i+1]:=TmsMailAddress(FAddrList[i]).Address;
      end;
    end
    else
    begin
      RowCount:=5;
      Cells[0,1]:='';
      Cells[1,1]:='';
      StringGrid1.Enabled:=false;
      EditButton.Enabled:=false;
      DeleteButton.Enabled:=false;
    end;
  end;
end;

procedure TAddrEditDlg.EditButtonClick(Sender: TObject);
var
  TempAddress : TmsMailAddress;
begin
  TempAddress:=TmsMailAddress(FAddrList[StringGrid1.Row-1]);
  TempAddress.Edit;
end;

procedure TAddrEditDlg.AddButtonClick(Sender: TObject);
var
  TempAddress : TmsMailAddress;
begin
  TempAddress:=TmsMailAddress.Create;
  TempAddress.Edit;
  if (TempAddress.Name<>'') or (TempAddress.Address<>'') then
  begin
    FAddrList.Add(TempAddress);
    FillStringGrid;
  end
  else
    TempAddress.Free;
end;

procedure TAddrEditDlg.DeleteButtonClick(Sender: TObject);
var
  Index : Integer;
begin
  Index:=StringGrid1.Row-1;
  FAddrList.Delete(Index);
  FillStringGrid;
end;

end.
