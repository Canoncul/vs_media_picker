// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:photo_manager/photo_manager.dart';

class DecodeImage extends ImageProvider<DecodeImage> {
  final AssetPathEntity entity;
  final double scale;
  final int thumbSize;
  final int index;

  const DecodeImage(
    this.entity, {
    this.scale = 1.0,
    this.thumbSize = 120,
    this.index = 0,
  });

  @override
  // ignore: override_on_non_overriding_member
  ImageStreamCompleter load(DecodeImage key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
    );
  }

  Future<ui.Codec> _loadAsync(DecodeImage key, ImageDecoderCallback decode) async {
    assert(key == this);

    final coverEntity = (await key.entity.getAssetListRange(start: index, end: index + 1))[0];

    final bytes = await coverEntity.thumbnailDataWithSize(ThumbnailSize(thumbSize, thumbSize));

    final ImmutableBuffer buffer = await ImmutableBuffer.fromUint8List(bytes!);

    return decode(buffer);
  }

  @override
  Future<DecodeImage> obtainKey(ImageConfiguration configuration) async {
    return this;
  }
}
