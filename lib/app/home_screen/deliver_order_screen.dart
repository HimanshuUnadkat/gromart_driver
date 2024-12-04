import 'package:driver/app/chat_screens/chat_screen.dart';
import 'package:driver/constant/constant.dart';
import 'package:driver/constant/show_toast_dialog.dart';
import 'package:driver/controllers/deliver_order_controller.dart';
import 'package:driver/models/cart_product_model.dart';
import 'package:driver/models/user_model.dart';
import 'package:driver/themes/app_them_data.dart';
import 'package:driver/themes/responsive.dart';
import 'package:driver/utils/dark_theme_provider.dart';
import 'package:driver/utils/fire_store_utils.dart';
import 'package:driver/utils/network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DeliverOrderScreen extends StatelessWidget {
  const DeliverOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: DeliverOrderController(),
        builder: (controller) {
          return controller.isLoading.value
              ? Constant.loader()
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                    centerTitle: false,
                    titleSpacing: 0,
                    iconTheme: const IconThemeData(color: AppThemeData.grey900, size: 20),
                    title: Text(
                      Constant.orderId(orderId: controller.orderModel.value.id.toString()).tr,
                      style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900, fontSize: 18, fontFamily: AppThemeData.medium),
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: ShapeDecoration(
                              color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Deliver to the",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.semiBold,
                                            fontSize: 16,
                                            color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                          ),
                                        ),
                                        Text(
                                          controller.orderModel.value.address!.getFullAddress(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: AppThemeData.medium,
                                            fontSize: 14,
                                            color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      ShowToastDialog.showLoader("Please wait");

                                      UserModel? customer = await FireStoreUtils.getUserProfile(controller.orderModel.value.authorID.toString());
                                      UserModel? driver = await FireStoreUtils.getUserProfile(controller.orderModel.value.driverID.toString());

                                      ShowToastDialog.closeLoader();

                                      Get.to(const ChatScreen(), arguments: {
                                        "customerName": '${customer!.fullName()}',
                                        "restaurantName": driver!.fullName(),
                                        "orderId": controller.orderModel.value.id,
                                        "restaurantId": driver.id,
                                        "customerId": customer.id,
                                        "customerProfileImage": customer.profilePictureURL ?? "",
                                        "restaurantProfileImage": driver.profilePictureURL ?? "",
                                        "token": customer.fcmToken,
                                        "chatType": "Driver",
                                      });
                                    },
                                    child: Container(
                                      width: 42,
                                      height: 42,
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(width: 1, color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200),
                                          borderRadius: BorderRadius.circular(120),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset("assets/icons/ic_wechat.svg"),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Container(
                            decoration: ShapeDecoration(
                              color: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.orderModel.value.products!.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      CartProductModel product = controller.orderModel.value.products![index];

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius.all(Radius.circular(14)),
                                                child: Stack(
                                                  children: [
                                                    NetworkImageWidget(
                                                      imageUrl: product.photo.toString(),
                                                      height: Responsive.height(8, context),
                                                      width: Responsive.width(16, context),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Container(
                                                      height: Responsive.height(8, context),
                                                      width: Responsive.width(16, context),
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          begin: const Alignment(-0.00, -1.00),
                                                          end: const Alignment(0, 1),
                                                          colors: [Colors.black.withOpacity(0), const Color(0xFF111827)],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "${product.name}",
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                              fontFamily: AppThemeData.regular,
                                                              color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          "x ${product.quantity}",
                                                          textAlign: TextAlign.start,
                                                          style: TextStyle(
                                                            fontFamily: AppThemeData.regular,
                                                            color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          product.variantInfo == null || product.variantInfo!.variantOptions!.isEmpty
                                              ? Container()
                                              : Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Variants",
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          fontFamily: AppThemeData.semiBold,
                                                          color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Wrap(
                                                        spacing: 6.0,
                                                        runSpacing: 6.0,
                                                        children: List.generate(
                                                          product.variantInfo!.variantOptions!.length,
                                                          (i) {
                                                            return Container(
                                                              decoration: ShapeDecoration(
                                                                color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                                                child: Text(
                                                                  "${product.variantInfo!.variantOptions!.keys.elementAt(i)} : ${product.variantInfo!.variantOptions![product.variantInfo!.variantOptions!.keys.elementAt(i)]}",
                                                                  textAlign: TextAlign.start,
                                                                  style: TextStyle(
                                                                    fontFamily: AppThemeData.medium,
                                                                    color: themeChange.getThem() ? AppThemeData.grey500 : AppThemeData.grey400,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ).toList(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          product.extras == null || product.extras!.isEmpty
                                              ? const SizedBox()
                                              : Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "Addons",
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        fontFamily: AppThemeData.semiBold,
                                                        color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Wrap(
                                                      spacing: 6.0,
                                                      runSpacing: 6.0,
                                                      children: List.generate(
                                                        product.extras!.length,
                                                        (i) {
                                                          return Container(
                                                            decoration: ShapeDecoration(
                                                              color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                            ),
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                                                              child: Text(
                                                                product.extras![i].toString(),
                                                                textAlign: TextAlign.start,
                                                                style: TextStyle(
                                                                  fontFamily: AppThemeData.medium,
                                                                  color: themeChange.getThem() ? AppThemeData.grey500 : AppThemeData.grey400,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ).toList(),
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        side: const BorderSide(
                                          color: AppThemeData.success400,
                                          width: 1.5,
                                        ),
                                        value: controller.conformPickup.value,
                                        activeColor: AppThemeData.success400,
                                        focusColor: AppThemeData.success400,
                                        onChanged: (value) {
                                          if (value != null) {
                                            controller.conformPickup.value = value;
                                          }
                                        },
                                      ),
                                      Text(
                                        "Give ${controller.totalQuantity.value.toString()} Items to the customer".tr,
                                        style: TextStyle(
                                            color: themeChange.getThem() ? AppThemeData.success400 : AppThemeData.success400, fontSize: 16, fontFamily: AppThemeData.medium),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar: InkWell(
                    onTap: () async {
                      if (controller.conformPickup.value == false) {
                        ShowToastDialog.showToast("Conform Deliver order");
                      } else {
                        controller.completedOrder();
                      }
                    },
                    child: Container(
                      color: AppThemeData.driverApp300,
                      width: Responsive.width(100, context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "Make Order Delivered",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey50,
                            fontSize: 16,
                            fontFamily: AppThemeData.medium,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        });
  }
}
