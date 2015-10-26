import QtQuick 2.4


PlayArea {
    background: "../resources/pokemon_center_floor.png"
    width: 600 * 1.2
    height: 600
    bpoints: [get_bpoint(pokemon_center_table1), get_bpoint(interior_medical_center_right_1),
                get_bpoint(interior_medical_center_left_1), get_bpoint(interior_medical_center_top_1),
                get_bpoint(interior_medical_center_bottom_1)]
    ipoints: [get_ipoints(interior_medical_center_exit_1,world_1)]
    init_col: 6
    init_row: 6
    fixed_init_pos: true
    flickable_area: flickable_area2
    Flickable{
        id: flickable_area2
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        contentHeight: cell_size * 8
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
        Rectangle{
            id: interior_medical_center_right_1
            width: 4
            height: parent.height
            anchors.right: parent.right
            color: "yellow"
        }
        Rectangle{
            id: interior_medical_center_left_1
            width: interior_medical_center_right_1.width
            height: interior_medical_center_right_1.height
            anchors.left: parent.left
            color: "yellow"
        }
        Rectangle{
            id: interior_medical_center_top_1
            width: parent.width
            height: 4
            anchors.top: parent.top
            color: "yellow"
        }
        Rectangle{
            id: interior_medical_center_bottom_1
            width: interior_medical_center_top_1.width
            height: interior_medical_center_top_1.height
            anchors.bottom: parent.bottom
            color: "yellow"
        }
    }

    onVisibleChanged: {
        if(visible){
            var num
            num = flickable_area.height/getXfromRow(1)
            //console.debug("num: "+num)
        }
    }

}

