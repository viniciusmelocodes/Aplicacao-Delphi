{
  Autor: Vinícius Lopes de Melo
  Data: 17/06/2014
  Link: https://github.com/viniciuslopesmelo/Aplicacao-Delphi

  Script da tabela da base de dados:

  CREATE TABLE VENDA (
    ID_VENDA      INTEGER NOT NULL,
    NOME_CLIENTE  VARCHAR(100),
    VALOR         NUMERIC(15,2));

  ALTER TABLE VENDA ADD CONSTRAINT PK_VENDA PRIMARY KEY (ID_VENDA);

}

unit untDMPrincipal;

interface

uses
  untDMConexao,

  Forms, Variants, SysUtils, Classes, DBXFirebird, DB, SqlExpr,
  FMTBcd, ppDB, ppDBPipe, ppComm, ppRelatv, ppProd, ppClass,
  ppReport, DBClient, Provider, ppCtrls, ppPrnabl, ppBands,
  ppCache, ppDesignLayer, ppParameter, ppVar, Windows,
  Dialogs, Controls;

type
  TDMPrincipal = class(TDataModule)
    dsDados: TDataSource;
    dspDados: TDataSetProvider;

    qryDados: TSQLQuery;
    qryDadosID_VENDA: TIntegerField;
    qryDadosNOME_CLIENTE: TStringField;
    qryDadosVALOR: TFMTBCDField;
    qryPesquisa: TSQLQuery;

    cdsDados: TClientDataSet;
    cdsDadosID_VENDA: TIntegerField;
    cdsDadosNOME_CLIENTE: TStringField;
    cdsDadosVALOR: TFMTBCDField;

    ppReport: TppReport;
    ppDBPipeline: TppDBPipeline;
    ppParameterList1: TppParameterList;
    ppDesignLayers1: TppDesignLayers;
    ppDesignLayer1: TppDesignLayer;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    ppDBText1: TppDBText;
    ppDBText2: TppDBText;
    ppDBText3: TppDBText;
    ppLabel1: TppLabel;
    ppLabel2: TppLabel;
    ppLabel3: TppLabel;
    ppLabel4: TppLabel;
    ppSystemVariable1: TppSystemVariable;
    ppLine1: TppLine;

  public

    function gravarRegistros(iQtdeRegistros: Integer): Boolean;

    function excluirTodosRegistros: Integer;

    function pesquisarPrimeiraVenda: Boolean;

    function pesquisarVendas: Boolean;

    function pesquisarUltimoId: Boolean;

    function emitirRelatorio: Boolean;

    function atualizarConexaoAplicativo: Boolean;

    function imprimirMensagem(sMensagem     : string;
                              sTipoMensagem : string): Boolean;

  end;

var
  DMPrincipal: TDMPrincipal;

implementation

{$R *.dfm}

{ TDMAplicativo }

function TDMPrincipal.atualizarConexaoAplicativo: Boolean;
begin
  DMConexao.atualizarConexaoAplicativo;
end;

function TDMPrincipal.emitirRelatorio: Boolean;
begin
  ppReport.Print;
end;

function TDMPrincipal.excluirTodosRegistros: Integer;
var
  iQtdeRegistrosExcluidos: Integer;
begin
  try
    DMConexao.iniciarTransacao;
    qryDados.Close;
    qryDados.SQL.Clear;
    qryDados.SQL.Add('DELETE FROM VENDA');

    iQtdeRegistrosExcluidos := qryDados.ExecSQL(True);

    if (iQtdeRegistrosExcluidos > 0) then
    begin
      DMConexao.confirmarTransacao;
      Result := iQtdeRegistrosExcluidos;
    end
    else
    begin
      DMConexao.reverterTransacao;
      Result := 0;
    end;

  except
    on E:Exception do
    begin
      DMConexao.reverterTransacao;
      imprimirMensagem('Não foi possível excluir todos os registros.' + sLineBreak + sLineBreak +
                       'Erro: ' + E.Message,
                       'Erro');
    end;
  end;
end;

function TDMPrincipal.gravarRegistros(iQtdeRegistros: Integer): Boolean;
var
  i, iUltimoId: Integer;
