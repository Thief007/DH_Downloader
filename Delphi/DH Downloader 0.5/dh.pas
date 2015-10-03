// DH Downloader 0.5
// (C) Doddy Hackman 2013

unit dh;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, acPNG, ExtCtrls, sSkinManager, StdCtrls, sGroupBox, sButton;

type
  TForm1 = class(TForm)
    sSkinManager1: TsSkinManager;
    Image1: TImage;
    sGroupBox1: TsGroupBox;
    sButton1: TsButton;
    sButton2: TsButton;
    sButton3: TsButton;
    sButton4: TsButton;
    procedure sButton3Click(Sender: TObject);
    procedure sButton4Click(Sender: TObject);
    procedure sButton1Click(Sender: TObject);
    procedure sButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses about, usbmode, generate;
{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin

  sSkinManager1.SkinDirectory := ExtractFilePath(Application.ExeName) + 'Data';
  sSkinManager1.SkinName := 'neonnight';
  sSkinManager1.Active := True;

end;

procedure TForm1.sButton1Click(Sender: TObject);
begin
  Form3.Show;
end;

procedure TForm1.sButton2Click(Sender: TObject);
begin
  Form4.Show;
end;

procedure TForm1.sButton3Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.sButton4Click(Sender: TObject);
begin
  Form1.Close;
end;

end.

// The End ?
