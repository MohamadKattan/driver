// this class for listing to image change when driver will approve his details

// this class for liting to image piker to use for upload images in driver info screen
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class GetImageProvider extends ChangeNotifier {
    XFile? personImage;
    XFile? imageDriverLis;
   XFile? imageCarLis;
   XFile? platLis;

  void updatePersonImage(XFile val) {
    personImage = val;
    notifyListeners();
  }

  void updateImageDriverLis(XFile val) {
    imageDriverLis = val;
    notifyListeners();
  }

  void updateImageCarLis(XFile val) {
    imageCarLis = val;
    notifyListeners();
  }

  void updateImagePlatLis(XFile val) {
    platLis = val;
    notifyListeners();
  }
}
