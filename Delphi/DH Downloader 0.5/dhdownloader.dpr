program dhdownloader;

uses
  Forms,
  dh in 'dh.pas' {Form1},
  about in 'about.pas' {Form2},
  usbmode in 'usbmode.pas' {Form3},
  generate in 'generate.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
