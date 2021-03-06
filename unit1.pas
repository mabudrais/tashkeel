unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLType,
  Spin, IniPropStorage,Unit2,windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    ChangeFontButton: TButton;
    Edit2: TEdit;
    SpinEdit1: TSpinEdit;
    FontDialog1: TFontDialog;
    IniPropStorage1: TIniPropStorage;
    procedure Memo1Change(Sender: TObject);
    procedure Memo1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure ChangeFontButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
  private
    lastKey: word;
    ChangeStart: integer;
    sks: array of word;
    IsShift: boolean;
    IsCaps: Boolean;
    procedure SetL(ke: array of word);
    function isShakl(ke: word): integer;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Memo1Change(Sender: TObject);
var
  OldSelectStart, ShaklINdex: integer;
begin
  log.LogStatus('Memo1Change', '');
  //WriteLn();
  // WriteLn(Memo1.CaretPos.x);
  // WriteLn(Memo1.CaretPos.y);
  // Memo1.SelLength:=0;
  // WriteLn(Memo1.SelStart);
  if (not CheckBox1.Checked)or(not IsCaps) then
    Exit;
  if ChangeStart > 0 then
  begin
    Dec(ChangeStart);
    Exit;
  end;
  ShaklINdex := isShakl(lastKey);
  // WriteLn(ShaklINdex);
  if ShaklINdex > -1 then
  begin
    ChangeStart := 2;
    OldSelectStart := Memo1.SelStart;
    Memo1.SelStart := OldSelectStart - 1;
    Memo1.SelLength := 1;
    Memo1.SelText := '';
    if (IsShift) and (OldSelectStart > 1) then
      Memo1.SelStart := Memo1.SelStart - 1;
    Memo1.SelText := Copy(Edit1.Text, ShaklINdex * 4 + 3, 2);
    Memo1.SelLength := 0;
    Memo1.SelStart := Memo1.SelStart + 1;
  end;
end;

procedure TForm1.Memo1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  //WriteLn(Key);
  log.LogStatus('Memo1KeyDown ' + IntToStr(Key), '');
  lastKey := Key;
  IsShift := ssShift in Shift;
  IsCaps :=  Odd(GetKeyState(VK_CAPITAL));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ChangeStart := 0;
  setl([VK_Q, VK_E, VK_A, VK_X, 192, VK_W, VK_S, VK_R]);
  SpinEdit1.Value := Memo1.Font.Size;
  log.LogStatus('FormCreate', '');
  IniPropStorage1.Restore;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  //Edit2.Text:=Copy(Edit1.Text,3,2);
end;

procedure TForm1.SetL(ke: array of word);
var
  k: integer;
begin
  SetLength(sks, Length(ke));
  for k := 0 to Length(ke) - 1 do
    sks[k] := ke[k];
end;

function TForm1.isShakl(ke: word): integer;
var
  k: integer;
begin
  Result := -1;
  for k := 0 to Length(sks) - 1 do
  begin
    if sks[k] = ke then
    begin
      Result := k;
      Exit;
    end;
  end;
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  log.LogStatus('CheckBox1Change ' + BoolToStr(CheckBox1.Checked), '');
  if CheckBox1.Checked = True then
    ChangeStart := 0;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  Log.LogStatus('SpinEdit1Change ' + IntToStr(SpinEdit1.Value), '');
  Memo1.Font.Size := SpinEdit1.Value;
end;

procedure TForm1.ChangeFontButtonClick(Sender: TObject);
begin
  FontDialog1.Font := Memo1.Font;
  FontDialog1.Execute;
  if Assigned(FontDialog1.Font) then
    Memo1.Font := FontDialog1.Font;
  SpinEdit1.Value := Memo1.Font.Size;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  {Memo1.Font.Size := 24;}
  SpinEdit1.Value := Memo1.Font.Size;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := True;
  IniPropStorage1.Save;
end;

end.
