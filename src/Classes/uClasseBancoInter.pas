{ *****************************************************************
  *****************************************************************
  ** Neste projeto é apresentado como consumir a API v2 do       **
  ** Banco Inter com autenticação OAUTH 2.0, utilizando o Delphi **
  ** e o componente Indy. Compatibilidade testada na versão do   **
  ** Delphi Rio, mas poderá funcionar em versão diferente.       **
  ** Desenvolvido por Delmar de Lima (CortesDEV).                **
  *****************************************************************
  ** Segue CortesDEV nas redes sociais                           **
  ** Youtube:   https://bit.ly/SeguirCortesDev                   **
  ** Instagram: https://www.instagram.com/cortesdevoficial/      **
  ** Facebook:  https://www.fb.com/cortesdevoficial              **
  ** WhatsApp:  https://wa.me/5597991442486                      **
  ** Site:      https://amil.cnt.br/cortesdev                    **
  *****************************************************************
  ***************************************************************** }
unit uClasseBancoInter;

interface

uses
  System.Classes, System.JSON, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, System.SysUtils, System.DateUtils,
  IdHTTP;

type
  TBancoInter = class(TComponent)
  private
    FLogFile: String;
    FDirFile: String;
    FCertFile: String;
    FKeyFile: String;
    FClientID: String;
    FClientSecret: String;
    FScope: String;
    FToken: String;
    FTokenTime: TDateTime;
    FSeuNumero: String;
    FNossoNumero: String;
    FCodigoBarras: String;
    FLinhaDigitavel: String;
    FValorNominal: Double;
    FDataVencimento: TDate;
    FCpfCnpj: String;
    FTipoPessoa: String;
    FNome: String;
    FEndereco: String;
    FNumero: String;
    FComplemento: String;
    FBairro: String;
    FCidade: String;
    FUF: String;
    FCEP: String;
    FEmail: String;
    FDDD: String;
    FTelefone: String;
    FLinha1: String;
    FLinha2: String;
    FDtDesconto: TDate;
    FTaxaDesconto: Double;
    FDtMulta: TDate;

    procedure GravarLog(value: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property LogFile: String read FLogFile write FLogFile;
    property DirFile: String read FDirFile write FDirFile;
    property CertFile: String read FCertFile write FCertFile;
    property KeyFile: String read FKeyFile write FKeyFile;
    property ClientID: String read FClientID write FClientID;
    property ClientSecret: String read FClientSecret write FClientSecret;
    property Scope: String read FScope write FScope;
    property Token: String read FToken write FToken;
    property TokenTime: TDateTime read FTokenTime write FTokenTime;
    property SeuNumero: String read FSeuNumero write FSeuNumero;
    property NossoNumero: String read FNossoNumero write FNossoNumero;
    property CodigoBarras: String read FCodigoBarras write FCodigoBarras;
    property LinhaDigitavel: String read FLinhaDigitavel write FLinhaDigitavel;
    property ValorNominal: Double read FValorNominal write FValorNominal;
    property DataVencimento: TDate read FDataVencimento write FDataVencimento;
    property CpfCnpj: String read FCpfCnpj write FCpfCnpj;
    property TipoPessoa: String read FTipoPessoa write FTipoPessoa;
    property Nome: String read FNome write FNome;
    property Endereco: String read FEndereco write FEndereco;
    property Numero: String read FNumero write FNumero;
    property Complemento: String read FComplemento write FComplemento;
    property Bairro: String read FBairro write FBairro;
    property Cidade: String read FCidade write FCidade;
    property UF: String read FUF write FUF;
    property CEP: String read FCEP write FCEP;
    property Email: String read FEmail write FEmail;
    property DDD: String read FDDD write FDDD;
    property Telefone: String read FTelefone write FTelefone;
    property Linha1: String read FLinha1 write FLinha1;
    property Linha2: String read FLinha2 write FLinha2;
    property DtDesconto: TDate read FDtDesconto write FDtDesconto;
    property TaxaDesconto: Double read FTaxaDesconto write FTaxaDesconto;
    property DtMulta: TDate read FDtMulta write FDtMulta;

    procedure GetToken;
    procedure PostBoleto;
  end;

Const
  URI_TOKEN = 'https://cdpj.partners.bancointer.com.br/oauth/v2/token';
  URI_BOLETOS = 'https://cdpj.partners.bancointer.com.br/cobranca/v2/boletos';

implementation

{ TBancoInter }

constructor TBancoInter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LogFile := ChangeFileExt(ParamStr(0), '.log');
  DirFile := ExtractFilePath(ParamStr(0)) + 'Boletos';
end;

destructor TBancoInter.Destroy;
begin
  inherited Destroy;
end;

procedure TBancoInter.GetToken;
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
    IOHandle.SSLOptions.CertFile := CertFile;
    IOHandle.SSLOptions.KeyFile := KeyFile;
    HTTP.IOHandler := IOHandle;
    HTTP.Request.ContentType := 'application/x-www-form-urlencoded';
    HTTP.Request.CharSet := 'UTF-8';

    try
      Params.Add('client_id=' + ClientID);
      Params.Add('client_secret=' + ClientSecret);
      Params.Add('scope=' + Scope);
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
            if JsoPair.JsonString.value = 'access_token' then
              Token := JsoPair.JsonValue.value;
            TokenTime := IncSecond(now, 3600);
          end;

          Jso.Free;
        end;
      end
      else
      begin
        GravarLog('Error: ' + IntToStr(HTTP.ResponseCode) + ' - ' +
          Resp.DataString);
      end;
    finally
      FreeAndNil(Params);
      FreeAndNil(Resp);
    end;
  except
    on e: exception do
      GravarLog('Erro ao gerar token: ' + e.Message);
  end;
end;

procedure TBancoInter.GravarLog(value: String);
var
  txtLog: TextFile;
begin
  AssignFile(txtLog, LogFile);
  if FileExists(LogFile) then
    Append(txtLog)
  else
    Rewrite(txtLog);
  Writeln(txtLog, FormatDateTime('dd/mm/YY hh:mm:ss - ', now) + value);
  CloseFile(txtLog);
end;

procedure TBancoInter.PostBoleto;
var
  HTTP: TIdHTTP;
  IOHandle: TIdSSLIOHandlerSocketOpenSSL;
  ListParams: TStringList;
  JsonStreamEnvio, Resp: TStringStream;
  Jso: TJSONObject;
  JsoPair: TJSONPair;
  Parametros: String;
begin
  if (Token = '') or (TokenTime <= now) then
  begin
    GravarLog('Error: Token OAuth não gerado ou venceu!');
    Abort;
  end;
  try
    ListParams := TStringList.Create;
    Resp := TStringStream.Create;

    HTTP := TIdHTTP.Create(nil);
    HTTP.Request.BasicAuthentication := False;
    HTTP.Request.UserAgent :=
      'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0';
    IOHandle := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
    IOHandle.SSLOptions.Method := sslvTLSv1_2;
    IOHandle.SSLOptions.Mode := sslmClient;
    IOHandle.SSLOptions.CertFile := CertFile;
    IOHandle.SSLOptions.KeyFile := KeyFile;
    HTTP.IOHandler := IOHandle;
    HTTP.Request.ContentType := 'application/json';
    HTTP.Request.Accept := 'application/json';
    HTTP.Request.CharSet := 'UTF-8';
    HTTP.Request.CustomHeaders.FoldLines := False;
    HTTP.Request.CustomHeaders.Add('Authorization: Bearer ' + Token);

    try
      Parametros := '{' + '"seuNumero": "' + SeuNumero + '",' +
        '"valorNominal": ' + FormatFloat('0', ValorNominal) +
        ', "valorAbatimento": 0,' + '"dataVencimento": "' +
        FormatDateTime('yyyy-mm-dd', DataVencimento) + '",' +
        '"numDiasAgenda": 60,' + '"pagador": {' + '"cpfCnpj": "' + CpfCnpj +
        '",' + '"tipoPessoa": "' + TipoPessoa + '",' + '"nome": "' + Nome + '",'
        + '"endereco": "' + Endereco + '",' + '"numero": "' + Numero + '",' +
        '"complemento": "' + Complemento + '",' + '"bairro": "' + Bairro + '",'
        + '"cidade": "' + Cidade + '",' + '"uf": "' + UF + '",' + '"cep": "' +
        CEP + '",' + '"email": "' + Email + '",' + '"ddd": "' + DDD + '",' +
        '"telefone": "' + Telefone + '"},' + '"mensagem": {' + '"linha1": "' +
        Linha1 + '", "linha2": "' + Linha2 +
        '", "linha3": "acesse amil.cnt.br"},' + '"desconto1": {' +
        '"codigoDesconto": "PERCENTUALDATAINFORMADA",' + '"data": "' +
        FormatDateTime('yyyy-mm-dd', DtDesconto) + '",' + '"taxa": ' +
        FormatFloat('0', TaxaDesconto) + ',' + '"valor": 0},' + '"multa": {' +
        '"codigoMulta": "PERCENTUAL",' + '"data": "' +
        FormatDateTime('yyyy-mm-dd', DtMulta) + '",' + '"valor": 0,' +
        '"taxa": 2},' + '"mora": {' + '"codigoMora": "TAXAMENSAL",' +
        '"data": "' + FormatDateTime('yyyy-mm-dd', DtMulta) + '",' +
        '"valor": 0,' + '"taxa": 1' + '}}';

      ListParams.text := Parametros;
      JsonStreamEnvio := TStringStream.Create(ListParams.text);
      HTTP.Post(URI_BOLETOS, JsonStreamEnvio, Resp);

      if HTTP.ResponseCode = 200 then
      begin
        if Resp.DataString <> '' then
        begin
          try
            Jso := TJSONObject.Create;
            Jso.Parse(Resp.Bytes, 0);
            for JsoPair in Jso do
            begin
              if JsoPair.JsonString.value = 'seuNumero' then
                SeuNumero := JsoPair.JsonValue.value
              else if JsoPair.JsonString.value = 'nossoNumero' then
                NossoNumero := JsoPair.JsonValue.value
              else if JsoPair.JsonString.value = 'codigoBarras' then
                CodigoBarras := JsoPair.JsonValue.value
              else if JsoPair.JsonString.value = 'linhaDigitavel' then
                LinhaDigitavel := JsoPair.JsonValue.value;
            end;
          finally
            FreeAndNil(Jso);
          end;
        end;
      end
      else
        GravarLog('Error: ' + IntToStr(HTTP.ResponseCode) + ' - ' +
          Resp.DataString);
    finally
      FreeAndNil(ListParams);
      FreeAndNil(Resp);
      FreeAndNil(JsonStreamEnvio);
      FreeAndNil(IOHandle);
      FreeAndNil(HTTP);
    end;
  except
    on e: exception do
      GravarLog('Erro ao enviar boleto: ' + e.Message);
  end;
end;

end.
