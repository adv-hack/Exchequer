{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVPDEvnt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Buttons, RVClass, TypInfo, RPDefine, RVProj,
  RVTool, RVData, RVLEMod, RVLEUtil, RVLEID, RVLEDef;

type
  TSourceEditorForm = class(TForm)
    SourceEditorPanel: TPanel;
    Panel3: TPanel;
    Splitter2: TSplitter;
    Panel1: TPanel;
    Splitter1: TSplitter;
    DefinedLB: TListBox;
    EventDesc: TRichEdit;
    Panel2: TPanel;
    Panel4: TPanel;
    AvailableCB: TComboBox;
    btnShowSelectedEvents: TSpeedButton;
    btnShowPageEvents: TSpeedButton;
    butnCompile: TButton;
    Label1: TLabel;
    Label2: TLabel;
    SyntaxMemo: TMemo;
    procedure DefinedLBClick(Sender: TObject);
    procedure AvailableCBClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnShowSelectedEventsClick(Sender: TObject);
    procedure btnShowPageEventsClick(Sender: TObject);
    procedure butnCompileClick(Sender: TObject);
    procedure SyntaxMemoChange(Sender: TObject);
    procedure EventDescEnter(Sender: TObject);
  private
    Instance: TRaveComponent;
    CurrPage: TRavePage;
    Event: TRaveEvent;

    procedure SaveCurrentEvent;
    procedure SelectEvent(EventName: string);
  public
    procedure FillEventDesc;
    procedure Setup;
    procedure Finish;
  end;

  TRaveEventDesigner = class(TRaveProjectDesigner)
  protected
    function GetTitle: string; override;
  public
    procedure SelectionChanged; override;
    procedure Modified; override;
    procedure Enter; override;
    procedure Exit; override;
    procedure Connect(Parent: TWinControl); override;
    procedure Disconnect; override;
  end; { TRaveEventDesigner }

var
  SourceEditorForm: TSourceEditorForm;

  procedure RaveRegister;

implementation

{$R *.DFM}

  procedure RaveRegister;

  begin { RaveRegister }
    SourceEditorForm := TSourceEditorForm.Create(Application);
    RegisterRaveProjectDesigner(TRaveEventDesigner);
  end;  { RaveRegister }

(*****************************************************************************}
( class TRaveEventDesigner
(*****************************************************************************)

  function TRaveEventDesigner.GetTitle: string;

  begin { GetTitle }
    Result := Trans('Event Editor');
  end;  { GetTitle }

  procedure TRaveEventDesigner.SelectionChanged;

  begin { SelectionChanged }
    SourceEditorForm.Setup;
  end;  { SelectionChanged }

  procedure TRaveEventDesigner.Modified;

  begin { Modified }
  end;  { Modified }

  procedure TRaveEventDesigner.Enter;

  begin { Enter }
    SourceEditorForm.Setup;
  end;  { Enter }

  procedure TRaveEventDesigner.Exit;

  begin { Exit }
    SourceEditorForm.Finish;
  end;  { Exit }

  procedure TRaveEventDesigner.Connect(Parent: TWinControl);

  begin { Connect }
    SourceEditorForm.SourceEditorPanel.Parent := Parent;
  end;  { Connect }

  procedure TRaveEventDesigner.Disconnect;

  begin { Disconnect }
    SourceEditorForm.SourceEditorPanel.Parent := SourceEditorForm;
  end;  { Disconnect }

(*****************************************************************************}
( class TSourceEditorForm
(*****************************************************************************)

  procedure TSourceEditorForm.FillEventDesc;

  var
    S1,S2: string;
    EventType: string;

    procedure SetCellAttribs(NewStyle: TFontStyles);

    begin
      With EventDesc,SelAttributes do begin
        Size := 10;
        Style := NewStyle;
        Color := clBlack;
      end; { with }
    end;

  begin { FillEventDesc }
  { Initialize EventDesc }
    With EventDesc do begin
      Clear;
    {TransOff}

    // Component/Event name line
      With SelAttributes do begin
        Name := {Trans-}'Arial';
        Size := 14;
        Style := [fsBold,fsUnderline];
        Color := clNavy;
      end; { with }
      If Assigned(Instance) then begin
        If DefinedLB.ItemIndex >= 0 then begin
          EventType := DefinedLB.Items[DefinedLB.ItemIndex];
          if Pos('.',EventType) > 0 then begin
            EventType := Copy(EventType,Pos('.',EventType) + 1, Length(EventType));
          end; { if }
          S1 := GetPropDescProc(Instance.ClassType,EventType);
          If Pos('|',S1) > 0 then begin
            S2 := Copy(S1, Pos('|',S1) + 1, Length(S1));
            S1 := Copy(S1, 0, Pos('|',S1) - 1);
          end else begin
            S2 := 'none';
          end; { else }
          If btnShowSelectedEvents.Down then begin
            Lines.Add(Instance.Name + ' ' + DefinedLB.Items[DefinedLB.ItemIndex] + ' event');
          end else begin
            Lines.Add(DefinedLB.Items[DefinedLB.ItemIndex] + ' event');
          end; { else }

        // Parameters and Description
          Lines.Add('');
          SetCellAttribs([]);
          Lines.Add('Parameters: ' + S2);
          Lines.Add('');
          SetCellAttribs([]);
          Lines.Add('Description: ' + S1);
          Lines.Add('');
          EventDesc.SelStart := FindText('Parameters:',0,Length(Lines.Text),[stWholeWord,stMatchCase]);
          EventDesc.SelLength := Length('Parameters:');
          SetCellAttribs([fsBold]);
          EventDesc.SelStart := FindText('Description:',0,Length(Lines.Text),[stWholeWord,stMatchCase]);
          EventDesc.SelLength := Length('Description:');
          SetCellAttribs([fsBold]);

        end else begin
          Lines.Add(Instance.Name + ' (No events defined)');
        end; { else }
      end else begin
        Lines.Add('(No component selected)');
      end; { else }
    {TransOn}
    end; { with }
  end;  { FillEventDesc }

  procedure TSourceEditorForm.Setup;

  var
    Count: integer;
    PropList: PPropList;
    PropInfo: PPropInfo;
    I1: integer;

  begin { Setup }
    If not Assigned(CurrentDesigner) then Exit;

  { Find selected component }
    If CurrentDesigner.Selections = 0 then begin
      Instance := nil;
    end else begin
      Instance := CurrentDesigner.Selection[0];
    end; { else }

  { Init AvailableCB and DefinedLB }
    AvailableCB.Clear;
    DefinedLB.Clear;
    EventDesc.Clear;
    SyntaxMemo.Clear;
    Event := nil;

    If Assigned(Instance) then begin
      AvailableCB.Enabled := true;
      DefinedLB.Enabled := true;
      Count := GetPropList(Instance.ClassInfo,tkProperties,nil);
      GetMem(PropList,Count * SizeOf(pointer));
      try
        GetPropList(Instance.ClassInfo,tkProperties,PropList);
        For I1 := 0 to Count - 1 do begin
          PropInfo := PropList^[I1];

        { Don't display if property is not visible }
//!!!!    If not PropertyVisible(Instance.ClassType,PropInfo.Name) then Continue;

        { Don't show non-event properties }
          If (PropInfo.PropType^.Kind <> tkClass) or not GetTypeData(
           PropInfo.PropType^).ClassType.InheritsFrom(TRaveEvent) then Continue;

          If GetOrdProp(Instance,PropInfo) = 0 then begin
            AvailableCB.Items.Add(PropInfo.Name);
          end else begin
            DefinedLB.Items.Add(PropInfo.Name);
          end; { else }
        end; { for }
      finally
        FreeMem(PropList,Count * SizeOf(pointer));
      end; { tryf }

      If AvailableCB.Items.Count = 0 then begin
        AvailableCB.Enabled := false;
      end; { if }
      If DefinedLB.Items.Count = 0 then begin
        DefinedLB.Enabled := false;
      end else begin
        DefinedLB.ItemIndex := 0;
        DefinedLBClick(DefinedLB);
      end; { else }
    end else begin
      AvailableCB.Enabled := false;
      DefinedLB.Enabled := false;
    end; { else }
    if btnShowPageEvents.Down then begin
      btnShowPageEventsClick(btnShowPageEvents);
    end else begin
     FillEventDesc;
    end; { else }
    butnCompile.Enabled := DefinedLB.Items.Count > 0;
    SyntaxMemo.ReadOnly := not butnCompile.Enabled;
  end;  { Setup }

  procedure TSourceEditorForm.Finish;

  begin { Finish }
    SaveCurrentEvent;
  end;  { Finish }

  procedure TSourceEditorForm.SaveCurrentEvent;

  begin { SaveCurrentEvent }
    If Assigned(Event) then begin
      If Event.Body <> SyntaxMemo.Text then begin
        ProjectManager.DataChanged := true;
        Event.Body := SyntaxMemo.Text;
      end; { if }
      Event := nil;
    end; { if }
  end;  { SaveCurrentEvent }

  procedure TSourceEditorForm.DefinedLBClick(Sender: TObject);

  var
    I1: integer;
    EventName: string;

  begin
    SaveCurrentEvent;

    EventName := DefinedLB.Items[DefinedLB.ItemIndex];
    I1 := Pos('.',EventName);
    If I1 > 0 then begin
      Instance := CurrPage.FindComponent(Copy(EventName,1,I1 - 1)) as TRaveComponent;
      Delete(EventName,1,I1);
    end; { if }
    Event := TRaveEvent(GetOrdProp(Instance,
    GetPropInfo(Instance.ClassInfo,EventName)));

    FillEventDesc;

  { Initialize SyntaxMemo }
    With SyntaxMemo do begin
      Text := Event.Body;
    end; { with }

    butnCompile.Enabled := DefinedLB.Items.Count > 0;
    SyntaxMemo.ReadOnly := not butnCompile.Enabled;
  end; { DefinedLBClick }

  procedure TSourceEditorForm.AvailableCBClick(Sender: TObject);

  var
    PropInfo: PPropInfo;
    TypeData: PTypeData;

  begin
    SaveCurrentEvent;
    If AvailableCB.Text = '' then Exit;

  { Create event and open in editor }
    PropInfo := GetPropInfo(Instance.ClassInfo,AvailableCB.Text);
    TypeData := GetTypeData(PropInfo^.PropType^);
    Event := TRaveEvent(GetOrdProp(Instance,PropInfo));
    If not Assigned(Event) then begin { Create event }
      Event := TypeData.ClassType.NewInstance as TRaveEvent;
      Event.Create;
      Event.Owner := Instance;
      SetOrdProp(Instance,PropInfo,integer(Event));
    end else begin
    //!!! Error, defined events shouldn't be in AvailableCB
    end; { if }

  { Remove event name from AvailableCB, add to DefinedLB and make active }
    DefinedLB.Enabled := true;
    DefinedLB.ItemIndex := DefinedLB.Items.Add(AvailableCB.Text);
    AvailableCB.Items.Delete(AvailableCB.ItemIndex);
    If AvailableCB.Items.Count = 0 then begin
      AvailableCB.Enabled := false;
    end; { if }
    SyntaxMemo.Text := Event.Body;
    DefinedLBClick(DefinedLB);
    ProjectManager.DataChanged := true;
  end;

procedure TSourceEditorForm.FormCreate(Sender: TObject);
begin
  FormTrans(self);
end;

procedure TSourceEditorForm.btnShowSelectedEventsClick(Sender: TObject);
begin
  SaveCurrentEvent;
  AvailableCB.Enabled := true;
  Setup;
end;

procedure TSourceEditorForm.btnShowPageEventsClick(Sender: TObject);

var
  Count: integer;
  PropList: PPropList;
  PropInfo: PPropInfo;
  I1: integer;
  I2: integer;

begin
  SaveCurrentEvent;

{ Find selected component }
  If CurrentDesigner.Selections = 0 then begin
    CurrPage := nil;
  end else begin
    CurrPage := CurrentDesigner.Selection[0].Page;
  end; { else }

{ Init AvailableCB and DefinedLB }
  AvailableCB.Clear;
  AvailableCB.Enabled := false;
  DefinedLB.Clear;
  EventDesc.Clear;
  SyntaxMemo.Clear;

  If Assigned(CurrPage) then begin
    DefinedLB.Enabled := true;
    For I2 := 0 to (CurrPage.ComponentCount - 1) do begin
      Instance := CurrPage.Components[I2] as TRaveComponent;

      Count := GetPropList(Instance.ClassInfo,tkProperties,nil);
      GetMem(PropList,Count * SizeOf(pointer));
      try
        GetPropList(Instance.ClassInfo,tkProperties,PropList);
        For I1 := 0 to Count - 1 do begin
          PropInfo := PropList^[I1];

        { Don't display if property is not visible }
//!!!     If not PropertyVisible(Instance.ClassType,PropInfo.Name) then Continue;

        { Don't show non-event properties }
          If (PropInfo.PropType^.Kind <> tkClass) or not GetTypeData(
           PropInfo.PropType^).ClassType.InheritsFrom(TRaveEvent) then Continue;

          If GetOrdProp(Instance,PropInfo) <> 0 then begin
            DefinedLB.Items.Add(Instance.Name + '.' + PropInfo.Name);
          end; { if }
        end; { for }
      finally
        FreeMem(PropList,Count * SizeOf(pointer));
      end; { tryf }
    end; { for }

    If AvailableCB.Items.Count = 0 then begin
      AvailableCB.Enabled := false;
    end; { if }
    If DefinedLB.Items.Count = 0 then begin
      DefinedLB.Enabled := false;
    end else begin
      DefinedLB.ItemIndex := 0;
      DefinedLBClick(DefinedLB);
    end; { else }
  end else begin
    DefinedLB.Enabled := false;
  end; { else }
end;

procedure TSourceEditorForm.SelectEvent(EventName: string);

var
  I1: integer;

begin { SelectEvent }
  For I1 := 0 to DefinedLB.Items.Count - 1 do begin
    If CompareText(EventName,DefinedLB.Items[I1]) = 0 then begin
      DefinedLB.ItemIndex := I1;
    end; { if }
  end; { for }
end;  { SelectEvent }

procedure TSourceEditorForm.butnCompileClick(Sender: TObject);

type
  TActionProc = procedure(aProjectItem: TRaveProjectItem);

var
  ErrorFound: boolean;

  procedure ActionBuildSource(aProjectItem: TRaveProjectItem);

  begin { ActionBuildSource }
  { Create module }
    If Assigned(aProjectItem.Module) then begin
      aProjectItem.Module.Free;
    end; { if }
    aProjectItem.Module := TRCPUModule.Create;
    With TRCPUModule(aProjectItem.Module) do begin
      ProjectManager := aProjectItem.Project;
      ProjectItem := aProjectItem;
      BuildSource;
    end; { with }
  end;  { ActionBuildSource }

  procedure ActionDefCompile(aProjectItem: TRaveProjectItem);

  begin { ActionDefCompile }
    CurrentModule := TRCPUModule(aProjectItem.Module);
    CurrentModule.Compile(true);
  end;  { ActionDefCompile }

  procedure ActionImpCompile(aProjectItem: TRaveProjectItem);

  begin { ActionImpCompile }
    CurrentModule := TRCPUModule(aProjectItem.Module);
    CurrentModule.Compile(false);
  end;  { ActionImpCompile }

  procedure ActionFixUp(aProjectItem: TRaveProjectItem);

  begin { ActionFixUp }
  // Fix up any cross module references
  end;  { ActionFixUp }

  procedure ActionEventConnect(aProjectItem: TRaveProjectItem);

  var
    I1: integer;
    RaveEvent: TRaveEvent;
    BaseID: TBaseID;
    EventList: TStrings;

  begin { ActionEventConnect }
  { Point Rave events to function offsets }
    EventList := TRCPUModule(aProjectItem.Module).EventList;
    For I1 := 0 to EventList.Count - 1 do begin
      RaveEvent := TRaveEvent(EventList.Objects[I1]);
      BaseID := TRCPUModule(aProjectItem.Module).FindID(EventList[I1]);
      If BaseID is TFuncID then begin
        RaveEvent.Position := TFuncID(BaseID).CodeLabel.Offset;
      end; { if }
      RaveEvent.ModuleOwner := aProjectItem;
    end; { for }
  end;  { ActionEventConnect }

  procedure PerformAction(aProjectItem: TRaveProjectItem;
                          ActionProc: TActionProc);

  var
    I1: integer;

  begin { PerformAction }
    ActionProc(aProjectItem);
    If (aProjectItem is TRaveProjectManager) or (aProjectItem is TRaveReport) then begin
      For I1 := 0 to aProjectItem.ComponentCount - 1 do begin
        If aProjectItem.Components[I1] is TRaveProjectItem then begin
          PerformAction(TRaveProjectItem(aProjectItem.Components[I1]),ActionProc);
        end; { if }
      end; { for }
    end; { if }
  end;  { PerformAction }

  function GetEventName(Event: TRaveEvent): string;

  var
    Count: integer;
    PropList: PPropList;
    PropInfo: PPropInfo;
    I1: integer;

  begin { GetEventName }
    Result := '';
    Count := GetTypeData(Event.Owner.ClassInfo)^.PropCount;
    If Count > 0 then begin
      GetMem(PropList,Count * SizeOf(pointer));
      try
        GetPropInfos(Event.Owner.ClassInfo,PropList);
        For I1 := 0 to (Count - 1) do begin
          PropInfo := PropList^[I1];
          If (PropInfo.PropType^.Kind = tkClass) and
           (TRaveEvent(GetOrdProp(Event.Owner,PropInfo)) = Event) then begin
            Result := PropInfo.Name;
            Exit;
          end; { if }
        end; { for }
      finally
        FreeMem(PropList,Count * SizeOf(pointer));
      end; { tryf }
    end; { if }
  end;  { GetEventName }

begin
  SaveCurrentEvent;
  ErrorFound := false;
  try
  // Create source for all modules
    PerformAction(ProjectManager,@ActionBuildSource);

  // Perform Definition only compiles
    PerformAction(ProjectManager,@ActionDefCompile);

  // Compile Implementation compiles
    PerformAction(ProjectManager,@ActionImpCompile);

  // Fix up cross module references
    PerformAction(ProjectManager,@ActionFixUp);

  // Point events to function locations
    PerformAction(ProjectManager,@ActionEventConnect);
  except
    on E: ERaveCompiler do begin
    // Go to event and line where error occured
      If Assigned(ErrorEvent) then begin
        CurrentDesigner.ClearSelection;
        CurrentDesigner.SelectControl(ErrorEvent.Owner);
        Setup;
        SelectEvent(GetEventName(ErrorEvent));
        While SyntaxMemo.CaretPos.y < ErrorLine - ErrorEvent.SourceLine do begin // move to line
          SyntaxMemo.SelStart := SyntaxMemo.SelStart + 1;
        end; { while }
        While (ErrorCol - 3 < Length(SyntaxMemo.Text)) and (SyntaxMemo.CaretPos.x < ErrorCol - 3) do begin // move to column
          SyntaxMemo.SelStart := SyntaxMemo.SelStart + 1;
        end; { while }
      end; { if }

    // Show error message
      ShowMessage(E.Message);
      ErrorFound := true;
      SyntaxMemo.SetFocus;
    end;
  end; { tryx }

  If not ErrorFound then begin
    DefinedLBClick(DefinedLB);
    SyntaxMemo.SetFocus;
    ShowMessage('Compile finished.');
  end; { if }
end;

procedure TSourceEditorForm.SyntaxMemoChange(Sender: TObject);
begin
  If Assigned(Event) then begin
    If Event.Body <> SyntaxMemo.Text then begin
      ProjectManager.DataChanged := true;
      Event.Body := SyntaxMemo.Text;
    end; { if }
  end; { if }
end;

procedure TSourceEditorForm.EventDescEnter(Sender: TObject);
begin
  SyntaxMemo.SetFocus;
end;

initialization
  RegisterProc('RVCL',RaveRegister);
end.
