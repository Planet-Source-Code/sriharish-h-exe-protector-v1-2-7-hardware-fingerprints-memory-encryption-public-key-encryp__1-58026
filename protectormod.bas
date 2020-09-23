Attribute VB_Name = "protectormod"
' Exe Protector v1.2 Open Source Main Module
' Author: Sriharish
' Email: sriharish@msn.com?Subject=ExeProtector
' Website: http://www.sriharish.info
' Loader: v1.2
' SDK: v1.0, Creep v1.1
' Registration Module: 1.2
' Hardware Keys: 2.1
' Loader Hook 1.2
' 3rd Party Modules used: Softice Detection system By David Ericsson, Progressbar by Mario Flores,SHA256 by Phil Fresle
' Special Thanks: Wilson Chan, Lee Cook,John Taylor, Tyson (for the site and support)
'--------------------------------------------------------------------------
' Memory Encryption: 1.1
' Memory Strip: 1.1
' Variable Memory Encryption: 1.0
' Variable Keys: 1.0
' Trial by Days: 1.2
' Trial by Count: 1.0
' Trial by Version: 1.0 (BETA)
' Trial by Date: 1.3
'---------------------------------------------------------------------------
' Language Editor: 0.5 (not fully complete)
' Protector Mod: 1.1
' Licensefile: 1.2
' Signature: EPOS12 (Exe Protector Open Source v1.2)
'----------------------------------------------------------------------------
'WARNING: DO NOT MODIFY THIS FILE, ALWAYS BACKUP!!!!!!
'----------------------------------------------------------------------------
Public Type License_File
Signature As String
Appname As String
appversion As String
filename As String
helpfile As String
trialkey As String
unlockkey As String
restrip As String
recrypt As String
recryptvar As String
creep As String
Variablekeys As String
Language As String
SMART As String
GEO As String
BIOS As String
CPU As String
MEM As String
VOLUME As String
Onecopy As String
Startup As String
TrialIncrease As String
Resettrial As String
Keychecksum As String
ep As String
slot As String
email As String
website As String
level As String
crc As String
PW_Reg As String
PW_unblock As String
Blacklistcount As String
Languagedata(0 To 14) As String
Blacklistdata() As String
ByteStrip(1 To 1023) As String
End Type
Private licinfo As License_File
Dim rcrypt As clsRijndael
Dim encryption As clsCryptoAPIandCompression
Public sessionfiletitle As String
Public cryptlevel As String
Dim crc32 As crc32cls
Dim pe As CPEEditor
Dim sect As CSectionHeader
Public Sub Protect_file()
Dim filenumber, i As Integer
Dim strkey As String
Dim reschunk() As Byte
Set rcrypt = New clsRijndael
Set pe = New CPEEditor

