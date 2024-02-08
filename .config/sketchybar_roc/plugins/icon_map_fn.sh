function icon_map() {
  case "$1" in
  "Keynote" | "Keynote 讲演")
    icon_result=":keynote:"
    ;;
  "Alacritty" | "Hyper" | "iTerm2" | "kitty" | "Terminal" | "终端" | "WezTerm")
    icon_result="󰆍"
    if grep -q "brew" <<<$2; then
      icon_result="󰏓"
    fi
    if grep -q "nvim" <<<$2; then
      icon_result="󰅨"
    fi
    ;;
  "Microsoft To Do" | "Things")
    icon_result=":things:"
    ;;
  "App Store")
    icon_result=":app_store:"
    ;;
  "Microsoft Excel")
    icon_result=":microsoft_excel:"
    ;;
  "Microsoft PowerPoint")
    icon_result=":microsoft_power_point:"
    ;;
  "1Password")
    icon_result=":one_password:"
    ;;
  "Typora")
    icon_result=":text:"
    ;;
  "Sequel Pro")
    icon_result=":sequel_pro:"
    ;;
  "Reminders" | "提醒事项")
    icon_result=":reminders:"
    ;;
  "Finder" | "访达")
    icon_result=":finder:"
    ;;
  "Notes" | "备忘录")
    icon_result=":notes:"
    ;;
  "Notion")
    icon_result=":notion:"
    ;;
  "Spotlight")
    icon_result=":spotlight:"
    ;;
  "Code" | "Code - Insiders")
    icon_result=":code:"
    ;;
  "Final Cut Pro")
    icon_result=":final_cut_pro:"
    ;;
  "Chromium" | "Google Chrome" | "Google Chrome Canary" | "Thorium")
    icon_result=":google_chrome:"
    ;;
  "GitHub Desktop")
    icon_result=":git_hub:"
    ;;
  "Slack")
    icon_result=":slack:"
    ;;
  "Neovide" | "MacVim" | "Vim" | "VimR")
    icon_result=":vim:"
    ;;
  "Color Picker" | "数码测色计")
    icon_result=":color_picker:"
    ;;
  "Default")
    icon_result=":default:"
    ;;
  "Pages" | "Pages 文稿")
    icon_result=":pages:"
    ;;
  "Canary Mail" | "HEY" | "Mail" | "Mailspring" | "MailMate" | "邮件")
    icon_result=":mail:"
    ;;
  "Music" | "音乐")
    icon_result=":music:"
    ;;
  "Calendar" | "日历" | "Fantastical" | "Cron" | "Amie")
    icon_result=":calendar:"
    ;;
  "Evernote Legacy")
    icon_result=":evernote_legacy:"
    ;;
  "Microsoft Word")
    icon_result=":microsoft_word:"
    ;;
  "Safari" | "Safari浏览器" | "Safari Technology Preview")
    icon_result=":safari:"
    ;;
  "Xcode")
    icon_result=":xcode:"
    ;;
  "Numbers" | "Numbers 表格")
    icon_result=":numbers:"
    ;;
  "微信")
    icon_result=":wechat:"
    ;;
  "Replit")
    icon_result=":replit:"
    ;;
  "Preview" | "预览" | "Skim" | "zathura")
    icon_result=":pdf:"
    ;;
  "VSCodium")
    icon_result=":vscodium:"
    ;;
  "Podcasts" | "播客")
    icon_result=":podcasts:"
    ;;
  "Alfred")
    icon_result=":alfred:"
    ;;
  "Insomnia")
    icon_result=":insomnia:"
    ;;
  "Affinity Photo")
    icon_result=":affinity_photo:"
    ;;
  "Messages" | "信息" | "Nachrichten")
    icon_result=":messages:"
    ;;
  "FaceTime" | "FaceTime 通话")
    icon_result=":face_time:"
    ;;
  "Grammarly Editor")
    icon_result=":grammarly:"
    ;;
  "Microsoft Teams" | "Microsoft Teams (work or school)")
    icon_result=":microsoft_teams:"
    ;;
  "System Preferences" | "System Settings" | "系统设置")
    icon_result=":gear:"
    ;;
  "Webex")
    icon_result="󰍫"
    ;;
  *)
    icon_result=":default:"
    ;;
  "CMD")
    icon_result="󰘳"
    ;;
  esac
}

icon_map "$1"

echo "$icon_result"
