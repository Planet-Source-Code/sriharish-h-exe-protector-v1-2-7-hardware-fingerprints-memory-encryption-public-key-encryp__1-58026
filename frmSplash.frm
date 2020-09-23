VERSION 5.00
Begin VB.Form frmSplash 
   BorderStyle     =   0  'None
   ClientHeight    =   6375
   ClientLeft      =   210
   ClientTop       =   1365
   ClientWidth     =   7695
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   Icon            =   "frmSplash.frx":0000
   KeyPreview      =   -1  'True
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Picture         =   "frmSplash.frx":000C
   ScaleHeight     =   6375
   ScaleWidth      =   7695
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
End
Attribute VB_Name = "frmSplash"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Sub Form_Click()
mainfrm.Show
Unload Me
End Sub

Private Sub Form_Load()
Dim shellsuccess As Long
If MsgBox("Do you want to vote for this code?", vbInformation + vbYesNo, "Knock Knock") = vbYes Then
shellsuccess = ShellExecute(Me.hwnd, "Open", "http://b.domaindlx.com/discbreaker/votepage.asp", 0&, 0&, 10)
End If
End Sub
