unit PickReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DataModule, ComCtrls, RepTreeIF, RptEngDLL, StdCtrls, ImgList, MiscUtil;

type
  TReportRec = Record
    cNodeType : char;
    sCode : string;
    sName : string;
    sFileName : string;
    sLastRun : string;
    bAllowEdit : boolean;
  end;{TReportRec}

  TReportInfo = Class
    ReportRec : TReportRec;
  end;{TReportInfo}

  TfrmPickReport = class(TForm)
    tvReports: TTreeView;
    btnOK: TButton;
    btnCancel: TButton;
    ilTree: TImageList;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure tvReportsChange(Sender: TObject; Node: TTreeNode);
    procedure FormDestroy(Sender: TObject);
    procedure tvReportsDblClick(Sender: TObject);
  private
    oReportTree : IReportTree_Interface;
    TreeNodeType, TreeNodeName, TreeNodeDesc,
    TreeNodeParent, TreeNodeChild, FileName, LastRun : ShortString;
    AllowEdit : Boolean;
    procedure WMGetMinMaxInfo(var message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure FillNewReportTree(const ParentID : ShortString; Node : TTreeNode);
  public
    sPrevCode : string;
  end;

var
  frmPickReport: TfrmPickReport;

implementation
uses
  ToolProc;

procedure TfrmPickReport.FillNewReportTree(const ParentID : ShortString; Node : TTreeNode);
var
  Res, Res1 : SmallInt;
  i : integer;
  ThisGroup : ShortString;
  FilePos : longint;
  ThisNode : TTreeNode;
//  RepRec : ^TReportNameRec;
  LocalParentID : ShortString;
  ReportInfo : TReportInfo;
begin

  if Node = nil then
  begin
    oReportTree := GetReportTree as IReportTree_Interface;

//    oReportTree.CompanyDataSetPath := CurrentCompanyRec.Path;
    oReportTree.CompanyDataSetPath := asCompanyPath;
    
//    oReportTree.ReportTreeSecurity := UserID;

    Res := oReportTree.GetFirstReport(TreeNodeType, TreeNodeName, TreeNodeDesc,
                    TreeNodeParent, TreeNodeChild, FileName, LastRun, AllowEdit);
  end
  else
    Res := 0;


  if Res = 0 then
  begin
    LocalParentID := ParentID;
    AllowEdit := False;
    Res := oReportTree.GetGEqual(LocalParentID, TreeNodeType, TreeNodeName, TreeNodeDesc,
                        TreeNodeParent, TreeNodeChild, FileName, LastRun, AllowEdit);
    while (Res = 0) and (Trim(LocalParentID) = Trim(TreeNodeParent)) do
    begin

      ThisNode := tvReports.Items.AddChild(Node,TreeNodeName + ' - ' + TreeNodeDesc);

      // Create and add Object to hold info
      ReportInfo := TReportInfo.Create;
      With ReportInfo.ReportRec do
      begin
        cNodeType := TreeNodeType[1];
        sCode := TreeNodeName;
        sName := TreeNodeDesc;
        sFileName := FileName;
        sLastRun := LastRun;
        bAllowEdit := AllowEdit;
      end;{with}
      ThisNode.Data := ReportInfo;

      // select node
      if (sPrevCode = TreeNodeName) then tvReports.Selected := ThisNode;

      if TreeNodeType = 'H' then
      begin
        Res1 := oReportTree.SavePosition(FilePos);
        FillNewReportTree(TreeNodeChild, ThisNode);
        Res1 := oReportTree.RestorePosition(FilePos);

        // Folder Icon
        ThisNode.ImageIndex := 0;
        ThisNode.SelectedIndex := 0;
      end else
      begin
        // Document Icon
        ThisNode.ImageIndex := 2;
        ThisNode.SelectedIndex := 2;
      end;

      Res := oReportTree.GetNext(TreeNodeType, TreeNodeName, TreeNodeDesc
      , TreeNodeParent, TreeNodeChild, FileName, LastRun, AllowEdit);
    end;{while}

    if Node = nil then oReportTree := nil;
  end;
end;


{$R *.dfm}

procedure TfrmPickReport.FormShow(Sender: TObject);
begin
  ClearList(tvReports);
  FillNewReportTree('0',nil);
end;

procedure TfrmPickReport.btnOKClick(Sender: TObject);
begin
  if (tvReports.Selected <> nil) and (tvReports.Selected.ImageIndex <> 0)
  then ModalResult := mrOK;
end;

procedure TfrmPickReport.tvReportsChange(Sender: TObject; Node: TTreeNode);
begin
  btnOK.Enabled := (tvReports.Selected <> nil)
  and (TReportInfo(tvReports.Selected.Data).ReportRec.cNodeType <> 'H');
end;

procedure TfrmPickReport.FormDestroy(Sender: TObject);
begin
  ClearList(tvReports);
end;

procedure TfrmPickReport.tvReportsDblClick(Sender: TObject);
begin
  btnOKClick(btnOK);
end;

procedure TfrmPickReport.WMGetMinMaxInfo(var message: TWMGetMinMaxInfo);
begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 400;
    ptMinTrackSize.Y := 300;
  end;{with}
  Message.Result := 0;
  inherited;
end;

end.
