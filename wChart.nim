##
## This control allows you to show responsive charts of numerical data.
##
## **It requires mCtrl.dll or (64bit mCtrl.dll renamed to) mCtrlx64.dll**.
##
## **Also requires GDIPLUS.DLL version 1.0 or newer to work correctly (available since Windows 2000 with some Service Packs or updates installed)**.
##
#
## :Appearance:
##    .. image:: ./wChart.png
##
#
## :Licence:
## mCtrl.dll/mCtrlx64.dll is covered by the GNU Lesser General Public License 2.1 or (if you choose so) any later version.
#
## :Superclass:
##    `wControl <https://khchen.github.io/wNim/wControl.html>`_
##
#

{.experimental, deadCodeElim: on.}

from wNim/private/winimx import NMHDR
import wNim/private/wBase
import wNim/private/controls/wControl
export wControl

type
    wChart* = ref object of wControl
  
const
  MC_CHS_PIE* = 0x00000000
  MC_CHS_SCATTER* = 0x00000001
  MC_CHS_LINE* = 0x00000002
  MC_CHS_STACKEDLINE* = 0x00000003
  MC_CHS_AREA* = 0x00000004
  MC_CHS_STACKEDAREA* = 0x00000005
  MC_CHS_COLUMN* = 0x00000006
  MC_CHS_STACKEDCOLUMN* = 0x00000007
  MC_CHS_BAR* = 0x00000008
  MC_CHS_STACKEDBAR* = 0x00000009
  MC_CHS_TYPEMASK* = 0x0000003F
  MC_CHS_NOTOOLTIPS* = 0x00000040
  MC_CHS_DOUBLEBUFFER* = 0x00000080
  
const
  MC_CHM_FIRST* = (WM_USER+0x4000 + 600)
  MC_CHM_GETDATASETCOUNT* = (MC_CHM_FIRST + 0)
  MC_CHM_DELETEALLDATASETS* = (MC_CHM_FIRST + 1)
  MC_CHM_INSERTDATASET* = (MC_CHM_FIRST + 2)
  MC_CHM_DELETEDATASET* = (MC_CHM_FIRST + 3)
  MC_CHM_GETDATASET* = (MC_CHM_FIRST + 4)
  MC_CHM_SETDATASET* = (MC_CHM_FIRST + 5)
  MC_CHM_GETDATASETCOLOR* = (MC_CHM_FIRST + 6)
  MC_CHM_SETDATASETCOLOR* = (MC_CHM_FIRST + 7)
  MC_CHM_GETDATASETLEGENDW* = (MC_CHM_FIRST + 8)
  MC_CHM_GETDATASETLEGENDA* = (MC_CHM_FIRST + 9)
  MC_CHM_SETDATASETLEGENDW* = (MC_CHM_FIRST + 10)
  MC_CHM_SETDATASETLEGENDA* = (MC_CHM_FIRST + 11)
  MC_CHM_GETFACTOREXPONENT* = (MC_CHM_FIRST + 12)
  MC_CHM_SETFACTOREXPONENT* = (MC_CHM_FIRST + 13)
  MC_CHM_GETAXISOFFSET* = (MC_CHM_FIRST + 14)
  MC_CHM_SETAXISOFFSET* = (MC_CHM_FIRST + 15)
  MC_CHM_SETTOOLTIPS* = (MC_CHM_FIRST + 16)
  MC_CHM_GETTOOLTIPS* = (MC_CHM_FIRST + 17)
  MC_CHM_GETAXISLEGENDW* = (MC_CHM_FIRST + 18)
  MC_CHM_GETAXISLEGENDA* = (MC_CHM_FIRST + 19)
  MC_CHM_SETAXISLEGENDW* = (MC_CHM_FIRST + 20)
  MC_CHM_SETAXISLEGENDA* = (MC_CHM_FIRST + 21)

type
  MC_CHDATASET* {.bycopy.} = object
    dwCount*: DWORD
    piValues*: ptr UncheckedArray[int]
  
  MC_NMCHDISPINFO* {.bycopy.} = object
    hdr*: NMHDR
    fMask*: DWORD
    iDataSet*: cint
    iValueFirst*: cint
    iValueLast*: cint
    piValues*: ptr cint


var dataset: MC_CHDATASET

const
  MC_CHN_FIRST* = (0x40000000 + 500)       
  MC_CHN_GETDISPINFO* = (MC_CHN_FIRST + 0)

proc getDataSetCount*(self:wChart):int = 
  ## get the count of datasets
  result = cast[int](SendMessage(self.mHwnd, MC_CHM_GETDATASETCOUNT, 0, 0))

proc deleteAllDataSets*(self:wChart):bool {.discardable.} =
  ## delete all the datasets
  result = cast[bool](SendMessage(self.mHwnd, MC_CHM_DELETEALLDATASETS, 0, 0))

