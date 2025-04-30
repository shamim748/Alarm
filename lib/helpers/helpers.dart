class Helpers {
  bool isFormattedAddress(String? address) {
    if (address == null || address.trim().isEmpty) return false;
    return address.contains(',') &&
        !RegExp(r'^[A-Z0-9]{4,}\+[A-Z0-9]{2,}').hasMatch(address.trim());
  }
}
