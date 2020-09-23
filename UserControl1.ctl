VERSION 5.00
Begin VB.UserControl EzCryptoApi 
   AutoRedraw      =   -1  'True
   BackColor       =   &H00000000&
   ClientHeight    =   1080
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   930
   InvisibleAtRuntime=   -1  'True
   MaskColor       =   &H00FFFFFF&
   ScaleHeight     =   1080
   ScaleWidth      =   930
   Begin VB.Image Image1 
      BorderStyle     =   1  'Fixed Single
      Height          =   960
      Left            =   60
      Top             =   60
      Width           =   810
   End
End
Attribute VB_Name = "EzCryptoApi"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'******************************************************'
'------------------------------------------------------'
' Project: EzCryptoAPI v1.0.7
'
' Date: July-28-2001
'
' Programmer: Antonio Ramirez Cobos
'
' Module: frmTest
'
' Description: Encrypts/Decrypts/Hash files or data string, by using
'              Cryptographic Algorithms API. For extended
'              Information about the functionality of the control
'              and its use, check its help file EzCryptoAPI.chm
'
'              The only thing not included in this Control is
'              the possibility of creating exchange keys or Key BLOB
'              for encryption/decryption PGP [Pretty Good Privacy] style
'              Maybe on a near future.
'                               THIS IS IMPORTANT
'              Remember to register rsaenh.dll on your system's registry
'              using Regsvr32.dll.
'
'              From the Author:
'              'cause I consider myself in a continuous learning
'              path with no end on programming, please, if you
'              can improve this program
'              contact me at: *TONYDSPANIARD@HOTMAIL.COM*
'
'              I would be pleased to hear from your opinions,
'              suggestions, and/or recommendations. Also, if you
'              know something I don't know and wish to share it
'              with me, here you'll have your techy pal from Spain
'              that will do exactly the same towards you. If I can
'              help you in any way, just ask.
'
'              INTELLECTUAL COPYRIGHT STUFF [Is up to you anyway]
'              --------------------------------------------------
'              This code is copyright 2001 Antonio Ramirez Cobos
'              This code may be reused and modified for non-commercial
'              purposes only as long as credit is given to the author
'              in the programmes about box and it's documentation.
'              If you use this code, please email me at:
'              TonyDSpaniard@hotmail.com and let me know what you think
'              and what you are doing with it.
'
'              PS: Don't forget to vote for me buddy programmer!
'                  I put a lot of effort on this control. Its on of my
'                  little beauties.
'
'------------------------------------------------------'
'******************************************************'
'Enumerators
Public Enum EC_HASH_ALG_ID
    MD2
    MD4
    MD5
    SHA
End Enum
Public Enum EC_HASH_DATAFORMAT
    EC_HF_HEXADECIMAL
    EC_HF_NUMERIC
    EC_HF_ASCII
End Enum
Private Enum EC_HASH_STATUS
    EC_HASH_NONE
    EC_HASH_BUSY
    EC_HASH_READY
End Enum
Private Enum EC_CRYPT_STATUS
    EC_CRYPT_NONE
    EC_CRYPT_BUSY
    EC_CRYPT_READY
End Enum
Private Enum EC_PROVIDER
    [No Providers]
    [Microsoft Base Cryptographic Provider v.1]
    [Microsoft Enhanced Cryptographic Provider]
End Enum
Public Enum EC_CRYPT_ALGO_ID
    RC2
    RC4
    DES
    [Triple DES]
    [Triple DES 112]
End Enum
Public Enum EC_CRYPT_SPEED
    [1KB]
    [2KB]
    [4KB]
    [8KB]
    [16KB]
    [30KB]
    [40KB]
    [50KB]
    [60KB]
    [80KB]
    [100KB]
End Enum
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' Cryptology Service Provider properties
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Private m_CSP_Provider As Long
Private m_Provider_Name As EC_PROVIDER
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' Hash Properties
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Private m_Hash_Object As Long
Private m_Hash_Data(20) As Byte 'This value will usually be 16 or 20, depending on the hash algorithm.
Private m_Hash_DataLen As Long
Private m_Hash_Algo_Id As EC_HASH_ALG_ID
Private m_Hash_Algorithm As Long
Private m_Hash_Status As EC_HASH_STATUS
Private m_Hash_DataReady As Boolean
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' Encryption/Decryption Properties
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Private m_EncDec_Password As String
Private m_EncDec_InBuffer As String
Private m_EncDec_Algo_Id As EC_CRYPT_ALGO_ID
Private m_EncDec_Status As EC_CRYPT_STATUS
Private m_EncDec_Algorithm As Long
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' Blocksize Properties
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Private HP_FILE_RW_BLOCKSIZE As Long
Private m_Speed As EC_CRYPT_SPEED
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' Events
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Event EncryptionFileStart()

Event EncryptionFileStatus(ByVal lBytesProcessed As Long, ByVal lTotalBytes As Long)

Event EncryptionFileComplete()

Event DecryptionFileStart()

Event DecryptionFileStatus(ByVal lBytesProcessed As Long, ByVal lTotalBytes As Long)

Event DecryptionFileComplete()

Event HashFileStart()

Event HashFileStatus(ByVal lBytesProcessed As Long, ByVal lTotalBytes As Long)

Event HashFileComplete()

Event EncryptionDataStart()

Event EncryptionDataComplete()

Event DecryptionDataStart()

Event DecryptionDataComplete()

Event HashDataStart()

Event HashDataComplete()


' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' Properties
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' Provider read-only property
'       Returns the name of the Cryptographic Service provider
'       as a string
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Property Get Provider() As String
    If m_Provider_Name = [Microsoft Base Cryptographic Provider v.1] Then
        Provider = MS_DEF_PROV
    Else
        Provider = MS_ENHANCED_PROV
    End If
End Property

' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' IsHashReady read-only property
'       Returns true if the Hash object is ready for use
'       False otherwise
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Property Get IsHashReady() As Boolean
    IsHashReady = False
    If m_Hash_Status = EC_HASH_READY Then IsHashReady = True
End Property
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' IsHashDataReady read-only property
'       Returns true if the Hash value has been already
'       calculated and ready to be taken
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Property Get IsHashDataReady() As Boolean
    IsHashDataReady = m_Hash_DataReady
End Property
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' Speed property
'       Gets/Sets the block size to be encrypted/decrypted/
'       reading/writing speed
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Property Get Speed() As EC_CRYPT_SPEED
    Speed = m_Speed
End Property
Public Property Let Speed(ByVal newSpeed As EC_CRYPT_SPEED)
    If newSpeed < [1KB] Or newSpeed > [100KB] Then
        ' If running then raise an error
        If Ambient.UserMode = True Then
            Err.Raise vbObjectError + ERROR_ILLEGAL_PROPERTY, "EzCryptoApi", "Illegal property value"
        Else ' Show a message box
            MsgBox "Illegal property value", vbCritical, "Error"
        End If
        Exit Property
    End If
    m_Speed = newSpeed
    Select Case m_Speed
        Case [1KB]: HP_FILE_RW_BLOCKSIZE = HP_FILE_RW_BLOCKSIZE_1k
        Case [2KB]: HP_FILE_RW_BLOCKSIZE = HP_FILE_RW_BLOCKSIZE_2k
        Case [4KB]: HP_FILE_RW_BLOCKSIZE = HP_FILE_RW_BLOCKSIZE_4k
        Case [8KB]: HP_FILE_RW_BLOCKSIZE = HP_FILE_RW_BLOCKSIZE_8k
        Case [16KB]: HP_FILE_RW_BLOCKSIZE = HP_FILE_RW_BLOCKSIZE_16k
        Case [30KB]: HP_FILE_RW_BLOCKSIZE = HP_FILE_RW_BLOCKSIZE_30k
        Case [40KB]: HP_FILE_RW_BLOCKSIZE = HP_FILE_RW_BLOCKSIZE_40k
        Case [50KB]: HP_FILE_RW_BLOCKSIZE = HP_FILE_RW_BLOCKSIZE_50k
        Case [60KB]: HP_FILE_RW_BLOCKSIZE = HP_FILE_RW_BLOCKSIZE_60k
        Case [80KB]: HP_FILE_RW_BLOCKSIZE = HP_FILE_RW_BLOCKSIZE_80k
        Case [100KB]: HP_FILE_RW_BLOCKSIZE = HP_FILE_RW_BLOCKSIZE_100k
    End Select
End Property
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' HashAlgorithm property
'       Gets/Sets the Algorithm used for 'Hashing' data
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Property Let HashAlgorithm(ByVal hAlgoId As EC_HASH_ALG_ID)
    ' If not a valid setting then raise an error
    If hAlgoId < 0 Or hAlgoId > 3 Then
        ' If running then raise an error
        If Ambient.UserMode = True Then
            Err.Raise vbObjectError + ERROR_ILLEGAL_PROPERTY, "EzCryptoApi", "Illegal property value"
        Else ' Show a message box
            MsgBox "Illegal property value", vbCritical, "Error"
        End If
        Exit Property
    End If
    ' Set algorithm
    m_Hash_Algo_Id = hAlgoId
    ' Find out the algorithm we are going to use
    ' And set the variable that we use to create
    ' the Hash
    Select Case m_Hash_Algo_Id
        Case MD2: m_Hash_Algorithm = CALG_MD2
        Case MD4: m_Hash_Algorithm = CALG_MD4
        Case MD5: m_Hash_Algorithm = CALG_MD5
        Case SHA: m_Hash_Algorithm = CALG_SHA
    End Select
End Property
Public Property Get HashAlgorithm() As EC_HASH_ALG_ID
    HashAlgorithm = m_Hash_Algo_Id
End Property
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' Password property
'       Gets/Sets the Password used to encrypt/decrypt data
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Property Get Password() As String
    Password = m_EncDec_Password
End Property
Public Property Let Password(ByVal sPassword As String)
    m_EncDec_Password = sPassword
End Property
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' EncryptionAlgorithm property
'       Gets/Sets the Algorithm used for encrypt/decrypt data
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Property Get EncryptionAlgorithm() As EC_CRYPT_ALGO_ID
    EncryptionAlgorithm = m_EncDec_Algo_Id
