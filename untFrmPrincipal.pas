{
  Autor: Vinícius Lopes de Melo
  Data: 17/06/2014
  Link: https://github.com/viniciuslopesmelo/Aplicacao-Delphi
}

unit untFrmPrincipal;

interface

uses
  untDMPrincipal,

  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TFormPrincipal = class(TForm)
    pnlProjeto: TPanel;
    btnGravarDados: TButton;
    edtQtdeRegistros: TLabeledEdit;
    btnEmitirRelatorioDados: TButton;
    btnExcluirTodosDados: TButton;
    lblCaminhoBancoDados: TLabel;
    lblAguarde: TLabel;
    btnInformacoes: TButton;

    procedure FormShow(Sender: TObject);

    procedure btnGravarDadosClick(Sender: TObject);

    procedure btnEmitirRelatorioDadosClick(Sender: TObject);

    procedure btnExcluirTodosDadosClick(Sender: TObject);

    procedure btnInformacoesClick(Sender: TObject);

  protected

    bProibidoExecutar: Boolean;

  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.dfm}

{ TFormProjeto }

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
  lblAguarde.Caption := '';

  if (FileExists('C:\BANCODADOS.fdb')) then
  begin
    lblCaminhoBancoDados.Caption := 'Caminho da Base de Dados: C:\BANCODADOS.fdb';
    bProibidoExecutar := False;
    DMPrincipal.atualizarConexaoAplicativo;
  end
  else
  begin
    DMPrincipal.imprimirMensagem('O arquivo de base de dados não existe em "C:\BANCODADOS.fdb".',
                                 'Aviso');
    lblCaminhoBancoDados.Caption := 'O arquivo de base de dados não existe em "C:\BANCODADOS.fdb".';
    bProibidoExecutar := True;
  end;
end;

procedure TFormPrincipal.btnEmitirRelatorioDadosClick(Sender: TObject);
begin
  if (not bProibidoExecutar) then
  begin
    if (not DMPrincipal.pesquisarVendas) then
      DMPrincipal.imprimirMensagem('Não há registros para serem emitidos.',
                                   'Informação')
    else
    begin
      lblAguarde.Caption := 'Aguarde... Emitindo relatório de dados.';
      Self.Refresh;
      Sleep(2000);
      DMPrincipal.emitirRelatorio;
      lblAguarde.Caption := '';
    end;
  end
  else
  begin
    DMPrincipal.imprimirMensagem('O arquivo de base de dados não existe em "C:\BANCODADOS.fdb".',
                                 'Aviso');
    lblCaminhoBancoDados.Caption := 'O arquivo de base de dados não existe em "C:\BANCODADOS.fdb".';
    bProibidoExecutar := True;
  end;
end;

procedure TFormPrincipal.btnExcluirTodosDadosClick(Sender: TObject);
var
  cursorSalvo             : TCursor;
  iQtdeRegistrosExcluidos : Integer;
begin
  if (not bProibidoExecutar) then
  begin
    if (not DMPrincipal.pesquisarPrimeiraVenda) then
      DMPrincipal.imprimirMensagem('Não há registros para excluir.', 'Informação')
    else if (DMPrincipal.imprimirMensagem('Deseja excluir todos os Registros?',
                                          'Pergunta')) then
    begin
      cursorSalvo   := Screen.Cursor;
      Screen.Cursor := crHourGlass;

      try
        lblAguarde.Caption := 'Aguarde... Excluindo dados.';
        Self.Enabled       := False;
        Self.Refresh;
        iQtdeRegistrosExcluidos := DMPrincipal.excluirTodosRegistros;

        if (iQtdeRegistrosExcluidos > 0) then
          DMPrincipal.imprimirMensagem('Exclusão realizada com sucesso.' + sLineBreak +
                                       IntToStr(iQtdeRegistrosExcluidos) + ' registros foram excluídos.',
                                       'Informação');

        Self.Enabled  := True;
        Self.Refresh;

        if (edtQtdeRegistros.CanFocus) then
          edtQtdeRegistros.SetFocus;

      finally
        Screen.Cursor      := cursorSalvo;
        Self.Enabled       := True;
        Self.Refresh;
        lblAguarde.Caption := '';
      end;
    end;
  end
  else
  begin
    DMPrincipal.imprimirMensagem('O arquivo de base de dados não existe em "C:\BANCODADOS.fdb".',
                                 'Aviso');
    lblCaminhoBancoDados.Caption := 'O arquivo de base de dados não existe em "C:\BANCODADOS.fdb".';
    bProibidoExecutar := True;
  end;
end;

procedure TFormPrincipal.btnGravarDadosClick(Sender: TObject);
var
  cursorSalvo    : TCursor;
  iQtdeRegistros : Integer;
begin
  if (not bProibidoExecutar) then
  begin
    cursorSalvo   := Screen.Cursor;
    Screen.Cursor := crHourGlass;

    try
      iQtdeRegistros := StrToIntDef(edtQtdeRegistros.Text, 0);

      if (iQtdeRegistros = 0) then
      begin
        DMPrincipal.imprimirMensagem('A Qtde de Registros dever ser maior que 0.',
                                     'Aviso');

        if (edtQtdeRegistros.CanFocus) then
          edtQtdeRegistros.SetFocus;
      end
      else if (iQtdeRegistros > 100000) then
      begin
        if (DMPrincipal.imprimirMensagem('Gravar mais de 100.000 registros de uma só vez ' + sLineBreak +
                                         'poderá causar lentidão na aplicação.' + sLineBreak + sLineBreak +
                                         'Gostaria de continuar mesmo assim?',
                                         'Pergunta')) then
        begin
          lblAguarde.Caption := 'Aguarde... Gravando dados.';
          Self.Enabled       := False;
          Self.Refresh;

          if (DMPrincipal.gravarRegistros(iQtdeRegistros)) then
            DMPrincipal.imprimirMensagem('Gravação realizada com sucesso.',
                                         'Informação');

          Self.Enabled  := True;
          Self.Refresh;

          if (edtQtdeRegistros.CanFocus) then
            edtQtdeRegistros.SetFocus;
        end;
      end
      else
      begin
        lblAguarde.Caption := 'Aguarde... Gravando dados.';
        Self.Enabled       := False;
        Self.Refresh;

        if (DMPrincipal.gravarRegistros(iQtdeRegistros)) then
          DMPrincipal.imprimirMensagem('Gravação realizada com sucesso.',
                                       'Informação');

        Self.Enabled  := True;
        Self.Refresh;

        if (edtQtdeRegistros.CanFocus) then
          edtQtdeRegistros.SetFocus;
      end;

    finally
      Screen.Cursor      := cursorSalvo;
      Self.Enabled       := True;
      Self.Refresh;
      lblAguarde.Caption := '';
    end;
  end
  else
  begin
    DMPrincipal.imprimirMensagem('O arquivo de base de dados não existe em "C:\BANCODADOS.fdb".',
                                 'Aviso');
    lblCaminhoBancoDados.Caption := 'O arquivo de base de dados não existe em "C:\BANCODADOS.fdb".';
    bProibidoExecutar := True;
  end;
end;

procedure TFormPrincipal.btnInformacoesClick(Sender: TObject);
begin
  DMPrincipal.imprimirMensagem('Link do projeto: https://github.com/viniciuslopesmelo/Aplicacao-Delphi',
                               'Informação');
end;

end.
