#  VIDEO TRANSKRİPT
#  - "çalışılacak\arşiv" içindeki her video klasörü için transkript üretir
#  - Her parça için:   arşiv\<video adı>\transkript\<parça adı>.txt ve .srt (zaman kodlu altyazı)
#  - Klasör için tek dosya: arşiv\<video adı>\<video adı>_transkript.txt (tüm parçalar sırayla)
#  - İnternete gönderilmez; whisper.cpp ile bu bilgisayarda çalışır

$ErrorActionPreference = 'Stop'
try { [Console]::OutputEncoding = [Text.Encoding]::UTF8 } catch {}

$Kok       = Split-Path -Parent $MyInvocation.MyCommand.Path
$Arsiv     = Join-Path (Join-Path $Kok 'çalışılacak') 'arşiv'
$WhisperDir = Join-Path $Kok 'whisper'
$Uzantilar = @('.mp4','.mkv','.mov','.avi','.wmv','.m4v','.webm','.flv','.ts','.mts','.m2ts','.mpg','.mpeg','.3gp')
$WhisperZip = @(
    'https://github.com/ggml-org/whisper.cpp/releases/download/v1.9.0/whisper-bin-x64.zip',
    'https://github.com/ggml-org/whisper.cpp/releases/download/v1.8.3/whisper-bin-x64.zip'
)
$Modeller = @(
    [pscustomobject]@{ Ad = 'Yüksek kalite (önerilen)'; Dosya = 'ggml-large-v3-turbo-q5_0.bin'; Boyut = '~550 MB' },
    [pscustomobject]@{ Ad = 'Hızlı (daha düşük doğruluk)'; Dosya = 'ggml-small.bin'; Boyut = '~470 MB' }
)
$ModelUrl = 'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/'

function Yaz($metin, $renk = 'Gray') { Write-Host $metin -ForegroundColor $renk }

function Arac-Bul($ad, $dizinler) {
    foreach ($d in $dizinler) {
        foreach ($aday in @((Join-Path $d "$ad.exe"), (Join-Path $d $ad))) {
            if (Test-Path -LiteralPath $aday -PathType Leaf) { return $aday }
        }
    }
    $k = Get-Command $ad -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($k) { return $k.Source }
    return $null
}

function Sor-Sayi($soru, [int]$varsayilan, [int]$enAz, [int]$enCok) {
    while ($true) {
        $c = Read-Host $soru
        if ([string]::IsNullOrWhiteSpace($c)) { return $varsayilan }
        $n = 0
        if ([int]::TryParse($c.Trim(), [ref]$n) -and $n -ge $enAz -and $n -le $enCok) { return $n }
        Yaz "  Lütfen $enAz ile $enCok arasında bir sayı girin." Yellow
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

function Indir($url, $hedef) {
    $curl = Get-Command curl.exe -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $curl) { $curl = Get-Command curl -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1 }
    if ($curl) {
        & $curl.Source -L --fail --retry 2 --connect-timeout 20 --progress-bar -o $hedef $url
        return ($LASTEXITCODE -eq 0)
    }
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        (New-Object Net.WebClient).DownloadFile($url, $hedef)
        return $true
    } catch { Yaz "  $($_.Exception.Message)" Red; return $false }
}

# ---------------------------------------------------------------------------
# Kurulum: whisper-cli + model (ilk seferde bir kez)
# ---------------------------------------------------------------------------
function Whisper-Kur {
    New-Item -ItemType Directory -Force -Path $WhisperDir | Out-Null
    $cli = Arac-Bul 'whisper-cli' @($WhisperDir)
    if (-not $cli) {
        Yaz 'Transkript aracı (whisper.cpp, ~5 MB) indiriliyor...' Cyan
        $zip = Join-Path ([IO.Path]::GetTempPath()) ("whisper_{0}.zip" -f (Get-Random))
        $ok = $false
        foreach ($u in $WhisperZip) { if (Indir $u $zip) { $ok = $true; break } }
        if (-not $ok) { throw 'whisper.cpp indirilemedi. İnternet bağlantınızı kontrol edin.' }
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $z = [IO.Compression.ZipFile]::OpenRead($zip)
        try {
            foreach ($e in $z.Entries) {
                if ($e.Name -eq 'whisper-cli.exe' -or $e.Name -like '*.dll') {
                    [IO.Compression.ZipFileExtensions]::ExtractToFile($e, (Join-Path $WhisperDir $e.Name), $true)
                }
            }
        } finally { $z.Dispose() }
        Remove-Item -LiteralPath $zip -Force -ErrorAction SilentlyContinue
        $cli = Arac-Bul 'whisper-cli' @($WhisperDir)
        if (-not $cli) { throw 'whisper-cli.exe arşivde bulunamadı.' }
        Yaz '  [OK] Transkript aracı kuruldu.' Green
    }

    $mevcut = @($Modeller | Where-Object { Test-Path -LiteralPath (Join-Path $WhisperDir $_.Dosya) })
    if ($mevcut.Count -gt 0) { return @{ Cli = $cli; Model = (Join-Path $WhisperDir $mevcut[0].Dosya) } }

    Yaz ''
    Yaz 'Konuşma tanıma modeli gerekiyor (ilk seferde bir kez indirilir):' White
    for ($i = 0; $i -lt $Modeller.Count; $i++) {
        Yaz ("  [{0}] {1}  ({2})" -f ($i + 1), $Modeller[$i].Ad, $Modeller[$i].Boyut)
    }
    $sec = Sor-Sayi 'Seçiminiz [1]' 1 1 $Modeller.Count
    $m = $Modeller[$sec - 1]
    $hedef = Join-Path $WhisperDir $m.Dosya
    $gecici = "$hedef.indiriliyor"
    Yaz "Model indiriliyor: $($m.Dosya)" Cyan
    if (-not (Indir ($ModelUrl + $m.Dosya) $gecici)) {
        Remove-Item -LiteralPath $gecici -Force -ErrorAction SilentlyContinue
        throw 'Model indirilemedi. İnternet bağlantınızı kontrol edin.'
    }
    Move-Item -LiteralPath $gecici -Destination $hedef -Force
    Yaz '  [OK] Model indirildi.' Green
    return @{ Cli = $cli; Model = $hedef }
}

