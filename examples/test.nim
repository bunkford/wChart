import wNim/[wApp, wFrame, wPanel, wMenuBar]
import ../wChart
import random

type
  # A menu ID in wNim is type of wCommandID (distinct int) or any enum type.
  MenuID = enum
    idAdd = wIdUser, idExit

let app = App()
#let tooltip = Frame(title="tooltip", size=(100,100))

let frame = Frame(title="wChart", size=(900, 900))
frame.setMinSize(size=(600, 600))

var menuBar = MenuBar(frame)
var menuFile = Menu(menuBar, "&File")
menuFile.append(idAdd, "Add Random Data", "Add data to chart.")
menuFile.appendSeparator()
menuFile.append(idExit, "E&xit", "Exit the program.")

let panel = Panel(frame)

let chart1 = Chart(panel, pos=(0,0), size=(300, 200), style=MC_CHS_PIE or MC_CHS_DOUBLEBUFFER)
chart1.plot("Work", [8], wBlue)
chart1.plot("Eat", [2], wBrown)
chart1.plot("Commute", [2], wYellowGreen)
chart1.plot("Watch TV", [2], wYellow)
chart1.plot("Sleep", [7], wRed)

let chart2 = Chart(panel, pos=(0,0), size=(300, 200), style=MC_CHS_SCATTER or MC_CHS_DOUBLEBUFFER)
chart2.setAxisLegendX("Height [cm]")
chart2.setAxisLegendY("Weight [kg]")
chart2.plot("Males", [185, 97, 169, 70, 182, 83, 191, 102, 174, 87, 163, 98, 201, 98, 76, 55, 44, 2, 10, 12],wBrown)
chart2.plot("Females", [110, 56, 144, 70, 112, 83, 151, 99, 117, 87, 120, 98, 122, 98, 130, 55, 86, 2, 11, 11, 0, 0])

let chart3 = Chart(panel, pos=(0,0), size=(300, 200), style=MC_CHS_LINE or MC_CHS_DOUBLEBUFFER)
chart3.setAxisLegendX("Year")
chart3.setAxisLegendY("Amount [Tons]")
chart3.setAxisOffsetX(2003)
chart3.plot("Austria",  @[1336060, 1538156, 1576579, 1600652, 1968113])
chart3.plot("Denmark",  @[1001582, 1119450,  993360, 1004163,  979198])
chart3.plot("Greece",  @[1197974, 1041795,  930593,  867127,  780887])

let chart4 = Chart(panel, pos=(0,0), size=(300, 200), style=MC_CHS_STACKEDLINE or MC_CHS_DOUBLEBUFFER)
chart4.setAxisLegendX("Year")
chart4.setAxisLegendY("Amount [Tons]")
chart4.setAxisOffsetX(2003)
chart4.plot("Austria",  [1336060, 1538156, 1576579, 1600652, 1968113])
chart4.plot("Denmark",  [1001582, 1119450,  993360, 1004163,  979198])
chart4.plot("Greece",  [1197974, 1041795,  930593,  867127,  780887])

let chart5 = Chart(panel, pos=(0,0), size=(300, 200), style=MC_CHS_AREA)
chart5.setAxisLegendX("Year")
chart5.setAxisLegendY("Amount [Tons]")
chart5.setAxisOffsetX(2003)
chart5.plot("Austria",  [1336060, 1538156, 1576579, 1600652, 1968113])
chart5.plot("Denmark",  [1001582, 1119450,  993360, 1004163,  979198])
chart5.plot("Greece",  [1197974, 1041795,  930593,  867127,  780887])

let chart6 = Chart(panel, pos=(0,0), size=(300, 200), style=MC_CHS_STACKEDAREA or MC_CHS_DOUBLEBUFFER)
chart6.setAxisLegendX("Year")
chart6.setAxisLegendY("Amount [Tons]")
chart6.setAxisOffsetX(2003)
chart6.plot("Austria",  [1336060, 1538156, 1576579, 1600652, 1968113])
chart6.plot("Denmark",  [1001582, 1119450,  993360, 1004163,  979198])
chart6.plot("Greece",  [1197974, 1041795,  930593,  867127,  780887])

let chart7 = Chart(panel, pos=(0,0), size=(300, 200), style=MC_CHS_COLUMN or MC_CHS_DOUBLEBUFFER)
chart7.setAxisLegendX("Year")
chart7.setAxisLegendY("Amount [Tons]")
chart7.setAxisOffsetX(2003)
chart7.plot("Austria",  [1336060, 1538156, 1576579, 1600652, 1968113])
chart7.plot("Denmark",  [1001582, 1119450,  993360, 1004163,  979198])
chart7.plot("Greece",  [1197974, 1041795,  930593,  867127,  780887])

