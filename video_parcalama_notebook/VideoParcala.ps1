#  VIDEO PARCALAMA
#  - "çalışılacak" klasöründeki videoları işler
#  - Parçaları "çalışılacak\arşiv\<video adı>\" klasörüne koyar
#  - Orijinal videoyu "çalışılacak\arşiv\" klasörüne taşır
#  - Yeniden kodlama yapmaz (kalite / veri kaybı yok), anahtar karelerden keser
#  - Boyut modunda hiçbir parça hedef MB'ı geçmez (her parça kontrol edilir)

$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}
$Inv = [Globalization.CultureInfo]::InvariantCulture

$Kok     = Split-Path -Parent $MyInvocation.MyCommand.Path
$Calisma = Join-Path $Kok 'çalışılacak'
$Arsiv   = Join-Path $Calisma 'arşiv'
$Uzantilar = @('.mp4','.mkv','.mov','.avi','.wmv','.m4v','.webm','.flv','.ts','.mts','.m2ts','.mpg','.mpeg','.3gp')
$Bindirme = 2.0   # "tekrar" seçilirse her parçanın başına eklenecek en az süre (sn)

function Yaz($metin, $renk = 'Gray') { Write-Host $metin -ForegroundColor $renk }
function Sayi([double]$d) { $d.ToString('0.######', $Inv) }

function Arac-Bul($ad) {
    foreach ($aday in @((Join-Path $Kok "$ad.exe"), (Join-Path $Kok $ad))) {
        if (Test-Path -LiteralPath $aday -PathType Leaf) { return $aday }
    }
    $k = Get-Command $ad -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($k) { return $k.Source }
    return $null
}

function Sor-Sayi($soru, [int]$varsayilan, [int]$enAz) {
    while ($true) {
        $c = Read-Host $soru
        if ([string]::IsNullOrWhiteSpace($c) -and $varsayilan -gt 0) { return $varsayilan }
        $n = 0
        if ([int]::TryParse($c.Trim(), [ref]$n) -and $n -ge $enAz) { return $n }
        Yaz "  Lütfen $enAz veya daha büyük bir tam sayı girin." Yellow
    }
}

function Sor-EvetHayir($soru, [bool]$varsayilan) {
    $ipucu = if ($varsayilan) { '(E/H) [E]' } else { '(E/H) [H]' }
    while ($true) {
        $c = (Read-Host "$soru $ipucu").Trim().ToUpperInvariant()
        if ($c -eq '') { return $varsayilan }
        if ($c -in 'E','EVET','Y') { return $true }
        if ($c -in 'H','HAYIR','N') { return $false }
    }
}

