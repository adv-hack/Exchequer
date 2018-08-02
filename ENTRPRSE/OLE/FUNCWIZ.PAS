unit FuncWiz;

{ markd6 12:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal;

{$IFNDEF FUNCWIZ}
  This section has been deliberately added to stop this module being
  accidently compiled in.
{$ENDIF}

type
  TfrmFunctionWizard = class(TForm)
    Label81: Label8;
    lstCategories: TListBox;
    Label82: Label8;
    ListBox2: TListBox;
    Label83: Label8;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

{$R FuncList.Res}

Var
  CatList, FuncList : TStringList;


{ Gets a specified string resource and calls the parsing function }
Procedure GetResStr(Const ResId : LongInt);
Var
  KeyS    :  Array[0..254] of Char;
  PC      :  PChar;
  RetLen  :  Integer;
Begin
  PC:=StrPCopy(KeyS,'');
  RetLen:=LoadString(HInstance,ResId,PC,255);
  {ProcessCSVLine (StrPas(PC));}
  ShowMessage (PC);
End;


Procedure LoadFunctions;
Begin { LoadFunctions }
  CatList := TStringList.Create;
  FuncList := TStringList.Create;

  GetResStr(8001);

End;  { LoadFunctions }


Procedure KillFunctions;
Begin { KillFunctions }
  CatList.Destroy;
  FuncList.Destroy;
End;  { KillFunctions }


{-----------------------------------------------------------------------------}

procedure TfrmFunctionWizard.FormCreate(Sender: TObject);
begin
  { load categories list }
  lstCategories.Items.AddObject('Customer', Pointer(0));
  lstCategories.Items.AddObject('General Ledger', Pointer(1));
  lstCategories.Items.AddObject(#9'Cost Centre', Pointer(2));
  lstCategories.Items.AddObject(#9'Department', Pointer(3));
  lstCategories.Items.AddObject('Job Costing', Pointer(4));
  lstCategories.Items.AddObject('Miscellaneous', Pointer(5));
  lstCategories.Items.AddObject('Stock', Pointer(6));
  lstCategories.Items.AddObject(#9'Location', Pointer(7));
  lstCategories.Items.AddObject('Supplier', Pointer(8));
  lstCategories.Items.AddObject('Transaction', Pointer(9));
end;

procedure TfrmFunctionWizard.Button1Click(Sender: TObject);
begin
  Close;
end;

Initialization
  LoadFunctions;
Finalization
  KillFunctions;
end.
