VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsCryptoAPIandCompression"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
'Doug Gaede
'December 11, 2000
'Wrapper class for Microsoft CryptoAPI (Base CSP) and Zlib compression dll.
'I release this code to the public domain for free use.

'This class handles compression/decompression,
'encryption/decryption (single key and key pair) and
'signing/validation of strings, byte arrays, and files.
'You must have the Zlib dll in the system folder to use
'the compression routines.

'Read through Microsoft's web site on the use
'of the CryptoAPI:
'http://msdn.microsoft.com/library/psdk/crypto/portalapi_3351.htm?RLD=290

'Read through Zlib's web site at Home page:
'http://www.info-zip.org/pub/infozip/zlib/
'for info on using the Zlib compression dll.

'Some of the single key cryptographic code was adapted from code
'that Fredrik Qvarfort adapted, on www.planetsourcecode.com  I added SALT
'functionality to the single key encryption.  I added all the
'public/private key (key pair or RSA) functionality, which took
'about two solid weeks to figure out and debug.

'Some of the compression code was adapted from code from
'the Zlib web site.

'see the attached README for full details.

'the following are for encryption/decryption
Private Declare Function CryptAcquireContext Lib "advapi32.dll" Alias "CryptAcquireContextA" (ByRef phProv As Long, ByVal pszContainer As String, ByVal pszProvider As String, ByVal dwProvType As Long, ByVal dwFlags As Long) As Long
Private Declare Function CryptCreateHash Lib "advapi32.dll" (ByVal hProv As Long, ByVal Algid As Long, ByVal hSessionKey As Long, ByVal dwFlags As Long, ByRef phHash As Long) As Long
Private Declare Function CryptHashData Lib "advapi32.dll" (ByVal hHash As Long, ByVal pbData As String, ByVal dwDataLen As Long, ByVal dwFlags As Long) As Long
Private Declare Function CryptDeriveKey Lib "advapi32.dll" (ByVal hProv As Long, ByVal Algid As Long, ByVal hBaseData As Long, ByVal dwFlags As Long, ByRef hSessionKey As Long) As Long
Private Declare Function CryptDestroyHash Lib "advapi32.dll" (ByVal hHash As Long) As Long
Private Declare Function CryptEncrypt Lib "advapi32.dll" (ByVal hSessionKey As Long, ByVal hHash As Long, ByVal Final As Long, ByVal dwFlags As Long, ByVal pbData As String, ByRef pdwDataLen As Long, ByVal dwBufLen As Long) As Long
Private Declare Function CryptDestroyKey Lib "advapi32.dll" (ByVal hSessionKey As Long) As Long
Private Declare Function CryptReleaseContext Lib "advapi32.dll" (ByVal hProv As Long, ByVal dwFlags As Long) As Long
Private Declare Function CryptDecrypt Lib "advapi32.dll" (ByVal hSessionKey As Long, ByVal hHash As Long, ByVal Final As Long, ByVal dwFlags As Long, ByVal pbData As String, ByRef pdwDataLen As Long) As Long
Private Declare Function CryptGetKeyParam Lib "advapi32.dll" (ByVal hSessionKey As Long, ByVal dwParam As Long, ByVal pbData As String, ByRef pdwDataLen As Long, ByVal dwFlags As Long) As Long
Private Declare Function CryptSetKeyParam Lib "advapi32.dll" (ByVal hSessionKey As Long, ByVal dwParam As Long, ByVal pbData As String, ByVal dwFlags As Long) As Long
Private Declare Function CryptGenRandom Lib "advapi32.dll" (ByVal hProv As Long, ByVal dwLen As Long, ByVal pbBuffer As String) As Long
Private Declare Function CryptGenKey Lib "advapi32.dll" (ByVal hProv As Long, ByVal Algid As Long, ByVal dwFlags As Long, ByRef hSessionKey As Long) As Long
Private Declare Function CryptGetHashParam Lib "advapi32.dll" (ByVal hHash As Long, ByVal dwParam As Long, ByVal pbData As String, ByRef pdwDataLen As Long, ByVal dwFlags As Long) As Long
Private Declare Function CryptSetHashParam Lib "advapi32.dll" (ByVal hHash As Long, ByVal dwParam As Long, ByVal pbData As String, ByVal dwFlags As Long) As Long
Private Declare Function CryptExportKey Lib "advapi32.dll" (ByVal hSessionKey As Long, ByVal hExpKey As Long, ByVal dwBlobType As Long, ByVal dwFlags As Long, ByVal pbData As String, ByRef pdwDataLen As Long) As Long
Private Declare Function CryptImportKey Lib "advapi32.dll" (ByVal hProv As Long, ByVal pbData As String, ByVal dwDataLen As Long, ByVal hPubKey As Long, ByVal dwFlags As Long, ByRef phKey As Long) As Long
Private Declare Function CryptGetUserKey Lib "advapi32.dll" (ByVal hProv As Long, ByVal dwKeySpec As Long, ByVal phUserKey As Long) As Long
Private Declare Function CryptSignHash Lib "advapi32.dll" Alias "CryptSignHashA" (ByVal hHash As Long, ByVal dwKeySpec As Long, ByVal sDescription As String, ByVal dwFlags As Long, ByVal pbSignature As String, pdwSigLen As Long) As Long
Private Declare Function CryptVerifySignature Lib "advapi32.dll" Alias "CryptVerifySignatureA" (ByVal hHash As Long, ByVal pbSignature As String, ByVal dwSigLen As Long, ByVal hPubKey As Long, ByVal sDescription As String, ByVal dwFlags As Long) As Long

'the following are for compression/decompression
Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)
'Private Declare Function compress Lib "zlib.dll" (dest As Any, destLen As Any, src As Any, ByVal srcLen As Long) As Long
'Private Declare Function compress2 Lib "zlib.dll" (dest As Any, destLen As Any, src As Any, ByVal srcLen As Long, ByVal level As Long) As Long
'Private Declare Function uncompress Lib "zlib.dll" (dest As Any, destLen As Any, src As Any, ByVal srcLen As Long) As Long

