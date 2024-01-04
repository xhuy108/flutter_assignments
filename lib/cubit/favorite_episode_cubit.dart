import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'favorite_episode_state.dart';

class FavoriteEpisodeCubit extends Cubit<FavoriteEpisodeState> {
  FavoriteEpisodeCubit() : super(FavoriteEpisodeInitial());
}
