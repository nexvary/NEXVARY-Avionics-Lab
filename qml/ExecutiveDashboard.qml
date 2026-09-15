import QtQuick
import QtQuick.Controls

Item {
    id: page
    clip: true

    function openRoute(routeId, targetPage, workspace, groupId) {
        var app = ApplicationWindow.window
        if (app && app.navigateRoute)
            app.navigateRoute(routeId, targetPage, workspace, groupId)
    }

    AirForceOperationsCenter {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: assurance.top
        anchors.bottomMargin: 8
    }

    CommandExecutiveAssurancePanel {
        id: assurance
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 142
        onRouteRequested: function(routeId, targetPage, workspace, groupId) {
            page.openRoute(routeId, targetPage, workspace, groupId)
        }
    }
}
