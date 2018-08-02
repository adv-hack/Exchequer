{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPSecFrm;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, RPDefine, RPSect, ComCtrls;

type
  TSectionEditForm = class(TForm)
    LeftGB: TGroupBox;
    LeftED: TEdit;
    LeftCB: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    RightGB: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    RightED: TEdit;
    RightCB: TComboBox;
    TopGB: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    TopED: TEdit;
    TopCB: TComboBox;
    BottomGB: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    BottomED: TEdit;
    BottomCB: TComboBox;
    PageGB: TGroupBox;
    Image1: TImage;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    EnabledCK: TCheckBox;
    HeightGB: TGroupBox;
    Label9: TLabel;
    Label11: TLabel;
    HeightED: TEdit;
    UnitsCB: TComboBox;
    SetupGB: TGroupBox;
    Label12: TLabel;
    TabIndexED: TEdit;
    Label13: TLabel;
    FontIndexED: TEdit;
    procedure LeftCBChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RightCBChange(Sender: TObject);
    procedure TopCBChange(Sender: TObject);
    procedure BottomCBChange(Sender: TObject);
    procedure UnitsCBChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EnabledCKClick(Sender: TObject);
    procedure LeftEDKeyPress(Sender: TObject; var Key: Char);
    procedure LeftEDExit(Sender: TObject);
    procedure RightEDExit(Sender: TObject);
    procedure RightEDKeyPress(Sender: TObject; var Key: Char);
    procedure TopEDKeyPress(Sender: TObject; var Key: Char);
    procedure TopEDExit(Sender: TObject);
    procedure BottomEDKeyPress(Sender: TObject; var Key: Char);
    procedure BottomEDExit(Sender: TObject);
    procedure TabIndexEDExit(Sender: TObject);
    procedure TabIndexEDKeyPress(Sender: TObject; var Key: Char);
    procedure FontIndexEDExit(Sender: TObject);
    procedure FontIndexEDKeyPress(Sender: TObject; var Key: Char);
    procedure HeightEDExit(Sender: TObject);
    procedure HeightEDKeyPress(Sender: TObject; var Key: Char);
  private
    procedure DrawImage;
    procedure UpdateForm;

    procedure LeftDownClick(Sender: TObject);
    procedure LeftUpClick(Sender: TObject);
    procedure RightDownClick(Sender: TObject);
    procedure RightUpClick(Sender: TObject);
    procedure TopDownClick(Sender: TObject);
    procedure TopUpClick(Sender: TObject);
    procedure BottomDownClick(Sender: TObject);
    procedure BottomUpClick(Sender: TObject);
    procedure HeightDownClick(Sender: TObject);
    procedure HeightUpClick(Sender: TObject);
    procedure TabDownClick(Sender: TObject);
    procedure TabUpClick(Sender: TObject);
    procedure FontDownClick(Sender: TObject);
    procedure FontUpClick(Sender: TObject);
    procedure LeftUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure RightUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure TopUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure BottomUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure HeightUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure TabUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure FontUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure CreateUpDown(AParent: TWinControl;
                           ALeft: integer;
                           ATop: integer;
                           UDClick: TUDClickEvent);
  public
    SaveSettings: boolean;
    RS: TReportSection;
  end;

var
  SectionEditForm: TSectionEditForm;

implementation

{$R *.DFM}

  procedure TSectionEditForm.DrawImage;

  const
    Shadow = 5;
    DimDist = 32;
    ArrDist = 4;
    Margin = DimDist div 2;

  var
    NewBitmap: TBitmap;
    Wid: integer;
    Hei: integer;
    X1: integer;
    Y1: integer;
    X2: integer;
    Y2: integer;
    InteriorBottom: boolean;
    InteriorRight: boolean;

    procedure DrawDimension(X1,Y1: integer;
                            DimDist: integer;
                            AdjX,AdjY: integer;
                            Text: string);

    var
      X2,Y2: integer;

    begin { DrawDimension }
      X2 := X1 + AdjX * DimDist;
      Y2 := Y1 + AdjY * DimDist;

      With NewBitmap.Canvas do begin
      { Draw main line }
        MoveTo(X1,Y1);
        LineTo(X2,Y2);

        If AdjX = 0 then begin { Vertical line }
        { Draw arrows }
          MoveTo(X1 - ArrDist,Y1 + ArrDist * AdjY);
          LineTo(X1,Y1);
          LineTo(X1 + ArrDist + 1,Y1 + (ArrDist + 1) * AdjY);

          MoveTo(X2 - ArrDist,Y2 - ArrDist * AdjY);
          LineTo(X2,Y2);
          LineTo(X2 + ArrDist + 1,Y2 - (ArrDist + 1) * AdjY);

        { Draw Text }
          SetBkMode(Handle,Transparent);
          TextOut(X1 + 4,(Y1 + Y2 - Abs(Font.Height)) div 2,Text);
        end else begin { Horizontal line }
        { Draw arrows }
          MoveTo(X1 + ArrDist * AdjX,Y1 - ArrDist);
          LineTo(X1,Y1);
          LineTo(X1 + (ArrDist + 1) * AdjX,Y1 + ArrDist + 1);

          MoveTo(X2 - ArrDist * AdjX,Y2 - ArrDist);
          LineTo(X2,Y2);
          LineTo(X2 - (ArrDist + 1) * AdjX,Y2 + ArrDist + 1);

        { Draw Text }
          SetBkMode(Handle,Transparent);
          TextOut((X1 + X2 - TextWidth(Text)) div 2,Y1 + 4,Text);
        end; { else }
      end; { with }
    end;  { DrawDimension }

  begin { DrawImage }
    Wid := Image1.Width;
    Hei := Image1.Height;

  { Item changed, redraw image }
    NewBitmap := TBitmap.Create;
    NewBitmap.Width := Wid;
    NewBitmap.Height := Hei;
    With NewBitmap.Canvas do begin
      Brush.Color := clLtGray;
      Brush.Style := bsSolid;
      Font.Name := 'MS Sans Serif';
      Font.Size := 8;
      Pen.Color := clLtGray;
      Pen.Width := 1;
      Pen.Style := psSolid;
      Pen.Mode := pmCopy;

    { Draw background }
      Rectangle(0,0,Wid,Hei);

    { Draw shadow }
      Pen.Color := clBlack;
      Brush.Color := clBlack;
      Rectangle(Shadow,Shadow,Wid,Hei);

    { Draw page }
      Brush.Color := clWhite;
      Wid := Wid - Shadow + 1;
      Hei := Hei - Shadow + 1;
      Rectangle(0,0,Wid,Hei);
      Dec(Wid);
      Dec(Hei);

    { Draw margin lines }
      Pen.Color := clGrayText;
      Pen.Style := psDot;
      Rectangle(Margin,Margin,Wid - Margin + 1,Hei - Margin + 1);
      Pen.Color := clBlack;
      Pen.Style := psSolid;

      Font.Color := clGrayText;
      SetBkMode(Handle,Transparent);
      TextOut(Margin,Margin - (Abs(Font.Height) + 3),'Margin');
      Font.Color := clBlack;

    { Draw top section dimension }
      InteriorBottom := false;
      InteriorRight := false;
      Case RS.LeftMethod of
        dmPage: begin
          X1 := DimDist;
        end;
        else begin { dmMargin, dmSpecial }
          X1 := DimDist + Margin;
        end;
      end; { case }
      Case RS.RightMethod of
        dmPage: begin
          X2 := Wid - DimDist;
        end;
        dmMargin: begin
          X2 := Wid - (DimDist + Margin);
        end;
        else begin { dmSpecial - from Left }
          X2 := Wid - DimDist;
          InteriorRight := true;
        end;
      end; { case }
      Case RS.TopMethod of
        dmPage: begin
          Y1 := DimDist;
        end;
        dmMargin: begin
          Y1 := DimDist + Margin;
        end;
        else begin { dmSpecial - from Cursor }
        { Draw previous line }
          Font.Color := clGrayText;
          SetBkMode(Handle,Transparent);
          TextOut(Margin + 2,Margin + 2,'This is the previous line of text.');
          Y1 := DimDist + Margin + 2 + TextHeight('X');
          Font.Color := clBlack;
        end;
      end; { case }
      Case RS.BottomMethod of
        dmPage: begin
          Y2 := Hei - DimDist;
        end;
        dmMargin: begin
          Y2 := Hei - (DimDist + Margin);
        end;
        else begin { dmSpecial - from Top }
          Y2 := Hei - DimDist;
          InteriorBottom := true;
        end;
      end; { case }

    { Draw section box }
      Brush.Color := clLtGray;
      Rectangle(X1,Y1,X2 + 1,Y2 + 1);
      SetBkMode(Handle,Transparent);
      TextOut(X1 + 2,Y1 + 2,'Section');
      Brush.Color := clWhite;

      DrawDimension(Wid div 2,Y1,DimDist,0,-1,'Top');
      If InteriorBottom then begin
        DrawDimension(Wid div 2,Y1,Y2 - Y1,0,1,'');
        Brush.Color := clLtGray;
        SetBkMode(Handle,Transparent);
        TextOut(Wid div 2 + 4,Y2 - 16,'Bottom');
        Brush.Color := clWhite;
      end else begin
        DrawDimension(Wid div 2,Y2,DimDist,0,1,'Bottom');
      end; { else }

      DrawDimension(X1,Hei div 2,DimDist,-1,0,'Left');
      If InteriorRight then begin
        DrawDimension(X1,Hei div 2,X2 - X1,1,0,'');
        Brush.Color := clLtGray;
        SetBkMode(Handle,Transparent);
        TextOut(X2 - (TextWidth('Right') + 5),Hei div 2 + 4,'Right');
        Brush.Color := clWhite;
      end else begin
        DrawDimension(X2,Hei div 2,DimDist,1,0,'Right');
      end; { else }
    end; { with }

    Image1.Picture.Bitmap := NewBitmap;
  end;  { DrawImage }

  procedure TSectionEditForm.UpdateForm;

  begin { UpdateForm }
    LeftED.Text := FloatToStrF(RS.Left,ffFixed,10,2);
    RightED.Text := FloatToStrF(RS.Right,ffFixed,10,2);
    TopED.Text := FloatToStrF(RS.Top,ffFixed,10,2);
    BottomED.Text := FloatToStrF(RS.Bottom,ffFixed,10,2);
    If RS.HeightMethod = hmLines then begin
      HeightED.Text := FloatToStrF(RS.MinHeight,ffFixed,10,0);
    end else begin
      HeightED.Text := FloatToStrF(RS.MinHeight,ffFixed,10,2);
    end; { else }
    EnabledCK.Checked := RS.Enabled;
    TabIndexED.Text := IntToStr(RS.TabIndex);
    FontIndexED.Text := IntToStr(RS.FontIndex);

    DrawImage;
  end;  { UpdateForm }

  procedure TSectionEditForm.LeftUpDownClick(Sender: TObject; Button: TUDBtnType);
  begin
    If Button = btNext then begin
      LeftUpClick(Sender);
    end else begin
      LeftDownClick(Sender);
    end; { else }
  end;

  procedure TSectionEditForm.RightUpDownClick(Sender: TObject; Button: TUDBtnType);
  begin
    If Button = btNext then begin
      RightUpClick(Sender);
    end else begin
      RightDownClick(Sender);
    end; { else }
  end;

  procedure TSectionEditForm.TopUpDownClick(Sender: TObject; Button: TUDBtnType);
  begin
    If Button = btNext then begin
      TopUpClick(Sender);
    end else begin
      TopDownClick(Sender);
    end; { else }
  end;

  procedure TSectionEditForm.BottomUpDownClick(Sender: TObject; Button: TUDBtnType);
  begin
    If Button = btNext then begin
      BottomUpClick(Sender);
    end else begin
      BottomDownClick(Sender);
    end; { else }
  end;

  procedure TSectionEditForm.HeightUpDownClick(Sender: TObject; Button: TUDBtnType);
  begin
    If Button = btNext then begin
      HeightUpClick(Sender);
    end else begin
      HeightDownClick(Sender);
    end; { else }
  end;

  procedure TSectionEditForm.TabUpDownClick(Sender: TObject; Button: TUDBtnType);
  begin
    If Button = btNext then begin
      TabUpClick(Sender);
    end else begin
      TabDownClick(Sender);
    end; { else }
  end;

  procedure TSectionEditForm.FontUpDownClick(Sender: TObject; Button: TUDBtnType);
  begin
    If Button = btNext then begin
      FontUpClick(Sender);
    end else begin
      FontDownClick(Sender);
    end; { else }
  end;

  procedure TSectionEditForm.CreateUpDown(AParent: TWinControl;
                                          ALeft: integer;
                                          ATop: integer;
                                          UDClick: TUDClickEvent);

  begin { CreateUpDown }
    With TUpDown.Create(self) do begin
      Parent := AParent;
      Width := 13;
      Height := 21;
      Left := ALeft;
      Top := ATop;
      OnClick := UDClick;
      Max := 20000;
      Position := 10000;
    end; { with }
  end;  { CreateUpDown }

  procedure TSectionEditForm.FormCreate(Sender: TObject);
  begin
  { Read in data from TReportSection object for initializing }
    RS := TReportSection.Create;
    SaveSettings := true;
    CreateUpDown(LeftGB,55,32,LeftUpDownClick);
    CreateUpDown(RightGB,55,32,RightUpDownClick);
    CreateUpDown(TopGB,55,32,TopUpDownClick);
    CreateUpDown(BottomGB,55,32,BottomUpDownClick);
    CreateUpDown(HeightGB,55,32,HeightUpDownClick);
    CreateUpDown(SetupGB,78,31,TabUpDownClick);
    CreateUpDown(SetupGB,170,31,FontUpDownClick);
  end;

  procedure TSectionEditForm.FormShow(Sender: TObject);
  begin
    LeftCB.ItemIndex := Ord(RS.LeftMethod);
    RightCB.ItemIndex := Ord(RS.RightMethod);
    TopCB.ItemIndex := Ord(RS.TopMethod);
    BottomCB.ItemIndex := Ord(RS.BottomMethod);
    UnitsCB.ItemIndex := Ord(RS.HeightMethod);
    UpdateForm;
  end;

  procedure TSectionEditForm.LeftDownClick(Sender: TObject);
  begin
    RS.Left := (Trunc((RS.Left - 0.0001) / 0.05)) * 0.05;
    UpdateForm;
  end;

  procedure TSectionEditForm.LeftUpClick(Sender: TObject);
  begin
    RS.Left := (Trunc((RS.Left + 0.0001) / 0.05) + 1) * 0.05;
    UpdateForm;
  end;

  procedure TSectionEditForm.RightDownClick(Sender: TObject);
  begin
    RS.Right := (Trunc((RS.Right - 0.0001) / 0.05)) * 0.05;
    UpdateForm;
  end;

  procedure TSectionEditForm.RightUpClick(Sender: TObject);
  begin
    RS.Right := (Trunc((RS.Right + 0.0001) / 0.05) + 1) * 0.05;
    UpdateForm;
  end;

  procedure TSectionEditForm.TopDownClick(Sender: TObject);
  begin
    RS.Top := (Trunc((RS.Top - 0.0001) / 0.05)) * 0.05;
    UpdateForm;
  end;

  procedure TSectionEditForm.TopUpClick(Sender: TObject);
  begin
    RS.Top := (Trunc((RS.Top + 0.0001) / 0.05) + 1) * 0.05;
    UpdateForm;
  end;

  procedure TSectionEditForm.BottomDownClick(Sender: TObject);
  begin
    RS.Bottom := (Trunc((RS.Bottom - 0.0001) / 0.05)) * 0.05;
    UpdateForm;
  end;

  procedure TSectionEditForm.BottomUpClick(Sender: TObject);
  begin
    RS.Bottom := (Trunc((RS.Bottom + 0.0001) / 0.05) + 1) * 0.05;
    UpdateForm;
  end;

  procedure TSectionEditForm.BitBtn1Click(Sender: TObject);
  begin
    Close;
  end;

  procedure TSectionEditForm.BitBtn2Click(Sender: TObject);
  begin
    SaveSettings := false;
    Close;
  end;

  procedure TSectionEditForm.BitBtn3Click(Sender: TObject);

  var
    OldHelpFile: string;

  begin
    OldHelpFile := Application.HelpFile;
    Application.HelpFile := 'RPPRO.HLP';
    Application.HelpContext(10800);
    Application.HelpFile := OldHelpFile;
  end;

  procedure TSectionEditForm.FormDestroy(Sender: TObject);
  begin
    RS.Free;
  end;

  procedure TSectionEditForm.LeftCBChange(Sender: TObject);
  begin
    RS.LeftMethod := TDistMethod(LeftCB.ItemIndex);
    UpdateForm;
  end;

  procedure TSectionEditForm.RightCBChange(Sender: TObject);
  begin
    RS.RightMethod := TDistMethod(RightCB.ItemIndex);
    UpdateForm;
  end;

  procedure TSectionEditForm.TopCBChange(Sender: TObject);
  begin
    RS.TopMethod := TDistMethod(TopCB.ItemIndex);
    UpdateForm;
  end;

  procedure TSectionEditForm.BottomCBChange(Sender: TObject);
  begin
    RS.BottomMethod := TDistMethod(BottomCB.ItemIndex);
    UpdateForm;
  end;

  procedure TSectionEditForm.UnitsCBChange(Sender: TObject);
  begin
    RS.HeightMethod := THeightMethod(UnitsCB.ItemIndex);
    UpdateForm;
  end;

  procedure TSectionEditForm.EnabledCKClick(Sender: TObject);
  begin
    RS.Enabled := EnabledCK.Checked;
  end;

  procedure TSectionEditForm.LeftEDKeyPress(Sender: TObject; var Key: Char);
  begin
    If Key = #13 then begin
      LeftEDExit(Sender);
    end; { if }
  end;

  procedure TSectionEditForm.LeftEDExit(Sender: TObject);

  var
    F1: double;
    ErrCode: integer;

  begin
    Val((Sender as TEdit).Text,F1,ErrCode);
    If (ErrCode = 0) and (RS.Left <> F1) then begin
      RS.Left := F1;
      UpdateForm;
    end; { if }
  end;

  procedure TSectionEditForm.RightEDKeyPress(Sender: TObject; var Key: Char);
  begin
    If Key = #13 then begin
      RightEDExit(Sender);
    end; { if }
  end;

  procedure TSectionEditForm.RightEDExit(Sender: TObject);

  var
    F1: double;
    ErrCode: integer;

  begin
    Val((Sender as TEdit).Text,F1,ErrCode);
    If (ErrCode = 0) and (RS.Right <> F1) then begin
      RS.Right := F1;
      UpdateForm;
    end; { if }
  end;

  procedure TSectionEditForm.TopEDKeyPress(Sender: TObject; var Key: Char);
  begin
    If Key = #13 then begin
      TopEDExit(Sender);
    end; { if }
  end;

  procedure TSectionEditForm.TopEDExit(Sender: TObject);

  var
    F1: double;
    ErrCode: integer;

  begin
    Val((Sender as TEdit).Text,F1,ErrCode);
    If (ErrCode = 0) and (RS.Top <> F1) then begin
      RS.Top := F1;
      UpdateForm;
    end; { if }
  end;

  procedure TSectionEditForm.BottomEDKeyPress(Sender: TObject;
    var Key: Char);
  begin
    If Key = #13 then begin
      BottomEDExit(Sender);
    end; { if }
  end;

  procedure TSectionEditForm.BottomEDExit(Sender: TObject);

  var
    F1: double;
    ErrCode: integer;

  begin
    Val((Sender as TEdit).Text,F1,ErrCode);
    If (ErrCode = 0) and (RS.Bottom <> F1) then begin
      RS.Bottom := F1;
      UpdateForm;
    end; { if }
  end;

  procedure TSectionEditForm.HeightDownClick(Sender: TObject);
  begin
    If RS.HeightMethod = hmLines then begin
      RS.MinHeight := RS.MinHeight - 1;
    end else begin
      RS.MinHeight := (Trunc((RS.MinHeight - 0.0001) / 0.05)) * 0.05;
    end; { else }
    UpdateForm;
  end;

  procedure TSectionEditForm.HeightUpClick(Sender: TObject);
  begin
    If RS.HeightMethod = hmLines then begin
      RS.MinHeight := RS.MinHeight + 1;
    end else begin
      RS.MinHeight := (Trunc((RS.MinHeight + 0.0001) / 0.05) + 1) * 0.05;
    end; { else }
    UpdateForm;
  end;

  procedure TSectionEditForm.TabIndexEDKeyPress(Sender: TObject;
    var Key: Char);
  begin
    If Key = #13 then begin
      TabIndexEDExit(Sender);
    end; { if }
  end;

  procedure TSectionEditForm.TabIndexEDExit(Sender: TObject);

  var
    I1: integer;
    ErrCode: integer;

  begin
    Val((Sender as TEdit).Text,I1,ErrCode);
    If (ErrCode = 0) and (RS.TabIndex <> I1) then begin
      RS.TabIndex := I1;
      UpdateForm;
    end; { if }
  end;

  procedure TSectionEditForm.TabDownClick(Sender: TObject);
  begin
    RS.TabIndex := RS.TabIndex - 1;
    UpdateForm;
  end;

  procedure TSectionEditForm.TabUpClick(Sender: TObject);
  begin
    RS.TabIndex := RS.TabIndex + 1;
    UpdateForm;
  end;

  procedure TSectionEditForm.FontDownClick(Sender: TObject);
  begin
    RS.FontIndex := RS.FontIndex - 1;
    UpdateForm;
  end;

  procedure TSectionEditForm.FontUpClick(Sender: TObject);
  begin
    RS.FontIndex := RS.FontIndex + 1;
    UpdateForm;
  end;

  procedure TSectionEditForm.FontIndexEDExit(Sender: TObject);

  var
    I1: integer;
    ErrCode: integer;

  begin
    Val((Sender as TEdit).Text,I1,ErrCode);
    If (ErrCode = 0) and (RS.FontIndex <> I1) then begin
      RS.FontIndex := I1;
      UpdateForm;
    end; { if }
  end;

  procedure TSectionEditForm.FontIndexEDKeyPress(Sender: TObject;
    var Key: Char);
  begin
    If Key = #13 then begin
      FontIndexEDExit(Sender);
    end; { if }
  end;

  procedure TSectionEditForm.HeightEDExit(Sender: TObject);

  var
    F1: double;
    ErrCode: integer;

  begin
    Val((Sender as TEdit).Text,F1,ErrCode);
    If (ErrCode = 0) and (RS.MinHeight <> F1) then begin
      RS.MinHeight := F1;
      UpdateForm;
    end; { if }
  end;

  procedure TSectionEditForm.HeightEDKeyPress(Sender: TObject;
    var Key: Char);
  begin
    If Key = #13 then begin
      HeightEDExit(Sender);
    end; { if }
  end;

end.