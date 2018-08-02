{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVPEPLst;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, RVDefine, RVClass, RVProj, RVTool, RVUtil, RPDefine;

type
  TPageListEditor = class(TForm)
    Label1: TLabel;
    OKBtn: TButton;
    CancelBtn: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    ReportCB: TComboBox;
    Label3: TLabel;
    GlobalCB: TComboBox;
    AddPageButton: TButton;
    AddGlobalButton: TButton;
    GroupBox2: TGroupBox;
    PageLB: TListBox;
    MoveUpSB: TSpeedButton;
    MoveDownSB: TSpeedButton;
    DeleteSB: TSpeedButton;
    procedure PageLBClick(Sender: TObject);
    procedure MoveUpSBClick(Sender: TObject);
    procedure MoveDownSBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AddPageButtonClick(Sender: TObject);
    procedure AddGlobalButtonClick(Sender: TObject);
    procedure DeleteSBClick(Sender: TObject);
  private
  public
    Report: TRaveReport;
    PageList: TRaveComponentList;
  end;

var
  PageListEditor: TPageListEditor;

  procedure RaveRegister;

implementation

{$R *.DFM}

type
  TRavePageListPropertyEditor = class(TRavePropertyEditor)
  protected
    function GetOptions: TPropertyOptionsSet; override;
    procedure Edit; override;
    function GetValue: string; override;
  end; { TRavePageListPropertyEditor }

  procedure RaveRegister;

  begin { RaveRegister }
  {TransOff}
    RegisterRavePropertyEditor(TypeInfo(TRaveComponentList),TRaveReport,'PageList',
     TRavePageListPropertyEditor);
  {TransOn}
  end;  { RaveRegister }

(*****************************************************************************}
( class TRavePageListPropertyEditor
(*****************************************************************************)

  function TRavePageListPropertyEditor.GetOptions: TPropertyOptionsSet;

  begin { GetOptions }
    Result := [poReadOnly,poEditor];
  end;  { GetOptions }

  function TRavePageListPropertyEditor.GetValue: string;

  begin { GetValue }
    If GetOrdValue(0) = 0 then begin
      Result := '';
    end else begin
      Result := '(' + Trans('Page List') + ')';
    end; { else }
  end;  { GetValue }

  procedure TRavePageListPropertyEditor.Edit;

  var
    List: TRaveComponentList;

  begin { Edit }
    With TPageListEditor.Create(Application) do try
    { Init dialog contents }
      Report := Instance[0] as TRaveReport;
      List := TObject(GetOrdValue(0)) as TRaveComponentList;
      If Assigned(List) then begin
        CopyList(List,PageList);
      end else begin
        PageList.Clear;
      end; { else }
      If ShowModal = mrOK then begin
      { Copy from dialog contents }
        Report.PageList := PageList;
        Modified;
      end; { if }
    finally
      Free;
    end; { with }
  end;  { Edit }

(*****************************************************************************}
( class TPageListEditor
(*****************************************************************************)

  procedure TPageListEditor.PageLBClick(Sender: TObject);

  begin
    MoveUpSB.Enabled := PageLB.ItemIndex > 0;
    MoveDownSB.Enabled := (PageLB.ItemIndex < PageLB.Items.Count - 1) and
     (PageLB.ItemIndex >= 0);
    DeleteSB.Enabled := (PageLB.Items.Count > 0);
  end;

  procedure TPageListEditor.MoveUpSBClick(Sender: TObject);

  begin
    PageLB.Items.Exchange(PageLB.ItemIndex,PageLB.ItemIndex - 1);
    PageLB.ItemIndex := PageLB.ItemIndex - 1;
    PageLBClick(PageLB);
  end;

  procedure TPageListEditor.MoveDownSBClick(Sender: TObject);

  begin
    PageLB.Items.Exchange(PageLB.ItemIndex,PageLB.ItemIndex + 1);
    PageLB.ItemIndex := PageLB.ItemIndex + 1;
    PageLBClick(PageLB);
  end;

  procedure TPageListEditor.FormCreate(Sender: TObject);

  begin
    FormTrans(self);
    PrepareToolWin(self);
    PageList := TRaveComponentList.Create;
  end;

  procedure TPageListEditor.FormDestroy(Sender: TObject);

  begin
    PageList.Free;
    SaveToolWin(self);
  end;

  procedure TPageListEditor.OKBtnClick(Sender: TObject);

  var
    I1: integer;

  begin
  { Fill up page list }
    PageList.Clear;
    For I1 := 0 to PageLB.Items.Count - 1 do begin
      PageList.Add(PageLB.Items.Objects[I1]);
    end; { for }
  end;

  procedure TPageListEditor.FormShow(Sender: TObject);

  var
    I1: integer;
    Page: TRavePage;

  begin
    RestoreToolWin(self);

  { Fill up ReportCB }
    If Report.ChildCount = 0 then begin
      ReportCB.Enabled := false;
      AddPageButton.Enabled := false;
    end else begin
      For I1 := 0 to Report.ChildCount - 1 do begin
        Page := TRavePage(Report.Child[I1]);
        ReportCB.Items.AddObject(Page.Name,Page);
      end; { for }
      ReportCB.ItemIndex := 0;
    end; { else }

  { Fill up GlobalCB }
    If ProjectManager.GlobalPageList.Count = 0 then begin
      GlobalCB.Enabled := false;
      AddGlobalButton.Enabled := false;
    end else begin
      For I1 := 0 to ProjectManager.GlobalPageList.Count - 1 do begin
        Page := TRavePage(ProjectManager.GlobalPageList[I1]);
        GlobalCB.Items.AddObject(Page.Name,Page);
      end; { for }
      GlobalCB.ItemIndex := 0;
    end; { else }

  { Copy from PageList to PageLB }
    PageLB.Clear;
    For I1 := 0 to PageList.Count - 1 do begin
      Page := TRavePage(PageList[I1]);
      PageLB.Items.AddObject(Page.Name,Page);
    end; { for }
    PageLB.ItemIndex := 0;
    PageLBClick(PageLB);
  end;

  procedure TPageListEditor.AddPageButtonClick(Sender: TObject);

  begin
    With ReportCB do begin
      PageLB.Items.AddObject(Items[ItemIndex],TRavePage(Items.Objects[ItemIndex]));
      PageLB.ItemIndex := PageLB.Items.Count -1;
      PageLBClick(PageLB);
    end; { with }
  end;

  procedure TPageListEditor.AddGlobalButtonClick(Sender: TObject);

  begin
    With GlobalCB do begin
      PageLB.Items.AddObject(Items[ItemIndex],TRavePage(Items.Objects[ItemIndex]));
      PageLB.ItemIndex := PageLB.Items.Count -1;
      PageLBClick(PageLB);
    end; { with }
  end;

  procedure TPageListEditor.DeleteSBClick(Sender: TObject);

  var
    SaveIndex: integer;

  begin
    SaveIndex := PageLB.ItemIndex;
    PageLB.Items.Delete(SaveIndex);
    If PageLB.Items.Count > 0 then begin
      If SaveIndex > 0 then begin
        PageLB.ItemIndex := SaveIndex - 1;
      end else begin
        PageLB.ItemIndex := SaveIndex;
      end; { else }
    end; { if }
    PageLBClick(PageLB);
  end;

initialization
  RegisterProc('RVCL',RaveRegister);
end.
