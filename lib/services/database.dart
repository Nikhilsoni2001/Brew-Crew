import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_crew/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  // collection Reference
  final CollectionReference brewCollection = Firestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  // brew list from snapshots
  List<Brew> _brewListFromSnapshots(QuerySnapshot snapshot)  {
   return snapshot.docs.map((doc) {
     return Brew(
       name: doc.data()['name'] ?? '',
       strength: doc.data()['strength'] ?? 0,
       sugars: doc.data()['sugars'] ?? '0'
     );
   }).toList();
  }

  // userData from snapshots
  UserData _userDataFromSnapshots(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data()['name'],
      sugars: snapshot.data()['sugar'],
      strength: snapshot.data()['strength']
    );
  }

  // get brews stream
Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshots);
}

// get user data stream
Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots()
    .map(_userDataFromSnapshots);
}

}