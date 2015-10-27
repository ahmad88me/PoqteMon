import QtQuick 2.4


Rectangle {
    width: 400
    height: 600
    focus: true
    id: playarea_comp
    color:"black"
    property string background: "../resources/ground-grass.png"
    property int frame_duration: 250
    property string hero_source: "../resources/hero-male-walking.png"
    property int cell_size: 50
    property int movement_step: cell_size/4
    property real init_row: 0
    property real init_col: 0
    property var ipoints : []//[mc.ipoint]
    property var bpoints: []//[mc.bpoint]
    property var last_pos: {"x": 0, "y": 0}
    property bool fixed_init_pos: false
    //property var flickable_area
    property int rows: 1
    property int cols: 1
    property var playarea_data

    Text{
        id: playarea_name
        text: ""
        font.bold: true
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        z: 15
    }

    Keys.onPressed: {
        move(event.key)
    }

    SpriteSequence{
        id: hero
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        running: true
        goalSprite: "no"
        interpolate: false
        width: cell_size
        height: cell_size
        z: 1
        sprites: [
            Sprite{
                name: "moveup"
                frameCount: 2
                frameWidth: 32
                frameHeight: 32
                frameX: 32
                source: hero_source
                frameDuration: frame_duration
                to:{"standup": 1}
            },
            Sprite{
                name: "movedown"
                frameCount: 2
                frameWidth: 32
                frameHeight: 32
                frameY: 32
                frameX: 32
                source: hero_source
                frameDuration: frame_duration
                to:{"standdown": 1}
            },
            Sprite{
                name: "moveleft"
                frameCount: 2
                frameWidth: 32
                frameHeight: 32
                frameY: 64
                frameX: 32
                source: hero_source
                frameDuration: frame_duration
                to:{"standleft": 1}
            },
            Sprite{
                name: "moveright"
                frameCount: 2
                frameWidth: 32
                frameHeight: 32
                frameY: 96
                frameX: 32
                source: hero_source
                frameDuration: frame_duration
                to:{"standright": 1}
            },
            Sprite{
                name: "standup"
                frameCount: 1
                frameWidth: 32
                frameHeight: 32
                frameX: 0
                source: hero_source
                frameDuration: frame_duration
            },
            Sprite{
                name: "standdown"
                frameCount: 1
                frameWidth: 32
                frameHeight: 32
                frameY: 32
                frameX: 0
                source: hero_source
                frameDuration: frame_duration
            },
            Sprite{
                name: "standleft"
                frameCount: 1
                frameWidth: 32
                frameHeight: 32
                frameY: 64
                frameX: 0
                source: hero_source
                frameDuration: frame_duration
            },
            Sprite{
                name: "standright"
                frameCount: 1
                frameWidth: 32
                frameHeight: 32
                frameY: 96
                frameX: 0
                source: hero_source
                frameDuration: frame_duration
            }
        ]
    }

    Rectangle{
        color: "red"
        width: hero.width
        height: hero.height
        x: hero.x
        y: hero.y
        z:4
        opacity: 0.1
    }

    Flickable{
        id: flickable_area
        anchors.fill: parent
        contentHeight: rows * cell_size
        contentWidth: cols * cell_size

        Rectangle{
            id: level_overview
            color: "yellow"
            anchors.fill: parent
            //opacity: 0.5
        }
    }

    Component.onCompleted: {
        //adjust_flickable_to_hero()
        depict_objects()
    }

    function depict_objects(){
        playarea_name.text = playarea_data["name"]
        console.debug("borders: "+playarea_data["bpoints"].length)
        handle_borders(playarea_data["bpoints"])
        handle_bimages(playarea_data["bimages"])
    }

    function adjust_flickable_to_hero(){

        flickable_area.interactive= false
        flickable_area.contentX = 0
        flickable_area.contentY = 0
        flickable_area.contentX -= (Math.floor(flickable_area.width/2/cell_size)-1) * cell_size
        flickable_area.contentY -= (Math.floor(flickable_area.height/2/cell_size)-1) * cell_size
        flickable_area.contentX += cell_size * init_col
        flickable_area.contentY += cell_size * init_row
        flickable_area.contentX -= cell_size - ((width/2 - hero.width/2)%cell_size)
        flickable_area.contentY -= cell_size - ((height/2 - hero.height/2)%cell_size)
        if(!fixed_init_pos){
            if(last_pos.x==0 && last_pos.y==0){
                last_pos.x = flickable_area.contentX
                last_pos.y = flickable_area.contentY
            }
            else{
                flickable_area.contentX = last_pos.x
                flickable_area.contentY = last_pos.y
            }
        }

    }

    function getXfromRow(r){
        return r*cell_size
    }

    function getYfromCol(c){
        return c*cell_size
    }

    function move(direction){
        last_pos.x=flickable_area.contentX
        last_pos.y=flickable_area.contentY
        var old_x = flickable_area.contentX
        var old_y = flickable_area.contentY
        switch(direction){
            case Qt.Key_Right:
                hero.jumpTo("moveright")
                flickable_area.contentX+=movement_step
                break
            case Qt.Key_Left:
                hero.jumpTo("moveleft")
                flickable_area.contentX-=movement_step
                break
            case Qt.Key_Up:
                hero.jumpTo("moveup")
                flickable_area.contentY-=movement_step
                break
            case Qt.Key_Down:
                hero.jumpTo("movedown")
                flickable_area.contentY+=movement_step
                break
        }
        if(check_collision_for_all()){
            if(!fixed_init_pos){
                if(last_pos.x > flickable_area.contentX){
                    last_pos.x +=cell_size
                }
                else{
                    last_pos.x -=cell_size
                }
                if(last_pos.y > flickable_area.contentY){
                    last_pos +=cell_size
                }
                else{
                    last_pos -=cell_size
                }
            }

            flickable_area.contentX = old_x
            flickable_area.contentY = old_y
        }
    }

    function check_collision_for_all(){
        var i;
        var res;
        for(i=0;i<ipoints.length;i++){
            res = is_collision(ipoints[i])
            //console.debug("collision: "+res)
            if(res){
                console.debug("will make some activities")
                main.switch_to_page(ipoints[i].destination)
                return false

            }
        }
        for(i=0;i<bpoints.length;i++){
            res = is_collision(bpoints[i])
            if(res){
                console.debug("block collision")
                return true
            }
        }
        return false
    }

    //https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection
    function is_collision(rect2){
        var rect1
        rect1 = {"width": hero.width/2,"height": hero.height/2, "x": flickable_area.contentX+parent.width/2 - hero.width/4,
            "y": flickable_area.contentY+parent.height/2 }// only half the character (horizontally) do collide
        if (rect1.x < rect2.x + rect2.width &&
           rect1.x + rect1.width > rect2.x &&
           rect1.y < rect2.y + rect2.height &&
           rect1.height + rect1.y > rect2.y){
            return true
        }
        else{
            return false
        }
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
            bpoints.push({
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
            bpoints.push({
                                      width: cell_size*bimages[i].width,
                                      height: cell_size*bimages[i].height,
                                      x: cell_size*bimages[i].x,
                                      y: cell_size*bimages[i].y,
                                  })
        }
    }

//    function append_ipoints(ipoints_v){
//        var i
//        for(i=0;i<ipoints_v.length;i++){
//            ipoints.push(ipoints_v[i])
//        }
//    }
//    function append_bpoints(bpoints_v){
//        var i
//        for(i=0;i<bpoints_v.length;i++){
//            bpoints.push(bpoints_v[i])
//        }
//    }

//    function get_bpoint(comp){
//        return {"width": comp.width, "height": comp.height,
//                "x": comp.x, "y": comp.y}
//    }

//    function get_ipoints(comp, dis){
//        return {"width": comp.width, "height": comp.height,
//                "x": comp.x, "y": comp.y, "destination": dis}
//    }
}