'the following are for encryption/decryption
Private Const SERVICE_PROVIDER As String = "Microsoft Base Cryptographic Provider v1.0" & vbNullChar 'can set this to other providers.  See Microsoft's website for full listing
Private Const KEY_CONTAINER As String = "CryptoAPIExample" & vbNullChar 'this is usually set to your program's name
Private Const PROV_RSA_FULL As Long = 1
Private Const CRYPT_NEWKEYSET As Long = 8
Private Const CRYPT_DELETEKEYSET As Long = 16
Private Const CRYPT_CREATE_SALT As Long = 4
Private Const CRYPT_EXPORTABLE As Long = 1
Private Const KP_SALT As Long = 2
Private Const ALG_CLASS_DATA_ENCRYPT As Long = 24576
Private Const ALG_CLASS_HASH As Long = 32768
Private Const ALG_TYPE_ANY As Long = 0
Private Const ALG_TYPE_STREAM As Long = 2048
Private Const ALG_SID_RC4 As Long = 1
Private Const ALG_SID_MD5 As Long = 3
Private Const ALG_SID_SHA As Long = 4
Private Const CALG_MD5 As Long = ((ALG_CLASS_HASH Or ALG_TYPE_ANY) Or ALG_SID_MD5)
Private Const CALG_RC4 As Long = ((ALG_CLASS_DATA_ENCRYPT Or ALG_TYPE_STREAM) Or ALG_SID_RC4)
Private Const CALG_SHA As Long = ((ALG_CLASS_HASH Or ALG_TYPE_ANY) Or ALG_SID_SHA)
Private Const AT_KEYEXCHANGE As Long = 1
Private Const AT_SIGNATURE As Long = 2
Private Const HP_HASHVAL As Long = 2
Private Const SIMPLEBLOB = 1
Private Const PUBLICKEYBLOB As Long = 6
Private Const PRIVATEKEYBLOB As Long = 7
Private Const CRYPT_NO_SALT = 16
Private Const NTE_BAD_SIGNATURE As Long = -2146893818

'the following are for encryption/decryption
Dim hCryptProv As Long 'the handle to the CSP
Dim strSALT As String 'the session key SALT
Dim strHash As String 'the value of the Hash
Dim hSessionKey As Long 'the handle to the current session key
Dim hKeyPair As Long 'the handle to the current key pair
Dim strPublicPrivateBlob As String 'the value of the private key in BLOB format.  Note that the public key is also put in here by the CryptoAPI
Dim strPublicBlob As String 'the value of the public key in BLOB format.  This is what you can send to other people.
Dim strSessionBlob As String 'the encrypted session key used during key pair encryption/decryption
Dim lngType As Long 'type of key in use (Export or Signature)
Dim strSig As String 'the value of the signature

'the following are for compression/decompression
Dim lngCompressedSize As Long
Dim lngDecompressedSize As Long

Enum CZErrors 'for compression/decompression
    Z_OK = 0
    Z_STREAM_END = 1
    Z_NEED_DICT = 2
    Z_ERRNO = -1
    Z_STREAM_ERROR = -2
    Z_DATA_ERROR = -3
    Z_MEM_ERROR = -4
    Z_BUF_ERROR = -5
    Z_VERSION_ERROR = -6
End Enum

Enum CompressionLevels 'for compression/decompression
    Z_NO_COMPRESSION = 0
    Z_BEST_SPEED = 1
    'note that levels 2-8 exist, too
    Z_BEST_COMPRESSION = 9
    Z_DEFAULT_COMPRESSION = -1
End Enum
'
'These types are included for your reference so you can see
'what is in the PUBLICKEYBLOB and PRIVATEKEYBLOB.
'They are not used by this class so are commented out.  I converted
'them from the C declarations so some of the variable types
'(As String, etc.) may be incorrect since I haven't tested them.
'
'Private Type PUBLICKEYSTRUC 'for encryption/decryption
'    bType As String
'    bVersion As String
'    reserved As Integer
'    aiKeyAlg As Long
'End Type
'
'Private Type RSAPUBKEY 'for encryption/decryption
'    magic As Long
'    bitlen As Long
'    pubexp As Long
'End Type
'
'Private Type PUBLICKEYBLOB 'for encryption/decryption
'    publickeystructure As PUBLICKEYSTRUC
'    rsapubkeystructure As RSAPUBKEY
'    modulus As String
'End Type
'
'Private Type PRIVATEKEYBLOB 'for encryption/decryption
'    publickeystructure As PUBLICKEYSTRUC
'    rsapubkeystructure As RSAPUBKEY
'    modulus As String
'    prime1 As String
'    prime2 As String
'    exponent1 As String
'    exponent2 As String
'    coefficient As String
'    privateExponent As String
'End Type

'************************************************************************
'This first set of properties and functions are for ENCRYPTION/DECRYPTION
'************************************************************************

Public Property Get ValueSALT() As String
'holds the current SALT.  In a production app this should be
'saved as plaintext along with the encrypted file.  See notes in the code below.
ValueSALT = strSALT

End Property

Public Property Let ValueSALT(strValue As String)

strSALT = String(Len(strValue), vbNullChar) 'initialize string for use by API
strSALT = strValue

End Property

Public Property Get ValuePublicPrivateKey() As String
'the value of the private key in BLOB format.
'Note that the CryptoAPI also stores the Public key with the Private Key.
ValuePublicPrivateKey = strPublicPrivateBlob

End Property

Public Property Let ValuePublicPrivateKey(strValue As String)

strPublicPrivateBlob = String(Len(strValue), vbNullChar) 'initialize string for use by API
strPublicPrivateBlob = strValue
strPublicBlob = vbNullString 'if you set PublicPrivate make Private null

End Property

Public Property Get ValuePublicKey() As String
'the value of the public key in BLOB format
'this is the key you can send to other people.
ValuePublicKey = strPublicBlob

End Property

Public Property Let ValuePublicKey(strValue As String)

strPublicBlob = String(Len(strValue), vbNullChar) 'initialize string for use by API
strPublicBlob = strValue
strPublicPrivateBlob = vbNullString 'if you set Public make PublicPrivate null