End Property
Public Property Let EncryptionAlgorithm(ByVal ecEncryptID As EC_CRYPT_ALGO_ID)
    ' If invalid setting then raise an error
    If ecEncryptID < RC2 Or ecEncryptID > [Triple DES 112] Then
        Err.Raise vbObjectError + ERROR_ILLEGAL_PROPERTY, , "Illegal property value"
        Exit Property
    End If
    ' No providers? Sorry, display annoying msgbox
    If m_Provider_Name = [No Providers] Then
        If Ambient.UserMode = True Then
            Err.Raise vbObjectError + ERROR_NO_KEY_CONTAINER, "EzCryptoApi", "Failed to get a handle to your key containers" & vbCrLf & _
                        "Please check if your Cryptographic providers are correctly installed!"
       Else
            MsgBox "EzCryptoApi failed to get a handle to your key containers" & vbCrLf & _
                    "Please check if your Cryptographic providers are correctly installed!", vbCritical, "Fatal Error  [EzCryptoApi]"
       End If
       Exit Property
    End If
    ' Check the type of provider we have. If Base CSP then
    ' we got RC2, RC4, and DES. Raise an error if that is the
    ' case and the user tries to set the algorithm to other
    ' than those above mentioned.
    If m_Provider_Name = [Microsoft Base Cryptographic Provider v.1] And _
       (ecEncryptID = [Triple DES] Or ecEncryptID = [Triple DES 112]) Then
       If Ambient.UserMode = True Then
            Err.Raise vbObjectError + ERROR_ALGO_NOT_SUPP, "EzCryptoApi", "Your Cryptographic Service Provider does not support this algorithm"
       Else
            MsgBox "Your Cryptographic Service Provider does not support this algorithm." & _
            "Make sure you have correctly registered [Microsoft Enhanced Cryptographic Provider]enhsig.dll-rsaenh.dll ", vbExclamation, "Error"
       End If
       Exit Property
    End If
    m_EncDec_Algo_Id = ecEncryptID
    ' Adjust the variable that holds the actual
    ' value for the algorithm to be used as a
    ' parameter with CryptEncrypt/CryptDecrypt
    Select Case m_EncDec_Algo_Id
        Case RC2: m_EncDec_Algorithm = CALG_RC2
        Case RC4: m_EncDec_Algorithm = CALG_RC4
        Case DES: m_EncDec_Algorithm = CALG_DES
        Case [Triple DES]: m_EncDec_Algorithm = CALG_3DES
        Case [Triple DES 112]: m_EncDec_Algorithm = CALG_3DES_112
    End Select
End Property
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' Sub Procedures
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' CreateHash Sub procedure
'       Initializes Hash Object
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Sub CreateHash()
Dim lError As Long
On Error GoTo ErrCreateHash
    ' lReturn: Holds the value returned by InitProvider()
    Dim lReturn As Long
    ' If we have an already created hash object
    ' then "KILL IT"
    If m_Hash_Status = EC_HASH_READY Then
        Call DestroyHash
    End If
    ' Let's try!
    ' Get a handle to the provider
    lReturn = InitProvider()
    ' No success getting a handle to the provider?
    ' Then raise an error
    If lReturn = 0 Then
        lError = ERROR_NO_KEY_CONTAINER
        Err.Raise vbObjectError ' Fire error handler
    End If
        
    'Attempt to acquire a handle to a Hash object
    If Not CBool(CryptCreateHash(m_CSP_Provider, m_Hash_Algorithm, _
            0, 0, m_Hash_Object)) Then
            lError = ERROR_NO_HASH_CREATE
            Err.Raise vbObjectError ' Fire error handler
    End If
    ' Hash Status = READY [to work!]
    m_Hash_Status = EC_HASH_READY
    Exit Sub
ErrCreateHash:
    ' Just raise the error back to the user
    ' so it can be trap by him/her
    Dim sMsg As String
    Select Case lError
        Case ERROR_NO_KEY_CONTAINER: sMsg = "Error getting a handle to key containers"
        Case ERROR_NO_HASH_CREATE: sMsg = "Unable to initialize Hash object"
        Case Else: Err.Raise Err.Number, "EzCryptoApi", Err.Description
    End Select
    Err.Raise Number:=(vbObjectError + lError), Source:="EzCryptoApi", Description:=sMsg
End Sub
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' HashDigestData Sub procedure
'       Creates a 'Digest' of the data
' Input:
'       1] sData: The data to be 'digested'
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Sub HashDigestData(ByVal sData As String)
Dim lError As Long
On Error GoTo ErrDigest
    If m_Hash_Status = EC_HASH_BUSY Then Exit Sub
    m_Hash_DataReady = False ' Data not ready yet
    m_Hash_DataLen = NO_DATASET
    ' If we don't have a created Hash object
    ' then raise an error
    If m_Hash_Status <> EC_HASH_READY Then
        lError = ERROR_NO_HASH_CREATED
        GoTo ErrNoCreated
        'Err.Raise vbObjectError + 1004, , "Hash Object has not been created yet."
    End If
    ' Raise HashDataStart event
    RaiseEvent HashDataStart
    ' We are busy
    m_Hash_Status = EC_HASH_BUSY
    Dim lDataLen As Long ' Holds the length of the data
    lDataLen = Len(sData)
    ' Digest data
    If Not CBool(CryptHashData(m_Hash_Object, sData, lDataLen, 0)) Then
        lError = ERROR_NO_DIGEST
        Err.Raise vbObjectError ' Fire error handler
        'Err.Raise vbObjectError + 1005, , "Unable to digest the data."
    End If
    ' Call SetHashData procedure to set
    ' the variable that holds the result
    ' of this digestion [see SetHashData]
    Call SetHashData
    If m_Hash_DataLen = NO_DATASET Then
        lError = ERROR_NO_HASH_DATA
        Err.Raise vbObjectError ' Fire error handler
    End If
    m_Hash_DataReady = True  ' Yep! Data ready
    m_Hash_Status = EC_HASH_READY  ' And we are ready to work again
    ' Raise event HashDataComplete
    RaiseEvent HashDataComplete
    Exit Sub
ErrNoCreated:
    Err.Raise vbObjectError + lError, "EzCryptoApi", "Hash Object has not been created yet"
ErrDigest:
    Dim sMsg As String
    m_Hash_Status = EC_HASH_READY
    Select Case lError
        Case ERROR_NO_DIGEST: sMsg = "Error 'digesting' data"
        Case ERROR_NO_HASH_DATA: sMsg = "Error setting/getting digested data"
        Case Else: Err.Raise Err.Number, "EzCryptoApi", Err.Description
    End Select
    Err.Raise vbObjectError + error, "EzCryptoApi", sMsg
End Sub
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' HashDigestFile Sub procedure
'       Creates a 'Digest' of the data
' Input:
'       1] sFilePath: The path and filename of the file to hash
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Sub HashDigestFile(ByVal sSourceFile As String)
Dim lError As Long
On Error GoTo ErrDigestFile
    ' If hash object is busy let's get out of here
    If m_Hash_Status = EC_HASH_BUSY Then Exit Sub
    m_Hash_DataReady = False ' Data not ready yet
    m_Hash_DataLen = NO_DATASET
    ' If we don't have a created Hash object
    ' then raise an error
    If m_Hash_Status <> EC_HASH_READY Then
        lError = ERROR_NO_HASH_CREATE
        GoTo ErrNoCreated
        'Err.Raise vbObjectError + 1004, , "Hash Object has not been created yet."
    End If
    ' Raise event HashFileStart
    RaiseEvent HashFileStart
    ' We are busy
    m_Hash_Status = EC_HASH_BUSY
    Dim fNum As Long    ' Holds the handle of the file to open
    Dim fLen As Long    ' Length of the file
    Dim fBlockBytes As Long  ' How many blocks of 160 bytes?
    Dim fLostBytes As Long   ' How many bytes remaining?
    Dim fdat() As Byte  ' Holds the bytes read from the file
    Dim iCounter As Integer, jCounter As Integer    ' Counters
    Dim lResult As Long ' Holds the return value of InitProvider()
    Dim lBytesProcessed ' Holds the total number of bytes processed
    
    ' First we check if the file exists
    If Trim(Dir(sSourceFile)) = "" Then
        lError = ERROR_FILE_NOT_FOUND
        Err.Raise vbObjectError ' Fire error handler
        'Err.Raise vbObjectError + 1007, , "File not found"
    End If
    If GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_DIRECTORY Then
        lError = ERROR_IS_DIR
        Err.Raise vbObjectError ' Fire error handler
    End If
    fNum = CreateFile(sSourceFile, GENERIC_READ, FILE_SHARE_READ Or FILE_SHARE_WRITE, ByVal 0&, OPEN_EXISTING, 0, 0)
    If fNum = INVALID_HANDLE_VALUE Then
        lError = ERROR_NO_FILE_OPEN
        Err.Raise vbObjectError ' Fire error handler
    End If
    ' Let's try!
    lBytesProcessed = 0
    ' Open the file for binary reading and lock for the rest!
        ' How long?
    fLen = GetFileSize(fNum, 0)
    ' Set pointer to beginning of file
    SetFilePointer fNum, 0, 0, FILE_BEGIN
    ' Raise the HashFileStatus event
    RaiseEvent HashFileStatus(lBytesProcessed, fLen)
    ' Bigger than the specified size?
    If fLen < HP_FILE_RW_BLOCKSIZE Then
        ' Resize dynamic array
        ReDim fdat(1 To fLen)
        ' Get the data
        ReadFile fNum, fdat(1), fLen, lResult, ByVal 0&
        If lResult <> fLen Then
            lError = ERROR_NO_READ
            Err.Raise vbObjectError ' Fire error handler
        End If
        ' And finally digest the data
        If Not CBool(CryptBinHashData(m_Hash_Object, fdat(1), fLen, 0)) Then
            lError = ERROR_NO_DIGEST
            Err.Raise vbObjectError ' Fire error handler
           'Err.Raise vbObjectError + 1005, , _
                "Unable to digest data."
        End If
        ' Raise the HashFileStatus event
        RaiseEvent HashFileStatus(fLen, fLen)
    Else
            ' Find out how many blocks the file holds
            fBlockBytes = fLen \ HP_FILE_RW_BLOCKSIZE
            ' Find out how many bytes are lost
            fLostBytes = fLen Mod HP_FILE_RW_BLOCKSIZE
            ' Now loop the number of blocks
            ' [First resize array]
            ReDim fdat(1 To HP_FILE_RW_BLOCKSIZE)
            For iCounter = 1 To fBlockBytes
                ' Now get the data
                ReadFile fNum, fdat(1), HP_FILE_RW_BLOCKSIZE, lResult, ByVal 0&
                If lResult <> HP_FILE_RW_BLOCKSIZE Then
                    lError = ERROR_NO_READ
                    Err.Raise vbObjectError ' Fire error handler
                End If
 '               ' Digest the data
                If Not CBool(CryptBinHashData(m_Hash_Object, fdat(1), HP_FILE_RW_BLOCKSIZE, 0)) Then
                    lError = ERROR_NO_DIGEST
                    Err.Raise vbObjectError ' Fire error handler
                   'Err.Raise vbObjectError + 1005, , _
                        "Unable to digest data."
                End If
                ' Add bytes processed and raise the HashFileStatus Event
                lBytesProcessed = lBytesProcessed + HP_FILE_RW_BLOCKSIZE
                RaiseEvent HashFileStatus(lBytesProcessed, fLen)
            Next
            If fLostBytes <> 0 Then
                ' Process lost bytes [bytes remaining]
                ReDim fdat(1 To fLostBytes)
                ' Get the remaining data
                ReadFile fNum, fdat(1), fLostBytes, lResult, ByVal 0&
                If lResult <> fLostBytes Then
                    lError = ERROR_NO_READ
                    Err.Raise vbObjectError ' Fire error handler
                End If
                ' Digest the data [BURP!-- sorry ;)]
                If Not CBool(CryptBinHashData(m_Hash_Object, fdat(1), fLostBytes, 0)) Then
                    lError = ERROR_NO_DIGEST
                    Err.Raise vbObjectError ' Fire error handler
                   'Err.Raise vbObjectError + 1005, , _
                        "Unable to digest data."
                End If
                ' Add bytes processed and raise the HashFileStatus Event
                lBytesProcessed = lBytesProcessed + fLostBytes
                RaiseEvent HashFileStatus(lBytesProcessed, fLen)
            End If
        End If
    CloseHandle fNum
    Erase fdat() ' Free up resources
    ' Set the data hashed to the variable
    Call SetHashData
    If m_Hash_DataLen = NO_DATASET Then
        lError = ERROR_NO_HASH_DATA
        Err.Raise vbObjectError ' Fire error handler
    End If
    m_Hash_DataReady = True
    m_Hash_Status = EC_HASH_READY ' Ready to work again!
    ' Raise HashFileComplete event
    RaiseEvent HashFileComplete
    Exit Sub