proc insertDataSet*(self:wChart, index:int, data:openArray[int]):int {.discardable.} =
  ## inserts a new dataset at specified index
  var arr = cast[ptr UncheckedArray[int]](data)
  dataset.dwCount = ((len(data)) * sizeof(int)) div sizeof(int)
  dataset.piValues = arr
  result = cast[int](SendMessage(self.mHwnd, MC_CHM_INSERTDATASET, index,  &dataset))

proc deleteDataSet*(self:wChart, index:int):bool {.discardable.} =
  ## delete dataset at index
  result = cast[bool](SendMessage(self.mHwnd, MC_CHM_DELETEDATASET, index,  0))

proc getDataSet*(self:wChart, index:int):seq[int] {.discardable.} =
  ## get dataset at index
  var count = cast[int](SendMessage(self.mHwnd, MC_CHM_GETDATASET, index, nil))
  var d = newSeq[int](count-1) # need to create an empty seq the size of the dataset 
  var data:MC_CHDATASET
  var arr = cast[ptr UncheckedArray[int]](d)
  data.dwCount = count
  data.piValues = arr
  SendMessage(self.mHwnd, MC_CHM_GETDATASET, index, &data)
  var a:seq[int] # result = seq to populate
  for i in 0 .. count-1:
    a.add(data.piValues[][i])
  result = a

proc setDataSet*(self:wChart, index:int, data:openArray[int]):bool {.discardable.} =
  ## replaces the dataset of an already defined index
  var arr = cast[ptr UncheckedArray[int]](data)
  dataset.dwCount = ((len(data)) * sizeof(int)) div sizeof(int)
  dataset.piValues = arr
  result = cast[bool](SendMessage(self.mHwnd, MC_CHM_SETDATASET, index,  &dataset))

proc getDataSetColor*(self:wChart, index:int):COLORREF = 
  ## gets the color of dataset at index
  ## only works when color has been previously set
  result = cast[COLORREF](SendMessage(self.mHwnd, MC_CHM_GETDATASETCOLOR, index, 0))

proc setDataSetColor*(self:wChart, index: int, color:COLORREF):bool {.discardable.}=
  ## set the dataset color at index, accepts wColor
  result = cast[bool](SendMessage(self.mHwnd, MC_CHM_SETDATASETCOLOR, index, color))

proc getDataSetLegend*(self:wChart, index:int, len:int = 500):string =
  ## get the dataset legend text for specified index.
  ## default max character length is 500, this can be set optionally
  ## longer text is turncated
  var param = MAKELPARAM(index, len)
  when winimUnicode:
    var buffer = newWString(len)
    SendMessage(self.mHwnd, MC_CHM_GETDATASETLEGENDW, param, &buffer)
  elif winimAnsi:
    var buffer = newString(len)
    SendMessage(self.mHwnd, MC_CHM_GETDATASETLEGENDA, param, &buffer)
  var s:string
  for i, c in buffer:
    if ord(c) > 0:
      s = s & chr(c)
  result = s

proc setDataSetLegend*(self:wChart, index:int, text:string):bool {.discardable.} =
  ## set the dataset legend for given index
  when winimUnicode:
    result = cast[bool](SendMessage(self.mHwnd, MC_CHM_SETDATASETLEGENDW, index, &T(text)))
  elif winimAnsi:
    result = cast[bool](SendMessage(self.mHwnd, MC_CHM_SETDATASETLEGENDA, index, &T(text)))

proc getFactorExponentX*(self:wChart):int = 
  ## get the factor exponant for the X axis
  result = cast[int](SendMessage(self.mHwnd, MC_CHM_GETFACTOREXPONENT, 1, 0))

proc getFactorExponentY*(self:wChart):int = 
  ## get the factor exponant for the Y axis
  result = cast[int](SendMessage(self.mHwnd, MC_CHM_GETFACTOREXPONENT, 2, 0))

proc setFactorExponentX*(self:wChart, exponent:int):bool {.discardable.}= 
  ## set the factor exponant for the X axis
  result = cast[bool](SendMessage(self.mHwnd, MC_CHM_SETFACTOREXPONENT, 1, exponent))

proc setFactorExponentY*(self:wChart, exponent:int):bool {.discardable.} = 
  ## set the factor exponant for the Y axis
  result = cast[bool](SendMessage(self.mHwnd, MC_CHM_SETFACTOREXPONENT, 2, exponent))

proc getAxisOffsetX*(self:wChart):int =
  # get X axis offset
  result = cast[int](SendMessage(self.mHwnd, MC_CHM_GETAXISOFFSET, 1, 0))

proc getAxisOffsetY*(self:wChart):int =
  ## get Y axis offset
  result = cast[int](SendMessage(self.mHwnd, MC_CHM_GETAXISOFFSET, 2, 0))

proc setAxisOffsetX*(self:wChart, offset:int):bool {.discardable.} =
  ## set X axis offset 
  result = cast[bool](SendMessage(self.mHwnd, MC_CHM_SETAXISOFFSET, 1, offset))

proc setAxisOffsetY*(self:wChart, offset:int):bool {.discardable.} =
  ## set Y axis offset 
  result = cast[bool](SendMessage(self.mHwnd, MC_CHM_SETAXISOFFSET, 2, offset))

