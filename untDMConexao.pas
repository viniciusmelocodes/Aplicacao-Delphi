{
  Autor: Vinícius Lopes de Melo
  Data: 17/06/2014
  Link: https://github.com/viniciuslopesmelo/Aplicacao-Delphi
}

unit untDMConexao;

interface

uses
  SysUtils, Classes, DBXFirebird, DB,
  SqlExpr, WideStrings, Dialogs, Forms,
  DBXCommon;

type
  TDMConexao = class(TDataModule)
    ConexaoApp: TSQLConnection;

    procedure DataModuleCreate(Sender: TObject);

  protected

    transactionApp : TDBXTransaction;

  public

    function confirmarTransacao: Boolean;

    function iniciarTransacao: Boolean;

    function reverterTransacao: Boolean;

    function atualizarConexaoAplicativo: Boolean;

  end;

var
  DMConexao: TDMConexao;

implementation

  // Usualmente não é recomendo que um DataModule enxergue um Form.
  // Nesse caso tive de enxergar somente para criar o objeto do Form
  // quando fosse para atualizar a conexao da aplicação.
uses
  untFrmPrincipal, untDMPrincipal;

{$R *.dfm}

procedure TDMConexao.DataModuleCreate(Sender: TObject);
begin
  atualizarConexaoAplicativo;
end;

function TDMConexao.atualizarConexaoAplicativo: Boolean;
begin
  try
    ConexaoApp.Connected := False;
    ConexaoApp.Connected := True;

    if (FormPrincipal = nil) then
      Application.CreateForm(TFormPrincipal, FormPrincipal);

  except
    on E:Exception do
    begin
      DMPrincipal.imprimirMensagem('Não foi possível se conectar a base de dados.' + sLineBreak + sLineBreak +
                                   'Erro: ' + E.Message,
                                   'Erro');
      Application.ProcessMessages;
      Application.Terminate;
    end;
  end;
end;

function TDMConexao.confirmarTransacao: Boolean;
begin
  ConexaoApp.CommitFreeAndNil(transactionApp);
end;

function TDMConexao.iniciarTransacao: Boolean;
begin
  transactionApp := ConexaoApp.BeginTransaction;
end;

function TDMConexao.reverterTransacao: Boolean;
begin
  ConexaoApp.RollbackFreeAndNil(transactionApp);
end;

end.
