{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPShell;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, RPDefine, RPBase, RPSect, RPSystem;

type
  TBaseShell = class;
  TDetailShell = class;
  TMasterShell = class;
  TReportShell = class;

  TReportEvent = procedure(ReportPrinter: TBaseReport;
                           ReportShell: TDetailShell) of object;

  TReportValidEvent = procedure(    ReportPrinter: TBaseReport;
                                    ReportShell: TDetailShell;
                                var Valid: boolean) of object;

{*************************************************************************}
{                             class TBaseShell                            }
{*************************************************************************}

  TBaseShell = class(TRPBaseComponent)
  protected
    FReportPrinter: TBaseReport;
    FEngine: TRPComponent;

    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    procedure SetEngine(Value: TRPComponent);
    procedure StartExecute(Sender: TObject);
    function InitEngine(Report: TBaseReport): boolean;
  public
    property ReportPrinter: TBaseReport read FReportPrinter write FReportPrinter;

    procedure Execute(Report: TBaseReport); virtual; abstract;
  published
    property Engine: TRPComponent read FEngine write SetEngine;
  end; { TBaseShell }

{*************************************************************************}
{                            class TDetailShell                           }
{*************************************************************************}

  TDetailShell = class(TBaseShell)
  protected
    Executing: boolean;

    FDetailReport: TDetailShell;
    FIsReprint: boolean;
    FIsNewPage: boolean;
    FReprint: boolean;
    FStartNewPage: boolean;
    DoNewPage: boolean;
    MasterShell: TDetailShell;
    RowPrinted: boolean;

    FSectionRow: TReportSection;
    FSectionBodyHeader: TReportSection;
    FSectionBodyFooter: TReportSection;
    FSectionGroupHeader: TReportSection;
    FSectionGroupFooter: TReportSection;

    FOnBodyBefore: TReportEvent;
    FOnBodyHeader: TReportEvent;
    FOnGroupBeforeFirst: TReportEvent;
    FOnGroupBefore: TReportValidEvent;
    FOnGroupHeader: TReportEvent;
    FOnRowBefore: TReportValidEvent;
    FOnRowPrint: TReportValidEvent;
    FOnDetailBefore: TReportEvent;
    FOnDetailAfter: TReportEvent;
    FOnRowAfter: TReportValidEvent;
    FOnGroupFooter: TReportEvent;
    FOnGroupAfter: TReportValidEvent;
    FOnGroupAfterLast: TReportEvent;
    FOnBodyFooter: TReportEvent;
    FOnBodyAfter: TReportEvent;

    procedure BodyBeforeEvent; virtual;
    procedure BodyHeaderEvent; virtual;
    procedure GroupBeforeFirstEvent; virtual;
    procedure GroupBeforeEvent(var Valid: boolean); virtual;
    procedure GroupHeaderEvent; virtual;
    procedure RowBeforeEvent(var Valid: boolean); virtual;
    procedure RowPrintEvent(var Valid: boolean); virtual;
    procedure DetailBeforeEvent; virtual;
    procedure DetailAfterEvent; virtual;
    procedure RowAfterEvent(var Valid: boolean); virtual;
    procedure GroupFooterEvent; virtual;
    procedure GroupAfterEvent(var Valid: boolean); virtual;
    procedure GroupAfterLastEvent; virtual;
    procedure BodyFooterEvent; virtual;
    procedure BodyAfterEvent; virtual;

    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
    procedure PrintBody;
    function PrintGroup: boolean;
    procedure PrintMasterRow;
    procedure SetNewPage(Sender: TObject);
    function ValidateNextSection(ReportSection: TReportSection): boolean;
    procedure SetSectionBodyHeader(Value: TReportSection);
    procedure SetSectionBodyFooter(Value: TReportSection);
    procedure SetSectionRow(Value: TReportSection);
    procedure SetSectionGroupHeader(Value: TReportSection);
    procedure SetSectionGroupFooter(Value: TReportSection);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PrintBodyHeader;
    procedure PrintBodyFooter;
    procedure PrintRow;
    procedure Execute(Report: TBaseReport); override;

    property IsReprint: boolean read FIsReprint;
    property IsNewPage: boolean read FIsNewPage;

  published
    property SectionBodyHeader: TReportSection read FSectionBodyHeader
     write SetSectionBodyHeader;
    property SectionBodyFooter: TReportSection read FSectionBodyFooter
     write SetSectionBodyFooter;
    property SectionRow: TReportSection read FSectionRow write SetSectionRow;

    property StartNewPage: boolean read FStartNewPage write FStartNewPage
     default false;

    property OnBodyBefore: TReportEvent read FOnBodyBefore write FOnBodyBefore;
    property OnBodyHeader: TReportEvent read FOnBodyHeader write FOnBodyHeader;
    property OnRowBefore: TReportValidEvent read FOnRowBefore write FOnRowBefore;
    property OnRowPrint: TReportValidEvent read FOnRowPrint write FOnRowPrint;
    property OnRowAfter: TReportValidEvent read FOnRowAfter write FOnRowAfter;
    property OnBodyFooter: TReportEvent read FOnBodyFooter write FOnBodyFooter;
    property OnBodyAfter: TReportEvent read FOnBodyAfter write FOnBodyAfter;
  end; { TDetailShell }

{*************************************************************************}
{                            class TMasterShell                           }
{*************************************************************************}

  TMasterShell = class(TDetailShell)
  public
    procedure PrintGroupHeader;
    procedure PrintGroupFooter;
    procedure PrintDetail;

  published
    property DetailReport: TDetailShell read FDetailReport write FDetailReport;
    property Reprint: boolean read FReprint write FReprint default false;

    property SectionGroupHeader: TReportSection read FSectionGroupHeader
     write SetSectionGroupHeader;
    property SectionGroupFooter: TReportSection read FSectionGroupFooter
     write SetSectionGroupFooter;

    property OnGroupBeforeFirst: TReportEvent read FOnGroupBeforeFirst
     write FOnGroupBeforeFirst;
    property OnGroupBefore: TReportValidEvent read FOnGroupBefore
     write FOnGroupBefore;
    property OnGroupHeader: TReportEvent read FOnGroupHeader write FOnGroupHeader;
    property OnDetailBefore: TReportEvent read FOnDetailBefore write FOnDetailBefore;
    property OnDetailAfter: TReportEvent read FOnDetailAfter write FOnDetailAfter;
    property OnGroupFooter: TReportEvent read FOnGroupFooter write FOnGroupFooter;
    property OnGroupAfter: TReportValidEvent read FOnGroupAfter
     write FOnGroupAfter;
    property OnGroupAfterLast: TReportEvent read FOnGroupAfterLast
     write FOnGroupAfterLast;
  end; { TMasterShell }

{*************************************************************************}
{                            class TReportShell                           }
{*************************************************************************}

  TReportShell = class(TMasterShell)
  protected
    FSectionReportHeader: TReportSection;
    FSectionReportFooter: TReportSection;
    FSectionPageHeader: TReportSection;
    FSectionPageFooter: TReportSection;

    FOnReportBefore: TReportEvent;
    FOnReportHeader: TReportEvent;
    FOnPageBefore: TReportEvent;
    FOnPageHeader: TReportEvent;
    FOnPageFooter: TReportEvent;
    FOnPageAfter: TReportEvent;
    FOnReportFooter: TReportEvent;
    FOnReportAfter: TReportEvent;

    procedure ReportBeforeEvent; virtual;
    procedure ReportHeaderEvent; virtual;
    procedure PageBeforeEvent; virtual;
    procedure PageHeaderEvent; virtual;
    procedure PageFooterEvent; virtual;
    procedure PageAfterEvent; virtual;
    procedure ReportFooterEvent; virtual;
    procedure ReportAfterEvent; virtual;

    procedure BeginPage(Sender: TObject);
    procedure EndPage(Sender: TObject);
    procedure PrintReport;
    procedure SetSectionReportHeader(Value: TReportSection);
    procedure SetSectionReportFooter(Value: TReportSection);
    procedure SetSectionPageHeader(Value: TReportSection);
    procedure SetSectionPageFooter(Value: TReportSection);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure PrintReportHeader;
    procedure PrintReportFooter;
    procedure PrintPageHeader;
    procedure PrintPageFooter;
    procedure Execute(Report: TBaseReport); override;

  published
    property SectionReportHeader: TReportSection read FSectionReportHeader
     write SetSectionReportHeader;
    property SectionReportFooter: TReportSection read FSectionReportFooter
     write SetSectionReportFooter;
    property SectionPageHeader: TReportSection read FSectionPageHeader
     write SetSectionPageHeader;
    property SectionPageFooter: TReportSection read FSectionPageFooter
     write SetSectionPageFooter;

    property OnReportBefore: TReportEvent read FOnReportBefore write FOnReportBefore;
    property OnReportHeader: TReportEvent read FOnReportHeader write FOnReportHeader;
    property OnPageBefore: TReportEvent read FOnPageBefore write FOnPageBefore;
    property OnPageHeader: TReportEvent read FOnPageHeader write FOnPageHeader;
    property OnPageFooter: TReportEvent read FOnPageFooter write FOnPageFooter;
    property OnPageAfter: TReportEvent read FOnPageAfter write FOnPageAfter;
    property OnReportFooter: TReportEvent read FOnReportFooter write FOnReportFooter;
    property OnReportAfter: TReportEvent read FOnReportAfter write FOnReportAfter;
  end; { TReportShell }

implementation

{*************************************************************************}
{                            class TBaseShell                             }
{*************************************************************************}

  procedure TBaseShell.Notification(AComponent: TComponent;
                                    Operation: TOperation);

  begin { Notification }
    inherited Notification(AComponent,Operation);
    If (Operation = opRemove) and (AComponent = FEngine) then begin
      FEngine := nil;
    end; { if }
  end;  { Notification }

  procedure TBaseShell.SetEngine(Value: TRPComponent);

  begin { SetEngine }
    FEngine := Value;
    If Assigned(Value) then begin
      Value.FreeNotification(self);
    end; { if }
  end;  { SetEngine }

  procedure TBaseShell.StartExecute(Sender: TObject);

  begin { StartExecute }
    Execute(Sender as TBaseReport);
  end;  { StartExecute }

  function TBaseShell.InitEngine(Report: TBaseReport): boolean;

  begin { InitEngine }
    Result := true;
    If Assigned(Report) then begin
      If Report.Printing then begin
        ReportPrinter := Report;
      end else begin
        With Report do begin
          OnPrint := StartExecute;
          Execute;
          Result := false;
        end; { with }
      end; { else }
    end else if Engine <> nil then begin
      If Engine is TReportSystem then begin
        With Engine as TReportSystem do begin
          If BaseReport <> nil then begin
            ReportPrinter := BaseReport;
          end else begin
            OnPrint := StartExecute;
            Execute;
            Result := false;
          end; { else }
        end; { with }
      end else begin
        With Engine as TBaseReport do begin
          If Printing then begin
            ReportPrinter := Engine as TBaseReport;
          end else begin
            OnPrint := StartExecute;
            Execute;
            Result := false;
          end; { if }
        end; { with }
      end; { else }
    end else begin
      RaiseError(Trans('No reporting engine provided for report shell.'));
    end; { else }
  end;  { InitEngine }

{*************************************************************************}
{                            class TDetailShell                           }
{*************************************************************************}

  constructor TDetailShell.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);

    FSectionRow := TReportSection.Create;
    FSectionGroupHeader := TReportSection.Create;
    FSectionGroupFooter := TReportSection.Create;
    FSectionBodyHeader := TReportSection.Create;
    FSectionBodyFooter := TReportSection.Create;
    FStartNewPage := false;
    FReprint := false;
    FIsReprint := false;
    FIsNewPage := true;
    FDetailReport := nil;
    DoNewPage := false;
    Executing := false;
    RowPrinted := false;
  end;  { Create }

  destructor TDetailShell.Destroy;

  begin { Destroy }
    FSectionRow.Free;
    FSectionGroupHeader.Free;
    FSectionGroupFooter.Free;
    FSectionBodyHeader.Free;
    FSectionBodyFooter.Free;

    inherited Destroy;
  end;  { Destroy }

  procedure TDetailShell.Notification(AComponent: TComponent;
                                      Operation: TOperation);

  begin { Notification }
    inherited Notification(AComponent,Operation);
    If (Operation = opRemove) and (AComponent = FDetailReport) then begin
      FDetailReport := nil;
    end; { if }
  end;  { Notification }

  procedure TDetailShell.BodyBeforeEvent;

  begin { BodyBeforeEvent }
    If Assigned(FOnBodyBefore) then begin
      FOnBodyBefore(ReportPrinter,self);
    end; { if }
  end;  { BodyBeforeEvent }

  procedure TDetailShell.BodyHeaderEvent;

  begin { BodyHeaderEvent }
    If Assigned(FOnBodyHeader) then begin
      ValidateNextSection(FSectionBodyHeader);
      FOnBodyHeader(ReportPrinter,self);
    end; { if }
  end;  { BodyHeaderEvent }

  procedure TDetailShell.GroupBeforeFirstEvent;

  begin { GroupBeforeFirstEvent }
    If Assigned(FOnGroupBeforeFirst) then begin
      FOnGroupBeforeFirst(ReportPrinter,self);
    end; { if }
  end;  { GroupBeforeFirstEvent }

  procedure TDetailShell.GroupBeforeEvent(var Valid: boolean);

  begin { GroupBeforeEvent }
    If Assigned(FOnGroupBefore) then begin
      FOnGroupBefore(ReportPrinter,self,Valid);
    end; { if }
  end;  { GroupBeforeEvent }

  procedure TDetailShell.GroupHeaderEvent;

  begin { GroupHeaderEvent }
    If Assigned(FOnGroupHeader) then begin
      If DoNewPage then begin
        ReportPrinter.NewPage;
        DoNewPage := false;
      end; { if }
      ValidateNextSection(FSectionGroupHeader);
      FOnGroupHeader(ReportPrinter,self);
    end; { if }
  end;  { GroupHeaderEvent }

  procedure TDetailShell.RowBeforeEvent(var Valid: boolean);

  begin { RowBeforeEvent }
    If Assigned(FOnRowBefore) then begin
      FOnRowBefore(ReportPrinter,self,Valid);
    end; { if }
  end;  { RowBeforeEvent }

  procedure TDetailShell.RowPrintEvent(var Valid: boolean);

  begin { RowPrintEvent }
    If Assigned(FOnRowPrint) then begin
      If not ValidateNextSection(FSectionRow) and not FIsReprint then begin
        If Assigned(MasterShell) then begin
          MasterShell.PrintMasterRow;
          ValidateNextSection(FSectionRow);
        end; { if }
      end; { if }
      FOnRowPrint(ReportPrinter,self,Valid);
      FIsNewPage := false;
    end; { if }
  end;  { RowPrintEvent }

  procedure TDetailShell.DetailBeforeEvent;

  begin { DetailBeforeEvent }
    If Assigned(FOnDetailBefore) then begin
      FOnDetailBefore(ReportPrinter,self);
    end; { if }
  end;  { DetailBeforeEvent }

  procedure TDetailShell.DetailAfterEvent;

  begin { DetailAfterEvent }
    If Assigned(FOnDetailAfter) then begin
      FOnDetailAfter(ReportPrinter,self);
    end; { if }
  end;  { DetailAfterEvent }

  procedure TDetailShell.RowAfterEvent(var Valid: boolean);

  begin { RowAfterEvent }
    If Assigned(FOnRowAfter) then begin
      FOnRowAfter(ReportPrinter,self,Valid);
    end; { if }
  end;  { RowAfterEvent }

  procedure TDetailShell.GroupFooterEvent;

  begin { GroupFooterEvent }
    If Assigned(FOnGroupFooter) then begin
      ValidateNextSection(FSectionGroupFooter);
      FOnGroupFooter(ReportPrinter,self);
    end; { if }
  end;  { GroupFooterEvent }

  procedure TDetailShell.GroupAfterEvent(var Valid: boolean);

  begin { GroupAfterEvent }
    If Assigned(FOnGroupAfter) then begin
      FOnGroupAfter(ReportPrinter,self,Valid);
    end; { if }
  end;  { GroupAfterEvent }

  procedure TDetailShell.GroupAfterLastEvent;

  begin { GroupAfterLastEvent }
    If Assigned(FOnGroupAfterLast) then begin
      FOnGroupAfterLast(ReportPrinter,self);
    end; { if }
  end;  { GroupAfterLastEvent }

  procedure TDetailShell.BodyFooterEvent;

  begin { BodyFooterEvent }
    If Assigned(FOnBodyFooter) then begin
      ValidateNextSection(FSectionBodyFooter);
      FOnBodyFooter(ReportPrinter,self);
    end; { if }
  end;  { BodyFooterEvent }

  procedure TDetailShell.BodyAfterEvent;

  begin { BodyAfterEvent }
    If Assigned(FOnBodyAfter) then begin
      FOnBodyAfter(ReportPrinter,self);
    end; { if }
  end;  { BodyAfterEvent }

  function TDetailShell.ValidateNextSection(ReportSection: TReportSection): boolean;

  begin { ValidateNextSection }
    Result := not ReportSection.SetUpSection(ReportPrinter);
  end;  { ValidateNextSection }

  procedure TDetailShell.PrintBodyHeader;

  begin { PrintBodyHeader }
    FIsReprint := true;
    BodyHeaderEvent;
    FIsReprint := false;
  end;  { PrintBodyHeader }

  procedure TDetailShell.PrintBodyFooter;

  begin { PrintBodyFooter }
    FIsReprint := true;
    BodyFooterEvent;
    FIsReprint := false;
  end;  { PrintBodyFooter }

  procedure TDetailShell.PrintRow;

  var
    GroupOK: boolean;

  begin { PrintRow }
    GroupOK := true;
    FIsReprint := true;
    RowBeforeEvent(GroupOK);
    try
      If GroupOK then begin
        RowPrintEvent(GroupOK);
      end; { if }
    finally
      RowAfterEvent(GroupOK);
    end; { tryf }
    FIsReprint := false;
  end;  { PrintRow }

  procedure TDetailShell.SetNewPage(Sender: TObject);

  begin { SetNewPage }
    FIsNewPage := true;
  end;  { SetNewPage }

  procedure TDetailShell.SetSectionBodyHeader(Value: TReportSection);

  begin { SetSectionBodyHeader }
    FSectionBodyHeader.Assign(Value);
  end;  { SetSectionBodyHeader }

  procedure TDetailShell.SetSectionBodyFooter(Value: TReportSection);

  begin { SetSectionBodyFooter }
    FSectionBodyFooter.Assign(Value);
  end;  { SetSectionBodyFooter }

  procedure TDetailShell.SetSectionRow(Value: TReportSection);

  begin { SetSectionRow }
    FSectionRow.Assign(Value);
  end;  { SetSectionRow }

  procedure TDetailShell.SetSectionGroupHeader(Value: TReportSection);

  begin { SetSectionGroupHeader }
    FSectionGroupHeader.Assign(Value);
  end;  { SetSectionGroupHeader }

  procedure TDetailShell.SetSectionGroupFooter(Value: TReportSection);

  begin { SetSectionGroupFooter }
    FSectionGroupFooter.Assign(Value);
  end;  { SetSectionGroupFooter }

  procedure TDetailShell.PrintBody;

  begin { PrintBody }
    ReportPrinter.AddReportEvent(reBeginPage,SetNewPage);
    try
      BodyBeforeEvent;
      try
      { Print all groups }
        BodyHeaderEvent;
        GroupBeforeFirstEvent;
        try
          While PrintGroup do begin
            If StartNewPage and RowPrinted then begin
              DoNewPage := true;
            end; { if }
          end; { while }
        finally
          GroupAfterLastEvent;
        end; { tryf }
        BodyFooterEvent;
      finally
        BodyAfterEvent;
      end; { tryf }
    finally
      ReportPrinter.RemoveReportEvent(reBeginPage,SetNewPage);
    end; { tryf }
  end;  { PrintBody }

  procedure TDetailShell.PrintMasterRow;

  begin { PrintMasterRow }
    If Assigned(MasterShell) then begin
      MasterShell.PrintMasterRow;
    end; { if }
    If FReprint then begin
      PrintRow;
    end; { if }
  end;  { PrintMasterRow }

  function TDetailShell.PrintGroup: boolean;

  var
    GroupOK: boolean;

  begin { PrintGroup }
    GroupOK := true;

  { Print Group }
    GroupBeforeEvent(GroupOK);
    try
      If GroupOK then begin
      { Print Group Header }
        GroupHeaderEvent;

      { Print Row }
        RowBeforeEvent(GroupOK);
        try
          RowPrinted := GroupOK;
          If GroupOK then begin
            If DoNewPage then begin
              ReportPrinter.NewPage;
              DoNewPage := false;
            end; { if }
            RowPrintEvent(GroupOK);
          end; { if }
        finally
          RowAfterEvent(GroupOK);
        end; { tryf }

      { Print Detail }
        If GroupOK then begin
          DetailBeforeEvent;
          try
            If Assigned(FDetailReport) and not FDetailReport.Executing then begin
              FDetailReport.MasterShell := self;
              FDetailReport.Execute(FReportPrinter);
            end; { if }
          finally
            DetailAfterEvent;
          end; { tryf }
        end; { if }

      { Print Group Footer }
        GroupFooterEvent;
      end;  { if }
    finally
      GroupAfterEvent(GroupOK);
      Result := GroupOK;
    end; { tryf }
  end;  { PrintGroup }

  procedure TDetailShell.Execute(Report: TBaseReport);

  begin { Execute }
    If InitEngine(Report) then begin
      FIsReprint := false;
      FIsNewPage := true;
      Executing := true;
      try
        PrintBody;
      finally
        Executing := false;
        ReportPrinter := nil;
      end; { tryf }
    end; { if }
  end;  { Execute }

