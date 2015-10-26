import QtQuick 2.4
import QtQuick.Window 2.2
import "qrc:/gomponents"

Window {
    visible: true
    width: 400
    height: 600
    id: main

    World1{
        id: world_1
        anchors.fill: parent
        visible: false
    }


    InteriorMedicalCenter{
        id: interior_medical_center_1
        anchors.fill: parent
        visible: false
    }

    Timer{
        id: t
        running: true
        repeat: false
        interval: 1000
        onTriggered: {
            world_1.visible=true
        }
    }


    function close_all(){
        world_1.visible=false
        interior_medical_center_1.visible=false
    }

    function switch_to_page(page){
        close_all()
        page.visible=true
        page.focus=true
    }


}