End Property

Public Property Get ValueSessionKey() As String
'holds the encrypted session key used during key pair encryption/decryption.
ValueSessionKey = strSessionBlob

End Property

Public Property Let ValueSessionKey(strValue As String)

strSessionBlob = String(Len(strValue), vbNullChar) 'initialize string for use by API
strSessionBlob = strValue

End Property

Public Property Get ValueSignature() As String
'holds the current signature.  In a production app this should be
'saved as along with the file.  See notes in the code below.
ValueSignature = strSig

End Property

Public Property Let ValueSignature(strValue As String)

strSig = String(Len(strValue), vbNullChar) 'initialize string for use by API
strSig = strValue

End Property

Public Sub EncryptFile(ByVal SourceFile As String, ByVal DestFile As String, ByVal Password As String)
'single key file encryption
Dim intNextFreeFile As Integer
Dim arrByteArray() As Byte
Dim x As Long
Dim y As Long
Dim z As Long

'reset the SALT value
strSALT = ""

'Open the source file and read the content
'into a arrByteArray to pass onto encryption
intNextFreeFile = FreeFile
Open SourceFile For Binary As #intNextFreeFile
ReDim arrByteArray(0 To LOF(intNextFreeFile) - 1)
Get #intNextFreeFile, , arrByteArray()
Close #intNextFreeFile

'Encrypt the arrByteArray
EncryptByteArray arrByteArray(), Password

'If the destination file already exists we need
'to delete it since opening it for binary use
'will preserve it if it already exists
On Error Resume Next
Kill DestFile
On Error GoTo 0

'Store the encrypted data in the destination file
intNextFreeFile = FreeFile
'first tack on strSALT to arrByteArray
'This is a kludge because while you can Put the the string
'before arrByteArray, for some reason you can not then
'Get the string when reading it back from the file, so I just
'tacked it on to the array.
z = UBound(arrByteArray) + 1
y = 1
ReDim Preserve arrByteArray(0 To (UBound(arrByteArray) + Len(strSALT) + 1))
For x = z To z + Len(strSALT) - 1
    arrByteArray(x) = Asc(Mid(strSALT, y, 1))
    y = y + 1
Next x
arrByteArray(UBound(arrByteArray)) = Len(strSALT) 'length of salt is last character

Open DestFile For Binary As #intNextFreeFile
Put #intNextFreeFile, , arrByteArray()
Close #intNextFreeFile

End Sub

Public Sub DecryptFile(ByVal SourceFile As String, ByVal DestFile As String, ByVal Password As String)
'single key file decryption
Dim intNextFreeFile As Integer
Dim arrByteArray() As Byte
Dim x As Long
Dim y As Long

'reset the SALT value
strSALT = ""

'Open the source file and read the content
'into arrByteArray to decrypt
intNextFreeFile = FreeFile
Open SourceFile For Binary As #intNextFreeFile
ReDim arrByteArray(0 To LOF(intNextFreeFile) - 1)
Get #intNextFreeFile, , arrByteArray()
Close #intNextFreeFile

'extract the SALT
'This is a kludge because while you can Put the the string
'before arrByteArray, for some reason you can not then
'Get the string when reading it back from the file, so I just
'tacked it on to the array.
y = arrByteArray(UBound(arrByteArray))
For x = UBound(arrByteArray) - y To UBound(arrByteArray) - 1
    strSALT = strSALT & Chr(arrByteArray(x))
Next x
ReDim Preserve arrByteArray(0 To (UBound(arrByteArray) - Len(strSALT) - 1))

'Decrypt arrByteArray
DecryptByteArray arrByteArray(), Password

'If the destination file already exists we need
'to delete it since opening it for binary use
'will preserve it if it already exists
On Error Resume Next
If FileLen(DestFile) > 0 Then Kill DestFile
On Error GoTo 0

'Store the decrypted data in the destination file
intNextFreeFile = FreeFile
Open DestFile For Binary As #intNextFreeFile
Put #intNextFreeFile, , arrByteArray()
Close #intNextFreeFile

End Sub

Public Function EncryptString(ByVal Text As String, ByVal Password As String) As String
'single key string encryption
EncryptString = EncryptDecrypt(Text, Password, True)

End Function

Public Function DecryptString(ByVal Text As String, ByVal Password As String) As String
'single key string decryption
DecryptString = EncryptDecrypt(Text, Password, False)

End Function

Public Function EncryptByteArray(ByRef arrByteArray() As Byte, ByVal Password As String)
'single key byte array encryption
Dim strInput As String
Dim strOutput As String

strInput = StrConv(arrByteArray(), vbUnicode) 'convert to string
strOutput = EncryptDecrypt(strInput, Password, True) 'return the encrypted data
arrByteArray() = StrConv(strOutput, vbFromUnicode) 'convert to byte array

End Function

Public Function DecryptByteArray(ByRef arrByteArray() As Byte, ByVal Password As String)
'single key byte array encryption
Dim strInput As String
Dim strOutput As String

strInput = StrConv(arrByteArray(), vbUnicode) 'convert to string
strOutput = EncryptDecrypt(strInput, Password, False) 'return the encrypted data
arrByteArray() = StrConv(strOutput, vbFromUnicode) 'convert to byte array

End Function

Public Sub Generate_KeyPair(Optional UseExchangeKeyPair As Boolean = True)
'generate a new key pair, export it, and set the key handle so you
'can next call EncryptFile_KeyPair
Dim lngParams As Long
Dim lngReturnValue As Long

lngParams = &H2000000 Or CRYPT_EXPORTABLE Or CRYPT_NO_SALT   'set the key length to 512, allow the keys to be exported, no salt

If UseExchangeKeyPair Then 'set the type of key pair (Exchange key pair or Signature key pair)
    lngType = AT_KEYEXCHANGE
Else
    lngType = AT_SIGNATURE
End If

'release old key pair handle
If hKeyPair <> 0 Then CryptDestroyKey hKeyPair

'generate the key pair
lngReturnValue = CryptGenKey(hCryptProv, lngType, lngParams, hKeyPair)
If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not generate public/private key pair"

