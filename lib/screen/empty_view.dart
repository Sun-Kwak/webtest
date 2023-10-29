import 'package:flutter/material.dart';
import 'package:web_test2/common/component/animated_Object.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Column(
          children: [
            Text('관리자등급 이상 권한이 필요 합니다.'),
            SizedBox(height: 20,),
            AnimatedObject(
                onTap: (){},
                child: Text('권한요청')),
          ],
        )),
      ],
    );
  }
}