Set encryption = New clsCryptoAPIandCompression
filenumber = FreeFile
Open App.path & "\" & "PUBLIC_KEY.PBK" For Binary Access Read As filenumber
strkey = String(LOF(filenumber), vbNullChar)
Get filenumber, , strkey
Close filenumber
encryption.SessionStart
'===========================================================================
encryption.ValuePublicKey = String(Len(strkey), vbNullChar) 'initialize the variable
encryption.ValuePublicKey = strkey
encryption.Import_KeyPair , True
'===========================================================================
If mainfrm.Chkbackup.Value = 1 Then
'On Error Resume Next
FileCopy mainfrm.filename.Text, mainfrm.filename.Text & sessionfiletitle & ".original"
End If
With mainfrm
ReDim licinfo.Blacklistdata(.blacklst.ListCount)
If .Optdays(0).Value = True Then
licinfo.trialkey = rcrypt.EncryptString(CreateTrialkey(1, .Txtdays.Text), Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .optcount.Value = True Then
licinfo.trialkey = rcrypt.EncryptString(CreateTrialkey(2, .txtcount.Text), Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .optdate.Value = True Then
licinfo.trialkey = rcrypt.EncryptString(CreateTrialkey(3, Format(.DTPicker1.Value, "MM-DD-YY")), Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .optversion.Value = True Then
licinfo.trialkey = rcrypt.EncryptString(CreateTrialkey(4, .txtversion.Text), Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
licinfo.unlockkey = rcrypt.EncryptString(CreateUnlockKey(.unlockkey.Text), Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
licinfo.Appname = rcrypt.EncryptString(.Appname.Text, Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
licinfo.appversion = rcrypt.EncryptString(.appversion.Text, Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
If .eamiltxt.Text = "" Then
licinfo.email = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.email = rcrypt.EncryptString(.eamiltxt.Text, Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .website.Text = "" Then
licinfo.website = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.website = rcrypt.EncryptString(.website.Text, Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If Trim$(cryptlevel) = "" Then
licinfo.level = rcrypt.EncryptString("150", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.level = rcrypt.EncryptString(cryptlevel, Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If licinfo.helpfile = "" Then
licinfo.helpfile = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.helpfile = rcrypt.EncryptString(.helptext.Text, Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
licinfo.filename = rcrypt.EncryptString(sessionfiletitle, Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
If .chkrestrip.Value = 1 Then
licinfo.restrip = rcrypt.EncryptString("1", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.restrip = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .Chkmem.Value = 1 Then
licinfo.recrypt = rcrypt.EncryptString("1", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.recrypt = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .Chkvarmem.Value = 1 Then
licinfo.recryptvar = rcrypt.EncryptString("1", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.recryptvar = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .Chkcreep.Value = 1 Then
licinfo.creep = rcrypt.EncryptString("1", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.creep = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .chkvar.Value = 1 Then
licinfo.Variablekeys = rcrypt.EncryptString("1", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.Variablekeys = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .Chklang.Value = 1 Then
licinfo.Language = rcrypt.EncryptString("1", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.Language = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .Chkone.Value = 1 Then
licinfo.Onecopy = rcrypt.EncryptString("1", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.Onecopy = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .chkstartup.Value = 1 Then
licinfo.Startup = rcrypt.EncryptString("1", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.Startup = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .chkreset.Value = 1 Then
licinfo.Resettrial = rcrypt.EncryptString("1", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.Resettrial = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .chkincrease.Value = 1 Then
licinfo.TrialIncrease = rcrypt.EncryptString("1", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.TrialIncrease = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .txtregpw.Text = "" Then
licinfo.PW_Reg = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.PW_Reg = rcrypt.EncryptString(.txtregpw.Text, Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If Trim$(.txtublockpw.Text) = "" Then
licinfo.PW_unblock = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.PW_unblock = rcrypt.EncryptString(.txtublockpw.Text, Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
For i = 0 To 14
licinfo.Languagedata(i) = rcrypt.EncryptString(.Lstlang.List(i), Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Next

.Lstlang.Enabled = False
For i = 0 To UBound(licinfo.Blacklistdata()) - 1
If .blacklst.List(i) <> "" Then
licinfo.Blacklistdata(i) = rcrypt.EncryptString(.blacklst.List(i), Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
Next

licinfo.Keychecksum = rcrypt.EncryptString(stringchecksum(.trialkey.Text), Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))

licinfo.Blacklistcount = rcrypt.EncryptString(.blacklst.ListCount, Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
stripfile
For i = 1 To 1023
licinfo.ByteStrip(i) = rcrypt.EncryptString(licinfo.ByteStrip(i), Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Next
If Len(Hex(licinfo.ep)) <= 4 Then
licinfo.slot = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.slot = rcrypt.EncryptString("1", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
licinfo.ep = rcrypt.EncryptString(licinfo.ep, Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))

If .lsthardware.Selected(0) = True Then
licinfo.SMART = rcrypt.EncryptString("1", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.SMART = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .lsthardware.Selected(1) = True Then
licinfo.GEO = rcrypt.EncryptString("1", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.GEO = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .lsthardware.Selected(2) = True Then
licinfo.BIOS = rcrypt.EncryptString("1", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.BIOS = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .lsthardware.Selected(3) = True Then
licinfo.CPU = rcrypt.EncryptString("1", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.CPU = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .lsthardware.Selected(4) = True Then
licinfo.MEM = rcrypt.EncryptString("1", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.MEM = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
If .lsthardware.Selected(5) = True Then
licinfo.VOLUME = rcrypt.EncryptString("1", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.VOLUME = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
licinfo.Signature = "EPOS12"
If .chkCRC.Value = 1 Then
licinfo.crc = rcrypt.EncryptString(getcrc(.filename.Text), Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
Else
licinfo.crc = rcrypt.EncryptString("0", Chr(100) & Chr(111) & Chr(110) & Chr(39) & Chr(116) & Chr(32) & Chr(98) & Chr(111) & Chr(116) & Chr(104) & Chr(101) & Chr(114))
End If
'If .chkreport.Value = 1 Then
'createreport
'End If
Close filenumber
If FileExists(Left(.filename.Text, Len(.filename.Text) - Len(sessionfiletitle)) & "Portus.lic") = True Then
Kill Left(.filename.Text, Len(.filename.Text) - Len(sessionfiletitle)) & "Portus.lic"
End If
Open Left(.filename.Text, Len(.filename.Text) - Len(sessionfiletitle)) & "Portus.lic.temp" For Binary As filenumber
Put #filenumber, , licinfo
Close filenumber
encryption.EncryptFile_KeyPair Left(.filename.Text, Len(.filename.Text) - Len(sessionfiletitle)) & "Portus.lic.temp", Left(.filename.Text, Len(.filename.Text) - Len(sessionfiletitle)) & "Portus.lic"
Kill Left(.filename.Text, Len(.filename.Text) - Len(sessionfiletitle)) & "Portus.lic.temp"
If .chkreport.Value = 1 Then
createreport Left(.filename.Text, Len(.filename.Text) - Len(sessionfiletitle))
If FileExists(App.path & "\" & "Report.html") = True Then
FileCopy App.path & "\" & "report.html", Left(.filename.Text, Len(.filename.Text) - Len(sessionfiletitle)) & "report.html"
End If
End If
Name mainfrm.filename.Text As mainfrm.filename.Text & ".locked"

End With

Exit Sub
error:
MsgBox Err.Description
End Sub
Private Function getcrc(filename As String)
Dim byteArray() As Byte
Dim lfilelength As Long
Dim filenumber As Integer
filenumber = FreeFile
Set crc32 = New crc32cls
Open filename For Binary Access Read As filenumber
lfilelength = LOF(filenumber)
ReDim byteArray(lfilelength)
Get filenumber, , byteArray()
Close filenuber
getcrc = crc32.CalcCRC32(byteArray)
End Function
Private Sub stripfile()

  Dim filenum As Integer
  Dim stripchunk As Byte
  Dim stringval As String
  Dim i, k As Integer
Set pe = New CPEEditor
pe.LoadFile mainfrm.filename.Text
    
    
    Set sect = pe.SectionHeaders(2)

    Set rcrypt = New clsRijndael
    On Error GoTo fileerror
    filenum = FreeFile
    k = 1
    Open mainfrm.filename.Text For Binary As filenum
    For i = Val(pe.OptionalHeader.AddressOfEntryPoint + 1) To Val(pe.OptionalHeader.AddressOfEntryPoint + 1023)
        Get #filenum, i, stripchunk
        licinfo.ByteStrip(k) = CDec(stripchunk)
       
        'Put #filenum, i, 0
        stripchunk = Empty
        stringval = Empty
        k = k + 1
       
    Next
    Close #filenum
    Open mainfrm.filename.Text For Binary As filenum
    For i = Val(pe.OptionalHeader.AddressOfEntryPoint + 1) To Val(pe.OptionalHeader.AddressOfEntryPoint + 1022)
        Put #filenum, i, 0
        stripchunk = Empty
        stringval = Empty
        Next
    Close #filenum
   licinfo.ep = sect.VirtualAddress - sect.PointerToRawData + pe.OptionalHeader.AddressOfEntryPoint
On Error Resume Next
Exit Sub

fileerror:
    MsgBox "Invalid file." & vbCrLf & Err.Description, vbCritical

End Sub
'$DX $AD $AF $FA $FA $RW $VC: 21$MZ:EP+RVA
'$AC $MA $AA $QW $WT $AD $OA: 21$MZ:EP+RVA
'$MX $OP $PA $PM $MM $AT $AA: 10$MZ:EP+RVA
'$VC $XA $XZ $AT $TA $GC $AQ: 2405$MZ:EP+RVA

