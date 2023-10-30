double calculateVo2Max(String gender, String exhaustionSecond) {
  try {
    double genderFactor = (gender == "남성") ? 2 : (gender == "여성") ? 1 : 0;
    double vo2Max =
        6.7 - (2.82 * genderFactor) + (0.056 * int.parse(exhaustionSecond));
    return double.parse(vo2Max.toStringAsFixed(2));
  } catch (e) {
    return 0.0;
  }
}