# ---------------------------------------------------------------------------
# Videoyu analiz et: anahtar kareler + her paketin zamanı ve boyutu
# ---------------------------------------------------------------------------
function Analiz($dosya) {
    $akisCikti = & $script:FFPROBE -v error -show_entries 'stream=index,codec_type:stream_disposition=attached_pic' -of csv=p=0 -- $dosya
    $vIdx = -1; $sesler = New-Object 'System.Collections.Generic.HashSet[int]'
    foreach ($s in $akisCikti) {
        $p = $s.Split(',')
        if ($p.Count -lt 2) { continue }
        $i = [int]$p[0]
        if ($p[1] -eq 'video' -and $vIdx -lt 0 -and ($p.Count -lt 3 -or $p[2] -ne '1')) { $vIdx = $i }
        elseif ($p[1] -eq 'audio') { [void]$sesler.Add($i) }
    }
    if ($vIdx -lt 0) { throw 'Videoda görüntü akışı bulunamadı.' }

    $fmt = & $script:FFPROBE -v error -show_entries format=start_time,duration -of csv=p=0 -- $dosya
    $fp = ($fmt | Select-Object -First 1).Split(',')
    $baslangic = 0.0; $sure = 0.0
    [void][double]::TryParse($fp[0], [Globalization.NumberStyles]::Float, $Inv, [ref]$baslangic)
    [void][double]::TryParse($fp[1], [Globalization.NumberStyles]::Float, $Inv, [ref]$sure)

    $zaman = New-Object 'System.Collections.Generic.List[double]' 200000
    $boyut = New-Object 'System.Collections.Generic.List[double]' 200000
    $anahtar = New-Object 'System.Collections.Generic.List[double]'
    $NS = [Globalization.NumberStyles]::Float
    $satirlar = & $script:FFPROBE -v error -show_entries 'packet=stream_index,pts_time,dts_time,size,flags' -of csv=p=0 -- $dosya
    foreach ($l in $satirlar) {
        $p = $l.Split(',')
        if ($p.Count -lt 5) { continue }
        $si = [int]$p[0]
        $isV = ($si -eq $vIdx)
        if (-not $isV -and -not $sesler.Contains($si)) { continue }
        $t = 0.0
        if (-not [double]::TryParse($p[1], $NS, $Inv, [ref]$t)) {
            if (-not [double]::TryParse($p[2], $NS, $Inv, [ref]$t)) { continue }
        }
        $t -= $baslangic
        $zaman.Add($t); $boyut.Add([double]$p[3])
        if ($isV -and $p[4].Contains('K')) { $anahtar.Add($t) }
    }
    if ($anahtar.Count -eq 0) { throw 'Anahtar kare bulunamadı.' }

    $z = $zaman.ToArray(); $b = $boyut.ToArray()
    [Array]::Sort($z, $b)
    $kum = New-Object double[] ($z.Length + 1)
    for ($i = 0; $i -lt $z.Length; $i++) { $kum[$i + 1] = $kum[$i] + $b[$i] }
    $k = $anahtar.ToArray(); [Array]::Sort($k)
    $k = @($k | Select-Object -Unique)
    $son = [Math]::Max($sure, $z[$z.Length - 1] + 0.001)
    return [pscustomobject]@{ VIdx = $vIdx; Zaman = $z; Kum = $kum; Anahtar = $k; Sure = $son }
}

# t zamanından önceki paket sayısı (ikili arama)
function Once($z, [double]$t) {
    $lo = 0; $hi = $z.Length
    while ($lo -lt $hi) { $m = ($lo + $hi) -shr 1; if ($z[$m] -lt $t) { $lo = $m + 1 } else { $hi = $m } }
    return $lo
}
function Bayt($a, [double]$t1, [double]$t2) { $a.Kum[(Once $a.Zaman $t2)] - $a.Kum[(Once $a.Zaman $t1)] }

# t'den küçük/eşit en büyük anahtar kare
function AnahtarOnce($k, [double]$t) {
    $sonuc = $k[0]
    foreach ($x in $k) { if ($x -le $t + 1e-6) { $sonuc = $x } else { break } }
    return $sonuc
}

function En-Uzun-Aralik($a) {
    $k = $a.Anahtar; $m = 0.0
    for ($i = 0; $i -lt $k.Count; $i++) {
        $son = if ($i -lt $k.Count - 1) { $k[$i + 1] } else { $a.Sure }
        if ($son - $k[$i] -gt $m) { $m = $son - $k[$i] }
    }
    return $m
}

function Bindirmeli-Bas($a, [double]$s, [bool]$tekrar) {
    if (-not $tekrar -or $s -le $a.Anahtar[0] + 1e-6) { return $s }
    return (AnahtarOnce $a.Anahtar ($s - $script:Bindirme))
}