ErrNoCreated:
    Err.Raise vbObject + lError, "EzCryptoApi", "Hash Object has not been created yet"
    Exit Sub ' I don't need it but...
ErrDigestFile:
    ' We are not busy anymore
    m_Hash_Status = EC_HASH_READY
    Dim sMsg As String
    If (fNum) Then CloseHandle fNum
    Select Case lError
        Case ERROR_NO_DIGEST: sMsg = "Error digesting data"
        Case ERROR_FILE_NOT_FOUND: sMsg = "File not found"
        Case ERROR_NO_READ: sMsg = "Error reading data"
        Case ERROR_NO_HASH_DATA: sMsg = "Error getting/setting digested data"
        Case ERROR_IS_DIR: sMsg = "EzCryptApi does not digest directories"
        Case Else:  Err.Raise Err.Number, "EzCryptoApi", Err.Description
    End Select
    Err.Raise vbObject + lError, "EzCryptoApi", sMsg
End Sub
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' GetDigestedData Function procedure
'       Returns the digested data from
' Input:
'       1] sFilePath: The path and filename of the file to hash
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Function GetDigestedData(ByVal echfFormat As EC_HASH_DATAFORMAT) As String
Dim lError As Long
On Error GoTo ErrHandler
    If echfFormat < EC_HF_HEXADECIMAL Or echfFormat > EC_HF_ASCII Then
        lError = ERROR_ILLEGAL_PROPERTY
        Err.Raise vbObjectError ' Fire error handler
        'Err.Raise vbObjectError + 1001, , "Illegal property value"
    End If
    'GetDigestedData = m_Hash_Prov.GetHashData(hFormat)
    Dim sData As String, sHex As String
    Dim iCounter As Integer
    If m_Hash_Status = EC_HASH_NONE Then
        lError = ERROR_NO_HASH_CREATE
        Err.Raise vbObjectError ' Fire error handler
        'Err.Raise vbObjectError + 1004, , _
            "The Hash object has not been created yet."
    End If
    If m_Hash_DataLen = NO_DATASET Or m_Hash_DataReady = False Then
        lError = ERROR_NOTHING_DIGESTED
        Err.Raise vbObjectError ' Fire error handler
    End If
    ' Format the data as specified
    Select Case echfFormat
        Case EC_HF_HEXADECIMAL
            For iCounter = 0 To m_Hash_DataLen - 1
                sHex = Hex(m_Hash_Data(iCounter))
                If Len(sHex) > 1 Then
                    sData = sData & sHex & vbTab
                Else
                    sData = sData & "0" & sHex & vbTab
                End If
                sHex = ""
            Next
        Case EC_HF_NUMERIC
            For iCounter = 0 To m_Hash_DataLen - 1
                sData = sData & CStr(m_Hash_Data(iCounter))
            Next
        Case EC_HF_ASCII
            For iCounter = 0 To m_Hash_DataLen - 1
                sData = sData & Chr(m_Hash_Data(iCounter))
            Next
    End Select
    GetDigestedData = sData
    Exit Function
ErrHandler:
    Dim sMsg As String
    Select Case lError
        Case ERROR_NO_HASH_CREATE: sMsg = "Hash object has not been created yet"
        Case ERROR_NOTHING_DIGESTED: sMsg = "Nothing has been digested yet"
        Case Else: Err.Raise Err.Number, "EzCryptoApi", Err.Description
    End Select
    Err.Raise vbObjectError + lError, "EzCryptoApi", sMsg
End Function
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' DestroyHash Sub procedure
'       Destroys the Hash Object [if any]
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Sub DestroyHash()
Dim lError As Long
On Error GoTo ErrDestroyHash
    ' We do some action only if we got
    ' the object, otherwise just pass
    If m_Hash_Status = EC_HASH_READY Then
        If Not CBool(CryptDestroyHash(m_Hash_Object)) Then
            lError = ERROR_NO_HASH_CREATE
            Err.Raise vbObjectError ' Fire error handler
            'Err.Raise vbObjectError + 1008, , "Unable to destroy Hash Object."
        End If
        ' Re-set property values
        m_Hash_DataLen = 0
        m_Hash_DataReady = False
        m_Hash_Status = EC_HASH_NONE
    End If
    Exit Sub
ErrDestroyHash:
    If lError = ERROR_NO_HASH_CREATE Then
        Err.Raise vbObjectError + lError, "EzCryptoApi", "Unable to destroy Hash object"
    Else: Err.Raise Err.Number, "EzCryptoApi", Err.Description
    End If
End Sub
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' SetHashData Sub procedure
'       Initializes m_Hash_Data byte array with the hash value
'       of the data digested
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Private Sub SetHashData()
Dim lLength As Long
   lLength = 20&     ' This will hold the actual length of the digested data
   If Not CBool(CryptGetHashParam(m_Hash_Object, HP_HASHVAL, m_Hash_Data(0), _
                  lLength, 0)) Then
        m_Hash_DataLen = 0
        Exit Sub
   End If
   ' Set the module variable to the actual length of the hash value
   m_Hash_DataLen = lLength
End Sub
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' About Sub procedure
'       Shows my fantastic about dialog box
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Sub about()
Attribute about.VB_UserMemId = -552
   ' Dim f As New frmAbout
    'f.Show vbModal
    'Set f = Nothing
End Sub
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' EncryptFile Sub procedure
'       Encrypts a Source file Overwriting the source. This
'       method is very useful with files small in size as it
'       reads the data in one shot, and writes cipher data in
'       shot.
' Input:
'       1] sSourceFile: Source Path and filename of the file
'                       to encrypt
'       2] ReadWriteOffset: The offset byte from where the control
'                           has to start encrypting and writing
'                           resulting cipher data to the file.
'                           It is very useful if the encrypted file
'                           has to hold a header which has to be read
'                           afterwards.
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Sub EncryptFile(ByVal sSourceFile As String, Optional ReadWriteOffset As Long = 0)
' Before anything starts to rock' and roll
' check if we are busy doing something
If m_EncDec_Status = EC_CRYPT_BUSY Then
    Exit Sub ' Get out of here!
End If
Dim lKey As Long            ' Encryption Key
Dim lBuffLen As Long        ' Length of Buffer
Dim lFileLen As Long        ' Length of File to encrypt
Dim lFileNum As Long        ' File number
Dim lBlockBytes As Long     ' How many blocks?
Dim lLostBytes As Long      ' How many bytes remaining?
Dim iCounter As Long        ' Counter
Dim lBytesProcessed As Long ' Bytes processed
Dim bFileData() As Byte     ' Buffer of bytes to encrypt
Dim btempFileData() As Byte ' Temp buffer
Dim lLength As Long         ' Length of data bytes read/encrypt/write
Dim lResult As Long         ' Length of data bytes read/write
Dim lFileAttrib As Long     ' File Attributes
Dim lError As Long          ' Error values

m_EncDec_Status = EC_CRYPT_BUSY ' working...
'm_EncDec_FileEnc = False    ' Start
On Error GoTo ErrEncrypt
' Check if the file exists
If Trim(Dir$(sSourceFile)) = "" Then
    lError = ERROR_FILE_NOT_FOUND
    Err.Raise vbObjectError ' Fire error handler
    'Err.Raise vbObjectError + 1007, , "File not found"
