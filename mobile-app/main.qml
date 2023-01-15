import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

import com.company.fileupload 1.0

Window {
    id: mainWindow
    width: 360
    height: 520
    visible: true
    title: qsTr("Dominant Color!")

    CaptureSession {
        id: captureSession
        videoOutput: output
        camera: Camera {}
        imageCapture: ImageCapture {
            onImageSaved: function (requestId, path) {
                console.log("Image saved", requestId, path)
            }
        }
    }

    Rectangle{
        width: mainWindow.width
        height: mainWindow.height - (captureButton.height*2)
        color: "black"

        VideoOutput {
            id: output
            anchors.fill: parent
            fillMode: VideoOutput.Stretch
        }

        Image {
            id: previewImage
            visible: checkBox.checked
            anchors.fill : parent
            source: captureSession.imageCapture.preview
            fillMode: Image.Stretch
            smooth: true
        }
    }

    FileUpload {
        id: uploader
        onComplete: {
            httpResponse.text = "Status: " + status + "\n" + reply
            progressBar.visible = false
            closeButton.enabled = true
        }
    }

    ColumnLayout {
        y: output.height
        RowLayout {
            Button {
                width: mainWindow.width / 2 - 10
                text: "Get dominant color"
                onClicked: {
                    uploader.postFile(
                                "http://192.168.1." + ipAddress.text + ":5000/upload",
                                "/storage/emulated/0/Android/data/org.qtproject.example.appSMVIT_project/files/lol.jpg",
                                "form-data; name=\"the_file\"; filename=\"lol.jpg\"")
                    popup.open()
                }
            }

            TextField {
                id: ipAddress
                width: mainWindow.width / 2 - 10
                validator: IntValidator {
                    bottom: 1
                    top: 999
                }
            }
        }
        RowLayout {
            Button {
                id: captureButton
                Layout.preferredWidth: mainWindow.width / 2 - 10
                text: "Capture"
                visible: captureSession.imageCapture.readyForCapture
                onClicked: captureSession.imageCapture.captureToFile(
                               "/storage/emulated/0/Android/data/org.qtproject.example.appSMVIT_project/files/lol.jpg")
            }

            CheckBox {
                id: checkBox
                Layout.preferredWidth: mainWindow.width / 2
                text: qsTr("Preview")
            }
        }
    }

    Popup {
        id: popup
        x: (mainWindow.width - width) / 2
        y: (mainWindow.height - height) / 2
        width: mainWindow.width / 1.5
        height: mainWindow.height / 2
        modal: true
        focus: true
        closePolicy: Popup.NoAutoClose

        ColumnLayout {
            Text {
                id: httpResponse
                font.pointSize: 20
                text: qsTr("Processing")
            }

            ProgressBar {
                id: progressBar
                visible: true
                indeterminate: true
                //anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                id: closeButton
                enabled: false
                text: "Close"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    popup.close()
                }
            }
        }
    }
}
