{ --------------------------------------------------------------------------------+
  |  SISTEMA...............: Amil Contabilidade LTDA | Gerador de Boleto           |
  |  PORTE DE EMPRESA......: Para micro e pequena empresa                          |
  |  SEGMENTO..............: Comércio em geral que emita Boleto Bancario           |
  |  LINGUAGEM/DB..........: Delphi 10.3 Rio (32 bits)                             |
  |--------------------------------------------------------------------------------|
  |                                                                                |
  |  AUTOR/PROGRAMADOR.....: Delmar de Lima (2022)                                 |
  |  E-MAIL................: atendimento@amil.cnt.br                               |
  |--------------------------------------------------------------------------------|
  |  Sistema desenvolvido para atender as necessidades da empresa de contabilidade |
  |  AMIL CONTABILIDADE LTDA | CNPJ nº 33.958.520/0001-60                          |
  |  Doações via PIX / Donations PIX: 97991442486   ou delmar.apui@gmail.com       |
  +-------------------------------------------------------------------------------- }
unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, System.JSON;

type
  TFrmPrincipal = class(TForm)
    btnEnviarBoleto: TButton;
    mReturn: TMemo;
    btnGetToken: TButton;
    edtToken: TEdit;
    procedure btnEnviarBoletoClick(Sender: TObject);
    procedure btnGetTokenClick(Sender: TObject);
  private
    function GetToken: String;
    function PostBoleto(aToken: String): Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;
  aToken: String;

implementation

{$R *.dfm}

procedure TFrmPrincipal.btnEnviarBoletoClick(Sender: TObject);
begin
  if PostBoleto(edtToken.Text) then
  begin
    mReturn.Lines.Add('-----------------------');
    mReturn.Lines.Add('Success');
  end;
end;

function TFrmPrincipal.GetToken: String;
var
  Params: TStringList;
  Resp: TStringStream;
  URI, CLIENT_ID, CLIENT_SECRET, SCOPE: String;
  Jso: TJSONObject;
  JsoPair: TJSONPair;
  HTTP: TIdHTTP;
  IOHandle: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    CLIENT_ID := ''; //Client Id obtido no detalhe da tela de aplicações no IB
    CLIENT_SECRET := ''; //Client Secret obtido no detalhe da tela de aplicações no IB
    SCOPE := 'extrato.read boleto-cobranca.read boleto-cobranca.write'; //Escopos cadastrados na tela de aplicações.
    Params := TStringList.Create;
    Resp := TStringStream.Create;

    HTTP := TIdHTTP.Create(nil);
    HTTP.Request.BasicAuthentication := False;
    HTTP.Request.UserAgent :=
      'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0';
    IOHandle := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
    IOHandle.SSLOptions.Method := sslvTLSv1_2;
    IOHandle.SSLOptions.Mode := sslmClient;
    IOHandle.SSLOptions.CertFile :=
      'C:\Inter API_Certificado.crt'; //Local do certificado digital, Obtido na tela de aplicações no IB
    IOHandle.SSLOptions.KeyFile :=
      'C:\Inter API_Chave.key'; //Local do Key, Obtido na tela de aplicações no IB
    HTTP.IOHandler := IOHandle;
    HTTP.Request.ContentType := 'application/x-www-form-urlencoded';
    HTTP.Request.CharSet := 'UTF-8';

    try
      URI := 'https://cdpj.partners.bancointer.com.br/oauth/v2/token';

      Params.Add('client_id=' + CLIENT_ID);
      Params.Add('client_secret=' + CLIENT_SECRET);
      Params.Add('scope=' + SCOPE);
      Params.Add('grant_type=client_credentials');

      try
        HTTP.Post(URI, Params, Resp);
        mReturn.Lines.Add(Resp.DataString);
        if HTTP.ResponseCode = 200 then
        begin
          if Resp.DataString <> '' then
          begin
            Jso := TJSONObject.Create;
            Jso.Parse(Resp.Bytes, 0);

            for JsoPair in Jso do
            begin
              if JsoPair.JsonString.Value = 'access_token' then
                Result := JsoPair.JsonValue.Value;
            end;

            Jso.Free;
          end;
        end
        else
        begin
          Result := 'Error: ' + IntToStr(HTTP.ResponseCode) + ' - ' +
            Resp.DataString;
        end;
      except
        on E: EIdHTTPProtocolException do
          Result := 'Error: ' + E.ErrorMessage;
      end;

    finally
      FreeAndNil(Params);
      FreeAndNil(Resp);
    end;
  except
    on ex: exception do
      Result := 'Erro ao gerar token: ' + ex.Message;
  end;
end;