# ---------------------------------------------------------------------------
# Kesim planları: her parça = [Bas, Son) ; Kesim = bindirmesiz başlangıç
# ---------------------------------------------------------------------------
function Plan-Boyut($a, [double]$butce, [bool]$tekrar) {
    $parcalar = @()
    $k = $a.Anahtar
    $s = $k[0]
    $uyari = $false
    while ($true) {
        $bas = Bindirmeli-Bas $a $s $tekrar
        if ((Bayt $a $bas $a.Sure) -le $butce) {
            $parcalar += [pscustomobject]@{ Bas = $bas; Kesim = $s; Son = $a.Sure; Sonuncu = $true }
            break
        }
        $son = $null
        foreach ($x in $k) {
            if ($x -le $s + 1e-6) { continue }
            if ((Bayt $a $bas $x) -le $butce) { $son = $x } else { break }
        }
        if ($null -eq $son) {
            # Tek bir anahtar kare aralığı bile hedeften büyük: bir sonraki anahtar kareye kadar al
            $son = ($k | Where-Object { $_ -gt $s + 1e-6 } | Select-Object -First 1)
            if ($null -eq $son) { $son = $a.Sure }
            $uyari = $true
        }
        $parcalar += [pscustomobject]@{ Bas = $bas; Kesim = $s; Son = $son; Sonuncu = $false }
        $s = $son
        if ($s -ge $a.Sure - 1e-6) { $parcalar[-1].Sonuncu = $true; break }
    }
    $script:PlanSigmadi = $uyari
    return ,$parcalar
}

function Plan-Esit($a, [int]$n, [bool]$tekrar) {
    $k = $a.Anahtar
    $sinirlar = New-Object 'System.Collections.Generic.List[double]'
    $sinirlar.Add($k[0])
    for ($i = 1; $i -lt $n; $i++) {
        $hedef = $a.Sure * $i / $n
        $enYakin = $k[0]
        foreach ($x in $k) { if ([Math]::Abs($x - $hedef) -lt [Math]::Abs($enYakin - $hedef)) { $enYakin = $x } }
        if ($enYakin -gt $sinirlar[$sinirlar.Count - 1] + 1e-6) { $sinirlar.Add($enYakin) }
    }
    if ($sinirlar.Count -lt $n) { Yaz "  [!] Videoda yeterli anahtar kare yok, $($sinirlar.Count) parça yapılabildi." Yellow }
    $parcalar = @()
    for ($i = 0; $i -lt $sinirlar.Count; $i++) {
        $s = $sinirlar[$i]
        $sonuncu = ($i -eq $sinirlar.Count - 1)
        $son = if ($sonuncu) { $a.Sure } else { $sinirlar[$i + 1] }
        $parcalar += [pscustomobject]@{ Bas = (Bindirmeli-Bas $a $s $tekrar); Kesim = $s; Son = $son; Sonuncu = $sonuncu }
    }
    return ,$parcalar
}

