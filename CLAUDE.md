# CLAUDE.md
このFlutterプロジェクトのアーキテクチャ・設計ルール。

## アーキテクチャ
```
UI (Page / Widget / ViewModel / State)
  ↓
Domain (Usecase)  ※複数Repositoryをまたぐ処理がある場合のみ
  ↓
Domain (Repository interface) / Model
  ↓
Data (Repository実装)
  ↓
Data (Service：端末・外部サービス連携 remote/local)
```
- ドメインモデルは `domain/model` に定義。DTO→ドメインモデルの変換は **Repository層** で行う。
- Usecaseは複数Repositoryをまたぐ場合のみ作る。単一Repositoryで完結する処理はViewModelから直接Repositoryを呼ぶ。

## ディレクトリ構成
```
lib/
  core/
    config/   # 環境設定・グローバル定数 (constants.dart等)
    events/   # EventBus, AppEvent (sealed class), Ref拡張
    components/ # アプリ共通ウィジェットや画面等
    extensions/ # 標準API拡張機能 (BuildContextやEdgeInsetsなどAPIごとにファイルを作成)
    l10n/ # 言語ファイル処理
    router/ # ルーティング設定
    theme/ # デザイン関連のトークン
  data/
    service/  # remote/local の外部・端末連携
    repository/
  domain/
    model/
    usecase/     # 複数Repositoryをまたぐ処理
    repository/  # interface
  ui/
    <feature_name>/
      widgets/
      view_models/ # State, ViewModel

assets/
  lang/  # 多言語文言 (ja.json等)
```

## 状態管理 (Riverpod)
- 画面ごとに `State`(freezed)と `ViewModel`(`AsyncNotifier`)をセットで持つ。Providerは `@riverpod` で自動生成する(手書き禁止)。
- UI表示は共通 `AsyncWidget`(`core/components/async_widget.dart`)経由。エラー時にリトライボタンは設置しない。`skipLoadingOnReload`/`skipLoadingOnRefresh` を公開し、デフォルトはRiverpod標準(`false`/`true`)。
- **表示Stateとコマンドを分離する**: 初期表示データは `build()` で取得しStateに保持。ユーザー操作(ボタン等)のメソッドは `Future<void>` を返し、失敗時は例外をthrowするのみでStateには反映しない。UI側の `onPressed` 内で `try-catch` し、成功/失敗の後処理(遷移・エラー表示)を行う。
- **ローディング表示**は共通 `ProgressDialog`(`core/components/progress_dialog.dart`)を使う(`showDialog`の直書き禁止)。メッセージは呼び出し元が必ず指定する。ViewModelに `isLoading` は持たせない。
- **ViewModelから他ViewModel/Providerを`ref.watch`することは禁止**(ローディングの連鎖伝播を招くため)。機能をまたぐ通知は `EventBus`(`core/events/event_bus.dart`)を使う。イベントは `AppEvent` を実装するsealed classとして定義し、購読は `ref.listenEvent<T>()`(`core/events/ref_listen_event_x.dart`、provider破棄時に自動解除)。

## エラーハンドリング
- 例外は必ずドメイン固有のエラー型に変換する(Usecase層があればそこで、なければViewModelで)。
- 通信ログは **Dioのinterceptor** で出す。**prod環境では無効化**する。
- コマンド実行の成功/失敗通知は共通 `ResultDialog`(`core/components/result_dialog.dart`)に統一し、内容は sealed class `ResultDialogContent`(success/error)で渡す。`barrierDismissible: false`、リトライボタンなし。初期表示データ取得時のエラーは引き続き `AsyncWidget` のインライン表示のまま(ダイアログにしない)。

## 命名規則
- ファイル名: `snake_case.dart`
- クラス: `XxxViewModel` / `XxxRepository` / `XxxService` / `XxxUsecase`。すべて `@riverpod` でProvider自動生成。
- Model/Stateは `freezed` + `json_serializable` 必須。単一コンストラクタは `abstract class`、複数コンストラクタ(union型)は `sealed class`。

## コード生成
- `.freezed.dart` / `.g.dart` はコミット対象外。生成が必要になったタイミングで `build_runner` を実行する。

## ルーティング
- `go_router` を使用。遷移は `context.push(xxxRoute)`、ルートは定数化してUIから参照可能にする。

## API / ネットワーク
- `Dio` を使用。DTO→ドメインモデルの変換は **Repository層** で行う。

## アプリ初期化処理
- `PackageInfo` など、Futureだが起動後は不変のデータは `main.dart` で `await` し、`overrideWithValue` で注入する(ViewModelで都度取得しない)。`dioProvider` も同様に `main.dart` でインスタンス化して注入する。

## 定数の扱い
- グローバル定数は `core/config/constants.dart` に集約する。肥大化したらドメインごとにファイルを分割する。

## パッケージ追加の方針
- 「使えそう」という理由だけで追加しない。最終更新日・利用数を含め総合的に評価し、承認を得てから追加する。自前実装で十分ならそちらを優先。パッケージを使う場合はFlutter Favoriteを第一候補とする。

## UI
- `SafeArea` はスクロールするWidget内では使用禁止(top方向の非スクロール領域への適用は許可)。
- スクロールが発生するWidgetは、拡張関数EdgeInsets.withSafeBottomを使用。
- `Column`/`Row`の子要素間のスペースは `spacing` パラメータで表現する。ループ内で `if (index > 0) SizedBox(...)` のようにインデックス条件でスペーサーを差し込む書き方は禁止。スペース幅が均一でない場合は、無理に1つの `spacing` に収めようとせず、値が揃うまとまりごとに`Column`/`Row`を分けて、それぞれに`spacing`を設定する。
- `Column`/`Row`などの`children`に複数要素を並べる場合は`for`ではなく`.map(...).toList()`を使う。パフォーマンスやその他の理由で`for`が必要な場合は相談する。
- SizedBoxのスペース指定は禁止しGapを使用する。スペースは奇数ではなく2pxの倍数。

## ボタン
- `ElevatedButton`は禁止(Flutter標準のエレベーション/シャドウアニメーションが本デザインに合わないため)。代わりに`FilledButton`/`OutlinedButton`/`TextButton`を用途に応じて使い分ける。
- スタイルは`ButtonStyle`を直接組み立てず、各ウィジェットの`.styleFrom(...)`を使う。
- `.styleFrom`では`tapTargetSize: MaterialTapTargetSize.shrinkWrap`・`minimumSize: Size.zero`を指定し、サイズは`padding`で確保する。
- 活性/非活性の見た目・アニメーションは`onPressed`に`null`を渡すことでMaterialの標準動作に任せる。`Opacity`等で自前に非活性表現を実装しない。

## テスト
- 現時点では最低限のみ。網羅的なテスト戦略は今後の課題とする(全面自動生成させない)。
