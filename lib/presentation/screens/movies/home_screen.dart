import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_slideshow_provider.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/movies/movies_slideshow.dart';
import 'package:cinemapedia/presentation/widgets/shared/bottom_navegation_bar.dart';
import 'package:cinemapedia/presentation/widgets/shared/custom_appbar.dart';
import 'package:cinemapedia/presentation/widgets/shared/full_screen_loader.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: CustomBottomNavigation(),
      body: _HomeView()
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {

  @override
  void initState() {
    super.initState();
    
    ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topratedMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
  }


  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch(initialLoadingProvider);
    if(initialLoading) return const FullScreenLoader();

    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );
    final populargMovies = ref.watch( popularMoviesProvider );
    final topratedgMovies = ref.watch( topratedMoviesProvider );
    final upcomingMovies = ref.watch( upcomingMoviesProvider );
    final slideshowMovies = ref.watch( moviesSlideshowProvider );

    
    
    return CustomScrollView(slivers: [
      const SliverAppBar(floating: true, 
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        background: CustomAppbar(),),),
      SliverList(delegate: SliverChildBuilderDelegate((context, index) {
        return Column(children: [

      MoviesSlideshow(movies: slideshowMovies),

      MovieHorizontalListview(movies: nowPlayingMovies, 
      loadNextPage: () {
        ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
      }, 
      title: 'En cines', 
      subTitle: 'Lunes 20'),
      MovieHorizontalListview(movies: topratedgMovies, 
      loadNextPage: () {
        ref.read(topratedMoviesProvider.notifier).loadNextPage();
      }, 
      title: 'Mejor calificados'),

      MovieHorizontalListview(movies: populargMovies, 
      loadNextPage: () {
        ref.read(popularMoviesProvider.notifier).loadNextPage();
      }, 
      title: 'Populares'),
      MovieHorizontalListview(movies: upcomingMovies, 
      loadNextPage: () {
        ref.read(upcomingMoviesProvider.notifier).loadNextPage();
      }, 
      title: 'Proximamente', 
      subTitle: 'En este mes'),
      // Expanded(
      //   child: ListView.builder(
      //   itemCount: nowPlayingMovies.length,
      //   itemBuilder: (context, index) {
      //     final movie = nowPlayingMovies[index];
      //     return ListTile(
      //       title: Text( movie.title ),
      //     );
      //   },
      //     ),
      // )
    ],);
      }, childCount: 1))
    ]);
  }
}