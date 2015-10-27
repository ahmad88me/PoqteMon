import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.2
import FileIO 1.0


Rectangle {
    width: 100
    height: 62
    id: level_parser

    property int cell_size: 50
    property var levels: []
    property var current_game_level: null


    FileIO{
        id: my_file
        source: ":level2.txt"
        onError: console.log("error in fileio")
    }

    Component.onCompleted: {
        var txt
        var i
        var fname=":level"
        for(i=1;i<=2;i++){
            my_file.source=fname+i+".txt"
            txt=my_file.read()
            console.debug(txt)
            parse(txt)
        }
        prepare_game_level(levels[1])
    }

    function parse(txt){
        var j = JSON.parse(txt)
        console.debug(j["name"])
        console.debug(j["rows"]+", "+j["cols"])
        //flickable_area3.contentHeight = cell_size * j["rows"]
        //flickable_area3.contentWidth = cell_size * j["cols"]
        levels.push(j)
        //handle_borders(j["bpoints"])
        //handle_images(j["images"])
        //handle_bimages(j["bimages"])
    }

    function prepare_game_level(j){
        //var game_level_component = Qt.createComponent("GameLevel.qml")
        var game_level_component = Qt.createComponent("PlayArea3.qml")
        current_game_level = game_level_component.createObject(level_parser,
                                                               {
                                                                "rows": j["rows"],
                                                                "cols": j["cols"],
                                                                "init_row": j["init_row"],
                                                                "init_col": j["init_col"],
                                                                "focus": true,
                                                                "width": width,
                                                                "height": height,
                                                                //"level_data": j
                                                                 "playarea_data": j
                                                               })
    }

    function switch_area(name, init_row, init_col){
        var i
        console.debug("switching to: "+name)
        for(i=0;i<levels.length;i++){
            if(levels[i].name==name){
                console.debug("will switch to: "+levels[i].name)
                current_game_level.destroy()
                levels[i].init_row = init_row
                levels[i].init_col = init_col
                prepare_game_level(levels[i])
            }
        }
    }





}
