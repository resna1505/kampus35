import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kampus/blocs/campus_news/campus_news_bloc.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/list_campus_news.dart';

class CampusNews extends StatelessWidget {
  const CampusNews({super.key});

  Future<void> _refreshData(BuildContext context) async {
    context.read<CampusNewsBloc>().add(CampusNewsGet());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          'Berita Kampus',
          style: blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: semiBold,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => CampusNewsBloc()..add(CampusNewsGet()),
        child: BlocBuilder<CampusNewsBloc, CampusNewsState>(
          builder: (context, state) {
            if (state is CampusNewsSuccess) {
              return RefreshIndicator(
                onRefresh: () => _refreshData(context),
                child: ListView(
                  children: state.campusnews.map((campusNewsMethod) {
                    return ListCampusNews(
                      campusNewsMethod: campusNewsMethod,
                      onTap: () {
                        Navigator.pushNamed(context, '/campus-news-detail',
                            arguments: campusNewsMethod.idberita);
                      },
                    );
                  }).toList(),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
