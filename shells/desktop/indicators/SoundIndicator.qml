/****************************************************************************
 * This file is part of Hawaii.
 *
 * Copyright (C) 2012-2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * Author(s):
 *    Pier Luigi Fiorini
 *
 * $BEGIN_LICENSE:GPL2+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
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
import QtQuick.Layouts 1.0
import Hawaii.Controls 1.0 as Controls
import Hawaii.Themes 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.hawaii.mixer 0.1 as MixerService
import ".."
import "sound" as SoundIndicator

Indicator {
    name: "sound"
    iconName: {
        if (MixerService.Mixer.muted || MixerService.Mixer.master == 0)
            return "audio-volume-muted-symbolic";
        if (MixerService.Mixer.master < 50)
            return "audio-volume-low-symbolic";
        if (MixerService.Mixer.master < 75)
            return "audio-volume-medium-symbolic";
        return "audio-volume-high-symbolic";
    }
    component: Component {
        ColumnLayout {
            spacing: units.largeSpacing

            Controls.Heading {
                text: qsTr("Sound")
                color: Theme.palette.panel.textColor
            }

            SoundIndicator.VolumeControl {
                Layout.fillWidth: true
            }

            SoundIndicator.MprisItem {
                id: mpris

                Layout.fillWidth: true
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }
    // TODO: When a volume item will be available -> Or with mpris and volume item
    //visible: mpris.visible
    visible: MixerService.Mixer.available

    Connections {
        target: compositorRoot
        onKeyPressed: {
            switch (event.key) {
            case Qt.Key_VolumeUp:
                MixerService.Mixer.increaseMaster();
                event.accepted = true;
                break;
            case Qt.Key_VolumeDown:
                MixerService.Mixer.decreaseMaster();
                event.accepted = true;
                break;
            case Qt.Key_VolumeMute:
                MixerService.Mixer.muted = !MixerService.Mixer.muted;
                event.accepted = true;
                break;
            default:
                event.accepted = false;
                break;
            }
        }
    }
}
