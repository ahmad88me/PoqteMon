import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.2
import FileIO 1.0


Rectangle {
    width: 400
    height: 600

    property int cell_size: 50
    property string file_name: ""
    property alias flickable_area: flickable_area3
    property int rows: 1
    property int cols: 1
    property var level_data

    Text{
        id: tt
        text: ""
        font.bold: true
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        z: 15
    }

    Component.onCompleted: {
        tt.text = level_data["name"]
        console.debug("borders: "+level_data["bpoints"].length)
        handle_borders(level_data["bpoints"])
        handle_bimages(level_data["bimages"])
        //handle_bimages(level_data["bimages"])
        //handle_images(level_data["images"])
    }

//    Component.onCompleted: {
//        txt=my_file.read()
//        console.debug(txt)
//        parse(txt)
//    }

    PlayArea2{
        id: playarea
        anchors.fill: parent
        flickable_area: flickable_area3
        Flickable{
            id: flickable_area3
            focus: true
            anchors.fill: parent
            interactive: false
            contentHeight: rows * cell_size
            contentWidth: cols * cell_size

            Rectangle{
                id: level_overview
                color: "yellow"
                anchors.fill: parent
                //opacity: 0.5
            }
        }
    }

    function parse(txt){
        var j = JSON.parse(txt)
        console.debug(j["name"])
        console.debug(j["rows"]+", "+j["cols"])
        flickable_area3.contentHeight = cell_size * j["rows"]
        flickable_area3.contentWidth = cell_size * j["cols"]
        levels.push(j)
        //handle_borders(j["bpoints"])
        //handle_images(j["images"])
        //handle_bimages(j["bimages"])
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

    function handle_bimages(bimages){
        var i
        var image_component = Qt.createComponent("Limage.qml")
        var border_component = Qt.createComponent("Border.qml")
        for(i=0;i<bimages.length;i++){
            image_component.createObject(level_overview,{
                                              source: "../resources/"+bimages[i].name,
                                              width: cell_size*bimages[i].img_width,
                                              height: cell_size*bimages[i].img_height,
                                              x: cell_size*bimages[i].img_x,
                                              y: cell_size*bimages[i].img_y,
                                              z: bimages[i].img_z,
                                              fillMode: bimages[i].tile ? Image.Tile: Image.Stretch
                                          })
            border_component.createObject(level_overview,{
                                              width: cell_size*bimages[i].width,
                                              height: cell_size*bimages[i].height,
                                              x: cell_size*bimages[i].x,
                                              y: cell_size*bimages[i].y,
                                              z: 10
                                          })
            playarea.bpoints.push({
                                      width: cell_size*bimages[i].width,
                                      height: cell_size*bimages[i].height,
                                      x: cell_size*bimages[i].x,
                                      y: cell_size*bimages[i].y,
                                  })
        }
    }
}

