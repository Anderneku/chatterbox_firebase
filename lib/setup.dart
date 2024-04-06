import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

Client client = Client()
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject("66049780e81189982449");

Databases databases = Databases(client);
Account account = Account(client);

// -----------------Actually Useless now but I'll keep it------------------
Future<DocumentList> documents = _initializeGlobalVariable();
Future<DocumentList> _initializeGlobalVariable() async{
  return await databases.listDocuments(
            databaseId: '66049ded02ae6d6b7ea8',
            collectionId: '66049df59abce3373e3a',
  );
}
