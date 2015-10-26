import QtQuick 2.4


PlayArea {
    background: "../resources/pokemon_center_floor.png"
    //background: "pokemon_center_floor.png"
    width: 600 * 1.2
    height: 600
    bpoints: [get_bpoint(pokemon_center_table1)]
    ipoints: [get_ipoints(interior_medical_center_exit_1,world_1)]
    //init_col: getXfromRow(1) * width/cell_size
    //init_row: height/cell_size
    Flickable{
        id: flickable_area
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        contentHeight: cell_size * 11
        contentWidth: cell_size * 13
        Image{
            source: "../resources/pokemon_center_floor.png"
            anchors.fill: parent
            fillMode: Image.Tile
        }
        PokemonCenterTable{
            id: pokemon_center_table1
            height: getXfromRow(4)
            width: getYfromCol(5)
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Rectangle{
            id: interior_medical_center_exit_1
            width: getXfromRow(2)
            height: getYfromCol(1)
            color:"#FF4444"
            opacity: 0.5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
        }

    }

    onVisibleChanged: {
        if(visible){
            console.debug("init_row: "+init_row)

            var num
            console.debug("row1: "+getXfromRow(1))
            num = flickable_area.height/getXfromRow(1)
            console.debug("num: "+num)
            //flickable_area.contentHeight = getXfromRow(Math.floor(num))
            //flickable_area.contentWidth =  getYfromCol(Math.floor(num)) * 1.2
            //adjust_flickable_to_hero()
        }
    }

}

