import 'package:app/ui/launch/view_models/launch_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'launch_view_model.g.dart';

/// 起動時にオンボーディングとメイン画面のどちらへ進むかを決める。
///
/// 本来は端末に保存したユーザー ID か、導入後の Supabase の認証セッションで
/// 分岐させる。どちらもまだ未接続なので、起動は常にオンボーディングへ進む。
/// 下の処理をその判定に置き換えれば、フローの残りはそのままでよい。
@riverpod
class LaunchViewModel extends _$LaunchViewModel {
  @override
  Future<LaunchState> build() async {
    // TODO(auth): 保存済みのユーザー ID / Supabase セッションを解決し、
    // 学習者の設定が済んでいれば LaunchDestination.main を返す。
    return const LaunchState(destination: LaunchDestination.onboarding);
  }
}
