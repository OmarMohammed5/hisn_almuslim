// 1) In pubspec.yaml, add:
//
// dependencies:
//   http: ^1.6.0
//   youtube_player_iframe: ^5.2.2
//
// 2) Before runApp, after your existing DI setup:
//
// await LecturesDependencies.register(getIt);
//
// 3) Add a route such as:
//
// AppRoutes.lectures = '/lectures';
//
// 4) Route builder:
//
// return BlocProvider(
//   create: (_) => LecturesDependencies.createCubit(getIt),
//   child: LecturesScreen(
//     preferences: getIt<SharedPreferences>(),
//   ),
// );
//
// 5) Start the app with:
// flutter run --dart-define=YOUTUBE_API_KEY=YOUR_RESTRICTED_KEY
//
// Production recommendation:
// move YouTube Data API calls to your backend and let Flutter consume your
// cached endpoint. Keep the IFrame player in Flutter.
