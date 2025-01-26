import 'package:fullstack_social_media_app/features/profile/domain/entities/profile_user';

abstract class SearchRepo {
  Future<List<ProfileUser?>> searchUsers(String query);
}
