Attribute VB_Name = "modPEStructs"
Option Explicit
'these struct definitions were taken from VB debugger sample by VF-fCRO
'http://www.Planet-Source-Code.com/vb/scripts/ShowCode.asp?txtCodeId=42422&lngWId=1

Public Const IMAGE_NUMBEROF_DIRECTORY_ENTRIES = 16
Public Const IMAGE_SIZEOF_SHORT_NAME = 8
Public Const IMAGE_NT_OPTIONAL_HDR32_MAGIC = &H10B

Public Type IMAGEDOSHEADER
    e_magic As Integer
    e_cblp As Integer
    e_cp As Integer
    e_crlc As Integer
    e_cparhdr As Integer
    e_minalloc As Integer
    e_maxalloc As Integer
    e_ss As Integer
    e_sp As Integer
    e_csum As Integer
    e_ip As Integer
    e_cs As Integer
    e_lfarlc As Integer
    e_ovno As Integer
    e_res(1 To 4) As Integer
    e_oemid As Integer
    e_oeminfo As Integer
    e_res2(1 To 10)    As Integer
    e_lfanew As Long
End Type

Public Type IMAGE_EXPORT_DIRECTORY
    Characteristics As Long
    TimeDateStamp As Long
    MajorVersion As Integer
    MinorVersion As Integer
    Name As Long
    Base As Long
    NumberOfFunctions As Long
    NumberOfNames As Long
    AddressOfFunctions As Long
    AddressOfNames As Long
    AddressOfNameOrdinals As Long
End Type

Public Type IMAGE_IMPORT_DIRECTORY
    dwRVAFunctionNameList As Long
    TimeDateStamp As Long
    ForwarderChain As Long
    dwRVAModuleName As Long
    dwRVAFunctionAddressList As Long
End Type

Public Type IMAGE_SECTION_HEADER
    nameSec As String * 6
    PhisicalAddress As Integer
    VirtualSize As Long
    VirtualAddress As Long
    SizeOfRawData As Long
    PointerToRawData As Long
    PointerToRelocations As Long
    PointerToLinenumbers As Long
    NumberOfRelocations As Integer
    NumberOfLinenumbers As Integer
    Characteristics As Long
End Type

Public Type IMAGE_FILE_HEADER
    Machine As Integer
    NumberOfSections As Integer
    TimeDateStamp As Long
    PointerToSymbolTable As Long
    NumberOfSymbols As Long
    SizeOfOptionalHeader As Integer
    Characteristics As Integer
End Type

Public Type IMAGE_DATA_DIRECTORY
    VirtualAddress As Long
    size As Long
End Type


Public Type IMAGE_OPTIONAL_HEADER
    Magic As Integer
    MajorLinkerVersion As Byte
    MinorLinkerVersion As Byte
    SizeOfCode As Long
    SizeOfInitializedData As Long
    SizeOfUninitializedData As Long
    AddressOfEntryPoint As Long
    BaseOfCode As Long
    BaseOfData As Long
    ImageBase As Long
    SectionAlignment As Long
    FileAlignment As Long
    MajorOperatingSystemVersion As Integer
    MinorOperatingSystemVersion As Integer
    MajorImageVersion As Integer
    MinorImageVersion As Integer
    MajorSubsystemVersion As Integer
    MinorSubsystemVersion As Integer
    Win32VersionValue As Long
    SizeOfImage As Long
    SizeOfHeaders As Long
    CheckSum As Long
    Subsystem As Integer
    DllCharacteristics As Integer
    SizeOfStackReserve As Long
    SizeOfStackCommit As Long
    SizeOfHeapReserve As Long
    SizeOfHeapCommit As Long
    LoaderFlags As Long
    NumberOfRvaAndSizes As Long
    DataDirectory(0 To 15) As IMAGE_DATA_DIRECTORY
End Type

'IMAGE DATA DIRECTORY:
'1-Export Table
'2-Import Table
'3-Resource Table
'4-Exception Table
'5-Certificate Table
'6-Relocation Table
'7-Debug Data
'8-Architecture Data
'9-Machine Value (MIPS GP)
'10-TLS Table
'11-Load Configuration Table
'12-Bound Import Table
'13-Import Address Table
'14-Delay Import Descriptor
'15-COM+ Runtime Header
'16-Reserved


Public Type IMAGE_NT_HEADERS
    Signature As String * 4
    FileHeader As IMAGE_FILE_HEADER
    OptionalHeader As IMAGE_OPTIONAL_HEADER
End Type

