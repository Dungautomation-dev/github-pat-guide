# 🔑 Cẩm Nang Toàn Diện Về GitHub Personal Access Token (PAT)

<p align="center">
  <a href="README.md"><b>🇻🇳 Tiếng Việt</b></a> &nbsp;|&nbsp; 
  <a href="README_EN.md"><b>🇺🇸 English</b></a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/GitHub-Personal%20Access%20Token-24292e?style=for-the-badge&logo=github&logoColor=white" alt="GitHub PAT">
  <img src="https://img.shields.io/badge/Security-Best%20Practices-success?style=for-the-badge&logo=shield" alt="Security">
  <img src="https://img.shields.io/badge/Level-All%20Levels-blue?style=for-the-badge" alt="Level">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License">
</p>

<p align="center">
  <strong>Tài liệu hướng dẫn chi tiết từ A-Z về cách tạo, sử dụng, tự động hóa và bảo mật GitHub Personal Access Token (PAT) dành cho lập trình viên và kỹ sư phần mềm.</strong>
</p>

---

## 📑 Mục Lục

- [1. GitHub Personal Access Token (PAT) Là Gì?](#1-github-personal-access-token-pat-là-gì)
  - [Tại sao GitHub bỏ xác thực bằng mật khẩu?](#tại-sao-github-bỏ-xác-thực-bằng-mật-khẩu)
  - [So sánh: Password vs PAT vs SSH Key](#so-sánh-password-vs-pat-vs-ssh-key)
- [2. Phân Loại Token Trên GitHub](#2-phân-loại-token-trên-github)
  - [Personal Access Tokens (Classic)](#personal-access-tokens-classic)
  - [Fine-grained Personal Access Tokens](#fine-grained-personal-access-tokens)
- [3. Hướng Dẫn Tạo Token Chi Tiết Từng Bước](#3-hướng-dẫn-tạo-token-chi-tiết-từng-bước)
  - [Cách tạo Token Classic (Phổ biến & Đơn giản nhất)](#cách-tạo-token-classic-phổ-biến--đơn-giản-nhất)
  - [Bảng tra cứu các quyền (Scopes) quan trọng](#bảng-tra-cứu-các-quyền-scopes-quan-trọng)
- [4. Cách Sử Dụng Token Trong Thực Tế](#4-cách-sử-dụng-token-trong-thực-tế)
  - [4.1. Thao tác với Git CLI (Clone, Push, Pull qua HTTPS)](#41-thao-tác-với-git-cli-clone-push-pull-qua-https)
  - [4.2. Gọi GitHub REST API (cURL, PowerShell, Python)](#42-gọi-github-rest-api-curl-powershell-python)
  - [4.3. Sử dụng trong VS Code & IDE](#43-sử-dụng-trong-vs-code--ide)
- [5. Các Lỗi Thường Gặp & Cách Khắc Phục](#5-các-lỗi-thường-gặp--cách-khắc-phục)
- [6. Nguyên Tắc Bảo Mật Sống Còn (Security Best Practices)](#6-nguyên-tắc-bảo-mật-sống-còn-security-best-practices)
- [7. Công Cụ Hỗ Trợ Kèm Theo Repo](#7-công-cụ-hỗ-trợ-kèm-theo-repo)

---

## 1. GitHub Personal Access Token (PAT) Là Gì?

**GitHub Personal Access Token (PAT)** là một chuỗi ký tự bảo mật được tạo ra để thay thế mật khẩu tài khoản khi bạn thực hiện các thao tác xác thực với GitHub qua:
- Giao thức dòng lệnh Git (Git CLI qua HTTPS).
- Giao diện lập trình ứng dụng (GitHub REST / GraphQL API).
- Các công cụ CI/CD, script tự động hóa, Docker, VS Code...

```
Cấu trúc token Classic:    ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx (40 ký tự)
Cấu trúc token Fine-grain: github_pat_xxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Tại sao GitHub bỏ xác thực bằng mật khẩu?
Từ ngày **13/08/2021**, GitHub đã chính thức ngừng hỗ trợ xác thực bằng mật khẩu tài khoản đối với tất cả các thao tác Git qua HTTPS. Lý do:
1. **Phân quyền chi tiết**: Mật khẩu cho phép truy cập toàn bộ tài khoản; trong khi Token có thể giới hạn chỉ đọc một vài repo hoặc chỉ cấp quyền ghi mã nguồn.
2. **Thời hạn hết hạn (Expiration)**: Mật khẩu tồn tại mãi mãi nếu không đổi; Token có thể cài đặt tự hủy sau 7 ngày, 30 ngày, 90 ngày.
3. **Thu hồi dễ dàng**: Nếu lỡ làm lộ Token, bạn chỉ việc bấm **Revoke** token đó mà không cần đổi mật khẩu gốc tài khoản hay ảnh hưởng đến các ứng dụng khác.

### So sánh: Password vs PAT vs SSH Key

| Tiêu chí | Mật khẩu (Password) | Personal Access Token (PAT) | Khóa SSH (SSH Key) |
| :--- | :---: | :---: | :---: |
| **Hỗ trợ Git CLI hiện nay** | ❌ Bị vô hiệu hóa | ✅ Có (qua HTTPS) | ✅ Có (qua SSH) |
| **Hỗ trợ gọi GitHub API** | ❌ Không | ✅ Hỗ trợ tối đa | ❌ Không trực tiếp |
| **Phân quyền (Scopes)** | ❌ Cấp toàn quyền | ✅ Tùy chỉnh chi tiết | ❌ Toàn quyền tài khoản |
| **Thời hạn hết hạn** | Không có | ✅ Có (tự hủy theo lịch) | Thường vĩnh viễn |
| **Độ tiện lợi khi tự động hóa**| Rất kém | ⭐ Cực kỳ linh hoạt | Tốt cho Server/CI |

---

## 2. Phân Loại Token Trên GitHub

Hiện nay GitHub cung cấp 2 loại Token:

```
                  ┌─────────────────────────────────────────┐
                  │          GitHub Access Tokens           │
                  └────────────────────┬────────────────────┘
                                       │
            ┌──────────────────────────┴──────────────────────────┐
            ▼                                                     ▼
┌───────────────────────────────┐     ┌─────────────────────────────────────────┐
│        Tokens (Classic)       │     │       Fine-grained Tokens (Beta)        │
├───────────────────────────────┤     ├─────────────────────────────────────────┤
│ • Tiền tố: ghp_...            │     │ • Tiền tố: github_pat_...               │
│ • Áp dụng: Toàn bộ tài khoản  │     │ • Áp dụng: Chỉ định repo cụ thể         │
│ • Dễ cấu hình, tương thích cao│     │ • Bảo mật cao nhất, kiểm soát chặt chẽ  │
│ • Khuyên dùng cho cá nhân/tool│     │ • Khuyên dùng cho tổ chức, dự án lớn    │
└───────────────────────────────┘     └─────────────────────────────────────────┘
```

---

## 3. Hướng Dẫn Tạo Token Chi Tiết Từng Bước

### Cách tạo Token Classic (Phổ biến & Đơn giản nhất)

1. **Bước 1**: Đăng nhập GitHub và truy cập trực tiếp đường link:
   👉 **[https://github.com/settings/tokens/new](https://github.com/settings/tokens/new)**
   *(Hoặc: Avatar góc phải ➔ **Settings** ➔ Cuộn xuống cuối chọn **Developer settings** ➔ **Personal access tokens** ➔ **Tokens (classic)** ➔ **Generate new token** ➔ **Generate new token (classic)**)*.
2. **Bước 2**: Nhập thông tin cấu hình:
   - **Note (Tên gợi nhớ)**: Đặt tên cho mục đích sử dụng (ví dụ: `Laptop-Git-Sync`, `Deploy-Script`, `ThiepGiangSinh-Tool`).
   - **Expiration (Thời hạn)**: Chọn thời gian token có hiệu lực (`7 days`, `30 days`, `90 days` hoặc `No expiration`). *Khuyến nghị: 30 hoặc 90 ngày*.
3. **Bước 3**: Chọn phạm vi quyền (**Select scopes**). Tùy nhu cầu mà tích chọn:
   - Nếu bạn dùng để **push/pull code git bình thường**, chỉ cần tích chọn ô **`repo`** (sẽ tự bao gồm quyền ghi, đọc repo public và private).
4. **Bước 4**: Cuộn xuống đáy trang và bấm nút xanh **Generate token**.
5. **Bước 5**: **LƯU LẠI TOKEN NGAY LẬP TỨC**!
   > [!IMPORTANT]
   > GitHub **chỉ hiển thị mã token này duy nhất một lần**. Khi bạn tải lại trang hoặc rời đi, bạn sẽ không bao giờ xem lại được chuỗi token đó nữa. Hãy copy và lưu vào trình quản lý mật khẩu an toàn.

---

### Bảng tra cứu các quyền (Scopes) quan trọng

| Tên Scope | Mô tả quyền hạn | Khi nào cần dùng? |
| :--- | :--- | :--- |
| **`repo`** | Toàn quyền kiểm soát repositories (public & private) | **Bắt buộc** khi dùng Git clone/push/pull code cá nhân |
| **`public_repo`** | Chỉ kiểm soát các repo công khai (không chạm vào repo riêng tư) | Khi dùng tool mã nguồn mở hoặc bot chỉ tương tác public repo |
| **`workflow`** | Quản lý và chỉnh sửa GitHub Actions workflows (`.github/workflows/`) | Khi dự án của bạn có các luồng CI/CD tự động |
| **`write:packages`** | Đẩy package lên GitHub Packages Registry | Khi publish thư viện npm, nuget, docker image lên GitHub |
| **`delete_repo`** | Cho phép xóa repository | Chỉ cấp khi bạn viết script dọn dẹp/xóa repo tự động |
| **`read:user` / `user:email`** | Đọc thông tin hồ sơ và email tài khoản | Khi làm chức năng "Đăng nhập bằng GitHub" |
| **`gist`** | Tạo và chỉnh sửa GitHub Gist | Khi muốn lưu trữ code snippet nhanh |

---

## 4. Cách Sử Dụng Token Trong Thực Tế

### 4.1. Thao tác với Git CLI (Clone, Push, Pull qua HTTPS)

#### Cách 1: Đẩy code trực tiếp kèm Token trong URL (Nhanh nhất cho Script)
```bash
# Cú pháp tổng quát:
git push https://<TOKEN>@github.com/<USERNAME>/<REPO_NAME>.git <BRANCH>

# Ví dụ thực tế:
git push https://ghp_YourSecretTokenExample1234567890@github.com/Dungauto/my-project.git main
```

#### Cách 2: Clone repository private bằng Token
```bash
git clone https://<TOKEN>@github.com/<USERNAME>/<REPO_NAME>.git
```

#### Cách 3: Đăng nhập vào Git Credential Manager của Windows
Khi bạn chạy `git push origin main` trong Terminal và cửa sổ yêu cầu nhập tài khoản:
- **Username**: Nhập tên tài khoản GitHub của bạn (ví dụ: `Dungauto`).
- **Password**: Dán chính **chuỗi Token (ghp_...)** vào ô mật khẩu.

#### Cách 4: Cập nhật URL Remote có sẵn
```bash
# Gắn token vào remote origin:
git remote set-url origin https://<TOKEN>@github.com/<USERNAME>/<REPO_NAME>.git

# Trả lại URL sạch (không lộ token trong cấu hình máy):
git remote set-url origin https://github.com/<USERNAME>/<REPO_NAME>.git
```

---

### 4.2. Gọi GitHub REST API (cURL, PowerShell, Python)

GitHub API yêu cầu truyền token qua HTTP Header: `Authorization: Bearer <TOKEN>` hoặc `Authorization: token <TOKEN>`.

#### 🔹 Bằng cURL:
```bash
# Lấy thông tin tài khoản của bạn:
curl -H "Authorization: token ghp_your_token_here" \
     https://api.github.com/user

# Tạo một repository mới tự động:
curl -X POST \
     -H "Authorization: token ghp_your_token_here" \
     -H "Accept: application/vnd.github.v3+json" \
     https://api.github.com/user/repos \
     -d '{"name":"my-awesome-repo","private":false,"description":"Repo created via API"}'
```

#### 🔹 Bằng PowerShell:
```powershell
$token = "ghp_your_token_here"
$headers = @{
    "Authorization" = "token $token"
    "Accept"        = "application/vnd.github.v3+json"
}

# Lấy danh sách repositories của tài khoản:
$repos = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Headers $headers
$repos | Select-Object name, html_url, private
```

#### 🔹 Bằng Python:
```python
import requests

TOKEN = "ghp_your_token_here"
headers = {
    "Authorization": f"token {TOKEN}",
    "Accept": "application/vnd.github.v3+json"
}

response = requests.get("https://api.github.com/user", headers=headers)
user_data = response.json()
print("Xin chào:", user_data.get("login"))
```

---

### 4.3. Sử dụng trong VS Code & IDE

1. Nhấn `Ctrl + Shift + P` (hoặc `Cmd + Shift + P` trên Mac).
2. Gõ `Git: Clone` và dán URL repository.
3. Nếu VS Code hỏi thông tin xác thực, dán chuỗi Token vào ô mật khẩu.

---

## 5. Các Lỗi Thường Gặp & Cách Khắc Phục

### ❌ Lỗi 1: `Support for password authentication was removed on August 13, 2021`
- **Nguyên nhân**: Bạn đang nhập mật khẩu đăng nhập tài khoản thay vì chuỗi Personal Access Token.
- **Khắc phục**: Tạo PAT theo hướng dẫn ở Mục 3, sau đó nhập mã `ghp_...` vào ô password.

### ❌ Lỗi 2: `remote: Permission to <User/Repo> denied to <User>` hoặc `403 Forbidden`
- **Nguyên nhân**: Token của bạn thiếu quyền (Scope). Thường là bạn chưa tích chọn ô **`repo`** khi tạo token.
- **Khắc phục**: 
  1. Vào [github.com/settings/tokens](https://github.com/settings/tokens).
  2. Bấm vào tên token cần sửa.
  3. Tích thêm ô `repo` rồi bấm **Update token**.

### ❌ Lỗi 3: `Bad credentials` (401 Unauthorized)
- **Nguyên nhân**: Chuỗi token bị sai ký tự, bị thiếu ký tự khi copy, hoặc token đã **hết hạn (expired)**.
- **Khắc phục**: Kiểm tra ngày hết hạn của token trên GitHub. Nếu đã hết hạn, bấm **Regenerate token** để nhận mã mới.

---

## 6. Nguyên Tắc Bảo Mật Sống Còn (Security Best Practices)

> [!CAUTION]
> **Token có quyền lực tương đương chìa khóa nhà bạn!** Bất kỳ ai có token quyền `repo` đều có thể tải xuống toàn bộ code bí mật hoặc xóa repository của bạn.

Tuân thủ nghiêm ngặt 5 nguyên tắc sau:

1. **Tuyệt đối KHÔNG commit Token vào Git**:
   - Không viết cứng token vào file code (`.js`, `.cs`, `.py`, `.html`).
   - Luôn thêm file `.env`, file config chứa token vào `.gitignore`.
2. **Nguyên tắc quyền tối thiểu (Least Privilege)**:
   - Cần quyền gì thì chỉ tích đúng quyền đó. Đừng bao giờ tích chọn tất cả các ô nếu không thực sự cần.
3. **Đặt thời hạn ngắn (Expiration)**:
   - Nên đặt thời hạn 30 - 90 ngày. Tránh chọn `No expiration` trừ trường hợp hệ thống tự động chạy ngầm đặc biệt.
4. **Dùng biến môi trường (Environment Variables)**:
   - Lưu token vào biến hệ điều hành (ví dụ: `GITHUB_TOKEN`) thay vì ghi ra văn bản rõ ràng.
5. **Thu hồi (Revoke) ngay lập tức khi nghi ngờ bị lộ**:
   - Nếu bạn lỡ commit token lên GitHub công khai, bot của GitHub sẽ cảnh báo *(Secret Scanning)*.
   - Hãy truy cập ngay [github.com/settings/tokens](https://github.com/settings/tokens) và bấm nút **Delete** cạnh token đó!

---

## 7. Công Cụ Hỗ Trợ Kèm Theo Repo

Trong thư mục [`scripts/`](file:///scripts/), repo này cung cấp sẵn các tiện ích:

- 🛠️ **[`scripts/test-token.ps1`](file:///scripts/test-token.ps1)**: Script PowerShell giúp kiểm tra tính hợp lệ của token, đọc danh sách quyền (scopes) và ngày hết hạn mà không làm lộ token.
- 📋 **[`CHEAT-SHEET.md`](file:///CHEAT-SHEET.md)**: Bảng tóm tắt nhanh 1 trang dành cho người bận rộn.

---

## 👨‍💻 Tác Giả & Đóng Góp

- **Tác giả**: [Dung Automation](https://github.com/Dungauto)
- **Email**: dungautomation@gmail.com
- **Giấy phép**: Phát hành miễn phí dưới giấy phép [MIT License](LICENSE).

<p align="center">
  ⭐ <em>Nếu tài liệu này hữu ích với bạn, đừng quên bấm Star cho repository nhé!</em> ⭐
</p>
