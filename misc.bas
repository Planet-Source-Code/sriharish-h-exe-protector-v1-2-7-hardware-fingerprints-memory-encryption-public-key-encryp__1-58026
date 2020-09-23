Attribute VB_Name = "misc"
Public Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpOperation As String, ByVal lpFile As String, ByVal lpParameters As String, ByVal lpDirectory As String, ByVal nShowCmd As Long) As Long
Public Function Convert2Hex(ByVal sAsciiData As String) As String

  Dim lDataLen As Long, iCounter As Long
  Dim sHexData As String, sReturnData As String

    lDataLen = Len(sAsciiData)
    For iCounter = 1 To lDataLen
        sHexData = Hex(Asc(Mid$(sAsciiData, iCounter, 1)))
        If Len(sHexData) < 2 Then sHexData = "0" & sHexData
        sReturnData = sReturnData & sHexData
        sHexData = ""
    Next iCounter
    Convert2Hex = sReturnData

End Function

Public Function convert2Ascii(ByVal sHexData As String) As String

  Dim lDataLen As Long, iCounter As Long
  Dim sAsciiData As String, sReturnData As String

    lDataLen = Len(sHexData)
    For iCounter = 1 To lDataLen Step 2
        sAsciiData = Chr$(CLng("&H" & (Mid$(sHexData, iCounter, 2))))
        sReturnData = sReturnData & sAsciiData
        sAsciiData = ""
    Next iCounter
    convert2Ascii = sReturnData

End Function

Public Function FileExists(sFileName As String) As Boolean
    On Error GoTo FExistsError
    Dim f As String
    f = FreeFile
    Open sFileName For Input As #f 'Open file
    Close #f
FExistsError:
    If Err.Number = 53 Then 'If doesn't exists
        FileExists = False 'Set FileExists to False
    ElseIf Err.Number = 0 Then 'else if exists
        FileExists = True 'Set FileExists to True
    End If
End Function

Public Sub saveproject(filename As String)
Dim projinfo As License_File
Dim i, filenumber As Integer
With mainfrm
If FileExists(filename) = True Then
Kill (filename)
End If
ReDim projinfo.Blacklistdata(.blacklst.ListCount)
projinfo.filename = .filename.Text
projinfo.Appname = .Appname.Text
projinfo.appversion = .appversion.Text
projinfo.trialkey = .trialkey.Text
projinfo.unlockkey = .unlockkey.Text
projinfo.email = .eamiltxt.Text
projinfo.website = .website.Text
projinfo.helpfile = .helptext.Text
If .Chkmem.Value = 1 Then
projinfo.recrypt = "1"
Else
projinfo.recrypt = "0"
End If
If .Chkvarmem = 1 Then
projinfo.recryptvar = "1"
Else
projinfo.recryptvar = "0"
End If
If .chkrestrip.Value = 1 Then
projinfo.restrip = "1"
Else
projinfo.restrip = "0"
End If
If .Chkcreep.Value = 1 Then
projinfo.creep = "1"
Else
projinfo.creep = "0"
End If
If .chkvar.Value = 1 Then
projinfo.Variablekeys = "1"
Else
projinfo.Variablekeys = "0"
End If
If .Chklang.Value = 1 Then
projinfo.Language = "1"
Else
projinfo.Language = "0"
End If
If .lsthardware.Selected(0) = True Then
projinfo.SMART = "1"
Else
projinfo.SMART = "0"
End If
If .lsthardware.Selected(1) = True Then
projinfo.GEO = "1"
Else
projinfo.GEO = "0"
End If
If .lsthardware.Selected(2) = True Then
projinfo.BIOS = "1"
Else
projinfo.BIOS = "0"
End If
If .lsthardware.Selected(3) = True Then
projinfo.CPU = "1"
Else
projinfo.CPU = "0"
End If
If .lsthardware.Selected(4) = True Then
projinfo.MEM = "1"
Else
projinfo.MEM = "0"
End If
If .lsthardware.Selected(5) = True Then
projinfo.VOLUME = "1"
Else
projinfo.VOLUME = "0"
End If
If .Chkone.Value = 1 Then
projinfo.Onecopy = "1"
Else
projinfo.Onecopy = "0"
End If
If .chkstartup.Value = 1 Then
projinfo.Startup = "1"
Else
projinfo.Startup = "0"
End If
If .chkreset.Value = 1 Then
projinfo.Resettrial = "1"
Else
projinfo.Resettrial = "0"
End If
If .chkincrease.Value = 1 Then
projinfo.TrialIncrease = "1"
Else
projinfo.TrialIncrease = "0"
End If
If .chkCRC.Value = 1 Then
projinfo.crc = "1"
Else
projinfo.crc = "0"
End If
projinfo.level = cryptlevel
projinfo.PW_Reg = .txtregpw.Text
projinfo.PW_unblock = .txtublockpw.Text
For i = 0 To .blacklst.ListCount - 1
projinfo.Blacklistdata(i) = .blacklst.List(i)
Next i
.Lstlang.Enabled = True
projinfo.Blacklistcount = .blacklst.ListCount
For i = 0 To 14