End If
' Proceed...
' Find out which attributes the source file has
' and store it for further setting
If GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_NORMAL Then
    lFileAttrib = FILE_ATTRIBUTE_NORMAL
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_SYSTEM Then
    lFileAttrib = FILE_ATTRIBUTE_SYSTEM
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_HIDDEN Then
    lFileAttrib = FILE_ATTRIBUTE_SYSTEM
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_READONLY Then
    lFileAttrib = FILE_ATTRIBUTE_READONLY
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_TEMPORARY Then
    lFileAttrib = FILE_ATTRIBUTE_TEMPORARY
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_DIRECTORY Then
    lError = ERROR_IS_DIR
    Err.Raise vbObjectError ' Fire error handler
End If
' Now set its attributes to normal, so we can
' work with it
If Not lFileAttrib = FILE_ATTRIBUTE_NORMAL Then
    SetFileAttributes sSourceFile, FILE_ATTRIBUTE_NORMAL
End If

' Initialize encryption key
lKey = InitKey
If lKey = 0 Then
    lError = ERROR_NO_KEY_DERIVED
    Err.Raise vbObjectError ' Fire error handler
End If

' Open the file again now using API functions (real fast)
' Source file for reading and writing
lFileNum = CreateFile(sSourceFile, GENERIC_READ Or GENERIC_WRITE, FILE_SHARE_READ Or FILE_SHARE_WRITE, ByVal 0&, OPEN_EXISTING, 0, 0)
If lFileNum = INVALID_HANDLE_VALUE Then
    lError = ERROR_NO_FILE_OPEN
    Err.Raise vbObjectError ' Fire error handler
End If
' Set the file pointer at ReadFromOffset point
SetFilePointer lFileNum, ReadWriteOffset, 0, FILE_BEGIN
' Get the source file length
lFileLen = GetFileSize(lFileNum, 0) - ReadWriteOffset
' Get everything in one shot an write it in one shot
' Prepare buffer space
ReDim bFileData(1 To (lFileLen * 2))
' Read the file in one shot
ReadFile lFileNum, bFileData(1), lFileLen, lResult, ByVal 0&
If lResult <> lFileLen Then
    lError = ERROR_NO_READ
    Err.Raise vbObjectError ' Fire error handler
End If
' Put pointer at ReadWriteOffset to write back the encrypted data without corrupting headers
SetFilePointer lFileNum, ReadWriteOffset, 0, FILE_BEGIN
' Raise event EncryptFileStart
RaiseEvent EncryptionFileStart
If lFileLen <= HP_FILE_RW_BLOCKSIZE Then ' If less than encryption blocksize encrypt in one shot
    ' Let's encrypt the block
    ' Prepare variables for encryption)
    lLength = lFileLen
    lBuffLen = UBound(bFileData)
    If Not CBool(CryptEncrypt(lKey, 0, 1, 0, bFileData(1), lLength, lBuffLen)) Then
        lError = ERROR_NO_ENCRYPT
        Err.Raise vbObjectError ' Fire error handler
    End If
    ' Write the results back to the file
    WriteFile lFileNum, bFileData(1), lLength, lResult, ByVal 0&
    If lResult <> lLength Then
        lError = ERROR_NO_WRITE
        Err.Raise vbObjectError ' Fire error handler
    End If
    ' Raise event
    RaiseEvent EncryptionFileStatus(lFileLen, lFileLen)
Else
' Find out how many HP_FILE_BLOCKSIZE blocks are
    lBlockBytes = lFileLen \ HP_FILE_RW_BLOCKSIZE
    ' And lost bytes
    lLostBytes = lFileLen Mod HP_FILE_RW_BLOCKSIZE
    ' Allocate space
    ' Now loop through the blocks and keep encrypting and writing data back to the file
    ReDim btempFileData(1 To (HP_FILE_RW_BLOCKSIZE * 2))
    Dim Offset As Currency ' just to be sure
    Offset = 1 ' offset to read from file data array
    lLength = HP_FILE_RW_BLOCKSIZE
    For iCounter = 1 To lBlockBytes
        ' Read from source array to temp
        CopyMem btempFileData(1), bFileData(Offset), HP_FILE_RW_BLOCKSIZE
        ' Prepare buffer
        lBuffLen = UBound(btempFileData)
        ' Encrypt data!
        If Not CBool(CryptEncrypt(lKey, 0, 0, 0, btempFileData(1), lLength, lBuffLen)) Then
            lError = ERROR_NO_ENCRYPT
            Err.Raise vbObjectError ' Fire error handler
        End If
        ' Write to file
        WriteFile lFileNum, btempFileData(1), lLength, lResult, ByVal 0&
        If lResult <> lLength Then
            lError = ERROR_NO_WRITE
            Err.Raise vbObjectError ' Fire error handler
        End If
        ' Update offset
        Offset = Offset + HP_FILE_RW_BLOCKSIZE
        DoEvents
        ' Raise event
        lBytesProcessed = (lBytesProcessed + HP_FILE_RW_BLOCKSIZE)
        RaiseEvent EncryptionFileStatus(lBytesProcessed, lFileLen)
    Next
'    ' Now get the lost bytes [if any]
    If lLostBytes <> 0 Then
        ' Get them in one shot
        ReDim btempFileData(1 To (lLostBytes * 2))
        CopyMem btempFileData(1), bFileData(Offset), lLostBytes
        ' prepare for encryption
        lLength = lLostBytes
        lBuffLen = UBound(btempFileData)
        'Encrypt data!
        If Not CBool(CryptEncrypt(lKey, 0, 1, 0, btempFileData(1), lLength, lBuffLen)) Then
            lError = ERROR_NO_ENCRYPT
            Err.Raise vbObjectError ' Fire error handler
        End If
        ' Write results to file
        WriteFile lFileNum, btempFileData(1), lLength, lResult, ByVal 0&
        If lResult <> lLength Then
            lError = ERROR_NO_WRITE
            Err.Raise vbObjectError ' Fire error handler
        End If
        ' Raise event
        lBytesProcessed = (lBytesProcessed + (lLostBytes))
        RaiseEvent EncryptionFileStatus(lBytesProcessed, lFileLen)
    End If
End If
' Destroy the key
If (lKey) Then CryptDestroyKey lKey
lKey = 0
'' Close the file again
If (lFileNum) Then CloseHandle lFileNum
' Free up resources
Erase bFileData
Erase btempFileData
' Reset - attributes
If lFileAttrib <> FILE_ATTRIBUTE_NORMAL Then
    SetFileAttributes sSourceFile, lFileAttrib
End If
' Not busy anymore
m_EncDec_Status = EC_CRYPT_READY
' Raise final event
RaiseEvent EncryptionFileComplete
Exit Sub
ErrEncrypt:
    m_EncDec_Status = EC_CRYPT_READY ' We fail this time but we are ready for some more
    Dim sMsg As String
    ' Close files if open
    If (lFileNum) Then
        ' Reset - attributes
        If lFileAttrib <> FILE_ATTRIBUTE_NORMAL And lError <> ERROR_IS_DIR Then
            SetFileAttributes sSourceFile, lFileAttrib
        End If
        CloseHandle lFileNum
    End If
    ' Destroy key if any
    If (lKey) Then CryptDestroyKey lKey
    ' Delete temporary file
    Select Case lError
        Case ERROR_FILE_NOT_FOUND: sMsg = "File not found"
        Case ERROR_TMPPTH_NOT_FOUND: sMsg = "Temp Folder not found"
        Case ERROR_NO_TMP_FILE: sMsg = "Error creating temporary file"
        Case ERROR_NO_READ: sMsg = "Error reading from File"
        Case ERROR_NO_WRITE: sMsg = "Error writing to File"
        Case ERROR_NO_FILE_OPEN: sMsg = "Error opening source File"
        Case ERROR_NO_TMP_OPEN: sMsg = "Error opening temporary File"
        Case ERROR_NO_ENCRYPT: sMsg = "Error encrypting File"
        Case ERROR_NO_KEY_DERIVED: sMsg = "Error to derive a key for encryption"
        Case ERROR_IS_DIR: sMsg = "EzCryptApi does not encrypt directories"
        Case Else: Err.Raise Err.Number, "EzCryptoApi", Err.Description
    End Select
    Err.Raise vbObjectError + lError, "EzCryptoApi", sMsg
End Sub
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' EncryptToDestFile Sub procedure
'       Encrypts a Source file to a destination file
' Input:
'       1] sSourceFile: Source Path and filename of the file
'                       to encrypt
'       2] sDestFile: Destination file to store encrypted data
'       3] WriteToOffset: The offset byte position where the control
'                         has to start writing the resulting cipher
'                         data into destination file. Useful, if destination
'                         file needs to hold a header that has to be read
'                         on decryption.
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Sub EncryptToDestFile(ByVal sSourceFile As String, ByVal sDestFile As String, Optional WriteToOffset As Long = 0)
' Before anything starts to rock' and roll
' check if we are busy doing something
If m_EncDec_Status = EC_CRYPT_BUSY Then
    Exit Sub ' Get out of here!
End If
Dim lKey As Long            ' Encryption Key
Dim lBuffLen As Long        ' Length of Buffer
Dim lFileLen As Long        ' Length of File to encrypt
Dim lFileNum As Long        ' File number
Dim lDestFileNum As Long    ' Destination file number
Dim lBlockBytes As Long     ' How many blocks?
Dim lLostBytes As Long      ' How many bytes remaining?
Dim iCounter As Long        ' Counter
Dim lBytesProcessed As Long ' Bytes processed
Dim bFileData() As Byte     ' Buffer of bytes to encrypt
Dim lLength As Long         ' Length of data bytes read/encrypt/write
Dim lResult As Long         ' Length of data bytes read/write
Dim lFileAttrib As Long     ' File Attributes
Dim lError As Long          ' Error values

m_EncDec_Status = EC_CRYPT_BUSY ' working...

On Error GoTo ErrEncrypt
' Check if the file exists
If Trim(Dir$(sSourceFile)) = "" Then
    lError = ERROR_FILE_NOT_FOUND
    Err.Raise vbObjectError ' Fire error handler
    'Err.Raise vbObjectError + 1007, , "File not found"
