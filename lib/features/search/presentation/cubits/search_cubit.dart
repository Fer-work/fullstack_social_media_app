import 'package: flutter_bloc/flutter_bloc.dart';
import 'package:fullstack_social_media_app/features/search/domain/search_repo.dart';
import 'package:fullstack_social_media_app/features/profile/domain/entities/profile_user.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepo searchRepo;

  SearchCubit({required this.searchRepo}) : super(SearchInitial());

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    try {
      emit(SearchLoading());
      final users = await searchRepo.searchUsers(query);
      emit(SearchLoaded(users));
    } catch (e) {
      emit(SearchError("Error fetching search results"));
    }
  }
}