# ---------------------------------------------------------------------------
# Parçaları ffmpeg ile kes (stream copy)
# ---------------------------------------------------------------------------
function Kes($dosya, $a, $parcalar, $hedefKlasor, $ad, $uz) {
    # 1) Videoyu tek geçişte, tam anahtar kare zamanlarından küçük bloklara böl
    #    (zamana atlama/seek kullanılmaz; böylece hiçbir kare kaybolmaz veya tekrarlanmaz)
    $k0 = $a.Anahtar[0]
    $sinirlar = @($parcalar | ForEach-Object { $_.Bas; $_.Kesim } | Where-Object { $_ -gt $k0 + 1e-6 } | Sort-Object -Unique)
    $B = @($k0) + $sinirlar   # blok i = [B[i], B[i+1])
    $gDir = Join-Path $hedefKlasor '_bloklar'
    New-Item -ItemType Directory -Force -Path $gDir | Out-Null

    $arg = @('-hide_banner', '-loglevel', 'error', '-stats', '-y', '-i', $dosya, '-map', "0:$($a.VIdx)", '-map', '0:a?', '-c', 'copy', '-map_metadata', '0')
    if ($sinirlar.Count -gt 0) {
        # Kesim zamanı, bir önceki anahtar kare ile kesilecek anahtar karenin arasına konur;
        # ffmpeg ilk uygun anahtar kareden keser, küçük zaman kaymaları sonucu değiştirmez.
        $zamanlar = ($sinirlar | ForEach-Object {
            $kk = $_; $onceki = $k0
            foreach ($x in $a.Anahtar) { if ($x -lt $kk - 1e-6) { $onceki = $x } else { break } }
            Sayi ($kk - [Math]::Min(0.5, ($kk - $onceki) / 2))
        }) -join ','
        $arg += @('-f', 'segment', '-segment_times', $zamanlar, '-reset_timestamps', '1', (Join-Path $gDir "b%05d$uz"))
    } else {
        $arg += @((Join-Path $gDir "b00000$uz"))
    }
    Yaz '  Kesiliyor...'
    & $script:FFMPEG @arg
    if ($LASTEXITCODE -ne 0) { throw 'ffmpeg kesim sırasında hata verdi.' }
    $bloklar = @(Get-ChildItem -LiteralPath $gDir -File | Sort-Object Name | ForEach-Object { $_.FullName })
    if ($bloklar.Count -ne $B.Count) { throw "Beklenen $($B.Count) blok yerine $($bloklar.Count) blok oluştu." }

    function BlokNo([double]$t) {
        for ($i = 0; $i -lt $B.Count; $i++) { if ([Math]::Abs($B[$i] - $t) -lt 1e-6) { return $i } }
        return $B.Count
    }

    # 2) Her parçayı ilgili bloklardan oluştur
    $ciktilar = @()
    $no = 0
    foreach ($p in $parcalar) {
        $no++
        $cikti = Join-Path $hedefKlasor ('{0}_parca{1:000}{2}' -f $ad, $no, $uz)
        $i1 = BlokNo $p.Bas
        $i2 = if ($p.Sonuncu) { $B.Count } else { BlokNo $p.Son }
        $secili = @($bloklar[$i1..($i2 - 1)])
        if ($secili.Count -eq 1) {
            Copy-Item -LiteralPath $secili[0] -Destination $cikti -Force
        } else {
            $liste = Join-Path $gDir 'liste.txt'
            $satirlar = $secili | ForEach-Object { "file '" + ($_ -replace "'", "'\''") + "'" }
            [IO.File]::WriteAllLines($liste, $satirlar, (New-Object Text.UTF8Encoding $false))
            $carg = @('-hide_banner', '-loglevel', 'error', '-y', '-f', 'concat', '-safe', '0', '-i', $liste, '-map', '0', '-c', 'copy')
            if ($uz -in '.mp4', '.m4v', '.mov') { $carg += @('-movflags', '+faststart') }
            & $script:FFMPEG @carg $cikti
            if ($LASTEXITCODE -ne 0) { throw "Parça $no birleştirilirken hata oluştu." }
        }
        $ciktilar += $cikti
    }
    Remove-Item -LiteralPath $gDir -Recurse -Force -ErrorAction SilentlyContinue
    return ,$ciktilar
}

function Sure-Oku($dosya) {
    $d = 0.0
    $o = & $script:FFPROBE -v error -show_entries format=duration -of csv=p=0 -- $dosya | Select-Object -First 1
    [void][double]::TryParse($o, [Globalization.NumberStyles]::Float, $Inv, [ref]$d)
    return $d
}

function Kare-Say($dosya, $secici) {
    $o = & $script:FFPROBE -v error -select_streams $secici -count_packets -show_entries stream=nb_read_packets -of csv=p=0 -- $dosya | Select-Object -First 1
    $n = 0L; [void][long]::TryParse(("$o").Trim(','), [ref]$n); return $n
}

