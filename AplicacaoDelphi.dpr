{
  Autor: Vinícius Lopes de Melo
  Data: 17/06/2014
  Link: https://github.com/viniciuslopesmelo/Aplicacao-Delphi
}

program AplicacaoDelphi;

uses
  Forms,
  untFrmPrincipal in 'untFrmPrincipal.pas' {FormPrincipal},
  untDMConexao in 'untDMConexao.pas' {DMConexao: TDataModule},
  untDMPrincipal in 'untDMPrincipal.pas' {DMPrincipal: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Aplicação Delphi com Base de Dados e Report Builder';
  Application.CreateForm(TDMConexao, DMConexao);
  Application.CreateForm(TDMPrincipal, DMPrincipal);
  Application.Run;
end.
