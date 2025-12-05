# Chrome Multi-Tab Auto Launcher (AutoHotkey) 

## 概要

このスクリプトは、`Ctrl + ↑` のショートカットひとつで **Google Chrome を起動し、複数のWebサイトを自動で新しいタブに開く**ための自動化ツールです。  

大学のLMSや日常的にアクセスするサイトを手動で入力する手間を省き、作業開始の手順を短縮する目的で作成しました。AutoHotkey v2 で動作します。

---

## 機能

###  ショートカット起動  
- `Ctrl + ↑`  
　→ Chromeを起動 or 既存ウィンドウをアクティブ化  
　→ 設定したURLを順に新しいタブで開く

### ✔ 自動IME制御（英数入力強制）  
URL入力時に日本語入力がONだと、

https:// → ｈｔｔｐｓ：／／

のように文字化けしてしまう問題があります。  

このスクリプトではURL送信前に **IMEの状態を取得し、ONの場合にのみ 半角/全角キーを送信してOFFに切り替える方式**を採用しています。

- トグル操作ではなく **状態判定付き制御**
- CapsLockや無変換キー方式と異なり、  
　**キーボードLEDの変化や予期しない文字変換が発生しない**
- 日本語環境でも安定して英数入力状態に統一される

---

## 使用方法

1. AutoHotkey v2 をインストール  
2. このリポジトリをDLまたはClone  
3. `url_open_command.ahk` を好きな場所に配置  
4. スクリプト内の `urls` を用途に合わせて編集：

```autohotkey
urls := [
    "https://example0.com/",
    "https://example1.com/",
    "https://example2.com/",
    "https://example3.com/"
]
```

5. ファイルを実行し、Ctrl + ↑ を押して動作確認

---

## コードのポイント
```IME制御ロジック
ForceIME_Off() {
    if (GetIMEStatus() = 1) {
        Send("{vkF4}") ; 半角/全角キー
        Sleep(80)
    }
}
```

- GetIMEStatus() で現在IMEがONか判定
- ONのときにだけIME切り替え信号を送る
- 環境依存が少なく、日本語IMEでも安定動作

```Chrome起動処理
pid := ProcessExist("chrome.exe")
if pid {
    WinActivate("ahk_pid " pid)
} else {
    Run('"C:\Program Files\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 2"')
}
```

- Chromeが既に起動している場合 → 再起動せず前面に表示

- 未起動のときだけ → 指定プロファイルで起動

---

## 改善の過程（制作意図）

開発中、IME制御の安定化が課題でした。

### 試行した方式：

方式	結果

IME API (0x283) 単体 → 一部環境で動作不安定  
CapsLock送信方式 → 動作するがLED点灯など副作用が発生  
無変換キー送信方式 → IME設定に引きずられ別動作になる場合あり  
半角/全角＋IME状態判定方式 → 最も安定・副作用なし → 採用  

最終的に、**状態判定 → 必要時のみ切り替え**というロジックに到達し、
環境差による挙動のズレを最小化しました。

---

## 今後の拡張案

- URLを外部ファイル(urls.json等)から読み込む方式
- GUIによるURL編集機能
- プロファイル切り替えの自動化
- サイトごとの自動ログイン補助（利用規約範囲内）

---

### 動作環境
Windows 10 / 11
AutoHotkey v2

### License
MIT License
