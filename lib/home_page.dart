//import 'dart:js';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:wallpaper_application/components.dart';
import 'package:wallpaper_application/controller/simple_ui_controller.dart';
import 'package:wallpaper_application/detail_view.dart';
import 'package:wallpaper_application/services/api_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  SimpleUiController simpleUiController = Get.put(SimpleUiController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // ApiService().getMethod("https://api.unsplash.com/photos/?per_page=30&order_by=${orderBy.value}&client_id=$apikey");

    return SafeArea(
      //acc. to dimensions of device
      child: Scaffold(
          body: SizedBox(
        width: double.infinity,
        height: double.infinity,
/*
The difference can be summarized into:

I want to be as big as my parent allows (double.infinity)
I want to be as big as the screen (MediaQuery).

 */

        child: Column(children: [
          MyAppBar(size: size), //described below
          Expanded(
              flex: 7,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildTabBar(),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Expanded(
                      flex: 13,
                      child: Obx(
                        //color: Colors.yellow,

                        () => simpleUiController.isLoading.value
                            ? Center(
                                child: customLoading(),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: GridView.custom(
                                    shrinkWrap: true, //????
                                    physics: BouncingScrollPhysics(),
                                    gridDelegate: SliverQuiltedGridDelegate(
                                        crossAxisCount: 4,
                                        mainAxisSpacing: 4,
                                        crossAxisSpacing: 4,
                                        pattern: [
                                          QuiltedGridTile(2, 2),
                                          QuiltedGridTile(1, 1),
                                          QuiltedGridTile(1, 1),
                                          QuiltedGridTile(1, 2),
                                        ]),
                                    childrenDelegate:
                                        SliverChildBuilderDelegate(
                                            childCount: simpleUiController
                                                .photos
                                                .length, (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(DetailView(index: index));
                                        },
                                        child: Hero(
                                          tag: simpleUiController.photos[index].id!,
                                          child: Container(
                                            child: CachedNetworkImage(
                                              imageUrl: simpleUiController
                                                  .photos[index].urls!['small'],
                                              imageBuilder: (ctx, img) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        image: img,
                                                        fit: BoxFit.cover,
                                                      )),
                                                );
                                              },
                                              placeholder: (context, url) =>
                                                  Center(
                                                child: customLoading(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) => Center(
                                                child: errorIcon(),
                                              ),
                                            ),
                                            // child: Image(image: NetworkImage(simpleUiController.photos[index].urls! ['small'])),
                                        
                                            // color: Colors.red,
                                          ),
                                        ),
                                      );
                                    })),
                              ),
                      )),
                ],
              ))
        ]),
      )),
    );
  }

  Widget _buildTabBar() {
    return ListView.builder(
        itemCount: simpleUiController.orders.length,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: ((context, index) {
          return Obx(
            //for grey container while scrolling on data
            () => GestureDetector(
              onTap: () {
                simpleUiController.orderFunc(simpleUiController.orders[index]);
                simpleUiController.selectedIndex.value = index;
              },
              child: AnimatedContainer(
                width: 100,
                margin: EdgeInsets.fromLTRB(index == 0 ? 15 : 5, 0, 5, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      index == simpleUiController.selectedIndex.value
                          ? 18
                          : 15),
                  color: index == simpleUiController.selectedIndex.value
                      ? Colors.grey[700]
                      : Colors.grey[200],
                ),
                duration: Duration(milliseconds: 300),
                child: Center(
                  child: Text(
                    simpleUiController.orders[index],
                    style: TextStyle(
                        color: index == simpleUiController.selectedIndex.value
                            ? Colors.white
                            : Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          );
        }));
  }
}

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key, required this.size});

  final Size size;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        width: size.width,
        height: size.height / 3.5,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.darken),
                image: NetworkImage(
                    'https://media.istockphoto.com/id/498309616/photo/great-ocean-road-at-night-milky-way-view.webp?b=1&s=170667a&w=0&k=20&c=q5cmaFOEDmoy3CbVEESWrCvSlZ-WDT1DgRtlEdP0ISE='))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "What would you like\n to find?",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  width: double.infinity,
                  height: 50,
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.only(top: 5),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none),
                        hintText: 'Search',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