function TFrmPrincipal.PostBoleto(aToken: String): Boolean;
var
  Params: TStringList;
  JsonStreamEnvio, Resp: TStringStream;
  URI, CLIENT_ID, CLIENT_SECRET, SCOPE, Parametros: String;
  Jso: TJSONObject;
  JsoPair: TJSONPair;
  HTTP: TIdHTTP;
  IOHandle: TIdSSLIOHandlerSocketOpenSSL;
begin
  Result := False;
  try
    Params := TStringList.Create;
    Resp := TStringStream.Create;

    HTTP := TIdHTTP.Create(nil);
    HTTP.Request.BasicAuthentication := False;
    HTTP.Request.UserAgent :=
      'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0';
    IOHandle := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
    IOHandle.SSLOptions.Method := sslvTLSv1_2;
    IOHandle.SSLOptions.Mode := sslmClient;
    IOHandle.SSLOptions.CertFile :=
      'C:\Inter API_Certificado.crt'; //Local do certificado digital, Obtido na tela de aplicações no IB
    IOHandle.SSLOptions.KeyFile :=
      'C:\Inter API_Chave.key'; //Local do Key, Obtido na tela de aplicações no IB
    HTTP.IOHandler := IOHandle;
    HTTP.Request.ContentType := 'application/json';
    HTTP.Request.Accept := 'application/json';
    HTTP.Request.CharSet := 'UTF-8';
    HTTP.Request.CustomHeaders.FoldLines := False;
    HTTP.Request.CustomHeaders.Add('Authorization: Bearer ' + aToken);

    try
      URI := 'https://cdpj.partners.bancointer.com.br/cobranca/v2/boletos';
      Parametros := '{' + '"seuNumero": "' + '32' + '",' + '"valorNominal": ' +
        '25' + ', "valorAbatimento": 0,' + '"dataVencimento": "' + '2022-04-15'
        + '",' + '"numDiasAgenda": 60,' + '"pagador": {' + '"cpfCnpj": "' +
        '33958520000160' + '",' + '"tipoPessoa": "' + 'JURIDICA' + '",' +
        '"nome": "' + 'AMIL CONTABILIDADE LTDA' + '",' +
        '"endereco": "' + 'RUA BAHIA' + '",' + '"numero": "' + '1006' + '",' +
        '"complemento": "' + '' + '",' + '"bairro": "' + 'CENTRO' + '",' +
        '"cidade": "' + 'APUI' + '",' + '"uf": "' + 'AM' + '",' + '"cep": "' +
        '69265000' + '",' + '"email": "' + 'atendimento@amil.cnt.br' + '",' + '"ddd": "' + '' + '",' +
        '"telefone": "' + '' + '"},' + '"mensagem": {' +
        '"linha1": "Honorario Contabil Ref.: ' + '69265000' + '"},' +
        '"desconto1": {' + '"codigoDesconto": "PERCENTUALDATAINFORMADA",' +
        '"data": "' + '2022-04-10' + '",' + '"taxa": ' + '5' + ',' +
        '"valor": 0},' + '"multa": {' + '"codigoMulta": "PERCENTUAL",' +
        '"data": "' + '2022-04-16' + '",' + '"valor": 0,' + '"taxa": 2},' +
        '"mora": {' + '"codigoMora": "TAXAMENSAL",' + '"data": "' + '2022-04-16'
        + '",' + '"valor": 0,' + '"taxa": 1' + '}}';
      Params.text := Parametros;
      JsonStreamEnvio := TStringStream.Create(Params.text);
      try
        HTTP.Post(URI, JsonStreamEnvio, Resp);
        mReturn.Lines.Add(Resp.DataString);
        if HTTP.ResponseCode = 200 then
        begin
          if Resp.DataString <> '' then
          begin
            Jso := TJSONObject.Create;
            Jso.Parse(Resp.Bytes, 0);

            for JsoPair in Jso do
            begin
              if JsoPair.JsonString.Value = 'codigoBarras' then
              begin
                mReturn.Lines.Add(JsoPair.JsonValue.Value);
                Result := True;
              end;
            end;

            Jso.Free;
          end;
        end
        else
        begin
         mReturn.Lines.Add('Error: ' + IntToStr(HTTP.ResponseCode) + ' - ' +
            Resp.DataString);
        end;
      except
        on E: EIdHTTPProtocolException do
         mReturn.Lines.Add('Error: ' + E.ErrorMessage);
      end;

    finally
      FreeAndNil(Params);
      FreeAndNil(Resp);
    end;
  except
    on ex: exception do
      mReturn.Lines.Add('Erro ao gerar token: ' + ex.Message);
  end;
end;

procedure TFrmPrincipal.btnGetTokenClick(Sender: TObject);
begin
  edtToken.Text := GetToken;
end;

end.
