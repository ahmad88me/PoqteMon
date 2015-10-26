import QtQuick 2.4

Item {
    width: 200
    height: 200
    property var ipoints: [{"width": thi.width, "height": thi.height,
                          "x": thi.x+x, "y": thi.y+y, "destination": interior_medical_center_1}]
    property var bpoints: [{"width": width, "height": height, "x": x, "y":y }]

    Image{
        anchors.fill: parent
        source: "../resources/medical_center.png"
        //source: "medical_center.png"
    }

    Rectangle{
    //Item{
        id: thi
        x: parent.width * 68/200
        y: 100
        height: parent.height/8
        width: parent.width * 5/200
        anchors.bottom: parent.bottom
        color: "blue"
        anchors.bottomMargin: 0
    }


}

