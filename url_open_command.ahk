#Requires AutoHotkey v2
SendMode("Input")

^Up::{
    ForceIME_Off()

    pid := ProcessExist("chrome.exe")
    if pid {
        WinActivate("ahk_pid " pid)
    } else {
        Run('"C:\Program Files\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 2"')
        Sleep(900)
    }

    Sleep(200)

    urls := [
        "https://lms.is.saga-u.ac.jp/",
        "https://example1.com/",
        "https://example2.com/",
        "https://example3.com/"
    ]

    for url in urls {
        Send("^t")
        Sleep(200)
        ForceIME_Off()
        Send(url "{Enter}")
        Sleep(300)
    }
}


; ----------- IME強制OFF関数（最安定版） -----------

ForceIME_Off() {
    if (GetIMEStatus() = 1) {
        Send("{vkF4}") ; ← 半角/全角キー
        Sleep(80)
    }
}


; ----------- IME状態取得（0=英数, 1=日本語） -----------

GetIMEStatus() {
    hwnd := WinGetID("A")
    return DllCall("SendMessage", "Ptr", hwnd, "UInt", 0x283, "Int", -1, "Int", 0)
}
