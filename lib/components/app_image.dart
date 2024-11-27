// Package imports:
import 'package:extended_image/extended_image.dart';
import 'package:flutter_svg/svg.dart';

// Project imports:
import '../../imports.dart';
import 'shimmer_widget.dart';

// ignore: must_be_immutable
class AppImage extends StatefulWidget {
  String? svgName;
  String? name;
  String? url;
  double? width;
  double? height;
  double? scale;
  Color? color;
  BoxFit? fit;
  double radius;
  final BorderRadius? borderRadius;

  AppImage.asset({
    super.key,
    required this.name,
    this.width,
    this.height,
    this.scale,
    this.color,
    this.fit,
    this.radius = 0.0,
    this.borderRadius,
  });

  AppImage.network({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.scale,
    this.color,
    this.fit,
    this.radius = 0.0,
    this.borderRadius,
  });

  AppImage.svg({
    super.key,
    required this.svgName,
    this.width,
    this.height,
    this.scale,
    this.color,
    this.fit,
    this.radius = 0.0,
    this.borderRadius,
  });

  @override
  State<AppImage> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<AppImage> {
  final String imageCacheName = "MemoryUsage";

  @override
  void dispose() {
    // clear ImageCache which named 'MemoryUsage'
    clearMemoryImageCache(imageCacheName);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return imageWidget();
  }

  Widget imageWidget() {
    return RepaintBoundary(
      child: widget.svgName != null
          ? SvgPicture.asset(
              widget.svgName!,
              width: widget.width,
              height: widget.height,
              colorFilter: widget.color != null
                  ? ColorFilter.mode(widget.color!, BlendMode.srcIn)
                  : null,
            )
          : widget.name != null
              ? ClipRRect(
                  borderRadius: widget.borderRadius ??
                      BorderRadius.circular(widget.radius),
                  child: ExtendedImage.asset(
                    widget.name ?? "",
                    gaplessPlayback: true,
                    width: widget.width,
                    height: widget.height,
                    scale: widget.scale ?? 1.0,
                    color: widget.color,
                    fit: widget.fit,
                    clearMemoryCacheWhenDispose: true,
                    imageCacheName: imageCacheName,
                    enableMemoryCache: false,
                  ),
                )
              : ExtendedImage.network(
                  widget.url ?? "",
                  gaplessPlayback: true,
                  width: widget.width,
                  height: widget.height,
                  scale: widget.scale ?? 1.0,
                  color: widget.color,
                  fit: widget.fit,
                  clearMemoryCacheWhenDispose: true,
                  imageCacheName: imageCacheName,
                  enableMemoryCache: false,
                  loadStateChanged: (ExtendedImageState state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        return ShimmerWidget(radius: widget.radius);

                      case LoadState.completed:
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: state.imageProvider,
                              fit: widget.fit ?? BoxFit.fill,
                            ),
                            borderRadius: widget.borderRadius ??
                                BorderRadius.all(
                                  Radius.circular(widget.radius),
                                ),
                          ),
                        );

                      case LoadState.failed:
                        return ClipRRect(
                          borderRadius: widget.borderRadius ??
                              BorderRadius.circular(widget.radius),
                          child: AppImage.asset(
                            name: "assets/images/no_image.png",
                            fit: BoxFit.fill,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        );
                    }
                  },
                ),
    );
  }
}