End If
' Proceed...
' Find out which attributes the source file has
' and store it for further setting
If GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_NORMAL Then
    lFileAttrib = FILE_ATTRIBUTE_NORMAL
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_SYSTEM Then
    lFileAttrib = FILE_ATTRIBUTE_SYSTEM
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_HIDDEN Then
    lFileAttrib = FILE_ATTRIBUTE_SYSTEM
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_READONLY Then
    lFileAttrib = FILE_ATTRIBUTE_READONLY
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_TEMPORARY Then
    lFileAttrib = FILE_ATTRIBUTE_TEMPORARY
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_DIRECTORY Then
    lError = ERROR_IS_DIR
    Err.Raise vbObjectError ' Fire error handler
End If
' Now set its attributes to normal, so we can
' work with it
If Not lFileAttrib = FILE_ATTRIBUTE_NORMAL Then
    SetFileAttributes sSourceFile, FILE_ATTRIBUTE_NORMAL
End If

' Initialize encryption key
lKey = InitKey
If lKey = 0 Then
    lError = ERROR_NO_KEY_DERIVED
    Err.Raise vbObjectError ' Fire error handler
End If
' Open the file again now using API functions (real fast)
' Source file for reading and writing
lFileNum = CreateFile(sSourceFile, GENERIC_READ Or GENERIC_WRITE, FILE_SHARE_READ Or FILE_SHARE_WRITE, ByVal 0&, OPEN_EXISTING, 0, 0)
If lFileNum = INVALID_HANDLE_VALUE Then
    lError = ERROR_NO_FILE_OPEN
    Err.Raise vbObjectError ' Fire error handler
End If
' Get the source file length
lFileLen = GetFileSize(lFileNum, 0)

' Now open destination file
lDestFileNum = CreateFile(sDestFile, GENERIC_WRITE, 0, ByVal 0&, OPEN_ALWAYS, ByVal 0&, 0)
If lDestFileNum = INVALID_HANDLE_VALUE Then
    lError = ERROR_NO_FILE_OPEN
    Err.Raise vbObjectError ' Fire error handler
End If
' Set the source file pointer at the beginning of the file
SetFilePointer lFileNum, 0, 0, FILE_BEGIN
' Put pointer at the beginning of the file to write back the encrypted data
SetFilePointer lDestFileNum, WriteToOffset, 0, FILE_BEGIN
RaiseEvent EncryptionFileStart
If lFileLen <= HP_FILE_RW_BLOCKSIZE Then ' If less than encryption blocksize encrypt in one shot
    ' Raise event EncryptFileStart
    RaiseEvent EncryptionFileStart
    ' Get everything in one shot an write it in one shot
    ' Prepare buffer space
    ReDim bFileData(1 To (lFileLen * 2))
    ' Read the file in one shot
    ReadFile lFileNum, bFileData(1), lFileLen, lResult, ByVal 0&
    If lResult <> lFileLen Then
        lError = ERROR_NO_READ
        Err.Raise vbObjectError ' Fire error handler
    End If
    RaiseEvent EncryptionFileStatus((lFileLen * 0.25), lFileLen)
    ' Let's encrypt the block
    ' Prepare variables for encryption)
    lLength = lFileLen
    lBuffLen = UBound(bFileData)
    If Not CBool(CryptEncrypt(lKey, 0, 1, 0, bFileData(1), lLength, lBuffLen)) Then
        lError = ERROR_NO_ENCRYPT
        Err.Raise vbObjectError ' Fire error handler
    End If
    ' Raise event
    RaiseEvent EncryptionFileStatus(lFileLen * 0.5, lFileLen)
    ' Write the results to destination file
    WriteFile lDestFileNum, bFileData(1), lLength, lResult, ByVal 0&
    If lResult <> lLength Then
        lError = ERROR_NO_WRITE
        Err.Raise vbObjectError ' Fire error handler
    End If
    ' Raise event
    RaiseEvent EncryptionFileStatus(lFileLen, lFileLen)
Else
    ' Find out how many HP_FILE_BLOCKSIZE blocks are
    lBlockBytes = lFileLen \ HP_FILE_RW_BLOCKSIZE
    ' And lost bytes
    lLostBytes = lFileLen Mod HP_FILE_RW_BLOCKSIZE
    ' Allocate space
    ' Now loop through the blocks and keep encrypting and writing data back to the file
    ReDim bFileData(1 To (HP_FILE_RW_BLOCKSIZE * 2))
    lLength = HP_FILE_RW_BLOCKSIZE
    For iCounter = 1 To lBlockBytes
        ' Read from source
        ReadFile lFileNum, bFileData(1), HP_FILE_RW_BLOCKSIZE, lResult, ByVal 0&
        If lResult <> HP_FILE_RW_BLOCKSIZE Then
            lError = ERROR_NO_READ
            Err.Raise vbObjectError ' Fire error handler
        End If
        ' Prepare buffer
        lBuffLen = UBound(bFileData)
        ' Encrypt data!
        If Not CBool(CryptEncrypt(lKey, 0, 0, 0, bFileData(1), lLength, lBuffLen)) Then
            lError = ERROR_NO_ENCRYPT
            Err.Raise vbObjectError ' Fire error handler
        End If
        ' Write to destination file
        WriteFile lDestFileNum, bFileData(1), lLength, lResult, ByVal 0&
        If lResult <> lLength Then
            lError = ERROR_NO_WRITE
            Err.Raise vbObjectError ' Fire error handler
        End If
        DoEvents
        ' Raise event
        lBytesProcessed = (lBytesProcessed + HP_FILE_RW_BLOCKSIZE)
        RaiseEvent EncryptionFileStatus(lBytesProcessed, lFileLen)
    Next
'    ' Now get the lost bytes [if any]
    If lLostBytes <> 0 Then
        ' Get them in one shot
        ReDim bFileData(1 To (lLostBytes * 2))
        ReadFile lFileNum, bFileData(1), lLostBytes, lResult, ByVal 0&
        If lResult <> lLostBytes Then
            lError = ERROR_NO_READ
            Err.Raise vbObjectError ' Fire error handler
        End If
        ' prepare for encryption
        lLength = lLostBytes
        lBuffLen = UBound(bFileData)
        'Encrypt data!
        If Not CBool(CryptEncrypt(lKey, 0, 1, 0, bFileData(1), lLength, lBuffLen)) Then
            lError = ERROR_NO_ENCRYPT
            Err.Raise vbObjectError ' Fire error handler
        End If
        ' Write to results to destination file
        WriteFile lDestFileNum, bFileData(1), lLength, lResult, ByVal 0&
        If lResult <> lLength Then
            lError = ERROR_NO_WRITE
            Err.Raise vbObjectError ' Fire error handler
        End If
        ' Raise event
        lBytesProcessed = (lBytesProcessed + (lLostBytes))
        RaiseEvent EncryptionFileStatus(lBytesProcessed, lFileLen)
    End If
End If
' Destroy the key
If (lKey) Then CryptDestroyKey lKey
lKey = 0
'' Close the file again
If (lFileNum) Then CloseHandle lFileNum
'' Close Destination file
If (lDestFileNum) Then CloseHandle lDestFileNum
' Free up resources
Erase bFileData
'Erase btemFileData
' Set source file attributes back to original
If Not lFileAttrib = FILE_ATTRIBUTE_NORMAL Then
    SetFileAttributes sSourceFile, FILE_ATTRIBUTE_NORMAL
End If
' Reset - attributes as the original
SetFileAttributes sDestFile, lFileAttrib

' Not busy anymore
m_EncDec_Status = EC_CRYPT_READY
' Raise final event
RaiseEvent EncryptionFileComplete
Exit Sub
ErrEncrypt:
    m_EncDec_Status = EC_CRYPT_READY ' We fail this time but we are ready for some more
    Dim sMsg As String
    ' Close files if open
    If (lFileNum) Then
        ' Reset - attributes
        If lFileAttrib <> FILE_ATTRIBUTE_NORMAL And lError <> ERROR_IS_DIR Then
            SetFileAttributes sSourceFile, lFileAttrib
        End If
        CloseHandle lFileNum
    End If
    If (lDestFileNum) Then CloseHandle lDestFileNum
    ' Destroy key if any
    If (lKey) Then CryptDestroyKey lKey
    ' Delete temporary file
    Select Case lError
        Case ERROR_FILE_NOT_FOUND: sMsg = "File not found"
        Case ERROR_TMPPTH_NOT_FOUND: sMsg = "Temp Folder not found"
        Case ERROR_NO_TMP_FILE: sMsg = "Error creating temporary file"
        Case ERROR_NO_READ: sMsg = "Error reading from File"
        Case ERROR_NO_WRITE: sMsg = "Error writing to File"
        Case ERROR_NO_FILE_OPEN: sMsg = "Error opening source File"
        Case ERROR_NO_TMP_OPEN: sMsg = "Error opening temporary File"
        Case ERROR_NO_ENCRYPT: sMsg = "Error encrypting File"
        Case ERROR_NO_KEY_DERIVED: sMsg = "Error to derive a key for encryption"
        Case ERROR_IS_DIR: sMsg = "EzCryptApi does not encrypt directories"
        Case Else: Err.Raise Err.Number, "EzCryptoApi", Err.Description
    End Select
    Err.Raise vbObjectError + lError, "EzCryptoApi", sMsg
End Sub
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' DecryptFile Sub procedure
'       Decrypts a Source file to a destination file
' Input:
'       1] sSourceFile: Source Path and filename of the file
'                       to Decrypt
'       2] ReadWriteOffset: The offset byte position from where
'                           the control has to read the data to
'                           decrypt. Useful if the file holds a header
'                           written on encryption.
'                           Note that decrypted data will be written back
'                           to the source file from the first byte
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Sub DecryptFile(ByVal sSourceFile As String, Optional ReadWriteOffset As Long = 0)
If m_EncDec_Status = EC_CRYPT_BUSY Then
    Exit Sub ' Get out of here!
