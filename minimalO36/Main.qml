import QtQuick 2.15
import SddmComponents 2.0

Rectangle {  // backdrop
    id: root
    width: 1920
    height: 1080
    color: "#1e1b2e"
    property int currentSession: sessionModel.lastIndex

    Connections {
        target: sddm
        function onLoginFailed() {
            waitAnimation.stop()
            passwordInput.text = ""
            passwordInput.forceActiveFocus()
            failAnimation.start()
        }
    }

    Rectangle {     // outer field
        id: borderGlow
        width:708
        height: 72
        radius: 35
        anchors.centerIn:parent

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#33ccff" }
            GradientStop { position: 1.0; color: "#00ff99" }
        }

        Rectangle {    // inner field
            id: inputField
            width: 700
            height: 70
            radius: 35
            color: "#2d2b42"
            anchors.centerIn: parent
            border.width: 2
            border.color: "#2d2b42"
    
            SequentialAnimation {
                id: failAnimation
                ColorAnimation {
                    target: inputField
                    property: "border.color"
                    to: "#ff0000"
                    duration: 50
                }
    
                PauseAnimation { duration: 300 }
    
                ColorAnimation {
                    target: inputField
                    property: "border.color"
                    to: "#2d2b42"
                    duration: 100
                }
            }

            // username
            TextInput {
                id: usernameInput
                anchors.centerIn: parent
                width: parent.width -40
                color: "#e2e0ef"
                font.pixelSize: 28
                font.letterSpacing: 8
                horizontalAlignment: TextInput.AlignHCenter
                focus: true
                opacity: 1.0

                Keys.onReturnPressed: {
                    if (usernameInput.text.length > 0) {
                        toPasswordAnimation.start()
                    }
                }
            }


            TextInput {
                id: passwordInput
                anchors.centerIn: parent
                width: parent.width - 40
                color: "#e2e0ef"
                font.pixelSize: 28
                font.letterSpacing: 8
                echoMode: TextInput.Password
                passwordCharacter: "*"
                horizontalAlignment: TextInput.AlignHCenter
                opacity: 0.0
                enabled: false

                onEnabledChanged: {
                    if (enabled) forceActiveFocus()
                }

                Keys.onReturnPressed: {
                    sddm.login(usernameInput.text, passwordInput.text, currentSession)
                    waitAnimation.start()
                }

                Keys.onEscapePressed: {
                    passwordInput.text = ""
                    toUsernameAnimation.start()
                }
            }
        }
    }

    // username > password transition
    SequentialAnimation {
        id: toPasswordAnimation
        NumberAnimation {
            target: usernameInput
            property: "opacity"
            to: 0.0
            duration: 200
        }
        ScriptAction {
            script: {
                usernameInput.enabled = false
                passwordInput.enabled = true
                passwordInput.forceActiveFocus()
            }
        }
        NumberAnimation {
            target: passwordInput
            property: "opacity"
            to: 1.0
            duration: 200
        }
    }

    // password > username transition
    SequentialAnimation {
        id: toUsernameAnimation
        NumberAnimation {
            target: passwordInput
            property: "opacity"
            to: 0.0
            duration: 200
        }
        ScriptAction {
            script: {
                passwordInput.enabled = false
                usernameInput.enabled = true
                usernameInput.forceActiveFocus()
            }
        }
        NumberAnimation {
            target: usernameInput
            property: "opacity"
            to: 1.0
            duration: 200
        }
    }

    SequentialAnimation {
        id: waitAnimation
        loops: Animation.Infinite
        ColorAnimation {
            target: inputField
            property: "border.color"
            to: "#7dcfff"
            duration: 300
        }
        ColorAnimation {
            target: inputField
            property: "border.color"
            to: "#2d2b42"
            duration: 500
        }
    }

        Text {  // debug
            anchors.top: parent.top
            anchors.left: parent.left
            color: "#ffffff"
            font.pixelSize: 14
            text: "idx: " + currentSession + " count: " + sessionModel.rowCount()
        }

    // session selector
    Row {
        id: sessionSelector
        z: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        spacing: 12

        Text {
            text: "<"
            color: "#33ccff"
            font.pixelSize: 16
            font.family: "JetBrainsMono Nerd Font"
            anchors.verticalCenter: parent.verticalCenter
    
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    currentSession = (currentSession - 1 + sessionModel.rowCount()) % sessionModel.rowCount()
                    usernameInput.forceActiveFocus()
                    inputField.border.color = "#ff0000"
                }
            }
        }
    
        Text {
            id: sessionLabel
            text: sessionModel.data(sessionModel.index(currentSession, 0), 258) || "NO-SESSION"  // 258=full path, 260=name only
            color: "#e2e0ef"
            font.pixelSize: 16
            font.family: "JetBrainsMono Nerd Font"
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: ">"
            color: "#00ff99"
            font.pixelSize: 16
            font.family: "JetBrainsMono Nerd Font"
            anchors.verticalCenter: parent.verticalCenter
    
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    currentSession = (currentSession + 1) % sessionModel.rowCount()
                    usernameInput.forceActiveFocus()
                    inputField.border.color = "#00ff00"
                }
            }
        }
    }
}
