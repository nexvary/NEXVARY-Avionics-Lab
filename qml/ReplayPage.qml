import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Theme.js" as Theme
Item {
    ColumnLayout { anchors.fill:parent; anchors.margins:18; spacing:14
        RowLayout { Layout.fillWidth:true
            Text { text:cockpit.text("replay"); color:Theme.gold; font.pixelSize:24; font.bold:true; Layout.fillWidth:true }
            Text { text:cockpit.replayIndex+" / "+cockpit.replayMaximum; color:Theme.cyan }
            MinisterialButton { text:cockpit.replayMode?cockpit.text("exit_replay"):cockpit.text("enter_replay"); onClicked:cockpit.setReplayMode(!cockpit.replayMode) }
        }
        Slider { Layout.fillWidth:true; from:0; to:Math.max(1,cockpit.replayMaximum); value:cockpit.replayIndex; enabled:cockpit.replayMode; onMoved:cockpit.seekReplay(Math.round(value)) }
        GridLayout { Layout.fillWidth:true; Layout.fillHeight:true; columns:4; columnSpacing:10; rowSpacing:10
            Repeater { model:cockpit.tiles; delegate:InstrumentTile { Layout.fillWidth:true; Layout.fillHeight:true; tileLabel:modelData.label; tileValue:modelData.value; tileState:modelData.state } }
        }
    }
}
