import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vieu/controller/custom_route_animation.dart';
import 'package:vieu/view/patient_view/Image_View_Page.dart';
import 'package:vieu/view/patient_view/Patients_Recents_Page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late CameraController _controller;

  late List<CameraDescription> cameras;
  late CameraDescription selectedCamera;

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        titleSpacing: .1,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).backgroundColor,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: Text(
          "Vieu",
          style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: size.width * .06),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
                weight: .5,
              ))
        ],
      ),
      body: FutureBuilder(
          future: initialize(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||snapshot.connectionState == ConnectionState.none || snapshot.data == false) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            }


            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * .75,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ValueListenableBuilder(
                          valueListenable: isLoading,
                          builder: (ctx, value, child) {
                            if (value) {
                              return Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).primaryColor,
                              ));
                            } else {
                              return CameraPreview(_controller);
                            }
                          },
                        ))),
                SizedBox(
                  height: size.height * .1,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                SlidePageRoute(
                                    page: const PatientRecentsPage()));
                          },
                          icon: Icon(Icons.format_list_bulleted_outlined,
                              color: Colors.black, size: size.width * .08),
                        ),
                        InkWell(
                          splashColor: Theme.of(context).primaryColorDark,
                          onTap: () async {
                            if (isLoading.value == false) {
                              isLoading.value = true;
                              if (_controller.value.isTakingPicture) {
                                return;
                              }

                              XFile? image = await _controller.takePicture();

                              Navigator.of(context).push(SlidePageRoute(
                                  page: ImageViewPage(
                                imagePath: image.path,
                              )));
                              await Future.delayed(const Duration(seconds: 1));
                              isLoading.value = false;
                            }
                          },
                          child: CircleAvatar(
                            radius: size.width * .08,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).primaryColorLight,
                              radius: size.width * .06,
                            ),
                          ),
                        ),
                        IconButton(

                            onPressed: () {
                              selectedCamera.name == "0"
                                  ? selectedCamera = cameras[1]
                                  : selectedCamera = cameras[0];
                              _controller.setDescription(selectedCamera);
                            },
                            icon: Icon(
                              Icons.autorenew_rounded,
                              color: Colors.black,
                              size: size.width * .08,
                            ))
                      ]),
                ),
              ],
            );
          }),
    );
  }

  Future<bool> initialize() async {
    bool request = false;

    request = await Permission.camera.request().isGranted;
    while (request == false) {
      request = await Permission.camera.request().isGranted;
    }

    cameras = await availableCameras();
    selectedCamera = cameras.first;

    _controller = CameraController(
      selectedCamera,
      ResolutionPreset.high,
    );

   await _controller.initialize();
   return true;

  }

}
