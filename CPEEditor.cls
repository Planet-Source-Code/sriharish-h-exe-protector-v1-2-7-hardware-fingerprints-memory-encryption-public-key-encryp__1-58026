VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CPEEditor"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'dzzie@yahoo.com
'http://sandsprite.com

Public SectionHeaders As New Collection 'of CSectionHeader
Public OptionalHeader As New COptionalHeader

Public errMessage As String

Private DOSHEADER As IMAGEDOSHEADER
Private NTHEADER As IMAGE_NT_HEADERS

Private myFile As String

Function LoadFile(fpath As String) As Boolean
    On Error GoTo hell
        
        Dim i As Long
        Dim f As Long
        Dim udtSH As IMAGE_SECTION_HEADER
        
        errMessage = Empty
        If Not FileExists(fpath) Then Err.Raise 1
            
        f = FreeFile
        Open fpath For Binary As f
        Get f, , DOSHEADER
        Get f, DOSHEADER.e_lfanew + 1, NTHEADER
        
        If NTHEADER.Signature <> "PE" & Chr(0) & Chr(0) Then Err.Raise 2
        
        OptionalHeader.LoadStruc NTHEADER.OptionalHeader
                
        For i = 1 To NTHEADER.FileHeader.NumberOfSections
            Get f, , udtSH
            AddToSections i, udtSH
        Next
         
        Close f
        LoadFile = True
        myFile = fpath
        
Exit Function
hell:
    Select Case Err.Number
        Case 1: errMessage = "File not found: " & fpath
        Case 2: errMessage = "Invalid PE signature: " & NTHEADER.Signature
        Case Else: errMessage = Err.Description
    End Select
    
End Function

Private Sub AddToSections(i As Long, sh As IMAGE_SECTION_HEADER)
     Dim csh As New CSectionHeader
     csh.LoadStruc sh
     SectionHeaders.Add csh, "sect:" & i
End Sub

Function SaveChanges() As Boolean
   On Error GoTo hell
   
    errMessage = Empty
    If Len(myFile) = 0 Then Err.Raise 1
    If Not FileExists(myFile) Then Err.Raise 2
    
    Dim i As Long
    Dim f As Long
    Dim udtSH As IMAGE_SECTION_HEADER
    Dim csh As CSectionHeader
    
    f = FreeFile
            
    NTHEADER.OptionalHeader = OptionalHeader.GetStruc
    
    Open myFile For Binary As f
    Put f, , DOSHEADER
    Put f, DOSHEADER.e_lfanew + 1, NTHEADER
            
    For i = 1 To NTHEADER.FileHeader.NumberOfSections
        Set csh = SectionHeaders("sect:" & i)
        udtSH = csh.GetStruc
        Put f, , udtSH
    Next
    
    SaveChanges = True
    
Exit Function
hell:
    Select Case Err.Number
        Case 1: errMessage = "No file is currently Loaded"
        Case 2: errMessage = "File not found: " & myFile
        Case Else: errMessage = Err.Description
    End Select
    
End Function

Sub AddSection(csh As CSectionHeader) 'not tested yet
    Dim cur As Integer
    
    cur = NTHEADER.FileHeader.NumberOfSections
    cur = cur + 1
    
    SectionHeaders.Add csh, "sect:" & cur
    NTHEADER.FileHeader.NumberOfSections = cur
    
End Sub



Private Function FileExists(path) As Boolean
  If Len(path) = 0 Then Exit Function
  If Dir(path, vbHidden Or vbNormal Or vbReadOnly Or vbSystem) <> "" Then FileExists = True
End Function




