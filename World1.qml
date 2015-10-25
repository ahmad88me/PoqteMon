import QtQuick 2.4
import "qrc:/gomponents"

PlayArea{
    Flickable{
        id: flickable_area
        contentHeight: getXfromRow(20)
        contentWidth: getYfromCol(20)
        property var ipoints : [mc.ipoint]
        property var bpoints: [mc.bpoint]
        MedicalCenter{
            id: mc
            x: 165
            y: 135
            width: 100//getXfromRow(2)
            height: 100//getYfromCol(2)
        }
    }
}

