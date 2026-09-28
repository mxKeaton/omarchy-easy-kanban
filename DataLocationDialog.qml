// Data location dialog for Easy Kanban.
// NOTE: This plugin is a user-owned clone; `omarchy plugin update` will overwrite this file.
import QtQuick
import qs.Commons
import qs.Ui

Item {
  id: root

  property bool opened
  property string currentPath
  property string draft
  property string error

  signal submitted(string path)
  signal reverted()
  signal canceled()

  visible: opened
  focus: opened
  z: 20

  onOpenedChanged: {
    if (opened) {
      draft = currentPath
      pathField.text = currentPath
      error = ""
      Qt.callLater(function() { pathField.forceActiveFocus() })
    }
  }

  function submit() {
    root.submitted(root.draft)
  }

  function eatEsc(event) {
    if (event.key !== Qt.Key_Escape) return
    root.canceled()
    event.accepted = true
  }

  Keys.onPressed: function(event) { root.eatEsc(event) }

  Rectangle {
    anchors.fill: parent
    color: Util.alpha(Color.background, 0.7)
    MouseArea {
      anchors.fill: parent
      onClicked: root.canceled()
    }
  }

  BorderSurface {
    width: Math.min(parent.width - Style.space(32), Style.space(420))
    height: body.implicitHeight + Style.space(28)
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: Style.space(20)
    color: Color.background
    borderSpec: Border.flat(Color.accent, Style.normalBorderWidth)
    radius: Style.cornerRadius

    MouseArea {
      anchors.fill: parent
      onClicked: {}
    }

    Column {
      id: body
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.margins: Style.space(14)
      spacing: Style.space(10)

      Text {
        text: "Data location"
        color: Color.foreground
        font.family: Style.font.family
        font.pixelSize: Style.font.body
      }

      Text {
        width: parent.width
        text: "Folder or full file path for easy-kanban.json"
        color: Color.muted
        font.family: Style.font.family
        font.pixelSize: Style.font.caption
        wrapMode: Text.WordWrap
      }

      TextField {
        id: pathField
        width: parent.width
        placeholderText: "/path/to/folder"
        text: root.draft
        onTextEdited: {
          root.draft = text
          root.error = ""
        }
        onAccepted: root.submit()
        Keys.onPressed: function(event) { root.eatEsc(event) }
      }

      Text {
        width: parent.width
        visible: root.error !== ""
        text: root.error
        color: Color.urgent
        font.family: Style.font.family
        font.pixelSize: Style.font.caption
        wrapMode: Text.WordWrap
      }

      Row {
        spacing: Style.space(8)
        anchors.right: parent.right

        Button {
          text: "Cancel"
          onClicked: root.canceled()
        }

        Button {
          text: "Revert to default"
          onClicked: root.reverted()
        }

        Button {
          text: "Save"
          onClicked: root.submit()
        }
      }
    }
  }
}
