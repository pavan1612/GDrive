import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis_auth/auth_io.dart';

class SecureStorage {
  final _credentialStorage = FlutterSecureStorage();

  //Save the credentials
  Future saveCredentials(AccessToken token, String refreshToken) async {
    await _credentialStorage.write(key: 'type', value: token.type);
    await _credentialStorage.write(key: 'data', value: token.data);
    await _credentialStorage.write(
        key: 'expiry', value: token.expiry.toString());
    await _credentialStorage.write(key: 'refreshToken', value: refreshToken);
  }

  Future saveRootID(String folderId) async {
    await _credentialStorage.write(key: 'rootID', value: folderId);
  }

  //Get the credentials
  Future<Map<String, dynamic>> getCredentials() async {
    var result = await _credentialStorage.readAll();
    if (result.length == 0) return null;
    return result;
  }

  Future getRootID() async {
    var result = await _credentialStorage.readAll();
    if (result.length <= 4) return null;
    return await _credentialStorage.read(key: 'rootID');
  }

  //Clear the credentials
  Future clearCredentials() {
    return _credentialStorage.deleteAll();
  }
}
