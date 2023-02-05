import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class IconCard extends StatelessWidget {
  String iconCode;
  var hour;
  var min;
  IconCard(this.iconCode, this.hour, this.min, {super.key});

  String url = "https://www.weatherbit.io/static/img/icons/";

  @override
  Widget build(BuildContext context) {
    num diff_hrs = 0;
    num diff_mins = 0;

    var hr = DateTime.now().hour;
    var mn = DateTime.now().minute;
    if (hour > hr) {
      diff_hrs = 0;
    } else {
      diff_hrs = (hr - hour);
      diff_mins = (mn - min);
    }
    String diff_s = "";
    if (diff_hrs != 0) {
      diff_s = diff_hrs.toString() + " hrs";
    } else if (diff_mins != 0) {
      diff_s = diff_mins.toString() + " mins";
    } else {
      diff_s = "0 mins";
    }

    return Column(
      children: [
        Container(
          child: CachedNetworkImage(
            imageUrl: url + iconCode + ".png",
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => Icon(Icons.error_outline),
          ),
          width: 150,
          height: 80,
          color: Colors.white,
        ),
        Text(
          "Updated " + (diff_s != "" ? diff_s : "0") + " ago",
          style: TextStyle(
              backgroundColor: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w200),
        )
      ],
    );
  }
}
