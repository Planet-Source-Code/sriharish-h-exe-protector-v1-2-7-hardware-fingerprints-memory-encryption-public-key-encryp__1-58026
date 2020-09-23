VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "comdlg32.ocx"
Object = "{BDC217C8-ED16-11CD-956C-0000C04E4C0A}#1.1#0"; "TABCTL32.OCX"
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomct2.ocx"
Begin VB.Form mainfrm 
   Caption         =   "Exe Protector v1.2 Advanced: Best Software Protection code in Pscode.com"
   ClientHeight    =   6900
   ClientLeft      =   60
   ClientTop       =   750
   ClientWidth     =   9105
   Icon            =   "mainfrm.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   6900
   ScaleWidth      =   9105
   StartUpPosition =   2  'CenterScreen
   Begin TabDlg.SSTab SSTab1 
      Height          =   6975
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   9135
      _ExtentX        =   16113
      _ExtentY        =   12303
      _Version        =   393216
      Style           =   1
      Tabs            =   6
      TabHeight       =   520
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      TabCaption(0)   =   "Main >>Step1"
      TabPicture(0)   =   "mainfrm.frx":74F2
      Tab(0).ControlEnabled=   -1  'True
      Tab(0).Control(0)=   "Label4"
      Tab(0).Control(0).Enabled=   0   'False
      Tab(0).Control(1)=   "Label3"
      Tab(0).Control(1).Enabled=   0   'False
      Tab(0).Control(2)=   "Label2"
      Tab(0).Control(2).Enabled=   0   'False
      Tab(0).Control(3)=   "Label1"
      Tab(0).Control(3).Enabled=   0   'False
      Tab(0).Control(4)=   "Label15"
      Tab(0).Control(4).Enabled=   0   'False
      Tab(0).Control(5)=   "Shape1"
      Tab(0).Control(5).Enabled=   0   'False
      Tab(0).Control(6)=   "Label16"
      Tab(0).Control(6).Enabled=   0   'False
      Tab(0).Control(7)=   "Shape2"
      Tab(0).Control(7).Enabled=   0   'False
      Tab(0).Control(8)=   "Label17"
      Tab(0).Control(8).Enabled=   0   'False
      Tab(0).Control(9)=   "Label20"
      Tab(0).Control(9).Enabled=   0   'False
      Tab(0).Control(10)=   "Label21"
      Tab(0).Control(10).Enabled=   0   'False
      Tab(0).Control(11)=   "Label22"
      Tab(0).Control(11).Enabled=   0   'False
      Tab(0).Control(12)=   "Label23"
      Tab(0).Control(12).Enabled=   0   'False
      Tab(0).Control(13)=   "Label24"
      Tab(0).Control(13).Enabled=   0   'False
      Tab(0).Control(14)=   "CommonDialog2"
      Tab(0).Control(14).Enabled=   0   'False
      Tab(0).Control(15)=   "Appname"
      Tab(0).Control(15).Enabled=   0   'False
      Tab(0).Control(16)=   "appversion"
      Tab(0).Control(16).Enabled=   0   'False
      Tab(0).Control(17)=   "trialkey"
      Tab(0).Control(17).Enabled=   0   'False
      Tab(0).Control(18)=   "unlockkey"
      Tab(0).Control(18).Enabled=   0   'False
      Tab(0).Control(19)=   "Command7"
      Tab(0).Control(19).Enabled=   0   'False
      Tab(0).Control(20)=   "Command8"
      Tab(0).Control(20).Enabled=   0   'False
      Tab(0).Control(21)=   "eamiltxt"
      Tab(0).Control(21).Enabled=   0   'False
      Tab(0).Control(22)=   "website"
      Tab(0).Control(22).Enabled=   0   'False
      Tab(0).Control(23)=   "helptext"
      Tab(0).Control(23).Enabled=   0   'False
      Tab(0).Control(24)=   "filename"
      Tab(0).Control(24).Enabled=   0   'False
      Tab(0).Control(25)=   "Command9"
      Tab(0).Control(25).Enabled=   0   'False
      Tab(0).Control(26)=   "cdlg2"
      Tab(0).Control(26).Enabled=   0   'False
      Tab(0).ControlCount=   27
      TabCaption(1)   =   "Protection Options >>Step2"
      TabPicture(1)   =   "mainfrm.frx":750E
      Tab(1).ControlEnabled=   0   'False
      Tab(1).Control(0)=   "Label19"
      Tab(1).Control(1)=   "Frame1"
      Tab(1).ControlCount=   2
      TabCaption(2)   =   "Language Editor >>Step3"
      TabPicture(2)   =   "mainfrm.frx":752A
      Tab(2).ControlEnabled=   0   'False
      Tab(2).Control(0)=   "Label12"
      Tab(2).Control(1)=   "Label11"
      Tab(2).Control(2)=   "Command1"
      Tab(2).Control(3)=   "Chklang"
      Tab(2).Control(4)=   "Lstlang"
      Tab(2).ControlCount=   5
      TabCaption(3)   =   "Hardware Fingerprints >>Step4"
      TabPicture(3)   =   "mainfrm.frx":7546
      Tab(3).ControlEnabled=   0   'False
      Tab(3).Control(0)=   "Label10"
      Tab(3).Control(1)=   "Label9"
      Tab(3).Control(2)=   "Text4"
      Tab(3).Control(3)=   "lsthardware"
      Tab(3).ControlCount=   4
      TabCaption(4)   =   "Misc >>Step5"
      TabPicture(4)   =   "mainfrm.frx":7562
      Tab(4).ControlEnabled=   0   'False
      Tab(4).Control(0)=   "Chkbackup"
      Tab(4).Control(1)=   "chklaunch"
      Tab(4).Control(2)=   "chkreport"
      Tab(4).Control(3)=   "txtublockpw"
      Tab(4).Control(4)=   "chkublock"
      Tab(4).Control(5)=   "txtregpw"
      Tab(4).Control(6)=   "chkregpw"
      Tab(4).Control(7)=   "chkCRC"
      Tab(4).Control(8)=   "chkincrease"
      Tab(4).Control(9)=   "chkreset"
      Tab(4).Control(10)=   "chkstartup"
      Tab(4).Control(11)=   "Chkone"
      Tab(4).Control(12)=   "Label14"
      Tab(4).ControlCount=   13
      TabCaption(5)   =   "Black Listed Codes"
      TabPicture(5)   =   "mainfrm.frx":757E
      Tab(5).ControlEnabled=   0   'False
      Tab(5).Control(0)=   "Label13"
      Tab(5).Control(1)=   "Label18"
      Tab(5).Control(2)=   "lbltotal"
      Tab(5).Control(3)=   "Command4"
      Tab(5).Control(4)=   "Command3"
      Tab(5).Control(5)=   "Command2"
      Tab(5).Control(6)=   "blacklst"
      Tab(5).Control(7)=   "Command5"
      Tab(5).Control(8)=   "Command6"
      Tab(5).Control(9)=   "cdlg"
      Tab(5).ControlCount=   10
      Begin VB.CheckBox Chkbackup 
         Caption         =   "Create Backup"
         Height          =   255
         Left            =   -71040
         TabIndex        =   75
         Top             =   1680
         Value           =   1  'Checked
         Width           =   1455
      End
      Begin MSComDlg.CommonDialog cdlg2 
         Left            =   360
         Top             =   1800
         _ExtentX        =   847
         _ExtentY        =   847
         _Version        =   393216
      End
      Begin VB.CommandButton Command9 
         Caption         =   "Browse"
         Height          =   375
         Left            =   6240
         TabIndex        =   74
         Top             =   800
         Width           =   1215
      End
      Begin VB.TextBox filename 
         Height          =   285
         Left            =   2160
         Locked          =   -1  'True
         TabIndex        =   73
         Top             =   840
         Width           =   3975
      End
      Begin VB.TextBox helptext 
         Height          =   285
         Left            =   2160
         MaxLength       =   255
         TabIndex        =   70
         Top             =   3600
         Width           =   2295
      End
      Begin VB.TextBox website 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   -1  'True
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF0000&
         Height          =   285
         Left            =   2160
         MaxLength       =   255
         TabIndex        =   69
         Text            =   "http://www.sriharish.info"
         Top             =   3240
         Width           =   2295
      End
      Begin VB.TextBox eamiltxt 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   400
            Underline       =   -1  'True
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H00FF0000&
         Height          =   285
         Left            =   2160
         MaxLength       =   255
         TabIndex        =   68
         Text            =   "sriharish@msn.com"
         Top             =   2760
         Width           =   2295
      End
      Begin MSComDlg.CommonDialog cdlg 
         Left            =   -67800
         Top             =   4560
         _ExtentX        =   847
         _ExtentY        =   847
         _Version        =   393216
      End
      Begin VB.CommandButton Command8 
         Caption         =   "Generate"
         Height          =   255
         Left            =   5760
         TabIndex        =   58
         Top             =   2400
         Width           =   1455
      End
      Begin VB.CommandButton Command7 
         Caption         =   "Generate"
         Height          =   255
         Left            =   5760
         TabIndex        =   57
         Top             =   2040
         Width           =   1455
      End
      Begin VB.CheckBox chklaunch 
         Caption         =   "Automatically launch after protection"
         Height          =   255
         Left            =   -71040
         TabIndex        =   43
         Top             =   1320
         Width           =   3135
      End
      Begin VB.CheckBox chkreport 
         Caption         =   "Create report after protection"
         Height          =   255
         Left            =   -71040
         TabIndex        =   42
         Top             =   960
         Width           =   2655
      End
      Begin VB.TextBox unlockkey 
         Height          =   285
         Left            =   2160
         MaxLength       =   255
         TabIndex        =   39
         Top             =   2400
         Width           =   3375
      End
      Begin VB.TextBox trialkey 
         Height          =   285
         Left            =   2160
         TabIndex        =   38
         Top             =   2040
         Width           =   3375
      End
      Begin VB.TextBox appversion 
         Height          =   285
         Left            =   2160
         MaxLength       =   5
         TabIndex        =   36
         Top             =   1560
         Width           =   735
      End
      Begin VB.TextBox Appname 
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   285
         Left            =   2160
         MaxLength       =   255
         TabIndex        =   35
         Top             =   1200
         Width           =   2295
      End
      Begin VB.TextBox txtublockpw 
         Enabled         =   0   'False
         Height          =   285
         Left            =   -71400
         TabIndex        =   33
         Top             =   3840
         Width           =   2295
      End
      Begin VB.CheckBox chkublock 
         Caption         =   "Reusable Loader unblock Password"
         Height          =   255
         Left            =   -74880
         TabIndex        =   32
         Top             =   3840
         Width           =   3015
      End
      Begin VB.TextBox txtregpw 
         Enabled         =   0   'False
         Height          =   285
         Left            =   -71400
         TabIndex        =   31
         Top             =   3360
         Width           =   2295
      End
      Begin VB.CheckBox chkregpw 
         Caption         =   "Use Password to access registration menu"
         Height          =   255
         Left            =   -74880
         TabIndex        =   30
         Top             =   3360
         Width           =   3375
      End
      Begin VB.CheckBox chkCRC 
         Caption         =   "Use CRC Check for Locked file (recommended)"
         Height          =   255
         Left            =   -74880
         TabIndex        =   29
         Top             =   2880
         Value           =   1  'Checked
         Width           =   4215
      End
      Begin VB.CheckBox chkincrease 
         Caption         =   "Increase Trial on request (not valid for trial by date or trial by version)"
         Height          =   255
         Left            =   -74880
         TabIndex        =   28
         Top             =   2400
         Width           =   5295
      End
      Begin VB.CheckBox chkreset 
         Caption         =   "Reset Trial on new versions (not valid for trial by version)"
         Height          =   255
         Left            =   -74880
         TabIndex        =   27
         Top             =   1920
         Width           =   4455
      End
      Begin VB.CheckBox chkstartup 
         Caption         =   "Do not show loader at start up"
         Height          =   255
         Left            =   -74880
         TabIndex        =   26
         Top             =   1440
         Width           =   3255
      End
      Begin VB.CheckBox Chkone 
         Caption         =   "Allow One copy"
         Height          =   255
         Left            =   -74880
         TabIndex        =   25
         Top             =   960
         Width           =   3255
      End
      Begin VB.CommandButton Command6 
         Caption         =   "Clear All"
         Height          =   375
         Left            =   -67680
         TabIndex        =   24
         Top             =   3600
         Width           =   1335
      End
      Begin VB.CommandButton Command5 
         Caption         =   "Load from text"
         Height          =   375
         Left            =   -67680
         TabIndex        =   23
         Top             =   3120
         Width           =   1335
      End
      Begin VB.Frame Frame1 
         Caption         =   "Protection Options"
         Height          =   5055
         Left            =   -74880
         TabIndex        =   10
         Top             =   720
         Width           =   8655
         Begin VB.CommandButton Command10 
            Caption         =   "Advanced"
            Height          =   375
            Left            =   7080
            TabIndex        =   76
            Top             =   480
            Width           =   1335
         End
         Begin VB.CheckBox Chkcreep 
            Caption         =   "Enable Creep (requires SDK, little slow)"
            Height          =   255
            Left            =   1920
            TabIndex        =   64
            Top             =   1560
            Width           =   4215
         End
         Begin VB.CheckBox Chkvarmem 
            Caption         =   "Enable Variable Memory Encryption (Another defence to confuse cracker)"
            Height          =   375
            Left            =   1920
            TabIndex        =   62
            Top             =   1080
            Width           =   4335
         End
         Begin VB.CheckBox Chkmem 
            Caption         =   "Enable Memory Encryption (Another antidumping defence)"
            Height          =   375
            Left            =   1920
            TabIndex        =   61
            Top             =   600
            Width           =   4335
         End
         Begin VB.Frame Frame2 
            Height          =   2055
            Left            =   120
            TabIndex        =   44
            Top             =   1920
            Width           =   8295
            Begin VB.TextBox txtversion 
               Enabled         =   0   'False
               Height          =   285
               Left            =   2160
               MaxLength       =   5
               TabIndex        =   51
               Top             =   1440
               Width           =   855
            End
            Begin VB.OptionButton optversion 
               Caption         =   "By Version"
               Height          =   255
               Left            =   960
               TabIndex        =   50
               Top             =   1440
               Width           =   1095
            End
            Begin VB.OptionButton optdate 
               Caption         =   "By Date"
               Height          =   255
               Left            =   960
               TabIndex        =   49
               Top             =   1080
               Width           =   975
            End
            Begin VB.TextBox txtcount 
               Enabled         =   0   'False
               Height          =   285
               Left            =   2160
               MaxLength       =   3
               TabIndex        =   48
               Top             =   720
               Width           =   855
            End
            Begin VB.OptionButton optcount 
               Caption         =   "By Count"
               Height          =   255
               Left            =   960
               TabIndex        =   47
               Top             =   720
               Width           =   975
            End
            Begin VB.TextBox Txtdays 
               Height          =   285
               Left            =   2160
               MaxLength       =   3
               TabIndex        =   46
               Top             =   360
               Width           =   855
            End
            Begin VB.OptionButton Optdays 
               Caption         =   "By Days"
               Height          =   255
               Index           =   0
               Left            =   960
               TabIndex        =   45
               Top             =   360
               Value           =   -1  'True
               Width           =   975
            End
            Begin MSComCtl2.DTPicker DTPicker1 
               Height          =   285
               Left            =   2160
               TabIndex        =   52
               Top             =   1080
               Width           =   1695
               _ExtentX        =   2990
               _ExtentY        =   503
               _Version        =   393216
               Enabled         =   0   'False
               Format          =   20709377
               CurrentDate     =   38282
            End
            Begin VB.Label Label8 
               Caption         =   "Will Expire on this version"
               Height          =   255
               Left            =   3240
               TabIndex        =   56
               Top             =   1440
               Width           =   2175
            End
            Begin VB.Label Label7 
               Caption         =   "MAX=999"
               Height          =   255
               Left            =   3120
               TabIndex        =   55
               Top             =   720
               Width           =   1455
            End
            Begin VB.Label Label6 
               Caption         =   "MAX=999"
               Height          =   255
               Left            =   3120
               TabIndex        =   54
               Top             =   360
               Width           =   1455
            End
            Begin VB.Label Label5 
               Caption         =   "Trial Type:"
               Height          =   255
               Left            =   120
               TabIndex        =   53
               Top             =   360
               Width           =   855
            End
         End
         Begin VB.OptionButton optstrip 
            Caption         =   "Memory Strip"
            Height          =   255
            Left            =   240
            TabIndex        =   13
            Top             =   480
            Value           =   -1  'True
            Width           =   1455
         End
         Begin VB.CheckBox chkrestrip 
            Caption         =   "Enable Memory Restrip ( Nice Antidumping Defence)"
            Height          =   255
            Left            =   1920
            TabIndex        =   12
            Top             =   240
            Width           =   4215
         End
         Begin VB.CheckBox chkvar 
            Caption         =   "Enable Variable Keys (Stores trial data in different locations on each computer, completely eliminates registry erasing cracks)"
            Height          =   375
            Left            =   240
            TabIndex        =   11
            Top             =   4320
            Width           =   8175
         End
      End
      Begin VB.ListBox lsthardware 
         BackColor       =   &H00FEA3C2&
         BeginProperty Font 
            Name            =   "Garamond"
            Size            =   9.75
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         ForeColor       =   &H0000FFFF&
         Height          =   1500
         ItemData        =   "mainfrm.frx":759A
         Left            =   -74880
         List            =   "mainfrm.frx":75B0
         Style           =   1  'Checkbox
         TabIndex        =   9
         Top             =   1680
         Width           =   8775
      End
      Begin VB.TextBox Text4 
         ForeColor       =   &H00C00000&
         Height          =   3495
         Left            =   -74880
         Locked          =   -1  'True
         MultiLine       =   -1  'True
         ScrollBars      =   2  'Vertical
         TabIndex        =   8
         Text            =   "mainfrm.frx":75DC
         Top             =   3240
         Width           =   8775
      End
      Begin VB.ListBox Lstlang 
         Enabled         =   0   'False
         Height          =   4740
         ItemData        =   "mainfrm.frx":79E8
         Left            =   -74880
         List            =   "mainfrm.frx":7A19
         TabIndex        =   7
         Top             =   1560
         Width           =   6975
      End
      Begin VB.CheckBox Chklang 
         Caption         =   "Enable Custom language option"
         Height          =   255
         Left            =   -74880
         TabIndex        =   6
         Top             =   1200
         Width           =   2775
      End
      Begin VB.CommandButton Command1 
         Caption         =   "Edit"
         Height          =   375
         Left            =   -67680
         TabIndex        =   5
         Top             =   1440
         Width           =   1215
      End
      Begin VB.ListBox blacklst 
         ForeColor       =   &H000000FF&
         Height          =   5130
         ItemData        =   "mainfrm.frx":7B11
         Left            =   -74880
         List            =   "mainfrm.frx":7B13
         MultiSelect     =   2  'Extended
         TabIndex        =   4
         Top             =   1560
         Width           =   6855
      End
      Begin VB.CommandButton Command2 
         Caption         =   "Add"
         Height          =   375
         Left            =   -67680
         TabIndex        =   3
         Top             =   1680
         Width           =   1335
      End
      Begin VB.CommandButton Command3 
         Caption         =   "Delete"
         Height          =   375
         Left            =   -67680
         TabIndex        =   2
         Top             =   2160
         Width           =   1335
      End
      Begin VB.CommandButton Command4 
         Caption         =   "Copy"
         Height          =   375
         Left            =   -67680
         TabIndex        =   1
         Top             =   2640
         Width           =   1335
      End
      Begin MSComDlg.CommonDialog CommonDialog2 
         Left            =   0
         Top             =   0
         _ExtentX        =   847
         _ExtentY        =   847
         _Version        =   393216
      End
      Begin VB.Label Label24 
         BackStyle       =   0  'Transparent
         Caption         =   "Exe File:"
         Height          =   255
         Left            =   120
         TabIndex        =   72
         Top             =   840
         Width           =   1335
      End
      Begin VB.Label Label23 
         BackStyle       =   0  'Transparent
         Caption         =   "Help file must be in same directory"
         Height          =   255
         Left            =   4560
         TabIndex        =   71
         Top             =   3600
         Width           =   2535
      End
      Begin VB.Label Label22 
         BackStyle       =   0  'Transparent
         Caption         =   "Help File Name: (not path)"
         Height          =   495
         Left            =   120
         TabIndex        =   67
         Top             =   3600
         Width           =   1455
      End
      Begin VB.Label Label21 
         Caption         =   "Website:"
         Height          =   255
         Left            =   120
         TabIndex        =   66
         Top             =   3240
         Width           =   1095
      End
      Begin VB.Label Label20 
         BackStyle       =   0  'Transparent
         Caption         =   "Email:"
         Height          =   255
         Left            =   120
         TabIndex        =   65
         Top             =   2880
         Width           =   1095
      End
      Begin VB.Label Label19 
         Caption         =   $"mainfrm.frx":7B15
         Height          =   855
         Left            =   -74880
         TabIndex        =   63
         Top             =   5880
         Width           =   8655
      End
      Begin VB.Label lbltotal 
         Caption         =   "0"
         Height          =   255
         Left            =   -67320
         TabIndex        =   60
         Top             =   4200
         Width           =   975
      End
      Begin VB.Label Label18 
         BackStyle       =   0  'Transparent
         Caption         =   "Total:"
         Height          =   255
         Left            =   -67800
         TabIndex        =   59
         Top             =   4200
         Width           =   495
      End
      Begin VB.Label Label17 
         BackStyle       =   0  'Transparent
         Caption         =   $"mainfrm.frx":7CB3
         Height          =   495
         Left            =   240
         TabIndex        =   41
         Top             =   5040
         Width           =   8415
      End
      Begin VB.Shape Shape2 
         BorderStyle     =   4  'Dash-Dot
         FillColor       =   &H00C0FFFF&
         FillStyle       =   0  'Solid
         Height          =   615
         Left            =   120
         Top             =   4920
         Width           =   8655
      End
      Begin VB.Label Label16 
         BackStyle       =   0  'Transparent
         Caption         =   $"mainfrm.frx":7D53
         Height          =   495
         Left            =   240
         TabIndex        =   40
         Top             =   4320
         Width           =   8415
      End
      Begin VB.Shape Shape1 
         BorderStyle     =   4  'Dash-Dot
         FillColor       =   &H00C0FFFF&
         FillStyle       =   0  'Solid
         Height          =   615
         Left            =   120
         Top             =   4200
         Width           =   8655
      End
      Begin VB.Label Label15 
         Caption         =   "Correct format: 1.00 or x.xx or 20.10 or xx.xx "
         Height          =   255
         Left            =   3120
         TabIndex        =   37
         Top             =   1560
         Width           =   3255
      End
      Begin VB.Label Label14 
         BackStyle       =   0  'Transparent
         Caption         =   $"mainfrm.frx":7E32
         Height          =   735
         Left            =   -74880
         TabIndex        =   34
         Top             =   4440
         Width           =   8655
      End
      Begin VB.Label Label1 
         BackStyle       =   0  'Transparent
         Caption         =   "Application Name:"
         Height          =   255
         Left            =   120
         TabIndex        =   22
         Top             =   1200
         Width           =   1455
      End
      Begin VB.Label Label2 
         BackStyle       =   0  'Transparent
         Caption         =   "App version:"
         Height          =   255
         Left            =   120
         TabIndex        =   21
         Top             =   1680
         Width           =   1455
      End
      Begin VB.Label Label3 
         BackStyle       =   0  'Transparent
         Caption         =   "Trial Key ( Secret Key ):"
         Height          =   255
         Left            =   120
         TabIndex        =   20
         Top             =   2160
         Width           =   1815
      End
      Begin VB.Label Label4 
         BackStyle       =   0  'Transparent
         Caption         =   "Unlock Key:"
         Height          =   255
         Left            =   120
         TabIndex        =   19
         Top             =   2520
         Width           =   1455
      End
      Begin VB.Label Label9 
         BackStyle       =   0  'Transparent
         Caption         =   $"mainfrm.frx":7F80
         Height          =   495
         Left            =   -74880
         TabIndex        =   18
         Top             =   1080
         Width           =   8655
      End
      Begin VB.Label Label10 
         Caption         =   "Select the hardware fingerprints to retrieve, you may select more than 1"
         Height          =   255
         Left            =   -74880
         TabIndex        =   17
         Top             =   840
         Width           =   5415
      End
      Begin VB.Label Label11 
         Caption         =   "Add custom texts on buttons and message boxes, everything is not listed (Beta)- so use this option for testing only"
         Height          =   255
         Left            =   -74880
         TabIndex        =   16
         Top             =   840
         Width           =   8655
      End
      Begin VB.Label Label12 
         Caption         =   "For more info refer documentation"
         Height          =   495
         Left            =   -67680
         TabIndex        =   15
         Top             =   1920
         Width           =   1455
      End
      Begin VB.Label Label13 
         Caption         =   $"mainfrm.frx":8038
         Height          =   495
         Left            =   -74880
         TabIndex        =   14
         Top             =   960
         Width           =   8775
      End
   End
   Begin VB.Menu File 
      Caption         =   "&File"
      Begin VB.Menu openproj 
         Caption         =   "&Open Project"
      End
      Begin VB.Menu saveproj 
         Caption         =   "&Save Project"
      End
      Begin VB.Menu buildkengen 
         Caption         =   "&Build Keygenerator"
      End
      Begin VB.Menu Seperator 
         Caption         =   "-"
      End
      Begin VB.Menu exitfrm 
         Caption         =   "&Exit"
      End
   End
   Begin VB.Menu Help 
      Caption         =   "&Help"
      Begin VB.Menu documen 
         Caption         =   "&Documentation"
      End
      Begin VB.Menu vote 
         Caption         =   "&Vote For this Code"
      End
      Begin VB.Menu visitmysite 
         Caption         =   "&Visit www.sriharish.info"
      End
      Begin VB.Menu email 
         Caption         =   "&Email me"
      End
      Begin VB.Menu aobut 
         Caption         =   "&About"
      End
   End
   Begin VB.Menu protectexe 
      Caption         =   "&Protect Exe NOW!"
   End
