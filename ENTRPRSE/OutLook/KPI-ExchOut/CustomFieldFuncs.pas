unit CustomFieldFuncs;

interface

uses StdCtrls, Enterprise01_TLB, ExchTypes;

function NumberOfVisibleUDFs(const Edits : Array of TCustomEdit) : Integer;
procedure ResizeUDFParentContainer(VisibleFieldCount: Integer; RowLength: Integer; ParentContainer: TObject; RowHeightOverRide: Integer = 0);
procedure ArrangeUDFs(const Captions : Array of TLabel; const Edits : Array of TCustomEdit);
procedure EnableUDFs(oToolkit: IToolkit;
                     const Captions : array of TLabel;
                     const Edits : array of TCustomEdit;
                     DocType: TDocTypes;
                     Arrange : Boolean = True);

implementation

uses Forms, Controls, SBSPanel;

function NumberOfVisibleUDFs(const Edits : Array of TCustomEdit) : Integer;
var
  i : Integer;
begin
  Result := 0;
  for i := Low(Edits) to High(Edits) do
    if Edits[i].Visible then inc(Result);
end;

//-------------------------------------------------------------------------

//procedure to adjust the height of the parent control of the UDEFs
//so that multiple hidden fields do not leave blank spaces.

//Parameters:
//VisibleFieldCount     - the number of UDFs that have their visibility property set to true
//RowLength             - the number of UDFs that make up a row on the user interface
//                        (typically UDFs are positioned on the UI as 1(c)olumn x 10(r)ow, 2c x 5r, 5c x 2r)
//ParentContainer       - the control that contains the UDF controls (such as a TForm or TSBSExtendedForm)
procedure ResizeUDFParentContainer(VisibleFieldCount: Integer; RowLength: Integer; ParentContainer: TObject; RowHeightOverRide: Integer = 0);
const
  //this is the pre-set height offset;                                                        -
  //for every row of UDEFs that are hidden; the container control will have it's height reduced by this amount
  ROW_HEIGHT = 23;
  //the total number of UDFs - recently been expanded to 10
  UDF_COUNT = 10;
var
  //stores the number of hidden UDFs
  HiddenFieldCount: Integer;
  //stores the number of hidden rows of UDFs
  HiddenRowCount: Integer;
  //this holds the sum amount that the container control needs to be adjusted by
  ContainerHeightOffset: Integer;
  ExtendedFormObj: TSBSExtendedForm;
begin
  //firstly, determine if we need to resize the container control;
  //if no DUFs are being hidden, we don't need to adjust the height
  if VisibleFieldCount <= (UDF_COUNT - RowLength) then
  begin
    //next, we need to determine how many rows of UDFs are hidden, so..

    //determine how many UD fields are hidden by subtracting the # of visible fields from the total # of fields
    HiddenFieldCount := UDF_COUNT - VisibleFieldCount;
    //now that we know how many individual UDFs are hidden, we can determine how many rows are hidden
    //by dividing the result by the length of a row
    HiddenRowCount := HiddenFieldCount div RowLength;
    //with the hidden row count, we can now calculate how much hight we need to subtract from the parent container
    //to remove the blank space that any hidden UDF rows will leave behind

    if RowHeightOverRide < 1 then
    begin
      ContainerHeightOffset := ROW_HEIGHT * HiddenRowCount;
    end
    else
    begin
      ContainerHeightOffset := RowHeightOverRide * HiddenRowCount;
    end;
    //finally, apply the height offset to the parent containers height property
    //currently this supports parent container property types of:
    //TSBSExtendedForm
    //TForm
    if ParentContainer Is TSBSExtendedForm then
    begin
      ExtendedFormObj := TSBSExtendedForm(ParentContainer);
      if VisibleFieldCount > 0 then
      begin
        ExtendedFormObj.ExpandedHeight := ExtendedFormObj.ExpandedHeight - ContainerHeightOffset;
      end
      else
      begin
        //GS 16/04/2012 ABSEXCH-12808: logic error when resizing the udf parent container when all fields are hidden;
        //it hides the whole drop-down form; but there could be fields other than UDfs on the form..
        ExtendedFormObj.ExpandedHeight := ExtendedFormObj.ExpandedHeight - ContainerHeightOffset;
        //ExtendedFormObj.ExpandedWidth := ExtendedFormObj.OrigWidth;
        //ExtendedFormObj.ExpandedHeight := ExtendedFormObj.OrigHeight;
      end;
    end
    else if ParentContainer Is TSBSPanel then
    begin
      TSBSPanel(ParentContainer).Height := TSBSPanel(ParentContainer).Height - ContainerHeightOffset;
    end
    else if ParentContainer Is TForm then
    begin
      TForm(ParentContainer).Height := TForm(ParentContainer).Height - ContainerHeightOffset;
    end
    else if ParentContainer Is TControl then
    begin
      TControl(ParentContainer).Top := TControl(ParentContainer).Top - ContainerHeightOffset;
    end;
  end;
end;

//-------------------------------------------------------------------------

procedure ArrangeUDFs(const Captions : Array of TLabel; const Edits : Array of TCustomEdit);
var
  i, j : Integer;