# ---------------------------------------------------------------------------
# Tek video
# ---------------------------------------------------------------------------
function Video-Isle($dosyaBilgi, $ayar) {
    $dosya = $dosyaBilgi.FullName
    $ad = [IO.Path]::GetFileNameWithoutExtension($dosya)
    $uz = $dosyaBilgi.Extension.ToLowerInvariant()
    $limit = [double]$ayar.MB * 1MB

    Yaz ''
    Yaz ('=' * 60) Cyan
    Yaz (" {0}   ({1:N1} MB)" -f $dosyaBilgi.Name, ($dosyaBilgi.Length / 1MB)) Cyan
    Yaz ('=' * 60) Cyan

    if ($ayar.Mod -eq 1 -and $dosyaBilgi.Length -le $limit) {
        Yaz "  Video zaten $($ayar.MB) MB'dan küçük, parçalanmadı. Arşive taşınıyor." Green
        Move-Item -LiteralPath $dosya -Destination (Benzersiz-Yol (Join-Path $Arsiv $dosyaBilgi.Name))
        return
    }

    Yaz '  Video analiz ediliyor (büyük dosyalarda biraz sürebilir)...'
    $kaynak = $dosya
    $gecici = $null
    $tekrar = [bool]$ayar.Tekrar
    $a = Analiz $kaynak
    $orjVIdx = $a.VIdx
    Yaz ("  Süre: {0}   Anahtar kare sayısı: {1}   En uzun anahtar kare aralığı: {2:0.0} sn" -f [TimeSpan]::FromSeconds([Math]::Round($a.Sure)), $a.Anahtar.Count, (En-Uzun-Aralik $a))

    $hedefKlasor = Benzersiz-Yol (Join-Path $Arsiv $ad)
    New-Item -ItemType Directory -Force -Path $hedefKlasor | Out-Null

    # Kayıpsız (yeniden kodlamadan) hedef boyuta sığıyor mu?
    if ($ayar.Mod -eq 1) {
        [void](Plan-Boyut $a ($limit * 0.985) $tekrar)
        if ($script:PlanSigmadi -and $tekrar) {
            [void](Plan-Boyut $a ($limit * 0.985) $false)
            if (-not $script:PlanSigmadi) {
                $tekrar = $false
                Yaz "  [i] 2 sn tekrar bu videoda $($ayar.MB) MB sınırına sığmıyor; bu video için tekrar iptal edildi." Yellow
            } else { $script:PlanSigmadi = $true }
        }
        if ($script:PlanSigmadi) {
            $tekrar = $false
            Yaz ''
            Yaz "  [!] Bu videoda anahtar kareler çok seyrek. Video yeniden kodlanmadan" Yellow
            Yaz "      $($ayar.MB) MB sınırına sığdırılamıyor (2 sn tekrar da iptal edildi)." Yellow
            Yaz '  Ne yapılsın?' White
            $secenekler = @()
            $secenekler += 'kodla';  Yaz ("   [{0}] Yeniden kodlayarak kes (yavaş; görüntü çok yüksek kalitede, ses aynen kopyalanır," -f $secenekler.Count)
            Yaz  '       her saniyeye anahtar kare konur, böylece tüm parçalar sınıra sığar)'
            $secenekler += 'boyle';  Yaz ("   [{0}] Yine de kayıpsız kes (bazı parçalar {1} MB'ı aşar)" -f $secenekler.Count, $ayar.MB)
            $sec = Sor-Sayi "  Seçiminiz [1]" 1 1
            if ($sec -gt $secenekler.Count) { $sec = 1 }
            switch ($secenekler[$sec - 1]) {
                'kodla' {
                    $gUz = if ($uz -in '.mp4', '.mov', '.m4v', '.mkv') { $uz } else { '.mkv' }
                    $gecici = Join-Path $hedefKlasor ("_gecici_kodlama$gUz")
                    Yaz '  Yeniden kodlanıyor... (videonun uzunluğuna göre uzun sürebilir)' Cyan
                    & $script:FFMPEG -hide_banner -loglevel error -stats -y -i $dosya -map "0:$($a.VIdx)" -map '0:a?' `
                        -c:v libx264 -preset medium -crf 17 -pix_fmt yuv420p -fps_mode passthrough `
                        -force_key_frames 'expr:gte(t,n_forced*1)' -c:a copy -map_metadata 0 $gecici
                    if ($LASTEXITCODE -ne 0) { throw 'Yeniden kodlama başarısız oldu.' }
                    $kaynak = $gecici
                    $uz = $gUz
                    $a = Analiz $kaynak
                }
            }
        }
    }

    $oran = 0.985
    for ($deneme = 1; $deneme -le 6; $deneme++) {
        if ($ayar.Mod -eq 1) { $plan = Plan-Boyut $a ($limit * $oran) $tekrar }
        else                 { $plan = Plan-Esit  $a $ayar.Parca $tekrar }
        Yaz ("  {0} parça çıkarılacak." -f $plan.Count)
        $ciktilar = Kes $kaynak $a $plan $hedefKlasor $ad $uz
        if ($ayar.Mod -ne 1 -or $script:PlanSigmadi -or $deneme -eq 6) { break }
        $buyuk = @($ciktilar | Where-Object { (Get-Item -LiteralPath $_).Length -gt $limit })
        if ($buyuk.Count -eq 0) { break }
        Yaz ("  [!] {0} parça hedefi aştı, daha küçük parçalarla yeniden kesiliyor..." -f $buyuk.Count) Yellow
        $ciktilar | ForEach-Object { Remove-Item -LiteralPath $_ -Force }
        $oran *= 0.96
    }

    # --- Kontrol ve rapor ---
    Yaz ''
    Yaz '  Parçalar:' White
    $no = 0; $toplamYeni = 0.0; $hata = $false
    foreach ($c in $ciktilar) {
        $p = $plan[$no]; $no++
        $fi = Get-Item -LiteralPath $c
        $mb = $fi.Length / 1MB
        $renk = 'Green'; $not = ''
        if ($ayar.Mod -eq 1 -and $fi.Length -gt $limit) { $renk = 'Red'; $not = '  <-- HEDEFİ AŞIYOR'; $hata = $true }
        $tekrarNot = if ($p.Bas -lt $p.Kesim - 1e-6) { '  (+{0:0.0} sn tekrar)' -f ($p.Kesim - $p.Bas) } else { '' }
        Yaz ("   {0,-40} {1,8:N1} MB   {2}{3}{4}" -f $fi.Name, $mb, [TimeSpan]::FromSeconds([Math]::Round($p.Son - $p.Bas)), $tekrarNot, $not) $renk
        $toplamYeni += ($p.Son - $p.Kesim)
    }

    # Veri kaybı kontrolü: görüntü karesi ve ses paketi sayılarını karşılaştır
    $orjKare = Kare-Say $dosya "$orjVIdx"
    $orjSes  = Kare-Say $dosya 'a:0'
    $parcaKare = 0L; $parcaSes = 0L
    foreach ($c in $ciktilar) { $parcaKare += (Kare-Say $c 'v:0'); $parcaSes += (Kare-Say $c 'a:0') }
    $fazla = if ($tekrar) { ' (fazlası tekrar edilen kısımlar)' } else { '' }
    if ($orjKare -gt 0 -and $parcaKare -ge $orjKare -and $parcaSes -ge $orjSes) {
        Yaz ("  [OK] Veri kaybı yok: görüntü {0} -> {1} kare, ses {2} -> {3} paket{4}." -f $orjKare, $parcaKare, $orjSes, $parcaSes, $fazla) Green
    } else {
        Yaz ("  [!] Eksik veri: görüntü {0} -> {1} kare, ses {2} -> {3} paket." -f $orjKare, $parcaKare, $orjSes, $parcaSes) Red
        $hata = $true
    }

    if ($gecici) { Remove-Item -LiteralPath $gecici -Force -ErrorAction SilentlyContinue }
    if ($hata) {
        Yaz '  Orijinal video yerinde bırakıldı (sorun olduğu için arşive taşınmadı).' Yellow
    } else {
        Move-Item -LiteralPath $dosya -Destination (Benzersiz-Yol (Join-Path $Arsiv $dosyaBilgi.Name))
        Yaz "  Orijinal video arşive taşındı." Green
    }
    Yaz "  Parça klasörü: $hedefKlasor" Green
}

