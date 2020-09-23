VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form Advanced 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Advanced Options- Encryption Level"
   ClientHeight    =   1890
   ClientLeft      =   45
   ClientTop       =   435
   ClientWidth     =   5130
   Icon            =   "Advanced.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1890
   ScaleWidth      =   5130
   StartUpPosition =   1  'CenterOwner
   Begin MSComctlLib.Slider Slider1 
      Height          =   435
      Left            =   120
      TabIndex        =   0
      Top             =   960
      Width           =   4815
      _ExtentX        =   8493
      _ExtentY        =   767
      _Version        =   393216
      Min             =   1
      Max             =   1023
      SelStart        =   150
      TickStyle       =   3
      Value           =   150
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "High"
      Height          =   255
      Left            =   4320
      TabIndex        =   4
      Top             =   1440
      Width           =   615
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Normal"
      Height          =   255
      Left            =   2040
      TabIndex        =   3
      Top             =   1440
      Width           =   615
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Default"
      Height          =   255
      Left            =   120
      TabIndex        =   2
      Top             =   1440
      Width           =   615
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   $"Advanced.frx":000C
      Height          =   615
      Left            =   120
      TabIndex        =   1
      Top             =   120
      Width           =   4695
   End
End
Attribute VB_Name = "Advanced"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Slider1_Change()
cryptlevel = Slider1.Value
End Sub