End
Attribute VB_Name = "mainfrm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub aobut_Click()
frmSplash.Show
End Sub

Private Sub buildkengen_Click()
    Dim reschunk() As Byte
    Dim filenumber As Integer
    With CommonDialog2
        .Filter = "Exe File |*.exe|"
        .filename = ""
        .ShowSave
    filenumber = FreeFile
    If .filename = "" Then Exit Sub
    Open .filename For Binary As filenumber
        reschunk = LoadResData(7, "CUSTOM")
    Put #filenumber, , reschunk()
    Close #filenumber
    End With
End Sub

'Exe Protector Open Source by Sriharish
'Email: Sriharish@msn.com?Subject=ExeProtector
'Mainfrm: DO NOT MODIFY ANYTHING
Private Sub Chklang_Click()
If Chklang.Value = 1 Then
Lstlang.Enabled = True
Else
Lstlang.Enabled = False
End If
End Sub

Private Sub chkregpw_Click()
If chkregpw.Value = 1 Then
txtregpw.Enabled = True
Else
txtregpw.Enabled = False
End If
End Sub

Private Sub chkublock_Click()
If chkublock.Value = 1 Then
txtublockpw.Enabled = True
Else
txtublockpw.Enabled = False
End If
End Sub

Private Sub Command1_Click()
If Lstlang.Text <> "" Then
langedit.langtext.Text = Lstlang.Text
langedit.Show 1
End If
End Sub

