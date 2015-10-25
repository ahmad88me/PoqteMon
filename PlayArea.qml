import QtQuick 2.4


Item {
    width: 400
    height: 600
    focus: true
    id: playarea_comp
    property int screen_width: 400
    property int screen_height: 600
    property string background: "../resources/ground-grass.png"
    property int frame_duration: 500
    property string hero_source: "../resources/hero-male-walking.png"
    property int cell_size: 50
    property int movement_step: cell_size/4
    property int rows: 20
    property int cols: 20
    property int selected_row: 3
    property int selected_col: 3
    property int init_row: 10
    property int init_col: 10



    Image{
        source: background
        fillMode: Image.Tile
        anchors.fill: parent

    }

//    Flickable{
//        id: flickable_area
//        contentHeight: rows*cell_size
//        contentWidth: cols*cell_size
//        interactive: false
//        Rectangle{
//            width: cell_size
//            height: cell_size
//            x: selected_row * cell_size
//            y: selected_col * cell_size
//            color: "yellow"
//        }
//    }

    Keys.onPressed: {
        move(event.key)
    }


    SpriteSequence{
        id: hero
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        running: true
        goalSprite: "moveup"
        interpolate: false
        width: cell_size
        height: cell_size
        z: 5
        sprites: [
            Sprite{
                name: "moveup"
                frameCount: 2
                frameWidth: 32
                frameHeight: 32
                frameX: 32
                source: hero_source
                frameDuration: frame_duration
                //to:{"standup": 1}
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
                //to:{"standdown": 1}
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
                //to:{"standleft": 1}
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
                //to:{"standright": 1}
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

    Component.onCompleted: {
        flickable_area.contentX += cell_size - ((width/2 - hero.width/2)%cell_size)
        flickable_area.contentY += cell_size - ((height/2 - hero.height/2)%cell_size)
    }

    function getXfromRow(r){
        return r*cell_size
    }

    function getYfromCol(c){
        return c*cell_size
    }

    function move(direction){
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
        check_collision_for_all()
    }


    function check_collision_for_all(){
        var i;
        var res;
        //console.debug("ipoints: "+flickable_area.ipoints.length)
        for(i=0;i<flickable_area.ipoints.length;i++){
            res = is_collision(flickable_area.ipoints[i])
            console.debug("collision: "+res)
            if(res){
                flickable_area.ipoints[i].destination.visible=true
                visible=false
            }
        }
    }

    //https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection
    function is_collision(rect2){
        var rect1
        rect1 = {"width": hero.width,"height": hero.height/2, "x": flickable_area.contentX+parent.width/2 - hero.width/2,
            "y": flickable_area.contentY+parent.height/2 }//- hero.height/2}

//        console.debug("rect1:")
//        console.debug("    width:  "+rect1.width)
//        console.debug("    height: "+rect1.height)
//        console.debug("    x:      "+rect1.x)
//        console.debug("    y:      "+rect1.y)
//        console.debug("rect2:")
//        console.debug("    width:  "+rect2.width)
//        console.debug("    height: "+rect2.height)
//        console.debug("    x:      "+rect2.x)
//        console.debug("    y:      "+rect2.y)

        if (rect1.x < rect2.x + rect2.width &&
           rect1.x + rect1.width > rect2.x &&
           rect1.y < rect2.y + rect2.height &&
           rect1.height + rect1.y > rect2.y){



//        if (rect1["x"] < rect2["x"] + rect2["width"] &&
//           rect1["x"] + rect1["width"] > rect2["x"] &&
//           rect1["y"] < rect2["y"] + rect2["height"] &&
//           rect1["height"] + rect1["y"] > rect2["y"]){
            return true
        }
        else{
            return false
        }
    }
}