End Sub

Public Sub Export_KeyPair(ByVal PrivateKeyPassword As String)
'export the keys so they are available via the properties ValuePublicKey and ValuePublicPrivateKey
Dim lngReturnValue As Long
Dim lngLength As Long

'Export the public key to strPublicBlob (ValuePublicKey property)
'This key is not encrypted
lngReturnValue = CryptExportKey(hKeyPair, 0, PUBLICKEYBLOB, 0, vbNull, lngLength) 'get the size of the buffer needed for the BLOB
strPublicBlob = String(lngLength, vbNullChar)
lngReturnValue = CryptExportKey(hKeyPair, 0, PUBLICKEYBLOB, 0, strPublicBlob, lngLength) 'get the BLOB
If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not export the public key blob"

'Export the private key to strPublicPrivateBlob (ValuePublicPrivateKey property)
'This key is encrypted with a password
'first get a handle to a session key derived from a password
SessionKeyFromPassword (PrivateKeyPassword)

lngReturnValue = CryptExportKey(hKeyPair, hSessionKey, PRIVATEKEYBLOB, 0, vbNull, lngLength) 'get the size of the buffer needed for the BLOB
strPublicPrivateBlob = String(lngLength, vbNullChar)
lngReturnValue = CryptExportKey(hKeyPair, hSessionKey, PRIVATEKEYBLOB, 0, strPublicPrivateBlob, lngLength) 'get the BLOB
If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not export the private key blob"

End Sub
Public Sub Import_KeyPair(Optional ByVal PrivateKeyPassword As String = vbNullString, Optional ByVal UseExchangeKeyPair As Boolean = True)
'import keys
Dim lngReturnValue As Long
Dim lngLength As Long
Dim lngParams As Long

'check to see if there are no keys available at all
If strPublicPrivateBlob = vbNullString And strPublicBlob = vbNullString Then
    Err.Raise vbObjectError + 1, , "One of the ValueXXXKey properties must hold a valid key"
End If

'release old key pair handle
If hKeyPair <> 0 Then CryptDestroyKey hKeyPair

If UseExchangeKeyPair Then 'set the type of key pair (Exchange key pair or Signature key pair keys)
    lngType = AT_KEYEXCHANGE
Else
    lngType = AT_SIGNATURE
End If

If strPublicPrivateBlob = vbNullString Then 'must be a Public key
    'import the key
    lngLength = Len(strPublicBlob)
    lngReturnValue = CryptImportKey(hCryptProv, strPublicBlob, lngLength, 0, 0, hKeyPair)
    If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not import the Public key"
     
Else 'must be a PublicPrivate key
    'get a session key handle from the password to unlock the
    'private key, which is encrypted
    SessionKeyFromPassword PrivateKeyPassword
    
    'import the key
    lngLength = Len(strPublicPrivateBlob)
    lngParams = CRYPT_EXPORTABLE Or CRYPT_NO_SALT
    lngReturnValue = CryptImportKey(hCryptProv, strPublicPrivateBlob, lngLength, hSessionKey, lngParams, hKeyPair)
    If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not import the PublicPrivate key.  Most likely an incorrect private key password was entered."
End If

'release session key handle
If hSessionKey <> 0 Then CryptDestroyKey hSessionKey

End Sub

Public Sub EncryptFile_KeyPair(ByVal SourceFile As String, ByVal DestFile As String)
'key pair file encryption
Dim intNextFreeFile As Integer
Dim arrByteArray() As Byte
Dim x As Long
Dim y As Long
Dim z As Long

'reset strSessionBlob
strSessionBlob = ""

'Open the source file and read the content
'into a arrByteArray to pass onto encryption
intNextFreeFile = FreeFile
Open SourceFile For Binary As #intNextFreeFile
ReDim arrByteArray(0 To LOF(intNextFreeFile) - 1)
Get #intNextFreeFile, , arrByteArray()
Close #intNextFreeFile

'Encrypt the arrByteArray
EncryptByteArray_KeyPair arrByteArray()

'If the destination file already exists we need
'to delete it since opening it for binary use
'will preserve it if it already exists
On Error Resume Next
Kill DestFile
On Error GoTo 0

'Store the encrypted data in the destination file
'first tack on strSessionBlob to arrByteArray
'This is a kludge because while you can Put the the string
'before arrByteArray, for some reason you can not then
'Get the string when reading it back from the file, so I just
'tacked it on to the array.
z = UBound(arrByteArray) + 1
y = 1
ReDim Preserve arrByteArray(0 To (UBound(arrByteArray) + Len(strSessionBlob) + 1))
For x = z To z + Len(strSessionBlob) - 1
    arrByteArray(x) = Asc(Mid(strSessionBlob, y, 1))
    y = y + 1
Next x
arrByteArray(UBound(arrByteArray)) = Len(strSessionBlob) 'length of blob is last character

intNextFreeFile = FreeFile
Open DestFile For Binary As #intNextFreeFile
Put #intNextFreeFile, , arrByteArray()
Close #intNextFreeFile

End Sub

Public Function DecryptFile_KeyPair(ByVal SourceFile As String, ByVal DestFile As String)
'key pair file decryption
Dim intNextFreeFile As Integer
Dim arrByteArray() As Byte
Dim x As Long
Dim y As Long

'reset the strSessionBlob value
strSessionBlob = ""

'Open the source file and read the content
'into arrByteArray to decrypt
intNextFreeFile = FreeFile
Open SourceFile For Binary As #intNextFreeFile
ReDim arrByteArray(0 To LOF(intNextFreeFile) - 1)
Get #intNextFreeFile, , arrByteArray()
Close #intNextFreeFile

'extract strSessionBlob
'This is a kludge because while you can Put the the string
'before arrByteArray, for some reason you can not then
'Get the string when reading it back from the file, so I just
'tacked it on to the array.
y = arrByteArray(UBound(arrByteArray))
For x = UBound(arrByteArray) - y To UBound(arrByteArray) - 1
    strSessionBlob = strSessionBlob & Chr(arrByteArray(x))
