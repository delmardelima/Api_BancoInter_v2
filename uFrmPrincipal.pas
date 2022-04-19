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
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, System.JSON,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons;

type
  TFrmPrincipal = class(TForm)
    pnPrincipal: TPanel;
    pnBotao: TPanel;
    sbSalvar: TSpeedButton;
    spLineBtn: TShape;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    pnlToolbar: TPanel;
    lblTitle: TLabel;
    Panel4: TPanel;
    Shape3: TShape;
    Label9: TLabel;
    mReturn: TMemo;
    Panel2: TPanel;
    edtKeyFile: TEdit;
    Label2: TLabel;
    Label1: TLabel;
    edtCertFile: TEdit;
    Panel3: TPanel;
    Shape1: TShape;
    Label3: TLabel;
    sbCertFile: TSpeedButton;
    sbKeyFile: TSpeedButton;
    procedure btnEnviarBoletoClick(Sender: TObject);
    procedure btnGetTokenClick(Sender: TObject);
    procedure sbCertFileClick(Sender: TObject);
    procedure sbKeyFileClick(Sender: TObject);
  private
    function GetToken: String;
    function PostBoleto(aToken: String): Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

Const
  // Local do certificado digital, Obtido na tela de aplicações no IB
  CERT_FILE = 'C:\Inter API_Certificado.crt';
  // Local da chave key, Obtido na tela de aplicações no IB
  KEY_FILE = 'C:\Inter API_Chave.key';
  // Client Id obtido no detalhe da tela de aplicações no IB
  CLIENT_ID = '';
  // Client Secret obtido no detalhe da tela de aplicações no IB
  CLIENT_SECRET = '';
  // Escopos cadastrados na tela de aplicações.
  SCOPE = 'extrato.read boleto-cobranca.read boleto-cobranca.write';
  // Link conforme documentação
  URI_TOKEN = 'https://cdpj.partners.bancointer.com.br/oauth/v2/token';
  URI_BOLETOS = 'https://cdpj.partners.bancointer.com.br/cobranca/v2/boletos';

implementation

{$R *.dfm}

procedure TFrmPrincipal.btnEnviarBoletoClick(Sender: TObject);
begin
  {if PostBoleto(edtToken.Text) then
  begin
    mReturn.Lines.Add('-----------------------');
    mReturn.Lines.Add('Success');
  end;}
end;

function TFrmPrincipal.GetToken: String;
var
  Params: TStringList;
  Resp: TStringStream;
  Jso: TJSONObject;
  JsoPair: TJSONPair;
  HTTP: TIdHTTP;
  IOHandle: TIdSSLIOHandlerSocketOpenSSL;
begin
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
    IOHandle.SSLOptions.CertFile := CERT_FILE;
    IOHandle.SSLOptions.KeyFile := KEY_FILE;
    HTTP.IOHandler := IOHandle;
    HTTP.Request.ContentType := 'application/x-www-form-urlencoded';
    HTTP.Request.CharSet := 'UTF-8';

    try
      Params.Add('client_id=' + CLIENT_ID);
      Params.Add('client_secret=' + CLIENT_SECRET);
      Params.Add('scope=' + SCOPE);
      Params.Add('grant_type=client_credentials');

      HTTP.Post(URI_TOKEN, Params, Resp);
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
        mReturn.Lines.Add('Error: ' + IntToStr(HTTP.ResponseCode) + ' - ' +
          Resp.DataString);
      end;
    finally
      FreeAndNil(Params);
      FreeAndNil(Resp);
    end;
  except
    on e: exception do
      mReturn.Lines.Add('Erro ao gerar token: ' + e.Message);
  end;
end;

function TFrmPrincipal.PostBoleto(aToken: String): Boolean;
var
  Params: TStringList;
  JsonStreamEnvio, Resp: TStringStream;
  Parametros: String;
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
    IOHandle.SSLOptions.CertFile := CERT_FILE;
    IOHandle.SSLOptions.KeyFile := KEY_FILE;
    HTTP.IOHandler := IOHandle;
    HTTP.Request.ContentType := 'application/json';
    HTTP.Request.Accept := 'application/json';
    HTTP.Request.CharSet := 'UTF-8';
    HTTP.Request.CustomHeaders.FoldLines := False;
    HTTP.Request.CustomHeaders.Add('Authorization: Bearer ' + aToken);

    try
      Parametros := '{' + '"seuNumero": "' + '32' + '",' + '"valorNominal": ' +
        '25' + ', "valorAbatimento": 0,' + '"dataVencimento": "' + '2022-04-15'
        + '",' + '"numDiasAgenda": 60,' + '"pagador": {' + '"cpfCnpj": "' +
        '33958520000160' + '",' + '"tipoPessoa": "' + 'JURIDICA' + '",' +
        '"nome": "' + 'AMIL CONTABILIDADE LTDA' + '",' + '"endereco": "' +
        'RUA BAHIA' + '",' + '"numero": "' + '1006' + '",' + '"complemento": "'
        + '' + '",' + '"bairro": "' + 'CENTRO' + '",' + '"cidade": "' + 'APUI' +
        '",' + '"uf": "' + 'AM' + '",' + '"cep": "' + '69265000' + '",' +
        '"email": "' + 'atendimento@amil.cnt.br' + '",' + '"ddd": "' + '' + '",'
        + '"telefone": "' + '' + '"},' + '"mensagem": {' +
        '"linha1": "Honorario Contabil Ref.: ' + '69265000' + '"},' +
        '"desconto1": {' + '"codigoDesconto": "PERCENTUALDATAINFORMADA",' +
        '"data": "' + '2022-04-10' + '",' + '"taxa": ' + '5' + ',' +
        '"valor": 0},' + '"multa": {' + '"codigoMulta": "PERCENTUAL",' +
        '"data": "' + '2022-04-16' + '",' + '"valor": 0,' + '"taxa": 2},' +
        '"mora": {' + '"codigoMora": "TAXAMENSAL",' + '"data": "' + '2022-04-16'
        + '",' + '"valor": 0,' + '"taxa": 1' + '}}';
      Params.Text := Parametros;
      JsonStreamEnvio := TStringStream.Create(Params.Text);
      try
        HTTP.Post(URI_BOLETOS, JsonStreamEnvio, Resp);
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
        on e: EIdHTTPProtocolException do
          mReturn.Lines.Add('Error: ' + e.ErrorMessage);
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

procedure TFrmPrincipal.sbCertFileClick(Sender: TObject);
var
  openDialog: topendialog;
begin
  openDialog := topendialog.Create(self);
  try
    openDialog.InitialDir := GetCurrentDir;
    openDialog.Options := [ofFileMustExist];
    openDialog.Filter := 'Certificado|*.crt';
    openDialog.FilterIndex := 1;
    if openDialog.Execute then
    begin
      edtCertFile.Text := openDialog.FileName;
    end;
  finally
    openDialog.Free;
  end;
end;

procedure TFrmPrincipal.sbKeyFileClick(Sender: TObject);
var
  openDialog: topendialog;
begin
  openDialog := topendialog.Create(self);
  try
    openDialog.InitialDir := GetCurrentDir;
    openDialog.Options := [ofFileMustExist];
    openDialog.Filter := 'Chave Key|*.key';
    openDialog.FilterIndex := 1;
    if openDialog.Execute then
    begin
      edtKeyFile.Text := openDialog.FileName;
    end;
  finally
    openDialog.Free;
  end;
end;

procedure TFrmPrincipal.btnGetTokenClick(Sender: TObject);
begin
  //edtToken.Text := GetToken;
end;

end.