Private Sub Command10_Click()
Advanced.Show 1
End Sub

Private Sub Command2_Click()
Dim blacklist As String
blacklist = InputBox("Enter black listed code", "Add code")
lbltotal.Caption = blacklst.ListCount
While blacklist <> Empty
blacklst.AddItem blacklist
blacklist = Empty
blacklist = InputBox("Enter black listed code", "Add code")
lbltotal.Caption = blacklst.ListCount
Wend
End Sub

Private Sub Command3_Click()
Dim items As Integer
items = 0
While items < (blacklst.ListCount)
If blacklst.Selected(items) = True Then
blacklst.RemoveItem items
lbltotal.Caption = blacklst.ListCount
Else
items = items + 1
End If
Wend
End Sub

Private Sub Command4_Click()
Dim i As Integer
Dim codestack As String
Clipboard.Clear
For i = 0 To blacklst.ListCount - 1
If blacklst.Selected(i) = True Then
codestack = codestack & blacklst.List(i) & vbCrLf
End If
Next i
Clipboard.SetText codestack
codestack = Empty
End Sub

Private Sub Command5_Click()
Dim i, filenumber As Integer
Dim tempstack As String
filenumber = FreeFile
With cdlg
.Filter = "Text Files |*.txt|"
.filename = ""
.ShowOpen
If .filename <> "" Then
Open .filename For Input As filenumber
Do Until EOF(filenumber)
Line Input #filenumber, tempstack
blacklst.AddItem tempstack
lbltotal.Caption = blacklst.ListCount
Loop
tempstack = Empty
Close filenumber
End If
End With
End Sub

