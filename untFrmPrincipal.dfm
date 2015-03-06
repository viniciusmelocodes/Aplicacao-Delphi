object FormPrincipal: TFormPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Aplica'#231#227'o Delphi com Base de Dados e Report Builder'
  ClientHeight = 184
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlProjeto: TPanel
    Left = 0
    Top = 0
    Width = 457
    Height = 184
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    ExplicitHeight = 187
    object lblCaminhoBancoDados: TLabel
      Left = 8
      Top = 162
      Width = 316
      Height = 16
      Caption = 'Caminho da Base de Dados: C:\BANCODADOS.fdb'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblAguarde: TLabel
      Left = 25
      Top = 130
      Width = 406
      Height = 25
      AutoSize = False
      Caption = 'Aguarde...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHotLight
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btnGravarDados: TButton
      Left = 25
      Top = 64
      Width = 190
      Height = 54
      Caption = 'Gravar dados'
      TabOrder = 1
      OnClick = btnGravarDadosClick
    end
    object edtQtdeRegistros: TLabeledEdit
      Left = 133
      Top = 27
      Width = 190
      Height = 21
      EditLabel.Width = 87
      EditLabel.Height = 13
      EditLabel.Caption = 'Qtde de Registros'
      NumbersOnly = True
      TabOrder = 0
      Text = '0'
    end
    object btnEmitirRelatorioDados: TButton
      Left = 241
      Top = 64
      Width = 190
      Height = 25
      Caption = 'Emitir relat'#243'rio de dados'
      TabOrder = 2
      OnClick = btnEmitirRelatorioDadosClick
    end
    object btnExcluirTodosDados: TButton
      Left = 241
      Top = 93
      Width = 190
      Height = 25
      Caption = 'Excluir todos os dados'
      TabOrder = 3
      OnClick = btnExcluirTodosDadosClick
    end
    object btnInformacoes: TButton
      Left = 356
      Top = 153
      Width = 75
      Height = 25
      Caption = 'Informa'#231#245'es'
      TabOrder = 4
      OnClick = btnInformacoesClick
    end
  end
end
