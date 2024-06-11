function cgen([char]$char, [int]$length) {
    for($i=1; $i -le $length; $i++){$str=$str += $char}
    return $str;
}

function Write-Color($info, $color, $newline, $color2) {
    if (!$color2) {$color2 = (get-host).ui.rawui.ForegroundColor}
    Write-Host "$($info[0])" -ForegroundColor $color -NoNewline
    if ($newline -eq $false) { Write-Host "$($info[1])" -ForegroundColor $color2 -NoNewline }
    else { Write-Host "$($info[1])" -ForegroundColor $color2 }
}

function SorroundWithChar($chars, $str) {
    $nchars = $chars.split("-")
    if ($nchars.length -gt 1) {
        return $nchars[0]+$str+$nchars[1]
    } else {
        return $str;
    }
}