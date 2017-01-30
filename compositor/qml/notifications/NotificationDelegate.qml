/****************************************************************************
 * This file is part of Liri.
 *
 * Copyright (C) 2017 Pier Luigi Fiorini
 *
 * Author(s):
 *    Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * $BEGIN_LICENSE:GPL3+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

import QtQuick 2.0
import QtQuick.Controls.Material 2.0
import Fluid.Core 1.0
import Fluid.Controls 1.0
import Fluid.Material 1.0
import "../components" as ShellComponents

Item {
    signal expired()
    signal closed()
    signal actionInvoked(string actionId)

    id: notification
    objectName: "notificationWindow"
    width: Units.gu(24)
    height: notificationItem.implicitHeight

    Material.theme: Material.Dark
    Material.primary: Material.Blue
    Material.accent: Material.Blue

    Behavior on height {
        NumberAnimation {
            easing.type: Easing.OutQuad
            duration: Units.longDuration
        }
    }

    Behavior on opacity {
        NumberAnimation {
            easing.type: Easing.OutSine
            duration: Units.longDuration
        }
    }

    Timer {
        id: timer
        interval: model.expireTimeout
        running: !model.isPersistent
        onTriggered: {
            if (!model.isPersistent) {
                timer.running = false
                notification.expired()
            }
        }
    }

    ShellComponents.CloseButton {
        anchors {
            top: parent.top
            right: parent.right
            topMargin: -Units.smallSpacing * 1.5
            rightMargin: -Units.smallSpacing * 1.5
        }
        z: 1
        onClicked: notification.closed()
    }

    Rectangle {
        id: bubble

        anchors.fill: parent

        layer.enabled: true
        layer.effect: ElevationEffect {
            elevation: 8
        }

        color: Material.dialogColor
        border.width: 1
        border.color: Utils.alpha(Qt.darker(Material.drawerBackgroundColor, 1.2), 0.5)
        radius: 6
        antialiasing: true
        z: 0

        Behavior on opacity {
            NumberAnimation {
                easing.type: Easing.OutSine
                duration: Units.longDuration
            }
        }

        NotificationItem {
            id: notificationItem
            anchors {
                fill: parent
                margins: Units.smallSpacing
            }
            summary: model.summary
            body: model.body
            hasIcon: model.hasIcon
            icon: "image://notifications/%1/%2".arg(model.id).arg(Date.now() / 1000 | 0)
            actions: model.actions
            onActionInvoked: notification.actionInvoked(actionId)
        }
    }

    // Do not capture click events, just change opacity when the pointer
    // is moved. This will make stuff underneath visible and clickable
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        hoverEnabled: true
        onEntered: bubble.opacity = 0.5
        onExited: bubble.opacity = 1.0
    }
}