begin
  if NumberOfVisibleUDFs(Edits) > 0 then
  begin
    i := 0;
    while i <= High(Edits) do
    begin
      if not Edits[i].Visible then
        for j := High(Edits) downto i + 1 do
        begin
          if j > Low(Edits) then
          begin
           //Move position of edit
           Edits[j].Top := Edits[j-1].Top;
           Edits[j].Left := Edits[j-1].Left;

           //PR: 11/11/2011 In some circumstances, (allocation wizard for one), one column of
           //Udfs has their labels right-aligned and the other has theirs left-aligned.
           //If we're moving between the two columns then we need to adjust accordingly.
           if Captions[j].Alignment <> Captions[j-1].Alignment then
           begin
             Captions[j].AutoSize := Captions[j-1].Autosize;
             Captions[j].Width := Captions[j-1].Width;
             Captions[j].Alignment := Captions[j-1].Alignment;
           end;

           //Move position of label
           Captions[j].Top := Captions[j-1].Top;
           Captions[j].Left := Captions[j-1].Left;

          end;
        end;
      inc(i);
    end;
  end;
end;

//-------------------------------------------------------------------------

procedure EnableUDFs(oToolkit: IToolkit;
                     const Captions : array of TLabel;
                     const Edits : array of TCustomEdit;
                     DocType: TDocTypes;
                     Arrange : Boolean = True);
var
  i : integer;
  HighestVisible : TCustomEdit;
  oUserFields: ISystemSetupUserFields3;
begin
  Assert(High(Edits) = High(Captions), 'Number of edits must equal number of captions.');
  HighestVisible := nil;

  //Run through edits setting visiblity and captions.
  oUserFields := (oToolkit.SystemSetup.ssUserFields as ISystemSetupUserFields3);
  for i := Low(Edits) to High(Edits) do
  begin
    case DocType of
      dtSIN,
      dtSRI,
      dtSCR,
      dtSRF,
      dtSJI,
      dtSJC:
        begin
          Captions[i].Caption := oUserFields.ufSINDesc[i + 1];
          Edits[i].Visible    := oUserFields.ufSINEnabled[i + 1];
        end;
      dtSRC:
        begin
          Captions[i].Caption := oUserFields.ufSRCDesc[i + 1];
          Edits[i].Visible    := oUserFields.ufSRCEnabled[i + 1];
        end;
      dtSQU:
        begin
          Captions[i].Caption := oUserFields.ufSQUDesc[i + 1];
          Edits[i].Visible    := oUserFields.ufSQUEnabled[i + 1];
        end;
      dtSOR,
      dtSDN:
        begin
          Captions[i].Caption := oUserFields.ufSORDesc[i + 1];
          Edits[i].Visible    := oUserFields.ufSOREnabled[i + 1];
        end;
      dtPIN,
      dtPPI,
      dtPCR,
      dtPRF,
      dtPJI,
      dtPJC:
        begin
          Captions[i].Caption := oUserFields.ufPINDesc[i + 1];
          Edits[i].Visible    := oUserFields.ufPINEnabled[i + 1];
        end;
      dtPPY:
        begin
          Captions[i].Caption := oUserFields.ufPPYDesc[i + 1];
          Edits[i].Visible    := oUserFields.ufPPYEnabled[i + 1];
        end;
      dtPQU:
        begin
          Captions[i].Caption := oUserFields.ufPQUDesc[i + 1];
          Edits[i].Visible    := oUserFields.ufPQUEnabled[i + 1];
        end;
      dtPOR,
      dtPDN:
        begin
          Captions[i].Caption := oUserFields.ufPORDesc[i + 1];
          Edits[i].Visible    := oUserFields.ufPOREnabled[i + 1];
        end;
      dtNMT:
        begin
          Captions[i].Caption := oUserFields.ufNOMDesc[i + 1];
          Edits[i].Visible    := oUserFields.ufNOMEnabled[i + 1];
        end;
      dtADJ:
        begin
          Captions[i].Caption := oUserFields.ufADJDesc[i + 1];
          Edits[i].Visible    := oUserFields.ufADJEnabled[i + 1];
        end;
      dtWOR:
        begin
          Captions[i].Caption := oUserFields.ufWORDesc[i + 1];
          Edits[i].Visible    := oUserFields.ufWOREnabled[i + 1];
        end;
      dtTSH:
        begin
          Captions[i].Caption := oUserFields.ufTSHDesc[i + 1];
          Edits[i].Visible    := oUserFields.ufTSHEnabled[i + 1];
        end;
      dtSRN:
        begin
          Captions[i].Caption := oUserFields.ufSRNDesc[i + 1];
          Edits[i].Visible    := oUserFields.ufSRNEnabled[i + 1];
        end;
      dtPRN:
        begin
          Captions[i].Caption := oUserFields.ufPRNDesc[i + 1];
          Edits[i].Visible    := oUserFields.ufPRNEnabled[i + 1];
        end;
    end;
    Captions[i].Visible := Edits[i].Visible;
    if Edits[i].Visible then
    begin
      //If we're using a weirdo drop-down thingy, then we need to keep track of the last
      //visible edit so we can set it as FocusLast
      if not Assigned(HighestVisible) or (Edits[i].TabOrder > HighestVisible.TabOrder) then
        HighestVisible := Edits[i];
    end;
  end; //for i

  if Arrange then
    ArrangeUDFs(Captions, Edits);

  //Assign FocusLast if necessary.
  if Assigned(HighestVisible) and (HighestVisible.Parent is TSBSExtendedForm) then
    with HighestVisible.Parent as TSBSExtendedForm do
      FocusLast := HighestVisible;
end;

//-------------------------------------------------------------------------

end.