function Benzersiz-Yol($yol) {
    if (-not (Test-Path -LiteralPath $yol)) { return $yol }
    $dizin = Split-Path -Parent $yol
    $ad = [IO.Path]::GetFileNameWithoutExtension($yol)
    $uz = [IO.Path]::GetExtension($yol)
    for ($i = 2; ; $i++) {
        $y = Join-Path $dizin ("{0} ({1}){2}" -f $ad, $i, $uz)
        if (-not (Test-Path -LiteralPath $y)) { return $y }
    }
}

# ===========================================================================
# ANA PROGRAM
# ===========================================================================
try { Clear-Host } catch {}
Yaz ('=' * 60) Cyan
Yaz '                  VİDEO PARÇALAMA ARACI' Cyan
Yaz ('=' * 60) Cyan
Yaz " Kaynak : $Calisma"
Yaz " Hedef  : $Arsiv"
Yaz ''

New-Item -ItemType Directory -Force -Path $Calisma, $Arsiv | Out-Null

$script:FFMPEG = Arac-Bul 'ffmpeg'
$script:FFPROBE = Arac-Bul 'ffprobe'
if (-not $script:FFMPEG -or -not $script:FFPROBE) {
    Yaz '[!] ffmpeg bulunamadı.' Yellow
    $kur = Join-Path $Kok 'FFmpegKur.bat'
    if ((Test-Path -LiteralPath $kur) -and (Sor-EvetHayir 'Şimdi otomatik indirilsin mi?' $true)) {
        Start-Process -FilePath 'cmd.exe' -ArgumentList '/c', "`"$kur`"" -Wait
        $script:FFMPEG = Arac-Bul 'ffmpeg'
        $script:FFPROBE = Arac-Bul 'ffprobe'
    }
    if (-not $script:FFMPEG -or -not $script:FFPROBE) {
        Yaz 'ffmpeg olmadan devam edilemiyor. FFmpegKur.bat dosyasını çalıştırın.' Red
        return
    }
}

while ($true) {
    $videolar = @(Get-ChildItem -LiteralPath $Calisma -File | Where-Object { $Uzantilar -contains $_.Extension.ToLowerInvariant() } | Sort-Object Name)
    if ($videolar.Count -eq 0) {
        Yaz "Klasörde video yok. Videoları şu klasöre koyun:" Yellow
        Yaz "  $Calisma" Yellow
        try { Start-Process explorer.exe -ArgumentList "`"$Calisma`"" } catch {}
        if (-not (Sor-EvetHayir 'Videoları koyduktan sonra devam edilsin mi?' $true)) { return }
        continue
    }

    Yaz "İşlenecek videolar ($($videolar.Count)):" White
    $videolar | ForEach-Object { Yaz ("  - {0}   ({1:N1} MB)" -f $_.Name, ($_.Length / 1MB)) }
    Yaz ''
    Yaz 'Nasıl parçalansın?' White
    Yaz '  [1] Boyuta göre  - her parça en fazla X MB   (varsayılan)'
    Yaz '  [2] Eşit parçaya göre - kaç parça olacağını siz seçin'
    $mod = Sor-Sayi 'Seçiminiz [1]' 1 1
    if ($mod -ne 2) { $mod = 1 }
    $ayar = [pscustomobject]@{ Mod = $mod; MB = 190; Parca = 0; Tekrar = $false }
    if ($mod -eq 1) { $ayar.MB = Sor-Sayi 'Parça boyutu kaç MB olsun? [190]' 190 1 }
    else            { $ayar.Parca = Sor-Sayi 'Kaç eşit parçaya bölünsün?' 0 2 }
    Yaz ''
    Yaz 'Kesim yerlerinde her parçanın başına bir önceki parçanın son ~2 saniyesi' White
    Yaz 'tekrar eklensin mi? (Geçişlerde hiçbir an kaçmaz; parçalar biraz büyür.)' White
    $ayar.Tekrar = Sor-EvetHayir 'Kesimde 2 sn tekrar alınsın mı?' $false

    foreach ($v in $videolar) {
        try { Video-Isle $v $ayar }
        catch { Yaz ("  [HATA] {0}: {1}" -f $v.Name, $_.Exception.Message) Red }
    }

    Yaz ''
    Yaz ('=' * 60) Cyan
    Yaz ' Tüm işlemler tamamlandı.' Cyan
    Yaz ('=' * 60) Cyan
    try { Start-Process explorer.exe -ArgumentList "`"$Arsiv`"" } catch {}
    if (-not (Sor-EvetHayir 'Klasöre yeni videolar koyup tekrar çalıştırmak ister misiniz?' $false)) { break }
}
