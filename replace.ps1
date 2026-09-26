$content = Get-Content -Path 'c:\acm 2\MarketSphere\frontend\index.html' -Raw
$content = $content -replace '<div class="verdict-status-icon" id="verdict-status-icon">.*?</div>', '<div class="verdict-status-icon" id="verdict-status-icon"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle></svg></div>'
$content = $content -replace '<div class="flow-icon">.*?</div>', '<div class="flow-icon"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="8"></circle></svg></div>'
Set-Content -Path 'c:\acm 2\MarketSphere\frontend\index.html' -Value $content -Encoding UTF8
