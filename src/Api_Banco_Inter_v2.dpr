program Api_Banco_Inter_v2;

uses
  Vcl.Forms,
  uFrm.Main in 'View\uFrm.Main.pas' {FrmPrincipal},
  uController.BancoInter in 'Controller\uController.BancoInter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
end.
