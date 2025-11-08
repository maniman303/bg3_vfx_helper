class VfxEntryModel {
  String vanillaUUID = "";
  String customUUID = "";
  String? vanillaError;
  String? customError;

  Map<String, String> toMap() {
    return {"vanillaUUID": vanillaUUID, "customUUID": customUUID};
  }

  VfxEntryModel();

  VfxEntryModel.fromMap(Map data) {
    vanillaUUID = data["vanillaUUID"] ?? "";
    customUUID = data["customUUID"] ?? "";
  }
}
