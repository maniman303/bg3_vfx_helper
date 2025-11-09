import 'package:uuid/v4.dart';

class VfxEntryModel {
  late final String id;
  String vanillaUUID = "";
  String customUUID = "";
  String? vanillaError;
  String? customError;

  Map<String, String> toMap() {
    return {"id": id, "vanillaUUID": vanillaUUID, "customUUID": customUUID};
  }

  VfxEntryModel() {
    id = UuidV4().generate();
  }

  VfxEntryModel.fromMap(Map data) {
    id = data["id"] ?? UuidV4().generate();
    vanillaUUID = data["vanillaUUID"] ?? "";
    customUUID = data["customUUID"] ?? "";
  }
}