Next x
ReDim Preserve arrByteArray(0 To (UBound(arrByteArray) - Len(strSessionBlob) - 1))

'Decrypt the arrByteArray
DecryptByteArray_KeyPair arrByteArray()

'If the destination file already exists we need
'to delete it since opening it for binary use
'will preserve it if it already exists
On Error Resume Next
If FileLen(DestFile) > 0 Then Kill DestFile
On Error GoTo 0

'Store the decrypted data in the destination file
intNextFreeFile = FreeFile
Open DestFile For Binary As #intNextFreeFile
Put #intNextFreeFile, , arrByteArray()
Close #intNextFreeFile

End Function

Public Function EncryptString_KeyPair(ByVal Text As String) As String
'key pair string encryption
EncryptString_KeyPair = EncryptDecrypt_KeyPair(Text, True)

End Function

Public Function DecryptString_KeyPair(ByVal Text As String) As String
'key pair string decryption
DecryptString_KeyPair = EncryptDecrypt_KeyPair(Text, False)

End Function

Public Function EncryptByteArray_KeyPair(ByRef arrByteArray() As Byte)
'key pair byte array encryption
Dim strInput As String
Dim strOutput As String

strInput = StrConv(arrByteArray(), vbUnicode) 'convert to string
strOutput = EncryptDecrypt_KeyPair(strInput, True) 'return the encrypted data
arrByteArray() = StrConv(strOutput, vbFromUnicode) 'convert to byte array

End Function

Public Function DecryptByteArray_KeyPair(ByRef arrByteArray() As Byte)
'key pair byte array encryption
Dim strInput As String
Dim strOutput As String

strInput = StrConv(arrByteArray(), vbUnicode) 'convert to string
strOutput = EncryptDecrypt_KeyPair(strInput, False) 'return the encrypted data
arrByteArray() = StrConv(strOutput, vbFromUnicode) 'convert to byte array


End Function

Public Sub SessionStart()
'this could be placed at the beginning of EncryptDecrypt, but if you are doing
'multiple encryptions/decryptions, calling this once speeds things up
Dim lngReturnValue As Long

'Get handle to CSP
lngReturnValue = CryptAcquireContext(hCryptProv, KEY_CONTAINER, SERVICE_PROVIDER, PROV_RSA_FULL, CRYPT_NEWKEYSET) 'try to make a new key container
If lngReturnValue = 0 Then
    lngReturnValue = CryptAcquireContext(hCryptProv, KEY_CONTAINER, SERVICE_PROVIDER, PROV_RSA_FULL, 0) 'try to get a handle to a key container that already exists, and if it fails...
    If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above.  Error during CryptAcquireContext for a new key container." & vbCrLf & "A container with this name probably already exists."
End If

End Sub

Public Sub SessionEnd()

'Release any session key handle
If hSessionKey <> 0 Then CryptDestroyKey hSessionKey

'Release any key pair handle
If hKeyPair <> 0 Then CryptDestroyKey hKeyPair

'Release provider handle
If hCryptProv <> 0 Then CryptReleaseContext hCryptProv, 0

End Sub

Private Function EncryptDecrypt(ByVal Text As String, Key As String, Encrypt As Boolean) As String
'the code in this function encrypts/decrypts the data using a single key
Dim lngLength As Long
Dim lngSALTLen As Long
Dim lngReturnValue As Long

SessionKeyFromPassword Key 'get a session key derived from the password

'Set a random SALT.  Always 11 bytes long for the Base CSP, but this code gets the allowed length the correct way
'since other CSPs can have longer lengths.  This shows you how.
If Encrypt Then 'only get a new SALT during encryption
    lngReturnValue = CryptGetKeyParam(hSessionKey, KP_SALT, vbNull, lngSALTLen, 0) 'get the allowed length of the SALT
    'lngReturnValue above is always 0 when you pass in the vbNull parameter, so no reason to check for an error.
    strSALT = String(lngSALTLen + 1, vbNullChar) 'initialize the buffer
    lngReturnValue = CryptGenRandom(hCryptProv, lngSALTLen, strSALT) 'generate a random SALT.
    strSALT = "_i_hate_Salt_" & vbNullChar
    'If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not generate a random SALT"
    'the SALT is now available via the ValueSALT property
End If

lngReturnValue = CryptSetKeyParam(hSessionKey, KP_SALT, strSALT, 0)
If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not set the SALT."
'Note that the same SALT must be used during encryption and decryption.
'A SALT causes the encrypted output to be different even when the input plaintext and password are the same,
'thus the SALT should be different every single time you encrypt a file or string.
'The SALT should be sent as plaintext along with the encrypted file.  This does not make the
'encryption any weaker.

'uncomment this code if you want to verify the SALT value set above
'strSALT = String(12, vbNullChar) 'clear the string
'lngSALTLen = 0 'clear the variable
'lngReturnValue = CryptGetKeyParam(hSessionKey, KP_SALT, vbNull, lngSALTLen, 0) 'get the length of the SALT
'lngReturnValue = CryptGetKeyParam(hSessionKey, KP_SALT, strSALT, lngSALTLen, 0) 'get the SALT
'If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not get the SALT."
'MsgBox "get " & lngSALTLen & " " & strSALT

'Encrypt or decrypt depending on the Encrypt parameter
lngLength = Len(Text)
If Encrypt Then
    lngReturnValue = CryptEncrypt(hSessionKey, 0, 1, 0, Text, lngLength, lngLength)
    If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Error during CryptEncrypt."
Else
    lngReturnValue = CryptDecrypt(hSessionKey, 0, 1, 0, Text, lngLength)
    If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Error during CryptDecrypt."
End If

'return the encrypted/decrypted data and chop off extra padding
EncryptDecrypt = Left$(Text, lngLength)

'Destroy the session key
If hSessionKey <> 0 Then CryptDestroyKey hSessionKey

End Function
Private Function EncryptDecrypt_KeyPair(ByVal Text As String, Encrypt As Boolean) As String
'the code in this function encrypts/decrypts the data using a single key
Dim lngLength As Long
Dim lngReturnValue As Long

