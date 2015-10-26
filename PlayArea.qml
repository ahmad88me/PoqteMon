import QtQuick 2.4


Rectangle {
    width: 400
    height: 600
    focus: true
    id: playarea_comp
    color:"black"
    property int screen_width: 400
    property int screen_height: 600
    property string background: "../resources/ground-grass.png"
    property int frame_duration: 500
    property string hero_source: "../resources/hero-male-walking.png"
    property int cell_size: 50
    property int movement_step: cell_size/4
    property real init_row: 0
    property real init_col: 0
    property var ipoints : []//[mc.ipoint]
    property var bpoints: []//[mc.bpoint]


//    Image{
//        source: background
//        fillMode: Image.Tile
//        anchors.fill: parent
//    }

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

//    Component.onCompleted: {
//        adjust_flickable_to_hero()
//    }

    onVisibleChanged: {
        if(visible){
            console.debug("me playarea")
            //flickable_area.contentX = 0
            //flickable_area.contentY = 0
            adjust_flickable_to_hero()
        }
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

    }


    function getXfromRow(r){
        return r*cell_size
    }

    function getYfromCol(c){
        return c*cell_size
    }

    function move(direction){
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
            console.debug("PlayArea: collision ")
            flickable_area.contentX = old_x
            flickable_area.contentY = old_y
        }
    }

    function check_collision_for_all(){
        var i;
        var res;
        for(i=0;i<ipoints.length;i++){
            res = is_collision(ipoints[i])
            console.debug("collision: "+res)
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
        //rect1 = {"width": hero.width,"height": hero.height/2, "x": flickable_area.contentX+parent.width/2 - hero.width/2,
       //     "y": flickable_area.contentY+parent.height/2 }//- hero.height/2}//just lower half do collide
        rect1 = {"width": hero.width/2,"height": hero.height/2, "x": flickable_area.contentX+parent.width/2 - hero.width/4,
            "y": flickable_area.contentY+parent.height/2 }// only half the character (horizontally) do collide

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
            return true
        }
        else{
            return false
        }
    }

    function append_ipoints(ipoints_v){
        var i
        for(i=0;i<ipoints_v.length;i++){
            ipoints.push(ipoints_v[i])
        }
    }
    function append_bpoints(bpoints_v){
        var i
        for(i=0;i<bpoints_v.length;i++){
            bpoints.push(bpoints_v[i])
        }
    }

    function get_bpoint(comp){
        return {"width": comp.width, "height": comp.height,
                "x": comp.x, "y": comp.y}
    }

    function get_ipoints(comp, dis){
        return {"width": comp.width, "height": comp.height,
                "x": comp.x, "y": comp.y, "destination": dis}
    }
}

