import QtQuick 2.4
import "qrc:/gomponents"


PlayArea{
    width: 400
    height: 600
    init_col: 4
    init_row: 9
    flickable_area: flickable_area1
    Flickable{
        id: flickable_area1
        contentHeight: getXfromRow(10)
        contentWidth: getYfromCol(10)
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Image{
            source: "../resources/ground-grass.png"
            anchors.fill: parent
            fillMode: Image.Tile
        }

        MedicalCenter{
            id: mc
            x: getXfromRow(4)
            y: getYfromCol(4)
            width: 100
            height: 100
        }
        Component.onCompleted: {
            //width=getXfromRow(2)
            //height=getYfromCol(2)
            append_ipoints(mc.ipoints)
            append_bpoints(mc.bpoints)
        }
    }
}

