import QtQuick 2.4
import QtQuick.Window 2.2
import "qrc:/gomponents"

Window {
    visible: true
    width: 400
    height: 600
    id: main
    //property var current_page: interior_medical_center_1

//    World1{
//        id: world_1
//        anchors.fill: parent
//        visible: false
//    }


//    InteriorMedicalCenter{
//        id: interior_medical_center_1
//        anchors.fill: parent
//        visible: false
//    }

//    Timer{
//        id: t
//        running: true
//        repeat: false
//        interval: 1000
//        onTriggered: {
//            //switch_to_page(current_page)
//        }
//    }

    LevelParser{
        id: level_parser
        anchors.fill: parent
    }


    function close_all(){
        world_1.visible=false
        interior_medical_center_1.visible=false
    }

    function switch_to_page(page){
        close_all()
        page.visible=true
        page.focus=true
        current_page = page
    }

//    Rectangle{
//        z: 1
//        color: "yellow"
//        width: parent.width/4
//        height: width
//        y: parent.height - height*2
//        //anchors.bottom: parent.bottom
//        opacity: 0.3
//        MouseArea{
//            anchors.fill: parent
//            onClicked:{
//                current_page.move(Qt.Key_Left)
//            }
//        }
//    }
//    Rectangle{
//        z: 1
//        color: "blue"
//        width: parent.width/4
//        height: width
//        x: width
//        anchors.bottom: parent.bottom
//        opacity: 0.3
//        MouseArea{
//            anchors.fill: parent
//            onClicked:{
//                current_page.move(Qt.Key_Up)
//            }
//        }
//    }
//    Rectangle{
//        z: 1
//        color: "red"
//        width: parent.width/4
//        height: width
//        x: width*2
//        anchors.bottom: parent.bottom
//        opacity: 0.3
//        MouseArea{
//            anchors.fill: parent
//            onClicked:{
//                current_page.move(Qt.Key_Down)
//            }
//        }
//    }
//    Rectangle{
//        z: 1
//        color: "yellow"
//        width: parent.width/4
//        height: width
//        x: width*3
//        y: parent.height - height*2

//        opacity: 0.3
//        MouseArea{
//            anchors.fill: parent
//            onClicked:{
//                current_page.move(Qt.Key_Right)
//            }
//        }
//    }
}
