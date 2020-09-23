Attribute VB_Name = "modverifydata"
Public Function checkdata() As Integer
With mainfrm
If .Appname.Text = "" Then
checkdata = 1
Exit Function
End If
If .trialkey.Text = "" Then
checkdata = 2
Exit Function
End If
If .Unlockkey.Text = "" Then
checkdata = 3
Exit Function
End If
If .appversion.Text = "" Then
checkdata = 4
Exit Function
End If
If IsNumeric(.appversion.Text) = False Then
checkdata = 5
Exit Function
End If
If .Optdays(0).Value = True Then
If .Txtdays.Text = "" Or Val(.Txtdays.Text) < 1 Or IsNumeric(.Txtdays) = False Then
checkdata = 6
End If
Exit Function
End If
If .optcount.Value = True Then
If .txtcount.Text = "" Or Val(.txtcount.Text) < 1 Or IsNumeric(.txtcount.Text) = False Then
checkdata = 7
End If
Exit Function
End If
If .optdate.Value = True Then
If Format(.DTPicker1.Value, "MM-DD-YY") < Format(Date, "MM-DD-TT") Then
checkdata = 8
End If
Exit Function
End If
If .optversion.Value = True And IsNumeric(.txtversion.Text) = False Or .txtversion.Text = "" Then
checkdata = 9
Exit Function
End If

If .optversion.Value = True And .txtversion.Text < .appversion.Text Or .txtversion.Text = .appversion.Text Then
checkdata = 10
Exit Function
End If
If .chkregpw.Value = 1 And .txtregpw.Text = "" Then
checkdata = 11
Exit Function
End If
If .chkublock.Value = 1 And .txtublockpw.Text = "" Then
checkdata = 12
Exit Function
End If
End With
End Function