If Encrypt Then 'get the public key and encrypt
    'first release old session handle
    If hSessionKey <> 0 Then CryptDestroyKey hSessionKey
    
    'get a random session key
    lngReturnValue = CryptGenKey(hCryptProv, CALG_RC4, CRYPT_EXPORTABLE, hSessionKey)
    If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not create session key for use in key pair encryption"
    
    'first release old key pair handle
    If hKeyPair <> 0 Then CryptDestroyKey hKeyPair
    
    'get a handle to the key pair
    lngReturnValue = CryptGetUserKey(hCryptProv, lngType, hKeyPair)
    If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not obtain public key for use in key pair encryption"

    'export and encrypt the session key
    lngReturnValue = CryptExportKey(hSessionKey, hKeyPair, SIMPLEBLOB, 0, vbNull, lngLength) 'get the size of the buffer needed for the BLOB
    strSessionBlob = String(lngLength, vbNullChar)
    lngReturnValue = CryptExportKey(hSessionKey, hKeyPair, SIMPLEBLOB, 0, strSessionBlob, lngLength) 'get the BLOB
    If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not export the session key during key pair encryption"

    'encrypt the data
    lngLength = Len(Text)
    lngReturnValue = CryptEncrypt(hSessionKey, 0, 1, 0, Text, lngLength, lngLength)
    If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Error during key pair CryptEncrypt encryption."

Else 'get the private key and decrypt
    'first release old session handle
    If hSessionKey <> 0 Then CryptDestroyKey hSessionKey
    
    'import the session key
    lngLength = Len(strSessionBlob)
    lngReturnValue = CryptImportKey(hCryptProv, strSessionBlob, lngLength, hKeyPair, 0, hSessionKey)
    If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not import the session key during key pair decryption.  Most likely an incorrect private key was used, thus it could not decrypt the session key."
    
    'first release old key pair handle
    If hKeyPair <> 0 Then CryptDestroyKey hKeyPair
    
    'get a handle to the key pair
    lngReturnValue = CryptGetUserKey(hCryptProv, lngType, hKeyPair)
    If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not obtain private key for use in key pair decryption"
    
    'decrypt
    lngLength = Len(Text)
    lngReturnValue = CryptDecrypt(hSessionKey, 0, 1, 0, Text, lngLength)
    If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Error during key pair CryptDecrypt decryption."

End If

'return the encrypted/decrypted data and chop off extra padding
EncryptDecrypt_KeyPair = Left$(Text, lngLength)

'Destroy the session key
If hSessionKey <> 0 Then CryptDestroyKey hSessionKey

End Function

Private Sub SessionKeyFromPassword(ByVal Key As String)
'This sub takes a string key as input and sets the module-level
'hSessionKey variable to a new session key handle.
'This sub is used by EncryptDecrypt, Export_KeyPair and Import_KeyPair.
Dim lngParams As Long
Dim lngReturnValue As Long
Dim strHash As String
Dim lngHashLen As Long
Dim hHash As Long 'the handle to the hash object

'Create a hash object to calculate a session
'key from the Password (instead of encrypting
'with the actual key)
lngReturnValue = CryptCreateHash(hCryptProv, CALG_SHA, 0, 0, hHash)
If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not create a Hash Object (CryptCreateHash API)"
'can use CALG_MD5 to get a 128-bit hash.  CALG_SHA returns a 160-bit hash (more secure).

'Hash the Password
lngReturnValue = CryptHashData(hHash, Key, Len(Key), 0)
If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not calculate a Hash Value (CryptHashData API)"
'A hash is a 'fingerprint' of any string.
'Hashes are extremely useful for determining whether a
'transmission or file has been altered.  This code can use
'one of two algorithms (see note above).  No matter what the
'length of input data, the hash will be a fixed length and
'will be unique for that string of data.  The same hash is produced for
'the same input data every time.  This is useful here to
'produce a fixed-length, unique password for any length password entered.

'Get the actual hash value
lngReturnValue = CryptGetHashParam(hHash, HP_HASHVAL, vbNull, lngHashLen, 0) 'get the hash length
strHash = String(lngHashLen + 1, vbNullChar)
lngReturnValue = CryptGetHashParam(hHash, HP_HASHVAL, strHash, lngHashLen, 0) 'get the hash value
If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not lngReturnValuerieve the hash value"

'Set certain values to add more flexibility and security.
'Make the key exportable. (I don't export the key in this sample code)
lngParams = CRYPT_EXPORTABLE 'use this when you generate your own SALT, which is recommended (see 8 lines below)
'Make the key exportable and add a system-generated SALT.
'use this line of code instead of the one above if you want the API to set the SALT...
'but the SALT is the same every time so this shouldn't be used!
'Note that I generate my own random SALT below.
'lngParams = CRYPT_EXPORTABLE Or CRYPT_CREATE_SALT

'release old session key handle if one exists
If hSessionKey <> 0 Then CryptDestroyKey hSessionKey

'Derive a session key from the hash object
lngReturnValue = CryptDeriveKey(hCryptProv, CALG_RC4, hHash, lngParams, hSessionKey)
If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not create a session key (CryptDeriveKey API)"

'Destroy the hash object
If hHash <> 0 Then CryptDestroyHash hHash

End Sub

Private Function SignValidate_KeyPair(ByVal Text As String, Sign As Boolean) As String
'Create a signature or verify a signature
Dim hHash As Long
Dim lngReturnValue As Long
Dim lngSigLen As Long

'reset the value
SignValidate_KeyPair = vbNullString

'Create a hash object to hash the input data
lngReturnValue = CryptCreateHash(hCryptProv, CALG_SHA, 0, 0, hHash)
If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not create a Hash Object (CryptCreateHash API)"
'can use CALG_MD5 to get a 128-bit hash.  CALG_SHA returns a 160-bit hash (more secure).

'Hash the data
lngReturnValue = CryptHashData(hHash, Text, Len(Text), 0)
If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not calculate a Hash Value (CryptHashData API)"