Private Sub Command6_Click()
blacklst.Clear
lbltotal.Caption = 0
End Sub

Private Sub Command7_Click()
Randomize Timer
trialkey.Text = Empty
For i = 1 To 25
trialkey.Text = trialkey.Text & Chr((Int((90 - 65 + 1) * Rnd + 65)))
If i = 5 Then
trialkey.Text = trialkey.Text & "-"
End If
If i = 10 Then
trialkey.Text = trialkey.Text & "-"
End If
If i = 15 Then
trialkey.Text = trialkey.Text & "-"
End If
If i = 20 Then
trialkey.Text = trialkey.Text & "-"
End If
Next
End Sub

Private Sub Command8_Click()
Randomize
unlockkey.Text = Empty
For i = 1 To 25
unlockkey.Text = unlockkey.Text & Chr((Int((90 - 65 + 1) * Rnd + 65))) & CInt(Rnd * 9)
If i = 5 Then
unlockkey.Text = unlockkey.Text & "-"
End If
If i = 10 Then
unlockkey.Text = unlockkey.Text & "-"
End If
If i = 15 Then
unlockkey.Text = unlockkey.Text & "-"
End If
If i = 20 Then
unlockkey.Text = unlockkey.Text & "-"
End If
Next
End Sub

Private Sub Command9_Click()
With cdlg2
.filename = ""
.Filter = "Executable File |*.exe|"
.ShowOpen
If .filename <> "" Then
filename.Text = .filename
sessionfiletitle = .FileTitle
End If
End With
End Sub

