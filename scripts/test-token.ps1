<#
.SYNOPSIS
    Script kiểm tra tính hợp lệ và quyền hạn của GitHub Personal Access Token (PAT).
.DESCRIPTION
    Script gọi GitHub REST API để xác thực token, đọc danh sách scopes và hạn mức rate limit
    mà không lưu trữ hay ghi log token ra ngoài.
.EXAMPLE
    .\test-token.ps1
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "    CÔNG CỤ KIỂM TRA GITHUB PERSONAL ACCESS TOKEN (PAT)   " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$tokenInput = Read-Host "Nhập GitHub Token của bạn (ghp_...)" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($tokenInput)
$token = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

if ([string]::IsNullOrWhiteSpace($token)) {
    Write-Host "[LỖI] Bạn chưa nhập token!" -ForegroundColor Red
    exit
}

Write-Host "Đang kết nối tới GitHub API..." -ForegroundColor Gray

$headers = @{
    "Authorization" = "token $token"
    "User-Agent"    = "PowerShell-GitHub-PAT-Tester"
    "Accept"        = "application/vnd.github.v3+json"
}

try {
    $response = Invoke-WebRequest -Uri "https://api.github.com/user" -Headers $headers -UseBasicParsing
    $userData = $response.Content | ConvertFrom-Json
    
    # Đọc scopes từ response headers
    $scopes = $response.Headers["X-OAuth-Scopes"]
    $rateLimitRemaining = $response.Headers["X-RateLimit-Remaining"]
    $rateLimitTotal = $response.Headers["X-RateLimit-Limit"]

    Write-Host ""
    Write-Host "✔ TOKEN HỢP LỆ!" -ForegroundColor Green
    Write-Host "----------------------------------------------------------"
    Write-Host "• Tài khoản:       $($userData.login) ($($userData.name))" -ForegroundColor White
    Write-Host "• Email:           $($userData.email)" -ForegroundColor White
    Write-Host "• Số repo Public:  $($userData.public_repos)" -ForegroundColor White
    Write-Host "• Danh sách quyền: $scopes" -ForegroundColor Yellow
    Write-Host "• API Rate Limit:  $rateLimitRemaining / $rateLimitTotal" -ForegroundColor White
    Write-Host "----------------------------------------------------------"
    Write-Host "Token này đã sẵn sàng sử dụng cho Git và API!" -ForegroundColor Green
}
catch {
    Write-Host ""
    Write-Host "✖ TOKEN KHÔNG HỢP LỆ HOẶC ĐÃ HẾT HẠN!" -ForegroundColor Red
    Write-Host "Chi tiết lỗi: $($_.Exception.Message)" -ForegroundColor DarkRed
}
