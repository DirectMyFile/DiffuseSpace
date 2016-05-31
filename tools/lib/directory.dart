library spacex.data.api.directory;

import "dart:async";
import "dart:io";

import "package:yaml/yaml.dart" as Yaml;

class DataDirectoryLoader {
  final Directory dir;

  DataDirectoryLoader.forDirectory(this.dir);

  factory DataDirectoryLoader.forPath(String path) {
    return new DataDirectoryLoader.forDirectory(new Directory(path));
  }

  factory DataDirectoryLoader.here() {
    return new DataDirectoryLoader.forDirectory(Directory.current);
  }

  Future<Map<String, dynamic>> load() async {
    var directoryFile = new File("${dir.path}/directory.yaml");
    Map<String, dynamic> directory =
      Yaml.loadYaml(await directoryFile.readAsString());

    var out = <String, dynamic>{};

    for (String key in directory.keys) {
      var keyDir = new Directory("${dir.path}/${key}");
      var keyOut = <dynamic>[];

      await for (FileSystemEntity entity in keyDir.list(recursive: true)) {
        if (entity is! File) continue;

        if (!entity.path.endsWith(".yaml") && !entity.path.endsWith(".json")) {
          continue;
        }

        File file = entity as File;
        var yaml = Yaml.loadYaml(await file.readAsString());
        keyOut.add(yaml);
      }

      out[key] = keyOut;
    }

    return out;
  }
}
