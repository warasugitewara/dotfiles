# Adguard ユーザールール (Youtube shorts用)
 ```text
! YouTube 左側の「ショート」メニューを非表示
youtube.com##ytd-guide-entry-renderer a[title="ショート"]
youtube.com##ytd-mini-guide-entry-renderer a[title="ショート"]
youtube.com##ytd-guide-entry-renderer a[title="Shorts"]
youtube.com##ytd-mini-guide-entry-renderer a[title="Shorts"]

! ホーム画面や検索結果のショート動画の棚（リール）を非表示
youtube.com##ytd-rich-shelf-renderer[is-shorts]
youtube.com##ytd-reel-shelf-renderer
! チャンネルページ「ショート」タブ（新スタイル 2023.10〜）
www.youtube.com##yt-tab-shape:has-text(/^Shorts$/)
www.youtube.com##yt-tab-shape:has-text(/^ショート$/)
! チャンネルページ「ショート」タブ（旧スタイル）
www.youtube.com##tp-yt-paper-tab:has(.tp-yt-paper-tab:has-text(Shorts))
www.youtube.com##tp-yt-paper-tab:has(.tp-yt-paper-tab:has-text(ショート))
 ```
# Adguard Home DNS (ブロックするサービス)
<img width="1032" height="602" alt="Screenshot 2026-06-08 02 43 42" src="https://github.com/user-attachments/assets/5617e5ad-6f11-486a-8a07-dd5a3663bf2d" />

*+* Temu, Tiktok