let chart8 = Chart(panel, pos=(0,0), size=(300, 200), style=MC_CHS_BAR or MC_CHS_DOUBLEBUFFER)
chart8.setAxisLegendX("Year")
chart8.setAxisLegendY("Amount [Tons]")
chart8.setAxisOffsetX(2003)
chart8.plot("Austria",  [1336060, 1538156, 1576579, 1600652, 1968113])
chart8.plot("Denmark",  [1001582, 1119450,  993360, 1004163,  979198])
chart8.plot("Greece",  [1197974, 1041795,  930593,  867127,  780887])

let chart9 = Chart(panel, pos=(0,0), size=(300, 200), style=MC_CHS_BAR or MC_CHS_DOUBLEBUFFER)
chart9.setAxisLegendX("Year")
chart9.setAxisLegendY("Amount [Tons]")
chart9.setAxisOffsetX(2003)
chart9.plot("Austria",  [1336060, 1538156, 1576579, 1600652, 1968113])
chart9.plot("Denmark",  [1001582, 1119450,  993360, 1004163,  979198])
chart9.plot("Greece",  [1197974, 1041795,  930593,  867127,  780887])

let chart10 = Chart(panel, pos=(0,0), size=(300, 200), style=MC_CHS_STACKEDBAR or MC_CHS_DOUBLEBUFFER)
chart10.setAxisLegendX("Year")
chart10.setAxisLegendY("Amount [Tons]")
chart10.setAxisOffsetX(2003)
chart10.plot("Austria",  [1336060, 1538156, 1576579, 1600652, 1968113], wRed)
chart10.plot("Denmark",  [1001582, 1119450,  993360, 1004163,  979198], wBlue)
chart10.plot("Greece",  [1197974, 1041795,  930593,  867127,  780887], wGreen)

proc layout() =
  panel.layout:
    chart1:
      chart1.left = panel.innerLeft
      chart1.top = panel.innerTop
      chart1.height = panel.height / 4
      chart1.width = panel.width / 3
    chart2:
      chart2.left = chart1.right
      chart2.top = panel.innerTop
      chart2.height = panel.height / 4
      chart2.width = panel.width / 3
    chart3:
      chart3.left = chart2.right
      chart3.top = panel.innerTop
      chart3.height = panel.height / 4
      chart3.width = panel.width / 3

    chart4:
      chart4.left = panel.innerLeft
      chart4.top = chart1.bottom
      chart4.height = panel.height / 4
      chart4.width = panel.width / 3
    chart5:
      chart5.left = chart4.right
      chart5.top = chart1.bottom
      chart5.height = panel.height / 4
      chart5.width = panel.width / 3
    chart6:
      chart6.left = chart5.right
      chart6.top = chart1.bottom
      chart6.height = panel.height / 4
      chart6.width = panel.width / 3 

    chart7:
      chart7.left = panel.innerLeft
      chart7.top = chart4.bottom
      chart7.height = panel.height / 4
      chart7.width = panel.width / 3
    chart8:
      chart8.left = chart7.right
      chart8.top = chart4.bottom
      chart8.height = panel.height / 4
      chart8.width = panel.width / 3
    chart9:
      chart9.left = chart8.right
      chart9.top = chart4.bottom
      chart9.height = panel.height / 4
      chart9.width = panel.width / 3 
    
    chart10:
      chart10.left = panel.innerLeft
      chart10.top = chart7.bottom
      chart10.height = panel.height / 4
      chart10.width = panel.width  

frame.wEvent_Size do (event: wEvent):
  layout()       

frame.idAdd do (event:wEvent):
  var count = chart10.getDataSetCount()
  chart1.plot("Extra Data " & $(count+1),  [rand(20)])
  chart2.plot("Extra Data " & $(count+1),  [rand(110), rand(110), rand(110), rand(110), rand(110), rand(110), rand(110), rand(110), rand(110), rand(110), rand(110), rand(110), rand(110), rand(110)])
  chart3.plot("Extra Data " & $(count+1),  [rand(119450), rand(119450),  rand(119450), rand(119450),  rand(119450)])
  chart4.plot("Extra Data " & $(count+1),  [rand(119450), rand(119450),  rand(119450), rand(119450),  rand(119450)])
  chart5.plot("Extra Data " & $(count+1),  [rand(119450), rand(119450),  rand(119450), rand(119450),  rand(119450)])
  chart6.plot("Extra Data " & $(count+1),  [rand(119450), rand(119450),  rand(119450), rand(119450),  rand(119450)])
  chart7.plot("Extra Data " & $(count+1),  [rand(119450), rand(119450),  rand(119450), rand(119450),  rand(119450)])
  chart8.plot("Extra Data " & $(count+1),  [rand(119450), rand(119450),  rand(119450), rand(119450),  rand(119450)])
  chart9.plot("Extra Data " & $(count+1),  [rand(119450), rand(119450),  rand(119450), rand(119450),  rand(119450)])
  chart10.plot("Extra Data " & $(count+1),  [rand(119450), rand(119450),  rand(119450), rand(119450),  rand(119450)])
  
frame.idExit do (event:wEvent):
  frame.delete

frame.center()
frame.show()
app.mainLoop()