# ---------------------------------------------------------------------------
# Tek parça: ses çıkar -> whisper -> txt + srt
# ---------------------------------------------------------------------------
function Parca-Transkript($parca, $hedefDir, $ayar, $calismaDir) {
    # whisper.cpp Türkçe karakterli yollarda sorun çıkarabildiği için
    # geçici dosyalar yalnızca İngilizce karakterli bir klasörde işlenir
    $wav = Join-Path $calismaDir 'ses.wav'
    $cikti = Join-Path $calismaDir 'cikti'
    Remove-Item -Path "$cikti.*" -Force -ErrorAction SilentlyContinue

    & $script:FFMPEG -hide_banner -loglevel error -y -i $parca.FullName -vn -ac 1 -ar 16000 -c:a pcm_s16le $wav | Out-Host
    if ($LASTEXITCODE -ne 0) { throw "Ses çıkarılamadı: $($parca.Name)" }

    $arg = @('-m', $ayar.Model, '-f', $wav, '-l', $ayar.Dil, '-t', $ayar.Is, '-otxt', '-osrt', '-of', $cikti, '-np')
    & $ayar.Cli @arg | Out-Host   # tanınan metin ekranda canlı görünür
    if ($LASTEXITCODE -ne 0) { throw "Transkript üretilemedi: $($parca.Name)" }

    $ad = [IO.Path]::GetFileNameWithoutExtension($parca.Name)
    $txt = Join-Path $hedefDir "$ad.txt"
    $srt = Join-Path $hedefDir "$ad.srt"
    Move-Item -LiteralPath "$cikti.txt" -Destination $txt -Force
    Move-Item -LiteralPath "$cikti.srt" -Destination $srt -Force
    Remove-Item -LiteralPath $wav -Force -ErrorAction SilentlyContinue
    return $txt
}

function Klasor-Transkript($klasor, $ayar, $calismaDir) {
    $parcalar = @(Get-ChildItem -LiteralPath $klasor.FullName -File |
        Where-Object { $Uzantilar -contains $_.Extension.ToLowerInvariant() } | Sort-Object Name)
    Yaz ''
    Yaz ('=' * 60) Cyan
    Yaz (" {0}   ({1} parça)" -f $klasor.Name, $parcalar.Count) Cyan
    Yaz ('=' * 60) Cyan
    if ($parcalar.Count -eq 0) { Yaz '  Klasörde video parçası yok, atlandı.' Yellow; return }

    $hedefDir = Join-Path $klasor.FullName 'transkript'
    New-Item -ItemType Directory -Force -Path $hedefDir | Out-Null
    $toplu = New-Object System.Text.StringBuilder
    [void]$toplu.AppendLine("TRANSKRİPT: $($klasor.Name)")
    [void]$toplu.AppendLine("Oluşturma: $(Get-Date -Format 'dd.MM.yyyy HH:mm')")
    [void]$toplu.AppendLine('')

    $no = 0
    $sure = [Diagnostics.Stopwatch]::StartNew()
    foreach ($p in $parcalar) {
        $no++
        Yaz ("  [{0}/{1}] {2} ..." -f $no, $parcalar.Count, $p.Name)
        $txt = Parca-Transkript $p $hedefDir $ayar $calismaDir
        $metin = ([IO.File]::ReadAllText($txt, [Text.Encoding]::UTF8)).Trim()
        [void]$toplu.AppendLine("===== $($p.Name) =====")
        [void]$toplu.AppendLine($metin)
        [void]$toplu.AppendLine('')
    }
    $toplam = Join-Path $klasor.FullName ("{0}_transkript.txt" -f $klasor.Name)
    [IO.File]::WriteAllText($toplam, $toplu.ToString(), (New-Object Text.UTF8Encoding $true))
    Yaz ("  [OK] Bitti ({0:mm\:ss} dk). Tüm metin: {1}" -f $sure.Elapsed, $toplam) Green
    Yaz "       Parça parça metin ve altyazılar: $hedefDir" Green
}

