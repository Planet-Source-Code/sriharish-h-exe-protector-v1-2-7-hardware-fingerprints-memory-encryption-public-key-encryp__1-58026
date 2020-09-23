Attribute VB_Name = "CreateKeys"
Dim rcrypt As clsRijndael
Dim crc32 As crc32cls
Public Function CreateTrialkey(trialtype As Integer, Data As String)
Dim tempstring As String
Dim keydata As String
Dim trialdata As String
 Dim Final As String
Set rcrypt = New clsRijndael
tempstring = EncryptKey("mD2wdcxAEca312af", mainfrm.trialkey.Text) & Chr(176)
Select Case trialtype
Case 1:
keydata = rcrypt.EncryptString("1", mainfrm.trialkey.Text, False) & Chr(176)
trialdata = rcrypt.EncryptString(Data, mainfrm.trialkey.Text, False)
Case 2:
keydata = rcrypt.EncryptString("2", mainfrm.trialkey.Text, False) & Chr(176)
trialdata = rcrypt.EncryptString(Data, mainfrm.trialkey.Text, False)
Case 3:
keydata = rcrypt.EncryptString("3", mainfrm.trialkey.Text, False) & Chr(176)
trialdata = rcrypt.EncryptString(Data, mainfrm.trialkey.Text, False)
Case 4
keydata = rcrypt.EncryptString("4", mainfrm.trialkey.Text, False) & Chr(176)
trialdata = rcrypt.EncryptString(Data, mainfrm.trialkey.Text, False)
End Select
Final = tempstring & keydata & trialdata
CreateTrialkey = EncodeStr64(Final)
tempstring = Empty
keydata = Empty
Final = Empty
trialdata = Empty
End Function

Public Function CreateUnlockKey(unlockkey As String)
Dim tempstring As String
Dim mainkey As String
Set rcrypt = New clsRijndael
tempstring = EncryptKey(unlockkey, "aeQEdfmvPxz221@@") & Chr(176)
mainkey = rcrypt.EncryptString(tempstring, unlockkey, False)
CreateUnlockKey = EncodeStr64(tempstring & mainkey)
tempstring = Empty
mainkey = Empty
End Function
Private Function EncryptKey(Key1 As String, txtcode As String)
'This Module is a Part of some encryption
'Also Special Thanks to Alexandra
Dim i, j, k As Integer, thekey
Dim a, b, CryptText As String
On Error Resume Next
    If Key1 <> "" Then
        thekey = Key1
        i = 0
        For j = 1 To Len(txtcode)
            i = i + 1
            If i > Len(thekey) Then i = 1
            a = Mid(txtcode, j, 1)
            k = Asc(a)
            b = Mid(thekey, i, 1)
            k = k + Asc(b)
            If k > 255 Then k = k - 255
            CryptText = CryptText & Chr(k)
        Next j
        txtcode = CryptText
EncryptKey = txtcode
End If
End Function
Public Function stringchecksum(Text As String) As Long
Dim i As Integer
Dim byteArray() As Byte
Set crc32 = New crc32cls
ReDim byteArray(Len(Text))
byteArray() = StrConv(Text, vbFromUnicode)
stringchecksum = crc32.CalcCRC32(byteArray())
End Function
