import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_application/model/photo_model.dart';
import 'package:wallpaper_application/services/api_service.dart';

class SimpleUiController extends GetxController {
  var selectedIndex = 0.obs;
  RxList<PhotosModel> photos = RxList();
  RxBool isLoading = true.obs;
  RxString ordersBy = "latest".obs;
  List<String> orders = [
    "latest",
    "oldest",
    "popular",
    "views",
  ];
  //get
  getPhotos() async {
    isLoading.value = true;
    var response = await ApiService().getMethod(''
        //'https://api.unsplash.com/photos/?per_page=30&order_by=${orderBy.value}&client_id=$apikey'
        );
    photos = RxList();
    if (response.statusCode == 200) {
      response.data.forEach((elm) {
        photos.add(PhotosModel.fromJson(elm));
      });
      isLoading.value = false;
    }
  }

  orderFunc(String newVal) {
    ordersBy.value = newVal;
    getPhotos();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getPhotos();
    super.onInit();
  }
}