End If
Dim sTempPath As String     ' Path of Temp folder in the system
Dim sTempFilename As String ' Temp filename
Dim lFileTempNum As Long    ' Temp file number
Dim lTempPathLen As Long    ' Length of Temp path returned by GetTempPath
Dim lKey As Long            ' Encryption Key
Dim lFileLen As Long        ' Length of File to decrypt
Dim lFileNum As Long        ' File number
Dim lBlockBytes As Long     ' How many 160 blocks?
Dim lLostBytes As Long      ' How many bytes remaining?
Dim iCounter As Long        ' Counter
Dim jCounter As Long        ' Counter
Dim lBytesProcessed As Long ' Bytes processed
Dim bBufflen As Byte        ' Length of the buffer to decrypt
Dim bFileData() As Byte     ' Holds File Data
Dim btempFileData() As Byte ' Holds Data to write to file [if exceeds block set]
Dim lResult As Long         ' Returned values
Dim lLength As Long         ' Length of buffer
Dim lFileAttrib As Long     ' File attributes
Dim lError As Long          ' Error values
On Error GoTo ErrDecryptFile
' We are busy
m_EncDec_Status = EC_CRYPT_BUSY
' Check if the file exists
If Trim(Dir$(sSourceFile)) = "" Then
    lError = ERROR_FILE_NOT_FOUND
    Err.Raise vbObjectError ' Fire error handler
End If
' Proceed with decryption
' Initialize key
lKey = InitKey
If lKey = 0 Then
    lError = ERROR_NO_KEY_DERIVED
    Err.Raise vbObjectError ' Fire error handler
End If
' Find out which attributes the source file have
If GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_NORMAL Then
    lFileAttrib = FILE_ATTRIBUTE_NORMAL
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_SYSTEM Then
    lFileAttrib = FILE_ATTRIBUTE_SYSTEM
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_HIDDEN Then
    lFileAttrib = FILE_ATTRIBUTE_SYSTEM
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_READONLY Then
    lFileAttrib = FILE_ATTRIBUTE_READONLY
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_TEMPORARY Then
    lFileAttrib = FILE_ATTRIBUTE_TEMPORARY
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_DIRECTORY Then
    lError = ERROR_IS_DIR
    Err.Raise vbObjectError ' Fire error handler
End If
' Set attributes to normal so we can work with it without problems
If lFileAttrib <> FILE_ATTRIBUTE_NORMAL Then
    SetFileAttributes sSourceFile, FILE_ATTRIBUTE_NORMAL
End If
' Now store the tempfilename into destination file
' Open the file again now using API functions (real fast)
' Source file for reading
lFileNum = CreateFile(sSourceFile, GENERIC_READ, FILE_SHARE_READ Or FILE_SHARE_WRITE, ByVal 0&, OPEN_EXISTING, 0, 0)
If lFileNum = INVALID_HANDLE_VALUE Then
    lError = ERROR_NO_FILE_OPEN
    Err.Raise vbObjectError ' Fire error handler
End If
' Set the file pointer at offset of the file
SetFilePointer lFileNum, ReadWriteOffset, 0, FILE_BEGIN
' Get the source file length
lFileLen = GetFileSize(lFileNum, 0) - ReadWriteOffset
' Get everything in one shot an write it in one shot
ReDim bFileData(1 To lFileLen)
' Read the whole lot in memory!
ReadFile lFileNum, bFileData(1), UBound(bFileData), lResult, ByVal 0&
If lResult <> UBound(bFileData) Then
    lError = ERROR_NO_READ
    Err.Raise vbObjectError ' Fire error handler
End If
' Now we close the handle and open the file again
' clearing existing data
CloseHandle lFileNum
' Re-open again
lFileNum = CreateFile(sSourceFile, GENERIC_WRITE, FILE_SHARE_READ, ByVal 0&, TRUNCATE_EXISTING, 0, 0)
If lFileNum = INVALID_HANDLE_VALUE Then
    lError = ERROR_NO_FILE_OPEN
    Err.Raise vbObjectError ' Fire error handler
End If
' Set file pointer to the beginning of the file now as we don't need any headers
SetFilePointer lFileNum, 0, 0, FILE_BEGIN
' Raise event
RaiseEvent DecryptionFileStart
If lFileLen <= HP_FILE_RW_BLOCKSIZE Then
    ' Let's encrypt the block
    ' Prepare buffer for encryption
    lLength = UBound(bFileData)
    'Decrypt data! [Full file Size]
    If Not CBool(CryptDecrypt(lKey, 0, 1, 0, bFileData(1), lLength)) Then
        lError = ERROR_NO_DECRYPT
        Err.Raise vbObjectError ' Fire error handler
    End If
    ' Write the results to back to the file
    WriteFile lFileNum, bFileData(1), lLength, lResult, ByVal 0&
    If lResult <> lLength Then
        lError = ERROR_NO_WRITE
        Err.Raise vbObjectError ' Fire error handler
    End If
    ' Raise event
    lBytesProcessed = (lBytesProcessed + lLength)
    RaiseEvent DecryptionFileStatus(lBytesProcessed, lFileLen)
Else
' Find out how many HP_FILE_BLOCKSIZE blocks are
    lBlockBytes = lFileLen \ HP_FILE_RW_BLOCKSIZE
    ' And lost bytes
    lLostBytes = lFileLen Mod HP_FILE_RW_BLOCKSIZE
    ' Blocks encrypted
    ' Now loop through the blocks and keep decrypting
    ReDim btempFileData(1 To HP_FILE_RW_BLOCKSIZE)
    Dim Offset As Currency ' just to be sure of the file size :o)
    Offset = 1 ' offset to read from file data array
    lLength = HP_FILE_RW_BLOCKSIZE
    For iCounter = 1 To lBlockBytes
        ' Get the block
        CopyMem btempFileData(1), bFileData(Offset), HP_FILE_RW_BLOCKSIZE
        'Decrypt data!
        If Not CBool(CryptDecrypt(lKey, 0, 0, 0, btempFileData(1), lLength)) Then
            lError = ERROR_NO_DECRYPT
            Err.Raise vbObjectError ' Fire error handler
        End If
        ' Write to temp file
        WriteFile lFileNum, btempFileData(1), lLength, lResult, ByVal 0&
        If lResult <> lLength Then
            lError = ERROR_NO_WRITE
            Err.Raise vbObjectError ' Fire error handler
        End If
        ' Update offset
        Offset = Offset + HP_FILE_RW_BLOCKSIZE
        ' Raise event
        lBytesProcessed = (lBytesProcessed + HP_FILE_RW_BLOCKSIZE)
        RaiseEvent DecryptionFileStatus(lBytesProcessed, lFileLen)
        DoEvents
    Next
    ' Now get the lost bytes [if any]
    If lLostBytes <> 0 Then
        ' Get them in one shot
        ReDim btempFileData(1 To lLostBytes)
        CopyMem btempFileData(1), bFileData(Offset), lLostBytes
        
        lLength = lLostBytes
        'Decrypt data!
        If Not CBool(CryptDecrypt(lKey, 0, 1, 0, btempFileData(1), lLength)) Then
            lError = ERROR_NO_DECRYPT
            Err.Raise vbObjectError ' Fire error handler
        End If
        
        WriteFile lFileNum, btempFileData(1), lLostBytes, lResult, ByVal 0&
        If lResult <> lLostBytes Then
            lError = ERROR_NO_WRITE
            Err.Raise vbObjectError ' Fire error handler
        End If
        lBytesProcessed = (lBytesProcessed + lLostBytes)
        RaiseEvent DecryptionFileStatus(lBytesProcessed, lFileLen)
    End If
End If
If (lKey) Then CryptDestroyKey lKey
CloseHandle lFileNum
lFileNum = 0
' Release resources
If (lKey) Then CryptDestroyKey lKey
' Close files
If (lFileNum) Then CloseHandle lFileNum

Erase bFileData
Erase btempFileData
' Re-set file attributes back to original
If lFileAttrib <> FILE_ATTRIBUTE_NORMAL Then
    SetFileAttributes sSourceFile, lFileAttrib
End If
m_EncDec_Status = EC_CRYPT_READY ' Ready to work again
' Raise final event
RaiseEvent DecryptionFileComplete
Exit Sub
ErrDecryptFile:
    m_EncDec_Status = EC_CRYPT_NONE
    Dim sMsg As String
    If (lKey) Then CryptDestroyKey lKey
    If (lFileNum) Then
        ' Reset - attributes
        If lFileAttrib <> FILE_ATTRIBUTE_NORMAL And lError <> ERROR_IS_DIR Then
            SetFileAttributes sSourceFile, lFileAttrib
        End If
        CloseHandle lFileNum
    End If
        
    Select Case lError
        Case ERROR_FILE_NOT_FOUND: sMsg = "File not found"
        Case ERROR_TMPPTH_NOT_FOUND: sMsg = "Temp Folder not found"
        Case ERROR_NO_TMP_FILE: sMsg = "Error creating temporary file"
        Case ERROR_NO_READ: sMsg = "Error reading from File"
        Case ERROR_NO_WRITE: sMsg = "Error writing to File"
        Case ERROR_NO_FILE_OPEN: sMsg = "Error opening source File"
        Case ERROR_NO_TMP_OPEN: sMsg = "Error opening temporary File"
        Case ERROR_NO_DECRYPT: sMsg = "Error decrypting File"
        Case ERROR_NO_KEY_DERIVED: sMsg = "Error to derive a key for decryption"
        Case ERROR_IS_DIR: sMsg = "EzCryptApi does not decrypt directories"
        Case Else: Err.Raise Err.Number, "EzCryptoApi", Err.Description
    End Select
    Err.Raise vbObjectError + lError, "EzCryptoApi", sMsg
End Sub
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' DecryptToDestFile Sub procedure
'       Decrypts a Source file to a destination file
' Input:
'       1] sSourceFile: Source Path and filename of the file
'                       to Decrypt
'       2] sDestFile: Destination file where decrypted data is stored
'       3] ReadFromOffset: The offset byte position where the control
'                         has to start reading the cipher
'                         data from source file. Useful, if source
'                         file holds a header that was written on encryption
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Sub DecryptToDestFile(ByVal sSourceFile As String, ByVal sDestFile As String, Optional ReadFromOffset As Long = 0)
If m_EncDec_Status = EC_CRYPT_BUSY Then
    Exit Sub ' Get out of here!
