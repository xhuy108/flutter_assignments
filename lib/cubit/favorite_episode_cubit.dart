import 'package:bai3/models/podcast_episode.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'favorite_episode_state.dart';

class FavoriteEpisodeCubit extends Cubit<List<PodcastEpisode>> {
  FavoriteEpisodeCubit() : super([]);

  void favoritePodcastHandler(PodcastEpisode podcastEpisode) {
    if (state.contains(podcastEpisode)) {
      emit(state.where((e) => e != podcastEpisode).toList());
      return;
    }
    emit([...state, podcastEpisode]);
  }
}