proc setToolTips*(self:wChart, handle:HWND):HWND {.discardable.} =
  ## assigns a window for tooltip with chart control
  result = cast[HWND](SendMessage(self.mHwnd, MC_CHM_SETTOOLTIPS, handle, 0))

proc getToolTips*(self:wChart):HWND =
  ## Get tooltip associated with the control
  result = cast[HWND](SendMessage(self.mHwnd, MC_CHM_GETTOOLTIPS, 0, 0))

proc getAxisLegendX*(self:wChart, len:int = 500):string =
  ## get the X axis legend text
  var param = MAKELPARAM(1, len)
  when winimUnicode:
    var buffer = newWString(len)
    SendMessage(self.mHwnd, MC_CHM_GETAXISLEGENDW, param, &buffer)
  elif winimAnsi:
    var buffer = newString(len)
    SendMessage(self.mHwnd, MC_CHM_GETAXISLEGENDA, param, &buffer)
  var s:string
  for i, c in buffer:
    if ord(c) > 0:
      s = s & chr(c)
  result = s

proc getAxisLegendY*(self:wChart, len:int = 500):string =
  ## get the Y axis legend text
  var param = MAKELPARAM(2, len)
  when winimUnicode:
    var buffer = newWString(len)
    SendMessage(self.mHwnd, MC_CHM_GETAXISLEGENDW, param, &buffer)
  elif winimAnsi:
    var buffer = newString(len)
    SendMessage(self.mHwnd, MC_CHM_GETAXISLEGENDA, param, &buffer)
  var s:string
  for i, c in buffer:
    if ord(c) > 0:
      s = s & chr(c)
  result = s

proc setAxisLegendX*(self:wChart, text:string):bool {.discardable.} =
  ## set X axis legend text
  when winimUnicode:
    result = cast[bool](SendMessage(self.mHwnd, MC_CHM_SETAXISLEGENDW, 1, &T(text)))
  elif winimAnsi:
    result = cast[bool](SendMessage(self.mHwnd, MC_CHM_SETAXISLEGENDA, 1, &T(text)))

proc setAxisLegendY*(self:wChart, text:string):bool {.discardable.} =
  ## set Y axis legend text
  when winimUnicode:
    result = cast[bool](SendMessage(self.mHwnd, MC_CHM_SETAXISLEGENDW, 2, &T(text)))
  elif winimAnsi:
    result = cast[bool](SendMessage(self.mHwnd, MC_CHM_SETAXISLEGENDA, 2, &T(text)))

proc plot*(self:wChart, name:string, data: openArray[int], color:varargs[COLORREF]) =
  ## convinience procedure to set name, dataset and color.
  var i:int = self.getDataSetCount()
  self.insertDataSet(i, data)
  self.setDataSetLegend(i, name)
  if len(color)>0:
    self.setDataSetColor(i, color[0])
  
when defined(cpu64):
  proc mcChart_Initialize*(self:wChart) {.cdecl, dynlib: "mCtrlx64.dll", importc: "mcChart_Initialize".}
  proc mcChart_Terminate*(self:wChart) {.cdecl, dynlib: "mCtrlx64.dll", importc: "mcChart_Terminate".}
else:
  proc mcChart_Initialize*(self:wChart) {.cdecl, dynlib: "mCtrl.dll", importc: "mcChart_Initialize".}
  proc mcChart_Terminate*(self:wChart) {.cdecl, dynlib: "mCtrl.dll", importc: "mcChart_Terminate".}

#[
proc wChart_OnNotify(self:wChart, event: wEvent) =
  var hdr = cast[NMHDR](event.lparam)
  if hdr.hwndFrom == self.mHwnd:
    if hdr.code == MC_CHN_GETDISPINFO:
      discard
      #var info = cast[MC_NMCHDISPINFO](event.lparam)
      #echo repr(info)
  ]#

proc final*(self:wChart) =
  ## Default finalizer for wChart.
  self.mcChart_Terminate()
  self.delete()
  
proc init*(self:wChart, parent: wWindow, id=wDefaultID, pos=wDefaultPoint, size=wDefaultSize, style=WS_CHILD or WS_VISIBLE or WS_TABSTOP) {.validate.} =
  ## Initializer.
  wValidate(parent)

  self.mcChart_Initialize()

  self.wControl.init(className="mCtrl.chart", parent=parent, id=id, pos=pos, size=size, style=style)

#[
  parent.hardConnect(WM_NOTIFY) do (event: wEvent):
    wChart_onNotify(self, event)
]#

proc Chart*(parent: wWindow, id=wDefaultID, pos=wDefaultPoint, size=wDefaultSize, style=WS_CHILD or WS_VISIBLE or WS_TABSTOP ): wChart {.inline, discardable.} =
  ## Constructor, creating and showing a chart control.
  wValidate(parent)
  new(result, final)
  result.init(parent, id, pos, size, style)