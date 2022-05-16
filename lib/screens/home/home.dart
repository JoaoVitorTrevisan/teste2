import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teste1/services/auth.dart';
import 'package:teste1/screens/home/register_video.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:teste1/models/youtube_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {

  final AuthService _auth = AuthService();

  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  CollectionReference data = FirebaseFirestore.instance.collection("data");

  final AuthService _auth = AuthService();

  late YoutubePlayerController _ytbPlayerController;
  List<YoutubeModel> videosList = [
    YoutubeModel(id: 1, youtubeId: 'o2gGD4ewTNA'),
    YoutubeModel(id: 2, youtubeId: 'OTzb2zFTBlk'),
    YoutubeModel(id: 3, youtubeId: 'FLcRb289uEM'),
    YoutubeModel(id: 4, youtubeId: 'g2nMKzhkvxw'),
    YoutubeModel(id: 5, youtubeId: 'qoDPvFAk2Vg'),
  ];

  @override
  void initState() {
    super.initState();

    _setOrientation([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        _ytbPlayerController = YoutubePlayerController(
          initialVideoId: videosList[0].youtubeId,
          params: const YoutubePlayerParams(
            showFullscreenButton: true,
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _ytbPlayerController.close();
  }

  _setOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }


  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.brown[50],

      appBar: AppBar(
        backgroundColor: Colors.blueAccent[400],
        title: Text('Open Unifeob'),
        elevation: 0.0,


        actions: <Widget>[

            FlatButton.icon(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterVideo()));
              },
              label: Text('Upload'),

            ),


          FlatButton.icon(
            icon: Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();
            },
            label: Text('Logout'),

          )
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [

            _buildYtbView(),
            _buildMoreVideoTitle(),
            _buildMoreVideosView(),
          ],
        ),
      ),

    );
  }

  //BUILDS

  _fetchData(){
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('data');
    collectionReference.snapshots().listen((snapshot) {

      setState(() {
        data = snapshot.docs[0].get('url');
      });

    });
  }

  _buildYtbView() {
    return AspectRatio(
      aspectRatio: 16 / 9,

      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        child: _ytbPlayerController != null
            ? YoutubePlayerIFrame(controller: _ytbPlayerController)
            : Center(child: CircularProgressIndicator()),
      ),
      );
  }

  _buildMoreVideoTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 182, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "More videos",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }



  _buildMoreVideosView() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
            itemCount: videosList.length,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  final _newCode = videosList[index].youtubeId;
                  _ytbPlayerController.load(_newCode);
                  _ytbPlayerController.stop();
                },
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 5,
                  margin: EdgeInsets.symmetric(vertical: 7),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Positioned(
                          child: CachedNetworkImage(
                            imageUrl:
                            "https://img.youtube.com/vi/${videosList[index]
                                .youtubeId}/0.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/ytbPlayBotton.png',
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );



  }


// G R I D   V I E W
// class Home extends StatelessWidget {
//
//   final AuthService _auth = AuthService();
//
//   Home({Key? key}) : super(key: key);
//
//   final List<Map> myProducts =
//   List.generate(20, (index) => {"id": index, "name": "Product $index"})
//       .toList();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.brown[50],
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent[400],
//         title: Text('Open Unifeob'),
//         elevation: 0.0,
//         actions:<Widget> [
//           ButtonTheme(
//             height: 250.0,
//
//
//             buttonColor: Colors.orange,
//             child: ElevatedButton(
//
//
//               onPressed:() {
//                  Navigator.push(context, MaterialPageRoute(builder: (context) => register_video()));
//               }, child: Text('Upload'),
//
//             ),
//
//           ),
//           FlatButton.icon(
//             icon: Icon(Icons.person),
//             onPressed:() async {
//               await _auth.signOut();
//             },
//             label: Text('Logout'),
//
//           )
//         ],
//       ),
//
//       body: Padding(
//
//
//         padding: const EdgeInsets.all(20.0),
//         child: Stack(
//           children: <Widget> [
//             SizedBox(height: 20,),
//
//
//
//             SizedBox(height: 20,),
//
//             Container(
//               child: GridView.builder(
//
//                   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                       maxCrossAxisExtent: 200,
//                       childAspectRatio: 4 / 3 ,
//                       crossAxisSpacing: 40,
//                       mainAxisSpacing: 40),
//                   itemCount: myProducts.length,
//                   itemBuilder: (BuildContext ctx, index) {
//
//                     return Container(
//
//                       alignment: Alignment.center,
//                       child: Text(myProducts[index]["name"]),
//                       decoration: BoxDecoration(
//
//                           color: Colors.amber,
//                           borderRadius: BorderRadius.circular(15)),
//                     );
//                   }),
//             ),
//           ],
//         ),
//
//
//       ),
//
//
//     );
//
//     // void _navigateToRegisterVideo(BuildContext context){
//     //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => register_video()));
//     // }
//   }
//
  register_video() {}

}
// }
