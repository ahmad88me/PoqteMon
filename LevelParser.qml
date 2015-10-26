import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.2
import FileIO 1.0


Rectangle {
    width: 100
    height: 62

    property int cell_size: 50
    property var levels: []

    FileIO{
        id: my_file
        source: ":level1.txt"
        onError: console.log("error in fileio")
    }

//    Button{
//        text:"read"
//        width: parent.width
//        z:1
//        onClicked:{
//            var txt=my_file.read()
//            console.debug(txt)
//            parse(txt)
//        }
//    }

    Component.onCompleted: {
        var txt
        var i
        for(i=1;i<=2;i++){
            my_file.read()
            console.debug(txt)
            parse(txt)
        }
    }

    PlayArea2{
        id: playarea
        anchors.fill: parent
        flickable_area: flickable_area3
        Flickable{
            id: flickable_area3
            focus: true
            anchors.fill: parent
            interactive: false
            Rectangle{
                id: level_overview
                color: "yellow"
                anchors.fill: parent
                opacity: 0.5
            }
        }
    }

    function parse(txt){
        var j = JSON.parse(txt)
        console.debug(j["name"])
        console.debug(j["rows"]+", "+j["cols"])
        flickable_area3.contentHeight = cell_size * j["rows"]
        flickable_area3.contentWidth = cell_size * j["cols"]
        handle_borders(j["bpoints"])
        handle_images(j["images"])
        //level_overview.children.push("")
        //var c = Qt.createComponent("Limage.qml")
        //var i = c.createObject(level_overview)
        //c = Qt.createComponent("Border.qml")
        //c.createObject(level_overview)
    }


    function handle_borders(borders){
        var i
        var border_component = Qt.createComponent("Border.qml")
        for(i=0;i<borders.length;i++){
            border_component.createObject(level_overview,{
                                              width: cell_size*borders[i].width,
                                              height: cell_size*borders[i].height,
                                              x: cell_size*borders[i].x,
                                              y: cell_size*borders[i].y,
                                              z: 10
                                          })
            playarea.bpoints.push({
                                      width: cell_size*borders[i].width,
                                      height: cell_size*borders[i].height,
                                      x: cell_size*borders[i].x,
                                      y: cell_size*borders[i].y,
                                  })
        }//forloop

    }

    function handle_images(images){
        var i
        var image_component = Qt.createComponent("Limage.qml")
        for(i=0;i<images.length;i++){
            image_component.createObject(level_overview,{
                                              source: "../resources/"+images[i].name,
                                              width: cell_size*images[i].width,
                                              height: cell_size*images[i].height,
                                              x: cell_size*images[i].x,
                                              y: cell_size*images[i].y,
                                              z: images[i].z,
                                              fillMode: images[i].tile ? Image.Tile: Image.Stretch
                                          })
        }
    }
}

