import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fullstack_social_media_app/features/search/domain/search_repo.dart';
import 'package:fullstack_social_media_app/features/search/presentation/cubits/search_states.dart';

// the cubits are the glue between the presentation layer (UI) and the domanin layer (business logic & entities)
// SearchState is an abstract class
class SearchCubit extends Cubit<SearchState> {
  final SearchRepo searchRepo;

  SearchCubit({required this.searchRepo}) : super(SearchInitial());

  // we defined this function in the domain layer.
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