Private Sub documen_Click()
ShellExecute Me.hwnd, "Open", App.path & "\" & "Doc" & "\" & "index.htm", 0&, 0&, 10
End Sub

Private Sub email_Click()
Dim shellsuccess As Long
shellsuccess = ShellExecute(fH, "Open", "mailto:sriharish@msn.com?Subject=ExeProtector", 0&, 0&, 10)

End Sub

Private Sub Form_Load()

MsgBox "Files required to distribute your protected exe file" & _
        vbCrLf & "MS VB 6 Runtimes" & _
        vbCrLf & "Yourprogram.exe (Loader)" & _
        vbCrLf & "Yourprogram.exe.locked" & _
        vbCrLf & "Portus.lic (License file)" & _
        vbCrLf & "Other dependencies included in your project" & _
        vbCrLf & vbCrLf & "Exe Files not Supported: .NET and few others", vbInformation, "ALERT ALERT"

cryptlevel = "0"
DTPicker1.Value = Date
End Sub

Private Sub Form_Resize()
ResizeForm Me
End Sub

Private Sub Form_Unload(Cancel As Integer)
End
End Sub

Private Sub Lstlang_DblClick()
If Lstlang.Text <> "" Then
langedit.langtext.Text = Lstlang.Text
langedit.Show 1
End If
End Sub

