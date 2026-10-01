# ⚡ GitHub PAT Cheat Sheet (Tra Cứu Nhanh)

Bản tóm tắt các lệnh và thao tác thông dụng nhất với GitHub Personal Access Token (PAT).

---

## 🚀 1. Các Lệnh Git CLI Phổ Biến

### Push lên Repo bằng Token:
```bash
git push https://<TOKEN>@github.com/<USERNAME>/<REPO>.git <BRANCH>
```

### Clone Repo Private bằng Token:
```bash
git clone https://<TOKEN>@github.com/<USERNAME>/<REPO>.git
```

### Đổi URL Remote có chứa Token:
```bash
git remote set-url origin https://<TOKEN>@github.com/<USERNAME>/<REPO>.git
```

### Đổi lại URL Remote Sạch (Không chứa token):
```bash
git remote set-url origin https://github.com/<USERNAME>/<REPO>.git
```

---

## 🌐 2. Gọi GitHub REST API Nhanh

### Kiểm tra thông tin User:
```bash
curl -H "Authorization: token <TOKEN>" https://api.github.com/user
```

### Kiểm tra giới hạn API Rate Limit:
```bash
curl -H "Authorization: token <TOKEN>" https://api.github.com/rate_limit
```

### Tạo Repo Mới:
```bash
curl -X POST -H "Authorization: token <TOKEN>" \
     -H "Accept: application/vnd.github.v3+json" \
     https://api.github.com/user/repos \
     -d '{"name":"ten-repo-moi", "private":false}'
```

---

## 🎯 3. Phân Biệt Scopes Phổ Biến

| Mục đích | Scope cần tích |
| :--- | :--- |
| **Đẩy code Git bình thường (Phổ biến nhất)** | `repo` |
| **Chỉ đọc/ghi repo public** | `public_repo` |
| **Sửa GitHub Actions Workflow** | `workflow` |
| **Đăng thư viện gói (npm/nuget/docker)** | `write:packages` |
| **Xóa repository** | `delete_repo` |
| **Đọc email / hồ sơ cá nhân** | `user:email`, `read:user` |

---

## 🛡️ 4. Xử Lý Khẩn Cấp Khi Bị Lộ Token

1. Vào ngay: **[https://github.com/settings/tokens](https://github.com/settings/tokens)**
2. Tìm token bị lộ, bấm nút **Delete** màu đỏ.
3. Tạo token mới và cập nhật lại vào các dự án.
