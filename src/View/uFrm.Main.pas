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

unit uFrm.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uController.BancoInter, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, Vcl.StdCtrls, Vcl.ExtCtrls, DateUtils, ShellApi;

type
  TFrmPrincipal = class(TForm)
    btnGetToken: TButton;
    edtToken: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtSeuNumero: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    spTop: TShape;
    edtNossoNumero: TEdit;
    Label5: TLabel;
    edtCodigoBarras: TEdit;
    Label6: TLabel;
    btnPostBoleto: TButton;
    Label7: TLabel;
    edtLinhaDigitavel: TEdit;
    Shape1: TShape;
    Shape2: TShape;
    Label8: TLabel;
    Label9: TLabel;
    edtArqPDF: TEdit;
    btnDownloadPDF: TButton;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    edtSituacao: TEdit;
    Label16: TLabel;
    edtValorPago: TEdit;
    btnConsultBoleto: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGetTokenClick(Sender: TObject);
    procedure btnPostBoletoClick(Sender: TObject);
    procedure btnDownloadPDFClick(Sender: TObject);
    procedure btnConsultBoletoClick(Sender: TObject);
  private
    { Private declarations }
    BancoInter: TBancoInter;
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

procedure TFrmPrincipal.btnConsultBoletoClick(Sender: TObject);
begin
  BancoInter.NossoNumero := edtNossoNumero.Text;
  BancoInter.ConsultBoleto;
  edtSituacao.Text := BancoInter.Situacao;
  edtValorPago.Text := BancoInter.ValorPago;
end;

procedure TFrmPrincipal.btnDownloadPDFClick(Sender: TObject);
begin
  BancoInter.NossoNumero := edtNossoNumero.Text;
  BancoInter.DownloadPDF;
  edtArqPDF.Text := BancoInter.ArqPDF;
  if FileExists(BancoInter.ArqPDF) then
    ShellExecute(Handle, nil, PChar(BancoInter.ArqPDF), nil, nil,
      SW_SHOWNORMAL);
end;

procedure TFrmPrincipal.btnGetTokenClick(Sender: TObject);
begin
  BancoInter.GetToken;
  if BancoInter.Token = '' then
    BancoInter.Token := 'Error GetToken!';
  edtToken.Text := BancoInter.Token;
end;

procedure TFrmPrincipal.btnPostBoletoClick(Sender: TObject);
begin
  BancoInter.SeuNumero := edtSeuNumero.Text;
  BancoInter.ValorNominal := 10;
  BancoInter.DataVencimento := incDay(date, 30);
  // Não pode ter acento ou caracteres especiais na solicitação.
  // Dados fictícios, retirado do site 4devs.com.br/gerador_de_pessoas
  BancoInter.CpfCnpj := '96730102268';
  BancoInter.TipoPessoa := 'FISICA'; // JURIDICA
  BancoInter.Nome := 'Thomas Claudio Bernardes';
  BancoInter.Endereco := 'Avenida 13 de Novembro';
  BancoInter.Numero := '697';
  BancoInter.Complemento := 'Casa';
  BancoInter.Bairro := 'Centro';
  BancoInter.Cidade := 'Apui';
  BancoInter.UF := 'AM';
  BancoInter.CEP := '69265000';
  BancoInter.Email := 'thomas_claudio_bernardes@lidertel.com.br';
  BancoInter.DDD := '97';
  BancoInter.Telefone := '981200415';
  BancoInter.Linha1 := 'Curti nosso canal | CortesDEV';
  BancoInter.Linha2 := 'Desenvolvido por Delmar de Lima';
  BancoInter.DtDesconto := incDay(date, 20);
  BancoInter.TaxaDesconto := 1; // 0 -> 100
  BancoInter.PostBoleto;
  edtSeuNumero.Text := BancoInter.SeuNumero;
  edtNossoNumero.Text := BancoInter.NossoNumero;
  edtCodigoBarras.Text := BancoInter.CodigoBarras;
  edtLinhaDigitavel.Text := BancoInter.LinhaDigitavel;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  BancoInter := TBancoInter.Create(Self);
  { ATENÇÃO!!!}
  { INFORMAÇÕES RETIRADA DA INTERNET BANKING }
  { NECESSARIO GERAR APLICAÇÃO NO MENU API DO BANCO INTER }
  { https://ajuda.bancointer.com.br/pt-BR/articles/4284884-como-cadastrar-uma-api }
  BancoInter.CertFile := ExtractFilePath(ParamStr(0)) + 'certificado.crt';
  BancoInter.KeyFile := ExtractFilePath(ParamStr(0)) + 'chave.key';
  BancoInter.ClientID := '';
  BancoInter.ClientSecret := '';
  BancoInter.Scope := 'extrato.read boleto-cobranca.read boleto-cobranca.write';
end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
  BancoInter.Free;
end;

end.