End If
Dim lKey As Long            ' Encryption Key
Dim lFileLen As Long        ' Length of File to decrypt
Dim lFileNum As Long        ' File handler
Dim lDestFileNum As Long    ' Destination file handler
Dim lBlockBytes As Long     ' How many 160 blocks?
Dim lLostBytes As Long      ' How many bytes remaining?
Dim iCounter As Long        ' Counter
Dim lBytesProcessed As Long ' Bytes processed
Dim bBufflen As Byte        ' Length of the buffer to decrypt
Dim bFileData() As Byte     ' Holds File Data
Dim btempFileData() As Byte ' Holds Data to write to file [if exceeds block set]
Dim lResult As Long         ' Returned values
Dim lLength As Long         ' Length of buffer
Dim lFileAttrib As Long     ' File attributes
Dim lError As Long          ' Error values
On Error GoTo ErrDecryptFile
' We are busy
m_EncDec_Status = EC_CRYPT_BUSY
' Check if the file exists
If Trim(Dir$(sSourceFile)) = "" Then
    lError = ERROR_FILE_NOT_FOUND
    Err.Raise vbObjectError ' Fire error handler
End If
' Proceed with decryption
' Initialize key
lKey = InitKey
If lKey = 0 Then
    lError = ERROR_NO_KEY_DERIVED
    Err.Raise vbObjectError ' Fire error handler
End If
' Find out which attributes the source file have
If GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_NORMAL Then
    lFileAttrib = FILE_ATTRIBUTE_NORMAL
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_SYSTEM Then
    lFileAttrib = FILE_ATTRIBUTE_SYSTEM
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_HIDDEN Then
    lFileAttrib = FILE_ATTRIBUTE_SYSTEM
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_READONLY Then
    lFileAttrib = FILE_ATTRIBUTE_READONLY
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_TEMPORARY Then
    lFileAttrib = FILE_ATTRIBUTE_TEMPORARY
ElseIf GetFileAttributes(sSourceFile) And FILE_ATTRIBUTE_DIRECTORY Then
    lError = ERROR_IS_DIR
'    Err.Raise vbObjectError ' Fire error handler
End If
' Set attributes to normal so we can work with it without problems
If lFileAttrib <> FILE_ATTRIBUTE_NORMAL Then
    SetFileAttributes sSourceFile, FILE_ATTRIBUTE_NORMAL
End If
' Source file for reading
lFileNum = CreateFile(sSourceFile, GENERIC_READ, FILE_SHARE_READ, ByVal 0&, OPEN_EXISTING, 0, 0)
If lFileNum = INVALID_HANDLE_VALUE Then
    lError = ERROR_NO_FILE_OPEN
    Err.Raise vbObjectError ' Fire error handler
End If
' Now open destination file for writing
lDestFileNum = CreateFile(sDestFile, GENERIC_WRITE, FILE_SHARE_READ, ByVal 0&, OPEN_ALWAYS, 0, 0)
If lDestFileNum = INVALID_HANDLE_VALUE Then
    lError = ERROR_NO_FILE_OPEN
    Err.Raise vbObjectError
End If

' Set the file pointer at the beginning of the files
SetFilePointer lFileNum, ReadFromOffset, 0, FILE_BEGIN
SetFilePointer lDestFileNum, 0, 0, FILE_BEGIN
' Get the source file length
lFileLen = GetFileSize(lFileNum, 0) - ReadFromOffset
' Raise event
RaiseEvent DecryptionFileStart
If lFileLen <= HP_FILE_RW_BLOCKSIZE Then
    ' Get everything in one shot an write it in one shot
    ReDim bFileData(1 To lFileLen)
    lLength = UBound(bFileData)
    ' Read the whole lot in memory!
    ReadFile lFileNum, bFileData(1), lLength, lResult, ByVal 0&
    If lResult <> lLength Then
        lError = ERROR_NO_READ
        Err.Raise vbObjectError ' Fire error handler
    End If
    RaiseEvent DecryptionFileStatus(lFileLen * 0.25, lFileLen)
    ' Let's encrypt the block
    ' Prepare buffer for encryption
    'Decrypt data! [Full file Size]
    If Not CBool(CryptDecrypt(lKey, 0, 1, 0, bFileData(1), lResult)) Then
        lError = ERROR_NO_DECRYPT
        Err.Raise vbObjectError ' Fire error handler
    End If
    RaiseEvent DecryptionFileStatus(lFileLen * 0.5, lFileLen)
    ' Write the results to destination file
    WriteFile lDestFileNum, bFileData(1), lLength, lResult, ByVal 0&
    If lResult <> lLength Then
        lError = ERROR_NO_WRITE
        Err.Raise vbObjectError ' Fire error handler
    End If
    ' Raise event
    RaiseEvent DecryptionFileStatus(lFileLen, lFileLen)
Else
' Find out how many HP_FILE_BLOCKSIZE blocks are
    lBlockBytes = lFileLen \ HP_FILE_RW_BLOCKSIZE
    ' And lost bytes
    lLostBytes = lFileLen Mod HP_FILE_RW_BLOCKSIZE
    ' Blocks encrypted
    ' Now loop through the blocks and keep decrypting
    ReDim bFileData(1 To HP_FILE_RW_BLOCKSIZE)
    'Dim offset As Currency ' just to be sure of the file size :o)
    'offset = 1 ' offset to read from file data array
    'lLength = HP_FILE_RW_BLOCKSIZE
    For iCounter = 1 To lBlockBytes
        ' Get the block
        'CopyMem btempFileData(1), bFileData(offset), HP_FILE_RW_BLOCKSIZE
        ReadFile lFileNum, bFileData(1), HP_FILE_RW_BLOCKSIZE, lResult, ByVal 0&
        If lResult <> HP_FILE_RW_BLOCKSIZE Then
            lError = ERROR_NO_READ
            Err.Raise vbObjectError
        End If
        'Decrypt data!
        If Not CBool(CryptDecrypt(lKey, 0, 0, 0, bFileData(1), HP_FILE_RW_BLOCKSIZE)) Then
            lError = ERROR_NO_DECRYPT
            Err.Raise vbObjectError ' Fire error handler
        End If
        ' Write to dest file
        WriteFile lDestFileNum, bFileData(1), HP_FILE_RW_BLOCKSIZE, lResult, ByVal 0&
        If lResult <> HP_FILE_RW_BLOCKSIZE Then
            lError = ERROR_NO_WRITE
            Err.Raise vbObjectError ' Fire error handler
        End If
        ' Update offset
        'offset = offset + HP_FILE_RW_BLOCKSIZE
        ' Raise event
        lBytesProcessed = (lBytesProcessed + HP_FILE_RW_BLOCKSIZE)
        RaiseEvent DecryptionFileStatus(lBytesProcessed, lFileLen)
        DoEvents
    Next
    ' Now get the lost bytes [if any]
    If lLostBytes <> 0 Then
        ' Get them in one shot
        ReDim bFileData(1 To lLostBytes)
        'CopyMem btempFileData(1), bFileData(offset), lLostBytes
        ReadFile lFileNum, bFileData(1), lLostBytes, lResult, ByVal 0&
        If lResult <> lLostBytes Then
            lError = ERROR_NO_READ
            Err.Raise vbObjectError
        End If
        'lLength = lLostBytes
        'Decrypt data!
        If Not CBool(CryptDecrypt(lKey, 0, 1, 0, bFileData(1), lLostBytes)) Then
            lError = ERROR_NO_DECRYPT
            Err.Raise vbObjectError ' Fire error handler
        End If
        
        WriteFile lDestFileNum, bFileData(1), lLostBytes, lResult, ByVal 0&
        If lResult <> lLostBytes Then
            lError = ERROR_NO_WRITE
            Err.Raise vbObjectError ' Fire error handler
        End If
        lBytesProcessed = (lBytesProcessed + lLostBytes)
        RaiseEvent DecryptionFileStatus(lBytesProcessed, lFileLen)
    End If
End If
' Release resources
If (lKey) Then CryptDestroyKey lKey
' Now we close handles and re-set attributes
CloseHandle lFileNum
lFileNum = 0
' Set attributes the one it had before
If lFileAttrib <> FILE_ATTRIBUTE_NORMAL Then
    SetFileAttributes sSourceFile, FILE_ATTRIBUTE_NORMAL
End If
CloseHandle lDestFileNum
lDestFileNum = 0
' Re-set file attributes as the original
SetFileAttributes sDestFile, lFileAttrib
Erase bFileData
'Erase btempFileData
m_EncDec_Status = EC_CRYPT_READY ' Ready to work again
' Raise final event
RaiseEvent DecryptionFileComplete
Exit Sub
ErrDecryptFile:
    m_EncDec_Status = EC_CRYPT_NONE
    Dim sMsg As String
    If (lKey) Then CryptDestroyKey lKey
    If (lFileNum) Then
        ' Reset - attributes
        If lFileAttrib <> FILE_ATTRIBUTE_NORMAL And lError <> ERROR_IS_DIR Then
            SetFileAttributes sSourceFile, lFileAttrib
        End If
        CloseHandle lFileNum
    End If
    If (lDestFileNum) Then CloseHandle lDestFileNum
    If IsArray(bFileData) Then Erase bFileData
    Select Case lError
        Case ERROR_FILE_NOT_FOUND: sMsg = "File not found"
        Case ERROR_TMPPTH_NOT_FOUND: sMsg = "Temp Folder not found"
        Case ERROR_NO_TMP_FILE: sMsg = "Error creating temporary file"
        Case ERROR_NO_READ: sMsg = "Error reading from File"
        Case ERROR_NO_WRITE: sMsg = "Error writing to File"
        Case ERROR_NO_FILE_OPEN: sMsg = "Error opening source File"
        Case ERROR_NO_TMP_OPEN: sMsg = "Error opening temporary File"
        Case ERROR_NO_DECRYPT: sMsg = "Error decrypting File"
        Case ERROR_NO_KEY_DERIVED: sMsg = "Error to derive a key for decryption"
        Case ERROR_IS_DIR: sMsg = "EzCryptApi does not decrypt directories"
        Case Else: Err.Raise Err.Number, "EzCryptoApi", Err.Description
    End Select
    Err.Raise vbObjectError + lError, "EzCryptoApi", sMsg
End Sub
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' InitKey Sub procedure
'       Initializes encryption/decryption keys
'
' Output:
'       A handle to the encryption/decryption key if successful
'       zero otherwise
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Private Function InitKey() As Long
Dim lHash As Long
Dim lKey As Long
' Not very optimistic
InitKey = 0
lKey = 0
' No success getting a handle to the provider?
' Then raise an error
If Not CBool(InitProvider()) Then
    GoTo Done
    'Err.Raise vbObjectError + 1003, , "Error getting a handle to key containers"
