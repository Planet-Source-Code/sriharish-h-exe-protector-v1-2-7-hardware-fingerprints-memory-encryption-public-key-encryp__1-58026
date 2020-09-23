Attribute VB_Name = "Reportmod"

Public Sub createreport(location As String)
Dim filenumber As Integer
filenumber = FreeFile
Open location & "reportdb.xml" For Output As filenumber
With mainfrm
Print #filenumber, Chr(60) & Chr(63) & Chr(120) & Chr(109) & Chr(108) & Chr(32) & Chr(118) & Chr(101) & Chr(114) & Chr(115) & Chr(105) & Chr(111) & Chr(110) & Chr(61) & Chr(34) & Chr(49) & Chr(46) & Chr(48) & Chr(34) & Chr(32) & Chr(101) & Chr(110) & Chr(99) & Chr(111) & Chr(100) & Chr(105) & Chr(110) & Chr(103) & Chr(61) & Chr(34) & Chr(105) & Chr(115) & Chr(111) & Chr(45) & Chr(56) & Chr(56) & Chr(53) & Chr(57) & Chr(45) & Chr(49) & Chr(34) & Chr(32) & Chr(63) & Chr(62)
Print #filenumber, "<!--  Exe Protector Generated Report  -->"
Print #filenumber, "<Main>"
Print #filenumber, "<Data>" & .filename.Text & "</Data>"
Print #filenumber, "<Data>" & .Appname.Text & "</Data>"
Print #filenumber, "<Data>" & .appversion.Text & "</Data>"
Print #filenumber, "<Data>" & .trialkey.Text & "</Data>"
Print #filenumber, "<Data>" & .unlockkey.Text & "</Data>"
Print #filenumber, "<Data>" & .eamiltxt.Text & "</Data>"
Print #filenumber, "<Data>" & .website.Text & "</Data>"
Print #filenumber, "<Data>" & .helptext.Text & "</Data>"
If .chkrestrip.Value = 1 Then
Print #filenumber, "<Data>" & "Enabled" & "</Data>"
Else
Print #filenumber, "<Data>" & "Disabled" & "</Data>"
End If
If .Chkmem.Value = 1 Then
Print #filenumber, "<Data>" & "Enabled" & "</Data>"
Else
Print #filenumber, "<Data>" & "Disabled" & "</Data>"
End If
If .Chkvarmem.Value = 1 Then
Print #filenumber, "<Data>" & "Enabled" & "</Data>"
Else
Print #filenumber, "<Data>" & "Disabled" & "</Data>"
End If
If .Chkcreep.Value = 1 Then
Print #filenumber, "<Data>" & "Enabled" & "</Data>"
Else
Print #filenumber, "<Data>" & "Disabled" & "</Data>"
End If
If .Optdays(0).Value = True Then
Print #filenumber, "<Data>" & "Trial by Days" & "</Data>"
Print #filenumber, "<Data>" & .Txtdays.Text & "</Data>"
End If
If .optcount.Value = True Then
Print #filenumber, "<Data>" & "Trial by Count" & "</Data>"
Print #filenumber, "<Data>" & .txtcount.Text & "</Data>"
End If
If .optdate.Value = True Then
Print #filenumber, "<Data>" & "Trial by Date" & "</Data>"
Print #filenumber, "<Data>" & Format(.DTPicker1.Value, "MM-DD-YY") & "</Data>"
End If
If .optversion.Value = True Then
Print #filenumber, "<Data>" & "Trial by Version" & "</Data>"
Print #filenumber, "<Data>" & .txtversion.Text & "</Data>"
End If
If .chkvar.Value = 1 Then
Print #filenumber, "<Data>" & "Enabled" & "</Data>"
Else
Print #filenumber, "<Data>" & "Disabled" & "</Data>"
End If
If .Chklang.Value = 1 Then
Print #filenumber, "<Data>" & "Enabled" & "</Data>"
Else
Print #filenumber, "<Data>" & "Disabled" & "</Data>"
End If
If .lsthardware.Selected(0) = True Then
Print #filenumber, "<Data>" & "Enabled" & "</Data>"
Else
Print #filenumber, "<Data>" & "Disabled" & "</Data>"
End If
If .lsthardware.Selected(1) = True Then
Print #filenumber, "<Data>" & "Enabled" & "</Data>"
Else
Print #filenumber, "<Data>" & "Disabled" & "</Data>"
End If
If .lsthardware.Selected(2) = True Then
Print #filenumber, "<Data>" & "Enabled" & "</Data>"
Else
Print #filenumber, "<Data>" & "Disabled" & "</Data>"
End If
If .lsthardware.Selected(3) = True Then
Print #filenumber, "<Data>" & "Enabled" & "</Data>"
Else
Print #filenumber, "<Data>" & "Disabled" & "</Data>"
End If
If .lsthardware.Selected(4) = True Then
Print #filenumber, "<Data>" & "Enabled" & "</Data>"
Else
Print #filenumber, "<Data>" & "Disabled" & "</Data>"
End If
If .lsthardware.Selected(5) = True Then
Print #filenumber, "<Data>" & "Enabled" & "</Data>"
Else
Print #filenumber, "<Data>" & "Disabled" & "</Data>"
End If
If .Chkone.Value = 1 Then
Print #filenumber, "<Data>" & "Enabled" & "</Data>"
Else
Print #filenumber, "<Data>" & "Disabled" & "</Data>"
End If
If .chkstartup.Value = 1 Then
Print #filenumber, "<Data>" & "Enabled" & "</Data>"
Else
Print #filenumber, "<Data>" & "Disabled" & "</Data>"
End If
If .chkreset.Value = 1 Then
Print #filenumber, "<Data>" & "Enabled" & "</Data>"
Else
Print #filenumber, "<Data>" & "Disabled" & "</Data>"
End If
If .chkincrease.Value = 1 Then
Print #filenumber, "<Data>" & "Enabled" & "</Data>"
Else
Print #filenumber, "<Data>" & "Disabled" & "</Data>"
End If
If .chkCRC.Value = 1 Then
Print #filenumber, "<Data>" & "Enabled" & "</Data>"
Else
Print #filenumber, "<Data>" & "Disabled" & "</Data>"
End If
Print #filenumber, "<Data>" & .txtregpw.Text & "</Data>"
Print #filenumber, "<Data>" & .txtublockpw.Text & "</Data>"
Print #filenumber, "<Data>" & .blacklst.ListCount & "</Data>"
Print #filenumber, "</Main>"
End With
Close #filenumber

End Sub
