import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kampus/blocs/campus_news/campus_news_bloc.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/buttons.dart';
import 'package:kampus/ui/widgets/home_campus_news.dart';
import 'package:kampus/ui/widgets/skeleton.dart';
import 'package:shimmer/shimmer.dart';

class BuildCampusNews extends StatelessWidget {
  const BuildCampusNews({super.key});

  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: whiteColor,
      ),
      child: BlocProvider(
        create: (context) => CampusNewsBloc()..add(CampusNewsGet()),
        child: BlocBuilder<CampusNewsBloc, CampusNewsState>(
          builder: (context, state) {
            if (state is CampusNewsLoading) {
              return Container(
                padding: const EdgeInsets.all(22),
                alignment: Alignment.centerLeft,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.white,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Skeleton(
                            height: 12,
                            width: 180,
                          ),
                          Skeleton(
                            height: 12,
                            width: 80,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Skeleton(
                        height: 150,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is CampusNewsSuccess) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Campus News',
                          style: blackTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                          ),
                        ),
                        CustomButtonOutline(
                          title: 'All News',
                          onTap: () {
                            Navigator.pushNamed(context, '/campus-news');
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: state.campusnews.map((campusNewsMethod) {
                        const SizedBox(
                          width: 18,
                        );
                        return HomeCampusNews(
                          campusNewsMethod: campusNewsMethod,
                          onTap: () {
                            Navigator.pushNamed(context, '/campus-news-detail',
                                arguments: campusNewsMethod.idberita);
                          },
                        );
                      }).toList(),
                    ),
                  )
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
