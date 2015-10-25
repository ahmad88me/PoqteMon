import QtQuick 2.5
import QtQuick.Window 2.2
import "qrc:/gomponents"

Window {
    visible: true
    width: 400
    height: 600

    World1{
        anchors.fill: parent
        visible: false
    }

    Rectangle{
        id: ddd
        anchors.fill: parent
        visible: false
        color:"red"
        width: 1000
        height: 1000
        MouseArea{
            anchors.fill: parent
            onClicked: {
                parent.visible=false
            }
        }
    }

}
