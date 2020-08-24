import 'dart:io';
import 'package:googleapis/drive/v3.dart' as driveAPI;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:GDrive_connect/assets/config.dart' as config;
import 'package:path/path.dart' as path;
import 'package:GDrive_connect/services/secure_storage.dart';

const _scopes = [driveAPI.DriveApi.DriveFileScope];

class GoogleDrive {
  GoogleDrive();
  final _secureStorage = SecureStorage();

  Future<bool> checkConnectionStatus() async {
    if (await _secureStorage.getCredentials() == null)
      return false;
    else
      return true;
  }

  Future<http.Client> getHttpClient() async {
    var credentials = await _secureStorage.getCredentials();
    if (credentials == null) {
      var authClient = await clientViaUserConsent(
          ClientId(config.clientId, config.clientSecret), _scopes, (url) async {
        await launch(
          url,
        );
      });
      await _secureStorage.saveCredentials(authClient.credentials.accessToken,
          authClient.credentials.refreshToken);
      return authClient;
    } else if (!DateTime.parse(credentials['expiry']).isAfter(DateTime.now())) {
      _secureStorage.clearCredentials();
      var client = await getHttpClient();
      return client;
    } else {
      DateTime expiry = DateTime.parse(credentials['expiry']);
      return authenticatedClient(
          http.Client(),
          AccessCredentials(
              AccessToken(credentials['type'], credentials['data'], expiry),
              credentials['refreshToken'],
              _scopes));
    }
  }

  Future connect() async {
    var client = await getHttpClient();
    var drive = driveAPI.DriveApi(client);
    try {
      var root = await drive.files.get('root', $fields: 'id');
      print(root.id);
      _secureStorage.saveRootID(root.id);
    } on Exception catch (err) {
      // DetailedApiRequestError(status: 404, message: File not found: 0ACOXys1_mZztUk9PVA.)
      print("Error while getting RootID" + err.toString());
      var str = err.toString();
      const start = "found: ";
      const end = ".)";

      final startIndex = str.indexOf(start);
      final endIndex = str.indexOf(end, startIndex + start.length);

      _secureStorage
          .saveRootID(str.substring(startIndex + start.length, endIndex));
    }
  }

  Future upload(File file) async {
    var client = await getHttpClient();
    var drive = driveAPI.DriveApi(client);
    var folderId = await _secureStorage.getRootID();
    var fileRequest = driveAPI.File()
      ..name = path.basename(file.absolute.path)
      ..parents = [folderId];
    try {
      return await drive.files.create(
        fileRequest,
        uploadMedia: driveAPI.Media(file.openRead(), file.lengthSync()),
      );
    } on Exception catch (err) {
      print(err);
    }
  }

  Future disconnect() async {
    await _secureStorage.clearCredentials();
  }

  Future<driveAPI.FileList> getFolderItemsList() async {
    var client = await getHttpClient();
    var drive = driveAPI.DriveApi(client);
    var folderId = await _secureStorage.getRootID();
    // drive.files.watch(request, fileId)
    try {
      return await drive.files.list(
        q: "'$folderId' in parents",
      );
    } on Exception catch (err) {
      print("Error while getting folder contents" + err.toString());
      return null;
    }
  }

  Future createFolder(String folderName) async {
    var client = await getHttpClient();
    var drive = driveAPI.DriveApi(client);
    var folderId = await _secureStorage.getRootID();
    driveAPI.File folderToUpload = driveAPI.File();
    folderToUpload.mimeType = 'application/vnd.google-apps.folder';
    folderToUpload.name = folderName;
    folderToUpload.parents = [folderId];
    return await drive.files.create(
      folderToUpload,
    );
  }

  Future setRootId(String rootId) async {
    await _secureStorage.saveRootID(rootId);
  }

  Future getRootId() async {
    return await _secureStorage.getRootID();
  }

  Future goBack() async {
    var client = await getHttpClient();
    var drive = driveAPI.DriveApi(client);
    var folderId = await _secureStorage.getRootID();
    try {
      var root = await drive.files.get(folderId, $fields: 'parents');
      await _secureStorage.saveRootID(root.parents[0]);
      return true;
    } on Exception catch (err) {
      print(err);
      return false;
    }
  }

  Future delete(String fileId) async {
    var client = await getHttpClient();
    var drive = driveAPI.DriveApi(client);
    try {
      return await drive.files.delete(fileId);
    } on Exception catch (err) {
      print(err);
    }
  }
}