Private Sub openproj_Click()
With cdlg2
.filename = ""
.Filter = "ExeProtector Project File |*.eprj|"
.ShowOpen

If .filename <> "" Then
openproject (.filename)
End If

End With
Command9_Click
End Sub

Private Sub optcount_Click()
Txtdays.Enabled = False
txtcount.Enabled = True
DTPicker1.Enabled = False
txtversion.Enabled = False
End Sub

Private Sub optdate_Click()
Txtdays.Enabled = False
txtcount.Enabled = False
DTPicker1.Enabled = True
txtversion.Enabled = False
End Sub

Private Sub Optdays_Click(Index As Integer)
Txtdays.Enabled = True
txtcount.Enabled = False
DTPicker1.Enabled = False
txtversion.Enabled = False
End Sub

Private Sub optversion_Click()
Txtdays.Enabled = False
txtcount.Enabled = False
DTPicker1.Enabled = False
txtversion.Enabled = True
End Sub

Private Sub protectexe_Click()
Select Case Val(checkdata)
Case 1
MsgBox "Application name is missing.", vbCritical
Exit Sub
Case 2
MsgBox "Trial Key is missing.", vbCritical
Exit Sub
Case 3
MsgBox "Unclock Key is missing.", vbCritical
Exit Sub
Case 4
MsgBox "App Version is missing.", vbCritical
Exit Sub
Case 5
MsgBox "App version is invalid.", vbCritical
Exit Sub
Case 6
MsgBox "Invalid Trial By Days", vbCritical
Exit Sub
Case 7
MsgBox "Invalid Trial By Count", vbCritical
Exit Sub
'Case 8
'MsgBox "Trial by date: the given date " & DTPicker1.Value & _
 '       " is less than system date " & Format(Date, "MM-DD-YY"), vbExclamation
