#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

InstaScript() {

    ; Get list of hashtags from hashtags.txt
    hashtags := Object()
    Loop, read, % A_ScriptDir "\hashtags.txt"
        hashtags[A_Index] := A_LoopReadLine

    ; How many posts we want to like
    Posts = 9 ; 15

    ; How many posts we have liked
    LikedPosts = 0;

    wb := ComObjCreate("InternetExplorer.Application")
    wb.Visible := true


    For i in  hashtags {

        ; The hashtag we want to like

        hash := hashtags[i]

        StringReplace , hash, hash, %A_Space%,,All

        HashTag := hash

        ; Stuff we need for the script to work
        Url = https://www.instagram.com/explore/tags/%HashTag%/
        QuerySelector = a[href*='%HashTag%']

        wb.Navigate(Url)

        while wb.busy or wb.ReadyState != 4
            Sleep 0

        ; wait 5 seconds before getting the links so that the page is populated
        Sleep 2000

        ; this is the first link on the page
        Links := wb.document.querySelectorAll(QuerySelector)

        if (Links.length < 0) {
            break
        }

        ; Click that first link
        Links[0].Click()

        ; Loop through 15 posts
        Loop %Posts% {

            ; Set Variables for Like action Interval
            low = 10   ; 42
            high = 15  ; 60
            Random, Time_To_Wait, low, high

            ; Set variable for Randomizer
            Random, FRand, 1, 5

            ; This will click through a random number of times so that we aren't liking every post in a row.
            ; It will only do it if the FRand number is three though, so it is programmed chaos.
            if FRand = 3
            {

                Random, ClickTimes, 1, 5

                Loop %ClickTimes% {

                    ; Get the next arrow
                    NextArrow := wb.document.getElementsByClassName("_3a693")

                    Sleep 3000
                    NextArrow[0].Click()

                }

            }

            InnerLinks := wb.document.getElementsByClassName("_eszkz _l9yih")

            ; Wait this long before liking the post and moving on to the next
            Sleep, Time_To_Wait * 1000

            ; This only likes the post if we haven't liked it already.
            if (wb.document.getElementsByClassName("coreSpriteHeartOpen").length > 0) {
                ; Click that heart
                InnerLinks[0].Click()
                LikedPosts += 1
            }

            Random, FollowRand, 1, 10
            ; Randomly follow people.
            if FollowRand = 2
            {
                FollowLink := wb.document.getElementsByClassName("_qv64e")
                Sleep 3000
                FollowLink[0].Click()
            }

            ; Get the next arrow
            NextArrow := wb.document.getElementsByClassName("_3a693")

            Sleep 4000

            if NextArrow.length > 0 {
                NextArrow[0].Click()
            } else {
                break
            }

        }

    }

    if (i == hashtags.length) {
        Sleep 3600000
        instaScript()
    }

}

instaScript()

Esc::ExitApp
