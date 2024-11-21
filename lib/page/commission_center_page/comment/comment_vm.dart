import 'package:flutter/cupertino.dart';
import 'package:jiayuan/repository/model/HouseKeeper_data_detail.dart';

class CommentViewModel with ChangeNotifier {
  List<Evaluation>? evaluations;

  Future<void> getComments() async {
    // Response response = await DioInstance.instance().get(path: path);
    //  evaluations = response.data.map<Evaluation>((e) => Evaluation.fromJson(e)).toList();
    evaluations = [
      Evaluation(
          userId: 1,
          avatar:
              'https://ts2.cn.mm.bing.net/th?id=OIP-C.jj8VGVug_ehmSS3HRYjIGwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2',
          nickName: '明天',
          content: ' very good,非常nice,简直好极了',
          time: DateTime.now(),
          rating: 3,
          images: [
            'https://ts4.cn.mm.bing.net/th?id=OIP-C.bMpWQEwwDo-U_7rDYXv8NwHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2',
            'https://ts1.cn.mm.bing.net/th?id=OIP-C.aSvw1WH4s3oHCEyAKoVcrwHaHW&w=250&h=249&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2',
                'https://ts3.cn.mm.bing.net/th?id=OIP-C.j8cNnCH_GGM_3h8v6-2IkQHaHa&w=250&h=250&c=8&rs=1&qlt=90&o=6&dpr=1.4&pid=3.1&rm=2'
          ]),
      Evaluation(
          userId: 2,
          avatar:
              'https://tse4-mm.cn.bing.net/th/id/OIP-C.v1i9Oqp3njmlR7hvfTPtLgAAAA?w=200&h=200&c=7&r=0&o=5&dpr=1.3&pid=1.7',
          nickName: '王伟',
          content: ' very good',
          time: DateTime.now(),
          rating: 4.5,
          images: [
            'https://tse2-mm.cn.bing.net/th/id/OIP-C.N3PRZovf6GDt75yh4q__mQHaHa?w=199&h=200&c=7&r=0&o=5&dpr=1.3&pid=1.7',
            'https://tse4-mm.cn.bing.net/th/id/OIP-C.v1i9Oqp3njmlR7hvfTPtLgAAAA?w=200&h=200&c=7&r=0&o=5&dpr=1.3&pid=1.7',
                'https://tse3-mm.cn.bing.net/th/id/OIP-C.QmxHOM4BTyf869Rrlz8bNgHaHb?w=215&h=215&c=7&r=0&o=5&dpr=1.3&pid=1.7',
              'https://tse3-mm.cn.bing.net/th/id/OIP-C.QmxHOM4BTyf869Rrlz8bNgHaHb?w=215&h=215&c=7&r=0&o=5&dpr=1.3&pid=1.7'
          ]),
    ];
  }
}
