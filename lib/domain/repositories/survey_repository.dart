import 'package:meatless_days/domain/entities/onboarding/survey.dart';

abstract class SurveyRepository {
  Future save(Survey survey);

  Future<Survey> getSurvey();
}

class MockSurveyRepository implements SurveyRepository {
  late Survey _cache;

  @override
  Future<Survey> getSurvey() {
    return Future.value(_cache);
  }

  @override
  Future save(Survey survey) {
    _cache = survey;
    return Future.value();
  }
}