begin
  try
    DMConexao.iniciarTransacao;

    if (pesquisarUltimoId) then
    begin
      if (qryPesquisa.FieldByName('ULTIMO_ID').Value = Null) then
        iUltimoId := 0
      else
        iUltimoId := qryPesquisa.FieldByName('ULTIMO_ID').Value;

      if (iUltimoId = 0) then
      begin
        if (not cdsDados.Active) then
          cdsDados.Open;

        for i := 1 to iQtdeRegistros do
        begin
          cdsDados.Append;
          cdsDadosID_VENDA.Value     := i;
          cdsDadosNOME_CLIENTE.Value := 'Cliente Consumidor ' + IntToStr(i);
          cdsDadosVALOR.AsCurrency   := i;
          cdsDados.Post;
        end;
      end
      else
      begin
        Inc(iUltimoId);

        if (not cdsDados.Active) then
          cdsDados.Open;

        for i := 1 to iQtdeRegistros do
        begin
          cdsDados.Append;
          cdsDadosID_VENDA.Value     := iUltimoId;
          cdsDadosNOME_CLIENTE.Value := 'Cliente Consumidor ' + IntToStr(iUltimoId);
          cdsDadosVALOR.AsCurrency   := i;
          cdsDados.Post;

          Inc(iUltimoId);
        end;
      end;
    end
    else
    begin
      if (not cdsDados.Active) then
        cdsDados.Open;

      for i := 1 to iQtdeRegistros do
      begin
        cdsDados.Append;
        cdsDadosID_VENDA.Value     := i;
        cdsDadosNOME_CLIENTE.Value := 'Cliente Consumidor ' + IntToStr(i);
        cdsDadosVALOR.AsCurrency   := i;
        cdsDados.Post;
      end;
    end;

    if (cdsDados.ApplyUpdates(0) = 0) then
    begin
      DMConexao.confirmarTransacao;
      Result := True;
    end
    else
    begin
      DMConexao.reverterTransacao;
      Result := False;
    end;

  except
    on E:Exception do
    begin
      DMConexao.reverterTransacao;
      imprimirMensagem('Não foi possível gravar o registro: ' + sLineBreak +
                       'ID Venda: ' + IntToStr(cdsDadosID_VENDA.Value) +
                       ' Cliente: ' + cdsDadosNOME_CLIENTE.Value +
                       ' Valor: ' + FloatToStr(cdsDadosVALOR.AsCurrency) + sLineBreak + sLineBreak +
                       'Erro: ' + E.Message,
                       'Erro');
    end;
  end;
end;

function TDMPrincipal.imprimirMensagem(sMensagem     : string;
                                       sTipoMensagem : string): Boolean;
begin
  Result := False;

  if (sTipoMensagem = 'Informação') then
    MessageBox(Application.Handle, PWideChar(sMensagem), 'Informação', MB_OK + MB_ICONINFORMATION)
  else if (sTipoMensagem = 'Aviso') then
    MessageBox(Application.Handle, PWideChar(sMensagem), 'Aviso', MB_OK + MB_ICONWARNING)
  else if (sTipoMensagem = 'Erro') then
    MessageBox(Application.Handle,
               PWideChar(sMensagem + sLineBreak + sLineBreak + 'Dúvidas? Entre em contato com o desenvolvedor.'),
               'Erro',
               MB_OK + MB_ICONERROR)
  else if (sTipoMensagem = 'Pergunta') then
  begin
    if (MessageBox(Application.Handle, PWideChar(sMensagem), 'Pergunta', MB_YESNO + MB_ICONQUESTION + MB_DEFBUTTON2) = IDYES) then
      Result := True
    else
      Result := False;
  end;
end;

function TDMPrincipal.pesquisarPrimeiraVenda: Boolean;
begin
  qryPesquisa.Close;
  qryPesquisa.SQL.Clear;
  qryPesquisa.SQL.Add('SELECT FIRST 1 * ');
  qryPesquisa.SQL.Add('  FROM VENDA');
  qryPesquisa.Open;

  if (not qryPesquisa.IsEmpty) then
    Result := True
  else
    Result := False;
end;

function TDMPrincipal.pesquisarUltimoId: Boolean;
begin
  qryPesquisa.Close;
  qryPesquisa.SQL.Clear;
  qryPesquisa.SQL.Add('SELECT MAX(ID_VENDA) AS ULTIMO_ID FROM VENDA');
  qryPesquisa.Open;

  if (not qryPesquisa.IsEmpty) then
    Result := True
  else
    Result := False;
end;

function TDMPrincipal.pesquisarVendas: Boolean;
begin
  cdsDados.Close;
  qryDados.SQL.Clear;
  qryDados.SQL.Add('SELECT * FROM VENDA');
  cdsDados.Open;

  if (not cdsDados.IsEmpty) then
    Result := True
  else
    Result := False;
end;

end.