If Sign Then 'sign it
    'Determine the size of signature
    lngReturnValue = CryptSignHash(hHash, AT_SIGNATURE, 0, 0, vbNull, lngSigLen)
    strSig = String(lngSigLen, vbNullChar) 'initialize the string

    'Sign hash object
    lngReturnValue = CryptSignHash(hHash, AT_SIGNATURE, 0, 0, strSig, lngSigLen)
    If lngReturnValue = 0 Then Err.Raise Err.LastDllError, , "DLL error code shown above. Could not sign the hash"
    
    'return the signature and chop off extra padding
    strSig = Left$(strSig, lngSigLen)
    SignValidate_KeyPair = Text
    'the signature is now available via the ValueSignature property
    
Else 'validate the signature
    'uses a signature placed into the ValueSignature property
    lngSigLen = Len(strSig)
    lngReturnValue = CryptVerifySignature(hHash, strSig, lngSigLen, hKeyPair, 0, 0)
    If lngReturnValue = 0 Then 'some error occurred
        If Err.LastDllError = NTE_BAD_SIGNATURE Then
            Err.Raise Err.LastDllError, , "DLL error code shown above. Bad signature.  This might be because the data has changed, or the wrong public key was used to check the signature."
        Else
            Err.Raise Err.LastDllError, , "DLL error code shown above. Could not verify the signature"
        End If
    End If 'some error occurred
    
    SignValidate_KeyPair = Text 'no error occurred
    
End If

'Destroy hash object.
If hHash <> 0 Then CryptDestroyHash hHash

End Function

Public Sub SignFile_KeyPair(ByVal SourceFile As String, ByVal DestFile As String)
'key pair file signing
Dim intNextFreeFile As Integer
Dim arrByteArray() As Byte
Dim x As Long
Dim y As Long
Dim z As Long

'reset strSig
strSig = ""

'Open the source file and read the content
'into a arrByteArray to pass onto signature algorithm
intNextFreeFile = FreeFile
Open SourceFile For Binary As #intNextFreeFile
ReDim arrByteArray(0 To LOF(intNextFreeFile) - 1)
Get #intNextFreeFile, , arrByteArray()
Close #intNextFreeFile

'sign the arrByteArray
SignByteArray_KeyPair arrByteArray()

'If the destination file already exists we need
'to delete it since opening it for binary use
'will preserve it if it already exists
On Error Resume Next
Kill DestFile
On Error GoTo 0

'Store the signed data in the destination file
'first tack on strSig to arrByteArray
'This is a kludge because while you can Put the the string
'before arrByteArray, for some reason you can not then
'Get the string when reading it back from the file, so I just
'tacked it on to the array.
z = UBound(arrByteArray) + 1
y = 1
ReDim Preserve arrByteArray(0 To (UBound(arrByteArray) + Len(strSig) + 1))
For x = z To z + Len(strSig) - 1
    arrByteArray(x) = Asc(Mid(strSig, y, 1))
    y = y + 1
Next x
arrByteArray(UBound(arrByteArray)) = Len(strSig) 'length of blob is last character

intNextFreeFile = FreeFile
Open DestFile For Binary As #intNextFreeFile
Put #intNextFreeFile, , arrByteArray()
Close #intNextFreeFile

End Sub

Public Function ValidateFile_KeyPair(ByVal SourceFile As String, ByVal DestFile As String)
'key pair file signature validation
Dim intNextFreeFile As Integer
Dim arrByteArray() As Byte
Dim x As Long
Dim y As Long

'reset the strSig value
strSig = ""

'Open the source file and read the content
'into arrByteArray to decrypt
intNextFreeFile = FreeFile
Open SourceFile For Binary As #intNextFreeFile
ReDim arrByteArray(0 To LOF(intNextFreeFile) - 1)
Get #intNextFreeFile, , arrByteArray()
Close #intNextFreeFile

'extract strSig
'This is a kludge because while you can Put the the string
'before arrByteArray, for some reason you can not then
'Get the string when reading it back from the file, so I just
'tacked it on to the array.
y = arrByteArray(UBound(arrByteArray))
For x = UBound(arrByteArray) - y To UBound(arrByteArray) - 1
    strSig = strSig & Chr(arrByteArray(x))
Next x
ReDim Preserve arrByteArray(0 To (UBound(arrByteArray) - Len(strSig) - 1))

'Decrypt the arrByteArray
ValidateByteArray_KeyPair arrByteArray()

'If the destination file already exists we need
'to delete it since opening it for binary use
'will preserve it if it already exists
On Error Resume Next
If FileLen(DestFile) > 0 Then Kill DestFile
On Error GoTo 0

'Store the decrypted data in the destination file
intNextFreeFile = FreeFile
Open DestFile For Binary As #intNextFreeFile
Put #intNextFreeFile, , arrByteArray()
Close #intNextFreeFile

End Function

Public Function SignByteArray_KeyPair(ByRef arrByteArray() As Byte)
'key pair byte array signing
Dim strInput As String
Dim strOutput As String

strInput = StrConv(arrByteArray(), vbUnicode) 'convert to string
strOutput = SignValidate_KeyPair(strInput, True) 'return the signature
arrByteArray() = StrConv(strOutput, vbFromUnicode) 'convert to byte array

End Function

Public Function ValidateByteArray_KeyPair(ByRef arrByteArray() As Byte)
'key pair byte array signing
Dim strInput As String
Dim strOutput As String

strInput = StrConv(arrByteArray(), vbUnicode) 'convert to string
strOutput = SignValidate_KeyPair(strInput, False) 'return the signature
arrByteArray() = StrConv(strOutput, vbFromUnicode) 'convert to byte array

End Function

Public Function SignString_KeyPair(ByVal Text As String) As String
'key pair string signing
SignString_KeyPair = SignValidate_KeyPair(Text, True)

End Function

Public Function ValidateString_KeyPair(ByVal Text As String) As String
'key pair string decryption
ValidateString_KeyPair = SignValidate_KeyPair(Text, False)

End Function

'************************************************************************
' All properties and functions below this line are for COMPRESSION/DECOMPRESSION
'************************************************************************

Public Property Get ValueCompressedSize() As Long
'size of an object after compression
ValueCompressedSize = lngCompressedSize
    
End Property