{*************************************************************************}
{                            class TMasterShell                           }
{*************************************************************************}

  procedure TMasterShell.PrintGroupHeader;

  begin { PrintGroupHeader }
    FIsReprint := true;
    GroupHeaderEvent;
    FIsReprint := false;
  end;  { PrintGroupHeader }

  procedure TMasterShell.PrintDetail;

  begin { PrintDetail }
    FIsReprint := true;
    DetailBeforeEvent;
    try
      If Assigned(FDetailReport) and not FDetailReport.Executing then begin
        FDetailReport.MasterShell := self;
        FDetailReport.Execute(ReportPrinter);
      end; { if }
    finally
      DetailAfterEvent;
    end; { tryf }
    FIsReprint := false;
  end;  { PrintDetail }

  procedure TMasterShell.PrintGroupFooter;

  begin { PrintGroupFooter }
    FIsReprint := true;
    GroupFooterEvent;
    FIsReprint := false;
  end;  { PrintGroupFooter }

{*************************************************************************}
{                            class TReportShell                           }
{*************************************************************************}

  constructor TReportShell.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);

    FSectionReportHeader := TReportSection.Create;
    FSectionReportFooter := TReportSection.Create;
    FSectionPageHeader := TReportSection.Create;
    FSectionPageFooter := TReportSection.Create;
    FSectionPageHeader.NoNewPage := true;
    FSectionPageFooter.NoNewPage := true;
  end;  { Create }

  destructor TReportShell.Destroy;

  begin { Destroy }
    FSectionReportHeader.Free;
    FSectionReportFooter.Free;
    FSectionPageHeader.Free;
    FSectionPageFooter.Free;

    inherited Destroy;
  end;  { Destroy }

  procedure TReportShell.ReportBeforeEvent;

  begin { ReportBeforeEvent }
    If Assigned(FOnReportBefore) then begin
      FOnReportBefore(ReportPrinter,self);
    end; { if }
  end;  { ReportBeforeEvent }

  procedure TReportShell.ReportHeaderEvent;

  begin { ReportHeaderEvent }
    If Assigned(FOnReportHeader) then begin
      ValidateNextSection(FSectionReportHeader);
      FOnReportHeader(ReportPrinter,self);
    end; { if }
  end;  { ReportHeaderEvent }

  procedure TReportShell.PageBeforeEvent;

  begin { PageBeforeEvent }
    If Assigned(FOnPageBefore) then begin
      FOnPageBefore(ReportPrinter,self);
    end; { if }
  end;  { PageBeforeEvent }

  procedure TReportShell.PageHeaderEvent;

  begin { PageHeaderEvent }
    If Assigned(FOnPageHeader) then begin
      ValidateNextSection(FSectionPageHeader);
      FOnPageHeader(ReportPrinter,self);
    end; { if }
  end;  { PageHeaderEvent }

  procedure TReportShell.PageFooterEvent;

  begin { PageFooterEvent }
    If Assigned(FOnPageFooter) then begin
      ValidateNextSection(FSectionPageFooter);
      FOnPageFooter(ReportPrinter,self);
    end; { if }
  end;  { PageFooterEvent }

  procedure TReportShell.PageAfterEvent;

  begin { PageAfterEvent }
    If Assigned(FOnPageAfter) then begin
      FOnPageAfter(ReportPrinter,self);
    end; { if }
  end;  { PageAfterEvent }

  procedure TReportShell.ReportFooterEvent;

  begin { ReportFooterEvent }
    If Assigned(FOnReportFooter) then begin
      ValidateNextSection(FSectionReportFooter);
      FOnReportFooter(ReportPrinter,self);
    end; { if }
  end;  { ReportFooterEvent }

  procedure TReportShell.ReportAfterEvent;

  begin { ReportAfterEvent }
    If Assigned(FOnReportAfter) then begin
      FOnReportAfter(ReportPrinter,self);
    end; { if }
  end;  { ReportAfterEvent }

  procedure TReportShell.SetSectionReportHeader(Value: TReportSection);

  begin { SetSectionReportHeader }
    FSectionReportHeader.Assign(Value);
  end;  { SetSectionReportHeader }

  procedure TReportShell.SetSectionReportFooter(Value: TReportSection);

  begin { SetSectionReportFooter }
    FSectionReportFooter.Assign(Value);
  end;  { SetSectionReportFooter }

  procedure TReportShell.SetSectionPageHeader(Value: TReportSection);

  begin { SetSectionPageHeader }
    FSectionPageHeader.Assign(Value);
  end;  { SetSectionPageHeader }

  procedure TReportShell.SetSectionPageFooter(Value: TReportSection);

  begin { SetSectionPageFooter }
    FSectionPageFooter.Assign(Value);
  end;  { SetSectionPageFooter }

  procedure TReportShell.PrintReportHeader;

  begin { PrintReportHeader }
    FIsReprint := true;
    ReportHeaderEvent;
    FIsReprint := false;
  end;  { PrintReportHeader }

  procedure TReportShell.PrintReportFooter;

  begin { PrintReportFooter }
    FIsReprint := true;
    ReportFooterEvent;
    FIsReprint := false;
  end;  { PrintReportFooter }

  procedure TReportShell.PrintPageHeader;

  begin { PrintPageHeader }
    FIsReprint := true;
    PageHeaderEvent;
    FIsReprint := false;
  end;  { PrintPageHeader }

  procedure TReportShell.PrintPageFooter;

  begin { PrintPageFooter }
    FIsReprint := true;
    PageFooterEvent;
    FIsReprint := false;
  end;  { PrintPageFooter }

  procedure TReportShell.BeginPage(Sender: TObject);

  begin { BeginPage }
    ReportPrinter := Sender as TBaseReport;
    PageBeforeEvent;
    PageHeaderEvent;
  end;  { BeginPage }

  procedure TReportShell.EndPage(Sender: TObject);

  begin { EndPage }
    ReportPrinter := Sender as TBaseReport;
    PageFooterEvent;
    PageAfterEvent;
  end;  { EndPage }

  procedure TReportShell.PrintReport;

  begin { PrintReport }
  { Add the page event handlers }
    ReportPrinter.AddReportEvent(reBeginPage,BeginPage);
    ReportPrinter.AddReportEvent(reEndPage,EndPage);
    try
      ReportBeforeEvent;
      try
        ReportHeaderEvent;
        BeginPage(ReportPrinter); { Call BeginPage for first page }
        PrintBody; { Print the body of the report }
        EndPage(ReportPrinter); { Call EndPage for last page }
        ReportFooterEvent;
      finally
        ReportAfterEvent;
      end; { tryf }
    finally
    { Remove the page event handlers }
      ReportPrinter.RemoveReportEvent(reBeginPage,BeginPage);
      ReportPrinter.RemoveReportEvent(reEndPage,EndPage);
    end; { tryf }
  end;  { PrintReport }

  procedure TReportShell.Execute(Report: TBaseReport);

  begin { Execute }
    If InitEngine(Report) then begin
      FIsReprint := false;
      FIsNewPage := true;
      Executing := true;
      try
        PrintReport;
      finally
        Executing := false;
        ReportPrinter := nil;
      end; { tryf }
    end; { if }
  end;  { Execute }

end.