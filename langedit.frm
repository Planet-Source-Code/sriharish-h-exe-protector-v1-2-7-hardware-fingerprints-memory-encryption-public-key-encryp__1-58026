VERSION 5.00
Begin VB.Form langedit 
   BorderStyle     =   4  'Fixed ToolWindow
   Caption         =   "Edit Language"
   ClientHeight    =   525
   ClientLeft      =   2760
   ClientTop       =   3630
   ClientWidth     =   3240
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   525
   ScaleWidth      =   3240
   ShowInTaskbar   =   0   'False
   Begin VB.TextBox langtext 
      Height          =   285
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   3015
   End
End
Attribute VB_Name = "langedit"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Option Explicit

Private Sub langtext_Change()
mainfrm.Lstlang.List(mainfrm.Lstlang.ListIndex) = langtext.Text
End Sub
