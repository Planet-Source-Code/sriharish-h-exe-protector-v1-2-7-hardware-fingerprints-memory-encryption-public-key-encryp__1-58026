VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "crc32cls"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private CRCTable(0 To 255) As Long

Public Function CalcCRC32(byteArray() As Byte) As Long
Dim Limit As Long
Dim crc As Long
Dim Temp1 As Long
Dim Temp2 As Long
Dim i As Long
  Limit = UBound(byteArray)
  crc = -1
  For i = 0 To Limit
    If crc < 0 Then
      Temp1 = crc And &H7FFFFFFF
      Temp1 = Temp1 \ 256
      Temp1 = (Temp1 Or &H800000) And &HFFFFFF
    Else
      Temp1 = (crc \ 256) And &HFFFFFF
    End If
    Temp2 = byteArray(i)   ' get the byte
    Temp2 = CRCTable((crc Xor Temp2) And &HFF)
    crc = Temp1 Xor Temp2
  Next i
  crc = crc Xor &HFFFFFFFF
  CalcCRC32 = crc
End Function

Private Sub Class_Initialize()
Dim i As Integer
Dim j As Integer
Dim Limit As Long
Dim crc As Long
Dim Temp1 As Long
  Limit = &HEDB88320
  For i = 0 To 255
    crc = i
    For j = 8 To 1 Step -1
      If crc < 0 Then
        Temp1 = crc And &H7FFFFFFF
        Temp1 = Temp1 \ 2
        Temp1 = Temp1 Or &H40000000
      Else
        Temp1 = crc \ 2
      End If
      If crc And 1 Then
        crc = Temp1 Xor Limit
      Else
        crc = Temp1
      End If
    Next j
    CRCTable(i) = crc
  Next i
End Sub