End If
If Not CBool(CryptCreateHash(m_CSP_Provider, m_Hash_Algorithm, 0, 0, lHash)) Then
    GoTo Done
'    Err.Raise vbObject + 1002, , "Unable to initalize hash object for encryption"
End If
'Hash in the password data.
If Not CBool(CryptHashData(lHash, m_EncDec_Password, Len(m_EncDec_Password), 0)) Then
    GoTo Done
'    Err.Raise vbObjectError + 1010, , "Unable to 'hash' the password"
End If
'Let's derive a session key from the hash object.
If Not CBool(CryptDeriveKey(m_CSP_Provider, m_EncDec_Algorithm, lHash, 0, lKey)) Then
    GoTo Done
'    Err.Raise vbObjectError + 1011, , "Unable to derive a session key from Hash object"
End If
CryptDestroyHash (lHash)
lHash = 0
' Success? lKey will have a handle to the session key
Done:
InitKey = lKey
End Function
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' InitProvider Sub procedure
'       Initializes Cryptographic Service Provider
'
' Output:
'       A handle to key container, zero otherwise
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Private Function InitProvider() As Long
Dim sProvider As String         ' Name of provider
Dim sContainer As String        ' vbnullchar
InitProvider = 1 'Very optimistic
If m_CSP_Provider = 0 Then
    sProvider = MS_ENHANCED_PROV & vbNullChar
    m_Provider_Name = [Microsoft Enhanced Cryptographic Provider]
    sContainer = vbNullChar
    'Attempt to acquire a handle to the chosen key container.
     If Not CBool(CryptAcquireContext(m_CSP_Provider, ByVal sContainer, ByVal sProvider, PROV_RSA_FULL, 0)) Then
        ' Attempt to create a new key container
        If Not CBool(CryptAcquireContext(m_CSP_Provider, ByVal sContainer, ByVal sProvider, PROV_RSA_FULL, CRYPT_NEWKEYSET)) Then
            ' Attempt to get a handle to the enhanced key container
            sProvider = MS_DEF_PROV & vbNullChar
            m_Provider_Name = [Microsoft Base Cryptographic Provider v.1]
            If Not CBool(CryptAcquireContext(m_CSP_Provider, ByVal sContainer, ByVal sProvider, PROV_RSA_FULL, 0)) Then
                ' Attempt to create a new key container
                If Not CBool(CryptAcquireContext(m_CSP_Provider, ByVal sContainer, ByVal sProvider, PROV_RSA_FULL, CRYPT_NEWKEYSET)) Then
                    If Ambient.UserMode = False Then
                         MsgBox "Unable to get a handle to key containers..." & vbCrLf & "Check your registry for the following names:" & _
                         vbCrLf & "Microsoft Base Cryptographic Provider v1.0" & vbCrLf & _
                        "Microsoft Enhanced Cryptographic Provider v1.0" & vbCrLf & "Without them, EzCryptoApi won't work.", vbCritical, "Fatal Error [EzCryptoApi]"
                        m_Provider_Name = [No Providers]
                        'If it is not possible to get a handle to the
                        '[default] OP containers, return 0 [sight! :{ ]
                        InitProvider = 0
                    End If
                End If
            End If
        End If
     End If
End If
End Function
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' EncryptData Sub procedure
'       Encrypts a small amounts of data
' Input:
'       1] sData: Data to encrypt
' Output:
'       The Encrypted data as a string
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Function EncryptData(ByVal sData As String) As String
' If working get out of here
If m_EncDec_Status = EC_CRYPT_BUSY Then Exit Function
Dim lKey As Long            ' Handle to the key
Dim sBuffer As String       ' Encrypted buffer
Dim lLength As Long         ' Length of buffer to encrypt
Dim lBufLen As Long         ' Length of buffer pass to the function
Dim lError As Long          ' Error values
On Error GoTo ErrEncrypt
m_EncDec_Status = EC_CRYPT_BUSY
'Get handle to a session key
lKey = InitKey
If lKey = 0 Then
    lError = ERROR_NO_KEY_DERIVED
    Err.Raise vbObjectError ' Fire error handler
End If
' Raise event
RaiseEvent EncryptionDataStart
'Prepare a string buffer for the CryptEncrypt function
lLength = Len(sData)    ' Get the length
lBufLen = lLength * 2   ' Initialize lBufLen with what will be the buffer size
sBuffer = String(lBufLen, vbNullChar)   ' Allocate buffer size
LSet sBuffer = sData    ' Copy the data to the left of the variable without resizing sBuffer
'Encrypt data!
If Not CBool(CryptStringEncrypt(lKey, 0, 1, 0, sBuffer, lLength, lBufLen)) Then
    lError = ERROR_NO_ENCRYPT
    Err.Raise vbObjectError ' Fire error handler
End If
' Return encrypted data
EncryptData = Left$(sBuffer, lLength)
'Free up CSP resources
'Destroy session key.
If (lKey) Then CryptDestroyKey lKey
' Raise event
RaiseEvent EncryptionDataComplete
' Ready to work again
m_EncDec_Status = EC_CRYPT_READY
Exit Function
ErrEncrypt:
    m_EncDec_Status = EC_CRYPT_NONE
    Dim sMsg As String
    If (lKey) Then CryptDestroyKey lKey
    Select Case lError
        Case ERROR_NO_KEY_DERIVED: sMsg = "Error deriving a key for encryption"
        Case ERROR_NO_ENCRYPT: sMsg = "Error encrypting data"
        Case Else: Err.Raise Err.Number, "EzCryptoApi", Err.Description
    End Select
    Err.Raise vbObjectError + lError, "EzCryptoApi", sMsg
End Function
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' DecryptData Sub procedure
'       Decrypts a small amounts of data
' Input:
'       1] sData: Data to decrypt
' Output:
'       The Decrypted data as a string
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Public Function DecryptData(ByVal sData As String) As String
If m_EncDec_Status = EC_CRYPT_BUSY Then Exit Function
Dim lError As Long      ' To raise errors
Dim lKey As Long        ' Key to use encryption algorithm
'Dim lResult As Long     ' Is the provider ready?
Dim lBufLen As Long     ' Length of data

On Error GoTo ErrDecrypt
m_EncDec_Status = EC_CRYPT_BUSY
RaiseEvent DecryptionDataStart
'Get a handle to session key
lKey = InitKey()
If lKey = 0 Then
    lError = ERROR_NO_KEY_DERIVED
    Err.Raise vbObjectError ' Fire error handler
End If
'Prepare sBuffer for CryptStringDecrypt
lBufLen = Len(sData)
'Decrypt data
If Not CBool(CryptStringDecrypt(lKey, 0, 1, 0, sData, lBufLen)) Then
    lError = ERROR_NO_DECRYPT
    Err.Raise vbObjectError ' Fire error handler
End If

'Return decrypted string
DecryptData = Mid$(sData, 1, lBufLen)

'Release CSP Resources
If lKey Then CryptDestroyKey lKey
RaiseEvent DecryptionDataComplete
m_EncDec_Status = EC_CRYPT_READY
Exit Function
ErrDecrypt:
    m_EncDec_Status = EC_CRYPT_NONE
    Dim sMsg As String
    Select Case lError
        Case ERROR_NO_KEY_DERIVED: sMsg = "Error to derive a key for decryption"
        Case ERROR_NO_DECRYPT: sMsg = "Error decrypting data"
        Case Else:    Err.Raise Err.Number, "EzCryptoApi", Err.Description
    End Select
    Err.Raise vbObjectError + lError, "Ezcryptoapi", sMsg
End Function
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
' Control lifespan...
' ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Private Sub UserControl_Initialize()
' This is necessary so we know on design mode
' what is available on the computer
Dim lResult As Long
lResult = InitProvider
If lResult = 1 Then CryptReleaseContext m_CSP_Provider, 0
m_CSP_Provider = 0
End Sub

Private Sub UserControl_InitProperties()
' Default properties
    m_Hash_Algo_Id = MD5
    m_Hash_Algorithm = CALG_MD5
    m_EncDec_Algo_Id = RC2
    m_EncDec_Algorithm = CALG_RC2
    m_EncDec_Password = "Ez ActiveX Controls"
    m_Speed = [1KB]
    HP_FILE_RW_BLOCKSIZE = HP_FILE_RW_BLOCKSIZE_1k
End Sub

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)

If Ambient.UserMode = True Then
    Dim lResult As Long
    lResult = InitProvider()
    If lResult = 0 Then
        Err.Raise vbObjectError + 1003, "EzCrytoApi", "Error getting a handle to key containers."
    End If
    m_EncDec_Status = EC_CRYPT_READY
Else
    m_EncDec_Status = EC_CRYPT_NONE
End If
HashAlgorithm = PropBag.ReadProperty("HashAlgorithm", MD5)
Password = PropBag.ReadProperty("Password", "Ez ActiveX Controls")
EncryptionAlgorithm = PropBag.ReadProperty("EncryptionAlgorithm", RC2)
Speed = PropBag.ReadProperty("Speed", [1KB])
m_Hash_Status = EC_HASH_NONE

End Sub

Private Sub UserControl_Resize()
    Dim R As RECT
    size DEF_WIDTH, DEF_HEIGHT
    UserControl.ScaleMode = vbPixels
    SetRect R, 0, 0, UserControl.ScaleWidth, UserControl.ScaleHeight
    DrawEdge hdc, R, EDGE_RAISED, BF_ADJUST Or BF_RECT
End Sub

Private Sub UserControl_Terminate()
    If m_Hash_Status = EC_HASH_READY Then CryptDestroyHash m_Hash_Object
    If m_CSP_Provider Then CryptReleaseContext m_CSP_Provider, 0
End Sub

Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
  PropBag.WriteProperty "HashAlgorithm", m_Hash_Algo_Id, MD5
  PropBag.WriteProperty "Password", m_EncDec_Password, "Ez Activex Controls"
  PropBag.WriteProperty "EncryptionAlgorithm", m_EncDec_Algo_Id, RC2
  PropBag.WriteProperty "Speed", m_Speed, [1KB]
End Sub



