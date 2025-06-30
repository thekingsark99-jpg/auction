import 'package:biddo/core/services/image_compress.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio_lib;

import '../controllers/flash.dart';
import '../controllers/image_picker.dart';
import 'base.dart';

class AIRepository {
  final dio = Get.find<Api>();
  final imageCompressService = Get.find<ImageCompressService>();
  final flashController = Get.find<FlashController>();

  Future<GeneratedDataResult?> generateData(
    String currency,
    List<AssetEntityPath>? galleryAssets,
    List<XFile>? cameraAssets,
  ) async {
    try {
      var formData = await generateFormDataForCreateOrUpdate(
        currency,
        galleryAssets,
        cameraAssets,
      );

      var response =
          await dio.api.post('/ai/generate-from-images', data: formData);
      return GeneratedDataResult.fromJSON(response.data);
    } catch (error) {
      if (error is DioException) {
        var response = error.response?.data.toString() ?? '';

        if (response.contains('TOO_MANY')) {
          flashController.showMessageFlash(
              tr('create_auction.repository.too_many_assets'));
          return null;
        }

        if (response.contains('ASSET_TOO_BIG')) {
          flashController
              .showMessageFlash(tr('create_auction.repository.asset_too_big'));
          return null;
        }

        if (response.contains('ASSET_NOT_SUPPORTED')) {
          flashController.showMessageFlash(
              tr('create_auction.repository.asset_not_supported'));
          return null;
        }
      }

      flashController.showMessageFlash(tr('ai.generate_error'));
      return null;
    }
  }

  Future<dio_lib.FormData> generateFormDataForCreateOrUpdate(
    String currency,
    List<AssetEntityPath>? galleryAssets,
    List<XFile>? cameraAssets,
  ) async {
    var files = galleryAssets?.map((asset) async {
      var compressed =
          await imageCompressService.compressFileByPath(asset.path, 400, 400);
      return dio_lib.MultipartFile.fromFileSync(
        compressed.path,
        filename: asset.name,
      );
    }).toList();

    if (files == null || files.isEmpty) {
      files = [];
    }

    var cameraFiles = cameraAssets?.map((asset) async {
      var compressed = await imageCompressService.compressFile(asset, 400, 400);
      return dio_lib.MultipartFile.fromFileSync(
        compressed.path,
        filename: asset.name,
      );
    }).toList();

    if (cameraFiles == null || cameraFiles.isEmpty) {
      cameraFiles = [];
    }

    files.addAll(cameraFiles);

    var compressedFiles = await Future.wait(files);

    var data = dio_lib.FormData.fromMap({
      'files': compressedFiles,
      'currency': currency,
    });
    return data;
  }
}

class GeneratedDataResult {
  final String title;
  final String description;
  final String category;
  final String price;

  GeneratedDataResult({
    required this.title,
    required this.description,
    required this.category,
    required this.price,
  });

  static GeneratedDataResult fromJSON(dynamic data) {
    return GeneratedDataResult(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      price: data['price'] != null ? data['price'].toString() : '',
    );
  }
}
