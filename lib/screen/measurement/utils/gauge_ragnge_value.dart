// import 'package:web_test2/screen/measurement/subScreen/conditions/model/aerobic_power.dart';
//
// AerobicPowerModel getGaugeRangeValue(
//     List<AerobicPowerModel> data, String fieldName) {
//   AerobicPowerModel aerobicPowerModel = AerobicPowerModel(
//       healthStatus: '',
//       percentage: 0,
//       m30: 0,
//       m40: 0,
//       m50: 0,
//       m60: 0,
//       m70: 0,
//       m80: 0,
//       w30: 0,
//       w40: 0,
//       w50: 0,
//       w60: 0,
//       w70: 0,
//       w80: 0);
//   double maxComparisonPoint = 0;
//   print(fieldName);
//   print(point);
//
//   for (int i = 0; i < data.length; i++) {
//     double comparisonPoint = 0;
//     switch (fieldName) {
//       case 'm30':
//         comparisonPoint = data[i].m30;
//         break;
//       case 'm40':
//         comparisonPoint = data[i].m40;
//         break;
//       case 'm50':
//         comparisonPoint = data[i].m50;
//         break;
//       case 'm60':
//         comparisonPoint = data[i].m60;
//         break;
//       case 'm70':
//         comparisonPoint = data[i].m70;
//         break;
//       case 'm80':
//         comparisonPoint = data[i].m80;
//         break;
//       case 'w30':
//         comparisonPoint = data[i].w30;
//         break;
//       case 'w40':
//         comparisonPoint = data[i].w40;
//         break;
//       case 'w50':
//         comparisonPoint = data[i].w50;
//         break;
//       case 'w60':
//         comparisonPoint = data[i].w60;
//         break;
//       case 'w70':
//         comparisonPoint = data[i].w70;
//         break;
//       case 'w80':
//         comparisonPoint = data[i].w80;
//         break;
//       default:
//       // 예외 처리 혹은 기본값 설정
//         break;
//     }
//
//     if (point >= comparisonPoint && comparisonPoint >= maxComparisonPoint) {
//       aerobicPowerModel = data[i];
//       maxComparisonPoint = comparisonPoint; // 추가: 새로운 최대 comparisonPoint 저장
//     }
//   }
//
//   return aerobicPowerModel;
// }
