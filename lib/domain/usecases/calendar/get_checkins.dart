import 'package:meatless_days/domain/entities/calendar/check_in_day.dart';
import 'package:meatless_days/domain/repositories/calendar_repository.dart';
import 'package:meatless_days/domain/usecases/use_case.dart';

class GetCheckins implements NoArgUseCase<List<CheckedInDay>> {
  final CalendarRepository repository;

  GetCheckins({required this.repository});

  @override
  Future<List<CheckedInDay>> call() {
    return repository.getCheckedinDays();
  }
}
