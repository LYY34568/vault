import 'package:flutter/material.dart';
import 'vault.dart';

void main() => runApp(VaultApp());

class VaultApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vault',
      theme: ThemeData.dark(),
      home: VaultHome(),
    );
  }
}

class VaultHome extends StatefulWidget {
  @override
  _VaultHomeState createState() => _VaultHomeState();
}

class _VaultHomeState extends State<VaultHome> {
  List<VaultFile> videos = [];

  @override
  void initState() {
    super.initState();
    loadVideos();
  }

  void loadVideos() async {
    final list = await VaultStorage.listVideos();
    setState(() => videos = list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('穹顶 Vault')),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(videos[i].name),
          subtitle: Text('${(videos[i].size / 1024 / 1024).toStringAsFixed(1)} MB'),
        ),
      ),
    );
  }
}