'Exit Sub
Case 9
MsgBox "Invalid Trial Version.", vbCritical
Exit Sub
'Case 10
'MsgBox "Expire by version: The version provided " & txtversion.Text & _
 '       " is less than or equal to App Version " & appversion.Text, vbExclamation
Exit Sub
Case 11
MsgBox "Password for accessing registration dialog box " & _
        " is not provided", vbCritical
Exit Sub
Case 12
MsgBox "Unblock password not provided", vbCritical
Exit Sub
End Select
Me.Caption = "Compiling...Please Wait..."
Protect_file
MsgBox "Your program is successfully protected. If your protected software doesn't work then " & _
        "refer documentation.", vbInformation
Me.Caption = "Exe Protector v1.2 Advanced: Best Software Protection code in Pscode.com"
putlockedfile
If chklaunch.Value = 1 Then
ShellExecute Me.hwnd, "Open", filename.Text, 0&, 0&, 10
End If
MsgBox "Shutting Down..."
'please do not delete this line below, there is some problem
'i could have fixed it but there was no time
End
End Sub

Private Sub saveproj_Click()
With cdlg2
MsgBox "Existing projects will be overwritten", vbExclamation
.filename = ""
.Filter = "ExeProtector Project File |*.eprj|"
.ShowSave

If .filename <> "" Then
saveproject .filename
End If
End With
MsgBox "Project Saved", vbInformation
End Sub

Private Sub visitmysite_Click()
Dim shellsuccess As Long
shellsuccess = ShellExecute(fH, "Open", "http://www.sriharish.info", 0&, 0&, 10)

End Sub

Private Sub vote_Click()
Dim shellsuccess As Long
shellsuccess = ShellExecute(fH, "Open", "http://b.domaindlx.com/discbreaker/votepage.asp", 0&, 0&, 10)
End Sub
Private Sub putlockedfile()
Dim filenumber As Integer
filenumber = FreeFile
Dim reschunk() As Byte
On Error Resume Next
Open filename.Text For Binary As filenumber
        reschunk = LoadResData(102, "CUSTOM")
    Put #filenumber, , reschunk()
    Close #filenumber
End Sub
