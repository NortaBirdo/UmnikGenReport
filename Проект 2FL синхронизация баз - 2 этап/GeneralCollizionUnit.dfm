object GeneralCollizionForm: TGeneralCollizionForm
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1056#1072#1079#1088#1077#1096#1077#1085#1080#1077' '#1082#1086#1083#1083#1080#1079#1080#1080
  ClientHeight = 406
  ClientWidth = 783
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 471
    Height = 13
    Caption = 
      #1054#1073#1085#1072#1088#1091#1078#1077#1085#1099' '#1082#1086#1083#1083#1080#1079#1080#1080'. '#1055#1086#1078#1072#1083#1091#1081#1089#1090#1072', '#1091#1082#1072#1078#1080#1090#1077' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1082#1086#1087#1080#1088#1086#1074#1072#1085#1080#1103 +
      ' '#1076#1083#1103' '#1084#1077#1090#1072#1090#1072#1073#1083#1080#1094#1099':'
  end
  object Label2: TLabel
    Left = 8
    Top = 87
    Width = 31
    Height = 13
    Caption = 'SQLite'
  end
  object Label3: TLabel
    Left = 8
    Top = 232
    Width = 36
    Height = 13
    Caption = 'FireBird'
  end
  object MataNameTabLabel: TLabel
    Left = 485
    Top = 16
    Width = 3
    Height = 13
  end
  object OkButton: TButton
    Left = 8
    Top = 374
    Width = 97
    Height = 25
    Caption = #1054#1082
    TabOrder = 0
    OnClick = OkButtonClick
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 35
    Width = 137
    Height = 46
    Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1074#1089#1077
    Items.Strings = (
      'FireBird -> SQLite'
      'SQLite -> FireBird')
    TabOrder = 1
    OnClick = RadioGroup1Click
  end
  object SkipAllButton: TButton
    Left = 678
    Top = 374
    Width = 97
    Height = 25
    Caption = #1055#1088#1086#1087#1091#1089#1090#1080#1090#1100' '#1074#1089#1077
    TabOrder = 2
    OnClick = SkipAllButtonClick
  end
  object SQLStringGrid: TStringGrid
    Left = 8
    Top = 106
    Width = 767
    Height = 120
    DefaultColWidth = 80
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnDblClick = SQLStringGridDblClick
    OnDrawCell = SQLStringGridDrawCell
    OnMouseMove = SQLStringGridMouseMove
    OnSelectCell = SQLStringGridSelectCell
  end
  object FBStringGrid: TStringGrid
    Left = 8
    Top = 248
    Width = 767
    Height = 120
    DefaultColWidth = 80
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnDblClick = FBStringGridDblClick
    OnDrawCell = FBStringGridDrawCell
    OnMouseMove = FBStringGridMouseMove
    OnSelectCell = FBStringGridSelectCell
  end
end
