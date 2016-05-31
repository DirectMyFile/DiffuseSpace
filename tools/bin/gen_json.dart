import "dart:convert";
import "dart:io";

import "package:spacex_data_api/directory.dart";

main() async {
  var loader = new DataDirectoryLoader.forPath(
    Platform.script.resolve("../../data").toFilePath()
  );

  var directory = await loader.load();
  print(const JsonEncoder.withIndent("  ").convert(directory));
}