# ===========================================================================
# ANA PROGRAM
# ===========================================================================
try { Clear-Host } catch {}
Yaz ('=' * 60) Cyan
Yaz '                  VİDEO TRANSKRİPT ARACI' Cyan
Yaz ('=' * 60) Cyan
Yaz " Klasör: $Arsiv"
Yaz ''

if (-not (Test-Path -LiteralPath $Arsiv)) {
    Yaz 'Arşiv klasörü yok. Önce VideoParcala.bat ile video parçalayın.' Yellow
    return
}

$script:FFMPEG = Arac-Bul 'ffmpeg' @($Kok)
if (-not $script:FFMPEG) { Yaz 'ffmpeg bulunamadı. Önce FFmpegKur.bat dosyasını çalıştırın.' Red; return }

$klasorler = @(Get-ChildItem -LiteralPath $Arsiv -Directory | Sort-Object Name)
if ($klasorler.Count -eq 0) { Yaz 'Arşivde parça klasörü yok. Önce VideoParcala.bat ile video parçalayın.' Yellow; return }

Yaz 'Arşivdeki video klasörleri:' White
for ($i = 0; $i -lt $klasorler.Count; $i++) {
    $var = Test-Path -LiteralPath (Join-Path $klasorler[$i].FullName ("{0}_transkript.txt" -f $klasorler[$i].Name))
    $durum = if ($var) { '  (transkript var)' } else { '' }
    Yaz ("  [{0}] {1}{2}" -f ($i + 1), $klasorler[$i].Name, $durum)
}
Yaz ''
Yaz 'Hangi klasörler? Enter = transkripti olmayanların hepsi,' White
Yaz '0 = hepsi (var olanlar yeniden), veya numaralar (örn: 1 3)' White
$secim = (Read-Host 'Seçiminiz').Trim()
if ($secim -eq '') {
    $islenecek = @($klasorler | Where-Object { -not (Test-Path -LiteralPath (Join-Path $_.FullName ("{0}_transkript.txt" -f $_.Name))) })
} elseif ($secim -eq '0') {
    $islenecek = $klasorler
} else {
    $islenecek = @()
    foreach ($s in ($secim -split '[\s,;]+')) {
        $n = 0
        if ([int]::TryParse($s, [ref]$n) -and $n -ge 1 -and $n -le $klasorler.Count) { $islenecek += $klasorler[$n - 1] }
    }
}
if ($islenecek.Count -eq 0) { Yaz 'İşlenecek klasör yok.' Yellow; return }

Yaz ''
Yaz 'Videoların dili:' White
Yaz '  [1] Türkçe   (varsayılan)'
Yaz '  [2] Otomatik algıla'
Yaz '  [3] İngilizce'
$dil = @('tr', 'auto', 'en')[(Sor-Sayi 'Seçiminiz [1]' 1 1 3) - 1]

try { $kurulum = Whisper-Kur }
catch {
    Yaz ''
    Yaz "[HATA] $($_.Exception.Message)" Red
    return
}
$ayar = [pscustomobject]@{
    Cli   = $kurulum.Cli
    Model = $kurulum.Model
    Dil   = $dil
    Is    = [string][Math]::Max(1, [Environment]::ProcessorCount)
}

$calismaDir = Join-Path ([IO.Path]::GetTempPath()) ("vp_transkript_{0}" -f (Get-Random))
New-Item -ItemType Directory -Force -Path $calismaDir | Out-Null
Yaz ''
Yaz 'Not: Transkript işlemciyi yoğun kullanır; uzun videolarda zaman alabilir.' DarkGray
try {
    foreach ($k in $islenecek) {
        try { Klasor-Transkript $k $ayar $calismaDir }
        catch { Yaz ("  [HATA] {0}: {1}" -f $k.Name, $_.Exception.Message) Red }
    }
} finally {
    Remove-Item -LiteralPath $calismaDir -Recurse -Force -ErrorAction SilentlyContinue
}

Yaz ''
Yaz ('=' * 60) Cyan
Yaz ' Transkript işlemleri tamamlandı.' Cyan
Yaz ('=' * 60) Cyan
try { Start-Process explorer.exe -ArgumentList "`"$Arsiv`"" } catch {}