Private Property Let ValueCompressedSize(ByVal New_ValueCompressedSize As Long)

lngCompressedSize = New_ValueCompressedSize
    
End Property

Public Property Get ValueDecompressedSize() As Long
'size of an object after decompression
ValueDecompressedSize = lngDecompressedSize
    
End Property

Private Property Let ValueDecompressedSize(ByVal New_ValueDecompressedSize As Long)

lngDecompressedSize = New_ValueDecompressedSize
    
End Property

Public Function CompressByteArray(TheData() As Byte, CompressionLevel As Integer) As Long
'compress a byte array
Dim lngResult As Long
Dim lngBufferSize As Long
Dim arrByteArray() As Byte

lngDecompressedSize = UBound(TheData) + 1

'Allocate memory for byte array
lngBufferSize = UBound(TheData) + 1
lngBufferSize = lngBufferSize + (lngBufferSize * 0.01) + 12
ReDim arrByteArray(lngBufferSize)

'Compress byte array (data)
'lngResult = compress(arrByteArray(0), lngBufferSize, TheData(0), UBound(TheData) + 1, CompressionLevel)

'Truncate to compressed size
ReDim Preserve TheData(lngBufferSize - 1)
CopyMemory TheData(0), arrByteArray(0), lngBufferSize

'Set property
lngCompressedSize = UBound(TheData) + 1

'return error code (if any)
CompressByteArray = lngResult

End Function

Public Function CompressString(Text As String, CompressionLevel As Integer) As Long
'compress a string
Dim lngOrgSize As Long
Dim lngReturnValue As Long
Dim lngCmpSize As Long
Dim strTBuff As String

ValueDecompressedSize = Len(Text)

'Allocate string space for the buffers
lngOrgSize = Len(Text)
strTBuff = String(lngOrgSize + (lngOrgSize * 0.01) + 12, 0)
lngCmpSize = Len(strTBuff)

'Compress string (temporary string buffer) data
'lngReturnValue = compress2(ByVal strTBuff, lngCmpSize, ByVal Text, Len(Text), CompressionLevel)

'Crop the string and set it to the actual string.
Text = Left$(strTBuff, lngCmpSize)

'Set compressed size of string.
ValueCompressedSize = lngCmpSize

'Cleanup
strTBuff = ""

'return error code (if any)
CompressString = lngReturnValue

End Function

Public Function DecompressByteArray(TheData() As Byte, OriginalSize As Long) As Long
'decompress a byte array
Dim lngResult As Long
Dim lngBufferSize As Long
Dim arrByteArray() As Byte

lngDecompressedSize = OriginalSize
lngCompressedSize = UBound(TheData) + 1

'Allocate memory for byte array
lngBufferSize = OriginalSize
lngBufferSize = lngBufferSize + (lngBufferSize * 0.01) + 12
ReDim arrByteArray(lngBufferSize)

'Decompress data
'lngResult = uncompress(arrByteArray(0), lngBufferSize, TheData(0), UBound(TheData) + 1)

'Truncate buffer to compressed size
ReDim Preserve TheData(lngBufferSize - 1)
CopyMemory TheData(0), arrByteArray(0), lngBufferSize

'return error code (if any)
DecompressByteArray = lngResult

End Function

Public Function DecompressString(Text As String, OriginalSize As Long) As Long
'decompress a string
Dim lngResult As Long
Dim lngCmpSize As Long
Dim strTBuff As String

'Allocate string space
strTBuff = String(ValueDecompressedSize + (ValueDecompressedSize * 0.01) + 12, 0)
lngCmpSize = Len(strTBuff)

ValueDecompressedSize = OriginalSize

'Decompress
'lngResult = uncompress(ByVal strTBuff, lngCmpSize, ByVal Text, Len(Text))

'Make string the size of the uncompressed string
Text = Left$(strTBuff, lngCmpSize)

ValueCompressedSize = lngCmpSize

'return error code (if any)
DecompressString = lngResult

End Function
Public Function CompressFile(FilePathIn As String, FilePathOut As String, CompressionLevel As Integer) As Long
'compress a file
Dim intNextFreeFile As Integer
Dim TheBytes() As Byte
Dim lngResult As Long
Dim lngFileLen As Long

lngFileLen = FileLen(FilePathIn)

'allocate byte array
ReDim TheBytes(lngFileLen - 1)

'read byte array from file
intNextFreeFile = FreeFile
Open FilePathIn For Binary Access Read As #intNextFreeFile
    Get #intNextFreeFile, , TheBytes()
Close #intNextFreeFile

'compress byte array
lngResult = CompressByteArray(TheBytes(), CompressionLevel)

'kill any file in place
On Error Resume Next
Kill FilePathOut
On Error GoTo 0

'Write it out
intNextFreeFile = FreeFile
Open FilePathOut For Binary Access Write As #intNextFreeFile
    Put #intNextFreeFile, , lngFileLen 'must store the length of the original file
    Put #intNextFreeFile, , TheBytes()
Close #intNextFreeFile

Erase TheBytes
CompressFile = lngResult

End Function

Public Function DecompressFile(FilePathIn As String, FilePathOut As String) As Long
'decompress a file
Dim intNextFreeFile As Integer
Dim TheBytes() As Byte
Dim lngResult As Long
Dim lngFileLen As Long

'allocate byte array
ReDim TheBytes(FileLen(FilePathIn) - 1)

'read byte array from file
intNextFreeFile = FreeFile
Open FilePathIn For Binary Access Read As #intNextFreeFile
    Get #intNextFreeFile, , lngFileLen 'the original (uncompressed) file's length
    Get #intNextFreeFile, , TheBytes()
Close #intNextFreeFile

'decompress
lngResult = DecompressByteArray(TheBytes(), lngFileLen)

'kill any file already there
On Error Resume Next
Kill FilePathOut
On Error GoTo 0

'Write it out
intNextFreeFile = FreeFile
Open FilePathOut For Binary Access Write As #intNextFreeFile
    Put #intNextFreeFile, , TheBytes()
Close #intNextFreeFile

Erase TheBytes
DecompressFile = lngResult

End Function

