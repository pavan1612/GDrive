import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:file_picker/file_picker.dart';

class SpeedDialWidget extends StatefulWidget {
  final _drive;
  Function callback;
  SpeedDialWidget(this._drive, this.callback);

  @override
  _SpeedDialWidgetState createState() => _SpeedDialWidgetState();
}

class _SpeedDialWidgetState extends State<SpeedDialWidget> {
  final _controller = TextEditingController();
  var folderName = '';
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      child: Icon(Icons.add_circle),
      children: [
        SpeedDialChild(
            label: 'Upload here',
            child: Icon(Icons.cloud_upload),
            onTap: () async {
              var file = await FilePicker.getFile();
              await widget._drive.upload(file);
              widget.callback();
            }),
        SpeedDialChild(
            label: 'Create folder here',
            child: Icon(Icons.create_new_folder),
            onTap: () => showModalBottomSheet(
                context: context,
                builder: (context) {
                  return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                    labelText: 'Folder Name here'),
                                onChanged: (value) {
                                  setState(() {
                                    folderName = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: FlatButton(
                                onPressed: () async {
                                  await widget._drive.createFolder(folderName);
                                  setState(() {
                                    _controller.clear();
                                    folderName = '';
                                  });
                                  widget.callback();
                                  Navigator.pop(context);
                                },
                                child: Text('Create folder')),
                          ),
                        ],
                      ));
                }))
      ],
    );
  }
}