projinfo.Languagedata(i) = .Lstlang.List(i)
Next i
.Lstlang.Enabled = False
projinfo.Signature = "EPOP12Proj"
filenumber = FreeFile
Open filename For Binary As filenumber
Put filenumber, , projinfo
Close filenumber
End With
End Sub
Public Sub openproject(filename As String)
Dim projinfo As License_File
Dim i, filenumber As Integer
filenumber = FreeFile
If FileExists(filename) = False Then
MsgBox "Invalid  Project File."
Exit Sub
End If
Open filename For Binary As filenumber
Get filenumber, , projinfo
Close filenumber
If projinfo.Signature <> "EPOP12Proj" Then
MsgBox "Invalid Project File.", vbCritical
Exit Sub
End If
With mainfrm
.filename.Text = projinfo.filename
.Appname.Text = projinfo.Appname
.trialkey.Text = projinfo.trialkey
.unlockkey.Text = projinfo.unlockkey
.eamiltxt.Text = projinfo.email
.website.Text = projinfo.website
.helptext.Text = projinfo.helpfile
.appversion.Text = projinfo.appversion
If projinfo.restrip = "1" Then
.chkrestrip.Value = 1
Else
.chkrestrip.Value = 0
End If
If projinfo.recrypt = "1" Then
.Chkmem.Value = 1
Else
.Chkmem.Value = 0
End If
If projinfo.recryptvar = "1" Then
.Chkvarmem.Value = 1
Else
.Chkvarmem.Value = 0
End If
If projinfo.creep = "1" Then
.Chkcreep.Value = 1
Else
.Chkcreep.Value = 0
End If
If projinfo.Variablekeys = "1" Then
.chkvar.Value = 1
Else
.chkvar = 0
End If
Advanced.Slider1.Value = Val(projinfo.level)
If projinfo.Language = "1" Then
.Lstlang.Clear
For i = 0 To 14
.Lstlang.AddItem projinfo.Languagedata(i)
Next
End If
If projinfo.SMART = "1" Then
.lsthardware.Selected(0) = True
Else
.lsthardware.Selected(0) = False
End If
If projinfo.GEO = "1" Then
.lsthardware.Selected(1) = True
Else
.lsthardware.Selected(1) = False
End If
If projinfo.BIOS = "1" Then
.lsthardware.Selected(2) = True
Else
.lsthardware.Selected(2) = False
End If
If projinfo.CPU = "1" Then
.lsthardware.Selected(3) = True
Else
.lsthardware.Selected(3) = False
End If
If projinfo.MEM = "1" Then
.lsthardware.Selected(4) = True
Else
.lsthardware.Selected(4) = False
End If
If projinfo.VOLUME = "1" Then
.lsthardware.Selected(5) = True
Else
.lsthardware.Selected(5) = False
End If
If projinfo.Onecopy = "1" Then
.Chkone.Value = 1
Else
.Chkone.Value = 0
End If
If projinfo.Startup = "1" Then
.chkstartup.Value = 1
Else
.chkstartup = 0
End If
If projinfo.Resettrial = "1" Then
.chkreset.Value = 1
Else
.chkreset.Value = 0
End If
If projinfo.TrialIncrease = "1" Then
.chkincrease.Value = 1
Else
.chkincrease = 0
End If
If projinfo.crc = "1" Then
.chkCRC.Value = 1
Else
.chkCRC = 0
End If
.txtregpw.Text = projinfo.PW_Reg
.txtublockpw.Text = projinfo.PW_unblock
If projinfo.Blacklistcount <> "0" Then
i = 0
.blacklst.Clear
.lbltotal.Caption = 0
For i = 0 To projinfo.Blacklistcount
.blacklst.AddItem projinfo.Blacklistdata(i)
Next
End If
.lbltotal.Caption = projinfo.Blacklistcount
End With
End Sub
