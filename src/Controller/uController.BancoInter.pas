{ *****************************************************************
  *****************************************************************
  ** Neste projeto � apresentado como consumir a API v2 do       **
  ** Banco Inter com autentica��o OAUTH 2.0, utilizando o Delphi **
  ** e o componente Indy. Compatibilidade testada na vers�o do   **
  ** Delphi Rio, mas poder� funcionar em vers�o diferente.       **
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

unit uController.BancoInter;

interface

uses
  System.Classes, System.JSON, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
  IdSSL, IdBaseComponent, IdComponent, IdTCPConnection, IdSSLOpenSSL,
  IdSSLOpenSSLHeaders, IdTCPClient, System.SysUtils, System.DateUtils, IdHTTP,
  IdCoderMIME;

type
  TBancoInter = class(TComponent)
  private
    FLogFile: String;
    FDirFile: String;
    FDirBin: String;
    FArqPDF: String;
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
    FSituacao: String;
    FValorPago: Double;
    FGetTokenResult: Boolean;
    FGetTokenError: String;
    FPostBoletoError: String;
    FPostBoletoResult: Boolean;
    FDownloadPDFError: String;
    FDownloadPDFResult: Boolean;

    procedure GravarLog(value: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property LogFile: String read FLogFile write FLogFile;
    property DirFile: String read FDirFile write FDirFile;
    property DirBin: String read FDirBin write FDirBin;
    property ArqPDF: String read FArqPDF write FArqPDF;
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
    property Situacao: String read FSituacao write FSituacao;
    property ValorPago: Double read FValorPago write FValorPago;
    property GetTokenResult: Boolean read FGetTokenResult write FGetTokenResult;
    property GetTokenError: String read FGetTokenError write FGetTokenError;
    property PostBoletoResult: Boolean read FPostBoletoResult
      write FPostBoletoResult;
    property PostBoletoError: String read FPostBoletoError
      write FPostBoletoError; // DownloadPDF
    property DownloadPDFResult: Boolean read FDownloadPDFResult
      write FDownloadPDFResult;
    property DownloadPDFError: String read FDownloadPDFError
      write FDownloadPDFError;

    procedure GetToken;
    procedure PostBoleto;
    procedure DownloadPDF;
    procedure ConsultBoleto;
  end;

Const
  URI_TOKEN = 'https://cdpj.partners.bancointer.com.br/oauth/v2/token';
  URI_BOLETOS = 'https://cdpj.partners.bancointer.com.br/cobranca/v2/boletos';
  URI_PDF = 'https://cdpj.partners.bancointer.com.br/cobranca/v2/boletos/';
  URI_CONSULT = 'https://cdpj.partners.bancointer.com.br/cobranca/v2/boletos/';

implementation

{ TBancoInter }

constructor TBancoInter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DirBin := ExtractFilePath(ParamStr(0));
  LogFile := ChangeFileExt(ParamStr(0), '.log');
  DirFile := ExtractFilePath(ParamStr(0)) + 'Boletos\';
  if Not DirectoryExists(DirFile) then
    ForceDirectories(DirFile);
  IdSSLOpenSSLHeaders.IdOpenSSLSetLibPath(DirBin);
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

    Params.Add('client_id=' + ClientID);
    Params.Add('client_secret=' + ClientSecret);
    Params.Add('scope=' + Scope);
    Params.Add('grant_type=client_credentials');

    try
      HTTP.Post(URI_TOKEN, Params, Resp);

      if HTTP.ResponseCode = 200 then
      begin
        GetTokenResult := true;

        try
          Jso := TJSONObject.Create;
          Jso.Parse(Resp.Bytes, 0);

          for JsoPair in Jso do
          begin
            if JsoPair.JsonString.value = 'access_token' then
              Token := JsoPair.JsonValue.value;
            TokenTime := IncSecond(now, 3600);
          end;
        finally
          FreeAndNil(Jso);
        end;
      end
      else
        GetTokenError := 'Error: ' + HTTP.ResponseText;
    except
      on e: EIdHTTPProtocolException do
        GetTokenError := 'Error: ' + HTTP.ResponseText + ' - ' + e.ErrorMessage;
    end;
  finally
    FreeAndNil(Params);
    FreeAndNil(Resp);
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
    PostBoletoError := 'Error: Token OAuth n�o gerado ou venceu!';
    exit;
  end;
  if (seuNumero = '') or (valorNominal <= 0) or (dataVencimento < date) then
  begin
    PostBoletoError := 'Error: Informe todos os campos obrigatorios!';
    exit;
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

    Parametros := '{' + '"seuNumero": "' + SeuNumero + '",' + '"valorNominal": '
      + FormatFloat('0', ValorNominal) + ', "valorAbatimento": 0,' +
      '"dataVencimento": "' + FormatDateTime('yyyy-mm-dd', DataVencimento) +
      '",' + '"numDiasAgenda": 60,' + '"pagador": {' + '"cpfCnpj": "' + CpfCnpj
      + '",' + '"tipoPessoa": "' + TipoPessoa + '",' + '"nome": "' + Nome + '",'
      + '"endereco": "' + Endereco + '",' + '"numero": "' + Numero + '",' +
      '"complemento": "' + Complemento + '",' + '"bairro": "' + Bairro + '",' +
      '"cidade": "' + Cidade + '",' + '"uf": "' + UF + '",' + '"cep": "' + CEP +
      '",' + '"email": "' + Email + '",' + '"ddd": "' + DDD + '",' +
      '"telefone": "' + Telefone + '"},' + '"mensagem": {' + '"linha1": "' +
      Linha1 + '", "linha2": "' + Linha2 +
      '", "linha3": "Tecnologia Amil Contabilidade LTDA"},' + '"desconto1": {' +
      '"codigoDesconto": "PERCENTUALDATAINFORMADA",' + '"data": "' +
      FormatDateTime('yyyy-mm-dd', DtDesconto) + '",' + '"taxa": ' +
      FormatFloat('0', TaxaDesconto) + ',' + '"valor": 0},' + '"multa": {' +
      '"codigoMulta": "PERCENTUAL",' + '"data": "' +
      FormatDateTime('yyyy-mm-dd', IncDay(DataVencimento)) + '",' +
      '"valor": 0,' + '"taxa": 2},' + '"mora": {' +
      '"codigoMora": "TAXAMENSAL",' + '"data": "' + FormatDateTime('yyyy-mm-dd',
      IncDay(DataVencimento)) + '",' + '"valor": 0,' + '"taxa": 1' + '}}';

    ListParams.text := Parametros;
    JsonStreamEnvio := TStringStream.Create(ListParams.text);
    try
      HTTP.Post(URI_BOLETOS, JsonStreamEnvio, Resp);

      if HTTP.ResponseCode = 200 then
      begin
        PostBoletoResult := true;
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
      end
      else
        PostBoletoError := 'Error: ' + IntToStr(HTTP.ResponseCode) + ' - ' +
          Resp.DataString;
    except
      on e: EIdHTTPProtocolException do
        PostBoletoError := 'Error: ' + HTTP.ResponseText + ' - ' +
          e.ErrorMessage;
    end;
  finally
    FreeAndNil(ListParams);
    FreeAndNil(Resp);
    FreeAndNil(JsonStreamEnvio);
    FreeAndNil(IOHandle);
    FreeAndNil(HTTP);
  end;
end;

procedure TBancoInter.DownloadPDF;
var
  RespPDF: TStringStream;
  wJSONObj: TJSONObject;
  wJSONV: TJSONValue;
  wPDF, URI_PDF_FINAL: String;
  MStream: TMemoryStream;
  Decoder: TIdDecoderMIME;
  FileDownload: TFileStream;
  HTTPBaixarPDF: TIdHTTP;
  IOHandleBaixarPDF: TIdSSLIOHandlerSocketOpenSSL;
begin
  if (Token = '') or (TokenTime <= now) then
  begin
    DownloadPDFError := 'Error: Token OAuth n�o gerado ou venceu!';
    exit;
  end;
  if (NossoNumero = '') then
  begin
    DownloadPDFError := 'Error: NossoNumero n�o informado!';
    exit;
  end;
  try
    RespPDF := TStringStream.Create;

    HTTPBaixarPDF := TIdHTTP.Create(nil);
    HTTPBaixarPDF.Request.BasicAuthentication := False;
    HTTPBaixarPDF.Request.UserAgent :=
      'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0';
    IOHandleBaixarPDF := TIdSSLIOHandlerSocketOpenSSL.Create(HTTPBaixarPDF);
    IOHandleBaixarPDF.SSLOptions.Method := sslvTLSv1_2;
    IOHandleBaixarPDF.SSLOptions.Mode := sslmClient;
    IOHandleBaixarPDF.SSLOptions.CertFile := CertFile;
    IOHandleBaixarPDF.SSLOptions.KeyFile := KeyFile;
    HTTPBaixarPDF.IOHandler := IOHandleBaixarPDF;
    HTTPBaixarPDF.Request.Accept := 'application/json';
    HTTPBaixarPDF.Request.CharSet := 'UTF-8';
    HTTPBaixarPDF.Request.CustomHeaders.FoldLines := False;
    HTTPBaixarPDF.Request.CustomHeaders.Add('Authorization: Bearer ' + Token);

    try
      URI_PDF_FINAL := URI_PDF + NossoNumero + '/pdf';
      HTTPBaixarPDF.Get(URI_PDF_FINAL, RespPDF);

      if HTTPBaixarPDF.ResponseCode = 200 then
      begin
        DownloadPDFResult := true;
        try
          wJSONObj := TJSONObject.Create;

          wJSONV := TJSONObject.ParseJSONValue(RespPDF.DataString);
          wJSONObj := TJSONObject(wJSONV);
          wPDF := wJSONObj.GetValue('pdf').value;

          Decoder := TIdDecoderMIME.Create(nil);
          MStream := TMemoryStream.Create;

          Decoder.DecodeStream(wPDF, MStream);
          ArqPDF := DirFile + NossoNumero + '.pdf';
          MStream.SaveToFile(ArqPDF);
        finally
          FreeAndNil(wJSONObj);
          FreeAndNil(wJSONV);
          FreeAndNil(Decoder);
          FreeAndNil(MStream);
        end;
      end
      else
        DownloadPDFError := 'Error: ' + IntToStr(HTTPBaixarPDF.ResponseCode) +
          ' - ' + RespPDF.DataString;
    except
      on e: EIdHTTPProtocolException do
        DownloadPDFError := 'Error: ' + HTTPBaixarPDF.ResponseText + ' - ' +
          e.ErrorMessage;
    end;
  finally
    FreeAndNil(RespPDF);
    FreeAndNil(IOHandleBaixarPDF);
    FreeAndNil(HTTPBaixarPDF);
  end;
end;

procedure TBancoInter.ConsultBoleto;
var
  RespConsult: TStringStream;
  Jso: TJSONObject;
  JsoPair: TJSONPair;
  URI_CONSULT_FINAL: String;
  HTTPConsult: TIdHTTP;
  IOHandleConsult: TIdSSLIOHandlerSocketOpenSSL;
begin
  try
    RespConsult := TStringStream.Create;

    HTTPConsult := TIdHTTP.Create(nil);
    HTTPConsult.Request.BasicAuthentication := False;
    HTTPConsult.Request.UserAgent :=
      'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0';
    IOHandleConsult := TIdSSLIOHandlerSocketOpenSSL.Create(HTTPConsult);
    IOHandleConsult.SSLOptions.Method := sslvTLSv1_2;
    IOHandleConsult.SSLOptions.Mode := sslmClient;
    IOHandleConsult.SSLOptions.CertFile := CertFile;
    IOHandleConsult.SSLOptions.KeyFile := KeyFile;
    HTTPConsult.IOHandler := IOHandleConsult;
    HTTPConsult.Request.Accept := 'application/json';
    HTTPConsult.Request.CustomHeaders.FoldLines := False;
    HTTPConsult.Request.CustomHeaders.Add('Authorization: Bearer ' + Token);

    try
      URI_CONSULT_FINAL := URI_CONSULT + NossoNumero;
      HTTPConsult.Get(URI_CONSULT_FINAL, RespConsult);
      if HTTPConsult.ResponseCode = 200 then
      begin
        Jso := TJSONObject.Create;
        Jso.Parse(RespConsult.Bytes, 0);

        for JsoPair in Jso do
        begin
          if JsoPair.JsonString.value = 'situacao' then
            Situacao := JsoPair.JsonValue.value;
          if Situacao = 'PAGO' then
          begin
            if JsoPair.JsonString.value = 'valorTotalRecebimento' then
              ValorPago := JsoPair.JsonValue.GetValue<Double>;
          end;
        end;
      end
      else
        GravarLog('Erro: ' + IntToStr(HTTPConsult.ResponseCode) + ' - ' +
          RespConsult.DataString);

    finally
      FreeAndNil(RespConsult);
      FreeAndNil(IOHandleConsult);
      FreeAndNil(HTTPConsult);
    end;
  except
    on ex: exception do
      GravarLog('Erro ao consultar boleto: ' + ex.Message);
  end;
end;

end.
