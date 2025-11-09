import 'dart:io';
import 'dart:isolate';

import 'package:bg3_vfx_helper/helpers/string_helper.dart';
import 'package:bg3_vfx_helper/logic/vfx_entry_model.dart';
import 'package:uuid/v4.dart';
import 'package:xml/xml.dart';
import 'package:path/path.dart' as p;

class VfxEntryController {
  static String? _validateUUID(String uuid) {
    if (StringHelper.isNullOrWhitespace(uuid)) {
      return "UUID cannot be empty.";
    }

    final regex = RegExp(
      r'^[0-9a-fA-F]{8}-'
      r'[0-9a-fA-F]{4}-'
      r'[0-9a-fA-F]{4}-'
      r'[0-9a-fA-F]{4}-'
      r'[0-9a-fA-F]{12}$',
    );

    if (!regex.hasMatch(uuid)) {
      return "Invalid UUID format.";
    }

    return null;
  }

  static bool _validateModel(VfxEntryModel model) {
    model.vanillaError = _validateUUID(model.vanillaUUID);
    model.customError = _validateUUID(model.customUUID);

    return model.vanillaError == null && model.customError == null;
  }

  static bool validateModels(List<VfxEntryModel> models) {
    var res = true;

    for (final model in models) {
      final modelRes = _validateModel(model);
      res = res && modelRes;
    }

    return res;
  }

  static int _getSlotId(XmlElement elem) {
    final firstNode = elem.firstElementChild;
    final firstNodeAttributes = firstNode?.childElements
        .where(
          (e) =>
              e.name.toString() == "attribute" &&
              e.attributes.any((a) => a.name.toString() == "id" && a.value == "SlotIndex"),
        )
        .firstOrNull
        ?.attributes;
    final firstNodeAttribute = firstNodeAttributes?.where((a) => a.name.toString() == "value").firstOrNull;
    final slotId = int.tryParse(firstNodeAttribute?.value ?? "0") ?? 0;

    return slotId;
  }

  static bool _containsVisualResource(XmlElement elem, String visualResourceUuid) {
    return elem.childElements.any(
      (e) => e.childElements.any(
        (c) =>
            c.name.toString() == "attribute" &&
            c.attributes.any((a) => a.name.toString() == "id" && a.value == "VisualResourceID") &&
            c.attributes.any((a) => a.name.toString() == "value" && a.value == visualResourceUuid),
      ),
    );
  }

  static Future<void> _backupFile(File file, DateTime date) async {
    final rootDirPath = file.parent.path;
    final backupDirPath = p.join(
      rootDirPath,
      "backup-${date.year}-${date.month}-${date.day}-${date.hour}-${date.minute}-${date.second}-${date.millisecond}",
    );
    final backupDir = Directory(backupDirPath);

    if (!await backupDir.exists()) {
      await backupDir.create();
    }

    final backupFilePath = p.join(backupDirPath, p.basename(file.path));
    await file.copy(backupFilePath);
  }

  static Future<void> _backupFiles(List<File> files) async {
    final backupDate = DateTime.now();

    for (final file in files) {
      await _backupFile(file, backupDate);
    }
  }

  static XmlElement _prepareXmlElement(int slotId, String customUUID) {
    final elem = XmlElement.tag(
      "node",
      attributes: [XmlAttribute(XmlName.fromString("id"), "strMaterialReference")],
    );

    var randomUUID = UuidV4().generate();

    final keyChild = XmlElement.tag(
      "attribute",
      attributes: [
        XmlAttribute(XmlName.fromString("id"), "Key"),
        XmlAttribute(XmlName.fromString("type"), "guid"),
        XmlAttribute(XmlName.fromString("value"), randomUUID),
      ],
    );

    elem.children.add(keyChild);

    if (slotId > 0) {
      final slotIndexChild = XmlElement.tag(
        "attribute",
        attributes: [
          XmlAttribute(XmlName.fromString("id"), "SlotIndex"),
          XmlAttribute(XmlName.fromString("type"), "int32"),
          XmlAttribute(XmlName.fromString("value"), slotId.toString()),
        ],
      );

      elem.children.add(slotIndexChild);
    }

    final visualResChild = XmlElement.tag(
      "attribute",
      attributes: [
        XmlAttribute(XmlName.fromString("id"), "VisualResourceID"),
        XmlAttribute(XmlName.fromString("type"), "guid"),
        XmlAttribute(XmlName.fromString("value"), customUUID),
      ],
    );

    elem.children.add(visualResChild);

    return elem;
  }

  static Future<void> _saveFile(File file, XmlDocument doc) async {
    final textData = doc.toXmlString(pretty: true, indent: '\t');

    await file.writeAsString(textData, flush: true);
  }

  static Future<XmlDocument?> _prepFile(List<VfxEntryModel> models, File file) async {
    final input = await file.readAsString();
    final doc = XmlDocument.parse(input);

    final saveElem = doc.getElement("save");
    final regionElem = saveElem?.getElement("region");
    final nodeElem = regionElem?.getElement("node");
    final childrenElem = nodeElem?.getElement("children");

    var res = false;

    if (childrenElem == null) {
      return null;
    }

    final slotId = _getSlotId(childrenElem);

    for (final model in models) {
      if (!_containsVisualResource(childrenElem, model.vanillaUUID)) {
        continue;
      }

      if (_containsVisualResource(childrenElem, model.customUUID)) {
        continue;
      }

      res = true;

      final modelElem = _prepareXmlElement(slotId, model.customUUID);

      childrenElem.children.add(modelElem);
    }

    return res ? doc : null;
  }

  static Future<int> _saveModels(List<VfxEntryModel> models, Directory dir) async {
    if (!await dir.exists()) {
      return -1;
    }

    if (!validateModels(models)) {
      return -1;
    }

    final files = <File>[];

    await for (final file in dir.list(followLinks: false)) {
      if (file is! File) {
        continue;
      }

      if (!file.path.toLowerCase().endsWith('.lsx')) {
        continue;
      }

      files.add(file);
    }

    final filesToSave = <File>{};

    for (final file in files) {
      final doc = await _prepFile(models, file);

      if (doc == null) {
        continue;
      }

      filesToSave.add(file);
    }

    if (filesToSave.isEmpty) {
      return 0;
    }

    await _backupFiles(files);

    for (final file in filesToSave) {
      final doc = await _prepFile(models, file);

      if (doc == null) {
        continue;
      }

      await _saveFile(file, doc);
    }

    return filesToSave.length;
  }

  static Future<int> saveModels(List<VfxEntryModel> models, Directory dir) async {
    final saveRes = await Isolate.run(() async {
      try {
        return await _saveModels(models, dir);
      } catch (_) {
        // TODO: Log this when logging is done
        return -1;
      }
    }, debugName: "saving-isolate");

    return saveRes;
  }
}
