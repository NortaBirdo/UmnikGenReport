object ChangePassForm: TChangePassForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1057#1084#1077#1085#1072' '#1087#1072#1088#1086#1083#1103
  ClientHeight = 170
  ClientWidth = 308
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 21
    Width = 93
    Height = 13
    Caption = #1048#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
  end
  object Label2: TLabel
    Left = 8
    Top = 48
    Width = 78
    Height = 13
    Caption = #1057#1090#1072#1088#1099#1081' '#1087#1072#1088#1086#1083#1100
  end
  object Label3: TLabel
    Left = 8
    Top = 75
    Width = 72
    Height = 13
    Caption = #1053#1086#1074#1099#1081' '#1087#1072#1088#1086#1083#1100
  end
  object Label4: TLabel
    Left = 8
    Top = 102
    Width = 129
    Height = 13
    Caption = #1055#1086#1074#1090#1086#1088#1080#1090#1077' '#1085#1086#1074#1099#1081' '#1087#1072#1088#1086#1083#1100
  end
  object Okbutton: TButton
    Left = 8
    Top = 126
    Width = 113
    Height = 25
    Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
    TabOrder = 0
    OnClick = OkbuttonClick
  end
  object CancelButton: TButton
    Left = 176
    Top = 126
    Width = 121
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = CancelButtonClick
  end
  object UserNameEdit: TEdit
    Left = 176
    Top = 18
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object OldPassEdit: TEdit
    Left = 176
    Top = 45
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 3
  end
  object NewPassEdit: TEdit
    Left = 176
    Top = 72
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object RepNewPassEdit: TEdit
    Left = 176
    Top = 99
    Width = 121
    Height = 21
    TabOrder = 5
  end
end
