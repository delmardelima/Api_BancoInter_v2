unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uClasseBancoInter, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, Vcl.StdCtrls;

type
  TFrmPrincipal = class(TForm)
    btnGetToken: TButton;
    edtToken: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGetTokenClick(Sender: TObject);
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

procedure TFrmPrincipal.btnGetTokenClick(Sender: TObject);
begin
  edtToken.Text := BancoInter.GetToken;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  BancoInter := TBancoInter.Create(Self);
  BancoInter.CertFile := ExtractFilePath(ParamStr(0)) + 'certificado.crt';
  BancoInter.KeyFile := ExtractFilePath(ParamStr(0)) + 'chave.key';
  BancoInter.ClientID := '';
  BancoInter.ClientSecret := '';
  BancoInter.Scope := 'extrato.read boleto-cobranca.read boleto-cobranca.write';// conforme permissão de uso da API
end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
  BancoInter.Free;
end;

end.
