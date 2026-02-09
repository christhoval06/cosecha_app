import '../../data/models/business.dart';
import '../../data/repositories/business_repository.dart';

class BusinessSession {
  BusinessSession._();

  static final BusinessSession instance = BusinessSession._();

  Business? _current;

  Business? get current => _current;

  Future<void> load() async {
    _current = BusinessRepository().getCurrent();
  }

  void setCurrent(Business? business) {
    _current = business;
  }
}
